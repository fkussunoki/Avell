&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza»’o dos browses"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-browse.i
    Purpose     : Implementar customiza»„es nos browsers

    Syntax      : {include/c-brows2.i}

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
 
    RUN get-attribute ('ProgAtributo':U).
    IF  RETURN-VALUE <>  ?
    AND RETURN-VALUE <> "":U 
    THEN DO:
        ASSIGN v-ROW-PARENT   = ROWID ({&FIRST-EXTERNAL-TABLE}).
        run value(RETURN-VALUE) persistent set wh-atributo (input-output v-row-table,
                                                            input v-row-parent,
                                                            input this-procedure,  
                                                            input "" ).
        RUN dispatch in wh-atributo (input 'initialize':U).
           
    end.
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
define input parameter p-issuer-hdl as handle no-undo.
define input parameter p-state      as char   no-undo.
case p-state:
    when "no-external-record-available":U then
        assign bt-formar:SENSITIVE in frame {&FRAME-NAME} = no.
    when "no-record-available":U then
        assign bt-formar:SENSITIVE in frame {&FRAME-NAME} = yes.
    when "record-available":U then
        assign bt-formar:SENSITIVE in frame {&FRAME-NAME} = yes.
    when "dblclick":U then
        apply "CHOOSE":U to bt-formar in frame {&FRAME-NAME}.
end case.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
