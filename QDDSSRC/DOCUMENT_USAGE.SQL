-- =====================================================================
-- Document Usage Tracking Table
-- Tracks document and API usage by date and region
-- =====================================================================

-- Uncomment the following line to drop existing table if needed
-- DROP TABLE DOCUMENT_USAGE;

-- Create the DOCUMENT_USAGE table
CREATE TABLE DOCUMENT_USAGE (
    -- Primary key with auto-increment
    USAGE_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (
        START WITH 1 INCREMENT BY 1
        NO CYCLE NO ORDER
    ),
    
    -- Date when the document/API was used
    USAGE_DATE DATE NOT NULL,
    
    -- Document region (state code), nullable
    DOC_REGIONS CHAR(2),
    
    -- Document code or API endpoint path
    DOCUMENT_CODE VARCHAR(100) NOT NULL,
    
    -- Timestamp when record was created
    CREATED_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Primary key constraint
    PRIMARY KEY (USAGE_ID)
);

-- Add descriptive labels for documentation
LABEL ON TABLE DOCUMENT_USAGE IS 'Document and API Usage Tracking';
LABEL ON COLUMN DOCUMENT_USAGE.USAGE_ID IS 'Usage Record ID';
LABEL ON COLUMN DOCUMENT_USAGE.USAGE_DATE IS 'Usage Date';
LABEL ON COLUMN DOCUMENT_USAGE.DOC_REGIONS IS 'Document Region (State)';
LABEL ON COLUMN DOCUMENT_USAGE.DOCUMENT_CODE IS 'Document Code or API Path';
LABEL ON COLUMN DOCUMENT_USAGE.CREATED_TIMESTAMP IS 'Record Creation Timestamp';
