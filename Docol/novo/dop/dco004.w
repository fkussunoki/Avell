&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsdocol         PROGRESS
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&global-define programa dco004 /*nome_do_programa  Exemplo: rel_cliente*/

{include/i-prgvrs504.i {&programa} 5.04.01.001}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo           AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.
DEFINE BUFFER b-tt-digita   FOR tt-digita.
                    
/* Local Variable Definitions (Template 2)---                           */
DEF VAR l-ok                AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita        AS CHAR    NO-UNDO.
DEF VAR c-terminal          AS CHAR    NO-UNDO.

/* Local Variable Definitions (Template 5) ---                          */
DEF VAR v_num_ped_exec_rpw  AS INTEGER  NO-UNDO.
DEF VAR i-cont              AS INTEGER  NO-UNDO.
DEF VAR c-impressora        AS CHAR     NO-UNDO.
DEF VAR c-layout            AS CHAR     NO-UNDO.
DEF VAR c-char              AS CHAR     NO-UNDO.
DEF VAR rw-log-exec         AS ROWID    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR c-param-campos      AS CHARACTER    NO-UNDO.
DEF VAR c-param-tipos       AS CHARACTER    NO-UNDO.
DEF VAR c-param-dados       AS CHARACTER    NO-UNDO.

DEF VAR l-valida            AS LOGICAL      NO-UNDO.

DEF NEW SHARED VAR v_des_estab_select       AS CHARACTER        NO-UNDO.
DEF NEW SHARED VAR v_rec_plano_ccusto       AS RECID            NO-UNDO.
DEF NEW SHARED VAR v_rec_ccusto             AS RECID            NO-UNDO.
DEF NEW SHARED VAR v_rec_plano_cta_ctbl     AS RECID            NO-UNDO.
DEF NEW SHARED VAR v_rec_cta_ctbl           AS RECID            NO-UNDO.


