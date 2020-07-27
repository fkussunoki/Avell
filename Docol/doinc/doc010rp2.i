IF rt-tipo-relat = 2 THEN DO: /*Detalhado*/

    FOR EACH tt-detalhe
        BREAK BY tt-detalhe.ep-codigo
              BY tt-detalhe.cod-estabel
              BY tt-detalhe.cc-codigo
              BY tt-detalhe.dt-trans
              BY tt-detalhe.cc-codigo
              BY tt-detalhe.serie-docto
              BY tt-detalhe.nro-docto
              BY tt-detalhe.cod-emit:
        
        DISP tt-detalhe.ep-codigo    COLUMN-LABEL "Emp"    
             tt-detalhe.cod-estabel  COLUMN-LABEL "Est"     FORMAT "x(3)"
             tt-detalhe.cc-codigo    COLUMN-LABEL "C.C."    FORMAT "99999"
             tt-detalhe.serie-docto  COLUMN-LABEL "Ser"     FORMAT "x(3)"
             tt-detalhe.nro-docto    COLUMN-LABEL "Nr.NF"   
             tt-detalhe.cod-emit     COLUMN-LABEL "Emiten"  FORMAT ">>>>>>>>9" // Chamado 76043 - campo aumentado para tamanho igual ao do banco de dados - ">>>>9"
             tt-detalhe.dt-trans     COLUMN-LABEL "Data"    FORMAT "99/99/9999"
             tt-detalhe.nat-operacao COLUMN-LABEL "Nat.Op"  FORMAT "x(6)"
             tt-detalhe.rec-devol    COLUMN-LABEL "Receita" FORMAT "->>>>>,>>9.99"
             tt-detalhe.vl-icms      COLUMN-LABEL "ICMS"    FORMAT "->>>>>,>>9.99"
             tt-detalhe.vl-icms-st   COLUMN-LABEL "ICMS ST" FORMAT "->>>>>,>>9.99"
             tt-detalhe.vl-cpv-var   COLUMN-LABEL "CPV Var" FORMAT "->>>>>,>>9.99"
             tt-detalhe.vl-cpv-cif   COLUMN-LABEL "CPV Fix" FORMAT "->>>>>,>>9.99"
             tt-detalhe.vl-cpv-var + tt-detalhe.vl-cpv-cif @ vl-cpv-tot
             WITH FRAME f-detalhado DOWN WIDTH 300 STREAM-IO.
        DOWN WITH FRAME f-detalhado.

        ACCUMULATE tt-detalhe.rec-devol  (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-cpv-var (TOTAL by tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-cpv-cif (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-icms    (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).
        ACCUMULATE tt-detalhe.vl-icms-st (TOTAL BY tt-detalhe.ep-codigo BY tt-detalhe.cod-estabel BY tt-detalhe.cc-codigo).

        IF LAST-OF(tt-detalhe.cc-codigo) THEN DO:
           UNDERLINE tt-detalhe.rec-devol
                     tt-detalhe.vl-cpv-var
                     tt-detalhe.vl-cpv-cif
                     tt-detalhe.vl-icms   
                     tt-detalhe.vl-icms-st
                     vl-cpv-tot WITH FRAME f-detalhado.
           DOWN WITH FRAME f-detalhado.
           DISP "Total C.C." @ tt-detalhe.cod-emit
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.rec-devol)  @ tt-detalhe.rec-devol 
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-cpv-var) @ tt-detalhe.vl-cpv-var
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-cpv-cif) @ tt-detalhe.vl-cpv-cif
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-icms   ) @ tt-detalhe.vl-icms   
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-icms-st) @ tt-detalhe.vl-icms-st
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-cpv-var) +
                (ACCUM TOTAL BY tt-detalhe.cc-codigo tt-detalhe.vl-cpv-cif) @ vl-cpv-tot WITH FRAME f-detalhado.
           DOWN 1 WITH FRAME f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.cod-estabel) THEN DO:
            UNDERLINE tt-detalhe.rec-devol            
                      tt-detalhe.vl-cpv-var
                      tt-detalhe.vl-cpv-cif
                      tt-detalhe.vl-icms   
                      tt-detalhe.vl-icms-st
                      vl-cpv-tot WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.

            DISP "Total Est." @ tt-detalhe.cod-emit
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.rec-devol)  @ tt-detalhe.rec-devol               
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-cpv-var) @ tt-detalhe.vl-cpv-var              
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-cpv-cif) @ tt-detalhe.vl-cpv-cif
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-icms   ) @ tt-detalhe.vl-icms
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-icms-st) @ tt-detalhe.vl-icms-st
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-cpv-var) +
                  (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.vl-cpv-cif) @ vl-cpv-tot WITH STREAM-IO FRAME f-detalhado.
            DOWN 1 WITH FRAME f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.ep-codigo) THEN DO:
           UNDERLINE tt-detalhe.rec-devol            
                     tt-detalhe.vl-cpv-var
                     tt-detalhe.vl-cpv-cif
                     tt-detalhe.vl-icms   
                     tt-detalhe.vl-icms-st
                     vl-cpv-tot WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.
            
            DISP "Total Emp." @ tt-detalhe.cod-emit
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.rec-devol)  @ tt-detalhe.rec-devol               
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-cpv-var) @ tt-detalhe.vl-cpv-var              
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-cpv-cif) @ tt-detalhe.vl-cpv-cif
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-icms   ) @ tt-detalhe.vl-icms
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-icms-st) @ tt-detalhe.vl-icms-st
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-cpv-var) + 
                  (ACCUM TOTAL BY tt-detalhe.ep-codigo tt-detalhe.vl-cpv-cif) @ vl-cpv-tot WITH FRAME f-detalhado.
        END.
        DELETE tt-detalhe.
    END.
