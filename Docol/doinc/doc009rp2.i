if rt-tipo-relat = 1 then do:
   for each tt-resumo
      break by tt-resumo.ep-codigo
            by tt-resumo.cod-estabel
            by tt-resumo.ct-codigo
            by tt-resumo.cc-codigo:
  
      ASSIGN de-total = tt-resumo.vl-mat + tt-resumo.vl-mob + tt-resumo.vl-impostos.
      
      disp tt-resumo.ep-codigo
           tt-resumo.cod-estabel
           tt-resumo.ct-codigo   COLUMN-LABEL 'Conta'
           tt-resumo.cc-codigo   COLUMN-LABEL 'CCusto'
           tt-resumo.vl-mat      COLUMN-LABEL 'CPV Variavel'
           tt-resumo.vl-mob      COLUMN-LABEL 'CPV Fixo'
           tt-resumo.vl-impostos COLUMN-LABEL 'Impostos'
           de-total              COLUMN-LABEL 'Total' FORMAT "->>>,>>>,>>9.99"
           with frame f-resumido STREAM-IO width 300 down.
      down with frame f-resumido.

      accumulate tt-resumo.vl-mat      (total by tt-resumo.ep-codigo by tt-resumo.cod-estabel BY tt-resumo.ct-codigo).
      accumulate tt-resumo.vl-mob      (total by tt-resumo.ep-codigo by tt-resumo.cod-estabel BY tt-resumo.ct-codigo).
      accumulate tt-resumo.vl-impostos (total by tt-resumo.ep-codigo by tt-resumo.cod-estabel BY tt-resumo.ct-codigo).
      accumulate de-total            (total by tt-resumo.ep-codigo by tt-resumo.cod-estabel BY tt-resumo.ct-codigo).

      if last-of(tt-resumo.ct-codigo) then do:
         underline tt-resumo.vl-mat 
                   tt-resumo.vl-mob 
                   tt-resumo.vl-impostos
                   de-total with frame f-resumido.
         down with frame f-resumido.
         disp "Total Conta" @ tt-resumo.ct-codigo
              (accum total by tt-resumo.ct-codigo tt-resumo.vl-mat)      @ tt-resumo.vl-mat
              (accum total by tt-resumo.ct-codigo tt-resumo.vl-mob)      @ tt-resumo.vl-mob 
              (accum total by tt-resumo.ct-codigo tt-resumo.vl-impostos) @ tt-resumo.vl-impostos
              (accum total by tt-resumo.ct-codigo de-total)            @ de-total with frame f-resumido.
         down 1 with frame f-resumido.
      end. /* if last-of */

      if last-of(tt-resumo.cod-estabel) then do:
         underline tt-resumo.vl-mat 
                   tt-resumo.vl-mob
                   tt-resumo.vl-impostos
                   de-total with frame f-resumido.
         down with frame f-resumido.
         disp "Total Estab" @ tt-resumo.ct-codigo
              (accum total by tt-resumo.cod-estabel tt-resumo.vl-mat)      @ tt-resumo.vl-mat
              (accum total by tt-resumo.cod-estabel tt-resumo.vl-mob)      @ tt-resumo.vl-mob 
              (accum total by tt-resumo.cod-estabel tt-resumo.vl-impostos) @ tt-resumo.vl-impostos
              (accum total by tt-resumo.cod-estabel de-total)            @ de-total with frame f-resumido.
         down 1 with frame f-resumido.
      end. /* if last-of */
      
      if last-of(tt-resumo.ep-codigo) then do:
         underline tt-resumo.vl-mat
                   tt-resumo.vl-mob 
                   tt-resumo.vl-impostos
                   de-total with frame f-resumido.
         down with frame f-resumido.
         disp "Total Empres" @ tt-resumo.ct-codigo
              (accum total by tt-resumo.ep-codigo tt-resumo.vl-mat)      @ tt-resumo.vl-mat
              (accum total by tt-resumo.ep-codigo tt-resumo.vl-mob)      @ tt-resumo.vl-mob 
              (accum total by tt-resumo.ep-codigo tt-resumo.vl-impostos) @ tt-resumo.vl-impostos
              (accum total by tt-resumo.ep-codigo de-total)            @ de-total with frame f-resumido.
      END. /* if last-of */
   END. /* for each tt-resumo */
