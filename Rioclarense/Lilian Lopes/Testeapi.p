def temp-table tt_empresa no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_id                           
          tta_cod_empresa                  ascending
    .

def temp-table tt_empresa_selec no-undo like emsbas.empresa
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_cod_empresa                   is primary unique
          tta_cod_empresa                  ascending
    .

def temp-table tt_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_cod_desc_erro                as character format "x(8)"
    .

def temp-table tt_espec_docto no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    index tt_espec_docto                  
          tta_cod_espec_docto              ascending
    .


def temp-table tt_titulos_em_aberto_acr no-undo
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(5)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parcela"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field ttv_nom_abrev_clien              as character format "x(12)" label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abrev"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cdn_clien_matriz             as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Matriz" column-label "Cliente Matriz"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaá∆o" column-label "Liquidaá∆o"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T°tulo" column-label "Vl Original T°tulo"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field ttv_val_origin_tit_acr_apres     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Original Apres" column-label "Vl Original Apres"
    field ttv_val_sdo_tit_acr_apres        as decimal format "->>>,>>>,>>9.99" decimals 2 label "Saldo Finalid Apres" column-label "Saldo Apres"
    field ttv_num_atraso_dias_acr          as integer format "->>>>>>9" label "Dias" column-label "Dias"
    field ttv_val_movto_tit_acr_pmr        as decimal format "->>>,>>>,>>>,>>9.99" decimals 2 label "Val Movto PMR" column-label "Val Movto PMR"
    field ttv_val_movto_tit_acr_amr        as decimal format "->>>,>>>,>>>,>>9.99" decimals 2 label "Val Movto AMR" column-label "Val Movto AMR"
    field tta_val_movto_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field ttv_rec_tit_acr                  as recid format ">>>>>>9"
    field ttv_cod_dwb_field_rpt            as character extent 13 format "x(32)" label "Conjunto" column-label "Conjunto"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    field tta_dat_indcao_perda_dedut       as date format "99/99/9999" initial ? label "Data Indicaá∆o" column-label "Data Indicaá∆o"
    field ttv_dat_tit_acr_aber             as date format "99/99/9999" initial today label "Posiá∆o Em" column-label "Posiá∆o Em"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condiá∆o Cobranáa" column-label "Cond Cobranáa"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field ttv_val_impto_retid              as decimal format ">>>>,>>>,>>9.99" decimals 2 label "Impto Retido" column-label "Imposto Retido"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    field ttv_nom_cidad_cobr               as character format "x(30)" label "Cidade Cobranáa" column-label "Cidade Cobranáa"
    field tta_cod_safra                    as character format "9999/9999" label "Safra" column-label "Safra"
    field tta_cod_contrat_graos            as character format "x(20)" label "Contrato Gr∆os" column-label "Contr Gr∆os"
    index tt_cod_empr_estab               
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_unid_negoc               ascending
    index tt_proc_export                  
          ttv_cod_proces_export            ascending
    .

def temp-table tt_titulos_em_aberto_acr_compl no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_unid_negoc               ascending
    .
def temp-table tt_clien_consid no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_cod_unid_federac             as character format "x(3)" label "Estado" column-label "UF"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field ttv_cdn_clien_matriz             as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Matriz" column-label "Cliente Matriz"
    index tt_idx                           is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    .


/************************** Buffer Definition Begin *************************/

def buffer b_compl_cond_cobr_acr
    for compl_cond_cobr_acr.
def buffer b_finalid_econ
    for finalid_econ.
def buffer b_finalid_unid_organ
    for finalid_unid_organ.
def buffer b_tit_acr
    for tit_acr.


/*************************** Buffer Definition End **************************/


/************************* Variable Definition Begin ************************/

def var v_cdn_cliente_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "Cliente Final"
    no-undo.
def var v_cdn_cliente_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente"
    column-label "Cliente Inicial"
    no-undo.
def var v_cdn_clien_matriz_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cdn_clien_matriz_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente Matriz"
    column-label "Cliente Matriz"
    no-undo.
def var v_cdn_repres_fim
    as Integer
    format ">>>,>>9":U
    initial 999999
    label "atÇ"
    column-label "Repres Final"
    no-undo.
def var v_cdn_repres_ini
    as Integer
    format ">>>,>>9":U
    initial 0
    label "Representante"
    column-label "Repres Inicial"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new shared var v_cod_carac_lim
    as character
    format "x(1)":U
    initial ";"
    label "Caracter Delimitador"
    no-undo.
def var v_cod_cart_bcia_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_ini
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new shared var v_cod_cond_cobr_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def new shared var v_cod_cond_cobr_ini
    as character
    format "x(8)":U
    label "Condiá∆o Cobranáa"
    column-label "Cond Cobranáa"
    no-undo.
def var v_cod_cta_ctbl_final
    as character
    format "x(20)":U
    initial "ZZZZZZZZZZZZZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_cta_ctbl_ini
    as character
    format "x(20)":U
    label "Conta Inicial"
    column-label "Inicial"
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
def var v_cod_erro
    as character
    format "x(10)":U
    column-label "Cod Erro"
    no-undo.
def var v_cod_espec_docto_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "C¢digo Final"
    no-undo.
def var v_cod_espec_docto_ini
    as character
    format "x(3)":U
    label "EspÇcie"
    column-label "C¢digo Inicial"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
    no-undo.
def var v_cod_finalid_econ_apres
    as character
    format "x(10)":U
    initial "Corrente" /*l_corrente*/
    label "Finalid Apresentaá∆o"
    column-label "Finalid Apresentaá∆o"
    no-undo.
def var v_cod_finalid_econ_aux
    as character
    format "x(10)":U
    label "Finalidade"
    column-label "Finalidade"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def var v_cod_grp_clien_fim
    as character
    format "x(4)":U
    initial "ZZZZ"
    label "atÇ"
    column-label "Grupo Cliente"
    no-undo.
def var v_cod_grp_clien_ini
    as character
    format "x(4)":U
    label "Grupo Cliente"
    column-label "Grupo Cliente"
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
def var v_cod_indic_econ_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def var v_cod_indic_econ_ini
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Inicial"
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
def var v_cod_plano_cta_ctbl_final
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "Final"
    column-label "Final"
    no-undo.
def var v_cod_plano_cta_ctbl_inic
    as character
    format "x(8)":U
    label "Plano Conta"
    column-label "Plano Cta"
    no-undo.
def var v_cod_portador_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Portador Final"
    no-undo.
def var v_cod_portador_ini
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador Inicial"
    no-undo.
def var v_cod_proces_export_fim
    as character
    format "x(12)":U
    initial "ZZZZZZZZZZZZ"
    label "atÇ"
    column-label "Proc Exp Final"
    no-undo.
def var v_cod_proces_export_ini
    as character
    format "x(12)":U
    label "Processo Exportaá∆o"
    column-label "Proc Exp Inicial"
    no-undo.
def var v_cod_ult_obj_procesdo
    as character
    format "x(32)":U
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
def var v_dat_calc_atraso
    as date
    format "99/99/9999":U
    initial today
    label "Calc Dias Atraso"
    column-label "Calc Dias Atraso"
    no-undo.
def var v_dat_cotac_indic_econ
    as date
    format "99/99/9999":U
    initial today
    label "Data Cotaá∆o"
    column-label "Data Cotaá∆o"
    no-undo.
def var v_dat_emis_docto_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_dat_emis_docto_ini
    as date
    format "99/99/9999":U
    label "Data Emiss∆o"
    column-label "Emiss∆o"
    no-undo.
def var v_dat_tit_acr_aber
    as date
    format "99/99/9999":U
    initial today
    label "Posiá∆o Em"
    column-label "Posiá∆o Em"
    no-undo.
def var v_dat_vencto_tit_acr_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "atÇ"
    column-label "Vencto Final"
    no-undo.
def var v_dat_vencto_tit_acr_ini
    as date
    format "99/99/9999":U
    label "Vencimento"
    column-label "Vencto Inicial"
    no-undo.
def new shared var v_des_estab_select
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 no-word-wrap
    size 30 by 1
    bgcolor 15 font 2
    label "Selecionados"
    column-label "Selecionados"
    no-undo.
def var v_ind_classif_tit_acr_em_aber
    as character
    format "X(30)":U
    initial "Por Representante/Cliente" /*l_por_representantecliente*/
    view-as radio-set Vertical
    radio-buttons "Por Representante/Cliente", "Por Representante/Cliente", "Por Portador/Carteira", "Por Portador/Carteira", "Por Cliente/Vencimento", "Por Cliente/Vencimento", "Por Nome do Cliente/Vencimento", "Por Nome Cliente/Vencimento", "Por Grupo Cliente/Cliente", "Por Grupo Cliente/Cliente", "Por Vencimento/Nome Cliente", "Por Vencimento/Nome Cliente", "Por Matriz", "Por Matriz", "Por Condiá∆o Cobranáa/Cliente", "Por Condiá∆o Cobranáa/Cliente", "Por EspÇcie/Vencto/Nome Cliente", "Por EspÇcie/Vencto/Nome Cliente"
     /*l_por_representantecliente*/ /*l_por_representantecliente*/ /*l_por_portadorcarteira*/ /*l_por_portadorcarteira*/ /*l_por_clientevencimento*/ /*l_por_clientevencimento*/ /*l_por_nome_do_clientevencimento*/ /*l_por_nome_clientevencimento*/ /*l_por_grupo_clientecliente*/ /*l_por_grupo_clientecliente*/ /*l_por_vencimentonome_cliente*/ /*l_por_vencimentonome_cliente*/ /*l_por_matriz*/ /*l_por_matriz*/ /*l_por_condcobranca_cliente*/ /*l_por_condcobranca_cliente*/ /*l_por_espec_Vencto_nomcli*/ /*l_por_espec_Vencto_nomcli*/
    bgcolor 8 
    label "Classificaá∆o"
    column-label "Classificaá∆o"
    no-undo.
def var v_ind_coluna
    as character
    format "X(15)":U
    view-as combo-box
    list-items ""
    inner-lines 8
    bgcolor 15 font 2
    label "Detalhar a Coluna"
    no-undo.
def var v_ind_dwb_run_mode
    as character
    format "X(07)":U
    initial "On-Line" /*l_online*/
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line", "Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    label "Run Mode"
    column-label "Run Mode"
    no-undo.
def var v_ind_forma_tot
    as character
    format "X(08)":U
    view-as radio-set Vertical
    radio-buttons "Por Unidade Neg¢cio", "Por Unidade Neg¢cio", "Por Estab/Unidade Neg¢cio", "Por Estab/Unidade Neg¢cio"
     /*l_por_unid_negoc*/ /*l_por_unid_negoc*/ /*l_por_estab_unidade_negocio*/ /*l_por_estab_unidade_negocio*/
    bgcolor 8 
    no-undo.
def var v_ind_tip_calc_juros
    as character
    format "X(10)":U
    initial "Simples" /*l_simples*/
    view-as combo-box
    list-items "Simples","Compostos"
    inner-lines 2
    bgcolor 15 font 2
    label "Tipo C†lculo Juros"
    column-label "Tipo C†lculo Juros"
    no-undo.
def var v_ind_visualiz_tit_acr_vert
    as character
    format "X(20)":U
    initial "Por Estabelecimento" /*l_por_estabelecimento*/
    view-as radio-set Vertical
    radio-buttons "Por Estabelecimento", "Por Estabelecimento", "Por Unidade Neg¢cio", "Por Unidade Neg¢cio"
     /*l_por_estabelecimento*/ /*l_por_estabelecimento*/ /*l_por_unid_negoc*/ /*l_por_unid_negoc*/
    bgcolor 8 
    label "Visualiza T°tulo"
    column-label "Visualiza T°tulo"
    no-undo.
def var v_log_alter_cor_tit_vendor
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
def var v_log_aumento_tela
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_aux_frame
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_classif_estab
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Classif Estab"
    column-label "Classif Estab"
    no-undo.
def new shared var v_log_classif_un
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Classif Unid Negoc"
    no-undo.
def var v_log_consid_abat
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    no-undo.
def var v_log_consid_clien_matriz
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_consid_desc
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    no-undo.
def var v_log_consid_impto_retid
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    label "Imposto Retido"
    no-undo.
def var v_log_consid_juros
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    label "Juros"
    no-undo.
def var v_log_consid_multa
    as logical
    format "Sim/N∆o"
    initial No
    view-as toggle-box
    no-undo.
def var v_log_control_cheq
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_control_terc_acr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_enable
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_juros_multa
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_funcao_melhoria_tit_aber
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_proces_export
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_funcao_tip_calc_juros
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_gerac_planilha
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Planilha"
    no-undo.
def var v_log_habilita_con_corporat
    as logical
    format "Sim/N∆o"
    initial no
    label "Habilita Consulta"
    column-label "Habilita Consulta"
    no-undo.
def var v_log_impto_cop
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_integr_mec
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_localiz_arg
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_modif
    as logical
    format "Sim/N∆o"
    initial yes
    label "Modifica"
    column-label "Modifica"
    no-undo.
def var v_log_modul_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_mostra_acr_cheq_devolv
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheques Devolvidos"
    column-label "Cheques Devolvidos"
    no-undo.
def var v_log_mostra_acr_cheq_recbdo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheques Recebidos"
    column-label "Cheques Receb"
    no-undo.
def var v_log_mostra_docto_acr_antecip
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Antecipaá∆o"
    column-label "Antecipaá∆o"
    no-undo.
def var v_log_mostra_docto_acr_aviso_db
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Aviso DÇbito"
    column-label "Aviso DÇbito"
    no-undo.
def var v_log_mostra_docto_acr_cheq
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheque"
    column-label "Cheque"
    no-undo.
def var v_log_mostra_docto_acr_normal
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Normal"
    column-label "Normal"
    no-undo.
def var v_log_mostra_docto_acr_prev
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Previs∆o"
    column-label "Previs∆o"
    no-undo.
def var v_log_mostra_docto_vendor
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Vendor"
    column-label "Vendor"
    no-undo.
def var v_log_mostra_docto_vendor_repac
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Vendor Repactuado"
    column-label "Vendor Repactuado"
    no-undo.
def var v_log_preco_flut_graos
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_sdo_tit_acr
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Tem Saldo"
    no-undo.
def var v_log_tip_espec_docto_cheq_terc
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheques Terceiros"
    column-label "Cheques Terceiros"
    no-undo.
def var v_log_tip_espec_docto_terc
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Dupl. Terceiros"
    column-label "Dupl. Terceiros"
    no-undo.
def var v_log_tit_acr_avencer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "T°tulos a Vencer"
    column-label "T°tulos a Vencer"
    no-undo.
def var v_log_tit_acr_estordo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Estornados"
    column-label "Estornados"
    no-undo.
