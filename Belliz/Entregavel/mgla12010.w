&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i MGLA12010 1.00.00.000}

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
DEFINE var l-logical AS LOGICAL.
DEFINE VAR nivel-usuar AS char.
DEFINE NEW GLOBAL SHARED VAR l-chato AS LOGICAL.
DEFINE INPUT PARAM p-demonst AS CHAR.
DEFINE INPUT PARAM p-coluna  AS CHAR.
DEFINE INPUT PARAM p-usuario AS CHAR.
DEFINE INPUT PARAM p-data    AS DATE.
DEFINE INPUT PARAM p-periodo AS INTEGER.
DEFINE INPUT PARAM p-exercicio AS INTEGER.
DEFINE INPUT PARAM p-rubrica  AS CHAR.
DEFINE INPUT PARAM p-entidade AS CHAR.
DEFINE INPUT PARAM p-estouro AS DEC FORMAT "->>>,>>>,>>>,>>>.99".
DEFINE INPUT param p-reais   AS DEC FORMAT "->>>,>>>,>>>,>>>.99".

DEFINE TEMP-TABLE TT-RECEITAS
    FIELD NOMES AS CHAR.

DEF VAR v-vlr-minimo AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-ok bt-cancelar-2 bt-cancelar bt-ajuda ~
RECT-1 RECT-14 RECT-15 RECT-16 
&Scoped-Define DISPLAYED-OBJECTS c-demonst c-coluna d-data-criacao ~
d-dt-altera c-periodo c-rubrica c-entidade c-exercicio desvio c-usuario ~
EDITOR-1 desvio-2 

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

DEFINE BUTTON bt-cancelar-2 AUTO-END-KEY 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Inclui" 
     SIZE 10 BY 1.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 96.29 BY 9.67 NO-UNDO.

DEFINE VARIABLE c-coluna AS CHARACTER FORMAT "X(256)":U 
     LABEL "Padr.Coluna" 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-demonst AS CHARACTER FORMAT "X(256)":U 
     LABEL "Demonstrativo" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-entidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "C.Custo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-exercicio AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Ano" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-rubrica AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-criacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Criacao" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-altera AS DATE FORMAT "99/99/9999":U 
     LABEL "Ult.Altera" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE desvio AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "% Estouro" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE desvio-2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "R$" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 102 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102.72 BY 1.67.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 8.25.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102.43 BY 10.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-demonst AT ROW 1.25 COL 15 COLON-ALIGNED WIDGET-ID 10
     c-coluna AT ROW 1.21 COL 52 COLON-ALIGNED WIDGET-ID 20
     d-data-criacao AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 18
     d-dt-altera AT ROW 3 COL 44.29 WIDGET-ID 4
     c-periodo AT ROW 4.42 COL 15.14 COLON-ALIGNED WIDGET-ID 16
     c-rubrica AT ROW 4.92 COL 51.86 COLON-ALIGNED WIDGET-ID 14
     c-entidade AT ROW 5 COL 77.29 COLON-ALIGNED WIDGET-ID 12
     c-exercicio AT ROW 5.92 COL 15.29 COLON-ALIGNED WIDGET-ID 6
     desvio AT ROW 7.67 COL 51.57 COLON-ALIGNED WIDGET-ID 8
     c-usuario AT ROW 7.58 COL 15.29 COLON-ALIGNED WIDGET-ID 22
     EDITOR-1 AT ROW 11.08 COL 4.14 NO-LABEL WIDGET-ID 2
     bt-ok AT ROW 21.38 COL 2
     bt-cancelar-2 AT ROW 21.38 COL 15 WIDGET-ID 32
     bt-cancelar AT ROW 21.38 COL 30.14
     bt-ajuda AT ROW 21.38 COL 92.29
     desvio-2 AT ROW 7.63 COL 77.29 COLON-ALIGNED WIDGET-ID 34
     RECT-1 AT ROW 21.17 COL 1.29
     RECT-14 AT ROW 1 COL 1 WIDGET-ID 24
     RECT-15 AT ROW 2.67 COL 1.29 WIDGET-ID 26
     RECT-16 AT ROW 10.92 COL 1.29 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.72 BY 21.71 WIDGET-ID 100.


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
         TITLE              = "Justificativa Orcamentaria"
         HEIGHT             = 21.92
         WIDTH              = 102.72
         MAX-HEIGHT         = 21.92
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.92
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-coluna IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-demonst IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-entidade IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-exercicio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-rubrica IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-data-criacao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-dt-altera IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN desvio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desvio-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Justificativa Orcamentaria */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Justificativa Orcamentaria */
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


