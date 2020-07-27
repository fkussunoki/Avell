&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESRC9999B5 2.06.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE v_usuario AS CHAR NO-UNDO.
DEFINE VARIABLE v_data-proc AS DATETIME NO-UNDO.
DEFINE VARIABLE v_cod-estabel AS CHAR NO-UNDO.
DEFINE VARIABLE r-cenario AS ROWID NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ColumnHandle  AS HANDLE    NO-UNDO.
DEFINE VARIABLE cField        AS CHAR      NO-UNDO.
DEFINE VARIABLE cFieldOld     AS CHAR      NO-UNDO  INIT ''.
DEFINE VARIABLE cFieldOld2    AS CHAR      NO-UNDO  INIT ''.
DEFINE VARIABLE cFieldOld3    AS CHAR      NO-UNDO  INIT ''.
DEFINE VARIABLE cPrepare      AS CHAR      NO-UNDO.
DEFINE VARIABLE c-num-pedido LIKE ordem-compr.num-pedido NO-UNDO .
DEFINE VARIABLE c-num-ordem LIKE prazo-compra.numero-ordem NO-UNDO .

DEFINE TEMP-TABLE ttAnaliseOCped NO-UNDO LIKE analiseOCped
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD des-cond-pag LIKE cond-pagto.descricao
    FIELD tipo-frete   AS   CHAR
    FIELD sit-ped      AS   CHAR
    FIELD seleciona    AS   CHAR FORM 'x(1)'
    FIELD valor-tot    LIKE AnaliseOCord.preco-total.

DEFINE TEMP-TABLE ttAnaliseOCord NO-UNDO LIKE analiseOCord
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD seleciona    AS   CHAR FORM 'x(1)'.

DEFINE TEMP-TABLE ttAnaliseOCpar NO-UNDO LIKE prazo-compra
    FIELD desc-sit     AS   CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME brOrdem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAnaliseOCord ttAnaliseOCpar ttAnaliseOCped

/* Definitions for BROWSE brOrdem                                       */
&Scoped-define FIELDS-IN-QUERY-brOrdem ttAnaliseOCord.seleciona ttAnaliseOCord.cod-estabel ttAnaliseOCord.data-proc ttAnaliseOCord.it-codigo ttAnaliseOCord.principio-ativo ttAnaliseOCord.cod-fabricante ttAnaliseOCord.num-pedido ttAnaliseOCord.numero-ordem ttAnaliseOCord.dias-estoque ttAnaliseOCord.qt-solic ttAnaliseOCord.preco-unit ttAnaliseOCord.preco-total ttAnaliseOCord.cod-comprado ttAnaliseOCord.cod-emitente ttAnaliseOCord.nome-emit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdem ttAnaliseOCord.seleciona   
&Scoped-define ENABLED-TABLES-IN-QUERY-brOrdem ttAnaliseOCord
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brOrdem ttAnaliseOCord
&Scoped-define SELF-NAME brOrdem
&Scoped-define QUERY-STRING-brOrdem FOR EACH ttAnaliseOCord       WHERE ttAnaliseOCord.num-pedido = c-num-pedido NO-LOCK
&Scoped-define OPEN-QUERY-brOrdem OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCord       WHERE ttAnaliseOCord.num-pedido = c-num-pedido NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brOrdem ttAnaliseOCord
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdem ttAnaliseOCord


/* Definitions for BROWSE brParcela                                     */
&Scoped-define FIELDS-IN-QUERY-brParcela ttAnaliseOCpar.parcela ttAnaliseOCpar.quant-saldo ttAnaliseOCpar.un ttAnaliseOCpar.data-entrega ttAnaliseOCpar.desc-sit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brParcela   
&Scoped-define SELF-NAME brParcela
&Scoped-define QUERY-STRING-brParcela FOR EACH ttAnaliseOCpar       WHERE ttAnaliseOCpar.numero-ordem = c-num-ordem NO-LOCK
&Scoped-define OPEN-QUERY-brParcela OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCpar       WHERE ttAnaliseOCpar.numero-ordem = c-num-ordem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brParcela ttAnaliseOCpar
&Scoped-define FIRST-TABLE-IN-QUERY-brParcela ttAnaliseOCpar


