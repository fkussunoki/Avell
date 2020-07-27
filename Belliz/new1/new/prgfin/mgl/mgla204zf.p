/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_compos_demonst_subst_505
** Descricao.............: Substituiá‰es das Composiá‰es do Demonst
** Versao................:  1.00.00.008
** Procedimento..........: con_demonst_ctbl_video
** Nome Externo..........: prgfin/mgl/MGLA204zf.p
** Data Geracao..........: 20/01/2011 - 11:47:42
** Criado por............: dalpra
** Criado em.............: 23/08/2001 09:00:39
** Alterado por..........: log352036
** Alterado em...........: 20/01/2011 11:47:36
** Gerado por............: log352036
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.008":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_compos_demonst_subst_505 MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/

&if "{&emsfin_version}" < "5.05" &then
run pi_messages (input "show",
                 input 5135,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "INICIAL","~~MAIOR","~~FNC_COMPOS_DEMONST_SUBST_505","~~5.05","~~EMSFIN","~~{&emsfin_version}")) /*msg_5135*/.
&else

/************************** Buffer Definition Begin *************************/

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
def new global shared var v_cod_ccusto_fim
    as Character
    format "x(11)":U
    initial "999999"
    label "CCusto Final"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_ini
    as Character
    format "x(11)":U
    label "CCusto Inicial"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_ccusto_pfixa_subst
    as character
    format "x(11)":U
    label "Subst Parte Fixa"
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
def new global shared var v_cod_plano_ccusto_sub
    as character
    format "x(8)":U
    label "Plano Centros Custo"
    column-label "Plano Centros Custo"
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
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
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
def new global shared var v_log_estab_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Subst Estab"
    column-label "Subst Estab"
    no-undo.
def var v_log_repeat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
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
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_plano_ccusto
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
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
def var v_log_plano_ccusto_unico         as logical         no-undo. /*local*/


/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
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
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_sav
    label "Salva"
    tooltip "Salva"
    size 1 by 1
    auto-go.
def button bt_zoo
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
def button bt_zoo2
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_327678
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_327679
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_327683
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_327684
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_327685
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_327686
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_04_compos_demonst_subst_505
    rt_001
         at row 01.50 col 02.00 bgcolor 8 
    rt_002
         at row 05.50 col 03.86
    " Centros Custo " view-as text
         at row 05.20 col 05.86 bgcolor 8 
    rt_cxcf
         at row 12.83 col 02.00 bgcolor 7 
    v_log_unid_organ_subst
         at row 02.00 col 20.00 label "  Unid Organ"
         help "Substituiá∆o da Unidade Organizacional"
         view-as toggle-box
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_unid_organ_sub
         at row 02.00 col 36.00 no-label
         help "C¢digo Unidade Organizacional"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327686
         at row 02.00 col 40.14
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_unid_organ_sub
         at row 02.00 col 36.00 no-label
         help "C¢digo Unidade Organizacional"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327686
         at row 02.00 col 42.14
&ENDIF
    v_log_estab_subst
         at row 03.00 col 20.00 label "  Estab"
         help "Substituiá∆o dos Estab nas Composiá‰es"
         view-as toggle-box
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_ini
         at row 03.00 col 36.00 no-label
         help "Codigo Estabelecimento Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_ini
         at row 03.00 col 36.00 no-label
         help "Codigo Estabelecimento Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
    bt_zoo
         at row 03.00 col 40.14 font ?
         help "Zoom"
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
    v_cod_estab_fim
         at row 03.00 col 49.00 colon-aligned label "AtÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
    v_cod_estab_fim
         at row 03.00 col 49.00 colon-aligned label "AtÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
