/*****************************************************************
**
**  I-IMLBL.I - Cria os labels para os DumbFolder do Template
**  de Importa»’o
**
*******************************************************************/

def var wh-label         as widget-handle no-undo.

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
def var c-list-label     as character     no-undo.
&ENDIF

def var wh-group         as widget-handle no-undo.
def var wh-child         as widget-handle no-undo.
def var c-list-folders   as char          no-undo.
def var i-current-folder as integer       no-undo.
def var i-new-folder     as integer       no-undo.
def var c-aux            as char no-undo.
def var i-aux            as integer no-undo.
ON CLOSE OF THIS-PROCEDURE DO:
   {include/i-logfin.i} 
   RUN DISABLE_UI.
END.
&if "{&PGLOG}" <> "" &then
    ON "LEAVE" OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG do:
      assign c-arq-old = c-arquivo-destino:screen-value.
    END.  
    ON "ENTER":U OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG OR
       "CTRL-ENTER":U OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG OR
       "CTRL-J":U OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG OR
       "CTRL-Z":U OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG OR
       "RETURN":U OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG do:
      RETURN NO-APPLY.
    END.  
    ON "~\" OF C-ARQUIVO-DESTINO IN FRAME F-PG-LOG do:
      apply "/" to C-ARQUIVO-DESTINO in frame F-PG-LOG.
      return no-apply.       
    end.
      
    ON "VALUE-CHANGED":U OF RS-DESTINO IN FRAME F-PG-LOG DO:
      do  with frame f-pg-log:
        case self:screen-value:
            when "1" then do:             
                assign c-arquivo-destino:screen-value = c-imp-old.            
                assign c-arquivo-destino:sensitive     = no 
                       c-arquivo-destino:visible       = yes                
                       bt-arquivo-destino:visible      = no
                       bt-config-impr-destino:visible  = yes.
              if c-imp-old = "" then       
                run pi-impres-pad.
            end.
            when "2" then do:
                assign c-arquivo-destino:screen-value = c-arq-old.            
                assign c-arquivo-destino:sensitive     = yes
                       c-arquivo-destino:visible       = yes                
                       bt-arquivo-destino:visible      = yes
                       bt-config-impr-destino:visible  = no.
            end.
            when "3" then do:                               
                assign c-arquivo-destino:screen-value = "".            
                assign c-arquivo-destino:sensitive     = no
                       c-arquivo-destino:visible       = no
                       bt-arquivo-destino:visible      = no
                       bt-config-impr-destino:visible  = no.
            end.
        end case.
      end.
    END.
&endif
/********************************************
** HELP FRAME
********************************************/
ON HELP OF FRAME F-IMPORT DO:
    {include/ajuda.i}
END.
&IF "{&PGLAY}" &THEN 
ON HELP OF FRAME F-PG-LAY DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGSEL}" &THEN 
ON HELP OF FRAME F-PG-SEL DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGPAR}" &THEN 
ON HELP OF FRAME F-PG-PAR DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGLOG}" &THEN 
ON HELP OF FRAME F-PG-LOG DO:
    {include/ajuda.i}
END.
&ENDIF
/******************************************** 
** Tradu»’o pÿgina 0 - frame f-import 
*********************************************/
do  with frame f-import:
    assign wh-group = frame f-import:handle
           wh-group = wh-group:first-child.
    do  while valid-handle(wh-group):
        assign wh-child = wh-group:first-child.
        do  while valid-handle(wh-child):
            case wh-child:type:
                when "RADIO-SET":U then 
                    run pi-trad-radio-set (input wh-child).
                when "FILL-IN":U then
                    run pi-trad-fill-in (input wh-child).
                when "TOGGLE-BOX":U then
                    run pi-trad-toggle-box (input wh-child).
                when "COMBO-BOX":U then
                    run pi-trad-combo-box (input wh-child).
                when "BUTTON":U then
                    run pi-trad-button (input wh-child).
            end case.
            assign wh-child = wh-child:next-sibling.
        end.
        assign wh-group = wh-group:next-sibling.
    end. 
