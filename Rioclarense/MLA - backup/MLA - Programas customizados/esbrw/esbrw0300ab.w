&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-pesquisa 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z02IN172 2.00.00.052 } /*** 010052 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z02IN172 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{cdp/cdcfgmat.i}
/* Parameters Definitions ---                                           */

def new global shared var gr-item as rowid no-undo.

/* Local Variable Definitions ---                                       */
def var v-row-table     as rowid no-undo.

def var h-detalhe as handle no-undo.
def var i-compr-fabric as int initial 3   no-undo.
def var l-cancelado    as log no-undo.
def var l-ativo        as log initial yes no-undo.
def var l-auto         as log initial yes no-undo.
def var l-todas        as log initial yes no-undo.
def var l-obsoleto     as log initial yes no-undo.
def var p-item         as rowid           no-undo.
def var i-class        as integer         no-undo.
def var c-item-ini     as char            no-undo.
def var c-item-fim     as char            no-undo.
def var c-desc-ini     as char            no-undo.
def var c-desc-fim     as char            no-undo.
def var c-familia-ini  as char            no-undo.
def var c-familia-fim  as char            no-undo.
def var c-fam-coml-ini as char            no-undo.
def var c-fam-coml-fim as char            no-undo.
def var i-ge-cod-ini   as int  init 0     no-undo.
def var i-ge-cod-fim   as int  init 99    no-undo.
def var c-compl-ini    as char            no-undo.
def var c-compl-fim    as char            no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-zoom

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-implantar bt-narrativa ~
bt-filtro bt-pend bt-carac bt-detalhar bt-ok bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-pesquisa AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b01in296 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b03in172 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b14in178 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b17in178 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b60in172 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b11di095 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-carac 
     LABEL "Carac T�cn" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-desc 
     LABEL "Descri��o" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-detalhar 
     LABEL "Detalhar" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-filtro 
     LABEL "Filtro" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-implantar 
     LABEL "Implantar" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-narrativa 
     LABEL "Narrativa" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-pend 
     LABEL "Pend�ncias" 
     SIZE 12 BY 1.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 88 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-zoom
     bt-implantar AT ROW 14.83 COL 2
     bt-narrativa AT ROW 14.83 COL 14
     bt-filtro AT ROW 14.83 COL 26
     bt-pend AT ROW 14.83 COL 38
     bt-carac AT ROW 14.83 COL 50
     bt-desc AT ROW 14.83 COL 62
     bt-detalhar AT ROW 14.83 COL 78
     bt-ok AT ROW 16.33 COL 3
     bt-cancela AT ROW 16.33 COL 14
     bt-ajuda AT ROW 16.33 COL 79
     rt-button AT ROW 16.08 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         DEFAULT-BUTTON bt-ok CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 5
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-pesquisa ASSIGN
         HIDDEN             = YES
         TITLE              = "Pesquisa de Itens"
         HEIGHT             = 16.63
         WIDTH              = 90.72
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 141.57
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 141.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-pesquisa 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-pesqui.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-pesquisa
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-zoom
                                                                        */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-zoom       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-desc IN FRAME f-zoom
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-pesquisa)
THEN w-pesquisa:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-pesquisa w-pesquisa
ON END-ERROR OF w-pesquisa /* Pesquisa de Itens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-pesquisa w-pesquisa
ON WINDOW-CLOSE OF w-pesquisa /* Pesquisa de Itens */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-zoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-zoom w-pesquisa
ON GO OF FRAME f-zoom
DO:
  run pi-go.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-pesquisa
ON CHOOSE OF bt-ajuda IN FRAME f-zoom /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-pesquisa
ON CHOOSE OF bt-cancela IN FRAME f-zoom /* Cancelar */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carac w-pesquisa
ON CHOOSE OF bt-carac IN FRAME f-zoom /* Carac T�cn */
DO:
    run cdp/cd9007.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desc w-pesquisa
