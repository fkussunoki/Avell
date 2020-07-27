&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
{include/i-prgvrs504.i DOC023A 5.05.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{doinc/doc024.i}

DEF INPUT PARAM p-nivel-relat  AS CHAR NO-UNDO.
DEF INPUT PARAM p-cod-ccusto   AS CHAR NO-UNDO.
DEF INPUT PARAM p-da-ini       AS DATE NO-UNDO.
DEF INPUT PARAM p-da-fim       AS DATE NO-UNDO.
DEF INPUT PARAM p-lista-ccusto AS CHAR NO-UNDO.
DEF INPUT PARAM p-cod-cta      AS CHAR NO-UNDO.

DEF INPUT PARAM TABLE FOR tt-cta.
DEF INPUT PARAM TABLE FOR tt-detalhe.

/* Local Variable Definitions ---                                       */

{include/i-rpvar504.i}
{utp/ut-glob504.i}

define variable c-arq-old       as char no-undo.
define variable c-arq-old-batch as char no-undo.
define variable c-imp-old       as char no-undo.
DEFINE VARIABLE l-ok            AS LOG  NO-UNDO.
def var c-terminal              as char no-undo.

DEF VAR cc-plano               AS CHAR NO-UNDO.
{doinc/dsg998.i} /* Sugest∆o cc-plano conforme empresa */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom bt-ok bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok 
     LABEL "&Executar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.42
     BGCOLOR 7 .

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
     SIZE 39.86 BY .88
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

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     bt-ok AT ROW 7.5 COL 2
     bt-cancela AT ROW 7.5 COL 13
     bt-ajuda AT ROW 7.5 COL 58
     rt-buttom AT ROW 7.25 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Imprime - DOC024A".

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 1.75 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     c-arquivo AT ROW 3 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3 COL 43 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3 COL 43 HELP
          "Escolha do nome do arquivo"
     rs-execucao AT ROW 5.25 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1 COL 1.72 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 4.5 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.29 COL 2
     RECT-9 AT ROW 4.79 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68 BY 6
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME f-pg-imp:FRAME = FRAME Dialog-Frame:HANDLE.

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Imprime - DOC024A */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda Dialog-Frame
ON CHOOSE OF bt-ajuda IN FRAME Dialog-Frame /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo Dialog-Frame
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr Dialog-Frame
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok Dialog-Frame
ON CHOOSE OF bt-ok IN FRAME Dialog-Frame /* Executar */
DO:
    ASSIGN c-arquivo      = INPUT FRAME f-pg-imp c-arquivo
           rs-destino     = INPUT FRAME f-pg-imp rs-destino.

    IF c-arquivo = "" THEN DO:
       RUN dop/MESSAGE.p ("Destino de Sa°da Inv†lido!",
                          "Defina Destino de Sa°da.").
    END.
    ELSE DO:
       RUN pi-executar.
       {include/i-rptrm504.i}
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino Dialog-Frame
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
    do  with frame f-pg-imp:
        case self:screen-value:
            when "1" then do:
                assign c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = ""
                       c-arquivo:sensitive    = no
                       bt-arquivo:visible     = no
                       bt-config-impr:visible = yes.
            end.
            when "2" then do:
                assign c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = session:temp-directory + "DOC023.TXT"
                       c-arquivo:sensitive                      = yes
                       bt-arquivo:visible                       = yes
                       bt-config-impr:visible                   = no.
            end.
            when "3" then do:
                assign c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = session:temp-directory + "DOC023.TXT"
                       c-arquivo:sensitive                      = no
                       bt-arquivo:visible                       = no
                       bt-config-impr:visible                   = no.
            end.
        end case.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao Dialog-Frame
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse504.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = session:temp-directory + "DOC024.TXT".

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
  HIDE FRAME f-pg-imp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  ENABLE rt-buttom bt-ok bt-cancela bt-ajuda 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  DISPLAY rs-destino c-arquivo rs-execucao text-destino text-modo 
      WITH FRAME f-pg-imp.
  ENABLE RECT-7 RECT-9 rs-destino c-arquivo bt-config-impr bt-arquivo 
         rs-execucao text-destino text-modo 
      WITH FRAME f-pg-imp.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar Dialog-Frame 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR c-destino             AS CHAR NO-UNDO.
    DEF VAR i-qtd-linhas          AS INT  NO-UNDO INIT 64.
    DEF VAR v_cod_dwb_user        AS CHAR NO-UNDO.
    DEF VAR v_num_ped_exec_corren AS INT  NO-UNDO.
    DEF VAR i-posicao             AS INT  NO-UNDO.

    DEF VAR de-tot-orcado         AS DEC  NO-UNDO.
    DEF VAR de-tot-previsto       AS DEC  NO-UNDO.
    DEF VAR de-tot-realiz         AS DEC  NO-UNDO.

    ASSIGN c-destino      = ENTRY(rs-destino,"Impressora,Arquivo,Terminal")
           v_cod_dwb_user = v_cod_usuar_corren.

    ASSIGN c-programa     = "DOC024A"
           c-versao       = "1.00"
           c-revisao      = "000"
           c-titulo-relat = "Consulta Despesas Realizadas"
           c-sistema      = "Orcamento".

    FIND FIRST emsuni.empresa NO-LOCK
         WHERE emsuni.empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
    IF  AVAIL emsuni.empresa THEN 
        ASSIGN  c-empresa = emsuni.empresa.nom_razao_social.

    {include/i-rpcab504.i}
    {include/rp-output504a.i} 

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    FIND FIRST emsuni.ccusto NO-LOCK
         WHERE emsuni.ccusto.cod_empresa      = v_cod_empres_usuar /*"DOC"*/
           AND emsuni.ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/
           AND emsuni.ccusto.cod_ccusto       = p-cod-ccusto NO-ERROR.
    PUT UNFORMATTED 
        "Centro Custo: " AT 01 p-cod-ccusto.
    IF AVAIL emsuni.ccusto THEN
       PUT UNFORMATTED
           " - "
           emsuni.ccusto.des_tit_ctbl.
    PUT UNFORMATTED
        "Per°odo.....: " AT 01 p-da-ini FORMAT "99/99/9999" " - " p-da-fim FORMAT "99/99/9999".

    IF p-cod-ccusto <> p-lista-ccusto THEN DO:
       PUT UNFORMATTED
           "Lista CCusto: " AT 01
           p-lista-ccusto FORMAT "x(114)".
       DO i-posicao = 114 TO LENGTH(p-lista-ccusto) BY 114:
          PUT SUBSTR(p-lista-ccusto,i-posicao + 1,114)  FORMAT "x(114)" AT 15.
       END.
       
    END.

    IF p-nivel-relat = "ccusto" THEN DO WITH FRAME f-cta:
       PUT SKIP(1).
       ASSIGN de-tot-orcado   = 0
              de-tot-previsto = 0
              de-tot-realiz   = 0.
       FOR EACH tt-cta
          WHERE tt-cta.val-orcado <> 0
             OR tt-cta.val-realiz <> 0
             OR tt-cta.val-previsto <> 0,
          FIRST cta_ctbl NO-LOCK
          WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
            AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl
             BY tt-cta.val-realiz DESC
             BY tt-cta.val-variac DESC
             BY tt-cta.val-orcado DESC
             BY tt-cta.val-previsto DESC
             BY tt-cta.cod_cta_ctbl:
          DISP tt-cta.cod_cta_ctbl
               cta_ctbl.des_tit_ctbl         FORMAT "x(50)"           COLUMN-LABEL "T°tulo"
               tt-cta.val-orcado             FORMAT "->>>,>>>,>>9.99"        LABEL "Oráado"
               tt-cta.val-previsto           FORMAT "->>>,>>>,>>9.99"        LABEL "Previsto"
               tt-cta.val-realiz             FORMAT "->>>,>>>,>>9.99"        LABEL "Realizado"
               tt-cta.val-variac             FORMAT "->>>9.99"               LABEL "% Var"
               WITH STREAM-IO WIDTH 132 NO-BOX DOWN FRAME f-cta.
          DOWN WITH FRAME f-cta.

          ASSIGN de-tot-orcado   = de-tot-orcado + tt-cta.val-orcado
                 de-tot-previsto = de-tot-previsto + tt-cta.val-previsto
                 de-tot-realiz   = de-tot-realiz + tt-cta.val-realiz.
       END.

       UNDERLINE tt-cta.val-orcado
                 tt-cta.val-previsto
                 tt-cta.val-realiz
                 tt-cta.val-variac WITH FRAME f-cta.
       DISP "TOTAL"                              @ tt-cta.cod_cta_ctbl
            de-tot-orcado                        @ tt-cta.val-orcado
            de-tot-previsto                      @ tt-cta.val-previsto
            de-tot-realiz                        @ tt-cta.val-realiz 
           (de-tot-realiz / de-tot-orcado) * 100 @ tt-cta.val-variac WITH FRAME f-cta.

    END.

    IF p-nivel-relat = "cta" THEN DO:
       FOR EACH tt-cta
          WHERE tt-cta.cod_cta_ctbl = p-cod-cta,
          FIRST cta_ctbl NO-LOCK
          WHERE cta_ctbl.cod_plano_cta_ctbl = "PCDOCOL"
            AND cta_ctbl.cod_cta_ctbl       = tt-cta.cod_cta_ctbl:

          PUT UNFORMATTED "Conta.......: " AT 01
              tt-cta.cod_cta_ctbl " - " cta_ctbl.des_tit_ctbl  FORMAT "x(50)" SKIP(1).

          FOR EACH tt-detalhe NO-LOCK
              WHERE tt-detalhe.cod_cta_ctbl = tt-cta.cod_cta_ctbl
                 BY tt-detalhe.cod_cta_ctbl
                 BY tt-detalhe.cod_ccusto
                 BY tt-detalhe.dat_transacao
                 BY tt-detalhe.val-movto DESC
                 BY tt-detalhe.val-previsto DESC:
              DISP tt-detalhe.cod_ccusto
                   tt-detalhe.dat_transacao
                   tt-detalhe.cod_modul_dtsul
                   tt-detalhe.val-movto(TOTAL)
                   tt-detalhe.val-previsto(TOTAL)
                   SUBSTR(tt-detalhe.descricao,1,60) FORMAT "x(60)" LABEL "Descricao"
                   WITH WIDTH 132 NO-BOX STREAM-IO DOWN FRAME f-ccusto.
              DOWN WITH FRAME f-ccusto.
          END.
       END.
    END.

    OUTPUT CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


