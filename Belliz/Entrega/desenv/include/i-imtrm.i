/**************************************************************************
**
** I-IMTRM - Realiza o destino de impress’o Terminal
**
***************************************************************************/

def var c-key-value as char no-undo.
if  {2} = 3 then do:
    get-key-value section "Datasul_EMS2":U key "Show-Report-Program":U value c-key-value.
    if  c-key-value = "" or  c-key-value = ?  then do:
        assign c-key-value = 'Notepad.exe':U.
        put-key-value section "Datasul_EMS2":U key "Show-Report-Program":U value c-key-value no-error.
    end.
    
    run WinExec (input c-key-value + chr(32) + {1}, input 1).
    {&OPEN-QUERY-{&BROWSE-NAME}}
end.
/* i-imtrm */
