  /***************************************************************
**
** I-STR060.I - Show Structure
** 
***************************************************************/
    define var v-log-return as logical no-undo. 
    define var v-num-row    as integer no-undo.
    assign v-num-row = browse br-str:focused-row.
    case v-char-move-to :
        when "collapse":U then do:
           run pi-collapse-structure( v-row-tt ).
        end.     
        when "expand":U then do:   
           run pi-expand-structure( v-row-tt ).
        end.    
        when "expand-all":U then do:
           run pi-expand-all(  v-row-tt ).
        end.    
    end.
    if browse br-str:set-reposition-row( v-num-row, "always":U ) then .
    
    
     /* I-STR060.I */
