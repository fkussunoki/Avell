/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_conjto_prefer_demonst_505_cons
** Descricao.............: Funá‰es Conjunto Preferàncias
** Versao................:  1.00.00.012
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204ze.p
** Data Geracao..........: 29/12/2010 - 09:50:29
** Criado por............: dalpra
** Criado em.............: 24/07/2001 11:18:23
** Alterado por..........: fut42625
** Alterado em...........: 29/12/2010 09:50:25
** Gerado por............: fut42625
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.012":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_conjto_prefer_demonst_505_cons MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/
/************************** Buffer Definition Begin *************************/

&if "{&emsuni_version}" >= "1.00" &then
def buffer b_cenar_ctbl
    for cenar_ctbl.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_finalid_econ
    for finalid_econ.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_period_ctbl
    for period_ctbl.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_ccusto
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
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
def var v_cod_cenar_ctbl
    as character
    format "x(8)":U
    label "Cen†rio Cont†bil"
    column-label "Cen†rio Cont†bil"
    no-undo.
def var v_cod_cta_ctbl
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.
def var v_cod_cta_prefer_excec
    as character
    format "x(20)":U
    initial "####################"
    label "Exceá∆o"
    column-label "Exceá∆o"
    no-undo.
def var v_cod_cta_prefer_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
    column-label "Parte Fixa"
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
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
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
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def var v_cod_format_1
    as character
    format "x(8)":U
    no-undo.
def var v_cod_format_ccusto
    as character
    format "x(11)":U
    initial "x(11)" /*l_x(11)*/
    label "Formato CCusto"
    column-label "Formato CCusto"
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
def var v_cod_indic_econ_base
    as character
    format "x(8)":U
    label "Moeda Base"
    column-label "Moeda Base"
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
def var v_cod_plano_ccusto_old
    as character
    format "x(8)":U
    label "Plano CCusto Antigo"
    column-label "Plano Centros Custo"
    no-undo.
def new global shared var v_cod_plano_cta_ctbl
    as character
    format "x(8)":U
    label "Plano Contas"
    column-label "Plano Contas"
    no-undo.
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
def var v_cod_unid_orctaria
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
def var v_dat_fim_period_1
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_fim_period_2
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_fim_period_ctbl
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Fim"
    column-label "Fim"
    no-undo.
def var v_dat_fim_period_ctbl_fim
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    column-label "Fim Per°odo"
    no-undo.
def var v_dat_fim_period_ctbl_ini
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    column-label "Fim Per°odo"
    no-undo.
def var v_dat_inic_period_ctbl
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "In°cio"
    column-label "In°cio"
    no-undo.
def var v_dat_inic_period_ctbl_fim
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "In°cio Per°odo"
    no-undo.
def var v_dat_inic_period_ctbl_ini
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "In°cio Per°odo"
    no-undo.
def var v_des_sdo_ctbl_fim
    as character
    format "9999/99":U
    initial "999999"
    label "2ß Per°odo"
    column-label "2ß Per°odo"
    no-undo.
def var v_des_sdo_ctbl_fim_ant
    as character
    format "9999/99":U
    no-undo.
def var v_des_sdo_ctbl_ini
    as character
    format "9999/99":U
    initial "000101"
    label "1ß Per°odo"
    column-label "1ß Per°odo"
    no-undo.
def var v_des_sdo_ctbl_inic_ant
    as character
    format "9999/99":U
    no-undo.
def new global shared var v_ind_selec_tip_demo
    as character
    format "X(28)":U
    view-as combo-box
    list-items "Saldo Conta Cont†bil","Saldo Conta Centros Custo","Saldo Centro Custo Contas"
     /*l_saldo_conta_contabil_demo*/ /*l_saldo_conta_centros_custo*/ /*l_saldo_centro_custo_contas*/
    inner-lines 5
    bgcolor 15 font 2
    label "Consultar"
    no-undo.
def new global shared var v_ind_tip_sdo_ctbl_demo
    as character
    format "X(15)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Tipo"
    no-undo.
def new global shared var v_log_alterado
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
def var v_log_habilita
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_habilita_orcto
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_repeat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_save
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_save_ok
    as logical
    format "Sim/N∆o"
    initial no
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
def var v_num_seq_orcto_ctbl
    as integer
    format ">>>>>>>>9":U
    label "Seq Orcto Cont†bil"
    column-label "Seq Orcto Cont†bil"
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
def new global shared var v_rec_cenar_orctario
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_cenar_orctario_bgc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_concorrente
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_conjto_prefer_demonst
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
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_exerc_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_finalid_econ
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_padr_col_demonst_ctbl
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_period_ctbl_fim
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_period_ctbl_ini
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
def new global shared var v_rec_table_sav
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_unid_orctaria
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_organ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_vers_orcto_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_vers_orcto_ctbl_bgc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_cotac_1
    as decimal
    format ">>>>,>>9.9999999999":U
    decimals 10
    label "Valor"
    column-label "Valor"
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
def var v_cod_return                     as character       no-undo. /*local*/
def var v_dat_cotac_indic_econ           as date            no-undo. /*local*/


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

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
def rectangle rt_004
    size 1 by 1
    edge-pixels 2.
def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_006
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_nex2
    label ">"
    tooltip "Pr¢xima Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-nex2"
    image-insensitive file "image/ii-nex2"
&endif
    size 1 by 1
    auto-go.
def button bt_nex4
    label ">"
    tooltip "Pr¢ximo"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-nex2"
    image-insensitive file "image/ii-nex2"
&endif
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_pre2
    label "<"
    tooltip "Ocorrància Anterior da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pre2"
    image-insensitive file "image/ii-pre2"
&endif
    size 1 by 1
    auto-go.
def button bt_pre4
    label "<"
    tooltip "Anterior"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
&endif
    size 1 by 1.
def button bt_sav
    label "Salva"
    tooltip "Salva"
    size 1 by 1
    auto-go.
