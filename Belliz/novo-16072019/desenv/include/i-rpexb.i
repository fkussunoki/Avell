/***************************************************************
**
** I-RPEXB.I - Saida B na PI-EXECUTAR do template de relat½rio
**
***************************************************************/

def var c-impressora as char no-undo.
def var c-layout as char no-undo.
DEFINE VARIABLE c-usuario-solicitante AS CHARACTER   NO-UNDO.

if  tt-param.destino = 1 then do:
  assign tt-param.arquivo = c-arquivo:screen-value in frame f-pg-imp
         c-arquivo = c-arquivo:screen-value in frame f-pg-imp.
  if num-entries(tt-param.arquivo,":") = 2 then do:
    assign c-impressora = substring(c-arquivo:screen-value in frame f-pg-imp,1,index(c-arquivo:screen-value in frame f-pg-imp,":") - 1).
    assign c-layout = substring(c-arquivo:screen-value in frame f-pg-imp,index(c-arquivo:screen-value in frame f-pg-imp,":") + 1,length(c-arquivo:screen-value in frame f-pg-imp) - index(c-arquivo:screen-value in frame f-pg-imp,":")). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = c-impressora
         and imprsor_usuar.cod_usuario = c-seg-usuario
         use-index imprsrsr_id no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario + "~~O usu rio '" + c-seg-usuario + "' nÆo possu¡ nenhuma impressora associada"). /* Daniel Kasemodel - 13/09/2006 - ALterado o n£mero da mensagem: 4306 -> 32169, Inserido o parƒmetro "~~" */
      return error.
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = c-impressora
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario + "~~A impressora nao possu¡ nenhum tipo de layout cadastrado"). /* Daniel Kasemodel - 13/09/2006 - Inserido o parƒmetro "~~" */
      return error.
    end.       
  end.  
  else do:
    if num-entries(c-arquivo,":") < 2 then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario + "~~A impressora nÆo existe"). /* Daniel Kasemodel - 13/09/2006 - ALterado o n£mero da mensagem: 4306 -> 32169, Inserido o parƒmetro "~~" */
      return error.
    end.
    assign tt-param.arquivo = c-arquivo:screen-value in frame f-pg-imp.
    assign c-impressora = entry(1,c-arquivo,":").
    assign c-layout = entry(2,c-arquivo,":"). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = c-impressora
         and imprsor_usuar.cod_usuario = c-seg-usuario
         use-index imprsrsr_id no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario + "~~O usu rio '" + c-seg-usuario + "' nÆo possu¡ nenhuma impressora associada"). /* Daniel Kasemodel - 13/09/2006 - ALterado o n£mero da mensagem: 4306 -> 32169, Inserido o parƒmetro "~~" */
      return error.
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = c-impressora
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show", input 4306, input c-seg-usuario + "~~O layout informado nÆo existe"). /* Daniel Kasemodel - 13/09/2006 - ALterado o n£mero da mensagem: 4306 -> 32169, Inserido o parƒmetro "~~" */
      return error.
    end.       
  end.

  /* Usu rio solicitante */
  IF CAN-FIND(FIRST param_extens_ems
              WHERE PARAM_extens_ems.cod_entid_param_ems = "histor_impres"
                AND param_extens_ems.cod_chave_param_ems = "histor_impres"
                AND param_extens_ems.cod_param_ems       = "log_histor_impres"
                AND param_extens_ems.log_param_ems       = YES) AND 
     CAN-FIND(FIRST usuar_mestre
              WHERE usuar_mestre.cod_usuario = c-seg-usuario 
                AND usuar_mestre.log_solic_impres = YES) THEN DO:
        RUN btb/btb004aa.w (output c-usuario-solicitante).

        IF c-usuario-solicitante = "" OR c-usuario-solicitante = ? THEN
            RETURN NO-APPLY.
        IF tt-param.usuario <> c-usuario-solicitante THEN
            ASSIGN tt-param.usuario = tt-param.usuario + CHR(1) + c-usuario-solicitante.
        /*END.*/
  END.
  /* Usu rio solicitante */

end.  
/* i-rpexb */


