USE DATABASE das;

USE SCHEMA das_healthcare_claims_raw_db;

USE ROLE das_dlk_das_healthcare_claims_do_grp;

CREATE OR REPLACE TABLE TEMP_MRCONSO_MRREL_RELATIONSHIPS_LOOKUP as WITH
    concept AS (
        SELECT
            INITCAP(b.str) AS related_from,
            a.rela AS relation,
            a.sab,
            c.str as related_to,
             c.code AS related_to_code,
            a.cui1 AS related_to_cui,
             c.sab as dictionary,
             c.tty as term_type,
            b.code AS related_from_code,
            a.cui2 AS related_from_cui,
            ROW_NUMBER() OVER (
            PARTITION BY a.CUI1 , a.sab
            ORDER BY l.rank_weight ASC    --lower = more preferred
        ) AS rn
        FROM
            mrrel a
            JOIN mrconso b ON a.cui2 = b.cui
            JOIN TEMP_MRCONSO_MRREL_RELATIONSHIPS_LOOKUP L 
            ON A.SAB = L.SAB
            AND B.SAB = L.SAB 
            AND B.TTY = L.TTY
            JOIN mrconso c 
            ON a.cui1 = c.cui
            AND a.sab = c.sab
        WHERE
            a.cui2 = 'C4535015'
            AND a.rela IS NOT NULL
    )
SELECT
    *
FROM
    concept
    WHERE RN=1;

