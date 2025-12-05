CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMARCY_CLAIMS_ENRICHED AS 
WITH claim_level AS (
    SELECT
        pc.claim_id,
        pc.person_id,
        pc.family_id,
        pc.ndc_nbr_cd,
        case 
        when pc.sex_cd = 'F' then 'Female'
        when pc.sex_cd = 'M' then 'Male'
        else 'Undisclosed' end as Gender,
        pc.age_years,
        CASE
      WHEN pc.age_years < 18 THEN '0-17'
      WHEN pc.age_years BETWEEN 18 AND 34 THEN '18-34'
      WHEN pc.age_years BETWEEN 35 AND 49 THEN '35-49'
      WHEN pc.age_years BETWEEN 50 AND 64 THEN '50-64'
      ELSE '65+'
    END AS age_group,
        pc.ordering_prov_id as npi,
        /* PROVIDER NAME LOGIC */
        CASE 
            WHEN npi.entity_type_code = '1' THEN
                CONCAT(
                    COALESCE(npi.provider_last_name, ''),
                    ', ',
                    COALESCE(npi.provider_first_name, ''),
                    ' ',
                    COALESCE(npi.provider_credential_text, '')
                )
            WHEN npi.entity_type_code = '2' THEN
                COALESCE(npi.provider_organization_name, '')
        END AS provider_name,
        npi.provider_business_mailing_address_city_name AS provider_city,
        npi.provider_business_mailing_address_state_name AS provider_state,
        substring(npi.provider_business_mailing_address_postal_code,1,5) AS provider_zip,
        MIN(pc.paid_dt) AS paid_dt,
        SUM(pc.net_pay_amt) AS final_net_pay_amt
    FROM DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMACY_CLAIMS pc
    LEFT JOIN DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.NPI_LOOKUP_FINAL npi
        ON pc.ordering_prov_id = npi.npi
    GROUP BY pc.claim_id,
        pc.person_id,
        pc.family_id,
        pc.ndc_nbr_cd,
        Gender,
        pc.age_years,
        age_group,
        pc.ordering_prov_id,
        npi.entity_type_code,
        npi.provider_last_name,
        npi.provider_first_name,
        npi.provider_credential_text,
        npi.provider_organization_name,
        npi.provider_business_mailing_address_city_name,
        npi.provider_business_mailing_address_state_name,
        substring(npi.provider_business_mailing_address_postal_code,1,5)
),
filtered_claims AS (
    SELECT *
    FROM claim_level
    WHERE final_net_pay_amt <> 0
),
description_clean AS (
    SELECT 
        fc.*,
        rx.best_description,
        
        -- Normalize brackets
        REPLACE(REPLACE(rx.best_description,'［','['),'］',']') AS desc_norm,

        -- Extract first bracketed brand name
        REPLACE(
            REPLACE(
                REGEXP_SUBSTR(
                    REPLACE(REPLACE(rx.best_description,'［','['),'］',']'),
                    '\\[([^\\]]+)\\]'
                ),
            '[',''),
        ']','') AS brand_name_raw,

        -- Extract generic (fallback)
        REGEXP_REPLACE(
            LOWER(
                REGEXP_REPLACE(
                    rx.best_description,
                    '(\\d+\\.?\\d*\\s*(mg|mcg|g|ml|%)|oral|topical|inhalation|solution|capsule|tablet|pack|kit|drop|syrup|suspension)',
                    ''
                )
            ),
        '\\s+', ' ') AS generic_name_raw
        
    FROM filtered_claims fc
    LEFT JOIN DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.NDC_RXNORM_LOOKUP rx
        ON fc.ndc_nbr_cd = rx.ndc
),
canon AS (
    SELECT
        *,
        INITCAP(brand_name_raw) AS brand_name,
        INITCAP(generic_name_raw) AS generic_name,
        CASE
            WHEN brand_name_raw IS NOT NULL THEN INITCAP(brand_name_raw)
            WHEN generic_name_raw IS NOT NULL THEN INITCAP(generic_name_raw)
            ELSE 'Not a drug (Lancets, etc)'
        END AS canonical_drug_name
    FROM description_clean
)
SELECT 
    c.claim_id,
    c.person_id,
    c.family_id,
    c.ndc_nbr_cd,
    c.gender,
    c.age_years,
    c.age_group,
    c.npi,
    c.provider_name,
    c.provider_city,
    c.provider_state,
    c.provider_zip,
    c.paid_dt,
    c.final_net_pay_amt,
    cal.fiscal_year,
    cal.fy_quarter,
    cal.fy_month,
    cal.fy_and_month_sort,
    cal.longmonth,
    cal.month_abbrev,
    c.best_description,
    c.brand_name,
    c.generic_name,
    c.canonical_drug_name,
    md5(c.claim_id||c.person_id||c.ndc_nbr_cd) as claim_hash
