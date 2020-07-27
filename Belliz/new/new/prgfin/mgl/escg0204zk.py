/*****************************************************************************
*****************************************************************************/

def var c-versao-prg as char initial " 5.12.16.100":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i api_demonst_ctbl_fin_sped MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def new shared temp-table tt_acumul_demonst_cadastro no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont†bil" column-label "Acumulador"
    field tta_log_zero_acumul_ctbl         as logical format "Sim/N∆o" initial no label "Zera Acumulador" column-label "Zera Acumulador"
    index tt_id                            is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_num_seq_demonst_ctbl         ascending
          tta_cod_acumul_ctbl              ascending
    .

def new shared temp-table tt_acumul_demonst_ctbl_result no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont†bil" column-label "Acumulador"
    field tta_log_zero_acumul_ctbl         as logical format "Sim/N∆o" initial no label "Zera Acumulador" column-label "Zera Acumulador"
    field ttv_val_sdo_ctbl_fim_sint_acumul as decimal format "->>,>>>,>>>,>>9.99" decimals 6
    field ttv_log_ja_procesdo              as logical format "Sim/N∆o" initial no
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    index tt_id                            is primary unique
          tta_cod_acumul_ctbl              ascending
          tta_cod_col_demonst_ctbl         ascending
          tta_num_seq_demonst_ctbl         ascending
    .

def new shared temp-table tt_ccustos_demonst no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_ccusto_pai               as Character format "x(11)" label "Centro Custo Pai" column-label "Centro Custo Pai"
    field ttv_log_proces                   as logical format "Sim/Nao" initial no label "&prc(" column-label "&prc("
    index tt_cod_ccusto_pai               
          ttv_cod_ccusto_pai               ascending
    index tt_log_proces                   
          ttv_log_proces                   ascending
    index tt_select_id                     is primary unique
          tta_cod_empresa                  ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    .

def new shared temp-table tt_col_demonst_ctbl no-undo like col_demonst_ctbl
    field ttv_rec_col_demonst_ctbl         as recid format ">>>>>>9"
    .

def temp-table tt_col_demonst_ctbl_ext no-undo
    field ttv_cod_padr_col_demonst         as character format "x(8)" label "Padr∆o Coluna"
    field ttv_cod_moed_finalid             as character format "x(10)" label "Moeda/Finalidade" column-label "Mo/Finalid"
    field ttv_num_conjto_param_ctbl        as integer format ">9" initial 0
    .

def new shared temp-table tt_compos_demonst_cadastro no-undo like compos_demonst_ctbl
    field tta_cod_proj_financ_excec        as character format "x(20)" label "Projeto Exceá∆o" column-label "Projeto Exceá∆o"
    field tta_cod_proj_financ_inicial      as character format "x(20)" label "Projeto Financ Inic" column-label "Projeto Financ Inic"
    index tt_id                           
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    .

def temp-table tt_conjto_prefer_demonst no-undo
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field tta_num_conjto_param_ctbl        as integer format ">9" initial 1 label "Conjunto ParÉmetros" column-label "Conjunto ParÉmetros"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_apres       as character format "x(10)" label "Finalid Apresentaá∆o" column-label "Finalid Apresent"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_cod_unid_organ_inic          as character format "x(3)" label "UO Inicial" column-label "UO Unicial"
    field tta_cod_unid_organ_fim           as character format "x(3)" label "UO Final" column-label "UO FInal"
    field tta_cod_estab_inic               as character format "x(3)" label "Estabelecimento" column-label "Estab Inicial"
    field tta_cod_estab_fim                as character format "x(3)" label "atÇ" column-label "Estabel Final"
    field tta_cod_unid_negoc_inic          as character format "x(3)" label "Unid Negoc" column-label "UN Inicial"
    field tta_cod_unid_negoc_fim           as character format "x(3)" label "atÇ" column-label "UN Final"
    field tta_cod_cenar_orctario           as character format "x(8)" label "Cen†rio Oráament†rio" column-label "Cen†rio Oráamen"
    field tta_cod_unid_orctaria            as character format "x(8)" label "Unid Oráament†ria" column-label "Unid Oráament†ria"
    field tta_cod_vers_orcto_ctbl          as character format "x(10)" label "Vers∆o Oráamento" column-label "Vers∆o Oráamento"
    field tta_num_seq_orcto_ctbl           as integer format ">>>>>>>>9" initial 0 label "Seq Orcto Cont†bil" column-label "Seq Orcto Cont†bil"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_cod_cta_ctbl_inic            as character format "x(20)" label "Conta Contabil" column-label "Conta Contab Inicial"
    field tta_cod_cta_ctbl_fim             as character format "x(20)" label "atÇ" column-label "Conta Cont†bil Final"
    field tta_cod_cta_ctbl_prefer_pfixa    as character format "x(20)" label "Parte Fixa" column-label "Parte Fixa"
    field tta_cod_cta_ctbl_prefer_excec    as character format "x(20)" label "Exceá∆o" column-label "Exceá∆o"
    field tta_cod_unid_organ_prefer_inic   as character format "x(3)" label "UO Prefer Inic" column-label "UO Prefer Inic"
    field tta_cod_unid_organ_prefer_fim    as character format "x(3)" label "UO Prefer Fim" column-label "UO Prefer Fim"
    field tta_cod_ccusto_inic              as Character format "x(11)" label "Centro Custo" column-label "Centro Custo Inicial"
    field tta_cod_ccusto_fim               as Character format "x(11)" label "atÇ" column-label "Centro Custo Final"
    field tta_cod_ccusto_pfixa             as character format "x(11)" initial "..........." label "Parte Fixa CCusto" column-label "Parte Fixa CCusto"
    field tta_cod_ccusto_excec             as character format "x(11)" initial "..........." label "Centro Custo Exceá∆o" column-label "Centro Custo Exceá∆o"
    field tta_cod_proj_financ_inicial      as character format "x(20)" label "Projeto Financ Inic" column-label "Projeto Financ Inic"
    field tta_cod_proj_financ_fim          as character format "x(20)" label "Projeto Final" column-label "Projeto Final"
    field tta_cod_proj_financ_pfixa        as character format "x(20)" initial "################################" label "Parte Fixa" column-label "Parte Fixa"
    field tta_cod_proj_financ_excec        as character format "x(20)" label "Projeto Exceá∆o" column-label "Projeto Exceá∆o"
    index tt_conjto_prefer_id              is primary unique
          tta_cod_usuario                  ascending
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
          tta_num_conjto_param_ctbl        ascending
    .

def new shared temp-table tt_controla_analise_vertical no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont†bil" column-label "Acumulador"
    field ttv_cod_linha                    as character format "x(730)"
    field ttv_val_sdo_ctbl_analis_vert     as decimal format "->>,>>>,>>>,>>9.99" decimals 6
    index tt_id                            is primary unique
          tta_cod_col_demonst_ctbl         ascending
          tta_cod_acumul_ctbl              ascending
          ttv_cod_linha                    ascending
    .

def new shared temp-table tt_cta_ctbl_demonst no-undo
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field ttv_cod_cta_ctbl_pai             as character format "x(20)" label "Conta Ctbl Pai" column-label "Conta Ctbl Pai"
    field ttv_log_consid_apurac            as logical format "Sim/N∆o" initial no
    field tta_ind_espec_cta_ctbl           as character format "X(10)" initial "Anal°tica" label "EspÇcie Conta" column-label "EspÇcie"
    index tt_cod_cta_ctbl_pai             
          tta_cod_plano_cta_ctbl           ascending
          ttv_cod_cta_ctbl_pai             ascending
    index tt_select_id                     is primary unique
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    .

def temp-table tt_demonst_ctbl_fin no-undo
    field ttv_num_nivel                    as integer format ">>>>,>>9"
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_rec_item_demonst_ctbl_video  as recid format ">>>>>>9"
    field ttv_rec_demonst_ctbl_video       as recid format ">>>>>>9"
    field ttv_cod_campo_1                  as character format "x(100)" column-label "Campo 1"
    field ttv_cod_campo_2                  as character format "x(100)"
    field ttv_cod_campo_3                  as character format "x(100)"
    field ttv_cod_campo_4                  as character format "x(100)"
    field ttv_cod_campo_5                  as character format "x(100)"
    field ttv_cod_campo_6                  as character format "x(100)"
    field ttv_cod_campo_7                  as character format "x(100)"
    field ttv_cod_campo_8                  as character format "x(100)"
    field ttv_cod_campo_9                  as character format "x(100)"
    field ttv_cod_campo_10                 as character format "x(100)"
    field ttv_cod_campo_11                 as character format "x(100)"
    field ttv_cod_campo_12                 as character format "x(100)"
    field ttv_cod_campo_13                 as character format "x(100)"
    field ttv_cod_campo_14                 as character format "x(100)"
    field ttv_cod_campo_15                 as character format "x(100)"
    field ttv_log_expand                   as logical format "Sim/N∆o" initial yes
    field ttv_log_expand_usuar             as logical format "Sim/N∆o" initial no
    field ttv_cod_inform_princ             as character format "x(20)"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_cta_ctbl_filho           as character format "x(20)" label "Conta Cont†bil Filho" column-label "Conta Cont†bil Filho"
    field tta_cod_proj_financ_filho        as character format "x(20)" label "Projeto Filho" column-label "Projeto Filho"
    field tta_cod_ccusto_filho             as Character format "x(11)" label "Centro Custo Filho" column-label "Centro Custo Filho"
    field tta_cod_unid_negoc_filho         as character format "x(3)" label "Unid Neg¢cio Filho" column-label "Unid Neg¢cio Filho"
    field tta_cod_unid_organ_filho         as character format "x(3)" label "Unid Organiz Filho" column-label "Unid Organiz Filho"
    field ttv_des_col_demonst_video        as character format "x(100)"
    field ttv_log_expand_estab             as logical format "Sim/N∆o" initial no
    field ttv_log_apres                    as logical format "Sim/N∆o" initial yes
    field ttv_log_analit                   as logical format "Sim/N∆o" initial no label "An†litico"
    field ttv_log_tot_estrut               as logical format "Sim/N∆o" initial no
    index tt_id                            is primary unique
          ttv_log_apres                    ascending
          tta_num_seq_demonst_ctbl         ascending
    index tt_id_descending                
          ttv_log_apres                    ascending
          tta_num_seq_demonst_ctbl         descending
    index tt_recid_demonst_ctbl_video     
          ttv_rec_demonst_ctbl_video       ascending
    .

def temp-table tt_demonst_ctbl_video no-undo
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_rec_demonst_ctbl_video       as recid format ">>>>>>9"
    field ttv_cod_lin_demonst              as character format "x(2000)"
    field ttv_num_seq_item_demonst_ctbl    as integer format ">>>>,>>9"
    field ttv_rec_item_demonst_ctbl_cad    as recid format ">>>>>>9"
    field ttv_rec_item_demonst_ctbl_video  as recid format ">>>>>>9"
    field ttv_des_lista_estab              as character format "x(2000)" label "Estabelecimentos" column-label "Estabelecimentos"
    field ttv_num_nivel                    as integer format ">>>>,>>9"
    index tt_id                            is primary unique
          tta_num_seq_demonst_ctbl         ascending
    .

def temp-table tt_erros_api_demonst_lote no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    index tt_erro_id                       is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
          ttv_num_erro                     ascending
    .

def new shared temp-table tt_estrut_visualiz_ctbl_cad no-undo like estrut_visualiz_ctbl
    .

def temp-table tt_exec_rpc no-undo
    field ttv_cod_aplicat_dtsul_corren     as character format "x(3)"
    field ttv_cod_ccusto_corren            as character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_dwb_user                 as character format "x(21)" label "Usu†rio" column-label "Usu†rio"
    field ttv_cod_empres_usuar             as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_usuar              as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_funcao_negoc_empres      as character format "x(50)"
    field ttv_cod_grp_usuar_lst            as character format "x(3)" label "Grupo Usu†rios" column-label "Grupo"
    field ttv_cod_idiom_usuar              as character format "x(8)" label "Idioma" column-label "Idioma"
    field ttv_cod_modul_dtsul_corren       as character format "x(3)" label "M¢dulo Corrente" column-label "M¢dulo Corrente"
    field ttv_cod_modul_dtsul_empres       as character format "x(100)"
    field ttv_cod_pais_empres_usuar        as character format "x(3)" label "Pa°s Empresa Usu†rio" column-label "Pa°s"
    field ttv_cod_plano_ccusto_corren      as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_unid_negoc_usuar         as character format "x(3)" label "Unidade Neg¢cio" column-label "Unid Neg¢cio"
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field ttv_cod_usuar_corren_criptog     as character format "x(16)"
    field ttv_num_ped_exec_corren          as integer format ">>>>9"
    field ttv_cod_livre                    as character format "x(2000)"
    .

def new shared temp-table tt_grp_col_demonst_video no-undo
    field tta_qtd_period_relac_base        as decimal format ">9" initial 0 label "Per°odos da Base" column-label "Per°odo da Base"
    field tta_qtd_exerc_relac_base         as decimal format ">9" initial 0 label "Exerc°cios da Base" column-label "Exerc°cios da Base"
    field tta_ind_tip_relac_base           as character format "X(20)" label "Tipo Relaá∆o" column-label "Tipo Relaá∆o"
    field tta_num_conjto_param_ctbl        as integer format ">9" initial 1 label "Conjunto ParÉmetros" column-label "Conjunto ParÉmetros"
    field tta_ind_tip_val_consolid         as character format "X(18)" initial "Total" label "Tipo Valor Consolid" column-label "Tipo Valor Consolid"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_val_cotac_indic_econ         as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_cod_cta_ctbl_fim             as character format "x(20)" label "Conta Final" column-label "Final"
    field ttv_cod_cta_ctbl_ini             as character format "x(20)" label "Conta Inicial" column-label "Inicial"
    field ttv_cod_cta_prefer_excec         as character format "x(20)" initial "####################" label "Exceá∆o" column-label "Exceá∆o"
    field ttv_cod_cta_prefer_pfixa         as character format "x(20)" label "Parte Fixa" column-label "Parte Fixa"
    field ttv_cod_unid_negoc_fim           as character format "x(3)" label "atÇ" column-label "Final"
    field ttv_cod_unid_negoc_ini           as character format "x(3)" label "Unid Neg¢cio" column-label "Unid Neg"
    field ttv_cod_estab_fim                as character format "x(3)" label "atÇ" column-label "Estab Final"
    field ttv_cod_estab_inic               as character format "x(3)" label "Estab Inicial" column-label "Estab Inicial"
    field ttv_cod_unid_organ_prefer        as character format "x(3)"
    field ttv_num_period                   as integer format ">>>>,>>9" label "Per°odo Cont†bil" column-label "Per°odo Cont†bil"
    field ttv_cod_unid_organ_prefer_inic   as character format "x(3)"
    field ttv_cod_unid_organ_prefer_fim    as character format "x(3)"
    field ttv_cod_unid_organ_fim           as character format "x(3)" label "Final" column-label "Unid Organizacional"
    field ttv_cod_unid_organ_ini           as character format "x(3)" label "UO Inicial" column-label "Unid Organizacional"
    field ttv_cod_cenar_orctario           as character format "x(8)" label "Cenar Orctario" column-label "Cen†rio Oráament†rio"
    field ttv_cod_vers_orcto_ctbl          as character format "x(10)" label "Vers∆o Oráamento" column-label "Vers∆o Oráamento"
    field ttv_cod_finalid_econ             as character format "x(10)" label "Finalidade Econìmica" column-label "Finalidade Econìmica"
    field ttv_dat_fim_period               as date format "99/99/9999" label "Fim Per°odo"
    field ttv_cod_plano_ccusto             as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_ccusto_inic              as character format "x(11)" label "C.Custo Inicial" column-label "C.Custo Inicial"
    field ttv_cod_ccusto_fim               as Character format "x(11)" label "atÇ" column-label "Centro Custo"
    field ttv_cod_ccusto_prefer_pfixa      as character format "x(11)" label "Parte Fixa"
    field ttv_cod_ccusto_prefer_excec      as character format "x(11)" label "Exceá∆o"
    field ttv_cod_proj_financ_inic         as character format "x(20)" label "Projeto Inicial"
    field ttv_cod_proj_financ_fim          as character format "x(20)" label "Projeto Final" column-label "Projeto"
    field ttv_cod_proj_financ_prefer_pfixa as character format "x(20)" label "Parte Fixa"
    field ttv_cod_proj_financ_prefer_excec as character format "x(20)" label "Exceá∆o"
    field tta_cod_unid_orctaria            as character format "x(8)" label "Unid Oráament†ria" column-label "Unid Oráament†ria"
    field tta_num_seq_orcto_ctbl           as integer format ">>>>>>>>9" initial 0 label "Seq Orcto Cont†bil" column-label "Seq Orcto Cont†bil"
    field ttv_cod_exec_period_1            as character format "x(6)"
    field ttv_cod_exec_period_2            as character format "x(6)"
    field ttv_des_col_demonst              as character format "x(40)"
    index tt_id                            is primary unique
          tta_qtd_period_relac_base        ascending
          tta_qtd_exerc_relac_base         ascending
          tta_ind_tip_relac_base           ascending
          tta_num_conjto_param_ctbl        ascending
          tta_ind_tip_val_consolid         ascending
    .

def new shared temp-table tt_item_demonst_ctbl_cadastro no-undo like item_demonst_ctbl
    field ttv_log_ja_procesdo              as logical format "Sim/N∆o" initial no
    field ttv_rec_item_demonst_ctbl_cad    as recid format ">>>>>>9"
    index tt_id                            is primary unique
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    index tt_recid                        
          ttv_rec_item_demonst_ctbl_cad    ascending
    .

def new shared temp-table tt_item_demonst_ctbl_video no-undo
    field ttv_val_seq_demonst_ctbl         as decimal format ">>>,>>9.99" decimals 2
    field ttv_rec_item_demonst_ctbl_cad    as recid format ">>>>>>9"
    field ttv_rec_item_demonst_ctbl_video  as recid format ">>>>>>9"
    field ttv_cod_chave_1                  as character format "x(20)"
    field ttv_cod_chave_2                  as character format "x(20)"
    field ttv_cod_chave_3                  as character format "x(20)"
    field ttv_cod_chave_4                  as character format "x(20)"
    field ttv_cod_chave_5                  as character format "x(20)"
    field ttv_cod_chave_6                  as character format "x(20)"
    field ttv_des_chave_1                  as character format "x(40)"
    field ttv_des_chave_2                  as character format "x(40)"
    field ttv_des_chave_3                  as character format "x(40)"
    field ttv_des_chave_4                  as character format "x(40)"
    field ttv_des_chave_5                  as character format "x(40)"
    field ttv_des_chave_6                  as character format "x(40)"
    field tta_des_tit_ctbl                 as character format "x(40)" label "T°tulo Cont†bil" column-label "T°tulo Cont†bil"
    field ttv_des_valpres                  as character format "x(40)"
    field ttv_log_tit_ctbl_vld             as logical format "Sim/N∆o" initial no
    field tta_ind_funcao_col_demonst_ctbl  as character format "X(12)" initial "Impress∆o" label "Funá∆o Coluna" column-label "Funá∆o Coluna"
    field tta_ind_orig_val_col_demonst     as character format "X(12)" initial "T°tulo" label "Origem Valores" column-label "Origem Valores"
    field tta_cod_format_col_demonst_ctbl  as character format "x(40)" label "Formato Coluna" column-label "Formato Coluna"
    field ttv_cod_identif_campo            as character format "x(40)"
    field ttv_log_cta_sint                 as logical format "Sim/N∆o" initial no
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    index tt_id                            is primary
          ttv_cod_chave_1                  ascending
          ttv_cod_chave_2                  ascending
          ttv_cod_chave_3                  ascending
          ttv_cod_chave_4                  ascending
          ttv_cod_chave_5                  ascending
          ttv_cod_chave_6                  ascending
          ttv_val_seq_demonst_ctbl         ascending
    index tt_recid                        
          ttv_rec_item_demonst_ctbl_video  ascending
    index tt_recid_cad                    
          ttv_rec_item_demonst_ctbl_cad    ascending
    .

def new shared temp-table tt_label_demonst_ctbl_video no-undo
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_num_pos_col_demonst_ctbl     as integer format ">>>>,>>9" label "N£mero Posiá‰es Col"
    field ttv_cod_format_col_demonst_ctbl  as character format "x(40)" label "Formato Coluna" column-label "Formato Coluna"
    field ttv_des_label_col_demonst_ctbl   as character format "x(40)"
    field tta_ind_orig_val_col_demonst     as character format "X(12)" initial "T°tulo" label "Origem Valores" column-label "Origem Valores"
    index tt_label_demonst                 is primary unique
          tta_num_seq_demonst_ctbl         ascending
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

def temp-table tt_ord_col no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_des_tit_ctbl                 as character format "x(40)" label "T°tulo Cont†bil" column-label "T°tulo Cont†bil"
    index tt_id                            is primary unique
          ttv_num_seq                      ascending
    .

def temp-table tt_prefer_demonst_ctbl_1 no-undo
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field tta_cod_exerc_ctbl               as character format "9999" label "Exerc°cio Cont†bil" column-label "Exerc°cio Cont†bil"
    field tta_num_period_ctbl              as integer format ">99" initial 0 label "Per°odo Cont†bil" column-label "Per°odo"
    field tta_val_fator_div_demonst_ctbl   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Fator Divis∆o" column-label "Fator Divis∆o"
    field tta_log_consid_apurac_restdo     as logical format "Sim/N∆o" initial no label "Considera Apuraá∆o" column-label "Considera Apuraá∆o"
    field tta_log_impr_cta_sem_sdo         as logical format "Sim/N∆o" initial no label "Contas sem Saldo" column-label "Conta Sem Saldo"
    field ttv_log_impr_acum_zero           as logical format "Sim/N∆o" initial no label "Impr Acum Zerado"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_acum_cta_ctbl_sint       as logical format "Sim/N∆o" initial no label "Acum Cta SintÇtica" column-label "Acum Cta SintÇtica"
    field tta_log_unid_organ_subst         as logical format "Sim/N∆o" initial no label "Unidade Organizacion" column-label "Unidade Organizacion"
    field tta_log_unid_negoc_subst         as logical format "Sim/N∆o" initial no label "UN Substituiá∆o" column-label "UN Substituiá∆o"
    field tta_log_estab_subst              as logical format "Sim/N∆o" initial no label "Estab Substituiá∆o" column-label "Estab Substituiá∆o"
    field tta_log_ccusto_subst             as logical format "Sim/N∆o" initial no label "Centro de custo Subs" column-label "Centro de custo Subs"
    field tta_cod_unid_organ_subst         as character format "x(3)" label "UO Substituiá∆o" column-label "UO Substituiá∆o"
    field tta_cod_unid_negoc_inic_subst    as character format "x(3)" label "UN Subst Inicial" column-label "UN Subst Inicial"
    field tta_cod_unid_negoc_fim_subst     as character format "x(38)" label "UN Subst Fim" column-label "UN Subst Fim"
    field tta_cod_estab_inic_subst         as character format "x(3)" label "Estab Subst Inic" column-label "Estab Subst Inic"
    field tta_cod_estab_fim_subst          as character format "x(3)" label "Estab Subst Fim" column-label "Estab Subst Fim"
    field tta_cod_ccusto_inic_subst        as character format "x(11)" label "CCusto Subst Inic" column-label "CCusto Subst Inic"
    field tta_cod_ccusto_fim_subst         as character format "x(11)" label "Ccusto Subst Fim" column-label "Ccusto Subst Fim"
    field tta_cod_ccusto_pfixa_subst       as character format "x(11)" label "Ccusto PFixa Subst" column-label "Ccusto PFixa Subst"
    field tta_cod_ccusto_exec_subst        as character format "x(11)" label "Ccusto Exec Subst" column-label "Ccusto Exec Subst"
    field tta_cod_plano_ccusto_subst       as character format "x(8)" label "Plano Ccusto Subst" column-label "Plano Ccusto Subst"
    field ttv_cod_carac_lim                as character format "x(1)" initial ";" label "Caracter Delimitador"
    field ttv_log_impr_col_sem_sdo         as logical format "Sim/N∆o" initial yes label "Impr Coluna Sem Sdo"
    index tt_prefer_demonst               
          tta_cod_demonst_ctbl             ascending
    index tt_prefer_id                     is primary unique
          tta_cod_usuario                  ascending
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
    index tt_prefer_padr_col              
          tta_cod_padr_col_demonst_ctbl    ascending
    .

