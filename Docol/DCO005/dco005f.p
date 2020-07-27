/*********************************************************************************************************
** Programa.........: dco005f
** Descricao .......: Buscar % Comiss∆o dos Representantes de Exportaá∆o
** Versao...........: 01.001
** Nome Externo.....: dop/dco005f.p
** Autor............: Diomar Muhlmann
** Criado...........: Setembro/2006
*********************************************************************************************************/

DEFINE INPUT  PARAM c-cod_estab       LIKE tit_acr.cod_estab         NO-UNDO.
DEFINE INPUT  PARAM c-cod_ser_doc     LIKE tit_acr.cod_ser_doc       NO-UNDO.
DEFINE INPUT  PARAM c-cod_tit_acr     LIKE tit_acr.cod_tit_acr       NO-UNDO.
DEFINE INPUT  PARAM i-cdn_repres      LIKE repres_tit_acr.cdn_repres NO-UNDO.
DEFINE OUTPUT PARAM de-perc-comis-exp AS DEC                         NO-UNDO.

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = c-cod_estab
       AND nota-fiscal.serie     = c-cod_ser_doc
       AND nota-fiscal.nr-fatura = c-cod_tit_acr NO-ERROR.
IF AVAIL nota-fiscal THEN DO:
   FOR EACH fat-repre NO-LOCK
      WHERE fat-repre.cod-estab = nota-fiscal.cod-estabel
        AND fat-repre.serie     = nota-fiscal.serie    
        AND fat-repre.nr-fatura = nota-fiscal.nr-fatura:

      FIND FIRST repres NO-LOCK
           WHERE repres.nome-abrev = fat-repre.nome-ab-rep NO-ERROR.

      IF repres.cod-rep = i-cdn_repres THEN
         ASSIGN de-perc-comis-exp = fat-repre.perc-comis.
   END.
END.
       
/* dco005f.p */
