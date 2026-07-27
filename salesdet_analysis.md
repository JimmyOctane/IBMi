# SALESDET.RPGLE — Sales Detail Analysis Report
**Billing Period:** June 2026 (Month 6, Year 2026)  
**Salesman ID:** 173  
**Generated:** 2026-07-23

---

## 📋 Data Structure

The file is a **comma-delimited sales detail export** (CSV stored with an `.rpgle` extension) with the following 12 columns:

| # | Field | Description |
|---|-------|-------------|
| 1 | Salesman ID | Rep identifier (all = 173) |
| 2 | Bill Month | Billing period month (all = 6) |
| 3 | Bill Century | Century portion of year (all = 20) |
| 4 | Bill Year | Year portion (all = 26 → 2026) |
| 5 | Order Number | Invoice/order ID (e.g. G933394) |
| 6 | Order Line | Line sequence within order |
| 7 | P/O Line | Non-zero = special/drop-ship item |
| 8 | Product | Item/SKU number |
| 9 | Qty Shipped | Units shipped |
| 10 | Extended Price | Total billed amount |
| 11 | Gross Cost | Total cost of goods |
| 12 | Gross Profit | Extended Price − Gross Cost |

---

## 📊 Overview Summary

| Metric | Value |
|--------|-------|
| **Total Line Items** | 3,723 |
| **Unique Orders** | 732 |
| **Unique Products** | 710 |
| **Total Extended Price (Revenue)** | $827,910.08 |
| **Total Gross Cost** | $718,275.75 |
| **Total Gross Profit** | $109,634.33 |
| **Overall Gross Margin** | **13.24%** |
| **Total Qty Shipped** | 7,995 units |
| **Avg Revenue per Order** | $1,131.02 |
| **Avg Gross Profit per Order** | $149.77 |

---

## 🏆 Top 10 Orders by Revenue

| Order | Revenue | Profit | Margin | Lines |
|-------|---------|--------|--------|-------|
| G959529 | $8,317.46 | $889.68 | 10.7% | 6 |
| G975594 | $8,160.26 | $648.19 | 7.9% | 9 |
| G951217 | $6,955.61 | $973.73 | 14.0% | 9 |
| G952665 | $6,873.00 | $874.29 | 12.7% | 12 |
| G934714 | $5,780.85 | $754.91 | 13.1% | 1 |
| G952632 | $5,701.02 | $837.34 | 14.7% | 18 |
| G941001 | $5,664.24 | $783.59 | 13.8% | 5 |
| G967670 | $5,606.67 | $631.02 | 11.3% | 9 |
| G963043 | $5,477.40 | $1,068.70 | 19.5% | 2 |
| G935656 | $5,435.08 | $785.82 | 14.5% | 19 |

> **Note:** G934714 is a single-line order worth $5,780.85 (product 379763A) — a high-value single-SKU purchase.

---

## 📦 Top 10 Products by Revenue

| Product | Revenue | Profit | Margin | Qty | Appearances |
|---------|---------|--------|--------|-----|-------------|
| 378916A | $41,745.90 | $3,338.77 | 8.0% | 41 | 38 |
| 378795A | $37,899.68 | $3,170.72 | 8.4% | 31 | 24 |
| 378796A | $36,703.17 | $2,898.98 | 7.9% | 28 | 25 |
| 378815A | $33,249.45 | $2,749.00 | 8.3% | 42 | 38 |
| 378797A | $30,716.41 | $2,458.45 | 8.0% | 20 | 20 |
| 378915A | $26,592.50 | $2,096.55 | 7.9% | 27 | 24 |
| 378919A | $24,849.24 | $2,053.96 | 8.3% | 17 | 17 |
| 378917A | $24,715.20 | $2,028.18 | 8.2% | 21 | 21 |
| 378918A | $21,831.70 | $1,741.60 | 8.0% | 17 | 16 |
| 378816A | $19,025.60 | $1,521.25 | 8.0% | 24 | 23 |

> **Observation:** The top revenue products are all in the **378xxx / 379xxx series** — these appear to be a family of high-value equipment or assemblies (unit prices $700–$1,800+). They generate the most gross profit dollars but at a **consistently thin margin of ~8%**.

