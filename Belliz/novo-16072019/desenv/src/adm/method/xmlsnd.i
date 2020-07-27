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

/* A altera‡Æo neste c¢digo deve ser repassada para o DWB */
IF l-XMLProducer AND lReceivingMsg = NO THEN DO:

    &IF DEFINED(SmartObject) > 0 OR
        DEFINED(DWB) > 0 &THEN
        FOR EACH RowErrors:
            DELETE RowErrors.
        END.
    &ENDIF
    RUN sendXMLMessage IN h-genericadapter.
    IF RETURN-VALUE = "NOK":U THEN DO:
        
        ASSIGN cReturnValue = "NOK":U
               lRepositionOldRecord = YES.
        &IF DEFINED(SmartObject) > 0 &THEN
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            RETURN "ADM-ERROR":U.
        &ELSE
            &IF DEFINED(DWB) > 0 &THEN
                FOR EACH rowErrors NO-LOCK:
                    ASSIGN cMsgErro = cMsgErro + STRING(RowErrors.ErrorSequence) + " - " + STRING(RowErrors.ErrorNumber) + " - " + RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp + chr(13).
                END.     
                @cx_message(9019,cMsgErro).                                       
                &IF ENTRY(1,'@&(program)':U,"_") = 'era':U &THEN
                    UNDO DELETE_BLOCK, LEAVE DELETE_BLOCK.
                &ELSE    
                    UNDO SAVE_BLOCK, LEAVE SAVE_BLOCK.
                &ENDIF    
            &ELSE
                UNDO TRANS_BLOCK, LEAVE TRANS_BLOCK.
            &ENDIF
        &ENDIF
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


