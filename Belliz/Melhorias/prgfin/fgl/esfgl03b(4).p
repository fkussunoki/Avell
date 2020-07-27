/********************************************************************************************************
**
**   Programa..............: esp_aprop_ctbl_impr
**   Nome Externo..........: esp/esfgl03a.py
**   Descricao.............: Relat¢rio Apropriaá‰es Cont†beis Espec°fico
**   Criado por............: Henke
**   Criado em.............: 25/02/2006
**   Vers∆o em.............: 27/02/2006 - Henke - 1.01.00.000 - Acerto RPW e eliminaá∆o de temp-tables;
**                           02/03/2006 - Henke - 1.01.01.000 - Apresentaá∆o de Lote, Lancto e Seq;
**                           14/03/2006 - Henke - 1.01.02.000 - Quando for RM (CEP) passou a n∆o detalhar;
**                           15/03/2006 - Henke - 1.01.03.000 - Acerto no hist¢rico do CMG (trocado coluna);
**                           21/03/2006 - Henke - 1.01.04.000 - Alterada a leitura do CEP (Aberto / Fechado);
**                           22/03/2006 - Henke - 1.01.05.000 - Acerto na leitura do Grp do CEP;
**                           22/03/2006 - Henke - 1.01.06.000 - Acerto na leitura das RM do CEP;
**                           29/03/2006 - Henke - 1.02.00.000 - Incluido faixas de Lote Ctbl e de Ccusto;
**                           04/04/2006 - Henke - 1.02.01.000 - Acerto na leitura dos movto_estoq;
**                           17/04/2006 - Henke - 1.02.02.000 - Leitura dos detalhes no CEP quando Ç conta
**                           cont†bil de Impostos;
**                           14/07/2006 - Henke - 1.02.03.000 - Isolado os gatilhos para compilar somente
**                           no Windows;
**                           10/08/2006 - Henke - 1.03.00.000 - Là somente o 1o. item de lancto ctbl do
**                           FTP de forma anal°tica;
**
*******************************************************************************************************/

def stream s_1.
def stream s_plha.
def stream s_ab.
def stream s_cd.
def stream s_ez.

DEFINE TEMP-TABLE es-usuar-cc
    FIELD COD_USUARIO AS CHAR
    FIELD COD_CCUSTO    AS CHAR.

DEFINE TEMP-TABLE es-apvs-ped-venda
    FIELD NOME-ABREV     AS CHAR
    FIELD NR-PEDCLI    AS CHARACTER
    FIELD cond-espec    AS CHAR.


DEFINE TEMP-TABLE tt-sumar-ft LIKE sumar-ft.

def temp-table tt_item_lancto_ctbl
    field cod_empresa         like item_lancto_ctbl.cod_empresa
    FIELD num_id_aprop_lancto_ctbl LIKE aprop_lancto_ctbl.num_id_aprop_lancto_ctbl
    field dat_lancto_ctbl     like item_lancto_ctbl.dat_lancto_ctbl
    field num_lote_ctbl       like item_lancto_ctbl.num_lote_ctbl
    field num_lancto_ctbl     like item_lancto_ctbl.num_lancto_ctbl
    field num_seq_lancto_ctbl like item_lancto_ctbl.num_seq_lancto_ctbl
    FIELD cod_modul_dtsul     LIKE lancto_ctbl.cod_modul_dtsul
    FIELD cod_plano_cta_ctbl  LIKE ITEM_lancto_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl        LIKE ITEM_lancto_ctbl.cod_cta_ctbl
    FIELD cod_plano_ccusto    LIKE ITEM_lancto_ctbl.cod_plano_ccusto
    FIELD cod_ccusto          LIKE ITEM_lancto_ctbl.cod_ccusto
    FIELD cod_estab           LIKE ITEM_lancto_ctbl.cod_estab
    FIELD cod_unid_negoc      LIKE ITEM_lancto_ctbl.cod_unid_negoc
    field val_lancto_ctbl_db  like item_lancto_ctbl.val_lancto_ctbl
    field val_lancto_ctbl_cr  like item_lancto_ctbl.val_lancto_ctbl
    field des_histor          like item_lancto_ctbl.des_histor_lancto_ctbl
    field num_seq_lancto_ctbl_cpart like item_lancto_ctbl.num_seq_lancto_ctbl_cpart
    index tt_id is primary unique
          num_id_aprop_lancto_ctbl
    index tt_seq is unique
          num_lote_ctbl
          num_lancto_ctbl
          num_seq_lancto_ctbl.

def temp-table tt_reg_calc_bem_pat
    field num_seq_reg_calc_bem_pat like aprop_ctbl_pat.num_seq_reg_calc_bem_pat.

DEF VAR V_COD_CTA_CTBL_INI     AS CHAR NO-UNDO.
DEF VAR V_COD_CTA_CTBL_FIM     AS CHAR NO-UNDO.

def new global shared var v_cod_dwb_user        as char no-undo.
def new global shared var v_cod_usuar_corren    as char no-undo.
def new global shared var v_num_ped_exec_corren as integer format ">>>>>9" no-undo.
def new global shared var v_cod_empres_usuar    like emsuni.empresa.cod_empresa  no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_plano_ccusto_corren AS CHAR NO-UNDO.
def new global shared var v_rec_empresa         as recid no-undo.
def new global shared var v_rec_empresa_1       as recid no-undo.
def new global shared var v_rec_cenar_ctbl      as recid no-undo.
def new global shared var v_rec_finalid_econ    as recid no-undo.
def new global shared var v_rec_plano_cta_ctbl  as recid no-undo.
def new global shared var v_rec_plano_ccusto    as recid no-undo.
def new global shared var v_rec_cta_ctbl        as recid no-undo.
def new global shared var v_rec_ccusto          as recid no-undo.
def new global shared var v_rec_estabelecimento as recid no-undo.
def new global shared var v_rec_unid_negoc      as recid no-undo.
def new global shared var v_rec_exerc_ctbl      as recid no-undo.
def new global shared var v_rec_lote_ctbl       as recid no-undo.
DEF NEW GLOBAL SHARED VAR v_rec_period_ctbl_ini AS RECID NO-UNDO. /* Criado para preencher data automaticamente na tela */
def new global shared var v_rec_demonst_ctbl    AS RECID NO-UNDO. /*  criado para preencher data automaticamente na tela */

def new global shared var v_cod_cta_ctbl_inicial
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.
def new global shared var v_cod_cta_ctbl_final
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.

def new global shared var v_cod_ccusto
    as character
    format "x(20)":U
    label "Centro de Custo"
    column-label "CCusto"
    no-undo.

def new global shared var v_cod_ccusto_final
    as character
    format "x(20)":U
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

def var v_cod_plano_cta_ctbl   like plano_cta_ctbl.cod_plano_cta_ctbl  no-undo.
def var v_des_plano_cta_ctbl   like plano_cta_ctbl.des_tit_ctbl        no-undo.
def var v_cod_format_cta_ctbl  like plano_cta_ctbl.cod_format_cta_ctbl no-undo.
def var v_cod_plano_ccusto     like plano_ccusto.cod_plano_ccusto      no-undo.
def var v_des_plano_ccusto     like plano_ccusto.des_tit_ctbl          no-undo.
def var v_cod_format_ccusto    like plano_ccusto.cod_format_ccusto     no-undo.
def var v_cod_cta_ctbl         like cta_ctbl.cod_cta_ctbl              no-undo.
def var v_cod_empresa          like emsuni.empresa.cod_empresa         no-undo.
def var v_nom_abrev            like emsuni.empresa.nom_abrev           no-undo.
def var v_cod_cenar_ctbl       like cenar_ctbl.cod_cenar_ctbl          no-undo.
def var v_des_cenar_ctbl       like cenar_ctbl.des_cenar_ctbl          no-undo.
def var v_cod_finalid_econ     like finalid_econ.cod_finalid_econ      no-undo.
def var v_des_finalid_econ     like finalid_econ.des_finalid_econ      no-undo.
def var v_dat_fim_period_ctbl  like period_ctbl.dat_fim_period_ctbl    no-undo.
def var v_dat_inic_period_ctbl like period_ctbl.dat_inic_period_ctbl   no-undo.
def var v_nom_estab            like estabelecimento.nom_abrev          no-undo.
def var v_cod_dwb_output       like dwb_rpt_param.cod_dwb_output no-undo.

def var v_cod_estab_ini        as char format "x(03)"               no-undo.
def var v_cod_estab_fim        as char format "x(03)" initial "ZZZ" no-undo.
def var v_cod_estab_aux        as char format "x(03)"               no-undo.
def var v_cod_estab_cpart      as char format "x(03)"               no-undo.
def var v_des_estab            as char format "x(40)"               no-undo.
def var v_des_estab_cpart      as char format "x(40)"               no-undo.
def var v_cod_unid_negoc_ini   as char format "x(03)"               no-undo.
def var v_cod_unid_negoc_fim   as char format "x(03)" initial "ZZZ" no-undo.
def var v_cod_unid_negoc_aux   as char format "x(03)"               no-undo.
def var v_cod_unid_negoc_cpart as char format "x(03)"               no-undo.
def var v_des_unid_negoc       as char format "x(40)"               no-undo.
def var v_des_unid_negoc_cpart as char format "x(40)"               no-undo.
//def var v_cod_cta_ctbl_ini     like cta_ctbl.cod_cta_ctbl label "Cta Ctbl Ini"  no-undo.
//def var v_cod_cta_ctbl_fim     like cta_ctbl.cod_cta_ctbl label "Final"         no-undo.
def var v_cod_cta_ctbl_aux     as char format "x(20)"               no-undo.
def var v_cod_cta_ctbl_ftp     as char                              no-undo.
def var v_cod_cta_ctbl_ext     as char                              no-undo.
def var v_cod_cta_ctbl_cpart   as char format "x(20)"               no-undo.
def var v_des_cta_ctbl         as char format "x(40)"               no-undo.
def var v_des_cta_ctbl_cpart   as char format "x(40)"               no-undo.
def var v_cod_ccusto_ini       like emsuni.ccusto.cod_ccusto label "Ccusto Ini" no-undo.
def var v_cod_ccusto_fim       like emsuni.ccusto.cod_ccusto label "Ccusto Fim" no-undo.
def var v_num_lote_ctbl_ini    like lote_ctbl.num_lote_ctbl initial 0           no-undo.
def var v_num_lote_ctbl_fim    like lote_ctbl.num_lote_ctbl initial 999999999   no-undo.
def var v_cod_ccusto_aux       as char format "x(11)"               no-undo.
def var v_cod_ccusto_cpart     as char format "x(11)"               no-undo.
def var v_des_ccusto           as char format "x(40)"               no-undo.
def var v_des_ccusto_cpart     as char format "x(40)"               no-undo.
def var v_des_refer            as char format "x(40)"               no-undo.
def var v_log_cep_open         as log no-undo.

def var v_val_sdo_item_acum    as decimal format "->>,>>>,>>>,>>9.99" decimals 2
                                  label "Sdo Ccusto  Fim" column-label "Sdo Acum fim" no-undo.    
def var v_val_sdo_ctbl_acum    as decimal format "->>,>>>,>>>,>>9.99" decimals 2
                                  label "Sdo Ccusto  Fim" column-label "Sdo Acum fim" no-undo.

def var v_wgh_focus            as widget-handle format ">>>>>>9" no-undo.
def var v_log_run              as log init yes no-undo.
def var v_num_ped_exec_rpw     as int          no-undo.

def var v_rpt_s_1_lines        as integer initial 66.
def var v_rpt_s_1_columns      as integer initial 132.
def var v_rpt_s_1_bottom       as integer initial 63.
def var v_rpt_s_1_page         as integer.
def var v_rpt_s_1_name         as character initial "Demonstrativo Cont†bil (%V)".

def var v_log_aprop        as log  no-undo.
def var v_log_print        as log  init yes no-undo.
def var v_des_impressor    as char no-undo.
def var v_des_layout       as char no-undo.
def var v_arq_aux          as char no-undo.
def var v_num_cont         as int  no-undo.
def var v_val_max          as dec  no-undo.
def var v_val_curr         as dec  no-undo.
def var v_num_entry        as int  no-undo.
def var c-esp              as character forma "x(03)".

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {ininc/i03in218.i 03}.
    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
    ASSIGN  c-esp = cAuxTraducao001.
&else
    ASSIGN c-esp = {ininc/i03in218.i 03}.
&endif


def var v_cod_release      as char format "x(11)"      no-undo.
def var v_nom_enterprise   as char format "x(40)"      no-undo.
def var v_nom_report_title as char format "x(40)"      no-undo.
def var v_dat_execution    as date format "99/99/9999" no-undo.
def var v_hra_execution    as char format "99:99"      no-undo.
def var v_nom_prog_ext     as char format "x(8)" label "Nome Externo" no-undo.
def var v_log_print_par    as log  format "Sim/N∆o" initial yes view-as toggle-box no-undo.
def var v_log_analit       as log  format "Sim/N∆o" initial yes view-as toggle-box no-undo.
def var v_log_lote_ctbl    as log  format "Sim/N∆o" view-as toggle-box no-undo.
def var v_log_cpart        as log  format "Sim/N∆o" initial no view-as toggle-box no-undo.

def var v_arq_out  as char format "x(80)" view-as editor max-chars 250 no-word-wrap 
                     size 40 by 1 bgcolor 15 font 2 label "Nome Arquivo" no-undo. 
def var v_arq_plan as char format "x(80)" view-as editor max-chars 250 no-word-wrap 
                      size 40 by 1 bgcolor 15 font 2 label "Arquivo Planiha" no-undo.                     
def var v_arq_ab   as char format "x(80)" view-as editor max-chars 250 no-word-wrap 
                      size 40 by 1 bgcolor 15 font 2 label "Arquivo Planiha" no-undo.                     
def var v_arq_cd   as char format "x(80)" view-as editor max-chars 250 no-word-wrap 
                      size 40 by 1 bgcolor 15 font 2 label "Arquivo Planiha" no-undo.                     
def var v_arq_ez    as char format "x(80)" view-as editor max-chars 250 no-word-wrap 
                      size 40 by 1 bgcolor 15 font 2 label "Arquivo Planiha" no-undo.                     


def var rs_destino
    as int
    initial 3
    view-as radio-set Horizontal
    radio-buttons "Impressora",1,"Arquivo",2,"Terminal",3
    bgcolor 8 
    no-undo.
def var rs_execucao
    as int
    initial 1
    view-as radio-set Horizontal
    radio-buttons "On-Line",1,"Batch",2
    bgcolor 8 
    no-undo.

def var v_des_percent_complete
    as character
    format "x(06)"
    no-undo.
def var v_des_percent_complete_fnd
    as character
    format "x(08)"
    no-undo.

def button bt_can2
    label "Cancela"
    tooltip "Cancela"
    size 10 by 1.
def button bt_can 
    label "&Cancela" 
    tooltip "Cancela" 
    size 10.00 by 1.00
    auto-endkey. 
def button bt_get_file 
    label "Pesquisa Arquivo" 
    tooltip "Pesquisa Arquivo" 
    image-up file "image/im-sea1" 
    image-insensitive file "image/ii-sea1" 
    size 1 by 1. 
def button bt_set_printer
    label "Define Impressora e Layout"
    tooltip "Define Impressora e Layout de Impress∆o"
    image-up file "image/im-setpr.bmp"
    image-insensitive file "image/ii-setpr"
    size 04.00 by 01.18.
def button bt_hel2 
    label "&Ajuda" 
    tooltip "Ajuda" 
    size 10.00 by 1.00.
def button bt_close
    label "&Fecha*" 
    tooltip "Fecha" 
    size 10.00 by 1.00
    auto-go.
def button bt_run
    label "&Executa"
    tooltip "Executa"
    size 10.00 by 01.00
    auto-go.
def button bt_zoo_emp
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_cenar
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_finalid
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ctaini
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ctafim
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ccini
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ccfim
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.    
def button bt_zoo_estini
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_estfim
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ltini
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_ltfim
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.    
def button bt_zoo_plano_cta
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_plano_cc
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.    
def button bt_zoo_unini
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.
def button bt_zoo_unfim
    label "Zoom" tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

def image im_fld_page_1 
    file "image/im-fldup":U 
    size 15.72 by 01.21.
def image im_fld_page_2 
    file "image/im-fldup":U 
    size 15.72 by 01.21.
def image im_fld_page_3 
    file "image/im-fldup":U 
    size 15.72 by 01.21.    

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
    size 46.79 by 1.92
    edge-pixels 2.

def rectangle rt_cxcf 
    size 76.29 by 1.42 
    fgcolor 1 edge-pixels 2. 
def rectangle rt_folder 
    size 76.29 by 10.46 
    edge-pixels 1. 
def rectangle rt_folder_bottom 
    size 76.00 by 0.13 
    edge-pixels 0. 
def rectangle rt_folder_left 
    size 0.43 by 10.17
    edge-pixels 0. 
def rectangle rt_folder_right 
    size 0.43 by 10.25 
    edge-pixels 0. 
def rectangle rt_folder_top 
    size 76.00 by 0.13 
    edge-pixels 0. 

def var v_des_traco   as char format "x(141)" no-undo.
def var v_des_traco_1 as char format "x(104)"  no-undo.
def var v_des_traco_2 as char format "x(133)" no-undo.

def frame f_rpt_header header
    v_des_traco at 01
    "P†gina: " at 143
    (page-number (s_1) + v_rpt_s_1_page) to 156 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 156 format "x(40)" skip
    "Per°odo: " at 1
    v_dat_inic_period_ctbl at 10 format "99/99/9999"
    "A" at 21
    v_dat_fim_period_ctbl at 23 format "99/99/9999"
    v_des_traco_1 at 34
    v_dat_execution at 139 format "99/99/9999"
    "-" at 150
    v_hra_execution at 152 format "99:99" skip (1)
    with no-box no-labels width 156 page-top stream-io.

def frame f_rpt_footer header
    skip (1)
    v_des_traco_2 at 1
    v_nom_prog_ext at 135 format "x(8)"
    "-" at 144
    v_cod_release to 156 format "x(11)" skip
    with no-box no-labels width 156 page-bottom stream-io.

def frame f_perc
    rt_005
         at row 01.29 col 02.00
    " Percentual Completo " view-as text
         at row 01.00 col 04.00
    v_des_percent_complete_fnd
         at row 02.04 col 03.00 no-label
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_percent_complete
         at row 02.04 col 03.00 no-label
         view-as fill-in
         size-chars 7.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_can2
         at row 03.50 col 20.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 50.00 by 05.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "".

def frame f_main
    rt_folder 
         at row 02.50 col 02.00 bgcolor 8  
    rt_folder_right 
         at row 02.58 col 77.72 bgcolor 7  
    rt_folder_left 
         at row 02.58 col 02.14 bgcolor 15  
    rt_cxcf 
         at row 13.33 col 02.00 bgcolor 7  
    rt_folder_top 
         at row 02.54 col 02.14 bgcolor 15  
    rt_folder_bottom 
         at row 12.79 col 02.14 bgcolor 7  
&if "{&window-system}" <> "TTY" &then 
    im_fld_page_1 
         at row 01.50 col 02.29 
    " Seleá∆o " view-as text
         at row 01.75 col 04.00 bgcolor 8 
    im_fld_page_2 
         at row 01.50 col 18.00 
    " ParÉmetros " view-as text
         at row 01.75 col 19.00 bgcolor 8 
    im_fld_page_3 
         at row 01.50 col 33.71          
    " Impress∆o/Execuá∆o " view-as text 
         at row 01.75 col 34.00 bgcolor 8  
&endif 
    bt_close 
         at row 13.54 col 03.00 font ? 
         help "OK" 
    bt_run
         at row 13.54 col 14.00 font ? 
         help "OK" 
    bt_can 
         at row 13.54 col 25.00 font ? 
         help "Cancela" 
    bt_hel2 
         at row 13.54 col 67.29 font ? 
         help "Ajuda" 
    with 1 down side-labels no-validate keep-tab-order three-d 
         size-char 79.72 by 15.17 
         view-as dialog-box 
         font 1 fgcolor ? bgcolor 8 
         title "Relat¢rio Apropriaá∆o Cont†bil - ESFGL03A - 1.03.00.000". 

