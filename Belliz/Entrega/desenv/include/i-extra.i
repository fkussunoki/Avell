/* ---------------------------------------------------------------------------------------------------
   Autor      : Medeiros
   Data       : 01/Dez/97
   Objetivo   : Include usada nos programas que fazem interface 
                con a API do windows.
    
   Parametros : Nenhum.
--------------------------------------------------------------------------------- */   

&IF DEFINED(PROEXTRA_I)=0 &THEN
&GLOBAL-DEFINE PROEXTRA_I
   
def new global shared var hpExtra as handle no-undo.
if not valid-handle(hpExtra) or
   hpExtra:type <> "PROCEDURE":U or
   hpExtra:file-name <> "utp/ut-extra.p":U then do:
    run utp/ut-extra.p persistent set hpExtra.
end.

&ENDIF  /* &IF DEFINED(PROEXTRA_I)=0 */


