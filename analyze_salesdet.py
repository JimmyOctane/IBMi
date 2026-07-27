from collections import defaultdict

lines = []
with open(r'c:\JimmyOctane\IBMi\QRPGLESRC\salesdet.rpgle', 'r') as f:
    lines = f.readlines()

data = []
for line in lines[2:]:  # skip 2-row header
    line = line.strip()
    if not line:
        continue
    parts = line.split(',')
    if len(parts) >= 12:
        try:
            row = {
                'salesman_id': int(parts[0]),
                'bill_month': int(parts[1]),
                'bill_century': int(parts[2]),
                'bill_year': int(parts[3]),
                'order_num': parts[4],
                'order_line': int(parts[5]),
                'po_line': int(parts[6]),
                'product': parts[7],
                'qty': float(parts[8]),
                'ext_price': float(parts[9]),
                'gross_cost': float(parts[10]),
                'gross_profit': float(parts[11]),
            }
            data.append(row)
        except:
            pass

print(f'Total line items: {len(data)}')

orders = set(r['order_num'] for r in data)
print(f'Unique orders: {len(orders)}')

products = set(r['product'] for r in data)
print(f'Unique products: {len(products)}')

total_price = sum(r['ext_price'] for r in data)
total_cost  = sum(r['gross_cost'] for r in data)
total_profit = sum(r['gross_profit'] for r in data)
total_qty = sum(r['qty'] for r in data)
print(f'Total Extended Price:  ${total_price:,.2f}')
print(f'Total Gross Cost:      ${total_cost:,.2f}')
print(f'Total Gross Profit:    ${total_profit:,.2f}')
print(f'Overall Gross Margin:  {total_profit/total_price*100:.2f}%')
print(f'Total Qty Shipped:     {total_qty:,.0f}')
print(f'Avg Revenue per Order: ${total_price/len(orders):,.2f}')
print(f'Avg Profit per Order:  ${total_profit/len(orders):,.2f}')

months = set(r['bill_month'] for r in data)
years  = set(str(r['bill_century'])+str(r['bill_year']).zfill(2) for r in data)
print(f'Billing Period(s): Month {months}, Year {years}')

order_rev = defaultdict(float)
order_profit = defaultdict(float)
order_lines = defaultdict(int)
for r in data:
    order_rev[r['order_num']] += r['ext_price']
    order_profit[r['order_num']] += r['gross_profit']
    order_lines[r['order_num']] += 1

top10_rev = sorted(order_rev.items(), key=lambda x: x[1], reverse=True)[:10]
print('\nTop 10 Orders by Revenue:')
for o, rev in top10_rev:
    print(f'  {o}: ${rev:,.2f} revenue, ${order_profit[o]:,.2f} profit, {order_lines[o]} lines')

prod_rev = defaultdict(float)
prod_profit = defaultdict(float)
prod_qty = defaultdict(float)
prod_count = defaultdict(int)
for r in data:
    prod_rev[r['product']] += r['ext_price']
    prod_profit[r['product']] += r['gross_profit']
    prod_qty[r['product']] += r['qty']
    prod_count[r['product']] += 1

top10_prod = sorted(prod_rev.items(), key=lambda x: x[1], reverse=True)[:10]
print('\nTop 10 Products by Revenue:')
for p, rev in top10_prod:
    margin = prod_profit[p]/rev*100 if rev else 0
    print(f'  {p}: ${rev:,.2f} rev, ${prod_profit[p]:,.2f} profit, {margin:.1f}% margin, qty={prod_qty[p]:.0f}, appearances={prod_count[p]}')

top10_prod_profit = sorted(prod_profit.items(), key=lambda x: x[1], reverse=True)[:10]
print('\nTop 10 Products by Gross Profit:')
for p, prof in top10_prod_profit:
    margin = prof/prod_rev[p]*100 if prod_rev[p] else 0
    print(f'  {p}: ${prof:,.2f} profit, ${prod_rev[p]:,.2f} rev, {margin:.1f}% margin')

high_margin = [(p, prod_profit[p]/prod_rev[p]*100) for p in prod_rev if prod_count[p] >= 5 and prod_rev[p] > 0]
high_margin.sort(key=lambda x: x[1], reverse=True)
print('\nTop 10 Highest-Margin Products (min 5 appearances):')
for p, m in high_margin[:10]:
    print(f'  {p}: {m:.1f}% margin, ${prod_rev[p]:,.2f} rev, qty={prod_qty[p]:.0f}')

neg = [r for r in data if r['gross_profit'] < 0]
print(f'\nNegative-profit line items: {len(neg)}')
for r in neg:
    print(f'  Order {r["order_num"]} line {r["order_line"]} product {r["product"]}: price=${r["ext_price"]:.2f} cost=${r["gross_cost"]:.2f} profit=${r["gross_profit"]:.2f}')

po_flagged = [r for r in data if r['po_line'] != 0]
print(f'\nLines with non-zero P/O Line (special/drop-ship): {len(po_flagged)}')

top_lines = sorted(data, key=lambda x: x['ext_price'], reverse=True)[:10]
print('\nTop 10 Largest Single Line Items by Price:')
for r in top_lines:
    print(f'  Order {r["order_num"]} line {r["order_line"]} product {r["product"]}: ${r["ext_price"]:.2f} (profit ${r["gross_profit"]:.2f}, margin {r["gross_profit"]/r["ext_price"]*100:.1f}%)')

# Order size distribution
size_buckets = {'1 line': 0, '2-5 lines': 0, '6-10 lines': 0, '11-20 lines': 0, '20+ lines': 0}
for o in orders:
    n = order_lines[o]
    if n == 1:
        size_buckets['1 line'] += 1
    elif n <= 5:
        size_buckets['2-5 lines'] += 1
    elif n <= 10:
        size_buckets['6-10 lines'] += 1
    elif n <= 20:
        size_buckets['11-20 lines'] += 1
    else:
        size_buckets['20+ lines'] += 1
print('\nOrder Size Distribution (by line count):')
for k, v in size_buckets.items():
    print(f'  {k}: {v} orders ({v/len(orders)*100:.1f}%)')

# Low-margin line items (below 5%)
low_margin = [r for r in data if r['ext_price'] > 0 and r['gross_profit']/r['ext_price'] < 0.05]
print(f'\nLow-margin line items (below 5%): {len(low_margin)} ({len(low_margin)/len(data)*100:.1f}% of all lines)')
print(f'  Combined revenue from low-margin lines: ${sum(r["ext_price"] for r in low_margin):,.2f}')

# High-value orders (revenue > $5000)
big_orders = [(o, rev) for o, rev in order_rev.items() if rev > 5000]
big_orders.sort(key=lambda x: x[1], reverse=True)
print(f'\nOrders with revenue > $5,000: {len(big_orders)}')
print(f'  Combined revenue: ${sum(r[1] for r in big_orders):,.2f} ({sum(r[1] for r in big_orders)/total_price*100:.1f}% of total)')