def var v_log_tit_acr_indcao_perda_dedut
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Indic Perda Dedut"
    no-undo.
def var v_log_tit_acr_nao_indcao_perda
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "N∆o Indic Perd Dedut"
    no-undo.
def var v_log_tit_acr_vencid
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "T°tulos Vencidos"
    column-label "T°tulos Vencidos"
    no-undo.
def var v_log_transf_estab_operac_financ
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def var v_log_vers_50_6
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
def var v_num_contador
    as integer
    format ">>>>,>>9":U
    initial 0
    no-undo.
def var v_num_cont_2
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_cont_3
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_cont_aux
    as integer
    format ">9":U
    no-undo.
def var v_num_dias_avencer_1
    as integer
    format ">>>9":U
    initial 30
    label "A Vencer atÇ"
    no-undo.
def var v_num_dias_avencer_2
    as integer
    format ">>>9":U
    initial 31
    label "de"
    column-label "de"
    no-undo.
def var v_num_dias_avencer_3
    as integer
    format ">>>9":U
    initial 60
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_num_dias_avencer_4
    as integer
    format ">>>9":U
    initial 61
    label "de"
    no-undo.
def var v_num_dias_avencer_5
    as integer
    format ">>>9":U
    initial 90
    label "atÇ"
    no-undo.
def var v_num_dias_avencer_6
    as integer
    format ">>>9":U
    initial 91
    label "Mais de"
    no-undo.
def var v_num_dias_avencer_7
    as integer
    format ">>>9":U
    initial 120
    label "atÇ"
    no-undo.
def var v_num_dias_avencer_8
    as integer
    format ">>>9":U
    initial 121
    label "Mais de"
    no-undo.
def var v_num_dias_vencid_1
    as integer
    format ">>>9":U
    initial 30
    label "Vencidos atÇ"
    no-undo.
def var v_num_dias_vencid_2
    as integer
    format ">>>9":U
    initial 31
    label "de"
    column-label "de"
    no-undo.
def var v_num_dias_vencid_3
    as integer
    format ">>>9":U
    initial 60
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_num_dias_vencid_4
    as integer
    format ">>>9":U
    initial 61
    label "de"
    no-undo.
def var v_num_dias_vencid_5
    as integer
    format ">>>9":U
    initial 90
    label "atÇ"
    no-undo.
def var v_num_dias_vencid_6
    as integer
    format ">>>9":U
    initial 91
    label "Mais de"
    no-undo.
def var v_num_dias_vencid_7
    as integer
    format ">>>9":U
    initial 120
    label "atÇ"
    no-undo.
def var v_num_dias_vencid_8
    as integer
    format ">>>9":U
    initial 121
    label "Mais de"
    no-undo.
def var v_num_ord_reg
    as integer
    format ">>9":U
    label "Ordem Registro"
    column-label "Ordem Registro"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_qtd_dias_avencer
    as decimal
    format ">>>9":U
    decimals 0
    initial 9999
    label "Em atÇ ...dias"
    column-label "Em AtÇ"
    no-undo.
def var v_qtd_dias_desc_antecip
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    no-undo.
def var v_qtd_dias_vencid
    as decimal
    format ">>>9":U
    decimals 0
    initial 0
    label "A mais de ...dias"
    column-label "A mais de"
    no-undo.
def var v_qtd_dias_vencto_tit_acr
    as decimal
    format "->>9":U
    decimals 0
    label "Dias Vencimento"
    column-label "Dias Vencimento"
    no-undo.
def new global shared var v_rec_clien_financ
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
def var v_rec_table
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_acr
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_cotac_indic_econ
    as decimal
    format "->>,>>>,>>>,>>9.9999999999":U
    decimals 10
    label "Cotaá∆o"
    column-label "Cotaá∆o"
    no-undo.
def var v_val_desc_tit_acr_antecip
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_estab
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_estab_antecip
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_estab_cr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_estab_normal
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_aux
    as decimal
    format ">>>>,>>>,>>9.99":U
    decimals 2
    label "Valor"
    column-label "Valor"
    no-undo.
def var v_val_juros_tit_acr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_origin_tit_acr
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor Original"
    column-label "Valor Original"
    no-undo.
def var v_val_perc_abat_acr_1
    as decimal
    format ">>9.9999":U
    decimals 4
    label "Perc Abatimento"
    column-label "Perc. Abatimento"
    no-undo.
def var v_val_perc_abat_acr_cond_cobr
    as decimal
    format ">>9.9999":U
    decimals 4
    label "Perc. Abatimento"
    column-label "Perc. Abatimento"
    no-undo.
def var v_val_perc_desc_antecip
    as decimal
    format ">>9.9999":U
    decimals 4
    initial 0
    label "% Antecip"
    column-label "% Antecip"
    no-undo.
def var v_val_perc_desc_antecip_cc
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_proces_antecip
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_proces_export
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_proces_export_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_proces_normal
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_sdo_tit_acr
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Valor Saldo"
    column-label "Valor Saldo"
    no-undo.
def var v_val_soma_impto_retid
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Total Geral"
    column-label "Total Geral"
    no-undo.
def var v_val_tot_geral_aber
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total Geral"
    column-label "Total Geral"
    no-undo.
def var v_val_tot_geral_antecip
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total Antecipado"
    column-label "Total Antecipado"
    no-undo.
def var v_val_tot_geral_normal
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def var v_val_unid_negoc
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_unid_negoc_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_unid_negoc_antecip
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_unid_negoc_normal
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_wgh_current_button
    as widget-handle
    format ">>>>>>9":U
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
def var v_num_idx                        as integer         no-undo. /*local*/
def var v_num_multiplic                  as integer         no-undo. /*local*/

ASSIGN v_cdn_repres_ini               = 0
       v_cdn_repres_fim               = 999999
       v_dat_vencto_tit_acr_ini       = 01/01/0001
       v_dat_vencto_tit_acr_fim       = 12/31/9999
       v_cdn_clien_matriz_ini         = 0
       v_cdn_clien_matriz_fim         = 99999999
       v_cod_cond_cobr_ini            = ""
       v_cod_cond_cobr_fim            = "zzzzzzzzz"
       v_cod_indic_econ_ini           = ""
       v_cod_indic_econ_fim           = "zzzzzzzzz"
       v_cdn_cliente_ini              = 0
       v_cdn_cliente_fim              = 99999999.

ASSIGN v_ind_visualiz_tit_acr_vert = "Por estabelecimento".
ASSIGN v_des_estab_select = "101,102,103".
ASSIGN v_val_cotac_indic_econ = 1.

RUN pi_verifica_espec_docto.

RUN pi_verifica_tit_acr_em_aberto(INPUT 41,
                                  INPUT TODAY).

OUTPUT TO c:\temp\desem.txt.
FOR EACH tt_titulos_em_aberto_acr:

    EXPORT DELIMITER ";" tt_titulos_em_aberto_acr.
END.



PROCEDURE pi_verifica_espec_docto:

    del_tt:
    for each tt_espec_docto exclusive-lock:
        delete tt_espec_docto.
    end /* for del_tt */.

    espec_block:
    for each emsbas.espec_docto fields (cod_espec_docto ind_tip_espec_docto) no-lock
        where espec_docto.cod_espec_docto >= v_cod_espec_docto_ini
        and   espec_docto.cod_espec_docto <= v_cod_espec_docto_fim:

        if  not can-find( first espec_docto_financ_acr no-lock
            where espec_docto_financ_acr.cod_espec_docto = espec_docto.cod_espec_docto ) then
            next espec_block.

        if  (espec_docto.ind_tip_espec_docto = "Previs∆o" /*l_previsao*/           and v_log_mostra_docto_acr_prev)
           or (espec_docto.ind_tip_espec_docto = "Antecipaá∆o" /*l_antecipacao*/        and v_log_mostra_docto_acr_antecip)
           or (espec_docto.ind_tip_espec_docto = "Normal" /*l_normal*/             and v_log_mostra_docto_acr_normal)
           or (espec_docto.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/       and v_log_mostra_docto_acr_aviso_db)
           or (espec_docto.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/  and v_log_mostra_docto_acr_cheq)
           or (espec_docto.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/          and v_log_tip_espec_docto_terc and v_log_control_terc_acr)
           or (espec_docto.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/          and v_log_tip_espec_docto_cheq_terc and v_log_control_terc_acr)
           or (espec_docto.ind_tip_espec_docto = "Vendor" /*l_vendor*/             and v_log_mostra_docto_vendor)       
           or (espec_docto.ind_tip_espec_docto = "Vendor Repactuado" /*l_vendor_repac*/       and v_log_mostra_docto_vendor_repac)
        then do:

           create tt_espec_docto.
           assign tt_espec_docto.tta_cod_espec_docto = espec_docto.cod_espec_docto.
        end /* if */.
    end /* for espec_block */.

END PROCEDURE. /* pi_verifica_espec_docto */

/*****************************************************************************
** Procedure Interna.....: pi_verifica_tit_acr_em_aberto
** Descricao.............: pi_verifica_tit_acr_em_aberto
** Criado por............: Uno
** Criado em.............: 02/01/1997 11:57:21
** Alterado por..........: rafaelposse
** Alterado em...........: 08/06/2016 08:28:15
*****************************************************************************/
PROCEDURE pi_verifica_tit_acr_em_aberto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_estil_dwb
        as Integer
        format ">>9"
        no-undo.
    def Input param p_dat_tit_acr_aber
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_movto_tit_acr_ult
        for movto_tit_acr.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_liquidac_tit_acr
        as date
        format "99/99/9999":U
        label "Liquidaá∆o"
        column-label "Liquidaá∆o"
        no-undo.
    def var v_log_vers_50_6
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_seq_ult_movto              as integer         no-undo. /*local*/
    def var v_num_seq_ult_movto_final        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* **  P_CDN_ESTIL_DWB: IDENTIFICA O PROGRAMA CHAMADOR DESTA PROCEDURE
    *
    *           20 - CONSULTA TITULOS EM ABERTO
    *           41 - RELAT‡RIO TITULOS EM ABERTO
    *
    ***/

        assign v_num_seq_ult_movto = 0.
        for each estabelecimento fields(cod_estab) no-lock:
            find last movto_tit_acr no-lock  
                where movto_tit_acr.cod_estab = estabelecimento.cod_estab
                use-index mvtttcr_token no-error.
            

            if  avail movto_tit_acr and movto_tit_acr.num_id_movto_tit_acr > v_num_seq_ult_movto then
                assign v_num_seq_ult_movto = movto_tit_acr.num_id_movto_tit_acr.
        end.
        assign v_num_seq_ult_movto = current-value(seq_movto_tit_acr).

    des_estab_block:
    do v_num_cont_aux = 1 to num-entries(v_des_estab_select):
        estab_block:
        for each estabelecimento fields(cod_estab cod_empresa) no-lock
            where estabelecimento.cod_estab  = entry(v_num_cont_aux, v_des_estab_select):

            if  not can-find(first tit_acr where tit_acr.cod_estab = estabelecimento.cod_estab) then
                next estab_block.


                espec_block:
                for each tt_espec_docto no-lock:

                    if  not can-find(first tit_acr
                        where tit_acr.cod_estab = estabelecimento.cod_estab
                        and   tit_acr.cod_espec_docto = tt_espec_docto.tta_cod_espec_docto) then 
                        next espec_block.
                    dat_block:
                    do v_dat_liquidac_tit_acr = (p_dat_tit_acr_aber + 1) to 12/31/9999:
                        find first tit_acr no-lock
                            where tit_acr.cod_estab             = estabelecimento.cod_estab
                            and   tit_acr.dat_liquidac_tit_acr >= v_dat_liquidac_tit_acr no-error.
                        if  avail tit_acr
                            then assign v_dat_liquidac_tit_acr = tit_acr.dat_liquidac_tit_acr.
                            else leave dat_block.    
                        tit_block:
                        for each tit_acr use-index titacr_liquidac no-lock
                            where tit_acr.cod_estab            = estabelecimento.cod_estab
                            and   tit_acr.dat_liquidac_tit_acr = v_dat_liquidac_tit_acr
                            and   tit_acr.cod_espec_docto      = tt_espec_docto.tta_cod_espec_docto
                            and   tit_acr.dat_transacao       <= p_dat_tit_acr_aber
                            and   tit_acr.cdn_repres          >= v_cdn_repres_ini
                            and   tit_acr.cdn_repres          <= v_cdn_repres_fim
                            and   tit_acr.dat_vencto_tit_acr  >= v_dat_vencto_tit_acr_ini
                            and   tit_acr.dat_vencto_tit_acr  <= v_dat_vencto_tit_acr_fim
                            and   tit_acr.cdn_clien_matriz    >= v_cdn_clien_matriz_ini
                            and   tit_acr.cdn_clien_matriz    <= v_cdn_clien_matriz_fim
                            and   tit_acr.cod_cond_cobr       >= v_cod_cond_cobr_ini
                            and   tit_acr.cod_cond_cobr       <= v_cod_cond_cobr_fim
                            and   tit_acr.cod_indic_econ      >= v_cod_indic_econ_ini
                            and   tit_acr.cod_indic_econ      <= v_cod_indic_econ_fim:

                            if  not v_log_consid_clien_matriz then do:
                                if not(tit_acr.cdn_cliente  >= v_cdn_cliente_ini
                                   and tit_acr.cdn_cliente  <= v_cdn_cliente_fim) then 
                                   next. 
                            end. 
                            else do:           
                                find first tt_clien_consid no-lock 
                                     where tt_clien_consid.tta_cod_empresa = estabelecimento.cod_empresa
                                       and tt_clien_consid.tta_cdn_cliente = tit_acr.cdn_cliente no-error.
                                if  not avail tt_clien_consid then 
                                    next.
                            end. 

                            if tit_acr.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/  then do:
                                find first cheq_acr no-lock
                                    where cheq_acr.cod_estab      = tit_acr.cod_estab
                                      and cheq_acr.num_id_tit_acr = tit_acr.num_id_tit_acr no-error.
                                if avail cheq_acr then do:
                                    find first movto_devol_cheq_acr no-lock
                                        where movto_devol_cheq_acr.num_id_cheq_acr = cheq_acr.num_id_cheq_acr
                                          and movto_devol_cheq_acr.dat_devol_cheq_acr <= p_dat_tit_acr_aber no-error.
                                    if avail movto_devol_cheq_acr then do:
    				    if v_log_mostra_acr_cheq_recbdo = yes and v_log_mostra_acr_cheq_devolv = no then
    					next tit_block.
    				end.		
    				else do:
    				    if v_log_mostra_acr_cheq_recbdo = no and v_log_mostra_acr_cheq_devolv = yes then
    				    next tit_block.
    				end.
                                end.      
                            end.


                            /* Begin_Include: i_verifica_processo_exportacao */
                            /* End_Include: i_verifica_processo_exportacao */

                            run pi_verifica_tit_acr_em_aberto_cria_tt (Input p_cdn_estil_dwb,
                                                                       Input p_dat_tit_acr_aber) /*pi_verifica_tit_acr_em_aberto_cria_tt*/.
                        end.
                    end.
                end.
            end.
        end.

    /* ** TRATAMENTO ESPECIAL PARA QUE OS TITULOS LIQUIDADOS DURANTE A EMISSAO DO RELATORIO
         NAO FIQUEM DE FORA DO RELATORIO, DEVIDO AO "DO:" DATAS DE LIQUIDAÄ«O (Barth) ***/


        assign v_num_seq_ult_movto_final = 0.
        for each estabelecimento fields(cod_estab) no-lock:
            find last movto_tit_acr no-lock  
                where movto_tit_acr.cod_estab = estabelecimento.cod_estab
                use-index mvtttcr_token no-error.
            if  avail movto_tit_acr and movto_tit_acr.num_id_movto_tit_acr > v_num_seq_ult_movto_final then
                assign v_num_seq_ult_movto_final = movto_tit_acr.num_id_movto_tit_acr.
        end.
        assign v_num_seq_ult_movto_final = current-value(seq_movto_tit_acr).

    if  v_num_seq_ult_movto_final > v_num_seq_ult_movto then do:
        estab_block:
        for each estabelecimento fields(cod_estab cod_empresa) no-lock
            where estabelecimento.cod_empresa  = v_cod_empres_usuar
            and   lookup(estabelecimento.cod_estab, v_des_estab_select) > 0,
            each  b_movto_tit_acr_ult no-lock
            where b_movto_tit_acr_ult.cod_estab            = estabelecimento.cod_estab
            and   b_movto_tit_acr_ult.num_id_movto_tit_acr > v_num_seq_ult_movto
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o Data Emiss∆o" /*l_alteracao_data_emissao*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o Data Vencimento" /*l_alteracao_data_vencimento*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Correá∆o de Valor" /*l_correcao_de_valor*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ ,
            tit_acr no-lock
            where tit_acr.cod_estab      = b_movto_tit_acr_ult.cod_estab
            and   tit_acr.num_id_tit_acr = b_movto_tit_acr_ult.num_id_tit_acr,
            first tt_espec_docto
            where tt_espec_docto.tta_cod_espec_docto = tit_acr.cod_espec_docto:

            for each tt_titulos_em_aberto_acr
                where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr:
                delete tt_titulos_em_aberto_acr.
            end.

            run pi_verifica_tit_acr_em_aberto_cria_tt (Input p_cdn_estil_dwb,
                                                       Input p_dat_tit_acr_aber) /*pi_verifica_tit_acr_em_aberto_cria_tt*/.
        end.
    end.

