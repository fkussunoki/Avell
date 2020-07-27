/***************************************************************
**
** I-frm160.I - Inclui no browse destino
** 
***************************************************************/ 
define var v-num-row-a  as integer no-undo.
define var v-log-method as logical no-undo.

do v-num-row-a = 1 to browse br-source-browse:num-selected-rows :
    assign v-log-method = browse br-source-browse:fetch-selected-row(v-num-row-a).

    
    if  is-create-allowed( rowid( {&FIRST-TABLE-IN-QUERY-br-source-browse}) ) then do:
        run pi-add-to-target( rowid( {&FIRST-TABLE-IN-QUERY-br-source-browse})  ).
        assign v-log-method = browse br-source-browse:deselect-selected-row(v-num-row-a)
               v-num-row-a  = v-num-row-a - 1.
    end.
end.
/*{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}*/
{&OPEN-QUERY-br-target-browse}
/* i-frm160 */
