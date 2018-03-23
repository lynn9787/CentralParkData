000100180322       Ctl-Opt OPTION(*NODEBUGIO:*SRCSTMT);
000101180322       Ctl-Opt DftActGrp(*No);
000103180322       // ===========================================
000104180322     D @charA          S              8    inz('04/12/01')
000105180322     D @charB          S             10    inz('12/02/2004')
000106180322     D @charC          S              8    inz('12/03/04')
000107180322
000108180323       Dcl-S @charA    Char(8)       inz('04/12/01');
000110180323       Dcl-S @charB    Char(10)      inz('12/02/2004');
000111180323       Dcl-S @charC    Char(8)       inz('12/03/04');
000112180323
000113180323       Dcl-S @dateA    date          inz(D'2004-12-04');
000114180323
000116180323       Dcl-S @numA     Packed(6:0)   inz(041205);
000117180323       Dcl-S @numB     Packed(7:0)   inz(1041206);
000118180323       Dcl-S @numC     Packed(8:0)   inz(20041207);
000119180323       Dcl-S @numD     Packed(6:0)   inz(120804);
000120180323       Dcl-S @numE     Packed(8:0)   inz(12092004);
000129180322      /free
000130180322       // *********************************************************************
000131180323         Initialize();
000132180323         DATESandTHINGS();
000156180322         *inlr = *on;
000157180323
000158180322       Dcl-Proc Initialize;
000170180323         If user = 'KELLYM';
000171180323           IPaddress = '10.10.10.10';
000172180323         EndIf;
000205180322       End-Proc;
000206180323
000207180323      //*************************************************************************************
000236180322       Dcl-Proc DATESandTHINGS;
000262180322      // character to character...
000263180322         @charB = %char(%date(@charA:*ymd/):*usa/);                // 'yy/mm/dd'     to  'mm/dd/ccyy
000264180322         @charC = %char(%date(@charA:*ymd/):*mdy/);                // 'yy/mm/dd'     to  'mm/dd/yy'
000265180322         @charA = %char(%date(@charB:*usa/):*ymd/);                // 'mm/dd/ccyy'   to  'yy/mm/dd'
000266180322         @charC = %char(%date(@charB:*usa/):*mdy/);                // 'mm/dd/ccyy'   to  'mm/dd/yy'
000267180322         @charA = %char(%date(@charC:*mdy/):*ymd/);                // 'mm/dd/yy'     to  'yy/mm/dd'
000268180322         @charB = %char(%date(@charC:*mdy/):*usa/);                // 'mm/dd/yy'     to  'mm/dd/ccyy
000269180322
000270180322       // character to date...
000271180322         @dateA = %date(@charA:*ymd/);                             // 'yy/mm/dd'     to  D'ccyy-mm-d
000272180322         @dateA = %date(@charB:*usa/);                             // 'mm/dd/ccyy'   to  D'ccyy-mm-d
000273180322         @dateA = %date(@charC:*mdy/);                             // 'mm/dd/yy'     to  D'ccyy-mm-d
000274180322
000275180322       // character to numeric...
000276180322         @numA = %dec(%char(%date(@charA:*ymd/):*ymd0):6:0);       // 'yy/mm/dd'     to  yymmdd
000277180322         @numB = %dec(%char(%date(@charA:*ymd/):*cymd0):7:0);      // 'yy/mm/dd'     to  cyymmdd
000278180322         @numC = %dec(%char(%date(@charA:*ymd/):*iso0):7:0);       // 'yy/mm/dd'     to  ccyymmdd
000279180322         @numD = %dec(%char(%date(@charA:*ymd/):*mdy0):7:0);       // 'yy/mm/dd'     to  mmddyy
000280180322         @numE = %dec(%char(%date(@charA:*ymd/):*usa0):7:0);       // 'yy/mm/dd'     to  mmddyyyy
000281180322         @numA = %dec(%char(%date(@charB:*usa/):*ymd0):6:0);       // 'mm/dd/ccyy'   to  yymmdd
000282180322         @numB = %dec(%char(%date(@charB:*usa/):*cymd0):7:0);      // 'mm/dd/ccyy'   to  cyymmdd
000283180322         @numC = %dec(%char(%date(@charB:*usa/):*iso0):7:0);       // 'mm/dd/ccyy'   to  ccyymmdd
000284180322         @numD = %dec(%char(%date(@charB:*usa/):*mdy0):7:0);       // 'mm/dd/ccyy'   to  mmddyy
000285180322         @numE = %dec(%char(%date(@charB:*usa/):*usa0):7:0);       // 'mm/dd/ccyy'   to  mmddyyyy
000286180322         @numA = %dec(%char(%date(@charC:*mdy/):*ymd0):6:0);       // 'mm/dd/yy'     to  yymmdd
000287180322         @numB = %dec(%char(%date(@charC:*mdy/):*cymd0):7:0);      // 'mm/dd/yy'     to  cyymmdd
000288180322         @numC = %dec(%char(%date(@charC:*mdy/):*iso0):7:0);       // 'mm/dd/yy'     to  ccyymmdd
000289180322         @numD = %dec(%char(%date(@charC:*mdy/):*mdy0):7:0);       // 'mm/dd/yy'     to  mmddyy
000290180322         @numE = %dec(%char(%date(@charC:*mdy/):*usa0):7:0);       // 'mm/dd/yy'     to  mmddyyyy
000291180322
000292180322       // date to character...
000293180322         @charA = %char(@dateA:*ymd/);                             // D'ccyy-mm-dd'  to  'yy/mm/dd'
000294180322         @charB = %char(@dateA:*usa/);                             // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000295180322         @charC = %char(@dateA:*mdy/);                             // D'ccyy-mm-dd'  to  'mm/dd/yy'
000296180322
000297180322       // date to numeric...
000298180322         @numA = %dec(%char(@dateA:*ymd/):6:0);                    // D'ccyy-mm-dd'  to  yymmdd
000299180322         @numB = %dec(%char(@dateA:*cymd/):7:0);                   // D'ccyy-mm-dd'  to  cyymmdd
000300180322         @numC = %dec(%char(@dateA:*iso-):8:0);                    // D'ccyy-mm-dd'  to  ccyymmdd
000301180322         @numD = %dec(%char(@dateA:*mdy/):6:0);                    // D'ccyy-mm-dd'  to  mmddyy
000302180322         @numE = %dec(%char(@dateA:*usa/):8:0);                    // D'ccyy-mm-dd'  to  mmddccyy
000303180322
000304180322       // numeric to character...
000305180322         @charA = %char(%date(@numA:*ymd):*ymd/);                  // yymmdd         to  'yy/mm/dd'
000306180322         @charB = %char(%date(@numA:*ymd):*usa/);                  // yymmdd         to  'mm/dd/ccyy
000307180322         @charC = %char(%date(@numA:*ymd):*mdy/);                  // yymmdd         to  'mm/dd/yy'
000308180322
000309180322         @charA = %char(%date(@numB:*cymd):*ymd/);                 // cyymmdd        to  'yy/mm/dd'
000310180322         @charB = %char(%date(@numB:*cymd):*usa/);                 // cyymmdd        to  'mm/dd/ccyy
000311180322         @charC = %char(%date(@numB:*cymd):*mdy/);                 // cyymmdd        to  'mm/dd/yy'
000312180322
000313180322         @charA = %char(%date(@numC:*iso):*ymd/);                  // D'ccyy-mm-dd'  to  'yy/mm/dd'
000314180322         @charB = %char(%date(@numC:*iso):*usa/);                  // D'ccyy-mm-dd'  to  'mm/dd/ccyy
000315180322         @charC = %char(%date(@numC:*iso):*mdy/);                  // D'ccyy-mm-dd'  to  'mm/dd/yy'
000316180322
000317180322         @charA = %char(%date(@numD:*mdy):*ymd/);                  // mmddyy         to  'yy/mm/dd'
000318180322         @charB = %char(%date(@numD:*mdy):*usa/);                  // mmddyy         to  'mm/dd/ccyy
000319180322         @charC = %char(%date(@numD:*mdy):*mdy/);                  // mmddyy         to  'mm/dd/yy'
000320180322
000321180322         @charA = %char(%date(@numE:*usa):*ymd/);                  // mmddccyy       to  'yy/mm/dd'
000322180322         @charB = %char(%date(@numE:*usa):*usa/);                  // mmddccyy       to  'mm/dd/ccyy
000323180322         @charC = %char(%date(@numE:*usa):*mdy/);                  // mmddccyy       to  'mm/dd/yy'
000324180322
000325180322       // numeric to date...
000326180322         @dateA = %date(@numA:*ymd);                               // yymmdd         to  D'ccyy-mm-d
000327180322         @dateA = %date(@numB:*cymd);                              // cyymmdd        to  D'ccyy-mm-d
000328180322         @dateA = %date(@numC:*iso);                               // ccyymmdd'      to  D'ccyy-mm-d
000329180322         @dateA = %date(@numD:*mdy);                               // mmddyy         to  D'ccyy-mm-d
000330180322         @dateA = %date(@numE:*usa);                               // mmddccyy       to  D'ccyy-mm-d
000331180322
000332180322       // numeric to numeric...
000333180322         @numB = %dec(%char(%date(@numA:*ymd):*cymd0):7:0);        // yymmdd         to  cyymmdd
000334180322         @numC = %dec(%char(%date(@numA:*ymd):*iso0):8:0);         // yymmdd         to  ccyymmdd
000335180322         @numD = %dec(%char(%date(@numA:*ymd):*mdy0):6:0);         // yymmdd         to  mmddyy
000336180322         @numE = %dec(%char(%date(@numA:*ymd):*usa0):8:0);         // yymmdd         to  mmddccyy
000337180322
000338180322         @numA = %dec(%char(%date(@numB:*cymd):*ymd0):6:0);        // cyymmdd        to  yymmdd
000339180322         @numC = %dec(%char(%date(@numB:*cymd):*iso0):8:0);        // cyymmdd        to  ccyymmdd
000340180322         @numD = %dec(%char(%date(@numB:*cymd):*mdy0):6:0);        // cyymmdd        to  mmddyy
000341180322         @numE = %dec(%char(%date(@numB:*cymd):*usa0):8:0);        // cyymmdd        to  mmddccyy
000342180322
000343180322         @numA = %dec(%char(%date(@numC:*iso):*ymd0):6:0);         // ccyymmdd       to  yymmdd
000344180322         @numB = %dec(%char(%date(@numC:*iso):*cymd0):7:0);        // ccyymmdd       to  cyymmdd
000345180322         @numD = %dec(%char(%date(@numC:*iso):*mdy0):6:0);         // ccyymmdd       to  mmddyy
000346180322         @numE = %dec(%char(%date(@numC:*iso):*usa0):8:0);         // ccyymmdd       to  mmddccyy
000347180322
000348180322         @numA = %dec(%char(%date(@numD:*mdy):*ymd0):6:0);         // mmddyy         to  yymmdd
000349180322         @numB = %dec(%char(%date(@numD:*mdy):*cymd0):7:0);        // mmddyy         to  cyymmdd
000350180322         @numC = %dec(%char(%date(@numD:*mdy):*iso0):8:0);         // mmddyy         to  ccyymmdd
000351180322         @numE = %dec(%char(%date(@numD:*mdy):*usa0):8:0);         // mmddyy         to  mmddccyy
000352180322
000353180322         @numA = %dec(%char(%date(@numE:*usa):*ymd0):6:0);         // mmddccyy       to  yymmdd
000354180322         @numB = %dec(%char(%date(@numE:*usa):*cymd0):7:0);        // mmddccyy       to  cyymmdd
000355180322         @numC = %dec(%char(%date(@numE:*usa):*iso0):8:0);         // mmddccyy       to  ccyymmdd
000356180322         @numD = %dec(%char(%date(@numE:*usa):*mdy0):6:0);         // mmddccyy       to  mmddyy
000357180322         end-proc;
