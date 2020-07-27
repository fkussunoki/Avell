&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : i-vldfrm.i
    Purpose     : Seleciona a pagina correta do folder e executa a validacao de
                  de frame nesta pÿgina. Utilizado em viewers de cadastro complexo.
    Syntax      :

    Description :

    Author(s)   : Ricardo de Lima Perdigao
    Created     : 14/03/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEF VAR i_page-viewer AS INTEGER   NO-UNDO.
  DEF VAR i_page-atual  AS INTEGER   NO-UNDO.
  DEF VAR h_Container   AS HANDLE    NO-UNDO.
  DEF VAR h_aux         AS HANDLE    NO-UNDO.
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




RUN get-attribute ("W-Page":U).
ASSIGN i_page-viewer = INT(RETURN-VALUE).
RUN get-attribute ("W-Container-Source":U).
ASSIGN h_Container = WIDGET-HANDLE(RETURN-VALUE).
RUN get-attribute IN h_Container ("CURRENT-PAGE":U).
ASSIGN i_page-atual = INT(RETURN-VALUE).


&IF "{&ems_dbtype}" = "SQL" and PROVERSION begins "9" &THEN 
    IF  not FRAME {&FRAME-NAME}:VALIDATE("enabled-fields") THEN DO:
        IF  i_page-viewer <> i_page-atual AND i_page-viewer <> 0 THEN do:
            RUN select-page IN  h_Container (i_page-viewer).
            FRAME {&FRAME-NAME}:VALIDATE("enabled-fields").
        end.
        RETURN "ADM-ERROR":U.
        
    END.
    
&ELSE
IF  not FRAME {&FRAME-NAME}:VALIDATE() THEN DO:
    IF  i_page-viewer <> i_page-atual AND i_page-viewer <> 0 THEN do:
        RUN select-page IN  h_Container (i_page-viewer).
        FRAME {&FRAME-NAME}:VALIDATE().
    end.
    RETURN "ADM-ERROR":U.            
END.

&ENDIF


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
