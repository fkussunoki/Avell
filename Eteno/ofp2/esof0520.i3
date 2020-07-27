/***************************************************************************
**
**    esof0520.I3 - Impressao dos termos de abertura e encerramento
**
*****************************************************************************/
do:
    page.    
    put skip(10) space(41) {1}.descricao skip
        space(41) fill("-", 40) format "x(40)" skip(5).
        
    run pi-print-editor ({1}.texto, 66).
    
    for each tt-editor:
        disp tt-editor.conteudo with no-label frame f-imp.
        down with frame f-imp.
    end.
    
    put skip.
    
    page.
end.
/* esof0520.I3 */
