       ctl-opt option(*srcstmt: *nodebugio) debug;
       ctl-opt bnddir('HTTPAPI');
       ctl-opt nomain;
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - OPV9106                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,1994.                           *
     F*------------------------------------------------------------------------*
     F*D Rest API - HTTPAPI using Pointers                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    This service program contains common procedures used to connect    *
     F*S    to web services via the HTTPAPI using pointers for parms           *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000014007 110520 275 HTTP METHODS USING HTTPAPI                      *
AB   F*E 8000014656 040626 275 Fix issue getting response headers              *
     F*M ----------------------------------------------------------------------*
      //----------------------------------------------------------------------
      //Working fields
      //----------------------------------------------------------------------

      //----------------------------------------------------------------------
      //Constants
      //----------------------------------------------------------------------   '
       dcl-c CRLF                  x'0d25';
       dcl-c NULL                  x'00';
       dcl-c LOWER                 'abcdefghijklmnopqrstuvwxyz';
       dcl-c UPPER                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

       dcl-s notes        char(200);
       dcl-s strpos       int(3);

      //----------------------------------------------------------------------
      //Prototypes
      //----------------------------------------------------------------------
       /include qcpysrc,hdy9106
       /include qrpglesrc,httpapi_h

      //----------------------------------------------------------------------
      // Procedure: get_http_prop
      // ----------------------------------------------------------------------
       dcl-pr get_http_prop extpgm('OPR0117');
         readTimeOut    packed(3: 0);
         readRetry      packed(2: 0);
         pgmname        char(10) const;
       end-pr;
      //----------------------------------------------------------------------
      // Procedure: web2_get
      // Description: Uses the axis transport to call a web service via a GET.
      //
      // Parms: uri - the endpoint of the service
      //        header - header values to include in the service.
      //
      // Returns: the response fo the service.
      // ----------------------------------------------------------------------
       dcl-proc web2_get export;
       dcl-pi *n;
         uri          char(1024) const;
         httpHeader   likeds(httpHeader_t);
         response_p   pointer;
         trace        char(1) const;
         certreq      char(1) const;
         pgmname      char(10) const;
       end-pi;
         dcl-s request_p pointer;

         request_p = *NULL;

         web2_send(uri: 'GET': httpHeader: trace: certreq: pgmname:
                   request_p: response_p);
       end-proc;
      //----------------------------------------------------------------------
      // Proc postMethod - Sends the specified request to the specified url
      //                   using the post http method.
      //
      //  parms: request data - formatted json string
      //
      //  return: nothing
      // ----------------------------------------------------------------------
       dcl-proc web2_post export;
       dcl-pi *n;
         uri          char(1024) const;
         httpHeader   likeds(httpHeader_t);
         request_p    pointer;
         response_p   pointer;
         trace        char(1) const;
         certreq      char(1) const;
         pgmname      char(10) const;
       end-pi;

         web2_send(uri: 'POST': httpHeader: trace: certreq:
                  pgmname: request_p: response_p);
       end-proc;
      //----------------------------------------------------------------------
      // Proc putMethod - Sends the specified request to the specified url
      //                   using the put http method.
      //
      //  parms: request data - formatted json string
      //
      //  return: nothing
      // ----------------------------------------------------------------------
       dcl-proc web2_put export;
       dcl-pi *n;
         uri          char(1024) const;
         httpHeader   likeds(httpHeader_t);
         request_p    pointer;
         response_p   pointer;
         trace        char(1) const;
         certreq      char(1) const;
         pgmname      char(10) const;
       end-pi;

         web2_send(uri: 'PUT': httpHeader: trace: certreq:
                   pgmname: request_p: response_p);
       end-proc;
      //----------------------------------------------------------------------
      // Proc deleteMethod - Sends the specified request to the specified url
      //                     using the delete http method.
      //
      //  parms: request data - formatted json string
      //
      //  return: nothing
      // ----------------------------------------------------------------------
       dcl-proc web2_delete export;
       dcl-pi *n;
         uri          char(1024) const;
         httpHeader   likeds(httpHeader_t);
         req_p        pointer options(*omit);
         response_p   pointer;
         trace        char(1) const;
         certreq      char(1) const;
         pgmname      char(10) const;
       end-pi;

         dcl-s request_p pointer;

         if (%addr(req_p) = *null);
           request_p = *NULL;
         else;
           request_p = req_p;
         endif;


         web2_send(uri: 'DELETE': httpHeader: trace: certreq:
                   pgmname: request_p: response_p);
       end-proc;
      //----------------------------------------------------------------------
      // Private procedures
      //----------------------------------------------------------------------

      //----------------------------------------------------------------------
      // Procedure: web_setHeader
      // Description: Uses the web transport to call a web service via a GET.
      //
      // Parms: uri - the endpoint of the service
      //        header - header values to include in the service.
      //
      // Returns: the response fo the service.
      // ----------------------------------------------------------------------
       dcl-proc web2_setHeader;
       dcl-pi *n;
         header        varchar(32767);
         vars          likeds(header_t) dim(50) const;
       end-pi;

         dcl-s i             int(10);

         header = '';

         for i = 1 to %elem(vars);
           if (vars(i).key = *blanks);
             leave;
           endif;

           if (%xlate(LOWER: UPPER: vars(i).key) <> 'CONTENT-TYPE');
           header += %trim(vars(i).key) + ':'
                   + %trim(vars(i).value) + CRLF;
           endif;
         endfor;

       end-proc;
      //----------------------------------------------------------------------
      // Procedure: web_getResponseHeaders
      // Description: Retrieves http response header info.
      //
      // Parms: tHandle - the pointer to the transport.
      //        ResponseKeys - the key values to pull from the response.
      //
      // Returns: the response fo the service.
      // ----------------------------------------------------------------------
       dcl-proc web2_getRespHeader;
       dcl-pi *n ;
         header        varchar(32767);
         respHeader    likeds(header_t) dim(50);
       end-pi;

         dcl-s i             int(10);
         dcl-s idx           int(10);
         dcl-s crlfIdx       int(10);
         dcl-s upHeader      like(header);
         dcl-s upKey         like(header_t.key);

         upHeader = %xlate(LOWER: UPPER: header);

       // Loop through response headers and look for them in the
       // response header.  If found parse out the value.
         for i = 1 to %elem(respHeader);
           if (respHeader(i).key = *blanks);
             leave;
           endif;

           upKey = %xlate(LOWER: UPPER: respHeader(i).key);
   AB  //  idx   = %scan(upKey: upHeader);
