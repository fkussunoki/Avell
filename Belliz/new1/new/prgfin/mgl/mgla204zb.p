/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_prefer_demonst_ctbl
** Descricao.............: Funá‰es Preferàncias Demonstrativo
** Versao................:  1.00.00.052
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204zb.p
** Data Geracao..........: 28/02/2014 - 14:41:38
** Criado por............: src370
** Criado em.............: 22/02/2001 10:57:02
** Alterado por..........: si1768
** Alterado em...........: 22/11/2013 16:34:33
** Gerado por............: si1768
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.052":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.052[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}

{include/cdcfgfin.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_prefer_demonst_ctbl MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/


/********************* Temporary Table Definition Begin *********************/

def new global shared temp-table tt_acumul_demonst_cadastro no-undo
    field tta_cod_demonst_ctbl             as character format "x(8)" label "Demonstrativo" column-label "Demonstrativo"
    field tta_num_seq_demonst_ctbl         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field tta_cod_acumul_ctbl              as character format "x(8)" label "Acumulador Cont†bil" column-label "Acumulador"
    field tta_log_zero_acumul_ctbl         as logical format "Sim/N∆o" initial no label "Zera Acumulador" column-label "Zera Acumulador"
    index tt_id                            is primary unique
          tta_cod_demonst_ctbl             ascending
          tta_num_seq_demonst_ctbl         ascending
          tta_cod_acumul_ctbl              ascending
    .

def new global shared temp-table tt_col_demonst_ctbl no-undo like col_demonst_ctbl
    field ttv_rec_col_demonst_ctbl         as recid format ">>>>>>9"
    .

def new global shared temp-table tt_compos_demonst_cadastro no-undo like compos_demonst_ctbl
    field tta_cod_proj_financ_excec        as character format "x(20)" label "Projeto Exceá∆o" column-label "Projeto Exceá∆o"
    field tta_cod_proj_financ_inicial      as character format "x(20)" label "Projeto Financ Inic" column-label "Projeto Financ Inic"
    index tt_id                           
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    .

def new global shared temp-table tt_estrut_visualiz_ctbl_cad no-undo like estrut_visualiz_ctbl
    .

def new global shared temp-table tt_item_demonst_ctbl_cadastro no-undo like item_demonst_ctbl
    field ttv_log_ja_procesdo              as logical format "Sim/N∆o" initial no
    field ttv_rec_item_demonst_ctbl_cad    as recid format ">>>>>>9"
    index tt_id                            is primary unique
          cod_demonst_ctbl                 ascending
          num_seq_demonst_ctbl             ascending
    index tt_recid                        
          ttv_rec_item_demonst_ctbl_cad    ascending
    .

def temp-table tt_ord_col no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_cod_col_demonst_ctbl         as character format "x(2)" label "Coluna" column-label "Coluna"
    field ttv_des_tit_ctbl                 as character format "x(40)" label "T°tulo Cont†bil" column-label "T°tulo Cont†bil"
    index tt_id                            is primary unique
          ttv_num_seq                      ascending
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

def buffer btt_ord_col
    for tt_ord_col.
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_col_demonst_ctbl
    for col_demonst_ctbl.
&endif
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
def new global shared var v_cod_ccusto_exec_subst
    as character
    format "x(11)":U
    label "Subst PExec"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def new global shared var v_cod_ccusto_fim
    as Character
    format "x(11)":U
    initial "999999"
    label "CCusto Final"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def new global shared var v_cod_ccusto_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZ" /*l_ZZZZZZZZZZZ*/
    label "atÇ"
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
def var v_cod_cenar_ctbl
    as character
    format "x(8)":U
    label "Cen†rio Cont†bil"
    column-label "Cen†rio Cont†bil"
    no-undo.
def var v_cod_consolid_recur
    as character
    format "x(8)":U
    no-undo.
def new shared var v_cod_cta_ctbl_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "Conta Final"
    column-label "Final"
    no-undo.
def new shared var v_cod_cta_ctbl_ini
    as character
    format "x(20)":U
    label "Conta Inicial"
    column-label "Inicial"
    no-undo.
def new shared var v_cod_cta_prefer_excec
    as character
    format "x(20)":U
    initial "####################"
    label "Exceá∆o"
    column-label "Exceá∆o"
    no-undo.
def new shared var v_cod_cta_prefer_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    column-label "Parte Fixa"
    no-undo.
def var v_cod_demonst_ctbl
    as character
    format "x(8)":U
    label "Demonstrativo"
    column-label "Demonstrativo"
    no-undo.
def var v_cod_dwb_field
    as character
    format "x(32)":U
    no-undo.
def var v_cod_dwb_order
    as character
    format "x(32)":U
    label "Classificaá∆o"
    column-label "Classificador"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empresa
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
def var v_cod_entry_3
    as character
    format "x(10)":U
    no-undo.
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
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_exerc_ctbl
    as character
    format "9999":U
    label "Exerc°cio Cont†bil"
    column-label "Exerc°cio Cont†bil"
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
def var v_cod_idioma
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_impr_acum_zero
    as character
    format "x(8)":U
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
def new global shared var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
def var v_cod_plano_cta_ctbl_pri
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
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
    column-label "Unid Neg"
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
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_dat_entry_4
    as date
    format "99/99/9999":U
    no-undo.
def new global shared var v_dat_fim_period_ctbl
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Fim"
    column-label "Fim"
    no-undo.
def new global shared var v_dat_inic_period_ctbl
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "In°cio"
    column-label "In°cio"
    no-undo.
def var v_des_linha
    as character
    format "x(132)":U
    no-undo.
def var v_des_lin_aux
    as character
    format "x(132)":U
    no-undo.
def new global shared var v_ind_selec_demo_ctbl
    as character
    format "X(25)":U
    view-as radio-set Vertical
    radio-buttons "Demonstrativo Cont†bil", "Demonstrativo Cont†bil"/*, "Consultas de Saldo", "Consultas de Saldo"*/
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
def new global shared var v_log_alterado
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_ccusto_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Ccusto"
    column-label "Subst Ccusto"
    no-undo.
def new shared var v_log_cenar_fisc
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_consid_apurac_restdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Consid Apurac Restdo"
    column-label "Apurac Restdo"
    no-undo.
def var v_log_consid_sdo_zero
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Impr Ctas Sdo Zero"
    no-undo.
def new global shared var v_log_consolid_recur
    as logical
    format "Sim/N∆o"
    initial NO
    view-as toggle-box
    label "Consolidaá∆o Recurs"
    column-label "Consolid Recurv"
    no-undo.
def var v_log_cta_ctbl_sint_2
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Acum. N°veis Sint."
    no-undo.
def new global shared var v_log_eai_habilit
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_estab_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Estab"
    column-label "Subst Estab"
    no-undo.
def var v_log_funcao_concil_consolid
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_funcao_impr_col_sem_sdo
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_gera_dados_xml
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Dados XML"
    column-label "Gera Dados XML"
    no-undo.
def var v_log_impr_acum_zero
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Impr Acum Zerado"
    no-undo.
def var v_log_impr_col_sem_sdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Impr Coluna Sem Sdo"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_period_balan_geren
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_plano_cta_ctbl_uni
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def new global shared var v_log_unid_negoc_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Un Neg"
    column-label "Subst Un Neg"
    no-undo.
def new global shared var v_log_unid_organ_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst UO"
    column-label "Subst UO"
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
def var v_num_count
    as integer
    format ">>>>,>>9":U
    no-undo.
def new shared var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
    no-undo.
def var v_num_fator_div
    as integer
    format ">>,>>>,>>9":U
    initial 1
    label "Fator Divis∆o"
    column-label "Fator Divis∆o"
    no-undo.
def var v_num_item
    as integer
    format ">>>>,>>9":U
    initial 0
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_period_ctbl
    as integer
    format "99":U
    initial 01
    label "Per°odo Atual"
    column-label "Period"
    no-undo.
def var v_num_seq_6
    as integer
    format ">>>>,>>9":U
    initial 10
    no-undo.
def new shared var v_rec_col_demonst_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_conjto_prefer_demonst
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_demonst_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_exerc_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_idioma
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_ord_col
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_padr_col_demonst_ctbl
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
def new global shared var v_rec_prefer_demonst_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_organ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_cod_ccusto                     as character       no-undo. /*local*/
def var v_cod_entry_4                    as character       no-undo. /*local*/
def var v_cod_final                      as character       no-undo. /*local*/
def var v_cod_initial                    as character       no-undo. /*local*/
def var v_log_alter                      as logical         no-undo. /*local*/
def var v_log_col_atualiz                as logical         no-undo. /*local*/
def var v_log_mudou_ord                  as logical         no-undo. /*local*/
def var v_log_mudou_ord_col              as logical         no-undo. /*local*/
def var v_num_aux                        as integer         no-undo. /*local*/
def var v_num_col                        as integer         no-undo. /*local*/
def var v_rec_padr_col_aux               as recid           no-undo. /*local*/


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_conjto_prefer_demonst
    for conjto_prefer_demonst
    scrolling.
def query qr_ord_col
    for tt_ord_col
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_conjto_prefer_demonst_1 query qr_conjto_prefer_demonst display 
    conjto_prefer_demonst.num_conjto_param_ctbl
    width-chars 04.29
        column-label "Conjto"
    conjto_prefer_demonst.cod_cenar_ctbl
    width-chars 08.00
        column-label "Cen†rio"
    conjto_prefer_demonst.cod_finalid_econ
    width-chars 10.00
        column-label "Finalidade"
    conjto_prefer_demonst.cod_finalid_econ_apres
    width-chars 10.72
        column-label "Finalid Apresent"
    conjto_prefer_demonst.dat_cotac_indic_econ
    width-chars 10.00
        column-label "Dat Cotaá∆o"
    conjto_prefer_demonst.cod_cenar_orctario
    width-chars 11.72
        column-label "Cen†rio Oráamen"
    conjto_prefer_demonst.cod_vers_orcto_ctbl
    width-chars 10.00
        column-label "Vers∆o"
    with no-box separators single 
         size 40.00 by 05.00
         font 1
         bgcolor 15.
def browse br_ord_col query qr_ord_col display 
    tt_ord_col.ttv_des_tit_ctbl
    width-chars 40.00
        column-label "T°tulo Cont†bil"
    with no-box separators single 
         size 30.00 by 05.00
         font 1
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_003
    size 1 by 1
    edge-pixels 2.
def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_006
    size 1 by 1
    edge-pixels 2.
def rectangle rt_007
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_conjto_prefer
    label "Conjto"
    tooltip "Conjunto de Preferàncias"
    size 1 by 1.
def button bt_down2
    label "\/"
    tooltip "Desce na Estrutura"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-down2.bmp"
    image-insensitive file "image/ii-down2.bmp"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_subst
    label "Subst"
    tooltip "Substituiá‰es das Composiá‰es do Demonst"
    size 1 by 1.
def button bt_up2
    label "A"
    tooltip "Sobe na Estrutura"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-up2.bmp"
    image-insensitive file "image/ii-up2.bmp"
&endif
    size 1 by 1.
def button bt_zoom_mcs
    label "ZOOM"
    tooltip ""
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_320531
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_320985
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_320986
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_321329
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326355
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326358
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_01_demonst_ctbl_fin_novo
    rt_mold
         at row 01.21 col 02.00
    rt_002
         at row 06.79 col 42.57
    " Preferàncias " view-as text
         at row 06.49 col 44.57 bgcolor 8 
    rt_003
         at row 06.79 col 02.57
    " Ordem das Colunas " view-as text
         at row 06.49 col 04.57 bgcolor 8 
    rt_005
         at row 13.00 col 02.00 bgcolor 8 
    rt_007
         at row 01.58 col 42.57 bgcolor 8 
    rt_006
         at row 01.58 col 02.57
    " Visualizar " view-as text
         at row 01.28 col 04.57 bgcolor 8 
    rt_001
         at row 04.08 col 02.57 bgcolor 8 
    rt_cxcf
         at row 17.83 col 02.00 bgcolor 7 
    v_ind_selec_demo_ctbl
         at row 02.00 col 05.00 no-label
         view-as radio-set Vertical
         radio-buttons "Demonstrativo Cont†bil", "Demonstrativo Cont†bil" /*,"Consultas de Saldo", "Consultas de Saldo"*/
          /*l_demonstrativo_contabil*/ /*l_demonstrativo_contabil*/ /*l_consultas_de_saldo*/ /*l_consultas_de_saldo*/
         bgcolor 8 
    v_ind_selec_tip_demo
         at row 01.79 col 50.00 colon-aligned label "Consultar"
         view-as combo-box
         &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
         list-item-pairs "Saldo Conta Cont†bil","Saldo Conta Cont†bil","Saldo Conta Centros Custo","Saldo Conta Centros Custo","Saldo Centro Custo Contas","Saldo Centro Custo Contas"
         &else
         list-items "Saldo Conta Cont†bil","Saldo Conta Centros Custo","Saldo Centro Custo Contas"
         &endif
          /*l_saldo_conta_contabil_demo*/ /*l_saldo_conta_centros_custo*/ /*l_saldo_centro_custo_contas*/
         inner-lines 5
         bgcolor 15 font 2
    v_ind_tip_sdo_ctbl_demo
         at row 02.79 col 50.00 colon-aligned label "Tipo"
         view-as combo-box
         &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
         list-item-pairs "Simples","Simples","Compostos","Compostos"
         &else
         list-items "Simples","Compostos"
         &endif
          /*l_simples*/ /*l_compostos*/
         inner-lines 5
         bgcolor 15 font 2
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ
         at row 02.79 col 74.00 colon-aligned label "UO"
         help "C¢digo Unidade Organizacional"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326358
         at row 02.79 col 80.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ
         at row 02.79 col 74.00 colon-aligned label "UO"
         help "C¢digo Unidade Organizacional"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326358
         at row 02.79 col 82.14
&ENDIF
    v_cod_plano_cta_ctbl
         at row 04.29 col 25.57 colon-aligned label "Plano Contas"
         help "C¢digo do Plano de Contas"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326355
         at row 04.29 col 36.71
    v_cod_plano_ccusto
         at row 05.29 col 25.57 colon-aligned label "Plano CCusto"
         help "C¢digo do Plano de Centros de Custos"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoom_mcs
         at row 05.29 col 36.72 font ?
    prefer_demonst_ctbl.cod_demonst_ctbl
         at row 04.29 col 25.57 colon-aligned label "Demonstrativo"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_320985
         at row 04.29 col 36.71
    prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
         at row 05.29 col 25.57 colon-aligned label "Padr∆o Colunas"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_320986
         at row 05.29 col 36.71
    br_ord_col
         at row 07.29 col 04.00
    bt_up2
         at row 08.00 col 36.00 font ?
         help "Sobe na Estrutura"
    bt_down2
         at row 10.00 col 36.00 font ?
         help "Desce na Estrutura"
    br_conjto_prefer_demonst_1
         at row 07.29 col 45.00
    v_cod_exerc_ctbl
         at row 13.29 col 16.00 colon-aligned label "Exerc°cio Cont†bil"
         help "C¢digo Ano Exerc°cio Cont†bil"
         view-as fill-in
         size-chars 5.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_321329
         at row 13.29 col 23.14
    v_num_period_ctbl
         at row 14.29 col 16.00 colon-aligned label "Per°odo Atual"
         help "Per°odo Cont†bil"
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_num_fator_div
         at row 15.29 col 16.00 colon-aligned label "Fator Divis∆o"
         help "Fator de Divis∆o dos Valores"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    idioma.cod_idioma
         at row 16.29 col 16.00 colon-aligned label "Idioma"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_320531
         at row 16.29 col 27.14
    v_log_consid_apurac_restdo
         at row 13.29 col 35.00 label "Consid Apurac Restdo"
         help "Considera apuraá∆o de resultados"
         view-as toggle-box
    v_log_cta_ctbl_sint_2
         at row 14.29 col 35.00 label "Acum. N°veis SintÇticos"
         help "Acumula Saldos em N°veis SintÇticos"
         view-as toggle-box
    v_log_gera_dados_xml
         at row 15.29 col 35.00 label "Gera Dados XML"
         help "Gera Dados XML"
         view-as toggle-box
    v_log_consid_sdo_zero
         at row 13.29 col 57.00 label "Impr Ctas Sem Sdo"
         view-as toggle-box
    v_log_impr_acum_zero
         at row 14.29 col 57.00 label "Impr Acum Zerado"
         help "Imprime Acumulador Zerado"
         view-as toggle-box
    v_log_consolid_recur
         at row 15.29 col 57.00 label "Consolidaá∆o Recursiva"
         help "Busca valores consolidados em UO de n°vel inf"
         view-as toggle-box
    v_log_impr_col_sem_sdo
         at row 16.29 col 57.00 label "Impr Colunas Sem Sdo"
         view-as toggle-box
    bt_conjto_prefer
         at row 13.29 col 77.00 font ?
         help "Conjunto de Preferàncias"
    bt_subst
         at row 14.50 col 77.00 font ?
         help "Substituiá‰es das Composiá‰es do Demonst"
    bt_ok
         at row 18.04 col 03.00 font ?
         help "OK"
    bt_can
         at row 18.04 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 18.04 col 77.57 font ?
         help "Ajuda"
    plano_cta_ctbl.des_tit_ctbl
         at row 04.29 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    plano_ccusto.des_tit_ctbl
         at row 05.29 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    demonst_ctbl.des_tit_ctbl
         at row 04.29 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    padr_col_demonst_ctbl.des_tit_ctbl
         at row 05.29 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 19.67 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Preferàncias Demonstrativo V°deo".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 10.00
           bt_can:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 01.00
           bt_conjto_prefer:width-chars  in frame f_dlg_01_demonst_ctbl_fin_novo = 10.00
           bt_conjto_prefer:height-chars in frame f_dlg_01_demonst_ctbl_fin_novo = 01.00
           bt_down2:width-chars          in frame f_dlg_01_demonst_ctbl_fin_novo = 04.00
           bt_down2:height-chars         in frame f_dlg_01_demonst_ctbl_fin_novo = 01.13
           bt_hel2:width-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 10.00
           bt_hel2:height-chars          in frame f_dlg_01_demonst_ctbl_fin_novo = 01.00
           bt_ok:width-chars             in frame f_dlg_01_demonst_ctbl_fin_novo = 10.00
           bt_ok:height-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 01.00
           bt_subst:width-chars          in frame f_dlg_01_demonst_ctbl_fin_novo = 10.00
           bt_subst:height-chars         in frame f_dlg_01_demonst_ctbl_fin_novo = 01.00
           bt_up2:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 04.00
           bt_up2:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 01.08
           bt_zoom_mcs:width-chars       in frame f_dlg_01_demonst_ctbl_fin_novo = 04.00
           bt_zoom_mcs:height-chars      in frame f_dlg_01_demonst_ctbl_fin_novo = 00.88
           rt_001:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 85.14
           rt_001:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 02.38
           rt_002:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 45.14
           rt_002:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 05.96
           rt_003:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 38.86
           rt_003:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 05.96
           rt_005:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 85.14
           rt_005:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 04.29
           rt_006:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 38.86
           rt_006:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 02.42
           rt_007:width-chars            in frame f_dlg_01_demonst_ctbl_fin_novo = 45.14
           rt_007:height-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 02.42
           rt_cxcf:width-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 86.57
           rt_cxcf:height-chars          in frame f_dlg_01_demonst_ctbl_fin_novo = 01.42
           rt_mold:width-chars           in frame f_dlg_01_demonst_ctbl_fin_novo = 86.57
           rt_mold:height-chars          in frame f_dlg_01_demonst_ctbl_fin_novo = 16.25.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_conjto_prefer_demonst_1:ALLOW-COLUMN-SEARCHING in frame f_dlg_01_demonst_ctbl_fin_novo = no
       br_conjto_prefer_demonst_1:COLUMN-MOVABLE in frame f_dlg_01_demonst_ctbl_fin_novo = no.
end.
&endif
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_ord_col:ALLOW-COLUMN-SEARCHING in frame f_dlg_01_demonst_ctbl_fin_novo = no
       br_ord_col:COLUMN-MOVABLE in frame f_dlg_01_demonst_ctbl_fin_novo = no.
end.
&endif
    /* set private-data for the help system */
    assign v_ind_selec_demo_ctbl:private-data                         in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_ind_selec_tip_demo:private-data                          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_ind_tip_sdo_ctbl_demo:private-data                       in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_zoo_326358:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           bt_zoo_326358:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           v_cod_unid_organ:private-data                              in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000024181":U
           bt_zoo_326355:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           v_cod_plano_cta_ctbl:private-data                          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000019704":U
           v_cod_plano_ccusto:private-data                            in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000023489":U
           bt_zoom_mcs:private-data                                   in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_zoo_320985:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           prefer_demonst_ctbl.cod_demonst_ctbl:private-data          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000019414":U
           bt_zoo_320986:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:private-data in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           br_ord_col:private-data                                    in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_up2:private-data                                        in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009439":U
           bt_down2:private-data                                      in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000008747":U
           br_conjto_prefer_demonst_1:private-data                    in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_zoo_321329:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           v_cod_exerc_ctbl:private-data                              in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000023759":U
           v_num_period_ctbl:private-data                             in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000024187":U
           v_num_fator_div:private-data                               in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000019486":U
           bt_zoo_320531:private-data                                 in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000009431":U
           idioma.cod_idioma:private-data                             in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000007141":U
           v_log_consid_apurac_restdo:private-data                    in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000023726":U
           v_log_cta_ctbl_sint_2:private-data                         in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_log_gera_dados_xml:private-data                          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_log_consid_sdo_zero:private-data                         in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000019487":U
           v_log_impr_acum_zero:private-data                          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_log_consolid_recur:private-data                          in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           v_log_impr_col_sem_sdo:private-data                        in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_conjto_prefer:private-data                              in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_subst:private-data                                      in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           bt_ok:private-data                                         in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000010721":U
           bt_can:private-data                                        in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000011050":U
           bt_hel2:private-data                                       in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000011326":U
           plano_cta_ctbl.des_tit_ctbl:private-data                   in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000025187":U
           plano_ccusto.des_tit_ctbl:private-data                     in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000025190":U
           demonst_ctbl.des_tit_ctbl:private-data                     in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           padr_col_demonst_ctbl.des_tit_ctbl:private-data            in frame f_dlg_01_demonst_ctbl_fin_novo = "HLP=000000000":U
           frame f_dlg_01_demonst_ctbl_fin_novo:private-data                                                  = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_326358:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_326358:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_326355:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_320985:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_320986:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_321329:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes
           bt_zoo_320531:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo = yes.
    /* move buttons to top */
    bt_zoo_326358:move-to-top().
    bt_zoo_326358:move-to-top().
    bt_zoo_326355:move-to-top().
    bt_zoo_320985:move-to-top().
    bt_zoo_320986:move-to-top().
    bt_zoo_321329:move-to-top().
    bt_zoo_320531:move-to-top().



{include/i_fclfrm.i f_dlg_01_demonst_ctbl_fin_novo }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON MOUSE-SELECT-DBLCLICK OF br_conjto_prefer_demonst_1 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    apply "choose" to bt_conjto_prefer in frame f_dlg_01_demonst_ctbl_fin_novo.
END. /* ON MOUSE-SELECT-DBLCLICK OF br_conjto_prefer_demonst_1 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON DEFAULT-ACTION OF br_ord_col IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    FIND col_demonst_ctbl NO-LOCK
        WHERE col_demonst_ctbl.cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl
        AND   col_demonst_ctbl.cod_col_demonst_ctbl      = tt_ord_col.ttv_cod_col_demonst_ctbl NO-ERROR.
    IF AVAIL col_demonst_ctbl THEN DO:
        ASSIGN v_rec_col_demonst_ctbl = RECID(col_demonst_ctbl).
        run prgfin/mgl/mgl007ja.p /* prg_det_col_demonst_ctbl*/.       
    END.

END. /* ON DEFAULT-ACTION OF br_ord_col IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_conjto_prefer IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    if not avail conjto_prefer_demonst then do:
      find first conjto_prefer_demonst no-lock
           where conjto_prefer_demonst.cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl
             and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
             and conjto_prefer_demonst.cod_usuario = prefer_demonst_ctbl.cod_usuario no-error.
    end.

    if  avail conjto_prefer_demonst
    then do:
       assign v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst)
              input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
              input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto
              input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo
              input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo
              input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ.
       if  input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl = "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/ 
       then do:
           if  search("prgfin/mgl/MGLA204zd.r") = ? and search("prgfin/mgl/MGLA204zd.p") = ? then do:
               if  v_cod_dwb_user begins 'es_' then
                   return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/MGLA204zd.p".
               else do:
                   message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/MGLA204zd.p"
                          view-as alert-box error buttons ok.
                   return.
               end.
           end.
           else
               run prgfin/mgl/MGLA204zd.p /*prg_fnc_conjto_prefer_demonst_505*/.
       end /* if */.
       else do:
           if  search("prgfin/mgl/MGLA204ze.r") = ? and search("prgfin/mgl/MGLA204ze.p") = ? then do:
               if  v_cod_dwb_user begins 'es_' then
                   return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/MGLA204ze.p".
               else do:
                   message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/MGLA204ze.p"
                          view-as alert-box error buttons ok.
                   return.
               end.
           end.
           else
               run prgfin/mgl/MGLA204ze.p /*prg_fnc_conjto_prefer_demonst_505_cons*/.
       end /* else */.
       open query qr_conjto_prefer_demonst for
          each conjto_prefer_demonst no-lock
          where conjto_prefer_demonst.cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl
            and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
            and conjto_prefer_demonst.cod_usuario = prefer_demonst_ctbl.cod_usuario
          .
       reposition qr_conjto_prefer_demonst
          to recid v_rec_conjto_prefer_demonst no-error.
    end /* if */.
END. /* ON CHOOSE OF bt_conjto_prefer IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_down2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    /************************* Variable Definition Begin ************************/

    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    FIND btt_ord_col
        WHERE btt_ord_col.ttv_num_seq = tt_ord_col.ttv_num_seq + 10 NO-ERROR.
    IF AVAIL btt_ord_col THEN DO:
        ASSIGN v_num_aux   = tt_ord_col.ttv_num_seq 
               v_num_aux_2 = btt_ord_col.ttv_num_seq
               tt_ord_col.ttv_num_seq  = 1
               btt_ord_col.ttv_num_seq = v_num_aux
               tt_ord_col.ttv_num_seq  = v_num_aux_2.
    END.
    ASSIGN v_rec_ord_col = RECID(tt_ord_col).
    OPEN QUERY qr_ord_col
        FOR EACH tt_ord_col.
    REPOSITION qr_ord_col TO RECID v_rec_ord_col.
END. /* ON CHOOSE OF bt_down2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_subst IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        /* --- Demonstrativo Cont†bil ---*/
        assign v_wgh_focus = prefer_demonst_ctbl.cod_demonst_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
        find demonst_ctbl no-lock
            where demonst_ctbl.cod_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl no-error.
        if  not available demonst_ctbl
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Demonstrativo Cont†bil", "Demonstrativos Cont†beis")) /*msg_1284*/.
            return no-apply.
        end.
    end.
    if avail prefer_demonst_ctbl then do:
        assign prefer_demonst_ctbl.dat_ult_atualiz = today.
        run pi_sec_to_formatted_time (Input time,
                                      output prefer_demonst_ctbl.hra_ult_atualiz) /*pi_sec_to_formatted_time*/.
    end.
    if  search("prgfin/mgl/MGLA204zf.r") = ? and search("prgfin/mgl/MGLA204zf.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/MGLA204zf.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/MGLA204zf.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/mgl/MGLA204zf.p /*prg_fnc_compos_demonst_subst_505*/.
END. /* ON CHOOSE OF bt_subst IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_up2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    /************************* Variable Definition Begin ************************/

    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    FIND btt_ord_col
        WHERE btt_ord_col.ttv_num_seq = tt_ord_col.ttv_num_seq - 10 NO-ERROR.
    IF AVAIL btt_ord_col THEN DO:
        ASSIGN v_num_aux   = tt_ord_col.ttv_num_seq 
               v_num_aux_2 = btt_ord_col.ttv_num_seq
               tt_ord_col.ttv_num_seq  = 1
               btt_ord_col.ttv_num_seq = v_num_aux
               tt_ord_col.ttv_num_seq  = v_num_aux_2.
    END.
    ASSIGN v_rec_ord_col = RECID(tt_ord_col).
    OPEN QUERY qr_ord_col
        FOR EACH tt_ord_col.
    REPOSITION qr_ord_col TO RECID v_rec_ord_col.
END. /* ON CHOOSE OF bt_up2 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON CHOOSE OF bt_zoom_mcs IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    assign v_cod_empresa = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ.

    if  search("prgint/utb/utb083ka.r") = ? and search("prgint/utb/utb083ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb083ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb083ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb083ka.p /*prg_sea_plano_ccusto*/.
    if  v_rec_plano_ccusto <> ? then do:
        find plano_ccusto where recid(plano_ccusto) = v_rec_plano_ccusto no-lock no-error.
        assign v_cod_plano_ccusto:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(plano_ccusto.cod_plano_ccusto).

        display plano_ccusto.des_tit_ctbl
                with frame f_dlg_01_demonst_ctbl_fin_novo.

        apply "entry" to v_cod_plano_ccusto in frame f_dlg_01_demonst_ctbl_fin_novo.
    end.


END. /* ON CHOOSE OF bt_zoom_mcs IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON LEAVE OF v_cod_plano_ccusto IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    find plano_ccusto no-lock
        where plano_ccusto.cod_empresa      = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
        and   plano_ccusto.cod_plano_ccusto = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto
        no-error.
    display plano_ccusto.des_tit_ctbl when avail plano_ccusto
            "" when not avail plano_ccusto @ plano_ccusto.des_tit_ctbl
            with frame f_dlg_01_demonst_ctbl_fin_novo.

END. /* ON LEAVE OF v_cod_plano_ccusto IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON LEAVE OF v_cod_plano_cta_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    find plano_cta_ctbl no-lock
        where plano_cta_ctbl.cod_plano_cta_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
        no-error.
    display plano_cta_ctbl.des_tit_ctbl when avail plano_cta_ctbl
            "" when not avail plano_cta_ctbl @ plano_cta_ctbl.des_tit_ctbl
            with frame f_dlg_01_demonst_ctbl_fin_novo.

END. /* ON LEAVE OF v_cod_plano_cta_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON LEAVE OF v_cod_unid_organ IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    find emsuni.empresa no-lock
         where empresa.cod_empresa = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ no-error.


    IF v_cod_plano_cta_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "" THEN DO:
        run pi_retornar_plano_cta_ctbl_prim (Input input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ,
                                             Input today,
                                             output v_cod_plano_cta_ctbl_pri,
                                             output v_log_plano_cta_ctbl_uni) /*pi_retornar_plano_cta_ctbl_prim*/.              
        if  v_log_plano_cta_ctbl_uni
        then do:
            assign v_cod_plano_cta_ctbl = v_cod_plano_cta_ctbl_pri
                   v_cod_plano_cta_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = v_cod_plano_cta_ctbl_pri.
        end.
    END.                      
    apply "leave" to v_cod_plano_cta_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.    

END. /* ON LEAVE OF v_cod_unid_organ IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON VALUE-CHANGED OF v_ind_selec_demo_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    if  v_ind_selec_demo_ctbl <> v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo
    and v_ind_selec_demo_ctbl <> '' then do:
        assign v_log_alterado = yes.
    end.
    else 
        assign v_log_alterado = no.

    ASSIGN INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl.

    if v_ind_selec_demo_ctbl <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        disable v_ind_selec_tip_demo
                v_ind_tip_sdo_ctbl_demo
                v_cod_unid_organ
                bt_zoo_326358
                with frame f_dlg_01_demonst_ctbl_fin_novo.    

        assign v_cod_plano_cta_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                          = no
               plano_cta_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                   = no
               v_cod_plano_ccusto:visible in frame f_dlg_01_demonst_ctbl_fin_novo                            = no
               plano_ccusto.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                     = no
               prefer_demonst_ctbl.cod_demonst_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo          = yes
               demonst_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                     = yes
               prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo = yes
               padr_col_demonst_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo            = yes
               bt_zoo_320985:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = yes
               bt_zoo_320986:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = yes
               bt_zoo_326355:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = no
               bt_zoom_mcs:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                   = no
               v_ind_selec_tip_demo:SCREEN-VALUE    in frame f_dlg_01_demonst_ctbl_fin_novo                  = ""
               v_ind_tip_sdo_ctbl_demo:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo                  = ""
               v_cod_unid_organ:SCREEN-VALUE        in frame f_dlg_01_demonst_ctbl_fin_novo                  = ""
               v_num_period_ctbl:FORMAT IN FRAME f_dlg_01_demonst_ctbl_fin_novo                              = '>9'.

       enable bt_down2
              bt_subst
              bt_up2
              prefer_demonst_ctbl.cod_demonst_ctbl
              bt_zoo_320985
              prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
              bt_zoo_320986
              v_cod_exerc_ctbl
              bt_zoo_321329
              v_num_fator_div
              v_num_period_ctbl
              v_log_impr_acum_zero
              with frame f_dlg_01_demonst_ctbl_fin_novo.

       if  v_log_funcao_concil_consolid
       then do:
           assign v_log_consolid_recur:checked in frame f_dlg_01_demonst_ctbl_fin_novo = NO.
           enable v_log_consolid_recur
                  with frame f_dlg_01_demonst_ctbl_fin_novo.
       end.

       /* Posiciona na £ltima preferància do usu†rio*/
       FOR EACH b_prefer_demonst_ctbl NO-LOCK
            where b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
            AND   b_prefer_demonst_ctbl.cod_demonst_ctbl          <> ""
            AND   b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl <> ""

            BREAK BY b_prefer_demonst_ctbl.dat_ult_atualiz
                  BY b_prefer_demonst_ctbl.hra_ult_atualiz:

           IF  LAST-OF(b_prefer_demonst_ctbl.dat_ult_atualiz)
           AND LAST-OF(b_prefer_demonst_ctbl.hra_ult_atualiz) THEN
               FIND FIRST prefer_demonst_ctbl exclusive-lock
                   WHERE prefer_demonst_ctbl.cod_usuario               = b_prefer_demonst_ctbl.cod_usuario
                     AND prefer_demonst_ctbl.cod_demonst_ctbl          = b_prefer_demonst_ctbl.cod_demonst_ctbl
                     AND prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
               NO-ERROR.
       END.
       if  avail prefer_demonst_ctbl then do:
           if prefer_demonst_ctbl.cod_idioma = "" then
               assign prefer_demonst_ctbl.cod_idioma = v_cod_idiom_usuar.  
           run pi_inicializa_prefer_demonst_ctbl /*pi_inicializa_prefer_demonst_ctbl*/.        
       end.
       else
           ASSIGN v_num_fator_div:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = "1" /*l_1*/ 
                  idioma.cod_idioma :SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = v_cod_idiom_usuar.

       if v_log_funcao_impr_col_sem_sdo = yes then
           display v_log_impr_col_sem_sdo with frame f_dlg_01_demonst_ctbl_fin_novo.
       else    
           assign v_log_impr_col_sem_sdo:visible in frame f_dlg_01_demonst_ctbl_fin_novo = no.
       if  not v_log_period_balan_geren then
           assign v_log_gera_dados_xml:visible in frame f_dlg_01_demonst_ctbl_fin_novo =  no.   
       else
           display v_log_gera_dados_xml with frame f_dlg_01_demonst_ctbl_fin_novo.     
    end.
    else do:
       /* Posiciona na £ltima preferància do usu†rio*/
       FOR EACH b_prefer_demonst_ctbl NO-LOCK
            where b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
            AND   b_prefer_demonst_ctbl.cod_demonst_ctbl          = ""
            AND   b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = ""
            BREAK BY b_prefer_demonst_ctbl.dat_ult_atualiz
                  BY b_prefer_demonst_ctbl.hra_ult_atualiz:

           IF  LAST-OF(b_prefer_demonst_ctbl.dat_ult_atualiz)
           AND LAST-OF(b_prefer_demonst_ctbl.hra_ult_atualiz) THEN
               FIND FIRST prefer_demonst_ctbl exclusive-lock
                   WHERE prefer_demonst_ctbl.cod_usuario               = b_prefer_demonst_ctbl.cod_usuario
                     AND prefer_demonst_ctbl.cod_demonst_ctbl          = b_prefer_demonst_ctbl.cod_demonst_ctbl
                     AND prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
               NO-ERROR.
       END.

       if  avail prefer_demonst_ctbl then do:
           if prefer_demonst_ctbl.cod_idioma = "" then
               assign prefer_demonst_ctbl.cod_idioma = v_cod_idiom_usuar.
           run pi_inicializa_prefer_demonst_ctbl /*pi_inicializa_prefer_demonst_ctbl*/.        
       end.   
       else
           ASSIGN idioma.cod_idioma :SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = v_cod_idiom_usuar.

        disable bt_down2
                bt_subst
                bt_up2
                bt_zoo_320985
                prefer_demonst_ctbl.cod_demonst_ctbl
                bt_zoo_320986
                prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                v_cod_exerc_ctbl
                v_num_fator_div
                v_num_period_ctbl
                v_log_impr_acum_zero
                bt_zoo_321329
                with frame f_dlg_01_demonst_ctbl_fin_novo.
        enable v_ind_selec_tip_demo
               v_ind_tip_sdo_ctbl_demo
               bt_zoo_326355
               v_cod_plano_cta_ctbl
               bt_zoom_mcs
               v_cod_plano_ccusto
               v_cod_unid_organ
               bt_zoo_326358
               with frame f_dlg_01_demonst_ctbl_fin_novo.

        if  v_log_funcao_concil_consolid
        then do:
           assign v_log_consolid_recur:checked in frame f_dlg_01_demonst_ctbl_fin_novo = NO.
           disable v_log_consolid_recur
                   with frame f_dlg_01_demonst_ctbl_fin_novo.
        end.

        assign v_log_gera_dados_xml = no.
        assign v_log_gera_dados_xml:checked in frame f_dlg_01_demonst_ctbl_fin_novo = no. 
        assign v_log_gera_dados_xml:visible in frame f_dlg_01_demonst_ctbl_fin_novo = no.   

       if v_log_funcao_impr_col_sem_sdo = yes then
           display v_log_impr_col_sem_sdo with frame f_dlg_01_demonst_ctbl_fin_novo.
       else    
           assign v_log_impr_col_sem_sdo:visible in frame f_dlg_01_demonst_ctbl_fin_novo = no.

        if avail prefer_demonst_ctbl then 
           assign prefer_demonst_ctbl.cod_demonst_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = " "
                  prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = " "
                  v_cod_unid_organ:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = v_cod_empres_usuar
                  v_log_alter = YES.

        apply "leave" to prefer_demonst_ctbl.cod_demonst_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.

        if avail prefer_demonst_ctbl then
           assign v_cod_plano_cta_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                          = yes
                  plano_cta_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                   = yes
                  v_cod_plano_ccusto:visible in frame f_dlg_01_demonst_ctbl_fin_novo                            = yes
                  plano_ccusto.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                     = yes
                  prefer_demonst_ctbl.cod_demonst_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo          = no
                  demonst_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo                     = no
                  prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo = no
                  padr_col_demonst_ctbl.des_tit_ctbl:visible in frame f_dlg_01_demonst_ctbl_fin_novo            = no
                  v_cod_unid_organ:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo                         = v_cod_empres_usuar
                  bt_zoo_320985:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = no
                  bt_zoo_320986:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = no
                  bt_zoo_326355:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                 = yes
                  bt_zoom_mcs:visible in frame f_dlg_01_demonst_ctbl_fin_novo                                   = yes.

        &if '{&emsfin_version}' = '5.05' &then
            assign v_ind_selec_tip_demo:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = ENTRY(2,prefer_demonst_ctbl.cod_livre_1,CHR(10))
                   v_cod_unid_organ:SCREEN-VALUE     in frame f_dlg_01_demonst_ctbl_fin_novo = ENTRY(4,prefer_demonst_ctbl.cod_livre_1,CHR(10))
                   v_cod_plano_cta_ctbl:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = ENTRY(5,prefer_demonst_ctbl.cod_livre_1,CHR(10))
                   v_cod_plano_ccusto:SCREEN-VALUE   in frame f_dlg_01_demonst_ctbl_fin_novo = ENTRY(6,prefer_demonst_ctbl.cod_livre_1,CHR(10)) no-error.
            IF  not avail prefer_demonst_ctbl
            or (prefer_demonst_ctbl.cod_livre_1 <> ''
            and ENTRY(2,prefer_demonst_ctbl.cod_livre_1,CHR(10)) = '') THEN 
                assign v_ind_selec_tip_demo:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = "Saldo Conta Cont†bil" /*l_saldo_conta_contabil_demo*/ .
        &else
            assign v_ind_selec_tip_demo:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = prefer_demonst_ctbl.ind_selec_tip_demo
                   v_cod_unid_organ:SCREEN-VALUE     in frame f_dlg_01_demonst_ctbl_fin_novo = prefer_demonst_ctbl.cod_unid_organ_subst
                   v_cod_plano_cta_ctbl:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = prefer_demonst_ctbl.cod_plano_cta_ctbl
                   v_cod_plano_ccusto:SCREEN-VALUE   in frame f_dlg_01_demonst_ctbl_fin_novo = prefer_demonst_ctbl.cod_plano_ccusto.
        &endif

        apply "leave" to v_cod_unid_organ in frame f_dlg_01_demonst_ctbl_fin_novo.
        apply "value-changed" to v_ind_selec_tip_demo in frame f_dlg_01_demonst_ctbl_fin_novo.
    end.
END. /* ON VALUE-CHANGED OF v_ind_selec_demo_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON VALUE-CHANGED OF v_ind_selec_tip_demo IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    /************************* Variable Definition Begin ************************/

    def var v_ind_selec_tip_demo_aux         as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    case v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo:
        when "Saldo Conta Cont†bil" /*l_saldo_conta_contabil_demo*/  then do:
            assign v_ind_tip_sdo_ctbl_demo:{&UI_LIST_ITEM_PAIRS}  in frame f_dlg_01_demonst_ctbl_fin_novo = getLstItTrans(yes, "Sdo/Movimento" /*l_sdomovimen*/  + ',' +
                                                                            "Comparativo" /*l_comparativo*/  + ',' +
                                                                            "Oráamentos" /*l_orcamentos*/ , "MGL")
                   v_ind_tip_sdo_ctbl_demo:inner-lines in frame f_dlg_01_demonst_ctbl_fin_novo = 3
                   v_cod_plano_ccusto:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = "".
            apply "leave" to v_cod_plano_ccusto IN FRAME f_dlg_01_demonst_ctbl_fin_novo.
            disable v_cod_plano_ccusto
                    bt_zoom_mcs
                    with frame f_dlg_01_demonst_ctbl_fin_novo.    
        end.
        when "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/  then do:
            assign v_ind_tip_sdo_ctbl_demo:{&UI_LIST_ITEM_PAIRS}  in frame f_dlg_01_demonst_ctbl_fin_novo = getLstItTrans(yes, "Sdo/Movimento" /*l_sdomovimen*/  + ',' +
                                                                            "Comparativo" /*l_comparativo*/  + ',' +
                                                                            "Oráamentos" /*l_orcamentos*/ , "MGL")
                   v_ind_tip_sdo_ctbl_demo:inner-lines in frame f_dlg_01_demonst_ctbl_fin_novo = 3.

            if  v_cod_plano_ccusto:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = "" /*l_null*/  then
                assign v_cod_plano_ccusto:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = v_cod_plano_ccusto_corren.

            apply "leave" to v_cod_plano_ccusto IN FRAME f_dlg_01_demonst_ctbl_fin_novo.
            enable v_cod_plano_ccusto
                   bt_zoom_mcs
                   with frame f_dlg_01_demonst_ctbl_fin_novo.    
        end.    
        when "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/  then do:
            assign v_ind_tip_sdo_ctbl_demo:{&UI_LIST_ITEM_PAIRS}  in frame f_dlg_01_demonst_ctbl_fin_novo = getLstItTrans(yes, "Sdo/Movimento" /*l_sdomovimen*/  + ',' +
                                                                            "Comparativo" /*l_comparativo*/  + ',' +
                                                                            "Oráamentos" /*l_orcamentos*/ , "MGL")
                   v_ind_tip_sdo_ctbl_demo:inner-lines in frame f_dlg_01_demonst_ctbl_fin_novo = 3.

            if  v_cod_plano_ccusto:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = "" /*l_null*/  then
                assign v_cod_plano_ccusto:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = v_cod_plano_ccusto_corren.

            apply "leave" to v_cod_plano_ccusto IN FRAME f_dlg_01_demonst_ctbl_fin_novo.
            enable v_cod_plano_ccusto
                   bt_zoom_mcs
                   with frame f_dlg_01_demonst_ctbl_fin_novo.    
        end.    
    end.
    assign v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = entry(1, getLstItUndoTrans(yes, v_ind_tip_sdo_ctbl_demo:{&UI_LIST_ITEM_PAIRS} in frame f_dlg_01_demonst_ctbl_fin_novo) ,',').

    for each tt_ord_col.
        delete tt_ord_col.
    end.

    /* * Recupera parÉmetro salvo neste campo caso se altere a opá∆o de visualizaá∆o **/
    IF  v_log_alter THEN do:
        ASSIGN v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = &if '{&emsfin_version}' = '5.05' &then
                                                                             ENTRY(3,prefer_demonst_ctbl.cod_livre_1,CHR(10))
                                                                         &else
                                                                             prefer_demonst_ctbl.ind_tip_sdo_ctbl_demo
                                                                         &ENDIF
               no-error.
        if  error-status:error then do:
            assign v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo   = "Saldo Conta Cont†bil" /*l_saldo_conta_contabil_demo*/ 
                   v_ind_tip_sdo_ctbl_demo:{&UI_LIST_ITEM_PAIRS}  in frame f_dlg_01_demonst_ctbl_fin_novo = getLstItTrans(yes, "Sdo/Movimento" /*l_sdomovimen*/  + ',' +
                                                                             "Comparativo" /*l_comparativo*/  + ',' +
                                                                             "Oráamentos" /*l_orcamentos*/ , "MGL")
                   v_ind_tip_sdo_ctbl_demo:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo = "Sdo/Movimento" /*l_sdomovimen*/ .
        end.
        assign v_log_alter = NO.
    end.

    &if '{&emsfin_version}' = '5.05' &then
        if AVAIL prefer_demonst_ctbl AND num-entries(prefer_demonst_ctbl.cod_livre_1,chr(10)) > 1 then 
           IF v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> entry(2,prefer_demonst_ctbl.cod_livre_1,chr(10)) THEN
              ASSIGN v_log_alterado = YES.
    &else
        IF v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> prefer_demonst_ctbl.ind_selec_tip_demo THEN
           ASSIGN v_log_alterado = YES.
    &endif


    run pi_rpt_open_item_padr_col_demonst_ctbl /*pi_rpt_open_item_padr_col_demonst_ctbl*/.
    run pi_abre_conjto_prefer_padr /*pi_abre_conjto_prefer_padr*/.

    if avail prefer_demonst_ctbl then do:
       &if '{&emsfin_version}' = '5.05' &then
           assign v_ind_selec_tip_demo_aux = entry(2,prefer_demonst_ctbl.cod_livre_1,chr(10)) no-error.
       &else
           assign v_ind_selec_tip_demo_aux = prefer_demonst_ctbl.ind_selec_tip_demo. 
       &endif
    end.   

    /* Se Mudou a opá∆o de Consulta Refaz os iniciais da Conta e Centro de Custo */
    if  v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> v_ind_selec_tip_demo_aux then do:
        find conjto_prefer_demonst exclusive-lock
           where conjto_prefer_demonst.cod_usuario               = v_cod_usuar_corren
             and conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
             and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
             and conjto_prefer_demonst.num_conjto_param_ctbl     = 1 no-error.
        if  avail conjto_prefer_demonst then do:

            /* Begin_Include: i_abre_conjto_prefer_padr_2 */
            find plano_cta_ctbl 
                where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-lock no-error.
            if  avail plano_cta_ctbl
            then do:
                run pi_retornar_valores_iniciais_prefer (Input plano_cta_ctbl.cod_format_cta_ctbl,
                                                         Input "Cta Ctbl" /*l_cta_ctbl*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                assign conjto_prefer_demonst.cod_cta_ctbl_inic         = v_cod_initial
                       conjto_prefer_demonst.cod_cta_ctbl_fim          = v_cod_final
                       conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl))
                       conjto_prefer_demonst.cod_cta_ctbl_prefer_excec = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl)).
            end.

            &if '{&emsfin_version}' > '5.05' &then

            find last param_geral_ems no-lock no-error.
            if  avail param_geral_ems
            then do:
                run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                         Input "Projeto" /*l_projeto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.

                assign conjto_prefer_demonst.cod_proj_financ_inicial = v_cod_initial
                       conjto_prefer_demonst.cod_proj_financ_fim     = v_cod_final
                       conjto_prefer_demonst.cod_proj_financ_pfixa = fill("#",length(param_geral_ems.cod_format_proj_financ))
                       conjto_prefer_demonst.cod_proj_financ_excec = fill("#",length(param_geral_ems.cod_format_proj_financ)).
            end.
            find first compos_demonst_ctbl no-lock
                where  compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                  and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl
            or v_cod_plano_ccusto:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo <> ""
            then do:
                if  avail compos_demonst_ctbl then
                   find first plano_ccusto no-lock
                        where plano_ccusto.cod_empresa      = v_cod_empres_usuar
                        and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                else
                   find first plano_ccusto no-lock
                        where plano_ccusto.cod_empresa      = v_cod_empres_usuar
                        and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo no-error.    
                if  avail plano_ccusto
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                             Input "CCusto" /*l_ccusto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign conjto_prefer_demonst.cod_ccusto_inic  = v_cod_initial
                           conjto_prefer_demonst.cod_ccusto_fim   = v_cod_final
                           conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                           conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
                end.
            end.
            &endif

            /* End_Include: i_abre_conjto_prefer_padr_2 */

            find first plano_ccusto no-lock
                where plano_ccusto.cod_empresa      = v_cod_empres_usuar
                and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo no-error.
            if  avail plano_ccusto
            then do:
                run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                         Input "CCusto" /*l_ccusto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
            end.
            &if '{&emsfin_version}' <= '5.05' &then
                find tab_livre_emsfin
                    where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                    and   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                    and   tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                    and   tab_livre_emsfin.cod_compon_2_idx_tab = string(1)
                    no-error.
                if  avail tab_livre_emsfin then do:
                    if  avail plano_ccusto then do:
                        assign tab_livre_emsfin.cod_livre_2 = v_cod_initial + chr(10) +
                                                              v_cod_final   + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)) + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)).
                    end.
                    else do:
                        assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                              "" + chr(10) +
                                                              "" + chr(10) +
                                                              "".
                    end.
                end.
            &else
                if  avail plano_ccusto then do:
                    assign conjto_prefer_demonst.cod_ccusto_inic  = v_cod_initial
                           conjto_prefer_demonst.cod_ccusto_fim   = v_cod_final
                           conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                           conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
                end.
            &endif
        end.
    end.
END. /* ON VALUE-CHANGED OF v_ind_selec_tip_demo IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON VALUE-CHANGED OF v_ind_tip_sdo_ctbl_demo IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    if avail prefer_demonst_ctbl then do:
       &if '{&emsfin_version}' = '5.05' &then
           IF v_ind_tip_sdo_ctbl_demo:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo <> ENTRY(3, prefer_demonst_ctbl.cod_livre_1, CHR(10)) THEN
              ASSIGN v_log_alterado = YES.
       &else
           IF v_ind_tip_sdo_ctbl_demo:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo <> prefer_demonst_ctbl.ind_tip_sdo_ctbl_demo THEN
              ASSIGN v_log_alterado = YES.
       &endif
    end.
    for each tt_ord_col.
        delete tt_ord_col.
    end.
    run pi_rpt_open_item_padr_col_demonst_ctbl /*pi_rpt_open_item_padr_col_demonst_ctbl*/.
    run pi_abre_conjto_prefer_padr /*pi_abre_conjto_prefer_padr*/.
END. /* ON VALUE-CHANGED OF v_ind_tip_sdo_ctbl_demo IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON LEAVE OF prefer_demonst_ctbl.cod_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    find demonst_ctbl no-lock
          where demonst_ctbl.cod_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl no-error.

    display demonst_ctbl.des_tit_ctbl when avail demonst_ctbl
            "" when not avail demonst_ctbl @ demonst_ctbl.des_tit_ctbl
            with frame f_dlg_01_demonst_ctbl_fin_novo.

    apply 'leave' to prefer_demonst_ctbl.cod_padr_col_demonst_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.
END. /* ON LEAVE OF prefer_demonst_ctbl.cod_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON LEAVE OF prefer_demonst_ctbl.cod_padr_col_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    if not v_log_alterado and avail prefer_demonst_ctbl
       and (prefer_demonst_ctbl.cod_padr_col_demonst_ctbl <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
            or prefer_demonst_ctbl.cod_demonst_ctbl <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl) then
        assign v_log_alterado = yes.

    if  v_log_funcao_concil_consolid
    then do:
        find first demonst_ctbl no-lock
             where demonst_ctbl.cod_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl no-error.
        find first plano_cta_ctbl no-lock
             where plano_cta_ctbl.cod_plano_cta_ctbl = demonst_ctbl.cod_plano_cta_ctbl no-error.
        if  avail plano_cta_ctbl
        and plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Consolidaá∆o" /*l_consolidacao*/  then
            enable v_log_consolid_recur
                   with frame f_dlg_01_demonst_ctbl_fin_novo.
    end.

    find padr_col_demonst_ctbl no-lock
       where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl =
             input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl no-error.
    display padr_col_demonst_ctbl.des_tit_ctbl when avail padr_col_demonst_ctbl
            "" when not avail padr_col_demonst_ctbl @ padr_col_demonst_ctbl.des_tit_ctbl
            with frame f_dlg_01_demonst_ctbl_fin_novo.
    if  (avail padr_col_demonst_ctbl and
        v_rec_padr_col_aux <> recid(padr_col_demonst_ctbl)) or
        (avail col_demonst_ctbl and asc(col_demonst_ctbl.cod_col_demonst_ctbl) - 64 <> v_num_item)
    then do:
        assign v_rec_padr_col_aux = recid(padr_col_demonst_ctbl)
               v_rec_padr_col_demonst_ctbl = v_rec_padr_col_aux
               v_num_entry   = 1
               v_log_mudou_ord_col = no.

        for each tt_ord_col.
            delete tt_ord_col.
        end.           

        /* * Pesquisa se n∆o houve alteraá‰es nas colunas e recria em caso de alteraá∆o **/

        /* Begin_Include: i_col_prefer_demonst_ctbl */
        &if '{&emsfin_version}' = '5.05' &then
            IF  can-find(first tab_livre_emsfin NO-LOCK
                where TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                and   TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                and   TAB_livre_emsfin.cod_compon_1_idx_tab = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + 
                                                              INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl) then do:
                /* * TESTA SE ALGUMA COLUNA FOI INCLU÷DA **/
                ASSIGN v_log_col_atualiz = NO.
                /* * Atualiza var com todas as colunas cadastradas e testa se TAB_livre est† atualizada **/
                for each col_demonst_ctbl no-lock
                   where col_demonst_ctbl.cod_padr_col_demonst_ctbl = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                   BY col_demonst_ctbl.num_soma_ascii_cod_col:

                   if col_demonst_ctbl.ind_funcao_col_demonst_ctbl = "Base C†lculo" /*l_base_calculo*/  then
                       next.

                   CREATE tt_ord_col.
                   ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                          tt_ord_col.ttv_cod_col_demonst_ctbl = col_demonst_ctbl.cod_col_demonst_ctbl
                          tt_ord_col.ttv_des_tit_ctbl         = col_demonst_ctbl.des_tit_ctbl
                          v_num_seq_6 = v_num_seq_6 + 10.

                   /* * Verifica se TAB_livre est† desatualizada **/
                   IF NOT can-find(first tab_livre_emsfin NO-LOCK
                      where TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                      and   TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                      and   TAB_livre_emsfin.cod_compon_1_idx_tab = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + 
                                                                    INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                      and   TAB_livre_emsfin.cod_livre_1          = col_demonst_ctbl.des_tit_ctbl
                      and   tab_livre_emsfin.cod_livre_2          = col_demonst_ctbl.cod_col_demonst_ctbl)
                      THEN ASSIGN v_log_col_atualiz = YES.
                end.
                /* * TESTA SE ALGUMA COLUNA FOI ELIMINADA **/
                if  NOT v_log_col_atualiz
                then do:
                    /* * Gera vari†vel com a sequància de colunas gravadas na TAB_livre **/
                    for each  TAB_livre_emsfin no-LOCK
                       where TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                       and   TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                       and   TAB_livre_emsfin.cod_compon_1_idx_tab = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + 
                                                                     INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl :
                        IF NOT CAN-FIND(tt_ord_col
                                        WHERE tt_ord_col.ttv_cod_col_demonst_ctbl = TAB_livre_emsfin.cod_livre_2
                                        AND   tt_ord_col.ttv_des_tit_ctbl         = TAB_livre_emsfin.cod_livre_1) THEN DO:
                            ASSIGN v_log_col_atualiz = YES.
                            LEAVE.
                        END.
                    end.
                end.
            end.
            /* * Caso alguma destas colunas n∆o esteja atualizada na TAB_livre elimina e atualiza esta **/
            if  v_log_col_atualiz then do:

                /* Begin_Include: i_cria_col_prefer_demonst_ctbl */
                &if '{&emsfin_version}' = '5.05' &then
                    for each   TAB_livre_emsfin exclusive-lock
                        where  TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/  
                        and    TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/  
                        and    TAB_livre_emsfin.cod_compon_1_idx_tab = (prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl):
                        delete tab_livre_emsfin.
                    end.

                    for each tt_ord_col:
                        CREATE TAB_livre_emsfin.
                        ASSIGN TAB_livre_emsfin.cod_modul_dtsul       = "MGL" /*l_mgl*/  
                               TAB_livre_emsfin.cod_tab_dic_dtsul     = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                               TAB_livre_emsfin.cod_compon_1_idx_tab  = prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                               TAB_livre_emsfin.cod_compon_2_idx_tab  = STRING(tt_ord_col.ttv_num_seq)
                               TAB_livre_emsfin.cod_livre_1           = tt_ord_col.ttv_des_tit_ctbl
                               tab_livre_emsfin.cod_livre_2           = tt_ord_col.ttv_cod_col_demonst_ctbl.
                        &if '{&emsfin_dbtype}' <> 'progress' &then 
                            VALIDATE TAB_livre_emsfin.
                        &endif
                    end.
                &else
                    for each col_prefer_demonst_ctbl exclusive-lock
                        where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                        and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                        and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
                        DELETE col_prefer_demonst_ctbl.
                    end.

                    for each tt_ord_col:
                        CREATE col_prefer_demonst_ctbl.
                        ASSIGN col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                               col_prefer_demonst_ctbl.cod_demonst_ctbl          = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                               col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                               col_prefer_demonst_ctbl.num_seq                   = tt_ord_col.ttv_num_seq
                               col_prefer_demonst_ctbl.des_tit_ctbl              = tt_ord_col.ttv_des_tit_ctbl
                               col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = tt_ord_col.ttv_cod_col_demonst_ctbl.
                        &if '{&emsfin_dbtype}' <> 'progress' &then 
                            VALIDATE col_prefer_demonst_ctbl.
                        &endif
                    end.
                &endif
                /* End_Include: i_cria_col_prefer_demonst_ctbl */

            end.
            else do:
                /* * Atualiza informaá‰es da tela conforme £ltima parametrizaá∆o do usu†rio **/
                for each tt_ord_col.
                    delete tt_ord_col.
                end.
                for each TAB_livre_emsfin no-lock
                    where TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                    and   TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                    and   TAB_livre_emsfin.cod_compon_1_idx_tab = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + 
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                    by    int(TAB_livre_emsfin.cod_compon_2_idx_tab):
                    if  tab_livre_emsfin.cod_livre_1 <> "" then do:
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = TAB_livre_emsfin.cod_livre_2
                               tt_ord_col.ttv_des_tit_ctbl         = TAB_livre_emsfin.cod_livre_1
                               v_num_seq_6                           = v_num_seq_6 + 10.
                    end.
                end.
            end.
        &else
            IF  can-find(first col_prefer_demonst_ctbl NO-LOCK
                where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl) then do:

                /* * TESTA SE ALGUMA COLUNA FOI INCLU÷DA **/
                ASSIGN v_log_col_atualiz = NO.

                /* * Atualiza var com todas as colunas cadastradas e testa se TAB_livre est† atualizada **/
                for each col_demonst_ctbl no-lock
                    where col_demonst_ctbl.cod_padr_col_demonst_ctbl = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                    BY col_demonst_ctbl.num_soma_ascii_cod_col:

                    CREATE tt_ord_col.
                    ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                           tt_ord_col.ttv_cod_col_demonst_ctbl = COL_demonst_ctbl.cod_col_demonst_ctbl
                           tt_ord_col.ttv_des_tit_ctbl         = COL_demonst_ctbl.des_tit_ctbl
                           v_num_seq_6                           = v_num_seq_6 + 10.

                    /* * Verifica se tabela est† desatualizada **/
                    IF  NOT can-find(first col_prefer_demonst_ctbl NO-LOCK
                        where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                        and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                        and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                        and   col_prefer_demonst_ctbl.des_tit_ctbl              = col_demonst_ctbl.des_tit_ctbl
                        and   col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = col_demonst_ctbl.cod_col_demonst_ctbl) THEN 
                        ASSIGN v_log_col_atualiz = YES.
                end.
            end.

            /* * TESTA SE ALGUMA COLUNA FOI ELIMINADA **/   
            if  not v_log_col_atualiz then do:
                /* * Gera vari†vel com a sequància de colunas gravadas na Tabela **/
                for each col_prefer_demonst_ctbl no-lock            
                    where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                    and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                    and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
                    IF NOT CAN-FIND(tt_ord_col
                        WHERE tt_ord_col.ttv_cod_col_demonst_ctbl = COL_prefer_demonst_ctbl.cod_col_demonst_ctbl
                        AND   tt_ord_col.ttv_des_tit_ctbl         = COL_prefer_demonst_ctbl.des_tit_ctbl) THEN DO:
                        ASSIGN v_log_col_atualiz = YES.
                        LEAVE.
                    end.
                end.
            end.

            /* * Caso alguma destas colunas n∆o esteja atualizada na Tabela elimina e atualiza esta **/
            if  v_log_col_atualiz then do:

                /* Begin_Include: i_cria_col_prefer_demonst_ctbl */
                &if '{&emsfin_version}' = '5.05' &then
                    for each   TAB_livre_emsfin exclusive-lock
                        where  TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/  
                        and    TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/  
                        and    TAB_livre_emsfin.cod_compon_1_idx_tab = (prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl):
                        delete tab_livre_emsfin.
                    end.

                    for each tt_ord_col:
                        CREATE TAB_livre_emsfin.
                        ASSIGN TAB_livre_emsfin.cod_modul_dtsul       = "MGL" /*l_mgl*/  
                               TAB_livre_emsfin.cod_tab_dic_dtsul     = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                               TAB_livre_emsfin.cod_compon_1_idx_tab  = prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                               TAB_livre_emsfin.cod_compon_2_idx_tab  = STRING(tt_ord_col.ttv_num_seq)
                               TAB_livre_emsfin.cod_livre_1           = tt_ord_col.ttv_des_tit_ctbl
                               tab_livre_emsfin.cod_livre_2           = tt_ord_col.ttv_cod_col_demonst_ctbl.
                        &if '{&emsfin_dbtype}' <> 'progress' &then 
                            VALIDATE TAB_livre_emsfin.
                        &endif
                    end.
                &else
                    for each col_prefer_demonst_ctbl exclusive-lock
                        where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                        and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                        and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
                        DELETE col_prefer_demonst_ctbl.
                    end.

                    for each tt_ord_col:
                        CREATE col_prefer_demonst_ctbl.
                        ASSIGN col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                               col_prefer_demonst_ctbl.cod_demonst_ctbl          = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                               col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                               col_prefer_demonst_ctbl.num_seq                   = tt_ord_col.ttv_num_seq
                               col_prefer_demonst_ctbl.des_tit_ctbl              = tt_ord_col.ttv_des_tit_ctbl
                               col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = tt_ord_col.ttv_cod_col_demonst_ctbl.
                        &if '{&emsfin_dbtype}' <> 'progress' &then 
                            VALIDATE col_prefer_demonst_ctbl.
                        &endif
                    end.
                &endif
                /* End_Include: i_cria_col_prefer_demonst_ctbl */

            end.
            else do:
                /* * Atualiza informaá‰es da tela conforme £ltima parametrizaá∆o do usu†rio **/
                for each tt_ord_col.
                    delete tt_ord_col.
                end.
                for each col_prefer_demonst_ctbl exclusive-lock
                    where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                    and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                    and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                    by    col_prefer_demonst_ctbl.cod_usuario 
                    by    col_prefer_demonst_ctbl.cod_demonst_ctbl
                    by    col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                    by    col_prefer_demonst_ctbl.num_seq:

                    if  col_prefer_demonst_ctbl.des_tit_ctbl <> "" then do:
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                               tt_ord_col.ttv_des_tit_ctbl = COL_prefer_demonst_ctbl.des_tit_ctbl
                               tt_ord_col.ttv_cod_col_demonst_ctbl = COL_prefer_demonst_ctbl.cod_col_demonst_ctbl
                               v_num_seq_6 = v_num_seq_6 + 10.
                    end.
                end.
            end.
        &endif
        /* End_Include: i_cria_col_prefer_demonst_ctbl */


        run pi_rpt_open_item_padr_col_demonst_ctbl /*pi_rpt_open_item_padr_col_demonst_ctbl*/.
        run pi_abre_conjto_prefer_padr /*pi_abre_conjto_prefer_padr*/.
    end.
END. /* ON LEAVE OF prefer_demonst_ctbl.cod_padr_col_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_320531 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF idioma.cod_idioma IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom */
    if  search("prgint/utb/utb014ka.r") = ? and search("prgint/utb/utb014ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb014ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb014ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb014ka.p /*prg_sea_idioma*/.
    if  v_rec_idioma <> ?
    then do:
        find idioma where recid(idioma) = v_rec_idioma no-lock no-error.
        assign idioma.cod_idioma:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(idioma.cod_idioma).

    end /* if */.
    apply "entry" to idioma.cod_idioma in frame f_dlg_01_demonst_ctbl_fin_novo.
end. /* ON  CHOOSE OF bt_zoo_320531 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON  CHOOSE OF bt_zoo_320985 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF prefer_demonst_ctbl.cod_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom */
    if  search("prgfin/mgl/mgl003ka.r") = ? and search("prgfin/mgl/mgl003ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl003ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl003ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/mgl/mgl003ka.p /*prg_sea_demonst_ctbl*/.
    if  v_rec_demonst_ctbl <> ?
    then do:
        find demonst_ctbl where recid(demonst_ctbl) = v_rec_demonst_ctbl no-lock no-error.
        assign prefer_demonst_ctbl.cod_demonst_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(demonst_ctbl.cod_demonst_ctbl).

        display demonst_ctbl.des_tit_ctbl
                with frame f_dlg_01_demonst_ctbl_fin_novo.

    end /* if */.
    apply "entry" to prefer_demonst_ctbl.cod_demonst_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.
end. /* ON  CHOOSE OF bt_zoo_320985 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON  CHOOSE OF bt_zoo_320986 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF prefer_demonst_ctbl.cod_padr_col_demonst_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom */
    if  search("prgfin/mgl/mgl007ka.r") = ? and search("prgfin/mgl/mgl007ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/mgl/mgl007ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/mgl/mgl007ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/mgl/mgl007ka.p /*prg_sea_padr_col_demonst_ctbl*/.
    if  v_rec_padr_col_demonst_ctbl <> ?
    then do:
        find padr_col_demonst_ctbl where recid(padr_col_demonst_ctbl) = v_rec_padr_col_demonst_ctbl no-lock no-error.
        assign prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl).

        display padr_col_demonst_ctbl.des_tit_ctbl
                with frame f_dlg_01_demonst_ctbl_fin_novo.

    end /* if */.
    apply "entry" to prefer_demonst_ctbl.cod_padr_col_demonst_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.
end. /* ON  CHOOSE OF bt_zoo_320986 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON  CHOOSE OF bt_zoo_321329 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF v_cod_exerc_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb075ka.r") = ? and search("prgint/utb/utb075ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb075ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb075ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb075ka.p /*prg_sea_exerc_ctbl*/.
    if  v_rec_exerc_ctbl <> ?
    then do:
        find exerc_ctbl where recid(exerc_ctbl) = v_rec_exerc_ctbl no-lock no-error.
        assign v_cod_exerc_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(exerc_ctbl.cod_exerc_ctbl).

        apply "entry" to v_cod_exerc_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_321329 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON  CHOOSE OF bt_zoo_326355 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF v_cod_plano_cta_ctbl IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb080ka.r") = ? and search("prgint/utb/utb080ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb080ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb080ka.p /*prg_sea_plano_cta_ctbl*/.
    if  v_rec_plano_cta_ctbl <> ?
    then do:
        find plano_cta_ctbl where recid(plano_cta_ctbl) = v_rec_plano_cta_ctbl no-lock no-error.
        assign v_cod_plano_cta_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(plano_cta_ctbl.cod_plano_cta_ctbl).

        display plano_cta_ctbl.des_tit_ctbl
                with frame f_dlg_01_demonst_ctbl_fin_novo.

        apply "entry" to v_cod_plano_cta_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326355 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON  CHOOSE OF bt_zoo_326358 IN FRAME f_dlg_01_demonst_ctbl_fin_novo
OR F5 OF v_cod_unid_organ IN FRAME f_dlg_01_demonst_ctbl_fin_novo DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb010ka.r") = ? and search("prgint/utb/utb010ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb010ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb010ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb010ka.p /*prg_sea_unid_organ*/.
    if  v_rec_unid_organ <> ?
    then do:
        find emsuni.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
        assign v_cod_unid_organ:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ in frame f_dlg_01_demonst_ctbl_fin_novo.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326358 IN FRAME f_dlg_01_demonst_ctbl_fin_novo */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_01_demonst_ctbl_fin_novo ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_demonst_ctbl_fin_novo ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_demonst_ctbl_fin_novo ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_01_demonst_ctbl_fin_novo */

ON WINDOW-CLOSE OF FRAME f_dlg_01_demonst_ctbl_fin_novo
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_dlg_01_demonst_ctbl_fin_novo */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_01_demonst_ctbl_fin_novo.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
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


        assign v_nom_prog     = substring(frame f_dlg_01_demonst_ctbl_fin_novo:title, 1, max(1, length(frame f_dlg_01_demonst_ctbl_fin_novo:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_prefer_demonst_ctbl":U.




    assign v_nom_prog_ext = "prgfin/mgl/MGLA204zb.p":U
           v_cod_release  = trim(" 1.00.00.052":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_prefer_demonst_ctbl}


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
    run pi_version_extract ('fnc_prefer_demonst_ctbl':U, 'prgfin/mgl/MGLA204zb.p':U, '1.00.00.052':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

&if '{&emsbas_version}' >= '5.06' &then
if  search("prgfin/bgc/bgc404aa.r") = ? and search("prgfin/bgc/bgc404aa.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bgc/bgc404aa.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/bgc/bgc404aa.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgfin/bgc/bgc404aa.py /*prg_spp_sdo_orcto_ctbl_bgc_acerto_cod_livre*/.
&endif


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


if  search("prgfin/fgl/fgl814aa.r") = ? and search("prgfin/fgl/fgl814aa.p") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl814aa.p".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "MGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl814aa.p"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgfin/fgl/fgl814aa.p /*prg_spp_col_demonst_ctbl_alt_tip_consolid*/.
if return-value = "NOK" /*l_nok*/  then
   return.
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
    run prgtec/men/men901za.py (Input 'fnc_prefer_demonst_ctbl') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prefer_demonst_ctbl')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prefer_demonst_ctbl')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_prefer_demonst_ctbl' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_prefer_demonst_ctbl'
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
    where prog_dtsul.cod_prog_dtsul = "fnc_prefer_demonst_ctbl":U
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


assign v_wgh_frame_epc = frame f_dlg_01_demonst_ctbl_fin_novo:handle.



assign v_nom_table_epc = 'prefer_demonst_ctbl':U
       v_rec_table_epc = recid(prefer_demonst_ctbl).

&endif

/* End_Include: i_verify_program_epc */



/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_dlg_01_demonst_ctbl_fin_novo:title = frame f_dlg_01_demonst_ctbl_fin_novo:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.00.052":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_dlg_01_demonst_ctbl_fin_novo = menu m_help:handle.


/* End_Include: i_std_dialog_box */
{include/title5.i f_dlg_01_demonst_ctbl_fin_novo FRAME}



/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(prefer_demonst_ctbl).    
    run value(v_nom_prog_upc) (input "initialize" /* l_initialize*/,
                               input 'viewer',
                               input this-procedure,
                               input v_wgh_frame_epc,
                               input v_nom_table_epc,
                               input v_rec_table_epc).
    if  "no" /* l_no*/ = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

if  v_nom_prog_appc <> '' then
do:
    assign v_rec_table_epc = recid(prefer_demonst_ctbl).    
    run value(v_nom_prog_appc) (input "initialize" /* l_initialize*/,
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  "no" /* l_no*/ = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

&if '{&emsbas_version}' > '5.00' &then
if  v_nom_prog_dpc <> '' then
do:
    assign v_rec_table_epc = recid(prefer_demonst_ctbl).    
    run value(v_nom_prog_dpc) (input "initialize" /* l_initialize*/,
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  "no" /* l_no*/ = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.
&endif
&endif
/* End_Include: i_exec_program_epc */



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


assign v_log_funcao_concil_consolid  = &IF DEFINED (BF_FIN_CONCIL_CONSOLID) &THEN YES &ELSE GetDefinedFunction('SPP_CONCIL_CONSOLID':U) &ENDIF
       v_log_funcao_impr_col_sem_sdo = &IF DEFINED (BF_FIN_PARAM_IMPR_COL)  &THEN YES &ELSE GetDefinedFunction('SPP_PARAM_IMPR_COL':U)  &ENDIF.
if  v_log_eai_habilit then
    assign v_log_period_balan_geren = &IF DEFINED (BF_FIN_XML_DEMONST) &THEN YES &ELSE GetDefinedFunction('SPP_XML_DEMONST':U) &ENDIF.       
else
    assign v_log_period_balan_geren = no.    

pause 0 before-hide.
view frame f_dlg_01_demonst_ctbl_fin_novo.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'INITIALIZE',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */

ASSIGN rt_mold:height-chars in frame f_dlg_01_demonst_ctbl_fin_novo = 16.8.

main_block:
do on endkey undo main_block, leave main_block
                on error undo main_block, leave main_block TRANSACTION.
    /* spp_estrut_ctbl_movto_analit_v2
      O programa de acerto foi modificado e deve ser executado novamente
      em toda a base instalada para corrigir o cod_livre_1 da tabela
      de estrutura - fut12234 03/05/2005

    find first emsbas.histor_exec_especial no-lock 
         where emsbas.histor_exec_especial.cod_modul_dtsul = @%(l_mgl) 
         and   emsbas.histor_exec_especial.cod_prog_dtsul  = 'spp_estrut_ctbl_movto_analit_v2'
         no-error.
    if not avail emsbas.histor_exec_especial then do:
       @run_vr (spp_estrut_ctbl_movto_analit).
    end.*/

    enable all with frame f_dlg_01_demonst_ctbl_fin_novo. 

    disable demonst_ctbl.des_tit_ctbl
            padr_col_demonst_ctbl.des_tit_ctbl
            plano_cta_ctbl.des_tit_ctbl
            plano_ccusto.des_tit_ctbl
            with frame f_dlg_01_demonst_ctbl_fin_novo.


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'DISPLAY',
                                 Input 'no',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'ENABLE',
                                 Input 'no',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    /* Posiciona na £ltima preferància do usu†rio*/
    FOR EACH b_prefer_demonst_ctbl NO-LOCK
         where b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
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

    /* Rodrigo - ATV247723*/
    IF  AVAIL prefer_demonst_ctbl THEN DO:
        &if '{&emsfin_version}' = '5.05' &then
        if trim(entry(1,prefer_demonst_ctbl.cod_livre_1,CHR(10))) = ' ' then
            assign entry(1,prefer_demonst_ctbl.cod_livre_1,CHR(10)) = "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/ .
        &else
        if trim(prefer_demonst_ctbl.ind_selec_demo_ctbl) = ' ' then
            assign prefer_demonst_ctbl.ind_selec_demo_ctbl = "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/ .
        &endif.

        ASSIGN v_ind_selec_demo_ctbl:SCREEN-VALUE IN FRAME f_dlg_01_demonst_ctbl_fin_novo = &if '{&emsfin_version}' = '5.05' &then
                                                                       entry(1,prefer_demonst_ctbl.cod_livre_1,CHR(10))
                                                                       &else
                                                                       prefer_demonst_ctbl.ind_selec_demo_ctbl
                                                                       &endif .
    END.
    /* Rodrigo - ATV247723*/

    apply "value-changed" to v_ind_selec_demo_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.

    apply "entry" to v_ind_selec_demo_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.

    if input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl = 'Demonstrativo Cont†bil' then do:     

        for each conjto_prefer_demonst exclusive-lock
           where conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
             and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
             and conjto_prefer_demonst.cod_usuario               = prefer_demonst_ctbl.cod_usuario:

            find first b_col_demonst_ctbl no-lock
                 where b_col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                   and b_col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
                   and b_col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_orcamento*/   no-error.
            if not avail b_col_demonst_ctbl then do:
               assign conjto_prefer_demonst.cod_cenar_orctario  = ''
                      conjto_prefer_demonst.cod_vers_orcto_ctbl = ''.
               &if '{&emsfin_version}' > '5.05' &then
                 assign conjto_prefer_demonst.cod_unid_orctaria  = ''
                        conjto_prefer_demonst.num_seq_orcto_ctbl = 0.
               &else
                 assign entry(1,conjto_prefer_demonst.cod_livre_1,chr(10)) = ''
                        entry(2,conjto_prefer_demonst.cod_livre_1,chr(10)) = '0'.
               &endif
            end.
        end.    
    end.    

    if  v_log_funcao_concil_consolid
    then do:
        find first dwb_rpt_param no-lock
            where dwb_rpt_param.cod_dwb_program = 'rel_demonst_ctbl_video':U
              and dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren + '_dem' no-error.
        if  avail dwb_rpt_param and num-entries(dwb_rpt_param.cod_dwb_parameters,chr(10)) > 37 then
            assign v_log_consolid_recur = string(entry(38,dwb_rpt_param.cod_dwb_parameters,chr(10))) = 'yes'.
        display v_log_consolid_recur with frame f_dlg_01_demonst_ctbl_fin_novo.
    end.
    else
        assign v_log_consolid_recur:visible in frame f_dlg_01_demonst_ctbl_fin_novo = no.

    data_block:
    repeat on endkey undo main_block, leave main_block on error undo data_block, retry data_block while true:
        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_01_demonst_ctbl_fin_novo focus v_wgh_focus.
        end.
        else do:
            wait-for go of frame f_dlg_01_demonst_ctbl_fin_novo.
        end.
        save_block:
        do on error undo data_block, retry data_block:

            if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
                /* --- Demonstrativo Cont†bil ---*/
                assign v_wgh_focus = prefer_demonst_ctbl.cod_demonst_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                find demonst_ctbl no-lock
                    where demonst_ctbl.cod_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl no-error.
                if  not available demonst_ctbl
                then do:
                    /* &1 inexistente ! */
                    run pi_messages (input "show",
                                     input 1284,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        "Demonstrativo Cont†bil", "Demonstrativos Cont†beis")) /*msg_1284*/.
                    next data_block.
                end.
            end.

            IF NOT v_log_alterado THEN DO:
                IF prefer_demonst_ctbl.cod_demonst_ctbl              <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                   OR prefer_demonst_ctbl.cod_padr_col_demonst_ctbl  <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                   OR prefer_demonst_ctbl.cod_exerc_ctbl             <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_exerc_ctbl
                   OR prefer_demonst_ctbl.cod_idioma                 <> input frame f_dlg_01_demonst_ctbl_fin_novo idioma.cod_idioma
                   OR prefer_demonst_ctbl.num_period_ctbl            <> input frame f_dlg_01_demonst_ctbl_fin_novo v_num_period_ctbl
                   OR prefer_demonst_ctbl.val_fator_div_demonst_ctbl <> input frame f_dlg_01_demonst_ctbl_fin_novo v_num_fator_div
                   OR prefer_demonst_ctbl.log_consid_apurac_restdo   <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_apurac_restdo
                   OR prefer_demonst_ctbl.log_acum_cta_ctbl_sint     <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_cta_ctbl_sint_2
                   OR prefer_demonst_ctbl.log_impr_cta_sem_sdo       <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_sdo_zero
                   OR prefer_demonst_ctbl.cod_demonst_ctbl           <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                   OR prefer_demonst_ctbl.cod_padr_col_demonst_ctbl  <> input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
              &if '{&emsfin_version}' >= '5.06' &then
                   OR prefer_demonst_ctbl.log_impr_acum_zero         <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero
              &else
                   OR prefer_demonst_ctbl.log_livre_1                <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero
              &endif
              &if '{&emsfin_version}' >= '5.07' &then
                   OR (not v_log_funcao_impr_col_sem_sdo or prefer_demonst_ctbl.log_impr_col_sem_sdo <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_col_sem_sdo)
              &else
                   OR (not v_log_funcao_impr_col_sem_sdo or (GetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10)) <> "no" /*l_no*/ ) <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_col_sem_sdo)
              &endif
              &if '{&emsfin_version}' >= '5.07' &then
                   OR prefer_demonst_ctbl.log_gera_dados_xml <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_gera_dados_xml
              &else
                   OR prefer_demonst_ctbl.num_livre_1        <> integer(input frame f_dlg_01_demonst_ctbl_fin_novo v_log_gera_dados_xml)
              &endif     

                   OR v_cod_unid_organ                               <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
                   OR v_ind_selec_demo_ctbl                          <> input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
                   OR v_ind_selec_demo_ctbl                          <> input FRAME f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
                   OR v_cod_exerc_ctbl                               <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_exerc_ctbl 
                   OR v_num_period_ctbl                              <> input frame f_dlg_01_demonst_ctbl_fin_novo v_num_period_ctbl
                   OR v_num_fator_div                                <> input frame f_dlg_01_demonst_ctbl_fin_novo v_num_fator_div
                   OR v_log_consid_apurac_restdo                     <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_apurac_restdo
                   OR v_log_consid_sdo_zero                          <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_sdo_zero
                   OR v_log_cta_ctbl_sint_2                          <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_cta_ctbl_sint_2
                   OR v_log_impr_acum_zero                           <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero
                   OR v_log_consolid_recur                           <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consolid_recur
                   OR v_log_gera_dados_xml                           <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_gera_dados_xml  
                   OR v_cod_unid_organ                               <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ 
                   OR (not v_log_funcao_impr_col_sem_sdo or v_log_impr_col_sem_sdo <> input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_col_sem_sdo) THEN DO:
                    ASSIGN v_log_alterado = YES.
                END.
                if NOT v_log_alterado
                   AND v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Consultas de Saldo" /*l_consultas_de_saldo*/ 
                then do:
                    IF v_cod_plano_cta_ctbl  <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
                       OR v_cod_plano_ccusto <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto THEN
                        ASSIGN v_log_alterado = YES.
                    IF NOT v_log_alterado THEN DO:
                        &if '{&emsfin_version}' = '5.05' &then
                            IF prefer_demonst_ctbl.cod_livre_1 <> input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl   + CHR(10) +
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo    + CHR(10) +
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo + CHR(10) +
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ        + CHR(10) +
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl    + CHR(10) +
                                                                  input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto THEN
                                ASSIGN v_log_alterado = YES.
                        &else
                            IF  prefer_demonst_ctbl.ind_selec_demo_ctbl      <> input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
                                OR prefer_demonst_ctbl.ind_selec_tip_demo    <> input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo
                                OR prefer_demonst_ctbl.ind_tip_sdo_ctbl_demo <> input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo
                                OR prefer_demonst_ctbl.cod_unid_organ_subst  <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
                                OR prefer_demonst_ctbl.cod_plano_cta_ctbl    <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
                                OR prefer_demonst_ctbl.cod_plano_ccusto      <> input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto THEN
                                ASSIGN v_log_alterado = YES.
                        &endif
                    END.
                END.
            END.

            /* --- Atualiza £ltima atualizaá∆o da preferància ---*/
            assign prefer_demonst_ctbl.dat_ult_atualiz = today.
            run pi_sec_to_formatted_time (Input time,
                                          output prefer_demonst_ctbl.hra_ult_atualiz) /*pi_sec_to_formatted_time*/.

            /* Atualiza demais campos da preferància*/
            assign prefer_demonst_ctbl.cod_exerc_ctbl             = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_exerc_ctbl no-error.
            assign prefer_demonst_ctbl.cod_idioma                 = idioma.cod_idioma:input-value
                   prefer_demonst_ctbl.num_period_ctbl            = v_num_period_ctbl:input-value
                   prefer_demonst_ctbl.val_fator_div_demonst_ctbl = v_num_fator_div:input-value
                   prefer_demonst_ctbl.log_consid_apurac_restdo   = v_log_consid_apurac_restdo:input-value
                   prefer_demonst_ctbl.log_acum_cta_ctbl_sint     = v_log_cta_ctbl_sint_2:input-value
                   prefer_demonst_ctbl.log_impr_cta_sem_sdo       = v_log_consid_sdo_zero:input-value
                   prefer_demonst_ctbl.cod_demonst_ctbl           = prefer_demonst_ctbl.cod_demonst_ctbl:input-value
                   prefer_demonst_ctbl.cod_padr_col_demonst_ctbl  = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:input-value
                   input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
                   input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
                   input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
                   input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo
                   input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo.
            IF v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  THEN DO:
               &if '{&emsfin_version}' >= '5.06' &then           
                     assign prefer_demonst_ctbl.log_impr_acum_zero = input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero.    
               &else 
                     assign prefer_demonst_ctbl.log_livre_1        = input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero.       
               &endif
            End.   

            &if '{&emsfin_version}' >= '5.07' &then
                assign prefer_demonst_ctbl.log_impr_col_sem_sdo = if v_log_funcao_impr_col_sem_sdo then v_log_impr_col_sem_sdo:input-value else yes.
            &else
                assign prefer_demonst_ctbl.cod_livre_1          = SetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10), string(if v_log_funcao_impr_col_sem_sdo then input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_col_sem_sdo else yes)).
            &endif
            &if '{&emsfin_version}' >= '5.07' &then
                assign prefer_demonst_ctbl.log_gera_dados_xml = v_log_gera_dados_xml:input-value.
            &else
                assign prefer_demonst_ctbl.num_livre_1        = integer(v_log_gera_dados_xml:input-value).
            &endif


            /* Begin_Include: i_cria_col_prefer_demonst_ctbl */
            &if '{&emsfin_version}' = '5.05' &then
                for each   TAB_livre_emsfin exclusive-lock
                    where  TAB_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/  
                    and    TAB_livre_emsfin.cod_tab_dic_dtsul    = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/  
                    and    TAB_livre_emsfin.cod_compon_1_idx_tab = (prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl):
                    delete tab_livre_emsfin.
                end.

                for each tt_ord_col:
                    CREATE TAB_livre_emsfin.
                    ASSIGN TAB_livre_emsfin.cod_modul_dtsul       = "MGL" /*l_mgl*/  
                           TAB_livre_emsfin.cod_tab_dic_dtsul     = prefer_demonst_ctbl.cod_usuario + chr(10) + "Preferàncias" /*l_preferencias*/ 
                           TAB_livre_emsfin.cod_compon_1_idx_tab  = prefer_demonst_ctbl.cod_demonst_ctbl + chr(10) + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                           TAB_livre_emsfin.cod_compon_2_idx_tab  = STRING(tt_ord_col.ttv_num_seq)
                           TAB_livre_emsfin.cod_livre_1           = tt_ord_col.ttv_des_tit_ctbl
                           tab_livre_emsfin.cod_livre_2           = tt_ord_col.ttv_cod_col_demonst_ctbl.
                    &if '{&emsfin_dbtype}' <> 'progress' &then 
                        VALIDATE TAB_livre_emsfin.
                    &endif
                end.
            &else
                for each col_prefer_demonst_ctbl exclusive-lock
                    where col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                    and   col_prefer_demonst_ctbl.cod_demonst_ctbl          = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                    and   col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
                    DELETE col_prefer_demonst_ctbl.
                end.

                for each tt_ord_col:
                    CREATE col_prefer_demonst_ctbl.
                    ASSIGN col_prefer_demonst_ctbl.cod_usuario               = prefer_demonst_ctbl.cod_usuario
                           col_prefer_demonst_ctbl.cod_demonst_ctbl          = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_demonst_ctbl
                           col_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
                           col_prefer_demonst_ctbl.num_seq                   = tt_ord_col.ttv_num_seq
                           col_prefer_demonst_ctbl.des_tit_ctbl              = tt_ord_col.ttv_des_tit_ctbl
                           col_prefer_demonst_ctbl.cod_col_demonst_ctbl      = tt_ord_col.ttv_cod_col_demonst_ctbl.
                    &if '{&emsfin_dbtype}' <> 'progress' &then 
                        VALIDATE col_prefer_demonst_ctbl.
                    &endif
                end.
            &endif
            /* End_Include: i_cria_col_prefer_demonst_ctbl */


            /* Salva ParÉmetros para as Consultas de Saldo */
            if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Consultas de Saldo" /*l_consultas_de_saldo*/ 
            then do:
                assign input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
                       input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto
                       input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
                       v_cod_demonst_ctbl          = ''
                       v_cod_padr_col_demonst_ctbl = ''
                       prefer_demonst_ctbl.val_fator_div_demonst_ctbl = 1.

                find unid_organ no-lock
                     where unid_organ.cod_unid_organ = v_cod_unid_organ no-error.
                if  not avail unid_organ then do:
                    assign v_wgh_focus = v_cod_unid_organ:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                    /* Unidade Organizacional Inexistente ! */
                    run pi_messages (input "show",
                                     input 264,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_264*/.
                    next data_block.
                end.

                find plano_cta_ctbl 
                    where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-lock no-error.
                if  not avail plano_cta_ctbl then do:
                    assign v_wgh_focus = v_cod_plano_cta_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                    /* Plano de Contas &1 inexistente ou inv†lido ! */
                    run pi_messages (input "show",
                                     input 680,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                       v_cod_plano_cta_ctbl)) /*msg_680*/.
                    next data_block.                    
                end.
                if  v_cod_plano_ccusto:sensitive in frame f_dlg_01_demonst_ctbl_fin_novo then do:
                    find plano_ccusto 
                        where plano_ccusto.cod_empresa = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
                        and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto no-lock no-error.
                    if  not avail plano_ccusto then do:
                        assign v_wgh_focus = v_cod_plano_ccusto:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                        /* Plano de Centro de Custo &1 Inexistente ! */
                        run pi_messages (input "show",
                                         input 11398,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                           v_cod_plano_ccusto)) /*msg_11398*/.
                        next data_block.                    
                    end.                    
                end.

                run pi_retornar_valores_iniciais_prefer (Input plano_cta_ctbl.cod_format_cta_ctbl,
                                                         Input "Cta Ctbl" /*l_cta_ctbl*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                find first conjto_prefer_demonst of prefer_demonst_ctbl exclusive-lock no-error.
                if  avail conjto_prefer_demonst then 
                    assign conjto_prefer_demonst.cod_cta_ctbl_prefer_excec = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl))
                           conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl)).

                &if '{&emsfin_version}' = '5.05' &then
                    assign prefer_demonst_ctbl.cod_livre_1 = input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl   + CHR(10) +
                                                             input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo    + CHR(10) +
                                                             input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo + CHR(10) +
                                                             input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ        + CHR(10) +
                                                             input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl    + CHR(10) +
                                                             input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto. 
                &else
                    assign prefer_demonst_ctbl.ind_selec_demo_ctbl   = v_ind_selec_demo_ctbl:input-value
                           prefer_demonst_ctbl.ind_selec_tip_demo    = v_ind_selec_tip_demo:input-value
                           prefer_demonst_ctbl.ind_tip_sdo_ctbl_demo = v_ind_tip_sdo_ctbl_demo:input-value
                           prefer_demonst_ctbl.cod_unid_organ_subst  = v_cod_unid_organ:input-value
                           prefer_demonst_ctbl.cod_plano_cta_ctbl    = v_cod_plano_cta_ctbl:input-value
                           prefer_demonst_ctbl.cod_plano_ccusto      = v_cod_plano_ccusto:input-value.
                &endif
                run pi_prefer_demonst_ctbl /*pi_prefer_demonst_ctbl*/.
            end.

            /* Begin_Include: i_executa_pi_epc_fin */
            run pi_exec_program_epc_FIN (Input 'ASSIGN',
                                         Input 'yes',
                                         output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
            if v_log_return_epc then /* epc retornou erro*/
                undo, retry.
            /* End_Include: i_executa_pi_epc_fin */

            run pi_vld_demons_ctbl_video /*pi_vld_demons_ctbl_video*/.
            if return-value = "NOK" /*l_nok*/  then
               next data_block.

            /* Begin_Include: i_executa_pi_epc_fin */
            run pi_exec_program_epc_FIN (Input 'VALIDATE',
                                         Input 'yes',
                                         output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
            if v_log_return_epc then /* epc retornou erro*/
                undo, retry.
            /* End_Include: i_executa_pi_epc_fin */

        end.
        leave data_block.
    end.
end.

DO TRANSACTION:
    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = 'rel_demonst_ctbl_video':U
           and dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren + '_dem' no-error.
    if  not available dwb_rpt_param
    then do:
        create dwb_rpt_param.
        assign dwb_rpt_param.cod_dwb_program         = 'rel_demonst_ctbl_video':U
               dwb_rpt_param.cod_dwb_user            = v_cod_usuar_corren + '_dem'
               dwb_rpt_param.cod_dwb_output          = "Terminal" /*l_terminal*/  
               dwb_rpt_param.ind_dwb_run_mode        = "On-Line" /*l_online*/ 
               dwb_rpt_param.cod_dwb_file            = ""
               dwb_rpt_param.nom_dwb_printer         = ""
               dwb_rpt_param.cod_dwb_print_layout    = "".
    end.

    /* --- Salva os ParÉmetros (RPW) ---*/
    IF  (v_log_impr_acum_zero:SENSITIVE IN FRAME f_dlg_01_demonst_ctbl_fin_novo) = YES THEN 
        ASSIGN v_cod_impr_acum_zero = string(v_log_impr_acum_zero:input-value).

    IF  (v_log_consolid_recur:SENSITIVE ) = YES THEN 
        ASSIGN v_cod_consolid_recur = string(v_log_consolid_recur:input-value).

    assign dwb_rpt_param.cod_dwb_parameters = prefer_demonst_ctbl.cod_demonst_ctbl:input-value  + chr(10)
                                            + prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:input-value + chr(10)
                                            + '' + chr(10)
                                            + '' + chr(10)
                                            + '' + chr(10)
                                            + '' + chr(10)
                                            + '' + chr(10)
                                            + string(v_cod_exerc_ctbl:input-value)       + chr(10)
                                            + string(v_num_period_ctbl:input-value)      + chr(10)
                                            + string(v_log_consid_apurac_restdo:input-value) + chr(10)
                                            + idioma.cod_idioma:input-value              + chr(10)
                                            + string(v_rec_prefer_demonst_ctbl) + chr(10)
                                            + string(v_num_fator_div:input-value)        + chr(10)
                                            + string(v_log_consid_sdo_zero:input-value)  + chr(10)
                                            + string(v_log_unid_organ_subst) + chr(10)
                                            + string(v_log_estab_subst)      + chr(10)
                                            + string(v_log_unid_negoc_subst) + chr(10)
                                            + string(v_log_ccusto_subst)     + chr(10)
                                            + v_cod_unid_organ_sub           + chr(10)
                                            + v_cod_estab_ini                + chr(10)
                                            + v_cod_estab_fim                + chr(10)
                                            + v_cod_unid_negoc_ini           + chr(10)
                                            + v_cod_unid_negoc_fim           + chr(10)
                                            + v_cod_plano_ccusto_sub         + chr(10)
                                            + v_cod_ccusto_ini               + chr(10)
                                            + v_cod_ccusto_fim               + chr(10)
                                            + v_cod_ccusto_pfixa_subst       + chr(10)
                                            + v_cod_ccusto_exec_subst        + chr(10)
                                            + string(v_log_cta_ctbl_sint_2:input-value)    + CHR(10)
                                            + v_cod_unid_organ:input-value  + CHR(10)
                                            + v_ind_selec_demo_ctbl:input-value  + CHR(10)
                                            + v_ind_selec_tip_demo:input-value  + CHR(10)
                                            + v_ind_tip_sdo_ctbl_demo:input-value + chr(10)
                                            + v_cod_usuar_corren + CHR(10)
                                            + string(v_dat_inic_period_ctbl,'99/99/9999') + CHR(10)
                                            + string(v_dat_fim_period_ctbl,'99/99/9999') + CHR(10)
                                            + v_cod_impr_acum_zero + CHR(10)
                                            + v_cod_consolid_recur + CHR(10)
                                            + (if v_log_funcao_impr_col_sem_sdo then string(v_log_impr_col_sem_sdo:input-value) else "yes" /*l_yes*/ ).
END.

hide frame f_dlg_01_demonst_ctbl_fin_novo.


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
** Procedure Interna.....: pi_vld_demons_ctbl_video
** Descricao.............: pi_vld_demons_ctbl_video
** Criado por............: src370
** Criado em.............: 22/02/2001 15:46:48
** Alterado por..........: fut41420
** Alterado em...........: 13/02/2008 15:20:26
*****************************************************************************/
PROCEDURE pi_vld_demons_ctbl_video:

    /************************* Variable Definition Begin ************************/

    def var v_cod_demonst_ctbl
        as character
        format "x(8)":U
        label "Demonstrativo"
        column-label "Demonstrativo"
        no-undo.
    def var v_cod_padr_col_demonst_ctbl
        as character
        format "x(8)":U
        label "Padr∆o Colunas"
        column-label "Padr∆o Colunas"
        no-undo.
    def var v_cod_conjto_prefer_orctario     as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_exerc_ctbl 
           input frame f_dlg_01_demonst_ctbl_fin_novo v_num_period_ctbl  no-error.
    assign input frame f_dlg_01_demonst_ctbl_fin_novo v_num_fator_div
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_apurac_restdo
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consid_sdo_zero
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_cta_ctbl_sint_2
           input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo
           input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo
           input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_impr_acum_zero
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_consolid_recur
           input frame f_dlg_01_demonst_ctbl_fin_novo v_log_gera_dados_xml
           v_cod_idioma = idioma.cod_idioma:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo.

    if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        IF  v_num_fator_div:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "0" /*l_0*/  THEN DO:
            /* Fator de Divis∆o Inv†lido ! */
            run pi_messages (input "show",
                             input 11688,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11688*/.
            return "NOK" /*l_nok*/ .
        END.

        run pi_verifica_segur_demonst_ctbl (Input demonst_ctbl.cod_demonst_ctbl,
                                            output v_log_return) /*pi_verifica_segur_demonst_ctbl*/.
        if  v_log_return = no
        then do:
            /* Usu†rio sem permiss∆o de acessar este demonstrativo. */
            run pi_messages (input "show",
                             input 1196,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1196*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        /* --- Padr∆o de Colunas do Demonstrativo Cont†bil ---*/
        find padr_col_demonst_ctbl no-lock
           where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl =
                 input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl no-error.
        if  not available padr_col_demonst_ctbl
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Padr∆o Colunas Demonstrativo", "Padr‰es Colunas Demonstrativo")) /*msg_1284*/.
            assign v_wgh_focus = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.
        assign v_cod_demonst_ctbl          = demonst_ctbl.cod_demonst_ctbl
               v_cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl.
    end.
    else do:
        if  v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "" /*l_null*/  
        or  v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = ? then do:
            /* ê necess†rio informar o tipo de Consulta ! */
            run pi_messages (input "show",
                             input 11423,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11423*/.
            assign v_wgh_focus = v_ind_selec_tip_demo:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.
        find padr_col_demonst_ctbl no-lock
           where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = "" /*l_null*/  
            or   padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = ? no-error.
        if  available padr_col_demonst_ctbl
        then do:
             /* Consulta Saldo do Demonstrativo Cont†bil n∆o ser† Poss°vel ! */
             run pi_messages (input "show",
                              input 13371,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13371*/.
             return "NOK" /*l_nok*/ .
        end /* if */.
    end.

    /* --- Conjunto de Preferàncias ---*/
    assign v_cod_conjto_prefer_orctario = ''.
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
            assign v_wgh_focus = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.
        if  conjto_prefer_demonst.cod_cenar_ctbl = ""
        then do:
            /* Cen†rio Cont†bil deve ser informado ! */
            run pi_messages (input "show",
                             input 694,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_694*/.
            assign v_wgh_focus = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.

        if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
            if  v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/   then do:
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
                    assign v_wgh_focus = bt_conjto_prefer:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                    return "NOK" /*l_nok*/ .
                end.
            end.
            if  v_ind_selec_tip_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/   then do:
                if  conjto_prefer_demonst.cod_cta_ctbl_inic <> conjto_prefer_demonst.cod_cta_ctbl_fim 
                or  conjto_prefer_demonst.cod_cta_ctbl_inic = '' then do:
                    /* Conta Cont†bil n∆o Informada ! */
                    run pi_messages (input "show",
                                     input 11426,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_11426*/.
                    assign v_wgh_focus = bt_conjto_prefer:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
                    return "NOK" /*l_nok*/ .               
                end.
            end.
            /* --- Oráamento ---*/
            if  can-find(first TT_col_demonst_ctbl no-lock
                where TT_col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                  and TT_col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
                  and TT_col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_orcamento*/ )
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
            end.
        end.
        else do:
            /* --- Oráamento ---*/
            if  can-find(first col_demonst_ctbl no-lock
                where col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
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
            end.
        end.
    end.

    if  v_cod_conjto_prefer_orctario <> ""
    then do:
        ASSIGN v_cod_conjto_prefer_orctario = STRING(v_cod_conjto_prefer_orctario,'x(' + string(R-INDEX(v_cod_conjto_prefer_orctario,',') - 1) + ')').
        /* ParÉmetros Oráamento n∆o Informados ! */
        run pi_messages (input "show",
                         input 11265,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_cod_conjto_prefer_orctario)) /*msg_11265*/.
        assign v_wgh_focus = bt_conjto_prefer:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
        return "NOK" /*l_nok*/ .
    end.

    if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        find first conjto_prefer_demonst no-lock
            where conjto_prefer_demonst.cod_usuario      = v_cod_usuar_corren
            and   conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
            and   conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl no-error.

        /* --- Exerc°cio Ctbl ---*/
        find first exerc_ctbl no-lock
           where exerc_ctbl.cod_exerc_ctbl = string(v_cod_exerc_ctbl) 
             and exerc_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl no-error.
        if  not avail exerc_ctbl
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Exerc°cio Cont†bil", "Exerc°cios Cont†beis")) /*msg_1284*/.
            assign v_wgh_focus = v_cod_exerc_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.
        find first period_ctbl
           where period_ctbl.cod_exerc_ctbl  = exerc_ctbl.cod_exerc_ctbl
             and period_ctbl.num_period_ctbl = v_num_period_ctbl 
             and period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl no-lock no-error.
        if  not avail period_ctbl
        then do:
            /* Per°odo Cont†bil &1 n∆o encontrado para Exerc°cio &2 ! */
            run pi_messages (input "show",
                             input 1051,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_period_ctbl, string(v_cod_exerc_ctbl))) /*msg_1051*/.
            assign v_wgh_focus = v_num_period_ctbl:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
            return "NOK" /*l_nok*/ .
        end.
        else
            assign v_dat_inic_period_ctbl = period_ctbl.dat_inic_period_ctbl
                   v_dat_fim_period_ctbl  = period_ctbl.dat_fim_period_ctbl.
    end.
    /* --- Idioma ---*/
    assign v_wgh_focus = idioma.cod_idioma:handle in frame f_dlg_01_demonst_ctbl_fin_novo.
    find idioma no-lock
         where idioma.cod_idioma = v_cod_idioma no-error.
    if  not avail idioma
    then do:
        /* &1 inexistente ! */
        run pi_messages (input "show",
                         input 1284,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Idioma", "Idiomas")) /*msg_1284*/.
        return "NOK" /*l_nok*/ .
    end.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_vld_demons_ctbl_video */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_open_item_padr_col_demonst_ctbl
** Descricao.............: pi_rpt_open_item_padr_col_demonst_ctbl
** Criado por............: src370
** Criado em.............: 28/02/2001 14:36:39
** Alterado por..........: fut35059
** Alterado em...........: 30/11/2005 19:34:07
*****************************************************************************/
PROCEDURE pi_rpt_open_item_padr_col_demonst_ctbl:

    /* Se o usu†rio mudou a ordem da colunas n∆o reprocessa */
    if  v_log_mudou_ord = no then do:
        if can-find(first tt_ord_col) then do:
            open query qr_ord_col
                for each tt_ord_col.
        end.
        else do:
            if  available padr_col_demonst_ctbl
            then do:
                block1:
                for
                   each col_demonst_ctbl no-lock
                      where col_demonst_ctbl.cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                         by &if '{&emsfin_version}' >= '5.01' &then
                                col_demonst_ctbl.num_soma_ascii_cod_col:
                            &else 
                                col_demonst_ctbl.cod_col_demonst_ctbl:
                            &endif
                    CREATE tt_ord_col.
                    ASSIGN tt_ord_col.ttv_num_seq = v_num_seq_6
                           tt_ord_col.ttv_cod_col_demonst_ctbl = COL_demonst_ctbl.cod_col_demonst_ctbl
                           tt_ord_col.ttv_des_tit_ctbl         = COL_demonst_ctbl.des_tit_ctbl
                           v_num_seq_6                           = v_num_seq_6 + 10.
                end.
                if  not v_cod_dwb_user begins "es_" /*l_es_*/  then
                    OPEN QUERY qr_ord_col
                        FOR EACH tt_ord_col.
            end.
            else do:
                case v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo:
                    when "Sdo/Movimento" /*l_sdomovimen*/  THEN DO:
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'A'
                               tt_ord_col.ttv_des_tit_ctbl         = "T°tulo Cont†bil" /*l_titulo_contabil*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'B'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Inicial" /*l_saldo_inicial*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'C'
                               tt_ord_col.ttv_des_tit_ctbl         = "Movto DÇbito" /*l_movto_debito*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'D'
                               tt_ord_col.ttv_des_tit_ctbl         = "Movto CrÇdito" /*l_movto_credito*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'E'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Final" /*l_saldo_final*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.                                        
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'F'
                               tt_ord_col.ttv_des_tit_ctbl         = "AV %" /*l_av_perc*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                    END.
                    when "Comparativo" /*l_comparativo*/  THEN DO:
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'A'
                               tt_ord_col.ttv_des_tit_ctbl         = "T°tulo Cont†bil" /*l_titulo_contabil*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'B'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Final 1¯" /*l_saldo_final_1*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'C'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Final 2¯" /*l_saldo_final_2*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'D'
                               tt_ord_col.ttv_des_tit_ctbl         = "AV % 1¯" /*l_av_perc_1*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'E'
                               tt_ord_col.ttv_des_tit_ctbl         = "AV % 2¯" /*l_av_perc_2*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'F'
                               tt_ord_col.ttv_des_tit_ctbl         = "AH %" /*l_ah_perc*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                    END.
                    when "Oráamentos" /*l_orcamentos*/  THEN DO:
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'A'
                               tt_ord_col.ttv_des_tit_ctbl         = "T°tulo Cont†bil" /*l_titulo_contabil*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'B'
                               tt_ord_col.ttv_des_tit_ctbl         = "Realizado" /*l_realizado*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'C'
                               tt_ord_col.ttv_des_tit_ctbl         = "Oráado" /*l_orcado*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'D'
                               tt_ord_col.ttv_des_tit_ctbl         = "Variaá∆o" /*l_variacao*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'E'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Realizado" /*l_sdo_realizado*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'F'
                               tt_ord_col.ttv_des_tit_ctbl         = "Saldo Oráado" /*l_saldo_oráado*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'G'
                               tt_ord_col.ttv_des_tit_ctbl         = "Qtd Realizada" /*l_qtd_realizada*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'H'
                               tt_ord_col.ttv_des_tit_ctbl         = "Qtd Oráada" /*l_qtd_orcada*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                        CREATE tt_ord_col.
                        ASSIGN tt_ord_col.ttv_num_seq              = v_num_seq_6
                               tt_ord_col.ttv_cod_col_demonst_ctbl = 'I'
                               tt_ord_col.ttv_des_tit_ctbl         = "PFixa" /*l_pfixa*/ 
                               v_num_seq_6                           = v_num_seq_6 + 10.
                    END.
                end.
                OPEN QUERY qr_ord_col
                    FOR EACH tt_ord_col.
            end.
        end.
    end.
END PROCEDURE. /* pi_rpt_open_item_padr_col_demonst_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_abre_conjto_prefer_padr
** Descricao.............: pi_abre_conjto_prefer_padr
** Criado por............: src370
** Criado em.............: 28/02/2001 14:38:40
** Alterado por..........: fut41420
** Alterado em...........: 09/01/2008 08:56:19
*****************************************************************************/
PROCEDURE pi_abre_conjto_prefer_padr:

    if input frame f_dlg_01_demonst_ctbl_fin_novo prefer_demonst_ctbl.cod_padr_col_demonst_ctbl <> v_cod_padr_col_demonst_ctbl then 
       assign v_num_entry = 1
              v_log_mudou_ord = no.

    if  v_ind_selec_demo_ctbl <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        if  not avail demonst_ctbl or
             not avail padr_col_demonst_ctbl
        then do:
             return.
        end.
        assign v_cod_demonst_ctbl          = demonst_ctbl.cod_demonst_ctbl
               v_cod_padr_col_demonst_ctbl = padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl
               v_cod_plano_cta_ctbl        = demonst_ctbl.cod_plano_cta_ctbl.
    end.
    else 
        assign v_cod_demonst_ctbl          = ""
               v_cod_padr_col_demonst_ctbl = "".

    find last prefer_demonst_ctbl exclusive-lock
         where prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
           and prefer_demonst_ctbl.cod_demonst_ctbl          = v_cod_demonst_ctbl
           and prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl no-error.
    if  not avail prefer_demonst_ctbl
    then do:
        create prefer_demonst_ctbl.
        assign prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
               prefer_demonst_ctbl.cod_demonst_ctbl          = v_cod_demonst_ctbl
               prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               prefer_demonst_ctbl.val_fator_div_demonst_ctbl = v_num_fator_div.

        &if '{&emsfin_dbtype}' <> 'progress' &then 
            VALIDATE prefer_demonst_ctbl.
        &endif
    end.

    /* --- Criaá∆o de Conjto de Preferàncias ---*/
    if  v_cod_padr_col_demonst_ctbl <> "" then do:
        conjto_block:
        for
            each col_demonst_ctbl no-lock
               where col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               break by col_demonst_ctbl.num_conjto_param_ctbl:
            if  first-of(col_demonst_ctbl.num_conjto_param_ctbl) then
                run pi_abre_conjto_prefer_padr_2 (Input col_demonst_ctbl.num_conjto_param_ctbl) /*pi_abre_conjto_prefer_padr_2*/.
        end.
    end.
    else
        run pi_abre_conjto_prefer_padr_2 (Input 1) /*pi_abre_conjto_prefer_padr_2*/.


    /* --- Verificar Conjuntos Prefer que n∆o s∆o mais utilizados ---*/
    if  v_ind_selec_demo_ctbl <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then do:
        conjto_block:
        for
            each conjto_prefer_demonst exclusive-lock
               where conjto_prefer_demonst.cod_usuario    = v_cod_usuar_corren
                 and conjto_prefer_demonst.cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl
                 and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl:
            find first col_demonst_ctbl no-lock
               where col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                 and col_demonst_ctbl.num_conjto_param_ctbl = conjto_prefer_demonst.num_conjto_param_ctbl no-error.
            if  not avail col_demonst_ctbl
            then do:
                &if '{&emsfin_version}' = '5.05' &then
                    find first tab_livre_emsfin exclusive-lock
                        where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                          and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                          and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                          and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
                    if avail tab_livre_emsfin then
                        delete tab_livre_emsfin.
                &endif

                delete conjto_prefer_demonst.
            end.
        end.
    end.
    else IF input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl <> '' then
    &if '{&emsfin_version}' = '5.05' &then
        assign prefer_demonst_ctbl.cod_livre_1 = input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl   + CHR(10) +
                                                 input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo    + CHR(10) +
                                                 input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo + CHR(10) +
                                                 input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ        + CHR(10) +
                                                 input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl    + CHR(10) +
                                                 input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto.
    &else
        assign prefer_demonst_ctbl.ind_selec_demo_ctbl   = input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl
               prefer_demonst_ctbl.ind_selec_tip_demo    = input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_tip_demo
               prefer_demonst_ctbl.ind_tip_sdo_ctbl_demo = input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_tip_sdo_ctbl_demo
               prefer_demonst_ctbl.cod_unid_organ_subst  = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_unid_organ
               prefer_demonst_ctbl.cod_plano_cta_ctbl    = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_cta_ctbl
               prefer_demonst_ctbl.cod_plano_ccusto      = input frame f_dlg_01_demonst_ctbl_fin_novo v_cod_plano_ccusto.
    &endif


    assign v_rec_prefer_demonst_ctbl = recid(prefer_demonst_ctbl)
           v_rec_demonst_ctbl        = recid(demonst_ctbl).
    open query qr_conjto_prefer_demonst for
        each conjto_prefer_demonst no-lock
           where conjto_prefer_demonst.cod_usuario               = prefer_demonst_ctbl.cod_usuario
             and conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
             and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl.
END PROCEDURE. /* pi_abre_conjto_prefer_padr */
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
** Procedure Interna.....: pi_retornar_cenar_ctbl_fisc
** Descricao.............: pi_retornar_cenar_ctbl_fisc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Rovina
** Alterado em...........: 13/11/1995 22:07:23
*****************************************************************************/
PROCEDURE pi_retornar_cenar_ctbl_fisc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first utiliz_cenar_ctbl no-lock
         where utiliz_cenar_ctbl.cod_empresa = p_cod_empresa
           and utiliz_cenar_ctbl.log_cenar_fisc = yes /*cl_retorna_fisc of utiliz_cenar_ctbl*/ no-error.
    if  avail utiliz_cenar_ctbl
    then do:
        if  p_dat_refer_ent = ? or (utiliz_cenar_ctbl.dat_inic_valid <= p_dat_refer_ent and
                                    utiliz_cenar_ctbl.dat_fim_valid >= p_dat_refer_ent)
        then do:
            assign p_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.
        end /* if */.
        else do:
            assign p_cod_cenar_ctbl = "".
        end /* else */.
    end /* if */.
    else do:
        assign p_cod_cenar_ctbl = "".
    end /* else */.
END PROCEDURE. /* pi_retornar_cenar_ctbl_fisc */
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
** Procedure Interna.....: pi_inicializa_prefer_demonst_ctbl
** Descricao.............: pi_inicializa_prefer_demonst_ctbl
** Criado por............: Dalpra
** Criado em.............: 23/07/2001 21:24:50
** Alterado por..........: fut41420
** Alterado em...........: 13/02/2008 15:20:21
*****************************************************************************/
PROCEDURE pi_inicializa_prefer_demonst_ctbl:

    assign v_cod_exerc_ctbl           = string(prefer_demonst_ctbl.cod_exerc_ctbl,"9999")
           v_num_period_ctbl          = prefer_demonst_ctbl.num_period_ctbl
           v_num_fator_div            = prefer_demonst_ctbl.val_fator_div_demonst_ctbl
           v_log_consid_apurac_restdo = prefer_demonst_ctbl.log_consid_apurac_restdo
           v_log_cta_ctbl_sint_2      = prefer_demonst_ctbl.log_acum_cta_ctbl_sint
           v_log_consid_sdo_zero      = prefer_demonst_ctbl.log_impr_cta_sem_sdo.

    &if '{&emsfin_version}' >= '5.06' &then
        assign v_log_impr_acum_zero = prefer_demonst_ctbl.log_impr_acum_zero.
    &else
        assign v_log_impr_acum_zero = prefer_demonst_ctbl.log_livre_1.
    &endif

    if v_log_funcao_impr_col_sem_sdo = yes then do:
    &if '{&emsfin_version}' >= '5.07' &then
        assign v_log_impr_col_sem_sdo = prefer_demonst_ctbl.log_impr_col_sem_sdo.
    &else
        assign v_log_impr_col_sem_sdo = (GetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10)) <> "no" /*l_no*/ ).
    &endif
    end.

    &if '{&emsfin_version}' >= '5.07' &then
        assign v_log_gera_dados_xml = prefer_demonst_ctbl.log_gera_dados_xml.
    &else
        if  prefer_demonst_ctbl.num_livre_1 = 1 then /* = yes*/
            assign v_log_gera_dados_xml = yes.
        else 
            assign v_log_gera_dados_xml = no.
    &endif    

    find demonst_ctbl no-lock
         where demonst_ctbl.cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl no-error.

    find padr_col_demonst_ctbl no-lock 
         where padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl no-error.

    find idioma no-lock
         where idioma.cod_idioma = prefer_demonst_ctbl.cod_idioma no-error.

    display prefer_demonst_ctbl.cod_demonst_ctbl
            prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
            idioma.cod_idioma when avail idioma
            demonst_ctbl.des_tit_ctbl when avail demonst_ctbl
            padr_col_demonst_ctbl.des_tit_ctbl when avail padr_col_demonst_ctbl
            v_cod_exerc_ctbl
            v_num_period_ctbl
            v_num_fator_div 
            v_log_consid_apurac_restdo
            v_log_cta_ctbl_sint_2
            v_log_consid_sdo_zero
            v_log_impr_acum_zero
            with frame f_dlg_01_demonst_ctbl_fin_novo.
    if  avail padr_col_demonst_ctbl then
        apply "leave" to prefer_demonst_ctbl.cod_padr_col_demonst_ctbl in frame f_dlg_01_demonst_ctbl_fin_novo.

END PROCEDURE. /* pi_inicializa_prefer_demonst_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_plano_cta_ctbl_prim
** Descricao.............: pi_retornar_plano_cta_ctbl_prim
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre17230
** Alterado em...........: 04/10/2000 17:10:08
*****************************************************************************/
PROCEDURE pi_retornar_plano_cta_ctbl_prim:

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
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def output param p_log_plano_cta_ctbl_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    calcula_block:
    for each plano_cta_unid_organ no-lock
     where plano_cta_unid_organ.cod_unid_organ = p_cod_unid_organ
       and plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio" /*cl_retorna_plano_cta_ctbl_prim of plano_cta_unid_organ*/:
        if  p_dat_refer_ent = ?
        or (plano_cta_unid_organ.dat_inic_valid <= p_dat_refer_ent
        and plano_cta_unid_organ.dat_fim_valid >= p_dat_refer_ent)
        then do:
            assign v_cod_return         = v_cod_return + "," + plano_cta_unid_organ.cod_plano_cta_ctbl
                   p_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.
        end /* if */.
    end /* for calcula_block */.

    if  num-entries(v_cod_return) = 2
    then do:
        assign p_log_plano_cta_ctbl_uni = yes.
    end /* if */.
    else do:
        assign p_log_plano_cta_ctbl_uni = no.
    end /* else */.
END PROCEDURE. /* pi_retornar_plano_cta_ctbl_prim */
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
** Procedure Interna.....: pi_abre_conjto_prefer_padr_2
** Descricao.............: pi_abre_conjto_prefer_padr_2
** Criado por............: Dalpra
** Criado em.............: 24/07/2001 20:27:18
** Alterado por..........: fut12232
** Alterado em...........: 10/05/2005 08:41:25
*****************************************************************************/
PROCEDURE pi_abre_conjto_prefer_padr_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_conjto_param_ctbl
        as integer
        format ">9"
        no-undo.


    /************************* Parameter Definition End *************************/

    find conjto_prefer_demonst exclusive-lock
       where conjto_prefer_demonst.cod_usuario               = v_cod_usuar_corren
         and conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
         and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
         and conjto_prefer_demonst.num_conjto_param_ctbl     = p_num_conjto_param_ctbl no-error.
    if  not avail conjto_prefer_demonst
    then do:
        &if '{&emsfin_version}' = '5.05' &then
            /* O c¢digo para 5.06 em diante esta na include @i(i_abre_conjto_prefer_padr_2) */
            find tab_livre_emsfin
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                and   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl)
                no-error.
            if  not avail tab_livre_emsfin
            then do:
                FIND FIRST tab_livre_emsfin
                WHERE tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                AND   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                AND   tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                AND   tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl) NO-LOCK NO-ERROR.
                if  not avail tab_livre_emsfin
                then do:
                    create tab_livre_emsfin.
                    assign tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                           tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                           tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                           tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl).
                end.  
                find last param_geral_ems no-lock no-error.
                if  avail param_geral_ems
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                             Input "Projeto" /*l_projeto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign tab_livre_emsfin.cod_livre_1 = v_cod_initial + chr(10) +
                                                          v_cod_final   + chr(10) +
                                                          fill("#",length(param_geral_ems.cod_format_proj_financ)) + chr(10) +
                                                          fill("#",length(param_geral_ems.cod_format_proj_financ)).
                end.

                find first compos_demonst_ctbl no-lock
                    where  compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                      and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
                if  avail compos_demonst_ctbl
                then do:
                    find first plano_ccusto no-lock
                        where plano_ccusto.cod_empresa = v_cod_empres_usuar
                        and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                    if  avail plano_ccusto
                    then do:
                        run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                                 Input "CCusto" /*l_ccusto*/,
                                                                 output v_cod_initial,
                                                                 output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                        assign tab_livre_emsfin.cod_livre_2 = v_cod_initial + chr(10) +
                                                              v_cod_final   + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)) + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)).
                    end.
                    else do:
                        assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                              "" + chr(10) +
                                                              "" + chr(10) +
                                                              "".
                    end.
                end.
                else do:
                    assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                          "" + chr(10) +
                                                          "" + chr(10) +
                                                          "".
                end.    
                &if '{&emsfin_dbtype}' <> 'progress' &then 
                    VALIDATE tab_livre_emsfin.
                &endif
            end.
        &endif.

        create conjto_prefer_demonst.
        assign conjto_prefer_demonst.cod_usuario      = v_cod_usuar_corren
               conjto_prefer_demonst.cod_demonst_ctbl = v_cod_demonst_ctbl
               conjto_prefer_demonst.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
               conjto_prefer_demonst.num_conjto_param_ctbl     = p_num_conjto_param_ctbl.
        run pi_retornar_cenar_ctbl_fisc (Input v_cod_empres_usuar,
                                         Input today,
                                         output v_cod_cenar_ctbl) /*pi_retornar_cenar_ctbl_fisc*/.
        assign conjto_prefer_demonst.cod_cenar_ctbl = v_cod_cenar_ctbl.

        &if '{&emsfin_version}' = '5.05' &then
          /* * Inicializa campo livre caso necess†rio **/
          if  num-entries(conjto_prefer_demonst.cod_livre_1, CHR(10)) < 4 then
              ASSIGN conjto_prefer_demonst.cod_livre_1 = FILL(CHR(10),3).

          /* * Inicializa campos do cen†rio e data da 2¶ faixa do Comparativo **/
          if  v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Comparativo" /*l_comparativo*/ 
          then do:
             IF  entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) /* CENµRIO 2 COMPARATIVO */ = "" THEN
                 ASSIGN entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) = v_cod_cenar_ctbl.
             IF  entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)) /* DATA 2 COMPARATIVO */ = "" THEN
                 ASSIGN entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)) = STRING(conjto_prefer_demonst.dat_livre_1).
          END.
        &else
          /* * Inicializa campos do cen†rio e data da 2¶ faixa do Comparativo **/
          if  v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Comparativo" /*l_comparativo*/ 
          then do:
             IF  conjto_prefer_demonst.cod_cenar_ctbl_2 /* CENµRIO 2 COMPARATIVO */ = "" THEN
                 ASSIGN conjto_prefer_demonst.cod_cenar_ctbl_2 = v_cod_cenar_ctbl.
             IF  conjto_prefer_demonst.cod_exerc_period_2 /* DATA 2 COMPARATIVO */ = "" THEN
                 ASSIGN conjto_prefer_demonst.cod_exerc_period_2 = conjto_prefer_demonst.cod_exerc_period_1.
          END.
        &endif

        find emsuni.pais no-lock
             where pais.cod_pais = v_cod_pais_empres_usuar /*cl_cod_pais_corrente of pais*/ no-error.
        if  avail pais
        then do:
            assign conjto_prefer_demonst.cod_finalid_econ = pais.cod_finalid_econ_pais
                   conjto_prefer_demonst.cod_finalid_econ_apres = pais.cod_finalid_econ_pais
                   conjto_prefer_demonst.val_cotac_indic_econ = 1.
        end.
        assign conjto_prefer_demonst.dat_cotac_indic_econ = today.

        if  v_ind_selec_demo_ctbl:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Consultas de Saldo" /*l_consultas_de_saldo*/  then
            assign conjto_prefer_demonst.cod_unid_organ_inic = ""
                   conjto_prefer_demonst.cod_unid_organ_fim  = "ZZZ".
        else
            assign conjto_prefer_demonst.cod_unid_organ_inic = v_cod_unid_organ
                   conjto_prefer_demonst.cod_unid_organ_fim  = v_cod_unid_organ.

        assign conjto_prefer_demonst.cod_estab_inic = ""
               conjto_prefer_demonst.cod_estab_fim  = "ZZZ"
               conjto_prefer_demonst.cod_unid_negoc_inic = ""
               conjto_prefer_demonst.cod_unid_negoc_fim  = "ZZZ".


        /* Begin_Include: i_abre_conjto_prefer_padr_2 */
        find plano_cta_ctbl 
            where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-lock no-error.
        if  avail plano_cta_ctbl
        then do:
            run pi_retornar_valores_iniciais_prefer (Input plano_cta_ctbl.cod_format_cta_ctbl,
                                                     Input "Cta Ctbl" /*l_cta_ctbl*/,
                                                     output v_cod_initial,
                                                     output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
            assign conjto_prefer_demonst.cod_cta_ctbl_inic         = v_cod_initial
                   conjto_prefer_demonst.cod_cta_ctbl_fim          = v_cod_final
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl))
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_excec = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl)).
        end.

        &if '{&emsfin_version}' > '5.05' &then

        find last param_geral_ems no-lock no-error.
        if  avail param_geral_ems
        then do:
            run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                     Input "Projeto" /*l_projeto*/,
                                                     output v_cod_initial,
                                                     output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.

            assign conjto_prefer_demonst.cod_proj_financ_inicial = v_cod_initial
                   conjto_prefer_demonst.cod_proj_financ_fim     = v_cod_final
                   conjto_prefer_demonst.cod_proj_financ_pfixa = fill("#",length(param_geral_ems.cod_format_proj_financ))
                   conjto_prefer_demonst.cod_proj_financ_excec = fill("#",length(param_geral_ems.cod_format_proj_financ)).
        end.
        find first compos_demonst_ctbl no-lock
            where  compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
              and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
        if  avail compos_demonst_ctbl
        or v_cod_plano_ccusto:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo <> ""
        then do:
            if  avail compos_demonst_ctbl then
               find first plano_ccusto no-lock
                    where plano_ccusto.cod_empresa      = v_cod_empres_usuar
                    and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
            else
               find first plano_ccusto no-lock
                    where plano_ccusto.cod_empresa      = v_cod_empres_usuar
                    and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto:SCREEN-VALUE in frame f_dlg_01_demonst_ctbl_fin_novo no-error.    
            if  avail plano_ccusto
            then do:
                run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                         Input "CCusto" /*l_ccusto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                assign conjto_prefer_demonst.cod_ccusto_inic  = v_cod_initial
                       conjto_prefer_demonst.cod_ccusto_fim   = v_cod_final
                       conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                       conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
            end.
        end.
        &endif

        /* End_Include: i_abre_conjto_prefer_padr_2 */


        assign conjto_prefer_demonst.cod_unid_organ_prefer_inic  = ""
               conjto_prefer_demonst.cod_unid_organ_prefer_fim   = "ZZZ".
    end.
    else do:
        &if '{&emsfin_version}' = '5.05' &then
          /* * Inicializa campo livre caso necess†rio **/
          if  num-entries(conjto_prefer_demonst.cod_livre_1, CHR(10)) < 4 then
              ASSIGN conjto_prefer_demonst.cod_livre_1 = FILL(CHR(10),3).

          /* * Inicializa campos do cen†rio e data da 2¶ faixa do Comparativo **/
          if  v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Comparativo" /*l_comparativo*/ 
          then do:
             IF  entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) /* CENµRIO 2 COMPARATIVO */ = "" THEN
                 ASSIGN entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) = conjto_prefer_demonst.cod_cenar_ctbl.
             IF  entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)) /* DATA 2 COMPARATIVO */ = "" THEN
                 ASSIGN entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)) = STRING(conjto_prefer_demonst.dat_livre_1).
          END.
        &else
          /* * Inicializa campos do cen†rio e data da 2¶ faixa do Comparativo **/
          if  v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo = "Comparativo" /*l_comparativo*/ 
          then do:
             IF  conjto_prefer_demonst.cod_cenar_ctbl_2 /* CENµRIO 2 COMPARATIVO */ = "" THEN
                 ASSIGN conjto_prefer_demonst.cod_cenar_ctbl_2 = conjto_prefer_demonst.cod_cenar_ctbl.
             IF  conjto_prefer_demonst.cod_exerc_period_2 /* DATA 2 COMPARATIVO */ = "" THEN
                 ASSIGN conjto_prefer_demonst.cod_exerc_period_2 = conjto_prefer_demonst.cod_exerc_period_1.
          END.
        &endif


        /* * Zera campos de Oráamento quando selecionar outra opá∆o de consulta **/
        /* FUT1082 - Se for Demonstrativo Cont†bil n∆o deve limpar os campos referentes ao Oráamento, porque as informaá‰es digitadas */
        /* pelo usu†rio ser∆o eliminadas, foráando a digitaá∆o das mesmas novamente.*/

        if  input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl <> "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/  THEN DO:
            if  v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "Oráamentos" /*l_orcamentos*/ 
            and v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> "" /*l_null*/ 
            and v_ind_tip_sdo_ctbl_demo:screen-value in frame f_dlg_01_demonst_ctbl_fin_novo <> ?
            then do:
                assign conjto_prefer_demonst.cod_cenar_orctario  = ""
                       conjto_prefer_demonst.cod_vers_orcto_ctbl = "".
                &if '{&emsfin_version}' > '5.05' &then
                    assign conjto_prefer_demonst.cod_unid_orctaria  = ""
                           conjto_prefer_demonst.num_seq_orcto_ctbl = 0.
                &else
                    assign conjto_prefer_demonst.cod_livre_1 = ""  + chr(10) +
                                                               "0" + chr(10) +
                                                               entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) + chr(10) +
                                                               entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)).
                &endif
            END.
        end.

        /* * N∆o Ç necess†rio passar por esta l¢gica p/ consultas **/
        IF  INPUT FRAME f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl =  "Consultas de Saldo" /*l_consultas_de_saldo*/ 
            THEN RETURN.

        /* --- Inicializa Campos do Ccusto, caso o usu†rio tenha alterado a composiá∆o do demonstrativo
              informando Ccusto ---*/

        /* Begin_Include: i_abre_conjto_prefer_padr */
        &if '{&emsfin_version}' = '5.05' &then
            find tab_livre_emsfin exclusive-lock
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                and   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + padr_col_demonst_ctbl.cod_padr_col_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_1_idx_tab = demonst_ctbl.cod_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_2_idx_tab = string(col_demonst_ctbl.num_conjto_param_ctbl)
                no-error.
            if  avail tab_livre_emsfin
            then do:
               if tab_livre_emsfin.cod_livre_2 = "" then do:
                   assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                         "" + chr(10) +
                                                         "" + chr(10) +
                                                         "".
               end.
               find first compos_demonst_ctbl no-lock
                    where  compos_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl
                    and    compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
               if  avail compos_demonst_ctbl
               and entry(2,tab_livre_emsfin.cod_livre_2,chr(10)) = ""
               then do:
                find first plano_ccusto no-lock
                    where  plano_ccusto.cod_empresa = v_cod_empres_usuar
                    and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                  if  avail plano_ccusto
                  then do:
                      run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                               Input "CCusto" /*l_ccusto*/,
                                                               output v_cod_initial,
                                                               output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                      assign tab_livre_emsfin.cod_livre_2 = v_cod_initial + chr(10) +
                                                          v_cod_final   + chr(10) +
                                                          fill("#",length(plano_ccusto.cod_format_ccusto)) + chr(10) +
                                                          fill("#",length(plano_ccusto.cod_format_ccusto)).
                  end.
               end.
            end.
        &else
            find first compos_demonst_ctbl no-lock
                where  compos_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl
                  and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl 
            and conjto_prefer_demonst.cod_ccusto_fim = ""
            then do:
                find first plano_ccusto no-lock
                    where  plano_ccusto.cod_empresa = v_cod_empres_usuar
                    and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                if  avail plano_ccusto
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                             Input "CCusto" /*l_ccusto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign conjto_prefer_demonst.cod_ccusto_inic = v_cod_initial
                           conjto_prefer_demonst.cod_ccusto_fim  = v_cod_final
                           conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                           conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
                end.
            end.
        &endif
        /* End_Include: i_abre_conjto_prefer_padr */

    end.

    &if '{&emsfin_dbtype}' <> 'progress' &then 
        VALIDATE conjto_prefer_demonst.
    &endif

    &if '{&emsfin_version}' = '5.05' &then
        if  num-entries(conjto_prefer_demonst.cod_livre_1, CHR(10)) = 4 then  
            assign v_cod_entry_3 = entry(3,conjto_prefer_demonst.cod_livre_1,chr(10))
                   v_cod_entry_4 = entry(4,conjto_prefer_demonst.cod_livre_1,CHR(10)).
        else
            assign v_cod_entry_3 = ''
                   v_cod_entry_4 = ''.
    &else
        assign v_cod_entry_3 = conjto_prefer_demonst.cod_cenar_ctbl_2
               v_cod_entry_4 = conjto_prefer_demonst.cod_exerc_period_2.
    &endif.    

    /* --- Se n∆o encontrar nenhuma coluna indicando que origem Ç oráamento zera os campos referentes ao oráamento ---*/
    /* FUT1082 - Se for Demonstrativo Cont†bil n∆o deve limpar os campos referentes ao Oráamento, porque as informaá‰es digitadas */
    /* pelo usu†rio ser∆o eliminadas, foráando a digitaá∆o das mesmas novamente.*/

    if  input frame f_dlg_01_demonst_ctbl_fin_novo v_ind_selec_demo_ctbl <> "Demonstrativo Cont†bil" /*l_demonstrativo_contabil*/  THEN DO:
        if not can-find(first col_demonst_ctbl
            where col_demonst_ctbl.cod_padr_col_demonst_ctbl = v_cod_padr_col_demonst_ctbl
            and   col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_oráamento*/ ) then do:
            assign conjto_prefer_demonst.cod_cenar_orctario  = ""
                   conjto_prefer_demonst.cod_vers_orcto_ctbl = "".
            &if '{&emsfin_version}' > '5.05' &then
                 assign conjto_prefer_demonst.cod_unid_orctaria  = ""
                        conjto_prefer_demonst.num_seq_orcto_ctbl = 0.
            &else
                 assign conjto_prefer_demonst.cod_livre_1 = ""            + chr(10) +
                                                            "0"           + chr(10) +
                                                            v_cod_entry_3 + chr(10) +
                                                            v_cod_entry_4.
            &endif
        end.
    end.

    /* * Atualiza campos parte fixa e excess∆o do conjto prefer. na tab_livre **/
    &if '{&emsfin_version}' <= '5.05' &then
        IF conjto_prefer_demonst.cod_livre_1 = "" THEN
           assign conjto_prefer_demonst.cod_livre_1 = "" + chr(10) + "0".

        if  not can-find(first tab_livre_emsfin no-lock
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  and tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl))
        then do:
            create tab_livre_emsfin.
            assign tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + v_cod_padr_col_demonst_ctbl
                   tab_livre_emsfin.cod_compon_1_idx_tab = v_cod_demonst_ctbl
                   tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl).
            find last param_geral_ems no-lock no-error.
            if  avail param_geral_ems
            then do:
                run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                         Input "Projeto" /*l_projeto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                assign tab_livre_emsfin.cod_livre_1 = v_cod_initial + chr(10) +
                                                      v_cod_final   + chr(10) +
                                                      fill("#",length(param_geral_ems.cod_format_proj_financ)) + chr(10) +
                                                      fill("#",length(param_geral_ems.cod_format_proj_financ)).
            end.

            find first compos_demonst_ctbl no-lock
                where  compos_demonst_ctbl.cod_demonst_ctbl = v_cod_demonst_ctbl
                  and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl
            then do:
                find first plano_ccusto no-lock
                    where plano_ccusto.cod_empresa = v_cod_empres_usuar
                    and   plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                if  avail plano_ccusto
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                             Input "CCusto" /*l_ccusto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign tab_livre_emsfin.cod_livre_2 = v_cod_initial + chr(10) +
                                                          v_cod_final   + chr(10) +
                                                          fill("#",length(plano_ccusto.cod_format_ccusto)) + chr(10) +
                                                          fill("#",length(plano_ccusto.cod_format_ccusto)).
                end.
                else do:
                    assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                          "" + chr(10) +
                                                          "" + chr(10) +
                                                          "".
                end.
            end.
            else do:
                assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                      "" + chr(10) +
                                                      "" + chr(10) +
                                                      "".
            end.
            &if '{&emsfin_dbtype}' <> 'progress' &then
                VALIDATE tab_livre_emsfin.
            &endif
        end.
    &endif.

END PROCEDURE. /* pi_abre_conjto_prefer_padr_2 */
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
** Procedure Interna.....: pi_exec_program_epc_FIN
** Descricao.............: pi_exec_program_epc_FIN
** Criado por............: src388
** Criado em.............: 09/09/2003 10:48:55
** Alterado por..........: fut1309
** Alterado em...........: 15/02/2006 09:44:03
*****************************************************************************/
PROCEDURE pi_exec_program_epc_FIN:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_event
        as character
        format "x(100)"
        no-undo.
    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_log_return_epc
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* *******************************************************************************************
    ** Objetivo..............: Substituir o c¢digo gerado pela include i_exec_program_epc,
    **                         muitas vezes repetido, com o intuito de evitar estouro de segmento.
    **
    ** Utilizaá∆o............: A utilizaá∆o desta procedure funciona exatamente como a include
    **                         anteriormente utilizada para este fim, para chamar ela deve ser 
    **                         includa a include i_executa_pi_epc_fin no programa, que ira executar 
    **                         esta pi e fazer tratamento para os retornos. Deve ser declarada a 
    **                         variavel v_log_return_epc (caso o parametro ela seja verdade, Ç 
    **                         porque a EPC retornou "NOK". 
    **
    **                         @i(i_executa_pi_epc_fin &event='INITIALIZE' &return='NO')
    **
    **                         Para se ter uma idÇia de como se usa, favor olhar o fonte do apb008za.p
    **
    **
    *********************************************************************************************/

    assign p_log_return_epc = no.
    /* ix_iz1_fnc_prefer_demonst_ctbl */


    /* Begin_Include: i_exec_program_epc_pi_fin */
    if  v_nom_prog_upc <> ''    
    or  v_nom_prog_appc <> ''
    or  v_nom_prog_dpc <> '' then do:
        &if 'prefer_demonst_ctbl' <> '' &then
            assign v_rec_table_epc = recid(prefer_demonst_ctbl)
                   v_nom_table_epc = 'prefer_demonst_ctbl'.
        &else
            assign v_rec_table_epc = ?
                   v_nom_table_epc = "".
        &endif
    end.
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_upc) (input p_cod_event,
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    if  v_nom_prog_appc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_appc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_dpc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.
    &endif
    &endif

    /* End_Include: i_exec_program_epc_pi_fin */


    /* ix_iz2_fnc_prefer_demonst_ctbl */
END PROCEDURE. /* pi_exec_program_epc_FIN */


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
/**********************  End of fnc_prefer_demonst_ctbl *********************/
