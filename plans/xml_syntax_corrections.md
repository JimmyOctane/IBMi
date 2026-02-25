# XML Syntax Corrections for SQL.SQLRPGLE

## Overview
This document identifies XML syntax errors found in [`SQL.SQLRPGLE`](../QRPGLESRC/sql.sqlrpgle:1) and provides corrections.

## Identified Issues

### 1. **Truncated/Unclosed Tags**

#### Line 38-39: `<docImageUrl>` tag
**Issue**: URL is truncated mid-value, tag never closes
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/T_TN2026021352207_202602231140
</entry>
```
**Should be**:
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/T_TN2026021352207_20260223114002.pdf</docImageUrl>
</entry>
```

#### Line 168: `<name>` tag
**Issue**: Text is truncated mid-sentence
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agree
```
**Should be**:
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agreement?</name>
```

#### Line 175: `<name>` tag
**Issue**: Text is truncated mid-sentence
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to t
```
**Should be**:
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to this agreement?</name>
```

#### Line 182: `<name>` tag
**Issue**: Text is truncated mid-sentence
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under anoth
```
**Should be**:
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under another company name in the past?</name>
```

#### Line 327-328: `<docImageUrl>` tag
**Issue**: URL is truncated mid-value
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/T_TN2026021352210_202602231144
```
**Should be**:
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/T_TN2026021352210_20260223114446.pdf</docImageUrl>
```

#### Line 429: `<name>` tag
**Issue**: Text is truncated mid-sentence
```xml
<name>If yes, please provide their name, phone, email and area of expertise (equipment, supplies, al
```
**Should be**:
```xml
<name>If yes, please provide their name, phone, email and area of expertise (equipment, supplies, all)</name>
```

#### Line 464: `<name>` tag
**Issue**: Text is truncated (duplicate of line 168)
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agree
```
**Should be**:
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agreement?</name>
```

#### Line 485: `<name>` tag
**Issue**: Text is truncated (duplicate of line 175)
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to t
```
**Should be**:
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to this agreement?</name>
```

#### Line 499: `<name>` tag
**Issue**: Text is truncated (duplicate of line 182)
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under anoth
```
**Should be**:
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under another company name in the past?</name>
```

#### Line 576-577: `<docImageUrl>` tag
**Issue**: URL is truncated mid-value
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/G_TN2026021352210_202602231143
```
**Should be**:
```xml
<docImageUrl>https://d3q2ltxdm0acu1.cloudfront.net/PI_TN2026021289684/G_TN2026021352210_20260223114346.pdf</docImageUrl>
```

#### Line 807: `<name>` tag
**Issue**: Text is truncated (duplicate of line 168)
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agree
```
**Should be**:
```xml
<name>Has there ever been any Bankruptcy or Wage Earner proceedings filed by any party to this agreement?</name>
```

#### Line 814: `<name>` tag
**Issue**: Text is truncated (duplicate of line 175)
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to t
```
**Should be**:
```xml
<name>Are there any unsatisfied liens, judgments, or pending collection suits against any party to this agreement?</name>
```

#### Line 821: `<name>` tag
**Issue**: Text is truncated (duplicate of line 182)
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under anoth
```
**Should be**:
```xml
<name>Have any Principles of the company conducted business with East Coast Metal Dist., under another company name in the past?</name>
```

### 2. **Missing XML Declaration**
**Issue**: File starts directly with content instead of proper XML declaration
```xml
This XML file does not appear to have any style information associated with it. The document tree is
<inbound-customer-data xmlns="http://www.bectran.com/">
```
**Should be**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<inbound-customer-data xmlns="http://www.bectran.com/">
```

## Summary of Issues
- **12 truncated text fields** in `<name>` tags across 3 customer records
- **4 truncated URLs** in `<docImageUrl>` tags
- **Missing XML declaration** at the beginning of the file
- **Line 1 contains non-XML text** that should be removed

## Impact
These syntax errors would cause:
1. XML parsers to fail validation
2. Data loss due to truncated values
3. Improper parsing of document structure
4. Potential application errors when reading the XML

## Recommendation
Create a corrected version of the XML file with:
- Proper XML declaration header
- Complete closing tags for all elements
- Full text for all truncated fields
- Complete URLs for all document references
