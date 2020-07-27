DEFINE BUFFER B-PEND FOR mla-doc-pend-aprov.
OUTPUT TO c:\desenv\mla.txt.

PUT UNFORMATTED "Nr.Trans | Pedido | Usuario Aprov | Usuario Alternativo | Usuario Transacao | Dt.Docto | Dt. Aprov | Dt. Rejeicao | Estabelec | Situacao" SKIP.

FOR EACH mla-doc-pend-aprov NO-LOCK BREAK BY mla-doc-pend-aprov.nr-trans:

    FIND LAST B-PEND WHERE B-PEND.chave-doc = mla-doc-pend-aprov.chave-doc
                     AND   B-PEND.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc NO-ERROR.

    IF B-PEND.ind-situacao = 2 THEN
        NEXT.

    ELSE DO:
        
        PUT UNFORMATTED mla-doc-pend-aprov.nr-trans  "|"
                        mla-doc-pend-aprov.chave-doc "|"
                        mla-doc-pend-aprov.cod-usuar "|"
                        mla-doc-pend-aprov.cod-usuar-altern "|"
                        mla-doc-pend-aprov.cod-usuar-trans "|"
                        mla-doc-pend-aprov.dt-geracao "|"   
                        mla-doc-pend-aprov.dt-aprova  "|"
                        mla-doc-pend-aprov.dt-rejeita "|"
                        mla-doc-pend-aprov.cod-estabel "|".

        IF mla-doc-pend-aprov.ind-situacao = 2 THEN
            PUT UNFORMATTED "Aprovado" SKIP.

        IF mla-doc-pend-aprov.ind-situacao = 3 THEN

            PUT UNFORMATTED "Rejeitado" SKIP.

        IF mla-doc-pend-aprov.ind-situacao = 1 THEN

            PUT UNFORMATTED "Pendente" SKIP.

    END.

    


END.
