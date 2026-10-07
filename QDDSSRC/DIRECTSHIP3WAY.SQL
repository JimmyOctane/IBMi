-- ============================================================================
-- Table: DIRECTSHIP3WAY
-- Source: /HOME/JFLANARY/DirectShip_3Way_match_2026d.csv
-- Description: DirectShip 3-way match detail rows loaded from CSV on IFS
-- ============================================================================

CREATE TABLE JAMIEDEV.DIRECTSHIP3WAY (
    TRNDTE           DECIMAL(6, 0)    NOT NULL,
    AP_VENDOR_NUMBER DECIMAL(5, 0)    NOT NULL,
    AP_VENDORS_NAME  VARCHAR(60)      NOT NULL,
    AP_INVOICE_NUMBER VARCHAR(20)     NOT NULL,
    RECEIVING_RPT_NO  DECIMAL(7, 0)    NOT NULL,
    PO_NUMBER         DECIMAL(7, 0)    NOT NULL,
    VARIANCE_REASON   CHAR(1),
    QTY_STOCKING_UOM  DECIMAL(15, 4),
    UNIT_PRICE        DECIMAL(15, 4),
    MATCHED_EXT_AMT   DECIMAL(15, 4),
    QTY_RCVD          DECIMAL(15, 4),
    ITEM_UNIT_COST    DECIMAL(15, 4),
    RECEIVING_EXT_AMT  DECIMAL(15, 4),
    DIFF              DECIMAL(15, 4),
    LOAD_TS           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (TRNDTE, AP_VENDOR_NUMBER, AP_INVOICE_NUMBER, RECEIVING_RPT_NO, PO_NUMBER)
);