def new shared temp-table tt_proj_financ_demonst no-undo
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_cod_proj_financ_pai          as character format "x(20)" label "Projeto Pai" column-label "Projeto Pai"
    field ttv_log_proces                   as logical format "Sim/Nao" initial no label "&prc(" column-label "&prc("
    field ttv_ind_espec_proj_financ        as character format "X(10)"
    index tt_cod_proj_financ_pai          
          ttv_cod_proj_financ_pai          ascending
    index tt_log_proces                   
          ttv_log_proces                   ascending
    index tt_select_id                     is primary unique
          tta_cod_proj_financ              ascending
    .

def new shared temp-table tt_relacto_item_retorna no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field ttv_rec_item_demonst             as recid format ">>>>>>9"
    field ttv_rec_ret                      as recid format ">>>>>>9"
    index tt_id                           
          tta_num_seq                      ascending
          ttv_rec_item_demonst             ascending
          ttv_rec_ret                      ascending
    index tt_id_2                         
          ttv_rec_item_demonst             ascending
          ttv_rec_ret                      ascending
    index tt_recid_item                   
          ttv_rec_item_demonst             ascending
    .

def new shared temp-table tt_relacto_item_retorna_cons no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field ttv_rec_ret_orig                 as recid format ">>>>>>9"
    field ttv_rec_ret_dest                 as recid format ">>>>>>9"
    index tt_id                           
          tta_num_seq                      ascending
          ttv_rec_ret_orig                 ascending
          ttv_rec_ret_dest                 ascending
    index tt_recid_item                   
          ttv_rec_ret_orig                 ascending
    .

def new shared temp-table tt_rel_grp_col_compos_demonst no-undo
    field ttv_num_seq_sdo                  as integer format ">>>>,>>9"
    field ttv_rec_grp_col_demonst_ctbl     as recid format ">>>>>>9"
    field ttv_rec_compos_demonst_ctbl      as recid format ">>>>>>9" initial ?
    index tt_id                            is primary
          ttv_rec_grp_col_demonst_ctbl     ascending
    index tt_id_2                         
          ttv_num_seq_sdo                  ascending
    .

def new shared temp-table tt_retorna_sdo_ctbl_demonst no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_cod_unid_organ_orig          as character format "x(3)" label "UO Origem" column-label "UO Origem"
    field ttv_ind_espec_sdo                as character format "X(20)"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Resultado" column-label "Apuraá∆o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo DB" column-label "Apuraá∆o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo CR" column-label "Apuraá∆o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field ttv_qtd_movto_ctbl               as decimal format "->>>>,>>9.9999" decimals 4
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Oráado" column-label "Valor Oráado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Oráado" column-label "Saldo Oráado"
    field tta_qtd_orcado                   as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtdade Oráada" column-label "Qtdade Oráada"
    field tta_qtd_orcado_sdo               as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Saldo Quantidade" column-label "Saldo Quantidade"
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field ttv_log_sdo_orcado_sint          as logical format "Sim/N∆o" initial no
    field ttv_val_perc_criter_distrib      as decimal format ">>9.99" decimals 6 initial 0 label "Percentual" column-label "Percentual"
    index tt_busca                        
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_busca_proj                   
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
          ttv_ind_espec_sdo                ascending
          tta_cod_unid_organ_orig          ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_proj_financ              ascending
          tta_dat_sdo_ctbl                 ascending
          ttv_ind_espec_sdo                ascending
          tta_num_seq                      ascending
    index tt_rec                          
          ttv_rec_ret_sdo_ctbl             ascending
    index tt_sint                         
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    .

def new shared temp-table tt_retorna_sdo_orcto_ccusto no-undo
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Oráado" column-label "Valor Oráado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Oráado" column-label "Saldo Oráado"
    field tta_qtd_orcado                   as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtdade Oráada" column-label "Qtdade Oráada"
    field tta_qtd_orcado_sdo               as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Saldo Quantidade" column-label "Saldo Quantidade"
    index tt_id                            is primary unique
          ttv_rec_ret_sdo_ctbl             ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    .

def temp-table tt_retorno_demonst no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_des_tit_ctbl                 as character format "x(40)" label "T°tulo Cont†bil" column-label "T°tulo Cont†bil"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field ttv_des_padr                     as character format "x(15)" initial "*" label "Pad" column-label "Pad"
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_des_label_col                as character format "x(40)"
    field ttv_des_label_sig_indic          as character format "x(40)"
    field ttv_cod_carac_lim                as character format "x(1)" initial ";" label "Caracter Delimitador"
    field ttv_des_linha                    as character format "x(132)"
    field ttv_cod_empres_usuar             as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_nom_enterprise               as character format "x(40)"
    field ttv_cod_periodo                  as character format "x(7)" label "Per°odo" column-label "Per°odo"
    index tt_ret_demont_id                 is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
          tta_num_seq_demonst_ctbl         ascending
    .

def temp-table tt_retorno_demonst_lin_1 no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field ttv_num_seq_lin                  as integer format ">>>>,>>9" label "Sequància" column-label "Sequància"
    field ttv_des_val_col                  as character format "x(80)"
    field ttv_num_seq_lin_demonst          as integer format ">>>>,>>9"
    index tt_ret_lin_id                    is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
          ttv_num_seq_lin                  ascending
    .

def new shared temp-table tt_unid_negocio no-undo
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_cod_unid_negoc_pai           as character format "x(3)" label "Un Neg Pai" column-label "Un Neg Pai"
    field ttv_log_proces                   as logical format "Sim/Nao" initial no label "&prc(" column-label "&prc("
    field ttv_ind_espec_unid_negoc         as character format "X(10)" initial "Anal°tica" label "EspÇcie UN" column-label "EspÇcie UN"
    index tt_cod_unid_negoc_pai           
          ttv_cod_unid_negoc_pai           ascending
    index tt_log_proces                   
          ttv_log_proces                   ascending
    index tt_select_id                     is primary unique
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_valor_demonst_ctbl_total no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_val_coluna                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    index tt_coluna                       
          tta_cod_col_demonst_ctbl         ascending
    .

def new shared temp-table tt_valor_demonst_ctbl_video no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_rec_item_demonst_ctbl        as recid format ">>>>>>9"
    field ttv_val_col_1                    as decimal format "->>,>>>,>>>,>>9.99" decimals 6
    index tt_coluna                       
          tta_cod_col_demonst_ctbl         ascending
    index tt_id                            is primary unique
          tta_cod_col_demonst_ctbl         ascending
          ttv_rec_item_demonst_ctbl        ascending
    index tt_linha                        
          ttv_rec_item_demonst_ctbl        ascending
    .

def temp-table tt_var_formul no-undo
    field ttv_cod_var_formul               as character format "x(8)"
    field ttv_val_var_formul               as decimal format "->>>,>>>,>>9.99999" decimals 5
    .

def temp-table tt_var_formul_1 no-undo
    field ttv_cod_var_formul               as character format "x(8)"
    field ttv_val_var_formul_1             as decimal format "->>,>>>,>>>,>>9.99999" decimals 6
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_col_demonst_ctbl
    for tt_col_demonst_ctbl.
&endif
def buffer btt_demonst_ctbl_fin
    for tt_demonst_ctbl_fin.
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_prefer_demonst_ctbl
    for prefer_demonst_ctbl.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_demonst_ctbl
    as character
    format "x(8)":U
    label "Demonstrativo"
    column-label "Demonstrativo"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_layout_fisc
    as character
    format "x(20)":U
    label "Layout"
    column-label "Layout"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def var v_cod_moed_finalid
    as character
    format "x(10)":U
    label "Moeda/Finalidade"
    column-label "Mo/Finalid"
    no-undo.
def var v_cod_padr_col_demonst_ctbl
    as character
    format "x(8)":U
    label "Padr∆o Colunas"
    column-label "Padr∆o Colunas"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
def var v_cod_reg_layout_fisc
    as character
    format "x(20)":U
    label "Registro"
    column-label "Registro"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_dat_fim_period_ctbl
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Fim"
    no-undo.
def var v_dat_inic_period_ctbl
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Inicial"
    column-label "In°cio"
    no-undo.
def var v_des_formul
    as character
    format "x(80)":U
    no-undo.
def var v_des_linha
    as character
    format "x(132)":U
    no-undo.
def var v_des_lista_estab
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 80 by 12
    bgcolor 15 font 2
    label "Estabelecimentos"
    column-label "Estabelecimentos"
    no-undo.
def var v_des_param
    as character
    format "x(50)":U
    label "Param"
    column-label "Param"
    no-undo.
def new global shared var v_hdl_func_padr_glob
    as Handle
    format ">>>>>>9":U
    label "Funá‰es Pad Glob"
    column-label "Funá‰es Pad Glob"
    no-undo.
def var v_ind_operac_formul
    as character
    format "X(08)":U
    no-undo.
def var v_ind_tip_operac_formul
    as character
    format "X(08)":U
    no-undo.
def var v_log_acum_cta_ctbl_sint
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Acum Cta SintÇtica"
    column-label "Acum Cta SintÇtica"
    no-undo.
def var v_log_funcao_concil_consolid
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_funcao_dw_demonst
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_tratam_dec
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_mostrar_msg_erro
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_retorno
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_save
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_tit_demonst
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_num_campo_layout_fisc
    as integer
    format ">>>9":U
    label "Campo"
    column-label "Campo"
    no-undo.
def var v_num_column
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_col_layout_fisc
    as integer
    format ">>>>9":U
    label "Coluna"
    column-label "Coluna"
    no-undo.
def var v_num_cont_1
    as integer
    format ">>>>,>>9":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_posicao
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_seq_6
    as integer
    format ">>>>,>>9":U
    initial 10
    no-undo.
def var v_num_seq_demonst_ctbl
    as integer
    format ">>>,>>9":U
    label "Sequància"
    column-label "Sequància"
    no-undo.
def var v_rec_demonst_ctbl_video
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_restdo_formul
    as decimal
    format "->>,>>>,>>>,>>9.99999999":U
    decimals 8
    no-undo.
def var v_val_sdo_base
    as decimal
    format "->>>>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Base"
    no-undo.
def var v_val_sdo_ctbl
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Cont†bil"
    column-label "Saldo Cont†bil"
    no-undo.
def var v_val_sdo_idx
    as decimal
    format "->>>>>>,>>>,>>9.9999":U
    decimals 6
    label "Saldo ÷ndice"
    no-undo.
