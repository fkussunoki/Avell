def temp-table tt_desmembramento_bem_pat_api no-undo
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequ?ncia Bem" column-label "Sequ?ncia"
    field ttv_dat_desmbrto                 as date format "99/99/9999" label "Data Desmbrto" column-label "Data Desmbrto"
    field ttv_ind_tip_desmbrto_bem_pat     as character format "X(16)"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cenÿrio Contÿbil" column-label "Cenÿrio Contÿbil"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .

def temp-table tt_desmemb_novos_bem_pat_api no-undo
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequ?ncia Bem" column-label "Sequ?ncia"
    field tta_des_bem_pat                  as character format "x(40)" label "Descri?’o Bem Pat" column-label "Descri?’o Bem Pat"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(11)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field ttv_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field ttv_val_origin_movto_bem_pat     as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original Movto" column-label "Valor Original Movto"
    field ttv_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field ttv_num_id_tt_desmbrto           as integer format ">>>9"
    field ttv_des_erro_api_movto_bem_pat   as character format "x(60)"
    field ttv_rec_id_temp_table            as recid format ">>>>>>9"
    .

def var v_hdl_api_bem_pat_desmbrto as handle no-undo.

def new shared stream s_1.

OUTPUT STREAM S_1 TO C:\DESENV\HLP.TXT.
create tt_desmembramento_bem_pat_api.
assign tt_desmembramento_bem_pat_api.ttv_num_id_tt_desmbrto         = 1
       tt_desmembramento_bem_pat_api.tta_cod_empresa                = '1'
       tt_desmembramento_bem_pat_api.tta_cod_cta_pat                = '12311004'
       tt_desmembramento_bem_pat_api.tta_num_bem_pat                = 1
       tt_desmembramento_bem_pat_api.tta_num_seq_bem_pat            = 1 
       tt_desmembramento_bem_pat_api.ttv_dat_desmbrto               = 12/10/2019
       tt_desmembramento_bem_pat_api.ttv_ind_tip_desmbrto_bem_pat   = 'Por valor'
       tt_desmembramento_bem_pat_api.ttv_cod_indic_econ             = 'real' 
       tt_desmembramento_bem_pat_api.ttv_cod_cenar_ctbl             = 'fiscal' 
       tt_desmembramento_bem_pat_api.ttv_rec_id_temp_table          = recid(tt_desmembramento_bem_pat_api).

create tt_desmemb_novos_bem_pat_api.
assign tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat                = '12311004'
       tt_desmemb_novos_bem_pat_api.tta_num_bem_pat                = 20
       tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat            = 0
       tt_desmemb_novos_bem_pat_api.tta_des_bem_pat                = 'testte'
       tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto           = 'padrao'
       tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons         = '11105'
       tt_desmemb_novos_bem_pat_api.tta_cod_estab                  = '101'
       tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc             = 'adm'
       tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat   = 3000
       tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen       = 1
       tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto         = 1
       tt_desmemb_novos_bem_pat_api.ttv_rec_id_temp_table          = recid(tt_desmemb_novos_bem_pat_api).

create tt_desmemb_novos_bem_pat_api.
assign tt_desmemb_novos_bem_pat_api.tta_cod_cta_pat                = '12311004'
       tt_desmemb_novos_bem_pat_api.tta_num_bem_pat                = 25
       tt_desmemb_novos_bem_pat_api.tta_num_seq_bem_pat            = 0
       tt_desmemb_novos_bem_pat_api.tta_des_bem_pat                = 'toscoo'
       tt_desmemb_novos_bem_pat_api.tta_cod_plano_ccusto           = 'padrao'
       tt_desmemb_novos_bem_pat_api.tta_cod_ccusto_respons         = '11105'
       tt_desmemb_novos_bem_pat_api.tta_cod_estab                  = '101'
       tt_desmemb_novos_bem_pat_api.tta_cod_unid_negoc             = 'adm'
       tt_desmemb_novos_bem_pat_api.ttv_val_origin_movto_bem_pat   = 4000
       tt_desmemb_novos_bem_pat_api.ttv_qtd_bem_pat_represen       = 1
       tt_desmemb_novos_bem_pat_api.ttv_num_id_tt_desmbrto         = 1
       tt_desmemb_novos_bem_pat_api.ttv_rec_id_temp_table          = recid(tt_desmemb_novos_bem_pat_api).

       run prgfin/fas/fas404za.py persistent set v_hdl_api_bem_pat_desmbrto (input 1).

       run pi_efetiva_desmemb_bens in v_hdl_api_bem_pat_desmbrto (input-output table tt_desmembramento_bem_pat_api,
                                                               input-output table tt_desmemb_novos_bem_pat_api).


       FOR EACH  tt_desmembramento_bem_pat_api:

           DISP  tt_desmembramento_bem_pat_api WITH 1 COL WIDTH 600.