ON CHOOSE OF bt-desc IN FRAME f-zoom /* Descri��o */
DO:
    def var c-palavra  as char no-undo.
    def var l-cancelou as logi no-undo.

    DEF VAR i-cont    AS INT  NO-UNDO.

    RUN get-attribute IN h_b03in172 (INPUT "palavra":U).
    assign c-palavra = return-value.
   
    ASSIGN c-palavra = REPLACE(c-palavra, CHR(126), CHR(34)).

    run cdp/cd0204i.w (input-output c-palavra, output l-cancelou).

 /* Foi implementada a consist�ncia abaixo para que n�o ocorra erro quando o usu�rio digitar ',' (v�rgula)
    ou '"' (aspas duplas). O Progress identifica estes caracteres como sendo terminadores no comando CONTAINS
    por isso n�o deve ser permitido o uso de '"' (aspas duplas) devendo ser substitu�do por branco bem como a 
    vari�vel C-PALAVRA deve ser coloca entre aspas para que seja poss�vel utilizar ',' (v�rgula). 
    FO que tratou esta situa��o: 1146.650  */
    /*REPLACE(c-palavra, '"', "~~").*/

    DO i-cont = 1 TO LENGTH(c-palavra):
       IF SUBSTRING(c-palavra,I-CONT,1) = CHR(34) THEN
          ASSIGN SUBSTRING(c-palavra,i-CONT,1) = CHR(126).
    END.
    ASSIGN c-palavra = '"' + c-palavra + '"'.   

    IF  l-cancelou = no then do:
        RUN set-attribute-list IN h_b03in172 (INPUT "palavra=":U + string(c-palavra)).
        ASSIGN c-palavra = REPLACE (c-palavra, CHR(126), CHR(126) + CHR(34)).
        RUN dispatch IN h_b03in172 ('open-query':U).
        /* RUN select-page(2). */
        RUN select-page(1).        
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar w-pesquisa
ON CHOOSE OF bt-detalhar IN FRAME f-zoom /* Detalhar */
DO:

   RUN get-attribute ('current-page').
   case return-value:
       when "1" then
          RUN pi-rowid IN h_b03in172 (OUTPUT p-item).
       when "2" then
          RUN pi-rowid IN h_b14in178 (OUTPUT p-item).
       when "3" then
          RUN pi-rowid IN h_b60in172 (OUTPUT p-item).
       when "4" then
          RUN pi-rowid IN h_b01in296 (OUTPUT p-item).
       when "5" then
          RUN pi-rowid IN h_b17in178 (OUTPUT p-item).
       when "6" then
          run pi-rowid in h_b11di095 (output p-item).
   end.

   if  not can-find(item where rowid(item) = p-item) then
       return no-apply.
   {&window-name}:sensitive = no.
   assign gr-item = p-item.
   run enp/en0703.w.
   {&window-name}:sensitive = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro w-pesquisa
ON CHOOSE OF bt-filtro IN FRAME f-zoom /* Filtro */
DO:
    run get-attribute ('current-page').  

    if return-value = "1" then
       run pi-retorna-classificacao in h_b03in172 (output i-class).
    else
        assign i-class = 0.    

    /** FO 1316.609 - UPC - Inicializar zoom somente com itens ativos **/                              
    RUN pi-upc (INPUT "ITEM-ATIVO":U,     
                INPUT "BT-FILTRO":U,      
                INPUT ?,                  
                INPUT ?,                  
                INPUT "item",             
                INPUT ?).                 
                                          
    IF RETURN-VALUE = "ATUALIZA":U THEN     
       ASSIGN l-auto = NO                 
              l-todas = NO                
              l-obsoleto = NO.            
    /** FIM FO 1316.609 ***/  

    run cdp/cd9020.w (input-output i-compr-fabric,
                      input-output l-ativo,
                      input-output l-auto,
                      input-output l-todas,
                      input-output l-obsoleto,
                      input-output c-item-ini,
                      input-output c-item-fim,
                      input-output c-desc-ini,
                      input-output c-desc-fim,
                      input-output c-familia-ini,
                      input-output c-familia-fim,
                      input-output c-fam-coml-ini,
                      input-output c-fam-coml-fim,
                      input-output i-ge-cod-ini,
                      input-output i-ge-cod-fim,
                      input-output c-compl-ini,
                      input-output c-compl-fim,
                      input        i-class,                      
                      output       l-cancelado).

    if  l-cancelado = no then do:
        run pi-recebe-var in h_b03in172 (input i-compr-fabric,
                                         input l-ativo,
                                         input l-auto,
                                         input l-todas,
                                         input l-obsoleto,
                                         input c-item-ini,
                                         input c-item-fim,
                                         input c-desc-ini,
                                         input c-desc-fim,
                                         input c-familia-ini,
                                         input c-familia-fim,
                                         input c-fam-coml-ini,
                                         input c-fam-coml-fim,
                                         input i-ge-cod-ini,
                                         input i-ge-cod-fim,
                                         input c-compl-ini,
                                         input c-compl-fim).

        if  valid-handle(h_b01in296) then do:
            run pi-filtra-zoom in h_b01in296 (input i-compr-fabric,
                                              input l-ativo,
                                              input l-auto,
                                              input l-todas,
                                              input l-obsoleto).


            RUN dispatch IN h_b01in296 ('open-query':U).                                        
        end.
    end.
         /* Chamada EPC */
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
       RUN VALUE(c-nom-prog-upc-mg97) (INPUT "TRIGGER-CHOOSE":U,
                                       INPUT "BT-FILTRO":U,
                                       INPUT THIS-PROCEDURE,
                                       INPUT FRAME {&FRAME-NAME}:HANDLE,
                                       INPUT STRING(l-ativo,"Y/N") + "|" + STRING(l-auto,"Y/N") + "|" + STRING(l-todas,"Y/N") + "|" + STRING(l-obsoleto,"Y/N"),
                                       INPUT ?).
    END.
   /* FIM da EPC */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-implantar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-implantar w-pesquisa
