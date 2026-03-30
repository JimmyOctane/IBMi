-- ============================================
-- SQL Queries to Read Bectran Customer XML Data
-- Based on inbound-customer-data XML structure
-- Namespace: http://www.bectran.com/
-- ============================================

-- ============================================
-- Query 1: Extract Basic Customer Information
-- ============================================
SELECT
    CUST.ACCOUNT_ID,
    CUST.TRANSACTION_ID,
    BI.ADDRESSLINEONE,
    BI.ADDRESSLINETWO,
    BI.ANNUALSALESRANGE,
    BI.BECTRANCUSTOMERID,
    BI.CITY,
    BI.CONTACTFIRST,
    BI.CONTACTLAST,
    BI.CONTACTPHONE,
    BI.CONTACTTITLE,
    BI.COUNTRYID,
    BI.DBANAME,
    BI.LEGALNAME,
    BI.DATECREATED,
    BI.DUNSNUMBER,
    BI.FAX,
    BI.BUSINESSEMAIL,
    BI.FEDTAXID,
    BI.NUMEMPLOYEES,
    BI.PHONE,
    BI.STATE,
    BI.STATEOFINC,
    BI.STYLEOFBUSINESS,
    BI.TYPEOFBUSINESS,
    BI.YEARESTABLISHED,
    BI.ZIPCODE,
    BI.CONTACTEMAIL
FROM MYLIB.CUSTXML X
-- Root customer node
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT 'http://www.bectran.com/'),
    '/inbound-customer-data/customer'
    PASSING X.XMLDATA
    COLUMNS
        ACCOUNT_ID      VARCHAR(40)  PATH '@account-id',
        TRANSACTION_ID  VARCHAR(40)  PATH '@transaction-id'
) AS CUST
-- basic-info section
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT 'http://www.bectran.com/'),
    '/inbound-customer-data/customer/basic-info'
    PASSING X.XMLDATA
    COLUMNS
        ADDRESSLINEONE      VARCHAR(200) PATH 'addressLineOne',
        ADDRESSLINETWO      VARCHAR(200) PATH 'addressLineTwo',
        ANNUALSALESRANGE    VARCHAR(200) PATH 'annualSalesRange',
        BECTRANCUSTOMERID   VARCHAR(40)  PATH 'bectranCustomerId',
        CITY                VARCHAR(100) PATH 'city',
        CONTACTFIRST        VARCHAR(100) PATH 'contactPersonFirstName',
        CONTACTLAST         VARCHAR(100) PATH 'contactPersonLastName',
        CONTACTPHONE        VARCHAR(40)  PATH 'contactPersonPhone',
        CONTACTTITLE        VARCHAR(100) PATH 'contactPersonTitle',
        COUNTRYID           VARCHAR(10)  PATH 'countryId',
        DBANAME             VARCHAR(200) PATH 'customerDbaName',
        LEGALNAME           VARCHAR(200) PATH 'customerLegalName',
        DATECREATED         VARCHAR(20)  PATH 'dateCreatedInBectran',
        DUNSNUMBER          VARCHAR(40)  PATH 'dunsNumber',
        FAX                 VARCHAR(40)  PATH 'fax',
        BUSINESSEMAIL       VARCHAR(200) PATH 'businessEmail',
        FEDTAXID            VARCHAR(40)  PATH 'federalTaxId',
        NUMEMPLOYEES        VARCHAR(40)  PATH 'numOfEmployee',
        PHONE               VARCHAR(40)  PATH 'phone',
        STATE               VARCHAR(10)  PATH 'state',
        STATEOFINC          VARCHAR(10)  PATH 'stateOfIncorporation',
        STYLEOFBUSINESS     VARCHAR(200) PATH 'styleOfBusiness',
        TYPEOFBUSINESS      VARCHAR(40)  PATH 'typeOfBusiness',
        YEARESTABLISHED     VARCHAR(10)  PATH 'yearEstablished',
        ZIPCODE             VARCHAR(20)  PATH 'zipCode',
        CONTACTEMAIL        VARCHAR(200) PATH 'contactPersonEmail'
) AS BI;

-- ============================================
-- Query 2: Extract Tax Exempt Information
-- ============================================
SELECT
    CUST.ACCOUNT_ID,
    CUST.TRANSACTION_ID,
    TAX.CERTNUM,
    TAX.STATECODE,
    TAX.EXPIRATION,
    TAX.HASEXPIRATIONDATE,
    TAX.DOCIMAGEURL
