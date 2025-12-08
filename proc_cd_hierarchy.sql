create or replace table temp_umls_proc_cd as WITH base AS (
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
        FROM MRHIER
        WHERE RELA IN('HCPCS', 'CPT')
    ),
    split AS (
        SELECT *,
               SPLIT(full_ptr, '.') AS ptr_array
        FROM base
    ),
    flat AS (
        SELECT
            b.CUI,
            b.AUI,
            b.CXN,
            b.PAUI,
            b.SAB,
            b.RELA,
            b.HCD,
            b.CVF,
            b.full_ptr,
            f.index AS hier_index,
            f.value::string AS hier_aui
        FROM split b,
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
        CASE 
            -- CPT
            WHEN SAB='CPT' AND TTY='PT' THEN 1
            WHEN SAB='CPT' AND TTY='HT' THEN 2
            WHEN SAB='CPT' AND TTY='SY' THEN 3
            WHEN SAB='CPT' AND TTY='MP' THEN 4
            WHEN SAB='CPT' AND TTY='POS' THEN 5
            WHEN SAB='CPT' AND TTY='GLP' THEN 6
            WHEN SAB='CPT' AND TTY='AB' THEN 7
            WHEN SAB='CPT' AND TTY='ETCF' THEN 8
            WHEN SAB='CPT' AND TTY='ETCLIN' THEN 9

            -- HCPCS
            WHEN SAB='HCPCS' AND TTY='PT' THEN 1
            WHEN SAB='HCPCS' AND TTY='MTH_HT' THEN 2
            WHEN SAB='HCPCS' AND TTY='HT' THEN 3
            WHEN SAB='HCPCS' AND TTY='OP' THEN 4
            WHEN SAB='HCPCS' AND TTY='OM' THEN 5
            WHEN SAB='HCPCS' AND TTY='AM' THEN 6
            WHEN SAB='HCPCS' AND TTY='OAM' THEN 7
            WHEN SAB='HCPCS' AND TTY='MP' THEN 8
            WHEN SAB='HCPCS' AND TTY='OA' THEN 9
            WHEN SAB='HCPCS' AND TTY='AB' THEN 10

            ELSE 99
        END
) AS rn

        FROM MRCONSO
        WHERE SAB IN ('HCPCS', 'CPT')
    )
SELECT
    f.CUI,
    f.AUI,
    f.CXN,
    f.PAUI,
    F.SAB,
    f.RELA,
    f.full_ptr,
    f.hier_index,
    f.hier_aui,
    rt.CODE AS proc_cd,
    rt.STR AS description,
    rt.TTY AS term_type_used,
    rt.RN
FROM flat f
LEFT JOIN ranked_terms rt
       ON rt.AUI = f.hier_aui AND rt.rn = 1
WHERE rt.CODE IS NOT NULL       -- ensures final output only returns requested codes
ORDER BY CUI, hier_index;