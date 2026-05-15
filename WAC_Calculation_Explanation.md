# WAC (Weighted Average Cost) Calculation System

## Overview

The WAC system consists of two main programs that work together to maintain accurate inventory valuation:

1. **[`IVR6110.RPGLE`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6110.RPGLE:1)** - Real-time WAC calculation for individual transactions
2. **[`IVR6200.RPGLE`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:1)** - End-of-month WAC "Trickle Down" rebuild process

---

# Part 1: IVR6110 - Real-Time WAC Calculation

## Overview

[`IVR6110.RPGLE`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6110.RPGLE:1) is a callable RPG program that recalculates the **Weighted Average Cost (WAC)** for inventory items in real-time. This program is essential for maintaining accurate inventory valuation by computing the new average cost whenever inventory transactions occur (receipts, adjustments, etc.).

## What is Weighted Average Cost (WAC)?

WAC is an inventory valuation method that calculates the average cost of all units in inventory. When new inventory is received at a different cost, the WAC is recalculated by:

1. Taking the total value of existing inventory
2. Adding the value of the new receipt
3. Dividing by the total quantity on hand

**Formula:**
```
WAC = (Existing Inventory Value + New Receipt Value) / Total Quantity On Hand
```

## Program Parameters

The program accepts 5 parameters (lines 23-27):

| Parameter | Type | Description |
|-----------|------|-------------|
| **PMIOB** | 7,0 | **On-Hand Before** - Quantity on hand before the transaction |
| **PMIWB** | 9,4 | **WAC Before** - Weighted Average Cost before the transaction |
| **PMITQ** | 7,0 | **Transaction Quantity** - Quantity being received/adjusted |
| **PMITC** | 9,4 | **Transaction Cost** - Unit cost of the transaction (landed cost) |
| **PMOWA** | 9,4 | **WAC After** - *OUTPUT* - New Weighted Average Cost after transaction |

## Calculation Logic

The program uses three distinct scenarios based on inventory levels:

### Scenario 1: On-Hand After ≤ 0 (Lines 40-41)
**Condition:** If the quantity on hand after the transaction is zero or negative

**Action:** WAC remains unchanged
```rpgle
PMOWA = PMIWB  (WAC After = WAC Before)
```

**Business Logic:** If there's no inventory remaining, preserve the previous WAC for reference. This prevents losing cost history when inventory goes to zero.

---

### Scenario 2: On-Hand Before ≤ 0, On-Hand After > 0 (Lines 44-46)
**Condition:** Starting from zero or negative inventory, receiving new stock

**Action:** WAC becomes the new receipt cost
```rpgle
PMOWA = PMITC  (WAC After = Transaction Cost)
```

**Business Logic:** When starting with no inventory, the new WAC is simply the cost of the first receipt. There's no previous value to average with.

**Example:**
- On-Hand Before: 0 units @ $0.00
- Receive: 100 units @ $10.50
- **Result:** WAC = $10.50

---

### Scenario 3: On-Hand Before > 0, On-Hand After > 0 (Lines 49-62)
**Condition:** Normal receipt into existing inventory

**Action:** Calculate weighted average
```rpgle
Step 1: VALBEF = PMIOB × PMIWB    (Perpetual Value Before)
Step 2: VALREC = PMITQ × PMITC    (Receipt Value)
Step 3: VALNEW = VALBEF + VALREC  (Perpetual Value After)
Step 4: PMOWA = VALNEW ÷ OA       (New WAC)
```

**Business Logic:** This is the true weighted average calculation, combining the value of existing inventory with the value of the new receipt.

**Example:**
- On-Hand Before: 50 units @ $10.00 = $500.00
- Receive: 100 units @ $12.00 = $1,200.00
- Total Value: $500.00 + $1,200.00 = $1,700.00
- Total Quantity: 50 + 100 = 150 units
- **Result:** WAC = $1,700.00 ÷ 150 = $11.33

---

## Special Handling: Zero Quantity Transactions (Lines 54-58)

The program includes special logic for transactions with zero quantity:

```rpgle
IF PMITQ ≠ 0
    VALREC = PMITQ × PMITC
ELSE
    VALREC = PMITC
ENDIF
```

