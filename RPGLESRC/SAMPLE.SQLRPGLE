000100180322       Ctl-Opt OPTION(*NODEBUGIO:*SRCSTMT);
000200180322       Ctl-Opt DftActGrp(*No);
000300180322       Dcl-S Date            Date            Inz(*SYS);
000400180322       // new change
                   // new line added from GIT Hub source editor.
000900180322       // ===========================================
001000180322     D @charA          S              8    inz('04/12/01')
001100180322     D @charB          S             10    inz('12/02/2004')
001200180322     D @charC          S              8    inz('12/03/04')
001300180322
001400180322     D @dateA          S               d   inz(D'2004-12-04')
001500180322
001600180322     D @numA           S              6  0 inz(041205)
001700180322     D @numB           S              7  0 inz(1041206)
001800180322     D @numC           S              8  0 inz(20041207)
001900180322     D @numD           S              6  0 inz(120804)
002000180322     D @numE           S              8  0 inz(12092004)
002100180322
002200180322        Dcl-Ds *n;
002300180322         NUM83           Zoned(8:3);
002400180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
002500180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
002600180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
002700180322       End-Ds;
002800180322
002900180322       Dcl-Ds *n;
003000180322         NUM62           Zoned(6:2);
003100180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
003200180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
003300180322       End-Ds;
003400180322
003500180322      /free
003600180322       // *********************************************************************
003700180322           Initialize();
003800180322       //      If AYR > SIXYR;
003900180322       //            X = 0;
004000180322       //
004100180322 7     //            For X = 1 To 6;
004200180322       //              *IN58 = '0';
004300180322       //              X = %Lookup(AYR : YR : X);
004400180322       //              *IN58 = (X > 0);
004500180322       //              If X = 0;
004600180322       //                X = 1;
004700180322       //              EndIf;
004800180322       //              ENDFOR;
0049001803228      //              If *IN58 = '1';
005000180322       //              ENDIF;
005100180322       //     ENDIF;
005200180322
005300180322       //BECOMES THIS EASIER CODE TO READ
005400180322              If AYR > SIXYR;
005500180322                   X = 0;
005600180322
005700180322                   For X = 1 To 6;
005800180322                    if %Lookup(AYR : YR : X) > 0;
005900180322                    ENDIF;
006000180322                   ENDFOR;
006100180322              ENDIF;
006200180322         *inlr = *on;
006300180322       Dcl-Proc Initialize;
006400180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
006500180322       //          1:2):2:0);
006600180322       //  WDD = DATE / 100;
006700180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
006800180322       //          5:2):2:0);
006900180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
007000180322                 1:2):2:0);
007100180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
007200180322                 3:2):2:0);
007300180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
007400180322                 5:2):2:0);
007500180322
007600180322       If user = 'KELLYM';
007700180322         IPaddress = '10.1.24.125';
007800180322       EndIf;
007900180322
008000180322       rtn = XLS_Visible(SQL_Socket:1);
008100180322        In *LOCK fastenctr;
008200180322         //WKCTR = fastenctr + 1;
008300180322         //If wkctr = 0;
008400180322         //  wkctr = wkctr + 1;
008500180322         //  fastenctr = WKCTR;
008600180322         //Else;
008700180322         //  fastenctr = WKCTR;
008800180322         //EndIf;
008900180322        MONITOR;
009000180322            WKCTR = fastenctr + 1;
009100180322        ON-ERROR;
009200180322           WKCTR = 01;
009300180322        ENDMON;
009400180322           fastenctr = WKCTR;
009500180322        Out fastenctr;
009600180322
009700180322        rtn = XLS_Visible(SQL_Socket:1);
009800180322       If user = 'KELLYM';
009900180322         IPaddress = '10.1.24.125';
010000180322       EndIf;
010100180322
010200180322       //PRIMARY FILES
010300180322       SETLL *LOVAL ACTMP1;
010400180322       READ ACTMP1;
010500180322       DOU %EOF(ACTMP1);
010600180322
010700180322       READ ACTMP1;
010800180322       ENDDO;
010900180322       *INLR = '1';
011000180322
011100180322       End-Proc;
011200180322
011300180322      //*************************************************************************************
011400180322       Dcl-Proc L1PRIMARY;
011500180322       //PRIMARY FILES WITH L1 BREAKS
011600180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
011700180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
011800180322
011900180322       SETLL *LOVAL ACTMP1;
012000180322       READ ACTMP1;
012100180322       SAVXLCNCD = XLCNCD;
012200180322       DOU %EOF(ACTMP1);
012300180322        IF XLCNCD <> SAVXLCNCD;
012400180322         SAVXLCNCD2 = XLCNCD;
012500180322         XLCNCD = SAVXLCNCD;
012600180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
012700180322         EXSR L1;
012800180322         SAVXLCNCD = SAVXLCNCD2;
012900180322         XLCNCD = SAVXLCNCD2;
013000180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
013100180322       ENDIF;
013200180322
013300180322       READ ACTMP1;
013400180322       ENDDO;
013500180322       IF %EOF(ACTMP1);
013600180322         EXSR L1;
013700180322       ENDIF;
013800180322       *INLR = '1';
013900180322
014000180322       End-Proc;
014100180322
014200180322       Dcl-Proc DATESandTHINGS;
014300180322      //*************************************************************************************
014400180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
014500180322       Dcl-S JGREG           Packed(12:9);
014600180322       Dcl-S J$YYWK          Packed(3:0);
014700180322       Dcl-S J$TST           Packed(9:9);
014800=     
014900              //making more changes but in git hub
015000180322       // ===========================================
015100180322     D @charA          S              8    inz('04/12/01')
015200180322     D @charB          S             10    inz('12/02/2004')
015300180322     D @charC          S              8    inz('12/03/04')
015400180322
015500180322     D @dateA          S               d   inz(D'2004-12-04')
015600180322
015700180322     D @numA           S              6  0 inz(041205)
015800180322     D @numB           S              7  0 inz(1041206)
015900180322     D @numC           S              8  0 inz(20041207)
016000180322     D @numD           S              6  0 inz(120804)
016100180322     D @numE           S              8  0 inz(12092004)
016200180322
016300180322        Dcl-Ds *n;
016400180322         NUM83           Zoned(8:3);
016500180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
016600180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
016700180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
016800180322       End-Ds;
016900180322
017000180322       Dcl-Ds *n;
017100180322         NUM62           Zoned(6:2);
017200180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
017300180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
017400180322       End-Ds;
017500180322
017600180322      /free
017700180322       // *********************************************************************
017800180322           Initialize();
017900180322       //      If AYR > SIXYR;
018000180322       //            X = 0;
018100180322       //
018200180322 7     //            For X = 1 To 6;
018300180322       //              *IN58 = '0';
018400180322       //              X = %Lookup(AYR : YR : X);
018500180322       //              *IN58 = (X > 0);
018600180322       //              If X = 0;
018700180322       //                X = 1;
018800180322       //              EndIf;
018900180322       //              ENDFOR;
0190001803228      //              If *IN58 = '1';
019100180322       //              ENDIF;
019200180322       //     ENDIF;
019300180322
019400180322       //BECOMES THIS EASIER CODE TO READ
019500180322              If AYR > SIXYR;
019600180322                   X = 0;
019700180322
019800180322                   For X = 1 To 6;
019900180322                    if %Lookup(AYR : YR : X) > 0;
020000180322                    ENDIF;
020100180322                   ENDFOR;
020200180322              ENDIF;
020300180322         *inlr = *on;
020400180322       Dcl-Proc Initialize;
020500180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
020600180322       //          1:2):2:0);
020700180322       //  WDD = DATE / 100;
020800180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
020900180322       //          5:2):2:0);
021000180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
021100180322                 1:2):2:0);
021200180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
021300180322                 3:2):2:0);
021400180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
021500180322                 5:2):2:0);
021600180322
021700180322       If user = 'KELLYM';
021800180322         IPaddress = '10.1.24.125';
021900180322       EndIf;
022000180322
022100180322       rtn = XLS_Visible(SQL_Socket:1);
022200180322        In *LOCK fastenctr;
022300180322         //WKCTR = fastenctr + 1;
022400180322         //If wkctr = 0;
022500180322         //  wkctr = wkctr + 1;
022600180322         //  fastenctr = WKCTR;
022700180322         //Else;
022800180322         //  fastenctr = WKCTR;
022900180322         //EndIf;
023000180322        MONITOR;
023100180322            WKCTR = fastenctr + 1;
023200180322        ON-ERROR;
023300180322           WKCTR = 01;
023400180322        ENDMON;
023500180322           fastenctr = WKCTR;
023600180322        Out fastenctr;
023700180322
023800180322        rtn = XLS_Visible(SQL_Socket:1);
023900180322       If user = 'KELLYM';
024000180322         IPaddress = '10.1.24.125';
024100180322       EndIf;
024200180322
024300180322       //PRIMARY FILES
024400180322       SETLL *LOVAL ACTMP1;
024500180322       READ ACTMP1;
024600180322       DOU %EOF(ACTMP1);
024700180322
024800180322       READ ACTMP1;
024900180322       ENDDO;
025000180322       *INLR = '1';
025100180322
025200180322       End-Proc;
025300180322
025400180322      //*************************************************************************************
025500180322       Dcl-Proc L1PRIMARY;
025600180322       //PRIMARY FILES WITH L1 BREAKS
025700180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
025800180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
025900180322
026000180322       SETLL *LOVAL ACTMP1;
026100180322       READ ACTMP1;
026200180322       SAVXLCNCD = XLCNCD;
026300180322       DOU %EOF(ACTMP1);
026400180322        IF XLCNCD <> SAVXLCNCD;
026500180322         SAVXLCNCD2 = XLCNCD;
026600180322         XLCNCD = SAVXLCNCD;
026700180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
026800180322         EXSR L1;
026900180322         SAVXLCNCD = SAVXLCNCD2;
027000180322         XLCNCD = SAVXLCNCD2;
027100180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
027200180322       ENDIF;
027300180322
027400180322       READ ACTMP1;
027500180322       ENDDO;
027600180322       IF %EOF(ACTMP1);
027700180322         EXSR L1;
027800180322       ENDIF;
027900180322       *INLR = '1';
028000180322
028100180322       End-Proc;
028200180322
028300180322       Dcl-Proc DATESandTHINGS;
028400180322      //*************************************************************************************
028500180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
028600180322       Dcl-S JGREG           Packed(12:9);
028700180322       Dcl-S J$YYWK          Packed(3:0);
028800180322       Dcl-S J$TST           Packed(9:9);
028900180322
029000> branch 'master' of https://github.com/lynn9787/CentralParkData.git
029100180322
029200180322
029300180322     C*     J$JD          DIV       365.25        J$YYWK            3 0
029400180322     C*     J$JD          DIV       365.25        J$TST             9 9
029500180322       //  J$YYWK = J$JD / 365.25;
029600180322       //  J$TST = J$JD / 365.25;
029700180322         JGREG = J$JD / DaysInYear;
029800180322         J$YYWK = %DEC(%SUBST(%CHAR(JGREG):1:3):3:0);
029900180322         J$TST = %DEC(%SUBST(%CHAR(JGREG):4:9):9:9);
030000180322
030100180322      //*************************************************************************************
030200180322
030300180322     C                   movea     Qty#          arr1
030400180322         pAToArrStr = %Addr(arr1);
030500180322         %Subst(AToArrStr:1:10) = Qty#;
030600180322         For i = 1 to %len(Qty#);
030700180322           arr1(i) = %subst(Qty#:i:1);
030800180322         Endfor;
030900180322
031000180322      //*************************************************************************************
031100180322      // character to character...
031200180322         @charB = %char(%date(@charA:*ymd/):*usa/);                // 'yy/mm/dd'     to  'mm/dd/ccyy
031300180322         @charC = %char(%date(@charA:*ymd/):*mdy/);                // 'yy/mm/dd'     to  'mm/dd/yy'
031400180322         @charA = %char(%date(@charB:*usa/):*ymd/);                // 'mm/dd/ccyy'   to  'yy/mm/dd'
031500180322         @charC = %char(%date(@charB:*usa/):*mdy/);                // 'mm/dd/ccyy'   to  'mm/dd/yy'
031600180322         @charA = %char(%date(@charC:*mdy/):*ymd/);                // 'mm/dd/yy'     to  'yy/mm/dd'
031700180322         @charB = %char(%date(@charC:*mdy/):*usa/);                // 'mm/dd/yy'     to  'mm/dd/ccyy
031800180322
031900180322       // character to date...
032000180322         @dateA = %date(@charA:*ymd/);                             // 'yy/mm/dd'     to  D'ccyy-mm-d
032100180322         @dateA = %date(@charB:*usa/);                             // 'mm/dd/ccyy'   to  D'ccyy-mm-d
032200180322         @dateA = %date(@charC:*mdy/);                             // 'mm/dd/yy'     to  D'ccyy-mm-d
032300180322
032400180322       // character to numeric...
032500180322         @numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0);       // 'yy/mm/dd'     to  yymmdd
032600180322         @numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0);      // 'yy/mm/dd'     to  cyymmdd
032700180322         @numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0);       // 'yy/mm/dd'     to  ccyymmdd
032800180322         @numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0);       // 'yy/mm/dd'     to  mmddyy
032900180322         @numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0);       // 'yy/mm/dd'     to  mmddyyyy
033000180322         @numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0);       // 'mm/dd/ccyy'   to  yymmdd
033100180322         @numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0);      // 'mm/dd/ccyy'   to  cyymmdd
033200180322         @numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0);       // 'mm/dd/ccyy'   to  ccyymmdd
033300180322         @numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0);       // 'mm/dd/ccyy'   to  mmddyy
033400180322         @numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0);       // 'mm/dd/ccyy'   to  mmddyyyy
033500180322         @numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0);       // 'mm/dd/yy'     to  yymmdd
033600180322         @numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0);      // 'mm/dd/yy'     to  cyymmdd
033700180322         @numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0);       // 'mm/dd/yy'     to  ccyymmdd
033800180322         @numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0);       // 'mm/dd/yy'     to  mmddyy
033900180322         @numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0);       // 'mm/dd/yy'     to  mmddyyyy
034000180322
034100180322       // date to character...
034200180322         @charA = %char(@dateA:*ymd/);                             // D'ccyy-mm-dd'  to  'yy/mm/dd'
034300180322         @charB = %char(@dateA:*usa/);                             // D'ccyy-mm-dd'  to  'mm/dd/ccyy
034400180322         @charC = %char(@dateA:*mdy/);                             // D'ccyy-mm-dd'  to  'mm/dd/yy'
034500180322
034600180322       // date to numeric...
034700180322         @numA = %dec(%char(@dateA:*ymd/):6:0);                    // D'ccyy-mm-dd'  to  yymmdd
034800180322         @numB = %dec(%char(@dateA:*cymd/):7:0);                   // D'ccyy-mm-dd'  to  cyymmdd
034900180322         @numC = %dec(%char(@dateA:*iso-):8:0);                    // D'ccyy-mm-dd'  to  ccyymmdd
035000180322         @numD = %dec(%char(@dateA:*mdy/):6:0);                    // D'ccyy-mm-dd'  to  mmddyy
035100180322         @numE = %dec(%char(@dateA:*usa/):8:0);                    // D'ccyy-mm-dd'  to  mmddccyy
035200180322
035300180322       // numeric to character...
035400180322         @charA = %char(%date(@numA:*ymd):*ymd/);                  // yymmdd         to  'yy/mm/dd'
035500180322         @charB = %char(%date(@numA:*ymd):*usa/);                  // yymmdd         to  'mm/dd/ccyy
035600180322         @charC = %char(%date(@numA:*ymd):*mdy/);                  // yymmdd         to  'mm/dd/yy'
035700180322
035800180322         @charA = %char(%date(@numB:*cymd):*ymd/);                 // cyymmdd        to  'yy/mm/dd'
035900180322         @charB = %char(%date(@numB:*cymd):*usa/);                 // cyymmdd        to  'mm/dd/ccyy
036000180322         @charC = %char(%date(@numB:*cymd):*mdy/);                 // cyymmdd        to  'mm/dd/yy'
036100180322
036200180322         @charA = %char(%date(@numC:*iso):*ymd/);                  // D'ccyy-mm-dd'  to  'yy/mm/dd'
036300180322         @charB = %char(%date(@numC:*iso):*usa/);                  // D'ccyy-mm-dd'  to  'mm/dd/ccyy
036400180322         @charC = %char(%date(@numC:*iso):*mdy/);                  // D'ccyy-mm-dd'  to  'mm/dd/yy'
036500180322
036600180322         @charA = %char(%date(@numD:*mdy):*ymd/);                  // mmddyy         to  'yy/mm/dd'
036700180322         @charB = %char(%date(@numD:*mdy):*usa/);                  // mmddyy         to  'mm/dd/ccyy
036800180322         @charC = %char(%date(@numD:*mdy):*mdy/);                  // mmddyy         to  'mm/dd/yy'
036900180322
037000180322         @charA = %char(%date(@numE:*usa):*ymd/);                  // mmddccyy       to  'yy/mm/dd'
037100180322         @charB = %char(%date(@numE:*usa):*usa/);                  // mmddccyy       to  'mm/dd/ccyy
037200180322         @charC = %char(%date(@numE:*usa):*mdy/);                  // mmddccyy       to  'mm/dd/yy'
037300180322
037400180322       // numeric to date...
037500180322         @dateA = %date(@numA:*ymd);                               // yymmdd         to  D'ccyy-mm-d
037600180322         @dateA = %date(@numB:*cymd);                              // cyymmdd        to  D'ccyy-mm-d
037700180322         @dateA = %date(@numC:*iso);                               // ccyymmdd'      to  D'ccyy-mm-d
037800180322         @dateA = %date(@numD:*mdy);                               // mmddyy         to  D'ccyy-mm-d
037900180322         @dateA = %date(@numE:*usa);                               // mmddccyy       to  D'ccyy-mm-d
038000180322
038100180322       // numeric to numeric...
038200180322         @numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0);        // yymmdd         to  cyymmdd
038300180322         @numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0);         // yymmdd         to  ccyymmdd
038400180322         @numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0);         // yymmdd         to  mmddyy
038500180322         @numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0);         // yymmdd         to  mmddccyy
038600180322
038700180322         @numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0);        // cyymmdd        to  yymmdd
038800180322         @numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0);        // cyymmdd        to  ccyymmdd
038900180322         @numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0);        // cyymmdd        to  mmddyy
039000180322         @numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0);        // cyymmdd        to  mmddccyy
039100180322
039200180322         @numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0);         // ccyymmdd       to  yymmdd
039300180322         @numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0);        // ccyymmdd       to  cyymmdd
039400180322         @numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0);         // ccyymmdd       to  mmddyy
039500180322         @numE = %dec(%char(%date(@numC:*iso):*usa0):8:0);         // ccyymmdd       to  mmddccyy
039600180322
039700180322         @numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0);         // mmddyy         to  yymmdd
039800180322         @numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0);        // mmddyy         to  cyymmdd
039900180322         @numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0);         // mmddyy         to  ccyymmdd
040000180322         @numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0);         // mmddyy         to  mmddccyy
040100180322
040200180322         @numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0);         // mmddccyy       to  yymmdd
040300180322         @numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0);        // mmddccyy       to  cyymmdd
040400180322         @numC = %dec(%char(%date(@numE:*usa):*iso0):8:0);         // mmddccyy       to  ccyymmdd
040500180322         @numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0);         // mmddccyy       to  mmddyy
040600180322         end-proc;