&Scoped-define SELF-NAME bt-cancelar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar-2 w-window
ON CHOOSE OF bt-cancelar-2 IN FRAME F-Main /* Salvar */
DO:


    FIND FIRST ext_justificativa     WHERE ext_justificativa.Rubrica = p-rubrica
                                     AND   ext_justificativa.Entidade = (IF p-coluna = "Pacotes" THEN p-demonst ELSE p-entidade)
                                     AND   ext_justificativa.Periodo  = p-periodo       
                                     AND   ext_justificativa.Ano      = p-exercicio
                                     AND   ext_justificativa.Cod_demonst = p-demonst            
                                     AND   ext_justificativa.Cod_padr_col = p-coluna                
                                     AND   ext_justificativa.log_justif   = YES NO-ERROR.

IF NOT AVAIL ext_justificativa THEN DO:

    CREATE ext_justificativa.
    ASSIGN ext_justificativa.Cod_demonst =  INPUT frame f-main c-demonst 
          ext_justificativa.Cod_padr_col =  input frame f-main c-coluna          
          ext_justificativa.dt_justifi   =  input frame f-main d-data-criacao    
          ext_justificativa.dt_ult_altera = input frame f-main d-dt-altera       
          ext_justificativa.Periodo       = input frame f-main c-periodo         
          ext_justificativa.Ano           = input frame f-main c-exercicio       
          ext_justificativa.Rubrica       = input frame f-main c-rubrica         
          ext_justificativa.Entidade      = input frame f-main c-entidade        
          ext_justificativa.percentual    = input frame f-main desvio            
          ext_justificativa.cod_usuario   = input frame f-main c-usuario         
          ext_justificativa.observacao    = input frame f-main editor-1
          ext_justificativa.log_justif    = YES.

END.

IF AVAIL ext_justificativa THEN DO:


  ASSIGN ext_justificativa.Cod_demonst =  INPUT frame f-main c-demonst 
        ext_justificativa.Cod_padr_col =  input frame f-main c-coluna          
        ext_justificativa.dt_justifi   =  input frame f-main d-data-criacao    
        ext_justificativa.dt_ult_altera = input frame f-main d-dt-altera       
        ext_justificativa.Periodo       = input frame f-main c-periodo         
        ext_justificativa.Ano           = input frame f-main c-exercicio       
        ext_justificativa.Rubrica       = input frame f-main c-rubrica         
        ext_justificativa.Entidade      = input frame f-main c-entidade        
        ext_justificativa.percentual    = input frame f-main desvio            
        ext_justificativa.cod_usuario   = input frame f-main c-usuario         
        ext_justificativa.observacao    = input frame f-main editor-1
        ext_justificativa.log_justif    = YES.


