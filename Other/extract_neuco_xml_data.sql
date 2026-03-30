-- Enhanced SQL script to extract specific data from Neuco XML transmission files
-- Based on the provided XML structure for order transmissions

-- Query to extract order header information
select 
  file_name,
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_id,
  xmlquery('$doc//transmission_header/type/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_type,
  xmlquery('$doc//transmission_header/timestamps/created/text()'
    passing xmlparse(document xml_content) as "doc") as created_date,
  xmlquery('$doc//order_info/job_name/text()'
    passing xmlparse(document xml_content) as "doc") as job_name,
  xmlquery('$doc//order_info/vendor_code/text()'
    passing xmlparse(document xml_content) as "doc") as vendor_code,
  xmlquery('$doc//order_info/vendor_name/text()'
    passing xmlparse(document xml_content) as "doc") as vendor_name,
  xmlquery('$doc//order_info/placed_date/text()'
    passing xmlparse(document xml_content) as "doc") as placed_date,
  xmlquery('$doc//order_info/branch_sell/text()'
    passing xmlparse(document xml_content) as "doc") as branch_sell,
  xmlquery('$doc//order_info/ship_code/text()'
    passing xmlparse(document xml_content) as "doc") as ship_code
from session.xml_files
where upper(file_name) like '%.XML';

-- Query to extract customer information
select 
  file_name,
  xmlquery('$doc//customer_info/account_number/text()'
    passing xmlparse(document xml_content) as "doc") as account_number,
  xmlquery('$doc//customer_info/account_name/text()'
    passing xmlparse(document xml_content) as "doc") as account_name,
  xmlquery('$doc//customer_info/contact/text()'
    passing xmlparse(document xml_content) as "doc") as contact_phone
from session.xml_files
where upper(file_name) like '%.XML';

-- Query to extract shipping address
select 
  file_name,
  xmlquery('$doc//ship_to_info/address/address_line_1/text()'
    passing xmlparse(document xml_content) as "doc") as ship_address_1,
  xmlquery('$doc//ship_to_info/address/city/text()'
    passing xmlparse(document xml_content) as "doc") as ship_city,
  xmlquery('$doc//ship_to_info/address/state/text()'
    passing xmlparse(document xml_content) as "doc") as ship_state,
  xmlquery('$doc//ship_to_info/address/zip/text()'
    passing xmlparse(document xml_content) as "doc") as ship_zip
from session.xml_files
where upper(file_name) like '%.XML';

-- Query to extract line item details using XMLTABLE
select 
  f.file_name,
  x.line_number,
  x.type_code,
  x.product_name,
  x.external_item_id,
  x.quantity,
  x.amount,
  x.cost
from session.xml_files f,
xmltable('$doc//line_item'
  passing xmlparse(document f.xml_content) as "doc"
  columns
    line_number int path 'line_number',
    type_code varchar(10) path 'type_code',
    product_name varchar(100) path 'product_name',
    external_item_id varchar(50) path 'external_item_id',
    quantity decimal(10,2) path 'quantity',
    amount decimal(12,2) path 'price/amount',
    cost decimal(12,2) path 'price/cost'
) as x
where upper(f.file_name) like '%.XML';

-- Query to extract pricing information
select 
  file_name,
  xmlquery('$doc//extra_charges/freight_charges/text()'
    passing xmlparse(document xml_content) as "doc") as freight_charges,
  xmlquery('$doc//price_header/amount/text()'
    passing xmlparse(document xml_content) as "doc") as total_amount
from session.xml_files
where upper(file_name) like '%.XML';

-- Comprehensive order summary view
select 
  f.file_name,
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_id,
  xmlquery('$doc//order_info/job_name/text()'
    passing xmlparse(document xml_content) as "doc") as job_name,
  xmlquery('$doc//customer_info/account_number/text()'
    passing xmlparse(document xml_content) as "doc") as account_number,
  xmlquery('$doc//customer_info/account_name/text()'
    passing xmlparse(document xml_content) as "doc") as account_name,
  count(x.line_number) as line_item_count,
  sum(x.quantity) as total_quantity,
  sum(x.amount) as total_line_amount
from session.xml_files f,
xmltable('$doc//line_item'
  passing xmlparse(document f.xml_content) as "doc"
  columns
    line_number int path 'line_number',
    quantity decimal(10,2) path 'quantity',
    amount decimal(12,2) path 'price/amount'
) as x
where upper(f.file_name) like '%.XML'
group by 
  f.file_name,
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document xml_content) as "doc"),
  xmlquery('$doc//order_info/job_name/text()'
    passing xmlparse(document xml_content) as "doc"),
  xmlquery('$doc//customer_info/account_number/text()'
    passing xmlparse(document xml_content) as "doc"),
  xmlquery('$doc//customer_info/account_name/text()'
    passing xmlparse(document xml_content) as "doc");