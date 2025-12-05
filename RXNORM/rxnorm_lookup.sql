CREATE
OR REPLACE TABLE ndc_rxnorm_lookup AS
WITH ndc_raw AS (
    SELECT
        DISTINCT LPAD(TRIM(atv), 11, '0') AS ndc,
        r.rxcui,
        r.rxaui,
        r.sab
    FROM
        NIH_rxnsat r
    WHERE
        r.atn = 'NDC'
),
best_sab AS (
    SELECT
        ndc,
        rxcui,
        rxaui,
        sab,
        ROW_NUMBER() OVER (
            PARTITION BY ndc
            ORDER BY
                CASE
                    sab
                    WHEN 'RXNORM' THEN 1
                    WHEN 'MMSL' THEN 2
                    WHEN 'NDDF' THEN 3
                    ELSE 9
                END
        ) AS rn
    FROM
        ndc_raw
),
conso AS (
    -- Join via RXAUI to get the exact product the NDC points to
    SELECT
        b.ndc,
        b.rxcui,
        c.rxaui,
        c.tty,
        c.str
    FROM
        best_sab b
        JOIN NIH_rxnconso c ON b.rxaui = c.rxaui
    WHERE
        b.rn = 1 -- only keep preferred SAB per NDC
),
best_tty AS (
    SELECT
        ndc,
        rxcui,
        rxaui,
        tty,
        str,
        ROW_NUMBER() OVER (
            PARTITION BY ndc
            ORDER BY
                CASE
                    tty
                    WHEN 'SBDG' THEN 5
                    WHEN 'SBDP' THEN 6
                    WHEN 'BPCK' THEN 7
                    WHEN 'GPCK' THEN 8
                    WHEN 'PSN' THEN 3
                    WHEN 'SBD' THEN 1
                    WHEN 'SCD' THEN 2
                    WHEN 'BN' THEN 4
                    WHEN 'IN' THEN 9
                    ELSE 90
                END
        ) AS rn
    FROM
        conso
)
SELECT
    ndc,
    rxcui,
    rxaui,
    tty AS best_tty,
    str AS best_description
FROM
    best_tty
WHERE
    rn = 1
    --and best_description is null
    --and ndc in ('00074055402', '63868094210', '55111015810', '66993001968')
ORDER BY
    ndc;

    select * from ndc_rxnorm_lookup where best_description is null;

  