{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-50 RECT-7 RECT-9 rs-destino ~
bt-config-impr bt-arquivo c-arquivo rs-execucao l-imp-param 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao ~
l-imp-param text-destino text-modo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-imp-param AS LOGICAL INITIAL no 
     LABEL "Imprime listagem dos parÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE BUTTON bt-select-estabelec 
     IMAGE-UP FILE "Image/im-ran_a.bmp":U
     LABEL "Estabelecimentos" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-select-representante 
     IMAGE-UP FILE "Image/im-ran_a.bmp":U
     LABEL "Representantes" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-zoom-empresa 
     IMAGE-UP FILE "Image/im-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "Image/ii-zoo.bmp":U
     LABEL "Empresa" 
     SIZE 4 BY .88.

DEFINE VARIABLE c-lista-cdn-repres AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 41 BY 1
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-lista-cod-estab AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 41 BY 1
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE c-cod-empresa AS CHARACTER FORMAT "X(15)":U 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c-cod-espec AS CHARACTER FORMAT "X(15)":U INITIAL "DM" 
     LABEL "EspÇcie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE dt-fim-periodo AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Vencimento atÇ" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE i-transacao AS INTEGER FORMAT ">>9":U INITIAL 51 
     LABEL "Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 2 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
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

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-1 AT ROW 14.25 COL 2
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         FONT 4
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     l-imp-param AT ROW 8 COL 4
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-50 AT ROW 7.5 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10
         FONT 4.

DEFINE FRAME f-pg-sel
     c-cod-empresa AT ROW 2.75 COL 18 COLON-ALIGNED
     bt-zoom-empresa AT ROW 2.75 COL 26
     c-lista-cod-estab AT ROW 3.75 COL 20 NO-LABEL
     bt-select-estabelec AT ROW 3.75 COL 61
     c-cod-espec AT ROW 5 COL 18 COLON-ALIGNED
     c-lista-cdn-repres AT ROW 6 COL 20 NO-LABEL
     bt-select-representante AT ROW 6 COL 61
     dt-fim-periodo AT ROW 7.25 COL 18 COLON-ALIGNED
     i-transacao AT ROW 8.25 COL 18 COLON-ALIGNED
     emsdocol.dc-comis-trans.descricao AT ROW 8.25 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
          BGCOLOR 15 
     "Estabelecimento:" VIEW-AS TEXT
          SIZE 11.57 BY .54 AT ROW 4 COL 8
     "Representantes:" VIEW-AS TEXT
          SIZE 11.57 BY .54 AT ROW 6.25 COL 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Estorno de Comiss‰es na Emiss∆o - DCO004"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat504.i}
{utp/ut-glob504.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-espec IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       c-lista-cdn-repres:READ-ONLY IN FRAME f-pg-sel        = TRUE.

ASSIGN 
       c-lista-cod-estab:READ-ONLY IN FRAME f-pg-sel        = TRUE.

/* SETTINGS FOR FILL-IN emsdocol.dc-comis-trans.descricao IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

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
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Estorno de Comiss‰es na Emiss∆o - DCO004 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Estorno de Comiss‰es na Emiss∆o - DCO004 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-select-estabelec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-select-estabelec w-relat
ON CHOOSE OF bt-select-estabelec IN FRAME f-pg-sel /* Estabelecimentos */
DO:
    RUN prgint/utb/utb071za &if "{&bf_mat_versao_ems}" >= "2.062" &then
                                (INPUT v_cod_empres_usuar)                                                                               
                             &endif.
    
    ASSIGN  c-lista-cod-estab = v_des_estab_select.
    DISPLAY c-lista-cod-estab WITH FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-select-representante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-select-representante w-relat
ON CHOOSE OF bt-select-representante IN FRAME f-pg-sel /* Representantes */
DO:
    RUN dop/dco003a.w (INPUT-OUTPUT c-lista-cdn-repres).
    DISPLAY c-lista-cdn-repres WITH FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom-empresa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom-empresa w-relat
ON CHOOSE OF bt-zoom-empresa IN FRAME f-pg-sel /* Empresa */
DO:
    RUN prgint/utb/utb069ka.p.
                         
    IF  v_rec_empresa <> ? THEN DO:
        FIND FIRST emsuni.empresa NO-LOCK
             WHERE RECID(emsuni.empresa) = v_rec_empresa NO-ERROR.
        DISPLAY emsuni.empresa.cod_empresa   @ c-cod-empresa WITH FRAME f-pg-sel.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-empresa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-empresa w-relat
ON F5 OF c-cod-empresa IN FRAME f-pg-sel /* Empresa */
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-empresa w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cod-empresa IN FRAME f-pg-sel /* Empresa */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-espec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-espec w-relat
ON F5 OF c-cod-espec IN FRAME f-pg-sel /* EspÇcie */
DO:
/*    {include\zoomvar.i &prog-zoom = "xxzoom\z99xx999.w"
                       &campo     = {&self-name}
                       &campozoom = "codigo"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-espec w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cod-espec IN FRAME f-pg-sel /* EspÇcie */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-fim-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-fim-periodo w-relat
ON MOUSE-SELECT-DBLCLICK OF dt-fim-periodo IN FRAME f-pg-sel /* Vencimento atÇ */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-transacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-transacao w-relat
ON MOUSE-SELECT-DBLCLICK OF i-transacao IN FRAME f-pg-sel /* Transaá∆o */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000504.i "{&programa}" "5.04.01.001"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini504.i}
ASSIGN  c-arq-old = SESSION:TEMP-DIRECTORY + "{&programa}.tmp".

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl504.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
  
    {include/i-rpmbl504.i}

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = v_cod_usuar_corren  NO-ERROR. 

    RUN pi-recupera-param.

    FIND FIRST dc-comis-trans NO-LOCK
         WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.
    DISP dc-comis-trans.descricao WHEN AVAIL dc-comis-trans WITH FRAME f-pg-sel.
    ASSIGN dt-fim-periodo:SCREEN-VALUE IN FRAME f-pg-sel = string(TODAY - DAY(TODAY)).

    /* sen∆o existe parametros salvos, coloque abaixo os valores initial */
    IF  RETURN-VALUE = 'nok' THEN
        ASSIGN  c-lista-cod-estab:SCREEN-VALUE IN FRAME f-pg-sel = v_cod_estab_usuar.

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-cod-empresa c-lista-cod-estab c-cod-espec c-lista-cdn-repres 
          dt-fim-periodo i-transacao 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  IF AVAILABLE emsdocol.dc-comis-trans THEN 
    DISPLAY emsdocol.dc-comis-trans.descricao 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE c-cod-empresa bt-zoom-empresa c-lista-cod-estab bt-select-estabelec 
         c-lista-cdn-repres bt-select-representante dt-fim-periodo i-transacao 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao l-imp-param text-destino text-modo 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-50 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao l-imp-param 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR l-valida    AS LOGICAL  NO-UNDO.

    /* valida conflitos com os processos agendados no servidor (RPW) */
    {include\i-vld-param504.i}
    
    DO  ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {include/i-rpexa504.i}

        /* Aqui s∆o gravados os campos da tabela que ser† grava e lida dentro 
           do pograma RP.P */
        RUN pi-salva-param.

        ASSIGN  INPUT FRAME f-pg-sel    c-cod-empresa           c-cod-espec
                                        c-lista-cod-estab       c-lista-cdn-repres
                                        dt-fim-periodo          i-transacao.
                                                                   
        /*empresa*/
        FIND FIRST emsuni.unid_organ NO-LOCK 
             WHERE emsuni.unid_organ.cod_unid_organ        = c-cod-empresa
               AND emsuni.unid_organ.cod_tip_unid_organ    = '998' NO-ERROR.
        IF  NOT AVAIL emsuni.unid_organ THEN DO:
            RUN MESSAGE.p ('Unidade Organizacional da Empresa n∆o encontrada.',
                           'N∆o encontrada Unidade Organizacional para a Empresa ' + 
                           c-cod-empresa + '.').
            APPLY "MOUSE-SELECT-CLICK"  TO im-pg-sel     IN FRAME f-relat.
            APPLY "ENTRY"               TO c-cod-empresa IN FRAME f-pg-sel.
            RETURN 'NOK'.
        END.

        IF  emsuni.unid_organ.dat_fim_valid  < TODAY OR 
            emsuni.unid_organ.dat_inic_valid > TODAY THEN DO:
            RUN MESSAGE.p ('Unidade Organizacional com prazo de Validade Vencida.',
                           'A Unidade Organizacional da Empresa ' + c-cod-empresa +
                           ' tem sua validade vencida.').
            APPLY "MOUSE-SELECT-CLICK"  TO im-pg-sel            IN FRAME f-relat.
            APPLY "ENTRY"               TO c-cod-empresa        IN FRAME f-pg-sel.
            RETURN 'NOK'.
        END.


        FIND FIRST dc-comis-trans NO-LOCK
             WHERE dc-comis-trans.cod_transacao = i-transacao NO-ERROR.
        IF NOT AVAIL dc-comis-trans THEN DO:
           RUN MESSAGE.p ('Transaá∆o n∆o cadastrada!',
                           'A transaá∆o de estorno de comiss∆o informada n∆o est† cadastrada').
            APPLY "MOUSE-SELECT-CLICK"  TO im-pg-sel            IN FRAME f-relat.
            APPLY "ENTRY"               TO i-transacao          IN FRAME f-pg-sel.
            RETURN 'NOK'.
        END.

        IF  rs-execucao:SCREEN-VALUE IN FRAME f-pg-imp = "2" THEN DO: /*execuá∆o em batch*/
            RUN prgtec/btb/btb911za.p (INPUT  "{&programa}RP",
                                       INPUT  "1.00.000",
                                       INPUT  0,
                                       INPUT  RECID(dwb_set_list_param),
                                       OUTPUT v_num_ped_exec_rpw).
          
            IF  v_num_ped_exec_rpw <> 0 THEN DO:
                RUN pi-message  (INPUT "show",
                                 INPUT 3556,
                                 INPUT SUBSTITUTE ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       v_num_ped_exec_rpw)).
          
                FIND CURRENT dwb_set_list_param NO-LOCK NO-ERROR.
            END.
        END.
        ELSE DO: /*execuá∆o on-line*/
            IF  SESSION:SET-WAIT-STATE("general") THEN.
                 RUN VALUE("dop/dco004rp.p").
            IF  SESSION:SET-WAIT-STATE("") THEN.
            
            /*abre o editor quando a saida for terminal*/
            {include/i-rptrm504.i}
        END.
    END. /* do transaction */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param w-relat 
