000100180322       Ctl-Opt OPTION(*NODEBUGIO:*SRCSTMT);
000101180322       Ctl-Opt DftActGrp(*No);
000102180322       Dcl-S Date            Date            Inz(*SYS);
000103180322       // Changes made
000104180322       //new changes
000105180322       // ===========================================
000106180322     D @charA          S              8    inz('04/12/01')
000107180322     D @charB          S             10    inz('12/02/2004')
000108180322     D @charC          S              8    inz('12/03/04')
000109180322
000110180322     D @dateA          S               d   inz(D'2004-12-04')
000111180322
000112180322     D @numA           S              6  0 inz(041205)
000113180322     D @numB           S              7  0 inz(1041206)
000114180322     D @numC           S              8  0 inz(20041207)
000115180322     D @numD           S              6  0 inz(120804)
000116180322     D @numE           S              8  0 inz(12092004)
000117180322
000118180322        Dcl-Ds *n;
000119180322         NUM83           Zoned(8:3);
000120180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
000121180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
000122180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
000123180322       End-Ds;
000124180322
000125180322       Dcl-Ds *n;
000126180322         NUM62           Zoned(6:2);
000127180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
000128180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
000129180322       End-Ds;
000130180322
000131180322      /free
000132180322       // *********************************************************************
000133180322           Initialize();
000134180322       //      If AYR > SIXYR;
000135180322       //            X = 0;
000136180322       //
000137180322 7     //            For X = 1 To 6;
000138180322       //              *IN58 = '0';
000139180322       //              X = %Lookup(AYR : YR : X);
000140180322       //              *IN58 = (X > 0);
000141180322       //              If X = 0;
000142180322       //                X = 1;
000143180322       //              EndIf;
000144180322       //              ENDFOR;
0001451803228      //              If *IN58 = '1';
000146180322       //              ENDIF;
000147180322       //     ENDIF;
000148180322
000149180322       //BECOMES THIS EASIER CODE TO READ
000150180322              If AYR > SIXYR;
000151180322                   X = 0;
000152180322
000153180322                   For X = 1 To 6;
000154180322                    if %Lookup(AYR : YR : X) > 0;
000155180322                    ENDIF;
000156180322                   ENDFOR;
000157180322              ENDIF;
000158180322         *inlr = *on;
000159180322       Dcl-Proc Initialize;
000160180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
000161180322       //          1:2):2:0);
000162180322       //  WDD = DATE / 100;
000163180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
000164180322       //          5:2):2:0);
000165180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
000166180322                 1:2):2:0);
000167180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
000168180322                 3:2):2:0);
000169180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
000170180322                 5:2):2:0);
000171180322
000172180322       If user = 'KELLYM';
000173180322         IPaddress = '10.1.24.125';
000174180322       EndIf;
000175180322
000176180322       rtn = XLS_Visible(SQL_Socket:1);
000177180322        In *LOCK fastenctr;
000178180322         //WKCTR = fastenctr + 1;
000179180322         //If wkctr = 0;
000180180322         //  wkctr = wkctr + 1;
000181180322         //  fastenctr = WKCTR;
000182180322         //Else;
000183180322         //  fastenctr = WKCTR;
000184180322         //EndIf;
000185180322        MONITOR;
000186180322            WKCTR = fastenctr + 1;
000187180322        ON-ERROR;
000188180322           WKCTR = 01;
000189180322        ENDMON;
000190180322           fastenctr = WKCTR;
000191180322        Out fastenctr;
000192180322
000193180322        rtn = XLS_Visible(SQL_Socket:1);
000194180322       If user = 'KELLYM';
000195180322         IPaddress = '10.1.24.125';
000196180322       EndIf;
000197180322
000198180322       //PRIMARY FILES
000199180322       SETLL *LOVAL ACTMP1;
000200180322       READ ACTMP1;
000201180322       DOU %EOF(ACTMP1);
000202180322
000203180322       READ ACTMP1;
000204180322       ENDDO;
000205180322       *INLR = '1';
000206180322
000207180322       End-Proc;
000208180322
000209180322      //*************************************************************************************
000210180322       Dcl-Proc L1PRIMARY;
000211180322       //PRIMARY FILES WITH L1 BREAKS
000212180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
000213180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
000214180322
000215180322       SETLL *LOVAL ACTMP1;
000216180322       READ ACTMP1;
000217180322       SAVXLCNCD = XLCNCD;
000218180322       DOU %EOF(ACTMP1);
000219180322        IF XLCNCD <> SAVXLCNCD;
000220180322         SAVXLCNCD2 = XLCNCD;
000221180322         XLCNCD = SAVXLCNCD;
000222180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
000223180322         EXSR L1;
000224180322         SAVXLCNCD = SAVXLCNCD2;
000225180322         XLCNCD = SAVXLCNCD2;
000226180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
000227180322       ENDIF;
000228180322
000229180322       READ ACTMP1;
000230180322       ENDDO;
000231180322       IF %EOF(ACTMP1);
000232180322         EXSR L1;
000233180322       ENDIF;
000234180322       *INLR = '1';
000235180322
000236180322       End-Proc;
000237180322
000238180322       Dcl-Proc DATESandTHINGS;
000239180322      //*************************************************************************************
000240180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
000241180322       Dcl-S JGREG           Packed(12:9);
000242180322       Dcl-S J$YYWK          Packed(3:0);
000243180322       Dcl-S J$TST           Packed(9:9);
000244180322
000245180322
000246180322     C*     J$JD          DIV       365.25        J$YYWK            3 0
000247180322     C*     J$JD          DIV       365.25        J$TST             9 9
000248180322       //  J$YYWK = J$JD / 365.25;
000249180322       //  J$TST = J$JD / 365.25;
000250180322         JGREG = J$JD / DaysInYear;
000251180322         J$YYWK = %DEC(%SUBST(%CHAR(JGREG):1:3):3:0);
000252180322         J$TST = %DEC(%SUBST(%CHAR(JGREG):4:9):9:9);
000253180322
000254180322      //*************************************************************************************
000255180322
000256180322     C                   movea     Qty#          arr1
000257180322         pAToArrStr = %Addr(arr1);
000258180322         %Subst(AToArrStr:1:10) = Qty#;
000259180322         For i = 1 to %len(Qty#);
000260180322           arr1(i) = %subst(Qty#:i:1);
000261180322         Endfor;
000262180322
000263180322      //*************************************************************************************
000264180322      // character to character...
000265180322         @charB = %char(%date(@charA:*ymd/):*usa/);                // 'yy/mm/dd'     to  'mm/dd/ccyy
000266180322         @charC = %char(%date(@charA:*ymd/):*mdy/);                // 'yy/mm/dd'     to  'mm/dd/yy'
000267180322         @charA = %char(%date(@charB:*usa/):*ymd/);                // 'mm/dd/ccyy'   to  'yy/mm/dd'
000268180322         @charC = %char(%date(@charB:*usa/):*mdy/);                // 'mm/dd/ccyy'   to  'mm/dd/yy'
000269180322         @charA = %char(%date(@charC:*mdy/):*ymd/);                // 'mm/dd/yy'     to  'yy/mm/dd'
000270180322         @charB = %char(%date(@charC:*mdy/):*usa/);                // 'mm/dd/yy'     to  'mm/dd/ccyy
000271180322
000272180322       // character to date...
000273180322         @dateA = %date(@charA:*ymd/);                             // 'yy/mm/dd'     to  D'ccyy-mm-d
000274180322         @dateA = %date(@charB:*usa/);                             // 'mm/dd/ccyy'   to  D'ccyy-mm-d
000275180322         @dateA = %date(@charC:*mdy/);                             // 'mm/dd/yy'     to  D'ccyy-mm-d
000276180322
000277180322       // character to numeric...
000278180322         @numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0);       // 'yy/mm/dd'     to  yymmdd
000279180322         @numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0);      // 'yy/mm/dd'     to  cyymmdd
000280180322         @numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0);       // 'yy/mm/dd'     to  ccyymmdd
000281180322         @numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0);       // 'yy/mm/dd'     to  mmddyy
000282180322         @numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0);       // 'yy/mm/dd'     to  mmddyyyy
000283180322         @numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0);       // 'mm/dd/ccyy'   to  yymmdd
000284180322         @numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0);      // 'mm/dd/ccyy'   to  cyymmdd
000285180322         @numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0);       // 'mm/dd/ccyy'   to  ccyymmdd
000286180322         @numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0);       // 'mm/dd/ccyy'   to  mmddyy
000287180322         @numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0);       // 'mm/dd/ccyy'   to  mmddyyyy
000288180322         @numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0);       // 'mm/dd/yy'     to  yymmdd
000289180322         @numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0);      // 'mm/dd/yy'     to  cyymmdd
000290180322         @numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0);       // 'mm/dd/yy'     to  ccyymmdd
000291180322         @numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0);       // 'mm/dd/yy'     to  mmddyy
000292180322         @numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0);       // 'mm/dd/yy'     to  mmddyyyy
000293180322
000294180322       // date to character...
000295180322         @charA = %char(@dateA:*ymd/);                             // D'ccyy-mm-dd'  to  'yy/mm/dd'
000296180322         @charB = %char(@dateA:*usa/);                             // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000297180322         @charC = %char(@dateA:*mdy/);                             // D'ccyy-mm-dd'  to  'mm/dd/yy'
000298180322
000299180322       // date to numeric...
000300180322         @numA = %dec(%char(@dateA:*ymd/):6:0);                    // D'ccyy-mm-dd'  to  yymmdd
000301180322         @numB = %dec(%char(@dateA:*cymd/):7:0);                   // D'ccyy-mm-dd'  to  cyymmdd
000302180322         @numC = %dec(%char(@dateA:*iso-):8:0);                    // D'ccyy-mm-dd'  to  ccyymmdd
000303180322         @numD = %dec(%char(@dateA:*mdy/):6:0);                    // D'ccyy-mm-dd'  to  mmddyy
000304180322         @numE = %dec(%char(@dateA:*usa/):8:0);                    // D'ccyy-mm-dd'  to  mmddccyy
000305180322
000306180322       // numeric to character...
000307180322         @charA = %char(%date(@numA:*ymd):*ymd/);                  // yymmdd         to  'yy/mm/dd'
000308180322         @charB = %char(%date(@numA:*ymd):*usa/);                  // yymmdd         to  'mm/dd/ccyy
000309180322         @charC = %char(%date(@numA:*ymd):*mdy/);                  // yymmdd         to  'mm/dd/yy'
000310180322
000311180322         @charA = %char(%date(@numB:*cymd):*ymd/);                 // cyymmdd        to  'yy/mm/dd'
000312180322         @charB = %char(%date(@numB:*cymd):*usa/);                 // cyymmdd        to  'mm/dd/ccyy
000313180322         @charC = %char(%date(@numB:*cymd):*mdy/);                 // cyymmdd        to  'mm/dd/yy'
000314180322
000315180322         @charA = %char(%date(@numC:*iso):*ymd/);                  // D'ccyy-mm-dd'  to  'yy/mm/dd'
000316180322         @charB = %char(%date(@numC:*iso):*usa/);                  // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000317180322         @charC = %char(%date(@numC:*iso):*mdy/);                  // D'ccyy-mm-dd'  to  'mm/dd/yy'
000318180322
000319180322         @charA = %char(%date(@numD:*mdy):*ymd/);                  // mmddyy         to  'yy/mm/dd'
000320180322         @charB = %char(%date(@numD:*mdy):*usa/);                  // mmddyy         to  'mm/dd/ccyy
000321180322         @charC = %char(%date(@numD:*mdy):*mdy/);                  // mmddyy         to  'mm/dd/yy'
000322180322
000323180322         @charA = %char(%date(@numE:*usa):*ymd/);                  // mmddccyy       to  'yy/mm/dd'
000324180322         @charB = %char(%date(@numE:*usa):*usa/);                  // mmddccyy       to  'mm/dd/ccyy
000325180322         @charC = %char(%date(@numE:*usa):*mdy/);                  // mmddccyy       to  'mm/dd/yy'
000326180322
000327180322       // numeric to date...
000328180322         @dateA = %date(@numA:*ymd);                               // yymmdd         to  D'ccyy-mm-d
000329180322         @dateA = %date(@numB:*cymd);                              // cyymmdd        to  D'ccyy-mm-d
000330180322         @dateA = %date(@numC:*iso);                               // ccyymmdd'      to  D'ccyy-mm-d
000331180322         @dateA = %date(@numD:*mdy);                               // mmddyy         to  D'ccyy-mm-d
000332180322         @dateA = %date(@numE:*usa);                               // mmddccyy       to  D'ccyy-mm-d
000333180322
000334180322       // numeric to numeric...
000335180322         @numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0);        // yymmdd         to  cyymmdd
000336180322         @numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0);         // yymmdd         to  ccyymmdd
000337180322         @numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0);         // yymmdd         to  mmddyy
000338180322         @numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0);         // yymmdd         to  mmddccyy
000339180322
000340180322         @numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0);        // cyymmdd        to  yymmdd
000341180322         @numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0);        // cyymmdd        to  ccyymmdd
000342180322         @numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0);        // cyymmdd        to  mmddyy
000343180322         @numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0);        // cyymmdd        to  mmddccyy
000344180322
000345180322         @numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0);         // ccyymmdd       to  yymmdd
000346180322         @numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0);        // ccyymmdd       to  cyymmdd
000347180322         @numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0);         // ccyymmdd       to  mmddyy
000348180322         @numE = %dec(%char(%date(@numC:*iso):*usa0):8:0);         // ccyymmdd       to  mmddccyy
000349180322
000350180322         @numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0);         // mmddyy         to  yymmdd
000351180322         @numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0);        // mmddyy         to  cyymmdd
000352180322         @numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0);         // mmddyy         to  ccyymmdd
000353180322         @numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0);         // mmddyy         to  mmddccyy
000354180322
000355180322         @numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0);         // mmddccyy       to  yymmdd
000356180322         @numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0);        // mmddccyy       to  cyymmdd
000357180322         @numC = %dec(%char(%date(@numE:*usa):*iso0):8:0);         // mmddccyy       to  ccyymmdd
000358180322         @numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0);         // mmddccyy       to  mmddyy
000359180322         end-proc;
