&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Library para window consulta simples"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : w-livre.i
    Purpose     : Permitir customiza‡Æo para as window de consulta simples

    Syntax      : {include/w-livre.i}

    Description : Library utilizada para customiza‡Æo da window de consulta
                  simples

    Author(s)   : Gilsinei
    Created     : 06/03/1997
    Notes       :
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable wh-pesquisa                as handle no-undo.
define variable wh-relacionamento          as handle no-undo.
define variable wh-consulta                as handle no-undo.
define variable v-row-table                as rowid no-undo.
define variable wh-programa                as handle no-undo.
define variable c-container                as char   no-undo.
define variable wh-container               as handle no-undo.
define variable container                  as char   no-undo.
def new global shared var r-registro-atual as rowid  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */
{include/i_fnctrad.i}


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

assign current-window:max-width-chars = current-window:width-chars
       current-window:max-height-chars = current-window:height-chars.

run pi-trad-menu (input {&window-name}:menubar).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-after-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-after-initialize Method-Library 
PROCEDURE pi-after-initialize :
/*------------------------------------------------------------------------------
  Purpose:     C¢digo a ser executado ap¢s a inicializa‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if  valid-handle(h_p-exihel) then
      run set-prog-parent in h_p-exihel (program-name(1)).

  /*Tradu‡Æo dos campos de tela*/
&IF "{&FNC_MULTI_IDIOMA}":U = "YES":U &THEN
    /*Verifica‡Æo da existencia da ut-trcampos no ambiente*/
    IF SEARCH("utp/ut-trcampos.r":U) <> ? OR 
        SEARCH("utp/ut-trcampos.p":U) <> ? THEN
        RUN utp/ut-trcampos.p.
&ENDIF
/*fim tradu‡Æo dos campos de tela*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-before-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-before-initialize Method-Library 
PROCEDURE pi-before-initialize :
/*------------------------------------------------------------------------------
  Purpose:     C¢digo a ser executado antes da inicializa‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-consulta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consulta Method-Library 
PROCEDURE pi-consulta :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de pesquisa e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-inicio    as integer no-undo.
def var i-fim       as integer no-undo.
def var rw-reserva  as rowid   no-undo.

    RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure,
         OUTPUT c-container).

    assign i-inicio     = r-index(THIS-PROCEDURE:file-name,"/") + 1
           i-fim        = r-index(THIS-PROCEDURE:file-name,".w").

    if i-fim < r-index(THIS-PROCEDURE:file-name,".r") then
       i-fim = r-index(THIS-PROCEDURE:file-name,".r").
    if i-inicio < r-index(THIS-PROCEDURE:file-name,"\") then
       i-inicio = r-index(THIS-PROCEDURE:file-name,"\") + 1.

    run utp/ut-cons.w (input substring(THIS-PROCEDURE:file-name,i-inicio , i-fim - i-inicio)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-disable-menu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-menu Method-Library 
PROCEDURE pi-disable-menu :
def var p-button-enable as char no-undo.
  
  RUN get-button-enable IN h_p-exihel (OUTPUT p-button-enable).
  assign menu-item mi-consultas:sensitive in menu m-livre = (entry(1,p-button-enable)= string(yes))
         menu-item mi-imprimir:sensitive in menu m-livre = (entry(2,p-button-enable)= string(yes))
         menu-item mi-sair:sensitive in menu m-livre = (entry(3,p-button-enable)= string(yes))
         menu-item mi-conteudo:sensitive in menu m-livre = (entry(4,p-button-enable)= string(yes))
         menu-item mi-sobre:sensitive in menu m-livre = (entry(4,p-button-enable)= string(yes)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trad-menu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trad-menu Method-Library 
PROCEDURE pi-trad-menu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-trdmn.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     Trata as mudan‡as de estado (State-Changed)
  Parameters:  INPUT Handle da procedure pai
               INPUT C¢digo do Estado
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.

  CASE entry(1, p-state, "|":U):
      WHEN 'Consulta':U THEN DO:
          run pi-consulta.
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

