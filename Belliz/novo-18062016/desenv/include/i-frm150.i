/***************************************************************
**
** I-frm150.I - Mostra o registro pai
** 
***************************************************************/ 
  find {&table-parent} where rowid({&table-parent}) = v-row-parent no-lock no-error.
  if  not avail {&table-parent}
  then do:
      stop.
  end /* if */.
  display {&FIELDS-IN-QUERY-{&FRAME-NAME}} with frame {&frame-name}.  
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

/* i-frm150 */
