use database DAS;
use schema DAS_HEALTHCARE_CLAIMS_RAW_DB;
USE ROLE DAS_DLK_DAS_HEALTHCARE_CLAIMS_DO_GRP;


CREATE OR REPLACE TABLE TEMP_MRCONSO_MRREL_RELATIONSHIPS_WEIGHTS (
    sab STRING,
    tty STRING,
    rank_weight INT
);

INSERT INTO TEMP_MRCONSO_MRREL_RELATIONSHIPS_WEIGHTS (sab, tty, rank_weight) VALUES
-- Preferred names
('MTH','PN',1),
('MTHCMSFRF','PT',2),



-- RXNORM hierarchy
('RXNORM','SCD',3),('RXNORM','SBD',4),('RXNORM','SCDG',5),('RXNORM','SCDGP',6),
('RXNORM','SBDG',7),('RXNORM','BPCK',8),('RXNORM','GPCK',9),('RXNORM','IN',10),
('RXNORM','PSN',11),('RXNORM','MIN',12),('RXNORM','SCDF',13),('RXNORM','SCDFP',14),
('RXNORM','SBDF',15),('RXNORM','SBDFP',16),('RXNORM','SCDC',17),('RXNORM','DFG',18),
('RXNORM','DF',19),('RXNORM','SBDC',20),('RXNORM','BN',21),('RXNORM','PIN',22),
('RXNORM','TMSY',23),('RXNORM','SY',24),

-- ATC (drug classification groups – critical for your drug family work)
('ATC','RXN_PT',25),('ATC','PT',26),('ATC','RXN_IN',27),('ATC','IN',28),

--MED-RT 
('MED-RT', 'PT', 30),
('MED-RT', 'FN', 31),
('MED-RT', 'SY', 32),

-- NCI oncology vocab
('NCI','PT',60),('NCI','SY',61),('NCI','CSN',62),('NCI','DN',63),('NCI','FBD',64),
('NCI','HD',65),('NCI','CCN',66),('NCI','AD',67),('NCI','CA2',68),('NCI','CA3',69),
('NCI','BN',70),('NCI','AB',71),('NCI','OP',72),

-- MTH meta terms
('MTH','CV',80),('MTH','XM',80),('MTH','PT',80),('MTH','SY',80),('MTH','RT',80),('MTH','DT',80),

-- MeSH
('MSH','MH',91),('MSH','TQ',92),('MSH','PEP',93),('MSH','ET',94),
('MSH','XQ',95),('MSH','PXQ',96),('MSH','NM',97);