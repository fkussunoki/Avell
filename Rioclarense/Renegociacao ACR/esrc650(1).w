&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i D99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
def var i-cod-rep as integer.  
/* Local Variable Definitions ---                                       */
DEF INPUT param p-id-tit-acr AS RECID NO-UNDO.

DEF NEW  GLOBAL SHARED VAR c-var-estab AS char.
DEF NEW GLOBAL  SHARED VAR c-var-serie  AS char.
DEF NEW GLOBAL  SHARED VAR c-var-fatura AS char.

DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-titulos 
    FIELD ttv-estab AS char
    FIELD ttv-especie AS char
    FIELD ttv-serie   AS char
    FIELD ttv-titulo AS CHAR
    FIELD ttv-parcela AS char
    FIELD ttv-valor   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>>.99"
    FIELD ttv-cta-ctbl AS char
    FIELD ttv-vcto   AS date.


DEFINE VAR i AS INTEGER.


def new global shared var v_rec_cta_ctbl_integr
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES fat-repre

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table fn-repre() @ i-cod-rep fat-repre.nome-ab-rep fat-repre.perc-comis fat-repre.comis-emis   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH fat-repre WHERE                                  fat-repre.cod-estabel = c-var-estab and                                  fat-repre.serie       = c-var-serie       and                                  fat-repre.nr-fatura   = c-var-fatura NO-LOCK
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH fat-repre WHERE                                  fat-repre.cod-estabel = c-var-estab and                                  fat-repre.serie       = c-var-serie       and                                  fat-repre.nr-fatura   = c-var-fatura NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-table fat-repre
&Scoped-define FIRST-TABLE-IN-QUERY-br-table fat-repre


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-1 RECT-2 RECT-3 RECT-4 RECT-7 ~
FILL-IN-6 FILL-IN-7 BUTTON-1 COMBO-BOX-1 br-table bt-ajuda bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS parc1 vcto1 c-estab FILL-IN-6 parc2 vcto2 ~
c-espec parc3 vcto3 FILL-IN-7 c-serie parc4 vcto4 COMBO-BOX-1 c-titulo ~
parc5 vcto5 parc6 vcto6 parc7 vcto7 parc8 vcto8 parc9 vcto9 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDialogCues" D-Dialog _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/*:T SmartDialog,uib,49267
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-repre D-Dialog 
FUNCTION fn-repre RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "Gerar" 
     SIZE 7.72 BY 1.13.

