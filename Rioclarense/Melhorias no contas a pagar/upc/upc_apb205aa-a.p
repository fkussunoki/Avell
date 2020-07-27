/*******************************************************************************
**  Programa : upc_apb205aa.p
**  Objetivo : Implementar campos espec°ficos na Consulta de T°tulos em Aberto
**  Data     : 29/11/2017
**  Autor    : Leandro Okoti
*******************************************************************************/
DEFINE INPUT PARAMETER i-tipo AS INTEGER NO-UNDO.

/*** Definiá∆o de Vari†veis Globais ***/
DEFINE NEW GLOBAL SHARED VAR whBrTable_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_apb205aa     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_apb205aa AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColSituacao_apb205aa    As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_apb205aa     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_apb205aa         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_apb205aa    AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_corp_apb205aa           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_corp_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_corp_apb205aa    AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColSituacao_corp_apb205aa       As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_corp_apb205aa        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_corp_apb205aa            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_corp_apb205aa       AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_un_apb205aa             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_un_apb205aa      AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColSituacao_un_apb205aa         As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_un_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_un_apb205aa              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_un_apb205aa         AS WIDGET-HANDLE NO-UNDO.





DEFINE NEW GLOBAL SHARED VAR whBrTable_un_corp_apb205aa             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whQryBrTable_un_corp_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whColAutorizacao_un_corp_apb205aa      AS WIDGET-HANDLE NO-UNDO.
DEFINE New Global Shared Var WhColSituacao_un_corp_apb205aa         As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR WhColBordero_un_corp_apb205aa          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColDDA_un_corp_apb205aa              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR WhColPortador_un_corp_apb205aa         AS WIDGET-HANDLE NO-UNDO.


DEFINE VAR h_buffer_movto AS HANDLE NO-UNDO.
DEFINE VAR c-narrativa    AS CHAR   NO-UNDO INIT ''.
DEFINE VAR c-dda          AS char   NO-UNDO INIT 'Nao'.
define var c-situacao     as char   NO-UNDO INIT ''.
define var c-bordero      as char   NO-UNDO INIT ''.
define var c-portador     as char   NO-UNDO INIT ''.

/* "br_tit_acr_em_aberto_un"      */
/* "br_tit_acr_em_aberto_un_corp" */