/* Definitions for BROWSE brPedido                                      */
&Scoped-define FIELDS-IN-QUERY-brPedido ttAnaliseOCped.seleciona ttAnaliseOCped.cod-estabel ttAnaliseOCped.data-proc ttAnaliseOCped.num-pedido ttAnaliseOCped.responsavel ttAnaliseOCped.cod-emitente ttAnaliseOCped.nome-emit ttAnaliseOCped.des-cond-pag ttAnaliseOCped.tipo-frete ttAnaliseOCped.sit-ped ttAnaliseOCped.valor-tot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPedido ttAnaliseOCped.seleciona   
&Scoped-define ENABLED-TABLES-IN-QUERY-brPedido ttAnaliseOCped
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brPedido ttAnaliseOCped
&Scoped-define SELF-NAME brPedido
&Scoped-define QUERY-STRING-brPedido FOR EACH ttAnaliseOCped
&Scoped-define OPEN-QUERY-brPedido OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCped.
&Scoped-define TABLES-IN-QUERY-brPedido ttAnaliseOCped
&Scoped-define FIRST-TABLE-IN-QUERY-brPedido ttAnaliseOCped


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brPedido BUTTON-2 brOrdem brParcela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
it-codigo||y|mgesp.analiseOCped.it-codigo
cod-emitente||y|mgesp.analiseOCped.cod-emitente
cod-fabricante||y|mgesp.analiseOCped.cod-fabricante
cod-estabel||y|mgesp.analiseOCped.cod-estabel
cod-cond-pag||y|mgesp.analiseOCped.cod-cond-pag
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "it-codigo,cod-emitente,cod-fabricante,cod-estabel,cod-cond-pag"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnc_Frete B-table-Win 
FUNCTION fnc_Frete RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnc_Situacao B-table-Win 
FUNCTION fnc_Situacao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "image/im-mens.gif":U
     IMAGE-DOWN FILE "image/im-mens.gif":U
     LABEL "Button 2" 
     SIZE 8.29 BY 2.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOrdem FOR 
      ttAnaliseOCord SCROLLING.

DEFINE QUERY brParcela FOR 
      ttAnaliseOCpar SCROLLING.

DEFINE QUERY brPedido FOR 
      ttAnaliseOCped SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdem B-table-Win _FREEFORM
  QUERY brOrdem NO-LOCK DISPLAY
      ttAnaliseOCord.seleciona COLUMN-LABEL ""      
      ttAnaliseOCord.cod-estabel FORMAT "X(5)":U
      ttAnaliseOCord.data-proc COLUMN-LABEL "Data Gera‡Æo" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      ttAnaliseOCord.it-codigo FORMAT "X(16)":U
      ttAnaliseOCord.principio-ativo FORMAT "X(60)":U WIDTH 30.86
      ttAnaliseOCord.cod-fabricante FORMAT "X(15)":U WIDTH 11.43
      ttAnaliseOCord.num-pedido FORMAT ">>>>>,>>9":U
      ttAnaliseOCord.numero-ordem FORMAT "zzzzzz9,99":U
      ttAnaliseOCord.dias-estoque FORMAT ">>>,>>9":U
      ttAnaliseOCord.qt-solic FORMAT ">>>,>>>,>>9.9999":U
      ttAnaliseOCord.preco-unit FORMAT ">>>>>,>>9.99999":U
      ttAnaliseOCord.preco-total FORMAT ">>>,>>>,>>9.99":U
      ttAnaliseOCord.cod-comprado COLUMN-LABEL "Comprador" FORMAT "X(12)":U
      ttAnaliseOCord.cod-emitente COLUMN-LABEL "Cod For" FORMAT ">>>>>>>>9":U
      ttAnaliseOCord.nome-emit COLUMN-LABEL "Fornecedor" FORMAT "x(80)":U WIDTH 31.72
ENABLE ttAnaliseOCord.seleciona
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 10.96
         TITLE "Resumo de Ordens de Compras geradas" ROW-HEIGHT-CHARS .67.

