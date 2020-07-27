/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: bas_cta_ctbl_razao
** Descricao.............: Consulta Raz∆o Conta Cont†bil
** Versao................:  1.00.00.001
** Procedimento..........: con_razao_cta_ctbl
** Nome Externo..........: prgfin/fgl/ESCF0208.p
** Data Geracao..........: 25/03/2015 - 16:13:58
** Criado por............: Henke
** Criado em.............: 20/12/1995 11:43:15
** Alterado por..........: fut12196
** Alterado em...........: 01/11/2013 15:40:32
** Gerado por............: fut41061
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.001[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */
{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bas_cta_ctbl_razao FGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=3":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_ccusto no-undo like ccusto
    field ttv_rec_ccusto                   as recid format ">>>>>>9" initial ?
    field ttv_cod_format_ccusto            as character format "x(11)" initial "99999" label "Formato CCusto" column-label "Formato CCusto"
    index tt_ccusto_id                     is primary unique
          cod_empresa                      ascending
          cod_plano_ccusto                 ascending
          cod_ccusto                       ascending
    .

def temp-table tt_ccusto_sem_permissao no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    index tt_ccusto_id                     is primary unique
          tta_cod_empresa                  ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    .

def temp-table tt_erro_relatorio_razao no-undo
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequància Lanáto" column-label "Sequància Lanáto"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_                              is primary
          tta_num_lote_ctbl                ascending
          tta_num_lancto_ctbl              ascending
          tta_num_seq_lancto_ctbl          ascending
    .

def new shared temp-table tt_estab_unid_negoc_select         like estab_unid_negoc
    index tt_estab_unid_negoc_select_id    is primary unique
          cod_estab                        ascending
          cod_unid_negoc                   ascending
    .

def temp-table tt_item_lancto_ctbl_razao no-undo
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequància Lanáto" column-label "Sequància Lanáto"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequància CPartida" column-label "Sequància CP"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont†bil" column-label "Hist¢rico Cont†bil"
    field ttv_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "DÇbitos" column-label "DÇbitos"
    field ttv_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "CrÇditos" column-label "CrÇditos"
    field ttv_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Final" column-label "Saldo Final"
    field ttv_cod_cta_ctbl_cpart           as character format "x(20)"
    field ttv_cod_ccusto_cpart             as character format "x(8)"
    index tt_item_id                       is primary unique
          tta_dat_lancto_ctbl              ascending
          tta_num_lote_ctbl                ascending
          tta_num_lancto_ctbl              ascending
          tta_num_seq_lancto_ctbl          ascending
    .

def temp-table tt_plano_cta_ctbl no-undo like plano_cta_ctbl
    field ttv_rec_plano_cta_ctbl           as recid format ">>>>>>9"
    index tt_plano_cta_ctbl_id             is primary unique
          cod_plano_cta_ctbl               ascending
    index tt_rec_plano_cta_ctbl            is unique
          ttv_rec_plano_cta_ctbl           ascending
    .

def new shared temp-table tt_sdo_ctbl        
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    index tt_id                            is primary unique
          tta_dat_sdo_ctbl                 ascending
    .

def new shared temp-table tt_unid_negoc         like emscad.unid_negoc
    field ttv_rec_unid_negoc               as recid format ">>>>>>9" initial ?
    .

def new shared temp-table tt_unid_organ         like emscad.unid_organ
    field ttv_rec_unid_organ               as recid format ">>>>>>9" initial ?
    .

def temp-table tt_vers_orcto_ctbl no-undo like vers_orcto_ctbl
    field ttv_rec_vers_orcto_ctbl          as recid format ">>>>>>9" initial ?
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    .



/********************** Temporary Table Definition End **********************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign row                  = 01.00
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

&if "{&emsuni_version}" >= "1.00" &then
def buffer b_estrut_unid_organ
    for emscad.estrut_unid_organ.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_item_lancto_ctbl
    for item_lancto_ctbl.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def stream s_str_rp.


/*************************** Stream Definition End **************************/

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
def var v_cod_cenar_ctbl
    as character
    format "x(8)":U
    label "Cen†rio Cont†bil"
    column-label "Cen†rio Cont†bil"
    no-undo.
def new global shared var v_cod_cenar_ctbl_ini
    as character
    format "x(8)":U
    label "Inicial"
    column-label "Inicial"
    no-undo.
def var v_cod_cta_ctbl_cpart
    as character
    format "x(20)":U
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
&IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
def new global shared var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
def new global shared var v_cod_estab_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
def new global shared var v_cod_estab_ini
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
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
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def var v_cod_format_cta_ctbl
    as character
    format "x(20)":U
    label "Formato Cta Cont†bil"
    column-label "Formato Conta"
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
def var v_cod_moed_finalid
    as character
    format "x(10)":U
    label "Moeda/Finalidade"
    column-label "Mo/Finalid"
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
def new global shared var v_cod_unid_organizacional
    as character
    format "x(3)":U
    no-undo.
&IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
def new global shared var v_cod_unid_organ_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "Final"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
def new global shared var v_cod_unid_organ_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "Final"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
def new global shared var v_cod_unid_organ_ini
    as character
    format "x(3)":U
    label "UO Inicial"
    column-label "Unid Organizacional"
    no-undo.
&ENDIF
&IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
def new global shared var v_cod_unid_organ_ini
    as Character
    format "x(5)":U
    label "UO Inicial"
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
def new global shared var v_dat_cotac_indic_econ
    as date
    format "99/99/9999":U
    initial today
    label "Data Cotaá∆o"
    column-label "Data Cotaá∆o"
    no-undo.
def new shared var v_dat_fim_period_ctbl
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
def var v_dat_inic_period_ctbl
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "In°cio"
    column-label "In°cio"
    no-undo.
def new shared var v_dat_inic_period_ctbl_pri
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "In°cio Per°odo"
    no-undo.
def var v_dat_inic_valid
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "In°cio Validade"
    column-label "Inicio Validade"
    no-undo.
def new global shared var v_des_histor
    as character
    format "x(40)":U
    label "ContÇm"
    column-label "Hist¢rico"
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
def var v_des_permis_ccusto
    as character
    format "x(40)":U
    no-undo.
def var v_des_unid_negoc_faixa
    as character
    format "x(200)":U
    no-undo.
def new global shared var v_hdl_func_padr_glob
    as Handle
    format ">>>>>>9":U
    label "Funá‰es Pad Glob"
    column-label "Funá‰es Pad Glob"
    no-undo.
def var v_log_alter
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_changed
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_changed_finalid
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
def new global shared var v_log_cta_restdo_acum
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_estab_unid_negoc
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Inclui Unid Neg¢cio"
    column-label "Inclui Unid Neg¢cio"
    no-undo.
def var v_log_funcao_histor_estrut
    as logical
    format "Sim/N∆o"
    initial Yes
    no-undo.
def var v_log_funcao_lista_cta_cpart
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_plano_cta_ctbl_uni
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_restric_estab
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Usa Segur Estab"
    column-label "Usa Segur Estab"
    no-undo.
def var v_log_valid_cenar
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_vers_orcto_ctbl
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Inclui Vers∆o Oráto"
    column-label "Inclui Vers∆o Oráto"
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
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
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
def new global shared var v_rec_cta_ctbl
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
def new global shared var v_rec_item_lancto_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_lancto_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
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
def new global shared var v_rec_unid_organ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_unid_organ_sdo
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new shared var v_val_sdo_ctbl_cr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "CrÇditos"
    column-label "CrÇditos"
    no-undo.
def new shared var v_val_sdo_ctbl_db
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "DÇbitos"
    column-label "DÇbitos"
    no-undo.
def new shared var v_val_sdo_ctbl_fim
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Final"
    column-label "Saldo Final"
    no-undo.
def new shared var v_val_sdo_ctbl_inic_ant
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Sdo Inicial Ant"
    column-label "Sdo Inicial Ant"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_cod_indic_econ_apres           as character       no-undo. /*local*/
def var v_cod_indic_econ_base            as character       no-undo. /*local*/
def var v_cod_return                     as character       no-undo. /*local*/
def var v_cod_unid_organ                 as character       no-undo. /*local*/
def var v_des_plano_cta_ctbl             as character       no-undo. /*local*/
def var v_log_changed_unid_organ         as logical         no-undo. /*local*/
def var v_log_return                     as logical         no-undo. /*local*/
def var v_num_primario                   as integer         no-undo. /*local*/
def var v_rec_unid_organ_aux             as recid           no-undo. /*local*/
def var v_val_cotac_indic_econ           as decimal         no-undo. /*local*/


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
    menu-item mi_fir               label "Primeiro"        accelerator "ALT-HOME"
    menu-item mi_pre               label "Anterior"        accelerator "ALT-CURSOR-LEFT"
    menu-item mi_nex               label "P&r¢ximo"        accelerator "ALT-CURSOR-RIGHT"
    menu-item mi_las               label "Èltimo"          accelerator "ALT-END"
    RULE
    menu-item mi_ran               label "Faixa"
    menu-item mi_fil               label "F&iltro"
    RULE
    menu-item mi_plano_contas      label "P&lano Contas"
    RULE
    menu-item mi_det               label "Detalhe"         accelerator "ALT-D"
    menu-item mi_razao_contabil    label "Ra&z∆o Cont†bil"
    RULE
    menu-item mi_imprime           label "Imprime"
    RULE
    menu-item mi_alternativa       label "Alternativa"
    RULE
    menu-item mi_exi               label "Sa°da".

def sub-menu  mi_hel
    menu-item mi_contents          label "Conte£do"
    RULE
    menu-item mi_about             label "Sobre".

def menu      m_10_cta_ctbl_razao   menubar
    sub-menu  mi_table              label "Tabela"
    sub-menu  mi_hel                label "Ajuda".



/**************************** Menu Definition End ***************************/

/************************** Query Definition Begin **************************/

def query qr_bas_cta_ctbl_razao
    for tt_item_lancto_ctbl_razao
    scrolling.
def query qr_bas_cta_ctbl_razao_1
    for tt_item_lancto_ctbl_razao
    scrolling.


/*************************** Query Definition End ***************************/

/************************** Browse Definition Begin *************************/

def browse br_bas_cta_ctbl_razao query qr_bas_cta_ctbl_razao display 
    tt_item_lancto_ctbl_razao.tta_dat_lancto_ctbl
        column-label "Data"
    tt_item_lancto_ctbl_razao.tta_num_lote_ctbl
        column-label "Lote"
    tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl
        column-label "Lanáto"
    tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl format ">>>>>>9" column-label "  Seq"
    tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl_cpart
        column-label "Seq CP"
    tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db
        column-label "DÇbitos"
    abs(tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr) format ">>,>>>,>>>,>>9.99" column-label "CrÇdito"
    tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_fim
        column-label "Saldo Final"
    tt_item_lancto_ctbl_razao.tta_des_histor_lancto_ctbl
        column-label "Hist¢rico Cont†bil"
    with no-box separators single 
         size 86.00 by 09.08
         font 2
         bgcolor 15.
def browse br_bas_cta_ctbl_razao_1 query qr_bas_cta_ctbl_razao_1 display 
    tt_item_lancto_ctbl_razao.tta_dat_lancto_ctbl
        column-label "Data"
    tt_item_lancto_ctbl_razao.tta_num_lote_ctbl
        column-label "Lote"
    tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl
        column-label "Lanáto"
    tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl format ">>>>>>9" column-label "  Seq"
    tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db
        column-label "DÇbitos"
    abs(tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr) format ">>,>>>,>>>,>>9.99" column-label "CrÇdito"
    tt_item_lancto_ctbl_razao.ttv_cod_cta_ctbl_cpart
    tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_fim
        column-label "Saldo Final"
    tt_item_lancto_ctbl_razao.tta_des_histor_lancto_ctbl
        column-label "Hist¢rico Cont†bil"
    with no-box separators single 
         size 86.00 by 09.08
         font 2
         bgcolor 15.


/*************************** Browse Definition End **************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_alter
    label "Alternativa"
    tooltip "Alternativa/Cta Ctbl"
&if "{&window-system}" <> "TTY" &then
    image file "image/im-alter.bmp"
&endif
    size 1 by 1.
def button bt_det1
    label "Det"
    tooltip "Detalhe"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-det"
    image-insensitive file "image/ii-det"
&endif
    size 1 by 1.
def button bt_ent
    label "Loc"
    tooltip "Entra"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
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
def button bt_hel1
    label " ?"
    tooltip "Ajuda"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-hel"
    image-insensitive file "image/ii-hel"
&endif
    size 1 by 1.
def button bt_las
    label ">>"
    tooltip "Èltima Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-las"
    image-insensitive file "image/ii-las"
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
def button bt_plano_cta_ctbl
    label "Plano..."
    tooltip "Plano de Contas"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-plano.bmp"
    image-insensitive file "image/ii-plano"
&endif
    size 1 by 1.
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
def button bt_ran2
    label "Faixa"
    tooltip "Faixa"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
&endif
    size 1 by 1.
def button bt_razao
    label "Raz∆o"
    tooltip "Raz∆o"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-livro.bmp"
    image-insensitive file "image/ii-livro.bmp"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_96444
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_98619
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_225941
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_cta_ctbl_razao
    rt_001
         at row 14.42 col 02.00
    " Saldos " view-as text
         at row 14.12 col 04.00
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    bt_fir
         at row 01.08 col 01.14 font ?
         help "Primeira Ocorrància da Tabela"
    bt_pre1
         at row 01.08 col 05.14 font ?
         help "Ocorrància Anterior da Tabela"
    bt_nex1
         at row 01.08 col 09.14 font ?
         help "Pr¢xima Ocorrància da Tabela"
    bt_las
         at row 01.08 col 13.14 font ?
         help "Èltima Ocorrància da Tabela"
    bt_ran2
         at row 01.08 col 18.14 font ?
         help "Faixa"
    bt_fil2
         at row 01.08 col 22.14 font ?
         help "Filtro"
    bt_plano_cta_ctbl
         at row 01.08 col 27.14 font ?
         help "Plano de Contas"
    bt_det1
         at row 01.08 col 32.14 font ?
         help "Detalhe"
    bt_razao
         at row 01.08 col 36.14 font ?
         help "Raz∆o"
    bt_pri
         at row 01.08 col 41.14 font ?
         help "Imprime"
    bt_alter
         at row 01.08 col 46.14 font ?
         help "Alternativa/Cta Ctbl"
    bt_exi
         at row 01.08 col 80.86 font ?
         help "Sa°da"
    bt_hel1
         at row 01.08 col 84.86 font ?
         help "Ajuda"
    cenar_ctbl.cod_cenar_ctbl
         at row 02.75 col 14.00 colon-aligned label "Cen†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_98619
         at row 02.75 col 25.14
    cenar_ctbl.des_cenar_ctbl
         at row 02.71 col 29.86 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    cta_ctbl.cod_cta_ctbl
         at row 03.71 col 14.00 colon-aligned label "Conta"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_96444
         at row 03.71 col 37.14
    cta_ctbl.cod_altern_cta_ctbl
         at row 03.71 col 14.00 colon-aligned label "Alternativa"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_225941
         at row 03.71 col 29.14
    br_bas_cta_ctbl_razao_1
         at row 05.00 col 02.00
         help "Itens de Lanáamento Cont†bil no Per°odo"
    bt_ent
         at row 03.71 col 41.14 font ?
         help "Entra"
    cta_ctbl.des_tit_ctbl
         at row 03.71 col 45.86 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    br_bas_cta_ctbl_razao
         at row 05.00 col 02.00
         help "Itens de Lanáamento Cont†bil no Per°odo"
    v_val_sdo_ctbl_db
         at row 14.63 col 37.00 colon-aligned label "DB"
         help "Saldo Cont†bil Ö DÇbito"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_ctbl_inic_ant
         at row 15.13 col 10.00 colon-aligned label "Inicial"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_ctbl_cr
         at row 15.63 col 37.00 colon-aligned label "CR"
         help "Saldo Cont†bil Ö CrÇdito"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_ctbl_fim
         at row 15.13 col 64.00 colon-aligned label "Final"
         help "Saldo Cont†bil Final"
         view-as fill-in
         size-chars 19.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 88.29 by 16.88
         at row 01.08 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Consulta Raz∆o Conta Cont†bil".
    /* adjust size of objects in this frame */
    assign bt_alter:width-chars           in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_alter:height-chars          in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_det1:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_det1:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_ent:width-chars             in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_ent:height-chars            in frame f_bas_10_cta_ctbl_razao = 00.88
           bt_exi:width-chars             in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_exi:height-chars            in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_fil2:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_fil2:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_fir:width-chars             in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_fir:height-chars            in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_hel1:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_hel1:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_las:width-chars             in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_las:height-chars            in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_nex1:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_nex1:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_plano_cta_ctbl:width-chars  in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_plano_cta_ctbl:height-chars in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_pre1:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_pre1:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_pri:width-chars             in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_pri:height-chars            in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_ran2:width-chars            in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_ran2:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.13
           bt_razao:width-chars           in frame f_bas_10_cta_ctbl_razao = 04.00
           bt_razao:height-chars          in frame f_bas_10_cta_ctbl_razao = 01.13
           rt_001:width-chars             in frame f_bas_10_cta_ctbl_razao = 86.00
           rt_001:height-chars            in frame f_bas_10_cta_ctbl_razao = 02.33
           rt_mold:width-chars            in frame f_bas_10_cta_ctbl_razao = 86.00
           rt_mold:height-chars           in frame f_bas_10_cta_ctbl_razao = 01.21
           rt_rgf:width-chars             in frame f_bas_10_cta_ctbl_razao = 88.00
           rt_rgf:height-chars            in frame f_bas_10_cta_ctbl_razao = 01.29.
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_bas_cta_ctbl_razao:ALLOW-COLUMN-SEARCHING in frame f_bas_10_cta_ctbl_razao = no
       br_bas_cta_ctbl_razao:COLUMN-MOVABLE in frame f_bas_10_cta_ctbl_razao = no.
end.
&endif
&if '{&emsbas_version}' >= '5.06' &then
if OPSYS = 'WIN32':U then do:
assign br_bas_cta_ctbl_razao_1:ALLOW-COLUMN-SEARCHING in frame f_bas_10_cta_ctbl_razao = no
       br_bas_cta_ctbl_razao_1:COLUMN-MOVABLE in frame f_bas_10_cta_ctbl_razao = no.
end.
&endif
    /* set private-data for the help system */
    assign bt_fir:private-data                       in frame f_bas_10_cta_ctbl_razao = "HLP=000004657":U
           bt_pre1:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000010790":U
           bt_nex1:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000010787":U
           bt_las:private-data                       in frame f_bas_10_cta_ctbl_razao = "HLP=000004658":U
           bt_ran2:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000008773":U
           bt_fil2:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000008766":U
           bt_plano_cta_ctbl:private-data            in frame f_bas_10_cta_ctbl_razao = "HLP=000008762":U
           bt_det1:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000010830":U
           bt_razao:private-data                     in frame f_bas_10_cta_ctbl_razao = "HLP=000008775":U
           bt_pri:private-data                       in frame f_bas_10_cta_ctbl_razao = "HLP=000010833":U
           bt_alter:private-data                     in frame f_bas_10_cta_ctbl_razao = "HLP=000024217":U
           bt_exi:private-data                       in frame f_bas_10_cta_ctbl_razao = "HLP=000004665":U
           bt_hel1:private-data                      in frame f_bas_10_cta_ctbl_razao = "HLP=000004666":U
           bt_zoo_98619:private-data                 in frame f_bas_10_cta_ctbl_razao = "HLP=000009431":U
           cenar_ctbl.cod_cenar_ctbl:private-data    in frame f_bas_10_cta_ctbl_razao = "HLP=000005310":U
           cenar_ctbl.des_cenar_ctbl:private-data    in frame f_bas_10_cta_ctbl_razao = "HLP=000011446":U
           bt_zoo_96444:private-data                 in frame f_bas_10_cta_ctbl_razao = "HLP=000009431":U
           cta_ctbl.cod_cta_ctbl:private-data        in frame f_bas_10_cta_ctbl_razao = "HLP=000011308":U
           bt_zoo_225941:private-data                in frame f_bas_10_cta_ctbl_razao = "HLP=000009431":U
           cta_ctbl.cod_altern_cta_ctbl:private-data in frame f_bas_10_cta_ctbl_razao = "HLP=000005338":U
           br_bas_cta_ctbl_razao_1:private-data      in frame f_bas_10_cta_ctbl_razao = "HLP=000008884":U
           bt_ent:private-data                       in frame f_bas_10_cta_ctbl_razao = "HLP=000009422":U
           cta_ctbl.des_tit_ctbl:private-data        in frame f_bas_10_cta_ctbl_razao = "HLP=000025188":U
           br_bas_cta_ctbl_razao:private-data        in frame f_bas_10_cta_ctbl_razao = "HLP=000008884":U
           v_val_sdo_ctbl_db:private-data            in frame f_bas_10_cta_ctbl_razao = "HLP=000024212":U
           v_val_sdo_ctbl_inic_ant:private-data      in frame f_bas_10_cta_ctbl_razao = "HLP=000024214":U
           v_val_sdo_ctbl_cr:private-data            in frame f_bas_10_cta_ctbl_razao = "HLP=000024213":U
           v_val_sdo_ctbl_fim:private-data           in frame f_bas_10_cta_ctbl_razao = "HLP=000024215":U
           frame f_bas_10_cta_ctbl_razao:private-data                                 = "HLP=000008884".
    /* enable function buttons */
    assign bt_zoo_98619:sensitive  in frame f_bas_10_cta_ctbl_razao = yes
           bt_zoo_96444:sensitive  in frame f_bas_10_cta_ctbl_razao = yes
           bt_zoo_225941:sensitive in frame f_bas_10_cta_ctbl_razao = yes.
    /* move buttons to top */
    bt_zoo_98619:move-to-top().
    bt_zoo_96444:move-to-top().
    bt_zoo_225941:move-to-top().



{include/i_fclfrm.i f_bas_10_cta_ctbl_razao }
/*************************** Frame Definition End ***************************/
&if '{&emsbas_version}' >= '5.06' &then
ON WINDOW-MAXIMIZED OF wh_w_program
DO:
def var v_whd_widget as widget-handle no-undo.
assign frame f_bas_10_cta_ctbl_razao:width-chars  = wh_w_program:width-chars
       frame f_bas_10_cta_ctbl_razao:height-chars = wh_w_program:height-chars no-error.

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


ON DEFAULT-ACTION OF br_bas_cta_ctbl_razao IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  avail item_lancto_ctbl
    then do:
        assign v_rec_item_lancto_ctbl = recid(item_lancto_ctbl).
        if  search("prgfin/fgl/fgl702ja.r") = ? and search("prgfin/fgl/fgl702ja.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl702ja.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl702ja.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fgl/fgl702ja.p /*prg_det_item_lancto_ctbl*/.
    end /* if */.
    enable br_bas_cta_ctbl_razao
           with frame f_bas_10_cta_ctbl_razao.
END. /* ON DEFAULT-ACTION OF br_bas_cta_ctbl_razao IN FRAME f_bas_10_cta_ctbl_razao */

ON VALUE-CHANGED OF br_bas_cta_ctbl_razao IN FRAME f_bas_10_cta_ctbl_razao
DO:

    /* Rodrigo - ATV233504:  Desfeita a alteraá∆o da FO 2059.938 pois n∆o estava mais apresentando o
      detalhe do item_lancto_ctbl (fgl702ja)*/

    find item_lancto_ctbl no-lock
      where item_lancto_ctbl.num_lote_ctbl       = tt_item_lancto_ctbl_razao.tta_num_lote_ctbl
        and item_lancto_ctbl.num_lancto_ctbl     = tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl
        and item_lancto_ctbl.num_seq_lancto_ctbl = tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl  no-error.
    find first tt_ccusto no-lock
      where tt_ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
        and tt_ccusto.cod_ccusto       = item_lancto_ctbl.cod_ccusto  no-error.
    if avail tt_ccusto then do:
        assign menu-item mi_razao_contabil:sensitive in menu m_10_cta_ctbl_razao = yes
               v_rec_ccusto = tt_ccusto.ttv_rec_ccusto.
        enable bt_razao
               with frame f_bas_10_cta_ctbl_razao.
    end.
    else do:
        assign menu-item mi_razao_contabil:sensitive in menu m_10_cta_ctbl_razao = no
               v_rec_ccusto = ?.
        disable bt_razao
                with frame f_bas_10_cta_ctbl_razao.       
    end.  
    /* Rodrigo - ATV233504*/
END. /* ON VALUE-CHANGED OF br_bas_cta_ctbl_razao IN FRAME f_bas_10_cta_ctbl_razao */

ON DEFAULT-ACTION OF br_bas_cta_ctbl_razao_1 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  avail item_lancto_ctbl
    then do:
        assign v_rec_item_lancto_ctbl = recid(item_lancto_ctbl).
        if  search("prgfin/fgl/fgl702ja.r") = ? and search("prgfin/fgl/fgl702ja.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl702ja.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl702ja.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/fgl/fgl702ja.p /*prg_det_item_lancto_ctbl*/.
    end /* if */.
    enable br_bas_cta_ctbl_razao_1
           with frame f_bas_10_cta_ctbl_razao.
END. /* ON DEFAULT-ACTION OF br_bas_cta_ctbl_razao_1 IN FRAME f_bas_10_cta_ctbl_razao */

ON VALUE-CHANGED OF br_bas_cta_ctbl_razao_1 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    /* FO: 2059.938 - Retirado o fonte para n∆o fazer a validaá∆o do centro de custo. Vai haver melhoria de performance.*/
    find item_lancto_ctbl no-lock
          where item_lancto_ctbl.num_lote_ctbl       = tt_item_lancto_ctbl_razao.tta_num_lote_ctbl
            and item_lancto_ctbl.num_lancto_ctbl     = tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl
            and item_lancto_ctbl.num_seq_lancto_ctbl = tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl  no-error.
    if avail item_lancto_ctbl and 
      item_lancto_ctbl.cod_plano_ccusto <> "" 
    then do:

        find ccusto no-lock
       where ccusto.cod_empresa = v_cod_unid_organ
         and ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
         and ccusto.cod_ccusto = item_lancto_ctbl.cod_ccusto no-error.
        if avail ccusto then
            assign v_rec_ccusto = recid(ccusto).

        assign menu-item mi_razao_contabil:sensitive in menu m_10_cta_ctbl_razao = yes.
        enable bt_razao
               with frame f_bas_10_cta_ctbl_razao.
    end.
    else do:
        assign menu-item mi_razao_contabil:sensitive in menu m_10_cta_ctbl_razao = no
               v_rec_ccusto = ?.
        disable bt_razao
                with frame f_bas_10_cta_ctbl_razao.
    end.    
END. /* ON VALUE-CHANGED OF br_bas_cta_ctbl_razao_1 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_alter IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  v_log_alter = no
    then do: 
        find cta_ctbl where 
             cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl and
             cta_ctbl.cod_cta_ctbl = input frame f_bas_10_cta_ctbl_razao
                 cta_ctbl.cod_cta_ctbl no-lock no-error.
        hide cta_ctbl.cod_cta_ctbl in frame f_bas_10_cta_ctbl_razao
             bt_zoo_96444 in frame f_bas_10_cta_ctbl_razao.
        view cta_ctbl.cod_altern_cta_ctbl in frame f_bas_10_cta_ctbl_razao
             bt_zoo_225941 in frame f_bas_10_cta_ctbl_razao.
        enable cta_ctbl.cod_altern_cta_ctbl
               with frame f_bas_10_cta_ctbl_razao.             
        assign bt_ent:column in frame f_bas_10_cta_ctbl_razao = 33.29
               cta_ctbl.des_tit_ctbl:column in frame f_bas_10_cta_ctbl_razao = 38.00
               v_log_alter = yes.
        if avail cta_ctbl then 
           assign cta_ctbl.cod_altern_cta_ctbl:screen-value in frame 
               f_bas_10_cta_ctbl_razao = string(cta_ctbl.cod_altern_cta_ctbl).
    end /* if */.
    else do: 
        find cta_ctbl where 
             cta_ctbl.cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl and 
             cta_ctbl.cod_altern_cta_ctbl = input frame f_bas_10_cta_ctbl_razao
                 cta_ctbl.cod_altern_cta_ctbl no-lock no-error.
        hide cta_ctbl.cod_altern_cta_ctbl in frame f_bas_10_cta_ctbl_razao
             bt_zoo_225941 in frame f_bas_10_cta_ctbl_razao.
        view cta_ctbl.cod_cta_ctbl in frame f_bas_10_cta_ctbl_razao
             bt_zoo_96444 in frame f_bas_10_cta_ctbl_razao.
        assign bt_ent:column in frame f_bas_10_cta_ctbl_razao = 41.14
               cta_ctbl.des_tit_ctbl:column in frame f_bas_10_cta_ctbl_razao = 45.86
               v_log_alter = no.
        if avail cta_ctbl then 
           assign cta_ctbl.cod_cta_ctbl:screen-value in frame 
               f_bas_10_cta_ctbl_razao = string(cta_ctbl.cod_cta_ctbl).        
    end /* else */.
END. /* ON CHOOSE OF bt_alter IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_det1 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  v_rec_cta_ctbl <> ?
    then do:
        if  search("prgint/utb/utb080jb.r") = ? and search("prgint/utb/utb080jb.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080jb.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb080jb.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb080jb.p /*prg_det_cta_ctbl*/.
    end /* if */.
END. /* ON CHOOSE OF bt_det1 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_ent IN FRAME f_bas_10_cta_ctbl_razao
DO:

    /* --- Criaá∆o dos tt_unid_negoc ---*/
    run pi_criar_unid_negoc_faixa /*pi_criar_unid_negoc_faixa*/.

    /* --- Criaá∆o dos tt_estab_unid_negoc ---*/
    run pi_criar_tt_estab_unid_negoc /*pi_criar_tt_estab_unid_negoc*/.

    /* --- Montar relaá∆o de estabelecimentos v†lidos ao usu†rio corrente ---*/
    run pi_lista_estab_valid_usuar_gld /*pi_lista_estab_valid_usuar_gld*/.

    /* --- Cen†rio Ctbl ---*/
       find first cenar_ctbl no-lock
            where cenar_ctbl.cod_cenar_ctbl = input frame f_bas_10_cta_ctbl_razao cenar_ctbl.cod_cenar_ctbl no-error.
    if  avail cenar_ctbl
    then do:
        assign v_rec_cenar_ctbl = recid(cenar_ctbl).
        if  v_cod_cenar_ctbl_ini <> cenar_ctbl.cod_cenar_ctbl
        then do:
            find first exerc_ctbl no-lock
               where exerc_ctbl.cod_cenar_ctbl  = cenar_ctbl.cod_cenar_ctbl
                 and exerc_ctbl.cod_exerc_ctbl >= string(year(today)) no-error.
            if  not avail exerc_ctbl
            then do:
                find first exerc_ctbl no-lock
                   where exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl no-error.
                if  not avail exerc_ctbl
                then do:
                    /* N∆o existe exerc°cio para o cen†rio cont†bil: &1 ! */
                    run pi_messages (input "show",
                                     input 1264,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                       cenar_ctbl.cod_cenar_ctbl)) /*msg_1264*/.
                    apply "entry" to cenar_ctbl.cod_cenar_ctbl in frame f_bas_10_cta_ctbl_razao.
                end /* if */.
            end /* if */.
            find period_ctbl no-lock
                where period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
                  and period_ctbl.cod_exerc_ctbl = exerc_ctbl.cod_exerc_ctbl
                  and period_ctbl.dat_inic_period_ctbl <= v_dat_inic_period_ctbl_pri
                  and period_ctbl.dat_fim_period_ctbl  >= v_dat_inic_period_ctbl_pri no-error.
            if  not avail period_ctbl
            then do:
                find first period_ctbl no-lock
                   where period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
                     and period_ctbl.cod_exerc_ctbl = exerc_ctbl.cod_exerc_ctbl no-error.
            end /* if */.
            if  avail period_ctbl
            then do:
                assign v_rec_exerc_ctbl       = recid(exerc_ctbl)
                       v_rec_period_ctbl_ini  = recid(period_ctbl)
                       v_cod_cenar_ctbl_ini   = cenar_ctbl.cod_cenar_ctbl
                       v_dat_inic_period_ctbl = period_ctbl.dat_inic_period_ctbl
                       v_dat_inic_period_ctbl_pri = v_dat_inic_period_ctbl
                       v_dat_fim_period_ctbl  = period_ctbl.dat_fim_period_ctbl.
            end /* if */.
            else do:
                /* N∆o existe Per°odos no Exerc°cio Cont†bil &1 ! */
                run pi_messages (input "show",
                                 input 1740,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                   exerc_ctbl.cod_cenar_ctbl,exerc_ctbl.cod_cenar_ctbl)) /*msg_1740*/.
                apply "entry" to cenar_ctbl.cod_cenar_ctbl in frame f_bas_10_cta_ctbl_razao.
            end /* else */.
        end /* if */.
    end /* if */.
    else do:
        message substitute(getStrTrans("&1 inexistente.", "FGL") /*l_not_found*/ ,getStrTrans("Cen†rio Cont†bil", "FGL"))
               view-as alert-box warning buttons ok.
        find cenar_ctbl
            where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
        apply "entry" to cenar_ctbl.cod_cenar_ctbl in frame f_bas_10_cta_ctbl_razao.
    end /* else */.
    /* --- Conta Ctbl ---*/
    if v_log_alter = yes then 
       find cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
            and cta_ctbl.cod_altern_cta_ctbl  = input frame f_bas_10_cta_ctbl_razao cta_ctbl.cod_altern_cta_ctbl no-error.
    else
       find cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
            and cta_ctbl.cod_cta_ctbl = input frame f_bas_10_cta_ctbl_razao cta_ctbl.cod_cta_ctbl no-error.
    if  avail cta_ctbl and
        cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl)
               v_log_answer   = session:set-wait-state('general').

        run pi_criar_item_lancto_ctbl_cta /*pi_criar_item_lancto_ctbl_cta*/.
        run pi_open_bas_cta_ctbl_razao /*pi_open_bas_cta_ctbl_razao*/.
        assign v_log_answer = session:set-wait-state("").
    end /* if */.
    else do:
        if  avail cta_ctbl
        then do:
            /* Conta Cont†bil deve ser Anal°tica. */
            run pi_messages (input "show",
                             input 1428,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1428*/.
        end /* if */.
        else do:
            message substitute(getStrTrans("&1 inexistente.", "FGL") /*l_not_found*/ ,getStrTrans("Conta Cont†bil", "FGL"))
                   view-as alert-box warning buttons ok.
            find cta_ctbl where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.
        end /* else */.
        apply "entry" to cta_ctbl.cod_cta_ctbl in frame f_bas_10_cta_ctbl_razao.
    end /* else */.
    if  can-find(first tt_ccusto_sem_permissao)
    then do:
        output stream s_str_rp to value(session:temp-directory + 'CCUSTO_SEM_PREMISS«O.txt')no-convert.
        disp stream s_str_rp 'Centro Custos sem Permiss∆o:' skip
                             '---------------------------' skip.
        for each tt_ccusto_sem_permissao:
            put stream s_str_rp tt_ccusto_sem_permissao.tta_cod_ccusto skip.
        end.
        output stream s_str_rp close.
        /* Usu†rio sem permiss∆o para acessar os centros de custos ! */
        run pi_messages (input "show",
                         input 20600,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           session:temp-directory + 'CCUSTO_SEM_PREMISS«O.txt')) /*msg_20600*/.
    end /* if */.
END. /* ON CHOOSE OF bt_ent IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_exi IN FRAME f_bas_10_cta_ctbl_razao
DO:

    assign v_rec_cenar_ctbl      = ?
           v_rec_exerc_ctbl      = ?       
           v_rec_plano_cta_ctbl  = ?
           v_rec_cta_ctbl        = ?.

    run pi_close_program /*pi_close_program*/.
END. /* ON CHOOSE OF bt_exi IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_fil2 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    assign v_log_changed_finalid = no.
    if  search("prgfin/fgl/fgl208zc.r") = ? and search("prgfin/fgl/fgl208zc.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl208zc.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl208zc.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl208zc.p /*prg_fnc_cta_ctbl_razao_filtro*/.
    if  v_log_changed_finalid = yes
    then do:
        ASSIGN v_cod_moed_finalid = v_cod_finalid_econ_fim. /* a finalidade FIM representa a moeda de apresentaá∆o dos dados */

        /* --- Encontrar cotacao entre Indic Base de Indic Apresentaá∆o ---*/
        if  v_cod_finalid_econ_ini <> v_cod_finalid_econ_fim
        then do:
           run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_ini,
                                               Input v_dat_cotac_indic_econ,
                                               output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
           run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_fim,
                                               Input v_dat_cotac_indic_econ,
                                               output v_cod_indic_econ_apres) /*pi_retornar_indic_econ_finalid*/.
           run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                          Input v_cod_indic_econ_apres,
                                          Input v_dat_cotac_indic_econ,
                                          Input "Real" /*l_real*/,
                                          output v_dat_cotac_indic_econ,
                                          output v_val_cotac_indic_econ,
                                          output v_cod_return) /*pi_achar_cotac_indic_econ*/.
        end /* if */.
        else do:
            assign v_val_cotac_indic_econ = 1
                   v_cod_indic_econ_base = "" 
                   v_cod_indic_econ_apres = "".
        end /* else */.
        apply "choose" to bt_ent in frame f_bas_10_cta_ctbl_razao.
    end /* if */.