END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* Inclui */
DO:
  
    ASSIGN editor-1:SENSITIVE = YES
           bt-ok:SENSITIVE = NO
           bt-cancelar:SENSITIVE = YES.




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
  DISPLAY c-demonst c-coluna d-data-criacao d-dt-altera c-periodo c-rubrica 
          c-entidade c-exercicio desvio c-usuario EDITOR-1 desvio-2 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE bt-ok bt-cancelar-2 bt-cancelar bt-ajuda RECT-1 RECT-14 RECT-15 
         RECT-16 
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
  
  {utp/ut9000.i "MGLA12010" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "RECEITA MERCADO EXTERNO".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "PMVA NATURAL ME".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "PMVA PRIMED ME".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "DEVOLUCOES ME".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "RECEITA MERCADO INTERNO".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "RECEITA MERCADO EXTERNO".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "PMVA NATURAL MI".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "PMVA PRIMED MI".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "BIOMASSA".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "MADEIRA BRUTA".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "DESCLASSIFICADO".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "MADEIRA BRUTA".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "TORAS".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "OUTROS ITENS NAO ORCADOS".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "DEVOLUCOES MI".
  CREATE tt-receitas.
  ASSIGN tt-receitas.nome = "RECEITAS TOTAL".
  
  FIND FIRST usuar_niv_usuar NO-LOCK WHERE usuar_niv_usuar.cod_usuar = p-usuario NO-ERROR.

  IF NOT AVAIL usuar_niv_usuar THEN DO:
      MESSAGE "Usu rio nao efetua justificativas. Favor contatar setor de controladoria"
          VIEW-AS ALERT-BOX.

      ASSIGN bt-ok:SENSITIVE = NO
             bt-cancelar-2:SENSITIVE = NO.
      RETURN.

  END.

 IF AVAIL usuar_niv_usuar THEN DO:

     IF p-coluna = "Pacotes" THEN
     ASSIGN nivel-usuar = "Pacote".
     ELSE
     ASSIGN nivel-usuar = usuar_niv_usuar.cod_niv_usuar.
 END.

  RUN PI_VALIDACAO.


  FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Rubrica = p-rubrica
                                       AND   ext_justificativa.Entidade = (IF p-coluna = "Pacotes" THEN p-demonst ELSE p-entidade)
                                       AND   ext_justificativa.Periodo  = p-periodo       
                                       AND   ext_justificativa.Ano      = p-exercicio
                                       AND   ext_justificativa.Cod_demonst = p-demonst            
                                       AND   ext_justificativa.Cod_padr_col = p-coluna                
                                       AND   ext_justificativa.log_justif   = YES NO-ERROR.

  IF NOT AVAIL ext_justificativa THEN DO:

      ASSIGN c-demonst:SCREEN-VALUE IN FRAME f-main = p-demonst
             c-coluna:SCREEN-VALUE IN FRAME f-main  = p-coluna
             d-data-criacao:SCREEN-VALUE IN FRAME f-main = string(date(TODAY))
             d-dt-altera:SCREEN-VALUE IN FRAME f-main    = string(date(TODAY))
             c-periodo:SCREEN-VALUE IN FRAME f-main      = string(p-periodo)
             c-exercicio:SCREEN-VALUE IN FRAME f-main    = string(p-exercicio)
             c-rubrica:SCREEN-VALUE IN FRAME f-main      = p-rubrica 
             c-entidade:SCREEN-VALUE IN FRAME f-main     = IF p-coluna = "Pacotes" THEN p-demonst ELSE p-entidade
             desvio:SCREEN-VALUE IN FRAME f-main         = string(p-estouro)
             desvio-2:SCREEN-VALUE IN FRAME f-main       = string(p-reais)
             c-usuario:SCREEN-VALUE IN FRAME f-main      = p-usuario.

  END.

IF AVAIL ext_justificativa THEN DO:
    
    ASSIGN bt-ok:LABEL = "Alterar".
    ASSIGN c-demonst:SCREEN-VALUE IN FRAME f-main = ext_justificativa.Cod_demonst
           c-coluna:SCREEN-VALUE IN FRAME f-main  = ext_justificativa.Cod_padr_col
           d-data-criacao:SCREEN-VALUE IN FRAME f-main = string(date(ext_justificativa.dt_justifi))
           d-dt-altera:SCREEN-VALUE IN FRAME f-main    = string(date(TODAY))
           c-periodo:SCREEN-VALUE IN FRAME f-main      = string(ext_justificativa.Periodo)
           c-exercicio:SCREEN-VALUE IN FRAME f-main    = string(ext_justificativa.Ano)
           c-rubrica:SCREEN-VALUE IN FRAME f-main      = ext_justificativa.Rubrica 
           c-entidade:SCREEN-VALUE IN FRAME f-main     = ext_justificativa.Entidade
           desvio:SCREEN-VALUE IN FRAME f-main         = string(ext_justificativa.percentual)
           c-usuario:SCREEN-VALUE IN FRAME f-main      = p-usuario
           desvio-2:SCREEN-VALUE IN FRAME f-main       = string(p-reais)
           EDITOR-1:SCREEN-VALUE IN FRAME F-MAIN       = ext_justificativa.observacao.
ASSIGN BT-OK:LABEL = "Editar".

END.

IF l-chato = YES THEN

    ASSIGN bt-ok:SENSITIVE = NO
           bt-cancelar-2:SENSITIVE = NO.

ELSE ASSIGN
           bt-ok:SENSITIVE = YES
           bt-cancelar-2:SENSITIVE = YES.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_validacao w-window 
PROCEDURE pi_validacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF p-estouro = ? THEN

    ASSIGN l-chato = NO.


FIND FIRST ext_lim_justif NO-LOCK WHERE ext_lim_justif.cod_exercicio = p-exercicio
                               AND   ext_lim_justif.num_periodo_ctbl = p-periodo
                               AND   ext_lim_justif.cod_niv_usuario   = nivel-usuar
                               NO-ERROR.

IF NOT AVAIL ext_lim_justif THEN  do:
    
    MESSAGE "Periodo para justificativa nao cadastrado" SKIP "Favor verificar programa MGLA1201" VIEW-AS ALERT-BOX ERROR.

    ASSIGN l-chato = YES.
    RETURN.

END.
 ASSIGN v-vlr-minimo = ext_lim_justif.valor_minimo.

  FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = p-coluna 
                                            AND   ext_exc_justificativas.cod_palavra     = p-rubrica NO-ERROR.

  IF AVAIL ext_exc_justificativas THEN DO:
      
      MESSAGE "Pelas regras, voce NAO DEVE justificar este item" VIEW-AS ALERT-BOX BUTTONS OK UPDATE l-logical.

          ASSIGN l-chato = YES.

    RETURN.

     END.



     FIND FIRST tt-receitas WHERE tt-receitas.nomes = trim(p-rubrica) NO-ERROR.

     IF AVAIL tt-receitas THEN DO:
         
       
         FIND FIRST ext_lim_justif NO-LOCK WHERE ext_lim_justif.cod_exercicio = p-exercicio
                                       AND   ext_lim_justif.num_periodo_ctbl = p-periodo
                                       AND   ext_lim_justif.cod_niv_usuario   = nivel-usuar
                                       NO-ERROR.

     IF (100 - ext_lim_justif.var_perc_positiva) <= (p-estouro)
         
          THEN DO:
 

         MESSAGE "Pelas regras, voce NAO PRECISA justificar este item" VIEW-AS ALERT-BOX BUTTONS OK UPDATE l-logical.

             ASSIGN l-chato = YES.

       RETURN.

     END.
     ASSIGN l-chato = NO.
     RETURN.
     END.

  

  
     FIND FIRST ext_lim_justif NO-LOCK WHERE ext_lim_justif.cod_exercicio = p-exercicio
                                   AND   ext_lim_justif.num_periodo_ctbl = p-periodo
                                   AND   ext_lim_justif.cod_niv_usuario   = nivel-usuar
                                   NO-ERROR.
  IF (ext_lim_justif.var_perc_positiva >= (p-estouro - 100)
  OR  ext_lim_justif.val_perc_negativa >= (p-estouro - 100))
       THEN DO:
      IF  p-reais <= v-vlr-minimo THEN DO:
                
      
      MESSAGE "Pelas regras, voce NAO PRECISA justificar este item" VIEW-AS ALERT-BOX BUTTONS OK UPDATE l-logical.

          ASSIGN l-chato = YES.

    RETURN.

     END.
  END.



 FIND FIRST ext_lim_justif NO-LOCK WHERE ext_lim_justif.cod_exercicio = p-exercicio
                               AND   ext_lim_justif.num_periodo_ctbl = p-periodo
                               AND   ext_lim_justif.cod_niv_usuario   = nivel-usuar
                               NO-ERROR.

 IF AVAIL EXT_lim_justif THEN DO:
     
     IF (DATETIME(TODAY, MTIME) > ext_lim_justif.dat_lim_justif   
     OR DATETIME(TODAY, MTIME) <  ext_lim_justif.dat_inicio_justif)  THEN DO:
         
     
         MESSAGE "O periodo atual nao esta habilitado para justificativas" VIEW-AS ALERT-BOX.
          ASSIGN l-chato = YES.


          RETURN.      
    END.
    ASSIGN l-chato = NO.

END.

 IF NOT AVAIL ext_lim_justif THEN DO:

     MESSAGE "Nao foram cadastrados parametros para justificar" VIEW-AS ALERT-BOX.
     ASSIGN l-chato = YES.


     RETURN.      
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