**Purpose:** This handles cost adjustments where the quantity is zero but the cost needs to be updated. Instead of multiplying by zero (which would give zero value), it uses the transaction cost directly.

**Use Case:** Adjusting the cost of existing inventory without changing quantities.

## Key Variables

| Variable | Type | Description |
|----------|------|-------------|
| **OA** | 7,0 | On-Hand After (calculated: PMIOB + PMITQ) |
| **VALBEF** | 15,7 | Perpetual Value Before (On-Hand Before × WAC Before) |
| **VALREC** | 15,7 | Receipt Value (Transaction Qty × Transaction Cost) |
| **VALNEW** | 15,7 | Perpetual Value After (VALBEF + VALREC) |

## Program Flow

```
START
  ↓
Clear output parameter (PMOWA)
  ↓
Calculate On-Hand After (OA = PMIOB + PMITQ)
  ↓
SELECT based on inventory levels:
  ├─ OA ≤ 0? → WAC stays same
  ├─ PMIOB ≤ 0 AND OA > 0? → WAC = new cost
  └─ PMIOB > 0 AND OA > 0? → Calculate weighted average
  ↓
Return PMOWA (new WAC)
  ↓
END
```

## Usage Example

This program would typically be called during inventory receipt processing:

```rpgle
// Before receiving 100 units at $12.50
OnHandBefore = 200;
WACBefore = 10.00;
TransQty = 100;
TransCost = 12.50;

CALL 'IVR6110' PARM(OnHandBefore, WACBefore, TransQty, TransCost, NewWAC);

// NewWAC will contain the recalculated weighted average cost
// Calculation: (200 × $10.00 + 100 × $12.50) / 300 = $10.83
```

## Business Impact

**Why WAC Matters:**
- **Inventory Valuation:** Determines the dollar value of inventory on the balance sheet
- **Cost of Goods Sold:** Affects profit calculations when items are sold
- **Financial Reporting:** Required for accurate financial statements
- **Pricing Decisions:** Helps establish minimum selling prices to maintain margins

## Modification History

- **Task 8000009876 (06/09/06):** Non-stock inventory balancing
- **Task 8000009570 (07/26/07):** HD/WO Interface modifications (lines 54-58 added for zero quantity handling)

---

# Part 2: IVR6200 - WAC Trickle Down (End-of-Month Rebuild)

## Overview

[`IVR6200.RPGLE`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:1) is the **"WAC Trickle Down"** program that performs end-of-month WAC recalculation. This program processes all inventory transactions chronologically to rebuild WAC values, ensuring accuracy after month-end processing or when corrections are needed.

## Purpose

The trickle down process is necessary because:
- **Historical Corrections:** When a past transaction is corrected, all subsequent transactions need WAC recalculation
- **Month-End Reconciliation:** Ensures WAC values are accurate across all transactions for the period
- **Data Integrity:** Rebuilds WAC chain when discrepancies are detected

## Program Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| **RCVNUM** | 7 | Receipt/Transaction Number to start from |
| **RCVLIN** | - | Receipt Line Number |
| **NEWWAC** | 9,4 | New WAC value (starting point) |
| **PMCRPD** | 6 | Current Period (CCYYMM format) |
| **ENDTRN** | - | Ending Transaction Number (where to stop) |
| **ENDTYP** | 3 | Ending Transaction Type ('POR', 'TRR', 'WOR') |

## Transaction Types Processed

The program processes four types of inventory transactions in chronological order:

### 1. Purchase Order Receipts (POR) - Lines 212-228
**File:** POFTRD (Purchase Order Transaction Detail)

**Logic:**
- Chains to purchase order receipt detail using PO number and line
- Only processes receipts dated on or before the current period
- Calls [`POR0212`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:219) to get receipt quantity and cost
- Executes [`CLCWAC`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:350) subroutine to recalculate WAC
- Tracks quantity variance for transactions outside the period

**Key Fields:**
- `RCVQTY` - Receipt Quantity
- `RCVCST` - Receipt Cost (includes freight, rebates, special buy adjustments)
- `RCVFRT` - Freight amount (weighted average)
- `RCVREB` - Rebate amount (weighted average)
- `RCVSPC` - Special buy amount

