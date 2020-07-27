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

Def New Global Shared Var h_dt-vencim1      As HANDLE           No-undo.
Def New Global Shared Var h_sc-codigo      As HANDLE           No-undo.

Def New Global Shared Var h_sc-codigo1      As HANDLE           No-undo.
Def New Global Shared Var h_ct-codigo      As HANDLE           No-undo.
Def New Global Shared Var h_requisitante      As HANDLE           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
Def New Global Shared Var h-cod-comprado      As HANDLE       No-undo.
Def New Global Shared Var h-dep-almoxar   As HANDLE       No-undo.
Def New Global Shared Var h-tp-despesa      As HANDLE       No-undo.
Def New Global Shared Var h-UN      As HANDLE       No-undo.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
DEF NEW GLOBAL SHARED VAR H-OBJETO2       AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR H-OBJETO3       AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_lotacao       AS CHAR NO-UNDO.



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

if  (p-ind-event = "AFTER-display" 
     AND v_lotacao   <> "10401" 
     AND v_lotacao   <>  "10402"
     ) THEN do:

    /* Encontra a fPage1 */
    assign h_frame = p-wgh-frame:first-child.
    assign h_frame = h_frame:first-child.

    do  while valid-handle(h_frame):
        if  h_frame:type <> "field-group" then do:

            IF h_frame:NAME = "fpage1" THEN
            DO:
                
                IF h_frame:TYPE = "frame" THEN DO:
                    
                    ASSIGN h-objeto2 = h_frame:FIRST-CHILD.
                    
                    do  while valid-handle(h-objeto2):

                         IF  h-objeto2:TYPE <> "field-group" and
                             h-objeto2:TYPE <> "frame" THEN DO:

                             IF h-objeto2:NAME = "SC-CODIGO" THEN DO:

                                ASSIGN H_sc-codigo = H-OBJETO2.
                                ASSIGN h_sc-codigo:SCREEN-VALUE =  v_lotacao.
                             
                            END. /* sc-codigo */


                               h-objeto2 = h-objeto2:NEXT-SIBLING.
                        END. /* field-group */

                         ELSE DO:
                               h-objeto2 = h-objeto2:FIRST-CHILD.
                         END. /* else-do */

                END. /* do while */

             END. /* type frame */
            END. /* fpage1 */

/* NOVO TRECHO EM 16/08/2018 */
            IF h_frame:NAME = "fpage3" THEN
            DO:
                
                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto3 = h_frame:FIRST-CHILD.
                    
                    do  while valid-handle(h-objeto3):


                         IF  h-objeto3:TYPE <> "field-group" and
                             h-objeto3:TYPE <> "frame" THEN DO:

                             IF h-objeto3:NAME = "UN" THEN DO:

                                ASSIGN  h-UN = H-OBJETO3.
                             
                            END. /* sc-codigo */
                      END.
                   END.
                 END.
               END.

/* FIM DO NOVO TRECHO */
            IF h_frame:NAME = "fpage1" THEN
            DO:
                
                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto3 = h_frame:FIRST-CHILD.
                    
                    do  while valid-handle(h-objeto3):


                         IF  h-objeto3:TYPE <> "field-group" and
                             h-objeto3:TYPE <> "frame" THEN DO:

                             IF h-objeto3:NAME = "IT-CODIGO" THEN DO:

                                ASSIGN  h_dt-vencim = H-OBJETO3.
                             
                            END. /* sc-codigo */


                             ON 'LEAVE':U OF H_DT-VENCIM PERSISTENT RUN UPC\upcc0300b4.p.

                             ON 'tab':U OF H_DT-VENCIM PERSISTENT RUN UPC\upcc0300b4.p.

                             IF h-objeto3:NAME = "SC-CODIGO" THEN DO:

                                ASSIGN H_sc-codigo1 = H-OBJETO3.
                             
                            END. /* sc-codigo */


                             IF h-objeto3:NAME = "requisitante" THEN DO:
                                 
                                
                                 ASSIGN h_requisitante = h-objeto3.
                             END. /* requisitante */


                             IF h-objeto3:NAME = "dep-almoxar" THEN DO:
                                 
                                
                                 ASSIGN h-dep-almoxar = h-objeto3.
                             END. /* requisitante */

                             IF h-objeto3:NAME = "tp-despesa" THEN DO:
                                 
                                
                                 ASSIGN h-tp-despesa = h-objeto3.
                             END. /* requisitante */


                             IF h-objeto3:NAME = "c-desc-item" THEN DO:
                                 
                                
                                 ASSIGN h_dt-vencim1 = h-objeto3.
                             END. /* requisitante */
                             
                             IF h-objeto3:NAME = "CT-CODIGO" THEN DO:

                                ASSIGN H_ct-codigo = H-OBJETO3.

                             END. /* ct-codigo */

                             IF h-objeto3:NAME = "cod-comprado" THEN DO:

                                ASSIGN H-cod-comprado = H-OBJETO3.

                             END. /* ct-codigo */


                               h-objeto3 = h-objeto3:NEXT-SIBLING.
                        END. /* field-group */

                         ELSE DO:
                               h-objeto3 = h-objeto3:FIRST-CHILD.
                         END. /* else do */

                    END. /* do while */

                END. /* type-frame */
            END. /* f-page1 */




        if  h_frame:name = "it-codigo" then do:

                assign h_dt-vencim = h_frame.


                ON 'MOUSE-SELECT-DBLCLICK':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b3.p.


                ON 'f3':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b3.p.



            end.


            if  h_frame:name = "c-desc-item" then do:

                    assign h_dt-vencim1 = h_frame.


                end.


        assign h_frame = h_frame:next-sibling.
    end.
        ELSE DO:
                assign h_frame = h_frame:first-child.
            end.
        END.
