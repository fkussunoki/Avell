DEFINE TEMP-TABLE tt-acumulador 
    FIELD cod_demonst AS char
    FIELD sequencia AS INTEGER
    FIELD cod_acumulador AS char.


INPUT FROM c:/DESENV/acumuladores.txt.

             REPEAT:
                 CREATE tt-acumulador.
                 IMPORT DELIMITER ";" tt-acumulador.cod_demonst
                                      tt-acumulador.sequencia
                                      tt-acumulador.cod_acumulador.
             END.


        FOR EACH tt-acumulador:

            FIND FIRST acumul_demonst_ctbl WHERE acumul_demonst_ctbl.cod_demonst_ctbl = tt-acumulador.cod_demonst   
                                           AND    acumul_demonst_ctbl.num_seq_demonst_ctbl = tt-acumulador.sequencia NO-ERROR.


            IF NOT AVAIL acumul_demonst_ctbl THEN DO:
                
            


        
             CREATE acumul_demonst_ctbl.
             ASSIGN acumul_demonst_ctbl.cod_demonst_ctbl = tt-acumulador.cod_demonst    
                    acumul_demonst_ctbl.num_seq_demonst_ctbl = tt-acumulador.sequencia
                    acumul_demonst_ctbl.cod_acumul_ctbl    = tt-acumulador.cod_acumulador.

             END.

            IF AVAIL acumul_demonst_ctbl THEN DO:
                ASSIGN acumul_demonst_ctbl.cod_demonst_ctbl = tt-acumulador.cod_demonst    
                       acumul_demonst_ctbl.num_seq_demonst_ctbl = tt-acumulador.sequencia
                       acumul_demonst_ctbl.cod_acumul_ctbl    = tt-acumulador.cod_acumulador.
                
            END.

           END.
