WITH fr AS (
    SELECT 
        cui, 
        aui, 
        PTR || '.' || AUI AS full_range 
    FROM 
        mrhier 
    WHERE 
        cui = 'C3885068' AND sab = 'ATC'
),
flattened_hierarchy AS (
    SELECT
        fr.cui AS original_cui,
        fr.aui AS original_aui,
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
    fh.original_cui,
    fh.original_aui,
    fh.HIERARCHY_LEVEL,
    fh.FLATTENED_AUI,
    mc.cui AS associated_cui,
    mc.code AS associated_code,
    mc.str AS associated_string,
    fh.full_range
FROM
    flattened_hierarchy fh
LEFT JOIN
    mrconso mc ON fh.FLATTENED_AUI = mc.aui
WHERE
    mc.sab = 'ATC' -- Optionally filter MRCONSO to only include the ATC source data
ORDER BY
    fh.original_cui, fh.original_aui, fh.HIERARCHY_LEVEL;