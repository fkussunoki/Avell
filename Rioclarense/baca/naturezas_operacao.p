OUTPUT TO c:\desenv\naturezas.txt.
FOR EACH natur-oper NO-LOCK:


    PUT UNFORMATTED natur-oper.nat-operacao  "|"
                    natur-oper.tipo          "|"
                    natur-oper.denominacao   "|"
                    natur-oper.especie-doc   "|"
                    natur-oper.terceiros     "|"
                    natur-oper.tp-oper-terc  "|"
                    natur-oper.nat-vinculada 
                    SKIP.
                    
END.