def frame f_param 
    rt_001 
         at row 01.25 col 02.00 bgcolor 8
    v_cod_empresa 
        at row 02.61 col 18.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    bt_zoo_emp 
        at row 02.61 col 22.30 colon-aligned 
    v_nom_abrev no-label
        at row 02.61 col 27.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v_cod_cenar_ctbl 
        at row 03.61 col 18.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    bt_zoo_cenar 
        at row 03.61 col 27.30 colon-aligned 
    v_des_cenar_ctbl no-label
        at row 03.61 col 32.00 colon-aligned 
        view-as fill-in size 35 by 0.88
        fgcolor ? bgcolor 15 font 2
    v_cod_finalid_econ
        at row 04.61 col 18.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    bt_zoo_finalid 
        at row 04.61 col 29.30 colon-aligned 
    v_des_finalid_econ no-label
        at row 04.61 col 34.00 colon-aligned 
        view-as fill-in size 35 by 0.88
        fgcolor ? bgcolor 15 font 2
    v_cod_plano_cta_ctbl label "Plano Cta Ctbl"
         at row 05.61 col 18.00 colon-aligned 
         view-as fill-in 
         fgcolor ? bgcolor 15 font 2         
    bt_zoo_plano_cta 
         at row 05.61 col 27.30 colon-aligned
    v_des_plano_cta_ctbl no-label
        at row 05.61 col 32.00 colon-aligned 
        view-as fill-in size 35 by 0.88
        fgcolor ? bgcolor 15 font 2        
    v_cod_plano_ccusto label "Plano Ccusto"
         at row 06.61 col 18.00 colon-aligned 
         view-as fill-in 
         fgcolor ? bgcolor 15 font 2
    bt_zoo_plano_cc 
         at row 06.61 col 27.30 colon-aligned
    v_des_plano_ccusto no-label
        at row 06.61 col 32.00 colon-aligned 
        view-as fill-in size 35 by 0.88
        fgcolor ? bgcolor 15 font 2    
    with 1 down side-labels no-validate keep-tab-order three-d 
         size-char 74.86 by 10.08 
         at row 04.54 col 02.00 no-box 
         font 1 fgcolor ? bgcolor 8. 
    assign rt_001:width-chars       in frame f_param = 72.72 
           rt_001:height-chars      in frame f_param = 09.54.

def frame f_select
    rt_001 
         at row 01.25 col 02.00 bgcolor 8
&if "{&window-system}" <> "TTY" &then
    v_dat_inic_period_ctbl
         at row 02.61 col 18.00 colon-aligned label "Data Inicial"
         help "Data"
         view-as fill-in
         fgcolor ? bgcolor 15 font 2
    v_dat_fim_period_ctbl
         at row 02.61 col 44.00 colon-aligned label "Final"
         help "Data"
         view-as fill-in
         fgcolor ? bgcolor 15 font 2
    v_cod_cta_ctbl_ini
         at row 03.61 col 18.00 colon-aligned label "Cta Ctbl Inicial"
         help "C¢digo Conta Cont†bil"
         view-as fill-in
         /*size-chars 14.14 by .88*/
         fgcolor ? bgcolor 15 font 2
/*     bt_zoo_ctaini                             */
/*          at row 03.61 col 37.30 colon-aligned */
    v_cod_cta_ctbl_fim
         at row 03.61 col 44.00 colon-aligned label "Final"
         help "C¢digo Conta Cont†bil"
         view-as fill-in
         /*size-chars 14.14 by .88*/
         fgcolor ? bgcolor 15 font 2
/*     bt_zoo_ctafim                             */
/*          at row 03.61 col 63.30 colon-aligned */
    v_cod_ccusto_ini
         at row 04.61 col 18.00 colon-aligned label "Ccusto Inicial"
         help "C¢digo Centro de Custo"
         view-as fill-in
         /*size-chars 12.14 by .88*/
         fgcolor ? bgcolor 15 font 2
/*     bt_zoo_ccini                              */
/*          at row 04.61 col 30.30 colon-aligned */
    v_cod_ccusto_fim
         at row 04.61 col 44.00 colon-aligned label "Final"
         help "C¢digo Unidade Neg¢cio"
         view-as fill-in
         /*size-chars 12.14 by .88*/
         fgcolor ? bgcolor 15 font 2
/*     bt_zoo_ccfim                              */
/*          at row 04.61 col 56.30 colon-aligned */
    v_cod_estab_ini
         at row 05.61 col 18.00 colon-aligned label "Estab Inicial"
         help "C¢digo Estabelecimento"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_estini
         at row 05.61 col 22.30 colon-aligned 
    v_cod_estab_fim
         at row 05.61 col 44.00 colon-aligned label "Final"
         help "C¢digo Estabelecimento"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_estfim 
         at row 05.61 col 48.30 colon-aligned
    v_cod_unid_negoc_ini
         at row 06.61 col 18.00 colon-aligned label "UNeg Inicial"
         help "C¢digo Unidade Neg¢cio"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_unini
         at row 06.61 col 22.30 colon-aligned 
    v_cod_unid_negoc_fim
         at row 06.61 col 44.00 colon-aligned label "Final"
         help "C¢digo Unidade Neg¢cio"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_unfim
         at row 06.61 col 48.30 colon-aligned
    v_log_lote_ctbl
         at row 7.81 col 20.00 label "Lote Cont†bil"
         help "Pesquisa por Lote Cont†bil"
    v_num_lote_ctbl_ini
         at row 08.81 col 18.00 colon-aligned label "Lote Inicial"
         help "N£mero Lote Cont†bil"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_ltini
         at row 08.81 col 31.30 colon-aligned 
    v_num_lote_ctbl_fim
         at row 08.81 col 44.00 colon-aligned label "Final"
         help "N£mero Lote Cont†bil"
         view-as fill-in
         size-chars 13.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_ltfim
         at row 08.81 col 57.30 colon-aligned         
&endif         
    with 1 down side-labels no-validate keep-tab-order three-d 
         size-char 74.86 by 10.08 
         at row 04.54 col 02.00 no-box 
         font 1 fgcolor ? bgcolor 8. 
    assign rt_001:width-chars   in frame f_select = 72.72 
           rt_001:height-chars  in frame f_select = 09.54.


def frame f_log 
    rt_003 
         at row 01.38 col 02.00 
    v_log_analit
         at row 1.48 col 10.00 label "Gera Arq Anal°tico"
         help "Gera Arquivo Anal°tico" 
    v_log_cpart
         at row 2.48 col 10.00 label "Contra-partida"
         help "Apresenta Contra-partida"          
    v_log_print_par
         at row 3.48 col 10.00 label "Imprime ParÉmetros"
         help "Imprime ParÉmetros" 
    rt_001 
         at row 04.75 col 02.00 
    " Destino " view-as text 
         at row 04.45 col 04.00 bgcolor 8  
    rt_004 
         at row 08.00 col 02.00 
    " Execuá∆o " view-as text 
         at row 07.70 col 04.00 bgcolor 8  
    rs_destino 
         at row 05.25 col 03.00 no-label 
         bgcolor 8  
    v_arq_out 
         at row 06.25 col 03.00 no-label 
         view-as editor max-chars 250 no-word-wrap 
         size 40 by 1 
         bgcolor 15 font 2 
    bt_get_file 
         at row 06.25 col 43.29 font ? 
         help "Pesquisa Arquivo" 
    bt_set_printer
         at row 06.25 col 43.29 font ?
         help "Define Impressora e Layout de Impress∆o"
    rs_execucao 
         at row 08.50 col 03.00 no-label 
         bgcolor 8  
    with 1 down side-labels no-validate keep-tab-order three-d 
         size-char 49.43 by 08.83 
         at row 01.50 col 04.00 no-box 
         font 1 fgcolor ? bgcolor 8. 
    assign bt_get_file:width-chars     in frame f_log = 04.00 
           bt_get_file:height-chars    in frame f_log = 01.08 
           rt_001:width-chars          in frame f_log = 47.29 
           rt_001:height-chars         in frame f_log = 02.88 
           rt_003:width-chars          in frame f_log = 47.29 
           rt_003:height-chars         in frame f_log = 03.00 
           rt_004:width-chars          in frame f_log = 47.29 
           rt_004:height-chars         in frame f_log = 01.50. 
    assign v_arq_out:return-inserted in frame f_log = yes. 

on choose of bt_can2 in frame f_perc do:
   output stream s_1 close.
   if v_log_analit = yes then
      output stream s_plha close.
   hide frame f_perc no-pause.
   stop.
end.

on choose of bt_run in frame f_main do:
   assign v_log_run = yes.
end.

&if "{&window-system}" <> "TTY" &then 
ON MOUSE-SELECT-CLICK OF im_fld_page_1 IN FRAME f_main 
DO: 

    if im_fld_page_2:load-image('image/im-flddn') then.
    if im_fld_page_3:load-image('image/im-flddn') then.
    assign im_fld_page_2:height = 1 
           im_fld_page_2:row    = 1.55
           im_fld_page_3:height = 1 
           im_fld_page_3:row    = 1.55. 
    if  im_fld_page_1:load-image('image/im-fldup') then.
    assign im_fld_page_1:height = 1.20 
           im_fld_page_1:row    = 1.45. 
    hide frame f_log.
    hide frame f_select.
    view frame f_param.

END.

ON MOUSE-SELECT-CLICK OF im_fld_page_2 IN FRAME f_main DO: 

    if  im_fld_page_1:load-image('image/im-flddn') then.
    if  im_fld_page_3:load-image('image/im-flddn') then.
    assign im_fld_page_1:height = 1 
           im_fld_page_1:row    = 1.55. 
    assign im_fld_page_3:height = 1 
           im_fld_page_3:row    = 1.55.            
    if  im_fld_page_2:load-image('image/im-fldup') then.
    assign im_fld_page_2:height = 1.20 
           im_fld_page_2:row    = 1.45. 
    hide frame f_param.
    hide frame f_log.
    view frame f_select.
    apply "leave" to v_cod_plano_cta_ctbl in frame f_param.
    apply "leave" to v_cod_plano_ccusto   in frame f_param.
    apply "value-changed" to v_log_lote_ctbl in frame f_select.

END.

ON MOUSE-SELECT-CLICK OF im_fld_page_3 IN FRAME f_main 
DO: 

    if  im_fld_page_1:load-image('image/im-flddn') then.
    if  im_fld_page_2:load-image('image/im-flddn') then.
    assign im_fld_page_1:height = 1 
           im_fld_page_1:row    = 1.55
           im_fld_page_2:height = 1 
           im_fld_page_2:row    = 1.55.
    if  im_fld_page_3:load-image('image/im-fldup') then.
    assign im_fld_page_3:height = 1.20 
           im_fld_page_3:row    = 1.45. 
    hide frame f_param.
    hide frame f_select.    
    view frame f_log.

END.

/*--- Empresa ---*/
on leave of v_cod_empresa in frame f_param do:
   find emsuni.empresa no-lock
      where emsuni.empresa.cod_empresa = input frame f_param v_cod_empresa no-error.
   assign v_nom_abrev   = "".
   if avail emsuni.empresa then do:
      assign v_cod_empresa = emsuni.empresa.cod_empresa
             v_rec_empresa = recid(emsuni.empresa)
             v_nom_abrev   = emsuni.empresa.nom_abrev.
   end.
   disp v_nom_abrev with frame f_param.
end.