---

## 💰 Top 10 Products by Gross Profit

| Product | Profit | Revenue | Margin | Appearances |
|---------|--------|---------|--------|-------------|
| 378916A | $3,338.77 | $41,745.90 | 8.0% | 38 |
| 378795A | $3,170.72 | $37,899.68 | 8.4% | 24 |
| 378796A | $2,898.98 | $36,703.17 | 7.9% | 25 |
| 378815A | $2,749.00 | $33,249.45 | 8.3% | 38 |
| 378797A | $2,458.45 | $30,716.41 | 8.0% | 20 |
| 378915A | $2,096.55 | $26,592.50 | 7.9% | 24 |
| 378919A | $2,053.96 | $24,849.24 | 8.3% | 17 |
| 378917A | $2,028.18 | $24,715.20 | 8.2% | 21 |
| **372026A** | **$1,775.06** | **$3,550.12** | **50.0%** | 12 |
| 378918A | $1,741.60 | $21,831.70 | 8.0% | 16 |

> **Standout:** Product **372026A** ranks 9th in profit dollars but generates a **50% gross margin** — by far the most profitable product on a per-dollar basis among frequently ordered items.

---

## ⭐ Top 10 Highest-Margin Products (min 5 appearances)

| Product | Margin | Profit | Revenue | Qty | Appearances |
|---------|--------|--------|---------|-----|-------------|
| 381246A | 66.7% | $21.34 | $31.98 | 7 | 5 |
| 381253A | 60.9% | $78.49 | $128.97 | 8 | 7 |
| 381225A | 57.5% | $51.65 | $89.81 | 8 | 6 |
| 69562 | 53.4% | $9.24 | $17.30 | 13 | 11 |
| 372026A | 50.0% | $1,775.06 | $3,550.12 | 14 | 12 |
| 316266A | 50.0% | $27.35 | $54.70 | 5 | 5 |
| 69560 | 49.6% | $8.41 | $16.96 | 19 | 16 |
| 332299A | 46.0% | $90.79 | $197.44 | 9 | 7 |
| 345448A | 42.1% | $93.60 | $222.36 | 58 | 24 |
| 83066 | 40.3% | $3.74 | $9.29 | 15 | 7 |

> **Key finding:** Products like **381246A, 381253A, 381225A, 372026A** are high-margin accessories/consumables. **345448A** is noteworthy — it ships in high volume (58 units, 24 orders) at 42% margin, making it a consistent profit contributor.

---

## 🔴 Negative-Profit Line Items (3 lines)

| Order | Line | Product | Price | Cost | Loss |
|-------|------|---------|-------|------|------|
| G944672 | 3 | 379880A | $573.22 | $609.18 | **-$35.96** |
| G959845 | 3 | 341019A | $1,035.65 | $1,053.64 | **-$17.99** |
| G959845 | 8 | 367006A | $1,340.90 | $1,364.18 | **-$23.28** |

> These 3 lines are sold **below cost**. G959845 has two loss-making lines on the same order, losing $41.27 combined. This may indicate a pricing error, promotional pricing, or a cost data issue that should be reviewed.

---

## 🔶 Special / Drop-Ship Lines (P/O Line ≠ 0) — 17 Lines

These 17 line items have a non-zero P/O Line flag, indicating they were fulfilled via a special purchase order or drop-ship arrangement:

