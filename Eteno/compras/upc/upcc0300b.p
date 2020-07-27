/*******************************************************************************
**  Cliente  : Eteno
**  Sistema  : EMS - 2.06
**  Programa : UPCC0300B.P
**  Objetivo : Informa‡äes espec¡ficas 
**  Data     : 01/2020
**  Autor    : Flavio Kussunoki - FKIS
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
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_sc-codigo        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_c-descricao      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_it-codigo        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_c-desc-item      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btok             AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btconfirma       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btsave           AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-frame1-cc0300b            AS HANDLE NO-UNDO.

/*** Defini‡Æo de Vari veis Locais
**************************************************************/
DEF VAR wh-fPage     AS WIDGET-HANDLE               NO-UNDO.
DEF VAR h-object     AS HANDLE                      NO-UNDO.
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.


IF p-ind-event  = 'AFTER-INITIALIZE' THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
      INPUT p-ind-Event,
      INPUT "button",    /*** Type ***/
      INPUT "btok",    /*** Name ***/
      INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
      OUTPUT  h_upcc0300b_btok).

    RUN tela-upc (INPUT p-wgh-frame,
      INPUT p-ind-Event,
      INPUT "button",    /*** Type ***/
      INPUT "btconfirma",    /*** Name ***/
      INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
      OUTPUT  h_upcc0300b_btconfirma).
    
    RUN tela-upc (INPUT p-wgh-frame,
      INPUT p-ind-Event,
      INPUT "button",    /*** Type ***/
      INPUT "btsave",    /*** Name ***/
      INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
      OUTPUT  h_upcc0300b_btsave).


    RUN tela-upc (INPUT p-wgh-frame,
      INPUT p-ind-Event,
      INPUT "fill-in",    /*** Type ***/
      INPUT "it-codigo",    /*** Name ***/
      INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
      OUTPUT  h_upcc0300b_it-codigo).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",    /*** Type ***/
                  INPUT "fPage1",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT wh-frame1-cc0300b).


    RUN tela-upc (INPUT wh-frame1-cc0300b,
      INPUT p-ind-Event,
      INPUT "fill-in",    /*** Type ***/
      INPUT "sc-codigo",    /*** Name ***/
      INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
      OUTPUT  h_upcc0300b_sc-codigo).

    RUN tela-upc(INPUT wh-frame1-cc0300b ,
      INPUT p-ind-event,
      INPUT 'fill-in',
      INPUT 'c-descricao',
      INPUT NO,
      OUTPUT h_upcc0300b_c-descricao).


END.

IF p-ind-event = "before-save-record" THEN DO:  
    IF VALID-HANDLE(h_upcc0300b_it-codigo) THEN DO:

    
        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = h_upcc0300b_it-codigo:SCREEN-VALUE NO-ERROR.

        IF ITEM.ge-codigo = 99 THEN DO:
            IF VALID-HANDLE(h_upcc0300b_sc-codigo) THEN DO:
                FIND FIRST usuar-ccusto NO-LOCK WHERE usuar-ccusto.cod-usuario = v_cod_usuar_corren
                                                AND   usuar-ccusto.sc-codigo   = h_upcc0300b_sc-codigo:SCREEN-VALUE NO-ERROR.

                IF NOT avail usuar-ccusto THEN DO:
                               RUN utp/ut-msgs(INPUT "show",
                            INPUT 17006,
                            INPUT "Centro de Custo nao pertence ao usuario").
                           RETURN.
 
                END.
           END.
       END.
    END.
END.

PROCEDURE pi-acha-handle:
    DEF INPUT  PARAMETER c-objeto AS CHARACTER NO-UNDO.
    DEF INPUT  PARAMETER c-nome   AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAMETER h-campo  AS HANDLE    NO-UNDO.
   

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD
           h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:NAME = c-nome THEN DO:
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


PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):             
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    RETURN "OK".
END PROCEDURE.

