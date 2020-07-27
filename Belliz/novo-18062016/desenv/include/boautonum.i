/*
** boautonum.i  - antigo - cd2504.i
**
** Include de Auto Numeracao.
**
** Ultima alteracao: 05/06/2000 - bre13188.
** Parametros:
** 1 - numero maximo de registros que pode ser incluido (formato do campo).
** 2 - campo da tabela
**
** Incluido no Rountable em 9/6 por Glauco pois o objeto ja existia no vermelha
*/

def var c-tabela as char.
assign c-tabela = "{&table-name}".
find last {&table-name} no-lock no-error.
if avail {&table-name} then do:
   assign i-auto-num = {&table-name}.{2} + 1.       
end.
else assign i-auto-num = 1.
    
if i-auto-num > {1} then do:
   do while i-cont <= {1}:
      if not can-find({&table-name} where {&table-name}.{2} = i-cont) then do:
         assign i-auto-num = i-cont
                i-cont = {1}.                
      end.       
      i-cont = i-cont + 1.
   end.
   if i-auto-num > {1} then do:
      assign i-seq-erro = i-seq-erro + 1.
      
      run utp/ut-table.p (input "mgcex":U,
                          input c-tabela,
                          input 1).      
      
      run utp/ut-msgs.p (input "msg":U,
                         input 17052,
                         input return-value).
      create tt-bo-erro.
      assign tt-bo-erro.i-sequen     = i-seq-erro
             tt-bo-erro.cd-erro      = 17052
             tt-bo-erro.mensagem     = return-value.      
   end.     
end.    
/** fim cd2504.i **/
