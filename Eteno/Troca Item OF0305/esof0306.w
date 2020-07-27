&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-naturezas
    FIELD ttv-naturezas AS char.



DEF TEMP-TABLE TT-NOTAS
    FIELD ttv-estab       AS char
    FIELD TTV-IT-CODIGO   AS CHAR
    FIELD ttv-it-codigo-or AS char
    FIELD TTV-NOTA-FISCAL AS CHAR
    FIELD TTV-SERIE       AS CHAR
    FIELD TTV-NAT-OPER    AS CHAR
    FIELD TTV-EMITENTE    AS INTEGER
    FIELD TTV-DT-EMISS    AS DATE
    FIELD ttv-selecionado AS LOGICAL INITIAL YES.

DEF VAR i AS INTEGER.

DEF VAR linhas AS INTEGER.

DEF VAR l-logico AS LOGICAL INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-notas

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-notas.ttv-selecionado tt-notas.TTV-IT-CODIGO tt-notas.TTV-NOTA-FISCAL tt-notas.TTV-SERIE tt-notas.TTV-NAT-OPER tt-notas.TTV-EMITENTE tt-notas.TTV-DT-EMISS   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 tt-notas.ttv-selecionado   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-5 tt-notas
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-5 tt-notas
&Scoped-define SELF-NAME BROWSE-5
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-notas
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY {&SELF-NAME} FOR EACH tt-notas.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-notas


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-natureza c-dt-ini c-dt-fim c-estab-ini ~
c-estab-fim BUTTON-11 BUTTON-12 bt-ok bt-cancelar bt-ajuda RECT-1 IMAGE-1 ~
IMAGE-2 IMAGE-3 IMAGE-4 RECT-16 BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS c-natureza c-dt-ini c-dt-fim c-estab-ini ~
c-estab-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-11 
     LABEL "Filtrar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-12 
     LABEL "Cancelar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-dt-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Dt. Emissao" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "zzzzz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Cod.Estab" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Naturezas" 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 83.14 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.72 BY 13.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 w-window _FREEFORM
  QUERY BROWSE-5 DISPLAY
      tt-notas.ttv-selecionado COLUMN-LABEL "Selecionado" VIEW-AS TOGGLE-BOX
tt-notas.TTV-IT-CODIGO   COLUMN-LABEL "Item" FORMAT "x(20)"
tt-notas.TTV-NOTA-FISCAL COLUMN-LABEL "NF"   FORMAT "x(10)"
tt-notas.TTV-SERIE       COLUMN-LABEL "Serie"  FORMAT "x(5)"
tt-notas.TTV-NAT-OPER    COLUMN-LABEL "Nat.Oper"  FORMAT "x(10)"
tt-notas.TTV-EMITENTE    COLUMN-LABEL "Cliente"   FORMAT "9999999"
tt-notas.TTV-DT-EMISS    COLUMN-LABEL "Emissao"   



ENABLE 
    tt-notas.ttv-selecionado
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 77.14 BY 12.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-natureza AT ROW 5.25 COL 24.72 COLON-ALIGNED WIDGET-ID 92
     c-dt-ini AT ROW 2.29 COL 25.29 COLON-ALIGNED WIDGET-ID 2
     c-dt-fim AT ROW 2.21 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-estab-ini AT ROW 3.63 COL 25 COLON-ALIGNED WIDGET-ID 10
     c-estab-fim AT ROW 3.54 COL 48.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-11 AT ROW 2.04 COL 66.14 WIDGET-ID 30
     BUTTON-12 AT ROW 3.5 COL 66.14 WIDGET-ID 32
     bt-ok AT ROW 23.42 COL 2
     bt-cancelar AT ROW 23.42 COL 13
     bt-ajuda AT ROW 23.33 COL 73.86
     BROWSE-5 AT ROW 9.33 COL 6.14 WIDGET-ID 200
     RECT-1 AT ROW 23.21 COL 1
     IMAGE-1 AT ROW 2.25 COL 41.29 WIDGET-ID 6
     IMAGE-2 AT ROW 2.25 COL 47.43 WIDGET-ID 8
     IMAGE-3 AT ROW 3.58 COL 41.14 WIDGET-ID 14
     IMAGE-4 AT ROW 3.58 COL 47.43 WIDGET-ID 16
     RECT-16 AT ROW 8.83 COL 1.29 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 198.43 BY 23.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Alteracao Titulos APB"
         HEIGHT             = 23.96
         WIDTH              = 84.72
         MAX-HEIGHT         = 23.96
         MAX-WIDTH          = 229
         VIRTUAL-HEIGHT     = 23.96
         VIRTUAL-WIDTH      = 229
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-5 RECT-16 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Alteracao Titulos APB */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Alteracao Titulos APB */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    

    FOR EACH tt-notas WHERE tt-notas.ttv-selecionado = YES:
        ASSIGN linhas = linhas + 1.

    END.


    MESSAGE 'Alterar os ' + string(linhas) + ' reguistros em OF0305?' VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE l-logico .

    IF l-logico THEN DO:

        FOR EACH tt-notas WHERE tt-notas.ttv-selecionado = YES:


            FIND FIRST it-doc-fisc WHERE it-doc-fisc.cod-estabel         = tt-notas.ttv-estab
                                           AND   it-doc-fisc.serie       = tt-notas.ttv-serie
                                           AND   it-doc-fisc.cod-emitente = tt-notas.ttv-emitente
                                           AND   it-doc-fisc.it-codigo    = tt-notas.ttv-it-codigo
                                           AND   it-doc-fisc.nr-doc-fis   = tt-notas.ttv-nota-fiscal
                                           NO-ERROR.


            ASSIGN it-doc-fisc.cd-trib-ipi = 3
                   it-doc-fisc.vl-ipiou-it = it-doc-fisc.vl-merc-liq.

            DELETE tt-notas.
        END.

    END.



        MESSAGE 'Processo Concluido' VIEW-AS ALERT-BOX.
        RUN pi-atualizar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 w-window
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Filtrar */
DO:
  
  RUN pi-filtrar.

  RUN pi-atualizar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 w-window
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Cancelar */
DO:
    EMPTY TEMP-TABLE tt-notas.

    RUN pi-atualizar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY c-natureza c-dt-ini c-dt-fim c-estab-ini c-estab-fim 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE c-natureza c-dt-ini c-dt-fim c-estab-ini c-estab-fim BUTTON-11 
         BUTTON-12 bt-ok bt-cancelar bt-ajuda RECT-1 IMAGE-1 IMAGE-2 IMAGE-3 
         IMAGE-4 RECT-16 BROWSE-5 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "XX9999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