def button bt_zoo2
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo3
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo7
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_326364
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326365
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326366
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326367
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326368
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326379
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326380
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326381
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326382
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_326383
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_04_conjto_prefer_demonst_505_cons
    rt_002
         at row 02.75 col 01.72 bgcolor 8 
    rt_003
         at row 06.13 col 02.14
    " Apresentaá∆o " view-as text
         at row 05.83 col 04.14 bgcolor 8 
    rt_005
         at row 09.25 col 52.72
    " Oráamentos " view-as text
         at row 08.95 col 54.72 bgcolor 8 
    rt_004
         at row 06.13 col 52.72 bgcolor 8 
    rt_006
         at row 03.17 col 02.14 bgcolor 8 
    rt_cxcf
         at row 14.38 col 02.00 bgcolor 7 
    rt_001
         at row 01.21 col 01.72 bgcolor 8 
    conjto_prefer_demonst.num_conjto_param_ctbl
         at row 01.42 col 33.00 colon-aligned label "Conjunto ParÉmetros"
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_ctbl
         at row 03.54 col 14.00 colon-aligned label "Conta Cont†bil"
         help "C¢digo da Conta Cont†bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326379
         at row 03.54 col 37.14
    v_cod_ccusto
         at row 04.54 col 14.00 colon-aligned label "Centro Custo"
         help "C¢digo Centro Custo"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo3
         at row 04.54 col 37.29 font ?
         help "Zoom"
    conjto_prefer_demonst.cod_cenar_ctbl
         at row 06.92 col 14.00 colon-aligned label "Cen†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326364
         at row 06.92 col 25.14
    v_des_sdo_ctbl_ini
         at row 06.92 col 32.72 colon-aligned label "1ß"
         help "Exerc°cio e Per°odo Cont†bil"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_pre4
         at row 06.88 col 43.14 font ?
         help "Anterior"
    bt_nex4
         at row 06.88 col 47.14 font ?
         help "Pr¢ximo"
    v_cod_cenar_ctbl
         at row 07.92 col 14.00 colon-aligned label "Cen†rio"
         help "Cen†rio Cont†bil"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo2
         at row 07.92 col 25.14 font ?
         help "Zoom"
    v_des_sdo_ctbl_fim
         at row 07.92 col 32.72 colon-aligned label "2ß"
         help "Exerc°cio e Per°odo Cont†bil"
         view-as fill-in
         size-chars 8.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_pre2
         at row 07.88 col 43.14 font ?
         help "Ocorrància Anterior da Tabela"
    bt_nex2
         at row 07.88 col 47.14 font ?
         help "Pr¢xima Ocorrància da Tabela"
    conjto_prefer_demonst.cod_finalid_econ
         at row 08.92 col 14.00 colon-aligned label "Finalidade"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326366
         at row 08.92 col 27.14
    conjto_prefer_demonst.cod_finalid_econ_apres
         at row 09.92 col 14.00 colon-aligned label "Apresentaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326367
         at row 09.92 col 27.14
    conjto_prefer_demonst.dat_cotac_indic_econ
         at row 10.92 col 14.00 colon-aligned label "Data Cotaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_cotac_1
         at row 11.92 col 14.00 colon-aligned label "Valor"
         help "Valor Cotaá∆o Paridade"
         view-as fill-in
         size-chars 20.14 by .88
         fgcolor ? bgcolor 15 font 2
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_ini
         at row 06.75 col 60.72 colon-aligned label "Estab"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326381
         at row 06.75 col 66.86
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_ini
         at row 06.75 col 60.72 colon-aligned label "Estab"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326381
         at row 06.75 col 68.86
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_fim
         at row 06.75 col 75.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326380
         at row 06.75 col 81.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_fim
         at row 06.75 col 75.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326380
         at row 06.75 col 83.14
&ENDIF
    v_cod_unid_negoc_ini
         at row 07.75 col 60.72 colon-aligned label "Unid Neg"
         help "Unidade de Neg¢cio Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326383
         at row 07.75 col 66.86
    v_cod_unid_negoc_fim
         at row 07.75 col 75.00 colon-aligned label "atÇ"
         help "Unidade de Neg¢cio Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326382
         at row 07.75 col 81.14
    conjto_prefer_demonst.cod_cenar_orctario
         at row 09.75 col 64.72 colon-aligned label "Cen†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326365
         at row 09.75 col 75.86
    v_cod_unid_orctaria
         at row 10.75 col 64.72 colon-aligned label "Un Orctaria"
         help "C¢digo Unidade Orcamentaria"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo7
         at row 10.75 col 75.86 font ?
         help "Zoom"
    v_num_seq_orcto_ctbl
         at row 11.75 col 64.72 colon-aligned label "Seq Orc Ctbl"
         help "Sequencia Orcamento Contabil"
         view-as fill-in
         size-chars 10.14 by .88
         fgcolor ? bgcolor 15 font 2
    conjto_prefer_demonst.cod_vers_orcto_ctbl
         at row 12.75 col 64.72 colon-aligned label "Vers∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_326368
         at row 12.75 col 77.86
    bt_ok
         at row 14.58 col 03.00 font ?
         help "OK"
    bt_sav
         at row 14.58 col 14.00 font ?
         help "Salva"
    bt_can
         at row 14.58 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 14.58 col 77.57 font ?
         help "Ajuda"
    cta_ctbl.des_tit_ctbl
         at row 03.54 col 41.29 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    emsuni.ccusto.des_tit_ctbl
         at row 04.54 col 41.43 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 16.21 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conjunto Preferàncias".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 10.00
           bt_can:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_hel2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 10.00
           bt_hel2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_nex2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_nex2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_nex4:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_nex4:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_ok:width-chars    in frame f_dlg_04_conjto_prefer_demonst_505_cons = 10.00
           bt_ok:height-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_pre2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_pre2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_pre4:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_pre4:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_sav:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 10.00
           bt_sav:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.00
           bt_zoo2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_zoo2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 00.88
           bt_zoo3:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_zoo3:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 00.88
           bt_zoo7:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.00
           bt_zoo7:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 00.88
           rt_001:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 86.86
           rt_001:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.33
           rt_002:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 86.86
           rt_002:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 11.54
           rt_003:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 50.29
           rt_003:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 07.88
           rt_004:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 35.14
           rt_004:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 02.83
           rt_005:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 35.14
           rt_005:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 04.75
           rt_006:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505_cons = 85.86
           rt_006:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 02.63
           rt_cxcf:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505_cons = 86.57
           rt_cxcf:height-chars in frame f_dlg_04_conjto_prefer_demonst_505_cons = 01.42.
    /* set private-data for the help system */
    assign conjto_prefer_demonst.num_conjto_param_ctbl:private-data  in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000023500":U
           bt_zoo_326379:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           v_cod_cta_ctbl:private-data                               in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000022982":U
           v_cod_ccusto:private-data                                 in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000013841":U
           bt_zoo3:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009433":U
           bt_zoo_326364:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           conjto_prefer_demonst.cod_cenar_ctbl:private-data         in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010457":U
           v_des_sdo_ctbl_ini:private-data                           in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000023545":U
           bt_pre4:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010792":U
           bt_nex4:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010789":U
           v_cod_cenar_ctbl:private-data                             in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000017118":U
           bt_zoo2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009432":U
           v_des_sdo_ctbl_fim:private-data                           in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000023546":U
           bt_pre2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010824":U
           bt_nex2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010823":U
           bt_zoo_326366:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           conjto_prefer_demonst.cod_finalid_econ:private-data       in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000021908":U
           bt_zoo_326367:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           conjto_prefer_demonst.cod_finalid_econ_apres:private-data in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000013407":U
           conjto_prefer_demonst.dat_cotac_indic_econ:private-data   in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000023200":U
           v_val_cotac_1:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000023498":U
           bt_zoo_326381:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           bt_zoo_326381:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           v_cod_estab_ini:private-data                              in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000016633":U
           bt_zoo_326380:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           bt_zoo_326380:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           v_cod_estab_fim:private-data                              in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000016634":U
           bt_zoo_326383:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           v_cod_unid_negoc_ini:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000019459":U
           bt_zoo_326382:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           v_cod_unid_negoc_fim:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000019460":U
           bt_zoo_326365:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           conjto_prefer_demonst.cod_cenar_orctario:private-data     in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000013850":U
           v_cod_unid_orctaria:private-data                          in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000000000":U
           bt_zoo7:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000000000":U
           v_num_seq_orcto_ctbl:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000000000":U
           bt_zoo_326368:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000009431":U
           conjto_prefer_demonst.cod_vers_orcto_ctbl:private-data    in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000013956":U
           bt_ok:private-data                                        in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000010721":U
           bt_sav:private-data                                       in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000011048":U
           bt_can:private-data                                       in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000011050":U
           bt_hel2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000011326":U
           cta_ctbl.des_tit_ctbl:private-data                        in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000025188":U
           emsuni.ccusto.des_tit_ctbl:private-data                          in frame f_dlg_04_conjto_prefer_demonst_505_cons = "HLP=000025191":U
           frame f_dlg_04_conjto_prefer_demonst_505_cons:private-data                                                 = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_326379:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326364:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326366:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326367:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326381:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326381:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326380:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326380:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326383:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326382:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326365:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           bt_zoo_326368:sensitive in frame f_dlg_04_conjto_prefer_demonst_505_cons = yes.
    /* move buttons to top */
    bt_zoo_326379:move-to-top().
    bt_zoo_326364:move-to-top().
    bt_zoo_326366:move-to-top().
    bt_zoo_326367:move-to-top().
    bt_zoo_326381:move-to-top().
    bt_zoo_326381:move-to-top().
    bt_zoo_326380:move-to-top().
    bt_zoo_326380:move-to-top().
    bt_zoo_326383:move-to-top().
    bt_zoo_326382:move-to-top().
    bt_zoo_326365:move-to-top().
    bt_zoo_326368:move-to-top().



