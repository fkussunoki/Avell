/******************************************************************************************************
**
**   Procedimento..........: dbgc201
**   Programa..............: dbgc201
**   Nome Externo..........: dop/dbgc201.p
**   Descricao.............: Consulta Or‡amento Espec¡fico
**   Criado por............: Gran Systems
**   Criado em.............: 20/11/2009
**   revisao...............: 16/10/2019
**                           Inserida coluna no Browse para totalizar Realizado + Empenhado (Flavio FKIS)             
******************************************************************************************************/

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

def stream s_1.

DEF BUFFER unid_negoc   FOR emsuni.unid_negoc.
DEF BUFFER b_cta_ctbl   FOR cta_ctbl.
DEF BUFFER modul_dtsul  FOR emsfnd.modul_dtsul.
DEF BUFFER usuar_univ   FOR emsuni.usuar_univ.
DEF BUFFER ccusto       FOR emsuni.ccusto.
DEF BUFFER usuar_mestre FOR emsfnd.usuar_mestre.

DEF NEW SHARED TEMP-TABLE tt_orcto_real
    FIELD cod_empresa           LIKE sdo_orcto_ctbl_bgc.cod_empresa
    FIELD cod_plano_ccusto      LIKE sdo_orcto_ctbl_bgc.cod_plano_ccusto
    FIELD cod_ccusto            LIKE sdo_orcto_ctbl_bgc.cod_ccusto
    FIELD cod_plano_cta_ctbl    LIKE sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl          LIKE sdo_orcto_ctbl_bgc.cod_cta_ctbl
    FIELD cod_cenar_ctbl        LIKE sdo_orcto_ctbl_bgc.cod_cenar_ctbl
    FIELD cod_exerc_ctbl        LIKE sdo_orcto_ctbl_bgc.cod_exerc_ctbl
    FIELD num_period_ctbl       LIKE sdo_orcto_ctbl_bgc.num_period_ctbl
    FIELD cod_cta_ctbl_pai      LIKE estrut_cta_ctbl.cod_cta_ctbl_pai
    FIELD cod_finalid_econ      LIKE sdo_ctbl.cod_finalid_econ
    FIELD ind_espec_cta_ctbl    LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD log_estrut            AS LOG
    FIELD des_cta_ctbl          LIKE cta_ctbl.des_tit_ctbl FORMAT "X(70)"
    FIELD val_ctbl              LIKE sdo_ctbl.val_sdo_ctbl_db
    FIELD val_ctbl_emp          LIKE sdo_ctbl.val_sdo_ctbl_db // Chamado 90242 - Inclu¡da coluna para exibir o Empenhado, que antes ia junto no Realizado
    FIELD val_ctbl_sdo          LIKE sdo_ctbl.val_sdo_ctbl_fim
    FIELD num_orig_movto_empenh LIKE orig_movto_empenh.num_orig_movto_empenh
    FIELD val_orcado            like sdo_orcto_ctbl_bgc.val_orcado
    FIELD val_orcado_sdo        LIKE sdo_orcto_ctbl_bgc.val_orcado_sdo
    FIELD val_perc              AS DEC
    FIELD val_perc_sdo          AS DEC
    FIELD des_period_bloq       AS CHAR
    FIELD dat_inicial           AS DATE
    FIELD dat_final             AS DATE
    INDEX tt_orcto_real_id      IS UNIQUE PRIMARY
          cod_plano_ccusto
          cod_ccusto
          cod_plano_cta_ctbl
          cod_cta_ctbl
          cod_cenar_ctbl
          cod_exerc_ctbl
          num_period_ctbl.

DEF BUFFER btt_orcto_real  FOR tt_orcto_real.

define temp-table tt_origem
    FIELD cod_empresa           LIKE sdo_orcto_ctbl_bgc.cod_empresa
    FIELD cod_plano_ccusto      LIKE sdo_orcto_ctbl_bgc.cod_plano_ccusto
    FIELD cod_ccusto            LIKE sdo_orcto_ctbl_bgc.cod_ccusto
    FIELD cod_plano_cta_ctbl    LIKE sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl          LIKE sdo_orcto_ctbl_bgc.cod_cta_ctbl
    FIELD cod_cenar_ctbl        LIKE sdo_orcto_ctbl_bgc.cod_cenar_ctbl
    FIELD cod_cta_ctbl_pai      LIKE estrut_cta_ctbl.cod_cta_ctbl_pai
    FIELD ind_origem            AS CHAR
    FIELD dat_inicial           AS date
    field num_orig_movto_empenh like orig_movto_empenh.num_orig_movto_empenh
    field val_movto_empenh      like orig_movto_empenh.val_movto_empenh.

/* e-mail */
DEF VAR v_des_para                AS CHAR FORMAT "x(200)" NO-UNDO.
DEF VAR v_des_copia               AS CHAR FORMAT "x(200)" NO-UNDO.

/* Temp-table da API BTB916ZA */
DEF NEW SHARED TEMP-TABLE tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer?ncia" column-label "Refer?ncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ?ncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist?ncia" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro                     as character format "x(10)" column-label "Cod Erro"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_arquivo                  as character format "x(255)"
    .

def temp-table tt_mail_fax no-undo
    field ttv_nom_servid                   as character format "x(30)"
    field ttv_num_porta_servid             as integer format ">>>>9"
    field ttv_log_exchange                 as logical format "Sim/NÆo" initial no
    field ttv_nom_from                     as character format "x(50)"
    field ttv_nom_to                       as character format "x(50)" label "To"
    field ttv_nom_cc                       as character format "x(50)" label "Cc"
    field ttv_nom_subject                  as character format "x(30)"
    field ttv_nom_message                  as character format "x(50)"
    field ttv_nom_attachfile               as character format "x(30)"
    field ttv_num_imptcia                  as integer format "9"
    field ttv_log_envda                    as logical format "Sim/NÆo" initial no
    field ttv_log_lida                     as logical format "Sim/NÆo" initial no
    field ttv_cod_format_mail              as character format "x(8)" initial "Texto"
    .

DEF TEMP-TABLE tt_param_bloq
    FIELD num_tip_inform       AS INT
    FIELD cod_inform           AS CHAR
    FIELD num_period_bloq      AS INT
    FIELD des_period_bloq      AS CHAR
    FIELD dat_inicial          AS DATE
    FIELD dat_final            AS DATE
    INDEX tt_id IS UNIQUE
          num_tip_inform
          cod_inform.

DEF TEMP-TABLE tt_ccusto LIKE emsuni.ccusto
    FIELD rec_ccusto         AS RECID 
    FIELD cod_format_ccusto  AS CHAR 
    INDEX tt_id IS PRIMARY UNIQUE 
          cod_empresa
          cod_plano_ccusto
          cod_ccusto.

DEF TEMP-TABLE tt_maximizacao NO-UNDO
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

DEF NEW GLOBAL SHARED VAR v_rec_empresa         AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_estabelecimento AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_modul_dtsul     AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_exerc_ctbl      AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_period_ctbl     AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_unid_negoc      AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_cenar_ctbl      AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_finalid_econ    AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_cta_ctbl  AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_cta_ctbl        AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_plano_ccusto    AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_ccusto          AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v-rec-dc-orc-grupo    AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_usuar_mestre    AS RECID NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar        like emsuni.empresa.cod_empresa  no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren        as char no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_dwb_user            as char no-undo.

DEF VAR l-implanta           AS LOGICAL NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.

DEF VAR wh_w_program         as WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_focus          as WIDGET-HANDLE NO-UNDO.
def var v_wgh_current_browse as WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_current_menu   AS WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_current_window AS WIDGET-HANDLE NO-UNDO.

def var v_cod_empresa               like emsuni.empresa.cod_empresa            no-undo.
def var v_cod_modul_dtsul           like emsfnd.modul_dtsul.cod_modul_dtsul    no-undo.
def var v_cod_estab_ini             like estabelecimento.cod_estab             no-undo.
def var v_cod_estab_fim             like estabelecimento.cod_estab init "ZZZ"  no-undo.
def var v_cod_unid_negoc_ini        like unid_negoc.cod_unid_negoc             no-undo.
def var v_cod_unid_negoc_fim        like unid_negoc.cod_unid_negoc init "ZZZ"  no-undo.
def var v_cod_cenar_ctbl            like cenar_ctbl.cod_cenar_ctbl             no-undo.
def var v_cod_exerc_ctbl            like exerc_ctbl.cod_exerc_ctbl             no-undo.
def var v_num_period_ctbl           like period_ctbl.num_period_ctbl INIT 1    no-undo.
def var v_cod_finalid_econ          like finalid_econ.cod_finalid_econ         no-undo.
def var v_cod_plano_cta_ctbl        like plano_cta_ctbl.cod_plano_cta_ctbl     no-undo.
def var v_cod_format_cta_ctbl       like plano_cta_ctbl.cod_format_cta_ctbl    no-undo.
def var v_cod_cta_ctbl              like cta_ctbl.cod_cta_ctbl init "00000000" no-undo.
DEF VAR v_des_cta_ctbl              LIKE cta_ctbl.des_tit_ctbl                 NO-UNDO.
def var v_cod_plano_ccusto          LIKE plano_ccusto.cod_plano_ccusto         no-undo.
def var v_cod_format_ccusto         LIKE plano_ccusto.cod_format_ccusto        no-undo.
def var v_cod_ccusto                LIKE ccusto.cod_ccusto                     NO-UNDO.
def var v_cod_ccusto_aux            LIKE v_cod_ccusto                          NO-UNDO.
DEF VAR v_des_ccusto                LIKE ccusto.des_tit_ctbl                   NO-UNDO.
DEF VAR v-cod-grupo                 LIKE dc-orc-grupo.cod-grupo                NO-UNDO.
def var v-cod-grupo-aux             LIKE v-cod-grupo                           NO-UNDO.
DEF VAR v-des-grupo                 LIKE dc-orc-grupo.descricao                NO-UNDO.
def var v_val_orcado                like sdo_cta_ctbl.val_sdo_ctbl_cr format "->>,>>>,>>9.99" no-undo.
def var v_val_realiz                like sdo_cta_ctbl.val_sdo_ctbl_cr format "->>,>>>,>>9.99" no-undo.
def var v_val_realiz_emp            like sdo_cta_ctbl.val_sdo_ctbl_cr format "->>,>>>,>>9.99" no-undo.
def var v_val_orcado_sdo            like sdo_cta_ctbl.val_sdo_ctbl_db format "->>>,>>>,>>9.99" no-undo.
def var v_val_realiz_sdo            like sdo_cta_ctbl.val_sdo_ctbl_cr format "->>>,>>>,>>9.99" no-undo.


DEF VAR v_log_acum                  AS LOG FORMAT "Sim/NÆo" VIEW-AS TOGGLE-BOX
                                       LABEL "Realizado Acumulado" NO-UNDO.

def var v_dat_inicial               as date format "99/99/9999"               no-undo.
def var v_dat_final                 as date format "99/99/9999"               no-undo.

DEF VAR v_rec_vers_orcto_ctbl_bgc   AS RECID NO-UNDO.
DEF VAR v_rec_tt_orcto_real         AS RECID NO-UNDO.
DEF VAR v_cod_unid_orctaria         AS CHAR NO-UNDO.
DEF VAR v_cod_cenar_orctario        AS CHAR NO-UNDO.
DEF VAR v_arq_email                 AS CHAR NO-UNDO.
DEF VAR v_arq_plan                  AS CHAR NO-UNDO.
DEF VAR v_num_seq_orcto_ctbl        AS INT  NO-UNDO.
DEF VAR v_num                       AS INT  NO-UNDO.

DEF VAR v_log_segur                 AS LOG NO-UNDO.
DEF VAR v_log_run                   AS LOG INIT YES NO-UNDO.
def var v_arq_out                   as char format "x(40)" no-undo.

def var v_num_cont                  as int  no-undo.
def var v_val_max                   as dec  no-undo.
def var v_val_curr                  as dec  no-undo.

DEF VAR cc-plano         AS CHAR    NO-UNDO.
{doinc/dsg998.i} /* SugestÆo cc-plano conforme empresa */

def var v_des_percent_complete
    as character
    format "x(06)"
    no-undo.
def var v_des_percent_complete_fnd
    as character
    format "x(08)"
    no-undo.

def rectangle rt_005
  size 46.79 by 1.92
  edge-pixels 2.

def rectangle rt_rgf
    size 125.72 by 1.29
    edge-pixels 2.
def rectangle rt_key
    size 124.22 by 2.50
    edge-pixels 2.

def button bt_can2
    label "Cancela"
    tooltip "Cancela"
    size 10 by 1.
def button bt_ent
    label "Entra" tooltip "Entra"
    image-up file "image/im-enter"
    image-insensitive file "image/ii-enter"
    size 4.5 by 1.15
    AUTO-GO.

def button bt_contr
    label "Contrai" tooltip "Contrai Estrutura"
    image-up file "image/im-cllps"
    image-insensitive file "image/ii-cllps"
    size 4.5 by 1.3.
def button bt_expan
    label "Expande" tooltip "Expande Estrutura"
    image-up file "image/im-expan"
    image-insensitive file "IMAGE/ii-expan"
    size 4.5 by 1.3.

def button bt_det
    label "Det"
    tooltip "Detalhe"
    image-up file "image/im-det"
    image-insensitive file "image/ii-det"
    size 4.00 by 1.13.
def button bt_exi
    label "Sa¡da"
    tooltip "Sa¡da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 4.00 by 1.13
    auto-go.
def button bt_fil
    label "Fil"
    tooltip "Filtro"
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
    size 4.00 by 1.13.
def button bt_fir
    label "<<"
    tooltip "Primeira Ocorrˆncia da Tabela"
    image-up file "image/im-fir"
    image-insensitive file "image/ii-fir"
    size 4.00 by 1.13.
def button bt_hel1
    label " ?"
    tooltip "Ajuda"
    image-up file "image/im-hel"
    image-insensitive file "image/ii-hel"
    size 4.00 by 1.13.
def button bt_las
    label ">>"
    tooltip "éltima Ocorrˆncia da Tabela"
    image-up file "image/im-las"
    image-insensitive file "image/ii-las"
    size 4.00 by 1.13.
def button bt_nex
    label ">"
    tooltip "Pr¢xima Ocorrˆncia da Tabela"
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
    size 4.00 by 1.13.
def button bt_pre
    label "<"
    tooltip "Ocorrˆncia Anterior da Tabela"
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
    size 4.00 by 1.13.
def button bt_pri
    label "Imp"
    tooltip "Imprime"
    image-up file "image/im-pri"
    image-insensitive file "image/ii-pri.bmp"
    size 4.00 by 1.13.
def button bt_ran
    label "Faixa"
    tooltip "Faixa"
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
    size 4.00 by 1.13.
def button bt_send
    label "Enc"
    tooltip "Encaminha"
    image-up file "image/im-send"
    image-insensitive file "image/ii-send"
    size 4.00 by 1.13.
def button bt_tot
    label "Tot"
    tooltip "Totais"
    image-up file "image/im-tot"
    image-insensitive file "image/ii-tot"
    size 4.00 by 1.13.

def button bt_zoo_cc
    label "Zoom Centro Custo"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.    
def button bt_zoo_grp
    label "Zoom Grupo de Contas"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.00.
def button bt_zoo_estini
    label "Zoom Estab Inicial"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.
def button bt_zoo_estfim
    label "Zoom Estab Final"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.
def button bt_zoo_exerc
    label "Zoom Exerc¡cio"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.
def button bt_zoo_unegini
    label "Zoom Unid Negoc Inicial"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.
def button bt_zoo_unegfim
    label "Zoom Unid Negoc Final"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by 1.10.

def frame f_perc
    rt_005
         at row 01.29 col 02.00 bgcolor 17
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
         font 1 fgcolor ? bgcolor 17
         title "".
def query qr_orcto for tt_orcto_real.
def browse br_orcto query qr_orcto
    display tt_orcto_real.des_cta_ctbl    column-label "Conta Cont bil" FORMAT "x(65)"
            tt_orcto_real.val_orcado      column-label "Or‡ado"      format "->>>,>>>,>>9.99"
            tt_orcto_real.val_ctbl        column-label "Realizado"   format "->>>,>>>,>>9.99"
            tt_orcto_real.val_ctbl_emp    column-label "Empenhado"   format "->>>,>>>,>>9.99"
            (tt_orcto_real.val_ctbl + tt_orcto_real.val_ctbl_emp)       COLUMN-LABEL "Real + Empen" format "->>>,>>>,>>9.99" 
            tt_orcto_real.val_perc        column-label "% Utz"       format "->,>>9.99"
            tt_orcto_real.val_orcado_sdo  column-label "Or‡ado Acum" format "->,>>>,>>>,>>9.99"
            tt_orcto_real.val_ctbl_sdo    column-label "Real Acum"   format "->,>>>,>>>,>>9.99"
            tt_orcto_real.val_perc_sdo    column-label "% Utz Acum"  format "->,>>9.99"
            tt_orcto_real.ind_espec_cta_ctbl COLUMN-LABEL "Esp‚cie"
            tt_orcto_real.des_period_bloq COLUMN-LABEL "Period Bloq" FORMAT "X(12)"
            tt_orcto_real.dat_inicial     COLUMN-LABEL "Data Inic"   FORMAT "99/99/9999"
            tt_orcto_real.dat_final       COLUMN-LABEL "Data Final"  FORMAT "99/99/9999"
            with size 116 by 15.70 separators font 1 bgcolor 15.