DEFINE VARIABLE COMBO-BOX-1 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Parcelas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "         1","         2","         3","         4","         5","         6","         7","         8","         9" 
     DROP-DOWN-LIST
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-espec AS CHARACTER FORMAT "X(256)":U 
     LABEL "Especie" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Titulo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cta." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS DECIMAL FORMAT "->,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE parc1 AS DATE FORMAT "99/99/99":U INITIAL ? 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc2 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc3 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc4 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc5 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc6 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc7 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc8 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE parc9 AS DATE FORMAT "99/99/99":U 
     LABEL "Vcto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto1 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto2 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto3 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto4 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto5 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto6 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto7 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto8 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vcto9 AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.72 BY 4.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.72 BY 5.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.86 BY 5.83.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 10.92.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 119.86 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      fat-repre SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table D-Dialog _FREEFORM
  QUERY br-table DISPLAY
      fn-repre() @ i-cod-rep
      fat-repre.nome-ab-rep
      fat-repre.perc-comis
      fat-repre.comis-emis
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78.57 BY 4.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     parc1 AT ROW 1.5 COL 88.43 COLON-ALIGNED WIDGET-ID 34
     vcto1 AT ROW 1.58 COL 105.57 COLON-ALIGNED WIDGET-ID 36
     c-estab AT ROW 1.92 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-6 AT ROW 2.58 COL 56.43 COLON-ALIGNED WIDGET-ID 20
     parc2 AT ROW 2.67 COL 88.57 COLON-ALIGNED WIDGET-ID 72
     vcto2 AT ROW 2.75 COL 105.57 COLON-ALIGNED WIDGET-ID 70
     c-espec AT ROW 3.17 COL 10.57 COLON-ALIGNED WIDGET-ID 4
     parc3 AT ROW 3.83 COL 88.57 COLON-ALIGNED WIDGET-ID 68
     vcto3 AT ROW 3.92 COL 105.57 COLON-ALIGNED WIDGET-ID 66
     FILL-IN-7 AT ROW 4.04 COL 56.86 COLON-ALIGNED WIDGET-ID 24
     c-serie AT ROW 4.5 COL 10.57 COLON-ALIGNED WIDGET-ID 6
     parc4 AT ROW 5.04 COL 88.57 COLON-ALIGNED WIDGET-ID 64
     vcto4 AT ROW 5.13 COL 105.57 COLON-ALIGNED WIDGET-ID 62
     BUTTON-1 AT ROW 5.46 COL 74.43 WIDGET-ID 22
     COMBO-BOX-1 AT ROW 5.5 COL 57 COLON-ALIGNED WIDGET-ID 32
     c-titulo AT ROW 5.83 COL 10.43 COLON-ALIGNED WIDGET-ID 8
     parc5 AT ROW 6.17 COL 88.57 COLON-ALIGNED WIDGET-ID 60
     vcto5 AT ROW 6.25 COL 105.57 COLON-ALIGNED WIDGET-ID 58
     parc6 AT ROW 7.33 COL 88.43 COLON-ALIGNED WIDGET-ID 56
     vcto6 AT ROW 7.42 COL 105.57 COLON-ALIGNED WIDGET-ID 54
     br-table AT ROW 7.58 COL 3.86 WIDGET-ID 200
     parc7 AT ROW 8.42 COL 88.72 COLON-ALIGNED WIDGET-ID 52
     vcto7 AT ROW 8.5 COL 105.57 COLON-ALIGNED WIDGET-ID 50
     parc8 AT ROW 9.54 COL 88.72 COLON-ALIGNED WIDGET-ID 48
     vcto8 AT ROW 9.63 COL 105.57 COLON-ALIGNED WIDGET-ID 46
     parc9 AT ROW 10.71 COL 88.72 COLON-ALIGNED WIDGET-ID 44
     vcto9 AT ROW 10.79 COL 105.57 COLON-ALIGNED WIDGET-ID 42
     bt-ajuda AT ROW 12.5 COL 110.86
     bt-ok AT ROW 12.54 COL 3
     bt-cancela AT ROW 12.54 COL 14
     rt-buttom AT ROW 12.29 COL 2
     RECT-1 AT ROW 1 COL 1.86 WIDGET-ID 12
     RECT-2 AT ROW 7.42 COL 2.14 WIDGET-ID 14
     RECT-3 AT ROW 1.17 COL 2.72 WIDGET-ID 16
     RECT-4 AT ROW 1.13 COL 47.14 WIDGET-ID 18
     RECT-7 AT ROW 1 COL 84.72 WIDGET-ID 28
     SPACE(0.27) SKIP(1.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Renegociacao"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-table vcto6 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-espec IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estab IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN parc9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vcto9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH fat-repre WHERE
                                 fat-repre.cod-estabel = c-var-estab and
                                 fat-repre.serie       = c-var-serie       and
                                 fat-repre.nr-fatura   = c-var-fatura NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Renegociacao */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Gerar */
DO:

    RUN pi-temp-table.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME D-Dialog /* Parcelas */
DO:
  
    FIND FIRST tit_acr NO-LOCK WHERE RECID(tit_acr) = p-id-tit-acr NO-ERROR.
    CASE combo-box-1:SCREEN-VALUE:


        WHEN "1" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = NO
                   vcto2:SENSITIVE = NO
                   parc3:SENSITIVE = NO
                   vcto3:SENSITIVE = NO
                   parc4:SENSITIVE = NO
                   vcto4:SENSITIVE = NO
                   parc5:SENSITIVE = NO
                   vcto5:SENSITIVE = NO
                   parc6:SENSITIVE = NO 
                   vcto6:SENSITIVE = NO 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "100"
                   vcto2:screen-value = "0"
                   vcto3:screen-value = "0"
                   vcto4:screen-value = "0"
                   vcto5:screen-value = "0"
                   vcto6:screen-value = "0"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"
                   parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30).

        END.


        WHEN "2" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = YES
                   vcto2:SENSITIVE = YES
                   parc3:SENSITIVE = NO
                   vcto3:SENSITIVE = NO
                   parc4:SENSITIVE = NO
                   vcto4:SENSITIVE = NO
                   parc5:SENSITIVE = NO
                   vcto5:SENSITIVE = NO
                   parc6:SENSITIVE = NO 
                   vcto6:SENSITIVE = NO 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "50"
                   vcto2:screen-value = "50"
                   vcto3:screen-value = "0"
                   vcto4:screen-value = "0"
                   vcto5:screen-value = "0"
                   vcto6:screen-value = "0"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"
                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60).



        END.

        WHEN "3" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = YES
                   vcto2:SENSITIVE = YES
                   parc3:SENSITIVE = YES
                   vcto3:SENSITIVE = YES
                   parc4:SENSITIVE = NO
                   vcto4:SENSITIVE = NO
                   parc5:SENSITIVE = NO
                   vcto5:SENSITIVE = NO
                   parc6:SENSITIVE = NO 
                   vcto6:SENSITIVE = NO 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "33,33"
                   vcto2:screen-value = "33,33"
                   vcto3:screen-value = "33,34"
                   vcto4:screen-value = "0"
                   vcto5:screen-value = "0"
                   vcto6:screen-value = "0"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90).

        END.
        WHEN "4" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = YES
                   vcto2:SENSITIVE = YES
                   parc3:SENSITIVE = YES
                   vcto3:SENSITIVE = YES
                   parc4:SENSITIVE = YES
                   vcto4:SENSITIVE = YES
                   parc5:SENSITIVE = NO
                   vcto5:SENSITIVE = NO
                   parc6:SENSITIVE = NO 
                   vcto6:SENSITIVE = NO 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "25"
                   vcto2:screen-value = "25"
                   vcto3:screen-value = "25"
                   vcto4:screen-value = "25"
                   vcto5:screen-value = "0"
                   vcto6:screen-value = "0"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120).

        END.
        WHEN "5" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = YES
                   vcto2:SENSITIVE = YES
                   parc3:SENSITIVE = YES
                   vcto3:SENSITIVE = YES
                   parc4:SENSITIVE = YES
                   vcto4:SENSITIVE = YES
                   parc5:SENSITIVE = YES
                   vcto5:SENSITIVE = YES
                   parc6:SENSITIVE = NO 
                   vcto6:SENSITIVE = NO 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "20"
                   vcto2:screen-value = "20"
                   vcto3:screen-value = "20"
                   vcto4:screen-value = "20"
                   vcto5:screen-value = "20"
                   vcto6:screen-value = "0"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120)
                parc5:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 150).

        END.
        WHEN "6" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = yes
                   vcto2:SENSITIVE = yes
                   parc3:SENSITIVE = yes
                   vcto3:SENSITIVE = yes
                   parc4:SENSITIVE = yes
                   vcto4:SENSITIVE = yes
                   parc5:SENSITIVE = yes
                   vcto5:SENSITIVE = yes
                   parc6:SENSITIVE = yes 
                   vcto6:SENSITIVE = yes 
                   parc7:SENSITIVE = NO  
                   vcto7:SENSITIVE = NO  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "16,66"
                   vcto2:screen-value = "16,66"
                   vcto3:screen-value = "16,66"
                   vcto4:screen-value = "16,66"
                   vcto5:screen-value = "16,66"
                   vcto6:screen-value = "16,70"
                   vcto7:screen-value = "0"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120)
                parc5:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 150)
                parc6:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 180).

        END.
        WHEN "7" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = yes
                   vcto2:SENSITIVE = yes
                   parc3:SENSITIVE = yes
                   vcto3:SENSITIVE = yes
                   parc4:SENSITIVE = yes
                   vcto4:SENSITIVE = yes
                   parc5:SENSITIVE = yes
                   vcto5:SENSITIVE = yes
                   parc6:SENSITIVE = yes 
                   vcto6:SENSITIVE = yes 
                   parc7:SENSITIVE = yes  
                   vcto7:SENSITIVE = yes  
                   parc8:SENSITIVE = NO  
                   vcto8:SENSITIVE = NO  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "14,28"
                   vcto2:screen-value = "14,28"
                   vcto3:screen-value = "14,28"
                   vcto4:screen-value = "14,28"
                   vcto5:screen-value = "14,28"
                   vcto6:screen-value = "14,28"
                   vcto7:screen-value = "14,32"
                   vcto8:screen-value = "0"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120)
                parc5:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 150)
                parc6:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 180)
                parc7:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 210).

        END.
        WHEN "8" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = yes
                   vcto2:SENSITIVE = yes
                   parc3:SENSITIVE = yes
                   vcto3:SENSITIVE = yes
                   parc4:SENSITIVE = yes
                   vcto4:SENSITIVE = yes
                   parc5:SENSITIVE = yes
                   vcto5:SENSITIVE = yes
                   parc6:SENSITIVE = yes 
                   vcto6:SENSITIVE = yes 
                   parc7:SENSITIVE = yes  
                   vcto7:SENSITIVE = yes  
                   parc8:SENSITIVE = yes  
                   vcto8:SENSITIVE = yes  
                   parc9:SENSITIVE = NO  
                   vcto9:SENSITIVE = NO. 

            ASSIGN vcto1:SCREEN-VALUE = "12,50"
                   vcto2:screen-value = "12,50"
                   vcto3:screen-value = "12,50"
                   vcto4:screen-value = "12,50"
                   vcto5:screen-value = "12,50"
                   vcto6:screen-value = "12,50"
                   vcto7:screen-value = "12,50"
                   vcto8:screen-value = "12,50"
                   vcto9:screen-value = "0"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120)
                parc5:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 150)
                parc6:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 180)
                parc7:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 210)
                parc8:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 240).

        END.
        WHEN "9" THEN DO:
            
            ASSIGN parc1:SENSITIVE = YES
                   vcto1:SENSITIVE = YES
                   parc2:SENSITIVE = yes
                   vcto2:SENSITIVE = yes
                   parc3:SENSITIVE = yes
                   vcto3:SENSITIVE = yes
                   parc4:SENSITIVE = yes
                   vcto4:SENSITIVE = yes
                   parc5:SENSITIVE = yes
                   vcto5:SENSITIVE = yes
                   parc6:SENSITIVE = yes 
                   vcto6:SENSITIVE = yes 
                   parc7:SENSITIVE = yes  
                   vcto7:SENSITIVE = yes  
                   parc8:SENSITIVE = yes  
                   vcto8:SENSITIVE = yes  
                   parc9:SENSITIVE = yes  
                   vcto9:SENSITIVE = yes. 

            ASSIGN vcto1:SCREEN-VALUE = "11,11"
                   vcto2:screen-value = "11,11"
                   vcto3:screen-value = "11,11"
                   vcto4:screen-value = "11,11"
                   vcto5:screen-value = "11,11"
                   vcto6:screen-value = "11,11"
                   vcto7:screen-value = "11,11"
                   vcto8:screen-value = "11,11"
                   vcto9:screen-value = "11,12"

                parc1:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 30)
                parc2:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 60)
                parc3:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 90)
                parc4:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 120)
                parc5:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 150)
                parc6:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 180)
                parc7:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 210)
                parc8:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 240)
                parc9:SCREEN-VALUE = string(tit_acr.dat_vencto_tit_acr + 270).

        END.


    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-6 D-Dialog