FROM canon c
LEFT JOIN DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.CALENDAR cal
    ON c.paid_dt = cal.date;

CREATE OR REPLACE VIEW DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMACY_CLAIMS_FY_YOY_SUMMARY AS  WITH base AS (
    SELECT
        canonical_drug_name,
        fiscal_year,
        SUM(final_net_pay_amt) AS spend,
        COUNT(distinct claim_id) AS claims,
        round(SUM(final_net_pay_amt)/COUNT(distinct claim_id),2) avg_cost_per_claim
    FROM DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMARCY_CLAIMS_ENRICHED
    GROUP BY 1,2
),

/* =======================================================================
   1. ALL-TIME METRICS (collapse across all fiscal years)
   ======================================================================= */
all_time AS (
    SELECT
        canonical_drug_name,
        SUM(spend)  AS all_time_spend,
        SUM(claims) AS all_time_claims
    FROM base
    GROUP BY canonical_drug_name
),

all_time_ranks AS (
    SELECT
        a.*,
        RANK() OVER (ORDER BY all_time_spend DESC)  AS all_time_spend_rank,
        RANK() OVER (ORDER BY all_time_claims DESC) AS all_time_claims_rank
    FROM all_time a
),

/* =======================================================================
   2. FY-level Ranks
   ======================================================================= */
with_FY_ranks AS (
    SELECT
        b.*,
        RANK() OVER (
            PARTITION BY fiscal_year ORDER BY spend DESC
        ) AS fy_spend_rank,
        RANK() OVER (
            PARTITION BY fiscal_year ORDER BY claims DESC
        ) AS fy_claims_rank
    FROM base b
),

/* =======================================================================
   3. YoY Changes
   ======================================================================= */
with_yoy AS (
    SELECT
        r.*,

        LAG(spend)  OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) AS prior_year_spend,
        LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) AS prior_year_claims,

        CASE 
            WHEN LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (spend - LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year)) 
                / NULLIF(LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year), 0) * 100,
                2
            )
        END AS yoy_spend_pct,

        CASE 
            WHEN LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (claims - LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year)) 
                / NULLIF(LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year), 0) * 100,
                2
            )
        END AS yoy_claims_pct,
    /* YoY % change for avg cost per claim */
        CASE 
            WHEN LAG(avg_cost_per_claim) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(avg_cost_per_claim) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (avg_cost_per_claim 
                    - LAG(avg_cost_per_claim) OVER (
                        PARTITION BY canonical_drug_name ORDER BY fiscal_year
                      )
                )
                / NULLIF(
                    LAG(avg_cost_per_claim) OVER (
                        PARTITION BY canonical_drug_name ORDER BY fiscal_year
                    ), 0
                ) * 100,
                2
            )
        END AS yoy_avg_cost_pct
    FROM with_FY_ranks r
),

/* =======================================================================
   4. Top 10 Flags
   ======================================================================= */
with_top10_flags AS (
    SELECT
        y.*,
        CASE WHEN fy_spend_rank  <= 10 THEN 1 ELSE 0 END AS fy_top10_spend_flag,
        CASE WHEN fy_claims_rank <= 10 THEN 1 ELSE 0 END AS fy_top10_claims_flag
    FROM with_yoy y
)

/* =======================================================================
   5. FINAL MERGE: Add all-time totals + ranks
   ======================================================================= */
