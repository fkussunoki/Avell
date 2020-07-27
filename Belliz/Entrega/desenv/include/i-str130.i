/***************************************************************
**
** I-STR130.I - Trecho da pi-expand-structure onde faz o acerto
**              da posi‡Æo dos ¡tens inseridos
** 
***************************************************************/ 
    increm:
       repeat preselect each b-tt-str exclusive-lock use-index tt-id-descending:

            find next  b-tt-str 
                 where b-tt-str.ttv-num-seq > v-num-seq-ini.
            assign b-tt-str.ttv-num-seq = b-tt-str.ttv-num-seq + v-num-count.

       end /* repeat increm */.

       insere:
       for each b-tt-str exclusive-lock
         where b-tt-str.ttv-num-seq < 0 :
            assign v-num-seq-ini = v-num-seq-ini + 10.
            assign b-tt-str.ttv-num-seq = v-num-seq-ini.
       end /* for insere */.
        
   end /* do expand-block */ .
   /* I-STR130.I */    
