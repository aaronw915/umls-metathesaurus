create or replace view ndc_lookup_v as 
WITH raw_data AS (
    SELECT
        sat.rxcui,
        sat.rxaui,
        sat.atv AS ndc,
        rxc.str AS description,    
        rxc.sab,
        rxc.tty,
        sat.suppress
    FROM
        rxnsat sat
    JOIN 
        rxnconso rxc 
        ON rxc.rxcui = sat.rxcui
        AND sat.sab = 'RXNORM'
        AND sat.atn = 'NDC'
    WHERE 
        rxc.sab = sat.sab
),
ranked_data AS (
    SELECT
        rd.*,
        ROW_NUMBER() OVER (
            PARTITION BY rd.ndc
            ORDER BY
                -- Assign a numeric priority based on the executive management ranking:
                -- PSN (1) > SCD (2) > SBD (3) > GPCK (4) > BPCK (5) > SY (6) > TMSY (7)
                CASE rd.tty
                    WHEN 'PSN' THEN 1
                    WHEN 'SCD' THEN 2
                    WHEN 'SBD' THEN 3
                    WHEN 'GPCK' THEN 4
                    WHEN 'BPCK' THEN 5
                    WHEN 'SY' THEN 6
                    WHEN 'TMSY' THEN 7
                    -- Assign a low priority to any other TTY not explicitly ranked
                    ELSE 99 
                END ASC,
                rd.description ASC -- Use description alphabetically as a tie-breaker
        ) AS rnk
    FROM
        raw_data rd
)
-- Select only the rows where the rank is 1 (the highest priority description for that NDC)
SELECT
    rxcui,
    ndc,
    description,
    tty
FROM
    ranked_data
WHERE
    rnk = 1
ORDER BY
    ndc;
