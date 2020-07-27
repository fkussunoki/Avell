/*Declara‡Æo da Fun‡Æo SetEntryField*/
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUN°€O *******************************
** Fun»’o para tratamento dos Entries dos c½digos livres
** 
**  p_num_posicao     - Nœmero do Entry / Posi»’o que serÿ atualizado
**  p_cod_campo       - Campo / Variÿvel que serÿ atualizada
**  p_cod_separador   - Separador que serÿ utilizado
**  p_cod_valor       - Valor que serÿ atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry ² 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor invÿlido, este valor serÿ convertido para Branco
         para possibilitar os cÿlculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /*l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /*l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.

