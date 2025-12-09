USE DATABASE DAS;
USE SCHEMA DAS_HEALTHCARE_CLAIMS_RAW_DB;
USE ROLE DAS_DLK_DAS_HEALTHCARE_CLAIMS_DO_GRP;
    
CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRCONSO
(
    CUI       CHAR(8)       COMMENT 'Concept Unique Identifier',
    LAT       CHAR(3)       COMMENT 'Language of Term',
    TS        CHAR(1)       COMMENT 'Term Status',
    LUI       CHAR(10)      COMMENT 'Lexical Unique Identifier',
    STT       CHAR(3)       COMMENT 'String Type',
    SUI       CHAR(10)      COMMENT 'String Unique Identifier',
    ISPREF    CHAR(1)       COMMENT 'Preferred String Indicator',
    AUI       CHAR(9)       COMMENT 'Atom Unique Identifier',
    SAUI      CHAR(50)      COMMENT 'Source Asserted Atom Identifier',
    SCUI      CHAR(100)     COMMENT 'Source Asserted Concept Identifier',
    SDUI      CHAR(100)     COMMENT 'Source Asserted Descriptor Identifier',
    SAB       CHAR(40)      COMMENT 'Source Vocabulary',
    TTY       CHAR(40)      COMMENT 'Term Type in Source',
    CODE      CHAR(100)     COMMENT 'Source Code',
    STR       CHAR(3000)    COMMENT 'Atom String',
    SRL       INTEGER       COMMENT 'Source Restriction Level',
    SUPPRESS  CHAR(1)       COMMENT 'Suppressible Flag',
    CVF       INTEGER       COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRCONSO - Concepts with all associated strings, codes, and source vocabularies';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDEF (
    CUI       CHAR(8)      COMMENT 'Concept Unique Identifier',
    AUI       CHAR(9)      COMMENT 'Atom Unique Identifier',
    ATUI      CHAR(11)     COMMENT 'Atom Term Identifier',
    SATUI     CHAR(50)     COMMENT 'Source Asserted Term Identifier',
    SAB       CHAR(40)     COMMENT 'Source Abbreviation',
    DEF       CHAR(4000)   COMMENT 'Concept Definition Text',
    SUPPRESS  CHAR(1)      COMMENT 'Suppression Flag',
    CVF       NUMBER          COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRDEF  Definitions for concepts';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDOC (
    DOCKEY   CHAR(50) COMMENT 'Documentation key/category',
    VALUE    CHAR(200) COMMENT 'Documentation value/description',
    TYPE     CHAR(50) COMMENT 'Type (e.g., STY, ATN, RELA)',
    EXPL     CHAR(1000) COMMENT 'Explanation of meaning'
)
COMMENT = 'UMLS MRDOC  Documentation about keys used in UMLS files';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRHIER (
    CUI     CHAR(8) COMMENT 'Concept Unique Identifier',
    AUI     CHAR(9) COMMENT 'Atom Unique Identifier',
    CXN     INTEGER COMMENT 'Context identifier',
    PAUI    CHAR(10) COMMENT 'Parent Atom Unique Identifier',
    SAB     CHAR(40) COMMENT 'Relationship attribute',
    RELA    CHAR(100) COMMENT 'Source vocabulary',
    PTR     CHAR(1000) COMMENT 'Path to root representation',
    HCD     CHAR(100)  COMMENT 'Hierarchy code (optional)',
    CVF     INTEGER COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRHIER  Hierarchical relationships between concepts';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRRANK (
    RANK     INTEGER COMMENT 'Rank order  lower is better',
    SAB      CHAR(40) COMMENT 'Source vocabulary',
    TTY      CHAR(40) COMMENT 'Term Type',
    SUPPRESS CHAR(1) COMMENT 'Suppressible flag'
)
COMMENT = 'UMLS MRRANK  Ranking of term types per vocabulary source';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRREL (
    CUI1      CHAR(8)    COMMENT 'First Concept Unique Identifier',
    AUI1      CHAR(9)    COMMENT 'First Atom Unique Identifier',
    STYPE1    CHAR(50)   COMMENT 'First source asserted relationship label',
    REL       CHAR(4)    COMMENT 'Relationship label',
    CUI2      CHAR(8)    COMMENT 'Second Concept Unique Identifier',
    AUI2      CHAR(9)    COMMENT 'Second Atom Unique Identifier',
    STYPE2    CHAR(50)   COMMENT 'Second source asserted relationship label',
    RELA      CHAR(100)  COMMENT 'Additional relationship label',
    RUI       CHAR(10)   COMMENT 'Relationship Unique Identifier',
    SRUI      CHAR(50)   COMMENT 'Source asserted Relationship Unique Identifier',
    SAB       CHAR(40)   COMMENT 'Source abbreviation',
    SL        CHAR(40)   COMMENT 'Source of relationship labels',
    RG        CHAR(10)   COMMENT 'Relationship group',
    DIR       CHAR(1)    COMMENT 'Direction flag',
    SUPPRESS  CHAR(1)    COMMENT 'Suppressible flag',
    CVF       INTEGER    COMMENT 'Content view flag'
)
COMMENT = 'UMLS MRREL  Relationships between concepts and atoms';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAB (
    VCUI    CHAR(8)       COMMENT 'Versioned CUI',
    RCUI    CHAR(8)       COMMENT 'Root CUI',
    VSAB    CHAR(40)      COMMENT 'Versioned Source Abbreviation',
    RSAB    CHAR(40)      COMMENT 'Root Source Abbreviation',
    SON     CHAR(3000)    COMMENT 'Official Source Name',
    SF      CHAR(40)      COMMENT 'Source Family',
    SVER    CHAR(40)      COMMENT 'Source Version',
    VSTART  CHAR(8)       COMMENT 'Version start date (YYYYMMDD)',
    VEND    CHAR(8)       COMMENT 'Version end date (YYYYMMDD)',
    IMETA   CHAR(10)      COMMENT 'Insertion Metadata',
    RMETA   CHAR(10)      COMMENT 'Removal Metadata',
    SLC     CHAR(1000)    COMMENT 'Source Language Code',
    SCC     CHAR(1000)    COMMENT 'Source Citation',
    SRL     INTEGER       COMMENT 'Source restriction level',
    TFR     INTEGER       COMMENT 'Term frequency, raw count',
    CFR     INTEGER       COMMENT 'Concept frequency, raw count',
    CXTY    CHAR(50)      COMMENT 'Context type',
    TTYL    CHAR(400)     COMMENT 'List of term types',
    ATNL    CHAR(4000)    COMMENT 'List of attributes',
    LAT     CHAR(3)       COMMENT 'Language of Source',
    CENC    CHAR(40)      COMMENT 'Encoding scheme',
    CURVER  CHAR(1)       COMMENT 'Indicates whether this is the current version',
    SABIN   CHAR(1)       COMMENT 'Source inclusion flag',
    SSN     CHAR(3000)    COMMENT 'Source short name',
    SCIT    CHAR(4000)    COMMENT 'Source citation additional info'
)
COMMENT = 'UMLS MRSAB  Source vocabulary metadata and versioning';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAT (
(
    CUI       CHAR(8)       COMMENT 'Concept Unique Identifier',
    LUI       CHAR(10)      COMMENT 'Lexical Unique Identifier',
    SUI       CHAR(10)      COMMENT 'String Unique Identifier',
    METAUI    CHAR(100)     COMMENT 'Metathesaurus Unique Identifier',
    STYPE     CHAR(50)      COMMENT 'Source type',
    CODE      CHAR(100)     COMMENT 'Source asserted identifier or code',
    ATUI      CHAR(11)      COMMENT 'Attribute Unique Identifier',
    SATUI     CHAR(50)      COMMENT 'Source asserted Attribute Unique Identifier',
    ATN       CHAR(100)     COMMENT 'Attribute name',
    SAB       CHAR(40)      COMMENT 'Source abbreviation',
    ATV       CHAR(4000)    COMMENT 'Attribute value',
    SUPPRESS  CHAR(1)       COMMENT 'Suppressible flag',
    CVF       INTEGER       COMMENT 'Content view flag'
)
)
COMMENT = 'UMLS MRSAT  Attributes for concepts, atoms, strings';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSTY
(
    CUI   CHAR(8)      COMMENT 'Concept Unique Identifier',
    TUI   CHAR(4)      COMMENT 'Semantic Type Unique Identifier',
    STN   CHAR(100)    COMMENT 'Semantic Type Tree Number',
    STY   CHAR(50)     COMMENT 'Semantic Type',
    ATUI  CHAR(11)     COMMENT 'Attribute Unique Identifier',
    CVF   INTEGER      COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRSTY  Semantic types associated with concepts';

CREATE OR REPLACE FILE FORMAT DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = '|'
    TRIM_SPACE = TRUE
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('', 'NULL',' ')
    ESCAPE = '\\'
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE;

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
