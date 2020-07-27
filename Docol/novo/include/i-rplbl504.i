/*****************************************************************
**
**  I-RPLBL.I - Cria os labels para os DumbFolder do relat¢rio
**
*******************************************************************/

def var wh-label-sel     as widget-handle no-undo.
def var wh-label-cla     as widget-handle no-undo.
def var wh-label-par     as widget-handle no-undo.
def var wh-label-dig     as widget-handle no-undo.
def var wh-label-imp     as widget-handle no-undo.
def var wh-group         as widget-handle no-undo.
def var wh-child         as widget-handle no-undo.
def var c-list-folders   as char          no-undo.
def var i-current-folder as integer       no-undo.
def var i-new-folder     as integer       no-undo.
def var c-aux            as char no-undo.

def var i-aux            as integer no-undo.
/**/
ON  CLOSE OF THIS-PROCEDURE DO:
    {include/i-logfin504.i}  
    RUN disable_ui.
END.


&if "{&PGIMP}" <> "" &then
  ON "LEAVE" OF C-ARQUIVO IN FRAME F-PG-IMP do:
    assign c-arq-old = c-arquivo:screen-value.
  END.  

  ON "ENTER" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "RETURN" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-ENTER" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-J" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-Z" OF C-ARQUIVO IN FRAME F-PG-IMP do:
    RETURN NO-APPLY.
  END.  

  ON "\" OF C-ARQUIVO IN FRAME F-PG-IMP do:
    apply "/" to C-ARQUIVO in frame F-PG-IMP.
    return no-apply.       
  end.


  ON  "VALUE-CHANGED" OF RS-DESTINO IN FRAME F-PG-IMP DO:
    do  with frame f-pg-imp:
      case self:screen-value:
          when "1" then do:
              assign c-arquivo:screen-value = c-imp-old.
              assign c-arquivo:sensitive    = no 
                     c-arquivo:visible      = yes              
                     bt-arquivo:visible     = no
                     bt-config-impr:visible = yes.
                     run pi-impres-pad.
          end.
          when "2" then do:                             
              assign c-arquivo:screen-value = replace(c-arq-old, "xml", "tmp"). //inserido por Flavio Kussunoki - 17/12/2019
              assign c-arquivo:sensitive     = yes
                     c-arquivo:visible       = yes              
                     bt-arquivo:visible      = yes
                     bt-config-impr:visible  = no.
          end.
          when "3" then do:                        
              assign c-arquivo:screen-value = "".
              assign c-arquivo:sensitive     = no    
                     c-arquivo:visible       = no
                     bt-arquivo:visible      = no
                     bt-config-impr:visible  = no.
          end.
          when "4" then do:                        
              assign c-arquivo:screen-value = replace(c-arq-old, "tmp", "XML"). //inserido por Flavio Kussunoki - 17/12/2019
              assign c-arquivo:sensitive     = YES    
                     c-arquivo:visible       = YES
                     bt-arquivo:visible      = YES
                     bt-config-impr:visible  = no.
          end.

      end case.
    end.
  END.
&endif

/********************************************************** 
** Traduá∆o p†gina 0 - frame f-relat 
**********************************************************/
/*do  with frame f-relat:
    assign wh-group = frame f-relat:handle
           wh-group = wh-group:first-child.
    do  while valid-handle(wh-group):
        assign wh-child = wh-group:first-child.
        do  while valid-handle(wh-child):
            case wh-child:type:
                when "RADIO-SET" then 
                    run pi-trad-radio-set (input wh-child).
                when "FILL-IN" then
                    run pi-trad-fill-in (input wh-child).
                when "TOGGLE-BOX" then
                    run pi-trad-toggle-box (input wh-child).
                when "COMBO-BOX" then
                    run pi-trad-combo-box (input wh-child).
                when "BUTTON" then
                    run pi-trad-button (input wh-child).
            end case.
            assign wh-child = wh-child:next-sibling.
        end.
        assign wh-group = wh-group:next-sibling.
    end. 
end.     */

/********************************************************** 
** Traduá∆o p†gina seleá∆o - frame f-pg-sel
**********************************************************/
&if "{&PGSEL}" <> "" &then
    create text wh-label-sel
        assign frame        = frame f-relat:handle
               format       = "x(07)"
               font         = 1
               screen-value = "Seleá∆o"
               width        = 8
               row          = 1.8
               col          = im-pg-sel:col in frame f-relat + 1.86
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-sel in frame f-relat.           
         end triggers.                   
     /*do  with frame f-pg-sel:
         assign wh-group = frame f-pg-sel:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET" then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN" then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX" then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX" then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON" then
                        run pi-trad-button (input wh-child).
                    when "TEXT" then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end. */
         
&endif

/********************************************************** 
** Traduá∆o p†gina classificaá∆o - frame f-pg-cla
**********************************************************/
&if "{&PGCLA}" <> "" &then
    create text wh-label-cla
        assign frame        = frame f-relat:handle
               format       = "x(13)"
               font         = 1
               screen-value = "Classificaá∆o"
               width        = 13
               row          = 1.8
               col          = im-pg-cla:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-cla in frame f-relat.           
         end triggers.       
     /*do  with frame f-pg-cla:
         assign wh-group = frame f-pg-cla:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET" then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN" then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX" then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX" then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON" then
                        run pi-trad-button (input wh-child).
                    when "TEXT" then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     */
