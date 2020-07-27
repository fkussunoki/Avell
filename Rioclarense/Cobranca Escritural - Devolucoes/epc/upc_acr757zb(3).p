
/***********************************************************************
**  Programa..: epc_acr757zb.p
**  Autor.....: Flavio Kussunoki
**  Data......: 06/02/2018
**  Descricao.: EPC desenvolvida para a CCRC.
**  Objetivo:  Nativamente o sistema nao permite o envio de duas ocorrencias
**  de abatimento por dia. A Rioclarense tem diversos casos de vinculacoes de
**  devolucoes.
**  A EPC acumula os valores da ocorrencia numa unica linha. Deixa, no entanto,
**  uma ocorencia para ser enviada no dia seguinte.
**  Para evitar duplicidade, o programa zera a segunda remessa, caso esta venha
**  a ser enviada.
**  VersÆo....: 001 - 00/00/2010
**                  Desenvolvimento Programa
************************************************************************/
define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.


    def shared temp-table tt_tit_acr_selec_cobr no-undo
        field ttv_rec_tit_acr                  as recid format ">>>>>>9"
        field ttv_rec_movto_ocor_bcia          as recid format ">>>>>>9" initial ?
        field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
        field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
        field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
        field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
        field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
        field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
        field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
        field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
        field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
        field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
        field tta_ind_trans_acr                as character format "X(29)" initial "Implanta‡Æo" label "Transa‡Æo" column-label "Transa‡Æo"
        field tta_ind_tip_ocor_bcia            as character format "x(40)" label "Tipo Ocor Bancia" column-label "Tipo Ocor Bancia"
        field ttv_log_selec_tit_acr            as logical format "Sim/NÆo" initial no label "Envia" column-label "Envia"
        field tta_log_envdo_edi                as logical format "Sim/Nao" initial no label "Enviada" column-label "Enviada"
        field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
        field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
        field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
        field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
        field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
        field ttv_val_sdo_tit_acr              as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
        field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
        field tta_cod_conven_bcio              as character format "x(20)" label "Convˆnio Banc rio" column-label "Convˆnio Banc rio"
        field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
        field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
        index tt_portador                     
              tta_cod_estab                    ascending
              tta_cod_portador                 ascending
              tta_cod_cart_bcia                ascending
        index tt_titulo_id                     is primary unique
              tta_cod_portador                 ascending
              tta_ind_trans_acr                ascending
              tta_cod_estab                    ascending
              tta_cod_espec_docto              ascending
              tta_cod_ser_docto                ascending
              tta_cod_tit_acr                  ascending
              tta_cod_parcela                  ascending
              tta_num_id_movto_tit_acr         ascending
              ttv_rec_movto_ocor_bcia          ascending.
        

DEFINE INPUT        PARAMETER p-ind-event AS  CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt_epc.

DEFINE BUFFER forma_pagto FOR emsfin.forma_pagto.
DEF VAR v_valor AS DEC FORMAT "->>>,>>>,>>>,>>>.99".

/* IF p-ind-event = "modificainstrucao" THEN DO: */

/*                                                                                                                                                               */
/*                                                                                                                                                               */
/*     FOR EACH tt_tit_acr_selec_cobr WHERE tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Concessao Abatimento" BREAK BY tt_tit_acr_selec_cobr.ttv_rec_tit_acr: */
/*                                                                                                                                                               */
/*                                                                                                                                                               */
/*                                                                                                                                                               */
/*         IF FIRST-OF(tt_tit_acr_selec_cobr.ttv_rec_tit_acr) THEN NEXT.                                                                                         */
/*                                                                                                                                                               */
/*             ELSE DO:                                                                                                                                          */
/*                                                                                                                                                               */
/*                                                                                                                                                               */
/*                                                                                                                                                               */
/*             ASSIGN tt_tit_acr_selec_cobr.tta_log_envdo_edi = NO                                                                                               */
/*                    tt_tit_acr_selec_cobr.ttv_log_selec_tit_acr = NO.                                                                                          */
/*         END.                                                                                                                                                  */
/*                                                                                                                                                               */
/*     END.                                                                                                                                                      */
/*                                                                                                                                                               */
/* END.         
                                                                                                                                                 
                                                                                                                                                 */


/* MESSAGE p-ind-event VIEW-AS ALERT-BOX.  */
IF p-ind-event = 'VlAbatEspec' THEN DO:


  

    FIND FIRST tt_epc NO-ERROR.

    FIND FIRST tt_tit_acr_selec_cobr WHERE string(recid(tt_tit_acr_selec_cobr)) =  tt_epc.val_parameter
                                     AND   tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Concessao Abatimento" NO-ERROR.
                                     



