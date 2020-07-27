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
{include/i-prgvrs.i ESRE001 1.00.00.001}

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

DEFINE INPUT PARAM v_recid AS ROWID.

DEF VAR pasta-entrada AS CHAR FORMAT "x(240)".
DEF VAR pasta-saida   AS CHAR FORMAT "x(240)".
DEF VAR l-entrada     AS LOGICAL.
DEF VAR l-saida       AS LOGICAL.
DEF VAR l-linha AS recid.


def var l-ok               as logical no-undo.
def new global shared var v_cod_usuar_corren as character
    format "x(12)"
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.


DEFINE TEMP-TABLE tt-ext-ordem-compra LIKE ext-ordem-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ext-ordem-compra

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-ext-ordem-compra.local tt-ext-ordem-compra.nr-requisicao tt-ext-ordem-compra.nr-ordem tt-ext-ordem-compra.nr-pedido tt-ext-ordem-compra.cod-emitente tt-ext-ordem-compra.cod-usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-ext-ordem-compra INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-ordem-compra INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-ext-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-ext-ordem-compra


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-11 RECT-12 BROWSE-2 ~
c-arquivo-entrada bt-dir-entrada BUTTON-1 BUTTON-2 bt-ok bt-cancelar ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-arquivo-entrada 

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

DEFINE BUTTON bt-dir-entrada 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-1 
     LABEL "Salvar" 
     SIZE 16.29 BY 1.

DEFINE BUTTON BUTTON-2 
     LABEL "Excluir" 
     SIZE 16.29 BY 1.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 4.17.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 6.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-ext-ordem-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-window _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-ext-ordem-compra.local
                tt-ext-ordem-compra.nr-requisicao
                tt-ext-ordem-compra.nr-ordem
                tt-ext-ordem-compra.nr-pedido
                tt-ext-ordem-compra.cod-emitente
                tt-ext-ordem-compra.cod-usuar
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 71.72 BY 5.5
         FGCOLOR 9  FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.33 COL 4.43 WIDGET-ID 200
     c-arquivo-entrada AT ROW 8.08 COL 16.72 COLON-ALIGNED WIDGET-ID 20
     bt-dir-entrada AT ROW 8.08 COL 53.86 HELP
          "Escolha do nome do arquivo" WIDGET-ID 24
     BUTTON-1 AT ROW 9.83 COL 21.43 WIDGET-ID 30
     BUTTON-2 AT ROW 9.83 COL 37.86 WIDGET-ID 32
     bt-ok AT ROW 12.21 COL 3
     bt-cancelar AT ROW 12.21 COL 14
     bt-ajuda AT ROW 12.21 COL 69
     RECT-1 AT ROW 12 COL 2
     RECT-11 AT ROW 7.33 COL 1.86 WIDGET-ID 26
     RECT-12 AT ROW 1.08 COL 1.57 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58 WIDGET-ID 100.


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
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 12.67
         WIDTH              = 80
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 RECT-12 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-ordem-compra INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 w-window
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
  ASSIGN l-linha = recid(tt-ext-ordem-compra).

  FIND FIRST tt-ext-ordem-compra NO-LOCK WHERE recid(tt-ext-ordem-compra) = l-linha NO-ERROR.

  IF AVAIL tt-ext-ordem-compra THEN DO:
      

      OS-COMMAND SILENT VALUE("start " + tt-ext-ordem-compra.Local).

  END.


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


&Scoped-define SELF-NAME bt-dir-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-entrada w-window
ON CHOOSE OF bt-dir-entrada IN FRAME F-Main
DO:
 
 {include/i-imarq.i c-arquivo-entrada f-main "'*.*' '*.*'"}
                          
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    RUN pi-efetivar.
    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 w-window
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Salvar */
DO:
  
    FIND FIRST ordem-compra  WHERE ROWID(ordem-compra) = v_recid NO-ERROR.

IF AVAIL ordem-compra THEN DO:


    FIND FIRST tt-ext-ordem-compra NO-LOCK WHERE tt-ext-ordem-compra.nr-requisicao = ordem-compra.nr-requisicao
                                        AND      tt-ext-ordem-compra.nr-ordem      = ordem-compra.numero-ordem
                                        AND      tt-ext-ordem-compra.nr-pedido     = ordem-compra.num-pedido
                                        AND      tt-ext-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
                                        AND      tt-ext-ordem-compra.local         = INPUT FRAME f-main c-arquivo-entrada NO-ERROR.

    IF NOT AVAIL tt-ext-ordem-compra THEN DO:
        

            
        

        CREATE tt-ext-ordem-compra.
        ASSIGN tt-ext-ordem-compra.Local = INPUT FRAME f-main c-arquivo-entrada
               tt-ext-ordem-compra.nr-requisicao  = ordem-compra.nr-requisicao
               tt-ext-ordem-compra.nr-ordem       = ordem-compra.numero-ordem
               tt-ext-ordem-compra.nr-pedido      = ordem-compra.num-pedido
               tt-ext-ordem-compra.cod-emitente   = ordem-compra.cod-emitente
               tt-ext-ordem-compra.cod-usuar      = v_cod_usuar_corren
