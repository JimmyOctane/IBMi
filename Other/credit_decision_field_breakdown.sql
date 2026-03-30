-- SQL Query to Extract Bectran Credit Decision XML Fields
-- Based on the customer-data XML structure with credit-decision-info

WITH xml_data AS (
  -- Read the XML file from IFS and strip XML declaration
  SELECT XMLPARSE(DOCUMENT
    REGEXP_REPLACE(
      LISTAGG(Line, ''), '<\?xml[^>]*\?>',
      '', 1, 0, 'i')) AS doc
  FROM TABLE(QSYS2.IFS_READ(PATH_NAME => '/home/bectran/cred_deci_20260224104027.xml'))
)
SELECT X.*
FROM xml_data,
XMLTABLE (
  XMLNAMESPACES(DEFAULT 'http://www.bectran.com/'),
  '$doc/customer-data/customer' PASSING xml_data.doc AS "doc"
COLUMNS
  -- Customer Attributes
  account_id VARCHAR(50) PATH '@account-id',
  
  -- Credit Decision Info Section
  amountRequested DECIMAL(15,2) PATH 'credit-decision-info/amountRequested',
  approvedLimit DECIMAL(15,2) PATH 'credit-decision-info/approvedLimit',
  clientAccountId VARCHAR(50) PATH 'credit-decision-info/clientAccountId',
  creditTerm VARCHAR(100) PATH 'credit-decision-info/creditTerm',
  creditTermCode VARCHAR(50) PATH 'credit-decision-info/creditTermCode',
  riskRating VARCHAR(20) PATH 'credit-decision-info/riskRating',
  riskRatingClass VARCHAR(20) PATH 'credit-decision-info/riskRatingClass',
  rawScore DECIMAL(10,2) PATH 'credit-decision-info/rawScore',
  transactionId VARCHAR(50) PATH 'credit-decision-info/transactionId',
  creditDecision VARCHAR(50) PATH 'credit-decision-info/creditDecision',
  decisionDate VARCHAR(20) PATH 'credit-decision-info/decisionDate',
  nextReviewDate VARCHAR(20) PATH 'credit-decision-info/nextReviewDate',
  
  -- Credit Request Info Section
  requestId VARCHAR(50) PATH 'credit-request-info/requestId',
  requestSource VARCHAR(50) PATH 'credit-request-info/requestSource',
  requestAmountRequested DECIMAL(15,2) PATH 'credit-request-info/amountRequested',
  termRequestedCode VARCHAR(50) PATH 'credit-request-info/termRequestedCode',
  termRequestedDescription VARCHAR(100) PATH 'credit-request-info/termRequestedDescription',
  plannedPurchase VARCHAR(50) PATH 'credit-request-info/plannedPurchase',
  requestDate VARCHAR(20) PATH 'credit-request-info/requestDate',
  requestFormType VARCHAR(50) PATH 'credit-request-info/requestFormType',
  purchaseOrderRequired VARCHAR(10) PATH 'credit-request-info/purchaseOrderRequired',
  accountNumExist VARCHAR(10) PATH 'credit-request-info/accountNumExist',
  requestClientAccountId VARCHAR(50) PATH 'credit-request-info/clientAccountId',
  orderPending VARCHAR(10) PATH 'credit-request-info/orderPending',
  orderPendingAmount DECIMAL(15,2) PATH 'credit-request-info/orderPendingAmount',
  
  -- Customer Basic Info Section
  addressLineOne VARCHAR(100) PATH 'customer-basic-info/addressLineOne',
  addressLineTwo VARCHAR(100) PATH 'customer-basic-info/addressLineTwo',
  annualSalesRange VARCHAR(50) PATH 'customer-basic-info/annualSalesRange',
  bectranCustomerId VARCHAR(50) PATH 'customer-basic-info/bectranCustomerId',
  city VARCHAR(50) PATH 'customer-basic-info/city',
  contactPersonFirstName VARCHAR(50) PATH 'customer-basic-info/contactPersonFirstName',
  contactPersonLastName VARCHAR(50) PATH 'customer-basic-info/contactPersonLastName',
  contactPersonPhone VARCHAR(30) PATH 'customer-basic-info/contactPersonPhone',
  contactPersonTitle VARCHAR(100) PATH 'customer-basic-info/contactPersonTitle',
  countryId VARCHAR(10) PATH 'customer-basic-info/countryId',
  customerDbaName VARCHAR(100) PATH 'customer-basic-info/customerDbaName',
  customerLegalName VARCHAR(100) PATH 'customer-basic-info/customerLegalName',
  dateCreatedInBectran VARCHAR(20) PATH 'customer-basic-info/dateCreatedInBectran',
  dunsNumber VARCHAR(20) PATH 'customer-basic-info/dunsNumber',
  fax VARCHAR(30) PATH 'customer-basic-info/fax',
  federalTaxId VARCHAR(20) PATH 'customer-basic-info/federalTaxId',
  numOfEmployee VARCHAR(50) PATH 'customer-basic-info/numOfEmployee',
  phone VARCHAR(30) PATH 'customer-basic-info/phone',
  state VARCHAR(10) PATH 'customer-basic-info/state',
  stateOfIncorporation VARCHAR(10) PATH 'customer-basic-info/stateOfIncorporation',
  styleOfBusiness VARCHAR(100) PATH 'customer-basic-info/styleOfBusiness',
  typeOfBusiness VARCHAR(50) PATH 'customer-basic-info/typeOfBusiness',
  yearEstablished VARCHAR(10) PATH 'customer-basic-info/yearEstablished',
  zipCode VARCHAR(20) PATH 'customer-basic-info/zipCode',
  contactPersonEmail VARCHAR(100) PATH 'customer-basic-info/contactPersonEmail',
  
  -- Additional Info Section
  personalGuaranteeCode VARCHAR(50) PATH 'additional-Info/entry/internal-code',
  personalGuaranteeDesc VARCHAR(200) PATH 'additional-Info/entry/description',
  personalGuaranteeValue VARCHAR(10) PATH 'additional-Info/entry/value',
  personalGuaranteeDataType VARCHAR(50) PATH 'additional-Info/entry/data-type'
) AS X;