### 2. Transfer Receipts (TRR) - Lines 231-243
**File:** IVFTRL (Inventory Transfer Detail)

**Logic:**
- Processes inventory transfers between locations/warehouses
- Chains to transfer detail using transfer number
- Only processes transfers dated on or before the current period
- Executes [`CLCWAC`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:350) subroutine to recalculate WAC
- Uses transfer cost and quantity from the transaction

**Key Fields:**
- `RCVCST` - Transfer cost (field IVAMAT)
- `RCVQTY` - Transfer quantity (field IVQY26)

### 3. Work Order Receipts (WOR) - Lines 246-270
**File:** WKFTRCPT (Work Order Receipt)

**Logic:**
- Processes manufactured/assembled items received from work orders
- Chains to work order receipt using WO number
- Only processes receipts dated on or before the current period
- **Special Handling (Task 8000010272):** Uses unit cost instead of extended cost
  - If quantity ≠ 0: `RCVCST = TRCCSTAMMK / TOTRECQYMK` (unit cost)
  - If quantity = 0: `RCVCST = TRCCSTAMMK` (total cost)
- Executes [`CLCWAC`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:350) subroutine to recalculate WAC

**Key Fields:**
- `TOTRECQYMK` - Total receipt quantity
- `TRCCSTAMMK` - Total receipt cost amount

### 4. Inventory Adjustments (ADJ) - Lines 273-323
**File:** IVFTADJ (Inventory Adjustment Detail)

**Logic:**
The most complex transaction type with three adjustment scenarios:

#### Scenario A: Quantity AND Cost Adjustment (Lines 291-293)
- Both `IVQY24` (quantity) and `IVAMY7` (cost) are non-zero
- Standard WAC calculation using [`CLCWAC`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:350) subroutine

#### Scenario B: Cost ONLY Adjustment (Lines 305-307)
- `IVAMY7` (cost) is non-zero, `IVQY24` (quantity) is zero
- WAC directly becomes the adjustment cost: `WACAFT = IVAMY7`
- No quantity change, just cost correction

#### Scenario C: Total Cost Adjustment (Lines 311-314)
- `IVAMZ1` (total cost adjustment) is non-zero
- Adjusts the total inventory value, then recalculates WAC:
  ```rpgle
  AMTAFT = AMTBEF + IVAMZ1
  WACAFT = AMTAFT / OHBEF
  ```

**Special Handling:**
- Skips adjustments where WAC before equals the adjustment WAC and quantity is negative (lines 274-277)
- Tracks quantity variance for adjustments outside the period

## CLCWAC Subroutine (Lines 350-377)

The core WAC calculation subroutine used by all transaction types:

```rpgle
BEGSR CLCWAC
  // Adjust on-hand with any variance from skipped transactions
  OHBEF = OHBEF + RCVVAR
  WACBEF = WACAFT  // Use previous calculated WAC
  
  // Calculate inventory value before
  AMTBEF = OHBEF × WACBEF
  
  // Calculate receipt/transaction amount
  RCVAMT = RCVQTY × RCVCST
  
  // Calculate on-hand after
  OHAFT = OHBEF + RCVQTY
  
  // Calculate inventory value after
  AMTAFT = AMTBEF + RCVAMT
  
  // Calculate new WAC
  IF OHAFT ≤ 0
    WACAFT = WACBEF  // Keep previous WAC if no inventory
  ELSE IF OHBEF ≤ 0
    WACAFT = RCVCST  // Use receipt cost if starting from zero
  ELSE
    WACAFT = AMTAFT / OHAFT  // Standard weighted average
  ENDIF
ENDSR
```

**This logic mirrors [`IVR6110`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6110.RPGLE:1) but operates in a loop across multiple transactions.**

## Process Flow

