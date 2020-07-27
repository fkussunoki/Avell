/***********************************************************************
**
**  i-RPINI.I - Inicializa‡äes do Template de Relat¢rio
**
***********************************************************************/

/* Preprocessor para elimina‡Æo de arquivos tempor rios */
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
    
    find usuar_mestre where usuar_mestre.cod_usuario = v_cod_usuar_corren /*c-seg-usuario*/ no-lock no-error.
    
    if avail usuar_mestre
        then assign c-arquivo = if length(usuar_mestre.nom_subdir_spool) <> 0
                                    then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + c-programa-mg97 + "~.lst")
                                    else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + c-programa-mg97 + "~.lst")
                    c-arq-old = c-arquivo.
        else assign c-arquivo = caps("spool~/" + c-programa-mg97 + "~.lst")
                    c-arq-old = c-arquivo.
    
    assign c-terminal = "Terminal"
           rs-destino = 3.
&ENDIF

/* i-rpini */

