/***************************************************************************
**
**    esof0540.I3 - Impressao dos termos de abertura e encerramento
**
*****************************************************************************/

do:
    hide all no-pause.
    page.
    put skip(10) space(41) {1}.descricao skip
        space(41) fill("-", 40) format "x(40)" skip(5).
    /* assign i-termo = 1. */    
    /*do i-ind1 = 1 to 15:
 *        put space(26) substring({1}.texto,i-termo,80) skip(1).   
 *        assign i-termo = i-termo + 80.
 *     end.
 *     page.*/
end.


/* esof0540.I3 */
