/**************************************************************************
**
** i-ultatu.i - Atualiza usuario, data e hora da ultima utilizacao
**
***************************************************************************/

def new global shared var v_cod_usuar_corren like usuar_mestre.cod_usuario no-undo.
assign {1}.hra_ult_atualiz       = replace(string(time, "hh:mm:ss":U),":","")
       {1}.dat_ult_atualiz       = today
       {1}.cod_usuar_ult_atualiz = v_cod_usuar_corren.
/* i-ultatu.i */
