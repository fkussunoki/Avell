/*****************************************************************
**
** I-RPTRP.I - Troca de P gina no Template de Relat¢rio
**
******************************************************************/
self:move-to-top() in frame f-relat.
&if "{&pgdig}" <> "" &then
    if num-results("br-digita":U) > 0 then
        apply "row-leave":U to br-digita in frame f-pg-dig.
&endif
case self:name:
    when "im-pg-sel" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            view frame {&PGSEL}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-sel) then
                assign wh-label-sel:bgcolor = 17.
            &ENDIF

            run pi-first-child (input frame {&PGSEL}:handle).
            im-pg-sel:load-image("image/im-fldup":U) .
            assign im-pg-sel:height = 1.20
                   im-pg-sel:row    = 1.50.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-cla) then
                assign wh-label-cla:bgcolor = 18.
            &ENDIF

            im-pg-cla:load-image("image/im-flddn":U) .
            im-pg-cla:move-to-bottom() .
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-par) then
                assign wh-label-par:bgcolor = 18.
            &ENDIF

            im-pg-par:load-image("image/im-flddn":U) .
            im-pg-par:move-to-bottom() .
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.
              
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-dig) then
                assign wh-label-dig:bgcolor = 18.
            &ENDIF

            im-pg-dig:load-image("image/im-flddn":U) .
            im-pg-dig:move-to-bottom() .
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
              
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-imp) then
                assign wh-label-imp:bgcolor = 18.
            &ENDIF

            im-pg-imp:load-image("image/im-flddn":U) .
            im-pg-imp:move-to-bottom() .
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-cla" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
              
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-sel) then
                assign wh-label-sel:bgcolor = 18.
            &ENDIF

            im-pg-sel:load-image("image/im-flddn":U) .
            im-pg-sel:move-to-bottom() .
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            view frame {&PGCLA}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-cla) then
                assign wh-label-cla:bgcolor = 17.
            &ENDIF

            run pi-first-child (input frame {&PGCLA}:handle).

            im-pg-cla:load-image("image/im-fldup":U) .
            assign im-pg-cla:height = 1.20
                   im-pg-cla:row    = 1.50.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
              
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-par) then
                assign wh-label-par:bgcolor = 18.
            &ENDIF
              
            im-pg-par:load-image("image/im-flddn":U) .
            im-pg-par:move-to-bottom() .
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-dig) then
                assign wh-label-dig:bgcolor = 18.
            &ENDIF

            im-pg-dig:load-image("image/im-flddn":U) .
            im-pg-dig:move-to-bottom() .
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-imp) then
                assign wh-label-imp:bgcolor = 18.
            &ENDIF

            im-pg-imp:load-image("image/im-flddn":U) .
            im-pg-imp:move-to-bottom() .
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-par" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-sel) then
                assign wh-label-sel:bgcolor = 18.
            &ENDIF

            im-pg-sel:load-image("image/im-flddn":U) .
            im-pg-sel:move-to-bottom() .
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-cla) then
                assign wh-label-cla:bgcolor = 18.
            &ENDIF

            im-pg-cla:load-image("image/im-flddn":U) .
            im-pg-cla:move-to-bottom() .
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            view frame {&PGPAR}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-par) then
                assign wh-label-par:bgcolor = 17.
            &ENDIF

            run pi-first-child (input frame {&PGPAR}:handle).
              im-pg-par:load-image("image/im-fldup":U) .
            assign im-pg-par:height = 1.20
                   im-pg-par:row    = 1.5.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-dig) then
                assign wh-label-dig:bgcolor = 18.
            &ENDIF

            im-pg-dig:load-image("image/im-flddn":U) .
            im-pg-dig:move-to-bottom() .
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-imp) then
                assign wh-label-imp:bgcolor = 18.
            &ENDIF

            im-pg-imp:load-image("image/im-flddn":U) .
            im-pg-imp:move-to-bottom() .
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-dig" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-sel) then
                assign wh-label-sel:bgcolor = 18.
            &ENDIF

            im-pg-sel:load-image("image/im-flddn":U) .
            im-pg-sel:move-to-bottom() .
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-cla) then
                assign wh-label-cla:bgcolor = 18.
            &ENDIF

            im-pg-cla:load-image("image/im-flddn":U) .
            im-pg-cla:move-to-bottom() .
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-par) then
                assign wh-label-par:bgcolor = 18.
            &ENDIF

            im-pg-par:load-image("image/im-flddn":U) .
            im-pg-par:move-to-bottom() .
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            view frame {&PGDIG}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-dig) then
                assign wh-label-dig:bgcolor = 17.
            &ENDIF

            run pi-first-child (input frame {&PGDIG}:handle).
              im-pg-dig:load-image("image/im-fldup":U) .
            assign im-pg-dig:height = 1.20
                   im-pg-dig:row    = 1.5.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-imp) then
                assign wh-label-imp:bgcolor = 18.
            &ENDIF

            im-pg-imp:load-image("image/im-flddn":U) .
            im-pg-imp:move-to-bottom() .
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-imp" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-sel) then do:
                assign wh-label-sel:bgcolor = 18.
            end.
            &ENDIF
            
            im-pg-sel:load-image("image/im-flddn":U) .
            im-pg-sel:move-to-bottom() .
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-cla) then
                assign wh-label-cla:bgcolor = 18.
            &ENDIF

            im-pg-cla:load-image("image/im-flddn":U) .
            im-pg-cla:move-to-bottom() .
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-par) then
                assign wh-label-par:bgcolor = 18.
            &ENDIF

            im-pg-par:load-image("image/im-flddn":U) .
            im-pg-par:move-to-bottom() .
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.

            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-dig) then
                assign wh-label-dig:bgcolor = 18.
            &ENDIF

            im-pg-dig:load-image("image/im-flddn":U) .
            im-pg-dig:move-to-bottom() .
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            view frame {&PGIMP}.
            
            /* Facelift */
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
            /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
            if valid-handle(wh-label-imp) then
                assign wh-label-imp:bgcolor = 17.
            &ENDIF

            run pi-first-child (input frame {&PGIMP}:handle).
              im-pg-imp:load-image("image/im-fldup":U) .
            assign im-pg-imp:height = 1.20
                   im-pg-imp:row    = 1.5.
        &ENDIF
    end.
end case.
assign i-current-folder = lookup(self:name,c-list-folders,",").
{include/i-epc014.i &PAGINA-ATUAL=i-current-folder}
/* i-rptrp.i */
