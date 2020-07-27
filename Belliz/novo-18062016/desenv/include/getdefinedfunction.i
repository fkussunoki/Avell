/**************************************************************************
**  Include.: /include/getdefinedfunction.i
**  Objetivo: Verifica se existe fun‡Æo de libera‡Æo especial
**  Data....: 20/10/2003
***************************************************************************/

FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT p_cod AS character):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.
    def var v_cd_funcao   as char    format "x(16)" initial "" no-undo.

    assign v_cd_funcao = p_cod.
    
    IF  CAN-FIND (FIRST funcao NO-LOCK
        WHERE funcao.cd-funcao = v_cd_funcao
        AND   funcao.ativo     = yes) THEN
        ASSIGN v_log_retorno = YES.

    {include/i-fnextvers.i v_cd_funcao v_log_retorno}

    RETURN v_log_retorno.
END FUNCTION.
