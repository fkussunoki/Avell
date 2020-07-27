&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i dpd362 2.04.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
    {cdp/cd0666.i}
    DEF TEMP-TABLE tt-erro-bo LIKE tt-erro.

        /*--- temp-tables ---*/
def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

DEFINE VARIABLE h-cd9500    AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-conta-ft  AS ROWID       NO-UNDO.
DEFINE VARIABLE i-cod-canal AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_cod_unid_negoc AS char   NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR v_cod_usuar_corren AS char NO-UNDO.
DEF VAR l-ok AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-confirma bt-confirma-2 bt-ok bt-cancelar ~
RECT-1 RECT-10 RECT-11 RECT-2 RECT-4 RECT-3 rt-button RECT-5 
&Scoped-Define DISPLAYED-OBJECTS dt-data-entrega c-nr-pedcli i-cod-emit ~
c-nome-emit c-cidade c-estado c-tp-pedido i-cod-rep c-nome-rep ~
de-vl-tot-ped c-cod-regional c-desc-regional 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     IMAGE-UP FILE "image/im-cancel.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-cancelar 
     LABEL "Cancelar Pedido" 
     SIZE 19 BY 1.25
     FGCOLOR 9 FONT 0.

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image/im-new.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-confirma-2 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-ok 
     LABEL "REATIVAR PEDIDO" 
     SIZE 19 BY 1.25
     FGCOLOR 9 FONT 0.

