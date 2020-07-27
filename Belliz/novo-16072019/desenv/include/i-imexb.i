/***************************************************************
**
** I-IMEXB.I - Saida B na PI-EXECUTAR do template de Importacao
**
***************************************************************/

def var c-impressora as char no-undo.
def var c-layout as char no-undo.
if  tt-param.destino = 1 then do:
  assign tt-param.arq-destino = c-arquivo-destino:screen-value in frame f-pg-log
         c-arquivo-destino = c-arquivo-destino:screen-value in frame f-pg-log.
  if num-entries(tt-param.arq-destino,":") = 2 then do:
    assign c-impressora = substring(c-arquivo-destino:screen-value in frame f-pg-log,1,index(c-arquivo-destino:screen-value in frame f-pg-log,":") - 1).
    assign c-layout = substring(c-arquivo-destino:screen-value in frame f-pg-log,index(c-arquivo-destino:screen-value in frame f-pg-log,":") + 1,length(c-arquivo-destino:screen-value in frame f-pg-log) - index(c-arquivo-destino:screen-value in frame f-pg-log,":")). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = c-impressora
         and imprsor_usuar.cod_usuario = c-seg-usuario
         use-index imprsrsr_id no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario).
      return error.
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = c-impressora
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario).
      return error.
    end.       
  end.  
  else do:
    if num-entries(c-arquivo-destino,":") < 2 then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario).
      return error.
    end.
    assign tt-param.arq-destino = c-arquivo-destino:screen-value in frame f-pg-log.
    assign c-impressora = entry(1,c-arquivo-destino,":").
    assign c-layout = entry(2,c-arquivo-destino,":"). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = c-impressora
         and imprsor_usuar.cod_usuario = c-seg-usuario
         use-index imprsrsr_id no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario).
      return error.
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = c-impressora
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show":U, input 4306, input c-seg-usuario).
      return error.
    end.       
  end.
end.  
/* i-rpexb */
