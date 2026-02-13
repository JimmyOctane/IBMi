# ARPCOMMTX Commission Matrix Table Analysis

## Table Structure

The ARPCOMMTX table appears to have the following columns based on the sample data:

| Column Name | Description | Data Type | Notes |
|-------------|-------------|-----------|-------|
| Geo Sales Zone | Geographic sales zone identifier | Numeric | Example: 3, 4 |
| Company Number | Company identifier | Numeric | Example: 1 |
| Division Code | Division identifier | Text | Example: ECM, WES |
| Selling Section Code | Section identifier | Text | Example: AMN, AMX, EQP, SUP |
| SALES LOW$ | Minimum sales amount | Numeric | Range start for sales criteria |
| SALES HIGH$ | Maximum sales amount | Numeric | Range end for sales criteria (9999999 = unlimited) |
| PROFIT% LOW% | Minimum profit percentage | Decimal | Range start for profit percentage |
| PROFIT% HIGH% | Maximum profit percentage | Decimal | Range end for profit percentage |
| COMM RATE | Commission rate | Decimal | The commission percentage to apply |

## Commission Matrix Logic

The commission rate is determined by finding the row where:
1. **PLAN_NO** (Geo Sales Zone) matches
2. **Company Number** matches  
3. **Division Code** matches
4. **Section Code** matches
5. Sales amount falls between SALES LOW$ and SALES HIGH$ (inclusive)
6. Profit percentage falls between PROFIT% LOW% and PROFIT% HIGH% (inclusive)

## Key Observations

### 1. Sales Amount Ranges
- Most entries use sales range of `1` to `9999999` (effectively unlimited)
- WES/SUP section has tiered sales ranges:
  - Tier 1: $1 - $175,000
  - Tier 2: $175,001 - $300,000  
  - Tier 3: $300,001 - $9,999,999

### 2. Profit Percentage Ranges
- ECM Division patterns:
  - AMN: 0-9.9%, 10-14.9%, 15-99.9%
  - AMX: 0-17.9%, 18-23%, 23.1-99.9%
  - EQP: 0-8.9%, 9-11.3%, 11.4-99.9%
  - SUP: 0-13.9%, 14-17.9%, 18-99.9%

- WES Division patterns:
  - More granular profit percentage bands
  - SUP section has very detailed profit bands (0.5% increments)

### 3. Commission Rate Patterns
- **Plan 3** (Geo Sales Zone 3): Higher commission rates
- **Plan 4** (Geo Sales Zone 4): Lower commission rates
- WES/SUP has the most complex matrix with sales amount tiers affecting rates

### 4. Special Cases
- WES/SUP section has a 3-dimensional matrix:
  - Sales amount tiers (3 levels)
  - Profit percentage bands (many incremental bands)
  - Each combination has a specific commission rate

## Sample Commission Calculations

### Example 1: ECM/AMN
- Sales: $50,000, Profit: 12%
- Plan 3: 7% commission (10-14.9% profit band)
- Plan 4: 4% commission (10-14.9% profit band)

### Example 2: WES/SUP  
- Sales: $200,000, Profit: 22.2%
- Plan 3: 10.45% commission (175001-300000 sales tier, 22-22.4% profit band)

### Example 3: WES/EQP
- Sales: $100,000, Profit: 13.5%
- Plan 3: 8% commission (13-14.4% profit band)

## Usage Pattern

To find the commission rate for a sale:

```sql
SELECT COMM_RATE
FROM ARPCOMMTX 
WHERE [Geo Sales Zone] = ?
  AND [Company Number] = ?
  AND [Division Code] = ?
  AND [Selling Section Code] = ?
  AND ? BETWEEN [SALES LOW$] AND [SALES HIGH$]
  AND ? BETWEEN [PROFIT% LOW%] AND [PROFIT% HIGH%]
```

## Business Rules Inferred

1. **Higher profit margins = higher commission rates** (generally)
2. **Geographic zones affect commission levels** (Plan 3 vs Plan 4)
3. **Product divisions have different commission structures**
4. **Sales volume tiers can affect commission rates** (WES/SUP example)
5. **Some sections have simple 3-tier structures, others are highly granular**