DEF VAR val_total AS HANDLE.
DEF VAR rs_pesq AS INTEGER 
    VIEW-AS RADIO-SET VERTICAL
    RADIO-BUTTONS "Centro de Custo", 1,"Grupo OBZ", 2
    SIZE 14 BY 2 NO-UNDO.


def frame f_main
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    bt_fir
         at row 01.08 COL 01.14 font ?
         help "Primeira Ocorrˆncia da Tabela"
    bt_pre
         at row 01.08 col 05.14 font ?
         help "Ocorrˆncia Anterior da Tabela"
    bt_nex
         at row 01.08 col 09.14 font ?
         help "Pr¢xima Ocorrˆncia da Tabela"
    bt_las
         at row 01.08 col 13.14 font ?
         help "éltima Ocorrˆncia da Tabela"
    bt_det
         at row 01.08 col 18.14 font ?
         help "Detalhe"
    bt_ran
         at row 01.08 col 22.14 font ?
         help "Faixa"
    bt_fil
         at row 01.08 col 26.14 font ?
         help "Filtro"
    bt_pri
         at row 01.08 col 31.14 font ?
         help "Imprime"
    bt_send
         at row 01.08 col 36.14 font ?
         help "Encaminha"
    bt_exi
         at row 01.08 col 118.57 font ?
         help "Sa¡da"
    bt_hel1
         at row 01.08 col 122.57 font ?
         help "Ajuda"
    rt_key
        at row 02.50 col 02.00
    rs_pesq 
         AT ROW 2.70 COL 6 NO-LABEL WIDGET-ID 8
    v_cod_ccusto
         at row 02.70 col 36.00 COLON-ALIGNED
         view-as fill-in
         size-chars 8.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_cc
         at row 02.63 col 40.14
    v_des_ccusto
         at row 02.70 col 50.5 NO-LABEL
         view-as fill-in 
         size-chars 43.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    v-cod-grupo
         at row 02.70 col 36.00 COLON-ALIGNED
         view-as fill-in
         size-chars 12.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_grp
         at row 02.63 col 50.14
    v-des-grupo
         at row 02.70 col 54.50 NO-LABEL
         view-as fill-in 
         size-chars 43.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    v_cod_exerc_ctbl
         at row 03.80 col 36.00 colon-aligned label "Exerc¡cio"
         view-as fill-in
         size-chars 5.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_exerc
         at row 03.70 col 43.14
    v_num_period_ctbl
         at row 03.80 col 50.00 colon-aligned label "Per"
         view-as fill-in
         size-chars 3.14 by 0.88
         fgcolor ? bgcolor 15 font 2
    bt_ent
         at row 03.65 col 55.24     
    br_orcto 
        at row 05.30 col 02.00
    bt_expan
        at row 07.30 col 120.24     
    bt_contr
        at row 08.60 col 120.24     
    v_val_realiz  
        at row 21.20 col 53.20 LABEL "Realizado"
        view-as fill-in SIZE 12 BY 0.88
        fgcolor ? bgcolor 15 font 1
    v_val_realiz_emp
        at row 21.20 col 72.60 NO-LABEL
        view-as fill-in SIZE 12 BY 0.88
        fgcolor ? bgcolor 15 font 1
    v_val_orcado label "Total"
        at row 21.20 col 44.60 
        view-as fill-in SIZE 12 BY 0.88
        fgcolor ? bgcolor 15 font 1
    v_val_realiz_sdo LABEL "Realiz Acum" 
        at row 21.20 col 95.30 
        view-as fill-in SIZE 13.3 BY 0.88
        fgcolor ? bgcolor 15 font 1
    v_val_orcado_sdo LABEL "Acum"
        at row 21.20 col 86.70 
        view-as fill-in SIZE 13.3 BY 0.88
        fgcolor ? bgcolor 15 font 1
    with 1 down side-labels no-validate keep-tab-order three-d 
        size-char 126.00 by 22.10 
        at row 01.13 col 01.00 
        font 1 fgcolor ? bgcolor 8 
        title "Consulta Or‡ado X Realizado - DBGC201 - 12.00.00.000".

ASSIGN val_total = br_orcto:GET-BROWSE-COLUMN(5).

{include/i_fclfrm.i f_main}
        
def sub-menu  mi_table
    menu-item mi_fir               label "Primeiro"        accelerator "ALT-HOME"
    menu-item mi_pre               label "Anterior"        accelerator "ALT-CURSOR-LEFT"
    menu-item mi_nex               label "Pr¢ximo"         accelerator "ALT-CURSOR-RIGHT"
    menu-item mi_las               label "éltimo"          accelerator "ALT-END"
    RULE
    menu-item mi_det               label "Detalhe"         accelerator "ALT-D"
    menu-item mi_sea               label "Pesquisa"        accelerator "ALT-Z"
    RULE
    menu-item mi_ran               label "Faixa"
    menu-item mi_fil               label "Filtro"
    RULE
    menu-item mi_rli               label "Relat¢rios"
    RULE
    menu-item mi_exi               label "Sa¡da".

def sub-menu  mi_hel
    menu-item mi_contents          label "Conte£do"
    RULE
    menu-item mi_about             label "Sobre".

def menu      m_main                menubar
    sub-menu  mi_table              label "Arquivo"
    sub-menu  mi_hel                label "Ajuda".

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
           resize               = no
           scroll-bars          = no
           status-area          = yes
           status-area-font     = ?
           message-area         = no
           message-area-font    = ?
           fgcolor              = ?
           bgcolor              = ?.

{include/i_fclwin.i wh_w_program}

ON WINDOW-MAXIMIZED OF wh_w_program DO:
def var v_whd_widget as widget-handle no-undo.
assign frame f_main:width-chars  = wh_w_program:width-chars
       frame f_main:height-chars = wh_w_program:height-chars no-error.

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

end.

ON WINDOW-RESTORED OF wh_w_program DO:

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

end.

ON ENTRY OF wh_w_program DO:

    def var v_whd_field_group   as widget-handle no-undo.
    def var v_whd_widget        as widget-handle no-undo.
    def buffer b_tt_maximizacao for tt_maximizacao.

    find first tt_maximizacao no-error.
    if not avail tt_maximizacao then do:
        assign v_whd_field_group = frame f_main:first-child.
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
                assign tt_maximizacao.frame-width-original   = frame f_main:width.
                assign tt_maximizacao.frame-height-original  = frame f_main:height.
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
    assign wh_w_program:max-width-chars  = 300 
           wh_w_program:max-height-chars = 300.

    if  valid-handle (wh_w_program)
    then do:
        assign current-window = wh_w_program:handle.
    END.

END.

on choose of bt_can2 in frame f_perc do:
   hide frame f_perc no-pause.
   STOP.
end.

ON WINDOW-CLOSE OF wh_w_program DO:

    apply "choose" to bt_exi in frame f_main.

END.

ON CHOOSE OF bt_fir IN FRAME f_main DO:
      
    FIND FIRST tt_ccusto NO-LOCK NO-ERROR.
    IF avail tt_ccusto then do:
        assign v_rec_ccusto = tt_ccusto.rec_ccusto
               v_cod_ccusto = tt_ccusto.cod_ccusto
               v_des_ccusto = tt_ccusto.des_tit_ctbl.
        display v_cod_ccusto
                v_des_ccusto
                with frame f_main.
        apply "leave" to v_num_period_ctbl in frame f_main.
        apply "choose" to bt_ent in frame f_main.
    end.
   
END.

ON CHOOSE OF bt_pre IN FRAME f_main DO:
      
    FIND PREV tt_ccusto NO-LOCK 
        WHERE tt_ccusto.cod_empresa      = v_cod_empresa
          AND tt_ccusto.cod_plano_ccusto = v_cod_plano_ccusto 
          AND tt_ccusto.cod_ccusto       < v_cod_ccusto NO-ERROR.
    IF AVAIL tt_ccusto THEN DO:
        ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
               v_cod_ccusto = tt_ccusto.cod_ccusto
               v_des_ccusto = tt_ccusto.des_tit_ctbl.
        DISPLAY v_cod_ccusto
                v_des_ccusto
                WITH FRAME f_main.
        APPLY "leave" TO v_num_period_ctbl IN FRAME f_main.
        APPLY "choose" TO bt_ent IN FRAME f_main.
    end.
    ELSE
        MESSAGE "Primeira ocorrˆncia da tabela" VIEW-AS ALERT-BOX WARNING. 
   
END.

ON CHOOSE OF bt_nex IN FRAME f_main DO:
      
    FIND NEXT tt_ccusto NO-LOCK 
        WHERE tt_ccusto.cod_empresa      = v_cod_empresa
          AND tt_ccusto.cod_plano_ccusto = v_cod_plano_ccusto 
          AND tt_ccusto.cod_ccusto       > v_cod_ccusto NO-ERROR.
    IF AVAIL tt_ccusto THEN DO:
        ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
               v_cod_ccusto = tt_ccusto.cod_ccusto
               v_des_ccusto = tt_ccusto.des_tit_ctbl.
        DISPLAY v_cod_ccusto
                v_des_ccusto
                WITH FRAME f_main.
        APPLY "leave" TO v_num_period_ctbl IN FRAME f_main.
        APPLY "choose" TO bt_ent IN FRAME f_main.
    END.
    ELSE
        MESSAGE "éltima ocorrˆncia da tabela" VIEW-AS ALERT-BOX WARNING.
   
END.

ON CHOOSE OF bt_las IN FRAME f_main DO:
      
    FIND LAST tt_ccusto NO-LOCK NO-ERROR.
    IF AVAIL tt_ccusto THEN DO:
        ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
               v_cod_ccusto = tt_ccusto.cod_ccusto
               v_des_ccusto = tt_ccusto.des_tit_ctbl.
        DISPLAY v_cod_ccusto
                v_des_ccusto
                WITH  FRAME f_main.
        APPLY "leave" TO v_num_period_ctbl IN FRAME f_main.
        APPLY "choose" TO bt_ent IN FRAME f_main.
    END.
   
end.

ON CHOOSE OF bt_ent IN FRAME f_main DO:

    
    ASSIGN v_val_orcado     = 0
           v_val_realiz     = 0
           v_val_realiz_emp = 0
           v_val_orcado_sdo = 0
           v_val_realiz_sdo = 0.
    CLOSE QUERY qr_orcto.
    DISPLAY br_orcto
            v_val_orcado
            v_val_realiz
            v_val_realiz_emp
            v_val_orcado_sdo
            v_val_realiz_sdo
            WITH FRAME f_main.

    ASSIGN v_num_period_ctbl = INPUT FRAME f_main v_num_period_ctbl.

    FIND period_ctbl NO-LOCK
        WHERE period_ctbl.cod_cenar_ctbl  = v_cod_cenar_ctbl
          AND period_ctbl.cod_exerc_ctbl  = v_cod_exerc_ctbl
          AND period_ctbl.num_period_ctbl = v_num_period_ctbl NO-ERROR.
    IF NOT AVAIL period_ctbl THEN DO:
       assign v_wgh_focus = v_num_period_ctbl:handle in frame f_main.
       message "Per¡odo Cont bil inexistente!" view-as alert-box error.
       return NO-APPLY.
    END.
    ELSE DO:
        ASSIGN v_rec_period_ctbl = RECID (period_ctbl)
                v_dat_inicial     = period_ctbl.dat_inic_period_ctbl
                v_dat_final       = period_ctbl.dat_fim_period_ctbl.
        RUN pi_vers_orcto_ctbl_bgc.
        IF v_rec_vers_orcto_ctbl_bgc = ? THEN DO:
            MESSAGE "NÆo existe VersÆo de Or‡amento Aprovada para " SKIP
                    "este Cen rio Orct rio: " v_cod_cenar_orctario SKIP
                    "nesta   Unid  Orctaria: " v_cod_unid_orctaria SKIP
                    "para  este Or‡amento: " v_num_seq_orcto_ctbl "!"
                    VIEW-AS ALERT-BOX WARNING.
           RETURN NO-APPLY.
        END.
        /* Per¡odo de Bloqueio */
        RUN pi_tt_param_bloq.
        ASSIGN v_log_run = YES.
    END.

END.

ON CHOOSE OF bt_det IN FRAME f_main DO:

    DEFINE VARIABLE h-aux AS HANDLE      NO-UNDO.

    IF AVAIL tt_orcto_real THEN DO:
        ASSIGN h-aux = CURRENT-WINDOW:HANDLE.
        ASSIGN h-aux:SENSITIVE = NO.
        ASSIGN v_rec_tt_orcto_real = RECID (tt_orcto_real).
        RUN dop/dbgc201a.p (INPUT v_rec_tt_orcto_real,
                            INPUT v_cod_unid_orctaria,
                            INPUT v_cod_estab_ini,
                            INPUT v_cod_estab_fim,
                            INPUT v_cod_unid_negoc_ini,
                            INPUT v_cod_unid_negoc_fim,
                            INPUT v_cod_format_cta_ctbl,
                            INPUT v_log_acum).
        ASSIGN h-aux:SENSITIVE = YES.
    END.
    ELSE
        RETURN NO-APPLY.

    ENABLE ALL WITH FRAME f_main.
    if rs_pesq = 2 then do:
        disable bt_contr
                with frame f_main.
    end.
    apply "value-changed" to rs_pesq in frame f_main.
    APPLY "ENTRY" TO v_wgh_focus.

END.

ON CHOOSE OF bt_zoo_grp IN FRAME f_main 
OR F5 OF v-cod-grupo IN FRAME f_main /* Grupo OBZ */ DO:

    RUN pi_sea_grupo.
    if v-cod-grupo-aux <> "" then do:
        FIND FIRST dc-orc-grupo NO-LOCK
            WHERE dc-orc-grupo.cod-grupo = v-cod-grupo-aux NO-ERROR.
        ASSIGN v-cod-grupo:SCREEN-VALUE IN FRAME f_main = dc-orc-grupo.cod-grupo
               v-des-grupo:SCREEN-VALUE IN FRAME f_main = dc-orc-grupo.descricao.
        apply "leave" to v-cod-grupo in frame f_main.
        apply "entry" to v-cod-grupo in frame f_main.
    end.
    
END.

ON LEAVE OF v-cod-grupo IN FRAME f_main /* Grupo OBZ */DO:

  ASSIGN INPUT FRAME f_main v-cod-grupo.

  IF v-cod-grupo = "" THEN
      RETURN 'NOK'.

  IF NOT CAN-FIND(FIRST dc-orc-grupo NO-LOCK
                  WHERE dc-orc-grupo.cod-grupo = v-cod-grupo) THEN DO:
      RUN dop/MESSAGE.p ("Grupo OBZ inexistente!",
                         "").
      RETURN 'NOK'.
  END.

  IF NOT CAN-FIND(FIRST dc-orc-grupo-usuar 
                  WHERE dc-orc-grupo-usuar.cod-grupo   = v-cod-grupo
                    AND dc-orc-grupo-usuar.cod_usuario = v_cod_usuar_corren) THEN DO:
      RUN dop/MESSAGE.p ("Usu rio sem permissÆo para o grupo informado!",
                        "").
      ASSIGN v-cod-grupo = ""
             v-des-grupo = "".
      DISP v-cod-grupo
           v-des-grupo
           WITH FRAME f_main.
      RETURN 'NOK'.

  END.
  
  FIND FIRST dc-orc-grupo NO-LOCK
      WHERE dc-orc-grupo.cod-grupo = v-cod-grupo NO-ERROR.
  if avail dc-orc-grupo then do:
      assign v-rec-dc-orc-grupo = recid (dc-orc-grupo)
             v-des-grupo        = dc-orc-grupo.descricao.
  end.
  else do:
      assign v-rec-dc-orc-grupo = ?
             v-des-grupo        = "".
  end.
  display v-des-grupo
          with frame f_main.
  

END.


