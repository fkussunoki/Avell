DEFINE VAR h-prog AS HANDLE.
OUTPUT TO c:\temp\notas.txt.
RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Processando NF").
FOR EACH natur-oper NO-LOCK WHERE natur-oper.emite-duplic = no:


    FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.nat-operacao = natur-oper.nat-operacao
                                 AND   it-doc-fisc.cod-estabel  = '102'
                                 AND   it-doc-fisc.ct-codigo    = ""
                                 AND   it-doc-fisc.dt-emis-doc  >= 01/01/2017
                                 AND   it-doc-fisc.dt-emis-doc  <= 01/31/2017:
RUN pi-acompanhar IN h-prog(INPUT "Estab: " + it-doc-fisc.cod-estabel + " Nat.Oper: " + it-doc-fisc.nat-operacao + " NF: " + it-doc-fisc.nr-doc-fis).


        PUT UNFORMATTED it-doc-fisc.cod-estabel ";"
                        it-doc-fisc.serie       ";"
                        it-doc-fisc.cod-emitente ";"
                        it-doc-fisc.nat-operacao ";"
                        it-doc-fisc.dt-emis-doc  ";"
                        it-doc-fisc.ct-codigo    ";"
                        it-doc-fisc.vl-merc-liq 
                        SKIP.
        


    END.


END.