END PROCEDURE.

/*****************************************************************************
** Procedure Interna.....: pi_verifica_tit_acr_em_aberto_cria_tt
** Descricao.............: pi_verifica_tit_acr_em_aberto_cria_tt
** Criado por............: Barth
** Criado em.............: 22/06/1999 08:29:49
** Alterado por..........: 002565
** Alterado em...........: 03/08/2018 10:33:20
*****************************************************************************/
PROCEDURE pi_verifica_tit_acr_em_aberto_cria_tt:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_estil_dwb
        as Integer
        format ">>9"
        no-undo.
    def Input param p_dat_tit_acr_aber
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_titulos_em_aberto_acr
        for tt_titulos_em_aberto_acr.
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    def buffer b_movto_tit_acr_aux
        for movto_tit_acr.
    def buffer b_movto_tit_acr_dest
        for movto_tit_acr.
    def buffer b_movto_tit_acr_pai
        for movto_tit_acr.
    def buffer b_tit_acr_dest
        for tit_acr.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cart_bcia
        as character
        format "x(3)":U
        label "Carteira"
        column-label "Carteira"
        no-undo.
    def var v_cod_portador
        as character
        format "x(5)":U
        label "Portador"
        column-label "Portador"
        no-undo.
    def var v_log_vers_50_6
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_nom_abrev
        as character
        format "x(15)":U
        label "Nome Abreviado"
        column-label "Nome Abrev"
        no-undo.
    def var v_num_atraso_dias_acr
        as integer
        format "->>>>>>9":U
        label "Dias"
        column-label "Dias"
        no-undo.
    def var v_val_origin_transf_estab
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        initial 0
        no-undo.
    def var v_cod_pessoa                     as character       no-undo. /*local*/
    def var v_dat_aux                        as date            no-undo. /*local*/
    def var v_dat_aux_2                      as date            no-undo. /*local*/
    def var v_dat_cotac_aux                  as date            no-undo. /*local*/
    def var v_hra_aux                        as character       no-undo. /*local*/
    def var v_log_operac_financ              as logical         no-undo. /*local*/
    def var v_val_cotac_aux                  as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/


    if  tit_acr.dat_liquidac_tit_acr <= p_dat_tit_acr_aber
    or  tit_acr.dat_transacao        >  p_dat_tit_acr_aber
    or  tit_acr.cdn_repres           <  v_cdn_repres_ini
    or  tit_acr.cdn_repres           >  v_cdn_repres_fim
    or  tit_acr.dat_vencto_tit_acr   <  v_dat_vencto_tit_acr_ini
    or  tit_acr.dat_vencto_tit_acr   >  v_dat_vencto_tit_acr_fim
    or  tit_acr.cdn_clien_matriz     <  v_cdn_clien_matriz_ini
    or  tit_acr.cdn_clien_matriz     >  v_cdn_clien_matriz_fim
    or  tit_acr.cod_cond_cobr        <  v_cod_cond_cobr_ini
    or  tit_acr.cod_cond_cobr        >  v_cod_cond_cobr_fim
    or  tit_acr.cod_indic_econ       <  v_cod_indic_econ_ini
    or  tit_acr.cod_indic_econ       >  v_cod_indic_econ_fim then
        return 'NOK'.

    if  not v_log_consid_clien_matriz then do:
        if  tit_acr.cdn_cliente      <  v_cdn_cliente_ini
            or tit_acr.cdn_cliente   >  v_cdn_cliente_fim then 
            next. 
    end. 

    if v_log_funcao_melhoria_tit_aber then do:
        if  tit_acr.dat_emis_docto       <  v_dat_emis_docto_ini
        or  tit_acr.dat_emis_docto       >  v_dat_emis_docto_fim then
            return 'NOK'.
    end.



    if  (v_log_tit_acr_nao_indcao_perda   = no and tit_acr.dat_indcao_perda_dedut >  p_dat_tit_acr_aber)
    or  (v_log_tit_acr_indcao_perda_dedut = no and tit_acr.dat_indcao_perda_dedut <=   p_dat_tit_acr_aber) then
        return 'NOK'.

    if  tit_acr.log_tit_acr_estordo = yes then do:
        if can-find(first movto_tit_acr use-index mvtttcr_id
            where movto_tit_acr.cod_estab      = tit_acr.cod_estab
            and   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
            and  (movto_tit_acr.ind_trans_acr = "Implantaá∆o" /*l_implantacao*/ 
            or    movto_tit_acr.ind_trans_acr = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ 
            or    movto_tit_acr.ind_trans_acr = "Implantaá∆o a DÇbito" /*l_implantacao_a_debito*/ 
            or    movto_tit_acr.ind_trans_acr = "Renegociaá∆o" /*l_renegociacao*/ 
            or    movto_tit_acr.ind_trans_acr = "Transf Estabelecimento" /*l_transf_estabelecimento*/ )
            and movto_tit_acr.log_ctbz_aprop_ctbl = no
            and v_log_tit_acr_estordo             = no) then return 'NOK'.
    end.

    assign v_val_origin_transf_estab = 0.
    if  can-find(first movto_tit_acr
        where movto_tit_acr.cod_estab     = tit_acr.cod_estab
        and  movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
        and  movto_tit_acr.ind_trans_acr  = "Transf Estabelecimento" /*l_transf_estabelecimento*/ ) then do:
        if  v_log_transf_estab_operac_financ then do:
            find first movto_tit_acr no-lock
                where movto_tit_acr.cod_estab      = tit_acr.cod_estab
                  and movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                  and movto_tit_acr.ind_trans_acr  = "Desconto Banc†rio" /*l_desconto_bancario*/  no-error.
            if not avail movto_tit_acr then
               return 'NOK'.
            else
               assign v_val_origin_transf_estab = movto_tit_acr.val_movto_tit_acr.   
        end.
        else
            return 'NOK'.
    end.    

    assign v_log_operac_financ = no.
    if  not v_log_transf_estab_operac_financ then
        assign v_log_sdo_tit_acr = tit_acr.log_sdo_tit_acr.
    else do:
        assign v_log_sdo_tit_acr = tit_acr.log_sdo_tit_acr.    
        find first b_movto_tit_acr_pai no-lock
            where b_movto_tit_acr_pai.cod_estab        = tit_acr.cod_estab
             and  b_movto_tit_acr_pai.num_id_tit_acr    = tit_acr.num_id_tit_acr
             and  b_movto_tit_acr_pai.ind_trans_acr     = "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/ 
             and  b_movto_tit_acr_pai.log_movto_estordo = no no-error.
        if  avail b_movto_tit_acr_pai then do:
            find first b_movto_tit_acr_dest no-lock
                 where b_movto_tit_acr_dest.cod_estab_tit_acr_pai    = b_movto_tit_acr_pai.cod_estab 
                   and b_movto_tit_acr_dest.num_id_movto_tit_acr_pai = b_movto_tit_acr_pai.num_id_movto_tit_acr
                   and b_movto_tit_acr_dest.ind_trans_acr_abrev      = "TRES" /*l_tres*/  no-error.
            if  avail b_movto_tit_acr_dest then do:
                find first b_movto_tit_acr_aux no-lock
                    where b_movto_tit_acr_aux.cod_estab      = b_movto_tit_acr_dest.cod_estab
                      and b_movto_tit_acr_aux.num_id_tit_acr = b_movto_tit_acr_dest.num_id_tit_acr
                      and b_movto_tit_acr_aux.ind_trans_acr  = "Desconto Banc†rio" /*l_desconto_bancario*/  no-error.
                if avail b_movto_tit_acr_aux then do:
                   if p_dat_tit_acr_aber >= b_movto_tit_acr_aux.dat_transacao then do:
                       assign v_val_origin_transf_estab = tit_acr.val_transf_estab.
                   end.
                   find b_tit_acr_dest no-lock
                      where b_tit_acr_dest.cod_estab      = b_movto_tit_acr_dest.cod_estab
                        and b_tit_acr_dest.num_id_tit_acr = b_movto_tit_acr_dest.num_id_tit_acr no-error.
                   assign v_log_sdo_tit_acr = b_tit_acr_dest.log_sdo_tit_acr.
                   if p_dat_tit_acr_aber > b_movto_tit_acr_aux.dat_transacao then
                      assign v_cod_portador   = b_movto_tit_acr_aux.cod_portador
                             v_cod_cart_bcia  = b_movto_tit_acr_aux.cod_cart_bcia
                             v_log_operac_financ = yes.
                end.   
            end.            
        end.    
    end.

    if  tit_acr.dat_vencto_tit_acr < p_dat_tit_acr_aber then do:
        if  v_log_tit_acr_vencid = no
        or (tit_acr.dat_vencto_tit_acr > p_dat_tit_acr_aber - v_qtd_dias_vencid) then
            return 'NOK'.
    end.
    else if  v_log_tit_acr_avencer = no
         or  (tit_acr.dat_vencto_tit_acr > p_dat_tit_acr_aber + v_qtd_dias_avencer) 
         and v_qtd_dias_avencer <> 9999 then
             return 'NOK'.

    if  v_log_consid_clien_matriz = yes then do:

        /* PCREQ-3851 - Consultas e Relat¢rios de Titulos por Matriz
           A partir da release 12.1.6, verifica se o cliente ser†
           considerado a partir da temp-table tt_clien_consid */

        find first tt_clien_consid
             where tt_clien_consid.tta_cod_empresa = tit_acr.cod_empresa
               and tt_clien_consid.tta_cdn_cliente = tit_acr.cdn_cliente no-error.
        if not avail tt_clien_consid then
            return "NOK" /*l_nok*/ .

        if v_log_gerac_planilha then do:
            if tt_clien_consid.tta_num_pessoa mod 2 = 0 then do:
                find first pessoa_fisic no-lock
                     where pessoa_fisic.num_pessoa_fisic = tt_clien_consid.tta_num_pessoa no-error.
                assign v_cod_pessoa = 'F'.
            end.
            else do:
                find first pessoa_jurid no-lock
                     where pessoa_jurid.num_pessoa_jurid = tt_clien_consid.tta_num_pessoa no-error.
                assign v_cod_pessoa = 'J'.
            end.
        end.
    end.
    else do:
        find first emsuni.cliente no-lock
             where cliente.cod_empresa    = tit_acr.cod_empresa /* v_cod_empres_usuar - leticia*/
               and cliente.cdn_cliente    = tit_acr.cdn_cliente
               and cliente.cod_grp_clien >= v_cod_grp_clien_ini
               and cliente.cod_grp_clien <= v_cod_grp_clien_fim no-error.
        if not avail cliente then
            return 'NOK'.

        if v_log_gerac_planilha then do:
            if cliente.num_pessoa mod 2 = 0 then do:
                find first pessoa_fisic no-lock
                     where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa no-error.
                assign v_cod_pessoa = 'F'.
            end.
            else do:
                find first pessoa_jurid no-lock
                     where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa no-error.
                assign v_cod_pessoa = 'J'.
            end.
        end.
    end.

    /* ** RETORNA A FINALIDADE ORIGINAL DO T÷TULO ***/
    run pi_retornar_finalid_indic_econ (Input tit_acr.cod_indic_econ,
                                        Input tit_acr.dat_transacao,
                                        output v_cod_finalid_econ_aux) /*pi_retornar_finalid_indic_econ*/.

    /* ** SE DATA DA POSIÄ«O FOR RETROCEDENTE, REFAZ O PORTADOR DA EPOCA ***/
    if  p_dat_tit_acr_aber  < today
    and v_log_operac_financ = no then do:
        run pi_retornar_portador_tit_acr_na_epoca (buffer tit_acr,
                                                   Input p_dat_tit_acr_aber,
                                                   output v_cod_portador,
                                                   output v_cod_cart_bcia) /*pi_retornar_portador_tit_acr_na_epoca*/.
    end.
    if  v_cod_portador = "" then
        assign v_cod_portador  = tit_acr.cod_portador
               v_cod_cart_bcia = tit_acr.cod_cart_bcia.

    if  v_cod_portador  < v_cod_portador_ini
    or  v_cod_portador  > v_cod_portador_fim
    or  v_cod_cart_bcia < v_cod_cart_bcia_ini
    or  v_cod_cart_bcia > v_cod_cart_bcia_fim then
        return 'NOK'.

    find emsuni.portador where portador.cod_portador = v_cod_portador no-lock no-error.
    if  avail portador then
        assign v_nom_abrev = portador.nom_abrev.

    if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/  then do:
           /* Quaado o t≠tulo nío possui val_tit_acr, nío cria temp_table. Neste caso, os cˇlculos de juros, abatimentos, etc, atualizam sempre 
           o último registro da temp table criado. Desta forma os valores iam se acumulando para cada t≠tulo (o que ≤ incorreto, visto que ≤ 
           filtrado por UN), e estouravam a mˇscara do campo. Colocado os if not can-find. Fiz os testes e funcionou. */    
            if  not can-find(first val_tit_acr where val_tit_acr.cod_estab = tit_acr.cod_estab
                             and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                             and   val_tit_acr.cod_finalid_econ = v_cod_finalid_econ
                             and   val_tit_acr.cod_unid_negoc  >= v_cod_unid_negoc_ini
                             and   val_tit_acr.cod_unid_negoc  <= v_cod_unid_negoc_fim  )  
            and not can-find(first val_tit_acr where val_tit_acr.cod_estab = tit_acr.cod_estab
                             and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                             and   val_tit_acr.cod_finalid_econ = v_cod_finalid_econ_aux
                             and   val_tit_acr.cod_unid_negoc  >= v_cod_unid_negoc_ini
                             and   val_tit_acr.cod_unid_negoc  <= v_cod_unid_negoc_fim  ) then return.


        /* Begin_Include: i_verifica_tit_acr_em_aberto_un */
        /* VALORES DO T÷TULO NA FINALIDADE INFORMADA */
        val_block:
        for each val_tit_acr fields (cod_estab num_id_tit_acr cod_finalid_econ cod_unid_negoc val_origin_tit_acr val_sdo_tit_acr val_entr_transf_estab  val_saida_transf_unid_negoc) no-lock
            where val_tit_acr.cod_estab        = tit_acr.cod_estab
            and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
            and   val_tit_acr.cod_finalid_econ = v_cod_finalid_econ
            and   val_tit_acr.cod_unid_negoc  >= v_cod_unid_negoc_ini
            and   val_tit_acr.cod_unid_negoc  <= v_cod_unid_negoc_fim
            break by val_tit_acr.cod_unid_negoc:

            assign v_val_origin_tit_acr = v_val_origin_tit_acr + val_tit_acr.val_origin_tit_acr + val_tit_acr.val_entr_transf_estab
                   v_val_sdo_tit_acr    = v_val_sdo_tit_acr + val_tit_acr.val_sdo_tit_acr.

            if  last-of(val_tit_acr.cod_unid_negoc) then do:

                create tt_titulos_em_aberto_acr.
                assign tt_titulos_em_aberto_acr.tta_cod_estab = tit_acr.cod_estab
                       tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                       tt_titulos_em_aberto_acr.tta_cod_espec_docto = tit_acr.cod_espec_docto
                       tt_titulos_em_aberto_acr.tta_cod_ser_docto = tit_acr.cod_ser_docto
                       tt_titulos_em_aberto_acr.tta_cod_tit_acr = tit_acr.cod_tit_acr
                       tt_titulos_em_aberto_acr.tta_cod_parcela = tit_acr.cod_parcela
                       tt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc
                       tt_titulos_em_aberto_acr.tta_cdn_cliente = tit_acr.cdn_cliente
                       tt_titulos_em_aberto_acr.tta_cdn_clien_matriz = tit_acr.cdn_clien_matriz
                       tt_titulos_em_aberto_acr.ttv_nom_abrev_clien = tit_acr.nom_abrev
                       tt_titulos_em_aberto_acr.tta_cod_portador = v_cod_portador
                       tt_titulos_em_aberto_acr.ttv_nom_abrev = v_nom_abrev             
                       tt_titulos_em_aberto_acr.tta_cod_cart_bcia = v_cod_cart_bcia               
                       tt_titulos_em_aberto_acr.tta_cdn_repres = tit_acr.cdn_repres
                       tt_titulos_em_aberto_acr.tta_cod_refer = tit_acr.cod_refer
                       tt_titulos_em_aberto_acr.tta_dat_emis_docto = tit_acr.dat_emis_docto
                       tt_titulos_em_aberto_acr.tta_dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
                       tt_titulos_em_aberto_acr.tta_cod_cond_cobr = tit_acr.cod_cond_cobr 
                       tt_titulos_em_aberto_acr.tta_cod_indic_econ = tit_acr.cod_indic_econ
                       tt_titulos_em_aberto_acr.tta_ind_tip_espec_docto = tit_acr.ind_tip_espec_docto
                       tt_titulos_em_aberto_acr.ttv_val_origin_tit_acr_apres = v_val_origin_tit_acr / v_val_cotac_indic_econ
                       tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = v_val_sdo_tit_acr / v_val_cotac_indic_econ
                       tt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr = v_dat_calc_atraso - tit_acr.dat_vencto_tit_acr
                       tt_titulos_em_aberto_acr.ttv_val_movto_tit_acr_pmr = 0
                       tt_titulos_em_aberto_acr.ttv_val_movto_tit_acr_amr = 0
                       tt_titulos_em_aberto_acr.tta_val_movto_tit_acr = 0
                       tt_titulos_em_aberto_acr.ttv_rec_tit_acr = recid(tit_acr)
                       tt_titulos_em_aberto_acr.ttv_dat_tit_acr_aber = p_dat_tit_acr_aber
                       tt_titulos_em_aberto_acr.tta_cod_tit_acr_bco = tit_acr.cod_tit_acr_bco
                       tt_titulos_em_aberto_acr.ttv_nom_cidad_cobr = if v_cod_pessoa = 'J' then pessoa_jurid.nom_cidad_cobr else "".

                if  v_log_consid_clien_matriz = yes then do:
                    assign tt_titulos_em_aberto_acr.tta_nom_abrev     = tt_clien_consid.tta_nom_pessoa 
                           tt_titulos_em_aberto_acr.tta_cod_grp_clien = tt_clien_consid.tta_cod_grp_clien.
                end. 
                else do: 
                    assign tt_titulos_em_aberto_acr.tta_nom_abrev     = cliente.nom_pessoa
                           tt_titulos_em_aberto_acr.tta_cod_grp_clien = cliente.cod_grp_clien.
                end. 


                if  tit_acr.dat_indcao_perda_dedut = 12/31/9999 then
                    assign tt_titulos_em_aberto_acr.tta_dat_indcao_perda_dedut = ?.
                else 
                    assign tt_titulos_em_aberto_acr.tta_dat_indcao_perda_dedut = tit_acr.dat_indcao_perda_dedut.

                assign v_val_origin_tit_acr = 0
                       v_val_sdo_tit_acr    = 0.

            if  v_log_sdo_tit_acr = yes then
                assign tt_titulos_em_aberto_acr.tta_dat_liquidac_tit_acr = ?.
            else
                assign tt_titulos_em_aberto_acr.tta_dat_liquidac_tit_acr = if (tit_acr.dat_liquidac_tit_acr     <> 12/31/9999
                                                                           and tit_acr.dat_ult_liquidac_tit_acr <> 12/31/9999 
                                                                           and tit_acr.dat_liquidac_tit_acr     <> tit_acr.dat_ult_liquidac_tit_acr
                                                                           and tit_acr.val_sdo_tit_acr           = 0) 
                                                                           then tit_acr.dat_ult_liquidac_tit_acr
                                                                           else tit_acr.dat_liquidac_tit_acr.

                assign tt_titulos_em_aberto_acr.tta_cod_empresa = tit_acr.cod_empresa.


                if v_log_gerac_planilha then do:
                   if not can-find(first tt_titulos_em_aberto_acr_compl no-lock
                        where tt_titulos_em_aberto_acr_compl.tta_cod_estab      = tt_titulos_em_aberto_acr.tta_cod_estab
                        and   tt_titulos_em_aberto_acr_compl.tta_num_id_tit_acr = tt_titulos_em_aberto_acr.tta_num_id_tit_acr
                        and   tt_titulos_em_aberto_acr_compl.tta_cod_unid_negoc = tt_titulos_em_aberto_acr.tta_cod_unid_negoc) then do:
                      create tt_titulos_em_aberto_acr_compl.
                      assign tt_titulos_em_aberto_acr_compl.tta_cod_estab      = tt_titulos_em_aberto_acr.tta_cod_estab
                             tt_titulos_em_aberto_acr_compl.tta_num_id_tit_acr = tt_titulos_em_aberto_acr.tta_num_id_tit_acr
                             tt_titulos_em_aberto_acr_compl.tta_cod_unid_negoc = tt_titulos_em_aberto_acr.tta_cod_unid_negoc
                             tt_titulos_em_aberto_acr_compl.tta_nom_cidade     = if v_cod_pessoa = 'J' then pessoa_jurid.nom_cidade   else pessoa_fisic.nom_cidade
                             tt_titulos_em_aberto_acr_compl.tta_cod_telefone   = if v_cod_pessoa = 'J' then pessoa_jurid.cod_telefone else pessoa_fisic.cod_telefone.
                   end.
                end.
            end.
        end /* for val_block */.

        if  not avail tt_titulos_em_aberto_acr then
            return 'NOK'.

        /* ** VALORES DO T÷TULO NA FINALIDADE ORIGINAL ***/
        val_block:
        for each val_tit_acr fields (cod_estab num_id_tit_acr cod_finalid_econ cod_unid_negoc val_origin_tit_acr val_sdo_tit_acr cod_tip_fluxo_financ val_entr_transf_estab val_perc_rat) no-lock
            where val_tit_acr.cod_estab        = tit_acr.cod_estab
            and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
            and   val_tit_acr.cod_finalid_econ = v_cod_finalid_econ_aux
            and   val_tit_acr.cod_unid_negoc  >= v_cod_unid_negoc_ini
            and   val_tit_acr.cod_unid_negoc  <= v_cod_unid_negoc_fim
            break by val_tit_acr.cod_unid_negoc:

            if  v_log_transf_estab_operac_financ and v_val_origin_transf_estab > 0 then do:
                assign v_val_origin_tit_acr = v_val_origin_tit_acr + (v_val_origin_transf_estab * val_tit_acr.val_perc_rat) / 100
                       v_val_sdo_tit_acr = v_val_sdo_tit_acr + (v_val_origin_transf_estab * val_tit_acr.val_perc_rat) / 100.
            end.
            else do:
                assign v_val_origin_tit_acr = v_val_origin_tit_acr + val_tit_acr.val_origin_tit_acr + val_tit_acr.val_entr_transf_estab
                       v_val_sdo_tit_acr    = v_val_sdo_tit_acr + val_tit_acr.val_sdo_tit_acr.
            end.

            if  last-of(val_tit_acr.cod_unid_negoc)
            then do:
                find first btt_titulos_em_aberto_acr exclusive-lock
                    where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                    and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                    and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
               if avail btt_titulos_em_aberto_acr then
                  assign btt_titulos_em_aberto_acr.tta_val_origin_tit_acr = v_val_origin_tit_acr
                         btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = v_val_sdo_tit_acr.

                assign v_val_sdo_tit_acr    = 0
                       v_val_origin_tit_acr = 0.
            end /* if */.
        end /* for val_block */.

        /* End_Include: i_verifica_tit_acr_em_aberto_un */

    end.
    else do:
        create tt_titulos_em_aberto_acr.
        assign tt_titulos_em_aberto_acr.tta_cod_estab = tit_acr.cod_estab
               tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
               tt_titulos_em_aberto_acr.tta_cod_espec_docto = tit_acr.cod_espec_docto
               tt_titulos_em_aberto_acr.tta_cod_ser_docto = tit_acr.cod_ser_docto
               tt_titulos_em_aberto_acr.tta_cod_tit_acr = tit_acr.cod_tit_acr
               tt_titulos_em_aberto_acr.tta_cod_parcela = tit_acr.cod_parcela
               tt_titulos_em_aberto_acr.tta_cod_unid_negoc = ""
               tt_titulos_em_aberto_acr.tta_cdn_cliente = tit_acr.cdn_cliente
               tt_titulos_em_aberto_acr.tta_cdn_clien_matriz = tit_acr.cdn_clien_matriz
               tt_titulos_em_aberto_acr.ttv_nom_abrev_clien = tit_acr.nom_abrev
               tt_titulos_em_aberto_acr.tta_cod_portador = v_cod_portador
               tt_titulos_em_aberto_acr.ttv_nom_abrev = v_nom_abrev             
               tt_titulos_em_aberto_acr.tta_cod_cart_bcia = v_cod_cart_bcia
               tt_titulos_em_aberto_acr.tta_cdn_repres = tit_acr.cdn_repres
               tt_titulos_em_aberto_acr.tta_cod_refer = tit_acr.cod_refer
               tt_titulos_em_aberto_acr.tta_dat_emis_docto = tit_acr.dat_emis_docto
               tt_titulos_em_aberto_acr.tta_dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_titulos_em_aberto_acr.tta_cod_cond_cobr = tit_acr.cod_cond_cobr 
               tt_titulos_em_aberto_acr.tta_cod_indic_econ = tit_acr.cod_indic_econ
               tt_titulos_em_aberto_acr.tta_ind_tip_espec_docto = tit_acr.ind_tip_espec_docto
               tt_titulos_em_aberto_acr.tta_val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr
               tt_titulos_em_aberto_acr.ttv_val_origin_tit_acr_apres = v_val_origin_tit_acr
               tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres =  v_val_sdo_tit_acr 
               tt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr = v_dat_calc_atraso - tit_acr.dat_vencto_tit_acr
               tt_titulos_em_aberto_acr.ttv_val_movto_tit_acr_pmr = 0
               tt_titulos_em_aberto_acr.ttv_val_movto_tit_acr_amr = 0
               tt_titulos_em_aberto_acr.tta_val_movto_tit_acr = 0
               tt_titulos_em_aberto_acr.ttv_rec_tit_acr = recid(tit_acr)
               tt_titulos_em_aberto_acr.ttv_dat_tit_acr_aber = p_dat_tit_acr_aber
               tt_titulos_em_aberto_acr.tta_cod_tit_acr_bco = tit_acr.cod_tit_acr_bco
               tt_titulos_em_aberto_acr.ttv_nom_cidad_cobr = if v_cod_pessoa = 'J' then pessoa_jurid.nom_cidad_cobr else "".

        if  v_log_consid_clien_matriz = yes then do:
            assign tt_titulos_em_aberto_acr.tta_nom_abrev     = tt_clien_consid.tta_nom_pessoa  
                   tt_titulos_em_aberto_acr.tta_cod_grp_clien = tt_clien_consid.tta_cod_grp_clien.
        end. 
        else do:           
            assign tt_titulos_em_aberto_acr.tta_nom_abrev     = cliente.nom_pessoa         
                   tt_titulos_em_aberto_acr.tta_cod_grp_clien = cliente.cod_grp_clien.
        end.            


            assign tt_titulos_em_aberto_acr.ttv_cod_proces_export = tit_acr.cod_proces_export.
            if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                if num-entries(tit_acr.cod_livre_1,chr(24)) >= 4 then
                    assign tt_titulos_em_aberto_acr.ttv_cod_proces_export = entry(4,tit_acr.cod_livre_1,CHR(24)).
            end.        
        if  v_log_transf_estab_operac_financ and v_val_origin_transf_estab > 0 then do:
            assign tt_titulos_em_aberto_acr.tta_val_origin_tit_acr = v_val_origin_transf_estab.
            if tit_acr.val_transf_estab = 0 then
               assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = v_val_origin_transf_estab.
        end.

        if  tit_acr.dat_indcao_perda_dedut = 12/31/9999 then
            assign tt_titulos_em_aberto_acr.tta_dat_indcao_perda_dedut = ?.
        else
            assign tt_titulos_em_aberto_acr.tta_dat_indcao_perda_dedut = tit_acr.dat_indcao_perda_dedut.

        if  v_log_sdo_tit_acr = yes then
            assign tt_titulos_em_aberto_acr.tta_dat_liquidac_tit_acr = ?.
        else
            assign tt_titulos_em_aberto_acr.tta_dat_liquidac_tit_acr = if (tit_acr.dat_liquidac_tit_acr     <> 12/31/9999
                                                                       and tit_acr.dat_ult_liquidac_tit_acr <> 12/31/9999
                                                                       and tit_acr.dat_liquidac_tit_acr     <> tit_acr.dat_ult_liquidac_tit_acr
                                                                       and tit_acr.val_sdo_tit_acr           = 0) 
                                                                       then tit_acr.dat_ult_liquidac_tit_acr
                                                                       else tit_acr.dat_liquidac_tit_acr.

        assign tt_titulos_em_aberto_acr.tta_cod_empresa = tit_acr.cod_empresa.

        for each val_tit_acr fields (cod_estab num_id_tit_acr cod_finalid_econ val_origin_tit_acr val_sdo_tit_acr val_entr_transf_estab) no-lock
            where val_tit_acr.cod_estab        = tit_acr.cod_estab
            and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
            and   val_tit_acr.cod_finalid_econ = v_cod_finalid_econ:
            assign tt_titulos_em_aberto_acr.ttv_val_origin_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_origin_tit_acr_apres +
                                                                           ((val_tit_acr.val_entr_transf_estab + val_tit_acr.val_origin_tit_acr) / v_val_cotac_indic_econ)
                   tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres    = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres    +
                                                                           (val_tit_acr.val_sdo_tit_acr / v_val_cotac_indic_econ).
        end.


        if v_log_gerac_planilha then do:
           if not can-find(first tt_titulos_em_aberto_acr_compl no-lock
                where tt_titulos_em_aberto_acr_compl.tta_cod_estab      = tt_titulos_em_aberto_acr.tta_cod_estab
                and   tt_titulos_em_aberto_acr_compl.tta_num_id_tit_acr = tt_titulos_em_aberto_acr.tta_num_id_tit_acr
                and   tt_titulos_em_aberto_acr_compl.tta_cod_unid_negoc = tt_titulos_em_aberto_acr.tta_cod_unid_negoc) then do:
              create tt_titulos_em_aberto_acr_compl.
              assign tt_titulos_em_aberto_acr_compl.tta_cod_estab      = tt_titulos_em_aberto_acr.tta_cod_estab
                     tt_titulos_em_aberto_acr_compl.tta_num_id_tit_acr = tt_titulos_em_aberto_acr.tta_num_id_tit_acr
                     tt_titulos_em_aberto_acr_compl.tta_cod_unid_negoc = tt_titulos_em_aberto_acr.tta_cod_unid_negoc
                     tt_titulos_em_aberto_acr_compl.tta_nom_cidade     = if v_cod_pessoa = 'J' then pessoa_jurid.nom_cidade   else pessoa_fisic.nom_cidade
                     tt_titulos_em_aberto_acr_compl.tta_cod_telefone   = if v_cod_pessoa = 'J' then pessoa_jurid.cod_telefone else pessoa_fisic.cod_telefone.
           end.
        end.
    end.

    run pi_verifica_movtos_tit_acr_em_aberto (Input p_dat_tit_acr_aber) /*pi_verifica_movtos_tit_acr_em_aberto*/.


    /* Begin_Include: i_calcula_saldo */
    def var v_val_perc_juros_dia_atraso_tit  as decimal  decimals 6  no-undo.
    def var v_hdl_api                        as handle               no-undo. 
    def var v_log_desc_antecip_ptlidad       as logical  initial no	 no-undo.
    def var v_val_perc_desc_tit_antecip      as decimal  decimals 4  no-undo.

    assign v_val_perc_juros_dia_atraso_tit = tit_acr.val_perc_juros_dia_atraso.

    /* Projeto..: DFIN001 
       Requisito: REQ 1947 - Tratar Desconto por Antecipaá∆o no Contas a Receber
       Descriá∆o: Atualiza vari†veis que ser∆o utilizadas para o c†lculo do desconto por antecipaá∆o */

        assign v_val_perc_desc_antecip_cc = 0 /* % Desconto Antecipaá∆o da Condiá∆o de Cobranáa */
               v_val_perc_desc_antecip    = tit_acr.val_perc_desc_antecip /* % Desconto Antecipaá∆o do T°tulo */
               v_qtd_dias_desc_antecip    = tit_acr.dat_vencto_tit_acr - v_dat_tit_acr_aber
               .

        if v_qtd_dias_desc_antecip < 0 then
            assign v_qtd_dias_desc_antecip = 0.

        if can-find(first param_integr_ems no-lock
                    where param_integr_ems.ind_param_integr_ems = &if defined(BF_FIN_ORIG_GRAOS) &then
                                                                  "Originaá∆o De Gr∆os" /*l_originacao_graos*/ 
                                                                  &else
                                                                  "Gr∆os 2.00" /*l_graos_2.00*/ 
                                                                  &endif
                                                                  ) then
            assign v_log_preco_flut_graos = true.

    if v_log_preco_flut_graos then do:
        run prgfin/acr/acr536za.py persistent set v_hdl_api.
        run pi_busca_juros_desc_liquidac_acr_graos in v_hdl_api (input tit_acr.cod_estab,
                                                                 input tit_acr.cod_espec_docto,
                                                                 input tit_acr.cod_ser_docto,
                                                                 input tit_acr.cod_tit_acr,
                                                                 input tit_acr.cod_parcela,
                                                                 input v_dat_tit_acr_aber,
                                                                 output v_val_perc_desc_tit_antecip,
                                                                 output v_val_perc_juros_dia_atraso_tit,
                                                                 output v_log_desc_antecip_ptlidad).
        delete procedure v_hdl_api.
    end.
    else do:
        assign v_val_perc_juros_dia_atraso_tit = tit_acr.val_perc_juros_dia_atraso    
               v_val_perc_desc_tit_antecip     = 0.
    end.



    /* ******* C†lculo de Juros / Desconto / Abatimento como na Liquidaá∆o / Multa ************ */

    if  v_log_funcao_juros_multa and
        v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr - tit_acr.qtd_dias_carenc_juros_acr > 0 then
        assign v_num_atraso_dias_acr = v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr.

    if  not v_log_funcao_juros_multa then
        assign v_num_atraso_dias_acr = v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr.


    /* Begin_Include: i_calcula_saldo_juros */
    if  v_log_consid_juros
    then do:
        if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
        then do:
            val_block:
            for each val_tit_acr no-lock
                where val_tit_acr.cod_estab            = tit_acr.cod_estab
                and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                break by val_tit_acr.cod_unid_negoc:

                if last-of(val_tit_acr.cod_unid_negoc) then do:
                    find first btt_titulos_em_aberto_acr
                         where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                         and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                         and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                    if avail btt_titulos_em_aberto_acr then do:
                        if  btt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr <> ? then                    
                            assign btt_titulos_em_aberto_acr.tta_val_juros = btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr
                                                                          * v_num_atraso_dias_acr
                                                                          * v_val_perc_juros_dia_atraso_tit
                                                                          / 100.


                        /* **** tipo de c†lculo de juros *******/
                        if  v_log_funcao_tip_calc_juros then do:
                                assign v_ind_tip_calc_juros = tit_acr.ind_tip_calc_juros.
                            run pi_retorna_juros_compostos (Input v_ind_tip_calc_juros,
                                                            Input v_val_perc_juros_dia_atraso_tit,
                                                            Input btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr,
                                                            Input v_num_atraso_dias_acr,
                                                            output v_val_juros_aux) /*pi_retorna_juros_compostos*/.
                            if  v_val_juros_aux <> ? then
                                assign btt_titulos_em_aberto_acr.tta_val_juros = v_val_juros_aux.
                        end.

                        if  v_dat_tit_acr_aber <= tit_acr.dat_vencto_tit_acr then
                            assign btt_titulos_em_aberto_acr.tta_val_juros = 0.
                    end.
                end.
            end.
        end /* if */.
        else do:
            if  tt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr <> ? then
                assign tt_titulos_em_aberto_acr.tta_val_juros = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr
                                                              * v_num_atraso_dias_acr
                                                              * v_val_perc_juros_dia_atraso_tit
                                                              / 100.


            /* **** tipo de c†lculo de juros *******/
            if  v_log_funcao_tip_calc_juros then do:
                    assign v_ind_tip_calc_juros = tit_acr.ind_tip_calc_juros.
                run pi_retorna_juros_compostos (Input v_ind_tip_calc_juros,
                                                Input v_val_perc_juros_dia_atraso_tit,
                                                Input tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr,
                                                Input v_num_atraso_dias_acr,
                                                output v_val_juros_aux) /*pi_retorna_juros_compostos*/.
                if  v_val_juros_aux <> ? then
                    assign tt_titulos_em_aberto_acr.tta_val_juros = v_val_juros_aux.
            end.

            if  v_dat_tit_acr_aber <= tit_acr.dat_vencto_tit_acr then
                assign tt_titulos_em_aberto_acr.tta_val_juros = 0.
        end /* else */.
    end.
    else
        if avail tt_titulos_em_aberto_acr then
           assign tt_titulos_em_aberto_acr.tta_val_juros = 0.
    /* End_Include: i_calcula_saldo_juros */


    if  v_log_consid_multa
    then do:
        if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
        then do:
            val_block:
            for each val_tit_acr no-lock
                where val_tit_acr.cod_estab        = tit_acr.cod_estab
                  and val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                  and val_tit_acr.cod_finalid_econ = v_cod_finalid_econ
                  and val_tit_acr.cod_unid_negoc  >= v_cod_unid_negoc_ini
                  and val_tit_acr.cod_unid_negoc  <= v_cod_unid_negoc_fim
                break by val_tit_acr.cod_unid_negoc:

                if  last-of(val_tit_acr.cod_unid_negoc)
                then do:
                    find first btt_titulos_em_aberto_acr
                         where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                           and btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                           and btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                    if  avail btt_titulos_em_aberto_acr
                    then do:
                        if  v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr - tit_acr.qtd_dias_carenc_multa_acr > 0
                        and tit_acr.val_perc_multa_atraso <> 0 then
                            assign btt_titulos_em_aberto_acr.tta_val_juros = btt_titulos_em_aberto_acr.tta_val_juros + 
                                                                           (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * tit_acr.val_perc_multa_atraso / 100).
                    end.
                end.
            end.
        end.
        else do:
            if  v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr - tit_acr.qtd_dias_carenc_multa_acr > 0 
            and tit_acr.val_perc_multa_atraso <> 0 then
                assign tt_titulos_em_aberto_acr.tta_val_juros = tt_titulos_em_aberto_acr.tta_val_juros + 
                                                               (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * tit_acr.val_perc_multa_atraso / 100).
        end.
    end.

    if  v_log_consid_juros or v_log_consid_multa
    then do:
        if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
        then do:
            for each btt_titulos_em_aberto_acr
               where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                 and btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr:
                assign btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + btt_titulos_em_aberto_acr.tta_val_juros).
            end.
        end.
        else
            assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + tt_titulos_em_aberto_acr.tta_val_juros).
    end.

    if  v_log_consid_abat or v_log_consid_desc
    then do:
        assign v_qtd_dias_vencto_tit_acr = v_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr.

             assign v_val_perc_abat_acr_1 = tit_acr.val_perc_abat_acr.


        /* Begin_Include: i_calcula_saldo_cond_cobr */
        if  tit_acr.cod_cond_cobr <> ""
        then do:
            find first cond_cobr_acr no-lock 
                 where cond_cobr_acr.cod_estab       = tit_acr.cod_estab
                 and   cond_cobr_acr.cod_cond_cobr   = tit_acr.cod_cond_cobr 
                 and   cond_cobr_acr.dat_inic_valid <= tit_acr.dat_emis_docto
                 and   cond_cobr_acr.dat_fim_valid   > tit_acr.dat_emis_docto no-error.

            find first compl_cond_cobr_acr no-lock
                 where compl_cond_cobr_acr.cod_estab              = tit_acr.cod_estab
                 and   compl_cond_cobr_acr.cod_cond_cobr          = tit_acr.cod_cond_cobr
                 and   compl_cond_cobr_acr.num_seq_cond_cobr_acr  = cond_cobr_acr.num_seq_cond_cobr_acr
                 and   compl_cond_cobr_acr.log_cond_cobr_acr_padr = yes no-error.

            if avail compl_cond_cobr then do:
                    assign v_val_perc_abat_acr_cond_cobr = compl_cond_cobr_acr.val_perc_abat_cond_cobr.

                /* Projeto..: DFIN001 
                   Requisito: REQ 1947 - Tratar Desconto por Antecipaá∆o no Contas a Receber
                   Descriá∆o: Atualiza vari†vel v_val_perc_desc_antecip_cc */

                    assign v_val_perc_desc_antecip_cc = compl_cond_cobr_acr.val_perc_desc_antecip /* % Desconto Antecipaá∆o da Condiá∆o de Cobranáa */
                           .

                if  v_log_consid_desc then do:
                if compl_cond_cobr_acr.val_perc_desc_cond_cobr = tit_acr.val_perc_desc
                   or tit_acr.dat_desconto = ? then do:
                   if v_qtd_dias_vencto_tit_acr < 0 then
                      find last b_compl_cond_cobr_acr no-lock
                          where b_compl_cond_cobr_acr.cod_estab                = tit_acr.cod_estab
                          and   b_compl_cond_cobr_acr.cod_cond_cobr            = tit_acr.cod_cond_cobr
                          and   b_compl_cond_cobr_acr.num_seq_cond_cobr_acr    = cond_cobr_acr.num_seq_cond_cobr_acr 
                          and   b_compl_cond_cobr_acr.qtd_dias_vencto_tit_acr <= (v_qtd_dias_vencto_tit_acr * (-1)) no-error.
                   else
                      find last b_compl_cond_cobr_acr no-lock
                          where b_compl_cond_cobr_acr.cod_estab                = tit_acr.cod_estab
                          and   b_compl_cond_cobr_acr.cod_cond_cobr            = tit_acr.cod_cond_cobr
                          and   b_compl_cond_cobr_acr.num_seq_cond_cobr_acr    = cond_cobr_acr.num_seq_cond_cobr_acr 
                          and   b_compl_cond_cobr_acr.qtd_dias_vencto_tit_acr <= (v_qtd_dias_vencto_tit_acr * (-1)) no-error.
                   if  avail b_compl_cond_cobr_acr
                   then do:
                       if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                       then do:
                           val_block:
                           for each val_tit_acr no-lock
                               where val_tit_acr.cod_estab            = tit_acr.cod_estab
                               and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                               and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                               and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                               and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                               break by val_tit_acr.cod_unid_negoc:

                               if last-of(val_tit_acr.cod_unid_negoc) then do:
                                   find first btt_titulos_em_aberto_acr
                                       where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                                       and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                                       and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                                   if avail btt_titulos_em_aberto_acr then
                                       assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                               b_compl_cond_cobr_acr.val_perc_desc_cond_cobr) / 100.
                               end.
                           end.
                       end /* if */.
                       else
                           assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                   b_compl_cond_cobr_acr.val_perc_desc_cond_cobr) / 100.
                   end /* if */.
                   else
                      if avail tt_titulos_em_aberto_acr then 
                         assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = 0.
                end.
                else do:
                   if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                   then do:
                       val_block:
                       for each val_tit_acr no-lock
                           where val_tit_acr.cod_estab            = tit_acr.cod_estab
                           and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                           and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                           and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                           and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                           break by val_tit_acr.cod_unid_negoc:

                           if last-of(val_tit_acr.cod_unid_negoc) then do:
                               find first btt_titulos_em_aberto_acr
                                   where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                                   and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                                   and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                               if avail btt_titulos_em_aberto_acr then
                                   assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                           tit_acr.val_perc_desc) / 100.
                           end.
                       end.
                   end /* if */.
                   else
                       assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                               tit_acr.val_perc_desc) / 100.
                end /* else */.
                end /* if considera desconto */.

                if  v_log_consid_abat then do:
                if  v_val_perc_abat_acr_cond_cobr = v_val_perc_abat_acr_1
                    or tit_acr.dat_abat_tit_acr = ? then do:
                    if v_qtd_dias_vencto_tit_acr < 0 then
                       find last b_compl_cond_cobr_acr no-lock
                           where b_compl_cond_cobr_acr.cod_estab                = tit_acr.cod_estab
                           and   b_compl_cond_cobr_acr.cod_cond_cobr            = tit_acr.cod_cond_cobr
                           and   b_compl_cond_cobr_acr.num_seq_cond_cobr_acr    = cond_cobr_acr.num_seq_cond_cobr_acr 
                           and   b_compl_cond_cobr_acr.qtd_dias_vencto_tit_acr <= (v_qtd_dias_vencto_tit_acr * (-1)) no-error.
                    else
                       find last b_compl_cond_cobr_acr no-lock
                           where b_compl_cond_cobr_acr.cod_estab                = tit_acr.cod_estab
                           and   b_compl_cond_cobr_acr.cod_cond_cobr            = tit_acr.cod_cond_cobr
                           and   b_compl_cond_cobr_acr.num_seq_cond_cobr_acr    = cond_cobr_acr.num_seq_cond_cobr_acr 
                           and   b_compl_cond_cobr_acr.qtd_dias_vencto_tit_acr <= (v_qtd_dias_vencto_tit_acr * (-1)) no-error.
                    if  avail b_compl_cond_cobr_acr
                    then do:
                       if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                       then do:
                           val_block:
                           for each val_tit_acr no-lock
                               where val_tit_acr.cod_estab            = tit_acr.cod_estab
                               and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                               and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                               and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                               and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                               break by val_tit_acr.cod_unid_negoc:

                               if last-of(val_tit_acr.cod_unid_negoc) then do:
                                   find first btt_titulos_em_aberto_acr
                                       where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                                       and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                                       and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                                   if avail btt_titulos_em_aberto_acr then do:
                                           assign btt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                                   b_compl_cond_cobr_acr.val_perc_abat_cond_cobr) / 100.
                                   end.
                               end.
                           end.
                       end /* if */.
                       else do:
                               assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                       b_compl_cond_cobr_acr.val_perc_abat_cond_cobr) / 100.
                       end /* else */. 
                    end /* if */.
                    else
                       if avail tt_titulos_em_aberto_acr then 
                          assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = 0.
                end.
                else do:
                    if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                    then do:
                       val_block:
                       for each val_tit_acr no-lock
                           where val_tit_acr.cod_estab            = tit_acr.cod_estab
                           and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                           and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                           and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                           and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                           break by val_tit_acr.cod_unid_negoc:

                           if last-of(val_tit_acr.cod_unid_negoc) then do:
                               find first btt_titulos_em_aberto_acr
                                   where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                                   and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                                   and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                               if avail btt_titulos_em_aberto_acr then
                                   assign btt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                           v_val_perc_abat_acr_1) / 100.
                           end.
                       end.
                    end /* if */.
                    else
                        assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                v_val_perc_abat_acr_1) / 100.
                end.
                end /* log considera abatimento */.
            end.
            else do:
                if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
                and (v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ?
                or   v_log_consid_desc and string(tit_acr.dat_desconto)     <> ?)
                then do:
                    val_block:
                    for each val_tit_acr no-lock
                       where val_tit_acr.cod_estab            = tit_acr.cod_estab
                       and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                       and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                       and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                       and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                       break by val_tit_acr.cod_unid_negoc:

                       if last-of(val_tit_acr.cod_unid_negoc) then do:
                           find first btt_titulos_em_aberto_acr
                               where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                               and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                               and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                           if avail btt_titulos_em_aberto_acr then do:
                               if  v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ? then 
                                   assign btt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                           v_val_perc_abat_acr_1) / 100.
                               if  v_log_consid_desc and string(tit_acr.dat_desconto) <> ? then
                                   assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                           tit_acr.val_perc_desc ) / 100.
                           end.
                       end.
                    end.
                end.
                else do:           
                    if  v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ? then 
                        assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                v_val_perc_abat_acr_1) / 100.
                    if  v_log_consid_desc and string(tit_acr.dat_desconto) <> ? then
                        assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                             tit_acr.val_perc_desc ) / 100.
                end.
            end.
        end /* if */.
        else do:
            if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
            and (v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ?
            or   v_log_consid_desc and string(tit_acr.dat_desconto)     <> ?)
            then do:
                val_block:
                for each val_tit_acr no-lock
                   where val_tit_acr.cod_estab            = tit_acr.cod_estab
                   and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                   and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                   and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                   and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                   break by val_tit_acr.cod_unid_negoc:

                   if last-of(val_tit_acr.cod_unid_negoc) then do:
                       find first btt_titulos_em_aberto_acr
                           where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                           and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                           and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                       if avail btt_titulos_em_aberto_acr then do:
                           if v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ? then 
                               assign btt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                       v_val_perc_abat_acr_1) / 100.
                           if v_log_consid_desc and string(tit_acr.dat_desconto) <> ? then
                               assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                                       tit_acr.val_perc_desc ) / 100.
                       end.
                   end.
                end.
            end.
            else do:
                if v_log_consid_abat and string(tit_acr.dat_abat_tit_acr) <> ? then 
                    assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                         v_val_perc_abat_acr_1) / 100.
                if v_log_consid_desc and string(tit_acr.dat_desconto) <> ? then
                    assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * 
                                                                         tit_acr.val_perc_desc ) / 100.
            end.
        end.
        /* End_Include: i_calcula_saldo_cond_cobr */


        /* Projeto..: DFIN001 
           Requisito: REQ 1947 - Tratar Desconto por Antecipaá∆o no Contas a Receber
           Descriá∆o: Calcula o % Desconto Antecipaá∆o */

            if v_log_preco_flut_graos = no then
                if v_val_perc_desc_antecip_cc = v_val_perc_desc_antecip then
                    assign v_val_perc_desc_tit_antecip = v_val_perc_desc_antecip_cc * v_qtd_dias_desc_antecip.
                else
                    assign v_val_perc_desc_tit_antecip = v_val_perc_desc_antecip * v_qtd_dias_desc_antecip.
        if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
        then do:

            val_block:
            for each val_tit_acr no-lock
               where val_tit_acr.cod_estab         = tit_acr.cod_estab
                 and val_tit_acr.num_id_tit_acr    = tit_acr.num_id_tit_acr
                 and val_tit_acr.cod_finalid_econ  = v_cod_finalid_econ
                 and val_tit_acr.cod_unid_negoc   >= v_cod_unid_negoc_ini
                 and val_tit_acr.cod_unid_negoc   <= v_cod_unid_negoc_fim
               break by val_tit_acr.cod_unid_negoc:

                if  last-of(val_tit_acr.cod_unid_negoc)
                then do:

                    for first btt_titulos_em_aberto_acr no-lock
                         where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                           and btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                           and btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc:

                        if v_dat_tit_acr_aber > tit_acr.dat_desconto then
                            assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = 0.

                        if v_dat_tit_acr_aber > tit_acr.dat_abat_tit_acr then
                           assign btt_titulos_em_aberto_acr.tta_val_abat_tit_acr = 0.

                        /* Projeto..: DFIN001 
                           Requisito: REQ 1947 - Tratar Desconto por Antecipaá∆o no Contas a Receber
                           Descriá∆o: Habilitar ou desabilitar o campo de % Antecip */

                            if  v_log_preco_flut_graos
                            then do:

                                if  v_log_consid_desc and v_val_perc_desc_tit_antecip <> 0
                                then do:

                                    if v_log_desc_antecip_ptlidad then
                                        assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = btt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                                               (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                                    else    
                                        assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                                end /* if */.
                            end /* if */.
                            else do:

                                if v_log_consid_desc and v_val_perc_desc_tit_antecip <> 0 then
                                    assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = btt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                                           (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.

                            end /* else */.


                            if  v_log_consid_desc and v_log_preco_flut_graos and v_val_perc_desc_tit_antecip <> 0
                            then do:

                                if v_log_desc_antecip_ptlidad then
                                    assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = btt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                                           (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                                else    
                                    assign btt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                            end /* if */.


                        assign btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr -
                                                                              (btt_titulos_em_aberto_acr.tta_val_abat_tit_acr +
                                                                               btt_titulos_em_aberto_acr.tta_val_desc_tit_acr).
                    end /* if */.
                end /* if */.
            end /* for val_block */.
        end /* if */.
        else do:

            if v_dat_tit_acr_aber > tit_acr.dat_desconto then
                assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = 0.

            if v_dat_tit_acr_aber > tit_acr.dat_abat_tit_acr then
                assign tt_titulos_em_aberto_acr.tta_val_abat_tit_acr = 0.

            /* Projeto..: DFIN001 
               Requisito: REQ 1947 - Tratar Desconto por Antecipaá∆o no Contas a Receber
               Descriá∆o: Habilitar ou desabilitar o campo de % Antecip */

                if  v_log_preco_flut_graos
                then do:

                    if  v_log_consid_desc and v_val_perc_desc_tit_antecip <> 0
                    then do:

                        if v_log_desc_antecip_ptlidad then
                            assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = tt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                                  (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                        else    
                            assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                    end /* if */.
                end /* if */.
                else do:

                    assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = tt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                          (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.

                end /* else */.


                if  v_log_consid_desc and v_log_preco_flut_graos and v_val_perc_desc_tit_antecip <> 0
                then do:

                    if v_log_desc_antecip_ptlidad then
                        assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = tt_titulos_em_aberto_acr.tta_val_desc_tit_acr + 
                                                                              (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                    else    
                        assign tt_titulos_em_aberto_acr.tta_val_desc_tit_acr = (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr * v_val_perc_desc_tit_antecip) / 100.
                end /* if */.



            assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr  -
                                                                 (tt_titulos_em_aberto_acr.tta_val_abat_tit_acr +
                                                                  tt_titulos_em_aberto_acr.tta_val_desc_tit_acr).

        end /* else */.
    end /* if */.
    /* End_Include: i_calcula_saldo_cond_cobr */


    /* Begin_Include: i_calcula_saldo_imposto */
    if  v_log_consid_impto_retid
    then do:
       for each impto_vincul_tit_acr no-lock 
          where impto_vincul_tit_acr.cod_estab      = tit_acr.cod_estab
          and   impto_vincul_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:            
          if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
          then do:
              val_block:
              for each val_tit_acr no-lock
                  where val_tit_acr.cod_estab            = tit_acr.cod_estab
                  and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                  and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                  and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                  and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                  break by val_tit_acr.cod_unid_negoc:

                  if last-of(val_tit_acr.cod_unid_negoc) then do:
                      find first btt_titulos_em_aberto_acr
                          where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                          and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                          and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                      if avail btt_titulos_em_aberto_acr then do:
                          IF v_log_impto_cop = no THEN DO:
                              assign btt_titulos_em_aberto_acr.ttv_val_impto_retid = btt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                            (btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr *
                                                                             impto_vincul_tit_acr.val_aliq_impto) / 100.
                          END.
                          ELSE DO:
                             IF impto_vincul_tit_acr.val_base_liq_impto <> 0 and tit_acr.val_sdo_tit_acr = tit_acr.val_origin_tit_acr THEN DO:
                                 assign btt_titulos_em_aberto_acr.ttv_val_impto_retid = btt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                                       (impto_vincul_tit_acr.val_base_liq_impto *
                                                                                        impto_vincul_tit_acr.val_aliq_impto) / 100.
                             END.
                             ELSE DO:
                                 assign btt_titulos_em_aberto_acr.ttv_val_impto_retid = btt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                                       ( btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr *
                                                                                        impto_vincul_tit_acr.val_aliq_impto) / 100.
                             END.                           
                          END.
                          assign btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr  - btt_titulos_em_aberto_acr.ttv_val_impto_retid
                                 v_val_soma_impto_retid                       = v_val_soma_impto_retid                        + btt_titulos_em_aberto_acr.ttv_val_impto_retid 
                                 btt_titulos_em_aberto_acr.ttv_val_impto_retid = 0.
                      end.
                  end.
              end.
          end.
          else do:
              IF v_log_impto_cop = no THEN DO:
                  assign tt_titulos_em_aberto_acr.ttv_val_impto_retid = tt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                        (tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr *
                                                                         impto_vincul_tit_acr.val_aliq_impto) / 100.
              END.
              ELSE DO:              
                 IF impto_vincul_tit_acr.val_base_liq_impto <> 0 and tit_acr.val_sdo_tit_acr = tit_acr.val_origin_tit_acr THEN DO:
                     assign tt_titulos_em_aberto_acr.ttv_val_impto_retid = tt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                           (impto_vincul_tit_acr.val_base_liq_impto *
                                                                            impto_vincul_tit_acr.val_aliq_impto) / 100.
                 END.
                 ELSE DO:
                     assign tt_titulos_em_aberto_acr.ttv_val_impto_retid = tt_titulos_em_aberto_acr.ttv_val_impto_retid +
                                                                           ( tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr *
                                                                            impto_vincul_tit_acr.val_aliq_impto) / 100.
                 END.               
              END.
              assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr  - tt_titulos_em_aberto_acr.ttv_val_impto_retid
                     v_val_soma_impto_retid                       = v_val_soma_impto_retid                        + tt_titulos_em_aberto_acr.ttv_val_impto_retid 
                     tt_titulos_em_aberto_acr.ttv_val_impto_retid = 0.
          end.
       end.   
    end /* if */.
    assign tt_titulos_em_aberto_acr.ttv_val_impto_retid = v_val_soma_impto_retid
           v_val_soma_impto_retid                       = 0.

    /* End_Include: i_calcula_saldo_imposto */


    /* Begin_Include: i_calcula_saldo_2 */
    if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
    then do:
        val_block:
        for each val_tit_acr no-lock
            where val_tit_acr.cod_estab            = tit_acr.cod_estab
            and   val_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
            and   val_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
            and   val_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
            and   val_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
            break by val_tit_acr.cod_unid_negoc:

            if last-of(val_tit_acr.cod_unid_negoc) then do:
                find first btt_titulos_em_aberto_acr
                     where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                     and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                     and   btt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_tit_acr.cod_unid_negoc no-error.
                if avail btt_titulos_em_aberto_acr then do:
                    if  btt_titulos_em_aberto_acr.tta_val_juros <> 0
                    or  btt_titulos_em_aberto_acr.tta_val_abat_tit_acr <> 0
                    or  btt_titulos_em_aberto_acr.tta_val_desc_tit_acr <> 0
                    or  btt_titulos_em_aberto_acr.ttv_val_impto_retid <> 0 then do:
                        if  btt_titulos_em_aberto_acr.tta_cod_indic_econ <> v_cod_indic_econ_apres then
                            run pi_achar_cotac_indic_econ (Input btt_titulos_em_aberto_acr.tta_cod_indic_econ,
                                                           Input v_cod_indic_econ_apres,
                                                           Input v_dat_cotac_indic_econ,
                                                           Input "Real" /*l_real*/,
                                                           output v_dat_cotac_aux,
                                                           output v_val_cotac_aux,
                                                           output v_cod_return) /*pi_achar_cotac_indic_econ*/.
                        else
                            assign v_val_cotac_aux = 1.

                        assign btt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = btt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres
                                  + ((btt_titulos_em_aberto_acr.tta_val_juros
                                    - btt_titulos_em_aberto_acr.tta_val_abat_tit_acr
                                    - btt_titulos_em_aberto_acr.tta_val_desc_tit_acr
                                    - btt_titulos_em_aberto_acr.ttv_val_impto_retid)
                                    / v_val_cotac_aux).
                    end.
                end.
            end.
        end.
    end.
    else do:
        if  tt_titulos_em_aberto_acr.tta_val_juros <> 0
        or  tt_titulos_em_aberto_acr.tta_val_abat_tit_acr <> 0
        or  tt_titulos_em_aberto_acr.tta_val_desc_tit_acr <> 0
        or  tt_titulos_em_aberto_acr.ttv_val_impto_retid <> 0 then do:
            if  tt_titulos_em_aberto_acr.tta_cod_indic_econ <> v_cod_indic_econ_apres then
                run pi_achar_cotac_indic_econ (Input tt_titulos_em_aberto_acr.tta_cod_indic_econ,
                                               Input v_cod_indic_econ_apres,
                                               Input v_dat_cotac_indic_econ,
                                               Input "Real" /*l_real*/,
                                               output v_dat_cotac_aux,
                                               output v_val_cotac_aux,
                                               output v_cod_return) /*pi_achar_cotac_indic_econ*/.
            else
                assign v_val_cotac_aux = 1.

            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres
                      + ((tt_titulos_em_aberto_acr.tta_val_juros
                        - tt_titulos_em_aberto_acr.tta_val_abat_tit_acr
                        - tt_titulos_em_aberto_acr.tta_val_desc_tit_acr
                        - tt_titulos_em_aberto_acr.ttv_val_impto_retid)
                        / v_val_cotac_aux).
        end.
    end.
    /* End_Include: i_calcula_saldo_2 */



    /* ** SE O TITULO N«O TINHA SALDO NA DATA, N«O SERµ IMPRESSO ***/
    /* ** OBS: EM ALGUNS CASOS O TITULO TEM SALDO NEGATIVO, DEVE SER IMPRESSO (Barth) ***/
    if avail tt_titulos_em_aberto_acr and tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = 0.00 and tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = 0.00 then do:
       delete tt_titulos_em_aberto_acr.
       return "NOK" /*l_nok*/ .
    end.

    return "".
END PROCEDURE. /* pi_verifica_tit_acr_em_aberto_cria_tt */

/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut43117
** Alterado em...........: 05/12/2011 10:21:41
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* alteracao sob demanda - atividade 195864*/
    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ then 
        assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.




END PROCEDURE. /* pi_retornar_finalid_indic_econ */

/*****************************************************************************
** Procedure Interna.....: pi_verifica_movtos_tit_acr_em_aberto
** Descricao.............: pi_verifica_movtos_tit_acr_em_aberto
** Criado por............: Uno
** Criado em.............: 02/01/1997 16:49:44
** Alterado por..........: adilsonhaut
** Alterado em...........: 11/07/2016 16:20:11
*****************************************************************************/
PROCEDURE pi_verifica_movtos_tit_acr_em_aberto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_tit_acr_aber
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_titulos_em_aberto_acr
        for tt_titulos_em_aberto_acr.
    def buffer b_movto_tit_acr_avo
        for movto_tit_acr.
    def buffer b_movto_tit_acr_pai
        for movto_tit_acr.
    def buffer b_val_tit_acr
        for val_tit_acr.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_val_unid_negoc
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        no-undo.
    def var v_cod_estab                      as character       no-undo. /*local*/
    def var v_log_liq_perda                  as logical         no-undo. /*local*/
    def var v_num_id_movto_tit_acr           as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ** IMPORTANTE: AS PIs ABAIXO DEVEM SER MANTIDAS EM SINCRONIA (Barth)
    *
    *    pi_verifica_movtos_tit_acr           (RAZAO)
    *    pi_verifica_movtos_tit_acr_em_aberto (TIT ABERTO)
    *    pi_sit_acr_acessar_movto_tit_acr     (SITUACAO ACR)
    */

    /* ** TRATAMENTO PARA MOVIMENTO DE LIQUIDAÄ«O PERDA DEDUTIVEL / ESTORNO DE TITULO ***/
    /* ** DETALHE: ESTES MOVIMENTOS N«O T“M VAL_MOVTO_TIT_ACR.           (Barth) ***/
    find first b_movto_tit_acr_pai no-lock
        where b_movto_tit_acr_pai.cod_estab         = tit_acr.cod_estab
        and   b_movto_tit_acr_pai.num_id_tit_acr    = tit_acr.num_id_tit_acr
        and   b_movto_tit_acr_pai.dat_transacao    <= p_dat_tit_acr_aber
        and   b_movto_tit_acr_pai.log_movto_estordo = no
        and  (b_movto_tit_acr_pai.ind_trans_acr     = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/ 
        or    b_movto_tit_acr_pai.ind_trans_acr     = "Estorno de T°tulo" /*l_estorno_de_titulo*/ ) no-error.
    if  avail b_movto_tit_acr_pai then do:
        assign v_log_liq_perda = yes.
        for each btt_titulos_em_aberto_acr
            where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
            and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr:
            assign btt_titulos_em_aberto_acr.tta_val_sdo_tit_acr       = 0
                   btt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = 0.
        end.
    end.


    /* ** VOLTA O SALDO DO T÷TULO, DE ACORDO COM OS MOVTOS POSTERIORES A DATA DE CORTE ***/
    movto_block:
    for each movto_tit_acr no-lock
        where movto_tit_acr.cod_estab      = tit_acr.cod_estab
        and   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
        and   movto_tit_acr.dat_transacao  > p_dat_tit_acr_aber:

        if  (v_ind_visualiz_tit_acr_vert = "Por Estabelecimento" /*l_por_estabelecimento*/ 
        and movto_tit_acr.ind_trans_acr  = "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/ )
        or  movto_tit_acr.ind_trans_acr  = "Alteraá∆o Data Vencimento" /*l_alteracao_data_vencimento*/ 
        or  movto_tit_acr.ind_trans_acr  = "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/ 
        or  movto_tit_acr.ind_trans_acr  = "Implantaá∆o" /*l_implantacao*/ 
        or  movto_tit_acr.ind_trans_acr  = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ 
        or  movto_tit_acr.ind_trans_acr  = "Transf Estabelecimento" /*l_transf_estabelecimento*/ 
        or  movto_tit_acr.ind_trans_acr  = "Renegociaá∆o" /*l_renegociacao*/ 
        or  movto_tit_acr.ind_trans_acr  = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/ 
        or  movto_tit_acr.ind_trans_acr  = "Estorno de T°tulo" /*l_estorno_de_titulo*/  then
            next movto_block.

        /* ** LIQUIDAÄ«O AP‡S PERDA DEDUT÷VEL N«O CONTA, N«O DEVE VOLTAR SALDO ***/
        if  v_log_liq_perda = yes
        and movto_tit_acr.log_recuper_perda = yes then
            next movto_block.

        /* ** IGNORA ESTORNADOS QUE N«O CONTABILIZAM ***/
        if  v_log_tit_acr_estordo             = no
        and movto_tit_acr.log_ctbz_aprop_ctbl = no
        and (movto_tit_acr.ind_trans_acr      begins "Estorno" /*l_estorno*/ 
        or   movto_tit_acr.log_movto_estordo  = yes) then do:
            /* ** A LIQUIDAÄ«O DA ANTECIPAÄ«O NUNCA CONTABILIZA, VERIFICA A DA DUPLICATA (Barth) ***/
            if  tit_acr.ind_tip_espec_docto        = "Antecipaá∆o" /*l_antecipacao*/ 
            and (movto_tit_acr.ind_trans_acr_abrev = "ELIQ" /*l_eliq*/ 
            or   movto_tit_acr.ind_trans_acr_abrev = "LIQ" /*l_liq*/ ) then do:
                find b_movto_tit_acr_pai
                    where b_movto_tit_acr_pai.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                    and   b_movto_tit_acr_pai.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai
                    no-lock no-error.
                if  movto_tit_acr.ind_trans_acr_abrev = "ELIQ" /*l_eliq*/  then do:
                    /* ** O PAI DO ESTORNO ê A LIQUIDAÄ«O. O PAI DA LIQUIDAÄ«O ê A LIQUIDAÄ«O DA DUPLICATA ***/
                    find b_movto_tit_acr_avo
                        where b_movto_tit_acr_avo.cod_estab            = b_movto_tit_acr_pai.cod_estab_tit_acr_pai
                        and   b_movto_tit_acr_avo.num_id_movto_tit_acr = b_movto_tit_acr_pai.num_id_movto_tit_acr_pai
                        no-lock no-error.
                    if  b_movto_tit_acr_avo.log_ctbz_aprop_ctbl = no then
                        next movto_block.
                end.
                else
                    if  b_movto_tit_acr_pai.log_ctbz_aprop_ctbl = no then
                        next movto_block.
            end.
            else
                next movto_block.
        end.

        if  movto_tit_acr.ind_trans_acr begins "Estorno" /*l_estorno*/  then do:
            assign v_num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai
                   v_cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                   v_num_multiplic        = -1. /* O estorno ser† subtra°do do saldo, por esse motivo o 
                                                   v_num_multiplic ser† multiplicado pela cotaá∆o */
        end.
        else do:
            assign v_num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                   v_cod_estab            = movto_tit_acr.cod_estab
                   v_num_multiplic        = 1.
        end.

        /* ** VOLTA ESTORNO DE PERDAS DEDUT÷VEIS (Barth) ***/
        if  movto_tit_acr.ind_trans_acr = "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/  then do:
            find b_movto_tit_acr_pai
                where b_movto_tit_acr_pai.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                and   b_movto_tit_acr_pai.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai
                no-lock no-error.
            if  avail b_movto_tit_acr_pai
            and b_movto_tit_acr_pai.ind_trans_acr = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/  then do:
                if  b_movto_tit_acr_pai.dat_transacao <= p_dat_tit_acr_aber then do:
                    for each aprop_ctbl_acr no-lock
                        where aprop_ctbl_acr.cod_estab             = b_movto_tit_acr_pai.cod_estab
                        and   aprop_ctbl_acr.num_id_movto_tit_acr  = b_movto_tit_acr_pai.num_id_movto_tit_acr
                        and   aprop_ctbl_acr.cod_unid_negoc       >= v_cod_unid_negoc_ini
                        and   aprop_ctbl_acr.cod_unid_negoc       <= v_cod_unid_negoc_fim
                        and   aprop_ctbl_acr.ind_natur_lancto_ctbl = 'CR',
                        each val_aprop_ctbl_acr no-lock
                        where val_aprop_ctbl_acr.cod_estab             = aprop_ctbl_acr.cod_estab
                        and   val_aprop_ctbl_acr.num_id_aprop_ctbl_acr = aprop_ctbl_acr.num_id_aprop_ctbl_acr
                        and   val_aprop_ctbl_acr.cod_finalid_econ      = v_cod_finalid_econ:
                        find first tt_titulos_em_aberto_acr
                            where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                            and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr no-error.
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr - val_aprop_ctbl_acr.val_aprop_ctbl.
                               tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres - val_aprop_ctbl_acr.val_aprop_ctbl.
                    end.
                end.
                next movto_block.
            end.
            else do:
               if  avail b_movto_tit_acr_pai
               and b_movto_tit_acr_pai.ind_trans_acr = "Liquidaá∆o" /*l_liquidacao*/   
               and b_movto_tit_acr_pai.log_recuper_perda = yes 
               and b_movto_tit_acr_pai.dat_transacao <= p_dat_tit_acr_aber then
                   next movto_block.
            end.
        end.


        if  v_ind_visualiz_tit_acr_vert = "Por Unidade Neg¢cio" /*l_por_unid_negoc*/ 
        then do:

             if  v_cod_finalid_econ <> v_cod_finalid_econ_aux
             or  v_cod_finalid_econ <> v_cod_finalid_econ_apres then do:
                /* CONVERTE E GRAVA O VALOR DO SALDO PARA A FINALIDADE DE APRESENTAÄ«O e BASE */
                val_block:
                for each val_movto_tit_acr no-lock
                    where val_movto_tit_acr.cod_estab            = v_cod_estab
                    and   val_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr
                    and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ
                    and   val_movto_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                    and   val_movto_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                    break by val_movto_tit_acr.cod_unid_negoc:


                    /* Begin_Include: i_recompoe_saldo_titulo_acr */
                    /* code_block: */
                    case movto_tit_acr.ind_trans_acr:
                        when "Acerto Valor a DÇbito" /*l_acerto_valor_a_debito*/         or
                        when "Acerto Valor a Maior" /*l_acerto_valor_a_maior*/         or
                        when "Estorno Acerto Val DÇbito" /*l_estorno_acerto_val_debito*/         or
                        when "Estorno Acerto Val Maior" /*l_estorno_acerto_val_maior*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc - ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                        when "Acerto Valor a CrÇdito" /*l_acerto_valor_a_credito*/         or
                        when "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/         or
                        when "Estorno Acerto Val CrÇdito" /*l_estorno_acerto_val_credito*/         or
                        when "Estorno Acerto Val Menor" /*l_estorno_acerto_val_menor*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                        when "Liquidaá∆o" /*l_liquidacao*/         or
                        when "Devoluá∆o" /*l_devolucao*/         or
                        when "Liquidaá∆o Enctro Ctas" /*l_liquidacao_enctro_ctas*/         or
                        when "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_liquidac_tit_acr 
                                                             + val_movto_tit_acr.val_abat_tit_acr
                                                             + val_movto_tit_acr.val_desconto) / (1 * v_num_multiplic) ).

                        when "Liquidaá∆o Renegociac" /*l_liquidacao_renegociac*/         or
                        when "Estorno Liquidacao Subst" /*l_estorno_liquidacao_subst*/         or
                        when "Estorno Liquid Renegociac" /*l_estorno_liquid_renegociac*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_saida_subst_nf_dupl / (1 * v_num_multiplic) ).

                        when "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/         or
                        when "Estorno Liquid Transf Estab" /*l_estorno_liquid_transf_estab*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_transf_estab / (1 * v_num_multiplic) ).

                        when "Correá∆o de Valor" /*l_correcao_de_valor*/         or
                        when "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/         or
                        when "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/         or
                        when "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc - ( ( val_movto_tit_acr.val_variac_cambial
                                                             + val_movto_tit_acr.val_acerto_cmcac
                                                             + val_movto_tit_acr.val_ganho_perda_cm
                                                             + val_movto_tit_acr.val_ganho_perda_projec ) / (1 * v_num_multiplic) ).

                        when "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/         or
                        when "Estorno Transf Unid Negoc" /*l_estorno_transf_unid_negoc*/ then
                            assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_saida_transf_unid_negoc
                                                             - val_movto_tit_acr.val_entr_transf_unid_negoc ) / (1 * v_num_multiplic) ).
                    end /* case code_block */.
                    /* End_Include: i_recompoe_saldo_titulo_acr */


                    if  last-of(val_movto_tit_acr.cod_unid_negoc)
                    then do:
                        find first tt_titulos_em_aberto_acr
                             where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                             and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr 
                             and   tt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_movto_tit_acr.cod_unid_negoc 
                        no-error.
                        if  avail tt_titulos_em_aberto_acr then do:
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres
                                                                                        + (v_val_unid_negoc / v_val_cotac_indic_econ)
                                   v_val_unid_negoc = 0.
                        end.       
                    end.
                end.
            end.

            /* GRAVA O VALOR ORIGINAL E SALDO DO T÷TULO NA FINALIDADE ORIGINAL */
            val_block:
            for each val_movto_tit_acr no-lock
                where val_movto_tit_acr.cod_estab            = v_cod_estab
                and   val_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr
                and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ_aux
                and   val_movto_tit_acr.cod_unid_negoc      >= v_cod_unid_negoc_ini
                and   val_movto_tit_acr.cod_unid_negoc      <= v_cod_unid_negoc_fim
                break by val_movto_tit_acr.cod_unid_negoc:


                /* Begin_Include: i_recompoe_saldo_titulo_acr */
                /* code_block: */
                case movto_tit_acr.ind_trans_acr:
                    when "Acerto Valor a DÇbito" /*l_acerto_valor_a_debito*/         or
                    when "Acerto Valor a Maior" /*l_acerto_valor_a_maior*/         or
                    when "Estorno Acerto Val DÇbito" /*l_estorno_acerto_val_debito*/         or
                    when "Estorno Acerto Val Maior" /*l_estorno_acerto_val_maior*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc - ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                    when "Acerto Valor a CrÇdito" /*l_acerto_valor_a_credito*/         or
                    when "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/         or
                    when "Estorno Acerto Val CrÇdito" /*l_estorno_acerto_val_credito*/         or
                    when "Estorno Acerto Val Menor" /*l_estorno_acerto_val_menor*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o" /*l_liquidacao*/         or
                    when "Devoluá∆o" /*l_devolucao*/         or
                    when "Liquidaá∆o Enctro Ctas" /*l_liquidacao_enctro_ctas*/         or
                    when "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_liquidac_tit_acr 
                                                         + val_movto_tit_acr.val_abat_tit_acr
                                                         + val_movto_tit_acr.val_desconto) / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o Renegociac" /*l_liquidacao_renegociac*/         or
                    when "Estorno Liquidacao Subst" /*l_estorno_liquidacao_subst*/         or
                    when "Estorno Liquid Renegociac" /*l_estorno_liquid_renegociac*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_saida_subst_nf_dupl / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/         or
                    when "Estorno Liquid Transf Estab" /*l_estorno_liquid_transf_estab*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_transf_estab / (1 * v_num_multiplic) ).

                    when "Correá∆o de Valor" /*l_correcao_de_valor*/         or
                    when "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/         or
                    when "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/         or
                    when "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc - ( ( val_movto_tit_acr.val_variac_cambial
                                                         + val_movto_tit_acr.val_acerto_cmcac
                                                         + val_movto_tit_acr.val_ganho_perda_cm
                                                         + val_movto_tit_acr.val_ganho_perda_projec ) / (1 * v_num_multiplic) ).

                    when "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/         or
                    when "Estorno Transf Unid Negoc" /*l_estorno_transf_unid_negoc*/ then
                        assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_saida_transf_unid_negoc
                                                         - val_movto_tit_acr.val_entr_transf_unid_negoc ) / (1 * v_num_multiplic) ).
                end /* case code_block */.
                /* End_Include: i_recompoe_saldo_titulo_acr */


                if  last-of(val_movto_tit_acr.cod_unid_negoc)
                then do:
                    find first tt_titulos_em_aberto_acr
                         where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                         and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr 
                         and   tt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_movto_tit_acr.cod_unid_negoc 
                    no-error.
                    if  avail tt_titulos_em_aberto_acr then do:     
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr
                                                                        + v_val_unid_negoc.                                                                      
                        if  v_cod_finalid_econ = v_cod_finalid_econ_aux
                        and v_cod_finalid_econ = v_cod_finalid_econ_apres then do:
                             assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr.
                        end.

                        assign v_val_unid_negoc = 0.
                    end.
                end.
            end.
        end.
        else do:
            find first tt_titulos_em_aberto_acr
                 where tt_titulos_em_aberto_acr.tta_cod_estab       = tit_acr.cod_estab
                 and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr  = tit_acr.num_id_tit_acr no-error.

            if  v_cod_finalid_econ <> v_cod_finalid_econ_aux
            or  v_cod_finalid_econ <> v_cod_finalid_econ_apres then do:
                /* CONVERTE E GRAVA O VALOR DO SALDO PARA A FINALIDADE DE APRESENTAÄ«O e BASE*/
                val_block:
                for each val_movto_tit_acr no-lock
                    where val_movto_tit_acr.cod_estab            = v_cod_estab
                    and   val_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr
                    and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ:


                    /* Begin_Include: i_recompoe_saldo_titulo_acr */
                    /* code_block: */
                    case movto_tit_acr.ind_trans_acr:
                        when "Acerto Valor a DÇbito" /*l_acerto_valor_a_debito*/         or
                        when "Acerto Valor a Maior" /*l_acerto_valor_a_maior*/         or
                        when "Estorno Acerto Val DÇbito" /*l_estorno_acerto_val_debito*/         or
                        when "Estorno Acerto Val Maior" /*l_estorno_acerto_val_maior*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres - ( val_movto_tit_acr.val_ajust_val_tit_acr / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Acerto Valor a CrÇdito" /*l_acerto_valor_a_credito*/         or
                        when "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/         or
                        when "Estorno Acerto Val CrÇdito" /*l_estorno_acerto_val_credito*/         or
                        when "Estorno Acerto Val Menor" /*l_estorno_acerto_val_menor*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + ( val_movto_tit_acr.val_ajust_val_tit_acr / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Liquidaá∆o" /*l_liquidacao*/         or
                        when "Devoluá∆o" /*l_devolucao*/         or
                        when "Liquidaá∆o Enctro Ctas" /*l_liquidacao_enctro_ctas*/         or
                        when "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + ( ( val_movto_tit_acr.val_liquidac_tit_acr 
                                                             + val_movto_tit_acr.val_abat_tit_acr
                                                             + val_movto_tit_acr.val_desconto) / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Liquidaá∆o Renegociac" /*l_liquidacao_renegociac*/         or
                        when "Estorno Liquidacao Subst" /*l_estorno_liquidacao_subst*/         or
                        when "Estorno Liquid Renegociac" /*l_estorno_liquid_renegociac*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + ( val_movto_tit_acr.val_saida_subst_nf_dupl / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/         or
                        when "Estorno Liquid Transf Estab" /*l_estorno_liquid_transf_estab*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + ( val_movto_tit_acr.val_transf_estab / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Correá∆o de Valor" /*l_correcao_de_valor*/         or
                        when "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/         or
                        when "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/         or
                        when "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres - ( ( val_movto_tit_acr.val_variac_cambial
                                                             + val_movto_tit_acr.val_acerto_cmcac
                                                             + val_movto_tit_acr.val_ganho_perda_cm
                                                             + val_movto_tit_acr.val_ganho_perda_projec ) / (v_val_cotac_indic_econ * v_num_multiplic) ).

                        when "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/         or
                        when "Estorno Transf Unid Negoc" /*l_estorno_transf_unid_negoc*/ then
                            assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + ( ( val_movto_tit_acr.val_saida_transf_unid_negoc
                                                             - val_movto_tit_acr.val_entr_transf_unid_negoc ) / (v_val_cotac_indic_econ * v_num_multiplic) ).
                    end /* case code_block */.
                    /* End_Include: i_recompoe_saldo_titulo_acr */

                end /* for val_block */.
            end /* if */.

            /* GRAVA O VALOR ORIGINAL E SALDO DO T÷TULO NA FINALIDADE ORIGINAL */
            val_block:
            for each val_movto_tit_acr no-lock
                where val_movto_tit_acr.cod_estab            = v_cod_estab
                and   val_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr
                and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ_aux:


                /* Begin_Include: i_recompoe_saldo_titulo_acr */
                /* code_block: */
                case movto_tit_acr.ind_trans_acr:
                    when "Acerto Valor a DÇbito" /*l_acerto_valor_a_debito*/         or
                    when "Acerto Valor a Maior" /*l_acerto_valor_a_maior*/         or
                    when "Estorno Acerto Val DÇbito" /*l_estorno_acerto_val_debito*/         or
                    when "Estorno Acerto Val Maior" /*l_estorno_acerto_val_maior*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr - ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                    when "Acerto Valor a CrÇdito" /*l_acerto_valor_a_credito*/         or
                    when "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/         or
                    when "Estorno Acerto Val CrÇdito" /*l_estorno_acerto_val_credito*/         or
                    when "Estorno Acerto Val Menor" /*l_estorno_acerto_val_menor*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o" /*l_liquidacao*/         or
                    when "Devoluá∆o" /*l_devolucao*/         or
                    when "Liquidaá∆o Enctro Ctas" /*l_liquidacao_enctro_ctas*/         or
                    when "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + ( ( val_movto_tit_acr.val_liquidac_tit_acr 
                                                         + val_movto_tit_acr.val_abat_tit_acr
                                                         + val_movto_tit_acr.val_desconto) / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o Renegociac" /*l_liquidacao_renegociac*/         or
                    when "Estorno Liquidacao Subst" /*l_estorno_liquidacao_subst*/         or
                    when "Estorno Liquid Renegociac" /*l_estorno_liquid_renegociac*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + ( val_movto_tit_acr.val_saida_subst_nf_dupl / (1 * v_num_multiplic) ).

                    when "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/         or
                    when "Estorno Liquid Transf Estab" /*l_estorno_liquid_transf_estab*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + ( val_movto_tit_acr.val_transf_estab / (1 * v_num_multiplic) ).

                    when "Correá∆o de Valor" /*l_correcao_de_valor*/         or
                    when "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/         or
                    when "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/         or
                    when "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr - ( ( val_movto_tit_acr.val_variac_cambial
                                                         + val_movto_tit_acr.val_acerto_cmcac
                                                         + val_movto_tit_acr.val_ganho_perda_cm
                                                         + val_movto_tit_acr.val_ganho_perda_projec ) / (1 * v_num_multiplic) ).

                    when "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/         or
                    when "Estorno Transf Unid Negoc" /*l_estorno_transf_unid_negoc*/ then
                        assign tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr + ( ( val_movto_tit_acr.val_saida_transf_unid_negoc
                                                         - val_movto_tit_acr.val_entr_transf_unid_negoc ) / (1 * v_num_multiplic) ).
                end /* case code_block */.
                /* End_Include: i_recompoe_saldo_titulo_acr */


                if  v_cod_finalid_econ = v_cod_finalid_econ_aux
                and v_cod_finalid_econ = v_cod_finalid_econ_apres then do:
                    assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.tta_val_sdo_tit_acr.
                end.
            end.
        end.
    end.

END PROCEDURE. /* pi_verifica_movtos_tit_acr_em_aberto */
