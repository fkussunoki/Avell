def temp-table tt_integr_apb_antecip_pef_pend no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Referˆncia" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Cont bil" column-label "Natureza Cont bil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    index tt_antcppfp_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_antcppfp_tip_refer           
          tta_cod_empresa                  ascending
          tta_ind_tip_refer                ascending
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_recid                        
          ttv_rec_antecip_pef_pend         ascending.