&ENDIF
    bt_zoo2
         at row 03.00 col 55.14 font ?
         help "Zoom"
    v_log_unid_negoc_subst
         at row 04.00 col 20.00 label "  Unid Neg"
         help "Substituiá∆o das Un Neg nas Composiá‰es"
         view-as toggle-box
    v_cod_unid_negoc_ini
         at row 04.00 col 36.00 no-label
         help "Unidade de Neg¢cio Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327685
         at row 04.00 col 40.14
    v_cod_unid_negoc_fim
         at row 04.00 col 49.00 colon-aligned label "AtÇ"
         help "Unidade de Neg¢cio Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327684
         at row 04.00 col 55.14
    v_log_ccusto_subst
         at row 06.00 col 20.00 label "  Ccusto"
         help "Substituiá∆o dos Ccustos nas Composiá‰es"
         view-as toggle-box
    v_cod_plano_ccusto_sub
         at row 07.00 col 18.00 colon-aligned label "Plano CCusto"
         help "C¢digo Plano Centros Custo"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327683
         at row 07.00 col 29.14
    v_cod_ccusto_ini
         at row 08.00 col 18.00 colon-aligned label "CCusto Inicial"
         help "C¢digo Centro Custo"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327679
         at row 08.00 col 32.14
    v_cod_ccusto_fim
         at row 09.00 col 18.00 colon-aligned label "Final"
         help "C¢digo Centro Custo"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_327678
         at row 09.00 col 32.14
    v_cod_ccusto_pfixa_subst
         at row 10.00 col 18.00 colon-aligned label "Subst Pfixa"
         help "Substituiá∆o da Parte Fixa do Ccustos"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ccusto_exec_subst
         at row 11.00 col 18.00 colon-aligned label "Subst PExec"
         help "Substituiá∆o da Parte Execá∆o dos Ccusto"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 13.04 col 03.00 font ?
         help "OK"
    bt_sav
         at row 13.04 col 14.00 font ?
         help "Salva"
    bt_can
         at row 13.04 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 13.04 col 52.57 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 65.00 by 14.67 default-button bt_sav
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Substituiá‰es Composiá‰es".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars             in frame f_dlg_04_compos_demonst_subst_505 = 10.00
           bt_can:height-chars            in frame f_dlg_04_compos_demonst_subst_505 = 01.00
           bt_hel2:width-chars            in frame f_dlg_04_compos_demonst_subst_505 = 10.00
           bt_hel2:height-chars           in frame f_dlg_04_compos_demonst_subst_505 = 01.00
           bt_ok:width-chars              in frame f_dlg_04_compos_demonst_subst_505 = 10.00
           bt_ok:height-chars             in frame f_dlg_04_compos_demonst_subst_505 = 01.00
           bt_sav:width-chars             in frame f_dlg_04_compos_demonst_subst_505 = 10.00
           bt_sav:height-chars            in frame f_dlg_04_compos_demonst_subst_505 = 01.00
           bt_zoo:width-chars             in frame f_dlg_04_compos_demonst_subst_505 = 04.00
           bt_zoo:height-chars            in frame f_dlg_04_compos_demonst_subst_505 = 00.88
           bt_zoo2:width-chars            in frame f_dlg_04_compos_demonst_subst_505 = 04.00
           bt_zoo2:height-chars           in frame f_dlg_04_compos_demonst_subst_505 = 00.88
           rt_001:width-chars             in frame f_dlg_04_compos_demonst_subst_505 = 61.57
           rt_001:height-chars            in frame f_dlg_04_compos_demonst_subst_505 = 11.00
           rt_002:width-chars             in frame f_dlg_04_compos_demonst_subst_505 = 57.72
           rt_002:height-chars            in frame f_dlg_04_compos_demonst_subst_505 = 06.50
           rt_cxcf:width-chars            in frame f_dlg_04_compos_demonst_subst_505 = 61.57
           rt_cxcf:height-chars           in frame f_dlg_04_compos_demonst_subst_505 = 01.42.
    /* set private-data for the help system */
    assign v_log_unid_organ_subst:private-data   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019455":U
           bt_zoo_327686:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           bt_zoo_327686:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_unid_organ_sub:private-data     in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019458":U
           v_log_estab_subst:private-data        in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019456":U
           v_cod_estab_ini:private-data          in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000016633":U
           bt_zoo:private-data                   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_estab_fim:private-data          in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000016634":U
           bt_zoo2:private-data                  in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009432":U
           v_log_unid_negoc_subst:private-data   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019457":U
           bt_zoo_327685:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_unid_negoc_ini:private-data     in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019459":U
           bt_zoo_327684:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_unid_negoc_fim:private-data     in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019460":U
           v_log_ccusto_subst:private-data       in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019461":U
           bt_zoo_327683:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_plano_ccusto_sub:private-data   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019462":U
           bt_zoo_327679:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_ccusto_ini:private-data         in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019463":U
           bt_zoo_327678:private-data            in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000009431":U
           v_cod_ccusto_fim:private-data         in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019467":U
           v_cod_ccusto_pfixa_subst:private-data in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019469":U
           v_cod_ccusto_exec_subst:private-data  in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000019475":U
           bt_ok:private-data                    in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000010721":U
           bt_sav:private-data                   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000011048":U
           bt_can:private-data                   in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_dlg_04_compos_demonst_subst_505 = "HLP=000011326":U
           frame f_dlg_04_compos_demonst_subst_505:private-data                             = "HLP=000000000".
    /* enable function buttons */
    assign bt_zoo_327686:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327686:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327685:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327684:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327683:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327679:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes
           bt_zoo_327678:sensitive in frame f_dlg_04_compos_demonst_subst_505 = yes.
    /* move buttons to top */
    bt_zoo_327686:move-to-top().
    bt_zoo_327686:move-to-top().
    bt_zoo_327685:move-to-top().
    bt_zoo_327684:move-to-top().
    bt_zoo_327683:move-to-top().
    bt_zoo_327679:move-to-top().
    bt_zoo_327678:move-to-top().



