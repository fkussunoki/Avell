def temp-table tt_atributos no-undo
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_num_vers_integr              as integer format ">>>>,>>9"
    field ttv_nom_graphic_title            as character format "x(50)"
    field ttv_num_graphic_title_color      as integer format ">>>>,>>9" initial ?
    field ttv_num_graphic_type             as integer format ">>>>,>>9" initial ?
    field ttv_num_graphic_style            as integer format ">>>>,>>9" initial ?
    field ttv_num_labels_color             as integer format ">>>>,>>9" initial ?
    field ttv_nom_left_title               as character format "x(30)" initial ?
    field ttv_num_left_title_style         as integer format ">>>>,>>9" initial ?
    field ttv_num_left_title_color         as integer format ">>>>,>>9" initial ?
    field ttv_nom_bottom_title             as character format "x(30)" initial ?
    field ttv_num_bottom_title_color       as integer format ">>>>,>>9" initial ?
    field ttv_num_dat_labels               as integer format ">>>>,>>9" initial ?
    field ttv_cod_dat_labels_format        as character format "x(8)" initial ?
    field ttv_num_dat_labels_color         as integer format ">>>>,>>9" initial ?
    field ttv_num_limit_lines              as integer format ">>>>,>>9" initial ?
    field ttv_num_limit_lines_color        as integer format ">>>>,>>9" initial ?
    field ttv_cod_limit_high_label         as character format "x(8)" initial ?
    field ttv_cod_limit_low_label          as character format "x(8)" initial ?
    field ttv_val_limit_high_value         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial ?
    field ttv_val_limit_low_value          as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial ?
    field ttv_num_line_stats               as integer format ">>>>,>>9" initial ?
    field ttv_num_mean_line_color          as integer format ">>>>,>>9" initial ?
    field ttv_num_min_max_lines_color      as integer format ">>>>,>>9" initial ?
    field ttv_num_st_dev_lines_color       as integer format ">>>>,>>9" initial ?
    field ttv_num_best_fit_lines_color     as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_type               as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_order              as integer format ">>>>,>>9" initial ?
    field ttv_num_curve_color              as integer format ">>>>,>>9" initial ?
    field ttv_num_thick_lines              as integer format ">>>>,>>9" initial ?
    field ttv_num_grid_style               as integer format ">>>>,>>9" initial ?
    field ttv_num_grid_line_style          as integer format ">>>>,>>9" initial ?
    field ttv_cod_title_font_name          as character format "x(8)" initial ?
    field ttv_num_title_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_title_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_other_font_name          as character format "x(8)" initial ?
    field ttv_num_other_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_other_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_label_font_name          as character format "x(8)" initial ?
    field ttv_num_label_font_size          as integer format ">>>>,>>9" initial ?
    field ttv_num_label_font_style         as integer format ">>>>,>>9" initial ?
    field ttv_cod_legend_font_name         as character format "x(8)" initial ?
    field ttv_num_legend_font_size         as integer format ">>>>,>>9" initial ?
    field ttv_num_legend_font_style        as integer format ">>>>,>>9" initial ?
    field ttv_num_legend_pos               as integer format ">>>>,>>9" initial ?
    field tta_cb3_ident_visual             as Character format "x(20)" initial ? label "N£mero Plaqueta" column-label "N£mero Plaqueta"
    index tt_idx_graph                     is primary unique
          ttv_num_graphic                  ascending
    .

def temp-table tt_cliente_matriz no-undo like emsuni.Cliente
    field ttv_rec_cliente                  as recid format ">>>>>>9"
    index tt_recid_cliente_matriz          is primary unique
          ttv_rec_cliente                  ascending
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

def temp-table tt_dados_aux no-undo
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_num_pointer                  as integer format ">>>>,>>9"
    field ttv_num_set                      as integer format ">>>>,>>9"
    field ttv_val_dado                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    index tt_dados_aux_id                  is unique
          ttv_num_graphic                  ascending
          ttv_num_pointer                  ascending
          ttv_num_set                      ascending
    .

def temp-table tt_datas_faixa no-undo
    field ttv_dat_table                    as date format "99/99/9999"
    index tt_data                          is primary
          ttv_dat_table                    ascending
    .

def temp-table tt_empresa no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_id                           
          tta_cod_empresa                  ascending
    .

def temp-table tt_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_cod_desc_erro                as character format "x(8)"
    .

def temp-table tt_espec_docto_faixa no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    index tt_codigo                        is primary
          tta_cod_espec_docto              ascending
    .

def temp-table tt_estab no-undo
    field ttv_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_empres                   as character format "x(10)" label "C¢digo Empresa" column-label "C¢digo Empresa"
    index tt_codigo                       
          ttv_cod_estab                    ascending
    .

def temp-table tt_estabelec no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    .

def temp-table tt_estabelecimento_empresa no-undo like estabelecimento
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_nom_razao_social             as character format "x(40)" label "Raz∆o Social" column-label "Raz∆o Social"
    field ttv_log_selec                    as logical format "Sim/N∆o" initial no column-label "Gera"
    index tt_cod_estab                     is primary unique
          tta_cod_estab                    ascending
    .

def temp-table tt_graph_data no-undo
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_num_point                    as integer format ">>>>,>>9"
    field ttv_num_set                      as integer format ">>>>,>>9"
    field ttv_val_graphic_dat              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_point                    ascending
          ttv_num_set                      ascending
    .

def temp-table tt_info_pessoa_fisic no-undo
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F°sica" column-label "Pessoa F°sica"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_cod_unid_federac             as character format "x(3)" label "Estado" column-label "UF"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_num_pessoa_fisic_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz Pessoa F°sica" column-label "Mtz Pes Fisc"
    index tt_idx                           is primary unique
          tta_num_pessoa_fisic             ascending
    index tt_idx_matriz                   
          tta_num_pessoa_fisic_matriz      ascending
    .

def temp-table tt_info_pessoa_jurid no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_cod_unid_federac             as character format "x(3)" label "Estado" column-label "UF"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    index tt_idx                           is primary unique
          tta_num_pessoa_jurid             ascending
    index tt_idx_matriz                   
          tta_num_pessoa_jurid_matriz      ascending
    .

def new shared temp-table tt_matriz_clien_liquidac_acr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_movto_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field tta_ind_espec_docto              as character format "X(08)" label "EspÇcie Documento" column-label "EspÇcie Documento"
    field tta_ind_trans_acr_abrev          as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    index tt_                              is primary unique
          ttv_rec_movto_tit_acr            ascending
    index tt_total                        
          tta_cod_tit_acr                  ascending
          tta_dat_transacao                ascending
          tta_ind_trans_acr_abrev          ascending
    .

def temp-table tt_param_clien_consid no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_des_estab_select             as character format "x(2000)" label "Selecionados" column-label "Selecionados"
    field ttv_cdn_cliente_ini              as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente Inicial"
    field ttv_cdn_cliente_fim              as Integer format ">>>,>>>,>>9" initial 0 label "atÇ" column-label "Cliente Final"
    field ttv_cod_grp_clien_ini            as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field ttv_cod_grp_clien_fim            as character format "x(4)" label "atÇ" column-label "Grupo Cliente"
    field ttv_log_consid_clien_matriz      as logical format "Sim/N∆o" initial no
    field ttv_cdn_matriz_clien_inic        as Integer format ">>>,>>9"
    field ttv_cdn_matriz_clien_fim         as Integer format ">>>,>>9"
    field ttv_log_mostra_erro              as logical format "Sim/N∆o" initial no
    index tt_idx                           is primary unique
          ttv_num_seq                      ascending
    .

def temp-table tt_pessoa_matriz_consid no-undo
    field ttv_num_pessoa_matriz            as integer format ">>>,>>>,>>9"
    index tt_idx                           is primary unique
          ttv_num_pessoa_matriz            ascending
    .

def temp-table tt_points no-undo
    field ttv_num_point                    as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_label_text               as character format "x(30)" initial ?
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_point                    ascending
    .

def temp-table tt_points_aux no-undo
    field ttv_num_point                    as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_label_text               as character format "x(30)" initial ?
    index tt_points_aux_id                 is primary unique
          ttv_num_point                    ascending
          ttv_num_graphic                  ascending
    .

def temp-table tt_sets no-undo
    field ttv_num_set                      as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_legend_text              as character format "x(30)" initial ?
    field ttv_num_color_set                as integer format ">>>>,>>9" initial ?
    index tt_idx_point                     is primary unique
          ttv_num_graphic                  ascending
          ttv_num_set                      ascending
    .

def temp-table tt_tit_acr_grafico_liquidac no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_num_mes                      as integer format "99" initial 01
    field tta_val_movto_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    .

def temp-table tt_tit_acr_liquidac no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_ind_trans_acr_abrev          as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field tta_log_movto_estordo            as logical format "Sim/N∆o" initial no label "Estornado" column-label "Estornado"
    field tta_log_liquidac_contra_antecip  as logical format "Sim/N∆o" initial no label "Liquidac AN" column-label "Liquidac AN"
    field tta_val_movto_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_cr_movto_tit_acr         as date format "99/99/9999" initial ? label "CrÇdito" column-label "CrÇdito"
    field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_ind_espec_docto              as character format "X(08)" label "EspÇcie Documento" column-label "EspÇcie Documento"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field ttv_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    index tt_cdn_cliente                  
          tta_cdn_cliente                  ascending
    index tt_cod_tit_acr                  
          tta_cod_tit_acr                  ascending
    index tt_dat_transacao                
          tta_dat_transacao                descending
    index tt_estab                         is primary
          tta_cod_estab                    ascending
    index tt_processo                     
          ttv_cod_proces_export            ascending
    .

def temp-table tt_tot_movtos_acr no-undo
    field ttv_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field ttv_val_tot_movto                as decimal format "->>,>>>,>>9.99" decimals 2 label "Valor Total" column-label "Valor Total"
    field ttv_num_ord_reg                  as integer format ">>9" label "Ordem Registro" column-label "Ordem Registro"
    field ttv_dat_initial                  as date format "99/99/9999" label "Data Inicial" column-label "Data Inicial"
    field ttv_dat_final                    as date format "99/99/9999" label "Data Final" column-label "Data Final"
    field ttv_ind_vencid_avencer           as character format "X(08)" initial "Vencidos" label "Vencid/a Vencer" column-label "Vencid/a Vencer"
    field ttv_num_dias_avencer_2           as integer format ">>>9" initial 31 label "de" column-label "de"
    field ttv_num_dias_avencer_3           as integer format ">>>9" initial 60 label "atÇ" column-label "atÇ"
    field ttv_log_graf                     as logical format "Sim/N∆o" initial no label "Gr†fico" column-label "Gr†fico"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    field tta_cod_proces_export            as character format "x(12)" label "Processo Exportaá∆o" column-label "Processo Exportaá∆o"
    field ttv_val_tot_geral_antecip        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Total Antecipado" column-label "Total Antecipado"
    field ttv_val_tot_geral_normal         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Total de T°tulos" column-label "Total de T°tulos"
    .

def temp-table tt_transacao_abreviada no-undo
    field tta_ind_trans_acr_abrev          as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    index tt_codigo                        is primary
          tta_ind_trans_acr_abrev          ascending
    .

def temp-table tt_usuar_grp_usuar no-undo like usuar_grp_usuar
    .

def temp-table tt_ylabels no-undo
    field ttv_num_y_label                  as integer format ">>>>,>>9"
    field ttv_num_graphic                  as integer format ">>>>,>>9"
    field ttv_nom_y_label_text             as character format "x(30)"
    index tt_idx_ylabel                    is primary unique
          ttv_num_y_label                  ascending
          ttv_num_graphic                  ascending
    .


def buffer btt_tit_acr_liquidac
    for tt_tit_acr_liquidac.
def buffer btt_tot_movtos_acr
    for tt_tot_movtos_acr.
def buffer b_finalid_econ
    for finalid_econ.
def buffer b_finalid_unid_organ
    for finalid_unid_organ.
def buffer b_segur_unid_organ
    for emsuni.segur_unid_organ.
def buffer b_unid_organ
    for emsuni.unid_organ.


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
def var v_cod_espec_docto_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "C¢digo Final"
    no-undo.
def var v_cod_espec_docto_final
    as character
    format "x(03)":U
    initial "ZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_espec_docto_ini
    as character
    format "x(3)":U
    label "EspÇcie"
    column-label "C¢digo Inicial"
    no-undo.
def var v_cod_espec_docto_inicial
    as character
    format "x(03)":U
    label "EspÇcie"
    column-label "EspÇcie Docto"
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
def var v_cod_finalid_econ_tit
    as character
    format "x(10)":U
    label "Finalidade"
    column-label "Finalidade"
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
def var v_cod_indic_econ_fim
    as character
    format "x(8)":U
    initial "ZZZZZZZZ"
    label "atÇ"
    column-label "Final"
    no-undo.
def var v_cod_indic_econ_idx
    as character
    format "x(8)":U
    label "Moeda ÷ndice"
    column-label "Moeda ÷ndice"
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
def var v_cod_tip_graf
    as character
    format "x(8)":U
    no-undo.
def var v_cod_tip_perspective
    as character
    format "x(8)":U
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
def var v_dat_conver
    as date
    format "99/99/9999":U
    initial today
    label "Data Convers∆o"
    column-label "Data Convers∆o"
    no-undo.
def var v_dat_cotac_indic_econ
    as date
    format "99/99/9999":U
    initial today
    label "Data Cotaá∆o"
    column-label "Data Cotaá∆o"
    no-undo.
def var v_dat_fim_graf
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_fim_period_aux
    as date
    format "99/99/9999":U
    label "Data Final"
    column-label "Data Final"
    no-undo.
def var v_dat_inic_graf
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_inic_period_aux
    as date
    format "99/99/9999":U
    label "Data Inicial"
    column-label "Data Inicial"
    no-undo.
