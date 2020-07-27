/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: api_demonst_ctbl_video
** Descricao.............: Montagem Demonstrativo de V¡deo
** Versao................:  1.00.00.098
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204za.py
** Data Geracao..........: 12/09/2014 - 17:14:13
** Criado por............: Dalpra
** Criado em.............: 24/01/2001 11:03:47
** Alterado por..........: fut41422
** Alterado em...........: 10/09/2014 15:39:32
** Gerado por............: sergio
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.098":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.098[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}

{include/cdcfgfin.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i api_demonst_ctbl_video MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def shared temp-table tt_acumul_demonst_cadastro no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont bil" column-label "Acumulador"
    field tta_log_zero_acumul_ctbl         as logical format "Sim/NÆo" initial no label "Zera Acumulador" column-label "Zera Acumulador"
    index tt_id                            is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_num_seq_demonst_ctbl         ascending
          tta_cod_acumul_ctbl              ascending
    .

def shared temp-table tt_acumul_demonst_ctbl_result no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont bil" column-label "Acumulador"
    field tta_log_zero_acumul_ctbl         as logical format "Sim/NÆo" initial no label "Zera Acumulador" column-label "Zera Acumulador"
    field ttv_val_sdo_ctbl_fim_sint_acumul as decimal format "->>,>>>,>>>,>>9.99" decimals 6
    field ttv_log_ja_procesdo              as logical format "Sim/NÆo" initial no
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    index tt_id                            is primary unique
          tta_cod_acumul_ctbl              ascending
          tta_cod_col_demonst_ctbl         ascending
          tta_num_seq_demonst_ctbl         ascending
    .

def shared temp-table tt_ccustos_demonst no-undo
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

def shared temp-table tt_col_demonst_ctbl no-undo like col_demonst_ctbl
    field ttv_rec_col_demonst_ctbl         as recid format ">>>>>>9"
    .

def temp-table tt_col_demonst_ctbl_ext no-undo
    field ttv_cod_padr_col_demonst         as character format "x(8)" label "PadrÆo Coluna"
    field ttv_cod_moed_finalid             as character format "x(10)" label "Moeda/Finalidade" column-label "Mo/Finalid"
    field ttv_num_conjto_param_ctbl        as integer format ">9" initial 0
    .

def shared temp-table tt_compos_demonst_cadastro no-undo like compos_demonst_ctbl
    field tta_cod_proj_financ_excec        as character format "x(20)" label "Projeto Exce‡Æo" column-label "Projeto Exce‡Æo"
    field tta_cod_proj_financ_inicial      as character format "x(20)" label "Projeto Financ Inic" column-label "Projeto Financ Inic"
    index tt_id                           
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    .

def shared temp-table tt_controla_analise_vertical no-undo
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont bil" column-label "Acumulador"
    field ttv_cod_linha                    as character format "x(730)"
    field ttv_val_sdo_ctbl_analis_vert     as decimal format "->>,>>>,>>>,>>9.99" decimals 6
    index tt_id                            is primary unique
          tta_cod_col_demonst_ctbl         ascending
          tta_cod_acumul_ctbl              ascending
          ttv_cod_linha                    ascending
    .

def shared temp-table tt_cta_ctbl_demonst no-undo
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field ttv_cod_cta_ctbl_pai             as character format "x(20)" label "Conta Ctbl Pai" column-label "Conta Ctbl Pai"
    field ttv_log_consid_apurac            as logical format "Sim/NÆo" initial no
    field tta_ind_espec_cta_ctbl           as character format "X(10)" initial "Anal¡tica" label "Esp‚cie Conta" column-label "Esp‚cie"
    index tt_cod_cta_ctbl_pai             
          tta_cod_plano_cta_ctbl           ascending
          ttv_cod_cta_ctbl_pai             ascending
    index tt_select_id                     is primary unique
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    .

def temp-table tt_estrut_unid_organ no-undo like emsuni.estrut_unid_organ
    field tta_cod_unid_organ_pai           as character format "x(3)" label "Unidade Organiz Pai" column-label "UO Pai"
    field tta_cod_unid_organ_filho         as character format "x(3)" label "Unid Organiz Filho" column-label "Unid Organiz Filho"
    field tta_num_seq_estrut_unid_organ    as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_dat_inic_valid               as date format "99/99/9999" initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF label "In¡cio Validade" column-label "Inic Validade"
    field tta_dat_fim_valid                as date format "99/99/9999" initial 12/31/9999 label "Fim Validade" column-label "Fim Validade"
    field ttv_rec_unid_organ               as recid format ">>>>>>9" initial ?
    field ttv_cod_order                    as character format "x(40)"
    field ttv_log_finalid_unid_organ       as logical format "Sim/NÆo" initial no label "Inclui Finalidade" column-label "Inclui Finalidade"
    field ttv_log_unid_organ_rel           as logical format "Sim/NÆo" initial no
    field ttv_des_unid_organ               as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo"
    field ttv_des_estrut_unid_organ        as character format "x(70)" label "Unid Organ" column-label "Unid Organ"
    field tta_cod_tip_unid_organ           as character format "x(3)" label "Tipo Unidade Organiz" column-label "Tipo UO"
    field tta_cdn_seq_estrut_organ         as Integer format ">>>,>>9" initial 0 label "Cod Seq Estrut Organ" column-label "Seq Est Org"
    index tt_cdn_seq                      
          tta_cdn_seq_estrut_organ         ascending
    index tt_estrut                       
          tta_cod_unid_organ_pai           ascending
          tta_num_seq_estrut_unid_organ    ascending
    .

def shared temp-table tt_estrut_visualiz_ctbl_cad no-undo like estrut_visualiz_ctbl
    .

def temp-table tt_exec_rpc no-undo
    field ttv_cod_aplicat_dtsul_corren     as character format "x(3)"
    field ttv_cod_ccusto_corren            as character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_cod_dwb_user                 as character format "x(21)" label "Usu rio" column-label "Usu rio"
    field ttv_cod_empres_usuar             as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_usuar              as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_funcao_negoc_empres      as character format "x(50)"
    field ttv_cod_grp_usuar_lst            as character format "x(3)" label "Grupo Usu rios" column-label "Grupo"
    field ttv_cod_idiom_usuar              as character format "x(8)" label "Idioma" column-label "Idioma"
    field ttv_cod_modul_dtsul_corren       as character format "x(3)" label "M¢dulo Corrente" column-label "M¢dulo Corrente"
    field ttv_cod_modul_dtsul_empres       as character format "x(100)"
    field ttv_cod_pais_empres_usuar        as character format "x(3)" label "Pa¡s Empresa Usu rio" column-label "Pa¡s"
    field ttv_cod_plano_ccusto_corren      as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_unid_negoc_usuar         as character format "x(3)" label "Unidade Neg¢cio" column-label "Unid Neg¢cio"
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
    field ttv_cod_usuar_corren_criptog     as character format "x(16)"
    field ttv_num_ped_exec_corren          as integer format ">>>>9"
    field ttv_cod_livre                    as character format "x(2000)"
    .

def shared temp-table tt_grp_col_demonst_video no-undo
    field tta_qtd_period_relac_base        as decimal format ">9" initial 0 label "Per¡odos da Base" column-label "Per¡odo da Base"
    field tta_qtd_exerc_relac_base         as decimal format ">9" initial 0 label "Exerc¡cios da Base" column-label "Exerc¡cios da Base"
    field tta_ind_tip_relac_base           as character format "X(20)" label "Tipo Rela‡Æo" column-label "Tipo Rela‡Æo"
    field tta_num_conjto_param_ctbl        as integer format ">9" initial 1 label "Conjunto Parƒmetros" column-label "Conjunto Parƒmetros"
    field tta_ind_tip_val_consolid         as character format "X(18)" initial "Total" label "Tipo Valor Consolid" column-label "Tipo Valor Consolid"
    field ttv_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field ttv_val_cotac_indic_econ         as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_cod_cta_ctbl_fim             as character format "x(20)" label "Conta Final" column-label "Final"
    field ttv_cod_cta_ctbl_ini             as character format "x(20)" label "Conta Inicial" column-label "Inicial"
    field ttv_cod_cta_prefer_excec         as character format "x(20)" initial "####################" label "Exce‡Æo" column-label "Exce‡Æo"
    field ttv_cod_cta_prefer_pfixa         as character format "x(20)" label "Parte Fixa" column-label "Parte Fixa"
    field ttv_cod_unid_negoc_fim           as character format "x(3)" label "at‚" column-label "Final"
    field ttv_cod_unid_negoc_ini           as character format "x(3)" label "Unid Neg¢cio" column-label "Inicial"
    field ttv_cod_estab_fim                as character format "x(3)" label "at‚" column-label "Estab Final"
    field ttv_cod_estab_inic               as character format "x(3)" label "Estab Inicial" column-label "Estab Inicial"
    field ttv_cod_unid_organ_prefer        as character format "x(3)"
    field ttv_num_period                   as integer format ">>>>,>>9" label "Per¡odo Cont bil" column-label "Per¡odo Cont bil"
    field ttv_cod_unid_organ_prefer_inic   as character format "x(3)"
    field ttv_cod_unid_organ_prefer_fim    as character format "x(3)"
    field ttv_cod_unid_organ_fim           as character format "x(3)" label "Final" column-label "Unid Organizacional"
    field ttv_cod_unid_organ_ini           as character format "x(3)" label "UO Inicial" column-label "Unid Organizacional"
    field ttv_cod_cenar_orctario           as character format "x(8)" label "Cenar Orctario" column-label "Cen rio Or‡ament rio"
    field ttv_cod_vers_orcto_ctbl          as character format "x(10)" label "VersÆo Or‡amento" column-label "VersÆo Or‡amento"
    field ttv_cod_finalid_econ             as character format "x(10)" label "Finalidade Econ“mica" column-label "Finalidade Econ“mica"
    field ttv_dat_fim_period               as date format "99/99/9999" label "Fim Per¡odo"
    field ttv_cod_plano_ccusto             as character format "x(8)" label "Plano CCusto" column-label "Plano CCusto"
    field ttv_cod_ccusto_inic              as character format "x(11)" label "C.Custo Inicial" column-label "C.Custo Inicial"
    field ttv_cod_ccusto_fim               as Character format "x(11)" label "at‚" column-label "Centro Custo"
    field ttv_cod_ccusto_prefer_pfixa      as character format "x(11)" label "Parte Fixa"
    field ttv_cod_ccusto_prefer_excec      as character format "x(11)" label "Exce‡Æo"
    field ttv_cod_proj_financ_inic         as character format "x(20)" label "Projeto Inicial"
    field ttv_cod_proj_financ_fim          as character format "x(20)" label "Projeto Final" column-label "Projeto"
    field ttv_cod_proj_financ_prefer_pfixa as character format "x(20)" label "Parte Fixa"
    field ttv_cod_proj_financ_prefer_excec as character format "x(20)" label "Exce‡Æo"
    field tta_cod_unid_orctaria            as character format "x(8)" label "Unid Or‡ament ria" column-label "Unid Or‡ament ria"
    field tta_num_seq_orcto_ctbl           as integer format ">>>>>>>>9" initial 0 label "Seq Orcto Cont bil" column-label "Seq Orcto Cont bil"
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

def temp-table tt_input_leitura_sdo_demonst no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending
    .

def temp-table tt_input_sdo no-undo
    field tta_cod_unid_organ_inic          as character format "x(3)" label "UO Inicial" column-label "UO Unicial"
    field tta_cod_unid_organ_fim           as character format "x(3)" label "UO Final" column-label "UO FInal"
    field ttv_cod_unid_organ_orig_ini      as character format "x(3)" label "UO Origem" column-label "UO Origem"
    field ttv_cod_unid_organ_orig_fim      as character format "x(3)" label "UO Origem" column-label "UO Origem"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl_inic            as character format "x(20)" label "Conta Contabil" column-label "Conta Contab Inicial"
    field tta_cod_cta_ctbl_fim             as character format "x(20)" label "at‚" column-label "Conta Cont bil Final"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_inic              as Character format "x(11)" label "Centro Custo" column-label "Centro Custo Inicial"
    field tta_cod_ccusto_fim               as Character format "x(11)" label "at‚" column-label "Centro Custo Final"
    field tta_cod_proj_financ_inic         as character format "x(8)" label "NÆo Utilizar..." column-label "Projeto"
    field tta_cod_proj_financ_fim          as character format "x(20)" label "Projeto Final" column-label "Projeto Final"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_cod_estab_inic               as character format "x(3)" label "Estabelecimento" column-label "Estab Inicial"
    field tta_cod_estab_fim                as character format "x(3)" label "at‚" column-label "Estabel Final"
    field tta_cod_unid_negoc_inic          as character format "x(3)" label "Unid Negoc" column-label "UN Inicial"
    field tta_cod_unid_negoc_fim           as character format "x(3)" label "at‚" column-label "UN Final"
    field ttv_ind_espec_sdo_tot            as character format "X(15)"
    field ttv_log_consid_apurac_restdo     as logical format "Sim/NÆo" initial yes label "Consid Apurac Restdo" column-label "Apurac Restdo"
    field ttv_cod_elimina_intercomp        as character format "x(20)"
    field ttv_log_espec_sdo_ccusto         as logical format "Sim/NÆo" initial no
    field ttv_log_restric_estab            as logical format "Sim/NÆo" initial no label "Usa Segur Estab" column-label "Usa Segur Estab"
    field ttv_ind_espec_cta                as character format "X(10)"
    field ttv_cod_leitura                  as character format "x(8)"
    field ttv_cod_condicao                 as character format "x(20)"
    field ttv_cod_cenar_orctario           as character format "x(8)" label "Cenar Orctario" column-label "Cen rio Or‡ament rio"
    field ttv_cod_unid_orctaria            as character format "x(8)" label "Unid Or‡ament ria" column-label "Unid Or‡ament ria"
    field ttv_num_seq_orcto_ctbl           as integer format ">>>>>>>>9" label "Seq Orcto Cont bil" column-label "Seq Orcto Cont bil"
    field ttv_cod_vers_orcto_ctbl          as character format "x(10)" label "VersÆo Or‡amento" column-label "VersÆo Or‡amento"
    field ttv_cod_cta_ctbl_pfixa           as character format "x(20)" label "Parte Fixa" column-label "Parte Fixa Cta Ctbl"
    field ttv_cod_ccusto_pfixa             as character format "x(11)" label "Parte Fixa CCusto" column-label "Parte Fixa CCusto"
    field ttv_cod_proj_financ_pfixa        as character format "x(20)" label "Parte Fixa"
    field ttv_cod_cta_ctbl_excec           as character format "x(20)" initial "...................." label "Parte Exce‡Æo" column-label "Parte Exce‡Æo"
    field ttv_cod_ccusto_excec             as character format "x(11)" initial "..........." label "Parte Exce‡Æo" column-label "Parte Exce‡Æo"
    field ttv_cod_proj_financ_excec        as character format "x(20)" initial "...................." label "Exce‡Æo" column-label "Exce‡Æo"
    field ttv_num_seq_demonst_ctbl         as integer format ">>>,>>9" label "Sequˆncia" column-label "Sequˆncia"
    field ttv_num_seq_compos_demonst       as integer format ">>>>,>>9"
    field ttv_cod_chave                    as character format "x(40)"
    field ttv_cod_seq                      as character format "x(200)"
    field ttv_cod_dat_sdo_ctbl_inic        as character format "x(200)"
    field ttv_cod_dat_sdo_ctbl_fim         as character format "x(200)"
    field ttv_cod_exerc_ctbl               as character format "9999" label "Exerc¡cio Cont bil" column-label "Exerc¡cio Cont bil"
    field ttv_cod_period_ctbl              as character format "x(08)" label "Per¡odo Cont bil" column-label "Per¡odo Cont bil"
    .

def shared temp-table tt_item_demonst_ctbl_cadastro no-undo like item_demonst_ctbl
    field ttv_log_ja_procesdo              as logical format "Sim/NÆo" initial no
    field ttv_rec_item_demonst_ctbl_cad    as recid format ">>>>>>9"
    index tt_id                            is primary unique
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    index tt_recid                        
          ttv_rec_item_demonst_ctbl_cad    ascending
    .

def shared temp-table tt_item_demonst_ctbl_video no-undo
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
    field tta_des_tit_ctbl                 as character format "x(40)" label "T¡tulo Cont bil" column-label "T¡tulo Cont bil"
    field ttv_des_valpres                  as character format "x(40)"
    field ttv_log_tit_ctbl_vld             as logical format "Sim/NÆo" initial no
    field tta_ind_funcao_col_demonst_ctbl  as character format "X(12)" initial "ImpressÆo" label "Fun‡Æo Coluna" column-label "Fun‡Æo Coluna"
    field tta_ind_orig_val_col_demonst     as character format "X(12)" initial "T¡tulo" label "Origem Valores" column-label "Origem Valores"
    field tta_cod_format_col_demonst_ctbl  as character format "x(40)" label "Formato Coluna" column-label "Formato Coluna"
    field ttv_cod_identif_campo            as character format "x(40)"
    field ttv_log_cta_sint                 as logical format "Sim/NÆo" initial no
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

def shared temp-table tt_label_demonst_ctbl_video no-undo
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_num_pos_col_demonst_ctbl     as integer format ">>>>,>>9" label "N£mero Posi‡äes Col"
    field ttv_cod_format_col_demonst_ctbl  as character format "x(40)" label "Formato Coluna" column-label "Formato Coluna"
    field ttv_des_label_col_demonst_ctbl   as character format "x(40)"
    field tta_ind_orig_val_col_demonst     as character format "X(12)" initial "T¡tulo" label "Origem Valores" column-label "Origem Valores"
    index tt_label_demonst                 is primary unique
          tta_num_seq_demonst_ctbl         ascending
    .

def temp-table tt_lista_cta_restric no-undo
    field ttv_rec_ret_sdo_ctbl_pai         as recid format ">>>>>>9"
    field ttv_rec_ret_sdo_ctbl_filho       as recid format ">>>>>>9"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

def shared temp-table tt_proj_financ_demonst no-undo
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

def shared temp-table tt_relacto_item_retorna no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
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

def shared temp-table tt_relacto_item_retorna_cons no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field ttv_rec_ret_orig                 as recid format ">>>>>>9"
    field ttv_rec_ret_dest                 as recid format ">>>>>>9"
    index tt_id                           
          tta_num_seq                      ascending
          ttv_rec_ret_orig                 ascending
          ttv_rec_ret_dest                 ascending
    index tt_recid_item                   
          ttv_rec_ret_orig                 ascending
    .

def shared temp-table tt_rel_grp_col_compos_demonst no-undo
    field ttv_num_seq_sdo                  as integer format ">>>>,>>9"
    field ttv_rec_grp_col_demonst_ctbl     as recid format ">>>>>>9"
    field ttv_rec_compos_demonst_ctbl      as recid format ">>>>>>9" initial ?
    index tt_id                            is primary
          ttv_rec_grp_col_demonst_ctbl     ascending
    index tt_id_2                         
          ttv_num_seq_sdo                  ascending
    .

def shared temp-table tt_retorna_sdo_ctbl_demonst no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont bil" column-label "Data Saldo Cont bil"
    field tta_cod_unid_organ_orig          as character format "x(3)" label "UO Origem" column-label "UO Origem"
    field ttv_ind_espec_sdo                as character format "X(20)"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D‚bito" column-label "Movto D‚bito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr‚dito" column-label "Movto Cr‚dito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont bil Final" column-label "Saldo Cont bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Resultado" column-label "Apura‡Æo Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Restdo DB" column-label "Apura‡Æo Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Restdo CR" column-label "Apura‡Æo Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field ttv_qtd_movto_ctbl               as decimal format "->>>>,>>9.9999" decimals 4
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Or‡ado" column-label "Valor Or‡ado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Or‡ado" column-label "Saldo Or‡ado"
    field tta_qtd_orcado                   as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtdade Or‡ada" column-label "Qtdade Or‡ada"
    field tta_qtd_orcado_sdo               as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Saldo Quantidade" column-label "Saldo Quantidade"
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field ttv_log_sdo_orcado_sint          as logical format "Sim/NÆo" initial no
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

def shared temp-table tt_retorna_sdo_orcto_ccusto no-undo
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Or‡ado" column-label "Valor Or‡ado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Or‡ado" column-label "Saldo Or‡ado"
    field tta_qtd_orcado                   as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtdade Or‡ada" column-label "Qtdade Or‡ada"
    field tta_qtd_orcado_sdo               as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Saldo Quantidade" column-label "Saldo Quantidade"
    index tt_id                            is primary unique
          ttv_rec_ret_sdo_ctbl             ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    .

def shared temp-table tt_unid_negocio no-undo
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_cod_unid_negoc_pai           as character format "x(3)" label "Un Neg Pai" column-label "Un Neg Pai"
    field ttv_log_proces                   as logical format "Sim/Nao" initial no label "&prc(" column-label "&prc("
    field ttv_ind_espec_unid_negoc         as character format "X(10)" label "Esp‚cie UN" column-label "Esp‚cie UN"
    index tt_cod_unid_negoc_pai           
          ttv_cod_unid_negoc_pai           ascending
    index tt_log_proces                   
          ttv_log_proces                   ascending
    index tt_select_id                     is primary unique
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_unid_orctaria no-undo
    field tta_cod_unid_orctaria            as character format "x(8)" label "Unid Or‡ament ria" column-label "Unid Or‡ament ria"
    .

def shared temp-table tt_valor_demonst_ctbl_video no-undo
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

/************************ Parameter Definition Begin ************************/

def Input param p_num_vers_integr_api
    as integer
    format ">>>>,>>9"
    no-undo.
def Input param table 
    for tt_exec_rpc.
def output param p_des_lista_estab
    as character
    format "x(2000)"
    no-undo.
def output param table 
    for tt_log_erros.


/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_compos_demonst_cadastro
    for tt_compos_demonst_cadastro.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer btt_compos_demonst_cadastro_2
    for tt_compos_demonst_cadastro.
&endif
def buffer btt_cta_ctbl_demonst
    for tt_cta_ctbl_demonst.
def buffer btt_grp_col_demonst_video
    for tt_grp_col_demonst_video.
def buffer btt_input_sdo
    for tt_input_sdo.
def buffer btt_item_demonst_ctbl_video
    for tt_item_demonst_ctbl_video.
def buffer btt_relacto_item_retorna
    for tt_relacto_item_retorna.
def buffer btt_retorna_sdo_ctbl_demonst
    for tt_retorna_sdo_ctbl_demonst.
def buffer btt_retorna_sdo_orcto_ccusto
    for tt_retorna_sdo_orcto_ccusto.
def buffer btt_valor_demonst_ctbl_video
    for tt_valor_demonst_ctbl_video.
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_empresa
    for emsuni.empresa.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_prefer_demonst_ctbl
    for prefer_demonst_ctbl.
&endif
&if "{&emsfin_version}" >= "5.05" &then
def buffer b_unid_orctaria_enter
    for unid_orctaria.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cdn_tot_ccusto_excec
    as Integer
    format ">>>,>>9":U
    no-undo.
def var v_cdn_tot_con_excec
    as Integer
    format ">>>,>>9":U
    no-undo.
def var v_cdn_tot_proj_excec
    as Integer
    format ">>>,>>9":U
    no-undo.
def var v_cod_1
    as character
    format "x(15)":U
    no-undo.
def var v_cod_2
    as character
    format "x(15)":U
    no-undo.
def var v_cod_3
    as character
    format "x(15)":U
    no-undo.
def var v_cod_4
    as character
    format "x(15)":U
    no-undo.
def var v_cod_5
    as character
    format "x(15)":U
    no-undo.
def var v_cod_6
    as character
    format "x(15)":U
    no-undo.
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
def new global shared var v_cod_ccusto_exec_subst
    as character
    format "x(11)":U
    label "Subst PExec"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def new global shared var v_cod_ccusto_fim
    as Character
    format "x(11)":U
    initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
    label "at‚"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_ccusto_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
    label "at‚"
    column-label "CCusto"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def new global shared var v_cod_ccusto_ini
    as Character
    format "x(11)":U
    label "CCusto Inicial"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_ccusto_ini
    as character
    format "x(20)":U
    label "CCusto Inicial"
    column-label "CCusto"
    no-undo.
&ENDIF
def new global shared var v_cod_ccusto_pfixa_subst
    as character
    format "x(11)":U
    label "Subst Parte Fixa"
    no-undo.
def var v_cod_ccusto_prefer_excec
    as character
    format "x(11)":U
    label "Exce‡Æo"
    no-undo.
def var v_cod_ccusto_prefer_pfixa
    as character
    format "x(11)":U
    label "Parte Fixa"
    no-undo.
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
def var v_cod_cta_ctbl_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    column-label "Parte Fixa Cta Ctbl"
    no-undo.
def var v_cod_cta_prefer_excec
    as character
    format "x(20)":U
    initial "####################"
    label "Exce‡Æo"
    column-label "Exce‡Æo"
    no-undo.
def var v_cod_cta_prefer_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    column-label "Parte Fixa"
    no-undo.
def var v_cod_c_1
    as character
    format "x(12)":U
    no-undo.
def var v_cod_c_2
    as character
    format "x(12)":U
    no-undo.
def var v_cod_c_3
    as character
    format "x(12)":U
    no-undo.
def var v_cod_c_4
    as character
    format "x(12)":U
    no-undo.
def var v_cod_c_5
    as character
    format "x(12)":U
    no-undo.
def var v_cod_c_6
    as character
    format "x(12)":U
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
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def var v_cod_empresa
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "at‚"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "at‚"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab_ini
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab_ini
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
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
    label "Formato Cta Cont bil"
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
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
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
    label "PadrÆo Colunas"
    column-label "PadrÆo Colunas"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_plano_ccusto_sub
    as character
    format "x(8)":U
    label "Plano Centros Custo"
    column-label "Plano Centros Custo"
    no-undo.
def var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
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
def var v_cod_proj_financ_excec
    as character
    format "x(20)":U
    initial "...................."
    label "Exce‡Æo"
    column-label "Exce‡Æo"
    no-undo.
def var v_cod_proj_financ_excec_prefer
    as character
    format "x(8)":U
    no-undo.
def var v_cod_proj_financ_exec
    as character
    format "x(20)":U
    no-undo.
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
def var v_cod_proj_financ_inic
    as character
    format "x(20)":U
    label "Projeto Inicial"
    no-undo.
def var v_cod_proj_financ_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    no-undo.
def var v_cod_proj_financ_prefer_excec
    as character
    format "x(20)":U
    label "Exce‡Æo"
    no-undo.
def var v_cod_proj_financ_prefer_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    no-undo.
def var v_cod_ult_obj_procesdo
    as character
    format "x(32)":U
    no-undo.
def var v_cod_unid_negoc_1
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Un Neg"
    no-undo.
def var v_cod_unid_negoc_2
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Un Neg"
    no-undo.
def var v_cod_unid_negoc_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "at‚"
    column-label "Final"
    no-undo.
def var v_cod_unid_negoc_ini
    as character
    format "x(3)":U
    label "Unid Neg¢cio"
    column-label "Inicial"
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
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_unid_organ
    as character
    format "x(3)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_unid_organ
    as Character
    format "x(5)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
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
def new global shared var v_cod_unid_organ_sub
    as character
    format "x(3)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_unid_organ_sub
    as Character
    format "x(5)":U
    label "Unid Organizacional"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_dat_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "at‚"
    column-label "Final"
    no-undo.
def new global shared var v_dat_fim_period_ctbl
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Fim"
    column-label "Fim"
    no-undo.
def var v_dat_fim_valid
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Fim Validade"
    no-undo.
def var v_dat_inic_valid
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "In¡cio Validade"
    column-label "Inicio Validade"
    no-undo.
def var v_des_formul
    as character
    format "x(80)":U
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
def var v_des_tit_ctbl
    as character
    format "x(40)":U
    label "T¡tulo Cont bil"
    column-label "T¡tulo Cont bil"
    no-undo.
def var v_des_tit_idiom
    as character
    format "x(40)":U
    no-undo.
def var v_des_valpres
    as character
    format "x(40)":U
    no-undo.
def var v_des_visualiz
    as character
    format "x(80)":U
    no-undo.
def new global shared var v_hdl_func_padr_glob
    as Handle
    format ">>>>>>9":U
    label "Fun‡äes Pad Glob"
    column-label "Fun‡äes Pad Glob"
    no-undo.
def var v_ind_espec_unid_orctaria
    as character
    format "X(10)":U
    initial "Anal¡tica" /*l_analitica*/
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Anal¡tica","Anal¡tica","Sint‚tica","Sint‚tica"
    &else
    list-items "Anal¡tica","Sint‚tica"
    &endif
     /*l_analitica*/ /*l_sintetica*/
    inner-lines 5
    bgcolor 15 font 2
    label "Esp‚cie UO"
    column-label "Esp‚cie"
    no-undo.
def var v_ind_funcao_col_demonst_ctbl
    as character
    format "X(12)":U
    initial "Todas" /*l_todas*/
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Todas","Todas","ImpressÆo","ImpressÆo","Base C lculo","Base C lculo"
    &else
    list-items "Todas","ImpressÆo","Base C lculo"
    &endif
     /*l_todas*/ /*l_impressao*/ /*l_base_calculo*/
    inner-lines 4
    bgcolor 15 font 2
    label "Fun‡Æo Coluna"
    column-label "Fun‡Æo Coluna"
    no-undo.
def var v_ind_operac_formul
    as character
    format "X(08)":U
    no-undo.
def var v_ind_orig_val_col_demonst
    as character
    format "X(12)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "T¡tulo","T¡tulo","F¢rmula","F¢rmula","Cont bil","Cont bil","Or‡amento","Or‡amento","Concorrente","Concorrente","Consolida‡Æo","Consolida‡Æo"
    &else
    list-items "T¡tulo","F¢rmula","Cont bil","Or‡amento","Concorrente","Consolida‡Æo"
    &endif
     /*l_titulo*/ /*l_formula*/ /*l_contabil*/ /*l_orcamento*/ /*l_concorrente*/ /*l_consolidacao*/
    inner-lines 7
    bgcolor 15 font 2
    label "Origem Valores"
    column-label "Origem Valores"
    no-undo.
def var v_ind_tip_operac_formul
    as character
    format "X(08)":U
    no-undo.
def var v_ind_tip_relacto
    as character
    format "X(15)":U
    label "Tipo Relacionamento"
    column-label "Tipo Relac"
    no-undo.
def new global shared var v_log_abert_ccusto
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Abrir por CCusto"
    column-label "Abrir por CCusto"
    no-undo.
def var v_log_achou
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_busca_val_empenh
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def new global shared var v_log_ccusto_subst
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Subst Ccusto"
    column-label "Subst Ccusto"
    no-undo.
def var v_log_consid_apurac_restdo
    as logical
    format "Sim/NÆo"
    initial yes
    view-as toggle-box
    label "Consid Apurac Restdo"
    column-label "Apurac Restdo"
    no-undo.
def new global shared var v_log_consolid_recur
    as logical
    format "Sim/NÆo"
    initial NO
    view-as toggle-box
    label "Consolida‡Æo Recurs"
    column-label "Consolid Recurv"
    no-undo.
def var v_log_descta
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def new global shared var v_log_eai_habilit
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def new global shared var v_log_estab_subst
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Subst Estab"
    column-label "Subst Estab"
    no-undo.
def var v_log_funcao_concil_consolid
    as logical
    format "Sim/NÆo"
    initial NO
    no-undo.
def var v_log_funcao_impr_col_sem_sdo
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_funcao_tratam_dec
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_gera_dados_xml
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Gera Dados XML"
    column-label "Gera Dados XML"
    no-undo.
def var v_log_impr_cta_sem_sdo
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_mostrar_msg_erro
    as logical
    format "Sim/NÆo"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_nao_cria_tt_input_sdo
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_orcto_cta_sint
    as logical
    format "Sim/NÆo"
    initial NO
    no-undo.
def var v_log_period_balan_geren
    as logical
    format "Sim/NÆo"
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
def var v_log_restric_estab
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Usa Segur Estab"
    column-label "Usa Segur Estab"
    no-undo.
def var v_log_retorno
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def var v_log_save
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_tit_demonst
    as logical
    format "Sim/NÆo"
    initial no
    no-undo.
def new global shared var v_log_unid_negoc_subst
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Subst Un Neg"
    column-label "Subst Un Neg"
    no-undo.
def new global shared var v_log_unid_organ_subst
    as logical
    format "Sim/NÆo"
    initial no
    view-as toggle-box
    label "Subst UO"
    column-label "Subst UO"
    no-undo.
def new global shared var v_nom_prog
    as character
    format "x(8)":U
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
def var v_num_col_aux_4
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_cont
    as integer
    format ">,>>9":U
    initial 0
    no-undo.
def var v_num_contador
    as integer
    format ">>>>,>>9":U
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
def var v_num_exerc_ctbl
    as integer
    format "->,>>9":U
    label "Exerc¡cio Atual"
    no-undo.
def var v_num_mes
    as integer
    format "99":U
    initial 01
    no-undo.
def var v_num_niv_unid_organ
    as integer
    format ">>>>,>>9":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_period_ctbl
    as integer
    format ">99":U
    initial 01
    label "Per¡odo Atual"
    column-label "Period"
    no-undo.
def var v_num_posicao
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_seq
    as integer
    format ">>>,>>9":U
    label "Seqˆncia"
    column-label "Seq"
    no-undo.
def var v_num_soma
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_ult_dia_mes
    as integer
    format ">>>>,>>9":U
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
    label "Qtdade Or‡ada"
    column-label "Qtdade Or‡ada"
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
def new global shared var v_rec_demonst_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_apurac_restdo_505
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Apura‡Æo Resultado"
    column-label "Apura‡Æo Resultado"
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
    label "Apura‡Æo Restdo CR"
    column-label "Apura‡Æo Restdo CR"
    no-undo.
def var v_val_apurac_restdo_db_505
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Apura‡Æo Restdo DB"
    column-label "Apura‡Æo Restdo DB"
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
def var v_val_cotac_indic_econ
    as decimal
    format "->>,>>>,>>>,>>9.9999999999":U
    decimals 10
    label "Cota‡Æo"
    column-label "Cota‡Æo"
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
    label "Valor Or‡ado"
    column-label "Valor Or‡ado"
    no-undo.
def var v_val_orcado_sdo
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Or‡ado Acumulado"
    column-label "Or‡ado Acumulado"
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
def var v_val_sdo_ctbl_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Cont bil"
    column-label "Saldo Cont bil"
    no-undo.
def var v_val_sdo_ctbl_cr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Cr‚ditos"
    column-label "Cr‚ditos"
    no-undo.
def var v_val_sdo_ctbl_db
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "D‚bitos"
    column-label "D‚bitos"
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
def var v_cod_carac_lim                  as character       no-undo. /*local*/
def var v_cod_ccusto                     as character       no-undo. /*local*/
def var v_cod_ccusto_ant                 as character       no-undo. /*local*/
def var v_cod_ccusto_exec                as character       no-undo. /*local*/
def var v_cod_ccusto_pesq                as character       no-undo. /*local*/
def var v_cod_ccusto_pfixa               as character       no-undo. /*local*/
def var v_cod_ccusto_sdo_fim             as character       no-undo. /*local*/
def var v_cod_ccusto_sdo_inic            as character       no-undo. /*local*/
def var v_cod_ccusto_valid               as character       no-undo. /*local*/
def var v_cod_cenar_ctbl_2               as character       no-undo. /*local*/
def var v_cod_chave                      as character       no-undo. /*local*/
def var v_cod_chave_tot                  as character       no-undo. /*local*/
def var v_cod_col_base                   as character       no-undo. /*local*/
def var v_cod_col_idx                    as character       no-undo. /*local*/
def var v_cod_cta_ctbl                   as character       no-undo. /*local*/
def var v_cod_cta_ctbl_ant               as character       no-undo. /*local*/
def var v_cod_cta_ctbl_exec              as character       no-undo. /*local*/
def var v_cod_cta_ctbl_pesq              as character       no-undo. /*local*/
def var v_cod_cta_ctbl_valid             as character       no-undo. /*local*/
def var v_cod_estab                      as character       no-undo. /*local*/
def var v_cod_estab_valid                as character       no-undo. /*local*/
def var v_cod_estrut                     as character       no-undo. /*local*/
def var v_cod_estrut_descr               as character       no-undo. /*local*/
def var v_cod_estrut_tot                 as character       no-undo. /*local*/
def var v_cod_estrut_visualiz            as character       no-undo. /*local*/
def var v_cod_final                      as character       no-undo. /*local*/
def var v_cod_format_ccusto              as character       no-undo. /*local*/
def var v_cod_initial                    as character       no-undo. /*local*/
def var v_cod_ord_col_demonst            as character       no-undo. /*local*/
def var v_cod_ord_col_demonst_aux        as character       no-undo. /*local*/
def var v_cod_plano_ccusto               as character       no-undo. /*local*/
def var v_cod_proj_financ_ant            as character       no-undo. /*local*/
def var v_cod_unid                       as character       no-undo. /*local*/
def var v_cod_unid_negoc                 as character       no-undo. /*local*/
def var v_cod_unid_negoc_valid           as character       no-undo. /*local*/
def var v_cod_unid_organ_inic            as character       no-undo. /*local*/
def var v_cod_unid_organ_orig            as character       no-undo. /*local*/
def var v_cod_usuar_corren_aux           as character       no-undo. /*local*/
def var v_des_col_aux                    as character       no-undo. /*local*/
def var v_des_valpres_aux                as character       no-undo. /*local*/
def var v_des_val_col                    as character       no-undo. /*local*/
def var v_ind_espec_cta                  as character       no-undo. /*local*/
def var v_ind_espec_cta_pesq             as character       no-undo. /*local*/
def var v_log_acumul_demonst             as logical         no-undo. /*local*/
def var v_log_ccusto_sumar               as logical         no-undo. /*local*/
def var v_log_consid_sdo_zero            as logical         no-undo. /*local*/
def var v_log_cta_ctbl_sint              as logical         no-undo. /*local*/
def var v_log_cta_ctbl_sumar             as logical         no-undo. /*local*/
def var v_log_elimina_intercomp          as logical         no-undo. /*local*/
def var v_log_espec_sdo_ccusto           as logical         no-undo. /*local*/
def var v_log_estab_sumar                as logical         no-undo. /*local*/
def var v_log_faixa_uo                   as logical         no-undo. /*local*/
def var v_log_final_proces               as logical         no-undo. /*local*/
def var v_log_primei_compos_demonst      as logical         no-undo. /*local*/
def var v_log_proj_subst                 as logical         no-undo. /*local*/
def var v_log_proj_sumar                 as logical         no-undo. /*local*/
def var v_log_return                     as logical         no-undo. /*local*/
def var v_log_sped                       as logical         no-undo. /*local*/
def var v_log_unid_negoc                 as logical         no-undo. /*local*/
def var v_log_unid_negoc_sumar           as logical         no-undo. /*local*/
def var v_log_unid_organ_sumar           as logical         no-undo. /*local*/
def var v_num_chave                      as integer         no-undo. /*local*/
def var v_num_col                        as integer         no-undo. /*local*/
def var v_num_col_aux                    as integer         no-undo. /*local*/
def var v_num_col_aux_1                  as integer         no-undo. /*local*/
def var v_num_col_aux_2                  as integer         no-undo. /*local*/
def var v_num_col_aux_3                  as integer         no-undo. /*local*/
def var v_num_cont_tt_eai                as integer         no-undo. /*local*/
def var v_num_entry                      as integer         no-undo. /*local*/
def var v_num_format_ccusto              as integer         no-undo. /*local*/
def var v_num_format_ccusto_compos       as integer         no-undo. /*local*/
def var v_num_format_col                 as integer         no-undo. /*local*/
def var v_num_format_cta_ctbl            as integer         no-undo. /*local*/
def var v_num_format_proj_financ         as integer         no-undo. /*local*/
def var v_num_item                       as integer         no-undo. /*local*/
def var v_num_seq_sdo                    as integer         no-undo. /*local*/
def var v_qtd_col                        as decimal         no-undo. /*local*/
def var v_val_analis_vert                as decimal         no-undo. /*local*/
def var v_val_cr                         as decimal         no-undo. /*local*/
def var v_val_db                         as decimal         no-undo. /*local*/
def var v_val_empenh                     as decimal         no-undo. /*local*/
def var v_val_sdo_base                   as decimal         no-undo. /*local*/
def var v_val_sdo_ctbl                   as decimal         no-undo. /*local*/
def var v_val_sdo_ctbl_aux               as decimal         no-undo. /*local*/
def var v_val_sdo_idx                    as decimal         no-undo. /*local*/


/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can2
    label "Cancela"
    tooltip "Cancela"
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



{include/i_fclfrm.i f_dlg_02_wait_processing }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


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


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_demonst_ctbl_video}


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
    run pi_version_extract ('api_demonst_ctbl_video':U, 'prgfin/mgl/MGLA204za.py':U, '1.00.00.098':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = '@(&program)' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = '@(&program)'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */



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

/* ************* Parametros da FUN€ÇO *******************************
** Fun‡Æo para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser  atualizado
**  p_cod_campo       - Campo / Vari vel que ser  atualizada
**  p_cod_separador   - Separador que ser  utilizado
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

/* ************* Parametros da FUN€ÇO *******************************
** Fun‡Æo para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posi‡Æo que ser  atualizado
**  p_cod_campo       - Campo / Vari vel que ser  atualizada
**  p_cod_separador   - Separador que ser  utilizado
**  p_cod_valor       - Valor que ser  atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry ‚ 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv lido, este valor ser  convertido para Branco
         para possibilitar os c lculo ***/
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
    /* include feita para nÆo ocorrer problemas na utiliza‡Æo do comando program-name */
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


assign v_log_orcto_cta_sint = &IF DEFINED (BF_FIN_ORCTO_CTA_SINT_BGC) &THEN YES 
                              &ELSE GetDefinedFunction('SPP_ORCTO_CTA_SINT_BGC':U) &ENDIF
       v_log_funcao_concil_consolid = &IF DEFINED (BF_FIN_CONCIL_CONSOLID) &THEN YES 
                                      &ELSE GetDefinedFunction('SPP_CONCIL_CONSOLID':U) &ENDIF
       v_log_funcao_impr_col_sem_sdo = &IF DEFINED (BF_FIN_PARAM_IMPR_COL)  &THEN YES 
                                       &ELSE GetDefinedFunction('SPP_PARAM_IMPR_COL':U)  &ENDIF.

/* 218397 -  FUN€ÇO EXCLUSIVA P/ A 'Frangosul ' - POSSUI MAI DE UMA COLUNA TÖTULO*/
assign v_log_tit_demonst = &IF DEFINED (BF_FIN_TIT_DEMONST) &THEN YES 
                                       &ELSE GetDefinedFunction('SPP_TIT_DEMONST':U) &ENDIF.

if  v_log_eai_habilit then
    assign v_log_period_balan_geren = &IF DEFINED (BF_FIN_XML_DEMONST) &THEN YES &ELSE GetDefinedFunction('SPP_XML_DEMONST':U) &ENDIF.
else
    assign v_log_period_balan_geren = no.

/* Decimais Chile */
if not valid-handle(v_hdl_func_padr_glob) then run prgint/utb/utb925za.py persistent set v_hdl_func_padr_glob no-error.

function FnAjustDec     returns decimal (p_val_movto as decimal, p_cod_moed_finalid as character) in v_hdl_func_padr_glob.

assign v_log_funcao_tratam_dec = GetDefinedFunction('SPP_TRAT_CASAS_DEC':U).


/* Begin_Include: i_ttPeriodGLBalanceInformation */
DEFINE shared TEMP-TABLE ttPeriodGLBalanceInformationXML NO-UNDO
     FIELD AccountCode AS CHARACTER INITIAL ?  /* C¢digo da conta cont bil (Uso interno: campo = cod_cta_ctbl ou ct-codigo)*/
     FIELD AccountDescription AS CHARACTER INITIAL ?  /* Descri‡Æo da conta cont bil (Uso interno: campo = cta_ctbl.des_tit_ctbl ou conta.titulo)*/
     FIELD AccountPlanCode AS CHARACTER INITIAL ?  /* C¢digo do Plano de Conta cont bil (Uso interno: campo = cod_plan_cta_ctbl)*/
     FIELD AccountPlanDescription AS CHARACTER INITIAL ?  /* Descri‡Æo do plano de contas cont bil (Uso interno: campo =des_plan_cta_ctbl)*/
     FIELD AlternateAccountCode AS CHARACTER INITIAL ?  /* C¢digo da conta alternativa*/
     FIELD BranchCode AS CHARACTER INITIAL ?  /* C¢digo dao estabelecimento (Uso interno: cod_estabel ou cdn-estabe)*/
     FIELD BranchDescription AS CHARACTER INITIAL ?  /* RazÆo Social do estabelecimento (Uso interno: des_empresa)*/
     FIELD BusinessUnitCode AS CHARACTER INITIAL ?  /* C¢digo da unidade de neg¢cio (Uso interno: campo = unid_negoc.cod_unid_negoc)*/
     FIELD BusinessUnitDescription AS CHARACTER INITIAL ?  /* Descri‡Æo da unidade de neg¢cio (Uso interno: campo = unid_negoc.des_unid_negoc)*/
     FIELD CompanyCode AS CHARACTER INITIAL ?  /* C¢digo da empresa (Uso interno: cod_empresa ou ep-codigo)*/
     FIELD CompanyDescription AS CHARACTER INITIAL ?  /* RazÆo Social da Empresa (Uso interno: des_empresa ou razao-social)*/
     FIELD CostCenterCode AS CHARACTER INITIAL ?  /* C¢digo do Centro de Custo (Uso interno: campo= ccusto.cod_ccusto ou sub-conta.sc-codigo)*/
     FIELD CostCenterDescription AS CHARACTER INITIAL ?  /* Desri‡Æo do Centro de Custo (Uso interno: campo = ccusto.des_tit_ctbl ou sub-conta.descricao)*/
     FIELD CostCenterPlanCode AS CHARACTER INITIAL ?  /* C¢digo do Plano de Centro de Custo (Uso interno: campo=ccusto.cod_plano_ccusto)*/
     FIELD CostCenterPlanDescription AS CHARACTER INITIAL ?  /* Descri‡Æo do Plano de Centro de Custo (Uso interno: campo=plano_ccusto.des_tit_ctbl)*/
     FIELD CreditValue AS decimal INITIAL ?  /* Valor de Cr‚dito do Per¡odo ( campo = saldo-conta.credito ou sdo_ctbl.val_sdo_ctbl_cr) */
     FIELD CreditValue_00 AS decimal INITIAL ?  /* Valor de Cr‚dito do Per¡odo ( campo = sdo_ctbl_ccusto.qdt_sdo_ctbl_cr )*/
     FIELD DebitValue AS decimal INITIAL ?  /* Valor de D‚bito do Per¡odo ( campo = saldo-conta.debito ou sdo_ctbl.val_sdo_ctbl_db)*/
     FIELD DebitValue_00 AS decimal INITIAL ?  /* Valor de D‚bito do Per¡odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_db)*/
     FIELD EconomicPurposeCode AS CHARACTER INITIAL ?  /* C¢digo da Finalidade Economica (Uso interno: campo = finalid_econ.cod_finalid_econ)*/
     FIELD EconomicPurposeDescription AS CHARACTER INITIAL ?  /* Descri‡Æo da Finalidade Economica (Uso interno: campo = finalid_econ.des_finalid_econ)*/
     FIELD FinalBalance AS decimal INITIAL ?  /* Saldo Final do Per¡odo ( campo = (saldo-conta.saldo + saldo-conta.debito - saldo-conta.credito) ou sdo_ctbl.val_sdo_ctbl_fim )*/
     FIELD FinalBalance_00 AS decimal INITIAL ?  /* Saldo Final do Per¡odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_fim )*/
     FIELD InitialBalance AS decimal INITIAL ?  /* Saldo Inicial do Per¡odo ( campo = saldo-conta.saldo ou ( sdo_ctbl.val_sdo_ctbl_fim - sdo_ctbl.val_sdo_ctbl_db + sdo_ctbl.val_sdo_ctbl_cr) )*/
     FIELD InitialBalance_00 AS decimal INITIAL ?  /* Saldo Inicial do Per¡odo ( campo = sdo_ctbl_ccusto.qtd_sdo_ctbl_fim - sdo_ctbl_ccusto.qtd_sdo_ctbl_db + sdo_ctbl_ccusto.qtd_sdo_ctbl_cr*/
     FIELD InternationalStandardAccountCode AS CHARACTER INITIAL ?  /* C¢digo Internacional da conta cont bil*/
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


if  v_log_period_balan_geren then
    empty temp-table ttPeriodGLBalanceInformationXML.

find first tt_exec_rpc no-error.

assign v_cod_aplicat_dtsul_corren = tt_exec_rpc.ttv_cod_aplicat_dtsul_corren
       v_cod_ccusto_corren        = tt_exec_rpc.ttv_cod_ccusto_corren
       v_cod_dwb_user             = tt_exec_rpc.ttv_cod_dwb_user
       v_cod_empres_usuar         = tt_exec_rpc.ttv_cod_empres_usuar
       v_cod_estab_usuar          = tt_exec_rpc.ttv_cod_estab_usuar
       v_cod_funcao_negoc_empres  = tt_exec_rpc.ttv_cod_funcao_negoc_empres
       v_cod_grp_usuar_lst        = tt_exec_rpc.ttv_cod_grp_usuar_lst
       v_cod_idiom_usuar          = tt_exec_rpc.ttv_cod_idiom_usuar
       v_cod_modul_dtsul_corren   = tt_exec_rpc.ttv_cod_modul_dtsul_corren
       v_cod_modul_dtsul_empres   = tt_exec_rpc.ttv_cod_modul_dtsul_empres
       v_cod_pais_empres_usuar    = tt_exec_rpc.ttv_cod_pais_empres_usuar
       v_cod_plano_ccusto_corren  = tt_exec_rpc.ttv_cod_plano_ccusto_corren
       v_cod_unid_negoc_usuar     = tt_exec_rpc.ttv_cod_unid_negoc_usuar
       v_cod_usuar_corren         = tt_exec_rpc.ttv_cod_usuar_corren
       v_cod_usuar_corren_criptog = tt_exec_rpc.ttv_cod_usuar_corren_criptog
       v_num_ped_exec_corren      = tt_exec_rpc.ttv_num_ped_exec_corren.

/* --- Localiza os Parƒmetros definidos pelo Usu rio para Consulta do Demonstrativo ---*/
if v_cod_dwb_user begins 'es_'
and v_nom_prog <> "Di rio" /*l_diario*/  then do:
     find dwb_rpt_param no-lock
        where dwb_rpt_param.cod_dwb_program = 'rel_demonst_ctbl_video':U
          and dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user no-error.
     if (not avail dwb_rpt_param) then
        return getStrTrans("Parƒmetros para o relat¢rio nÆo encontrado.", "MGL") /*1993*/ + " (" + "1993" + ")" + chr(10) + getStrTrans("NÆo foi poss¡vel encontrar os parƒmetros necess rios para a impressÆo do relat¢rio para o programa e usu rio corrente.", "MGL") /*1993*/.

      assign v_cod_demonst_ctbl          = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10))
             v_cod_padr_col_demonst_ctbl = entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10))
             v_log_consid_apurac_restdo  = (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').

     if  v_log_funcao_concil_consolid and
         num-entries(dwb_rpt_param.cod_dwb_parameters,chr(10)) > 37 then
         assign v_log_consolid_recur = string(entry(38,dwb_rpt_param.cod_dwb_parameters,chr(10))) = 'yes'.

    FOR EACH b_prefer_demonst_ctbl NO-LOCK
        WHERE b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
         BREAK BY b_prefer_demonst_ctbl.dat_ult_atualiz
               BY b_prefer_demonst_ctbl.hra_ult_atualiz:
        IF  LAST-OF(b_prefer_demonst_ctbl.dat_ult_atualiz)
        AND LAST-OF(b_prefer_demonst_ctbl.hra_ult_atualiz) THEN
            FIND FIRST prefer_demonst_ctbl no-lock
                WHERE prefer_demonst_ctbl.cod_usuario = b_prefer_demonst_ctbl.cod_usuario
                  AND prefer_demonst_ctbl.cod_demonst_ctbl = b_prefer_demonst_ctbl.cod_demonst_ctbl
                  AND prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
            NO-ERROR.
    END.
end.
else do:
    do transaction:
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
    end.
    assign v_cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
           v_cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl.
end.

    /* ARMAZENA A SEQUENCIA DE COLUNAS QUE O USUµRIO DEFINIU NA EMISSÇO*/
&if '{&emsfin_version}' = '5.05' &then
    for each TAB_livre_emsfin no-lock
        where TAB_livre_emsfin.cod_modul_dtsul       = "MGL" /*l_mgl*/ 
        and   TAB_livre_emsfin.cod_tab_dic_dtsul     = v_cod_usuar_corren + chr(10) + "Preferˆncias" /*l_preferencias*/ 
        and   TAB_livre_emsfin.cod_compon_1_idx_tab  = v_cod_demonst_ctbl + chr(10) + v_cod_padr_col_demonst_ctbl
        by    int(TAB_livre_emsfin.cod_compon_2_idx_tab):

        if  v_cod_ord_col_demonst = "" then
            assign v_cod_ord_col_demonst = tab_livre_emsfin.cod_livre_1.
        else
            assign v_cod_ord_col_demonst = 
                   v_cod_ord_col_demonst + chr(59) + tab_livre_emsfin.cod_livre_1.

       if  v_cod_ord_col_demonst_aux = "" then
            assign v_cod_ord_col_demonst_aux = tab_livre_emsfin.cod_livre_2.
       else
            assign v_cod_ord_col_demonst_aux = 
                   v_cod_ord_col_demonst_aux + chr(59) + tab_livre_emsfin.cod_livre_2.            
    end.
&else
    for each  col_prefer_demonst_ctbl no-lock
        where col_prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
        and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = v_cod_demonst_ctbl
        and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
        by    col_prefer_demonst_ctbl.cod_usuario
        by    col_prefer_demonst_ctbl.cod_demonst_ctbl
        by    col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
        by    col_prefer_demonst_ctbl.num_seq:

        if  v_cod_ord_col_demonst = "" then
            assign v_cod_ord_col_demonst = col_prefer_demonst_ctbl.des_tit_ctbl.
        else
            assign v_cod_ord_col_demonst = 
                   v_cod_ord_col_demonst + chr(59) + col_prefer_demonst_ctbl.des_tit_ctbl.

        if  v_cod_ord_col_demonst_aux = "" then
            assign v_cod_ord_col_demonst_aux = col_prefer_demonst_ctbl.cod_col_demonst_ctbl.
        else
            assign v_cod_ord_col_demonst_aux = 
                   v_cod_ord_col_demonst_aux + chr(59) + col_prefer_demonst_ctbl.cod_col_demonst_ctbl.           
    end.
&endif

if not v_cod_dwb_user begins 'es_' 
or v_nom_prog = "Di rio" /*l_diario*/  then do:
    assign v_log_consid_apurac_restdo  = prefer_demonst_ctbl.log_consid_apurac_restdo
           v_cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
           v_cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl.
end.    

if avail prefer_demonst_ctbl then do:
    &if '{&emsfin_version}' >= '5.07' &then
        assign v_log_gera_dados_xml = prefer_demonst_ctbl.log_gera_dados_xml.
    &else
        if  prefer_demonst_ctbl.num_livre_1 = 1 then
            assign v_log_gera_dados_xml = yes.
        else 
            assign v_log_gera_dados_xml = no.
    &endif    
end.

/* --- Elimina Temp Tables ---*/

EMPTY TEMP-TABLE tt_acumul_demonst_ctbl_result.
EMPTY TEMP-TABLE tt_grp_col_demonst_video.
EMPTY TEMP-TABLE tt_label_demonst_ctbl_video.

EMPTY TEMP-TABLE tt_retorna_sdo_ctbl_demonst.
EMPTY TEMP-TABLE tt_rel_grp_col_compos_demonst.
EMPTY TEMP-TABLE tt_relacto_item_retorna.
EMPTY TEMP-TABLE tt_relacto_item_retorna_cons.
EMPTY TEMP-TABLE tt_item_demonst_ctbl_video.
EMPTY TEMP-TABLE tt_valor_demonst_ctbl_video.

EMPTY TEMP-TABLE tt_estrut_unid_organ.
EMPTY TEMP-TABLE tt_controla_analise_vertical.
EMPTY TEMP-TABLE tt_var_formul_1.
EMPTY TEMP-TABLE tt_ccustos_demonst.
EMPTY TEMP-TABLE tt_cta_ctbl_demonst.
EMPTY TEMP-TABLE tt_unid_negocio.
EMPTY TEMP-TABLE tt_proj_financ_demonst.

for each tt_col_demonst_ctbl_ext:
    delete tt_col_demonst_ctbl_ext.
end.

if  v_nom_prog = "Di rio" /*l_diario*/ 
then do:
    EMPTY TEMP-TABLE tt_acumul_demonst_cadastro.
    EMPTY TEMP-TABLE tt_item_demonst_ctbl_cadastro.
    EMPTY TEMP-TABLE tt_compos_demonst_cadastro.
    EMPTY TEMP-TABLE tt_estrut_visualiz_ctbl_cad.
    EMPTY TEMP-TABLE tt_col_demonst_ctbl.
end.

assign v_log_sped = Verifica_Program_Name('utb733za', 25).

if v_cod_demonst_ctbl <> '' /* Se nÆo for Consulta de Saldos*/ then do:
    /* --- Posiciona no Demonstrativo definido nos par³metros ---*/
    find demonst_ctbl no-lock
        where demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
        no-error.

    /* --- Seta recid demonstrativo para poder ser utilizado em outros programas ---*/
    assign v_rec_demonst_ctbl = if avail demonst_ctbl then recid(demonst_ctbl) else ?
           v_cod_demonst_ctbl = if avail demonst_ctbl then demonst_ctbl.cod_demonst_ctbl else ''.

    /* --- Posiciona no Padr’o de Colunas definido nos par³metros ---*/
    find padr_col_demonst_ctbl
        where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
        no-lock no-error.
    assign v_cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl.
    IF  NOT CAN-FIND(FIRST tt_item_demonst_ctbl_cadastro) then do:

        if v_cod_dwb_user begins 'es_'
        and v_nom_prog <> "Di rio" /*l_diario*/  then do:
                assign v_cod_ult_obj_procesdo = "Criando Colunas..." /*l_criando_colunas*/ .
                run pi_grava_ult_objeto (Input v_cod_ult_obj_procesdo).
        end.

        /* ITEM DO DEMONSTRATIVO CONTµBIL */
        for each item_demonst_ctbl no-lock
            where item_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl:
            create tt_item_demonst_ctbl_cadastro.
            buffer-copy item_demonst_ctbl to tt_item_demonst_ctbl_cadastro            
            assign tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad = recid(tt_item_demonst_ctbl_cadastro).

            /* COMPOSI€ÇO DO DEMONSTRATIVO CONTµBIL */
            for each compos_demonst_ctbl of item_demonst_ctbl no-lock:

                if v_cod_unid_organ_sub <> '' then do:
                    if can-find (first tt_compos_demonst_cadastro 
                             where tt_compos_demonst_cadastro.cod_demonst_ctbl       = tt_compos_demonst_cadastro.cod_demonst_ctbl      
                             and   tt_compos_demonst_cadastro.num_seq_demonst_ctbl   =  tt_compos_demonst_cadastro.num_seq_demonst_ctbl
                             and   tt_compos_demonst_cadastro.num_seq_compos_demonst <> tt_compos_demonst_cadastro.num_seq_compos_demonst
                             and   tt_compos_demonst_cadastro.cod_unid_organ    =  tt_compos_demonst_cadastro.cod_unid_organ
                             and   tt_compos_demonst_cadastro.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
                             and   tt_compos_demonst_cadastro.cod_cta_ctbl_inic   = tt_compos_demonst_cadastro.cod_cta_ctbl_inic    
                             and   tt_compos_demonst_cadastro.cod_cta_ctbl_fim  = tt_compos_demonst_cadastro.cod_cta_ctbl_fim
                             and   tt_compos_demonst_cadastro.cod_plano_ccusto  =  tt_compos_demonst_cadastro.cod_plano_ccusto
                             and   tt_compos_demonst_cadastro.cod_ccusto_inic  = tt_compos_demonst_cadastro.cod_ccusto_inic
                             and   tt_compos_demonst_cadastro.cod_ccusto_fim =  tt_compos_demonst_cadastro.cod_ccusto_fim 
                             and   tt_compos_demonst_cadastro.cod_estab_inic = tt_compos_demonst_cadastro.cod_estab_inic    
                             and   tt_compos_demonst_cadastro.cod_estab_fim = tt_compos_demonst_cadastro.cod_estab_fim     
                             and   tt_compos_demonst_cadastro.cod_unid_negoc_inic = tt_compos_demonst_cadastro.cod_unid_negoc_inic
                             and   tt_compos_demonst_cadastro.cod_unid_negoc_fim  = tt_compos_demonst_cadastro.cod_unid_negoc_fim) then
                    next.                    
                end.

                create tt_compos_demonst_cadastro.
                buffer-copy compos_demonst_ctbl to tt_compos_demonst_cadastro.

                /* Quando o demonstrativo for gerado para o SPED Cont bil, nÆo dever  inverter o valor */
                if v_log_sped then
                    assign tt_compos_demonst_cadastro.log_inverte_val = no.

                &if '{&emsfin_version}' = '5.05' &then 
                    if num-entries(compos_demonst_ctbl.cod_livre_1,chr(10)) >= 1 then
                        assign tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial = entry(1,compos_demonst_ctbl.cod_livre_1,chr(10)) no-error.

                    if num-entries(compos_demonst_ctbl.cod_livre_1,chr(10)) >= 2 then
                        assign tt_compos_demonst_cadastro.tta_cod_proj_financ_excec   = entry(2,compos_demonst_ctbl.cod_livre_1,chr(10)) no-error.
                &else
                    assign tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial = compos_demonst_ctbl.cod_proj_financ_inicial
                           tt_compos_demonst_cadastro.tta_cod_proj_financ_excec   = compos_demonst_ctbl.cod_proj_financ_excec.
                &endif

                /* * Recupera parƒmetros de substitui‡Æo **/
                if not v_cod_dwb_user begins 'es_' 
                or v_nom_prog = "Di rio" /*l_diario*/  then do:
                    &if '{&emsfin_version}' = '5.05' &then
                        if  prefer_demonst_ctbl.cod_livre_1 <> '' then do:
                            assign v_log_unid_organ_subst = (entry(2,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES').
                            if  v_log_unid_organ_subst then
                                assign tt_compos_demonst_cadastro.cod_unid_organ     = entry(6,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_unid_organ_fim = entry(6,prefer_demonst_ctbl.cod_livre_1,chr(10)).

                            assign v_log_unid_negoc_subst = (entry(3,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'yes').
                            if  v_log_unid_negoc_subst then
                                assign tt_compos_demonst_cadastro.cod_unid_negoc_inic = entry(7,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_unid_negoc_fim = entry(8,prefer_demonst_ctbl.cod_livre_1,chr(10)).

                            assign v_log_estab_subst = (entry(4,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'yes').
                            if  v_log_estab_subst then
                                assign tt_compos_demonst_cadastro.cod_estab_inic = entry(9,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_estab_fim  = entry(10,prefer_demonst_ctbl.cod_livre_1,chr(10)).

                            assign v_log_ccusto_subst = (entry(5,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'yes').
                            if  v_log_ccusto_subst then  
                                assign tt_compos_demonst_cadastro.cod_ccusto_inic  = entry(11,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_ccusto_fim   = entry(12,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_plano_ccusto = entry(15,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_ccusto_excec = entry(14,prefer_demonst_ctbl.cod_livre_1,chr(10))
                                       tt_compos_demonst_cadastro.cod_ccusto_pfixa = entry(13,prefer_demonst_ctbl.cod_livre_1,chr(10)).
                        end.
                    &else
                        if  prefer_demonst_ctbl.log_unid_organ_subst then
                            assign tt_compos_demonst_cadastro.cod_unid_organ     = prefer_demonst_ctbl.cod_unid_organ_subst
                                   tt_compos_demonst_cadastro.cod_unid_organ_fim = prefer_demonst_ctbl.cod_unid_organ_subst.

                        if  prefer_demonst_ctbl.log_unid_negoc_subst then
                            assign tt_compos_demonst_cadastro.cod_unid_negoc_inic = prefer_demonst_ctbl.cod_unid_negoc_inic_subst
                                   tt_compos_demonst_cadastro.cod_unid_negoc_fim  = prefer_demonst_ctbl.cod_unid_negoc_fim_subst.

                        if  prefer_demonst_ctbl.log_estab_subst then
                            assign tt_compos_demonst_cadastro.cod_estab_inic = prefer_demonst_ctbl.cod_estab_inic_subst
                                   tt_compos_demonst_cadastro.cod_estab_fim = prefer_demonst_ctbl.cod_estab_fim_subst.

                        if  prefer_demonst_ctbl.log_ccusto_subst then
                            assign tt_compos_demonst_cadastro.cod_ccusto_inic  = prefer_demonst_ctbl.cod_ccusto_inic_subst
                                   tt_compos_demonst_cadastro.cod_ccusto_fim   = prefer_demonst_ctbl.cod_ccusto_fim_subst
                                   tt_compos_demonst_cadastro.cod_plano_ccusto = prefer_demonst_ctbl.cod_plano_ccusto_subst
                                   tt_compos_demonst_cadastro.cod_ccusto_excec = prefer_demonst_ctbl.cod_ccusto_exec_subst
                                   tt_compos_demonst_cadastro.cod_ccusto_pfixa = prefer_demonst_ctbl.cod_ccusto_pfixa_subst.
                    &endif
                end.
                else do:
                    assign v_log_unid_organ_subst = (entry(15,dwb_rpt_param.cod_dwb_parameters ,chr(10)) = 'YES').
                    if  v_log_unid_organ_subst then
                        assign tt_compos_demonst_cadastro.cod_unid_organ     = entry(19,dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_unid_organ_fim = entry(19,dwb_rpt_param.cod_dwb_parameters, chr(10)).

                    assign v_log_unid_negoc_subst = (entry(17,dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                    if  v_log_unid_negoc_subst then
                        assign tt_compos_demonst_cadastro.cod_unid_negoc_inic = entry(22,dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_unid_negoc_fim = entry(23,dwb_rpt_param.cod_dwb_parameters, chr(10)).

                    assign v_log_estab_subst = (entry(16,dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                    if  v_log_estab_subst then
                        assign tt_compos_demonst_cadastro.cod_estab_inic = entry(20, dwb_rpt_param.cod_dwb_parameters ,chr(10))
                               tt_compos_demonst_cadastro.cod_estab_fim  = entry(21, dwb_rpt_param.cod_dwb_parameters,chr(10)).

                    assign v_log_ccusto_subst = (entry(18, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                    if  v_log_ccusto_subst then  
                        assign tt_compos_demonst_cadastro.cod_ccusto_inic  = entry(25, dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_ccusto_fim   = entry(26, dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_plano_ccusto = entry(24, dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_ccusto_excec = entry(28, dwb_rpt_param.cod_dwb_parameters, chr(10))
                               tt_compos_demonst_cadastro.cod_ccusto_pfixa = entry(27, dwb_rpt_param.cod_dwb_parameters, chr(10)).    
                end.
            end.

            /* ACUMULADOR */
            for each acumul_demonst_ctbl of item_demonst_ctbl no-lock:
                find  tt_acumul_demonst_cadastro
                   where tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = acumul_demonst_ctbl.cod_demonst_ctbl
                   and   tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = acumul_demonst_ctbl.num_seq_demonst_ctbl
                   and   tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = acumul_demonst_ctbl.cod_acumul_ctbl
                   no-error.
                if  not avail tt_acumul_demonst_cadastro then do:
                    create tt_acumul_demonst_cadastro.
                    assign tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = acumul_demonst_ctbl.cod_demonst_ctbl
                           tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = acumul_demonst_ctbl.num_seq_demonst_ctbl
                           tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = acumul_demonst_ctbl.cod_acumul_ctbl
                           tt_acumul_demonst_cadastro.tta_log_zero_acumul_ctbl = acumul_demonst_ctbl.log_zero_acumul_ctbl.
                end.
            end.
        end.
    end.
    if v_cod_dwb_user begins 'es_'
    and v_nom_prog <> "Di rio" /*l_diario*/  then do:
        assign v_cod_ult_obj_procesdo = "Criando Estrutura Visualiza‡Æo..." /*l_Criando_estrutura_visualizacao*/ .
        run pi_grava_ult_objeto(Input v_cod_ult_obj_procesdo).
    end.
    /* COLUNAS DO PADRÇO */
    if  not can-find(first tt_col_demonst_ctbl) then do:
        for each col_demonst_ctbl no-lock
            where col_demonst_ctbl.cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl:
            if col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Empenhado" /*l_empenhado*/ 
               or col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Mov + Empenh" /*l_movto_realiz_mais_empenhado*/  then do:
/****Araupel*****/
               find first periodo_orcto no-error.
                   IF date(int(prefer_demonst_ctbl.num_period_ctbl), 01, int(prefer_demonst_ctbl.cod_exerc_ctbl) ) <= date(periodo_orcto.Mes, 01, periodo_orcto.Ano) THEN

                assign v_log_busca_val_empenh = no.
            else
            assign v_log_busca_val_empenh = yes.

            end.
            create tt_col_demonst_ctbl.
            buffer-copy col_demonst_ctbl to tt_col_demonst_ctbl.
            assign tt_col_demonst_ctbl.ttv_rec_col_demonst_ctbl = recid(tt_col_demonst_ctbl).
        end.                                                                                                   
    end.
    /* ESTRUTURA DE VISUALIZA€ÇO DO DEMONSTRATIVO */
    if  not can-find(first tt_estrut_visualiz_ctbl_cad) then do:
        for each estrut_visualiz_ctbl no-lock
            where estrut_visualiz_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl:
            create tt_estrut_visualiz_ctbl_cad.
            buffer-copy estrut_visualiz_ctbl to tt_estrut_visualiz_ctbl_cad.
        end.
    end.
end.
else do: 
    assign v_cod_demonst_ctbl          = ""
           v_cod_padr_col_demonst_ctbl = "".
end.

if  v_log_period_balan_geren and v_cod_demonst_ctbl <> '' then do:
    assign v_dat_fim         = date(prefer_demonst_ctbl.num_period_ctbl, 15, int(prefer_demonst_ctbl.cod_exerc_ctbl)) + 30
           v_dat_fim         = date(month(v_dat_fim), 01, year(v_dat_fim)) - 1
           v_num_ult_dia_mes = day(v_dat_fim)
           v_dat_inic_valid  = date(prefer_demonst_ctbl.num_period_ctbl, 01, int(prefer_demonst_ctbl.cod_exerc_ctbl))
           v_dat_fim_valid   = date(prefer_demonst_ctbl.num_period_ctbl, v_num_ult_dia_mes, int(prefer_demonst_ctbl.cod_exerc_ctbl)).

    cenarBlock:
    for each cenar_ctbl no-lock
        &if '{&emsfin_version}' >= '5.06' &then
        where cenar_ctbl.log_cenar_inativ = no:
        &else
        where cenar_ctbl.log_livre_1 = no:
        &endif

        find last utiliz_cenar_ctbl no-lock
            where utiliz_cenar_ctbl.cod_empresa     = v_cod_empres_usuar
            and   utiliz_cenar_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
            and   utiliz_cenar_ctbl.dat_inic_valid <= v_dat_inic_valid
            and   utiliz_cenar_ctbl.dat_fim_valid  >= v_dat_fim_valid
            and   utiliz_cenar_ctbl.log_cenar_fisc  = yes no-error.
       if  avail utiliz_cenar_ctbl then
           leave cenarBlock.
    end.
end.

run pi_demonst_ctbl_video /*pi_demonst_ctbl_video*/.


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
    if  param_geral_gld.ind_trad_tit_ctbl = "NÆo Utiliza" /*l_nao_utiliza*/ 
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
** Procedure Interna.....: pi_retorna_usa_segur_estab
** Descricao.............: pi_retorna_usa_segur_estab
** Criado por............: Barth
** Criado em.............: 17/04/2000 22:23:16
** Alterado por..........: log348825
** Alterado em...........: 17/02/2010 09:39:11
*****************************************************************************/
PROCEDURE pi_retorna_usa_segur_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_demonst_ctbl
        as character
        format "x(8)"
        no-undo.
    def output param p_log_restric_estab
        as logical
        format "Sim/NÆo"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_demonst_ctbl
        for demonst_ctbl.
    &endif
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_param_geral_gld
        for param_geral_gld.
    &endif


    /*************************** Buffer Definition End **************************/

    /* *****
    **
    **  O PARAMETRO P_COD_DEMONST_CTBL PODE SER USADO DE TRES FORMAS:
    **
    **    ?  - RETORNA SE A FUN€ÇO BF_FIN_SEGUR_DEMONST_MGL ESTµ HABILITADA (OU EXECUTOU PROGRAMA ESPECIAL QUE LIBERA).
    **    "" - RETORNA SE NO PARAMETRO GERAL DA CONTABILIDADE USA O CONTROLE DE ESTABELECIMENTO.
    **    <cod_demonst> - RETORNA SE O DEMONSTRATIVO CADASTRADO USA O CONTROLE.
    **
    *******/

    &if  defined(BF_FIN_SEGUR_DEMONST_MGL) &then

        if  p_cod_demonst_ctbl = ? then do:        /* ** RETORNA SE FUN€ÇO HABILITADA PARA ESTA VERSÇO ***/
            assign p_log_restric_estab = yes.
        end.
        else if  p_cod_demonst_ctbl <> ""          /* ** RETORNA SE DEMONSTRATIVO USA CONTROLE ***/
        then do:
            find b_demonst_ctbl where b_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl no-lock no-error.
            if  avail b_demonst_ctbl then
                assign p_log_restric_estab = b_demonst_ctbl.log_restric_estab.
        end.
        else do:                                   /* ** RETORNA SE PARAM GERAL CTBL USA CONTROLE ***/
            find last b_param_geral_gld no-lock no-error.
            if avail b_param_geral_gld then
                assign p_log_restric_estab = b_param_geral_gld.log_restric_estab.
        end.

    &elseif '{&emsfin_version}' >= '5.02' &then

        find emsbas.histor_exec_especial
            where emsbas.histor_exec_especial.cod_modul_dtsul = 'MGL'
            and   emsbas.histor_exec_especial.cod_prog_dtsul  = "fnc_segur_demonst_mgl":U
            no-lock no-error.
        if  not avail emsbas.histor_exec_especial then
            return.

        if  p_cod_demonst_ctbl = ? then do:        /* ** RETORNA SE FUN€ÇO HABILITADA PARA ESTA VERSÇO ***/
            assign p_log_restric_estab = yes.
        end.
        else if  p_cod_demonst_ctbl <> ""          /* ** RETORNA SE DEMONSTRATIVO USA CONTROLE ***/
        then do:
            find b_demonst_ctbl where b_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl no-lock no-error.
            if  avail b_demonst_ctbl then
                assign p_log_restric_estab = b_demonst_ctbl.log_livre_1.
        end.
        else do:                                   /* ** RETORNA SE PARAM GERAL CTBL USA CONTROLE ***/
            find last b_param_geral_gld no-lock no-error.
            if avail b_param_geral_gld then
                assign p_log_restric_estab = (b_param_geral_gld.num_livre_1 = 1).
        end.

    &endif

END PROCEDURE. /* pi_retorna_usa_segur_estab */
/*****************************************************************************
** Procedure Interna.....: pi_demonst_ctbl_video
** Descricao.............: pi_demonst_ctbl_video
** Criado por............: Dalpra
** Criado em.............: 24/01/2001 11:06:17
** Alterado por..........: fut33243
** Alterado em...........: 01/10/2009 16:46:51
*****************************************************************************/
PROCEDURE pi_demonst_ctbl_video:

    /************************* Variable Definition Begin ************************/

    def var v_log_achou_4
        as logical
        format "Sim/NÆo"
        initial yes
        no-undo.
    def var v_log_impr_col_sem_sdo
        as logical
        format "Sim/NÆo"
        initial yes
        view-as toggle-box
        label "Impr Coluna Sem Sdo"
        no-undo.
    def var v_num_col_aux                    as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if not v_cod_dwb_user begins 'es_' then do:
        run pi_wait_processing (Input "Preparando Informa‡äes..." /*l_preparando_informacoes*/ ,
                                Input "Preparando Informa‡äes..." /*l_preparando_informacoes*/ ).

        disable bt_can2 with frame f_dlg_02_wait_processing.
    end.
    else do:
        assign v_cod_ult_obj_procesdo = "Preparando Informa‡äes..." /*l_preparando_informacoes*/ .
        run pi_grava_ult_objeto (Input v_cod_ult_obj_procesdo).
    end.

    /* --- Leitura dos Parametros Gerais do EMS e da Contabilidade ---*/
    find last param_geral_ems no-lock no-error.
    find last param_geral_gld no-lock no-error.

    /* --- Verifica se o Demonstrativo utiliza Seguran‡a por Estabelecimento ---*/
    run pi_retorna_usa_segur_estab (Input v_cod_demonst_ctbl,
                                    output v_log_restric_estab) /*pi_retorna_usa_segur_estab*/.

    /* --- Verifica o N£mero de Colunas definidas para o Demonstrativo ---*/
    assign v_qtd_col = 0.
    for each  tt_col_demonst_ctbl no-lock
        where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl:
        assign v_qtd_col = v_qtd_col + 1.
    end.

    /* --- N£mero de Colunas ---*/
    assign v_num_col_aux = 0.
    do  v_num_col = 1 to v_qtd_col:

        /* --- Informa‡äes necess rias para montagem das colunas (Ordem/Labels/Formato...) ---*/
        for each tt_col_demonst_ctbl no-lock
            where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl   = v_cod_padr_col_demonst_ctbl
            and   (tt_col_demonst_ctbl.des_tit_ctbl               = GetEntryField(v_num_col, v_cod_ord_col_demonst, chr(59))
            and   tt_col_demonst_ctbl.cod_col_demonst_ctbl        = GetEntryField(v_num_col, v_cod_ord_col_demonst_aux, chr(59))
            or    tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl = "Base C lculo" /*l_base_calculo*/ ):

            if  tt_col_demonst_ctbl.ind_orig_val_col_demonst = "T¡tulo" /*l_titulo*/  then do:
                if tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl <> "Base C lculo" /*l_base_calculo*/  then
                    assign v_num_format_col = int(replace(substring(tt_col_demonst_ctbl.cod_format_col_demonst_ctbl, 
                                                              index(tt_col_demonst_ctbl.cod_format_col_demonst_ctbl, "(") + 1, 
                                                             length(tt_col_demonst_ctbl.cod_format_col_demonst_ctbl)), ")", "")) 
                           v_cod_format_col_demonst_ctbl = v_cod_format_col_demonst_ctbl + fill("9", v_num_format_col) + chr(10).
            end.
            else if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  then do:
                if tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl <> "Base C lculo" /*l_base_calculo*/  then
                    assign v_cod_format_col_demonst_ctbl = 
                           v_cod_format_col_demonst_ctbl + tt_col_demonst_ctbl.cod_format_col_demonst_ctbl + chr(10).
            end.
            else do:
                if v_ind_orig_val_col_demonst = "" then
                    assign v_ind_orig_val_col_demonst = tt_col_demonst_ctbl.ind_orig_val_col_demonst.
                else
                    if lookup(tt_col_demonst_ctbl.ind_orig_val_col_demonst, v_ind_orig_val_col_demonst, chr(59)) = 0 then
                        assign v_ind_orig_val_col_demonst = v_ind_orig_val_col_demonst + chr(59) 
                                                              + tt_col_demonst_ctbl.ind_orig_val_col_demonst.
                if tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl <> "Base C lculo" /*l_base_calculo*/  then
                   assign v_cod_format_col_demonst_ctbl = 
                          v_cod_format_col_demonst_ctbl + tt_col_demonst_ctbl.cod_format_col_demonst_ctbl + chr(10).

                /* --- Cria‡Æo dos Grupos de Colunas ---*/
                find tt_grp_col_demonst_video
                   where tt_grp_col_demonst_video.tta_qtd_period_relac_base    = tt_col_demonst_ctbl.qtd_period_relac_base
                     and tt_grp_col_demonst_video.tta_qtd_exerc_relac_base     = tt_col_demonst_ctbl.qtd_exerc_relac_base
                     and tt_grp_col_demonst_video.tta_ind_tip_relac_base       = tt_col_demonst_ctbl.ind_tip_relac_base
                     and tt_grp_col_demonst_video.tta_num_conjto_param_ctbl    = tt_col_demonst_ctbl.num_conjto_param_ctbl 
                     and tt_grp_col_demonst_video.tta_ind_tip_val_consolid     = tt_col_demonst_ctbl.ind_tip_val_consolid
                     no-error.
                if  not avail tt_grp_col_demonst_video then do:
                    create tt_grp_col_demonst_video.
                    assign tt_grp_col_demonst_video.tta_qtd_period_relac_base    = tt_col_demonst_ctbl.qtd_period_relac_base
                           tt_grp_col_demonst_video.tta_qtd_exerc_relac_base     = tt_col_demonst_ctbl.qtd_exerc_relac_base
                           tt_grp_col_demonst_video.tta_ind_tip_relac_base       = tt_col_demonst_ctbl.ind_tip_relac_base
                           tt_grp_col_demonst_video.tta_num_conjto_param_ctbl    = tt_col_demonst_ctbl.num_conjto_param_ctbl
                           tt_grp_col_demonst_video.tta_ind_tip_val_consolid     = tt_col_demonst_ctbl.ind_tip_val_consolid.

                end.
            end.

            if  tt_col_demonst_ctbl.ind_funcao_col_demonst_ctbl = "ImpressÆo" /*l_impressao*/  then do:
                assign v_num_col_aux = v_num_col_aux + 1.
                /* --- Retorna o Label da colunas no Idioma selecionado ---*/
                if v_cod_dwb_user begins 'es_'
                and v_nom_prog <> "Di rio" /*l_diario*/  then do:
                    run pi_retornar_trad_idiom (Input tt_col_demonst_ctbl.des_tit_ctbl,
                                                Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                end.
                else do:
                    run pi_retornar_trad_idiom (Input tt_col_demonst_ctbl.des_tit_ctbl,
                                                Input prefer_demonst_ctbl.cod_idioma,
                                                output v_des_tit_idiom) /*pi_retornar_trad_idiom*/.
                end.

                /* --- Cria Temp-Table com os Labels das Colunas ---*/
                find tt_label_demonst_ctbl_video
                   where tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                   no-error.
                if  not avail tt_label_demonst_ctbl_video then do:
                    create tt_label_demonst_ctbl_video.
                    assign tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl        = tt_col_demonst_ctbl.cod_col_demonst_ctbl 
                           tt_label_demonst_ctbl_video.ttv_des_label_col               = trim(v_des_tit_idiom)
                           tt_label_demonst_ctbl_video.tta_num_seq_demonst_ctbl        = v_num_col_aux
                           tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst    = tt_col_demonst_ctbl.ind_orig_val_col_demonst
                           tt_label_demonst_ctbl_video.ttv_cod_format_col_demonst_ctbl = tt_col_demonst_ctbl.cod_format_col_demonst_ctbl.

                    /* --- Retorna o n£mero m ximo de posi‡äes que deve ser reservado para o atributo, ser  utilizado
                          para definir a largura da coluna ---*/
                    run pi_calcula_numero_posicoes_formato_505 (Input tt_col_demonst_ctbl.cod_format_col_demonst_ctbl,
                                                                output tt_label_demonst_ctbl_video.ttv_num_pos_col_demonst_ctbl) /*pi_calcula_numero_posicoes_formato_505*/.
                end.
            end.
        end.
    end.

    run pi_item_demonst_ctbl_video /*pi_item_demonst_ctbl_video*/.

    if v_log_funcao_impr_col_sem_sdo then do:
        /* Se foi chamado a partir do programa fgl305ab, como nÆo tem o parƒmetro "Imprime Coluna sem Saldo"
        considera sempre para imprimir. */
        assign v_log_achou_4 = Verifica_Program_Name('fgl305ab':U, 25).
        if v_log_achou_4 = no then do:

            if v_cod_dwb_user begins 'es_' and v_nom_prog <> "Di rio" /*l_diario*/   then do:
                if num-entries(dwb_rpt_param.cod_dwb_parameters,chr(10)) > 38 then
                    assign v_log_impr_col_sem_sdo = (GetEntryField(39, dwb_rpt_param.cod_dwb_parameters, chr(10)) <> "no" /*l_no*/ ).
                else    
                    assign v_log_impr_col_sem_sdo = yes.
            end.            
            else do:
                &if '{&emsfin_version}' >= '5.07' &then
                assign v_log_impr_col_sem_sdo = prefer_demonst_ctbl.log_impr_col_sem_sdo.
                &else
                /* Se nÆo tem mais que 38, significa que ainda nÆo foi alterado o parƒmetro prefer_demonst_ctbl.cod_livre_1*/
                assign v_log_impr_col_sem_sdo = (GetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10)) <> "no" /*l_no*/ ).
                &endif
            end.

            if v_log_impr_col_sem_sdo = no then do:

                colunas:
                for each tt_label_demonst_ctbl_video
                    where tt_label_demonst_ctbl_video.tta_ind_orig_val_col_demonst <> "T¡tulo" /*l_titulo*/ :

                    for each tt_valor_demonst_ctbl_video 
                        where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl:
                        if tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0 then 
                            next colunas.
                    end.   

                    /* Se chegou aqui, significa que todas as linhas tem valores iguais a zero */
                    for each tt_valor_demonst_ctbl_video 
                        where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_label_demonst_ctbl_video.tta_cod_col_demonst_ctbl:
                        delete tt_valor_demonst_ctbl_video.
                    end.    
                    delete tt_label_demonst_ctbl_video.
                end.

            end.        
        end.        
    end.


END PROCEDURE. /* pi_demonst_ctbl_video */
/*****************************************************************************
** Procedure Interna.....: pi_item_demonst_ctbl_video
** Descricao.............: pi_item_demonst_ctbl_video
** Criado por............: Dalpra
** Criado em.............: 24/01/2001 13:44:49
** Alterado por..........: fut38629
** Alterado em...........: 22/02/2010 11:29:06
*****************************************************************************/
PROCEDURE pi_item_demonst_ctbl_video:

    /************************* Variable Definition Begin ************************/

    def var v_log_impr_acum_zero
        as logical
        format "Sim/NÆo"
        initial no
        view-as toggle-box
        label "Impr Acum Zerado"
        no-undo.
    def var v_num_cont
        as integer
        format ">,>>9":U
        initial 0
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_log_final_proces = no.

    if v_cod_dwb_user begins 'es_'
    and v_nom_prog <> "Di rio" /*l_diario*/  then do:
        assign v_cod_ult_obj_procesdo = "Leitura dos itens do demonstrativo ..." /*l_leitura_itens_demonstrativo*/ .
        run pi_grava_ult_objeto ( Input v_cod_ult_obj_procesdo).
    end.                          

    /* --- Leitura dos Itens do Demonstrativo selecionado ---*/
    for each tt_item_demonst_ctbl_cadastro
       where tt_item_demonst_ctbl_cadastro.ttv_log_ja_procesdo = no:

        /* --- Atualiza temp-table como jÿ processada ---*/
        assign tt_item_demonst_ctbl_cadastro.ttv_log_ja_procesdo = yes.


        /* * Impress’o de linhas em branco Antes do Item **/
        if  tt_item_demonst_ctbl_cadastro.num_lin_salto_antes > 0 then do:
            do v_num_contador = 1 to tt_item_demonst_ctbl_cadastro.num_lin_salto_antes:
                create tt_item_demonst_ctbl_video.
                assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = (tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl - 0.2)
                       tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_1  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_2  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_3  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_4  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_5  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_6  = ""
                       tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = 'Chr Espec'
                       tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
                       tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).
            end.
        end.

        /* * Impress’o de Tra»o Antes dos Itens **/
        if  tt_item_demonst_ctbl_cadastro.ind_impres_traco_lin = "Antes" /*l_antes*/  then do:
            create tt_item_demonst_ctbl_video.
            assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = (tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl - 0.1)
                   tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes
                   tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(substring(tt_item_demonst_ctbl_cadastro.ind_carac_traco,1,1),100)
                   tt_item_demonst_ctbl_video.ttv_cod_chave_1  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_2  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_3  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_4  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_5  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_6  = ""
                   tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = 'Chr Espec'
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).
        end.

        /* --- Tipo de Linha do Demonstrativo ---*/
        if  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst <> "T¡tulo" /*l_titulo*/   then do: 
            assign v_log_estab_sumar      = yes
                   v_log_cta_ctbl_sumar   = yes
                   v_log_ccusto_sumar     = yes
                   v_log_unid_negoc_sumar = yes
                   v_log_unid_organ_sumar = yes
                   v_log_proj_sumar       = yes
                   v_cod_estrut_descr     = ""
                   v_cod_estrut_tot       = ""
                   v_cod_estrut           = ""
                   v_cod_estrut_visualiz  = ""
                   v_cod_chave            = fill(chr(10), 6)
                   v_des_tit_ctbl         = tt_item_demonst_ctbl_cadastro.des_tit_ctbl.

            if v_cod_dwb_user begins 'es_'
            and v_nom_prog <> "Di rio" /*l_diario*/  then do:
                run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                            Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                            output v_des_tit_ctbl).
            end.
            else do:
                run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                            Input prefer_demonst_ctbl.cod_idioma,
                                            output v_des_tit_ctbl) /*pi_retornar_trad_idiom*/.
            end.
            /* --- Verifica se existem Acumuladores para o Demonstrativo ---*/
            if  can-find(first tt_acumul_demonst_cadastro
                where tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                  and tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl) then
                assign v_log_acumul_demonst = yes.
            else
                assign v_log_acumul_demonst = no.

            /* --- Estrutura de Visualiza»’o ---*/
            if  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst    = "Valor" /*l_valor*/  
            and tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "Valor Conta" /*l_valor_conta*/   then do:
                assign v_cod_estrut_tot   = ""
                       v_cod_lista_compon = "".

                for each tt_estrut_visualiz_ctbl_cad no-lock
                   where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                     and tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:

                    assign v_cod_estrut = 
                           v_cod_estrut + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz + chr(10)
                           v_cod_estrut_visualiz = 
                           v_cod_estrut_visualiz + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz + chr(10).

                    /* --- Totalizadores ---*/
                    if  tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl = yes then
                        assign v_cod_estrut_tot = 
                               v_cod_estrut_tot + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz + chr(10).

                    /* --- Descri»„es ---*/
                    if  tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst = yes then
                        assign v_cod_estrut_tot = 
                               v_cod_estrut_tot + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz + chr(10).

                    assign v_cod_lista_compon = 
                           v_cod_lista_compon + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz          + ';'
                                              + string(tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl) + ';'
                                              + string(tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst)    + ';'.

                    case tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz:
                        when "UO Origem" /*l_uo_origem*/   then /* --- Saldo Consolidado ---*/
                            assign v_log_unid_organ_sumar = no /* --- N’o sumaria Unid Organ ---*/.

                        when "Estabelecimento" /*l_estabelecimento*/   then
                            assign v_log_estab_sumar = no /* --- N’o sumaria Estabelecimento ---*/.

                        when "Unidade Neg¢cio" /*l_unidade_negocio*/   then
                            assign v_log_unid_negoc_sumar = no /* --- N’o sumaria Unid Negoc ---*/.

                        when "Conta Cont bil" /*l_conta_contabil*/   then
                            assign v_log_cta_ctbl_sumar = no /* --- N’o sumaria Conta Ctbl ---*/.

                        when "Centro de Custo" /*l_centro_de_custo*/   then
                            assign v_log_ccusto_sumar = no  /* --- N’o sumaria Ccusto ---*/.

                        when "Projeto" /*l_projeto*/   then
                            assign v_log_proj_sumar = no  /* --- N’o sumaria Projeto ---*/.
                    end.
                end.
            end.

            /* --- Acerta Variÿvel que controla a chave ---*/
            if  v_log_estab_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "Estabelecimento" /*l_estabelecimento*/   + chr(10).

            if  v_log_cta_ctbl_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "Conta Cont bil" /*l_conta_contabil*/   + chr(10).

            if  v_log_ccusto_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "Centro de Custo" /*l_centro_de_custo*/   + chr(10).

            if  v_log_unid_negoc_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "Unidade Neg¢cio" /*l_unidade_negocio*/   + chr(10).

            if  v_log_unid_organ_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "UO Origem" /*l_uo_origem*/   + chr(10).

            if  v_log_proj_sumar = yes then
                assign v_cod_estrut = v_cod_estrut + "Projeto" /*l_projeto*/   + chr(10).

            /* --- Composi»„es do Item Demonstrativo ---*/
            assign v_log_primei_compos_demonst = yes.

            for each  tt_compos_demonst_cadastro no-lock
                where tt_compos_demonst_cadastro.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                and   tt_compos_demonst_cadastro.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                by    tt_compos_demonst_cadastro.num_seq_compos_demonst:

                /* ===================================
                 212559 - qdo o bt subst nÆo for selecionado e possui uma faixa de unid de neg e ccusto ele estava somando o vlr seis vezes
                ===================================*/
                if can-find (first tt_compos_demonst_cadastro /* exclusive-lock*/
                             where tt_compos_demonst_cadastro.cod_demonst_ctbl       = tt_compos_demonst_cadastro.cod_demonst_ctbl      
                             and   tt_compos_demonst_cadastro.num_seq_demonst_ctbl   =  tt_compos_demonst_cadastro.num_seq_demonst_ctbl
                             and   tt_compos_demonst_cadastro.num_seq_compos_demonst <> tt_compos_demonst_cadastro.num_seq_compos_demonst
                             and   tt_compos_demonst_cadastro.cod_unid_organ    =  tt_compos_demonst_cadastro.cod_unid_organ
                             and   tt_compos_demonst_cadastro.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl
                             and   tt_compos_demonst_cadastro.cod_cta_ctbl_inic   = tt_compos_demonst_cadastro.cod_cta_ctbl_inic    
                             and   tt_compos_demonst_cadastro.cod_cta_ctbl_fim  = tt_compos_demonst_cadastro.cod_cta_ctbl_fim
                             and   tt_compos_demonst_cadastro.cod_plano_ccusto  =  tt_compos_demonst_cadastro.cod_plano_ccusto
                             and   tt_compos_demonst_cadastro.cod_ccusto_inic  = tt_compos_demonst_cadastro.cod_ccusto_inic
                             and   tt_compos_demonst_cadastro.cod_ccusto_fim =  tt_compos_demonst_cadastro.cod_ccusto_fim 
                             and   tt_compos_demonst_cadastro.cod_estab_inic = tt_compos_demonst_cadastro.cod_estab_inic    
                             and   tt_compos_demonst_cadastro.cod_estab_fim = tt_compos_demonst_cadastro.cod_estab_fim     
                             and   tt_compos_demonst_cadastro.cod_unid_negoc_inic = tt_compos_demonst_cadastro.cod_unid_negoc_inic
                             and   tt_compos_demonst_cadastro.cod_unid_negoc_fim  = tt_compos_demonst_cadastro.cod_unid_negoc_fim) then
                                 delete tt_compos_demonst_cadastro.

               /* --- Tipo Compos Valor Conta ---*/
               if  tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "Valor Conta" /*l_valor_conta*/   then do:

                   /* --- Ajusta os Valores de Unidades Organiz ---*/
                   if  num-entries (tt_compos_demonst_cadastro.des_formul_ctbl, chr(10)) <> 5 then do transaction:
                       find btt_compos_demonst_cadastro exclusive-lock
                          where  btt_compos_demonst_cadastro.cod_demonst_ctbl       = tt_compos_demonst_cadastro.cod_demonst_ctbl
                          and    btt_compos_demonst_cadastro.num_seq_demonst_ctbl   = tt_compos_demonst_cadastro.num_seq_demonst_ctbl
                          and    btt_compos_demonst_cadastro.num_seq_compos_demonst = tt_compos_demonst_cadastro.num_seq_compos_demonst no-error.
                       if  avail btt_compos_demonst_cadastro then do:
                           assign btt_compos_demonst_cadastro.des_formul_ctbl = 
                                  btt_compos_demonst_cadastro.des_formul_ctbl + chr(10) + btt_compos_demonst_cadastro.cod_unid_organ.
                           release btt_compos_demonst_cadastro.
                       end.
                   end.
                   find first emsuni.unid_organ
                      where unid_organ.cod_unid_organ >= tt_compos_demonst_cadastro.cod_unid_organ
                      and   unid_organ.cod_unid_organ <= tt_compos_demonst_cadastro.cod_unid_organ_fim
                      no-lock no-error.
                   if avail unid_organ then
                       assign v_cod_unid_organ = unid_organ.cod_unid_organ.

                   run pi_item_compos_demonst_ctbl.

                   /* --- Faixa de Unidades Organiz ---*/
                   /* *********comentado por Rafael Lima*****************************
                   uo_block:
                   for each  unid_organ no-lock
                       where unid_organ.cod_unid_organ >= tt_compos_demonst_cadastro.cod_unid_organ
                       and unid_organ.cod_unid_organ <= tt_compos_demonst_cadastro.cod_unid_organ_fim:

                       if  unid_organ.num_niv_unid_organ = 999
                       or (unid_organ.num_niv_unid_organ < 998 
                       and not can-find(first tt_col_demonst_ctbl
                            where tt_col_demonst_ctbl.ind_orig_val_col_demonst = @%(l_consolidacao) )) then do:
                            next uo_block.
                       end.
                       assign v_cod_unid_organ = unid_organ.cod_unid_organ.

                       run pi_item_compos_demonst_ctbl.
                   end.
                   *******************************************************************/
               end.
            end.
        end.
        else do:
            if v_cod_dwb_user begins 'es_' 
            and v_nom_prog <> "Di rio" /*l_diario*/  then do:
                run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                            Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                            output v_des_tit_ctbl).
            end.
            else do:
                run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                            Input prefer_demonst_ctbl.cod_idioma,
                                            output v_des_tit_ctbl) /*pi_retornar_trad_idiom*/.
            end.
            create tt_item_demonst_ctbl_video.
            assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                   tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes
                   tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + v_des_tit_ctbl
                   tt_item_demonst_ctbl_video.ttv_cod_chave_1  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_2  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_3  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_4  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_5  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_6  = ""
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).
        end.


        /* * Impress’o de Tra»o Antes dos Itens **/
        if  tt_item_demonst_ctbl_cadastro.ind_impres_traco_lin = "Depois" /*l_depois*/  then do:
            create tt_item_demonst_ctbl_video.
            assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = (tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl + 0.1)
                   tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes
                   tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(substring(tt_item_demonst_ctbl_cadastro.ind_carac_traco,1,1),100)
                   tt_item_demonst_ctbl_video.ttv_cod_chave_1  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_2  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_3  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_4  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_5  = ""
                   tt_item_demonst_ctbl_video.ttv_cod_chave_6  = ""
                   tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = 'Chr Espec'
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
                   tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).
        end.

        /* * Impress’o de linhas em branco APOS o Item **/
        if  tt_item_demonst_ctbl_cadastro.num_lin_salto_apos > 0 then do:
            do v_num_contador = 1 to tt_item_demonst_ctbl_cadastro.num_lin_salto_apos:
                create tt_item_demonst_ctbl_video.
                assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = (tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl + 0.2)
                       tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes
                       tt_item_demonst_ctbl_video.tta_des_tit_ctbl = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_1  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_2  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_3  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_4  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_5  = ""
                       tt_item_demonst_ctbl_video.ttv_cod_chave_6  = ""
                       tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst = 'Chr Espec'
                       tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
                       tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).
            end.   
        end.

    end.

    assign v_log_final_proces = yes.

    if  can-find(first tt_input_sdo) then do:

        if v_cod_dwb_user begins 'es_'
        and v_nom_prog <> "Di rio" /*l_diario*/  then do:
             assign v_cod_ult_obj_procesdo = "Leitura dos Saldos Cont beis" /*l_Leitura_saldos_contabeis*/ .
             run pi_grava_ult_objeto (Input v_cod_ult_obj_procesdo).
        end.

        if  search("prgfin/fgl/fgl905zc.r") = ? and search("prgfin/fgl/fgl905zc.py") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl905zc.py".
            else do:
                message getStrTrans("Programa execut vel nÆo foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl905zc.py"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fgl/fgl905zc.py (Input 1,
                                    input table tt_input_sdo,
                                    Input table tt_input_leitura_sdo_demonst,
                                    output p_des_lista_estab,
                                    output table tt_log_erros) /*prg_api_retornar_sdo_ctbl_demonst*/.

        if v_log_sped then do:
            if  search("prgfin/mgl/MGLA204zl.r") = ? and search("prgfin/mgl/MGLA204zl.py") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/MGLA204zl.py".
                else do:
                    message getStrTrans("Programa execut vel nÆo foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/MGLA204zl.py"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgfin/mgl/MGLA204zl.py /*prg_api_demonst_ctbl_sped_recalc_sdo*/.
        end.


        if not v_cod_dwb_user begins 'es_' then do:
            run pi_wait_processing (Input "Calculando Colunas..." /*l_calculando_colunas*/ ,
                                    Input "Calculando Colunas..." /*l_calculando_colunas*/ ).

            disable bt_can2 with frame f_dlg_02_wait_processing.
        end.
        else do:
            assign v_cod_ult_obj_procesdo = "Calculando Colunas..." /*l_calculando_colunas*/ .
            run pi_grava_ult_objeto (Input v_cod_ult_obj_procesdo).
        end.

        for each tt_item_demonst_ctbl_video:
            if tt_item_demonst_ctbl_video.tta_cod_plano_ccusto <> "" then
               assign v_cod_plano_ccusto = tt_item_demonst_ctbl_video.tta_cod_plano_ccusto.

            find tt_item_demonst_ctbl_cadastro
                where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = v_cod_demonst_ctbl
                and   tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                no-error.

            if tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst = "T¡tulo" /*l_titulo*/ 
            or tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/  then
                next.

            assign v_cod_lista_compon = "".
            for each tt_estrut_visualiz_ctbl_cad no-lock
               where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                 and tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:
                assign v_cod_lista_compon = 
                       v_cod_lista_compon + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz          + ';'
                                          + string(tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl) + ';'
                                          + string(tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst)    + ';'.
            end.

            assign tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad = recid(tt_item_demonst_ctbl_cadastro).

            if  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst = "C lculo" /*l_calculo*/   then
                assign tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = no.
            else
                assign tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes.


    /* Begin_Include: i_item_demonst_ctbl_video */
            for each tt_grp_col_demonst_video:


                /* Begin_Include: i_item_demonst_ctbl_video_aux */
                            /* Atualizacao do Valor da Linha */    
                            assign v_val_sdo_ctbl_fim            = 0
                                   v_val_sdo_ctbl_ini            = 0
                                   v_val_sdo_ctbl_db             = 0
                                   v_val_sdo_ctbl_cr             = 0
                                   v_val_movto                   = 0
                                   v_val_apurac_restdo_acum_505  = 0
                                   v_val_apurac_restdo_db_505    = 0
                                   v_val_apurac_restdo_cr_505    = 0
                                   v_val_apurac_restdo_movto_50  = 0
                                   v_val_apurac_restdo_inic_50   = 0
                                   v_qtd_sdo_ctbl_db             = 0
                                   v_qtd_sdo_ctbl_cr             = 0
                                   v_qtd_sdo_ctbl_fim            = 0
                                   v_qtd_sdo_ctbl_inic           = 0
                                   v_qtd_movto                   = 0
                                   v_val_movto_empenh            = 0
                                   v_qtd_movto_empenh            = 0
                                   v_val_orcado                  = 0
                                   v_val_orcado_sdo              = 0
                                   v_qtd_orcado                  = 0
                                   v_qtd_orcado_sdo              = 0
                                   v_num_cont_1                  = 0.
                /* End_Include: i_item_demonst_ctbl_video_aux */


                for each tt_rel_grp_col_compos_demonst
                    where tt_rel_grp_col_compos_demonst.ttv_rec_grp_col_demonst_ctbl = recid(tt_grp_col_demonst_video):

                    find tt_compos_demonst_cadastro
                        where recid(tt_compos_demonst_cadastro) = tt_rel_grp_col_compos_demonst.ttv_rec_compos_demonst_ctbl
                        no-error.
                    if  tt_compos_demonst_cadastro.num_seq_demonst_ctbl <> integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl) then
                        next.

                    if v_log_orcto_cta_sint then do:
                        EMPTY TEMP-TABLE tt_lista_cta_restric.
                        for each tt_relacto_item_retorna
                            where tt_relacto_item_retorna.tta_num_seq          = tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo
                            and   tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                            find tt_retorna_sdo_ctbl_demonst
                                where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_item_retorna.ttv_rec_ret
                                no-error.
                            if  avail tt_retorna_sdo_ctbl_demonst then do:
                                if  tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo = "Or‡amento" /*l_orcamento*/  then do:
                                    find tt_cta_ctbl_demonst
                                        where tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
                                        and   tt_cta_ctbl_demonst.tta_cod_cta_ctbl       = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
                                        no-lock no-error.
                                    if  avail tt_cta_ctbl_demonst
                                    and tt_cta_ctbl_demonst.tta_ind_espec_cta_ctbl = "Sint‚tica" /*l_sintetica*/  then do:
                                        run pi_localiza_tt_cta_ctbl_analitica_demonst (Input tt_cta_ctbl_demonst.tta_cod_cta_ctbl) /*pi_localiza_tt_cta_ctbl_analitica_demonst*/.
                                    end.
                                end.
                            end.
                        end.    
                    end.
                    relacto_block:
                    for each tt_relacto_item_retorna 
                        where tt_relacto_item_retorna.tta_num_seq             = tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo
                        and   tt_relacto_item_retorna.ttv_rec_item_demonst    = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                        find tt_retorna_sdo_ctbl_demonst
                            where tt_retorna_sdo_ctbl_demonst.ttv_rec_ret_sdo_ctbl = tt_relacto_item_retorna.ttv_rec_ret
                            no-error.
                        if  avail tt_retorna_sdo_ctbl_demonst then do:

                            assign v_cod_unid_organ   =  tt_retorna_sdo_ctbl_demonst.tta_cod_unid_organ_orig
                                   v_cod_plano_ccusto =  tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto.

                            if  v_log_gera_dados_xml then do:

                                if  v_log_impr_cta_sem_sdo or
                                   (tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr  <> 0 or
                                    tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db  <> 0 or
                                    tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim <> 0) then
                                    run pi_ttPeriodGLBalanceInformation_XML /*pi_ttPeriodGLBalanceInformation_XML*/.

                            end.

                            /* ****
                                Quando o item for do tipo c lculo nÆo deve somar o que estiver na exce‡Æo da composi‡Æo que est 
                                sendo lida - Rodrigo 
                            *****/
                            if  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst        = "C lculo" /*l_calculo*/ 
                                and tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "Valor Conta" /*l_valor_conta*/ 
                            then do:
                                assign v_cod_cta_ctbl_exec     = replace(tt_compos_demonst_cadastro.cod_cta_ctbl_excec,"#", ".").

                                if v_cod_cta_ctbl_exec <> fill(chr(46), length(tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl))
                                    and tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl matches v_cod_cta_ctbl_exec
                                    then do:
                                        next relacto_block.
                                end.
                            end.
                            /* ****************/


                            /* **** RAFA ******/
                            if  v_log_orcto_cta_sint
                            and tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo = "Or‡amento" /*l_orcamento*/  then do:
                                find tt_cta_ctbl_demonst
                                    where tt_cta_ctbl_demonst.tta_cod_plano_cta_ctbl = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
                                    and   tt_cta_ctbl_demonst.tta_cod_cta_ctbl       = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
                                   no-lock no-error.
                                if avail tt_cta_ctbl_demonst 
                                   and tt_cta_ctbl_demonst.tta_ind_espec_cta_ctbl = "Sint‚tica" /*l_sintetica*/   then do:
                                    run pi_localiza_tt_cta_ctbl_analitica_demonst (Input tt_cta_ctbl_demonst.tta_cod_cta_ctbl) /* pi_localiza_tt_cta_ctbl_analitica_demonst*/.
                                end.

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
                                                if tt_retorna_sdo_orcto_ccusto.tta_val_orcado = 0.01 then next. else
                                                if  tt_compos_demonst_cadastro.log_inverte_val then

                                                
                                                    assign v_val_orcado                  = v_val_orcado - tt_retorna_sdo_orcto_ccusto.tta_val_orcado     
                                                           v_val_orcado_sdo              = v_val_orcado_sdo - tt_retorna_sdo_orcto_ccusto.tta_val_orcado_sdo 
                                                           v_qtd_orcado                  = v_qtd_orcado - tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado     
                                                           v_qtd_orcado_sdo              = v_qtd_orcado_sdo - tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado_sdo.
                                                else    
                                                    assign v_val_orcado                  = v_val_orcado + tt_retorna_sdo_orcto_ccusto.tta_val_orcado     
                                                           v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_val_orcado_sdo 
                                                           v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado     
                                                           v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_orcto_ccusto.tta_qtd_orcado_sdo.
                                            end.
                                        end.
                                        next.
                                    end.
                                end.
                            end.
                            /* ****************/

                            if  tt_compos_demonst_cadastro.log_inverte_val then do:
                                assign v_val_sdo_ctbl_fim            = v_val_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim
                                       v_val_movto                   = v_val_movto - tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl
                                       v_val_sdo_ctbl_ini            = v_val_sdo_ctbl_ini - (tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_val_movto_ctbl)
                                       v_val_sdo_ctbl_db             = v_val_sdo_ctbl_db  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db
                                       v_val_sdo_ctbl_cr             = v_val_sdo_ctbl_cr  + tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr
                                       v_qtd_sdo_ctbl_fim            = v_qtd_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim
                                       v_qtd_movto                   = v_qtd_movto - tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl
                                       v_qtd_sdo_ctbl_inic           = v_qtd_sdo_ctbl_inic - (tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim - tt_retorna_sdo_ctbl_demonst.ttv_qtd_movto_ctbl)
                                       v_qtd_sdo_ctbl_db             = v_qtd_sdo_ctbl_db + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_db
                                       v_qtd_sdo_ctbl_cr             = v_qtd_sdo_ctbl_cr + tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_cr
                                       v_val_apurac_restdo_acum_505  = v_val_apurac_restdo_acum_505 - tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum
                                       v_val_apurac_restdo_db_505    = v_val_apurac_restdo_db_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db
                                       v_val_apurac_restdo_cr_505    = v_val_apurac_restdo_cr_505 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr
                                       v_val_apurac_restdo_movto_50 = v_val_apurac_restdo_movto_50 - tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo
                                       v_val_apurac_restdo_inic_50   = v_val_apurac_restdo_inic_50 - (tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum - tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo)
                                       v_val_movto_empenh            = v_val_movto_empenh - tt_retorna_sdo_ctbl_demonst.tta_val_movto_empenh
                                       v_qtd_movto_empenh            = v_qtd_movto_empenh - tt_retorna_sdo_ctbl_demonst.tta_qtd_movto_empenh.

                                       if tt_retorna_sdo_ctbl_demonst.tta_val_orcado  = 0.01 then next.
                                       else
                                       assign  v_val_orcado                  = v_val_orcado - tt_retorna_sdo_ctbl_demonst.tta_val_orcado     
                                               v_val_orcado_sdo              = v_val_orcado_sdo - tt_retorna_sdo_ctbl_demonst.tta_val_orcado_sdo 
                                               v_qtd_orcado                  = v_qtd_orcado - tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado     
                                               v_qtd_orcado_sdo              = v_qtd_orcado_sdo - tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado_sdo.
                                end.
                            else do:   
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
                                       v_val_apurac_restdo_movto_50  = v_val_apurac_restdo_movto_50 + tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo
                                       v_val_apurac_restdo_inic_50   = v_val_apurac_restdo_inic_50 + (tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum - tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo)
                                       v_val_movto_empenh            = v_val_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_val_movto_empenh
                                       v_qtd_movto_empenh            = v_qtd_movto_empenh + tt_retorna_sdo_ctbl_demonst.tta_qtd_movto_empenh.


                                       if tt_retorna_sdo_ctbl_demonst.tta_val_orcado  = 0.01 then next.
                                       else
                              assign   v_val_orcado                  = v_val_orcado + tt_retorna_sdo_ctbl_demonst.tta_val_orcado     
                                       v_val_orcado_sdo              = v_val_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_val_orcado_sdo 
                                       v_qtd_orcado                  = v_qtd_orcado + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado     
                                       v_qtd_orcado_sdo              = v_qtd_orcado_sdo + tt_retorna_sdo_ctbl_demonst.tta_qtd_orcado_sdo.
                           end.
                        end.
                    end.
                end.
                run pi_item_demonst_ctbl_video_trata_sdo (Input no) /*pi_item_demonst_ctbl_video_trata_sdo*/.
            end.

            assign v_des_visualiz     = tt_item_demonst_ctbl_video.ttv_cod_chave_1 + chr(59)
                                      + tt_item_demonst_ctbl_video.ttv_cod_chave_2 + chr(59)
                                      + tt_item_demonst_ctbl_video.ttv_cod_chave_3 + chr(59)
                                      + tt_item_demonst_ctbl_video.ttv_cod_chave_4 + chr(59)
                                      + tt_item_demonst_ctbl_video.ttv_cod_chave_5 + chr(59)
                                      + tt_item_demonst_ctbl_video.ttv_cod_chave_6.

            if  tt_item_demonst_ctbl_cadastro.des_tit_ctbl = ""
            then do: 
                assign v_num_cont_1 = 0.
                if v_log_tit_demonst then do: 
                    /* 218397 Na parametriza‡Æo, ‚ possivel informar mais de uma coluna titulo */
                    for each tt_col_demonst_ctbl no-lock
                        where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                          and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T¡tulo" /*l_titulo*/ :

                        assign v_num_cont_1 = v_num_cont_1 + 1
                               v_num_cont_2 = v_num_cont_1.

                        if lookup("Conta Cont bil" /*l_conta_contabil*/ , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)) <> 0 then
                            assign v_cod_plano_cta_ctbl = tt_item_demonst_ctbl_video.tta_cod_plano_cta_ctbl.       

                        run pi_busca_descricoes_video.
                        /* * Controle de tabula»’o segundo Par³metros de Impress’o do Item Demonstrativo **/
                        if tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst > 0 then do:
                            if tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_1.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                            assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                        end.
                    end.
                end.
                else do:        
                    find first tt_col_demonst_ctbl no-lock
                        where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                          and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T¡tulo" /*l_titulo*/  no-error.
                    if avail  tt_col_demonst_ctbl then do:
                        if lookup("Conta Cont bil" /*l_conta_contabil*/ , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)) <> 0 then
                            assign v_cod_plano_cta_ctbl = tt_item_demonst_ctbl_video.tta_cod_plano_cta_ctbl.
                        run pi_busca_descricoes_video.
                        /* * Controle de tabula»’o segundo Par³metros de Impress’o do Item Demonstrativo **/
                        if tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst > 0 then do:
                            if tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_1.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                            if tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                                assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                            assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                        end.
                    end.
                end.      
            end.
        end.
    end.

    /* --- Processa os Itens FORMULA ---*/
    assign v_log_final_proces = yes.
    for each  tt_item_demonst_ctbl_cadastro
        where tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/  :
        for each  tt_compos_demonst_cadastro no-lock
            where tt_compos_demonst_cadastro.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
            and   tt_compos_demonst_cadastro.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
            break by tt_compos_demonst_cadastro.num_seq_demonst_ctbl:
            run pi_item_compos_demonst_formul.
        end.
    end.

    /* --- Calcula Variacao e Formulas das Colunas ---*/
    if  can-find(first tt_col_demonst_ctbl
        where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
        and  (tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "F¢rmula" /*l_formula*/ 
        or    tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "Varia‡Æo" /*l_variacao*/ )) then do:
        for each tt_item_demonst_ctbl_video:
            find tt_item_demonst_ctbl_cadastro
                where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = v_cod_demonst_ctbl
                and   tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                no-error.
            run pi_col_demons_ctbl_video_more_3.
        end.
    end.

    /* --- Processa os Itens FORMULA somente para as colunas de f¢rmula ---*/
    assign v_log_final_proces = yes.
    for each  tt_item_demonst_ctbl_cadastro
        where tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/  :
        for each  tt_compos_demonst_cadastro no-lock
            where tt_compos_demonst_cadastro.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
            and   tt_compos_demonst_cadastro.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
            break by tt_compos_demonst_cadastro.num_seq_demonst_ctbl:
            if index(tt_compos_demonst_cadastro.des_formul_ctbl,'/') <> 0 
               or index(tt_compos_demonst_cadastro.des_formul_ctbl,'*') <> 0 then 
                run pi_item_compos_demonst_formul_2.
        end.
    end.

    /* --- Calcula Analise Vertical ---*/
    if  can-find(first  tt_col_demonst_ctbl
        where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/  
        and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     = "An. Vertical" /*l_analise_vertical*/  ) then do:
        for each tt_item_demonst_ctbl_video:
            run pi_col_demons_ctbl_video_analise_vertical.
        end.
    end.

    /* --- Elimina registros sem saldo conforme o parametro ---*/
    if v_cod_dwb_user begins 'es_' 
       and v_nom_prog <> "Di rio" /*l_diario*/  then do:
        assign v_log_impr_cta_sem_sdo = (entry(14, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
       if  num-entries(dwb_rpt_param.cod_dwb_parameters,chr(10)) >= 37 then
           assign v_log_impr_acum_zero = (entry(37, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
    end.
    else do:
        assign v_log_impr_cta_sem_sdo = prefer_demonst_ctbl.log_impr_cta_sem_sdo.
        &if '{&emsfin_version}' >= '5.06' &then
            assign v_log_impr_acum_zero = prefer_demonst_ctbl.log_impr_acum_zero.
        &else
            assign v_log_impr_acum_zero = prefer_demonst_ctbl.log_livre_1.
        &endif
    end.
    if  v_log_impr_cta_sem_sdo = no then do:
        for each tt_item_demonst_ctbl_video
            where tt_item_demonst_ctbl_video.ttv_cod_chave_1 <> "" :

            find tt_item_demonst_ctbl_cadastro
                where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = v_cod_demonst_ctbl
                and   tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                no-error.

            /* Passa a imprimir os totalizadores zerados conforme atividade 126750.*/
            if  v_log_impr_acum_zero and
                v_cod_demonst_ctbl <> "" and
                tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/  then 
                next.

            if  (not can-find(first tt_valor_demonst_ctbl_video
                where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                and   tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0)) 
            then do:
                for each tt_valor_demonst_ctbl_video
                    where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                    delete tt_valor_demonst_ctbl_video.
                end.
                if tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/  
                then do:
                    for each btt_item_demonst_ctbl_video
                        where  integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl) = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl: 
                        delete btt_item_demonst_ctbl_video. 
                    end.    
                end.
                else
                    delete tt_item_demonst_ctbl_video.
            end.
        end.
    end.
    else do:
        /* Cria registros com saldo zero */
        for each tt_input_sdo:
            assign v_num_contador = 1
                   v_cod_c_1 = "" 
                   v_cod_c_2 = "" 
                   v_cod_c_3 = "" 
                   v_cod_c_4 = "" 
                   v_cod_c_5 = "" 
                   v_cod_c_6 = "" 
                   v_cod_1 = "" 
                   v_cod_2 = "" 
                   v_cod_3 = "" 
                   v_cod_4 = "" 
                   v_cod_5 = "" 
                   v_cod_6 = "".

            assign v_cdn_tot_con_excec    = num-entries(tt_input_sdo.ttv_cod_cta_ctbl_excec, chr(10))
                   v_cdn_tot_ccusto_excec = num-entries(tt_input_sdo.ttv_cod_ccusto_excec, chr(10))
                   v_cdn_tot_proj_excec   = num-entries(tt_input_sdo.ttv_cod_proj_financ_excec, chr(10)).

            find first tt_rel_grp_col_compos_demonst
                where tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo = int(entry(1,tt_input_sdo.ttv_cod_seq,chr(10)))
                no-lock no-error.

            find tt_compos_demonst_cadastro
                where recid(tt_compos_demonst_cadastro) = tt_rel_grp_col_compos_demonst.ttv_rec_compos_demonst_ctbl
                no-lock no-error.

            find tt_item_demonst_ctbl_cadastro
                where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = tt_compos_demonst_cadastro.cod_demonst_ctbl
                and   tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = tt_compos_demonst_cadastro.num_seq_demonst_ctbl
                no-lock no-error.

            /* ALTERACAO RAFAEL */
            assign v_cod_estrut       = ""
                   v_cod_lista_compon = "".
            for each tt_estrut_visualiz_ctbl_cad no-lock
                where tt_estrut_visualiz_ctbl_cad.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                and   tt_estrut_visualiz_ctbl_cad.num_seq_demonst_ctbl = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl:
                assign v_cod_estrut = v_cod_estrut 
                                    + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz + chr(10).
                assign v_cod_lista_compon = v_cod_lista_compon 
                                          + tt_estrut_visualiz_ctbl_cad.ind_inform_estrut_visualiz          + ';'
                                          + string(tt_estrut_visualiz_ctbl_cad.log_tot_inform_demonst_ctbl) + ';'
                                          + string(tt_estrut_visualiz_ctbl_cad.log_descr_inform_demonst)    + ';'.
            end.
            /* FIM ALTERACAO RAFAEL */

            run pi_cria_item_sem_sdo.
        end.
        if  v_log_impr_acum_zero = no and
            v_cod_demonst_ctbl <> ""
        then do:
            for each tt_item_demonst_ctbl_video
                where tt_item_demonst_ctbl_video.ttv_cod_chave_1 <> "" :
                find tt_item_demonst_ctbl_cadastro
                    where tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = v_cod_demonst_ctbl
                    and   tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = integer(tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                    no-error.
                if  (not can-find(first tt_valor_demonst_ctbl_video
                    where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                    and   tt_valor_demonst_ctbl_video.ttv_val_col_1 <> 0))
                then do:
                    if  tt_item_demonst_ctbl_cadastro.ind_tip_compos_demonst = "F¢rmula" /*l_formula*/ 
                    then do:
                        for each tt_valor_demonst_ctbl_video
                            where tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                            delete tt_valor_demonst_ctbl_video.
                        end.
                        for each btt_item_demonst_ctbl_video
                            where  integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl) = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl: 
                            delete btt_item_demonst_ctbl_video. 
                        end.
                    end /* if */.
                end /* if */.
            end.
        end /* if */.
    end.
    /* End_Include: i_item_demonst_ctbl_video_aux */


    if v_cod_dwb_user begins 'es_'
    and v_nom_prog <> "Di rio" /*l_diario*/  then do:
         assign v_cod_ult_obj_procesdo = "ImpressÆo Conclu¡da" /*l_Impressao_concluida*/ .
         run pi_grava_ult_objeto (Input v_cod_ult_obj_procesdo).
    end.

    /* Elimina todos os registros da temp-table */
    EMPTY TEMP-TABLE tt_input_sdo.
    EMPTY TEMP-TABLE tt_input_leitura_sdo_demonst.

END PROCEDURE. /* pi_item_demonst_ctbl_video */
/*****************************************************************************
** Procedure Interna.....: pi_compos_unid_organ_demonst_ctbl
** Descricao.............: pi_compos_unid_organ_demonst_ctbl
** Criado por............: fut12171
** Criado em.............: 11/03/2002 09:20:12
** Alterado por..........: fut12171
** Alterado em...........: 11/03/2002 10:05:29
*****************************************************************************/
PROCEDURE pi_compos_unid_organ_demonst_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.


    /************************* Parameter Definition End *************************/

    find emsuni.unid_organ no-lock
        where unid_organ.cod_unid_organ = p_cod_unid_organ  no-error.
    if  avail unid_organ then do:
        assign v_cod_unid_organ      = unid_organ.cod_unid_organ
               v_num_niv_unid_organ  = unid_organ.num_niv_unid_organ
               v_cod_unid_organ_inic = tt_compos_demonst_cadastro.cod_unid_organ
               v_cod_unid_organ_fim  = tt_compos_demonst_cadastro.cod_unid_organ_fim
               v_log_faixa_uo        = yes. /* --- Mudou a faixa de UOïs nas composi‡äes ---*/

        run pi_item_compos_demonst_ctbl.

        assign v_log_faixa_uo = no.
    end.
END PROCEDURE. /* pi_compos_unid_organ_demonst_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_item_compos_demonst_ctbl
** Descricao.............: pi_item_compos_demonst_ctbl
** Criado por............: Dalpra
** Criado em.............: 19/02/2001 10:32:59
** Alterado por..........: corp45760
** Alterado em...........: 16/03/2011 15:50:33
*****************************************************************************/
PROCEDURE pi_item_compos_demonst_ctbl:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_cta_ctbl
        for cta_ctbl.
    &endif
    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_cta_ctbl_2
        for cta_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /* --- Plano de Contas ---*/
    if  v_cod_plano_cta_ctbl <> tt_compos_demonst_cadastro.cod_plano_cta_ctbl then do:
        find plano_cta_ctbl 
           where plano_cta_ctbl.cod_plano_cta_ctbl = tt_compos_demonst_cadastro.cod_plano_cta_ctbl no-lock no-error.
        if  avail plano_cta_ctbl then
            assign v_cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
                   v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
                   v_num_format_cta_ctbl = length (plano_cta_ctbl.cod_format_cta_ctbl).
        else
            assign v_cod_plano_cta_ctbl  = ""
                   v_cod_format_cta_ctbl = fill('x', 20)
                   v_num_format_cta_ctbl = 0.
    end.

    /* --- Plano Ccusto ---*/
    if  v_cod_plano_ccusto <> tt_compos_demonst_cadastro.cod_plano_ccusto then do:
        find plano_ccusto no-lock
            where plano_ccusto.cod_empresa      = tt_compos_demonst_cadastro.cod_unid_organ
              and plano_ccusto.cod_plano_ccusto = tt_compos_demonst_cadastro.cod_plano_ccusto no-error.
        if  avail plano_ccusto then
            assign v_cod_plano_ccusto  = plano_ccusto.cod_plano_ccusto
                   v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
                   v_num_format_ccusto_compos = length (plano_ccusto.cod_format_ccusto).
        else
            assign v_cod_plano_ccusto  = ""
                   v_cod_format_ccusto = fill('x', 11)
                   v_num_format_ccusto_compos = 0.
    end.
    /* --- Projeto ---*/
    assign v_num_format_proj_financ = length (param_geral_ems.cod_format_proj_financ)
           v_cod_format_proj_financ = param_geral_ems.cod_format_proj_financ.

    /* Parte fixa e excecao */
    assign v_cod_cta_ctbl_pfixa    = replace (tt_compos_demonst_cadastro.cod_cta_ctbl_pfixa, "#", ".")
           v_cod_cta_ctbl_pfixa    = substr (v_cod_cta_ctbl_pfixa, 1 , v_num_format_cta_ctbl)
           v_cod_cta_ctbl_exec     = replace(tt_compos_demonst_cadastro.cod_cta_ctbl_excec,"#", ".")
           v_cod_cta_ctbl_exec     = substr (v_cod_cta_ctbl_exec, 1 , v_num_format_cta_ctbl)
           v_cod_ccusto_pfixa      = replace (tt_compos_demonst_cadastro.cod_ccusto_pfixa, "#", ".")
           v_cod_ccusto_pfixa      = substr (v_cod_ccusto_pfixa, 1 , v_num_format_ccusto_compos)
           v_cod_ccusto_exec       = replace(tt_compos_demonst_cadastro.cod_ccusto_excec, "#", ".")
           v_cod_ccusto_exec       = substr (v_cod_ccusto_exec, 1 , v_num_format_ccusto_compos)
           v_cod_proj_financ_pfixa = replace (tt_compos_demonst_cadastro.cod_proj_financ_pfixa, "#", ".")
           v_cod_proj_financ_pfixa = substr (v_cod_proj_financ_pfixa, 1 , v_num_format_proj_financ)
           v_cod_proj_financ_excec = replace(tt_compos_demonst_cadastro.tta_cod_proj_financ_excec,"#", ".")
           v_cod_proj_financ_excec = substr (v_cod_proj_financ_excec, 1 , v_num_format_proj_financ).

    /* Faixa de informacao a ser procurada */
    assign v_cod_cta_ctbl_ini     = tt_compos_demonst_cadastro.cod_cta_ctbl_inic
           v_cod_cta_ctbl_fim     = tt_compos_demonst_cadastro.cod_cta_ctbl_fim
           v_cod_ccusto_ini       = tt_compos_demonst_cadastro.cod_ccusto_inic
           v_cod_ccusto_fim       = tt_compos_demonst_cadastro.cod_ccusto_fim
           v_cod_estab_ini        = tt_compos_demonst_cadastro.cod_estab_inic
           v_cod_estab_fim        = tt_compos_demonst_cadastro.cod_estab_fim
           v_cod_unid_organ_ini   = tt_compos_demonst_cadastro.cod_unid_organ
           v_cod_unid_organ_fim   = tt_compos_demonst_cadastro.cod_unid_organ_fim       
           v_cod_unid_negoc_ini   = tt_compos_demonst_cadastro.cod_unid_negoc_inic
           v_cod_unid_negoc_fim   = tt_compos_demonst_cadastro.cod_unid_negoc_fim
           v_cod_proj_financ_ini  = tt_compos_demonst_cadastro.tta_cod_proj_financ_inicial
           v_cod_proj_financ_fim  = tt_compos_demonst_cadastro.cod_proj_financ_fim.

    assign v_ind_espec_cta        = tt_compos_demonst_cadastro.ind_espec_cta_ctbl_consid
           v_log_espec_sdo_ccusto = tt_compos_demonst_cadastro.log_ccusto_sint.

    /* fo 1023547 - para item tipo de linha c lculo, nÆo apresentava o total corretamente 
    if tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst = @%(l_calculo)
       and v_ind_espec_cta = @%(l_todas) then 
            assign v_ind_espec_cta = @%(l_analitica).

    desfeito pois ocasionou novo problema, nÆo totalizava quando a faixa era de contas sint‚ticas
    ex. 1000000 a 1000000 */ 


    find b_cta_ctbl
        where b_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        and   b_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl_ini
        no-lock no-error.
    if not avail b_cta_ctbl then 
        find first b_cta_ctbl
            where b_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
            and   b_cta_ctbl.cod_cta_ctbl       > v_cod_cta_ctbl_ini
            no-lock no-error.

    find b_cta_ctbl_2
        where b_cta_ctbl_2.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        and   b_cta_ctbl_2.cod_cta_ctbl       = v_cod_cta_ctbl_fim
        no-lock no-error.
    if not avail b_cta_ctbl_2 then 
       find last b_cta_ctbl_2
            where b_cta_ctbl_2.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
            and   b_cta_ctbl_2.cod_cta_ctbl       < v_cod_cta_ctbl_fim
            no-lock no-error.

    /* composi‡Æo definida como esp‚cia = todas:
       controle criado para os acumuladores com valores definidos por itens definidos por
       tipo de linha "c lculo"/"valor conta" tenham o mesmo valor apresentado para acumuladores com valores definidos
       por itens de tipo de linha "valor"/"valor conta". (cfe. funcionamento do ems 5.04) - atividade 198030 - cliente que fez a migra‡Æo".
     */  

    if  v_cod_cta_ctbl_ini <> v_cod_cta_ctbl_fim and
        v_ind_espec_cta =  "Todas" /*l_todas*/  and
        tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst = "C lculo" /*l_calculo*/ 
    then do:
        /* Para item tipo de linha c lculo, nÆo apresentava o total corretamente nos acumuladores para faixa de contas 
           de "sint‚tica - anal¡tica" ou  "anal¡tica - anal¡tica de estrutura diferentes"
           e esp‚cie informada como "todas" .
           Esp‚cie  "sint‚tica" pelos testes nÆo pode ser aplicado a mesma regra  */

        if  avail b_cta_ctbl and 
            b_cta_ctbl.ind_espec_cta_ctbl <> "Sint‚tica" /*l_sintetica*/   then do:
            assign v_ind_espec_cta = "Anal¡tica" /*l_analitica*/ .
        end.
        else if  avail b_cta_ctbl_2 and 
                 b_cta_ctbl_2.ind_espec_cta_ctbl <> "Sint‚tica" /*l_sintetica*/  then do:
                 assign v_ind_espec_cta = "Anal¡tica" /*l_analitica*/ .
        end.

    end.


    /* fo 1069713 - quando cta cont bil inicio =  cta cont bil fim e se for uma conta sint‚tica, se informar esp‚cie de conta = todas nÆo gera
      corretamente o total(acumulador) , pois neste caso s¢ gera total de conta sint‚tica e a esp‚cie = todas busca total somente das contas anal¡ticas*/

    if  v_cod_cta_ctbl_ini = v_cod_cta_ctbl_fim then do:
        find b_cta_ctbl
        where b_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        and   b_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl_ini
        no-lock no-error.

        if  avail b_cta_ctbl
        and v_ind_espec_cta = "Todas" /*l_todas*/                      
        and b_cta_ctbl.ind_espec_cta_ctbl = "Sint‚tica" /*l_sintetica*/   then do:
            assign v_ind_espec_cta = b_cta_ctbl.ind_espec_cta_ctbl.
        end.
    end.    

    run pi_col_demonst_ctbl_video.
END PROCEDURE. /* pi_item_compos_demonst_ctbl */
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
** Procedure Interna.....: pi_col_demonst_ctbl_video
** Descricao.............: pi_col_demonst_ctbl_video
** Criado por............: dalpra
** Criado em.............: 04/04/2001 10:39:24
** Alterado por..........: rafaelposse
** Alterado em...........: 23/01/2014 09:41:37
*****************************************************************************/
PROCEDURE pi_col_demonst_ctbl_video:

    /************************* Variable Definition Begin ************************/

    def var v_cod_usuario
        as character
        format "x(12)":U
        label "Usu rio"
        column-label "Usu rio"
        no-undo.
    def var v_cod_ccusto_exec_prefer         as character       no-undo. /*local*/
    def var v_cod_ccusto_pfixa_prefer        as character       no-undo. /*local*/
    def var v_cod_ccusto_prefer_fim          as character       no-undo. /*local*/
    def var v_cod_ccusto_prefer_inic         as character       no-undo. /*local*/
    def var v_cod_cta_ctbl_exec_prefer       as character       no-undo. /*local*/
    def var v_cod_cta_ctbl_pfixa_prefer      as character       no-undo. /*local*/
    def var v_cod_cta_ctbl_prefer_fim        as character       no-undo. /*local*/
    def var v_cod_cta_ctbl_prefer_inic       as character       no-undo. /*local*/
    def var v_cod_estab_prefer_fim           as character       no-undo. /*local*/
    def var v_cod_estab_prefer_inic          as character       no-undo. /*local*/
    def var v_cod_proj_financ_exec_prefer    as character       no-undo. /*local*/
    def var v_cod_proj_financ_pfixa_prefer   as character       no-undo. /*local*/
    def var v_cod_proj_financ_prefer_fim     as character       no-undo. /*local*/
    def var v_cod_proj_financ_prefer_inic    as character       no-undo. /*local*/
    def var v_cod_unid_negoc_prefer_fim      as character       no-undo. /*local*/
    def var v_cod_unid_negoc_prefer_inic     as character       no-undo. /*local*/
    def var v_cod_unid_organ_prefer_fim      as character       no-undo. /*local*/
    def var v_cod_unid_organ_prefer_inic     as character       no-undo. /*local*/
    def var v_num_entry                      as integer         no-undo. /*local*/
    def var v_num_period_ano                 as integer         no-undo. /*local*/
    def var v_num_period_mes                 as integer         no-undo. /*local*/
    def var v_num_quant_anos                 as integer         no-undo. /*local*/
    def var v_qtd_period                     as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    col_block:
    for each  tt_grp_col_demonst_video no-lock:

        if  v_cod_dwb_user begins 'es_'
        and v_nom_prog <> "Di rio" /*l_diario*/  then do:
            assign v_cod_usuario               = entry(34,dwb_rpt_param.cod_dwb_parameters,chr(10))
                   v_cod_demonst_ctbl          = entry(1,dwb_rpt_param.cod_dwb_parameters,chr(10))
                   v_cod_padr_col_demonst_ctbl = entry(2,dwb_rpt_param.cod_dwb_parameters,chr(10)).
        end.
        else do:
            assign v_cod_usuario               = prefer_demonst_ctbl.cod_usuario
                   v_cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
                   v_cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl.    
        end.
        /* - Retirado Validacao Chamado TIDJ28 
        if  tt_grp_col_demonst_video.ttv_cod_cenar_ctbl = ? 
        or  tt_grp_col_demonst_video.ttv_cod_cenar_ctbl = ""
        or  tt_grp_col_demonst_video.ttv_cod_cenar_ctbl = " " then do:
        ----------------------------*/ 

        find conjto_prefer_demonst no-lock
             where conjto_prefer_demonst.cod_usuario               = v_cod_usuario
               and conjto_prefer_demonst.cod_demonst_ctbl          = v_cod_demonst_ctbl
               and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               and conjto_prefer_demonst.num_conjto_param_ctbl     = tt_grp_col_demonst_video.tta_num_conjto_param_ctbl no-error.
        if  avail conjto_prefer_demonst then do:
            assign tt_grp_col_demonst_video.ttv_cod_cenar_ctbl       = conjto_prefer_demonst.cod_cenar_ctbl
                   tt_grp_col_demonst_video.ttv_cod_finalid_econ     = conjto_prefer_demonst.cod_finalid_econ
                   tt_grp_col_demonst_video.ttv_val_cotac_indic_econ = conjto_prefer_demonst.val_cotac_indic_econ
                   tt_grp_col_demonst_video.ttv_cod_unid_negoc_fim   = conjto_prefer_demonst.cod_unid_negoc_fim
                   tt_grp_col_demonst_video.ttv_cod_unid_negoc_ini   = conjto_prefer_demonst.cod_unid_negoc_inic
                   tt_grp_col_demonst_video.ttv_cod_estab_fim        = conjto_prefer_demonst.cod_estab_fim
                   tt_grp_col_demonst_video.ttv_cod_estab_inic       = conjto_prefer_demonst.cod_estab_inic.

            /* Decimais Chile */
            if  v_log_funcao_tratam_dec then do:
                create tt_col_demonst_ctbl_ext.
                assign tt_col_demonst_ctbl_ext.ttv_cod_padr_col_demonst  = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                       tt_col_demonst_ctbl_ext.ttv_num_conjto_param_ctbl = conjto_prefer_demonst.num_conjto_param_ctbl    
                       tt_col_demonst_ctbl_ext.ttv_cod_moed_finalid      = conjto_prefer_demonst.cod_finalid_econ_apres.
            end.


            &if '{&emsfin_version}' > '5.05' &then
                assign tt_grp_col_demonst_video.ttv_cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                       tt_grp_col_demonst_video.tta_cod_unid_orctaria   = conjto_prefer_demonst.cod_unid_orctaria
                       tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl
                       tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl  = conjto_prefer_demonst.num_seq_orcto_ctbl.
            &else
                assign tt_grp_col_demonst_video.ttv_cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario
                       tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl
                       tt_grp_col_demonst_video.tta_cod_unid_orctaria   = entry(1,conjto_prefer_demonst.cod_livre_1,chr(10))
                       tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl  = int(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))).
            &endif

            if  v_cod_demonst_ctbl <> "" then do:
                assign tt_grp_col_demonst_video.ttv_cod_cta_ctbl_ini           = conjto_prefer_demonst.cod_cta_ctbl_inic
                       tt_grp_col_demonst_video.ttv_cod_cta_ctbl_fim           = conjto_prefer_demonst.cod_cta_ctbl_fim
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = conjto_prefer_demonst.cod_unid_organ_prefer_inic
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = conjto_prefer_demonst.cod_unid_organ_prefer_fim
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_ini         = conjto_prefer_demonst.cod_unid_organ_inic
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_fim         = conjto_prefer_demonst.cod_unid_organ_fim
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec       = conjto_prefer_demonst.cod_cta_ctbl_prefer_excec
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa       = conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa.

                if  v_cod_unid_organ_sub <> '' then
                    assign tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = v_cod_unid_organ_sub
                           tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = v_cod_unid_organ_sub.                       

                &if  '{&emsfin_version}' > '5.05' &then
                     assign tt_grp_col_demonst_video.ttv_cod_proj_financ_inic         = conjto_prefer_demonst.cod_proj_financ_inicial
                            tt_grp_col_demonst_video.ttv_cod_proj_financ_fim          = conjto_prefer_demonst.cod_proj_financ_fim
                            tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec = conjto_prefer_demonst.cod_proj_financ_excec
                            tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa = conjto_prefer_demonst.cod_proj_financ_pfixa
                            tt_grp_col_demonst_video.ttv_cod_ccusto_inic              = conjto_prefer_demonst.cod_ccusto_inic
                            tt_grp_col_demonst_video.ttv_cod_ccusto_fim               = conjto_prefer_demonst.cod_ccusto_fim
                            tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec      = conjto_prefer_demonst.cod_ccusto_excec
                            tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa      = conjto_prefer_demonst.cod_ccusto_pfixa
                            tt_grp_col_demonst_video.ttv_cod_exec_period_1            = ""
                            tt_grp_col_demonst_video.ttv_cod_exec_period_2            = "".
                &else
                     find tab_livre_emsfin no-lock
                          where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                            and   tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                            and   tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                            and   tab_livre_emsfin.cod_compon_2_idx_tab = STRING(conjto_prefer_demonst.num_conjto_param_ctbl)
                          no-error.
                     if  avail tab_livre_emsfin then do:
                         assign tt_grp_col_demonst_video.ttv_cod_proj_financ_inic         = entry(1, tab_livre_emsfin.cod_livre_1, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_proj_financ_fim          = entry(2, tab_livre_emsfin.cod_livre_1, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec = entry(3, tab_livre_emsfin.cod_livre_1, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa = entry(4, tab_livre_emsfin.cod_livre_1, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_ccusto_inic              = entry(1, tab_livre_emsfin.cod_livre_2, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_ccusto_fim               = entry(2, tab_livre_emsfin.cod_livre_2, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa      = entry(3, tab_livre_emsfin.cod_livre_2, chr(10))
                                tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec      = entry(4, tab_livre_emsfin.cod_livre_2, chr(10)).
                     end.
                     assign tt_grp_col_demonst_video.ttv_cod_exec_period_1 = ""
                            tt_grp_col_demonst_video.ttv_cod_exec_period_2 = "".
                &endif
                assign tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec = replace(tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec = substr (tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec, 1 , v_num_format_proj_financ)
                       tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa = replace(tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa = substr (tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa, 1 , v_num_format_proj_financ)
                       tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec      = replace(tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec      = substr (tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec, 1 , v_num_format_ccusto_compos)
                       tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa      = replace(tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa      = substr (tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa, 1 , v_num_format_ccusto_compos)
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa         = replace(tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa         = substr (tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa, 1 , v_num_format_cta_ctbl)
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec         = replace(tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec, "#", ".")
                       tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec         = substr (tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec, 1 , v_num_format_cta_ctbl).
            end.
            else do:
                /* RAFA */
                assign tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = ''
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = 'ZZZ'
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_ini         = ''
                       tt_grp_col_demonst_video.ttv_cod_unid_organ_fim         = 'ZZZ'.

                &if '{&emsfin_version}' > '5.05' &then
                    assign tt_grp_col_demonst_video.ttv_cod_exec_period_1 = conjto_prefer_demonst.cod_exerc_period_1
                           tt_grp_col_demonst_video.ttv_cod_exec_period_2 = conjto_prefer_demonst.cod_exerc_period_2
                           v_cod_cenar_ctbl_2                             = conjto_prefer_demonst.cod_cenar_ctbl_2.
                &else
                    assign v_cod_cenar_ctbl_2 = entry(3,conjto_prefer_demonst.cod_livre_1,chr(10))
                           tt_grp_col_demonst_video.ttv_cod_exec_period_1 = string(year(conjto_prefer_demonst.dat_livre_1),'9999') +
                                                                            string(month(conjto_prefer_demonst.dat_livre_1),'99')
                           tt_grp_col_demonst_video.ttv_cod_exec_period_2 = string(string (year(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'9999') +
                                                                            string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'99')) no-error.
                &endif
                /* --- Se for Comparativo cria uma NOVA TT_GRP ---*/
                if  tt_grp_col_demonst_video.ttv_cod_exec_period_2 <> "" then do:
                    find first btt_grp_col_demonst_video
                         where btt_grp_col_demonst_video.tta_num_conjto_param_ctbl = 2 no-error.
                    if  avail btt_grp_col_demonst_video
                        and v_cod_cenar_ctbl_2 <> '' then do:
                        /* RAFA */
                        assign btt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = ''
                               btt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = 'ZZZ'
                               btt_grp_col_demonst_video.ttv_cod_unid_organ_ini         = ''
                               btt_grp_col_demonst_video.ttv_cod_unid_organ_fim         = 'ZZZ'
                               btt_grp_col_demonst_video.ttv_cod_finalid_econ           = conjto_prefer_demonst.cod_finalid_econ
                               btt_grp_col_demonst_video.ttv_val_cotac_indic_econ       = conjto_prefer_demonst.val_cotac_indic_econ
                               btt_grp_col_demonst_video.ttv_cod_unid_negoc_fim         = conjto_prefer_demonst.cod_unid_negoc_fim
                               btt_grp_col_demonst_video.ttv_cod_unid_negoc_ini         = conjto_prefer_demonst.cod_unid_negoc_inic
                               btt_grp_col_demonst_video.ttv_cod_estab_fim              = conjto_prefer_demonst.cod_estab_fim
                               btt_grp_col_demonst_video.ttv_cod_estab_inic             = conjto_prefer_demonst.cod_estab_inic
                               btt_grp_col_demonst_video.ttv_cod_cenar_orctario         = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                               btt_grp_col_demonst_video.tta_cod_unid_orctaria          = tt_grp_col_demonst_video.tta_cod_unid_orctaria
                               btt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl        = tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl
                               btt_grp_col_demonst_video.tta_num_seq_orcto_ctbl         = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                               btt_grp_col_demonst_video.ttv_cod_cenar_ctbl             = v_cod_cenar_ctbl_2 /* CENµRIO 2 para a Consulta Comparativo*/
                               btt_grp_col_demonst_video.ttv_cod_exec_period_1          = tt_grp_col_demonst_video.ttv_cod_exec_period_2
                               btt_grp_col_demonst_video.ttv_cod_exec_period_2          = "".
                    end.
                end.
            end.
           /* -- end. -*/
        end.

        /* --- Quando for Consultas de Saldo o per­do a ser consultado virÿ neste atributo ---*/
        if  tt_grp_col_demonst_video.ttv_cod_exec_period_1 <> "" then do:
            assign v_num_period_ano = int(substr(tt_grp_col_demonst_video.ttv_cod_exec_period_1,1,4))
                   v_num_period_mes = int(substr(tt_grp_col_demonst_video.ttv_cod_exec_period_1,5,2)).
        end.
        else do:
            if not v_cod_dwb_user begins 'es_'
            or v_nom_prog = "Di rio" /*l_diario*/  then do:
                assign v_num_period_mes = prefer_demonst_ctbl.num_period_ctbl
                       v_num_period_ano = int(prefer_demonst_ctbl.cod_exerc_ctbl).
            end.                   
            else do:
                assign v_num_period_mes = int(entry(9, dwb_rpt_param.cod_dwb_parameters, chr(10)))
                       v_num_period_ano = int(entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10))).
            end.
        end.

        /* -------- 220577 - Em um cen rio ‚ poss¡vel ter mais de 12 per¡odos -------- */
        find last period_ctbl no-lock          
            where period_ctbl.cod_cenar_ctbl  = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
              and period_ctbl.cod_exerc_ctbl  = string(v_num_period_ano)
              and period_ctbl.num_period_ctbl > 12 no-error.

        if avail period_ctbl then
            assign v_qtd_period = period_ctbl.num_period_ctbl.
        else
            assign v_qtd_period = 12.
        /* ---- ----  */

        if  tt_grp_col_demonst_video.tta_ind_tip_relac_base = "Antes da Referˆncia" /*l_antes_da_referencia*/ 
        then do:
            assign v_num_mes = v_num_period_mes - tt_grp_col_demonst_video.tta_qtd_period_relac_base
                   v_num_ano = v_num_period_ano - tt_grp_col_demonst_video.tta_qtd_exerc_relac_base.
            if  v_num_mes <= 0
            then do:
                assign v_num_quant_anos = 0.
                repeat while v_num_mes <= 0:
                    assign v_num_mes        = v_qtd_period + v_num_mes
                           v_num_quant_anos = v_num_quant_anos + 1.
                end.
                if  v_num_ano = v_num_period_ano then
                   assign v_num_ano = v_num_period_ano - v_num_quant_anos.
            end.
        end.
        else do:
            assign v_num_mes = v_num_period_mes + tt_grp_col_demonst_video.tta_qtd_period_relac_base
                   v_num_ano = v_num_period_ano + tt_grp_col_demonst_video.tta_qtd_exerc_relac_base.
            if  v_num_mes > v_qtd_period
            then do:
                assign v_num_quant_anos = 0.
                repeat while v_num_mes > v_qtd_period:
                    assign v_num_mes        = v_num_mes - v_qtd_period
                           v_num_quant_anos = v_num_quant_anos + 1.
                end.
                if  v_num_ano = v_num_period_ano then
                    assign v_num_ano = v_num_period_ano + v_num_quant_anos.
            end.
        end.
        if  tt_grp_col_demonst_video.ttv_num_period = 0
        then do:
            find period_ctbl no-lock
                where period_ctbl.cod_cenar_ctbl  = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
                and   period_ctbl.num_period_ctbl = v_num_mes
                and   period_ctbl.cod_exerc_ctbl  = string(v_num_ano) no-error.
            if  not avail period_ctbl then
               assign tt_grp_col_demonst_video.ttv_num_period     = 0
                      tt_grp_col_demonst_video.ttv_dat_fim_period = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
            else
               assign tt_grp_col_demonst_video.ttv_num_period     = period_ctbl.num_period_ctbl
                      tt_grp_col_demonst_video.ttv_dat_fim_period = period_ctbl.dat_fim_period_ctbl.
        end.

        assign v_val_cotac_indic_econ = tt_grp_col_demonst_video.ttv_val_cotac_indic_econ
               v_val_sdo_ctbl = 0.

        /* Necessario para saldos consolidados */
        if  tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = ''
        and tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = '' then 
            assign tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic = ''
                   tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim  = 'ZZZ'.

        /* RAFA */
        assign v_cod_unid_organ_prefer_inic = if tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic > v_cod_unid_organ_ini then
                                                 tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_inic
                                              else v_cod_unid_organ_ini
               v_cod_unid_organ_prefer_fim  = if tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim < v_cod_unid_organ_fim then
                                                 tt_grp_col_demonst_video.ttv_cod_unid_organ_prefer_fim
                                              else v_cod_unid_organ_fim
               v_cod_estab_prefer_inic      = if tt_grp_col_demonst_video.ttv_cod_estab_ini > v_cod_estab_ini then
                                                 tt_grp_col_demonst_video.ttv_cod_estab_ini
                                              else v_cod_estab_ini
               v_cod_estab_prefer_fim       = if tt_grp_col_demonst_video.ttv_cod_estab_fim < v_cod_estab_fim then
                                                 tt_grp_col_demonst_video.ttv_cod_estab_fim
                                              else v_cod_estab_fim
               v_cod_unid_negoc_prefer_inic = if tt_grp_col_demonst_video.ttv_cod_unid_negoc_ini > v_cod_unid_negoc_ini then
                                                 tt_grp_col_demonst_video.ttv_cod_unid_negoc_ini
                                              else v_cod_unid_negoc_ini
               v_cod_unid_negoc_prefer_fim  = if tt_grp_col_demonst_video.ttv_cod_unid_negoc_fim < v_cod_unid_negoc_fim then
                                                 tt_grp_col_demonst_video.ttv_cod_unid_negoc_fim
                                              else v_cod_unid_negoc_fim.
        if v_cod_demonst_ctbl <> "" then do:
            assign v_cod_cta_ctbl_prefer_inic      = if tt_grp_col_demonst_video.ttv_cod_cta_ctbl_ini > v_cod_cta_ctbl_ini then
                                                       tt_grp_col_demonst_video.ttv_cod_cta_ctbl_ini
                                                    else v_cod_cta_ctbl_ini
                   v_cod_cta_ctbl_prefer_fim      = if tt_grp_col_demonst_video.ttv_cod_cta_ctbl_fim < v_cod_cta_ctbl_fim then
                                                       tt_grp_col_demonst_video.ttv_cod_cta_ctbl_fim
                                                    else v_cod_cta_ctbl_fim
                   v_cod_ccusto_prefer_inic        = if tt_grp_col_demonst_video.ttv_cod_ccusto_ini > v_cod_ccusto_ini then
                                                       tt_grp_col_demonst_video.ttv_cod_ccusto_ini
                                                    else v_cod_ccusto_ini
                   v_cod_ccusto_prefer_fim        = if tt_grp_col_demonst_video.ttv_cod_ccusto_fim < v_cod_ccusto_fim   and tt_grp_col_demonst_video.ttv_cod_ccusto_fim <> ""   then
                                                       tt_grp_col_demonst_video.ttv_cod_ccusto_fim
                                                    else v_cod_ccusto_fim
                   v_cod_proj_financ_prefer_inic   = if tt_grp_col_demonst_video.ttv_cod_proj_financ_ini > v_cod_proj_financ_ini then
                                                       tt_grp_col_demonst_video.ttv_cod_proj_financ_ini
                                                    else v_cod_proj_financ_ini
                   v_cod_proj_financ_prefer_fim   = if tt_grp_col_demonst_video.ttv_cod_proj_financ_fim < v_cod_proj_financ_fim then
                                                       tt_grp_col_demonst_video.ttv_cod_proj_financ_fim
                                                    else v_cod_proj_financ_fim.

            assign v_cod_cta_ctbl_pfixa_prefer    = v_cod_cta_ctbl_pfixa
                   v_cod_cta_ctbl_exec_prefer     = v_cod_cta_ctbl_exec
                   v_cod_ccusto_pfixa_prefer      = v_cod_ccusto_pfixa
                   v_cod_ccusto_exec_prefer       = v_cod_ccusto_exec
                   v_cod_proj_financ_pfixa_prefer = v_cod_proj_financ_pfixa
                   v_cod_proj_financ_excec_prefer = v_cod_proj_financ_excec.


        /* Begin_Include: i_trata_col_demonst_ctbl_video */
        /* Trata a Parte Excecao da conta, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec <> '' 
        and tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec <> fill('.',v_num_format_cta_ctbl) then
            assign v_cod_cta_ctbl_exec_prefer = v_cod_cta_ctbl_exec_prefer + chr(10) + tt_grp_col_demonst_video.ttv_cod_cta_prefer_excec.

        /* Trata a Parte Excecao do centro de custo, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec <> '' 
        and tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec <> fill('.',v_num_format_ccusto_compos) then
            assign v_cod_ccusto_exec_prefer = v_cod_ccusto_exec_prefer + chr(10) + tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_excec.

        /* Trata a Parte Excecao do projeto, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec <> '' 
        and tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec <> fill('.',v_num_format_proj_financ) then
            assign v_cod_proj_financ_excec_prefer = v_cod_proj_financ_excec_prefer + chr(10) + tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_excec.

        /* Trata a Parte Fixa da conta, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa <> '' 
        and tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa <> fill('.',v_num_format_cta_ctbl) then do:
            do v_num_contador = 1 to length(tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa):
                if substring(v_cod_cta_ctbl_pfixa_prefer,v_num_contador,1) = '.' then
                    assign substring(v_cod_cta_ctbl_pfixa_prefer,v_num_contador,1) =  substring(tt_grp_col_demonst_video.ttv_cod_cta_prefer_pfixa,v_num_contador,1).
            end.
        end.

        /* Trata a Parte Fixa do centro de custo, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa <> '' 
        and tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa <> fill('.',v_num_format_ccusto_compos) then do:
            do v_num_contador = 1 to length(tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa):
                if substring(v_cod_ccusto_pfixa_prefer,v_num_contador,1) = '.' then
                    assign substring(v_cod_ccusto_pfixa_prefer,v_num_contador,1) =  substring(tt_grp_col_demonst_video.ttv_cod_ccusto_prefer_pfixa,v_num_contador,1).
            end.
        end.

        /* Trata a Parte Fixa do projeto, caso tenha tenha sido informado no cadastro do demonstrativo e no conjunto de preferencias */
        if  tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa <> '' 
        and tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa <> fill('.',v_num_format_proj_financ) then do:
            do v_num_contador = 1 to length(tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa):
                if substring(v_cod_proj_financ_pfixa_prefer,v_num_contador,1) = '.' then
                    assign substring(v_cod_proj_financ_pfixa_prefer,v_num_contador,1) =  substring(tt_grp_col_demonst_video.ttv_cod_proj_financ_prefer_pfixa,v_num_contador,1).
            end.
        end.
        /* End_Include: i_trata_col_demonst_ctbl_video */

        end.
        else do:
            assign v_cod_cta_ctbl_prefer_inic     = v_cod_cta_ctbl_ini
                   v_cod_cta_ctbl_prefer_fim      = v_cod_cta_ctbl_fim
                   v_cod_ccusto_prefer_inic       = v_cod_ccusto_ini
                   v_cod_ccusto_prefer_fim        = v_cod_ccusto_fim
                   v_cod_proj_financ_prefer_inic  = v_cod_proj_financ_ini
                   v_cod_proj_financ_prefer_fim   = v_cod_proj_financ_fim
                   v_cod_cta_ctbl_pfixa_prefer    = ""
                   v_cod_cta_ctbl_exec_prefer     = ""
                   v_cod_ccusto_pfixa_prefer      = ""
                   v_cod_ccusto_exec_prefer       = ""
                   v_cod_proj_financ_pfixa_prefer = ""
                   v_cod_proj_financ_excec_prefer = "".
        end.
        assign v_num_seq_sdo = v_num_seq_sdo + 1.

        if v_cod_dwb_user begins 'es_' and v_nom_prog <> "Di rio" /*l_diario*/  then 
            assign v_log_consid_apurac_restdo = (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes') .
        else 
            assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.


        /* Begin_Include: i_col_demonst_ctbl_video_aux */
        find first tt_input_sdo
             where tt_input_sdo.tta_cod_unid_organ_inic      = v_cod_unid_organ_prefer_inic
             and   tt_input_sdo.tta_cod_unid_organ_fim       = v_cod_unid_organ_prefer_fim
             and   tt_input_sdo.ttv_cod_unid_organ_orig_ini  = tt_grp_col_demonst_video.ttv_cod_unid_organ_ini   
             and   tt_input_sdo.ttv_cod_unid_organ_orig_fim  = tt_grp_col_demonst_video.ttv_cod_unid_organ_fim
             and   tt_input_sdo.tta_cod_cenar_ctbl           = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
             and   tt_input_sdo.tta_cod_finalid_econ         = tt_grp_col_demonst_video.ttv_cod_finalid_econ
             and   tt_input_sdo.tta_cod_plano_cta_ctbl       = v_cod_plano_cta_ctbl
             and   tt_input_sdo.tta_cod_plano_ccusto         = v_cod_plano_ccusto
             and   tt_input_sdo.tta_cod_cta_ctbl_inic        = v_cod_cta_ctbl_prefer_inic
             and   tt_input_sdo.tta_cod_cta_ctbl_fim         = v_cod_cta_ctbl_prefer_fim
             and   tt_input_sdo.tta_cod_proj_financ_inic     = v_cod_proj_financ_prefer_inic
             and   tt_input_sdo.tta_cod_proj_financ_fim      = v_cod_proj_financ_prefer_fim
             and   tt_input_sdo.tta_cod_estab_inic           = v_cod_estab_prefer_inic
             and   tt_input_sdo.tta_cod_estab_fim            = v_cod_estab_prefer_fim
             and   tt_input_sdo.tta_cod_unid_negoc_inic      = v_cod_unid_negoc_prefer_inic
             and   tt_input_sdo.tta_cod_unid_negoc_fim       = v_cod_unid_negoc_prefer_fim
             and   tt_input_sdo.tta_cod_ccusto_inic          = v_cod_ccusto_prefer_inic
             and   tt_input_sdo.tta_cod_ccusto_fim           = v_cod_ccusto_prefer_fim
             and   tt_input_sdo.ttv_log_consid_apurac_restdo = v_log_consid_apurac_restdo
             and   tt_input_sdo.ttv_cod_elimina_intercomp    = tt_grp_col_demonst_video.tta_ind_tip_val_consolid
             and   tt_input_sdo.ttv_log_espec_sdo_ccusto     = v_log_espec_sdo_ccusto
             and   tt_input_sdo.ttv_log_restric_estab        = v_log_restric_estab
             and   tt_input_sdo.ttv_ind_espec_sdo_tot        = v_ind_orig_val_col_demonst
             and   tt_input_sdo.ttv_ind_espec_cta            = v_ind_espec_cta
             and   tt_input_sdo.ttv_cod_leitura              = "for each"
             and   tt_input_sdo.ttv_cod_condicao             = "Igual"
             and   tt_input_sdo.ttv_cod_cenar_orctario       = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
             and   tt_input_sdo.ttv_cod_unid_orctaria        = tt_grp_col_demonst_video.tta_cod_unid_orctaria
             and   tt_input_sdo.ttv_num_seq_orcto_ctbl       = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
             and   tt_input_sdo.ttv_cod_vers_orcto_ctbl      = tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl
             and   tt_input_sdo.ttv_cod_cta_ctbl_pfixa       = v_cod_cta_ctbl_pfixa_prefer
             and   tt_input_sdo.ttv_cod_ccusto_pfixa         = v_cod_ccusto_pfixa_prefer
             and   tt_input_sdo.ttv_cod_proj_financ_pfixa    = v_cod_proj_financ_pfixa_prefer
             and   tt_input_sdo.ttv_cod_cta_ctbl_excec       = v_cod_cta_ctbl_exec_prefer
             and   tt_input_sdo.ttv_cod_ccusto_excec         = v_cod_ccusto_exec_prefer
             and   tt_input_sdo.ttv_cod_proj_financ_excec    = v_cod_proj_financ_excec_prefer
             and   tt_input_sdo.ttv_num_seq_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
             and   tt_input_sdo.ttv_num_seq_compos_demonst   = tt_compos_demonst_cadastro.num_seq_compos_demonst
             and   tt_input_sdo.ttv_cod_chave                = v_cod_estrut_visualiz
             no-error.
        if not avail tt_input_sdo then do:
            /* =====================================================================================================================
              L¢gica criada para validar o caso de nÆo encontrar plano centro de custo para a unidade organizacional substitu¡da.
              Ex: Duas composi‡äes para unidades organizacionais diferentes e substituir a unidade organizacional, nÆo ir  achar o
              plano centro de custo e duplicar o valor. Atividade 171524 OS 7980
              =====================================================================================================================*/

            assign v_log_nao_cria_tt_input_sdo = no.

            if  v_log_unid_organ_subst or
                v_log_estab_subst or
                v_log_unid_negoc_subst or
                v_log_ccusto_subst
            then do:

                if trim(v_cod_plano_ccusto)  = '' and 
                   trim(v_cod_ccusto_prefer_fim) <> '' then 
                     assign v_log_nao_cria_tt_input_sdo = yes.

                if can-find(first tt_input_sdo
                            where tt_input_sdo.tta_cod_unid_organ_inic      = v_cod_unid_organ_prefer_inic
                            and   tt_input_sdo.tta_cod_unid_organ_fim       = v_cod_unid_organ_prefer_fim
                            and   tt_input_sdo.ttv_cod_unid_organ_orig_ini  = tt_grp_col_demonst_video.ttv_cod_unid_organ_ini   
                            and   tt_input_sdo.ttv_cod_unid_organ_orig_fim  = tt_grp_col_demonst_video.ttv_cod_unid_organ_fim
                            and   tt_input_sdo.tta_cod_cenar_ctbl           = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
                            and   tt_input_sdo.tta_cod_finalid_econ         = tt_grp_col_demonst_video.ttv_cod_finalid_econ
                            and   tt_input_sdo.tta_cod_plano_cta_ctbl       = v_cod_plano_cta_ctbl
                            and   tt_input_sdo.tta_cod_plano_ccusto         = v_cod_plano_ccusto
                            and   tt_input_sdo.tta_cod_cta_ctbl_inic        = v_cod_cta_ctbl_prefer_inic
                            and   tt_input_sdo.tta_cod_cta_ctbl_fim         = v_cod_cta_ctbl_prefer_fim
                            and   tt_input_sdo.tta_cod_proj_financ_inic     = v_cod_proj_financ_prefer_inic
                            and   tt_input_sdo.tta_cod_proj_financ_fim      = v_cod_proj_financ_prefer_fim
                            and   tt_input_sdo.tta_cod_estab_inic           = v_cod_estab_prefer_inic
                            and   tt_input_sdo.tta_cod_estab_fim            = v_cod_estab_prefer_fim
                            and   tt_input_sdo.tta_cod_unid_negoc_inic      = v_cod_unid_negoc_prefer_inic
                            and   tt_input_sdo.tta_cod_unid_negoc_fim       = v_cod_unid_negoc_prefer_fim
                            and   tt_input_sdo.tta_cod_ccusto_inic          = v_cod_ccusto_prefer_inic
                            and   tt_input_sdo.tta_cod_ccusto_fim           = v_cod_ccusto_prefer_fim
                            and   tt_input_sdo.ttv_log_consid_apurac_restdo = v_log_consid_apurac_restdo
                            and   tt_input_sdo.ttv_cod_elimina_intercomp    = tt_grp_col_demonst_video.tta_ind_tip_val_consolid
                            and   tt_input_sdo.ttv_log_espec_sdo_ccusto     = v_log_espec_sdo_ccusto
                            and   tt_input_sdo.ttv_log_restric_estab        = v_log_restric_estab
                            and   tt_input_sdo.ttv_ind_espec_sdo_tot        = v_ind_orig_val_col_demonst
                            and   tt_input_sdo.ttv_ind_espec_cta            = v_ind_espec_cta
                            and   tt_input_sdo.ttv_cod_leitura              = "for each"
                            and   tt_input_sdo.ttv_cod_condicao             = "Igual"
                            and   tt_input_sdo.ttv_cod_cenar_orctario       = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                            and   tt_input_sdo.ttv_cod_unid_orctaria        = tt_grp_col_demonst_video.tta_cod_unid_orctaria
                            and   tt_input_sdo.ttv_num_seq_orcto_ctbl       = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                            and   tt_input_sdo.ttv_cod_vers_orcto_ctbl      = tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl
                            and   tt_input_sdo.ttv_cod_cta_ctbl_pfixa       = v_cod_cta_ctbl_pfixa_prefer
                            and   tt_input_sdo.ttv_cod_ccusto_pfixa         = v_cod_ccusto_pfixa_prefer
                            and   tt_input_sdo.ttv_cod_proj_financ_pfixa    = v_cod_proj_financ_pfixa_prefer
                            and   tt_input_sdo.ttv_cod_cta_ctbl_excec       = v_cod_cta_ctbl_exec_prefer
                            and   tt_input_sdo.ttv_cod_ccusto_excec         = v_cod_ccusto_exec_prefer
                            and   tt_input_sdo.ttv_cod_proj_financ_excec    = v_cod_proj_financ_excec_prefer
                            and   tt_input_sdo.ttv_num_seq_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                            and   tt_input_sdo.ttv_cod_chave                = v_cod_estrut_visualiz) then
                    assign v_log_nao_cria_tt_input_sdo = yes.

                /* ===========================================================================================================
                   212559 - (Logica criada para validar ao gravar a tt_input_sdo se selecionar alguma subtitui‡Æo valida as composi‡äes,
                   dependendo do caso deve-se prevalecer a maior salvando somente uma vez para nÆo duplicar o valor. 
                   ex.: Existe definido uma composi‡Æo de faixa 5.0.00.00.00 5.9.99.99.99 e as demais todas com as faixas 5.1.01.01.01 
                   at‚ 5.9.99.99.99 estava duplicado o valor pq incluida duas faixas diferentes. 
                ============================================================================================================*/           
                if  v_log_ccusto_subst
                and v_cod_ccusto_ini = v_cod_ccusto_fim then do:    
                    if can-find(first btt_input_sdo no-lock
                        where btt_input_sdo.tta_cod_unid_organ_inic      = v_cod_unid_organ_prefer_inic
                        and   btt_input_sdo.tta_cod_unid_organ_fim       = v_cod_unid_organ_prefer_fim
                        and   btt_input_sdo.ttv_cod_unid_organ_orig_ini  = tt_grp_col_demonst_video.ttv_cod_unid_organ_ini   
                        and   btt_input_sdo.ttv_cod_unid_organ_orig_fim  = tt_grp_col_demonst_video.ttv_cod_unid_organ_fim
                        and   btt_input_sdo.tta_cod_cenar_ctbl           = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
                        and   btt_input_sdo.tta_cod_finalid_econ         = tt_grp_col_demonst_video.ttv_cod_finalid_econ
                        and   btt_input_sdo.tta_cod_plano_cta_ctbl       = v_cod_plano_cta_ctbl
                        and   btt_input_sdo.tta_cod_plano_ccusto         = v_cod_plano_ccusto
                        and   btt_input_sdo.tta_cod_proj_financ_inic     = v_cod_proj_financ_prefer_inic
                        and   btt_input_sdo.tta_cod_proj_financ_fim      = v_cod_proj_financ_prefer_fim
                        and   btt_input_sdo.tta_cod_cta_ctbl_ini        <= v_cod_cta_ctbl_ini 
                        and   btt_input_sdo.tta_cod_cta_ctbl_fim        >= v_cod_cta_ctbl_prefer_fim 
                        and   btt_input_sdo.tta_cod_estab_inic          <= v_cod_estab_prefer_inic 
                        and   btt_input_sdo.tta_cod_estab_fim           >= v_cod_estab_prefer_fim  
                        and   btt_input_sdo.tta_cod_unid_negoc_inic     <= v_cod_unid_negoc_prefer_inic
                        and   btt_input_sdo.tta_cod_unid_negoc_fim      >= v_cod_unid_negoc_prefer_fim 
                        and   btt_input_sdo.tta_cod_ccusto_inic         <= v_cod_ccusto_prefer_inic 
                        and   btt_input_sdo.tta_cod_ccusto_fim          >= v_cod_ccusto_prefer_fim
                        and   btt_input_sdo.ttv_log_consid_apurac_restdo = v_log_consid_apurac_restdo
                        and   btt_input_sdo.ttv_cod_elimina_intercomp    = tt_grp_col_demonst_video.tta_ind_tip_val_consolid
                        and   btt_input_sdo.ttv_log_espec_sdo_ccusto     = v_log_espec_sdo_ccusto
                        and   btt_input_sdo.ttv_log_restric_estab        = v_log_restric_estab
                        and   btt_input_sdo.ttv_ind_espec_sdo_tot        = v_ind_orig_val_col_demonst
                        and   btt_input_sdo.ttv_ind_espec_cta            = v_ind_espec_cta
                        and   btt_input_sdo.ttv_cod_leitura              = "for each"
                        and   btt_input_sdo.ttv_cod_condicao             = "Igual"
                        and   btt_input_sdo.ttv_cod_cenar_orctario       = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                        and   btt_input_sdo.ttv_cod_unid_orctaria        = tt_grp_col_demonst_video.tta_cod_unid_orctaria
                        and   btt_input_sdo.ttv_num_seq_orcto_ctbl       = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                        and   btt_input_sdo.ttv_cod_vers_orcto_ctbl      = tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl
                        and   btt_input_sdo.ttv_cod_cta_ctbl_pfixa       = v_cod_cta_ctbl_pfixa_prefer
                        and   btt_input_sdo.ttv_cod_ccusto_pfixa         = v_cod_ccusto_pfixa_prefer
                        and   btt_input_sdo.ttv_cod_proj_financ_pfixa    = v_cod_proj_financ_pfixa_prefer
                        and   btt_input_sdo.ttv_cod_cta_ctbl_excec       = v_cod_cta_ctbl_exec_prefer
                        and   btt_input_sdo.ttv_cod_ccusto_excec         = v_cod_ccusto_exec_prefer
                        and   btt_input_sdo.ttv_cod_proj_financ_excec    = v_cod_proj_financ_excec_prefer
                        and   btt_input_sdo.ttv_num_seq_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                        and   btt_input_sdo.ttv_cod_chave                = v_cod_estrut_visualiz) then
                            assign v_log_nao_cria_tt_input_sdo = yes.     
                end.               
            end /* if */.        
            if  v_log_nao_cria_tt_input_sdo = no
            then do:
                &IF '{&emsfin_version}' >= '5.06' &THEN
                find unid_orctaria no-lock
                    where unid_orctaria.cod_unid_orctaria = tt_grp_col_demonst_video.tta_cod_unid_orctaria no-error.
                if avail unid_orctaria
                and unid_orctaria.ind_espec_unid_orctaria = "Sint‚tica" /*l_sintetica*/  then
                    assign v_ind_espec_unid_orctaria = unid_orctaria.ind_espec_unid_orctaria.
                else
                    assign v_ind_espec_unid_orctaria = "Anal¡tica" /*l_analitica*/ .
                &else
                    assign v_ind_espec_unid_orctaria = "Anal¡tica" /*l_analitica*/ .
                &endif

                if v_ind_espec_unid_orctaria = "Sint‚tica" /*l_sintetica*/  then do:
                    run pi_achar_unid_orctaria_filho (Input unid_orctaria.cod_unid_orctaria) /*pi_achar_unid_orctaria_filho*/.
                    for each tt_unid_orctaria:

                        find first vers_orcto_ctbl_bgc no-lock
                            where vers_orcto_ctbl_bgc.cod_cenar_orctario      = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                              and vers_orcto_ctbl_bgc.cod_unid_orctaria       = tt_unid_orctaria.tta_cod_unid_orctaria
                              and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl      = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                              and vers_orcto_ctbl_bgc.num_sit_vers_orcto_ctbl = 2 no-error.

                        if avail vers_orcto_ctbl_bgc then do:
                            create tt_input_sdo.
                            assign tt_input_sdo.ttv_cod_seq                  = string(v_num_seq_sdo)
                                   tt_input_sdo.tta_cod_unid_organ_inic      = v_cod_unid_organ_prefer_inic
                                   tt_input_sdo.tta_cod_unid_organ_fim       = v_cod_unid_organ_prefer_fim
                                   tt_input_sdo.ttv_cod_unid_organ_orig_ini  = tt_grp_col_demonst_video.ttv_cod_unid_organ_ini           
                                   tt_input_sdo.ttv_cod_unid_organ_orig_fim  = tt_grp_col_demonst_video.ttv_cod_unid_organ_fim
                                   tt_input_sdo.tta_cod_cenar_ctbl           = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
                                   tt_input_sdo.tta_cod_finalid_econ         = tt_grp_col_demonst_video.ttv_cod_finalid_econ
                                   tt_input_sdo.tta_cod_plano_cta_ctbl       = v_cod_plano_cta_ctbl
                                   tt_input_sdo.tta_cod_plano_ccusto         = v_cod_plano_ccusto
                                   tt_input_sdo.tta_cod_cta_ctbl_inic        = v_cod_cta_ctbl_prefer_inic
                                   tt_input_sdo.tta_cod_cta_ctbl_fim         = v_cod_cta_ctbl_prefer_fim
                                   tt_input_sdo.tta_cod_proj_financ_inic     = v_cod_proj_financ_prefer_inic
                                   tt_input_sdo.tta_cod_proj_financ_fim      = v_cod_proj_financ_prefer_fim
                                   tt_input_sdo.tta_cod_estab_inic           = v_cod_estab_prefer_inic
                                   tt_input_sdo.tta_cod_estab_fim            = v_cod_estab_prefer_fim
                                   tt_input_sdo.tta_cod_unid_negoc_inic      = v_cod_unid_negoc_prefer_inic
                                   tt_input_sdo.tta_cod_unid_negoc_fim       = v_cod_unid_negoc_prefer_fim
                                   tt_input_sdo.tta_cod_ccusto_inic          = v_cod_ccusto_prefer_inic
                                   tt_input_sdo.tta_cod_ccusto_fim           = v_cod_ccusto_prefer_fim
                                   tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic    = string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                                   tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim     = string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                                   tt_input_sdo.ttv_log_consid_apurac_restdo = v_log_consid_apurac_restdo
                                   tt_input_sdo.ttv_cod_elimina_intercomp    = tt_grp_col_demonst_video.tta_ind_tip_val_consolid
                                   tt_input_sdo.ttv_log_espec_sdo_ccusto     = v_log_espec_sdo_ccusto
                                   tt_input_sdo.ttv_log_restric_estab        = v_log_restric_estab
                                   tt_input_sdo.ttv_ind_espec_sdo_tot        = v_ind_orig_val_col_demonst
                                   tt_input_sdo.ttv_ind_espec_cta            = v_ind_espec_cta
                                   tt_input_sdo.ttv_cod_leitura              = "for each"
                                   tt_input_sdo.ttv_cod_condicao             = "Igual"
                                   tt_input_sdo.ttv_cod_cenar_orctario       = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                                   tt_input_sdo.ttv_cod_unid_orctaria        = tt_unid_orctaria.tta_cod_unid_orctaria
                                   tt_input_sdo.ttv_num_seq_orcto_ctbl       = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                                   tt_input_sdo.ttv_cod_vers_orcto_ctbl      = vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl
                                   tt_input_sdo.ttv_cod_exerc_ctbl           = string(v_num_ano)
                                   tt_input_sdo.ttv_cod_period_ctbl          = string(v_num_mes)
                                   tt_input_sdo.ttv_cod_cta_ctbl_pfixa       = v_cod_cta_ctbl_pfixa_prefer
                                   tt_input_sdo.ttv_cod_ccusto_pfixa         = v_cod_ccusto_pfixa_prefer
                                   tt_input_sdo.ttv_cod_proj_financ_pfixa    = v_cod_proj_financ_pfixa_prefer
                                   tt_input_sdo.ttv_cod_cta_ctbl_excec       = v_cod_cta_ctbl_exec_prefer
                                   tt_input_sdo.ttv_cod_ccusto_excec         = v_cod_ccusto_exec_prefer
                                   tt_input_sdo.ttv_cod_proj_financ_excec    = v_cod_proj_financ_excec_prefer
                                   tt_input_sdo.ttv_num_seq_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                                   tt_input_sdo.ttv_num_seq_compos_demonst   = tt_compos_demonst_cadastro.num_seq_compos_demonst
                                   tt_input_sdo.ttv_cod_chave                = v_cod_estrut_visualiz.    
                        end.           
                        delete tt_unid_orctaria.
                    end.
                end.
                else do:
                    create tt_input_sdo.
                    assign tt_input_sdo.ttv_cod_seq                  = string(v_num_seq_sdo)
                           tt_input_sdo.tta_cod_unid_organ_inic      = v_cod_unid_organ_prefer_inic
                           tt_input_sdo.tta_cod_unid_organ_fim       = v_cod_unid_organ_prefer_fim
                           tt_input_sdo.ttv_cod_unid_organ_orig_ini  = tt_grp_col_demonst_video.ttv_cod_unid_organ_ini           
                           tt_input_sdo.ttv_cod_unid_organ_orig_fim  = tt_grp_col_demonst_video.ttv_cod_unid_organ_fim
                           tt_input_sdo.tta_cod_cenar_ctbl           = tt_grp_col_demonst_video.ttv_cod_cenar_ctbl
                           tt_input_sdo.tta_cod_finalid_econ         = tt_grp_col_demonst_video.ttv_cod_finalid_econ
                           tt_input_sdo.tta_cod_plano_cta_ctbl       = v_cod_plano_cta_ctbl
                           tt_input_sdo.tta_cod_plano_ccusto         = v_cod_plano_ccusto
                           tt_input_sdo.tta_cod_cta_ctbl_inic        = v_cod_cta_ctbl_prefer_inic
                           tt_input_sdo.tta_cod_cta_ctbl_fim         = v_cod_cta_ctbl_prefer_fim
                           tt_input_sdo.tta_cod_proj_financ_inic     = v_cod_proj_financ_prefer_inic
                           tt_input_sdo.tta_cod_proj_financ_fim      = v_cod_proj_financ_prefer_fim
                           tt_input_sdo.tta_cod_estab_inic           = v_cod_estab_prefer_inic
                           tt_input_sdo.tta_cod_estab_fim            = v_cod_estab_prefer_fim
                           tt_input_sdo.tta_cod_unid_negoc_inic      = v_cod_unid_negoc_prefer_inic
                           tt_input_sdo.tta_cod_unid_negoc_fim       = v_cod_unid_negoc_prefer_fim
                           tt_input_sdo.tta_cod_ccusto_inic          = v_cod_ccusto_prefer_inic
                           tt_input_sdo.tta_cod_ccusto_fim           = v_cod_ccusto_prefer_fim
                           tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic    = string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                           tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim     = string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                           tt_input_sdo.ttv_log_consid_apurac_restdo = v_log_consid_apurac_restdo
                           tt_input_sdo.ttv_cod_elimina_intercomp       = tt_grp_col_demonst_video.tta_ind_tip_val_consolid
                           tt_input_sdo.ttv_log_espec_sdo_ccusto     = v_log_espec_sdo_ccusto
                           tt_input_sdo.ttv_log_restric_estab        = v_log_restric_estab
                           tt_input_sdo.ttv_ind_espec_sdo_tot        = v_ind_orig_val_col_demonst
                           tt_input_sdo.ttv_ind_espec_cta            = v_ind_espec_cta
                           tt_input_sdo.ttv_cod_leitura              = "for each"
                           tt_input_sdo.ttv_cod_condicao             = "Igual"
                           tt_input_sdo.ttv_cod_cenar_orctario       = tt_grp_col_demonst_video.ttv_cod_cenar_orctario
                           tt_input_sdo.ttv_cod_unid_orctaria        = tt_grp_col_demonst_video.tta_cod_unid_orctaria
                           tt_input_sdo.ttv_num_seq_orcto_ctbl       = tt_grp_col_demonst_video.tta_num_seq_orcto_ctbl
                           tt_input_sdo.ttv_cod_vers_orcto_ctbl      = tt_grp_col_demonst_video.ttv_cod_vers_orcto_ctbl
                           tt_input_sdo.ttv_cod_exerc_ctbl           = string(v_num_ano)
                           tt_input_sdo.ttv_cod_period_ctbl          = string(v_num_mes)
                           tt_input_sdo.ttv_cod_cta_ctbl_pfixa       = v_cod_cta_ctbl_pfixa_prefer
                           tt_input_sdo.ttv_cod_ccusto_pfixa         = v_cod_ccusto_pfixa_prefer
                           tt_input_sdo.ttv_cod_proj_financ_pfixa    = v_cod_proj_financ_pfixa_prefer
                           tt_input_sdo.ttv_cod_cta_ctbl_excec       = v_cod_cta_ctbl_exec_prefer
                           tt_input_sdo.ttv_cod_ccusto_excec         = v_cod_ccusto_exec_prefer
                           tt_input_sdo.ttv_cod_proj_financ_excec    = v_cod_proj_financ_excec_prefer
                           tt_input_sdo.ttv_num_seq_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                           tt_input_sdo.ttv_num_seq_compos_demonst   = tt_compos_demonst_cadastro.num_seq_compos_demonst
                           tt_input_sdo.ttv_cod_chave                = v_cod_estrut_visualiz.
                end.           
            end /* if */.
        end.
        else do:
            assign tt_input_sdo.ttv_cod_seq               = tt_input_sdo.ttv_cod_seq + chr(10)
                                                        + string(v_num_seq_sdo)
                   tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic = tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic + chr(10)
                                                        + string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                   tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim  = tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim + chr(10) 
                                                        + string(tt_grp_col_demonst_video.ttv_dat_fim_period)
                   tt_input_sdo.ttv_cod_exerc_ctbl        = tt_input_sdo.ttv_cod_exerc_ctbl + chr(10)
                                                        + string(v_num_ano)
                   tt_input_sdo.ttv_cod_period_ctbl       = tt_input_sdo.ttv_cod_period_ctbl + chr(10)
                                                        + string(v_num_mes).
        end.

        create tt_input_leitura_sdo_demonst.
        assign tt_input_leitura_sdo_demonst.ttv_num_seq_1    = v_num_seq_sdo
               tt_input_leitura_sdo_demonst.ttv_cod_label    = "Valores Empenhados" /*l_valores_empenhados*/ 
               tt_input_leitura_sdo_demonst.ttv_des_conteudo = string(v_log_busca_val_empenh).    

        create tt_input_leitura_sdo_demonst.
        assign tt_input_leitura_sdo_demonst.ttv_num_seq_1    = v_num_seq_sdo
               tt_input_leitura_sdo_demonst.ttv_cod_label    = "Demonstrativo Cont bil" /*l_demonstrativo_contabil*/ 
               tt_input_leitura_sdo_demonst.ttv_des_conteudo = v_cod_demonst_ctbl.

        if  v_log_funcao_concil_consolid
        then do:
            create tt_input_leitura_sdo_demonst.
            assign tt_input_leitura_sdo_demonst.ttv_num_seq_1    = v_num_seq_sdo
                   tt_input_leitura_sdo_demonst.ttv_cod_label    = "Consolida‡Æo Recursiva" /*l_consolida‡Æo_recursiva*/  
                   tt_input_leitura_sdo_demonst.ttv_des_conteudo = string(v_log_consolid_recur).
        end.

        create tt_rel_grp_col_compos_demonst.
        assign tt_rel_grp_col_compos_demonst.ttv_num_seq_sdo                 = v_num_seq_sdo
               tt_rel_grp_col_compos_demonst.ttv_rec_grp_col_demonst_ctbl    = recid(tt_grp_col_demonst_video)
               tt_rel_grp_col_compos_demonst.ttv_rec_compos_demonst_ctbl     = recid(tt_compos_demonst_cadastro).

        /* End_Include: i_col_demonst_ctbl_video_aux */

    end.    
END PROCEDURE. /* pi_col_demonst_ctbl_video */
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

            /* ** Se objeto ‚ operador, n£mero ou branco pula objeto ***/
            if  index("+-*^/()",substring(p_des_formul,v_num_posicao,1)) = 0 and
                substring(p_des_formul, v_num_posicao, 1) <> " "
            then do:
                if  index("0123456789.",substring(p_des_formul,v_num_posicao,1)) <> 0
                then do:
                    if  v_log_save = yes
                    then do: /* n£mero faz parte da vari vel */
                       assign v_des_formul = v_des_formul + substring(p_des_formul,v_num_posicao,1).
                    end /* if */.
                end /* if */.
                else do:
                    if  v_log_save = no
                    then do: /* ** Primeira letra da vari vel ***/
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
                then do:  /* ** v_des_formul possui vari vel - gera temp table ***/
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
       then do: /* ** £ltima letra da vari vel encontrada na f¢rmula - gera temp table ***/
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
    then do: /* ** NÆo tem mais formula ***/
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
    then do: /* ** NÆo tem mais formula ***/
        assign v_ind_operac_formul      = "Final" /*l_final*/ 
               v_ind_tip_operac_formul  = "DLM" /*l_dlm*/ .
        return.
    end /* if */.

    if  index("+-*^/()",substring(v_des_formul, v_num_posicao, 1))  <> 0
    then do: /* ** Objeto ‚ operador  +-*^/() ***/
        assign v_ind_operac_formul      = substring(v_des_formul, v_num_posicao, 1)
               v_ind_tip_operac_formul = "DLM" /*l_dlm*/ 
               v_num_posicao            = v_num_posicao + 1.
        return.
    end /* if */.

    if  index("0123456789.",substring(v_des_formul, v_num_posicao, 1)) <> 0
    then do:  /* ** Objeto ‚ n£mero ***/
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
    do /* ** Interpreta a vari vel ***/
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
        format "Sim/NÆo"
        no-undo.
    def Input param p_log_mostrar_msg_erro
        as logical
        format "Sim/NÆo"
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
    /* ** Executa soma o substra‡Æo ***/
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
    /* ** Executa multiplica‡Æo ou divisÆo ***/
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
    /* ** Executa exponencia‡Æo ***/
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

    /* ** Caso encontrar + ou - obter o seguinte objeto para opera‡Æo soma o diferˆncia ***/
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

    assign v_log_achou_tmp     = Verifica_Program_Name('MGLA204za':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('MGLA204aa':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('mgl304ab':U, 30).
    if  not v_log_achou_tmp then
        assign v_log_achou_tmp = Verifica_Program_Name('MGLA204zi':U, 30).

    /* ** Caso que indicador ‚ abre parentesis chamar pi_calcul_formul_2 recursivamente ***/
    if v_ind_operac_formul     = '(' and
       v_ind_tip_operac_formul = "DLM" /*l_dlm*/  then do:
       run pi_calcul_formul_obtem_objeto /*pi_calcul_formul_obtem_objeto*/.
       run pi_calcul_formul_2 (input-output p_val_restdo_formul) /*pi_calcul_formul_2*/.
       if v_ind_operac_formul <> ')' then do: /* ** NÆo foi encontrado o fechamento do parˆntesis ***/
          if  v_log_mostrar_msg_erro = yes
          then do:
              /* Faltou fechar parˆnteses ! */
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

    /* ** Executa opera‡Æo aritm‚tica ***/

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

    /* ** InversÆo de sinal ***/
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

    /* ** Substitui vari vel pelo valor dela ***/
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
             /* Vari vel nÆo definida ! */
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
              /* Erro de sintaxe na expressÆo ! */
              run pi_messages (input "show",
                               input 1238,
                               input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1238*/.
           end /* if */.
           assign v_log_retorno = yes.
       end /* else */.
    end /* else */.
END PROCEDURE. /* pi_calcul_formul_substitui */
/*****************************************************************************
** Procedure Interna.....: pi_item_compos_demonst_formul
** Descricao.............: pi_item_compos_demonst_formul
** Criado por............: Dalpra
** Criado em.............: 30/04/2001 16:52:59
** Alterado por..........: fut38629
** Alterado em...........: 27/03/2009 10:43:48
*****************************************************************************/
PROCEDURE pi_item_compos_demonst_formul:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer btt_item_demonst_ctbl_cadastro
        for tt_item_demonst_ctbl_cadastro.
    &endif


    /*************************** Buffer Definition End **************************/

    /* --- Cria‡Æo dos tt_item_demonst_ctbl_video ---*/
    find tt_item_demonst_ctbl_video
       where tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl no-error.
    if  not avail tt_item_demonst_ctbl_video then do:
        create tt_item_demonst_ctbl_video.
        assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl        = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
               tt_item_demonst_ctbl_video.tta_ind_funcao_col_demonst_ctbl = v_ind_funcao_col_demonst_ctbl
               tt_item_demonst_ctbl_video.tta_cod_format_col_demonst_ctbl = v_cod_format_col_demonst_ctbl
               tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst    = v_ind_orig_val_col_demonst
               tt_item_demonst_ctbl_video.ttv_des_valpres = v_des_valpres
               tt_item_demonst_ctbl_video.ttv_cod_chave_2 = ""
               tt_item_demonst_ctbl_video.ttv_cod_chave_3 = ""
               tt_item_demonst_ctbl_video.ttv_cod_chave_4 = ""
               tt_item_demonst_ctbl_video.ttv_cod_chave_5 = ""
               tt_item_demonst_ctbl_video.ttv_cod_chave_6 = ""
               tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad   = tt_item_demonst_ctbl_cadastro.ttv_rec_item_demonst_ctbl_cad
               tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).

        if v_cod_dwb_user begins 'es_' 
        and v_nom_prog <> "Di rio" /*l_diario*/  then do:
            run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                        Input entry(11, dwb_rpt_param.cod_dwb_parameters,chr(10)),
                                        output v_des_tit_ctbl).
        end.
        else do:
            run pi_retornar_trad_idiom (Input tt_item_demonst_ctbl_cadastro.des_tit_ctbl,
                                        Input prefer_demonst_ctbl.cod_idioma,
                                        output v_des_tit_ctbl) /*pi_retornar_trad_idiom*/.
        end.

        if  v_des_tit_ctbl <> "" then
            assign tt_item_demonst_ctbl_video.ttv_cod_chave_1 = v_des_tit_ctbl
                   tt_item_demonst_ctbl_video.ttv_des_chave_1 = v_des_tit_ctbl.
        else   
            assign tt_item_demonst_ctbl_video.ttv_cod_chave_1 = tt_item_demonst_ctbl_cadastro.des_tit_ctbl
                   tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_cadastro.des_tit_ctbl.

        /* * Controle de tabula»’o segundo Par³metros de Impress’o do Item Demonstrativo **/
        if tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst > 0 then do:
            assign tt_item_demonst_ctbl_video.ttv_cod_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_cod_chave_1
                   tt_item_demonst_ctbl_video.ttv_des_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_1.
        end.

        /* --- Verifica se impre ou nÆo o item ---*/
        if  tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst = "C lculo" /*l_calculo*/  then 
            assign tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = no.
        else
            assign tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes.
    end.

    var_formul_block:
    for each tt_var_formul_1:
        delete tt_var_formul_1.
    end.
    /* --- Pesquisa Valores das Colunas ---*/
    run pi_ident_var_formul_1 (Input tt_compos_demonst_cadastro.des_formul_ctbl) /*pi_ident_var_formul_1*/.

    /* para tipos de linha c lculo nÆo h  necessidade de criar v¡nculo para expansÆo */
    if tt_item_demonst_ctbl_cadastro.ind_tip_lin_demonst <> "C lculo" /*l_calculo*/  then do:
        if  v_log_funcao_concil_consolid then do:
            var_formul_block:
            for each tt_var_formul_1 no-lock:
                for each tt_acumul_demonst_cadastro
                    where tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl     = tt_compos_demonst_cadastro.cod_demonst_ctbl
                    and   tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl < tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                    and   tt_acumul_demonst_cadastro.tta_cod_acumul_ctbl      = tt_var_formul_1.ttv_cod_var_formul:

                    assign v_num_soma = 0.

                    find last btt_compos_demonst_cadastro no-lock
                        where btt_compos_demonst_cadastro.cod_demonst_ctbl     = tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl
                          and btt_compos_demonst_cadastro.num_seq_demonst_ctbl = tt_compos_demonst_cadastro.num_seq_demonst_ctbl no-error.
                    if avail btt_compos_demonst_cadastro then
                       assign v_num_soma = btt_compos_demonst_cadastro.num_seq_compos_demonst.

                    /* Montar Cadastro vinculando a sequencia com a sequencia do acumulador */
                    /* Ler cadastro criado para os itens e re-criar usando a sequencia do acumulador */
                    for each  btt_compos_demonst_cadastro no-lock
                        where btt_compos_demonst_cadastro.cod_demonst_ctbl     = tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl
                          and btt_compos_demonst_cadastro.num_seq_demonst_ctbl = tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl
                          and btt_compos_demonst_cadastro.cod_cta_ctbl_ini    <> "":
                        assign v_num_soma = v_num_soma + 10.
                        create btt_compos_demonst_cadastro_2.
                        buffer-copy btt_compos_demonst_cadastro to btt_compos_demonst_cadastro_2
                             assign btt_compos_demonst_cadastro_2.num_seq_demonst_ctbl   = tt_compos_demonst_cadastro.num_seq_demonst_ctbl
                                    btt_compos_demonst_cadastro_2.num_seq_compos_demonst = v_num_soma.
                        if v_log_sped then
                            assign btt_compos_demonst_cadastro_2.log_inverte_val = no.
                    end.

                    find btt_item_demonst_ctbl_cadastro
                       where btt_item_demonst_ctbl_cadastro.cod_demonst_ctbl     = tt_acumul_demonst_cadastro.tta_cod_demonst_ctbl
                       and   btt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl = tt_acumul_demonst_cadastro.tta_num_seq_demonst_ctbl
                       no-error.

                    for each btt_item_demonst_ctbl_video
                        where btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad = recid(btt_item_demonst_ctbl_cadastro):

                        /* Link do acumulador - ler relacto criado para os itens e re-criar usando a sequencia do acumulador */
                        for each  btt_relacto_item_retorna
                            where btt_relacto_item_retorna.ttv_rec_item_demonst = btt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video:
                            if  not can-find(first tt_relacto_item_retorna
                                where tt_relacto_item_retorna.tta_num_seq = integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                                  and tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                                  and tt_relacto_item_retorna.ttv_rec_ret  = btt_relacto_item_retorna.ttv_rec_ret) then do:
                                create tt_relacto_item_retorna.
                                assign tt_relacto_item_retorna.tta_num_seq = integer(btt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl)
                                       tt_relacto_item_retorna.ttv_rec_item_demonst = tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video
                                       tt_relacto_item_retorna.ttv_rec_ret  = btt_relacto_item_retorna.ttv_rec_ret.
                            end.
                        end.
                    end.
                end.
            end.
        end.
    end.

    /* --- Composi‡Æo das Linhas do Demonstrativo ---*/
    for each tt_col_demonst_ctbl no-lock
       where tt_col_demonst_ctbl.ind_orig_val_col_demonst <> "F¢rmula" /*l_formula*/ :

        assign v_val_sdo_ctbl = 0.

        var_formul_block:
        for each tt_var_formul_1 no-lock:
            assign tt_var_formul_1.ttv_val_var_formul_1 = 0.
            for each tt_acumul_demonst_ctbl_result no-lock
                where tt_acumul_demonst_ctbl_result.tta_cod_acumul_ctbl      = tt_var_formul_1.ttv_cod_var_formul
                  and tt_acumul_demonst_ctbl_result.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                  and tt_acumul_demonst_ctbl_result.tta_num_seq_demonst_ctbl < tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl :
                assign tt_var_formul_1.ttv_val_var_formul_1 = tt_var_formul_1.ttv_val_var_formul_1 + tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul.
            end.
        end.

        run pi_calcul_formul_1 (input-output v_val_sdo_ctbl,
                                input tt_compos_demonst_cadastro.des_formul_ctbl,
                                output v_log_return,
                                Input yes) /*pi_calcul_formul_1*/.
        if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

        if can-find(first tt_var_formul_1) and avail tt_acumul_demonst_ctbl_result and
           tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Or‡amento" /*l_orcamento*/  then
            assign v_log_proces = tt_acumul_demonst_ctbl_result.TTV_LOG_JA_PROCESDO.
        else
            assign v_log_proces = no.

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
        else if  v_log_proces = no then do: 
                 if tt_valor_demonst_ctbl_video.ttv_val_col_1 = ? then
                    assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = 0.
                 assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = 
                        tt_valor_demonst_ctbl_video.ttv_val_col_1 + v_val_sdo_ctbl.
             end.
             else if  tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "Or‡amento" /*l_orcamento*/   then
                      assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.

        if  v_log_final_proces = yes then do:
            assign  v_log_proces = no.
            run pi_calcula_acumulador_video (Input tt_col_demonst_ctbl.cod_col_demonst_ctbl,
                                             Input v_val_sdo_ctbl) /*pi_calcula_acumulador_video*/.

        end.
    end.


END PROCEDURE. /* pi_item_compos_demonst_formul */
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
           find emsuni.unid_organ no-lock
                where unid_organ.cod_unid_organ = v_cod_unid_organ_aux
                no-error.
           if  avail unid_organ then do:
               if  v_cod_dwb_user begins 'es_' 
               and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
            /* 218397 - Na segundo coluna do t¡tulo nÆo exibe dados qdo a expansÆo ‚ por Unid org.*/
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
               and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
            /* 218397 - Na segundo coluna do t¡tulo nÆo exibe dados qdo a expansÆo ‚ por estabelecimento.*/
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
           find emsuni.unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = v_cod_unid_negoc_aux
                      no-error.
            if  avail unid_negoc
            then do:
               if v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
            /* 218397 - Na segundo coluna do t¡tulo nÆo exibe dados qdo a expansÆo ‚ por Unid Negoc.*/
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
            find emsuni.ccusto no-lock
              where ccusto.cod_empresa        = v_cod_unid_organ
              and   ccusto.cod_plano_ccusto   = v_cod_plano_ccusto
              and   ccusto.cod_ccusto         = v_cod_ccusto
              no-error.
            if  avail ccusto then do:
               if  v_cod_dwb_user begins 'es_'
               and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
            /* 218397 - Na segundo coluna do t¡tulo nÆo exibe dados qdo a expansÆo ‚ por Ccusto.*/
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

    assign v_num_entry = lookup("Conta Cont bil" /*l_conta_contabil*/  , tt_item_demonst_ctbl_video.ttv_cod_identif_campo, chr(10)).
    if v_num_entry <> 0 then do:
        assign v_cod_cta_ctbl = entry(v_num_entry, v_des_visualiz, chr(59))
               v_num_aux = lookup("Conta Cont bil" /*l_conta_contabil*/  , v_cod_lista_compon, ';').
        if  (entry(v_num_aux + 2, v_cod_lista_compon, ';') = 'yes') = yes
        then do:
           if v_cod_demonst_ctbl <> '' /* Se nÆo for Consulta de Saldos*/ then do:
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
               if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl <> "NÆo" /*l_nao*/  
               then do:
                   if  tt_col_demonst_ctbl.ind_mostra_cod_ctbl = "Sim" /*l_sim*/  
                   then do:
                       assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = 
                              string(b_cta_ctbl_impr.cod_cta_ctbl, v_cod_format_cta_ctbl).
                   end.
                   else do:
                       assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = b_cta_ctbl_impr.cod_cta_ctbl_padr_internac.
                   end /* else */.

                   /* 218397 - Para nÆo duplicar a descri‡Æo nas colunas t¡tulo caso possuir mais de uma*/ 
                   if (v_log_tit_demonst and  v_num_cont_1 = 1 or v_num_cont_2 = 1) or not v_log_tit_demonst then do:
                       if v_cod_dwb_user begins 'es_'
                       and v_nom_prog <> "Di rio" /*l_diario*/  then do:               
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
                   and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
           /* 218397 Qdo tiver mais de uma coluna t¡tulo. utiliza o ttv_des_chave para cada coluna t¡tulo*/
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
               and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
            /* 218397 - Na segundo coluna do t¡tulo nÆo exibe dados qdo a expansÆo ‚ por Projeto.*/
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
        and v_nom_prog <> "Di rio" /*l_diario*/  then do:
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
         /* 211931 - pi_item_demonst_ctbl_video_trata_sdo / se a unid negoc for PAI nÆo deve somar no total */
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
    /* assinala a vari vel v_log_primei_compos_demonst acima para que as pr¢ximas intera‡äes nÆo somais mais mil‚simos na composi‡Æo
    pois neste caso poder¡amos ter os totais alterados */
END PROCEDURE. /* pi_calcula_acumulador_video */
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
            if  tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "Varia‡Æo" /*l_variacao*/  
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
        format "Sim/NÆo"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count_2                    as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

        col_block:
        for each tt_col_demonst_ctbl
            where tt_col_demonst_ctbl.ind_orig_val_col_demonst <> "F¢rmula" /*l_formula*/  
            and   tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl     <> "T¡tulo" /*l_titulo*/ :   

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
                  if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Or‡amento" /*l_orcamento*/  then do:
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
                          and v_nom_prog <> "Di rio" /*l_diario*/  then
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

               when "D‚bitos" /*l_debitos*/  then case_block2:
                do:
                  assign v_val_db = 0.

                  /* Begin_Include: i_calc_debito_sdo_ctbl */
                    if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                    then do:
                        if v_cod_dwb_user begins 'es_'
                        and v_nom_prog <> "Di rio" /*l_diario*/  then
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

               when "Cr‚ditos" /*l_creditos*/  then case_block2:
                do:
                  assign v_val_cr = 0.

                  /* Begin_Include: i_calc_credito_sdo_ctbl */
                  if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                  then do:
                      if v_cod_dwb_user begins 'es_'
                      and v_nom_prog <> "Di rio" /*l_diario*/  then
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
                    if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Or‡amento" /*l_orcamento*/  then do:
                       if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                       then do:
                           if v_val_orcado = 0.01 then next.
                               else

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
                           and v_nom_prog <> "Di rio" /*l_diario*/  then
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


                    /***Customizacao Justificativa orcamentaria Araupel****/ 
                    /****Busca no cadastro do periodo se o ultimo perioodo esta fechado*******/
                    /*********zera empenho se estiver***********************/

            FIND FIRST periodo_orcto NO-LOCK NO-ERROR.

                  assign v_val_empenh   = 0
                         v_val_sdo_ctbl = 0.

                  if tt_col_demonst_ctbl.ind_qualific_col_ctbl = "Valor" /*l_valor*/  
                  then do:
                      if v_cod_dwb_user begins 'es_'
                      and v_nom_prog <> "Di rio" /*l_diario*/  then
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

                        IF date(int(prefer_demonst_ctbl.num_period_ctbl), 01, int(prefer_demonst_ctbl.cod_exerc_ctbl) ) <= date(periodo_orcto.Mes, 01, periodo_orcto.Ano) THEN

                        assign v_val_empenh = 0.
                        ELSE
                        ASSIGN v_val_empenh = v_val_movto_empenh.
                    end.
                    else do:
                        assign v_val_empenh = v_qtd_movto_empenh.
                    end.

                  /* End_Include: i_calc_empenh_sdo_ctbl */

                  assign v_val_sdo_ctbl = v_val_sdo_ctbl + v_val_empenh.
               end.

               when "Saldo Final" /*l_saldo_final*/  then case_block2:
                do:
                  if tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Or‡amento" /*l_orcamento*/  then do:
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
                      and v_nom_prog <> "Di rio" /*l_diario*/  then
                          assign v_log_consid_apurac_restdo =  (entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10)) = 'yes').
                      else assign v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo.

                         if  v_log_consid_apurac_restdo = no
                         then do:

                             if v_log_sped then /* Considera somente a apura‡Æo do per¡odo, nÆo do ano todo */
                                assign v_val_sdo_ctbl = v_val_sdo_ctbl_fim + v_val_apurac_restdo_inic_50.
                             else

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
               when "% Participac" /*l_%_Participa‡Æo*/  then case_block2:
                do:
                     assign v_val_sdo_ctbl = v_val_perc_particip.
               end.
            end.
            /* 211931 - SE O PAI DA UNIDADE DE NEGàCIO SELECIONADO ESTIVER DENTRO DA FAIXA
             DESCONSIDERA A UNIDADE DE NEGàCIO PAI NA SOMA TOTAL */
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
                    find first emsuni.unid_negoc no-lock
                        where unid_negoc.cod_unid_negoc = estrut_unid_negoc.cod_unid_negoc_filho 
                          and unid_negoc.ind_espec_unid_negoc = "Sint‚tica" /*l_sintetica*/  no-error.
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
                tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl = "% Participac" /*l_%_Participa‡Æo*/ 
            then do:
                assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
                return.
            end.

            /* * Recalcula valor segundo Cota»’o cadastrada no Conjto Prefer¼ncias **/
            if avail tt_grp_col_demonst_video then
               assign v_val_sdo_ctbl = FnAjustDec(round(v_val_sdo_ctbl / tt_grp_col_demonst_video.ttv_val_cotac_indic_econ,2), v_cod_moed_finalid).
            if v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

            if  p_log_inverte_val
            and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "D‚bitos" /*l_debitos*/  
            and tt_col_demonst_ctbl.ind_tip_val_sdo_ctbl <> "Cr‚ditos" /*l_creditos*/   then
                assign v_val_sdo_ctbl = v_val_sdo_ctbl * -1.

            if v_cod_dwb_user begins 'es_' 
            and v_nom_prog <> "Di rio" /*l_diario*/  then          
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
        and v_nom_prog <> "Di rio" /*l_diario*/  then
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
        for emsuni.ccusto.
    def output param p_log_return
        as logical
        format "Sim/NÆo"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default ‚ nÆo ter permissÆo */

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
            where segur_ccusto.cod_empresa    = p_ccusto.cod_empresa
            and segur_ccusto.cod_plano_ccusto = p_ccusto.cod_plano_ccusto
            and segur_ccusto.cod_ccusto       = p_ccusto.cod_ccusto NO-LOCK.
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
** Procedure Interna.....: pi_cria_item_sem_sdo_2
** Descricao.............: pi_cria_item_sem_sdo_2
** Criado por............: src531
** Criado em.............: 09/08/2002 11:07:23
** Alterado por..........: fut41422_1
** Alterado em...........: 05/09/2012 15:20:50
*****************************************************************************/
PROCEDURE pi_cria_item_sem_sdo_2:

    find tt_item_demonst_ctbl_video
       where tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
         and tt_item_demonst_ctbl_video.ttv_cod_chave_1            = v_cod_c_1
         and tt_item_demonst_ctbl_video.ttv_cod_chave_2            = v_cod_c_2
         and tt_item_demonst_ctbl_video.ttv_cod_chave_3            = v_cod_c_3
         and tt_item_demonst_ctbl_video.ttv_cod_chave_4            = v_cod_c_4
         and tt_item_demonst_ctbl_video.ttv_cod_chave_5            = v_cod_c_5
         and tt_item_demonst_ctbl_video.ttv_cod_chave_6            = v_cod_c_6
         no-lock no-error.
    if not avail tt_item_demonst_ctbl_video then do:

        run pi_valida_itens_sem_sdo /*pi_valida_itens_sem_sdo*/.
        if return-value = "NOK" /*l_nok*/  then return.

        create tt_item_demonst_ctbl_video. 
        assign tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl        = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
               tt_item_demonst_ctbl_video.ttv_cod_chave_1                 = v_cod_c_1
               tt_item_demonst_ctbl_video.ttv_cod_chave_2                 = v_cod_c_2
               tt_item_demonst_ctbl_video.ttv_cod_chave_3                 = v_cod_c_3
               tt_item_demonst_ctbl_video.ttv_cod_chave_4                 = v_cod_c_4
               tt_item_demonst_ctbl_video.ttv_cod_chave_5                 = v_cod_c_5
               tt_item_demonst_ctbl_video.ttv_cod_chave_6                 = v_cod_c_6
               tt_item_demonst_ctbl_video.ttv_cod_identif_campo           = v_cod_estrut
               tt_item_demonst_ctbl_video.tta_ind_orig_val_col_demonst    = ""
               tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_video = recid(tt_item_demonst_ctbl_video).

        assign tt_item_demonst_ctbl_video.ttv_rec_item_demonst_ctbl_cad = recid(tt_item_demonst_ctbl_cadastro)
               tt_item_demonst_ctbl_video.ttv_log_tit_ctbl_vld = yes.

        assign v_des_visualiz     = tt_item_demonst_ctbl_video.ttv_cod_chave_1 + chr(59)
                                  + tt_item_demonst_ctbl_video.ttv_cod_chave_2 + chr(59)
                                  + tt_item_demonst_ctbl_video.ttv_cod_chave_3 + chr(59)
                                  + tt_item_demonst_ctbl_video.ttv_cod_chave_4 + chr(59)
                                  + tt_item_demonst_ctbl_video.ttv_cod_chave_5 + chr(59)
                                  + tt_item_demonst_ctbl_video.ttv_cod_chave_6.

        if  tt_item_demonst_ctbl_cadastro.des_tit_ctbl = "" then do:
            if v_log_tit_demonst then do: 
                /* 218397 Na parametriza»’o, ² possivel informar mais de uma coluna titulo */
                assign v_num_cont_1 = 0.
                for each tt_col_demonst_ctbl no-lock
                    where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                      and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T¡tulo" /*l_titulo*/  :
                    assign v_num_cont_1 = v_num_cont_1 + 1
                           v_num_cont_2 = v_num_cont_1. /* A pi_busca_descricoes_video tbm ² tratado no MGLA204aa, precisarÿ desta var*/

                    if v_cod_1 = "Conta Cont bil" /*l_conta_contabil*/  then
                        assign v_cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl.

                    run pi_busca_descricoes_video.

                    /* * Controle de tabula¯Êo segundo Parümetros de ImpressÊo do Item Demonstrativo **/
                    if tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst > 0 then do:
                        if tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_1.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                        assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                    end.       
                end.
            end.
            else do:
                find first tt_col_demonst_ctbl no-lock
                    where tt_col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
                      and tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "T¡tulo" /*l_titulo*/   no-error.
                if  avail tt_col_demonst_ctbl then do:

                    if v_cod_1 = "Conta Cont bil" /*l_conta_contabil*/  then
                        assign v_cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl.            

                    run pi_busca_descricoes_video.

                    /* * Controle de tabula¯Êo segundo Parümetros de ImpressÊo do Item Demonstrativo **/
                    if tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst > 0 then do:
                        if tt_item_demonst_ctbl_video.ttv_des_chave_1 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_1 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_1.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_2 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_2 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_2.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_3 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_3 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_3.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_4 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_4 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_4.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_5 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_5 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_5.
                        if tt_item_demonst_ctbl_video.ttv_des_chave_6 = tt_item_demonst_ctbl_video.tta_des_tit_ctbl then
                            assign tt_item_demonst_ctbl_video.ttv_des_chave_6 = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.ttv_des_chave_6.
                        assign tt_item_demonst_ctbl_video.tta_des_tit_ctbl = fill(" ",tt_item_demonst_ctbl_cadastro.num_endent_lin_demonst) + tt_item_demonst_ctbl_video.tta_des_tit_ctbl.
                    end.
                end. 
            end.
        end.
    end.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_cria_item_sem_sdo_2 */
/*****************************************************************************
** Procedure Interna.....: pi_cria_item_sem_sdo
** Descricao.............: pi_cria_item_sem_sdo
** Criado por............: src531
** Criado em.............: 09/08/2002 11:10:21
** Alterado por..........: fut35059
** Alterado em...........: 01/11/2006 10:47:19
*****************************************************************************/
PROCEDURE pi_cria_item_sem_sdo:

    /************************* Variable Definition Begin ************************/

    def var v_cod_aux                        as character       no-undo. /*local*/
    def var v_log_restric_ccusto_estab       as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_aux = entry(v_num_contador, v_cod_estrut, chr(10)).

    if  v_cod_aux <> "" then do:    
        if  v_cod_aux = "Conta Cont bil" /*l_conta_contabil*/  then do:
            if  v_cod_1 = "" then
                assign v_cod_1 = "Conta Cont bil" /*l_conta_contabil*/ .
            else
            if  v_cod_2 = "" then
                assign v_cod_2 = "Conta Cont bil" /*l_conta_contabil*/ .
            else
            if  v_cod_3 = "" then
                assign v_cod_3 = "Conta Cont bil" /*l_conta_contabil*/ .
            else
            if  v_cod_4 = "" then
                assign v_cod_4 = "Conta Cont bil" /*l_conta_contabil*/ .
            else
            if  v_cod_5 = "" then
                assign v_cod_5 = "Conta Cont bil" /*l_conta_contabil*/ .
            else
            if  v_cod_6 = "" then
                assign v_cod_6 = "Conta Cont bil" /*l_conta_contabil*/ .

            cta_ctbl:
            for each cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl  = tt_input_sdo.tta_cod_plano_cta_ctbl
                and   cta_ctbl.cod_cta_ctbl       >= tt_input_sdo.tta_cod_cta_ctbl_inic
                and   cta_ctbl.cod_cta_ctbl       <= tt_input_sdo.tta_cod_cta_ctbl_fim:

                /* --- Verifica Espýcie da Conta ---*/
                if tt_input_sdo.ttv_ind_espec_cta = "Primeiro N¡vel" /*l_primeiro_nivel*/   then do:
                    /* Consulta de Saldos */
                    if not can-find(first estrut_cta_ctbl
                            where estrut_cta_ctbl.cod_plano_Cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
                            and   estrut_cta_ctbl.cod_cta_ctbl_filho = cta_ctbl.cod_cta_ctbl
                            and   estrut_cta_ctbl.cod_cta_ctbl_pai   = "") then
                        next cta_ctbl.
                end.
                else do:
                    if tt_input_sdo.ttv_ind_espec_cta <> "" then do:
                        if (tt_input_sdo.ttv_ind_espec_cta <> "Todas" /*l_todas*/  
                        and tt_input_sdo.ttv_ind_espec_cta <> cta_ctbl.ind_espec_cta_ctbl) then
                            next cta_ctbl.
                    end.
                end.

                /* Verifica Parte Fixa */
                if (not cta_ctbl.cod_cta_ctbl matches tt_input_sdo.ttv_cod_cta_ctbl_pfixa and tt_input_sdo.ttv_cod_cta_ctbl_pfixa <> '') then
                    next cta_ctbl.

                /* Verifica Excecao */
                if tt_input_sdo.ttv_cod_cta_ctbl_excec <> "" then do:
                    do v_num_count = 1 to v_cdn_tot_con_excec:
                        if (entry(v_num_count,tt_input_sdo.ttv_cod_cta_ctbl_excec,chr(10)) <> fill(chr(46), length(cta_ctbl.cod_cta_ctbl))
                        and cta_ctbl.cod_cta_ctbl matches entry(v_num_count,tt_input_sdo.ttv_cod_cta_ctbl_excec,chr(10))) then
                            next cta_ctbl.
                    end.
                end.            
                if  v_cod_1 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_1 = cta_ctbl.cod_cta_ctbl.
                else
                if  v_cod_2 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_2 = cta_ctbl.cod_cta_ctbl.
                else
                if  v_cod_3 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_3 = cta_ctbl.cod_cta_ctbl.
                else
                if  v_cod_4 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_4 = cta_ctbl.cod_cta_ctbl.
                else
                if  v_cod_5 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_5 = cta_ctbl.cod_cta_ctbl.
                else
                if  v_cod_6 = "Conta Cont bil" /*l_conta_contabil*/  then
                    assign v_cod_c_6 = cta_ctbl.cod_cta_ctbl.

                if  entry(v_num_contador + 1, v_cod_estrut, chr(10)) <> "" then do:
                    assign v_num_contador = v_num_contador + 1.
                    run pi_cria_item_sem_sdo.
                    assign v_num_contador = v_num_contador - 1.
                end.
                else do:
                    run pi_cria_item_sem_sdo_2.
                end.
            end.
        end.
        if  v_cod_aux = "Centro de Custo" /*l_centro_de_custo*/  then do:
            if  v_cod_1 = "" then
                assign v_cod_1 = "Centro de Custo" /*l_centro_de_custo*/ .
            else
            if  v_cod_2 = "" then
                assign v_cod_2 = "Centro de Custo" /*l_centro_de_custo*/ .
            else
            if  v_cod_3 = "" then
                assign v_cod_3 = "Centro de Custo" /*l_centro_de_custo*/ .
            else
            if  v_cod_4 = "" then
                assign v_cod_4 = "Centro de Custo" /*l_centro_de_custo*/ .
            else
            if  v_cod_5 = "" then
                assign v_cod_5 = "Centro de Custo" /*l_centro_de_custo*/ .
            else
            if  v_cod_6 = "" then
                assign v_cod_6 = "Centro de Custo" /*l_centro_de_custo*/ .

            for each emsuni.empresa no-lock
               where empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
               and   empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:

                find plano_ccusto
                   where plano_ccusto.cod_empresa = empresa.cod_emp
                   and   plano_ccusto.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                   no-lock no-error.
                if not avail plano_ccusto then
                    next.

                ccusto:
                for each emsuni.ccusto no-lock
                    where ccusto.cod_empresa       = empresa.cod_emp
                    and   ccusto.cod_plano_ccusto  = tt_input_sdo.tta_cod_plano_ccusto
                    and   ccusto.cod_ccusto       >= tt_input_sdo.tta_cod_ccusto_inic
                    and   ccusto.cod_ccusto       <= tt_input_sdo.tta_cod_ccusto_fim:

                    /* Verifica Restri‡Æo Estabelecimento*/
                    if not can-find(first estabelecimento no-lock
                                    where estabelecimento.cod_empresa = empresa.cod_emp
                                      and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                                      and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim) then next ccusto.

                    estabelecimento:
                    for each estabelecimento no-lock
                       where estabelecimento.cod_empresa = empresa.cod_emp
                         and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                         and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                        assign v_log_restric_ccusto_estab = no. 

                        if can-find(first restric_ccusto
                                    where restric_ccusto.cod_empresa      = empresa.cod_emp
                                      and restric_ccusto.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                                      and restric_ccusto.cod_ccusto       = ccusto.cod_ccusto
                                      and restric_ccusto.cod_estab        = estabelecimento.cod_estab) then 
                            assign v_log_restric_ccusto_estab = yes.
                        else
                            leave estabelecimento.
                    end.

                    if v_log_restric_ccusto_estab = yes then next ccusto.

                    /* Verifica Parte Fixa */
                    if ( not ccusto.cod_ccusto matches tt_input_sdo.ttv_cod_ccusto_pfixa and tt_input_sdo.ttv_cod_ccusto_pfixa <> '') then
                        next ccusto.

                    /* Verifica Excecao */
                    if tt_input_sdo.ttv_cod_ccusto_excec <> "" then do:
                        do v_num_count = 1 to v_cdn_tot_ccusto_excec:
                            if (entry(v_num_count,tt_input_sdo.ttv_cod_ccusto_excec,chr(10)) <> fill(chr(46), length(ccusto.cod_ccusto))
                            and ccusto.cod_ccusto matches entry(v_num_count,tt_input_sdo.ttv_cod_ccusto_excec,chr(10))) then
                                next ccusto.
                        end.
                    end.

                    if tt_input_sdo.ttv_ind_espec_cta = '' /* consulta saldo conta centro custo */  then do: 
                        run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                                 Input "CCusto" /*l_ccusto*/ ,
                                                                 output v_cod_initial,
                                                                 output v_cod_final) /* pi_retornar_valores_iniciais_prefer*/.

                        /* Se o Pai do ccusto selecionado estiver dentro da faixa desconsidera o ccusto */
                        IF  CAN-find(first estrut_ccusto
                            where estrut_ccusto.cod_empresa      = empresa.cod_emp
                            and   estrut_ccusto.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                            and   estrut_ccusto.cod_ccusto_filho = ccusto.cod_ccusto
                            and   estrut_ccusto.cod_ccusto_pai  >= tt_input_sdo.tta_cod_ccusto_inic
                            and   estrut_ccusto.cod_ccusto_pai  <= tt_input_sdo.tta_cod_ccusto_fim
                            and   estrut_ccusto.cod_ccusto_pai  <> ""
                            and   estrut_ccusto.cod_ccusto_pai  <> v_cod_initial) then do:
                            next ccusto.
                        end.
                    end.

                    if  v_cod_1 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_1 = ccusto.cod_ccusto.
                    else
                    if  v_cod_2 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_2 = ccusto.cod_ccusto.
                    else
                    if  v_cod_3 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_3 = ccusto.cod_ccusto.
                    else
                    if  v_cod_4 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_4 = ccusto.cod_ccusto.
                    else
                    if  v_cod_5 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_5 = ccusto.cod_ccusto.
                    else
                    if  v_cod_6 = "Centro de Custo" /*l_centro_de_custo*/   then
                        assign v_cod_c_6 = ccusto.cod_ccusto.

                    if  entry(v_num_contador + 1, v_cod_estrut, chr(10)) <> "" then do:
                        assign v_num_contador = v_num_contador + 1.
                        run pi_cria_item_sem_sdo.
                        assign v_num_contador = v_num_contador - 1.
                    end.
                    else do:
                        run pi_cria_item_sem_sdo_2.
                    end.
                end.
            end.
        end.
        if  v_cod_aux = "Estabelecimento" /*l_estabelecimento*/  then do:
            if  v_cod_1 = "" then
                assign v_cod_1 = "Estabelecimento" /*l_estabelecimento*/ .
            else
            if  v_cod_2 = "" then
                assign v_cod_2 = "Estabelecimento" /*l_estabelecimento*/ .
            else
            if  v_cod_3 = "" then
                assign v_cod_3 = "Estabelecimento" /*l_estabelecimento*/ .
            else
            if  v_cod_4 = "" then
                assign v_cod_4 = "Estabelecimento" /*l_estabelecimento*/ .
            else
            if  v_cod_5 = "" then
                assign v_cod_5 = "Estabelecimento" /*l_estabelecimento*/ .
            else
            if  v_cod_6 = "" then
                assign v_cod_6 = "Estabelecimento" /*l_estabelecimento*/ .
            for each empresa no-lock
               where empresa.cod_empresa >= tt_input_sdo.tta_cod_unid_organ_inic
               and   empresa.cod_empresa <= tt_input_sdo.tta_cod_unid_organ_fim:
                for each estabelecimento no-lock
                    where estabelecimento.cod_empresa = empresa.cod_empresa
                    and   estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                    and   estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                    if  v_cod_1 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_1 = estabelecimento.cod_estab.
                    else
                    if  v_cod_2 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_2 = estabelecimento.cod_estab.
                    else
                    if  v_cod_3 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_3 = estabelecimento.cod_estab.
                    else
                    if  v_cod_4 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_4 = estabelecimento.cod_estab.
                    else
                    if  v_cod_5 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_5 = estabelecimento.cod_estab.
                    else
                    if  v_cod_6 = "Estabelecimento" /*l_estabelecimento*/   then
                        assign v_cod_c_6 = estabelecimento.cod_estab.

                    if  entry(v_num_contador + 1, v_cod_estrut, chr(10)) <> "" then do:
                        assign v_num_contador = v_num_contador + 1.
                        run pi_cria_item_sem_sdo.
                        assign v_num_contador = v_num_contador - 1.
                    end.
                    else do:
                        run pi_cria_item_sem_sdo_2.
                    end.
                end.
            end.
        end.
        if  v_cod_aux = "Unidade Neg¢cio" /*l_unidade_negocio*/  then do:
            if  v_cod_1 = "" then
                assign v_cod_1 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .
            else
            if  v_cod_2 = "" then
                assign v_cod_2 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .
            else
            if  v_cod_3 = "" then
                assign v_cod_3 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .
            else
            if  v_cod_4 = "" then
                assign v_cod_4 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .
            else
            if  v_cod_5 = "" then
                assign v_cod_5 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .
            else
            if  v_cod_6 = "" then
                assign v_cod_6 = "Unidade Neg¢cio" /*l_unidade_negocio*/ .

            for each tt_unid_negocio
                where tt_unid_negocio.tta_cod_unid_negoc >= tt_input_sdo.tta_cod_unid_negoc_inic
                and   tt_unid_negocio.tta_cod_unid_negoc <= tt_input_sdo.tta_cod_unid_negoc_fim:

                if  v_cod_1 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_1 = tt_unid_negocio.tta_cod_unid_negoc.
                else
                if  v_cod_2 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_2 = tt_unid_negocio.tta_cod_unid_negoc.
                else
                if  v_cod_3 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_3 = tt_unid_negocio.tta_cod_unid_negoc.
                else
                if  v_cod_4 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_4 = tt_unid_negocio.tta_cod_unid_negoc.
                else
                if  v_cod_5 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_5 = tt_unid_negocio.tta_cod_unid_negoc.
                else
                if  v_cod_6 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
                    assign v_cod_c_6 = tt_unid_negocio.tta_cod_unid_negoc.

                if  entry(v_num_contador + 1, v_cod_estrut, chr(10)) <> "" then do:
                    assign v_num_contador = v_num_contador + 1.
                    run pi_cria_item_sem_sdo.
                    assign v_num_contador = v_num_contador - 1.
                end.
                else do:
                    run pi_cria_item_sem_sdo_2.
                end.
            end.
        end.
        if  v_cod_aux = "Projeto" /*l_projeto*/  then do:
            if  v_cod_1 = "" then
                assign v_cod_1 = "Projeto" /*l_projeto*/ .
            else
            if  v_cod_2 = "" then
                assign v_cod_2 = "Projeto" /*l_projeto*/ .
            else
            if  v_cod_3 = "" then
                assign v_cod_3 = "Projeto" /*l_projeto*/ .
            else
            if  v_cod_4 = "" then
                assign v_cod_4 = "Projeto" /*l_projeto*/ .
            else
            if  v_cod_5 = "" then
                assign v_cod_5 = "Projeto" /*l_projeto*/ .
            else
            if  v_cod_6 = "" then
                assign v_cod_6 = "Projeto" /*l_projeto*/ .

            proj_financ:
            for each tt_proj_financ_demonst
                where tt_proj_financ_demonst.tta_cod_proj_financ >= tt_input_sdo.tta_cod_proj_financ_inic
                and   tt_proj_financ_demonst.tta_cod_proj_financ <= tt_input_sdo.tta_cod_proj_financ_fim:

                /* Verifica Parte Fixa */
                if ( not tt_proj_financ_demonst.tta_cod_proj_financ matches substring(tt_input_sdo.ttv_cod_proj_financ_pfixa,1,length(tt_proj_financ_demonst.tta_cod_proj_financ)) and tt_input_sdo.ttv_cod_proj_financ_pfixa <> '') then
                    next proj_financ.

                /* Verifica Excecao */
                if tt_input_sdo.ttv_cod_proj_financ_excec <> "" then do:
                    do v_num_count = 1 to v_cdn_tot_proj_excec:
                        if (substring(entry(v_num_count,tt_input_sdo.ttv_cod_proj_financ_excec,chr(10)),1,length(tt_proj_financ_demonst.tta_cod_proj_financ)) <> fill(chr(46), length(tt_proj_financ_demonst.tta_cod_proj_financ))
                        and tt_proj_financ_demonst.tta_cod_proj_financ matches (substring(entry(v_num_count,tt_input_sdo.ttv_cod_proj_financ_excec,chr(10)),1,length(tt_proj_financ_demonst.tta_cod_proj_financ)))) then
                            next proj_financ.
                    end.
                end.

                if  v_cod_1 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_1 = tt_proj_financ_demonst.tta_cod_proj_financ.
                else
                if  v_cod_2 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_2 = tt_proj_financ_demonst.tta_cod_proj_financ.
                else
                if  v_cod_3 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_3 = tt_proj_financ_demonst.tta_cod_proj_financ.
                else
                if  v_cod_4 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_4 = tt_proj_financ_demonst.tta_cod_proj_financ.
                else
                if  v_cod_5 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_5 = tt_proj_financ_demonst.tta_cod_proj_financ.
                else
                if  v_cod_6 = "Projeto" /*l_projeto*/  then
                    assign v_cod_c_6 = tt_proj_financ_demonst.tta_cod_proj_financ.

                if  entry(v_num_contador + 1, v_cod_estrut, chr(10)) <> "" then do:
                    assign v_num_contador = v_num_contador + 1.
                    run pi_cria_item_sem_sdo.
                    assign v_num_contador = v_num_contador - 1.
                end.
                else do:
                    run pi_cria_item_sem_sdo_2.
                end.
            end.
        end.
    end.

END PROCEDURE. /* pi_cria_item_sem_sdo */
/*****************************************************************************
** Procedure Interna.....: pi_calcula_numero_posicoes_formato_505
** Descricao.............: pi_calcula_numero_posicoes_formato_505
** Criado por............: src531
** Criado em.............: 04/09/2002 14:33:15
** Alterado por..........: src531
** Alterado em...........: 04/09/2002 14:35:25
*****************************************************************************/
PROCEDURE pi_calcula_numero_posicoes_formato_505:

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
    or  string(substring(p_cod_format,1))   = 'Z'
    or  string(substring(p_cod_format,1))   = '>'
    or  string(substring(p_cod_format,1,2)) = '(z' 
    or  string(substring(p_cod_format,1,2)) = '(>' then do:
        assign p_num_pos_calc = length(p_cod_format).
        return.         
    end.    

END PROCEDURE. /* pi_calcula_numero_posicoes_formato_505 */
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
** Procedure Interna.....: pi_valida_formato_excessao_demonst_ctbl_video
** Descricao.............: pi_valida_formato_excessao_demonst_ctbl_video
** Criado por............: src531
** Criado em.............: 02/10/2002 10:57:11
** Alterado por..........: src531
** Alterado em...........: 02/10/2002 11:02:29
*****************************************************************************/
PROCEDURE pi_valida_formato_excessao_demonst_ctbl_video:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_format_2
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_aux_1                      as character       no-undo. /*local*/
    def var v_cod_aux_2                      as character       no-undo. /*local*/
    def var v_cod_aux_3                      as character       no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_aux_1 = p_cod_format_1
           v_cod_aux_2 = p_cod_format_2.

    do  v_num_cont = 1 to length(v_cod_aux_1):
        if  substr(v_cod_aux_1, v_num_cont, 1) = substr(v_cod_aux_2, v_num_cont, 1) then
            assign  v_cod_aux_3 = v_cod_aux_3 + substr(v_cod_aux_1, v_num_cont, 1).
        else do:
            if  substr(v_cod_aux_1, v_num_cont, 1) = "#" then
                assign  v_cod_aux_3 = v_cod_aux_3 + substr(v_cod_aux_2, v_num_cont, 1).
            else
                if  substr(v_cod_aux_2, v_num_cont, 1) = "#" then
                    assign  v_cod_aux_3 = v_cod_aux_3 + substr(v_cod_aux_1, v_num_cont, 1).
                else
                    assign  v_cod_aux_3 =  v_cod_aux_3 + "#".
        end.
    end.
    assign  p_cod_return = v_cod_aux_3.

END PROCEDURE. /* pi_valida_formato_excessao_demonst_ctbl_video */
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
           and   btt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo       = "Or‡amento" /*l_orcamento*/ 
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
** Procedure Interna.....: pi_grava_ult_objeto
** Descricao.............: pi_grava_ult_objeto
** Criado por............: src12337
** Criado em.............: 21/10/2003 18:12:02
** Alterado por..........: corp45760
** Alterado em...........: 22/05/2014 09:47:58
*****************************************************************************/
PROCEDURE pi_grava_ult_objeto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_ult_obj_procesdo
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_seconds_fim_api
        as integer
        format ">>>>,>>9":U
        initial 0
        no-undo.
    def var v_num_seconds_inic_api
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

     if  v_num_ped_exec_corren > 0 then do:
            find ped_exec
                where ped_exec.num_ped_exec = v_num_ped_exec_corren
                no-lock no-error.
            if  avail ped_exec then do:
                find servid_exec
                   where servid_exec.cod_servid_exec = ped_exec.cod_servid_exec
                   no-lock no-error.
                if  avail servid_exec
                   &if '{&emsbas_version}' <= '5.05' &then           
                    and (    servid_exec.num_livre_2 = 1 ) then do:
                   &else
                    and (    servid_exec.log_gera_extrat_vers = yes ) then do:
                   &endif

                   &if '{&emsbas_version}' >= '5.07A' &then           
                    assign v_cod_arq = servid_exec.nom_dir_spool
                                     + '/es_' + string(ped_exec.num_ped_exec,"999999999") + '.ext'.
                   &else
                    assign v_cod_arq = servid_exec.nom_dir_spool
                                     + '/es_' + string(ped_exec.num_ped_exec,"99999") + '.ext'.
                   &endif
                   assign v_cod_tip_prog = 'pro,dic'.
                   if  v_cod_arq     <> '' 
                   and v_cod_arq     <> ? 
                   and 'api_atualizar_ult_obj' <> 'api_atualizar_ult_obj' then do:
                       assign v_cod_arq      = ""
                              v_cod_tip_prog = "".
                   end.
                end.
                else do:
                    if (v_cod_arq <> '' and v_cod_arq <> ?) then do:
                    end.
                end.
            end.
        end.
        assign v_num_seconds_inic_api = time.

        if v_num_seconds_inic_api < v_num_seconds_fim_api then do:
            v_num_seconds_fim_api = time.
        end.

        /* So atualiza a cada 60 segundos */
        if  (v_num_seconds_inic_api - v_num_seconds_fim_api) >= 60
        then do:
            assign v_num_seconds_fim_api = time.

            find ped_exec exclusive-lock
                where ped_exec.num_ped_exec = v_num_ped_exec_corren /* cl_le_ped_exec_global of ped_exec*/ no-error.
            if  avail ped_exec
            then do:
                assign ped_exec.cod_ult_obj_procesdo = substring(p_cod_ult_obj_procesdo,1,32).
            end /* if */.
            else do:
              return "NOK" /*l_nok*/ .
            end /* else */.
        end /* if */.
END PROCEDURE. /* pi_grava_ult_objeto */
/*****************************************************************************
** Procedure Interna.....: pi_item_compos_demonst_formul_2
** Descricao.............: pi_item_compos_demonst_formul_2
** Criado por............: fut1180
** Criado em.............: 26/08/2004 18:06:29
** Alterado por..........: fut12209_2
** Alterado em...........: 05/04/2005 09:54:00
*****************************************************************************/
PROCEDURE pi_item_compos_demonst_formul_2:

    /* --- Cria‡Æo dos tt_item_demonst_ctbl_video ---*/
    find tt_item_demonst_ctbl_video
        where tt_item_demonst_ctbl_video.ttv_val_seq_demonst_ctbl   = tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl no-error.

    var_formul_block:
    for each tt_var_formul_1:
        delete tt_var_formul_1.
    end.
    /* --- Pesquisa Valores das Colunas ---*/
    run pi_ident_var_formul_1 (Input tt_compos_demonst_cadastro.des_formul_ctbl) /*pi_ident_var_formul_1*/.

    /* --- Composi»’o das Linhas do Demonstrativo ---*/
    for each tt_col_demonst_ctbl no-lock
        where tt_col_demonst_ctbl.ind_orig_val_col_demonst = "F¢rmula" /*l_formula*/ :

        if index(tt_col_demonst_ctbl.des_formul_ctbl,'/') <> 0 or
           index(tt_col_demonst_ctbl.des_formul_ctbl,'*') <> 0 then next.

        assign v_val_sdo_ctbl = 0.

        var_formul_block:
        for each tt_var_formul_1 no-lock:
            assign tt_var_formul_1.ttv_val_var_formul_1 = 0.
            for each tt_acumul_demonst_ctbl_result no-lock
                where tt_acumul_demonst_ctbl_result.tta_cod_acumul_ctbl      = tt_var_formul_1.ttv_cod_var_formul
                  and tt_acumul_demonst_ctbl_result.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                  and tt_acumul_demonst_ctbl_result.tta_num_seq_demonst_ctbl < tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl :

                assign tt_var_formul_1.ttv_val_var_formul_1 = tt_var_formul_1.ttv_val_var_formul_1 + tt_acumul_demonst_ctbl_result.ttv_val_sdo_ctbl_fim_sint_acumul.
            end.
        end.

        run pi_calcul_formul_1 (input-output v_val_sdo_ctbl,
                                input tt_compos_demonst_cadastro.des_formul_ctbl,
                                output v_log_return,
                                Input yes) /*pi_calcul_formul_1*/.
        if  v_val_sdo_ctbl = ? then assign v_val_sdo_ctbl = 0.

        if can-find(first tt_var_formul_1) and avail tt_acumul_demonst_ctbl_result
           and tt_col_demonst_ctbl.ind_orig_val_col_demonst = "Or‡amento" /*l_orcamento*/  then
            assign v_log_proces = tt_acumul_demonst_ctbl_result.TTV_LOG_JA_PROCESDO.
        else 
            assign v_log_proces = no.

        find tt_valor_demonst_ctbl_video
            where tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl  = tt_col_demonst_ctbl.cod_col_demonst_ctbl
             and  tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl = recid(tt_item_demonst_ctbl_video)
             no-lock no-error.
        if  not avail tt_valor_demonst_ctbl_video then do:
            create tt_valor_demonst_ctbl_video.
            assign tt_valor_demonst_ctbl_video.tta_cod_col_demonst_ctbl = tt_col_demonst_ctbl.cod_col_demonst_ctbl
                   tt_valor_demonst_ctbl_video.ttv_rec_item_demonst_ctbl= recid(tt_item_demonst_ctbl_video)
                   tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
        end.
        else if  v_log_proces = no then do: 
            if tt_valor_demonst_ctbl_video.ttv_val_col_1 = ? then
                assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = 0.
                assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.
        end.
        else if  tt_col_demonst_ctbl.ind_orig_val_col_demonst  = "Or‡amento" /*l_orcamento*/   then 
            assign tt_valor_demonst_ctbl_video.ttv_val_col_1 = v_val_sdo_ctbl.                            

        if  v_log_final_proces = yes then do:
            assign  v_log_proces = no.
            run pi_calcula_acumulador_video (Input tt_col_demonst_ctbl.cod_col_demonst_ctbl,
                                             Input v_val_sdo_ctbl) /*pi_calcula_acumulador_video*/.
        end.
    end.
END PROCEDURE. /* pi_item_compos_demonst_formul_2 */
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

    /* ** Substitui vari vel pelo valor dela ***/
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
             /* Vari vel nÆo definida ! */
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
              /* Erro de sintaxe na expressÆo ! */
              run pi_messages (input "show",
                               input 1238,
                               input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1238*/.
           end /* if */.
           assign v_log_retorno = yes.
       end /* else */.
    end /* else */.
END PROCEDURE. /* pi_calcul_formul_substitui_1 */
/*****************************************************************************
** Procedure Interna.....: pi_ttPeriodGLBalanceInformation_XML
** Descricao.............: pi_ttPeriodGLBalanceInformation_XML
** Criado por............: its0105
** Criado em.............: 25/07/2005 13:37:11
** Alterado por..........: fut41422_1
** Alterado em...........: 10/03/2014 10:09:49
*****************************************************************************/
PROCEDURE pi_ttPeriodGLBalanceInformation_XML:

    /************************* Variable Definition Begin ************************/

    def var v_num_seq                        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  not avail utiliz_cenar_ctbl then do:
        assign v_num_seq = 0.
        find last tt_log_erros no-error.
        if  avail tt_log_erros then
            assign v_num_seq = tt_log_erros.ttv_num_seq.

        create tt_log_erros.
        assign tt_log_erros.ttv_num_seq = v_num_seq + 1
               tt_log_erros.ttv_num_cod_erro = 14206
               .
        assign tt_log_erros.ttv_des_erro     = substitute(getStrTrans("Cen rio Fiscal nÆo encontrado para a Empresa &1 !", "MGL") /*14206*/, v_cod_empres_usuar)
               .
        assign tt_log_erros.ttv_des_ajuda    = substitute(getStrTrans("NÆo foi encontrado um cen rio definido como fiscal para a empresa &1 no per¡odo de &2 at‚ &3." + chr(10) +
    "", "MGL") /*14206*/, v_cod_empres_usuar, v_dat_inic_valid, v_dat_inic_valid).
        return.
    end.

    /* Salva informa‡äes para o XML caso a origem do Saldo seja Cont bil e o Cen rio
       igual ao cen rio fiscal para o per¡odo informado na tela de parametriza‡Æo. */
    if  tt_retorna_sdo_ctbl_demonst.ttv_ind_espec_sdo  = "Cont bil" /*l_contabil*/ 
    then do:

        assign v_num_cont_tt_eai = v_num_cont_tt_eai + 1.

        find last ttPeriodGLBalanceInformationXML
        where ttPeriodGLBalanceInformationXML.ttPeriodGLBalanceInformationID = v_num_cont_tt_eai no-error.
        if  not avail ttPeriodGLBalanceInformationXML then do:

            find first ttPeriodGLBalanceInformationXML
                where ttPeriodGLBalanceInformationXML.CompanyCode         = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
                and   ttPeriodGLBalanceInformationXML.BranchCode          = tt_retorna_sdo_ctbl_demonst.tta_cod_estab
                and   ttPeriodGLBalanceInformationXML.BusinessUnitCode    = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc
                and   ttPeriodGLBalanceInformationXML.AccountPlanCode     = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
                and   ttPeriodGLBalanceInformationXML.AccountCode         = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
                and   ttPeriodGLBalanceInformationXML.CostCenterPlanCode  = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto 
                and   ttPeriodGLBalanceInformationXML.CostCenterCode      = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto
                and   ttPeriodGLBalanceInformationXML.EconomicPurposeCode = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ no-error.
            if  not avail ttPeriodGLBalanceInformationXML then do:

                find cta_ctbl no-lock
                    where cta_ctbl.cod_plano_cta_ctbl = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl 
                    and   cta_ctbl.cod_cta_ctbl       = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl no-error.

                find plano_cta_ctbl no-lock
                    where plano_cta_ctbl.cod_plano_cta_ctbl = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl no-error.

                find plano_ccusto no-lock
                    where plano_ccusto.cod_empresa      = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
                    and   plano_ccusto.cod_plano_ccusto = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto no-error.

                find emsuni.ccusto no-lock
                    where ccusto.cod_empresa      = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
                    and   ccusto.cod_plano_ccusto = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto
                    and   ccusto.cod_ccusto       = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto no-error.

                find emsuni.unid_negoc no-lock
                    where unid_negoc.cod_unid_negoc = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc no-error.

                find estabelecimento no-lock
                    where estabelecimento.cod_estab = tt_retorna_sdo_ctbl_demonst.tta_cod_estab no-error.

                find emsuni.empresa no-lock 
                    where empresa.cod_empresa = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa no-error.

                find finalid_econ no-lock
                    where finalid_econ.cod_finalid_econ = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ no-error.

                    create ttPeriodGLBalanceInformationXML.
                    assign ttPeriodGLBalanceInformationXML.AccountCode                = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
                           ttPeriodGLBalanceInformationXML.AccountDescription         = if avail cta_ctbl then cta_ctbl.des_tit_ctbl else ""
                           ttPeriodGLBalanceInformationXML.AccountPlanCode            = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
                           ttPeriodGLBalanceInformationXML.AccountPlanDescription     = if avail plano_cta_ctbl then plano_cta_ctbl.des_tit_ctbl else ""
                           ttPeriodGLBalanceInformationXML.AlternateAccountCode       = cta_ctbl.cod_altern_cta_ctbl
                           ttPeriodGLBalanceInformationXML.BranchCode                 = tt_retorna_sdo_ctbl_demonst.tta_cod_estab
                           ttPeriodGLBalanceInformationXML.BranchDescription          = if avail estabelecimento then estabelecimento.nom_pessoa else ""
                           ttPeriodGLBalanceInformationXML.BusinessUnitCode           = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc
                           ttPeriodGLBalanceInformationXML.BusinessUnitDescription    = if avail unid_negoc then unid_negoc.des_unid_negoc else ""
                           ttPeriodGLBalanceInformationXML.CompanyCode                = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
                           ttPeriodGLBalanceInformationXML.CompanyDescription         = if avail empresa then empresa.nom_razao_social else ""
                           ttPeriodGLBalanceInformationXML.CostCenterCode             = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto
                           ttPeriodGLBalanceInformationXML.CostCenterDescription      = if avail ccusto then ccusto.des_tit_ctbl else ""
                           ttPeriodGLBalanceInformationXML.CostCenterPlanCode         = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto
                           ttPeriodGLBalanceInformationXML.CostCenterPlanDescription  = if avail plano_ccusto then plano_ccusto.des_tit_ctbl else ""
                           ttPeriodGLBalanceInformationXML.CreditValue                = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr
                           ttPeriodGLBalanceInformationXML.CreditValue_00             = tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_cr
                           ttPeriodGLBalanceInformationXML.DebitValue                 = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db
                           ttPeriodGLBalanceInformationXML.DebitValue_00              = tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_db
                           ttPeriodGLBalanceInformationXML.EconomicPurposeCode        = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ
                           ttPeriodGLBalanceInformationXML.EconomicPurposeDescription = if avail finalid_econ then finalid_econ.des_finalid_econ else ""
                           ttPeriodGLBalanceInformationXML.FinalBalance               = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim
                           ttPeriodGLBalanceInformationXML.FinalBalance_00            = tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim
                           ttPeriodGLBalanceInformationXML.InitialBalance             = (tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim -
                                                                                         tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db +
                                                                                         tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr)
                           ttPeriodGLBalanceInformationXML.InitialBalance_00          = (tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_fim -
                                                                                         tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_db +
                                                                                         tt_retorna_sdo_ctbl_demonst.tta_qtd_sdo_ctbl_cr)
                           ttPeriodGLBalanceInformationXML.InternationalStandardAccountCode = cta_ctbl.cod_cta_ctbl_padr_internac
                           ttPeriodGLBalanceInformationXML.ttPeriodGLBalanceInformationID   = v_num_cont_tt_eai.
            end.
        end.
    end.
END PROCEDURE. /* pi_ttPeriodGLBalanceInformation_XML */
/*****************************************************************************
** Procedure Interna.....: pi_valida_itens_sem_sdo
** Descricao.............: pi_valida_itens_sem_sdo
** Criado por............: fut35059
** Criado em.............: 03/11/2006 16:04:51
** Alterado por..........: fut41162
** Alterado em...........: 24/06/2008 16:21:01
*****************************************************************************/
PROCEDURE pi_valida_itens_sem_sdo:

    assign v_cod_cta_ctbl_valid   = ''
           v_cod_ccusto_valid     = ''
           v_cod_estab_valid      = ''
           v_cod_unid_negoc_valid = ''.

    /* Busca c¢digo da conta cont bil*/
    if  v_cod_1 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_1.
    else
    if  v_cod_2 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_2.
    else    
    if  v_cod_3 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_3.
    else    
    if  v_cod_4 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_4.
    else    
    if  v_cod_5 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_5.
    else  
    if  v_cod_6 = "Conta Cont bil" /*l_conta_contabil*/  then
        assign v_cod_cta_ctbl_valid = v_cod_c_6.

    /* Busca c¢digo do centro de custo*/
    if  v_cod_1 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_1.
    else
    if  v_cod_2 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_2.
    else
    if  v_cod_3 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_3.
    else
    if  v_cod_4 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_4.
    else
    if  v_cod_5 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_5.
    else
    if  v_cod_6 = "Centro de Custo" /*l_centro_de_custo*/  then
        assign v_cod_ccusto_valid = v_cod_c_6.

    /* Busca c¢digo do estabelecimento*/
    if  v_cod_1 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_1.
    else
    if  v_cod_2 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_2.
    else
    if  v_cod_3 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_3.
    else
    if  v_cod_4 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_4.
    else
    if  v_cod_5 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_5.
    else
    if  v_cod_6 = "Estabelecimento" /*l_estabelecimento*/  then
        assign v_cod_estab_valid = v_cod_c_6.

    /* Busca c¢digo da unidade de negocio*/
    if  v_cod_1 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_1.
    else
    if  v_cod_2 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_2.
    else
    if  v_cod_3 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_3.
    else
    if  v_cod_4 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_4.
    else
    if  v_cod_5 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_5.
    else
    if  v_cod_6 = "Unidade Neg¢cio" /*l_unidade_negocio*/  then
        assign v_cod_unid_negoc_valid = v_cod_c_6.

    run pi_valida_itens_sem_sdo_criter_distrib /*pi_valida_itens_sem_sdo_criter_distrib*/.
    if return-value = "NOK" /*l_nok*/  then
       return "NOK" /*l_nok*/ .

    run pi_valida_itens_sem_sdo_restric_cta /*pi_valida_itens_sem_sdo_restric_cta*/.
    if return-value = "NOK" /*l_nok*/  then
       return "NOK" /*l_nok*/ .

    run pi_valida_itens_sem_sdo_restric_ccusto /*pi_valida_itens_sem_sdo_restric_ccusto*/.
    if return-value = "NOK" /*l_nok*/  then
       return "NOK" /*l_nok*/ .

    return "OK" /*l_ok*/ . 
END PROCEDURE. /* pi_valida_itens_sem_sdo */
/*****************************************************************************
** Procedure Interna.....: pi_valida_itens_sem_sdo_criter_distrib
** Descricao.............: pi_valida_itens_sem_sdo_criter_distrib
** Criado por............: fut35059
** Criado em.............: 08/11/2006 09:25:09
** Alterado por..........: fut35183_2
** Alterado em...........: 22/09/2008 15:05:11
*****************************************************************************/
PROCEDURE pi_valida_itens_sem_sdo_criter_distrib:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_cta_ctbl_3
        for cta_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    if  trim(v_cod_cta_ctbl_valid) <> '' and
        trim(v_cod_ccusto_valid)   <> ''
    then do:
        if  trim(v_cod_estab_valid) <> ''
        then do:
            find last criter_distrib_cta_ctbl no-lock
                where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl
                and   criter_distrib_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl_valid
                and   criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_valid
                and   criter_distrib_cta_ctbl.dat_inic_valid    <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                and   criter_distrib_cta_ctbl.dat_fim_valid     >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim) no-error.     
            if  avail criter_distrib_cta_ctbl
            then do:
                if criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos" /*l_utiliza_todos*/  then 
                   return "OK" /*l_ok*/ .
                else do:
                    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
                    then do:
                        find first mapa_distrib_ccusto
                             where mapa_distrib_ccusto.cod_estab               = v_cod_estab_valid
                             and   mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                             and   mapa_distrib_ccusto.dat_inic_valid         <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                             and   mapa_distrib_ccusto.dat_fim_valid          >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim) no-lock no-error.
                        if  avail mapa_distrib_ccusto and
                             mapa_distrib_ccusto.ind_tip_mapa_distrib_ccusto <> "Lista" /*l_lista*/ 
                        then do:

                             if  trim(v_cod_unid_negoc_valid) <> ''
                             then do:
                                 if can-find(first item_distrib_ccusto no-lock
                                             where item_distrib_ccusto.cod_estab               = v_cod_estab_valid
                                               and item_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                               and item_distrib_ccusto.cod_unid_negoc          = v_cod_unid_negoc_valid
                                               and item_distrib_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                               and item_distrib_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .
                             end /* if */.
                             else do:
                                 for each estab_unid_negoc no-lock
                                    where estab_unid_negoc.cod_estab       = v_cod_estab_valid
                                    and   estab_unid_negoc.cod_unid_negoc >= tt_input_sdo.tta_cod_unid_negoc_ini
                                    and   estab_unid_negoc.cod_unid_negoc <= tt_input_sdo.tta_cod_unid_negoc_fim
                                    and   estab_unid_negoc.dat_inic_valid <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                                    and   estab_unid_negoc.dat_fim_valid  >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim):

                                     if can-find(first item_distrib_ccusto no-lock
                                                 where item_distrib_ccusto.cod_estab               = v_cod_estab_valid
                                                   and item_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                                   and item_distrib_ccusto.cod_unid_negoc          = estab_unid_negoc.cod_unid_negoc
                                                   and item_distrib_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                                   and item_distrib_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .
                                 end.
                             end /* else */.  
                         end /* if */.
                         else do:
                             if  avail mapa_distrib_ccusto
                             then do:
                                 if can-find(first item_lista_ccusto no-lock
                                             where item_lista_ccusto.cod_estab               = v_cod_estab_valid
                                               and item_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                               and item_lista_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                               and item_lista_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .

                                 /* Begin_Include: i_valida_itens_sem_sdo_criter_distrib_ccusto_estrut_pai */
                                 /* ================================================================================================*/
                                 /* 203095 - caso nÆo tem crit‚rio de distribui‡Æo, verifico se esse ccusto ‚ pai de uma estrutura */    
                                 /* devo imprimir o pai da estrutura,                                                              */
                                 /* caso no demonstrativo est  flegado como ccusto sint‚tico e se o filho est  dentro do crit‚rio  */
                                 /* ================================================================================================*/
                                 if can-find(first compos_demonst_ctbl no-lock
                                     where compos_demonst_ctbl.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                                       and compos_demonst_ctbl.num_seq_demonst_ctbl = 
                                 tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                                       and compos_demonst_ctbl.log_ccusto_sint = yes) then do:

                                     for each  estrut_ccusto no-lock
                                         where estrut_ccusto.cod_empresa      = b_empresa.cod_emp
                                   	  and estrut_ccusto.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                                           and estrut_ccusto.cod_ccusto_pai   = v_cod_ccusto_valid
                                           and estrut_ccusto.cod_ccusto_filho <> '':
                                         if can-find(first item_lista_ccusto no-lock
                                             where item_lista_ccusto.cod_estab               = v_cod_estab_valid
                                               and item_lista_ccusto.cod_mapa_distrib_ccusto = 
                                 criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                               and item_lista_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                               and item_lista_ccusto.cod_ccusto              = estrut_ccusto.cod_ccusto_filho) then return "OK" /*l_ok*/  .

                                     end.  
                                 end. 
                                 /* End_Include: i_valida_itens_sem_sdo_criter_distrib_ccusto_estrut_pai */
                                 .              
                             end /* if */.
                         end /* else */.
                         return "NOK" /*l_nok*/ . 
                    end /* if */.
                    else do:
                        return "NOK" /*l_nok*/ . 
                    end /* else */.
                end.
            end /* if */.
            else do:
                /* Se a conta verificada for sintetica, retornar OK */
                find  first b_cta_ctbl_3
                where b_cta_ctbl_3.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl 
                and   b_cta_ctbl_3.cod_cta_ctbl       = v_cod_cta_ctbl_valid                no-lock no-error.
                if avail b_cta_ctbl_3
                     and b_cta_ctbl_3.ind_espec_cta_ctbl = "Sint‚tica" /*l_sintetica*/  
                     and v_log_impr_cta_sem_sdo then
                    return "OK" /*l_ok*/ .
                else       
                    return "NOK" /*l_nok*/ .
            end.
        end /* if */.
        else do:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:

                estabelecimento:
                for each estabelecimento no-lock
                   where estabelecimento.cod_empresa = b_empresa.cod_emp
                     and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                     and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                    assign v_cod_estab_valid = estabelecimento.cod_estab.

                    find last criter_distrib_cta_ctbl no-lock
                        where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl
                        and   criter_distrib_cta_ctbl.cod_cta_ctbl       = v_cod_cta_ctbl_valid
                        and   criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_valid
                        and   criter_distrib_cta_ctbl.dat_inic_valid    <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                        and   criter_distrib_cta_ctbl.dat_fim_valid     >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim) no-error.     
                    if  avail criter_distrib_cta_ctbl
                    then do:
                        if criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos" /*l_utiliza_todos*/  then 
                           return "OK" /*l_ok*/ .
                        else do:
                            if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
                            then do:
                                find first mapa_distrib_ccusto
                                     where mapa_distrib_ccusto.cod_estab               = v_cod_estab_valid
                                     and   mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                     and   mapa_distrib_ccusto.dat_inic_valid         <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                                     and   mapa_distrib_ccusto.dat_fim_valid          >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim) no-lock no-error.
                                if  avail mapa_distrib_ccusto and
                                     mapa_distrib_ccusto.ind_tip_mapa_distrib_ccusto <> "Lista" /*l_lista*/ 
                                then do:

                                     if  trim(v_cod_unid_negoc_valid) <> ''
                                     then do:
                                         if can-find(first item_distrib_ccusto no-lock
                                                     where item_distrib_ccusto.cod_estab               = v_cod_estab_valid
                                                       and item_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                                       and item_distrib_ccusto.cod_unid_negoc          = v_cod_unid_negoc_valid
                                                       and item_distrib_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                                       and item_distrib_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .
                                     end /* if */.
                                     else do:
                                         for each estab_unid_negoc no-lock
                                            where estab_unid_negoc.cod_estab       = v_cod_estab_valid
                                            and   estab_unid_negoc.cod_unid_negoc >= tt_input_sdo.tta_cod_unid_negoc_ini
                                            and   estab_unid_negoc.cod_unid_negoc <= tt_input_sdo.tta_cod_unid_negoc_fim
                                            and   estab_unid_negoc.dat_inic_valid <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                                            and   estab_unid_negoc.dat_fim_valid  >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim):

                                             if can-find(first item_distrib_ccusto no-lock
                                                         where item_distrib_ccusto.cod_estab               = v_cod_estab_valid
                                                           and item_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                                           and item_distrib_ccusto.cod_unid_negoc          = estab_unid_negoc.cod_unid_negoc
                                                           and item_distrib_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                                           and item_distrib_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .
                                         end.
                                     end /* else */.

                                 end /* if */.
                                 else do:
                                     if  avail mapa_distrib_ccusto
                                     then do:
                                         if can-find(first item_lista_ccusto no-lock
                                                     where item_lista_ccusto.cod_estab               = v_cod_estab_valid
                                                       and item_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                                       and item_lista_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                                       and item_lista_ccusto.cod_ccusto              = v_cod_ccusto_valid) then return "OK" /*l_ok*/ .

                                          /* Begin_Include: i_valida_itens_sem_sdo_criter_distrib_ccusto_estrut_pai */
                                          /* ================================================================================================*/
                                          /* 203095 - caso nÆo tem crit‚rio de distribui‡Æo, verifico se esse ccusto ‚ pai de uma estrutura */    
                                          /* devo imprimir o pai da estrutura,                                                              */
                                          /* caso no demonstrativo est  flegado como ccusto sint‚tico e se o filho est  dentro do crit‚rio  */
                                          /* ================================================================================================*/
                                          if can-find(first compos_demonst_ctbl no-lock
                                              where compos_demonst_ctbl.cod_demonst_ctbl     = tt_item_demonst_ctbl_cadastro.cod_demonst_ctbl
                                                and compos_demonst_ctbl.num_seq_demonst_ctbl = 
                                          tt_item_demonst_ctbl_cadastro.num_seq_demonst_ctbl
                                                and compos_demonst_ctbl.log_ccusto_sint = yes) then do:

                                              for each  estrut_ccusto no-lock
                                                  where estrut_ccusto.cod_empresa      = b_empresa.cod_emp
                                            	  and estrut_ccusto.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                                                    and estrut_ccusto.cod_ccusto_pai   = v_cod_ccusto_valid
                                                    and estrut_ccusto.cod_ccusto_filho <> '':
                                                  if can-find(first item_lista_ccusto no-lock
                                                      where item_lista_ccusto.cod_estab               = v_cod_estab_valid
                                                        and item_lista_ccusto.cod_mapa_distrib_ccusto = 
                                          criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                                        and item_lista_ccusto.cod_plano_ccusto        = tt_input_sdo.tta_cod_plano_ccusto
                                                        and item_lista_ccusto.cod_ccusto              = estrut_ccusto.cod_ccusto_filho) then return "OK" /*l_ok*/  .

                                              end.  
                                          end. 
                                          /* End_Include: i_valida_itens_sem_sdo_criter_distrib_ccusto_estrut_pai */
                                          . 
                                     end /* if */.
                                 end /* else */.
                                 next estabelecimento. 
                            end /* if */.
                            else do:
                                next estabelecimento. 
                            end /* else */.
                        end.
                    end /* if */.
                    else next estabelecimento.     
                end.
            end.
            /* Se a conta verificada for sintetica, retornar OK */
            find  first b_cta_ctbl_3
            where b_cta_ctbl_3.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl 
            and   b_cta_ctbl_3.cod_cta_ctbl       = v_cod_cta_ctbl_valid                no-lock no-error.
            if avail b_cta_ctbl_3
                 and b_cta_ctbl_3.ind_espec_cta_ctbl = "Sint‚tica" /*l_sintetica*/  
                 and v_log_impr_cta_sem_sdo then
                return "OK" /*l_ok*/ .
            else       
                return "NOK" /*l_nok*/ .        
        end /* else */.
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_valida_itens_sem_sdo_criter_distrib */
/*****************************************************************************
** Procedure Interna.....: pi_valida_itens_sem_sdo_restric_cta
** Descricao.............: pi_valida_itens_sem_sdo_restric_cta
** Criado por............: fut35059
** Criado em.............: 08/11/2006 09:25:19
** Alterado por..........: fut41162
** Alterado em...........: 07/07/2008 15:42:21
*****************************************************************************/
PROCEDURE pi_valida_itens_sem_sdo_restric_cta:

    /************************* Variable Definition Begin ************************/

    def var v_log_valid_cta_restric_estab    as logical         no-undo. /*local*/
    def var v_log_valid_cta_restric_un       as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  trim(v_cod_cta_ctbl_valid) <> ''
    then do:

        assign v_log_valid_cta_restric_un    = no
               v_log_valid_cta_restric_estab = no.

        /* Valida restri‡äes conta cont bil- unidade de negocio*/
        if  trim(v_cod_unid_negoc_valid) <> ''
        then do:
            b_empresa:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                if can-find(first cta_restric_unid_negoc 
                            where cta_restric_unid_negoc.cod_cta_ctbl       = v_cod_cta_ctbl_valid
                              and cta_restric_unid_negoc.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl
                              and cta_restric_unid_negoc.cod_unid_negoc     = v_cod_unid_negoc_valid
                              and cta_restric_unid_negoc.cod_unid_organ     = b_empresa.cod_emp) then return "NOK" /*l_nok*/ .
            end.
        end /* if */.
        else do:
            b_empresa:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                estabelecimento:
                for each estabelecimento no-lock
                   where estabelecimento.cod_empresa = b_empresa.cod_emp
                     and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                     and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                     bl_ccusto:
                     for each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab       = estabelecimento.cod_estab
                          and estab_unid_negoc.cod_unid_negoc >= tt_input_sdo.tta_cod_unid_negoc_ini
                          and estab_unid_negoc.cod_unid_negoc <= tt_input_sdo.tta_cod_unid_negoc_fim
                          and estab_unid_negoc.dat_inic_valid <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                          and estab_unid_negoc.dat_fim_valid  >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim):

                          assign v_cod_unid_negoc_valid     = estab_unid_negoc.cod_unid_negoc
                                 v_log_valid_cta_restric_un = no.

                          if can-find(first cta_restric_unid_negoc 
                                      where cta_restric_unid_negoc.cod_cta_ctbl       = v_cod_cta_ctbl_valid
                                        and cta_restric_unid_negoc.cod_plano_cta_ctbl = tt_input_sdo.tta_cod_plano_cta_ctbl
                                        and cta_restric_unid_negoc.cod_unid_negoc     = v_cod_unid_negoc_valid
                                        and cta_restric_unid_negoc.cod_unid_organ     = b_empresa.cod_emp) then          
                              assign v_log_valid_cta_restric_un = yes.
                          /* =================================================================================
                             se o estab nÆo possui restri‡Æo com a unid neg, valida o ccusto
                             Valido as unid de negocio p/ a cta ctbl ((unid neg) n -> x (cta ctbl/ccusto)),
                             o ccusto devera ter alguma unidade de neg v lida, que estaja v lida p/ a cta ctbl tbm
                             =================================================================================*/
                          if not v_log_valid_cta_restric_un  then do:
                              if  trim(v_cod_unid_negoc_valid) <> '' and trim(v_cod_ccusto_valid) <> '' then do:
                                  if can-find(first ccusto_unid_negoc
                                      where ccusto_unid_negoc.cod_ccusto         = v_cod_ccusto_valid
                                          and ccusto_unid_negoc.cod_empresa      = b_empresa.cod_emp
                                          and ccusto_unid_negoc.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                                          and ccusto_unid_negoc.cod_unid_negoc   = v_cod_unid_negoc_valid) then return "OK" /*l_ok*/  .
                                  else
                                      next bl_ccusto.              
                              end.
                              else
                                  leave b_empresa.
                          end.
                          /* =======================================================================*/                    
                     end.
                end.
            end.
            if v_log_valid_cta_restric_un then return "NOK" /*l_nok*/ .
        end /* else */.

        /* Valida restri‡äes conta cont bil- estabelecimento*/
        if  trim(v_cod_estab_valid) <> ''
        then do:
            b_empresa:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                if can-find(first cta_restric_estab
                            where cta_restric_estab.cod_cta_ctbl        = v_cod_cta_ctbl_valid
                              and cta_restric_estab.cod_estab           = v_cod_estab_valid
                              and cta_restric_estab.cod_plano_cta_ctbl  = tt_input_sdo.tta_cod_plano_cta_ctbl
                              and cta_restric_estab.cod_unid_organ      = b_empresa.cod_emp) then return "NOK" /*l_nok*/ .
            end.
        end /* if */.
        else do:
            b_empresa:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                estabelecimento:
                for each estabelecimento no-lock
                   where estabelecimento.cod_empresa = b_empresa.cod_emp
                     and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                     and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                     assign v_cod_estab_valid = estabelecimento.cod_estab
                            v_log_valid_cta_restric_estab = no.

                     if can-find(first cta_restric_estab
                                 where cta_restric_estab.cod_cta_ctbl        = v_cod_cta_ctbl_valid
                                   and cta_restric_estab.cod_estab           = v_cod_estab_valid
                                   and cta_restric_estab.cod_plano_cta_ctbl  = tt_input_sdo.tta_cod_plano_cta_ctbl
                                   and cta_restric_estab.cod_unid_organ      = b_empresa.cod_emp) then
                         assign v_log_valid_cta_restric_estab = yes.
                     else 
                         leave b_empresa.     
                end.
            end.
            if v_log_valid_cta_restric_estab = yes then return "NOK" /*l_nok*/ .
        end /* else */.
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_valida_itens_sem_sdo_restric_cta */
/*****************************************************************************
** Procedure Interna.....: pi_valida_itens_sem_sdo_restric_ccusto
** Descricao.............: pi_valida_itens_sem_sdo_restric_ccusto
** Criado por............: fut35059
** Criado em.............: 08/11/2006 09:25:35
** Alterado por..........: fut35059
** Alterado em...........: 08/11/2006 10:34:56
*****************************************************************************/
PROCEDURE pi_valida_itens_sem_sdo_restric_ccusto:

    /************************* Variable Definition Begin ************************/

    def var v_log_valid_ccusto_restric_un    as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  trim(v_cod_ccusto_valid)   <> ''
    then do:

        assign v_log_valid_ccusto_restric_un = no.

        /* Valida restri‡äes ccusto- unidade de negocio*/
        if  trim(v_cod_unid_negoc_valid) <> ''
        then do:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                if can-find(first ccusto_unid_negoc
                            where ccusto_unid_negoc.cod_ccusto       = v_cod_ccusto_valid
                              and ccusto_unid_negoc.cod_empresa      = b_empresa.cod_emp
                              and ccusto_unid_negoc.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                              and ccusto_unid_negoc.cod_unid_negoc   = v_cod_unid_negoc_valid) then return "OK" /*l_ok*/ .
            end.
            return "NOK" /*l_nok*/ .
        end /* if */.
        else do:
            b_empresa:
            for each b_empresa no-lock
               where b_empresa.cod_emp >= tt_input_sdo.tta_cod_unid_organ_inic
                 and b_empresa.cod_emp <= tt_input_sdo.tta_cod_unid_organ_fim:
                estabelecimento:
                for each estabelecimento no-lock
                   where estabelecimento.cod_empresa = b_empresa.cod_emp
                     and estabelecimento.cod_estab  >= tt_input_sdo.tta_cod_estab_inic
                     and estabelecimento.cod_estab  <= tt_input_sdo.tta_cod_estab_fim:

                     for each estab_unid_negoc no-lock
                        where estab_unid_negoc.cod_estab       = estabelecimento.cod_estab
                          and estab_unid_negoc.cod_unid_negoc >= tt_input_sdo.tta_cod_unid_negoc_ini
                          and estab_unid_negoc.cod_unid_negoc <= tt_input_sdo.tta_cod_unid_negoc_fim
                          and estab_unid_negoc.dat_inic_valid <= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_inic)
                          and estab_unid_negoc.dat_fim_valid  >= date(tt_input_sdo.ttv_cod_dat_sdo_ctbl_fim):

                          assign v_cod_unid_negoc_valid        = estab_unid_negoc.cod_unid_negoc
                                 v_log_valid_ccusto_restric_un = no.

                          if not can-find(first ccusto_unid_negoc
                                          where ccusto_unid_negoc.cod_ccusto       = v_cod_ccusto_valid
                                            and ccusto_unid_negoc.cod_empresa      = b_empresa.cod_emp
                                            and ccusto_unid_negoc.cod_plano_ccusto = tt_input_sdo.tta_cod_plano_ccusto
                                            and ccusto_unid_negoc.cod_unid_negoc   = v_cod_unid_negoc_valid) then
                              assign v_log_valid_ccusto_restric_un = yes.
                          else 
                              leave b_empresa.
                     end.
                end.
            end.
            if v_log_valid_ccusto_restric_un then return "NOK" /*l_nok*/ .
        end /* else */.
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_valida_itens_sem_sdo_restric_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_achar_unid_orctaria_filho
** Descricao.............: pi_achar_unid_orctaria_filho
** Criado por............: fut41162
** Criado em.............: 09/09/2009 10:21:42
** Alterado por..........: fut41162
** Alterado em...........: 09/09/2009 10:41:34
*****************************************************************************/
PROCEDURE pi_achar_unid_orctaria_filho:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_orctaria_pai
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    &IF DEFINED (BF_FIN_CONSOLID_UNID_ORCTARIA) &THEN
        for each estrut_unid_orctaria no-lock
            where estrut_unid_orctaria.cod_unid_orctaria_pai = p_cod_unid_orctaria_pai:
            find b_unid_orctaria_enter no-lock
                where b_unid_orctaria_enter.cod_unid_orctaria = estrut_unid_orctaria.cod_unid_orctaria_filho no-error.
            if avail b_unid_orctaria_enter
            and b_unid_orctaria_enter.ind_espec_unid_orctaria = "Sint‚tica" /*l_sintetica*/   then 
                run pi_achar_unid_orctaria_filho (Input estrut_unid_orctaria.cod_unid_orctaria_filho) /* pi_achar_unid_orctaria_filho*/.
            else do:
                find tt_unid_orctaria no-lock
                    where tt_unid_orctaria.tta_cod_unid_orctaria = estrut_unid_orctaria.cod_unid_orctaria_filho no-error.
                if not avail tt_unid_orctaria then do:
                    create tt_unid_orctaria.
                    assign tt_unid_orctaria.tta_cod_unid_orctaria = estrut_unid_orctaria.cod_unid_orctaria_filho.
                end.
            end.
        end.
    &ENDIF
END PROCEDURE. /* pi_achar_unid_orctaria_filho */


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
                getStrTrans("Programa Mensagem", "MGL") c_prg_msg getStrTrans("nÆo encontrado.", "MGL")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/**********************  End of api_demonst_ctbl_video **********************/
