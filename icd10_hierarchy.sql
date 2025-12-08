CREATE
    OR REPLACE TABLE temp_umls_icd10 AS WITH base AS (
        SELECT
            CUI,
            AUI,
            CXN,
            PAUI,
            RELA,
            SAB,
            HCD,
            CVF,
            CONCAT(PTR, '.', AUI) AS full_ptr
        FROM
            MRHIER
        WHERE
            RELA = 'ICD10CM' -- FIXED FILTER
    ),
    split AS (
        SELECT
            *,
            SPLIT(full_ptr, '.') AS ptr_array
        FROM
            base
    ),
    flat AS (
        SELECT
            b.CUI,
            b.AUI,
            b.CXN,
            b.PAUI,
            b.RELA,
            b.SAB,
            b.HCD,
            b.CVF,
            b.full_ptr,
            f.index AS hier_index,
            f.value::string AS hier_aui
        FROM
            split b,
            LATERAL FLATTEN(input => b.ptr_array) f
    ),
    ranked_terms AS (
        SELECT
            AUI,
            CUI,
            CODE,
            STR,
            TTY,
            ROW_NUMBER() OVER (
                PARTITION BY AUI
                ORDER BY
                CASE TS WHEN 'P' THEN 1 ELSE 2 END,
                    CASE
                        TTY
                        WHEN 'PT' THEN 1
                        WHEN 'HT' THEN 2
                        WHEN 'SY' THEN 3
                        ELSE 9
                    END
            ) AS rn
        FROM
            MRCONSO
        WHERE
            SAB = 'ICD10CM'
    )
SELECT
    f.CUI,
    f.AUI,
    f.CXN,
    f.PAUI,
    f.RELA,
    f.full_ptr,
    f.hier_index,
    f.hier_aui,
    rt.CODE AS icd10_code,
    REPLACE(rt.CODE, '.', '') AS icd10_code_hc,
    rt.STR AS description,
    rt.TTY AS term_type_used,
    RT.RN
FROM
    flat f
    LEFT JOIN ranked_terms rt ON rt.AUI = f.hier_aui
    AND rt.rn = 1
ORDER BY
    CUI,
    hier_index;