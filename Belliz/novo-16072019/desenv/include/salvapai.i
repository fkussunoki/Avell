/**********************************************************************************
**
**    Include: {include/salvapai.i}
**
**    Fun»’o : L½gica do bt-salva para o cadastro de pai, do template w-incmdp.w
**
**    Data   : 26/09/1997
**
**    Autor  : Sergio Weber Jr.
**
**    Par³metros : {1} - handle da viewer principal.
**
***********************************************************************************/

do  on error undo, return no-apply:
  RUN dispatch IN {1} ('update-record':U).
  IF return-value = "ADM-ERROR":U THEN
     RETURN NO-APPLY.
  run select-page (input 1).
 
  if estado = 'copia':U then do:
     run pi-desabilita-chave in {1}.
  end.  
  if estado = 'inclui':U then do:
     RUN dispatch IN wh-query('open-query':U).
     RUN dispatch IN {1} ('add-record':U).
  end.
  
end. 