end.     
/******************************************** 
** Tradu‡Æo p gina layout - frame f-pg-lay 
*********************************************/

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
assign c-list-label = "".
&ENDIF

&if "{&PGLAY}" <> "" &then
    {utp/ut-liter.i "Layout" * C}
    create text wh-label
        assign frame        = frame f-import:handle
               format       = "x(8)"
               font         = 1
               screen-value = trim(return-value)
               width        = 13
               row          = 1.8
               col          = im-pg-lay:col in frame f-import + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click":U to im-pg-lay in frame f-import.           
         end triggers.       
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    if c-list-label <> "" then 
        assign c-list-label = c-list-label + ",".
    assign c-list-label = c-list-label + string(wh-label:handle) + ",".
    assign c-list-label = c-list-label + string(frame f-pg-lay:handle).
    &ENDIF
     do  with frame f-pg-lay:
         assign wh-group = frame f-pg-lay:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET":U then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN":U then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX":U then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX":U then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON":U then
                        run pi-trad-button (input wh-child).
                    when "TEXT":U then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     
&endif
/******************************************** 
** Tradu‡Æo p gina sele‡Æo - frame f-pg-sel 
*********************************************/
&if "{&PGSEL}" <> "" &then
    {utp/ut-liter.i "Sele‡Æo" * C}
    create text wh-label
        assign frame        = frame f-import:handle
               format       = "x(09)"
               font         = 1
               screen-value = trim(return-value)
               width        = 8
               row          = 1.8
               col          = im-pg-sel:col in frame f-import + 1.86
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click":U to im-pg-sel in frame f-import. /* Fo 1369.154 - tech1139 - 08/09/2006 */          
         end triggers.                   
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    if c-list-label <> "" then 
        assign c-list-label = c-list-label + ",".
    assign c-list-label = c-list-label + string(wh-label:handle) + ",".
    assign c-list-label = c-list-label + string(frame f-pg-sel:handle).
    &ENDIF
     do  with frame f-pg-sel:
         assign wh-group = frame f-pg-sel:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET":U then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN":U then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX":U then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX":U then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON":U then
                        run pi-trad-button (input wh-child).
                    when "TEXT":U then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     
         
&endif
/******************************************** 
** Tradu»’o pÿgina par³metros - frame f-pg-par 
*********************************************/
&if "{&PGPAR}" <> "" &then
    ON "ENTER":U OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR OR
       "CTRL-ENTER":U OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR OR
       "CTRL-J":U OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR OR
       "CTRL-Z":U OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR OR
       "RETURN":U OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR do:
      RETURN NO-APPLY.
    END.  
    ON "~\" OF C-ARQUIVO-ENTRADA IN FRAME F-PG-PAR do:
      apply "/" to C-ARQUIVO-ENTRADA in frame F-PG-PAR.
      return no-apply.       
    end.
    {utp/ut-liter.i "Parƒmetros" * C}
    create text wh-label
        assign frame        = frame f-import:handle
               format       = "x(11)"
               font         = 1
               screen-value = trim(return-value)
               width        = 11
               row          = 1.8
               col          = im-pg-par:col in frame f-import + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click":U to im-pg-par in frame f-import.           
         end triggers.
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    if c-list-label <> "" then 
        assign c-list-label = c-list-label + ",".
    assign c-list-label = c-list-label + string(wh-label:handle) + ",".
    assign c-list-label = c-list-label + string(frame f-pg-par:handle).
    &ENDIF
     do  with frame f-pg-par:
         assign wh-group = frame f-pg-par:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET":U then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN":U then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX":U then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX":U then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON":U then
                        run pi-trad-button (input wh-child).
                    when "TEXT":U then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     