ON VALUE-CHANGED OF rs_pesq IN FRAME f_main DO:

  if INPUT FRAME f_main rs_pesq <> rs_pesq then do:
     empty temp-table tt_orcto_real.
     run pi_open_query.  
  end.
   
  ASSIGN INPUT FRAME f_main rs_pesq.

  CASE rs_pesq:
      WHEN 1 THEN DO:
          ASSIGN bt_expan:sensitive      = yes
                 v_cod_ccusto:VISIBLE    = YES
                 v_cod_ccusto:SENSITIVE  = YES
                 v_des_ccusto:VISIBLE    = YES
                 bt_zoo_cc:VISIBLE       = YES
                 bt_zoo_cc:SENSITIVE     = YES
                 v-cod-grupo:VISIBLE     = NO
                 v-cod-grupo:SENSITIVE   = NO
                 v-des-grupo:VISIBLE     = NO
                 bt_zoo_grp:VISIBLE      = NO
                 bt_zoo_grp:SENSITIVE    = NO.
          find ccusto no-lock
             where recid (ccusto) = v_rec_ccusto no-error.
          if avail ccusto then do:
              assign v_cod_ccusto = ccusto.cod_ccusto
                     v_des_ccusto = ccusto.des_tit_ctbl.
          end.
          else do:
              assign v_rec_ccusto = ?
                     v_cod_ccusto = ""
                     v_des_ccusto = "".
          end.
          display v_cod_ccusto
                  v_des_ccusto WITH FRAME f_main.
      END.
      WHEN 2 THEN DO:
          ASSIGN bt_expan:sensitive      = no
                 v_cod_ccusto:VISIBLE    = NO
                 v_cod_ccusto:SENSITIVE  = NO
                 v_des_ccusto:VISIBLE    = NO
                 bt_zoo_cc:VISIBLE       = NO
                 bt_zoo_cc:SENSITIVE     = NO
                 v-cod-grupo:VISIBLE     = YES
                 v-cod-grupo:SENSITIVE   = YES
                 v-des-grupo:VISIBLE     = YES
                 bt_zoo_grp:VISIBLE      = YES
                 bt_zoo_grp:SENSITIVE    = YES.
          find dc-orc-grupo no-lock
             where recid (dc-orc-grupo) = v-rec-dc-orc-grupo no-error.
          if avail dc-orc-grupo then do:
              assign v-cod-grupo = dc-orc-grupo.cod-grupo
                     v-des-grupo = dc-orc-grupo.descricao.
          end.
          else do:
              assign v-rec-dc-orc-grupo = ?
                     v-cod-grupo        = ""
                     v-des-grupo        = "".
          end.
          display v-cod-grupo
                  v-des-grupo WITH FRAME f_main.
      END.
  END CASE.
  
END.

on choose of bt_zoo_cc in frame f_main 
or F5 of v_cod_ccusto in frame f_main do:
        
    RUN pi_sea_ccusto.
    if v_cod_ccusto_aux <> "" then do:
        FIND FIRST tt_ccusto NO-LOCK
            WHERE tt_ccusto.cod_ccusto = v_cod_ccusto_aux NO-ERROR.
        ASSIGN v_cod_ccusto:SCREEN-VALUE IN FRAME f_main = tt_ccusto.cod_ccusto
               v_des_ccusto:SCREEN-VALUE IN FRAME f_main = tt_ccusto.des_tit_ctbl.
        apply "leave" to v_cod_ccusto in frame f_main.
        apply "entry" to v_cod_ccusto in frame f_main.
    end.
end.

on leave of v_cod_ccusto in frame f_main do:

    IF INPUT FRAME f_main v_cod_ccusto <> "" THEN DO:
    
        FIND FIRST tt_ccusto no-lock
            WHERE tt_ccusto.cod_empresa      = v_cod_empresa
              AND tt_ccusto.cod_plano_ccusto = v_cod_plano_ccusto 
              AND tt_ccusto.cod_ccusto       = INPUT FRAME f_main v_cod_ccusto no-error.
        if avail tt_ccusto then do:
            ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
                   v_cod_ccusto = tt_ccusto.cod_ccusto
                   v_des_ccusto = tt_ccusto.des_tit_ctbl.
        end.
        else do:
            assign v_rec_ccusto = ?
                   v_des_ccusto = "".
        end.
        DISPLAY v_des_ccusto
                WITH FRAME f_main.
    END.

end.

on choose of bt_zoo_exerc in frame f_main 
or F5 of v_cod_exerc_ctbl in frame f_main do:

    if  search("prgint/utb/utb075ka.r") = ? and search("prgint/utb/utb075ka.p") = ? then do:
        message "Programa execut vel nÆo foi encontrado:"  "prgint/utb/utb075ka.p"
               view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb075ka.p.
    if  v_rec_exerc_ctbl <> ? then do:
        find exerc_ctbl
          where recid(exerc_ctbl) = v_rec_exerc_ctbl no-lock no-error.
        assign v_cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
               v_cod_exerc_ctbl:screen-value in frame f_main = exerc_ctbl.cod_exerc_ctbl.
        apply "leave" to v_cod_exerc_ctbl in frame f_main.
        apply "entry" to v_cod_exerc_ctbl in frame f_main.
    end.

end.

on leave of v_cod_exerc_ctbl in frame f_main do:
    
    find exerc_ctbl no-lock
        where exerc_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
          and exerc_ctbl.cod_exerc_ctbl = input frame f_main v_cod_exerc_ctbl no-error.
    if avail exerc_ctbl then do:
        assign v_rec_exerc_ctbl = recid (exerc_ctbl).
    end.
    else do:
        assign v_rec_exerc_ctbl = ?.               
    end.

end.

on leave of v_num_period_ctbl in frame f_main do:
    
    find period_ctbl no-lock
        where period_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
          and period_ctbl.cod_exerc_ctbl = v_cod_exerc_ctbl
          AND period_ctbl.num_period_ctbl = INPUT FRAME f_main v_num_period_ctbl no-error.
    if avail period_ctbl then do:
        assign v_rec_period_ctbl = recid (period_ctbl)
               v_dat_inicial     = period_ctbl.dat_inic_period_ctbl
               v_dat_final       = period_ctbl.dat_fim_period_ctbl.
    end.
    else do:
        assign v_rec_exerc_ctbl = ?.               
    end.

end.

ON CHOOSE OF bt_fil IN FRAME f_main DO:
    
    DEF VAR v_cod_cenar_ctbl_aux    AS char NO-UNDO.
    DEF VAR v_cod_exerc_ctbl_aux    AS char NO-UNDO.
    DEF VAR v_cod_finalid_econ_aux  AS char NO-UNDO.

    RUN pi_filtro.

END.

ON CHOOSE OF bt_ran IN FRAME f_main DO:
    
    def var v_cod_estab_ini_aux as char no-undo.
    def var v_cod_estab_fim_aux as char no-undo.
    def var v_cod_unid_negoc_ini_aux as char no-undo.
    def var v_cod_unid_negoc_fim_aux as char no-undo.    
    
    assign v_cod_estab_ini_aux      = v_cod_estab_ini
           v_cod_estab_fim_aux      = v_cod_estab_fim
           v_cod_unid_negoc_ini_aux = v_cod_unid_negoc_ini
           v_cod_unid_negoc_fim_aux = v_cod_unid_negoc_fim.
    
    RUN pi_range.
    IF v_cod_estab_ini_aux      <> v_cod_estab_ini 
    OR v_cod_estab_fim_aux      <> v_cod_estab_fim
    or v_cod_unid_negoc_ini_aux <> v_cod_unid_negoc_ini 
    OR v_cod_unid_negoc_fim_aux <> v_cod_unid_negoc_fim THEN DO:
        APPLY "choose" TO bt_ent IN FRAME f_main.
    END.

end.

ON VALUE-CHANGED OF br_orcto IN FRAME f_main DO:

    DISABLE bt_det
            WITH FRAME f_main.
    
    IF AVAIL tt_orcto_real THEN DO:
        IF tt_orcto_real.cod_cta_ctbl_pai <> "" THEN
            ENABLE bt_det
                   WITH FRAME f_main.
    END.

END.

ON DEFAULT-ACTION OF br_orcto IN FRAME f_main DO:

   
   DEF VAR v_cod_cta_ctbl_aux   LIKE cta_ctbl.cod_cta_ctbl NO-UNDO.

   IF AVAIL tt_orcto_real THEN DO:
      ASSIGN v_rec_tt_orcto_real = RECID (tt_orcto_real)
             v_cod_cta_ctbl_aux  = tt_orcto_real.cod_cta_ctbl.
      FIND FIRST btt_orcto_real NO-LOCK
          WHERE btt_orcto_real.cod_cta_ctbl_pai = v_cod_cta_ctbl_aux NO-ERROR.
      IF AVAIL btt_orcto_real THEN DO:
          DISABLE bt_det
                  WITH FRAME f_main.             
          FOR EACH btt_orcto_real EXCLUSIVE-LOCK
              WHERE btt_orcto_real.cod_cta_ctbl_pai = v_cod_cta_ctbl_aux:           
              IF RECID (btt_orcto_real) <> v_rec_tt_orcto_real THEN DO:
                  IF btt_orcto_real.log_estrut = NO THEN DO:
                      ASSIGN btt_orcto_real.log_estrut = YES.
                  END.                 
                  ELSE DO:
                      ASSIGN btt_orcto_real.log_estrut = NO.
                      RUN pi_contrair (INPUT btt_orcto_real.cod_cta_ctbl).                 
                  END.                 
              END.
          END.
          RUN pi_open_query.
          REPOSITION qr_orcto
                TO RECID v_rec_tt_orcto_real NO-ERROR.
      END.
      ELSE DO:
          ENABLE bt_det
                 WITH FRAME f_main.      
      END.
   END.
   
END.

ON mouse-select-dblclick OF br_orcto IN FRAME f_main DO:

    IF bt_det:SENSITIVE IN FRAME f_main = YES THEN DO:
        APPLY "CHOOSE" TO bt_det IN FRAME f_main.
    END.
    ELSE 
        RETURN NO-APPLY.

END.

ON CHOOSE OF bt_expan IN FRAME f_main DO:

    FOR EACH tt_orcto_real EXCLUSIVE-LOCK
        WHERE tt_orcto_real.cod_cta_ctbl_pai <> "":    
        IF tt_orcto_real.log_estrut = NO THEN DO:
            ASSIGN tt_orcto_real.log_estrut = YES.
        END.
    END.
    RUN pi_open_query.
    if rs_pesq = 1 then do:        
        DISABLE bt_expan
                WITH FRAME f_main.
        ENABLE bt_contr
               WITH FRAME f_main.
    end.

END.

ON CHOOSE OF bt_contr IN FRAME f_main DO:


    FOR EACH tt_orcto_real EXCLUSIVE-LOCK
        WHERE tt_orcto_real.cod_cta_ctbl_pai <> "":           
    
        IF tt_orcto_real.log_estrut = YES THEN DO:
            ASSIGN tt_orcto_real.log_estrut = NO.
        END.
    END.
    RUN pi_open_query.
    if rs_pesq = 1 then do:    
        DISABLE bt_contr
                WITH FRAME f_main.
        ENABLE bt_expan
               WITH FRAME f_main.
    end.
    

END.


ON ROW-DISPLAY OF br_orcto IN FRAME f_main DO:
   
   if avail tt_orcto_real then do:
       IF tt_orcto_real.val_perc > 90 THEN DO:
           IF tt_orcto_real.val_perc > 100 THEN DO:
               ASSIGN tt_orcto_real.val_ctbl    :bgcolor in browse br_orcto = 12
                      tt_orcto_real.val_ctbl_emp:bgcolor in browse br_orcto = 12
                      tt_orcto_real.val_ctbl    :fgcolor in browse br_orcto = 15
                      tt_orcto_real.val_ctbl_emp:fgcolor in browse br_orcto = 15
                      tt_orcto_real.val_perc    :bgcolor in browse br_orcto = 12
                      tt_orcto_real.val_perc    :fgcolor in browse br_orcto = 15
                      val_total   :BGCOLOR = 12 
                      val_total   :fgcolor = 15. 
               
           END.
           ELSE DO:
               ASSIGN tt_orcto_real.val_ctbl    :bgcolor in browse br_orcto = 14
                      tt_orcto_real.val_ctbl_emp:bgcolor in browse br_orcto = 14
                      tt_orcto_real.val_ctbl    :fgcolor in browse br_orcto = ?
                      tt_orcto_real.val_ctbl_emp:fgcolor in browse br_orcto = ?
                      tt_orcto_real.val_perc    :bgcolor in browse br_orcto = 14
                      tt_orcto_real.val_perc    :fgcolor in browse br_orcto = ?
                      val_total   :bgcolor = 14 
                      val_total   :fgcolor = ?. 

           END.
       END.
       ELSE DO:
           ASSIGN tt_orcto_real.val_ctbl    :bgcolor in browse br_orcto = 15
                  tt_orcto_real.val_ctbl_emp:bgcolor in browse br_orcto = 15
                  tt_orcto_real.val_ctbl    :fgcolor in browse br_orcto = ?
                  tt_orcto_real.val_ctbl_emp:fgcolor in browse br_orcto = ?
                  tt_orcto_real.val_perc    :bgcolor in browse br_orcto = 15
                  tt_orcto_real.val_perc    :fgcolor in browse br_orcto = ?
                  val_total   :bgcolor  = 15 
                  val_total   :fgcolor  = ?. 

       END.
       IF tt_orcto_real.val_perc_sdo > 90 THEN DO:
           IF tt_orcto_real.val_perc_sdo > 100 THEN DO:
               ASSIGN tt_orcto_real.val_ctbl_sdo:bgcolor in browse br_orcto = 12
                      tt_orcto_real.val_ctbl_sdo:fgcolor in browse br_orcto = 15
                      tt_orcto_real.val_perc_sdo:bgcolor in browse br_orcto = 12
                      tt_orcto_real.val_perc_sdo:fgcolor in browse br_orcto = 15.


           END.
           ELSE DO:
               ASSIGN tt_orcto_real.val_ctbl_sdo:bgcolor in browse br_orcto = 14
                      tt_orcto_real.val_ctbl_sdo:fgcolor in browse br_orcto = ?
                      tt_orcto_real.val_perc_sdo:bgcolor in browse br_orcto = 14
                      tt_orcto_real.val_perc_sdo:fgcolor in browse br_orcto = ?.


           END.
       END.
       ELSE DO:
           ASSIGN tt_orcto_real.val_ctbl_sdo:bgcolor in browse br_orcto = 15
                  tt_orcto_real.val_ctbl_sdo:fgcolor in browse br_orcto = ?
                  tt_orcto_real.val_perc_sdo:bgcolor in browse br_orcto = 15
                  tt_orcto_real.val_perc_sdo:fgcolor in browse br_orcto = ?.


       END.
   end.   

END.

ON CHOOSE OF bt_pri IN FRAME f_main DO:
        
    /*RUN btb/btb944za.p (INPUT wh_w_program).*/
    DEF VAR v_des_data AS CHAR NO-UNDO.
    
    ASSIGN v_des_data  = STRING (YEAR (TODAY), "9999")
                       + STRING (MONTH (TODAY), "99")
                       + STRING (DAY (TODAY), "99")
                       + "_" 
                       + STRING (TIME, "hh:mm")
           v_des_data  = REPLACE (v_des_data, ":", "")
           v_arq_email = SESSION:TEMP-DIR 
                       + TRIM (v_cod_ccusto) 
                       + TRIM (v_cod_exerc_ctbl) 
                       + STRING (v_num_period_ctbl, "99")
                       + "_"
                       + v_des_data
                       + ".xlsx".

    IF SEARCH (v_arq_email) <> ? THEN
       OS-DELETE VALUE (v_arq_email).

    IF CAN-FIND (FIRST tt_orcto_real) THEN DO:
        APPLY "CTRL-ALT-E" TO wh_w_program.
        ASSIGN v_arq_plan  = SESSION:TEMP-DIR + "gotoexcel_" + trim(v_cod_usuar_corren) + ".xlsx".           
        IF SEARCH (v_arq_plan) <> ? THEN DO:
            IF SEARCH (v_arq_email) <> ? THEN
                OS-DELETE VALUE (v_arq_email).
            OS-COPY VALUE (v_arq_plan) VALUE (v_arq_email).
        END.
    END.
    ELSE
        RETURN.

END.

ON CHOOSE OF bt_send IN FRAME f_main DO:

    APPLY "CHOOSE" TO bt_pri IN FRAME f_main.

    IF SEARCH (v_arq_email) <> ? THEN
        RUN pi_email.

END.

ON CHOOSE OF bt_exi IN FRAME f_main DO:

    ASSIGN v_log_run = NO.
    run pi_close_program.

END.

/*--- Main Code ---*/
assign wh_w_program:title             = frame f_main:title
       frame f_main:title             = ?
       wh_w_program:width-chars       = frame f_main:width-chars
       wh_w_program:height-chars      = frame f_main:height-chars - 0.85
       frame f_main:row               = 1
       frame f_main:col               = 1
       wh_w_program:menubar           = menu m_main:handle
       wh_w_program:col               = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row               = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window                 = wh_w_program
       v_wgh_current_menu             = current-window:MENUBAR
       v_wgh_current_window           = wh_w_program.

pause 0 before-hide.
assign v_wgh_focus = v_cod_ccusto:handle in frame f_main.
/*--- Empresa ---*/
find emsuni.empresa no-lock
   where emsuni.empresa.cod_empresa = v_cod_empres_usuar no-error.
if not avail emsuni.empresa then do:
   message "Empresa inexistente!" view-as alert-box error.
   RETURN.
