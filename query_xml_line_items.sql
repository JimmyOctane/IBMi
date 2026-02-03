-- Query Examples for session.xml_line_items Table
-- =================================================

-- 1. View all line items from all files
SELECT * FROM session.xml_line_items
ORDER BY file_name, line_number;

-- 2. Get line items for a specific file
SELECT 
    line_number,
    product_name,
    quantity,
    amount,
    cost
FROM session.xml_line_items
WHERE file_name = 'order_123.xml'
ORDER BY line_number;

-- 3. Summary by product
SELECT 
    product_name,
    COUNT(*) as line_count,
    SUM(DECIMAL(quantity, 10, 2)) as total_quantity,
    SUM(DECIMAL(amount, 12, 2)) as total_amount
FROM session.xml_line_items
WHERE quantity IS NOT NULL AND amount IS NOT NULL
GROUP BY product_name
ORDER BY total_amount DESC;

-- 4. Line items with pricing details
SELECT 
    file_name,
    line_number,
    product_name,
    external_item_id,
    quantity,
    amount,
    cost,
    CASE 
        WHEN DECIMAL(cost, 12, 2) > 0 
        THEN DECIMAL(amount, 12, 2) - DECIMAL(cost, 12, 2)
        ELSE 0
    END as margin
FROM session.xml_line_items
WHERE amount IS NOT NULL AND cost IS NOT NULL
ORDER BY file_name, line_number;

-- 5. Join with order header to get complete order view
SELECT 
    h.job_name,
    h.account_name,
    h.vendor_name,
    l.line_number,
    l.product_name,
    l.quantity,
    l.amount
FROM session.xml_order_header h
JOIN session.xml_line_items l ON h.file_name = l.file_name
ORDER BY h.file_name, l.line_number;

-- 6. Find high-value line items
SELECT 
    file_name,
    line_number,
    product_name,
    quantity,
    amount
FROM session.xml_line_items
WHERE DECIMAL(amount, 12, 2) > 500.00
ORDER BY DECIMAL(amount, 12, 2) DESC;

-- 7. Count line items per order file
SELECT 
    file_name,
    COUNT(*) as line_count,
    MIN(processed_date) as first_processed
FROM session.xml_line_items
GROUP BY file_name
ORDER BY line_count DESC;

-- 8. Filter by specific product types
SELECT 
    file_name,
    line_number,
    product_name,
    type_code,
    external_item_id,
    quantity,
    amount
FROM session.xml_line_items
WHERE type_code = 'E'  -- or whatever type code you need
ORDER BY file_name, line_number;

-- 9. Get items with bundle information
SELECT 
    file_name,
    line_number,
    product_name,
    bundle_id,
    quantity,
    amount
FROM session.xml_line_items
WHERE bundle_id IS NOT NULL AND TRIM(bundle_id) <> ''
ORDER BY bundle_id, line_number;

-- 10. Monthly summary (if you have date info in file names or processed_date)
SELECT 
    YEAR(processed_date) as year,
    MONTH(processed_date) as month,
    COUNT(*) as total_lines,
    COUNT(DISTINCT file_name) as total_files
FROM session.xml_line_items
GROUP BY YEAR(processed_date), MONTH(processed_date)
ORDER BY year, month;