/*****************************************************************
**
** I-RPARQ - Choose of bt-Arquivo no template de relat¢rio
**
*****************************************************************/

    def var c-arq-conv  as char no-undo.

    /* tech1139 - FO 1223.694  - 02/11/2005 */
    assign c-arq-conv = replace(input frame f-pg-imp c-arquivo, "/", CHR(92)).
    /* tech1139 - FO 1223.694  - 02/11/2005 */

    
/*tech14178 modificado para apresentar dialog com extens∆o PDF quando o mesmo estiver sendo usado */
&IF "{&PDF}" = "YES" &THEN /*tech868*/
    
    IF NOT usePDF() THEN

&ENDIF
    
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.lst" "*.lst",
                   "*.*" "*.*"
           ASK-OVERWRITE 
           DEFAULT-EXTENSION "lst"
           INITIAL-DIR "spool" 
           SAVE-AS
           USE-FILENAME
           UPDATE l-ok.

&IF "{&PDF}" = "YES" &THEN /*tech868*/
   ELSE
       SYSTEM-DIALOG GET-FILE c-arq-conv
          FILTERS "*.pdf" "*.pdf",
                  "*.*" "*.*"
          ASK-OVERWRITE 
          DEFAULT-EXTENSION "pdf"
          INITIAL-DIR "spool" 
          SAVE-AS
          USE-FILENAME
          UPDATE l-ok.

&endif


    if  l-ok = yes then do:
        /* tech1139 - FO 1223.694  - 02/11/2005 */
        assign c-arquivo = replace(c-arq-conv, CHR(92), "/"). 
        /* tech1139 - FO 1223.694  - 02/11/2005 */
        display c-arquivo with frame f-pg-imp.
    end.

/* i-rparq */