&endif

/********************************************************** 
** Traduá∆o p†gina parÉmetros - frame f-pg-par
**********************************************************/
&if "{&PGPAR}" <> "" &then
    create text wh-label-par
        assign frame        = frame f-relat:handle
               format       = "x(10)"
               font         = 1
               screen-value = "ParÉmetros"
               width        = 11
               row          = 1.8
               col          = im-pg-par:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-par in frame f-relat.           
         end triggers.
     /*do  with frame f-pg-par:
         assign wh-group = frame f-pg-par:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET" then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN" then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX" then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX" then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON" then
                        run pi-trad-button (input wh-child).
                    when "TEXT" then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.*/


&endif

/********************************************************** 
** Traduá∆o p†gina digitaá∆o - frame f-pg-dig
**********************************************************/
&if "{&PGDIG}" <> "" &then
    create text wh-label-dig
        assign frame        = frame f-relat:handle
               format       = "x(09)"
               font         = 1
               screen-value = "Digitaá∆o"
               width        = 10
               row          = 1.8
               col          = im-pg-dig:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-dig in frame f-relat.           
         end triggers.
     /*do  with frame f-pg-dig:
         assign wh-group = frame f-pg-dig:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET" then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN" then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX" then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX" then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON" then
                        run pi-trad-button (input wh-child).
                    when "TEXT" then
                        run pi-trad-text (input wh-child).
                    when "BROWSE" then
                        run pi-trad-browse (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     */

&endif

/********************************************************** 
** Traduá∆o p†gina impress∆o - frame f-pg-imp
**********************************************************/
&if "{&PGIMP}" <> "" &then
    create text wh-label-imp
        assign frame        = frame f-relat:handle
               format       = "x(09)"
               font         = 1
               screen-value = "Impress∆o"
               width        = 10
               row          = 1.8
               col          = im-pg-imp:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on mouse-select-click
                apply "mouse-select-click" to im-pg-imp in frame f-relat.           
         end triggers.                   
     /*do  with frame f-pg-imp:
         assign wh-group = frame f-pg-imp:handle
                wh-group = wh-group:first-child.
         do  while valid-handle(wh-group):
             assign wh-child = wh-group:first-child.
             do  while valid-handle(wh-child):
                 case wh-child:type:
                    when "RADIO-SET" then 
                        run pi-trad-radio-set (input wh-child).
                    when "FILL-IN" then
                        run pi-trad-fill-in (input wh-child).
                    when "TOGGLE-BOX" then
                        run pi-trad-toggle-box (input wh-child).
                    when "COMBO-BOX" then
                        run pi-trad-combo-box (input wh-child).
                    when "BUTTON" then
                        run pi-trad-button (input wh-child).
                    when "TEXT" then
                        run pi-trad-text (input wh-child).
                 end case.
                 assign wh-child = wh-child:next-sibling.
             end.
             assign wh-group = wh-group:next-sibling.
         end. 
     
     end.     */
         
&endif


/********************************************************** 
** Procedures de Traducao 
**********************************************************/
procedure pi-trad-radio-set:
   
    def input param wh-objeto    as widget-handle no-undo.
  
    assign c-aux = wh-objeto:radio-buttons.
    do  i-aux = 1 to num-entries(wh-objeto:radio-buttons):
        if  (i-aux mod 2) <> 0 then do:
            assign entry(i-aux, c-aux) = replace(entry(i-aux, wh-objeto:radio-buttons), chr(32), "_").
        end.
    end.                                              
    assign wh-objeto:radio-buttons = c-aux.
    
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        assign wh-objeto:help = replace(wh-objeto:help, chr(32), "_").
    end.  

end.

procedure pi-trad-fill-in:
   
    def input param wh-objeto    as widget-handle no-undo.
    
        if  wh-objeto:label <> ?
        and wh-objeto:label <> "" then do:
            assign wh-objeto:label = replace(wh-objeto:label, chr(32), "_").
        end. 
        if  wh-objeto:help <> "" 
        and wh-objeto:help <> ? then do:
            assign wh-objeto:help = replace(wh-objeto:help, chr(32), "_").
        end.         
    
end.

procedure pi-trad-toggle-box:
   
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        assign wh-objeto:label = replace(wh-objeto:label, chr(32), "_").
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        assign wh-objeto:help = replace(wh-objeto:help, chr(32), "_").
    end.         
    
end.

procedure pi-trad-combo-box:
    /* nota: n∆o traduz conte£do */                   
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        assign wh-objeto:label = replace(wh-objeto:label, chr(32), "_").
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        assign wh-objeto:help = replace(wh-objeto:help, chr(32), "_").
    end.         
    
end.

