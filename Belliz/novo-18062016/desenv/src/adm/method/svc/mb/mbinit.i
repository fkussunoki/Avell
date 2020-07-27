&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m a implementa‡Æo para Servi‡o de RPC."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/svc/mb/mbinit.i
    Purpose    : Include que inicializa o mecanismo de Message Broker

    Parameters : 

    Author     :

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ****************************  Definitions  *************************** */

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
         HEIGHT             = 6.57
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF ("{&XMLProducer}" = "YES":U AND
    "{&SOMessageBroker}" <> "":U) OR
    "{&XMLAPI}" = "YES":U &THEN
    IF NOT VALID-HANDLE(hSOMessageBroker) OR 
       hSOMessageBroker:TYPE <> "PROCEDURE":U OR
       hSOMessageBroker:FILE-NAME <> "{&SOMessageBroker}":U THEN DO:
          IF CONNECTED ("mgmp") THEN /*Alterado por tech30713 - 31/10/06 - FO:1393771*/
            RUN {&SOMessageBroker} PERSISTENT SET hSOMessageBroker.
    END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