def var v_cod_usuar_2                    as character       no-undo. /*local*/
def var v_log_col_atualiz                as logical         no-undo. /*local*/
def var v_log_return                     as logical         no-undo. /*local*/
def var v_num_col                        as integer         no-undo. /*local*/
def var v_num_lin_tit                    as integer         no-undo. /*local*/


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_demonst_ctbl_fin_sped}


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('api_demonst_ctbl_fin_sped':U, 'prgfin/mgl/escg0204zk.py':U, '5.12.16.100':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

/* ***[ BLOQUEIA EXECUÄ«O QUANDO N«O HOUVER A FUNÄ«O DEFINIDA ]****/

/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emsbas.histor_exec_especial NO-LOCK
         WHERE emsbas.histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND emsbas.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            SPP      at 1 
            v_log_retorno  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */
    .

    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */


/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.


/* End_Include: i_declara_SetEntryField */


/* Begin_Include: i_declara_Verifica_Program_Name */
FUNCTION Verifica_Program_Name RETURN LOG (INPUT Programa AS CHAR, INPUT Repeticoes AS INT):
    DEF VAR v_num_cont  AS INTEGER NO-UNDO.
    DEF VAR v_log_achou AS LOGICAL NO-UNDO.


    /* Begin_Include: i_verifica_program_name */
    /* include feita para n∆o ocorrer problemas na utilizaá∆o do comando program-name */
    assign  v_num_cont  = 1
            v_log_achou = no.
    bloco:
    repeat:
        if index(program-name(v_num_cont),Programa) = ? then 
            leave bloco.
        if index(program-name(v_num_cont),Programa) <> 0 then do:
            assign v_log_achou = yes.
            leave bloco.
        end.
        if v_num_cont = Repeticoes then
            leave bloco.
        assign v_num_cont = v_num_cont + 1.
    end.
    /* End_Include: i_verifica_program_name */


    RETURN v_log_achou.
END FUNCTION.
/* End_Include: i_declara_Verifica_Program_Name */



/* Begin_Include: i_ttPeriodGLBalanceInformation */
DEFINE new shared TEMP-TABLE ttPeriodGLBalanceInformationXML NO-UNDO
     FIELD AccountCode AS CHARACTER INITIAL ?  /* C¢digo da conta cont†bil (Uso interno: campo = cod_cta_ctbl ou ct-codigo)*/
     FIELD AccountDescription AS CHARACTER INITIAL ?  /* Descriá∆o da conta cont†bil (Uso interno: campo = cta_ctbl.des_tit_ctbl ou conta.titulo)*/
     FIELD AccountPlanCode AS CHARACTER INITIAL ?  /* C¢digo do Plano de Conta cont†bil (Uso interno: campo = cod_plan_cta_ctbl)*/
     FIELD AccountPlanDescription AS CHARACTER INITIAL ?  /* Descriá∆o do plano de contas cont†bil (Uso interno: campo =des_plan_cta_ctbl)*/
     FIELD AlternateAccountCode AS CHARACTER INITIAL ?  /* C¢digo da conta alternativa*/
     FIELD BranchCode AS CHARACTER INITIAL ?  /* C¢digo dao estabelecimento (Uso interno: cod_estabel ou cdn-estabe)*/
     FIELD BranchDescription AS CHARACTER INITIAL ?  /* Raz∆o Social do estabelecimento (Uso interno: des_empresa)*/
     FIELD BusinessUnitCode AS CHARACTER INITIAL ?  /* C¢digo da unidade de neg¢cio (Uso interno: campo = unid_negoc.cod_unid_negoc)*/
     FIELD BusinessUnitDescription AS CHARACTER INITIAL ?  /* Descriá∆o da unidade de neg¢cio (Uso interno: campo = unid_negoc.des_unid_negoc)*/
     FIELD CompanyCode AS CHARACTER INITIAL ?  /* C¢digo da empresa (Uso interno: cod_empresa ou ep-codigo)*/
     FIELD CompanyDescription AS CHARACTER INITIAL ?  /* Raz∆o Social da Empresa (Uso interno: des_empresa ou razao-social)*/
     FIELD CostCenterCode AS CHARACTER INITIAL ?  /* C¢digo do Centro de Custo (Uso interno: campo= ccusto.cod_ccusto ou sub-conta.sc-codigo)*/
     FIELD CostCenterDescription AS CHARACTER INITIAL ?  /* Desriá∆o do Centro de Custo (Uso interno: campo = ccusto.des_tit_ctbl ou sub-conta.descricao)*/
     FIELD CostCenterPlanCode AS CHARACTER INITIAL ?  /* C¢digo do Plano de Centro de Custo (Uso interno: campo=ccusto.cod_plano_ccusto)*/
     FIELD CostCenterPlanDescription AS CHARACTER INITIAL ?  /* Descriá∆o do Plano de Centro de Custo (Uso interno: campo=plano_ccusto.des_tit_ctbl)*/
     FIELD CreditValue AS decimal INITIAL ?  /* Valor de CrÇdito do Per°odo ( campo = saldo-conta.credito ou sdo_ctbl.val_sdo_ctbl_cr) */
     FIELD CreditValue_00 AS decimal INITIAL ?  /* Valor de CrÇdito do Per°odo ( campo = sdo_ctbl_ccusto.qdt_sdo_ctbl_cr )*/
     FIELD DebitValue AS decimal INITIAL ?  /* Valor de DÇbito do Per°odo ( campo = saldo-conta.debito ou sdo_ctbl.val_sdo_ctbl_db)*/
     FIELD DebitValue_00 AS decimal INITIAL ?  /* Valor de DÇbito do Per°odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_db)*/
     FIELD EconomicPurposeCode AS CHARACTER INITIAL ?  /* C¢digo da Finalidade Economica (Uso interno: campo = finalid_econ.cod_finalid_econ)*/
     FIELD EconomicPurposeDescription AS CHARACTER INITIAL ?  /* Descriá∆o da Finalidade Economica (Uso interno: campo = finalid_econ.des_finalid_econ)*/
     FIELD FinalBalance AS decimal INITIAL ?  /* Saldo Final do Per°odo ( campo = (saldo-conta.saldo + saldo-conta.debito - saldo-conta.credito) ou sdo_ctbl.val_sdo_ctbl_fim )*/
     FIELD FinalBalance_00 AS decimal INITIAL ?  /* Saldo Final do Per°odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_fim )*/
     FIELD InitialBalance AS decimal INITIAL ?  /* Saldo Inicial do Per°odo ( campo = saldo-conta.saldo ou ( sdo_ctbl.val_sdo_ctbl_fim - sdo_ctbl.val_sdo_ctbl_db + sdo_ctbl.val_sdo_ctbl_cr) )*/
     FIELD InitialBalance_00 AS decimal INITIAL ?  /* Saldo Inicial do Per°odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_fim - sdo_ctbl_ccusto.qtd_sdo_ctbl_db + sdo_ctbl_ccusto.qtd_sdo_ctbl_cr*/
     FIELD InternationalStandardAccountCode AS CHARACTER INITIAL ?  /* C¢digo Internacional da conta cont†bil*/
     FIELD ttPeriodGLBalanceInformationID AS INTEGER INITIAL ?
     INDEX ixttPeriodGLBalanceInformationID IS PRIMARY UNIQUE ttPeriodGLBalanceInformationID ASCENDING
     INDEX ixttper2
           CompanyCode        ASCENDING
           BranchCode          ASCENDING
           BusinessUnitCode    ASCENDING
           AccountPlanCode    ASCENDING
           AccountCode        ASCENDING
           CostCenterPlanCode  ASCENDING
           CostCenterCode     ASCENDING
           EconomicPurposeCode ASCENDING.

/* End_Include: i_ttPeriodGLBalanceInformation */



/* Begin_Include: i_verify_program_epc_custom */
define variable v_nom_prog_upc    as character     no-undo init ''.
define variable v_nom_prog_appc   as character     no-undo init ''.
&if '{&emsbas_version}' > '5.00' &then
define variable v_nom_prog_dpc    as character     no-undo init ''.
&endif

define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "api_demonst_ctbl_fin_sped":U
    no-lock no-error.
if  avail prog_dtsul then do:
    if  prog_dtsul.nom_prog_upc <> ''
    and prog_dtsul.nom_prog_upc <> ? then
        assign v_nom_prog_upc = prog_dtsul.nom_prog_upc.
    if  prog_dtsul.nom_prog_appc <> ''
    and prog_dtsul.nom_prog_appc <> ? then
        assign v_nom_prog_appc = prog_dtsul.nom_prog_appc.
&if '{&emsbas_version}' > '5.00' &then
    if  prog_dtsul.nom_prog_dpc <> ''
    and prog_dtsul.nom_prog_dpc <> ? then
        assign v_nom_prog_dpc = prog_dtsul.nom_prog_dpc.
&endif
end.

/* End_Include: i_verify_program_epc_custom */


/* Decimais Chile */
if not valid-handle(v_hdl_func_padr_glob) then run prgint/utb/utb925za.py persistent set v_hdl_func_padr_glob no-error.

function FnAjustDec     returns decimal (p_val_movto as decimal, p_cod_moed_finalid as character) in v_hdl_func_padr_glob.

assign v_log_funcao_tratam_dec = GetDefinedFunction('SPP_TRAT_CASAS_DEC':U).

/* 218397 -  FUNÄ«O EXCLUSIVA P/ A 'Frangosul ' - POSSUI MAI DE UMA COLUNA T÷TULO*/
assign v_log_tit_demonst = &IF DEFINED (BF_FIN_TIT_DEMONST) &THEN YES 
                           &ELSE GetDefinedFunction('SPP_TIT_DEMONST':U) &ENDIF.



/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_identifica_conteudo
** Descricao.............: pi_identifica_conteudo
** Criado por............: dalpra
** Criado em.............: 05/06/2001 16:49:50
** Alterado por..........: fut41651
** Alterado em...........: 17/09/2009 15:08:34
*****************************************************************************/
PROCEDURE pi_identifica_conteudo:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_nivel
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_inform
        as character
        format "x(60)"
        no-undo.
    def Input param p_cod_campo
        as character
        format "x(25)"
        no-undo.


    /************************* Parameter Definition End *************************/

    CASE p_cod_inform:
        when "Conta Cont†bil" /*l_conta_contabil*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho    = p_cod_campo.
            if tt_demonst_ctbl_fin.ttv_cod_inform_princ = p_cod_inform then do:
                find first tt_cta_ctbl_demonst
                   where tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                   and   tt_cta_ctbl_demonst.ttv_cod_cta_ctbl_pai   = p_cod_campo
                   no-error.
                if not avail tt_cta_ctbl_demonst then
                    assign tt_demonst_ctbl_fin.ttv_log_analit = yes.
            end.        
        END.
        when "Centro de Custo" /*l_centro_de_custo*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_ccusto_filho      = p_cod_campo.
            if tt_demonst_ctbl_fin.ttv_cod_inform_princ = p_cod_inform then do:
                find first tt_ccustos_demonst
                   where tt_ccustos_demonst.ttv_cod_ccusto_pai  = p_cod_campo
                   no-error.
                if not avail tt_ccustos_demonst then do:
                    assign tt_demonst_ctbl_fin.ttv_log_analit = yes.
                end.
                else do:  
                    /* 211231 x 217273 - o ccusto pai pode receber lanáamentos
                      se a compos_demonst_ctbl.log_ccusto_sint estiver 'NO'
                      ele recebe lanáamentos, sendo assim deve somar o valor do ccusto pai
                      se a compos_demonst_ctbl.log_ccusto_sint estiver 'yes'
                      ele n∆o recebe lanáamentos, sendo assim n∆o deve somar o valor do ccusto pai */
                    find first compos_demonst_ctbl no-lock
                        where compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                          and compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
                        if  avail compos_demonst_ctbl
                        then do:  
                        if not compos_demonst_ctbl.log_ccusto_sint then do:
                            find first tt_ccustos_demonst  no-lock
                                 where tt_ccustos_demonst.ttv_cod_ccusto      = p_cod_campo
                                   and tt_ccustos_demonst.ttv_cod_ccusto_pai  = '' no-error.
                            if not avail tt_ccustos_demonst then 
                                assign tt_demonst_ctbl_fin.ttv_log_analit = yes.
                        end.     
                    end. 
                END.
            end.        
        END.
        when "Projeto" /*l_projeto*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_proj_financ_filho = p_cod_campo.
            if tt_demonst_ctbl_fin.ttv_cod_inform_princ = p_cod_inform then do:
                find first tt_proj_financ_demonst
                   where tt_proj_financ_demonst.ttv_cod_proj_financ_pai = p_cod_campo
                    no-error.
                if not avail tt_proj_financ_demonst then
                    assign tt_demonst_ctbl_fin.ttv_log_analit = yes.
            end.        
        END.
        when "Unidade Neg¢cio" /*l_unidade_negocio*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho  = p_cod_campo.
            if tt_demonst_ctbl_fin.ttv_cod_inform_princ = p_cod_inform then do:
                find first tt_unid_negocio
                   where tt_unid_negocio.ttv_cod_unid_negoc_pai = p_cod_campo
                    no-error.
                if not avail tt_unid_negocio then
                    assign tt_demonst_ctbl_fin.ttv_log_analit = yes.
            end.        
        END.
        when "Estabelecimento" /*l_estabelecimento*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_estab             = p_cod_campo.
        END.
        when "UO Origem" /*l_uo_origem*/ then do:
            ASSIGN tt_demonst_ctbl_fin.tta_cod_unid_organ_filho  = p_cod_campo.
        END.
    END.

    /* * Carrega demais informaá‰es dos n°veis acima a esta posiá∆o na extrutura **/
    CASE (p_num_nivel - 1):
        when 0 then
            run pi_identifica_conteudo (Input 0,
                                        Input entry(1,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_1) /*pi_identifica_conteudo*/.
        when 1 then
            run pi_identifica_conteudo (Input 1,
                                        Input entry(2,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_2) /*pi_identifica_conteudo*/.
        when 2 then
            run pi_identifica_conteudo (Input 2,
                                        Input entry(3,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_3) /*pi_identifica_conteudo*/.
        when 3 then
            run pi_identifica_conteudo (Input 3,
                                        Input entry(4,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_4) /*pi_identifica_conteudo*/.
        when 4 then
            run pi_identifica_conteudo (Input 4,
                                        Input entry(5,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_5) /*pi_identifica_conteudo*/.
        when 5 then
            run pi_identifica_conteudo (Input 5,
                                        Input entry(6,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_6) /*pi_identifica_conteudo*/.
    END.

END PROCEDURE. /* pi_identifica_conteudo */
/*****************************************************************************
** Procedure Interna.....: pi_retorno_api_demonst_ctbl_video_sped
** Descricao.............: pi_retorno_api_demonst_ctbl_video_sped
** Criado por............: fut38629
** Criado em.............: 19/03/2009 16:18:16
** Alterado por..........: fut38629
** Alterado em...........: 02/04/2009 16:44:24
*****************************************************************************/
PROCEDURE pi_retorno_api_demonst_ctbl_video_sped:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_item_demonst_ctbl
        for item_demonst_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_format
        as character
        format "x(8)":U
        label "Formato"
        column-label "Formato"
        no-undo.
    def var v_des_label_col
        as character
        format "x(40)":U
        no-undo.
    def var v_des_label_sig_indic
        as character
        format "x(40)":U
        no-undo.
    def var v_des_sig_indic_econ
        as character
        format "x(06)":U
        label "Sigla"
        column-label "Sigla"
        no-undo.
    def var v_des_val_col
        as character
        format "x(80)":U
        no-undo.
    def var v_log_primei_col_title
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_ano
        as integer
        format "9999":U
        initial 0001
        label "Ano"
        no-undo.
    def var v_num_initial
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_mes
        as integer
        format "99":U
        initial 01
        no-undo.
    def var v_num_period_ano
        as integer
        format "9999":U
        label "Ano"
        column-label "Ano"
        no-undo.
    def var v_num_period_mes
        as integer
        format "99":U
        label "Per°odo"
        column-label "Per°odo"
        no-undo.
    def var v_dat_fim_period_col             as date            no-undo. /*local*/
    def var v_num_col_max                    as integer         no-undo. /*local*/
    def var v_num_linha                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    for each tt_col_demonst_ctbl_ext:
        delete tt_col_demonst_ctbl_ext.
    end.

    if  NOT AVAIL prefer_demonst_ctbl
    then do:
        /* ***[ Posiciona na ultima preferencia do usuario ]****/
        FOR EACH b_prefer_demonst_ctbl NO-LOCK
             WHERE b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
               AND b_prefer_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
               AND b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
             BREAK BY b_prefer_demonst_ctbl.dat_ult_atualiz
                   BY b_prefer_demonst_ctbl.hra_ult_atualiz:

            IF  LAST-OF(b_prefer_demonst_ctbl.dat_ult_atualiz)
            AND LAST-OF(b_prefer_demonst_ctbl.hra_ult_atualiz) THEN
                FIND FIRST prefer_demonst_ctbl exclusive-lock
                    WHERE prefer_demonst_ctbl.cod_usuario = b_prefer_demonst_ctbl.cod_usuario
                      AND prefer_demonst_ctbl.cod_demonst_ctbl = b_prefer_demonst_ctbl.cod_demonst_ctbl
                      AND prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                NO-ERROR.
        END.
    END.

    /* Posiciona no Padr∆o de Colunas definido nos parÉmetros */
    FIND  padr_col_demonst_ctbl NO-LOCK
    WHERE padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl NO-ERROR.

    /* Posiciona no Demontrativo definido nos parÉmetros */
    FIND  demonst_ctbl NO-LOCK
    WHERE demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl NO-ERROR.
    IF AVAIL demonst_ctbl THEN
       ASSIGN v_cod_plano_cta_ctbl = demonst_ctbl.cod_plano_cta_ctbl.

    /* Inicializa vari†veis de controle */
    assign v_num_col_max         = 0
           v_des_label_col       = ""
           v_des_label_sig_indic = ""
           v_des_linha           = "".

    /* Monta os labels das colunas */
    &IF '{&emsfin_version}' >= '5.05' &THEN
    FOR EACH tt_label_demonst_ctbl_video:

        /* Begin_Include: i_demonst_ctbl_moeda_label_coluna */
        if prefer_demonst_ctbl.cod_padr_col_demonst <> "" then do:
            find tt_col_demonst_ctbl
                where tt_col_demonst_ctbl.cod_padr_col_demonst = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                and   tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl no-error.
            if avail tt_col_demonst_ctbl 
               and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "T°tulo" /*l_titulo*/  
               and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "% Participac" /*l_%_Participaá∆o*/  then do:
                find conjto_prefer_demonst no-lock
                    where conjto_prefer_demonst.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                    and   conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
                    and   conjto_prefer_demonst.cod_padr_col_demonst_ctbl = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                    and   conjto_prefer_demonst.num_conjto_param_ctbl     = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
                if avail conjto_prefer_demonst then do:

                    /* busca data fim periodo */
                    assign v_num_period_mes = prefer_demonst_ctbl.num_period_ctbl
                           v_num_period_ano = int(prefer_demonst_ctbl.cod_exerc_ctbl).
                    if  tt_col_demonst_ctbl.ind_tip_relac_base = "Antes da Referància" /*l_antes_da_referencia*/ 
                    then do:
                        assign v_num_mes = v_num_period_mes - tt_col_demonst_ctbl.qtd_period_relac_base
                               v_num_ano = v_num_period_ano - tt_col_demonst_ctbl.qtd_exerc_relac_base.
                        if  v_num_mes <= 0
                        then do:
                            assign v_num_mes = 12 + v_num_mes.
                            if  v_num_ano = v_num_period_ano then
                               assign v_num_ano = v_num_period_ano - 1.
                        end.
                    end.
                    else do:
                        assign v_num_mes = v_num_period_mes + tt_col_demonst_ctbl.qtd_period_relac_base
                               v_num_ano = v_num_period_ano + tt_col_demonst_ctbl.qtd_exerc_relac_base.
                        if  v_num_mes > 12
                        then do:
                            assign v_num_mes = v_num_mes - 12.
                            if  v_num_ano = v_num_period_ano then
                                assign v_num_ano = v_num_period_ano + 1.
                        end.
                    end.

                    find period_ctbl no-lock
                        where period_ctbl.cod_cenar_ctbl  = conjto_prefer_demonst.cod_cenar_ctbl
                        and   period_ctbl.num_period_ctbl = v_num_mes
                        and   period_ctbl.cod_exerc_ctbl  = string(v_num_ano) no-error.
                    if avail period_ctbl then
                        assign v_dat_fim_period_col = period_ctbl.dat_fim_period_ctbl.

                    find first histor_finalid_econ no-lock
                        where histor_finalid_econ.cod_finalid_econ        = conjto_prefer_demonst.cod_finalid_econ_apres
                        and   histor_finalid_econ.dat_inic_valid_finalid <= v_dat_fim_period_col
                        and   histor_finalid_econ.dat_fim_valid_finalid   > v_dat_fim_period_col no-error.
                    if avail histor_finalid_econ THEN DO:
                        FIND indic_econ NO-LOCK
                            WHERE indic_econ.cod_indic_econ = histor_finalid_econ.cod_indic_econ NO-ERROR.
                        IF AVAIL indic_econ THEN DO:
                            ASSIGN v_des_sig_indic_econ = indic_econ.des_sig_indic_econ.
                            IF v_log_funcao_tratam_dec THEN DO:
                                create tt_col_demonst_ctbl_ext.
                                assign tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst  = tt_col_demonst_ctbl.cod_padr_col_demonst
                                       tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = conjto_prefer_demonst.num_conjto_param_ctbl
                                       tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid      = histor_finalid_econ.cod_indic_econ.
                            END.
                        END.
                    END.

                    if prefer_demonst_ctbl.val_fator_div_demonst_ctbl > 1 then do:
                        assign v_des_sig_indic_econ = v_des_sig_indic_econ + "/" + string(prefer_demonst_ctbl.val_fator_div_demonst_ctbl).
                        IF v_log_funcao_tratam_dec THEN DO:
                            create tt_col_demonst_ctbl_ext.
                            assign tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst
                                   tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = conjto_prefer_demonst.num_conjto_param_ctbl
                                   tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid     = conjto_prefer_demonst.cod_finalid_econ_apres.
                        END.
                    end.
                end.
            end.
            else
                assign v_des_sig_indic_econ = ''.
        end.
        /* End_Include: i_demonst_ctbl_moeda_label_coluna */
        .

        assign v_des_label_sig_indic     = v_des_label_sig_indic + string(v_des_sig_indic_econ,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')')) + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
               v_des_label_col           = v_des_label_col       + string(tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')')) + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
               v_des_linha               = v_des_linha + fill("-",tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
               v_num_col_max             = v_num_col_max + 1
               v_num_linha               = v_num_linha + 1.
    END.
    &ENDIF

    /* **[ Monta linha com os valores de todas as colunas ]***/

    for each tt_valor_demonst_ctbl_total:
      delete tt_valor_demonst_ctbl_total.
    end.

    /* Carrega variavel com as posiá‰es dos titulos nas colunas */
    for each  tt_label_demonst_ctbl_video
        where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col
        and   tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl < v_num_col + 16 :
        if  tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then
            assign v_num_lin_tit = tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl.

        assign v_cod_format = v_cod_format + tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl + chr(10).
    end.

    /* Acerta entradas do formato para utilizaá∆o direta na logica do restante do programa */
    assign v_cod_format = v_cod_format + fill(chr(10),5)
           v_log_primei_col_title = no.

    /* Carrega informaá‰es das linhas apenas uma vez */
    if  not can-find(first tt_demonst_ctbl_fin)
    then do:
       run pi_carrega_lin_titulo (Input 0) /*pi_carrega_lin_titulo*/.
    end.

    find emsuni.empresa no-lock
        where empresa.cod_empresa = v_cod_empres_usuar
        no-error.
    if  avail empresa then
        assign v_nom_enterprise = empresa.nom_razao_social.
    else
        assign v_nom_enterprise = "DATASUL" /*l_DATASUL*/ .
    find demonst_ctbl no-lock
        where demonst_ctbl.cod_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
        no-error.
    find padr_col_demonst_ctbl no-lock
        where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
        no-error.

    /* Remonta os valores das colunas conforme posiá∆o da coluna atual */
    for each tt_demonst_ctbl_fin
        where tt_demonst_ctbl_fin.ttv_log_apres
        USE-INDEX tt_id_descending:

        /* Carrega os Titulos na Coluna Correta Quando Estiver Navegando */
        if  v_log_primei_col_title
        then do:
            assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
        end.
        else do:
            case v_num_lin_tit:
                when v_num_col + 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                when v_num_col + 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
            end case.
        end.

        find first tt_item_demonst_ctbl_video
           where  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video no-error.

        /* * Sai fora do bloco de totalizaá∆o quando a linha corrente for um titulo **/
        if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then
            next.

        /* * Sai fora do bloco de totalizaá∆o quando a linha corrente for caracter especial **/
        if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "Chr Espec" /*l_hr_espec*/  then do:
            assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_2 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_3 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_4 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_5 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_6 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_7 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_8 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_9 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_10 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_11 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_12 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_13 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_14 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video
                   tt_demonst_ctbl_fin.ttv_cod_campo_15 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
            next.
        end.

        find first tt_label_demonst_ctbl_video
           where  tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
        find first tt_col_demonst_ctbl no-lock
           where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
           and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
           no-error.


        /* * Cria valores somente para os niveis que n∆o ser∆o totalizados posteriormente **/
        if  can-find(first tt_estrut_visualiz_ctbl_cad 
            where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = v_cod_demonst_ctbl
            and   tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
            and   tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz  = tt_demonst_ctbl_fin.ttv_cod_inform_princ
            and   tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = no)
        then do:
            if  can-find(first btt_demonst_ctbl_fin
                where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin))
            then do:

                /* Begin_Include: i_open_demonst_ctbl_fin */
                case v_num_lin_tit:
                    when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                       tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_14 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_15 = "".
                    when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_3 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_4 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_5 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_6 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_1 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_7 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_8 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_9 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_10 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_11 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_12 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_13 = ""
                                        tt_demonst_ctbl_fin.ttv_cod_campo_14 = "".
                end case.
                next.
                /* End_Include: i_open_demonst_ctbl_fin */

            end.
        end.
        if v_log_primei_col_title = yes then
            assign v_num_initial = 2.
        else
            assign v_num_initial = 1.

        /* Begin_Include: i_totaliza_colunas_demonst */
        do v_num_column = v_num_initial to 15:

            /* * Para a lΩgica de valores serˇ desconsiderada a coluna de t≠tulos **/
            if  avail tt_label_demonst_ctbl_video and tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/   and v_num_lin_tit <> 0
            then do:
                find next tt_label_demonst_ctbl_video
                    where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
                IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
                find first tt_col_demonst_ctbl no-lock
                    where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                      and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                    no-error.
                next.
            end.

            if  avail tt_col_demonst_ctbl
            and tt_demonst_ctbl_fin.ttv_log_expand_usuar = NO
            and can-find(first btt_demonst_ctbl_fin no-lock
                   where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)) then do:

                assign v_val_sdo_ctbl = 0.
                for each btt_demonst_ctbl_fin no-lock
                   where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):

                   IF tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "F¢rmula" /*l_Formula*/   AND
                     (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/  OR 
                      tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_Variacao*/ )
                   THEN .
                   ELSE run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                      Input tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                end.

                IF tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "F¢rmula" /*l_Formula*/   AND
                  (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/  OR 
                   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_Variacao*/  )
                THEN .
                ELSE DO:
                      /* Criar a tt_valor_demonst_ctbl_total apenas quando for a linha de n°vel zero, para acumular o total da coluna que n∆o 
                         Ç de origem f¢rmula, que poder† ser utilizado mais tarde para calcular o total de alguma coluna que poss°velmente 
                         utilize esta coluna em sua f¢rmula. */
                      if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                      then do:
                          if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                          where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl)
                          then do:
                              create tt_valor_demonst_ctbl_total.
                              assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                                     tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                          end /* if */.
                          else do:
                              find tt_valor_demonst_ctbl_total
                                  where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl NO-ERROR.
                              if avail tt_valor_demonst_ctbl_total then
                                 assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                          end /* else */.
                      end /* if */.
                      if v_val_sdo_ctbl <> 0 then do:
                         case v_num_column:
                            when 1 then if v_num_lin_tit <> v_num_col + 1 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = string(v_val_sdo_ctbl,ENTRY(1,v_cod_format,chr(10))).
                            when 2 then if v_num_lin_tit <> v_num_col + 2 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = string(v_val_sdo_ctbl,ENTRY(2,v_cod_format,chr(10))).
                            when 3 then if v_num_lin_tit <> v_num_col + 3 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = string(v_val_sdo_ctbl,ENTRY(3,v_cod_format,chr(10))).
                            when 4 then if v_num_lin_tit <> v_num_col + 4 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = string(v_val_sdo_ctbl,ENTRY(4,v_cod_format,chr(10))).
                            when 5 then if v_num_lin_tit <> v_num_col + 5 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = string(v_val_sdo_ctbl,ENTRY(5,v_cod_format,chr(10))).
                            when 6 then if v_num_lin_tit <> v_num_col + 6 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = string(v_val_sdo_ctbl,ENTRY(6,v_cod_format,chr(10))).
                            when 7 then if v_num_lin_tit <> v_num_col + 7 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = string(v_val_sdo_ctbl,ENTRY(7,v_cod_format,chr(10))).
                            when 8 then if v_num_lin_tit <> v_num_col + 8 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = string(v_val_sdo_ctbl,ENTRY(8,v_cod_format,chr(10))).
                            when 9 then if v_num_lin_tit <> v_num_col + 9 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = string(v_val_sdo_ctbl,ENTRY(9,v_cod_format,chr(10))).
                            when 10 then if v_num_lin_tit <> v_num_col + 10 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = string(v_val_sdo_ctbl,ENTRY(10,v_cod_format,chr(10))).
                            when 11 then if v_num_lin_tit <> v_num_col + 11 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = string(v_val_sdo_ctbl,ENTRY(11,v_cod_format,chr(10))).
                            when 12 then if v_num_lin_tit <> v_num_col + 12 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = string(v_val_sdo_ctbl,ENTRY(12,v_cod_format,chr(10))).
                            when 13 then if v_num_lin_tit <> v_num_col + 13 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = string(v_val_sdo_ctbl,ENTRY(13,v_cod_format,chr(10))).
                            when 14 then if v_num_lin_tit <> v_num_col + 14 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = string(v_val_sdo_ctbl,ENTRY(14,v_cod_format,chr(10))).
                            when 15 then if v_num_lin_tit <> v_num_col + 15 then
                               assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = string(v_val_sdo_ctbl,ENTRY(15,v_cod_format,chr(10))).
                         end.
                      end.
                      else assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(1,v_cod_format,chr(10))) else "" WHEN v_num_column = 1
                                  tt_demonst_ctbl_fin.ttv_cod_campo_2 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(2,v_cod_format,chr(10))) else "" WHEN v_num_column = 2
                                  tt_demonst_ctbl_fin.ttv_cod_campo_3 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(3,v_cod_format,chr(10))) else "" WHEN v_num_column = 3
                                  tt_demonst_ctbl_fin.ttv_cod_campo_4 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(4,v_cod_format,chr(10))) else "" WHEN v_num_column = 4
                                  tt_demonst_ctbl_fin.ttv_cod_campo_5 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(5,v_cod_format,chr(10))) else "" WHEN v_num_column = 5
                                  tt_demonst_ctbl_fin.ttv_cod_campo_6 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(6,v_cod_format,chr(10))) else "" WHEN v_num_column = 6
                                  tt_demonst_ctbl_fin.ttv_cod_campo_7 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(7,v_cod_format,chr(10))) else "" WHEN v_num_column = 7
                                  tt_demonst_ctbl_fin.ttv_cod_campo_8 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(8,v_cod_format,chr(10))) else "" WHEN v_num_column = 8
                                  tt_demonst_ctbl_fin.ttv_cod_campo_9 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(9,v_cod_format,chr(10))) else "" WHEN v_num_column = 9
                                  tt_demonst_ctbl_fin.ttv_cod_campo_10 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(10,v_cod_format,chr(10))) else "" WHEN v_num_column = 10
                                  tt_demonst_ctbl_fin.ttv_cod_campo_11 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(11,v_cod_format,chr(10))) else "" WHEN v_num_column = 11
                                  tt_demonst_ctbl_fin.ttv_cod_campo_12 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(12,v_cod_format,chr(10))) else "" WHEN v_num_column = 12
                                  tt_demonst_ctbl_fin.ttv_cod_campo_13 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(13,v_cod_format,chr(10))) else "" WHEN v_num_column = 13
                                  tt_demonst_ctbl_fin.ttv_cod_campo_14 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(14,v_cod_format,chr(10))) else "" WHEN v_num_column = 14
                                  tt_demonst_ctbl_fin.ttv_cod_campo_15 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(15,v_cod_format,chr(10))) else "" WHEN v_num_column = 15.

                      if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "% Participac" /*l_%_Participaá∆o*/ 
                      and v_log_funcao_concil_consolid
                      then do:

                          /* Begin_Include: i_totaliza_colunas_demonst_2 */
                          case v_num_column:
                              when  1 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_1  = if tt_demonst_ctbl_fin.ttv_cod_campo_1  = string(0,ENTRY(1,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_1 + '%'.
                              when  2 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_2  = if tt_demonst_ctbl_fin.ttv_cod_campo_2  = string(0,ENTRY(2,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_2 + '%'.
                              when  3 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_3  = if tt_demonst_ctbl_fin.ttv_cod_campo_3  = string(0,ENTRY(3,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_3 + '%'.
                              when  4 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_4  = if tt_demonst_ctbl_fin.ttv_cod_campo_4  = string(0,ENTRY(4,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_4 + '%'.
                              when  5 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_5  = if tt_demonst_ctbl_fin.ttv_cod_campo_5  = string(0,ENTRY(5,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_5 + '%'.
                              when  6 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_6  = if tt_demonst_ctbl_fin.ttv_cod_campo_6  = string(0,ENTRY(6,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_6 + '%'.
                              when  7 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_7  = if tt_demonst_ctbl_fin.ttv_cod_campo_7  = string(0,ENTRY(7,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_7 + '%'.
                              when  8 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_8  = if tt_demonst_ctbl_fin.ttv_cod_campo_8  = string(0,ENTRY(8,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_8 + '%'.
                              when  9 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_9  = if tt_demonst_ctbl_fin.ttv_cod_campo_9  = string(0,ENTRY(9,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_9 + '%'.
                              when 10 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = if tt_demonst_ctbl_fin.ttv_cod_campo_10 = string(0,ENTRY(10,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_10 + '%'.
                              when 11 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = if tt_demonst_ctbl_fin.ttv_cod_campo_11 = string(0,ENTRY(11,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_11 + '%'.
                              when 12 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = if tt_demonst_ctbl_fin.ttv_cod_campo_12 = string(0,ENTRY(12,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_12 + '%'.
                              when 13 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = if tt_demonst_ctbl_fin.ttv_cod_campo_13 = string(0,ENTRY(13,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_13 + '%'.
                              when 14 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = if tt_demonst_ctbl_fin.ttv_cod_campo_14 = string(0,ENTRY(14,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_14 + '%'.
                              when 15 then
                                 assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = if tt_demonst_ctbl_fin.ttv_cod_campo_15 = string(0,ENTRY(15,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_15 + '%'.
                          end.
                          /* End_Include: i_totaliza_colunas_demonst_2 */

                      end.
                END.
            end.
            else do:
                find tt_valor_demonst_ctbl_video
                    where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                    and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video no-error.

                if  avail tt_valor_demonst_ctbl_video
                then do:
                   case v_num_column:
                      when 1 then if v_num_lin_tit <> v_num_col + 1 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(1,v_cod_format,chr(10))).
                      when 2 then if v_num_lin_tit <> v_num_col + 2 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(2,v_cod_format,chr(10))).
                      when 3 then if v_num_lin_tit <> v_num_col + 3 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(3,v_cod_format,chr(10))).
                      when 4 then if v_num_lin_tit <> v_num_col + 4 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(4,v_cod_format,chr(10))).
                      when 5 then if v_num_lin_tit <> v_num_col + 5 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(5,v_cod_format,chr(10))).
                      when 6 then if v_num_lin_tit <> v_num_col + 6 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(6,v_cod_format,chr(10))).
                      when 7 then if v_num_lin_tit <> v_num_col + 7 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(7,v_cod_format,chr(10))).
                      when 8 then if v_num_lin_tit <> v_num_col + 8 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(8,v_cod_format,chr(10))).
                      when 9 then if v_num_lin_tit <> v_num_col + 9 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(9,v_cod_format,chr(10))).
                      when 10 then if v_num_lin_tit <> v_num_col + 10 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(10,v_cod_format,chr(10))).
                      when 11 then if v_num_lin_tit <> v_num_col + 11 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(11,v_cod_format,chr(10))).
                      when 12 then if v_num_lin_tit <> v_num_col + 12 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(12,v_cod_format,chr(10))).
                      when 13 then if v_num_lin_tit <> v_num_col + 13 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(13,v_cod_format,chr(10))).
                      when 14 then if v_num_lin_tit <> v_num_col + 14 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(14,v_cod_format,chr(10))).
                      when 15 then if v_num_lin_tit <> v_num_col + 15 then
                         assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),ENTRY(15,v_cod_format,chr(10))).
                   end.
                end. /* end if*/
                else assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(1,v_cod_format,chr(10))) else "" WHEN v_num_column = 1
                            tt_demonst_ctbl_fin.ttv_cod_campo_2 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(2,v_cod_format,chr(10))) else "" WHEN v_num_column = 2
                            tt_demonst_ctbl_fin.ttv_cod_campo_3 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(3,v_cod_format,chr(10))) else "" WHEN v_num_column = 3
                            tt_demonst_ctbl_fin.ttv_cod_campo_4 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(4,v_cod_format,chr(10))) else "" WHEN v_num_column = 4
                            tt_demonst_ctbl_fin.ttv_cod_campo_5 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(5,v_cod_format,chr(10))) else "" WHEN v_num_column = 5
                            tt_demonst_ctbl_fin.ttv_cod_campo_6 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(6,v_cod_format,chr(10))) else "" WHEN v_num_column = 6
                            tt_demonst_ctbl_fin.ttv_cod_campo_7 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(7,v_cod_format,chr(10))) else "" WHEN v_num_column = 7
                            tt_demonst_ctbl_fin.ttv_cod_campo_8 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(8,v_cod_format,chr(10))) else "" WHEN v_num_column = 8
                            tt_demonst_ctbl_fin.ttv_cod_campo_9 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(9,v_cod_format,chr(10))) else "" WHEN v_num_column = 9
                            tt_demonst_ctbl_fin.ttv_cod_campo_10 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(10,v_cod_format,chr(10))) else "" WHEN v_num_column = 10
                            tt_demonst_ctbl_fin.ttv_cod_campo_11 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(11,v_cod_format,chr(10))) else "" WHEN v_num_column = 11
                            tt_demonst_ctbl_fin.ttv_cod_campo_12 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(12,v_cod_format,chr(10))) else "" WHEN v_num_column = 12
                            tt_demonst_ctbl_fin.ttv_cod_campo_13 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(13,v_cod_format,chr(10))) else "" WHEN v_num_column = 13
                            tt_demonst_ctbl_fin.ttv_cod_campo_14 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(14,v_cod_format,chr(10))) else "" WHEN v_num_column = 14
                            tt_demonst_ctbl_fin.ttv_cod_campo_15 = if avail tt_label_demonst_ctbl_video then string(0,ENTRY(15,v_cod_format,chr(10))) else "" WHEN v_num_column = 15.

                if  avail tt_col_demonst_ctbl
                and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "% Participac" /*l_%_Participaá∆o*/ 
                and v_log_funcao_concil_consolid
                then do:

                    /* Begin_Include: i_totaliza_colunas_demonst_2 */
                    case v_num_column:
                        when  1 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_1  = if tt_demonst_ctbl_fin.ttv_cod_campo_1  = string(0,ENTRY(1,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_1 + '%'.
                        when  2 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_2  = if tt_demonst_ctbl_fin.ttv_cod_campo_2  = string(0,ENTRY(2,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_2 + '%'.
                        when  3 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_3  = if tt_demonst_ctbl_fin.ttv_cod_campo_3  = string(0,ENTRY(3,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_3 + '%'.
                        when  4 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_4  = if tt_demonst_ctbl_fin.ttv_cod_campo_4  = string(0,ENTRY(4,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_4 + '%'.
                        when  5 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_5  = if tt_demonst_ctbl_fin.ttv_cod_campo_5  = string(0,ENTRY(5,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_5 + '%'.
                        when  6 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_6  = if tt_demonst_ctbl_fin.ttv_cod_campo_6  = string(0,ENTRY(6,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_6 + '%'.
                        when  7 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_7  = if tt_demonst_ctbl_fin.ttv_cod_campo_7  = string(0,ENTRY(7,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_7 + '%'.
                        when  8 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_8  = if tt_demonst_ctbl_fin.ttv_cod_campo_8  = string(0,ENTRY(8,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_8 + '%'.
                        when  9 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_9  = if tt_demonst_ctbl_fin.ttv_cod_campo_9  = string(0,ENTRY(9,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_9 + '%'.
                        when 10 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = if tt_demonst_ctbl_fin.ttv_cod_campo_10 = string(0,ENTRY(10,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_10 + '%'.
                        when 11 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = if tt_demonst_ctbl_fin.ttv_cod_campo_11 = string(0,ENTRY(11,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_11 + '%'.
                        when 12 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = if tt_demonst_ctbl_fin.ttv_cod_campo_12 = string(0,ENTRY(12,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_12 + '%'.
                        when 13 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = if tt_demonst_ctbl_fin.ttv_cod_campo_13 = string(0,ENTRY(13,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_13 + '%'.
                        when 14 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = if tt_demonst_ctbl_fin.ttv_cod_campo_14 = string(0,ENTRY(14,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_14 + '%'.
                        when 15 then
                           assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = if tt_demonst_ctbl_fin.ttv_cod_campo_15 = string(0,ENTRY(15,v_cod_format,chr(10))) then "" else tt_demonst_ctbl_fin.ttv_cod_campo_15 + '%'.
                    end.
                    /* End_Include: i_totaliza_colunas_demonst_2 */

                end.
            end.
            find next tt_label_demonst_ctbl_video
               where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
            if not avail tt_label_demonst_ctbl_video then 
                leave.
            find first tt_col_demonst_ctbl no-lock
               where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
               no-error.
        end.

         /* Begin_Include: i_totaliza_colunas_demonst2 */
         /* fo 1010914 
          a totalizaá∆o quando f¢rmula/variaá∆o deve ser calculada e n∆o somada */
         /* FO 1053928
          Alterado programa para acumular corretamente na estrutura de visualizaá∆o, 
          as colunas que tem em sua f¢rmula, outras colunas que s∆o base de c†lculo.*/

         find first tt_label_demonst_ctbl_video
             where  tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
         find first tt_col_demonst_ctbl no-lock
             where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
            no-error.

         /* Decimais Chile */
         if v_log_funcao_tratam_dec then do:
             find first tt_col_demonst_ctbl_ext
                 where tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                   and tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
             if avail tt_col_demonst_ctbl_ext then
                 assign v_cod_moed_finalid = tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid.
         end.


         do v_num_column = v_num_initial to 15:

             /* * Para a lΩgica de valores serˇ desconsiderada a coluna de t≠tulos **/
             if  avail tt_label_demonst_ctbl_video and tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_T°tulo*/  /* l_titulo*/   and v_num_lin_tit <> 0
             then do:
                   find next tt_label_demonst_ctbl_video
                        where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
                   IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
                   find first tt_col_demonst_ctbl no-lock
                        where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                        and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                        no-error.
                   next.
             end.

             if  tt_demonst_ctbl_fin.ttv_log_expand_usuar = no
                and can-find(first btt_demonst_ctbl_fin no-lock
                             where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin))
             then do:
                 if  tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "F¢rmula" /*l_Formula*/ 
                 then do:
                     if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "F¢rmula" /*l_Formula*/ 
                     then do:
                        /* calcula f¢rmula */
                        ASSIGN v_val_sdo_ctbl = 0.
                        for each tt_var_formul_1:
                            delete tt_var_formul_1.
                        end.
                        run pi_ident_var_formul_1 (Input tt_col_demonst_ctbl.des_formul_ctbl) /*pi_ident_var_formul_1*/.
                        for each tt_var_formul_1 no-lock:
                            /* là o buffer da tt_col_demonst_ctbl para verificar buscar as colunas que fazem parte da formula que estam fora
                               da quantidade de colunas que s∆o mostradas em video.*/
                            find btt_col_demonst_ctbl
                                 where btt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_var_formul_1.ttv_cod_var_formul no-error.
                            if  avail btt_col_demonst_ctbl
                            then do:
                                ASSIGN v_val_sdo_ctbl = 0.
                                if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                                then do:
                                    for each btt_demonst_ctbl_fin no-lock
                                       where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):

                                         run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                       Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                    end.
                                    if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                     where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                    then do:
                                        create tt_valor_demonst_ctbl_total.
                                        assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                               tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                    end /* if */.
                                    else do:
                                        find tt_valor_demonst_ctbl_total
                                            where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                         if avail tt_valor_demonst_ctbl_total then
                                           assign tt_valor_demonst_ctbl_total.ttv_val_coluna = tt_valor_demonst_ctbl_total.ttv_val_coluna + v_val_sdo_ctbl.
                                    end /* else */.
                                end /* if */.
                                else do:
                                    for each btt_demonst_ctbl_fin no-lock
                                       where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                         run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                       Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                         if  btt_demonst_ctbl_fin.ttv_log_tot_estrut
                                         then do:
                                             if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                             where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                             then do:
                                                 create tt_valor_demonst_ctbl_total.
                                                 assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                                        tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                             end /* if */.
                                             else do:
                                                 find tt_valor_demonst_ctbl_total
                                                     where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl NO-ERROR.
                                                 if avail tt_valor_demonst_ctbl_total then
                                                    assign tt_valor_demonst_ctbl_total.ttv_val_coluna = tt_valor_demonst_ctbl_total.ttv_val_coluna + v_val_sdo_ctbl.
                                             end /* else */.
                                         end /* if */.
                                    end.
                                end /* else */.
                                if v_val_sdo_ctbl <> ? then
                                    assign tt_var_formul_1.ttv_val_var_formul_1 = v_val_sdo_ctbl.
                                else 
                                    assign tt_var_formul_1.ttv_val_var_formul_1 = 0.
                            end /* if */.
                        end.
                        assign v_val_sdo_ctbl = 0.
                        run pi_calcul_formul_1 (input-output v_val_sdo_ctbl,
                                                input tt_col_demonst_ctbl.des_formul_ctbl,
                                                output v_log_return,
                                                Input yes) /* pi_calcul_formul_1*/.
                        if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.               
                     end.

                     if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Variaá∆o" /*l_Variacao*/ 
                     then do:
                        /* Calcula Variacao */
                        find btt_col_demonst_ctbl
                             where btt_col_demonst_ctbl.cod_col_demonst_ctbl = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 1, 2)) no-error.
                        if  avail btt_col_demonst_ctbl
                        then do:
                            assign v_val_sdo_ctbl = 0.
                            if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                            then do:
                                find tt_valor_demonst_ctbl_total
                                    where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                if  avail tt_valor_demonst_ctbl_total then
                                    assign v_val_sdo_ctbl = tt_valor_demonst_ctbl_total.ttv_val_coluna.
                            end /* if */.
                            else do:
                                for each btt_demonst_ctbl_fin no-lock
                                    where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                    run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                  Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                    if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                     where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                    then do:
                                        create tt_valor_demonst_ctbl_total.
                                        assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                               tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                    end /* if */.
                                    else do:
                                        find tt_valor_demonst_ctbl_total
                                             where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                        if avail tt_valor_demonst_ctbl_total then
                                           assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                    end /* else */.
                                end.
                            end /* else */.
                            if  v_val_sdo_ctbl <> ? then
                                assign v_val_sdo_idx = v_val_sdo_ctbl.
                            else 
                                assign v_val_sdo_idx = 0.
                        end /* if */.

                        find btt_col_demonst_ctbl
                             where btt_col_demonst_ctbl.cod_col_demonst_ctbl = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 6, 2)) no-error.
                        if  avail btt_col_demonst_ctbl
                        then do:
                            assign v_val_sdo_ctbl = 0.
                            if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                            then do:
                                find tt_valor_demonst_ctbl_total
                                    where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                if  avail tt_valor_demonst_ctbl_total then
                                    assign v_val_sdo_ctbl = tt_valor_demonst_ctbl_total.ttv_val_coluna.
                            end /* if */.
                            else do:
                                for each btt_demonst_ctbl_fin no-lock
                                   where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                    run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                  Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                    if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                     where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                    then do:
                                        create tt_valor_demonst_ctbl_total.
                                        assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                               tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                    end /* if */.
                                    else do:
                                        find tt_valor_demonst_ctbl_total
                                            where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                        if avail tt_valor_demonst_ctbl_total then
                                           assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                    end /* if */.
                                end.
                            end /* else */.
                            if v_val_sdo_ctbl <> ? then
                                assign v_val_sdo_base = v_val_sdo_ctbl.
                            else
                                assign v_val_sdo_base = 0.
                        end /* if */.

                        if  v_val_sdo_idx  <> 0
                        and v_val_sdo_base <> 0
                        then do:
                            assign v_val_sdo_ctbl = FnAjustDec(dec(v_val_sdo_idx / v_val_sdo_base * 100 - 100), v_cod_moed_finalid).
                            if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.
                        end /* if */.
                     end /* if */.

                     if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/    OR
                          tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_Variacao*/ 
                     then do:
                          if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                          where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl)
                          then do:
                              create tt_valor_demonst_ctbl_total.
                              assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                                     tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl .
                          end /* if */.
                          else do:
                              find tt_valor_demonst_ctbl_total
                                  where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl no-error.
                              if avail tt_valor_demonst_ctbl_total then
                                 assign tt_valor_demonst_ctbl_total.ttv_val_coluna =  v_val_sdo_ctbl .
                          end /* else */.
                          case v_num_column:
                              when 1 then if v_num_lin_tit <> v_num_col + 1 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = string(v_val_sdo_ctbl,ENTRY(1,v_cod_format,chr(10))).
                              when 2 then if v_num_lin_tit <> v_num_col + 2 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = string(v_val_sdo_ctbl,ENTRY(2,v_cod_format,chr(10))).
                              when 3 then if v_num_lin_tit <> v_num_col + 3 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = string(v_val_sdo_ctbl,ENTRY(3,v_cod_format,chr(10))).
                              when 4 then if v_num_lin_tit <> v_num_col + 4 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = string(v_val_sdo_ctbl,ENTRY(4,v_cod_format,chr(10))).
                              when 5 then if v_num_lin_tit <> v_num_col + 5 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = string(v_val_sdo_ctbl,ENTRY(5,v_cod_format,chr(10))).
                              when 6 then if v_num_lin_tit <> v_num_col + 6 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = string(v_val_sdo_ctbl,ENTRY(6,v_cod_format,chr(10))).
                              when 7 then if v_num_lin_tit <> v_num_col + 7 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = string(v_val_sdo_ctbl,ENTRY(7,v_cod_format,chr(10))).
                              when 8 then if v_num_lin_tit <> v_num_col + 8 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = string(v_val_sdo_ctbl,ENTRY(8,v_cod_format,chr(10))).
                              when 9 then if v_num_lin_tit <> v_num_col + 9 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = string(v_val_sdo_ctbl,ENTRY(9,v_cod_format,chr(10))).
                              when 10 then if v_num_lin_tit <> v_num_col + 10 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = string(v_val_sdo_ctbl,ENTRY(10,v_cod_format,chr(10))).
                              when 11 then if v_num_lin_tit <> v_num_col + 11 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = string(v_val_sdo_ctbl,ENTRY(11,v_cod_format,chr(10))).
                              when 12 then if v_num_lin_tit <> v_num_col + 12 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = string(v_val_sdo_ctbl,ENTRY(12,v_cod_format,chr(10))).
                              when 13 then if v_num_lin_tit <> v_num_col + 13 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = string(v_val_sdo_ctbl,ENTRY(13,v_cod_format,chr(10))).
                              when 14 then if v_num_lin_tit <> v_num_col + 14 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = string(v_val_sdo_ctbl,ENTRY(14,v_cod_format,chr(10))).
                              when 15 then if v_num_lin_tit <> v_num_col + 15 then
                                  assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = string(v_val_sdo_ctbl,ENTRY(15,v_cod_format,chr(10))).
                         end.
                     end /* if */.
                 end /* if */.
             end /* if */.
             find next tt_label_demonst_ctbl_video
                  where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col no-error.
             if not avail tt_label_demonst_ctbl_video then 
                leave.
             find first tt_col_demonst_ctbl no-lock
                  where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                    and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                  no-error.
         end.
         /* End_Include: i_totaliza_colunas_demonst2 */


        /* End_Include: i_totaliza_colunas_demonst2 */

    end.

    /* ***[ Grava Dados Retornados da API ]****/
    CREATE tt_retorno_demonst.
    ASSIGN tt_retorno_demonst.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
           tt_retorno_demonst.tta_des_tit_ctbl              = demonst_ctbl.des_tit_ctbl
           tt_retorno_demonst.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
           tt_retorno_demonst.ttv_des_padr                  = padr_col_demonst_ctbl.des_tit_ctbl
           tt_retorno_demonst.tta_num_seq_demonst_ctbl      = v_num_seq_demonst_ctbl
           tt_retorno_demonst.ttv_des_label_col             = v_des_label_col
           tt_retorno_demonst.ttv_des_label_sig_indic       = v_des_label_sig_indic
           tt_retorno_demonst.ttv_cod_carac_lim             = tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
           tt_retorno_demonst.ttv_des_linha                 = v_des_linha
           tt_retorno_demonst.ttv_cod_empres_usuar          = v_cod_empres_usuar
           tt_retorno_demonst.ttv_nom_enterprise            = v_nom_enterprise
           tt_retorno_demonst.ttv_cod_periodo               = string(v_dat_inic_period_ctbl,'99/99/9999') + chr(32) + "A" /*l_A*/  + chr(32) + string(v_dat_fim_period_ctbl,'99/99/9999') + chr(32).

    /* Cria temp-table que ser† utilizada para impress∆o */
    run pi_cria_tt_impressao_demonst (Input v_num_col_max - 1) /*pi_cria_tt_impressao_demonst*/.

    /* Monta informaá‰es da linha a ser impressa */
    FOR EACH tt_demonst_ctbl_video NO-LOCK
        BREAK BY tt_demonst_ctbl_video.tta_num_seq_demonst_ctbl 
              BY tt_demonst_ctbl_video.ttv_num_seq_item_demonst_ctbl:

        DO v_num_column = 1 TO v_num_col_max:
            assign v_des_val_col  = v_des_val_col +
                                    right-trim(string(entry(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10)))) +
                                    tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim.
        END.

        if  v_log_funcao_dw_demonst
        then do:
            find first b_item_demonst_ctbl no-lock
                where b_item_demonst_ctbl.cod_demonst_ctbl     = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                  and b_item_demonst_ctbl.num_seq_demonst_ctbl = tt_demonst_ctbl_video.ttv_num_seq_item_demonst_ctbl no-error.
            if avail b_item_demonst_ctbl then do:
                &if '{&emsuni_version}' >= "5.07" &then
                    assign v_cod_layout_fisc       = b_item_demonst_ctbl.cod_layout_fisc
                           v_cod_reg_layout_fisc   = b_item_demonst_ctbl.cod_reg_layout_fisc
                           v_num_campo_layout_fisc = b_item_demonst_ctbl.num_campo_layout_fisc
                           v_num_col_layout_fisc   = b_item_demonst_ctbl.num_col_layout_fisc.
                &else
                    assign v_cod_layout_fisc       = GetEntryField(1,b_item_demonst_ctbl.cod_Livre_1,chr(10))
                           v_cod_reg_layout_fisc   = GetEntryField(2,b_item_demonst_ctbl.cod_Livre_1,chr(10))
                           v_num_campo_layout_fisc = int(GetEntryField(3,b_item_demonst_ctbl.cod_Livre_1,chr(10)))
                           v_num_col_layout_fisc   = int(GetEntryField(4,b_item_demonst_ctbl.cod_Livre_1,chr(10))).
                &endif
                if v_cod_layout_fisc <> "" then do:
                    assign v_des_val_col = v_des_val_col + v_cod_layout_fisc  + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
                                         + v_cod_reg_layout_fisc              + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
                                         + string(v_num_campo_layout_fisc)    + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim
                                         + string(v_num_col_layout_fisc,'99') + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim.
                end.
            end.
        end /* if */.

        /* ------------------------------------- EPC ---------------------------------------*/
        /* Esta epc visa alterar o conte£do da vari†vel v_des_val_col (que representa a linha do demonstrativo cont†bil) */
        if  v_nom_prog_dpc  <> ''
        or  v_nom_prog_upc  <> ''
        or  v_nom_prog_appc <> ''
        then do:
            for each tt_epc:
                delete tt_epc.
            end.

            create tt_epc.
            assign tt_epc.cod_event     = 'DWF'
                   tt_epc.cod_param     = 'DEMONSTRATIVO'
                   tt_epc.val_parameter = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl.

            create tt_epc.
            assign tt_epc.cod_event     = 'DWF'
                   tt_epc.cod_param     = 'SEQUENCIA ITEM DEMONSTRATIVO'
                   tt_epc.val_parameter = STRING(tt_demonst_ctbl_video.ttv_num_seq_item_demonst_ctbl).

            create tt_epc.
            assign tt_epc.cod_event     = 'DWF'
                   tt_epc.cod_param     = 'LINHA'
                   tt_epc.val_parameter = v_des_val_col.

            create tt_epc.
            assign tt_epc.cod_event     = 'DWF'
                   tt_epc.cod_param     = 'DELIMITADOR'
                   tt_epc.val_parameter = tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim.

            if v_nom_prog_dpc <> "" then
                run value(v_nom_prog_dpc) (input 'DWF', input-output table tt_epc).
            else if v_nom_prog_upc <> "" then
                run value(v_nom_prog_upc) (input 'DWF', input-output table tt_epc).
            else if v_nom_prog_appc <> "" then
                run value(v_nom_prog_appc) (input 'DWF', input-output table tt_epc).

            find tt_epc
               where tt_epc.cod_event     = 'DWF'
               and   tt_epc.cod_parameter = 'LINHA' no-lock no-error.
            if avail tt_epc then do:
                assign v_des_val_col = tt_epc.val_parameter.
            end.
        end /* if */.
        /* ----------------------------------- FIM EPC -------------------------------------*/

        CREATE tt_retorno_demonst_lin_1.
        ASSIGN tt_retorno_demonst_lin_1.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
               tt_retorno_demonst_lin_1.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
               tt_retorno_demonst_lin_1.ttv_num_seq_lin               = v_num_linha
               tt_retorno_demonst_lin_1.ttv_num_seq_lin_demonst       = tt_demonst_ctbl_video.ttv_num_seq_item_demonst_ctbl           
               tt_retorno_demonst_lin_1.ttv_des_val_col               = v_des_val_col.

        /* Zera conte£do da vari†vel para pr¢xima impress∆o e atualiza contador linha */
        ASSIGN v_des_val_col = ""
               v_num_linha   = v_num_linha + 1.
    END.
END PROCEDURE. /* pi_retorno_api_demonst_ctbl_video_sped */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_lin_titulo
** Descricao.............: pi_carrega_lin_titulo
** Criado por............: bre17752
** Criado em.............: 30/07/2001 02:06:45
** Alterado por..........: fut12209
** Alterado em...........: 17/12/2007 09:47:57
*****************************************************************************/
PROCEDURE pi_carrega_lin_titulo:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_cont
        as integer
        format ">,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_rec_demonst_ctbl_video_2       as recid           no-undo. /*local*/
    def var v_rec_demonst_ctbl_video_3       as recid           no-undo. /*local*/
    def var v_rec_demonst_ctbl_video_4       as recid           no-undo. /*local*/
    def var v_rec_demonst_ctbl_video_5       as recid           no-undo. /*local*/


    /************************** Variable Definition End *************************/

    for each tt_item_demonst_ctbl_video
      break by tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl
           by tt_item_demonst_ctbl_video.ttv_cod_chave_1
           by tt_item_demonst_ctbl_video.ttv_cod_chave_2
           by tt_item_demonst_ctbl_video.ttv_cod_chave_3
           by tt_item_demonst_ctbl_video.ttv_cod_chave_4
           by tt_item_demonst_ctbl_video.ttv_cod_chave_5
           by tt_item_demonst_ctbl_video.ttv_cod_chave_6:
      if  tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then do:
         assign p_num_cont = p_num_cont + 10.
         create tt_demonst_ctbl_fin.
         assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                tt_demonst_ctbl_fin.ttv_log_expand = NO
                tt_demonst_ctbl_fin.ttv_des_col_demonst_video = tt_item_demonst_ctbl_video.tta_des_tit_ctbl
                tt_demonst_ctbl_fin.ttv_cod_inform_princ = "T°tulo" /*l_titulo*/  .

         /* Begin_Include: i_carrega_col_titulo */
         case v_num_lin_tit:
             when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
             when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
         end case.
         /* End_Include: i_carrega_col_titulo */
         .
       end.

      if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "Chr Espec" /*l_hr_espec*/  then do:
          assign p_num_cont = p_num_cont + 10.
          create tt_demonst_ctbl_fin.
          assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                 tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                 tt_demonst_ctbl_fin.ttv_log_expand = NO
                 tt_demonst_ctbl_fin.ttv_des_col_demonst_video = tt_item_demonst_ctbl_video.tta_des_tit_ctbl
                 tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Chr Espec" /*l_hr_espec*/ .
          next.
      end.
       find tt_item_demonst_ctbl_cadastro
          where tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad no-lock no-error.
      if not avail tt_item_demonst_ctbl_cadastro then
          next.
       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_1)
      and ( tt_item_demonst_ctbl_video.ttv_cod_chave_1 <> '' 
      or  (tt_item_demonst_ctbl_video.ttv_cod_chave_1 = '' 
      and  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst <> "C†lculo" /*l_calculo*/  
      and  tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/ )) then do:
         assign p_num_cont = p_num_cont + 10.
         create tt_demonst_ctbl_fin.
         assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                tt_demonst_ctbl_fin.ttv_log_expand = NO
                v_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)
                tt_demonst_ctbl_fin.ttv_des_col_demonst_video = tt_item_demonst_ctbl_video.ttv_des_chave_1.
          if  tt_item_demonst_ctbl_video.ttv_cod_chave_1 <> "" then do:
              case v_num_lin_tit:
                 when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
                 when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 =  tt_item_demonst_ctbl_video.ttv_des_chave_1.
             end case.
            assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(1,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
            run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                        Input entry(1,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_1) /*pi_identifica_conteudo*/.
         end.
         if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
             assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.
         if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/   then
             assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
      end.
       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_2) 
       and tt_item_demonst_ctbl_video.ttv_cod_chave_2 <> '' then do:
         assign p_num_cont = p_num_cont + 10.
         create tt_demonst_ctbl_fin.
         assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                tt_demonst_ctbl_fin.ttv_log_expand = NO
                tt_demonst_ctbl_fin.ttv_num_nivel  = 1
                tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video
                v_rec_demonst_ctbl_video_2 = recid(tt_demonst_ctbl_fin)
                tt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.

          /* Se a linha PAI for Estabelecimento desabilita a opªío */
          if  can-find(first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video
              and  btt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/  ) then
              assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
          /* tem visualizaá∆o definida para o item ent∆o para linha anterior atribui ttv_log_expand = yes, 
             para n∆o permitir expans∆o desta linha. */ 
          find first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video no-lock no-error.
          if avail btt_demonst_ctbl_fin then
              assign btt_demonst_ctbl_fin.ttv_log_expand = yes.

          if  tt_item_demonst_ctbl_video.ttv_cod_chave_2 <> "" then do:
             assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(2,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).

             /* Begin_Include: i_carrega_lin_titulo_1 */
              case v_num_lin_tit:
                  when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                  when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",4) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
              end case.
             /* End_Include: i_carrega_lin_titulo_1 */

             run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                         Input entry(2,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                         Input tt_item_demonst_ctbl_video.ttv_cod_chave_2) /*pi_identifica_conteudo*/.
          end.
          if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
              assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.
       end.

       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_3) 
       and tt_item_demonst_ctbl_video.ttv_cod_chave_3 <> ''
       then do:
          assign p_num_cont = p_num_cont + 10.
          create tt_demonst_ctbl_fin.
          assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                 tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                 tt_demonst_ctbl_fin.ttv_log_expand = NO
                 tt_demonst_ctbl_fin.ttv_num_nivel  = 2
                 tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video_2
                 v_rec_demonst_ctbl_video_3 = recid(tt_demonst_ctbl_fin)
                 tt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.

          /* Se a linha PAI for Estabelecimento desabilita a opªío */
          if  can-find(first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_2
              and  btt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/  ) then
              assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
          /* tem visualizaá∆o definida para o item ent∆o para linha anterior atribui ttv_log_expand = yes, 
             para n∆o permitir expans∆o desta linha. */ 
          find first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_2
              no-lock no-error.
          if avail btt_demonst_ctbl_fin then
              assign btt_demonst_ctbl_fin.ttv_log_expand = yes.

          if  tt_item_demonst_ctbl_video.ttv_cod_chave_3 <> ""
          then do:
             assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(3,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
             case v_num_lin_tit:
                 when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                 when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",8) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
              end case. 
             run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                         Input entry(3,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                         Input tt_item_demonst_ctbl_video.ttv_cod_chave_3) /*pi_identifica_conteudo*/.
          end.
          if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
              assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.      
       end.

       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_4) 
       and tt_item_demonst_ctbl_video.ttv_cod_chave_4 <> ''
       then do:
          assign p_num_cont = p_num_cont + 10.
          create tt_demonst_ctbl_fin.
          assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                 tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                 tt_demonst_ctbl_fin.ttv_log_expand = NO
                 tt_demonst_ctbl_fin.ttv_num_nivel  = 3
                 tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video_3
                 v_rec_demonst_ctbl_video_4 = recid(tt_demonst_ctbl_fin)
                 tt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.

          /* Se a linha PAI for Estabelecimento desabilita a opªío */
          if  can-find(first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_3
              and  btt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/  ) then
              assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
          /* tem visualizaá∆o definida para o item ent∆o para linha anterior atribui ttv_log_expand = yes, 
             para n∆o permitir expans∆o desta linha. */ 
          find first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_3 no-lock no-error.
          if avail btt_demonst_ctbl_fin then
              assign btt_demonst_ctbl_fin.ttv_log_expand = yes.

          if  tt_item_demonst_ctbl_video.ttv_cod_chave_4 <> "" then do:
             assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(4,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
         case v_num_lin_tit:
             when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
             when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",12) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
         end case.
             run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                         Input entry(4,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                         Input tt_item_demonst_ctbl_video.ttv_cod_chave_4) /*pi_identifica_conteudo*/.
          end.
          if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
              assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.      
       end.

       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_5) 
       and tt_item_demonst_ctbl_video.ttv_cod_chave_5 <> '' then do:
          assign p_num_cont = p_num_cont + 10.
          create tt_demonst_ctbl_fin.
          assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                 tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                 tt_demonst_ctbl_fin.ttv_log_expand = NO
                 tt_demonst_ctbl_fin.ttv_num_nivel  = 4
                 tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video_4
                 v_rec_demonst_ctbl_video_5 = recid(tt_demonst_ctbl_fin)
                 tt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.

          /* Se a linha PAI for Estabelecimento desabilita a opªío */
          if  can-find(first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_4
              and  btt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/  ) then
              assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
          /* tem visualizaá∆o definida para o item ent∆o para linha anterior atribui ttv_log_expand = yes, 
             para n∆o permitir expans∆o desta linha. */ 
          find first btt_demonst_ctbl_fin
              where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_4 no-lock no-error.
          if avail btt_demonst_ctbl_fin then
              assign btt_demonst_ctbl_fin.ttv_log_expand = yes.

          if  tt_item_demonst_ctbl_video.ttv_cod_chave_5 <> "" then do:
             assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(5,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
             case v_num_lin_tit:
                 when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                 when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",16) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
             end case.    
             run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                         Input entry(5,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                         Input tt_item_demonst_ctbl_video.ttv_cod_chave_5) /*pi_identifica_conteudo*/.
          end.
          if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
              assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.      
       end.
       if  first-of(tt_item_demonst_ctbl_video.ttv_cod_chave_6) 
       and tt_item_demonst_ctbl_video.ttv_cod_chave_6 <> '' then do:
         assign p_num_cont = p_num_cont + 10.
         create tt_demonst_ctbl_fin.
         assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = p_num_cont
                tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                tt_demonst_ctbl_fin.ttv_log_expand = NO
                tt_demonst_ctbl_fin.ttv_num_nivel  = 5
                tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video_5
                tt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
         /* Se a linha PAI for Estabelecimento desabilita a opªío */
         if  can-find(first btt_demonst_ctbl_fin
             where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_5
             and  btt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/ ) then
             assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
         /* tem visualizaá∆o definida para o item ent∆o para linha anterior atribui ttv_log_expand = yes, 
            para n∆o permitir expans∆o desta linha. */ 

         find first btt_demonst_ctbl_fin
             where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_5 no-lock no-error.
         if avail btt_demonst_ctbl_fin then
             assign btt_demonst_ctbl_fin.ttv_log_expand = yes.
          if  tt_item_demonst_ctbl_video.ttv_cod_chave_6 <> "" then do:
            assign tt_demonst_ctbl_fin.ttv_cod_inform_princ = entry(6,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).

             /* Begin_Include: i_carrega_lin_titulo_aux */
             case v_num_lin_tit:
                  when 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 3 then assign tt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 4 then assign tt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 5 then assign tt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 6 then assign tt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 7 then assign tt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 8 then assign tt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 9 then assign tt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 10 then assign tt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 11 then assign tt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 12 then assign tt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 13 then assign tt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 14 then assign tt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                  when 15 then assign tt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",20) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
              end case.
             /* End_Include: i_carrega_lin_titulo_aux */

            run pi_identifica_conteudo (Input tt_demonst_ctbl_fin.ttv_num_nivel,
                                        Input entry(6,tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)),
                                        Input tt_item_demonst_ctbl_video.ttv_cod_chave_6) /*pi_identifica_conteudo*/.
          end.
          if  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Conta Cont†bil" /*l_Conta_Cont†bil*/  then
              assign tt_demonst_ctbl_fin.ttv_log_tot_estrut = yes.      
       end.
    end.
END PROCEDURE. /* pi_carrega_lin_titulo */
/*****************************************************************************
** Procedure Interna.....: pi_busca_filhos_recursiv
** Descricao.............: pi_busca_filhos_recursiv
** Criado por............: src507
** Criado em.............: 22/10/2002 11:24:56
** Alterado por..........: fut12209_2
** Alterado em...........: 31/03/2005 10:02:33
*****************************************************************************/
PROCEDURE pi_busca_filhos_recursiv:

    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_demonst_ctbl
        as recid
        format ">>>>>>9"
        no-undo.
    def Input param p_cod_col_demonst_ctbl_aux
        as character
        format "x(2)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_demonst_ctbl_fin_aux
        for tt_demonst_ctbl_fin.


    /*************************** Buffer Definition End **************************/

    if can-find(first btt_demonst_ctbl_fin_aux
                where btt_demonst_ctbl_fin_aux.ttv_rec_demonst_ctbl_video = p_rec_demonst_ctbl) then do:
        for each btt_demonst_ctbl_fin_aux no-lock
           where btt_demonst_ctbl_fin_aux.ttv_rec_demonst_ctbl_video = p_rec_demonst_ctbl:
            run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin_aux),
                                          Input p_cod_col_demonst_ctbl_aux) /*pi_busca_filhos_recursiv*/.
        end.
    end.
    else do:
        find btt_demonst_ctbl_fin_aux
           where recid(btt_demonst_ctbl_fin_aux) = p_rec_demonst_ctbl
           no-lock no-error.
        if avail btt_demonst_ctbl_fin_aux then do:

            if v_log_acum_cta_ctbl_sint = no then do:
                if btt_demonst_ctbl_fin_aux.ttv_log_analit = no then
                    return.
            end.

            find tt_valor_demonst_ctbl_video
                where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = p_cod_col_demonst_ctbl_aux
                and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = btt_demonst_ctbl_fin_aux.ttv_rec_item_demonst_ctbl_video no-error.
            if  avail tt_valor_demonst_ctbl_video then do:
                assign v_val_sdo_ctbl = v_val_sdo_ctbl + dec(tt_valor_demonst_ctbl_video.ttv_val_col_1).
            end.
        end.
    end.

END PROCEDURE. /* pi_busca_filhos_recursiv */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_1
** Descricao.............: pi_calcul_formul_1
** Criado por............: Roberto
** Criado em.............: 24/08/1999 08:53:23
** Alterado por..........: Roberto
** Alterado em...........: 24/08/1999 10:15:03
*****************************************************************************/
PROCEDURE pi_calcul_formul_1:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.
    def input param p_des_formul
        as character
        format "x(80)"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param p_log_mostrar_msg_erro
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign v_log_mostrar_msg_erro = p_log_mostrar_msg_erro.

    assign v_num_posicao = 0
           v_des_formul  = "".

    main_block:
    do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

       assign v_num_posicao            = 1
              v_val_restdo_formul      = 0
              v_ind_operac_formul      = ""
              v_ind_tip_operac_formul  = ""
              v_des_formul             = p_des_formul
              p_log_return             = no.

       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       if  v_ind_operac_formul = "Final" /*l_final*/ 
          or v_ind_operac_formul = ""
       then do:
          return.
       end /* if */.
       run pi_calcul_formul_2 (input-output p_val_restdo_formul) /*pi_calcul_formul_2*/.

    end /* do main_block */.

    assign p_log_return = v_log_retorno.
END PROCEDURE. /* pi_calcul_formul_1 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_obtem_objeto
** Descricao.............: pi_calcul_formul_obtem_objeto
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:51:44
** Alterado por..........: josecarlos
** Alterado em...........: 29/07/1996 14:49:53
*****************************************************************************/
PROCEDURE pi_calcul_formul_obtem_objeto:

    /* ** Obtem  objeto da formula ***/
    assign v_ind_operac_formul     = ""
           v_ind_tip_operac_formul = "".

    if  v_num_posicao > length(v_des_formul)
    then do: /* ** N∆o tem mais formula ***/
        assign v_ind_operac_formul      = "Final" /*l_final*/ 
               v_ind_tip_operac_formul  = "DLM" /*l_dlm*/ .
               return.
    end /* if */.

    block1:
    do /* ** Pula brancos da formula ***/
        while v_num_posicao <= length(v_des_formul):
        if  substring(v_des_formul, v_num_posicao, 1) = " "
        then do:
           assign v_num_posicao = v_num_posicao + 1.
        end /* if */.
        else do:
           leave block1.
        end /* else */.
    end /* do block1 */.

    if  v_num_posicao > length(v_des_formul)
    then do: /* ** N∆o tem mais formula ***/
        assign v_ind_operac_formul      = "Final" /*l_final*/ 
               v_ind_tip_operac_formul  = "DLM" /*l_dlm*/ .
        return.
    end /* if */.

    if  index("+-*^/()",substring(v_des_formul, v_num_posicao, 1))  <> 0
    then do: /* ** Objeto Ç operador  +-*^/() ***/
        assign v_ind_operac_formul      = substring(v_des_formul, v_num_posicao, 1)
               v_ind_tip_operac_formul = "DLM" /*l_dlm*/ 
               v_num_posicao            = v_num_posicao + 1.
        return.
    end /* if */.

    if  index("0123456789.",substring(v_des_formul, v_num_posicao, 1)) <> 0
    then do:  /* ** Objeto Ç n£mero ***/
        block2:
        do
        while index("0123456789.",substring(v_des_formul, v_num_posicao, 1)) <> 0:
            assign v_ind_operac_formul  = v_ind_operac_formul + substring(v_des_formul, v_num_posicao, 1)
                   v_num_posicao        = v_num_posicao + 1.
        end /* do block2 */.
        assign v_ind_tip_operac_formul = "NUM" /*l_numerico*/ .
        return.
    end /* if */.

    block3:
    do /* ** Interpreta a vari†vel ***/
        while index("+-*^/()",substring(v_des_formul, v_num_posicao, 1)) = 0 and
                    v_num_posicao <= length(v_des_formul) and
                    substring(v_des_formul, v_num_posicao, 1) <> " ":
        assign v_ind_operac_formul = v_ind_operac_formul + substring(v_des_formul, v_num_posicao, 1)
               v_num_posicao       = v_num_posicao + 1.
    end /* do block3 */.
    assign v_ind_tip_operac_formul = "VAR" /*l_var*/ .
    return.
END PROCEDURE. /* pi_calcul_formul_obtem_objeto */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_2
** Descricao.............: pi_calcul_formul_2
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:52:17
** Alterado por..........: josecarlos
** Alterado em...........: 29/07/1996 11:53:11
*****************************************************************************/
PROCEDURE pi_calcul_formul_2:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_operac_formul_2            as character       no-undo. /*local*/
    def var v_val_restdo_formul_2            as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    run pi_calcul_formul_3 (input-output p_val_restdo_formul) /*pi_calcul_formul_3*/.
    assign v_ind_operac_formul_2 = v_ind_operac_formul.
    /* ** Executa soma o substraá∆o ***/
    block:
    do
    while v_ind_operac_formul_2  = "+" /*l_+*/  or
          v_ind_operac_formul_2  = "-" /*l_-*/ :
        run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
        run pi_calcul_formul_3 (input-output v_val_restdo_formul_2) /*pi_calcul_formul_3*/.
        run pi_calcul_formul_aritmetica (Input v_ind_operac_formul_2,
                                         input-output p_val_restdo_formul,
                                         input-output v_val_restdo_formul_2) /*pi_calcul_formul_aritmetica*/.
        assign v_ind_operac_formul_2 = v_ind_operac_formul.
    end /* do block */.
END PROCEDURE. /* pi_calcul_formul_2 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_3
** Descricao.............: pi_calcul_formul_3
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:52:26
** Alterado por..........: josecarlos
** Alterado em...........: 01/10/1997 10:13:56
*****************************************************************************/
PROCEDURE pi_calcul_formul_3:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_operac_formul_2            as character       no-undo. /*local*/
    def var v_val_restdo_formul_2            as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    run pi_calcul_formul_4 (input-output p_val_restdo_formul) /*pi_calcul_formul_4*/.
    assign v_ind_operac_formul_2 = v_ind_operac_formul.
    /* ** Executa multiplicaá∆o ou divis∆o ***/
    block4:
    do
    while v_ind_operac_formul_2 = '*' or
          v_ind_operac_formul_2 = '/':
        run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
        run pi_calcul_formul_4 (input-output v_val_restdo_formul_2) /*pi_calcul_formul_4*/.
        run pi_calcul_formul_aritmetica (Input v_ind_operac_formul_2,
                                         input-output p_val_restdo_formul,
                                         input-output v_val_restdo_formul_2) /*pi_calcul_formul_aritmetica*/.
        assign v_ind_operac_formul_2 = v_ind_operac_formul.
    end /* do block4 */.
END PROCEDURE. /* pi_calcul_formul_3 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_4
** Descricao.............: pi_calcul_formul_4
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:52:35
** Alterado por..........: josecarlos
** Alterado em...........: 29/07/1996 11:27:56
*****************************************************************************/
PROCEDURE pi_calcul_formul_4:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_val_restdo_formul_2            as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    run pi_calcul_formul_5 (input-output p_val_restdo_formul) /*pi_calcul_formul_5*/.
    /* ** Executa exponenciaá∆o ***/
    if  v_ind_operac_formul = "^"
    then do:
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       run pi_calcul_formul_4 (input-output v_val_restdo_formul_2) /*pi_calcul_formul_4*/.
       run pi_calcul_formul_aritmetica (Input "^",
                                        input-output p_val_restdo_formul,
                                        input-output v_val_restdo_formul_2) /*pi_calcul_formul_aritmetica*/.
    end /* if */.
END PROCEDURE. /* pi_calcul_formul_4 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_5
** Descricao.............: pi_calcul_formul_5
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:52:44
** Alterado por..........: josecarlos
** Alterado em...........: 29/07/1996 14:01:15
*****************************************************************************/
PROCEDURE pi_calcul_formul_5:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_operac_formul_2            as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ** Caso encontrar + ou - obter o seguinte objeto para operaá∆o soma o diferància ***/
    if  v_ind_tip_operac_formul = "DLM" /*l_dlm*/  and
       (v_ind_operac_formul     = "+" /*l_+*/  or v_ind_operac_formul = "-" /*l_-*/ )
    then do:
        assign v_ind_operac_formul_2 = v_ind_operac_formul.
        run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
    end /* if */.
    run pi_calcul_formul_6 (input-output p_val_restdo_formul) /*pi_calcul_formul_6*/.
    if  v_ind_operac_formul_2 <> ""
    then do:
       run pi_calcul_formul_inverte (Input v_ind_operac_formul_2,
                                     input-output p_val_restdo_formul) /*pi_calcul_formul_inverte*/.
    end /* if */.
END PROCEDURE. /* pi_calcul_formul_5 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_6
** Descricao.............: pi_calcul_formul_6
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:52:59
** Alterado por..........: fut12139
** Alterado em...........: 27/09/2005 16:08:07
*****************************************************************************/
PROCEDURE pi_calcul_formul_6:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_achou_tmp                  as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_log_achou_tmp     = Verifica_Program_Name('escg0204za':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('escg0204aa':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('mgl304ab':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('escg0204zi':U, 30).

    /* ** Caso que indicador Ç abre parentesis chamar pi_calcul_formul_2 recursivamente ***/
    if v_ind_operac_formul     = '(' and
       v_ind_tip_operac_formul = "DLM" /*l_dlm*/  then do:
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       run pi_calcul_formul_2 (input-output p_val_restdo_formul) /*pi_calcul_formul_2*/.
       if v_ind_operac_formul <> ')' then do: /* ** N∆o foi encontrado o fechamento do paràntesis ***/
          if  v_log_mostrar_msg_erro = yes
          then do:
              /* Faltou fechar parànteses ! */
              run pi_messages (input "show",
                               input 1236,
                               input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1236*/.
          end /* if */.
          assign v_log_retorno = yes.
       end.
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
    end.
    else do:
       if v_log_achou_tmp then    
          run pi_calcul_formul_substitui_1 (input-output p_val_restdo_formul) /*pi_calcul_formul_substitui_1*/.
       else
          run pi_calcul_formul_substitui (input-output p_val_restdo_formul) /*pi_calcul_formul_substitui*/.
    end.


END PROCEDURE. /* pi_calcul_formul_6 */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_aritmetica
** Descricao.............: pi_calcul_formul_aritmetica
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:53:19
** Alterado por..........: josecarlos
** Alterado em...........: 01/10/1997 10:17:11
*****************************************************************************/
PROCEDURE pi_calcul_formul_aritmetica:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_formul
        as character
        format "x(80)"
        no-undo.
    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.
    def input-output param p_val_restdo_formul_2
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /* ** Executa operaá∆o aritmÇtica ***/

    /* blk_operacao: */
    case p_des_formul:
       when '-' then
          assign p_val_restdo_formul = p_val_restdo_formul - p_val_restdo_formul_2.

       when '+' then
          assign p_val_restdo_formul = p_val_restdo_formul + p_val_restdo_formul_2.

       when '*' then
          assign p_val_restdo_formul = p_val_restdo_formul * p_val_restdo_formul_2.

       when '/' then
          assign p_val_restdo_formul = p_val_restdo_formul / p_val_restdo_formul_2.

       when '^' then
          assign p_val_restdo_formul = exp(p_val_restdo_formul, p_val_restdo_formul_2).

    end /* case blk_operacao */.
END PROCEDURE. /* pi_calcul_formul_aritmetica */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_inverte
** Descricao.............: pi_calcul_formul_inverte
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:53:36
** Alterado por..........: josecarlos
** Alterado em...........: 26/07/1996 18:06:33
*****************************************************************************/
PROCEDURE pi_calcul_formul_inverte:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_operac_formul
        as character
        format "X(08)"
        no-undo.
    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /* ** Invers∆o de sinal ***/
    if  p_ind_operac_formul = "-" /*l_-*/ 
    then do:
         assign p_val_restdo_formul = -1 * p_val_restdo_formul.
    end /* if */.
END PROCEDURE. /* pi_calcul_formul_inverte */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_substitui
** Descricao.............: pi_calcul_formul_substitui
** Criado por............: josecarlos
** Criado em.............: 26/07/1996 09:54:12
** Alterado por..........: BRE17140
** Alterado em...........: 24/08/1999 10:27:14
*****************************************************************************/
PROCEDURE pi_calcul_formul_substitui:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_num_format             as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ** Substitui vari†vel pelo valor dela ***/
    if  v_ind_tip_operac_formul = "VAR" /*l_var*/ 
    then do:
       find tt_var_formul no-lock
            where tt_var_formul.ttv_cod_var_formul = v_ind_operac_formul /*cl_busca_valor of tt_var_formul*/ no-error.
       if  avail tt_var_formul
       then do:
          assign p_val_restdo_formul = tt_var_formul.ttv_val_var_formul
                 v_val_restdo_formul = tt_var_formul.ttv_val_var_formul.
       end /* if */.
       else do:
          if  v_log_mostrar_msg_erro = yes
          then do:
             /* Vari†vel n∆o definida ! */
             run pi_messages (input "show",
                              input 1237,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_ind_operac_formul,v_des_formul)) /*msg_1237*/.
          end /* if */.
          assign p_val_restdo_formul = 0
                 v_log_retorno       = yes.
       end /* else */.
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       return.
    end /* if */.
    else do: /* ** Substitui o n£mero pelo valor correspondente ***/
       if  v_ind_tip_operac_formul = "NUM" /*l_numerico*/ 
       then do:
           assign v_ind_tip_num_format   = session:numeric-format.
           assign session:numeric-format = 'American'.
           assign p_val_restdo_formul    = decimal(v_ind_operac_formul).
           assign session:numeric-format = v_ind_tip_num_format.
           run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
           return.
       end /* if */.
       else do:
           if  v_log_mostrar_msg_erro = yes
           then do:
              /* Erro de sintaxe na express∆o ! */
              run pi_messages (input "show",
                               input 1238,
                               input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1238*/.
           end /* if */.
           assign v_log_retorno = yes.
       end /* else */.
    end /* else */.
END PROCEDURE. /* pi_calcul_formul_substitui */
/*****************************************************************************
** Procedure Interna.....: pi_calcul_formul_substitui_1
** Descricao.............: pi_calcul_formul_substitui_1
** Criado por............: fut12209_2
** Criado em.............: 31/03/2005 17:18:13
** Alterado por..........: fut12209_2
** Alterado em...........: 01/04/2005 15:59:01
*****************************************************************************/
PROCEDURE pi_calcul_formul_substitui_1:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_val_restdo_formul
        as decimal
        format "->>,>>>,>>>,>>9.99999999"
        decimals 8
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_num_format             as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ** Substitui vari†vel pelo valor dela ***/
    if  v_ind_tip_operac_formul = "VAR" /*l_var*/ 
    then do:
      find tt_var_formul_1 no-lock
            where tt_var_formul_1.ttv_cod_var_formul = v_ind_operac_formul no-error.
       if  avail tt_var_formul_1
       then do:
          assign p_val_restdo_formul = tt_var_formul_1.ttv_val_var_formul_1
                 v_val_restdo_formul = tt_var_formul_1.ttv_val_var_formul_1.
       end /* if */.
       else do:
          if  v_log_mostrar_msg_erro = yes
          then do:
             /* Vari†vel n∆o definida ! */
             run pi_messages (input "show",
                              input 1237,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_ind_operac_formul,v_des_formul)) /*msg_1237*/.
          end /* if */.
          assign p_val_restdo_formul = 0
                 v_log_retorno       = yes.
       end /* else */.
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       return.
    end /* if */.
    else do: /* ** Substitui o n£mero pelo valor correspondente ***/
       if  v_ind_tip_operac_formul = "NUM" /*l_numerico*/ 
       then do:
           assign v_ind_tip_num_format   = session:numeric-format.
           assign session:numeric-format = 'American'.
           assign p_val_restdo_formul    = decimal(v_ind_operac_formul).
           assign session:numeric-format = v_ind_tip_num_format.
           run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
           return.
       end /* if */.
       else do:
           if  v_log_mostrar_msg_erro = yes
           then do:
              /* Erro de sintaxe na express∆o ! */
              run pi_messages (input "show",
                               input 1238,
                               input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1238*/.
           end /* if */.
           assign v_log_retorno = yes.
       end /* else */.
    end /* else */.
END PROCEDURE. /* pi_calcul_formul_substitui_1 */
/*****************************************************************************
** Procedure Interna.....: pi_cria_tt_impressao_demonst
** Descricao.............: pi_cria_tt_impressao_demonst
** Criado por............: bre17752
** Criado em.............: 25/07/2001 22:57:10
** Alterado por..........: fut41162_3
** Alterado em...........: 17/09/2009 18:03:47
*****************************************************************************/
PROCEDURE pi_cria_tt_impressao_demonst:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_col_max
        as integer
        format ">>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_seq
        as integer
        format ">>>,>>9":U
        label "SeqÅància"
        column-label "Seq"
        no-undo.


    /************************** Variable Definition End *************************/

    /* * Inicializa temp-table para receber valores da impressío **/
    for each tt_demonst_ctbl_video:
      delete tt_demonst_ctbl_video.
    end.
    for each tt_valor_demonst_ctbl_total:
      delete tt_valor_demonst_ctbl_total.
    end.
    for each tt_col_demonst_ctbl_ext:
      delete tt_col_demonst_ctbl_ext.
    end.

    /* * Prepara temp-table com conteúdo inicial e entrada de dados **/
    for each tt_demonst_ctbl_fin use-index tt_id
        where tt_demonst_ctbl_fin.ttv_log_apres:
        create tt_demonst_ctbl_video.
        assign tt_demonst_ctbl_video.tta_num_seq_demonst_ctbl   = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl
               tt_demonst_ctbl_video.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)
               tt_demonst_ctbl_video.ttv_cod_lin_demonst        = fill(chr(10),p_num_col_max)
               tt_demonst_ctbl_video.ttv_des_lista_estab        = v_des_lista_estab /* * Atualiza este campo com os estab nío vˇlidos qdo jˇ tiver atualizado DEMO **/
               tt_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
               tt_demonst_ctbl_video.ttv_num_nivel              = tt_demonst_ctbl_fin.ttv_num_nivel.
    end.

    /* * Remonta os valores das colunas conforme posiªío da coluna atual **/
    for each tt_demonst_ctbl_fin 
        where tt_demonst_ctbl_fin.ttv_log_apres
        use-index tt_id_descending:

        find first tt_item_demonst_ctbl_video
           where  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video 
           no-error.

        find first tt_label_demonst_ctbl_video no-error.

        find first tt_demonst_ctbl_video 
           where tt_demonst_ctbl_video.tta_num_seq_demonst_ctbl = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl 
           no-error.

        /* * Campos atualizados para verificar Par≥metros de Impressío **/
        assign tt_demonst_ctbl_video.ttv_num_seq_item_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
               tt_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad.

        /* * Sai fora do bloco de totalizaªío quando a linha corrente for um t≠tulo **/
        if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then do:
            do  v_num_seq = 1 to (p_num_col_max + 1):
                if not avail tt_label_demonst_ctbl_video then 
                    next.
                /* * Atualiza campo com valor do t≠tulo parametrizado para visualizar nesta coluna **/
                if  tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then 
                    /* 218397 - Qdo tiver mais de uma coluna titulo */
                    if v_log_tit_demonst and v_num_cont_1 > 1 then do:
                        case v_num_seq:
                            when 1 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_1,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).                                              
                            when 2 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_2,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                        end case.
                    end.
                    else
                        assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                find next tt_label_demonst_ctbl_video no-error.
                IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
            end.
            next.
        end.

        /* * Sai fora do bloco de totalizaªío quando a linha corrente for caracter especial **/
        if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "Chr Espec" /*l_hr_espec*/  then do:
            do  v_num_seq = 1 to (p_num_col_max + 1):
                if not avail tt_label_demonst_ctbl_video then 
                    next.
                assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                find next tt_label_demonst_ctbl_video no-error.
                IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
            end.
            next.
        end.

        /* * Cria valores somente para os n≠veis que nío serío totalizados posteriormente **/
        if can-find(first tt_estrut_visualiz_ctbl_cad 
             where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = v_cod_demonst_ctbl
             and   tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
             and   tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz  = tt_demonst_ctbl_fin.ttv_cod_inform_princ
             and   tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = no) then do:
            if can-find(first btt_demonst_ctbl_fin 
                 where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)) then do:
                do  v_num_seq = 1 to (p_num_col_max + 1):
                    if not avail tt_label_demonst_ctbl_video then 
                        next.
                    /* * Atualiza campo com valor do t≠tulo parametrizado para visualizar nesta coluna **/
                    if  tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then
                        /* 218397 - Qdo tiver mais de uma coluna titulo */
                        if v_log_tit_demonst and  v_num_cont_1 > 1 then do:
                            case v_num_seq:
                                when 1 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_1,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).                                              
                                when 2 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_2,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                            end case.
                        end.
                        else
                            assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_seq,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                    find next tt_label_demonst_ctbl_video no-error.
                    IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
                end.
                next.
            end.
        end.


        /* Begin_Include: i_totaliza_colunas_aux */
        find first tt_col_demonst_ctbl no-lock
             where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
             no-error.

        do v_num_column = 1 to (p_num_col_max + 1):

            /* * Para a lΩgica de valores serˇ desconsiderada a coluna de t≠tulos **/
            if  avail tt_label_demonst_ctbl_video 
            and tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then do:
                /* 218397 - Qdo tiver mais de uma coluna titulo */
                if v_log_tit_demonst and v_num_cont_1 > 1 then do:
                    case v_num_column:
                        when 1 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_1,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).                                              
                        when 2 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_2,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                    end case.
                end.
                    else        
                        assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                find next tt_label_demonst_ctbl_video no-error.
                IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
                find first tt_col_demonst_ctbl no-lock
                     where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                     no-error.
                next.
            end.

            if  tt_demonst_ctbl_fin.ttv_log_expand_usuar = NO
            and can-find(first btt_demonst_ctbl_fin no-lock
                   where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)) then do:

                assign v_val_sdo_ctbl = 0.
                for each btt_demonst_ctbl_fin no-lock
                   where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                    if tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "F¢rmula" /*l_Formula*/   AND
                      (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/   OR 
                       tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_Variacao*/  )
                    then .
                    else run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                       Input tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                end.
                if tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "F¢rmula" /*l_Formula*/   AND
                  (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/  OR 
                   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     =  "Variaá∆o" /*l_Variacao*/   )
                then .
                else do:
                   /* Criar a tt_valor_demonst_ctbl_total apenas quando for a linha de n≠vel zero, para acumular o total da coluna que nío 
                      ≤ de origem fΩrmula, que poderˇ ser utilizado mais tarde para calcular o total de alguma coluna que poss≠velmente 
                      utilize esta coluna em sua fΩrmula. */
                   if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                   then do:
                       if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                       where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl)
                       then do:
                           create tt_valor_demonst_ctbl_total.
                           assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                                  tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                       end /* if */.
                       else do:
                           find tt_valor_demonst_ctbl_total
                               where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl no-error.
                           if avail tt_valor_demonst_ctbl_total then
                              assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                       end /* else */.
                   end /* if */.
                   if v_val_sdo_ctbl <> 0 then
                       assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryField(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(dec(v_val_sdo_ctbl),tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
                   else 
                       assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(0,tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
                end.
            end.
            else do:
                find tt_valor_demonst_ctbl_video
                    where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                    and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video no-error.

                if  avail tt_valor_demonst_ctbl_video then
                    assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1),tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
                else 
                    assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(0,tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
            end.
            find next tt_label_demonst_ctbl_video no-error.
            if not avail tt_label_demonst_ctbl_video then 
                leave.    
            find first tt_col_demonst_ctbl no-lock
                where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                  and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                no-error.

        end.
        /* fo 113647 - recalcular valores das colunas de f¢rmula e variaá∆o
        (antes somente somava)- neste ponto atualiza tabela utilizada na impress∆o das informaá‰es
        */  
        find first tt_label_demonst_ctbl_video no-error.
        find first tt_col_demonst_ctbl no-lock
            where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
            and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
            no-error.

        IF v_log_funcao_tratam_dec THEN DO:
             find first tt_col_demonst_ctbl_ext
                 where tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                   and tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
             if avail tt_col_demonst_ctbl_ext then
                 assign v_cod_moed_finalid = tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid.
        END.


        do v_num_column = 1 to (p_num_col_max + 1):

            /* * Para a lΩgica de valores serˇ desconsiderada a coluna de t≠tulos **/
            if  avail tt_label_demonst_ctbl_video 
            and tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then do:
                /* 218397 - Qdo tiver mais de uma coluna titulo */
                if v_log_tit_demonst and v_num_cont_1 > 1 then do:
                    case v_num_column:
                        when 1 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_1,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).                                              
                        when 2 then assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_cod_campo_2,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                    end case.
                end.
                else      
                    assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,string('x(' + string(tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) + ')'))).
                find next tt_label_demonst_ctbl_video no-error.
                IF NOT AVAIL tt_label_demonst_ctbl_video THEN LEAVE.
                find first tt_col_demonst_ctbl no-lock
                    where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                      and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                 no-error.

                 next.
            end.

            if  tt_demonst_ctbl_fin.ttv_log_expand_usuar = NO
            and can-find(first btt_demonst_ctbl_fin no-lock
                         where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)) then do:
                assign v_val_sdo_ctbl = 0.

                if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Variaá∆o" /*l_Variacao*/ 
                then do:
                   /* Calcula Variacao */
                    find btt_col_demonst_ctbl
                         where btt_col_demonst_ctbl.cod_col_demonst_ctbl = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 1, 2)) no-error.
                    if  avail btt_col_demonst_ctbl
                    then do:
                        assign v_val_sdo_ctbl = 0.
                        if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                        then do:
                            find tt_valor_demonst_ctbl_total
                                where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                            if  avail tt_valor_demonst_ctbl_total then
                                assign v_val_sdo_ctbl = tt_valor_demonst_ctbl_total.ttv_val_coluna.
                        end /* if */.
                        else do:
                            for each btt_demonst_ctbl_fin no-lock
                                where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                              Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                 where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                then do:
                                    create tt_valor_demonst_ctbl_total.
                                    assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                           tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                end /* if */.
                                else do:
                                    find tt_valor_demonst_ctbl_total
                                         where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                    if avail tt_valor_demonst_ctbl_total then
                                       assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                end /* else */.
                            end.
                        end /* else */.
                    end /* if */.
                    if  v_val_sdo_ctbl <> ? then
                        assign v_val_sdo_idx = v_val_sdo_ctbl.
                    else 
                        assign v_val_sdo_idx = 0.

                    find btt_col_demonst_ctbl
                         where btt_col_demonst_ctbl.cod_col_demonst_ctbl = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 6, 2)) no-error.
                    if  avail btt_col_demonst_ctbl
                    then do:
                        assign v_val_sdo_ctbl = 0.
                        if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                        then do:
                            find tt_valor_demonst_ctbl_total
                                where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                            if  avail tt_valor_demonst_ctbl_total then
                                assign v_val_sdo_ctbl = tt_valor_demonst_ctbl_total.ttv_val_coluna.
                        end /* if */.
                        else do:
                            for each btt_demonst_ctbl_fin no-lock
                               where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                              Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                 where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                then do:
                                    create tt_valor_demonst_ctbl_total.
                                    assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                           tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                end /* if */.
                                else do:
                                    find tt_valor_demonst_ctbl_total
                                        where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                    if avail tt_valor_demonst_ctbl_total then
                                       assign tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                end /* if */.
                            end.
                        end /* else */.
                        if v_val_sdo_ctbl <> ? then
                            assign v_val_sdo_base = v_val_sdo_ctbl.
                        else
                            assign v_val_sdo_base = 0.
                    end /* if */.
                    if  v_val_sdo_idx  <> 0 
                    and v_val_sdo_base <> 0 then do:
                        assign v_val_sdo_ctbl = FnAjustDec(dec(v_val_sdo_idx / v_val_sdo_base * 100 - 100), v_cod_moed_finalid).
                        if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.
                    end.
                end /* if */.

                if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/ 
                then do:
                   /* calcula fΩrmula */
                   assign v_val_sdo_ctbl = 0.
                   for each tt_var_formul_1:
                       delete tt_var_formul_1.
                   end.
                   run pi_ident_var_formul_1 (Input tt_col_demonst_ctbl.des_formul_ctbl) .
                   for each tt_var_formul_1 no-lock:
                       /* lº o buffer da tt_col_demonst_ctbl para verificar buscar as colunas que fazem parte da formula que estam fora
                          da quantidade de colunas que sío mostradas em video.*/                   
                       find btt_col_demonst_ctbl
                            where btt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_var_formul_1.ttv_cod_var_formul no-error.
                       if  avail btt_col_demonst_ctbl
                       then do:
                           ASSIGN v_val_sdo_ctbl = 0.
                           if  tt_demonst_ctbl_fin.ttv_num_nivel = 0
                           then do:  
                               for each btt_demonst_ctbl_fin no-lock
                                  where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):

                                    run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                  Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                               end.
                               if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                               then do:
                                   create tt_valor_demonst_ctbl_total.
                                   assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                          tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                               end /* if */.
                               else do:
                                   find tt_valor_demonst_ctbl_total
                                       where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl no-error.
                                    if avail tt_valor_demonst_ctbl_total then
                                      assign tt_valor_demonst_ctbl_total.ttv_val_coluna = tt_valor_demonst_ctbl_total.ttv_val_coluna + v_val_sdo_ctbl.
                               end /* else */.
                           end /* if */.
                           else do:
                               for each btt_demonst_ctbl_fin no-lock
                                  where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin):
                                    run pi_busca_filhos_recursiv (Input recid(btt_demonst_ctbl_fin),
                                                                  Input btt_col_demonst_ctbl.cod_col_demonst_ctbl) /*pi_busca_filhos_recursiv*/.
                                    if  btt_demonst_ctbl_fin.ttv_log_tot_estrut
                                    then do:
                                        if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                                        where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl)
                                        then do:
                                            create tt_valor_demonst_ctbl_total.
                                            assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl
                                                   tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl.
                                        end /* if */.
                                        else do:
                                            find tt_valor_demonst_ctbl_total
                                                where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = btt_col_demonst_ctbl.cod_col_demonst_ctbl NO-ERROR.
                                            if avail tt_valor_demonst_ctbl_total then
                                               assign tt_valor_demonst_ctbl_total.ttv_val_coluna = tt_valor_demonst_ctbl_total.ttv_val_coluna + v_val_sdo_ctbl.
                                        end /* else */.
                                    end /* if */.
                               end.
                           end /* else */.
                           if v_val_sdo_ctbl <> ? then
                               assign tt_var_formul_1.ttv_val_var_formul_1 = v_val_sdo_ctbl.
                           else 
                               assign tt_var_formul_1.ttv_val_var_formul_1 = 0.
                       end /* if */.
                   end.
                   assign v_val_sdo_ctbl = 0.

                   run pi_calcul_formul_1 (input-output v_val_sdo_ctbl,
                                           input tt_col_demonst_ctbl.des_formul_ctbl,
                                           output v_log_return,
                                           Input yes) /* pi_calcul_formul_1*/.
                   if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.
                end /* if */.

                if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_Formula*/     OR
                    tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_Variacao*/ 
                then do:
                    if  not can-find(first tt_valor_demonst_ctbl_total no-lock
                                    where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl)
                    then do:
                        create tt_valor_demonst_ctbl_total.
                        assign tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                               tt_valor_demonst_ctbl_total.ttv_val_coluna = v_val_sdo_ctbl .
                    end /* if */.
                    else do:
                        find tt_valor_demonst_ctbl_total
                            where tt_valor_demonst_ctbl_total.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl no-error.
                        if avail tt_valor_demonst_ctbl_total then
                           assign tt_valor_demonst_ctbl_total.ttv_val_coluna =  v_val_sdo_ctbl .
                    end /* else */.
                    if v_val_sdo_ctbl <> 0 then
                        assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(dec(v_val_sdo_ctbl),tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
                    else 
                        assign tt_demonst_ctbl_video.ttv_cod_lin_demonst = setentryfield(v_num_column,tt_demonst_ctbl_video.ttv_cod_lin_demonst,chr(10), string(0,tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl)).
                end /* if */.
            end.

            find next tt_label_demonst_ctbl_video no-error.
            if not avail tt_label_demonst_ctbl_video then 
                leave.    
            find first tt_col_demonst_ctbl no-lock
                where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                  and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                no-error.

        end.

        /* End_Include: i_totaliza_colunas_aux */

    end.
END PROCEDURE. /* pi_cria_tt_impressao_demonst */
/*****************************************************************************
** Procedure Interna.....: pi_ident_var_formul_1
** Descricao.............: pi_ident_var_formul_1
** Criado por............: fut12209_2
** Criado em.............: 31/03/2005 17:15:57
** Alterado por..........: fut12209_2
** Alterado em...........: 01/04/2005 15:09:08
*****************************************************************************/
PROCEDURE pi_ident_var_formul_1:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_formul
        as character
        format "x(80)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign v_num_posicao = 0
           v_des_formul  = "".

    main_block:
    do on endkey undo main_block, leave main_block on error undo main_block, leave main_block.

       assign v_num_posicao = 1.

       block1:
       do

          while v_num_posicao <= length(p_des_formul):

            /* ** Se objeto Ç operador, n£mero ou branco pula objeto ***/
            if  index("+-*^/()",substring(p_des_formul,v_num_posicao,1)) = 0 and
                substring(p_des_formul, v_num_posicao, 1) <> " "
            then do:
                if  index("0123456789.",substring(p_des_formul,v_num_posicao,1)) <> 0
                then do:
                    if  v_log_save = yes
                    then do: /* n£mero faz parte da vari†vel */
                       assign v_des_formul = v_des_formul + substring(p_des_formul,v_num_posicao,1).
                    end /* if */.
                end /* if */.
                else do:
                    if  v_log_save = no
                    then do: /* ** Primeira letra da vari†vel ***/
                       assign v_log_save = yes.
                       assign v_des_formul = substring(p_des_formul,v_num_posicao,1).
                    end /* if */.
                    else do:
                       assign v_des_formul = v_des_formul + substring(p_des_formul,v_num_posicao,1).
                    end /* else */.
                end /* else */.
            end /* if */.
            else do:
                if  v_log_save
                then do:  /* ** v_des_formul possui vari†vel - gera temp table ***/
                   find tt_var_formul_1 no-lock
                        where tt_var_formul_1.ttv_cod_var_formul = v_des_formul  no-error.
                   if  not avail tt_var_formul_1
                   then do:
                      create tt_var_formul_1.
                      assign tt_var_formul_1.ttv_cod_var_formul = v_des_formul.
                   end /* if */.
                   assign v_log_save = no. /* ** esvazia v_des_formula ***/
                end /* if */.
            end /* else */.
            assign v_num_posicao = v_num_posicao + 1.
       end /* do block1 */.

       if  v_log_save
       then do: /* ** £ltima letra da vari†vel encontrada na f¢rmula - gera temp table ***/
           find tt_var_formul_1 no-lock
                where tt_var_formul_1.ttv_cod_var_formul = v_des_formul no-error.
           if  not avail tt_var_formul_1
           then do:
              create tt_var_formul_1.
              assign tt_var_formul_1.ttv_cod_var_formul = v_des_formul.
              assign v_log_save = no.
           end /* if */.
       end /* if */.

    end /* do main_block */.
END PROCEDURE. /* pi_ident_var_formul_1 */
/*****************************************************************************
** Procedure Interna.....: pi_sec_to_formatted_time
** Descricao.............: pi_sec_to_formatted_time
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 01/02/1995 10:47:54
*****************************************************************************/
PROCEDURE pi_sec_to_formatted_time:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_seconds
        as integer
        format ">>>,>>9"
        no-undo.
    def output param p_hra_formatted_time
        as Character
        format "99:99:99"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_hra_formatted_time = replace(string(p_num_seconds,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").

END PROCEDURE. /* pi_sec_to_formatted_time */
/*****************************************************************************
** Procedure Interna.....: pi_vld_api_demons_ctbl_video
** Descricao.............: pi_vld_api_demons_ctbl_video
** Criado por............: fut12139
** Criado em.............: 28/03/2005 13:28:46
** Alterado por..........: fut35118
** Alterado em...........: 06/12/2006 15:30:01
*****************************************************************************/
PROCEDURE pi_vld_api_demons_ctbl_video:

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    /* --- Demonstrativo Contabil ---*/
    find demonst_ctbl no-lock
       where demonst_ctbl.cod_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl no-error.
    if  not available demonst_ctbl
    then do:

        /* Begin_Include: i_grava_erro_api_demonst */
        IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
           FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

        if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                   WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                     AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                     AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1284 )
        then do:

            CREATE tt_erros_api_demonst_lote.
            ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                   tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                   tt_erros_api_demonst_lote.ttv_num_erro                  = 1284
                   v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "Demonstrativo Cont†bil","Demonstrativos Cont†beis","","") + "~~~~~~~~~~~~~~~~".

            run pi_messages (input "msg",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                       ENTRY(2,v_des_param,"~~"),
                                                                                                                       ENTRY(3,v_des_param,"~~"),
                                                                                                                       ENTRY(4,v_des_param,"~~"),
                                                                                                                       ENTRY(5,v_des_param,"~~"),
                                                                                                                       ENTRY(6,v_des_param,"~~"),
                                                                                                                       ENTRY(7,v_des_param,"~~"),
                                                                                                                       ENTRY(8,v_des_param,"~~"),
                                                                                                                       ENTRY(9,v_des_param,"~~")).
            run pi_messages (input "help",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                         ENTRY(2,v_des_param,"~~"),
                                                                                                                         ENTRY(3,v_des_param,"~~"),
                                                                                                                         ENTRY(4,v_des_param,"~~"),
                                                                                                                         ENTRY(5,v_des_param,"~~"),
                                                                                                                         ENTRY(6,v_des_param,"~~"),
                                                                                                                         ENTRY(7,v_des_param,"~~"),
                                                                                                                         ENTRY(8,v_des_param,"~~"),
                                                                                                                         ENTRY(9,v_des_param,"~~")).
        END.

        /* End_Include: i_grava_erro_api_demonst */

    end.

    /* --- Valida Seguranáa Demonstrativo --- */
    run pi_verifica_segur_demonst_ctbl (Input tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl,
                                        output v_log_return) /*pi_verifica_segur_demonst_ctbl*/.
    if  v_log_return = no
    then do:

        /* Begin_Include: i_grava_erro_api_demonst */
        IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
           FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

        if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                   WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                     AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                     AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1196 )
        then do:

            CREATE tt_erros_api_demonst_lote.
            ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                   tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                   tt_erros_api_demonst_lote.ttv_num_erro                  = 1196
                   v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "","","","") + "~~~~~~~~~~~~~~~~".

            run pi_messages (input "msg",
                             input 1196,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1196*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                       ENTRY(2,v_des_param,"~~"),
                                                                                                                       ENTRY(3,v_des_param,"~~"),
                                                                                                                       ENTRY(4,v_des_param,"~~"),
                                                                                                                       ENTRY(5,v_des_param,"~~"),
                                                                                                                       ENTRY(6,v_des_param,"~~"),
                                                                                                                       ENTRY(7,v_des_param,"~~"),
                                                                                                                       ENTRY(8,v_des_param,"~~"),
                                                                                                                       ENTRY(9,v_des_param,"~~")).
            run pi_messages (input "help",
                             input 1196,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1196*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                         ENTRY(2,v_des_param,"~~"),
                                                                                                                         ENTRY(3,v_des_param,"~~"),
                                                                                                                         ENTRY(4,v_des_param,"~~"),
                                                                                                                         ENTRY(5,v_des_param,"~~"),
                                                                                                                         ENTRY(6,v_des_param,"~~"),
                                                                                                                         ENTRY(7,v_des_param,"~~"),
                                                                                                                         ENTRY(8,v_des_param,"~~"),
                                                                                                                         ENTRY(9,v_des_param,"~~")).
        END.

        /* End_Include: i_grava_erro_api_demonst */

    END.

    /* --- Padrao de Colunas do Demonstrativo Contabil ---*/
    find padr_col_demonst_ctbl no-lock
       where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl no-error.
    if  not available padr_col_demonst_ctbl
    then do:

        /* Begin_Include: i_grava_erro_api_demonst */
        IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
           FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

        if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                   WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                     AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                     AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1284 )
        then do:

            CREATE tt_erros_api_demonst_lote.
            ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                   tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                   tt_erros_api_demonst_lote.ttv_num_erro                  = 1284
                   v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "Padr∆o Colunas Demonstrativo","Padr‰es Colunas Demonstrativo","","") + "~~~~~~~~~~~~~~~~".

            run pi_messages (input "msg",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                       ENTRY(2,v_des_param,"~~"),
                                                                                                                       ENTRY(3,v_des_param,"~~"),
                                                                                                                       ENTRY(4,v_des_param,"~~"),
                                                                                                                       ENTRY(5,v_des_param,"~~"),
                                                                                                                       ENTRY(6,v_des_param,"~~"),
                                                                                                                       ENTRY(7,v_des_param,"~~"),
                                                                                                                       ENTRY(8,v_des_param,"~~"),
                                                                                                                       ENTRY(9,v_des_param,"~~")).
            run pi_messages (input "help",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                         ENTRY(2,v_des_param,"~~"),
                                                                                                                         ENTRY(3,v_des_param,"~~"),
                                                                                                                         ENTRY(4,v_des_param,"~~"),
                                                                                                                         ENTRY(5,v_des_param,"~~"),
                                                                                                                         ENTRY(6,v_des_param,"~~"),
                                                                                                                         ENTRY(7,v_des_param,"~~"),
                                                                                                                         ENTRY(8,v_des_param,"~~"),
                                                                                                                         ENTRY(9,v_des_param,"~~")).
        END.

        /* End_Include: i_grava_erro_api_demonst */

    end.

    ASSIGN v_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
           v_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl.

    /* --- Valida valor informado para o Fator Divis∆o --- */
    if  tt_prefer_demonst_ctbl_1.tta_val_fator_div_demonst_ctbl = 0
    then do:

        /* Begin_Include: i_grava_erro_api_demonst */
        IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
           FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

        if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                   WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                     AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                     AND tt_erros_api_demonst_lote.ttv_num_erro                  = 11688 )
        then do:

            CREATE tt_erros_api_demonst_lote.
            ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                   tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                   tt_erros_api_demonst_lote.ttv_num_erro                  = 11688
                   v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "","","","") + "~~~~~~~~~~~~~~~~".

            run pi_messages (input "msg",
                             input 11688,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_11688*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                       ENTRY(2,v_des_param,"~~"),
                                                                                                                       ENTRY(3,v_des_param,"~~"),
                                                                                                                       ENTRY(4,v_des_param,"~~"),
                                                                                                                       ENTRY(5,v_des_param,"~~"),
                                                                                                                       ENTRY(6,v_des_param,"~~"),
                                                                                                                       ENTRY(7,v_des_param,"~~"),
                                                                                                                       ENTRY(8,v_des_param,"~~"),
                                                                                                                       ENTRY(9,v_des_param,"~~")).
            run pi_messages (input "help",
                             input 11688,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_11688*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                         ENTRY(2,v_des_param,"~~"),
                                                                                                                         ENTRY(3,v_des_param,"~~"),
                                                                                                                         ENTRY(4,v_des_param,"~~"),
                                                                                                                         ENTRY(5,v_des_param,"~~"),
                                                                                                                         ENTRY(6,v_des_param,"~~"),
                                                                                                                         ENTRY(7,v_des_param,"~~"),
                                                                                                                         ENTRY(8,v_des_param,"~~"),
                                                                                                                         ENTRY(9,v_des_param,"~~")).
        END.

        /* End_Include: i_grava_erro_api_demonst */

    END.

    /* --- Idioma ---*/
    find first idioma no-lock
         where idioma.cod_idioma = tt_prefer_demonst_ctbl_1.tta_cod_idioma no-error.
    if  not avail idioma
    then do:

        /* Begin_Include: i_grava_erro_api_demonst */
        IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
           FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

        if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                   WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                     AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                     AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1284 )
        then do:

            CREATE tt_erros_api_demonst_lote.
            ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                   tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                   tt_erros_api_demonst_lote.ttv_num_erro                  = 1284
                   v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "Idioma", "Idiomas","","") + "~~~~~~~~~~~~~~~~".

            run pi_messages (input "msg",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                       ENTRY(2,v_des_param,"~~"),
                                                                                                                       ENTRY(3,v_des_param,"~~"),
                                                                                                                       ENTRY(4,v_des_param,"~~"),
                                                                                                                       ENTRY(5,v_des_param,"~~"),
                                                                                                                       ENTRY(6,v_des_param,"~~"),
                                                                                                                       ENTRY(7,v_des_param,"~~"),
                                                                                                                       ENTRY(8,v_des_param,"~~"),
                                                                                                                       ENTRY(9,v_des_param,"~~")).
            run pi_messages (input "help",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
            assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1284*/.
            ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                         ENTRY(2,v_des_param,"~~"),
                                                                                                                         ENTRY(3,v_des_param,"~~"),
                                                                                                                         ENTRY(4,v_des_param,"~~"),
                                                                                                                         ENTRY(5,v_des_param,"~~"),
                                                                                                                         ENTRY(6,v_des_param,"~~"),
                                                                                                                         ENTRY(7,v_des_param,"~~"),
                                                                                                                         ENTRY(8,v_des_param,"~~"),
                                                                                                                         ENTRY(9,v_des_param,"~~")).
        END.

        /* End_Include: i_grava_erro_api_demonst */

    END.

    /* --- Conjunto de Preferàncias ---*/
    FOR EACH tt_conjto_prefer_demonst NO-LOCK
       WHERE tt_conjto_prefer_demonst.tta_cod_usuario               = tt_prefer_demonst_ctbl_1.tta_cod_usuario
         AND tt_conjto_prefer_demonst.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
         AND tt_conjto_prefer_demonst.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl:

        /* --- Valida Finalidade --- */
        if  tt_conjto_prefer_demonst.tta_cod_finalid_econ = ""
        then do:

            /* Begin_Include: i_grava_erro_api_demonst */
            IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
               FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

            if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                       WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                         AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                         AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1190 )
            then do:

                CREATE tt_erros_api_demonst_lote.
                ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                       tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                       tt_erros_api_demonst_lote.ttv_num_erro                  = 1190
                       v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "","","","") + "~~~~~~~~~~~~~~~~".

                run pi_messages (input "msg",
                                 input 1190,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1190*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                           ENTRY(2,v_des_param,"~~"),
                                                                                                                           ENTRY(3,v_des_param,"~~"),
                                                                                                                           ENTRY(4,v_des_param,"~~"),
                                                                                                                           ENTRY(5,v_des_param,"~~"),
                                                                                                                           ENTRY(6,v_des_param,"~~"),
                                                                                                                           ENTRY(7,v_des_param,"~~"),
                                                                                                                           ENTRY(8,v_des_param,"~~"),
                                                                                                                           ENTRY(9,v_des_param,"~~")).
                run pi_messages (input "help",
                                 input 1190,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1190*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                             ENTRY(2,v_des_param,"~~"),
                                                                                                                             ENTRY(3,v_des_param,"~~"),
                                                                                                                             ENTRY(4,v_des_param,"~~"),
                                                                                                                             ENTRY(5,v_des_param,"~~"),
                                                                                                                             ENTRY(6,v_des_param,"~~"),
                                                                                                                             ENTRY(7,v_des_param,"~~"),
                                                                                                                             ENTRY(8,v_des_param,"~~"),
                                                                                                                             ENTRY(9,v_des_param,"~~")).
            END.

            /* End_Include: i_grava_erro_api_demonst */

        end.

        /* --- Valida Cen†rio --- */
        if  tt_conjto_prefer_demonst.tta_cod_cenar_ctbl = ""
        then do:

            /* Begin_Include: i_grava_erro_api_demonst */
            IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
               FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

            if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                       WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                         AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                         AND tt_erros_api_demonst_lote.ttv_num_erro                  = 694 )
            then do:

                CREATE tt_erros_api_demonst_lote.
                ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                       tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                       tt_erros_api_demonst_lote.ttv_num_erro                  = 694
                       v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "","","","") + "~~~~~~~~~~~~~~~~".

                run pi_messages (input "msg",
                                 input 694,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_694*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                           ENTRY(2,v_des_param,"~~"),
                                                                                                                           ENTRY(3,v_des_param,"~~"),
                                                                                                                           ENTRY(4,v_des_param,"~~"),
                                                                                                                           ENTRY(5,v_des_param,"~~"),
                                                                                                                           ENTRY(6,v_des_param,"~~"),
                                                                                                                           ENTRY(7,v_des_param,"~~"),
                                                                                                                           ENTRY(8,v_des_param,"~~"),
                                                                                                                           ENTRY(9,v_des_param,"~~")).
                run pi_messages (input "help",
                                 input 694,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_694*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                             ENTRY(2,v_des_param,"~~"),
                                                                                                                             ENTRY(3,v_des_param,"~~"),
                                                                                                                             ENTRY(4,v_des_param,"~~"),
                                                                                                                             ENTRY(5,v_des_param,"~~"),
                                                                                                                             ENTRY(6,v_des_param,"~~"),
                                                                                                                             ENTRY(7,v_des_param,"~~"),
                                                                                                                             ENTRY(8,v_des_param,"~~"),
                                                                                                                             ENTRY(9,v_des_param,"~~")).
            END.

            /* End_Include: i_grava_erro_api_demonst */

        end.

        /* --- Exerc°cio Ctbl ---*/
        find first exerc_ctbl no-lock
           where exerc_ctbl.cod_exerc_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_exerc_ctbl
             and exerc_ctbl.cod_cenar_ctbl = tt_conjto_prefer_demonst.tta_cod_cenar_ctbl no-error.
        if  not avail exerc_ctbl
        then do:

            /* Begin_Include: i_grava_erro_api_demonst */
            IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
               FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

            if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                       WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                         AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                         AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1284 )
            then do:

                CREATE tt_erros_api_demonst_lote.
                ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                       tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                       tt_erros_api_demonst_lote.ttv_num_erro                  = 1284
                       v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", "Exerc°cio Cont†bil", "Exerc°cios Cont†beis","","") + "~~~~~~~~~~~~~~~~".

                run pi_messages (input "msg",
                                 input 1284,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1284*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                           ENTRY(2,v_des_param,"~~"),
                                                                                                                           ENTRY(3,v_des_param,"~~"),
                                                                                                                           ENTRY(4,v_des_param,"~~"),
                                                                                                                           ENTRY(5,v_des_param,"~~"),
                                                                                                                           ENTRY(6,v_des_param,"~~"),
                                                                                                                           ENTRY(7,v_des_param,"~~"),
                                                                                                                           ENTRY(8,v_des_param,"~~"),
                                                                                                                           ENTRY(9,v_des_param,"~~")).
                run pi_messages (input "help",
                                 input 1284,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1284*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                             ENTRY(2,v_des_param,"~~"),
                                                                                                                             ENTRY(3,v_des_param,"~~"),
                                                                                                                             ENTRY(4,v_des_param,"~~"),
                                                                                                                             ENTRY(5,v_des_param,"~~"),
                                                                                                                             ENTRY(6,v_des_param,"~~"),
                                                                                                                             ENTRY(7,v_des_param,"~~"),
                                                                                                                             ENTRY(8,v_des_param,"~~"),
                                                                                                                             ENTRY(9,v_des_param,"~~")).
            END.

            /* End_Include: i_grava_erro_api_demonst */

        end.

        /* --- Per°odo Ctbl ---*/    
        find first period_ctbl no-lock
           where period_ctbl.cod_exerc_ctbl  = tt_prefer_demonst_ctbl_1.tta_cod_exerc_ctbl
             and period_ctbl.num_period_ctbl = tt_prefer_demonst_ctbl_1.tta_num_period_ctbl
             and period_ctbl.cod_cenar_ctbl  = tt_conjto_prefer_demonst.tta_cod_cenar_ctbl no-error.
        if  not avail period_ctbl
        then do:

            /* Begin_Include: i_grava_erro_api_demonst */
            IF NOT AVAIL tt_prefer_demonst_ctbl_1 THEN
               FIND FIRST tt_prefer_demonst_ctbl_1 NO-ERROR.

            if  NOT CAN-FIND(tt_erros_api_demonst_lote NO-LOCK
                       WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                         AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                         AND tt_erros_api_demonst_lote.ttv_num_erro                  = 1051 )
            then do:

                CREATE tt_erros_api_demonst_lote.
                ASSIGN tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                       tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl
                       tt_erros_api_demonst_lote.ttv_num_erro                  = 1051
                       v_des_param = substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", tt_prefer_demonst_ctbl_1.tta_num_period_ctbl,tt_prefer_demonst_ctbl_1.tta_cod_exerc_ctbl,"","") + "~~~~~~~~~~~~~~~~".

                run pi_messages (input "msg",
                                 input 1051,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_erro = return-value /*msg_1051*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_erro = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_erro, ENTRY(1,v_des_param,"~~"),
                                                                                                                           ENTRY(2,v_des_param,"~~"),
                                                                                                                           ENTRY(3,v_des_param,"~~"),
                                                                                                                           ENTRY(4,v_des_param,"~~"),
                                                                                                                           ENTRY(5,v_des_param,"~~"),
                                                                                                                           ENTRY(6,v_des_param,"~~"),
                                                                                                                           ENTRY(7,v_des_param,"~~"),
                                                                                                                           ENTRY(8,v_des_param,"~~"),
                                                                                                                           ENTRY(9,v_des_param,"~~")).
                run pi_messages (input "help",
                                 input 1051,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_erros_api_demonst_lote.ttv_des_msg_ajuda = return-value /*msg_1051*/.
                ASSIGN tt_erros_api_demonst_lote.ttv_des_msg_ajuda = SUBSTITUTE(tt_erros_api_demonst_lote.ttv_des_msg_ajuda, ENTRY(1,v_des_param,"~~"),
                                                                                                                             ENTRY(2,v_des_param,"~~"),
                                                                                                                             ENTRY(3,v_des_param,"~~"),
                                                                                                                             ENTRY(4,v_des_param,"~~"),
                                                                                                                             ENTRY(5,v_des_param,"~~"),
                                                                                                                             ENTRY(6,v_des_param,"~~"),
                                                                                                                             ENTRY(7,v_des_param,"~~"),
                                                                                                                             ENTRY(8,v_des_param,"~~"),
                                                                                                                             ENTRY(9,v_des_param,"~~")).
            END.

            /* End_Include: i_grava_erro_api_demonst */

        end.
        else
            assign v_dat_inic_period_ctbl = period_ctbl.dat_inic_period_ctbl
                   v_dat_fim_period_ctbl  = period_ctbl.dat_fim_period_ctbl.
    END.

    /* --- Efetua todas as validaá‰es para retornar como ERRO ---*/
    IF CAN-FIND(FIRST tt_erros_api_demonst_lote NO-LOCK
               WHERE tt_erros_api_demonst_lote.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
                 AND tt_erros_api_demonst_lote.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl)
    THEN return "NOK" /*l_nok*/ .

    RETURN "OK" /*l_ok*/ .
END PROCEDURE. /* pi_vld_api_demons_ctbl_video */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_demonst_ctbl
** Descricao.............: pi_verifica_segur_demonst_ctbl
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: lucas
** Alterado em...........: 16/12/1999 17:11:53
*****************************************************************************/
PROCEDURE pi_verifica_segur_demonst_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_demonst_ctbl
        as character
        format "x(8)"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */
    if can-find(first segur_demonst_ctbl no-lock
        where segur_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl
          and segur_demonst_ctbl.cod_grp_usuar = "*")
    then
        assign p_log_return = yes.
    else do:
        loop_block:
        for each usuar_grp_usuar no-lock
            where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:

            find first segur_demonst_ctbl no-lock
                where segur_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl
                  and segur_demonst_ctbl.cod_grp_usuar    = usuar_grp_usuar.cod_grp_usuar no-error.
            if avail segur_demonst_ctbl then do:
                assign p_log_return = yes.
                leave loop_block.
            end.
        end.
    end.        
END PROCEDURE. /* pi_verifica_segur_demonst_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_main_api_demonst_ctbl_fin_sped
** Descricao.............: pi_main_api_demonst_ctbl_fin_sped
** Criado por............: fut38629
** Criado em.............: 20/02/2009 16:23:56
** Alterado por..........: fut38629
** Alterado em...........: 02/04/2009 17:28:18
*****************************************************************************/
PROCEDURE pi_main_api_demonst_ctbl_fin_sped:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_vers_integr_api
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param table 
        for tt_prefer_demonst_ctbl_1.
    def Input param table 
        for tt_conjto_prefer_demonst.
    def output param table 
        for tt_retorno_demonst.
    def output param table 
        for tt_retorno_demonst_lin_1.
    def output param table 
        for tt_erros_api_demonst_lote.


    /************************* Parameter Definition End *************************/

    ASSIGN v_log_funcao_concil_consolid = &IF DEFINED (BF_FIN_CONCIL_CONSOLID) &THEN YES 
                                          &ELSE GetDefinedFunction('SPP_CONCIL_CONSOLID':U) &ENDIF
           v_log_funcao_dw_demonst = GetDefinedFunction('SPP_DWF_DEMONST':U).


    /* Begin_Include: i_log_exec_prog_dtsul_ini */
    assign v_rec_log = ?.

    if can-find(prog_dtsul
           where prog_dtsul.cod_prog_dtsul = 'api_demonst_ctbl_fin_sped' 
             and prog_dtsul.log_gera_log_exec = yes) then do transaction:
        create log_exec_prog_dtsul.
        assign log_exec_prog_dtsul.cod_prog_dtsul           = 'api_demonst_ctbl_fin_sped'
               log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
               log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
        assign v_rec_log = recid(log_exec_prog_dtsul).
        release log_exec_prog_dtsul no-error.
    end.


    /* End_Include: i_log_exec_prog_dtsul_ini */


    /* ***[ Dados do Demonstrativo ]****/
    FOR EACH tt_prefer_demonst_ctbl_1:
        assign v_log_acum_cta_ctbl_sint = tt_prefer_demonst_ctbl_1.tta_log_acum_cta_ctbl_sint.
        /* ***[ PI Valida Dados Entrada ]****/
        run pi_vld_api_demons_ctbl_video /*pi_vld_api_demons_ctbl_video*/.
        IF RETURN-VALUE = "NOK" /*l_nok*/  THEN
            NEXT.

        /* ***[ Posiciona usu†rio corrente cfme definido pelo usuario, para uso na API Demo/ Inicializa seq demonst ]****/
        ASSIGN v_cod_usuar_2      = v_cod_usuar_corren
               v_cod_usuar_corren = tt_prefer_demonst_ctbl_1.tta_cod_usuario
               v_num_seq_demonst_ctbl = v_num_seq_demonst_ctbl + 1
               v_log_col_atualiz = NO.

        /* ***[ Posiciona na ultima preferencia do usuario ]****/
        FOR EACH b_prefer_demonst_ctbl NO-LOCK
             WHERE b_prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
               AND b_prefer_demonst_ctbl.cod_demonst_ctbl          = v_cod_demonst_ctbl
               AND b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
             BREAK BY b_prefer_demonst_ctbl.dat_ult_atualiz
                   BY b_prefer_demonst_ctbl.hra_ult_atualiz:

            IF  LAST-OF(b_prefer_demonst_ctbl.dat_ult_atualiz)
            AND LAST-OF(b_prefer_demonst_ctbl.hra_ult_atualiz) THEN
                FIND FIRST prefer_demonst_ctbl exclusive-lock
                    WHERE prefer_demonst_ctbl.cod_usuario = b_prefer_demonst_ctbl.cod_usuario
                      AND prefer_demonst_ctbl.cod_demonst_ctbl = b_prefer_demonst_ctbl.cod_demonst_ctbl
                      AND prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                NO-ERROR.
        END.

        if  NOT AVAIL prefer_demonst_ctbl
        then do:
            CREATE prefer_demonst_ctbl.
            ASSIGN prefer_demonst_ctbl.cod_usuario                = v_cod_usuar_corren
                   prefer_demonst_ctbl.cod_demonst_ctbl           = v_cod_demonst_ctbl
                   prefer_demonst_ctbl.cod_padr_col_demonst_ctbl  = v_cod_padr_col_demonst_ctbl.

            &if '{&emsfin_dbtype}' <> 'progress' &then 
                VALIDATE prefer_demonst_ctbl.
            &endif
        END.

        /* ***[ Atualiza ultima posiá∆o da preferencia ]****/
        assign prefer_demonst_ctbl.dat_ult_atualiz = today.
        run pi_sec_to_formatted_time (Input time,
                                      output prefer_demonst_ctbl.hra_ult_atualiz) /*pi_sec_to_formatted_time*/.

        /* ***[ Atualiza demais campos da preferencia ]****/
        &if '{&emsfin_version}' >= '5.05' &then
        assign prefer_demonst_ctbl.cod_exerc_ctbl             = tt_prefer_demonst_ctbl_1.tta_cod_exerc_ctbl
               prefer_demonst_ctbl.cod_idioma                 = tt_prefer_demonst_ctbl_1.tta_cod_idioma
               prefer_demonst_ctbl.num_period_ctbl            = tt_prefer_demonst_ctbl_1.tta_num_period_ctbl
               prefer_demonst_ctbl.val_fator_div_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_val_fator_div_demonst_ctbl
               prefer_demonst_ctbl.log_consid_apurac_restdo   = tt_prefer_demonst_ctbl_1.tta_log_consid_apurac_restdo
               prefer_demonst_ctbl.log_acum_cta_ctbl_sint     = tt_prefer_demonst_ctbl_1.tta_log_acum_cta_ctbl_sint
               prefer_demonst_ctbl.log_impr_cta_sem_sdo       = tt_prefer_demonst_ctbl_1.tta_log_impr_cta_sem_sdo
               prefer_demonst_ctbl.cod_demonst_ctbl           = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
               prefer_demonst_ctbl.cod_padr_col_demonst_ctbl  = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl .
        &endif
        &if '{&emsfin_version}' >= '5.06' &then
            assign prefer_demonst_ctbl.log_impr_acum_zero = tt_prefer_demonst_ctbl_1.ttv_log_impr_acum_zero.
        &else
            assign prefer_demonst_ctbl.log_livre_1        = tt_prefer_demonst_ctbl_1.ttv_log_impr_acum_zero.
        &endif
        &if '{&emsfin_version}' >= '5.07' &then
            assign prefer_demonst_ctbl.log_impr_col_sem_sdo = tt_prefer_demonst_ctbl_1.ttv_log_impr_col_sem_sdo.
        &else
            assign prefer_demonst_ctbl.cod_livre_1          = SetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10), string(tt_prefer_demonst_ctbl_1.ttv_log_impr_col_sem_sdo)).
        &endif

        /* ***[ Conjunto de Preferàncias ]****/
        FOR EACH tt_conjto_prefer_demonst NO-LOCK
           WHERE tt_conjto_prefer_demonst.tta_cod_usuario               = tt_prefer_demonst_ctbl_1.tta_cod_usuario
             AND tt_conjto_prefer_demonst.tta_cod_demonst_ctbl          = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl
             AND tt_conjto_prefer_demonst.tta_cod_padr_col_demonst_ctbl = tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl:

            /* ***[ Cria o Conjunto de Preferencias, caso inexista ]****/
            FIND conjto_prefer_demonst EXCLUSIVE-LOCK
                 WHERE conjto_prefer_demonst.cod_usuario               = tt_conjto_prefer_demonst.tta_cod_usuario
                   AND conjto_prefer_demonst.cod_demonst_ctbl          = tt_conjto_prefer_demonst.tta_cod_demonst_ctbl
                   AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = tt_conjto_prefer_demonst.tta_cod_padr_col_demonst_ctbl
                   AND conjto_prefer_demonst.num_conjto_param_ctbl     = tt_conjto_prefer_demonst.tta_num_conjto_param_ctbl NO-ERROR.
            if  NOT AVAIL conjto_prefer_demonst
            then do:
                CREATE conjto_prefer_demonst.
                ASSIGN conjto_prefer_demonst.cod_usuario               = tt_conjto_prefer_demonst.tta_cod_usuario
                       conjto_prefer_demonst.cod_demonst_ctbl          = tt_conjto_prefer_demonst.tta_cod_demonst_ctbl
                       conjto_prefer_demonst.cod_padr_col_demonst_ctbl = tt_conjto_prefer_demonst.tta_cod_padr_col_demonst_ctbl
                       conjto_prefer_demonst.num_conjto_param_ctbl     = tt_conjto_prefer_demonst.tta_num_conjto_param_ctbl.
            END.
            ASSIGN conjto_prefer_demonst.cod_cenar_ctbl             = tt_conjto_prefer_demonst.tta_cod_cenar_ctbl
                   conjto_prefer_demonst.cod_finalid_econ           = tt_conjto_prefer_demonst.tta_cod_finalid_econ
                   conjto_prefer_demonst.cod_finalid_econ_apres     = tt_conjto_prefer_demonst.tta_cod_finalid_econ_apres
                   conjto_prefer_demonst.dat_cotac_indic_econ       = tt_conjto_prefer_demonst.tta_dat_cotac_indic_econ
                   conjto_prefer_demonst.cod_unid_organ_inic        = tt_conjto_prefer_demonst.tta_cod_unid_organ_inic
                   conjto_prefer_demonst.cod_unid_organ_fim         = tt_conjto_prefer_demonst.tta_cod_unid_organ_fim
                   conjto_prefer_demonst.cod_estab_inic             = tt_conjto_prefer_demonst.tta_cod_estab_inic
                   conjto_prefer_demonst.cod_estab_fim              = tt_conjto_prefer_demonst.tta_cod_estab_fim
                   conjto_prefer_demonst.cod_unid_negoc_inic        = tt_conjto_prefer_demonst.tta_cod_unid_negoc_inic
                   conjto_prefer_demonst.cod_unid_negoc_fim         = tt_conjto_prefer_demonst.tta_cod_unid_negoc_fim
                   conjto_prefer_demonst.cod_cenar_orctario         = tt_conjto_prefer_demonst.tta_cod_cenar_orctario
                   conjto_prefer_demonst.cod_vers_orcto_ctbl        = tt_conjto_prefer_demonst.tta_cod_vers_orcto_ctbl
                   conjto_prefer_demonst.val_cotac_indic_econ       = tt_conjto_prefer_demonst.tta_val_cotac_indic_econ
                   conjto_prefer_demonst.cod_cta_ctbl_inic          = tt_conjto_prefer_demonst.tta_cod_cta_ctbl_inic
                   conjto_prefer_demonst.cod_cta_ctbl_fim           = tt_conjto_prefer_demonst.tta_cod_cta_ctbl_fim
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa  = tt_conjto_prefer_demonst.tta_cod_cta_ctbl_prefer_pfixa
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_excec  = tt_conjto_prefer_demonst.tta_cod_cta_ctbl_prefer_excec
                   conjto_prefer_demonst.cod_unid_organ_prefer_inic = tt_conjto_prefer_demonst.tta_cod_unid_organ_prefer_inic
                   conjto_prefer_demonst.cod_unid_organ_prefer_fim  = tt_conjto_prefer_demonst.tta_cod_unid_organ_prefer_fim
               &if '{&emsfin_version}' > '5.05' &then
                   conjto_prefer_demonst.cod_unid_orctaria          = tt_conjto_prefer_demonst.tta_cod_unid_orctaria
                   conjto_prefer_demonst.num_seq_orcto_ctbl         = tt_conjto_prefer_demonst.tta_num_seq_orcto_ctbl
                   conjto_prefer_demonst.cod_ccusto_inic            = tt_conjto_prefer_demonst.tta_cod_ccusto_inic
                   conjto_prefer_demonst.cod_ccusto_fim             = tt_conjto_prefer_demonst.tta_cod_ccusto_fim
                   conjto_prefer_demonst.cod_ccusto_pfixa           = tt_conjto_prefer_demonst.tta_cod_ccusto_pfixa
                   conjto_prefer_demonst.cod_ccusto_excec           = tt_conjto_prefer_demonst.tta_cod_ccusto_excec
                   conjto_prefer_demonst.cod_proj_financ_inicial    = tt_conjto_prefer_demonst.tta_cod_proj_financ_inicial
                   conjto_prefer_demonst.cod_proj_financ_fim        = tt_conjto_prefer_demonst.tta_cod_proj_financ_fim
                   conjto_prefer_demonst.cod_proj_financ_pfixa      = tt_conjto_prefer_demonst.tta_cod_proj_financ_pfixa
                   conjto_prefer_demonst.cod_proj_financ_excec      = tt_conjto_prefer_demonst.tta_cod_proj_financ_excec
               &else 
                   conjto_prefer_demonst.cod_livre_1                = tt_conjto_prefer_demonst.tta_cod_unid_orctaria          + chr(10) +
                                                                      STRING(tt_conjto_prefer_demonst.tta_num_seq_orcto_ctbl) + chr(10) +
                                                                      "" /*l_null*/  + chr(10) + "" /*l_null*/ 
               &endif
                   .

            /* ***[ Salvar dados referentes a CCusto e Projeto ]****/
            &if '{&emsfin_version}' <= '5.05' &then
               find tab_livre_emsfin exclusive-lock
                    where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                      and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                      and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                      and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
               if  not avail tab_livre_emsfin
               then do:
                  create tab_livre_emsfin.
                  assign tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                         tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                         tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                         tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl).
               end.
               assign tab_livre_emsfin.cod_livre_1 = tt_conjto_prefer_demonst.tta_cod_proj_financ_inicial + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_proj_financ_fim     + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_proj_financ_pfixa   + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_proj_financ_excec
                      tab_livre_emsfin.cod_livre_2 = tt_conjto_prefer_demonst.tta_cod_ccusto_inic       + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_ccusto_fim        + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_proj_financ_pfixa + chr(10) +
                                                     tt_conjto_prefer_demonst.tta_cod_proj_financ_excec + chr(10) +
                                                     "" /*l_null*/ .
            &endif
        END.


        /* ***[ Define Ordem de Apresentaá∆o das Colunas ]****/
        FOR EACH col_demonst_ctbl NO-LOCK
           WHERE col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
           BY col_demonst_ctbl.num_soma_ascii_cod_col:

           IF col_demonst_ctbl.ind_funcao_col_demonst_ctbl = "Base C†lculo" /*l_base_calculo*/   THEN
               NEXT.

           CREATE tt_ord_col.
           ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                  tt_ord_col.ttv_cod_col_demonst_ctbl = col_demonst_ctbl.cod_col_demonst_ctbl
                  tt_ord_col.ttv_des_tit_ctbl         = col_demonst_ctbl.des_tit_ctbl
                  v_num_seq_6 = v_num_seq_6 + 10.

           &if '{&emsfin_version}' <= '5.05' &then
            /* * Verifica se TAB_livre est† desatualizada **/
            IF NOT CAN-FIND(FIRST tab_livre_emsfin NO-LOCK
               WHERE TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
               AND   TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
               AND   TAB_livre_emsfin.cod_compon_1_idx_tab = prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + 
                                                             prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
               AND   TAB_livre_emsfin.cod_livre_1          = col_demonst_ctbl.des_tit_ctbl
               AND   tab_livre_emsfin.cod_livre_2          = col_demonst_ctbl.cod_col_demonst_ctbl)
               THEN ASSIGN v_log_col_atualiz = YES.
           &else
            /* * Verifica se tabela est† desatualizada **/
            IF  NOT CAN-FIND(FIRST col_prefer_demonst_ctbl NO-LOCK
                WHERE col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                AND   col_prefer_demonst_ctbl.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
                AND   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                AND   col_prefer_demonst_ctbl.des_tit_ctbl              = col_demonst_ctbl.des_tit_ctbl
                AND   col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = col_demonst_ctbl.cod_col_demonst_ctbl) THEN
                ASSIGN v_log_col_atualiz = YES.
           &endif
        END.

        if  v_log_col_atualiz
        then do:
         &if '{&emsfin_version}' <= '5.05' &then
             for each   TAB_livre_emsfin exclusive-lock
                 where  TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                 and    TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                 and    TAB_livre_emsfin.cod_compon_1_idx_tab = (prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl):
                 delete tab_livre_emsfin.
             end.

             FOR each tt_ord_col:
                 CREATE TAB_livre_emsfin.
                 ASSIGN TAB_livre_emsfin.cod_modul_dtsul       = "MGL" /*l_mgl*/ 
                        TAB_livre_emsfin.cod_tab_dic_dtsul     = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                        TAB_livre_emsfin.cod_compon_1_idx_tab  = prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                        TAB_livre_emsfin.cod_compon_2_idx_tab  = STRING(tt_ord_col.ttv_num_seq)
                        TAB_livre_emsfin.cod_livre_1           = tt_ord_col.ttv_des_tit_ctbl
                        TAB_livre_emsfin.cod_livre_2           = tt_ord_col.ttv_cod_col_demonst_ctbl.

                 &if '{&emsfin_dbtype}' <> 'progress' &then
                     VALIDATE TAB_livre_emsfin.
                 &endif
             END.
         &else
             for each col_prefer_demonst_ctbl exclusive-lock
                 where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                 and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
                 and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
                 DELETE col_prefer_demonst_ctbl.
             end.

             FOR each tt_ord_col:
                CREATE col_prefer_demonst_ctbl.
                ASSIGN col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                       col_prefer_demonst_ctbl.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
                       col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                       col_prefer_demonst_ctbl.num_seq                   = tt_ord_col.ttv_num_seq
                       col_prefer_demonst_ctbl.des_tit_ctbl              = tt_ord_col.ttv_des_tit_ctbl
                       col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = tt_ord_col.ttv_cod_col_demonst_ctbl.
                &if '{&emsfin_dbtype}' <> 'progress' &then
                   VALIDATE col_prefer_demonst_ctbl.
                &endif
             END.
         &endif
        END.


        /* ***[ Atualiza tabela para executar simulando RPW, evitando retorno de msg em tela ]****/
        ASSIGN v_cod_dwb_user = 'es_' + v_cod_usuar_corren.

        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = 'rel_demonst_ctbl_video':U
               and dwb_rpt_param.cod_dwb_user    = 'es_' + v_cod_usuar_corren no-error.
        if  not available dwb_rpt_param
        then do:
            create dwb_rpt_param.
            assign dwb_rpt_param.cod_dwb_program      = 'rel_demonst_ctbl_video':U
                   dwb_rpt_param.cod_dwb_user         = 'es_' + v_cod_usuar_corren
                   dwb_rpt_param.cod_dwb_output       = "Terminal" /*l_terminal*/  
                   dwb_rpt_param.ind_dwb_run_mode     = "On-Line" /*l_online*/ 
                   dwb_rpt_param.cod_dwb_file         = ""
                   dwb_rpt_param.nom_dwb_printer      = ""
                   dwb_rpt_param.cod_dwb_print_layout = "".
        END.

        /* --- Salva os ParÉmetros (RPW) ---*/
        assign dwb_rpt_param.cod_dwb_parameters = tt_prefer_demonst_ctbl_1.tta_cod_demonst_ctbl                   + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_padr_col_demonst_ctbl          + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_acum_cta_ctbl_sint)     + chr(10)
                                                + "no" /*l_no*/                                                       + chr(10)
                                                + ''                                                            + chr(10)
                                                + tt_prefer_demonst_ctbl_1.ttv_cod_carac_lim                      + chr(10)
                                                + ''                                                            + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_exerc_ctbl                     + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_num_period_ctbl)            + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_consid_apurac_restdo)   + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_idioma                         + chr(10)
                                                + string(recid(prefer_demonst_ctbl))                            + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_val_fator_div_demonst_ctbl) + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_impr_cta_sem_sdo)       + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_unid_organ_subst)       + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_estab_subst)            + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_unid_negoc_subst)       + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_ccusto_subst)           + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_unid_organ_subst               + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_estab_ini                      + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_estab_fim                      + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_unid_negoc_ini                 + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_unid_negoc_fim                 + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_plano_ccusto_subst             + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_ccusto_ini                     + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_ccusto_fim                     + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_ccusto_pfixa_subst             + chr(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_ccusto_exec_subst              + chr(10)
                                                + string(tt_prefer_demonst_ctbl_1.tta_log_acum_cta_ctbl_sint)     + CHR(10)
                                                + tt_prefer_demonst_ctbl_1.tta_cod_unid_organ                     + CHR(10)
                                                + "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/                                   + CHR(10)
                                                + ''                                                            + CHR(10)
                                                + ''                                                            + chr(10)
                                                + v_cod_usuar_corren                                            + CHR(10)
                                                + string(v_dat_inic_period_ctbl,'99/99/9999')                   + CHR(10)
                                                + string(v_dat_fim_period_ctbl,'99/99/9999')                    + CHR(10)
                                                + string(tt_prefer_demonst_ctbl_1.ttv_log_impr_acum_zero)       + CHR(10)
                                                + ''                                                            + CHR(10)
                                                + string(tt_prefer_demonst_ctbl_1.ttv_log_impr_col_sem_sdo).

        /* ***[ Executa API Demonstrativo ]****/

        /* Begin_Include: i_api_demonst_ctbl_video */
        for each tt_exec_rpc:
          delete tt_exec_rpc.
        end.

        create  tt_exec_rpc.
        assign  tt_exec_rpc.ttv_cod_aplicat_dtsul_corren  = v_cod_aplicat_dtsul_corren
                tt_exec_rpc.ttv_cod_ccusto_corren         = v_cod_ccusto_corren
                tt_exec_rpc.ttv_cod_dwb_user              = v_cod_dwb_user
                tt_exec_rpc.ttv_cod_empres_usuar          = v_cod_empres_usuar
                tt_exec_rpc.ttv_cod_estab_usuar           = v_cod_estab_usuar 
                tt_exec_rpc.ttv_cod_funcao_negoc_empres   = v_cod_funcao_negoc_empres
                tt_exec_rpc.ttv_cod_grp_usuar_lst         = v_cod_grp_usuar_lst
                tt_exec_rpc.ttv_cod_idiom_usuar           = v_cod_idiom_usuar
                tt_exec_rpc.ttv_cod_modul_dtsul_corren    = v_cod_modul_dtsul_corren
                tt_exec_rpc.ttv_cod_modul_dtsul_empres    = v_cod_modul_dtsul_empres
                tt_exec_rpc.ttv_cod_pais_empres_usuar     = v_cod_pais_empres_usuar
                tt_exec_rpc.ttv_cod_plano_ccusto_corren   = v_cod_plano_ccusto_corren
                tt_exec_rpc.ttv_cod_unid_negoc_usuar      = v_cod_unid_negoc_usuar
                tt_exec_rpc.ttv_cod_usuar_corren          = v_cod_usuar_corren
                tt_exec_rpc.ttv_cod_usuar_corren_criptog  = v_cod_usuar_corren_criptog
                tt_exec_rpc.ttv_num_ped_exec_corren       = v_num_ped_exec_corren.

        if  search("prgfin/mgl/escg0204za.r") = ? and search("prgfin/mgl/escg0204za.py") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/escg0204za.py".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/mgl/escg0204za.py"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/mgl/escg0204za.py (Input 1,
                                    Input table tt_exec_rpc,
                                    output v_des_lista_estab,
                                    output table tt_log_erros) /*prg_api_demonst_ctbl_video*/.
        /* End_Include: i_api_demonst_ctbl_video */
        .

        /* ***[ Formata Retorno API ]****/
        run pi_retorno_api_demonst_ctbl_video_sped /*pi_retorno_api_demonst_ctbl_video_sped*/.

        /* ***[ Retorna valor do usu†rio corrente ]****/
        ASSIGN v_cod_usuar_corren = v_cod_usuar_2.
        ASSIGN v_cod_dwb_user     = v_cod_usuar_corren.

        /* ***[ Elimina temp-tables ]****/
        for each tt_item_demonst_ctbl_video:
          delete tt_item_demonst_ctbl_video.
        end.  
        for each tt_label_demonst_ctbl_video:
          delete tt_label_demonst_ctbl_video.
        end.
        for each tt_valor_demonst_ctbl_video:
          delete tt_valor_demonst_ctbl_video.
        end.
        for each tt_demonst_ctbl_fin:
          delete tt_demonst_ctbl_fin.
        end.
        for each tt_item_demonst_ctbl_cadastro:
          delete tt_item_demonst_ctbl_cadastro.
        end.
        for each tt_compos_demonst_cadastro:
          delete tt_compos_demonst_cadastro.
        end.
        for each tt_estrut_visualiz_ctbl_cad:
          delete tt_estrut_visualiz_ctbl_cad.
        end.
        for each tt_col_demonst_ctbl:
          delete tt_col_demonst_ctbl.
        end.
        for each tt_acumul_demonst_cadastro:
          delete tt_acumul_demonst_cadastro.
        end.
        for each tt_ord_col:
          delete tt_ord_col.
        end.

    END.


    /* Begin_Include: i_log_exec_prog_dtsul_fim */
    if v_rec_log <> ? then do transaction:
        find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
        if  avail log_exec_prog_dtsul
        then do:
            assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
                   log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
        end /* if */.
        release log_exec_prog_dtsul.
    end.

    /* End_Include: i_log_exec_prog_dtsul_fim */

    return.
END PROCEDURE. /* pi_main_api_demonst_ctbl_fin_sped */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/


/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*********************  End of api_demonst_ctbl_fin_sped ********************/