DEFINE BROWSE brParcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brParcela B-table-Win _FREEFORM
  QUERY brParcela NO-LOCK DISPLAY
      ttAnaliseOCpar.parcela COLUMN-LABEL "Parc" FORMAT ">>>>9":U
      ttAnaliseOCpar.quant-saldo COLUMN-LABEL "Qtde Saldo" FORMAT "->>>>,>>9.9999":U
      ttAnaliseOCpar.un COLUMN-LABEL "Un" FORMAT "xx":U
      ttAnaliseOCpar.data-entrega COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
      ttAnaliseOCpar.desc-sit COLUMN-LABEL "Situacao" FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 45.14 BY 10.88
         TITLE "Parcelas da Ordem de Compra".

DEFINE BROWSE brPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPedido B-table-Win _FREEFORM
  QUERY brPedido NO-LOCK DISPLAY
      ttAnaliseOCped.seleciona COLUMN-LABEL ""      
      ttAnaliseOCped.cod-estabel FORMAT "X(5)":U
      ttAnaliseOCped.data-proc COLUMN-LABEL "Data Gera‡Æo" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      ttAnaliseOCped.num-pedido FORMAT ">>>>>,>>9":U
      ttAnaliseOCped.responsavel COLUMN-LABEL "Comprador" FORMAT "X(12)":U
      ttAnaliseOCped.cod-emitente COLUMN-LABEL "Cod For" FORMAT ">>>>>>>>9":U
      ttAnaliseOCped.nome-emit COLUMN-LABEL "Fornecedor" FORMAT "x(80)":U WIDTH 31.72
      ttAnaliseOCped.des-cond-pag COLUMN-LABEL "Condi‡Æo Pagamento" FORMAT "x(30)":U WIDTH 24.43
      ttAnaliseOCped.tipo-frete COLUMN-LABEL "Frete" FORMAT "x(10)":U
      ttAnaliseOCped.sit-ped COLUMN-LABEL "Situa‡Æo" FORMAT "x(15)":U
      ttAnaliseOCped.valor-tot COLUMN-LABEL "Valor Total" FORMAT ">>>>>,>>>,>>9.99999":U
ENABLE ttAnaliseOCped.seleciona
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 175 BY 13.75
         TITLE "Resumo de Pedidos de Compras gerados" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     brPedido AT ROW 1 COL 1
     BUTTON-2 AT ROW 2.67 COL 177.29 WIDGET-ID 2
     brOrdem AT ROW 15.21 COL 1 WIDGET-ID 200
     brParcela AT ROW 15.21 COL 135.57 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 25.33
         WIDTH              = 185.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB brPedido 1 F-Main */
/* BROWSE-TAB brOrdem BUTTON-2 F-Main */
/* BROWSE-TAB brParcela brOrdem F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdem
/* Query rebuild information for BROWSE brOrdem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCord
      WHERE ttAnaliseOCord.num-pedido = c-num-pedido NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE brOrdem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brParcela
/* Query rebuild information for BROWSE brParcela
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCpar
      WHERE ttAnaliseOCpar.numero-ordem = c-num-ordem NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE brParcela */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPedido
/* Query rebuild information for BROWSE brPedido
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttAnaliseOCped.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST USED, FIRST USED"
     _Where[1]         = "mgesp.analiseOCped.usuario = v_usuario
 AND mgesp.analiseOCped.data-proc = v_data-proc
 AND mgesp.analiseOCped.cod-estabel = v_cod-estabel
 AND mgesp.analiseOCped.principio-ativo = v_principio-ativo
 AND mgesp.analiseOCped.cod-fabricante = v_cod-fabricante
 AND mgesp.analiseOCped.it-codigo = v_it-codigo"
     _Query            is NOT OPENED
*/  /* BROWSE brPedido */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME brOrdem
&Scoped-define SELF-NAME brOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdem B-table-Win
ON VALUE-CHANGED OF brOrdem IN FRAME F-Main /* Resumo de Ordens de Compras geradas */
DO:
     ASSIGN c-num-ordem = IF AVAIL ttAnaliseOCord THEN ttAnaliseOCord.numero-ordem ELSE 0.
     {&open-query-brParcela}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPedido
