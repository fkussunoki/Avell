/*****************************************************************************
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 5.12.16.107":U no-undo.
def var c-versao-rcode as char initial "[[[5.12.16.107[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}
    
{include/cdcfgfin.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bas_demonst_ctbl_fin MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/


/********************* Temporary Table Definition Begin - Projeto Orcamento Araupel*********************/
def new shared temp-table tt_just_resumo no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
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
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Oráado" column-label "Valor Oráado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Oráado" column-label "Saldo Oráado"
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field ttv_log_sdo_orcado_sint          as logical format "Sim/N∆o" initial no
    field ttv_val_perc_criter_distrib      as decimal format ">>9.99" decimals 6 initial 0 label "Percentual" column-label "Percentual"
    field ttv_concatena                    as CHAR FORMAT "x(100)"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
          ttv_ind_espec_sdo                ascending
          tta_cod_unid_organ_orig          ascending
    .


def new shared temp-table tt_just_totaliza no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
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
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Oráado" column-label "Valor Oráado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Oráado" column-label "Saldo Oráado"
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field ttv_log_sdo_orcado_sint          as logical format "Sim/N∆o" initial no
    field ttv_val_perc_criter_distrib      as decimal format ">>9.99" decimals 6 initial 0 label "Percentual" column-label "Percentual"
    field ttv_justifica                    as LOGICAL INITIAL NO
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
          ttv_ind_espec_sdo                ascending
          tta_cod_unid_organ_orig          ascending
    .

DEFINE TEMP-TABLE tt-receitas
    FIELD nome AS CHAR.

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

def temp-table tt_atributos no-undo
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_num_vers_integr              as integer format ">>>>,>>9"
    field ttv_nom_graphic_title            as character format "x(50)"
    field ttv_num_graphic_title_color      as integer format ">>>>,>>9" initial ?
    field ttv_num_graphic_type             as integer format ">>>>,>>9" initial ?
    field ttv_num_graphic_style            as integer format ">>>>,>>9" initial ?
    field ttv_num_labels_color             as integer format ">>>>,>>9" initial ?
    field ttv_nom_left_title               as character format "x(30)" initial ?
    field ttv_num_left_title_style         as integer format ">>>>,>>9" initial ?
    field ttv_num_left_title_color         as integer format ">>>>,>>9" initial ?
    field ttv_nom_bottom_title             as character format "x(30)" initial ?
    field ttv_num_bottom_title_color       as integer format ">>>>,>>9" initial ?
    field ttv_num_dat_labels               as integer format ">>>>,>>9" initial ?
    field ttv_cod_dat_labels_format        as character format "x(8)" initial ?
    field ttv_num_dat_labels_color         as integer format ">>>>,>>9" initial ?
    field ttv_num_limit_lines              as integer format ">>>>,>>9" initial ?
    field ttv_num_limit_lines_color        as integer format ">>>>,>>9" initial ?
    field ttv_cod_limit_high_label         as character format "x(8)" initial ?
    field ttv_cod_limit_low_label          as character format "x(8)" initial ?
    field ttv_val_limit_high_value         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial ?
    field ttv_val_limit_low_value          as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial ?
    field ttv_num_line_stats               as integer format ">>>>,>>9" initial ?
    field ttv_num_mean_line_color          as integer format ">>>>,>>9" initial ?
    field ttv_num_min_max_lines_color      as integer format ">>>>,>>9" initial ?
    field ttv_num_st_dev_lines_color       as integer format ">>>>,>>9" initial ?
    field ttv_num_best_fit_lines_color     as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_type               as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_order              as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_color              as integer format ">>>>,>>9" initial ?
    field ttv_num_thick_lines              as integer format ">>>>,>>9" initial ?
    field ttv_num_grid_style               as integer format ">>>>,>>9" initial ?
    field ttv_num_grid_line_style          as integer format ">>>>,>>9" initial ?
    field ttv_cod_title_font_name          as character format "x(8)" initial ?
    field ttv_num_title_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_title_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_other_font_name          as character format "x(8)" initial ?
    field ttv_num_other_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_other_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_label_font_name          as character format "x(8)" initial ?
    field ttv_num_label_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_label_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_legend_font_name         as character format "x(8)" initial ?
    field ttv_num_legend_font_size         as integer format ">>>>,>>9" initial ?
    field ttv_num_legend_font_style        as integer format ">>>>,>>9" initial ?
    field ttv_num_legend_pos               as integer format ">>>>,>>9" initial ?
    field tta_cb3_ident_visual             as Character format "x(20)" initial ? label "N£mero Plaqueta" column-label "N£mero Plaqueta"
    index tt_idx_graph                     is primary unique
          ttv_num_graphic                  ascending
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
    field ttv_log_analit                   as logical format "Sim/N∆o" initial no label "Anal°tico"
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

def temp-table tt_demonst_ctbl_legenda no-undo
    field ttv_cod_legenda_demonst          as character format "x(30)" label "Informaá∆o"
    .

def new shared temp-table tt_demonst_ctbl_video no-undo
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

def temp-table tt_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_cod_desc_erro                as character format "x(8)"
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

def temp-table tt_graph_data no-undo
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_num_point                    as integer format ">>>>,>>9"
    field ttv_num_set                      as integer format ">>>>,>>9"
    field ttv_val_graphic_dat              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_point                    ascending
          ttv_num_set                      ascending
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
    field ttv_cod_chave_1                  as character format "x(20)" label "Chave de Acesso"
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

def temp-table tt_lista_cta_restric no-undo
    field ttv_rec_ret_sdo_ctbl_pai         as recid format ">>>>>>9"
    field ttv_rec_ret_sdo_ctbl_filho       as recid format ">>>>>>9"
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

def temp-table tt_points no-undo
    field ttv_num_point                    as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_label_text               as character format "x(30)" initial ?
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_point                    ascending
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

def temp-table tt_relacto_valor_aux no-undo
    field ttv_rec_val_aux                  as recid format ">>>>>>9"
    field ttv_rec_ret_sdo                  as recid format ">>>>>>9"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    index tt_id                           
          tta_num_seq                      ascending
          ttv_rec_val_aux                  ascending
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

def temp-table tt_sets no-undo
    field ttv_num_set                      as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_legend_text              as character format "x(30)" initial ?
    field ttv_num_color_set                as integer format ">>>>,>>9" initial ?
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_set                      ascending
    .

def new shared temp-table tt_unid_negocio no-undo
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_cod_unid_negoc_pai           as character format "x(3)" label "Un Neg Pai" column-label "Un Neg Pai"
    field ttv_log_proces                   as logical format "Sim/Nao" initial no label "&prc(" column-label "&prc("
    field ttv_ind_espec_unid_negoc         as character format "X(10)" label "EspÇcie UN" column-label "EspÇcie UN"
    index tt_cod_unid_negoc_pai           
          ttv_cod_unid_negoc_pai           ascending
    index tt_log_proces                   
          ttv_log_proces                   ascending
    index tt_select_id                     is primary unique
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_valor_aux no-undo
    field tta_cod_seq                      as character format "x(8)" label "Sequància" column-label "Sequància"
    field ttv_cod_inform_1                 as character format "x(20)" label "Label-1" column-label "Label-1"
    index tt_id                           
          ttv_cod_inform_1                 ascending
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

def temp-table tt_valor_demonst_ctbl_video_aux no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_rec_item_demonst_ctbl        as recid format ">>>>>>9"
    field ttv_val_coluna                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2
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

def temp-table tt_ylabels no-undo
    field ttv_num_y_label                  as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_y_label_text             as character format "x(30)"
    index tt_idx_ylabel                    is primary unique
          ttv_num_y_label                  ascending
          ttv_num_graphic                  ascending
    .



/********************** Temporary Table Definition End **********************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
&if '{&emsbas_version}' >= '5.06' &then
         resize               = no
&else
         resize               = yes
&endif
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.




{include/i_fclwin.i wh_w_program }
/*************************** Window Definition End **************************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_col_demonst_ctbl
    for tt_col_demonst_ctbl.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_compos_demonst_cadastro
    for tt_compos_demonst_cadastro.
&endif
def buffer btt_cta_ctbl_demonst
    for tt_cta_ctbl_demonst.
def buffer btt_demonst_ctbl_fin
    for tt_demonst_ctbl_fin.
def buffer btt_demonst_ctbl_video
    for tt_demonst_ctbl_video.
&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_estrut_visualiz_ctbl_cad
    for tt_estrut_visualiz_ctbl_cad.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_item_demonst_ctbl_cadastro
    for tt_item_demonst_ctbl_cadastro.
&endif
def buffer btt_item_demonst_ctbl_video
    for tt_item_demonst_ctbl_video.
def buffer btt_retorna_sdo_ctbl_demonst
    for tt_retorna_sdo_ctbl_demonst.
def buffer btt_retorna_sdo_orcto_ccusto
    for tt_retorna_sdo_orcto_ccusto.
def buffer btt_valor_demonst_ctbl_video
    for tt_valor_demonst_ctbl_video.
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_estrut_ccusto
    for estrut_ccusto.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_estrut_cta_ctbl
    for estrut_cta_ctbl.
&endif
&if "{&emsuni_version}" >= "5.05" &then
def buffer b_estrut_proj_financ
    for estrut_proj_financ.
&endif
&if "{&emsuni_version}" >= "5.05" &then
def buffer b_estrut_unid_negoc
    for estrut_unid_negoc.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_estrut_unid_organ
    for emsuni.estrut_unid_organ.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_prefer_demonst_ctbl
    for prefer_demonst_ctbl.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variaveis globais projeto Araupel ************************/

        def new global shared var v_var_ccusto
            as DECIMAL
            format "->>>,>>>>,>>>>,>>>.99"
            no-undo.


        def new global shared var v_var_ccusto_neg
            as DECIMAL
            format "->>>,>>>>,>>>>,>>>.99"
            no-undo.


        def new global shared var v_log_realizado
            as logical
            format "Sim/N∆o"
            initial no
            view-as toggle-box
            label "Realizado"
            no-undo.

    
        def new global shared var v_log_nao_realzdo_label
            as logical
            format "Sim/N∆o"
            initial no
            view-as toggle-box
            label "Nao Realizado"
            no-undo.


/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_aux_3
    as character
    format "x(1)":U
    no-undo.
def var v_cod_campo
    as character
    format "x(25)":U
    label "Campo"
    column-label "Campo"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def new global shared var v_cod_ccusto
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_ccusto
    as character
    format "x(20)":U
    label "Centro de Custo"
    column-label "CCusto"
    no-undo.
&ENDIF
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_exec_subst
    as character
    format "x(11)":U
    label "Subst PExec"
    no-undo.
def new global shared var v_cod_ccusto_final
    as character
    format "x(11)":U
    initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_cod_ccusto_inicial
    as character
    format "x(11)":U
    label "Centro de Custo"
    no-undo.
def var v_cod_ccusto_pai
    as Character
    format "x(11)":U
    label "Centro Custo Pai"
    column-label "Centro Custo Pai"
    no-undo.
def var v_cod_ccusto_pai_fim
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_pai_maior
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_pai_menor
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_pfixa_subst
    as character
    format "x(11)":U
    label "Subst Parte Fixa"
    no-undo.
def var v_cod_ccusto_subst_fim
    as character
    format "x(11)":U
    no-undo.
def var v_cod_ccusto_subst_inic
    as character
    format "x(11)":U
    no-undo.
def new global shared var v_cod_cenar_ctbl_ini
    as character
    format "x(8)":U
    label "Inicial"
    column-label "Inicial"
    no-undo.
def var v_cod_chave
    as character
    format "x(40)":U
    no-undo.
def var v_cod_cta_ctbl
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.
def new global shared var v_cod_cta_ctbl_final
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_cod_cta_ctbl_inic
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.
def new global shared var v_cod_cta_ctbl_inicial
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
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
def new global shared var v_cod_empres_ems_fim
    as character
    format "x(3)":U
    initial "ZZZ" /*l_zzz*/
    label "atÇ"
    no-undo.
def new global shared var v_cod_empres_ems_inic
    as character
    format "x(3)":U
    label "Empresa"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def new global shared var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_estab_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def new global shared var v_cod_estab_in
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_estab_in
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def new global shared var v_cod_estab_ini
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_estab_ini
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
def var v_cod_estab_subst_fim
    as character
    format "x(3)":U
    no-undo.
def var v_cod_estab_subst_inic
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_exec_period_1
    as character
    format "x(6)":U
    no-undo.
def new global shared var v_cod_exerc_ctbl_fin
    as character
    format "9999":U
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_cod_exerc_ctbl_inic
    as character
    format "9999":U
    label "Exerc°cio Cont†bil"
    column-label "Exerc°cio Cont†bil"
    no-undo.
def new global shared var v_cod_finalid_econ_fim
    as character
    format "x(10)":U
    initial "ZZZZZZZZZZ"
    label "Final"
    column-label "Final"
    no-undo.
def new global shared var v_cod_finalid_econ_ini
    as character
    format "x(10)":U
    label "Inicial"
    column-label "Inicial"
    no-undo.
def var v_cod_format_ccusto
    as character
    format "x(11)":U
    initial "x(11)" /*l_x(11)*/
    label "Formato CCusto"
    column-label "Formato CCusto"
    no-undo.
def var v_cod_format_col_demonst_ctbl
    as character
    format "x(40)":U
    label "Formato Coluna"
    column-label "Formato Coluna"
    no-undo.
def var v_cod_format_cta_ctbl
    as character
    format "x(20)":U
    label "Formato Cta Cont†bil"
    column-label "Formato Conta"
    no-undo.
def var v_cod_format_proj_financ
    as character
    format "x(20)":U
    label "Formato Projeto"
    column-label "Formato Projeto"
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
def var v_cod_inform
    as character
    format "x(60)":U
    no-undo.
def var v_cod_lista_compon
    as character
    format "x(50)":U
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
def new global shared var v_cod_plano_ccusto
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_plano_ccusto_ant
    as character
    format "x(8)":U
    label "Plano Centros Custo"
    column-label "Plano Centros Custo"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_plano_ccusto_final
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_cod_plano_ccusto_ini
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano Centros Custo"
    no-undo.
def var v_cod_plano_ccusto_sub
    as character
    format "x(8)":U
    label "Plano Centros Custo"
    column-label "Plano Centros Custo"
    no-undo.
def new global shared var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
def new global shared var v_cod_plano_cta_ctbl_inicial
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
def new global shared var v_cod_plano_cta_final
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_cod_proj_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_proj_financ
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def var v_cod_proj_financ_000
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def var v_cod_proj_financ_999
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def new global shared var v_cod_proj_inic
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def var v_cod_tip_graf
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_unid_negoc
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Un Neg"
    no-undo.
def new global shared var v_cod_unid_negoc_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def new global shared var v_cod_unid_negoc_ini
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Inicial"
    no-undo.
def new global shared var v_cod_unid_negoc_inic
    as character
    format "x(3)":U
    label "Unidade Neg¢cio"
    column-label "Unidade Neg¢cio"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_unid_orctaria_ate
    as character
    format "x(8)":U
    initial "ZZZZZZZZ" /*l_zzzzzzzz*/
    label "atÇ"
    column-label "AtÇ"
    no-undo.
def new global shared var v_cod_unid_orctaria_aux
    as character
    format "x(8)":U
    label "Unid Oráament†ria"
    column-label "Unid Oráament†ria"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def new global shared var v_cod_unid_organ
    as character
    format "x(3)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_unid_organ
    as Character
    format "x(5)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
def new global shared var v_cod_unid_organizacional
    as character
    format "x(3)":U
    no-undo.
def var v_cod_unid_organ_ant
    as character
    format "x(3)":U
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_unid_organ_sub
    as character
    format "x(3)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_unid_organ_sub
    as Character
    format "x(5)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
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
def var v_dat_fim_period
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    no-undo.
def var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def new global shared var v_dat_movto
    as date
    format "99/99/9999":U
    label "Data Movimento"
    column-label "Data Movimento"
    no-undo.
def new global shared var v_dat_movto_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "atÇ"
    no-undo.
def var v_des_chave
    as character
    format "x(40)":U
    no-undo.
def var v_des_col_aux
    as character
    format "x(40)":U
    no-undo.
def var v_des_erro_aux
    as character
    format "x(200)":U
    label "Erro RPC AUX"
    column-label "Erro"
    no-undo.
def var v_des_erro_rpc
    as character
    format "x(200)":U
    label "Erro RPC"
    column-label "Erro RPC"
    no-undo.
def var v_des_formul
    as character
    format "x(80)":U
    no-undo.
def var v_des_lista_ccusto_sem_segur
    as character
    format "x(40)":U
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
def var v_des_tit_idiom
    as character
    format "x(40)":U
    no-undo.
def var v_des_visualiz
    as character
    format "x(80)":U
    no-undo.
def var v_des_visualiz_ccusto
    as character
    format "x(40)":U
    no-undo.
def var v_des_visualiz_plano_ccusto
    as character
    format "x(40)":U
    no-undo.
def var v_des_visualiz_unid_organ
    as character
    format "x(40)":U
    no-undo.
def new global shared var v_hdl_func_padr_glob
    as Handle
    format ">>>>>>9":U
    label "Funá‰es Pad Glob"
    column-label "Funá‰es Pad Glob"
    no-undo.
def var v_ind_funcao_col_demonst_ctbl
    as character
    format "X(12)":U
    initial "Todas" /*l_todas*/
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Todas","Todas","Impress∆o","Impress∆o","Base C†lculo","Base C†lculo"
    &else
    list-items "Todas","Impress∆o","Base C†lculo"
    &endif
     /*l_todas*/ /*l_impressao*/ /*l_base_calculo*/
    inner-lines 4
    bgcolor 15 font 2
    label "Funá∆o Coluna"
    column-label "Funá∆o Coluna"
    no-undo.
def var v_ind_operac_formul
    as character
    format "X(08)":U
    no-undo.
def new global shared var v_ind_selec_demo_ctbl
    as character
    format "X(25)":U
    view-as radio-set Vertical
    radio-buttons "Demonstrativo Cont†bil", "Demonstrativo Cont†bil" /*, "Consultas de Saldo", "Consultas de Saldo" */
     /*l_demonstrativo_contabil*/ /*l_demonstrativo_contabil*/ /*l_consultas_de_saldo*/ /*l_consultas_de_saldo*/
    bgcolor 8 
    no-undo.
def new global shared var v_ind_selec_tip_demo
    as character
    format "X(28)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Saldo Conta Cont†bil","Saldo Conta Cont†bil","Saldo Conta Centros Custo","Saldo Conta Centros Custo","Saldo Centro Custo Contas","Saldo Centro Custo Contas"
    &else
    list-items "Saldo Conta Cont†bil","Saldo Conta Centros Custo","Saldo Centro Custo Contas"
    &endif
     /*l_saldo_conta_contabil_demo*/ /*l_saldo_conta_centros_custo*/ /*l_saldo_centro_custo_contas*/
    inner-lines 5
    bgcolor 15 font 2
    label "Consultar"
    no-undo.
def var v_ind_tip_operac_formul
    as character
    format "X(08)":U
    no-undo.
def new global shared var v_ind_tip_sdo_ctbl_demo
    as character
    format "X(15)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Simples","Simples","Compostos","Compostos"
    &else
    list-items "Simples","Compostos"
    &endif
     /*l_simples*/ /*l_compostos*/
    inner-lines 5
    bgcolor 15 font 2
    label "Tipo"
    no-undo.
def new global shared var v_log_abert_ccusto
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Abrir por CCusto"
    column-label "Abrir por CCusto"
    no-undo.
def var v_log_achou
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_acum_cta_ctbl_sint
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Acum Cta SintÇtica"
    column-label "Acum Cta SintÇtica"
    no-undo.
def new global shared var v_log_alterado
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_ccusto_pai
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_ccusto_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Ccusto"
    column-label "Subst Ccusto"
    no-undo.
def new global shared var v_log_col_analis_vert
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_compos_msg_varios
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_consid_apurac_restdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Consid Apurac Restdo"
    column-label "Apurac Restdo"
    no-undo.
def new shared var v_log_consolid_recur
    as logical
    format "Sim/N∆o"
    initial NO
    view-as toggle-box
    label "Consolidaá∆o Recurs"
    column-label "Consolid Recurv"
    no-undo.
def var v_log_estab_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Estab"
    column-label "Subst Estab"
    no-undo.
def var v_log_exec_orctaria
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_expand
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_expand_lin
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_final_proces
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_concil_consolid
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_funcao_expand_cta_ctbl
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
def var v_log_nova_con_sdo_empenh
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_orcto_cta_sint
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def new global shared var v_log_orig_demonst
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_plano_ccusto_varios
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_primei_col_title
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_primei_compos_demonst
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_proces
    as logical
    format "Sim/Nao"
    initial no
    view-as toggle-box
    label "&prc("
    column-label "&prc("
    no-undo.
def var v_log_process
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_retorno
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_ret_segur
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_rpc
    as logical
    format "Sim/N∆o"
    initial no
    label "RPC"
    column-label "RPC"
    no-undo.
def var v_log_save
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_status
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_tit_demonst
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_unid_negoc_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Un Neg"
    column-label "Subst Un Neg"
    no-undo.
def var v_log_unid_organ_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst UO"
    column-label "Subst UO"
    no-undo.
def var v_log_unid_organ_varios
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_vert
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new shared var v_nom_dwb_print_file_2
    as character
    format "x(100)":U
    label "Arquivo Impress∆o"
    column-label "Arq Impr"
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_ano
    as integer
    format "9999":U
    initial 0001
    label "Ano"
    no-undo.
def var v_num_aux
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_column
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_coluna
    as integer
    format ">>>>,>>9":U
    label "Coluna"
    column-label "Coluna"
    no-undo.
def var v_num_conjto_param_ctbl
    as integer
    format ">9":U
    initial 0
    no-undo.
def var v_num_cont
    as integer
    format ">,>>9":U
    initial 0
    no-undo.
def var v_num_cont_1
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_cont_2
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_count
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_dataset
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
    no-undo.
def var v_num_mes
    as integer
    format "99":U
    initial 01
    label "Màs"
    no-undo.
def var v_num_nivel
    as integer
    format ">>>>,>>9":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_num_period_ctbl_final
    as integer
    format ">99":U
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new global shared var v_num_period_ctbl_ini
    as integer
    format ">99":U
    initial 001
    label "Per°odo Inicial"
    column-label "Inicial"
    no-undo.
def var v_num_pos
    as integer
    format ">>>>,>>9":U
    label "Posiá∆o Inicial"
    column-label "Posiá∆o Inicial"
    no-undo.
def var v_num_posicao
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_seq
    as integer
    format ">>>,>>9":U
    label "SeqÅància"
    column-label "Seq"
    no-undo.
def var v_num_seq_fim
    as integer
    format ">>>,>>9":U
    initial 999999
    label "Sequencia Final"
    no-undo.
def var v_num_seq_ini
    as integer
    format ">>>,>>9":U
    initial 0
    label "Sequencia Inicial"
    no-undo.
def var v_qtd_movto
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    no-undo.
def var v_qtd_movto_empenh
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    label "Qtde Movto Empenhado"
    column-label "Qtde Movto Empenhado"
    no-undo.
def var v_qtd_orcado
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    initial 0
    label "Qtdade Oráada"
    column-label "Qtdade Oráada"
    no-undo.
def var v_qtd_orcado_sdo
    as decimal
    format "->>,>>>,>>>,>>9.9999":U
    decimals 4
    no-undo.
def var v_qtd_sdo_ctbl_cr
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Quantidade CR"
    column-label "Quantidade CR"
    no-undo.
def var v_qtd_sdo_ctbl_db
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Quantidade DB"
    column-label "Quantidade DB"
    no-undo.
def var v_qtd_sdo_ctbl_fim
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Quantidade Final"
    column-label "Quantidade Final"
    no-undo.
def var v_qtd_sdo_ctbl_inic
    as decimal
    format ">>>9":U
    decimals 0
    no-undo.
def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_cenar_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_col_demonst_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_cta_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_demonst_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_demonst_ctbl_video
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_empresa
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_exerc_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_finalid_econ
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_item_demonst_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_item_demonst_ctbl_video
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_period_ctbl_ini
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_ccusto
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_cta_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_vers_orcto_ctbl_bgc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_apurac_restdo_acum_505
    as decimal
    format "->>>>,>>>,>>>,>>9.99":U
    decimals 2
    label "Apuracao Final"
    column-label "Apuracao Final"
    no-undo.
def var v_val_apurac_restdo_cr_505
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Apuraá∆o Restdo CR"
    column-label "Apuraá∆o Restdo CR"
    no-undo.
def var v_val_apurac_restdo_db_505
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Apuraá∆o Restdo DB"
    column-label "Apuraá∆o Restdo DB"
    no-undo.
def var v_val_apurac_restdo_inic_50
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_apurac_restdo_movto_50
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Creditar"
    column-label "Creditar"
    no-undo.
def var v_val_db
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Valor Debitado"
    column-label "Debitado"
    no-undo.
def var v_val_empenh
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_movto
    as decimal
    format "->,>>>,>>>,>>9.99":U
    decimals 2
    label "Movimento"
    column-label "Valor Movto"
    no-undo.
def var v_val_movto_empenh
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 9
    label "Movto Empenhado"
    column-label "Movto Empenhado"
    no-undo.
def var v_val_orcado
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Valor Oráado"
    column-label "Valor Oráado"
    no-undo.
def var v_val_orcado_sdo
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Oráado Acumulado"
    column-label "Oráado Acumulado"
    no-undo.
def var v_val_perc_particip
    as decimal
    format ">,>>9.99":U
    decimals 6
    no-undo.
def var v_val_restdo_formul
    as decimal
    format "->>,>>>,>>>,>>9.99999999":U
    decimals 8
    no-undo.
def var v_val_sdo_ctbl_cr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "CrÇditos"
    column-label "CrÇditos"
    no-undo.
def var v_val_sdo_ctbl_db
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "DÇbitos"
    column-label "DÇbitos"
    no-undo.
def var v_val_sdo_ctbl_fim
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Final"
    column-label "Saldo Final"
    no-undo.
def var v_val_sdo_ctbl_ini
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Inicial"
    column-label "Saldo Inicial"
    no-undo.
def var v_val_sdo_idx
    as decimal
    format "->>>>>>,>>>,>>9.9999":U
    decimals 6
    label "Saldo ÷ndice"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_servid_rpc
    as widget-handle
    format ">>>>>>9":U
    label "Handle RPC"
    column-label "Handle RPC"
    no-undo.
def var v_cod_conjto_prefer_orctario     as character       no-undo. /*local*/
def var v_cod_exerc_period_1             as character       no-undo. /*local*/
def var v_cod_exerc_period_2             as character       no-undo. /*local*/
def var v_cod_final                      as character       no-undo. /*local*/
def var v_cod_format                     as character       no-undo. /*local*/
def var v_cod_initial                    as character       no-undo. /*local*/
def var v_cod_unid                       as character       no-undo. /*local*/
def var v_cod_unid_negoc_subst_fim       as character       no-undo. /*local*/
def var v_cod_unid_negoc_subst_inic      as character       no-undo. /*local*/
def var v_log_return                     as logical         no-undo. /*local*/
def var v_log_unid_negoc                 as logical         no-undo. /*local*/
def var v_nom_prog                       as character       no-undo. /*local*/
def var v_num_col                        as integer         no-undo. /*local*/
def var v_num_col_max                    as integer         no-undo. /*local*/
def var v_num_lin_tit                    as integer         no-undo. /*local*/
def var v_num_seq_compos                 as integer         no-undo. /*local*/
def var v_rec_demonst_ctbl_video_aux     as recid           no-undo. /*local*/
def var v_val_analis_vert                as decimal         no-undo. /*local*/
def var v_val_sdo_base                   as decimal         no-undo. /*local*/
def var v_val_sdo_ctbl                   as decimal         no-undo. /*local*/


&if '{&emsbas_version}' >= '5.06' &then
def temp-table tt_maximizacao no-undo
    field hdl-widget             as widget-handle
    field tipo-widget            as character 
    field row-original           as decimal
    field col-original           as decimal
    field width-original         as decimal
    field height-original        as decimal
    field log-posiciona-row      as logical
    field log-posiciona-col      as logical
    field log-calcula-width      as logical
    field log-calcula-height     as logical
    field log-button-right       as logical
    field frame-width-original   as decimal
    field frame-height-original  as decimal
    field window-width-original  as decimal
    field window-height-original as decimal.
&endif
/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/


def sub-menu  mi_table
    menu-item mi_exi               label "Sair".

def sub-menu  mi_hel
    menu-item mi_contents          label "Conte£do"
    RULE
    menu-item mi_about             label "Sobre".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Tabela"
    sub-menu  mi_hel                label "Ajuda".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_demonst_ctbl_fin
    for tt_demonst_ctbl_fin
    scrolling.
def query qr_demonst_ctbl_legenda
    for tt_demonst_ctbl_legenda
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_demonst_ctbl_fin query qr_demonst_ctbl_fin display 
    tt_demonst_ctbl_fin.ttv_cod_campo_1
    width-chars 0013.00
    tt_demonst_ctbl_fin.ttv_cod_campo_2
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_3
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_4
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_5
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_6
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_7
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_8
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_9
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_10
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_11
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_12
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_13
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_14
    width-chars 0010.80
    tt_demonst_ctbl_fin.ttv_cod_campo_15
    width-chars 0010.80
    enable 
        tt_demonst_ctbl_fin.ttv_cod_campo_1
        tt_demonst_ctbl_fin.ttv_cod_campo_2
        tt_demonst_ctbl_fin.ttv_cod_campo_3
        tt_demonst_ctbl_fin.ttv_cod_campo_4
        tt_demonst_ctbl_fin.ttv_cod_campo_5
        tt_demonst_ctbl_fin.ttv_cod_campo_6
        tt_demonst_ctbl_fin.ttv_cod_campo_7
        tt_demonst_ctbl_fin.ttv_cod_campo_8
        tt_demonst_ctbl_fin.ttv_cod_campo_9
        tt_demonst_ctbl_fin.ttv_cod_campo_10
        tt_demonst_ctbl_fin.ttv_cod_campo_11
        tt_demonst_ctbl_fin.ttv_cod_campo_12
        tt_demonst_ctbl_fin.ttv_cod_campo_13
        tt_demonst_ctbl_fin.ttv_cod_campo_14
        tt_demonst_ctbl_fin.ttv_cod_campo_15
    with separators single no-row-markers 
         size 88.57 by 14.38
         font 2
         bgcolor 15
         title "Acompanhamento Orcamentario".
def browse br_demonst_ctbl_legenda query qr_demonst_ctbl_legenda display 
    tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst
    width-chars 30.00
        column-label "v_cod_legenda_demonst"
    enable 
        tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst
    with no-box separators multiple no-row-markers 
         size 33.00 by 05.75
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_atz
    label "Atualiza"
    tooltip "Atualiza"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-tick.bmp"
    image-insensitive file "image/ii-tic-i.bmp"
&endif
    size 1 by 1.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_can2
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1.
def button bt_config_rpc
    label "RPC"
    tooltip "Configura RPC"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-cfrpc.bmp"
    image-insensitive file "image/ii-cfrpc.bmp"
&endif
    size 1 by 1.
def button bt_exi
    label "Sa°da"
    tooltip "Sa°da"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
&endif
    size 1 by 1.
def button bt_fil2
    label "Fil"
    tooltip "Filtro"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
&endif
    size 1 by 1.
def button bt_fir
    label "<<"
    tooltip "Primeira Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-fir"
    image-insensitive file "image/ii-fir"
&endif
    size 1 by 1.
def button bt_grf_barra
    label "Grf"
    tooltip "Gr†fico An†lise Horizontal"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-grf.bmp"
    image-insensitive file "image/ii-grf"
&endif
    size 1 by 1.
def button bt_grf_pizza
    label "Grf"
    tooltip "Gr†fico An†lise Vertical"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pizza.bmp"
    image-insensitive file "image/ii-pizza"
&endif
    size 1 by 1.
def button bt_hel1
    label " ?"
    tooltip "Ajuda"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-hel"
    image-insensitive file "image/ii-hel"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_las
    label ">>"
    tooltip "Èltima Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-las"
    image-insensitive file "image/ii-las"
&endif
    size 1 by 1.
def button bt_legenda
    label "Legenda"
    tooltip "Legenda"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-legen"
&endif
    size 1 by 1.
def button bt_nex1
    label ">"
    tooltip "Pr¢xima Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
&endif
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_pre1
    label "<"
    tooltip "Ocorrància Anterior da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
&endif
    size 1 by 1.
def button bt_pri
    label "Imp"
    tooltip "Imprime"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pri"
    image-insensitive file "image/ii-pri.bmp"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_demonst_ctbl_fin
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    bt_exi
         at row 01.08 col 82.57 font ?
         help "Sa°da"
    bt_hel1
         at row 01.08 col 86.57 font ?
         help "Ajuda"
    bt_fir
         at row 01.13 col 01.57 font ?
         help "Primeira Ocorrància da Tabela"
    bt_pre1
         at row 01.13 col 05.57 font ?
         help "Ocorrància Anterior da Tabela"
    bt_nex1
         at row 01.13 col 09.57 font ?
         help "Pr¢xima Ocorrància da Tabela"
    bt_las
         at row 01.13 col 13.57 font ?
         help "Èltima Ocorrància da Tabela"
    bt_fil2
         at row 01.13 col 18.57 font ?
         help "Filtro"
    bt_pri
         at row 01.13 col 22.57 font ?
         help "Imprime"
    bt_atz
         at row 01.13 col 26.57 font ?
         help "Atualiza"
    bt_legenda
         at row 01.13 col 30.57 font ?
         help "Legenda"
    bt_grf_pizza
         at row 01.13 col 34.57 font ?
         help "Gr†fico An†lise Vertical"
    bt_grf_barra
         at row 01.13 col 38.57 font ?
         help "Gr†fico An†lise Horizontal"
    bt_config_rpc
         at row 01.13 col 43.57 font ?
         help "Configura RPC"
    br_demonst_ctbl_fin
         at row 02.42 col 01.43
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 17.00
         at row 01.00 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Acompanhamento Orcamentario".
    /* adjust size of objects in this frame */
    assign bt_atz:width-chars         in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_atz:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_config_rpc:width-chars  in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_config_rpc:height-chars in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_exi:width-chars         in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_exi:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_fil2:width-chars        in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_fil2:height-chars       in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_fir:width-chars         in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_fir:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_grf_barra:width-chars   in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_grf_barra:height-chars  in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_grf_pizza:width-chars   in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_grf_pizza:height-chars  in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_hel1:width-chars        in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_hel1:height-chars       in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_las:width-chars         in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_las:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_legenda:width-chars     in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_legenda:height-chars    in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_nex1:width-chars        in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_nex1:height-chars       in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_pre1:width-chars        in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_pre1:height-chars       in frame f_bas_10_demonst_ctbl_fin = 01.13
           bt_pri:width-chars         in frame f_bas_10_demonst_ctbl_fin = 04.00
           bt_pri:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.13
           rt_mold:width-chars        in frame f_bas_10_demonst_ctbl_fin = 87.72
           rt_mold:height-chars       in frame f_bas_10_demonst_ctbl_fin = 01.21
           rt_rgf:width-chars         in frame f_bas_10_demonst_ctbl_fin = 89.72
           rt_rgf:height-chars        in frame f_bas_10_demonst_ctbl_fin = 01.29.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_demonst_ctbl_fin:ALLOW-COLUMN-SEARCHING in frame f_bas_10_demonst_ctbl_fin = no
       br_demonst_ctbl_fin:COLUMN-MOVABLE in frame f_bas_10_demonst_ctbl_fin = no.
end.
&endif
    /* set private-data for the help system */
    assign bt_exi:private-data              in frame f_bas_10_demonst_ctbl_fin = "HLP=000004665":U
           bt_hel1:private-data             in frame f_bas_10_demonst_ctbl_fin = "HLP=000004666":U
           bt_fir:private-data              in frame f_bas_10_demonst_ctbl_fin = "HLP=000004657":U
           bt_pre1:private-data             in frame f_bas_10_demonst_ctbl_fin = "HLP=000010790":U
           bt_nex1:private-data             in frame f_bas_10_demonst_ctbl_fin = "HLP=000010787":U
           bt_las:private-data              in frame f_bas_10_demonst_ctbl_fin = "HLP=000004658":U
           bt_fil2:private-data             in frame f_bas_10_demonst_ctbl_fin = "HLP=000008766":U
           bt_pri:private-data              in frame f_bas_10_demonst_ctbl_fin = "HLP=000010833":U
           bt_atz:private-data              in frame f_bas_10_demonst_ctbl_fin = "HLP=000021479":U
           bt_legenda:private-data          in frame f_bas_10_demonst_ctbl_fin = "HLP=000000000":U
           bt_grf_pizza:private-data        in frame f_bas_10_demonst_ctbl_fin = "HLP=000008759":U
           bt_grf_barra:private-data        in frame f_bas_10_demonst_ctbl_fin = "HLP=000008756":U
           bt_config_rpc:private-data       in frame f_bas_10_demonst_ctbl_fin = "HLP=000000000":U
           br_demonst_ctbl_fin:private-data in frame f_bas_10_demonst_ctbl_fin = "HLP=000000000":U
           frame f_bas_10_demonst_ctbl_fin:private-data                        = "HLP=000000000".

def frame f_dlg_01_demonst_ctbl_legenda
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 07.96 col 02.00 bgcolor 7 
    br_demonst_ctbl_legenda
         at row 01.50 col 03.29
    bt_ok
         at row 08.17 col 03.00 font ?
         help "OK"
    bt_can
         at row 08.17 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 08.17 col 26.43 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 38.86 by 09.79 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Legenda Demonstrativo Cont†bil".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_demonst_ctbl_legenda = 10.00
           bt_can:height-chars  in frame f_dlg_01_demonst_ctbl_legenda = 01.00
           bt_hel2:width-chars  in frame f_dlg_01_demonst_ctbl_legenda = 10.00
           bt_hel2:height-chars in frame f_dlg_01_demonst_ctbl_legenda = 01.00
           bt_ok:width-chars    in frame f_dlg_01_demonst_ctbl_legenda = 10.00
           bt_ok:height-chars   in frame f_dlg_01_demonst_ctbl_legenda = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_demonst_ctbl_legenda = 35.43
           rt_cxcf:height-chars in frame f_dlg_01_demonst_ctbl_legenda = 01.42
           rt_mold:width-chars  in frame f_dlg_01_demonst_ctbl_legenda = 35.43
           rt_mold:height-chars in frame f_dlg_01_demonst_ctbl_legenda = 06.38.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_demonst_ctbl_legenda:ALLOW-COLUMN-SEARCHING in frame f_dlg_01_demonst_ctbl_legenda = no
       br_demonst_ctbl_legenda:COLUMN-MOVABLE in frame f_dlg_01_demonst_ctbl_legenda = no.
end.
&endif
    /* set private-data for the help system */
    assign br_demonst_ctbl_legenda:private-data in frame f_dlg_01_demonst_ctbl_legenda = "HLP=000000000":U
           bt_ok:private-data                   in frame f_dlg_01_demonst_ctbl_legenda = "HLP=000010721":U
           bt_can:private-data                  in frame f_dlg_01_demonst_ctbl_legenda = "HLP=000011050":U
           bt_hel2:private-data                 in frame f_dlg_01_demonst_ctbl_legenda = "HLP=000011326":U
           frame f_dlg_01_demonst_ctbl_legenda:private-data                            = "HLP=000000000".

def frame f_dlg_02_wait_processing
    rt_001
         at row 01.29 col 02.00
    " Processando... " view-as text
         at row 01.00 col 04.00
    ed_1x40
         at row 02.04 col 03.00
         help "" no-label
    bt_can2
         at row 03.50 col 27.86 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 65.72 by 05.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "".
    /* adjust size of objects in this frame */
    assign bt_can2:width-chars  in frame f_dlg_02_wait_processing = 10.00
           bt_can2:height-chars in frame f_dlg_02_wait_processing = 01.00
           rt_001:width-chars   in frame f_dlg_02_wait_processing = 62.43
           rt_001:height-chars  in frame f_dlg_02_wait_processing = 01.92.
    /* set return-inserted = yes for editors */
    assign ed_1x40:return-inserted in frame f_dlg_02_wait_processing = yes.
    /* set private-data for the help system */
    assign ed_1x40:private-data in frame f_dlg_02_wait_processing = "HLP=000000000":U
           bt_can2:private-data in frame f_dlg_02_wait_processing = "HLP=000011451":U
           frame f_dlg_02_wait_processing:private-data            = "HLP=000000000".



{include/i_fclfrm.i f_bas_10_demonst_ctbl_fin f_dlg_01_demonst_ctbl_legenda f_dlg_02_wait_processing }
/*************************** Frame Definition End ***************************/
&if '{&emsbas_version}' >= '5.06' &then
ON WINDOW-MAXIMIZED OF wh_w_program
DO:
def var v_whd_widget as widget-handle no-undo.
assign frame f_bas_10_demonst_ctbl_fin:width-chars  = wh_w_program:width-chars
       frame f_bas_10_demonst_ctbl_fin:height-chars = wh_w_program:height-chars no-error.

for each tt_maximizacao:
    assign v_whd_widget = tt_maximizacao.hdl-widget.

    if tt_maximizacao.log-posiciona-row = yes then do:
        assign v_whd_widget:row = wh_w_program:height - (tt_maximizacao.window-height-original - tt_maximizacao.row-original).
    end.
    if tt_maximizacao.log-calcula-width = yes then do:
        assign v_whd_widget:width = wh_w_program:width - ( tt_maximizacao.window-width-original - tt_maximizacao.width-original ).
    end.
    if tt_maximizacao.log-calcula-height = yes then do:
        assign v_whd_widget:height = wh_w_program:height - ( tt_maximizacao.window-height-original - tt_maximizacao.height-original ).
    end.
    if tt_maximizacao.log-posiciona-col = yes then do:
        assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
    end.
    if tt_maximizacao.tipo-widget = 'button'
    and tt_maximizacao.log-button-right = yes then do:
        assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
    end.
end.

end. /* ON WINDOW-MAXIMIZED OF wh_w_program */
&endif
&if '{&emsbas_version}' >= '5.06' &then
ON WINDOW-RESTORED OF wh_w_program
DO:
def var v_whd_widget as widget-handle no-undo.

for each tt_maximizacao:
    assign v_whd_widget = tt_maximizacao.hdl-widget.

    if can-query(v_whd_widget,'row') then
        assign v_whd_widget:row    = tt_maximizacao.row-original    no-error.

    if can-query(v_whd_widget,'col') then
        assign v_whd_widget:col    = tt_maximizacao.col-original    no-error.

    if can-query(v_whd_widget,'width') then
        assign v_whd_widget:width  = tt_maximizacao.width-original  no-error.

    if can-query(v_whd_widget,'height') then
        assign v_whd_widget:height = tt_maximizacao.height-original no-error.
end.

end. /* ON WINDOW-RESTORED OF wh_w_program */
&endif

/*********************** User Interface Trigger Begin ***********************/


ON ROW-DISPLAY OF br_demonst_ctbl_fin IN FRAME f_bas_10_demonst_ctbl_fin
DO:

run pi_row_display /*pi_row_display*/.

END. /* ON ROW-DISPLAY OF br_demonst_ctbl_fin IN FRAME f_bas_10_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.

    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_1 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.

    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_2 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.

END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_3 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_4 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_5 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_6 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin
DO:

     /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_7 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_8 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.

END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_9 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_10 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_11 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_12 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_13 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_14 IN BROWSE br_demonst_ctbl_fin */

ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON ANY-PRINTABLE OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin */

ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin
DO:

    /* N∆o permite editar coluna*/
    return no-apply.
END. /* ON DEL OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin */

ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin
DO:

    /* Posiciona coluna selecionada*/
    find tt_item_demonst_ctbl_video
         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
         no-lock no-error.
    /* Posiciona item do demonstrativo*/
    find first tt_item_demonst_ctbl_cadastro no-lock
         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
         no-error.
    assign v_cod_campo = self:name.
END. /* ON ENTRY OF tt_demonst_ctbl_fin.ttv_cod_campo_15 IN BROWSE br_demonst_ctbl_fin */

ON CHOOSE OF bt_atz IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /************************* Variable Definition Begin ************************/

    def var v_des_erro_aux
        as character
        format "x(200)":U
        label "Erro RPC AUX"
        column-label "Erro"
        no-undo.
    def var v_des_erro_rpc
        as character
        format "x(200)":U
        label "Erro RPC"
        column-label "Erro RPC"
        no-undo.
    def var v_log_answer
        as logical
        format "Sim/N∆o"
        initial yes
        view-as toggle-box
        no-undo.
    def var v_log_rpc
        as logical
        format "Sim/N∆o"
        initial no
        label "RPC"
        column-label "RPC"
        no-undo.
    def var v_wgh_servid_rpc
        as widget-handle
        format ">>>>>>9":U
        label "Handle RPC"
        column-label "Handle RPC"
        no-undo.
    def var v_cod_ccusto                     as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    run pi_wait_processing (Input "Aguarde, em processamento..." /*l_aguarde_em_processamento*/ ,
                            Input "Aguarde, em processamento..." /*l_aguarde_em_processamento*/ ).



    assign v_log_compos_msg_varios = no.                        

    disable bt_can2 with frame f_dlg_02_wait_processing.

    run pi_vld_demons_ctbl /*pi_vld_demons_ctbl*/.
    if  return-value = "NOK" /*l_nok*/  then do:
        hide frame f_dlg_02_wait_processing.
        return no-apply.
    end.

    run pi_bt_atz_demonst /*pi_bt_atz_demonst*/.

    hide frame f_dlg_02_wait_processing.

    /* * Mensagem de alerta com a lista dos estabelecimentos sem acesso permitido
        ao usu†rio corrente, ou seja, desconsiderados no processamento do demonst **/
    if  v_des_lista_estab <> "" then do:
        /* Restriá∆o de Estabelecimentos ao Usu†rio na Contabilidade ! */
        run pi_messages (input "show",
                         input 11339,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           v_cod_usuar_corren, v_des_lista_estab)) /*msg_11339*/.
    end.

    if avail tt_demonst_ctbl_fin then
        enable bt_grf_barra
               bt_grf_pizza
               with frame f_bas_10_demonst_ctbl_fin.
END. /* ON CHOOSE OF bt_atz IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_config_rpc IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_configur_rpc
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    run prgtec/btb/btb924za.p persistent set v_wgh_configur_rpc /*prg_fnc_prog_dtsul_rpc*/.

    run pi_fnc_prog_dtsul_rpc_programa in v_wgh_configur_rpc (Input "api_demonst_ctbl_video":U) /*pi_fnc_prog_dtsul_rpc_programa*/.

    run pi_fnc_prog_dtsul_rpc_refresh in v_wgh_configur_rpc /*pi_fnc_prog_dtsul_rpc_refresh*/.
END. /* ON CHOOSE OF bt_config_rpc IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_exi IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    run pi_close_program /*pi_close_program*/.
END. /* ON CHOOSE OF bt_exi IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_fil2 IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    run pi_choose_bt_fil2 /*pi_choose_bt_fil2*/.

    disable bt_grf_barra
            bt_grf_pizza
            with frame f_bas_10_demonst_ctbl_fin.
END. /* ON CHOOSE OF bt_fil2 IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_fir IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /* *N∆o faz nada caso n∆o tenha valor m†ximo**/
    if v_num_col_max = 0 or v_num_col = 0 then RETURN NO-APPLY.

    ASSIGN v_num_col = 0.
    apply "Entry" /*l_entry*/  to tt_demonst_ctbl_fin.ttv_cod_campo_1 in browse br_demonst_ctbl_fin.
    run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.

END. /* ON CHOOSE OF bt_fir IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_grf_barra IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    assign v_cod_tip_graf = '4' /* 4 - barras ... 2 - pizza*/.
    run pi_gera_tt_grafico (Input tt_demonst_ctbl_fin.ttv_num_nivel) /*pi_gera_tt_grafico*/.
END. /* ON CHOOSE OF bt_grf_barra IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_grf_pizza IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    assign v_cod_tip_graf = '2'. /* 4 - barras ... 2 - pizza*/.
    run pi_gera_tt_grafico (Input tt_demonst_ctbl_fin.ttv_num_nivel) /*pi_gera_tt_grafico*/.
END. /* ON CHOOSE OF bt_grf_pizza IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_demonst_ctbl_fin
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_las IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /************************* Variable Definition Begin ************************/

    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* *N∆o faz nada caso n∆o tenha valor m†ximo**/
    IF v_num_col_max = 0 or v_num_col_max < 15 THEN RETURN NO-APPLY.

    /* *Posiciona no ultimo valor v†lido para rolagem**/
    if  v_num_col_max >= 15
    then do:
        /* 5 colunas => 5 ... mantÇm £lt. col => 4 */
        DO v_num_cont = 1 TO (v_num_col_max + 14) BY 15:
           IF (v_num_cont - 1) >= v_num_col_max THEN
              ASSIGN v_num_col = (v_num_cont - 15).
        END.
    end /* if */.
    ELSE ASSIGN v_num_col = 0.
    apply "Entry" /*l_entry*/  to tt_demonst_ctbl_fin.ttv_cod_campo_1 in browse br_demonst_ctbl_fin.
    run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.
END. /* ON CHOOSE OF bt_las IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_legenda IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    view frame f_dlg_01_demonst_ctbl_legenda.
    assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:label in browse br_demonst_ctbl_legenda = getStrTrans("Informaá∆o", "MGL") /*l_informaá∆o*/ .
    enable bt_ok 
           bt_hel2 with frame f_dlg_01_demonst_ctbl_legenda.
    assign bt_can:visible in frame f_dlg_01_demonst_ctbl_legenda = no.

    if  not can-find(first tt_demonst_ctbl_legenda) then do:
        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Conta Cont†bil" /*l_conta_contabil*/ .

        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Centro de Custo" /*l_centro_de_custo*/ .

        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Estabelecimento" /*l_estabelecimento*/ .

        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Unidade Neg¢cio" /*l_unidade_negocio*/ .

        &IF DEFINED(BF_ADM_FIN_PROJ) &THEN 
        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Projeto" /*l_projeto*/ .
        &ENDIF

        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "UO Origem" /*l_uo_origem*/ .

        create tt_demonst_ctbl_legenda.
        assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst = "Linha T°tulo" /*l_linha_titulo*/ .
    end.

    open query qr_demonst_ctbl_legenda 
         for each tt_demonst_ctbl_legenda.

    wait-for choose of bt_ok in frame f_dlg_01_demonst_ctbl_legenda.

    hide frame f_dlg_01_demonst_ctbl_legenda.
END. /* ON CHOOSE OF bt_legenda IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_nex1 IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /* *N∆o faz nada caso n∆o tenha valor m†ximo**/
    if v_num_col_max = 0 then RETURN NO-APPLY.

    if  (v_num_col + 14) >= v_num_col_max
    then do:
        message getStrTrans("Èltima ocorrància da tabela.", "MGL") /*l_last*/ 
               view-as alert-box warning buttons ok.
        RETURN NO-APPLY.
    end /* if */.

    /* *No Bot∆o propriedades dever† ser definido padr∆o para rolagem de colunas
    Ex: Combo-box com os itens => "5 colunas" (5) -  "MantÇm £lt.coluna" (4) **/
    ASSIGN v_num_col = v_num_col + 14.
    apply "Entry" /*l_entry*/  to tt_demonst_ctbl_fin.ttv_cod_campo_1 in browse br_demonst_ctbl_fin.
    run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.
END. /* ON CHOOSE OF bt_nex1 IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_pre1 IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    /* *N∆o faz nada caso n∆o tenha valor m†ximo**/
    if v_num_col_max = 0 then RETURN NO-APPLY.

    if  (v_num_col - 14) < 0
    then do:
        message getStrTrans("Primeira ocorrància da tabela.", "MGL") /*l_first*/ 
               view-as alert-box warning buttons ok.
        RETURN NO-APPLY.
    end /* if */.

    /* *No Bot∆o propriedades dever† ser definido padr∆o para rolagem de colunas
     Ex: Combo-box com os itens => "5 colunas" (5) -  "MantÇm £lt.coluna" (4) **/
    ASSIGN v_num_col = v_num_col - 14.
    apply "Entry" /*l_entry*/  to tt_demonst_ctbl_fin.ttv_cod_campo_1 in browse br_demonst_ctbl_fin.
    run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.
END. /* ON CHOOSE OF bt_pre1 IN FRAME f_bas_10_demonst_ctbl_fin */

ON CHOOSE OF bt_pri IN FRAME f_bas_10_demonst_ctbl_fin
DO:

    run pi_vld_demons_ctbl /*pi_vld_demons_ctbl*/.
        if  return-value = "NOK" /*l_nok*/   then 
            return no-apply.

        If session:set-wait-state("General" /*l_general*/ ) then.

        run pi_cria_tt_impressao_demonst (Input v_num_col_max) /*pi_cria_tt_impressao_demonst*/.

        If session:set-wait-state ("") then.

        /* * Executa RelatΩrio Demonstrativo de V≠deo **/
        if  search("prgfin/mgl/mgl304ab.r") = ? and search("prgfin/mgl/mgl304ab.py") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl304ab.py".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl304ab.py"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/mgl/mgl304ab.py /*prg_rpt_demonst_ctbl_video*/.

        EMPTY TEMP-TABLE tt_demonst_ctbl_video.

        run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.
END. /* ON CHOOSE OF bt_pri IN FRAME f_bas_10_demonst_ctbl_fin */

ON ROW-DISPLAY OF br_demonst_ctbl_legenda IN FRAME f_dlg_01_demonst_ctbl_legenda
DO:

    case tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:
        when "Conta Cont†bil" /*l_conta_contabil*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 0.
        when "Centro de Custo" /*l_centro_de_custo*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 14.
        when "Estabelecimento" /*l_estabelecimento*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 1.
        when "Unidade Neg¢cio" /*l_unidade_negocio*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 11.
        when "Projeto" /*l_projeto*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 0.
        when "UO Origem" /*l_uo_origem*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 9.
        when "Linha T°tulo" /*l_linha_titulo*/  then
           assign tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:bgcolor in browse br_demonst_ctbl_legenda = 15
                  tt_demonst_ctbl_legenda.ttv_cod_legenda_demonst:fgcolor in browse br_demonst_ctbl_legenda = 0.
    end.

END. /* ON ROW-DISPLAY OF br_demonst_ctbl_legenda IN FRAME f_dlg_01_demonst_ctbl_legenda */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_demonst_ctbl_legenda
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_demonst_ctbl_legenda */

ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_wait_processing
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_prog_dtsul
        as character
        format "x(50)":U
        label "Programa"
        column-label "Programa"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_prog_dtsul = program-name(1).

    if  index(v_cod_prog_dtsul, 'men903za') <> 0
    then do:
        run pi_messages (input 'show',
                         input 4289,
                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.

    if  index(v_cod_prog_dtsul, 'men903za') = 0
    then do:
        hide frame f_dlg_02_wait_processing.
        stop.
    end /* if */.

END. /* ON CHOOSE OF bt_can2 IN FRAME f_dlg_02_wait_processing */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON CHOOSE OF FRAME f_bas_10_demonst_ctbl_fin
DO:

    if  search("prgfin/mgl/escg0204zb.r") = ? and search("prgfin/mgl/escg0204zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/escg0204zb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/escg0204zb.p"
                   view-as alert-box error buttons ok.
            stop.
        end.
    end.
    else
        run prgfin/mgl/escg0204zb.p /*prg_fnc_prefer_demonst_ctbl*/.

    /* * Localiza os ParÉmetros definidos pelo Usu†rio para Consulta do Demonstrativo **/
    FOR EACH b_prefer_demonst_ctbl NO-LOCK
        WHERE b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
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

    /* --- Posiciona no Padr∆o de Colunas definido nos parÉmetros ---*/
    find padr_col_demonst_ctbl
        where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
        no-lock no-error.
END. /* ON CHOOSE OF FRAME f_bas_10_demonst_ctbl_fin */

ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_demonst_ctbl_fin
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* * Evita erro progress 4052 **/
    IF self:type = 'BROWSE-COLUMN':U THEN
       return no-apply.


    /* Begin_Include: i_right_mouse_down_window */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_nom_title_aux       = current-window:title
               current-window:title  = self:help.
    end /* if */.

    /* End_Include: i_right_mouse_down_window */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_demonst_ctbl_fin */

ON ENDKEY OF FRAME f_bas_10_demonst_ctbl_fin
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(demonst_ctbl).    
        run value(v_nom_prog_upc) (input 'CANCEL',
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    if  v_nom_prog_appc <> '' then
    do:
        assign v_rec_table_epc = recid(demonst_ctbl).    
        run value(v_nom_prog_appc) (input 'CANCEL',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' then
    do:
        assign v_rec_table_epc = recid(demonst_ctbl).    
        run value(v_nom_prog_dpc) (input 'CANCEL',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.
    &endif
    &endif
    /* End_Include: i_exec_program_epc */

END. /* ON ENDKEY OF FRAME f_bas_10_demonst_ctbl_fin */

ON END-ERROR OF FRAME f_bas_10_demonst_ctbl_fin
DO:

    run pi_close_program /*pi_close_program*/.
END. /* ON END-ERROR OF FRAME f_bas_10_demonst_ctbl_fin */

ON HELP OF FRAME f_bas_10_demonst_ctbl_fin ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_bas_10_demonst_ctbl_fin */

ON RIGHT-MOUSE-UP OF FRAME f_bas_10_demonst_ctbl_fin ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_window */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign current-window:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_window */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_bas_10_demonst_ctbl_fin */

ON HELP OF FRAME f_dlg_01_demonst_ctbl_legenda ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_demonst_ctbl_legenda */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_demonst_ctbl_legenda ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_demonst_ctbl_legenda */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_demonst_ctbl_legenda ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_demonst_ctbl_legenda */

ON WINDOW-CLOSE OF FRAME f_dlg_01_demonst_ctbl_legenda
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_demonst_ctbl_legenda */

ON HELP OF FRAME f_dlg_02_wait_processing ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_02_wait_processing */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_wait_processing ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_02_wait_processing */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_wait_processing ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_02_wait_processing */

ON WINDOW-CLOSE OF FRAME f_dlg_02_wait_processing
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_02_wait_processing */


/***************************** Frame Trigger End ****************************/

/*************************** Window Trigger Begin ***************************/

IF session:window-system <> "TTY" THEN
DO:

ON ENTRY OF wh_w_program
DO:
&if '{&emsbas_version}' >= '5.06' &then
    def var v_whd_field_group   as widget-handle no-undo.
    def var v_whd_widget        as widget-handle no-undo.
    def buffer b_tt_maximizacao for tt_maximizacao.
    find first tt_maximizacao no-error.
    if not avail tt_maximizacao then do:
        assign v_whd_field_group = frame f_bas_10_demonst_ctbl_fin:first-child.
        repeat while valid-handle(v_whd_field_group):
            assign v_whd_widget = v_whd_field_group:first-child.
            repeat while valid-handle(v_whd_widget):
                create tt_maximizacao.
                if can-query(v_whd_widget,'handle') then
                    assign tt_maximizacao.hdl-widget            = v_whd_widget:handle no-error.
                if can-query(v_whd_widget,'type') then
                    assign tt_maximizacao.tipo-widget           = v_whd_widget:type no-error.
                if can-query(v_whd_widget,'row') then
                    assign tt_maximizacao.row-original          = v_whd_widget:row no-error.
                if can-query(v_whd_widget,'col') then
                    assign tt_maximizacao.col-original          = v_whd_widget:col no-error.
                if can-query(v_whd_widget,'width') then
                    assign tt_maximizacao.width-original        = v_whd_widget:width no-error.
                if can-query(v_whd_widget,'height') then
                    assign tt_maximizacao.height-original       = v_whd_widget:height no-error.
                assign tt_maximizacao.frame-width-original   = frame f_bas_10_demonst_ctbl_fin:width.
                assign tt_maximizacao.frame-height-original  = frame f_bas_10_demonst_ctbl_fin:height.
                assign tt_maximizacao.window-width-original  = wh_w_program:width.
                assign tt_maximizacao.window-height-original = wh_w_program:height.
                assign tt_maximizacao.log-posiciona-row  = no.
                assign tt_maximizacao.log-posiciona-col  = no.
                assign tt_maximizacao.log-calcula-width  = no.
                assign tt_maximizacao.log-calcula-height = no.
                assign tt_maximizacao.log-button-right   = no.
                if can-query(v_whd_widget,'flat-button') then do:
                    if v_whd_widget:flat-button = yes then do:
                        assign tt_maximizacao.log-posiciona-col  = no.
                        if v_whd_widget:name = 'bt_exi' or
                           v_whd_widget:name = 'bt_hel1' then do:
                            assign tt_maximizacao.log-button-right   = yes.
                        end.
                    end.
                end.
                if can-query(v_whd_widget,'type') then do:
                    if v_whd_widget:type = 'browse' then 
                        assign tt_maximizacao.log-calcula-height = yes.
                end.
                assign v_whd_widget = v_whd_widget:next-sibling.
            end.
            assign v_whd_field_group = v_whd_field_group:next-sibling.
        end.
    end.
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'browse'
          by tt_maximizacao.row-original:
        find first b_tt_maximizacao
             where b_tt_maximizacao.tipo-widget = 'browse'
               and b_tt_maximizacao.hdl-widget = tt_maximizacao.hdl-widget
            no-error.
        if avail b_tt_maximizacao then do:
            leave.
        end.
    end.
    if avail b_tt_maximizacao then do:
        for each tt_maximizacao
            where tt_maximizacao.row-original >=  b_tt_maximizacao.row-original + 
                                                  b_tt_maximizacao.height-original - 1:
            assign tt_maximizacao.log-calcula-height = no.
            assign tt_maximizacao.log-posiciona-row  = yes.
            assign tt_maximizacao.log-posiciona-col  = no.
        end.
    end.
    for each b_tt_maximizacao
        where b_tt_maximizacao.tipo-widget = 'browse':
        assign b_tt_maximizacao.log-calcula-width = yes.
        for each tt_maximizacao
            where tt_maximizacao.row-original + tt_maximizacao.height-original >= 
                  b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.tipo-widget = 'rectangle'
              and b_tt_maximizacao.log-calcula-height = yes:
            assign tt_maximizacao.log-calcula-height = yes.
        end.
        for each tt_maximizacao
           where tt_maximizacao.tipo-widget <> 'browse'
             and not (    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                      and tt_maximizacao.row-original + tt_maximizacao.height-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original
                      and tt_maximizacao.col-original >= b_tt_maximizacao.col-original
                      and tt_maximizacao.col-original + tt_maximizacao.width-original < b_tt_maximizacao.col-original + b_tt_maximizacao.width-original )
             and ((    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original - 0.5 )
              or (     tt_maximizacao.row-original < b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original + tt_maximizacao.height-original > b_tt_maximizacao.row-original )):
            assign tt_maximizacao.log-posiciona-col = yes.
        end.
    end. 
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'rectangle':
        if tt_maximizacao.frame-width-original - tt_maximizacao.width-original < 4 then do:
            assign tt_maximizacao.log-posiciona-col  = no.
            assign tt_maximizacao.log-calcula-width  = yes.
        end.
    end.
    assign wh_w_program:max-width-chars = 300 
           wh_w_program:max-height-chars = 300.

&endif

    if  valid-handle (wh_w_program)
    then do:
        assign current-window = wh_w_program:handle.
    end /* if */.
END. /* ON ENTRY OF wh_w_program */

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_demonst_ctbl_fin.

END. /* ON WINDOW-CLOSE OF wh_w_program */

END.

/**************************** Window Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10
DO:

    apply "choose" to bt_exi in frame f_bas_10_demonst_ctbl_fin.

END. /* ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10 */

ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10
DO:

    apply "choose" to bt_hel1 in frame f_bas_10_demonst_ctbl_fin.

END. /* ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10 */

ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_about_call */
    assign v_nom_prog     = substring(current-window:title, 1, max(1, length(current-window:title) - 10))
                          + chr(10)
                          + "bas_demonst_ctbl_fin":U
           v_nom_prog_ext = "prgfin/mgl/escg0204.p":U
           v_cod_release  = trim(" 5.12.16.107":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
    /* End_Include: i_about_call */

END. /* ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10 */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i bas_demonst_ctbl_fin}


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
    run pi_version_extract ('bas_demonst_ctbl_fin':U, 'prgfin/mgl/escg0204.p':U, '2.12.16.100':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'bas_demonst_ctbl_fin') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_demonst_ctbl_fin')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_demonst_ctbl_fin')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'bas_demonst_ctbl_fin' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'bas_demonst_ctbl_fin'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "bas_demonst_ctbl_fin":U
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


assign v_wgh_frame_epc = frame f_bas_10_demonst_ctbl_fin:handle.



assign v_nom_table_epc = 'demonst_ctbl':U
       v_rec_table_epc = recid(demonst_ctbl).

&endif

/* End_Include: i_verify_program_epc */



/* Begin_Include: ix_p00_bas_demonst_ctbl_fin */
def var p_cod_empres_usuar  as character  no-undo.

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



/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emscad.histor_exec_especial NO-LOCK
         WHERE emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND emscad.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
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

assign v_log_orcto_cta_sint = &IF DEFINED (BF_FIN_ORCTO_CTA_SINT_BGC) &THEN YES 
                              &ELSE GetDefinedFunction('SPP_ORCTO_CTA_SINT_BGC':U) &ENDIF.

assign v_log_nova_con_sdo_empenh = &IF DEFINED (BF_FIN_RASTREAB_EMPENH) &THEN YES 
                                   &ELSE GetDefinedFunction('SPP_RASTREAB_EMPENH':U) &ENDIF.

/* 218397 -  FUNÄ«O EXCLUSIVA P/ A 'Frangosul ' - POSSUI MAI DE UMA COLUNA T÷TULO*/
assign v_log_tit_demonst = &IF DEFINED (BF_FIN_TIT_DEMONST) &THEN YES 
                           &ELSE GetDefinedFunction('SPP_TIT_DEMONST':U) &ENDIF.


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


&glob frame_aux f_bas_10_demonst_ctbl_fin

/* Begin_Include: i_exec_define_rpc */
FUNCTION rpc_exec         RETURNS logical   (input p_cod_program as character) in v_wgh_servid_rpc.
FUNCTION rpc_server       RETURNS handle    (input p_cod_program as character) in v_wgh_servid_rpc.
FUNCTION rpc_program      RETURNS character (input p_cod_program as character) in v_wgh_servid_rpc.
FUNCTION rpc_tip_exec     RETURNS logical   (input p_cod_program as character) in v_wgh_servid_rpc.
FUNCTION rpc_exec_set     RETURNS logical   (input p_cod_program as character, 
                                             input p_log_value as logical)     in v_wgh_servid_rpc.

/* End_Include: i_exec_define_rpc */

find first  param_geral_bgc no-lock no-error.

/* Begin_Include: i_verifica_log_orcamento */

    assign v_log_exec_orctaria = no.

    &if '{&emsfin_version}' >= '5.05' &then
        &if defined(BF_FIN_EXEC_ORCTARIA) &then
            assign v_log_exec_orctaria = yes.
        &else
            if  can-find(first emscad.histor_exec_especial 
               where emscad.histor_exec_especial.cod_prog_dtsul = 'spp_exec_orctaria')
            then do:
                assign v_log_exec_orctaria = yes.
            end /* if */.
        &endif
    &endif

    if  v_log_exec_orctaria
    then do:


        find first param_utiliz_produt no-lock
            where param_utiliz_produt.cod_empresa = v_cod_empres_usuar
              and param_utiliz_produt.cod_modul_dtsul = "BGC" /*l_bgc*/  no-error.
        if  avail param_utiliz_produt
        then do:
            assign v_log_exec_orctaria = yes.
        end /* if */.
        else do:
            assign v_log_exec_orctaria = no.

        end /* if */.
    end /* if */.


    &if '{&emsfin_version}' >= '5.05' &then
        if  v_log_exec_orctaria then do:
            find last param_geral_bgc no-lock no-error.
            if  not avail param_geral_bgc then
                assign v_log_exec_orctaria  = NO.
            else
                if  not param_geral_bgc.log_efetua_exec_orctaria then
                    assign v_log_exec_orctaria  = NO.
        end.
    &endif  


/* End_Include: i_verifica_log_orcamento */


ON WINdoW-maximized of wh_w_program
do:
    run pi_ix_p00_bas_demonst_ctbl_fin (Input 1) /*pi_ix_p00_bas_demonst_ctbl_fin*/.
END.
ON WINdoW-restored of wh_w_program
do:
    run pi_ix_p00_bas_demonst_ctbl_fin (Input 2) /*pi_ix_p00_bas_demonst_ctbl_fin*/.
END.

run pi_redimensiona_colunas /*pi_redimensiona_colunas*/.

if  search("prgfin/fgl/fgl814aa.r") = ? and search("prgfin/fgl/fgl814aa.p") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl814aa.p".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl814aa.p"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/fgl/fgl814aa.p /*prg_spp_col_demonst_ctbl_alt_tip_consolid*/.
if return-value = "NOK" /*l_nok*/  then
    return.

if  search("prgfin/mgl/mgl400aa.r") = ? and search("prgfin/mgl/mgl400aa.p") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl400aa.p".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl400aa.p"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/mgl/mgl400aa.p /*prg_spp_col_demonst_ctbl_alter_nom*/.
if return-value = "NOK" /*l_nok*/  then
    return.

if  search("prgfin/bgc/bgc802aa.r") = ? and search("prgfin/bgc/bgc802aa.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bgc/bgc802aa.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/bgc/bgc802aa.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/bgc/bgc802aa.py /*prg_spp_sdo_ctbl_apartir_empenho*/.

if  search("prgfin/mgl/escg0204ab.r") = ? and search("prgfin/mgl/escg0204ab.p") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/escg0204ab.p".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/escg0204ab.p"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/mgl/escg0204ab.p /*prg_spp_demonst_ctbl_acerto*/.

/* Decimais Chile */
assign v_log_funcao_tratam_dec = GetDefinedFunction('SPP_TRAT_CASAS_DEC':U).

if not valid-handle(v_hdl_func_padr_glob) then run prgint/utb/utb925za.py persistent set v_hdl_func_padr_glob no-error.

function FnAjustDec     returns dec (p_val_movto as decimal, p_cod_moed_finalid as character) in v_hdl_func_padr_glob.
/* End_Include: i_verifica_log_orcamento */

/* redefiniá‰es do menu */
assign sub-menu  mi_table:label in menu m_10 = "Arquivo" /*l_file*/ .

/* redefiniá‰es da window e frame */

/* Begin_Include: i_std_window */
/* tratamento do t°tulo, menu, vers∆o e dimens‰es */
assign wh_w_program:title         = frame f_bas_10_demonst_ctbl_fin:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.12.16.107":U)
                                  + chr(41)
       frame f_bas_10_demonst_ctbl_fin:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_demonst_ctbl_fin:width-chars
       wh_w_program:height-chars  = frame f_bas_10_demonst_ctbl_fin:height-chars - 0.85
       frame f_bas_10_demonst_ctbl_fin:row         = 1
       frame f_bas_10_demonst_ctbl_fin:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

find first modul_dtsul
    where modul_dtsul.cod_modul_dtsul = v_cod_modul_dtsul_corren
    no-lock no-error.
if  avail modul_dtsul
then do:
    if  wh_w_program:load-icon (modul_dtsul.img_icone) = yes
    then do:
        /* Utiliza como °cone sempre o °cone do m¢dulo corrente */
    end /* if */.
end /* if */.

/* End_Include: i_std_window */
{include/title5.i wh_w_program}


run pi_frame_settings (Input frame f_bas_10_demonst_ctbl_fin:handle) /*pi_frame_settings*/.


/* Begin_Include: ix_p02_bas_demonst_ctbl_fin */

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


def var m_1 as handle no-undo.
def var m_2 as handle no-undo.
def var m_3 as handle no-undo.
def var m_4 as handle no-undo.
def var m_5 as handle no-undo.
def var m_6 as handle no-undo.
def var m_7 as handle no-undo.
def var m_9 as handle no-undo.
def var m_10 as handle no-undo.
def var m_11 as handle no-undo.
def var m_12 as handle no-undo.
def var m_13 as handle no-undo.
def var m_14 as handle no-undo.
def var m_15 as handle no-undo.
def var m_16 as handle no-undo.
def var h_rule as handle no-undo.

assign v_log_nova_con_sdo_empenh = &IF DEFINED (BF_FIN_RASTREAB_EMPENH) &THEN YES 
                                   &ELSE GetDefinedFunction('SPP_RASTREAB_EMPENH':U) &ENDIF
       v_log_funcao_concil_consolid = &IF DEFINED (BF_FIN_CONCIL_CONSOLID) &THEN YES 
                                      &ELSE GetDefinedFunction('SPP_CONCIL_CONSOLID':U) &ENDIF.
assign v_log_funcao_expand_cta_ctbl = GetDefinedFunction('SPP_EXP_CTA_CTBL':U).

define menu m_menu.

assign br_demonst_ctbl_fin:popup-menu in frame f_bas_10_demonst_ctbl_fin = menu m_menu:handle.

run pi_cria_menu (input "Contrai Estrutura" /*l_contrai_estrutura*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 1,
                  input no,
                  input menu m_menu:handle,
                  output m_1).

run pi_cria_menu (input "",
                  input "Rule" /*l_rule_menu*/ ,
                  input 0,
                  input no,
                  input menu m_menu:handle,
                  output h_rule).    

run pi_cria_menu (input "Conta Cont†bil" /*l_conta_contabil*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 2,
                  input no,
                  input menu m_menu:handle,
                  output m_2).

run pi_cria_menu (input "Centro Custo" /*l_centro_custo*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 3,
                  input no,
                  input menu m_menu:handle,
                  output m_3).

run pi_cria_menu (input "Projeto" /*l_projeto*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 4,
                  input no,
                  input menu m_menu:handle,
                  output m_4).

run pi_cria_menu (input "Unidades de Neg¢cio" /*l_unidades_de_negocio*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 5,
                  input no,
                  input menu m_menu:handle,
                  output m_5).

run pi_cria_menu (input "Estabelecimento" /*l_estabelecimento*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 6,
                  input no,
                  input menu m_menu:handle,
                  output m_6).

run pi_cria_menu (input "Unidade Organizacional" /*l_unid_organ*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 7,
                  input no,
                  input menu m_menu:handle,
                  output m_7).            

run pi_cria_menu (input "",
                  input "Rule" /*l_rule_menu*/ ,
                  input 0,
                  input no,
                  input menu m_menu:handle,
                  output h_rule). 

if  v_log_funcao_concil_consolid then do:
    run pi_cria_menu (input "Expande/Contrai Todas as Linhas" /*l_exp/cont_todas_as_linhas*/ ,
                      input "Normal" /*l_normal*/ ,
                      input 15,
                      input yes,
                      input menu m_menu:handle,
                      output m_15).            

    run pi_cria_menu (input "",
                      input "Rule" /*l_rule_menu*/ ,
                      input 0,
                      input no,
                      input menu m_menu:handle,
                      output h_rule).
end.

run pi_cria_menu (input "Razao Cta Ctbl" /*l_razao_cta_ctbl*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 9,
                  input no,
                  input menu m_menu:handle,
                  output m_9).

run pi_cria_menu (input "Raz∆o CCusto" /*l_razao_ccusto*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 10,
                  input no,
                  input menu m_menu:handle,
                  output m_10).



if v_log_nova_con_sdo_empenh then do:
    run pi_cria_menu (input "Origem Empenho" /*l_origem_empenho*/ ,
                      input "Normal" /*l_normal*/ ,
                      input 13,
                      input no,
                      input menu m_menu:handle,
                      output m_13). 


    run pi_cria_menu (input "Justificativa Oráament†ria" /*l_movimentacao_orctaria*/ ,
                      input "Normal" /*l_normal*/ ,
                      input 14,
                      input NO,
                      input menu m_menu:handle,
                      output m_14).
end.

run pi_cria_menu (input "",
                  input "Rule" /*l_rule_menu*/ ,
                  input 0,
                  input no,
                  input menu m_menu:handle,
                  output h_rule). 

run pi_cria_menu (input "Detalhe Cadastro Coluna" /*l_detalhe_coluna*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 11,
                  input no,
                  input menu m_menu:handle,
                  output m_11).

run pi_cria_menu (input "Detalhe Consulta Item" /*l_detalhe_item*/ ,
                  input "Normal" /*l_normal*/ ,
                  input 12,
                  input no,
                  input menu m_menu:handle,
                  output m_12).

if v_log_funcao_expand_cta_ctbl then do:
    run pi_cria_menu (input "",
                      input "Rule" /*l_rule_menu*/ ,
                      input 0,
                      input no,
                      input menu m_menu:handle,
                      output h_rule). 

    run pi_cria_menu (input "Expande Todas Contas Contabeis" /*l_exp_todas_cta_ctbl*/ ,
                      input "Normal" /*l_normal*/ ,
                      input 16,
                      input no,
                      input menu m_menu:handle,
                      output m_16).
end.               
ON RIGHT-MOUSE-DOWN OF br_demonst_ctbl_fin IN FRAME f_bas_10_demonst_ctbl_fin ANYWHERE
DO:
    run pi_habilita_itens_expansao /*pi_habilita_itens_expansao*/.

    if  v_log_funcao_concil_consolid then
        assign v_log_expand_lin = M_15:CHECKED.
END.

/* End_Include: i_declara_SetEntryField */


pause 0 before-hide.

view frame f_bas_10_demonst_ctbl_fin.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_upc) (input 'INITIALIZE',
                               input 'viewer',
                               input this-procedure,
                               input v_wgh_frame_epc,
                               input v_nom_table_epc,
                               input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

if  v_nom_prog_appc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_appc) (input 'INITIALIZE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

&if '{&emsbas_version}' > '5.00' &then
if  v_nom_prog_dpc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_dpc) (input 'INITIALIZE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.
&endif
&endif
/* End_Include: i_exec_program_epc */



/* Begin_Include: ix_p05_bas_demonst_ctbl_fin */
run pi_ix_p05_bas_demonst_ctbl_fin.

/* End_Include: ix_p05_bas_demonst_ctbl_fin */

enable bt_exi
       bt_hel1
       bt_legenda
       with frame f_bas_10_demonst_ctbl_fin.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_upc) (input 'ENABLE',
                               input 'viewer',
                               input this-procedure,
                               input v_wgh_frame_epc,
                               input v_nom_table_epc,
                               input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

if  v_nom_prog_appc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_appc) (input 'ENABLE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

&if '{&emsbas_version}' > '5.00' &then
if  v_nom_prog_dpc <> '' then
do:
    assign v_rec_table_epc = recid(demonst_ctbl).    
    run value(v_nom_prog_dpc) (input 'ENABLE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.
&endif
&endif
/* End_Include: i_exec_program_epc */


{include/i_trdmnu.i wh_w_program:menubar}
main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    /* Begin_Include: ix_p10_bas_demonst_ctbl_fin */
    enable all with frame f_bas_10_demonst_ctbl_fin.
    disable bt_config_rpc with frame f_bas_10_demonst_ctbl_fin.

    /* * Habilita bot‰es de grafico nas consultas **/

    IF  v_ind_selec_demo_ctbl = "Consultas de Saldo" /*l_consultas_de_saldo*/  THEN
        ASSIGN bt_grf_barra:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = YES
               bt_grf_pizza:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = YES.
    ELSE
        ASSIGN bt_grf_barra:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = NO
               bt_grf_pizza:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = NO.

    run pi_open_demonst_ctbl_fin.

    apply "choose" to bt_fil2 in frame f_bas_10_demonst_ctbl_fin.


    /* End_Include: ix_p10_bas_demonst_ctbl_fin */

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_demonst_ctbl_fin.
    end /* if */.
end /* do main_block */.

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



/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_close_program
** Descricao.............: pi_close_program
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: vanei
** Alterado em...........: 14/05/1998 15:13:54
*****************************************************************************/
PROCEDURE pi_close_program:


        if  avail demonst_ctbl
        then do:
            assign v_rec_demonst_ctbl = recid(demonst_ctbl).
        end /* if */.
        else do:
            assign v_rec_demonst_ctbl = ?.
        end /* else */.



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


    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end /* if */.
END PROCEDURE. /* pi_close_program */
/*****************************************************************************
** Procedure Interna.....: pi_frame_settings
** Descricao.............: pi_frame_settings
** Criado por............: Gilsinei
** Criado em.............: 27/10/1995 08:24:12
** Alterado por..........: Gilsinei
** Alterado em...........: 27/10/1995 08:49:51
*****************************************************************************/
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
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
** Procedure Interna.....: pi_open_demonst_ctbl_fin
** Descricao.............: pi_open_demonst_ctbl_fin
** Criado por............: Dalpra
** Criado em.............: 13/02/2001 11:01:25
** Alterado por..........: fut12196
** Alterado em...........: 24/09/2013 14:40:19
*****************************************************************************/
PROCEDURE pi_open_demonst_ctbl_fin:

    /************************* Variable Definition Begin ************************/

    def var v_num_cont_col
        as integer
        format ">>>9":U
        initial 0
        no-undo.
    def var v_num_initial
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    EMPTY TEMP-TABLE tt_valor_demonst_ctbl_total.
    assign v_cod_format  = ""
           v_num_lin_tit = 0
           v_num_cont_1  = 0.

         if v_num_col <> 0 then do:
            /* Verifica se a primeira coluna eh de titulo */
            find first tt_label_demonst_ctbl_video
                 where tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  
                 no-lock no-error.
            if  avail tt_label_demonst_ctbl_video
            and tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = 1 then
                assign v_log_primei_col_title = yes
                       v_cod_format          = tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl + chr(10).
            else 
                assign v_log_primei_col_title = no.
        end.
        else 
            assign v_log_primei_col_title = no.

        if not (PROGRAM-NAME(2) begins 'pi_rpt_demonst_ctbl_video'
            or program-name(3) begins 'pi_rpt_demonst_ctbl_video') then
           run pi_demonst_ctbl_fin_label_coluna /*pi_demonst_ctbl_fin_label_coluna*/.

        /* * Variˇvel utilizada para desvio qdo pi chamada no RelatΩrio **/
        if  avail prefer_demonst_ctbl then
            assign v_log_acum_cta_ctbl_sint = prefer_demonst_ctbl.log_acum_cta_ctbl_sint.

        /* * Carrega variˇvel com as posiªÑes dos t≠tulos nas colunas **/
        assign v_num_cont_col = v_num_col.
        GravaFormato:
        for each  tt_label_demonst_ctbl_video
            where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col :
            if  tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then
                assign v_num_lin_tit = tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl
                       v_num_cont_1 = v_num_cont_1 + 1.

            /* Logica para buscar o formato das 15 colunas que ser∆o apresentadas em tela*/
            ASSIGN v_num_cont_col = v_num_cont_col + 1.
            IF v_num_cont_col >= v_num_col + 16 THEN DO:
                LEAVE GravaFormato.
            END.
            assign v_cod_format = v_cod_format + tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl + chr(10).
        end.

        /* * Acerta entradas do formato para utilizaªío direta na lΩgica do restante do programa **/
        assign v_cod_format = v_cod_format + fill(chr(10),5).

        if v_log_primei_col_title = yes then
            assign v_num_lin_tit         = 1.

        /* * Carrega informaªÑes das linhas apenas uma vez **/
        if  not can-find(first tt_demonst_ctbl_fin) then do:
           run pi_carrega_lin_titulo (Input 0) /*pi_carrega_lin_titulo*/.
        end.

        /* * Remonta os valores das colunas conforme posiªío da coluna atual **/
        for each tt_demonst_ctbl_fin 
            where tt_demonst_ctbl_fin.ttv_log_apres
            USE-INDEX tt_id_descending:

            /* * Carrega os T≠tulos na Coluna Correta Quando Estiver Navegando **/
            if v_log_primei_col_title then do:
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

            /* 218397 - Qdo tiver mais de uma coluna titulo */
            if v_log_tit_demonst and v_num_cont_1 > 1 then do:
                do v_num_cont_2 = 1 to v_num_cont_1:
                    case v_num_cont_2 :
                        when v_num_col + 1 then assign tt_demonst_ctbl_fin.ttv_cod_campo_1 = tt_demonst_ctbl_fin.ttv_des_col_demonst_video.
                        when v_num_col + 2 then assign tt_demonst_ctbl_fin.ttv_cod_campo_2 = tt_item_demonst_ctbl_video.ttv_des_chave_2.
                    end case.
                end.
            end.                                              

            /* * Sai fora do bloco de totalizaªío quando a linha corrente for um t≠tulo **/
            if tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  then
                next.

            /* * Sai fora do bloco de totalizaªío quando a linha corrente for caracter especial **/
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

            /* * Cria valores somente para os n≠veis que nío serío totalizados posteriormente **/
            if can-find(first tt_estrut_visualiz_ctbl_cad 
                 where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = v_cod_demonst_ctbl
                 and   tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                 and   tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz  = tt_demonst_ctbl_fin.ttv_cod_inform_princ
                 and   tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = no) then do:
                if can-find(first btt_demonst_ctbl_fin 
                     where btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(tt_demonst_ctbl_fin)) then do:

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

        assign v_log_expand = NO.

        open query qr_demonst_ctbl_fin for
             each  tt_demonst_ctbl_fin
             where tt_demonst_ctbl_fin.ttv_log_apres.        
END PROCEDURE. /* pi_open_demonst_ctbl_fin */
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
** Procedure Interna.....: pi_demonst_ctbl_fin_label_coluna
** Descricao.............: pi_demonst_ctbl_fin_label_coluna
** Criado por............: Dalpra
** Criado em.............: 10/01/2001 08:48:34
** Alterado por..........: fut1180_2
** Alterado em...........: 27/12/2004 14:54:27
*****************************************************************************/
PROCEDURE pi_demonst_ctbl_fin_label_coluna:

    /************************* Variable Definition Begin ************************/

    def var v_des_sig_indic_econ
        as character
        format "x(06)":U
        label "Sigla"
        column-label "Sigla"
        no-undo.
    def var v_num_contador
        as integer
        format ">>>>,>>9":U
        initial 0
        no-undo.
    def var v_dat_fim_period_col             as date            no-undo. /*local*/
    def var v_num_ano                        as integer         no-undo. /*local*/
    def var v_num_mes                        as integer         no-undo. /*local*/
    def var v_num_period_ano                 as integer         no-undo. /*local*/
    def var v_num_period_mes                 as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if v_log_primei_col_title = no then
        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:label in browse br_demonst_ctbl_fin = "".

        assign tt_demonst_ctbl_fin.ttv_cod_campo_2:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_3:label in browse br_demonst_ctbl_fin = "" 
               tt_demonst_ctbl_fin.ttv_cod_campo_4:label in browse br_demonst_ctbl_fin = "" 
               tt_demonst_ctbl_fin.ttv_cod_campo_5:label in browse br_demonst_ctbl_fin = "" 
               tt_demonst_ctbl_fin.ttv_cod_campo_6:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_7:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_8:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_9:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_10:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_11:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_12:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_13:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_14:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_15:label in browse br_demonst_ctbl_fin = ""

               tt_demonst_ctbl_fin.ttv_cod_campo_1:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_2:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_3:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_4:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_5:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_6:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_7:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_8:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_9:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_10:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_11:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_12:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_13:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_14:visible in browse br_demonst_ctbl_fin = YES
               tt_demonst_ctbl_fin.ttv_cod_campo_15:visible in browse br_demonst_ctbl_fin = YES.

        if v_log_primei_col_title = yes then
            assign v_num_contador = 1.
        else
            assign v_num_contador = 0.

        for each tt_label_demonst_ctbl_video
            where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl > v_num_col :

            assign v_num_contador       = v_num_contador + 1
                   v_des_sig_indic_econ = "".


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


            if prefer_demonst_ctbl.cod_padr_col_demonst <> "" then
                assign v_des_sig_indic_econ = "!" + v_des_sig_indic_econ.

            /* case tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl:*/
            case v_num_contador:
               when 1 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_1:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_1:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_1:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 2 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_2:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_2:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_2:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 3 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_3:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_3:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_3:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 4 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_4:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_4:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_4:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 5 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_5:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_5:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_5:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 6 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_6:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_6:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_6:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 7 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_7:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_7:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_7:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 8 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_8:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_8:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_8:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 9 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_9:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_9:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_9:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 10 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_10:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_10:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_10:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 11 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_11:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_11:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_11:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 12 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_12:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_12:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_12:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 13 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_13:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_13:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_13:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 14 then
                assign tt_demonst_ctbl_fin.ttv_cod_campo_14:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_14:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_14:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
               when 15 then do:
                assign tt_demonst_ctbl_fin.ttv_cod_campo_15:label in browse br_demonst_ctbl_fin       = tt_label_demonst_ctbl_video.ttv_des_label_col_demonst_ctbl + v_des_sig_indic_econ
                       tt_demonst_ctbl_fin.ttv_cod_campo_15:label-font in browse br_demonst_ctbl_fin  = 6
                       tt_demonst_ctbl_fin.ttv_cod_campo_15:width-chars in browse br_demonst_ctbl_fin = tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl + 1.
                LEAVE.
               end.
            end.
        end.

        /* * "ESCONDE" colunas que nío possuem registros informados **/
        if  tt_demonst_ctbl_fin.ttv_cod_campo_15:label in browse br_demonst_ctbl_fin <> ""
            then RETURN.

        if  tt_demonst_ctbl_fin.ttv_cod_campo_1:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_1:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_2:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_2:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_3:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_3:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_4:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_4:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_5:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_5:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_6:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_6:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_7:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_7:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_8:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_8:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_9:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_9:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_10:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_10:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_11:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_11:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_12:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_12:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_13:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_13:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_14:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_14:visible in browse br_demonst_ctbl_fin = NO.
        if  tt_demonst_ctbl_fin.ttv_cod_campo_15:label in browse br_demonst_ctbl_fin = "" then
            assign tt_demonst_ctbl_fin.ttv_cod_campo_15:visible in browse br_demonst_ctbl_fin = NO.



        


END PROCEDURE. /* pi_demonst_ctbl_fin_label_coluna */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new
** Descricao.............: pi_tt_demonst_ctbl_fin_new
** Criado por............: dalpra
** Criado em.............: 05/06/2001 17:11:32
** Alterado por..........: fut12209
** Alterado em...........: 17/12/2007 09:03:09
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_inform
        as character
        format "x(60)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_unid_negoc_pai
        as character
        format "x(3)":U
        label "Un Neg Pai"
        column-label "Un Neg Pai"
        no-undo.
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_unid_organ_pai
        as character
        format "x(3)":U
        label "Unidade Organiz Pai"
        column-label "UO Pai"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_unid_organ_pai
        as Character
        format "x(5)":U
        label "Unidade Organiz Pai"
        column-label "UO Pai"
        no-undo.
    &ENDIF
    def var v_num_count_estrut_visualiz
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_seq_estrut_visualiz
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_seq_orig                   as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    EXPand:
        do ON ERROR UNdo EXPand, LEAVE EXPand:
            /* * Grava recid da tt_demonst atual **/
            assign v_rec_demonst_ctbl_video_aux = tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video
                   v_log_abert_ccusto = no.

            /* * Posiciona no tt_item_cadastro ORIGEM DA COPIA **/
            find tt_item_demonst_ctbl_cadastro
                where tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad
                no-error.
            if  avail tt_item_demonst_ctbl_cadastro then do:

                /* Posiciona na visualizacao do item a ser expandido*/
                assign v_num_count_estrut_visualiz = 0
                       v_num_seq_estrut_visualiz   = 0.
                for each tt_estrut_visualiz_ctbl_cad 
                    where  tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = v_cod_demonst_ctbl
                    and    tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:
                    assign v_num_seq_estrut_visualiz   = tt_estrut_visualiz_ctbl_cad.num_seq_estrut_visualiz
                           v_num_count_estrut_visualiz = v_num_count_estrut_visualiz + 1.
                end.

                /* Posiciona na visualizacao do item a ser expandido*/
                find first tt_estrut_visualiz_ctbl_cad 
                    where  tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = v_cod_demonst_ctbl
                    and    tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                    and    tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz  = tt_demonst_ctbl_fin.ttv_cod_inform_princ
                    no-lock no-error.

                /* Atualiza estrutura Pai */
                if avail tt_estrut_visualiz_ctbl_cad and
                   tt_estrut_visualiz_ctbl_cad.num_seq_estrut_visualiz = v_num_seq_estrut_visualiz then
                    assign tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = yes.

                /* Cria estrutura de visualizacao para a expansao */
                if  avail tt_estrut_visualiz_ctbl_cad
                then do:
                    create btt_estrut_visualiz_ctbl_cad.
                    assign btt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl            = tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl
                           btt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl        = tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl
                           btt_estrut_visualiz_ctbl_cad.num_seq_estrut_visualiz     = v_num_seq_estrut_visualiz + 10
                           btt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz  = p_cod_inform
                           btt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = yes
                           btt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst    = tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst.

                    assign v_cod_lista_compon = btt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz          + ';'
                                              + string(btt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl) + ';'
                                              + string(btt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst)    + ';'.
                end.
                else do:
                    if v_log_funcao_concil_consolid then
                       assign v_cod_lista_compon = ';yes;yes'.
                end.

                /* Passa o registro para o Buffer */
                find btt_item_demonst_ctbl_video
                   where recid(btt_item_demonst_ctbl_video) = recid(tt_item_demonst_ctbl_video)
                   no-error.

                /* * Monta composiªío por extrutura do tt_item_cadastro expandido somente para o mesmo item **/
                case p_cod_inform :
                    when "Conta Cont†bil" /*l_conta_contabil*/  then do:
                        run pi_tt_demonst_ctbl_fin_new_cta (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_cta*/.
                    end.
                    when "Centro de Custo" /*l_centro_de_custo*/  then do:
                        assign v_des_lista_ccusto_sem_segur = "".
                        run pi_tt_demonst_ctbl_fin_new_ccusto (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_ccusto*/.
                        if v_des_lista_ccusto_sem_segur <> "" then do:
                            if  v_log_expand_lin = NO
                            then do:
                                /* Usuario n∆o possui permiss∆o para o Centro de Custo. */
                                run pi_messages (input "show",
                                                 input 12061,
                                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                                   v_des_lista_ccusto_sem_segur)) /*msg_12061*/.
                            end.
                        end.
                    end.
                    when "Projeto" /*l_projeto*/  then do:
                        run pi_tt_demonst_ctbl_fin_new_projeto (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_projeto*/.
                    end.
                    when "Unidade Neg¢cio" /*l_unidade_negocio*/  then do:
                        run pi_tt_demonst_ctbl_fin_new_unid_negoc (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_unid_negoc*/.
                    end.
                    when "UO Origem" /*l_uo_origem*/  then do:
                        run pi_tt_demonst_ctbl_fin_new_unid_organ (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_unid_organ*/.
                    end.
                    when "Estabelecimento" /*l_estabelecimento*/   then do:
                        run pi_tt_demonst_ctbl_fin_new_estabelecimento (Input p_num_espaco) /*pi_tt_demonst_ctbl_fin_new_estabelecimento*/.
                    end.
                end.

                /* Elimina a estrutura de visualizacao criado acima caso nao exista expansao disponivel */
                if v_log_return = no then do:
                    if  avail btt_estrut_visualiz_ctbl_cad then
                        delete btt_estrut_visualiz_ctbl_cad.
                end.
                else do:
                    if p_cod_inform = "Estabelecimento" /*l_estabelecimento*/  then do:
                    /* tt_demonst_ctbl_fin corrente eh o que estah sendo expandindo pela opcao Estabelecimento, 
                      indicador  ttv_log_expand_estab = yes n∆o permite nova expansao por estabelecimento (VER.
                      pi_habilita_itens_expansao), quando expandia n estabelecimentos soh atribuia  ao £ltimo.*/

                        assign tt_demonst_ctbl_fin.ttv_log_expand_estab = yes.
                    end.
                end.
            end.
        end.
END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new */
/*****************************************************************************
** Procedure Interna.....: pi_localiza_niveis_sint
** Descricao.............: pi_localiza_niveis_sint
** Criado por............: bre17752
** Criado em.............: 13/06/2001 14:25:55
** Alterado por..........: src531
** Alterado em...........: 16/08/2002 15:42:21
*****************************************************************************/
PROCEDURE pi_localiza_niveis_sint:

    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_demonst_ctbl_video
        as recid
        format ">>>>>>9"
        no-undo.
    def Input param p_rec_demonst_ctbl_video_aux
        as recid
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* * Posiciona a tt_demonst no n≠vel atual **/
    find first btt_demonst_ctbl_fin
        where recid(btt_demonst_ctbl_fin) = p_rec_demonst_ctbl_video
          and btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = p_rec_demonst_ctbl_video_aux no-error.

    /* * Carrega composiªío com faixas de registros dos n≠veis que compÑem esta
        informaªío ou com as faixas informadas na composiªío do demonstrativo **/

    assign tt_compos_demonst_cadastro.cod_cta_ctbl_inic   = if btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = ''
                                                            then tt_compos_demonst_cadastro.cod_cta_ctbl_inic
                                                            else btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho
           tt_compos_demonst_cadastro.cod_cta_ctbl_fim    = if btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = ''
                                                            then tt_compos_demonst_cadastro.cod_cta_ctbl_fim
                                                            else btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho
           tt_compos_demonst_cadastro.cod_ccusto_inic     = if btt_demonst_ctbl_fin.tta_cod_ccusto_filho = '' then
                                                                if v_log_ccusto_subst then v_cod_ccusto_subst_inic
                                                                else tt_compos_demonst_cadastro.cod_ccusto_inic
                                                            else btt_demonst_ctbl_fin.tta_cod_ccusto_filho                      
           tt_compos_demonst_cadastro.cod_ccusto_fim      = if btt_demonst_ctbl_fin.tta_cod_ccusto_filho = '' then
                                                                if v_log_ccusto_subst then v_cod_ccusto_subst_fim
                                                                else tt_compos_demonst_cadastro.cod_ccusto_fim
                                                            else btt_demonst_ctbl_fin.tta_cod_ccusto_filho
           tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial = if btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = ''
                                                                    then tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial
                                                                    else btt_demonst_ctbl_fin.tta_cod_proj_financ_filho
           tt_compos_demonst_cadastro.cod_proj_financ_fim         = if btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = ''
                                                                    then tt_compos_demonst_cadastro.cod_proj_financ_fim
                                                                    else btt_demonst_ctbl_fin.tta_cod_proj_financ_filho
           tt_compos_demonst_cadastro.cod_unid_negoc_inic = if btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho = '' then
                                                                if v_log_unid_negoc_subst then v_cod_unid_negoc_subst_inic
                                                                else tt_compos_demonst_cadastro.cod_unid_negoc_inic
                                                            else btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
           tt_compos_demonst_cadastro.cod_unid_negoc_fim  = if btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho = '' then
                                                                if v_log_unid_negoc_subst then v_cod_unid_negoc_subst_fim
                                                                else tt_compos_demonst_cadastro.cod_unid_negoc_fim
                                                            else btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
           tt_compos_demonst_cadastro.cod_estab_inic      = if btt_demonst_ctbl_fin.tta_cod_estab = '' then
                                                                if v_log_estab_subst then v_cod_estab_subst_inic
                                                                else tt_compos_demonst_cadastro.cod_estab_inic
                                                            else btt_demonst_ctbl_fin.tta_cod_estab
           tt_compos_demonst_cadastro.cod_estab_fim       = if btt_demonst_ctbl_fin.tta_cod_estab = '' then
                                                                if v_log_estab_subst then v_cod_estab_subst_fim
                                                                else tt_compos_demonst_cadastro.cod_estab_fim
                                                            else btt_demonst_ctbl_fin.tta_cod_estab
           tt_compos_demonst_cadastro.cod_unid_organ      = if btt_demonst_ctbl_fin.tta_cod_unid_organ_filho = '' then
                                                                if v_log_unid_organ_subst then v_cod_unid_organ_sub
                                                                else tt_compos_demonst_cadastro.cod_unid_organ
                                                            else btt_demonst_ctbl_fin.tta_cod_unid_organ_filho
           tt_compos_demonst_cadastro.cod_unid_organ_fim  = if btt_demonst_ctbl_fin.tta_cod_unid_organ_filho = '' then
                                                                if v_log_unid_organ_subst then v_cod_unid_organ_sub
                                                                else tt_compos_demonst_cadastro.cod_unid_organ
                                                            else btt_demonst_ctbl_fin.tta_cod_unid_organ_filho.
END PROCEDURE. /* pi_localiza_niveis_sint */
/*****************************************************************************
** Procedure Interna.....: pi_expand_demonst_fin
** Descricao.............: pi_expand_demonst_fin
** Criado por............: dalpra
** Criado em.............: 05/06/2001 16:59:46
** Alterado por..........: fut12209
** Alterado em...........: 30/01/2008 09:09:17
*****************************************************************************/
PROCEDURE pi_expand_demonst_fin:


    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_item
        as character
        format "x(30)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_estab                      as character       no-undo. /*local*/
    def var v_num_cont_aux                   as integer         no-undo. /*local*/
    def var v_num_seq_initial                as integer         no-undo. /*local*/
    def var v_num_seq_orig                   as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    expand:
        do on error undo expand, return error:

           if not avail tt_item_demonst_ctbl_video then do:
                /* Posiciona item do demonstrativo*/
                find tt_item_demonst_ctbl_video
                     where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                     no-lock no-error.
                find first tt_item_demonst_ctbl_cadastro no-lock
                     where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
                       and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                     no-error.
            end.

            assign v_num_seq_initial                        = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl
                   v_num_seq                                = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                   v_num_seq_orig                           = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                   v_num_count                              = 0
                   v_num_nivel                              = tt_demonst_ctbl_fin.ttv_num_nivel + 1
                   tt_demonst_ctbl_fin.ttv_log_expand       = yes
                   tt_demonst_ctbl_fin.ttv_log_expand_usuar = yes
                   v_cod_estab                              = tt_demonst_ctbl_fin.tta_cod_estab
                   v_rec_demonst_ctbl_video                 = recid(tt_demonst_ctbl_fin)
                   v_log_expand                             = yes.

            /* * L¢gica para reposicionar corretamente item expandido **/
            assign v_num_pos = br_demonst_ctbl_fin:focused-row in frame f_bas_10_demonst_ctbl_fin.
            if  v_num_pos <> ? then
                assign v_log_status = br_demonst_ctbl_fin:set-repositioned-row(v_num_pos, 'conditional') in frame f_bas_10_demonst_ctbl_fin.

            do v_num_cont = 1 to 99:
                if  SUBSTR(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,v_num_cont,1) = " " then
                    assign v_num_cont_aux = v_num_cont_aux + 1.
                    else LEAVE.
            end.

            if p_cod_item = "Centro de Custo" /*l_centro_de_custo*/  then
               if  v_log_unid_organ_varios or  v_log_plano_ccusto_varios then do:
                   if not v_log_compos_msg_varios  then do:
                      /* somente mostrar a mensagem abaixo uma vez */
                      assign v_log_compos_msg_varios = yes.
                      /* Ordenaá∆o dos C¢digos de  Centros de Custo. */
                      run pi_messages (input "show",
                                       input 18960,
                                       input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_18960*/.
                   end.
               end.

            /* * Cria novos itens para expandir a informaªío no demonstrativo **/
            run pi_tt_demonst_ctbl_fin_new (Input v_cod_estab,
                                            Input (v_num_cont_aux + 4) /* espaªo identaªío*/,
                                            Input p_cod_item) /*pi_tt_demonst_ctbl_fin_new*/.

            if  v_log_return = no then do:
                find tt_demonst_ctbl_fin 
                    where recid(tt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video
                    no-error.
                if  avail tt_demonst_ctbl_fin then
                    assign tt_demonst_ctbl_fin.ttv_log_expand       = no
                           tt_demonst_ctbl_fin.ttv_log_expand_usuar = no.
                    if  v_log_expand_lin = NO
                    then do:
                        /* N∆o existem informaá‰es a serem expandidas. */
                        run pi_messages (input "show",
                                         input 11609,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11609*/.
                    end.

                /* Begin_Include: i_entry_browse_demonst_video */
                /* Posiciona coluna selecionada*/
                find tt_item_demonst_ctbl_video
                     where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                     no-lock no-error.
                find first tt_label_demonst_ctbl_video 
                     where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + 1 no-error.
                find first tt_col_demonst_ctbl no-lock
                     where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                     no-error.
                find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.

                /* Posiciona item do demonstrativo*/
                find first tt_item_demonst_ctbl_cadastro no-lock
                     where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
                       and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                     no-error.

                /* * Posiciona no item correto para pesquisa do detalhe **/
                find first item_demonst_ctbl of tt_item_demonst_ctbl_cadastro no-lock no-error.

                /* * LΩgica para localizar item nos n≠veis acima qdo nío encontrado nos n≠veis expandidos e nío for uma consulta **/
                if  avail tt_demonst_ctbl_fin
                then do:
                    assign v_rec_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video.

                    blk_while:
                    do while not avail item_demonst_ctbl :
                        find first btt_demonst_ctbl_fin where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video no-error.
                        if avail btt_demonst_ctbl_fin then do:
                            find btt_item_demonst_ctbl_video
                            where btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = btt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                            no-lock no-error.

                            find first item_demonst_ctbl  no-lock
                            where item_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                            and item_demonst_ctbl.num_seq_demonst_ctbl = integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                            no-error.

                            assign v_rec_demonst_ctbl_video = btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video.
                        end.
                        else
                            leave blk_while.
                    end.

                end.

                if  avail tt_demonst_ctbl_fin then
                    status input tt_demonst_ctbl_fin.ttv_cod_inform_princ in window wh_w_program.
                /* End_Include: i_entry_browse_demonst_video */


                leave expand.
            end.

            /* --- Elimina registros sem saldo conforme o par≥metro ---*/
            if  prefer_demonst_ctbl.log_impr_cta_sem_sdo = no then do:
                erase:
                for each tt_demonst_ctbl_fin
                   where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:

                    find first tt_item_demonst_ctbl_video
                        where  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                        no-error.
                    if  avail tt_item_demonst_ctbl_video then do:
                        if  not can-find(first tt_valor_demonst_ctbl_video
                        where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                        and   tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0) then do:
                            for each tt_valor_demonst_ctbl_video
                               where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                               delete tt_valor_demonst_ctbl_video.
                            end.
                            delete tt_item_demonst_ctbl_video.
                            delete tt_demonst_ctbl_fin.
                        end.
                    end.
                end /* for erase */.
            end.

            /* --- Calcula Variaªío e FΩrmulas das Colunas ---*/
            if  can-find(first tt_col_demonst_ctbl
                where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
                and  (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_formula*/  
                or    tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_variacao*/  )) then do:
                for each tt_item_demonst_ctbl_video:

                    find first tt_demonst_ctbl_fin
                       where tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                       and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                       no-error.
                    if not avail tt_demonst_ctbl_fin then
                        next.

                    run pi_col_demons_ctbl_video_more_3 /*pi_col_demons_ctbl_video_more_3*/.
                end.
            end.

            /* Se for consulta de saldo, calcula AV de forma diferenciada */
            if prefer_demonst_ctbl.cod_demonst_ctbl = "" then do:
                for each tt_controla_analise_vertical:
                    delete tt_controla_analise_vertical.
                end.

                for each tt_col_demonst_ctbl 
                   where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
                   and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/  :
                    create tt_controla_analise_vertical.
                    assign tt_controla_analise_vertical.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 8, 2))
                           tt_controla_analise_vertical.tta_cod_acumul_ctbl       = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 12, 8)).

                    for each tt_demonst_ctbl_fin
                        where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:
                        find tt_valor_demonst_ctbl_video
                            where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 8, 2))
                            and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video no-error.
                        if  avail tt_valor_demonst_ctbl_video then do:
                            assign tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert = tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert
                                                                                             + ABS(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1)).
                        end. /* end if*/
                    end.
                end.
            end.

            /* --- Calcula Analise Vertical ---*/
            if  can-find(first  tt_col_demonst_ctbl
                where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
                and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/  ) then do:
                for each tt_item_demonst_ctbl_video:

                    find first tt_demonst_ctbl_fin
                       where tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                       and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                       no-error.
                    if not avail tt_demonst_ctbl_fin then
                        next.

                    run pi_col_demons_ctbl_video_analise_vertical /*pi_col_demons_ctbl_video_analise_vertical*/.
                end.
            end.

            increm:
            repeat preselect each tt_demonst_ctbl_fin use-index tt_id_descending:
                find next tt_demonst_ctbl_fin
                    where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl > v_num_seq_initial.
                assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl + v_num_count.
            end.

            insere:
            for each tt_demonst_ctbl_fin
                where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:
                assign v_num_seq_initial = v_num_seq_initial + 10
                       tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = v_num_seq_initial.
            end.
        end.
END PROCEDURE. /* pi_expand_demonst_fin */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_ccusto
** Descricao.............: pi_tt_demonst_ctbl_fin_new_ccusto
** Criado por............: Dalpra
** Criado em.............: 22/07/2001 10:10:46
** Alterado por..........: fut41422
** Alterado em...........: 18/11/2013 09:32:27
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
    def var v_cod_ccusto_fim
        as Character
        format "x(11)":U
        initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
        label "atÇ"
        column-label "Centro Custo"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_ccusto_fim
        as character
        format "x(20)":U
        initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
        label "atÇ"
        column-label "CCusto"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
    def var v_cod_ccusto_ini
        as Character
        format "x(11)":U
        label "CCusto Inicial"
        column-label "Centro Custo"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_ccusto_ini
        as character
        format "x(20)":U
        label "CCusto Inicial"
        column-label "CCusto"
        no-undo.
    &ENDIF
    def var v_cod_ccusto_pai
        as Character
        format "x(11)":U
        label "Centro Custo Pai"
        column-label "Centro Custo Pai"
        no-undo.
    def var v_cod_unid_organ2
        as character
        format "x(3)":U
        no-undo.
    def var v_log_ok_1
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_plano_ccusto_valid         as character       no-undo. /*local*/
    def var v_num_seq_estrut                 as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_log_return = no
           v_cod_inform = "Centro de Custo" /*l_centro_de_custo*/ 
           v_log_abert_ccusto = yes.

    if  tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> "" then do:
        if not v_log_unid_organ_varios and
           not v_log_plano_ccusto_varios then do:
           /* Atividade 207449
              necessario carregar estas variˇveis com for each, pois quando um item do demonstrativo tem diversas composicoes, 
              que tenham ou nao informados o codigo do plano de custo, nao estava expandindo o centro de custo filho, acusando a mensagem
              11609 incorretamente, caso a primeira composicao nao tivesse informado o plano de ccusto. 
              Na logica abaixo, ira carregar o v_cod_plano_ccusto_valid com o primeiro codigo de plano ccusto informado <> vazio */

           for each btt_compos_demonst_cadastro no-lock
                where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
                  and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                  and  btt_compos_demonst_cadastro.cod_cta_ctbl_ini     <> "":
                  if v_cod_plano_ccusto_valid <> "" then
                      next.
                  assign v_cod_plano_ccusto_valid = btt_compos_demonst_cadastro.cod_plano_ccusto
                         v_cod_unid_organ2        = btt_compos_demonst_cadastro.cod_unid_organ
                         v_log_ok_1               = yes.
           end.

           if not v_log_ok_1 then
                  assign v_cod_plano_ccusto_valid = v_cod_plano_ccusto
                         v_cod_unid_organ2 = v_cod_unid_organ.  
           if  v_log_ccusto_subst then
               assign v_cod_plano_ccusto_valid = v_cod_plano_ccusto_sub.

           find plano_ccusto
           where plano_ccusto.cod_empresa      = v_cod_unid_organ2
             and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
           no-lock no-error.
           if  avail plano_ccusto then
               assign v_cod_format_ccusto = plano_ccusto.cod_format_ccusto.

           for each estrut_ccusto FIELDS(cod_empresa cod_plano_ccusto cod_ccusto_pai cod_ccusto_filho) no-lock
               where estrut_ccusto.cod_empresa            = v_cod_unid_organ2
                 and   estrut_ccusto.cod_plano_ccusto       = v_cod_plano_ccusto_valid
                 and   estrut_ccusto.cod_ccusto_pai         = tt_demonst_ctbl_fin.tta_cod_ccusto_filho:
                 assign v_cod_chave  = estrut_ccusto.cod_ccusto_filho
                        v_cod_plano_ccusto = v_cod_plano_ccusto_valid
                        v_cod_unid_organ = estrut_ccusto.cod_empresa.
                 run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/. 
           end.
        end.   
        else do:
           for each btt_compos_demonst_cadastro  no-lock 
              where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
                and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

                   /* Begin_Include: i_tt_demonst_ctbl_fin_new_ccusto2 */
                   if  v_log_ccusto_subst then
                       assign v_cod_plano_ccusto_valid = v_cod_plano_ccusto_sub.
                   else
                       assign v_cod_plano_ccusto_valid = btt_compos_demonst_cadastro.cod_plano_ccusto.
                   find plano_ccusto
                      where plano_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                      and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                      no-lock no-error.
                   if  avail plano_ccusto then 
                       assign v_cod_format_ccusto = plano_ccusto.cod_format_ccusto.
                   for each estrut_ccusto FIELDS(cod_empresa cod_plano_ccusto cod_ccusto_pai cod_ccusto_filho) no-lock
                       where estrut_ccusto.cod_empresa            = btt_compos_demonst_cadastro.cod_unid_organ
                       and   estrut_ccusto.cod_plano_ccusto       = v_cod_plano_ccusto_valid
                       and   estrut_ccusto.cod_ccusto_pai         = tt_demonst_ctbl_fin.tta_cod_ccusto_filho:
                       assign v_cod_chave  = estrut_ccusto.cod_ccusto_filho
                              v_cod_plano_ccusto = v_cod_plano_ccusto_valid
                              v_cod_unid_organ = btt_compos_demonst_cadastro.cod_unid_organ.
                       run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
                   end.

                   /* End_Include: i_tt_demonst_ctbl_fin_new_ccusto2 */

           end.    
        end.
    end.
    else do:
        /* LE tODAS AS COMPOSI∞COES ORIGENS DA COPIA */
        for each btt_compos_demonst_cadastro no-lock
             where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
               and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

            if  v_log_ccusto_subst then
                assign v_cod_plano_ccusto_valid = v_cod_plano_ccusto_sub
                       v_cod_ccusto_ini = v_cod_ccusto_subst_inic
                       v_cod_ccusto_fim = v_cod_ccusto_subst_fim.
            else do:
                assign v_cod_plano_ccusto_valid = btt_compos_demonst_cadastro.cod_plano_ccusto
                       v_cod_ccusto_ini = btt_compos_demonst_cadastro.cod_ccusto_ini
                       v_cod_ccusto_fim = btt_compos_demonst_cadastro.cod_ccusto_fim.
                if num-entries(v_des_visualiz_ccusto,chr(10)) > 0 then
                    assign v_cod_ccusto_ini = v_cod_ccusto_pai_menor
                           v_cod_ccusto_fim = v_cod_ccusto_pai_maior.
            end.

            find plano_ccusto
               where plano_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
               and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
               no-lock no-error.
            if  avail plano_ccusto then
                assign v_cod_format_ccusto = plano_ccusto.cod_format_ccusto.

            /* Verificar os itens da faixa */
            bloco:
            for each estrut_ccusto FIELDS(cod_empresa cod_plano_ccusto cod_ccusto_pai cod_ccusto_filho) no-lock
                where estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                and   estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                and   estrut_ccusto.cod_ccusto_filho >= v_cod_ccusto_ini
                and   estrut_ccusto.cod_ccusto_filho <= v_cod_ccusto_fim:

                find emscad.ccusto no-lock
                    where ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                    and   ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                    and   ccusto.cod_ccusto       = estrut_ccusto.cod_ccusto_pai
                    no-error.
                if  avail ccusto then do:
                    /* Nesta etapa considera somente os n≠veis PAIS */
                    if  not can-find(first b_estrut_ccusto
                        where b_estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                        and   b_estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                        and   b_estrut_ccusto.cod_ccusto_pai   = estrut_ccusto.cod_ccusto_filho) then do:
                        next bloco.
                    end.

                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a conta */
                    if  can-find(first b_estrut_ccusto
                        where b_estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                        and   b_estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                        and   b_estrut_ccusto.cod_ccusto_pai   = estrut_ccusto.cod_ccusto_pai
                        and   b_estrut_ccusto.cod_ccusto_pai  >= v_cod_ccusto_ini
                        and   b_estrut_ccusto.cod_ccusto_pai  <= v_cod_ccusto_fim) then do:
                        next bloco.
                    end.
                end.
                else next bloco.

                assign v_cod_chave  = estrut_ccusto.cod_ccusto_filho
                       v_cod_plano_ccusto = v_cod_plano_ccusto_valid
                       v_cod_unid_organ = plano_ccusto.cod_empresa.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_ccusto_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next bloco.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.

            bloco:    
            for each estrut_ccusto FIELDS(cod_empresa cod_plano_ccusto cod_ccusto_pai cod_ccusto_filho) no-lock
                where estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                and   estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                and   estrut_ccusto.cod_ccusto_filho >= v_cod_ccusto_ini
                and   estrut_ccusto.cod_ccusto_filho <= v_cod_ccusto_fim:

                /* Se for PAI na estrutura jˇ foi considerado no for each anterior */
                find ccusto no-lock
                    where ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                    and   ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                    and   ccusto.cod_ccusto       = estrut_ccusto.cod_ccusto_pai
                    no-error.
                if  avail ccusto then do:
                    if  can-find(first b_estrut_ccusto
                        where b_estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                        and   b_estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                        and   b_estrut_ccusto.cod_ccusto_pai   = estrut_ccusto.cod_ccusto_filho) then do:
                        next bloco.
                    end.
                    else do:
                        /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera o Ccusto */
                        if  can-find(first b_estrut_ccusto
                            where b_estrut_ccusto.cod_empresa      = btt_compos_demonst_cadastro.cod_unid_organ
                            and   b_estrut_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_valid
                            and   b_estrut_ccusto.cod_ccusto_pai   = estrut_ccusto.cod_ccusto_pai
                            and   b_estrut_ccusto.cod_ccusto_pai  <> ""
                            and   b_estrut_ccusto.cod_ccusto_pai  >= v_cod_ccusto_ini
                            and   b_estrut_ccusto.cod_ccusto_pai  <= v_cod_ccusto_fim) then do:
                            next bloco.
                        end.
                    end.                
                end.
                assign v_cod_chave  = estrut_ccusto.cod_ccusto_filho
                       v_cod_plano_ccusto = v_cod_plano_ccusto_valid
                       v_cod_unid_organ = plano_ccusto.cod_empresa.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_ccusto_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next bloco.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.                    
        end.
    end.

    run pi_compos_estrut_2 /*pi_compos_estrut_2*/.

END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_projeto
** Descricao.............: pi_tt_demonst_ctbl_fin_new_projeto
** Criado por............: Dalpra
** Criado em.............: 22/07/2001 10:50:34
** Alterado por..........: src531
** Alterado em...........: 17/09/2002 08:46:49
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_projeto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_proj_financ_fim
        as character
        format "x(20)":U
        initial "ZZZZZZZZZZZZZZZZZZZZ"
        label "Projeto Final"
        column-label "Projeto"
        no-undo.
    def var v_cod_proj_financ_ini
        as character
        format "x(20)":U
        label "Inicial"
        column-label "Projeto"
        no-undo.
    def var v_cod_proj_financ_pai
        as character
        format "x(20)":U
        label "Projeto Pai"
        column-label "Projeto Pai"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_log_return = no
           v_cod_inform = "Projeto" /*l_projeto*/ 
           v_cod_format_proj_financ = param_geral_ems.cod_format_proj_financ.

    if  tt_demonst_ctbl_fin.tta_cod_proj_financ_filho <> "" then do:
        for each estrut_proj_financ FIELDS(cod_proj_financ_pai cod_proj_financ_filho) no-lock
            where estrut_proj_financ.cod_proj_financ_pai = tt_demonst_ctbl_fin.tta_cod_proj_financ_filho:
            assign v_cod_chave  = estrut_proj_financ.cod_proj_financ_filho.
            run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
        end.
    end.
    else do:

        /* Lº toDAS AS COMPOSI∞ÜES ORIGENS DA COPIA */
        for each btt_compos_demonst_cadastro no-lock
             where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
               and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

            &if '{&emsfin_version}' = '5.05' &then 
                assign v_cod_proj_financ_ini = entry(1,btt_compos_demonst_cadastro.cod_livre_1,chr(10)).
            &else    
                assign v_cod_proj_financ_ini = btt_compos_demonst_cadastro.cod_proj_financ_inicial.
            &endif
            assign v_cod_proj_financ_fim = btt_compos_demonst_cadastro.cod_proj_financ_fim.

            /* Verificar os itens da faixa */
            for each estrut_proj_financ FIELDS(cod_proj_financ_pai cod_proj_financ_filho) no-lock
                where estrut_proj_financ.cod_proj_financ_filho >= v_cod_proj_financ_ini
                and   estrut_proj_financ.cod_proj_financ_filho <= v_cod_proj_financ_fim:

                /* Nesta etapa considera somente os n≠veis PAIS */
                if  not can-find(first b_estrut_proj_financ
                    where b_estrut_proj_financ.cod_proj_financ_pai = estrut_proj_financ.cod_proj_financ_filho) then do:
                    next.
                end.

                /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a conta */
                if  can-find(first b_estrut_proj_financ
                    where b_estrut_proj_financ.cod_proj_financ_pai  = estrut_proj_financ.cod_proj_financ_pai
                    and   b_estrut_proj_financ.cod_proj_financ_pai <> ""
                    and   b_estrut_proj_financ.cod_proj_financ_pai >= v_cod_proj_financ_ini
                    and   b_estrut_proj_financ.cod_proj_financ_pai <= v_cod_proj_financ_fim) then do:
                    next.
                end.
                assign v_cod_chave  = estrut_proj_financ.cod_proj_financ_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.

            for each estrut_proj_financ FIELDS(cod_proj_financ_pai cod_proj_financ_filho) no-lock
                where estrut_proj_financ.cod_proj_financ_filho >= v_cod_proj_financ_ini
                and   estrut_proj_financ.cod_proj_financ_filho <= v_cod_proj_financ_fim:

                /* Se for PAI na estrutura jˇ foi considerado no for each anterior */
                if  can-find(first b_estrut_proj_financ
                    where b_estrut_proj_financ.cod_proj_financ_pai   = estrut_proj_financ.cod_proj_financ_filho) then do:
                    next.
                end.
                else do:
                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera o projeto */
                    if  can-find(first b_estrut_proj_financ
                        where b_estrut_proj_financ.cod_proj_financ_pai   = estrut_proj_financ.cod_proj_financ_pai
                        and   b_estrut_proj_financ.cod_proj_financ_pai  <> ""
                        and   b_estrut_proj_financ.cod_proj_financ_pai  >= v_cod_proj_financ_ini
                        and   b_estrut_proj_financ.cod_proj_financ_pai  <= v_cod_proj_financ_fim) then do:
                        next.
                    end.
                end.
                assign v_cod_chave  = estrut_proj_financ.cod_proj_financ_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.                    
        end.
    end.

    run pi_compos_estrut_2 /*pi_compos_estrut_2*/.

END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_projeto */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_cta
** Descricao.............: pi_tt_demonst_ctbl_fin_new_cta
** Criado por............: Dalpra
** Criado em.............: 22/07/2001 10:48:44
** Alterado por..........: src531
** Alterado em...........: 17/09/2002 08:45:48
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_cta:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cta_ctbl_fim
        as character
        format "x(20)":U
        initial "ZZZZZZZZZZZZZZZZZZZZ"
        label "Conta Final"
        column-label "Final"
        no-undo.
    def var v_cod_cta_ctbl_ini
        as character
        format "x(20)":U
        label "Conta Inicial"
        column-label "Inicial"
        no-undo.
    def var v_cod_cta_ctbl_pai
        as character
        format "x(20)":U
        label "Conta Ctbl Pai"
        column-label "Conta Ctbl Pai"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_log_return = no
           v_cod_inform = "Conta Cont†bil" /*l_conta_contabil*/ .

    find plano_cta_ctbl 
       where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl 
       no-lock no-error.
    if  avail plano_cta_ctbl then
        assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl.

    if  tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho <> "" then do:
        for each estrut_cta_ctbl FIELDS(cod_plano_cta_ctbl cod_cta_ctbl_pai cod_cta_ctbl_filho) no-lock
            where estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
            and   estrut_cta_ctbl.cod_cta_ctbl_pai   = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho:
            assign v_cod_chave  = estrut_cta_ctbl.cod_cta_ctbl_filho.
            run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
        end.
    end.
    else do:
        /* Lº toDAS AS COMPOSI∞ÜES ORIGENS DA COPIA */
        for each btt_compos_demonst_cadastro no-lock
             where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
               and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

            /* Verificar os itens da faixa */
            if  btt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid <> "Anal°tica" /*l_analitica*/   then do:
                for each estrut_cta_ctbl FIELDS(cod_plano_cta_ctbl cod_cta_ctbl_pai cod_cta_ctbl_filho) no-lock
                    where estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                    and   estrut_cta_ctbl.cod_cta_ctbl_filho >= btt_compos_demonst_cadastro.cod_cta_ctbl_inic
                    and   estrut_cta_ctbl.cod_cta_ctbl_filho <= btt_compos_demonst_cadastro.cod_cta_ctbl_fim:

                    /* Nesta etapa considera somente os n≠veis PAIS */
                    if  not can-find(first b_estrut_cta_ctbl
                        where b_estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai   = estrut_cta_ctbl.cod_cta_ctbl_filho) then do:
                        next.
                    end.

                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a conta */
                    if  can-find(first b_estrut_cta_ctbl
                        where b_estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai   = estrut_cta_ctbl.cod_cta_ctbl_pai
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai  >= btt_compos_demonst_cadastro.cod_cta_ctbl_inic
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai  <= btt_compos_demonst_cadastro.cod_cta_ctbl_fim) then do:
                        next.
                    end.
                    assign v_cod_chave  = estrut_cta_ctbl.cod_cta_ctbl_filho.

                    find first btt_demonst_ctbl_fin
                       where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                       and   btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = v_cod_chave
                       no-lock no-error.
                    if avail btt_demonst_ctbl_fin then
                        next.

                    run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
                end.
            end.

            for each estrut_cta_ctbl FIELDS(cod_plano_cta_ctbl cod_cta_ctbl_pai cod_cta_ctbl_filho) no-lock
                where estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                and   estrut_cta_ctbl.cod_cta_ctbl_filho >= btt_compos_demonst_cadastro.cod_cta_ctbl_inic
                and   estrut_cta_ctbl.cod_cta_ctbl_filho <= btt_compos_demonst_cadastro.cod_cta_ctbl_fim:

                /* Se for PAI na estrutura jˇ foi considerado no for each anterior */
                if  can-find(first b_estrut_cta_ctbl
                    where b_estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                    and   b_estrut_cta_ctbl.cod_cta_ctbl_pai   = estrut_cta_ctbl.cod_cta_ctbl_filho)
                    and   btt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid <> "Anal°tica" /*l_analitica*/   then do:
                    next.
                end.
                else do:
                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a conta */
                    if  can-find(first b_estrut_cta_ctbl
                        where b_estrut_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai   = estrut_cta_ctbl.cod_cta_ctbl_pai
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai  <> ""
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai  >= btt_compos_demonst_cadastro.cod_cta_ctbl_inic
                        and   b_estrut_cta_ctbl.cod_cta_ctbl_pai  <= btt_compos_demonst_cadastro.cod_cta_ctbl_fim) 
                        and  btt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid <> "Anal°tica" /*l_analitica*/   then do:  
                        next.
                    end.
                end.
                assign v_cod_chave  = estrut_cta_ctbl.cod_cta_ctbl_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.                    
        end.
    end.

    run pi_compos_estrut_2.
END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_cta */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_unid_negoc
** Descricao.............: pi_tt_demonst_ctbl_fin_new_unid_negoc
** Criado por............: Dalpra
** Criado em.............: 22/07/2001 10:51:58
** Alterado por..........: its0068
** Alterado em...........: 31/08/2005 14:25:06
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_unid_negoc_fim
        as character
        format "x(3)":U
        initial "ZZZ"
        label "atÇ"
        column-label "Final"
        no-undo.
    def var v_cod_unid_negoc_ini
        as character
        format "x(3)":U
        label "Unid Neg¢cio"
        column-label "Inicial"
        no-undo.
    def var v_cod_unid_negoc_pai
        as character
        format "x(3)":U
        label "Un Neg Pai"
        column-label "Un Neg Pai"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_log_return = no
           v_cod_inform = "Unidade Neg¢cio" /*l_unidade_negocio*/ .

    if  tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> "" then do:
        for each estrut_unid_negoc FIELDS(cod_unid_negoc_pai cod_unid_negoc_filho) no-lock
            where estrut_unid_negoc.cod_unid_negoc_pai    = tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho:
            assign v_cod_chave  = estrut_unid_negoc.cod_unid_negoc_filho.
            run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
        end.
    end.
    else do:
        /* Lº toDAS AS COMPOSI∞ÜES ORIGENS DA COPIA */
        for each btt_compos_demonst_cadastro no-lock
             where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
               and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

            if  v_log_unid_negoc_subst then
                assign v_cod_unid_negoc_ini = v_cod_unid_negoc_subst_inic
                       v_cod_unid_negoc_fim = v_cod_unid_negoc_subst_fim.
            else
                assign v_cod_unid_negoc_fim = btt_compos_demonst_cadastro.cod_unid_negoc_fim
                       v_cod_unid_negoc_ini = btt_compos_demonst_cadastro.cod_unid_negoc_ini.

            /* Verificar os itens da faixa */
            for each estrut_unid_negoc FIELDS(cod_unid_negoc_pai cod_unid_negoc_filho) no-lock
                where estrut_unid_negoc.cod_unid_negoc_filho >= v_cod_unid_negoc_ini
                and   estrut_unid_negoc.cod_unid_negoc_filho <= v_cod_unid_negoc_fim:

                /* Nesta etapa considera somente os n≠veis PAIS */
                if  not can-find(first b_estrut_unid_negoc
                    where b_estrut_unid_negoc.cod_unid_negoc_pai = estrut_unid_negoc.cod_unid_negoc_filho) then do:
                    next.
                end.

                /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a unidade de negΩcio */
                if  can-find(first b_estrut_unid_negoc
                    where b_estrut_unid_negoc.cod_unid_negoc_pai  = estrut_unid_negoc.cod_unid_negoc_pai
                    and   b_estrut_unid_negoc.cod_unid_negoc_pai <> ""
                    and   b_estrut_unid_negoc.cod_unid_negoc_pai >= v_cod_unid_negoc_ini
                    and   b_estrut_unid_negoc.cod_unid_negoc_pai <= v_cod_unid_negoc_fim) then do:
                    next.
                end.
                assign v_cod_chave  = estrut_unid_negoc.cod_unid_negoc_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.

            for each estrut_unid_negoc FIELDS(cod_unid_negoc_pai cod_unid_negoc_filho) no-lock
                where estrut_unid_negoc.cod_unid_negoc_filho >= v_cod_unid_negoc_ini
                and   estrut_unid_negoc.cod_unid_negoc_filho <= v_cod_unid_negoc_fim:

                find tt_unid_negocio
                     where tt_unid_negocio.tta_cod_unid_negoc = estrut_unid_negoc.cod_unid_negoc_filho no-error.
                if  not avail tt_unid_negocio then
                    next.

                /* Se for PAI na estrutura jˇ foi considerado no for each anterior */
                if  can-find(first b_estrut_unid_negoc
                    where b_estrut_unid_negoc.cod_unid_negoc_pai   = estrut_unid_negoc.cod_unid_negoc_filho) then do:
                    next.
                end.
                else do:
                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a UNIDADE NEGÖCIO */
                    if  can-find(first b_estrut_unid_negoc
                        where b_estrut_unid_negoc.cod_unid_negoc_pai   = estrut_unid_negoc.cod_unid_negoc_pai
                        and   b_estrut_unid_negoc.cod_unid_negoc_pai  <> ""
                        and   b_estrut_unid_negoc.cod_unid_negoc_pai  >= v_cod_unid_negoc_ini
                        and   b_estrut_unid_negoc.cod_unid_negoc_pai  <= v_cod_unid_negoc_fim) then do:
                        next.
                    end.
                end.
                assign v_cod_chave  = estrut_unid_negoc.cod_unid_negoc_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.                    
        end.
    end.

    run pi_compos_estrut_2 /*pi_compos_estrut_2*/.
END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_unid_organ
** Descricao.............: pi_tt_demonst_ctbl_fin_new_unid_organ
** Criado por............: Dalpra
** Criado em.............: 22/07/2001 10:56:09
** Alterado por..........: src507
** Alterado em...........: 22/10/2002 10:46:29
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_unid_organ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_unid_organ_fim
        as character
        format "x(3)":U
        initial "ZZZ"
        label "Final"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_unid_organ_fim
        as Character
        format "x(5)":U
        initial "ZZZZZ"
        label "Final"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_unid_organ_ini
        as character
        format "x(3)":U
        label "UO Inicial"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_unid_organ_ini
        as Character
        format "x(5)":U
        label "UO Inicial"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_unid_organ_pai
        as character
        format "x(3)":U
        label "Unidade Organiz Pai"
        column-label "UO Pai"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_unid_organ_pai
        as Character
        format "x(5)":U
        label "Unidade Organiz Pai"
        column-label "UO Pai"
        no-undo.
    &ENDIF


    /************************** Variable Definition End *************************/

    assign v_log_return = no
           v_cod_inform = "UO Origem" /*l_uo_origem*/ .

    if  tt_demonst_ctbl_fin.tta_cod_unid_organ_filho <> "" then do:
        for each emscad.estrut_unid_organ FIELDS(cod_unid_organ_pai cod_unid_organ_filho) no-lock
            where estrut_unid_organ.cod_unid_organ_pai    = tt_demonst_ctbl_fin.tta_cod_unid_organ_filho:

            find emscad.unid_organ 
               where unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho
               and   unid_organ.num_niv_unid_organ <> 999
               no-lock no-error.
            if not avail unid_organ then 
                next.

            assign v_cod_chave  = estrut_unid_organ.cod_unid_organ_filho.
            run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
        end.
    end.
    else do:
        /* Lº toDAS AS COMPOSI∞ÜES ORIGENS DA COPIA */
        for each btt_compos_demonst_cadastro no-lock
             where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
               and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

            assign v_cod_unid_organ_ini = btt_compos_demonst_cadastro.cod_unid_organ
                   v_cod_unid_organ_fim = btt_compos_demonst_cadastro.cod_unid_organ_fim.

            /* Verificar Substituiá∆o de UO - RAFA */

            /* Verificar os itens da faixa */
            for each estrut_unid_organ FIELDS(cod_unid_organ_pai cod_unid_organ_filho) no-lock
                where estrut_unid_organ.cod_unid_organ_filho >= v_cod_unid_organ_ini
                and   estrut_unid_organ.cod_unid_organ_filho <= v_cod_unid_organ_fim:
                find unid_organ 
                   where unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho
                   no-lock no-error.
                if not avail unid_organ then 
                    next.

                if unid_organ.num_niv_unid_organ <> 998 then do:
                    /* Nesta etapa considera somente os n°veis PAIS */
                    if  not can-find(first b_estrut_unid_organ
                        where b_estrut_unid_organ.cod_unid_organ_pai = estrut_unid_organ.cod_unid_organ_filho) then do:
                        next.
                    end.

                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a unidade de neg¢cio */
                    if  can-find(first b_estrut_unid_organ
                        where b_estrut_unid_organ.cod_unid_organ_pai  = estrut_unid_organ.cod_unid_organ_pai
                        and   b_estrut_unid_organ.cod_unid_organ_pai >= v_cod_unid_organ_ini
                        and   b_estrut_unid_organ.cod_unid_organ_pai <= v_cod_unid_organ_fim) then do:
                        next.
                    end.
                end.
                assign v_cod_chave  = estrut_unid_organ.cod_unid_organ_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_unid_organ_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.

            for each estrut_unid_organ FIELDS(cod_unid_organ_pai cod_unid_organ_filho) no-lock
                where estrut_unid_organ.cod_unid_organ_filho >= v_cod_unid_organ_ini
                and   estrut_unid_organ.cod_unid_organ_filho <= v_cod_unid_organ_fim:

                /* Se for PAI na estrutura jˇ foi considerado no for each anterior */
                if  can-find(first b_estrut_unid_organ
                    where b_estrut_unid_organ.cod_unid_organ_pai   = estrut_unid_organ.cod_unid_organ_filho) then do:
                    next.
                end.
                else do:
                    /* Se o Pai da conta selecionada estiver dentro da faixa desconsidera a UNIDADE NEGÖCIO */
                    if  can-find(first b_estrut_unid_organ
                        where b_estrut_unid_organ.cod_unid_organ_pai   = estrut_unid_organ.cod_unid_organ_pai
                        and   b_estrut_unid_organ.cod_unid_organ_pai  <> ""
                        and   b_estrut_unid_organ.cod_unid_organ_pai  >= v_cod_unid_organ_ini
                        and   b_estrut_unid_organ.cod_unid_organ_pai  <= v_cod_unid_organ_fim) then do:
                        next.
                    end.
                end.
                assign v_cod_chave  = estrut_unid_organ.cod_unid_organ_filho.

                find first btt_demonst_ctbl_fin
                   where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                   and   btt_demonst_ctbl_fin.tta_cod_unid_organ_filho = v_cod_chave
                   no-lock no-error.
                if avail btt_demonst_ctbl_fin then
                    next.

                run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
            end.
        end.
    end.

    run pi_compos_estrut_2 /*pi_compos_estrut_2*/.

END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_habilita_itens_expansao_1
** Descricao.............: pi_habilita_itens_expansao_1
** Criado por............: fut12209
** Criado em.............: 31/01/2008 10:45:11
** Alterado por..........: fut12209
** Alterado em...........: 31/01/2008 15:05:11
*****************************************************************************/
PROCEDURE pi_habilita_itens_expansao_1:

    /************************* Variable Definition Begin ************************/

    def var v_num_compos                     as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    IF v_log_nova_con_sdo_empenh THEN
        ASSIGN m_13:SENSITIVE = NO
               m_14:SENSITIVE = YES.

    if  avail tt_item_demonst_ctbl_video
        and tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "Chr Espec" /*l_hr_espec*/  then do:
        assign m_1:SENSITIVE  = NO
               m_2:SENSITIVE  = NO
               m_3:SENSITIVE  = NO
               m_4:SENSITIVE  = NO
               m_5:SENSITIVE  = NO
               m_6:SENSITIVE  = NO
               m_7:SENSITIVE  = NO
               m_9:SENSITIVE  = NO
               m_10:SENSITIVE = NO
               m_11:SENSITIVE = YES
               m_12:SENSITIVE = YES
               .
        return.
    end.

    /* * Desabilita todas as opªÑes quando nío houver registros ou for uma linha de t≠tulos **/
    if  not avail tt_demonst_ctbl_fin
    OR (avail tt_item_demonst_ctbl_video 
    and tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  )
    OR (avail tt_item_demonst_ctbl_cadastro
    and tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst    = "F¢rmula" /*l_formula*/ 
    and v_log_funcao_concil_consolid = no )
    then do:
        assign  m_1:SENSITIVE  = NO
                m_2:SENSITIVE  = NO
                m_3:SENSITIVE  = NO
                m_4:SENSITIVE  = NO
                m_5:SENSITIVE  = NO
                m_6:SENSITIVE  = NO
                m_7:SENSITIVE  = NO
                m_9:SENSITIVE  = NO
                m_10:SENSITIVE  = NO
                m_11:SENSITIVE  = NO
                m_12:SENSITIVE  = NO
                
                .

        /* * Desabilita opªío de contraªío para registros nío espandidos **/
        if  avail tt_demonst_ctbl_fin
        and not tt_demonst_ctbl_fin.ttv_log_expand then do:
            assign  m_1:SENSITIVE  = NO.
        end.

        if  avail tt_item_demonst_ctbl_video
        and (tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "T°tulo" /*l_titulo*/  
        OR   tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst    = "F¢rmula" /*l_formula*/  )
        and prefer_demonst_ctbl.cod_demonst_ctbl <> "" then
        assign  m_11:SENSITIVE  = YES
                m_12:SENSITIVE  = YES
                .

        RETURN NO-APPLY.
    end.

    assign  m_1:SENSITIVE  = YES
            m_2:SENSITIVE  = YES
            m_3:SENSITIVE  = NO
            m_4:SENSITIVE  = YES
            m_5:SENSITIVE  = YES
            m_6:SENSITIVE  = YES
            m_7:SENSITIVE  = YES
            m_9:SENSITIVE  = NO      
            m_10:SENSITIVE  = NO
            m_11:SENSITIVE  = YES
            m_12:SENSITIVE  = YES
            m_14:SENSITIVE  = YES.

    /* * Desabilita Detalhes para as Consultas de Saldos **/
    if  prefer_demonst_ctbl.cod_demonst_ctbl = "" then
        assign  m_11:SENSITIVE  = NO
                m_12:SENSITIVE  = NO.

    /* * Se jˇ estˇ expandida estrutura, nío permite expandir novamente **/
    if  tt_demonst_ctbl_fin.ttv_log_expand
    then do:
        assign  m_2:SENSITIVE  = NO
                m_3:SENSITIVE  = NO
                m_4:SENSITIVE  = NO
                m_5:SENSITIVE  = NO
                m_6:SENSITIVE  = NO
                m_7:SENSITIVE  = NO.
    end.


    /* Controle para validar a existància de varias composicoes definidas para o item  do demonstrativo e estas
    composiá‰es estarem definidas para buscar informaá‰es de varias Unidades Organizacionias ou Plano de CCustos diferentes.
    Ser† emitido mensagem de alerta no caso de expans∆o de ccusto.
    msg: Pode n∆o apresentar na ordenaá∆o correta os ccusto se as estruturas de cc n∆o forem iguais entre as empresas. 

    */

    assign v_num_compos = 0
           v_des_visualiz_Unid_Organ = ""
           v_des_visualiz_plano_ccusto = ""
           v_log_Unid_Organ_varios = no
           v_log_Plano_CCusto_varios = no.
    for each tt_compos_demonst_cadastro no-lock
        where tt_compos_demonst_cadastro.cod_demonst_ctbl       = prefer_demonst_ctbl.cod_demonst_ctbl
          and tt_compos_demonst_cadastro.num_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
          and tt_compos_demonst_cadastro.cod_plano_ccusto      <> "":
        /* se a composiá∆o for por faixa de UO (n∆o informa cc e n∆o permite expans∆o de cc) ent∆o desconsidera*/
        if  tt_compos_demonst_cadastro.cod_unid_organ =  tt_compos_demonst_cadastro.cod_unid_organ_fim then do:
            if v_num_compos = 0  then do:
               assign v_num_compos = 1
                      v_cod_unid_organ_ant = tt_compos_demonst_cadastro.cod_unid_organ
                      v_des_visualiz_Unid_Organ  = v_des_visualiz_Unid_Organ + tt_compos_demonst_cadastro.cod_unid_organ + chr(10)
                      v_cod_plano_ccusto_ant = tt_compos_demonst_cadastro.cod_plano_ccusto
                      v_des_visualiz_plano_ccusto = v_des_visualiz_plano_ccusto + tt_compos_demonst_cadastro.cod_plano_ccusto + chr(10).
            end.
            else do:
                assign v_num_compos = v_num_compos + 1.
                if  v_cod_unid_organ_ant <> tt_compos_demonst_cadastro.cod_unid_organ then do:
                    assign v_log_Unid_Organ_varios = yes
                           v_des_visualiz_Unid_Organ  = v_des_visualiz_Unid_Organ  + tt_compos_demonst_cadastro.cod_unid_organ + chr(10)
                           v_cod_unid_organ_ant = tt_compos_demonst_cadastro.cod_unid_organ.
                end.
                if v_cod_plano_ccusto_ant <> tt_compos_demonst_cadastro.cod_plano_ccusto  then do:
                    assign v_log_Plano_ccusto_varios = yes
                           v_des_visualiz_plano_ccusto = v_des_visualiz_plano_ccusto  + tt_compos_demonst_cadastro.cod_plano_ccusto + chr(10)
                           v_cod_plano_ccusto_ant = tt_compos_demonst_cadastro.cod_plano_ccusto.

                end.
            end.
        end.
    end.

END PROCEDURE. /* pi_habilita_itens_expansao_1 */
/*****************************************************************************
** Procedure Interna.....: pi_habilita_itens_expansao
** Descricao.............: pi_habilita_itens_expansao
** Criado por............: bre17752
** Criado em.............: 25/07/2001 10:51:11
** Alterado por..........: fut41162
** Alterado em...........: 08/09/2009 21:33:47
*****************************************************************************/
PROCEDURE pi_habilita_itens_expansao:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_estrut_visualiz_ctbl
        for estrut_visualiz_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_visualiz_aux
        as character
        format "x(40)":U
        no-undo.
    def var v_log_desabta_ccusto
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_compos                     as integer         no-undo. /*local*/
    def var v_num_compos_2                   as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    run pi_habilita_itens_expansao_1.

    /* * Posiciona no primeiro item de composiªío para utilizar nas validaªÑes abaixo **/
    find first tt_compos_demonst_cadastro no-lock
        where tt_compos_demonst_cadastro.cod_demonst_ctbl       = prefer_demonst_ctbl.cod_demonst_ctbl
          and tt_compos_demonst_cadastro.num_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
          and tt_compos_demonst_cadastro.cod_plano_ccusto      <> ""
        no-error.
    if  not avail tt_compos_demonst_cadastro then 
        find first tt_compos_demonst_cadastro no-lock
            where tt_compos_demonst_cadastro.cod_demonst_ctbl       = prefer_demonst_ctbl.cod_demonst_ctbl
              and tt_compos_demonst_cadastro.num_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
            no-error.
    if  not avail tt_compos_demonst_cadastro then do:
        assign  m_1:SENSITIVE  = NO
                m_2:SENSITIVE  = NO
                m_3:SENSITIVE  = NO
                m_4:SENSITIVE  = NO
                m_5:SENSITIVE  = NO
                m_6:SENSITIVE  = NO
                m_7:SENSITIVE  = NO
                m_9:SENSITIVE  = NO
                m_10:SENSITIVE  = NO
                m_11:SENSITIVE  = NO
                m_12:SENSITIVE  = NO.
       

        /* * Desabilita opªío de contraªío para registros nío espandidos **/
        if  not tt_demonst_ctbl_fin.ttv_log_expand then do:
            assign  m_1:SENSITIVE  = NO
                    /*m_14:SENSITIVE = YES*/.
        end.

        return no-apply.
    end.
    else do:
         for each b_estrut_visualiz_ctbl no-lock
             where b_estrut_visualiz_ctbl.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
               and b_estrut_visualiz_ctbl.num_seq_demonst_ctbl =  tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:
                   assign   v_des_visualiz_aux =  v_des_visualiz_aux + b_estrut_visualiz_ctbl.ind_inform_estrut_visualiz + chr(10).
         end. 

        /* * Desabilita opªío de contraªío para registros nío espandidos **/
        if  not tt_demonst_ctbl_fin.ttv_log_expand then do:
            assign  m_1:SENSITIVE  = NO
                    /*m_14:SENSITIVE = YES*/.
            
        end.

        /* * desabilita opcao de contracao para registros expandidos por visualizaá∆o (nao expandidos pelo usu†rio) * */
         if lookup(tt_demonst_ctbl_fin.ttv_cod_inform_princ , v_des_visualiz_aux, chr(10)) <> 0  and 
            tt_demonst_ctbl_fin.ttv_log_expand_usuar = no  THEN DO:
            assign  m_1:SENSITIVE  = NO
                    /*m_14:SENSITIVE = YES*/.
         END.

        /* * Caso a cta seja sint≤tica as opªÑes da Consulta ao Razío ficarío desabilitadas **/
        if (tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho <> ""
        and can-find(first cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
              and cta_ctbl.cod_cta_ctbl       = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho
              and cta_ctbl.ind_espec_cta_ctbl = "SintÇtica" /*l_sintetica*/  ))
        OR  tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = '' then
            assign  m_9:SENSITIVE  = NO
                    m_10:SENSITIVE  = NO
                    .

        /* Caso o Centro de Custo nío esteja expandido nío permite consultar o Razío*/
        if  tt_demonst_ctbl_fin.tta_cod_ccusto_filho = '' then
            assign  m_10:SENSITIVE  = YES
                    .

        if can-find (first plano_cta_ctbl no-lock
                     where plano_cta_ctbl.cod_plano_cta_ctbl     = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
                     and   plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  ) then
            assign  m_6:SENSITIVE   = NO
                    m_9:SENSITIVE   = NO
                    m_10:SENSITIVE  = NO
                   .

        /* Desabilita a Expansao de Projeto caso a empresa nao utilize projetos */
        if  not can-find(first proj_financ where proj_financ.cod_proj_financ <> "")
        then assign  m_4:SENSITIVE  = NO
                     .

        /* Se busca saldo CC igual a nao, entao desabilita expansao por CC */
        if tt_compos_demonst_cadastro.cod_plano_ccusto = '' THEN 
            assign  m_3:SENSITIVE  = NO
                     .

        /* * Caso a conta contˇbil nío tenha estrutura abaixo dela, ficarˇ desabilitada **/
        if  tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho <> ''
        and not can-find(first estrut_cta_ctbl
            where estrut_cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
            and   estrut_cta_ctbl.cod_cta_ctbl_pai = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho) then
            assign  m_2:SENSITIVE  = NO
                    m_14:SENSITIVE = NO. /*alteracao para Belliz*/

        /* * Caso nío tenha estrutura abaixo do CCusto, esta opªío ficarˇ desabilitada, ou seja
             o ccusto expandido est† no £ltimo n°vel da estrutura, n∆o tem filhos **/
        if  tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> '' then do:
            if not v_log_unid_organ_varios and
               not v_log_plano_ccusto_varios then do:
                   if not can-find(first estrut_ccusto
                    where estrut_ccusto.cod_empresa      = tt_compos_demonst_cadastro.cod_unid_organ
                    and   estrut_ccusto.cod_plano_ccusto = tt_compos_demonst_cadastro.cod_plano_ccusto
                    and   estrut_ccusto.cod_ccusto_pai = tt_demonst_ctbl_fin.tta_cod_ccusto_filho) then
                    assign  m_3:SENSITIVE  = NO
                            m_14:SENSITIVE = NO.
            end.
            else do:
                /* Para itens com n composiá‰es informadas com n unidades organizacionais ou n pl ccustos:
                   considerar a lista de unid organ e plano ccusto para verificar se  em alguma estrutura o ccusto tem estrutura baixo dele, 
                   nesse caso n∆o desabilita opá∆o de expans∆o*/
                assign v_num_compos = 0
                       v_num_compos_2 = 0 
                       v_log_desabta_ccusto = yes.
                repeat v_num_compos = 1 to (NUM-ENTRIES(v_des_visualiz_Unid_Organ,chr(10)) - 1):
                   repeat v_num_compos_2 = 1 to (NUM-ENTRIES(v_des_visualiz_Plano_CCusto,chr(10)) - 1):
                          if  can-find(first estrut_ccusto
                           where estrut_ccusto.cod_empresa      = entry(v_num_compos , v_des_visualiz_Unid_Organ,chr(10))
                           and   estrut_ccusto.cod_plano_ccusto = entry(v_num_compos_2 , v_des_visualiz_Plano_ccusto,chr(10))
                           and   estrut_ccusto.cod_ccusto_pai = tt_demonst_ctbl_fin.tta_cod_ccusto_filho) 
                           then do:
                                assign v_log_desabta_ccusto  = NO.
                           end.
                   end.
                   if not v_log_desabta_ccusto  then leave.
                end.
                if  v_log_desabta_ccusto  then
                    assign  m_3:SENSITIVE  = NO
                            .
            end.        
        end.
        /* * Caso o Projeto nío tenha estrutura abaixo dele, ficarˇ desabilitado **/
        if  tt_demonst_ctbl_fin.tta_cod_proj_financ_filho <> ''
        and not can-find(first estrut_proj_financ
            where estrut_proj_financ.cod_proj_financ_pai = tt_demonst_ctbl_fin.tta_cod_proj_financ_filho) then
            assign  m_4:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* * Caso nío tenha estrutura abaixo da Unidade de NegΩcio, opªío ficarˇ desabilitada **/
        if  tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ''
        and not can-find(first estrut_unid_negoc
            where estrut_unid_negoc.cod_unid_negoc_pai = tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho) then
            assign  m_5:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* * Caso a unidade de neg¢cio estar definida na estrutura de visualizaá∆o do item do demonstrativo - opá∆o ficar desabilitada
             pois lista todas as unidades de uma s¢ vez independente da estrutura definida **/  
        if  prefer_demonst_ctbl.cod_demonst_ctbl <> "" and 
            lookup("Unidade Neg¢cio" /*l_unidade_negocio*/ , v_des_visualiz_aux, chr(10)) <> 0 then     
            assign  m_5:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* * Caso nío tenha estrutura abaixo da Unidade Organizacional, opªío ficarˇ desabilitada **/
        if  tt_demonst_ctbl_fin.tta_cod_unid_organ_filho <> ''
        and not can-find(first emscad.estrut_unid_organ
            where estrut_unid_organ.cod_unid_organ_pai = tt_demonst_ctbl_fin.tta_cod_unid_organ_filho) then
            assign  m_7:SENSITIVE  = NO
                   m_14:SENSITIVE = NO.

        /* *215984 - Ao consultar o demonstrativo ou Sdo de um Plano Consolidado, permitir† a expans∆o somente p/ o pr¢ximo n°vel (orig).* */     
        if  tt_demonst_ctbl_fin.tta_cod_unid_organ_filho <> ''
            and not can-find(first tt_retorna_sdo_ctbl_demonst
                where  tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo = "Consolidaá∆o" /*l_consolidacao*/  
                and tt_retorna_sdo_ctbl_demonst.tta_cod_empresa = tt_demonst_ctbl_fin.tta_cod_unid_organ_filho) then
                assign  m_7:SENSITIVE  = NO.

        if  not can-find(first tt_col_demonst_ctbl
            where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
            and   tt_col_demonst_ctbl.ind_orig_val_col_demonst <> "Consolidaá∆o" /*l_consolidacao*/  ) then
            assign  m_6:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* * Se o estabelecimento jˇ foi expandido nas estruturas acima nío permite expandir novamente **/
        if  tt_demonst_ctbl_fin.ttv_log_expand_estab 
        or  tt_demonst_ctbl_fin.ttv_cod_inform_princ = "Estabelecimento" /*l_estabelecimento*/   then
            assign  m_6:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* * Caso o estabelecimento estar definida na estrutura de visualizaá∆o do item do demonstrativo - opá∆o ficar desabilitada
             pois lista todos os estabelecimentos j† na primeira atualizaá∆o. **/  
        if  prefer_demonst_ctbl.cod_demonst_ctbl <> "" and 
            lookup("Estabelecimento" /*l_estabelecimento*/ , v_des_visualiz_aux, chr(10)) <> 0 then     
            assign  m_6:SENSITIVE  = NO
                    m_14:SENSITIVE = NO.

        /* if v_log_exec_orctaria then do:
            case v_cod_campo:
                when 'ttv_cod_campo_1' then
                    assign v_num_coluna = 1.
                when 'ttv_cod_campo_2' then
                    assign v_num_coluna = 2.
                when 'ttv_cod_campo_3' then
                    assign v_num_coluna = 3.
                when 'ttv_cod_campo_4' then
                    assign v_num_coluna = 4.
                when 'ttv_cod_campo_5' then
                    assign v_num_coluna = 5.
                when 'ttv_cod_campo_6' then
                    assign v_num_coluna = 6.
                when 'ttv_cod_campo_7' then
                    assign v_num_coluna = 7.
                when 'ttv_cod_campo_8' then
                    assign v_num_coluna = 8.
                when 'ttv_cod_campo_9' then
                    assign v_num_coluna = 9.
                when 'ttv_cod_campo_10' then
                    assign v_num_coluna = 10.
                when 'ttv_cod_campo_11' then
                    assign v_num_coluna = 11.
                when 'ttv_cod_campo_12' then
                    assign v_num_coluna = 12.
                when 'ttv_cod_campo_13' then
                    assign v_num_coluna = 13.
                when 'ttv_cod_campo_14' then
                    assign v_num_coluna = 14.
                when 'ttv_cod_campo_15' then
                    assign v_num_coluna = 15.
            end.

            find first tt_label_demonst_ctbl_video 
                 where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + v_num_coluna no-error.
            find first tt_col_demonst_ctbl no-lock
                 where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                   and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                 no-error.
            find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.
            if avail col_demonst_ctbl
               and (col_demonst_ctbl.ind_tip_val_sdo_ctbl = @%(l_empenhado)
                    or col_demonst_ctbl.ind_tip_val_sdo_ctbl = @%(l_movto_realiz_mais_empenhado)) then
                assign  m_13:SENSITIVE  = YES.
        end.*/

        /* Habilita "Origem Empenho" caso exista coluna de valor empenhado */
        if v_log_nova_con_sdo_empenh
           and tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho <> ''
           and can-find(first tt_col_demonst_ctbl
                        where tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Empenhado" /*l_empenhado*/ 
                        or    tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Mov + Empenh" /*l_movto_realiz_mais_empenhado*/ ) then
            assign m_13:sensitive  = yes.

        /* Habilita "Movimentaá∆o Oráament†ria" caso exista coluna de valor oráado */ 
/*         if v_log_nova_con_sdo_empenh                                                                         */
/*            and (can-find(first tt_col_demonst_ctbl                                                           */
/*                           where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Oráamento" /*l_orcamento*/ ) */
/*                 OR (prefer_demonst_ctbl.cod_demonst_ctbl = ""                                                */
/*                     AND v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/ )) then                      */
/*             assign  m_14:sensitive  = YES.                                                                   */

    end.
END PROCEDURE. /* pi_habilita_itens_expansao */
/*****************************************************************************
** Procedure Interna.....: pi_contrai_estrutura
** Descricao.............: pi_contrai_estrutura
** Criado por............: bre17752
** Criado em.............: 27/07/2001 15:48:44
** Alterado por..........: its0068
** Alterado em...........: 29/08/2005 09:37:00
*****************************************************************************/
PROCEDURE pi_contrai_estrutura:

    contrai:
    do on error undo contrai, leave contrai:
    disable br_demonst_ctbl_fin with frame f_bas_10_demonst_ctbl_fin.

        assign v_num_seq_ini = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl
               v_num_seq_fim = 0
               v_num_count   = 0
               v_num_nivel   = tt_demonst_ctbl_fin.ttv_num_nivel
               tt_demonst_ctbl_fin.ttv_log_expand       = NO
               tt_demonst_ctbl_fin.ttv_log_expand_usuar = NO           
               v_rec_item_demonst_ctbl_video            = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
               v_rec_demonst_ctbl_video                 = recid(tt_demonst_ctbl_fin).

        /* * L¢gica para reposicionar item expandido **/
        assign v_num_pos = br_demonst_ctbl_fin:focused-row in frame f_bas_10_demonst_ctbl_fin.
        if  v_num_pos <> ? then
            assign v_log_status = br_demonst_ctbl_fin:set-repositioned-row(v_num_pos, 'conditional':U) in frame f_bas_10_demonst_ctbl_fin.

        BLOCK:
        for each btt_demonst_ctbl_fin no-lock
            where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl > v_num_seq_ini:
            if   btt_demonst_ctbl_fin.ttv_num_nivel = v_num_nivel
            or   btt_demonst_ctbl_fin.ttv_num_nivel < v_num_nivel then
                 LEAVE BLOCK.
            assign v_num_seq_fim = btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl + 10.
        end.

        erase:
        for each tt_demonst_ctbl_fin
            where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl > v_num_seq_ini
              and tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < v_num_seq_fim :

            find first tt_item_demonst_ctbl_video
                where  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                no-error.
            if  avail tt_item_demonst_ctbl_video then do:
                for each tt_relacto_item_retorna
                   where tt_relacto_item_retorna.tta_num_seq             = 0
                   and   tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                    delete tt_relacto_item_retorna.
                end.
                for each tt_valor_demonst_ctbl_video
                   where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video):
                    delete tt_valor_demonst_ctbl_video.
                end.
                DELETE tt_item_demonst_ctbl_video.
            end.
            DELETE tt_demonst_ctbl_fin.

            assign v_num_count = v_num_count + 10.
        end /* for erase */.

        if  v_num_seq_fim <> ?
        then do:
            assign v_num_seq_ini = v_num_seq_ini + v_num_count.
            decrease:
            repeat preselect each tt_demonst_ctbl_fin use-index tt_id:
                 find next tt_demonst_ctbl_fin
                      where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl > v_num_seq_ini.
                 assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl - v_num_count.
            end /* repeat decrease */.
        end /* if */.

        enable br_demonst_ctbl_fin with frame f_bas_10_demonst_ctbl_fin.
    end /* do contrai */.

END PROCEDURE. /* pi_contrai_estrutura */
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
** Procedure Interna.....: pi_razao_contabil_demonst
** Descricao.............: pi_razao_contabil_demonst
** Criado por............: bre17752
** Criado em.............: 30/07/2001 04:21:05
** Alterado por..........: fut41455
** Alterado em...........: 19/02/2008 11:27:47
*****************************************************************************/
PROCEDURE pi_razao_contabil_demonst: 

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_opc
        as character
        format "x(15)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_ano_aux
        as integer
        format "9999":U
        initial 0001
        label "atÇ"
        no-undo.
    def var v_num_mes_aux
        as integer
        format "99":U
        initial 01
        no-undo.
    def var v_num_resto
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/
       
    If session:set-wait-state ("General" /*l_general*/ ) then.

    if  v_cod_demonst_ctbl <> '' then
        FIND FIRST conjto_prefer_demonst NO-LOCK
            WHERE conjto_prefer_demonst.cod_usuario = v_cod_usuar_corren
              AND conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
              AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
              AND conjto_prefer_demonst.num_conjto_param_ctbl     = v_num_conjto_param_ctbl
              NO-ERROR.
    else
        FIND FIRST conjto_prefer_demonst NO-LOCK
            WHERE conjto_prefer_demonst.cod_usuario = v_cod_usuar_corren
              AND conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
              AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
              NO-ERROR.

    FIND cenar_ctbl NO-LOCK
        WHERE cenar_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl NO-ERROR.

    if  v_cod_demonst_ctbl <> '' then do:
        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = prefer_demonst_ctbl.cod_exerc_ctbl NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl = prefer_demonst_ctbl.num_period_ctbl NO-ERROR.
        assign v_num_ano_aux  = integer(prefer_demonst_ctbl.cod_exerc_ctbl)
               v_num_mes_aux  = prefer_demonst_ctbl.num_period_ctbl.
    end.
    else do:
        &if '{&emsfin_version}' > '5.05' &then
            assign v_cod_exec_period_1 = conjto_prefer_demonst.cod_exerc_period_1.
        &else
            assign v_cod_exec_period_1 = string(year(conjto_prefer_demonst.dat_livre_1),'9999') +
                                         string(month(conjto_prefer_demonst.dat_livre_1),'99').
        &endif

        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(substr(v_cod_exec_period_1,1,4),'9999') NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl =  int(STRING(substr(v_cod_exec_period_1,5,2),'99')) NO-ERROR.
        assign v_num_ano_aux = integer(string(substr(v_cod_exec_period_1,1,4),'9999'))
               v_num_mes_aux = int(STRING(substr(v_cod_exec_period_1,5,2),'99')).
    end.


    run pi_definir_periodo_razao.
    if v_num_ano <> 0 or v_num_mes <> 0 then do:
       if v_cod_aux_3 = "+" then do:
          assign v_num_ano_aux = v_num_ano_aux + v_num_ano
                 v_num_mes_aux = v_num_mes_aux + v_num_mes.
          if v_num_mes_aux > 12  then do:
              assign v_num_mes_aux = v_num_mes_aux - 12.
              if v_num_ano = 0 then
                 assign v_num_ano_aux = v_num_ano_aux + 1.
          end.
       end.
       else do:
          assign v_num_ano_aux = v_num_ano_aux - v_num_ano
                 v_num_mes_aux = v_num_mes_aux - v_num_mes.
          if v_num_mes_aux <= 0 then do:
             assign v_num_mes_aux = 12 + v_num_mes_aux.
             if v_num_ano = 0 then 
                assign v_num_ano_aux = v_num_ano_aux - 1.
          end.
       end.

       FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(v_num_ano_aux) NO-ERROR.
       FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = string(v_num_ano_aux)
              AND period_ctbl.num_period_ctbl = v_num_mes_aux NO-ERROR.

    end.      

    FIND plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
        NO-ERROR.
    FIND cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
          AND cta_ctbl.cod_cta_ctbl = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho NO-ERROR.
    FIND finalid_econ NO-LOCK
        WHERE finalid_econ.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ
        NO-ERROR.

    ASSIGN v_cod_cenar_ctbl_ini   = cenar_ctbl.cod_cenar_ctbl
           v_cod_finalid_econ_ini = finalid_econ.cod_finalid_econ
           v_cod_finalid_econ_fim = conjto_prefer_demonst.cod_finalid_econ_apres
           v_cod_unid_negoc_ini   = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ""
                                    then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
                                    else conjto_prefer_demonst.cod_unid_negoc_inic
           v_cod_unid_negoc_fim   = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ""
                                    then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
                                    else conjto_prefer_demonst.cod_unid_negoc_fim
           v_cod_estab_ini        = if tt_demonst_ctbl_fin.tta_cod_estab <> ""
                                    then tt_demonst_ctbl_fin.tta_cod_estab
                                    else conjto_prefer_demonst.cod_estab_inic
           v_cod_estab_fim        = if tt_demonst_ctbl_fin.tta_cod_estab <> ""
                                    then tt_demonst_ctbl_fin.tta_cod_estab
                                    else conjto_prefer_demonst.cod_estab_fim
           v_rec_cenar_ctbl       = RECID(cenar_ctbl)
           v_rec_exerc_ctbl       = RECID(exerc_ctbl)
           v_rec_period_ctbl_ini  = RECID(period_ctbl)
           v_rec_plano_cta_ctbl   = RECID(plano_cta_ctbl)
           v_rec_cta_ctbl         = RECID(cta_ctbl)
           v_rec_finalid_econ     = RECID(finalid_econ)
           v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_acum_cta_ctbl_sint.

    if  p_cod_opc = "Cta Ctbl" /*l_cta_ctbl*/ 
    then do:
        if tt_demonst_ctbl_fin.ttv_cod_inform_princ = "UO Origem" /*l_uo_origem*/ 
           and avail tt_demonst_ctbl_fin then do:
           assign v_cod_unid_organizacional = tt_demonst_ctbl_fin.tta_cod_unid_organ_filho.
        end.
        else do:
           assign v_cod_unid_organizacional = ''.
        end.           
        if  search("prgfin/fgl/escf0208.r") = ? and search("prgfin/fgl/escf0208.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl208aa.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl208aa.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fgl/escf0208.p /*prg_bas_cta_ctbl_razao*/.
    END.
    else do:

        FIND plano_ccusto NO-LOCK
            WHERE plano_ccusto.cod_empresa      = tt_compos_demonst_cadastro.cod_unid_organ
            AND   plano_ccusto.cod_plano_ccusto = tt_compos_demonst_cadastro.cod_plano_ccusto
            NO-ERROR.
        FIND emscad.ccusto NO-LOCK
            WHERE ccusto.cod_empresa    = plano_ccusto.cod_empresa
              and ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
              AND ccusto.cod_ccusto =  substring(v_cod_demonst_ctbl, 1, 4) /* tt_demonst_ctbl_fin.tta_cod_ccusto_filho */ NO-ERROR.

        ASSIGN v_rec_plano_ccusto = RECID(plano_ccusto)
               v_rec_ccusto = RECID(ccusto).

        if  search("prgfin/fgl/escf0209.r") = ? and search("prgfin/fgl/escf0209.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl209aa.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl209aa.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fgl/escf0209.p /*prg_bas_ccusto_razao*/.
    END.


    /* --- Recupera valores para a faixa de UN ---*/
    ASSIGN v_cod_unid_negoc_ini = v_cod_unid_negoc_subst_inic
           v_cod_unid_negoc_fim = v_cod_unid_negoc_subst_fim.


END PROCEDURE. /* pi_razao_contabil_demonst */
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
** Procedure Interna.....: pi_bt_atz_demonst
** Descricao.............: pi_bt_atz_demonst
** Criado por............: bre17752
** Criado em.............: 23/08/2001 10:43:24
** Alterado por..........: fut12209
** Alterado em...........: 24/02/2009 13:44:55
*****************************************************************************/
PROCEDURE pi_bt_atz_demonst:

        if v_cod_arq <> "" then do:
          output to value(v_cod_arq) append.
          put skip(1)  '<< In°cio bt atualiza >> ' string(time,'hh:mm:ss')  skip.
          output close.
        end.

        EMPTY TEMP-TABLE tt_exec_rpc.

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

        assign v_log_abert_ccusto = no.

        If session:set-wait-state ("General" /*l_general*/  ) then.

        /* Elimina temp-tables*/
        EMPTY TEMP-TABLE tt_item_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_label_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_valor_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_demonst_ctbl_fin.
        EMPTY TEMP-TABLE tt_item_demonst_ctbl_cadastro.
        EMPTY TEMP-TABLE tt_compos_demonst_cadastro.
        EMPTY TEMP-TABLE tt_estrut_visualiz_ctbl_cad.
        EMPTY TEMP-TABLE tt_col_demonst_ctbl.
        EMPTY TEMP-TABLE tt_acumul_demonst_cadastro.
        EMPTY TEMP-TABLE tt_just_resumo.
        EMPTY TEMP-TABLE tt_just_totaliza.

        if  avail prefer_demonst_ctbl
        and  prefer_demonst_ctbl.cod_demonst_ctbl = ""
        then do: /* Se for Consultas de Saldo */
            run pi_prefer_demonst_ctbl /*pi_prefer_demonst_ctbl*/.
        end.

        /* * Para limpar as informaªÑes do Browse **/
        open query qr_demonst_ctbl_fin for
             each  tt_demonst_ctbl_fin.

        &if integer(entry(1,proversion,'.')) >= 8 &then 
            &if '{&emsbas_version}' > '1.00' &then
                /* * COLOCADO COMO COMENTARIO, PORQUE ESTA OCORRENTE ERRO DE PASSAGE DE PARAMETRO ATRAVEZ DE TEMP-TABLE
                    NEW SHARED QUANDO EXECUTADO VIA RPC, SOLICITAÄ«O FEITA POR RAFAEL LIMA.  ALTERADO POR NEVES 15/01/2004
                /* Begin_Include: i_exec_initialize_rpc */
                if  not valid-handle(v_wgh_servid_rpc)
                or v_wgh_servid_rpc:type <> 'procedure':U
                or v_wgh_servid_rpc:file-name <> 'prgtec/btb/btb008za.py':U
                then do:
                    run prgtec/btb/btb008za.py persistent set v_wgh_servid_rpc (input 1).
                end /* if */.

                run pi_connect in v_wgh_servid_rpc ('api_demonst_ctbl_video':U, '', yes).
                /* end_Include: i_exec_initialize_rpc */

                if  rpc_exec('api_demonst_ctbl_video':U)
                then do:

                    rpc_exec_set('api_demonst_ctbl_video':U,yes).
                    rpc_block:
                    repeat while rpc_exec('api_demonst_ctbl_video':U) on stop undo rpc_block, retry rpc_block:
                        if  rpc_program('api_demonst_ctbl_video':U) = ?
                        then do: 
                           leave rpc_block.        
                        end /* if */.
                        if  retry
                        then do:
                            run pi_status_error in v_wgh_servid_rpc.
                            next rpc_block.
                        end /* if */.
                        if  rpc_tip_exec('api_demonst_ctbl_video':U)
                        then do:
                            run pi_check_server in v_wgh_servid_rpc ('api_demonst_ctbl_video':U).
                            if  return-value = 'yes'
                            then do:
                                if  rpc_program('api_demonst_ctbl_video':U) <> ?
                                then do:
                                    if  '1,input table tt_exec_rpc,
                                         output v_des_lista_estab' = '""'
                                    then do:
                                        &if '""' = '""' &then
                                            run value(rpc_program('api_demonst_ctbl_video':U)) on rpc_server('api_demonst_ctbl_video':U) transaction distinct no-error.
                                        &else
                                            run value(rpc_program('api_demonst_ctbl_video':U)) persistent set "" on rpc_server('api_demonst_ctbl_video':U) transaction distinct no-error.
                                        &endif
                                    end /* if */.
                                    else do:
                                        &if '""' = '""' &then
                                            run value(rpc_program('api_demonst_ctbl_video':U)) on rpc_server('api_demonst_ctbl_video':U) transaction distinct (1,input table tt_exec_rpc,
                                         output v_des_lista_estab) no-error.
                                        &else
                                            run value(rpc_program('api_demonst_ctbl_video':U)) persistent set "" on rpc_server('api_demonst_ctbl_video':U) transaction distinct (1,input table tt_exec_rpc,
                                         output v_des_lista_estab) no-error.
                                        &endif
                                    end /* else */.
                                end /* if */.    
                            end /* if */.
                            else do:
                                next rpc_block.
                            end /* else */.
                        end /* if */.
                        else do:
                            if  rpc_program('api_demonst_ctbl_video':U) <> ?
                            then do: 
                                if  '1,input table tt_exec_rpc,
                                         output v_des_lista_estab' = '""'
                                then do:
                                    &if '""' = '""' &then 
                                        run value(rpc_program('api_demonst_ctbl_video':U)) no-error.
                                    &else
                                        run value(rpc_program('api_demonst_ctbl_video':U)) persistent set "" no-error.
                                    &endif
                                end /* if */.
                                else do:
                                    &if '""' = '""' &then 
                                        run value(rpc_program('api_demonst_ctbl_video':U)) (1,input table tt_exec_rpc,
                                         output v_des_lista_estab) no-error.
                                    &else
                                        run value(rpc_program('api_demonst_ctbl_video':U)) persistent set "" (1,input table tt_exec_rpc,
                                         output v_des_lista_estab) no-error.
                                    &endif
                                end /* else */.
                            end /* if */.        
                        end /* else */.

                        run pi_status_error in v_wgh_servid_rpc.
                    end /* repeat rpc_block */.
                    /* end_Include: i_exec_dispatch_rpc */

                end /* if */.

                run pi_destroy_rpc in v_wgh_servid_rpc ('api_demonst_ctbl_video':U).

                &if '""' <> '""' &then
                    if  valid-handle("") then
                        delete procedure "".
                &endif

                if  valid-handle(v_wgh_servid_rpc) then
                    delete procedure v_wgh_servid_rpc.
                ***/
                run prgfin/mgl/escg0204za.py(1,input table tt_exec_rpc,output v_des_lista_estab,output table tt_log_erros) no-error.

/*              FOR EACH tt_retorna_sdo_ctbl_demonst:                                                                                                                                  */
/*                                  CREATE  tt_just_resumo.                                                                                                                            */
/*                     ASSIGN  tt_just_resumo.tta_num_seq                              = tt_retorna_sdo_ctbl_demonst.tta_num_seq                                                       */
/*                             tt_just_resumo.tta_cod_empresa                          = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa                                                   */
/*                             tt_just_resumo.tta_cod_finalid_econ                     = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ                                              */
/*                             tt_just_resumo.tta_cod_plano_cta_ctbl                   = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl                                            */
/*                             tt_just_resumo.tta_cod_cta_ctbl                         = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl                                                  */
/*                             tt_just_resumo.tta_cod_plano_ccusto                     = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto                                              */
/*                             tt_just_resumo.tta_cod_ccusto                           = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto                                                    */
/*                             tt_just_resumo.tta_cod_cenar_ctbl                       = tt_retorna_sdo_ctbl_demonst.tta_cod_cenar_ctbl                                                */
/*                             tt_just_resumo.tta_cod_estab                            = tt_retorna_sdo_ctbl_demonst.tta_cod_estab                                                     */
/*                             tt_just_resumo.tta_cod_unid_negoc                       = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc                                                */
/*                             tt_just_resumo.tta_dat_sdo_ctbl                         = tt_retorna_sdo_ctbl_demonst.tta_dat_sdo_ctbl                                                  */
/*                             tt_just_resumo.tta_cod_unid_organ_orig                  = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig                                           */
/*                             tt_just_resumo.ttv_ind_espec_sdo                        = tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo                                                 */
/*                             tt_just_resumo.tta_val_sdo_ctbl_db                      = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db                                               */
/*                             tt_just_resumo.tta_val_sdo_ctbl_cr                      = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr                                               */
/*                             tt_just_resumo.tta_val_sdo_ctbl_fim                     = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim                                              */
/*                             tt_just_resumo.tta_val_apurac_restdo                    = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo                                             */
/*                             tt_just_resumo.tta_val_apurac_restdo_db                 = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db                                          */
/*                             tt_just_resumo.tta_val_apurac_restdo_cr                 = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr                                          */
/*                             tt_just_resumo.tta_val_apurac_restdo_acum               = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum                                        */
/*                             tt_just_resumo.tta_val_movto_empenh                     = tt_retorna_sdo_ctbl_demonst.tta_val_movto_empenh                                              */
/*                             tt_just_resumo.ttv_val_movto_ctbl                       = tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl                                                */
/*                             tt_just_resumo.tta_val_orcado                           = tt_retorna_sdo_ctbl_demonst.tta_val_orcado                                                    */
/*                             tt_just_resumo.tta_val_orcado_sdo                       = tt_retorna_sdo_ctbl_demonst.tta_val_orcado_sdo                                                */
/*                             tt_just_resumo.ttv_rec_ret_sdo_ctbl                     = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl                                              */
/*                             tt_just_resumo.ttv_log_sdo_orcado_sint                  = tt_retorna_sdo_ctbl_demonst.ttv_log_sdo_orcado_sint                                           */
/*                             tt_just_resumo.ttv_val_perc_criter_distrib              = tt_retorna_sdo_ctbl_demonst.ttv_val_perc_criter_distrib                                       */
/*                             tt_just_resumo.ttv_concatena                            = (tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl + tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto).  */
/*                                                                                                                                                                                     */
/*                 END.                                                                                                                                                                */
/*                                                                                                                                                                                     */
/*                                                                                                                                                                                     */
/*                 FOR EACH tt_just_resumo NO-LOCK BREAK BY tt_just_resumo.ttv_concatena:                                                                                              */
/*                                                                                                                                                                                     */
/*                     ACCUMULATE tt_just_resumo.ttv_val_movto_ctbl (SUB-TOTAL BY tt_just_resumo.ttv_concatena).                                                                       */
/*                                                                                                                                                                                     */
/*                     IF LAST-OF (tt_just_resumo.ttv_concatena) THEN DO:                                                                                                              */
/*                                                                                                                                                                                     */
/*                         CREATE tt_just_totaliza.                                                                                                                                    */
/*                         ASSIGN tt_just_totaliza.tta_num_seq                            = tt_just_resumo.tta_num_seq                                                                 */
/*                                tt_just_totaliza.tta_cod_empresa                        = tt_just_resumo.tta_cod_empresa                                                             */
/*                                tt_just_totaliza.tta_cod_finalid_econ                   = tt_just_resumo.tta_cod_finalid_econ                                                        */
/*                                tt_just_totaliza.tta_cod_plano_cta_ctbl                 = tt_just_resumo.tta_cod_plano_cta_ctbl                                                      */
/*                                tt_just_totaliza.tta_cod_cta_ctbl                       = tt_just_resumo.tta_cod_cta_ctbl                                                            */
/*                                tt_just_totaliza.tta_cod_plano_ccusto                   = tt_just_resumo.tta_cod_plano_ccusto                                                        */
/*                                tt_just_totaliza.tta_cod_ccusto                         = tt_just_resumo.tta_cod_ccusto                                                              */
/*                                tt_just_totaliza.tta_cod_cenar_ctbl                     = tt_just_resumo.tta_cod_cenar_ctbl                                                          */
/*                                tt_just_totaliza.tta_cod_estab                          = tt_just_resumo.tta_cod_estab                                                               */
/*                                tt_just_totaliza.tta_cod_unid_negoc                     = tt_just_resumo.tta_cod_unid_negoc                                                          */
/*                                tt_just_totaliza.tta_dat_sdo_ctbl                       = tt_just_resumo.tta_dat_sdo_ctbl                                                            */
/*                                tt_just_totaliza.tta_cod_unid_organ_orig                = tt_just_resumo.tta_cod_unid_organ_orig                                                     */
/*                                tt_just_totaliza.ttv_ind_espec_sdo                      = tt_just_resumo.ttv_ind_espec_sdo                                                           */
/*                                tt_just_totaliza.tta_val_sdo_ctbl_db                    = tt_just_resumo.tta_val_sdo_ctbl_db                                                         */
/*                                tt_just_totaliza.tta_val_sdo_ctbl_cr                    = tt_just_resumo.tta_val_sdo_ctbl_cr                                                         */
/*                                tt_just_totaliza.tta_val_sdo_ctbl_fim                   = tt_just_resumo.tta_val_sdo_ctbl_fim                                                        */
/*                                tt_just_totaliza.tta_val_apurac_restdo                  = tt_just_resumo.tta_val_apurac_restdo                                                       */
/*                                tt_just_totaliza.tta_val_apurac_restdo_db               = tt_just_resumo.tta_val_apurac_restdo_db                                                    */
/*                                tt_just_totaliza.tta_val_apurac_restdo_cr               = tt_just_resumo.tta_val_apurac_restdo_cr                                                    */
/*                                tt_just_totaliza.tta_val_apurac_restdo_acum             = tt_just_resumo.tta_val_apurac_restdo_acum                                                  */
/*                                tt_just_totaliza.tta_val_movto_empenh                   = tt_just_resumo.tta_val_movto_empenh                                                        */
/*                                tt_just_totaliza.ttv_val_movto_ctbl                     = ACCUM SUB-TOTAL BY tt_just_resumo.ttv_concatena tt_just_resumo.ttv_val_movto_ctbl          */
/*                                tt_just_totaliza.tta_val_orcado                         = tt_just_resumo.tta_val_orcado                                                              */
/*                                tt_just_totaliza.tta_val_orcado_sdo                     = tt_just_resumo.tta_val_orcado_sdo                                                          */
/*                                tt_just_totaliza.ttv_rec_ret_sdo_ctbl                   = tt_just_resumo.ttv_rec_ret_sdo_ctbl                                                        */
/*                                tt_just_totaliza.ttv_log_sdo_orcado_sint                = tt_just_resumo.ttv_log_sdo_orcado_sint                                                     */
/*                                tt_just_totaliza.ttv_val_perc_criter_distrib            = tt_just_resumo.ttv_val_perc_criter_distrib.                                                */
/*                                                                                                                                                                                     */
/*                                                                                                                                                                                     */
/*                     END.                                                                                                                                                            */
/*                                                                                                                                                                                     */
/*                 END.                                                                                                                                                                */

                EMPTY TEMP-TABLE tt_just_resumo.


/*                 FIND LAST regra_calc_var_orcto NO-LOCK NO-ERROR.  */
/*                                                                   */
/*                 IF AVAIL regra_calc_var_orcto THEN DO:            */
                    
/*                     ASSIGN v_var_ccusto = regra_calc_var_orcto.val_perc_var_ccusto           */
/*                            v_var_ccusto_neg = regra_calc_var_orcto.val_perc_var_ccusto_neg.  */
/*                                                                                              */
/*                 END.                                                                         */




            &endif.
        &endif.

        If session:set-wait-state ("") then.

        if not v_cod_dwb_user begins 'es_' then do:
            run pi_wait_processing (Input "Imprimindo..." /*l_imprimindo_2*/ ,
                                    Input "Imprimindo..." /*l_imprimindo_2*/ ).

            disable bt_can2 with frame f_dlg_02_wait_processing.
        end.

        /* *Posiciona Demosntrativo para criar T≠tulo**/
        if  avail prefer_demonst_ctbl
        and prefer_demonst_ctbl.cod_demonst_ctbl <> "" then do:
            find demonst_ctbl no-lock where recid(demonst_ctbl) = v_rec_demonst_ctbl no-error.
            assign v_cod_demonst_ctbl   = demonst_ctbl.cod_demonst_ctbl
                   v_cod_plano_cta_ctbl = demonst_ctbl.cod_plano_cta_ctbl
                   v_cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl.
        end.
        else do:
            assign v_cod_demonst_ctbl   = ""
                   v_cod_padr_col_demonst_ctbl = "".
            &if '{&emsfin_version}' = '5.05' &then     
                assign v_cod_plano_cta_ctbl = entry(5,prefer_demonst_ctbl.cod_livre_1,chr(10)).
            &else
                assign v_cod_plano_cta_ctbl = prefer_demonst_ctbl.cod_plano_cta_ctbl.
            &endif
        end.

        if  br_demonst_ctbl_fin:width-chars  in frame f_bas_10_demonst_ctbl_fin = 112
        then do:

            /* Begin_Include: i_demonst_ctbl_fin_titulo_browse */
            if  avail demonst_ctbl and prefer_demonst_ctbl.cod_demonst_ctbl <> "" then
                assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string(demonst_ctbl.des_tit_ctbl,'x(115)') + "Per°odo de Referància:" /*l_periodo_referencia*/    + ' ' +
                       STRING(prefer_demonst_ctbl.num_period_ctbl,'99') + '/' + STRING(prefer_demonst_ctbl.cod_exerc_ctbl,'9999').
            else do:
                /* Posiciona registro no Conjto Prefer da Consulta */
                find first conjto_prefer_demonst no-lock
                    where conjto_prefer_demonst.cod_usuario      = v_cod_usuar_corren
                      and conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
                      and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl no-error.
                if  avail conjto_prefer_demonst then do:
                    &if '{&emsfin_version}' = '5.05' &then
                         assign v_cod_exerc_period_1 =  string(month(conjto_prefer_demonst.dat_livre_1),'99')  + chr(47)
                                                      + string(year(conjto_prefer_demonst.dat_livre_1),'9999') + chr(32)
                                v_cod_exerc_period_2 =  string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'99') + chr(47)
                                                      + string(string( year(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10))))),'9999').
                    &else
                        assign v_cod_exerc_period_1 = conjto_prefer_demonst.cod_exerc_period_1
                               v_cod_exerc_period_2 = conjto_prefer_demonst.cod_exerc_period_2.
                    &endif
                end.

                if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/   then
                    assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string("Consulta" /*l_consulta*/   + chr(32) + v_ind_selec_tip_demo + chr(58) + v_ind_tip_sdo_ctbl_demo
                           + chr(32) + chr(45) + chr(32) + v_cod_unid_organ,'x(95)') + "Per°odo de Referància:" /*l_periodo_referencia*/   + chr(32) 
                           + v_cod_exerc_period_1
                           + "E" /*l_e*/   + chr(32)
                           + v_cod_exerc_period_2.
                else /* Orªamento ou Sdo/Movimento */
                    assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string("Consulta" /*l_consulta*/   + chr(32) + v_ind_selec_tip_demo + chr(58) + v_ind_tip_sdo_ctbl_demo
                           + chr(32) + chr(45) + chr(32) + v_cod_unid_organ,'x(115)') + "Per°odo de Referància:" /*l_periodo_referencia*/    
                           + chr(32) + v_cod_exerc_period_1.
            end.
        end.
        else do:

            if  avail demonst_ctbl and prefer_demonst_ctbl.cod_demonst_ctbl <> "" then
                assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string(demonst_ctbl.des_tit_ctbl,'x(75)') + "Per°odo de Referància:" /*l_periodo_referencia*/    + ' ' +
                       STRING(prefer_demonst_ctbl.num_period_ctbl,"99") + '/' + STRING(prefer_demonst_ctbl.cod_exerc_ctbl,"9999").
            else do:
                /* Posiciona registro no Conjto Prefer da Consulta */
                find first conjto_prefer_demonst no-lock
                    where conjto_prefer_demonst.cod_usuario      = v_cod_usuar_corren
                      and conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
                      and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl no-error.
                if  avail conjto_prefer_demonst then do:
                    &if '{&emsfin_version}' = '5.05' &then
                         assign v_cod_exerc_period_1 =  string(month(conjto_prefer_demonst.dat_livre_1),'99')  + chr(47)
                                                      + string(year(conjto_prefer_demonst.dat_livre_1),'9999') + chr(32)
                                v_cod_exerc_period_2 =  string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'99') + chr(47)
                                                      + string(string( year(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10))))),'9999').
                    &else
                        assign v_cod_exerc_period_1 = conjto_prefer_demonst.cod_exerc_period_1
                               v_cod_exerc_period_2 = conjto_prefer_demonst.cod_exerc_period_2.
                    &endif
                end.

                if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/   then
                    assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string("Consulta" /*l_consulta*/   + chr(32) + v_ind_selec_tip_demo + chr(58) + v_ind_tip_sdo_ctbl_demo
                           + chr(32) + chr(45) + chr(32) + v_cod_unid_organ,'x(60)') + "Per°odo de Referància:" /*l_periodo_referencia*/   + chr(32) 
                           + v_cod_exerc_period_1
                           + "E" /*l_e*/   + chr(32)
                           + v_cod_exerc_period_2.
                else 
                    assign br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = string("Consulta" /*l_consulta*/   + chr(32) + v_ind_selec_tip_demo + chr(58) + v_ind_tip_sdo_ctbl_demo
                           + chr(32) + chr(45) + chr(32) + v_cod_unid_organ,'x(75)') + "Per°odo de Referància:" /*l_periodo_referencia*/    
                           + chr(32) + v_cod_exerc_period_1.
            end.
         end.

        /* *Inicializa variˇvel utilizada para montar labels das colunas**/
        assign v_num_col = 0.

        /* *Atualiza variˇvel com valor mˇximo que coluna pode correr**/
        find LAST tt_label_demonst_ctbl_video no-error.
        if not avail tt_label_demonst_ctbl_video then do:
           assign  bt_fir:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                   bt_pre1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                   bt_nex1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                   bt_las:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO .
        end.    
        else do:
          assign v_num_col_max = tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl - 1
                 bt_fir:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = yes
                 bt_pre1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = yes
                 bt_nex1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = yes
                 bt_las:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = yes .
          if tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl <= 15 then
             assign  bt_fir:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                     bt_pre1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                     bt_nex1:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO
                     bt_las:SENSITIVE in frame f_bas_10_demonst_ctbl_fin = NO .
          else do:
             /* Utilizar os bot‰es primeiro/anterior/pr¢ximo/£ltimo. */
             run pi_messages (input "show",
                              input 18728,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_18728*/.
          end.
        end.       
        run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.


        if v_cod_arq <> "" then do:
          output to value(v_cod_arq) append.
          put skip(1)  '<< Fim bt atualiza >> ' string(time,'hh:mm:ss')  skip.
          output close.
        end.

        /* Trava a primeira coluna caso seja de titulo */
        if v_num_lin_tit = 1 then
            assign BROWSE br_demonst_ctbl_fin:NUM-LOCKED-COLUMNS = 1.
        else
            assign BROWSE br_demonst_ctbl_fin:NUM-LOCKED-COLUMNS = 0.

        /* Begin_Include: i_exec_program_epc */
        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then
        do:
            assign v_rec_table_epc = recid(demonst_ctbl).    
            run value(v_nom_prog_upc) (input 'BT_DIREITO',
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        if  v_nom_prog_appc <> '' then
        do:
            assign v_rec_table_epc = recid(demonst_ctbl).    
            run value(v_nom_prog_appc) (input 'BT_DIREITO',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_dpc <> '' then
        do:
            assign v_rec_table_epc = recid(demonst_ctbl).    
            run value(v_nom_prog_dpc) (input 'BT_DIREITO',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'no' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.
        &endif
        &endif

END PROCEDURE. /* pi_bt_atz_demonst */
/*****************************************************************************
** Procedure Interna.....: pi_prefer_demonst_ctbl
** Descricao.............: pi_prefer_demonst_ctbl
** Criado por............: Dalpra
** Criado em.............: 24/07/2001 19:02:04
** Alterado por..........: fut1236
** Alterado em...........: 05/12/2003 15:12:39
*****************************************************************************/
PROCEDURE pi_prefer_demonst_ctbl:

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_prefer_excec
        as character
        format "x(11)":U
        label "Exceá∆o"
        no-undo.
    def var v_cod_ccusto_prefer_pfixa
        as character
        format "x(11)":U
        label "Parte Fixa"
        no-undo.
    def var v_cod_tipo                       as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    EMPTY TEMP-TABLE tt_item_demonst_ctbl_cadastro.
    EMPTY TEMP-TABLE tt_compos_demonst_cadastro.
    EMPTY TEMP-TABLE tt_col_demonst_ctbl.
    EMPTY TEMP-TABLE tt_estrut_visualiz_ctbl_cad.
    EMPTY TEMP-TABLE tt_acumul_demonst_cadastro.

    find first conjto_prefer_demonst no-lock
        where  conjto_prefer_demonst.cod_usuario               = prefer_demonst_ctbl.cod_usuario
        and    conjto_prefer_demonst.cod_demonst_ctbl          = ''
        and    conjto_prefer_demonst.cod_padr_col_demonst_ctbl = ''
        no-error.
    if  avail conjto_prefer_demonst then do:
        create tt_item_demonst_ctbl_cadastro.
        assign tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl              = ''
               tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl          = 10
               tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst           = "Valor" /*l_valor*/  
               tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst        = "Valor Conta" /*l_valor_conta*/  
               tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad = recid(tt_item_demonst_ctbl_cadastro).

        create tt_compos_demonst_cadastro.
        assign tt_compos_demonst_cadastro.cod_demonst_ctbl            = ''
               tt_compos_demonst_cadastro.num_seq_compos_demonst      = 10
               tt_compos_demonst_cadastro.num_seq_demonst_ctbl        = 10
               tt_compos_demonst_cadastro.cod_unid_organ              = v_cod_unid_organ
               tt_compos_demonst_cadastro.cod_unid_organ_fim          = v_cod_unid_organ    
               tt_compos_demonst_cadastro.cod_plano_cta_ctbl          = v_cod_plano_cta_ctbl
               tt_compos_demonst_cadastro.cod_cta_ctbl_inic           = conjto_prefer_demonst.cod_cta_ctbl_inic
               tt_compos_demonst_cadastro.cod_cta_ctbl_fim            = conjto_prefer_demonst.cod_cta_ctbl_fim
               tt_compos_demonst_cadastro.cod_estab_inic              = conjto_prefer_demonst.cod_estab_inic
               tt_compos_demonst_cadastro.cod_estab_fim               = conjto_prefer_demonst.cod_estab_fim
               tt_compos_demonst_cadastro.cod_unid_negoc_inic         = conjto_prefer_demonst.cod_unid_negoc_inic
               tt_compos_demonst_cadastro.cod_unid_negoc_fim          = conjto_prefer_demonst.cod_unid_negoc_fim
               tt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid   = "Primeiro N°vel" /*l_primeiro_nivel*/  
               tt_compos_demonst_cadastro.log_ccusto_sint             = yes.

        &if '{&emsfin_version}' = '5.05' &then
            find first tab_livre_emsfin exclusive-lock
               where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/  
               and   tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
               and   tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
               no-error.
           if  avail tab_livre_emsfin then
               assign tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial  = entry(1, tab_livre_emsfin.cod_livre_1, chr(10))
                      tt_compos_demonst_cadastro.cod_proj_financ_fim          = entry(2, tab_livre_emsfin.cod_livre_1, chr(10))
                      tt_compos_demonst_cadastro.tta_cod_proj_financ_excec    = entry(3, tab_livre_emsfin.cod_livre_1, chr(10))
                      tt_compos_demonst_cadastro.cod_proj_financ_pfixa        = entry(4, tab_livre_emsfin.cod_livre_1, chr(10)).
        &else
            assign tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial = conjto_prefer_demonst.cod_proj_financ_inicial
                   tt_compos_demonst_cadastro.cod_proj_financ_fim         = conjto_prefer_demonst.cod_proj_financ_fim
                   tt_compos_demonst_cadastro.tta_cod_proj_financ_excec   = conjto_prefer_demonst.cod_proj_financ_excec
                   tt_compos_demonst_cadastro.cod_proj_financ_pfixa       = conjto_prefer_demonst.cod_proj_financ_pfixa.
        &endif

        create tt_item_demonst_ctbl_cadastro.
        assign tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl              = ''
               tt_item_demonst_ctbl_cadastro.des_tit_ctbl                  = "Total Composiá∆o" /*l_tot_composicao*/  
               tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl          = 20
               tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst           = "Valor" /*l_valor*/  
               tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst        = "F¢rmula" /*l_formula*/  
               tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad = recid(tt_item_demonst_ctbl_cadastro).

        if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/   
        or  v_ind_selec_tip_demo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/   then do:


            /* --- Formato CCusto ---*/
            find first plano_ccusto no-lock
                where plano_ccusto.cod_empresa      = v_cod_unid_organ /* v_cod_empres_usuar RAFA*/
                and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto no-error.
            if  avail plano_ccusto
            then do:
                assign v_cod_ccusto_prefer_pfixa = fill('#', length(plano_ccusto.cod_format_ccusto))
                       v_cod_ccusto_prefer_excec = fill('#', length(plano_ccusto.cod_format_ccusto)).
            end.

            &if '{&emsfin_version}' = '5.05' &then
               if  avail tab_livre_emsfin then
                   assign tt_compos_demonst_cadastro.cod_ccusto_inic = entry(1,tab_livre_emsfin.cod_livre_2,chr(10))
                          tt_compos_demonst_cadastro.cod_ccusto_fim  = entry(2,tab_livre_emsfin.cod_livre_2,chr(10)).
            &else
                assign tt_compos_demonst_cadastro.cod_ccusto_inic = conjto_prefer_demonst.cod_ccusto_inic
                       tt_compos_demonst_cadastro.cod_ccusto_fim  = conjto_prefer_demonst.cod_ccusto_fim.
            &endif

            assign tt_compos_demonst_cadastro.cod_plano_ccusto  = v_cod_plano_ccusto
                   tt_compos_demonst_cadastro.cod_ccusto_excec  = v_cod_ccusto_prefer_excec
                   tt_compos_demonst_cadastro.cod_ccusto_pfixa  = v_cod_ccusto_prefer_pfixa.

            if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/  then do:
                assign tt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid = ''. /* n∆o retirar esta l¢ica */
                run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                         Input "CCusto" /*l_ccusto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                assign tt_compos_demonst_cadastro.cod_ccusto_excec   = fill("#",length(plano_ccusto.cod_format_ccusto))
                       tt_compos_demonst_cadastro.cod_ccusto_pfixa   = fill("#",length(plano_ccusto.cod_format_ccusto))
                       tt_compos_demonst_cadastro.cod_ccusto_inic    = v_cod_initial
                       tt_compos_demonst_cadastro.cod_ccusto_fim     = v_cod_final.
                if avail tab_livre_emsfin then
                   assign entry(1,tab_livre_emsfin.cod_livre_2,chr(10)) = v_cod_initial
                          entry(2,tab_livre_emsfin.cod_livre_2,chr(10)) = v_cod_final.
            end.        
        end.

        find plano_cta_ctbl 
            where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-lock no-error.
        if  avail plano_cta_ctbl
        then do:
            run pi_retornar_valores_iniciais_prefer (Input plano_cta_ctbl.cod_format_cta_ctbl,
                                                     Input "Cta Ctbl" /*l_cta_ctbl*/,
                                                     output v_cod_initial,
                                                     output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
            assign tt_compos_demonst_cadastro.cod_cta_ctbl_excec = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl))
                   tt_compos_demonst_cadastro.cod_cta_ctbl_pfixa = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl)).
            if  v_ind_selec_tip_demo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/  
            or  v_ind_selec_tip_demo = "Saldo Conta Cont†bil" /*l_saldo_conta_contabil_demo*/  then
                assign tt_compos_demonst_cadastro.cod_cta_ctbl_inic = v_cod_initial
                       tt_compos_demonst_cadastro.cod_cta_ctbl_fim  = v_cod_final.
        end.

        /* Linha de Total */
        create tt_compos_demonst_cadastro.
        assign tt_compos_demonst_cadastro.cod_demonst_ctbl       = ''
               tt_compos_demonst_cadastro.num_seq_compos_demonst = 10
               tt_compos_demonst_cadastro.num_seq_demonst_ctbl   = 20              
               tt_compos_demonst_cadastro.des_formul_ctbl        = 'TotSdoCt':U.

        if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/   then 
            assign v_cod_tipo = "Centro de Custo" /*l_centro_de_custo*/  .
        else
            assign v_cod_tipo = "Conta Cont†bil" /*l_conta_contabil*/  .

        create tt_estrut_visualiz_ctbl_cad.
        assign tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl           = ''
               tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl       = 10
               tt_estrut_visualiz_ctbl_cad.num_seq_estrut_visualiz    = 10
               tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz = v_cod_tipo
               tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst   = yes.

        run pi_prefer_demonst_ctbl_sdo_cta_ctbl /*pi_prefer_demonst_ctbl_sdo_cta_ctbl*/.

    end.
END PROCEDURE. /* pi_prefer_demonst_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_prefer_demonst_ctbl_sdo_cta_ctbl
** Descricao.............: pi_prefer_demonst_ctbl_sdo_cta_ctbl
** Criado por............: Dalpra
** Criado em.............: 25/07/2001 20:08:38
** Alterado por..........: fut12161
** Alterado em...........: 03/08/2005 10:14:27
*****************************************************************************/
PROCEDURE pi_prefer_demonst_ctbl_sdo_cta_ctbl:

    case v_ind_tip_sdo_ctbl_demo:
        when "Sdo/Movimento" /*l_sdomovimen*/  then do:
            run pi_col_consulta_sdo_ctbl (Input 'A',
                                          Input "T°tulo Cont†bil" /*l_titulo_cont†bil*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "T°tulo" /*l_titulo*/,
                                          Input "T°tulo" /*l_titulo*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input 'x(30)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'B',
                                          Input "Saldo Inicial" /*l_saldo_inicial*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Inicial" /*l_saldo_inicial*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "Sim" /*l_sim*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'C',
                                          Input "Movto DÇbito" /*l_movto_debito*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "DÇbitos" /*l_debitos*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "Sim" /*l_sim*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'D',
                                          Input "Movto CrÇdito" /*l_movto_credito*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "CrÇditos" /*l_creditos*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "Sim" /*l_sim*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'E',
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                            else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "Sim" /*l_sim*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'F',
                                          Input "AV %" /*l_av_perc*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "An. Vertical" /*l_analise_vertical*/,
                                          Input "F¢rmula" /*l_formula*/,
                                          Input '(E  / (E ,"TotSdoCt" /*l_totalizador_sdo_cta*/ :U) * 100)',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.                                       
         CREATE tt_acumul_demonst_cadastro.
         ASSIGN tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = 'TotSdoCt':U
                tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = ''
                tt_acumul_demonst_cadastro.tta_log_zero_acumul_ctbl = no
                tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = 10.
        end.
        when "Comparativo" /*l_comparativo*/  then do:
            run pi_col_consulta_sdo_ctbl (Input 'A',
                                          Input "T°tulo Cont†bil" /*l_titulo_contabil*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "T°tulo" /*l_titulo*/,
                                          Input "T°tulo" /*l_titulo*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input 'x(30)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'B',
                                          Input "Saldo Final 1¯" /*l_saldo_final_1*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'C',
                                          Input "Saldo Final 2¯" /*l_saldo_final_2*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 2,
                                          Input /* O Segundo conjunto Ç montado automaticamente na api_demonst_ctbl_video */                                        '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'D',
                                          Input "AV % 1¯" /*l_av_perc_1*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "An. Vertical" /*l_analise_vertical*/,
                                          Input "F¢rmula" /*l_formula*/,
                                          Input '(B  / (B ,"TotSdoCt") * 100)' /*l_formula_analis_vert_1*/,
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'E',
                                          Input "AV % 2¯" /*l_av_perc_2*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "An. Vertical" /*l_analise_vertical*/,
                                          Input "F¢rmula" /*l_formula*/,
                                          Input '(C  / (C ,"TotSdoCt") * 100)' /*l_formula_analis_vert_2*/,
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'F',
                                          Input "AH %" /*l_ah_perc*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "F¢rmula" /*l_formula*/,
                                          Input "F¢rmula" /*l_formula*/,
                                          Input 'C  / B  * 100 - 100',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
         CREATE tt_acumul_demonst_cadastro.
         ASSIGN tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = 'TotSdoCt':U
                tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = ''
                tt_acumul_demonst_cadastro.tta_log_zero_acumul_ctbl = no
                tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = 10.
        end.
        when "Oráamentos" /*l_orcamentos*/  then do:
            run pi_col_consulta_sdo_ctbl (Input 'A',
                                          Input "T°tulo Cont†bil" /*l_titulo_contabil*/,
                                          Input 0,
                                          Input 0,
                                          Input '',
                                          Input "T°tulo" /*l_titulo*/,
                                          Input "T°tulo" /*l_titulo*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input 'x(30)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'B',
                                          Input "Realizado" /*l_realizado*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Movimento" /*l_movimento*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'C',
                                          Input "Oráado" /*l_orcado*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Movimento" /*l_movimento*/,
                                          Input "Oráamento" /*l_orcamento*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'D',
                                          Input "Variaá∆o" /*l_variacao*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Variaá∆o" /*l_variacao*/,
                                          Input "F¢rmula" /*l_formula*/,
                                          Input 'C  / B  * 100 - 100',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'E',
                                          Input "Saldo Realizado" /*l_sdo_realizado*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'F',
                                          Input "Saldo Oráado" /*l_saldo_orcado*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Saldo Final" /*l_saldo_final*/,
                                          Input "Oráamento" /*l_orcamento*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Valor" /*l_valor*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'G',
                                          Input "Qtd Realizada" /*l_qtd_realizada*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Movimento" /*l_movimento*/,
                                          Input if plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then "Consolidaá∆o" /*l_consolidacao*/                                             else "Cont†bil" /*l_contabil*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Quantidade" /*l_quantidade*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            run pi_col_consulta_sdo_ctbl (Input 'H',
                                          Input "Qtd Oráada" /*l_qtd_orcada*/,
                                          Input 0,
                                          Input 0,
                                          Input "Antes da Referància" /*l_antes_da_referencia*/,
                                          Input "Movimento" /*l_movimento*/,
                                          Input "Oráamento" /*l_orcamento*/,
                                          Input '',
                                          Input "Impress∆o" /*l_impressao*/,
                                          Input 1,
                                          Input '',
                                          Input '(>,>>>,>>>,>>>,>>9.99)',
                                          input "N∆o" /*l_nao*/,
                                          Input "Quantidade" /*l_quantidade*/,
                                          Input "Consolidado" /*l_consolidado*/,
                                          Input 0) /*pi_col_consulta_sdo_ctbl*/.
            CREATE tt_acumul_demonst_cadastro.
            ASSIGN tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = 'TotSdoCt':U
                   tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = ''
                   tt_acumul_demonst_cadastro.tta_log_zero_acumul_ctbl = no
                   tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = 10.

        end.
    end.

END PROCEDURE. /* pi_prefer_demonst_ctbl_sdo_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_col_consulta_sdo_ctbl
** Descricao.............: pi_col_consulta_sdo_ctbl
** Criado por............: Dalpra
** Criado em.............: 24/07/2001 19:47:44
** Alterado por..........: Dalpra
** Alterado em...........: 01/08/2001 11:30:46
*****************************************************************************/
PROCEDURE pi_col_consulta_sdo_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_col_demonst_ctbl
        as character
        format "x(2)"
        no-undo.
    def Input param p_des_tit_ctbl
        as character
        format "x(40)"
        no-undo.
    def Input param p_qtd_period_relac_base
        as decimal
        format ">9"
        decimals 0
        no-undo.
    def Input param p_qtd_exerc_relac_base
        as decimal
        format ">9"
        decimals 0
        no-undo.
    def Input param p_ind_tip_relac_base
        as character
        format "X(20)"
        no-undo.
    def Input param p_ind_tip_val_sdo_ctbl
        as character
        format "X(13)"
        no-undo.
    def Input param p_ind_orig_val_col_demonst
        as character
        format "X(12)"
        no-undo.
    def Input param p_des_formul_ctbl
        as character
        format "x(2000)"
        no-undo.
    def Input param p_ind_funcao_col_demonst_ctbl
        as character
        format "X(12)"
        no-undo.
    def Input param p_num_conjto_param_ctbl
        as integer
        format ">9"
        no-undo.
    def Input param p_cod_col_base_analis_vert
        as character
        format "!"
        no-undo.
    def Input param p_cod_format_col_demonst_ctbl
        as character
        format "x(40)"
        no-undo.
    def input param p_ind_mostra_cod_ctbl
        as character
        format "X(13)"
        no-undo.
    def Input param p_ind_qualific_col_ctbl
        as character
        format "X(10)"
        no-undo.
    def Input param p_ind_tip_val_consolid
        as character
        format "X(18)"
        no-undo.
    def Input param p_num_soma_ascii_cod_col
        as integer
        format ">>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    CREATE tt_col_demonst_ctbl.
    ASSIGN tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl       = ''
           tt_col_demonst_ctbl.cod_col_demonst_ctbl            = p_cod_col_demonst_ctbl
           tt_col_demonst_ctbl.des_tit_ctbl                    = p_des_tit_ctbl
           tt_col_demonst_ctbl.qtd_period_relac_base           = p_qtd_period_relac_base
           tt_col_demonst_ctbl.qtd_exerc_relac_base            = p_qtd_exerc_relac_base
           tt_col_demonst_ctbl.ind_tip_relac_base              = p_ind_tip_relac_base
           tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl            = p_ind_tip_val_sdo_ctbl
           tt_col_demonst_ctbl.ind_orig_val_col_demonst        = p_ind_orig_val_col_demonst
           tt_col_demonst_ctbl.des_formul_ctbl                 = p_des_formul_ctbl
           tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl     = p_ind_funcao_col_demonst_ctbl
           tt_col_demonst_ctbl.num_conjto_param_ctbl           = p_num_conjto_param_ctbl
           tt_col_demonst_ctbl.cod_col_base_analis_vert        = p_cod_col_base_analis_vert
           tt_col_demonst_ctbl.cod_format_col_demonst_ctbl     = p_cod_format_col_demonst_ctbl
           tt_col_demonst_ctbl.ind_mostra_cod_ctbl             = p_ind_mostra_cod_ctbl
           tt_col_demonst_ctbl.ind_qualific_col_ctbl           = p_ind_qualific_col_ctbl
           tt_col_demonst_ctbl.ind_tip_val_consolid            = p_ind_tip_val_consolid
           tt_col_demonst_ctbl.num_soma_ascii_cod_col          = p_num_soma_ascii_cod_col
           tt_col_demonst_ctbl.ttv_rec_col_demonst_ctbl        = recid(tt_col_demonst_ctbl).
END PROCEDURE. /* pi_col_consulta_sdo_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_valores_iniciais_prefer
** Descricao.............: pi_retornar_valores_iniciais_prefer
** Criado por............: src388
** Criado em.............: 11/06/2001 11:40:43
** Alterado por..........: fut35059
** Alterado em...........: 30/01/2006 14:29:47
*****************************************************************************/
PROCEDURE pi_retornar_valores_iniciais_prefer:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_campo
        as character
        format "x(25)"
        no-undo.
    def output param p_cod_initial
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_final
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count_proj                 as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_count_proj = 1
           v_cod_proj_financ_000 = ""
           v_cod_proj_financ_999 = ""
           p_cod_initial = ""
           p_cod_final = "".

    do while v_num_count_proj <= length(p_cod_format):
        if  substring(p_cod_format,v_num_count_proj,1) <> "-"
        and substring(p_cod_format,v_num_count_proj,1) <> "."
        then do:
            if  substring(p_cod_format,v_num_count_proj,1) = "9"
            then do:
                assign v_cod_proj_financ_000 = v_cod_proj_financ_000 + "0"
                       v_cod_proj_financ_999 = v_cod_proj_financ_999 + "9".
            end.
            else do:
                if  substring(p_cod_format,v_num_count_proj,1) = "x" /*l_x*/  
                then do:
                    if p_cod_campo <> "Projeto" /*l_projeto*/  then
                        assign v_cod_proj_financ_000 = v_cod_proj_financ_000 + "0".

                    assign v_cod_proj_financ_999 = v_cod_proj_financ_999 + "Z" /*l_z*/ .
                end.
            end.
        end.
        assign v_num_count_proj = v_num_count_proj + 1.
    end.

    assign p_cod_initial = v_cod_proj_financ_000
           p_cod_final   = v_cod_proj_financ_999.
END PROCEDURE. /* pi_retornar_valores_iniciais_prefer */
/*****************************************************************************
** Procedure Interna.....: pi_vld_demons_ctbl
** Descricao.............: pi_vld_demons_ctbl
** Criado por............: dalpra
** Criado em.............: 16/11/2001 11:21:39
** Alterado por..........: fut41422_3
** Alterado em...........: 30/08/2012 15:03:51
*****************************************************************************/
PROCEDURE pi_vld_demons_ctbl:

    /************************* Variable Definition Begin ************************/

    def var v_log_grp_usuar                  as logical         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  not avail prefer_demonst_ctbl then do:
        /* ParÉmetros n∆o selecionados ! */
        run pi_messages (input "show",
                         input 11420,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11420*/.
        assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
        return "NOK" /*l_nok*/ .
    end.

    assign v_cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
           v_cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
           v_des_visualiz_ccusto = ""
           v_log_ccusto_pai = no.
    find first compos_demonst_ctbl no-lock
    where compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
      and compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
    if  avail compos_demonst_ctbl
    then do:
        find first plano_ccusto no-lock
             where plano_ccusto.cod_empresa = compos_demonst_ctbl.cod_unid_organ
               and plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
        if  avail plano_ccusto
        then do:
        run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                 Input "CCusto" /*l_ccusto*/,
                                                 output v_cod_initial,
                                                 output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
        end.
    end.

    assign v_cod_ccusto_pai_menor = v_cod_final
           v_cod_ccusto_pai_maior = v_cod_initial.
    /* --- Conjunto de Preferàncias ---*/
    preferencias:
    for
        each conjto_prefer_demonst no-lock
           where conjto_prefer_demonst.cod_usuario               = v_cod_usuar_corren
             and conjto_prefer_demonst.cod_demonst_ctbl          = v_cod_demonst_ctbl
             and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl:
        if  conjto_prefer_demonst.cod_finalid_econ = ""
        then do:
            /* Finalidade Cont†bil n∆o foi Informada ! */
            run pi_messages (input "show",
                             input 1190,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1190*/.
            assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
            return "NOK" /*l_nok*/ .
        end.
        if  conjto_prefer_demonst.cod_cenar_ctbl = ""
        then do:
            /* Cen†rio Cont†bil deve ser informado ! */
            run pi_messages (input "show",
                             input 694,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_694*/.
            assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
            return "NOK" /*l_nok*/ .
        end.

        if  v_ind_selec_demo_ctbl = "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
            if  v_ind_selec_tip_demo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/   then do:
                assign v_cod_ccusto = ''.
                &if '{&emsfin_version}' <= '5.05' &then
                    find tab_livre_emsfin exclusive-lock
                        where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                          and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                          and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                          and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
                    if  avail tab_livre_emsfin then
                        assign v_cod_ccusto = entry(1,tab_livre_emsfin.cod_livre_2,chr(10)) no-error.
                &else
                    assign v_cod_ccusto = conjto_prefer_demonst.cod_ccusto_inic. 
                &endif
                if  v_cod_ccusto = '' then do:
                    /* Centro de Custo n∆o Informado. */
                    run pi_messages (input "show",
                                     input 11425,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11425*/.
                    assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
                    return "NOK" /*l_nok*/ .
                end.
            end.
            if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/   then do:
                if  conjto_prefer_demonst.cod_cta_ctbl_inic <> conjto_prefer_demonst.cod_cta_ctbl_fim 
                or  conjto_prefer_demonst.cod_cta_ctbl_inic = '' then do:
                    /* Conta Cont†bil n∆o Informada ! */
                    run pi_messages (input "show",
                                     input 11426,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11426*/.
                    assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
                    return "NOK" /*l_nok*/ .
                end.
            end.
            /* --- Oráamento ---*/
            if  can-find(first tt_col_demonst_ctbl no-lock
                where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                  and tt_col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
                  and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_orcamento*/ )
            then do:

                if not can-find(first vers_orcto_ctbl_bgc no-lock
                     where vers_orcto_ctbl_bgc.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                       and vers_orcto_ctbl_bgc.cod_unid_orctaria   = &if '{&emsfin_version}' > '5.05'
                                                                     &then conjto_prefer_demonst.cod_unid_orctaria
                                                                     &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
                       and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = &if '{&emsfin_version}' > '5.05'
                                                                     &then conjto_prefer_demonst.num_seq_orcto_ctbl
                                                                     &else integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) &endif
                       and vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl)
                then assign v_cod_conjto_prefer_orctario = v_cod_conjto_prefer_orctario + string(conjto_prefer_demonst.num_conjto_param_ctbl) + ", ".
                else do:
                    assign v_log_grp_usuar = no.
                    do v_num_cont = 1 to num-entries(v_cod_grp_usuar_lst):
                        find first segur_vers_orcto_bgc no-lock
                            where segur_vers_orcto_bgc.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                              and segur_vers_orcto_bgc.cod_unid_orctaria   = &if '{&emsfin_version}' > '5.05'
                                                                             &then conjto_prefer_demonst.cod_unid_orctaria
                                                                             &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
                              and segur_vers_orcto_bgc.num_seq_orcto_ctbl  = &if '{&emsfin_version}' > '5.05'
                                                                             &then conjto_prefer_demonst.num_seq_orcto_ctbl
                                                                             &else integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) &endif
                              and segur_vers_orcto_bgc.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl
                              and (segur_vers_orcto_bgc.cod_grp_usuar = entry(v_num_cont, v_cod_grp_usuar_lst) or segur_vers_orcto_bgc.cod_grp_usuar = "*") no-error.
                        if avail segur_vers_orcto_bgc then do:
                            assign v_log_grp_usuar = yes.
                            leave.
                        end.  
                    end.  
                    if not v_log_grp_usuar then do:
                        /* &1 ! */
                        run pi_messages (input "show",
                                         input 524,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            'Usu†rio sem permiss∆o para a vers∆o de oráamento informada',                                       'Verifique na manutená∆o de oráamentos, seguranáa de oráamento se o grupo do usu†rio est† com permiss∆o de acesso para a vers∆o do oráamento informada')) /*msg_524*/.
                        return "NOK" /*l_nok*/ .
                    end.
                end.
            end.
        end.
        else do:
            /* --- Identificar faixa de ccustos informados em Conjunto de Preferàncias,
                   se a faixa inicial n∆o comeáa com o pai da estrutura de ccusto.
                   Nessa situaá∆o a expans∆o por ccusto n∆o, efetuada corretamente --- */
            &if '{&emsfin_version}' <= '5.05' &then
                find tab_livre_emsfin exclusive-lock
                    where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                      and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                      and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                      and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
                if avail tab_livre_emsfin then do:
                   assign v_cod_ccusto_pai = entry(1,tab_livre_emsfin.cod_livre_2,chr(10))
                          v_cod_ccusto_pai_fim = entry(2,tab_livre_emsfin.cod_livre_2,chr(10)) no-error.
                end.  
           &else
                   assign v_cod_ccusto_pai = conjto_prefer_demonst.cod_ccusto_inic
                          v_cod_ccusto_pai_fim = conjto_prefer_demonst.cod_ccusto_fim.
           &endif

           if v_cod_ccusto_pai <> v_cod_initial then do:          
               if avail compos_demonst_ctbl then do:
                   find first plano_ccusto no-lock
                        where plano_ccusto.cod_empresa = compos_demonst_ctbl.cod_unid_organ 
                          and plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.                   
                   if avail plano_ccusto then do:
                       find first emscad.ccusto no-lock
                           where ccusto.cod_empresa = plano_ccusto.cod_empresa
                           and ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
                           and ccusto.cod_ccusto = v_cod_ccusto_pai no-error.
                       if avail ccusto then do:        
                           if not can-find(first estrut_ccusto
                               where estrut_ccusto.cod_empresa = compos_demonst_ctbl.cod_unid_organ
                                 and estrut_ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
                                 and estrut_ccusto.cod_ccusto_pai = ""
                                 and estrut_ccusto.cod_ccusto_filho = v_cod_ccusto_pai)
                           then do:

                               if index(v_des_visualiz_ccusto, v_cod_ccusto_pai) = 0 then do:
                                   assign v_des_visualiz_ccusto = v_des_visualiz_ccusto + v_cod_ccusto_pai + ',' + v_cod_ccusto_pai_fim + ',' + compos_demonst_ctbl.cod_unid_organ + ',' + plano_ccusto.cod_plano_ccusto + chr(10).              
                               end.

                               if v_cod_ccusto_pai_menor > v_cod_ccusto_pai then
                                   assign v_cod_ccusto_pai_menor = v_cod_ccusto_pai.
                               if v_cod_ccusto_pai_maior < v_cod_ccusto_pai_fim then
                                   assign v_cod_ccusto_pai_maior = v_cod_ccusto_pai_fim.                 
                           end.
                       end.    
                   end.
               end.
           end.
           else
               assign v_log_ccusto_pai = yes.               

            /* --- Oráamento ---*/
            if  can-find(first col_demonst_ctbl no-lock
                where col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                  and col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
                  and col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_orcamento*/ )
            then do:

                if not can-find(first vers_orcto_ctbl_bgc no-lock
                     where vers_orcto_ctbl_bgc.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                       and vers_orcto_ctbl_bgc.cod_unid_orctaria   = &if '{&emsfin_version}' > '5.05'
                                                                     &then conjto_prefer_demonst.cod_unid_orctaria
                                                                     &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
                       and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = &if '{&emsfin_version}' > '5.05'
                                                                     &then conjto_prefer_demonst.num_seq_orcto_ctbl
                                                                     &else integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) &endif
                       and vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl)
                then assign v_cod_conjto_prefer_orctario = v_cod_conjto_prefer_orctario + string(conjto_prefer_demonst.num_conjto_param_ctbl) + ", ".
                else do:
                    assign v_log_grp_usuar = no.
                    do v_num_cont = 1 to num-entries(v_cod_grp_usuar_lst):
                        find first segur_vers_orcto_bgc no-lock
                            where segur_vers_orcto_bgc.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                              and segur_vers_orcto_bgc.cod_unid_orctaria   = &if '{&emsfin_version}' > '5.05'
                                                                             &then conjto_prefer_demonst.cod_unid_orctaria
                                                                             &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
                              and segur_vers_orcto_bgc.num_seq_orcto_ctbl  = &if '{&emsfin_version}' > '5.05'
                                                                             &then conjto_prefer_demonst.num_seq_orcto_ctbl
                                                                             &else integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) &endif
                              and segur_vers_orcto_bgc.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl
                              and (segur_vers_orcto_bgc.cod_grp_usuar = entry(v_num_cont, v_cod_grp_usuar_lst) or segur_vers_orcto_bgc.cod_grp_usuar = "*") no-error.
                        if avail segur_vers_orcto_bgc then do:
                            assign v_log_grp_usuar = yes.
                            leave.
                        end.  
                    end.  
                    if not v_log_grp_usuar then do:
                        /* &1 ! */
                        run pi_messages (input "show",
                                         input 524,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            'Usu†rio sem permiss∆o para a vers∆o de oráamento informada',                                       'Verifique na manutená∆o de oráamentos, seguranáa de oráamento se o grupo do usu†rio est† com permiss∆o de acesso para a vers∆o do oráamento informada')) /*msg_524*/.
                        return "NOK" /*l_nok*/ .
                    end.
                end.
            end.
        end.
    end.

    /* Se existirem n conjuntos de preferàncias e um deles comeáar na faixa inicial n∆o necessita de controle */
    if v_log_ccusto_pai then
       assign v_des_visualiz_ccusto = "".

    if  v_cod_conjto_prefer_orctario <> ""
    then do:
        ASSIGN v_cod_conjto_prefer_orctario = STRING(v_cod_conjto_prefer_orctario,'x(' + string(R-INDEX(v_cod_conjto_prefer_orctario,',') - 1) + ')').
        /* ParÉmetros Oráamento n∆o Informados ! */
        run pi_messages (input "show",
                         input 11265,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_cod_conjto_prefer_orctario)) /*msg_11265*/.
        assign v_wgh_focus = bt_fil2:handle in frame f_bas_10_demonst_ctbl_fin.
        return "NOK" /*l_nok*/ .
    end.

END PROCEDURE. /* pi_vld_demons_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_gera_tt_grafico
** Descricao.............: pi_gera_tt_grafico
** Criado por............: bre17752
** Criado em.............: 08/11/2001 16:19:31
** Alterado por..........: bre17108
** Alterado em...........: 12/12/2003 15:25:55
*****************************************************************************/
PROCEDURE pi_gera_tt_grafico:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_nivel
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_indic_econ_plural
        as character
        format "x(32)":U
        label "Inteiro Plural"
        column-label "Inteiro Plural"
        no-undo.
    def var v_des_tit
        as character
        format "x(18)":U
        no-undo.
    def var v_num_seq_fim
        as integer
        format ">>>,>>9":U
        initial 999999
        label "Sequencia Final"
        no-undo.
    def var v_num_seq_ini
        as integer
        format ">>>,>>9":U
        initial 0
        label "Sequencia Inicial"
        no-undo.


    /************************** Variable Definition End *************************/

    find btt_demonst_ctbl_fin
      where recid(btt_demonst_ctbl_fin) = tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video
      no-lock no-error.
    if avail btt_demonst_ctbl_fin then do:
        find first tt_demonst_ctbl_fin
           where tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(btt_demonst_ctbl_fin)
           no-lock no-error.
        if avail tt_demonst_ctbl_fin then
            assign v_num_seq_ini = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl.

        find last tt_demonst_ctbl_fin
           where tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = recid(btt_demonst_ctbl_fin)
           no-lock no-error.
        if avail tt_demonst_ctbl_fin then
            assign v_num_seq_fim = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl.
    end.


    /* Begin_Include: i_limpa_temp_table_graficos */
    /* ****Limpa as temp-tables de grafico*****/
    for each tt_atributos:
        delete tt_atributos.
    end.    
    for each tt_graph_data:
        delete tt_graph_data.
    end.
    for each tt_sets:
        delete tt_sets.
    end.
    for each tt_erro:
        delete tt_erro.
    end.
    for each tt_points:
        delete tt_points.
    end.
    /* End_Include: i_limpa_temp_table_graficos */


    IF NOT AVAIL conjto_prefer_demonst THEN
    FIND FIRST conjto_prefer_demonst NO-LOCK
        WHERE conjto_prefer_demonst.cod_usuario = v_cod_usuar_corren
          AND conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
          AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
          NO-ERROR.

    find last histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ_apres no-error.
    find indic_econ no-lock
         where indic_econ.cod_indic_econ = histor_finalid_econ.cod_indic_econ
          no-error.
    if  avail indic_econ
    then do:
        find first trad_indic_econ no-lock
             where trad_indic_econ.cod_indic_econ = indic_econ.cod_indic_econ
               and trad_indic_econ.cod_idioma = prefer_demonst_ctbl.cod_idioma no-error.
        if avail trad_indic_econ
        THEN assign v_des_indic_econ_plural = trad_indic_econ.des_indic_econ_plural.
    end.

    /* * Tipo gr†fico => 4 - barras ... 2 - pizza **/.
    if v_cod_tip_graf = "2" /*l_2*/  then
       assign v_num_dataset = 2.
    else
       assign v_num_dataset = 1.
    assign v_num_cont = 0.


    /* ******************** Criaá∆o da tt_atributos **************************/

    if  (v_num_dataset = 1) and
    (not can-find(first tt_atributos where (tt_atributos.ttv_num_graphic_type = 1 and tt_atributos.ttv_num_graphic = 1)))
    then do:

        if  v_ind_tip_sdo_ctbl_demo <> "Sdo/Movimento" /*l_sdomovimen*/ 
        then do:
            create tt_atributos.
            assign tt_atributos.ttv_num_vers_integr      = 003
                   tt_atributos.ttv_num_graphic_type     = 4
                   tt_atributos.ttv_nom_graphic_title    = "An†lise Horizontal" /*l_analise_horiz*/ 
                   tt_atributos.ttv_nom_left_title       = "Saldo" /*l_saldo*/  + ' ' + v_des_indic_econ_plural
                   tt_atributos.ttv_num_left_title_style = 0
                   tt_atributos.ttv_num_legend_pos       = 0 
                   tt_atributos.ttv_num_grid_style       = 3
                   tt_atributos.ttv_num_graphic          = 1.

            if  v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  then do:
                &if '{&emsfin_version}' = '5.05' &then
                    assign tt_atributos.ttv_nom_graphic_title = "An†lise Horizontal" /*l_analise_horiz*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99')
                                                                                    + '/' + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                &else
                    assign tt_atributos.ttv_nom_graphic_title = "An†lise Horizontal" /*l_analise_horiz*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                &endif
            end.
            create tt_sets.
            assign tt_sets.ttv_num_set         = 1
                   tt_sets.ttv_num_graphic     = 1.
            &if '{&emsfin_version}' = '5.05' &then
                assign tt_sets.ttv_nom_legend_text = string(month(conjto_prefer_demonst.dat_livre_1),'99')
                                             + '/' + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
            &else
                assign tt_sets.ttv_nom_legend_text = conjto_prefer_demonst.cod_exerc_period_1.
            &endif

            if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  then
               assign tt_sets.ttv_nom_legend_text = "Realizado do Per°odo" /*l_real_do_periodo*/ .

            create tt_sets.
            assign tt_sets.ttv_num_set         = 2
                   tt_sets.ttv_num_graphic     = 1.
            &if '{&emsfin_version}' = '5.05' &then
                assign tt_sets.ttv_nom_legend_text = string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,CHR(10)))),'99')
                                             + '/' + string(year(date(entry(4,conjto_prefer_demonst.cod_livre_1,CHR(10)))),'9999'). 
            &else
                assign tt_sets.ttv_nom_legend_text = conjto_prefer_demonst.cod_exerc_period_2.
            &endif  

            if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  then
               assign tt_sets.ttv_nom_legend_text = "Oráamentado" /*l_orcamentado*/ .
        end /* if */.
    end /* if */.


    /* ******************** Criaá∆o dos Sets **************************/

    FOR EACH tt_demonst_ctbl_fin NO-LOCK
        WHERE tt_demonst_ctbl_fin.ttv_log_apres
        and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl >= v_num_seq_ini
        and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl <= v_num_seq_fim
        and   tt_demonst_ctbl_fin.ttv_num_nivel             = p_num_nivel
        BREAK BY tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl :

        /* N∆o cria tt grafico para linha Totalizadora*/
        FIND FIRST tt_item_demonst_ctbl_video
            WHERE  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
            NO-ERROR.
        IF CAN-FIND (FIRST tt_item_demonst_ctbl_cadastro NO-LOCK
           WHERE tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = v_cod_demonst_ctbl
           AND tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
           AND tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/ )
        THEN NEXT.

        ASSIGN v_num_cont = v_num_cont + 1.

        FIND FIRST cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
               AND cta_ctbl.cod_cta_ctbl = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho NO-ERROR.

        if  v_ind_tip_sdo_ctbl_demo <> "Sdo/Movimento" /*l_sdomovimen*/ 
        then do:
            if  first(tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl)
            then do:
                if  v_num_dataset = 1
                then do: /* Gr†fico de Barra */

                    if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
                    then 
                         RUN pi_carrega_graf_comparativo.
                    else if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/   
                         then run pi_carrega_graf_orcamento.
                end /* if */.
                else do:  /* Gr†fico de Pizza */
                    assign v_log_vert = yes.
                    if  not can-find(first tt_atributos where
                       (tt_atributos.ttv_num_graphic_type = 1 and tt_atributos.ttv_num_graphic = 1) and 
                       (tt_atributos.ttv_num_graphic_type = 1 and tt_atributos.ttv_num_graphic = 2))
                    then do:

                        if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  then
                           &if '{&emsfin_version}' = '5.05' &then
                               assign v_des_tit = "Realizado do Per°odo" /*l_real_do_periodo*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99')
                                                                        + '/' + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                           &else
                               assign v_des_tit = "Realizado do Per°odo" /*l_real_do_periodo*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                           &endif
                        else
                            &if '{&emsfin_version}' = '5.05' &then
                               assign v_des_tit = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99')
                                                                       + '/' + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                            &else
                               assign v_des_tit = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                            &endif

                        create tt_atributos.
                        assign tt_atributos.ttv_num_vers_integr   = 003
                               tt_atributos.ttv_num_graphic_type  = 2
                               tt_atributos.ttv_nom_graphic_title = v_des_tit
                               tt_atributos.ttv_num_graphic_style = 6
                               tt_atributos.ttv_num_graphic       = 1.
                        if  v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  then
                            &if '{&emsfin_version}' = '5.05' &then
                                assign v_des_tit = "Oráamentado" /*l_orcamentado*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99')
                                                                     + '/' + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                            &else
                                assign v_des_tit = "Oráamentado" /*l_orcamentado*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                            &endif
                        else
                            &if '{&emsfin_version}' = '5.05' &then
                                assign v_des_tit = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,CHR(10)))),'99')
                                                                        + '/' + string(year(date(entry(4,conjto_prefer_demonst.cod_livre_1,CHR(10)))),'9999').
                            &else
                                assign v_des_tit = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                            &endif

                        create tt_atributos.
                        assign tt_atributos.ttv_num_vers_integr       = 003
                               tt_atributos.ttv_num_graphic_type      = 2
                               tt_atributos.ttv_nom_graphic_title     = v_des_tit 
                               tt_atributos.ttv_num_graphic_style     = 6
                               tt_atributos.ttv_num_graphic           = 2.
                        assign v_des_tit = ''.
                    end /* if */.
                    if  can-find(first tt_atributos where tt_atributos.ttv_num_graphic = 1)
                    then do:
                        create tt_sets.
                        assign tt_sets.ttv_num_set          = v_num_cont
                               tt_sets.ttv_num_graphic      = 1
                               tt_sets.ttv_nom_legend_text  = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/.
                    end /* if */.
                    if  can-find(first tt_atributos where tt_atributos.ttv_num_graphic = 2)
                    then do:
                        create tt_sets.
                        assign tt_sets.ttv_num_set          = v_num_cont
                               tt_sets.ttv_num_graphic      = 2
                               tt_sets.ttv_nom_legend_text  = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/.
                    end /* if */.
        /* assign v_des_values = string(absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")","")))) /*2ß periodo - orcado*/.*/

                    if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
                    then 
                        RUN pi_carrega_graf_comparativo.
                    else if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/ 
                         then 
                            RUN pi_carrega_graf_orcamento.
                end /* else */.
            end /* if */.
            else do:
                if  v_num_dataset = 1
                then do: /* Gr†fico de Barra */
                    if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
                    then
                        RUN pi_carrega_graf_comparativo.
                    else if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/  
                         then
                            RUN pi_carrega_graf_orcamento.
                end /* if */.
                else do: /* Gr†fico de Pizza */
                    assign v_log_vert = yes.
                    if  (can-find(first tt_atributos where tt_atributos.ttv_num_graphic = 1))
                    then do:
                        create tt_sets.
                        assign tt_sets.ttv_num_set          = V_NUM_CONT
                               tt_sets.ttv_num_graphic      = 1
                               tt_sets.ttv_nom_legend_text  = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/.
                    end /* if */.
                    if  can-find(first tt_atributos where tt_atributos.ttv_num_graphic = 2)
                    then do:
                       create tt_sets.
                       assign tt_sets.ttv_num_set          = v_num_cont
                              tt_sets.ttv_num_graphic      = 2
                              tt_sets.ttv_nom_legend_text  = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/. 
                    end /* if */.

        /* assign v_des_values = string(absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")","")))) /*1ß periodo - realizado*/.*/
                    if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
                    then
                        RUN pi_carrega_graf_comparativo.
                    else if v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/ 
                         then
                            run pi_carrega_graf_orcamento.
                end /* else */.
            end /* else */.
        end /* if */.
        else do:
            if  (v_num_dataset = 1)
            then do:
               if  not can-find(first tt_atributos where tt_atributos.ttv_num_graphic  = 1)
               then do:
                  create tt_atributos.
                  assign tt_atributos.ttv_num_vers_integr   = 003
                         tt_atributos.ttv_num_graphic_type  = 4
                         tt_atributos.ttv_nom_left_title    = "Saldo" /*l_saldo*/  + ' ' + v_des_indic_econ_plural
                         tt_atributos.ttv_num_grid_style    = 3
                         tt_atributos.ttv_num_graphic       = 1.

                  &if '{&emsfin_version}' = '5.05' &then
                      assign tt_atributos.ttv_nom_graphic_title = "An†lise Horizontal" /*l_analise_horiz*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99') + '/'
                                                                                            + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                  &else
                      assign tt_atributos.ttv_nom_graphic_title = "An†lise Horizontal" /*l_analise_horiz*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                  &endif

                  create tt_sets.
                  assign tt_sets.ttv_num_set     = 1
                         tt_sets.ttv_num_graphic = 1.
               end /* if */.
               RUN pi_carrega_graf_sdo_moviment.
            end /* if */.
            else do: /* Gr†fico Pizza */
                assign v_log_vert = yes.
                if  not can-find(first tt_atributos where tt_atributos.ttv_num_graphic  = 1)
                then do:
                    create tt_atributos.
                    assign tt_atributos.ttv_num_vers_integr       = 003
                           tt_atributos.ttv_num_graphic_type      = 2
                           tt_atributos.ttv_num_graphic_style     = 6
                           tt_atributos.ttv_num_graphic           = 1.

                  &if '{&emsfin_version}' = '5.05' &then
                      assign tt_atributos.ttv_nom_graphic_title = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + string(month(conjto_prefer_demonst.dat_livre_1),'99') + '/'
                                                                                            + string(year(conjto_prefer_demonst.dat_livre_1),'9999').
                  &else
                      assign tt_atributos.ttv_nom_graphic_title = "An†lise Vertical" /*l_analise_vertic*/  + ' ' + conjto_prefer_demonst.cod_exerc_period_1.
                  &endif

                end /* if */.
                RUN pi_carrega_graf_sdo_moviment.
            end /* else */.
        end /* else */.
    end /* for tt_item_sdo_cta_ctbl */.

    run prgtec/btb/btb900zb.p (input table tt_atributos,
                               Input table tt_points,
                               Input table tt_sets,
                               Input table tt_graph_data,
                               Input table tt_ylabels,
                               output table tt_erro) /*prg_fnc_show_graphic_2*/.

    assign v_log_vert = no.
END PROCEDURE. /* pi_gera_tt_grafico */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_graf_sdo_moviment
** Descricao.............: pi_carrega_graf_sdo_moviment
** Criado por............: bre17752
** Criado em.............: 08/11/2001 16:20:12
** Alterado por..........: src531
** Alterado em...........: 04/09/2002 12:53:24
*****************************************************************************/
PROCEDURE pi_carrega_graf_sdo_moviment:

    if  v_log_vert = no
    then do:
        create tt_points.
        assign tt_points.ttv_num_point      = v_num_cont
               tt_points.ttv_num_graphic    = 1
               tt_points.ttv_nom_label_text = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/.

        create tt_graph_data.
        assign tt_graph_data.ttv_num_point       = tt_points.ttv_num_point
               tt_graph_data.ttv_num_set         = 1
               tt_graph_data.ttv_num_graphic     = 1
               tt_graph_data.ttv_val_graphic_dat = ABS(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_5,"(","-"),")",""))).
    end /* if */.
    else do:
         if  can-find(first tt_atributos where tt_atributos.ttv_num_graphic = 1)
         then do:
            create tt_sets.
            assign tt_sets.ttv_num_set         = v_num_cont
                   tt_sets.ttv_num_graphic     = 1
                   tt_sets.ttv_nom_legend_text = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/.
         end /* if */.
         create tt_points.
         assign tt_points.ttv_num_point   = v_num_cont
                tt_points.ttv_num_graphic = 1.

         create tt_graph_data.
         assign tt_graph_data.ttv_num_point        = v_num_cont
                tt_graph_data.ttv_num_set          = 1
                tt_graph_data.ttv_num_graphic      = 1
                tt_graph_data.ttv_val_graphic_dat  = dec(tt_demonst_ctbl_fin.ttv_cod_campo_6).

    end /* else */.
END PROCEDURE. /* pi_carrega_graf_sdo_moviment */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_graf_comparativo
** Descricao.............: pi_carrega_graf_comparativo
** Criado por............: bre17752
** Criado em.............: 08/11/2001 16:20:35
** Alterado por..........: bre17752
** Alterado em...........: 19/11/2001 11:06:32
*****************************************************************************/
PROCEDURE pi_carrega_graf_comparativo:

    if  v_log_vert = no
    then do:
        create tt_points.
        assign tt_points.ttv_num_point      = v_num_cont
               tt_points.ttv_num_graphic    = 1
               tt_points.ttv_nom_label_text = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/ .

        create tt_graph_data.
        assign tt_graph_data.ttv_num_point       = tt_points.ttv_num_point
               tt_graph_data.ttv_num_set         = 1
               tt_graph_data.ttv_num_graphic     = 1
               tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* 1ß periodo*/.

        create tt_graph_data.
        assign tt_graph_data.ttv_num_point       = tt_points.ttv_num_point
               tt_graph_data.ttv_num_set         = 2
               tt_graph_data.ttv_num_graphic     = 1
               tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* 2ß periodo*/.
    end /* if */.
    else do:
         create tt_points.
         assign tt_points.ttv_num_point   = v_num_cont
                tt_points.ttv_num_graphic = 1.
         if  can-find(first tt_atributos where tt_atributos.ttv_num_graphic  = 2)
         then do:
             create tt_points.
             assign tt_points.ttv_num_point   = v_num_cont
                    tt_points.ttv_num_graphic = 2 .
         end /* if */.

         create tt_graph_data.
         assign tt_graph_data.ttv_num_point   = v_num_cont
                tt_graph_data.ttv_num_set     = 1
                tt_graph_data.ttv_num_graphic = 1.
         If absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* 1ß periodo*/ = 0 then
            assign tt_graph_data.ttv_val_graphic_dat = 1.
         else
            assign tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* 1ß periodo*/.

         create tt_graph_data.
         assign tt_graph_data.ttv_num_point   = v_num_cont
                tt_graph_data.ttv_num_set     = 1
                tt_graph_data.ttv_num_graphic = 2.
         If absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* 2ß periodo*/ = 0 then
            assign tt_graph_data.ttv_val_graphic_dat = 1.
         else
            assign tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* 2ß periodo*/.
    end /* else */.
END PROCEDURE. /* pi_carrega_graf_comparativo */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_graf_orcamento
** Descricao.............: pi_carrega_graf_orcamento
** Criado por............: bre17752
** Criado em.............: 08/11/2001 16:21:13
** Alterado por..........: bre17752
** Alterado em...........: 19/11/2001 11:04:36
*****************************************************************************/
PROCEDURE pi_carrega_graf_orcamento:

    if  v_log_vert = no
    then do:
        create tt_points.
        assign tt_points.ttv_num_point      = v_num_cont
               tt_points.ttv_num_graphic    = 1 
               tt_points.ttv_nom_label_text = tt_demonst_ctbl_fin.ttv_cod_campo_1 /* descriá∆o cta*/ .

        create tt_graph_data.
        assign tt_graph_data.ttv_num_point       = tt_points.ttv_num_point
               tt_graph_data.ttv_num_set         = 1 
               tt_graph_data.ttv_num_graphic     = 1 
               tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* Realizado*/.

        create tt_graph_data.
        assign tt_graph_data.ttv_num_point       = tt_points.ttv_num_point
               tt_graph_data.ttv_num_set         = 2
               tt_graph_data.ttv_num_graphic     = 1
               tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* Orcado*/.
    end /* if */.
    else do:
         create tt_points.
         assign tt_points.ttv_num_point   = v_num_cont
                tt_points.ttv_num_graphic = 1. 
         if  can-find(first  tt_atributos 
                      where (tt_atributos.ttv_num_graphic = 2))
         then do:
             create tt_points.
             assign tt_points.ttv_num_point   = v_num_cont
                    tt_points.ttv_num_graphic = 2 .
         end /* if */.

         create tt_graph_data.
         assign tt_graph_data.ttv_num_point   = v_num_cont
                tt_graph_data.ttv_num_set     = 1 
                tt_graph_data.ttv_num_graphic = 1.
         If absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* Realizado*/ = 0 then
            assign tt_graph_data.ttv_val_graphic_dat = 0.1.
         else
            assign tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_2,"(","-"),")",""))) /* Realizado*/.

         create tt_graph_data.
         assign tt_graph_data.ttv_num_point   = v_num_cont
                tt_graph_data.ttv_num_set     = 1
                tt_graph_data.ttv_num_graphic = 2.
         If absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* Orcado*/ = 0 then
            assign tt_graph_data.ttv_val_graphic_dat = 0.1.
         else       
            assign tt_graph_data.ttv_val_graphic_dat = absolute(dec(REPLACE(REPLACE(tt_demonst_ctbl_fin.ttv_cod_campo_3,"(","-"),")",""))) /* Orcado*/.
    end /* else */.
END PROCEDURE. /* pi_carrega_graf_orcamento */
/*****************************************************************************
** Procedure Interna.....: pi_row_display
** Descricao.............: pi_row_display
** Criado por............: src531
** Criado em.............: 15/08/2002 17:44:35
** Alterado por..........: src531
** Alterado em...........: 04/09/2002 11:44:44
*****************************************************************************/
    DEF VAR v_coluna4                        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
    DEF VAR v_coluna3                        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
    DEF VAR v_coluna2                        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
    DEF VAR v_coluna5                        AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".

PROCEDURE pi_row_display:

    DEFINE VAR v_vlr_minimo AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>>.99".
    DEFINE VAR v_vlr_minimo_neg AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
    FIND FIRST ext_lim_justif NO-LOCK WHERE ext_lim_justif.cod_exercicio    = int(prefer_demonst_ctbl.cod_exerc_ctbl)
                                      AND   ext_lim_justif.num_periodo_ctbl = prefer_demonst_ctbl.num_period_ctbl
                                      NO-ERROR.

    ASSIGN v_vlr_minimo = ext_lim_justif.valor_minimo.
    ASSIGN v_vlr_minimo_neg = ext_lim_justif.valor_minimo_neg.
        
    ASSIGN v_var_ccusto = ext_lim_justif.var_perc_positiva
           v_var_ccusto_neg = ext_lim_justif.val_perc_negativa.

    /* Temp-table para definicao de nomes a serem ignorados na Araupel*/


    case tt_demonst_ctbl_fin.ttv_cod_inform_princ:
        when "Centro de Custo" /*l_centro_de_custo*/  THEN DO:
            

           assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
           END.
        when "Estabelecimento" /*l_estabelecimento*/  then
           assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
        when "Unidade Neg¢cio" /*l_unidade_negocio*/  then
           assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0              
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
        when "Projeto" /*l_projeto*/  then
           assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0 
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
        when "UO Origem" /*l_uo_origem*/  then
           assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 11
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 9 
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 9
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 9.
        when "T°tulo" /*l_titulo*/  THEN DO:
            
            
                  assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 0
                  tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 05 
                  tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 05
                  tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 05.
        END.

        when "Conta Cont†bil" /*l_titulo*/  THEN DO:



assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
      tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
      tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
 END.

 OTHERWISE DO: /* caso nao esteja como titulo, conta, centro de custo, estabelecimento, unidade de negocio faz*/


     IF  tt_demonst_ctbl_fin.ttv_cod_campo_3 BEGINS "==" THEN
         NEXT.
     ELSE DO:
         IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_3) BEGINS "(" THEN DO:


             ASSIGN v_coluna3 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_3), "(" ) , ")"))) * - 1.

             END. /* begins ( */
             ELSE DO:
             ASSIGN v_coluna3 = dec(TRIM(ttv_cod_campo_3)).
             END.  /* nao comeca com ( */
    
                   
     

     IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_2) BEGINS "(" THEN DO:
         ASSIGN v_coluna2 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_2), "(" ) , ")"))) * - 1.
     
    END. /* begins ( */
         ELSE DO:
         ASSIGN v_coluna2 = dec(TRIM(ttv_cod_campo_2)).
     END. /* nao comeca com ( */


         IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_4) BEGINS "(" THEN 
             ASSIGN v_coluna4 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_4), "(" ) , ")"))) * - 1.
             ELSE
             ASSIGN v_coluna4 = dec(TRIM(ttv_cod_campo_4)).


             /* novo - inserido em 04/08/2017 para fazer com que as receitas tenham calculo inverso ao das despesas */
             IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_5) BEGINS "(" THEN 
                 ASSIGN v_coluna5 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_5), "(" ) , ")"))) * - 1.
                 ELSE
                 ASSIGN v_coluna5 = dec(TRIM(ttv_cod_campo_5)).

            
        END.

         


             FIND FIRST ext_exc_justificativas WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                               AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

             IF AVAIL ext_exc_justificativas THEN DO:

                 assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
               RETURN.  
             END. /* Fim da clausula da excecao de palavras */

                IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) BEGINS "|" THEN DO:
                    
                

                 assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                        tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
               RETURN.  
             END. /* Fim da clausula da excecao de palavras */


             FIND FIRST demonst_ctbl NO-LOCK WHERE demonst_ctbl.cod_demonst_ctbl =  conjto_prefer_demonst.cod_demonst_ctbl NO-ERROR.

             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* =====================================RECEITAS DE VENDAS - PARAMETROS PARA GERACAO==================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             FIND FIRST tt-receitas WHERE tt-receitas.nome = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.
             IF AVAIL tt-receitas THEN DO:


                 IF  v_coluna4 = 0 
                 AND (absolute(v_coluna2) - ABSOLUTE(v_coluna3)) > v_vlr_minimo  /* era R$ 300,00*/
                     THEN NEXT.

                 IF (v_coluna4) <= (100 - v_var_ccusto) 
                          THEN DO:
                    IF (absolute(v_coluna2) - ABSOLUTE(v_coluna3)) > v_vlr_minimo THEN DO: /* era R$ 300,00*/

                     FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cod_demonst = demonst_ctbl.des_tit_ctbl
                                                          AND   ext_justificativa.Cod_padr_col = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                          AND   ext_justificativa.Periodo     = prefer_demonst_ctbl.num_period_ctbl
                                                          AND   ext_justificativa.Ano         = INT(prefer_demonst_ctbl.cod_exerc_ctbl)
                                                          AND   ext_justificativa.cta_ctbl     = entry(1, trim(tt_demonst_ctbl_fin.ttv_cod_campo_1), "|")
                                                          AND   ext_justificativa.ccusto       = trim(conjto_prefer_demonst.cod_demonst_ctbl)
                                                          AND   ext_justificativa.log_justif  = YES NO-ERROR.

                     IF AVAIL ext_justificativa THEN DO:




                 assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
                        tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                        tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
                  END. /* fim da ext_justificativa */


                  IF NOT AVAIL ext_justificativa THEN DO:




              assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 14 
                     tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 14
                     tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                     tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

                    END. /* Fim da falta de justificativa */
        
                END. /* fim da variacao acima de R$ 300,00 */
            END.    /* fim da variacao percentual */
                    RETURN.
        END.       /*fim da TT-Receitas */

             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ============================================DESPESAS - PARAMETROS PARA GERACAO======================================= */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
             /* ===================================================================================================================== */
        IF  (v_coluna2 = 0
        AND v_coluna3 <> 0)
         THEN DO:


            FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cod_demonst = demonst_ctbl.des_tit_ctbl
                                                 AND   ext_justificativa.Cod_padr_col = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                 AND   ext_justificativa.Periodo     = prefer_demonst_ctbl.num_period_ctbl
                                                 AND   ext_justificativa.Ano         = INT(prefer_demonst_ctbl.cod_exerc_ctbl)
                                                 AND   ext_justificativa.cta_ctbl     = entry(1, trim(tt_demonst_ctbl_fin.ttv_cod_campo_1), "|")
                                                 AND   ext_justificativa.ccusto    = trim(conjto_prefer_demonst.cod_demonst_ctbl)
                                                 AND   ext_justificativa.log_justif  = YES NO-ERROR.

            IF AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
            END.

    FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = demonst_ctbl.des_tit_ctbl
                                         AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

   IF AVAIL ext_exc_justificativas THEN DO:
       assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
              tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.

    IF NOT AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 14 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

           END.

                FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                     AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

               IF AVAIL ext_exc_justificativas THEN DO:
                   assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.
            RETURN.
        END.
         
 

        IF absolute(v_coluna2) = absolute(v_coluna3)
        THEN DO:




        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

        RETURN.
       END. /*Fim da ext_justificativa*/


        IF  (v_coluna3 = 0
        AND v_coluna2 <> 0)
         THEN DO:


            FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cod_demonst = demonst_ctbl.des_tit_ctbl
                                                 AND   ext_justificativa.Cod_padr_col = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                 AND   ext_justificativa.Periodo     = prefer_demonst_ctbl.num_period_ctbl
                                                 AND   ext_justificativa.Ano         = INT(prefer_demonst_ctbl.cod_exerc_ctbl)
                                                 AND   ext_justificativa.cta_ctbl     = entry(1, trim(tt_demonst_ctbl_fin.ttv_cod_campo_1), "|")
                                                 AND   ext_justificativa.ccusto    = trim(conjto_prefer_demonst.cod_demonst_ctbl)
                                                 AND   ext_justificativa.log_justif  = YES NO-ERROR.

            IF AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
            END.

    FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = demonst_ctbl.des_tit_ctbl
                                         AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

   IF AVAIL ext_exc_justificativas THEN DO:
       assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
              tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.

    IF NOT AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 14 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 14
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

           END.

                FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                     AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

               IF AVAIL ext_exc_justificativas THEN DO:
                   assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.
            RETURN.
        END.




         IF ((v_coluna5) > v_var_ccusto 
         OR  (v_coluna5) < v_var_ccusto_neg)
         THEN DO:

           
            IF (absolute(v_coluna3) - ABSOLUTE(v_coluna2)) > v_vlr_minimo 
            OR  (ABSOLUTE(v_coluna3) - ABSOLUTE(v_COLuna2)) < v_vlr_minimo_neg THEN DO:
                
             
            
             FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cod_demonst = demonst_ctbl.des_tit_ctbl
                                                  AND   ext_justificativa.Cod_padr_col = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                  AND   ext_justificativa.Periodo     = prefer_demonst_ctbl.num_period_ctbl
                                                  AND   ext_justificativa.Ano         = INT(prefer_demonst_ctbl.cod_exerc_ctbl)
                                                  AND   ext_justificativa.cta_ctbl     = entry(1, trim(tt_demonst_ctbl_fin.ttv_cod_campo_1), "|")
                                                  AND   ext_justificativa.ccusto       =  trim(conjto_prefer_demonst.cod_demonst_ctbl)
                                                  AND   ext_justificativa.log_justif  = YES NO-ERROR.

        IF AVAIL ext_justificativa THEN DO:
                 
             

           
         assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
                tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
        END. /*Fim da ext_justificativa*/




     /* novo - inserido em 26/07/2017 para fazer com que os itens existentes em ext_exc nao sejam destacados */

     FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                          AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

        IF AVAIL ext_exc_justificativas THEN DO:
            assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                   tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
    
    
        END. /* fim da ext_exc_justificativa*/


     IF NOT AVAIL ext_justificativa THEN DO:



     assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 14 
            tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 14
            tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
            tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

        END. /*fim da ext_justificativa*/ 
        

     /* novo - inserido em 26/07/2017 para fazer com que os itens existentes em ext_exc nao sejam destacados */
        FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                  AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.


        IF AVAIL ext_exc_justificativas THEN DO:

            assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                   tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                   tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                   tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

        END. /*fim da ext_exc_justificativa*/ 


      END. /* fim da varicao maior que R$ 300,00*/
    RETURN.
   END.   /* fim da variacao % */
 
 
    
   



        IF  v_coluna4 = 0 
         THEN DO:



            FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cod_demonst = demonst_ctbl.des_tit_ctbl
                                                 AND   ext_justificativa.Cod_padr_col = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                 AND   ext_justificativa.Periodo     = prefer_demonst_ctbl.num_period_ctbl
                                                 AND   ext_justificativa.Ano         = INT(prefer_demonst_ctbl.cod_exerc_ctbl)
                                                 AND   ext_justificativa.cta_ctbl     = entry(1, trim(tt_demonst_ctbl_fin.ttv_cod_campo_1), "|")
                                                 AND   ext_justificativa.ccusto    = trim(conjto_prefer_demonst.cod_demonst_ctbl)
                                                 AND   ext_justificativa.log_justif  = YES NO-ERROR.

            IF AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
            END.

    FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = demonst_ctbl.des_tit_ctbl
                                         AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

   IF AVAIL ext_exc_justificativas THEN DO:
       assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
              tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
              tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
              tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.

    IF NOT AVAIL ext_justificativa THEN DO:





        assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
               tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
               tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
               tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.

           END.

                FIND FIRST ext_exc_justificativas NO-LOCK WHERE ext_exc_justificativas.cod_padr_coluna = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                                                     AND   ext_exc_justificativas.cod_palavra     = trim(tt_demonst_ctbl_fin.ttv_cod_campo_1) NO-ERROR.

               IF AVAIL ext_exc_justificativas THEN DO:
                   assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15 
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
                          tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                          tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.


            END.
            RETURN.
        END.
            



     ELSE DO:

         assign tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 10 
                tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 10
                tt_demonst_ctbl_fin.ttv_cod_campo_1:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_2:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_3:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_4:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_5:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_6:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_7:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_8:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_9:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_10:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_11:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_12:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_13:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_14:fgcolor in browse br_demonst_ctbl_fin = 0
                tt_demonst_ctbl_fin.ttv_cod_campo_15:fgcolor in browse br_demonst_ctbl_fin = 0.
           
        END.  
     END.
    END CASE.
END PROCEDURE. /* pi_row_display */
/*****************************************************************************
** Procedure Interna.....: pi_tt_demonst_ctbl_fin_new_estabelecimento
** Descricao.............: pi_tt_demonst_ctbl_fin_new_estabelecimento
** Criado por............: src531
** Criado em.............: 16/08/2002 16:12:52
** Alterado por..........: src531
** Alterado em...........: 17/09/2002 08:46:05
*****************************************************************************/
PROCEDURE pi_tt_demonst_ctbl_fin_new_estabelecimento:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign v_log_return = no
               v_cod_inform = "Estabelecimento" /*l_estabelecimento*/ .

        if  tt_demonst_ctbl_fin.tta_cod_estab = "" then do:
            /* Lº toDAS AS COMPOSI∞ÜES ORIGENS DA COPIA */
            for each btt_compos_demonst_cadastro no-lock
                 where btt_compos_demonst_cadastro.cod_demonst_ctbl       = v_cod_demonst_ctbl
                   and btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl):

                for each emscad.unid_organ
                   where unid_organ.cod_unid_organ    >= btt_compos_demonst_cadastro.cod_unid_organ
                   and   unid_organ.cod_unid_organ    <= btt_compos_demonst_cadastro.cod_unid_organ_fim
                   and   unid_organ.num_niv_unid_organ = 998:
                    /* Verificar os itens da faixa */
                    for each estabelecimento no-lock
                        where estabelecimento.cod_empresa = unid_organ.cod_unid_organ
                        and   estabelecimento.cod_estab  >= btt_compos_demonst_cadastro.cod_estab_inic
                        and   estabelecimento.cod_estab  <= btt_compos_demonst_cadastro.cod_estab_fim:
                        assign v_cod_chave  = estabelecimento.cod_estab.

                        find first btt_demonst_ctbl_fin
                           where btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           and   btt_demonst_ctbl_fin.tta_cod_estab = v_cod_chave
                           no-lock no-error.
                        if avail btt_demonst_ctbl_fin then
                            next.

                        run pi_compos_estrut (Input p_num_espaco) /*pi_compos_estrut*/.
                    end.
                end.
            end.
        end.

        run pi_compos_estrut_2.
END PROCEDURE. /* pi_tt_demonst_ctbl_fin_new_estabelecimento */
/*****************************************************************************
** Procedure Interna.....: pi_compos_estrut
** Descricao.............: pi_compos_estrut
** Criado por............: src531
** Criado em.............: 16/08/2002 16:36:46
** Alterado por..........: fut41422
** Alterado em...........: 18/11/2013 09:33:58
*****************************************************************************/
PROCEDURE pi_compos_estrut:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_espaco
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_ret_segur
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    /* Verifica restricoes de seguranca */
    case v_cod_inform:
        when "Centro de Custo" /*l_centro_de_custo*/  then do:
            /* --- Verifica se Usuˇrio tem permissío de acesso ---*/ 
            run pi_verifica_segur_ccusto_demonst (Input estrut_ccusto.cod_empresa,
                                                  Input estrut_ccusto.cod_plano_ccusto,
                                                  Input v_cod_chave,
                                                  output v_log_ret_segur) /*pi_verifica_segur_ccusto_demonst*/. 
            if  v_log_ret_segur = no then do:
                assign v_des_lista_ccusto_sem_segur = v_des_lista_ccusto_sem_segur + chr(10) + v_cod_chave.
                return.
            end.
        end.
        when "Projeto" /*l_projeto*/  then do:
        end.
        when "Unidade Neg¢cio" /*l_unidade_negocio*/  then do:
        end.
    end.    

    assign v_log_return = yes.

    create tt_item_demonst_ctbl_video.
    buffer-copy btt_item_demonst_ctbl_video to tt_item_demonst_ctbl_video.
    assign v_des_visualiz                                             = v_cod_chave
           tt_item_demonst_ctbl_video.ttv_cod_identif_campo           = v_cod_inform
           tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video)
           tt_item_demonst_ctbl_video.ttv_cod_chave_1                 = v_cod_chave
           v_num_count                                                = v_num_count + 10.

    assign v_num_cont_2 = 0.
    /* 218397 - Frangosul */
    if v_log_tit_demonst then do:
        for each tt_col_demonst_ctbl no-lock
            where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
              and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T°tulo" /*l_titulo*/ :
            assign v_num_cont_2 = v_num_cont_2 + 1.
            run pi_busca_descricoes_video.
        end.
    end.
    else do:
        find first tt_col_demonst_ctbl no-lock
            where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
              and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T°tulo" /*l_titulo*/  no-error.
        if avail tt_col_demonst_ctbl then do:
            run pi_busca_descricoes_video.
        end.
    end.

    assign v_des_chave = tt_item_demonst_ctbl_video.ttv_des_chave_1.

    create btt_demonst_ctbl_fin.
    assign btt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = -40000 + v_num_count
           btt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
           btt_demonst_ctbl_fin.ttv_log_expand = NO
           btt_demonst_ctbl_fin.ttv_num_nivel  = v_num_nivel
           btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video
           btt_demonst_ctbl_fin.ttv_des_col_demonst_video = fill(" ",p_num_espaco) + v_des_chave.

    assign btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho    = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho
           btt_demonst_ctbl_fin.tta_cod_ccusto_filho      = tt_demonst_ctbl_fin.tta_cod_ccusto_filho
           btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = tt_demonst_ctbl_fin.tta_cod_proj_financ_filho
           btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho  = tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
           btt_demonst_ctbl_fin.tta_cod_estab             = tt_demonst_ctbl_fin.tta_cod_estab
           btt_demonst_ctbl_fin.ttv_log_expand_estab      = tt_demonst_ctbl_fin.ttv_log_expand_estab
           btt_demonst_ctbl_fin.tta_cod_unid_organ_filho  = tt_demonst_ctbl_fin.tta_cod_unid_organ_filho.

    case v_cod_inform:
        when "Conta Cont†bil" /*l_conta_contabil*/  then
            assign btt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho    = v_cod_chave.
        when "Centro de Custo" /*l_centro_de_custo*/  then
            assign btt_demonst_ctbl_fin.tta_cod_ccusto_filho      = v_cod_chave.
        when "Projeto" /*l_projeto*/  then
            assign btt_demonst_ctbl_fin.tta_cod_proj_financ_filho = v_cod_chave.
        when "Unidade Neg¢cio" /*l_unidade_negocio*/  then
            assign btt_demonst_ctbl_fin.tta_cod_unid_negoc_filho  = v_cod_chave.
        when "Estabelecimento" /*l_estabelecimento*/  then do:
            assign btt_demonst_ctbl_fin.tta_cod_estab             = v_cod_chave
                   btt_demonst_ctbl_fin.ttv_log_expand_estab = yes.   
        end.
        when "UO Origem" /*l_uo_origem*/  then 
            assign btt_demonst_ctbl_fin.tta_cod_unid_organ_filho  = v_cod_chave.
    end.    

    assign btt_demonst_ctbl_fin.ttv_cod_inform_princ = v_cod_inform.

    case v_num_lin_tit:
        when 1 then assign btt_demonst_ctbl_fin.ttv_cod_campo_1 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 2 then assign btt_demonst_ctbl_fin.ttv_cod_campo_2 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 3 then assign btt_demonst_ctbl_fin.ttv_cod_campo_3 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 4 then assign btt_demonst_ctbl_fin.ttv_cod_campo_4 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 5 then assign btt_demonst_ctbl_fin.ttv_cod_campo_5 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 6 then assign btt_demonst_ctbl_fin.ttv_cod_campo_6 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 7 then assign btt_demonst_ctbl_fin.ttv_cod_campo_7 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 8 then assign btt_demonst_ctbl_fin.ttv_cod_campo_8 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 9 then assign btt_demonst_ctbl_fin.ttv_cod_campo_9 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 10 then assign btt_demonst_ctbl_fin.ttv_cod_campo_10 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 11 then assign btt_demonst_ctbl_fin.ttv_cod_campo_11 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 12 then assign btt_demonst_ctbl_fin.ttv_cod_campo_12 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 13 then assign btt_demonst_ctbl_fin.ttv_cod_campo_13 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 14 then assign btt_demonst_ctbl_fin.ttv_cod_campo_14 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
        when 15 then assign btt_demonst_ctbl_fin.ttv_cod_campo_15 = fill(" ",(4 * v_num_nivel)) + v_des_chave.
    end case.

    /* Nao retirar este find. Esta aqui devido a uma falha do progress que nao cria o registro 
       no buffer enquanto nao acabar a transacao */
    find first btt_demonst_ctbl_fin no-error.
END PROCEDURE. /* pi_compos_estrut */
/*****************************************************************************
** Procedure Interna.....: pi_compos_estrut_2
** Descricao.............: pi_compos_estrut_2
** Criado por............: src531
** Criado em.............: 16/08/2002 16:36:38
** Alterado por..........: fut41422_1
** Alterado em...........: 11/06/2012 14:33:28
*****************************************************************************/
PROCEDURE pi_compos_estrut_2:

    /************************* Variable Definition Begin ************************/

    def var v_cdn_cont_lista
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_cdn_tot_lista
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_log_abert
        as logical
        format "Sim/Nao"
        initial yes
        no-undo.
    def var v_num_count_1
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_lista_cta_restric:
        delete tt_lista_cta_restric.
    end.

    if v_log_return = yes then do:

        assign v_log_abert = no.

        EMPTY TEMP-TABLE tt_valor_aux.
        EMPTY TEMP-TABLE tt_relacto_valor_aux.

        for each tt_relacto_item_retorna 
           where tt_relacto_item_retorna.ttv_rec_item_demonst = btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video,
            first tt_retorna_sdo_ctbl_demonst
                where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_item_retorna.ttv_rec_ret
                by tt_retorna_sdo_ctbl_demonst.ttv_log_sdo_orcado_sint:

            /* **** RAFA ******/
            if  v_log_orcto_cta_sint then do:
                IF  v_cod_inform = "Conta Cont†bil" /*l_conta_contabil*/ 
                AND tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl THEN
                    NEXT.

                find tt_cta_ctbl_demonst
                   where tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
                   and   tt_cta_ctbl_demonst.tta_cod_cta_ctbl       = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
                   no-lock no-error.
                if avail tt_cta_ctbl_demonst 
                and tt_cta_ctbl_demonst.tta_ind_espec_cta_ctbl = "SintÇtica" /*l_sintetica*/  then do:
                    run pi_localiza_tt_cta_ctbl_analitica_demonst (Input tt_cta_ctbl_demonst.tta_cod_cta_ctbl) /*pi_localiza_tt_cta_ctbl_analitica_demonst*/.
                end.
            end.
            /* ****************/

            case v_cod_inform:
                when "Conta Cont†bil" /*l_conta_contabil*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl.
                when "Centro de Custo" /*l_centro_de_custo*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto.
                when "Projeto" /*l_projeto*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_proj_financ.
                when "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc.
                when "Estabelecimento" /*l_estabelecimento*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_estab.
                when "UO Origem" /*l_uo_origem*/  then
                    assign v_cod_chave = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig.
            end.    

            find tt_valor_aux 
                where tt_valor_aux.ttv_cod_inform_1 = v_cod_chave
                no-error.
            if not avail tt_valor_aux then do:
                create tt_valor_aux.
                assign tt_valor_aux.tta_cod_seq        = string(tt_retorna_sdo_ctbl_demonst.tta_num_seq)
                       tt_valor_aux.ttv_cod_inform_1 = v_cod_chave.
            end.
            else do:
                if lookup(string(tt_retorna_sdo_ctbl_demonst.tta_num_seq), tt_valor_aux.tta_cod_seq, chr(10)) = 0 then
                    assign tt_valor_aux.tta_cod_seq = tt_valor_aux.tta_cod_seq + chr(10) + string(tt_retorna_sdo_ctbl_demonst.tta_num_seq).
            end.
            create tt_relacto_valor_aux.
            assign tt_relacto_valor_aux.ttv_rec_val_aux   = recid(tt_valor_aux)
                   tt_relacto_valor_aux.ttv_rec_ret_sdo = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl
                   tt_relacto_valor_aux.tta_num_seq            = tt_retorna_sdo_ctbl_demonst.tta_num_seq.
        end.

        for each tt_valor_aux:
            assign v_cod_chave = tt_valor_aux.ttv_cod_inform_1.

            bloco1:
            repeat:
                if v_cod_chave = "" then
                    leave bloco1.
                case v_cod_inform:
                    when "Conta Cont†bil" /*l_conta_contabil*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho = v_cod_chave 
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                    when "Centro de Custo" /*l_centro_de_custo*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_ccusto_filho = v_cod_chave
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                    when "Projeto" /*l_projeto*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_proj_financ_filho = v_cod_chave
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                    when "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho = v_cod_chave
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                    when "Estabelecimento" /*l_estabelecimento*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_estab = v_cod_chave
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                    when "UO Origem" /*l_uo_origem*/  then
                        find first tt_demonst_ctbl_fin 
                           where tt_demonst_ctbl_fin.tta_cod_unid_organ_filho = v_cod_chave
                           and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                           no-error.
                end.    

                if not avail tt_demonst_ctbl_fin then do:

                    case v_cod_inform:
                        when "Conta Cont†bil" /*l_conta_contabil*/  then do:
                            find tt_cta_ctbl_demonst
                               where tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                               and tt_cta_ctbl_demonst.tta_cod_cta_ctbl = v_cod_chave
                               no-error.
                            if avail tt_cta_ctbl_demonst then
                                assign v_cod_chave = tt_cta_ctbl_demonst.ttv_cod_cta_ctbl_pai.
                            else
                                leave bloco1.
                        end.
                        when "Centro de Custo" /*l_centro_de_custo*/  then do:
                            Find first tt_relacto_valor_aux 
                               where tt_relacto_valor_aux.ttv_rec_val_aux   = recid(tt_valor_aux)
                               and   tt_relacto_valor_aux.tta_num_seq          = integer(entry(1,tt_valor_aux.tta_cod_seq, chr(10))) 
                               no-error.
                               /* o entry acima pode ser fixo 1 pois os conte£dos seguintes de sequància dizem respeito as colunas do demonstrativo
                                  n∆o interferindo na definiá∆o da empresa e plano de ccusto  (ati 148737) - ocorrància de erro qdo composiá∆o do item 
                                  definida com <n> empresas e <n> plano de ccustos */
                            if avail tt_relacto_valor_aux 
                            then do:
                               find first tt_retorna_sdo_ctbl_demonst
                               where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_valor_aux.ttv_rec_ret_sdo
                               no-error.
                               If avail tt_retorna_sdo_ctbl_demonst
                               then do:
                                   find tt_ccustos_demonst
                                       where tt_ccustos_demonst.tta_cod_empresa      = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
                                       and   tt_ccustos_demonst.tta_cod_plano_ccusto = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto
                                       and   tt_ccustos_demonst.tta_cod_ccusto       = v_cod_chave
                                       no-error.
                                   if avail tt_ccustos_demonst then
                                       assign v_cod_chave = tt_ccustos_demonst.ttv_cod_ccusto_pai.
                                   else
                                       leave bloco1.
                               end.
                               else
                                  leave bloco1.         
                            end.
                            else do:
                               find tt_ccustos_demonst
                                    where tt_ccustos_demonst.tta_cod_empresa      = v_cod_unid_organ
                                    and   tt_ccustos_demonst.tta_cod_plano_ccusto = v_cod_plano_ccusto
                                    and   tt_ccustos_demonst.tta_cod_ccusto       = v_cod_chave
                               no-error.
                               if avail  tt_ccustos_demonst then
                                  assign v_cod_chave = tt_ccustos_demonst.ttv_cod_ccusto_pai.
                               else 
                                  leave bloco1.                   
                            end.
                        end.
                        when "Projeto" /*l_projeto*/  then do:
                            find tt_proj_financ_demonst
                               where tt_proj_financ_demonst.tta_cod_proj_financ = v_cod_chave
                               no-error.
                            assign v_cod_chave = tt_proj_financ_demonst.ttv_cod_proj_financ_pai.
                        end.
                        when "Unidade Neg¢cio" /*l_unidade_negocio*/  then do:
                            find tt_unid_negocio
                               where tt_unid_negocio.tta_cod_unid_negoc = v_cod_chave
                               no-error.
                            assign v_cod_chave = tt_unid_negocio.ttv_cod_unid_negoc_pai.
                        end.
                        when "Estabelecimento" /*l_estabelecimento*/  then do:
                            leave bloco1.
                        end.
                        when "UO Origem" /*l_uo_origem*/  then do:
                            find emscad.estrut_unid_organ
                               where estrut_unid_organ.cod_unid_organ_filho = v_cod_chave
                               no-lock no-error.
                            if avail estrut_unid_organ then do:
                                assign v_cod_chave = estrut_unid_organ.cod_unid_organ_pai.
                            end.
                            else
                                leave bloco1.
                        end.
                    end.    
                end.
                else do:
                    assign v_log_abert = yes.
                    find tt_item_demonst_ctbl_video
                      where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                      no-error.
                    assign v_log_final_proces = no.

                    do v_num_count_1 = 1 to num-entries(tt_valor_aux.tta_cod_seq, chr(10)):

                        /* Atualizacao do Valor da Linha */    
                        assign v_val_sdo_ctbl_fim            = 0
                               v_val_sdo_ctbl_ini            = 0
                               v_val_sdo_ctbl_db             = 0
                               v_val_sdo_ctbl_cr             = 0
                               v_val_apurac_restdo_inic_50   = 0
                               v_val_apurac_restdo_acum_505  = 0
                               v_val_apurac_restdo_db_505    = 0
                               v_val_apurac_restdo_cr_505    = 0
                               v_val_apurac_restdo_movto_50  = 0
                               v_qtd_sdo_ctbl_db             = 0
                               v_qtd_sdo_ctbl_cr             = 0
                               v_qtd_sdo_ctbl_fim            = 0
                               v_qtd_sdo_ctbl_inic           = 0
                               v_val_movto_empenh            = 0
                               v_qtd_movto_empenh            = 0
                               v_val_movto                   = 0
                               v_qtd_movto                   = 0
                               v_val_orcado                  = 0
                               v_val_orcado_sdo              = 0
                               v_qtd_orcado                  = 0
                               v_qtd_orcado_sdo              = 0
                               v_val_perc_particip           = 0.

                        find tt_rel_grp_col_compos_demonst 
                           where tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo = integer(entry(v_num_count_1,tt_valor_aux.tta_cod_seq, chr(10)))
                           no-error.
                        find tt_grp_col_demonst_video
                           where recid(tt_grp_col_demonst_video) = tt_rel_grp_col_compos_demonst.ttv_rec_grp_col_demonst_ctbl
                           no-error.
                        find tt_compos_demonst_cadastro
                           where recid(tt_compos_demonst_cadastro) = tt_rel_grp_col_compos_demonst.ttv_rec_compos_demonst_ctbl
                           no-error.
                        for each tt_relacto_valor_aux
                           where tt_relacto_valor_aux.tta_num_seq          = integer(entry(v_num_count_1,tt_valor_aux.tta_cod_seq, chr(10)))
                           and   tt_relacto_valor_aux.ttv_rec_val_aux = recid(tt_valor_aux):
                            find tt_retorna_sdo_ctbl_demonst
                               where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_valor_aux.ttv_rec_ret_sdo
                               no-error.
                            if avail tt_retorna_sdo_ctbl_demonst then do:
                                create tt_relacto_item_retorna.
                                assign tt_relacto_item_retorna.tta_num_seq             = 0
                                       tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                                       tt_relacto_item_retorna.ttv_rec_ret          = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl.

                                /* ********* RAFA ***********/
                                if  v_log_orcto_cta_sint then do:
                                    IF  tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo = "Oráamento" /*l_orcamento*/  THEN DO:
                                        find first tt_lista_cta_restric
                                           where tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_filho = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl
                                           no-lock no-error.
                                        if avail tt_lista_cta_restric then do:
                                            if tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto <> '' then
                                                next.
                                            else do:
                                                for each tt_retorna_sdo_orcto_ccusto
                                                   where tt_retorna_sdo_orcto_ccusto.ttv_rec_ret_sdo_ctbl = recid(tt_retorna_sdo_ctbl_demonst):
                                                    if not can-find(btt_retorna_sdo_orcto_ccusto
                                                                where btt_retorna_sdo_orcto_ccusto.ttv_rec_ret_sdo_ctbl = tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_pai
                                                                and   btt_retorna_sdo_orcto_ccusto.tta_cod_plano_ccusto = tt_retorna_sdo_orcto_ccusto.tta_cod_plano_ccusto
                                                                and   btt_retorna_sdo_orcto_ccusto.tta_cod_ccusto       = tt_retorna_sdo_orcto_ccusto.tta_cod_ccusto) then do:
                                                        assign v_val_orcado                  = v_val_orcado + tt_retorna_sdo_orcto_ccusto.tta_val_orcado     
                                                               v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_val_orcado_sdo 
                                                               v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado     
                                                               v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado_sdo.
                                                    end.
                                                end.
                                                next.
                                            end.
                                        end.
                                    END.
                                end.
                              


                                assign v_val_sdo_ctbl_fim            = v_val_sdo_ctbl_fim + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim
                                       v_val_sdo_ctbl_ini            = v_val_sdo_ctbl_ini + (tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl)
                                       v_val_sdo_ctbl_db             = v_val_sdo_ctbl_db  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db
                                       v_val_sdo_ctbl_cr             = v_val_sdo_ctbl_cr  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr
                                       v_val_movto                   = v_val_movto + tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl
                                       v_qtd_sdo_ctbl_fim            = v_qtd_sdo_ctbl_fim + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim
                                       v_qtd_sdo_ctbl_inic           = v_qtd_sdo_ctbl_inic + (tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl)
                                       v_qtd_sdo_ctbl_db             = v_qtd_sdo_ctbl_db + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_db
                                       v_qtd_sdo_ctbl_cr             = v_qtd_sdo_ctbl_cr + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_cr
                                       v_qtd_movto                   = v_qtd_movto + tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl
                                       v_val_apurac_restdo_acum_505  = v_val_apurac_restdo_acum_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum
                                       v_val_apurac_restdo_db_505    = v_val_apurac_restdo_db_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db
                                       v_val_apurac_restdo_cr_505    = v_val_apurac_restdo_cr_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr
                                       v_val_apurac_restdo_movto_50 = v_val_apurac_restdo_movto_50 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo
                                       v_val_apurac_restdo_inic_50   = v_val_apurac_restdo_inic_50 + (tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo)
                                       v_val_movto_empenh            = v_val_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_val_movto_empenh
                                       v_qtd_movto_empenh            = v_qtd_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_qtd_movto_empenh
                                       v_val_orcado                  = v_val_orcado + tt_retorna_sdo_ctbl_demonst.tta_val_orcado     
                                       v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_val_orcado_sdo 
                                       v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado     
                                       v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado_sdo
                                       v_val_perc_particip           = tt_retorna_sdo_ctbl_demonst.ttv_val_perc_criter_distrib.
                            end.

                        end.
                        run pi_item_demonst_ctbl_video_trata_sdo (input tt_compos_demonst_cadastro.log_inverte_val).
                    end.
                    leave bloco1.
                end.
            end.
        end.
        if  v_log_funcao_concil_consolid
        then do:
            if  v_cod_inform = "UO Origem" /*l_uo_origem*/  and v_log_abert = no then
                run pi_compos_estrut_3 /*pi_compos_estrut_3*/.
        end.
    end.
END PROCEDURE. /* pi_compos_estrut_2 */
/*****************************************************************************
** Procedure Interna.....: pi_compos_estrut_3
** Descricao.............: pi_compos_estrut_3
** Criado por............: its0068
** Criado em.............: 25/08/2005 18:26:31
** Alterado por..........: its0068
** Alterado em...........: 22/09/2005 08:28:11
*****************************************************************************/
PROCEDURE pi_compos_estrut_3:

    /************************* Variable Definition Begin ************************/

    def var v_cdn_cont_lista
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_cdn_tot_lista
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_num_count_1
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_lista_cta_restric:
        delete tt_lista_cta_restric.
    end.

    EMPTY TEMP-TABLE tt_valor_aux.
    EMPTY TEMP-TABLE tt_relacto_valor_aux.

    for each tt_relacto_item_retorna 
       where tt_relacto_item_retorna.ttv_rec_item_demonst = btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video,
        first tt_retorna_sdo_ctbl_demonst
            where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_item_retorna.ttv_rec_ret:
        for each tt_relacto_item_retorna_cons
           where tt_relacto_item_retorna_cons.ttv_rec_ret_orig = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl,
            first btt_retorna_sdo_ctbl_demonst
                where btt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_item_retorna_cons.ttv_rec_ret_dest:
            assign v_cod_chave = btt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig.
            find tt_valor_aux 
                where tt_valor_aux.ttv_cod_inform_1 = v_cod_chave
                no-error.
            if not avail tt_valor_aux then do:
                create tt_valor_aux.
                assign tt_valor_aux.tta_cod_seq        = string(btt_retorna_sdo_ctbl_demonst.tta_num_seq)
                       tt_valor_aux.ttv_cod_inform_1 = v_cod_chave.
            end.
            else do:
                if lookup(string(btt_retorna_sdo_ctbl_demonst.tta_num_seq), tt_valor_aux.tta_cod_seq, chr(10)) = 0 then
                    assign tt_valor_aux.tta_cod_seq = tt_valor_aux.tta_cod_seq + chr(10) + string(btt_retorna_sdo_ctbl_demonst.tta_num_seq).
            end.
            create tt_relacto_valor_aux.
            assign tt_relacto_valor_aux.ttv_rec_val_aux   = recid(tt_valor_aux)
                   tt_relacto_valor_aux.ttv_rec_ret_sdo   = btt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl
                   tt_relacto_valor_aux.tta_num_seq       = btt_retorna_sdo_ctbl_demonst.tta_num_seq.
        end.
    end.

    for each tt_valor_aux:
        assign v_cod_chave = tt_valor_aux.ttv_cod_inform_1.

        bloco1:
        repeat:
            if v_cod_chave = "" then
                leave bloco1.
            find first tt_demonst_ctbl_fin 
               where tt_demonst_ctbl_fin.tta_cod_unid_organ_filho = v_cod_chave
               and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
               no-error.

            if not avail tt_demonst_ctbl_fin then do:
                find emscad.estrut_unid_organ
                   where estrut_unid_organ.cod_unid_organ_filho = v_cod_chave
                   no-lock no-error.
                if avail estrut_unid_organ then do:
                    assign v_cod_chave = estrut_unid_organ.cod_unid_organ_pai.
                end.
                else
                    leave bloco1.
            end.
            else do:
                find tt_item_demonst_ctbl_video
                  where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                  no-error.
                assign v_log_final_proces = no.

                do v_num_count_1 = 1 to num-entries(tt_valor_aux.tta_cod_seq, chr(10)):

                    /* Atualizacao do Valor da Linha */    
                    assign v_val_sdo_ctbl_fim            = 0
                           v_val_sdo_ctbl_ini            = 0
                           v_val_sdo_ctbl_db             = 0
                           v_val_sdo_ctbl_cr             = 0
                           v_val_apurac_restdo_inic_50   = 0
                           v_val_apurac_restdo_acum_505  = 0
                           v_val_apurac_restdo_db_505    = 0
                           v_val_apurac_restdo_cr_505    = 0
                           v_val_apurac_restdo_movto_50  = 0
                           v_qtd_sdo_ctbl_db             = 0
                           v_qtd_sdo_ctbl_cr             = 0
                           v_qtd_sdo_ctbl_fim            = 0
                           v_qtd_sdo_ctbl_inic           = 0
                           v_val_movto_empenh            = 0
                           v_qtd_movto_empenh            = 0
                           v_val_movto                   = 0
                           v_qtd_movto                   = 0
                           v_val_orcado                  = 0
                           v_val_orcado_sdo              = 0
                           v_qtd_orcado                  = 0
                           v_qtd_orcado_sdo              = 0
                           v_val_perc_particip           = 0.

                    find tt_rel_grp_col_compos_demonst 
                       where tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo = integer(entry(v_num_count_1,tt_valor_aux.tta_cod_seq, chr(10)))
                       no-error.
                    find tt_grp_col_demonst_video
                       where recid(tt_grp_col_demonst_video) = tt_rel_grp_col_compos_demonst.ttv_rec_grp_col_demonst_ctbl
                       no-error.
                    find tt_compos_demonst_cadastro
                       where recid(tt_compos_demonst_cadastro) = tt_rel_grp_col_compos_demonst.ttv_rec_compos_demonst_ctbl
                       no-error.
                    for each tt_relacto_valor_aux
                       where tt_relacto_valor_aux.tta_num_seq          = integer(entry(v_num_count_1,tt_valor_aux.tta_cod_seq, chr(10)))
                       and   tt_relacto_valor_aux.ttv_rec_val_aux = recid(tt_valor_aux):
                        find tt_retorna_sdo_ctbl_demonst
                           where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_valor_aux.ttv_rec_ret_sdo
                           no-error.
                        if avail tt_retorna_sdo_ctbl_demonst then do:
                            create tt_relacto_item_retorna.
                            assign tt_relacto_item_retorna.tta_num_seq             = 0
                                   tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                                   tt_relacto_item_retorna.ttv_rec_ret          = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl.

                            /* ********* RAFA ***********/
                            if  v_log_orcto_cta_sint then do:
                                IF  tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo = "Oráamento" /*l_orcamento*/  THEN DO:
                                    find first tt_lista_cta_restric
                                       where tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_filho = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl
                                       no-lock no-error.
                                    if avail tt_lista_cta_restric then do:
                                        if tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto <> '' then
                                            next.
                                        else do:
                                            for each tt_retorna_sdo_orcto_ccusto
                                               where tt_retorna_sdo_orcto_ccusto.ttv_rec_ret_sdo_ctbl = recid(tt_retorna_sdo_ctbl_demonst):
                                                if not can-find(btt_retorna_sdo_orcto_ccusto
                                                            where btt_retorna_sdo_orcto_ccusto.ttv_rec_ret_sdo_ctbl = tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_pai
                                                            and   btt_retorna_sdo_orcto_ccusto.tta_cod_plano_ccusto = tt_retorna_sdo_orcto_ccusto.tta_cod_plano_ccusto
                                                            and   btt_retorna_sdo_orcto_ccusto.tta_cod_ccusto       = tt_retorna_sdo_orcto_ccusto.tta_cod_ccusto) then do:
                                                    assign v_val_orcado                  = v_val_orcado + tt_retorna_sdo_orcto_ccusto.tta_val_orcado     
                                                           v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_val_orcado_sdo 
                                                           v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado     
                                                           v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado_sdo.
                                                end.
                                            end.
                                            next.
                                        end.
                                    end.
                                END.
                            end.
                            /* *************************/

                            assign v_val_sdo_ctbl_fim            = v_val_sdo_ctbl_fim + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim
                                   v_val_sdo_ctbl_ini            = v_val_sdo_ctbl_ini + (tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl)
                                   v_val_sdo_ctbl_db             = v_val_sdo_ctbl_db  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db
                                   v_val_sdo_ctbl_cr             = v_val_sdo_ctbl_cr  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr
                                   v_val_movto                   = v_val_movto + tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl
                                   v_qtd_sdo_ctbl_fim            = v_qtd_sdo_ctbl_fim + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim
                                   v_qtd_sdo_ctbl_inic           = v_qtd_sdo_ctbl_inic + (tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl)
                                   v_qtd_sdo_ctbl_db             = v_qtd_sdo_ctbl_db + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_db
                                   v_qtd_sdo_ctbl_cr             = v_qtd_sdo_ctbl_cr + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_cr
                                   v_qtd_movto                   = v_qtd_movto + tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl
                                   v_val_apurac_restdo_acum_505  = v_val_apurac_restdo_acum_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum
                                   v_val_apurac_restdo_db_505    = v_val_apurac_restdo_db_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db
                                   v_val_apurac_restdo_cr_505    = v_val_apurac_restdo_cr_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr
                                   v_val_apurac_restdo_movto_50 = v_val_apurac_restdo_movto_50 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo
                                   v_val_apurac_restdo_inic_50   = v_val_apurac_restdo_inic_50 + (tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo)
                                   v_val_movto_empenh            = v_val_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_val_movto_empenh
                                   v_qtd_movto_empenh            = v_qtd_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_qtd_movto_empenh
                                   v_val_orcado                  = v_val_orcado + tt_retorna_sdo_ctbl_demonst.tta_val_orcado     
                                   v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_val_orcado_sdo 
                                   v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado     
                                   v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado_sdo
                                   v_val_perc_particip           = tt_retorna_sdo_ctbl_demonst.ttv_val_perc_criter_distrib.
                        end.
                    end.
                    run pi_item_demonst_ctbl_video_trata_sdo (input tt_compos_demonst_cadastro.log_inverte_val).
                end.
                leave bloco1.
            end.
        end.
    end.
END PROCEDURE. /* pi_compos_estrut_3 */
/*****************************************************************************
** Procedure Interna.....: pi_busca_descricoes_video
** Descricao.............: pi_busca_descricoes_video
** Criado por............: dalpra
** Criado em.............: 18/05/2001 19:18:32
** Alterado por..........: fut41422
** Alterado em...........: 24/10/2012 09:24:59
*****************************************************************************/
PROCEDURE pi_busca_descricoes_video:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_cta_ctbl_impr
        for cta_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_estab_aux
        as character
        format "x(3)":U
        label "Estabelecimento"
        column-label "Estabelecimento"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_estab_aux
        as Character
        format "x(5)":U
        label "Estabelecimento"
        column-label "Estabelecimento"
        no-undo.
    &ENDIF
    def var v_cod_unid_negoc_aux
        as character
        format "x(3)":U
        label "Unid Neg¢cio"
        column-label "Un Neg"
        no-undo.
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    def var v_cod_unid_organ_aux
        as character
        format "x(3)":U
        label "Unid Organizacional"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_unid_organ_aux
        as Character
        format "x(5)":U
        label "Unid Organizacional"
        column-label "Unid Organizacional"
        no-undo.
    &ENDIF


    /************************** Variable Definition End *************************/

    assign v_num_entry = lookup("UO Origem" /*l_uo_origem*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:

        assign v_cod_unid_organ_aux = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("UO Origem" /*l_uo_origem*/  , v_cod_lista_compon, ';').

        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
           find emscad.unid_organ no-lock
                where unid_organ.cod_unid_organ = v_cod_unid_organ_aux
                no-error.
           if  avail unid_organ then do:
               if  v_cod_dwb_user begins 'es_' 
               and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input unid_organ.des_unid_organ,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.
               else do:
                   run pi_retornar_trad_idiom (Input unid_organ.des_unid_organ,
                                               Input prefer_demonst_ctbl.cod_idioma,
                                               output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.                                           
               assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = v_cod_unid_organ_aux + '-' + chr(32) + v_des_tit_idiom.
            end.
            /* 218397 - Na segundo coluna do t°tulo n∆o exibe dados qdo a expans∆o Ç por Unid org.*/
            if v_log_tit_demonst and v_log_tit_demonst and v_num_cont_1 > 1 AND v_num_cont_2 > 1 then do:
                assign v_num_entry = v_num_cont_2
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ''.
            end.


            /* Begin_Include: i_busca_descricoes_video */
            case v_num_entry:
                 when 1 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 2 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 3 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 4 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 5 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 6 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
            end.
            /* End_Include: i_busca_descricoes_video */

        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.ttv_cod_chave_1.
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.ttv_cod_chave_2.
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.ttv_cod_chave_3.
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.ttv_cod_chave_4.
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.ttv_cod_chave_5.
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.ttv_cod_chave_6.
            end.
        end.
    end.

    assign v_num_entry = lookup("Estabelecimento" /*l_estabelecimento*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_estab_aux = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Estabelecimento" /*l_estabelecimento*/  , v_cod_lista_compon, ';').

        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
            find estabelecimento no-lock
                where estabelecimento.cod_estab = v_cod_estab_aux
                      no-error.
            if  avail estabelecimento
            then do:
               if v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input estabelecimento.nom_pessoa,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.
               else do:
                   run pi_retornar_trad_idiom (Input estabelecimento.nom_pessoa,
                                               Input prefer_demonst_ctbl.cod_idioma,
                                               output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.                                           
               assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = v_cod_estab_aux + '-' + chr(32) + v_des_tit_idiom.
            end.
            /* 218397 - Na segundo coluna do t°tulo n∆o exibe dados qdo a expans∆o Ç por estabelecimento.*/
            if v_log_tit_demonst and v_num_cont_1 > 1 AND v_num_cont_2 > 1 then do:
                assign v_num_entry = v_num_cont_2
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ''.
            end.

            /* Begin_Include: i_busca_descricoes_video */
            case v_num_entry:
                 when 1 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 2 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 3 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 4 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 5 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 6 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
            end.
            /* End_Include: i_busca_descricoes_video */

        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.ttv_cod_chave_1.
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.ttv_cod_chave_2.
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.ttv_cod_chave_3.
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.ttv_cod_chave_4.
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.ttv_cod_chave_5.
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.ttv_cod_chave_6.
            end.
        end.
    end.

    assign v_num_entry  = lookup("Unidade Neg¢cio" /*l_unidade_negocio*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_unid_negoc_aux = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Unidade Neg¢cio" /*l_unidade_negocio*/  , v_cod_lista_compon, ';').

        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
           find emscad.unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = v_cod_unid_negoc_aux
                      no-error.
            if  avail unid_negoc
            then do:
               if v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input unid_negoc.des_unid_negoc,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.
               else do:
                   run pi_retornar_trad_idiom (Input unid_negoc.des_unid_negoc,
                                               Input prefer_demonst_ctbl.cod_idioma,
                                               output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.                                           
               assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = v_cod_unid_negoc_aux + '-' + chr(32) + v_des_tit_idiom.
            end.
            /* 218397 - Na segundo coluna do t°tulo n∆o exibe dados qdo a expans∆o Ç por Unid Negoc.*/
            if v_log_tit_demonst and v_num_cont_1 > 1 AND v_num_cont_2 > 1 then do:
                assign v_num_entry = v_num_cont_2
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ''.
            end.

            /* Begin_Include: i_busca_descricoes_video */
            case v_num_entry:
                 when 1 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 2 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 3 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 4 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 5 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 6 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
            end.
            /* End_Include: i_busca_descricoes_video */

        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.ttv_cod_chave_1.
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.ttv_cod_chave_2.
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.ttv_cod_chave_3.
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.ttv_cod_chave_4.
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.ttv_cod_chave_5.
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.ttv_cod_chave_6.
            end.
        end.
    end.

    assign v_num_entry  = lookup("Centro de Custo" /*l_centro_de_custo*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_ccusto = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Centro de Custo" /*l_centro_de_custo*/  , v_cod_lista_compon, ';').
        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
            find emscad.ccusto no-lock
              where ccusto.cod_empresa        = v_cod_unid_organ
              and   ccusto.cod_plano_ccusto   = v_cod_plano_ccusto
              and   ccusto.cod_ccusto         = v_cod_ccusto
              no-error.
            if  avail ccusto then do:
               if  v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input ccusto.des_tit_ctbl,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                end.
                else do:
                   run pi_retornar_trad_idiom (Input ccusto.des_tit_ctbl,
                                               Input prefer_demonst_ctbl.cod_idioma,
                                               output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                end.
               assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = string(v_cod_ccusto, v_cod_format_ccusto)
                                                                + '-' + chr(32) + v_des_tit_idiom.
            end.
            /* 218397 - Na segundo coluna do t°tulo n∆o exibe dados qdo a expans∆o Ç por Ccusto.*/
            if v_log_tit_demonst and v_num_cont_1 > 1 AND v_num_cont_2 > 1 then do:
                assign v_num_entry = v_num_cont_2
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ''.
            end.

            /* Begin_Include: i_busca_descricoes_video */
            case v_num_entry:
                 when 1 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 2 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 3 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 4 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 5 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 6 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
            end.
            /* End_Include: i_busca_descricoes_video */

        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_1, v_cod_format_ccusto).
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_2, v_cod_format_ccusto).
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_3, v_cod_format_ccusto).
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_4, v_cod_format_ccusto).
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_5, v_cod_format_ccusto).
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_6, v_cod_format_ccusto).
            end.
        end.
    end.

    assign v_num_entry = lookup("Conta Cont†bil" /*l_conta_contabil*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_cta_ctbl = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Conta Cont†bil" /*l_conta_contabil*/  , v_cod_lista_compon, ';').
        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
           if v_cod_demonst_ctbl <> '' /* Se n∆o for Consulta de Saldos*/ then do:
               find b_cta_ctbl_impr no-lock
                 where b_cta_ctbl_impr.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                   and b_cta_ctbl_impr.cod_cta_ctbl        = v_cod_cta_ctbl no-error.
               if not avail b_cta_ctbl_impr then do:    
                   find b_cta_ctbl_impr no-lock
                     where b_cta_ctbl_impr.cod_plano_cta_ctbl = demonst_ctbl.cod_plano_cta_ctbl
                       and b_cta_ctbl_impr.cod_cta_ctbl        = v_cod_cta_ctbl no-error.
               end.
           end.
           else do:
               find b_cta_ctbl_impr no-lock
                 where b_cta_ctbl_impr.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                   and b_cta_ctbl_impr.cod_cta_ctbl        = v_cod_cta_ctbl no-error.
           end.   

           if  avail b_cta_ctbl_impr
           then do:
               if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl <> "N∆o" /*l_nao*/  
               then do:
                   if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl = "Sim" /*l_sim*/  
                   then do:
                       assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = 
                              string(b_cta_ctbl_impr.cod_cta_ctbl, v_cod_format_cta_ctbl).
                   end.
                   else do:
                       assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = b_cta_ctbl_impr.cod_cta_ctbl_padr_internac.
                   end /* else */.

                   /* 218397 - Para n∆o duplicar a descriá∆o nas colunas t°tulo caso possuir mais de uma*/ 
                   if (v_log_tit_demonst and  v_num_cont_1 = 1 or v_num_cont_2 = 1) or not v_log_tit_demonst then do:
                       if v_cod_dwb_user begins 'es_'
                       and v_nom_prog <> "Di†rio" /*l_diario*/  then do:               
                           run pi_retornar_trad_idiom (Input b_cta_ctbl_impr.des_tit_ctbl,
                                                       Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                       output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                       end.
                       else do:
                           run pi_retornar_trad_idiom (Input b_cta_ctbl_impr.des_tit_ctbl,
                                                       Input prefer_demonst_ctbl.cod_idioma,
                                                       output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                       end.
                       if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl = "Internacional" /*l_internacional*/  then 
                           assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = string(tt_item_demonst_ctbl_video.tta_des_tit_ctbl)
                                                                              + "-" + chr(32) + v_des_tit_idiom.
                       else 
                           assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = tt_item_demonst_ctbl_video.tta_des_tit_ctbl
                                                                              + "-" + chr(32) + v_des_tit_idiom.
                   end.
                   if v_log_tit_demonst and  v_num_cont_1 > 1 or v_num_cont_2 > 1 then do:
                       if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl = "Internacional" /*l_internacional*/  then 
                           assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = string(tt_item_demonst_ctbl_video.tta_des_tit_ctbl).
                       else 
                           assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                   end. /* if 218397*/
               end.
               else do:
                   if v_cod_dwb_user begins 'es_'
                   and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                        run pi_retornar_trad_idiom (Input b_cta_ctbl_impr.des_tit_ctbl,
                                                    Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                    output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                   end.
                   else do:
                       run pi_retornar_trad_idiom (Input b_cta_ctbl_impr.des_tit_ctbl,
                                                   Input prefer_demonst_ctbl.cod_idioma,
                                                   output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                   end.
                   assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = v_des_tit_idiom.
               end /* else */.
               if  length(tt_item_demonst_ctbl_video.tta_des_tit_ctbl) < 40
               then do:
                   assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = tt_item_demonst_ctbl_video.tta_des_tit_ctbl
                          + fill(chr(32), 40 - length(tt_item_demonst_ctbl_video.tta_des_tit_ctbl)).
               end.
           end.
           /* 218397 Qdo tiver mais de uma coluna t°tulo. utiliza o ttv_des_chave para cada coluna t°tulo*/
           if v_log_tit_demonst and v_num_cont_1 > 1 and v_num_cont_2 > 1 then 
               assign v_num_entry = v_num_cont_1.


           /* Begin_Include: i_busca_descricoes_video */
           case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
           end.
           /* End_Include: i_busca_descricoes_video */

        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_1, v_cod_format_cta_ctbl).
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_2, v_cod_format_cta_ctbl).
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_3, v_cod_format_cta_ctbl).
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_4, v_cod_format_cta_ctbl).
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_5, v_cod_format_cta_ctbl).
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_6, v_cod_format_cta_ctbl).
            end.
        end.
    end.

    assign v_num_entry  = lookup("Projeto" /*l_projeto*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_proj_financ = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Projeto" /*l_projeto*/  , v_cod_lista_compon, ';').
        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
           find proj_financ no-lock
                where proj_financ.cod_proj_financ = v_cod_proj_financ
                no-error.
            if  avail proj_financ
            then do:
               if v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input proj_financ.des_tit_ctbl,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.
               else do:
                   run pi_retornar_trad_idiom (Input proj_financ.des_tit_ctbl,
                                               Input prefer_demonst_ctbl.cod_idioma,
                                               output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
               end.                                            
               assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = string(v_cod_proj_financ, v_cod_format_proj_financ)
                                                                + '-' + chr(32) + v_des_tit_idiom.
            end.                      
            /* 218397 - Na segundo coluna do t°tulo n∆o exibe dados qdo a expans∆o Ç por Projeto.*/
            if v_log_tit_demonst and v_num_cont_1 > 1 AND v_num_cont_2 > 1 then do:
                assign v_num_entry = v_num_cont_2
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ''.
            end.

            /* Begin_Include: i_busca_descricoes_video */
            case v_num_entry:
                 when 1 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 2 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 3 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 4 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 5 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                 when 6 then
                     assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
            end.
            /* End_Include: i_busca_descricoes_video */


        end.
        else do:
            case v_num_entry:
                when 1 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_1, v_cod_format_proj_financ).
                when 2 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_2, v_cod_format_proj_financ).
                when 3 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_3, v_cod_format_proj_financ).
                when 4 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_4, v_cod_format_proj_financ).
                when 5 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_5, v_cod_format_proj_financ).
                when 6 then
                    assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = string(tt_item_demonst_ctbl_video.ttv_cod_chave_6, v_cod_format_proj_financ).
            end.
        end.
    end.

END PROCEDURE. /* pi_busca_descricoes_video */
/*****************************************************************************
** Procedure Interna.....: pi_item_demonst_ctbl_video_trata_sdo
** Descricao.............: pi_item_demonst_ctbl_video_trata_sdo
** Criado por............: Dalpra
** Criado em.............: 28/07/2001 10:00:19
** Alterado por..........: fut38629
** Alterado em...........: 25/06/2010 17:07:31
*****************************************************************************/
PROCEDURE pi_item_demonst_ctbl_video_trata_sdo:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_inverte_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count_2                    as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

        col_block:
        for each tt_col_demonst_ctbl
            where tt_col_demonst_ctbl.ind_orig_val_col_demonst <> "F¢rmula" /*l_formula*/  
            and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     <> "T°tulo" /*l_titulo*/ :   

            if avail tt_grp_col_demonst_video then do:
                if tt_col_demonst_ctbl.qtd_period_relac_base <> tt_grp_col_demonst_video.tta_qtd_period_relac_base
                or tt_col_demonst_ctbl.qtd_exerc_relac_base  <> tt_grp_col_demonst_video.tta_qtd_exerc_relac_base 
                or tt_col_demonst_ctbl.ind_tip_relac_base    <> tt_grp_col_demonst_video.tta_ind_tip_relac_base   
                or tt_col_demonst_ctbl.num_conjto_param_ctbl <> tt_grp_col_demonst_video.tta_num_conjto_param_ctbl
                or tt_col_demonst_ctbl.ind_tip_val_consolid  <> tt_grp_col_demonst_video.tta_ind_tip_val_consolid then
                    next.
            end.

            /* Decimais do Chile */
            IF v_log_funcao_tratam_dec THEN DO:
                 find first tt_col_demonst_ctbl_ext
                     where tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
                 if avail tt_col_demonst_ctbl_ext then
                     assign v_cod_moed_finalid = tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid.
            END.

            /* case_block1: */
            case tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl:
               when "Saldo Inicial" /*l_saldo_inicial*/  then case_block2:
                  do:
                  if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Oráamento" /*l_orcamento*/  then do:
                      if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                      then do:
                          assign v_val_sdo_ctbl = v_val_orcado_sdo - v_val_orcado.
                      end.
                      else do:
                          assign v_val_sdo_ctbl = v_qtd_orcado_sdo - v_qtd_orcado.
                      end.
                  end.
                  else do:
                      if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                      then do:
                          if v_cod_dwb_user begins 'es_'
                          and v_nom_prog <> "Di†rio" /*l_diario*/  then
                              assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                          else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.

                         if v_log_consid_apurac_restdo = no
                         then do:
                             assign v_val_sdo_ctbl = v_val_sdo_ctbl_ini.
                         end.
                         else do:
                             assign v_val_sdo_ctbl = v_val_apurac_restdo_inic_50
                                                   + v_val_sdo_ctbl_ini.
                         end.
                      end.
                      else do:
                          assign v_val_sdo_ctbl = v_qtd_sdo_ctbl_fim
                                                - v_qtd_sdo_ctbl_db
                                                + v_qtd_sdo_ctbl_cr.
                      end.
                  end.
               end.

               when "DÇbitos" /*l_debitos*/  then case_block2:
                do:
                  assign v_val_db = 0.

                  /* Begin_Include: i_calc_debito_sdo_ctbl */
                    if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                    then do:
                        if v_cod_dwb_user begins 'es_'
                        and v_nom_prog <> "Di†rio" /*l_diario*/  then
                            assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                        else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.
                        if  v_log_consid_apurac_restdo = no
                        then do:
                            assign v_val_db = v_val_sdo_ctbl_db.
                        end.
                        else do:
                            assign v_val_db = v_val_sdo_ctbl_db 
                                            + v_val_apurac_restdo_db_505.
                        end.
                    end.
                    else do:
                        assign v_val_db = v_qtd_sdo_ctbl_db.
                    end.

                  /* End_Include: i_calc_debito_sdo_ctbl */

                  assign v_val_sdo_ctbl = v_val_db.
               end.

               when "CrÇditos" /*l_creditos*/  then case_block2:
                do:
                  assign v_val_cr = 0.

                  /* Begin_Include: i_calc_credito_sdo_ctbl */
                  if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                  then do:
                      if v_cod_dwb_user begins 'es_'
                      and v_nom_prog <> "Di†rio" /*l_diario*/  then
                          assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                      else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.

                      if  v_log_consid_apurac_restdo = no
                      then do:
                          assign v_val_cr = v_val_sdo_ctbl_cr.
                      end.
                      else do:
                          assign v_val_cr = v_val_sdo_ctbl_cr 
                                            + v_val_apurac_restdo_cr_505.
                      end.
                  end.
                  else do:
                      assign v_val_cr = v_qtd_sdo_ctbl_cr.
                  end.
                  /* End_Include: i_calc_credito_sdo_ctbl */

                  assign v_val_sdo_ctbl = v_val_cr.
               end.

               when "Movimento" /*l_movimento*/  then case_block2:
                do:
                    if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Oráamento" /*l_orcamento*/  then do:
                       if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                       then do:
                           assign v_val_sdo_ctbl = v_val_orcado.
                       end.
                       else do:
                           assign v_val_sdo_ctbl = v_qtd_orcado.
                       end.
                    end.
                   else do:
                       if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                       then do:
                           if v_cod_dwb_user begins 'es_'
                           and v_nom_prog <> "Di†rio" /*l_diario*/  then
                                assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                           else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.
                           if  v_log_consid_apurac_restdo = no
                           then do:
                               assign v_val_sdo_ctbl = v_val_movto.
                           end.
                           else do:
                               assign v_val_sdo_ctbl = v_val_movto
                                                     + v_val_apurac_restdo_movto_50.
                           end.
                       end.
                       else do:
                           assign v_val_sdo_ctbl = v_qtd_movto.
                       end.
                   end.
               end.
               when "Empenhado" /*l_empenhado*/  then case_block2:
                do:
                  assign v_val_empenh = 0.


                  /* Begin_Include: i_calc_empenh_sdo_ctbl */
                    if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                    then do:
                        assign v_val_empenh = v_val_movto_empenh.
                    end.
                    else do:
                        assign v_val_empenh = v_qtd_movto_empenh.
                    end.

                  /* End_Include: i_calc_empenh_sdo_ctbl */

                  assign v_val_sdo_ctbl = v_val_empenh.
               end.

               when "Mov + Empenh" /*l_movto_realiz_mais_empenhado*/  then case_block2:
                do:
                  assign v_val_empenh   = 0
                         v_val_sdo_ctbl = 0.

                  if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                  then do:
                      if v_cod_dwb_user begins 'es_'
                      and v_nom_prog <> "Di†rio" /*l_diario*/  then
                          assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                      else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.

                      if  v_log_consid_apurac_restdo = no
                      then do:
                          assign v_val_sdo_ctbl = v_val_movto.
                      end.
                      else do:
                          assign v_val_sdo_ctbl = v_val_movto
                                                + v_val_apurac_restdo_movto_50.
                      end.
                  end.
                  else do:
                      assign v_val_sdo_ctbl = v_qtd_movto.
                  end.


                  /* Begin_Include: i_calc_empenh_sdo_ctbl */
                    if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                    then do:
                        assign v_val_empenh = v_val_movto_empenh.
                    end.
                    else do:
                        assign v_val_empenh = v_qtd_movto_empenh.
                    end.

                  /* End_Include: i_calc_empenh_sdo_ctbl */

                  assign v_val_sdo_ctbl = v_val_sdo_ctbl + v_val_empenh.
               end.

               when "Saldo Final" /*l_saldo_final*/  then case_block2:
                do:
                  if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Oráamento" /*l_orcamento*/  then do:
                      if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                      then do:
                          assign v_val_sdo_ctbl = v_val_orcado_sdo.
                      end.
                      else do:
                          assign v_val_sdo_ctbl = v_qtd_orcado_sdo.
                      end.
                  end.
                  else do:
                      if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                      then do:
                      if v_cod_dwb_user begins 'es_'
                      and v_nom_prog <> "Di†rio" /*l_diario*/  then
                          assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                      else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.

                         if  v_log_consid_apurac_restdo = no
                         then do:

                                assign v_val_sdo_ctbl = v_val_sdo_ctbl_fim.
                         end.
                         else do:
                            assign v_val_sdo_ctbl = v_val_sdo_ctbl_fim
                                                  + v_val_apurac_restdo_acum_505.
                         end.
                      end.
                      else do:
                          assign v_val_sdo_ctbl = v_qtd_sdo_ctbl_fim.
                      end.
                  end.
               end.
               when "% Participac" /*l_%_Participaá∆o*/  then case_block2:
                do:
                     assign v_val_sdo_ctbl = v_val_perc_particip.
               end.
            end.
            /* 211931 - SE O PAI DA UNIDADE DE NEG‡CIO SELECIONADO ESTIVER DENTRO DA FAIXA
             DESCONSIDERA A UNIDADE DE NEG‡CIO PAI NA SOMA TOTAL */
            if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/  ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) <> 0 then do:

                assign v_cod_unid = ''
                       v_log_unid_negoc = no.
                if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/   ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) = 1 then
                    assign v_cod_unid = tt_item_demonst_ctbl_video.ttv_cod_chave_1.
                else
                if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/   ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) = 2 then
                    assign v_cod_unid = tt_item_demonst_ctbl_video.ttv_cod_chave_2.
                else
                if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/   ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) = 3 then
                    assign v_cod_unid = tt_item_demonst_ctbl_video.ttv_cod_chave_3.
                else
                if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/   ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) = 4 then
                    assign v_cod_unid = tt_item_demonst_ctbl_video.ttv_cod_chave_4.
                else
                if lookup("Unidade Neg¢cio" /*l_unidade_negocio*/   ,tt_item_demonst_ctbl_video.ttv_cod_identif_campo,chr(10)) = 5 then
                    assign v_cod_unid = tt_item_demonst_ctbl_video.ttv_cod_chave_5.

                find first estrut_unid_negoc no-lock
                    where estrut_unid_negoc.cod_unid_negoc_filho = v_cod_unid 
                    and estrut_unid_negoc.cod_unid_negoc_pai     = '' no-error.
                if  avail estrut_unid_negoc then do:
                    find first emscad.unid_negoc no-lock
                        where unid_negoc.cod_unid_negoc = estrut_unid_negoc.cod_unid_negoc_filho 
                          and unid_negoc.ind_espec_unid_negoc = "SintÇtica" /*l_sintetica*/  no-error.
                    if avail unid_negoc then
                        assign v_log_unid_negoc = yes.
                end.
            end.


            /* Begin_Include: i_col_demonst_ctbl_video */
            find tt_valor_demonst_ctbl_video
                 where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                 and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                 no-lock no-error.
            if  not avail tt_valor_demonst_ctbl_video
            then do:
                 create tt_valor_demonst_ctbl_video.
                 assign tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                        tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= recid(tt_item_demonst_ctbl_video).
            end.

            if  v_log_funcao_concil_consolid and
                tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "% Participac" /*l_%_Participaá∆o*/ 
            then do:
                assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
                return.
            end.

            /* * Recalcula valor segundo Cotaªío cadastrada no Conjto Preferºncias **/
            if avail tt_grp_col_demonst_video then
               assign v_val_sdo_ctbl = FnAjustDec(round(v_val_sdo_ctbl / tt_grp_col_demonst_video.ttv_val_cotac_indic_econ,2), v_cod_moed_finalid).
            if v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

            if  p_log_inverte_val
            and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "DÇbitos" /*l_debitos*/  
            and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "CrÇditos" /*l_creditos*/   then
                assign v_val_sdo_ctbl = v_val_sdo_ctbl * -1.

            if v_cod_dwb_user begins 'es_' 
            and v_nom_prog <> "Di†rio" /*l_diario*/  then          
                assign v_val_sdo_ctbl = FnAjustDec(v_val_sdo_ctbl / dec(entry(13, dwb_rpt_param.cod_dwb_parameters, chr(10))), v_cod_moed_finalid).
            else
                assign v_val_sdo_ctbl = FnAjustDec(v_val_sdo_ctbl / b_prefer_demonst_ctbl.val_fator_div_demonst_ctbl, v_cod_moed_finalid).

            assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = 
                   tt_valor_demonst_ctbl_video.ttv_val_col_1 + v_val_sdo_ctbl.

            if  v_log_final_proces = yes then do:
                run pi_calcula_acumulador_video (Input tt_col_demonst_ctbl.cod_col_demonst_ctbl,
                                                 Input v_val_sdo_ctbl) /*pi_calcula_acumulador_video*/.
            end.

            /* End_Include: i_col_demonst_ctbl_video */

        end.

END PROCEDURE. /* pi_item_demonst_ctbl_video_trata_sdo */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_trad_idiom
** Descricao.............: pi_retornar_trad_idiom
** Criado por............: Marcelo
** Criado em.............: 20/05/1998 17:14:48
** Alterado por..........: Julio
** Alterado em...........: 24/08/1998 09:30:07
*****************************************************************************/
PROCEDURE pi_retornar_trad_idiom:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_tit_ctbl
        as character
        format "x(40)"
        no-undo.
    def Input param p_cod_idioma
        as character
        format "x(8)"
        no-undo.
    def output param p_des_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  not avail param_geral_ems
    then do:
        find last param_geral_ems no-lock no-error.
        if  not avail param_geral_ems
        then do:
            assign p_des_return = p_des_tit_ctbl.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* if */.
    if  param_geral_ems.cod_idiom_princ = p_cod_idioma
    then do:
        assign p_des_return = p_des_tit_ctbl.
        return "OK" /*l_ok*/ .
    end /* if */.
    if  not avail param_geral_gld
    then do:
        find last param_geral_gld no-lock no-error.
        if  not avail param_geral_gld
        then do:
            assign p_des_return = p_des_tit_ctbl.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* if */.    
    if  param_geral_gld.ind_trad_tit_ctbl = "N∆o Utiliza" /*l_nao_utiliza*/ 
    then do:
        assign p_des_return = p_des_tit_ctbl.
        return "NOK" /*l_nok*/ .
    end /* if */.
    find tit_ctbl no-lock where tit_ctbl.des_tit_ctbl = p_des_tit_ctbl no-error.
    if  not avail tit_ctbl
    then do:
        p_des_return = p_des_tit_ctbl.
        return "NOK" /*l_nok*/ .
    end /* if */.
    find trad_tit_ctbl no-lock 
        where trad_tit_ctbl.num_id_tit_ctbl = tit_ctbl.num_id_tit_ctbl
          and trad_tit_ctbl.cod_idioma = p_cod_idioma no-error.
    if  avail trad_tit_ctbl
    then do:
        assign p_des_return = trad_tit_ctbl.des_trad_tit_ctbl.
        return "OK" /*l_ok*/ .
    end /* if */.
    else do:
        assign p_des_return = p_des_tit_ctbl.
        return "NOK" /*l_nok*/ .
    end /* else */.       
END PROCEDURE. /* pi_retornar_trad_idiom */
/*****************************************************************************
** Procedure Interna.....: pi_col_demons_ctbl_video_more_3
** Descricao.............: pi_col_demons_ctbl_video_more_3
** Criado por............: Dalpra
** Criado em.............: 12/06/2001 10:02:43
** Alterado por..........: fut31947
** Alterado em...........: 27/06/2007 14:53:05
*****************************************************************************/
PROCEDURE pi_col_demons_ctbl_video_more_3:

    /* Se criou pelo menos um registro de valor para a linha continua o processo */
    if  can-find(first tt_valor_demonst_ctbl_video
        where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
        and   tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0)
    then do:

        col_block:
        for each  tt_col_demonst_ctbl no-lock
            where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/ 
            by tt_col_demonst_ctbl.num_soma_ascii_cod_col: 

            /* Decimais Chile */
            IF v_log_funcao_tratam_dec THEN DO:
                 find first tt_col_demonst_ctbl_ext
                     where tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
                 if avail tt_col_demonst_ctbl_ext then
                     assign v_cod_moed_finalid = tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid.
            END.

            /* Calcula Variacao */
            if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Variaá∆o" /*l_variacao*/  
            then do:
                find btt_valor_demonst_ctbl_video
                    where btt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                    and   btt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 1, 2))
                    no-error.
                if  avail btt_valor_demonst_ctbl_video then
                    assign v_val_sdo_idx = btt_valor_demonst_ctbl_video.ttv_val_col_1.
                else 
                    assign v_val_sdo_idx = 0.

                find btt_valor_demonst_ctbl_video
                    where btt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                    and   btt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 6, 2))
                    no-error.
                if  avail btt_valor_demonst_ctbl_video then
                    assign v_val_sdo_base = btt_valor_demonst_ctbl_video.ttv_val_col_1.
                else
                    assign v_val_sdo_base = 0.

                if  v_val_sdo_idx  <> 0 
                and v_val_sdo_base <> 0 then do:
                    assign v_val_sdo_ctbl = FnAjustDec(dec(v_val_sdo_idx / v_val_sdo_base * 100 - 100), v_cod_moed_finalid).
                    if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

                    find tt_valor_demonst_ctbl_video
                         where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                         and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                         no-lock no-error.
                    if  not avail tt_valor_demonst_ctbl_video then do:
                        create tt_valor_demonst_ctbl_video.
                        assign tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                               tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= recid(tt_item_demonst_ctbl_video)
                               tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
                    end.
                end.
            end.

            /* Calcula Formula */
            if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "F¢rmula" /*l_formula*/  
            then do:
                for each tt_var_formul_1:
                    delete tt_var_formul_1.
                end.
                run pi_ident_var_formul_1 (Input tt_col_demonst_ctbl.des_formul_ctbl) /*pi_ident_var_formul_1*/.
                for each tt_var_formul_1 no-lock:
                    find btt_valor_demonst_ctbl_video
                        where btt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                        and   btt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_var_formul_1.ttv_cod_var_formul
                        no-error.
                    if  avail btt_valor_demonst_ctbl_video then
                        assign tt_var_formul_1.ttv_val_var_formul_1 = btt_valor_demonst_ctbl_video.ttv_val_col_1.
                    else 
                        assign tt_var_formul_1.ttv_val_var_formul_1 = 0.
                end.
                assign v_val_sdo_ctbl = 0.

                run pi_calcul_formul_1 (input-output v_val_sdo_ctbl,
                                        input tt_col_demonst_ctbl.des_formul_ctbl,
                                        output v_log_return,
                                        Input yes) /*pi_calcul_formul_1*/.
                if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

                find tt_valor_demonst_ctbl_video
                     where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                     and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                     no-lock no-error.
                if  not avail tt_valor_demonst_ctbl_video then do:
                    create tt_valor_demonst_ctbl_video.
                    assign tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                           tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                           tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
                end.
                else do: 
                    assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl. 
                end.
            end.

            if  v_log_final_proces = yes then do:
                run pi_calcula_acumulador_video (Input tt_col_demonst_ctbl.cod_col_demonst_ctbl,
                                                 Input v_val_sdo_ctbl) /* pi_calcula_acumulador_video*/.
            end.

        end.
    end.

END PROCEDURE. /* pi_col_demons_ctbl_video_more_3 */
/*****************************************************************************
** Procedure Interna.....: pi_calcula_numero_posicoes_formato
** Descricao.............: pi_calcula_numero_posicoes_formato
** Criado por............: Dalpra
** Criado em.............: 24/01/2001 11:34:00
** Alterado por..........: src531
** Alterado em...........: 04/09/2002 14:32:44
*****************************************************************************/
PROCEDURE pi_calcula_numero_posicoes_formato:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.
    def output param p_num_pos_calc
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  string(substring(p_cod_format,1,1)) = 'X' then do:
        assign p_num_pos_calc = int(substring(p_cod_format,3,length(p_cod_format) - 3)).
        return.         
    end.

    if  string(substring(p_cod_format,1,2)) = '9(' then do:
        assign p_num_pos_calc = int(substring(p_cod_format,3,length(p_cod_format) - 3)).
        return.         
    end.    

    if  string(substring(p_cod_format,1,2)) = '99' 
    or  string(substring(p_cod_format,1)) = 'Z'
    or  string(substring(p_cod_format,1)) = '>' then do:
        assign p_num_pos_calc = length(p_cod_format).
        return.         
    end.    

    if  string(substring(p_cod_format,1,2)) = '(z' 
    or  string(substring(p_cod_format,1,2)) = '(>' then do:
        assign p_num_pos_calc = length(p_cod_format) - 1.
        return.
    end.


END PROCEDURE. /* pi_calcula_numero_posicoes_formato */
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
        assign v_log_achou_tmp = Verifica_Program_Name('escg0204':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('mgl304ab':U, 30).

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
** Procedure Interna.....: pi_calcula_acumulador_video
** Descricao.............: pi_calcula_acumulador_video
** Criado por............: Dalpra
** Criado em.............: 05/06/2001 10:00:27
** Alterado por..........: fut41162
** Alterado em...........: 26/11/2008 16:52:58
*****************************************************************************/
PROCEDURE pi_calcula_acumulador_video:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_col_demonst_ctbl
        as character
        format "x(2)"
        no-undo.
    def Input param p_val_sdo_ctbl_fim_sint
        as decimal
        format "->>>>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_localiz_sdo                as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_log_localiz_sdo = no.

    blk_ler:
    for
        each tt_acumul_demonst_cadastro no-lock
           where tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
             and tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:

        if tt_item_demonst_ctbl_video.ttv_log_cta_sint = yes then
            next.         

        /* ----------------------Analise Vertical--------------------------------------*/
        find tt_controla_analise_vertical
            where tt_controla_analise_vertical.tta_cod_col_demonst_ctbl  = p_cod_col_demonst_ctbl
            and   tt_controla_analise_vertical.ttv_cod_linha             = tt_item_demonst_ctbl_video.ttv_des_chave_1
            and   tt_controla_analise_vertical.tta_cod_acumul_ctbl       = tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl
            no-error.
        if  not avail tt_controla_analise_vertical then do:
            create tt_controla_analise_vertical.
            assign tt_controla_analise_vertical.tta_cod_col_demonst_ctbl = p_cod_col_demonst_ctbl
                   tt_controla_analise_vertical.ttv_cod_linha            = tt_item_demonst_ctbl_video.ttv_des_chave_1
                   tt_controla_analise_vertical.tta_cod_acumul_ctbl      = tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl.
        end.
        if v_cod_dwb_user begins 'es_' 
        and v_nom_prog <> "Di†rio" /*l_diario*/  then do:
            assign v_cod_demonst_ctbl = entry(1, dwb_rpt_param.cod_dwb_parameters,chr(10)).
        end.
        else do:
            assign v_cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl.
        end.

        /* Se for consulta de saldo, calcula AV de forma diferenciada */
        if v_cod_demonst_ctbl = "" then
            assign tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert =
                   tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert + ABS(p_val_sdo_ctbl_fim_sint).
        else
            assign tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert =
                   tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert + p_val_sdo_ctbl_fim_sint.

        /* ----------------------Analise Vertical--------------------------------------*/
         /* 211931 - pi_item_demonst_ctbl_video_trata_sdo / se a unid negoc for PAI n∆o deve somar no total */
         if v_log_unid_negoc = yes then
            assign  p_val_sdo_ctbl_fim_sint = 0.

        find first tt_acumul_demonst_ctbl_result no-lock
             where tt_acumul_demonst_ctbl_result.tta_cod_acumul_ctbl      = tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl
               and tt_acumul_demonst_ctbl_result.tta_cod_col_demonst_ctbl = p_cod_col_demonst_ctbl
               and tt_acumul_demonst_ctbl_result.tta_num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl  no-error.

        if  not avail tt_acumul_demonst_ctbl_result
        then do:
            create tt_acumul_demonst_ctbl_result.
            assign tt_acumul_demonst_ctbl_result.tta_cod_acumul_ctbl = tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl
                   tt_acumul_demonst_ctbl_result.tta_cod_col_demonst_ctbl = p_cod_col_demonst_ctbl
                   tt_acumul_demonst_ctbl_result.tta_num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                   tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul = p_val_sdo_ctbl_fim_sint.

            if  v_log_proces then
                assign tt_acumul_demonst_ctbl_result.TTV_LOG_JA_PROCESDO = yes.

        end.
        else do:
             assign tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul = tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul + p_val_sdo_ctbl_fim_sint.
        end.

        if  v_log_primei_compos_demonst
        then do:
            if  p_val_sdo_ctbl_fim_sint <> 0
            then do:
                assign tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul = 
                       tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul + 0.0000000001
                       v_log_localiz_sdo = yes. 
            end /* if */.
        end /* if */.
    end /* for blk_ler */.
    if  v_log_localiz_sdo
    then do:
       assign v_log_primei_compos_demonst = no.
    end.
    /* assinala a vari†vel v_log_primei_compos_demonst acima para que as pr¢ximas interaá‰es n∆o somais mais milÇsimos na composiá∆o
    pois neste caso poder°amos ter os totais alterados */
END PROCEDURE. /* pi_calcula_acumulador_video */
/*****************************************************************************
** Procedure Interna.....: pi_col_demons_ctbl_video_analise_vertical
** Descricao.............: pi_col_demons_ctbl_video_analise_vertical
** Criado por............: Dalpra
** Criado em.............: 30/07/2001 05:17:20
** Alterado por..........: fut31947
** Alterado em...........: 27/06/2007 14:52:56
*****************************************************************************/
PROCEDURE pi_col_demons_ctbl_video_analise_vertical:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_tt_col_demonst_ctbl
        for tt_col_demonst_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_valor                      as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    col_block:
    for each tt_col_demonst_ctbl 
       where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
       and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/  :

        /* Decimais Chile */
        IF v_log_funcao_tratam_dec THEN DO:
             find first tt_col_demonst_ctbl_ext
                 where tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst = tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                   and tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = tt_col_demonst_ctbl.num_conjto_param_ctbl no-error.
             if avail tt_col_demonst_ctbl_ext then
                 assign v_cod_moed_finalid = tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid.
        END.

        find btt_valor_demonst_ctbl_video
            where btt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
            and   btt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 2, 2))
            no-error.
        if  avail btt_valor_demonst_ctbl_video then
            assign v_val_sdo_idx = btt_valor_demonst_ctbl_video.ttv_val_col_1.
        else 
            assign v_val_sdo_idx = 0.

        /* Se for consulta de saldo, calcula AV de forma diferenciada */
        if v_cod_dwb_user begins 'es_'
        and v_nom_prog <> "Di†rio" /*l_diario*/  then
            assign v_cod_demonst_ctbl = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)).
        else 
            assign v_cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl.

        if v_cod_demonst_ctbl = "" then
            assign v_val_sdo_idx = ABS(v_val_sdo_idx).        

        if  v_val_sdo_idx <> 0 then do: 

            assign v_val_analis_vert = 0.

            for each  tt_controla_analise_vertical
                where tt_controla_analise_vertical.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 8, 2))
                and   tt_controla_analise_vertical.tta_cod_acumul_ctbl       = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 12, 8)):
                assign v_val_analis_vert = 
                       v_val_analis_vert + tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert.
            end.

            if  v_val_analis_vert <> 0 then do:
                assign v_val_sdo_ctbl = FnAjustDec(dec((v_val_sdo_idx / v_val_analis_vert) * 100), v_cod_moed_finalid).
                find tt_valor_demonst_ctbl_video
                     where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                     and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
                     no-lock no-error.
                if  not avail tt_valor_demonst_ctbl_video then do:
                    create tt_valor_demonst_ctbl_video.
                    assign tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                           tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= recid(tt_item_demonst_ctbl_video)
                           tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
                end.
                else
                    assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = 
                           tt_valor_demonst_ctbl_video.ttv_val_col_1 + v_val_sdo_ctbl.
                if  tt_valor_demonst_ctbl_video.ttv_val_col_1 >= 10000 
                or  tt_valor_demonst_ctbl_video.ttv_val_col_1 <= -10000 then
                    assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = ?.
            end.
        end.
    end.

END PROCEDURE. /* pi_col_demons_ctbl_video_analise_vertical */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p00_bas_demonst_ctbl_fin
** Descricao.............: pi_ix_p00_bas_demonst_ctbl_fin
** Criado por............: src531
** Criado em.............: 03/09/2002 13:28:22
** Alterado por..........: corp45582
** Alterado em...........: 12/06/2012 14:30:12
*****************************************************************************/
PROCEDURE pi_ix_p00_bas_demonst_ctbl_fin:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_opc
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    IF p_num_opc = 1 THEN DO:
        /* * Demonstrativo jˇ maximizado para resoluªío de 640 x 480 **/
        if SESSION:WORK-AREA-HEIGHT-PIXELS = 452 then RETURN NO-APPLY.

        assign frame f_bas_10_demonst_ctbl_fin:width-chars = session:WIDTH-CHARS - 1.29
               frame f_bas_10_demonst_ctbl_fin:height-chars = session:HEIGHT-CHARS - 3.49
               wh_w_program:width-chars   = frame f_bas_10_demonst_ctbl_fin:width-chars
               wh_w_program:height-chars  = frame f_bas_10_demonst_ctbl_fin:height-chars - 0.85
               wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
               wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
               frame f_bas_10_demonst_ctbl_fin:row = 1
               frame f_bas_10_demonst_ctbl_fin:col = 1
               current-window             = wh_w_program

               rt_rgf:visible              in frame f_bas_10_demonst_ctbl_fin = no
               bt_exi:visible              in frame f_bas_10_demonst_ctbl_fin = no
               bt_hel1:visible             in frame f_bas_10_demonst_ctbl_fin = no
               rt_mold:visible             in frame f_bas_10_demonst_ctbl_fin = no
               br_demonst_ctbl_fin:visible in frame f_bas_10_demonst_ctbl_fin = no

               rt_rgf:width-chars          in frame f_bas_10_demonst_ctbl_fin = session:WIDTH-CHARS - 1.79
               bt_exi:col                  in frame f_bas_10_demonst_ctbl_fin = session:WIDTH-CHARS - 9.29
               bt_hel1:col                 in frame f_bas_10_demonst_ctbl_fin = session:WIDTH-CHARS - 5.29
               br_demonst_ctbl_fin:width-chars  in frame f_bas_10_demonst_ctbl_fin = session:WIDTH-CHARS  - 3.29
               br_demonst_ctbl_fin:height-chars in frame f_bas_10_demonst_ctbl_fin = session:HEIGHT-CHARS - 6.5

               rt_rgf:visible              in frame f_bas_10_demonst_ctbl_fin = yes
               bt_exi:visible              in frame f_bas_10_demonst_ctbl_fin = yes
               bt_hel1:visible             in frame f_bas_10_demonst_ctbl_fin = yes
               rt_mold:visible             in frame f_bas_10_demonst_ctbl_fin = yes
               br_demonst_ctbl_fin:visible in frame f_bas_10_demonst_ctbl_fin = yes no-error.
    end.

    IF p_num_opc = 2 THEN DO:

        assign wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
               wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
               frame f_bas_10_demonst_ctbl_fin:row = 1
               frame f_bas_10_demonst_ctbl_fin:col = 1
               current-window             = wh_w_program
               rt_rgf:visible              in frame f_bas_10_demonst_ctbl_fin = no
               bt_exi:visible              in frame f_bas_10_demonst_ctbl_fin = no
               bt_hel1:visible             in frame f_bas_10_demonst_ctbl_fin = no
               rt_mold:visible             in frame f_bas_10_demonst_ctbl_fin = no
               br_demonst_ctbl_fin:visible in frame f_bas_10_demonst_ctbl_fin = no

               rt_rgf:width-chars          in frame f_bas_10_demonst_ctbl_fin = (session:width-chars - wh_w_program:width-chars) - 2.29
               bt_exi:col                  in frame f_bas_10_demonst_ctbl_fin = (session:width-chars - wh_w_program:width-chars) - 10
               bt_hel1:col                 in frame f_bas_10_demonst_ctbl_fin = (session:width-chars - wh_w_program:width-chars) - 6
               br_demonst_ctbl_fin:width-chars  in frame f_bas_10_demonst_ctbl_fin = (session:width-chars - wh_w_program:width-chars) - 4.09
               br_demonst_ctbl_fin:height-chars in frame f_bas_10_demonst_ctbl_fin = (session:height-chars - wh_w_program:height-chars) - 12.09

               rt_rgf:visible              in frame f_bas_10_demonst_ctbl_fin = yes
               bt_exi:visible              in frame f_bas_10_demonst_ctbl_fin = yes
               bt_hel1:visible             in frame f_bas_10_demonst_ctbl_fin = yes
               rt_mold:visible             in frame f_bas_10_demonst_ctbl_fin = yes
               br_demonst_ctbl_fin:visible in frame f_bas_10_demonst_ctbl_fin = yes no-error.     

    end.
END PROCEDURE. /* pi_ix_p00_bas_demonst_ctbl_fin */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_ccusto
** Descricao.............: pi_verifica_segur_ccusto
** Criado por............: Henke
** Criado em.............: 02/02/1996 16:26:15
** Alterado por..........: corp45591
** Alterado em...........: 14/11/2011 11:50:51
*****************************************************************************/
PROCEDURE pi_verifica_segur_ccusto:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_ccusto
        for emscad.ccusto.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    if can-find (first segur_ccusto
       where segur_ccusto.cod_empresa      = p_ccusto.cod_empresa
         and segur_ccusto.cod_plano_ccusto = p_ccusto.cod_plano_ccusto
         and segur_ccusto.cod_ccusto       = p_ccusto.cod_ccusto
         and segur_ccusto.cod_grp_usuar    = "*")
    then
        assign p_log_return = yes.
    else do:
        loop_block:
                FOR EACH segur_ccusto
                where segur_ccusto.cod_empresa             = p_ccusto.cod_empresa
                       and segur_ccusto.cod_plano_ccusto   = p_ccusto.cod_plano_ccusto
                       and segur_ccusto.cod_ccusto         = p_ccusto.cod_ccusto NO-LOCK.
                IF CAN-FIND(FIRST usuar_grp_usuar
                            WHERE usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren
                            AND   usuar_grp_usuar.cod_grp_usuar = segur_ccusto.cod_grp_usuar) THEN DO:
                    assign p_log_return = yes.
                    leave loop_block.

                END.
            END.
    end /* else */.
END PROCEDURE. /* pi_verifica_segur_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_ccusto_demonst
** Descricao.............: pi_verifica_segur_ccusto_demonst
** Criado por............: src531
** Criado em.............: 30/08/2002 13:21:00
** Alterado por..........: src531
** Alterado em...........: 30/08/2002 13:22:31
*****************************************************************************/
PROCEDURE pi_verifica_segur_ccusto_demonst:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
        as Character
        format "x(11)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
        as character
        format "x(20)"
    &ENDIF
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default ≤ nío ter permissío */

    if can-find (first segur_ccusto
       where segur_ccusto.cod_empresa      = p_cod_empresa
         and segur_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
         and segur_ccusto.cod_ccusto       = p_cod_ccusto
         and segur_ccusto.cod_grp_usuar    = "*")
    then
        assign p_log_return = yes.
    else do:
        loop_block:
        for each usuar_grp_usuar no-lock
            where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren
            &if '{&emsbas_version}' >= '5.01' &then
               use-index srgrpsr_usuario
            &endif:
            find first segur_ccusto no-lock
                 where segur_ccusto.cod_empresa = p_cod_empresa
                   and segur_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
                   and segur_ccusto.cod_ccusto  = p_cod_ccusto
                   and segur_ccusto.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar no-error.
            if  avail segur_ccusto
            then do:
                assign p_log_return = yes.
                leave loop_block.
            end /* if */.
        end /* for loop_block */.
    end /* else */.

END PROCEDURE. /* pi_verifica_segur_ccusto_demonst */
/*****************************************************************************
** Procedure Interna.....: pi_redimensiona_colunas
** Descricao.............: pi_redimensiona_colunas
** Criado por............: src531
** Criado em.............: 12/09/2002 12:36:04
** Alterado por..........: src531
** Alterado em...........: 12/09/2002 12:36:40
*****************************************************************************/
PROCEDURE pi_redimensiona_colunas:

    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_1:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_1:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_2:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_2:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_3:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_3:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_4:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_4:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_5:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_5:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_6:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_6:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_7:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_7:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_8:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_8:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_9:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_9:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_10:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_10:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_11:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_11:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_12:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_12:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_13:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_13:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_14:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_14:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_15:MOVABLE in browse br_demonst_ctbl_fin = TRUE.
    ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_15:RESIZABLE in browse br_demonst_ctbl_fin = TRUE.
END PROCEDURE. /* pi_redimensiona_colunas */
/*****************************************************************************
** Procedure Interna.....: pi_choose_bt_fil2
** Descricao.............: pi_choose_bt_fil2
** Criado por............: src507
** Criado em.............: 21/10/2002 16:43:07
** Alterado por..........: fut12232
** Alterado em...........: 16/02/2005 20:03:31
*****************************************************************************/
PROCEDURE pi_choose_bt_fil2:

    /************************* Variable Definition Begin ************************/

    def var v_ind_selec_demo_ctbl_atual
        as character
        format "X(08)":U
        no-undo.
    def var v_rec_item_cad_aux
        as recid
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* * GRAVA RECID DA tt_item_..._cadastro PARA VERIFICAR SE ESTA FOI ALTERADA NAS PREFER“NCIAS **/
    FIND FIRST tt_item_demonst_ctbl_cadastro NO-ERROR.
    ASSIGN v_rec_item_cad_aux = IF AVAIL tt_item_demonst_ctbl_cadastro THEN tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad ELSE ?.

    if  search("prgfin/mgl/escg0204zb.r") = ? and search("prgfin/mgl/escg0204zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/escg0204zb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/escg0204zb.p"
                   view-as alert-box error buttons ok.
            stop.
        end.
    end.
    else
        run prgfin/mgl/escg0204zb.p /*prg_fnc_prefer_demonst_ctbl*/.

    /* * Localiza os ParÉmetros definidos pelo Usu†rio para Consulta do Demonstrativo **/
    FOR EACH b_prefer_demonst_ctbl NO-LOCK
        WHERE b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
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

    /* * Recupera parÉmetros de substituiá∆o do usu†rio **/
    if  avail prefer_demonst_ctbl then do:
        &if '{&emsfin_version}' = '5.05' &then
          IF NUM-ENTRIES(prefer_demonst_ctbl.cod_livre_1,chr(10)) >= 15 THEN
             assign v_log_unid_organ_subst      = (entry(2,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
                    v_log_unid_negoc_subst      = (entry(3,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
                    v_log_estab_subst           = (entry(4,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
                    v_log_ccusto_subst          = (entry(5,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
                    v_cod_unid_organ_sub        = entry(6,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_unid_negoc_subst_inic = entry(7,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_unid_negoc_subst_fim  = entry(8,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_estab_subst_inic      = entry(9,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_estab_subst_fim       = entry(10,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_ccusto_subst_inic     = entry(11,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_ccusto_subst_fim      = entry(12,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_ccusto_pfixa_subst    = entry(13,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_ccusto_exec_subst     = entry(14,prefer_demonst_ctbl.cod_livre_1,chr(10))
                    v_cod_plano_ccusto_sub      = entry(15,prefer_demonst_ctbl.cod_livre_1,chr(10)).
        &else
          assign v_log_unid_organ_subst   = prefer_demonst_ctbl.log_unid_organ_subst
                 v_log_unid_negoc_subst   = prefer_demonst_ctbl.log_unid_negoc_subst
                 v_log_estab_subst        = prefer_demonst_ctbl.log_estab_subst
                 v_log_ccusto_subst       = prefer_demonst_ctbl.log_ccusto_subst
                 v_cod_unid_organ_sub     = prefer_demonst_ctbl.cod_unid_organ_subst
                 v_cod_unid_negoc_subst_inic = prefer_demonst_ctbl.cod_unid_negoc_inic_subst
                 v_cod_unid_negoc_subst_fim  = prefer_demonst_ctbl.cod_unid_negoc_fim_subst
                 v_cod_estab_subst_inic      = prefer_demonst_ctbl.cod_estab_inic_subst
                 v_cod_estab_subst_fim       = prefer_demonst_ctbl.cod_estab_fim_subst
                 v_cod_ccusto_subst_inic     = prefer_demonst_ctbl.cod_ccusto_inic_subst
                 v_cod_ccusto_subst_fim      = prefer_demonst_ctbl.cod_ccusto_fim_subst
                 v_cod_ccusto_pfixa_subst    = prefer_demonst_ctbl.cod_ccusto_pfixa_subst
                 v_cod_ccusto_exec_subst     = prefer_demonst_ctbl.cod_ccusto_exec_subst
                 v_cod_plano_ccusto_sub      = prefer_demonst_ctbl.cod_plano_ccusto_subst.
        &endif
    end.

    /* --- Posiciona no Padr∆o de Colunas definido nos parÉmetros ---*/
    find padr_col_demonst_ctbl
        where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
        no-lock no-error.

    ASSIGN v_log_col_analis_vert = NO.
    IF  v_ind_selec_demo_ctbl = "Consultas de Saldo" /*l_consultas_de_saldo*/  THEN DO:
        IF  can-find(FIRST tt_COL_demonst_ctbl
            WHERE tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = "") THEN
            ASSIGN v_log_col_analis_vert = yes.
    END.
    if avail prefer_demonst_ctbl then do:
       &if '{&emsfin_version}' = '5.05' &then
           assign v_ind_selec_demo_ctbl_atual = ENTRY(1,prefer_demonst_ctbl.cod_livre_1,CHR(10)).
       &else
           assign v_ind_selec_demo_ctbl_atual = prefer_demonst_ctbl.ind_selec_demo_ctbl.
       &endif
    end.    
    /* * CASO A TEMP-TABLE OU O TIPO CONSULTA TENHA SIDO ALTERADO, IRµ ELIMINAR REGISTROS Jµ PROCESSADOS E 'ZERAR' BROWSER **/
    FIND FIRST tt_item_demonst_ctbl_cadastro NO-ERROR.
    if  (AVAIL tt_item_demonst_ctbl_cadastro
    AND tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad <> v_rec_item_cad_aux)
    OR (v_ind_selec_demo_ctbl = "Consultas de Saldo" /*l_consultas_de_saldo*/  
    AND (avail prefer_demonst_ctbl and v_ind_selec_demo_ctbl_atual = ""))
    or  v_log_alterado
    then do:

        /* Elimina temp-tables*/
        EMPTY TEMP-TABLE tt_item_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_label_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_valor_demonst_ctbl_video.
        EMPTY TEMP-TABLE tt_demonst_ctbl_fin.

        /* * Para limpar as informaá‰es do Browse **/
        open query qr_demonst_ctbl_fin for
             each  tt_demonst_ctbl_fin
             by tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl.

        /* * Zera t°tulos das colunas j† processadas **/
        ASSIGN tt_demonst_ctbl_fin.ttv_cod_campo_1:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_2:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_3:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_4:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_5:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_6:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_7:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_8:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_9:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_10:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_11:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_12:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_13:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_14:label in browse br_demonst_ctbl_fin = ""
               tt_demonst_ctbl_fin.ttv_cod_campo_15:label in browse br_demonst_ctbl_fin = ""

               tt_demonst_ctbl_fin.ttv_cod_campo_1:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_2:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_3:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_4:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_5:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_6:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_7:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_8:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_9:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_10:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_11:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_12:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_13:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_14:visible in browse br_demonst_ctbl_fin = NO
               tt_demonst_ctbl_fin.ttv_cod_campo_15:visible in browse br_demonst_ctbl_fin = NO.

        /* * Volta t°tulo do Demonstrativo no Browse para o valor defalt **/
        ASSIGN br_demonst_ctbl_fin:title in frame f_bas_10_demonst_ctbl_fin = getStrTrans("Demonstrativo Cont†bil", "MGL") /*l_demonstrativo_contabil*/ .
    END.

    /* * ATUALIZA VARIµVEL COM A ÈLTIMA CONSULTA REALIZADA **/
    ASSIGN v_ind_selec_demo_ctbl = v_ind_selec_demo_ctbl_atual.

    /* * Habilita bot‰es de grafico nas consultas **/
    IF  v_ind_selec_demo_ctbl = "Consultas de Saldo" /*l_consultas_de_saldo*/  THEN
        ASSIGN bt_grf_barra:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = YES
               bt_grf_pizza:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = YES.
    ELSE

        ASSIGN bt_grf_barra:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = NO
               bt_grf_pizza:SENSITIVE IN FRAME f_bas_10_demonst_ctbl_fin = NO.

    apply "entry" to bt_atz IN FRAME f_bas_10_demonst_ctbl_fin.
END PROCEDURE. /* pi_choose_bt_fil2 */
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
** Procedure Interna.....: pi_setar_return_value
** Descricao.............: pi_setar_return_value
** Criado por............: karla
** Criado em.............: 20/08/1998 11:13:46
** Alterado por..........: karla
** Alterado em...........: 20/08/1998 11:17:42
*****************************************************************************/
PROCEDURE pi_setar_return_value:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    return p_des_return.
END PROCEDURE. /* pi_setar_return_value */
/*****************************************************************************
** Procedure Interna.....: pi_wait_processing
** Descricao.............: pi_wait_processing
** Criado por............: Krammel
** Criado em.............: 24/01/1996 10:32:15
** Alterado por..........: Jaison
** Alterado em...........: 23/10/1998 09:38:03
*****************************************************************************/
PROCEDURE pi_wait_processing:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_message
        as character
        format "x(40)"
        no-undo.
    def Input param p_nom_frame_title
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  p_nom_frame_title <> ? or
       frame f_dlg_02_wait_processing:visible = no
    then do:
        if  p_nom_frame_title <> ""
        then do:
            assign frame f_dlg_02_wait_processing:title = p_nom_frame_title.
        end /* if */.
        else do:
            assign frame f_dlg_02_wait_processing:title = getStrTrans("Aguarde, em processamento...", "MGL") /*l_aguarde_em_processamento*/ .
        end /* else */.
        assign ed_1x40:width-chars in frame f_dlg_02_wait_processing = 60.
    end /* if */.
    assign ed_1x40:screen-value in frame f_dlg_02_wait_processing = p_des_message.
    enable all with frame f_dlg_02_wait_processing.
    process events.
END PROCEDURE. /* pi_wait_processing */
/*****************************************************************************
** Procedure Interna.....: pi_localiza_tt_cta_ctbl_analitica_demonst
** Descricao.............: pi_localiza_tt_cta_ctbl_analitica_demonst
** Criado por............: bre17108
** Criado em.............: 25/07/2003 20:11:51
** Alterado por..........: bre17108
** Alterado em...........: 29/01/2004 17:30:23
*****************************************************************************/
PROCEDURE pi_localiza_tt_cta_ctbl_analitica_demonst:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.


    /************************* Parameter Definition End *************************/

    for each  btt_cta_ctbl_demonst no-lock
        where btt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl
        and   btt_cta_ctbl_demonst.ttv_cod_cta_ctbl_pai   = p_cod_cta_ctbl:
        find first btt_retorna_sdo_ctbl_demonst
           where btt_retorna_sdo_ctbl_demonst.tta_cod_empresa         = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa        
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ    = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ   
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl  = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl 
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl        = btt_cta_ctbl_demonst.tta_cod_cta_ctbl
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto    = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto   
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_ccusto          = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto         
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_proj_financ     = tt_retorna_sdo_ctbl_demonst.tta_cod_proj_financ    
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_cenar_ctbl      = tt_retorna_sdo_ctbl_demonst.tta_cod_cenar_ctbl     
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_estab           = tt_retorna_sdo_ctbl_demonst.tta_cod_estab          
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc      = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc     
           and   btt_retorna_sdo_ctbl_demonst.tta_dat_sdo_ctbl        = tt_retorna_sdo_ctbl_demonst.tta_dat_sdo_ctbl       
           and   btt_retorna_sdo_ctbl_demonst.tta_num_seq             = tt_retorna_sdo_ctbl_demonst.tta_num_seq
           and   btt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo       = "Oráamento" /*l_orcamento*/ 
           and   btt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig
           no-error.
        if avail btt_retorna_sdo_ctbl_demonst then do:
            create tt_lista_cta_restric.
            assign tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_pai   = tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl
                   tt_lista_cta_restric.ttv_rec_ret_sdo_ctbl_filho = btt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl.
        end.
        run pi_localiza_tt_cta_ctbl_analitica_demonst (Input btt_cta_ctbl_demonst.tta_cod_cta_ctbl) /*pi_localiza_tt_cta_ctbl_analitica_demonst*/.
    end.

END PROCEDURE. /* pi_localiza_tt_cta_ctbl_analitica_demonst */
/*****************************************************************************
** Procedure Interna.....: pi_definir_periodo_razao
** Descricao.............: pi_definir_periodo_razao
** Criado por............: fut12209
** Criado em.............: 13/04/2004 10:17:26
** Alterado por..........: fut12209
** Alterado em...........: 13/04/2004 15:54:59
*****************************************************************************/
PROCEDURE pi_definir_periodo_razao:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer btt_col_demonst_ctbl
        for tt_col_demonst_ctbl.
    &endif
    def buffer btt_valor_demonst_ctbl_video
        for tt_valor_demonst_ctbl_video.


    /*************************** Buffer Definition End **************************/

    assign v_num_mes = 0
           v_num_ano = 0
           v_cod_aux_3 = "+"
           v_num_coluna = 0.
    case v_cod_campo:
            when 'ttv_cod_campo_1' then
                assign v_num_coluna = 1.
            when 'ttv_cod_campo_2' then
                assign v_num_coluna = 2.
            when 'ttv_cod_campo_3' then
                assign v_num_coluna = 3.
            when 'ttv_cod_campo_4' then
                assign v_num_coluna = 4.
            when 'ttv_cod_campo_5' then
                assign v_num_coluna = 5.
            when 'ttv_cod_campo_6' then
                assign v_num_coluna = 6.
            when 'ttv_cod_campo_7' then
                assign v_num_coluna = 7.
            when 'ttv_cod_campo_8' then
                assign v_num_coluna = 8.
            when 'ttv_cod_campo_9' then
                assign v_num_coluna = 9.
            when 'ttv_cod_campo_10' then
                assign v_num_coluna = 10.
            when 'ttv_cod_campo_11' then
                assign v_num_coluna = 11.
            when 'ttv_cod_campo_12' then
                assign v_num_coluna = 12.
            when 'ttv_cod_campo_13' then
                assign v_num_coluna = 13.
            when 'ttv_cod_campo_14' then
                assign v_num_coluna = 14.
            when 'ttv_cod_campo_15' then
                assign v_num_coluna = 15.
    end.
    if v_num_coluna <> 0 then do:
        find first tt_label_demonst_ctbl_video 
             where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl =  v_num_coluna no-error.
        find first tt_col_demonst_ctbl no-lock
             where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
             no-error.
        if avail  tt_col_demonst_ctbl then do:
           assign v_num_mes = tt_col_demonst_ctbl.qtd_period_relac_base 
                  v_num_ano = tt_col_demonst_ctbl.qtd_exerc_relac_base .
           if tt_col_demonst_ctbl.ind_tip_relac_base = "Antes da Referància" /*l_antes_da_referencia*/  then
              assign  v_cod_aux_3 = "-".
           else
              assign  v_cod_aux_3 = "+".
        end.      
    end.



END PROCEDURE. /* pi_definir_periodo_razao */
/*****************************************************************************
** Procedure Interna.....: pi_consulta_empenho
** Descricao.............: pi_consulta_empenho
** Criado por............: fut1180
** Criado em.............: 26/07/2004 11:41:52
** Alterado por..........: fut1180
** Alterado em...........: 14/09/2005 17:33:02
*****************************************************************************/
PROCEDURE pi_consulta_empenho:

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_fim_aux             as character       no-undo. /*local*/
    def var v_cod_ccusto_inic_aux            as character       no-undo. /*local*/
    def var v_num_ano_aux                    as integer         no-undo. /*local*/
    def var v_num_mes_aux                    as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    FIND FIRST conjto_prefer_demonst NO-LOCK
        WHERE conjto_prefer_demonst.cod_usuario = v_cod_usuar_corren
          AND conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
          AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
          AND conjto_prefer_demonst.num_conjto_param_ctbl =  v_num_conjto_param_ctbl
          NO-ERROR.
    FIND cenar_ctbl NO-LOCK
        WHERE cenar_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl NO-ERROR.

    if  v_cod_demonst_ctbl <> '' then do:
        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = prefer_demonst_ctbl.cod_exerc_ctbl NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl = prefer_demonst_ctbl.num_period_ctbl NO-ERROR.
        assign v_num_ano_aux  = integer(prefer_demonst_ctbl.cod_exerc_ctbl)
               v_num_mes_aux  = prefer_demonst_ctbl.num_period_ctbl.
    end.
    else do:
        &if '{&emsfin_version}' > '5.05' &then
            assign v_cod_exec_period_1 = conjto_prefer_demonst.cod_exerc_period_1.
        &else
            assign v_cod_exec_period_1 = string(year(conjto_prefer_demonst.dat_livre_1),'9999') +
                                         string(month(conjto_prefer_demonst.dat_livre_1),'99').
        &endif

        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(substr(v_cod_exec_period_1,1,4),'9999') NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl =  int(STRING(substr(v_cod_exec_period_1,5,2),'99')) NO-ERROR.
        assign v_num_ano_aux = integer(string(substr(v_cod_exec_period_1,1,4),'9999'))
               v_num_mes_aux = int(STRING(substr(v_cod_exec_period_1,5,2),'99')).
    end.

    run pi_definir_periodo_razao.

    if v_num_ano <> 0 or v_num_mes <> 0 then do:
       if v_cod_aux_3 = "+" then do:
          assign v_num_ano_aux = v_num_ano_aux + v_num_ano
                 v_num_mes_aux = v_num_mes_aux + v_num_mes.
          if v_num_mes_aux > 12  then do:
              assign v_num_mes_aux = v_num_mes_aux - 12.
              if v_num_ano = 0 then
                 assign v_num_ano_aux = v_num_ano_aux + 1.
          end.
       end.
       else do:
          assign v_num_ano_aux = v_num_ano_aux - v_num_ano
                 v_num_mes_aux = v_num_mes_aux - v_num_mes.
          if v_num_mes_aux <= 0 then do:
             assign v_num_mes_aux = 12 + v_num_mes_aux.
             if v_num_ano = 0 then 
                assign v_num_ano_aux = v_num_ano_aux - 1.
          end.
       end.

       FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(v_num_ano_aux) NO-ERROR.
       FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = string(v_num_ano_aux)
              AND period_ctbl.num_period_ctbl = v_num_mes_aux NO-ERROR.

    end.      

    FIND plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl NO-ERROR.

    FIND cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
          AND cta_ctbl.cod_cta_ctbl = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho NO-ERROR.

    FIND finalid_econ NO-LOCK
        WHERE finalid_econ.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ NO-ERROR.

    FIND plano_ccusto NO-LOCK
        WHERE plano_ccusto.cod_empresa      = tt_compos_demonst_cadastro.cod_unid_organ
        AND   plano_ccusto.cod_plano_ccusto = tt_compos_demonst_cadastro.cod_plano_ccusto NO-ERROR.

    /* Recupera a faixa dos Centros de Custo */
    IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho = "" THEN DO:
        &if '{&emsfin_version}' <= '5.05' &then
            FIND FIRST tab_livre_emsfin NO-LOCK
                WHERE tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  AND tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + CHR(10) + v_cod_padr_col_demonst_ctbl
                  AND tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                  AND tab_livre_emsfin.cod_compon_2_idx_tab = string(1) NO-ERROR.
            IF AVAIL tab_livre_emsfin THEN
                ASSIGN v_cod_ccusto_inic_aux = ENTRY(1,tab_livre_emsfin.cod_livre_2,CHR(10))
                       v_cod_ccusto_fim_aux  = ENTRY(2,tab_livre_emsfin.cod_livre_2,CHR(10)).
        &else
            ASSIGN v_cod_ccusto_inic_aux = conjto_prefer_demonst.cod_ccusto_inic
                   v_cod_ccusto_fim_aux  = conjto_prefer_demonst.cod_ccusto_fim.
        &endif
    END.

    find emscad.empresa no-lock
        where empresa.cod_empresa = tt_compos_demonst_cadastro.cod_unid_organ no-error.

        assign v_rec_empresa           = recid(empresa)
            v_rec_cenar_ctbl        = recid(cenar_ctbl) 
            v_rec_finalid_econ      = recid(finalid_econ) 
            v_rec_plano_cta_ctbl    = recid(plano_cta_ctbl) 
            v_rec_plano_ccusto      = if avail plano_ccusto then recid(plano_ccusto) 
                                      else ?
            v_cod_cta_ctbl_inicial  = cta_ctbl.cod_cta_ctbl 
            v_cod_cta_ctbl_final    = cta_ctbl.cod_cta_ctbl 
            v_cod_ccusto            = IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> ""
                                      THEN tt_demonst_ctbl_fin.tta_cod_ccusto_filho
                                      ELSE v_cod_ccusto_inic_aux
            v_cod_ccusto_final      = IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> ""
                                      THEN tt_demonst_ctbl_fin.tta_cod_ccusto_filho
                                      ELSE v_cod_ccusto_fim_aux
            v_cod_estab_in          = if tt_demonst_ctbl_fin.tta_cod_estab <> ""
                                      then tt_demonst_ctbl_fin.tta_cod_estab
                                      else conjto_prefer_demonst.cod_estab_inic
            v_cod_estab_fim         = if tt_demonst_ctbl_fin.tta_cod_estab <> ""
                                      then tt_demonst_ctbl_fin.tta_cod_estab
                                      else conjto_prefer_demonst.cod_estab_inic
            v_cod_unid_negoc        = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> "" 
                                      then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
                                      else conjto_prefer_demonst.cod_unid_negoc_inic
            v_cod_unid_negoc_fim    = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ""
                                      then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho
                                      else conjto_prefer_demonst.cod_unid_negoc_fim
            v_dat_movto             = period_ctbl.dat_inic_period_ctbl 
            v_dat_movto_fim         = period_ctbl.dat_fim_period_ctbl
            v_log_orig_demonst      = yes
            v_cod_unid_orctaria_aux = &if '{&emsfin_version}' > '5.05'
                                      &then conjto_prefer_demonst.cod_unid_orctaria
                                      &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
            v_cod_unid_orctaria_ate = &if '{&emsfin_version}' > '5.05'
                                      &then conjto_prefer_demonst.cod_unid_orctaria
                                      &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif. 

    if  search("prgfin/bgc/bgc200aa.r") = ? and search("prgfin/bgc/bgc200aa.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bgc/bgc200aa.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/bgc/bgc200aa.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
/*     else DO:                                                                                                                                                       */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*         FIND LAST periodo_orcto NO-LOCK NO-ERROR.                                                                                                                  */
/*               IF date(prefer_demonst_ctbl.num_period_ctbl, 01, int(prefer_demonst_ctbl.cod_exerc_ctbl)) <= date(periodo_orcto.Mes, 01, periodo_orcto.Ano) THEN DO: */
/*                  ASSIGN v_log_realizado = YES                                                                                                                      */
/*                         v_log_nao_realzdo_label = no.                                                                                                              */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*                                                                                                                                                                    */
/*              END.                                                                                                                                                  */
/*              IF date(prefer_demonst_ctbl.num_period_ctbl, 01, int(prefer_demonst_ctbl.cod_exerc_ctbl)) > date(periodo_orcto.Mes, 01, periodo_orcto.Ano) THEN DO:   */
/*                                                                                                                                                                    */
/*                  ASSIGN v_log_realizado = NO                                                                                                                       */
/*                         v_log_nao_realzdo_label = YES.                                                                                                             */
/*                                                                                                                                                                    */
/* END.                                                                                                                                                               */
         

        run prgfin/bgc/bgc200aa.p /*prg_bas_orig_movto_empenh*/.

    assign v_log_orig_demonst = no.

    /* --- Recupera valores para a faixa de UN ---*/
    ASSIGN v_cod_unid_negoc_fim = v_cod_unid_negoc_subst_fim.
/* END. */
END PROCEDURE. /* pi_consulta_empenho */
/*****************************************************************************
** Procedure Interna.....: pi_executa_gatilho_menu
** Descricao.............: pi_executa_gatilho_menu
** Criado por............: fut1180
** Criado em.............: 04/08/2004 20:57:27
** Alterado por..........: fut12209
** Alterado em...........: 18/12/2007 10:15:09
*****************************************************************************/
PROCEDURE pi_executa_gatilho_menu:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_menu
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_expand_all
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_rec_demonst_ctbl_video_1
        as recid
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  v_log_funcao_concil_consolid and v_log_expand_lin and p_num_menu < 8
    then do:
        /* p_num_menu = 1 --> Contrai estrutura */
        if  p_num_menu = 1 then
            assign v_log_expand_all = YES.
        else
            assign v_log_expand_all = NO.

        assign v_rec_demonst_ctbl_video_1 = recid(tt_demonst_ctbl_fin).
        repeat preselect each btt_demonst_ctbl_fin
            where ( btt_demonst_ctbl_fin.ttv_log_expand = no and v_log_expand_all = no) or
                  ( btt_demonst_ctbl_fin.ttv_log_expand = yes and v_log_expand_all = yes and   btt_demonst_ctbl_fin.ttv_log_expand_usuar = yes) :
            find next btt_demonst_ctbl_fin.
            find first tt_demonst_ctbl_fin
                 where recid(tt_demonst_ctbl_fin) = recid(btt_demonst_ctbl_fin) no-error.

            /* Posiciona coluna selecionada*/
            find tt_item_demonst_ctbl_video no-lock
                where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                  no-error.

            if  avail tt_item_demonst_ctbl_video
            and tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = "Chr Espec" /*l_hr_espec*/  then
                next.

            /* Posiciona item do demonstrativo*/
            find first tt_item_demonst_ctbl_cadastro no-lock
                 where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
                   and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                   no-error.

            run pi_executa_gatilho_menu_2 (Input p_num_menu) /*pi_executa_gatilho_menu_2*/.
        end.
        if  can-find(first tt_demonst_ctbl_fin
            where recid(tt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video_1) then
            assign v_rec_demonst_ctbl_video = v_rec_demonst_ctbl_video_1.
        else
            assign v_rec_demonst_ctbl_video = ?.
    end.
    else
        run pi_executa_gatilho_menu_2 (Input p_num_menu) /*pi_executa_gatilho_menu_2*/.

    if  p_num_menu = 1
    then do:
        /* Contrai extrutura */
        open query qr_demonst_ctbl_fin for
              each tt_demonst_ctbl_fin
             where tt_demonst_ctbl_fin.ttv_log_apres
                by tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl.    
    end.
    else do:
        /* * Monta valores encontrados e posiciona no item expandido **/
        run pi_open_demonst_ctbl_fin /*pi_open_demonst_ctbl_fin*/.
    end.

    if  v_rec_demonst_ctbl_video <> ?
    then do:
        reposition qr_demonst_ctbl_fin to recid v_rec_demonst_ctbl_video no-error.
        assign v_rec_demonst_ctbl_video = ?.
    end.
    else
        reposition qr_demonst_ctbl_fin to row (1)  no-error.

END PROCEDURE. /* pi_executa_gatilho_menu */
/*****************************************************************************
** Procedure Interna.....: pi_executa_gatilho_menu_2
** Descricao.............: pi_executa_gatilho_menu_2
** Criado por............: its0068
** Criado em.............: 25/08/2005 11:27:28
** Alterado por..........: fut12209
** Alterado em...........: 24/02/2009 13:45:20
*****************************************************************************/
PROCEDURE pi_executa_gatilho_menu_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_menu
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    case p_num_menu:

        when 1 then do:
            If session:set-wait-state ("General" /*l_general*/ ) then.
            run pi_contrai_estrutura /*pi_contrai_estrutura*/.
            If session:set-wait-state ("") then.
            apply "Entry" /*l_entry*/   to br_demonst_ctbl_fin IN FRAME f_bas_10_demonst_ctbl_fin.

        END.

        when 2 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "Conta Cont†bil" /* l_conta_contabil*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 3 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "Centro de Custo" /* l_centro_de_custo*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 4 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "Projeto" /* l_projeto*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 5 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "Unidade Neg¢cio" /* l_unidade_negocio*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 6 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "Estabelecimento" /* l_estabelecimento*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 7 then do:

            /* Begin_Include: i_menu_item_demonst_video */
            expande:
            do on error undo expande, leave expande:

                If session:set-wait-state ("General" /*l_general*/ ) then.

                disable br_demonst_ctbl_fin
                        with frame f_bas_10_demonst_ctbl_fin.

                run pi_expand_demonst_fin (Input "UO Origem" /* l_uo_origem*/) /*pi_expand_demonst_fin*/.

                enable br_demonst_ctbl_fin
                       with frame f_bas_10_demonst_ctbl_fin.

            end.
            If session:set-wait-state ("") then.

            apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
            /* End_Include: i_menu_item_demonst_video */

        END.

        when 9 then do:
            if  trim(v_cod_demonst_ctbl) <> ''
            then do: 
                case v_cod_campo:
                  when 'ttv_cod_campo_1' then
                      assign v_num_coluna = 1.
                  when 'ttv_cod_campo_2' then
                      assign v_num_coluna = 2.
                  when 'ttv_cod_campo_3' then
                      assign v_num_coluna = 3.
                  when 'ttv_cod_campo_4' then
                      assign v_num_coluna = 4.
                  when 'ttv_cod_campo_5' then
                      assign v_num_coluna = 5.
                  when 'ttv_cod_campo_6' then
                      assign v_num_coluna = 6.
                  when 'ttv_cod_campo_7' then
                      assign v_num_coluna = 7.
                  when 'ttv_cod_campo_8' then
                      assign v_num_coluna = 8.
                  when 'ttv_cod_campo_9' then
                      assign v_num_coluna = 9.
                  when 'ttv_cod_campo_10' then
                      assign v_num_coluna = 10.
                  when 'ttv_cod_campo_11' then
                      assign v_num_coluna = 11.
                  when 'ttv_cod_campo_12' then
                      assign v_num_coluna = 12.
                  when 'ttv_cod_campo_13' then
                      assign v_num_coluna = 13.
                  when 'ttv_cod_campo_14' then
                      assign v_num_coluna = 14.
                  when 'ttv_cod_campo_15' then
                      assign v_num_coluna = 15.
                end.
                find first tt_label_demonst_ctbl_video 
                     where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + v_num_coluna 
                no-error.
                find first tt_col_demonst_ctbl no-lock
                     where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                no-error.
                find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.
                if  avail col_demonst_ctbl
                then do:
                    assign v_num_conjto_param_ctbl = col_demonst_ctbl.num_conjto_param_ctbl.
                    run pi_razao_contabil_demonst (Input "Cta Ctbl" /*l_cta_ctbl*/) /*pi_razao_contabil_demonst*/.
                end.
            end /* if */.
            else do:
                run pi_razao_contabil_demonst (Input "Cta Ctbl" /*l_cta_ctbl*/) /*pi_razao_contabil_demonst*/.
            end /* else */.
        END.

        when 10 then do:
            if  trim(v_cod_demonst_ctbl) <> ''
            then do: 
                case v_cod_campo:
                  when 'ttv_cod_campo_1' then
                      assign v_num_coluna = 1.
                  when 'ttv_cod_campo_2' then
                      assign v_num_coluna = 2.
                  when 'ttv_cod_campo_3' then
                      assign v_num_coluna = 3.
                  when 'ttv_cod_campo_4' then
                      assign v_num_coluna = 4.
                  when 'ttv_cod_campo_5' then
                      assign v_num_coluna = 5.
                  when 'ttv_cod_campo_6' then
                      assign v_num_coluna = 6.
                  when 'ttv_cod_campo_7' then
                      assign v_num_coluna = 7.
                  when 'ttv_cod_campo_8' then
                      assign v_num_coluna = 8.
                  when 'ttv_cod_campo_9' then
                      assign v_num_coluna = 9.
                  when 'ttv_cod_campo_10' then
                      assign v_num_coluna = 10.
                  when 'ttv_cod_campo_11' then
                      assign v_num_coluna = 11.
                  when 'ttv_cod_campo_12' then
                      assign v_num_coluna = 12.
                  when 'ttv_cod_campo_13' then
                      assign v_num_coluna = 13.
                  when 'ttv_cod_campo_14' then
                      assign v_num_coluna = 14.
                  when 'ttv_cod_campo_15' then
                      assign v_num_coluna = 15.
                end.
                find first tt_label_demonst_ctbl_video 
                     where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + v_num_coluna no-error.
                find first tt_col_demonst_ctbl no-lock
                     where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                       and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl no-error.
                find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.
                if  avail col_demonst_ctbl
                then do:
                    assign v_num_conjto_param_ctbl = col_demonst_ctbl.num_conjto_param_ctbl.
                    run pi_razao_contabil_demonst (Input "CCusto" /*l_ccusto*/) /*pi_razao_contabil_demonst*/.
                end /* if */.
            end /* if */.
            else do:
                run pi_razao_contabil_demonst (Input "CCusto" /*l_ccusto*/) /*pi_razao_contabil_demonst*/.
            end /* else */.    
        end.    
        when 11 then do:
            case v_cod_campo:
                when 'ttv_cod_campo_1' then
                    assign v_num_coluna = 1.
                when 'ttv_cod_campo_2' then
                    assign v_num_coluna = 2.
                when 'ttv_cod_campo_3' then
                    assign v_num_coluna = 3.
                when 'ttv_cod_campo_4' then
                    assign v_num_coluna = 4.
                when 'ttv_cod_campo_5' then
                    assign v_num_coluna = 5.
                when 'ttv_cod_campo_6' then
                    assign v_num_coluna = 6.
                when 'ttv_cod_campo_7' then
                    assign v_num_coluna = 7.
                when 'ttv_cod_campo_8' then
                    assign v_num_coluna = 8.
                when 'ttv_cod_campo_9' then
                    assign v_num_coluna = 9.
                when 'ttv_cod_campo_10' then
                    assign v_num_coluna = 10.
                when 'ttv_cod_campo_11' then
                    assign v_num_coluna = 11.
                when 'ttv_cod_campo_12' then
                    assign v_num_coluna = 12.
                when 'ttv_cod_campo_13' then
                    assign v_num_coluna = 13.
                when 'ttv_cod_campo_14' then
                    assign v_num_coluna = 14.
                when 'ttv_cod_campo_15' then
                    assign v_num_coluna = 15.
            end.

            find first tt_label_demonst_ctbl_video 
                 where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + v_num_coluna no-error.
            find first tt_col_demonst_ctbl no-lock
                 where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                   and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                 no-error.
            find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.
            if  avail col_demonst_ctbl
            then do:
                assign v_rec_col_demonst_ctbl = RECID(col_demonst_ctbl).
                if  search("prgfin/mgl/mgl007ja.r") = ? and search("prgfin/mgl/mgl007ja.p") = ? then do:
                    if  v_cod_dwb_user begins 'es_' then
                        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl007ja.p".
                    else do:
                        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl007ja.p"
                               view-as alert-box error buttons ok.
                        return.
                    end.
                end.
                else
                    run prgfin/mgl/mgl007ja.p /*prg_det_col_demonst_ctbl*/.
            end.       
        END.

        when 12 then do:
            if  avail tt_item_demonst_ctbl_cadastro
               then do:
               find first item_demonst_ctbl of tt_item_demonst_ctbl_cadastro no-lock no-error.
               if  avail item_demonst_ctbl
               then do:
                   assign v_rec_item_demonst_ctbl = recid(item_demonst_ctbl).
                   if  search("prgfin/mgl/mgl003ja.r") = ? and search("prgfin/mgl/mgl003ja.p") = ? then do:
                       if  v_cod_dwb_user begins 'es_' then
                           return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl003ja.p".
                       else do:
                           message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl003ja.p"
                                  view-as alert-box error buttons ok.
                           return.
                       end.
                   end.
                   else
                       run prgfin/mgl/mgl003ja.p /*prg_det_item_demonst_ctbl*/.
               end.
            end.   
        END.

        when 13 then do:
             case v_cod_campo:
              when 'ttv_cod_campo_1' then
                  assign v_num_coluna = 1.
              when 'ttv_cod_campo_2' then
                  assign v_num_coluna = 2.
              when 'ttv_cod_campo_3' then
                  assign v_num_coluna = 3.
              when 'ttv_cod_campo_4' then
                  assign v_num_coluna = 4.
              when 'ttv_cod_campo_5' then
                  assign v_num_coluna = 5.
              when 'ttv_cod_campo_6' then
                  assign v_num_coluna = 6.
              when 'ttv_cod_campo_7' then
                  assign v_num_coluna = 7.
              when 'ttv_cod_campo_8' then
                  assign v_num_coluna = 8.
              when 'ttv_cod_campo_9' then
                  assign v_num_coluna = 9.
              when 'ttv_cod_campo_10' then
                  assign v_num_coluna = 10.
              when 'ttv_cod_campo_11' then
                  assign v_num_coluna = 11.
              when 'ttv_cod_campo_12' then
                  assign v_num_coluna = 12.
              when 'ttv_cod_campo_13' then
                  assign v_num_coluna = 13.
              when 'ttv_cod_campo_14' then
                  assign v_num_coluna = 14.
              when 'ttv_cod_campo_15' then
                  assign v_num_coluna = 15.
             end.
             find first tt_label_demonst_ctbl_video 
                  where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + v_num_coluna 
             no-error.
             find first tt_col_demonst_ctbl no-lock
                  where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                    and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
             no-error.
             find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.
             if  avail col_demonst_ctbl
             then do:
                assign v_num_conjto_param_ctbl = col_demonst_ctbl.num_conjto_param_ctbl.
                run pi_consulta_empenho.
             end.
        end.    
        when 14 then
            run pi_consulta_orcamento.

        when 16 then do:

            /* Begin_Include: i_menu_item_demonst_video */
                expande:
                do on error undo expande, leave expande:

                    If session:set-wait-state ("General" /*l_general*/  /* l_general*/ ) then.

                    disable br_demonst_ctbl_fin
                            with frame f_bas_10_demonst_ctbl_fin.

                    if v_cod_arq <> "" then do:
                      output to value(v_cod_arq) append.
                      put skip(1)  '<< In°cio expans∆o total >> ' string(time,'hh:mm:ss')  skip.
                      output close.
                    end.                            


                    for each tt_demonst_ctbl_fin:
                        run pi_expand_demonst_fin_aux (Input "Conta Cont†bil" /*l_conta_contabil*/  /* l_conta_contabil*/) /* pi_expand_demonst_fin*/.                
                    end.

                    if v_cod_arq <> "" then do:
                      output to value(v_cod_arq) append.
                      put skip(1)  '<< Fim expans∆o total >> ' string(time,'hh:mm:ss')  skip.
                      output close.
                    end.        


                    enable br_demonst_ctbl_fin
                           with frame f_bas_10_demonst_ctbl_fin.

                end.
                If session:set-wait-state ("") then.

                apply "Entry" /*l_entry*/  to br_demonst_ctbl_fin.
                /* End_Include: i_menu_item_demonst_video */

            END.

    end case.

END PROCEDURE. /* pi_executa_gatilho_menu_2 */
/*****************************************************************************
** Procedure Interna.....: pi_cria_menu
** Descricao.............: pi_cria_menu
** Criado por............: fut1180
** Criado em.............: 09/08/2004 11:10:26
** Alterado por..........: its0068
** Alterado em...........: 25/08/2005 14:05:59
*****************************************************************************/
PROCEDURE pi_cria_menu:

    /************************ Parameter Definition Begin ************************/

    def Input param p_nom_label
        as character
        format "x(999)"
        no-undo.
    def Input param p_cod_tip_menu
        as character
        format "x(8)"
        no-undo.
    def Input param p_num_menu
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_log_habilita
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    def input param p-wgh-object       as handle        no-undo.
    def output param p-wgh-menu        as handle        no-undo.

    def var wh-menu-item as widget-handle no-undo.

    if  p_nom_label = ''
    then do:
        create menu-item wh-menu-item
        assign label   = p_nom_label
               parent  = p-wgh-object
               subtype = p_cod_tip_menu.
    end.
    else do:
        create menu-item wh-menu-item
        assign label   = p_nom_label
               parent  = p-wgh-object
               subtype = p_cod_tip_menu
               toggle-box = p_log_habilita
        triggers:
            on choose persistent run prgfin/mgl/escg0204zh.p (input p_num_menu,
                                                        input this-procedure).
        end triggers.
    end.
    assign p-wgh-menu = wh-menu-item:HANDLE.
END PROCEDURE. /* pi_cria_menu */
/*****************************************************************************
** Procedure Interna.....: pi_consulta_orcamento
** Descricao.............: pi_consulta_orcamento
** Criado por............: fut1180
** Criado em.............: 09/08/2004 22:30:48
** Alterado por..........: its37043
** Alterado em...........: 26/10/2005 11:16:10
*****************************************************************************/
PROCEDURE pi_consulta_orcamento:
    /***Araupel**** Customizacao Justificativa*****/
    
    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_fim_aux             as character       no-undo. /*local*/
    def var v_cod_ccusto_inic_aux            as character       no-undo. /*local*/
    def var v_num_ano_aux                    as integer         no-undo. /*local*/
    def var v_num_mes_aux                    as integer         no-undo. /*local*/
    DEF VAR v_cp2                            AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99" NO-UNDO.
    DEF VAR v_cp3                            AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99" NO-UNDO.
    DEF VAR v_cp                             AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99" NO-UNDO.
    /************************** Variable Definition End *************************/

    FIND FIRST conjto_prefer_demonst NO-LOCK
        WHERE conjto_prefer_demonst.cod_usuario = v_cod_usuar_corren
          AND conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
          AND conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
          NO-ERROR.
    FIND cenar_ctbl NO-LOCK
        WHERE cenar_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl NO-ERROR.

    if  v_cod_demonst_ctbl <> '' then do:
        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = prefer_demonst_ctbl.cod_exerc_ctbl NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl = prefer_demonst_ctbl.num_period_ctbl NO-ERROR.
        assign v_num_ano_aux  = integer(prefer_demonst_ctbl.cod_exerc_ctbl)
               v_num_mes_aux  = prefer_demonst_ctbl.num_period_ctbl.
    end.
    else do:
        &if '{&emsfin_version}' > '5.05' &then
            assign v_cod_exec_period_1 = conjto_prefer_demonst.cod_exerc_period_1.
        &else
            assign v_cod_exec_period_1 = string(year(conjto_prefer_demonst.dat_livre_1),'9999') +
                                         string(month(conjto_prefer_demonst.dat_livre_1),'99').
        &endif

        FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(substr(v_cod_exec_period_1,1,4),'9999') NO-ERROR.
        FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
              AND period_ctbl.num_period_ctbl =  int(STRING(substr(v_cod_exec_period_1,5,2),'99')) NO-ERROR.
        assign v_num_ano_aux = integer(string(substr(v_cod_exec_period_1,1,4),'9999'))
               v_num_mes_aux = int(STRING(substr(v_cod_exec_period_1,5,2),'99')).
    end.

    run pi_definir_periodo_razao.

    if v_num_ano <> 0 or v_num_mes <> 0 then do:
       if v_cod_aux_3 = "+" then do:
          assign v_num_ano_aux = v_num_ano_aux + v_num_ano
                 v_num_mes_aux = v_num_mes_aux + v_num_mes.
          if v_num_mes_aux > 12  then do:
              assign v_num_mes_aux = v_num_mes_aux - 12.
              if v_num_ano = 0 then
                 assign v_num_ano_aux = v_num_ano_aux + 1.
          end.
       end.
       else do:
          assign v_num_ano_aux = v_num_ano_aux - v_num_ano
                 v_num_mes_aux = v_num_mes_aux - v_num_mes.
          if v_num_mes_aux <= 0 then do:
             assign v_num_mes_aux = 12 + v_num_mes_aux.
             if v_num_ano = 0 then 
                assign v_num_ano_aux = v_num_ano_aux - 1.
          end.
       end.

       FIND exerc_ctbl NO-LOCK
            WHERE exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              AND exerc_ctbl.cod_exerc_ctbl = string(v_num_ano_aux) NO-ERROR.
       FIND period_ctbl NO-LOCK
            WHERE period_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
              AND period_ctbl.cod_exerc_ctbl  = string(v_num_ano_aux)
              AND period_ctbl.num_period_ctbl = v_num_mes_aux NO-ERROR.

    end.      

    FIND cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
          AND cta_ctbl.cod_cta_ctbl       = tt_demonst_ctbl_fin.tta_cod_cta_ctbl_filho NO-ERROR.
    FIND finalid_econ NO-LOCK
        WHERE finalid_econ.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ
        NO-ERROR.

    /* Recupera a faixa dos Centros de Custo */
    IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho = "" THEN DO:
        &if '{&emsfin_version}' <= '5.05' &then
            FIND FIRST tab_livre_emsfin NO-LOCK
                WHERE tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  AND tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + CHR(10) + v_cod_padr_col_demonst_ctbl
                  AND tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                  AND tab_livre_emsfin.cod_compon_2_idx_tab = string(1) NO-ERROR.
            IF AVAIL tab_livre_emsfin THEN
                ASSIGN v_cod_ccusto_inic_aux = ENTRY(1,tab_livre_emsfin.cod_livre_2,CHR(10))
                       v_cod_ccusto_fim_aux  = ENTRY(2,tab_livre_emsfin.cod_livre_2,CHR(10)).
        &else
            ASSIGN v_cod_ccusto_inic_aux = conjto_prefer_demonst.cod_ccusto_inic
                   v_cod_ccusto_fim_aux  = conjto_prefer_demonst.cod_ccusto_fim.
        &endif
    END.

    find vers_orcto_ctbl_bgc no-lock
        where vers_orcto_ctbl_bgc.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
        and   vers_orcto_ctbl_bgc.cod_unid_orctaria   = &if '{&emsfin_version}' > '5.05'
                                                      &then conjto_prefer_demonst.cod_unid_orctaria
                                                      &else entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) &endif
        and   vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = &if '{&emsfin_version}' > '5.05'
                                                      &then conjto_prefer_demonst.num_seq_orcto_ctbl
                                                      &else integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) &endif
        and   vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl no-error.
    if avail vers_orcto_ctbl_bgc then
        assign v_rec_vers_orcto_ctbl_bgc = recid(vers_orcto_ctbl_bgc).

    assign v_cod_empres_ems_inic        = tt_compos_demonst_cadastro.cod_unid_organ
           v_cod_empres_ems_fim         = tt_compos_demonst_cadastro.cod_unid_organ
/*            v_rec_cenar_ctbl             = recid(cenar_ctbl)                                              */
/*            v_rec_finalid_econ           = recid(finalid_econ)                                            */
/*            v_cod_plano_cta_ctbl_inicial = tt_compos_demonst_cadastro.cod_plano_cta_ctbl                  */
/*            v_cod_plano_cta_final        = tt_compos_demonst_cadastro.cod_plano_cta_ctbl                  */
/*            v_cod_plano_ccusto_ini       = tt_compos_demonst_cadastro.cod_plano_ccusto                    */
/*            v_cod_plano_ccusto_final     = if tt_compos_demonst_cadastro.cod_plano_ccusto <> ""           */
/*                                           then tt_compos_demonst_cadastro.cod_plano_ccusto               */
/*                                           else "ZZZZZZZZ":U                                              */
/*            v_cod_cta_ctbl_inic          = cta_ctbl.cod_cta_ctbl                                          */
/*            v_cod_cta_ctbl_final         = cta_ctbl.cod_cta_ctbl                                          */
/*            v_cod_ccusto_inicial         = IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> ""              */
/*                                           THEN tt_demonst_ctbl_fin.tta_cod_ccusto_filho                  */
/*                                           ELSE v_cod_ccusto_inic_aux                                     */
/*            v_cod_ccusto_final           = IF tt_demonst_ctbl_fin.tta_cod_ccusto_filho <> ""              */
/*                                           THEN tt_demonst_ctbl_fin.tta_cod_ccusto_filho                  */
/*                                           ELSE v_cod_ccusto_fim_aux                                      */
/*            v_cod_estab_ini              = if tt_demonst_ctbl_fin.tta_cod_estab <> ""                     */
/*                                           then tt_demonst_ctbl_fin.tta_cod_estab                         */
/*                                           else conjto_prefer_demonst.cod_estab_inic                      */
/*            v_cod_estab_fim              = if tt_demonst_ctbl_fin.tta_cod_estab <> ""                     */
/*                                           then tt_demonst_ctbl_fin.tta_cod_estab                         */
/*                                           else conjto_prefer_demonst.cod_estab_fim                       */
/*            v_cod_unid_negoc_inic        = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ""          */
/*                                           then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho              */
/*                                           else conjto_prefer_demonst.cod_unid_negoc_inic                 */
/*            v_cod_unid_negoc_fim         = if tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho <> ""          */
/*                                           then tt_demonst_ctbl_fin.tta_cod_unid_negoc_filho              */
/*                                           else conjto_prefer_demonst.cod_unid_negoc_fim                  */
/*            v_log_orig_demonst           = yes                                                            */
/*            v_cod_proj_inic              = if tt_demonst_ctbl_fin.tta_cod_proj_financ <> ""               */
/*                                           then tt_demonst_ctbl_fin.tta_cod_proj_financ                   */
/*                                           else entry(1, tt_compos_demonst_cadastro.cod_livre_1, CHR(10)) */
/*            v_cod_proj_fim               = if tt_demonst_ctbl_fin.tta_cod_proj_financ <> ""               */
/*                                           then tt_demonst_ctbl_fin.tta_cod_proj_financ                   */
/*                                           else tt_compos_demonst_cadastro.cod_proj_financ_fim            */
           v_cod_exerc_ctbl_inic        = exerc_ctbl.cod_exerc_ctbl
           v_cod_exerc_ctbl_fin         = exerc_ctbl.cod_exerc_ctbl
           v_num_period_ctbl_ini        = period_ctbl.num_period_ctbl
           v_num_period_ctbl_final      = period_ctbl.num_period_ctbl. 


    /***Ponto de customizacao das justificativas*******/

IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_3) BEGINS "(" THEN 
    ASSIGN v_cp3 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_3), "(" ) , ")"))) * - 1.
 ELSE 
    ASSIGN v_cp3 = dec(TRIM(tt_demonst_ctbl_fin.ttv_cod_campo_3)).

IF trim(tt_demonst_ctbl_fin.ttv_cod_campo_2) BEGINS "(" THEN 
    ASSIGN v_cp2 = (dec(ENTRY(1, entry(2, TRIM(ttv_cod_campo_2), "(" ) , ")"))) * - 1.
 ELSE 
   ASSIGN v_cp2 =   dec(TRIM(tt_demonst_ctbl_fin.ttv_cod_campo_2)).

   ASSIGN v_cp = v_cp3 - v_cp2.


    RUN prgfin/mgl/escg12010.w (INPUT conjto_prefer_demonst.cod_demonst_ctbl,
                                INPUT conjto_prefer_demonst.cod_padr_col_demonst_ctbl,
                                INPUT v_cod_usuar_corren,
                                INPUT TODAY,
                                INPUT prefer_demonst_ctbl.num_period_ctbl,
                                INPUT prefer_demonst_ctbl.cod_exerc_ctbl,
                                INPUT trim(tt_demonst_ctbl_fin.ttv_cod_campo_1),
                                INPUT conjto_prefer_demonst.cod_demonst_ctbl,
                                INPUT v_cp3 ,
                                INPUT v_cp2).
                                    


/*     if v_cod_plano_ccusto_ini = ""                                       */
/*     and v_cod_plano_ccusto_final = "ZZZZZZZZ" /*l_ZZZZZZZZ*/  then       */
/*         assign v_cod_ccusto_inicial = ""                                 */
/*                v_cod_ccusto_final   = "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/ .  */

/*     if  search("prgfin/bdg/bdg204aa.r") = ? and search("prgfin/bdg/bdg204aa.p") = ? then do:                                              */
/*         if  v_cod_dwb_user begins 'es_' then                                                                                              */
/*             return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bdg/bdg204aa.p".                    */
/*         else do:                                                                                                                          */
/*             message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/bdg/bdg204aa.p"  */
/*                    view-as alert-box error buttons ok.                                                                                    */
/*             return.                                                                                                                       */
/*         end.                                                                                                                              */
/*     end.                                                                                                                                  */
/*     else                                                                                                                                  */
/*         run prgfin/bdg/bdg204aa.p /*prg_bas_vers_orcto_ctbl_bgc_movto_fin*/.                                                              */
/*                                                                                                                                           */
/*     assign v_log_orig_demonst = no.  */
/*                                                                                                                                           */
/*     /* --- Recupera valores para a faixa de UN ---*/                                                                                      */
    ASSIGN v_cod_unid_negoc_fim = v_cod_unid_negoc_subst_fim.
END PROCEDURE. /* pi_consulta_orcamento */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p05_bas_demonst_ctbl_fin
** Descricao.............: pi_ix_p05_bas_demonst_ctbl_fin
** Criado por............: fut12209
** Criado em.............: 31/01/2008 16:45:14
** Alterado por..........: fut12209
** Alterado em...........: 31/01/2008 16:46:43
*****************************************************************************/
PROCEDURE pi_ix_p05_bas_demonst_ctbl_fin:

    /* Elimina temp-tables da mem¢ria ao iniciar programa*/

    EMPTY TEMP-TABLE tt_item_demonst_ctbl_video.
    EMPTY TEMP-TABLE tt_label_demonst_ctbl_video.
    EMPTY TEMP-TABLE tt_valor_demonst_ctbl_video.

    assign br_demonst_ctbl_fin:separators in frame f_bas_10_demonst_ctbl_fin         = no no-error.

    assign bt_fir:help in frame f_bas_10_demonst_ctbl_fin = "Voltar Ö primeira coluna desse demonstratvo" /*l_primeira_col*/ 
           bt_pre1:help in frame f_bas_10_demonst_ctbl_fin = "Voltar Ö coluna anterior desse Demonstrativo" /*l_col_anterior*/ 
           bt_nex1:help in frame f_bas_10_demonst_ctbl_fin = "Listar a(s) pr¢xima(s) coluna(s) desse Demonstrativo" /*l_proxima_col*/ 
           bt_las:help in frame f_bas_10_demonst_ctbl_fin = "Listar a £ltima coluna desse Demonstrativo" /*l_ultima_col*/ 
           bt_fir:tooltip in frame f_bas_10_demonst_ctbl_fin = "Voltar Ö primeira coluna desse demonstratvo" /*l_primeira_col*/ 
           bt_pre1:tooltip in frame f_bas_10_demonst_ctbl_fin = "Voltar Ö coluna anterior desse Demonstrativo" /*l_col_anterior*/ 
           bt_nex1:tooltip in frame f_bas_10_demonst_ctbl_fin = "Listar a(s) pr¢xima(s) coluna(s) desse Demonstrativo" /*l_proxima_col*/ 
           bt_las:tooltip in frame f_bas_10_demonst_ctbl_fin = "Listar a £ltima coluna desse Demonstrativo" /*l_ultima_col*/ 
           br_demonst_ctbl_fin:bgcolor    in frame f_bas_10_demonst_ctbl_fin         = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_1:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_2:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_3:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_4:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_5:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_6:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_7:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_8:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_9:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_10:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_11:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_12:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_13:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_14:bgcolor in browse br_demonst_ctbl_fin = 15
           tt_demonst_ctbl_fin.ttv_cod_campo_15:bgcolor in browse br_demonst_ctbl_fin = 15
           v_log_expand = no.

    /* * Localiza os ParÉmetros definidos pelo Usu†rio para Consulta do Demonstrativo **/
    FOR EACH b_prefer_demonst_ctbl NO-LOCK
        WHERE b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
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

    /* --- Posiciona no Padr∆o de Colunas definido nos parÉmetros ---*/
    find padr_col_demonst_ctbl
        where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
        no-lock no-error.
END PROCEDURE. /* pi_ix_p05_bas_demonst_ctbl_fin */
/*****************************************************************************
** Procedure Interna.....: pi_expand_demonst_fin_aux
** Descricao.............: pi_expand_demonst_fin_aux
** Criado por............: fut43112
** Criado em.............: 05/11/2008 12:39:45
** Alterado por..........: fut12209
** Alterado em...........: 24/02/2009 11:57:09
*****************************************************************************/
PROCEDURE pi_expand_demonst_fin_aux:

    /************************ Parameter Definition Begin ************************/

    def input param p_cod_item
        as character
        format "x(30)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_estab_aux_1                as character       no-undo. /*local*/
    def var v_num_cont_aux                   as integer         no-undo. /*local*/
    def var v_num_seq_initial                as integer         no-undo. /*local*/
    def var v_num_seq_orig                   as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

     expand:
                do on error undo expand, return error:

                    /* Posiciona item do demonstrativo*/
                    find tt_item_demonst_ctbl_video
                         where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                         no-lock no-error.
                    find first tt_item_demonst_ctbl_cadastro no-lock
                         where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
                           and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                         no-error.

                    assign v_num_seq_initial                        = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl
                           v_num_seq                                = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                           v_num_seq_orig                           = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                           v_num_count                              = 0
                           v_num_nivel                              = tt_demonst_ctbl_fin.ttv_num_nivel + 1
                           tt_demonst_ctbl_fin.ttv_log_expand       = yes
                           tt_demonst_ctbl_fin.ttv_log_expand_usuar = yes
                           v_cod_estab_aux_1                         = tt_demonst_ctbl_fin.tta_cod_estab
                           v_rec_demonst_ctbl_video                 = recid(tt_demonst_ctbl_fin)
                           v_log_expand                             = yes.


                    /* * L¢gica para reposicionar corretamente item expandido **/
                    assign v_num_pos = br_demonst_ctbl_fin:focused-row in frame f_bas_10_demonst_ctbl_fin.
                    if  v_num_pos <> ? then
                        assign v_log_status = br_demonst_ctbl_fin:set-repositioned-row(v_num_pos, 'conditional') in frame f_bas_10_demonst_ctbl_fin.

                    do v_num_cont = 1 to 99:
                        if  substr(tt_demonst_ctbl_fin.ttv_des_col_demonst_video,v_num_cont,1) = " " then
                            assign v_num_cont_aux = v_num_cont_aux + 1.
                            else LEAVE.
                    end.

                    /* * Cria novos itens para expandir a informaá∆o no demonstrativo **/

                    run pi_tt_demonst_ctbl_fin_new (Input v_cod_estab_aux_1,
                                                    Input (v_num_cont_aux + 4) /* espaªo identaªío*/,
                                                    Input p_cod_item) /* pi_tt_demonst_ctbl_fin_new*/.

                    if  v_log_return = no then do:            
                        find tt_demonst_ctbl_fin 
                            where recid(tt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video
                            no-error.
                        if  avail tt_demonst_ctbl_fin then do:

                            assign tt_demonst_ctbl_fin.ttv_log_expand       = no
                                   tt_demonst_ctbl_fin.ttv_log_expand_usuar = no.
                        end.


                        /* Begin_Include: i_entry_browse_demonst_video */
                        /* Posiciona coluna selecionada*/
                        find tt_item_demonst_ctbl_video
                             where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                             no-lock no-error.
                        find first tt_label_demonst_ctbl_video 
                             where tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl = v_num_col + 1 no-error.
                        find first tt_col_demonst_ctbl no-lock
                             where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                               and tt_col_demonst_ctbl.cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl
                             no-error.
                        find first col_demonst_ctbl of tt_col_demonst_ctbl no-lock no-error.

                        /* Posiciona item do demonstrativo*/
                        find first tt_item_demonst_ctbl_cadastro no-lock
                             where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl = v_cod_demonst_ctbl
                               and tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                             no-error.

                        /* * Posiciona no item correto para pesquisa do detalhe **/
                        find first item_demonst_ctbl of tt_item_demonst_ctbl_cadastro no-lock no-error.

                        /* * L¢gica para localizar item nos n–veis acima qdo n∆o encontrado nos n–veis expandidos e n∆o for uma consulta **/
                        if  avail tt_demonst_ctbl_fin
                        then do:
                            assign v_rec_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video.

                            blk_while:
                            do while not avail item_demonst_ctbl :
                                find first btt_demonst_ctbl_fin where recid(btt_demonst_ctbl_fin) = v_rec_demonst_ctbl_video no-error.
                                if avail btt_demonst_ctbl_fin then do:

                                    find btt_item_demonst_ctbl_video
                                    where btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = btt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                                    no-lock no-error.

                                    find first item_demonst_ctbl  no-lock
                                    where item_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                                    and item_demonst_ctbl.num_seq_demonst_ctbl = integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                                    no-error.

                                    assign v_rec_demonst_ctbl_video = btt_demonst_ctbl_fin.ttv_rec_demonst_ctbl_video.
                                end.
                                else
                                    leave blk_while.
                            end.
                        end.

                        if  avail tt_demonst_ctbl_fin then
                            status input tt_demonst_ctbl_fin.ttv_cod_inform_princ in window wh_w_program.
                        /* End_Include: i_entry_browse_demonst_video */

                        leave expand.
                    end.

                    /* --- Elimina registros sem saldo conforme o par∆metro ---*/
                    if  prefer_demonst_ctbl.log_impr_cta_sem_sdo = no then do:
                        erase:
                        for each tt_demonst_ctbl_fin
                           where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:

                            find first tt_item_demonst_ctbl_video
                                where  tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                                no-error.
                            if  avail tt_item_demonst_ctbl_video then do:
                                if  not can-find(first tt_valor_demonst_ctbl_video
                                where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                                and   tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0) then do:
                                    for each tt_valor_demonst_ctbl_video
                                       where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                                       delete tt_valor_demonst_ctbl_video.
                                    end.
                                    delete tt_item_demonst_ctbl_video.
                                    delete tt_demonst_ctbl_fin.
                                end.
                            end.
                        end /* for erase */.
                    end.

                    /* --- Calcula Variaá∆o e F¢rmulas das Colunas ---*/
                    if  can-find(first tt_col_demonst_ctbl
                        where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/   
                        and  (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_formula*/ 
                        or    tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Variaá∆o" /*l_variacao*/ )) then do:
                        for each tt_demonst_ctbl_fin
                            where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:
                               find first tt_item_demonst_ctbl_video
                               where tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video
                               no-error.
                               if not avail  tt_item_demonst_ctbl_video then 
                                  next.
                               run pi_col_demons_ctbl_video_more_3 /* pi_col_demons_ctbl_video_more_3*/.
                        end.
                    end.

                    /* Se for consulta de saldo, calcula AV de forma diferenciada */
                    if prefer_demonst_ctbl.cod_demonst_ctbl = "" /* l_*/  then do:
                        for each tt_controla_analise_vertical:
                            delete tt_controla_analise_vertical.
                        end.

                        for each tt_col_demonst_ctbl 
                           where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/   
                           and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/ :
                            create tt_controla_analise_vertical.
                            assign tt_controla_analise_vertical.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 8, 2))
                                   tt_controla_analise_vertical.tta_cod_acumul_ctbl       = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 12, 8)).

                            for each tt_demonst_ctbl_fin
                                where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:
                                find tt_valor_demonst_ctbl_video
                                    where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = trim(substring(tt_col_demonst_ctbl.des_formul_ctbl, 8, 2))
                                    and   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video no-error.
                                if  avail tt_valor_demonst_ctbl_video then do:
                                    assign tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert = tt_controla_analise_vertical.ttv_val_sdo_ctbl_analis_vert
                                                                                                     + ABS(dec(tt_valor_demonst_ctbl_video.ttv_val_col_1)).
                                end. /* end if*/
                            end.
                        end.
                    end.

                    /* --- Calcula Analise Vertical ---*/
                    if  can-find(first  tt_col_demonst_ctbl
                        where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/   
                        and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/ ) then do:
                        for each tt_item_demonst_ctbl_video:

                            find first tt_demonst_ctbl_fin
                               where tt_demonst_ctbl_fin.ttv_rec_item_demonst_ctbl_video = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                               and   tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0
                               no-error.
                            if not avail tt_demonst_ctbl_fin then
                                next.

                            run pi_col_demons_ctbl_video_analise_vertical /* pi_col_demons_ctbl_video_analise_vertical*/.
                        end.
                    end.

                    increm:
                    repeat preselect each tt_demonst_ctbl_fin use-index tt_id_descending:
                        find next tt_demonst_ctbl_fin
                            where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl > v_num_seq_initial.
                        assign tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl + v_num_count.
                    end.

                    insere:
                    for each tt_demonst_ctbl_fin
                        where tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl < 0:
                        assign v_num_seq_initial = v_num_seq_initial + 10
                               tt_demonst_ctbl_fin.tta_num_seq_demonst_ctbl = v_num_seq_initial.
                    end.
                end.
END PROCEDURE. /* pi_expand_demonst_fin_aux */


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
        message getStrTrans("Mensagem nr. ", "MGL") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "MGL") c_prg_msg getStrTrans("n∆o encontrado.", "MGL")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of bas_demonst_ctbl_fin ***********************/