END.

if  (p-ind-event = "AFTER-display" 
     AND v_lotacao   = "10402" 
     ) THEN do:

    /* Encontra a fPage1 */
    assign h_frame = p-wgh-frame:first-child.
    assign h_frame = h_frame:first-child.

    do  while valid-handle(h_frame):
        if  h_frame:type <> "field-group" then do:


/* NOVO TRECHO EM 16/08/2018 */
            IF h_frame:NAME = "fpage4" THEN
            DO:

                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto3 = h_frame:FIRST-CHILD.

                    do  while valid-handle(h-objeto3):


                         IF  h-objeto3:TYPE <> "field-group" and
                             h-objeto3:TYPE <> "frame" THEN DO:

                             IF h-objeto3:NAME = "UN" THEN DO:

                                ASSIGN  h-UN = H-OBJETO3.

                            END. /* sc-codigo */
                      END.
                   END.
                 END.
               END.

/* FIM DO NOVO TRECHO */

            IF h_frame:NAME = "fpage1" THEN
            DO:
                
                IF h_frame:TYPE = "frame" THEN DO:
                    
                    ASSIGN h-objeto2 = h_frame:FIRST-CHILD.
                    
                    do  while valid-handle(h-objeto2):

                         IF  h-objeto2:TYPE <> "field-group" and
                             h-objeto2:TYPE <> "frame" THEN DO:

                             IF h-objeto2:NAME = "SC-CODIGO" THEN DO:

                                ASSIGN H_sc-codigo = H-OBJETO2.
                                ASSIGN h_sc-codigo:SCREEN-VALUE = mla-usuar-aprov.cod-lotacao.
                             
                            END. /* sc-codigo */


                               h-objeto2 = h-objeto2:NEXT-SIBLING.
                        END. /* field-group */

                         ELSE DO:
                               h-objeto2 = h-objeto2:FIRST-CHILD.
                         END. /* else-do */

                END. /* do while */

             END. /* type frame */
            END. /* fpage1 */


            IF h_frame:NAME = "fpage1" THEN
            DO:
                
                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto3 = h_frame:FIRST-CHILD.
                    
                    do  while valid-handle(h-objeto3):


                         IF  h-objeto3:TYPE <> "field-group" and
                             h-objeto3:TYPE <> "frame" THEN DO:

                             ON 'LEAVE':U OF H_DT-VENCIM PERSISTENT RUN UPC\upcc0300b4.p.

                             IF h-objeto3:NAME = "requisitante" THEN DO:
                                 
                                
                                 ASSIGN h_requisitante = h-objeto3.
                             END. /* requisitante */


                             IF h-objeto3:NAME = "SC-CODIGO" THEN DO:

                                ASSIGN H_sc-codigo1 = H-OBJETO3.
                             
                            END. /* sc-codigo */


                             IF h-objeto3:NAME = "requisitante" THEN DO:
                                 
                                
                                 ASSIGN h_requisitante = h-objeto3.
                             END. /* requisitante */


                             IF h-objeto3:NAME = "dep-almoxar" THEN DO:
                                 
                                
                                 ASSIGN h-dep-almoxar = h-objeto3.
                             END. /* requisitante */

                             IF h-objeto3:NAME = "tp-despesa" THEN DO:
                                 
                                
                                 ASSIGN h-tp-despesa = h-objeto3.
                             END. /* requisitante */


                             IF h-objeto3:NAME = "c-desc-item" THEN DO:
                                 
                                
                                 ASSIGN h_dt-vencim1 = h-objeto3.
                             END. /* requisitante */
                             
                             IF h-objeto3:NAME = "CT-CODIGO" THEN DO:

                                ASSIGN H_ct-codigo = H-OBJETO3.

                             END. /* ct-codigo */

                             IF h-objeto3:NAME = "cod-comprado" THEN DO:

                                ASSIGN H-cod-comprado = H-OBJETO3.

                             END. /* ct-codigo */

                               h-objeto3 = h-objeto3:NEXT-SIBLING.
                        END. /* field-group */

                         ELSE DO:
                               h-objeto3 = h-objeto3:FIRST-CHILD.
                         END. /* else do */

                    END. /* do while */

                END. /* type-frame */
            END. /* f-page1 */




        if  h_frame:name = "it-codigo" then do:

                assign h_dt-vencim = h_frame.


                ON 'MOUSE-SELECT-DBLCLICK':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b5.p.


                ON 'f3':U OF h_dt-vencim PERSISTENT RUN upc/upcc0300b5.p.



            end.


            if  h_frame:name = "c-desc-item" then do:

                    assign h_dt-vencim1 = h_frame.


                end.


        assign h_frame = h_frame:next-sibling.
    end.
        ELSE DO:
                assign h_frame = h_frame:first-child.
            end.
        END.
END.



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
