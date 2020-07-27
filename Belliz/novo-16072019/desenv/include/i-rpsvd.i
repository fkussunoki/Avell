/*****************************************************************
**
** I-RPSVD.I - Bot∆o Salvar Digitaá∆o             
**
*****************************************************************/

define var r-tt-digita as rowid no-undo.

SYSTEM-DIALOG GET-FILE c-arq-digita
   FILTERS "*.dig" "*.dig",
           "*.*" "*.*"
   ASK-OVERWRITE 
   DEFAULT-EXTENSION "*.dig"
   SAVE-AS             
   CREATE-TEST-FILE
   USE-FILENAME
   UPDATE l-ok.

if avail tt-digita then assign r-tt-digita = rowid(tt-digita).

if l-ok then do:
    output to value(c-arq-digita).
    for each tt-digita:
        export tt-digita.
    end.
    output close. 
    
    reposition br-digita to rowid(r-tt-digita) no-error.
end.

/* i-rpsvd.i */
