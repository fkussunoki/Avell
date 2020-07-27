/*****************************************************************
**
** I-IMARQ - Choose of bt-Arquivo no template de importação
**
*****************************************************************/

    def var c-arq-conv  as char no-undo.

    assign c-arq-conv = replace(input frame {2} {1}, "/", "~\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS &IF "{3}" <> "" &THEN {3} 
               &ENDIF
               &IF "{3}" = "" &THEN
               "*.lst" "*.lst",
               "*.*" "*.*"         
               &ENDIF      
       &IF '{1}' <> 'c-arquivo-entrada' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign {1} = replace(c-arq-conv, "~\", "/").
        display {1} with frame {2}.
    end.
     

     
/* i-imarq */