ON CHOOSE OF bt-implantar IN FRAME f-zoom /* Implantar */
DO:
     {include/i-implan.i cdp/cd0204.w h_b03in172 h_b14in178 h_b60in172 h_b01in296 h_b17in178} 
/*   Devem ser passados os handles de todos os browsers do programa  */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-narrativa w-pesquisa
ON CHOOSE OF bt-narrativa IN FRAME f-zoom /* Narrativa */
DO:
    RUN get-attribute ('current-page').
    if  return-value <> '2' and
        return-value <> '5' then do:
        case return-value:
             when "1" then
                RUN pi-rowid IN h_b03in172 (OUTPUT p-item).
             when "3" then
                RUN pi-rowid IN h_b60in172 (OUTPUT p-item).
             when "4" then
                RUN pi-rowid IN h_b01in296 (OUTPUT p-item).
        end.
        if  not can-find(item where rowid(item) = p-item) then
            return no-apply.
        run cdp/cd9001.w (input p-item).
    end.
    else
        run cdp/cd9014.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pend w-pesquisa
ON CHOOSE OF bt-pend IN FRAME f-zoom /* Pend�ncias */
DO:
    run cdp/cd9006.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-pesquisa
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-pesquisa 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-pesquisa  _ADM-CREATE-OBJECTS
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
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Item|Item-Fornec|Carac Tec|Pend�ncias|Item-FornecII|Cliente' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.17 , 1.57 ) NO-ERROR.
       RUN set-size IN h_folder ( 13.67 , 88.57 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inbrw/b03in172.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b03in172 ).
       RUN set-position IN h_b03in172 ( 2.58 , 2.72 ) NO-ERROR.
       /* Size in UIB:  ( 11.25 , 84.57 ) */

       /* Links to SmartBrowser h_b03in172. */
       RUN add-link IN adm-broker-hdl ( h_b03in172 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b03in172 ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inbrw/b14in178.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = it-codigo':U ,
             OUTPUT h_b14in178 ).
       RUN set-position IN h_b14in178 ( 2.50 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 12.00 , 84.57 ) */

       /* Links to SmartBrowser h_b14in178. */
       RUN add-link IN adm-broker-hdl ( h_b14in178 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b14in178 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inbrw/b60in172.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b60in172 ).
       RUN set-position IN h_b60in172 ( 3.13 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.79 , 82.29 ) */

       /* Links to SmartBrowser h_b60in172. */
       RUN add-link IN adm-broker-hdl ( h_b60in172 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b60in172 ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inbrw/b01in296.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = it-codigo':U ,
             OUTPUT h_b01in296 ).
       RUN set-position IN h_b01in296 ( 2.46 , 4.29 ) NO-ERROR.
       /* Size in UIB:  ( 11.83 , 84.14 ) */

       /* Links to SmartBrowser h_b01in296. */
       RUN add-link IN adm-broker-hdl ( h_b01in296 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b01in296 ,
             h_folder , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inbrw/b17in178.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b17in178 ).
       RUN set-position IN h_b17in178 ( 2.75 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.75 , 84.57 ) */

       /* Links to SmartBrowser h_b17in178. */
       RUN add-link IN adm-broker-hdl ( h_b17in178 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b17in178 ,
             h_folder , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dibrw/b11di095.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b11di095 ).
       RUN set-position IN h_b11di095 ( 2.75 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.75 , 84.57 ) */

       /* Links to SmartBrowser h_b17in178. */
       RUN add-link IN adm-broker-hdl ( h_b11di095 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b11di095 ,
             h_folder , 'AFTER':U ).
    END. /* Page 6 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-pesquisa  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-pesquisa  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-pesquisa)
  THEN DELETE WIDGET w-pesquisa.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-pesquisa  _DEFAULT-ENABLE
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
  ENABLE rt-button bt-implantar bt-narrativa bt-filtro bt-pend bt-carac 
         bt-detalhar bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-zoom IN WINDOW w-pesquisa.
  {&OPEN-BROWSERS-IN-QUERY-f-zoom}
  VIEW w-pesquisa.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page w-pesquisa 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  do with frame {&frame-name}:
      run get-attribute ('current-page').
      assign bt-filtro:sensitive = return-value = '1' or return-value = '4'.
      if  return-value <> '1' then
          assign bt-desc:sensitive = no.
      else
          if  valid-handle(h_b03in172) then do:
              run get-attribute IN h_b03in172 (INPUT "descricao":U).
              assign bt-desc:sensitive in frame {&frame-name} = return-value = "yes".          
          end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-pesquisa 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-pesquisa 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-pesquisa 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

{utp/ut9000.i "Z02IN172" "2.00.00.050"}

   assign c-item-fim     = fill ("Z", 16)
          c-desc-fim     = fill ("Z", 60)
          c-familia-fim  = fill ("Z", 8)
          c-fam-coml-fim = fill ("Z", 8)
          c-compl-fim    = fill ("Z", 20).


  /* Dispatch standard ADM method.*/
  &IF '{&bf_mat_versao_ems}' < '2.05' &THEN
     RUN delete-folder-page IN h_folder (INPUT 5).
  &ENDIF


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*Desabilita o bot�o detalhar se o m�dulo Engenharia n�o estiver implantado*/

  find first param-global no-lock no-error.
  if avail param-global and param-global.modulo-en = yes then do:
     assign bt-detalhar:sensitive in frame {&frame-name} = yes.
  end.  
  else do:
    assign bt-detalhar:sensitive in frame {&frame-name} = no.
  end.

  assign bt-implantar:sensitive in frame {&frame-name} = l-implanta
         l-implanta = no.

  run init-pages ("1").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc w-pesquisa 