/*     FOR EACH tt_tit_acr_selec_cobr WHERE tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Concessao Abatimento": */

        
        FIND FIRST movto_tit_acr NO-LOCK WHERE recid(movto_tit_acr) = tt_tit_acr_selec_cobr.ttv_rec_movto_tit_acr
                                         AND  movto_tit_acr.ind_trans_acr = "Liquida‡Æo"
                                         AND  movto_tit_acr.cod_estab =    tt_tit_acr_selec_cobr.tta_cod_estab
                                         AND  movto_tit_acr.cod_espec_docto = tt_tit_acr_selec_cobr.tta_cod_espec_docto
                                         AND  movto_tit_acr.dat_transacao   = tt_tit_acr_selec_cobr.tta_dat_transacao 
                                         AND  movto_tit_acr.dat_vencto_tit_acr = tt_tit_acr_selec_cobr.tta_dat_vencto_tit_acr NO-ERROR.
                    

        IF CAN-FIND(movto_ocor_bcia NO-LOCK WHERE movto_ocor_bcia.num_id_tit_acr = movto_tit_acr.num_id_tit_acr
                                           AND   movto_ocor_bcia.ind_tip_ocor_bcia = "Concessao Abatimento"
                                           AND   movto_ocor_bcia.log_movto_envdo_bco = YES
                                           AND   movto_ocor_bcia.cod_estab       = movto_tit_acr.cod_estab
                                           AND   movto_ocor_bcia.cod_portador    = movto_tit_acr.cod_portador
                                           AND   movto_ocor_bcia.cod_cart_bcia   = movto_tit_acr.cod_cart_bcia
                                           and   movto_ocor_bcia.dat_movto_ocor_bcia >= movto_tit_acr.dat_transacao)
                                           THEN DO:
                                               

            CREATE tt_epc.
            ASSIGN tt_epc.cod_event     = 'VlAbatEspec'   
                   tt_epc.cod_parameter = 'VlAbatEspec-NOVO'
                   tt_epc.val_parameter = STRING(0).

                                           END.

        

        ELSE DO:
            

        FOR EACH movto_ocor_bcia NO-LOCK WHERE movto_ocor_bcia.num_id_tit_acr = movto_tit_acr.num_id_tit_acr
                                         AND   movto_ocor_bcia.ind_tip_ocor_bcia = "Concessao Abatimento"
                                         AND   movto_ocor_bcia.cod_estab       = movto_tit_acr.cod_estab
                                         and   movto_ocor_bcia.dat_movto_ocor_bcia >= movto_tit_acr.dat_transacao
                                         

                                         BREAK BY movto_ocor_bcia.dat_movto_ocor_bcia:

            IF movto_ocor_bcia.log_movto_envdo_bco = YES THEN RETURN.
/*    */
            ACCUMULATE movto_ocor_bcia.val_movto_ocor_bcia (SUB-TOTAL BY movto_ocor_bcia.dat_movto_ocor_bcia).


            IF LAST-OF(movto_ocor_bcia.dat_movto_ocor_bcia) THEN DO:



/*         ASSIGN v_valor = v_valor +  movto_ocor_bcia.val_movto_ocor_bcia.  */

            CREATE tt_epc.
            ASSIGN tt_epc.cod_event     = 'VlAbatEspec'
                   tt_epc.cod_parameter = 'VlAbatEspec-NOVO'
                   tt_epc.val_parameter = STRING(ACCUM SUB-TOTAL BY movto_ocor_bcia.dat_movto_ocor_bcia movto_ocor_bcia.val_movto_ocor_bcia).
         END.   
       END.

     END.
    END.


/*         CREATE tt_epc.                                   */
/*         ASSIGN tt_epc.cod_event     = 'VlAbatEspec'      */
/*                tt_epc.cod_parameter = 'VlAbatEspec-NOVO' */
/*                tt_epc.val_parameter = STRING(v_valor).   */
    



/*       FOR EACH tt_tit_acr_selec_cobr WHERE tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Concessao Abatimento" BREAK BY tt_tit_acr_selec_cobr.ttv_rec_tit_acr: */
/*           ASSIGN tt_tit_acr_selec_cobr.tta_log_envdo_edi = YES                                                                                                  */
/*                  tt_tit_acr_selec_cobr.ttv_log_selec_tit_acr = YES.                                                                                             */
/*     END.                                                                                                                                                        */
/* FOR EACH tt-epc:                                                                */
/*     MESSAGE "tt-epc.cod-event -> " tt-epc.cod-event SKIP                        */
/*             "tt-epc.cod-parameter -> " tt-epc.cod-parameter SKIP                */
/*             "tt-epc.val-parameter -> " tt-epc.val-parameter VIEW-AS ALERT-BOX.  */
/* END.                                                                            */

