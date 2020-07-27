DEF TEMP-TABLE tt-itens
    FIELD cod_demonst AS char
    FIELD seq_demonst AS INTEGER
    FIELD seq_item AS  INTEGER
    FIELD plano AS char
    FIELD conta AS char
    FIELD FORMula AS char.


INPUT FROM c:/DESENV/itens_demonst.txt.


             REPEAT:
                 CREATE tt-itens.
                 IMPORT DELIMITER ";" tt-itens.cod_demonst
                                      tt-itens.seq_demonst
                                      tt-itens.seq_item
                                      tt-itens.plano
                                      tt-itens.conta
                                      tt-itens.formula.
             END.


             FOR EACH tt-itens:

                 FIND FIRST compos_demonst_ctbl WHERE compos_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst          
                                                AND      compos_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst      
                                                AND      compos_demonst_ctbl.num_seq_compos_demonst = tt-itens.seq_item  NO-ERROR.

                 IF NOT avail compos_demonst_ctbl THEN DO:
                     
                 




                 FIND FIRST item_demonst_ctbl NO-LOCK WHERE item_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                                                      AND   item_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst NO-ERROR.

                 IF item_demonst_ctbl.ind_tip_lin_demonst = "C lculo" THEN DO:
                     
                     CREATE compos_demonst_ctbl.
                     ASSIGN compos_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                            compos_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst
                            compos_demonst_ctbl.num_seq_compos_demonst = tt-itens.seq_item
                            compos_demonst_ctbl.cod_estab_inic    = ""
                            compos_demonst_ctbl.cod_estab_fim     = "zzz"
                            compos_demonst_ctbl.cod_unid_negoc_inic = ""
                            compos_demonst_ctbl.cod_unid_negoc_fim   = "zzz"
                            compos_demonst_ctbl.cod_plano_cta_ctbl   = tt-itens.plano
                            compos_demonst_ctbl.cod_cta_ctbl_inic    = tt-itens.conta
                            compos_demonst_ctbl.cod_cta_ctbl_fim     = tt-itens.conta
                            compos_demonst_ctbl.cod_cta_ctbl_pfixa   = "########"
                            compos_demonst_ctbl.cod_cta_ctbl_excec   = "########"
                            compos_demonst_ctbl.ind_espec_cta_ctbl_consid = "Anal¡tica"
                            compos_demonst_ctbl.cod_plano_ccusto     = "OFICIAL"
                            compos_demonst_ctbl.cod_ccusto_inic      = "00000"
                            compos_demonst_ctbl.cod_ccusto_fim       = "99999"
                            compos_demonst_ctbl.cod_ccusto_pfixa     = "#####"
                            compos_demonst_ctbl.cod_ccusto_excec     = "#####"
                            compos_demonst_ctbl.cod_unid_organ_fim   = "1"
                            compos_demonst_ctbl.cod_proj_financ_inic = ""
                            compos_demonst_ctbl.cod_proj_financ_fim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                            compos_demonst_ctbl.cod_proj_financ_pfixa = "########################"
                            compos_demonst_ctbl.cod_proj_financ_excec = "########################"
                            compos_demonst_ctbl.cod_proj_financ_inicial = ""
                            compos_demonst_ctbl.cod_unid_organ = "1".
                            


                 END.

                 IF item_demonst_ctbl.ind_tip_compos_demonst = "F¢rmula" THEN DO:
                     CREATE compos_demonst_ctbl.
                     ASSIGN compos_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                            compos_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst
                            compos_demonst_ctbl.num_seq_compos_demonst = tt-itens.seq_item
                            compos_demonst_ctbl.des_formul_ctbl        = tt-itens.formula.


                END.
             END.

             IF AVAIL compos_demonst_ctbl THEN DO:
                 
                         FIND FIRST item_demonst_ctbl NO-LOCK WHERE item_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                                             AND   item_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst NO-ERROR.
        
        IF item_demonst_ctbl.ind_tip_lin_demonst = "C lculo" THEN DO:
        
            ASSIGN compos_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                   compos_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst
                   compos_demonst_ctbl.num_seq_compos_demonst = tt-itens.seq_item
                   compos_demonst_ctbl.cod_estab_inic    = ""
                   compos_demonst_ctbl.cod_estab_fim     = "zzz"
                   compos_demonst_ctbl.cod_unid_negoc_inic = ""
                   compos_demonst_ctbl.cod_unid_negoc_fim   = "zzz"
                   compos_demonst_ctbl.cod_plano_cta_ctbl   = tt-itens.plano
                   compos_demonst_ctbl.cod_cta_ctbl_inic    = tt-itens.conta
                   compos_demonst_ctbl.cod_cta_ctbl_fim     = tt-itens.conta
                   compos_demonst_ctbl.cod_cta_ctbl_pfixa   = "########"
                   compos_demonst_ctbl.cod_cta_ctbl_excec   = "########"
                   compos_demonst_ctbl.ind_espec_cta_ctbl_consid = "Anal¡tica"
                   compos_demonst_ctbl.cod_plano_ccusto     = "OFICIAL"
                   compos_demonst_ctbl.cod_ccusto_inic      = "00000"
                   compos_demonst_ctbl.cod_ccusto_fim       = "99999"
                   compos_demonst_ctbl.cod_ccusto_pfixa     = "#####"
                   compos_demonst_ctbl.cod_ccusto_excec     = "#####"
                   compos_demonst_ctbl.cod_unid_organ_fim   = "1"
                   compos_demonst_ctbl.cod_proj_financ_inic = ""
                   compos_demonst_ctbl.cod_proj_financ_fim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                   compos_demonst_ctbl.cod_proj_financ_pfixa = "########################"
                   compos_demonst_ctbl.cod_proj_financ_excec = "########################"
                   compos_demonst_ctbl.cod_proj_financ_inicial = ""
                   compos_demonst_ctbl.cod_unid_organ        = "1".
        
        
        
        END.
        
        IF item_demonst_ctbl.ind_tip_compos_demonst = "F¢rmula" THEN DO:
            ASSIGN compos_demonst_ctbl.cod_demonst_ctbl = tt-itens.cod_demonst
                   compos_demonst_ctbl.num_seq_demonst_ctbl = tt-itens.seq_demonst
                   compos_demonst_ctbl.num_seq_compos_demonst = tt-itens.seq_item
                   compos_demonst_ctbl.des_formul_ctbl        = tt-itens.formula.
        
        
        END.
        
        
        
        
        
        
                     END.
        
                END.

    