on choose of bt_zoo_emp in frame f_param 
or F5 of v_cod_empresa in frame f_param do:
    if  search("prgint/utb/utb069ka.r") = ? and search("prgint/utb/utb069ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb069ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb069ka.p.
    if  v_rec_empresa <> ? then do:
        find emsuni.empresa
          where recid(emsuni.empresa) = v_rec_empresa no-lock no-error.
        assign v_cod_empresa:screen-value in frame f_param = emsuni.empresa.cod_empresa.
        apply "leave" to v_cod_empresa in frame f_param.
        apply "entry" to v_cod_empresa in frame f_param.
    end.
end.

/*--- Cen†rio Ctbl ---*/
on leave of v_cod_cenar_ctbl in frame f_param do:
   find cenar_ctbl no-lock
      where cenar_ctbl.cod_cenar_ctbl = input frame f_param v_cod_cenar_ctbl no-error.
   if avail cenar_ctbl then do:
      assign v_cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
             v_rec_cenar_ctbl = recid(cenar_ctbl).
   end.
end.

on choose of bt_zoo_cenar in frame f_param 
or F5 of v_cod_cenar_ctbl in frame f_param do:
    if  search("prgint/utb/utb076ka.r") = ? and search("prgint/utb/utb076ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb076ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb076ka.p.
    if  v_rec_cenar_ctbl <> ? then do:
        find cenar_ctbl
          where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
        assign v_cod_cenar_ctbl:screen-value in frame f_param = cenar_ctbl.cod_cenar_ctbl.
        apply "leave" to v_cod_cenar_ctbl in frame f_param.
        apply "entry" to v_cod_cenar_ctbl in frame f_param.
    end.
end.

/*--- Finalidade Econìmica ---*/
on leave of v_cod_finalid_econ in frame f_param do:
   find finalid_econ no-lock
      where finalid_econ.cod_finalid_econ = input frame f_param v_cod_finalid_econ no-error.
   if avail finalid_econ then do:
      assign v_cod_finalid_econ = finalid_econ.cod_finalid_econ
             v_rec_finalid_econ = recid(finalid_econ).
   end.
end.

on choose of bt_zoo_finalid in frame f_param 
or F5 of v_cod_finalid_econ in frame f_param do:
    if  search("prgint/utb/utb077ka.r") = ? and search("prgint/utb/utb077ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb077ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb077ka.p.
    if  v_rec_finalid_econ <> ? then do:
        find finalid_econ
          where recid(finalid_econ) = v_rec_finalid_econ no-lock no-error.
        assign v_cod_finalid_econ:screen-value in frame f_param = finalid_econ.cod_finalid_econ.
        apply "leave" to v_cod_finalid_econ in frame f_param.
        apply "entry" to v_cod_finalid_econ in frame f_param.
    end.
end.

on leave of v_cod_plano_cta_ctbl in frame f_param do:
   find plano_cta_ctbl no-lock
      where plano_cta_ctbl.cod_plano_cta_ctbl = input frame f_param v_cod_plano_cta_ctbl no-error.
   if avail plano_cta_ctbl then do:
      assign v_cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
             v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
             v_des_plano_cta_ctbl  = plano_cta_ctbl.des_tit_ctbl
             v_rec_plano_cta_ctbl  = recid(plano_cta_ctbl).
/*       if v_cod_cta_ctbl_ini = "" then                                               */
/*          assign v_cod_cta_ctbl_ini    = fill ("0", length (v_cod_format_cta_ctbl))  */
/*                 v_cod_cta_ctbl_fim    = fill ("9", length (v_cod_format_cta_ctbl)). */
      assign v_cod_cta_ctbl_ini:format in frame f_select = v_cod_format_cta_ctbl
             v_cod_cta_ctbl_fim:format in frame f_select = v_cod_format_cta_ctbl
/*              bt_zoo_ctaini:col in frame f_select = 18 + length(v_cod_format_cta_ctbl) + 3.30 */
/*              bt_zoo_ctafim:col in frame f_select = 44 + length(v_cod_format_cta_ctbl) + 3.30 */
             v_cod_cta_ctbl_ini:visible in frame f_select = no
             v_cod_cta_ctbl_fim:visible in frame f_select = no
             v_cod_cta_ctbl_ini:visible in frame f_select = yes.
             v_cod_cta_ctbl_fim:visible in frame f_select = yes.
      display v_cod_cta_ctbl_ini
              v_cod_cta_ctbl_fim
              with frame f_select.
   end.
/*    else                                  */
/*        assign v_cod_plano_cta_ctbl  = "" */
/*               v_des_plano_cta_ctbl  = "" */
/*               v_cod_format_cta_ctbl = "" */
/*               v_cod_cta_ctbl_ini    = "" */
/*               v_cod_cta_ctbl_fim    = "" */
/*               v_rec_plano_cta_ctbl  = ?. */
   display v_des_plano_cta_ctbl
           with frame f_param.
              
end.

on choose of bt_zoo_plano_cta in frame f_param 
or F5 of v_cod_plano_cta_ctbl in frame f_param do:
    if  search("prgint/utb/utb080ka.r") = ? and search("prgint/utb/utb080ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb080ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb080ka.p.
    if  v_rec_plano_cta_ctbl <> ? then do:
        find plano_cta_ctbl
          where recid(plano_cta_ctbl) = v_rec_plano_cta_ctbl no-lock no-error.
        assign v_cod_plano_cta_ctbl:screen-value in frame f_param = plano_cta_ctbl.cod_plano_cta_ctbl.
        apply "leave" to v_cod_plano_cta_ctbl in frame f_param.
        apply "entry" to v_cod_plano_cta_ctbl in frame f_param.
    end.
end.

on leave of v_cod_plano_ccusto in frame f_param do:

   find plano_ccusto no-lock
      where plano_ccusto.cod_empresa      = input frame f_param v_cod_empresa
        and plano_ccusto.cod_plano_ccusto = input frame f_param v_cod_plano_ccusto no-error.
   if avail plano_ccusto then do:
      assign v_cod_plano_ccusto  = plano_ccusto.cod_plano_ccusto
             v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
             v_des_plano_ccusto  = plano_ccusto.des_tit_ctbl
             v_rec_plano_ccusto  = recid(plano_ccusto).
      if v_cod_ccusto_ini = "" then 
         assign v_cod_ccusto_ini    = v_cod_ccusto_ini
                v_cod_ccusto_fim    = v_cod_ccusto_final.
      assign v_cod_ccusto_ini:format in frame f_select = v_cod_format_ccusto
             v_cod_ccusto_fim:format in frame f_select = v_cod_format_ccusto
/*              bt_zoo_ccini:col in frame f_select = 18 + length(v_cod_format_ccusto) + 3.30 */
/*              bt_zoo_ccfim:col in frame f_select = 44 + length(v_cod_format_ccusto) + 3.30 */
             v_cod_ccusto_ini:visible in frame f_select = no
             v_cod_ccusto_fim:visible in frame f_select = no
             v_cod_ccusto_ini:visible in frame f_select = yes
             v_cod_ccusto_fim:visible in frame f_select = yes.
      display v_cod_ccusto_ini
              v_cod_ccusto_fim
              with frame f_select.
   end.
   else
       assign v_cod_plano_ccusto  = ""
              v_cod_format_ccusto = ""
              v_des_plano_ccusto  = ""
              v_rec_plano_ccusto  = ?.
   display v_des_plano_ccusto
           with frame f_param.

end.

on choose of bt_zoo_plano_cc in frame f_param
or F5 of v_cod_plano_ccusto in frame f_param do:

    if  search("prgint/utb/utb083ka.r") = ? and search("prgint/utb/utb083ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb083ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb083ka.p.
    if  v_rec_plano_ccusto <> ? then do:
        find plano_ccusto
          where recid(plano_ccusto) = v_rec_plano_ccusto no-lock no-error.
        assign v_cod_plano_ccusto:screen-value in frame f_param = plano_ccusto.cod_plano_ccusto.
        apply "leave" to v_cod_plano_ccusto in frame f_param.
        apply "entry" to v_cod_plano_ccusto in frame f_param.
    end.
    
end.

/*--- Cta Pat Ini ---*/
/* on leave of v_cod_cta_ctbl_ini in frame f_select do:                                        */
/*    find cta_ctbl no-lock                                                                    */
/*       where cta_ctbl.cod_plano_cta_ctbl = input frame f_param v_cod_plano_cta_ctbl          */
/*         and cta_ctbl.cod_cta_ctbl       = input frame f_select v_cod_cta_ctbl_ini no-error. */
/*    if avail cta_ctbl then do:                                                               */
/*       assign v_cod_cta_ctbl_ini = cta_ctbl.cod_cta_ctbl                                     */
/*              v_rec_cta_ctbl     = recid(cta_ctbl).                                          */
/*    end.                                                                                     */
/* end.                                                                                        */
/*                                                                                             */
/* on choose of bt_zoo_ctaini in frame f_select                                                 */
/* or F5 of v_cod_cta_ctbl_ini in frame f_select do:                                            */
/*     if  search("prgint/utb/utb080ne.r") = ? and search("prgint/utb/utb080ne.p") = ? then do: */
/*         message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb080ne.p"          */
/*                view-as alert-box error buttons ok.                                           */
/*         return.                                                                              */
/*     end.                                                                                     */
/*     else                                                                                     */
/*         run prgint/utb/utb080ne.p.                                                           */
/*     if  v_rec_cta_ctbl <> ? then do:                                                         */
/*         find cta_ctbl                                                                        */
/*           where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.                           */
/*         assign v_cod_cta_ctbl_ini:screen-value in frame f_select = cta_ctbl.cod_cta_ctbl.    */
/*         apply "entry" to v_cod_cta_ctbl_ini in frame f_select.                               */
/*     end.                                                                                     */
/* end.                                                                                         */

/* /*--- Cta Pat Fim ---*/                                                                     */
/* on leave of v_cod_cta_ctbl_fim in frame f_select do:                                        */
/*    find cta_ctbl no-lock                                                                    */
/*       where cta_ctbl.cod_plano_cta_ctbl = input frame f_param v_cod_plano_cta_ctbl          */
/*         and cta_ctbl.cod_cta_ctbl       = input frame f_select v_cod_cta_ctbl_fim no-error. */
/*    if avail cta_ctbl then do:                                                               */
/*       assign v_cod_cta_ctbl_fim = cta_ctbl.cod_cta_ctbl                                     */
/*              v_rec_cta_ctbl     = recid(cta_ctbl).                                          */
/*    end.                                                                                     */
/* end.                                                                                        */

/* on choose of bt_zoo_ctafim in frame f_select                                                 */
/* or F5 of v_cod_cta_ctbl_fim in frame f_select do:                                            */
/*     if  search("prgint/utb/utb080ne.r") = ? and search("prgint/utb/utb080ne.p") = ? then do: */
/*         message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb080ne.p"          */
/*                view-as alert-box error buttons ok.                                           */
/*         return.                                                                              */
/*     end.                                                                                     */
/*     else                                                                                     */
/*         run prgint/utb/utb080ne.p.                                                           */
/*     if  v_rec_cta_ctbl <> ? then do:                                                         */
/*         find cta_ctbl                                                                        */
/*            where recid(cta_ctbl) = v_rec_cta_ctbl no-lock no-error.                          */
/*         assign v_cod_cta_ctbl_fim:screen-value in frame f_select = cta_ctbl.cod_cta_ctbl.    */
/*         apply "entry" to v_cod_cta_ctbl_fim in frame f_select.                               */
/*     end.                                                                                     */
/* end.                                                                                         */

/*--- Ccusto Ini ---*/
on leave of v_cod_ccusto_ini in frame f_select do:
   find emsuni.ccusto no-lock
      where emsuni.ccusto.cod_empresa      = input frame f_param v_cod_empresa
        and emsuni.ccusto.cod_plano_ccusto = input frame f_param v_cod_plano_ccusto 
        and emsuni.ccusto.cod_ccusto       = input frame f_select v_cod_ccusto_ini no-error.
   if avail ccusto then do:
      assign v_cod_ccusto_ini = emsuni.ccusto.cod_ccusto
             v_rec_ccusto     = recid(ccusto).
   end.
end.

/* on choose of bt_zoo_ccini in frame f_select                                                  */
/* or F5 of v_cod_ccusto_ini in frame f_select do:                                              */
/*     if  search("prgint/utb/utb066ka.r") = ? and search("prgint/utb/utb066ka.p") = ? then do: */
/*         message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb066ka.p"          */
/*                view-as alert-box error buttons ok.                                           */
/*         return.                                                                              */
/*     end.                                                                                     */
/*     else                                                                                     */
/*         run prgint/utb/utb066ka.p.                                                           */
/*     if  v_rec_ccusto <> ? then do:                                                           */
/*         find emsuni.ccusto                                                                   */
/*            where recid (ccusto) = v_rec_ccusto no-lock no-error.                             */
/*         assign v_cod_ccusto_ini:screen-value in frame f_select = emsuni.ccusto.cod_ccusto.   */
/*         apply "entry" to v_cod_ccusto_ini in frame f_select.                                 */
/*     end.                                                                                     */
/* end.                                                                                         */

/*--- Ccusto Fim ---*/
on leave of v_cod_ccusto_fim in frame f_select do:
   find emsuni.ccusto no-lock
      where emsuni.ccusto.cod_empresa      = input frame f_param v_cod_empresa
        and emsuni.ccusto.cod_plano_ccusto = input frame f_param v_cod_plano_ccusto 
        and emsuni.ccusto.cod_ccusto       = input frame f_select v_cod_ccusto_fim no-error.
   if avail ccusto then do:
      assign v_cod_ccusto_fim = emsuni.ccusto.cod_ccusto
             v_rec_ccusto     = recid(ccusto).
   end.
end.

/* on choose of bt_zoo_ccfim in frame f_select                                                  */
/* or F5 of v_cod_ccusto_fim in frame f_select do:                                              */
/*     if  search("prgint/utb/utb066ka.r") = ? and search("prgint/utb/utb066ka.p") = ? then do: */
/*         message "Programa execut†vel n∆o foi encontrado: "  "prgint/utb/utb066ka.p"          */
/*                view-as alert-box error buttons ok.                                           */
/*         return.                                                                              */
/*     end.                                                                                     */
/*     else                                                                                     */
/*         run prgint/utb/utb066ka.p.                                                           */
/*     if  v_rec_ccusto <> ? then do:                                                           */
/*         find emsuni.ccusto                                                                   */
/*            where recid (ccusto) = v_rec_ccusto no-lock no-error.                             */
/*         assign v_cod_ccusto_fim:screen-value in frame f_select = emsuni.ccusto.cod_ccusto.   */
/*         apply "entry" to v_cod_ccusto_fim in frame f_select.                                 */
/*     end.                                                                                     */
/* end.                                                                                         */

/*--- Estabelecimento Inicial ---*/
on leave of v_cod_estab_ini in frame f_select do:
   find estabelecimento no-lock
      where estabelecimento.cod_estab = input frame f_select v_cod_estab_ini no-error.
   if avail estabelecimento then do:
      assign v_cod_estab_fim = estabelecimento.cod_estab             
             v_rec_estabelecimento = recid (estabelecimento).
   end.
end.

on choose of bt_zoo_estini in frame f_select
or F5 of v_cod_estab_ini in frame f_select do:
    if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb071na.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb071na.p (input v_cod_empresa).
    if v_rec_estabelecimento <> ? then do:
        find estabelecimento
           where recid (estabelecimento) = v_rec_estabelecimento no-lock no-error.
        assign v_cod_estab_ini:screen-value in frame f_select = estabelecimento.cod_estab.
        apply "leave" to v_cod_estab_ini in frame f_select.
        apply "entry" to v_cod_estab_ini in frame f_select.
    end.
end.

/*--- Estabelecimento Final ---*/
on leave of v_cod_estab_fim in frame f_select do:
   find estabelecimento no-lock
      where estabelecimento.cod_estab = input frame f_select v_cod_estab_fim no-error.
   if avail estabelecimento then do:
      assign v_cod_estab_fim       = estabelecimento.cod_estab
             v_rec_estabelecimento = recid (estabelecimento).
   end.
end.

on choose of bt_zoo_estfim in frame f_select
or F5 of v_cod_estab_fim in frame f_select do:
    if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb071na.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb071na.p (input v_cod_empresa).
    if  v_rec_estabelecimento <> ? then do:
        find estabelecimento
           where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
        assign v_cod_estab_fim:screen-value in frame f_select = estabelecimento.cod_estab.
        apply "leave" to v_cod_estab_fim in frame f_select.
        apply "entry" to v_cod_estab_fim in frame f_select.
    end.
end.

/*--- Unidade de Neg¢cio Inicial ---*/
on leave of v_cod_unid_negoc_ini in frame f_select do:
   find emscad.unid_negoc no-lock
      where unid_negoc.cod_unid_negoc = input frame f_select v_cod_unid_negoc_ini no-error.
   if avail unid_negoc then do:
      assign v_cod_unid_negoc_ini = unid_negoc.cod_unid_negoc
             v_rec_unid_negoc     = recid (unid_negoc).
   end.
end.

on choose of bt_zoo_unini in frame f_select 
or F5 of v_cod_unid_negoc_ini in frame f_select do:
    if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb011ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb011ka.p.
    if  v_rec_unid_negoc <> ? then do:
        find emscad.unid_negoc
           where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign v_cod_unid_negoc_ini:screen-value in frame f_select = unid_negoc.cod_unid_negoc.
        apply "leave" to v_cod_unid_negoc_ini in frame f_select.
        apply "entry" to v_cod_unid_negoc_ini in frame f_select.
    end.
end.

/*--- Unidade de Neg¢cio Final ---*/
on leave of v_cod_unid_negoc_fim in frame f_select do:
   find emscad.unid_negoc no-lock
      where unid_negoc.cod_unid_negoc = input frame f_select v_cod_unid_negoc_fim no-error.
   if avail unid_negoc then do:
      assign v_cod_unid_negoc_fim = unid_negoc.cod_unid_negoc
             v_rec_unid_negoc     = recid (unid_negoc).
   end.
end.

on choose of bt_zoo_unfim in frame f_select
or F5 of v_cod_unid_negoc_fim in frame f_select do:
   if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
       message "Programa execut†vel n∆o foi encontrado:"  "prgint/utb/utb011ka.p"
              view-as alert-box error buttons ok.
       return.
   end.
   else
       run prgint/utb/utb011ka.p.
   if  v_rec_unid_negoc <> ? then do:
       find emscad.unid_negoc
          where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
       assign v_cod_unid_negoc_fim:screen-value in frame f_select = unid_negoc.cod_unid_negoc.
       apply "leave" to v_cod_unid_negoc_fim in frame f_select.
       apply "entry" to v_cod_unid_negoc_fim in frame f_select.
   end.
end.

/*--- Lote Ctbl Inicial ---*/
on leave of v_num_lote_ctbl_ini in frame f_select do:
   find lote_ctbl no-lock
      where lote_ctbl.num_lote_ctbl = input frame f_select v_num_lote_ctbl_ini no-error.
   if avail lote_ctbl then do:
      assign v_num_lote_ctbl_ini = lote_ctbl.num_lote_ctbl
             v_rec_lote_ctbl     = recid (lote_ctbl).
   end.
end.

on choose of bt_zoo_ltini in frame f_select
or F5 of v_num_lote_ctbl_ini in frame f_select do:
    if  search("prgfin/fgl/fgl724na.r") = ? and search("prgfin/fgl/fgl724na.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgfin/fgl/fgl724na.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgfin/fgl/fgl724na.p (input ?,
                                   input "Ctbz",
                                   input ?).
    if  v_rec_lote_ctbl <> ? then do:
        find lote_ctbl
           where recid (lote_ctbl) = v_rec_lote_ctbl no-lock no-error.
        assign v_num_lote_ctbl_ini:screen-value in frame f_select = string (lote_ctbl.num_lote_ctbl).
        apply "leave" to v_num_lote_ctbl_ini in frame f_select.
        apply "entry" to v_num_lote_ctbl_ini in frame f_select.
    end.
end.

/*--- Lote Ctbl Final ---*/
on leave of v_num_lote_ctbl_fim in frame f_select do:
   find lote_ctbl no-lock
      where lote_ctbl.num_lote_ctbl = input frame f_select v_num_lote_ctbl_fim no-error.
   if avail lote_ctbl then do:
      assign v_num_lote_ctbl_fim = lote_ctbl.num_lote_ctbl
             v_rec_lote_ctbl     = recid (lote_ctbl).
   end.
end.

on choose of bt_zoo_ltfim in frame f_select
or F5 of v_num_lote_ctbl_fim in frame f_select do:
    if search("prgfin/fgl/fgl724na.r") = ? and search("prgfin/fgl/fgl724na.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:"  "prgfin/fgl/fgl724na.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgfin/fgl/fgl724na.p (input ?,
                                   input "Ctbz",
                                   input ?).
    if v_rec_lote_ctbl <> ? then do:
        find lote_ctbl
           where recid (lote_ctbl) = v_rec_lote_ctbl no-lock no-error.
        assign v_num_lote_ctbl_fim:screen-value in frame f_select = string (lote_ctbl.num_lote_ctbl).
        apply "leave" to v_num_lote_ctbl_fim in frame f_select.
        apply "entry" to v_num_lote_ctbl_fim in frame f_select.
    end.
end.

on value-changed of v_log_lote_ctbl in frame f_select do:

   assign input frame f_select v_log_lote_ctbl.
   if v_log_lote_ctbl = yes then do:
       enable v_num_lote_ctbl_ini
              bt_zoo_ltini
              v_num_lote_ctbl_fim
              bt_zoo_ltfim
              with frame f_select.
       assign v_num_lote_ctbl_ini:sensitive in frame f_select = yes
              v_num_lote_ctbl_fim:sensitive in frame f_select = yes
              bt_zoo_ltini:sensitive in frame f_select = yes
              bt_zoo_ltfim:sensitive in frame f_select = yes.              
   end.
   else do:
       assign v_num_lote_ctbl_ini:sensitive in frame f_select = no
              v_num_lote_ctbl_fim:sensitive in frame f_select = no
              bt_zoo_ltini:sensitive in frame f_select = no
              bt_zoo_ltfim:sensitive in frame f_select = no.
       disable v_num_lote_ctbl_ini
               bt_zoo_ltini
               v_num_lote_ctbl_fim
               bt_zoo_ltfim
               with frame f_select.              
   end.

end.

on value-changed of rs_destino in frame f_log do:

  if input frame f_log rs_destino = 1 then do:
     assign bt_get_file:visible  in frame f_log = no
            bt_set_printer:visible in frame f_log = yes
            v_arq_out:visible   in frame f_log = yes
            v_arq_out:sensitive in frame f_log = no.
     if v_des_impressor = "" then do:
        find first imprsor_usuar no-lock
           where imprsor_usuar.cod_usuario = v_cod_usuar_corren
             use-index imprsrsr_id no-error.
        if avail imprsor_usuar then do:
           find first layout_impres no-lock
              where layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
           if avail layout_impres then
               assign v_arq_out:screen-value in frame f_log = imprsor_usuar.nom_impressora 
                                                            + ":" + layout_impres.cod_layout_impres
                      v_des_impressor                          = imprsor_usuar.nom_impressora
                      v_des_layout                             = layout_impres.cod_layout_impres.
         end.
     end.
     else
         assign v_arq_out:screen-value in frame f_log = v_des_impressor + ":" + v_des_layout.
  end.
  if input frame f_log rs_destino = 2 then do:
     assign bt_get_file:visible    in frame f_log = yes
            bt_set_printer:visible in frame f_log = no
            v_arq_out:visible      in frame f_log = yes             
            v_arq_out:sensitive    in frame f_log = yes.
     if input frame f_log rs_execucao = 1 then         
         if avail dwb_set_list_param and dwb_set_list_param.cod_dwb_file <> "" then
             assign v_arq_out:screen-value in frame f_log = dwb_set_list_param.cod_dwb_file.
         else
             assign v_arq_out:screen-value in frame f_log = session:temp-directory + "esfgl03a" + '.csv'.
     else
         if avail dwb_set_list_param and dwb_set_list_param.cod_dwb_file <> "" then
             assign v_arq_out:screen-value in frame f_log = dwb_set_list_param.cod_dwb_file.
         else     
             assign v_arq_out:screen-value in frame f_log = "esfgl03a.csv".
  end.
  if input frame f_log rs_destino = 3 then
     assign bt_get_file:visible    in frame f_log = no
            bt_set_printer:visible in frame f_log = no
            v_arq_out:visible      in frame f_log = no.

end.

on value-changed of rs_execucao in frame f_log do:

   find current dwb_set_list_param exclusive-lock no-error.
   assign dwb_set_list_param.cod_dwb_file = ""
          rs_execucao
          v_arq_out = "".
   if rs_execucao = 2 then do:      
      if  rs_destino:disable("Terminal") in frame f_log then do:
      end.
   end.
   else do:
       if  rs_destino:enable("Terminal") in frame f_log then do:
       end.
   end.
   apply "value-changed" to rs_destino in frame f_log.

end.


on choose of bt_get_file in frame f_log do:

   def var v_arq_conv  as char no-undo.
   def var v_log_ok    as log init no.

   SYSTEM-DIALOG GET-FILE v_arq_conv
        FILTERS "*.lst" "*.lst",
                "*.txt" "*.txt",
                "*.*" "*.*"
        ASK-OVERWRITE 
        DEFAULT-EXTENSION "lst"
        INITIAL-DIR "c:\temp" 
        USE-FILENAME
        UPDATE v_log_ok.
   if v_log_ok = yes then do:
      assign v_arq_out = v_arq_conv.
      display v_arq_out with frame f_log.
   end.

end.

on choose of bt_set_printer in frame f_log do:

   assign v_arq_aux = v_arq_out:screen-value in frame f_log.
   run prgtec/btb/btb036nb.p (output v_des_impressor, output v_des_layout).
   if v_arq_out <> ":" then do:
      assign v_arq_out = v_des_impressor + ":" + v_des_layout.
   end.
   else do:
      assign v_arq_out = v_arq_aux.
   end.
   disp v_arq_out with frame f_log.

end.
&endif

assign frame f_log:frame    = frame f_main:handle 
       frame f_log:row      = 2.7 
       frame f_log:col      = 2.5 
       frame f_select:frame = frame f_main:handle 
       frame f_select:row   = 2.7 
       frame f_select:col   = 2.5 
       frame f_param:frame  = frame f_main:handle 
       frame f_param:row    = 2.7 
       frame f_param:col    = 2.5. 

run pi_return_user (output v_cod_dwb_user).

/*--- Execuá∆o RPW ---*/
if v_num_ped_exec_corren <> 0 then do:
   run pi_dwb_rpt_param.
   /*--- Impress∆o Raz∆o Cont†bil ---*/
   run pi_esp_aprop_ctbl_impr.
end.
else do:
    pause 0 before-hide.
    assign v_wgh_focus = v_cod_empresa:handle in frame f_param.
    /*--- Recupera os parÉmetros ---*/
    run pi_dwb_rpt_param.
    /*--- Valores Iniciais ---*/
    if not avail dwb_set_list_param then do:
       run pi_inic_param.
    end.
    assign v_log_cpart = no.
    main_block:
    repeat on endkey undo main_block, leave main_block
       on stop undo main_block, retry main_block
       on error undo main_block, retry main_block with frame f_main:
       assign v_log_run = no.
       enable all with frame f_main.
       enable all except v_log_cpart with frame f_log.
       enable all with frame f_select.
       enable all with frame f_param.

       find emscad.empresa no-lock
           where RECID(empresa) = v_rec_empresa_1 NO-ERROR.
           
                 
       ASSIGN V_COD_CTA_CTBL_INI = V_COD_cTA_CTBL_INICIAL
              V_COD_CTA_CTBL_FIM = V_COD_CTA_CTBL_FINAL
              v_cod_ccusto_ini   = V_COD_CCUSTO
              v_cod_ccusto_fim   = V_COD_CCUSTO_FINAL
              v_dat_fim_period_ctbl = v_dat_movto_fim
              v_dat_inic_period_ctbl = v_dat_movto
              v_cod_empresa = empresa.cod_empresa
              v_nom_abrev = empresa.nom_abrev.


       display v_cod_empresa v_nom_abrev 
               v_cod_cenar_ctbl v_des_cenar_ctbl
               v_cod_finalid_econ v_des_finalid_econ
               v_cod_plano_cta_ctbl v_des_plano_cta_ctbl
               v_cod_plano_ccusto v_des_plano_ccusto
               with frame f_param.
       display v_dat_inic_period_ctbl v_dat_fim_period_ctbl
               v_cod_cta_ctbl_ini v_cod_cta_ctbl_fim
               v_cod_ccusto_ini v_cod_ccusto_fim
               v_cod_estab_ini v_cod_estab_fim
               v_cod_unid_negoc_ini v_cod_unid_negoc_fim
               v_log_lote_ctbl
               v_num_lote_ctbl_ini v_num_lote_ctbl_fim
               with frame f_select.
       display v_log_analit
               v_log_cpart
               v_log_print_par
               rs_destino
               rs_execucao
               v_arq_out
               with frame f_log.
       disable v_nom_abrev
               v_des_cenar_ctbl
               v_des_finalid_econ
               v_des_plano_cta_ctbl
               v_des_plano_ccusto
               with frame f_param.
        

       RUN pi_justificativa.
       IF v_rec_period_ctbl_ini <> ? THEN DO:

FIND FIRST period_ctbl NO-LOCK WHERE RECID(period_ctbl) = v_rec_period_ctbl_ini NO-ERROR.



IF AVAIL period_ctbl THEN

ASSIGN v_dat_inic_period_ctbl:SCREEN-VALUE IN FRAME f_select = string(period_ctbl.dat_inic_period_ctbl)
       v_dat_fim_period_ctbl:SCREEN-VALUE IN FRAME f_select  = string(period_ctbl.dat_fim_period_ctbl)
       v_dat_inic_period_ctbl:SENSITIVE = NO
       v_dat_fim_period_ctbl:SENSITIVE = NO.


END.

       
       
       apply "value-changed" to rs_destino in frame f_log.
       &if "{&window-system}" <> "TTY" &then 
       apply "MOUSE-SELECT-CLICK" to im_fld_page_1 in frame f_main.
       &endif
       apply "entry" to v_wgh_focus.
       
       if valid-handle(v_wgh_focus) then do:
          wait-for go of frame f_main focus v_wgh_focus.
       end.
       else do:
           wait-for go of frame f_main.
       end.
       
       ASSIGN v_arq_out = replace(v_arq_out,"txt","csv"). 
       assign input frame f_param v_cod_empresa
              input frame f_param v_cod_cenar_ctbl
              input frame f_param v_cod_finalid_econ
              input frame f_param v_cod_plano_cta_ctbl
              input frame f_param v_cod_plano_ccusto
              input frame f_select v_dat_inic_period_ctbl
              input frame f_select v_dat_fim_period_ctbl
              input frame f_select v_cod_cta_ctbl_ini
              input frame f_select v_cod_cta_ctbl_fim
              input frame f_select v_cod_ccusto_ini
              input frame f_select v_cod_ccusto_fim              
              input frame f_select v_cod_estab_ini
              input frame f_select v_cod_estab_fim
              input frame f_select v_cod_unid_negoc_ini
              input frame f_select v_cod_unid_negoc_fim
              input frame f_select v_log_lote_ctbl
              input frame f_select v_num_lote_ctbl_ini
              input frame f_select v_num_lote_ctbl_fim              
              input frame f_log v_log_analit
              input frame f_log v_log_cpart
              input frame f_log v_log_print_par
              input frame f_log rs_destino
              input frame f_log rs_execucao
              input frame f_log v_arq_out.


       /*--- Valida Valores ---*/
       
       run pi_vld_param.
       
       run pi_salva_param.
       if v_log_run = yes then do:
           
           if rs_execucao:screen-value in frame f_log = "2" then do:    
             RUN prgtec/btb/btb911za.p (input  "esp_aprop_ctbl_impr",
                                        input  "1.03.00.000",
                                        input  0,
                                        input  recid(dwb_set_list_param),
                                        output v_num_ped_exec_rpw).
             
             if v_num_ped_exec_rpw <> 0 then do:
                run pi_message  (input "show",
                                 input 3556,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       v_num_ped_exec_rpw)).
                find current dwb_set_list_param no-lock no-error.
             end.
            
          end.
          else do:
              
             if session:set-wait-state("general") then.
             
             /*--- Recupera os parÉmetros ---*/
             run pi_dwb_rpt_param.


             /*--- Impress∆o Raz∆o Cont†bil ---*/
            
             run pi_esp_aprop_ctbl_impr.
             if session:set-wait-state("") then.
             
          end.
       end.
       else do: 
           hide frame f_log no-pause.
           hide frame f_param no-pause.
           hide frame f_main no-pause.
           return.
       end.
       
    end.
end.



procedure pi_inic_param:

   find emsuni.empresa no-lock
      where emsuni.empresa.cod_empresa = v_cod_empres_usuar no-error.
   if avail emsuni.empresa then do:
      assign v_cod_empresa = emsuni.empresa.cod_empresa
             v_nom_abrev   = emsuni.empresa.nom_abrev
             v_rec_empresa = recid (emsuni.empresa).
   end.
   find cenar_ctbl no-lock 
      where cenar_ctbl.cod_cenar_ctbl = "Fiscal" no-error.
   if avail cenar_ctbl then do:
      assign v_cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
             v_des_cenar_ctbl = cenar_ctbl.des_cenar_ctbl
             v_rec_cenar_ctbl = recid (cenar_ctbl).
   end.
   find finalid_econ no-lock
      where finalid_econ.cod_finalid_econ = "Corrente" no-error.
   if avail finalid_econ then do:
      assign v_cod_finalid_econ = finalid_econ.cod_finalid_econ
             v_des_finalid_econ = finalid_econ.des_finalid_econ
             v_rec_finalid_econ = recid (finalid_econ).
   end.
   find last plano_cta_unid_organ no-lock
      where plano_cta_unid_organ.cod_unid_organ         = v_cod_empresa
        and plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim†rio" no-error.
   if avail plano_cta_unid_organ then 
      assign v_cod_plano_cta_ctbl = plano_cta_unid_organ.cod_plano_cta_ctbl.

end.

procedure pi_vld_param:

   find emsuni.empresa no-lock
      where empresa.cod_empresa = v_cod_empresa no-error.
   if not avail empresa then do:
       assign v_wgh_focus = v_cod_empresa:handle in frame f_param.
       message "Empresa inexistente!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   find cenar_ctbl no-lock 
      where cenar_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl no-error.
   if not avail cenar_ctbl then do:
       assign v_wgh_focus = v_cod_cenar_ctbl:handle in frame f_param.
       message "Cen†rio Cont†bil inexistente!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   find finalid_econ no-lock
      where finalid_econ.cod_finalid_econ = v_cod_finalid_econ no-error.
   if not avail finalid_econ then do:
       assign v_wgh_focus = v_cod_finalid_econ:handle in frame f_param.
       message "Finalidade Econìmica inexistente!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   find plano_cta_ctbl no-lock 
      where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-error.
   if not avail plano_cta_ctbl then do:
       assign v_wgh_focus = v_cod_plano_cta_ctbl:handle in frame f_param.
       message "Plano de Contas Cont†beis inexistente!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   find plano_ccusto no-lock 
      where plano_ccusto.cod_empresa      = v_cod_empresa
        and plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto no-error.
   if not avail plano_ccusto then do:
       assign v_wgh_focus = v_cod_plano_ccusto:handle in frame f_param.
       message "Plano de Centros de Custos inexistente!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_dat_inic_period_ctbl > v_dat_fim_period_ctbl then do:
       assign v_wgh_focus = v_dat_inic_period_ctbl:handle in frame f_select.
       message "Data Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_cod_cta_ctbl_ini > v_cod_cta_ctbl_fim then do:
       assign v_wgh_focus = v_cod_cta_ctbl_ini:handle in frame f_select.
       message "Conta Ctbl Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_cod_ccusto_ini > v_cod_ccusto_fim then do:
       assign v_wgh_focus = v_cod_ccusto_ini:handle in frame f_select.
       message "Centro de Custo Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_cod_estab_ini > v_cod_estab_fim then do:
       assign v_wgh_focus = v_cod_estab_ini:handle in frame f_select.
       message "Estabelecimento Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_cod_unid_negoc_ini > v_cod_unid_negoc_fim then do:
       assign v_wgh_focus = v_cod_unid_negoc_ini:handle in frame f_select.
       message "Unidade de Neg¢cio Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
       return error.
   end.
   if v_log_lote_ctbl = yes then do:
       if v_num_lote_ctbl_ini > v_num_lote_ctbl_fim then do:
           assign v_wgh_focus = v_num_lote_ctbl_ini:handle in frame f_select.
           message "Centro de Custo Inicial maior que Final!" view-as ALERT-BOX INFORMATION.
           return error.
       end.
   end.   

end.

procedure pi_salva_param:

    /* verfica controles do EMS 5 e dispara login se necess†rio */
    run prgtec/btb/btb906za.p.
    if rs_destino = 2 and rs_execucao = 2 then do:
        do while index(v_arq_out,"~/") <> 0: 
            assign v_arq_out = substring(v_arq_out,(index(v_arq_out,"~/" ) + 1)).
        end. 
    end.
    /* Recuperar parÉmetros da £ltima execuá∆o */
    do transaction:
        find dwb_set_list_param exclusive-lock
            where dwb_set_list_param.cod_dwb_program = "esp_aprop_ctbl_impr"
              and dwb_set_list_param.cod_dwb_user    = v_cod_dwb_user no-error.
        if  not avail dwb_set_list_param then do:
            create dwb_set_list_param.
            assign dwb_set_list_param.cod_dwb_program = "esp_aprop_ctbl_impr"
                   dwb_set_list_param.cod_dwb_user    = v_cod_dwb_user.
        end.
        assign dwb_set_list_param.cod_dwb_file              = v_arq_out
               dwb_set_list_param.nom_dwb_printer           = v_des_impressor
               dwb_set_list_param.cod_dwb_print_layout      = v_des_layout
               dwb_set_list_param.log_dwb_print_parameters  = v_log_print_par               
               dwb_set_list_param.cod_dwb_output            = if rs_destino = 1 then "Impressora"
                                                                        else if rs_destino = 2 then "Arquivo"
                                                                           else if rs_destino = 3 then "Terminal"
                                                                              else "arquivo"
               dwb_set_list_param.cod_dwb_parameters        = v_cod_empresa                + chr(10) 
                                                                   + v_cod_cenar_ctbl             + chr(10)
                                                                   + v_cod_finalid_econ           + chr(10)
                                                                   + v_cod_plano_cta_ctbl         + chr(10)
                                                                   + string (v_dat_inic_period_ctbl) + chr(10)
                                                                   + string (v_dat_fim_period_ctbl)  + chr(10)
                                                                   + v_cod_cta_ctbl_ini           + chr(10)
                                                                   + v_cod_cta_ctbl_fim           + chr(10)
                                                                   + v_cod_estab_ini              + chr(10)
                                                                   + v_cod_estab_fim              + chr(10)
                                                                   + v_cod_unid_negoc_ini         + chr(10)
                                                                   + v_cod_unid_negoc_fim         + chr(10)
                                                                   + string (v_log_analit)        + chr(10)
                                                                   + string (rs_execucao)         + chr(10)
                                                                   + v_cod_plano_ccusto           + chr(10)
                                                                   + v_cod_ccusto_ini             + chr(10)
                                                                   + v_cod_ccusto_fim             + chr(10)
                                                                   + string (v_log_lote_ctbl)     + chr(10)
                                                                   + string (v_num_lote_ctbl_ini) + chr(10)
                                                                   + string (v_num_lote_ctbl_fim) + chr(10)
                                                                   + string (v_log_cpart).
    end.

end.

procedure pi_dwb_rpt_param:

   if v_num_ped_exec_corren = 0 then do:
      find dwb_set_list_param no-lock
         where dwb_set_list_param.cod_dwb_program = "esp_aprop_ctbl_impr"
           and dwb_set_list_param.cod_dwb_user    = v_cod_dwb_user
         use-index dwbstlsa_id no-error.
      if avail dwb_set_list_param then do:
         assign v_cod_empresa        = entry (01, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_cenar_ctbl     = entry (02, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_finalid_econ   = entry (03, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_plano_cta_ctbl = entry (04, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_dat_inic_period_ctbl = date (entry (05, dwb_set_list_param.cod_dwb_parameters, chr(10)))
                v_dat_fim_period_ctbl  = date (entry (06, dwb_set_list_param.cod_dwb_parameters, chr(10)))
                v_cod_cta_ctbl_ini   = entry (07, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_cta_ctbl_fim   = entry (08, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_estab_ini      = entry (09, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_estab_fim      = entry (10, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_unid_negoc_ini = entry (11, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_cod_unid_negoc_fim = entry (12, dwb_set_list_param.cod_dwb_parameters, chr(10))
                v_log_analit         = (entry (13, dwb_set_list_param.cod_dwb_parameters, chr(10)) = 'yes')
                rs_execucao          = int (entry (14, dwb_set_list_param.cod_dwb_parameters, chr(10)))
                v_log_print_par      = dwb_set_list_param.log_dwb_print_parameters
                v_des_impressor      = dwb_set_list_param.nom_dwb_printer
                v_des_layout         = dwb_set_list_param.cod_dwb_print_layout
                v_cod_dwb_output     = dwb_set_list_param.cod_dwb_output
                v_arq_out            = dwb_set_list_param.cod_dwb_file.
          if  num-entries (dwb_set_list_param.cod_dwb_parameters, chr(10)) >= 15 then
              assign v_cod_plano_ccusto   = entry (15, dwb_set_list_param.cod_dwb_parameters, chr(10))
                     v_cod_ccusto_ini     = entry (16, dwb_set_list_param.cod_dwb_parameters, chr(10))
                     v_cod_ccusto_fim     = entry (17, dwb_set_list_param.cod_dwb_parameters, chr(10))
                     v_log_lote_ctbl      = (entry (18, dwb_set_list_param.cod_dwb_parameters, chr(10)) = 'yes')
                     v_num_lote_ctbl_ini  = int (entry (19, dwb_set_list_param.cod_dwb_parameters, chr(10)))
                     v_num_lote_ctbl_fim  = int (entry (20, dwb_set_list_param.cod_dwb_parameters, chr(10))).          
          if num-entries (dwb_set_list_param.cod_dwb_parameters, chr(10)) = 21 then
              assign v_log_cpart = (entry (21, dwb_set_list_param.cod_dwb_parameters, chr(10)) = 'yes').
      end.
   end.
   else do:
      find ped_exec_param no-lock
          where ped_exec_param.num_ped_exec = v_num_ped_exec_corren no-error.
      if avail ped_exec_param then do:
         assign v_cod_empresa        = entry (01, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_cenar_ctbl     = entry (02, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_finalid_econ   = entry (03, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_plano_cta_ctbl = entry (04, ped_exec_param.cod_dwb_parameters, chr(10))
                v_dat_inic_period_ctbl = date (entry (05, ped_exec_param.cod_dwb_parameters, chr(10)))
                v_dat_fim_period_ctbl  = date (entry (06, ped_exec_param.cod_dwb_parameters, chr(10)))
                v_cod_cta_ctbl_ini   = entry (07, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_cta_ctbl_fim   = entry (08, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_estab_ini      = entry (09, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_estab_fim      = entry (10, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_unid_negoc_ini = entry (11, ped_exec_param.cod_dwb_parameters, chr(10))
                v_cod_unid_negoc_fim = entry (12, ped_exec_param.cod_dwb_parameters, chr(10))
                v_log_analit         = (entry (13, ped_exec_param.cod_dwb_parameters, chr(10)) = 'yes')
                v_log_print_par      = ped_exec_param.log_dwb_print_parameters
                v_des_impressor      = ped_exec_param.nom_dwb_printer
                v_des_layout         = ped_exec_param.cod_dwb_print_layout
                v_cod_dwb_output     = ped_exec_param.cod_dwb_output
                v_arq_out            = ped_exec_param.cod_dwb_file.
          if num-entries (dwb_set_list_param.cod_dwb_parameters, chr(10)) >= 15 then
              assign v_cod_plano_ccusto   = entry (15, ped_exec_param.cod_dwb_parameters, chr(10))
                     v_cod_ccusto_ini     = entry (16, ped_exec_param.cod_dwb_parameters, chr(10))
                     v_cod_ccusto_fim     = entry (17, ped_exec_param.cod_dwb_parameters, chr(10))
                     v_log_lote_ctbl      = (entry (18, ped_exec_param.cod_dwb_parameters, chr(10)) = 'yes')
                     v_num_lote_ctbl_ini  = int (entry (19, ped_exec_param.cod_dwb_parameters, chr(10)))
                     v_num_lote_ctbl_fim  = int (entry (20, ped_exec_param.cod_dwb_parameters, chr(10))).          
          if num-entries (ped_exec_param.cod_dwb_parameters, chr(10)) = 21 then
              assign v_log_cpart = (entry (21, ped_exec_param.cod_dwb_parameters, chr(10)) = 'yes').
         find ped_exec of ped_exec_param no-lock no-error.
         find servid_exec of ped_exec no-lock no-error.
         if avail servid_exec then do:
             assign v_arq_out = servid_exec.nom_dir_spool + "/" 
                              + v_arq_out.
         end.                
      end.
   end.
   assign v_log_cep_open = no
          rs_destino     = if v_cod_dwb_output = "Impressora" then 1
                             else if v_cod_dwb_output = "Arquivo" then 2
                                else if v_cod_dwb_output = "Terminal" then 3
                                   else 2.
   find emsuni.empresa no-lock
      where emsuni.empresa.cod_empresa = v_cod_empresa no-error.
   if avail emsuni.empresa then do:
      assign v_cod_empresa = emsuni.empresa.cod_empresa
             v_nom_abrev   = emsuni.empresa.nom_abrev
             v_rec_empresa = recid (emsuni.empresa).
   end.
   find cenar_ctbl no-lock 
      where cenar_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl no-error.
   if avail cenar_ctbl then do:
      assign v_cod_cenar_ctbl = cenar_ctbl.cod_cenar_ctbl
             v_des_cenar_ctbl = cenar_ctbl.des_cenar_ctbl
             v_rec_cenar_ctbl = recid (cenar_ctbl).
   end.
   find plano_cta_ctbl no-lock
      where plano_cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl no-error.
   if avail plano_cta_ctbl then do:
      assign v_cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
             v_des_plano_cta_ctbl  = plano_cta_ctbl.des_tit_ctbl
             v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
             v_rec_plano_cta_ctbl  = recid (plano_cta_ctbl).
   end.
   if v_cod_plano_ccusto = "" then
      assign v_cod_plano_ccusto = v_cod_plano_ccusto_corren.
   find plano_ccusto no-lock
      where plano_ccusto.cod_empresa      = v_cod_empresa
        and plano_ccusto.cod_plano_ccusto = v_cod_plano_ccusto no-error.
   if avail plano_ccusto then do:
      assign v_cod_plano_ccusto  = plano_ccusto.cod_plano_ccusto
             v_des_plano_ccusto  = plano_ccusto.des_tit_ctbl
             v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
             v_rec_plano_ccusto  = recid (plano_ccusto).    
      if num-entries (v_cod_format_ccusto, ".") > 0 then
         assign v_num_entry = num-entries (v_cod_format_ccusto, ".") - 1.
   end.
   
   find finalid_econ no-lock
      where finalid_econ.cod_finalid_econ = v_cod_finalid_econ no-error.
   if avail finalid_econ then do:
      assign v_cod_finalid_econ = finalid_econ.cod_finalid_econ
             v_des_finalid_econ = finalid_econ.des_finalid_econ
             v_rec_finalid_econ = recid (finalid_econ).
   end.

end.

procedure pi_esp_aprop_ctbl_impr:

   find emsuni.empresa no-lock
      where emsuni.empresa.cod_empresa = v_cod_empresa no-error.
   if avail emsuni.empresa then do:
      assign v_cod_cta_ctbl     = ""
             v_des_traco       = fill("-", 141)
             v_des_traco_1     = fill("-", 104)
             v_des_traco_2     = fill("-", 133)
             v_nom_enterprise  = emsuni.empresa.nom_razao_social
             v_nom_report_title = "Relat¢rio Apropriaá‰es Cont†beis Espec°fico"
             v_nom_prog_ext    = caps("esfgl03a")
             v_cod_release     = "1.03.00.000"
             v_dat_execution   = today
             v_hra_execution   = replace(string(time,"hh:mm:ss"),":","").
   end.

   assign v_arq_plan = v_arq_out
          /*substr (v_arq_plan, length (v_arq_plan) - 2, 3) = "csv"
          v_arq_ab   = v_arq_out + "ab"
          substr (v_arq_plan, length (v_arq_plan) - 2, 3) = "csv"
          v_arq_cd   = v_arq_out + "cd"
          substr (v_arq_plan, length (v_arq_plan) - 2, 3) = "csv"
          v_arq_ez   = v_arq_out + "ez"
          substr (v_arq_plan, length (v_arq_plan) - 2, 3) = "csv"*/ .
          

   case v_cod_dwb_output:
       when "Terminal" /*l_terminal*/  then do:
           assign v_arq_out = session:temp-directory + "esfgl03a" + STRING(TIME) + '.csv'.
           output stream s_1 to value(v_arq_out) convert target 'iso8859-1'.
           if v_log_analit = yes then do:
              output stream s_plha to value(v_arq_plan) convert target 'iso8859-1'.
              /*output stream s_ab to value(v_arq_ab) convert target 'iso8859-1'.
              output stream s_cd to value(v_arq_cd) convert target 'iso8859-1'.
              output stream s_ez to value(v_arq_ez) convert target 'iso8859-1'. WCS*/
           end.
       end.
       when "Impressora" /*l_printer*/  then do:
           find imprsor_usuar no-lock
               where imprsor_usuar.nom_impressora = v_des_impressor
               and  imprsor_usuar.cod_usuario     = v_cod_dwb_user
               use-index imprsrsr_id no-error.
           find layout_impres no-lock
               where layout_impres.nom_impressora    = v_des_impressor
               and   layout_impres.cod_layout_impres = v_des_layout
               no-error.
           assign v_rpt_s_1_bottom = layout_impres.num_lin_pag /* + v_rpt_s_1_bottom - v_rpt_s_1_lines */
                  v_rpt_s_1_lines  = layout_impres.num_lin_pag.
           if opsys = "UNIX" then do:
               if v_num_ped_exec_corren <> 0 then do:
                   find ped_exec no-lock
                       where ped_exec.num_ped_exec = v_num_ped_exec_corren no-error.
                   if avail ped_exec then do:
                       find servid_exec_imprsor no-lock
                           where servid_exec_imprsor.cod_servid_exec = ped_exec.cod_servid_exec
                           and   servid_exec_imprsor.nom_impressora  = v_des_impressor no-error.
                       if avail servid_exec_imprsor then
                           output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                  paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
                      else
                           output stream s_1 through value(imprsor_usuar.nom_disposit_so)
                               paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
                  end.
               end.
               else
                   output stream s_1 through value(imprsor_usuar.nom_disposit_so)
                       paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
           end.
           else
               output stream s_1 to value(imprsor_usuar.nom_disposit_so)
                      paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
               output stream s_plha to value (v_arq_plan) convert target 'iso8859-1'.
            for each configur_layout_impres no-lock
               where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
               by configur_layout_impres.num_ord_funcao_imprsor:
               find configur_tip_imprsor no-lock
                   where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                   and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                   and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                   no-error.
               put stream s_1 control configur_tip_imprsor.cod_comando_configur.
           end.
       end.
       when "Arquivo" /*l_file*/  then do:
           /*
           output stream s_plha to value(v_arq_out) convert target 'iso8859-1'.
          /* if v_log_analit = yes then /*WCS*/ */
          
              output stream s_1 to value (v_arq_plan) convert target 'iso8859-1'.*/
           assign v_arq_out = session:temp-directory + "esfgl03a_" + STRING(TIME) + '.csv'.
           
           output stream s_1 to value(v_arq_out) convert target 'iso8859-1'.
          
           if v_log_analit = yes then do:
             
              output stream s_plha to value(v_arq_plan) convert target 'iso8859-1'.
              /*output stream s_ab to value(v_arq_ab) convert target 'iso8859-1'.
              output stream s_cd to value(v_arq_cd) convert target 'iso8859-1'.
              output stream s_ez to value(v_arq_ez) convert target 'iso8859-1'. WCS*/
           end.
       end.
   end.
   
   run pi_pesq_item_lancto_ctbl.

   if v_log_print_par = yes then do:
   end.
   output stream s_1 close.
   if v_log_analit = yes then
      output stream s_plha close.
   hide frame f_perc no-pause.
   if v_cod_dwb_output = "Terminal" /* Terminal */ then
       RUN pi_abre_edit (INPUT v_arq_plan).
      /*run pi_abre_edit (Input v_arq_out).*/
   

end.

procedure pi_pesq_item_lancto_ctbl:

   def var v_val_max   as int no-undo.
   def var v_val_curr  as int no-undo.
   def var v_val_aux   as int no-undo.
   def var v_dat_aux   as date no-undo.
   
   for each tt_item_lancto_ctbl:
      delete tt_item_lancto_ctbl.
   end.
   for each tt_reg_calc_bem_pat:
       delete tt_reg_calc_bem_pat.
   end.
   assign v_val_max  = 0
          v_val_curr = 0
          v_val_aux  = v_dat_fim_period_ctbl - v_dat_inic_period_ctbl + 1
          v_val_sdo_item_acum = 0
          v_val_sdo_ctbl_acum = 0.

   run pi_impr_cabec.
   if v_log_lote_ctbl = no then do:
       for each cta_ctbl no-lock
          where cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
            and cta_ctbl.cod_cta_ctbl      >= v_cod_cta_ctbl_ini
            and cta_ctbl.cod_cta_ctbl      <= v_cod_cta_ctbl_fim:
          if cta_ctbl.ind_espec_cta_ctbl = "SintÇtica" then 
             next.
          assign v_val_max = v_val_max + 1.
       end.      
       assign v_val_max = v_val_max * v_val_aux.    
       run pi_percentual (input v_val_max,
                          input 0,
                          input "Executando...").  
       for each cta_ctbl no-lock
          where cta_ctbl.cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
            and cta_ctbl.cod_cta_ctbl      >= v_cod_cta_ctbl_ini
            and cta_ctbl.cod_cta_ctbl      <= v_cod_cta_ctbl_fim:
          if cta_ctbl.ind_espec_cta_ctbl = "SintÇtica" then 
             next.
          do v_dat_aux = v_dat_inic_period_ctbl to v_dat_fim_period_ctbl:
           
             for each item_lancto_ctbl no-lock
                 where item_lancto_ctbl.cod_plano_cta_ctbl  = cta_ctbl.cod_plano_cta_ctbl
                   and item_lancto_ctbl.cod_cta_ctbl        = cta_ctbl.cod_cta_ctbl
                   and item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"
                   and item_lancto_ctbl.dat_lancto_ctbl     = v_dat_aux
                   AND item_lancto_ctbl.cod_estab          >= v_cod_estab_ini
                   AND item_lancto_ctbl.cod_estab          <= v_cod_estab_fim
                   and not item_lancto_ctbl.log_lancto_apurac_restdo:
                 /*--- Aciona a API Item Lancto Ctbl Espec°fico ---*/
                 
                 run pi_gerac_tt_item_lancto_ctbl.
             end.
             run pi_impr_tt_item_lancto_ctbl.             
             assign v_val_curr = v_val_curr + 1.
             run pi_percentual (input v_val_max,
                                input v_val_curr,
                                input "Executando...").
             if v_val_curr = v_val_max then
                hide frame f_perc no-pause.
          end.
       end.

   end.
   else do:
       for each lancto_ctbl no-lock
          where lancto_ctbl.num_lote_ctbl >= v_num_lote_ctbl_ini
            and lancto_ctbl.num_lote_ctbl <= v_num_lote_ctbl_fim:
          if lancto_ctbl.ind_sit_lancto_ctbl <> "CTBZ" then
              next.
          assign v_val_max = v_val_max + 1.
       end.
       run pi_percentual (input v_val_max,
                          input 0,
                          input "Executando...").  
       for each lancto_ctbl no-lock
          where lancto_ctbl.num_lote_ctbl >= v_num_lote_ctbl_ini
            and lancto_ctbl.num_lote_ctbl <= v_num_lote_ctbl_fim:
          if lancto_ctbl.ind_sit_lancto_ctbl <> "CTBZ" then
              next.            
          for each item_lancto_ctbl of lancto_ctbl no-lock
             break by item_lancto_ctbl.cod_cta_ctbl:
             if item_lancto_ctbl.cod_plano_cta_ctbl <> v_cod_plano_cta_ctbl then
                 next.
             if item_lancto_ctbl.log_lancto_apurac_restdo then
                next.
             IF item_lancto_ctbl.cod_cta_ctbl < v_cod_cta_ctbl_ini
             or item_lancto_ctbl.cod_cta_ctbl > v_cod_cta_ctbl_fim THEN
                 next.
             /*--- Aciona a API Item Lancto Ctbl Espec°fico ---*/
             run pi_gerac_tt_item_lancto_ctbl.                 
          end.
          run pi_impr_tt_item_lancto_ctbl.
          assign v_val_curr = v_val_curr + 1.
          run pi_percentual (input v_val_max,
                             input v_val_curr,
                             input "Executando...").
          if v_val_curr = v_val_max then
             hide frame f_perc no-pause.                             
       end.

   end.

end.

procedure pi_gerac_tt_item_lancto_ctbl:
     
    def var v_dat_fim_mes as date no-undo.
    
    if month (v_dat_fim_period_ctbl) < 12 then
        assign v_dat_fim_mes = DATE (MONTH (v_dat_fim_period_ctbl) + 1, 01, YEAR (v_dat_fim_period_ctbl)) - 1.
    else
        assign v_dat_fim_mes = DATE (01, 01, YEAR (v_dat_fim_period_ctbl) + 1) - 1.
    item_block:
    do:
       if item_lancto_ctbl.cod_empresa <> v_cod_empresa then 
          leave item_block.
       IF item_lancto_ctbl.cod_unid_negoc < v_cod_unid_negoc_ini
       or item_lancto_ctbl.cod_unid_negoc > v_cod_unid_negoc_fim THEN
          leave ITEM_block.
       if v_cod_ccusto_ini <> fill ("0", length (v_cod_format_ccusto) - v_num_entry)
       or v_cod_ccusto_fim <> fill ("9", length (v_cod_format_ccusto) - v_num_entry) then do:
           if item_lancto_ctbl.cod_plano_ccusto <> v_cod_plano_ccusto then
               leave item_block.
           IF item_lancto_ctbl.cod_ccusto < v_cod_ccusto_ini
           or item_lancto_ctbl.cod_ccusto > v_cod_ccusto_fim THEN
               leave item_block.

       end.
       
       FIND aprop_lancto_ctbl NO-LOCK
           WHERE aprop_lancto_ctbl.num_lote_ctbl       = ITEM_lancto_ctbl.num_lote_ctbl
             AND aprop_lancto_ctbl.num_lancto_ctbl     = ITEM_lancto_ctbl.num_lancto_ctbl
             AND aprop_lancto_ctbl.num_seq_lancto_ctbl = ITEM_lancto_ctbl.num_seq_lancto_ctbl
             AND aprop_lancto_ctbl.cod_finalid_econ    = v_cod_finalid_econ NO-ERROR.
       IF AVAIL aprop_lancto_ctbl THEN DO:
          
           FIND FIRST tt_item_lancto_ctbl 
               WHERE tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl = aprop_lancto_ctbl.num_id_aprop_lancto_ctbl NO-ERROR.
           IF AVAIL tt_item_lancto_ctbl THEN
              leave item_block.             
          find es-usuar-cc where es-usuar-cc.cod_usuario = v_cod_usuar_corren
                             and es-usuar-cc.cod_ccusto  = "*"
               no-lock no-error.
          if not avail es-usuar-cc then do:
             if (item_lancto_ctbl.cod_ccusto = "" and 
                 not can-find(first es-usuar-cc 
                              where es-usuar-cc.cod_usuario = v_cod_usuar_corren
                                and es-usuar-cc.cod_ccusto  = ""))
             or (item_lancto_ctbl.cod_ccusto <> "" and 
                 not can-find(first es-usuar-cc 
                              where es-usuar-cc.cod_usuario = v_cod_usuar_corren
                                and es-usuar-cc.cod_ccusto  = item_lancto_ctbl.cod_ccusto)) then
             /*   leave item_block.   imprimir todas as contas. 19/06             */
          end.
 
           create tt_item_lancto_ctbl.
           assign tt_item_lancto_ctbl.cod_empresa         = item_lancto_ctbl.cod_empresa
                  tt_item_lancto_ctbl.dat_lancto_ctbl     = item_lancto_ctbl.dat_lancto_ctbl
                  tt_item_lancto_ctbl.num_lote_ctbl       = item_lancto_ctbl.num_lote_ctbl
                  tt_item_lancto_ctbl.num_lancto_ctbl     = item_lancto_ctbl.num_lancto_ctbl
                  tt_item_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl
                  tt_item_lancto_ctbl.cod_plano_cta_ctbl  = item_lancto_ctbl.cod_plano_cta_ctbl
                  tt_item_lancto_ctbl.cod_cta_ctbl        = item_lancto_ctbl.cod_cta_ctbl
                  tt_item_lancto_ctbl.cod_plano_ccusto    = item_lancto_ctbl.cod_plano_ccusto
                  tt_item_lancto_ctbl.cod_ccusto          = item_lancto_ctbl.cod_ccusto
                  tt_item_lancto_ctbl.cod_estab           = item_lancto_ctbl.cod_estab
                  tt_item_lancto_ctbl.cod_unid_negoc      = item_lancto_ctbl.cod_unid_negoc
                  tt_item_lancto_ctbl.des_histor          = item_lancto_ctbl.des_histor_lancto_ctbl
                  tt_item_lancto_ctbl.des_histor          = replace (tt_item_lancto_ctbl.des_histor, chr(10), chr(32))
                  tt_item_lancto_ctbl.des_histor          = replace (tt_item_lancto_ctbl.des_histor, chr(13), chr(32))
                  tt_item_lancto_ctbl.num_seq_lancto_ctbl_cpart = item_lancto_ctbl.num_seq_lancto_ctbl_cpart
                  tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl = aprop_lancto_ctbl.num_id_aprop_lancto_ctbl.                
           if item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" then do:
               assign tt_item_lancto_ctbl.val_lancto_ctbl_db = aprop_lancto_ctbl.val_lancto_ctbl.
           end.
           else do:
               assign tt_item_lancto_ctbl.val_lancto_ctbl_cr = aprop_lancto_ctbl.val_lancto_ctbl.
           end.
           FIND lancto_ctbl OF ITEM_lancto_ctbl NO-LOCK NO-ERROR.           
           IF AVAIL lancto_ctbl THEN do:          
              ASSIGN tt_item_lancto_ctbl.cod_modul_dtsul = lancto_ctbl.cod_modul_dtsul.
              if  lancto_ctbl.cod_modul_dtsul  = "CEP" 
              and lancto_ctbl.dat_lancto_ctbl <= v_dat_fim_mes then do:                  
                  assign v_log_cep_open = yes.
              end.
           end.
       end.
    end.

end.

procedure pi_impr_tt_item_lancto_ctbl:
      
   for each tt_item_lancto_ctbl
       /*break by tt_item_lancto_ctbl.cod_cta_ctbl
             by tt_item_lancto_ctbl.cod_modul_dtsul*/:
       
       assign v_val_sdo_item_acum = v_val_sdo_item_acum
                                  + tt_item_lancto_ctbl.val_lancto_ctbl_db
                                  - tt_item_lancto_ctbl.val_lancto_ctbl_cr.
       if v_cod_format_ccusto = "" then do:
           find plano_ccusto no-lock
              where plano_ccusto.cod_empresa      = tt_item_lancto_ctbl.cod_empresa
                and plano_ccusto.cod_plano_ccusto = tt_item_lancto_ctbl.cod_plano_ccusto no-error.
           if avail plano_ccusto then
              assign v_cod_format_ccusto = plano_ccusto.cod_format_ccusto.
       end.
       if v_cod_cta_ctbl_aux <> tt_item_lancto_ctbl.cod_cta_ctbl then do:
           find cta_ctbl no-lock
              where cta_ctbl.cod_plano_cta_ctbl = tt_item_lancto_ctbl.cod_plano_cta_ctbl
                and cta_ctbl.cod_cta_ctbl       = tt_item_lancto_ctbl.cod_cta_ctbl no-error.
           if avail cta_ctbl then
              assign v_des_cta_ctbl = cta_ctbl.des_tit_ctbl.
           else
             assign v_des_cta_ctbl = "".
           assign v_cod_cta_ctbl_aux = tt_item_lancto_ctbl.cod_cta_ctbl.
       end.
       if v_cod_estab_aux <> tt_item_lancto_ctbl.cod_estab then do:
           FIND estabelecimento NO-LOCK
               WHERE estabelecimento.cod_estab = tt_item_lancto_ctbl.cod_estab NO-ERROR.
           if avail estabelecimento then 
              assign v_des_estab = estabelecimento.nom_abrev.
           else
              assign v_des_estab = "".
           assign v_cod_estab_aux = tt_item_lancto_ctbl.cod_estab.
       end.
       if v_cod_unid_negoc_aux <> tt_item_lancto_ctbl.cod_unid_negoc then do:
           FIND emscad.unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = tt_item_lancto_ctbl.cod_unid_negoc NO-ERROR.
           if avail unid_negoc then
              assign v_des_unid_negoc = unid_negoc.des_unid_negoc.
           else
              assign v_des_unid_negoc = "".              
           assign v_cod_unid_negoc_aux = tt_item_lancto_ctbl.cod_unid_negoc.
       end.
       if v_cod_ccusto_aux <> tt_item_lancto_ctbl.cod_ccusto then do:
           FIND emsuni.ccusto NO-LOCK
               WHERE ccusto.cod_empresa      = tt_item_lancto_ctbl.cod_empresa
                 AND ccusto.cod_plano_ccusto = tt_item_lancto_ctbl.cod_plano_ccusto
                 AND ccusto.cod_ccusto       = tt_item_lancto_ctbl.cod_ccusto NO-ERROR.
           IF AVAIL ccusto THEN
              assign v_des_ccusto = ccusto.des_tit_ctbl.                     
           else
              assign v_des_ccusto = "".
           assign v_cod_ccusto_aux = tt_item_lancto_ctbl.cod_ccusto.
       end.           
       assign v_des_refer = string (tt_item_lancto_ctbl.num_lote_ctbl)   + "|"
                          + string (tt_item_lancto_ctbl.num_lancto_ctbl) + "|"
                          + string (tt_item_lancto_ctbl.num_seq_lancto_ctbl).
       put stream s_1 unformatted
           tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)  
           v_des_refer chr(59)
           string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
           v_des_cta_ctbl                          chr(59)
           string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
           v_des_ccusto                            chr(59)           
           tt_item_lancto_ctbl.cod_estab           chr(59)
           v_des_estab                             chr(59)
           tt_item_lancto_ctbl.cod_unid_negoc      chr(59)
           v_des_unid_negoc                        chr(59).
       if v_log_cpart = yes then
           run pi_impr_cpart (input no /* "SintÇtico" */,
                              input tt_item_lancto_ctbl.num_lote_ctbl,
                              input tt_item_lancto_ctbl.num_lancto_ctbl,
                              input tt_item_lancto_ctbl.num_seq_lancto_ctbl_cpart).
       put stream s_1 unformatted           
           tt_item_lancto_ctbl.val_lancto_ctbl_db      format ">>>,>>>,>>9.99"   chr(59)
           tt_item_lancto_ctbl.val_lancto_ctbl_cr * -1 format "->>>,>>>,>>9.99"  chr(59) 
           v_val_sdo_item_acum                         format "->>>>,>>>,>>9.99" chr(59)
           if tt_item_lancto_ctbl.val_lancto_ctbl_db > 0 then " D" else " C"   chr(59)           
           tt_item_lancto_ctbl.cod_modul_dtsul     chr(59) chr(59)
           tt_item_lancto_ctbl.des_histor
           skip.
       if v_log_analit = yes then do: /*WCS*/
           /* Là os registros nos m¢dulos */
           assign v_log_aprop = no.
           run pi_impr_analit.
           if v_log_aprop = no then 
              put stream s_plha
                  skip.           
       end.                                
       delete tt_item_lancto_ctbl.
   end.

end.

procedure pi_impr_cpart:
   
   def input param p_log_movto           as log no-undo.
   def input param p_num_lote_ctbl       as int no-undo.
   def input param p_num_lancto_ctbl     as int no-undo.
   def input param p_num_seq_lancto_ctbl as int no-undo.
      
   find item_lancto_ctbl no-lock
       where item_lancto_ctbl.num_lote_ctbl       = p_num_lote_ctbl
         and item_lancto_ctbl.num_lancto_ctbl     = p_num_lancto_ctbl
         and item_lancto_ctbl.num_seq_lancto_ctbl = p_num_seq_lancto_ctbl no-error.
   if avail item_lancto_ctbl then do:
       if v_cod_format_ccusto = "" then do:
           find plano_ccusto no-lock
              where plano_ccusto.cod_empresa      = item_lancto_ctbl.cod_empresa
                and plano_ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto no-error.
           if avail plano_ccusto then
              assign v_cod_format_ccusto = plano_ccusto.cod_format_ccusto.
       end.
       if v_cod_cta_ctbl_cpart <> item_lancto_ctbl.cod_cta_ctbl then do:
           find cta_ctbl no-lock
              where cta_ctbl.cod_plano_cta_ctbl = item_lancto_ctbl.cod_plano_cta_ctbl
                and cta_ctbl.cod_cta_ctbl       = item_lancto_ctbl.cod_cta_ctbl no-error.
           if avail cta_ctbl then
              assign v_des_cta_ctbl_cpart = cta_ctbl.des_tit_ctbl.
           else
             assign v_des_cta_ctbl_cpart = "".
           assign v_cod_cta_ctbl_cpart = item_lancto_ctbl.cod_cta_ctbl.
       end.
       if v_cod_estab_cpart <> item_lancto_ctbl.cod_estab then do:
           FIND estabelecimento NO-LOCK
               WHERE estabelecimento.cod_estab = item_lancto_ctbl.cod_estab NO-ERROR.
           if avail estabelecimento then 
              assign v_des_estab_cpart = estabelecimento.nom_abrev.
           else
              assign v_des_estab_cpart = "".
           assign v_cod_estab_cpart = item_lancto_ctbl.cod_estab.
       end.
       if v_cod_unid_negoc_cpart <> item_lancto_ctbl.cod_unid_negoc then do:
           FIND emscad.unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = item_lancto_ctbl.cod_unid_negoc NO-ERROR.
           if avail unid_negoc then
              assign v_des_unid_negoc_cpart = unid_negoc.des_unid_negoc.
           else
              assign v_des_unid_negoc_cpart = "".
           assign v_cod_unid_negoc_cpart = item_lancto_ctbl.cod_unid_negoc.
       end.
       if v_cod_ccusto_cpart <> item_lancto_ctbl.cod_ccusto then do:
           FIND emsuni.ccusto NO-LOCK
               WHERE ccusto.cod_empresa      = item_lancto_ctbl.cod_empresa
                 AND ccusto.cod_plano_ccusto = item_lancto_ctbl.cod_plano_ccusto
                 AND ccusto.cod_ccusto       = item_lancto_ctbl.cod_ccusto NO-ERROR.
           IF AVAIL ccusto THEN
              assign v_des_ccusto_cpart = ccusto.des_tit_ctbl.                     
           else
              assign v_des_ccusto_cpart = "".
           assign v_cod_ccusto_cpart = item_lancto_ctbl.cod_ccusto.
       end.
       if p_log_movto = no then 
           put stream s_1 unformatted        
               item_lancto_ctbl.num_seq_lancto_ctbl chr(59)
               string (item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
               v_des_cta_ctbl_cpart                 chr(59)
               string (item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
               v_des_ccusto_cpart                   chr(59)
               item_lancto_ctbl.cod_estab           chr(59)
               v_des_estab_cpart                    chr(59)
               item_lancto_ctbl.cod_unid_negoc      chr(59)
               v_des_unid_negoc_cpart               chr(59).
       else
           put stream s_plha unformatted        
               item_lancto_ctbl.num_seq_lancto_ctbl chr(59)
               string (item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
               v_des_cta_ctbl_cpart                 chr(59)
               string (item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
               v_des_ccusto_cpart                   chr(59)
               item_lancto_ctbl.cod_estab           chr(59)
               v_des_estab_cpart                    chr(59)
               item_lancto_ctbl.cod_unid_negoc      chr(59)
               v_des_unid_negoc_cpart               chr(59).       
   end.
   else do:
       if p_log_movto = no then    
           put stream s_1 unformatted
               fill (chr(59), 9).
       else
           put stream s_plha unformatted
               fill (chr(59), 9).       
   end.

end.

procedure pi_impr_analit:

    def var v_dat_ini          as date no-undo.
    def var v_dat_fim          as date no-undo.
    def var v_log_requis       as log  no-undo.
    
    case tt_item_lancto_ctbl.cod_modul_dtsul:
        when 'CEP' then do:
             assign v_cod_cta_ctbl_ext = trim (tt_item_lancto_ctbl.cod_cta_ctbl)
                                       /**
                                       + trim (tt_item_lancto_ctbl.cod_unid_negoc)
                                       **/ .
             if tt_item_lancto_ctbl.cod_ccusto = "" then
                assign v_cod_cta_ctbl_ext = v_cod_cta_ctbl_ext.
             else
                assign v_cod_cta_ctbl_ext = v_cod_cta_ctbl_ext
                                          /**
                                          + trim (tt_item_lancto_ctbl.cod_ccusto)
                                          **/
                                          .             
             if v_log_cep_open = yes then 
                ASSIGN v_dat_fim = tt_item_lancto_ctbl.dat_lancto_ctbl
                       v_dat_ini = tt_item_lancto_ctbl.dat_lancto_ctbl.
             else
                ASSIGN v_dat_fim = tt_item_lancto_ctbl.dat_lancto_ctbl
                       v_dat_ini = DATE (MONTH (v_dat_fim), 01, YEAR (v_dat_fim)).             
             run pi_aprop_lancto_ctbl_cep (input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl,                                
                                           input v_cod_cta_ctbl_ext,
                                           input tt_item_lancto_ctbl.cod_ccusto,
                                           input v_dat_ini,
                                           input v_dat_fim,
                                           output v_log_requis).
             assign v_cod_cta_ctbl_ext = "".                                           
        end.
        when 'FTP' then do:
             /**
             if v_cod_cta_ctbl_ext <> "" and v_cod_cta_ctbl_ftp = v_cod_cta_ctbl_ext then
                 next.
             **/
             assign v_cod_cta_ctbl_ext = /** trim (tt_item_lancto_ctbl.cod_estab) 
                                       + **/ trim (tt_item_lancto_ctbl.cod_cta_ctbl)
                                       /**
                                       + trim (tt_item_lancto_ctbl.cod_unid_negoc) **/ .
             /**
             if tt_item_lancto_ctbl.cod_ccusto = "" then
                assign v_cod_cta_ctbl_ext = v_cod_cta_ctbl_ext  + "00000".
             else
                assign v_cod_cta_ctbl_ext = v_cod_cta_ctbl_ext
                                          + trim (tt_item_lancto_ctbl.cod_ccusto).
             **/ 
             run pi_aprop_lancto_ctbl_ftp (input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl,
                                           input v_cod_cta_ctbl_ext,
                                           input tt_item_lancto_ctbl.cod_ccusto).
             assign v_cod_cta_ctbl_ftp = /** trim (tt_item_lancto_ctbl.cod_estab)
                                       + **/ trim (tt_item_lancto_ctbl.cod_cta_ctbl)
                                       /**
                                       + trim (tt_item_lancto_ctbl.cod_unid_negoc) **/.
             /**                          
             if tt_item_lancto_ctbl.cod_ccusto = "" then
                assign v_cod_cta_ctbl_ftp = v_cod_cta_ctbl_ext + "00000".
             else
                assign v_cod_cta_ctbl_ftp = v_cod_cta_ctbl_ext
                                          + trim (tt_item_lancto_ctbl.cod_ccusto).
             **/
        end.
        when 'ACR' then do:
            run pi_aprop_lancto_ctbl_acr (Input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl).
        end.
        when 'APB' then do:
            run pi_aprop_lancto_ctbl_apb (Input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl).
        end.
        /**
        when 'APL' then do:
            run pi_aprop_lancto_ctbl_apl (Input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl).
        end. 
        **/       
        when 'CMG' then do:
            run pi_aprop_lancto_ctbl_cmg (Input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl).
        end.
        when 'FAS' then do:
            run pi_aprop_lancto_ctbl_fas (Input tt_item_lancto_ctbl.num_id_aprop_lancto_ctbl).        
        end.
        otherwise do:
            if tt_item_lancto_ctbl.cod_modul_dtsul = 'FGL' or tt_item_lancto_ctbl.cod_modul_dtsul = 'PTP' then do:                
            
                put stream s_plha unformatted
                    tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
                    v_des_refer chr(59)
                    string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
                    trim (v_des_cta_ctbl) chr(59).
                IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
                    put stream s_plha unformatted
                        string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                        TRIM (v_des_ccusto) CHR(59).
                ELSE
                    put stream s_plha unformatted
                        FILL (CHR(59), 02).
                if v_log_cpart = yes then
                    run pi_impr_cpart (input yes /* "Anal°tico" */,
                                       input tt_item_lancto_ctbl.num_lote_ctbl,
                                       input tt_item_lancto_ctbl.num_lancto_ctbl,
                                       input tt_item_lancto_ctbl.num_seq_lancto_ctbl_cpart).                
                put stream s_plha unformatted
                                                              chr(59) /* Deposito  */
                                                              chr(59) /* Especie   */
                                                              chr(59) /* Serie     */
                                                              chr(59) /* Docto     */
                                                              chr(59) /* Parc      */
                                                              chr(59) /* Emit      */
                                                              chr(59) /* Nome Emit */
                                                              chr(59) /* Item      */
                                                              chr(59) /* Un        */
                                                              chr(59) /* Qtd       */ .
                assign tt_item_lancto_ctbl.des_histor = replace (tt_item_lancto_ctbl.des_histor, chr(10), chr(32))
                       v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                           + tt_item_lancto_ctbl.val_lancto_ctbl_db
                                           - tt_item_lancto_ctbl.val_lancto_ctbl_cr.
                put stream s_plha unformatted
                    tt_item_lancto_ctbl.val_lancto_ctbl_db format ">>>,>>>,>>9.99" chr(59)
                    tt_item_lancto_ctbl.val_lancto_ctbl_cr * -1 format "->>>,>>>,>>9.99" chr(59)
                    tt_item_lancto_ctbl.val_lancto_ctbl_db + (tt_item_lancto_ctbl.val_lancto_ctbl_cr * -1)  format "->>>,>>>,>>9.99" chr(59)
                    /**
                    v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                    if tt_item_lancto_ctbl.val_lancto_ctbl_db > 0 then " D" else " C" chr(59)
                    **/
                    tt_item_lancto_ctbl.cod_modul_dtsul chr(59)
                    trim (tt_item_lancto_ctbl.des_histor)
                   skip.
                /**        
                put stream s_plha unformatted
                    trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
                    TRIM (v_des_estab)                        CHR(59)
                    TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
                    TRIM (v_des_unid_negoc)                   CHR(59).
                **/
           end.
        end.
    end.

end.

PROCEDURE pi_aprop_lancto_ctbl_acr:

    def input param p_num_id_aprop_lancto_ctbl as int no-undo.
    
    def var v_val_db as dec no-undo.
    def var v_val_cr as dec no-undo.
    def var v_des_histor as char no-undo.
    def var c_nom_pessoa as char form "x(60)" no-undo.


    for each val_aprop_ctbl_acr no-lock
        where val_aprop_ctbl_acr.num_id_aprop_lancto_ctbl = p_num_id_aprop_lancto_ctbl:
        find aprop_ctbl_acr no-lock
            where aprop_ctbl_acr.cod_estab             = val_aprop_ctbl_acr.cod_estab
              and aprop_ctbl_acr.num_id_aprop_ctbl_acr = val_aprop_ctbl_acr.num_id_aprop_ctbl_acr no-error.
        find movto_tit_acr no-lock
            where movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
            and   movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr no-error.
        if aprop_ctbl_acr.ind_natur_lancto_ctbl = "DB" then 
            assign v_val_db = val_aprop_ctbl_acr.val_aprop_ctbl.
        else
            assign v_val_cr = val_aprop_ctbl_acr.val_aprop_ctbl.
        find tit_acr no-lock
            where tit_acr.cod_estab      = movto_tit_acr.cod_estab
              and tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.
        find emsuni.cliente no-lock
            where cliente.cod_empresa = v_cod_empres_usuar
              and cliente.cdn_cliente = tit_acr.cdn_cliente no-error.
        if not avail cliente then
            next.
        put stream s_plha unformatted
            tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
            v_des_refer chr(59)
            string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
            trim (v_des_cta_ctbl) chr(59).
        IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
            put stream s_plha unformatted
                string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                TRIM (v_des_ccusto) CHR(59).
        ELSE
            put stream s_plha unformatted
                FILL (CHR(59), 02).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).

        assign c_nom_pessoa = trim(replace(cliente.nom_pessoa,chr(59),"")).

        put stream s_plha unformatted
                                                      chr(59) /* Deposito  */
            tit_acr.cod_espec_docto                   chr(59) /* Especie   */
            tit_acr.cod_ser_docto                     chr(59) /* Serie     */
            tit_acr.cod_tit_acr                       chr(59) /* Docto     */
            tit_acr.cod_parcela                       chr(59) /* Parc      */
            cliente.cdn_cliente                       chr(59) /* Emit      */
            c_nom_pessoa                              chr(59) /* Nome Emit */
                                                      chr(59) /* Item      */
                                                      chr(59) /* Un        */
                                                      chr(59) /* Qtd       */ .
        assign v_log_aprop         = yes
               v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                   + v_val_db
                                   - v_val_cr.        
        put stream s_plha unformatted        
            v_val_db            format ">>>,>>>,>>9.99"  chr(59)
            v_val_cr * -1       format "->>>,>>>,>>9.99" chr(59)
            v_val_db + (v_val_cr * -1) format "->>>,>>>,>>9.99" chr(59) /*Saldo*/
            /**
            v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
            if v_val_db > 0 then " D" else " C"       chr(59)
            **/
            "ACR"
            chr(59)
            /**
            movto_tit_acr.ind_trans_acr
            " Cliente: "
            cliente.nom_abrev
            " Esp: " 
            tit_acr.cod_espec_docto
            " SÇrie: "
            tit_acr.cod_ser_docto
            " T°tulo: "
            tit_acr.cod_tit_acr
            '/'
            tit_acr.cod_parcela
            chr(59)
            **/ .
        find first histor_movto_tit_acr no-lock
           where histor_movto_tit_acr.cod_estab            = tit_acr.cod_estab
             and histor_movto_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
             and histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
             and histor_movto_tit_acr.ind_orig_histor_acr  = "movimento" no-error.
        if avail histor_movto_tit_acr then do:
           assign v_des_histor = histor_movto_tit_acr.des_text_histor
                  v_des_histor = replace (v_des_histor, chr(10), chr(32))
                  v_des_histor = replace (v_des_histor, chr(13), chr(32))
                  v_des_histor = replace (v_des_histor, chr(59), chr(32)).
        
           put stream s_plha unformatted
                trim (v_des_histor) form "x(1000)".
        end.
            
        /**        
        put stream s_plha unformatted
            trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
            TRIM (v_des_estab)                        CHR(59)
            TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
            TRIM (v_des_unid_negoc)                   CHR(59).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).
        **/
        put stream s_plha
            skip.
    end.
   
END.

procedure pi_aprop_lancto_ctbl_apb:

    def input param p_num_id_aprop_lancto_ctbl as int no-undo.

    def var v_val_db         as dec  no-undo.
    def var v_val_cr         as dec  no-undo.
    def var v_cdn_fornecedor as int  no-undo.
    def var v_nom_abrev      as char no-undo.
    def var v_cod_tit_ap     as char no-undo.

    def var v_des_histor as char no-undo.
    def var c_nom_pessoa as char form "x(60)" no-undo.
    
    for each val_aprop_ctbl_ap no-lock
        where val_aprop_ctbl_ap.num_id_aprop_lancto_ctbl = p_num_id_aprop_lancto_ctbl:
        find aprop_ctbl_ap no-lock
            where aprop_ctbl_ap.cod_estab            = val_aprop_ctbl_ap.cod_estab
            and   aprop_ctbl_ap.num_id_aprop_ctbl_ap = val_aprop_ctbl_ap.num_id_aprop_ctbl_ap no-error.
        find movto_tit_ap no-lock
            where movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
            and   movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap no-error.
        if aprop_ctbl_ap.ind_natur_lancto_ctbl = "DB" then 
           assign v_val_db = val_aprop_ctbl_ap.val_aprop_ctbl.
        else
           assign v_val_cr = val_aprop_ctbl_ap.val_aprop_ctbl. 
        if  movto_tit_ap.ind_trans_ap <> "Pagto Extra Fornecedor" 
        and movto_tit_ap.ind_trans_ap <> "Pagto Extra Fornecedor CR" then do:
            find tit_ap no-lock
                where tit_ap.cod_estab     = movto_tit_ap.cod_estab
                  and tit_ap.num_id_tit_ap = movto_tit_ap.num_id_tit_ap no-error.
            if not avail tit_ap then
               next.
            assign v_cdn_fornecedor = tit_ap.cdn_fornecedor
                   v_cod_tit_ap     = tit_ap.cod_tit_ap.
        end.
        else do:
            assign v_cdn_fornecedor = movto_tit_ap.cdn_fornec_pef
                   v_cod_tit_ap     = movto_tit_ap.cod_refer.
        end.
        find emsuni.fornecedor no-lock
           where emsuni.fornecedor.cod_empresa    = v_cod_empres_usuar
             and emsuni.fornecedor.cdn_fornecedor = v_cdn_fornecedor no-error.
        if avail fornecedor then do:
           if fornecedor.nom_abrev = fornecedor.cod_id_feder then
              assign v_nom_abrev = replace(fornecedor.nom_pessoa,chr(59),"").
           else
              assign v_nom_abrev = fornecedor.nom_abrev.
        end.
        else
            next.
            
        put stream s_plha unformatted
            tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
            v_des_refer chr(59)
            string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
            trim (v_des_cta_ctbl) chr(59).
        IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
            put stream s_plha unformatted
                string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                TRIM (v_des_ccusto) CHR(59).
        ELSE
            put stream s_plha unformatted
                FILL (CHR(59), 02).

        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).
        assign c_nom_pessoa = trim(replace(fornecedor.nom_pessoa,chr(59),"")).
        put stream s_plha unformatted
                                                      chr(59) /* Deposito  */
            tit_ap.cod_espec_docto                    chr(59) /* Especie   */
            tit_ap.cod_ser_docto                      chr(59) /* Serie     */
            tit_ap.cod_tit_ap /* v_cod_tit_ap */      chr(59) /* Docto     */
            tit_ap.cod_parcela                        chr(59) /* Parc      */
            fornecedor.cdn_fornecedor                 chr(59) /* Emit      */
            c_nom_pessoa                              chr(59) /* Nome Emit */
                                                      chr(59) /* Item      */
                                                      chr(59) /* Un        */
                                                      chr(59) /* Qtd       */ .
        assign v_log_aprop         = yes
               v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                   + v_val_db
                                   - v_val_cr.
        put stream s_plha unformatted
            v_val_db            format ">>>,>>>,>>9.99"  chr(59)
            v_val_cr * -1       format "->>>,>>>,>>9.99" chr(59)
            v_val_db + (v_val_cr * -1) format "->>>,>>>,>>9.99" chr(59) /*Saldo*/
            /**
            v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
            if v_val_db > 0 then " D" else " C" chr(59)
            **/
            "APB"
            chr(59).
            /**
            " Usuario: "
            movto_tit_ap.cod_usuario chr(32)
            " Transacao: " 
            movto_tit_ap.ind_trans_ap chr(32)
            " Fornec: "
            v_cdn_fornecedor chr(32)
            v_nom_abrev.
            
        if avail tit_ap then
            put stream s_plha unformatted
                " Esp: " 
                tit_ap.cod_espec_docto
                " SÇrie: "
                tit_ap.cod_ser_docto
                " T°tulo: "
                v_cod_tit_ap
                '/'
                tit_ap.cod_parcela
                chr(59).
        else
            put stream s_plha unformatted
                " T°tulo: "
                v_cod_tit_ap
                chr(59).        
            **/    
        find first histor_tit_movto_ap no-lock
            where histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
              and histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap
              and histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
              and histor_tit_movto_ap.ind_orig_histor_ap  = "movimento" no-error.
        if avail histor_tit_movto_ap then do:
            assign v_des_histor = histor_tit_movto_ap.des_text_histor
                   v_des_histor = replace (v_des_histor, chr(10), chr(32))
                   v_des_histor = replace (v_des_histor, chr(13), chr(32))
                   v_des_histor = replace (v_des_histor, chr(59), chr(32)).
            put stream s_plha unformatted
                trim (v_des_histor) form "x(1000)".
        end.
            
        /**
        put stream s_plha unformatted
            trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
            TRIM (v_des_estab)                        CHR(59)
            TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
            TRIM (v_des_unid_negoc)                   CHR(59).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).
        **/            
        put stream s_plha
            skip.
    end.

end.

PROCEDURE pi_aprop_lancto_ctbl_apl:

    def input param p_num_id_aprop_lancto_ctbl as int no-undo.    

    def var v_val_db     as dec  no-undo.
    def var v_val_cr     as dec  no-undo.
    def var v_des_histor as char no-undo.

    for each aprop_ctbl_apl no-lock
        where aprop_ctbl_apl.num_id_aprop_lancto_ctbl = p_num_id_aprop_lancto_ctbl:
        find movto_operac_financ no-lock
             where movto_operac_financ.num_id_movto_operac_financ = aprop_ctbl_apl.num_id_movto_operac_financ no-error.
        find operac_financ no-lock
            where operac_financ.num_id_operac_financ = movto_operac_financ.num_id_operac_financ no-error.    
        assign v_des_histor = movto_operac_financ.des_histor_movto_apl
               v_des_histor = replace (v_des_histor, chr(10), chr(32))
               v_des_histor = replace (v_des_histor, chr(13), chr(32))
               v_des_histor = replace (v_des_histor, chr(59), chr(32)).
        if aprop_ctbl_apl.ind_natur_lancto_ctbl = "DB" then 
           assign v_val_db = aprop_ctbl_apl.val_aprop_indic_econ_movto.
        else
           assign v_val_cr = aprop_ctbl_apl.val_aprop_indic_econ_movto.      
        put stream s_plha unformatted
             tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
             v_des_refer chr(59)
             string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
            trim (v_des_cta_ctbl) chr(59).
        IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
            put stream s_plha unformatted
                string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                TRIM (v_des_ccusto) CHR(59).
        ELSE
            put stream s_plha unformatted
                FILL (CHR(59), 02).
        put stream s_plha unformatted
            trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
            TRIM (v_des_estab)                        CHR(59)
            TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
            TRIM (v_des_unid_negoc)                   CHR(59).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).            
        assign v_log_aprop         = yes
               v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                   + v_val_db
                                   - v_val_cr.       
        put stream s_plha unformatted
            v_val_db            format ">>>,>>>,>>9.99" chr(59)
            v_val_cr * -1       format "->>>,>>>,>>9.99" chr(59)
            v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
            if v_val_db > 0 then " D" else " C" chr(59)
            "APL;"
            chr(59)
            "Trans: "
            movto_operac_financ.ind_tip_trans_apl
            " Banco: "
            operac_financ.cod_banco           
            " Produto: "
            operac_financ.cod_produt_financ
            " Oper: "
            operac_financ.cod_operac_financ            
            chr(59)
            trim (v_des_histor)
            skip.
    end.

end.

procedure pi_aprop_lancto_ctbl_cmg:

    def input param p_num_id_aprop_lancto_ctbl as int no-undo.
    
    def var v_val_db     as dec  no-undo.
    def var v_val_cr     as dec  no-undo.
    def var v_cod_usuar  as char no-undo.
    def var v_des_histor as char no-undo.

    for each val_aprop_ctbl_cmg no-lock
        where val_aprop_ctbl_cmg.num_id_aprop_lancto_ctbl = p_num_id_aprop_lancto_ctbl:
        find first aprop_ctbl_cmg no-lock
          where aprop_ctbl_cmg.num_id_movto_cta_corren = val_aprop_ctbl_cmg.num_id_movto_cta_corren
            and aprop_ctbl_cmg.num_seq_aprop_ctbl_cmg  = val_aprop_ctbl_cmg.num_seq_aprop_ctbl_cmg no-error.
        find first movto_cta_corren no-lock
           where movto_cta_corren.num_id_movto_cta_corren = aprop_ctbl_cmg.num_id_movto_cta_corren no-error.
        assign v_des_histor = movto_cta_corren.des_histor_movto_cta_corren
               v_des_histor = replace (v_des_histor, chr(10), chr(32))
               v_des_histor = replace (v_des_histor, chr(13), chr(32)).
        if aprop_ctbl_cmg.ind_natur_lancto_ctbl = "DB" then 
           assign v_val_db = val_aprop_ctbl_cmg.val_movto_cta_corren.
        else
           assign v_val_cr = val_aprop_ctbl_cmg.val_movto_cta_corren.
        if movto_cta_corren.cod_usuar_emis_aviso_lancto <> "" then
           assign v_cod_usuar = movto_cta_corren.cod_usuar_emis_aviso_lancto.
        else
           assign v_cod_usuar = movto_cta_corren.cod_usuar_ult_atualiz.
        put stream s_plha unformatted
            tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
            v_des_refer chr(59)
            string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
            trim (v_des_cta_ctbl) chr(59).
        IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
            put stream s_plha unformatted
                string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                TRIM (v_des_ccusto) CHR(59).
        ELSE
            put stream s_plha unformatted
                FILL (CHR(59), 02).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).

        put stream s_plha unformatted
                                                      chr(59) /* Deposito  */
                                                      chr(59) /* Especie   */
                                                      chr(59) /* Serie     */
                                                      chr(59) /* Docto     */
                                                      chr(59) /* Parc      */
                                                      chr(59) /* Emit      */
                                                      chr(59) /* Nome Emit */
                                                      chr(59) /* Item      */
                                                      chr(59) /* Un        */
                                                      chr(59) /* Qtd       */ .
        assign v_log_aprop         = yes
               v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                   + v_val_db
                                   - v_val_cr.                                   
        put stream s_plha unformatted
            v_val_db            format ">>>,>>>,>>9.99" chr(59)
            v_val_cr       * -1 format "->>>,>>>,>>9.99" chr(59)
            v_val_db + (v_val_cr   * -1) format "->>>,>>>,>>9.99" chr(59)  /*Saldo*/
            /**
            v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
            if v_val_db > 0 then " D" else " C" chr(59)
            **/
            "CMG"
            chr(59)
            trim (v_des_histor)
            /**
            chr(59)
            "Seq: "
            movto_cta_corren.num_seq_movto_cta_corren
            " Cta Corren: "
            movto_cta_corren.cod_cta_corren
            " Fluxo: "
            movto_cta_corren.ind_fluxo_movto_cta_corren
            " Usuario : " trim (v_cod_usuar)
            **/
            skip.
        /**
        put stream s_plha unformatted
            trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
            TRIM (v_des_estab)                        chr(59)
            TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
            TRIM (v_des_unid_negoc)                   CHR(59).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).
        **/
    end.

end.

procedure pi_aprop_lancto_ctbl_fas:

    def input param p_num_id_aprop_lancto_ctbl as int no-undo.

    def var v_val_db         as dec  no-undo.
    def var v_val_cr         as dec  no-undo.
    def var v_des_histor     as char no-undo.
    
    for each aprop_ctbl_pat no-lock  
       where (aprop_ctbl_pat.num_id_aprop_lancto_ctbl_db = p_num_id_aprop_lancto_ctbl or 
              aprop_ctbl_pat.num_id_aprop_lancto_ctbl_cr = p_num_id_aprop_lancto_ctbl):
        /**   
        if can-find(first tt_reg_calc_bem_pat 
                    where tt_reg_calc_bem_pat.num_seq_reg_calc_bem_pat =aprop_ctbl_pat.num_seq_reg_calc_bem_pat) then
           return "OK":U.
        create tt_reg_calc_bem_pat.
        assign tt_reg_calc_bem_pat.num_seq_reg_calc_bem_pat = aprop_ctbl_pat.num_seq_reg_calc_bem_pat.
        **/   
        for each reg_calc_bem_pat no-lock
           where reg_calc_bem_pat.cod_cenar_ctbl = v_cod_cenar_ctbl
             and reg_calc_bem_pat.num_seq_reg_calc_bem_pat = aprop_ctbl_pat.num_seq_reg_calc_bem_pat:
           find bem_pat no-lock
               where bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat no-error.
           if aprop_ctbl_pat.num_id_aprop_lancto_ctbl_db = p_num_id_aprop_lancto_ctbl then 
              assign v_val_db = aprop_ctbl_pat.val_lancto_ctbl.
           else
              assign v_val_cr = aprop_ctbl_pat.val_lancto_ctbl.
        end.
        if v_val_db = 0 and v_val_cr = 0 then
           return.
        assign v_des_histor = aprop_ctbl_pat.des_histor_lancto_ctbl
               v_des_histor = replace (v_des_histor, chr(10), chr(32))
               v_des_histor = replace (v_des_histor, chr(13), chr(32)).
        
        put stream s_plha unformatted
            tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
            v_des_refer chr(59)
            string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
            trim (v_des_cta_ctbl) chr(59).
        IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
            put stream s_plha unformatted
                string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                TRIM (v_des_ccusto) CHR(59).
        ELSE
            put stream s_plha unformatted
                FILL (CHR(59), 02).
        if v_log_cpart = yes then
            put stream s_plha unformatted
                fill (chr(59), 9).            

        put stream s_plha unformatted
                                                      chr(59) /* Deposito  */
                                                      chr(59) /* Especie   */
                                                      chr(59) /* Serie     */
                                                      chr(59) /* Docto     */
                                                      chr(59) /* Parc      */
                                                      chr(59) /* Emit      */
                                                      chr(59) /* Nome Emit */
                                                      chr(59) /* Item      */
                                                      chr(59) /* Un        */
                                                      chr(59) /* Qtd       */ .
        assign v_log_aprop         = yes
               v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                   + v_val_db
                                   - v_val_cr.
        put stream s_plha unformatted        
            v_val_db            format "->>>,>>>,>>9.99" chr(59)
            v_val_cr * -1       format "->>>,>>>,>>9.99" chr(59)
            v_val_db + (v_val_cr * -1) format "->>>,>>>,>>9.99" chr(59)  /*Saldo*/
            /**
            v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
            if v_val_db > 0 then " D" else " C" chr(59)
            **/
            "FAS;"
            /**
            " Transaá∆o: "
            reg_calc_bem_pat.ind_trans_calc_bem_pat
            " Conta Pat: "
            bem_pat.cod_cta_pat
            " Bem: "
            bem_pat.num_bem_pat
            " Seq: "
            bem_pat.num_seq_bem_pat chr(32)
            reg_calc_bem_pat.ind_orig_calc_bem_pat            
            chr(59)
            trim (aprop_ctbl_pat.des_histor_lancto_ctbl)
            **/
            trim (v_des_histor)
            skip.
        /**
        put stream s_plha unformatted
            trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
            TRIM (v_des_estab)                        CHR(59)
            TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
            TRIM (v_des_unid_negoc)                   CHR(59).
        **/    
    end.

end.

procedure pi_aprop_lancto_ctbl_cep:

    def input param p-num-id-movto-ctbl as int  no-undo.
    def input param p-conta-contabil    as char no-undo.
    def input param p-centro-custo      as char no-undo.
    def input param p-dat-ini           as date no-undo.
    def input param p-dat-fim           as date no-undo.
    def output param p-log-requis       as log  no-undo.
    
    def var v_num_grp          LIKE mgind.item.ge-codigo no-undo.
    def var v_des_narrat       as char format "x(90)"  no-undo. 
    def var v_val_movto        as decimal              no-undo.
    def var v_val_movto_rm     as decimal              no-undo.
    DEF VAR v_dat_ini          AS DATE                 NO-UNDO.
    DEF VAR v_dat_fim          AS DATE                 NO-UNDO.
    DEF VAR v_dat_fim_mes      AS DATE                 NO-UNDO.
    DEF VAR v_dat_aux          AS DATE                 NO-UNDO.
    DEF VAR v_conta            LIKE movto-estoq.conta-contabil no-undo.
    def var v_log_cta_saldo    as log                  no-undo.
    def var v_des_histor       as char no-undo.
    def var i_emp              as char                 no-undo.
    def var c-nome-emit        as char form "x(40)"    no-undo.

    DEFINE VARIABLE obs-pedido   AS CHARACTER   NO-UNDO.

    assign v_des_histor = tt_item_lancto_ctbl.des_histor
           v_des_histor = replace (v_des_histor, chr(10), chr(32))
           v_des_histor = replace (v_des_histor, chr(13), chr(32)).
    
    find aprop_lancto_ctbl no-lock
       where aprop_lancto_ctbl.num_id_aprop_lancto_ctbl = p-num-id-movto-ctbl no-error.
    find item_lancto_ctbl of aprop_lancto_ctbl no-lock no-error.
    if avail item_lancto_ctbl then do:
       ASSIGN v_dat_fim = p-dat-ini /*item_lancto_ctbl.dat_lancto_ctbl*/
              v_dat_ini = p-dat-fim /*DATE (MONTH (v_dat_fim), 01, YEAR (v_dat_fim))*/
              v_conta   = p-conta-contabil.
       /**       
       if p-centro-custo = "" then
          for first trad_cta_ctbl_ext no-lock
              where trad_cta_ctbl_ext.cod_unid_organ = "BLZ"
                and trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = "FCONT" 
                and trad_cta_ctbl_ext.cod_plano_cta_ctbl = "GERAL"
                and trad_cta_ctbl_ext.cod_cta_ctbl = v_conta:
              assign v_conta = trad_cta_ctbl_ext.cod_cta_ctbl_ext.  
          end.
       else
          for first trad_cta_ctbl_ext no-lock
              where trad_cta_ctbl_ext.cod_unid_organ = "BLZ"
                and trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = "FCONT" 
                and trad_cta_ctbl_ext.cod_plano_cta_ctbl = "GERAL"
                and trad_cta_ctbl_ext.cod_cta_ctbl = v_conta
                and trad_cta_ctbl_ext.cod_plano_ccusto = "GERAL"
                and trad_cta_ctbl_ext.cod_ccusto = p-centro-custo:
              assign v_conta = trad_cta_ctbl_ext.cod_cta_ctbl_ext.  
          end.
       **/   
       assign v_conta = replace(v_conta,".","").
          
       if r-index (item_lancto_ctbl.des_histor_lancto_ctbl, "Grupo:") <> 0 then
          assign v_num_grp = int (substr (item_lancto_ctbl.des_histor_lancto_ctbl, r-index (item_lancto_ctbl.des_histor_lancto_ctbl, "grupo:") + 7, 2)).
       /* Verifica se Ç Conta Ctbl de Saldo ou de Impostos */
       FIND mgadm.estabelec NO-LOCK 
           where estabelec.cod-estabel = item_lancto_ctbl.cod_estab NO-ERROR.
       if avail estabelec then do:
          if mgadm.estabelec.conta-icms = v_conta then
             assign v_log_cta_saldo = yes.
          if mgadm.estabelec.conta-ipi = v_conta then
             assign v_log_cta_saldo = yes.
       end.
       i_emp = item_lancto_ctbl.cod_empresa.
       /**
       find first trad_org_ext 
            where trad_org_ext.cod_tip_unid_organ = "998"
              and trad_org_ext.cod_unid_organ = i_emp
              and trad_org_ext.cod_unid_organ_ext <> trad_org_ext.cod_unid_organ
            no-lock no-error.
       if avail trad_org_ext then
          assign i_emp = trad_org_ext.cod_unid_organ_ext.
                           
       if p-centro-custo = "" then
       find first conta-contab
            where mgadm.conta-contab.ep-codigo  = i_emp
              and mgadm.conta-contab.ct-codigo  = v_conta no-lock no-error.
       else
       find first conta-contab
            where mgadm.conta-contab.ep-codigo  = i_emp
              and mgadm.conta-contab.ct-codigo  = v_conta 
              and mgadm.conta-contab.sc-codigo  = p-centro-custo no-lock no-error.
       if avail mgadm.conta-contab and mgadm.conta-contab.estoque = 9 then
          assign v_log_cta_saldo = yes.
       **/
       /**
       find cta_ctbl_integr where cta_ctbl_integr.cod_plano_cta_ctbl = "GERAL"
                              and cta_ctbl_integr.cod_modul_dtsul    = "CEP"
                              and cta_ctbl_integr.cod_cta_ctbl       = v_conta
            no-lock no-error.
            
       if avail cta_ctbl_integr and cta_ctbl_integr.ind_finalid_ctbl = "Saldo por grupo de estoque" then
          assign v_log_cta_saldo = yes.
       **/
       if v_log_cta_saldo = yes then do:
           put stream s_plha unformatted
               tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
               v_des_refer chr(59)
               string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
               trim (v_des_cta_ctbl) chr(59).
           IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
               put stream s_plha unformatted
                   string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                   TRIM (v_des_ccusto) CHR(59).
           ELSE
               put stream s_plha unformatted
                   FILL (CHR(59), 02).
           if v_log_cpart = yes then
               put stream s_plha unformatted
                   fill (chr(59), 9).

           put stream s_plha unformatted
                                                         chr(59) /* Deposito  */
                                                         chr(59) /* Especie   */
                                                         chr(59) /* Serie     */
                                                         chr(59) /* Docto     */
                                                         chr(59) /* Parc      */
                                                         chr(59) /* Emit      */
                                                         chr(59) /* Nome Emit */
               "CONTA DE SALDO / IMPOSTO IPI-ICMS"       chr(59) /* Item      */
                                                         chr(59) /* Un        */
                                                         chr(59) /* Qtd       */ .
           assign tt_item_lancto_ctbl.des_histor = replace (tt_item_lancto_ctbl.des_histor, chr(10), chr(32))
                  v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                      + tt_item_lancto_ctbl.val_lancto_ctbl_db
                                      - tt_item_lancto_ctbl.val_lancto_ctbl_cr.
           put stream s_plha unformatted
               tt_item_lancto_ctbl.val_lancto_ctbl_db format ">>>,>>>,>>9.99" chr(59)
               tt_item_lancto_ctbl.val_lancto_ctbl_cr * -1 format "->>>,>>>,>>9.99" chr(59)
               tt_item_lancto_ctbl.val_lancto_ctbl_db + (tt_item_lancto_ctbl.val_lancto_ctbl_cr * -1) format "->>>,>>>,>>9.99" chr(59) /*Saldo*/
               /**
               v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
               if tt_item_lancto_ctbl.val_lancto_ctbl_db > 0 then " D" else " C" chr(59)
               **/
               tt_item_lancto_ctbl.cod_modul_dtsul chr(59)
               chr(59)
               trim (v_des_histor) form "x(1000)"
               skip.       
           /**        
           put stream s_plha unformatted
               trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
               TRIM (v_des_estab)                        CHR(59)
               TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
               TRIM (v_des_unid_negoc)                   CHR(59).
           if v_log_cpart = yes then
               put stream s_plha unformatted
                   fill (chr(59), 9).
           **/
           return.
           
       end.          
       do v_dat_aux = v_dat_ini to v_dat_fim:
           movto_block:
           for each movto-estoq no-lock
              where movto-estoq.ct-codigo      = v_conta
                and movto-estoq.dt-trans       = v_dat_aux
              use-index data-conta
              break by movto-estoq.cod-estabel
                    by movto-estoq.esp-docto:
              if p-centro-custo <> "" and p-centro-custo <> movto-estoq.sc-codigo then
                 next movto_block.
              if movto-estoq.cod-estabel <> item_lancto_ctbl.cod_estab then 
                 next movto_block.
              assign v_val_movto = 0.
              
              if movto-estoq.esp-docto = 30 /* RM */ then do:
                  find first item 
                     where item.it-codigo   = movto-estoq.it-codigo no-lock no-error.
                  if avail item and item.ge-codigo = v_num_grp then do:
                      assign v_val_movto  = (movto-estoq.valor-mat-m[1]
                                          +  movto-estoq.valor-mob-m[1]
                                          +  movto-estoq.valor-ggf-m[1]
                                          +  movto-estoq.valor-icm
                                          +  movto-estoq.valor-ipi).
                      if movto-estoq.tipo-trans = 1 then 
                          assign v_val_movto = v_val_movto * -1.
                      assign v_val_movto_rm = v_val_movto_rm 
                                            + v_val_movto.
                  end.
              end.             
              else do:
                  find first item 
                     where item.it-codigo   = movto-estoq.it-codigo no-lock no-error.
                  if avail item then do:
                     if item.ge-codigo <> v_num_grp then 
                        next movto_block.
                     find emitente of movto-estoq no-lock no-error.
                     
                     assign v_val_movto  = (movto-estoq.valor-mat-m[1]
                                         +  movto-estoq.valor-mob-m[1]
                                         +  movto-estoq.valor-ggf-m[1]
                                         +  movto-estoq.valor-icm
                                         +  movto-estoq.valor-ipi).
                     if movto-estoq.tipo-trans = 1 then 
                        assign v_val_movto = v_val_movto * -1.
                     /* Impress∆o no s_plha */
                     put stream s_plha unformatted
                         movto-estoq.dt-trans format "99/99/9999" chr(59)
                         v_des_refer chr(59)
                         string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
                         trim (v_des_cta_ctbl) chr(59).
                     IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
                         put stream s_plha unformatted
                             string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                             TRIM (v_des_ccusto) CHR(59).
                     ELSE
                         put stream s_plha unformatted
                             FILL (CHR(59), 02).

                     if v_log_cpart = yes then
                         put stream s_plha unformatted
                             fill (chr(59), 9).                         

                     put stream s_plha unformatted
                         movto-estoq.cod-depos                     chr(59) /* Deposito  */
                         {ininc/i03in218.i 04 movto-estoq.esp-docto}
                                                                   chr(59) /* Especie   */
                         movto-estoq.serie-docto                   chr(59) /* Serie     */
                         movto-estoq.nro-docto                     chr(59) /* Docto     */
                                                                   chr(59) /* Parc      */.
                     if avail emitente then do:
                        assign c-nome-emit = trim(replace(emitente.nome-emit,chr(59),"")).
                        put stream s_plha unformatted
                            emitente.cod-emitente                  chr(59) /* Emit      */
                            c-nome-emit                            chr(59) /* Nome Emit */.
                     end.
                     else
                        put stream s_plha unformatted
                                                                   chr(59) /* Emit      */
                                                                   chr(59) /* Nome Emit */.
                     put stream s_plha unformatted
                         movto-estoq.it-codigo                                   chr(59) /* Item      */
                         movto-estoq.un                                          chr(59) /* Un        */
                         movto-estoq.quantidade                                  chr(59) /* Qtd       */ .

                     assign v_log_aprop         = yes
                            v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                                + v_val_movto.
                     IF v_val_movto > 0 THEN DO:
                         PUT STREAM s_plha unformatted
                             v_val_movto FORMAT ">>>,>>>,>>9.99" CHR(59)
                             0 FORMAT ">>>,>>>,>>9.99" CHR(59)
                             v_val_movto FORMAT ">>>,>>>,>>9.99" CHR(59)   /*Saldo*/
                             /**
                             v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                             " D;"
                             **/
                             "CEP".
                     END.
                     ELSE DO:
                         PUT STREAM s_plha unformatted
                             0 FORMAT ">>>,>>>,>>9.99" CHR(59)
                             v_val_movto FORMAT "->>>,>>>,>>9.99" CHR(59)
                             v_val_movto FORMAT "->>>,>>>,>>9.99" CHR(59)   /*Saldo - WCS - 13/04/2018*/
                             /**
                             v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                             " C;"
                             **/
                             "CEP".
                     END.
                     assign v_des_narrat = "".
                     /*--- Imprime Narrativa do Item-doc-est ---*/
                     find item-doc-est no-lock 
                        where item-doc-est.serie-docto  = movto-estoq.serie-docto
                          and item-doc-est.nro-docto    = movto-estoq.nro-docto
                          and item-doc-est.cod-emitente = movto-estoq.cod-emitente
                          and item-doc-est.nat-operacao = movto-estoq.nat-operacao
                          and item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                     if avail item-doc-est then do:
                        if item-doc-est.narrativa <> "" then 
                           assign v_des_narrat = item-doc-est.narrativa
                                  v_des_narrat = replace (v_des_narrat, chr(10), chr(32))
                                  v_des_narrat = replace (v_des_narrat, chr(13), chr(32))
                                  v_des_narrat = replace (v_des_narrat, chr(59), chr(32)).
                        PUT STREAM s_plha UNFORMATTED
                            ";"
                             TRIM (v_des_narrat) form "x(1000)".
                     end.
                     else do:

                         FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel = movto-estoq.cod-estabel
                                                  AND nota-fiscal.serie       = movto-estoq.serie-docto  
                                                  AND nota-fiscal.nr-nota-fis = movto-estoq.nro-docto NO-LOCK NO-ERROR. 
                         IF AVAIL nota-fiscal THEN DO:
                         
                             FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                                                   AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
    
                             IF AVAIL ped-venda THEN DO:
                                 ASSIGN obs-pedido = "".
                                 FIND FIRST es-apvs-ped-venda WHERE es-apvs-ped-venda.nome-abrev = ped-venda.nome-abrev
                                                                AND es-apvs-ped-venda.nr-pedcli  = ped-venda.nr-pedcli NO-LOCK NO-ERROR.
                                 IF AVAIL es-apvs-ped-venda THEN
                                     ASSIGN obs-pedido = es-apvs-ped-venda.nr-pedcli + " - " + trim(replace( es-apvs-ped-venda.cond-espec,chr(59),"")).

                                 ASSIGN obs-pedido = replace (obs-pedido, chr(10), chr(32))
                                        obs-pedido = replace (obs-pedido, chr(13), chr(32))
                                        obs-pedido = REPLACE (obs-pedido, chr(59), chr(32)).
                             END.

                         END.


                        PUT STREAM s_plha unformatted
                            ";Grp: "
                            ITEM.ge-codigo 
                            " Esp: "
                            {ininc/i03in218.i 04 movto-estoq.esp-docto}  FORMAT "x(03)"
                            " Dep: "
                            movto-estoq.cod-depos.
                        IF AVAIL emitente THEN 
                           PUT STREAM s_plha unformatted
                               " Emit: "
                               emitente.nome-abrev.
                        PUT STREAM s_plha UNFORMATTED
                            " Ser: "
                            movto-estoq.serie-docto
                            " Docto: "
                            movto-estoq.nro-docto
                            " Item: "
                            movto-estoq.it-codigo
                            " - "
                            item.desc-item.

                        PUT STREAM s_plha
                           ";" obs-pedido  FORMAT "X(180)".  
                     end.

                     PUT STREAM s_plha UNFORMATTED
                         SKIP.

                     /**
                     put stream s_plha unformatted
                         trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
                         TRIM (v_des_estab)                        CHR(59)
                         TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
                         TRIM (v_des_unid_negoc)                   CHR(59).
                     if v_log_cpart = yes then
                         put stream s_plha unformatted
                             fill (chr(59), 9).                         
                     if movto-estoq.nr-trans > 0 THEN DO:
                         FIND doc-pend-aprov NO-LOCK
                             WHERE doc-pend-aprov.nr-trans = movto-estoq.nr-trans NO-ERROR.
                         IF AVAIL doc-pend-aprov THEN DO:
                             FIND requisicao NO-LOCK
                                 WHERE requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao NO-ERROR.
                         END.
                         IF AVAIL requisicao THEN DO:
                             PUT STREAM s_plha UNFORMATTED
                                 TRIM (requisicao.nome-abrev).
                         END.
                     END.
                     IF movto-estoq.numero-ordem > 0 THEN DO:
                         FIND ordem-compra NO-LOCK
                             WHERE ordem-compra.numero-ordem = movto-estoq.numero-ordem NO-ERROR.
                         IF AVAIL ordem-compra THEN DO:
                             PUT STREAM s_plha UNFORMATTED
                                 ordem-compra.requisitante FORMAT "x(12)".
                         END.
                     END.
                     **/
                     assign v_val_movto_rm = 0.
                  end.
              end.
           end.
           if v_val_movto_rm > 0 then do:
              assign v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                         + v_val_movto_rm.              
              put stream s_plha unformatted
                  movto-estoq.dt-trans format "99/99/9999" chr(59)  
                  v_des_refer chr(59)
                  string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
                  v_des_cta_ctbl                   chr(59)
                  string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                  v_des_ccusto                            chr(59).
              if v_log_cpart = yes then
                  put stream s_plha unformatted
                      fill (chr(59), 9).
              put stream s_plha unformatted
                                                            chr(59) /* Deposito  */
                                                            chr(59) /* Especie   */
                                                            chr(59) /* Serie     */
                                                            chr(59) /* Docto     */
                                                            chr(59) /* Emit      */
                                                            chr(59) /* Nome Emit */
                  "ESPECIE RM"                              chr(59) /* Item      */
                                                            chr(59) /* Un        */
                                                            chr(59) /* Qtd       */ .
                                        
              IF v_val_movto_rm > 0 THEN DO:
                   PUT STREAM s_plha unformatted
                      v_val_movto_rm FORMAT ">>>,>>>,>>9.99" CHR(59)
                      0 FORMAT ">>>,>>>,>>9.99" CHR(59)
                      v_val_movto_rm FORMAT ">>>,>>>,>>9.99" CHR(59) /*Saldo*/

                      /**
                      v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                      " D;"
                      **/
                      "CEP;"
                      v_des_histor form "x(1000)" 
                      skip.                             
              END.
              ELSE DO:
                  PUT STREAM s_plha unformatted
                      0 FORMAT ">>>,>>>,>>9.99" CHR(59)
                      v_val_movto_rm FORMAT "->>>,>>>,>>9.99" CHR(59)
                      v_val_movto_rm * -1 FORMAT "->>>,>>>,>>9.99" CHR(59) /*Saldo*/
 
                      /**
                      v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                      " C;"
                      **/
                      "CEP;"
                      v_des_histor form "x(1000)" 
                      skip.              
              END.

              /**    
              put stream s_plha unformatted
                  tt_item_lancto_ctbl.cod_estab           chr(59)
                  v_des_estab                             chr(59)
                  tt_item_lancto_ctbl.cod_unid_negoc      chr(59)
                  v_des_unid_negoc                        chr(59).
              if v_log_cpart = yes then
                  put stream s_plha unformatted
                      fill (chr(59), 9).                  
              **/
              assign v_val_movto_rm = 0.         
           end.           
        end.
    END.

end.

procedure pi_aprop_lancto_ctbl_ftp:

    def input param p-num-id-sumar-ft as int  no-undo.
    def input param p-conta-contabil  as char no-undo.
    def input param p-centro-custo    as char no-undo.

    def var c-tp-imposto as char format "x(20)" no-undo.
    def var v_num_nota   as char form   "x(16)" no-undo.
    def var v_serie      as char form   "x(5)"  no-undo.
    def var c-nome-emit  as char form   "x(40)" no-undo.
    
    
    DEFINE VARIABLE i-tp-imposto AS INTEGER     NO-UNDO.
    /**
    assign p-conta-contabil = substr (p-conta-contabil, 4, 16).
    **/
    find aprop_lancto_ctbl no-lock
       where aprop_lancto_ctbl.num_id_aprop_lancto_ctbl = p-num-id-sumar-ft no-error.
    find item_lancto_ctbl of aprop_lancto_ctbl no-lock no-error.
    if avail item_lancto_ctbl then do:
       assign v_num_nota = replace(item_lancto_ctbl.des_histor_lancto_ctbl,"MOVTO REF DOCTO NR. ","")
              v_num_nota = replace(v_num_nota,"serie ","") 
              v_serie    = entry(2,v_num_nota," ")
              v_num_nota = entry(1,v_num_nota," ").
       
       ASSIGN i-tp-imposto = 0.

        for EACH sumar-ft no-lock
            where sumar-ft.cod-estabel = tt_item_lancto_ctbl.cod_estab
              and sumar-ft.serie       = v_serie 
              and sumar-ft.nr-nota-fis = v_num_nota            
              and sumar-ft.ct-conta    = p-conta-contabil
              and sumar-ft.sc-conta    = p-centro-custo
              and sumar-ft.dt-movto    = tt_item_lancto_ctbl.dat_lancto_ctbl
              BY  sumar-ft.tp-imposto :

            FIND FIRST tt-sumar-ft WHERE tt-sumar-ft.cod-estabel = sumar-ft.cod-estabel
                                     AND tt-sumar-ft.serie       = sumar-ft.serie      
                                     and tt-sumar-ft.nr-nota-fis = sumar-ft.nr-nota-fis
                                     and tt-sumar-ft.tp-imposto  = sumar-ft.tp-imposto  NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-sumar-ft THEN DO:
                
                CREATE tt-sumar-ft.
                ASSIGN tt-sumar-ft.cod-estabel = sumar-ft.cod-estabel 
                       tt-sumar-ft.serie       = sumar-ft.serie      
                       tt-sumar-ft.nr-nota-fis = sumar-ft.nr-nota-fis
                       tt-sumar-ft.tp-imposto  = sumar-ft.tp-imposto .


            END.
            ELSE NEXT.

            IF i-tp-imposto = sumar-ft.tp-imposto THEN NEXT.

            ASSIGN i-tp-imposto = sumar-ft.tp-imposto.

            find nota-fiscal of sumar-ft no-lock no-error.  

            put stream s_plha unformatted
                tt_item_lancto_ctbl.dat_lancto_ctbl format "99/99/9999" chr(59)
                v_des_refer chr(59)
                string (tt_item_lancto_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) chr(59)
                trim (v_des_cta_ctbl) chr(59).
            IF tt_item_lancto_ctbl.cod_ccusto <> "" THEN
                put stream s_plha unformatted
                    string (tt_item_lancto_ctbl.cod_ccusto, v_cod_format_ccusto) chr(59)
                    TRIM (v_des_ccusto) CHR(59).
            ELSE
                put stream s_plha unformatted
                    FILL (CHR(59), 02).
                    
            if v_log_cpart = yes then
                put stream s_plha unformatted
                    fill (chr(59), 9).
            assign v_log_aprop         = yes
                   v_val_sdo_ctbl_acum = v_val_sdo_ctbl_acum
                                       + sumar-ft.vl-contab * -1.
            put stream s_plha unformatted
                                                          chr(59) /* Deposito  */
                ENTRY (nota-fiscal.esp-docto,c-esp)       form "x(3)"
                                                          chr(59) /* Especie   */
                sumar-ft.serie                            chr(59) /* Serie     */
                sumar-ft.nr-nota-fis                      chr(59) /* Docto     */
                                                          chr(59) /* Parc      */.
            if avail nota-fiscal then do:
               
               find emitente where emitente.cod-emitente = nota-fiscal.cod-emitente
                    no-lock no-error.
              /* put stream s_plha unformatted
                   nota-fiscal.cod-emitente               chr(59) /* Emit      */.*/
               if avail emitente then do:
                  assign c-nome-emit = trim(replace(emitente.nome-emit,chr(59),"")).
                  put stream s_plha unformatted
                      emitente.cod-emitente                  chr(59) /* Emit      */
                      c-nome-emit                            chr(59) /* Nome Emit */.
               end.
            end.
            else
               put stream s_plha unformatted
                                                      chr(59) /* Emit      */
                                                      chr(59) /* Nome Emit */.
            put stream s_plha unformatted                                           
                                                      chr(59) /* Item      */
                                                      chr(59) /* Un        */
                                                      chr(59) /* Qtd       */.
            /**                                              
            put stream s_plha unformatted
                trim (tt_item_lancto_ctbl.cod_estab)      chr(59)
                TRIM (v_des_estab)                        CHR(59)
                TRIM (tt_item_lancto_ctbl.cod_unid_negoc) chr(59)
                TRIM (v_des_unid_negoc)                   CHR(59).
            **/
            if sumar-ft.vl-contab > 0 then DO:
               PUT STREAM s_plha
                   0 FORMAT ">>>,>>>,>>9.99" CHR(59) form "x(1)"
                   sumar-ft.vl-contab * -1 FORMAT "->>>,>>>,>>9.99" CHR(59) form "x(1)" 
                   sumar-ft.vl-contab * -1 FORMAT "->>>,>>>,>>9.99" CHR(59) form "x(1)" /*Saldo*/
                   /**
                   v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                   "  C;"
                   **/
                   "FTP;".
            END.
            ELSE DO:
               PUT STREAM s_plha
                   sumar-ft.vl-contab * -1 FORMAT ">>>,>>>,>>9.99" CHR(59) form "x(1)"
                   0 FORMAT ">>>,>>>,>>9.99" CHR(59) form "x(1)"
                   sumar-ft.vl-contab * -1 FORMAT ">>>,>>>,>>9.99" CHR(59) form "x(1)" /*Saldo*/
                   /**
                   v_val_sdo_ctbl_acum format "->>,>>>,>>>,>>9.99" chr(59)
                   "  D;"
                   **/
                   "FTP;".
            END.
            if avail nota-fiscal then 
               put stream s_plha
                   "Cliente: "  
                    nota-fiscal.nome-ab-cli.
            put stream s_plha
               " Ser: "
               sumar-ft.serie
               " NF: "
               sumar-ft.nr-nota-fis.
            if sumar-ft.tp-imposto <> 0 then do:
               run pi-retorna-imposto (input  sumar-ft.tp-imposto,
                                       output c-tp-imposto).
               put stream s_plha
                   " Imp: " 
                   c-tp-imposto.
            end.
                
            PUT STREAM s_plha
                SKIP.
        end.
    END.

end.

procedure pi-retorna-imposto:
    
    def input param p-tp-imposto   as int  no-undo.
    def output param p-des-imposto as char no-undo.
    
    case p-tp-imposto:
        when 1 then
           assign p-des-imposto = "IPI".
        when 2 then
           assign p-des-imposto = "ICMS".
        when 3 then
           assign p-des-imposto = "ISS".
        when 4 then 
           assign p-des-imposto = "I.R.R.F.".
        when 5 then
           assign p-des-imposto = "PIS".
        when 6 then
           assign p-des-imposto = "COFINS".
        when 7 then
           assign p-des-imposto = "ICM SUBST. TRIB.".
        when 8 then
           assign p-des-imposto = "Descontos".
        when 9 then
           assign p-des-imposto = "PIS SUBSTITUTO".
        when 10 then
           assign p-des-imposto = "COFINS SUBSTITUTO".
        when 11 then
           assign p-des-imposto = "I.N.S.S.".
        otherwise
           assign p-des-imposto = "".
    end.

end.

procedure pi_impr_cabec:

   if v_log_cpart = no then
       put stream s_1 unformatted
          "Data"      chr(59)
          "Lote|Lancto|Seq" chr(59)      
          "Cta Ctbl"  chr(59) chr(59)
          "Ccusto"    chr(59) chr(59)
          "Est"       chr(59) chr(59)      
          "UNeg"      chr(59) chr(59)
          "DÇbitos"   chr(59)
          "CrÇditos"  chr(59)
          "Saldo"     chr(59)
          "D/C"       chr(59)
          "Origem"    chr(59) chr(59)
          "Hist¢rico" 
           skip.
   else
       put stream s_1 unformatted
          "Data"      chr(59)
          "Lote|Lancto|Seq" chr(59)      
          "Cta Ctbl"  chr(59) chr(59)
          "Ccusto"    chr(59) chr(59)
          "Est"       chr(59) chr(59)      
          "UNeg"      chr(59) chr(59)
          "Seq Cpart" chr(59)      
          "Cta Ctbl Cpart"  chr(59) chr(59)
          "Ccusto Cpart"    chr(59) chr(59)
          "Est Cpart"       chr(59) chr(59)      
          "UNeg Cpart"      chr(59) chr(59)          
          "DÇbitos"   chr(59)
          "CrÇditos"  chr(59)
          "Saldo"     chr(59)
          "D/C"       chr(59)
          "Origem"    chr(59) chr(59)
          "Hist¢rico"
           skip.   

   if v_log_analit = yes then do:
       if v_log_cpart = no then
           put stream s_plha unformatted 
               "Data;Lote|Lancto|Seq;Cta Ctbl;Descriá∆o da Conta;Ccusto;Descriá∆o do C.C;Dep;Esp;Ser;Docto;Parc;Emit;Nome Emit;Item;Un;Qtd;"
               "Movto DÇbito;Movto CrÇdito;Saldo;Origem;Historico;Obs. Pedido"
               skip.
       else
           put stream s_plha unformatted 
               "Data;Lote|Lancto|Seq;Cta Ctbl;Descriá∆o da Conta;Ccusto;Descriá∆o do C.C;"
               "Seq Cpart;Cta Ctbl Cpart;T°tulo;Ccusto Cpart;T°tulo;Estab Cpart;Nome Abrev;Un Neg Cpart;Descriá∆o;"
               "Dep;Esp;Ser;Docto;Parc;Emit;Nome Emit;Item;Un;Qtd;Movto DÇbito;Movto CrÇdito;Saldo ;Origem;Historico;Obs. Pedido"
               skip.
   end.

end.

procedure pi_percentual:

    def Input param p_val_max
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_val_curr
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_nom_title
        as character
        format "x(32)"
        no-undo.

    if  p_val_max = 0
    then do:
       assign p_val_max = 1.
    end.

    assign v_des_percent_complete     = string(integer(p_val_curr * 100 / p_val_max))
                                      + chr(32) + chr(37)
           v_des_percent_complete_fnd = v_des_percent_complete.

    if v_num_ped_exec_corren = 0 then do:
       if p_val_curr = 0 then do:
          assign v_des_percent_complete:width-pixels     in frame f_perc = 1
                 v_des_percent_complete:bgcolor          in frame f_perc = 1
                 v_des_percent_complete:fgcolor          in frame f_perc = 15
                 v_des_percent_complete:font             in frame f_perc = 1
                 rt_005:bgcolor                          in frame f_perc = 8
                 v_des_percent_complete_fnd:width-pixels in frame f_perc = 315
                 v_des_percent_complete_fnd:font         in frame f_perc = 1.
          if p_nom_title <> "" then do:
             assign frame f_perc:title = p_nom_title.
          end.
          else do:
             assign frame f_perc:title = "Aguarde, em processamento...".
          end.
          view frame f_perc.
       end.
       else do:
          assign v_des_percent_complete:width-pixels = max(((315 * p_val_curr)
                                                     / p_val_max), 1).
       end.
       display v_des_percent_complete
               v_des_percent_complete_fnd
               with frame f_perc.
       enable all with frame f_perc.
       process events.
    end.
    else do:
       run prgtec/btb/btb908ze.py (Input 1,
                                   Input v_des_percent_complete).
    end.

end.

procedure pi_abre_edit:

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.
    
    def var v_cod_key_value
        as character
        format "x(8)"
        no-undo.
    
    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or  v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end.
    
    os-command silent value(v_cod_key_value + chr(32) + p_cod_dwb_file).

end. 

procedure pi_message:

   def input param c_action    as char    no-undo.
   def input param i_msg       as integer no-undo.
   def input param c_param     as char    no-undo.

   def var c_prg_msg           as char    no-undo.

   assign c_prg_msg = "messages/"
                    + string(trunc(i_msg / 1000,0),"99")
                    + "/msg"
                    + string(i_msg, "99999").

   if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do:
      message "Mensagem nr. " i_msg "!!!" skip
              "Programa Mensagem" c_prg_msg "n∆o encontrado."
              view-as alert-box error.
      return error.
   end.

   run value(c_prg_msg + ".p") (input c_action, input c_param).
   return return-value.

end.

PROCEDURE pi_return_user:

    def output param p_nom_user  as character format "x(32)" no-undo.

    assign p_nom_user = v_cod_usuar_corren.
    if  v_cod_usuar_corren begins 'es_'
    then do:
       assign v_cod_usuar_corren = entry(2,v_cod_usuar_corren,"_").
    end.
END.

PROCEDURE pi_justificativa:


   


    ASSIGN v_cod_cta_ctbl_ini:SENSITIVE IN FRAME f_select= NO
           v_cod_cta_ctbl_fim:SENSITIVE IN FRAME f_select= NO. 


    ASSIGN v_cod_ccusto_ini:SENSITIVE IN FRAME f_select = NO
           v_cod_ccusto_fim:SENSITIVE IN FRAME f_select= NO.

END PROCEDURE.
