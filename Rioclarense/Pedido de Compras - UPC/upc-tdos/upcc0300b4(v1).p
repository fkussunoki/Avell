DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-prog AS handle.
/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.

Def New Global Shared Var h_dt-vencim1      As HANDLE           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.
DEF NEW GLOBAL SHARED VAR H_sc-codigo1       AS HANDLE NO-UNDO.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
Def New Global Shared Var h-dep-almoxar   As HANDLE       No-undo.
Def New Global Shared Var h-tp-despesa   As HANDLE       No-undo.
Def New Global Shared Var h-UN      As HANDLE       No-undo.
def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.
DEF VAR h_api_ccusto AS HANDLE.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
Def New Global Shared Var h_ct-codigo      As HANDLE           No-undo.
Def New Global Shared Var h_requisitante      As HANDLE           No-undo.
DEF NEW GLOBAL SHARED VAR v_lotacao        AS CHAR NO-UNDO.
Def New Global Shared Var h-cod-comprado      As HANDLE       No-undo.

def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
DEF VAR v_log_utz_ccusto AS LOGICAL.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .


FIND FIRST ITEM WHERE ROWID(ITEM) = gr-item NO-ERROR.

FIND FIRST ITEM WHERE ITEM.it-codigo = h_dt-vencim:SCREEN-VALUE.

ASSIGN H-UN:SCREEN-VALUE = ITEM.un.

FIND FIRST ext-item-mat NO-LOCK WHERE ext-item-mat.it-codigo = ITEM.it-codigo NO-ERROR.

   run prgint\utb\utb742za.py persistent set h_api_ccusto. 
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS 2 */
                                                       input  "102", /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  item.ct-codigo,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */


IF AVAIL ext-item-mat THEN DO:
    
    
    CASE ext-item-mat.l-rateio:
        WHEN YES THEN DO:
            IF v_lotacao BEGINS "10" THEN

            ASSIGN h_ct-codigo:SCREEN-VALUE = ext-item-mat.ct-codigo-adm
                   h_sc-codigo1:SENSITIVE   = NO
                  
                   h_sc-codigo1:SCREEN-VALUE = "30200".
            
        END.
        WHEN YES THEN DO:
            IF v_lotacao BEGINS "20" THEN

            ASSIGN h_ct-codigo:SCREEN-VALUE = ext-item-mat.ct-codigo-coml
                   
                h_sc-codigo1:SENSITIVE   = NO
                h_sc-codigo1:SCREEN-VALUE = "30200".
            
        END.
        WHEN NO THEN DO:
            IF v_lotacao BEGINS "10" THEN

            ASSIGN h_ct-codigo:SCREEN-VALUE = ext-item-mat.ct-codigo-adm
.            
            ASSIGN h_sc-codigo1:SENSITIVE   = NO.
            ASSIGN H_sc-codigo1:SCREEN-VALUE = v_lotacao.
        END.
        WHEN NO THEN DO:
            IF v_lotacao BEGINS "20" THEN

            ASSIGN h_ct-codigo:SCREEN-VALUE = ext-item-mat.ct-codigo-coml
 .           
            ASSIGN h_sc-codigo1:SENSITIVE   = NO.
            ASSIGN H_sc-codigo1:SCREEN-VALUE = v_lotacao.
        END.


    END CASE.
    
END.

ELSE DO:
    ASSIGN h_ct-codigo:SCREEN-VALUE = item.ct-codigo.
    
    IF v_log_utz_ccusto THEN DO:
        
    
    ASSIGN h_sc-codigo1:SENSITIVE   = NO.
    ASSIGN H_sc-codigo1:SCREEN-VALUE = v_lotacao.
  END.

  ELSE DO:
      ASSIGN h_sc-codigo1:SENSITIVE   = NO.
      ASSIGN H_sc-codigo1:SCREEN-VALUE = ''.
      
  END.


END.

ASSIGN h_dt-vencim1:SCREEN-VALUE = ITEM.descricao-1.
ASSIGN h_requisitante:SCREEN-VALUE = v_cod_usuar_corren.
ASSIGN h-cod-comprado:SCREEN-VALUE = v_cod_usuar_corren.
ASSIGN h-dep-almoxar:SCREEN-VALUE = ITEM.deposito-pad.
ASSIGN h-tp-despesa:SCREEN-VALUE = string(ITEM.tp-desp-padrao).






    