AB         idx   = %scan(%trim(upKey): upHeader);
           if (idx > 0);
             idx += %len(%trim(respHeader(i).key)) + 1;
             crlfIdx = %scan(CRLF: header: idx);

             if (crlfIdx = 0);
               crlfIdx = %len(%trim(header)) + 1;
             endif;

   AB  //    respHeader(i).value = %subst(header: idx: crlfIdx - idx);
AB           respHeader(i).value = %trim(%subst(header: idx: crlfIdx - idx));

           endif;
         endfor;

       end-proc;
      //----------------------------------------------------------------------
      // Procedure: web2_send
      // Description: Uses the axis transport to call a web service.
      //
      // Parms: uri - the endpoint of the service
      //        method - crud operation.
      //        header - header values to include in the service.
      //
      // Returns: the response of the service.
      // ----------------------------------------------------------------------
       dcl-proc web2_send;
       dcl-pi *n;
         inURL          char(1024) const;
         inMethod       char(6) const;
         httpHeader     likeds(httpHeader_t) ;
         inTrace          char(1) const;
         certreq        char(1) const;
         inPgmname        char(10) const;
         request_p      pointer options(*omit);
         response_p     pointer options(*omit);
       end-pi;

         dcl-s readTimeOut    packed(3: 0);
         dcl-s readRetry      packed(2: 0);
         dcl-ds request      likeds(request_t) based(request_p);
         dcl-ds response     likeds(response_t) based(response_p);
         dcl-s rc        int(10);
         dcl-s retry     int(10);
         dcl-s contentType like(header_t.value);
         dcl-s i           int(10);

         dcl-c UPPER                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
         dcl-c LOWER                   'abcdefghijklmnopqrstuvwxyz';

      // Log http api.  File will be /tmp/httpapi_debug.txt
         if (inTrace = 'Y');
           http_debug(*on);
         endif;

      // Set Timeout
         get_http_prop(readTimeOut: readRetry: inPgmName);
         http_setOption('timeout': %char(readTimeout));

      // Hook up Header info
         http_xproc( HTTP_POINT_ADDL_HEADER
                   : %paddr(web2_setHeader)
                   : %addr(httpHeader.headers(1).key)
         );

      // Hook up response header procedure