| Order | Line | PO# | Product | Price | Profit |
|-------|------|-----|---------|-------|--------|
| G890011 | 1 | 2 | 53798 | $47.79 | $16.66 |
| G890011 | 3 | 1 | 380775A | $268.94 | $83.37 |
| G905534 | 1 | 1 | 360459A | $134.24 | $45.64 |
| G911795 | 1 | 1 | 368493A | $472.62 | $160.69 |
| G915938 | 1 | 1 | 384201A | $631.86 | $214.83 |
| G924097 | 1 | 1 | 384102A | $988.47 | $355.85 |
| G924264 | 1 | 1 | 380798A | $79.46 | $34.96 |
| G935722 | 3 | 1 | 385638A | $1,266.14 | $392.50 |
| G937516 | 1 | 1 | 291419A | $91.44 | $39.32 |
| G937516 | 3 | 2 | 291419A | $91.44 | $39.32 |
| G938353 | 1 | 1 | 384202A | $565.34 | $169.60 |
| G938428 | 1 | 1 | PTS005-0341117 | $223.74 | $106.28 |
| G941001 | 3 | 1 | 381943A | $1,599.50 | $155.38 |
| G945459 | 1 | 1 | 369021A | $492.78 | $177.40 |
| G968934 | 1 | 1 | 379812A | $1,160.50 | $89.36 |
| G968934 | 2 | 2 | 379811A | $1,110.50 | $85.51 |
| G974558 | 1 | 1 | 381647A | $2,983.40 | $289.82 |

> All 17 special-order lines are **profitable** (no losses). Combined revenue: ~$11,207. These tend to be higher-value items.

---

## 📏 Order Size Distribution

| Order Size | Count | % of Orders |
|------------|-------|-------------|
| 1 line | 186 | 25.4% |
| 2–5 lines | 292 | **39.9%** |
| 6–10 lines | 172 | 23.5% |
| 11–20 lines | 71 | 9.7% |
| 20+ lines | 11 | 1.5% |

> The majority of orders (65%) have **5 or fewer lines**. About 1-in-4 orders is a single-line purchase. Only 11 orders exceed 20 lines — these are likely large service/distribution accounts.

---

## 💎 Top 10 Largest Single Line Items by Price

| Order | Line | Product | Price | Profit | Margin |
|-------|------|---------|-------|--------|--------|
| G959529 | 5 | 378795A | $7,233.60 | $591.84 | 8.2% |
| G934714 | 2 | 379763A | $5,780.85 | $754.91 | 13.1% |
| G945575 | 3 | 379702A | $4,129.00 | $539.68 | 13.1% |
| G941001 | 2 | 381640A | $3,433.28 | $467.35 | 13.6% |
| G952808 | 1 | 383245A | $3,156.30 | $306.61 | 9.7% |
| G963043 | 3 | 381604A | $3,143.70 | $613.37 | 19.5% |
| G963350 | 1 | 378920A | $3,028.00 | $233.16 | 7.7% |
| G974558 | 1 | 381647A | $2,983.40 | $289.82 | 9.7% |
| G977588 | 3 | 382140A | $2,978.58 | $595.72 | 20.0% |
| G952665 | 8 | 381643A | $2,867.00 | $220.76 | 7.7% |

---

## ⚠️ Low-Margin Line Items (below 5%)

- **Count:** 6 lines (0.2% of all lines)
- **Combined Revenue:** $4,523.97
- These are isolated cases and not a systemic concern.

---

## 📈 High-Value Orders (Revenue > $5,000)

- **Count:** 16 orders
- **Combined Revenue:** $95,291.98 (**11.5% of total revenue**)
- Only 2.2% of orders, but generating over 11% of revenue — classic Pareto concentration.

---

## 🔍 Key Takeaways & Observations

1. **Revenue is concentrated in the 378xxx/379xxx product family** — these 10 SKUs alone represent nearly $317K in revenue (~38% of total). They are high-ticket items but at thin ~8% margins.

2. **True profit drivers are small, high-margin accessories** — Products like 372026A (50%), 345448A (42%), 332299A (46%), and the 381xxx series (57–67%) generate much higher margins. Upselling these alongside equipment could significantly improve overall margin.

3. **Overall margin of 13.24% is modest** — pulled down heavily by the high-volume, low-margin equipment lines. Without the top 10 revenue products, the margin profile would look significantly healthier.

4. **3 below-cost sales need review** — G944672 (379880A), G959845 (341019A & 367006A). The two on G959845 are likely a pricing or discount error.

5. **Drop-ship/special orders are managed well** — all 17 flagged lines are profitable, suggesting good special-order pricing discipline.

6. **Order size skews small** — 65% of orders have ≤5 lines, suggesting potential to increase basket size through cross-selling.