end.
ELSE DO:
    ASSIGN v_rec_empresa = RECID (empresa)
           v_cod_empresa = v_cod_empres_usuar.
    EMPTY TEMP-TABLE tt_ccusto.

    FIND FIRST plano_ccusto NO-LOCK 
         WHERE plano_ccusto.cod_empresa      = v_cod_empresa
           AND plano_ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/ NO-ERROR.
    IF AVAIL plano_ccusto then do:

       ASSIGN v_cod_plano_ccusto  = plano_ccusto.cod_plano_ccusto
              v_cod_format_ccusto = plano_ccusto.cod_format_ccusto
              v_rec_plano_ccusto  = RECID (plano_ccusto).
       RUN pi_cria_tt_ccusto.
       /*IF v_rec_ccusto = ? THEN DO: 
           FIND FIRST usuar_univ NO-LOCK
               WHERE usuar_univ.cod_usuario = v_cod_usuar_corren NO-ERROR.
           IF AVAIL usuar_univ THEN DO:
               IF usuar_univ.cod_empresa = v_cod_empresa THEN DO:
                   FIND ccusto OF usuar_univ NO-LOCK NO-ERROR.
                   IF AVAIL ccusto THEN DO:
                       FIND tt_ccusto OF ccusto NO-LOCK NO-ERROR.
                       IF AVAIL tt_ccusto THEN DO:
                           ASSIGN v_rec_ccusto  = tt_ccusto.rec_ccusto
                                  v_cod_ccusto = tt_ccusto.cod_ccusto
                                  v_des_ccusto = tt_ccusto.des_tit_ctbl.
                       END.
                   END.
               END.
               ELSE DO:
                   FIND FIRST tt_ccusto NO-LOCK NO-ERROR.
                   IF AVAIL tt_ccusto THEN DO:
                       ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
                              v_cod_ccusto = tt_ccusto.cod_ccusto
                              v_des_ccusto = tt_ccusto.des_tit_ctbl.
                   END.
               END.                   
           END.
       END.
       ELSE DO:
           MESSAGE 1223
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           FIND tt_ccusto NO-LOCK
               WHERE tt_ccusto.rec_ccusto = v_rec_ccusto NO-ERROR.
           IF AVAIL tt_ccusto THEN DO:               
               ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
                      v_cod_ccusto = tt_ccusto.cod_ccusto
                      v_des_ccusto = tt_ccusto.des_tit_ctbl.
           END.
           ELSE DO:
               FIND FIRST tt_ccusto NO-LOCK NO-ERROR.
               IF AVAIL tt_ccusto THEN DO:
                   ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
                          v_cod_ccusto = tt_ccusto.cod_ccusto
                          v_des_ccusto = tt_ccusto.des_tit_ctbl.
               END.
           END.
       END.*/
       ASSIGN bt_zoo_cc:col in frame f_main = 38 + length(v_cod_format_ccusto) + 3.30
              v_cod_ccusto:visible in frame f_main = no
              v_cod_ccusto:visible in frame f_main = yes.
    end.
    ELSE DO:
        ASSIGN v_cod_plano_ccusto  = ""
               v_cod_format_ccusto = ""
               v_cod_ccusto        = ""
               v_rec_ccusto        = ?
               v_rec_plano_ccusto  = ?.
    END.
END.

IF v_cod_ccusto = "" THEN DO:
    FIND FIRST tt_ccusto NO-LOCK NO-ERROR.
    IF AVAIL tt_ccusto THEN DO:
        /*ASSIGN v_rec_ccusto = tt_ccusto.rec_ccusto
               v_cod_ccusto = tt_ccusto.cod_ccusto
               v_des_ccusto = tt_ccusto.des_tit_ctbl.*/
        ASSIGN v_rec_ccusto = ?
               v_cod_ccusto = ""
               v_des_ccusto = "".
    END.
    ELSE DO:
        MESSAGE "Usu rio: " CAPS (v_cod_usuar_corren)
                " nÆo tem acesso a Centros de Custos!" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.

FIND LAST plano_cta_unid_organ NO-LOCK
    WHERE plano_cta_unid_organ.cod_unid_organ = v_cod_empresa 
      AND plano_cta_unid_organ.ind_tip_plano_cta_ctbl = "Prim rio"
      and plano_cta_unid_organ.dat_fim_valid  > TODAY NO-ERROR.
if avail plano_cta_unid_organ then do:
    FIND plano_cta_ctbl OF plano_cta_unid_organ NO-LOCK NO-ERROR.
    IF AVAIL plano_cta_ctbl THEN DO:
        assign v_cod_plano_cta_ctbl  = plano_cta_ctbl.cod_plano_cta_ctbl
               v_cod_format_cta_ctbl = plano_cta_ctbl.cod_format_cta_ctbl
               v_rec_plano_cta_ctbl  = recid(plano_cta_ctbl).
    END.
end.
IF v_cod_format_cta_ctbl = "" THEN
    ASSIGN v_cod_format_cta_ctbl = "99999999".

/*--- Recupera os parƒmetros ---*/
run pi_dwb_set_list_param.
/*--- Valores Iniciais ---*/
if not avail emsfnd.dwb_set_list_param then do:
   run pi_inic_param.
end.
ASSIGN v_log_run = YES.
view frame f_main.

main_block:
repeat on endkey undo main_block, leave main_block
   on stop undo main_block, leave main_block 
   on error undo main_block, retry main_block with frame f_main:
   assign v_log_run = no
          v_arq_out = session:temp-directory.

   enable all with frame f_main.
   DISABLE v_des_ccusto
           v-des-grupo
           bt_det
           bt_contr
           v_val_orcado v_val_realiz v_val_realiz_emp
           v_val_orcado_sdo v_val_realiz_sdo
           WITH FRAME f_main.
   display v_cod_ccusto
           v_des_ccusto
           v-cod-grupo
           v-des-grupo
           v_cod_exerc_ctbl 
           v_num_period_ctbl
           with frame f_main.
   APPLY "value-changed" TO rs_pesq IN FRAME f_main.
   apply "entry" to v_wgh_focus.
   
   if valid-handle(v_wgh_focus) then do:
      wait-for go of frame f_main focus v_wgh_focus.
   end.
   else do:
       wait-for go of frame f_main.
   end.
   assign input frame f_main v_cod_exerc_ctbl
          input frame f_main v_num_period_ctbl.

   if v_cod_ccusto:visible in frame f_main = yes then do:
        assign input frame f_main v_cod_ccusto
               v-cod-grupo = "".
   end.
   else do:
        assign input frame f_main v-cod-grupo
               v_cod_ccusto = "".   
   end.

   /*--- Valida Valores ---*/
   run pi_vld_param.
   run pi_salva_param.
   if v_log_run = yes then do:
      for each tt_orcto_real:
         delete tt_orcto_real.
      end.
      assign v_val_curr     = 0
             v_val_max      = 0.

      EMPTY TEMP-TABLE tt_orcto_real.
      FOR EACH estabelecimento NO-LOCK
          WHERE estabelecimento.cod_empresa = v_cod_empresa
            AND estabelecimento.cod_estab  >= v_cod_estab_ini
            AND estabelecimento.cod_estab  <= v_cod_estab_fim:
          FOR EACH estab_unid_negoc NO-LOCK
              WHERE estab_unid_negoc.cod_estab       = estabelecimento.cod_estab
                AND estab_unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
                AND estab_unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim:
              ASSIGN v_val_max = v_val_max + 1.
          END.
      END.
      
      if session:set-wait-state ("general") then.
      run pi_percentual (input v_val_max,
                         INPUT 0,
                         input "Pesquisando Saldos....").
      FOR EACH estabelecimento NO-LOCK
          WHERE estabelecimento.cod_empresa = v_cod_empresa
            AND estabelecimento.cod_estab  >= v_cod_estab_ini
            AND estabelecimento.cod_estab  <= v_cod_estab_fim:
          FOR EACH estab_unid_negoc NO-LOCK
              WHERE estab_unid_negoc.cod_estab       = estabelecimento.cod_estab
                AND estab_unid_negoc.cod_unid_negoc >= v_cod_unid_negoc_ini
                AND estab_unid_negoc.cod_unid_negoc <= v_cod_unid_negoc_fim:
              RUN pi_cria_tt_orcto_real (INPUT v_num_period_ctbl).
              assign v_val_curr = v_val_curr + 1.
              run pi_percentual (input v_val_max,
                                 input v_val_curr,
                                 input "Pesquisando Saldos...").
          END.
      END.
      IF CAN-FIND (FIRST tt_orcto_real) THEN DO:
          RUN pi_sdo_ctbl_real.
      END.

      if session:set-wait-state ("") then.
      run pi_open_query.
      hide frame f_perc no-pause.
   end.
   else do: 
       hide frame f_main no-pause.
       return.
   end.
end.

PROCEDURE pi_contrair:

    DEF INPUT PARAM p_cod_cta_ctbl AS CHAR NO-UNDO.

    FOR EACH btt_orcto_real EXCLUSIVE-LOCK
        WHERE btt_orcto_real.cod_cta_ctbl_pai = p_cod_cta_ctbl:
        IF btt_orcto_real.log_estrut = YES THEN DO:
            ASSIGN btt_orcto_real.log_estrut = NO.
            /*RUN pi_contrair (INPUT btt_orcto_real.cod_cta_ctbl).*/
        END.
    END.

END.

PROCEDURE pi_vers_orcto_ctbl_bgc:

    unid_blk:
    FOR EACH relacto_unid_orctaria NO-LOCK WHERE
             relacto_unid_orctaria.cod_unid_orctaria   >= "" AND
             relacto_unid_orctaria.num_tip_inform_organ = 1 /* Empresa */ AND
             relacto_unid_orctaria.cod_inform_organ     = v_cod_empres_usuar:
        FIND unid_orctaria OF relacto_unid_orctaria NO-LOCK NO-ERROR.
        IF AVAIL unid_orctaria AND unid_orctaria.log_bloq_exec_orctaria = YES THEN DO:
            ASSIGN v_cod_unid_orctaria = unid_orctaria.cod_unid_orctaria.
            LEAVE unid_blk.
        END.
    END.

    FIND FIRST cenar_orctario_bgc NO-LOCK WHERE
               cenar_orctario_bgc.cod_cenar_orctario    >= ""  AND
               cenar_orctario_bgc.log_base_exec_orctaria = YES NO-ERROR.
    IF AVAIL cenar_orctario_bgc THEN DO:
        ASSIGN v_cod_cenar_orctario = cenar_orctario_bgc.cod_cenar_orctario.
        FIND FIRST orcto_ctbl_bgc NO-LOCK
            WHERE orcto_ctbl_bgc.cod_cenar_orctario = v_cod_cenar_orctario
              AND orcto_ctbl_bgc.cod_unid_orctaria  = v_cod_unid_orctaria
              AND orcto_ctbl_bgc.dat_inic_valid     = DATE (01, 01, INT (v_cod_exerc_ctbl)) NO-ERROR.
        IF AVAIL orcto_ctbl_bgc THEN DO:
            ASSIGN v_cod_finalid_econ   = orcto_ctbl_bgc.cod_finalid_econ
                   v_num_seq_orcto_ctbl = orcto_ctbl_bgc.num_seq_orcto_ctbl.
            FIND LAST vers_orcto_ctbl_bgc OF orcto_ctbl_bgc NO-LOCK
                /*WHERE vers_orcto_ctbl_bgc.num_sit_vers_orcto_ctbl = 2 /* Aprovada */  NO-ERROR*/.
            IF AVAIL vers_orcto_ctbl_bgc THEN DO:
                 ASSIGN v_rec_vers_orcto_ctbl_bgc = RECID (vers_orcto_ctbl_bgc).
            END.         
        END.
    END.

END.

PROCEDURE pi_cria_tt_orcto_real:

    DEF INPUT PARAM p_num_period_ctbl AS INT NO-UNDO.

    IF p_num_period_ctbl = v_num_period_ctbl THEN DO:
        FIND vers_orcto_ctbl_bgc NO-LOCK
            WHERE RECID (vers_orcto_ctbl_bgc) = v_rec_vers_orcto_ctbl_bgc NO-ERROR.
        IF AVAIL vers_orcto_ctbl_bgc THEN DO:
            if v_cod_ccusto <> "" then do:
                FOR EACH sdo_orcto_ctbl_bgc NO-LOCK OF vers_orcto_ctbl_bgc
                    WHERE sdo_orcto_ctbl_bgc.cod_empresa      = tt_ccusto.cod_empresa
                      AND sdo_orcto_ctbl_bgc.cod_plano_ccusto = tt_ccusto.cod_plano_ccusto
                      AND sdo_orcto_ctbl_bgc.cod_ccusto       = tt_ccusto.cod_ccusto
                      AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl   = v_cod_cenar_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl   = v_cod_exerc_ctbl
                      AND sdo_orcto_ctbl_bgc.num_period_ctbl  = p_num_period_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_estab        = estab_unid_negoc.cod_estab
                      AND sdo_orcto_ctbl_bgc.cod_unid_negoc   = estab_unid_negoc.cod_unid_negoc:

                    /* Verifica parƒmetro Ativo para Conta contabil */
                    IF NOT CAN-FIND(FIRST param_bloq_exec_orctaria NO-LOCK
                                    WHERE param_bloq_exec_orctaria.num_tip_inform_organ = 2
                                     AND param_bloq_exec_orctaria.cod_inform_organ = ("PCDOCOL" + CHR(10) + sdo_orcto_ctbl_bgc.cod_cta_ctbl)) THEN NEXT.

                    RUN pi_tt_orcto_real (input sdo_orcto_ctbl_bgc.cod_plano_ccusto,
                                          input sdo_orcto_ctbl_bgc.cod_ccusto).
                END.
            END.
            ELSE DO:
                for each dc-orc-grupo-conta no-lock
                    where dc-orc-grupo-conta.cod-grupo = v-cod-grupo:
                    FOR EACH sdo_orcto_ctbl_bgc NO-LOCK OF vers_orcto_ctbl_bgc
                        WHERE sdo_orcto_ctbl_bgc.cod_empresa        = v_cod_empresa
                          AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl = dc-orc-grupo-conta.cod_plano_ctbl
                          AND sdo_orcto_ctbl_bgc.cod_cta_ctbl       = dc-orc-grupo-conta.cod_cta_ctbl
                          AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl     = v_cod_cenar_ctbl
                          AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl     = v_cod_exerc_ctbl
                          AND sdo_orcto_ctbl_bgc.num_period_ctbl    = p_num_period_ctbl
                          AND sdo_orcto_ctbl_bgc.cod_estab          = estab_unid_negoc.cod_estab
                          AND sdo_orcto_ctbl_bgc.cod_unid_negoc     = estab_unid_negoc.cod_unid_negoc:

                        /* Verifica parƒmetro Ativo para Conta contabil */
                        IF NOT CAN-FIND(FIRST param_bloq_exec_orctaria NO-LOCK
                                        WHERE param_bloq_exec_orctaria.num_tip_inform_organ = 2
                                         AND param_bloq_exec_orctaria.cod_inform_organ = ("PCDOCOL" + CHR(10) + sdo_orcto_ctbl_bgc.cod_cta_ctbl)) THEN NEXT.

                        RUN pi_tt_orcto_real (input "",
                                              input "").
                    END.                    
                end.            
            end.
        END.
    END.
    ELSE DO:
        if v_cod_ccusto <> "" then do:
            FOR EACH sdo_orcto_ctbl_bgc NO-LOCK OF vers_orcto_ctbl_bgc
                WHERE sdo_orcto_ctbl_bgc.cod_empresa        = tt_orcto_real.cod_empresa
                  AND sdo_orcto_ctbl_bgc.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
                  AND sdo_orcto_ctbl_bgc.cod_ccusto         = tt_orcto_real.cod_ccusto
                  AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl     = tt_orcto_real.cod_exerc_ctbl
                  AND sdo_orcto_ctbl_bgc.num_period_ctbl    = p_num_period_ctbl:
                IF sdo_orcto_ctbl_bgc.cod_estab < v_cod_estab_ini 
                OR sdo_orcto_ctbl_bgc.cod_estab > v_cod_estab_fim THEN 
                    NEXT.
                IF sdo_orcto_ctbl_bgc.cod_unid_negoc < v_cod_unid_negoc_ini 
                OR sdo_orcto_ctbl_bgc.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                    NEXT.

                /* Verifica parƒmetro Ativo para Conta contabil */
                IF NOT CAN-FIND(FIRST param_bloq_exec_orctaria NO-LOCK
                            WHERE param_bloq_exec_orctaria.num_tip_inform_organ = 2
                              AND param_bloq_exec_orctaria.cod_inform_organ = ("PCDOCOL" + CHR(10) + sdo_orcto_ctbl_bgc.cod_cta_ctbl)) THEN NEXT.

                RUN pi_tt_orcto_real (input sdo_orcto_ctbl_bgc.cod_plano_ccusto,
                                      input sdo_orcto_ctbl_bgc.cod_ccusto).
            END.
        end.
        else do:
            FOR EACH sdo_orcto_ctbl_bgc NO-LOCK OF vers_orcto_ctbl_bgc
                WHERE sdo_orcto_ctbl_bgc.cod_empresa        = tt_orcto_real.cod_empresa
                  AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                  AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl     = tt_orcto_real.cod_exerc_ctbl
                  AND sdo_orcto_ctbl_bgc.num_period_ctbl    = p_num_period_ctbl:
                IF sdo_orcto_ctbl_bgc.cod_estab < v_cod_estab_ini 
                OR sdo_orcto_ctbl_bgc.cod_estab > v_cod_estab_fim THEN 
                    NEXT.
                IF sdo_orcto_ctbl_bgc.cod_unid_negoc < v_cod_unid_negoc_ini 
                OR sdo_orcto_ctbl_bgc.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                    NEXT.

                /* Verifica parƒmetro Ativo para Conta contabil */
                IF NOT CAN-FIND(FIRST param_bloq_exec_orctaria NO-LOCK
                            WHERE param_bloq_exec_orctaria.num_tip_inform_organ = 2
                              AND param_bloq_exec_orctaria.cod_inform_organ = ("PCDOCOL" + CHR(10) + sdo_orcto_ctbl_bgc.cod_cta_ctbl)) THEN NEXT.

                RUN pi_tt_orcto_real (input "",
                                      input "").
            END.        
        end.
    END.