END. /* ON CHOOSE OF bt_fil2 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_fir IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if v_log_alter then 
       find first cta_ctbl no-lock 
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_altern no-error.
    else 
       find first cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_id no-error.          
    if  avail cta_ctbl and v_rec_cta_ctbl <> recid(cta_ctbl)
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl).
        if v_log_alter = no then 
           display cta_ctbl.cod_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
        else    
           display cta_ctbl.cod_altern_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_altern_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
       if  avail cta_ctbl and
           cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/  
       then do:
            assign v_rec_cta_ctbl = recid(cta_ctbl)
                   v_log_answer   = session:set-wait-state('general').
            run pi_criar_item_lancto_ctbl_cta /* pi_criar_item_lancto_ctbl_cta*/.
            run pi_open_bas_cta_ctbl_razao /* pi_open_bas_cta_ctbl_razao*/.
            assign v_log_answer = session:set-wait-state("").
       end /* if */.

    /* @apply(choose) bt_ent in frame @&(frame). */
    end /* if */.
    else do:
        if  not avail cta_ctbl
        then do:
           /* --- Mostrar Conta no formato do Plano ---*/
           run pi_retornar_inic_zero (Input cta_ctbl.cod_cta_ctbl:handle in frame f_bas_10_cta_ctbl_razao,
                                      Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_retornar_inic_zero*/.
           assign v_rec_cta_ctbl     = ?
                  v_val_sdo_ctbl_inic_ant = 0
                  v_val_sdo_ctbl_fim = 0
                  v_val_sdo_ctbl_db  = 0
                  v_val_sdo_ctbl_cr  = 0.
           display cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
           message getStrTrans("N∆o existem ocorràncias na tabela.", "FGL") /*l_no_record*/ 
                  view-as alert-box warning buttons ok.
           /* Eliminar registros da Temp Table tt_item_lancto_ctbl_razao */
           tt_item_block:
           for
              each tt_item_lancto_ctbl_razao exclusive-lock:
              delete tt_item_lancto_ctbl_razao.
           end /* for tt_item_block */.
           run pi_open_bas_cta_ctbl_razao /*pi_open_bas_cta_ctbl_razao*/.
        end /* if */.
    end /* else */.
END. /* ON CHOOSE OF bt_fir IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_cta_ctbl_razao
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel1 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_las IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if v_log_alter then 
       find  last cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_altern no-error.
    else 
       find  last cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_id no-error.

    if  avail cta_ctbl and
    cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl)
               v_log_answer   = session:set-wait-state('general').
        run pi_criar_item_lancto_ctbl_cta /* pi_criar_item_lancto_ctbl_cta*/.
        run pi_open_bas_cta_ctbl_razao /* pi_open_bas_cta_ctbl_razao*/.
        assign v_log_answer = session:set-wait-state("").
    end /* if */.


    if  v_rec_cta_ctbl <> recid(cta_ctbl)
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl).
        if v_log_alter = no then 
           display cta_ctbl.cod_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
        else
           display cta_ctbl.cod_altern_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_altern_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.       
        /* @apply(choose) bt_ent in frame @&(frame). */
    end /* if */.
    else do:
        if  not avail cta_ctbl
        then do:
            assign cenar_ctbl.cod_cenar_ctbl:screen-value    in frame f_bas_10_cta_ctbl_razao = ""
                   cenar_ctbl.des_cenar_ctbl:screen-value    in frame f_bas_10_cta_ctbl_razao = ""
                   cta_ctbl.cod_altern_cta_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao = ""
                   cta_ctbl.cod_cta_ctbl:screen-value        in frame f_bas_10_cta_ctbl_razao = ""
                   cta_ctbl.des_tit_ctbl:screen-value        in frame f_bas_10_cta_ctbl_razao = ""
                   v_val_sdo_ctbl_cr:screen-value            in frame f_bas_10_cta_ctbl_razao = ""
                   v_val_sdo_ctbl_db:screen-value            in frame f_bas_10_cta_ctbl_razao = ""
                   v_val_sdo_ctbl_fim:screen-value           in frame f_bas_10_cta_ctbl_razao = ""
                   v_val_sdo_ctbl_inic_ant:screen-value      in frame f_bas_10_cta_ctbl_razao = "".
            message getStrTrans("N∆o existem ocorràncias na tabela.", "FGL") /*l_no_record*/ 
                   view-as alert-box warning buttons ok.
        end /* if */.
    end /* else */.
