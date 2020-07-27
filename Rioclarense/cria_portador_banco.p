DEFINE BUFFER b-portador FOR portad_finalid_econ.

    FOR EACH b-portador NO-LOCK WHERE b-portador.cod_estab = "102":


            FIND FIRST portad_finalid_econ NO-LOCK WHERE portad_finalid_econ.cod_estab = '105'
                                                   AND   portad_finalid_econ.cod_portador = b-portador.cod_portador
                                                   AND   portad_finalid_econ.cod_cart_bcia = b-portador.cod_cart_bcia
                                                   AND   portad_finalid_econ.cod_finalid_econ = b-portador.cod_finalid_econ NO-ERROR.



            IF NOT AVAIL portad_finalid_econ THEN DO:
                

                CREATE portad_finalid_econ.
                ASSIGN 
                    portad_finalid_econ.cdd_version               = b-portador.cdd_version               
                    portad_finalid_econ.cod_cart_bcia             = b-portador.cod_cart_bcia     
                    portad_finalid_econ.cod_cta_corren            = b-portador.cod_cta_corren    
                    portad_finalid_econ.cod_estab                 = "105"          
                    portad_finalid_econ.cod_finalid_econ          = b-portador.cod_finalid_econ  
                    portad_finalid_econ.cod_livre_1               = b-portador.cod_livre_1       
                    portad_finalid_econ.cod_livre_2               = b-portador.cod_livre_2       
                    portad_finalid_econ.cod_portador              = b-portador.cod_portador      
                    portad_finalid_econ.dat_livre_1               = b-portador.dat_livre_1       
                    portad_finalid_econ.dat_livre_2               = b-portador.dat_livre_2       
                    portad_finalid_econ.log_livre_1               = b-portador.log_livre_1       
                    portad_finalid_econ.log_livre_2               = b-portador.log_livre_2       
                    portad_finalid_econ.num_livre_1               = b-portador.num_livre_1       
                    portad_finalid_econ.num_livre_2               = b-portador.num_livre_2       
                    portad_finalid_econ.val_livre_1               = b-portador.val_livre_1       
                    portad_finalid_econ.val_livre_2               = b-portador.val_livre_2       
                    portad_finalid_econ.val_sdo_cobr              = b-portador.val_sdo_cobr .     


            END.
    END.