&Scoped-define SELF-NAME brPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedido B-table-Win
ON ROW-ENTRY OF brPedido IN FRAME F-Main /* Resumo de Pedidos de Compras gerados */
DO:

  {&open-query-brOrdem}
  {&open-query-brParcela}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedido B-table-Win
ON ROW-LEAVE OF brPedido IN FRAME F-Main /* Resumo de Pedidos de Compras gerados */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedido B-table-Win
ON VALUE-CHANGED OF brPedido IN FRAME F-Main /* Resumo de Pedidos de Compras gerados */
DO:

     ASSIGN c-num-pedido = IF AVAIL ttAnaliseOCped THEN ttAnaliseOCped.num-pedido ELSE 0.
    {&open-query-brOrdem}
    
     APPLY 'value-changed' TO brOrdem IN FRAME f-main.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  
  define buffer  bttAnaliseOCped for ttAnaliseOCped.
  
    FIND FIRST  bttAnaliseOCped WHERE RECID( bttAnaliseOCped) = recid(ttanaliseOCped) NO-ERROR.

    find first pedido-compr where pedido-compr.num-pedido = bttAnaliseOCped.num-pedido no-error.
    
    if avail pedido-compr then do:
    
    
    run esp/esrcc0300.p(INPUT rowid(pedido-compr)).
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOrdem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON START-SEARCH OF brPedido IN FRAME f-main
DO:
    ASSIGN ColumnHandle = brPedido:CURRENT-COLUMN
           cField = ColumnHandle:NAME
           cPrepare = ("FOR EACH ttAnaliseOCped NO-LOCK " + "BY " + cField + (IF cFieldOld <> "" AND cFieldOld = cField THEN " DESCENDING" ELSE "")).
    QUERY brPedido:QUERY-PREPARE (cPrepare).
    QUERY brPedido:QUERY-OPEN().

    ASSIGN cFieldOld = IF cFieldOld = '' THEN cField ELSE ''.
    
     APPLY 'value-changed' TO brPedido IN FRAME f-main.
    
END.

ON START-SEARCH OF brOrdem IN FRAME f-main
DO:
    ASSIGN ColumnHandle = brOrdem:CURRENT-COLUMN
           cField = ColumnHandle:NAME
           cPrepare = ("FOR EACH ttAnaliseOCord NO-LOCK WHERE ttAnaliseOCord.num-pedido = " + STRING(c-num-pedido) + " BY " + cField + (IF cFieldOld2 <> "" AND cFieldOld2 = cField THEN " DESCENDING" ELSE "")).
    QUERY brOrdem:QUERY-PREPARE (cPrepare).
    QUERY brOrdem:QUERY-OPEN().

    ASSIGN cFieldOld2 = IF cFieldOld2 = '' THEN cField ELSE ''.

    APPLY 'value-changed' TO brOrdem IN FRAME f-main.
END.

ON START-SEARCH OF brParcela IN FRAME f-main
DO:
    ASSIGN ColumnHandle = brOrdem:CURRENT-COLUMN
           cField = ColumnHandle:NAME
           cPrepare = ("FOR EACH ttAnaliseOCpar NO-LOCK WHERE ttAnaliseOCpar.numero-ordem = " + STRING(c-num-ordem) + " BY " + cField + (IF cFieldOld2 <> "" AND cFieldOld3 = cField THEN " DESCENDING" ELSE "")).
    QUERY brOrdem:QUERY-PREPARE (cPrepare).
    QUERY brOrdem:QUERY-OPEN().

    ASSIGN cFieldOld3 = IF cFieldOld3 = '' THEN cField ELSE ''.

    APPLY 'value-changed' TO brParcela IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-browser B-table-Win 
PROCEDURE pi-inicializa-browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttAnaliseOCped.
EMPTY TEMP-TABLE ttAnaliseOCord.
EMPTY TEMP-TABLE ttAnaliseOCpar.
DEF VAR d-valor LIKE ordem-compra.preco-fornec NO-UNDO.

