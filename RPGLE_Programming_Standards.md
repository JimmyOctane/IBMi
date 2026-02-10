# RPGLE Programming Standards

## Display Operation (DSPLY) Guidelines

### Character Length Limitations

The [`DSPLY`](RPGLE_Programming_Standards.md:7) opcode in RPGLE has strict character length limitations that must be observed to prevent compilation errors and runtime issues.

#### Maximum Length Requirements

- **Total DSPLY Length**: The [`DSPLY`](RPGLE_Programming_Standards.md:12) opcode cannot exceed **52 characters** in total length
- This includes:
  - The literal text being displayed
  - Any variable content concatenated to the message
  - String manipulation functions like [`%trim()`](RPGLE_Programming_Standards.md:16)

#### Best Practices for DSPLY Usage

1. **Keep Messages Concise**: Design display messages to be clear but brief
2. **Split Long Messages**: Break lengthy messages into multiple [`DSPLY`](RPGLE_Programming_Standards.md:19) statements
3. **Use Variables**: Store formatted messages in variables when complex concatenation is needed
4. **Test Message Length**: Always verify that the final concatenated message doesn't exceed 52 characters

#### Examples

**✅ CORRECT - Within 52 character limit:**
```rpgle
dsply 'Process complete';                    // 16 characters
dsply 'Error: File not found';              // 21 characters  
dsply 'Count: ' + %char(recordCount);       // Variable length, verify total
```

**❌ INCORRECT - Exceeds 52 character limit:**
```rpgle
dsply 'UNEXPECTED: Non-existent file returned Success=true';  // 53+ characters
dsply 'SUCCESS: Non-existent file correctly failed';         // 43+ characters (may exceed with variables)
```

**✅ CORRECTED - Split into multiple statements:**
```rpgle
dsply 'UNEXPECTED: Non-existent file';
dsply 'returned Success=true';

dsply 'SUCCESS: Non-existent file';
dsply 'correctly failed';
```

#### Troubleshooting DSPLY Length Issues

When encountering DSPLY length violations:

1. **Count Characters**: Manually count the total character length including variables
2. **Use Variables**: Store complex concatenations in [`varchar`](RPGLE_Programming_Standards.md:44) variables first
3. **Split Messages**: Break into logical, readable chunks
4. **Abbreviate**: Use standard abbreviations where appropriate (e.g., "Doc" for "Document")

#### Variable-Based Alternative

For complex messages, use variables to control length:

```rpgle
dcl-s displayMsg varchar(50);

// Build message with length control
displayMsg = 'Error: ' + %trim(errorText);
if %len(displayMsg) > 50;
  displayMsg = %subst(displayMsg : 1 : 47) + '...';
endif;
dsply displayMsg;
```

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-10  
**Author**: East Coast Metals Development Team