{include/i_fclfrm.i f_dlg_04_compos_demonst_subst_505 }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_compos_demonst_subst_505
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON CHOOSE OF bt_sav IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    assign v_log_repeat = yes.
END. /* ON CHOOSE OF bt_sav IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON CHOOSE OF bt_zoo IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    /* Zoom de Atributo sem referencia para o usuario */
    if v_cod_unid_organ_sub = "" then do:
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
           assign v_cod_estab_ini:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
                  string(estabelecimento.cod_estab).
           apply "entry" to v_cod_estab_ini in frame f_dlg_04_compos_demonst_subst_505.
       end /* if */.
    end.
    else do:
       if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
           if  v_cod_dwb_user begins 'es_' then
               return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb071na.p".
           else do:
               message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb071na.p"
                      view-as alert-box error buttons ok.
               return.
           end.
       end.
       else
           run prgint/utb/utb071na.p (Input input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub) /*prg_see_estabelecimento_empresa*/.
       if  v_rec_estabelecimento <> ?
       then do:
           find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
           assign v_cod_estab_ini:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
                  string(estabelecimento.cod_estab).
           apply "entry" to v_cod_estab_ini in frame f_dlg_04_compos_demonst_subst_505.
       end /* if */.
    end.

END. /* ON CHOOSE OF bt_zoo IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    /* Zoom de Atributo sem referencia para o usuario */
    if v_cod_unid_organ_sub = "" then do:
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
           assign v_cod_estab_fim:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
                  string(estabelecimento.cod_estab).
           apply "entry" to v_cod_estab_fim in frame f_dlg_04_compos_demonst_subst_505.
       end /* if */.
    end.
    else do:
       if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
           if  v_cod_dwb_user begins 'es_' then
               return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb071na.p".
           else do:
               message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb071na.p"
                      view-as alert-box error buttons ok.
               return.
           end.
       end.
       else
           run prgint/utb/utb071na.p (Input input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub) /*prg_see_estabelecimento_empresa*/.
       if  v_rec_estabelecimento <> ?
       then do:
           find estabelecimento where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
           assign v_cod_estab_fim:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
                  string(estabelecimento.cod_estab).
           apply "entry" to v_cod_estab_fim in frame f_dlg_04_compos_demonst_subst_505.
       end /* if */.
    end.

END. /* ON CHOOSE OF bt_zoo2 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON LEAVE OF v_cod_plano_ccusto_sub IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    if input frame f_dlg_04_compos_demonst_subst_505 v_cod_plano_ccusto_sub   <> v_cod_plano_ccusto_sub then
        assign v_log_alterado = yes.

    find plano_ccusto no-lock
         where plano_ccusto.cod_empresa      = v_cod_unid_organ_sub
           and plano_ccusto.cod_plano_ccusto = input frame f_dlg_04_compos_demonst_subst_505 v_cod_plano_ccusto_sub no-error.
    if  avail plano_ccusto
    then do:
        assign v_rec_plano_ccusto = recid(plano_ccusto).

        run pi_retornar_inic_zero (Input v_cod_ccusto_ini:handle in frame f_dlg_04_compos_demonst_subst_505,
                                   Input plano_ccusto.cod_format_ccusto) /*pi_retornar_inic_zero*/.
        run pi_retornar_inic_max (Input v_cod_ccusto_fim:handle in frame f_dlg_04_compos_demonst_subst_505,
                                  Input plano_ccusto.cod_format_ccusto) /*pi_retornar_inic_max*/.
        run pi_formatar_pfixa (Input v_cod_ccusto_pfixa_subst:handle in frame f_dlg_04_compos_demonst_subst_505,
                               Input plano_ccusto.cod_format_ccusto) /*pi_formatar_pfixa*/.
        run pi_formatar_pfixa (Input v_cod_ccusto_exec_subst:handle in frame f_dlg_04_compos_demonst_subst_505,
                               Input plano_ccusto.cod_format_ccusto) /*pi_formatar_pfixa*/.

        assign v_cod_plano_ccusto_sub = plano_ccusto.cod_plano_ccusto
               v_cod_ccusto_ini:format in frame f_dlg_04_compos_demonst_subst_505 = plano_ccusto.cod_format_ccusto
               v_cod_ccusto_fim:format in frame f_dlg_04_compos_demonst_subst_505 = plano_ccusto.cod_format_ccusto.
    end /* if */.
    else do:
        assign v_rec_plano_ccusto = ?
               v_cod_ccusto_ini:format = "x(11)":U
               v_cod_ccusto_fim:format = "x(11)":U
               v_cod_ccusto_pfixa_subst:format = "x(11)":U
               v_cod_ccusto_exec_subst:format  = "x(11)":U
               v_cod_ccusto_ini = ""
               v_cod_ccusto_fim = ""
               v_cod_ccusto_pfixa_subst = ""
               v_cod_ccusto_exec_subst  = ""
               v_cod_plano_ccusto_sub   = "".
    end /* else */.