&endif
/******************************************** 
** Tradu‡Æo p gina log - frame f-pg-log 
*********************************************/
&if "{&PGLOG}" <> "" &then
    {utp/ut-liter.i "Log" * C}
    create text wh-label
         assign frame        = frame f-import:handle
               format       = "x(6)"
               font         = 1
               screen-value = trim(return-value)
               width        = 10
               row          = 1.8
               col          = im-pg-log:col in frame f-import + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-log in frame f-import.           
         end triggers.                   
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    if c-list-label <> "" then 
        assign c-list-label = c-list-label + ",".
    assign c-list-label = c-list-label + string(wh-label:handle) + ",".
    assign c-list-label = c-list-label + string(frame f-pg-log:handle).
    &ENDIF
     do  with frame f-pg-log:
         assign wh-group = frame f-pg-log:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET":U then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN":U then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX":U then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX":U then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON":U then
                        run pi-trad-button (input wh-child).
                    when "TEXT":U then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     
         
&endif
/********************************************************** 
** Troca de pÿgina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/
                        . /*
assign c-list-folders = &IF "{&PGLAY}" <> "" &THEN "im-pg-lay,":U +
                        &ENDIF
                        &IF "{&PGSEL}" <> "" &THEN "im-pg-sel,":U +
                        &ENDIF
                        &IF "{&PGPAR}" <> "" &THEN "im-pg-par,":U +
                        &ENDIF
                        &IF "{&PGLOG}" <> "" &THEN "im-pg-log":U 
                        &ENDIF
*/
                        
&IF "{&PGLAY}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-lay,":U.
&ENDIF
&IF "{&PGSEL}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-sel,":U.
&ENDIF
&IF "{&PGPAR}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-par,":U.
&ENDIF
&IF "{&PGLOG}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-log":U.
&ENDIF
                        
on  CTRL-TAB OF {&WINDOW-NAME} anywhere do:

    if  i-current-folder = NUM-ENTRIES(c-list-folders,",") then
        assign i-new-folder = 1.
    else         
        assign i-new-folder = i-current-folder + 1.   

    /*Alteracao 05/10/2006 - tech1007 - Alteracao para nÆo exibir folders cuja imagem esteja desabilitada*/
    DO WHILE TRUE:
        &IF "{&PGLAY}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-lay":U THEN DO:
                IF im-pg-lay:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-lay in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = NUM-ENTRIES(c-list-folders,",") then
                        assign i-new-folder = 1.
                    else 
                        assign i-new-folder = i-new-folder + 1.   
                END.
            END.
        &ENDIF
        &IF "{&PGSEL}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-sel":U THEN DO:
                IF im-pg-sel:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-sel in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = NUM-ENTRIES(c-list-folders,",") then
                        assign i-new-folder = 1.
                    else 
                        assign i-new-folder = i-new-folder + 1.   
                END.
            END.
        &ENDIF    
        &IF "{&PGPAR}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-par":U THEN DO:
                IF im-pg-par:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-par in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = NUM-ENTRIES(c-list-folders,",") then
                        assign i-new-folder = 1.
                    else 
                        assign i-new-folder = i-new-folder + 1.   
                END.
            END.
        &ENDIF    
        &IF "{&PGLOG}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-log":U THEN DO:
                IF im-pg-log:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-log in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = NUM-ENTRIES(c-list-folders,",") then
                        assign i-new-folder = 1.
                    else 
                        assign i-new-folder = i-new-folder + 1.   
                END.
            END.
        &ENDIF    
    END.
    /*Fim alteracao 05/10/2006*/