ON F5 OF FILL-IN-6 IN FRAME D-Dialog /* Cta. */
DO:
  
    FIND FIRST plano_cta_ctbl NO-LOCK WHERE plano_cta_ctbl.dat_fim_valid >= TODAY NO-ERROR.

        run prgint/utb/utb033na.p (Input "ACR" /*l_acr*/,
                               Input plano_cta_ctbl.cod_plano_cta_ctbl,
                               Input "Conta Movimento" /*l_conta_movimento*/) /*prg_see_cta_ctbl_integr*/.
    if  v_rec_cta_ctbl_integr <> ?
    then do:
        find cta_ctbl_integr where recid(cta_ctbl_integr) = v_rec_cta_ctbl_integr no-lock no-error.
        assign fill-in-6:screen-value in frame {&FRAME-NAME} =
               string(cta_ctbl_integr.cod_cta_ctbl).
end. /* ON  CHOOSE OF bt_zoo_293421 IN FRAME f_dlg_04_aprop_ctbl_pend_acr_rateio */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-6 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-6 IN FRAME D-Dialog /* Cta. */
DO:
  APPLY 'f5' TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-table
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY parc1 vcto1 c-estab FILL-IN-6 parc2 vcto2 c-espec parc3 vcto3 
          FILL-IN-7 c-serie parc4 vcto4 COMBO-BOX-1 c-titulo parc5 vcto5 parc6 
          vcto6 parc7 vcto7 parc8 vcto8 parc9 vcto9 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom RECT-1 RECT-2 RECT-3 RECT-4 RECT-7 FILL-IN-6 FILL-IN-7 
         BUTTON-1 COMBO-BOX-1 br-table bt-ajuda bt-ok bt-cancela 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "D99XX999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .



  /* Code placed here will execute AFTER standard behavior.    */



  FIND FIRST tit_acr WHERE RECID(tit_acr) = p-id-tit-acr NO-ERROR.

  ASSIGN  c-estab:SCREEN-VALUE = tit_acr.cod_estab.
  ASSIGN  c-espec:SCREEN-VALUE = tit_acr.cod_espec_docto.
  ASSIGN  c-serie:SCREEN-VALUE  = tit_acr.cod_ser_docto.
  ASSIGN  c-titulo:SCREEN-VALUE = tit_acr.cod_tit_acr.

  ASSIGN c-var-estab  = tit_acr.cod_estab
         c-var-serie  = tit_acr.cod_ser_docto
         c-var-fatura = tit_acr.cod_tit_acr.
  
  
  {utp/ut-field.i mgadm repres cod-rep 2}
