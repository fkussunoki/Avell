/***************************************************************
**
** I-STR120.I - Expandir estrutura
** 
***************************************************************/ 
    define input parameter v-row-structure as rowid no-undo.
    
    define var v-num-level     as integer no-undo.
    define var v-num-level-aux as integer no-undo.
        
    define buffer b-tt-str for tt-str.
    
    expande-tudo:
    do on error undo expande-tudo, leave expande-tudo:

        find b-tt-str where rowid(b-tt-str) = v-row-structure no-lock no-error.
        assign v-num-level     = b-tt-str.ttv-num-level
               v-num-level-aux = v-num-level.

        run pi-expand-structure (input v-row-structure).

        find b-tt-str where rowid(b-tt-str) = v-row-structure no-lock no-error.
        find next b-tt-str no-lock
             where b-tt-str.ttv-num-level >= v-num-level
             use-index tt-id no-error.

        expande-filho:
        do while avail b-tt-str and b-tt-str.ttv-num-level > v-num-level-aux:
           if  b-tt-str.ttv-log-child = yes
           then do:
               v-row-structure = rowid(b-tt-str).
               run pi-expand-structure (input v-row-structure).
               assign v-num-level = v-num-level-aux.
               find b-tt-str where rowid(b-tt-str) = v-row-structure no-lock no-error.
           end /* if */.
           find next b-tt-str no-lock
               where b-tt-str.ttv-num-level >= v-num-level
               use-index tt-id no-error.
        end /* do expande-filho */.

    end /* do expande-tudo */.
/* I-STR120.I */    
