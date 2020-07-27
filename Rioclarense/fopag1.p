DEFINE TEMP-TABLE tt-fp
    FIELD cdn_funcionario AS INTEGER
    FIELD cdn_estab       AS char
    FIELD num_mes         AS INTEGER
    FIELD num_ano         AS INTEGER
    FIELD cdn_event_fp    AS char
    FIELD cdn_cta_efp_Db     AS char
    field cdn_cta_efp_cr     as char
    field cod_rh_ccusto_db   as char
    field cod_rh_ccusto_cr   as char
    field cod_unid_negoc  as char 
    FIELD percentual      AS char
    FIELD valor           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99" .

DEFINE VAR i AS INTEGER.

def var h-prog as handle.
def temp-table tt-erros
field cod_event as char.

DEFINE STREAM S1.
DEFINE STREAM S2.



ASSIGN i = 1.




run utp/ut-acomp.p persistent set h-prog.

run pi-inicializar in h-prog(Input "Iniciando").

FOR EACH movto_calcul_func NO-LOCK WHERE movto_calcul_func.num_ano_refer_fp = 2018
                                   AND   movto_calcul_func.num_mes_refer_fp >= 1
                                   AND   movto_calcul_func.num_mes_refer_fp <= 4:

            FIND FIRST funcionario NO-LOCK WHERE funcionario.cdn_empresa = movto_calcul_func.cdn_empresa
                                           AND   funcionario.cdn_estab   = movto_calcul_func.cdn_estab
                                           AND   funcionario.cdn_funcionario  = movto_calcul_func.cdn_funcionario NO-ERROR.


                
            run pi-acompanhar in h-prog(Input "Ano" + string(movto_calcul_func.num_ano_refer_fp) + " Mes " + string(movto_calcul_func.num_mes_refer_fp) + "Func " + string(funcionario.cdn_funcionario)).

                       DO WHILE i < 31:                                                
 
                        FIND FIRST cta_mdo_efp NO-LOCK WHERE cta_mdo_efp.cdn_empresa = movto_calcul_func.cdn_empresa
                                                       AND   cta_mdo_efp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i]
                                                       AND   cta_mdo_efp.cod_tip_mdo  = funcionario.cod_tip_mdo NO-ERROR.
                        if avail cta_mdo_efp then do:
                               
                        CREATE tt-fp.
                        ASSIGN tt-fp.cdn_funcionario                    = movto_calcul_func.cdn_funcionario
                               tt-fp.cdn_estab                          = funcionario.cdn_estab
                               tt-fp.num_mes                            = movto_calcul_func.num_mes_refer_fp
                               tt-fp.num_ano                            = movto_calcul_func.num_ano_refer_fp
                               tt-fp.cdn_event_fp                       = cta_mdo_efp.cdn_event_fp
                               tt-fp.cdn_cta_efp_db                     = cta_mdo_efp.cod_rh_cta_ctbl_db
                               tt-fp.cdn_cta_efp_cr                     = cta_mdo_efp.cod_rh_cta_ctbl_cr
                               tt-fp.cod_rh_ccusto_db                  = cta_mdo_efp.cod_rh_ccusto_db
                               tt-fp.cod_rh_ccusto_cr                  = cta_mdo_efp.cod_rh_ccusto_cr
                               tt-fp.cod_unid_negoc                     = funcionario.cod_unid_negoc
                               tt-fp.valor                              = movto_calcul_func.val_calcul_efp[i].
                                                
                        
                        END.

                        
                        if not avail cta_mdo_efp then do:
                        create tt-erros.
                        assign tt-erros.cod_event = movto_calcul_func.cdn_event_fp[i].
                        
                      end.
                      assign i = i + 1.
                  END.
                  assign i = 1.
         END.   
run pi-finalizar in h-prog.



            FOR EACH tt-fp:


                FOR EACH perc_rat_ccusto NO-LOCK WHERE perc_rat_ccusto.cdn_funcionario = tt-fp.cdn_funcionario:



                    ASSIGN tt-fp.percentual = tt-fp.percentual + ";" + perc_rat_ccusto.cod_rh_ccusto + ";" + perc_rat_ccusto.cod_unid_negoc + ";" + string(perc_rat_ccusto.val_val_perc_rat_ccusto).



            END.
     END.


            OUTPUT STREAM S1 TO c:\temp\folha.txt.

            FOR EACH tt-fp:


                PUT STREAM S1 UNFORMATTED tt-fp.cdn_funcionario ";"
                                TT-FP.cdn_estab       ";"
                                tt-fp.num_mes         ";"
                                tt-fp.num_ano         ";"
                                tt-fp.cdn_event    ";"
                                tt-fp.cdn_cta_efp_Db    ";" 
                                tt-fp.cdn_cta_efp_cr    ";"
                                tt-fp.cod_rh_ccusto_db  ";"
                                tt-fp.cod_rh_ccusto_cr  ";"
                                tt-fp.cod_unid_negoc ";"
                                tt-fp.valor          ";"
                                tt-fp.percentual
 
                    SKIP.










            END.
            
                        OUTPUT STREAM S2 TO c:\temp\ERROS.txt.
FOR EACH TT-ERROS:
DISP STREAM S2 TT-ERROS.

END.

            
            message "fim" view-as alert-box.
