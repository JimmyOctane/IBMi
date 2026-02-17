/* =============================================================  */
/* Table: XMLORDDTL                                               */
/* Purpose: XML Order Detail Information                          */
/* Author: Roo Code                                               */
/* Date: 2026-02-16                                               */
/* Notes: Stores order detail data extracted from Neuco XML files */
/* ============================================================== */

CREATE OR REPLACE TABLE TKTEST.XMLORDDTL (
  /* Link to Header */
  orderNumber         CHAR(40)        NOT NULL WITH DEFAULT,
  
  /* Line Item Identification */
  lineNumber          INT             NOT NULL WITH DEFAULT,
  typeCode            VARCHAR(20),
  
  /* Product Information */
  productName         VARCHAR(100),
  mincronItemId       VARCHAR(50),
  externalItemId      VARCHAR(50),
  pimId               VARCHAR(50),
  bundleId            VARCHAR(50),
  
  /* Quantity and Pricing (Numeric fields) */
  quantity            DECIMAL(11,3),
  amount              DECIMAL(15,5),
  cost                DECIMAL(15,5),
  surchargeAmount     DECIMAL(15,5),
  taxAmount           DECIMAL(15,5),
  taxPercent          DECIMAL(7,4),
  priceOverride       DECIMAL(15,5),
  
  /* Audit Fields */
  createdDate         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedDate         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  /* Primary Key */
  CONSTRAINT PK_XMLORDDTL PRIMARY KEY (orderNumber, lineNumber),
  
  /* Foreign Key to Header */
  CONSTRAINT FK_XMLORDDTL_HDR FOREIGN KEY (orderNumber)
    REFERENCES TKTEST.XMLORDHDR (orderNumber)
    ON DELETE CASCADE
);

/* Create indexes for common queries */
CREATE INDEX IDX_XMLORDDTL_PROD ON TKTEST.XMLORDDTL (productName);
CREATE INDEX IDX_XMLORDDTL_EXT ON TKTEST.XMLORDDTL (externalItemId);
CREATE INDEX IDX_XMLORDDTL_TYPE ON TKTEST.XMLORDDTL (typeCode);

/* Add column comments */
LABEL ON COLUMN TKTEST.XMLORDDTL
  (orderNumber IS 'Order Number',
   lineNumber IS 'Line Item Number',
   typeCode IS 'Line Item Type Code',
   productName IS 'Product Name/Number',
   mincronItemId IS 'Mincron Item ID',
   externalItemId IS 'External Item ID',
   pimId IS 'PIM ID',
   bundleId IS 'Bundle ID',
   quantity IS 'Quantity Ordered',
   amount IS 'Line Item Amount',
   cost IS 'Line Item Cost',
   surchargeAmount IS 'Surcharge Amount',
   taxAmount IS 'Tax Amount',
   taxPercent IS 'Tax Percentage',
   priceOverride IS 'Price Override',
   createdDate IS 'Record Created Date',
   updatedDate IS 'Record Updated Date');

LABEL ON TABLE TKTEST.XMLORDDTL IS 'XML Order Detail';
