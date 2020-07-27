&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza»’o dos browses"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-browse.i
    Purpose     : Implementar customiza»„es nos browsers

    Syntax      : {include/c-brows5.i}

    Description : Method-Library criada para fornecer customiza»’o para
                  os browses a serem utilizadas pelos programas do
                  Magnus97

    Author(s)   : Medeiros
    Created     : 20/06/1998
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

def var linha-eliminada as int no-undo.
def var rw-last as rowid no-undo.
def var c_Aux-var as char.
def var l-elimina as logical init yes no-undo.
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
         HEIGHT             = 2.04
         WIDTH              = 39.57.
 /* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 
/* ***************************  Main Block  *************************** */
ON  GO OF frame {&frame-name} 
OR  ENTER OF FRAME {&frame-name} ANYWHERE DO:
    if  self:type <> "editor":U 
    or (self:type =  "editor":U 
        and keyfunction(lastkey) <> "RETURN":U) then do:               
        RUN get-link-handle IN adm-broker-hdl (INPUT  THIS-PROCEDURE,
                                               INPUT  "CONTAINER-SOURCE":U,
                                               OUTPUT c_Aux-var). 
                                            
        if  "{&ENABLED-FIELDS}" <> "" then do:
            run pi-enter-go IN widget-handle(c_Aux-var).
            return no-apply.
        end.    
    end.                    
    else do:
        if  self:insert-string(chr(10)) then.
    end.
END.              
if {&browse-name}:set-repositioned-row({&browse-name}:down,"always":U) then.
/* create {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
assign {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line = 1. */
 
RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ).
run pi-entry.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-insere-registro) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insere-registro Method-Library 
PROCEDURE insere-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if  l-elimina = yes then do:
    run pi-insert.
end.  
else do:
    create {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
    assign {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line = 1.
       
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ).
      
    run pi-entry.
    
    assign bt-eliminar:sensitive in frame {&frame-name} = yes
           bt-modificar:sensitive in frame {&frame-name} = yes
           l-elimina = yes.
end.  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-busca-valor) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor Method-Library 
PROCEDURE pi-busca-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param c-lista-obj as char no-undo.
def var c-cod-obj       as char no-undo.
def var c-lista-obj-ret as char no-undo.
def var i-cont    as int  no-undo.
do  i-cont = 1 to num-entries(c-lista-obj):
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
        INPUT entry(i-cont, c-lista-obj)).
    assign c-lista-obj-ret = c-lista-obj-ret + min(c-lista-obj-ret, ",") + return-value.
end.
return c-lista-obj-ret.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-elimina) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina Method-Library 
PROCEDURE pi-elimina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign linha-eliminada = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line.
delete {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ).
 
if num-results("{&browse-name}") > 0 then
  run pi-entry.
else
  assign bt-eliminar:sensitive in frame {&frame-name} = no
         bt-modificar:sensitive in frame {&frame-name} = no
         l-elimina = no.
/* Tira o FOCUS do browse */
if num-results("{&browse-name}") = 0 then  
  apply "choose":U to bt-eliminar in frame {&frame-name}.
  
  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-foco-atributo) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-foco-atributo Method-Library 
PROCEDURE pi-foco-atributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if num-results("{&BROWSE-NAME}") = 0 then
         apply "choose":U to bt-incluir in frame {&frame-name}.
    else
         apply "choose":U to bt-modificar in frame {&frame-name}.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-insert) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-insert Method-Library 
PROCEDURE pi-insert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var i-line as int no-undo.
  def var rw-current as rowid no-undo.
    if  avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then
        assign i-line = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line.
    else
        assign i-line = 1.
      
    find last {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} no-error.
    if  avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then
        assign i-line = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line.  
    else
        assign i-line = 1.
  
    create {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
    assign {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line = i-line + 1
           i-line = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line.
  
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ).
   
    find {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} where {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.line = i-line.
    assign rw-current = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}})
           rw-last = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
    reposition {&browse-name} to rowid rw-current.
        
    run pi-entry.
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
  if last-event:label = "off-end":U and 
     l-elimina = yes then
    run insere-registro.
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
  if last-event:label = "cursor-down":U and
     rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-name}}) = rw-last then return "LAST":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-salva) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva Method-Library 
PROCEDURE pi-salva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then
  assign browse {&BROWSE-NAME} {&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}.
  
run pi-salva-rel.  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-save-record) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save-record Method-Library 
PROCEDURE pi-save-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if l-elimina = yes then
    run pi-salva.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