def var v_dat_liquidac_fim
    as date
    format "99/99/9999":U
    label "atÇ"
    no-undo.
def var v_dat_liquidac_final
    as date
    format "99/99/9999":U
    label "atÇ"
    no-undo.
def var v_dat_liquidac_inic
    as date
    format "99/99/9999":U
    label "Data de Liquidaá∆o"
    column-label "Liquidaá∆o"
    no-undo.
def var v_dat_liquidac_inicial
    as date
    format "99/99/9999":U
    label "Data de Liquidaá∆o"
    column-label "Liquidaá∆o"
    no-undo.
def var v_dat_transacao_fim
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Final"
    no-undo.
def var v_dat_transacao_ini
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Transaá∆o"
    column-label "Data Transaá∆o"
    no-undo.
def var v_dat_vencto_docto_fim
    as date
    format "99/99/9999":U
    initial today
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_dat_vencto_docto_inic
    as date
    format "99/99/9999":U
    label "Vencimento"
    column-label "Vencimento"
    no-undo.
def new shared var v_des_estab_select
    as character
    format "x(2000)":U
    view-as editor max-chars 2000
    size 30 by 1
    bgcolor 15 font 2
    label "Selecionados"
    column-label "Selecionados"
    no-undo.
def new shared var v_des_estab_select_aux
    as character
    format "x(2000)":U
    view-as editor max-chars 2000
    size 30 by 1
    bgcolor 15 font 2
    no-undo.
def var v_des_finalid_econ_abrev
    as character
    format "x(25)":U
    label "Finalidade"
    column-label "Finalidade"
    no-undo.
def var v_des_labels
    as character
    format "x(40)":U
    no-undo.
def var v_des_values
    as character
    format "x(40)":U
    no-undo.
def var v_ind_trans_acr_abrev
    as character
    format "X(04)":U
    label "Transaá∆o"
    column-label "Transaá∆o"
    no-undo.
def var v_log_consid_clien_matriz
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_control_terc_acr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_erro
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_funcao_proces_export
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_habilita_con_corporat
    as logical
    format "Sim/N∆o"
    initial no
    label "Habilita Consulta"
    column-label "Habilita Consulta"
    no-undo.
def var v_log_integr_mec
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_modul_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_mostra_acerto_val_cr
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Acerto Valor a CR"
    no-undo.
def var v_log_mostra_acerto_val_menor
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Acerto Valor a Menor"
    no-undo.
def var v_log_mostra_antecip
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Antecipaá∆o"
    column-label "Antecipaá∆o"
    no-undo.
def var v_log_mostra_aviso_db
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Aviso DÇbito"
    column-label "Aviso DÇbito"
    no-undo.
def var v_log_mostra_aviso_db_1
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Aviso DÇbito"
    column-label "Aviso DÇbito"
    no-undo.
def var v_log_mostra_cheq
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Cheque"
    column-label "Cheque"
    no-undo.
def var v_log_mostra_devol
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Devoluá∆o"
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
def var v_log_mostra_liquidac
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Liquidaá∆o"
    no-undo.
def var v_log_mostra_liquidac_antecip
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquidaá∆o contra AN"
    no-undo.
def var v_log_mostra_liquidac_estorn
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquid. Estornadas"
    no-undo.
def var v_log_mostra_liquidac_normal
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquidaá∆o Normal"
    no-undo.
def var v_log_mostra_liquidac_pagto
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquidaá∆o c/ Pagto"
    no-undo.
def var v_log_mostra_liquidac_renegoc
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquid Renegociaá∆o"
    no-undo.
def var v_log_mostra_liquidac_subst
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquid Substituiá∆o"
    no-undo.
def var v_log_mostra_liq_enctro_cta
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Liq Encontro Ctas"
    column-label "Liq Encontro Ctas"
    no-undo.
def var v_log_mostra_ndebito
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Nota de DÇbito"
    no-undo.
def var v_log_mostra_nf
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_mostra_normal
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Normal"
    no-undo.
def var v_log_mostra_nota_cr
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Nota CrÇdito"
    column-label "Nota CrÇdito"
    no-undo.
def var v_log_mostra_perda_dedut
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Liquid Perda Dedut"
    column-label "Liquid Perda Dedut"
    no-undo.
def var v_log_mostra_prev
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Previs∆o"
    no-undo.
def var v_log_mostra_transf_estab
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Transf Estabelec"
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
def var v_log_tot_geral
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_vers_50_6
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_color
    as character
    format "x(30)":U
    no-undo.
def var v_nom_graphic_title
    as character
    format "x(50)":U
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
def var v_nom_razao_social
    as character
    format "x(30)":U
    label "Raz∆o Social"
    column-label "Raz∆o Social"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
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
def var v_num_cont_aux
    as integer
    format ">9":U
    no-undo.
def var v_num_dataset
    as integer
    format ">>>>,>>9":U
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
def new global shared var v_rec_movto_tit_acr
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
def var v_val_cotac
    as decimal
    format "->>9.9999":U
    decimals 4
    label "Cotaá∆o"
    no-undo.
def var v_val_cotac_indic_econ
    as decimal
    format "->>,>>>,>>>,>>9.9999999999":U
    decimals 10
    label "Cotaá∆o"
    column-label "Cotaá∆o"
    no-undo.
def var v_val_pagto_apb
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Valor Pagamento"
    column-label "Valor Pagamento"
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
def var v_log_tot_proces                 as logical         no-undo. /*local*/
DEF NEW GLOBAL SHARED VAR h-acomp AS HANDLE NO-UNDO.


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


/* Funá∆o para Controle Terceiros */

/* Begin_Include: i_verifica_controle_terceiros_acr */
assign v_log_control_terc_acr = no.
find emsuni.histor_exec_especial no-lock
     where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
     and   histor_exec_especial.cod_prog_dtsul  = 'SPP_CONTROLE_TERCEIROS_ACR':u
     no-error.
if avail histor_exec_especial then
   assign v_log_control_terc_acr = yes.

/* End_Include: i_funcao_extract */

if v_log_control_terc_acr = no then
    assign v_log_tip_espec_docto_terc      = no
           v_log_tip_espec_docto_cheq_terc = no.

assign v_log_habilita_con_corporat = no.
   find  histor_exec_especial no-lock
        where histor_exec_especial.cod_modul_dtsul = 'UFN'
        and   histor_exec_especial.cod_prog_dtsul = 'Spp_registro_corporativo_acr' no-error.
    if  avail histor_exec_especial then
        assign v_log_habilita_con_corporat = yes.


/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emsuni.histor_exec_especial NO-LOCK
         WHERE histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.



    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */

PROCEDURE pi-liquida:

    def OUTPUT param table for tt_tit_acr_liquidac.

/* Begin_Include: i_vrf_funcao_integr_mec_ems5 */
IF  can-find(first param_integr_ems no-lock
    where param_integr_ems.ind_param_integr_ems = "CÉmbio 2.00 X FIN EMS 5" /*l_cambio_2.00_x_fin_ems_5*/ ) THEN
    assign v_log_integr_mec = YES.
ELSE
    assign v_log_integr_mec = NO.

ASSIGN v_dat_liquidac_inicial      = 01/01/2000
       v_dat_liquidac_final        = TODAY
       v_dat_transacao_ini         = 01/01/2000
       v_dat_transacao_fim         = TODAY 
       v_dat_liquidac_inic         = 01/01/2000 
       v_dat_liquidac_fim          = TODAY 
       v_dat_inic_period_aux       = 01/01/2000 
       v_dat_fim_period_aux        = TODAY 
       v_dat_cotac_indic_econ      = today
       v_cod_finalid_econ_apres    = "corrente"
       v_cod_finalid_econ          = "corrente"
       v_des_finalid_econ_abrev    = "corrente"
       v_cdn_cliente_ini           = 0
       v_cdn_cliente_fim           = 99999999
       v_log_mostra_liquidac_pagto = yes
       v_val_cotac                 = 1
       v_cod_espec_docto_ini       = ""
       v_cod_espec_docto_fim       = "zzzz" 
       v_log_mostra_liquidac_normal  = YES  
       v_log_mostra_liquidac_antecip = NO
       v_log_mostra_liquidac         =  YES
       v_des_estab_select            = "101,102,103,104,301".

            des_estab_block:
            do v_num_cont_aux = 1 to num-entries(v_des_estab_select):

                blk_estab:
                for first estabelecimento fields(cod_estab cod_empresa) no-lock
                    where estabelecimento.cod_estab = entry(v_num_cont_aux, v_des_estab_select):

                    create tt_estab.
                    assign tt_estab.ttv_cod_empres = estabelecimento.cod_empresa
                           tt_estab.ttv_cod_estab  = estabelecimento.cod_estab.

                end /* for blk_estab */.
            end /* do des_estab_block */.


            create tt_estabelec. 
            assign tt_estabelec.tta_cod_estab = "101".

            create tt_estabelec. 
            assign tt_estabelec.tta_cod_estab = "102".

            create tt_estabelec. 
            assign tt_estabelec.tta_cod_estab = "103".
            create tt_estabelec. 
            assign tt_estabelec.tta_cod_estab = "104".
            create tt_estabelec. 
            assign tt_estabelec.tta_cod_estab = "301".

            create tt_param_clien_consid.
            assign tt_param_clien_consid.ttv_num_seq                 = 1
                   tt_param_clien_consid.ttv_cdn_cliente_ini         = v_cdn_cliente_ini
                   tt_param_clien_consid.ttv_cdn_cliente_fim         = v_cdn_cliente_fim
                   tt_param_clien_consid.ttv_cod_grp_clien_ini       = "":U
                   tt_param_clien_consid.ttv_cod_grp_clien_fim       = "ZZZZ":U
                   tt_param_clien_consid.ttv_log_consid_clien_matriz = NO
                   tt_param_clien_consid.ttv_cdn_matriz_clien_inic   = 0
                   tt_param_clien_consid.ttv_cdn_matriz_clien_fim    = 999999
                   tt_param_clien_consid.ttv_log_mostra_erro         = no.

            run pi_criar_tt_clien_consid (Input table tt_param_clien_consid,
                                          Input table tt_estab,
                                          output table tt_clien_consid) /*pi_criar_tt_clien_consid*/.

            for each tt_clien_consid
               where tt_clien_consid.tta_cod_empresa = "1" ,//v_cod_empres_usuar,
               first emsuni.cliente no-lock
               where cliente.cod_empresa = tt_clien_consid.tta_cod_empresa
                 and cliente.cdn_cliente = tt_clien_consid.tta_cdn_cliente:      

                create tt_cliente_matriz.
                assign tt_cliente_matriz.ttv_rec_cliente = recid(cliente).
                buffer-copy cliente to tt_cliente_matriz.

            end.

                        


RUN pi_manter_tempor_liquidac_period_generic_con.


END PROCEDURE.
/*****************************************************************************
** Procedure Interna.....: pi_carrega_espec_docto_temporaria
** Descricao.............: pi_carrega_espec_docto_temporaria
** Criado por............: Amarildo
** Criado em.............: 13/03/1997 08:28:52
** Alterado por..........: fut41061
** Alterado em...........: 09/04/2013 15:09:43
*****************************************************************************/
PROCEDURE pi_carrega_espec_docto_temporaria:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_espec_docto_ini
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_espec_docto_fim
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    especie:
    for each espec_docto_financ_acr
       fields (cod_espec_docto) no-lock
       where espec_docto_financ_acr.cod_espec_docto >= p_cod_espec_docto_ini
       and   espec_docto_financ_acr.cod_espec_docto <= p_cod_espec_docto_fim.
       find first emsuni.espec_docto of espec_docto_financ_acr no-lock no-error.

       if  not available espec_docto then
           next especie.

       if  espec_docto.ind_tip_espec_docto = "Normal" /*l_normal*/             or
           espec_docto.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/          or /* controle terceiros */
           espec_docto.ind_tip_espec_docto = "Previs∆o" /*l_previsao*/           or
           espec_docto.ind_tip_espec_docto = "Antecipaá∆o" /*l_antecipacao*/        or 
           espec_docto.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/  or
           espec_docto.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/          or /* controle terceiros */
           espec_docto.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/       or
           espec_docto.ind_tip_espec_docto = "Vendor" /*l_vendor*/             or  /* ==> MODULO VENDOR <== */
           espec_docto.ind_tip_espec_docto = "Vendor Repactuado" /*l_vendor_repac*/ 
       then do:         /* ==> MODULO VENDOR <== */

           /* especie2: */
           case espec_docto.ind_tip_espec_docto:
              when "Cheques Recebidos" /*l_cheques_recebidos*/ then
                  if  v_log_mostra_cheq = no then
                      next especie.
              when "Normal" /*l_normal*/ then
                  if  v_log_mostra_normal = no then
                      next especie.
              when "Antecipaá∆o" /*l_antecipacao*/ then
                  if  v_log_mostra_antecip = no then
                      next especie.
              when "Previs∆o" /*l_previsao*/ then
                  if  v_log_mostra_prev = no then
                      next especie.
              when "Aviso DÇbito" /*l_aviso_debito*/ then
                  if  v_log_mostra_aviso_db = no then
                      next especie.
              when "Terceiros" /*l_terceiros*/ then /* controle terceiros */
                  if v_log_tip_espec_docto_terc = no
                  or v_log_control_terc_acr     = no then
                      next especie.
              when "Cheques Terceiros" /*l_cheq_terc*/ then /* controle terceiros */
                  if v_log_tip_espec_docto_cheq_terc = no
                  or v_log_control_terc_acr          = no then
                      next especie.
              when "Vendor" /*l_vendor*/ then          /* ==> MODULO VENDOR <== */
                  if  v_log_mostra_docto_vendor = no then
                      next especie.
              when "Vendor Repactuado" /*l_vendor_repac*/ then    /* ==> MODULO VENDOR <== */
                  if  v_log_mostra_docto_vendor_repac = no then
                      next especie.
           end /* case especie2 */.
        end /* if */.
        else
            next especie.

        create tt_espec_docto_faixa.
        assign tt_espec_docto_faixa.tta_cod_espec_docto     = espec_docto_financ_acr.cod_espec_docto
               tt_espec_docto_faixa.tta_ind_tip_espec_docto = espec_docto.ind_tip_espec_docto.
    end /* for especie */.
END PROCEDURE. /* pi_carrega_espec_docto_temporaria */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_transacao_abreviada
** Descricao.............: pi_carrega_transacao_abreviada
** Criado por............: Amarildo
** Criado em.............: 13/03/1997 10:08:48
** Alterado por..........: fut41061
** Alterado em...........: 09/04/2013 15:16:20
*****************************************************************************/
PROCEDURE pi_carrega_transacao_abreviada:

    if  v_log_mostra_liquidac_normal
    or  v_log_mostra_liquidac_antecip
    or  v_log_mostra_liquidac then do:

        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "LIQ" /*l_liq*/ . /* Liquidaá∆o */ 

           if  not v_log_mostra_acerto_val_menor then do:
                create tt_transacao_abreviada.
                assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "AVMN" /*l_avmn*/ . /* Acerto Valor a Menor */
           end.    
    end.

    if  v_log_mostra_liquidac_renegoc then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "LQRN" /*l_lqrn*/ . /* Liquidaá∆o Renegociac */
    end.
    if  v_log_mostra_liq_enctro_cta then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "LQEC" /*l_lqec*/ . /* Liquidaá∆o Enctro Ctas*/
    end.
    if  v_log_mostra_perda_dedut then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "LQPD" /*l_lqpd*/ . /* Liquidaá∆o Perda Dedutivel*/
    end.
    if  v_log_mostra_transf_estab then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "LQTE" /*l_lqte*/ . /* Liquidaá∆o Transf Estab */
    end.
    if  v_log_mostra_acerto_val_cr then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "AVCR" /*l_avcr*/ . /* Acerto Valor a CrÇdito */
    end.
    if  v_log_mostra_acerto_val_menor then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "AVMN" /*l_avmn*/ . /* Acerto Valor a Menor */
    end.
    if  v_log_mostra_devol then do:
        create tt_transacao_abreviada.
        assign tt_transacao_abreviada.tta_ind_trans_acr_abrev = "DEV" /*l_dev*/ .  /* Devoluá∆o */
    end.
