/**********************************************************************************
**
**    Include: {include/cancepai.i}
**
**    Fun»’o : L½gica do bt-cancela para o cadastro de pai, do template w-incmdp.w
**
**    Data   : 26/09/1997
**
**    Autor  : Sergio Weber Jr.
**
**    Par³metros : {1} - handle da viewer principal.
**
***********************************************************************************/

  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
