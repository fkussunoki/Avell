&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : w-cadsim.i
    Purpose     : Permitir customiza‡Æo para as window de cadastro simples

    Syntax      : {include/w-cadsim.i}

    Description : Library utilizada para customiza‡Æo da window de cadastro
                  simples

    Author(s)   : Vanei
    Created     : 14/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable wh-pesquisa     as widget-handle    no-undo.
define variable wh-atributo     as widget-handle    no-undo.

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

run pi-trad-menu (input {&window-name}:menu-bar).

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

&IF DEFINED(EXCLUDE-pi-disable-menu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-menu Method-Library 
PROCEDURE pi-disable-menu :
def var p-button-enable as char no-undo.
  
APPLY "ENTRY" TO CURRENT-WINDOW.

  RUN get-button-enable IN h_p-cadsim (OUTPUT p-button-enable).
  assign menu-item mi-incluir:sensitive  in menu m-cadastro = (entry(1,p-button-enable)= string(yes))
         menu-item mi-copiar:sensitive   in menu m-cadastro = (entry(2,p-button-enable)= string(yes))
         menu-item mi-alterar:sensitive  in menu m-cadastro = (entry(3,p-button-enable)= string(yes))
         menu-item mi-eliminar:sensitive in menu m-cadastro = (entry(4,p-button-enable)= string(yes))
         menu-item mi-desfazer:sensitive in menu m-cadastro = (entry(5,p-button-enable)= string(yes))
         menu-item mi-cancelar:sensitive in menu m-cadastro = (entry(6,p-button-enable)= string(yes))
         menu-item mi-salvar:sensitive   in menu m-cadastro = (entry(7,p-button-enable)= string(yes)).
  
  RUN get-button-enable IN h_p-navega (OUTPUT p-button-enable).
  assign menu-item mi-primeiro:sensitive in menu m-cadastro = (entry(1,p-button-enable)= string(yes))
         menu-item mi-anterior:sensitive in menu m-cadastro = (entry(2,p-button-enable)= string(yes))
         menu-item mi-proximo:sensitive in menu m-cadastro = (entry(3,p-button-enable)= string(yes))
         menu-item mi-ultimo:sensitive in menu m-cadastro = (entry(4,p-button-enable)= string(yes))
         menu-item mi-va-para:sensitive in menu m-cadastro = (entry(5,p-button-enable)= string(yes))
         menu-item mi-pesquisa:sensitive in menu m-cadastro = (entry(6,p-button-enable)= string(yes)).
  
  RUN get-button-enable IN h_p-exihel (OUTPUT p-button-enable).
  assign menu-item mi-consultas:sensitive in menu m-cadastro = (entry(1,p-button-enable)= string(yes))
         menu-item mi-imprimir:sensitive in menu m-cadastro = (entry(2,p-button-enable)= string(yes))
         menu-item mi-sair:sensitive in menu m-cadastro = (entry(3,p-button-enable)= string(yes))
         menu-item mi-conteudo:sensitive in menu m-cadastro = (entry(4,p-button-enable)= string(yes)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-enter-go) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enter-go Method-Library 
PROCEDURE pi-enter-go :
/*------------------------------------------------------------------------------
  Purpose:     Trata salvar para go e return
  Notes:       
------------------------------------------------------------------------------*/
  run pi-salvar IN h_p-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trad-menu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trad-menu Method-Library 
PROCEDURE pi-trad-menu :
/*------------------------------------------------------------------------------
  Purpose: Tradu‡Æo dos Menus das Janelas    
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

