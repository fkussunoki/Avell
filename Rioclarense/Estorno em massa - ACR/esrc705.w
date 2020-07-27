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
{include/i-prgvrs.i ESRC715 1.00.00.000}

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

DEFINE TEMP-TABLE tt_tit_Acr
    FIELD cod_empresa                  AS char
    FIELD cod_estab                    AS char
    FIELD cod_espec_docto              AS char
    FIELD cod_ser_docto                AS char
    FIELD cod_tit_acr                  AS char
    FIELD cod_parcela                  AS char
    FIELD cdn_cliente                  AS INTEGER
    FIELD nom_abrev                    AS char
    FIELD cod_refer                    AS char
    FIELD ind_trans_acr_abrev          AS char
    FIELD dat_transacao                AS date
    FIELD val_movto_tit_acr            AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99"
    FIELD num_id_movto                 AS char
    FIELD num_id_tit_acr               AS char
    FIELD v_selecionado                AS LOGICAL INITIAL NO.



def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .



def var v_num_cont AS INTEGER.
DEF VAR v_referencia AS char.
DEF VAR v_estab      AS char.
DEF VAR v_new_ref    AS char.

DEF VAR v_cod_portador AS CHAR.
DEF VAR v_cod_carteira AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_tit_acr

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt_tit_acr.cod_empresa tt_tit_acr.cod_estab tt_tit_acr.cod_espec_docto tt_tit_acr.cod_ser_docto tt_tit_acr.cod_tit_acr tt_tit_acr.cod_parcela tt_tit_acr.cdn_cliente tt_tit_acr.nom_abrev tt_tit_acr.cod_refer tt_tit_acr.ind_trans_acr_abrev tt_tit_acr.dat_transacao tt_tit_acr.val_movto_tit_acr tt_tit_acr.num_id_movto tt_tit_acr.num_id_tit_acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt_tit_acr
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt_tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt_tit_acr


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-estab c-ref BUTTON-2 c_cod_portador ~
c_cod_carteira BUTTON-11 bt-ok bt-cancelar bt-ajuda RECT-1 RECT-17 RECT-30 ~
RECT-31 BROWSE-3 RECT-32 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab c-ref c_cod_portador ~
c_cod_carteira 

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
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "IMAGE/im-clr1.bmp":U
     LABEL "Estornar" 
     SIZE 15 BY 1.75.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMAGE/im-check4.bmp":U
     LABEL "Ok" 
     SIZE 8 BY 1.13.

DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencia" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod_carteira AS CHARACTER FORMAT "X(256)":U 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod_portador AS CHARACTER FORMAT "x(40)":U 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 116 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 19.42.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.86 BY 4.5.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.14 BY 4.5.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.57 BY 12.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt_tit_acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 w-window _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt_tit_acr.cod_empresa            
tt_tit_acr.cod_estab              
tt_tit_acr.cod_espec_docto        
tt_tit_acr.cod_ser_docto          
tt_tit_acr.cod_tit_acr            
tt_tit_acr.cod_parcela            
tt_tit_acr.cdn_cliente            
tt_tit_acr.nom_abrev              
tt_tit_acr.cod_refer              
tt_tit_acr.ind_trans_acr_abrev    
tt_tit_acr.dat_transacao          
tt_tit_acr.val_movto_tit_acr      
tt_tit_acr.num_id_movto           
tt_tit_acr.num_id_tit_acr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 103.43 BY 10.67 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-cod-estab AT ROW 2.42 COL 20 COLON-ALIGNED WIDGET-ID 14
     c-ref AT ROW 3.63 COL 20.14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 3.54 COL 36.43 WIDGET-ID 8
     c_cod_portador AT ROW 2.5 COL 62.72 COLON-ALIGNED WIDGET-ID 12
     c_cod_carteira AT ROW 3.75 COL 62.72 COLON-ALIGNED WIDGET-ID 22
     BUTTON-11 AT ROW 2.54 COL 82 WIDGET-ID 10
     bt-ok AT ROW 20.79 COL 2
     bt-cancelar AT ROW 20.79 COL 13
     bt-ajuda AT ROW 20.79 COL 106.29
     BROWSE-3 AT ROW 7.13 COL 9 WIDGET-ID 200
     "Selecione os Titulos" VIEW-AS TEXT
          SIZE 24 BY .67 AT ROW 6.21 COL 5.29 WIDGET-ID 28
     "Dados Portador" VIEW-AS TEXT
          SIZE 17.43 BY .67 AT ROW 1.29 COL 53 WIDGET-ID 24
     "Dados do Lote" VIEW-AS TEXT
          SIZE 16.57 BY .67 AT ROW 1.33 COL 10.43 WIDGET-ID 18
     RECT-1 AT ROW 20.58 COL 1
     RECT-17 AT ROW 1.13 COL 1.57 WIDGET-ID 6
     RECT-30 AT ROW 1.42 COL 9.14 WIDGET-ID 16
     RECT-31 AT ROW 1.42 COL 51.57 WIDGET-ID 20
     RECT-32 AT ROW 6.5 COL 3.57 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.86 BY 21.63 WIDGET-ID 100.


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
         TITLE              = "Estorno de Titulos em massa"
         HEIGHT             = 21.63
         WIDTH              = 116.86
         MAX-HEIGHT         = 21.63
         MAX-WIDTH          = 116.86
         VIRTUAL-HEIGHT     = 21.63
         VIRTUAL-WIDTH      = 116.86
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
/* BROWSE-TAB BROWSE-3 RECT-31 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Estorno de Titulos em massa */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Estorno de Titulos em massa */
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
ON CHOOSE OF bt-ok IN FRAME F-Main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 w-window
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Estornar */
DO:
  
 DEF VAR i AS INT NO-UNDO.
 DEF VAR n AS INT NO-UNDO.
 DEF VAR nb AS INT NO-UNDO.
 DEF VAR l-logico AS LOGICAL.

 ASSIGN v_cod_portador = INPUT FRAME {&FRAME-NAME} c_cod_portador.
 ASSIGN v_cod_carteira = INPUT FRAME {&FRAME-NAME} c_cod_carteira.




 nb = browse-3:NUM-SELECTED-ROWS.


 IF nb <> 0 THEN 
     
     DO i = 1 TO nb:
     

     IF browse-3:FETCH-SELECTED-ROW(i) THEN

         ASSIGN tt_tit_acr.v_selecionado = YES
                tt_tit_acr.cod_refer     = v_new_ref.

 END.

 FIND FIRST tt_tit_acr WHERE  tt_tit_acr.v_selecionado = YES NO-ERROR.

 IF NOT AVAIL tt_tit_acr THEN DO:
     
     MESSAGE "Nenhum titulo selecionado" VIEW-AS ALERT-BOX.
     RETURN.

 END.

 ELSE DO:
     
  MESSAGE "Deseja alterar o portador " + v_referencia " ?" VIEW-AS ALERT-BOX
      BUTTONS YES-NO  UPDATE l-logico.


  IF l-logico THEN
      

 RUN pi-estornar(INPUT v_cod_portador,
                 INPUT v_cod_carteira).


  ELSE 
      RETURN.
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-window
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Ok */
DO:

    ASSIGN v_referencia = INPUT FRAME {&FRAME-NAME} c-ref.
    ASSIGN v_estab      = INPUT FRAME {&FRAME-NAME} c-cod-estab.

    IF v_referencia = "" THEN DO:
        
    
        MESSAGE "Uma referencia ‚ necessaria" VIEW-AS ALERT-BOX.
    RETURN.

    END.

    IF NOT CAN-FIND(FIRST movto_tit_acr WHERE movto_tit_acr.cod_refer = trim(v_referencia) 
                                        AND   movto_tit_acr.cod_estab = trim(v_estab)) THEN DO:
        
    
        MESSAGE "A referencia " + v_referencia + " nao ‚ valida" VIEW-AS ALERT-BOX.
    RETURN.
    END.

  RUN pi-titulos(INPUT v_referencia,
                 INPUT v_estab)
                 .


  FIND FIRST tt_tit_Acr.

  OPEN QUERY browse-3 FOR EACH tt_tit_acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  DISPLAY c-cod-estab c-ref c_cod_portador c_cod_carteira 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE c-cod-estab c-ref BUTTON-2 c_cod_portador c_cod_carteira BUTTON-11 
         bt-ok bt-cancelar bt-ajuda RECT-1 RECT-17 RECT-30 RECT-31 BROWSE-3 
         RECT-32 
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
  
  {utp/ut9000.i "ESRC715" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estornar w-window 
PROCEDURE pi-estornar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-cod-portador AS CHAR.
DEF INPUT PARAM p-cod-carteira AS CHAR.


ASSIGN v_num_cont = 1.
FOR EACH tt_tit_acr WHERE tt_tit_acr.v_selecionado = YES:

    for each movto_tit_acr where movto_tit_Acr.num_id_tit_acr        = int(tt_tit_acr.num_id_tit_acr) 
                           AND   movto_tit_acr.num_id_movto_tit_acr  = int(tt_tit_acr.num_id_movto)
                           and   movto_tit_acr.ind_trans_acr_abrev   = "LIQ"
                           and   movto_tit_acr.cod_estab             = tt_tit_acr.cod_estab
                           and   movto_tit_acr.cod_espec_docto       = tt_tit_acr.cod_espec_docto
                           and   movto_tit_acr.dat_trans             = tt_tit_Acr.dat_trans
                           and   movto_tit_Acr.val_movto_tit_acr     = tt_tit_acr.val_movto_tit_Acr:
                        
    run prgfin/acr/acr711zp.py (input 1,
                                input "",
                                buffer movto_tit_acr,
                                input p-cod-portador,
                                input p-cod-carteira,
                                output table tt_log_erros).
                                
    END.
END.


                               find first tt_log_erros no-error.

                               IF AVAIL tt_log_erros THEN DO:
                                                              
    MESSAGE "Erros gravados em " + SESSION:TEMP-DIRECTORY + "/erros.txt".
OUTPUT TO value(SESSION:TEMP-DIRECTORY + "/erros.txt").
    PUT UNFORMATTED tt_log_erros.ttv_num_seq         ";"
                    tt_log_erros.ttv_num_cod_erro     ";"
                    tt_log_erros.ttv_des_erro         ";"
                    tt_log_erros.ttv_des_ajuda                         
        SKIP.
END.



ELSE DO:
    
    MESSAGE "Concluido com sucesso".

    FOR EACH tt_tit_Acr WHERE tt_tit_Acr.v_selecionado = YES:

        DELETE tt_tit_acr.
    END.


    {&OPEN-QUERY-browse-3}
         APPLY 'value-changed' TO browse-3 IN FRAME f-main.

END.
 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-titulos w-window 
PROCEDURE pi-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT param p-referencia AS char.
DEF INPUT param p-estab      AS CHAR.


FOR EACH movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_refer           = p-referencia
                               AND   movto_tit_acr.ind_trans_acr_abrev BEGINS "liq"
                               AND   movto_tit_acr.cod_estab            = p-estab:


    FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_empresa = movto_tit_acr.cod_empresa
                                AND  tit_acr.cod_estab   = movto_tit_acr.cod_estab
                                AND  tit_acr.cod_espec_docto = movto_tit_acr.cod_espec_docto
                                AND  tit_acr.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr NO-ERROR.


    IF AVAIL tit_acr THEN DO:
        
        CREATE tt_tit_Acr.
        ASSIGN tt_tit_acr.cod_empresa                = tit_acr.cod_empresa
               tt_tit_acr.cod_estab                  = tit_acr.cod_estab
               tt_tit_acr.cod_espec_docto            = tit_acr.cod_espec_docto
               tt_tit_acr.cod_ser_docto              = tit_acr.cod_ser_docto
               tt_tit_acr.cod_tit_acr                = tit_acr.cod_tit_acr
               tt_tit_acr.cod_parcela                = tit_acr.cod_parcela
               tt_tit_acr.cdn_cliente                = tit_acr.cdn_cliente
               tt_tit_acr.nom_abrev                  = tit_acr.nom_abrev
               tt_tit_acr.cod_refer                  = ""
               tt_tit_acr.ind_trans_acr_abrev        = movto_tit_acr.ind_trans_acr_abrev
               tt_tit_acr.dat_transacao              = movto_tit_acr.dat_transacao
               tt_tit_acr.val_movto_tit_acr          = movto_tit_acr.val_movto_tit_acr
               tt_tit_acr.num_id_movto               = string(movto_tit_acr.num_id_movto_tit_acr)
               tt_tit_acr.num_id_tit_acr             = string(movto_tit_acr.num_id_tit_acr).

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
  {src/adm/template/snd-list.i "tt_tit_acr"}

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

