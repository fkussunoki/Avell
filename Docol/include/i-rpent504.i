/***************************************************************************
**
**  include para validar return e go nos programas de relatorio do magnus 97
**
**  Sergio Weber Junior
****************************************************************************/
&if "{&botao}" <> "no" &then

    &if "{&pgsel}" <> "" &then
    ON  GO OF frame {&pgsel} ANYWHERE DO:    
        if  self:type <> "editor" 
            or (self:type = "editor" 
            and keyfunction(lastkey) <> "RETURN") then do: 
            apply "choose" to bt-executar in frame f-relat.
        end.
      END.              
    &endif  

    &if "{&pgcla}" <> "" &then
    ON  GO OF frame {&pgcla} ANYWHERE DO:    
        if  self:type <> "editor" 
        or (self:type = "editor" 
        and keyfunction(lastkey) <> "RETURN") then do: 
            apply "choose" to bt-executar in frame f-relat.
        end.
      END.              
    &endif  
    
    &if "{&pgpar}" <> "" &then
    ON  GO OF frame {&pgpar} ANYWHERE DO:    
        if  self:type <> "editor" 
        or (self:type = "editor" 
        and keyfunction(lastkey) <> "RETURN") then do: 
            apply "choose" to bt-executar in frame f-relat.
        end.
      END.              
    &endif  
    
    &if "{&pgdig}" <> "" &then
    ON  GO OF frame {&pgdig} ANYWHERE DO:    
        if  self:type <> "editor" 
        or (self:type = "editor" 
        and keyfunction(lastkey) <> "RETURN") then do: 
            apply "choose" to bt-executar in frame f-relat.
        end.
      END.              
    &endif  
    
    &if "{&pgimp}" <> "" &then
    ON  GO OF frame {&pgimp} ANYWHERE DO:    
        if  self:type <> "editor" 
        or (self:type = "editor" 
        and keyfunction(lastkey) <> "RETURN") then do: 
            apply "choose" to bt-executar in frame f-relat.
        end.
      END.              
    &endif  
&endif

