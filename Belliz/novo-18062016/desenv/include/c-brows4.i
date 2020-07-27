&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza»’o dos browses"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-browse.i
    Purpose     : Implementar customiza»„es nos browsers

    Syntax      : {include/c-brows4.i}

    Description : Method-Library criada para fornecer customiza»’o para
                  os browses a serem utilizadas pelos programas do
                  Magnus97

    Author(s)   : Weber
    Created     : 12/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define variable wh-atributo     as handle    no-undo.
define variable wh-programa     as handle    no-undo.
def var c-container as char no-undo.
def new global shared var r-registro-atual as rowid     no-undo.
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
         HEIGHT             = 2.01
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

RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgAtributo":U).
         
RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgIncMod":U).
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-atributo) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atributo Method-Library 
PROCEDURE pi-atributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var rw-posicao as rowid no-undo.
    def var rw-parent  as rowid no-undo.
    if  valid-handle(wh-atributo) then
        return.
    RUN get-attribute ('ProgAtributo':U).
    IF  RETURN-VALUE <>  ? AND RETURN-VALUE <> "":U THEN DO:             
        run pi-posicao-browse (output rw-posicao).
        run pi-posicao-query  (output rw-parent).
        if rw-posicao <> ? then do:
            run value(RETURN-VALUE) persistent set wh-atributo 
                                        (input-output   rw-posicao,
                                         input          rw-parent,
                                         input          this-procedure,
                                         input          "alterar":U).
            if valid-handle(wh-atributo) then do:
                RUN dispatch in wh-atributo (input 'initialize':U).  
                if valid-handle(wh-atributo) then do:
                    run pi-reposiciona in wh-atributo.
                    run pi-desabilita-bts in wh-atributo.
                    run new-state in wh-atributo (input 'update-begin':U).
                end.  
            end.  
        end.   
    end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-container) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-container Method-Library 
PROCEDURE pi-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-container ).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-desabilita) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita Method-Library 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run pi-container.
run pi-desab IN widget-handle(c-container).     
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-eliminar) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eliminar Method-Library 
PROCEDURE pi-eliminar :
/*------------------------------------------------------------------------------
  Purpose:     Devolve a posicao do browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 if valid-handle(wh-programa) then
    return.
  if  avail {&FIRST-TABLE-IN-QUERY-{&browse-name}} then do with frame {&frame-name}:
      {include/confdel.i}
      if l-resposta then do: 
          find current {&FIRST-TABLE-IN-QUERY-{&browse-name}} exclusive-lock.
          delete {&FIRST-TABLE-IN-QUERY-{&browse-name}}.
          if  {&browse-name}:delete-current-row() then .  
          return "OK":U.
      end.            
      else
          return "NOK":U.
  end.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-habilita) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita Method-Library 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  run pi-container.
  run pi-habil IN widget-handle(c-container).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-posicao-browse) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicao-browse Method-Library 
PROCEDURE pi-posicao-browse :
/*------------------------------------------------------------------------------
  Purpose:     Devolve a posicao do browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter rw-posicao-browse as rowid no-undo.
    assign rw-posicao-browse = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-posicao-query) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicao-query Method-Library 
PROCEDURE pi-posicao-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define output parameter V-ROW-PARENT as rowid no-undo.
    ASSIGN v-ROW-PARENT   = ROWID ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-reposiciona-query) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-query Method-Library 
PROCEDURE pi-reposiciona-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-row-table as rowid no-undo.
  
  reposition {&browse-name} to rowid p-row-table no-error.
  RUN dispatch IN THIS-PROCEDURE ('get-next':U).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     Trata munda»as de estado no browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-issuer-hdl as handle no-undo.
    def input parameter p-state      as char   no-undo.
   
    case p-state:
        when 'Atributo':U then do:
            run pi-atributo.
        end.    
   end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