END. /* ON CHOOSE OF bt_las IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_nex1 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if v_log_alter then 
       find  next cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_altern no-error.
    else 
       find next cta_ctbl no-lock
           where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
             and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_id no-error.
    if  avail cta_ctbl
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl).
        if v_log_alter = no then 
           display cta_ctbl.cod_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
        else 
           display cta_ctbl.cod_altern_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_altern_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.          
        if  avail cta_ctbl and
            cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/  
        then do:
            assign v_rec_cta_ctbl = recid(cta_ctbl)
                   v_log_answer   = session:set-wait-state('general').
            run pi_criar_item_lancto_ctbl_cta /* pi_criar_item_lancto_ctbl_cta*/.
            run pi_open_bas_cta_ctbl_razao /* pi_open_bas_cta_ctbl_razao*/.
            assign v_log_answer = session:set-wait-state("").
        end /* if */.

    /* @apply(choose) bt_ent in frame @&(frame).*/
    end /* if */.
    else do:
        apply "choose" to bt_las in frame f_bas_10_cta_ctbl_razao.
        if  avail cta_ctbl
        then do:
            message getStrTrans("Èltima ocorrància da tabela.", "FGL") /*l_last*/ 
                   view-as alert-box warning buttons ok.
        end /* if */.
    end /* else */.
