000100180322       Ctl-Opt Option(*NoDebugIO:*SRCSTMT);
000101180322       Ctl-Opt DftActGrp(*No);
000102180322
000103180322       Dcl-S  TIMDAY       Zoned(14:0);
000104180322       Dcl-Ds *n PSDS;
000105180322         user            Char(10)        Pos(254);
000106180322       End-Ds;
000107180322           Initialize();
000108180322        rtn = XLS_Visible(SQL_Socket:1);
000109180322       If user = 'KELLYM';
000110180322         IPaddress = '';
000111180322       EndIf;
000112180322M018|  //           if @mach = *blanks AND (specs = '17'
000113180322M018|  //           OR specs = '10');
000114180322M018|  //              errspec = *on;
000115180322M018|  //              errdcod = *on;
000116180322M018|  //           endif;
000117180322
000118180322
000119180322     C     SYSDAT        MULT      10000.0001    SWITCHDATE
000120180322     C     DATE6         MULT      10000.01      DATEIN
000121180322
000122180322         SwitchDate =  %Dec(%subst(%EditC(SYSDAT:'X'):7:2) +    //yy
000123180322                      %subst(%EditC(SYSDAT:'X'):1:2) +    //mm
000124180322                      %subst(%EditC(SYSDAT:'X'):3:2):6:0);//dd
000125180322
000126180322         DATEIN = %Dec(%subst(%EditC(DATE6:'X'):5:2) +
000127180322                        %subst(%EditC(DATE6:'X'):1:2) +
000128180322                        ('00'):8:0);
000129180322         DSCMDY = %Dec(
000130180322                     %Subst(%EditC(AOCYMD:'X'):3:4) +
000131180322                     %Subst(%EditC(AOCYMD:'X'):1:2) :6:0);
000132180322
000133180322         qcmd = 'KMLSPLFWM MAILBOX(*USER) TOADDR('  + %trim(EM2) +
000134180322                ') SUBJECT(' + '''' + %trim(subj2) + '''' + ') ' +
000135180322                'FROMADDR(' + %trim(EM2) + ') ' +
000136180322                'SPLFILE(ENG334T) SPLUSER(' + %trim(user) + ') ' +
000137180322                'SPLDESC(' + '''' + %trim(file2) + '''' + ') ' +
000138180322                'JOBNAME(*) ' +
000139180322                'SPLNBR(*LAST) RMVSPLF(*YES) TRANSLATE(6)';
000140180322
000141180322         qcmd = 'KMLPCFAT MAILMBR(TENG400) SUBJECT(' + %trim(subject) +
000142180322                ') FROMADDR(''Reporting@Smalley.com'')'  +
000143180322                ' FILENAME(' + '''' + %trim(filename) + ' ' +
000144180322                 %trim(monthyear) + '.xlsx' + '''' + ')' +
000145180322                ' FOLDER(' + ''''+ folder + '''' + ')';
000146180322
000147180322         *inlr = *on;
000148180322
000149180322       Dcl-Proc Initialize;
000150180322         //HHMMSSMMDDYYYY
000151180322         TIMDAY = %dec(%editc(%dec(%time()):'X')  +
000152180322                        %editc(%dec(%date():*usa):'X'):14:0);
000153180322       End-Proc Initialize;
000154180322       // ******************************************************************************************
000155180322       // ------------------------------------------------------------------------------------*
000156180322       //                          Modification Log                                           *
000157180322       // ------------------------------------------------------------------------------------*
000158180322       //  Mod# |  Date  |Pgmr|Ticket| Description                                            *
000159180322       // ------------------------------------------------------------------------------------*
000160180322       //       |11/28/17|KLM |      | Converted to Free Form                                 *
000161180322       //       |        |    |      |                                                        *
000162180322       //       |        |    |      |                                                        *
000163180322       // ------------------------------------------------------------------------------------*
000164180322       // ******************************************************************************************
000165180322       //       |KELLY |08/08/16 | Converted to Free Form
000166180322      *  8/08/2016  RETIRED - LAST USED 3/12/14    KLM
000167180322      *  8/08/2016  RETIRED - NEVERUSED            KLM