/* PREENCHER NOVA COLUNA "AUTORIZAÄ«O" */
CASE i-tipo:

    WHEN 1 THEN DO: /* "br_tit_ap_em_aberto" */

        IF VALID-HANDLE (whQryBrTable_apb205aa) AND
           VALID-HANDLE(whColAutorizacao_apb205aa) THEN DO:

            whQryBrTable_apb205aa:GET-CURRENT().
            
            ASSIGN h_buffer_movto = whQryBrTable_apb205aa:GET-BUFFER-HANDLE(1).

            /* BUSCA A DUPLICATA VINCULADA AO TITULO DE A PAGAR */
            FOR EACH dupli-apagar WHERE dupli-apagar.serie-docto  = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                                    AND dupli-apagar.nro-docto    = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_tit_ap"):BUFFER-VALUE)
                                    AND dupli-apagar.cod-emitente = INT(h_buffer_movto:BUFFER-FIELD("tta_cdn_fornecedor"):BUFFER-VALUE)
                                    AND dupli-apagar.parcela      = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE) NO-LOCK,
                FIRST docum-est OF dupli-apagar NO-LOCK,
                FIRST item-doc-est OF docum-est NO-LOCK,
                FIRST estabelec OF docum-est NO-LOCK.

                /* BUSCA PELO AUTORIZADOR, CASO N«O SEJA ENCONTRADO, ê EXIBIDO TODA A NARRATIVA */
                FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = estabelec.ep-codigo
                                                AND mla-doc-pend-aprov.cod-estabel = estabelec.cod-estabel 
                                                AND mla-doc-pend-aprov.cod-tip-doc = 8   /* Pedido Emergencial */
                                                AND mla-doc-pend-aprov.chave-doc   = STRING(item-doc-est.num-pedido)
                                                AND mla-doc-pend-aprov.historico   = NO  NO-LOCK NO-ERROR.
                
                ASSIGN c-narrativa = IF AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.cod-usuar ELSE item-doc-est.narrativa.
                    
                LEAVE.
                
            END. /* FOR EACH dupli-apagar  */


            FIND FIRST tit_ap NO-LOCK WHERE tit_ap.num_id_tit_ap          = INT(h_buffer_movto:BUFFER-FIELD("tta_num_id_tit_ap"):BUFFER-VALUE)
                                      AND   tit_ap.cod_estab              = string(h_buffer_movto:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)  
                                      AND   tit_ap.cb4_tit_ap_bco_cobdor <> "" NO-ERROR.

               IF AVAIL tit_ap THEN DO:
                   
               

               ASSIGN c-dda = "Sim".

               FIND last item_bord_ap NO-LOCK WHERE  item_bord_ap.cod_empresa           = tit_ap.cod_empresa
                                               AND   item_bord_ap.cod_estab             = tit_ap.cod_estab
                                               AND   item_bord_ap.cod_espec_docto       = tit_ap.cod_espec_docto
                                               AND   item_bord_ap.cod_ser_docto         = tit_ap.cod_ser_docto
                                               AND   item_bord_ap.cdn_fornecedor        = tit_ap.cdn_fornecedor
                                               AND   item_bord_ap.cod_tit_ap            = tit_ap.cod_tit_ap
                                               AND   item_bord_ap.cod_parcela           = tit_ap.cod_parcela
                                               AND   item_bord_ap.val_pagto             = tit_ap.val_sdo_tit_ap 
                                               AND   item_bord_ap.ind_sit_item_bord_ap  <> "estornado" NO-ERROR.


                   IF AVAIL item_bord_ap THEN DO:


                       ASSIGN c-situacao = string(item_bord_ap.ind_sit_item_bord_ap)
                              c-bordero  = string(item_bord_ap.num_bord_ap)
                              c-portador = item_bord_ap.cod_portador.
                
            
                  END.  
              END.
           END.


        /* ATRIBUI O VALOR DA NOVA COLUNA */
        ASSIGN whColAutorizacao_apb205aa:SCREEN-VALUE = c-narrativa
               WhColSituacao_apb205aa:SCREEN-VALUE    = c-situacao
               WhColBordero_apb205aa:SCREEN-VALUE     = c-bordero
               WhColDDA_apb205aa:SCREEN-VALUE         = c-dda
               WhColPortador_apb205aa:SCREEN-VALUE    = c-portador.


               

    END. /* WHEN 1 THEN DO:  */ 

    
    WHEN 2 THEN DO: /* "br_tit_ap_em_aberto_corp" */

        IF VALID-HANDLE (whQryBrTable_corp_apb205aa) AND
           VALID-HANDLE(whColAutorizacao_corp_apb205aa) THEN DO:

            whQryBrTable_corp_apb205aa:GET-CURRENT().
            
            ASSIGN h_buffer_movto = whQryBrTable_corp_apb205aa:GET-BUFFER-HANDLE(1).

            /* BUSCA A DUPLICATA VINCULADA AO TITULO DE A PAGAR */
            FOR EACH dupli-apagar WHERE dupli-apagar.serie-docto  = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                                    AND dupli-apagar.nro-docto    = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_tit_ap"):BUFFER-VALUE)
                                    AND dupli-apagar.cod-emitente = INT(h_buffer_movto:BUFFER-FIELD("tta_cdn_fornecedor"):BUFFER-VALUE)
                                    AND dupli-apagar.parcela      = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE) NO-LOCK,
                FIRST docum-est OF  dupli-apagar NO-LOCK,
                FIRST item-doc-est OF docum-est NO-LOCK,
                FIRST estabelec OF docum-est NO-LOCK.

                /* BUSCA PELO AUTORIZADOR, CASO N«O SEJA ENCONTRADO, ê EXIBIDO TODA A NARRATIVA */
                FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = estabelec.ep-codigo
                                                AND mla-doc-pend-aprov.cod-estabel = estabelec.cod-estabel 
                                                AND mla-doc-pend-aprov.cod-tip-doc = 8   /* Pedido Emergencial */
                                                AND mla-doc-pend-aprov.chave-doc   = STRING(item-doc-est.num-pedido)
                                                AND mla-doc-pend-aprov.historico   = NO  NO-LOCK NO-ERROR.
                
                ASSIGN c-narrativa = IF AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.cod-usuar ELSE item-doc-est.narrativa.
                    
                LEAVE.
            END.  /* FOR EACH dupli-apagar  */

            FIND FIRST tit_ap NO-LOCK WHERE tit_ap.num_id_tit_ap          = INT(h_buffer_movto:BUFFER-FIELD("tta_num_id_tit_ap"):BUFFER-VALUE)
                                      AND   tit_ap.cod_estab              = string(h_buffer_movto:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)  
                                      AND   tit_ap.cb4_tit_ap_bco_cobdor <> "" NO-ERROR.

               IF AVAIL tit_ap THEN DO:
                   
               

               ASSIGN c-dda = "Sim".

               FIND last item_bord_ap NO-LOCK WHERE  item_bord_ap.cod_empresa           = tit_ap.cod_empresa
                                               AND   item_bord_ap.cod_estab             = tit_ap.cod_estab
                                               AND   item_bord_ap.cod_espec_docto       = tit_ap.cod_espec_docto
                                               AND   item_bord_ap.cod_ser_docto         = tit_ap.cod_ser_docto
                                               AND   item_bord_ap.cdn_fornecedor        = tit_ap.cdn_fornecedor
                                               AND   item_bord_ap.cod_tit_ap            = tit_ap.cod_tit_ap
                                               AND   item_bord_ap.cod_parcela           = tit_ap.cod_parcela
                                               AND   item_bord_ap.val_pagto             = tit_ap.val_sdo_tit_ap 
                                               AND   item_bord_ap.ind_sit_item_bord_ap  <> "estornado" NO-ERROR.


                   IF AVAIL item_bord_ap THEN DO:


                       ASSIGN c-situacao = string(item_bord_ap.ind_sit_item_bord_ap)
                              c-bordero  = string(item_bord_ap.num_bord_ap)
                              c-portador = item_bord_ap.cod_portador.
                
            
                  END.  

            END.


        END.  

        /* ATRIBUI O VALOR DA NOVA COLUNA */
        ASSIGN whColAutorizacao_corp_apb205aa:SCREEN-VALUE = c-narrativa
               WhColSituacao_corp_apb205aa:SCREEN-VALUE    = c-situacao
               WhColBordero_corp_apb205aa:SCREEN-VALUE     = c-bordero
               WhColDDA_corp_apb205aa:SCREEN-VALUE         = c-dda
               WhColPortador_corp_apb205aa:SCREEN-VALUE    = c-portador.


    END. /* WHEN 2 THEN DO:  */ 


    WHEN 3 THEN DO: /* "br_tit_ap_em_aberto_un" */

        IF VALID-HANDLE (whQryBrTable_un_apb205aa) AND
           VALID-HANDLE(whColAutorizacao_un_apb205aa) THEN DO:

            whQryBrTable_un_apb205aa:GET-CURRENT().
            
            ASSIGN h_buffer_movto = whQryBrTable_un_apb205aa:GET-BUFFER-HANDLE(1).

            /* BUSCA A DUPLICATA VINCULADA AO TITULO DE A PAGAR */
            FOR EACH dupli-apagar WHERE dupli-apagar.serie-docto  = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                                    AND dupli-apagar.nro-docto    = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_tit_ap"):BUFFER-VALUE)
                                    AND dupli-apagar.cod-emitente = INT(h_buffer_movto:BUFFER-FIELD("tta_cdn_fornecedor"):BUFFER-VALUE)
                                    AND dupli-apagar.parcela      = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE) NO-LOCK,
                FIRST docum-est OF dupli-apagar NO-LOCK,
                FIRST item-doc-est OF docum-est NO-LOCK,
                FIRST estabelec OF docum-est NO-LOCK.

                /* BUSCA PELO AUTORIZADOR, CASO N«O SEJA ENCONTRADO, ê EXIBIDO TODA A NARRATIVA */
                FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = estabelec.ep-codigo
                                                AND mla-doc-pend-aprov.cod-estabel = estabelec.cod-estabel 
                                                AND mla-doc-pend-aprov.cod-tip-doc = 8   /* Pedido Emergencial */
                                                AND mla-doc-pend-aprov.chave-doc   = STRING(item-doc-est.num-pedido)
                                                AND mla-doc-pend-aprov.historico   = NO  NO-LOCK NO-ERROR.
                
                ASSIGN c-narrativa = IF AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.cod-usuar ELSE item-doc-est.narrativa.
                    
                LEAVE.
              END.

                FIND FIRST tit_ap NO-LOCK WHERE tit_ap.num_id_tit_ap          = INT(h_buffer_movto:BUFFER-FIELD("tta_num_id_tit_ap"):BUFFER-VALUE)
                                          AND   tit_ap.cod_estab              = string(h_buffer_movto:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)  
                                          AND   tit_ap.cb4_tit_ap_bco_cobdor <> "" NO-ERROR.

                   IF AVAIL tit_ap THEN DO:



                   ASSIGN c-dda = "Sim".

                   FIND last item_bord_ap NO-LOCK WHERE  item_bord_ap.cod_empresa           = tit_ap.cod_empresa
                                                   AND   item_bord_ap.cod_estab             = tit_ap.cod_estab
                                                   AND   item_bord_ap.cod_espec_docto       = tit_ap.cod_espec_docto
                                                   AND   item_bord_ap.cod_ser_docto         = tit_ap.cod_ser_docto
                                                   AND   item_bord_ap.cdn_fornecedor        = tit_ap.cdn_fornecedor
                                                   AND   item_bord_ap.cod_tit_ap            = tit_ap.cod_tit_ap
                                                   AND   item_bord_ap.cod_parcela           = tit_ap.cod_parcela
                                                   AND   item_bord_ap.val_pagto             = tit_ap.val_sdo_tit_ap 
                                                   AND   item_bord_ap.ind_sit_item_bord_ap  <> "estornado" NO-ERROR.


                       IF AVAIL item_bord_ap THEN DO:


                           ASSIGN c-situacao = string(item_bord_ap.ind_sit_item_bord_ap)
                                  c-bordero  = string(item_bord_ap.num_bord_ap)
                                  c-portador = item_bord_ap.cod_portador.


                      END.  
                  END.
               END.

        /* ATRIBUI O VALOR DA NOVA COLUNA */
        ASSIGN whColAutorizacao_un_apb205aa:SCREEN-VALUE   = c-narrativa
               WhColSituacao_un_apb205aa:SCREEN-VALUE    = c-situacao
               WhColBordero_un_apb205aa:SCREEN-VALUE     = c-bordero
               WhColDDA_un_apb205aa:SCREEN-VALUE         = c-dda
               WhColPortador_un_apb205aa:SCREEN-VALUE    = c-portador.

    END. /* WHEN 3 THEN DO:  */ 

    WHEN 4 THEN DO: /* "br_tit_ap_em_aberto_un_corp_apb205aa" */

        IF VALID-HANDLE (whQryBrTable_un_corp_apb205aa) AND
           VALID-HANDLE(whColAutorizacao_un_corp_apb205aa) THEN DO:

            whQryBrTable_un_corp_apb205aa:GET-CURRENT().
            
            ASSIGN h_buffer_movto = whQryBrTable_un_corp_apb205aa:GET-BUFFER-HANDLE(1).

            /* BUSCA A DUPLICATA VINCULADA AO TITULO DE A PAGAR */
            FOR EACH dupli-apagar WHERE dupli-apagar.serie-docto  = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_ser_docto"):BUFFER-VALUE)
                                    AND dupli-apagar.nro-docto    = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_tit_ap"):BUFFER-VALUE)
                                    AND dupli-apagar.cod-emitente = INT(h_buffer_movto:BUFFER-FIELD("tta_cdn_fornecedor"):BUFFER-VALUE)
                                    AND dupli-apagar.parcela      = STRING(h_buffer_movto:BUFFER-FIELD("tta_cod_parcela"):BUFFER-VALUE) NO-LOCK,
                FIRST docum-est OF dupli-apagar NO-LOCK,
                FIRST item-doc-est OF docum-est NO-LOCK,
                FIRST estabelec OF docum-est NO-LOCK.

                /* BUSCA PELO AUTORIZADOR, CASO N«O SEJA ENCONTRADO, ê EXIBIDO TODA A NARRATIVA */
                FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = estabelec.ep-codigo
                                                AND mla-doc-pend-aprov.cod-estabel = estabelec.cod-estabel 
                                                AND mla-doc-pend-aprov.cod-tip-doc = 8   /* Pedido Emergencial */
                                                AND mla-doc-pend-aprov.chave-doc   = STRING(item-doc-est.num-pedido)
                                                AND mla-doc-pend-aprov.historico   = NO  NO-LOCK NO-ERROR.
                
                ASSIGN c-narrativa = IF AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.cod-usuar ELSE item-doc-est.narrativa.
                    
                LEAVE.
            END.  /* FOR EACH dupli-apagar  */
            FIND FIRST tit_ap NO-LOCK WHERE tit_ap.num_id_tit_ap          = INT(h_buffer_movto:BUFFER-FIELD("tta_num_id_tit_ap"):BUFFER-VALUE)
                                      AND   tit_ap.cod_estab              = string(h_buffer_movto:BUFFER-FIELD("tta_cod_estab"):BUFFER-VALUE)  
                                      AND   tit_ap.cb4_tit_ap_bco_cobdor <> "" NO-ERROR.

               IF AVAIL tit_ap THEN DO:



               ASSIGN c-dda = "Sim".

               FIND last item_bord_ap NO-LOCK WHERE  item_bord_ap.cod_empresa           = tit_ap.cod_empresa
                                               AND   item_bord_ap.cod_estab             = tit_ap.cod_estab
                                               AND   item_bord_ap.cod_espec_docto       = tit_ap.cod_espec_docto
                                               AND   item_bord_ap.cod_ser_docto         = tit_ap.cod_ser_docto
                                               AND   item_bord_ap.cdn_fornecedor        = tit_ap.cdn_fornecedor
                                               AND   item_bord_ap.cod_tit_ap            = tit_ap.cod_tit_ap
                                               AND   item_bord_ap.cod_parcela           = tit_ap.cod_parcela
                                               AND   item_bord_ap.val_pagto             = tit_ap.val_sdo_tit_ap 
                                               AND   item_bord_ap.ind_sit_item_bord_ap  <> "estornado" NO-ERROR.


                   IF AVAIL item_bord_ap THEN DO:


                       ASSIGN c-situacao = string(item_bord_ap.ind_sit_item_bord_ap)
                              c-bordero  = string(item_bord_ap.num_bord_ap)
                              c-portador = item_bord_ap.cod_portador.


                  END.  
              END.
           END.

    /* ATRIBUI O VALOR DA NOVA COLUNA */
    ASSIGN whColAutorizacao_un_apb205aa:SCREEN-VALUE   = c-narrativa
           WhColSituacao_un_apb205aa:SCREEN-VALUE    = c-situacao
           WhColBordero_un_apb205aa:SCREEN-VALUE     = c-bordero
           WhColDDA_un_apb205aa:SCREEN-VALUE         = c-dda
           WhColPortador_un_apb205aa:SCREEN-VALUE    = c-portador.

    END. /* WHEN 4 THEN DO:  */ 

END CASE.  /* CASE i-tipo:  */




RETURN 'OK'.
