  /***************************************************************
**
** I-STR100.I - 
** 
***************************************************************/
    define var v-log-return as logical no-undo. 
    define var v-num-row    as integer no-undo.
    assign v-num-row = browse br-str:focused-row.
  
    case v-char-move-to :
        when "right":U then do:
             if not fn-valid-move-right( input v-row-tt ) then 
                assign v-log-return = yes.
             else   
                run pi-move-right    ( v-row-tt ).
        end.     
        when "left":U then do:   
            if not fn-valid-move-left( input v-row-tt ) then 
               assign v-log-return = yes.
            else   
               run pi-move-left     ( v-row-tt ).
        end.    
        when "up":U then do:
            if not fn-valid-move-up( input v-row-tt ) then 
                assign v-log-return = yes.        
            else    
                run pi-move-up       ( v-row-tt ).
        end.    
        when "down":U then do:
            if not fn-valid-move-right( input v-row-tt ) then 
                assign v-log-return = yes.        
            else    
                run pi-move-down ( v-row-tt ).   
        end.    
    end.
    if browse br-str:set-reposition-row( v-num-row, "always":U ) then .
    
    
    
     /* I-STR100.I */
