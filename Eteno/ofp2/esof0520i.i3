/****************************************************************************
**
** esof0520.i3 - Substitui o proprama OG0520G3.P
**
**************************************************************************/

if (c-estado       <> doc-fiscal.estado and
    c-estado       <> "RS"              and
    c-estado       <> "SC"              and
    c-estado       <> "PR"              and
    doc-fiscal.pais = "Brasil")         or
   ((c-estado       = "RS"              or              
     c-estado       = "PR"              or
     c-estado       = "SC")             and
    doc-fiscal.pais = "Brasil")         then do:

/* if c-estado <> doc-fiscal.estado and doc-fiscal.pais = "Brasil" then do: */
    find tt-tab-ocor use-index codigo
        where  tt-tab-ocor.cod-tab    = 249
        and    tt-tab-ocor.c-campo1 = c-usuario
        and    tt-tab-ocor.c-campo2 = doc-fiscal.estado
        and    tt-tab-ocor.l-campo1 = no /* resumo por uf */ no-error.  

    if  not avail tt-tab-ocor then do:
        /*find last tt-tab-ocor 
            where tt-tab-ocor.cod-tab = 249 no-lock no-error.
        assign i-aux-1 = (if avail tt-tab-ocor then tt-tab-ocor.cod-ocor else 0) + 1.*/
        create tt-tab-ocor.
        assign tt-tab-ocor.cod-tab    = 249
               tt-tab-ocor.cod-ocor   = i-aux-1
               tt-tab-ocor.c-campo1 = c-usuario
               tt-tab-ocor.c-campo2 = doc-fiscal.estado
               tt-tab-ocor.l-campo1 = no. /* resumo por uf */
    end.

    &if '{&bf_dis_versao_ems}' = '2.04' or '{&bf_dis_versao_ems}' = '2.05' &then
        if  l-considera-icms-st then
            assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-tot-item.
        else
            assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + (it-doc-fisc.vl-tot-item - it-doc-fisc.dec-2).
    &elseif '{&bf_dis_versao_ems}' >= '2.06' &then
        if  l-considera-icms-st then
            assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-tot-item.
        else
            assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + (it-doc-fisc.vl-tot-item - it-doc-fisc.val-icms-subst-entr).
    &else
        assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-tot-item.
    &endif

    assign tt-tab-ocor.de-campo2 = tt-tab-ocor.de-campo2 + it-doc-fisc.vl-bsubs-it
           tt-tab-ocor.de-campo3 = tt-tab-ocor.de-campo3 + it-doc-fisc.vl-icmsub-it            
           tt-tab-ocor.de-campo4 = tt-tab-ocor.de-campo4 + it-doc-fisc.vl-bicms-it
           tt-tab-ocor.de-campo5 = tt-tab-ocor.de-campo5 + (IF  doc-fiscal.tipo-nat = 3 
                                                            AND AVAIL natur-oper 
                                                            AND natur-oper.cd-trib-icm = 3
                                                                THEN it-doc-fisc.vl-tot-item 
                                                                ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                                         THEN it-doc-fisc.vl-icmsou-it
                                                                         ELSE 0 ). 
end.
/* Fim da include */
