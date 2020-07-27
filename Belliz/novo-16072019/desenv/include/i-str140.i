  /***************************************************************
**
** I-STR140.I - Ap½s abrir o browse da estrutura
** 
***************************************************************/
if  v-row-temp-table <> ?
then do:
    find first tt-str no-lock use-index tt-id no-error.
    if available tt-str 
    then do:
       assign v-row-temp-table = rowid( tt-str ).
    end.
end.  /* if */

if  v-row-temp-table <> ? 
then do:
    reposition br-str to rowid v-row-temp-table.
end . /* if */

apply "value-changed":U to br-str in frame {&frame-name}. 
      /* I-STR140.I */
