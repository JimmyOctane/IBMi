// Address consolidation logic
if IADDR1 <> *BLANKS and IADDR2 = *BLANKS and IADDR3 <> *BLANKS;
    IADDR2 = IADDR1;
    clear IADDR1;
endif;

// Initialize control variables
CASE## = CASE;           // Case control
ADRL## = MAXADRL;        // Max address Length
FIRM## = INAME;          // Firm name

// Address field assignment based on max address length
// Check if combined address length exceeds field limit
addressLength = %len(%trim(IADDR2)) + %len(%trim(IADDR3));

select;
    when addressLength <= MAXADRL and IADDR2 <> *BLANKS and IADDR3 <> *BLANKS;
        DADR## = IADDR2 + IADDR3;  // Use addr 2&3 as DEL when combined length fits
        
    when IADDR3 <> *BLANKS and IADDR2 <> *BLANKS;
        DADR## = IADDR3;           // Use addr 3 as DEL
        SADR## = IADDR2;           // Use addr 2 as SEC
        
    when IADDR3 = *BLANKS and IADDR2 <> *BLANKS and IADDR1 <> *BLANKS;
        DADR## = IADDR2;           // Use addr 2 as DEL
        SADR## = IADDR1;           // Use addr 1 as SEC
        
    when IADDR3 = *BLANKS and IADDR2 = *BLANKS and IADDR1 <> *BLANKS;
        DADR## = IADDR1;           // Use addr 1 as DEL
        
    when IADDR3 <> *BLANKS and IADDR2 = *BLANKS and IADDR1 <> *BLANKS;
        DADR## = IADDR3;           // Use addr 3 as DEL
        SADR## = IADDR1;           // Use addr 1 as SEC
endsl;

// City, State assignment
CITY## = ICITY;          // CITY
STAT## = ISTATE;         // STATE
ZIPCODE = IZIP;

// ZIP code processing
select;
    when POS6 = '-' and POS7TO10 <> *BLANKS;
        ZIPC## = IZIP;           // ZIP
        ZIP4## = %subst(IZIP: 7: 4);  // ZIP+4 (assuming MOVE extracts last 4)
        
    when POS6 = '-' and POS7TO10 = *BLANKS;
        ZIPC## = IZIP;           // ZIP
        
    when POS6 <> '-' and POS6 <> ' ';
        ZIPC## = IZIP;           // ZIP
        ZIP4## = POS6TO9;        // ZIP+4
        
    when POS6 = ' ' and POS7TO10 = *BLANKS;
        ZIPC## = IZIP;           // ZIP
endsl;