END.

PROCEDURE pi_tt_orcto_real:

    def input param p_cod_plano_ccusto as char no-undo.
    def input param p_cod_ccusto       as char no-undo.
     
    DEF VAR v_des_tit_ctbl     AS CHAR NO-UNDO.

    FIND FIRST tt_orcto_real
        WHERE tt_orcto_real.cod_empresa        = sdo_orcto_ctbl_bgc.cod_empresa
          AND tt_orcto_real.cod_plano_ccusto   = p_cod_plano_ccusto
          AND tt_orcto_real.cod_ccusto         = p_cod_ccusto
          AND tt_orcto_real.cod_plano_cta_ctbl = sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
          AND tt_orcto_real.cod_cta_ctbl       = sdo_orcto_ctbl_bgc.cod_cta_ctbl
          AND tt_orcto_real.cod_cenar_ctbl     = sdo_orcto_ctbl_bgc.cod_cenar_ctbl
          AND tt_orcto_real.cod_exerc_ctbl     = sdo_orcto_ctbl_bgc.cod_exerc_ctbl
          AND tt_orcto_real.num_period_ctbl    = v_num_period_ctbl NO-ERROR.
    IF NOT AVAIL tt_orcto_real THEN DO:
        FIND cta_ctbl NO-LOCK
            WHERE cta_ctbl.cod_plano_cta_ctbl = sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
              AND cta_ctbl.cod_cta_ctbl       = sdo_orcto_ctbl_bgc.cod_cta_ctbl NO-ERROR.
        IF AVAIL cta_ctbl THEN DO:
            ASSIGN v_des_tit_ctbl  = cta_ctbl.des_tit_ctbl.                    
        END.

        CREATE tt_orcto_real.
        ASSIGN tt_orcto_real.cod_empresa        = sdo_orcto_ctbl_bgc.cod_empresa
               tt_orcto_real.cod_plano_ccusto   = p_cod_plano_ccusto
               tt_orcto_real.cod_ccusto         = p_cod_ccusto
               tt_orcto_real.cod_plano_cta_ctbl = sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
               tt_orcto_real.cod_cta_ctbl       = sdo_orcto_ctbl_bgc.cod_cta_ctbl
               tt_orcto_real.cod_cenar_ctbl     = sdo_orcto_ctbl_bgc.cod_cenar_ctbl
               tt_orcto_real.cod_exerc_ctbl     = sdo_orcto_ctbl_bgc.cod_exerc_ctbl
               tt_orcto_real.num_period_ctbl    = v_num_period_ctbl
               tt_orcto_real.cod_finalid_econ   = v_cod_finalid_econ
               tt_orcto_real.des_cta_ctbl       = FILL (CHR(32), 3)
                                                + STRING (tt_orcto_real.cod_cta_ctbl, v_cod_format_cta_ctbl) + " - " + v_des_tit_ctbl.
        /*if p_cod_ccusto <> "" then do:*/
            FIND FIRST estrut_cta_ctbl NO-LOCK
                WHERE estrut_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
                  AND estrut_cta_ctbl.cod_cta_ctbl_filho = cta_ctbl.cod_cta_ctbl NO-ERROR.
            IF AVAIL estrut_cta_ctbl THEN DO:
                ASSIGN tt_orcto_real.cod_cta_ctbl_pai   = estrut_cta_ctbl.cod_cta_ctbl_pai
                       tt_orcto_real.ind_espec_cta_ctbl = "Anal¡tica"
                       tt_orcto_real.log_estrut         = NO.
            END.
        /*end.
        else do:
            assign tt_orcto_real.cod_cta_ctbl_pai   = sdo_orcto_ctbl_bgc.cod_cta_ctbl
                   tt_orcto_real.ind_espec_cta_ctbl = "Anal¡tica"
                   tt_orcto_real.log_estrut         = NO.                 
        end.*/        
        /* Periodicidade */
        FIND tt_param_bloq 
            WHERE tt_param_bloq.num_tip_inform = 2 /* Cta Ctbl */
              AND tt_param_bloq.cod_inform     = tt_orcto_real.cod_cta_ctbl NO-ERROR.
        IF NOT AVAIL tt_param_bloq THEN DO:
            FIND tt_param_bloq 
                WHERE tt_param_bloq.num_tip_inform = 1 /* Empresa */
                  AND tt_param_bloq.cod_inform     = tt_orcto_real.cod_empresa NO-ERROR.
            IF NOT AVAIL tt_param_bloq THEN
                ASSIGN tt_orcto_real.des_period_bloq = "Mensal"
                       tt_orcto_real.dat_inicial     = v_dat_inicial
                       tt_orcto_real.dat_final       = v_dat_final.
            ELSE
                ASSIGN tt_orcto_real.des_period_bloq = tt_param_bloq.des_period_bloq
                       tt_orcto_real.dat_inicial     = tt_param_bloq.dat_inicial
                       tt_orcto_real.dat_final       = tt_param_bloq.dat_final.
        END.
        ELSE DO:
            ASSIGN tt_orcto_real.des_period_bloq = tt_param_bloq.des_period_bloq
                   tt_orcto_real.dat_inicial     = tt_param_bloq.dat_inicial
                   tt_orcto_real.dat_final       = tt_param_bloq.dat_final.
        END.
    END.
    IF  sdo_orcto_ctbl_bgc.num_period_ctbl >= MONTH (tt_orcto_real.dat_inicial)
    AND sdo_orcto_ctbl_bgc.num_period_ctbl <= MONTH (tt_orcto_real.dat_final) THEN
        ASSIGN tt_orcto_real.val_orcado = tt_orcto_real.val_orcado
                                        + sdo_orcto_ctbl_bgc.val_orcado.
    IF MONTH (tt_orcto_real.dat_final) = sdo_orcto_ctbl_bgc.num_period_ctbl THEN
        ASSIGN tt_orcto_real.val_orcado_sdo = tt_orcto_real.val_orcado_sdo
                                            + sdo_orcto_ctbl_bgc.val_orcado_sdo.

END.

PROCEDURE pi_sdo_ctbl_real:

    DEF VAR v_dat_ini_pesq AS DATE NO-UNDO.
    DEF VAR v_dat_fim_pesq AS DATE NO-UNDO.
    DEF VAR v_dat_ini_aux  AS DATE NO-UNDO.
    DEF VAR v_dat_fim_aux  AS DATE NO-UNDO.
    DEF VAR v_num_aux      AS INT NO-UNDO.

    FOR EACH tt_orcto_real 
        WHERE tt_orcto_real.cod_cta_ctbl_pai <> "":
        ASSIGN v_dat_ini_pesq = tt_orcto_real.dat_inicial
               v_dat_fim_pesq = tt_orcto_real.dat_final.
        /*IF tt_orcto_real.cod_cta_ctbl = "41006605" THEN
            MESSAGE v_dat_fim_pesq SKIP
                    v_dat_final VIEW-AS ALERT-BOX.*/
        DO v_num_aux = 1 TO MONTH (v_dat_final):
            ASSIGN v_dat_ini_aux = DATE (v_num_aux, 01, INT (v_cod_exerc_ctbl)).
            IF v_num_aux < 12 THEN
                ASSIGN v_dat_fim_aux = DATE (v_num_aux + 1, 01, INT (v_cod_exerc_ctbl)) - 1.
            ELSE
                ASSIGN v_dat_fim_aux = DATE (12, 31, INT (v_cod_exerc_ctbl)).
            IF v_num_aux <> v_num_period_ctbl THEN DO:
                RUN pi_cria_tt_orcto_real (INPUT v_num_aux).
            END.
            
            if tt_orcto_real.cod_ccusto <> "" then do:
                FOR EACH sdo_ctbl NO-LOCK
                    WHERE sdo_ctbl.cod_empresa        = tt_orcto_real.cod_empresa
                      AND sdo_ctbl.cod_finalid_econ   = v_cod_finalid_econ
                      and sdo_ctbl.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                      and sdo_ctbl.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                      and sdo_ctbl.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                      and sdo_ctbl.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
                      and sdo_ctbl.cod_ccusto         = tt_orcto_real.cod_ccusto
                      and sdo_ctbl.dat_sdo_ctbl       = v_dat_fim_aux
                    USE-INDEX sdoctbl_id
                    BY sdo_ctbl.cod_estab
                    BY sdo_ctbl.cod_unid_negoc
                    BY sdo_ctbl.cod_ccusto:          
                    IF sdo_ctbl.cod_estab < v_cod_estab_ini 
                    OR sdo_ctbl.cod_estab > v_cod_estab_fim THEN 
                        NEXT.
                    IF sdo_ctbl.cod_unid_negoc < v_cod_unid_negoc_ini 
                    OR sdo_ctbl.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                        NEXT.
                    IF  sdo_ctbl.dat_sdo_ctbl >= v_dat_ini_pesq
                    AND sdo_ctbl.dat_sdo_ctbl <= v_dat_fim_pesq THEN DO:
                        ASSIGN tt_orcto_real.val_ctbl  = tt_orcto_real.val_ctbl
                                                       + (sdo_ctbl.val_sdo_ctbl_db - sdo_ctbl.val_sdo_ctbl_cr).
                    END.
                    ASSIGN  tt_orcto_real.val_ctbl_sdo = tt_orcto_real.val_ctbl_sdo
                                                       + (sdo_ctbl.val_sdo_ctbl_db - sdo_ctbl.val_sdo_ctbl_cr).
                END.
            end.
            else do:
                FOR EACH sdo_ctbl NO-LOCK
                    WHERE sdo_ctbl.cod_empresa        = tt_orcto_real.cod_empresa
                      AND sdo_ctbl.cod_finalid_econ   = v_cod_finalid_econ
                      and sdo_ctbl.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                      and sdo_ctbl.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                      and sdo_ctbl.cod_plano_ccusto   <> ""
                      and sdo_ctbl.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                      and sdo_ctbl.dat_sdo_ctbl       = v_dat_fim_aux
                    USE-INDEX sdoctbl_id
                    BY sdo_ctbl.cod_estab
                    BY sdo_ctbl.cod_unid_negoc:
                    IF sdo_ctbl.cod_estab < v_cod_estab_ini 
                    OR sdo_ctbl.cod_estab > v_cod_estab_fim THEN 
                        NEXT.
                    IF sdo_ctbl.cod_unid_negoc < v_cod_unid_negoc_ini 
                    OR sdo_ctbl.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                        NEXT.
                    IF  sdo_ctbl.dat_sdo_ctbl >= v_dat_ini_pesq
                    AND sdo_ctbl.dat_sdo_ctbl <= v_dat_fim_pesq THEN do:
                        ASSIGN tt_orcto_real.val_ctbl  = tt_orcto_real.val_ctbl
                                                       + (sdo_ctbl.val_sdo_ctbl_db - sdo_ctbl.val_sdo_ctbl_cr).
                    end.
                    ASSIGN  tt_orcto_real.val_ctbl_sdo = tt_orcto_real.val_ctbl_sdo
                                                       + (sdo_ctbl.val_sdo_ctbl_db - sdo_ctbl.val_sdo_ctbl_cr).
                END.
            end.
            
            /* Empenhado */
            if tt_orcto_real.cod_ccusto <> "" then do:
                FOR EACH orig_movto_empenh NO-LOCK
                    WHERE orig_movto_empenh.cod_empresa        = tt_orcto_real.cod_empresa
                      AND orig_movto_empenh.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                      AND orig_movto_empenh.cod_finalid_econ   = v_cod_finalid_econ
                      AND orig_movto_empenh.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                      AND orig_movto_empenh.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
                      AND orig_movto_empenh.cod_ccusto         = tt_orcto_real.cod_ccusto
                      AND orig_movto_empenh.dat_sdo_ctbl       = v_dat_fim_aux:
                    IF orig_movto_empenh.num_ult_funcao = 3 /* Realizado */
                    /*OR orig_movto_empenh.num_ult_funcao = 5 */ THEN
                        NEXT.
                    IF orig_movto_empenh.cod_estab < v_cod_estab_ini 
                    OR orig_movto_empenh.cod_estab > v_cod_estab_fim THEN 
                        NEXT.
                    IF orig_movto_empenh.cod_unid_negoc < v_cod_unid_negoc_ini 
                    OR orig_movto_empenh.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                        NEXT.
                    IF  orig_movto_empenh.dat_sdo_ctbl >= v_dat_ini_pesq
                    AND orig_movto_empenh.dat_sdo_ctbl <= v_dat_fim_pesq THEN DO:
                        //ASSIGN tt_orcto_real.val_ctbl_emp = tt_orcto_real.val_ctbl_emp
                                                          + orig_movto_empenh.val_movto_empenh.
 
                    CREATE tt_origem.
                    assign tt_origem.cod_empresa              =  tt_orcto_real.cod_empresa 
                           tt_origem.cod_plano_ccusto         =  tt_orcto_real.cod_plano_ccusto   
                           tt_origem.cod_ccusto               =  tt_orcto_real.cod_ccusto        
                           tt_origem.cod_plano_cta_ctbl       =  tt_orcto_real.cod_plano_cta_ctbl 
                           tt_origem.cod_cta_ctbl             =  tt_orcto_real.cod_cta_ctbl 
                           tt_origem.cod_cta_ctbl_pai         =  tt_orcto_real.cod_cta_ctbl_pai
                           tt_origem.dat_inicial              =  v_dat_fim_aux 
                           tt_origem.num_orig_movto_empenh    =  orig_movto_empenh.num_orig_movto_empenh 
                           tt_origem.val_movto_empenh         =  orig_movto_empenh.val_movto_empenh. 
                                         
                                                                          
                    END.
                    ASSIGN tt_orcto_real.val_ctbl_sdo = tt_orcto_real.val_ctbl_sdo
                                                      + orig_movto_empenh.val_movto_empenh.
/*                     CREATE tt_origem. */
/*                     assign tt_origem.cod_empresa              =  tt_orcto_real.cod_empresa */
/*                            tt_origem.cod_plano_ccusto         =  tt_orcto_real.cod_plano_ccusto */
/*                            tt_origem.cod_ccusto               =  tt_orcto_real.cod_ccusto */
/*                            tt_origem.cod_plano_cta_ctbl       =  tt_orcto_real.cod_plano_cta_ctbl */
/*                            tt_origem.cod_cta_ctbl             =  tt_orcto_real.cod_cta_ctbl */
/*                            tt_origem.cod_cta_ctbl_pai         =  tt_orcto_real.cod_cta_ctbl_pai */
/*                            tt_origem.dat_inicial               =  v_dat_fim_aux */
/*                            tt_origem.num_orig_movto_empenh    =  orig_movto_empenh.num_orig_movto_empenh */
/*                            tt_origem.val_movto_empenh         =  orig_movto_empenh.val_movto_empenh. */
/*    */
                END.
            end.
            else do:
                FOR EACH orig_movto_empenh NO-LOCK
                    WHERE orig_movto_empenh.cod_empresa        = tt_orcto_real.cod_empresa
                      AND orig_movto_empenh.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                      AND orig_movto_empenh.cod_finalid_econ   = v_cod_finalid_econ
                      AND orig_movto_empenh.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl
                      AND orig_movto_empenh.dat_sdo_ctbl       = v_dat_fim_aux:
                    IF orig_movto_empenh.num_ult_funcao = 3 /* Realizado */
                    /*OR orig_movto_empenh.num_ult_funcao = 5 */ THEN
                        NEXT.
                    IF orig_movto_empenh.cod_estab < v_cod_estab_ini 
                    OR orig_movto_empenh.cod_estab > v_cod_estab_fim THEN 
                        NEXT.
                    IF orig_movto_empenh.cod_unid_negoc < v_cod_unid_negoc_ini 
                    OR orig_movto_empenh.cod_unid_negoc > v_cod_unid_negoc_fim THEN
                        NEXT.
                    IF  orig_movto_empenh.dat_sdo_ctbl >= v_dat_ini_pesq
                    AND orig_movto_empenh.dat_sdo_ctbl <= v_dat_fim_pesq THEN DO:
                        //ASSIGN tt_orcto_real.val_ctbl_emp = tt_orcto_real.val_ctbl_emp
                                                          + orig_movto_empenh.val_movto_empenh.
                    CREATE tt_origem.
                    assign tt_origem.cod_empresa              =  tt_orcto_real.cod_empresa 
                           tt_origem.cod_plano_ccusto         =  tt_orcto_real.cod_plano_ccusto   
                           tt_origem.cod_ccusto               =  tt_orcto_real.cod_ccusto        
                           tt_origem.cod_plano_cta_ctbl       =  tt_orcto_real.cod_plano_cta_ctbl 
                           tt_origem.cod_cta_ctbl             =  tt_orcto_real.cod_cta_ctbl 
                           tt_origem.cod_cta_ctbl_pai         =  tt_orcto_real.cod_cta_ctbl_pai
                           tt_origem.dat_inicial               =  v_dat_fim_aux 
                           tt_origem.num_orig_movto_empenh    =  orig_movto_empenh.num_orig_movto_empenh 
                           tt_origem.val_movto_empenh         =  orig_movto_empenh.val_movto_empenh. 

                    END.
                    ASSIGN tt_orcto_real.val_ctbl_sdo = tt_orcto_real.val_ctbl_sdo
                                                      + orig_movto_empenh.val_movto_empenh.
