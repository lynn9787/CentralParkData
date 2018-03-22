000100180322       Ctl-Opt OPTION(*NODEBUGIO:*SRCSTMT);
000101180322       Ctl-Opt DftActGrp(*No);
000102180322       Dcl-S Date            Date            Inz(*SYS);
000103180322       // Changes made
                    //making more changes but in git hub
000104180322       // ===========================================
000105180322     D @charA          S              8    inz('04/12/01')
000106180322     D @charB          S             10    inz('12/02/2004')
000107180322     D @charC          S              8    inz('12/03/04')
000108180322
000109180322     D @dateA          S               d   inz(D'2004-12-04')
000110180322
000111180322     D @numA           S              6  0 inz(041205)
000112180322     D @numB           S              7  0 inz(1041206)
000113180322     D @numC           S              8  0 inz(20041207)
000114180322     D @numD           S              6  0 inz(120804)
000115180322     D @numE           S              8  0 inz(12092004)
000116180322
000117180322        Dcl-Ds *n;
000118180322         NUM83           Zoned(8:3);
000119180322         Aint5           Zoned(5:0)      OVERLAY(NUM83);
000120180322         Aint4           Zoned(4:0)      OVERLAY(NUM83:2);
000121180322         Adec2           Zoned(2:0)      OVERLAY(NUM83:6);
000122180322       End-Ds;
000123180322
000124180322       Dcl-Ds *n;
000125180322         NUM62           Zoned(6:2);
000126180322         Bint4           Zoned(4:0)      OVERLAY(NUM62);
000127180322         Bdec2           Zoned(2:0)      OVERLAY(NUM62:5);
000128180322       End-Ds;
000129180322
000130180322      /free
000131180322       // *********************************************************************
000132180322           Initialize();
000133180322       //      If AYR > SIXYR;
000134180322       //            X = 0;
000135180322       //
000136180322 7     //            For X = 1 To 6;
000137180322       //              *IN58 = '0';
000138180322       //              X = %Lookup(AYR : YR : X);
000139180322       //              *IN58 = (X > 0);
000140180322       //              If X = 0;
000141180322       //                X = 1;
000142180322       //              EndIf;
000143180322       //              ENDFOR;
0001441803228      //              If *IN58 = '1';
000145180322       //              ENDIF;
000146180322       //     ENDIF;
000147180322
000148180322       //BECOMES THIS EASIER CODE TO READ
000149180322              If AYR > SIXYR;
000150180322                   X = 0;
000151180322
000152180322                   For X = 1 To 6;
000153180322                    if %Lookup(AYR : YR : X) > 0;
000154180322                    ENDIF;
000155180322                   ENDFOR;
000156180322              ENDIF;
000157180322         *inlr = *on;
000158180322       Dcl-Proc Initialize;
000159180322       //  WMM = %Dec(%Subst(%EditC(DATE:'X'):
000160180322       //          1:2):2:0);
000161180322       //  WDD = DATE / 100;
000162180322       //  WYY = %Dec(%Subst(%EditC(DATE:'X'):
000163180322       //          5:2):2:0);
000164180322         WMM = %Dec(%Subst(%EditC(DATE:'X'):
000165180322                 1:2):2:0);
000166180322         WDD = %Dec(%Subst(%EditC(DATE:'X'):
000167180322                 3:2):2:0);
000168180322         WYY = %Dec(%Subst(%EditC(DATE:'X'):
000169180322                 5:2):2:0);
000170180322
000171180322       If user = 'KELLYM';
000172180322         IPaddress = '10.1.24.125';
000173180322       EndIf;
000174180322
000175180322       rtn = XLS_Visible(SQL_Socket:1);
000176180322        In *LOCK fastenctr;
000177180322         //WKCTR = fastenctr + 1;
000178180322         //If wkctr = 0;
000179180322         //  wkctr = wkctr + 1;
000180180322         //  fastenctr = WKCTR;
000181180322         //Else;
000182180322         //  fastenctr = WKCTR;
000183180322         //EndIf;
000184180322        MONITOR;
000185180322            WKCTR = fastenctr + 1;
000186180322        ON-ERROR;
000187180322           WKCTR = 01;
000188180322        ENDMON;
000189180322           fastenctr = WKCTR;
000190180322        Out fastenctr;
000191180322
000192180322        rtn = XLS_Visible(SQL_Socket:1);
000193180322       If user = 'KELLYM';
000194180322         IPaddress = '10.1.24.125';
000195180322       EndIf;
000196180322
000197180322       //PRIMARY FILES
000198180322       SETLL *LOVAL ACTMP1;
000199180322       READ ACTMP1;
000200180322       DOU %EOF(ACTMP1);
000201180322
000202180322       READ ACTMP1;
000203180322       ENDDO;
000204180322       *INLR = '1';
000205180322
000206180322       End-Proc;
000207180322
000208180322      //*************************************************************************************
000209180322       Dcl-Proc L1PRIMARY;
000210180322       //PRIMARY FILES WITH L1 BREAKS
000211180322       Dcl-S SAVSLSCNR       LIKE(SLSCNR);
000212180322       Dcl-S SAVSLSCNR2      LIKE(SLSCNR);
000213180322
000214180322       SETLL *LOVAL ACTMP1;
000215180322       READ ACTMP1;
000216180322       SAVXLCNCD = XLCNCD;
000217180322       DOU %EOF(ACTMP1);
000218180322        IF XLCNCD <> SAVXLCNCD;
000219180322         SAVXLCNCD2 = XLCNCD;
000220180322         XLCNCD = SAVXLCNCD;
000221180322         READP ACTMP1;             //READ THE PRIOR RECORD TO PROCESS THE LEVEL BREAK
000222180322         EXSR L1;
000223180322         SAVXLCNCD = SAVXLCNCD2;
000224180322         XLCNCD = SAVXLCNCD2;
000225180322         READ ACTMP1;             //READ THE NEXT RECORD TO GET BACK TO THE CORRECT RECORD AGAIN
000226180322       ENDIF;
000227180322
000228180322       READ ACTMP1;
000229180322       ENDDO;
000230180322       IF %EOF(ACTMP1);
000231180322         EXSR L1;
000232180322       ENDIF;
000233180322       *INLR = '1';
000234180322
000235180322       End-Proc;
000236180322
000237180322       Dcl-Proc DATESandTHINGS;
000238180322      //*************************************************************************************
000239180322       Dcl-S DaysInYear      Packed(5:2)   INZ(365.25);
000240180322       Dcl-S JGREG           Packed(12:9);
000241180322       Dcl-S J$YYWK          Packed(3:0);
000242180322       Dcl-S J$TST           Packed(9:9);
000243180322
000244180322
000245180322     C*     J$JD          DIV       365.25        J$YYWK            3 0
000246180322     C*     J$JD          DIV       365.25        J$TST             9 9
000247180322       //  J$YYWK = J$JD / 365.25;
000248180322       //  J$TST = J$JD / 365.25;
000249180322         JGREG = J$JD / DaysInYear;
000250180322         J$YYWK = %DEC(%SUBST(%CHAR(JGREG):1:3):3:0);
000251180322         J$TST = %DEC(%SUBST(%CHAR(JGREG):4:9):9:9);
000252180322
000253180322      //*************************************************************************************
000254180322
000255180322     C                   movea     Qty#          arr1
000256180322         pAToArrStr = %Addr(arr1);
000257180322         %Subst(AToArrStr:1:10) = Qty#;
000258180322         For i = 1 to %len(Qty#);
000259180322           arr1(i) = %subst(Qty#:i:1);
000260180322         Endfor;
000261180322
000262180322      //*************************************************************************************
000263180322      // character to character...
000264180322         @charB = %char(%date(@charA:*ymd/):*usa/);                // 'yy/mm/dd'     to  'mm/dd/ccyy
000265180322         @charC = %char(%date(@charA:*ymd/):*mdy/);                // 'yy/mm/dd'     to  'mm/dd/yy'
000266180322         @charA = %char(%date(@charB:*usa/):*ymd/);                // 'mm/dd/ccyy'   to  'yy/mm/dd'
000267180322         @charC = %char(%date(@charB:*usa/):*mdy/);                // 'mm/dd/ccyy'   to  'mm/dd/yy'
000268180322         @charA = %char(%date(@charC:*mdy/):*ymd/);                // 'mm/dd/yy'     to  'yy/mm/dd'
000269180322         @charB = %char(%date(@charC:*mdy/):*usa/);                // 'mm/dd/yy'     to  'mm/dd/ccyy
000270180322
000271180322       // character to date...
000272180322         @dateA = %date(@charA:*ymd/);                             // 'yy/mm/dd'     to  D'ccyy-mm-d
000273180322         @dateA = %date(@charB:*usa/);                             // 'mm/dd/ccyy'   to  D'ccyy-mm-d
000274180322         @dateA = %date(@charC:*mdy/);                             // 'mm/dd/yy'     to  D'ccyy-mm-d
000275180322
000276180322       // character to numeric...
000277180322         @numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0);       // 'yy/mm/dd'     to  yymmdd
000278180322         @numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0);      // 'yy/mm/dd'     to  cyymmdd
000279180322         @numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0);       // 'yy/mm/dd'     to  ccyymmdd
000280180322         @numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0);       // 'yy/mm/dd'     to  mmddyy
000281180322         @numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0);       // 'yy/mm/dd'     to  mmddyyyy
000282180322         @numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0);       // 'mm/dd/ccyy'   to  yymmdd
000283180322         @numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0);      // 'mm/dd/ccyy'   to  cyymmdd
000284180322         @numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0);       // 'mm/dd/ccyy'   to  ccyymmdd
000285180322         @numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0);       // 'mm/dd/ccyy'   to  mmddyy
000286180322         @numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0);       // 'mm/dd/ccyy'   to  mmddyyyy
000287180322         @numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0);       // 'mm/dd/yy'     to  yymmdd
000288180322         @numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0);      // 'mm/dd/yy'     to  cyymmdd
000289180322         @numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0);       // 'mm/dd/yy'     to  ccyymmdd
000290180322         @numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0);       // 'mm/dd/yy'     to  mmddyy
000291180322         @numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0);       // 'mm/dd/yy'     to  mmddyyyy
000292180322
000293180322       // date to character...
000294180322         @charA = %char(@dateA:*ymd/);                             // D'ccyy-mm-dd'  to  'yy/mm/dd'
000295180322         @charB = %char(@dateA:*usa/);                             // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000296180322         @charC = %char(@dateA:*mdy/);                             // D'ccyy-mm-dd'  to  'mm/dd/yy'
000297180322
000298180322       // date to numeric...
000299180322         @numA = %dec(%char(@dateA:*ymd/):6:0);                    // D'ccyy-mm-dd'  to  yymmdd
000300180322         @numB = %dec(%char(@dateA:*cymd/):7:0);                   // D'ccyy-mm-dd'  to  cyymmdd
000301180322         @numC = %dec(%char(@dateA:*iso-):8:0);                    // D'ccyy-mm-dd'  to  ccyymmdd
000302180322         @numD = %dec(%char(@dateA:*mdy/):6:0);                    // D'ccyy-mm-dd'  to  mmddyy
000303180322         @numE = %dec(%char(@dateA:*usa/):8:0);                    // D'ccyy-mm-dd'  to  mmddccyy
000304180322
000305180322       // numeric to character...
000306180322         @charA = %char(%date(@numA:*ymd):*ymd/);                  // yymmdd         to  'yy/mm/dd'
000307180322         @charB = %char(%date(@numA:*ymd):*usa/);                  // yymmdd         to  'mm/dd/ccyy
000308180322         @charC = %char(%date(@numA:*ymd):*mdy/);                  // yymmdd         to  'mm/dd/yy'
000309180322
000310180322         @charA = %char(%date(@numB:*cymd):*ymd/);                 // cyymmdd        to  'yy/mm/dd'
000311180322         @charB = %char(%date(@numB:*cymd):*usa/);                 // cyymmdd        to  'mm/dd/ccyy
000312180322         @charC = %char(%date(@numB:*cymd):*mdy/);                 // cyymmdd        to  'mm/dd/yy'
000313180322
000314180322         @charA = %char(%date(@numC:*iso):*ymd/);                  // D'ccyy-mm-dd'  to  'yy/mm/dd'
000315180322         @charB = %char(%date(@numC:*iso):*usa/);                  // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000316180322         @charC = %char(%date(@numC:*iso):*mdy/);                  // D'ccyy-mm-dd'  to  'mm/dd/yy'
000317180322
000318180322         @charA = %char(%date(@numD:*mdy):*ymd/);                  // mmddyy         to  'yy/mm/dd'
000319180322         @charB = %char(%date(@numD:*mdy):*usa/);                  // mmddyy         to  'mm/dd/ccyy
000320180322         @charC = %char(%date(@numD:*mdy):*mdy/);                  // mmddyy         to  'mm/dd/yy'
000321180322
000322180322         @charA = %char(%date(@numE:*usa):*ymd/);                  // mmddccyy       to  'yy/mm/dd'
000323180322         @charB = %char(%date(@numE:*usa):*usa/);                  // mmddccyy       to  'mm/dd/ccyy
000324180322         @charC = %char(%date(@numE:*usa):*mdy/);                  // mmddccyy       to  'mm/dd/yy'
000325180322
000326180322       // numeric to date...
000327180322         @dateA = %date(@numA:*ymd);                               // yymmdd         to  D'ccyy-mm-d
000328180322         @dateA = %date(@numB:*cymd);                              // cyymmdd        to  D'ccyy-mm-d
000329180322         @dateA = %date(@numC:*iso);                               // ccyymmdd'      to  D'ccyy-mm-d
000330180322         @dateA = %date(@numD:*mdy);                               // mmddyy         to  D'ccyy-mm-d
000331180322         @dateA = %date(@numE:*usa);                               // mmddccyy       to  D'ccyy-mm-d
000332180322
000333180322       // numeric to numeric...
000334180322         @numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0);        // yymmdd         to  cyymmdd
000335180322         @numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0);         // yymmdd         to  ccyymmdd
000336180322         @numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0);         // yymmdd         to  mmddyy
000337180322         @numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0);         // yymmdd         to  mmddccyy
000338180322
000339180322         @numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0);        // cyymmdd        to  yymmdd
000340180322         @numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0);        // cyymmdd        to  ccyymmdd
000341180322         @numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0);        // cyymmdd        to  mmddyy
000342180322         @numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0);        // cyymmdd        to  mmddccyy
000343180322
000344180322         @numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0);         // ccyymmdd       to  yymmdd
000345180322         @numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0);        // ccyymmdd       to  cyymmdd
000346180322         @numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0);         // ccyymmdd       to  mmddyy
000347180322         @numE = %dec(%char(%date(@numC:*iso):*usa0):8:0);         // ccyymmdd       to  mmddccyy
000348180322
000349180322         @numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0);         // mmddyy         to  yymmdd
000350180322         @numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0);        // mmddyy         to  cyymmdd
000351180322         @numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0);         // mmddyy         to  ccyymmdd
000352180322         @numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0);         // mmddyy         to  mmddccyy
000353180322
000354180322         @numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0);         // mmddccyy       to  yymmdd
000355180322         @numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0);        // mmddccyy       to  cyymmdd
000356180322         @numC = %dec(%char(%date(@numE:*usa):*iso0):8:0);         // mmddccyy       to  ccyymmdd
000357180322         @numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0);         // mmddccyy       to  mmddyy
000358180322         end-proc;
