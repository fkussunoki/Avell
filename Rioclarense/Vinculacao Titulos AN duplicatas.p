DEF BUFFER b-movto FOR movto_tit_acr.
DEF BUFFER b-tit   FOR tit_acr.
DEF BUFFER b-cria  FOR movto_tit_acr.

DEF VAR h-prog AS HANDLE.

    OUTPUT TO c:/temp/movto.txt.


                PUT UNFORMATTED "Estab; Especie; Serie; Titulo; Parcela; Cliente; Vlr; Dt.Liquida; Estab AN; Espec AN; Serie AN; Titulo AN; Dt Implantacao AN"
                    SKIP.

                RUN utp/ut-acomp.p PERSISTENT SET h-prog.
                RUN pi-inicializar IN h-prog (INPUT "Gerando").
FOR EACH emscad.espec_docto WHERE emscad.espec_docto.ind_tip_espec_docto = "Antecipa‡Æo":

    FOR EACH movto_tit_acr NO-LOCK WHERE movto_tit_acr.ind_trans_acr = "Liquida‡Æo"
                                   AND   movto_tit_acr.cod_espec_docto = emscad.espec_docto.cod_espec_docto
                                   AND   movto_tit_acr.dat_transacao   >= 01/01/2019
                                   AND   movto_tit_acr.dat_transacao   <= 05/31/2019:

                RUN pi-acompanhar IN h-prog (INPUT "Dt Trans " + string(movto_tit_acr.dat_transacao)).

                FOR EACH  b-movto NO-LOCK WHERE b-movto.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai:

                FIND FIRST b-cria USE-INDEX mvtttcr_razao NO-LOCK WHERE b-cria.cod_empresa     = movto_tit_acr.cod_empresa
                                    AND   b-cria.cod_estab       = movto_tit_acr.cod_estab
                                    AND   b-cria.cod_espec_docto = movto_tit_acr.cod_espec_docto
                                    AND   b-cria.num_id_tit_acr  = movto_tit_acr.num_id_tit_acr NO-ERROR.


                FIND FIRST tit_acr NO-LOCK WHERE tit_acr.num_id_tit_acr = b-movto.num_id_tit_acr NO-ERROR.

                FIND FIRST b-tit   NO-LOCK WHERE b-tit.num_id_tit_acr   = movto_tit_acr.num_id_tit_acr NO-ERROR.

                PUT UNFORMATTED tit_acr.cod_estab ";"
                                tit_acr.cod_espec_docto ";"
                                tit_acr.cod_ser_docto   ";"
                                tit_acr.cod_tit_acr     ";"
                                tit_acr.cod_parcela     ";"
                                tit_acr.cdn_cliente     ";"
                                b-movto.val_movto_tit_acr ";"
                                b-movto.dat_transacao     ";"
                                b-tit.cod_estab           ";"      
                                b-tit.cod_espec_docto     ";"
                                b-tit.cod_ser_docto       ";"
                                b-tit.cod_tit_acr         ";"
                                b-tit.cod_parcela         ";"
                                b-cria.dat_transacao
                                SKIP.
                                






                END.

    END.
 END.

 RUN pi-finalizar IN h-prog.
