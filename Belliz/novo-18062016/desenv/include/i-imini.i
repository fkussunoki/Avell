/***********************************************************************
**
**  i-IMINI.I - Inicializa»„es do Template de Importa»’o
**
***********************************************************************/

/* Preprocessor para elimina»’o de arquivos temporÿrios */
&GLOBAL-DEFINE ExpImp OK
assign {&window-name}:virtual-width-chars  = {&window-name}:width-chars
       {&window-name}:virtual-height-chars = {&window-name}:height-chars
       {&window-name}:min-width-chars      = {&window-name}:width-chars
       {&window-name}:max-width-chars      = {&window-name}:width-chars
       {&window-name}:min-height-chars     = {&window-name}:height-chars
       {&window-name}:max-height-chars     = {&window-name}:height-chars
       c-arquivo-destino = "spool~/":U + c-programa-mg97   + ".lst":U.
       
&IF  "{&PGPAR}" <> "" &THEN
  assign c-arquivo-entrada:row in frame f-pg-par = c-arquivo-entrada:row in frame f-pg-par - 0.06
         c-arquivo-entrada:height in frame f-pg-par = 1.
&ENDIF
       
&IF  "{&PGLOG}" <> "" &THEN
  assign c-arquivo-destino:row in frame f-pg-log = c-arquivo-destino:row in frame f-pg-log - 0.06
         c-arquivo-destino:height in frame f-pg-log = 1.
&ENDIF
      
find usuar_mestre where usuar_mestre.cod_usuario = c-seg-usuario no-lock no-error.
if avail usuar_mestre
    then assign c-arquivo-destino = if length(usuar_mestre.nom_subdir_spool) <> 0
                                        then caps(replace(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, " ", "~/") + "~/" + c-programa-mg97 + "~.lst":U)
                                        else caps(replace(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + c-programa-mg97 + "~.lst":U)
                c-arq-old         = c-arquivo-destino.
    else assign c-arquivo-destino = caps("spool~/":U + c-programa-mg97 + "~.lst":U)
                c-arq-old         = c-arquivo-destino.
run utp/ut-liter.p (input "Terminal":U,
                    input "*",
                    input "R":U).
assign c-terminal = return-value.

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    run pi_aplica_facelift_thin in h-facelift ( input frame f-import:handle ).
    /* run pi_aplica_facelift_thin in h-facelift ( input frame f-import:handle ). */
    &IF "{&PGSEL}" <> "" &THEN
        run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-sel:handle ).
    &ENDIF
    &IF "{&PGLAY}" <> "" &THEN
        run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-lay:handle ).
        /* Restri‡Æo */
        assign ed-layout:font = 2. /* FO 1313663 - tech1139 - 08/05/2006 */
    &ENDIF
    &IF "{&PGPAR}" <> "" &THEN
        run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-par:handle ).
    &ENDIF
    &IF "{&PGLOG}" <> "" &THEN
        run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-log:handle ).
    &ENDIF
&ENDIF
/* i-imini */
