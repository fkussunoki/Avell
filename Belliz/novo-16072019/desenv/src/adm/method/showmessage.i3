&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Exibir mensagens de ERROR/INFORMATION/WARNING atrav‚s do utilit rio ut-show-msgs.w.

Este include faz somente a elimina‡Æo da instƒncia do utilit rio."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/ShowMessage.i3
    Purpose    : Exibir mensagens de ERROR/INFORMATION/WARNING atrav‚s do
                 utilit rio ut-show-msgs.w

    Authors    : John Cleber Jaraceski, Sergio Weber

    Notes      : Este include faz somente a elimina‡Æo da instƒncia do 
                 utilit rio
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/*--- Destr¢i tela de mensagens de erros ---*/
IF VALID-HANDLE(hShowMsg) and
  hShowMsg:TYPE = "PROCEDURE":U and
  hShowMsg:FILE-NAME = "utp/ShowMessage.w":U THEN DO:
       RUN destroyInterface IN hShowMsg.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