END PROCEDURE. /* pi_carrega_transacao_abreviada */
/*****************************************************************************
** Procedure Interna.....: pi_vld_valores_apres_apb_acr
** Descricao.............: pi_vld_valores_apres_apb_acr
** Criado por............: Uno
** Criado em.............: 19/07/1996 15:44:37
** Alterado por..........: fut41061
** Alterado em...........: 09/04/2013 14:46:55
*****************************************************************************/
PROCEDURE pi_vld_valores_apres_apb_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_finalid_econ_apres
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_conver
        as date
        format "99/99/9999"
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


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_indic_econ_base
        as character
        format "x(8)":U
        label "Moeda Base"
        column-label "Moeda Base"
        no-undo.
    def var v_cod_indic_econ_idx
        as character
        format "x(8)":U
        label "Moeda ÷ndice"
        column-label "Moeda ÷ndice"
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    find first finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = p_cod_finalid_econ
         no-error.
    if  not avail finalid_econ
    then do:
        /* Finalidade Econìmica inexistente ! */
        run pi_messages (input "show",
                         input 1652,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1652*/.
        return error.
    end /* if */.

    if  finalid_econ.ind_armaz_val <> "M¢dulos" /*l_modulos*/ 
    then do:
        /* Finalidade Econìmica n∆o armazena valores no M¢dulo ! */
        run pi_messages (input "show",
                         input 1389,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            p_cod_finalid_econ)) /*msg_1389*/.
        return error.
    end /* if */.

    find first finalid_unid_organ no-lock
         where finalid_unid_organ.cod_unid_organ   = v_cod_empres_usuar
         and   finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ
         no-error.
    if  not avail finalid_unid_organ
    then do:
        /* Finalidade n∆o liberada para Empresa do Usu†rio ! */
        run pi_messages (input "show",
                         input 2655,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2655*/.
        return error.
    end /* if */.



    run pi_retornar_indic_econ_finalid (Input p_cod_finalid_econ,
                                        Input p_dat_conver,
                                        output v_cod_indic_econ_base) /*pi_retornar_indic_econ_finalid*/.
    if  v_cod_indic_econ_base = ? or v_cod_indic_econ_base = " "
    then do:
        /* Hist¢rico da Finalidade Inexistente para Data Convers∆o ! */
        run pi_messages (input "show",
                         input 2452,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2452*/.
        return error.
    end /* if */.

    find first b_finalid_econ no-lock
         where b_finalid_econ.cod_finalid_econ = p_cod_finalid_econ_apres
         no-error.
    if  not avail b_finalid_econ
    then do:
        /* Finalidade Econìmica de Apresentaá∆o Inexistente ! */
        run pi_messages (input "show",
                         input 2450,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2450*/.
        return error.
    end /* if */.

    find first b_finalid_unid_organ no-lock
         where b_finalid_unid_organ.cod_unid_organ   = v_cod_empres_usuar
         and   b_finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ_apres
         no-error.
    if  not avail b_finalid_unid_organ
    then do:
        /* Finalidade Apresentaá∆o n∆o liberada p/ Empresa do Usu†rio ! */
        run pi_messages (input "show",
                         input 2656,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2656*/.
        return error.
    end /* if */.

    run pi_retornar_indic_econ_finalid (Input p_cod_finalid_econ_apres,
                                        Input p_dat_conver,
                                        output v_cod_indic_econ_idx) /*pi_retornar_indic_econ_finalid*/.
    if  v_cod_indic_econ_idx = ? or v_cod_indic_econ_idx = " "
    then do:
        /* Hist¢rico Finalid. Apresent. Inexistente p/ Data Convers∆o ! */
        run pi_messages (input "show",
                         input 2453,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2453*/.
        return error.
    end /* if */.

    run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_base,
                                   Input v_cod_indic_econ_idx,
                                   Input p_dat_conver,
                                   Input "Real" /*l_real*/,
                                   output p_dat_cotac_indic_econ,
                                   output p_val_cotac_indic_econ,
                                   output v_cod_return) /*pi_achar_cotac_indic_econ*/.
    if  v_cod_return <> "OK" /*l_ok*/ 
    then do:
        /* Cotaá∆o entre Indicadores Econìmicos n∆o encontrada ! */
        run pi_messages (input "show",
                         input 358,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            entry(2,v_cod_return), entry(3,v_cod_return), entry(4,v_cod_return), entry(5,v_cod_return))) /*msg_358*/.
        return error.
    end /* if */.
END PROCEDURE. /* pi_vld_valores_apres_apb_acr */
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
         use-index hstrfnld_id
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
                     use-index ctcprd_id
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id
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
                                          use-index ctcprd_id
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               v_log_indic     = yes.
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
** Procedure Interna.....: pi_criar_tt_matriz_clien_liquidac_acr
** Descricao.............: pi_criar_tt_matriz_clien_liquidac_acr
** Criado por............: bre18791
** Criado em.............: 05/07/1999 11:15:02
** Alterado por..........: fut1090
** Alterado em...........: 25/09/2003 13:32:09
*****************************************************************************/
PROCEDURE pi_criar_tt_matriz_clien_liquidac_acr:

    create tt_matriz_clien_liquidac_acr.
    assign tt_matriz_clien_liquidac_acr.tta_cod_empresa                 = tt_tit_acr_liquidac.tta_cod_empresa
           tt_matriz_clien_liquidac_acr.tta_cod_estab                   = tt_tit_acr_liquidac.tta_cod_estab
           tt_matriz_clien_liquidac_acr.tta_cod_espec_docto             = tt_tit_acr_liquidac.tta_cod_espec_docto
           tt_matriz_clien_liquidac_acr.tta_cod_ser_docto               = tt_tit_acr_liquidac.tta_cod_ser_docto
           tt_matriz_clien_liquidac_acr.tta_cod_tit_acr                 = tt_tit_acr_liquidac.tta_cod_tit_acr
           tt_matriz_clien_liquidac_acr.tta_cod_parcela                 = tt_tit_acr_liquidac.tta_cod_parcela
           tt_matriz_clien_liquidac_acr.tta_cdn_cliente                 = tt_tit_acr_liquidac.tta_cdn_cliente
           tt_matriz_clien_liquidac_acr.tta_nom_abrev                   = tt_tit_acr_liquidac.tta_nom_abrev
           tt_matriz_clien_liquidac_acr.tta_dat_transacao               = tt_tit_acr_liquidac.tta_dat_transacao
           tt_matriz_clien_liquidac_acr.tta_ind_trans_acr_abrev         = tt_tit_acr_liquidac.tta_ind_trans_acr_abrev
           tt_matriz_clien_liquidac_acr.tta_val_movto_tit_acr           = tt_tit_acr_liquidac.tta_val_movto_tit_acr
           tt_matriz_clien_liquidac_acr.ttv_rec_movto_tit_acr           = tt_tit_acr_liquidac.ttv_rec_movto_tit_acr
           tt_matriz_clien_liquidac_acr.tta_ind_espec_docto             = tt_tit_acr_liquidac.tta_ind_espec_docto
           tt_matriz_clien_liquidac_acr.tta_dat_vencto_tit_acr          = tt_tit_acr_liquidac.tta_dat_vencto_tit_acr
           tt_matriz_clien_liquidac_acr.tta_val_desconto                = tt_tit_acr_liquidac.tta_val_desconto
           tt_matriz_clien_liquidac_acr.tta_val_abat_tit_acr            = tt_tit_acr_liquidac.tta_val_abat_tit_acr
           tt_matriz_clien_liquidac_acr.tta_val_juros                   = tt_tit_acr_liquidac.tta_val_juros
           tt_matriz_clien_liquidac_acr.tta_val_multa_tit_acr           = tt_tit_acr_liquidac.tta_val_multa_tit_acr
           tt_matriz_clien_liquidac_acr.tta_cod_indic_econ              = tt_tit_acr_liquidac.tta_cod_indic_econ.      


END PROCEDURE. /* pi_criar_tt_matriz_clien_liquidac_acr */
/*****************************************************************************
** Procedure Interna.....: pi_manter_tempor_liquidac_period_generic_con
** Descricao.............: pi_manter_tempor_liquidac_period_generic_con
** Criado por............: bre17906
** Criado em.............: 09/07/1999 15:15:36
** Alterado por..........: fut1147
** Alterado em...........: 04/08/2014 10:46:07
*****************************************************************************/
PROCEDURE pi_manter_tempor_liquidac_period_generic_con:

    /************************* Variable Definition Begin ************************/

    def var v_dat_param                      as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    for each tt_espec_docto_faixa:
      delete tt_espec_docto_faixa.
    end.
    run pi_carrega_espec_docto_temporaria (v_cod_espec_docto_ini, v_cod_espec_docto_fim).

    for each tt_transacao_abreviada:
      delete tt_transacao_abreviada.
    end.
    run pi_carrega_transacao_abreviada.

    for each tt_tit_acr_liquidac:
      delete tt_tit_acr_liquidac.
    end.

    /* ** Deletar esta temp-table somente se o programa for o de contexto do cliente ***/
    if index(program-name(1), 'prgfin/acr/acr247za.p') <> 0 
    then do:
       for each tt_matriz_clien_liquidac_acr:
         delete tt_matriz_clien_liquidac_acr.
       end.
    end.


    if (v_dat_liquidac_fim - v_dat_liquidac_inic) <= 30 then
       run pi_manter_tempor_liquidac_period_generic_con_dat.
    else 

       run pi_manter_tempor_liquidac_period_generic_con_cli. 



END PROCEDURE. /* pi_manter_tempor_liquidac_period_generic_con */
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
** Procedure Interna.....: pi_tit_acr_con_liquidac_grava_valores
** Descricao.............: pi_tit_acr_con_liquidac_grava_valores
** Criado por............: Barth
** Criado em.............: 19/12/2000 15:54:49
** Alterado por..........: fut40711
** Alterado em...........: 20/07/2007 08:33:35
*****************************************************************************/
PROCEDURE pi_tit_acr_con_liquidac_grava_valores:

    /************************* Variable Definition Begin ************************/

    def var v_cod_refer_contrat_cambio
        as character
        format "x(10)":U
        no-undo.
    def var v_cod_finalid_econ_tit           as character       no-undo. /*local*/
    def var v_cod_return                     as character       no-undo. /*local*/
    def var v_val_cotac_apres                as decimal         no-undo. /*local*/
    def var v_val_liq_tit_acr                as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  tit_acr.cod_indic_econ = v_cod_indic_econ_idx then
        return.   /* ** O TITULO Jµ ESTµ NA MOEDA DE APRESENTAÄ«O ***/

    run pi_retornar_finalid_indic_econ (Input tit_acr.cod_indic_econ,
                                        Input tit_acr.dat_transacao,
                                        output v_cod_finalid_econ_tit) /*pi_retornar_finalid_indic_econ*/.

    if v_cod_indic_econ_idx = "" or v_cod_indic_econ_idx = ? then
        run pi_retornar_indic_econ_finalid (Input v_cod_finalid_econ_apres,
                                            Input v_dat_cotac_indic_econ,
                                            output v_cod_indic_econ_idx) /* pi_retornar_indic_econ_finalid*/.

    if  v_cod_finalid_econ_tit <> v_cod_finalid_econ_apres then do:
        run pi_achar_cotac_indic_econ (Input tit_acr.cod_indic_econ,
                                       Input v_cod_indic_econ_idx,
                                       Input v_dat_cotac_indic_econ,
                                       Input "Real" /*l_real*/,
                                       output v_dat_conver,
                                       output v_val_cotac_apres,
                                       output v_cod_return) /*pi_achar_cotac_indic_econ*/.
        if v_val_cotac_apres > 0 then
            assign tt_tit_acr_liquidac.tta_val_movto_tit_acr = tt_tit_acr_liquidac.tta_val_movto_tit_acr / v_val_cotac_apres.
        else do:

                assign v_cod_refer_contrat_cambio = movto_tit_acr.cod_refer_contrat_cambio.

                if movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/ 
                and v_cod_refer_contrat_cambio <> ' '
                and movto_tit_acr.ind_motiv_acerto_val = "Liquidaá∆o" /*l_liquidacao*/  then do:
                    for each val_movto_tit_acr 
                         fields (cod_estab num_id_movto_tit_acr cod_finalid_econ val_liquidac_tit_acr val_ajust_val_tit_acr)
                         no-lock
                         where val_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                         and   val_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                         and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ_apres:
    			assign v_val_liq_tit_acr = v_val_liq_tit_acr + val_movto_tit_acr.val_ajust_val_tit_acr.
    	        end.       
                end.
                else do:

            for each val_movto_tit_acr 
                 fields (cod_estab num_id_movto_tit_acr cod_finalid_econ val_liquidac_tit_acr)
                 no-lock
                 where val_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                 and   val_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                 and   val_movto_tit_acr.cod_finalid_econ     = v_cod_finalid_econ_apres:
                assign v_val_liq_tit_acr = v_val_liq_tit_acr + val_movto_tit_acr.val_liquidac_tit_acr.
            end.

                end.
            assign tt_tit_acr_liquidac.tta_val_movto_tit_acr = v_val_liq_tit_acr.
        end.
    end.

END PROCEDURE. /* pi_tit_acr_con_liquidac_grava_valores */
/*****************************************************************************
** Procedure Interna.....: pi_carrega_tt_faixa_datas
** Descricao.............: pi_carrega_tt_faixa_datas
** Criado por............: Amarildo
** Criado em.............: 13/03/1997 07:56:39
** Alterado por..........: Klug
** Alterado em...........: 30/04/1998 16:46:09
*****************************************************************************/
PROCEDURE pi_carrega_tt_faixa_datas:

    /************************ Parameter Definition Begin ************************/

    def Input param p_dat_inic
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_table
        as date
        format "99/99/9999":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* ** CARREGA TEMPORµRIA COM AS DATAS COMPREENDIDAS EM UMA DETERMINADA FAIXA *********/
    /* ** Dever† ser relacionada aos objetos do programa uma tab-temp (tt_datas_faixa) ***/

    assign v_dat_table = p_dat_inic.
    data:
    repeat while v_dat_table <= p_dat_fim:
       create tt_datas_faixa.
       assign tt_datas_faixa.ttv_dat_table = v_dat_table
              v_dat_table                  = v_dat_table + 1.
    end /* repeat data */.

    /* ***********************************************************************************/
END PROCEDURE. /* pi_carrega_tt_faixa_datas */
/*****************************************************************************
** Procedure Interna.....: pi_manter_tempor_liquidac_period_generic_con_cli
** Descricao.............: pi_manter_tempor_liquidac_period_generic_con_cli
** Criado por............: fut1147
** Criado em.............: 23/03/2006 10:57:44
** Alterado por..........: rafaelposse
** Alterado em...........: 18/05/2016 16:42:25
*****************************************************************************/
PROCEDURE pi_manter_tempor_liquidac_period_generic_con_cli:

    /************************* Variable Definition Begin ************************/

    def var v_cod_refer_contrat_cambio
        as character
        format "x(10)":U
        no-undo.
    def var v_dat_param                      as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if v_log_habilita_con_corporat then do:
        blk_estab:
        do v_num_cont_aux = 1 to num-entries(v_des_estab_select):

            if not can-find (first movto_tit_acr
                             where movto_tit_acr.cod_estab      = entry(v_num_cont_aux, v_des_estab_select)
                               and movto_tit_acr.dat_transacao >= v_dat_liquidac_inic
                               and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim no-lock)
            then next blk_estab.

            blk_movto:        
            do v_dat_param = v_dat_liquidac_inic to v_dat_liquidac_fim:
               find first movto_tit_acr no-lock
                    where movto_tit_acr.cod_estab      = entry(v_num_cont_aux, v_des_estab_select)
                      and movto_tit_acr.dat_transacao >= v_dat_param no-error.
               if avail movto_tit_acr and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim
                  then assign v_dat_param = movto_tit_acr.dat_transacao.
                  else leave blk_movto.

               movimento:
               for each movto_tit_acr 
                   fields (cod_empresa cod_estab cod_espec_docto cod_portador cdn_cliente num_id_tit_acr num_id_movto_tit_acr
                           ind_trans_acr_abrev dat_transacao dat_cr_movto_tit_acr log_liquidac_contra_antecip 
                           log_movto_estordo val_movto_tit_acr dat_vencto_tit_acr val_desconto val_abat_tit_acr 
                           val_juros val_multa_tit_acr dat_liquidac_tit_acr cod_refer_contrat_cambio ind_motiv_acerto_val) no-lock
                   where movto_tit_acr.cod_estab     = entry(v_num_cont_aux, v_des_estab_select)
                     and movto_tit_acr.dat_transacao = v_dat_param:

                    if  not v_log_consid_clien_matriz then do:
                        if  movto_tit_acr.cdn_cliente       < v_cdn_cliente_ini or
                            movto_tit_acr.cdn_cliente       > v_cdn_cliente_fim then 
                            next.                   
                    end.
                    else do:
                        find first tt_clien_consid 
                             where tt_clien_consid.tta_cod_empresa = movto_tit_acr.cod_empresa
                               and tt_clien_consid.tta_cdn_cliente = movto_tit_acr.cdn_cliente no-error. 
                        if  not avail tt_clien_consid then
                            next movimento.    
                    end. 

                    /* Se o acerto de valor for igual a ZERO, isso indica que sua origem Ç VENDOR, sendo assim, esses movimentos devem ser desconsiderados */
                    IF v_log_modul_vendor                = YES AND
                       movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  AND
                       movto_tit_acr.val_movto_tit_acr   = 0 THEN
                       NEXT movimento.

                     if not can-find (first tt_espec_docto_faixa
                                      where tt_espec_docto_faixa.tta_cod_espec_docto = movto_tit_acr.cod_espec_docto no-lock)
                     then next movimento.

                     if not can-find (first tt_transacao_abreviada
                                      where tt_transacao_abreviada.tta_ind_trans_acr_abrev = movto_tit_acr.ind_trans_acr_abrev no-lock)
                     then next movimento.


                     if movto_tit_acr.ind_trans_acr_abrev = "LIQ" /*l_liq*/   or
                        movto_tit_acr.ind_trans_acr_abrev = "LQRN" /*l_lqrn*/  or
                        movto_tit_acr.ind_trans_acr_abrev = "LQEC" /*l_lqec*/  then do:
                        if movto_tit_acr.dat_liquidac_tit_acr < v_dat_liquidac_inicial or
                           movto_tit_acr.dat_liquidac_tit_acr > v_dat_liquidac_final
                        then next movimento.
                     end.   

                     assign v_cod_refer_contrat_cambio = movto_tit_acr.cod_refer_contrat_cambio.

                         if movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/ 
                         and v_cod_refer_contrat_cambio <> ' '
                         and movto_tit_acr.ind_motiv_acerto_val = "Liquidaá∆o" /*l_liquidacao*/  then do:
                             if not v_log_mostra_liquidac then
                                 next movimento.
                         end.
                         else if movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  then do:
                             if not v_log_mostra_acerto_val_menor then
                                 next movimento.
                         end.


                     /* Begin_Include: i_selecao_consulta_liquidacao_con */
                     find first tit_acr no-lock
                          where tit_acr.cod_estab       = movto_tit_acr.cod_estab
                            and tit_acr.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr
                          no-error.
                     if not avail tit_acr
                        then next movimento.

                     if  ((movto_tit_acr.log_liquidac_contra_antecip = no
                       and v_log_mostra_liquidac_pagto               = no)
                        or (movto_tit_acr.log_liquidac_contra_antecip = yes
                       and  v_log_mostra_liquidac_antecip             = no))
                        or (movto_tit_acr.log_movto_estordo           = yes
                       and  v_log_mostra_liquidac_estorn              = no)
                        or (movto_tit_acr.cod_portador < v_cod_portador_ini
                        or  movto_tit_acr.cod_portador > v_cod_portador_fim)
                        or (tit_acr.cod_indic_econ     < v_cod_indic_econ_ini
                        or  tit_acr.cod_indic_econ     > v_cod_indic_econ_fim)
                       then next movimento.
                     /* End_Include: i_selecao_consulta_liquidacao_con */


                         if tit_acr.cod_proces_export < v_cod_proces_export_ini
                         or tit_acr.cod_proces_export > v_cod_proces_export_fim then
                            next movimento.
                         if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                            if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then do:
                               if string(entry(4,tit_acr.cod_livre_1,CHR(24))) < v_cod_proces_export_ini
                               or string(entry(4,tit_acr.cod_livre_1,CHR(24))) > v_cod_proces_export_fim then
                                  next movimento.
                            end.
                            else do:
                               if v_cod_proces_export_ini <> "" /*l_null*/  then do:
                                  if num-entries (tit_acr.cod_livre_1,chr(24)) < 4 then
                                     next movimento.
                               end.   
                            end.               
                         end.        


                         RUN pi-acompanhar IN h-acomp (INPUT "ESRC798b " + "Estab " + tit_Acr.cod_estab + " Data " + string(tit_Acr.dat_transacao)).
                     create tt_tit_acr_liquidac.
                     assign tt_tit_acr_liquidac.tta_cod_empresa                 = tit_acr.cod_empresa
                            tt_tit_acr_liquidac.tta_cod_espec_docto             = tit_acr.cod_espec_docto
                            tt_tit_acr_liquidac.tta_cod_ser_docto               = tit_acr.cod_ser_docto
                            tt_tit_acr_liquidac.tta_cod_tit_acr                 = tit_acr.cod_tit_acr
                            tt_tit_acr_liquidac.tta_cod_parcela                 = tit_acr.cod_parcela
                            tt_tit_acr_liquidac.tta_cdn_cliente                 = tit_acr.cdn_cliente
                            tt_tit_acr_liquidac.tta_nom_abrev                   = tit_acr.nom_abrev
                            tt_tit_acr_liquidac.tta_cod_estab                   = movto_tit_acr.cod_estab
                            tt_tit_acr_liquidac.tta_dat_transacao               = movto_tit_acr.dat_transacao
                            tt_tit_acr_liquidac.tta_dat_cr_movto_tit_acr        = movto_tit_acr.dat_cr_movto_tit_acr
                            tt_tit_acr_liquidac.tta_ind_trans_acr_abrev         = movto_tit_acr.ind_trans_acr_abrev
                            tt_tit_acr_liquidac.tta_log_movto_estordo           = movto_tit_acr.log_movto_estordo
                            tt_tit_acr_liquidac.tta_log_liquidac_contra_antecip = movto_tit_acr.log_liquidac_contra_antecip
                            tt_tit_acr_liquidac.tta_val_movto_tit_acr           = movto_tit_acr.val_movto_tit_acr
                            tt_tit_acr_liquidac.tta_num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                            tt_tit_acr_liquidac.ttv_rec_movto_tit_acr           = recid(movto_tit_acr)
                            tt_tit_acr_liquidac.tta_ind_espec_docto             = tit_acr.ind_tip_espec_docto
                            tt_tit_acr_liquidac.tta_dat_vencto_tit_acr          = movto_tit_acr.dat_vencto_tit_acr
                            tt_tit_acr_liquidac.tta_val_desconto                = movto_tit_acr.val_desconto
                            tt_tit_acr_liquidac.tta_val_abat_tit_acr            = movto_tit_acr.val_abat_tit_acr
                            tt_tit_acr_liquidac.tta_val_juros                   = movto_tit_acr.val_juros
                            tt_tit_acr_liquidac.tta_val_multa_tit_acr           = movto_tit_acr.val_multa_tit_acr.

                     if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                             assign tt_tit_acr_liquidac.ttv_cod_proces_export = tit_acr.cod_proces_export.                          
                             if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then
                                 assign tt_tit_acr_liquidac.ttv_cod_proces_export = entry(4,tit_acr.cod_livre_1,chr(24)).
                     end.       

                     find first compl_movto_tit_acr no-lock
                          where compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                            and compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                          no-error.

                     if avail compl_movto_tit_acr  
                        then assign tt_tit_acr_liquidac.tta_cod_indic_econ = compl_movto_tit_acr.cod_indic_econ. 
                        else assign tt_tit_acr_liquidac.tta_cod_indic_econ = tit_acr.cod_indic_econ. 

                     run pi_tit_acr_con_liquidac_grava_valores.
               end.
            end.
        end.
    end.
    else do:

        blk_estab:
        for each tt_estabelec:

            if not can-find (first movto_tit_acr
                             where movto_tit_acr.cod_estab      = tt_estabelec.tta_cod_estab
                               and movto_tit_acr.dat_transacao >= v_dat_liquidac_inic
                               and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim no-lock)
            then next blk_estab.

            blk_movto:
            for each tt_cliente_matriz:

                do v_dat_param = v_dat_liquidac_inic to v_dat_liquidac_fim:
                   find first movto_tit_acr no-lock
                        where movto_tit_acr.cod_estab      = tt_estabelec.tta_cod_estab
                          and movto_tit_acr.cdn_cliente    = tt_cliente_matriz.cdn_cliente
                          and movto_tit_acr.dat_transacao >= v_dat_param
                   no-error.
                   if avail movto_tit_acr and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim
                      then assign v_dat_param = movto_tit_acr.dat_transacao.
                      else next blk_movto.

                   movimento:
                   for each movto_tit_acr 
                       fields (cod_estab cod_espec_docto cod_portador cdn_cliente num_id_tit_acr num_id_movto_tit_acr
                               ind_trans_acr_abrev dat_transacao dat_cr_movto_tit_acr log_liquidac_contra_antecip 
                               log_movto_estordo val_movto_tit_acr dat_vencto_tit_acr val_desconto val_abat_tit_acr 
                               val_juros val_multa_tit_acr dat_liquidac_tit_acr cod_refer_contrat_cambio ind_motiv_acerto_val) no-lock
                       where movto_tit_acr.cod_estab     = tt_estabelec.tta_cod_estab
                         and movto_tit_acr.cdn_cliente   = tt_cliente_matriz.cdn_cliente
                         and movto_tit_acr.dat_transacao = v_dat_param:

                        /* Se o acerto de valor for igual a ZERO, isso indica que sua origem Ç VENDOR, sendo assim, esses movimentos devem ser desconsiderados */
                        IF v_log_modul_vendor                = YES AND
                           movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  AND
                           movto_tit_acr.val_movto_tit_acr   = 0 THEN
                           NEXT movimento.

                         if not can-find (first tt_espec_docto_faixa
                                          where tt_espec_docto_faixa.tta_cod_espec_docto = movto_tit_acr.cod_espec_docto no-lock)
                         then next movimento.

                         if not can-find (first tt_transacao_abreviada
                                          where tt_transacao_abreviada.tta_ind_trans_acr_abrev = movto_tit_acr.ind_trans_acr_abrev no-lock)
                         then next movimento.


                         if movto_tit_acr.ind_trans_acr_abrev = "LIQ" /*l_liq*/   or
                            movto_tit_acr.ind_trans_acr_abrev = "LQRN" /*l_lqrn*/  or
                            movto_tit_acr.ind_trans_acr_abrev = "LQEC" /*l_lqec*/  then do:
                            if movto_tit_acr.dat_liquidac_tit_acr < v_dat_liquidac_inicial or
                               movto_tit_acr.dat_liquidac_tit_acr > v_dat_liquidac_final
                            then next movimento.
                         end.   

                         assign v_cod_refer_contrat_cambio = movto_tit_acr.cod_refer_contrat_cambio.

                             if movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/ 
                             and v_cod_refer_contrat_cambio <> ' '
                             and movto_tit_acr.ind_motiv_acerto_val = "Liquidaá∆o" /*l_liquidacao*/  then do:
                                 if not v_log_mostra_liquidac then
                                     next movimento.
                             end.
                             else if movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  then do:
                                 if not v_log_mostra_acerto_val_menor then
                                     next movimento.
                             end.


                         /* Begin_Include: i_selecao_consulta_liquidacao_con */
                         find first tit_acr no-lock
                              where tit_acr.cod_estab       = movto_tit_acr.cod_estab
                                and tit_acr.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr
                              no-error.
                         if not avail tit_acr
                            then next movimento.

                         if  ((movto_tit_acr.log_liquidac_contra_antecip = no
                           and v_log_mostra_liquidac_pagto               = no)
                            or (movto_tit_acr.log_liquidac_contra_antecip = yes
                           and  v_log_mostra_liquidac_antecip             = no))
                            or (movto_tit_acr.log_movto_estordo           = yes
                           and  v_log_mostra_liquidac_estorn              = no)
                            or (movto_tit_acr.cod_portador < v_cod_portador_ini
                            or  movto_tit_acr.cod_portador > v_cod_portador_fim)
                            or (tit_acr.cod_indic_econ     < v_cod_indic_econ_ini
                            or  tit_acr.cod_indic_econ     > v_cod_indic_econ_fim)
                           then next movimento.
                         /* End_Include: i_selecao_consulta_liquidacao_con */


                             if tit_acr.cod_proces_export < v_cod_proces_export_ini
                             or tit_acr.cod_proces_export > v_cod_proces_export_fim then
                                next movimento.
                             if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                                if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then do:
                                   if string(entry(4,tit_acr.cod_livre_1,CHR(24))) < v_cod_proces_export_ini
                                   or string(entry(4,tit_acr.cod_livre_1,CHR(24))) > v_cod_proces_export_fim then
                                      next movimento.
                                end.
                                else do:
                                   if v_cod_proces_export_ini <> "" /*l_null*/  then do:
                                      if num-entries (tit_acr.cod_livre_1,chr(24)) < 4 then
                                         next movimento.
                                   end.   
                                end.               
                             end.        
                          RUN pi-acompanhar IN h-acomp (INPUT "ESRC798b" + "Estab " + tit_Acr.cod_estab + " Data " + STRING(tit_acr.dat_transacao)).
                         create tt_tit_acr_liquidac.
                         assign tt_tit_acr_liquidac.tta_cod_empresa                 = tit_acr.cod_empresa
                                tt_tit_acr_liquidac.tta_cod_espec_docto             = tit_acr.cod_espec_docto
                                tt_tit_acr_liquidac.tta_cod_ser_docto               = tit_acr.cod_ser_docto
                                tt_tit_acr_liquidac.tta_cod_tit_acr                 = tit_acr.cod_tit_acr
                                tt_tit_acr_liquidac.tta_cod_parcela                 = tit_acr.cod_parcela
                                tt_tit_acr_liquidac.tta_cdn_cliente                 = tit_acr.cdn_cliente
                                tt_tit_acr_liquidac.tta_nom_abrev                   = tit_acr.nom_abrev
                                tt_tit_acr_liquidac.tta_cod_estab                   = movto_tit_acr.cod_estab
                                tt_tit_acr_liquidac.tta_dat_transacao               = movto_tit_acr.dat_transacao
                                tt_tit_acr_liquidac.tta_dat_cr_movto_tit_acr        = movto_tit_acr.dat_cr_movto_tit_acr
                                tt_tit_acr_liquidac.tta_ind_trans_acr_abrev         = movto_tit_acr.ind_trans_acr_abrev
                                tt_tit_acr_liquidac.tta_log_movto_estordo           = movto_tit_acr.log_movto_estordo
                                tt_tit_acr_liquidac.tta_log_liquidac_contra_antecip = movto_tit_acr.log_liquidac_contra_antecip
                                tt_tit_acr_liquidac.tta_val_movto_tit_acr           = movto_tit_acr.val_movto_tit_acr
                                tt_tit_acr_liquidac.tta_num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                                tt_tit_acr_liquidac.ttv_rec_movto_tit_acr           = recid(movto_tit_acr)
                                tt_tit_acr_liquidac.tta_ind_espec_docto             = tit_acr.ind_tip_espec_docto
                                tt_tit_acr_liquidac.tta_dat_vencto_tit_acr          = movto_tit_acr.dat_vencto_tit_acr
                                tt_tit_acr_liquidac.tta_val_desconto                = movto_tit_acr.val_desconto
                                tt_tit_acr_liquidac.tta_val_abat_tit_acr            = movto_tit_acr.val_abat_tit_acr
                                tt_tit_acr_liquidac.tta_val_juros                   = movto_tit_acr.val_juros
                                tt_tit_acr_liquidac.tta_val_multa_tit_acr           = movto_tit_acr.val_multa_tit_acr.

                         if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                                 if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then
                                     assign tt_tit_acr_liquidac.ttv_cod_proces_export = entry(4,tit_acr.cod_livre_1,chr(24)).
                         end.       

                         find first compl_movto_tit_acr no-lock
                              where compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                and compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                              no-error.

                         if avail compl_movto_tit_acr  
                            then assign tt_tit_acr_liquidac.tta_cod_indic_econ = compl_movto_tit_acr.cod_indic_econ. 
                            else assign tt_tit_acr_liquidac.tta_cod_indic_econ = tit_acr.cod_indic_econ. 

                         run pi_tit_acr_con_liquidac_grava_valores.
                   end.
                end.
            end.
        end.
    end.
END PROCEDURE. /* pi_manter_tempor_liquidac_period_generic_con_cli */
/*****************************************************************************
** Procedure Interna.....: pi_manter_tempor_liquidac_period_generic_con_dat
** Descricao.............: pi_manter_tempor_liquidac_period_generic_con_dat
** Criado por............: fut1147
** Criado em.............: 23/03/2006 10:57:27
** Alterado por..........: adilsonhaut
** Alterado em...........: 12/08/2016 10:19:52
*****************************************************************************/
PROCEDURE pi_manter_tempor_liquidac_period_generic_con_dat:

    /************************* Variable Definition Begin ************************/

    def var v_cod_refer_contrat_cambio
        as character
        format "x(10)":U
        no-undo.
    def var v_dat_param                      as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if v_log_habilita_con_corporat then do:
        blk_estab:
        do v_num_cont_aux = 1 to num-entries(v_des_estab_select):

            blk_movto:        
            do v_dat_param = v_dat_liquidac_inic to v_dat_liquidac_fim:
               find first movto_tit_acr no-lock
                    where movto_tit_acr.cod_estab      = entry(v_num_cont_aux, v_des_estab_select)
                      and movto_tit_acr.dat_transacao >= v_dat_param
               no-error.
               if avail movto_tit_acr and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim
                  then assign v_dat_param = movto_tit_acr.dat_transacao.
                  else leave blk_movto.

               movimento:
               for each tt_espec_docto_faixa,   
                   each tt_transacao_abreviada, 
                   each movto_tit_acr 
                   fields (cod_empresa cod_estab cod_espec_docto cod_portador cdn_cliente num_id_tit_acr num_id_movto_tit_acr
                           ind_trans_acr_abrev dat_transacao dat_cr_movto_tit_acr log_liquidac_contra_antecip 
                           log_movto_estordo val_movto_tit_acr dat_vencto_tit_acr val_desconto val_abat_tit_acr 
                           val_juros val_multa_tit_acr dat_liquidac_tit_acr cod_refer_contrat_cambio ind_motiv_acerto_val)
                   use-index mvtttcr_estab_dat_trans no-lock
                   where movto_tit_acr.cod_estab            = entry(v_num_cont_aux, v_des_estab_select)
                     and movto_tit_acr.dat_transacao        = v_dat_param
                     and movto_tit_acr.cod_espec_docto      = tt_espec_docto_faixa.tta_cod_espec_docto
                     and movto_tit_acr.ind_trans_acr_abrev  = tt_transacao_abreviada.tta_ind_trans_acr_abrev:

                    if  not v_log_consid_clien_matriz then do:
                        if  movto_tit_acr.cdn_cliente     < v_cdn_cliente_ini or
                            movto_tit_acr.cdn_cliente     > v_cdn_cliente_fim then 
                            next.      
                    end. 
                    else do: 
                        find first tt_clien_consid 
                             where tt_clien_consid.tta_cod_empresa = movto_tit_acr.cod_empresa
                               and tt_clien_consid.tta_cdn_cliente = movto_tit_acr.cdn_cliente no-error. 
                        if  not avail tt_clien_consid then
                            next movimento.    
                    end.



                    /* Se o acerto de valor for igual a ZERO, isso indica que sua origem Ç VENDOR, sendo assim, esses movimentos devem ser desconsiderados */
                    IF v_log_modul_vendor                = YES AND
                       movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  AND
                       movto_tit_acr.val_movto_tit_acr   = 0 THEN
                       NEXT movimento.

                     if movto_tit_acr.ind_trans_acr_abrev = "LIQ" /*l_liq*/   or
                        movto_tit_acr.ind_trans_acr_abrev = "LQRN" /*l_lqrn*/  or
                        movto_tit_acr.ind_trans_acr_abrev = "LQEC" /*l_lqec*/  then do:
                        if movto_tit_acr.dat_liquidac_tit_acr < v_dat_liquidac_inicial or
                           movto_tit_acr.dat_liquidac_tit_acr > v_dat_liquidac_final
                        then next movimento.
                     end.   

                         assign v_cod_refer_contrat_cambio = movto_tit_acr.cod_refer_contrat_cambio.

                     if verifica_program_name('acr235aa':U,30) or 
                        verifica_program_name('acr262za':U,30)                  
                     then do:

                          /* Begin_Include: i_selecao_consulta_liquidacao_con */
                          find first tit_acr no-lock
                               where tit_acr.cod_estab       = movto_tit_acr.cod_estab
                                 and tit_acr.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr
                               no-error.
                          if not avail tit_acr
                             then next movimento.

                          if  ((movto_tit_acr.log_liquidac_contra_antecip = no
                            and v_log_mostra_liquidac_pagto               = no)
                             or (movto_tit_acr.log_liquidac_contra_antecip = yes
                            and  v_log_mostra_liquidac_antecip             = no))
                             or (movto_tit_acr.log_movto_estordo           = yes
                            and  v_log_mostra_liquidac_estorn              = no)
                             or (movto_tit_acr.cod_portador < v_cod_portador_ini
                             or  movto_tit_acr.cod_portador > v_cod_portador_fim)
                             or (tit_acr.cod_indic_econ     < v_cod_indic_econ_ini
                             or  tit_acr.cod_indic_econ     > v_cod_indic_econ_fim)
                            then next movimento.
                          /* End_Include: i_selecao_consulta_liquidacao_con */

                     end.
                     else do:     

                          /* Begin_Include: i_selecao_consulta_cliente */
                          find tit_acr of movto_tit_acr no-lock no-error. 
                          if not avail tit_acr then next movimento.

                          if ((movto_tit_acr.log_liquidac_contra_antecip = no                        and 
                              v_log_mostra_liquidac_pagto                = no)                       or  
                             (movto_tit_acr.log_liquidac_contra_antecip  = yes                       and 
                              v_log_mostra_liquidac_antecip              = no))                      or
                             (movto_tit_acr.log_movto_estordo            = yes                       and 
                              v_log_mostra_liquidac_estorn               = no)                       or
                             (not(movto_tit_acr.cod_espec_docto         >= v_cod_espec_docto_inicial and 
                                  movto_tit_acr.cod_espec_docto         <= v_cod_espec_docto_final   and
                                  movto_tit_acr.dat_vencto_tit_acr      >= v_dat_vencto_docto_inic   and
                                  movto_tit_acr.dat_vencto_tit_acr      <= v_dat_vencto_docto_fim))  or
                             (tit_acr.ind_tip_espec_docto                = "Normal" /*l_normal*/               and
                              v_log_mostra_normal                        = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Antecipaá∆o" /*l_antecipacao*/          and
                              v_log_mostra_antecip                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Previs∆o" /*l_previsao*/             and
                              v_log_mostra_prev                          = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Cheques Recebidos" /*l_cheques_recebidos*/    and
                              v_log_mostra_cheq                          = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Nota de DÇbito" /*l_nota_de_debito*/       and
                              v_log_mostra_ndebito                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Nota de CrÇdito" /*l_nota_de_credito*/      and
                              v_log_mostra_nota_cr                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Vendor" /*l_vendor*/               and
                              v_log_mostra_docto_vendor                  = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Vendor Repactuado" /*l_vendor_repac*/         and
                              v_log_mostra_docto_vendor_repac            = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Aviso DÇbito" /*l_aviso_debito*/         and
                              v_log_mostra_aviso_db_1                    = no)                       then next movimento.
                          /* End_Include: i_selecao_consulta_cliente */

                     end.

                         if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                            if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then do:
                               if string(entry(4,tit_acr.cod_livre_1,CHR(24))) < v_cod_proces_export_ini
                               or string(entry(4,tit_acr.cod_livre_1,CHR(24))) > v_cod_proces_export_fim then
                                  next movimento.
                            end.
                            else do:
                               if v_cod_proces_export_ini <> "" /*l_null*/  then do:
                                  if num-entries (tit_acr.cod_livre_1,chr(24)) < 4 then
                                     next movimento.
                               end.   
                            end.               
                         end.        

                         RUN pi-acompanhar IN h-acomp (INPUT "ESRC798b " + "Estab " + tit_Acr.cod_estab + " Data " + STRING(tit_acr.dat_transacao)).
                     create tt_tit_acr_liquidac.
                     assign tt_tit_acr_liquidac.tta_cod_empresa                 = tit_acr.cod_empresa
                            tt_tit_acr_liquidac.tta_cod_espec_docto             = tit_acr.cod_espec_docto
                            tt_tit_acr_liquidac.tta_cod_ser_docto               = tit_acr.cod_ser_docto
                            tt_tit_acr_liquidac.tta_cod_tit_acr                 = tit_acr.cod_tit_acr
                            tt_tit_acr_liquidac.tta_cod_parcela                 = tit_acr.cod_parcela
                            tt_tit_acr_liquidac.tta_cdn_cliente                 = tit_acr.cdn_cliente
                            tt_tit_acr_liquidac.tta_nom_abrev                   = tit_acr.nom_abrev
                            tt_tit_acr_liquidac.tta_cod_estab                   = movto_tit_acr.cod_estab
                            tt_tit_acr_liquidac.tta_dat_transacao               = movto_tit_acr.dat_transacao
                            tt_tit_acr_liquidac.tta_dat_cr_movto_tit_acr        = movto_tit_acr.dat_cr_movto_tit_acr
                            tt_tit_acr_liquidac.tta_ind_trans_acr_abrev         = movto_tit_acr.ind_trans_acr_abrev
                            tt_tit_acr_liquidac.tta_log_movto_estordo           = movto_tit_acr.log_movto_estordo
                            tt_tit_acr_liquidac.tta_log_liquidac_contra_antecip = movto_tit_acr.log_liquidac_contra_antecip
                            tt_tit_acr_liquidac.tta_val_movto_tit_acr           = movto_tit_acr.val_movto_tit_acr
                            tt_tit_acr_liquidac.tta_num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                            tt_tit_acr_liquidac.ttv_rec_movto_tit_acr           = recid(movto_tit_acr)
                            tt_tit_acr_liquidac.tta_ind_espec_docto             = tit_acr.ind_tip_espec_docto
                            tt_tit_acr_liquidac.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
                            tt_tit_acr_liquidac.tta_val_desconto                = movto_tit_acr.val_desconto
                            tt_tit_acr_liquidac.tta_val_abat_tit_acr            = movto_tit_acr.val_abat_tit_acr
                            tt_tit_acr_liquidac.tta_val_juros                   = movto_tit_acr.val_juros
                            tt_tit_acr_liquidac.tta_val_multa_tit_acr           = movto_tit_acr.val_multa_tit_acr.

                     if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                             if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then
                                 assign tt_tit_acr_liquidac.ttv_cod_proces_export = entry(4,tit_acr.cod_livre_1,chr(24)).
                     end.       

                     find first compl_movto_tit_acr no-lock
                          where compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                            and compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                          no-error.

                     if avail compl_movto_tit_acr  
                        then assign tt_tit_acr_liquidac.tta_cod_indic_econ = compl_movto_tit_acr.cod_indic_econ. 
                        else assign tt_tit_acr_liquidac.tta_cod_indic_econ = tit_acr.cod_indic_econ. 

                     /* ** Gravar esta temp-table somente se o programa for o de contexto do cliente ***/
                     if index(program-name(1), 'prgfin/acr/acr247za.p') <> 0 then do:
                        run pi_criar_tt_matriz_clien_liquidac_acr.
                     end.

                     /* ** Gravar valores base x apresentacao, somente se o programa for o de consulta liquidacao periodo ***/
                     if verifica_program_name('acr235aa':U,30) or 
                        verifica_program_name('acr262za':U,30) then
                        run pi_tit_acr_con_liquidac_grava_valores.
               end.
            end.
        end.

    end.
    else do:
        blk_estab:
        for each tt_estabelec:

            blk_movto:
            do v_dat_param = v_dat_liquidac_inic to v_dat_liquidac_fim:
               find first movto_tit_acr no-lock
                    where movto_tit_acr.cod_estab      = tt_estabelec.tta_cod_estab
                      and movto_tit_acr.dat_transacao >= v_dat_param
               no-error.
               if avail movto_tit_acr and movto_tit_acr.dat_transacao <= v_dat_liquidac_fim
                  then assign v_dat_param = movto_tit_acr.dat_transacao.
                  else next blk_movto.

               movimento:
               for each tt_espec_docto_faixa,   
                   each tt_transacao_abreviada, 
                   each movto_tit_acr 
                   fields (cod_empresa cod_estab cod_espec_docto cod_portador cdn_cliente num_id_tit_acr num_id_movto_tit_acr
                           ind_trans_acr_abrev dat_transacao dat_cr_movto_tit_acr log_liquidac_contra_antecip 
                           log_movto_estordo val_movto_tit_acr dat_vencto_tit_acr val_desconto val_abat_tit_acr 
                           val_juros val_multa_tit_acr dat_liquidac_tit_acr cod_refer_contrat_cambio ind_motiv_acerto_val)
                   use-index mvtttcr_estab_dat_trans no-lock
                   where movto_tit_acr.cod_estab            = tt_estabelec.tta_cod_estab
                     and movto_tit_acr.dat_transacao        = v_dat_param
                     and movto_tit_acr.cod_espec_docto      = tt_espec_docto_faixa.tta_cod_espec_docto
                     and movto_tit_acr.ind_trans_acr_abrev  = tt_transacao_abreviada.tta_ind_trans_acr_abrev:

                    if  not v_log_consid_clien_matriz then do:
                        if  movto_tit_acr.cdn_cliente     < v_cdn_cliente_ini or
                            movto_tit_acr.cdn_cliente     > v_cdn_cliente_fim then 
                            next.      
                    end. 
                    else do: 
                        find first tt_clien_consid 
                             where tt_clien_consid.tta_cod_empresa = movto_tit_acr.cod_empresa
                               and tt_clien_consid.tta_cdn_cliente = movto_tit_acr.cdn_cliente no-error. 
                        if  not avail tt_clien_consid then
                            next movimento.    
                    end.



                    /* Se o acerto de valor for igual a ZERO, isso indica que sua origem Ç VENDOR, sendo assim, esses movimentos devem ser desconsiderados */
                    IF v_log_modul_vendor                = YES AND
                       movto_tit_acr.ind_trans_acr_abrev = "AVMN" /*l_avmn*/  AND
                       movto_tit_acr.val_movto_tit_acr   = 0 THEN
                       NEXT movimento.

                     if movto_tit_acr.ind_trans_acr_abrev = "LIQ" /*l_liq*/   or
                        movto_tit_acr.ind_trans_acr_abrev = "LQRN" /*l_lqrn*/  or
                        movto_tit_acr.ind_trans_acr_abrev = "LQEC" /*l_lqec*/  then do:
                        if movto_tit_acr.dat_liquidac_tit_acr < v_dat_liquidac_inicial or
                           movto_tit_acr.dat_liquidac_tit_acr > v_dat_liquidac_final
                        then next movimento.
                     end.   

                         assign v_cod_refer_contrat_cambio = movto_tit_acr.cod_refer_contrat_cambio.


                     if verifica_program_name('acr235aa':U,30) or 
                        verifica_program_name('acr262za':U,30) 
                     then do:

                          /* Begin_Include: i_selecao_consulta_liquidacao_con */
                          find first tit_acr no-lock
                               where tit_acr.cod_estab       = movto_tit_acr.cod_estab
                                 and tit_acr.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr
                               no-error.
                          if not avail tit_acr
                             then next movimento.

                          if  ((movto_tit_acr.log_liquidac_contra_antecip = no
                            and v_log_mostra_liquidac_pagto               = no)
                             or (movto_tit_acr.log_liquidac_contra_antecip = yes
                            and  v_log_mostra_liquidac_antecip             = no))
                             or (movto_tit_acr.log_movto_estordo           = yes
                            and  v_log_mostra_liquidac_estorn              = no)
                             or (movto_tit_acr.cod_portador < v_cod_portador_ini
                             or  movto_tit_acr.cod_portador > v_cod_portador_fim)
                             or (tit_acr.cod_indic_econ     < v_cod_indic_econ_ini
                             or  tit_acr.cod_indic_econ     > v_cod_indic_econ_fim)
                            then next movimento.
                          /* End_Include: i_selecao_consulta_liquidacao_con */

                     end.
                     else do:     

                          /* Begin_Include: i_selecao_consulta_cliente */
                          find tit_acr of movto_tit_acr no-lock no-error. 
                          if not avail tit_acr then next movimento.

                          if ((movto_tit_acr.log_liquidac_contra_antecip = no                        and 
                              v_log_mostra_liquidac_pagto                = no)                       or  
                             (movto_tit_acr.log_liquidac_contra_antecip  = yes                       and 
                              v_log_mostra_liquidac_antecip              = no))                      or
                             (movto_tit_acr.log_movto_estordo            = yes                       and 
                              v_log_mostra_liquidac_estorn               = no)                       or
                             (not(movto_tit_acr.cod_espec_docto         >= v_cod_espec_docto_inicial and 
                                  movto_tit_acr.cod_espec_docto         <= v_cod_espec_docto_final   and
                                  movto_tit_acr.dat_vencto_tit_acr      >= v_dat_vencto_docto_inic   and
                                  movto_tit_acr.dat_vencto_tit_acr      <= v_dat_vencto_docto_fim))  or
                             (tit_acr.ind_tip_espec_docto                = "Normal" /*l_normal*/               and
                              v_log_mostra_normal                        = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Antecipaá∆o" /*l_antecipacao*/          and
                              v_log_mostra_antecip                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Previs∆o" /*l_previsao*/             and
                              v_log_mostra_prev                          = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Cheques Recebidos" /*l_cheques_recebidos*/    and
                              v_log_mostra_cheq                          = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Nota de DÇbito" /*l_nota_de_debito*/       and
                              v_log_mostra_ndebito                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Nota de CrÇdito" /*l_nota_de_credito*/      and
                              v_log_mostra_nota_cr                       = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Vendor" /*l_vendor*/               and
                              v_log_mostra_docto_vendor                  = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Vendor Repactuado" /*l_vendor_repac*/         and
                              v_log_mostra_docto_vendor_repac            = no)                       or
                             (tit_acr.ind_tip_espec_docto                = "Aviso DÇbito" /*l_aviso_debito*/         and
                              v_log_mostra_aviso_db_1                    = no)                       then next movimento.
                          /* End_Include: i_selecao_consulta_cliente */

                     end.

                         if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                            if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then do:
                               if string(entry(4,tit_acr.cod_livre_1,CHR(24))) < v_cod_proces_export_ini
                               or string(entry(4,tit_acr.cod_livre_1,CHR(24))) > v_cod_proces_export_fim then
                                  next movimento.
                            end.
                            else do:
                               if v_cod_proces_export_ini <> "" /*l_null*/  then do:
                                  if num-entries (tit_acr.cod_livre_1,chr(24)) < 4 then
                                     next movimento.
                               end.   
                            end.               
                         end.        

                         RUN pi-acompanhar IN h-acomp (INPUT "ESRC798b " + "Estab " + tit_Acr.cod_estab + " Data " + STRING(tit_acr.dat_transacao)).
                     create tt_tit_acr_liquidac.
                     assign tt_tit_acr_liquidac.tta_cod_empresa                 = tit_acr.cod_empresa
                            tt_tit_acr_liquidac.tta_cod_espec_docto             = tit_acr.cod_espec_docto
                            tt_tit_acr_liquidac.tta_cod_ser_docto               = tit_acr.cod_ser_docto
                            tt_tit_acr_liquidac.tta_cod_tit_acr                 = tit_acr.cod_tit_acr
                            tt_tit_acr_liquidac.tta_cod_parcela                 = tit_acr.cod_parcela
                            tt_tit_acr_liquidac.tta_cdn_cliente                 = tit_acr.cdn_cliente
                            tt_tit_acr_liquidac.tta_nom_abrev                   = tit_acr.nom_abrev
                            tt_tit_acr_liquidac.tta_cod_estab                   = movto_tit_acr.cod_estab
                            tt_tit_acr_liquidac.tta_dat_transacao               = movto_tit_acr.dat_transacao
                            tt_tit_acr_liquidac.tta_dat_cr_movto_tit_acr        = movto_tit_acr.dat_cr_movto_tit_acr
                            tt_tit_acr_liquidac.tta_ind_trans_acr_abrev         = movto_tit_acr.ind_trans_acr_abrev
                            tt_tit_acr_liquidac.tta_log_movto_estordo           = movto_tit_acr.log_movto_estordo
                            tt_tit_acr_liquidac.tta_log_liquidac_contra_antecip = movto_tit_acr.log_liquidac_contra_antecip
                            tt_tit_acr_liquidac.tta_val_movto_tit_acr           = movto_tit_acr.val_movto_tit_acr
                            tt_tit_acr_liquidac.tta_num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                            tt_tit_acr_liquidac.ttv_rec_movto_tit_acr           = recid(movto_tit_acr)
                            tt_tit_acr_liquidac.tta_ind_espec_docto             = tit_acr.ind_tip_espec_docto
                            tt_tit_acr_liquidac.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
                            tt_tit_acr_liquidac.tta_val_desconto                = movto_tit_acr.val_desconto
                            tt_tit_acr_liquidac.tta_val_abat_tit_acr            = movto_tit_acr.val_abat_tit_acr
                            tt_tit_acr_liquidac.tta_val_juros                   = movto_tit_acr.val_juros
                            tt_tit_acr_liquidac.tta_val_multa_tit_acr           = movto_tit_acr.val_multa_tit_acr.

                     if v_log_funcao_proces_export or v_log_vers_50_6 then do:
                             if num-entries (tit_acr.cod_livre_1,chr(24)) > 3 then
                                 assign tt_tit_acr_liquidac.ttv_cod_proces_export = entry(4,tit_acr.cod_livre_1,chr(24)).
                     end.       

                     find first compl_movto_tit_acr no-lock
                          where compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                            and compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                          no-error.

                     if avail compl_movto_tit_acr  
                        then assign tt_tit_acr_liquidac.tta_cod_indic_econ = compl_movto_tit_acr.cod_indic_econ. 
                        else assign tt_tit_acr_liquidac.tta_cod_indic_econ = tit_acr.cod_indic_econ. 

                     /* ** Gravar esta temp-table somente se o programa for o de contexto do cliente ***/
                     if index(program-name(1), 'prgfin/acr/acr247za.p') <> 0 then do:

                        run pi_criar_tt_matriz_clien_liquidac_acr.
                     end.

                     /* ** Gravar valores base x apresentacao, somente se o programa for o de consulta liquidacao periodo ***/
                     if verifica_program_name('acr235aa':U,30) or 
                        verifica_program_name('acr262za':U,30) then
                        run pi_tit_acr_con_liquidac_grava_valores.
               end.
            end.        
        end.
    end.
END PROCEDURE. /* pi_manter_tempor_liquidac_period_generic_con_dat */
/*****************************************************************************
** Procedure Interna.....: pi_criar_tt_clien_consid
** Descricao.............: pi_criar_tt_clien_consid
** Criado por............: log352036_1
** Criado em.............: 21/05/2015 10:48:23
** Alterado por..........: jeffersonsil
** Alterado em...........: 06/11/2015 11:00:41
*****************************************************************************/
PROCEDURE pi_criar_tt_clien_consid:

    /************************ Parameter Definition Begin ************************/

    def Input param table 
        for tt_param_clien_consid.
    def Input param table 
        for tt_estab.
    def output param table 
        for tt_clien_consid.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_clien_consid
        for tt_clien_consid.
    def buffer btt_estab
        for tt_estab.
    def buffer btt_info_pessoa_fisic
        for tt_info_pessoa_fisic.
    def buffer btt_info_pessoa_jurid
        for tt_info_pessoa_jurid.
    def buffer b_cliente_consid
        for emsuni.cliente.
    def buffer b_cliente_matriz
        for emsuni.cliente.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_clien_matriz
        as Integer
        format ">>>,>>>,>>9":U
        label "Cliente Matriz"
        column-label "Cliente Matriz"
        no-undo.
    def var v_cod_telefone
        as character
        format "x(20)":U
        label "Telefone"
        column-label "Telefone"
        no-undo.
    def var v_cod_unid_federac
        as character
        format "x(3)":U
        label "Unidade Federaá∆o"
        column-label "Unidade Federaá∆o"
        no-undo.
    def var v_log_exist
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_nom_cidade
        as character
        format "x(32)":U
        label "Cidade"
        column-label "Cidade"
        no-undo.
    def var v_num_pessoa_fisic_matriz
        as integer
        format ">>>,>>>,>>9":U
        initial 0
        label "Matriz"
        column-label "Matriz"
        no-undo.
    def var v_num_pessoa_jurid_matriz
        as integer
        format ">>>,>>>,>>9":U
        label "Matriz"
        column-label "Matriz"
        no-undo.


    /************************** Variable Definition End *************************/

    /* *******************************************************************************
     * Limpa temp-tables
     *******************************************************************************/
    for each tt_clien_consid:
        delete tt_clien_consid.
    end.

    for each tt_pessoa_matriz_consid:
        delete tt_pessoa_matriz_consid.
    end.

    /* *******************************************************************************
     * Posiciona no registro de parÉmetros
     *******************************************************************************/
    find first tt_param_clien_consid no-error.
    if not avail tt_param_clien_consid then
        return "NOK" /*l_nok*/ .

    /* *******************************************************************************
     * Melhorar performance
     *******************************************************************************/
    /* ê mais r†pido para o Oracle e SQL Server ir apenas uma vez ao banco para buscar as pessoas
       f°sicas e jur°dicas e armazenar isto em temp-table para ser utilizado posteriormente do que
       ir ao banco a cada iteraá∆o do bloco blk_criar_tt_clien_consid */
    if  not can-find(first tt_info_pessoa_fisic)
    then do:
        for each pessoa_fisic fields(num_pessoa_fisic
                                     nom_cidade
                                     cod_unid_federac
                                     cod_telefone
                                     ) no-lock:
            create tt_info_pessoa_fisic.
            assign tt_info_pessoa_fisic.tta_num_pessoa_fisic = pessoa_fisic.num_pessoa_fisic
                   tt_info_pessoa_fisic.tta_nom_cidade       = pessoa_fisic.nom_cidade
                   tt_info_pessoa_fisic.tta_cod_unid_federac = pessoa_fisic.cod_unid_federac
                   tt_info_pessoa_fisic.tta_cod_telefone     = pessoa_fisic.cod_telefone
                   .
        end.
    end /* if */.

    if  not can-find(first tt_info_pessoa_jurid)
    then do:
        for each pessoa_jurid fields(num_pessoa_jurid
                                     nom_cidade
                                     cod_unid_federac
                                     cod_telefone
                                     num_pessoa_jurid_matriz) no-lock:
            create tt_info_pessoa_jurid.
            assign tt_info_pessoa_jurid.tta_num_pessoa_jurid        = pessoa_jurid.num_pessoa_jurid
                   tt_info_pessoa_jurid.tta_nom_cidade              = pessoa_jurid.nom_cidade
                   tt_info_pessoa_jurid.tta_cod_unid_federac        = pessoa_jurid.cod_unid_federac
                   tt_info_pessoa_jurid.tta_cod_telefone            = pessoa_jurid.cod_telefone
                   tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz.
        end.
    end /* if */.

    /* *******************************************************************************
     * ê feita a busca dos clientes respeitando as faixas de clientes e
     * grupos de clientes, alÇm da verificaá∆o se a empresa do cliente Ç
     * v†lida. Os clientes considerados s∆o armazenados na temp-table tt_clien_consid
     *******************************************************************************/
    if  tt_param_clien_consid.ttv_cdn_cliente_ini = tt_param_clien_consid.ttv_cdn_cliente_fim
    then do:

        blk_criar_tt_clien_consid:
        for  each b_cliente_consid fields(cod_empresa   
                                                                      cdn_cliente
                                                                      num_pessoa    
                                                                      nom_abrev     
                                                                      nom_pessoa    
                                                                      cod_id_feder  
                                                                      cod_grp_clien) no-lock
            where b_cliente_consid.cdn_cliente    = tt_param_clien_consid.ttv_cdn_cliente_ini
              and b_cliente_consid.cod_grp_clien >= tt_param_clien_consid.ttv_cod_grp_clien_ini
              and b_cliente_consid.cod_grp_clien <= tt_param_clien_consid.ttv_cod_grp_clien_fim,
            first tt_estab
            where tt_estab.ttv_cod_empres = b_cliente_consid.cod_empresa:


            /* Begin_Include: i_criar_tt_clien_consid */
            /* Verifica se o cliente j† foi considerado */
            if can-find(first tt_clien_consid
                        where tt_clien_consid.tta_cod_empresa = b_cliente_consid.cod_empresa
                          and tt_clien_consid.tta_cdn_cliente = b_cliente_consid.cdn_cliente) then
                next blk_criar_tt_clien_consid.

            /* Verifica se o n£mero da pessoa do cliente possui valor 0 */
            if  b_cliente_consid.num_pessoa = 0
            then do:
                /* if tt_param_clien_consid.ttv_log_mostra_erro then
                    @cx_message(10917, b_cliente_consid.cdn_cliente). - Alterar mensagem para cliente se necess†rio */
                next blk_criar_tt_clien_consid.
            end /* if */.

            assign v_nom_cidade        = ""
                   v_cod_unid_federac  = ""
                   v_cod_telefone      = ""
                   v_cdn_clien_matriz  = 0
                   .

            /* Caso a pessoa do cliente seja PESSOA F÷SICA (n£meros pares) */
            if  b_cliente_consid.num_pessoa modulo 2 = 0
            then do:

                find first tt_info_pessoa_fisic
                     where tt_info_pessoa_fisic.tta_num_pessoa_fisic = b_cliente_consid.num_pessoa no-error.
                if  avail tt_info_pessoa_fisic
                then do:

                    assign v_nom_cidade        = tt_info_pessoa_fisic.tta_nom_cidade
                           v_cod_unid_federac  = tt_info_pessoa_fisic.tta_cod_unid_federac
                           v_cod_telefone      = tt_info_pessoa_fisic.tta_cod_telefone
                           v_cdn_clien_matriz = b_cliente_consid.cdn_cliente
                           .

                    if b_cliente_consid.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                    or b_cliente_consid.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                        next blk_criar_tt_clien_consid.
                end /* if */.
                else do:
                    if tt_param_clien_consid.ttv_log_mostra_erro then
                        /* Pessoa &1 &2 n∆o est† cadastrada para o &3 &4 ! */
                        run pi_messages (input "show",
                                         input 11736,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            "F°sica" /*l_fisica*/  , b_cliente_consid.num_pessoa,                                "Cliente" /*l_cliente*/ , b_cliente_consid.cdn_cliente)) /*msg_11736*/.
                    next blk_criar_tt_clien_consid.
                end /* else */.
            end /* if */.
            /* Caso a pessoa do cliente seja PESSOA JUR÷DICA (n£meros °mpares) */
            else do:

                find first tt_info_pessoa_jurid
                     where tt_info_pessoa_jurid.tta_num_pessoa_jurid = b_cliente_consid.num_pessoa no-error.
                if  avail tt_info_pessoa_jurid
                then do:

                    assign v_nom_cidade              = tt_info_pessoa_jurid.tta_nom_cidade
                           v_cod_unid_federac        = tt_info_pessoa_jurid.tta_cod_unid_federac
                           v_cod_telefone            = tt_info_pessoa_jurid.tta_cod_telefone
                           v_num_pessoa_jurid_matriz = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz
                           .

                    if  tt_info_pessoa_jurid.tta_num_pessoa_jurid = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz
                    then do:

                        assign v_cdn_clien_matriz = b_cliente_consid.cdn_cliente.

                        if b_cliente_consid.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                        or b_cliente_consid.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                            next blk_criar_tt_clien_consid.

                    end /* if */.
                    else do:

                        for first b_cliente_matriz fields(cod_empresa
                                                          num_pessoa
                                                          cdn_cliente) no-lock
                            where b_cliente_matriz.cod_empresa = b_cliente_consid.cod_empresa
                              and b_cliente_matriz.num_pessoa  = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz:

                            assign v_cdn_clien_matriz = b_cliente_matriz.cdn_cliente.

                            if b_cliente_matriz.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                            or b_cliente_matriz.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                                next blk_criar_tt_clien_consid.

                        end.
                        if not avail b_cliente_matriz then
                            if  tt_param_clien_consid.ttv_cdn_matriz_clien_inic > 0 
                            and tt_param_clien_consid.ttv_cdn_matriz_clien_fim  < 999999999 then
                                next blk_criar_tt_clien_consid.

                    end /* else */.
                end /* if */.
                else do:
                    if tt_param_clien_consid.ttv_log_mostra_erro then
                        /* Pessoa &1 &2 n∆o est† cadastrada para o &3 &4 ! */
                        run pi_messages (input "show",
                                         input 11736,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            "Jur°dica" /*l_juridica*/ , b_cliente_consid.num_pessoa,                                "Cliente" /*l_cliente*/  , b_cliente_consid.cdn_cliente)) /*msg_11736*/.
                    next blk_criar_tt_clien_consid.
                end /* else */.
            end /* else */.

            create tt_clien_consid.
            assign tt_clien_consid.tta_cod_empresa       = b_cliente_consid.cod_empresa
                   tt_clien_consid.tta_cdn_cliente       = b_cliente_consid.cdn_cliente
                   tt_clien_consid.tta_num_pessoa        = b_cliente_consid.num_pessoa
                   tt_clien_consid.tta_nom_abrev         = b_cliente_consid.nom_abrev
                   tt_clien_consid.tta_nom_pessoa        = b_cliente_consid.nom_pessoa
                   tt_clien_consid.tta_cod_id_feder      = b_cliente_consid.cod_id_feder
                   tt_clien_consid.tta_cod_grp_clien     = b_cliente_consid.cod_grp_clien
                   tt_clien_consid.tta_nom_cidade        = v_nom_cidade
                   tt_clien_consid.tta_cod_unid_federac  = v_cod_unid_federac

                   tt_clien_consid.ttv_cdn_clien_matriz  = v_cdn_clien_matriz
                   . 

            /* PCREQ-3851 - Consultas e Relat¢rios de Titulos por Matriz
               Neste ponto, alÇm de considerar o cliente em relaá∆o a faixa, tambÇm busca
               e considera os clientes pertencentes a mesma Matriz do cliente j†
               considerado. */
            if  tt_param_clien_consid.ttv_log_consid_clien_matriz
            then do:

                if  tt_clien_consid.tta_num_pessoa modulo 2 = 0
                then do:

                    /* Pessoa F°sica */
                end /* if */.
                else do:

                    /* Pessoa Jur°dica */

                    if can-find(first tt_pessoa_matriz_consid
                                where tt_pessoa_matriz_consid.ttv_num_pessoa_matriz = v_num_pessoa_jurid_matriz) then
                        next blk_criar_tt_clien_consid.

                    create tt_pessoa_matriz_consid.
                    assign tt_pessoa_matriz_consid.ttv_num_pessoa_matriz = v_num_pessoa_jurid_matriz.

                    blk_cliente_matriz:
                    for each btt_info_pessoa_jurid
                       where btt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz = v_num_pessoa_jurid_matriz,
                        each b_cliente_matriz fields(cod_empresa   
                                                        cdn_cliente
                                                        num_pessoa    
                                                        nom_abrev     
                                                        nom_pessoa    
                                                        cod_id_feder  
                                                        cod_grp_clien) no-lock
                       where b_cliente_matriz.num_pessoa = btt_info_pessoa_jurid.tta_num_pessoa_jurid,
                       first btt_estab
                       where btt_estab.ttv_cod_empres = b_cliente_matriz.cod_empresa:

                        if can-find(first btt_clien_consid
                                    where btt_clien_consid.tta_cod_empresa = b_cliente_matriz.cod_empresa
                                      and btt_clien_consid.tta_cdn_cliente = b_cliente_matriz.cdn_cliente) then
                            next blk_cliente_matriz.

                        create btt_clien_consid.
                        assign btt_clien_consid.tta_cod_empresa       = b_cliente_matriz.cod_empresa
                               btt_clien_consid.tta_cdn_cliente       = b_cliente_matriz.cdn_cliente
                               btt_clien_consid.tta_num_pessoa        = b_cliente_matriz.num_pessoa
                               btt_clien_consid.tta_nom_abrev         = b_cliente_matriz.nom_abrev
                               btt_clien_consid.tta_nom_pessoa        = b_cliente_matriz.nom_pessoa
                               btt_clien_consid.tta_cod_id_feder      = b_cliente_matriz.cod_id_feder
                               btt_clien_consid.tta_cod_grp_clien     = b_cliente_matriz.cod_grp_clien
                               btt_clien_consid.tta_nom_cidade        = btt_info_pessoa_jurid.tta_nom_cidade
                               btt_clien_consid.tta_cod_unid_federac  = btt_info_pessoa_jurid.tta_cod_unid_federac

                               btt_clien_consid.ttv_cdn_clien_matriz  = tt_clien_consid.ttv_cdn_clien_matriz
                               . 

                    end /* for blk_cliente_matriz */.
                end /* else */.
            end /* if */.
            /* End_Include: i_criar_tt_clien_consid */


        end /* for blk_criar_tt_clien_consid */.
    end /* if */.
    else do:

        blk_criar_tt_clien_consid:
        for each b_cliente_consid fields(cod_empresa   
                                            cdn_cliente
                                            num_pessoa    
                                            nom_abrev     
                                            nom_pessoa    
                                            cod_id_feder  
                                            cod_grp_clien) no-lock
           where b_cliente_consid.cdn_cliente   >= tt_param_clien_consid.ttv_cdn_cliente_ini
             and b_cliente_consid.cdn_cliente   <= tt_param_clien_consid.ttv_cdn_cliente_fim
             and b_cliente_consid.cod_grp_clien >= tt_param_clien_consid.ttv_cod_grp_clien_ini
             and b_cliente_consid.cod_grp_clien <= tt_param_clien_consid.ttv_cod_grp_clien_fim,
           first tt_estab
           where tt_estab.ttv_cod_empres = b_cliente_consid.cod_empresa:


            /* Begin_Include: i_criar_tt_clien_consid */
            /* Verifica se o cliente j† foi considerado */
            if can-find(first tt_clien_consid
                        where tt_clien_consid.tta_cod_empresa = b_cliente_consid.cod_empresa
                          and tt_clien_consid.tta_cdn_cliente = b_cliente_consid.cdn_cliente) then
                next blk_criar_tt_clien_consid.

            /* Verifica se o n£mero da pessoa do cliente possui valor 0 */
            if  b_cliente_consid.num_pessoa = 0
            then do:
                /* if tt_param_clien_consid.ttv_log_mostra_erro then
                    @cx_message(10917, b_cliente_consid.cdn_cliente). - Alterar mensagem para cliente se necess†rio */
                next blk_criar_tt_clien_consid.
            end /* if */.

            assign v_nom_cidade        = ""
                   v_cod_unid_federac  = ""
                   v_cod_telefone      = ""
                   v_cdn_clien_matriz  = 0
                   .

            /* Caso a pessoa do cliente seja PESSOA F÷SICA (n£meros pares) */
            if  b_cliente_consid.num_pessoa modulo 2 = 0
            then do:

                find first tt_info_pessoa_fisic
                     where tt_info_pessoa_fisic.tta_num_pessoa_fisic = b_cliente_consid.num_pessoa no-error.
                if  avail tt_info_pessoa_fisic
                then do:

                    assign v_nom_cidade        = tt_info_pessoa_fisic.tta_nom_cidade
                           v_cod_unid_federac  = tt_info_pessoa_fisic.tta_cod_unid_federac
                           v_cod_telefone      = tt_info_pessoa_fisic.tta_cod_telefone
                           v_cdn_clien_matriz = b_cliente_consid.cdn_cliente
                           .

                    /* Verifica se o cliente consta na faixa de matriz */
                    if b_cliente_consid.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                    or b_cliente_consid.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                        next blk_criar_tt_clien_consid.
                end /* if */.
                else do:
                    if tt_param_clien_consid.ttv_log_mostra_erro then
                        /* Pessoa &1 &2 n∆o est† cadastrada para o &3 &4 ! */
                        run pi_messages (input "show",
                                         input 11736,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            "F°sica" /*l_fisica*/  , b_cliente_consid.num_pessoa,                                "Cliente" /*l_cliente*/ , b_cliente_consid.cdn_cliente)) /*msg_11736*/.
                    next blk_criar_tt_clien_consid.
                end /* else */.
            end /* if */.
            /* Caso a pessoa do cliente seja PESSOA JUR÷DICA (n£meros °mpares) */
            else do:

                find first tt_info_pessoa_jurid
                     where tt_info_pessoa_jurid.tta_num_pessoa_jurid = b_cliente_consid.num_pessoa no-error.
                if  avail tt_info_pessoa_jurid
                then do:

                    assign v_nom_cidade              = tt_info_pessoa_jurid.tta_nom_cidade
                           v_cod_unid_federac        = tt_info_pessoa_jurid.tta_cod_unid_federac
                           v_cod_telefone            = tt_info_pessoa_jurid.tta_cod_telefone
                           v_num_pessoa_jurid_matriz = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz
                           .

                    if  tt_info_pessoa_jurid.tta_num_pessoa_jurid = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz
                    then do:

                        assign v_cdn_clien_matriz = b_cliente_consid.cdn_cliente.

                        if b_cliente_consid.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                        or b_cliente_consid.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                            next blk_criar_tt_clien_consid.

                    end /* if */.
                    else do:

                        for first b_cliente_matriz fields(cod_empresa
                                                          num_pessoa
                                                          cdn_cliente) no-lock
                            where b_cliente_matriz.cod_empresa = b_cliente_consid.cod_empresa
                              and b_cliente_matriz.num_pessoa  = tt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz:

                            assign v_cdn_clien_matriz = b_cliente_matriz.cdn_cliente.

                            if b_cliente_matriz.cdn_cliente < tt_param_clien_consid.ttv_cdn_matriz_clien_inic
                            or b_cliente_matriz.cdn_cliente > tt_param_clien_consid.ttv_cdn_matriz_clien_fim then
                                next blk_criar_tt_clien_consid.

                        end.
                        if not avail b_cliente_matriz then
                            if  tt_param_clien_consid.ttv_cdn_matriz_clien_inic > 0 
                            and tt_param_clien_consid.ttv_cdn_matriz_clien_fim  < 999999999 then
                                next blk_criar_tt_clien_consid.

                    end /* else */.
                end /* if */.
                else do:
                    if tt_param_clien_consid.ttv_log_mostra_erro then
                        /* Pessoa &1 &2 n∆o est† cadastrada para o &3 &4 ! */
                        run pi_messages (input "show",
                                         input 11736,
                                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                            "Jur°dica" /*l_juridica*/ , b_cliente_consid.num_pessoa,                                "Cliente" /*l_cliente*/  , b_cliente_consid.cdn_cliente)) /*msg_11736*/.
                    next blk_criar_tt_clien_consid.
                end /* else */.
            end /* else */.

            create tt_clien_consid.
            assign tt_clien_consid.tta_cod_empresa       = b_cliente_consid.cod_empresa
                   tt_clien_consid.tta_cdn_cliente       = b_cliente_consid.cdn_cliente
                   tt_clien_consid.tta_num_pessoa        = b_cliente_consid.num_pessoa
                   tt_clien_consid.tta_nom_abrev         = b_cliente_consid.nom_abrev
                   tt_clien_consid.tta_nom_pessoa        = b_cliente_consid.nom_pessoa
                   tt_clien_consid.tta_cod_id_feder      = b_cliente_consid.cod_id_feder
                   tt_clien_consid.tta_cod_grp_clien     = b_cliente_consid.cod_grp_clien
                   tt_clien_consid.tta_nom_cidade        = v_nom_cidade
                   tt_clien_consid.tta_cod_unid_federac  = v_cod_unid_federac

                   tt_clien_consid.ttv_cdn_clien_matriz  = v_cdn_clien_matriz
                   . 

            /* PCREQ-3851 - Consultas e Relat¢rios de Titulos por Matriz
               Neste ponto, alÇm de considerar o cliente em relaá∆o a faixa, tambÇm busca
               e considera os clientes pertencentes a mesma Matriz do cliente j†
               considerado. */
            if  tt_param_clien_consid.ttv_log_consid_clien_matriz
            then do:

                if  tt_clien_consid.tta_num_pessoa modulo 2 = 0
                then do:

                    /* Pessoa F°sica */
                end /* if */.
                else do:

                    /* Pessoa Jur°dica */

                    if can-find(first tt_pessoa_matriz_consid
                                where tt_pessoa_matriz_consid.ttv_num_pessoa_matriz = v_num_pessoa_jurid_matriz) then
                        next blk_criar_tt_clien_consid.

                    create tt_pessoa_matriz_consid.
                    assign tt_pessoa_matriz_consid.ttv_num_pessoa_matriz = v_num_pessoa_jurid_matriz.

                    blk_cliente_matriz:
                    for each btt_info_pessoa_jurid
                       where btt_info_pessoa_jurid.tta_num_pessoa_jurid_matriz = v_num_pessoa_jurid_matriz,
                        each b_cliente_matriz fields(cod_empresa   
                                                        cdn_cliente
                                                        num_pessoa    
                                                        nom_abrev     
                                                        nom_pessoa    
                                                        cod_id_feder  
                                                        cod_grp_clien) no-lock
                       where b_cliente_matriz.num_pessoa = btt_info_pessoa_jurid.tta_num_pessoa_jurid,
                       first btt_estab
                       where btt_estab.ttv_cod_empres = b_cliente_matriz.cod_empresa:

                        if can-find(first btt_clien_consid
                                    where btt_clien_consid.tta_cod_empresa = b_cliente_matriz.cod_empresa
                                      and btt_clien_consid.tta_cdn_cliente = b_cliente_matriz.cdn_cliente) then
                            next blk_cliente_matriz.

                        create btt_clien_consid.
                        assign btt_clien_consid.tta_cod_empresa       = b_cliente_matriz.cod_empresa
                               btt_clien_consid.tta_cdn_cliente       = b_cliente_matriz.cdn_cliente
                               btt_clien_consid.tta_num_pessoa        = b_cliente_matriz.num_pessoa
                               btt_clien_consid.tta_nom_abrev         = b_cliente_matriz.nom_abrev
                               btt_clien_consid.tta_nom_pessoa        = b_cliente_matriz.nom_pessoa
                               btt_clien_consid.tta_cod_id_feder      = b_cliente_matriz.cod_id_feder
                               btt_clien_consid.tta_cod_grp_clien     = b_cliente_matriz.cod_grp_clien
                               btt_clien_consid.tta_nom_cidade        = btt_info_pessoa_jurid.tta_nom_cidade
                               btt_clien_consid.tta_cod_unid_federac  = btt_info_pessoa_jurid.tta_cod_unid_federac

                               btt_clien_consid.ttv_cdn_clien_matriz  = tt_clien_consid.ttv_cdn_clien_matriz
                               . 

                    end /* for blk_cliente_matriz */.
                end /* else */.
            end /* if */.
            /* End_Include: i_criar_tt_clien_consid */


        end /* for blk_criar_tt_clien_consid */.
    end /* else */.   

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_criar_tt_clien_consid */