DEFINE VARIABLE c-cidade AS CHARACTER FORMAT "X(25)":U 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-regional AS CHARACTER FORMAT "X(5)":U 
     LABEL "Regional" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-regional AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(2)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-rep AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nr PedCli" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-pedido AS CHARACTER FORMAT "X(2)":U 
     LABEL "Tipo do Pedido" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-tot-ped AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Vl Total Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-data-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova Data de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emit AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 1.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 43 BY 1.75
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 22 BY 1.75
     BGCOLOR 12 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 22 BY 1.75
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88.72 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     dt-data-entrega AT ROW 8 COL 70 COLON-ALIGNED
     c-nr-pedcli AT ROW 2.75 COL 16 COLON-ALIGNED
     bt-confirma AT ROW 1.25 COL 18
     bt-confirma-2 AT ROW 3.5 COL 66
     bt-ok AT ROW 12.5 COL 69
     bt-cancela AT ROW 1.25 COL 23
     i-cod-emit AT ROW 3.75 COL 16 COLON-ALIGNED
     c-nome-emit AT ROW 3.75 COL 27 COLON-ALIGNED NO-LABEL
     c-cidade AT ROW 6.25 COL 16 COLON-ALIGNED
     c-estado AT ROW 7.25 COL 16 COLON-ALIGNED
     c-tp-pedido AT ROW 8.25 COL 16 COLON-ALIGNED
     i-cod-rep AT ROW 5.25 COL 16 COLON-ALIGNED
     c-nome-rep AT ROW 5.25 COL 27 COLON-ALIGNED NO-LABEL
     de-vl-tot-ped AT ROW 10.75 COL 16 COLON-ALIGNED
     c-cod-regional AT ROW 9.75 COL 16 COLON-ALIGNED
     c-desc-regional AT ROW 9.75 COL 21 COLON-ALIGNED NO-LABEL
     bt-cancelar AT ROW 12.5 COL 5 WIDGET-ID 2
     RECT-1 AT ROW 2.5 COL 2
     RECT-10 AT ROW 7.5 COL 49
     RECT-11 AT ROW 9.5 COL 2
     RECT-2 AT ROW 12.25 COL 25
     RECT-4 AT ROW 5 COL 2
     RECT-3 AT ROW 12.25 COL 3 WIDGET-ID 4
     rt-button AT ROW 1 COL 2
     RECT-5 AT ROW 12.25 COL 68 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 13.17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Reativaá∆o Pedido Expositor DPD362.W"
         HEIGHT             = 13.25
         WIDTH              = 90.72
         MAX-HEIGHT         = 21.63
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.63
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cidade IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-regional IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-regional IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estado IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-rep IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-pedcli IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-pedido IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-tot-ped IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-data-entrega IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emit IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-rep IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Reativaá∆o Pedido Expositor DPD362.W */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Reativaá∆o Pedido Expositor DPD362.W */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-livre
ON CHOOSE OF bt-cancela IN FRAME f-cad
DO:
  RUN pi-habilita (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-livre
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar Pedido */
DO:
  

  
     FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = INPUT FRAME {&FRAME-NAME} i-cod-emit NO-ERROR.

     FIND FIRST ped-venda 
          WHERE ped-venda.nome-abrev = emitente.nome-abrev
            AND ped-venda.nr-pedcli  = INPUT FRAME {&FRAME-NAME} c-nr-pedcli NO-ERROR.


     ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
     RUN dop/dpd081b.w (INPUT ROWID(ped-venda), OUTPUT l-ok).
     ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
     IF l-ok = NO THEN DO:
         RETURN NO-APPLY.
     END.


     DISP ""   @ c-cidade
          ""   @ c-estado
          ""   @ i-cod-rep
          ""   @ c-nome-rep
          ""   @ c-tp-pedido
          ""   @ c-cod-regional
          ""   @ c-desc-regional
          ""   @ de-vl-tot-ped
          ""   @ dt-data-entrega
          WITH FRAME {&FRAME-NAME}.
     assign bt-ok     :SENSITIVE IN FRAME {&FRAME-NAME}  = NO
            bt-cancela:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.
     APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.







END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-livre
ON CHOOSE OF bt-confirma IN FRAME f-cad
DO:
  FIND FIRST param-global NO-LOCK.
  RUN pi-habilita (INPUT YES).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma-2 w-livre
ON CHOOSE OF bt-confirma-2 IN FRAME f-cad
DO:

  assign bt-ok:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.
  DISP ""   @ c-cidade
       ""   @ c-estado
       ""   @ i-cod-rep
       ""   @ c-nome-rep
       ""   @ c-tp-pedido
       ""   @ c-cod-regional
       ""   @ c-desc-regional
       ""   @ de-vl-tot-ped
       WITH FRAME {&FRAME-NAME}.

  FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = INPUT FRAME {&FRAME-NAME} i-cod-emit NO-ERROR.
  IF NOT AVAIL emitente THEN DO:
      RUN dop/MESSAGE.p (INPUT "Cliente n∆o cadastrado!",
                         INPUT "Cliente n∆o cadastrado!").
      APPLY "entry" TO i-cod-emit IN FRAME {&FRAME-NAME}.
      return NO-APPLY.
  END.

  FIND ped-venda NO-LOCK
       WHERE ped-venda.nome-abrev = emitente.nome-abrev
         AND ped-venda.nr-pedcli  = INPUT FRAME {&FRAME-NAME} c-nr-pedcli NO-ERROR.
  IF NOT AVAIL ped-venda THEN DO:
      RUN dop/MESSAGE.p (INPUT "Pedido de Venda n∆o cadastrado!",
                         INPUT "Pedido de Venda n∆o cadastrado!").
      APPLY "entry" TO i-cod-emit IN FRAME {&FRAME-NAME}.
      return NO-APPLY.
  END.

  RUN pi-mostra-valores.

  IF lookup(ped-venda.tp-pedido,"69,70,71,72,93,92") = 0 THEN DO:  /*Projeto Levum - Vivian - 17/07/19 - Inclus∆o tipo pedido expositor louáas (69)*/
      RUN dop/MESSAGE.p (INPUT "Tipo do Pedido Inv†lido!",
                         INPUT "Pedido n∆o Ç Expositor, Metal ou Embalagem!" + CHR(10) + "O Tipo do Pedido deve ser 69, 70, 71, 72, 92 ou 93").
      APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.
      return NO-APPLY.
  END.
  IF ped-venda.cod-sit-ped <> 5 THEN DO:
      RUN dop/MESSAGE.p (INPUT "Pedido de Venda n∆o esta suspenso!",
                         INPUT "Pedido de Venda n∆o esta suspenso! N∆o precisa ser reativado!").
      APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.
      return NO-APPLY.
  END.



  assign bt-ok:SENSITIVE IN FRAME {&FRAME-NAME}  = YES.
  assign bt-cancela:SENSITIVE IN FRAME {&FRAME-NAME}  = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-livre
ON CHOOSE OF bt-ok IN FRAME f-cad /* REATIVAR PEDIDO */
DO:
  /*
  IF INPUT FRAME {&FRAME-NAME} de-vl-verba < INPUT FRAME {&FRAME-NAME} de-vl-tot-ped THEN DO:
      RUN dop/MESSAGE.p (INPUT "Verba Insuficiente para Reativar o Pedido!",
                         INPUT "Verba Insuficiente para Reativar o Pedido!").
      APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.
      return NO-APPLY.
  END.
  */

  FOR EACH ped-venda WHERE ped-venda.nome-abrev = emitente.nome-abrev
                       AND ped-venda.nr-pedcli  = INPUT FRAME {&FRAME-NAME} c-nr-pedcli TRANSACTION:
     FIND FIRST dc-ped-venda WHERE dc-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
     ASSIGN dc-ped-venda.log-reativou-pedido = YES.

     ASSIGN ped-venda.cod-sit-ped = 1  /* Aberto */
            ped-venda.dt-reativ   = today
            ped-venda.user-reat   = c-seg-usuario
            ped-venda.completo    = NO
            ped-venda.dt-entrega  = INPUT FRAME {&FRAME-NAME} dt-data-entrega.

     IF ped-venda.dt-entrega = ? THEN
        ASSIGN ped-venda.dt-entrega = TODAY.

     FOR EACH ped-item OF ped-venda WHERE ped-item.cod-sit-item = 5:
         ASSIGN ped-item.cod-sit-item = 1 
                ped-item.dt-entrega   = ped-venda.dt-entrega. 
     END.
     FOR EACH ped-ent OF ped-venda WHERE ped-ent.cod-sit-ent = 5:
         ASSIGN ped-ent.cod-sit-ent = 1 /* Aberto */
                ped-ent.dt-entrega  = ped-venda.dt-entrega.
     END.
     FOR EACH tt-erro-bo:
         DELETE tt-erro-bo.
     END.
     RUN dop/dpd556.p (INPUT ped-venda.nome-abrev,    /* Completa Pedido */
                       INPUT ped-venda.nr-pedcli,
                       OUTPUT TABLE tt-erro-bo).
     

     /*
     assign de-vl-tot-ped = ped-venda.vl-tot-ped.
     for each exp-contro-regional
        where exp-contro-regional.periodo      >= (string(year(today),"9999") + "01")
          and exp-contro-regional.periodo      <= (string(year(today),"9999") + string(month(today),"99"))
          and exp-contro-regional.cod-regional  = INPUT FRAME {&FRAME-NAME} c-cod-regional
          and exp-contro-regional.vl-saldo  > 0:
          if de-vl-tot-ped <= exp-contro-regional.vl-saldo then do:
            create exp-ped-controle.
            assign exp-ped-controle.nr-ped-exp    = " "
                   exp-ped-controle.nr-pedcli     = ped-venda.nr-pedcli
                   exp-ped-controle.cod-emit      = emitente.cod-emit
                   exp-ped-controle.periodo       = exp-contro-regional.periodo
                   exp-ped-controle.tipo          = exp-contro-regional.tipo
                   exp-ped-controle.dt-trans      = exp-contro-regional.dt-trans
                   exp-ped-controle.hora          = exp-contro-regional.hora
                   exp-ped-controle.dt-libera     = today
                   exp-ped-controle.hora-libera   = string(time,"hh:mm:ss")
                   exp-ped-controle.cod-regional  = exp-contro-regional.cod-regional
                   exp-ped-controle.imposto       = no
                   exp-ped-controle.seq-liberacao = "1"
                   exp-ped-controle.vl-liberado   = de-vl-tot-ped.
            assign exp-contro-regional.vl-saldo  = exp-contro-regional.vl-saldo - exp-ped-controle.vl-liberado.
            leave.
          end. /* then do */
          else do:
            create exp-ped-controle.
            assign exp-ped-controle.nr-ped-exp    = " "
                   exp-ped-controle.nr-pedcli     = ped-venda.nr-pedcli
                   exp-ped-controle.cod-emit      = emitente.cod-emit
                   exp-ped-controle.periodo       = exp-contro-regional.periodo
                   exp-ped-controle.tipo          = exp-contro-regional.tipo
                   exp-ped-controle.dt-trans      = exp-contro-regional.dt-trans
                   exp-ped-controle.hora          = exp-contro-regional.hora
                   exp-ped-controle.dt-libera     = today
                   exp-ped-controle.hora-libera   = string(time,"hh:mm:ss")
                   exp-ped-controle.cod-regional  = exp-contro-regional.cod-regional
                   exp-ped-controle.imposto       = no
                   exp-ped-controle.seq-liberacao = "1"
                   exp-ped-controle.vl-liberado   = exp-contro-regional.vl-saldo.
            assign exp-contro-regional.vl-saldo          = exp-contro-regional.vl-saldo - exp-ped-controle.vl-liberado.
                     de-vl-tot-ped                = de-vl-tot-ped -
                                                   exp-ped-controle.vl-liberado.
          end. /* else do */
     end.     /* for each exp-contro-regional */
     ***      Final do Create do Ped-Contr-Exp    ****/

     IF ped-venda.cod-sit-ped = 1 THEN DO:

         /* Verifica Oráamento do Pedido Tipo 71/93/69 */
          IF ped-venda.tp-pedido = "71" OR ped-venda.tp-pedido = "93" OR ped-venda.tp-pedido = "69" THEN DO:  /*Projeto Levum - Vivian - 17/07/19 - Inclus∆o tipo pedido expositor louáas (69)*/

              FIND LAST param_geral_bgc NO-LOCK WHERE
                        param_geral_bgc.dat_ult_atualiz >= 01/01/0001 AND
                        param_geral_bgc.hra_ult_atualiz >= ""         NO-ERROR.
              FIND FIRST param-global   NO-LOCK NO-ERROR.
              IF AVAIL param_geral_bgc and param_geral_bgc.log_efetua_exec_orctaria = yes THEN DO:

                    EMPTY TEMP-TABLE tt_xml_input_1.

                    IF NOT VALID-HANDLE(h-cd9500) THEN
                        RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

                    FIND FIRST emitente
                         WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.

                    IF AVAIL emitente THEN DO:

                        ASSIGN r-conta-ft = ?.

                        ASSIGN i-cod-canal = ped-venda.cod-canal-venda.

                        FIND FIRST conta-ft NO-LOCK
                             WHERE conta-ft.cod-estabel = ped-venda.cod-estabel
                               AND conta-ft.nat-oper    = ped-venda.nat-oper
                               AND conta-ft.cod-canal   = i-cod-canal NO-ERROR.
                        IF NOT AVAIL conta-ft THEN DO: //TRANSACTION
                            ASSIGN i-cod-canal = 0. /* Se nao zerar o canal de venda busca a conta errada no faturamento */
                        END.


                        FIND FIRST estabelecimento NO-LOCK WHERE estabelecimento.cod_estab = ped-venda.cod-estabel NO-ERROR.
                        FOR EACH  unid-negoc-grp-usuar NO-LOCK
                            WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
                            EACH  unid-negoc-estab NO-LOCK
                            WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
                              AND unid-negoc-estab.cod-estabel     = estabelecimento.cod_estab
                              AND unid-negoc-estab.dat-inic-valid <= TODAY
                              AND unid-negoc-estab.dat-fim-valid  >= TODAY:

                            ASSIGN v_cod_unid_negoc = unid-negoc-estab.cod-unid-negoc.
                        END.
                        
                       
                        /* Busca dados de Conta e Centro de Custo */
                        RUN pi-cd9500 IN h-cd9500(INPUT  ped-venda.cod-estabel,
                                                  INPUT  emitente.cod-gr-cli,
                                                  INPUT  ?,
                                                  INPUT  ped-venda.nat-operacao,
                                                  INPUT  ?,
                                                  INPUT  "",
                                                  INPUT  i-cod-canal,
                                                  OUTPUT r-conta-ft).
                    
                        FOR FIRST conta-ft 
                            WHERE ROWID(conta-ft) = r-conta-ft no-lock:
                        

                            //19.09.2019 - Flavio Kussunoki
                            //Execuáao oráament†ria para pedidos de mostru†rio
                            //Origem de Movimento 90 - Pedido Expositor.
                            //Faz liberaáao e a manutencao Ç feita pelo PD4000.
                            //Na primeira execucao VERIFICA, pois se inserir VERIFCA e ATUALIZA, quando d† erro nao demonstra o erro.


                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label       = "Funcao"
                                     tt_xml_input_1.tt_des_conteudo    = "Verifica"
                                     tt_xml_input_1.tt_num_seq_1_xml   = 1
                                     tt_xml_input_1.tt_num_seq_2_xml   = 0.
                               
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label       = "Empresa"
                                     tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
                                     tt_xml_input_1.tt_num_seq_1_xml   = 1
                                     tt_xml_input_1.tt_num_seq_2_xml   = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
                                     tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.ct-cusven)
                                     tt_xml_input_1.tt_num_seq_1_xml   = 1
                                     tt_xml_input_1.tt_num_seq_2_xml   = 0.
                               
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                                     tt_xml_input_1.tt_des_conteudo    = ped-venda.cod-estabel
                                     tt_xml_input_1.tt_num_seq_1_xml   = 1
                                     tt_xml_input_1.tt_num_seq_2_xml   = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                                     tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.dt-entrega)
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                                     tt_xml_input_1.tt_des_conteudo   = "0"
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                               
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                                     tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.vl-liq-ped)
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                                     tt_xml_input_1.tt_des_conteudo   = "1"
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                                     tt_xml_input_1.tt_des_conteudo   = "90"
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                                     tt_xml_input_1.tt_des_conteudo   = "Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                                  
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                                     tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                                     tt_xml_input_1.tt_num_seq_1_xml  = 1
                                     tt_xml_input_1.tt_num_seq_2_xml  = 0.
                              
                              create tt_xml_input_1.
                              assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                                     tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.sc-cusven)
                                     tt_xml_input_1.tt_num_seq_1_xml   = 1
                                     tt_xml_input_1.tt_num_seq_2_xml   = 0.
    
                              RUN prgfin/bgc/bgc700za.py (input 1,
                                                          input table tt_xml_input_1,
                                                          output table tt_log_erros) .  

                        END.
                    END.

                    IF VALID-HANDLE(h-cd9500) THEN
                        DELETE WIDGET h-cd9500.

              END.
          END.
          find first tt_log_erros no-lock no-error.
          if  avail tt_log_erros then do: 
               RUN dop/dpd557.p (INPUT ped-venda.nome-abrev, 
                                 INPUT ped-venda.nr-pedcli,
                                 INPUT tt_log_erros.ttv_des_ajuda,
                                 OUTPUT TABLE tt-erro). /* programa que suspende o pedido */

               RUN dop/MESSAGE.p (INPUT "O Pedido ficou SUSPENSO Novamente!",
                                   INPUT "Motivo: " + tt_log_erros.ttv_des_ajuda).
          END.
          ELSE DO:

              // apenas atualiza a movimentacao da Execucao Oráamentaria
              FIND FIRST tt_xml_input_1 NO-LOCK WHERE tt_xml_input_1.tt_cod_label       = "Funcao" NO-ERROR.
              ASSIGN  tt_xml_input_1.tt_des_conteudo = "Atualiza".

              RUN prgfin/bgc/bgc700za.py (input 1,
                                          input table tt_xml_input_1,
                                          output table tt_log_erros) .  

                MESSAGE "Pedido Reativado!" VIEW-AS ALERT-BOX.

                // NDS 77139 - Envia e-mail tambÇm para reativaá∆o dos tipos 87 e 88
                IF (ped-venda.cod-sit-ped = 1 /* Aberto */ OR ped-venda.cod-sit-ped = 2 /* Atendido Parcial */ ) AND
                    (ped-venda.tp-pedido = "71" OR ped-venda.tp-pedido = "93" OR ped-venda.tp-pedido = "69" OR  /*Projeto Levum - Vivian - 17/07/19 - Inclus∆o tipo pedido expositor louáas (69)*/
                     ped-venda.tp-pedido = "87" OR ped-venda.tp-pedido = "97" OR // VENDA METAIS PARA EXPOSIÄ«O
                     ped-venda.tp-pedido = "88" OR ped-venda.tp-pedido = "98") THEN DO: // VENDA EXPOSITOR BOUTIQUE
                      RUN dop/dpd338.p (INPUT ped-venda.nr-pedido).
                END.
          END.
     END.
     ELSE DO:
        RUN dop/MESSAGE.p ("Pedido Suspenso Novamente!",
                           ped-venda.desc-susp).
     END.
  END. /* for each ped-venda ... */


  DISP ""   @ c-cidade
       ""   @ c-estado
       ""   @ i-cod-rep
       ""   @ c-nome-rep
       ""   @ c-tp-pedido
       ""   @ c-cod-regional
       ""   @ c-desc-regional
       ""   @ de-vl-tot-ped
       ""   @ dt-data-entrega
       WITH FRAME {&FRAME-NAME}.

  assign bt-ok     :SENSITIVE IN FRAME {&FRAME-NAME}  = NO
         bt-cancela:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.

  APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-pedcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-pedcli w-livre
