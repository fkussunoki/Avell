/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_conjto_prefer_demonst_505
** Descricao.............: Funá‰es Conjunto Preferàncias
** Versao................:  1.00.00.023
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204zd.p
** Data Geracao..........: 04/09/2012 - 15:08:59
** Criado por............: src388
** Criado em.............: 28/05/2001 10:20:23
** Alterado por..........: fut42625
** Alterado em...........: 21/03/2011 16:12:24
** Gerado por............: fut41422_3
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.023":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_conjto_prefer_demonst_505 MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/



/************************** Buffer Definition Begin *************************/

&if "{&emsuni_version}" >= "1.00" &then
def buffer b_finalid_econ
    for finalid_econ.
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
def var v_cod_ccusto_fim
    as Character
    format "x(11)":U
    initial "999999"
    label "CCusto Final"
    column-label "Centro Custo"
    no-undo.
def var v_cod_ccusto_inic
    as character
    format "x(11)":U
    label "C.Custo Inicial"
    column-label "C.Custo Inicial"
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
def var v_cod_cenar_orctario
    as character
    format "x(8)":U
    label "Cenar Orctario"
    column-label "Cen†rio Oráament†rio"
    no-undo.
def shared var v_cod_cta_ctbl_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "Conta Final"
    column-label "Final"
    no-undo.
def shared var v_cod_cta_ctbl_ini
    as character
    format "x(20)":U
    label "Conta Inicial"
    column-label "Inicial"
    no-undo.
def shared var v_cod_cta_prefer_excec
    as character
    format "x(20)":U
    initial "####################"
    label "Exceá∆o"
    column-label "Exceá∆o"
    no-undo.
def shared var v_cod_cta_prefer_pfixa
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
def var v_cod_format_ccusto
    as character
    format "x(11)":U
    initial "x(11)" /*l_x(11)*/
    label "Formato CCusto"
    column-label "Formato CCusto"
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
def var v_cod_plano_ccusto
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
def var v_cod_proj_financ_fim
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "Projeto Final"
    column-label "Projeto"
    no-undo.
def var v_cod_proj_financ_inic
    as character
    format "x(20)":U
    label "Projeto Inicial"
    no-undo.
def var v_cod_proj_financ_prefer_excec
    as character
    format "x(20)":U
    label "Exceá∆o"
    no-undo.
def var v_cod_proj_financ_prefer_pfixa
    as character
    format "x(20)":U
    label "Parte Fixa"
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
def var v_cod_unid_organ_orig_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "UO Origem"
    column-label "UO Origem"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_unid_organ_orig_fim
    as Character
    format "x(5)":U
    initial "ZZZZZ"
    label "UO Origem"
    column-label "UO Origem"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_unid_organ_orig_ini
    as character
    format "x(3)":U
    label "UO Origem"
    column-label "UO Origem"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_unid_organ_orig_ini
    as Character
    format "x(5)":U
    label "UO Origem"
    column-label "UO Origem"
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
def var v_cod_vers_orcto_ctbl
    as character
    format "x(10)":U
    label "Vers∆o Oráamento"
    column-label "Vers∆o Oráamento"
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
def var v_log_habilita_orcto
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_next
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_prev
    as logical
    format "Sim/N∆o"
    initial NO
    view-as toggle-box
    label "Previs∆o"
    column-label "Previs∆o"
    no-undo.
def var v_log_repeat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
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
def new global shared var v_rec_proj_financ
    as recid
    format ">>>>>>9":U
    initial ?
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
def rectangle rt_007
    size 1 by 1
    edge-pixels 2.
def rectangle rt_008
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
def button bt_sav
    label "Salva"
    tooltip "Salva"
    size 1 by 1
    auto-go.
def button bt_zoo3
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo4
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo5
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo6
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/im-zoo"
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
def button bt_zoo_325210
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325211
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325212
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325213
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325214
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325233
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325234
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325237
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325238
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325244
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325245
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325246
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325247
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325252
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_325253
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_04_conjto_prefer_demonst_505
    rt_002
         at row 02.75 col 02.14 bgcolor 8 
    rt_003
         at row 03.13 col 03.29
    " Apresentaá∆o " view-as text
         at row 02.83 col 05.29 bgcolor 8 
    rt_006
         at row 03.13 col 43.00
    " Conta Cont†bil " view-as text
         at row 02.83 col 45.00
    rt_007
         at row 08.38 col 43.00
    " CCusto " view-as text
         at row 08.08 col 45.00 bgcolor 8 
    rt_008
         at row 13.38 col 43.00 bgcolor 8 
    rt_005
         at row 13.38 col 03.29
    " Oráamentos " view-as text
         at row 13.08 col 05.29 bgcolor 8 
    rt_004
         at row 09.38 col 03.29
    " Estrut Organiz " view-as text
         at row 09.08 col 05.29 bgcolor 8 
    rt_cxcf
         at row 18.17 col 02.00 bgcolor 7 
    rt_001
         at row 01.21 col 02.14 bgcolor 8 
    conjto_prefer_demonst.num_conjto_param_ctbl
         at row 01.42 col 33.00 colon-aligned label "Conjunto ParÉmetros"
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    conjto_prefer_demonst.cod_cenar_ctbl
         at row 03.63 col 15.57 colon-aligned label "Cen†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325210
         at row 03.63 col 26.71
    conjto_prefer_demonst.cod_finalid_econ
         at row 04.63 col 15.57 colon-aligned label "Finalidade"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325212
         at row 04.63 col 28.71
    conjto_prefer_demonst.cod_finalid_econ_apres
         at row 05.63 col 15.57 colon-aligned label "Apresentaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325213
         at row 05.63 col 28.71
    conjto_prefer_demonst.dat_cotac_indic_econ
         at row 06.63 col 15.57 colon-aligned label "Data Cotaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_cotac_1
         at row 07.63 col 15.57 colon-aligned label "Valor"
         help "Valor Cotaá∆o Paridade"
         view-as fill-in
         size-chars 20.14 by .88
         fgcolor ? bgcolor 15 font 2
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ_orig_ini
         at row 09.75 col 15.57 colon-aligned label "UO Origem"
         help "Unidade Organ Origem Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325247
         at row 09.75 col 21.71
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ_orig_ini
         at row 09.75 col 15.57 colon-aligned label "UO Origem"
         help "Unidade Organ Origem Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325247
         at row 09.75 col 23.71
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ_ini
         at row 09.75 col 15.57 colon-aligned label "UO Inicial"
         help "Unidade Organizacional Origem Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325253
         at row 09.75 col 21.71
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ_ini
         at row 09.75 col 15.57 colon-aligned label "UO Inicial"
         help "Unidade Organizacional Origem Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325253
         at row 09.75 col 23.71
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ_orig_fim
         at row 09.75 col 29.00 colon-aligned label "atÇ"
         help "Unidade Organ Origem Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325246
         at row 09.75 col 35.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ_orig_fim
         at row 09.75 col 29.00 colon-aligned label "atÇ"
         help "Unidade Organ Origem Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325246
         at row 09.75 col 37.14
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ_fim
         at row 09.75 col 29.00 colon-aligned label "atÇ"
         help "Unidade Organizacional Origem Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325252
         at row 09.75 col 35.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ_fim
         at row 09.75 col 29.00 colon-aligned label "atÇ"
         help "Unidade Organizacional Origem Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325252
         at row 09.75 col 37.14
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_ini
         at row 10.75 col 15.57 colon-aligned label "Estabelecimento"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325238
         at row 10.75 col 21.71
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_ini
         at row 10.75 col 15.57 colon-aligned label "Estabelecimento"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325238
         at row 10.75 col 23.71
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_fim
         at row 10.75 col 29.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325237
         at row 10.75 col 35.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_fim
         at row 10.75 col 29.00 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325237
         at row 10.75 col 37.14
