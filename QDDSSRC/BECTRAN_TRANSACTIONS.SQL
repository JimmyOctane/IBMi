-- =====================================================================
-- Bectran Customer Transaction Table
-- =====================================================================
-- This table stores customer account information and credit application
-- requests from the Bectran credit management system.
-- =====================================================================

-- Drop table if it exists
DROP TABLE IF EXISTS BECCUSTP;

-- Create the main transaction table
CREATE TABLE BECCUSTP (
    -- Primary Key
    GUID CHAR(26) NOT NULL,
    
    -- Business Keys
    ACCTID VARCHAR(20) NOT NULL,
    TRANID INTEGER NOT NULL,
    
    -- Customer Address Information
    ADDR1 VARCHAR(100),
    ADDR2 VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(2),
    ZIPCODE VARCHAR(10),
    COUNTRYID VARCHAR(2),
    
    -- Annual Sales and Employee Information
    ANSALRNG VARCHAR(50),
    ANSALBEC VARCHAR(20),
    ANSALCLI VARCHAR(20),
    ANSALDSC VARCHAR(100),
    NUMEMP VARCHAR(50),
    NUMEMPBEC VARCHAR(20),
    NUMEMPCLI VARCHAR(20),
    NUMEMPDSC VARCHAR(100),
    
    -- Bectran System Information
    BECCUSTID VARCHAR(20),
    BECCRTDT DATE,
    
    -- Contact Person Information
    CNTFNAME VARCHAR(50),
    CNTLNAME VARCHAR(50),
    CNTPHONE VARCHAR(20),
    CNTTITLE VARCHAR(100),
    CNTEMAIL VARCHAR(100),
    
    -- Customer Business Information
    CUSTDBA VARCHAR(100),
    CUSTLEGAL VARCHAR(100),
    DUNSNUMBER VARCHAR(20),
    FAX VARCHAR(20),
    BUSEMAIL VARCHAR(100),
    FEDTAXID VARCHAR(20),
    PHONE VARCHAR(20),
    STINCORP VARCHAR(2),
    YRESTAB INTEGER,
    
    -- Business Type and Style
    STYLEBIZ VARCHAR(50),
    STYBIZBEC VARCHAR(50),
    STYBIZCLI VARCHAR(20),
    STYBIZDSC VARCHAR(100),
    TYPEBIZ VARCHAR(50),
    TYPBIZBEC VARCHAR(20),
    TYPBIZCLI VARCHAR(20),
    TYPBIZDSC VARCHAR(100),
    
    -- Credit Request Information
    REQUESTID INTEGER,
    REQSRC VARCHAR(50),
    AMTREQ DECIMAL(15,2),
    TERMREQCD VARCHAR(50),
    TERMREQDS VARCHAR(50),
    PLANPURCH VARCHAR(50),
    REQDATE DATE,
    REQFRMTYP VARCHAR(50),
    POREQ VARCHAR(3),
    
    -- Account Status Information
    ACNUMEXST VARCHAR(3),
    CLIACCTID VARCHAR(50),
    ORDPEND VARCHAR(3),
    ORDPNDAMT DECIMAL(15,2),
    STATUS CHAR(1) DEFAULT ' ',
    
    -- Customer Creation Tracking
    CUSTCRTBY VARCHAR(10),
    CUSTCRTTS TIMESTAMP,
    
    -- Audit Fields
    CRTTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Primary Key Constraint
    PRIMARY KEY (GUID)
);

-- Add comments to the table
LABEL ON TABLE BECCUSTP IS 'Bectran Customer Transaction Data';

LABEL ON COLUMN BECCUSTP (
    GUID IS 'Unique Record Identifier (26-char GUID)',
    ACCTID IS 'Bectran Account ID',
    TRANID IS 'Transaction ID',
    ADDR1 IS 'Address Line 1',
    ADDR2 IS 'Address Line 2',
    CITY IS 'City',
    STATE IS 'State Code',
    ZIPCODE IS 'ZIP/Postal Code',
    COUNTRYID IS 'Country Code',
    ANSALRNG IS 'Annual Sales Range',
    ANSALBEC IS 'Annual Sales Bectran Code',
    ANSALCLI IS 'Annual Sales Client Code',
    ANSALDSC IS 'Annual Sales Description',
    NUMEMP IS 'Number of Employees',
    NUMEMPBEC IS 'Number of Employees Bectran Code',
    NUMEMPCLI IS 'Number of Employees Client Code',
    NUMEMPDSC IS 'Number of Employees Description',
    BECCUSTID IS 'Bectran Customer ID',
    BECCRTDT IS 'Date Created in Bectran',
    CNTFNAME IS 'Contact First Name',
    CNTLNAME IS 'Contact Last Name',
    CNTPHONE IS 'Contact Phone',
    CNTTITLE IS 'Contact Title',
    CNTEMAIL IS 'Contact Email',
    CUSTDBA IS 'Customer DBA Name',
    CUSTLEGAL IS 'Customer Legal Name',
    DUNSNUMBER IS 'DUNS Number',
    FAX IS 'Fax Number',
    BUSEMAIL IS 'Business Email',
    FEDTAXID IS 'Federal Tax ID',
    PHONE IS 'Business Phone',
    STINCORP IS 'State of Incorporation',
    YRESTAB IS 'Year Established',
    STYLEBIZ IS 'Style of Business',
    STYBIZBEC IS 'Style of Business Bectran Code',
    STYBIZCLI IS 'Style of Business Client Code',
    STYBIZDSC IS 'Style of Business Description',
    TYPEBIZ IS 'Type of Business',
    TYPBIZBEC IS 'Type of Business Bectran Code',
    TYPBIZCLI IS 'Type of Business Client Code',
    TYPBIZDSC IS 'Type of Business Description',
    REQUESTID IS 'Request ID',
    REQSRC IS 'Request Source',
    AMTREQ IS 'Amount Requested',
    TERMREQCD IS 'Term Requested Code',
    TERMREQDS IS 'Term Requested Description',
    PLANPURCH IS 'Planned Purchase Amount',
    REQDATE IS 'Request Date',
    REQFRMTYP IS 'Request Form Type',
    POREQ IS 'Purchase Order Required',
    ACNUMEXST IS 'Account Number Exists',
    CLIACCTID IS 'Client Account ID',
    ORDPEND IS 'Order Pending',
    ORDPNDAMT IS 'Order Pending Amount',
    STATUS IS 'Status: '' ''=Pending E=Error X=Exclude C=Created',
    CUSTCRTBY IS 'Customer Created By User',
    CUSTCRTTS IS 'Customer Created Timestamp',
    CRTTS IS 'Created Timestamp',
    UPDTS IS 'Updated Timestamp'
);
