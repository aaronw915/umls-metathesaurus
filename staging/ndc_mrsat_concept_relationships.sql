CREATE OR REPLACE TABLE TEMP_NDC_RELATIONSHIP_WEIGHTS (
    sab STRING,
    tty STRING,
    rank_weight INT
);

INSERT INTO TEMP_NDC_RELATIONSHIP_WEIGHTS (sab, tty, rank_weight) VALUES

-----------------------------------------
-- 1. RXNORM FIRST (NDC–centric priority) 
-- Structured dose forms → branded/generic → packs → synonym types
-----------------------------------------

('RXNORM','SCD',1),   -- Semantic Clinical Drug (generic strength + form)
('RXNORM','SBD',2),   -- Semantic Branded Drug
('RXNORM','BPCK',3),  -- Branded packs (NDC often maps here)
('RXNORM','GPCK',4),  -- Generic packs
('RXNORM','SCDG',5),  -- Clinical drug group
('RXNORM','SBDG',6),  -- Branded drug group
('RXNORM','SCDF',7),  -- Clinical drug + dose form
('RXNORM','SBDF',8),  -- Branded dose form
('RXNORM','IN',9),    -- Ingredient
('RXNORM','MIN',10),  -- Multigran ingredient
('RXNORM','PSN',11),  -- Preferred Substance Name
('RXNORM','BN',12),   -- Brand name
('RXNORM','SY',13),   -- Synonym
('RXNORM','TMSY',14), -- Term type synonym

-----------------------------------------
-- 2. NDDF SECOND (commonly tied to NDC classification)
-----------------------------------------

('NDDF','CD',20),     -- Clinical Drug class
('NDDF','IN',21),     -- Ingredient
('NDDF','DF',22),     -- Dose Form
('NDDF','CDC',23),    -- Clinical Drug + class
('NDDF','CDD',24),    -- Clinical dose descriptor
('NDDF','CDA',25),    -- Clinical drug attributes

-----------------------------------------
-- 3. MTHSPL THIRD (Structured Product Label NDC relationships)
-----------------------------------------

('MTHSPL','DP',30),       -- Drug Product
('MTHSPL','MTH_RXN_DP',31),  -- SPL mapped to RxNorm product

-----------------------------------------
-- 4. OTHER Vocabularies Last (fallback)
-----------------------------------------

('VANDF','IN',50),
('VANDF','AB',51),
('VANDF','CD',52),
('VANDF','MTH_RXN_CD',53),

('MMSL','MS',60),
('MMSL','CD',61),
('MMSL','BN',62),
('MMSL','BD',63),
('MMSL','MTH_RXN_BD',64),

('GS','MTH_RXN_CD',70),
('GS','MTH_RXN_BD',71),
('GS','CD',72),
('GS','IN',73),
('GS','BD',74),

('MMX','CD',80),
('MMX','BD',81),
('MMX','MTH_RXN_CD',82),
('MMX','MTH_RXN_BD',83),
sele
('CVX','RXN_PT',90);   -- Non–drug CVX route but included for fallback