{include/i_fclfrm.i f_dlg_04_conjto_prefer_demonst_505_cons }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_nex2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    find period_ctbl NO-LOCK
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl
           AND period_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_fim,1,4)
           AND period_ctbl.num_period_ctbl = int(substring(v_des_sdo_ctbl_fim,5,2)) NO-ERROR.
    find next period_ctbl no-lock
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl no-error.
    if  avail period_ctbl
    then do:
        find exerc_ctbl no-lock
             where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
               and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
              no-error.
        if  v_rec_exerc_ctbl <> recid(exerc_ctbl)
        then do:
            assign v_rec_exerc_ctbl = recid(exerc_ctbl).
        end /* if */.
        assign v_rec_period_ctbl_fim      = recid(period_ctbl)
               v_dat_inic_period_ctbl_fim = period_ctbl.dat_inic_period_ctbl
               v_dat_fim_period_ctbl_fim  = period_ctbl.dat_fim_period_ctbl
               v_des_sdo_ctbl_fim         = period_ctbl.cod_exerc_ctbl
                                          + string(period_ctbl.num_period_ctbl,"99").
        display v_des_sdo_ctbl_fim
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        message "Èltima ocorrància da tabela." /*l_last*/ 
               view-as alert-box warning buttons ok.
    end /* else */.
END. /* ON CHOOSE OF bt_nex2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_nex4 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    find period_ctbl NO-LOCK
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl
           AND period_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_ini,1,4)
           AND period_ctbl.num_period_ctbl = int(substring(v_des_sdo_ctbl_ini,5,2)) NO-ERROR.
    find next period_ctbl no-lock
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl no-error.
    if  avail period_ctbl
    then do:
        find exerc_ctbl no-lock
             where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
               and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
              no-error.
        if  v_rec_exerc_ctbl <> recid(exerc_ctbl)
        then do:
            assign v_rec_exerc_ctbl = recid(exerc_ctbl).
        end /* if */.
        assign v_rec_period_ctbl_ini      = recid(period_ctbl)
               v_dat_inic_period_ctbl_ini = period_ctbl.dat_inic_period_ctbl
               v_dat_fim_period_ctbl_ini  = period_ctbl.dat_fim_period_ctbl
               v_des_sdo_ctbl_ini         = period_ctbl.cod_exerc_ctbl
                                          + string(period_ctbl.num_period_ctbl,"99").
        display v_des_sdo_ctbl_ini
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        message "Èltima ocorrància da tabela." /*l_last*/ 
               view-as alert-box warning buttons ok.
    end /* else */.
END. /* ON CHOOSE OF bt_nex4 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_ok IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    assign v_log_save = yes
           v_log_repeat = no.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_pre2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    find period_ctbl NO-LOCK
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl
           AND period_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_fim,1,4)
           AND period_ctbl.num_period_ctbl = int(substring(v_des_sdo_ctbl_fim,5,2)) NO-ERROR.
    find prev period_ctbl no-lock
         where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl no-error.
    if  avail period_ctbl
    then do:
        find exerc_ctbl no-lock
             where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
               and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
              no-error.
        if  v_rec_exerc_ctbl <> recid(exerc_ctbl)
        then do:
            assign v_rec_exerc_ctbl = recid(exerc_ctbl).
        end /* if */.
        assign v_rec_period_ctbl_fim      = recid(period_ctbl)
               v_dat_inic_period_ctbl_fim = period_ctbl.dat_inic_period_ctbl
               v_dat_fim_period_ctbl_fim  = period_ctbl.dat_fim_period_ctbl
               v_des_sdo_ctbl_fim         = period_ctbl.cod_exerc_ctbl
                                          + string(period_ctbl.num_period_ctbl,"99").
        display v_des_sdo_ctbl_fim
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        message "Primeira ocorrància da tabela." /*l_first*/ 
               view-as alert-box warning buttons ok.
    end /* else */.
END. /* ON CHOOSE OF bt_pre2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_pre4 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    find period_ctbl NO-LOCK
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl
           AND period_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_ini,1,4)
           AND period_ctbl.num_period_ctbl = int(substring(v_des_sdo_ctbl_ini,5,2)) NO-ERROR.
    find prev period_ctbl no-lock
         where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl no-error.
    if  avail period_ctbl
    then do:
        find exerc_ctbl no-lock
             where exerc_ctbl.cod_cenar_ctbl = period_ctbl.cod_cenar_ctbl
               and exerc_ctbl.cod_exerc_ctbl = period_ctbl.cod_exerc_ctbl
              no-error.
        if  v_rec_exerc_ctbl <> recid(exerc_ctbl)
        then do:
            assign v_rec_exerc_ctbl = recid(exerc_ctbl).
        end /* if */.
        assign v_rec_period_ctbl_ini      = recid(period_ctbl)
               v_dat_inic_period_ctbl_ini = period_ctbl.dat_inic_period_ctbl
               v_dat_fim_period_ctbl_ini  = period_ctbl.dat_fim_period_ctbl
               v_des_sdo_ctbl_ini         = period_ctbl.cod_exerc_ctbl
                                          + string(period_ctbl.num_period_ctbl,"99").
        display v_des_sdo_ctbl_ini
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        message "Primeira ocorrància da tabela." /*l_first*/ 
               view-as alert-box warning buttons ok.
    end /* else */.
END. /* ON CHOOSE OF bt_pre4 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_sav IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    assign v_log_save = yes
           v_log_repeat = yes.
END. /* ON CHOOSE OF bt_sav IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  search("prgint/utb/utb076ka.r") = ? and search("prgint/utb/utb076ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb076ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb076ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb076ka.p /*prg_sea_cenar_ctbl*/.
    if  v_rec_cenar_ctbl <> ?
    then do:
        find first cenar_ctbl no-lock
            where recid(cenar_ctbl) = v_rec_cenar_ctbl no-error.
        if  avail cenar_ctbl
        then do:
            assign v_cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = cenar_ctbl.cod_cenar_ctbl.
            apply "entry" to v_cod_cenar_ctbl in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end /* if */.
    end /* if */.
END. /* ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  search("prgint/utb/utb066ka.r") = ? and search("prgint/utb/utb066ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb066ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb066ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb066ka.p /*prg_sea_ccusto*/.
    if  v_rec_ccusto <> ? then do:
        find emsuni.ccusto 
           where recid(ccusto) = v_rec_ccusto no-lock no-error. 
           assign v_cod_ccusto:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = string(ccusto.cod_ccusto,v_cod_format_ccusto).

        apply "entry" to v_cod_ccusto in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end.
END. /* ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON CHOOSE OF bt_zoo7 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  search("prgfin/bdg/bdg006ka.r") = ? and search("prgfin/bdg/bdg006ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bdg/bdg006ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/bdg/bdg006ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/bdg/bdg006ka.p /*prg_sea_unid_orctaria*/.
    if  v_rec_unid_orctaria <> ? then do:
        find unid_orctaria
           where recid(unid_orctaria) = v_rec_unid_orctaria no-lock no-error. 
           assign v_cod_unid_orctaria:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = unid_orctaria.cod_unid_orctaria.

        apply "entry" to v_cod_unid_orctaria in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end.