SELECT
    f.*,
    a.all_time_spend,
    a.all_time_claims,
    a.all_time_spend_rank,
    a.all_time_claims_rank
FROM with_top10_flags f
LEFT JOIN all_time_ranks a
    ON f.canonical_drug_name = a.canonical_drug_name
ORDER BY canonical_drug_name, fiscal_year;


SELECT *
FROM with_all_time where canonical_drug_name='Ozempic' order by fiscal_year;



/*=======================================================================
View providing fiscal year–level pharmacy claim aggregations, including total spend, 
total claims, year-over-year metrics, average cost per claim, and fiscal-year rankings. 
This view is designed for analytics and dashboarding and contains one row per
 canonical drug per fiscal year with precomputed KPIs such as YOY percent 
 changes, top-10 fiscal year flags, and all-time ranks.
=======================================================================*/
create or replace table DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMACY_CLAIMS_FY_RANKINGS_SUMMARY AS 

WITH base AS (
    SELECT
        CANONICAL_DRUG_NAME,
        FISCAL_YEAR,
        COUNT(DISTINCT claim_id) AS total_claims,
        SUM(FINAL_NET_PAY_AMT) AS total_final_net_pay,
        round(SUM(FINAL_NET_PAY_AMT)/COUNT(DISTINCT claim_id),2) AS avg_final_net_pay
    FROM DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMARCY_CLAIMS_ENRICHED
    GROUP BY CANONICAL_DRUG_NAME, FISCAL_YEAR
),

ranks AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY fiscal_year
            ORDER BY total_final_net_pay DESC
        ) AS yearly_total_paid_rank,
        RANK() OVER (
            PARTITION BY fiscal_year
            ORDER BY total_claims DESC
        ) AS yearly_total_CLAIMS_rank,
        lag(total_claims) over (partition by CANONICAL_DRUG_NAME order by fiscal_year) as previous_year_total_claims,
        lag(total_final_net_pay) over (partition by CANONICAL_DRUG_NAME order by fiscal_year) as previous_year_total_final_net_pay
    FROM base
)
SELECT
    b.CANONICAL_DRUG_NAME,
    b.fiscal_year,
    b.total_claims,
    b.total_final_net_pay,
    b.avg_final_net_pay,
    r.yearly_total_paid_rank,
    lag(r.yearly_total_paid_rank) over (partition by b.CANONICAL_DRUG_NAME order by b.fiscal_year) as previous_year_total_paid_rank,
    lag(r.yearly_total_paid_rank) over (partition by b.CANONICAL_DRUG_NAME order by b.fiscal_year) - r.yearly_total_paid_rank as yearly_total_paid_rank_change,
    lag(r.yearly_total_CLAIMS_rank) over (partition by b.CANONICAL_DRUG_NAME order by b.fiscal_year) as previous_year_total_CLAIMS_rank,
    lag(r.yearly_total_CLAIMS_rank) over (partition by b.CANONICAL_DRUG_NAME order by b.fiscal_year) - r.yearly_total_CLAIMS_rank as yearly_total_CLAIMS_rank_change,
    R.yearly_total_CLAIMS_rank,
    r.previous_year_total_claims,
    r.previous_year_total_final_net_pay,
   ((b.total_claims-r.previous_year_total_claims)/r.previous_year_total_claims) as yoy_total_claims_pct,
   ((b.total_final_net_pay-r.previous_year_total_final_net_pay)/r.previous_year_total_final_net_pay) as yoy_total_final_net_pay_pct
FROM base b
JOIN ranks r
  ON r.CANONICAL_DRUG_NAME = b.CANONICAL_DRUG_NAME
 AND r.fiscal_year = b.fiscal_year
ORDER BY CANONICAL_DRUG_NAME, FISCAL_YEAR ;


