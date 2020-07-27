/***************************************************************
**
** I-frm170.I - Exclui do browse destino
** 
***************************************************************/ 
define var v-num-row-a  as integer no-undo.
define var v-log-method as logical no-undo.

do v-num-row-a = 1 to browse br-target-browse:num-selected-rows :
    assign v-log-method = browse br-target-browse:fetch-selected-row(v-num-row-a)  .
    if  is-delete-allowed( rowid( {&FIRST-TABLE-IN-QUERY-br-target-browse} )  ) then do:
        run pi-delete-from-target( rowid( {&FIRST-TABLE-IN-QUERY-br-target-browse} ) ).
    end.
end.
{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

/* i-frm170 */
