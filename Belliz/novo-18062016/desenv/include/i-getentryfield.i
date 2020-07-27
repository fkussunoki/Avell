/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNø°O *******************************
** Fun¯Êo para tratamento dos Entries dos c«digos livres
** 
**  p_num_posicao     - Nßmero do Entry que ser˜ atualizado
**  p_cod_campo       - Campo / Vari˜vel que ser˜ atualizada
**  p_cod_separador   - Separador que ser˜ utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */
