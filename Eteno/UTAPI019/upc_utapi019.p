/********************************************************************************
** Datasul Technology
**
** Programa: utapi019-upc - UPC reponsavel para montar o comando de envio de email
**
** Codigo de Parametros Dispon¡veis:    
**      EmailFrom       - Email remetente
**      EmailTo         - Email destino
**      ServidorEmail   - Servidor SMTP
**      CorpoEmail      - Arquivo com o texto do e-mail
**      CommandEmail    - Retorna o comando completo do e-mail
** 
**      Historico...... - rde - 01/10/2019 - ajusta assunto do e-mail de aprova‡Æo/rejei‡Æo (envio j  ‚ feito pelo esrcc0300.p).
********************************************************************************/
{include/i-epc200.i1} /* defini‡Æo da temp-table tt-epc */

DEF INPUT               PARAM p-ind-event   AS CHAR NO-UNDO.
DEF INPUT-OUTPUT        PARAM TABLE         FOR tt-epc.

/******************************************************************************
* Vari vel Global que cont‚m o usu rio corrente,
*  caso queira realizar alguma customiza‡Æo a n¡vel de usu rio.
******************************************************************************/
/*
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
*/

DEF VAR cComandoEmail                       AS CHAR NO-UNDO.
DEF VAR c-server                            AS CHAR NO-UNDO.
DEF VAR c-porta                             AS CHAR NO-UNDO.
DEF VAR c-arq-mens                          AS CHAR NO-UNDO.
DEF VAR jj                                  AS INT  NO-UNDO.
DEF VAR vi-num-pedido                       AS INT  NO-UNDO.
DEF VAR c-fabricante                        AS CHAR.
DEF VAR vlo-sinalizar                       AS LOG NO-UNDO.
DEF VAR vc-trecho-original-cortado          AS CHAR NO-UNDO.
DEF VAR novo-cComandoEmail                  AS CHAR NO-UNDO.
DEF VAR vc-final                            AS CHAR NO-UNDO.

DEF VAR deValorTotal       AS DEC                       NO-UNDO.   /* STRING (deValorTotal,">>>,>>>,>>9.99") */
DEF VAR de-preco-unit      LIKE ordem-compra.preco-unit NO-UNDO.
DEF VAR de-qt-solic        LIKE ordem-compra.qt-solic   NO-UNDO.
DEF VAR c-un               LIKE ITEM.un                 NO-UNDO.
DEF VAR deFator            AS   DEC                     NO-UNDO.
DEF VAR c-ass-e-mail       AS   CHAR                    NO-UNDO.
DEF VAR vc-tipo            AS   CHAR                    NO-UNDO.
DEF VAR vi-pos             AS   INT                     NO-UNDO.

/******************************************************************************
*
*   Exemplo: Rotina para ponto de EPC do BLAT.
*
******************************************************************************/
IF p-ind-event = "eMailBlat" THEN DO:
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "eMailBlat":U
         AND   tt-epc.cod-parameter = "CommandEmail":U
         EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN ASSIGN  cComandoEmail = tt-epc.val-parameter.

    /*Excluindo parametros */
    IF cComandoEmail MATCHES('*-mime*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-mime', '').
    IF cComandoEmail MATCHES('*-noh2*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-noh2', '').
    IF cComandoEmail MATCHES('*-noh*')  THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-noh',  '').
    IF cComandoEmail MATCHES('*-html*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-html', '').

