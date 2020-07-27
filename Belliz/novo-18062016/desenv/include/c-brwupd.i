&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
/* ********************  Preprocessor Definitions  ******************** */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS
/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
 /* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 
/* ***************************  Main Block  *************************** */

{&BROWSE-NAME}:SET-REPOSITIONED-ROW({&BROWSE-NAME}:DOWN, "ALWAYS":U).
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-add) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add Method-Library 
PROCEDURE pi-add :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var i-indice    as integer no-undo.
define var r-tt-update as rowid   no-undo.
if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}
then do:
    assign browse {&BROWSE-NAME} {&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}.
    run pi-update.
end.
find last {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} no-lock no-error.
if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}
then assign i-indice = {&first-table-in-query-{&browse-name}}.indice + 1.
else assign i-indice = 1.
assign {&BROWSE-NAME}:REFRESHABLE in frame {&FRAME-NAME} = no.
create {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
assign {&first-table-in-query-{&browse-name}}.indice = i-indice
       r-tt-update                                   = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
assign {&BROWSE-NAME}:REFRESHABLE in frame {&FRAME-NAME} = yes.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
reposition {&BROWSE-NAME} to rowid r-tt-update.
run pi-entry.
/*if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
 * then do: 
 *     assign i-indice = {&first-table-in-query-{&browse-name}}.indice.
 *     
 *     assign browse {&BROWSE-NAME} {&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}.
 *     run pi-update.
 * end.
 * else assign i-indice = 0.
 * 
 * do transaction:
 *     repeat preselect each {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
 *         where {&first-table-in-query-{&browse-name}}.indice > i-indice:
 *         find next {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} no-error.
 *         if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
 *         then assign {&first-table-in-query-{&browse-name}}.indice = {&first-table-in-query-{&browse-name}}.indice + 1.
 *         else leave.
 *     end.
 *     
 *     create {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
 *     assign {&first-table-in-query-{&browse-name}}.indice = i-indice + 1
 *            i-indice                                      = i-indice + 1.
 * end.
 * 
 * RUN dispatch IN THIS-PROCEDURE ('open-query':U).
 * 
 * find {&first-table-in-query-{&browse-name}} where {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.indice = i-indice.
 * assign r-tt-update = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
 * 
 * reposition {&BROWSE-NAME} to rowid r-tt-update.
 * 
 * run pi-entry.*/
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-delete) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete Method-Library 
PROCEDURE pi-delete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var i-indice as integer no-undo.
if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
then assign i-indice = {&first-table-in-query-{&browse-name}}.indice.
else assign i-indice = 0.
do transaction:
    find current {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} exclusive-lock.
    delete {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
    
    repeat preselect each {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}
        where {&first-table-in-query-{&browse-name}}.indice > i-indice:
        find next {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} no-error.
        if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
        then assign {&first-table-in-query-{&browse-name}}.indice = {&first-table-in-query-{&browse-name}}.indice - 1.
        else leave.
    end.
end.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
/* Problema com OFF-END ao executar OPEN-QUERY */
if num-results("{&BROWSE-NAME}") = 0 then do:
    apply "ENTRY":U to {&BROWSE-NAME} in frame {&FRAME-NAME}.
end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-off-end) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-off-end Method-Library 
PROCEDURE pi-off-end :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if LAST-EVENT:LABEL = "OFF-END":U then 
    if num-results("{&BROWSE-NAME}") >= 1 then
        run pi-add.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-row-leave) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-row-leave Method-Library 
PROCEDURE pi-row-leave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} and 
   ({&BROWSE-NAME}:FOCUSED-ROW in frame {&FRAME-NAME} = num-results("{&BROWSE-NAME}") and
    LAST-EVENT:LABEL = "CURSOR-DOWN":U) then return "ADM-ERROR":U.
run pi-update.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-select-page-folder) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-select-page-folder Method-Library 
PROCEDURE pi-select-page-folder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var i-page-browse-aux as integer       no-undo.
define var i-page-atual-aux  as integer       no-undo.
define var wh-container-aux  as widget-handle no-undo.
RUN get-attribute ('w-page':U).
assign i-page-browse-aux = integer(RETURN-VALUE).
RUN get-attribute ('w-container-source':U).
assign wh-container-aux = widget-handle(RETURN-VALUE).
RUN get-attribute ('current-page':U).
assign i-page-atual-aux = integer(RETURN-VALUE).
if i-page-atual-aux <> i-page-browse-aux and 
   i-page-browse-aux <> 0 then 
    RUN select-page IN wh-container-aux (input i-page-browse-aux).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-issuer-hdl as handle no-undo.
define input param p-state      as char   no-undo.
case p-state:
    when "no-record-available":U then
        assign bt-modificar:SENSITIVE in frame {&FRAME-NAME} = no
               bt-eliminar:SENSITIVE in frame {&FRAME-NAME} = no.
    when "no-external-record-available":U then
        assign bt-modificar:SENSITIVE in frame {&FRAME-NAME} = no
               bt-eliminar:SENSITIVE in frame {&FRAME-NAME} = no.
    when "record-available":U then
        assign bt-modificar:SENSITIVE in frame {&FRAME-NAME} = yes
               bt-eliminar:SENSITIVE in frame {&FRAME-NAME} = yes.
end case.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
