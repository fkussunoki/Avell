/*****************************************************************
**
** I-RPRCD.I - Bot’o Recuperar Digita»’o             
**
*****************************************************************/

SYSTEM-DIALOG GET-FILE c-arq-digita
   FILTERS "*.dig" "*.dig",
           "*.*" "*.*"
   DEFAULT-EXTENSION "*.dig"
   MUST-EXIST
   USE-FILENAME
   UPDATE l-ok.
if l-ok then do:
    for each tt-digita:
        delete tt-digita.
    end.
    input from value(c-arq-digita) no-echo.
    repeat:             
        create tt-digita.
        import tt-digita.
    end.    
    input close. 
    
    delete tt-digita.
    
    open query br-digita for each tt-digita.
    
    if num-results("br-digita":U) > 0 then 
        assign bt-alterar:SENSITIVE in frame f-pg-dig = yes
               bt-retirar:SENSITIVE in frame f-pg-dig = yes
               bt-salvar:SENSITIVE in frame f-pg-dig  = yes.
    else
        assign bt-alterar:SENSITIVE in frame f-pg-dig = no
               bt-retirar:SENSITIVE in frame f-pg-dig = no
               bt-salvar:SENSITIVE in frame f-pg-dig  = no.
end.
/* i-rprcd */

