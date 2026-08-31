**FREE
// -------------------------------------------------------------------
// Program Name - OEC2000
//
// Copyright Mincron SBC Corp. 1983, 1990, 2006.
//
// Order Entry/Maintenance Menu
//
// SQLRPGLE conversion notes:
// - Converted from CLP menu driver KIOSKC
// - Preserves menu option routing and redisplay behavior
// - Display file KIOSKD provides the option input fields
// - Called programs remain external dependencies
// - Source intentionally keeps only variables used by this module
// -------------------------------------------------------------------

ctl-opt dftactgrp(*no) actgrp(*caller) bnddir('ECBIND') option(*srcstmt:*nodebugio);

/COPY qcpysrc,RUNCMND_CP

dcl-pr OEC2018 extpgm('OEC2018');
end-pr;

dcl-pr OERC620 extpgm('OERC620');
end-pr;
dcl-pr IVR0420 extpgm('IVR0420');
  p1 packed(7:0) const;
  p2 packed(3:0) const;
  p3 char(1) const;
  p4 char(1) const;
end-pr;
dcl-pr OER4010 extpgm('OER4010');
end-pr;

dcl-pr OER2050 extpgm('OER2050');
end-pr;

dcl-pr OERC615 extpgm('OERC615');
end-pr;
dcl-pr OER5006 extpgm('OER5006');
  p1 char(10) const;
end-pr;
dcl-pr OER6060 extpgm('OER6060');
  p1 char(30) const;
  p2 char(15) const;
  p3 char(7) const;
  p4 packed(6:0) const;
  p5 packed(3:0) const;
  p6 packed(6:0) const;
  p7 char(1) const;
end-pr;
dcl-pr OER1075 extpgm('OER1075');
end-pr;
dcl-pr OPR0105 extpgm('OPR0105');
  p1 char(9) const;
end-pr;
dcl-pr OPR0100 extpgm('OPR0100');
  p1 char(9) const;
  p2 char(10) const;
  p3 char(1) const;
end-pr;
dcl-pr OEC1063 extpgm('OEC1063');
  p1 packed(7:0) const;
  p2 char(1) const;
end-pr;
dcl-pr OER4130 extpgm('OER4130');
  p1 char(1) const;
  p2 char(7) const;
  p3 char(2000) const;
  p4 char(7) const;
  p5 char(7) const;
end-pr;

dcl-pr SIGNON extpgm('SIGNON');
end-pr;

dcl-pr RSTLIBL extpgm('RSTLIBL');
  pEnv char(4) const;
end-pr;

dcl-f KIOSKD workstn;

dcl-s Branch   packed(3:0) inz;
dcl-s Customer packed(6:0) inz;
dcl-s Item     packed(6:0) inz;
dcl-s lineNumber packed(3:0) inz;
dcl-s PGMNAM   char(10);
dcl-s USER     char(10) inz(' ');
dcl-s APPL     char(2) inz('OE');
dcl-s LVL      char(2) inz('01');
dcl-s OPT      char(2) inz(' ');
dcl-s AUTH     char(1) inz('Y');
dcl-s FPATH    char(9) inz(' ');
dcl-s CMDLIN   char(9) inz(' ');
dcl-s screen1  ind inz(*on);
dcl-s IN92     char(1) inz('0');
dcl-s IN99     char(1) inz('0');
dcl-s CRTMOD   char(1) inz('N');
dcl-s CUSTNO   char(7) inz(' ');
dcl-s OEDS     char(2000) inz(' ');
dcl-s CRDNO    char(7) inz(' ');
dcl-s WRNTNO   char(7) inz(' ');
dcl-s ORDER    packed(7:0) inz(*zeros);
dcl-s RETURNFIELD char(1) inz(' ');
dcl-s FPGM     char(10) inz(' ');
dcl-s RTNCDE   ind inz(*off);
dcl-s BAROPT   packed(1:0) inz(0);
dcl-s PASSOPTION char(7) inz(*blanks);
dcl-s prodTest char(10) inz;
dcl-s Q char(1) inz('''');
dcl-s endscreen2 ind inz(*off);

*inlr = *on;

 // pull in production or test dataarea
 reset prodTest;
 exec sql
   select data_area_value
   into :prodTest
   from qsys2.data_area_info
   where data_area_name = 'PRODTEST'
     and data_area_library = 'QGPL';

// Restore the library list for the current environment.
RSTLIBL(prodTest);

dow screen1 = *on;
  exfmt KIOSKD1;

  CMDLIN = %trim(CMDLIN);
  FPATH = CMDLIN;

  if FPATH <> ' ' and not (%subst(FPATH:1:1) >= '0' and %subst(FPATH:1:1) <= '13');
    if %subst(FPATH:1:1) = '?';
      OPR0105(FPATH);
      RETURNFIELD = '0';
      OPR0100(FPATH: FPGM: RETURNFIELD);
      BAROPT = 0;
      PASSOPTION = 'X' + Q + '000F' + Q;
      commandString =
      'CALL PGM(' + %trim(FPGM) +  ') PARM('  +%trim(PASSOPTION) + ')';
      runIBMCommand(commandString);
    else;
      RETURNFIELD = '0';
      OPR0100(FPATH: FPGM: RETURNFIELD);
      // now we have the program lets call it
      select;
        // transfer control
       when RETURNFIELD = '0';
        PASSOPTION = 'X' + Q + '000F' + Q;
        commandString =
        'CALL PGM(' + %trim(FPGM) +  ') PARM('  +%trim(PASSOPTION) + ')';
        runIBMCommand(commandString);
        // error code
       when RETURNFIELD = '1';
      endsl;
    endif;

  endif;

  if *in03 = *on;
    WarnExitScreen();
  elseif *in16 = *on;
    screen1 = *off;
  else;
    select;
      when CMDLIN = '1';
        OEC2018();
      when CMDLIN = '2';
        OERC620();
      when CMDLIN = '3';
        IVR0420(Branch: Item: ' ': ' ');
      when CMDLIN = '4';
        OER4010();
      when CMDLIN = '5';
        OER2050();
      when CMDLIN = '6';
        OERC615();
      when CMDLIN = '7';
        OER5006('OER2095   ');
      when CMDLIN = '8';
        OER5006('OER2090   ');
      when CMDLIN = '9';
        OER5006('OER2098   ');
      when CMDLIN = '10';
        OER6060(*blanks:*blanks:*blanks:Item:lineNumber:Customer:'I');
      when CMDLIN = '11';
        *inlr = *off;
        ORDER = *zeros;
        RETURNFIELD = ' ';
        commandString = 'CHGDTAARA DTAARA(*LDA *ALL) VALUE('''' '''')';
        runIBMCommand(commandString);
        OEC1063(ORDER: RETURNFIELD);
      when CMDLIN = '12';
        OER1075();
      when CMDLIN = '13';
        CRTMOD = 'Y';
        OER4130(CRTMOD: CUSTNO: OEDS: CRDNO: WRNTNO);
      when CMDLIN = '14';
        SIGNON();
      other;
        // No additional processing
    endsl;
  endif;
enddo;

dcl-proc WarnExitScreen;
  dcl-pi *n;
  end-pi;

  endscreen2 = *off;

  dow not endscreen2;
    exfmt KIOSKWN;

    if *in03 = *on;
      endscreen2 = *on;
      screen1 = *on;
    else;
      endscreen2 = *on;
      screen1 = *off;
    endif;
  enddo;

end-proc;