END. /* if rt-tipo-relat = 1 */


IF rt-tipo-relat = 2 THEN DO:
    FOR EACH tt-detalhe WHERE
        BREAK BY tt-detalhe.ep-codigo
              BY tt-detalhe.cod-estabel
              BY tt-detalhe.ct-codigo
              BY tt-detalhe.cc-codigo
              BY tt-detalhe.serie
              BY tt-detalhe.nr-nota-fis:

        FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = tt-detalhe.cod-emitente NO-ERROR.

        DISP tt-detalhe.ep-codigo   
             tt-detalhe.cod-estabel 
             tt-detalhe.ct-codigo                COLUMN-LABEL 'Conta'             FORMAT "x(6)"
             tt-detalhe.cc-codigo                COLUMN-LABEL 'CCusto'            FORMAT "x(5)" 
             tt-detalhe.serie                    COLUMN-LABEL 'S‚rie'             FORMAT "x(3)"
             tt-detalhe.nr-nota-fis              COLUMN-LABEL "Nr Nota"           FORMAT "x(8)" 
             emitente.cod-emitente               COLUMN-LABEL "Codigo"            
             emitente.nome-abrev                 COLUMN-LABEL "Nome Abrev"        FORMAT "x(12)"
             tt-detalhe.it-codigo                COLUMN-LABEL "Item"              FORMAT "x(10)" 
             tt-detalhe.desc-item                COLUMN-LABEL "Descricao"         
             tt-detalhe.vl-mat                   COLUMN-LABEL "Valor!Material"    FORMAT "->>,>>>,>>9.99"
             tt-detalhe.vl-mob                   COLUMN-LABEL "Valor!Mao-de-obra" FORMAT "->>,>>>,>>9.99"
             tt-detalhe.vl-impostos              COLUMN-LABEL "Valor!Impostos"    FORMAT "->>,>>>,>>9.99"             
             WITH STREAM-IO FRAME f-detalhado DOWN WIDTH 300.
        DOWN WITH FRAME f-detalhado.           

        ACCUMULATE tt-detalhe.vl-mat      (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-mob      (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-impostos (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).

        IF LAST-OF(tt-detalhe.cc-codigo) THEN DO:
            UNDERLINE tt-detalhe.vl-mat
                      tt-detalhe.vl-mob 
                      tt-detalhe.vl-impostos WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.
            DISP "Total CCusto" @ tt-detalhe.desc-item 
                 (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-mat)      @ tt-detalhe.vl-mat
                 (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-mob)      @ tt-detalhe.vl-mob 
                 (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-impostos) @ tt-detalhe.vl-impostos WITH FRAME f-detalhado.
            DOWN 1 WITH FRAME f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.cod-estabel) THEN DO:
            UNDERLINE tt-detalhe.vl-mat
                      tt-detalhe.vl-mob 
                      tt-detalhe.vl-impostos WITH frame f-detalhado.
            DOWN WITH FRAME f-detalhado.
            DISP "Total Estab" @ tt-detalhe.desc-item 
                 (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-mat)      @ tt-detalhe.vl-mat
                 (ACCUM total BY tt-detalhe.cod-estabel tt-detalhe.vl-mob)      @ tt-detalhe.vl-mob 
                 (ACCUM total BY tt-detalhe.cod-estabel tt-detalhe.vl-impostos) @ tt-detalhe.vl-impostos WITH FRAME f-detalhado.
            DOWN 1 with frame f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.ep-codigo) THEN DO:
            UNDERLINE tt-detalhe.vl-mat
                      tt-detalhe.vl-mob 
                      tt-detalhe.vl-impostos WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.
            DISP "Total Empres" @ tt-detalhe.desc-item /*tt-detalhe.nr-nota-fis*/
                 (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-mat)      @ tt-detalhe.vl-mat
                 (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-mob)      @ tt-detalhe.vl-mob 
                 (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-impostos) @ tt-detalhe.vl-impostos WITH FRAME f-detalhado.
        END.
        DELETE tt-detalhe.
    END.




END. /* if rt-tipo-relat = 2 */




/* doc009rp2.i */
