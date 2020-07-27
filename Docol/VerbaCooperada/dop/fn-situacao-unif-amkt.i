FUNCTION fn-situacao-unif-amkt RETURNS CHARACTER(p-numero AS INT):

    // amkt-forma-pagto.tipo-pagto -> 1 - Bonificado, 2 - Abatimento, 3 - Adiantamento
    // bfn-amkt-aprov-pend.tipo -> 1 - Solicita‡Æo, 2 - Comprova‡Æo, 3 - Pagamento
    // bfn-amkt-aprov-pend.situacao -> 1 - Pendente, 2 - Aprovada, 3 - Reprovada

    DEF BUFFER bfn-amkt-solicitacao      FOR amkt-solicitacao.
    DEF BUFFER bfn-amkt-forma-pagto      FOR amkt-forma-pagto.
    DEF BUFFER bfn-amkt-aprov-pend       FOR amkt-aprov-pend.
    DEF BUFFER bfn-amkt-solic-vl-bonific FOR amkt-solic-vl-bonific.

    FIND FIRST bfn-amkt-solicitacao NO-LOCK WHERE
               bfn-amkt-solicitacao.numero = p-numero NO-ERROR.
    IF NOT AVAIL bfn-amkt-solicitacao THEN RETURN "".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita‡Æo Reprovada" THEN
        RETURN "Solicita‡Æo Reprovada".

    IF bfn-amkt-solicitacao.cod-situacao = "Pendente de Aprova‡Æo" THEN
        RETURN "Pendente de Aprova‡Æo".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita‡Æo Cancelada" THEN
        RETURN "Solicita‡Æo Cancelada".

    IF bfn-amkt-solicitacao.cod-situacao = "Solicita‡Æo Encerrada" THEN
        RETURN "Solicita‡Æo Encerrada".

    FIND FIRST bfn-amkt-forma-pagto NO-LOCK WHERE
               bfn-amkt-forma-pagto.cd-forma-pagto = bfn-amkt-solicitacao.cd-forma-pagto NO-ERROR.

    CASE bfn-amkt-forma-pagto.tipo-pagto:
        WHEN 1 THEN DO: // Bonificado
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            // Chamado 90578 - Adequa‡Æo desta fun‡Æo … recente altera‡Æo de fluxo Bonificado, que agora primeiro passa pelo pagamento
            IF bfn-amkt-solicitacao.situacao-pagto = "Solicita‡Æo Pagto. Liberada" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova‡Æo do Valor". // Chamado 90664 - "Pendente de Aprova‡Æo do Pagamento R$".
                ELSE
                    RETURN "Pendente de Confirma‡Æo do Valor". // Chamado 90664 - "Pendente de Solicita‡Æo do Pagamento R$".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova‡Æo" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova‡Æo
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova‡Æo da Comprova‡Æo".
                ELSE
                    IF bfn-amkt-solicitacao.dt-validade-final >= TODAY THEN
                        RETURN "Solicita‡Æo Aprovada".
                    ELSE
                        RETURN "Pendente de Comprova‡Æo".
            END.

            FIND FIRST bfn-amkt-solic-vl-bonific NO-LOCK WHERE
                       bfn-amkt-solic-vl-bonific.tipo-documento = 1 /* bfn-amkt-solicitacao */        AND
                       bfn-amkt-solic-vl-bonific.documento      = STRING(bfn-amkt-solicitacao.numero) NO-ERROR.
            IF AVAIL bfn-amkt-solic-vl-bonific                                                                                AND
               bfn-amkt-solic-vl-bonific.vl-liberado > bfn-amkt-solic-vl-bonific.vl-realizado                                 AND
               TODAY                                <= DATE(ADD-INTERVAL(bfn-amkt-solic-vl-bonific.data-hora-lib, 90, 'DAY')) THEN
                RETURN "Pendente Implanta‡Æo de Pedido".
            ELSE
                RETURN "Solicita‡Æo Finalizada".
        END. // WHEN 1 THEN DO: // Bonificado
        WHEN 2 THEN DO: // Abatimento
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova‡Æo" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova‡Æo
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova‡Æo da Comprova‡Æo".
                ELSE IF bfn-amkt-solicitacao.dt-validade-final >= TODAY THEN
                    RETURN "Solicita‡Æo Aprovada".
                ELSE
                    RETURN "Pendente de Comprova‡Æo".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Comprova‡Æo Aprovada" THEN DO:
                IF bfn-amkt-solicitacao.situacao-pagto = "Solicita‡Æo Pagto. Liberada" THEN DO:
                    IF AVAIL bfn-amkt-aprov-pend        AND
                       bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                       bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                        RETURN "Pendente de Aprova‡Æo de Abatimento".
                    ELSE
                        RETURN "Pendente Solicita‡Æo de Abatimento".
                END.
                ELSE
                    RETURN "Solicita‡Æo Finalizada".
            END.
        END. // WHEN 2 THEN DO: // Abatimento
        WHEN 3 THEN DO: // Pagamento
            FOR LAST bfn-amkt-aprov-pend NO-LOCK WHERE
                     bfn-amkt-aprov-pend.cd-solicitacao = bfn-amkt-solicitacao.numero BY bfn-amkt-aprov-pend.dt-situacao: END.

            IF bfn-amkt-solicitacao.situacao-pagto = "Solicita‡Æo Pagto. Liberada" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 3 AND  // Pagamento
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova‡Æo do Pagamento R$".
                ELSE
                    RETURN "Pendente de Solicita‡Æo do Pagamento R$".
            END.

            IF bfn-amkt-solicitacao.situacao-comprov = "Pendente de Comprova‡Æo" THEN DO:
                IF AVAIL bfn-amkt-aprov-pend        AND
                   bfn-amkt-aprov-pend.tipo     = 2 AND  // Comprova‡Æo
                   bfn-amkt-aprov-pend.situacao = 1 THEN // Pendente
                    RETURN "Pendente de Aprova‡Æo de Comprova‡Æo".
                ELSE
                    RETURN "Pendente de Comprova‡Æo".
            END.

            RETURN "Solicita‡Æo Finalizada".
        END. // WHEN 3 THEN DO: // Pagamento
    END CASE. // CASE bfn-amkt-forma-pagto.tipo-pagto:
END FUNCTION. // fn-situacao-unif