&ENDIF
    v_cod_unid_negoc_ini
         at row 11.75 col 15.57 colon-aligned label "Unid Neg¢cio"
         help "Unidade de Neg¢cio Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325245
         at row 11.75 col 21.71
    v_cod_unid_negoc_fim
         at row 11.75 col 29.00 colon-aligned label "atÇ"
         help "Unidade de Neg¢cio Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325244
         at row 11.75 col 35.14
    conjto_prefer_demonst.cod_cenar_orctario
         at row 13.75 col 15.57 colon-aligned label "Cen†rio"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325211
         at row 13.75 col 26.71
    v_cod_unid_orctaria
         at row 14.75 col 15.57 colon-aligned label "Un Orctaria"
         help "C¢digo Unidade Orcamentaria"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo7
         at row 14.75 col 26.72 font ?
         help "Zoom"
    v_num_seq_orcto_ctbl
         at row 15.75 col 15.57 colon-aligned label "Seq Orc Ctbl"
         help "Sequencia Orcamento Contabil"
         view-as fill-in
         size-chars 10.14 by .88
         fgcolor ? bgcolor 15 font 2
    conjto_prefer_demonst.cod_vers_orcto_ctbl
         at row 16.75 col 15.57 colon-aligned label "Vers∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325214
         at row 16.75 col 28.71
    v_cod_cta_ctbl_ini
         at row 03.79 col 54.00 colon-aligned label "Inicial"
         help "C¢digo Conta Cont†bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325234
         at row 03.79 col 77.14
    v_cod_cta_ctbl_fim
         at row 04.79 col 54.00 colon-aligned label "Final"
         help "C¢digo Conta Cont†bil"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_325233
         at row 04.79 col 77.14
    v_cod_cta_prefer_pfixa
         at row 05.79 col 54.00 colon-aligned label "Parte Fixa"
         help "Parte Fixa da Conta Ctbl no Conjto Prefer"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_prefer_excec
         at row 06.79 col 54.00 colon-aligned label "Exceá∆o"
         help "Exceá∆o da Conta Ctbl no Conjto Prefer"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ccusto_inic
         at row 08.75 col 56.00 no-label
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo3
         at row 08.75 col 77.00 font ?
         help "Zoom"
    v_cod_ccusto_fim
         at row 09.75 col 56.00 no-label
         help "C¢digo Centro Custo"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo4
         at row 09.75 col 77.00 font ?
         help "Zoom"
    v_cod_ccusto_prefer_pfixa
         at row 10.75 col 54.00 colon-aligned label "Parte Fixa"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ccusto_prefer_excec
         at row 11.75 col 54.00 colon-aligned label "Exceá∆o"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_proj_financ_inic
         at row 13.75 col 54.00 colon-aligned label "Projeto Inicial"
         help "Informe o Projeto Inicial"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo5
         at row 13.75 col 77.00 font ?
         help "Zoom"
    v_cod_proj_financ_fim
         at row 14.75 col 54.00 colon-aligned label "Projeto Final"
         help "Infome o Projeto Final"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo6
         at row 14.75 col 77.00 font ?
         help "Zoom"
    v_cod_proj_financ_prefer_pfixa
         at row 15.75 col 54.00 colon-aligned label "Parte Fixa"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_proj_financ_prefer_excec
         at row 16.75 col 54.00 colon-aligned label "Exceá∆o"
         view-as fill-in
         size-chars 21.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 18.38 col 03.00 font ?
         help "OK"
    bt_sav
         at row 18.38 col 14.00 font ?
         help "Salva"
    bt_can
         at row 18.38 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 18.38 col 73.72 font ?
         help "Ajuda"
    "Inicial:"
         at row 08.75 col 50.43 font 1
         view-as text /*l_Inicial:*/
    "  Final:"
         at row 09.75 col 50.43 font 1
         view-as text /*l_bbfinal:*/
    bt_pre2
         at row 18.38 col 38.86 font ?
         help "Ocorrància Anterior da Tabela"
    bt_nex2
         at row 18.38 col 43.72 font ?
         help "Pr¢xima Ocorrància da Tabela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 86.14 by 20.00 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Conjunto Preferàncias".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 10.00
           bt_can:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_hel2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 10.00
           bt_hel2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_nex2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_nex2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_ok:width-chars    in frame f_dlg_04_conjto_prefer_demonst_505 = 10.00
           bt_ok:height-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_pre2:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_pre2:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_sav:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 10.00
           bt_sav:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 01.00
           bt_zoo3:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_zoo3:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 00.88
           bt_zoo4:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_zoo4:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 00.88
           bt_zoo5:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_zoo5:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 00.88
           bt_zoo6:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_zoo6:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 00.88
           bt_zoo7:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.00
           bt_zoo7:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 00.88
           rt_001:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 82.72
           rt_001:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 01.33
           rt_002:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 82.72
           rt_002:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 15.38
           rt_003:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 38.86
           rt_003:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 05.75
           rt_004:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 38.86
           rt_004:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 03.63
           rt_005:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 38.86
           rt_005:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.50
           rt_006:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 40.57
           rt_006:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.88
           rt_007:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 40.57
           rt_007:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.63
           rt_008:width-chars   in frame f_dlg_04_conjto_prefer_demonst_505 = 40.57
           rt_008:height-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 04.50
           rt_cxcf:width-chars  in frame f_dlg_04_conjto_prefer_demonst_505 = 82.72
           rt_cxcf:height-chars in frame f_dlg_04_conjto_prefer_demonst_505 = 01.42.
    /* set private-data for the help system */
    assign conjto_prefer_demonst.num_conjto_param_ctbl:private-data  in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000023500":U
           bt_zoo_325210:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           conjto_prefer_demonst.cod_cenar_ctbl:private-data         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000010457":U
           bt_zoo_325212:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           conjto_prefer_demonst.cod_finalid_econ:private-data       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000021908":U
           bt_zoo_325213:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           conjto_prefer_demonst.cod_finalid_econ_apres:private-data in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000013407":U
           conjto_prefer_demonst.dat_cotac_indic_econ:private-data   in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000023200":U
           v_val_cotac_1:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000023498":U
           bt_zoo_325247:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325247:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_organ_orig_ini:private-data                    in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo_325253:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325253:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_organ_ini:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000021915":U
           bt_zoo_325246:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325246:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_organ_orig_fim:private-data                    in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo_325252:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325252:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_organ_fim:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000021916":U
           bt_zoo_325238:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325238:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_estab_ini:private-data                              in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000016633":U
           bt_zoo_325237:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           bt_zoo_325237:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_estab_fim:private-data                              in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000016634":U
           bt_zoo_325245:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_negoc_ini:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000019459":U
           bt_zoo_325244:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_unid_negoc_fim:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000019460":U
           bt_zoo_325211:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           conjto_prefer_demonst.cod_cenar_orctario:private-data     in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000013850":U
           v_cod_unid_orctaria:private-data                          in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo7:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           v_num_seq_orcto_ctbl:private-data                         in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo_325214:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           conjto_prefer_demonst.cod_vers_orcto_ctbl:private-data    in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000013956":U
           bt_zoo_325234:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_cta_ctbl_ini:private-data                           in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000019246":U
           bt_zoo_325233:private-data                                in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009431":U
           v_cod_cta_ctbl_fim:private-data                           in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000019247":U
           v_cod_cta_prefer_pfixa:private-data                       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000023503":U
           v_cod_cta_prefer_excec:private-data                       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000023502":U
           v_cod_ccusto_inic:private-data                            in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo3:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009433":U
           v_cod_ccusto_fim:private-data                             in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000019467":U
           bt_zoo4:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009434":U
           v_cod_ccusto_prefer_pfixa:private-data                    in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           v_cod_ccusto_prefer_excec:private-data                    in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           v_cod_proj_financ_inic:private-data                       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo5:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000009435":U
           v_cod_proj_financ_fim:private-data                        in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_zoo6:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           v_cod_proj_financ_prefer_pfixa:private-data               in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           v_cod_proj_financ_prefer_excec:private-data               in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000000000":U
           bt_ok:private-data                                        in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000010721":U
           bt_sav:private-data                                       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000011048":U
           bt_can:private-data                                       in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000011050":U
           bt_hel2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000011326":U
           bt_pre2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000010824":U
           bt_nex2:private-data                                      in frame f_dlg_04_conjto_prefer_demonst_505 = "HLP=000010823":U
           frame f_dlg_04_conjto_prefer_demonst_505:private-data                                                 = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_325210:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325212:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325213:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325247:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325247:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325253:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325253:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325246:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325246:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325252:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325252:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325238:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325238:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325237:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325237:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325245:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325244:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325211:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325214:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325234:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes
           bt_zoo_325233:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 = yes.
    /* move buttons to top */
    bt_zoo_325210:move-to-top().
    bt_zoo_325212:move-to-top().
    bt_zoo_325213:move-to-top().
    bt_zoo_325247:move-to-top().
    bt_zoo_325247:move-to-top().
    bt_zoo_325253:move-to-top().
    bt_zoo_325253:move-to-top().
    bt_zoo_325246:move-to-top().
    bt_zoo_325246:move-to-top().
    bt_zoo_325252:move-to-top().
    bt_zoo_325252:move-to-top().
    bt_zoo_325238:move-to-top().
    bt_zoo_325238:move-to-top().
    bt_zoo_325237:move-to-top().
    bt_zoo_325237:move-to-top().
    bt_zoo_325245:move-to-top().
    bt_zoo_325244:move-to-top().
    bt_zoo_325211:move-to-top().
    bt_zoo_325214:move-to-top().
    bt_zoo_325234:move-to-top().
    bt_zoo_325233:move-to-top().



{include/i_fclfrm.i f_dlg_04_conjto_prefer_demonst_505 }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_nex2 IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    valid_block:
    DO ON ERROR UNDO valid_block.
       run pi_vld_conjto_prefer_demonst_505 /*pi_vld_conjto_prefer_demonst_505*/.
    END.

    IF  ERROR-STATUS:ERROR THEN DO:
        apply "entry" to v_wgh_focus.
        RETURN NO-APPLY.
    END.

    find next conjto_prefer_demonst of prefer_demonst_ctbl exclusive-lock no-error.
    if  not avail conjto_prefer_demonst
    then do:
        find last conjto_prefer_demonst of prefer_demonst_ctbl exclusive-lock no-error.
        if  avail conjto_prefer_demonst
        then do:
            message "Èltima ocorrància da tabela." /*l_last*/ 
                   view-as alert-box warning buttons ok.
            assign v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
        end /* if */.
        else do:
            clear frame f_dlg_04_conjto_prefer_demonst_505 no-pause.
            message "N∆o existem ocorràncias na tabela." /*l_no_record*/ 
                   view-as alert-box warning buttons ok.
            assign v_rec_conjto_prefer_demonst = ?.
        end /* else */.
    end /* if */.
    else do:
        assign v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
        run pi_init_fnc_conjto_prefer_demonst_505 /*pi_init_fnc_conjto_prefer_demonst_505*/.
    end /* else */.

    assign v_log_save = yes
           v_log_repeat = yes.

    /* FUT1082 - atividade 119756.*/
    assign v_log_next = yes.       
END. /* ON CHOOSE OF bt_nex2 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_ok IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    run pi_valida_salva /*pi_valida_salva*/.
    if return-value <> 'OK' then
        return no-apply.

    assign v_log_save = yes
           v_log_repeat = no.
