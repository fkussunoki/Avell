  /***************************************************************
**
** I-STR160.I - Inicializar a estrutura
** 
***************************************************************/
    if session:set-wait-state('general':U) then .
    run pi-cleanup-tt-str.
    run pi-create-first-level-in-tt-str.
    {&OPEN-QUERY-{&BROWSE-NAME}}    
    if session:set-wait-state("") then .
