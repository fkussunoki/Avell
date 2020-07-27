def temp-table tt_param_titulos_aberto_clien no-undo
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field ttv_log_ret_docto                as logical format "Sim/N’o" initial no label "Retorna T­tulos" column-label "Retorna T­tulos"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    field ttv_log_vencid                   as logical format "Sim/N’o" initial yes label "Vencidos" column-label "Vencidos"
    field ttv_log_avencer                  as logical format "Sim/N’o" initial yes label "A Vencer" column-label "A Vencer"
    field ttv_log_antecip                  as logical format "Sim/N’o" initial yes label "Antecipa»’o" column-label "Antecipa»’o"
    field tta_des_sig_indic_econ           as character format "x(06)" label "Sigla" column-label "Sigla"
    .

def temp-table tt_titulos_aberto_clien no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T­tulo" column-label "Vl Original T­tulo"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T­tulo" column-label "Saldo T­tulo"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_val_origin_indic_econ        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Moeda T­tulo"
    field ttv_val_sdo_indic_econ           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Saldo Moeda T­tulo"
    field ttv_num_situacao                 as integer format ">9"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    .

def temp-table tt_tot_tit_aberto_faixa_vencto no-undo
    field ttv_num_situacao                 as integer format ">9"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    field ttv_val_sdo_faixa_vencto         as decimal format ">>>,>>>,>>9.99" decimals 2
    index tt_index                        
          ttv_num_situacao                 ascending
          ttv_num_faixa_vencto             ascending
    .

def temp-table tt_tot_tit_aberto_period no-undo
    field ttv_val_sdo_vencid               as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_avencer              as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_antecip              as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    .

def temp-table tt_erro_msg no-undo
    field ttv_num_msg_erro                 as integer format ">>>>>>9" label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_help_erro                as character format "x(200)"
    index tt_num_erro                     
          ttv_num_msg_erro                 ascending
    .


DEFINE VAR h-prog AS HANDLE.

RUN prgfin/acr/acr520za.r PERSISTENT SET h-prog.

FOR EACH clien_financ NO-LOCK USE-INDEX clnfnnc_id:

    FIND LAST estatis_clien NO-LOCK WHERE estatis_clien.cod_empresa = clien_financ.cod_empresa
                                    AND   estatis_clien.cdn_cliente = clien_financ.cdn_cliente
                                    AND   estatis_clien.val_sdo_clien > 0 NO-ERROR.

    IF AVAIL estatis_clien THEN DO:
        

        CREATE tt_param_titulos_aberto_clien.
        ASSIGN tt_param_titulos_aberto_clien.tta_cdn_cliente = estatis_clien.cdn_cliente
               tt_param_titulos_aberto_clien.tta_dat_emis_docto = 01/01/2010
               tt_param_titulos_aberto_clien.tta_dat_vencto_tit_acr = 12/31/9999
               tt_param_titulos_aberto_clien.ttv_log_ret_docto = YES
               tt_param_titulos_aberto_clien.ttv_num_faixa_vencto = 1
               tt_param_titulos_aberto_clien.ttv_log_vencid = YES
               tt_param_titulos_aberto_clien.ttv_log_avencer  = YES
               tt_param_titulos_aberto_clien.ttv_log_antecip  = no.


               
               


        RUN pi_main_titulos_abertos_cliente_01 IN h-prog(INPUT-OUTPUT TABLE tt_param_titulos_aberto_clien,
                                                         OUTPUT TABLE tt_tot_tit_aberto_period,
                                                         OUTPUT TABLE tt_tot_tit_aberto_faixa_vencto,
                                                         OUTPUT TABLE  tt_titulos_aberto_clien,
                                                         OUTPUT TABLE tt_erro_msg).



    END.



END.


FOR EACH tt_titulos_aberto_clien:

    disp tt_titulos_aberto_clien WITH 1 COL WIDTH 600.
END.
