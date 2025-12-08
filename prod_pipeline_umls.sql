CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRCONSO (
    CUI        STRING COMMENT 'Concept Unique Identifier',
    LAT        STRING COMMENT 'Language of term',
    TS         STRING COMMENT 'Term Status (P=preferred, S=supplemental)',
    LUI        STRING COMMENT 'Lexical Unique Identifier',
    STT        STRING COMMENT 'String Type (PF=preferred form, etc.)',
    SUI        STRING COMMENT 'String Unique Identifier',
    ISPREF     STRING COMMENT 'Preferred term indicator (Y/N)',
    AUI        STRING COMMENT 'Atom Unique Identifier',
    SAUI       STRING COMMENT 'Source Atom Identifier',
    SCUI       STRING COMMENT 'Source Asserted Concept Identifier',
    SDUI       STRING COMMENT 'Source Asserted Descriptor Identifier',
    SAB        STRING COMMENT 'Source vocabulary abbreviation',
    TTY        STRING COMMENT 'Term Type in Source',
    CODE       STRING COMMENT 'Source term code',
    STR        STRING COMMENT 'String representation of term',
    SRL        STRING COMMENT 'Source Restriction Level',
    SUPPRESS   STRING COMMENT 'Suppressible flag (O, Y, E, N)',
    CVF        STRING COMMENT 'Content View Flag (may be null)'
)
COMMENT = 'UMLS MRCONSO  Concept names, lexical and term information';


CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDEF (
    CUI       STRING COMMENT 'Concept Unique Identifier',
    AUI       STRING COMMENT 'Atom Unique Identifier for defining atom',
    ATUI      STRING COMMENT 'Atom-Level Type Unique Identifier',
    SATUI     STRING COMMENT 'Source Asserted TUI',
    SAB       STRING COMMENT 'Source vocabulary abbreviation',
    DEF       STRING COMMENT 'Definition text',
    SUPPRESS  STRING COMMENT 'Suppressible flag (O,Y,E,N)',
    CVF       STRING COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRDEF  Definitions for concepts';


CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRDOC (
    DOCKEY   STRING COMMENT 'Documentation key/category',
    VALUE    STRING COMMENT 'Documentation value/description',
    TYPE     STRING COMMENT 'Type (e.g., STY, ATN, RELA)',
    EXPL     STRING COMMENT 'Explanation of meaning'
)
COMMENT = 'UMLS MRDOC  Documentation about keys used in UMLS files';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRHIER (
    CUI     STRING COMMENT 'Concept Unique Identifier',
    AUI     STRING COMMENT 'Atom Unique Identifier',
    CXN     STRING COMMENT 'Context identifier',
    PAUI    STRING COMMENT 'Parent Atom Unique Identifier',
    RELA    STRING COMMENT 'Relationship attribute',
    SAB     STRING COMMENT 'Source vocabulary',
    PTR     STRING COMMENT 'Path to root representation',
    HCD     STRING COMMENT 'Hierarchy code (optional)',
    CVF     STRING COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRHIER  Hierarchical relationships between concepts';


CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRRANK (
    RANK     STRING COMMENT 'Rank order  lower is better',
    SAB      STRING COMMENT 'Source vocabulary',
    TTY      STRING COMMENT 'Term Type',
    SUPPRESS STRING COMMENT 'Suppressible flag'
)
COMMENT = 'UMLS MRRANK  Ranking of term types per vocabulary source';


CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRREL (
    CUI1      STRING COMMENT 'Concept Unique Identifier (source)',
    AUI1      STRING COMMENT 'Atom Unique Identifier source',
    STYPE1    STRING COMMENT 'Semantic type of source',
    REL       STRING COMMENT 'Relationship type',
    CUI2      STRING COMMENT 'Concept Unique Identifier (target)',
    AUI2      STRING COMMENT 'Atom Unique Identifier target',
    STYPE2    STRING COMMENT 'Semantic type of target',
    RELA      STRING COMMENT 'Additional relationship attribute',
    RUI       STRING COMMENT 'Relationship Unique Identifier',
    SRUI      STRING COMMENT 'Source Relationship Identifier',
    SAB       STRING COMMENT 'Source vocabulary',
    SL        STRING COMMENT 'Source of relationship',
    RG        STRING COMMENT 'Relationship group identifier',
    DIR       STRING COMMENT 'Directionality of relationship',
    SUPPRESS  STRING COMMENT 'Suppressible flag',
    CVF       STRING COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRREL  Relationships between concepts and atoms';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAB (
    VCUI     STRING COMMENT 'Versioned Concept Unique Identifier',
    RCUI     STRING COMMENT 'Root Concept Unique Identifier',
    VSAB     STRING COMMENT 'Versioned Source Abbreviation',
    RSAB     STRING COMMENT 'Root Source Abbreviation',
    SON      STRING COMMENT 'Official source name',
    SF       STRING COMMENT 'Short form name',
    SVER     STRING COMMENT 'Source version',
    VSTART   STRING COMMENT 'Version start date',
    VEND     STRING COMMENT 'Version end date',
    IMETA    STRING COMMENT 'Includes Meta flag',
    RMETA    STRING COMMENT 'Root metadata flag',
    SLC      STRING COMMENT 'Source licensing contact',
    SCC      STRING COMMENT 'Source content contact',
    SRL      STRING COMMENT 'Source restriction level',
    TFR      STRING COMMENT 'Term frequency rank',
    CFR      STRING COMMENT 'Concept frequency rank',
    CXTY     STRING COMMENT 'Context type',
    TTYP     STRING COMMENT 'Term type',
    ATNL     STRING COMMENT 'Attribute name list',
    LAT      STRING COMMENT 'Language',
    CENC     STRING COMMENT 'Encoding',
    CURVER   STRING COMMENT 'Current version flag',
    SRCEP    STRING COMMENT 'Source release comment',
    VSAMP    STRING COMMENT 'Version sample flag',
    VENDP    STRING COMMENT 'Version end flag',
    SCIT     STRING COMMENT 'Citation information'
)
COMMENT = 'UMLS MRSAB  Source vocabulary metadata and versioning';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSAT (
    CUI       STRING COMMENT 'Concept Unique Identifier (may be null)',
    LUI       STRING COMMENT 'Lexical Unique Identifier',
    SUI       STRING COMMENT 'String Unique Identifier',
    METAUI    STRING COMMENT 'Meta Unique Identifier',
    STYPE     STRING COMMENT 'Semantic Type of attribute',
    ATN       STRING COMMENT 'Attribute Name',
    SAB       STRING COMMENT 'Source vocabulary',
    ATV       STRING COMMENT 'Attribute Value',
    SUPPRESS  STRING COMMENT 'Suppressible flag',
    CVF       STRING COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRSAT  Attributes for concepts, atoms, strings';

CREATE OR REPLACE TABLE DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.MRSTY (
    CUI      STRING COMMENT 'Concept Unique Identifier',
    TUI      STRING COMMENT 'Semantic Type Unique Identifier',
    STN      STRING COMMENT 'Semantic Type Tree Number',
    STY      STRING COMMENT 'Semantic Type name',
    ATUI     STRING COMMENT 'Atom Type Unique Identifier',
    CVF      STRING COMMENT 'Content View Flag'
)
COMMENT = 'UMLS MRSTY  Semantic types associated with concepts';




COPY INTO MRCONSO
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRCONSO.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRDEF
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRDEF.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRDOC
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRDOC.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRHIER
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRHIER.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRRANK
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRRANK.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRREL
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRREL.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRSAB
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSAB.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRSAT
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSAT.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');

COPY INTO MRSTY
FROM @DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.DAS_HEALTHCARE_CLAIMS_RAW_DB_INTERNAL_STAGE/MRSTY.RRF
FILE_FORMAT = (FORMAT_NAME='DAS.DAS_HEALTHCARE_CLAIMS_RAW_DB.UMLS_RRF_FORMAT');
