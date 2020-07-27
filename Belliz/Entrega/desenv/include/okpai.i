/**********************************************************************************
**
**    Include: {include/okpai.i}
**
**    Fun»’o : L½gica do bt-ok para o cadastro de pai, do template w-incmdp.w
**
**    Data   : 26/09/1997
**
**    Autor  : Sergio Weber Jr.
**
**    Par³metros : {1} - handle da viewer principal.
**
***********************************************************************************/
do  on error undo, return no-apply:
  RUN dispatch IN {1}('update-record':U).
  IF return-value = "ADM-ERROR":U THEN
     RETURN NO-APPLY.
  RUN dispatch IN wh-query ('open-query':U).
  RUN get-rowid IN {1}
      (OUTPUT v-row-table).
  RUN pi-reposiciona-query IN wh-query
      (INPUT v-row-table).
  apply "close":U to this-procedure.
end. 
