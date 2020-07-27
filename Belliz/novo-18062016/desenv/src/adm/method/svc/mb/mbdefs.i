&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Include que cont‚m defini‡äes para Servi‡o de RPC."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    Library    : method/svc/mb/mbdefs.i
    Purpose    : Include que cont‚m defini‡äes para Servi‡o de Message Broker

    Parameters :

    Author     : Alexandre Krammel

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */


/* DBO-XML-BEGIN */
/*--- So compila se for necessario (XMLProducer = YES) ---*/
&IF ("{&XMLProducer}" = "YES":U AND
    "{&SOMessageBroker}" <> "":U) OR "{&XMLGenericAdapter}" = "YES":U OR
    "{&XMLAPI}" = "YES":U &THEN

    /*--- Defini‡Æo de vari vel que cont‚m o handle global do DBO de MB ---*/
    DEFINE NEW GLOBAL SHARED VARIABLE hSOMessageBroker AS HANDLE NO-UNDO. /* Handle SOMessageBroker */
    
    /*--- Defini‡Æo da temp-table usada para preparar o conte£do de <DATASUL-MESSAGE> ---*/
    DEFINE TEMP-TABLE DATASUL-MESSAGE NO-UNDO
        FIELD TOPIC    AS CHAR
        FIELD ACTION   AS CHAR
        FIELD SENDER   AS CHAR
        FIELD BODY     AS CHAR.
    
&ENDIF
/* DBO-XML-END */

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
         HEIGHT             = 6.71
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