ON LEAVE OF c-nr-pedcli IN FRAME f-cad /* Nr PedCli */
DO:
    FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nr-pedcli  = INPUT FRAME {&FRAME-NAME} c-nr-pedcli 
                                   AND ped-venda.cod-sit-ped = 5 NO-ERROR.
    IF NOT AVAIL ped-venda THEN
       FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nr-pedcli  = INPUT FRAME {&FRAME-NAME} c-nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:
       FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.
       DISP emitente.cod-emit  @ i-cod-emit
            emitente.nome-emit @ c-nome-emit
            WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emit w-livre
ON LEAVE OF i-cod-emit IN FRAME f-cad /* Cliente */
DO:
  
    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} i-cod-emit NO-ERROR.
    IF AVAIL emitente THEN
        DISP emitente.cod-emit  @ i-cod-emit
             emitente.nome-emit @ c-nome-emit
             WITH FRAME {&FRAME-NAME}.
    ELSE
        DISP 0  @ i-cod-emit
             "" @ c-nome-emit
             WITH FRAME {&FRAME-NAME}.




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* c-nr-pedcli:load-mouse-pointer("image\lupa.cur") in frame {&frame-name}. */
/* i-cod-emit:load-mouse-pointer("image\lupa.cur") in frame {&frame-name}.  */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-ok:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY dt-data-entrega c-nr-pedcli i-cod-emit c-nome-emit c-cidade c-estado 
          c-tp-pedido i-cod-rep c-nome-rep de-vl-tot-ped c-cod-regional 
          c-desc-regional 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE bt-confirma bt-confirma-2 bt-ok bt-cancelar RECT-1 RECT-10 RECT-11 
         RECT-2 RECT-4 RECT-3 rt-button RECT-5 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "dpd362" "2.04.00.000"}




  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
  RUN pi-habilita (INPUT NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita w-livre 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-log AS LOG.

  assign bt-ok:sensitive                in frame {&frame-name}  = NO
         bt-cancelar:sensitive                in frame {&frame-name}  = NO
         bt-confirma:sensitive          in frame {&frame-name}  = (NOT p-log)
         bt-confirma-2:sensitive        in frame {&frame-name}  = p-log
         bt-cancela:sensitive           in frame {&frame-name}  = p-log     
         c-nr-pedcli:SENSITIVE          in frame {&frame-name}  = p-log
         i-cod-emit:SENSITIVE           in frame {&frame-name}  = p-log.


     IF p-log THEN
         DISP ""        @ c-nr-pedcli           
              0         @ i-cod-emit
              ""        @ c-nome-emit
              WITH FRAME {&FRAME-NAME}.
     ELSE
         DISP ""        @ c-nr-pedcli           
              ""        @ i-cod-emit
              ""        @ c-nome-emit
              WITH FRAME {&FRAME-NAME}.


     DISP ""   @ c-cidade
          ""   @ c-estado
          ""   @ i-cod-rep
          ""   @ c-nome-rep
          ""   @ c-tp-pedido
          ""   @ c-cod-regional
          ""   @ c-desc-regional
          ""   @ de-vl-tot-ped
          ""   @ dt-data-entrega
          WITH FRAME {&FRAME-NAME}.
     APPLY "entry" TO c-nr-pedcli IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valores w-livre 
PROCEDURE pi-mostra-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR dt-aux-entrega AS DATE.
DEF VAR i-dias         AS INT.
          
  IF ped-venda.cidade <> "" OR 
     ped-venda.estado <> "" THEN
     ASSIGN c-cidade = ped-venda.cidade
            c-estado = ped-venda.estado.
  ELSE DO:
     FIND loc-entr WHERE loc-entr.nome-abrev  = ped-venda.nome-abrev
                     AND loc-entr.cod-entrega = ped-venda.cod-entrega NO-ERROR.
     IF AVAIL loc-entr THEN
         ASSIGN c-cidade = loc-entr.cidade
                c-estado = loc-entr.estado.        
     ELSE
         ASSIGN c-cidade = emitente.cidade
                c-estado = emitente.estado.
  END.

  FIND FIRST repres NO-LOCK WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
  ASSIGN i-cod-rep     = repres.cod-rep
         c-nome-rep    = repres.nome
         c-tp-pedido   = ped-venda.tp-pedido
         de-vl-tot-ped = ped-venda.vl-tot-ped.

  find regiao no-lock where regiao.nome-ab-reg = repres.nome-ab-reg.      
  find first dc-regiao no-lock where dc-regiao.nome-ab-reg = repres.nome-ab-reg no-error.
  if not avail dc-regiao then
     find first regional no-lock where regional.cod-regional  = "" no-error.
  else 
     find first regional no-lock where regional.cod-regional  = dc-regiao.cod-regional no-error.
  IF AVAIL regional THEN
     ASSIGN c-cod-regional  = regional.cod-regional
            c-desc-regional = regional.des-regional.
  ELSE
      ASSIGN c-cod-regional  = ""
             c-desc-regional = "".


  ASSIGN dt-data-entrega = ped-venda.dt-entrega.
  IF ped-venda.tp-pedido = "70" /* Expositor */ OR
     ped-venda.tp-pedido = "92" /* Expositor */ THEN DO:
              ASSIGN dt-aux-entrega = TODAY.
              DO i-dias = 1 TO 20:
                  ASSIGN dt-aux-entrega = dt-aux-entrega + 1.
                  REPEAT:
                      FIND FIRST calen-coml
                           WHERE calen-coml.ep-codigo   = i-ep-codigo-usuario
                             AND calen-coml.cod-estabel = ped-venda.cod-estabel
                             AND calen-coml.data        = dt-aux-entrega NO-ERROR.
                      IF NOT AVAIL calen-coml THEN LEAVE.
                      IF calen-coml.tipo <> 1 THEN DO: 
                         ASSIGN dt-aux-entrega = dt-aux-entrega + 1.
                      END.
                      ELSE LEAVE.                     
                  END.
              END. /* do i-dias ... */
              /* ASSIGN dt-data-entrega = today + 20. */
              ASSIGN dt-data-entrega = dt-aux-entrega.
  END.
  ELSE DO:
      ASSIGN dt-aux-entrega = TODAY.
      DO i-dias = 1 TO 8:
          ASSIGN dt-aux-entrega = dt-aux-entrega + 1.
          REPEAT:
              FIND FIRST calen-coml
                   WHERE calen-coml.ep-codigo   = i-ep-codigo-usuario
                     AND calen-coml.cod-estabel = ped-venda.cod-estabel
                     AND calen-coml.data        = dt-aux-entrega NO-ERROR.
              IF NOT AVAIL calen-coml THEN LEAVE.
              IF calen-coml.tipo <> 1 THEN DO: 
                 ASSIGN dt-aux-entrega = dt-aux-entrega + 1.
              END.
              ELSE LEAVE.                     
          END.
      END. /* do i-dias ... */
      ASSIGN dt-data-entrega = dt-aux-entrega.
      /* ASSIGN dt-data-entrega = today + 5. */
  END.
     

  IF ped-venda.dt-entrega > dt-data-entrega THEN
      ASSIGN dt-data-entrega = ped-venda.dt-entrega.


  DISP c-cidade
       c-estado
       i-cod-rep
       c-nome-rep
       c-tp-pedido
       c-cod-regional
       c-desc-regional
       de-vl-tot-ped
       dt-data-entrega
       WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