END. /* ON CHOOSE OF bt_zoo7 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF v_cod_ccusto IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    assign v_cod_format_1 = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto no-error.
    if  error-status:error or index (string(v_cod_format_1, v_cod_format_ccusto), chr(32)) <> 0
    then do:
        /* Formato &2 Inv†lido ! */
        run pi_messages (input "show",
                         input 4488,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_cod_format_ccusto)) /*msg_4488*/.
        return no-apply.
    end /* if */.

    find emsuni.ccusto no-lock
        where ccusto.cod_plano_ccusto = v_cod_plano_ccusto
          and ccusto.cod_ccusto = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto no-error.
    display ccusto.des_tit_ctbl when avail ccusto
            "" when not avail ccusto @ ccusto.des_tit_ctbl
            with frame f_dlg_04_conjto_prefer_demonst_505_cons.
END. /* ON LEAVE OF v_cod_ccusto IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF v_cod_cta_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    assign v_cod_format = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl no-error.
    if  error-status:error or index (string(v_cod_format, v_cod_format_cta_ctbl), chr(32)) <> 0
    then do:
        /* Formato &2 Inv†lido ! */
        run pi_messages (input "show",
                         input 4488,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_cod_format_cta_ctbl)) /*msg_4488*/.
        return no-apply.
    end /* if */.

    find cta_ctbl no-lock
        where cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
          and cta_ctbl.cod_cta_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl no-error.
    display cta_ctbl.des_tit_ctbl when avail cta_ctbl
            "" when not avail cta_ctbl @ cta_ctbl.des_tit_ctbl
            with frame f_dlg_04_conjto_prefer_demonst_505_cons.
END. /* ON LEAVE OF v_cod_cta_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF v_des_sdo_ctbl_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    /* Rodrigo - ATV242243*/
    if  v_des_sdo_ctbl_fim <> input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_fim then do:
        assign v_des_sdo_ctbl_fim = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_fim.
        find exerc_ctbl no-lock 
          where exerc_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons 
            and exerc_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_fim,1,4) no-error.
        if avail exerc_ctbl then
           assign v_rec_exerc_ctbl = recid(exerc_ctbl).
    end.
    display v_des_sdo_ctbl_fim with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    /* Rodrigo - ATV242243*/
END. /* ON LEAVE OF v_des_sdo_ctbl_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF v_des_sdo_ctbl_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  v_des_sdo_ctbl_ini <> input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_ini
    then do:
        assign v_des_sdo_ctbl_ini = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_ini.
        find exerc_ctbl no-lock where
             exerc_ctbl.cod_cenar_ctbl = conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons and
             exerc_ctbl.cod_exerc_ctbl = substring(v_des_sdo_ctbl_ini,1,4) no-error.
        if avail exerc_ctbl then
           assign v_rec_exerc_ctbl = recid(exerc_ctbl).
    end /* if */.
    display v_des_sdo_ctbl_ini
            with frame f_dlg_04_conjto_prefer_demonst_505_cons.
END. /* ON LEAVE OF v_des_sdo_ctbl_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:


END. /* ON LEAVE OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  conjto_prefer_demonst.cod_finalid_econ:screen-value = conjto_prefer_demonst.cod_finalid_econ_apres:screen-value
    then do:
        disable conjto_prefer_demonst.dat_cotac_indic_econ
                v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        enable conjto_prefer_demonst.dat_cotac_indic_econ
               v_val_cotac_1
               with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* else */.
END. /* ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  conjto_prefer_demonst.cod_finalid_econ:screen-value = conjto_prefer_demonst.cod_finalid_econ_apres:screen-value
    then do:
        assign v_val_cotac_1 = 1.
        display v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        disable conjto_prefer_demonst.dat_cotac_indic_econ
                v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.
    else do:
        enable conjto_prefer_demonst.dat_cotac_indic_econ
               v_val_cotac_1
               with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* else */.
END. /* ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON ENTRY OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    if  v_rec_vers_orcto_ctbl_bgc <> ?
    and avail vers_orcto_ctbl_bgc then
        assign v_num_seq_orcto_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = string(vers_orcto_ctbl_bgc.num_seq_orcto_ctbl)
               v_cod_unid_orctaria:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = vers_orcto_ctbl_bgc.cod_unid_orctaria
               conjto_prefer_demonst.cod_cenar_orctario:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = vers_orcto_ctbl_bgc.cod_cenar_orctario
               v_rec_vers_orcto_ctbl_bgc = ? .
END. /* ON ENTRY OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON LEAVE OF conjto_prefer_demonst.dat_cotac_indic_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
DO:

    /* --- Verifica Convers∆o de Moedas ---*/
    if  (input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ <>
         input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ_apres)
    or  (input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.dat_cotac_indic_econ <>
         conjto_prefer_demonst.dat_cotac_indic_econ)
    then do:
        run pi_retornar_indic_econ_finalid (Input input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ,
                                            Input input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.dat_cotac_indic_econ,
                                            output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
        run pi_retornar_indic_econ_finalid (Input input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ_apres,
                                            Input input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.dat_cotac_indic_econ,
                                            output v_cod_indic_econ_apres) /*pi_retornar_indic_econ_finalid*/.
        run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                       Input v_cod_indic_econ_apres,
                                       Input input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.dat_cotac_indic_econ,
                                       Input "Real" /*l_real*/,
                                       output v_dat_cotac_indic_econ,
                                       output v_val_cotac_1,
                                       output v_cod_return) /*pi_achar_cotac_indic_econ*/.
    end /* if */.
    display v_val_cotac_1
            with frame f_dlg_04_conjto_prefer_demonst_505_cons.