assign i-cod-rep:label in browse br-table = return-value.

OPEN QUERY br-table FOR EACH fat-repre WHERE
                                 fat-repre.cod-estabel = c-var-estab and
                                 fat-repre.serie       = c-var-serie       and
                                 fat-repre.nr-fatura   = c-var-fatura NO-LOCK.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-parcelas D-Dialog 
PROCEDURE pi-parcelas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         DEF INPUT param v-parcela AS INTEGER.
         DEF OUTPUT param r-parcela AS char.

         CASE v-parcela:

             WHEN 1 THEN
              ASSIGN r-parcela = "r1".
             WHEN 2 THEN
              ASSIGN r-parcela = "r2".
             WHEN 3 THEN
              ASSIGN r-parcela = "r3".
             WHEN 4 THEN
             ASSIGN r-parcela = "r4".
             WHEN 5 THEN
             ASSIGN r-parcela = "r5".
             WHEN 6 THEN
             ASSIGN r-parcela = "r6".
             WHEN 7 THEN
             ASSIGN r-parcela = "r7".
             WHEN 8 THEN
             ASSIGN r-parcela = "r8".
             WHEN 9 THEN
             ASSIGN r-parcela = "r9".




         END CASE.
         
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-temp-table D-Dialog 
PROCEDURE pi-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR r-parcela AS char.
ASSIGN i = 1.

  DO WHILE (i <= INT(combo-box-1:SCREEN-VALUE IN FRAME {&FRAME-NAME})):

      RUN pi-parcelas(INPUT i,
                      OUTPUT r-parcela).

      CREATE tt-titulos.
      ASSIGN tt-titulos.ttv-estab     = c-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             tt-titulos.ttv-especie   = c-espec:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             tt-titulos.ttv-serie     = c-serie:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             tt-titulos.ttv-titulo    = c-titulo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             tt-titulos.ttv-parcela   = r-parcela
             tt-titulos.ttv-cta-ctbl  = fill-in-6:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

      CASE i:

          WHEN 1 THEN DO:
              
          
          ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc1
                 tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto1 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.
                 
          WHEN 2 THEN DO:
              
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc2
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto2 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.

          WHEN 3 THEN DO:
              
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc3
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto3 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 4 THEN DO:
              
          
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc4
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto4 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 5 THEN DO:
              
          
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc5
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto5 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 6 THEN DO:
              
          
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc6
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto6 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 7 THEN DO:
              
          
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc7
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto7 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 8 THEN DO:
              
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc8
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto8 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.


          WHEN 9 THEN DO:
              
          
              ASSIGN tt-titulos.ttv-vcto = INPUT FRAME {&FRAME-NAME} parc9
                     tt-titulos.ttv-valor = (INPUT FRAME {&FRAME-NAME} vcto9 / 100) * INPUT FRAME {&FRAME-NAME} fill-in-7.
         ASSIGN i = i + 1.
          END.

      END CASE.


      END.


      RUN esp/esrcc650rp.p (INPUT TABLE tt-titulos,
                           INPUT FRAME {&FRAME-NAME} fill-in-7).

      APPLY 'close' TO THIS-PROCEDURE.

      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "fat-repre"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-repre D-Dialog 
FUNCTION fn-repre RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  find first repres where
             repres.nome-abrev = fat-repre.nome-ab-rep no-lock no-error.
  if avail repres then
     RETURN repres.cod-rep.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

