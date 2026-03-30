-- SQL to handle BRANCHPC field with zip codes (5-digit or 9-digit with dash)
-- Table: HYPBRCJOB
-- Field: BRANCHPC (10 characters, contains zip code)
-- Handles: 5-digit zips, 9-digit zips with dash (12345-6789), or continuous 9-digit

SELECT
  CASE
    -- If contains dash, split and pad both parts
    WHEN LOCATE('-', TRIM(BRANCHPC)) > 0 THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, LOCATE('-', TRIM(BRANCHPC)) - 1), 5, '0') || '-' ||
      LPAD(SUBSTR(TRIM(BRANCHPC), LOCATE('-', TRIM(BRANCHPC)) + 1), 4, '0')
    -- If 9 continuous digits, insert dash after 5th digit
    WHEN LENGTH(TRIM(BRANCHPC)) = 9 AND TRIM(BRANCHPC) NOT LIKE '%-%' THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, 5), 5, '0') || '-' ||
      SUBSTR(TRIM(BRANCHPC), 6, 4)
    -- If 5 digits or less, just pad to 5 digits
    WHEN LENGTH(TRIM(BRANCHPC)) <= 5 THEN
      LPAD(TRIM(BRANCHPC), 5, '0')
    -- Handle other cases (6-8 digits) - pad to 5 and truncate if needed
    ELSE
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, 5), 5, '0')
  END AS FORMATTED_ZIPCODE,
  BRANCHPC AS ORIGINAL_BRANCHPC,
  LENGTH(TRIM(BRANCHPC)) AS ORIGINAL_LENGTH
FROM HYPBRCJOB;

-- Alternative simpler approach - just handle the most common cases:
SELECT
  CASE
    -- Already has dash - pad both sides
    WHEN TRIM(BRANCHPC) LIKE '%-%' THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, LOCATE('-', TRIM(BRANCHPC)) - 1), 5, '0') || '-' ||
      LPAD(SUBSTR(TRIM(BRANCHPC), LOCATE('-', TRIM(BRANCHPC)) + 1), 4, '0')
    -- 9 continuous digits - add dash
    WHEN LENGTH(TRIM(BRANCHPC)) = 9 THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, 5), 5, '0') || '-' ||
      SUBSTR(TRIM(BRANCHPC), 6, 4)
    -- 5 or fewer digits - just pad
    ELSE
      LPAD(TRIM(BRANCHPC), 5, '0')
  END AS FORMATTED_ZIPCODE,
  BRANCHPC AS ORIGINAL_BRANCHPC
FROM HYPBRCJOB;

-- If you want to update the field in place:
UPDATE HYPBRCJOB
SET BRANCHPC =
  CASE
    WHEN TRIM(BRANCHPC) LIKE '%-%' THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, LOCATE('-', TRIM(BRANCHPC)) - 1), 5, '0') || '-' ||
      LPAD(SUBSTR(TRIM(BRANCHPC), LOCATE('-', TRIM(BRANCHPC)) + 1), 4, '0')
    WHEN LENGTH(TRIM(BRANCHPC)) = 9 THEN
      LPAD(SUBSTR(TRIM(BRANCHPC), 1, 5), 5, '0') || '-' ||
      SUBSTR(TRIM(BRANCHPC), 6, 4)
    ELSE
      LPAD(TRIM(BRANCHPC), 5, '0')
  END
WHERE TRIM(BRANCHPC) <> '';

-- Examples of what this handles:
-- Original -> Result
-- '123     ' -> '00123'
-- '12345   ' -> '12345'
-- '123456789' -> '12345-6789'
-- '12345-678' -> '12345-0678'
-- '123-4567 ' -> '00123-4567'
-- '1234-56  ' -> '01234-0056'