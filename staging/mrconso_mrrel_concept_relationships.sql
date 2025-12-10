USE DATABASE das;

USE SCHEMA das_healthcare_claims_raw_db;

USE ROLE das_dlk_das_healthcare_claims_do_grp;

CREATE OR REPLACE TABLE temp_mrconso_mrrel_relationships_weights (sab STRING, tty STRING, rank_weight INT);

INSERT INTO
    temp_mrconso_mrrel_relationships_weights (sab, tty, rank_weight)
VALUES
    -- Preferred names
    -- RXNORM hierarchy
    ('RXNORM', 'SCD', 1),
    ('RXNORM', 'SBD', 2),
    ('RXNORM', 'SCDG', 3),
    ('RXNORM', 'SCDGP', 4),
    ('RXNORM', 'SBDG', 5),
    ('RXNORM', 'BPCK', 6),
    ('RXNORM', 'GPCK', 7),
    ('RXNORM', 'IN', 8),
    ('RXNORM', 'PSN', 9),
    ('RXNORM', 'MIN', 10),
    ('RXNORM', 'SCDF', 11),
    ('RXNORM', 'SCDFP', 12),
    ('RXNORM', 'SBDF', 13),
    ('RXNORM', 'SBDFP', 14),
    ('RXNORM', 'SCDC', 15),
    ('RXNORM', 'DFG', 16),
    ('RXNORM', 'DF', 17),
    ('RXNORM', 'SBDC', 18),
    ('RXNORM', 'BN', 19),
    ('RXNORM', 'PIN', 20),
    ('RXNORM', 'TMSY', 21),
    ('RXNORM', 'SY', 22),
    ('MTH', 'PN', 23),
    ('MTHCMSFRF', 'PT', 24),
    -- ATC (drug classification groups – critical for your drug family work)
    ('ATC', 'RXN_PT', 25),
    ('ATC', 'PT', 26),
    ('ATC', 'RXN_IN', 27),
    ('ATC', 'IN', 28),
    --MED-RT 
    ('MED-RT', 'PT', 30),
    ('MED-RT', 'FN', 31),
    ('MED-RT', 'SY', 32),
    -- NCI oncology vocab
    ('NCI', 'PT', 60),
    ('NCI', 'SY', 61),
    ('NCI', 'CSN', 62),
    ('NCI', 'DN', 63),
    ('NCI', 'FBD', 64),
    ('NCI', 'HD', 65),
    ('NCI', 'CCN', 66),
    ('NCI', 'AD', 67),
    ('NCI', 'CA2', 68),
    ('NCI', 'CA3', 69),
    ('NCI', 'BN', 70),
    ('NCI', 'AB', 71),
    ('NCI', 'OP', 72),
    -- MTH meta terms
    ('MTH', 'CV', 80),
    ('MTH', 'XM', 81),
    ('MTH', 'PT', 82),
    ('MTH', 'SY', 83),
    ('MTH', 'RT', 84),
    ('MTH', 'DT', 84),
    -- MeSH
    ('MSH', 'MH', 91),
    ('MSH', 'TQ', 92),
    ('MSH', 'PEP', 93),
    ('MSH', 'ET', 94),
    ('MSH', 'XQ', 95),
    ('MSH', 'PXQ', 96),
    ('MSH', 'NM', 97);