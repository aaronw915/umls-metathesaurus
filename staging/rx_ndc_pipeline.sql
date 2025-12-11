/* Build a table of the highest-ranked description for every CUI.
MRCONSO contains all names/synonyms for each concept; MRRANK supplies the ranking.
We select the “best” (rank-1) string per CUI to ensure consistent naming later. */
CREATE    OR REPLACE TABLE TEMP_MRCONSO_CUI_DESCRIPTIONS_WEIGHTED AS
WITH      MR_RANKINGS AS (
          SELECT    M.CUI,
                    M.STR AS NAME,
                    M.CODE,
                    M.AUI,
                    M.SAB,
                    M.TTY,
                    ROW_NUMBER() OVER (
                    PARTITION BY M.CUI
                    ORDER BY  R.RANK DESC
                    ) AS RN
          FROM      MRCONSO M
          JOIN      MRRANK R ON M.SAB = R.SAB
          AND       M.TTY = R.TTY
          )
SELECT    *
FROM      MR_RANKINGS
WHERE     RN = 1;

/* Extract all NDC–CUI mappings from MRSAT.
- ATN='NDC' returns the NDC attribute values.
- SUPPRESS='N' filters out deprecated entries.
- Normalizes NDC by removing hyphens and requiring 11 digits. */
CREATE    OR REPLACE TABLE TEMP_MRSAT_NDC_LOOKUP AS
SELECT    DISTINCT CUI,
          REPLACE(ATV, '-', '') AS NDC
FROM      MRSAT
WHERE     ATN = 'NDC'
AND       SUPPRESS = 'N'
AND       LENGTH(REPLACE(ATV, '-', '')) = 11;

/* Determine the most representative CUI for each NDC based on MRRANK.
Step 1: Rank all CUIs linked to an NDC using RxNorm ranking logic.
Step 2: Select the highest ranked CUI for each NDC.
Step 3: Attach the best-ranked description (from TEMP_MRCONSO_CUI_DESCRIPTIONS_WEIGHTED). */
CREATE    OR REPLACE TABLE TEMP_NDC_CUI_DESCRIPTION_BEST AS
WITH      NDC_CUI_RANKED AS (
          SELECT    N.NDC,
                    N.CUI,
                    R.RANK AS MRRANK_SCORE,
                    ROW_NUMBER() OVER (
                    PARTITION BY N.NDC
                    ORDER BY  R.RANK DESC
                    ) AS RN
          FROM      TEMP_MRSAT_NDC_LOOKUP N
          JOIN      MRCONSO M ON N.CUI = M.CUI
          JOIN      MRRANK R ON M.SAB = R.SAB
          AND       M.TTY = R.TTY
          ),
          BEST_CUI AS (
          SELECT    NDC,
                    CUI
          FROM      NDC_CUI_RANKED
          WHERE     RN = 1
          )
SELECT    B.NDC,
          B.CUI,
          D.NAME,
          D.CODE,
          D.AUI,
          D.SAB,
          D.TTY
FROM      BEST_CUI B
JOIN      TEMP_MRCONSO_CUI_DESCRIPTIONS_WEIGHTED D ON B.CUI = D.CUI;