END. /* ON CHOOSE OF bt_nex1 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_plano_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  search("prgint/utb/utb080nb.r") = ? and search("prgint/utb/utb080nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080nb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb080nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb080nb.p /*prg_see_plano_cta_ctbl_uo*/.   
    if  v_rec_plano_cta_ctbl <> ?
    then do:
        find plano_cta_ctbl where recid(plano_cta_ctbl) = v_rec_plano_cta_ctbl no-lock no-error.
        if  lookup(plano_cta_ctbl.cod_plano_cta_ctbl,v_des_plano_cta_ctbl) = 0
        then do:
            /* Usu†rio sem permiss∆o ! */
            run pi_messages (input "show",
                             input 13007,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_13007*/.
            return no-apply.
        end /* if */.
        if  plano_cta_ctbl.ind_tip_plano_cta_ctbl <> "Prim†rio" /*l_primario*/ 
        then do:
            /* Plano de Contas n∆o Ç do tipo prim†rio ! */
            run pi_messages (input "show",
                             input 1779,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1779*/.
            return no-apply.
        end /* if */.
        else do:
            assign v_rec_plano_cta_ctbl  = recid(plano_cta_ctbl)
                   v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl.
            /* Mostrar Conta no formato do Plano */
            run pi_retornar_inic_zero (Input cta_ctbl.cod_cta_ctbl:handle in frame f_bas_10_cta_ctbl_razao,
                                       Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_retornar_inic_zero*/.
            apply "choose" to bt_fir in frame f_bas_10_cta_ctbl_razao.
        end /* else */.
    end /* if */.
END. /* ON CHOOSE OF bt_plano_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_pre1 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if v_log_alter then 
       find  prev cta_ctbl no-lock
            where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
              and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
              and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_altern no-error.
    else 
       find prev cta_ctbl no-lock
           where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
             and cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
             and cta_ctbl.cod_plano_cta_ctbl <> ""  use-index ctactbl_id no-error.
    if  avail cta_ctbl
    then do:
        assign v_rec_cta_ctbl = recid(cta_ctbl).
        if v_log_alter = no then 
           display cta_ctbl.cod_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.
        else 
           display cta_ctbl.cod_altern_cta_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.cod_altern_cta_ctbl
                   cta_ctbl.des_tit_ctbl when avail cta_ctbl
                   "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                   with frame f_bas_10_cta_ctbl_razao.   
        if  avail cta_ctbl and
            cta_ctbl.ind_espec_cta_ctbl = "Anal°tica" /*l_analitica*/ 
        then do:
            assign v_rec_cta_ctbl = recid(cta_ctbl)
                   v_log_answer   = session:set-wait-state('general').
            run pi_criar_item_lancto_ctbl_cta /* pi_criar_item_lancto_ctbl_cta*/.
            run pi_open_bas_cta_ctbl_razao /* pi_open_bas_cta_ctbl_razao*/.
            assign v_log_answer = session:set-wait-state("").
        end /* if */.

    /* @apply(choose) bt_ent in frame @&(frame).*/
    end /* if */.
    else do:
        apply "choose" to bt_fir in frame f_bas_10_cta_ctbl_razao.
        if  avail cta_ctbl
        then do:
            message getStrTrans("Primeira ocorrància da tabela.", "FGL") /*l_first*/ 
                   view-as alert-box warning buttons ok.
        end /* if */.
    end /* else */.
END. /* ON CHOOSE OF bt_pre1 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_pri IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if  search("prgfin/fgl/fgl304ad.r") = ? and search("prgfin/fgl/fgl304ad.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl304ad.py".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl304ad.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl304ad.py /*prg_rpt_lancto_ctbl_razao_cta*/.
END. /* ON CHOOSE OF bt_pri IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_ran2 IN FRAME f_bas_10_cta_ctbl_razao
DO:

    assign v_log_changed = no.
    if  search("prgfin/fgl/fgl208zb.r") = ? and search("prgfin/fgl/fgl208zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl208zb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl208zb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl208zb.p /*prg_fnc_cta_ctbl_razao_faixa*/.
    if  v_log_changed = yes
    then do:
        /* --- Criaá∆o dos tt_unid_negoc ---*/
        run pi_criar_unid_negoc_faixa /*pi_criar_unid_negoc_faixa*/.

        /* --- Criaá∆o dos tt_estab_unid_negoc ---*/
        run pi_criar_tt_estab_unid_negoc /*pi_criar_tt_estab_unid_negoc*/.

        /* --- Montar relaá∆o de unidades de neg¢cio que o usu†rio n∆o tem acesso 
        @run (pi_lista_unid_negoc_segur_usuar).
        ---*/
        /* --- Montar relaá∆o de estabelecimentos v†lidos ao usu†rio corrente ---*/
        run pi_lista_estab_valid_usuar_gld /*pi_lista_estab_valid_usuar_gld*/.

        find first period_ctbl no-lock
             where period_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
               and period_ctbl.dat_inic_period_ctbl <= v_dat_inic_period_ctbl_pri
               and period_ctbl.dat_fim_period_ctbl  >= v_dat_inic_period_ctbl_pri no-error.
        if  avail period_ctbl
        then do:
            find first exerc_ctbl no-lock
                 where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
                   and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
                  no-error.
            assign v_rec_exerc_ctbl       = recid(exerc_ctbl)
                   v_rec_period_ctbl_ini  = recid(period_ctbl)
                   v_dat_inic_period_ctbl = period_ctbl.dat_inic_period_ctbl.
        end /* if */.

        /* ** Mensagem de alerta com a lista dos estabelecimentos com acesso permitido
             ao usu†rio corrente, ou seja, considerados no processamento da consulta. ***/
        if  v_des_lista_estab <> ""
        and v_cod_estab_ini <> v_cod_estab_fim then do:
            /* Restriá∆o de Estabelecimentos ao Usu†rio na Contabilidade ! */
            run pi_messages (input "show",
                             input 9937,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_des_lista_estab, v_cod_usuar_corren)) /*msg_9937*/.
        end.

        apply "choose" to bt_ent in frame f_bas_10_cta_ctbl_razao.
    end /* if */.
END. /* ON CHOOSE OF bt_ran2 IN FRAME f_bas_10_cta_ctbl_razao */

ON CHOOSE OF bt_razao IN FRAME f_bas_10_cta_ctbl_razao
DO:

    if avail item_lancto_ctbl then do:
        find first ccusto no-lock
            where ccusto.cod_ccusto = item_lancto_ctbl.cod_ccusto
              and ccusto.cod_empresa = item_lancto_ctbl.cod_empresa
              and ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto no-error.
        if avail ccusto then
            assign v_rec_ccusto = recid(ccusto).

        if avail cta_ctbl then assign v_rec_cta_ctbl = recid(cta_ctbl).
    end.
    assign v_log_changed         = no
           v_log_changed_finalid = no.
    if  search("prgfin/fgl/fgl209aa.r") = ? and search("prgfin/fgl/fgl209aa.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl209aa.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl209aa.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl209aa.p /*prg_bas_ccusto_razao*/.
    if  v_log_changed         = yes or
        v_log_changed_finalid = yes
    then do:
        apply "choose" to bt_ent in frame f_bas_10_cta_ctbl_razao.
    end /* if */.
END. /* ON CHOOSE OF bt_razao IN FRAME f_bas_10_cta_ctbl_razao */

ON LEAVE OF cenar_ctbl.cod_cenar_ctbl IN FRAME f_bas_10_cta_ctbl_razao
DO:

    find first cenar_ctbl no-lock
         where cenar_ctbl.cod_cenar_ctbl = input frame f_bas_10_cta_ctbl_razao cenar_ctbl.cod_cenar_ctbl /*cl_bas_cta_ctbl_razao of cenar_ctbl*/ no-error.
    display cenar_ctbl.des_cenar_ctbl when avail cenar_ctbl
            "" when not avail cenar_ctbl @ cenar_ctbl.des_cenar_ctbl
            with frame f_bas_10_cta_ctbl_razao.
END. /* ON LEAVE OF cenar_ctbl.cod_cenar_ctbl IN FRAME f_bas_10_cta_ctbl_razao */

ON LEAVE OF cta_ctbl.cod_altern_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao
DO:

    find first cta_ctbl no-lock
         where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
           and cta_ctbl.cod_altern_cta_ctbl = input frame f_bas_10_cta_ctbl_razao cta_ctbl.cod_altern_cta_ctbl
    &if "{&emsuni_version}" >= "5.01" &then
         use-index ctactbl_altern
    &endif
          /*cl_frame_cod_alter_cta_ctbl of cta_ctbl*/ no-error.
    display cta_ctbl.des_tit_ctbl when avail cta_ctbl
            "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
            with frame f_bas_10_cta_ctbl_razao.
END. /* ON LEAVE OF cta_ctbl.cod_altern_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao */

ON LEAVE OF cta_ctbl.cod_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao
DO:

    assign v_cod_format = input frame f_bas_10_cta_ctbl_razao cta_ctbl.cod_cta_ctbl no-error.
    if  error-status:error or index(string(v_cod_format,v_cod_format_cta_ctbl),chr(32)) <> 0
    then do:
        /* Formato &2 Inv†lido ! */
        run pi_messages (input "show",
                         input 4488,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           v_cod_format_cta_ctbl,'')) /*msg_4488*/.
        return no-apply.
    end /* if */.    
    find first cta_ctbl no-lock
         where cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
           and cta_ctbl.cod_cta_ctbl = input frame f_bas_10_cta_ctbl_razao cta_ctbl.cod_cta_ctbl /*cl_frame_plano_cta_ctbl of cta_ctbl*/ no-error.
    display cta_ctbl.des_tit_ctbl when avail cta_ctbl
            "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
            with frame f_bas_10_cta_ctbl_razao.
END. /* ON LEAVE OF cta_ctbl.cod_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_96444 IN FRAME f_bas_10_cta_ctbl_razao
OR F5 OF cta_ctbl.cod_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao DO:

    if  search("prgint/utb/utb080ne.r") = ? and search("prgint/utb/utb080ne.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080ne.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb080ne.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb080ne.p /*prg_see_cta_ctbl_analitica*/.
    if  v_rec_cta_ctbl <> ?
    then do:
        find cta_ctbl where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.
        assign cta_ctbl.cod_cta_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   string(cta_ctbl.cod_cta_ctbl)
               cta_ctbl.des_tit_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   cta_ctbl.des_tit_ctbl.
        apply "entry" to cta_ctbl.cod_cta_ctbl in frame f_bas_10_cta_ctbl_razao.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_96444 IN FRAME f_bas_10_cta_ctbl_razao */

ON  CHOOSE OF bt_zoo_98619 IN FRAME f_bas_10_cta_ctbl_razao
OR F5 OF cenar_ctbl.cod_cenar_ctbl IN FRAME f_bas_10_cta_ctbl_razao DO:

    if  search("prgint/utb/utb076na.r") = ? and search("prgint/utb/utb076na.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb076na.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb076na.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb076na.p /*prg_see_cenar_ctbl_uo*/.
    if  v_rec_cenar_ctbl <> ?
    then do:
        find cenar_ctbl where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
        assign cenar_ctbl.cod_cenar_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   string(cenar_ctbl.cod_cenar_ctbl)
               cenar_ctbl.des_cenar_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   cenar_ctbl.des_cenar_ctbl.
        apply "entry" to cenar_ctbl.cod_cenar_ctbl in frame f_bas_10_cta_ctbl_razao.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_98619 IN FRAME f_bas_10_cta_ctbl_razao */

ON  CHOOSE OF bt_zoo_225941 IN FRAME f_bas_10_cta_ctbl_razao
OR F5 OF cta_ctbl.cod_altern_cta_ctbl IN FRAME f_bas_10_cta_ctbl_razao DO:

    if  search("prgint/utb/utb080ne.r") = ? and search("prgint/utb/utb080ne.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080ne.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgint/utb/utb080ne.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb080ne.p /*prg_see_cta_ctbl_analitica*/.
    if  v_rec_cta_ctbl <> ?
    then do:
        find cta_ctbl where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.
        assign cta_ctbl.cod_altern_cta_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   string(cta_ctbl.cod_altern_cta_ctbl)
               cta_ctbl.des_tit_ctbl:screen-value in frame f_bas_10_cta_ctbl_razao =
                   cta_ctbl.des_tit_ctbl.
        apply "entry" to cta_ctbl.cod_altern_cta_ctbl in frame f_bas_10_cta_ctbl_razao.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_225941 IN FRAME f_bas_10_cta_ctbl_razao */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON ENDKEY OF FRAME f_bas_10_cta_ctbl_razao
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(cta_ctbl).    
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
        assign v_rec_table_epc = recid(cta_ctbl).    
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
        assign v_rec_table_epc = recid(cta_ctbl).    
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

END. /* ON ENDKEY OF FRAME f_bas_10_cta_ctbl_razao */

ON END-ERROR OF FRAME f_bas_10_cta_ctbl_razao
DO:

    run pi_close_program /*pi_close_program*/.
END. /* ON END-ERROR OF FRAME f_bas_10_cta_ctbl_razao */

ON HELP OF FRAME f_bas_10_cta_ctbl_razao ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_bas_10_cta_ctbl_razao */

ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_cta_ctbl_razao ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_bas_10_cta_ctbl_razao */

ON RIGHT-MOUSE-UP OF FRAME f_bas_10_cta_ctbl_razao ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_bas_10_cta_ctbl_razao */


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
        assign v_whd_field_group = frame f_bas_10_cta_ctbl_razao:first-child.
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
                assign tt_maximizacao.frame-width-original   = frame f_bas_10_cta_ctbl_razao:width.
                assign tt_maximizacao.frame-height-original  = frame f_bas_10_cta_ctbl_razao:height.
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

    apply "choose" to bt_exi in frame f_bas_10_cta_ctbl_razao.

END. /* ON WINDOW-CLOSE OF wh_w_program */

END.

/**************************** Window Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_fir IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_fir in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_fir IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_pre IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_pre1 in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_pre IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_nex IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_nex1 in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_nex IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_las IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_las in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_las IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_ran IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_ran2 in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_ran IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_fil IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_fil2 in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_fil IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_plano_contas IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_plano_cta_ctbl in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_plano_contas IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_det IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_det1 in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_det IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_razao_contabil IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_razao in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_razao_contabil IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_imprime IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_pri in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_imprime IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_alternativa IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_alter in frame f_bas_10_cta_ctbl_razao.
END. /* ON CHOOSE OF MENU-ITEM mi_alternativa IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_exi in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10_cta_ctbl_razao
DO:

    apply "choose" to bt_hel1 in frame f_bas_10_cta_ctbl_razao.

END. /* ON CHOOSE OF MENU-ITEM mi_contents IN MENU m_10_cta_ctbl_razao */

ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10_cta_ctbl_razao
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
                          + "bas_cta_ctbl_razao":U
           v_nom_prog_ext = "prgfin/fgl/ESCF0208.p":U
           v_cod_release  = trim(" 1.00.00.001":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
    /* End_Include: i_about_call */

END. /* ON CHOOSE OF MENU-ITEM mi_about IN MENU m_10_cta_ctbl_razao */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */


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
    run pi_version_extract ('bas_cta_ctbl_razao':U, 'prgfin/fgl/ESCF0208.p':U, '1.00.00.001':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
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
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FGL") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'bas_cta_ctbl_razao') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_cta_ctbl_razao')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'bas_cta_ctbl_razao')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'bas_cta_ctbl_razao' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'bas_cta_ctbl_razao'
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
    where prog_dtsul.cod_prog_dtsul = "bas_cta_ctbl_razao":U
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


assign v_wgh_frame_epc = frame f_bas_10_cta_ctbl_razao:handle.



assign v_nom_table_epc = 'cta_ctbl':U
       v_rec_table_epc = recid(cta_ctbl).

&endif

/* End_Include: i_verify_program_epc */



/* Begin_Include: ix_p00_bas_cta_ctbl_razao */
hide cta_ctbl.cod_altern_cta_ctbl in frame f_bas_10_cta_ctbl_razao
     bt_zoo_225941 in frame f_bas_10_cta_ctbl_razao.

assign v_log_funcao_histor_estrut = no.

&if defined(BF_FIN_REESTRUT_SOCIETARIA) &then
    if can-find(first histor_exec_especial
                where histor_exec_especial.cod_prog_dtsul = 'SVZ_REESTRUT_SOCIETARIA') then 
        assign v_log_funcao_histor_estrut = yes.
&endif

/* ** Atualizaá∆o das Funá∆o Especiais ***/

/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emscad.histor_exec_especial NO-LOCK
         WHERE histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND histor_exec_especial.cod_prog_dtsul  = SPP) THEN
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
.
if not valid-handle(v_hdl_func_padr_glob) then run prgint/utb/utb925za.py persistent set v_hdl_func_padr_glob no-error.
function FnAjustDec returns dec (p_val_movto as decimal, p_cod_moed_finalid as character) in v_hdl_func_padr_glob.

/* verifica se existe funá∆o para informar cotaá∆o */
assign v_log_funcao_lista_cta_cpart = &IF DEFINED(BF_FIN_LISTAR_CTA_CPARTIDA) &THEN YES &ELSE GetDefinedFunction('SPP_LISTAR_CTA_CPARTIDA':U)    &ENDIF.

/* --- Unidade Organizacional ---*/
find emscad.unid_organ no-lock
     where unid_organ.cod_unid_organ = v_cod_empres_usuar no-error.

if not Verifica_Program_Name('mgl204aa':U,2)
and v_cod_unid_organizacional <> '' THEN DO:     
    find unid_organ no-lock
         where unid_organ.cod_unid_organ = v_cod_unid_organizacional no-error.
end.
if  avail unid_organ
then do:
    assign v_rec_unid_organ         = recid(unid_organ)
           v_rec_unid_organ_sdo     = v_rec_unid_organ
           v_log_changed_unid_organ = yes.

    find first emscad.empresa no-lock
         where empresa.cod_empresa = unid_organ.cod_unid_organ
          no-error.
    assign v_cod_unid_organ = unid_organ.cod_unid_organ.
end /* if */.
else do:
    /* Empresa do usu†rio n∆o definida. */
    run pi_messages (input "show",
                     input 1040,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1040*/.
    return.
end /* else */.

&if '{&emsfin_version}' >= '5.05' &then
/* * N∆o altera faixa do estabelecimento quando executado pelo DEMO V÷DEO (testa menu ou editor) **/
IF  INDEX(PROGRAM-NAME(2), "mgl204aa":U) <> 0
OR  PROGRAM-NAME(2) BEGINS "pi_razao_contabil_demonst":U THEN
    ASSIGN v_log_changed_unid_organ = NO.
&endif

/* --- Plano de Contas, Centros de Custo, Verifica se UO utiliza BU
      e Estabelecimento Inicial e Final do Usu†rio ---*/
run pi_selecionar_unid_organ /*pi_selecionar_unid_organ*/.
if  return-value = "NOK" /*l_nok*/ 
then do:
    return.
end /* if */.

/* --- Verifica se est† parametrizado para utilizar o controle de restriá∆o
      de acesso por estabelecimentos relacionados ao usu†rio corrente  ---*/
assign v_log_restric_estab = no.
run pi_retorna_usa_segur_estab (Input "",
                                output v_log_restric_estab) /*pi_retorna_usa_segur_estab*/.

/* --- Criaá∆o dos tt_estab_unid_negoc ---*/
run pi_criar_tt_estab_unid_negoc /*pi_criar_tt_estab_unid_negoc*/.

/* /*--- Montar relaá∆o de unidades de neg¢cio que o usu†rio n∆o tem acesso ---*/
@run (pi_lista_unid_negoc_segur_usuar).*/

/* --- Montar relaá∆o de estabelecimentos v†lidos ao usu†rio corrente ---*/
run pi_lista_estab_valid_usuar_gld /*pi_lista_estab_valid_usuar_gld*/.

/* --- Finalidade Econ Inicial ---*/
if  v_cod_finalid_econ_ini = ? or
    v_cod_finalid_econ_ini = ""
then do:
    run pi_retornar_finalid_econ_corren_estab (Input v_cod_estab_ini,
                                               output v_cod_finalid_econ_ini) /*pi_retornar_finalid_econ_corren_estab*/.
    find finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = v_cod_finalid_econ_ini /*cl_finalid_econ_ini of finalid_econ*/ no-error.
    if  avail finalid_econ
    then do:
        assign v_rec_finalid_econ     = recid(finalid_econ)
               v_dat_cotac_indic_econ = today.
    end /* if */.
    else do:
        /* Finalidade Econìmica corrente n∆o econtrada para U.O ! */
        run pi_messages (input "show",
                         input 1192,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1192*/.
        return.
    end /* else */.
end /* if */.
else do:
    find first finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = v_cod_finalid_econ_ini /*cl_finalid_econ_ini of finalid_econ*/ no-error.
    if  avail finalid_econ
    then do:
        assign v_rec_finalid_econ = recid(finalid_econ).
    end /* if */.
end /* else */.

/* --- Finalidade Econ Final ---*/
if  v_cod_finalid_econ_fim = ? or
    v_cod_finalid_econ_fim = "ZZZZZZZZZZ":U
then do:
    assign v_cod_finalid_econ_fim = v_cod_finalid_econ_ini.
end /* if */.
else do:
    find first finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = v_cod_finalid_econ_fim /*cl_finalid_econ_fim of finalid_econ*/ no-error.
    if  avail finalid_econ
    then do:
       assign v_cod_finalid_econ_fim = finalid_econ.cod_finalid_econ.
    end /* if */.
end /* else */.

/* --- Encontrar cotacao entre Indic Base de Indic Apresentaá∆o ---*/
ASSIGN v_cod_moed_finalid = v_cod_finalid_econ_fim. /* a finalidade FIM representa a moeda de apresentaá∆o dos dados */

if  v_cod_finalid_econ_ini <> v_cod_finalid_econ_fim
then do:
    run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_ini,
                                        Input v_dat_cotac_indic_econ,
                                        output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
    run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_fim,
                                        Input v_dat_cotac_indic_econ,
                                        output v_cod_indic_econ_apres) /*pi_retornar_indic_econ_finalid*/.
    run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                   Input v_cod_indic_econ_apres,
                                   Input v_dat_cotac_indic_econ,
                                   Input "Real" /*l_real*/,
                                   output v_dat_cotac_indic_econ,
                                   output v_val_cotac_indic_econ,
                                   output v_cod_return) /*pi_achar_cotac_indic_econ*/.
end /* if */.
else do:
    assign v_val_cotac_indic_econ = 1.
end /* else */.

/* --- Cen†rio Cont†bil ---*/
find cenar_ctbl where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
if  not avail cenar_ctbl
then do:
    run pi_retornar_cenar_ctbl_fisc (Input v_cod_empres_usuar,
                                     Input today,
                                     output v_cod_cenar_ctbl) /*pi_retornar_cenar_ctbl_fisc*/.
    if  v_cod_cenar_ctbl = ? or
        v_cod_cenar_ctbl = ""
    then do:

        find first utiliz_cenar_ctbl no-lock
             where utiliz_cenar_ctbl.cod_empresa = v_cod_empres_usuar no-error.
        if  avail utiliz_cenar_ctbl
        then do:
            assign v_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.
            find cenar_ctbl no-lock
                 where cenar_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
&if "{&emsuni_version}" >= "5.01" &then
                 use-index tpxrcctb_id
&endif
                  /*cl_validar_cenar_ctbl of cenar_ctbl*/ no-error.
            if  avail cenar_ctbl
            then do:
                assign v_rec_cenar_ctbl = recid(cenar_ctbl).
            end /* if */.            
        end /* if */.
        else do:
            assign v_cod_cenar_ctbl = "".
        end /* else */.

        if  v_cod_cenar_ctbl = ? or
            v_cod_cenar_ctbl = ""
        then do:
            /* Cen†rio Cont†bil Inexistente ! */
            run pi_messages (input "show",
                             input 449,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_449*/.
            return.
        end.
    end /* if */.
    else do:
        find cenar_ctbl no-lock
             where cenar_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
&if "{&emsuni_version}" >= "5.01" &then
             use-index tpxrcctb_id
&endif
              /*cl_validar_cenar_ctbl of cenar_ctbl*/ no-error.
        if  avail cenar_ctbl
        then do:
            assign v_rec_cenar_ctbl = recid(cenar_ctbl).
        end /* if */.
    end /* else */.
end /* if */.
assign v_cod_cenar_ctbl_ini = cenar_ctbl.cod_cenar_ctbl.

/* --- Per°odo Cont†bil Inicial ---*/
find period_ctbl where recid(period_ctbl) = v_rec_period_ctbl_ini no-lock no-error.
if  not avail period_ctbl
then do:
    find first exerc_ctbl no-lock
         where exerc_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl_ini
           and exerc_ctbl.cod_exerc_ctbl >= string(year(today)) /*cl_exerc_ctbl_ano of exerc_ctbl*/ no-error.
    if  not avail exerc_ctbl
    then do:
        find last exerc_ctbl no-lock
             where exerc_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
              no-error.
        if  not avail exerc_ctbl
        then do:
            /* N∆o existe exerc°cio para o cen†rio cont†bil: &1 ! */
            run pi_messages (input "show",
                             input 1264,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               cenar_ctbl.cod_cenar_ctbl)) /*msg_1264*/.
            return.
        end /* if */.
    end /* if */.
    find first period_ctbl no-lock
        where period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
          and period_ctbl.cod_exerc_ctbl = exerc_ctbl.cod_exerc_ctbl
          and period_ctbl.dat_inic_period_ctbl <= today
          and period_ctbl.dat_fim_period_ctbl  >= today no-error.
    if  not avail period_ctbl
    then do:
        find first period_ctbl no-lock
            where period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
              and period_ctbl.cod_exerc_ctbl = exerc_ctbl.cod_exerc_ctbl no-error.
    end /* if */.
end /* if */.

if  not avail period_ctbl
then do:
    /* N∆o existe Per°odos no Exerc°cio Cont†bil &1 ! */
    run pi_messages (input "show",
                     input 1740,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       exerc_ctbl.cod_cenar_ctbl,exerc_ctbl.cod_cenar_ctbl)) /*msg_1740*/.
    return.
end /* if */.

find first exerc_ctbl no-lock
     where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
       and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
      no-error.
assign v_rec_exerc_ctbl       = recid(exerc_ctbl)
       v_rec_period_ctbl_ini  = recid(period_ctbl)
       v_dat_inic_period_ctbl = period_ctbl.dat_inic_period_ctbl
       v_dat_inic_period_ctbl_pri = v_dat_inic_period_ctbl
       v_dat_fim_period_ctbl  = period_ctbl.dat_fim_period_ctbl.

/* --- Plano de Contas Cont†beis ---*/
if  v_rec_plano_cta_ctbl <> ?
then do:
    find plano_cta_ctbl where recid(plano_cta_ctbl) = v_rec_plano_cta_ctbl no-lock no-error.
    if  avail plano_cta_ctbl
    then do:
        assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl.
    end /* if */.
end /* if */.
else do:
    run pi_retornar_plano_cta_ctbl_prim (Input v_cod_empres_usuar,
                                         Input today,
                                         output v_cod_plano_cta_ctbl,
                                         output v_log_plano_cta_ctbl_uni) /*pi_retornar_plano_cta_ctbl_prim*/.
    find plano_cta_ctbl
        where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
        no-lock no-error.
    if  avail plano_cta_ctbl
    then do:
        assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
               v_rec_plano_cta_ctbl = recid(plano_cta_ctbl).
    end /* if */.
end /* else */.

find first tt_plano_cta_ctbl no-lock
     where tt_plano_cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl /*cl_plano_cta_ctbl_usuar of tt_plano_cta_ctbl*/ no-error.
if  not avail tt_plano_cta_ctbl or
    tt_plano_cta_ctbl.ind_tip_plano_cta_ctbl <> "Prim†rio" /*l_primario*/ 
then do:
    find first tt_plano_cta_ctbl no-lock
         where tt_plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Prim†rio" /*cl_primario of tt_plano_cta_ctbl*/ no-error.
    if  avail tt_plano_cta_ctbl
    then do:
        assign v_rec_plano_cta_ctbl = tt_plano_cta_ctbl.ttv_rec_plano_cta_ctbl.
        find plano_cta_ctbl where recid(plano_cta_ctbl) = v_rec_plano_cta_ctbl no-lock no-error.
        assign v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl.
    end /* if */.
    else do:
        /* Usu†rio n∆o tem acesso a Plano de Contas do tipo: &1. */
        run pi_messages (input "show",
                         input 1946,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "Prim†rio" /*l_primario*/)) /*msg_1946*/.
        return.
    end /* else */.
end /* if */.

/* --- Mostrar Conta no formato do Plano ---*/
run pi_retornar_inic_zero (Input cta_ctbl.cod_cta_ctbl:handle in frame f_bas_10_cta_ctbl_razao,
                           Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_retornar_inic_zero*/.

find cta_ctbl where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.
if  avail cta_ctbl and
   (cta_ctbl.cod_plano_cta_ctbl <> plano_cta_ctbl.cod_plano_cta_ctbl or
    cta_ctbl.ind_espec_cta_ctbl <> "Anal°tica" /*l_analitica*/ )
then do:
    assign v_rec_cta_ctbl = ?.
end /* if */.

if  v_log_funcao_lista_cta_cpart
then do:
    assign ttv_cod_cta_ctbl_cpart:label in browse br_bas_cta_ctbl_razao_1 = getStrTrans("Contra Partida", "FGL") /*l_contra_partida*/ .
    assign br_bas_cta_ctbl_razao_1:num-locked-columns in frame f_bas_10_cta_ctbl_razao = 1.
    assign br_bas_cta_ctbl_razao:visible in frame f_bas_10_cta_ctbl_razao = no.
end.
else do:
    assign br_bas_cta_ctbl_razao:num-locked-columns in frame f_bas_10_cta_ctbl_razao = 1.
    assign br_bas_cta_ctbl_razao_1:visible in frame f_bas_10_cta_ctbl_razao = no.
end.
/* End_Include: i_declara_Verifica_Program_Name */

/* redefiniá‰es do menu */
assign sub-menu  mi_table:label in menu m_10_cta_ctbl_razao = "Arquivo" /*l_file*/ .

/* redefiniá‰es da window e frame */

/* Begin_Include: i_std_window */
/* tratamento do t°tulo, menu, vers∆o e dimens‰es */
assign wh_w_program:title         = frame f_bas_10_cta_ctbl_razao:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 1.00.00.001":U)
                                  + chr(41)
       frame f_bas_10_cta_ctbl_razao:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_cta_ctbl_razao:width-chars
       wh_w_program:height-chars  = frame f_bas_10_cta_ctbl_razao:height-chars - 0.85
       frame f_bas_10_cta_ctbl_razao:row         = 1
       frame f_bas_10_cta_ctbl_razao:col         = 1
       wh_w_program:menubar       = menu m_10_cta_ctbl_razao:handle
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


run pi_frame_settings (Input frame f_bas_10_cta_ctbl_razao:handle) /*pi_frame_settings*/.

/* ix_p02_bas_cta_ctbl_razao */

pause 0 before-hide.

view frame f_bas_10_cta_ctbl_razao.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(cta_ctbl).    
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
    assign v_rec_table_epc = recid(cta_ctbl).    
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
    assign v_rec_table_epc = recid(cta_ctbl).    
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


/* ix_p05_bas_cta_ctbl_razao */
enable bt_exi
       bt_hel1
       bt_fir
       bt_nex1
       bt_pre1
       bt_las
       bt_ran2
       bt_fil2
       bt_plano_cta_ctbl
       bt_det1
       bt_pri
       bt_ent
       bt_alter
       cta_ctbl.cod_cta_ctbl
       cenar_ctbl.cod_cenar_ctbl
       with frame f_bas_10_cta_ctbl_razao.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(cta_ctbl).    
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
    assign v_rec_table_epc = recid(cta_ctbl).    
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
    assign v_rec_table_epc = recid(cta_ctbl).    
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

    /* Begin_Include: ix_p10_bas_cta_ctbl_razao */
    if  v_log_plano_cta_ctbl_uni = yes
    then do:
        assign menu-item mi_plano_contas:sensitive in menu m_10_cta_ctbl_razao = no.
    end /* if */.
    display cenar_ctbl.cod_cenar_ctbl when avail cenar_ctbl
            "" when not avail cenar_ctbl @ cenar_ctbl.cod_cenar_ctbl
            cenar_ctbl.des_cenar_ctbl when avail cenar_ctbl
            "" when not avail cenar_ctbl @ cenar_ctbl.des_cenar_ctbl
            with frame f_bas_10_cta_ctbl_razao.
    if  v_rec_cta_ctbl = ?
    then do:
        apply "choose" to bt_fir in frame f_bas_10_cta_ctbl_razao.
    end /* if */.
    else do:
        display cta_ctbl.cod_cta_ctbl when avail cta_ctbl
                "" when not avail cta_ctbl @ cta_ctbl.cod_cta_ctbl
                cta_ctbl.des_tit_ctbl when avail cta_ctbl
                "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
                with frame f_bas_10_cta_ctbl_razao.
    end /* else */.

    /* Verifica se Plano de Contas, do tipo Prim†rio Ç unico para o usu†rio */
    plano_cta_ctbl:
    for each tt_plano_cta_ctbl no-lock:
        if tt_plano_cta_ctbl.ind_tip_plano_cta_ctbl = "prim†rio" then
           assign v_num_primario = v_num_primario + 1.

        assign v_des_plano_cta_ctbl = v_des_plano_cta_ctbl + "," + tt_plano_cta_ctbl.cod_plano_cta_ctbl.
    end.

    &if '{&emsfin_version}' >= '5.05' &then
    /* * Processa informaá‰es automaticamente quando executado pelo DEMO V÷DEO (testa menu ou editor) **/
    IF  INDEX(PROGRAM-NAME(2), "mgl204aa":U) <> 0
    OR  PROGRAM-NAME(2) BEGINS "pi_razao_contabil_demonst":U THEN
        apply "choose" to bt_ent in frame f_bas_10_cta_ctbl_razao.
    &endif
    /* End_Include: ix_p10_bas_cta_ctbl_razao */

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_cta_ctbl_razao.
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


        if  avail cta_ctbl
        then do:
            assign v_rec_cta_ctbl = recid(cta_ctbl).
        end /* if */.
        else do:
            assign v_rec_cta_ctbl = ?.
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
** Procedure Interna.....: pi_retornar_finalid_econ_corren_estab
** Descricao.............: pi_retornar_finalid_econ_corren_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41061
** Alterado em...........: 27/04/2009 08:43:48
*****************************************************************************/
PROCEDURE pi_retornar_finalid_econ_corren_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab
         use-index stblcmnt_id no-error.
    if  avail estabelecimento
    then do:
       find emscad.pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais
             no-error.
       assign p_cod_finalid_econ = pais.cod_finalid_econ_pais.
    end.
END PROCEDURE. /* pi_retornar_finalid_econ_corren_estab */
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
** Procedure Interna.....: pi_retornar_inic_zero
** Descricao.............: pi_retornar_inic_zero
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut35059
** Alterado em...........: 30/01/2006 14:29:38
*****************************************************************************/
PROCEDURE pi_retornar_inic_zero:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_attrib
        as widget-handle
        format ">>>>>>9"
        no-undo.
    def Input param p_cod_format_cta_ctbl
        as character
        format "x(20)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cta_ctbl_000
        as character
        format "x(20)":U
        label "Conta Cont†bil"
        column-label "Conta Cont†bil"
        no-undo.
    def var v_num_count_cta
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count_cta = 1.
           v_cod_cta_ctbl_000 = "".

    contador:
    do while v_num_count_cta <= length(p_cod_format_cta_ctbl):
        if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) <> "-"
        and substring(p_cod_format_cta_ctbl,v_num_count_cta,1) <> "."
        then do:
            if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "!"
            then do:
                assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "9"
                then do:
                    assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "0".
                end /* if */.
                else do:
                    if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "x" /*l_x*/ 
                    then do:
                        assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "0".
                        /* ** Alteraá∆o sob demanda - Ativ 149706 ***/
                    end /* if */.
                    else do:
                        assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + keylabel(32).
                    end /* else */.
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count_cta = v_num_count_cta + 1.
    end /* do contador */.

    assign p_wgh_attrib:format       = 'x(50)'
           p_wgh_attrib:screen-value = v_cod_cta_ctbl_000
           p_wgh_attrib:format       = p_cod_format_cta_ctbl.
END PROCEDURE. /* pi_retornar_inic_zero */
/*****************************************************************************
** Procedure Interna.....: pi_criar_item_lancto_ctbl_cta
** Descricao.............: pi_criar_item_lancto_ctbl_cta
** Criado por............: Henke
** Criado em.............: 03/02/1997 10:31:22
** Alterado por..........: fut35059
** Alterado em...........: 19/07/2006 10:27:28
*****************************************************************************/
PROCEDURE pi_criar_item_lancto_ctbl_cta:

    find first utiliz_cenar_ctbl no-lock
         where utiliz_cenar_ctbl.cod_empresa = v_cod_empres_usuar 
           AND utiliz_cenar_ctbl.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl no-error.
           IF AVAILABLE utiliz_cenar_ctbl THEN DO:
              ASSIGN v_dat_inic_valid = utiliz_cenar_ctbl.dat_inic_valid
                     v_dat_fim_valid  = utiliz_cenar_ctbl.dat_fim_valid.
           END.

    /* ** Criar registros da Temp Table tt_item_lancto_ctbl_razao ***/

    /* Eliminar registros da Temp Table tt_item_lancto_ctbl_razao */
    tt_item_block:
    for
        each tt_item_lancto_ctbl_razao exclusive-lock:
        delete tt_item_lancto_ctbl_razao.
    end /* for tt_item_block */.

    if  not can-find(first finalid_utiliz_cenar 
              where finalid_utiliz_cenar.cod_empresa      = v_cod_unid_organ 
                and finalid_utiliz_cenar.cod_cenar_ctbl   = cenar_ctbl.cod_cenar_ctbl 
                and finalid_utiliz_cenar.cod_finalid_econ = v_cod_finalid_econ_ini)
    then do:

        /* Finalidade econìmica n∆o vinculada ao cen†rio ! */
        run pi_messages (input "show",
                         input 18168,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           v_cod_finalid_econ_ini,cenar_ctbl.cod_cenar_ctbl,v_cod_unid_organ)) /*msg_18168*/.
        return.

    end /* if */.

    /* Apropriaá‰es da Conta Cont†bil */
    estab_un_block:
    for
        each tt_estab_unid_negoc_select no-lock:
        IF v_log_estab_unid_negoc THEN DO:

            item_lancto_ctbl:
             for each item_lancto_ctbl no-lock
                 where item_lancto_ctbl.cod_empresa         = v_cod_unid_organ
                   and item_lancto_ctbl.cod_estab           = tt_estab_unid_negoc_select.cod_estab
                   and item_lancto_ctbl.cod_unid_negoc      = tt_estab_unid_negoc_select.cod_unid_negoc
                   and item_lancto_ctbl.cod_plano_cta_ctbl  = cta_ctbl.cod_plano_cta_ctbl
                   and item_lancto_ctbl.cod_cta_ctbl        = cta_ctbl.cod_cta_ctbl
                   and item_lancto_ctbl.ind_sit_lancto_ctbl = "Ctbz" /*l_contabilizado*/ 
                   and (item_lancto_ctbl.cod_cenar_ctbl     = cenar_ctbl.cod_cenar_ctbl
                   or   item_lancto_ctbl.cod_cenar_ctbl     = "")
                   and item_lancto_ctbl.dat_lancto_ctbl     >= v_dat_inic_period_ctbl_pri
                   and item_lancto_ctbl.dat_lancto_ctbl     <= v_dat_fim_period_ctbl:

                   IF NOT (item_lancto_ctbl.dat_lancto_ctbl >= v_dat_inic_valid and
                           item_lancto_ctbl.dat_lancto_ctbl <= v_dat_fim_valid) THEN
                           next item_lancto_ctbl.

                   /* Considerar o parÉmetro de Apuraá∆o de Resultado -> FUT1082  23/07/2002*/
                   if v_log_consid_apurac_restdo = NO AND
                      item_lancto_ctbl.log_lancto_apurac_restdo = YES
                      then do:
                      next item_lancto_ctbl.
                   end.

                   RUN pi_criar_item_lancto_ctbl_cta_more.
                   IF RETURN-VALUE = 'NOK' THEN
                       next item_lancto_ctbl.
             end /* for item_lancto_ctbl */.
        END.
        ELSE DO:
            item_lancto_ctbl:
            for each item_lancto_ctbl no-lock
                where item_lancto_ctbl.cod_empresa         = v_cod_unid_organ
                  and item_lancto_ctbl.cod_estab           = tt_estab_unid_negoc_select.cod_estab
                  and item_lancto_ctbl.cod_plano_cta_ctbl  = cta_ctbl.cod_plano_cta_ctbl
                  and item_lancto_ctbl.cod_cta_ctbl        = cta_ctbl.cod_cta_ctbl
                  and item_lancto_ctbl.ind_sit_lancto_ctbl = "Ctbz" /*l_contabilizado*/  
                  and (item_lancto_ctbl.cod_cenar_ctbl     = cenar_ctbl.cod_cenar_ctbl
                  or   item_lancto_ctbl.cod_cenar_ctbl     = "")
                  and item_lancto_ctbl.dat_lancto_ctbl     >= v_dat_inic_period_ctbl_pri
                  and item_lancto_ctbl.dat_lancto_ctbl     <= v_dat_fim_period_ctbl:

                  IF NOT (item_lancto_ctbl.dat_lancto_ctbl >= v_dat_inic_valid and
                          item_lancto_ctbl.dat_lancto_ctbl <= v_dat_fim_valid) THEN
                          next item_lancto_ctbl.

                  /* Considerar o parÉmetro de Apuraá∆o de Resultado -> FUT1082  23/07/2002*/
                  if v_log_consid_apurac_restdo = NO AND
                     item_lancto_ctbl.log_lancto_apurac_restdo = YES
                     then do:
                     next item_lancto_ctbl.
                  end.

                  RUN pi_criar_item_lancto_ctbl_cta_more.
                  IF RETURN-VALUE = 'NOK' THEN
                     next item_lancto_ctbl.
            end /* for item_lancto_ctbl */.
        END.
    end /* for estab_un_block */.
END PROCEDURE. /* pi_criar_item_lancto_ctbl_cta */
/*****************************************************************************
** Procedure Interna.....: pi_criar_item_lancto_ctbl_cta_more
** Descricao.............: pi_criar_item_lancto_ctbl_cta_more
** Criado por............: src12337
** Criado em.............: 14/01/2002 11:30:35
** Alterado por..........: fut12196
** Alterado em...........: 01/11/2013 10:22:23
*****************************************************************************/
PROCEDURE pi_criar_item_lancto_ctbl_cta_more:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_ccusto
        for ccusto.
    &endif


    /*************************** Buffer Definition End **************************/

    if  v_des_histor <> "" and index(item_lancto_ctbl.des_histor_lancto_ctbl, v_des_histor) = 0
    then do:
        RETURN "NOK" /*l_nok*/ .
    end /* if */.

    if item_lancto_ctbl.cod_plano_ccusto <> '' 
         AND item_lancto_ctbl.cod_ccusto <> '' THEN DO:

        find first tt_ccusto no-lock
            where  tt_ccusto.cod_empresa        = v_cod_empres_usuar
              and  tt_ccusto.cod_plano_ccusto   = item_lancto_ctbl.cod_plano_ccusto
              and  tt_ccusto.cod_ccusto         = item_lancto_ctbl.cod_ccusto no-error.
        if  not avail tt_ccusto
        then do:
            IF CAN-FIND(FIRST tt_ccusto_sem_permissao
                        WHERE tt_ccusto_sem_permissao.tta_cod_empresa      = v_cod_empres_usuar
                        AND   tt_ccusto_sem_permissao.tta_cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                        AND   tt_ccusto_sem_permissao.tta_cod_ccusto       = item_lancto_ctbl.cod_ccusto) THEN DO:
                return "NOK" /*l_nok*/ . /* Caso exista a tt_ccusto_sem_permissao significa que o centro de custo j† foi lido em item anterior e n∆o tem permiss∆o*/
            END.
            FIND FIRST b_ccusto
                 WHERE b_ccusto.cod_empresa      = v_cod_empres_usuar
                 AND   b_ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                 AND   b_ccusto.cod_ccusto       = item_lancto_ctbl.cod_ccusto
                    NO-LOCK NO-ERROR.
            IF AVAIL b_ccusto THEN DO:
                run pi_verifica_segur_ccusto (buffer b_ccusto,       
                                              output v_log_return).
                IF v_log_return THEN DO:
                    CREATE tt_ccusto.                                          
                    ASSIGN tt_ccusto.ttv_rec_ccusto     = recid(b_ccusto)            
                           tt_ccusto.cod_empresa        = b_ccusto.cod_empresa          
                           tt_ccusto.cod_plano_ccusto   = b_ccusto.cod_plano_ccusto
                           tt_ccusto.cod_ccusto         = b_ccusto.cod_ccusto.            
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST tt_ccusto_sem_permissao
                                    WHERE tt_ccusto_sem_permissao.tta_cod_empresa      = v_cod_empres_usuar
                                    AND   tt_ccusto_sem_permissao.tta_cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                                    AND   tt_ccusto_sem_permissao.tta_cod_ccusto       = item_lancto_ctbl.cod_ccusto) then do:
                        create tt_ccusto_sem_permissao.
                        assign tt_ccusto_sem_permissao.tta_cod_empresa      = v_cod_empres_usuar               
                               tt_ccusto_sem_permissao.tta_cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                               tt_ccusto_sem_permissao.tta_cod_ccusto       = item_lancto_ctbl.cod_ccusto.
                    end.
                    return "NOK" /*l_nok*/ .
                END.
            END.
        end.     
    END.

    find finalid_utiliz_cenar where 
         finalid_utiliz_cenar.cod_empresa    = v_cod_unid_organ and
         finalid_utiliz_cenar.cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl and
         finalid_utiliz_cenar.cod_finalid_econ = v_cod_finalid_econ_ini no-lock no-error.
    if  avail finalid_utiliz_cenar
    then do:
        if  item_lancto_ctbl.cod_indic_econ <> v_cod_indic_econ_base
        then do:
                find first aprop_lancto_ctbl no-lock
                    where aprop_lancto_ctbl.num_lote_ctbl       = item_lancto_ctbl.num_lote_ctbl
                      and aprop_lancto_ctbl.num_lancto_ctbl     = item_lancto_ctbl.num_lancto_ctbl
                      and aprop_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl
                      and aprop_lancto_ctbl.cod_finalid_econ    = v_cod_finalid_econ_ini no-error.
                if  not avail aprop_lancto_ctbl then RETURN 'NOK'.
                else do:
                    create tt_item_lancto_ctbl_razao.
                    assign tt_item_lancto_ctbl_razao.tta_dat_lancto_ctbl           = item_lancto_ctbl.dat_lancto_ctbl
                           tt_item_lancto_ctbl_razao.tta_num_lote_ctbl             = item_lancto_ctbl.num_lote_ctbl
                           tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl           = item_lancto_ctbl.num_lancto_ctbl
                           tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl       = item_lancto_ctbl.num_seq_lancto_ctbl
                           tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl_cpart = item_lancto_ctbl.num_seq_lancto_ctbl_cpart
                           tt_item_lancto_ctbl_razao.tta_des_histor_lancto_ctbl    = item_lancto_ctbl.des_histor_lancto_ctbl.
                    if  item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" /*l_db*/  
                    then do:
                        assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db = fnAjustDec(aprop_lancto_ctbl.val_lancto_ctbl
                                                                             / v_val_cotac_indic_econ, v_cod_moed_finalid).
                    end /* if */.
                    else do:
                        assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr = fnAjustDec((aprop_lancto_ctbl.val_lancto_ctbl * -1)
                                                                             / v_val_cotac_indic_econ, v_cod_moed_finalid).
                    end /* else */.
                end /* if */.
        end /* if */.
        else do:
            create tt_item_lancto_ctbl_razao.
            assign tt_item_lancto_ctbl_razao.tta_dat_lancto_ctbl           = item_lancto_ctbl.dat_lancto_ctbl
                   tt_item_lancto_ctbl_razao.tta_num_lote_ctbl             = item_lancto_ctbl.num_lote_ctbl
                   tt_item_lancto_ctbl_razao.tta_num_lancto_ctbl           = item_lancto_ctbl.num_lancto_ctbl
                   tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl       = item_lancto_ctbl.num_seq_lancto_ctbl
                   tt_item_lancto_ctbl_razao.tta_num_seq_lancto_ctbl_cpart = item_lancto_ctbl.num_seq_lancto_ctbl_cpart
                   tt_item_lancto_ctbl_razao.tta_des_histor_lancto_ctbl    = item_lancto_ctbl.des_histor_lancto_ctbl.
            if  item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" /*l_db*/ 
            then do:
                assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db = fnAjustDec(item_lancto_ctbl.val_lancto_ctbl
                                                                     / v_val_cotac_indic_econ, v_cod_moed_finalid).
            end /* if */.
            else do:
                assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr = fnAjustDec((item_lancto_ctbl.val_lancto_ctbl * -1)
                                                                     / v_val_cotac_indic_econ, v_cod_moed_finalid).
            end /* else */.
        end /* else */.
        If tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db = ? then
           assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db = 0.
        If tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr = ? then
           assign tt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr = 0. 

        if  v_log_funcao_lista_cta_cpart and item_lancto_ctbl.num_seq_lancto_ctbl_cpart <> 0
        then do:
            find first b_item_lancto_ctbl use-index tmlnctcb_id
                 where b_item_lancto_ctbl.num_lote_ctbl       = item_lancto_ctbl.num_lote_ctbl
                   and b_item_lancto_ctbl.num_lancto_ctbl     = item_lancto_ctbl.num_lancto_ctbl
                   and b_item_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl_cpart
                   no-lock no-error.
            if  avail b_item_lancto_ctbl then
                assign tt_item_lancto_ctbl_razao.ttv_cod_cta_ctbl_cpart = STRING(b_item_lancto_ctbl.cod_cta_ctbl,plano_cta_ctbl.cod_format_cta_ctbl).
        end.  
    end /* if */.

END PROCEDURE. /* pi_criar_item_lancto_ctbl_cta_more */
/*****************************************************************************
** Procedure Interna.....: pi_open_bas_cta_ctbl_razao
** Descricao.............: pi_open_bas_cta_ctbl_razao
** Criado por............: Henke
** Criado em.............: 26/12/1995 16:23:17
** Alterado por..........: fut41162
** Alterado em...........: 01/02/2010 16:56:00
*****************************************************************************/
PROCEDURE pi_open_bas_cta_ctbl_razao:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_item_lancto_ctbl_razao
        for tt_item_lancto_ctbl_razao.
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_item_lancto_ctbl
        for item_lancto_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_busca_sdo
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_val_sdo_ctbl_fim = 0
           v_val_sdo_ctbl_db  = 0
           v_val_sdo_ctbl_cr  = 0
           v_val_sdo_ctbl_inic_ant = 0
           v_log_cta_restdo_acum = no.
    /* --- Saldo Anterior ---*/
    assign v_log_busca_sdo = yes.
    find first period_ctbl
         where period_ctbl.cod_cenar_ctbl  = v_cod_cenar_ctbl_ini
         and   period_ctbl.cod_exerc_ctbl  = string(year(v_dat_inic_period_ctbl_pri),"9999")
         and   period_ctbl.num_period_ctbl = 1
         no-lock no-error.
    if avail period_ctbl then do:
       if month(period_ctbl.dat_inic_period_ctbl) = month(v_dat_inic_period_ctbl_pri) then do:
          find first grp_cta_ctbl
               where grp_cta_ctbl.cod_tip_grp_cta_ctbl     = cta_ctbl.cod_tip_grp_cta_ctbl
               and   grp_cta_ctbl.cod_grp_cta_ctbl         = cta_ctbl.cod_grp_cta_ctbl
               and   grp_cta_ctbl.log_consid_apurac_restdo = yes
               no-lock no-error.
          if avail grp_cta_ctbl then do:
             assign v_log_busca_sdo = no.
          end.   
          else do:
              /* 232341 - alteraá∆o j† efetuada no raz∆o (fgl304ad - 219382) */
              /* Quando NaO CONSIDERA APURAcaO de resultados para CONTAS DE RESULTADOS (PL).     */
              /* O valor com apuraªío sempre DEVE ser considerado no SALDO INICIAL (somente em janeiro).  */
              find first grp_cta_ctbl no-lock
                  where grp_cta_ctbl.cod_tip_grp_cta_ctbl     = cta_ctbl.cod_tip_grp_cta_ctbl
                  and   grp_cta_ctbl.cod_grp_cta_ctbl         = cta_ctbl.cod_grp_cta_ctbl
                  and   grp_cta_ctbl.log_consid_apurac_restdo = no no-error.
              if avail grp_cta_ctbl and v_log_consid_apurac_restdo = no and month(v_dat_inic_period_ctbl_pri) = 1 then
                  assign  v_log_cta_restdo_acum = yes.
          end.
          if not v_log_busca_sdo and day(v_dat_inic_period_ctbl_pri) <> 01 then do:
              find first b_item_lancto_ctbl
                   where b_item_lancto_ctbl.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                   and   b_item_lancto_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
                   and   b_item_lancto_ctbl.dat_lancto_ctbl   >= date(month(v_dat_inic_period_ctbl_pri),01,year(v_dat_inic_period_ctbl_pri))
                   and   b_item_lancto_ctbl.dat_lancto_ctbl    < v_dat_inic_period_ctbl_pri no-lock no-error.
                if avail b_item_lancto_ctbl then
                    assign v_log_busca_sdo = yes.          
          end.
       end.
    end.
    if v_log_busca_sdo then do:
       run prgfin/fgl/fgl905za.py (Input 1,
                                   Input v_cod_unid_organ,
                                   Input v_cod_cenar_ctbl_ini,
                                   Input v_cod_finalid_econ_ini,
                                   Input cta_ctbl.cod_plano_cta_ctbl,
                                   Input cta_ctbl.cod_cta_ctbl,
                                   Input "",
                                   Input "",
                                   Input "",
                                   Input "",
                                   Input v_dat_inic_period_ctbl_pri - 1,
                                   Input v_dat_inic_period_ctbl_pri - 1,
                                   Input no,
                                   Input v_log_consid_apurac_restdo,
                                   Input no,
                                   input-output table tt_erro_relatorio_razao) /*prg_api_sdo_cta_ctbl*/.
    end.                          
    find first tt_sdo_ctbl exclusive-lock no-error.
    if  avail tt_sdo_ctbl
    then do:
        assign v_val_sdo_ctbl_inic_ant = fnAjustDec(tt_sdo_ctbl.tta_val_sdo_ctbl_fim / v_val_cotac_indic_econ, v_cod_moed_finalid).
        delete tt_sdo_ctbl.
    end /* if */.
    /* --- Atualiza Sdo Fim ---*/
    tt_item_block:
    for
       each btt_item_lancto_ctbl_razao exclusive-lock:
        assign v_val_sdo_ctbl_db = v_val_sdo_ctbl_db + btt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_db
               v_val_sdo_ctbl_cr = v_val_sdo_ctbl_cr + btt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_cr
               btt_item_lancto_ctbl_razao.ttv_val_sdo_ctbl_fim = v_val_sdo_ctbl_inic_ant
                                                              + v_val_sdo_ctbl_db
                                                              + v_val_sdo_ctbl_cr.
    end /* for tt_item_block */.
    assign v_val_sdo_ctbl_fim = v_val_sdo_ctbl_inic_ant + v_val_sdo_ctbl_db + v_val_sdo_ctbl_cr.

    If v_val_sdo_ctbl_inic_ant = ? then
       assign v_val_sdo_ctbl_inic_ant = 0.
    If v_val_sdo_ctbl_db = ? then
       assign v_val_sdo_ctbl_db = 0.
    If v_val_sdo_ctbl_cr = ? then
       assign v_val_sdo_ctbl_cr = 0.
    If v_val_sdo_ctbl_fim = ? then
       assign v_val_sdo_ctbl_fim = 0.       

    /* if can-find(first tt_item_lancto_ctbl_razao)
       and v_des_unid_negoc_faixa <> "" then
        @cx_message(12686, v_des_unid_negoc_faixa).*/

    if  v_log_funcao_lista_cta_cpart
    then do:
        close query qr_bas_cta_ctbl_razao_1.
        open query qr_bas_cta_ctbl_razao_1 for
            each tt_item_lancto_ctbl_razao no-lock.

        enable br_bas_cta_ctbl_razao_1
               with frame f_bas_10_cta_ctbl_razao.
        apply "value-changed" to br_bas_cta_ctbl_razao_1 in frame f_bas_10_cta_ctbl_razao.
    end.
    else do:
        close query qr_bas_cta_ctbl_razao.
        open query qr_bas_cta_ctbl_razao for
            each tt_item_lancto_ctbl_razao no-lock.

        enable br_bas_cta_ctbl_razao
               with frame f_bas_10_cta_ctbl_razao.
        apply "value-changed" to br_bas_cta_ctbl_razao in frame f_bas_10_cta_ctbl_razao.
    end.

    display abs(v_val_sdo_ctbl_cr) @ v_val_sdo_ctbl_cr
            v_val_sdo_ctbl_db
            v_val_sdo_ctbl_fim
            v_val_sdo_ctbl_inic_ant 
            with frame f_bas_10_cta_ctbl_razao.
END PROCEDURE. /* pi_open_bas_cta_ctbl_razao */
/*****************************************************************************
** Procedure Interna.....: pi_selecionar_unid_organ
** Descricao.............: pi_selecionar_unid_organ
** Criado por............: Henke
** Criado em.............: 09/01/1996 14:33:42
** Alterado por..........: si1768
** Alterado em...........: 04/10/2013 13:07:54
*****************************************************************************/
PROCEDURE pi_selecionar_unid_organ:

    /************************* Variable Definition Begin ************************/

    def var v_log_plano_ccusto_uni
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    find emscad.unid_organ no-lock
        where recid(unid_organ) = v_rec_unid_organ no-error.
    if  avail unid_organ
    then do:
        /* Plano de Contas Cont†beis do Usu†rio (tt_plano_cta_ctbl) */
        run pi_criar_plano_cta_ctbl_usuar (output v_log_plano_cta_ctbl_uni) /*pi_criar_plano_cta_ctbl_usuar*/.
        if  v_log_plano_cta_ctbl_uni = ?
        then do:
            /* Usu†rio n∆o possui permiss∆o de acesso a Plano de Contas. */
            run pi_messages (input "show",
                             input 1944,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               unid_organ.cod_unid_organ)) /*msg_1944*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        /* Vers‰es de Oráamento do Usu†rio (tt_vers_orcto_ctbl) */
        run pi_criar_vers_orcto_ctbl_usuar (output v_log_vers_orcto_ctbl) /*pi_criar_vers_orcto_ctbl_usuar*/.

        /* Centros de Custo do Usu†rio */
        if  unid_organ.num_niv_unid_organ = 998
        then do:
            find emscad.empresa no-lock
                 where empresa.cod_empresa = unid_organ.cod_unid_organ no-error.
            find plano_ccusto no-lock
                where plano_ccusto.cod_empresa      = empresa.cod_empresa
                and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_corren no-error.
            if  not avail plano_ccusto
            then do:

                run pi_retornar_plano_ccusto_ult (Input empresa.cod_empresa,
                                                  Input today,
                                                  output v_cod_plano_ccusto_corren,
                                                  output v_log_plano_ccusto_uni) /*pi_retornar_plano_ccusto_ult*/.

                find plano_ccusto no-lock
                    where plano_ccusto.cod_empresa      = empresa.cod_empresa
                    and   plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_corren no-error.

            end /* if */.
            if  avail plano_ccusto
            then do:
                assign v_rec_plano_ccusto = recid(plano_ccusto).
                if not Verifica_Program_Name('ESCF0208':U,1) or (Verifica_Program_Name('ESCF0208':U,1)
                and Verifica_Program_Name('fgl209aa':U,10)) then  
                    run pi_criar_ccusto_usuar (Input v_cod_usuar_corren) /*pi_criar_ccusto_usuar*/.
            end /* if */.
        end /* if */.

        /* Faixa de Unidades Organizacionais */
        &if defined(BF_FIN_REESTRUT_SOCIETARIA) &then
        IF v_log_funcao_histor_estrut = YES THEN DO:

            FOR EACH estrut_unid_organ NO-LOCK
               WHERE estrut_unid_organ.cod_unid_organ_pai = unid_organ.cod_unid_organ:

                IF estrut_unid_organ.dat_inic_valid >  v_dat_fim_period_ctbl OR
                   estrut_unid_organ.dat_fim_valid < v_dat_inic_period_ctbl_pri THEN NEXT.

                find first unid_organ no-lock
                     where unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho no-error.
                run pi_criar_unid_organ_usuar (Input unid_organ.num_niv_unid_organ,
                                               Input estrut_unid_organ.cod_unid_organ_pai) /* pi_criar_unid_organ_usuar*/.

                find unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
                unid_organ:
                for each tt_unid_organ exclusive-lock:
                    find first b_estrut_unid_organ no-lock
                         where b_estrut_unid_organ.cod_unid_organ_pai   = unid_organ.cod_unid_organ
                           and b_estrut_unid_organ.cod_unid_organ_filho = tt_unid_organ.cod_unid_organ no-error.
                    if  not avail b_estrut_unid_organ then
                        delete tt_unid_organ.
                end /* for unid_organ */.

                if  unid_organ.num_niv_unid_organ = 998
                then do:
                    find first tt_unid_organ no-lock no-error.
                    if  avail tt_unid_organ
                    then do:
                        if  v_log_changed_unid_organ = yes
                        then do: /* Caso mudou Unidade Organizacional */
                            assign v_cod_estab_ini = tt_unid_organ.cod_unid_organ.
                            find last tt_unid_organ no-lock no-error.
                            assign v_cod_estab_fim = tt_unid_organ.cod_unid_organ.
                        end /* if */.
                    end /* if */.
                    else do:
                        /* Usuˇrio &1 sem permissío para acessar UOãs da &2 ! */
                        run pi_messages (input 'show',
                                         input 4688,
                                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                            v_cod_usuar_corren, unid_organ.cod_unid_organ)) /* msg_4688*/.
                        return 'NOK' /* l_nok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    find first tt_unid_organ no-lock no-error.
                    if  avail tt_unid_organ
                    then do:
                        if  v_log_changed_unid_organ = yes
                        then do: /* Caso mudou Unidade Organizacional */
                            if  v_cod_unid_organ_ini = ''
                            then do:
                               assign v_cod_unid_organ_ini = tt_unid_organ.cod_unid_organ.
                            end /* if */.
                            if  v_cod_unid_organ_fim = 'ZZZ'
                            then do:
                               find last tt_unid_organ no-lock no-error.
                               assign v_cod_unid_organ_fim = tt_unid_organ.cod_unid_organ.
                            end /* if */.                          
                        end /* if */.
                    end /* if */.
                    else do:
                        /* Usuˇrio &1 sem permissío para acessar UOãs da &2 ! */
                        run pi_messages (input 'show',
                                         input 4688,
                                         input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',
                                                            v_cod_usuar_corren, unid_organ.cod_unid_organ)) /* msg_4688*/.
                        return 'NOK' /* l_nok*/ .
                    end /* else */.
                end /* else */.

            end.
        end.
        else do:
        &ENDIF 

        find first emscad.estrut_unid_organ no-lock
            where estrut_unid_organ.cod_unid_organ_pai = unid_organ.cod_unid_organ
            no-error.
        if  avail estrut_unid_organ
        then do:
            find first unid_organ no-lock
               where unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho no-error.
            run pi_criar_unid_organ_usuar (Input unid_organ.num_niv_unid_organ,
                                           Input estrut_unid_organ.cod_unid_organ_pai) /*pi_criar_unid_organ_usuar*/.

            find unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
            unid_organ:
            for each tt_unid_organ exclusive-lock:
                find first b_estrut_unid_organ no-lock
                   where b_estrut_unid_organ.cod_unid_organ_pai   = unid_organ.cod_unid_organ
                     and b_estrut_unid_organ.cod_unid_organ_filho = tt_unid_organ.cod_unid_organ no-error.
                if  not avail b_estrut_unid_organ then
                    delete tt_unid_organ.
            end /* for unid_organ */.

            if  unid_organ.num_niv_unid_organ = 998
            then do:
                find first tt_unid_organ no-lock no-error.
                if  avail tt_unid_organ
                then do:
                    if  v_log_changed_unid_organ = yes
                    then do: /* Caso mudou Unidade Organizacional */
                        assign v_cod_estab_ini = tt_unid_organ.cod_unid_organ.
                        find last tt_unid_organ no-lock no-error.
                        assign v_cod_estab_fim = tt_unid_organ.cod_unid_organ.
                    end /* if */.
                end /* if */.
                else do:
                    /* Usu†rio &1 sem permiss∆o para acessar UOÔs da &2 ! */
                    run pi_messages (input "show",
                                     input 4688,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        v_cod_usuar_corren, unid_organ.cod_unid_organ)) /*msg_4688*/.
                    return "NOK" /*l_nok*/ .
                end /* else */.
            end /* if */.
            else do:
                find first tt_unid_organ no-lock no-error.
                if  avail tt_unid_organ
                then do:
                    if  v_log_changed_unid_organ = yes
                    then do: /* Caso mudou Unidade Organizacional */
                        if  v_cod_unid_organ_ini = ""
                        then do:
                           assign v_cod_unid_organ_ini = tt_unid_organ.cod_unid_organ.
                        end /* if */.
                        if  v_cod_unid_organ_fim = "ZZZ"
                        then do:
                           find last tt_unid_organ no-lock no-error.
                           assign v_cod_unid_organ_fim = tt_unid_organ.cod_unid_organ.
                        end /* if */.                          
                    end /* if */.
                end /* if */.
                else do:
                    /* Usu†rio &1 sem permiss∆o para acessar UOÔs da &2 ! */
                    run pi_messages (input "show",
                                     input 4688,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                        v_cod_usuar_corren, unid_organ.cod_unid_organ)) /*msg_4688*/.
                    return "NOK" /*l_nok*/ .
                end /* else */.
            end /* else */.
        end /* if */.
        else do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               "Estrutura Unid Organizacional","Unidades Organizacionais")) /*msg_1284*/.
            return "NOK" /*l_nok*/ .
        end /* else */.

        &if defined(BF_FIN_REESTRUT_SOCIETARIA) &then
        end.
        &endif

        /* Verifica se UO utiliza funá∆o Unid Negoc */
        /* Deve apresentar os valores independente se a empresa utiliza ou n∆o unidade de neg¢cio FO:769080*/
        /* @run (pi_verifica_utiliz_funcao('BU', unid_organ.cod_unid_organ, v_log_estab_unid_negoc)).*/
        assign v_log_estab_unid_negoc = yes.

        /* Unidades de Neg¢cio */
        if  v_log_estab_unid_negoc = yes
        then do:
            run pi_criar_unid_negoc_faixa /*pi_criar_unid_negoc_faixa*/.

            find first tt_unid_negoc no-lock no-error.
            if  avail tt_unid_negoc
            then do:
                if  v_log_changed_unid_organ = yes
                then do: /* Caso mudou Unidade Organizacional */
                    if  v_cod_unid_negoc_ini = ""
                    then do:
                        assign v_cod_unid_negoc_ini = tt_unid_negoc.cod_unid_negoc.
                    end /* if */.

                    if  v_cod_unid_negoc_fim = "ZZZ"
                    then do:
                        find last tt_unid_negoc no-lock no-error.
                        assign v_cod_unid_negoc_fim = tt_unid_negoc.cod_unid_negoc.
                    end /* if */.
                end /* if */.
            end /* if */.
            else do:
                /* Usu†rio n∆o possui permiss∆o de acesso a Unid Negoc. */
                run pi_messages (input "show",
                                 input 1964,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1964*/.
                return "NOK" /*l_nok*/ .
            end /* else */.
        end /* if */.

        /* Verifica se a Faixa de UO ou de Unid Negoc n∆o Ç irregular */
        assign v_rec_unid_organ_aux = v_rec_unid_organ.
        run pi_verifica_faixa_sdo_cta_ctbl /*pi_verifica_faixa_sdo_cta_ctbl*/.
        assign v_log_changed_unid_organ = no.
    end /* if */.
END PROCEDURE. /* pi_selecionar_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_criar_plano_cta_ctbl_usuar
** Descricao.............: pi_criar_plano_cta_ctbl_usuar
** Criado por............: Henke
** Criado em.............: 08/02/1996 17:00:20
** Alterado por..........: Henke
** Alterado em...........: 10/02/1996 17:05:44
*****************************************************************************/
PROCEDURE pi_criar_plano_cta_ctbl_usuar:

    /************************ Parameter Definition Begin ************************/

    def output param p_log_plano_cta_ctbl_uni
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_ocor
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    delete_block:
    for
        each tt_plano_cta_ctbl exclusive-lock:
        delete tt_plano_cta_ctbl.
    end /* for delete_block */.

    find emscad.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
    if  avail unid_organ
    then do:
        plano_cta_unid_organ:
        for
            each plano_cta_unid_organ no-lock
            where plano_cta_unid_organ.cod_unid_organ = unid_organ.cod_unid_organ
            :
            run pi_verifica_segur_plano_cta_ctbl (Input plano_cta_unid_organ.cod_plano_cta_ctbl,
                                                  Input plano_cta_unid_organ.cod_unid_organ,
                                                  output v_log_return) /*pi_verifica_segur_plano_cta_ctbl*/.
            if  v_log_return = no
            then do:
                next plano_cta_unid_organ.
            end /* if */.
            find first plano_cta_ctbl no-lock
                 where plano_cta_ctbl.cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl
                  no-error.
            create tt_plano_cta_ctbl.
            assign v_num_ocor = v_num_ocor + 1
                   tt_plano_cta_ctbl.ttv_rec_plano_cta_ctbl = recid(plano_cta_ctbl)
                   tt_plano_cta_ctbl.cod_plano_cta_ctbl     = plano_cta_ctbl.cod_plano_cta_ctbl
                   tt_plano_cta_ctbl.ind_tip_plano_cta_ctbl = plano_cta_ctbl.ind_tip_plano_cta_ctbl.
        end /* for plano_cta_unid_organ */.
    end /* if */.
    if  v_num_ocor > 1
    then do:
        assign p_log_plano_cta_ctbl_uni = no.
    end /* if */.
    else do:
        if  v_num_ocor = 1
        then do:
            assign p_log_plano_cta_ctbl_uni = yes.
        end /* if */.
        else do:  /* Nenhuma Ocorrància */
            assign p_log_plano_cta_ctbl_uni = ?.
        end /* else */.
    end /* else */.
END PROCEDURE. /* pi_criar_plano_cta_ctbl_usuar */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_plano_cta_ctbl
** Descricao.............: pi_verifica_segur_plano_cta_ctbl
** Criado por............: Henke
** Criado em.............: 08/02/1996 16:31:20
** Alterado por..........: BRE17264
** Alterado em...........: 04/05/1999 15:28:42
*****************************************************************************/
PROCEDURE pi_verifica_segur_plano_cta_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    find first plano_cta_unid_organ no-lock
         where plano_cta_unid_organ.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
           and plano_cta_unid_organ.cod_unid_organ = p_cod_unid_organ /*cl_retorna_plano_cta_validos of plano_cta_unid_organ*/ no-error.
    loop_block:
    for
       each segur_plano_cta_ctbl no-lock
       where segur_plano_cta_ctbl.cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl
         and segur_plano_cta_ctbl.cod_unid_organ = plano_cta_unid_organ.cod_unid_organ
       :
       find first usuar_grp_usuar no-lock
            where usuar_grp_usuar.cod_grp_usuar = segur_plano_cta_ctbl.cod_grp_usuar
              and usuar_grp_usuar.cod_usuario = v_cod_usuar_corren /*cl_permissao_plano_cta of usuar_grp_usuar*/ no-error.
       if  avail usuar_grp_usuar or segur_plano_cta_ctbl.cod_grp_usuar = "*" /*l_**/ 
       then do:
           assign p_log_return = yes.
           leave loop_block.
           /* tem permiss∆o*/
       end /* if */.
    end /* for loop_block */.
END PROCEDURE. /* pi_verifica_segur_plano_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_criar_ccusto_usuar
** Descricao.............: pi_criar_ccusto_usuar
** Criado por............: Henke
** Criado em.............: 10/02/1996 14:24:40
** Alterado por..........: fut35183
** Alterado em...........: 18/02/2009 15:15:59
*****************************************************************************/
PROCEDURE pi_criar_ccusto_usuar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_usuario
        as character
        format "x(12)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    find plano_ccusto where recid(plano_ccusto) = v_rec_plano_ccusto no-lock no-error.
    if  not avail plano_ccusto
    then do:
        /* &1 inexistente ! */
        run pi_messages (input "show",
                         input 1284,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           "Plano Centros Custo","Planos Centros Custo")) /*msg_1284*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  not can-find(first segur_ccusto
                 where segur_ccusto.cod_empresa = plano_ccusto.cod_empresa
                   and segur_ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
                   and segur_ccusto.cod_grp_usuar = "*" /*l_**/ )
    then do:
        usuar_grp_usuar:
        for
           each usuar_grp_usuar no-lock
           where usuar_grp_usuar.cod_usuario = p_cod_usuario /*cl_p_cod_usuario of usuar_grp_usuar*/:
           if  can-find(first segur_ccusto
                   where segur_ccusto.cod_empresa = plano_ccusto.cod_empresa
                     and segur_ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
                     and segur_ccusto.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar /*cl_usuar_corren of segur_ccusto*/)
                   then do:
               assign v_log_return = yes.
               leave usuar_grp_usuar.
           end /* if */.
        end /* for usuar_grp_usuar */.
        if  v_log_return = no
        then do:
            /* Usu†rio n∆o possui permiss∆o de acesso a Centros de Custo. */
            run pi_messages (input "show",
                             input 1955,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                               plano_ccusto.cod_plano_ccusto)) /*msg_1955*/.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* if */.

    delete_block:
    for
        each tt_ccusto exclusive-lock:
        delete tt_ccusto.
    end /* for delete_block */.

    ccusto:
    for each ccusto no-lock
     where ccusto.cod_empresa = plano_ccusto.cod_empresa
       and ccusto.cod_plano_ccusto = plano_ccusto.cod_plano_ccusto
     :
        run pi_verifica_segur_ccusto (buffer ccusto,
                                      output v_log_return) /*pi_verifica_segur_ccusto*/.
        if  v_log_return = no
        then do:
            next ccusto.
        end /* if */.
        create tt_ccusto.
        assign tt_ccusto.ttv_rec_ccusto   = recid(ccusto)
               tt_ccusto.cod_empresa      = ccusto.cod_empresa
               tt_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
               tt_ccusto.cod_ccusto       = ccusto.cod_ccusto
               tt_ccusto.des_tit_ctbl     = ccusto.des_tit_ctbl.
    end /* for ccusto */.





