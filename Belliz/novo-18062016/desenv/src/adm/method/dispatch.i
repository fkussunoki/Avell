/* dispatch.i - inline broker code for the dispatch method.
   Arguments are the object's procedure handle and the base event name. */

  DO:
    IF  index("{1}", "p-") <> 0 THEN do:
         if {1}:PRIVATE-DATA <> "ok" then
           assign c-private-data2 = {1}:PRIVATE-DATA.
    END.
    ELSE DO:
          assign h-caller = {1}.
          assign c-private-data2 = h-caller:PRIVATE-DATA.
    END.  
    IF ({src/adm/method/get-attr.i {1} INITIALIZED} EQ "YES":U) OR
       (LOOKUP ({2}, adm-pre-initialize-events) NE 0 ) THEN
    DO:
      adm-dispatch-proc =
         IF CAN-DO({1}:INTERNAL-ENTRIES, "local-":U + {2}) THEN
         "local-":U + {2} 
         ELSE IF CAN-DO({1}:INTERNAL-ENTRIES,
          {src/adm/method/get-attr.i {1} adm-dispatch-qualifier}
             + '-':U + {2}) THEN 
          {src/adm/method/get-attr.i {1} adm-dispatch-qualifier}
             + '-':U + {2} 
         ELSE IF CAN-DO({1}:INTERNAL-ENTRIES, "adm-":U + {2}) THEN
             "adm-":U + {2}
         ELSE {2}.
      RUN VALUE(adm-dispatch-proc) IN {1} NO-ERROR.

      &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
      /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
      /*Alterado 11/03/2006 - tech1007 - Alteracao para contemplar funcionalidade de faceLift em Viewers*/
      IF adm-dispatch-proc = "local-disable-fields" THEN DO:
          if valid-handle({1}) then do: /*Alterado 07/04/2006 - tech38629 - Erro Invalid Handle */
              ASSIGN hFrame = {1}:CURRENT-WINDOW.
              if valid-handle(hFrame) then do: /*Alterado 07/04/2006 - tech38629 - Erro Invalid Handle */
                  ASSIGN hFrame = hFrame:FIRST-CHILD.
                  IF VALID-HANDLE(h-facelift) THEN DO:
                      RUN pi_change_state_color IN h-facelift (INPUT hFrame, NO).
                  END.
              end.
          end.
      END.
      /*Alterado 07/04/2006 - tech1007 - Alteracao para corrigir problemas do facelift na operacao de c¢pia*/
      IF adm-dispatch-proc = "local-copy-record" OR adm-dispatch-proc = "adm-copy-record" THEN DO:
          if valid-handle({1}) then do: /*Alterado 10/04/2006 - tech38629 - Erro Invalid Handle */
              ASSIGN hFrame = {1}:CURRENT-WINDOW.
              if valid-handle(hFrame) then do: /*Alterado 07/04/2006 - tech38629 - Erro Invalid Handle */
                  ASSIGN hFrame = hFrame:FIRST-CHILD.

                  IF VALID-HANDLE(h-facelift) THEN DO:
                      RUN pi_change_state_color IN h-facelift (INPUT hFrame, YES).
                  END.
              END.
          end.
      END.
      IF adm-dispatch-proc = "local-add-record" OR adm-dispatch-proc = "adm-add-record" THEN DO:
          if valid-handle({1}) then do: /*Alterado 10/04/2006 - tech38629 - Erro Invalid Handle */
              ASSIGN hFrame = {1}:CURRENT-WINDOW.
              if valid-handle(hFrame) then do: /*Alterado 07/04/2006 - tech38629 - Erro Invalid Handle */
                  ASSIGN hFrame = hFrame:FIRST-CHILD.

                  IF VALID-HANDLE(h-facelift) THEN DO:
                      RUN pi_change_state_color IN h-facelift (INPUT hFrame, YES).
                  END.
              END.
          end.
      END.
      /*Fim alteracao 07/04/2006*/
      /*Fim alteracao 11/03/2006*/
      &ENDIF
      
      IF index("{1}", "p-") <> 0 THEN DO:
         if {1}:PRIVATE-DATA = ? OR
             {1}:PRIVATE-DATA = "ok" then DO:
                assign {1}:PRIVATE-DATA = c-private-data2 no-error.
          end.      
      END.    
      ELSE DO:
         IF VALID-HANDLE(h-caller) THEN
            ASSIGN h-caller:PRIVATE-DATA = c-private-data2 NO-ERROR.
      END.    

      /* Log the method name etc. if monitoring */
      IF VALID-HANDLE(adm-watchdog-hdl) THEN
      DO:
        RUN receive-message IN adm-watchdog-hdl 
         (INPUT {1}, INPUT "":U,
              INPUT adm-dispatch-proc) NO-ERROR.  
      END.
    END.
  END.
