ctl-opt option(*srcstmt:*nodebugio) debug(*yes) dftactgrp(*no);

//------------------------------------------------------------------------
// PROGRAM NAME - CREATE_NEUCO_TABLES                                          
//------------------------------------------------------------------------
//                                                                       
//------------------------------------------------------------------------
// Create structured tables for Neuco XML transmission data                    
//------------------------------------------------------------------------
// PURPOSE: Create normalized tables for order, customer, and line item data               
//                                                                       
// SPECIAL NOTES: Creates tables optimized for Neuco XML structure                    
//                                                                       
//----------------------------------------------------------------------
// TASK       DATE   ID  DESCRIPTION                                     
// ---------- ------ --- ------------------------------------------------
// JJF   3060 013025 JJF Created program to build Neuco tables            
//----------------------------------------------------------------------

//=======================================================================
//
// Program Info
//
dcl-ds programStatus psds qualified;
  pgmName *proc;
  parms int(10) pos(37);
  msgData char(80) pos(91);
  msgId char(4) pos(171);
  jobName char(10) pos(244);
  userId char(10) pos(254);
  jobNumber zoned(6) pos(264);
end-ds;

exec sql set option commit=*none, datfmt=*iso, closqlcsr=*ENDMOD;

*inlr = *on;

// Drop existing tables if they exist
monitor;
  exec sql drop table session.neuco_orders;
on-error;
  // Table doesn't exist, continue
endmon;

monitor;
  exec sql drop table session.neuco_customers;
on-error;
  // Table doesn't exist, continue
endmon;

monitor;
  exec sql drop table session.neuco_line_items;
on-error;
  // Table doesn't exist, continue
endmon;

// Create orders table
exec sql
  create table session.neuco_orders (
    transmission_id varchar(50) not null,
    transmission_type varchar(50),
    created_date timestamp,
    updated_date timestamp,
    job_name varchar(100),
    vendor_code varchar(20),
    vendor_name varchar(50),
    placed_date timestamp,
    promised_date timestamp,
    branch_sell varchar(10),
    branch_ship varchar(10),
    ship_code varchar(20),
    order_type_code varchar(5),
    order_status_code varchar(5),
    freight_charges decimal(12,2),
    total_amount decimal(12,2),
    file_name varchar(256),
    processed_date timestamp default current_timestamp,
    primary key (transmission_id)
  );

// Create customers table  
exec sql
  create table session.neuco_customers (
    transmission_id varchar(50) not null,
    account_number varchar(20),
    account_name varchar(100),
    contact_phone varchar(20),
    ship_address_1 varchar(100),
    ship_address_2 varchar(100),
    ship_city varchar(50),
    ship_state varchar(10),
    ship_zip varchar(15),
    ship_country varchar(50),
    bill_address_1 varchar(100),
    bill_address_2 varchar(100),
    bill_city varchar(50),
    bill_state varchar(10),
    bill_zip varchar(15),
    bill_country varchar(50),
    primary key (transmission_id),
    foreign key (transmission_id) references session.neuco_orders(transmission_id)
  );

// Create line items table
exec sql
  create table session.neuco_line_items (
    transmission_id varchar(50) not null,
    line_number int not null,
    type_code varchar(10),
    product_name varchar(100),
    external_item_id varchar(50),
    pim_id varchar(20),
    quantity decimal(12,3),
    amount decimal(12,2),
    cost decimal(12,2),
    surcharge_amount decimal(12,2),
    tax_amount decimal(12,2),
    tax_percentage decimal(8,4),
    primary key (transmission_id, line_number),
    foreign key (transmission_id) references session.neuco_orders(transmission_id)
  );

// Create indexes for better performance
exec sql create index idx_neuco_orders_date on session.neuco_orders(placed_date);
exec sql create index idx_neuco_customers_account on session.neuco_customers(account_number);
exec sql create index idx_neuco_line_items_product on session.neuco_line_items(product_name);