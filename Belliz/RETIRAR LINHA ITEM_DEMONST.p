DEF VAR h-prog AS HANDLE.

DEF TEMP-TABLE tt-demonst 
    FIELD cod AS char.


INPUT FROM c:\silet\demonst.txt.

REPEAT:
    CREATE tt-demonst.
    IMPORT tt-demonst.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.


RUN pi-inicializar IN h-prog (INPUT "Gerando").

FOR EACH tt-demonst:
FOR EACH item_demonst_ctbl WHERE item_demonst_ctbl.cod_demonst_ctbl = TT-DEMONST.COD
                           AND   (item_demonst_ctbl.num_lin_salto_antes > 0
                           OR     item_demonst_ctbl.num_lin_salto_apos >0):
RUN pi-acompanhar IN h-prog (INPUT item_demonst_ctbl.cod_demonst_ctbl + string(item_demonst_ctbl.num_seq_demonst_ctbl)).

    ASSIGN item_demonst_ctbl.num_lin_salto_antes = 0
           item_demonst_ctbl.num_lin_salto_apos = 0.



    END.
END.

RUN pi-finalizar IN h-prog.
