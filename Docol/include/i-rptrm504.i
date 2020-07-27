/**************************************************************************
**
** I-RPTRM - Realiza o destino de impressÆo Terminal
**
***************************************************************************/

DEFINE VARIABLE c-key-value AS CHARACTER NO-UNDO.

IF  rs-destino = 3 THEN DO:
    
    GET-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE c-key-value.
    
    IF  c-key-value = "":U OR c-key-value = ?  THEN DO:
        ASSIGN c-key-value = "Notepad.exe":U.
        PUT-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE c-key-value no-error.
    END.
   
    /*DOS SILENT Notepad.exe VALUE(tt-param.arquivo).*/
    /*DOS SILENT Notepad.exe VALUE(c-key-value + chr(32) + tt-param.arquivo).*/
    
    /* A versão original da include traz o os-command como padrão, porém
       optamos por mudar isso o winexec para não piscar uma tela em dos */
    /*OS-COMMAND NO-WAIT VALUE(c-key-value + chr(32) + tt-param.arquivo).  */
    
    RUN winexec (INPUT c-key-value + CHR(32) + c-arquivo, INPUT 1).

     /*{&OPEN-QUERY-{&BROWSE-NAME}}*/

END.

/* i-rptrm */
