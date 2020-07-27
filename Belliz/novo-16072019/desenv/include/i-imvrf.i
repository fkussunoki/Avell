/************************************************************************
**
**  I-IMVRF.I - Verifica existencia de arquivo texto com layout
**
**************************************************************************/
&IF Defined(DialLayout) = 0 &THEN
      def new global shared var v_cod_dialet_corren as character no-undo.
      &global-define DialLayout Yes
&ENDIF

If v_cod_dialet_corren Begins "en" Then
    assign c-arq-layout = "layout~/lo{&programa}.{&versao-layout}":U + "en":U.
Else If v_cod_dialet_corren Begins "es" Then
    assign c-arq-layout = "layout~/lo{&programa}.{&versao-layout}":U + "es":U.
Else 
    assign c-arq-layout = "layout~/lo{&programa}.{&versao-layout}":U + "pt":U.
If Search(c-arq-layout) = ? Then
    Assign c-arq-layout = "layout~/lo{&programa}.{&versao-layout}":U.

&IF DEFINED(diretorio) &THEN 
    assign c-arq-layout = "{&diretorio}~/" + c-arq-layout.
&ENDIF
if  search(c-arq-layout) <> ? then do:
    if  ed-layout:read-file(c-arq-layout) in frame f-pg-lay then.
end.
else do:
    run utp/ut-msgs.p (input "show":U,
                       input 2870,
                       input "").     
    return.                   
end.
/* i-imvrf.i */

