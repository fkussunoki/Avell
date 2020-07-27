/***********************************************************************
**
**  i-RPINI.I - Inicializa»„es do Template de Relat½rio
**
***********************************************************************/

/* Preprocessor para elimina»’o de arquivos temporÿrios */
&GLOBAL-DEFINE Relatorio OK
assign {&window-name}:virtual-width-chars  = {&window-name}:width-chars
       {&window-name}:virtual-height-chars = {&window-name}:height-chars
       {&window-name}:min-width-chars      = {&window-name}:width-chars
       {&window-name}:max-width-chars      = {&window-name}:width-chars
       {&window-name}:min-height-chars     = {&window-name}:height-chars
       {&window-name}:max-height-chars     = {&window-name}:height-chars.
&IF "{&PGDIG}" <> "":U &THEN
browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).
&ENDIF
&IF "{&PGIMP}" <> "":U &THEN
    assign c-arquivo:row in frame f-pg-imp    = c-arquivo:row in frame f-pg-imp - 0.06
           c-arquivo:height in frame f-pg-imp = 1.
    
    find usuar_mestre where usuar_mestre.cod_usuario = c-seg-usuario no-lock no-error.
    
    if avail usuar_mestre
        then assign c-arquivo = if length(usuar_mestre.nom_subdir_spool) <> 0
                                    then caps(replace(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, " ", "~/") + "~/" + c-programa-mg97 + "~.lst":U)
                                    else caps(replace(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + c-programa-mg97 + "~.lst":U)
                    c-arq-old = c-arquivo.
        else assign c-arquivo = caps("spool~/":U + c-programa-mg97 + "~.lst":U)
                    c-arq-old = c-arquivo.

    run utp/ut-liter.p (input "Terminal":U, 
                        input "*",
                        input "R").
    
    assign c-terminal = return-value
                        rs-destino = 3.

    /*Alterado tech1007 - 14/02/2005 - C¢digo removido pois o template foi alterado
      para que a op‡Æo de RTF nÆo seja uma op‡Æo de destino
    &IF "{&RTF}":U = "YES":U &THEN
        rs-destino:ADD-LAST("RTF", 4) IN FRAME f-pg-imp.
        
        run utp/ut-liter.p (input "RTF":U, 
                            input "*",
                            input "R").
        
        assign c-rtf      = return-value.
    &ENDIF
    Fim alteracao tech1007 - 14/02/2005*/
           
&ENDIF
/* i-rpini */
