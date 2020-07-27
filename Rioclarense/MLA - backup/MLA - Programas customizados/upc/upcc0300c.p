DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-prog AS handle.
/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.
DEF NEW GLOBAL SHARED VAR H_sc-codigo       AS HANDLE NO-UNDO.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
Def New Global Shared Var h_ct-codigo      As HANDLE           No-undo.
Def New Global Shared Var h_requisitante      As HANDLE           No-undo.
DEF NEW GLOBAL SHARED VAR v_lotacao        AS CHAR NO-UNDO.
Def New Global Shared Var h_cod-comprado      As HANDLE       No-undo.

def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.



FIND FIRST ITEM WHERE ROWID(ITEM) = gr-item NO-ERROR.

ASSIGN H_sc-codigo:SCREEN-VALUE = v_lotacao.
ASSIGN h_ct-codigo:SCREEN-VALUE = item.ct-codigo.
ASSIGN h_requisitante:SCREEN-VALUE = v_cod_usuar_corren.
ASSIGN h_cod-comprado:SCREEN-VALUE = v_cod_usuar_corren.






    
