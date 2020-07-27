&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

CREATE DATASUL-MESSAGE.
ASSIGN DATASUL-MESSAGE.TOPIC  = "{&Topic}"
       DATASUL-MESSAGE.ACTION = "API-RETURN"
       DATASUL-MESSAGE.SENDER = "{&Sender}".

RUN Buffer2XML IN hXMLParser (INPUT "",
                              INPUT (BUFFER DATASUL-MESSAGE:HANDLE),
                              INPUT ?,
                              INPUT "ACTION,SENDER,TOPIC,BODY":U,
                              INPUT "",
                              INPUT "",
                              INPUT-OUTPUT pReturnMessage).

RUN getElementHandle IN hXMLParser (INPUT pReturnMessage,
                                    INPUT 2,
                                    INPUT "BODY":U,
                                    OUTPUT hBody).

RUN Buffer2XML IN hXMLParser (INPUT "INDIVIDUAL-PARAMETERS",
                              INPUT (BUFFER {&TempTable}:HANDLE),
                              INPUT ?,
                              INPUT "",
                              INPUT "",
                              INPUT "",
                              INPUT-OUTPUT hBody).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


