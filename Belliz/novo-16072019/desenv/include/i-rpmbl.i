/*****************************************************************
**
**  I-RPMBL.I - Main Block do Template de Relat½rio
**  {1} =  Par³metro Opcional, indica a imagem que deve ser aplicado
**         o "mouse-select-click" 
*******************************************************************/
{include/i_fnctrad.i}
apply "value-changed":U to rs-destino in frame f-pg-imp.
&IF "{1}" <> "" &THEN
    apply "mouse-select-click":U to {1} in frame f-relat.
&ELSE
    apply "mouse-select-click":U to im-pg-sel in frame f-relat.
&ENDIF

 VIEW {&WINDOW-NAME}. /*View na window do relat¢rio*/                                                                          
 APPLY "ENTRY":U TO FRAME f-relat. /*Transferindo focus para a frame principal do relat¢rio*/                         
 APPLY "ENTRY":U TO {&WINDOW-NAME}. /*Transferindo focus para janela afim de evitar a vinda do men£ para a frente da janela*/  


/*Tradu‡Æo dos objetos de tela*/
&IF "{&FNC_MULTI_IDIOMA}":U = "YES":U &THEN
    /*Verifica‡Æo da existencia da ut-trcampos no ambiente*/
    IF SEARCH("utp/ut-trcampos.r":U) <> ? OR 
        SEARCH("utp/ut-trcampos.p":U) <> ? THEN 
        Run utp/ut-trcampos.p.
&ENDIF
/*fim tradu‡Æo dos objetos de tela*/
/*Alteracao tech14207*/
&IF "{1}" <> "" &THEN
    case "{1}":
        &IF "{&PGSEL}" <> "" &THEN
        when "im-pg-sel" THEN DO:
            run pi-first-child (input frame f-pg-sel:handle).
        end.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
        when "im-pg-cla" THEN DO:
            run pi-first-child (input frame f-pg-cla:handle).
        end.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
        when "im-pg-par" THEN DO:
            run pi-first-child (input frame f-pg-par:handle).
        end.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
        when "im-pg-dig" THEN DO:
            run pi-first-child (input frame f-pg-dig:handle).
        end.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
        when "im-pg-imp" THEN DO:
            run pi-first-child (input frame f-pg-imp:handle).
        end.
        &ENDIF
    end case.
&ELSE
    run pi-first-child (input frame f-pg-sel:handle).
&ENDIF
/*tech 14207*/
/* i-rpmbl */
