FUNCTION fn-situacao-unif-amkt RETURNS CHARACTER(p-numero AS INT):

    // amkt-forma-pagto.tipo-pagto -> 1 - Bonificado, 2 - Abatimento, 3 - Adiantamento
    // bfn-amkt-aprov-pend.tipo -> 1 - Solicita��o, 2 - Comprova��o, 3 - Pagamento
    // bfn-amkt-aprov-pend.situacao -> 1 - Pendente, 2 - Aprovada, 3 - Reprovada

    DEF BUFFER bfn-amkt-solicitacao      FOR amkt-solicitacao.
    DEF BUFFER bfn-amkt-forma-pagto      FOR amkt-forma-pagto.
    DEF BUFFER bfn-amkt-aprov-pend       FOR amkt-aprov-pend.
    DEF BUFFER bfn-amkt-solic-vl-bonific FOR amkt-solic-vl-bonific.

    FIND FIRST bfn-amkt-solicitacao NO-LOCK WHERE
               bfn-amkt-solicitacao.numero = p-numero NO-ERROR.
    IF NOT AVAIL bfn-amkt-solicitacao THEN RETURN "".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita��o Reprovada" THEN
        RETURN "Solicita��o Reprovada".

    IF bfn-amkt-solicitacao.cod-situacao = "Pendente de Aprova��o" THEN
        RETURN "Pendente de Aprova��o".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita��o Cancelada" THEN
        RETURN "Solicita��o Cancelada".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita��o Encerrada" THEN
        RETURN "Solicita��o Encerrada".

    FIND FIRST bfn-amkt-forma-pagto NO-LOCK WHERE
               bfn-amkt-forma-pagto.cd-forma-pagto = bfn-amkt-solicitacao.cd-forma-pagto NO-ERROR.

    CASE bfn-amkt-forma-pagto.tipo-pagto:
        WHEN 1 THEN DO: // Bonificado
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            // Chamado 90578 - Adequa��o desta fun��o � recente altera��o de fluxo Bonificado, que agora primeiro passa pelo pagamento
            IF bfn-amkt-solicitacao.situacao-pagto = "Solicita��o Pagto. Liberada" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova��o do Valor". // Chamado 90664 - "Pendente de Aprova��o do Pagamento R$".
                ELSE
                    RETURN "Pendente de Confirma��o do Valor". // Chamado 90664 - "Pendente de Solicita��o do Pagamento R$".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova��o" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova��o
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova��o da Comprova��o".
                ELSE
                    IF bfn-amkt-solicitacao.dt-validade-final >= TODAY THEN
                        RETURN "Solicita��o Aprovada".
                    ELSE
                        RETURN "Pendente de Comprova��o".
            END.

            FIND FIRST bfn-amkt-solic-vl-bonific NO-LOCK WHERE
                       bfn-amkt-solic-vl-bonific.tipo-documento = 1 /* bfn-amkt-solicitacao */        AND
                       bfn-amkt-solic-vl-bonific.documento      = STRING(bfn-amkt-solicitacao.numero) NO-ERROR.
            IF AVAIL bfn-amkt-solic-vl-bonific                                                                                AND
               bfn-amkt-solic-vl-bonific.vl-liberado > bfn-amkt-solic-vl-bonific.vl-realizado                                 AND
               TODAY                                <= DATE(ADD-INTERVAL(bfn-amkt-solic-vl-bonific.data-hora-lib, 90, 'DAY')) THEN
                RETURN "Pendente Implanta��o de Pedido".
            ELSE
                RETURN "Solicita��o Finalizada".
        END. // WHEN 1 THEN DO: // Bonificado
        WHEN 2 THEN DO: // Abatimento
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova��o" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova��o
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova��o da Comprova��o".
                ELSE IF bfn-amkt-solicitacao.dt-validade-final >= TODAY THEN
                    RETURN "Solicita��o Aprovada".
                ELSE
                    RETURN "Pendente de Comprova��o".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Comprova��o Aprovada" THEN DO:
                IF bfn-amkt-solicitacao.situacao-pagto = "Solicita��o Pagto. Liberada" THEN DO:
                    IF AVAIL bfn-amkt-aprov-pend        AND
                       bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                       bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                        RETURN "Pendente de Aprova��o de Abatimento".
                    ELSE
                        RETURN "Pendente Solicita��o de Abatimento".
                END.
                ELSE
                    RETURN "Solicita��o Finalizada".
            END.
        END. // WHEN 2 THEN DO: // Abatimento
        WHEN 3 THEN DO: // Pagamento
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            IF bfn-amkt-solicitacao.situacao-pagto = "Solicita��o Pagto. Liberada" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova��o do Pagamento R$".
                ELSE
                    RETURN "Pendente de Solicita��o do Pagamento R$".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova��o" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova��o
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova��o de Comprova��o".
                ELSE
                    RETURN "Pendente de Comprova��o".
            END.

            RETURN "Solicita��o Finalizada".
        END. // WHEN 3 THEN DO: // Pagamento
    END CASE. // CASE bfn-amkt-forma-pagto.tipo-pagto:
END FUNCTION. // fn-situacao-unif