/* IF p-ind-event = "Atualiza Forma Pagto" THEN DO:                                                                   */
/*                                                                                                                    */
/*     FIND FIRST tt-epc                                                                                              */
/*          WHERE tt-epc.cod-event     = p-ind-event                                                                  */
/*            AND tt-epc.cod-parameter = "recid_item_bord" NO-ERROR.                                                  */
/*     IF NOT AVAIL tt-epc THEN                                                                                       */
/*         RETURN.                                                                                                    */
/*                                                                                                                    */
/*     FIND FIRST item_bord_ap WHERE RECID(item_bord_ap) = INTEGER(tt-epc.val-parameter) NO-LOCK NO-ERROR.            */
/*     IF NOT AVAIL item_bord_ap THEN                                                                                 */
/*         RETURN.                                                                                                    */
/*                                                                                                                    */
/*     FIND FIRST forma_pagto OF item_bord_ap NO-LOCK NO-ERROR.                                                       */
/*     IF NOT AVAIL forma_pagto THEN                                                                                  */
/*         RETURN.                                                                                                    */
/*                                                                                                                    */
/*     IF forma_pagto.ind_tip_forma_pagto = "Boleto" THEN DO:                                                         */
/*         FIND FIRST tit_ap OF item_bord_ap NO-LOCK NO-ERROR.                                                        */
/*         IF NOT AVAIL tit_ap THEN                                                                                   */
/*             RETURN.                                                                                                */
/*                                                                                                                    */
/*         IF LENGTH(TRIM(tit_ap.cb4_tit_ap_bco_cobdor)) = 48 THEN DO: /* Codigo de barras de consumo */              */
/*             CREATE tt-epc.                                                                                         */
/*             ASSIGN tt-epc.cod-event     = p-ind-event                                                              */
/*                    tt-epc.cod-parameter = "Retorno Forma Pagto"                                                    */
/*                    tt-epc.val-parameter = forma_pagto.ind_tip_forma_pagto + "Consumo" /* cod_id_bloco_msg_edi */   */
/*                                           + CHR(10) + "13".                           /* cdn_tip_forma_pagto */    */
/*         END.                                                                                                       */
/*     END.                                                                                                           */
/*     IF forma_pagto.ind_tip_forma_pagto = "Cr‚dito Conta Corrente" THEN DO:                                         */
/*                                                                                                                    */
/*         FIND FIRST forma_pagto_bco OF forma_pagto NO-LOCK                                                          */
/*              WHERE forma_pagto_bco.cod_banco EQ "001" NO-ERROR.                                                    */
/*                                                                                                                    */
/*         IF AVAIL forma_pagto_bco AND                                                                               */
/*            forma_pagto_bco.cod_forma_pagto_bco EQ "05" THEN DO: /* Cr‚dito Conta Poupan‡a - 001-Banco do Brasil */ */
/*             CREATE tt-epc.                                                                                         */
/*             ASSIGN tt-epc.cod-event     = p-ind-event                                                              */
/*                    tt-epc.cod-parameter = "Retorno Forma Pagto"                                                    */
/*                    tt-epc.val-parameter = "Cr‚dito C/P"          /* cod_id_bloco_msg_edi */                        */
/*                                           + CHR(10) + "05".      /* cdn_tip_forma_pagto */                         */
/*         END.                                                                                                       */
/*     END.                                                                                                           */
/*                                                                                                                    */
/* END.                                                                                                               */
/* RETURN "OK".                                                                                                       */


/*     if  v_nom_prog_upc <> ''                                                                                               */
/*     then do:                                                                                                               */
/*         for each tt_epc:                                                                                                   */
/*             delete tt_epc.                                                                                                 */
/*         end.                                                                                                               */
/*                                                                                                                            */
/*         create tt_epc.                                                                                                     */
/*         assign tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                               */
/*                tt_epc.cod_parameter = 'recid_item_bord'                                                                    */
/*                tt_epc.val_parameter = string(recid(item_bord_ap)).                                                         */
/*         create tt_epc.                                                                                                     */
/*         assign tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                               */
/*                tt_epc.cod_parameter = 'recid_forma_bco'                                                                    */
/*                tt_epc.val_parameter = string(recid(forma_pagto_bco)).                                                      */
/*                                                                                                                            */
/*         /* Begin_Include: i_exec_program_epc_custom */                                                                     */
/*         if  v_nom_prog_upc <> '' then                                                                                      */
/*         do:                                                                                                                */
/*             run value(v_nom_prog_upc) (input 'Atualiza Forma Pagto',                                                       */
/*                                        input-output table tt_epc).                                                         */
/*         end.                                                                                                               */
/*         /* End_Include: i_exec_program_epc_custom */                                                                       */
/*                                                                                                                            */
/*         if  return-value = "OK" /*l_ok*/                                                                                   */
/*         then do:                                                                                                           */
/*             find first tt_epc no-lock                                                                                      */
/*                 where tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                        */
/*                 and   tt_epc.cod_parameter = 'Retorno Forma Pagto'                                                         */
/*                 no-error.                                                                                                  */
/*             if avail tt_epc and                                                                                            */
/*                tt_epc.val_parameter <> ""  and                                                                             */
/*                num-entries(tt_epc.val_parameter,chr(10)) >= 2 then                                                         */
/*                assign tt_detail_msg_pagto_edi_mpf.ttv_cod_id_bloco_msg_edi = entry(1,tt_epc.val_parameter, chr(10))        */
/*                       tt_detail_msg_pagto_edi_mpf.ttv_cdn_tip_forma_pagto  = int(entry(2,tt_epc.val_parameter, chr(10))).  */
/*         end.                                                                                                               */
/*         for each tt_epc:                                                                                                   */
/*             delete tt_epc.                                                                                                 */
/*         end.                                                                                                               */
/*     end.                                                                                                                   */
/*                                                                                                                            */

/* _UIB-CODE-BLOCK-END */



