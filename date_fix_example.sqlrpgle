// Fixed date parsing code example
// Original problematic code:
// INSTR = '9/4/2025 12:00:00 AM                              '   
// :p1 = %scan(' ' : inStr);                                        
// p2 = %scan(':' : inStr : p1 + 1);                               
// p3 = %scan(':' : inStr : p2 + 1);                               
//                                                                
// myDate = %date(%subst(inStr:1:%scan(' ':inStr)) : *USA);        
// getting date error on muDate = dcl-s myDate      date;

// CORRECTED VERSION:

// Declare variables first
dcl-s inStr varchar(50) inz('9/4/2025 12:00:00 AM                              ');
dcl-s myDate date;
dcl-s p1 int(10);
dcl-s p2 int(10);
dcl-s p3 int(10);
dcl-s dateString varchar(10);

// Find positions for parsing
p1 = %scan(' ' : inStr);                                        
p2 = %scan(':' : inStr : p1 + 1);                               
p3 = %scan(':' : inStr : p2 + 1);

// Extract just the date part (before the first space)
dateString = %subst(inStr : 1 : p1 - 1);

// Convert to date - use *USA format for MM/DD/YYYY
// Note: Your date '9/4/2025' needs to be padded to '09/04/2025' for *USA
// OR use a different approach

// Method 1: Pad the date string for *USA format
monitor;
  // If single digits, this might fail with *USA, so let's try a different approach
  myDate = %date(dateString : *USA);
on-error;
  // If *USA fails, try parsing manually or use *ISO after conversion
  // For now, set a default or handle the error
  myDate = %date();  // Current date as fallback
endmon;

// Method 2: Alternative - convert to *ISO format first
// This is more robust for varying date formats
dcl-s isoDateString char(10);
dcl-s month char(2);
dcl-s day char(2);
dcl-s year char(4);
dcl-s slashPos1 int(10);
dcl-s slashPos2 int(10);

// Find slash positions
slashPos1 = %scan('/' : dateString);
slashPos2 = %scan('/' : dateString : slashPos1 + 1);

// Extract components
month = %subst(dateString : 1 : slashPos1 - 1);
day = %subst(dateString : slashPos1 + 1 : slashPos2 - slashPos1 - 1);
year = %subst(dateString : slashPos2 + 1);

// Pad single digits with leading zeros
if %len(%trim(month)) = 1;
  month = '0' + %trim(month);
endif;
if %len(%trim(day)) = 1;
  day = '0' + %trim(day);
endif;

// Build ISO format string (YYYY-MM-DD)
isoDateString = %trim(year) + '-' + %trim(month) + '-' + %trim(day);

// Convert to date using *ISO format
myDate = %date(isoDateString : *ISO);