/************************************************************************
 ** Programa..: dop/dco005a.p                                          **
 ** Objetivo..: Encontrar o Centro de custo do Representante/Ped-venda **
 ** Criaá∆o...: Ivan Marcelo Silveira - 17/11/2003                     **
 ************************************************************************/

DEF INPUT PARAM c-cod_empresa       AS CHARACTER    NO-UNDO.
DEF INPUT PARAM i-cdn_repres        AS INTEGER      NO-UNDO.
DEF INPUT PARAM c-cod_estab         AS CHARACTER    NO-UNDO.
DEF INPUT PARAM i-num_id_tit_acr    AS INTEGER      NO-UNDO.

DEF OUTPUT PARAM c-cod_ccusto       AS CHARACTER    NO-UNDO.

DEF VAR c-mercado      AS CHAR NO-UNDO.
DEF VAR c-tipo-mercado AS CHAR NO-UNDO.
DEF VAR c-ccusto       AS CHAR NO-UNDO.
DEF VAR c-nome-ab-reg  AS CHAR NO-UNDO.

FIND FIRST tit_acr NO-LOCK
     WHERE tit_acr.cod_estab      = c-cod_estab
       AND tit_acr.num_id_tit_acr = i-num_id_tit_acr NO-ERROR.

IF AVAIL tit_acr THEN DO:
   FIND FIRST ped_vda_tit_acr NO-LOCK
        WHERE ped_vda_tit_acr.cod_estab        = c-cod_estab
          AND ped_vda_tit_acr.num_id_tit_acr   = i-num_id_tit_acr NO-ERROR.
   IF  AVAIL ped_vda_tit_acr THEN
       FIND FIRST ped-venda NO-LOCK 
            WHERE ped-venda.nr-pedido  = INTEGER(ped_vda_tit_acr.cod_ped_vda) NO-ERROR.

   FIND FIRST grupo-ped NO-LOCK
        WHERE grupo-ped.tp-pedido = ped-venda.tp-pedido 
          AND grupo-ped.cod-grupo = 5  /* SAT */  NO-ERROR.

   IF  AVAIL grupo-ped 
       THEN ASSIGN c-cod_ccusto = '31100'.

   IF c-cod_ccusto = "" THEN DO:
      IF tit_acr.dat_emis_docto >= 01/01/2010 AND tit_acr.cod_espec_docto <> "VV" THEN DO: /* Data da Divis∆o dos Centros de Custos ICC e Revenda */
         FIND FIRST dc-nota-fiscal NO-LOCK
              WHERE dc-nota-fiscal.cod-estabel = tit_acr.cod_estab
                AND dc-nota-fiscal.serie       = tit_acr.cod_ser_doc
                AND dc-nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
         IF AVAIL dc-nota-fiscal            AND
            dc-nota-fiscal.cc-codigo <> "" THEN DO:
            ASSIGN c-cod_ccusto = dc-nota-fiscal.cc-codigo.
         END.
      END.
      ELSE DO:
         FIND FIRST nota-fiscal NO-LOCK
              WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
                AND nota-fiscal.serie       = tit_acr.cod_ser_doc
                AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
         IF AVAIL nota-fiscal THEN DO:
            RUN dop/dft000.p (INPUT nota-fiscal.cod-estabel,
                              INPUT nota-fiscal.serie,
                              INPUT nota-fiscal.nr-nota-fis,
                              OUTPUT c-mercado,
                              OUTPUT c-tipo-mercado,
                              OUTPUT c-ccusto,
                              OUTPUT c-nome-ab-reg).
            ASSIGN c-cod_ccusto = c-ccusto.
         END.
      END.
   END.
END.

IF c-cod_ccusto = "" THEN DO:
   FIND FIRST dc-repres NO-LOCK
        WHERE dc-repres.cod_empresa = c-cod_empresa
          AND dc-repres.cdn_repres  = i-cdn_repres NO-ERROR.
   ASSIGN c-cod_ccusto = IF  AVAIL dc-repres THEN dc-repres.cod_ccusto ELSE "".
END.

/* FIM - dco005a.p */
