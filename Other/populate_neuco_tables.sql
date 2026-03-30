-- Insert parsed XML data into normalized Neuco tables
-- Run this after executing the read_xml_ifs program and creating tables

-- Insert order data
insert into session.neuco_orders (
  transmission_id,
  transmission_type,
  created_date,
  updated_date,
  job_name,
  vendor_code,
  vendor_name,
  placed_date,
  promised_date,
  branch_sell,
  branch_ship,
  ship_code,
  order_type_code,
  order_status_code,
  freight_charges,
  file_name
)
select 
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_id,
  xmlquery('$doc//transmission_header/type/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_type,
  timestamp(xmlquery('$doc//transmission_header/timestamps/created/text()'
    passing xmlparse(document xml_content) as "doc")) as created_date,
  timestamp(xmlquery('$doc//transmission_header/timestamps/updated/text()'
    passing xmlparse(document xml_content) as "doc")) as updated_date,
  xmlquery('$doc//order_info/job_name/text()'
    passing xmlparse(document xml_content) as "doc") as job_name,
  xmlquery('$doc//order_info/vendor_code/text()'
    passing xmlparse(document xml_content) as "doc") as vendor_code,
  xmlquery('$doc//order_info/vendor_name/text()'
    passing xmlparse(document xml_content) as "doc") as vendor_name,
  timestamp(xmlquery('$doc//order_info/placed_date/text()'
    passing xmlparse(document xml_content) as "doc")) as placed_date,
  timestamp(xmlquery('$doc//order_info/promised_date/text()'
    passing xmlparse(document xml_content) as "doc")) as promised_date,
  xmlquery('$doc//order_info/branch_sell/text()'
    passing xmlparse(document xml_content) as "doc") as branch_sell,
  xmlquery('$doc//order_info/branch_ship/text()'
    passing xmlparse(document xml_content) as "doc") as branch_ship,
  xmlquery('$doc//order_info/ship_code/text()'
    passing xmlparse(document xml_content) as "doc") as ship_code,
  xmlquery('$doc//order_info/order_type_code/text()'
    passing xmlparse(document xml_content) as "doc") as order_type_code,
  xmlquery('$doc//order_info/order_status_code/text()'
    passing xmlparse(document xml_content) as "doc") as order_status_code,
  decimal(xmlquery('$doc//extra_charges/freight_charges/text()'
    passing xmlparse(document xml_content) as "doc"), 12, 2) as freight_charges,
  file_name
from session.xml_files
where upper(file_name) like '%.XML';

-- Insert customer data
insert into session.neuco_customers (
  transmission_id,
  account_number,
  account_name,
  contact_phone,
  ship_address_1,
  ship_address_2,
  ship_city,
  ship_state,
  ship_zip,
  ship_country
)
select 
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document xml_content) as "doc") as transmission_id,
  xmlquery('$doc//customer_info/account_number/text()'
    passing xmlparse(document xml_content) as "doc") as account_number,
  xmlquery('$doc//customer_info/account_name/text()'
    passing xmlparse(document xml_content) as "doc") as account_name,
  xmlquery('$doc//customer_info/contact/text()'
    passing xmlparse(document xml_content) as "doc") as contact_phone,
  xmlquery('$doc//ship_to_info/address/address_line_1/text()'
    passing xmlparse(document xml_content) as "doc") as ship_address_1,
  xmlquery('$doc//ship_to_info/address/address_line_2/text()'
    passing xmlparse(document xml_content) as "doc") as ship_address_2,
  xmlquery('$doc//ship_to_info/address/city/text()'
    passing xmlparse(document xml_content) as "doc") as ship_city,
  xmlquery('$doc//ship_to_info/address/state/text()'
    passing xmlparse(document xml_content) as "doc") as ship_state,
  xmlquery('$doc//ship_to_info/address/zip/text()'
    passing xmlparse(document xml_content) as "doc") as ship_zip,
  xmlquery('$doc//ship_to_info/address/country/text()'
    passing xmlparse(document xml_content) as "doc") as ship_country
from session.xml_files
where upper(file_name) like '%.XML';

-- Insert line item data
insert into session.neuco_line_items (
  transmission_id,
  line_number,
  type_code,
  product_name,
  external_item_id,
  pim_id,
  quantity,
  amount,
  cost,
  surcharge_amount,
  tax_amount,
  tax_percentage
)
select 
  xmlquery('$doc//transmission_header/transmission_id/text()'
    passing xmlparse(document f.xml_content) as "doc") as transmission_id,
  x.line_number,
  x.type_code,
  x.product_name,
  x.external_item_id,
  x.pim_id,
  x.quantity,
  x.amount,
  x.cost,
  x.surcharge_amount,
  x.tax_amount,
  x.tax_percentage
from session.xml_files f,
xmltable('$doc//line_item'
  passing xmlparse(document f.xml_content) as "doc"
  columns
    line_number int path 'line_number',
    type_code varchar(10) path 'type_code',
    product_name varchar(100) path 'product_name',
    external_item_id varchar(50) path 'external_item_id',
    pim_id varchar(20) path 'pim_id',
    quantity decimal(12,3) path 'quantity',
    amount decimal(12,2) path 'price/amount',
    cost decimal(12,2) path 'price/cost',
    surcharge_amount decimal(12,2) path 'price/surcharge_amount',
    tax_amount decimal(12,2) path 'price/tax_info/amount',
    tax_percentage decimal(8,4) path 'price/tax_info/percentage'
) as x
where upper(f.file_name) like '%.XML';

-- Verification queries
select 'Orders inserted: ' || count(*) as result from session.neuco_orders
union all
select 'Customers inserted: ' || count(*) as result from session.neuco_customers  
union all
select 'Line items inserted: ' || count(*) as result from session.neuco_line_items;