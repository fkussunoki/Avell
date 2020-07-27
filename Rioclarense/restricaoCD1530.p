DEFINE VAR v_nat-oper AS CHAR VIEW-AS FILL-IN.
DEFINE VAR l-logico AS LOGICAL.
DEFINE BUTTON b_ok.
DEFINE VAR i-cont AS INTEGER.

DEFINE FRAME a
    v_nat-oper 
    b_ok WITH THREE-D.

ON 'choose' OF b_ok
DO:
    ASSIGN v_nat-oper.
    RUN testes.

END.


ENABLE b_ok WITH FRAME a.
ENABLE v_nat-oper WITH FRAME a.
      disp v_nat-oper WITH FRAME a.



PROCEDURE testes:
OUTPUT TO c:\temp\natur-oper.txt.      
                        /*Nat. n’o pode ser desativada, devido a exist¼ncia de documentos no receb. n’o atualizados*/ 
                    
        IF  CAN-FIND (FIRST docum-est WHERE
                            docum-est.ce-atual = NO
                        AND docum-est.nat-operacao = v_nat-oper) THEN DO:
        
            MESSAGE "Pendente tabela DOCUM-EST " VIEW-AS ALERT-BOX.
            RUN docum-est.



            end.

        /* Existem pedido de venda para esta natureza */

        if  can-find (first ped-venda where
                            ped-venda.nat-operacao =  v_nat-oper AND
                            ped-venda.cod-sit-ped  < 3) then do:

            MESSAGE "Pendente tabela PED-VENDA " VIEW-AS ALERT-BOX.
            RUN ped-venda.
        end.

        /* Existem itens de pedido para esta natureza */

        DO  i-cont = 1 TO 2:
        
            FOR EACH ped-venda WHERE
                     ped-venda.cod-sit-ped = i-cont NO-LOCK,
                EACH ped-item OF ped-venda
                WHERE ped-item.cod-sit-item < 3 AND
                      ped-item.nat-operacao = v_nat-oper NO-LOCK:
MESSAGE "Pendente tabela PED-VENDA " + ped-item.it-codigo VIEW-AS ALERT-BOX.
        RUN it-ped-venda.            
    return.       
            END.
        END.

        /* Existem documentos pendentes para esta natureza */
             
             if  can-find (first  wt-docto WHERE 
                                  wt-docto.nat-operacao = v_nat-oper) then do:

MESSAGE "Pendente tabela WT-DOCTO " VIEW-AS ALERT-BOX.
    RUN wt-docto.
                 
             return.
             end.

             if  can-find (first  wt-it-docto WHERE 
                                  wt-it-docto.nat-operacao = v_nat-oper or
                                  wt-it-docto.nat-docum = v_nat-oper) then do:

                 MESSAGE "Pendente tabela WT-IT-DOCTO " VIEW-AS ALERT-BOX.
    RUN wt-it-docto.
                 return.
             end.

END PROCEDure.

 PROCEDURE docum-est:

     PUT "docum-est.............." SKIP.
     PUT "esp-docto; serie; nr-docto; emitente; dt-emissao" SKIP.
     FOR EACH               docum-est WHERE
                            docum-est.ce-atual = NO
                            AND docum-est.nat-operacao = v_nat-oper:

         PUT docum-est.esp-docto ";"
             docum-est.serie-docto ";"
             docum-est.nro-docto ";"
             docum-est.cod-emitente ";"
             docum-est.dt-emissao
             SKIP.
         END.

END PROCEDURE.

PROCEDURE ped-venda:
    PUT "ped-venda.........." SKIP.
    PUT "estab; nome; ped-cliente; pedido; dt-emissao" SKIP.
    FOR EACH                ped-venda where
                            ped-venda.nat-operacao =  v_nat-oper AND
                            ped-venda.cod-sit-ped  < 3:

        PUT ped-venda.cod-estabel ";"
            ped-venda.nome-abrev ";"
            ped-venda.nr-pedcli ";"
            ped-venda.nr-pedido ";"
            ped-venda.dt-emissao
            SKIP.
        END.
END PROCEDURE.


PROCEDURE wt-docto:
    PUT "wt-docto.........." SKIP.
    PUT "estab; serie; nr-nota; nome; dt-emissao; nr.pedido" SKIP.
    FOR EACH                      wt-docto WHERE 
                                  wt-docto.nat-operacao = v_nat-oper:

        PUT wt-docto.cod-estabel ";"
            wt-docto.serie ";"
            wt-docto.nr-nota ";"
            wt-docto.nome-abrev ";"
            wt-docto.dt-emis-nota ";"
            wt-docto.nr-pedcli
            SKIP.

        END.

END PROCEDURE.

PROCEDURE wt-it-docto:
    PUT "wt-it-docto.........." SKIP.
    PUT "it-codigo; nr-docum" SKIP.
    FOR EACH wt-it-docto         WHERE 
                                  wt-it-docto.nat-operacao = v_nat-oper or
                                  wt-it-docto.nat-docum = v_nat-oper:

        PUT wt-it-docto.it-codigo ";"
            wt-it-docto.nr-docum
            SKIP.
END.
END PROCEDURE.


PROCEDURE it-ped-venda:

PUT "ped-venda............" SKIP.
PUT "cod-est; nome; nr-pedido-cl; nr-pedido; emitente" SKIP.
              FOR EACH ped-venda WHERE
                     ped-venda.cod-sit-ped = i-cont NO-LOCK,
                EACH ped-item OF ped-venda
                WHERE ped-item.cod-sit-item < 3 AND
                      ped-item.nat-operacao = v_nat-oper NO-LOCK:

                  PUT ped-venda.cod-estabel ";"
                      ped-venda.nome-abrev ";"
                      ped-venda.nr-pedcli ";"
                      ped-venda.nr-pedido ";"
                      ped-venda.cod-emitente
                      SKIP.
END.

END PROCEDURE.
