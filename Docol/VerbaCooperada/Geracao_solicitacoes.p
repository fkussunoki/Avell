CURRENT-LANG = CURRENT-LANG.

DEFINE TEMP-TABLE ttErro                
    FIELD SeqErro           AS INTEGER
    FIELD desc-erro-1       AS CHARACTER
    FIELD desc-erro-2       AS CHARACTER
    INDEX I00-Principal AS PRIMARY
    SeqErro.

DEF VAR num-solicita AS INTEGER.

FIND LAST amkt-solicitacao WHERE amkt-solicitacao.numero = 6399 NO-ERROR.

RUN esp\criasolicitacoesmkt.p(INPUT "3fad9cd3498e1c43d2d08364bb5bd3d9",
                              INPUT 808,
                              INPUT 0, 
                              INPUT amkt-solicitacao.cd-acao,
                              INPUT amkt-solicitacao.cd-forma-pagto,
                              INPUT amkt-solicitacao.cd-justificativa,
                              INPUT amkt-solicitacao.tipo-fatur,
                              INPUT amkt-solicitacao.justificativa-det,
                              INPUT amkt-solicitacao.cd-publico-alvo,
                              INPUT amkt-solicitacao.cd-tipo-acao,
                              INPUT amkt-solicitacao.cod-emitente,
                              INPUT amkt-solicitacao.dinamica,
                              INPUT 06/30/2019,
                              INPUT 06/01/2019,
                              INPUT amkt-solicitacao.forma-pagto-agencia,
                              INPUT amkt-solicitacao.forma-pagto-cd-banco,
                              INPUT amkt-solicitacao.forma-pagto-conta,
                              INPUT amkt-solicitacao.forma-pagto-cpf-cnpj,
                              INPUT amkt-solicitacao.forma-pagto-favorecido,
                              INPUT amkt-solicitacao.forma-pagto-nome-banco,
                              INPUT amkt-solicitacao.forma-pagto-tipo,
                              INPUT 1200,
                              INPUT amkt-solicitacao.payback-dias,
                              INPUT amkt-solicitacao.indice-aprov,
                              INPUT amkt-solicitacao.indice-aprov-dias,
                              OUTPUT TABLE tterro,
                              OUTPUT num-solicita).

MESSAGE NUM-SOLICITA VIEW-AS ALERT-BOX.

OUTPUT TO C:\DESENV\TT-ERRO.TXT.
FOR EACH TTERRO:
    EXPORT TTERRO.
END.
                              
OUTPUT CLOSE.