/*                     CREATE tt_origem. */
/*                     assign tt_origem.cod_empresa              =  tt_orcto_real.cod_empresa */
/*                            tt_origem.cod_plano_ccusto         =  tt_orcto_real.cod_plano_ccusto */
/*                            tt_origem.cod_ccusto               =  tt_orcto_real.cod_ccusto */
/*                            tt_origem.cod_plano_cta_ctbl       =  tt_orcto_real.cod_plano_cta_ctbl */
/*                            tt_origem.cod_cta_ctbl             =  tt_orcto_real.cod_cta_ctbl */
/*                            tt_origem.cod_cta_ctbl_pai         =  tt_orcto_real.cod_cta_ctbl_pai */
/*                            tt_origem.dat_inicial               =  v_dat_fim_aux */
/*                            tt_origem.num_orig_movto_empenh    =  orig_movto_empenh.num_orig_movto_empenh */
/*                            tt_origem.val_movto_empenh         =  orig_movto_empenh.val_movto_empenh. */
/*    */
                END.            
            end.
        END.
    END.
    
        
        /* Atualiza Saldo no Estrutura */
        FOR EACH tt_origem 
            WHERE tt_origem.cod_cta_ctbl_pai <> "":

            CASE tt_origem.num_orig_movto_empenh:
                when 1 /* T¡tulo APB Pendente */ then do:
                    ASSIGN tt_origem.ind_origem = "empenhado".

                end.
                when 2 /* T¡tulo APB */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".

                end.
                when 4 /* T¡tulo AP Pendente */ then do:
                    ASSIGN tt_origem.ind_origem = "empenhado".
                end.
                when 5 /* T¡tulo AP */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 6 /* Atendimento de Requisi‡Æo */      or
                when 8 /* Transa‡äes Diversas */            or
                when 20 /* Requisi‡Æo de Materiais */       or
                when 13 /* Entrada NF */                    or
                when 14 /* Devolu‡Æo NF */                  or 
                when 33 /* Req./Devol. Material MI */       or 
                when 34 /* Atend.Req./Solic. Material MI */ then do:

                    ASSIGN tt_origem.ind_origem = "realizado".
                  

                end.
                when 7 /* Requisi‡Æo/Solicita‡Æo de Compras */ then do:
                    ASSIGN tt_origem.ind_origem = "empenhado".
                end.
                when 18 /* Aprova‡Æo Cota‡Æo */ then do:
                    ASSIGN tt_origem.ind_origem = "empenhado".
                end.
                when 3  or
                when 21 or
                when 22 or
                when 23 or
                when 24 or 
                when 25 then do: /* EEC */
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 26 then do: /* FGL */
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 10 /* C. Compra sem Matriz */ or
                when 11 /* C. Compra com Matriz */ or
                when 12 /* C. Compra por Medi‡Æo */ then do: /* CNP */
                    ASSIGN tt_origem.ind_origem = "empenhado".
                end.
                when 32 /* Movto Conta Corrente 2.0 */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 35 /* Req./Solic. Material MI*/ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 36 /* MOB MI */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.
                when 37 /* GGF MI */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.    
                when 38 /* Movto Cta Corrente 5.0 */ then do:
                    ASSIGN tt_origem.ind_origem = "realizado".
                end.    

            END CASE.
        end.
            FOR EACH tt_origem WHERE tt_origem.ind_origem = "Empenhado" BREAK BY tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto:

                ACCUMULATE tt_origem.val_movto_empenh (SUB-TOTAL BY tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto).

                IF LAST-OF (tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto) THEN DO:

                    FIND FIRST tt_orcto_real WHERE tt_orcto_real.cod_empresa        = tt_origem.cod_empresa
                                             AND   tt_orcto_real.cod_plano_ccusto   = tt_origem.cod_plano_ccusto
                                             AND   tt_orcto_real.cod_plano_cta_ctbl = tt_origem.cod_plano_cta_ctbl
                                             AND   tt_orcto_real.cod_cta_ctbl       = tt_origem.cod_cta_ctbl 
                                             and   tt_orcto_real.cod_ccusto         = tt_origem.cod_ccusto NO-ERROR.
                                             
                    ASSIGN tt_orcto_real.val_ctbl_emp = ACCUM SUB-TOTAL BY (tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto) tt_origem.val_movto_empenh.
                END.
                            
            END.

            FOR EACH tt_origem WHERE tt_origem.ind_origem = "Realizado" BREAK BY tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto:

                ACCUMULATE tt_origem.val_movto_empenh (SUB-TOTAL BY tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto).

                IF LAST-OF (tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto) THEN DO:

                    FIND FIRST tt_orcto_real WHERE tt_orcto_real.cod_empresa        = tt_origem.cod_empresa
                                             AND   tt_orcto_real.cod_plano_ccusto   = tt_origem.cod_plano_ccusto
                                             AND   tt_orcto_real.cod_plano_cta_ctbl = tt_origem.cod_plano_cta_ctbl
                                             AND   tt_orcto_real.cod_cta_ctbl       = tt_origem.cod_cta_ctbl 
                                             and   tt_orcto_real.cod_ccusto         = tt_origem.cod_ccusto NO-ERROR.


                    ASSIGN tt_orcto_real.val_ctbl = tt_orcto_real.val_ctbl + ACCUM SUB-TOTAL BY (tt_origem.cod_cta_ctbl + tt_origem.cod_ccusto) tt_origem.val_movto_empenh.
                END.
                            
            END.

    if v_cod_ccusto <> "" then do:   

        FOR EACH tt_orcto_real 
            WHERE tt_orcto_real.cod_cta_ctbl_pai <> "":

            FIND FIRST btt_orcto_real
                WHERE btt_orcto_real.cod_empresa        = tt_orcto_real.cod_empresa
                  AND btt_orcto_real.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
                  AND btt_orcto_real.cod_ccusto         = tt_orcto_real.cod_ccusto
                  AND btt_orcto_real.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                  AND btt_orcto_real.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl_pai
                  AND btt_orcto_real.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                  AND btt_orcto_real.cod_exerc_ctbl     = tt_orcto_real.cod_exerc_ctbl
                  AND btt_orcto_real.num_period_ctbl    = tt_orcto_real.num_period_ctbl NO-ERROR.
            IF NOT AVAIL btt_orcto_real THEN DO:
                CREATE btt_orcto_real.
                ASSIGN btt_orcto_real.cod_empresa        = tt_orcto_real.cod_empresa
                       btt_orcto_real.cod_plano_ccusto   = tt_orcto_real.cod_plano_ccusto
                       btt_orcto_real.cod_ccusto         = tt_orcto_real.cod_ccusto
                       btt_orcto_real.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                       btt_orcto_real.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl_pai
                       btt_orcto_real.cod_cenar_ctbl     = tt_orcto_real.cod_cenar_ctbl
                       btt_orcto_real.cod_exerc_ctbl     = tt_orcto_real.cod_exerc_ctbl
                       btt_orcto_real.num_period_ctbl    = tt_orcto_real.num_period_ctbl
                       btt_orcto_real.cod_finalid_econ   = tt_orcto_real.cod_finalid_econ
                       btt_orcto_real.ind_espec_cta_ctbl = "Sint‚tica"
                       btt_orcto_real.log_estrut         = YES.
                FIND b_cta_ctbl NO-LOCK
                    WHERE b_cta_ctbl.cod_plano_cta_ctbl = tt_orcto_real.cod_plano_cta_ctbl
                      AND b_cta_ctbl.cod_cta_ctbl       = tt_orcto_real.cod_cta_ctbl_pai NO-ERROR.
                IF AVAIL b_cta_ctbl THEN DO:
                    ASSIGN btt_orcto_real.des_cta_ctbl = STRING (b_cta_ctbl.cod_cta_ctbl, v_cod_format_cta_ctbl) + " - " + b_cta_ctbl.des_tit_ctbl.
                END.
            END.
            ASSIGN btt_orcto_real.val_ctbl       = btt_orcto_real.val_ctbl
                                                 + tt_orcto_real.val_ctbl
                   btt_orcto_real.val_ctbl_emp   = btt_orcto_real.val_ctbl_emp
                                                 + tt_orcto_real.val_ctbl_emp
                   btt_orcto_real.val_ctbl_sdo   = btt_orcto_real.val_ctbl_sdo
                                                 + tt_orcto_real.val_ctbl_sdo
                   btt_orcto_real.val_orcado     = btt_orcto_real.val_orcado
                                                 + tt_orcto_real.val_orcado
                   btt_orcto_real.val_orcado_sdo = btt_orcto_real.val_orcado_sdo
                                                 + tt_orcto_real.val_orcado_sdo.
        end.
    end.
END.

procedure pi_inic_param:

   find emsuni.empresa no-lock
      where emsuni.empresa.cod_empresa = v_cod_empres_usuar no-error.
   if avail emsuni.empresa then do:
      assign v_cod_empresa = emsuni.empresa.cod_empresa
             v_rec_empresa = recid (emsuni.empresa).
   end.

   ASSIGN v_cod_cenar_ctbl   = "Fiscal"
          v_cod_finalid_econ = "Corrente".
   FIND exerc_ctbl NO-LOCK
       WHERE exerc_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
         AND exerc_ctbl.cod_exerc_ctbl = STRING (YEAR (TODAY)) NO-ERROR.
   FIND period_ctbl NO-LOCK
       WHERE period_ctbl.cod_cenar_ctbl = exerc_ctbl.cod_cenar_ctbl
         AND period_ctbl.cod_exerc_ctbl = exerc_ctbl.cod_exerc_ctbl
         AND period_ctbl.num_period_ctbl = INT (MONTH (TODAY)) NO-ERROR.
   IF AVAIL period_ctbl THEN DO:
       assign v_dat_final       = period_ctbl.dat_fim_period_ctbl
              v_dat_inicial     = period_ctbl.dat_inic_period_ctbl
              v_cod_exerc_ctbl  = period_ctbl.cod_exerc_ctbl
              v_num_period_ctbl = period_ctbl.num_period_ctbl.
   END.
   ELSE DO:
       FIND LAST period_ctbl NO-LOCK
           WHERE period_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl NO-ERROR.
       IF AVAIL period_ctbl THEN DO:
           assign v_dat_final       = period_ctbl.dat_fim_period_ctbl
                  v_dat_inicial     = period_ctbl.dat_inic_period_ctbl
                  v_cod_exerc_ctbl  = period_ctbl.cod_exerc_ctbl
                  v_num_period_ctbl = period_ctbl.num_period_ctbl.
       END.
   END.

end.

procedure pi_vld_param:

    IF v_cod_cenar_ctbl = "" THEN
        ASSIGN v_cod_cenar_ctbl = "Fiscal".
    FIND period_ctbl NO-LOCK
        WHERE period_ctbl.cod_cenar_ctbl  = v_cod_cenar_ctbl
          AND period_ctbl.cod_exerc_ctbl  = v_cod_exerc_ctbl
          AND period_ctbl.num_period_ctbl = v_num_period_ctbl NO-ERROR.
    IF NOT AVAIL period_ctbl THEN DO:
       assign v_wgh_focus = v_num_period_ctbl:handle in frame f_main.
       message "Per¡odo Cont bil inexistente!" view-as alert-box error.
       return "NOK".
    END.
    ASSIGN v_wgh_focus   = v_num_period_ctbl:HANDLE IN FRAME f_main
           v_arq_out     = v_arq_out 
                         + string (day (v_dat_inicial), "99")
                         + string (day (v_dat_final), "99")
                         + string (month (v_dat_final), "99")
                         + ".csv".

end.

procedure pi_salva_param:

/*    /* Recuperar parƒmetros da £ltima execu‡Æo */ */
/*    do transaction: */
/*       find emsfnd.dwb_set_list_param exclusive-lock */
/*          where emsfnd.dwb_set_list_param.cod_dwb_program = "esp_control_ctbz" */
/*            and emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren no-error. */
/*       if not avail emsfnd.dwb_set_list_param then do: */
/*          create emsfnd.dwb_set_list_param. */
/*          assign emsfnd.dwb_set_list_param.cod_dwb_program = "esp_control_ctbz" */
/*                 emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren. */
/*       end. */
/*       assign emsfnd.dwb_set_list_param.cod_dwb_parameters = v_cod_cenar_ctbl     + CHR(10) */
/*                                                           + v_cod_exerc_ctbl     + CHR(10) */
/*                                                           + STRING (v_num_period_ctbl) + CHR(10) */
/*                                                           + v_cod_estab_ini      + chr(10) */
/*                                                           + v_cod_estab_fim      + CHR(10) */
/*                                                           + v_cod_unid_negoc_ini + CHR(10) */
/*                                                           + v_cod_unid_negoc_fim. */
/*    end. */
/*    */
end.

procedure pi_dwb_set_list_param:

/*    find emsfnd.dwb_set_list_param no-lock */
/*       where emsfnd.dwb_set_list_param.cod_dwb_program = "esp_control_ctbz" */
/*         and emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren */
/*       use-index dwbstlsa_id no-error. */
/*    if avail emsfnd.dwb_set_list_param then do: */
/*       assign v_cod_cenar_ctbl     = entry (01, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)) */
/*              v_cod_exerc_ctbl     = entry (02, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)) */
/*              v_num_period_ctbl    = INT (entry (03, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))) */
/*              v_cod_estab_ini      = entry (04, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)) */
/*              v_cod_estab_fim      = entry (05, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)) */
/*              v_cod_unid_negoc_ini = entry (06, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)) */
/*              v_cod_unid_negoc_fim = entry (07, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)). */
/*    end. */
   FIND period_ctbl NO-LOCK
       WHERE period_ctbl.cod_cenar_ctbl = v_cod_cenar_ctbl
         AND period_ctbl.cod_exerc_ctbl = v_cod_exerc_ctbl
         AND period_ctbl.num_period_ctbl = v_num_period_ctbl NO-ERROR.
   IF AVAIL period_ctbl THEN DO:
       ASSIGN v_dat_inicial = period_ctbl.dat_inic_period_ctbl
              v_dat_final   = period_ctbl.dat_fim_period_ctbl.
   END.

end.

procedure pi_open_query:

   assign v_val_orcado     = 0
          v_val_realiz     = 0
          v_val_realiz_emp = 0
          v_val_orcado_sdo = 0
          v_val_realiz_sdo = 0.

   FOR EACH tt_orcto_real:  

       IF tt_orcto_real.cod_cta_ctbl_pai <> "" THEN DO:
           assign v_val_orcado     = v_val_orcado
                                   + tt_orcto_real.val_orcado
                  v_val_realiz     = v_val_realiz
                                   + tt_orcto_real.val_ctbl
                  v_val_realiz_emp = v_val_realiz_emp
                                   + tt_orcto_real.val_ctbl_emp
                  v_val_orcado_sdo = v_val_orcado_sdo
                                   + tt_orcto_real.val_orcado_sdo
                  v_val_realiz_sdo = v_val_realiz_sdo
                                   + tt_orcto_real.val_ctbl_sdo.
       END.
       ASSIGN tt_orcto_real.val_perc     = ((tt_orcto_real.val_ctbl + tt_orcto_real.val_ctbl_emp) / tt_orcto_real.val_orcado) * 100
              tt_orcto_real.val_perc_sdo = (tt_orcto_real.val_ctbl_sdo / tt_orcto_real.val_orcado_sdo) * 100.
   END.

   display v_val_orcado v_val_realiz v_val_realiz_emp
           v_val_orcado_sdo v_val_realiz_sdo
           with frame f_main.

   if v_cod_ccusto <> "" then do:
      OPEN QUERY qr_orcto
         FOR EACH tt_orcto_real
             WHERE tt_orcto_real.log_estrut = YES.
   end.
   else do:
      OPEN QUERY qr_orcto
         FOR EACH tt_orcto_real
             WHERE tt_orcto_real.log_estrut = no.
   end.

   FIND FIRST tt_orcto_real NO-LOCK NO-ERROR.    
   IF AVAIL tt_orcto_real THEN DO:
       br_orcto:DESELECT-SELECTED-ROW(1) in frame f_main.
   END.

end.

PROCEDURE pi_filtro:

    def rectangle rt_param
        size 45 by 3.60
        edge-pixels 2.
    
    def rectangle rt_cxft 
        size 45 by 1.50 
        edge-pixels 2.
    
    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.
    
    def button bt_ok
        label "&OK"
        tooltip "OK"
        size 10 by 1
        auto-go.
    
    def frame f_filtro
         rt_param
            at row 01.13 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
         v_log_acum LABEL "Realizado Acumulado"
            at row 02.38 col 14.00 colon-aligned 
            fgcolor ? bgcolor 17
         rt_cxft
            at row 5.10 col 1.00 COLON-ALIGNED
            fgcolor ? bgcolor 18
         bt_ok   at row 5.32 col 04.00 bgcolor 8 help "Fecha" 
         bt_can  at row 5.32 col 14.50 bgcolor 8 help "Cancela"     
         with 1 down side-labels no-validate keep-tab-order three-d 
              size-char 50.00 by 7.00 
              at row 01.13 col 01.00 
              font 1 fgcolor ? bgcolor 17 
              VIEW-AS DIALOG-BOX 
              title "Filtro - 12.00.00.000".
    
    on choose of bt_can in frame f_filtro do:
       return "error".
    end.

    on choose of bt_ok in frame f_filtro do:
       return "".
    end.
    
    display v_log_acum
            with frame f_filtro.
    
    enable all with frame f_filtro.

    WAIT-FOR GO OF FRAME f_filtro.

    ASSIGN INPUT FRAME f_filtro v_log_acum.           
           
