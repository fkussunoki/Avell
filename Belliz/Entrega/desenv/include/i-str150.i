/***************************************************************
**
** I-STR150.I - Mostra o registro pai
** 
***************************************************************/ 
find {&table-parent} where rowid({&table-parent}) = v-row-parent-str no-lock no-error.
  if  not avail {&table-parent}
  then do:
      stop.
  end /* if */.
  display {&FIELDS-IN-QUERY-{&FRAME-NAME}} with frame {&frame-name}.  

