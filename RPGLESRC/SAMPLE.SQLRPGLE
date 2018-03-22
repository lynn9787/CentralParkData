000100180322       Ctl-Opt OPTION(*NODEBUGIO:*SRCSTMT);
000200180322       Ctl-Opt DftActGrp(*No);
000300180322       Dcl-S Date            Date            Inz(*SYS);
000400180322       // Changes made
000500< HEAD
                   // need this line to show in RDI
000600180322       //new changes
000601180322       //new line
000700180322       // ===========================================
000800180322     D @charA          S              8    inz('04/12/01')
000900180322     D @charB          S             10    inz('12/02/2004')
001000180322     D @charC          S              8    inz('12/03/04')
001100180322
001200180322     D @dateA          S               d   inz(D'2004-12-04')
001300180322
001400180322     D @numA           S              6  0 inz(041205)
001500180322     D @numB           S              7  0 inz(1041206)
001600180322     D @numC           S              8  0 inz(20041207)
001700180322     D @numD           S              6  0 inz(120804)
001800180322     D @numE           S              8  0 inz(12092004)
001900180322
002000180322        Dcl-Ds *n;
002100180322         NUM83           Zoned(8:3);
002200180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
002300180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
002400180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
002500180322       End-Ds;
002600180322
002700180322       Dcl-Ds *n;
002800180322         NUM62           Zoned(6:2);
002900180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
003000180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
003100180322       End-Ds;
003200180322
003300180322      /free
003400180322       // *********************************************************************
003500180322           Initialize();
003600180322       //      If AYR > SIXYR;
003700180322       //            X = 0;
003800180322       //
003900180322 7     //            For X = 1 To 6;
004000180322       //              *IN58 = '0';
004100180322       //              X = %Lookup(AYR : YR : X);
004200180322       //              *IN58 = (X > 0);
004300180322       //              If X = 0;
004400180322       //                X = 1;
004500180322       //              EndIf;
004600180322       //              ENDFOR;
0047001803228      //              If *IN58 = '1';
004800180322       //              ENDIF;
004900180322       //     ENDIF;
005000180322
005100180322       //BECOMES THIS EASIER CODE TO READ
005200180322              If AYR > SIXYR;
005300180322                   X = 0;
005400180322
005500180322                   For X = 1 To 6;
005600180322                    if %Lookup(AYR : YR : X) > 0;
005700180322                    ENDIF;
005800180322                   ENDFOR;
005900180322              ENDIF;
006000180322         *inlr = *on;
006100180322       Dcl-Proc Initialize;
006200180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
006300180322       //          1:2):2:0);
006400180322       //  WDD = DATE / 100;
006500180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
006600180322       //          5:2):2:0);
006700180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
006800180322                 1:2):2:0);
006900180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
007000180322                 3:2):2:0);
007100180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
007200180322                 5:2):2:0);
007300180322
007400180322       If user = 'KELLYM';
007500180322         IPaddress = '10.1.24.125';
007600180322       EndIf;
007700180322
007800180322       rtn = XLS_Visible(SQL_Socket:1);
007900180322        In *LOCK fastenctr;
008000180322         //WKCTR = fastenctr + 1;
008100180322         //If wkctr = 0;
008200180322         //  wkctr = wkctr + 1;
008300180322         //  fastenctr = WKCTR;
008400180322         //Else;
008500180322         //  fastenctr = WKCTR;
008600180322         //EndIf;
008700180322        MONITOR;
008800180322            WKCTR = fastenctr + 1;
008900180322        ON-ERROR;
009000180322           WKCTR = 01;
009100180322        ENDMON;
009200180322           fastenctr = WKCTR;
009300180322        Out fastenctr;
009400180322
009500180322        rtn = XLS_Visible(SQL_Socket:1);
009600180322       If user = 'KELLYM';
009700180322         IPaddress = '10.1.24.125';
009800180322       EndIf;
009900180322
010000180322       //PRIMARY FILES
010100180322       SETLL *LOVAL ACTMP1;
010200180322       READ ACTMP1;
010300180322       DOU %EOF(ACTMP1);
010400180322
010500180322       READ ACTMP1;
010600180322       ENDDO;
010700180322       *INLR = '1';
010800180322
010900180322       End-Proc;
011000180322
011100180322      //*************************************************************************************
011200180322       Dcl-Proc L1PRIMARY;
011300180322       //PRIMARY FILES WITH L1 BREAKS
011400180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
011500180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
011600180322
011700180322       SETLL *LOVAL ACTMP1;
011800180322       READ ACTMP1;
011900180322       SAVXLCNCD = XLCNCD;
012000180322       DOU %EOF(ACTMP1);
012100180322        IF XLCNCD <> SAVXLCNCD;
012200180322         SAVXLCNCD2 = XLCNCD;
012300180322         XLCNCD = SAVXLCNCD;
012400180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
012500180322         EXSR L1;
012600180322         SAVXLCNCD = SAVXLCNCD2;
012700180322         XLCNCD = SAVXLCNCD2;
012800180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
012900180322       ENDIF;
013000180322
013100180322       READ ACTMP1;
013200180322       ENDDO;
013300180322       IF %EOF(ACTMP1);
013400180322         EXSR L1;
013500180322       ENDIF;
013600180322       *INLR = '1';
013700180322
013800180322       End-Proc;
013900180322
014000180322       Dcl-Proc DATESandTHINGS;
014100180322      //*************************************************************************************
014200180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
014300180322       Dcl-S JGREG           Packed(12:9);
014400180322       Dcl-S J$YYWK          Packed(3:0);
014500180322       Dcl-S J$TST           Packed(9:9);
014600=     
014700              //making more changes but in git hub
014800180322       // ===========================================
014900180322     D @charA          S              8    inz('04/12/01')
015000180322     D @charB          S             10    inz('12/02/2004')
015100180322     D @charC          S              8    inz('12/03/04')
015200180322
015300180322     D @dateA          S               d   inz(D'2004-12-04')
015400180322
015500180322     D @numA           S              6  0 inz(041205)
015600180322     D @numB           S              7  0 inz(1041206)
015700180322     D @numC           S              8  0 inz(20041207)
015800180322     D @numD           S              6  0 inz(120804)
015900180322     D @numE           S              8  0 inz(12092004)
016000180322
016100180322        Dcl-Ds *n;
016200180322         NUM83           Zoned(8:3);
016300180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
016400180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
016500180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
016600180322       End-Ds;
016700180322
016800180322       Dcl-Ds *n;
016900180322         NUM62           Zoned(6:2);
017000180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
017100180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
017200180322       End-Ds;
017300180322
017400180322      /free
017500180322       // *********************************************************************
017600180322           Initialize();
017700180322       //      If AYR > SIXYR;
017800180322       //            X = 0;
017900180322       //
018000180322 7     //            For X = 1 To 6;
018100180322       //              *IN58 = '0';
018200180322       //              X = %Lookup(AYR : YR : X);
018300180322       //              *IN58 = (X > 0);
018400180322       //              If X = 0;
018500180322       //                X = 1;
018600180322       //              EndIf;
018700180322       //              ENDFOR;
0188001803228      //              If *IN58 = '1';
018900180322       //              ENDIF;
019000180322       //     ENDIF;
019100180322
019200180322       //BECOMES THIS EASIER CODE TO READ
019300180322              If AYR > SIXYR;
019400180322                   X = 0;
019500180322
019600180322                   For X = 1 To 6;
019700180322                    if %Lookup(AYR : YR : X) > 0;
019800180322                    ENDIF;
019900180322                   ENDFOR;
020000180322              ENDIF;
020100180322         *inlr = *on;
020200180322       Dcl-Proc Initialize;
020300180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
020400180322       //          1:2):2:0);
020500180322       //  WDD = DATE / 100;
020600180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
020700180322       //          5:2):2:0);
020800180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
020900180322                 1:2):2:0);
021000180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
021100180322                 3:2):2:0);
021200180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
021300180322                 5:2):2:0);
021400180322
021500180322       If user = 'KELLYM';
021600180322         IPaddress = '10.1.24.125';
021700180322       EndIf;
021800180322
021900180322       rtn = XLS_Visible(SQL_Socket:1);
022000180322        In *LOCK fastenctr;
022100180322         //WKCTR = fastenctr + 1;
022200180322         //If wkctr = 0;
022300180322         //  wkctr = wkctr + 1;
022400180322         //  fastenctr = WKCTR;
022500180322         //Else;
022600180322         //  fastenctr = WKCTR;
022700180322         //EndIf;
022800180322        MONITOR;
022900180322            WKCTR = fastenctr + 1;
023000180322        ON-ERROR;
023100180322           WKCTR = 01;
023200180322        ENDMON;
023300180322           fastenctr = WKCTR;
023400180322        Out fastenctr;
023500180322
023600180322        rtn = XLS_Visible(SQL_Socket:1);
023700180322       If user = 'KELLYM';
023800180322         IPaddress = '10.1.24.125';
023900180322       EndIf;
024000180322
024100180322       //PRIMARY FILES
024200180322       SETLL *LOVAL ACTMP1;
024300180322       READ ACTMP1;
024400180322       DOU %EOF(ACTMP1);
024500180322
024600180322       READ ACTMP1;
024700180322       ENDDO;
024800180322       *INLR = '1';
024900180322
025000180322       End-Proc;
025100180322
025200180322      //*************************************************************************************
025300180322       Dcl-Proc L1PRIMARY;
025400180322       //PRIMARY FILES WITH L1 BREAKS
025500180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
025600180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
025700180322
025800180322       SETLL *LOVAL ACTMP1;
025900180322       READ ACTMP1;
026000180322       SAVXLCNCD = XLCNCD;
026100180322       DOU %EOF(ACTMP1);
026200180322        IF XLCNCD <> SAVXLCNCD;
026300180322         SAVXLCNCD2 = XLCNCD;
026400180322         XLCNCD = SAVXLCNCD;
026500180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
026600180322         EXSR L1;
026700180322         SAVXLCNCD = SAVXLCNCD2;
026800180322         XLCNCD = SAVXLCNCD2;
026900180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
027000180322       ENDIF;
027100180322
027200180322       READ ACTMP1;
027300180322       ENDDO;
027400180322       IF %EOF(ACTMP1);
027500180322         EXSR L1;
027600180322       ENDIF;
027700180322       *INLR = '1';
027800180322
027900180322       End-Proc;
028000180322
028100180322       Dcl-Proc DATESandTHINGS;
028200180322      //*************************************************************************************
028300180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
028400180322       Dcl-S JGREG           Packed(12:9);
028500180322       Dcl-S J$YYWK          Packed(3:0);
028600180322       Dcl-S J$TST           Packed(9:9);
028700180322
028800> branch 'master' of https://github.com/lynn9787/CentralParkData.git
028900180322
029000180322
029100180322     C*     J$JD          DIV       365.25        J$YYWK            3 0
029200180322     C*     J$JD          DIV       365.25        J$TST             9 9
029300180322       //  J$YYWK = J$JD / 365.25;
029400180322       //  J$TST = J$JD / 365.25;
029500180322         JGREG = J$JD / DaysInYear;
029600180322         J$YYWK = %DEC(%SUBST(%CHAR(JGREG):1:3):3:0);
029700180322         J$TST = %DEC(%SUBST(%CHAR(JGREG):4:9):9:9);
029800180322
029900180322      //*************************************************************************************
030000180322
030100180322     C                   movea     Qty#          arr1
030200180322         pAToArrStr = %Addr(arr1);
030300180322         %Subst(AToArrStr:1:10) = Qty#;
030400180322         For i = 1 to %len(Qty#);
030500180322           arr1(i) = %subst(Qty#:i:1);
030600180322         Endfor;
030700180322
030800180322      //*************************************************************************************
030900180322      // character to character...
031000180322         @charB = %char(%date(@charA:*ymd/):*usa/);                // 'yy/mm/dd'     to  'mm/dd/ccyy
031100180322         @charC = %char(%date(@charA:*ymd/):*mdy/);                // 'yy/mm/dd'     to  'mm/dd/yy'
031200180322         @charA = %char(%date(@charB:*usa/):*ymd/);                // 'mm/dd/ccyy'   to  'yy/mm/dd'
031300180322         @charC = %char(%date(@charB:*usa/):*mdy/);                // 'mm/dd/ccyy'   to  'mm/dd/yy'
031400180322         @charA = %char(%date(@charC:*mdy/):*ymd/);                // 'mm/dd/yy'     to  'yy/mm/dd'
031500180322         @charB = %char(%date(@charC:*mdy/):*usa/);                // 'mm/dd/yy'     to  'mm/dd/ccyy
031600180322
031700180322       // character to date...
031800180322         @dateA = %date(@charA:*ymd/);                             // 'yy/mm/dd'     to  D'ccyy-mm-d
031900180322         @dateA = %date(@charB:*usa/);                             // 'mm/dd/ccyy'   to  D'ccyy-mm-d
032000180322         @dateA = %date(@charC:*mdy/);                             // 'mm/dd/yy'     to  D'ccyy-mm-d
032100180322
032200180322       // character to numeric...
032300180322         @numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0);       // 'yy/mm/dd'     to  yymmdd
032400180322         @numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0);      // 'yy/mm/dd'     to  cyymmdd
032500180322         @numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0);       // 'yy/mm/dd'     to  ccyymmdd
032600180322         @numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0);       // 'yy/mm/dd'     to  mmddyy
032700180322         @numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0);       // 'yy/mm/dd'     to  mmddyyyy
032800180322         @numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0);       // 'mm/dd/ccyy'   to  yymmdd
032900180322         @numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0);      // 'mm/dd/ccyy'   to  cyymmdd
033000180322         @numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0);       // 'mm/dd/ccyy'   to  ccyymmdd
033100180322         @numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0);       // 'mm/dd/ccyy'   to  mmddyy
033200180322         @numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0);       // 'mm/dd/ccyy'   to  mmddyyyy
033300180322         @numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0);       // 'mm/dd/yy'     to  yymmdd
033400180322         @numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0);      // 'mm/dd/yy'     to  cyymmdd
033500180322         @numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0);       // 'mm/dd/yy'     to  ccyymmdd
033600180322         @numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0);       // 'mm/dd/yy'     to  mmddyy
033700180322         @numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0);       // 'mm/dd/yy'     to  mmddyyyy
033800180322
033900180322       // date to character...
034000180322         @charA = %char(@dateA:*ymd/);                             // D'ccyy-mm-dd'  to  'yy/mm/dd'
034100180322         @charB = %char(@dateA:*usa/);                             // D'ccyy-mm-dd'  to  'mm/dd/ccyy
034200180322         @charC = %char(@dateA:*mdy/);                             // D'ccyy-mm-dd'  to  'mm/dd/yy'
034300180322
034400180322       // date to numeric...
034500180322         @numA = %dec(%char(@dateA:*ymd/):6:0);                    // D'ccyy-mm-dd'  to  yymmdd
034600180322         @numB = %dec(%char(@dateA:*cymd/):7:0);                   // D'ccyy-mm-dd'  to  cyymmdd
034700180322         @numC = %dec(%char(@dateA:*iso-):8:0);                    // D'ccyy-mm-dd'  to  ccyymmdd
034800180322         @numD = %dec(%char(@dateA:*mdy/):6:0);                    // D'ccyy-mm-dd'  to  mmddyy
034900180322         @numE = %dec(%char(@dateA:*usa/):8:0);                    // D'ccyy-mm-dd'  to  mmddccyy
035000180322
035100180322       // numeric to character...
035200180322         @charA = %char(%date(@numA:*ymd):*ymd/);                  // yymmdd         to  'yy/mm/dd'
035300180322         @charB = %char(%date(@numA:*ymd):*usa/);                  // yymmdd         to  'mm/dd/ccyy
035400180322         @charC = %char(%date(@numA:*ymd):*mdy/);                  // yymmdd         to  'mm/dd/yy'
035500180322
035600180322         @charA = %char(%date(@numB:*cymd):*ymd/);                 // cyymmdd        to  'yy/mm/dd'
035700180322         @charB = %char(%date(@numB:*cymd):*usa/);                 // cyymmdd        to  'mm/dd/ccyy
035800180322         @charC = %char(%date(@numB:*cymd):*mdy/);                 // cyymmdd        to  'mm/dd/yy'
035900180322
036000180322         @charA = %char(%date(@numC:*iso):*ymd/);                  // D'ccyy-mm-dd'  to  'yy/mm/dd'
036100180322         @charB = %char(%date(@numC:*iso):*usa/);                  // D'ccyy-mm-dd'  to  'mm/dd/ccyy
036200180322         @charC = %char(%date(@numC:*iso):*mdy/);                  // D'ccyy-mm-dd'  to  'mm/dd/yy'
036300180322
036400180322         @charA = %char(%date(@numD:*mdy):*ymd/);                  // mmddyy         to  'yy/mm/dd'
036500180322         @charB = %char(%date(@numD:*mdy):*usa/);                  // mmddyy         to  'mm/dd/ccyy
036600180322         @charC = %char(%date(@numD:*mdy):*mdy/);                  // mmddyy         to  'mm/dd/yy'
036700180322
036800180322         @charA = %char(%date(@numE:*usa):*ymd/);                  // mmddccyy       to  'yy/mm/dd'
036900180322         @charB = %char(%date(@numE:*usa):*usa/);                  // mmddccyy       to  'mm/dd/ccyy
037000180322         @charC = %char(%date(@numE:*usa):*mdy/);                  // mmddccyy       to  'mm/dd/yy'
037100180322
037200180322       // numeric to date...
037300180322         @dateA = %date(@numA:*ymd);                               // yymmdd         to  D'ccyy-mm-d
037400180322         @dateA = %date(@numB:*cymd);                              // cyymmdd        to  D'ccyy-mm-d
037500180322         @dateA = %date(@numC:*iso);                               // ccyymmdd'      to  D'ccyy-mm-d
037600180322         @dateA = %date(@numD:*mdy);                               // mmddyy         to  D'ccyy-mm-d
037700180322         @dateA = %date(@numE:*usa);                               // mmddccyy       to  D'ccyy-mm-d
037800180322
037900180322       // numeric to numeric...
038000180322         @numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0);        // yymmdd         to  cyymmdd
038100180322         @numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0);         // yymmdd         to  ccyymmdd
038200180322         @numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0);         // yymmdd         to  mmddyy
038300180322         @numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0);         // yymmdd         to  mmddccyy
038400180322
038500180322         @numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0);        // cyymmdd        to  yymmdd
038600180322         @numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0);        // cyymmdd        to  ccyymmdd
038700180322         @numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0);        // cyymmdd        to  mmddyy
038800180322         @numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0);        // cyymmdd        to  mmddccyy
038900180322
039000180322         @numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0);         // ccyymmdd       to  yymmdd
039100180322         @numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0);        // ccyymmdd       to  cyymmdd
039200180322         @numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0);         // ccyymmdd       to  mmddyy
039300180322         @numE = %dec(%char(%date(@numC:*iso):*usa0):8:0);         // ccyymmdd       to  mmddccyy
039400180322
039500180322         @numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0);         // mmddyy         to  yymmdd
039600180322         @numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0);        // mmddyy         to  cyymmdd
039700180322         @numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0);         // mmddyy         to  ccyymmdd
039800180322         @numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0);         // mmddyy         to  mmddccyy
039900180322
040000180322         @numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0);         // mmddccyy       to  yymmdd
040100180322         @numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0);        // mmddccyy       to  cyymmdd
040200180322         @numC = %dec(%char(%date(@numE:*usa):*iso0):8:0);         // mmddccyy       to  ccyymmdd
040300180322         @numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0);         // mmddccyy       to  mmddyy
040400180322         end-proc;