END. /* ON LEAVE OF v_cod_plano_ccusto_sub IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON LEAVE OF v_cod_unid_organ_sub IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    if  input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub <> v_cod_unid_organ_sub
    then do:
        assign v_cod_unid_organ_sub = input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub
               v_log_alterado       = yes.
        find emsuni.empresa no-lock
           where empresa.cod_empresa = input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub no-error.
        if  avail empresa
        then do:
            enable v_log_ccusto_subst
                   with frame f_dlg_04_compos_demonst_subst_505.
        end /* if */.
        else do:
            disable v_log_ccusto_subst
                    with frame f_dlg_04_compos_demonst_subst_505.
        end /* else */.
        apply "value-changed" to v_log_ccusto_subst in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.
END. /* ON LEAVE OF v_cod_unid_organ_sub IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON VALUE-CHANGED OF v_log_ccusto_subst IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_plano_ccusto_return        as character       no-undo. /*local*/
    def var v_cod_plano_ccusto_unico         as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  v_log_ccusto_subst:checked in frame f_dlg_04_compos_demonst_subst_505 = yes
    then do:
        assign v_log_unid_organ_subst = yes.
        display v_log_unid_organ_subst
                with frame f_dlg_04_compos_demonst_subst_505.
            apply "value-changed" to v_log_unid_organ_subst in frame f_dlg_04_compos_demonst_subst_505.
            run pi_retornar_plano_ccusto_ult (Input v_cod_unid_organ_sub,
                                              Input ?,
                                              output v_cod_plano_ccusto_return,
                                              output v_log_plano_ccusto_unico) /*pi_retornar_plano_ccusto_ult*/.

            if  v_cod_unid_organ_sub = ? OR                 
                v_cod_unid_organ_sub = ""
            then do:
                find plano_ccusto no-lock
                     where plano_ccusto.cod_empresa      = v_cod_unid_organ_sub
                       and plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_return 
                           no-error.
            end /* if */.
            else do:
                find plano_ccusto no-lock
                     where plano_ccusto.cod_empresa      = v_cod_unid_organ_sub
                       and plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_sub
                           no-error.
                if  not avail plano_ccusto
                then do:                    
                   find plano_ccusto no-lock
                        where plano_ccusto.cod_empresa      = v_cod_unid_organ_sub
                          and plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto_return 
                              no-error.
                end /* if */.        
            end /* else */.

            if  avail plano_ccusto
            then do: 
                assign v_rec_plano_ccusto = recid(plano_ccusto)
                       v_cod_plano_ccusto_sub = plano_ccusto.cod_plano_ccusto.
                display v_cod_plano_ccusto_sub
                        with frame f_dlg_04_compos_demonst_subst_505.
            end /* if */.
            else do:
                assign v_rec_plano_ccusto = ?.
            end /* else */.

            enable v_cod_ccusto_exec_subst
                   v_cod_ccusto_pfixa_subst
                   v_cod_ccusto_fim
                   bt_zoo_327678
                   v_cod_ccusto_ini
                   bt_zoo_327679
                   v_cod_plano_ccusto_sub
                   bt_zoo_327683
                   with frame f_dlg_04_compos_demonst_subst_505.
            apply "leave" to v_cod_plano_ccusto_sub in frame f_dlg_04_compos_demonst_subst_505.
            if  v_log_plano_ccusto_unico = yes
            then do:
                disable v_cod_plano_ccusto_sub
                        bt_zoo_327683
                        with frame f_dlg_04_compos_demonst_subst_505.
            end /* if */.
            else do:
                enable v_cod_plano_ccusto_sub
                   bt_zoo_327683
                   with frame f_dlg_04_compos_demonst_subst_505.
        end /* else */.
    end /* if */. 
    else do:
        assign v_cod_ccusto_ini:format = "x(11)":U
               v_cod_ccusto_fim:format = "x(11)":U
               v_cod_ccusto_pfixa_subst:format = "x(11)":U
               v_cod_ccusto_exec_subst:format  = "x(11)":U
               v_cod_ccusto_ini = ""
               v_cod_ccusto_fim = ""
               v_cod_ccusto_pfixa_subst = ""
               v_cod_ccusto_exec_subst  = ""
               v_cod_plano_ccusto_sub   = "".
        disable v_cod_ccusto_exec_subst
                v_cod_ccusto_pfixa_subst
                v_cod_ccusto_fim
                bt_zoo_327678
                v_cod_ccusto_ini
                bt_zoo_327679
                v_cod_plano_ccusto_sub
                bt_zoo_327683
                with frame f_dlg_04_compos_demonst_subst_505.
        display v_cod_ccusto_exec_subst
                v_cod_ccusto_pfixa_subst
                v_cod_ccusto_fim
                v_cod_ccusto_ini
                v_cod_plano_ccusto_sub
                with frame f_dlg_04_compos_demonst_subst_505.
    end /* else */.