.
            {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
    END.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-window
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Excluir */
DO:
    ASSIGN l-linha = recid(tt-ext-ordem-compra).

    FOR EACH tt-ext-ordem-compra WHERE recid(tt-ext-ordem-compra) = l-linha:

        FOR EACH ext-ordem-compra WHERE ext-ordem-compra.local         = tt-ext-ordem-compra.local
                                  AND   ext-ordem-compra.nr-requisicao  = tt-ext-ordem-compra.nr-requisicao
                                  AND   ext-ordem-compra.nr-ordem       = tt-ext-ordem-compra.nr-ordem
                                  AND   ext-ordem-compra.nr-pedido      = tt-ext-ordem-compra.nr-pedido
                                  AND   ext-ordem-compra.cod-emitente   = tt-ext-ordem-compra.cod-emitente
                                  AND   ext-ordem-compra.cod-usuar      = tt-ext-ordem-compra.cod-usuar:
                        DELETE ext-ordem-compra.
        END.

        DELETE tt-ext-ordem-compra.
    END.

    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-window
ON MOUSE-SELECT-DBLCLICK OF BUTTON-2 IN FRAME F-Main /* Excluir */
DO:
    ASSIGN l-linha = recid(ext-ordem-compra).

    FIND FIRST ext-ordem-compra NO-LOCK WHERE recid(ext-ordem-compra) = l-linha NO-ERROR.

    IF AVAIL ext-ordem-compra THEN DO:
        

        OS-COMMAND SILENT VALUE("start " + ext-ordem-compra.Local).

    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY c-arquivo-entrada 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-11 RECT-12 BROWSE-2 c-arquivo-entrada bt-dir-entrada 
         BUTTON-1 BUTTON-2 bt-ok bt-cancelar bt-ajuda 
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
  
  {utp/ut9000.i "ESRE001" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FIND FIRST ordem-compra NO-LOCK WHERE ROWID(ordem-compra) = v_recid NO-ERROR.

  IF AVAIL ordem-compra THEN DO:
      
      FOR EACH ext-ordem-compra NO-LOCK WHERE ext-ordem-compra.nr-ordem     = ordem-compra.numero-ordem
                                        AND   ext-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
                                        :
          
          CREATE tt-ext-ordem-compra.
          ASSIGN tt-ext-ordem-compra.nr-requisicao = ext-ordem-compra.nr-requisicao
                 tt-ext-ordem-compra.nr-ordem      = ext-ordem-compra.nr-ordem
                 tt-ext-ordem-compra.nr-pedido     = ext-ordem-compra.nr-pedido
                 tt-ext-ordem-compra.cod-emitente  = ext-ordem-compra.cod-emitente
                 tt-ext-ordem-compra.cod-usuar     = ext-ordem-compra.cod-usuar
                 tt-ext-ordem-compra.local         = ext-ordem-compra.local.
                 

  END.
 
END.

/*   FIND FIRST ordem-compra NO-LOCK WHERE ROWID(ordem-compra) = v_recid NO-ERROR.                   */
/*                                                                                                   */
/*   FOR EACH ext-requisicao NO-LOCK WHERE ext-requisicao.nr-requisicao = ordem-compra.nr-requisicao */
/*                                  :                                                                */
/*                                                                                                   */
/*                                                                                                   */
/*          CREATE tt-ext-ordem-compra.                                                              */
/*          ASSIGN tt-ext-ordem-compra.nr-requisicao        = ext-requisicao.nr-requisicao           */
/*                 tt-ext-ordem-compra.cod-usuar            = ext-requisicao.cod-usuar               */
/*                 tt-ext-ordem-compra.local                = ext-requisicao.local.                  */
/*                                                                                                   */
/*   END.                                                                                            */
/*                                                                                                   */

 {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

     END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetivar w-window 
PROCEDURE pi-efetivar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-ext-ordem-compra NO-LOCK:

    FIND FIRST ext-ordem-compra NO-LOCK WHERE ext-ordem-compra.nr-ordem  = tt-ext-ordem-compra.nr-ordem
                                        AND   ext-ordem-compra.local     = tt-ext-ordem-compra.local
                                        AND   ext-ordem-compra.cod-usuar = tt-ext-ordem-compra.cod-usuar NO-ERROR.
            
        
        IF NOT AVAIL ext-ordem-compra THEN DO:
        
        CREATE ext-ordem-compra.
        ASSIGN ext-ordem-compra.nr-ordem          =     tt-ext-ordem-compra.nr-ordem  
               ext-ordem-compra.local             =     tt-ext-ordem-compra.local     
               ext-ordem-compra.cod-usuar         =     tt-ext-ordem-compra.cod-usuar 
               ext-ordem-compra.nr-requisicao     =     tt-ext-ordem-compra.nr-requisicao
               ext-ordem-compra.nr-pedido         =     tt-ext-ordem-compra.nr-pedido
               ext-ordem-compra.cod-emitente      =     tt-ext-ordem-compra.cod-emitente.


               
               
               
                
            
            END.

END.



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
  {src/adm/template/snd-list.i "tt-ext-ordem-compra"}

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

