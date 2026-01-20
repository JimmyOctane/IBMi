# Waiting for IVPMSBR Field Information

## Status
Waiting for user to provide the IVPMSBR table field list from Untitled-1 file.

## Required Information

Need the actual database field names for IVPMSBR table that correspond to:

### Core Identification
- Item number
- Branch code
- Product code
- Manufacturer

### Quantities
- Quantity on hand
- Allocated quantity
- Reserved quantity
- Backordered quantity
- Order point quantity

### Sales Tracking
- Last sale date
- MTD sales (dollar amount)
- MTD sales (quantity)
- YTD sales (dollar amount)
- YTD sales (quantity)

### Vendor/Receiving
- MTD $ received from vendor
- Manufacturing/lead time

### Inventory Status
- Days out of stock

## Next Steps

Once the field information is provided, I will:

1. Create the [`QRPGLESRC/itemdet_cp.rpgle`](../QRPGLESRC/itemdet_cp.rpgle) copy book with:
   - Procedure prototype for getItemDetails
   - Data structure with input parameters (item, branch)
   - Data structure with all output fields matching IVPMSBR

2. Create the [`QRPGLESRC/itemdet.sqlrpgle`](../QRPGLESRC/itemdet.sqlrpgle) service program with:
   - NOMAIN module following PERZIP pattern
   - SQL query to fetch IVPMSBR data
   - Error handling with Monitor/On-Error blocks
   - Export procedure matching the prototype

3. Create the [`QRPGLESRC/itemdet_ts.rpgle`](../QRPGLESRC/itemdet_ts.rpgle) test program with:
   - /COPY statement for the copy book
   - Test data initialization
   - Call to getItemDetails procedure
   - Result display

## Coding Style Reference

Following the PERZIP pattern documented in:
- [`QRPGLESRC/perzip_cp.rpgle`](../QRPGLESRC/perzip_cp.rpgle) - Copy book structure
- [`QRPGLESRC/perzip.sqlrpgle`](../QRPGLESRC/perzip.sqlrpgle) - Service program implementation
- [`QRPGLESRC/perzip_ts.rpgle`](../QRPGLESRC/perzip_ts.rpgle) - Testing program pattern