END. /* ON VALUE-CHANGED OF v_log_ccusto_subst IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON VALUE-CHANGED OF v_log_estab_subst IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    if  v_log_estab_subst:checked in frame f_dlg_04_compos_demonst_subst_505 = yes
    then do:
        enable v_cod_estab_ini
               bt_zoo
               v_cod_estab_fim
               bt_zoo2
               with frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.
    else do:
        assign v_cod_estab_ini = ""
               v_cod_estab_fim = "ZZZ".
        display v_cod_estab_ini
                v_cod_estab_fim
                with frame f_dlg_04_compos_demonst_subst_505.
        disable v_cod_estab_ini
                bt_zoo
                v_cod_estab_fim
                bt_zoo2
                with frame f_dlg_04_compos_demonst_subst_505.
    end /* else */.
END. /* ON VALUE-CHANGED OF v_log_estab_subst IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON VALUE-CHANGED OF v_log_unid_negoc_subst IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    if  v_log_unid_negoc_subst:checked in frame f_dlg_04_compos_demonst_subst_505 = yes
    then do:
        enable v_cod_unid_negoc_ini
               bt_zoo_327685
               v_cod_unid_negoc_fim
               bt_zoo_327684
               with frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.
    else do:
        assign v_cod_unid_negoc_ini = ""
               v_cod_unid_negoc_fim = "ZZZ".
        display v_cod_unid_negoc_ini
                v_cod_unid_negoc_fim
                with frame f_dlg_04_compos_demonst_subst_505.
        disable v_cod_unid_negoc_ini
                bt_zoo_327685
                v_cod_unid_negoc_fim
                bt_zoo_327684
                with frame f_dlg_04_compos_demonst_subst_505.
    end /* else */.
END. /* ON VALUE-CHANGED OF v_log_unid_negoc_subst IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON VALUE-CHANGED OF v_log_unid_organ_subst IN FRAME f_dlg_04_compos_demonst_subst_505
DO:

    if  v_log_unid_organ_subst:checked in frame f_dlg_04_compos_demonst_subst_505 = yes
    then do:
        if  v_cod_unid_organ_sub = ""
        then do:
            assign v_cod_unid_organ_sub = v_cod_empres_usuar.
        end /* if */.
        display v_cod_unid_organ_sub
                with frame f_dlg_04_compos_demonst_subst_505.
        enable v_cod_unid_organ_sub
               bt_zoo_327686
               with frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.
    else do:
        assign v_cod_unid_organ_sub = "".
        display v_cod_unid_organ_sub
                with frame f_dlg_04_compos_demonst_subst_505.
        disable v_cod_unid_organ_sub
                bt_zoo_327686
                with frame f_dlg_04_compos_demonst_subst_505.
    end /* else */.
    apply "leave" to v_cod_unid_organ_sub in frame f_dlg_04_compos_demonst_subst_505.
END. /* ON VALUE-CHANGED OF v_log_unid_organ_subst IN FRAME f_dlg_04_compos_demonst_subst_505 */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_327678 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_ccusto_fim IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

    /* fn_generic_zoom_variable */
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
    if  v_rec_ccusto <> ?
    then do:
        find emsuni.ccusto where recid(ccusto) = v_rec_ccusto no-lock no-error.
        assign v_cod_ccusto_fim:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(ccusto.cod_ccusto).

        apply "entry" to v_cod_ccusto_fim in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327678 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON  CHOOSE OF bt_zoo_327679 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_ccusto_ini IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

    /* fn_generic_zoom_variable */
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
    if  v_rec_ccusto <> ?
    then do:
        find emsuni.ccusto where recid(ccusto) = v_rec_ccusto no-lock no-error.
        assign v_cod_ccusto_ini:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(ccusto.cod_ccusto).

        apply "entry" to v_cod_ccusto_ini in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327679 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON  CHOOSE OF bt_zoo_327683 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_plano_ccusto_sub IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/utb/utb083ka.r") = ? and search("prgint/utb/utb083ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb083ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb083ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb083ka.p /*prg_sea_plano_ccusto*/.
    if  v_rec_plano_ccusto <> ?
    then do:
        find plano_ccusto where recid(plano_ccusto) = v_rec_plano_ccusto no-lock no-error.
        assign v_cod_plano_ccusto_sub:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(plano_ccusto.cod_plano_ccusto).

        apply "entry" to v_cod_plano_ccusto_sub in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327683 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON  CHOOSE OF bt_zoo_327684 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_unid_negoc_fim IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

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
        assign v_cod_unid_negoc_fim:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_fim in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327684 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON  CHOOSE OF bt_zoo_327685 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_unid_negoc_ini IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

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
        assign v_cod_unid_negoc_ini:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(unid_negoc.cod_unid_negoc).

        apply "entry" to v_cod_unid_negoc_ini in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327685 IN FRAME f_dlg_04_compos_demonst_subst_505 */

