&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          eai              PROGRESS
*/
&Scoped-define WINDOW-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS c-win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCC0306 1.00.00.000 } /*** 010033 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCC0306 MCC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat�rio                            */
/* Obs: Retirar o valor do preprocessador para as p�ginas que n�o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Temporary Table Definitions ---                                      */


    define temp-table tt-param no-undo
        field destino            as integer
        field arquivo            as char format "x(35)"
        field usuario            as char format "x(12)"
        field data-exec          as date
        field hora-exec          as integer
        field classifica         as integer
        field desc-classifica    as char format "x(40)"
        field modelo-rtf         as char format "x(35)"
        field l-habilitaRtf      as LOG
        FIELD cod-emitente-ini   AS INTEGER
        FIELD cod-emitente-fim   AS INTEGER
        FIELD dt-ini             AS date
        FIELD dt-fim             AS date.


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok         as logical no-undo.
def var c-arq-digita as char    no-undo.
def var c-terminal   as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES grup-estoque estabelec item param-estoq

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH grup-estoque SHARE-LOCK, ~
      EACH mgadm.estabelec WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK, ~
      EACH item OF grup-estoque SHARE-LOCK, ~
      EACH param-estoq WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH grup-estoque SHARE-LOCK, ~
      EACH mgadm.estabelec WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK, ~
      EACH item OF grup-estoque SHARE-LOCK, ~
      EACH param-estoq WHERE TRUE /* Join to grup-estoque incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel grup-estoque estabelec item ~
param-estoq
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel grup-estoque
&Scoped-define SECOND-TABLE-IN-QUERY-f-pg-sel estabelec
&Scoped-define THIRD-TABLE-IN-QUERY-f-pg-sel item
&Scoped-define FOURTH-TABLE-IN-QUERY-f-pg-sel param-estoq


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 RECT-11 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao tb-imprimir-parametro text-parametro 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao ~
tb-imprimir-parametro text-parametro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR c-win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu��o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-parametro AS CHARACTER FORMAT "X(256)":U INITIAL "Par�metros de Impress�o" 
      VIEW-AS TEXT 
     SIZE 19.72 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3,
"Planilha", 4
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 2.13.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.86 BY 1.71.

DEFINE VARIABLE tb-imprimir-parametro AS LOGICAL INITIAL yes 
     LABEL "Imprimir par�metros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE c-emitente-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/40 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-pg-sel FOR 
      grup-estoque, 
      estabelec, 
      item, 
      param-estoq SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu��o do relat�rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress�o do Relat�rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 48 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 48 HELP
          "Configura��o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat�rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu��o" NO-LABEL
     tb-imprimir-parametro AT ROW 8.5 COL 3 WIDGET-ID 4
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-parametro AT ROW 7.58 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
     RECT-11 AT ROW 7.88 COL 2.14 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.5 BY 10.5.

DEFINE FRAME f-pg-sel
     dt-ini AT ROW 4.21 COL 20 COLON-ALIGNED WIDGET-ID 12
     dt-fim AT ROW 4.17 COL 45.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-emitente-ini AT ROW 5.38 COL 20.29 COLON-ALIGNED WIDGET-ID 28
     c-emitente-fim AT ROW 5.33 COL 45.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     IMAGE-27 AT ROW 4.17 COL 36.14 WIDGET-ID 14
     IMAGE-28 AT ROW 4.17 COL 44 WIDGET-ID 16
     IMAGE-29 AT ROW 5.33 COL 36.43 WIDGET-ID 30
     IMAGE-30 AT ROW 5.33 COL 44.29 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.5 BY 10.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW c-win ASSIGN
         HIDDEN             = YES
         TITLE              = "Pedidos x Recebimento"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB c-win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW c-win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu��o".

/* SETTINGS FOR FRAME f-pg-sel
   Custom                                                               */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
THEN c-win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _TblList          = "eai.grup-estoque,mgadm.estabelec WHERE eai.grup-estoque ...,eai.item OF eai.grup-estoque,eai.param-estoq WHERE eai.grup-estoque ..."
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON END-ERROR OF c-win /* Pedidos x Recebimento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON WINDOW-CLOSE OF c-win /* Pedidos x Recebimento */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda c-win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo c-win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar c-win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr c-win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar c-win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
    do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp c-win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel c-win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao c-win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK c-win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCC0306" "1.00.00.000"}