END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_pre2 IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    valid_block:
    DO ON ERROR UNDO valid_block.
       run pi_vld_conjto_prefer_demonst_505 /*pi_vld_conjto_prefer_demonst_505*/.
    END.

    IF  ERROR-STATUS:ERROR THEN DO:
        apply "entry" to v_wgh_focus.
        RETURN NO-APPLY.
    END.

    find prev conjto_prefer_demonst of prefer_demonst_ctbl exclusive-lock no-error.
    if  not avail conjto_prefer_demonst
    then do:
        find first conjto_prefer_demonst of prefer_demonst_ctbl exclusive-lock no-error.
        if  avail conjto_prefer_demonst
        then do:
            message "Primeira ocorrància da tabela." /*l_first*/ 
                   view-as alert-box warning buttons ok.
            assign v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
        end /* if */.
        else do:
            clear frame f_dlg_04_conjto_prefer_demonst_505 no-pause.
            message "N∆o existem ocorràncias na tabela." /*l_no_record*/ 
                   view-as alert-box warning buttons ok.
            assign v_rec_conjto_prefer_demonst = ?.
        end /* else */.
    end /* if */.
    else do:
        assign v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
        run pi_init_fnc_conjto_prefer_demonst_505 /*pi_init_fnc_conjto_prefer_demonst_505*/.
    end /* else */.

    assign v_log_save = yes
           v_log_repeat = yes.

    /* FUT1082 - atividade 119756.*/
    assign v_log_prev = yes.  
END. /* ON CHOOSE OF bt_pre2 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_sav IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    run pi_valida_salva /*pi_valida_salva*/.
    if return-value <> 'OK' then
        return no-apply.

    assign v_log_save = yes
           v_log_repeat = yes.
END. /* ON CHOOSE OF bt_sav IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_04_conjto_prefer_demonst_505
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
           assign v_cod_ccusto_inic:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = string(ccusto.cod_ccusto,v_cod_format_ccusto).

        apply "entry" to v_cod_ccusto_inic in frame f_dlg_04_conjto_prefer_demonst_505.
    end.
END. /* ON CHOOSE OF bt_zoo3 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_zoo4 IN FRAME f_dlg_04_conjto_prefer_demonst_505
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
           assign v_cod_ccusto_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = string(ccusto.cod_ccusto,v_cod_format_ccusto).

        apply "entry" to v_cod_ccusto_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end.
END. /* ON CHOOSE OF bt_zoo4 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_zoo5 IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if  search("prgint/utb/utb044ka.r") = ? and search("prgint/utb/utb044ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb044ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb044ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb044ka.p /*prg_sea_proj_financ*/.
    if  v_rec_proj_financ <> ? then do:
        find proj_financ 
           where recid(proj_financ) = v_rec_proj_financ no-lock no-error. 
        if v_cod_format_proj_financ <> "" then
            assign v_cod_proj_financ_inic:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = string(proj_financ.cod_proj_financ,v_cod_format_proj_financ).
        else
            assign v_cod_proj_financ_inic:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = proj_financ.cod_proj_financ.    

        apply "entry" to v_cod_proj_financ_inic in frame f_dlg_04_conjto_prefer_demonst_505.
    end.
END. /* ON CHOOSE OF bt_zoo5 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_zoo6 IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if  search("prgint/utb/utb044ka.r") = ? and search("prgint/utb/utb044ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb044ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb044ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb044ka.p /*prg_sea_proj_financ*/.
    if  v_rec_proj_financ <> ? then do:
        find proj_financ 
           where recid(proj_financ) = v_rec_proj_financ no-lock no-error.
        if v_cod_format_proj_financ <> "" then       
            assign v_cod_proj_financ_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = string(proj_financ.cod_proj_financ,v_cod_format_proj_financ).
        else
            assign v_cod_proj_financ_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = proj_financ.cod_proj_financ.    

        apply "entry" to v_cod_proj_financ_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end.
END. /* ON CHOOSE OF bt_zoo6 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON CHOOSE OF bt_zoo7 IN FRAME f_dlg_04_conjto_prefer_demonst_505
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
           assign v_cod_unid_orctaria:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = unid_orctaria.cod_unid_orctaria.

        apply "entry" to v_cod_unid_orctaria in frame f_dlg_04_conjto_prefer_demonst_505.
    end.
END. /* ON CHOOSE OF bt_zoo7 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON LEAVE OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if conjto_prefer_demonst.cod_cenar_ctbl <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_ctbl then
        assign v_log_alterado = yes.
END. /* ON LEAVE OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if conjto_prefer_demonst.cod_finalid_econ <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ then
        assign v_log_alterado = yes.
    if  conjto_prefer_demonst.cod_finalid_econ:screen-value = conjto_prefer_demonst.cod_finalid_econ_apres:screen-value
    then do:
        disable conjto_prefer_demonst.dat_cotac_indic_econ
                v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.
    else do:
        enable conjto_prefer_demonst.dat_cotac_indic_econ
               v_val_cotac_1
               with frame f_dlg_04_conjto_prefer_demonst_505.
    end /* else */.
END. /* ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if conjto_prefer_demonst.cod_finalid_econ_apres <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ_apres then
        assign v_log_alterado = yes.
    if  conjto_prefer_demonst.cod_finalid_econ:screen-value = conjto_prefer_demonst.cod_finalid_econ_apres:screen-value
    then do:
        assign v_val_cotac_1 = 1.
        display v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505.
        disable conjto_prefer_demonst.dat_cotac_indic_econ
                v_val_cotac_1
                with frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.
    else do:
        enable conjto_prefer_demonst.dat_cotac_indic_econ
               v_val_cotac_1
               with frame f_dlg_04_conjto_prefer_demonst_505.
    end /* else */.
END. /* ON LEAVE OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON ENTRY OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if  v_rec_vers_orcto_ctbl_bgc <> ?
    and avail vers_orcto_ctbl_bgc then
        assign v_num_seq_orcto_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = string(vers_orcto_ctbl_bgc.num_seq_orcto_ctbl)
               v_cod_unid_orctaria:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = vers_orcto_ctbl_bgc.cod_unid_orctaria
               conjto_prefer_demonst.cod_cenar_orctario:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = vers_orcto_ctbl_bgc.cod_cenar_orctario
               v_rec_vers_orcto_ctbl_bgc = ? .
END. /* ON ENTRY OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON LEAVE OF conjto_prefer_demonst.dat_cotac_indic_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505
DO:

    if conjto_prefer_demonst.dat_cotac_indic_econ <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.dat_cotac_indic_econ then
        assign v_log_alterado = yes.
    /* --- Verifica Convers∆o de Moedas ---*/
    if  (input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ <>
         input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ_apres)
    or  (input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.dat_cotac_indic_econ <>
         conjto_prefer_demonst.dat_cotac_indic_econ)
    then do:
        run pi_retornar_indic_econ_finalid (Input input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ,
                                            Input input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.dat_cotac_indic_econ,
                                            output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
        run pi_retornar_indic_econ_finalid (Input input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ_apres,
                                            Input input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.dat_cotac_indic_econ,
                                            output v_cod_indic_econ_apres) /*pi_retornar_indic_econ_finalid*/.
        run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                       Input v_cod_indic_econ_apres,
                                       Input input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.dat_cotac_indic_econ,
                                       Input "Real" /*l_real*/,
                                       output v_dat_cotac_indic_econ,
                                       output v_val_cotac_1,
                                       output v_cod_return) /*pi_achar_cotac_indic_econ*/.
    end /* if */.
    display v_val_cotac_1
            with frame f_dlg_04_conjto_prefer_demonst_505.
END. /* ON LEAVE OF conjto_prefer_demonst.dat_cotac_indic_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505 */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_325210 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF conjto_prefer_demonst.cod_cenar_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
                string(cenar_ctbl.cod_cenar_ctbl).
        apply "entry" to conjto_prefer_demonst.cod_cenar_ctbl in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325210 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325211 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF conjto_prefer_demonst.cod_cenar_orctario IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign conjto_prefer_demonst.cod_cenar_orctario:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(cenar_orctario_bgc.cod_cenar_orctario).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_cenar_orctario in frame f_dlg_04_conjto_prefer_demonst_505.
end. /* ON  CHOOSE OF bt_zoo_325211 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325212 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF conjto_prefer_demonst.cod_finalid_econ IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign conjto_prefer_demonst.cod_finalid_econ:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(finalid_econ.cod_finalid_econ).
        apply "entry" to conjto_prefer_demonst.cod_finalid_econ in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325212 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325213 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF conjto_prefer_demonst.cod_finalid_econ_apres IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign conjto_prefer_demonst.cod_finalid_econ_apres:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(finalid_econ.cod_finalid_econ).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_finalid_econ_apres in frame f_dlg_04_conjto_prefer_demonst_505.
end. /* ON  CHOOSE OF bt_zoo_325213 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325214 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF conjto_prefer_demonst.cod_vers_orcto_ctbl IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign conjto_prefer_demonst.cod_vers_orcto_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl).

    end /* if */.
    apply "entry" to conjto_prefer_demonst.cod_vers_orcto_ctbl in frame f_dlg_04_conjto_prefer_demonst_505.
