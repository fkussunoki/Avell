&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Library para window pesquisa"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : w-pesqui.i
    Purpose     : Permitir customiza»’o para as window de pesquisa

    Syntax      : {include/w-pesqui.i}

    Description : Library utilizada para customiza»’o da window de pesquisa

    Author(s)   : Vanei
    Created     : 14/01/1997
    Notes       :
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable c-lista-atributos-chave as character init '':U  no-undo.
define variable wh-browse               as handle               no-undo.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-entry) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-entry Method-Library 
PROCEDURE pi-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* apply "entry" to bt-ok in frame {&frame-name}. */

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-entry-atributos-chave) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-entry-atributos-chave Method-Library 
PROCEDURE pi-entry-atributos-chave :
/*------------------------------------------------------------------------------
  Purpose:     Mostra o valor dos atributos chaves quando for um zoom de campo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define var wh-atributo   as widget-handle    no-undo.
    define var wh-parent     as widget-handle    no-undo.
    define var i-cont        as integer          no-undo.
    define var c-atributo    as character        no-undo.
    define var c-valor       as character        no-undo.
    if c-lista-atributos-chave = "" then
       return.
    do  i-cont = 1 to num-entries(c-lista-atributos-chave, chr(10)):
        assign c-atributo  = entry(i-cont, c-lista-atributos-chave, chr(10))
               wh-atributo = widget-handle(entry(1, entry(1, c-atributo, '=':U), '|':U)) 
            no-error.
    
        if  valid-handle(wh-atributo) then do:
            assign wh-parent = wh-atributo:PARENT.
        
            if valid-handle(wh-parent) then 
               if wh-parent:TYPE = "browse":U then
                  apply "ENTRY":U to wh-parent.
        
            apply "ENTRY":U to wh-atributo.
        end.
    end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-go) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-go Method-Library 
PROCEDURE pi-go :
/*------------------------------------------------------------------------------
  Purpose:     Trata evento de go
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  apply "value-changed" to self.
  
  if  v-row-table <> ? then do:
      run new-state ("Reposiciona|":U + string(v-row-table)).
  end.
  if  c-lista-atributos-chave <> "":U then
      run pi-mostra-atributos-chave.
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-mostra-atributos-chave) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-atributos-chave Method-Library 
PROCEDURE pi-mostra-atributos-chave :
/*------------------------------------------------------------------------------
  Purpose:     Mostra o valor dos atributos chaves quando for um zoom de campo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define variable wh-atributo   as widget-handle    no-undo.
  define variable i-cont        as integer          no-undo.
  define variable c-atributo    as character        no-undo.
  define variable c-valor       as character        no-undo.
  if  valid-handle(wh-browse)
  and c-lista-atributos-chave <> "":U then
  do  i-cont = 1 to num-entries(c-lista-atributos-chave, chr(10)):
      assign c-atributo  = entry(i-cont, c-lista-atributos-chave, chr(10))
             wh-atributo = widget-handle(entry(1, entry(1, c-atributo, '=':U), '|':U)) no-error.
      if  valid-handle(wh-atributo) then do:
          if  num-entries(c-atributo, '|':U) = 2 then
              run pi-retorna-valor in wh-browse (entry(2, c-atributo, '|':U)).
          else
              run pi-retorna-valor in wh-browse (wh-atributo:name).
          assign wh-atributo:screen-value = return-value.
          apply 'entry':U to wh-atributo. 
      end.
  end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-seta-atributos-chave) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-atributos-chave Method-Library 
PROCEDURE pi-seta-atributos-chave :
/*------------------------------------------------------------------------------
  Purpose:     Seta atributos chave
  Parameters:  INPUT com o handle dos atributos chave
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-lista-atributos-chave as character no-undo.
  
  if  c-lista-atributos-chave = "":U then
      assign c-lista-atributos-chave = p-lista-atributos-chave.
  else
      assign c-lista-atributos-chave = c-lista-atributos-chave + ',':U + p-lista-atributos-chave.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     Trata as mudan»as de estado (State-Changed)
  Parameters:  INPUT Handle da procedure pai
               INPUT C½digo do Estado
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.
  
  CASE entry(1, p-state, '|':U):
      when 'DblClick':U then do:
           /* *** apply 'go' to frame {&frame-name}. *** */
          run pi-go.
      end.
      when 'Value-Changed':U then do:
          assign wh-browse = widget-handle(entry(2, p-state, '|':U)) no-error.
      end.
  END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