procedure pi-trad-button:
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:label <> ?
    and wh-objeto:label <> "" then do:
        assign wh-objeto:label = replace(wh-objeto:label, chr(32), "_").
    end. 
    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        assign wh-objeto:help    = replace(wh-objeto:help, chr(32), "_")
               wh-objeto:tooltip = trim(replace(wh-objeto:help, chr(32), "_")).
    end.         
    
end.

procedure pi-trad-text:
    
    def input param wh-objeto    as widget-handle no-undo.
    
    if  wh-objeto:screen-value <> ?
    and wh-objeto:screen-value <> "" then do:
        assign wh-objeto:screen-value = replace(wh-objeto:screen-value, chr(32), "_").
               wh-objeto:width = length(replace(wh-objeto:screen-value, chr(32), "_")).
    end.
    else do:
        if  wh-objeto:private-data <> ?
        and wh-objeto:private-data <> "" then do:
            assign wh-objeto:screen-value = " " + replace(wh-objeto:private-data, chr(32), "_").
                   wh-objeto:width = length(replace(wh-objeto:private-data, chr(32), "_")) + 1.
        end.
    
    end.
    
end.

procedure pi-trad-browse:
    
    def input param wh-objeto    as widget-handle no-undo.

    def var wh-column            as widget-handle no-undo.

    if  wh-objeto:help <> "" 
    and wh-objeto:help <> ? then do:
        assign wh-objeto:help = replace(wh-objeto:help, chr(32), "_").
    end.         

    if  wh-objeto:title <> "" 
    and wh-objeto:title <> ? then do:
        assign wh-objeto:title = replace(wh-objeto:title, chr(32), "_").
    end.         

    assign wh-column = wh-objeto:first-column.
    do  while wh-column <> ?:
        assign wh-column:label = replace(wh-column:label, chr(32), "_").
        assign wh-column = wh-column:next-column.
    end.

end.

/* i-rplbl */
&if "{&PGIMP}" <> "" &then

procedure pi-impres-pad:

/*
do with frame f-pg-imp:
    find layout_impres_padr no-lock
         where layout_impres_padr.cod_usuario = c-seg-usuario
            and layout_impres_padr.cod_proced = c-programa-mg97  use-index lytmprsp_id /*cl_default_procedure_user of layout_impres_padr*/ no-error.
    if  not avail layout_impres_padr
    then do:
        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = "*"
               and layout_impres_padr.cod_proced = c-programa-mg97  use-index lytmprsp_id /*cl_default_procedure of layout_impres_padr*/ no-error.
        if  avail layout_impres_padr
        then do:
            find imprsor_usuar no-lock
                 where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                   and imprsor_usuar.cod_usuario = string(c-seg-usuario)
                 use-index imprsrsr_id /*cl_layout_current_user of imprsor_usuar*/ no-error.
        end /* if */.
        if  not avail imprsor_usuar
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = c-seg-usuario
                   and layout_impres_padr.cod_proced = "*"
                 use-index lytmprsp_id /*cl_default_user of layout_impres_padr*/ no-error.
        end /* if */.
    end /* if */.
    if  avail layout_impres_padr
    then do:
        assign c-arquivo:screen-value in frame f-pg-imp = layout_impres_padr.nom_impressora
                                    + ":"
                                    + layout_impres_padr.cod_layout_impres.
    end /* if */.
    else do:
         c-arquivo:screen-value in frame f-pg-imp = "".
    end /* else */.
end /* do dflt */.
*/
end.
/*pi-impres-pad */

&endif

/********************************************************** 
** Troca de p†gina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/
&IF "{&PGSEL}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-sel,".
&ENDIF
&IF "{&PGCLA}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-cla,".
&ENDIF
&IF "{&PGPAR}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-par,".
&ENDIF
&IF "{&PGDIG}" <> "" &THEN 
    assign c-list-folders = c-list-folders + "im-pg-dig,".
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    assign c-list-folders = c-list-folders + "im-pg-imp".
&ENDIF

if  substring(c-list-folders,length(c-list-folders)) = "," then 
    assign c-list-folders = substring(c-list-folders,1,length(c-list-folders) - 1 ).

on  CTRL-TAB,SHIFT-CTRL-TAB anywhere do:
    define variable h_handle  as handle no-undo.       
    define variable c_imagem  as character no-undo.
    define variable l_direita as logical no-undo.            

    l_direita = last-event:label = 'CTRL-TAB'.
        
    block1:
    repeat:        
        if  l_direita then do:
            if  i-current-folder = num-entries(c-list-folders) then
                i-current-folder = 1.
            else
                i-current-folder = i-current-folder + 1.
        end.
        else do:
            if  i-current-folder = 1 then
                i-current-folder = num-entries(c-list-folders).
            else
                i-current-folder = i-current-folder - 1.
        end.
    
        assign c_imagem = entry(i-current-folder,c-list-folders)
               h_handle = frame f-relat:first-child
               h_handle = h_handle:first-child.

        do  while valid-handle(h_handle):
            if  h_handle:type = 'image' and
                h_handle:name =  c_imagem then do:
                if  h_handle:sensitive = no then 
                    next block1.
                apply 'mouse-select-click' to h_handle.
                leave block1.
            end.
            h_handle = h_handle:next-sibling.
        end.
    end.
end.



PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