END PROCEDURE. /* pi_criar_ccusto_usuar */
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
        for ccusto.
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
** Procedure Interna.....: pi_criar_unid_organ_usuar
** Descricao.............: pi_criar_unid_organ_usuar
** Criado por............: Henke
** Criado em.............: 12/02/1996 15:10:00
** Alterado por..........: si1768
** Alterado em...........: 04/10/2013 11:39:41
*****************************************************************************/
PROCEDURE pi_criar_unid_organ_usuar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_niv_unid_organ
        as integer
        format ">>9"
        no-undo.
    def Input param p_cod_unid_organ_pai
    &IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    delete_block:
    for
        each tt_unid_organ exclusive-lock:
        delete tt_unid_organ.
    end /* for delete_block */.

    find first emscad.unid_organ no-lock
         where unid_organ.cod_unid_organ = p_cod_unid_organ_pai /*cl_p_cod_unid_organ_pai of unid_organ*/ no-error.
    if  avail unid_organ
    then do:
        estrut_unid_organ:
        for
            each emscad.estrut_unid_organ no-lock
            where estrut_unid_organ.cod_unid_organ_pai = unid_organ.cod_unid_organ
            :

            &if defined(BF_FIN_REESTRUT_SOCIETARIA) &then
               if  v_log_funcao_histor_estrut = yes
               then do:
                   if  estrut_unid_organ.dat_inic_valid > v_dat_fim_period_ctbl OR
                       estrut_unid_organ.dat_fim_valid < v_dat_inic_period_ctbl_pri
                   then do: 
                       next estrut_unid_organ.
                   end /* if */.
               end /* if */.

            &endif    



            find first unid_organ no-lock
                 where unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho
                  no-error.
            run pi_verifica_segur_unid_organ (buffer unid_organ,
                                              output v_log_return) /*pi_verifica_segur_unid_organ*/.
            if  v_log_return = no
            then do:
                next estrut_unid_organ.
            end /* if */.

            find first tt_unid_organ no-lock where tt_unid_Organ.cod_unid_Organ = unid_organ.cod_unid_organ no-error.
            if not available tt_unid_organ then do:
                create tt_unid_organ.
                assign tt_unid_organ.ttv_rec_unid_organ = recid(unid_organ)
                       tt_unid_organ.cod_unid_organ     = unid_organ.cod_unid_organ
                       tt_unid_organ.des_unid_organ     = unid_organ.des_unid_organ
                       tt_unid_organ.cod_tip_unid_organ = unid_organ.cod_tip_unid_organ
                       tt_unid_organ.num_niv_unid_organ = unid_organ.num_niv_unid_organ
                       tt_unid_organ.dat_inic_valid     = unid_organ.dat_inic_valid
                       tt_unid_organ.dat_fim_valid      = unid_organ.dat_fim_valid.
            end.
        end /* for estrut_unid_organ */.
    end /* if */.
    else do:
        unid_organ:
        for
            each unid_organ no-lock:
            if  p_num_niv_unid_organ = 0 or
                p_num_niv_unid_organ = ? or
                p_num_niv_unid_organ = unid_organ.num_niv_unid_organ
            then do:
                run pi_verifica_segur_unid_organ (buffer unid_organ,
                                                  output v_log_return) /*pi_verifica_segur_unid_organ*/.
            end /* if */.
            else do:
                next unid_organ.
            end /* else */.
            if  v_log_return = no
            then do:
                next unid_organ.
            end /* if */.

            find first tt_unid_organ no-lock where tt_unid_Organ.cod_unid_Organ = unid_organ.cod_unid_organ no-error.
            if not available tt_unid_organ then do:        
                create tt_unid_organ.
                assign tt_unid_organ.ttv_rec_unid_organ = recid(unid_organ)
                       tt_unid_organ.cod_unid_organ     = unid_organ.cod_unid_organ
                       tt_unid_organ.des_unid_organ     = unid_organ.des_unid_organ
                       tt_unid_organ.cod_tip_unid_organ = unid_organ.cod_tip_unid_organ
                       tt_unid_organ.num_niv_unid_organ = unid_organ.num_niv_unid_organ
                       tt_unid_organ.dat_inic_valid     = unid_organ.dat_inic_valid
                       tt_unid_organ.dat_fim_valid      = unid_organ.dat_fim_valid.    
            end.
        end /* for unid_organ */.
    end /* else */.
