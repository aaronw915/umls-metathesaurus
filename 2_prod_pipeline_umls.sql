USE DATABASE DAS;
USE SCHEMA DAS_HEALTHCARE_CLAIMS_RAW_DB;
USE ROLE DAS_DLK_DAS_HEALTHCARE_CLAIMS_DO_GRP;
USE WAREHOUSE DAS_SFK_XS_WH;
    
CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRCONSO
(
    CUI       VARCHAR(8)       COMMENT 'Concept Unique Identifier',
    LAT       VARCHAR(3)       COMMENT 'Language of Term',
    TS        VARCHAR(1)       COMMENT 'Term Status',
    LUI       VARCHAR(10)      COMMENT 'Lexical Unique Identifier',
    STT       VARCHAR(3)       COMMENT 'String Type',
    SUI       VARCHAR(10)      COMMENT 'String Unique Identifier',
    ISPREF    VARCHAR(1)       COMMENT 'Preferred String Indicator',
    AUI       VARCHAR(9)       COMMENT 'Atom Unique Identifier',
    SAUI      VARCHAR(50)      COMMENT 'Source Asserted Atom Identifier',
    SCUI      VARCHAR(100)     COMMENT 'Source Asserted Concept Identifier',
    SDUI      VARCHAR(100)     COMMENT 'Source Asserted Descriptor Identifier',
    SAB       VARCHAR(40)      COMMENT 'Source Vocabulary',
    TTY       VARCHAR(40)      COMMENT 'Term Type in Source',
    CODE      VARCHAR(100)     COMMENT 'Source Code',
    STR       VARCHAR(3000)    COMMENT 'Atom String',
    SRL       VARCHAR       COMMENT 'Source Restriction Level',
    SUPPRESS  VARCHAR(1)       COMMENT 'Suppressible Flag',
    CVF       VARCHAR       COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRCONSO - Concepts with all associated strings, codes, and source vocabularies';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDEF (
    CUI       VARCHAR(8)      COMMENT 'Concept Unique Identifier',
    AUI       VARCHAR(9)      COMMENT 'Atom Unique Identifier',
    ATUI      VARCHAR(11)     COMMENT 'Atom Term Identifier',
    SATUI     VARCHAR(50)     COMMENT 'Source Asserted Term Identifier',
    SAB       VARCHAR(40)     COMMENT 'Source Abbreviation',
    DEF       VARCHAR   COMMENT 'Concept Definition Text',
    SUPPRESS  VARCHAR(1)      COMMENT 'Suppression Flag',
    CVF       NUMBER          COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRDEF  Definitions for concepts';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDOC (
    DOCKEY   VARCHAR(50) COMMENT 'Documentation key/category',
    VALUE    VARCHAR(200) COMMENT 'Documentation value/description',
    TYPE     VARCHAR(50) COMMENT 'Type (e.g., STY, ATN, RELA)',
    EXPL     VARCHAR COMMENT 'Explanation of meaning'
)
COMMENT = 'UMLS MRDOC  Documentation about keys used in UMLS files';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRHIER (
    CUI     VARCHAR(8) COMMENT 'Concept Unique Identifier',
    AUI     VARCHAR(9) COMMENT 'Atom Unique Identifier',
    CXN     VARCHAR COMMENT 'Context identifier',
    PAUI    VARCHAR(10) COMMENT 'Parent Atom Unique Identifier',
    SAB     VARCHAR(40) COMMENT 'Relationship attribute',
    RELA    VARCHAR(100) COMMENT 'Source vocabulary',
    PTR     VARCHAR(1000) COMMENT 'Path to root representation',
    HCD     VARCHAR(100)  COMMENT 'Hierarchy code (optional)',
    CVF     VARCHAR COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRHIER  Hierarchical relationships between concepts';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRRANK (
    RANK     VARCHAR COMMENT 'Rank order  lower is better',
    SAB      VARCHAR(40) COMMENT 'Source vocabulary',
    TTY      VARCHAR(40) COMMENT 'Term Type',
    SUPPRESS VARCHAR(1) COMMENT 'Suppressible flag'
)
COMMENT = 'UMLS MRRANK  Ranking of term types per vocabulary source';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRREL (
    CUI1      VARCHAR(8)    COMMENT 'First Concept Unique Identifier',
    AUI1      VARCHAR(9)    COMMENT 'First Atom Unique Identifier',
    STYPE1    VARCHAR(50)   COMMENT 'First source asserted relationship label',
    REL       VARCHAR(4)    COMMENT 'Relationship label',
    CUI2      VARCHAR(8)    COMMENT 'Second Concept Unique Identifier',
    AUI2      VARCHAR(9)    COMMENT 'Second Atom Unique Identifier',
    STYPE2    VARCHAR(50)   COMMENT 'Second source asserted relationship label',
    RELA      VARCHAR(100)  COMMENT 'Additional relationship label',
    RUI       VARCHAR(10)   COMMENT 'Relationship Unique Identifier',
    SRUI      VARCHAR(50)   COMMENT 'Source asserted Relationship Unique Identifier',
    SAB       VARCHAR(40)   COMMENT 'Source abbreviation',
    SL        VARCHAR(40)   COMMENT 'Source of relationship labels',
    RG        VARCHAR(10)   COMMENT 'Relationship group',
    DIR       VARCHAR(1)    COMMENT 'Direction flag',
    SUPPRESS  VARCHAR(1)    COMMENT 'Suppressible flag',
    CVF       VARCHAR    COMMENT 'Content view flag'
)
COMMENT = 'UMLS MRREL  Relationships between concepts and atoms';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAB (
    VCUI    VARCHAR(8)       COMMENT 'Versioned CUI',
    RCUI    VARCHAR(8)       COMMENT 'Root CUI',
    VSAB    VARCHAR(40)      COMMENT 'Versioned Source Abbreviation',
    RSAB    VARCHAR(40)      COMMENT 'Root Source Abbreviation',
    SON     VARCHAR(3000)    COMMENT 'Official Source Name',
    SF      VARCHAR(40)      COMMENT 'Source Family',
    SVER    VARCHAR(40)      COMMENT 'Source Version',
    VSTART  VARCHAR(8)       COMMENT 'Version start date (YYYYMMDD)',
    VEND    VARCHAR(8)       COMMENT 'Version end date (YYYYMMDD)',
    IMETA   VARCHAR(10)      COMMENT 'Insertion Metadata',
    RMETA   VARCHAR(10)      COMMENT 'Removal Metadata',
    SLC     VARCHAR(1000)    COMMENT 'Source Language Code',
    SCC     VARCHAR(1000)    COMMENT 'Source Citation',
    SRL     VARCHAR       COMMENT 'Source restriction level',
    TFR     VARCHAR       COMMENT 'Term frequency, raw count',
    CFR     VARCHAR       COMMENT 'Concept frequency, raw count',
    CXTY    VARCHAR(50)      COMMENT 'Context type',
    TTYL    VARCHAR(400)     COMMENT 'List of term types',
    ATNL    VARCHAR(4000)    COMMENT 'List of attributes',
    LAT     VARCHAR(3)       COMMENT 'Language of Source',
    CENC    VARCHAR(40)      COMMENT 'Encoding scheme',
    CURVER  VARCHAR(1)       COMMENT 'Indicates whether this is the current version',
    SABIN   VARCHAR(1)       COMMENT 'Source inclusion flag',
    SSN     VARCHAR    COMMENT 'Source short name',
    SCIT    VARCHAR    COMMENT 'Source citation additional info'
)
COMMENT = 'UMLS MRSAB  Source vocabulary metadata and versioning';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAT (
    CUI       VARCHAR(8)       COMMENT 'Concept Unique Identifier',
    LUI       VARCHAR(10)      COMMENT 'Lexical Unique Identifier',
    SUI       VARCHAR(10)      COMMENT 'String Unique Identifier',
    METAUI    VARCHAR(100)     COMMENT 'Metathesaurus Unique Identifier',
    STYPE     VARCHAR(50)      COMMENT 'Source type',
    CODE      VARCHAR(100)     COMMENT 'Source asserted identifier or code',
    ATUI      VARCHAR(11)      COMMENT 'Attribute Unique Identifier',
    SATUI     VARCHAR(50)      COMMENT 'Source asserted Attribute Unique Identifier',
    ATN       VARCHAR(100)     COMMENT 'Attribute name',
    SAB       VARCHAR(40)      COMMENT 'Source abbreviation',
    ATV       VARCHAR    COMMENT 'Attribute value',
    SUPPRESS  VARCHAR(1)       COMMENT 'Suppressible flag',
    CVF       VARCHAR       COMMENT 'Content view flag'
)
COMMENT = 'UMLS MRSAT  Attributes for concepts, atoms, strings';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSTY
(
    CUI   VARCHAR(8)      COMMENT 'Concept Unique Identifier',
    TUI   VARCHAR(4)      COMMENT 'Semantic Type Unique Identifier',
    STN   VARCHAR(100)    COMMENT 'Semantic Type Tree Number',
    STY   VARCHAR(50)     COMMENT 'Semantic Type',
    ATUI  VARCHAR(11)     COMMENT 'Attribute Unique Identifier',
    CVF   VARCHAR      COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRSTY  Semantic types associated with concepts';

CREATE OR REPLACE FILE FORMAT DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = '|'
    TRIM_SPACE = TRUE
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('', 'NULL',' ')
    ESCAPE = '\\'
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRCONSO
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRCONSO.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDEF
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRDEF.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDOC
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRDOC.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRHIER
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRHIER.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRRANK
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRRANK.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRREL
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRREL.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAB
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSAB.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAT
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSAT.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSTY
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSTY.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT')
ON_ERROR = 'ABORT_STATEMENT';
