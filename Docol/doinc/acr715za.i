/*Temp-table 1:  conter  os dados dos t¡tulos/movimentos a serem estornados/cancelados.*/

def temp-table tt_integr_acr_estorn_cancel no-undo
    field ttv_ind_niv_operac_acr           as character format "X(12)" label "N¡vel Opera‡Æo" column-label "N¡vel Opera‡Æo"
    field ttv_ind_tip_operac_acr           as character format "X(15)" label "Tipo Opera‡Æo" column-label "Tipo Opera‡Æo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_id_movto_tit_acr         ascending.

/*Temp-table 2:  conter  as informa‡äes para tratamento de erros.*/

def temp-table tt_log_erros_estorn_cancel no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_id_movto_tit_acr         ascending
          ttv_num_mensagem                 ascending.