end.
on  SHIFT-CTRL-TAB OF {&WINDOW-NAME} anywhere do:
    if  i-current-folder = 1 then
        assign i-new-folder = NUM-ENTRIES(c-list-folders,",").
    else 
        assign i-new-folder = i-current-folder - 1.   

    /*Alteracao 05/10/2006 - tech1007 - Alteracao para nÆo exibir folders cuja imagem esteja desabilitada*/
    DO WHILE TRUE:
        &IF "{&PGLAY}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-lay":U THEN DO:
                IF im-pg-lay:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-lay in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = 1 then
                        assign i-new-folder = NUM-ENTRIES(c-list-folders,",").
                    else 
                        assign i-new-folder = i-new-folder - 1.   
                END.
            END.                
        &ENDIF
        &IF "{&PGSEL}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-sel":U THEN DO:
                IF im-pg-sel:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-sel in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = 1 then
                        assign i-new-folder = NUM-ENTRIES(c-list-folders,",").
                    else 
                        assign i-new-folder = i-new-folder - 1.   
                END.
            END.
        &ENDIF    
        &IF "{&PGPAR}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-par":U THEN do:
                IF im-pg-par:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-par in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = 1 then
                        assign i-new-folder = NUM-ENTRIES(c-list-folders,",").
                    else 
                        assign i-new-folder = i-new-folder - 1.   
                END.
            END.
        &ENDIF    
        &IF "{&PGLOG}" &THEN  
            if  entry(i-new-folder,c-list-folders,",") = "im-pg-log":U THEN DO:
                IF im-pg-log:SENSITIVE in frame f-import = YES THEN DO:
                    apply 'MOUSE-SELECT-CLICK':U to im-pg-log in frame f-import.
                    LEAVE.
                END.
                ELSE DO:
                    if  i-new-folder = 1 then
                        assign i-new-folder = NUM-ENTRIES(c-list-folders,",").
                    else 
                        assign i-new-folder = i-new-folder - 1.   
                END.
            END.
        &ENDIF 
    END.
    /*Fim alteracao 05/10/2006*/       
end.
/********************************************************** 
** Procedure de troca de pÿgina por CTRL-TAB 
**********************************************************/
procedure pi-first-child:
        
    define input parameter wh-entry-folder as widget-handle.
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /* Altera‡Æo efetuada por tech38629 para o projeto Facelift */
    define variable wh-label-aux as widget-handle no-undo.
    define variable wh-frame-aux as widget-handle no-undo.
    
    do i-aux = 1 to num-entries(c-list-label):
        assign wh-label-aux = widget-handle(entry(i-aux,c-list-label)).
        assign i-aux = i-aux + 1.
        assign wh-frame-aux = widget-handle(entry(i-aux,c-list-label)).
        if wh-frame-aux = wh-entry-folder then do:
            assign wh-label-aux:bgcolor = 17.
        end.
        else do:
            assign wh-label-aux:bgcolor = 18.
        end.    
    end.
    &ENDIF
    assign wh-entry-folder = wh-entry-folder:first-child
           wh-entry-folder = wh-entry-folder:first-child.
    do  while(valid-handle(wh-entry-folder)):
        if  wh-entry-folder:sensitive = yes 
        and wh-entry-folder:type <> 'rectangle':U 
        and wh-entry-folder:type <> 'image':U then do:
            apply 'entry':U to wh-entry-folder.
            leave.
        end.
        else
            assign wh-entry-folder = wh-entry-folder:next-sibling.    
    end.
    
