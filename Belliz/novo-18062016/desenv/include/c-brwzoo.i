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

    Author(s)   : Vanei
    Created     : 12/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/*--- Global Variable Definitions                                      ---*/
DEFINE NEW GLOBAL SHARED VARIABLE r-registro-atual AS ROWID NO-UNDO.
/*--- Variable Definitions                                             ---*/
DEFINE VARIABLE cContainer AS CHARACTER NO-UNDO.
DEFINE VARIABLE deTime     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hContainer AS HANDLE    NO-UNDO.
DEFINE VARIABLE lRepeat    AS LOGICAL   NO-UNDO.
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
  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgInclui":U).
  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgModifica":U).
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

PROCEDURE GetSystemTime EXTERNAL "KERNEL32.DLL":U PERSISTENT:
    DEFINE OUTPUT PARAMETER lpSystemTime AS MEMPTR NO-UNDO.
END.
&IF DEFINED(EXCLUDE-ApplyFillIn) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyFillIn Method-Library
PROCEDURE ApplyFillIn :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE wh-first-tab-item AS WIDGET-HANDLE NO-UNDO.
ASSIGN wh-first-tab-item = FRAME {&FRAME-NAME}:FIRST-CHILD
       wh-first-tab-item = wh-first-tab-item:FIRST-TAB-ITEM.
APPLY "ENTRY":U TO wh-first-tab-item.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-after-initialize) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-after-initialize Method-Library 
PROCEDURE pi-after-initialize :
/*------------------------------------------------------------------------------
  Purpose:     C½digo a ser executado ap½s a inicializa»’o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-before-initialize) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-before-initialize Method-Library 
PROCEDURE pi-before-initialize :
/*------------------------------------------------------------------------------
  Purpose:     C½digo a ser executado antes da inicializa»’o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-close-query) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-close-query Method-Library 
PROCEDURE pi-close-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
close query {&browse-name}.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-elimina) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina Method-Library 
PROCEDURE pi-elimina :
/*------------------------------------------------------------------------------
  Purpose:     Elimina a linha corrente do browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if  avail {&FIRST-TABLE-IN-QUERY-{&browse-name}} then do with frame {&frame-name}:
      {include/confdel.i}
      if l-resposta then do:
          delete {&FIRST-TABLE-IN-QUERY-{&browse-name}}.
          if  {&browse-name}:delete-current-row() then .
      end.
  end.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-inclui) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui Method-Library 
PROCEDURE pi-inclui :
/*------------------------------------------------------------------------------
  Purpose:     Chama programa de inclus’o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN get-attribute ('ProgInclui':U).
    IF  RETURN-VALUE <> ?
    AND RETURN-VALUE <> "":U THEN DO:
        run value(RETURN-VALUE).
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-modifica) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-modifica Method-Library 
PROCEDURE pi-modifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN get-attribute ('ProgModifica':U).
    IF  RETURN-VALUE <> ?
    AND RETURN-VALUE <> "":U THEN DO:
        run value(RETURN-VALUE).
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    END.
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
    def input parameter p-issuer-hdl as handle no-undo.
    def input parameter p-state      as char   no-undo.
    case p-state:
        when 'Inclui':U then do:
            run pi-inclui.
        end.
        when 'Modifica':U then do:
            run pi-modifica.
        end.
        when 'Elimina':U then do:
            run pi-elimina.
        end.
    end.
    /*Inicio alteracao para solucionar o problema na primeira visualizacao dos browsers nao default do folder*/
    if  (p-state = 'link-changed':U 
    OR  p-state = 'record-available':U)/*Fim alteracao*/
    and avail {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} then do:
        apply 'value-changed':U to {&browse-name} in frame {&frame-name}.
        apply 'entry':U to {&browse-name} in frame {&frame-name}.
    end.    
 END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-value-changed) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-value-changed Method-Library 
PROCEDURE pi-value-changed :
/*------------------------------------------------------------------------------
  Purpose:     Trata value-changed
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
