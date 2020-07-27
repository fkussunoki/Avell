def var qtde-item as dec no-undo.
def var l-logico as logical no-undo initial no.
for each nota-fiscal no-lock where nota-fiscal.dt-emis-nota >= 05/01/2020
                             and   nota-fiscal.dt-emis-nota <= 05/31/2020
                             and   nota-fiscal.dt-cancela   = ?
                             and   nota-fiscal.emite-duplic = yes:

                                
      for each it-nota-fisc no-lock of nota-fiscal break by it-nota-fisc.nr-nota-fis:

        find first devol-cli no-lock where devol-cli.it-codigo = it-nota-fisc.it-codigo
                                     and   devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                     and   devol-cli.serie     = it-nota-fisc.serie no-error.

                                     if avail devol-cli then 
                                     assign l-logico = yes.
                                     else
                                     assign l-logico = no.

            accumulate it-nota-fisc.qt-faturada[1] (sub-total by it-nota-fisc.nr-nota-fis).
            if first-of(it-nota-fisc.nr-nota-fis) then do:
                assign qtde-item = 0.
            end.

            if last-of(it-nota-fisc.nr-nota-fis) then do:
                assign qtde-item = accum sub-total by it-nota-fisc.nr-nota-fis it-nota-fisc.qt-faturada[1].
            end.
      end.      

    find first repres no-lock where repres.cod-rep = nota-fiscal.cod-rep no-error.

                for each fat-duplic no-lock where fat-duplic.nr-fatura = nota-fiscal.nr-fatura
                                              and   fat-duplic.serie     = nota-fiscal.serie
                                              and   fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                                              break by fat-duplic.cod-estabel
                                                    by fat-duplic.nr-fatura:


                        accumulate fat-duplic.vl-comis (sub-total by fat-duplic.nr-fatura).

                        if last-of(fat-duplic.nr-fatura) then do:
                                                    
                disp 
                     nota-fiscal.cod-emitente column-label "Codigo cliente"
                     nota-fiscal.nome-ab-cli  column-label "Nome Cliente"
                     repres.nome-abrev     column-label "Representante"
                     nota-fiscal.cod-estabel column-label "Estab"
                     nota-fiscal.nr-fatura   column-label "NF"
                     nota-fiscal.serie       column-label "Serie"
                     qtde-item               column-label "Qtde"
                     nota-fiscal.vl-merc-tot-fat column-label "Total Mercadorias"
                     nota-fiscal.vl-tot-ipi      column-label "IPI"
                     nota-fiscal.vl-frete        column-label "Frete"
                     nota-fiscal.vl-tot-nota     column-label "Vlr. NF"
                     (accum sub-total by fat-duplic.nr-fatura fat-duplic.vl-comis)          column-label "Base Calculo"
                     repres.comis-direta         column-label "% Comissao"
                     (accum sub-total by fat-duplic.nr-fatura fat-duplic.vl-comis) * (repres.comis-direta / 100)          column-label "Comissao"
                     l-logico column-label "Devolucao"
                     with stream-io width 600.
                end.
            end.        
end.                     