end.

PROCEDURE pi_range:

    def rectangle rt_param
        size 45 by 2.60
        edge-pixels 2.
    
    def rectangle rt_cxft 
        size 45 by 1.50 
        edge-pixels 2.
    
    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.
    
    def button bt_ok
        label "&OK"
        tooltip "OK"
        size 10 by 1
        auto-go.
    
    def frame f_range
         rt_param
            at row 01.13 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
         v_cod_estab_ini LABEL "Estab Ini"
            at row 01.38 col 13.00 colon-aligned 
            view-as fill-in 
            fgcolor ? bgcolor 15 font 2
         bt_zoo_estini
            at row 01.30 col 19.14
         v_cod_estab_fim LABEL "at‚"
            at row 01.38 col 29.00 colon-aligned 
            view-as fill-in 
            fgcolor ? bgcolor 15 font 2
         bt_zoo_estfim
            at row 01.30 col 35.14
         v_cod_unid_negoc_ini LABEL "UNeg Ini"
            at row 02.50 col 13.00 colon-aligned 
            view-as fill-in 
            fgcolor ? bgcolor 15 font 2
         bt_zoo_unegini
            at row 02.42 col 19.14            
         v_cod_unid_negoc_fim LABEL "at‚"
            at row 02.50 col 29.00 colon-aligned 
            view-as fill-in 
            fgcolor ? bgcolor 15 font 2
         bt_zoo_unegfim
            at row 02.42 col 35.14
         rt_cxft
            at row 4.10 col 1.00 COLON-ALIGNED
            fgcolor ? bgcolor 18
         bt_ok   at row 4.32 col 04.00 bgcolor 8 help "Fecha" 
         bt_can  at row 4.32 col 14.50 bgcolor 8 help "Cancela"     
         with 1 down side-labels no-validate keep-tab-order three-d 
              size-char 50.00 by 6.00 
              at row 01.13 col 01.00 
              font 1 fgcolor ? bgcolor 17 
              VIEW-AS DIALOG-BOX 
              title "Faixas - 12.00.00.000".
    
    on choose of bt_can in frame f_range do:
       return "error".
    end.

    on choose of bt_ok in frame f_range do:
       return "".
    end.
    
    /*--- Estabelecimento Inicial ---*/
    on leave of v_cod_estab_ini in frame f_range do:
       find estabelecimento no-lock
          where estabelecimento.cod_estab = input frame f_range v_cod_estab_ini no-error.
       if avail estabelecimento then do:
          assign v_cod_estab_fim = estabelecimento.cod_estab.
       end.
    end.
    
    on choose of bt_zoo_estini in frame f_range
    or F5 of v_cod_estab_ini in frame f_range do:
        if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
            message "Programa execut vel nÆo foi encontrado:"  "prgint/utb/utb071na.p"
                   view-as alert-box error buttons ok.
            return.
        end.
        else
            run prgint/utb/utb071na.p (input v_cod_empres_usuar).
        if  v_rec_estabelecimento <> ? then do:
            find estabelecimento
              where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
            assign v_cod_estab_ini:screen-value in frame f_range = estabelecimento.cod_estab.
            apply "leave" to v_cod_estab_ini in frame f_range.
            apply "entry" to v_cod_estab_ini in frame f_range.
        end.
    end.

    /*--- Estabelecimento Final ---*/
    on leave of v_cod_estab_fim in frame f_range do:
       find estabelecimento no-lock
          where estabelecimento.cod_estab = input frame f_range v_cod_estab_fim no-error.
       if avail estabelecimento then do:
          assign v_cod_estab_fim = estabelecimento.cod_estab.
       end.
    end.
    
    on choose of bt_zoo_estfim in frame f_range 
    or F5 of v_cod_estab_fim in frame f_range do:
        if  search("prgint/utb/utb071na.r") = ? and search("prgint/utb/utb071na.p") = ? then do:
            message "Programa execut vel nÆo foi encontrado:"  "prgint/utb/utb071na.p"
                   view-as alert-box error buttons ok.
            return.
        end.
        else
            run prgint/utb/utb071na.p (input v_cod_empres_usuar).
        if  v_rec_estabelecimento <> ? then do:
            find estabelecimento
              where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.
            assign v_cod_estab_fim:screen-value in frame f_range = estabelecimento.cod_estab.
            apply "leave" to v_cod_estab_fim in frame f_range.
            apply "entry" to v_cod_estab_fim in frame f_range.
        end.
    end.
    
    /*--- Unidade de Neg¢cio Inicial ---*/
    on leave of v_cod_unid_negoc_ini in frame f_range do:
       find unid_negoc no-lock
          where unid_negoc.cod_unid_negoc = input frame f_range v_cod_unid_negoc_ini no-error.
       if avail unid_negoc then do:
          assign v_cod_unid_negoc_fim = unid_negoc.cod_unid_negoc.
       end.
    end.
    
    on choose of bt_zoo_unegini in frame f_range 
    or F5 of v_cod_unid_negoc_ini in frame f_range do:
        if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
            message "Programa execut vel nÆo foi encontrado:"  "prgint/utb/utb011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
        else
            run prgint/utb/utb011ka.p.
        if  v_rec_unid_negoc <> ? then do:
            find unid_negoc
              where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
            assign v_cod_unid_negoc_ini:screen-value in frame f_range = unid_negoc.cod_unid_negoc.
            apply "leave" to v_cod_unid_negoc_ini in frame f_range.
            apply "entry" to v_cod_unid_negoc_ini in frame f_range.
        end.
    end.
    
    /*--- Unidade de Neg¢cio Final ---*/
    on leave of v_cod_unid_negoc_fim in frame f_range do:
       find unid_negoc no-lock
          where unid_negoc.cod_unid_negoc = input frame f_range v_cod_unid_negoc_fim no-error.
       if avail unid_negoc then do:
          assign v_cod_unid_negoc_fim = unid_negoc.cod_unid_negoc.
       end.
    end.
    
    on choose of bt_zoo_unegfim in frame f_range 
    or F5 of v_cod_unid_negoc_fim in frame f_range do:
       if  search("prgint/utb/utb011ka.r") = ? and search("prgint/utb/utb011ka.p") = ? then do:
           message "Programa execut vel nÆo foi encontrado:"  "prgint/utb/utb011ka.p"
                  view-as alert-box error buttons ok.
           return.
       end.
       else
           run prgint/utb/utb011ka.p.
       if  v_rec_unid_negoc <> ? then do:
           find unid_negoc
             where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
           assign v_cod_unid_negoc_fim:screen-value in frame f_range = unid_negoc.cod_unid_negoc.
           apply "leave" to v_cod_unid_negoc_fim in frame f_range.
           apply "entry" to v_cod_unid_negoc_fim in frame f_range.
       end.
    end.

        
    display v_cod_estab_ini
            v_cod_estab_fim
            v_cod_unid_negoc_ini
            v_cod_unid_negoc_fim
            with frame f_range.
    
    enable all with frame f_range.
    apply "entry" to v_cod_estab_ini in frame f_range.
    
    wait-for go of frame f_range.
    ASSIGN INPUT FRAME f_range v_cod_estab_ini
           INPUT FRAME f_range v_cod_estab_fim
           INPUT FRAME f_range v_cod_unid_negoc_ini
           INPUT FRAME f_range v_cod_unid_negoc_fim.
           
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

    if  p_val_curr = 0 then do:
        assign v_des_percent_complete:width-pixels     in frame f_perc = 1
               v_des_percent_complete:bgcolor          in frame f_perc = 1
               v_des_percent_complete:fgcolor          in frame f_perc = 15
               v_des_percent_complete:font             in frame f_perc = 1
               rt_005:bgcolor                          in frame f_perc = 17
               v_des_percent_complete_fnd:width-pixels in frame f_perc = 315
               v_des_percent_complete_fnd:font         in frame f_perc = 1.
        if  p_nom_title <> "" then do:
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
        if  p_nom_title <> "" then do:
            assign frame f_perc:title = p_nom_title.
        end.
        else do:
            assign frame f_perc:title = "Aguarde, em processamento...".
        end.
        view frame f_perc.
    end.
    display v_des_percent_complete
            v_des_percent_complete_fnd
            with frame f_perc.
    enable all with frame f_perc.
    process events.

end.

PROCEDURE pi_cria_tt_ccusto:

    FOR EACH ccusto no-lock
       WHERE ccusto.cod_empresa      = v_cod_empres_usuar
         AND ccusto.cod_plano_ccusto = cc-plano /*"CCDOCOL"*/:

        /*RUN pi_verifica_segur_ccusto (BUFFER ccusto,
                                      OUTPUT v_log_segur).
        if v_log_segur = NO THEN DO:
            NEXT.
        END.*/
        /*IF CAN-FIND (FIRST sdo_orcto_ctbl_bgc 
                     WHERE sdo_orcto_ctbl_bgc.cod_empresa      = ccusto.cod_empresa
                       AND sdo_orcto_ctbl_bgc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                       AND sdo_orcto_ctbl_bgc.cod_ccusto       = ccusto.cod_ccusto) THEN DO:*/
        
            CREATE tt_ccusto.
            ASSIGN tt_ccusto.rec_ccusto        = RECID (ccusto)
                   tt_ccusto.cod_empresa       = ccusto.cod_empresa
                   tt_ccusto.cod_plano_ccusto  = ccusto.cod_plano_ccusto
                   tt_ccusto.cod_ccusto        = ccusto.cod_ccusto
                   tt_ccusto.cod_format_ccusto = v_cod_format_ccusto
                   tt_ccusto.des_tit_ctbl      = ccusto.des_tit_ctbl.
        /*END.*/
    END.
END.

PROCEDURE pi_verifica_segur_ccusto:

    DEF PARAM BUFFER p_ccusto     FOR emsuni.ccusto.
    DEF OUTPUT PARAM p_log_segur AS LOG NO-UNDO.

    ASSIGN p_log_segur = NO.

    IF CAN-FIND (FIRST segur_ccusto
                 WHERE segur_ccusto.cod_empresa      = p_ccusto.cod_empresa
                   AND segur_ccusto.cod_plano_ccusto = p_ccusto.cod_plano_ccusto
                   AND segur_ccusto.cod_ccusto       = p_ccusto.cod_ccusto
                   AND segur_ccusto.cod_grp_usuar    = "*") THEN DO:
        ASSIGN p_log_segur = yes.
    END.
    ELSE DO:
        cc_block:
        FOR EACH segur_ccusto NO-LOCK
            WHERE segur_ccusto.cod_empresa      = p_ccusto.cod_empresa
              AND segur_ccusto.cod_plano_ccusto = p_ccusto.cod_plano_ccusto
              AND segur_ccusto.cod_ccusto       = p_ccusto.cod_ccusto:

            IF CAN-FIND(FIRST usuar_grp_usuar
                        WHERE usuar_grp_usuar.cod_grp_usuar = segur_ccusto.cod_grp_usuar
                          AND usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren) THEN DO:
                ASSIGN p_log_segur = YES.
                LEAVE cc_block.
            END.
        END.
    END.

END.

PROCEDURE pi_sea_ccusto:

    def rectangle rt_param
        size 67 by 8.60
        edge-pixels 2.

    def rectangle rt_cxft 
        size 67 by 1.50 
        edge-pixels 2.

    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.

    def button bt_ok
        label "&OK"
        tooltip "OK"
        size 10 by 1
        auto-go.

    DEF QUERY qr_ccusto FOR tt_ccusto.
    def browse br_ccusto query qr_ccusto 
        display tt_ccusto.cod_ccusto   width-chars 6.00 column-label "Ccusto"
                tt_ccusto.des_tit_ctbl width-chars 42.00
                with separators multiple SIZE 64.00 by 07.60 
                     font 2 bgcolor 15
                     title "Centros de Custo".

    def frame f_sea_ccusto
         rt_param
            at row 01.13 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
         rt_cxft
            at row 10.10 col 1.00 colon-aligned 
            fgcolor ? bgcolor 18
         br_ccusto at row 01.60 col 04.50
         bt_ok   at row 10.38 col 04.00 bgcolor 8 help "Fecha" 
         bt_can  at row 10.38 col 14.50 bgcolor 8 help "Cancela"     
         with 1 down side-labels no-validate keep-tab-order three-d 
              size-char 72.00 by 12.00 
              at row 01.13 col 01.00 
              font 1 fgcolor ? bgcolor 17 
              VIEW-AS DIALOG-BOX 
              title "Pesquisa Centro de Custos Usu rio - 12.00.00.000".

    ON choose OF bt_can IN FRAME f_sea_ccusto DO:
        ASSIGN v_cod_ccusto_aux = "".
    END.

    on mouse-select-dblclick of br_ccusto in frame f_sea_ccusto do:

        apply "value-changed" to br_ccusto in frame f_sea_ccusto.
        apply "go" to frame f_sea_ccusto.

    end.

    ON VALUE-CHANGED OF br_ccusto IN FRAME f_sea_ccusto do:

        IF AVAIL tt_ccusto THEN DO:
            ASSIGN v_cod_ccusto_aux = tt_ccusto.cod_ccusto.
        END.
        ELSE
            ASSIGN v_cod_ccusto_aux = ?.

    END.
    
    ON 'ESC' OF FRAME f_sea_ccusto DO:
        ASSIGN v_cod_ccusto_aux = "".        
    END.

    OPEN QUERY qr_ccusto
        FOR EACH tt_ccusto NO-LOCK.

    DISPLAY br_ccusto
            WITH FRAME f_sea_ccusto.

    ENABLE ALL  WITH FRAME f_sea_ccusto.
    APPLY "value-changed" TO br_ccusto IN FRAME f_sea_ccusto.
    WAIT-FOR GO OF FRAME f_sea_ccusto.

END.

PROCEDURE pi_sea_grupo:

    def rectangle rt_param
        size 67 by 8.60
        edge-pixels 2.

    def rectangle rt_cxft 
        size 67 by 1.50 
        edge-pixels 2.

    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.

    def button bt_ok
        label "&OK"
        tooltip "OK"
        size 10 by 1
        auto-go.

    DEF QUERY qr_grupo FOR dc-orc-grupo.
    def browse br_grupo query qr_grupo 
        display dc-orc-grupo.cod-grupo width-chars 12.00 column-label "Grupo OBZ"
                dc-orc-grupo.descricao width-chars 50.00
                with separators multiple SIZE 64.00 by 07.60 
                     font 2 bgcolor 15
                     title "Grupo de Contas Or‡amento".

    def frame f_sea_grupo
         rt_param
            at row 01.13 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
         rt_cxft
            at row 10.10 col 1.00 colon-aligned 
            fgcolor ? bgcolor 18
         br_grupo at row 01.60 col 04.50
         bt_ok    at row 10.38 col 04.00 bgcolor 8 help "Fecha" 
         bt_can   at row 10.38 col 14.50 bgcolor 8 help "Cancela"     
         with 1 down side-labels no-validate keep-tab-order three-d 
              size-char 72.00 by 12.00 
              at row 01.13 col 01.00 
              font 1 fgcolor ? bgcolor 17 
              VIEW-AS DIALOG-BOX 
              title "Pesquisa Grupo de Contas - 12.00.00.000".

    ON choose OF bt_can IN FRAME f_sea_grupo DO:
        ASSIGN v-cod-grupo-aux = "".
    END.

    on mouse-select-dblclick of br_grupo in frame f_sea_grupo do:

        apply "value-changed" to br_grupo in frame f_sea_grupo.
        apply "go" to frame f_sea_grupo.

    end.

    ON VALUE-CHANGED OF br_grupo IN FRAME f_sea_grupo do:
        IF AVAIL dc-orc-grupo THEN DO:
            ASSIGN v-cod-grupo-aux = dc-orc-grupo.cod-grupo.
        END.
        ELSE
            ASSIGN v-cod-grupo-aux = ?.
    END.
    
    ON 'ESC' OF FRAME f_sea_grupo DO:
        ASSIGN v-cod-grupo-aux = "".        
    END.

    OPEN QUERY qr_grupo
        FOR EACH dc-orc-grupo NO-LOCK WHERE dc-orc-grupo.cod-grupo >= "".

    DISPLAY br_grupo
            WITH FRAME f_sea_grupo.

    ENABLE ALL  WITH FRAME f_sea_grupo.
    APPLY "value-changed" TO br_grupo IN FRAME f_sea_grupo.
    WAIT-FOR GO OF FRAME f_sea_grupo.

END.

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes then do:
        delete procedure this-procedure.
    end.

END PROCEDURE.

