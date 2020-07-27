/*********************************************************************************************************
** Programa.........: dco005e
** Descricao .......: Buscar Data de Emiss∆o da Nota Fiscal
** Versao...........: 01.001
** Nome Externo.....: dop/dco005e.p
** Autor............: Diomar Muhlmann
** Criado...........: 07/04/2004
*********************************************************************************************************/

DEFINE INPUT  PARAM c-cod_estab   LIKE tit_acr.cod_estab.
DEFINE INPUT  PARAM c-cod_ser_doc LIKE tit_acr.cod_ser_doc.
DEFINE INPUT  PARAM c-cod_tit_acr LIKE tit_acr.cod_tit_acr.
DEFINE OUTPUT PARAM da-emis-nota  AS DATE.

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = c-cod_estab
       AND nota-fiscal.serie     = c-cod_ser_doc
       AND nota-fiscal.nr-fatura = c-cod_tit_acr NO-ERROR.
IF AVAIL nota-fiscal THEN
   ASSIGN da-emis-nota = nota-fiscal.dt-emis-nota.
ELSE
   ASSIGN da-emis-nota = 12/31/9999.

/* dco005e.p */
