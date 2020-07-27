/*****************************************************************************
**  Include.: doap003rpa.i
**  Autor...: Diomar MÅhlmann
**  Data....: Outubro/2004
**  Objetivo: Pesquisar t°tulos APB e ACR por Matriz para encontro de contas
*****************************************************************************/

FOR EACH tt-matriz.
    DELETE tt-matriz.
END.
FOR EACH tt-tit_ap.
    DELETE tt-tit_ap.
END.
FOR EACH tt-tit_acr.
    DELETE tt-tit_acr.
END.
    
FOR EACH estabelecimento NO-LOCK USE-INDEX stblcmnt_id
   WHERE estabelecimento.cod_empresa = c-cod-empresa /*v_cod_empres_usuar*/
     AND LOOKUP(estabelecimento.cod_estab,c-cod_estab-ax) <> 0:

   RUN pi-inicializar IN h-acomp (INPUT "Verificando Contas a Pagar...").

   FOR EACH emsuni.espec_docto NO-LOCK
      WHERE LOOKUP(emsuni.espec_docto.cod_espec_doc,c-lista-cod-esp-ap-ax) <> 0
        AND emsuni.espec_docto.ind_tip_espec_docto                        = 'Normal':

      RUN pi-acompanhar IN h-acomp (INPUT "Estabelecimento: " + estabelecimento.cod_estab + " - EspÇcie " + string(emsuni.espec_docto.cod_espec_doc)).

      FOR EACH tit_ap USE-INDEX titap_dat_prev_pagto NO-LOCK
         WHERE tit_ap.cod_estab           = estabelecimento.cod_estab
           AND tit_ap.dat_liquidac_tit_ap = 12/31/9999
           AND tit_ap.cod_espec_docto     = emsuni.espec_docto.cod_espec_doc
           AND tit_ap.dat_prev_pagto     >= dat_vencto_tit_ap-ini-ax
           AND tit_ap.dat_prev_pagto     <= dat_vencto_tit_ap-fin-ax:

         IF tit_ap.cdn_fornecedor         < i-cdn_fornecedor-ini-ax  OR
            tit_ap.cdn_fornecedor         > i-cdn_fornecedor-fin-ax  OR
            tit_ap.cod_ser_docto          < c-cod_ser_docto-ini-ax   OR 
            tit_ap.cod_ser_docto          > c-cod_ser_docto-fin-ax   OR 
            tit_ap.cod_tit_ap             < c-cod_tit_ap-ini-ax      OR
            tit_ap.cod_tit_ap             > c-cod_tit_ap-fin-ax      OR
            tit_ap.cod_parcela            < c-cod_parcela-ini-ax     OR
            tit_ap.cod_parcela            > c-cod_parcela-fin-ax     OR
            tit_ap.dat_emis_docto         < dat_emis_docto-ini-ax    OR
            tit_ap.dat_emis_docto         > dat_emis_docto-fin-ax  THEN NEXT.

         FIND FIRST pessoa_jurid NO-LOCK
              WHERE pessoa_jurid.num_pessoa_jurid = tit_ap.num_pessoa NO-ERROR.
         FIND FIRST emsuni.cliente NO-LOCK
              WHERE emsuni.cliente.cod_empresa = v_cod_empres_usuar
                AND emsuni.cliente.num_pessoa  = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.
         IF NOT AVAIL emsuni.cliente THEN NEXT. /* Se n∆o encontrar Matriz do Fornecedor Cadastrada como Cliente desconsidera o t°tulo */

         FIND FIRST tt-matriz NO-LOCK
              WHERE tt-matriz.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.
         IF NOT AVAIL tt-matriz THEN DO:
            CREATE tt-matriz.
            ASSIGN tt-matriz.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz.
         END.
         CREATE tt-tit_ap.
         ASSIGN tt-tit_ap.cod_empresa             = tit_ap.cod_empresa
                tt-tit_ap.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz
                tt-tit_ap.num_pessoa_jurid        = pessoa_jurid.num_pessoa_jurid
                tt-tit_ap.cdn_fornecedor          = tit_ap.cdn_fornecedor
                tt-tit_ap.cod_estab               = tit_ap.cod_estab
                tt-tit_ap.num_id_tit_ap           = tit_ap.num_id_tit_ap.
      END. /* for each tit_ap */
   END. /* for each emsuni.espec_docto */

   RUN pi-inicializar IN h-acomp ("Verificando Contas a Receber...").
   
   FOR EACH tt-matriz NO-LOCK
      WHERE NOT tt-matriz.log-tit_acr.
      
      RUN pi-acompanhar IN h-acomp ("Estabelecimento: " + estabelecimento.cod_estab + " - Matriz: " + STRING(tt-matriz.num_pessoa_jurid_matriz)) NO-ERROR.

      FOR EACH pessoa_jurid NO-LOCK
         WHERE pessoa_jurid.num_pessoa_jurid_matriz = tt-matriz.num_pessoa_jurid_matriz.
         FIND FIRST emsuni.cliente NO-LOCK
              WHERE emsuni.cliente.cod_empresa = estabelecimento.cod_empresa
                AND emsuni.cliente.num_pessoa  = pessoa_jurid.num_pessoa_jurid NO-ERROR.
         IF AVAIL emsuni.cliente THEN DO:

            FOR EACH tit_acr USE-INDEX titacr_clien_datas NO-LOCK
               WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
                 AND tit_acr.cdn_cliente          = emsuni.cliente.cdn_cliente
                 AND tit_acr.dat_liquidac_tit_acr = 12/31/9999:
               IF LOOKUP(tit_acr.cod_espec_docto,c-lista-cod-esp-cr-ax) = 0                           OR 
                  tit_acr.dat_vencto_tit_acr                            < dat_vencto_tit_acr-ini-ax   OR
                  tit_acr.dat_vencto_tit_acr                            > dat_vencto_tit_acr-fin-ax THEN NEXT.
               CREATE tt-tit_acr.
               ASSIGN tt-tit_acr.cod_empresa             = tit_acr.cod_empresa
                      tt-tit_acr.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz
                      tt-tit_acr.num_pessoa_jurid        = pessoa_jurid.num_pessoa_jurid
                      tt-tit_acr.cdn_cliente             = tit_acr.cdn_cliente
                      tt-tit_acr.cod_estab               = tit_acr.cod_estab
                      tt-tit_acr.num_id_tit_acr          = tit_acr.num_id_tit_acr.
            END.
            FIND FIRST tt-tit_acr NO-LOCK
                 WHERE tt-tit_acr.cod_empresa             = estabelecimento.cod_empresa
                   AND tt-tit_acr.num_pessoa_jurid_matriz = tt-matriz.num_pessoa_jurid_matriz NO-ERROR.
            IF AVAIL tt-tit_acr THEN
               ASSIGN tt-matriz.log-tit_acr = YES.
         END.
      END.
   END.
END.

/* dap003rpa.i */


