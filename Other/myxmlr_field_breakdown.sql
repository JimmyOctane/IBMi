-- SQL Query to Extract Bectran Customer XML Fields from MYXMLR
-- Based on the inbound-customer-data XML structure
-- Updated to handle XML namespace

WITH xml_data AS (
  -- Read the XML file from IFS and strip XML declaration
  SELECT XMLPARSE(DOCUMENT
    REGEXP_REPLACE(
      LISTAGG(Line, ''), '<\?xml[^>]*\?>',
      '', 1, 0, 'i')) AS doc
  FROM TABLE(QSYS2.IFS_READ(PATH_NAME => '/home/bectran/cus_xml_setup_20260224104026.xml'))
)
SELECT X.*
FROM xml_data,
XMLTABLE (
  XMLNAMESPACES(DEFAULT 'http://www.bectran.com/'),
  '$doc/inbound-customer-data/customer' PASSING xml_data.doc AS "doc"
COLUMNS
  -- Customer Attributes
  account_id VARCHAR(50) PATH '@account-id',
  transaction_id VARCHAR(50) PATH '@transaction-id',
  
  -- Basic Info Section
  addressLineOne VARCHAR(100) PATH 'basic-info/addressLineOne',
  addressLineTwo VARCHAR(100) PATH 'basic-info/addressLineTwo',
  annualSalesRange VARCHAR(50) PATH 'basic-info/annualSalesRange',
  bectranCustomerId VARCHAR(50) PATH 'basic-info/bectranCustomerId',
  city VARCHAR(50) PATH 'basic-info/city',
  contactPersonFirstName VARCHAR(50) PATH 'basic-info/contactPersonFirstName',
  contactPersonLastName VARCHAR(50) PATH 'basic-info/contactPersonLastName',
  contactPersonPhone VARCHAR(30) PATH 'basic-info/contactPersonPhone',
  contactPersonTitle VARCHAR(100) PATH 'basic-info/contactPersonTitle',
  countryId VARCHAR(10) PATH 'basic-info/countryId',
  customerDbaName VARCHAR(100) PATH 'basic-info/customerDbaName',
  customerLegalName VARCHAR(100) PATH 'basic-info/customerLegalName',
  dateCreatedInBectran VARCHAR(20) PATH 'basic-info/dateCreatedInBectran',
  dunsNumber VARCHAR(20) PATH 'basic-info/dunsNumber',
  fax VARCHAR(30) PATH 'basic-info/fax',
  businessEmail VARCHAR(100) PATH 'basic-info/businessEmail',
  federalTaxId VARCHAR(20) PATH 'basic-info/federalTaxId',
  numOfEmployee VARCHAR(50) PATH 'basic-info/numOfEmployee',
  phone VARCHAR(30) PATH 'basic-info/phone',
  state VARCHAR(10) PATH 'basic-info/state',
  stateOfIncorporation VARCHAR(10) PATH 'basic-info/stateOfIncorporation',
  styleOfBusiness VARCHAR(100) PATH 'basic-info/styleOfBusiness',
  typeOfBusiness VARCHAR(50) PATH 'basic-info/typeOfBusiness',
  yearEstablished VARCHAR(10) PATH 'basic-info/yearEstablished',
  zipCode VARCHAR(20) PATH 'basic-info/zipCode',
  contactPersonEmail VARCHAR(100) PATH 'basic-info/contactPersonEmail',
  
  -- Credit Request Info Section
  requestId VARCHAR(50) PATH 'credit-request-info/requestId',
  requestSource VARCHAR(50) PATH 'credit-request-info/requestSource',
  amountRequested DECIMAL(15,2) PATH 'credit-request-info/amountRequested',
  termRequestedCode VARCHAR(50) PATH 'credit-request-info/termRequestedCode',
  termRequestedDescription VARCHAR(100) PATH 'credit-request-info/termRequestedDescription',
  plannedPurchase VARCHAR(50) PATH 'credit-request-info/plannedPurchase',
  requestDate VARCHAR(20) PATH 'credit-request-info/requestDate',
  requestFormType VARCHAR(50) PATH 'credit-request-info/requestFormType',
  purchaseOrderRequired VARCHAR(10) PATH 'credit-request-info/purchaseOrderRequired',
  accountNumExist VARCHAR(10) PATH 'credit-request-info/accountNumExist',
  clientAccountId VARCHAR(50) PATH 'credit-request-info/clientAccountId',
  orderPending VARCHAR(10) PATH 'credit-request-info/orderPending',
  orderPendingAmount DECIMAL(15,2) PATH 'credit-request-info/orderPendingAmount',
  
  -- Customer Profile Detail - Style of Business
  styleOfBusinessBectranCode VARCHAR(50) PATH 'customer-profile-detail/styleOfBusiness/bectranInternalCode',
  styleOfBusinessClientCode VARCHAR(50) PATH 'customer-profile-detail/styleOfBusiness/clientInternalCode',
  styleOfBusinessDescription VARCHAR(100) PATH 'customer-profile-detail/styleOfBusiness/description',
  
  -- Customer Profile Detail - Type of Business
  typeOfBusinessBectranCode VARCHAR(50) PATH 'customer-profile-detail/typeOfBusiness/bectranInternalCode',
  typeOfBusinessClientCode VARCHAR(50) PATH 'customer-profile-detail/typeOfBusiness/clientInternalCode',
  typeOfBusinessDescription VARCHAR(100) PATH 'customer-profile-detail/typeOfBusiness/description',
  
  -- Customer Profile Detail - Annual Sales
  annualSalesBectranCode VARCHAR(50) PATH 'customer-profile-detail/annualSales/bectranInternalCode',
  annualSalesClientCode VARCHAR(50) PATH 'customer-profile-detail/annualSales/clientInternalCode',
  annualSalesDescription VARCHAR(100) PATH 'customer-profile-detail/annualSales/description',
  
  -- Customer Profile Detail - Number of Employees
  numOfEmployeeBectranCode VARCHAR(50) PATH 'customer-profile-detail/numOfEmployee/bectranInternalCode',
  numOfEmployeeClientCode VARCHAR(50) PATH 'customer-profile-detail/numOfEmployee/clientInternalCode',
  numOfEmployeeDescription VARCHAR(100) PATH 'customer-profile-detail/numOfEmployee/description'
) AS X;