END. /* ON LEAVE OF conjto_prefer_demonst.dat_cotac_indic_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_326364 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    if  search("prgint/utb/utb076na.r") = ? and search("prgint/utb/utb076na.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb076na.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb076na.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb076na.p /*prg_see_cenar_ctbl_uo*/.
    if  v_rec_cenar_ctbl <> ?
    then do:
        find cenar_ctbl where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
        assign conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
                string(cenar_ctbl.cod_cenar_ctbl).
        apply "entry" to conjto_prefer_demonst.cod_cenar_ctbl in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326364 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326365 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF conjto_prefer_demonst.cod_cenar_orctario IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom */
    if  search("prgfin/bdg/bdg001ka.r") = ? and search("prgfin/bdg/bdg001ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/bdg/bdg001ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/bdg/bdg001ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/bdg/bdg001ka.p /*prg_sea_cenar_orctario_bgc*/.
    if  v_rec_cenar_orctario_bgc <> ?
    then do:
        find cenar_orctario_bgc where recid(cenar_orctario_bgc) = v_rec_cenar_orctario_bgc no-lock no-error.
        assign conjto_prefer_demonst.cod_cenar_orctario:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(cenar_orctario_bgc.cod_cenar_orctario).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_cenar_orctario in frame f_dlg_04_conjto_prefer_demonst_505_cons.
end. /* ON  CHOOSE OF bt_zoo_326365 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326366 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    if  search("prgint/utb/utb077nb.r") = ? and search("prgint/utb/utb077nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb077nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb077nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb077nb.p (Input v_cod_empres_usuar,
                               Input yes,
                               Input yes,
                               Input yes,
                               Input yes,
                               Input yes) /*prg_see_finalid_econ_unid_organ*/.
    if  v_rec_finalid_econ <> ?
    then do:
        find finalid_econ where recid(finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign conjto_prefer_demonst.cod_finalid_econ:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(finalid_econ.cod_finalid_econ).
        apply "entry" to conjto_prefer_demonst.cod_finalid_econ in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326366 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326367 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom */
    if  search("prgint/utb/utb077ka.r") = ? and search("prgint/utb/utb077ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb077ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb077ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb077ka.p /*prg_sea_finalid_econ*/.
    if  v_rec_finalid_econ <> ?
    then do:
        find finalid_econ where recid(finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign conjto_prefer_demonst.cod_finalid_econ_apres:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(finalid_econ.cod_finalid_econ).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_finalid_econ_apres in frame f_dlg_04_conjto_prefer_demonst_505_cons.
end. /* ON  CHOOSE OF bt_zoo_326367 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326368 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom */
    if  search("prgint/dcf/dcf710ka.r") = ? and search("prgint/dcf/dcf710ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/dcf/dcf710ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/dcf/dcf710ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/dcf/dcf710ka.p /*prg_sea_vers_orcto_ctbl_bgc*/.
    if  v_rec_vers_orcto_ctbl_bgc <> ?
    then do:
        find vers_orcto_ctbl_bgc where recid(vers_orcto_ctbl_bgc) = v_rec_vers_orcto_ctbl_bgc no-lock no-error.
        assign conjto_prefer_demonst.cod_vers_orcto_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_vers_orcto_ctbl in frame f_dlg_04_conjto_prefer_demonst_505_cons.
end. /* ON  CHOOSE OF bt_zoo_326368 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326379 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF v_cod_cta_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb080nc.r") = ? and search("prgint/utb/utb080nc.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb080nc.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb080nc.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb080nc.p /*prg_see_cta_ctbl_plano*/.
    if  v_rec_cta_ctbl <> ?
    then do:
        find cta_ctbl where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.
        assign v_cod_cta_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(cta_ctbl.cod_cta_ctbl).

        apply "entry" to v_cod_cta_ctbl in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326379 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326380 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF v_cod_estab_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb071ka.r") = ? and search("prgint/utb/utb071ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb071ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb071ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb071ka.p /*prg_sea_estabelecimento*/.
    if  v_rec_estabelecimento <> ?
    then do:
        find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
        assign v_cod_estab_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(estabelecimento.cod_estab).

        apply "entry" to v_cod_estab_fim in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326380 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326381 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF v_cod_estab_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb071ka.r") = ? and search("prgint/utb/utb071ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb071ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb071ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb071ka.p /*prg_sea_estabelecimento*/.
    if  v_rec_estabelecimento <> ?
    then do:
        find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
        assign v_cod_estab_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(estabelecimento.cod_estab).

        apply "entry" to v_cod_estab_ini in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326381 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326382 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF v_cod_unid_negoc_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb011ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb011ka.p /*prg_sea_unid_negoc*/.
    if  v_rec_unid_negoc <> ?
    then do:
        find emsuni.unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign v_cod_unid_negoc_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_fim in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326382 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON  CHOOSE OF bt_zoo_326383 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons
OR F5 OF v_cod_unid_negoc_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb011ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb011ka.p /*prg_sea_unid_negoc*/.
    if  v_rec_unid_negoc <> ?
    then do:
        find emsuni.unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign v_cod_unid_negoc_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_ini in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_326383 IN FRAME f_dlg_04_conjto_prefer_demonst_505_cons */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_conjto_prefer_demonst_505_cons */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_04_conjto_prefer_demonst_505_cons.





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


        assign v_nom_prog     = substring(frame f_dlg_04_conjto_prefer_demonst_505_cons:title, 1, max(1, length(frame f_dlg_04_conjto_prefer_demonst_505_cons:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_conjto_prefer_demonst_505_cons":U.




    assign v_nom_prog_ext = "prgfin/mgl/MGLA204ze.p":U
           v_cod_release  = trim(" 1.00.00.012":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_conjto_prefer_demonst_505_cons}


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
    run pi_version_extract ('fnc_conjto_prefer_demonst_505_cons':U, 'prgfin/mgl/MGLA204ze.p':U, '1.00.00.012':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.

assign v_cod_ccusto:width in frame f_dlg_04_conjto_prefer_demonst_505_cons = 21.14.

pause 0 before-hide.
view frame f_dlg_04_conjto_prefer_demonst_505_cons.
find prefer_demonst_ctbl no-lock
   where recid(prefer_demonst_ctbl) = v_rec_prefer_demonst_ctbl no-error.

enable all with frame f_dlg_04_conjto_prefer_demonst_505_cons.
disable cta_ctbl.des_tit_ctbl
        ccusto.des_tit_ctbl
        bt_zoo3
        v_cod_cta_ctbl
        v_cod_ccusto
        conjto_prefer_demonst.num_conjto_param_ctbl
        v_cod_cenar_ctbl
        v_des_sdo_ctbl_fim
        bt_zoo2
        bt_pre2
        bt_nex2
        with frame f_dlg_04_conjto_prefer_demonst_505_cons.

run pi_init_fnc_conjto_prefer_demonst_505_cons /*pi_init_fnc_conjto_prefer_demonst_505_cons*/.

main_block:
repeat on endkey undo main_block, leave main_block while v_log_repeat = yes:
    assign v_log_save = no
           v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
    if  valid-handle(v_wgh_focus)
    then do:
        wait-for go of frame f_dlg_04_conjto_prefer_demonst_505_cons focus v_wgh_focus.
    end.
    else do:
        wait-for go of frame f_dlg_04_conjto_prefer_demonst_505_cons focus bt_ok.
    end.
    run pi_vld_conjto_prefer_demonst_505_cons /*pi_vld_conjto_prefer_demonst_505_cons*/.
end /* repeat main_block */.

hide frame f_dlg_04_conjto_prefer_demonst_505_cons.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

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
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: bre17752
** Alterado em...........: 30/07/2003 12:46:24
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
                        assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "A" /*l_A*/ .
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
** Procedure Interna.....: pi_init_fnc_conjto_prefer_demonst_505_cons
** Descricao.............: pi_init_fnc_conjto_prefer_demonst_505_cons
** Criado por............: dalpra
** Criado em.............: 24/07/2001 11:45:47
** Alterado por..........: fut41455
** Alterado em...........: 29/05/2008 15:37:27
*****************************************************************************/
PROCEDURE pi_init_fnc_conjto_prefer_demonst_505_cons:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_compos_demonst_ctbl
        for compos_demonst_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_habilita_ccusto            as logical         no-undo. /*local*/
    def var v_log_habilita_cta_ctbl          as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find conjto_prefer_demonst 
       where recid(conjto_prefer_demonst) = v_rec_conjto_prefer_demonst exclusive-lock no-error.
    if  avail conjto_prefer_demonst
    then do:
        /* --- Busca valores referentes a projeto e ccussto ---*/
        &if '{&emsfin_version}' <= '5.05' &then
            find tab_livre_emsfin exclusive-lock
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
            if  avail tab_livre_emsfin
            then do:
                assign v_cod_ccusto = entry(1,tab_livre_emsfin.cod_livre_2,chr(10)) no-error.
            end.

            /* --- Cen†rios e Per°odos ---*/
            assign v_cod_cenar_ctbl   = entry(3,conjto_prefer_demonst.cod_livre_1,chr(10)) no-error. /* CENµRIO 2 COMPARATIVO */

            assign v_des_sdo_ctbl_ini = string(year(conjto_prefer_demonst.dat_livre_1),'9999') +
                                        string(month(conjto_prefer_demonst.dat_livre_1),'99')
                   v_des_sdo_ctbl_fim = string(string( year(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'9999') +
                                               string(month(date(entry(4,conjto_prefer_demonst.cod_livre_1,chr(10)))),'99')) no-error.
            assign v_des_sdo_ctbl_inic_ant = v_des_sdo_ctbl_ini
                   v_des_sdo_ctbl_fim_ant  = v_des_sdo_ctbl_fim.
            if v_des_sdo_ctbl_ini = "000101" or 
               v_des_sdo_ctbl_ini = ""       or
               v_des_sdo_ctbl_ini = ? then assign v_des_sdo_ctbl_ini = string(year(today),'9999') +
                                                                       string(month(today),'99').
            if v_des_sdo_ctbl_fim = "999999" or
               v_des_sdo_ctbl_fim = ""       or
               v_des_sdo_ctbl_fim = ? then assign v_des_sdo_ctbl_fim = string(year(today),'9999') +
                                                                       string(month(today),'99').
        &endif

        assign v_cod_estab_ini           = conjto_prefer_demonst.cod_estab_inic
               v_cod_estab_fim           = conjto_prefer_demonst.cod_estab_fim
               v_cod_unid_negoc_ini      = conjto_prefer_demonst.cod_unid_negoc_inic
               v_cod_unid_negoc_fim      = conjto_prefer_demonst.cod_unid_negoc_fim
               v_val_cotac_1             = conjto_prefer_demonst.val_cotac_indic_econ
               v_cod_cta_ctbl            = conjto_prefer_demonst.cod_cta_ctbl_inic
               &if '{&emsfin_version}' > '5.05' &then
               v_cod_unid_orctaria       = conjto_prefer_demonst.cod_unid_orctaria
               v_num_seq_orcto_ctbl      = conjto_prefer_demonst.num_seq_orcto_ctbl
               v_cod_ccusto              = conjto_prefer_demonst.cod_ccusto_inic
               v_cod_cenar_ctbl          = conjto_prefer_demonst.cod_cenar_ctbl_2
               v_des_sdo_ctbl_ini        = conjto_prefer_demonst.cod_exerc_period_1
               v_des_sdo_ctbl_fim        = conjto_prefer_demonst.cod_exerc_period_2.
               &else
               v_cod_unid_orctaria       = entry(1,conjto_prefer_demonst.cod_livre_1,chr(10))
               v_num_seq_orcto_ctbl      = integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) no-error.
               &endif

        if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/ 
        then do:
            /* --- Formato Conta Cont†bil ---*/
            find first plano_cta_ctbl no-lock
                where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-error.
            if  avail plano_cta_ctbl
            then do:
                assign v_cod_cta_ctbl:format in frame f_dlg_04_conjto_prefer_demonst_505_cons = plano_cta_ctbl.cod_format_cta_ctbl
                       v_cod_format_cta_ctbl     = plano_cta_ctbl.cod_format_cta_ctbl
                       v_rec_plano_cta_ctbl      = recid(plano_cta_ctbl)
                       v_cod_cta_prefer_pfixa    = fill('#', length(plano_cta_ctbl.cod_format_cta_ctbl))
                       v_cod_cta_prefer_excec    = fill('#', length(plano_cta_ctbl.cod_format_cta_ctbl)).

                    enable v_cod_cta_ctbl
                           with frame f_dlg_04_conjto_prefer_demonst_505_cons.
                    assign v_log_habilita_cta_ctbl = yes.
                    if v_cod_cta_ctbl = "" then do:
                        run pi_retornar_inic_zero (Input v_cod_cta_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons,
                                                   Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_retornar_inic_zero*/.
                        assign v_cod_cta_ctbl = v_cod_cta_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons.
                    end.
                    else display v_cod_cta_ctbl with frame f_dlg_04_conjto_prefer_demonst_505_cons.
            end.
            else do:
                disable v_cod_cta_ctbl
                        bt_zoo_326379
                        with frame f_dlg_04_conjto_prefer_demonst_505_cons.
                assign v_rec_plano_cta_ctbl = ?
                       v_cod_cta_ctbl = "".
            end.
        end.
        else do:
            disable v_cod_cta_ctbl
                    bt_zoo_326379
                    with frame f_dlg_04_conjto_prefer_demonst_505_cons.
            assign v_rec_plano_cta_ctbl = ?
                   v_cod_cta_ctbl = "".
        end.


        if  v_ind_selec_tip_demo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/ 
        then do:
            /* --- Formato CCusto ---*/
            find first plano_ccusto no-lock
                where plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto no-error.
            if  avail plano_ccusto
            then do:
              find first b_compos_demonst_ctbl no-lock
              where b_compos_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl
              and b_compos_demonst_ctbl.cod_plano_ccusto <> ""
              and b_compos_demonst_ctbl.cod_plano_ccusto <> plano_ccusto.cod_plano_ccusto no-error.
              if  not avail b_compos_demonst_ctbl
              then do:
                assign v_cod_ccusto:format in frame f_dlg_04_conjto_prefer_demonst_505_cons = plano_ccusto.cod_format_ccusto
                       v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
                       v_rec_plano_ccusto = recid(plano_ccusto)
                       v_cod_ccusto_prefer_pfixa = fill('#', length(plano_ccusto.cod_format_ccusto))
                       v_cod_ccusto_prefer_excec = fill('#', length(plano_ccusto.cod_format_ccusto)).

                if v_cod_ccusto = "" then do:
                    run pi_retornar_inic_zero (Input v_cod_ccusto:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons,
                                               Input plano_ccusto.cod_format_ccusto) /*pi_retornar_inic_zero*/.
                    assign v_cod_ccusto = v_cod_ccusto:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons.
                end.
                else display v_cod_ccusto with frame f_dlg_04_conjto_prefer_demonst_505_cons.

                enable bt_zoo3
                       v_cod_ccusto
                       with frame f_dlg_04_conjto_prefer_demonst_505_cons.
                assign v_log_habilita_ccusto = yes.
               end.
               else
                   assign v_log_habilita_ccusto = no.     
            end.
            else do:
                assign v_rec_plano_ccusto = ?
                       v_cod_ccusto = "" /*l_null*/ .
                disable bt_zoo3
                        v_cod_ccusto
                        with frame f_dlg_04_conjto_prefer_demonst_505_cons.
            end.
        end.
        else do:
            assign v_rec_plano_ccusto = ?
                   v_cod_ccusto = "" /*l_null*/ .
            disable bt_zoo3
                    v_cod_ccusto
                    with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.

        if  v_ind_tip_sdo_ctbl_demo = "Oráamentos" /*l_orcamentos*/ 
        then do:
            assign v_log_habilita = yes.
            enable conjto_prefer_demonst.cod_cenar_orctario
                   bt_zoo_326365
                   v_cod_unid_orctaria
                   bt_zoo7
                   v_num_seq_orcto_ctbl
                   conjto_prefer_demonst.cod_vers_orcto_ctbl
                   bt_zoo_326368
                   with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.
        else do:
            assign v_log_habilita = no.
            disable conjto_prefer_demonst.cod_cenar_orctario
                    bt_zoo_326365
                    v_cod_unid_orctaria
                    bt_zoo7
                    v_num_seq_orcto_ctbl
                    conjto_prefer_demonst.cod_vers_orcto_ctbl
                    bt_zoo_326368
                    with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.

        if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
        then do:
            enable v_cod_cenar_ctbl
                   bt_zoo2
                   v_des_sdo_ctbl_fim
                   bt_pre2
                   bt_nex2
                   with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.
        else do:
            assign v_cod_cenar_ctbl = "" /*l_null*/ 
                   v_des_sdo_ctbl_fim = "" /*l_null*/ .
            disable v_cod_cenar_ctbl
                    bt_zoo2
                    v_des_sdo_ctbl_fim
                    bt_pre2
                    bt_nex2
                    with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.

        display conjto_prefer_demonst.num_conjto_param_ctbl
                conjto_prefer_demonst.cod_cenar_ctbl
                v_cod_cenar_ctbl
                conjto_prefer_demonst.cod_cenar_orctario
                conjto_prefer_demonst.cod_finalid_econ
                conjto_prefer_demonst.cod_finalid_econ_apres
                conjto_prefer_demonst.cod_vers_orcto_ctbl
                conjto_prefer_demonst.dat_cotac_indic_econ
                v_cod_estab_ini
                v_cod_estab_fim
                v_cod_unid_negoc_ini
                v_cod_unid_negoc_fim
                v_val_cotac_1
                v_des_sdo_ctbl_ini
                v_des_sdo_ctbl_fim
                v_cod_unid_orctaria
                v_num_seq_orcto_ctbl
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.

        if  conjto_prefer_demonst.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ_apres
        then do:
            disable conjto_prefer_demonst.dat_cotac_indic_econ
                    v_val_cotac_1
                    with frame f_dlg_04_conjto_prefer_demonst_505_cons.
        end.
    end.
    else do:
        assign v_des_sdo_ctbl_ini = string(year(today)) +
                                    string(month(today),'99')
               v_des_sdo_ctbl_fim = string(year(today)) +
                                    string(month(today),'99').

        display v_des_sdo_ctbl_fim
                v_des_sdo_ctbl_ini
                with frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end.

    if v_log_habilita_cta_ctbl = yes then do:
        apply "leave" to v_cod_cta_ctbl in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        assign v_wgh_focus = v_cod_cta_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end.
    if v_log_habilita_ccusto then do:
        apply "leave" to v_cod_ccusto in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        assign v_wgh_focus = v_cod_ccusto:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
    end.
END PROCEDURE. /* pi_init_fnc_conjto_prefer_demonst_505_cons */
/*****************************************************************************
** Procedure Interna.....: pi_vld_conjto_prefer_demonst_505_cons
** Descricao.............: pi_vld_conjto_prefer_demonst_505_cons
** Criado por............: dalpra
** Criado em.............: 24/07/2001 14:50:15
** Alterado por..........: fut41422
** Alterado em...........: 09/11/2010 15:29:46
*****************************************************************************/
PROCEDURE pi_vld_conjto_prefer_demonst_505_cons:

    if  v_ind_selec_tip_demo = "Saldo Conta Centros Custo" /*l_saldo_conta_centros_custo*/ 
    then do:
        /* --- Conta Cont†bil ---*/
        if  v_cod_cta_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons <> ""
        then do:
            find first cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
                  and cta_ctbl.cod_cta_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl no-error.
            if  not avail cta_ctbl
            then do:
                /* Conta Cont†bil &1 Inexistente ! */
                run pi_messages (input "show",
                                 input 7620,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                   input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl,v_cod_plano_cta_ctbl)) /*msg_7620*/.
                assign v_wgh_focus = v_cod_cta_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
                return error.
            end.
        end.
    end.

    if  v_ind_selec_tip_demo = "Saldo Centro Custo Contas" /*l_saldo_centro_custo_contas*/ 
    then do:
        /* --- CCusto ---*/
        if  v_cod_ccusto:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons <> ""
        then do:
            find first emsuni.ccusto no-lock
                where ccusto.cod_empresa = v_cod_unid_organ
                  and ccusto.cod_plano_ccusto = v_cod_plano_ccusto
                  and ccusto.cod_ccusto = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto no-error.
            if  not avail ccusto
            then do:
                /* Centro de Custo &1 n∆o cadastrado ! */
                run pi_messages (input "show",
                                 input 239,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_239*/.
                assign v_wgh_focus = v_cod_ccusto:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
                return error.
            end.
        end.
    end.

    /* --- 1o Cenar Ctbl ---*/
    if  conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons <> ""
    then do:
        find cenar_ctbl no-lock
             where cenar_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl no-error.
        if  not avail cenar_ctbl
        then do:
            /* Cen†rio Contabil &1 informado n∆o encontrado ! */
            run pi_messages (input "show",
                             input 379,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_379*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
            return error.
        end.
    end.

    /* --- 1o Per°odo Cont†bil ---*/
    find first period_ctbl no-lock
        where period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl
          and period_ctbl.cod_exerc_ctbl = substring(input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_ini,1,4)
          and period_ctbl.num_period_ctbl = int(substring(input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_ini,5,2)) no-error.
    if  not avail period_ctbl
    then do:
        /* Per°odo Cont†bil inv†lido ! */
        run pi_messages (input "show",
                         input 2730,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl)) /*msg_2730*/.
        assign v_wgh_focus = v_des_sdo_ctbl_ini:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        return error.
    end.

    assign v_dat_fim_period_1 = period_ctbl.dat_fim_period_ctbl.

    if  v_ind_tip_sdo_ctbl_demo = "Comparativo" /*l_comparativo*/ 
    then do:
        /* --- 2o Cenar Ctbl ---*/
        if  v_cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons <> ""
        then do:
            find b_cenar_ctbl no-lock
                 where b_cenar_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl no-error.
            if  not avail b_cenar_ctbl
            then do:
                /* Cen†rio Contabil &1 informado n∆o encontrado ! */
                run pi_messages (input "show",
                                 input 379,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_379*/.
                assign v_wgh_focus = v_cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
                return error.
            end.
        end.

        /* --- 2o Per°odo Cont†bil ---*/
        find first b_period_ctbl no-lock
            where b_period_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl
              and b_period_ctbl.cod_exerc_ctbl = substring(input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_fim,1,4)
              and b_period_ctbl.num_period_ctbl = int(substring(input frame f_dlg_04_conjto_prefer_demonst_505_cons v_des_sdo_ctbl_fim,5,2)) no-error.
        if  not avail b_period_ctbl
        then do:
            /* Per°odo Cont†bil inv†lido ! */
            run pi_messages (input "show",
                             input 2730,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl)) /*msg_2730*/.
            assign v_wgh_focus = v_des_sdo_ctbl_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
            return error.
        end.

        assign v_dat_fim_period_2 = b_period_ctbl.dat_fim_period_ctbl.
    end.

    /* Validaá∆o das faixas - Estabelecimento*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_fim < input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Estabelecimento" /*l_estabelecimento*/ ,"Estabelecimento" /*l_estabelecimento*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_estab_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        return error.
    end.

    /* Validaá∆o das faixas - UN*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_fim < input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Unidade de Neg¢cio" /*l_unidade_de_negocio*/ ,"Unidade de Neg¢cio" /*l_unidade_de_negocio*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_unid_negoc_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        return error.
    end.

    /* --- Finalidades Econìmicas ---*/
    find finalid_econ no-lock
          where finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ no-error.
    if  not avail finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        return error.
    end.
    find b_finalid_econ no-lock
         where b_finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ_apres no-error.
    if  not avail b_finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ_apres:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
        return error.
    end.

    /* --- Cenar e Vers∆o Oráamentos ---*/
    if  v_log_habilita = yes
    then do:
        find first cenar_orctario_bgc no-lock
             where cenar_orctario_bgc.cod_cenar_orctario = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_orctario no-error.
        if  not avail cenar_orctario_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Cen†rio Oráament†rio", "Cen†rios Oráament†rios")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_orctario:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
            return error.
        end.
        find first unid_orctaria no-lock
             where unid_orctaria.cod_unid_orctaria = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_orctaria no-error.
        if  not avail unid_orctaria
        then do:
            /* Unidade Oráament†ria &1 Inexistente ! */
            run pi_messages (input "show",
                             input 10876,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10876*/.
            assign v_wgh_focus = v_cod_unid_orctaria:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
            return error.
        end.
        find first vers_orcto_ctbl_bgc no-lock
             where vers_orcto_ctbl_bgc.cod_cenar_orctario  = cenar_orctario_bgc.cod_cenar_orctario
               and vers_orcto_ctbl_bgc.cod_unid_orctaria   = unid_orctaria.cod_unid_orctaria
               and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_num_seq_orcto_ctbl
               and vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_vers_orcto_ctbl no-error.
        if  not avail vers_orcto_ctbl_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Vers∆o Oráamento Cont†bil", "Oráamentos Cont†beis")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_vers_orcto_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505_cons.
            return error.
        end.
    end.

    IF input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_orctaria                             <> v_cod_unid_orctaria
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_num_seq_orcto_ctbl                         <> v_num_seq_orcto_ctbl
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl                             <> v_cod_cenar_ctbl
       OR int(input frame f_dlg_04_conjto_prefer_demonst_505_cons v_val_cotac_1)                           <> int(v_val_cotac_1)
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_ctbl         <> conjto_prefer_demonst.cod_cenar_ctbl      
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.dat_cotac_indic_econ   <> conjto_prefer_demonst.dat_cotac_indic_econ
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_cenar_orctario     <> conjto_prefer_demonst.cod_cenar_orctario  
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_vers_orcto_ctbl    <> conjto_prefer_demonst.cod_vers_orcto_ctbl 
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ       <> conjto_prefer_demonst.cod_finalid_econ
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons conjto_prefer_demonst.cod_finalid_econ_apres <> conjto_prefer_demonst.cod_finalid_econ_apres
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_ini                              <> conjto_prefer_demonst.cod_estab_inic
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_fim                              <> conjto_prefer_demonst.cod_estab_fim      
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_ini                         <> conjto_prefer_demonst.cod_unid_negoc_inic
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_fim                         <> conjto_prefer_demonst.cod_unid_negoc_fim 
       OR input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto                                 <> v_cod_ccusto
       OR (v_des_sdo_ctbl_ini:SENSITIVE IN frame f_dlg_04_conjto_prefer_demonst_505_cons = YES 
           AND v_des_sdo_ctbl_inic_ant <> v_des_sdo_ctbl_ini)
       OR (v_des_sdo_ctbl_fim:SENSITIVE IN frame f_dlg_04_conjto_prefer_demonst_505_cons = yes
           AND v_des_sdo_ctbl_fim_ant <> v_des_sdo_ctbl_fim)
       then
        assign v_log_alterado = yes.

    assign conjto_prefer_demonst.cod_finalid_econ
           conjto_prefer_demonst.cod_finalid_econ_apres.
    if  conjto_prefer_demonst.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ_apres
    then do:
        assign v_val_cotac_1:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons = "1".
    end.

    if  v_ind_selec_tip_demo <> "Saldo Conta Cont†bil" /*l_saldo_conta_contabil_demo*/  then do:
        IF conjto_prefer_demonst.cod_cta_ctbl_inic <> input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl THEN
            ASSIGN v_log_alterado = YES.
        assign conjto_prefer_demonst.cod_cta_ctbl_inic = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl
               conjto_prefer_demonst.cod_cta_ctbl_fim  = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cta_ctbl.
    end.

    assign v_wgh_focus = ?
           input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_orctaria
           input frame f_dlg_04_conjto_prefer_demonst_505_cons v_num_seq_orcto_ctbl
           input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl
           input frame f_dlg_04_conjto_prefer_demonst_505_cons v_val_cotac_1
           conjto_prefer_demonst.cod_cenar_ctbl
           conjto_prefer_demonst.dat_cotac_indic_econ
           conjto_prefer_demonst.cod_cenar_orctario
           conjto_prefer_demonst.cod_vers_orcto_ctbl
           conjto_prefer_demonst.cod_estab_inic              = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_ini
           conjto_prefer_demonst.cod_estab_fim               = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_estab_fim
           conjto_prefer_demonst.cod_unid_negoc_inic         = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_ini
           conjto_prefer_demonst.cod_unid_negoc_fim          = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_negoc_fim
           conjto_prefer_demonst.val_cotac_indic_econ        = v_val_cotac_1
           conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa   = v_cod_cta_prefer_pfixa
           conjto_prefer_demonst.cod_cta_ctbl_prefer_excec   = v_cod_cta_prefer_excec
           &if '{&emsfin_version}' > '5.05' &then
           conjto_prefer_demonst.cod_unid_orctaria           = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_unid_orctaria
           conjto_prefer_demonst.num_seq_orcto_ctbl          = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_num_seq_orcto_ctbl
           conjto_prefer_demonst.cod_ccusto_inic             = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto
           conjto_prefer_demonst.cod_ccusto_fim              = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto
           conjto_prefer_demonst.cod_ccusto_pfixa            = v_cod_ccusto_prefer_pfixa
           conjto_prefer_demonst.cod_ccusto_excec            = v_cod_ccusto_prefer_excec
           conjto_prefer_demonst.cod_cenar_ctbl_2            = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_cenar_ctbl
           /* Rodrigo - ATV24243*/
           conjto_prefer_demonst.cod_exerc_period_1          = substring(v_des_sdo_ctbl_ini,1,4)
                                                               + substring(v_des_sdo_ctbl_ini,5,2)
           conjto_prefer_demonst.cod_exerc_period_2          = substring(v_des_sdo_ctbl_fim,1,4)
                                                               + substring(v_des_sdo_ctbl_fim,5,2)
           /* Rodrigo - ATV24243*/
           &else
           conjto_prefer_demonst.dat_livre_1                 = v_dat_fim_period_1
           conjto_prefer_demonst.cod_livre_1                 = v_cod_unid_orctaria          + chr(10) +
                                                               string(v_num_seq_orcto_ctbl) + chr(10) +
                                                               v_cod_cenar_ctbl             + chr(10) +
                                                               if string(v_dat_fim_period_2) <> ? then string(v_dat_fim_period_2)
                                                               else ""
           &endif
           .

    /* --- Salvar dados referentes a CCusto e Projeto ---*/
    &if '{&emsfin_version}' <= '5.05' &then
        if  not avail tab_livre_emsfin
        then do:
           create tab_livre_emsfin.
           assign tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                  tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                  tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl).
        end.
        assign tab_livre_emsfin.cod_livre_1 = "" /*l_null*/  + chr(10) +
                                              "ZZZZZZZZZZZZZZZZZZZZ" /*l_zzzzzzzzzzzzzzzzzzzz*/  + chr(10) +
                                              '####################' + chr(10) +
                                              '####################'.
        if  v_cod_ccusto:screen-value in frame f_dlg_04_conjto_prefer_demonst_505_cons <> ""
        then do:
            assign tab_livre_emsfin.cod_livre_2 = input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto + chr(10) +
                                                  input frame f_dlg_04_conjto_prefer_demonst_505_cons v_cod_ccusto + chr(10) +
                                                  v_cod_ccusto_prefer_pfixa          + chr(10) +
                                                  v_cod_ccusto_prefer_excec.
        end.
    &endif
END PROCEDURE. /* pi_vld_conjto_prefer_demonst_505_cons */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_inic_max
** Descricao.............: pi_retornar_inic_max
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: bre17205
** Alterado em...........: 17/01/2001 18:05:59
*****************************************************************************/
PROCEDURE pi_retornar_inic_max:

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
            if  substring(p_cod_format_cta_ctbl,v_num_count_cta,1) = "9"
            then do:
                assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + "9".
            end /* if */.
            else do:
                assign v_cod_cta_ctbl_000 = v_cod_cta_ctbl_000 + keylabel(90).
            end /* else */.
        end /* if */.
        assign v_num_count_cta = v_num_count_cta + 1.
    end /* do contador */.



    assign p_wgh_attrib:format       = p_cod_format_cta_ctbl 
           p_wgh_attrib:screen-value = v_cod_cta_ctbl_000 no-error.

END PROCEDURE. /* pi_retornar_inic_max */


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
/****************  End of fnc_conjto_prefer_demonst_505_cons ****************/
