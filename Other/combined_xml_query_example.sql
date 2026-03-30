-- Combined SQL query that reads XML from IFS file and parses it with XMLTABLE
-- This combines the IFS_READ function with XMLTABLE parsing

WITH xml_data AS (
  -- Read the XML file from IFS and strip XML declaration
  SELECT XMLPARSE(DOCUMENT
    REGEXP_REPLACE(
      LISTAGG(Line, ''),
      '<\?xml[^>]*\?>',
      '',
      1, 0, 'i'
    )
  ) AS doc
  FROM TABLE(QSYS2.IFS_READ(PATH_NAME =>
    '/home/Nueco/BK_994681_order_9855f665-5b2f-40c8-b0e6-68e369b97825.xml'))
)
SELECT X.*
FROM xml_data,
XMLTABLE ('$doc/transmission/order' PASSING xml_data.doc AS "doc"
COLUMNS
  order_number char(40) PATH 'OrderHeader/order_info/order_number',
  po_number VARCHAR(20) PATH 'OrderHeader/order_info/po_number',
  po_number_2 VARCHAR(20) PATH 'OrderHeader/order_info/po_number_2',
  job_name VARCHAR(40) PATH 'OrderHeader/order_info/job_name',
  unique_id VARCHAR(40) PATH 'OrderHeader/order_info/unique_id',
  freight_method VARCHAR(40) PATH 'OrderHeader/order_info/freight_method',
  vendor_code VARCHAR(40) PATH 'OrderHeader/order_info/vendor_code',
  vendor_name VARCHAR(40) PATH 'OrderHeader/order_info/vendor_name',
  placed_date VARCHAR(40) PATH 'OrderHeader/order_info/placed_date', 
  requested_pickup_time VARCHAR(40) PATH 'OrderHeader/order_info/requested_pickup_time',
  branch_sell VARCHAR(40) PATH 'OrderHeader/order_info/branch_sell',
  branch_ship VARCHAR(40) PATH 'OrderHeader/order_info/branch_ship',
  ship_code VARCHAR(40) PATH 'OrderHeader/order_info/ship_code',
  ship_subcode VARCHAR(40) PATH 'OrderHeader/order_info/ship_subcode',
  special_instructions VARCHAR(40) PATH 'OrderHeader/order_info/special_instructions',
  order_notes VARCHAR(40) PATH 'OrderHeader/order_info/order_notes',
  charge_or_cash VARCHAR(40) PATH 'OrderHeader/order_info/charge_or_cash',
  order_type_code VARCHAR(40) PATH 'OrderHeader/order_info/order_type_code',
  order_status_code VARCHAR(40) PATH 'OrderHeader/order_info/order_status_code',
  order_status_code_override VARCHAR(40) PATH 'OrderHeader/order_info/order_status_code_override',
  amount VARCHAR(40) PATH 'OrderHeader/price_header/amount', 
  surcharge_amount VARCHAR(40) PATH 'OrderHeader/price_header/surcharge_amount',
  freight_charges VARCHAR(40) PATH 'OrderHeader/price_header/extra_charges/freight_charges',  
  extra_charge VARCHAR(40) PATH 'OrderHeader/price_header/extra_charges/extra_charge',
  taxAmount VARCHAR(40) PATH 'OrderHeader/price_header/tax_info/amount',  
  percentage VARCHAR(40) PATH 'OrderHeader/price_header/tax_info/percentage', 
  override_price VARCHAR(40) PATH 'OrderHeader/price_header/override_price',   
  account_number VARCHAR(40) PATH 'OrderHeader/customer_info/account_number',   
  account_name VARCHAR(40) PATH 'OrderHeader/customer_info/account_name',     
  contact VARCHAR(40) PATH 'OrderHeader/customer_info/contact',     
  city VARCHAR(150) PATH 'OrderHeader/ship_to_info/address/city',   
  state VARCHAR(2) PATH 'OrderHeader/ship_to_info/address/state',   
  zip VARCHAR(10) PATH 'OrderHeader/ship_to_info/address/zip',   
  country VARCHAR(40) PATH 'OrderHeader/ship_to_info/address/country',    
  address_line_1 VARCHAR(40) PATH 'OrderHeader/ship_to_info/address/address_line_1',   
  address_line_2 VARCHAR(40) PATH 'OrderHeader/ship_to_info/address/address_line_2',
  address_line_3 VARCHAR(40) PATH 'OrderHeader/ship_to_info/address/address_line_3', 
  ShipContact VARCHAR(40) PATH 'OrderHeader/ship_to_info/contact',  
  BillCity VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/city',  
  Billstate VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/state',  
  Billzip VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/zip',  
  Billcountry VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/country',  
  Billaddress_line_1 VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/address_line_1',  
  Billaddress_line_2 VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/address_line_2',  
  Billaddress_line_3 VARCHAR(40) PATH 'OrderHeader/billing/bill_to_info/address/address_line_3',
  card_info VARCHAR(40) PATH 'OrderHeader/billing/card_info'
) AS X;

-- Alternative approaches if the main query still has issues:

-- Option 1: Using XMLCAST with XML declaration stripped
/*
WITH xml_data AS (
  SELECT XMLCAST(
    REGEXP_REPLACE(
      LISTAGG(Line, ''),
      '<\?xml[^>]*\?>',
      '',
      1, 0, 'i'
    ) AS XML
  ) AS doc
  FROM TABLE(QSYS2.IFS_READ(PATH_NAME =>
    '/home/Nueco/BK_994681_order_9855f665-5b2f-40c8-b0e6-68e369b97825.xml'))
)
SELECT X.*
FROM xml_data,
XMLTABLE ('$doc/transmission/order' PASSING xml_data.doc AS "doc"
... rest of columns as above ...
) AS X;
*/

-- Option 2: Simple concatenation without XML parsing (if XML functions continue to fail)
/*
WITH xml_string AS (
  SELECT LISTAGG(Line, '') AS xml_content
  FROM TABLE(QSYS2.IFS_READ(PATH_NAME =>
    '/home/Nueco/BK_994681_order_9855f665-5b2f-40c8-b0e6-68e369b97825.xml'))
)
SELECT X.*
FROM xml_string,
XMLTABLE ('$xml/transmission/order' PASSING XMLPARSE(DOCUMENT xml_string.xml_content) AS "xml"
... rest of columns as above ...
) AS X;
*/