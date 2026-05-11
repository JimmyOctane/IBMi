-- Table to store customer totals from CSV file
-- File: /home/NEUCO/*.csv
-- Format: Customer Number, total$

CREATE TABLE JAMIEDEV.CUSTOMER_TOTALS (
    CUST_NBR DECIMAL(11, 0) NOT NULL,
    TOTAL_AMT DECIMAL(15, 2) NOT NULL,
    LOAD_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CUST_NBR)
);

LABEL ON TABLE JAMIEDEV.CUSTOMER_TOTALS 
    IS 'Customer Totals from CSV';

LABEL ON COLUMN JAMIEDEV.CUSTOMER_TOTALS (
    CUST_NBR IS 'Customer Number',
    TOTAL_AMT IS 'Total Amount',
    LOAD_DATE IS 'Date Loaded'
);
