/***************************************************************
**
** I-STR110.I - Fechar n¡vel da estrutura corrente
** 
***************************************************************/ 
define input parameter v-row-tt as rowid no-undo.
define var v-num-level     as integer no-undo.
define var v-num-count     as integer no-undo.
define var v-num-seq-ini   as integer no-undo.
define var v-num-seq-fim   as integer no-undo.
define var v-cod-pai       like tt-str.tta-cod-cta-ctbl-filho no-undo.
   

collapse:
do on error undo collapse, leave collapse:
   
              
    find tt-str where rowid(tt-str) = v-row-tt no-lock no-error.
    
    assign v-num-seq-ini   = tt-str.ttv-num-seq
           v-num-level            = tt-str.ttv-num-level
           v-num-count            = 0    
           tt-str.ttv-log-expand  = no.
    find next tt-str no-lock
         where tt-str.ttv-num-level <= v-num-level
         use-index tt-id no-error.
    if  avail tt-str
    then do:
        assign v-num-seq-fim = tt-str.ttv-num-seq.
    end /* if */.
    else do:
        assign v-num-seq-fim = ?.
    end /* else */.

    erase:
    for each tt-str exclusive-lock
     where tt-str.ttv-num-seq > v-num-seq-ini
       and tt-str.ttv-num-seq < v-num-seq-fim
     use-index tt-id :
         delete tt-str.
         assign v-num-count = v-num-count + 10.
    end /* for erase */.

    if  v-num-seq-fim <> ?
    then do:
        assign v-num-seq-ini = v-num-seq-ini + v-num-count.

        decrease:
        repeat preselect each tt-str exclusive-lock use-index tt-id:
             find next tt-str 
                  where tt-str.ttv-num-seq > v-num-seq-ini.
             assign tt-str.ttv-num-seq = tt-str.ttv-num-seq - v-num-count.
        end /* repeat decrease */.
    end /* if */.

end /* do collapse */.