FROM MYLIB.CUSTXML X
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT ''http://www.bectran.com/''),
    ''/inbound-customer-data/customer''
    PASSING X.XMLDATA
    COLUMNS
        ACCOUNT_ID      VARCHAR(40)  PATH ''@account-id'',
        TRANSACTION_ID  VARCHAR(40)  PATH ''@transaction-id''
) AS CUST
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT ''http://www.bectran.com/''),
    ''/inbound-customer-data/customer/tax-exempt-info/entry''
    PASSING X.XMLDATA
    COLUMNS
        CERTNUM             VARCHAR(40)  PATH ''certNum'',
        STATECODE           VARCHAR(10)  PATH ''stateCode'',
        EXPIRATION          VARCHAR(30)  PATH ''expiration'',
        HASEXPIRATIONDATE   VARCHAR(10)  PATH ''hasExpirationDate'',
        DOCIMAGEURL         VARCHAR(500) PATH ''docImageUrl''
) AS TAX;

-- ============================================
-- Query 3: Extract Owner/Officer Information
-- ============================================
SELECT
    CUST.ACCOUNT_ID,
    CUST.TRANSACTION_ID,
    OWN.SALUTATION,
    OWN.FIRSTNAME,
    OWN.LASTNAME,
    OWN.PHONE,
    OWN.PERSTITLE,
    OWN.SSN,
    OWN.DRIVERSLICENCE,
    OWN.OWNERPERCENTAGE,
    OWN.DATEOFBIRTH,
    OWN.SPOUSENAME,
    OWN.SPOUSEDRIVERSLICENCE,
    OWN.SPOUSESSN,
    OWN.EMAIL,
    OWN.FAX,
    OWN.ADDRESSLINEONE,
    OWN.ADDRESSLINETWO,
    OWN.CITY,
    OWN.STATE,
    OWN.COUNTRYID,
    OWN.ZIPCODE
FROM MYLIB.CUSTXML X
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT ''http://www.bectran.com/''),
    ''/inbound-customer-data/customer''
    PASSING X.XMLDATA
    COLUMNS
        ACCOUNT_ID      VARCHAR(40)  PATH ''@account-id'',
        TRANSACTION_ID  VARCHAR(40)  PATH ''@transaction-id''
) AS CUST
CROSS JOIN XMLTABLE(
    XMLNAMESPACES(DEFAULT ''http://www.bectran.com/''),
    ''/inbound-customer-data/customer/owner-officer-info/entry''
    PASSING X.XMLDATA
    COLUMNS
        SALUTATION              VARCHAR(20)  PATH ''salutation'',
        FIRSTNAME               VARCHAR(100) PATH ''firstName'',
        LASTNAME                VARCHAR(100) PATH ''lastName'',
        PHONE                   VARCHAR(40)  PATH ''phone'',
        PERSTITLE               VARCHAR(100) PATH ''persTitle'',
        SSN                     VARCHAR(20)  PATH ''ssn'',
        DRIVERSLICENCE          VARCHAR(40)  PATH ''driversLicence'',
        OWNERPERCENTAGE         VARCHAR(10)  PATH ''ownerPercentage'',
        DATEOFBIRTH             VARCHAR(20)  PATH ''dateOfBirth'',
        SPOUSENAME              VARCHAR(100) PATH ''spouseName'',
        SPOUSEDRIVERSLICENCE    VARCHAR(40)  PATH ''spouseDriversLicence'',
        SPOUSESSN               VARCHAR(20)  PATH ''spouseSsn'',
        EMAIL                   VARCHAR(200) PATH ''email'',
        FAX                     VARCHAR(40)  PATH ''fax'',
        ADDRESSLINEONE          VARCHAR(200) PATH ''addressLineOne'',
        ADDRESSLINETWO          VARCHAR(200) PATH ''addressLineTwo'',
        CITY                    VARCHAR(100) PATH ''city'',
        STATE                   VARCHAR(10)  PATH ''state'',
        COUNTRYID               VARCHAR(10)  PATH ''countryId'',
        ZIPCODE                 VARCHAR(20)  PATH ''zipCode''
) AS OWN;