/* ---------------------------------------------------------------------------
VIEW:      PHARMACY_CLAIMS_FY_YOY_SUMMARY
PURPOSE:   Fiscal Year–level summary of Spend, Claims, Avg Cost per Claim,
           YoY changes, and top-drug rankings.
GRAIN:     canonical_drug_name, fiscal_year
NOTES:     For FY-only dashboards. Do not add month/quarter or the math breaks.
--------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMACY_CLAIMS_FY_YOY_SUMMARY AS  WITH base AS (
    SELECT
        canonical_drug_name,
        fiscal_year,
        SUM(final_net_pay_amt) AS spend,
        COUNT(distinct claim_id) AS claims,
        round(SUM(final_net_pay_amt)/COUNT(distinct claim_id),2) avg_cost_per_claim
    FROM DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMARCY_CLAIMS_ENRICHED
    GROUP BY 1,2
),

/* =======================================================================
   1. ALL-TIME METRICS (collapse across all fiscal years)
   ======================================================================= */
all_time AS (
    SELECT
        canonical_drug_name,
        SUM(spend)  AS all_time_spend,
        SUM(claims) AS all_time_claims
    FROM base
    GROUP BY canonical_drug_name
),

all_time_ranks AS (
    SELECT
        a.*,
        RANK() OVER (ORDER BY all_time_spend DESC)  AS all_time_spend_rank,
        RANK() OVER (ORDER BY all_time_claims DESC) AS all_time_claims_rank
    FROM all_time a
),

/* =======================================================================
   2. FY-level Ranks
   ======================================================================= */
with_FY_ranks AS (
    SELECT
        b.*,
        RANK() OVER (
            PARTITION BY fiscal_year ORDER BY spend DESC
        ) AS fy_spend_rank,
        RANK() OVER (
            PARTITION BY fiscal_year ORDER BY claims DESC
        ) AS fy_claims_rank
    FROM base b
),

/* =======================================================================
   3. YoY Changes
   ======================================================================= */
with_yoy AS (
    SELECT
        r.*,

        LAG(spend)  OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) AS prior_year_spend,
        LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) AS prior_year_claims,

        CASE 
            WHEN LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (spend - LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year)) 
                / NULLIF(LAG(spend) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year), 0) ,
                2
            )
        END AS yoy_spend_pct,

        CASE 
            WHEN LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (claims - LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year)) 
                / NULLIF(LAG(claims) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year), 0) ,
                2
            )
        END AS yoy_claims_pct,
    /* YoY % change for avg cost per claim */
        CASE 
            WHEN LAG(avg_cost_per_claim) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) IS NULL THEN NULL
            WHEN LAG(avg_cost_per_claim) OVER (PARTITION BY canonical_drug_name ORDER BY fiscal_year) = 0 THEN NULL
            ELSE ROUND(
                (avg_cost_per_claim 
                    - LAG(avg_cost_per_claim) OVER (
                        PARTITION BY canonical_drug_name ORDER BY fiscal_year
                      )
                )
                / NULLIF(
                    LAG(avg_cost_per_claim) OVER (
                        PARTITION BY canonical_drug_name ORDER BY fiscal_year
                    ), 0
                ) ,
                2
            )
        END AS yoy_avg_cost_pct
    FROM with_FY_ranks r
),

/* =======================================================================
   4. Top 10 Flags
   ======================================================================= */
with_top10_flags AS (
    SELECT
        y.*,
        CASE WHEN fy_spend_rank  <= 10 THEN 1 ELSE 0 END AS fy_top10_spend_flag,
        CASE WHEN fy_claims_rank <= 10 THEN 1 ELSE 0 END AS fy_top10_claims_flag
    FROM with_yoy y
)

/* =======================================================================
   5. FINAL MERGE: Add all-time totals + ranks
   ======================================================================= */
SELECT
    f.*,
    a.all_time_spend,
    a.all_time_claims,
    a.all_time_spend_rank,
    a.all_time_claims_rank
FROM with_top10_flags f
LEFT JOIN all_time_ranks a
    ON f.canonical_drug_name = a.canonical_drug_name
ORDER BY canonical_drug_name, fiscal_year;


SELECT fiscal_year, sum(spend), sum(claims), sum(spend)/sum(claims)
FROM DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.PHARMACY_CLAIMS_FY_YOY_SUMMARY 
--where canonical_drug_name='Ozempic'
group by fiscal_year
order by fiscal_year;


select file_name, max(paid_dt) from pharmacy_claims group by 1 order by 2 nulls last;




