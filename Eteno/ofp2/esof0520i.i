/*****************************************************************************
**  INCLUDE: esof0520I.I
**  OBJETIVO: CRIAR O temp-table tt-cred-com CASO A CONDICAO SEJA SATISFEITA
**  {1} -> VALOR DE ICMS TRIBUTADO  
**  {2} -> TIPO DE REGISTRO
**  {3} -> ALIQUOTA DE ICMS
******************************************************************************/

&IF DEFINED(bf_dis_formato_CFOP) &THEN
    &GLOBAL-DEFINE COD-CFOP       doc-fiscal.cod-cfop
&ELSE
    &GLOBAL-DEFINE COD-CFOP       trim(substr(doc-fiscal.char-1,1,4))
&ENDIF

if  c-estado = "MG" and {1} > 0 and doc-fiscal.vl-icms-com > 0 then do:
    find first tt-cred-com 
         where tt-cred-com.nat-operacao = (IF doc-fiscal.dt-docto < da-dt-cfop
                                            THEN substring(doc-fiscal.nat-operacao,1,3) 
                                            ELSE {&COD-CFOP})
         and   tt-cred-com.c-aliquota   = {3}
         and   tt-cred-com.c-resumo     = "{2}"
         no-error.

    if  not avail tt-cred-com then do:
        create tt-cred-com.
        assign tt-cred-com.nat-operacao = (IF doc-fiscal.dt-docto < da-dt-cfop
                                            THEN SUBSTR(doc-fiscal.nat-operacao,1,3)
                                            ELSE {&COD-CFOP})
               tt-cred-com.c-aliquota   = {3}
               tt-cred-com.c-resumo     = "{2}".
    end.

     
    assign tt-cred-com.vl-icms-com =  tt-cred-com.vl-icms-com 
                                   + doc-fiscal.vl-icms-com.
end.
