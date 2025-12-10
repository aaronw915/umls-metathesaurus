USE DATABASE das;
USE SCHEMA das_healthcare_claims_raw_db;
USE ROLE das_dlk_das_healthcare_claims_do_grp;
USE WAREHOUSE DAS_SFK_XS_WH;
CREATE OR REPLACE TABLE TEMP_ATC_HIERARCHY AS WITH fr AS (
    SELECT 
        cui, 
        aui, 
        PTR || '.' || AUI AS full_range 
    FROM 
        mrhier 
),
flattened_hierarchy AS (
    SELECT
        fr.cui AS cui,
        fr.aui AS aui,
        FLATTENED_ROW.INDEX  AS HIERARCHY_LEVEL, -- Add 1 to make it 1-based
        FLATTENED_ROW.VALUE::VARCHAR AS FLATTENED_AUI, -- Cast the value to VARCHAR
        fr.full_range
    FROM
        fr,
    LATERAL FLATTEN(
        INPUT => split(fr.full_range, '.')
    ) AS FLATTENED_ROW
)
-- Main selection joining with MRCONSO
SELECT
    fh.CUI,
    fh.AUI,
    fh.HIERARCHY_LEVEL,
    fh.FLATTENED_AUI,
    mc.cui AS FLATTENED_CUI,
    mc.code AS ATC_CODE,
    mc.str AS ATC_STRING,
    fh.full_range
FROM
    flattened_hierarchy fh
LEFT JOIN
    mrconso mc ON fh.FLATTENED_AUI = mc.aui
WHERE
    mc.sab = 'ATC' -- Optionally filter MRCONSO to only include the ATC source data