END PROCEDURE. /* pi_criar_unid_organ_usuar */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_unid_organ
** Descricao.............: pi_verifica_segur_unid_organ
** Criado por............: Henke
** Criado em.............: 06/02/1996 09:53:41
** Alterado por..........: Reis
** Alterado em...........: 13/09/1999 14:02:37
*****************************************************************************/
PROCEDURE pi_verifica_segur_unid_organ:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_unid_organ
        for emscad.unid_organ.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    loop_block:
    for
       each emscad.segur_unid_organ no-lock
       where segur_unid_organ.cod_unid_organ = p_unid_organ.cod_unid_organ
       :
       find first usuar_grp_usuar no-lock
            where usuar_grp_usuar.cod_grp_usuar = segur_unid_organ.cod_grp_usuar
              and usuar_grp_usuar.cod_usuario = v_cod_usuar_corren /*cl_permissao_unid_organ of usuar_grp_usuar*/ no-error.
       if  avail usuar_grp_usuar or segur_unid_organ.cod_grp_usuar = "*"
       then do:
           assign p_log_return = yes.
           leave loop_block.
           /* tem permiss∆o*/
       end /* if */.
    end /* for loop_block */.
END PROCEDURE. /* pi_verifica_segur_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_criar_vers_orcto_ctbl_usuar
** Descricao.............: pi_criar_vers_orcto_ctbl_usuar
** Criado por............: Henke
** Criado em.............: 09/02/1996 08:19:08
** Alterado por..........: Henke
** Alterado em...........: 10/02/1996 18:15:10
*****************************************************************************/
PROCEDURE pi_criar_vers_orcto_ctbl_usuar:

    /************************ Parameter Definition Begin ************************/

    def output param p_log_vers_orcto_ctbl
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_ocor
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* Vers‰es de Oráamentos do Usu†rio Corrente */
    delete_block:
    for
        each tt_vers_orcto_ctbl exclusive-lock:
        delete tt_vers_orcto_ctbl.
    end /* for delete_block */.

    find emscad.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
    if  avail unid_organ
    then do:
        vers_block:
        for
            each vers_orcto_ctbl no-lock
            where vers_orcto_ctbl.cod_unid_organ = unid_organ.cod_unid_organ /*cl_unid_organ of vers_orcto_ctbl*/:
            run pi_verifica_segur_vers_orcto_ctbl (buffer vers_orcto_ctbl,
                                                   output v_log_return) /*pi_verifica_segur_vers_orcto_ctbl*/.
            if  v_log_return = no
            then do:
                next vers_block.
            end /* if */.
            find first cenar_orctario no-lock
                 where cenar_orctario.cod_cenar_orctario = vers_orcto_ctbl.cod_cenar_orctario
                   and cenar_orctario.cod_unid_organ = vers_orcto_ctbl.cod_unid_organ
                  no-error.
            if  avail cenar_orctario
            then do:
                create tt_vers_orcto_ctbl.
                assign v_num_ocor = v_num_ocor + 1
                       tt_vers_orcto_ctbl.ttv_rec_vers_orcto_ctbl = recid(vers_orcto_ctbl)
                       tt_vers_orcto_ctbl.tta_cod_plano_cta_ctbl  = cenar_orctario.cod_plano_cta_ctbl
                       tt_vers_orcto_ctbl.cod_unid_organ          = vers_orcto_ctbl.cod_unid_organ
                       tt_vers_orcto_ctbl.cod_cenar_orctario      = vers_orcto_ctbl.cod_cenar_orctario
                       tt_vers_orcto_ctbl.cod_cenar_ctbl          = vers_orcto_ctbl.cod_cenar_ctbl
                       tt_vers_orcto_ctbl.cod_exerc_ctbl          = vers_orcto_ctbl.cod_exerc_ctbl
                       tt_vers_orcto_ctbl.cod_vers_orcto_ctbl     = vers_orcto_ctbl.cod_vers_orcto_ctbl
                       tt_vers_orcto_ctbl.cod_usuario             = vers_orcto_ctbl.cod_usuario.
            end /* if */.
        end /* for vers_block */.
    end /* if */.
    if  v_num_ocor > 1
    then do:
        assign p_log_vers_orcto_ctbl = no.
    end /* if */.
    else do:
        if  v_num_ocor = 1
        then do:
            assign p_log_vers_orcto_ctbl = yes.
        end /* if */.
        else do:  /* Nenhuma Ocorrància */
            assign p_log_vers_orcto_ctbl = ?.
        end /* else */.
    end /* else */.