IF AVAIL analiseOCcenar THEN DO:
    FOR EACH analiseOCped NO-LOCK
       WHERE analiseOCped.usuario = analiseOCcenar.usuario
         AND analiseOCped.data-proc = analiseOCcenar.data-proc
         AND analiseOCped.num-pedido <> 0,
       FIRST pedido-compr OF analiseOCped NO-LOCK:

       FIND emitente NO-LOCK WHERE emitente.cod-emitente = analiseOCped.cod-emitente NO-ERROR.
       FIND cond-pagto NO-LOCK WHERE cond-pagto.cod-cond-pag = analiseOCped.cod-cond-pag NO-ERROR.

       CREATE ttAnaliseOCped.
       BUFFER-COPY analiseOCped TO ttAnaliseOCped
           ASSIGN ttAnaliseOCped.nome-emit = IF AVAIL emitente THEN emitente.nome-emit ELSE ''
                  ttAnaliseOCped.des-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ''
                  ttAnaliseOCped.tipo-frete = fnc_Frete()
                  ttAnaliseOCped.sit-ped = fnc_Situacao().
      
       ASSIGN d-valor = 0.       
       FOR EACH ordem-compra OF pedido-compr NO-LOCK:
          ASSIGN d-valor = d-valor + (ordem-compra.preco-fornec * ordem-compra.qt-solic).
       END.
       ASSIGN ttAnaliseOCped.valor-tot = d-valor.
    END.
    FOR EACH analiseOCord NO-LOCK
       WHERE analiseOCord.usuario = analiseOCcenar.usuario
         AND analiseOCord.data-proc = analiseOCcenar.data-proc
         AND analiseOCord.num-pedido <> 0,
       FIRST ordem-compra OF analiseOCord NO-LOCK:

        FIND emitente NO-LOCK WHERE emitente.cod-emitente = analiseOCord.cod-emitente NO-ERROR.
        FIND ITEM NO-LOCK WHERE ITEM.it-codigo = analiseOCord.it-codigo NO-ERROR.

        CREATE ttAnaliseOCord.
        BUFFER-COPY analiseOCord TO ttAnaliseOCord
            ASSIGN ttAnaliseOCord.nome-emit = IF AVAIL emitente THEN emitente.nome-emit ELSE ''
                   ttAnaliseOCord.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ''.

        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.numero-ordem = analiseOCord.numero-ordem:
            CREATE ttAnaliseOCpar.
            BUFFER-COPY prazo-compra TO ttAnaliseOCpar
                ASSIGN ttAnaliseOCpar.desc-sit = {ininc/i02in274.i 4 prazo-compra.situacao}.
        END.

    END.
END.

{&open-query-brPedido}
{&open-query-brOrdem}
{&open-query-brParcela}

APPLY 'value-changed' TO brPedido IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-resumo B-table-Win 
PROCEDURE pi-inicializa-resumo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_rowid AS ROWID NO-UNDO.

FIND analiseOCcenar NO-LOCK WHERE ROWID(analiseOCcenar) = p_rowid NO-ERROR.

ASSIGN r-cenario = IF AVAIL analiseOCcenar THEN ROWID(analiseOCcenar) ELSE ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "it-codigo" "analiseOCped" "it-codigo"}
  {src/adm/template/sndkycas.i "cod-emitente" "analiseOCped" "cod-emitente"}
  {src/adm/template/sndkycas.i "cod-fabricante" "analiseOCped" "cod-fabricante"}
  {src/adm/template/sndkycas.i "cod-estabel" "analiseOCped" "cod-estabel"}
  {src/adm/template/sndkycas.i "cod-cond-pag" "analiseOCped" "cod-cond-pag"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttAnaliseOCped"}
  {src/adm/template/snd-list.i "ttAnaliseOCpar"}
  {src/adm/template/snd-list.i "ttAnaliseOCord"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnc_Frete B-table-Win 
FUNCTION fnc_Frete RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE fn_TipoFrete AS CHAR NO-UNDO.

  CASE analiseOCped.frete:
      WHEN 1 THEN ASSIGN fn_TipoFrete = 'Pago'.
      WHEN 2 THEN ASSIGN fn_TipoFrete = 'A Pagar'.
      OTHERWISE   ASSIGN fn_TipoFrete = ''.
  END CASE.
  
  RETURN fn_TipoFrete.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnc_Situacao B-table-Win 
FUNCTION fnc_Situacao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {ininc/i02in295.i 4 pedido-compr.situacao}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