/*     FIND FIRST param-global NO-LOCK NO-ERROR.                                                                            */
/*     IF param-global.serv-mail <> '' THEN DO:                                                                             */
/*         ASSIGN c-server = '-server "' + TRIM(param-global.serv-mail) + '"'.                                              */
/*         IF cComandoEmail MATCHES('*' + c-server + '*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, c-server, ''). */
/*     END.                                                                                                                 */
/*     IF param-global.porta-mail <> 0 THEN DO:                                                                             */
/*         ASSIGN c-porta = '-port ' + TRIM(STRING(param-global.porta-mail)).                                               */
/*         IF cComandoEmail MATCHES('*' + c-porta + '*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, c-porta, '').   */
/*     END.                                                                                                                 */
    FIND FIRST param_email NO-LOCK NO-ERROR.
    IF param_email.cod_servid_e_mail <> '' THEN DO:
        ASSIGN c-server = '-server "' + TRIM(param_email.cod_servid_e_mail) + '"'.
        IF cComandoEmail MATCHES('*' + c-server + '*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, c-server, '').
    END.
    IF param_email.num_porta <> 0 THEN DO:
        ASSIGN c-porta = '-port ' + TRIM(STRING(param_email.num_porta)).
        IF cComandoEmail MATCHES('*' + c-porta + '*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, c-porta, '').
    END.
    
    /*Compatibilizando os parametros do Blat com o SendEmail */
    IF cComandoEmail MATCHES('*blat.exe"*') THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, 'blat.exe"', 'SendEmail.exe"').
    IF cComandoEmail MATCHES('*-s*')        THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-s', '-u').
    IF cComandoEmail MATCHES('*-c*')        THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-c', '-cc').
    IF cComandoEmail MATCHES('*-attach*')   THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-attach', '-a').
    IF cComandoEmail MATCHES('*-log*')        THEN ASSIGN cComandoEmail = REPLACE(cComandoEmail, '-log', '-l').

    IF cComandoEmail MATCHES('*dtsemail*') THEN DO:
        ASSIGN c-arq-mens = SUBSTRING(cComandoEmail,(R-INDEX(cComandoEmail,'"',INDEX(cComandoEmail,'dtsemail'))) + 1, (INDEX(cComandoEmail,'"',INDEX(cComandoEmail,'dtsemail')) - R-INDEX(cComandoEmail,'"',INDEX(cComandoEmail,'dtsemail'))) - 1).
               cComandoEmail = REPLACE(cComandoEmail, STRING('"' + c-arq-mens + '"'), STRING('-o message-file=' + '"' + c-arq-mens + '"') ).
    END.

    /*Define o parƒmetro Server/Hostname*/
    /*ASSIGN cComandoEmail = cComandoEmail + " -s mail.rioclarense.com.br".*/
    /*ASSIGN cComandoEmail = cComandoEmail + " -s 201.63.145.29".*/
	/*ASSIGN cComandoEmail = cComandoEmail + " -s 192.168.0.1".*/
	/*ASSIGN cComandoEmail = cComandoEmail + " -s relay.rioclarense.com.br:2525".*/
	ASSIGN cComandoEmail = cComandoEmail + " -s smtp.gmail.com:587".

    /*Define o tipo de arquivo <auto|texto|html> */
    ASSIGN cComandoEmail = cComandoEmail + " -o message-content-type=html".

    /*Define o tipo de criptografia */
    /*ASSIGN cComandoEmail = cComandoEmail + " -o tls=yes".*/
    /*ASSIGN cComandoEmail = cComandoEmail + " -o tls=no".*/
    /*ASSIGN cComandoEmail = cComandoEmail + " -o ssl=yes".*/

    /*######## DEFINE NOVA AUTENTICA€ÇO ########*/
    IF cComandoEmail MATCHES ('*@eteno.com.br*') THEN   /* recall@rioclarense.com.br */
        ASSIGN cComandoEmail = cComandoEmail + " -xu eteno@eteno.com.br"
               cComandoEmail = cComandoEmail + " -xp af91675386".
  
    IF AVAIL tt-epc THEN ASSIGN  tt-epc.val-parameter = cComandoEmail.
END.

/******************************************************************************
*
*   Exemplo: Sa¡da em arquivo comando customizado.
*
******************************************************************************/
/*
output to value("\\ccrrctotvs01\totvs\dts-prg116\ERP\especifico\ems2\QG\temp\utapi019.txt") convert target "iso8859-1" APPEND.
   PUT UNFORMATTED " Comando: " + STRING(cComandoEmail) SKIP.
output close.
*/
/******************************************************************************
*
*   Exemplo: Sa¡da em tela do comando customizado.
*
******************************************************************************/
/*
MESSAGE "Comando: " + STRING(cComandoEmail) VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