PROCEDURE pi-recupera-param :
/*------------------------------------------------------------------------------
  Purpose:     Recuperar os parÉmetros informados pelo usu†rio corrente em 
               sua £ltima execuá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST dwb_set_list_param NO-LOCK
         WHERE dwb_set_list_param.cod_dwb_program = "{&programa}"
           AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
         
    IF  NOT AVAIL dwb_set_list_param THEN RETURN 'nok'.
    
    {include/i-rprcpr504.i}

    ASSIGN  /*pagina de impress∆o*/
            rs-destino              = LOOKUP(dwb_set_list_param.cod_dwb_output,"Impressora,Arquivo,Terminal")
            l-imp-param             = dwb_set_list_param.log_dwb_print_parameters
            c-arquivo               = dwb_set_list_param.cod_dwb_file
            c-impressora            = dwb_set_list_param.nom_dwb_printer
            c-layout                = dwb_set_list_param.cod_dwb_print_layout.
    IF  rs-destino = 1 
        THEN ASSIGN  c-imp-old  = c-impressora + ":" + c-layout.
        ELSE ASSIGN  c-arq-old  = c-arquivo.
    
    /*pagina de digitaá∆o*/
    FIND FIRST dwb_set_list_param_aux EXCLUSIVE-LOCK
         WHERE dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
           AND dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user NO-ERROR.
    IF  AVAIL dwb_set_list_param_aux THEN 
        DO  i-cont = 1 TO NUM-ENTRIES(dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)):
            CREATE  tt-digita.
            ASSIGN  tt-digita.ordem   = INT(ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)))
                    i-cont            = i-cont + 1
                    tt-digita.exemplo = ENTRY(i-cont, dwb_set_list_param_aux.cod_dwb_parameters, CHR(10)).
        END.

    DISPLAY /*pagina de impress∆o*/
            rs-destino      
            l-imp-param     
            c-arquivo       WITH FRAME f-pg-imp.
    
    APPLY "value-changed"       TO rs-destino           IN FRAME f-pg-imp.
    APPLY "mouse-select-click"  TO im-pg-sel            IN FRAME f-relat.
    
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-param w-relat 
PROCEDURE pi-salva-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {include/i-rpsvpr504.i}
    
    ASSIGN  /*pagina de impress∆o*/
            INPUT FRAME f-pg-imp    rs-destino  c-arquivo
                                    l-imp-param rs-execucao.
    
    /* verfica controles do EMS 5 e dispara login se necess†rio */
    RUN prgtec/btb/btb906za.p.    
    
    IF  rs-destino = 2 AND rs-execucao = 2 THEN 
        DO  WHILE INDEX(c-arquivo,"~/") <> 0: 
            ASSIGN  c-arquivo = SUBSTRING(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
        END. 
    IF  rs-destino = 3 THEN 
        ASSIGN  c-arquivo = SESSION:TEMP-DIRECTORY + "{&programa}.tmp".

    DO  TRANSACTION:
        FIND FIRST dwb_set_list_param EXCLUSIVE-LOCK
             WHERE dwb_set_list_param.cod_dwb_program = "{&programa}"
               AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
        IF  NOT AVAIL dwb_set_list_param THEN DO:
            CREATE  dwb_set_list_param.
            ASSIGN  dwb_set_list_param.cod_dwb_program = "{&programa}"
                    dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren.
        END.
        
        ASSIGN  dwb_set_list_param.cod_dwb_file             = c-arquivo
                dwb_set_list_param.nom_dwb_printer          = c-impressora
                dwb_set_list_param.cod_dwb_print_layout     = c-layout
                dwb_set_list_param.qtd_dwb_line             = 64
                dwb_set_list_param.log_dwb_print_parameters = l-imp-param
                dwb_set_list_param.cod_dwb_output           = ENTRY(rs-destino,"Impressora,Arquivo,Terminal")
                dwb_set_list_param.cod_dwb_parameters       = c-param-campos + CHR(13) + 
                                                                     c-param-tipos  + CHR(13) + 
                                                                     c-param-dados  .
        FIND CURRENT dwb_set_list_param NO-LOCK NO-ERROR.
        
        /*grava a lista da temp-table digita*/
        FIND FIRST dwb_set_list_param_aux EXCLUSIVE-LOCK
             WHERE dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
               AND dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user NO-ERROR.

        FIND FIRST tt-digita NO-LOCK NO-ERROR.
        IF  AVAIL tt-digita THEN DO:
        
            IF  NOT AVAIL dwb_set_list_param_aux THEN DO:
                CREATE  dwb_set_list_param_aux.
                ASSIGN  dwb_set_list_param_aux.cod_dwb_program = dwb_set_list_param.cod_dwb_program
                        dwb_set_list_param_aux.cod_dwb_user    = dwb_set_list_param.cod_dwb_user.
            END.
            
            ASSIGN  i-cont = 0.
            FOR EACH tt-digita NO-LOCK:
                ASSIGN  i-cont = i-cont + 1.
                IF  i-cont = 1 
                    THEN ASSIGN  dwb_set_list_param_aux.cod_dwb_parameters = STRING(tt-digita.ordem) + CHR(10) + tt-digita.exemplo.
                    ELSE ASSIGN  dwb_set_list_param_aux.cod_dwb_parameters = dwb_set_list_param_aux.cod_dwb_parameters + chr(10) +
                                                                                    STRING(tt-digita.ordem) + CHR(10) + tt-digita.exemplo.
            END.
        END.
        ELSE /* se n∆o existe tt-digita e existe dwb_set_list_param, apaga */
            IF  AVAIL dwb_set_list_param_aux THEN
                DELETE  dwb_set_list_param_aux.

    END. /*do transaction*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp504.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
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

