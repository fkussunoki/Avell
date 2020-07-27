def temp-table tt_movto_comis_repres_geracao2 no-undo
    field tta_cod_empresa as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_repres as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_cod_estab as character format "x(3)" label "Estabelecimento" column-label "Estab"                  
    field tta_cod_espec_docto as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"        
    field tta_cod_ser_docto as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"              
    field tta_cod_tit_acr as character format "x(10)" label "T¡tulo" column-label "T¡tulo"                       
    field tta_cod_parcela as character format "x(02)" label "Parcela" column-label "Parc"                        
    field tta_cod_refer as character format "x(10)" label "Referˆncia" column-label "Referˆncia"                 
    field tta_cod_usuario as character format "x(12)" label "Usu rio" column-label "Usu rio"                     
    field tta_dat_transacao as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac" 
    field tta_ind_trans_acr as character format "X(29)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
    field tta_ind_sit_movto_comis as character format "X(18)" initial "Liberado" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_ind_tip_movto as character format "X(20)" label "Tipo Movimento" column-label "Tipo Movimento"             
    field tta_ind_natur_lancto_ctbl as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"    
    field tta_val_base_calc_comis as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_val_movto_comis as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Movimento" column-label "Valor Movimento"
    field tta_num_id_tit_acr as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"                
    field tta_des_histor_movto_comis as character format "x(40)" label "Hist¢rico" column-label "Hist¢rico"                                     
    field tta_num_id_movto_tit_acr as integer format "9999999999" initial 0 label "Token Movto Tit ACR" column-label "Token Movto Tit ACR"      
    field tta_ind_trans_comis as character format "X(35)" label "Transa‡Æo ComissÆo" column-label "Transa‡Æo ComissÆo"                          
    field tta_cod_unid_negoc as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"                                              
    field ttv_log_consid_movto_pagto as logical format "Sim/NÆo" initial yes                                                                    
    field tta_dat_emis_docto as date format "99/99/9999" initial today label "Data EmissÆo" column-label "Dt EmissÆo"                           
    field tta_cdn_motiv_movto_comis as Integer format ">>>9" initial 0 label "C¢digo Motiv Movto" column-label "C¢digo Motiv"                   
    index tt_id_movto_comis                                                                                                                     
          tta_cod_empresa ascending                                                                                                             
          tta_cdn_repres ascending
    .

DEF TEMP-TABLE tt_movto_comis_erro NO-UNDO 
    FIELD tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    FIELD tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    FIELD ttv_num_seq_movto_comis_erro     as integer format ">>>>,>>9" label "Num Sequ¼ncia" column-label "Num Sequ¼ncia"
    FIELD ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    FIELD ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    INDEX tt_id_movto                     
          tta_cod_empresa                  ascending
          tta_cdn_repres                   ascending
          ttv_num_seq_movto_comis_erro     ascending.