AB       for i = 1 to %elem(httpHeader.rspHeaderKeys);
AB         if (httpHeader.rspHeaderKeys(i) = *blanks);
AB           leave;
AB         endif;
AB         response.headers(i).key = httpHeader.rspHeaderKeys(i);
AB       endfor;
AB
         http_xproc( HTTP_POINT_PARSE_HDR_LONG
                   : %paddr(web2_getRespHeader)
                   : %addr(response.headers(1).key)
         );

      // Look if content-type specified
         contentType = 'text/xml';

         for i = 1 to %elem(httpHeader.headers);
           if (httpHeader.headers(i).key = *blanks);
             leave;
           endif;

           if (%xlate(LOWER: UPPER: httpHeader.headers(i).key)
               = 'CONTENT-TYPE');
             contentType = httpHeader.headers(i).value;
             leave;
           endif;
         endfor;

      // Send Request
         retry = readRetry;
         dow (retry >= 0);
           retry = retry - 1;

           response.msg = '';
           response.status = *blanks;
           response.error = *blanks;

           if (request_p = *NULL);
             rc = http_req(inMethod: inURL: *OMIT
                          : response.msg: *OMIT: *OMIT
                          :contentType);
           else;
             rc = http_req(inMethod: inURL: *OMIT
                          : response.msg: *OMIT: request.msg
                          :contentType);
           endif;

           if (rc = 1);
             response.status = '200';
           else;
             response.status = %char(rc);
             if (%subst(response.status: 1: 1) <> '2');
               response.error = http_error(*omit: rc);
               response.status = %char(rc);
             endif;
           endif;

       // Decerment retry on error
           if (response.error <> *blanks and retry >= 0);
             clear StrPos;
             StrPos = %scan('operation timed out' : response.error);

             //  No Timeout error?
             if (StrPos = 0);
               clear StrPos;
               StrPos = %scan('Failed to open connection' : response.error);

               // No Connection error?
               if (StrPos = 0);
                 // Do not retry if no Timeout/Connection errors occurred...
                 retry = -1;
               endif;
             endif;
           endif;

       // No errors? End loop...
           if (response.error = *blanks);
             retry = -1;
           endif;

         enddo;

       // Write to API log file if API trace set to Y or
       // error in send/receive or HTTP status code is not 200-299
          notes   = *blanks;

        if  response.error <> *blanks;
               notes = 'Programmer: check response error; check IBM Copybook +
                        in AIV9105 for Transport API PTF changes etc.';
          web2_LOG('HTTP_ERR': inURL: request_p: response_p: inPgmName: Notes);
        Else;

         if   %subst(response.status: 1: 1) <> '2'  ;
               notes = 'Programmer:  HTTP status is not 200-299. Google HTTP  +
                                Status Code for the code meaning.';

          web2_LOG('HTTP_ERR': inURL: request_p: response_p: inPgmName: Notes);

         Else;
          if  inTrace = 'Y' ;
               notes = 'Programmer: Config setting for this APITrace +
                                is set to Y.';
          web2_LOG('HTTP_ERR': inURL: request_p: response_p: inPgmName: Notes);

          Endif;
         Endif;
        Endif;

       end-proc;
      //----------------------------------------------------------------------
      // Procedure: web2_log
      // Description: Writes logging record.
      //
      // Parms: LogType - \ZHTTP_ERR\Z or \ZTRACE_ON\Z or \ZJSON_ERR\Z
      //        uri - the endpoint of the service
      //        response - for the service
      //        APIName - program name
      //        Notes - message built and passed in
      //        Request - formatted json string
      //
      // ----------------------------------------------------------------------
        dcl-proc web2_log export;
        dcl-pi *n;
         LogType      char(10) const;
         uri          char(1024) const;
         request_p    pointer;
         response_p   pointer;
         PgmName      char(10) const;
         Notes        char(200);
        end-pi;

        dcl-s logData      char(32000);
        dcl-ds request      likeds(request_t) based(request_p);
        dcl-ds response     likeds(response_t) based(response_p);
       //
       // Write to API log file if API trace set to Y or
       // error in send/receive or HTTP status code is not 200-299
              logData = *blanks;
              logData = URI;
              exec sql insert into aiqwrlog (Area, RestRsp)
                       values('URI', :logData);
              logData = *blanks;
        // Do not reference request if pointer not passed...
              if request_p <> *null and request <> *blanks;
                logData = request.msg;
                exec sql insert into aiqwrlog (Area, RestRsp)
                       values('Request', :logData);
              endif;
              logData = *blanks;
              logData = response.msg;
              exec sql insert into aiqwrlog (Area, RestRsp)
                       values('respMsg', :logData);
              logData = *blanks;
              logData = 'APIName: ' + %trim(pgmName) +
                        ', HTTPStatus: ' + response.status +
                        ', HTTPError: ' + %trim(response.error) +
                        ', Notes: ' + %trim(notes);
              exec sql insert into aiqwrlog (Area, RestRsp)
                       values(:logtype, :logData);

       end-proc;