end. /* ON  CHOOSE OF bt_zoo_325214 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325233 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_cta_ctbl_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_cta_ctbl_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(cta_ctbl.cod_cta_ctbl).

        apply "entry" to v_cod_cta_ctbl_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325233 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325234 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_cta_ctbl_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_cta_ctbl_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(cta_ctbl.cod_cta_ctbl).

        apply "entry" to v_cod_cta_ctbl_ini in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325234 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325237 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_estab_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_estab_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(estabelecimento.cod_estab).

        apply "entry" to v_cod_estab_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325237 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325238 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_estab_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_estab_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(estabelecimento.cod_estab).

        apply "entry" to v_cod_estab_ini in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325238 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325244 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_negoc_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_unid_negoc_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325244 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325245 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_negoc_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

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
        assign v_cod_unid_negoc_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_ini in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325245 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325246 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_organ_orig_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb010ka.r") = ? and search("prgint/utb/utb010ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb010ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb010ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb010ka.p /*prg_sea_unid_organ*/.
    if  v_rec_unid_organ <> ?
    then do:
        find emsuni.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
        assign v_cod_unid_organ_orig_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ_orig_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325246 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325247 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_organ_orig_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb010ka.r") = ? and search("prgint/utb/utb010ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb010ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb010ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb010ka.p /*prg_sea_unid_organ*/.
    if  v_rec_unid_organ <> ?
    then do:
        find emsuni.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
        assign v_cod_unid_organ_orig_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ_orig_ini in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325247 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325252 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_organ_fim IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb010ka.r") = ? and search("prgint/utb/utb010ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb010ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb010ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb010ka.p /*prg_sea_unid_organ*/.
    if  v_rec_unid_organ <> ?
    then do:
        find emsuni.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
        assign v_cod_unid_organ_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ_fim in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325252 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON  CHOOSE OF bt_zoo_325253 IN FRAME f_dlg_04_conjto_prefer_demonst_505
