DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-prog AS handle.
/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.

Def New Global Shared Var h_dt-vencim1      As HANDLE           No-undo.
DEF NEW GLOBAL SHARED VAR H_sc-codigo      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_ct-codigo      AS HANDLE NO-UNDO.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h_requisitante   As HANDLE       No-undo.
Def New Global Shared Var h-cod-comprado   As HANDLE       No-undo.

Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
DEF NEW GLOBAL SHARED VAR v_lotacao AS CHAR NO-UNDO.


def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.


RUN esbrw\esbrw0300ab.w.

FIND FIRST ITEM WHERE ROWID(ITEM) = gr-item NO-ERROR.

ASSIGN h_dt-vencim :SCREEN-VALUE = ITEM.it-codigo.
/* ASSIGN H_sc-codigo:SCREEN-VALUE = v_lotacao. */
ASSIGN H_DT-VENCIM1:SCREEN-VALUE = item.descricao-1.
ASSIGN h_ct-codigo:SCREEN-VALUE = item.ct-codigo.
/* ASSIGN h_requisitante:SCREEN-VALUE = v_cod_usuar_corren. */
/* ASSIGN h-cod-comprado:SCREEN-VALUE = v_cod_usuar_corren. */

    