END. /* if l-detalhado ... */

IF rt-tipo-relat = 1 THEN DO: /*Resumido*/

    FOR EACH tt-resumo
        BREAK BY tt-resumo.ep-codigo
              BY tt-resumo.cod-estabel
              BY tt-resumo.cc-codigo:
        
        DISP tt-resumo WITH FRAME f-resumido DOWN WIDTH 300 STREAM-IO.

        DISP tt-resumo.vl-cpv-var + tt-resumo.vl-cpv-cif @ vl-cpv-tot WITH FRAME f-resumido WIDTH 132.
        DOWN WITH FRAME f-resumido WIDTH 132.

        ACCUMULATE tt-resumo.vl-total   (TOTAL BY tt-resumo.ep-codigo BY tt-resumo.cod-estabel).
        ACCUMULATE tt-resumo.vl-cpv-var (TOTAL BY tt-resumo.ep-codigo BY tt-resumo.cod-estabel).
        ACCUMULATE tt-resumo.vl-cpv-cif (TOTAL BY tt-resumo.ep-codigo BY tt-resumo.cod-estabel).
        ACCUMULATE tt-resumo.vl-icms    (TOTAL BY tt-resumo.ep-codigo BY tt-resumo.cod-estabel).
        ACCUMULATE tt-resumo.vl-icms-st (TOTAL BY tt-resumo.ep-codigo BY tt-resumo.cod-estabel).

        IF LAST-OF(tt-resumo.cod-estabel) THEN DO:
           UNDERLINE tt-resumo.vl-total
                     tt-resumo.vl-cpv-var       
                     tt-resumo.vl-cpv-cif
                     tt-resumo.vl-icms   
                     tt-resumo.vl-icms-st
                     vl-cpv-tot WITH FRAME f-resumido WIDTH 132.
           DOWN WITH FRAME f-resumido WIDTH 132.

           DISP "Total Est." @ tt-resumo.cc-codigo
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-total)   @ tt-resumo.vl-total
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-cpv-var) @ tt-resumo.vl-cpv-var 
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-cpv-cif) @ tt-resumo.vl-cpv-cif 
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-icms   ) @ tt-resumo.vl-icms
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-icms-st) @ tt-resumo.vl-icms-st

                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-cpv-var) + 
                (ACCUM TOTAL BY tt-resumo.cod-estabel tt-resumo.vl-cpv-cif) @ vl-cpv-tot                
                 WITH FRAME f-resumido WIDTH 132.
           DOWN 1 WITH FRAME f-resumido WIDTH 132.
        END. /* if last-of ... */

        IF LAST-OF(tt-resumo.ep-codigo) THEN DO:
           UNDERLINE tt-resumo.vl-total
                     tt-resumo.vl-cpv-var     
                     tt-resumo.vl-cpv-cif
                     tt-resumo.vl-icms   
                     tt-resumo.vl-icms-st
                     vl-cpv-tot WITH FRAME f-resumido WIDTH 132.
           DOWN WITH FRAME f-resumido WIDTH 132.

           DISP "Total Emp." @ tt-resumo.cc-codigo
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-total)   @ tt-resumo.vl-total
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-cpv-var) @ tt-resumo.vl-cpv-var 
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-cpv-cif) @ tt-resumo.vl-cpv-cif 
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-icms   ) @ tt-resumo.vl-icms
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-icms-st) @ tt-resumo.vl-icms-st
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-cpv-var) + 
                (ACCUM TOTAL BY tt-resumo.ep-codigo tt-resumo.vl-cpv-cif) @ vl-cpv-tot WITH FRAME f-resumido WIDTH 132.
        END. 
        DELETE tt-resumo.
    END.
END. /* if l-resumido ... */