OR F5 OF v_cod_unid_organ_ini IN FRAME f_dlg_04_conjto_prefer_demonst_505 DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb010ka.r") = ? and search("prgint/utb/utb010ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb010ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb010ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb010ka.p /*prg_sea_unid_organ*/.
    if  v_rec_unid_organ <> ?
    then do:
        find emsuni.unid_organ where recid(unid_organ) = v_rec_unid_organ no-lock no-error.
        assign v_cod_unid_organ_ini:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ_ini in frame f_dlg_04_conjto_prefer_demonst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_325253 IN FRAME f_dlg_04_conjto_prefer_demonst_505 */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_04_conjto_prefer_demonst_505 ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_conjto_prefer_demonst_505 ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_conjto_prefer_demonst_505 */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_conjto_prefer_demonst_505 ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_conjto_prefer_demonst_505 */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_04_conjto_prefer_demonst_505.





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


        assign v_nom_prog     = substring(frame f_dlg_04_conjto_prefer_demonst_505:title, 1, max(1, length(frame f_dlg_04_conjto_prefer_demonst_505:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_conjto_prefer_demonst_505":U.




    assign v_nom_prog_ext = "prgfin/mgl/MGLA204zd.p":U
           v_cod_release  = trim(" 1.00.00.023":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_conjto_prefer_demonst_505}


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
    run pi_version_extract ('fnc_conjto_prefer_demonst_505':U, 'prgfin/mgl/MGLA204zd.p':U, '1.00.00.023':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.


/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "fnc_conjto_prefer_demonst_505":U
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


assign v_wgh_frame_epc = frame f_dlg_04_conjto_prefer_demonst_505:handle.



assign v_nom_table_epc = 'conjto_prefer_demonst':U
       v_rec_table_epc = recid(conjto_prefer_demonst).

&endif

/* End_Include: i_verify_program_epc */


assign v_cod_ccusto_inic:width in frame f_dlg_04_conjto_prefer_demonst_505 = 21.14
       v_cod_ccusto_fim:width  in frame f_dlg_04_conjto_prefer_demonst_505 = 21.14
       v_cod_ccusto_prefer_pfixa:width  in frame f_dlg_04_conjto_prefer_demonst_505 = 21.14
       v_cod_ccusto_prefer_excec:width  in frame f_dlg_04_conjto_prefer_demonst_505 = 21.14.

pause 0 before-hide.
view frame f_dlg_04_conjto_prefer_demonst_505.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'INITIALIZE',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */

find padr_col_demonst_ctbl no-lock
   where recid(padr_col_demonst_ctbl) = v_rec_padr_col_demonst_ctbl no-error.
find prefer_demonst_ctbl no-lock
   where recid(prefer_demonst_ctbl) = v_rec_prefer_demonst_ctbl no-error.

enable all with frame f_dlg_04_conjto_prefer_demonst_505.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'ENABLE',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */


&IF DEFINED(BF_ADM_FIN_PROJ) &THEN 
&ELSE
    assign rt_008:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
           v_cod_proj_financ_inic:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
           v_cod_proj_financ_fim:visible in frame f_dlg_04_conjto_prefer_demonst_505  = no
           v_cod_proj_financ_prefer_pfixa:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
           v_cod_proj_financ_prefer_excec:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
           bt_zoo5:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
           bt_zoo6:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no.

&ENDIF
disable bt_zoo3
        bt_zoo4
        v_cod_ccusto_inic
        v_cod_ccusto_fim
        v_cod_ccusto_prefer_pfixa
        v_cod_ccusto_prefer_excec
        with frame f_dlg_04_conjto_prefer_demonst_505.

disable conjto_prefer_demonst.num_conjto_param_ctbl
        with frame f_dlg_04_conjto_prefer_demonst_505.

run pi_init_fnc_conjto_prefer_demonst_505 /*pi_init_fnc_conjto_prefer_demonst_505*/.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'DISPLAY',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */


main_block:
repeat on endkey undo main_block, leave main_block while v_log_repeat = yes:
    &IF DEFINED(BF_ADM_FIN_PROJ) &THEN 
    &ELSE
        assign rt_008:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
               v_cod_proj_financ_inic:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
               v_cod_proj_financ_fim:visible in frame f_dlg_04_conjto_prefer_demonst_505  = no
               v_cod_proj_financ_prefer_pfixa:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
               v_cod_proj_financ_prefer_excec:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
               bt_zoo5:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
               bt_zoo6:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no.

    &ENDIF

    assign v_log_save = no
           v_rec_conjto_prefer_demonst = recid(conjto_prefer_demonst).
    if  valid-handle(v_wgh_focus)
    then do:
        wait-for go of frame f_dlg_04_conjto_prefer_demonst_505 focus v_wgh_focus.
        run pi_vld_conjto_prefer_demonst_505 /*pi_vld_conjto_prefer_demonst_505*/.
    end.
    else do:
        wait-for go of frame f_dlg_04_conjto_prefer_demonst_505 focus bt_ok.

        if v_log_next = no and
           v_log_prev = no then
            run pi_vld_conjto_prefer_demonst_505 /*pi_vld_conjto_prefer_demonst_505*/.                
    end.   

    /* Begin_Include: i_executa_pi_epc_fin */
    run pi_exec_program_epc_FIN (Input 'VALIDATE',
                                 Input 'yes',
                                 output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
    if v_log_return_epc then /* epc retornou erro*/
        undo, retry.
    /* End_Include: i_executa_pi_epc_fin */


    assign v_log_next = no
           v_log_prev = no.

end /* repeat main_block */.

hide frame f_dlg_04_conjto_prefer_demonst_505.


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
** Procedure Interna.....: pi_formatar_pfixa
** Descricao.............: pi_formatar_pfixa
** Criado por............: vanei
** Criado em.............: 21/12/1995 08:48:21
** Alterado por..........: bre15725
** Alterado em...........: 27/01/1998 16:41:50
*****************************************************************************/
PROCEDURE pi_formatar_pfixa:

    /************************ Parameter Definition Begin ************************/

    def Input param p_wgh_focus
        as widget-handle
        format ">>>>>>9"
        no-undo.
    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_attrib                     as character       no-undo. /*local*/
    def var v_cod_format                     as character       no-undo. /*local*/
    def var v_cod_inicial                    as character       no-undo. /*local*/
    def var v_num_count                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_format   = ""
           v_cod_inicial  = "".

    conta_block:
    do v_num_count = 1 to length(p_cod_format):
        assign v_cod_attrib = substring(p_cod_format, v_num_count, 1).
        if  v_cod_attrib = 'X'
        or  v_cod_attrib = "!"
        or  v_cod_attrib = "9"
        then do:
            assign v_cod_inicial  = v_cod_inicial + "#"
                   v_cod_format   = v_cod_format  + 'X'.
        end /* if */.
        else do:
            if  v_cod_attrib = "-"
            or  v_cod_attrib = "."
            then do:
                assign v_cod_format = v_cod_format + v_cod_attrib.
            end /* if */.
        end /* else */.
    end /* do conta_block */.

    if  valid-handle(p_wgh_focus)
    then do:
        assign p_wgh_focus:format       = v_cod_format
               p_wgh_focus:screen-value = v_cod_inicial.
    end /* if */.

    return v_cod_format.
END PROCEDURE. /* pi_formatar_pfixa */
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
** Procedure Interna.....: pi_init_fnc_conjto_prefer_demonst_505
** Descricao.............: pi_init_fnc_conjto_prefer_demonst_505
** Criado por............: src388
** Criado em.............: 28/05/2001 10:55:33
** Alterado por..........: fut43112
** Alterado em...........: 05/01/2009 11:45:41
*****************************************************************************/
PROCEDURE pi_init_fnc_conjto_prefer_demonst_505:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_compos_demonst_ctbl
        for compos_demonst_ctbl.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_habilita                   as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find conjto_prefer_demonst 
       where recid(conjto_prefer_demonst) = v_rec_conjto_prefer_demonst exclusive-lock no-error.
    if  avail conjto_prefer_demonst
    then do:
        /* --- Busca valores referentes a projeto e ccusto ---*/
        &if '{&emsfin_version}' = '5.05' &then
            find tab_livre_emsfin exclusive-lock
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                  and tab_livre_emsfin.cod_tab_dic_dtsul    = conjto_prefer_demonst.cod_usuario + chr(10) + conjto_prefer_demonst.cod_padr_col_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_1_idx_tab = conjto_prefer_demonst.cod_demonst_ctbl
                  and tab_livre_emsfin.cod_compon_2_idx_tab = string(conjto_prefer_demonst.num_conjto_param_ctbl) no-error.
            if  avail tab_livre_emsfin
            then do:
                assign v_cod_proj_financ_inic         = entry(1,tab_livre_emsfin.cod_livre_1,chr(10))
                       v_cod_proj_financ_fim          = entry(2,tab_livre_emsfin.cod_livre_1,chr(10))
                       v_cod_proj_financ_prefer_pfixa = entry(3,tab_livre_emsfin.cod_livre_1,chr(10))
                       v_cod_proj_financ_prefer_excec = entry(4,tab_livre_emsfin.cod_livre_1,chr(10))
                       v_cod_ccusto_inic              = entry(1,tab_livre_emsfin.cod_livre_2,chr(10))
                       v_cod_ccusto_fim               = entry(2,tab_livre_emsfin.cod_livre_2,chr(10))
                       v_cod_ccusto_prefer_pfixa      = entry(3,tab_livre_emsfin.cod_livre_2,chr(10))
                       v_cod_ccusto_prefer_excec      = entry(4,tab_livre_emsfin.cod_livre_2,chr(10)) no-error.
             end.
        &endif

        assign v_cod_unid_organ_orig_ini = conjto_prefer_demonst.cod_unid_organ_inic
               v_cod_unid_organ_orig_fim = conjto_prefer_demonst.cod_unid_organ_fim
               v_cod_estab_ini           = conjto_prefer_demonst.cod_estab_inic
               v_cod_estab_fim           = conjto_prefer_demonst.cod_estab_fim
               v_cod_unid_negoc_ini      = conjto_prefer_demonst.cod_unid_negoc_inic
               v_cod_unid_negoc_fim      = conjto_prefer_demonst.cod_unid_negoc_fim
               v_val_cotac_1             = conjto_prefer_demonst.val_cotac_indic_econ
               v_cod_cta_ctbl_ini        = conjto_prefer_demonst.cod_cta_ctbl_inic
               v_cod_cta_ctbl_fim        = conjto_prefer_demonst.cod_cta_ctbl_fim
               v_cod_cta_prefer_pfixa    = conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa
               v_cod_cta_prefer_excec    = conjto_prefer_demonst.cod_cta_ctbl_prefer_excec
               v_cod_unid_organ_ini      = conjto_prefer_demonst.cod_unid_organ_prefer_inic
               v_cod_unid_organ_fim      = conjto_prefer_demonst.cod_unid_organ_prefer_fim

               v_cod_cenar_orctario      = conjto_prefer_demonst.cod_cenar_orctario
               v_cod_vers_orcto_ctbl     = conjto_prefer_demonst.cod_vers_orcto_ctbl

               &if '{&emsfin_version}' > '5.05' &then
               v_cod_unid_orctaria       = conjto_prefer_demonst.cod_unid_orctaria
               v_num_seq_orcto_ctbl      = conjto_prefer_demonst.num_seq_orcto_ctbl
               v_cod_proj_financ_inic    = conjto_prefer_demonst.cod_proj_financ_inicial
               v_cod_proj_financ_fim     = conjto_prefer_demonst.cod_proj_financ_fim
               v_cod_proj_financ_prefer_pfixa = conjto_prefer_demonst.cod_proj_financ_pfixa
               v_cod_proj_financ_prefer_excec = conjto_prefer_demonst.cod_proj_financ_excec
               v_cod_ccusto_inic         = conjto_prefer_demonst.cod_ccusto_inic
               v_cod_ccusto_fim          = conjto_prefer_demonst.cod_ccusto_fim
               v_cod_ccusto_prefer_pfixa = conjto_prefer_demonst.cod_ccusto_pfixa
               v_cod_ccusto_prefer_excec = conjto_prefer_demonst.cod_ccusto_excec.
               &else
               v_cod_unid_orctaria       = entry(1,conjto_prefer_demonst.cod_livre_1,chr(10))
               v_num_seq_orcto_ctbl      = integer(entry(2,conjto_prefer_demonst.cod_livre_1,chr(10))) no-error.
               &endif

        find demonst_ctbl no-lock
           where recid(demonst_ctbl) = v_rec_demonst_ctbl no-error.
        find plano_cta_ctbl of demonst_ctbl no-lock no-error.
        if  avail plano_cta_ctbl
        then do:
            assign v_cod_cta_ctbl_ini:format in frame f_dlg_04_conjto_prefer_demonst_505 = plano_cta_ctbl.cod_format_cta_ctbl
                   v_cod_cta_ctbl_fim:format in frame f_dlg_04_conjto_prefer_demonst_505 = plano_cta_ctbl.cod_format_cta_ctbl
                   v_rec_plano_cta_ctbl = recid(plano_cta_ctbl).
            run pi_formatar_pfixa (Input v_cod_cta_prefer_pfixa:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                   Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_formatar_pfixa*/.
            run pi_formatar_pfixa (Input v_cod_cta_prefer_excec:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                   Input plano_cta_ctbl.cod_format_cta_ctbl) /*pi_formatar_pfixa*/.

            /* --- Formato CCusto ---*/
            find first compos_demonst_ctbl no-lock
                where  compos_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl
                  and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl
            then do:
                find first plano_ccusto no-lock
                    where plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                if  avail plano_ccusto
                then do:
                  find first b_compos_demonst_ctbl no-lock
                  where b_compos_demonst_ctbl.cod_demonst_ctbl = demonst_ctbl.cod_demonst_ctbl
                  and b_compos_demonst_ctbl.cod_plano_ccusto <> ""
                  and b_compos_demonst_ctbl.cod_plano_ccusto <> plano_ccusto.cod_plano_ccusto no-error.
               if ((avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_inic,".",""),"0","") = ""))or
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_inic,"-",""),"0","") = ""))or
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_inic,".",""),"A" /*l_a*/ ,"") = ""))or 
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_inic,"-",""),"A" /*l_a*/ ,"") = "")))and 
                  ((avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_fim,".",""),"9","") = "" ))or
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_fim,"-",""),"9","") = "" ))or 
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_fim,".",""),"Z" /*l_z*/ ,"") = "" ))or
                   (avail b_compos_demonst_ctbl and (replace(replace(v_cod_ccusto_fim,"-",""),"Z" /*l_z*/ ,"") = "" )))
                  then do:
                      assign v_log_habilita  = no.
                  end.
                  else do:
                     assign v_cod_ccusto_inic:format in frame f_dlg_04_conjto_prefer_demonst_505 = plano_ccusto.cod_format_ccusto
                           v_cod_ccusto_fim:format  in frame f_dlg_04_conjto_prefer_demonst_505 = plano_ccusto.cod_format_ccusto
                           v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
                           v_rec_plano_ccusto = RECID(plano_ccusto)
                           v_log_habilita = yes.
                    run pi_formatar_pfixa (Input v_cod_ccusto_prefer_pfixa:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                           Input plano_ccusto.cod_format_ccusto) /*pi_formatar_pfixa*/.
                    run pi_formatar_pfixa (Input v_cod_ccusto_prefer_excec:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                           Input plano_ccusto.cod_format_ccusto) /*pi_formatar_pfixa*/.                 
                  end.                          
                end.
            end.
            else do:
                assign v_log_habilita = no.
            end.   
        end.
        else do:
            assign v_rec_plano_cta_ctbl = ?
                   v_rec_plano_ccusto   = ?.
        end.

        /* --- Formato Projeto ---*/
        &IF DEFINED(BF_ADM_FIN_PROJ) &THEN 
            find last param_geral_ems no-lock no-error.
            if  avail param_geral_ems
            then do:
                if param_geral_ems.cod_format_proj_financ <> "" then do:
                    assign v_cod_proj_financ_inic:format in frame f_dlg_04_conjto_prefer_demonst_505 = param_geral_ems.cod_format_proj_financ
                           v_cod_proj_financ_fim:format  in frame f_dlg_04_conjto_prefer_demonst_505 = param_geral_ems.cod_format_proj_financ
                           v_cod_format_proj_financ = param_geral_ems.cod_format_proj_financ.
                    run pi_formatar_pfixa (Input v_cod_proj_financ_prefer_pfixa:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                           Input param_geral_ems.cod_format_proj_financ) /*pi_formatar_pfixa*/.
                    run pi_formatar_pfixa (Input v_cod_proj_financ_prefer_excec:handle in frame f_dlg_04_conjto_prefer_demonst_505,
                                           Input param_geral_ems.cod_format_proj_financ) /*pi_formatar_pfixa*/.
                end.
                else do:
                    assign v_cod_proj_financ_prefer_pfixa:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = '####################'
                           v_cod_proj_financ_prefer_excec:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = '####################'
                           v_cod_proj_financ_inic:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = ""
                           v_cod_proj_financ_fim:screen-value in frame f_dlg_04_conjto_prefer_demonst_505  = "ZZZZZZZZZZZZZZZZZZZZ" /*l_zzzzzzzzzzzzzzzzzzzz*/ .
                end.                                        
            end.
            display v_cod_proj_financ_inic
                    v_cod_proj_financ_fim
                    v_cod_proj_financ_prefer_pfixa
                    v_cod_proj_financ_prefer_excec
                    with frame f_dlg_04_conjto_prefer_demonst_505.
        &ENDIF

        display conjto_prefer_demonst.num_conjto_param_ctbl
                conjto_prefer_demonst.cod_cenar_ctbl
                conjto_prefer_demonst.cod_cenar_orctario
                conjto_prefer_demonst.cod_finalid_econ
                conjto_prefer_demonst.cod_finalid_econ_apres
                conjto_prefer_demonst.cod_vers_orcto_ctbl
                conjto_prefer_demonst.dat_cotac_indic_econ
                v_cod_estab_ini
                v_cod_estab_fim
                v_cod_unid_negoc_ini
                v_cod_unid_negoc_fim
                v_cod_cta_ctbl_ini
                v_cod_cta_ctbl_fim
                v_cod_cta_prefer_pfixa
                v_cod_cta_prefer_excec
                v_val_cotac_1
                v_cod_unid_orctaria
                v_num_seq_orcto_ctbl
                with frame f_dlg_04_conjto_prefer_demonst_505.
        if  conjto_prefer_demonst.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ_apres
        then do:
            disable conjto_prefer_demonst.dat_cotac_indic_econ
                    v_val_cotac_1
                    with frame f_dlg_04_conjto_prefer_demonst_505.
        end.
        enable bt_zoo5
               bt_zoo6
               with frame f_dlg_04_conjto_prefer_demonst_505.
        if  v_log_habilita = yes
        then do:
            display v_cod_ccusto_inic
                    v_cod_ccusto_fim
                    v_cod_ccusto_prefer_pfixa
                    v_cod_ccusto_prefer_excec
                    with frame f_dlg_04_conjto_prefer_demonst_505.
            enable bt_zoo3
                   bt_zoo4
                   v_cod_ccusto_inic
                   v_cod_ccusto_fim
                   v_cod_ccusto_prefer_pfixa
                   v_cod_ccusto_prefer_excec
                   with frame f_dlg_04_conjto_prefer_demonst_505.
        end.
        else do:
            disable bt_zoo3
                    bt_zoo4
                    v_cod_ccusto_inic
                    v_cod_ccusto_fim
                    v_cod_ccusto_prefer_pfixa
                    v_cod_ccusto_prefer_excec
                    with frame f_dlg_04_conjto_prefer_demonst_505.
        end.

        /* --- Consolidaá∆o ---*/
        find first col_demonst_ctbl no-lock
           where col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
             and col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
             and col_demonst_ctbl.ind_orig_val_col_demonst  = "Consolidaá∆o" /*l_consolidacao*/  no-error.
        if  avail col_demonst_ctbl
        then do:
            assign v_cod_unid_organ_orig_ini:visible in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   v_cod_unid_organ_orig_fim:visible in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   v_cod_unid_organ_ini:visible      in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   v_cod_unid_organ_fim:visible      in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   bt_zoo_325247:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   bt_zoo_325246:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   bt_zoo_325253:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   bt_zoo_325252:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = no.
            display v_cod_unid_organ_orig_ini
                    v_cod_unid_organ_orig_fim
                    with frame f_dlg_04_conjto_prefer_demonst_505.
            enable v_cod_unid_organ_orig_ini
                   bt_zoo_325247
                   v_cod_unid_organ_orig_fim
                   bt_zoo_325246
                   with frame f_dlg_04_conjto_prefer_demonst_505.
        end.
        else do:
            assign v_cod_unid_organ_orig_ini:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   v_cod_unid_organ_orig_fim:visible in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   v_cod_unid_organ_ini:visible      in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   v_cod_unid_organ_fim:visible      in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   bt_zoo_325247:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   bt_zoo_325246:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = no
                   bt_zoo_325253:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = yes
                   bt_zoo_325252:visible             in frame f_dlg_04_conjto_prefer_demonst_505 = yes.
            display v_cod_unid_organ_ini
                    v_cod_unid_organ_fim
                    with frame f_dlg_04_conjto_prefer_demonst_505.
            enable v_cod_unid_organ_ini
                   bt_zoo_325253
                   v_cod_unid_organ_fim
                   bt_zoo_325252
                   with frame f_dlg_04_conjto_prefer_demonst_505.
        end.
        /* --- Cont†bil ou Oráamento ---*/
        find first col_demonst_ctbl no-lock
           where col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
             and col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
             and (col_demonst_ctbl.ind_orig_val_col_demonst = "Cont†bil" /*l_contabil*/ 
              or  col_demonst_ctbl.ind_orig_val_col_demonst = "Oráamento" /*l_orcamento*/ ) no-error.
        if  avail col_demonst_ctbl
        then do:
            enable v_cod_unid_organ_ini
                   bt_zoo_325253
                   v_cod_unid_organ_fim
                   bt_zoo_325252
                   with frame f_dlg_04_conjto_prefer_demonst_505.
            enable v_cod_estab_ini
                   bt_zoo_325238
                   v_cod_estab_fim
                   bt_zoo_325237
                   with frame f_dlg_04_conjto_prefer_demonst_505.
        end.

        /* --- Oráamento ---*/
        find first col_demonst_ctbl no-lock
           where col_demonst_ctbl.cod_padr_col_demonst_ctbl = conjto_prefer_demonst.cod_padr_col_demonst_ctbl
             and col_demonst_ctbl.num_conjto_param_ctbl     = conjto_prefer_demonst.num_conjto_param_ctbl
             and  col_demonst_ctbl.ind_orig_val_col_demonst  = "Oráamento" /*l_orcamento*/  no-error.
        if  avail col_demonst_ctbl
        then do:
            assign v_log_habilita_orcto = yes.
            enable conjto_prefer_demonst.cod_cenar_orctario
                   bt_zoo_325211
                   v_cod_unid_orctaria
                   bt_zoo7
                   v_num_seq_orcto_ctbl
                   conjto_prefer_demonst.cod_vers_orcto_ctbl
                   bt_zoo_325214
                   with frame f_dlg_04_conjto_prefer_demonst_505.
        end.
        else do:
            assign v_log_habilita_orcto = no.
            disable conjto_prefer_demonst.cod_cenar_orctario
                    bt_zoo_325211
                    v_cod_unid_orctaria
                    bt_zoo7
                    v_num_seq_orcto_ctbl
                    conjto_prefer_demonst.cod_vers_orcto_ctbl
                    bt_zoo_325214
                    with frame f_dlg_04_conjto_prefer_demonst_505.
        end.

        assign conjto_prefer_demonst.cod_unid_organ_inic        = v_cod_unid_organ_orig_ini
               conjto_prefer_demonst.cod_unid_organ_fim         = v_cod_unid_organ_orig_fim
               conjto_prefer_demonst.cod_estab_inic             = v_cod_estab_ini
               conjto_prefer_demonst.cod_estab_fim              = v_cod_estab_fim
               conjto_prefer_demonst.cod_unid_negoc_inic        = v_cod_unid_negoc_ini
               conjto_prefer_demonst.cod_unid_negoc_fim         = v_cod_unid_negoc_fim
               conjto_prefer_demonst.val_cotac_indic_econ       = v_val_cotac_1
               conjto_prefer_demonst.cod_cta_ctbl_inic          = v_cod_cta_ctbl_ini
               conjto_prefer_demonst.cod_cta_ctbl_fim           = v_cod_cta_ctbl_fim
               conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa  = v_cod_cta_prefer_pfixa
               conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa  = v_cod_cta_prefer_excec
               conjto_prefer_demonst.cod_unid_organ_prefer_inic = v_cod_unid_organ_ini
               conjto_prefer_demonst.cod_unid_organ_prefer_fim  = v_cod_unid_organ_fim

               conjto_prefer_demonst.cod_cenar_orctario  = conjto_prefer_demonst.cod_cenar_orctario:screen-value in frame f_dlg_04_conjto_prefer_demonst_505
               conjto_prefer_demonst.cod_vers_orcto_ctbl = conjto_prefer_demonst.cod_vers_orcto_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505

               &if '{&emsfin_version}' > '5.05' &then
               conjto_prefer_demonst.cod_unid_orctaria           = v_cod_unid_orctaria
               conjto_prefer_demonst.num_seq_orcto_ctbl          = v_num_seq_orcto_ctbl
               conjto_prefer_demonst.cod_proj_financ_inicial     = v_cod_proj_financ_inic
               conjto_prefer_demonst.cod_proj_financ_fim         = v_cod_proj_financ_fim
               conjto_prefer_demonst.cod_proj_financ_pfixa       = v_cod_proj_financ_prefer_pfixa
               conjto_prefer_demonst.cod_proj_financ_excec       = v_cod_proj_financ_prefer_excec
               conjto_prefer_demonst.cod_ccusto_inic             = v_cod_ccusto_inic
               conjto_prefer_demonst.cod_ccusto_fim              = v_cod_ccusto_fim
               conjto_prefer_demonst.cod_ccusto_pfixa            = v_cod_ccusto_prefer_pfixa
               conjto_prefer_demonst.cod_ccusto_excec            = v_cod_ccusto_prefer_excec
               &else
               conjto_prefer_demonst.cod_livre_1                 = v_cod_unid_orctaria          + chr(10) +
                                                                   string(v_num_seq_orcto_ctbl) + chr(10) +
                                                                   "" /*l_null*/                    + chr(10) +
                                                                   "" /*l_null*/ 
               &endif
               .
        &if '{&emsfin_version}' <= '5.05' &then
            if  avail tab_livre_emsfin
            then do:
                assign tab_livre_emsfin.cod_livre_1 = v_cod_proj_financ_inic         + chr(10) +
                                                      v_cod_proj_financ_fim          + chr(10) +
                                                      v_cod_proj_financ_prefer_pfixa + chr(10) +
                                                      v_cod_proj_financ_prefer_excec
                       tab_livre_emsfin.cod_livre_2 = v_cod_ccusto_inic              + chr(10) +
                                                      v_cod_ccusto_fim               + chr(10) +
                                                      v_cod_ccusto_prefer_pfixa      + chr(10) +
                                                      v_cod_ccusto_prefer_excec.
            end.
        &endif

        /* Begin_Include: i_executa_pi_epc_fin */
        run pi_exec_program_epc_FIN (Input 'ASSIGN',
                                     Input 'yes',
                                     output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
        if v_log_return_epc then /* epc retornou erro*/
            undo, retry.
        /* End_Include: i_executa_pi_epc_fin */

    end.
END PROCEDURE. /* pi_init_fnc_conjto_prefer_demonst_505 */
/*****************************************************************************
** Procedure Interna.....: pi_vld_conjto_prefer_demonst_505
** Descricao.............: pi_vld_conjto_prefer_demonst_505
** Criado por............: src388
** Criado em.............: 28/05/2001 13:33:59
** Alterado por..........: fut41422_3
** Alterado em...........: 04/09/2012 15:06:41
*****************************************************************************/
PROCEDURE pi_vld_conjto_prefer_demonst_505:

    /************************* Variable Definition Begin ************************/

    def var v_log_grp_usuar                  as logical         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* Validaá∆o das faixas - UO*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Unidade Organizacional" /*l_unid_organ*/ ,"Unidade Organizacional" /*l_unid_organ*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_unid_organ_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.

    /* Validaá∆o das faixas - Estabelecimento*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Estabelecimento" /*l_estabelecimento*/ ,"Estabelecimento" /*l_estabelecimento*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_estab_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.

    /* Validaá∆o das faixas - UN*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Unidade de Neg¢cio" /*l_unidade_de_negocio*/ ,"Unidade de Neg¢cio" /*l_unidade_de_negocio*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_unid_negoc_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.

    /* Validaá∆o das faixas - Conta Cont†bil*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Conta Cont†bil" /*l_conta_contabil*/ ,"Conta Cont†bil" /*l_conta_contabil*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_cta_ctbl_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.

    /* Validaá∆o das faixas - CCusto*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_inic
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Centro de Custo" /*l_centro_de_custo*/ ,"Centro de Custo" /*l_centro_de_custo*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_ccusto_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.

    &IF DEFINED(BF_ADM_FIN_PROJ) &THEN
    /* Validaá∆o das faixas - Projeto*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_inic
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Projeto Financeiro" /*l_proj_financ*/ ,"Projeto Financeiro" /*l_proj_financ*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_proj_financ_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end.
    &ENDIF

    /* --- Cenar Ctbl ---*/
    if  conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 <> ""
    then do:
         find cenar_ctbl no-lock
              where cenar_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505
                    conjto_prefer_demonst.cod_cenar_ctbl no-error.
         if  not avail cenar_ctbl
         then do:
             /* Cen†rio Contabil &1 informado n∆o encontrado ! */
             run pi_messages (input "show",
                              input 379,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_379*/.
             assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.
             return error.
         end /* if */.
    end /* if */.
    /* --- Finalidades Econìmicas ---*/
    find finalid_econ no-lock
          where finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ no-error.
    if  not avail finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end /* if */.
    find b_finalid_econ no-lock
         where b_finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ_apres no-error.
    if  not avail b_finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ_apres:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return error.
    end /* if */.
    /* --- Cenar e Vers∆o Oráamentos ---*/
    if  v_log_habilita_orcto = yes
    then do:
        find first cenar_orctario_bgc no-lock
             where cenar_orctario_bgc.cod_cenar_orctario = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_orctario no-error.
        if  not avail cenar_orctario_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Cen†rio Oráament†rio", "Cen†rios Oráament†rios")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_orctario:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return error.
        end /* if */.
        find first unid_orctaria no-lock
             where unid_orctaria.cod_unid_orctaria = input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_orctaria no-error.
        if  not avail unid_orctaria
        then do:
            /* Unidade Oráament†ria &1 Inexistente ! */
            run pi_messages (input "show",
                             input 10876,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10876*/.
            assign v_wgh_focus = v_cod_unid_orctaria:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return error.
        end /* if */.
        find first vers_orcto_ctbl_bgc no-lock
             where vers_orcto_ctbl_bgc.cod_cenar_orctario  = cenar_orctario_bgc.cod_cenar_orctario
               and vers_orcto_ctbl_bgc.cod_unid_orctaria   = unid_orctaria.cod_unid_orctaria
               and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = input frame f_dlg_04_conjto_prefer_demonst_505 v_num_seq_orcto_ctbl
               and vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_vers_orcto_ctbl no-error.
        if  not avail vers_orcto_ctbl_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Vers∆o Oráamento Cont†bil", "Oráamentos Cont†beis")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_vers_orcto_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return error.
        end /* if */.

        assign v_log_grp_usuar = no.
        do v_num_cont = 1 to num-entries(v_cod_grp_usuar_lst):
            find first segur_vers_orcto_bgc no-lock
                where segur_vers_orcto_bgc.cod_cenar_orctario = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_orctario
                  and segur_vers_orcto_bgc.cod_unid_orctaria = input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_orctaria
                  and segur_vers_orcto_bgc.num_seq_orcto_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505 v_num_seq_orcto_ctbl
                  and segur_vers_orcto_bgc.cod_vers_orcto_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_vers_orcto_ctbl
                  and (segur_vers_orcto_bgc.cod_grp_usuar = entry(v_num_cont,v_cod_grp_usuar_lst) or segur_vers_orcto_bgc.cod_grp_usuar = '*') no-error.
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
                                                'Usu†rio sem permiss∆o para esta vers∆o de oráamento',                           'Verifique na manutená∆o de oráamentos, seguranáa de oráamento se o grupo do usu†rio est† com permiss∆o de acesso para esta vers∆o do oráamento')) /*msg_524*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_vers_orcto_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return error.
        end.
    end /* if */.

    assign conjto_prefer_demonst.cod_finalid_econ
           conjto_prefer_demonst.cod_finalid_econ_apres.
    if  conjto_prefer_demonst.cod_finalid_econ = conjto_prefer_demonst.cod_finalid_econ_apres
    then do:
        assign v_val_cotac_1:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 = "1".
    end /* if */.
    &IF DEFINED(BF_ADM_FIN_PROJ) &THEN 
        if not v_log_alterado
           and (v_cod_proj_financ_prefer_pfixa    <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_prefer_pfixa
                or v_cod_proj_financ_prefer_excec <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_prefer_excec
                or v_cod_proj_financ_inic         <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_inic
                or v_cod_proj_financ_fim          <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_fim) then
            assign v_log_alterado = yes.
        ASSIGN input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_prefer_pfixa
               input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_prefer_excec
               input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_inic
               input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_fim.
    &ENDIF
    if not v_log_alterado
       and (v_cod_unid_organ_orig_ini <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_orig_ini
       or v_cod_unid_organ_orig_fim <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_orig_fim
       or v_cod_unid_organ_ini      <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_ini
       or v_cod_unid_organ_fim      <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_fim
       or v_cod_estab_ini           <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_ini
       or v_cod_estab_fim           <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_fim
       or v_cod_unid_negoc_ini      <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_ini
       or v_cod_unid_negoc_fim      <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_fim
       or v_cod_cta_ctbl_ini        <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_ini
       or v_cod_cta_ctbl_fim        <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_fim
       or v_cod_cta_prefer_pfixa    <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_prefer_pfixa
       or v_cod_cta_prefer_excec    <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_prefer_excec
       or v_val_cotac_1             <> input frame f_dlg_04_conjto_prefer_demonst_505 v_val_cotac_1
       or (v_cod_ccusto_inic:sensitive in frame f_dlg_04_conjto_prefer_demonst_505
           and v_cod_ccusto_inic         <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_inic)
       or (v_cod_ccusto_fim:sensitive in frame f_dlg_04_conjto_prefer_demonst_505 
           and v_cod_ccusto_fim          <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_fim)
       or (v_cod_ccusto_prefer_pfixa:sensitive in frame f_dlg_04_conjto_prefer_demonst_505
           and v_cod_ccusto_prefer_pfixa <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_prefer_pfixa)
       or (v_cod_ccusto_prefer_excec:sensitive in frame f_dlg_04_conjto_prefer_demonst_505
           and v_cod_ccusto_prefer_excec <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_prefer_excec)
       or v_cod_unid_orctaria       <> input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_orctaria
       or v_num_seq_orcto_ctbl      <> input frame f_dlg_04_conjto_prefer_demonst_505 v_num_seq_orcto_ctbl 
       or conjto_prefer_demonst.cod_cenar_orctario  <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_orctario
       or conjto_prefer_demonst.cod_vers_orcto_ctbl <> input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_vers_orcto_ctbl) then
        assign v_log_alterado = yes.

    assign v_wgh_focus = ?
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_orig_ini
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_orig_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_ini
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_ini
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_ini
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_ini
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_prefer_pfixa
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_prefer_excec
           input frame f_dlg_04_conjto_prefer_demonst_505 v_val_cotac_1
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_inic
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_fim
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_prefer_pfixa
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_prefer_excec
           input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_orctaria
           input frame f_dlg_04_conjto_prefer_demonst_505 v_num_seq_orcto_ctbl

           input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_orctario
           input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_vers_orcto_ctbl

           conjto_prefer_demonst.cod_cenar_ctbl
           conjto_prefer_demonst.dat_cotac_indic_econ
           conjto_prefer_demonst.cod_cenar_orctario
           conjto_prefer_demonst.cod_vers_orcto_ctbl
           conjto_prefer_demonst.cod_unid_organ_inic         = v_cod_unid_organ_orig_ini
           conjto_prefer_demonst.cod_unid_organ_fim          = v_cod_unid_organ_orig_fim
           conjto_prefer_demonst.cod_estab_inic              = v_cod_estab_ini
           conjto_prefer_demonst.cod_estab_fim               = v_cod_estab_fim
           conjto_prefer_demonst.cod_unid_negoc_inic         = v_cod_unid_negoc_ini
           conjto_prefer_demonst.cod_unid_negoc_fim          = v_cod_unid_negoc_fim
           conjto_prefer_demonst.val_cotac_indic_econ        = v_val_cotac_1
           conjto_prefer_demonst.cod_cta_ctbl_inic           = v_cod_cta_ctbl_ini
           conjto_prefer_demonst.cod_cta_ctbl_fim            = v_cod_cta_ctbl_fim
           conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa   = v_cod_cta_prefer_pfixa
           conjto_prefer_demonst.cod_cta_ctbl_prefer_excec   = v_cod_cta_prefer_excec
           conjto_prefer_demonst.cod_unid_organ_prefer_inic  = v_cod_unid_organ_ini
           conjto_prefer_demonst.cod_unid_organ_prefer_fim   = v_cod_unid_organ_fim
           &if '{&emsfin_version}' > '5.05' &then
           conjto_prefer_demonst.cod_unid_orctaria           = v_cod_unid_orctaria
           conjto_prefer_demonst.num_seq_orcto_ctbl          = v_num_seq_orcto_ctbl
           conjto_prefer_demonst.cod_proj_financ_inicial     = v_cod_proj_financ_inic
           conjto_prefer_demonst.cod_proj_financ_fim         = v_cod_proj_financ_fim
           conjto_prefer_demonst.cod_proj_financ_pfixa       = v_cod_proj_financ_prefer_pfixa
           conjto_prefer_demonst.cod_proj_financ_excec       = v_cod_proj_financ_prefer_excec
           conjto_prefer_demonst.cod_ccusto_inic             = v_cod_ccusto_inic
           conjto_prefer_demonst.cod_ccusto_fim              = v_cod_ccusto_fim
           conjto_prefer_demonst.cod_ccusto_pfixa            = v_cod_ccusto_prefer_pfixa
           conjto_prefer_demonst.cod_ccusto_excec            = v_cod_ccusto_prefer_excec
           &else
           conjto_prefer_demonst.cod_livre_1                 = v_cod_unid_orctaria          + chr(10) +
                                                               string(v_num_seq_orcto_ctbl) + chr(10) +
                                                               "" /*l_null*/                    + chr(10) +
                                                               "" /*l_null*/ 
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
        end /* if */.
        assign tab_livre_emsfin.cod_livre_1 = v_cod_proj_financ_inic         + chr(10) +
                                              v_cod_proj_financ_fim          + chr(10) +
                                              v_cod_proj_financ_prefer_pfixa + chr(10) +
                                              v_cod_proj_financ_prefer_excec
               tab_livre_emsfin.cod_livre_2 = v_cod_ccusto_inic              + chr(10) +
                                              v_cod_ccusto_fim               + chr(10) +
                                              v_cod_ccusto_prefer_pfixa      + chr(10) +
                                              v_cod_ccusto_prefer_excec      + chr(10) +
                                              v_cod_plano_ccusto.
    &endif
END PROCEDURE. /* pi_vld_conjto_prefer_demonst_505 */
/*****************************************************************************
** Procedure Interna.....: pi_valida_salva
** Descricao.............: pi_valida_salva
** Criado por............: fut1082
** Criado em.............: 21/06/2004 17:11:15
** Alterado por..........: fut1082
** Alterado em...........: 21/06/2004 17:22:19
*****************************************************************************/
PROCEDURE pi_valida_salva:

    /* Validaá∆o das faixas - UO*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_organ_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Unidade Organizacional" /*l_unid_organ*/ ,"Unidade Organizacional" /*l_unid_organ*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_unid_organ_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.

    /* Validaá∆o das faixas - Estabelecimento*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_estab_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Estabelecimento" /*l_estabelecimento*/ ,"Estabelecimento" /*l_estabelecimento*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_estab_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.

    /* Validaá∆o das faixas - UN*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_negoc_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Unidade de Neg¢cio" /*l_unidade_de_negocio*/ ,"Unidade de Neg¢cio" /*l_unidade_de_negocio*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_unid_negoc_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.

    /* Validaá∆o das faixas - Conta Cont†bil*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_cta_ctbl_ini
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Conta Cont†bil" /*l_conta_contabil*/ ,"Conta Cont†bil" /*l_conta_contabil*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_cta_ctbl_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.

    /* Validaá∆o das faixas - CCusto*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_ccusto_inic
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Centro de Custo" /*l_centro_de_custo*/ ,"Centro de Custo" /*l_centro_de_custo*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_ccusto_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.

    &IF DEFINED(BF_ADM_FIN_PROJ) &THEN
    /* Validaá∆o das faixas - Projeto*/
    if  input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_fim < input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_proj_financ_inic
    then do:
        /* &1 Inicial maior que &1 Final ! */
        run pi_messages (input "show",
                         input 6096,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "Projeto Financeiro" /*l_proj_financ*/ ,"Projeto Financeiro" /*l_proj_financ*/)) /*msg_6096*/.
        assign v_wgh_focus = v_cod_proj_financ_fim:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end.
    &ENDIF

    /* --- Cenar Ctbl ---*/
    if  conjto_prefer_demonst.cod_cenar_ctbl:screen-value in frame f_dlg_04_conjto_prefer_demonst_505 <> ""
    then do:
         find cenar_ctbl no-lock
              where cenar_ctbl.cod_cenar_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505
                    conjto_prefer_demonst.cod_cenar_ctbl no-error.
         if  not avail cenar_ctbl
         then do:
             /* Cen†rio Contabil &1 informado n∆o encontrado ! */
             run pi_messages (input "show",
                              input 379,
                              input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_379*/.
             assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.
             return 'NOK'.
         end /* if */.
    end /* if */.
    /* --- Finalidades Econìmicas ---*/
    find finalid_econ no-lock
          where finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ no-error.
    if  not avail finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end /* if */.
    find b_finalid_econ no-lock
         where b_finalid_econ.cod_finalid_econ = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_finalid_econ_apres no-error.
    if  not avail b_finalid_econ
    then do:
        /* Finalidade Econìmica Inv†lida ! */
        run pi_messages (input "show",
                         input 509,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_509*/.
        assign v_wgh_focus = conjto_prefer_demonst.cod_finalid_econ_apres:handle in frame f_dlg_04_conjto_prefer_demonst_505.
        return 'NOK'.
    end /* if */.
    /* --- Cenar e Vers∆o Oráamentos ---*/
    if  v_log_habilita_orcto = yes
    then do:
        find first cenar_orctario_bgc no-lock
             where cenar_orctario_bgc.cod_cenar_orctario = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_cenar_orctario no-error.
        if  not avail cenar_orctario_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Cen†rio Oráament†rio", "Cen†rios Oráament†rios")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_cenar_orctario:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return 'NOK'.
        end /* if */.
        find first unid_orctaria no-lock
             where unid_orctaria.cod_unid_orctaria = input frame f_dlg_04_conjto_prefer_demonst_505 v_cod_unid_orctaria no-error.
        if  not avail unid_orctaria
        then do:
            /* Unidade Oráament†ria &1 Inexistente ! */
            run pi_messages (input "show",
                             input 10876,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_10876*/.
            assign v_wgh_focus = v_cod_unid_orctaria:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return 'NOK'.
        end /* if */.
        find first vers_orcto_ctbl_bgc no-lock
             where vers_orcto_ctbl_bgc.cod_cenar_orctario  = cenar_orctario_bgc.cod_cenar_orctario
               and vers_orcto_ctbl_bgc.cod_unid_orctaria   = unid_orctaria.cod_unid_orctaria
               and vers_orcto_ctbl_bgc.num_seq_orcto_ctbl  = input frame f_dlg_04_conjto_prefer_demonst_505 v_num_seq_orcto_ctbl
               and vers_orcto_ctbl_bgc.cod_vers_orcto_ctbl = input frame f_dlg_04_conjto_prefer_demonst_505 conjto_prefer_demonst.cod_vers_orcto_ctbl no-error.
        if  not avail vers_orcto_ctbl_bgc
        then do:
            /* &1 inexistente ! */
            run pi_messages (input "show",
                             input 1284,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                "Vers∆o Oráamento Cont†bil", "Oráamentos Cont†beis")) /*msg_1284*/.
            assign v_wgh_focus = conjto_prefer_demonst.cod_vers_orcto_ctbl:handle in frame f_dlg_04_conjto_prefer_demonst_505.
            return 'NOK'.
        end /* if */.
    end /* if */.

    return 'OK'.

END PROCEDURE. /* pi_valida_salva */
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
    /* ix_iz1_fnc_conjto_prefer_demonst_505 */


    /* Begin_Include: i_exec_program_epc_pi_fin */
    if  v_nom_prog_upc <> ''    
    or  v_nom_prog_appc <> ''
    or  v_nom_prog_dpc <> '' then do:
        &if 'conjto_prefer_demonst' <> '' &then
            assign v_rec_table_epc = recid(conjto_prefer_demonst)
                   v_nom_table_epc = 'conjto_prefer_demonst'.
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


    /* ix_iz2_fnc_conjto_prefer_demonst_505 */
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
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*******************  End of fnc_conjto_prefer_demonst_505 ******************/