END PROCEDURE. /* pi_criar_vers_orcto_ctbl_usuar */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_vers_orcto_ctbl
** Descricao.............: pi_verifica_segur_vers_orcto_ctbl
** Criado por............: Henke
** Criado em.............: 31/01/1996 10:36:31
** Alterado por..........: Reis
** Alterado em...........: 13/09/1999 13:50:54
*****************************************************************************/
PROCEDURE pi_verifica_segur_vers_orcto_ctbl:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_vers_orcto_ctbl
        for vers_orcto_ctbl.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    loop_block:
    for
       each segur_vers_orcto_ctbl no-lock
       where segur_vers_orcto_ctbl.cod_cenar_ctbl = p_vers_orcto_ctbl.cod_cenar_ctbl
         and segur_vers_orcto_ctbl.cod_cenar_orctario = p_vers_orcto_ctbl.cod_cenar_orctario
         and segur_vers_orcto_ctbl.cod_exerc_ctbl = p_vers_orcto_ctbl.cod_exerc_ctbl
         and segur_vers_orcto_ctbl.cod_unid_organ = p_vers_orcto_ctbl.cod_unid_organ
         and segur_vers_orcto_ctbl.cod_vers_orcto_ctbl = p_vers_orcto_ctbl.cod_vers_orcto_ctbl
       :
       find first usuar_grp_usuar no-lock
            where usuar_grp_usuar.cod_grp_usuar = segur_vers_orcto_ctbl.cod_grp_usuar
              and usuar_grp_usuar.cod_usuario = v_cod_usuar_corren /*cl_permissao_vers_orcto_ctbl of usuar_grp_usuar*/ no-error.
       if  avail usuar_grp_usuar or segur_vers_orcto_ctbl.cod_grp_usuar = "*"
       then do:
           assign p_log_return = yes.       
           leave loop_block.
           /* tem permiss∆o*/
       end /* if */.
    end /* for loop_block */.
