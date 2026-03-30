-- Combined SQL query that reads XML from IFS file and parses line items with XMLTABLE
-- This combines the IFS_READ function with XMLTABLE parsing for line_items

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
SELECT Y.*
FROM xml_data,
XMLTABLE ('$doc/transmission/order/line_items/line_item' PASSING xml_data.doc AS "doc"
COLUMNS
  line_number char(40) PATH 'line_number',
  type_code VARCHAR(40) PATH 'type_code',
  product_name VARCHAR(40) PATH 'product_name', 
  mincron_item_id VARCHAR(40) PATH 'mincron_item_id',
  external_item_id VARCHAR(40) PATH 'external_item_id', 
  pim_id VARCHAR(40) PATH 'pim_id',
  bundle_id VARCHAR(40) PATH 'bundle_id', 
  quantity VARCHAR(40) PATH 'quantity', 
  amount VARCHAR(40) PATH 'price/amount', 
  cost VARCHAR(40) PATH 'price/cost', 
  surcharge_amount VARCHAR(40) PATH 'price/surcharge_amount',
  taxAmount VARCHAR(40) PATH 'price/tax_info',
  taxPercent VARCHAR(40) PATH 'price/tax_info/percentage',
  price_override VARCHAR(40) PATH 'price/price_override' 
) AS Y;

-- Alternative approach using XMLCAST if needed:
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
SELECT Y.*
FROM xml_data,
XMLTABLE ('$doc/transmission/order/line_items/line_item' PASSING xml_data.doc AS "doc"
... rest of columns as above ...
) AS Y;
*/