PROCEDURE pi-upc :
/*------------------------------------------------------------------------------
** UPC Especifica
** Podem ser passados parametros para ela afim de reutilizar o codigo
** se houver necessidade.    
------------------------------------------------------------------------------*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:FILE-NAME.    

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME {&FRAME-NAME}:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).
        

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:

        run value(c-nom-prog-appc-mg97) (input p-ind-event,
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME {&FRAME-NAME}:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).

    end.

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then do:
        run value(c-nom-prog-upc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME {&FRAME-NAME}:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-pesquisa 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm/objects/folder.w *RTB-SmObj* ".
  RUN "inbrw/b03in172.w *RTB-SmObj* ".
  RUN "inbrw/b14in178.w *RTB-SmObj* ".
  RUN "inbrw/b60in172.w *RTB-SmObj* ".
  RUN "inbrw/b01in296.w *RTB-SmObj* ".
  RUN "inbrw/b17in178.w *RTB-SmObj* ".
  RUN "dibrw/b11di095.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-pesquisa  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-pesquisa 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  case entry(1, p-state, "|"):
      when 'New-Line':U then do:
          if  num-entries(p-state, "|":U) > 1 then
              assign v-row-table = to-rowid(entry(2, p-state, "|":U)).
          else
              assign v-row-table = ?.
      end.
      when "descricao":U then do:
          run get-attribute IN h_b03in172 (INPUT "descricao":U).
          assign bt-desc:sensitive in frame {&frame-name} = return-value = "yes".
      end.
  end.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

