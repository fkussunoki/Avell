/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: api_demonst_ctbl_fin
** Descricao.............: API Demonstrativo de V°deo
** Versao................:  1.00.00.011
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204zi.py
** Data Geracao..........: 14/11/2013 - 14:09:32
** Criado por............: fut12139
** Criado em.............: 23/03/2005 19:24:00
** Alterado por..........: fut35118
** Alterado em...........: 20/12/2006 13:32:25
** Gerado por............: fut41422_1
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.011":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i api_demonst_ctbl_fin MGL}
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
    field ttv_cod_unid_negoc_ini           as character format "x(3)" label "Unid Neg¢cio" column-label "Inicial"
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

def temp-table tt_prefer_demonst_ctbl no-undo
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
    index tt_prefer_demonst               
          tta_cod_demonst_ctbl             ascending
    index tt_prefer_id                     is primary unique
          tta_cod_usuario                  ascending
          tta_cod_demonst_ctbl             ascending
          tta_cod_padr_col_demonst_ctbl    ascending
    index tt_prefer_padr_col              
          tta_cod_padr_col_demonst_ctbl    ascending
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

def temp-table tt_retorno_demonst_lin no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_cod_padr_col_demonst_ctbl    as character format "x(8)" label "Padr∆o Colunas" column-label "Coluna Demonstrativo"
    field ttv_num_seq_lin                  as integer format ">>>>,>>9" label "Sequància" column-label "Sequància"
    field ttv_des_val_col                  as character format "x(80)"
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



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_num_vers_integr_api
    as integer
    format ">>>>,>>9"
    no-undo.
def Input param table 
    for tt_prefer_demonst_ctbl.
def Input param table 
    for tt_conjto_prefer_demonst.
def output param table 
    for tt_retorno_demonst.
def output param table 
    for tt_retorno_demonst_lin.
def output param table 
    for tt_erros_api_demonst_lote.


/************************* Parameter Definition End *************************/

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
def var v_hdl_demonst_ctbl_1
    as Handle
    format ">>>>>>9":U
    no-undo.
def new global shared var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_demonst_ctbl_fin}


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
    run pi_version_extract ('api_demonst_ctbl_fin':U, 'prgfin/mgl/MGLA204zi.py':U, '1.00.00.011':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'api_demonst_ctbl_fin' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'api_demonst_ctbl_fin'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */



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
    where prog_dtsul.cod_prog_dtsul = "api_demonst_ctbl_fin":U
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


if  search("prgfin/mgl/MGLA204zj.r") = ? and search("prgfin/mgl/MGLA204zj.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/MGLA204zj.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/mgl/MGLA204zj.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/mgl/MGLA204zj.py persistent set v_hdl_demonst_ctbl_1 /*prg_api_demonst_ctbl_fin_1*/.

main_block:
do on error undo main_block, leave main_block.

    for each tt_prefer_demonst_ctbl:
        create tt_prefer_demonst_ctbl_1.
        buffer-copy tt_prefer_demonst_ctbl to tt_prefer_demonst_ctbl_1.
        assign tt_prefer_demonst_ctbl_1.ttv_log_impr_col_sem_sdo = yes.
    end.

    return-value = ?.
    run pi_main_api_demonst_ctbl_fin in v_hdl_demonst_ctbl_1 (Input p_num_vers_integr_api,
                                      Input table tt_prefer_demonst_ctbl_1,
                                      Input table tt_conjto_prefer_demonst,
                                      output table tt_retorno_demonst,
                                      output table tt_retorno_demonst_lin,
                                      output table tt_erros_api_demonst_lote) /*pi_main_api_demonst_ctbl_fin*/.
end.

if VALID-HANDLE(v_hdl_demonst_ctbl_1) then
  delete procedure v_hdl_demonst_ctbl_1.


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

return return-value.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

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
/***********************  End of api_demonst_ctbl_fin ***********************/
