/*****************************************************************
**
** I-RPTRP.I - Troca de P gina no Template de Relat¢rio
**
******************************************************************/

if  self:move-to-top() in frame f-relat then.

case self:name:
    when "im-pg-sel" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            view frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-fldup") then.
            assign im-pg-sel:height = 1.20
                   im-pg-sel:row    = 1.50.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.
            if  im-pg-cla:load-image("image/im-flddn") then.
            if  im-pg-cla:move-to-bottom() then.
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn") then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.
            if  im-pg-dig:load-image("image/im-flddn") then.
            if  im-pg-dig:move-to-bottom() then.
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
            if  im-pg-imp:load-image("image/im-flddn") then.
            if  im-pg-imp:move-to-bottom() then.
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-cla" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn") then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            view frame {&PGCLA}.
            if  im-pg-cla:load-image("image/im-fldup") then.
            assign im-pg-cla:height = 1.20
                   im-pg-cla:row    = 1.50.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn") then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.
            if  im-pg-dig:load-image("image/im-flddn") then.
            if  im-pg-dig:move-to-bottom() then.
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
            if  im-pg-imp:load-image("image/im-flddn") then.
            if  im-pg-imp:move-to-bottom() then.
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-par" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn") then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.
            if  im-pg-cla:load-image("image/im-flddn") then.
            if  im-pg-cla:move-to-bottom() then.
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            view frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-fldup") then.
            assign im-pg-par:height = 1.20
                   im-pg-par:row    = 1.5.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.
            if  im-pg-dig:load-image("image/im-flddn") then.
            if  im-pg-dig:move-to-bottom() then.
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
            if  im-pg-imp:load-image("image/im-flddn") then.
            if  im-pg-imp:move-to-bottom() then.
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-dig" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn") then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.
            if  im-pg-cla:load-image("image/im-flddn") then.
            if  im-pg-cla:move-to-bottom() then.
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn") then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            view frame {&PGDIG}.
            if  im-pg-dig:load-image("image/im-fldup") then.
            assign im-pg-dig:height = 1.20
                   im-pg-dig:row    = 1.5.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            hide frame {&PGIMP}.
            if  im-pg-imp:load-image("image/im-flddn") then.
            if  im-pg-imp:move-to-bottom() then.
            assign im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-imp" then do with frame f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn") then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            hide frame {&PGCLA}.
            if  im-pg-cla:load-image("image/im-flddn") then.
            if  im-pg-cla:move-to-bottom() then.
            assign im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn") then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            hide frame {&PGDIG}.
            if  im-pg-dig:load-image("image/im-flddn") then.
            if  im-pg-dig:move-to-bottom() then.
            assign im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            view frame {&PGIMP}.
            if  im-pg-imp:load-image("image/im-fldup") then.
            assign im-pg-imp:height = 1.20
                   im-pg-imp:row    = 1.5.
        &ENDIF
    end.
end case.

assign i-current-folder = lookup(self:name,c-list-folders,",").

/* i-rptrp.i */
