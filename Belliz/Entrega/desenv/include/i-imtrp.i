/*****************************************************************
**
** I-IMTRP.I - Troca de Pÿgina no Template de Importa»’o
**
******************************************************************/

if  self:move-to-top() in frame f-import then.
case self:name:
    when "im-pg-sel" then do with frame f-import:
        &IF "{&PGLAY}" <> "" &THEN
            hide frame {&PGLAY}.
            if  im-pg-lay:load-image("image/im-flddn":U) then.
            if  im-pg-lay:move-to-bottom() then.
            assign im-pg-lay:height = 1  
                   im-pg-lay:row    = 1.6. 
        &ENDIF
        
        &IF "{&PGSEL}" <> "" &THEN
            view frame {&PGSEL}.
            run pi-first-child (input frame {&PGSEL}:handle).
            if  im-pg-sel:load-image("image/im-fldup":U) then.
            assign im-pg-sel:height = 1.20
                   im-pg-sel:row    = 1.50.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn":U) then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGLOG}" <> "" &THEN
            hide frame {&PGLOG}.
            if  im-pg-log:load-image("image/im-flddn":U) then.
            if  im-pg-log:move-to-bottom() then.
            assign im-pg-log:height = 1
                   im-pg-log:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-lay" then do with frame f-import:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn":U) then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGLAY}" <> "" &THEN
            view frame {&PGLAY}.
            run pi-first-child (input frame {&PGLAY}:handle).
            if  im-pg-lay:load-image("image/im-fldup":U) then.
            assign im-pg-lay:height = 1.20
                   im-pg-lay:row    = 1.50.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn":U) then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGLOG}" <> "" &THEN
            hide frame {&PGLOG}.
            if  im-pg-log:load-image("image/im-flddn":U) then.
            if  im-pg-log:move-to-bottom() then.
            assign im-pg-log:height = 1
                   im-pg-log:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-par" then do with frame f-import:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn":U) then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGLAY}" <> "" &THEN
            hide frame {&PGLAY}.
            if  im-pg-lay:load-image("image/im-flddn":U) then.
            if  im-pg-lay:move-to-bottom() then.
            assign im-pg-lay:height = 1
                   im-pg-lay:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            view frame {&PGPAR}.
            run pi-first-child (input frame {&PGPAR}:handle).
            if  im-pg-par:load-image("image/im-fldup":U) then.
            assign im-pg-par:height = 1.20
                   im-pg-par:row    = 1.5.
        &ENDIF
        &IF "{&PGLOG}" <> "" &THEN
            hide frame {&PGLOG}.
            if  im-pg-log:load-image("image/im-flddn":U) then.
            if  im-pg-log:move-to-bottom() then.
            assign im-pg-log:height = 1
                   im-pg-log:row    = 1.6.
        &ENDIF
    end.
    when "im-pg-log" then do with frame f-import:
        &IF "{&PGSEL}" <> "" &THEN
            hide frame {&PGSEL}.
            if  im-pg-sel:load-image("image/im-flddn":U) then.
            if  im-pg-sel:move-to-bottom() then.
            assign im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGLAY}" <> "" &THEN
            hide frame {&PGLAY}.
            if  im-pg-lay:load-image("image/im-flddn":U) then.
            if  im-pg-lay:move-to-bottom() then.
            assign im-pg-lay:height = 1
                   im-pg-lay:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            hide frame {&PGPAR}.
            if  im-pg-par:load-image("image/im-flddn":U) then.
            if  im-pg-par:move-to-bottom() then.
            assign im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGLOG}" <> "" &THEN
            view frame {&PGLOG}.
            run pi-first-child (input frame {&PGLOG}:handle).
            if  im-pg-log:load-image("image/im-fldup":U) then.
            assign im-pg-log:height = 1.20
                   im-pg-log:row    = 1.5.
        &ENDIF
    end.
end case.
assign i-current-folder = lookup(self:name,c-list-folders).
{include/i-epc014.i &PAGINA-ATUAL=i-current-folder}
/* i-imtrp.i */
