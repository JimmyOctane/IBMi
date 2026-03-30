-- SQL script to test the XML IFS reader program
-- This script demonstrates how to use the created program and view the results

-- First, call the program to process XML files from /home/Nueco
-- (This would typically be done through CALL PGM(READ_XML_IFS) in the IBM i environment)

-- Query the processed XML files table
SELECT 
    file_name,
    file_path,
    processed_date,
    LENGTH(xml_content) as content_size
FROM session.xml_files
ORDER BY processed_date DESC;

-- Query the parsed XML table data view
SELECT 
    file_name,
    element_name,
    element_value,
    element_path
FROM session.xml_table_data
WHERE element_value IS NOT NULL 
    AND TRIM(element_value) <> ''
ORDER BY file_name, element_path;

-- Example: Find specific XML elements (adjust based on your XML structure)
SELECT 
    file_name,
    element_name,
    element_value
FROM session.xml_table_data
WHERE UPPER(element_name) LIKE '%TABLE%'
    OR UPPER(element_name) LIKE '%ROW%'
    OR UPPER(element_name) LIKE '%DATA%'
ORDER BY file_name, element_name;

-- Count XML files processed
SELECT 
    COUNT(*) as total_files,
    MIN(processed_date) as first_processed,
    MAX(processed_date) as last_processed
FROM session.xml_files;

-- Show XML file details with content preview
SELECT 
    file_name,
    LENGTH(xml_content) as size_bytes,
    SUBSTR(xml_content, 1, 200) as content_preview
FROM session.xml_files
ORDER BY file_name;