PROCEDURE pi_email:

    def rectangle rt_key
        size 70 by 3.60
        edge-pixels 2.
    def rectangle rt_cxft 
        size 70 by 1.50 
        edge-pixels 2.
    def rectangle rt_cxft_1
        size 40 by 1.50 
        edge-pixels 2.
    
    def button bt_ok
        label "&Envia"
        tooltip "Envia e-mail"
        size 10 by 1
        auto-go.
    
    def button bt_can
        label "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.

    def button bt_zoo_para
        label "Zoom" tooltip "Zoom"
        image-up file "image/im-zoo"
        image-insensitive file "image/ii-zoo"
        size 4 by .88.
    def button bt_zoo_copia
        label "Zoom" tooltip "Zoom"
        image-up file "image/im-zoo"
        image-insensitive file "image/ii-zoo"
        size 4 by .88.

    DEF VAR v_wgh_foc                 AS  WIDGET-HANDLE NO-UNDO.
    DEF VAR v_log_sav                 AS LOG NO-UNDO.

    def frame f_email
        rt_key
            at row 01.63 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
        v_des_para
            at row 01.91 col 06.00 COLON-ALIGNED LABEL "Para"
            view-as fill-in
            size-chars 60.14 by .88
            fgcolor ? bgcolor 15 font 2
        bt_zoo_para
            at row 01.91 col 66.30 colon-aligned
        v_des_copia
            at row 02.91 COL 06.00 COLON-ALIGNED LABEL "Cc"
            view-as EDITOR 
            size-chars 60.14 by 2
            fgcolor ? bgcolor 15 font 2
        bt_zoo_copia
            at row 02.91 col 66.30 COLON-ALIGNED
        rt_cxft
            at row 05.50 col 1.00 colon-aligned 
            fgcolor ? BGCOLOR 18
        bt_ok   at row 05.73 col 04.00 bgcolor 8 help "Envia" 
        bt_can  at row 05.73 col 14.40 bgcolor 8 help "Cancela"     
        with 1 down side-labels no-validate keep-tab-order three-d 
             size-char 75.00 by 07.50 
             at row 01.13 col 01.00 
             font 1 fgcolor ? bgcolor 17 
             VIEW-AS DIALOG-BOX 
             title "Envia E-mail - 12.00.00.000".
    
    ON CHOOSE OF bt_zoo_para IN FRAME f_email 
    OR F5 OF v_des_para IN FRAME f_email DO:
        ASSIGN v_rec_usuar_mestre = ?
               INPUT FRAME f_email v_des_para.
        RUN sec/sec000ka.p.
        if v_rec_usuar_mestre <> ? then do:
            FIND usuar_mestre NO-LOCK
                WHERE RECID (usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
            IF v_des_para = "" THEN
                ASSIGN v_des_para:SCREEN-VALUE IN FRAME f_email = usuar_mestre.cod_e_mail_local.
            ELSE
                ASSIGN v_des_para:SCREEN-VALUE IN FRAME f_email = v_des_para + ";" + TRIM (usuar_mestre.cod_e_mail_local).
            APPLY "entry" to v_des_para in frame f_email.
        end.
    end.

    ON CHOOSE OF bt_zoo_copia IN FRAME f_email 
    OR F5 OF v_des_copia IN FRAME f_email DO:
        ASSIGN v_rec_usuar_mestre = ?
               INPUT FRAME f_email v_des_copia.
        RUN sec/sec000ka.
        if v_rec_usuar_mestre <> ? then do:
            FIND usuar_mestre NO-LOCK
                WHERE RECID (usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
            IF v_des_copia = "" THEN
                ASSIGN v_des_copia:SCREEN-VALUE IN FRAME f_email = usuar_mestre.cod_e_mail_local.
            ELSE
                ASSIGN v_des_copia:SCREEN-VALUE IN FRAME f_email = v_des_copia + ";" + TRIM (usuar_mestre.cod_e_mail_local).
            APPLY "entry" to v_des_copia in frame f_email.
        end.
    end.

    ASSIGN v_wgh_foc  = v_des_para:handle in frame f_email
           v_des_para = ""
           v_log_sav  = YES.

    main_block:
    REPEAT WHILE v_log_sav = yes on endkey undo main_block, leave main_block
       ON ERROR UNDO main_block, retry main_block with frame f_email:
       ASSIGN v_log_sav   = NO.
       ENABLE ALL
              WITH FRAME f_email.
       DISPLAY v_des_para
               v_des_copia
               WITH FRAME f_email.
       APPLY "entry" TO v_des_para IN FRAME f_email.
       IF VALID-HANDLE (v_wgh_foc) THEN DO:
          WAIT-FOR GO OF FRAME f_email FOCUS v_wgh_foc.
       END.
       ELSE DO:
          WAIT-FOR GO OF FRAME f_email.
       END.
       ASSIGN INPUT FRAME f_email v_des_para
              INPUT FRAME f_email v_des_copia.
       /*--- Valida E-mail ---*/
       /*RUN pi_vld_email.*/
       
    END.    
    
    HIDE FRAME f_email NO-PAUSE.

    RUN pi_envia_email (INPUT "Saldos").

END.

PROCEDURE pi_envia_email:

    DEF INPUT PARAM p_ind_acao AS CHAR NO-UNDO.

    DEF VAR v_log_servid_exchange AS LOG  NO-UNDO.
    DEF VAR v_cod_servid_e_mail   AS CHAR NO-UNDO.
    DEF VAR v_num_porta           AS INT  NO-UNDO.


    DEF VAR v_num_seq_refer AS INT NO-UNDO.
    DEF VAR v_des_from     AS CHAR NO-UNDO.
    DEF VAR v_des_period   AS CHAR NO-UNDO.
    DEF VAR v_nom_subject  AS CHAR NO-UNDO.
    DEF VAR v_nom_message  AS CHAR NO-UNDO.
    DEF VAR v_num_mensagem AS INT NO-UNDO.
    DEF VAR v_ind_titulo   AS CHAR NO-UNDO.
            
    IF STRING (TIME, "HH:MM") < "12" THEN
        ASSIGN v_des_period = "Bom dia!".
    ELSE
        ASSIGN v_des_period = "Boa tarde!".

    FIND usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:
        ASSIGN v_des_from = usuar_mestre.cod_e_mail_local.
    END.

    CASE p_ind_acao:
        WHEN "Saldos" THEN DO:
            ASSIGN v_nom_subject = "Extrato Saldos Or‡ados X Realizados"
                   v_nom_message = '<HTML><BODY><font face="Times New Roman" size=3>' + '<h3><p><font color="black">' + v_des_period + '</font></p></h3>'
                                 + '<p5><p>Anexo o Extrato dos Saldos Or‡ados e Realizados.'
                                 + '<br>' 
                                 + '<p>Relat¢rio gerado atrav‚s da Consulta Espec¡fica: dbgc201.</p>'
                                 + '<p>Atenciosamente,</p>'
                                 + '<img src=http://imageshack.com/a/img903/7981/5noQ5b.jpg>'
                                 + '</BODY></HTML>'. 
        END.
        WHEN "Movimentos" THEN DO:
            ASSIGN v_nom_subject = "Extrato Movimentos Empenhados e Realizados"
                   v_nom_message = '<HTML><BODY><font face="Times New Roman" size=3>' + '<h3><p><font color="black">' + v_des_period + '</font></p></h3>'
                                 + '<p5><p>Anexo o Extrato dos Movimentos Empenhados e Realizados.'
                                 + '<br>' 
                                 + '<p>Relat¢rio gerado atrav‚s da Consulta Espec¡fica: dbgc201.</p>'
                                 + '<p>Atenciosamente,</p>'
                                 + '<img src=http://imageshack.com/a/img903/7981/5noQ5b.jpg>'
                                 + '</BODY></HTML>'. 
        END.
    END CASE.

    EMPTY TEMP-TABLE tt_mail_fax.
    EMPTY TEMP-TABLE tt_erros_mail_fax.

    &IF '{&emsfin_version}' < '5.07A' &THEN
    FIND FIRST param_geral_btb NO-LOCK  NO-ERROR.
    IF NOT AVAIL param_geral_btb THEN
        RETURN.
    ASSIGN v_log_servid_exchange = param_geral_btb.log_servid_exchange
           v_cod_servid_e_mail   = param_geral_btb.cod_ip_servid_mail
           v_num_porta           = param_geral_btb.num_porta_servid_mail.
    &ELSE
    FIND FIRST param_email NO-LOCK WHERE
               param_email.cod_servid_e_mail >= "" NO-ERROR.
    IF NOT AVAIL param_email THEN
        RETURN.
    ASSIGN v_log_servid_exchange = param_email.log_servid_exchange
           v_cod_servid_e_mail   = param_email.cod_servid_e_mail
           v_num_porta           = param_email.num_porta.
    &ENDIF

    CREATE tt_mail_fax.
    ASSIGN tt_mail_fax.ttv_log_exchange     = v_log_servid_exchange
           tt_mail_fax.ttv_nom_servid       = v_cod_servid_e_mail
           tt_mail_fax.ttv_num_porta_servid = v_num_porta
           tt_mail_fax.ttv_nom_from         = v_des_from
           tt_mail_fax.ttv_nom_to           = v_des_para
           tt_mail_fax.ttv_nom_cc           = v_des_copia
           tt_mail_fax.ttv_nom_subject      = v_nom_subject
           tt_mail_fax.ttv_nom_message      = v_nom_message
           tt_mail_fax.ttv_cod_format_mail  = "html"
           tt_mail_fax.ttv_nom_attachfile   = v_arq_email.

    run prgtec/btb/btb916za.p (input "1",
                               INPUT TABLE tt_mail_fax,
                               OUTPUT TABLE tt_erros_mail_fax).

    FOR EACH tt_erros_mail_fax NO-LOCK:       
        assign v_num_mensagem   = INT (tt_erros_mail_fax.ttv_cod_erro).
        create tt_log_erros_atualiz. 
        assign v_num_seq_refer = v_num_seq_refer + 1
               tt_log_erros_atualiz.tta_cod_estab       = "" 
               tt_log_erros_atualiz.tta_cod_refer       = tt_erros_mail_fax.ttv_cod_erro 
               tt_log_erros_atualiz.tta_num_seq_refer   = v_num_seq_refer 
               tt_log_erros_atualiz.ttv_ind_tip_relacto = "" 
               tt_log_erros_atualiz.ttv_num_relacto     = 0 
               tt_log_erros_atualiz.ttv_num_mensagem    = 0 
               tt_log_erros_atualiz.ttv_des_msg_erro    = tt_erros_mail_fax.ttv_des_erro
               tt_log_erros_atualiz.ttv_des_msg_ajuda   = tt_erros_mail_fax.ttv_des_erro.        
    END.

END.

PROCEDURE pi_tt_param_bloq:

    DEF VAR v_dat_ini          AS DATE FORMAT "99/99/9999" LABEL "In¡cio" NO-UNDO.
    DEF VAR v_dat_fim          AS DATE FORMAT "99/99/9999" LABEL "Final" NO-UNDO.
    DEF VAR v_num_bloq         AS INT NO-UNDO.
    DEF VAR v_num_mes          AS INT NO-UNDO.
    DEF VAR v_num_aux          AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt_param_bloq.

    ASSIGN v_num_mes = MONTH (v_dat_final).

    FOR EACH param_bloq_exec_orctaria NO-LOCK WHERE
             param_bloq_exec_orctaria.num_tip_inform_organ >= 0 AND
             param_bloq_exec_orctaria.cod_inform_organ     >= "":
        FIND tt_param_bloq 
            WHERE tt_param_bloq.num_tip_inform = param_bloq_exec_orctaria.num_tip_inform_organ
              AND tt_param_bloq.cod_inform     = param_bloq_exec_orctaria.cod_inform_organ  NO-ERROR.
        IF NOT AVAIL tt_param_bloq THEN DO:
            CREATE tt_param_bloq.
            ASSIGN tt_param_bloq.num_tip_inform  = param_bloq_exec_orctaria.num_tip_inform_organ
                   tt_param_bloq.cod_inform      = param_bloq_exec_orctaria.cod_inform_organ
                   tt_param_bloq.num_period_bloq = param_bloq_exec_orctaria.num_periodic_bloq.
            IF tt_param_bloq.num_tip_inform = 2 /* Cta Ctbl*/ THEN DO:
                ASSIGN tt_param_bloq.cod_inform = REPLACE (tt_param_bloq.cod_inform, v_cod_plano_cta_ctbl, ";")
                       tt_param_bloq.cod_inform = TRIM (ENTRY (2, tt_param_bloq.cod_inform, CHR(59))).
            END.
        END.
        ASSIGN v_num_bloq = param_bloq_exec_orctaria.num_periodic_bloq.
        CASE v_num_bloq:
            WHEN 1 THEN DO: /* Mensal */
                ASSIGN tt_param_bloq.des_period_bloq = "Mensal"
                       v_dat_ini = v_dat_inicial
                       v_dat_fim = v_dat_final.
            END.
            WHEN 2 THEN DO: /* Trimestral */
                ASSIGN tt_param_bloq.des_period_bloq = "Trimestral".
                IF (v_num_mes MOD 3) = 0 THEN
                    ASSIGN v_num_aux = v_num_mes.    
                ELSE
                    ASSIGN v_num_aux = (INT (SUBSTR (STRING (DEC (v_num_mes / 3)), 1, 1)) + 1) * 3.
                IF v_num_aux < 12 THEN
                    ASSIGN v_dat_fim = DATE (v_num_aux + 1, 01, YEAR (v_dat_final)) - 1
                           v_dat_ini = DATE (MONTH (v_dat_fim) - 2, 01, YEAR (v_dat_fim)).
                ELSE
                    ASSIGN v_dat_fim = DATE (12, 01, YEAR (v_dat_final))
                           v_dat_ini = DATE (10, 01, YEAR (v_dat_final)).
            END.
            WHEN 3 THEN DO: /* Semestral */
                ASSIGN tt_param_bloq.des_period_bloq = "Semestral".
                IF (v_num_mes MOD 6) = 0 THEN
                    ASSIGN v_num_aux = v_num_mes.    
                ELSE
                    ASSIGN v_num_aux = (INT (SUBSTR (STRING (DEC (v_num_mes / 6)), 1, 1)) + 1) * 6.
                IF v_num_aux < 12 THEN
                    ASSIGN v_dat_fim = DATE (v_num_aux + 1, 01, YEAR (v_dat_final)) - 1
                           v_dat_ini = DATE (MONTH (v_dat_fim) - 5, 01, YEAR (v_dat_fim)).
                ELSE
                    ASSIGN v_dat_fim = DATE (12, 01, YEAR (v_dat_final))
                           v_dat_ini = DATE (7, 01, YEAR (v_dat_fim)).
            END.
            WHEN 4 THEN DO: /* Anual */
                ASSIGN tt_param_bloq.des_period_bloq = "Anual"
                       v_dat_fim = DATE (12, 01, YEAR (v_dat_final))
                       v_dat_ini = DATE (01, 01, YEAR (v_dat_final)).
            END.
            WHEN 5 THEN DO: /* At‚ o Per¡odo */
                ASSIGN tt_param_bloq.des_period_bloq = "At‚ o Per¡odo"
                       v_dat_ini = DATE (01, 01, YEAR (v_dat_final)).
                IF v_num_mes < 12 THEN
                    ASSIGN v_dat_fim = DATE (v_num_mes + 1, 01, YEAR (v_dat_final)) - 1.                   
                ELSE
                    ASSIGN v_dat_fim = DATE (12, 01, YEAR (v_dat_final)).
            END.
            WHEN 6 THEN DO: /* Ap¢s Per¡odo */
                ASSIGN tt_param_bloq.des_period_bloq = "Ap¢s Per¡odo"
                       v_dat_ini = DATE (v_num_mes, 01, YEAR (v_dat_final))
                       v_dat_fim = DATE (01, 01, YEAR (v_dat_final) + 1 ) - 1.                   
            END.
            WHEN 7 THEN DO: /* Flutuante */
                ASSIGN tt_param_bloq.des_period_bloq = "Flutuante"
                       v_num_aux = param_bloq_exec_orctaria.qtd_period_bloq_flut.
                IF v_num_mes - v_num_aux <= 1 THEN
                    ASSIGN v_num_aux = 1.
                ELSE
                    ASSIGN v_num_aux = v_num_mes - v_num_aux.
                ASSIGN v_dat_ini = DATE (v_num_aux, 01, YEAR (v_dat_inicial))
                       v_num_aux = param_bloq_exec_orctaria.qtd_period_bloq_flut.
                IF v_num_mes + v_num_aux >= 12 THEN
                    ASSIGN v_num_aux = 12.
                ELSE
                    ASSIGN v_num_aux = v_num_mes + v_num_aux.
                IF v_num_aux < 12 THEN
                    ASSIGN v_dat_fim = DATE (v_num_aux + 1, 01, YEAR (v_dat_ini)) - 1.
                ELSE
                    ASSIGN v_dat_fim = DATE (12, 01, YEAR (v_dat_final)).
            END.
        END CASE.
        ASSIGN tt_param_bloq.dat_inicial = v_dat_ini
               tt_param_bloq.dat_final   = v_dat_fim.        
    END.

END.