ON  CHOOSE OF bt_zoo_327686 IN FRAME f_dlg_04_compos_demonst_subst_505
OR F5 OF v_cod_unid_organ_sub IN FRAME f_dlg_04_compos_demonst_subst_505 DO:

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
        assign v_cod_unid_organ_sub:screen-value in frame f_dlg_04_compos_demonst_subst_505 =
               string(unid_organ.cod_unid_organ).

        apply "entry" to v_cod_unid_organ_sub in frame f_dlg_04_compos_demonst_subst_505.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_327686 IN FRAME f_dlg_04_compos_demonst_subst_505 */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_04_compos_demonst_subst_505 ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_04_compos_demonst_subst_505 */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_compos_demonst_subst_505 ANYWHERE
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

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_compos_demonst_subst_505 */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_compos_demonst_subst_505 ANYWHERE
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

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_compos_demonst_subst_505 */


/***************************** Frame Trigger End ****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_compos_demonst_subst_505}


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
    run pi_version_extract ('fnc_compos_demonst_subst_505':U, 'prgfin/mgl/MGLA204zf.p':U, '1.00.00.008':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

&IF '{&emsfin_version}' >= '5.07A' &THEN
    assign bt_zoo:column  in frame f_dlg_04_compos_demonst_subst_505 = bt_zoo:column  in frame f_dlg_04_compos_demonst_subst_505 + 2
           bt_zoo2:column in frame f_dlg_04_compos_demonst_subst_505 = bt_zoo2:column in frame f_dlg_04_compos_demonst_subst_505 + 2.
&ENDIF           

assign v_wgh_focus = v_log_unid_organ_subst:handle in frame f_dlg_04_compos_demonst_subst_505.


/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "fnc_compos_demonst_subst_505":U
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


assign v_wgh_frame_epc = frame f_dlg_04_compos_demonst_subst_505:handle.



assign v_nom_table_epc = 'prefer_demonst_ctbl':U
       v_rec_table_epc = recid(prefer_demonst_ctbl).

&endif

/* End_Include: i_verify_program_epc */


pause 0 before-hide.

assign v_cod_ccusto_ini:width         in frame f_dlg_04_compos_demonst_subst_505 = 21.14
       bt_zoo_327679:column           in frame f_dlg_04_compos_demonst_subst_505 = bt_zoo_327679:column in frame f_dlg_04_compos_demonst_subst_505 + 9.00
       v_cod_ccusto_fim:width         in frame f_dlg_04_compos_demonst_subst_505 = 21.14
       bt_zoo_327678:column           in frame f_dlg_04_compos_demonst_subst_505 = bt_zoo_327678:column in frame f_dlg_04_compos_demonst_subst_505 + 9.00
       v_cod_ccusto_pfixa_subst:width in frame f_dlg_04_compos_demonst_subst_505 = 21.14
       v_cod_ccusto_exec_subst:width  in frame f_dlg_04_compos_demonst_subst_505 = 21.14.



display bt_can
        bt_hel2
        bt_ok
        bt_sav
        bt_zoo
        bt_zoo2
        v_cod_ccusto_exec_subst
        v_cod_ccusto_fim
        v_cod_ccusto_ini
        v_cod_ccusto_pfixa_subst
        v_cod_estab_fim
        v_cod_estab_ini
        v_cod_plano_ccusto_sub
        v_cod_unid_negoc_fim
        v_cod_unid_negoc_ini
        v_cod_unid_organ_sub
        v_log_ccusto_subst
        v_log_estab_subst
        v_log_unid_negoc_subst
        v_log_unid_organ_subst
        with frame f_dlg_04_compos_demonst_subst_505.
disable all with frame f_dlg_04_compos_demonst_subst_505.
enable v_log_estab_subst
       v_log_unid_negoc_subst
       v_log_unid_organ_subst
       v_log_ccusto_subst
       bt_can
       bt_hel2
       bt_ok
       bt_sav
       bt_zoo
       with frame f_dlg_04_compos_demonst_subst_505.           


