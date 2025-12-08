CREATE OR REPLACE TABLE temp_claim_icd10_long AS
WITH all_claims AS (
    SELECT claim_id,
           paid_dt,
           dx_cd, dx_cd_02, dx_cd_03, dx_cd_04, dx_cd_05, dx_cd_06, dx_cd_07, dx_cd_08, dx_cd_09, dx_cd_10,
           dx_cd_11, dx_cd_12, dx_cd_13, dx_cd_14, dx_cd_15, dx_cd_16, dx_cd_17, dx_cd_18, dx_cd_19, dx_cd_20,
           dx_cd_21, dx_cd_22, dx_cd_23, dx_cd_24, dx_cd_25
    FROM health_care_claims
)
SELECT DISTINCT
    claim_id,
    paid_dt,
    dx_code
FROM all_claims
UNPIVOT (
    dx_code FOR dx_pos IN (
        dx_cd, dx_cd_02, dx_cd_03, dx_cd_04, dx_cd_05, dx_cd_06, dx_cd_07, dx_cd_08, dx_cd_09, dx_cd_10,
        dx_cd_11, dx_cd_12, dx_cd_13, dx_cd_14, dx_cd_15, dx_cd_16, dx_cd_17, dx_cd_18, dx_cd_19, dx_cd_20,
        dx_cd_21, dx_cd_22, dx_cd_23, dx_cd_24, dx_cd_25
    )
)
WHERE dx_code NOT IN ('~','');