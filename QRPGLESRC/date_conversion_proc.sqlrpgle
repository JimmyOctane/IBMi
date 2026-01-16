// Date Conversion Procedure for AFSSFTPDR
// Handles non-padded date formats like "12/1/2025 9:38:00 AM"

dcl-proc convertCSVDateToDate;
  dcl-pi *n date;
    dateTimeStr varchar(50) const;
  end-pi;
  
  dcl-s dateStr varchar(20);
  dcl-s month varchar(2);
  dcl-s day varchar(2);
  dcl-s year varchar(4);
  dcl-s slashPos1 int(10);
  dcl-s slashPos2 int(10);
  dcl-s spacePos int(10);
  dcl-s isoDateStr char(10);
  dcl-s resultDate date;
  
  // Extract just the date part (before the space)
  spacePos = %scan(' ' : dateTimeStr);
  if spacePos = 0;
    dateStr = %trim(dateTimeStr);
  else;
    dateStr = %subst(dateTimeStr : 1 : spacePos - 1);
  endif;
  
  // Find slash positions
  slashPos1 = %scan('/' : dateStr);
  slashPos2 = %scan('/' : dateStr : slashPos1 + 1);
  
  if slashPos1 = 0 or slashPos2 = 0;
    // Invalid format - return current date
    return %date();
  endif;
  
  // Extract components
  month = %subst(dateStr : 1 : slashPos1 - 1);
  day = %subst(dateStr : slashPos1 + 1 : slashPos2 - slashPos1 - 1);
  year = %subst(dateStr : slashPos2 + 1);
  
  // Pad single digits with leading zeros
  if %len(%trim(month)) = 1;
    month = '0' + %trim(month);
  endif;
  if %len(%trim(day)) = 1;
    day = '0' + %trim(day);
  endif;
  
  // Build ISO format string (YYYY-MM-DD)
  isoDateStr = %trim(year) + '-' + %trim(month) + '-' + %trim(day);
  
  // Convert to date using *ISO format
  monitor;
    resultDate = %date(isoDateStr : *ISO);
  on-error;
    // If conversion fails, return current date
    resultDate = %date();
  endmon;
  
  return resultDate;
end-proc;