end.
/********************************************************** 
** Procedures de Traducao 
**********************************************************/
procedure pi-trad-radio-set:
   
    def input param wh-objeto    as widget-handle no-undo.
  
    assign c-aux = wh-objeto:radio-buttons.
    do  i-aux = 1 to num-entries(wh-objeto:radio-buttons):
        if  (i-aux mod 2) <> 0 then do:
            run utp/ut-liter.p (input replace(entry(i-aux, wh-objeto:radio-buttons), chr(32), "_"),
                                input "",
                                input "R":U). 
            assign entry(i-aux, c-aux) = return-value.
        end.
    end.                                              
    assign wh-objeto:radio-buttons = c-aux.
    
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        run utp/ut-liter.p (input replace(wh-objeto:help, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:help = return-value.
    end.  
end.
procedure pi-trad-fill-in:
   
    def input param wh-objeto    as widget-handle no-undo.
    
        if  wh-objeto:label <> ?
        and wh-objeto:label <> "" then do:
            run utp/ut-liter.p (input replace(wh-objeto:label, chr(32), "_"),
                                input "",
                                input "L":U). 
            assign wh-objeto:label = return-value.
        end. 
        if  wh-objeto:help <> "" 
        and wh-objeto:help <> ? then do:
            run utp/ut-liter.p (input replace(wh-objeto:help, chr(32), "_"),
                                input "",
                                input "R":U). 
            assign wh-objeto:help = return-value.
        end.         
    
end.
procedure pi-trad-toggle-box:
   
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        run utp/ut-liter.p (input replace(wh-objeto:label, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:label = return-value.
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        run utp/ut-liter.p (input replace(wh-objeto:help, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:help = return-value.
    end.         
    
end.
procedure pi-trad-combo-box:
                        /* nota: nÆo traduz conteœdo */
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        run utp/ut-liter.p (input replace(wh-objeto:label, chr(32), "_"),
                            input "",
                            input "L":U). 
        assign wh-objeto:label = return-value.
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        run utp/ut-liter.p (input replace(wh-objeto:help, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:help = return-value.
    end.         
    
end.
procedure pi-trad-button:
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        run utp/ut-liter.p (input replace(wh-objeto:label, chr(32), "_"),
                            input "",
                            input "C":U). 
        assign wh-objeto:label = return-value.
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        run utp/ut-liter.p (input replace(wh-objeto:help, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:help = return-value
               wh-objeto:tooltip = trim(return-value).
    end.         
    
end.
procedure pi-trad-text:
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:screen-value <> ?
    and wh-objeto:screen-value <> "" then do:
        run utp/ut-liter.p (input replace(wh-objeto:screen-value, chr(32), "_"),
                            input "",
                            input "R":U). 
        assign wh-objeto:screen-value = return-value.
               wh-objeto:width = length(return-value).
    end.
    else do:
        if  wh-objeto:private-data <> ?
        and wh-objeto:private-data <> "" then do:
            run utp/ut-liter.p (input replace(wh-objeto:private-data, chr(32), "_"),
                                input "",
                                input "R":U). 
            assign wh-objeto:screen-value = " " + return-value.
                   wh-objeto:width = length(return-value) + 1.
        end.
    
    end.
    
end.
&if "{&PGLOG}" <> "" &then
procedure pi-impres-pad:
do with frame f-pg-log:
    find layout_impres_padr no-lock
         where layout_impres_padr.cod_usuario = c-seg-usuario
            and layout_impres_padr.cod_proced = c-programa-mg97  use-index lytmprsp_id  no-error. /*cl_default_procedure_user of layout_impres_padr*/
    if  not avail layout_impres_padr
    then do:
        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = "*"
               and layout_impres_padr.cod_proced = c-programa-mg97  use-index lytmprsp_id  no-error. /*cl_default_procedure of layout_impres_padr*/
        if  avail layout_impres_padr
        then do:
            find imprsor_usuar no-lock
                 where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                   and imprsor_usuar.cod_usuario = string(c-seg-usuario)
                 use-index imprsrsr_id  no-error. /*cl_layout_current_user of imprsor_usuar*/
        end . /* if */
        if  not avail imprsor_usuar
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = c-seg-usuario
                   and layout_impres_padr.cod_proced = "*"
                 use-index lytmprsp_id  no-error. /*cl_default_user of layout_impres_padr*/
        end . /* if */
    end . /* if */
    if  avail layout_impres_padr
    then do:
        assign c-arquivo-destino:screen-value in frame f-pg-log = layout_impres_padr.nom_impressora
                                    + ":"
                                    + layout_impres_padr.cod_layout_impres.
    end . /* if */
    else do:
         c-arquivo-destino:screen-value in frame f-pg-log = "".
    end . /* else */
end . /* do dflt */
end.
/*pi-impres-pad */
&endif
/* i-imlbl */

/* define procedure externa para execucao do programa de visualizacao do relatorio */

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