/* * Posiciona na £ltima preferància do usu†rio **/
FOR EACH b_prefer_demonst_ctbl NO-LOCK
     where b_prefer_demonst_ctbl.cod_usuario = v_cod_usuar_corren
     AND   b_prefer_demonst_ctbl.cod_demonst_ctbl          <> ""
     AND   b_prefer_demonst_ctbl.cod_padr_col_demonst_ctbl <> ""
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
&if '{&emsfin_version}' = '5.05' &then
  IF NUM-ENTRIES(prefer_demonst_ctbl.cod_livre_1,chr(10)) >= 15 THEN
     assign v_log_unid_organ_subst   = (entry(2,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
            v_log_unid_negoc_subst   = (entry(3,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
            v_log_estab_subst        = (entry(4,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
            v_log_ccusto_subst       = (entry(5,prefer_demonst_ctbl.cod_livre_1,chr(10)) = 'YES')
            v_cod_unid_organ_sub     = entry(6,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_unid_negoc_ini     = entry(7,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_unid_negoc_fim     = entry(8,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_estab_ini          = entry(9,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_estab_fim          = entry(10,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_ccusto_ini         = entry(11,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_ccusto_fim         = entry(12,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_ccusto_pfixa_subst = entry(13,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_ccusto_exec_subst  = entry(14,prefer_demonst_ctbl.cod_livre_1,chr(10))
            v_cod_plano_ccusto_sub   = entry(15,prefer_demonst_ctbl.cod_livre_1,chr(10)).
&else
  assign v_log_unid_organ_subst   = prefer_demonst_ctbl.log_unid_organ_subst
         v_log_unid_negoc_subst   = prefer_demonst_ctbl.log_unid_negoc_subst
         v_log_estab_subst        = prefer_demonst_ctbl.log_estab_subst
         v_log_ccusto_subst       = prefer_demonst_ctbl.log_ccusto_subst
         v_cod_unid_organ_sub     = prefer_demonst_ctbl.cod_unid_organ_subst
         v_cod_unid_negoc_ini     = prefer_demonst_ctbl.cod_unid_negoc_inic_subst
         v_cod_unid_negoc_fim     = prefer_demonst_ctbl.cod_unid_negoc_fim_subst
         v_cod_estab_ini          = prefer_demonst_ctbl.cod_estab_inic_subst
         v_cod_estab_fim          = prefer_demonst_ctbl.cod_estab_fim_subst
         v_cod_ccusto_ini         = prefer_demonst_ctbl.cod_ccusto_inic_subst
         v_cod_ccusto_fim         = prefer_demonst_ctbl.cod_ccusto_fim_subst
         v_cod_ccusto_pfixa_subst = prefer_demonst_ctbl.cod_ccusto_pfixa_subst
         v_cod_ccusto_exec_subst  = prefer_demonst_ctbl.cod_ccusto_exec_subst
         v_cod_plano_ccusto_sub   = prefer_demonst_ctbl.cod_plano_ccusto_subst.
&endif

disp v_log_unid_organ_subst   
     v_log_unid_negoc_subst   
     v_log_estab_subst        
     v_log_ccusto_subst       
     v_cod_unid_organ_sub     
     v_cod_unid_negoc_ini     
     v_cod_unid_negoc_fim     
     v_cod_estab_ini          
     v_cod_estab_fim          
     v_cod_ccusto_ini         
     v_cod_ccusto_fim         
     v_cod_ccusto_pfixa_subst 
     v_cod_ccusto_exec_subst  
     v_cod_plano_ccusto_sub with frame f_dlg_04_compos_demonst_subst_505.

apply "value-changed" to v_log_unid_organ_subst in frame f_dlg_04_compos_demonst_subst_505.
apply "value-changed" to v_log_unid_negoc_subst in frame f_dlg_04_compos_demonst_subst_505.
apply "value-changed" to v_log_estab_subst      in frame f_dlg_04_compos_demonst_subst_505.
apply "value-changed" to v_log_ccusto_subst     in frame f_dlg_04_compos_demonst_subst_505.

repeat_block:
repeat while v_log_repeat:
    assign v_log_repeat = no.
    main_block:
    do on endkey undo main_block, leave main_block on error undo main_block, retry main_block.
        display v_cod_ccusto_exec_subst
                v_cod_ccusto_pfixa_subst
                v_cod_ccusto_fim
                v_cod_ccusto_ini
                v_cod_plano_ccusto_sub
                with frame f_dlg_04_compos_demonst_subst_505.


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


        if  valid-handle(v_wgh_focus)
        then do:
            wait-for go of frame f_dlg_04_compos_demonst_subst_505 focus v_wgh_focus.
        end.
        else do:
            wait-for go of frame f_dlg_04_compos_demonst_subst_505 focus bt_ok.
        end.

        IF NOT v_log_alterado                                                                                       
           AND (input frame f_dlg_04_compos_demonst_subst_505 v_log_unid_organ_subst      <> v_log_unid_organ_subst 
                OR input frame f_dlg_04_compos_demonst_subst_505 v_log_unid_negoc_subst   <> v_log_unid_negoc_subst
                OR input frame f_dlg_04_compos_demonst_subst_505 v_log_estab_subst        <> v_log_estab_subst
                OR input frame f_dlg_04_compos_demonst_subst_505 v_log_ccusto_subst       <> v_log_ccusto_subst
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_negoc_ini     <> v_cod_unid_negoc_ini
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_negoc_fim     <> v_cod_unid_negoc_fim
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_estab_ini          <> v_cod_estab_ini
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_estab_fim          <> v_cod_estab_fim
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_ini         <> v_cod_ccusto_ini
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_fim         <> v_cod_ccusto_fim
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_pfixa_subst <> v_cod_ccusto_pfixa_subst
                OR input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_exec_subst  <> v_cod_ccusto_exec_subst) THEN
            ASSIGN v_log_alterado = YES.

        if  input frame f_dlg_04_compos_demonst_subst_505 v_log_ccusto_subst = yes
        then do:
            find plano_ccusto no-lock
               where plano_ccusto.cod_empresa      = input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub
                 and plano_ccusto.cod_plano_ccusto = input frame f_dlg_04_compos_demonst_subst_505 v_cod_plano_ccusto_sub no-error.
            if  not avail plano_ccusto
            then do: 
                /* &1 inexistente ! */
                run pi_messages (input "show",
                                 input 1284,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "Plano Centros Custo", "Planos Centros Custo")) /*msg_1284*/.
                assign v_wgh_focus = v_cod_plano_ccusto_sub:handle in frame f_dlg_04_compos_demonst_subst_505.
                undo main_block, retry main_block.
            end.
        end.

        assign input frame f_dlg_04_compos_demonst_subst_505 v_log_unid_organ_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_log_unid_negoc_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_log_estab_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_log_ccusto_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_organ_sub
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_negoc_ini
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_unid_negoc_fim
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_estab_ini
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_estab_fim
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_ini
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_fim
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_pfixa_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_ccusto_exec_subst
               input frame f_dlg_04_compos_demonst_subst_505 v_cod_plano_ccusto_sub.

        /* * Salva parÉmetros da tela nas preferàncias do usu†rio **/
        &if '{&emsfin_version}' = '5.05' &then
        assign prefer_demonst_ctbl.cod_livre_1 = entry(1,prefer_demonst_ctbl.cod_livre_1,chr(10)) + chr(10) +
                                                 string(v_log_unid_organ_subst) + chr(10) +
        					 string(v_log_unid_negoc_subst) + chr(10) +
        					 string(v_log_estab_subst) 	+ chr(10) +
        					 string(v_log_ccusto_subst) 	+ chr(10) +
        				         v_cod_unid_organ_sub     + chr(10) +
        					 v_cod_unid_negoc_ini     + chr(10) +
        					 v_cod_unid_negoc_fim     + chr(10) +
        					 v_cod_estab_ini 	  + chr(10) +
        					 v_cod_estab_fim 	  + chr(10) +
        					 v_cod_ccusto_ini 	  + chr(10) +
        					 v_cod_ccusto_fim 	  + chr(10) +
        					 v_cod_ccusto_pfixa_subst + chr(10) +
        					 v_cod_ccusto_exec_subst  + chr(10) +
        					 v_cod_plano_ccusto_sub.
        &else
        assign prefer_demonst_ctbl.log_unid_organ_subst      = v_log_unid_organ_subst
               prefer_demonst_ctbl.log_unid_negoc_subst      = v_log_unid_negoc_subst
    	       prefer_demonst_ctbl.log_estab_subst           = v_log_estab_subst
               prefer_demonst_ctbl.log_ccusto_subst          = v_log_ccusto_subst
               prefer_demonst_ctbl.cod_unid_organ_subst      = v_cod_unid_organ_sub
               prefer_demonst_ctbl.cod_unid_negoc_inic_subst = v_cod_unid_negoc_ini
               prefer_demonst_ctbl.cod_unid_negoc_fim_subst  = v_cod_unid_negoc_fim
               prefer_demonst_ctbl.cod_estab_inic_subst      = v_cod_estab_ini
               prefer_demonst_ctbl.cod_estab_fim_subst       = v_cod_estab_fim
               prefer_demonst_ctbl.cod_ccusto_inic_subst     = v_cod_ccusto_ini
               prefer_demonst_ctbl.cod_ccusto_fim_subst      = v_cod_ccusto_fim
               prefer_demonst_ctbl.cod_ccusto_pfixa_subst    = v_cod_ccusto_pfixa_subst
               prefer_demonst_ctbl.cod_ccusto_exec_subst     = v_cod_ccusto_exec_subst
               prefer_demonst_ctbl.cod_plano_ccusto_subst    = v_cod_plano_ccusto_sub.
        &endif    


        /* Begin_Include: i_exec_program_epc */
        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then
        do:
            assign v_rec_table_epc = recid(prefer_demonst_ctbl).    
            run value(v_nom_prog_upc) (input "END" /* l_end*/,
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
            run value(v_nom_prog_appc) (input "END" /* l_end*/,
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
            run value(v_nom_prog_dpc) (input "END" /* l_end*/,
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


    end /* do main_block */.
end /* repeat repeat_block */.

assign v_wgh_focus = ?.
hide frame f_dlg_04_compos_demonst_subst_505.


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


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/
&endif

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
/*******************  End of fnc_compos_demonst_subst_505 *******************/
