CREATE    OR REPLACE TABLE TEMP_RX_CLAIMS_NDC_DESCRIPTIONS AS
WITH      RX_NDCS AS (
          SELECT    DISTINCT NDC_NBR_CD AS NDC
          FROM      PHARMACY_CLAIMS
          ),
          MR_NDCS AS (
          SELECT    CUI,
                    ATV AS NDC
          FROM      MRSAT
          WHERE     ATN = 'NDC'
          ),
          JOINED AS (
          SELECT    RX.NDC,
                    MR.CUI
          FROM      RX_NDCS RX
          LEFT JOIN MR_NDCS MR ON RX.NDC = MR.NDC
          ),
          WEIGHTED AS (
          SELECT    A.CUI,
                    A.STR AS NDC_NAME,
                    A.SAB,
                    A.TTY
          FROM      MRCONSO A
          JOIN      TEMP_MRCONSO_MRREL_RELATIONSHIPS_WEIGHTS W ON A.SAB = W.SAB
          AND       A.TTY = W.TTY
          QUALIFY   ROW_NUMBER() OVER (
                    PARTITION BY A.CUI
                    ORDER BY  W.RANK_WEIGHT
                    ) = 1
          )
SELECT    DISTINCT J.NDC,
          W.NDC_NAME,
          W.SAB,
          W.TTY,
          W.CUI
FROM      JOINED J
LEFT JOIN WEIGHTED W ON J.CUI = W.CUI
limit 5 ;