ASSIGN c-natureza:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1352tt, 1302'.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar w-window 
PROCEDURE pi-atualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY browse-5 FOR EACH tt-notas WHERE TT-NOTAS.TTV-SELECIONADO = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtrar w-window 
PROCEDURE pi-filtrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-notas.      
DEF BUFFER B-ITEM FOR it-nota-fisc.
                                         
RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Gerando").


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Gerando").

ENTRADAS:
DO i = 1 TO NUM-ENTRIES(INPUT FRAME {&FRAME-NAME} c-natureza):

    FOR EACH docum-est NO-LOCK WHERE   docum-est.cod-estabel >= INPUT FRAME {&FRAME-NAME} c-estab-ini
                              AND      docum-est.cod-estabel <= INPUT FRAME {&FRAME-NAME} c-estab-fim
                              AND      docum-est.dt-trans    >= INPUT FRAME {&FRAME-NAME} c-dt-ini
                              AND      docum-est.dt-trans    <= INPUT FRAME {&FRAME-NAME} c-dt-fim
                              AND      docum-est.nat-operacao = trim(ENTRY(i, INPUT FRAME {&FRAME-NAME} c-natureza)),
        EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
                                  AND   item-doc-est.nro-docto    = docum-est.nro-docto
                                  AND   item-doc-est.serie-docto  = docum-est.serie-docto
                                  :

        RUN pi-acompanhar IN h-prog (INPUT "Nat.Op " + docum-est.nat-operacao + " Dt.Emiss " + string(docum-est.dt-trans)).

             FIND FIRST it-doc-fisc NO-LOCK WHERE it-doc-fisc.cod-estabel = docum-est.cod-estabel
                                            AND   it-doc-fisc.serie       = docum-est.serie-docto
                                            AND   it-doc-fisc.cod-emitente = docum-est.cod-emitente
                                            AND   it-doc-fisc.it-codigo    = item-doc-est.it-codigo
                                            AND   it-doc-fisc.nr-doc-fis  = docum-est.nro-docto
                                            AND   it-doc-fisc.cd-trib-ipi <> 3
                                            AND   it-doc-fisc.vl-ipiou-it = 0
                                            NO-ERROR.

             IF AVAIL it-doc-fisc THEN DO:
                 
             

             CREATE TT-NOTAS.
             ASSIGN TT-NOTAS.TTV-IT-CODIGO   = it-doc-fisc.it-codigo
                    TT-NOTAS.TTV-NOTA-FISCAL = it-doc-fisc.nr-doc-fis
                    TT-NOTAS.TTV-SERIE       = it-doc-fisc.serie
                    TT-NOTAS.TTV-NAT-OPER    = it-doc-fisc.nat-operacao
                    TT-NOTAS.TTV-EMITENTE    = it-doc-fisc.cod-emitente
                    TT-NOTAS.TTV-DT-EMISS    = it-doc-fisc.dt-emis-doc
                    tt-notas.ttv-estab       = it-doc-fisc.cod-estabel
                    tt-notas.ttv-selecionado = YES
                 .


       END.
   END.
END.
RUN PI-FINALIZAR IN H-PROG.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-notas"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