```
START
  ↓
Initialize: Set starting WAC, period, and variance to zero
  ↓
Get initial receipt date/time from POFWAC1
  ↓
Position to start of WAC chain (SETGT IVLWAC3)
  ↓
LOOP: Read next transaction chronologically (READE IVLWAC3)
  ↓
  Determine transaction type (indicators *IN47, *IN48, *IN46, *IN49)
  ↓
  ┌─────────────────────────────────────────────────┐
  │ *IN47 = POR (Purchase Order Receipt)            │
  │ *IN48 = TRR (Transfer Receipt)                  │
  │ *IN46 = WOR (Work Order Receipt)                │
  │ *IN49 = ADJ (Inventory Adjustment)              │
  └─────────────────────────────────────────────────┘
  ↓
  IF transaction date ≤ current period
    ├─ Get transaction details (qty, cost)
    ├─ Call CLCWAC subroutine
    └─ Update WACAFT and NEWWAC
  ELSE
    └─ Track quantity variance (RCVVAR)
  ↓
  Check if reached ending transaction (ENDTRN/ENDTYP)
    ├─ YES: LEAVE loop
    └─ NO: Continue to next transaction
  ↓
END LOOP
  ↓
Return NEWWAC (final recalculated WAC)
  ↓
END
```

## Key Features

### 1. Chronological Processing
- Uses IVLWAC3 file to process transactions in date/time order
- Ensures WAC is calculated sequentially, maintaining accuracy

### 2. Period Cutoff
- Only processes transactions dated on or before `PMCRPD` (current period)
- Transactions after the period are tracked but not included in WAC calculation

### 3. Variance Tracking
- `RCVVAR` accumulates quantity changes from skipped transactions
- Applied to on-hand before calculation in CLCWAC subroutine
- Ensures accurate on-hand quantities even when some transactions are excluded

### 4. Stopping Point
- `ENDTRN` and `ENDTYP` specify where to stop the trickle down
- Allows partial rebuilds from a specific transaction forward
- Prevents unnecessary processing of unchanged transactions

### 5. Enhanced Cost Components (Lines 131-133)
- **RCVFRT** - Weighted average freight (Task 8000010272)
- **RCVREB** - Weighted average rebates (Task 8000010325)
- **RCVSPC** - Special buy adjustments (Task 1290000353)

## Integration with IVR6110

| Aspect | IVR6110 (Real-Time) | IVR6200 (Trickle Down) |
|--------|---------------------|------------------------|
| **When Used** | During transaction entry | End-of-month or corrections |
| **Scope** | Single transaction | Multiple transactions chronologically |
| **Input** | Current on-hand and WAC | Starting WAC and transaction range |
| **Output** | New WAC for one transaction | Rebuilt WAC chain for period |
| **Performance** | Fast, single calculation | Slower, processes entire chain |
| **Purpose** | Real-time accuracy | Historical accuracy and reconciliation |

## Modification History

- **Task 8000011000 (01/30/06):** Initial release for MSS/HD 11.0
- **Task 8000009877 (04/07/06):** Database changes for inventory balancing
- **Task 8000009876 (07/26/06):** Non-stock inventory balancing support
- **Task 8000009906 (08/22/06):** Populate fields for inventory balancing
- **Task 8000009570 (11/01/06):** HD/WO interface integration
- **Task 8000009966 (02/09/07):** Change S/O number to 7 alpha
- **Task 8000010272 (12/12/07):** Use unit cost for W/O receipt, not extended
- **Task 8000010256 (02/28/08):** Weighted average freight
- **Task 8000010344 (07/22/08):** Rename WOPWAC in HD due to MSS/LM
- **Task 8000010325 (01/21/09):** Weighted average rebates
- **Task 1290000353 (01/04/16):** WAR V3 special buy

---

# Summary

## WAC System Architecture

The two programs work together to maintain accurate inventory costs:

### Real-Time Processing ([`IVR6110`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6110.RPGLE:1))
- Called during transaction entry (receipts, adjustments, transfers)
- Calculates WAC for the current transaction
- Fast, single-transaction focus
- Maintains day-to-day accuracy

### Period-End Reconciliation ([`IVR6200`](C:\JimmyOctane\IBMi\QRPGLESRC\IVR6200.RPGLE:1))
- Called during month-end processing or when corrections are needed
- Rebuilds WAC chain chronologically from a starting point
- Processes all transaction types in date/time order
- Ensures historical accuracy and fixes discrepancies

**Together, these programs ensure that inventory valuation remains accurate both in real-time operations and through period-end reconciliation processes.**