END PROCEDURE. /* pi_verifica_segur_vers_orcto_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_lista_estab_valid_usuar_gld
** Descricao.............: pi_lista_estab_valid_usuar_gld
** Criado por............: Uno
** Criado em.............: 20/06/2000 15:38:04
** Alterado por..........: Uno
** Alterado em...........: 20/06/2000 15:43:53
*****************************************************************************/
PROCEDURE pi_lista_estab_valid_usuar_gld:

    assign v_des_lista_estab = "".

    /* ---  Monta relaá∆o dos estabelecimentos v†lidos ao usu†rio corrente, com base nos registros
           da tt_unid_organ, aos quais s∆o verificados a seguranáa de unidade organizacional ---*/
    estab_block:
    for each tt_unid_organ no-lock
        where tt_unid_organ.num_niv_unid_organ = 999 /* Estabelecimento */
          and tt_unid_organ.cod_unid_organ >= v_cod_estab_ini
          and tt_unid_organ.cod_unid_organ <= v_cod_estab_fim:

        assign v_des_lista_estab = v_des_lista_estab
                                 + (if v_des_lista_estab <> "" then "," else "")
                                 + tt_unid_organ.cod_unid_organ.
    end /* for estab_block */.

END PROCEDURE. /* pi_lista_estab_valid_usuar_gld */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_plano_ccusto_ult
** Descricao.............: pi_retornar_plano_ccusto_ult
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: veber
** Alterado em...........: 16/05/1996 08:26:47
*****************************************************************************/
PROCEDURE pi_retornar_plano_ccusto_ult:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def output param p_log_plano_ccusto_uni
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
    for
        each plano_ccusto no-lock
        where plano_ccusto.cod_empresa = p_cod_empresa /*cl_p_cod_empresa of plano_ccusto*/:
        if  p_dat_refer_ent = ?
        or (plano_ccusto.dat_inic_valid <= p_dat_refer_ent
        and plano_ccusto.dat_fim_valid  >= p_dat_refer_ent)
        then do:
            assign v_cod_return         = v_cod_return + ',' + plano_ccusto.cod_plano_ccusto
                   p_cod_plano_ccusto = plano_ccusto.cod_plano_ccusto.
        end /* if */.
    end /* for calcula_block */.

    if  num-entries(v_cod_return) = 2
    then do:
        assign p_log_plano_ccusto_uni = yes.
    end /* if */.
    else do:
        assign p_log_plano_ccusto_uni = no.
    end /* else */.

END PROCEDURE. /* pi_retornar_plano_ccusto_ult */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_faixa_sdo_cta_ctbl
** Descricao.............: pi_verifica_faixa_sdo_cta_ctbl
** Criado por............: Henke
** Criado em.............: 14/02/1996 10:18:06
** Alterado por..........: si1768
** Alterado em...........: 04/10/2013 13:04:45
*****************************************************************************/
PROCEDURE pi_verifica_faixa_sdo_cta_ctbl:

    /* ** Verifica se Faixa n∆o Ç irregular ***/

    find emscad.unid_organ where recid(unid_organ) = v_rec_unid_organ_aux no-lock no-error.
    assign v_rec_unid_organ = recid(unid_organ).

    if  (v_cod_estab_ini      < v_cod_estab_fim      and
         unid_organ.num_niv_unid_organ = 998)        or
        (v_cod_unid_organ_ini < v_cod_unid_organ_fim and
         unid_organ.num_niv_unid_organ < 998)
    then do:           /* Unidade Organizacional */

        estrut_unid_organ:
        for
           each emscad.estrut_unid_organ no-lock
           where estrut_unid_organ.cod_unid_organ_pai = unid_organ.cod_unid_organ
           :
           &if defined(BF_FIN_REESTRUT_SOCIETARIA) &then
           if v_log_funcao_histor_estrut = YES then do:
               if estrut_unid_organ.dat_inic_valid > v_dat_fim_period_ctbl OR
                  estrut_unid_organ.dat_fim_valid < v_dat_inic_period_ctbl_pri then next estrut_unid_organ.
           end.
           &endif


           if  (estrut_unid_organ.cod_unid_organ_filho > v_cod_estab_ini and
                estrut_unid_organ.cod_unid_organ_filho < v_cod_estab_fim) or
               (estrut_unid_organ.cod_unid_organ_filho > v_cod_unid_organ_ini and
                estrut_unid_organ.cod_unid_organ_filho < v_cod_unid_organ_fim)
           then do:
               find first tt_unid_organ no-lock
                    where tt_unid_organ.cod_unid_organ = estrut_unid_organ.cod_unid_organ_filho
                     no-error.
               if  not avail tt_unid_organ
               then do:
                   /* @cx_message(1967,@fx_tab_label(unid_organ),@fx_tab_plabel(unid_organ)).*/ 
                   leave estrut_unid_organ.
               end /* if */.
           end /* if */.
       end /* for estrut_unid_organ */.
    end /* if */.

END PROCEDURE. /* pi_verifica_faixa_sdo_cta_ctbl */
/*****************************************************************************
** Procedure Interna.....: pi_criar_tt_estab_unid_negoc
** Descricao.............: pi_criar_tt_estab_unid_negoc
** Criado por............: Henke
** Criado em.............: 06/08/1996 15:05:40
** Alterado por..........: Uno
** Alterado em...........: 20/06/2000 15:44:51
*****************************************************************************/
PROCEDURE pi_criar_tt_estab_unid_negoc:

    /************************* Variable Definition Begin ************************/

    def var v_log_possui_permis              as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* --- Limpeza da tabela tempor†ria ---*/
    estab_un_block:
    for each tt_estab_unid_negoc_select exclusive-lock:
        delete tt_estab_unid_negoc_select.
    end /* for estab_un_block */.

    /* --- Criaá∆o dos tt_estab_unid_negoc_select ---*/
    estab_block:
    for each tt_unid_organ no-lock
        where tt_unid_organ.num_niv_unid_organ = 999 /* Estabelecimento */
          and tt_unid_organ.cod_unid_organ    >= v_cod_estab_ini
          and tt_unid_organ.cod_unid_organ    <= v_cod_estab_fim:

        /* ** SE RESTRINGE ACESSO A ESTABELECIMENTOS DO USUµRIO NA CONSULTA,
             ESTE N«O CONSEGUIRµ ENXERGAR VALORES DE OUTROS ESTABELECIMENTOS ***/
        if  v_log_restric_estab = yes then do:

            assign v_log_possui_permis = no.
            if  can-find(first emscad.segur_unid_organ no-lock
                where segur_unid_organ.cod_unid_organ = tt_unid_organ.cod_unid_organ
                and   segur_unid_organ.cod_grp_usuar  = "*") then do:
                assign v_log_possui_permis = yes.
            end.
            else do:
                loop_block:
                for each usuar_grp_usuar no-lock
                    where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren:
                    if  can-find(first segur_unid_organ no-lock
                        where segur_unid_organ.cod_unid_organ = tt_unid_organ.cod_unid_organ
                        and   segur_unid_organ.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar) then do:
                        assign v_log_possui_permis = yes.
                        leave loop_block.
                    end.
                end.
            end.

            if  v_log_possui_permis = no then
                next estab_block.
        end.

        if  v_log_estab_unid_negoc = yes
        then do:
            estab_un_block:
            for each estab_unid_negoc no-lock
                where estab_unid_negoc.cod_estab       = tt_unid_organ.cod_unid_organ
                  and estab_unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
                  and estab_unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim:

                find first tt_unid_negoc no-lock
                     where tt_unid_negoc.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc
                      no-error.
                if  not avail tt_unid_negoc
                then do:
                    next estab_un_block.
                end /* if */.

                create tt_estab_unid_negoc_select.
                assign tt_estab_unid_negoc_select.cod_estab      = estab_unid_negoc.cod_estab
                       tt_estab_unid_negoc_select.cod_unid_negoc = estab_unid_negoc.cod_unid_negoc.
            end /* for estab_un_block */.
        end /* if */.
        else do:
            create tt_estab_unid_negoc_select.
            assign tt_estab_unid_negoc_select.cod_estab      = tt_unid_organ.cod_unid_organ
                   tt_estab_unid_negoc_select.cod_unid_negoc = "".
        end /* else */.
    end /* for estab_block */.
END PROCEDURE. /* pi_criar_tt_estab_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_criar_unid_negoc_faixa
** Descricao.............: pi_criar_unid_negoc_faixa
** Criado por............: BRE17264
** Criado em.............: 31/08/1999 15:29:41
** Alterado por..........: fut35059
** Alterado em...........: 27/07/2006 17:34:24
*****************************************************************************/
PROCEDURE pi_criar_unid_negoc_faixa:

    delete_block:
    for
        each tt_unid_negoc exclusive-lock:
        delete tt_unid_negoc.
    end /* for delete_block */.

    unid_negoc_block:
    for each emscad.unid_negoc no-lock
        where unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
        and   unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim:

        /* @run (pi_verifica_segur_unid_negoc (unid_negoc.cod_unid_negoc, v_log_return)).
        @if(v_log_return = no)
            @next(unid_negoc_block).
        @end_if().*/

        if not can-find (first tt_unid_negoc where tt_unid_negoc.ttv_rec_unid_negoc = recid(unid_negoc)) then do:
            create tt_unid_negoc.
            assign tt_unid_negoc.ttv_rec_unid_negoc = recid(unid_negoc)
                   tt_unid_negoc.cod_unid_negoc     = unid_negoc.cod_unid_negoc
                   tt_unid_negoc.cdn_unid_negoc     = unid_negoc.cdn_unid_negoc
                   tt_unid_negoc.des_unid_negoc     = unid_negoc.des_unid_negoc.
        end.
    end /* for unid_negoc_block */.

END PROCEDURE. /* pi_criar_unid_negoc_faixa */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_finalid
** Descricao.............: pi_retornar_indic_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:21:29
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ
** Descricao.............: pi_achar_cotac_indic_econ
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut1309_4
** Alterado em...........: 08/02/2006 16:12:34
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
    &if "{&emsuni_version}" >= "5.01" &then
                     use-index ctcprd_id
    &endif
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
    &if "{&emsuni_version}" >= "5.01" &then
                         use-index prdndccn_id
    &endif
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: fut41061
** Alterado em...........: 20/03/2015 15:46:55
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di†ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/  then
                            find prev cotac_parid no-lock
                                where cotac_parid.cod_indic_econ_base   = p_cod_param_1
                                  and cotac_parid.cod_indic_econ_idx    = p_cod_param_2
                                  and cotac_parid.dat_cotac_indic_econ  < p_dat_transacao
                                  and cotac_parid.ind_tip_cotac_parid   = p_ind_tip_cotac_parid
                                  and cotac_parid.val_cotac_indic_econ <> 0.0 use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/  then
                            find next cotac_parid no-lock
                                where cotac_parid.cod_indic_econ_base   = p_cod_param_1
                                  and cotac_parid.cod_indic_econ_idx    = p_cod_param_2
                                  and cotac_parid.dat_cotac_indic_econ  > p_dat_transacao
                                  and cotac_parid.ind_tip_cotac_parid   = p_ind_tip_cotac_parid
                                  and cotac_parid.val_cotac_indic_econ <> 0.0 use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */
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
    &IF "{&emsuni_version}" >= "" AND "{&emsuni_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsuni_version}" >= "5.07A" AND "{&emsuni_version}" < "9.99" &THEN
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
        format "Sim/N∆o"
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
    **    ?  - RETORNA SE A FUNÄ«O BF_FIN_SEGUR_DEMONST_MGL ESTµ HABILITADA (OU EXECUTOU PROGRAMA ESPECIAL QUE LIBERA).
    **    "" - RETORNA SE NO PARAMETRO GERAL DA CONTABILIDADE USA O CONTROLE DE ESTABELECIMENTO.
    **    <cod_demonst> - RETORNA SE O DEMONSTRATIVO CADASTRADO USA O CONTROLE.
    **
    *******/

    &if  defined(BF_FIN_SEGUR_DEMONST_MGL) &then

        if  p_cod_demonst_ctbl = ? then do:        /* ** RETORNA SE FUNÄ«O HABILITADA PARA ESTA VERS«O ***/
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

        find emscad.histor_exec_especial
            where histor_exec_especial.cod_modul_dtsul = 'MGL'
            and   histor_exec_especial.cod_prog_dtsul  = "fnc_segur_demonst_mgl":U
            no-lock no-error.
        if  not avail histor_exec_especial then
            return.

        if  p_cod_demonst_ctbl = ? then do:        /* ** RETORNA SE FUNÄ«O HABILITADA PARA ESTA VERS«O ***/
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
        message getStrTrans("Mensagem nr. ", "FGL") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "FGL") c_prg_msg getStrTrans("n∆o encontrado.", "FGL")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/************************  End of bas_cta_ctbl_razao ************************/
