/* ========================================================================== */
/* Table: XMLORDHDR                                                           */
/* Purpose: XML Order Header Information                                      */
/* Author: Roo Code                                                           */
/* Date: 2026-02-16                                                           */
/* Notes: Stores order header data extracted from Neuco XML files             */
/* ========================================================================== */

CREATE OR REPLACE TABLE XMLORDHDR (
  /* Order Identification */
  orderNumber         CHAR(40)        NOT NULL WITH DEFAULT,
  poNumber            VARCHAR(20),
  poNumber2           VARCHAR(20),
  jobName             VARCHAR(100),
  uniqueId            VARCHAR(50),
  
  /* Shipping Information */
  freightMethod       VARCHAR(20),
  requestedPickupTime TIMESTAMP,
  shipCode            VARCHAR(20),
  shipSubcode         VARCHAR(20),
  
  /* Vendor Information */
  vendorCode          VARCHAR(20),
  vendorName          VARCHAR(100),
  
  /* Order Details */
  placedDate          TIMESTAMP,
  branchSell          VARCHAR(10),
  branchShip          VARCHAR(10),
  specialInstructions VARCHAR(500),
  orderNotes          VARCHAR(500),
  chargeOrCash        VARCHAR(20),
  orderTypeCode       CHAR(1),
  orderStatusCode     CHAR(1),
  orderStatusCodeOverride VARCHAR(10),
  
  /* Financial Information (Numeric fields) */
  amount              DECIMAL(15,5),
  surchargeAmount     DECIMAL(15,5),
  freightCharges      DECIMAL(15,5),
  extraCharge         DECIMAL(15,5),
  taxAmount           DECIMAL(15,5),
  percentage          DECIMAL(7,4),
  overridePrice       DECIMAL(15,5),
  
  /* Customer Information */
  accountNumber       VARCHAR(20),
  accountName         VARCHAR(100),
  contact             VARCHAR(50),
  
  /* Ship To Address */
  city                VARCHAR(150),
  state               CHAR(2),
  zip                 VARCHAR(10),
  country             VARCHAR(50),
  addressLine1        VARCHAR(100),
  addressLine2        VARCHAR(100),
  addressLine3        VARCHAR(100),
  shipContact         VARCHAR(50),
  
  /* Bill To Address */
  billCity            VARCHAR(150),
  billState           CHAR(2),
  billZip             VARCHAR(10),
  billCountry         VARCHAR(50),
  billAddressLine1    VARCHAR(100),
  billAddressLine2    VARCHAR(100),
  billAddressLine3    VARCHAR(100),
  
  /* Payment Information */
  cardInfo            VARCHAR(100),
  
  /* Audit Fields */
  createdDate         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedDate         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  /* Processing Status Fields */
  processedFlag       CHAR(1) NOT NULL WITH DEFAULT,
  processedStamp      TIMESTAMP
);

/* Add column comments */
LABEL ON COLUMN XMLORDHDR
  (orderNumber IS 'Order Number',
   poNumber IS 'Purchase Order Number',
   poNumber2 IS 'Secondary PO Number',
   jobName IS 'Job Name',
   uniqueId IS 'Unique Identifier',
   freightMethod IS 'Freight Method Code',
   requestedPickupTime IS 'Requested Pickup Time',
   shipCode IS 'Ship Code',
   shipSubcode IS 'Ship Subcode',
   vendorCode IS 'Vendor Code',
   vendorName IS 'Vendor Name',
   placedDate IS 'Order Placed Date',
   branchSell IS 'Selling Branch',
   branchShip IS 'Shipping Branch',
   specialInstructions IS 'Special Instructions',
   orderNotes IS 'Order Notes',
   chargeOrCash IS 'Charge or Cash',
   orderTypeCode IS 'Order Type Code',
   orderStatusCode IS 'Order Status Code',
   orderStatusCodeOverride IS 'Order Status Override',
   amount IS 'Order Amount',
   surchargeAmount IS 'Surcharge Amount',
   freightCharges IS 'Freight Charges',
   extraCharge IS 'Extra Charges',
   taxAmount IS 'Tax Amount',
   percentage IS 'Tax Percentage',
   overridePrice IS 'Override Price',
   accountNumber IS 'Customer Account Number',
   accountName IS 'Customer Account Name',
   contact IS 'Contact Information',
   city IS 'Ship To City',
   state IS 'Ship To State',
   zip IS 'Ship To ZIP Code',
   country IS 'Ship To Country',
   addressLine1 IS 'Ship To Address Line 1',
   addressLine2 IS 'Ship To Address Line 2',
   addressLine3 IS 'Ship To Address Line 3',
   shipContact IS 'Ship To Contact',
   billCity IS 'Bill To City',
   billState IS 'Bill To State',
   billZip IS 'Bill To ZIP Code',
   billCountry IS 'Bill To Country',
   billAddressLine1 IS 'Bill To Address Line 1',
   billAddressLine2 IS 'Bill To Address Line 2',
   billAddressLine3 IS 'Bill To Address Line 3',
   cardInfo IS 'Card Information',
   createdDate IS 'Record Created Date',
   updatedDate IS 'Record Updated Date',
   processedFlag IS 'Processing Status Flag',
   processedStamp IS 'Processing Timestamp');

LABEL ON TABLE XMLORDHDR IS 'XML Order Header';
