&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza»’o dos browses"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-browse.i
    Purpose     : Implementar customiza»„es nos browsers

    Syntax      : {include/c-browse.i}

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
def new global shared var gr-{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} as rowid no-undo.
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
         HEIGHT             = .57
         WIDTH              = 40.86.
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
    IF  RETURN-VALUE <>  ? AND RETURN-VALUE <> "":U THEN DO:
        GET CURRENT {&BROWSE-NAME}.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
           ASSIGN gr-{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
           run value(RETURN-VALUE) persistent set wh-atributo.
           RUN dispatch in wh-atributo (input 'initialize':U).
        END.
    end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF

&IF DEFINED(EXCLUDE-pi-detalhe) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe Method-Library 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var rw-posicao as rowid no-undo.
    if  valid-handle(wh-atributo) then
        return.
    RUN get-attribute ('ProgAtributo':U).
    IF  RETURN-VALUE <>  ?
    AND RETURN-VALUE <> "":U 
    THEN DO:             
      run pi-posicao-browse (output rw-posicao).
      if rw-posicao <> ? then do:
         run value(RETURN-VALUE) persistent set wh-atributo.
         if valid-handle(wh-atributo) then do:
           RUN dispatch in wh-atributo (input 'initialize':U).  
           run pi-reposiciona in wh-atributo (input-output rw-posicao).
         end.  
      end.   
    end.
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

if valid-handle(wh-programa) then return.
if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then do with frame {&FRAME-NAME}:
    {include/confdel.i}
    if l-resposta then do:
        delete {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.
        if {&browse-name}:DELETE-CURRENT-ROW() then .

        find current {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} no-lock no-error.
        if avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
        then run new-state ("record-available, SELF":U).
        else run new-state ("no-record-available, SELF":U).

        return "OK":U.
    end.
    else return "NOK":U.
end.
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
&IF DEFINED(EXCLUDE-pi-reposiciona-query) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-query Method-Library 
PROCEDURE pi-reposiciona-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-row-table AS ROWID NO-UNDO.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o reposicionamento de  
              registros em browse devido a deficiencia dos Templates PROGRESS 
              com DATABASE DIFERENTE DE PROGRESS
              **********************************/
    &IF "{&ems_dbtype}":U = "progress":U &THEN
        REPOSITION {&BROWSE-NAME} TO ROWID p-row-table NO-ERROR.
        RUN dispatch IN THIS-PROCEDURE ('get-next':U).
    &ENDIF
/***********************************************/

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
define var wh-objeto as widget-handle no-undo.
case p-state:
    when "Atributo":U then do:
        run pi-atributo.
    end.
    when "no-record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-idet":U or
               wh-objeto:NAME = "bt-detalhar":U then
                assign wh-objeto:SENSITIVE = no.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "no-external-record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-idet":U or
               wh-objeto:NAME = "bt-detalhar":U then
                assign wh-objeto:SENSITIVE = no.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-idet":U or
               wh-objeto:NAME = "bt-detalhar":U then
                assign wh-objeto:SENSITIVE = yes.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "dblclick":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-idet":U or
               wh-objeto:NAME = "bt-detalhar":U then
                leave.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.

        if valid-handle(wh-objeto) then
            apply "CHOOSE":U to wh-objeto.
    end.
end case.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF

