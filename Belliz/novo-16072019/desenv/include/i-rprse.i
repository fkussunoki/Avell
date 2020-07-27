/****************************************************************
**
** I-RPRSE.I - Gatilho "Value-Changed" de rs-execucao 
**
*****************************************************************/

ASSIGN rs-execucao.

IF rs-execucao = 2 THEN DO:
    IF rs-destino:SCREEN-VALUE IN FRAME f-pg-imp <> "1":U THEN
        ASSIGN rs-destino:SCREEN-VALUE IN FRAME f-pg-imp = "2":U
               c-arquivo       = IF c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = "":U
                                 THEN IF c-arquivo = "" 
                                      THEN c-arq-old
                                      ELSE c-arquivo
                                 ELSE c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp
               c-arq-old       = c-arquivo
               c-arq-old-batch = SUBSTRING(c-arquivo, R-INDEX(c-arquivo, "/":U) + 1)
               c-arquivo:screen-value = c-arq-old-batch.
    
    
    APPLY "VALUE-CHANGED":U TO rs-destino IN FRAME f-pg-imp.

    IF c-arq-old-batch NE "" THEN /* Por Thiago Garcia ref. FO 901.132 */
        
    
    ASSIGN c-arquivo.
    
    rs-destino:DISABLE(c-terminal) IN FRAME f-pg-imp.
    /*Alterado tech1007 - 14/02/2005 - Removido pois a op‡Æo de RTF foi removida
      do rs-destino
    &IF "{&RTF}":U = "YES":U &THEN
        rs-destino:DISABLE(c-rtf) IN FRAME f-pg-imp.
    &ENDIF
    Fim alteracao tech1007 - 14/02/2005*/
END.
ELSE DO:
    IF rs-destino:SCREEN-VALUE IN FRAME f-pg-imp <> "1":U THEN
        ASSIGN c-arquivo       = IF c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = "":U
                                 THEN c-arquivo
                                 ELSE c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp
               c-arq-old-batch = c-arquivo.
    
    APPLY "VALUE-CHANGED":U TO rs-destino IN FRAME f-pg-imp.
    
    rs-destino:ENABLE(c-terminal) IN FRAME f-pg-imp.
    /*Alterado tech1007 - 14/02/2005 - Removido pois a op‡Æo de RTF foi removida
      do rs-destino
    &IF "{&RTF}":U = "YES":U &THEN
        rs-destino:ENABLE(c-rtf) IN FRAME f-pg-imp.
    &ENDIF
    Fim alteracao tech1007 - 14/02/2005*/
    ASSIGN c-arquivo.
END.
