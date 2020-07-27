DEFINE TEMP-TABLE tt-demonst
    FIELD cod_demonst AS char
    FIELD seq_demonst AS INTEGER
    FIELD tp-linha AS char
    FIELD tip_compos AS char
    FIELD titulo     AS char
    FIELD FORMat-linha AS char
    FIELD desenho       AS char
    FIELD TABulacao    AS INTEGER
    FIELD n-linhas      AS INTEGER.



INPUT FROM c:/DESENV/linha_demonst.txt.



             REPEAT:

                 CREATE tt-demonst.
                 IMPORT DELIMITER ";" tt-demonst.cod_demonst
                                      tt-demonst.seq_demonst
                                      tt-demonst.tp-linha
                                      tt-demonst.tip_compos
                                      tt-demonst.titulo
                                      tt-demonst.format-linha
                                      tt-demonst.desenho
                                      tt-demonst.tabulacao
                                      tt-demonst.n-linhas.

                 
             END.


             FOR EACH tt-demonst:

                 FIND FIRST item_demonst_ctbl                  WHERE item_demonst_ctbl.cod_demonst_ctbl = tt-demonst.cod_demonst      
                                                               AND   item_demonst_ctbl.num_seq_demonst_ctbl = tt-demonst.seq_demonst  NO-ERROR.


                 IF NOT AVAIL item_demonst_ctbl THEN DO:
                     
                 



                 CREATE item_demonst_ctbl.
                 ASSIGN item_demonst_ctbl.cod_demonst_ctbl = tt-demonst.cod_demonst
                        item_demonst_ctbl.num_seq_demonst_ctbl = tt-demonst.seq_demonst
                        item_demonst_ctbl.ind_tip_lin_demonst  = tt-demonst.tp-linha
                        item_demonst_ctbl.ind_tip_compos_demonst = tt-demonst.tip_compos
                        item_demonst_ctbl.des_tit_ctbl           = tt-demonst.titulo.
                        

                 IF tt-demonst.format-linha <> "" THEN DO:
                     
                     ASSIGN item_demonst_ctbl.ind_impres_traco_lin = tt-demonst.format-linha
                            item_demonst_ctbl.ind_carac_traco      = tt-demonst.desenho
                            item_demonst_ctbl.num_lin_salto_ANTES     = tt-demonst.n-linhas
                            item_demonst_ctbl.num_endent_lin_demonst = tt-demonst.tabulacao.

                 END.

                 ELSE DO:
                     ASSIGN item_demonst_ctbl.num_endent_lin_demonst = tt-demonst.tabulacao.
                 END.

               END.

               IF AVAIL item_demonst_ctbl THEN DO:
                   
                   ASSIGN  item_demonst_ctbl.cod_demonst_ctbl = tt-demonst.cod_demonst        
                           item_demonst_ctbl.num_seq_demonst_ctbl = tt-demonst.seq_demonst    
                           item_demonst_ctbl.ind_tip_lin_demonst  = tt-demonst.tp-linha       
                           item_demonst_ctbl.ind_tip_compos_demonst = tt-demonst.tip_compos   
                           item_demonst_ctbl.des_tit_ctbl           = tt-demonst.titulo.      

                   IF tt-demonst.format-linha <> "" THEN DO:

               ASSIGN item_demonst_ctbl.ind_impres_traco_lin = tt-demonst.format-linha
                      item_demonst_ctbl.ind_carac_traco      = tt-demonst.desenho
                      item_demonst_ctbl.num_lin_salto_ANTES     = tt-demonst.n-linhas
                      item_demonst_ctbl.num_endent_lin_demonst = tt-demonst.tabulacao.

             END.


               END.


             END.
            





