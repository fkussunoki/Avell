/*******************************************************************************
**  Cliente  : Rioclarense
**  Sistema  : EMS - 2.06
**  Programa : UPCC0300B.P
**  Objetivo : Informa‡äes espec¡ficas 
**  Data     : 02/2014
**  Autor    : Joao Tagliatti - Tauil
**  Versao   : 2.06.00.000
*******************************************************************************/

/*** Parƒmetros de recep‡Æo da UPC
**************************************************************/
DEF INPUT PARAMETER p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAMETER p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.

/*** Defini‡Æo de Vari veis Globais
**************************************************************/
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_nome-abrev        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_ppm_nome-abrev    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_ppi_Zoom_Pedidos  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_ppi_Zoom_Clientes AS HANDLE NO-UNDO.

/*** Defini‡Æo de Vari veis Locais
**************************************************************/
DEF VAR wh-fPage     AS WIDGET-HANDLE               NO-UNDO.
DEF VAR h-object     AS HANDLE                      NO-UNDO.
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
DEF VAR v_lotacao AS char.


FIND FIRST mla-usuar-aprov NO-LOCK WHERE mla-usuar-aprov.cod-usuar = v_cod_usuar_corren NO-ERROR.

IF AVAIL mla-usuar-aprov THEN

    ASSIGN v_lotacao = mla-usuar-aprov.cod-lotacao.

/* MESSAGE "p-ind-event"   STRING(p-ind-event)  SKIP               */
/*         "p-ind-object"  STRING(p-ind-object) SKIP               */
/*         "p-wgh-object"  STRING(p-wgh-object) SKIP               */
/*         "p-wgh-frame"   STRING(p-wgh-frame)  SKIP               */
/*         "p-cod-table"   STRING(p-cod-table)  SKIP               */
/*         "p-row-table"   STRING(p-row-table)  SKIP               */
/*         "p-wgh-object:FILE-NAME" STRING(p-wgh-object:FILE-NAME) */
/*         VIEW-AS ALERT-BOX.                                      */

if  (p-ind-event = "AFTER-INITIALIZE" 
     AND v_lotacao   <> "10401") THEN do:




    /* Encontra a fPage1 */
    assign h_frame = p-wgh-frame:first-child.
    assign h_frame = h_frame:first-child.

    do  while valid-handle(h_frame):
        if  h_frame:type <> "field-group" then do:
             
            if  h_frame:name = "it-codigo" then do:
                assign h_dt-vencim = h_frame.


                ON 'MOUSE-SELECT-DBLCLICK':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b3.p.


                ON 'f3':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b3.p.

            end.

            if  h_frame:name = "sc-codigo" then do:
                assign h_dt-vencim:SCREEN-VALUE = v_lotacao.

            END.

            assign h_frame = h_frame:next-sibling.
        end.
        else
            assign h_frame = h_frame:first-child.

            
        END.
    
end.

 /*IF VALID-HANDLE( wh-bt-conf) THEN   DO:     
    wh-bt-conf:SENSITIVE = TRUE.
    wh-bt-conf:MOVE-TO-TOP().
 END.
                   
 IF VALID-HANDLE(h-btconf) THEN
    ASSIGN h-btconf:SENSITIVE = NO.

 */



IF p-ind-event  = 'AFTER-INITIALIZE' AND
   p-ind-object = 'CONTAINER' THEN DO:

    RUN pi-acha-handle (INPUT "nome-abrev", OUTPUT h_upcc0300b_nome-abrev).

    IF VALID-HANDLE(h_upcc0300b_nome-abrev) THEN DO:

        ON 'F6':U OF h_upcc0300b_nome-abrev PERSISTENT RUN upc/upcc0300b2.p.

        /* Inicio: Create a popup menu */
        CREATE MENU h_upcc0300b_ppm_nome-abrev.
        ASSIGN h_upcc0300b_ppm_nome-abrev:POPUP-ONLY = TRUE
               h_upcc0300b_nome-abrev:POPUP-MENU = h_upcc0300b_ppm_nome-abrev.

        CREATE MENU-ITEM h_upcc0300b_ppi_Zoom_Pedidos
            ASSIGN PARENT      = h_upcc0300b_ppm_nome-abrev
                   LABEL       = 'Zoom Pedidos'
                   SENSITIVE   = TRUE
                   TRIGGERS:
                       ON CHOOSE PERSISTENT RUN upc/upcc0300b1.p (INPUT 'Pedidos').
                   END TRIGGERS.
        CREATE MENU-ITEM h_upcc0300b_ppi_Zoom_Clientes
            ASSIGN PARENT      = h_upcc0300b_ppm_nome-abrev
                   LABEL       = 'Zoom Clientes'
                   SENSITIVE   = TRUE
                   TRIGGERS:
                       ON CHOOSE PERSISTENT RUN upc/upcc0300b1.p (INPUT 'Clientes').
                   END TRIGGERS.

        /* Fim: Create a popup menu */
    END. /* IF VALID-HANDLE(h_upcc0300b_nome-abrev) THEN DO: */

END.


RETURN 'OK':U.

PROCEDURE pi-acha-handle:
    DEF INPUT  PARAMETER c-objeto AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAMETER h-campo  AS HANDLE    NO-UNDO.

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD
           h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:NAME = 'fPage3' THEN DO:
            ASSIGN wh-fPage = h-object:FIRST-CHILD.
            DO WHILE VALID-HANDLE(wh-fPage):
                IF wh-fPage:NAME = c-objeto THEN ASSIGN h-campo = wh-fPage.

                IF wh-fPage:TYPE = 'field-group' THEN
                     ASSIGN wh-fPage = wh-fPage:FIRST-CHILD.
                ELSE ASSIGN wh-fPage = wh-fPage:NEXT-SIBLING.
            END.
        END.
        IF h-object:TYPE = 'field-group' THEN
             ASSIGN h-object = h-object:FIRST-CHILD.
        ELSE ASSIGN h-object = h-object:NEXT-SIBLING.
    END.
END.