/* inicializa��es do template de relat�rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   RUN disable_UI.
END.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


    RUN enable_UI.

    {include/i-rpmbl.i im-pg-sel}



    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects c-win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available c-win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI c-win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
  THEN DELETE WIDGET c-win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI c-win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-imp im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-destino c-arquivo rs-execucao tb-imprimir-parametro text-parametro 
      WITH FRAME f-pg-imp IN WINDOW c-win.
  ENABLE RECT-7 RECT-9 RECT-11 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao tb-imprimir-parametro text-parametro 
      WITH FRAME f-pg-imp IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY dt-ini dt-fim c-emitente-ini c-emitente-fim 
      WITH FRAME f-pg-sel IN WINDOW c-win.
  ENABLE dt-ini IMAGE-27 dt-fim IMAGE-28 c-emitente-ini IMAGE-29 c-emitente-fim 
         IMAGE-30 
      WITH FRAME f-pg-sel IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW c-win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit c-win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/

   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize c-win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   

  
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar c-win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}
    if  input frame f-pg-imp rs-destino = 2 OR 
        input frame f-pg-imp rs-destino = 4 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry'              to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.


/*             /* Valida��o de duplicidade de registro na temp-table tt-digita */                                                 */
/*             find first b-tt-digita where b-tt-digita.cod-estabel = tt-digita.cod-estabel and                                   */
/*                                          rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.                              */
/*             if avail b-tt-digita then do:                                                                                      */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid rowid(b-tt-digita).                                                              */
/*                                                                                                                                */
/*                 run utp/ut-msgs.p (input "show", input 108, input "").                                                         */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             /* As demais valida��es devem ser feitas aqui */                                                                   */
/*             if not can-find(estabelec where estabelec.cod-estabel = tt-digita.cod-estabel)                                     */
/*             then do:                                                                                                           */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                                                                                                                                */
/*                 {utp/ut-table.i mgadm estabelec 1}                                                                             */
/*                 run utp/ut-msgs.p (input "show", input 2, input return-value).                                                 */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             find estab-mat where estab-mat.cod-estabel = tt-digita.cod-estabel                                                 */
/*                  no-lock no-error.                                                                                             */
/*             if not avail estab-mat then do:                                                                                    */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                                                                                                                                */
/*                 {utp/ut-table.i mgind estab-mat 1}                                                                             */
/*                 run utp/ut-msgs.p (input "show", input 2, input return-value).                                                 */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*                                                                                                                                */
/*             run cdp/cdapi005.p (input  estab-mat.ult-per-fech,                                                                 */
/*                                 output da-iniper-x,                                                                            */
/*                                 output da-fimper-x,                                                                            */
/*                                 output i-mes,                                                                                  */
/*                                 output i-ano,                                                                                  */
/*                                 output da-iniper-fech,                                                                         */
/*                                 output da-fimper-fech).                                                                        */
/*                                                                                                                                */
/*             if i-mes = ? or                                                                                                    */
/*                i-ano = 0 then do:                                                                                              */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                 run utp/ut-msgs.p (input "show", input 16459, input "").                                                       */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*                                                                                                                                */
/*             end.                                                                                                               */
/*             if estab-mat.ult-per-fech = "" or                                                                                  */
/*                estab-mat.ult-per-fech = ? then do:                                                                             */
/*                 apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                                    */
/*                 reposition br-digita to rowid r-tt-digita.                                                                     */
/*                 run utp/ut-msgs.p (input "show", input 17109, input "").                                                       */
/*                 apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.                                                  */
/*                 return error.                                                                                                  */
/*             end.                                                                                                               */
/*         end.                                                                                                                   */
/*     &endif.                                                                                                                    */
/*                                                                                                                                */
/*     /* Coloque aqui as valida��es das outras p�ginas, lembrando que elas                                                       */
/*        devem apresentar uma mensagem de erro cadastrada, posicionar na p�gina                                                  */
/*        com problemas e colocar o focus no campo com problemas             */                                                   */
/*                                                                                                                                */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) = 1                                                                   */
/*     and param-estoq.tem-moeda1 = no then do:                                                                                   */
/*         run utp/ut-msgs.p (input "show", input 110, input "").                                                                 */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) = 2                                                                   */
/*     and param-estoq.tem-moeda2 = no then do:                                                                                   */
/*         run utp/ut-msgs.p (input "show", input 111, input "").                                                                 */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*     if  int(substr(input frame f-pg-par cb-moeda, 1, 1)) > 2 then do:                                                          */
/*         run utp/ut-msgs.p (input "show", input 4412, input "").                                                                */
/*         apply 'mouse-select-click' to im-pg-par in frame f-relat.                                                              */
/*         apply 'entry'              to cb-moeda  in frame f-pg-par.                                                             */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */
/*     /*Validar se existe ano fiscal cadastrado para o periodo informado*/                                                       */
/*     if not avail param-global then                                                                                             */
/*         find first param-global no-lock no-error.                                                                              */
/*                                                                                                                                */
/*     assign i-empresa = param-global.empresa-prin.                                                                              */
/*                                                                                                                                */
/*     if not can-find(first ano-fiscal where ano-fiscal.ep-codigo  = i-empresa                                                   */
/*                                        and ano-fiscal.ano-fiscal = INT(SUBSTRING(input frame f-pg-sel c-per-i,1,4))) then do:  */
/*         run utp/ut-msgs.p (input "show",                                                                                       */
/*                            input 4138,                                                                                         */
/*                            input SUBSTRING(input frame f-pg-sel c-per-i,1,4)).                                                 */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */
/*      if not can-find(first ano-fiscal where ano-fiscal.ep-codigo  = i-empresa                                                  */
/*                                         and ano-fiscal.ano-fiscal = INT(SUBSTRING(input frame f-pg-sel c-per-f,1,4))) then do: */
/*        run utp/ut-msgs.p (input "show",                                                                                        */
/*                           input 4138,                                                                                          */
/*                           input SUBSTRING(input frame f-pg-sel c-per-f,1,4)).                                                  */
/*         return error.                                                                                                          */
/*     end.                                                                                                                       */
/*                                                                                                                                */


    create tt-param.
    assign tt-param.usuario           = c-seg-usuario
           tt-param.destino           = input frame f-pg-imp rs-destino
           tt-param.data-exec         = today
           tt-param.hora-exec         = time
           tt-param.dt-ini            = iNPUT FRAME f-pg-sel dt-ini
           tt-param.dt-fim            = INPUT FRAME f-pg-sel dt-fim
           tt-param.cod-emitente-ini  = INPUT FRAME f-pg-sel c-emitente-ini
           tt-param.cod-emitente-fim  = INPUT FRAME f-pg-sel c-emitente-fim.


    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 OR tt-param.destino = 4 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l�gica de grava��o dos par�mtros e sele��o na temp-table
       tt-param */ 

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

     {include/i-rprun.i esp/escc0306rp.p}
    

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina c-win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P�gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records c-win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "grup-estoque"}
  {src/adm/template/snd-list.i "estabelec"}
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "param-estoq"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed c-win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

