/***************************************************************************
**
**  include para validar return e go nos programas de relatorio do magnus 97
**
**  Sergio Weber Junior
****************************************************************************/

&if "{&botao}" <> "no":U &then
    &if "{&pgsel}" <> "" &then
    ON  GO OF frame {&pgsel} 
     ANYWHERE DO:     /*  OR  ENTER OF FRAME {&pgsel} */
        if  self:type <> "editor" 
            or (self:type = "editor":U 
            and keyfunction(lastkey) <> "RETURN":U) then do: 
            apply "choose":U to bt-executar in frame f-import.
        end.
      END.              
    &endif  &if "{&pglay}" <> "" &then
    ON  GO OF frame {&pglay} 
      ANYWHERE DO:     /* OR  ENTER OF FRAME {&pglay} */
        if  self:type <> "editor" 
            or (self:type = "editor":U 
            and keyfunction(lastkey) <> "RETURN":U) then do: 
            apply "choose":U to bt-executar in frame f-import.
        end.
      END.              
    &endif  
    
    &if "{&pgpar}" <> "" &then
    ON  GO OF frame {&pgpar} 
     ANYWHERE DO:     /*  OR  ENTER OF FRAME {&pgpar}*/
        if  self:type <> "editor":U 
            or (self:type = "editor":U 
            and keyfunction(lastkey) <> "RETURN":U) then do: 
            apply "choose":U to bt-executar in frame f-import.
        end.
      END.              
    &endif  
    
    &if "{&pglog}" <> "" &then
    ON  GO OF frame {&pglog} 
     ANYWHERE DO:     /*  OR  ENTER OF FRAME {&pglog}*/
        if  self:type <> "editor":U 
            or (self:type = "editor":U 
            and keyfunction(lastkey) <> "RETURN":U) then do: 
            apply "choose":U to bt-executar in frame f-import.
        end.
      END.              
    &endif  
&endif
