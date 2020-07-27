&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : c-broker.i
    Purpose     : Customiza‡äes do Broker

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get-Field-Screen-Value Procedure 
PROCEDURE Get-Field-Screen-Value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER    h_Issuer-hdl  AS HANDLE NO-UNDO.
 DEFINE INPUT PARAMETER    c_Field-Name  AS CHAR   NO-UNDO.
 DEFINE VAR   h_Container                AS HANDLE NO-UNDO.
 DEFINE VAR   c_Container                AS CHAR   NO-UNDO.
 
 RUN Who-Is-The-Container (h_Issuer-hdl, OUTPUT c_Container).
 IF  c_Container = "?" THEN RETURN "ADM-ERROR".
 ASSIGN h_Container = WIDGET-HANDLE(c_Container).
 RUN Scan-Each-Linked-Objects (h_Container,h_Issuer-hdl,c_Field-Name).
 RETURN RETURN-VALUE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Scan-Each-Linked-Objects Procedure 
PROCEDURE Scan-Each-Linked-Objects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_Container  AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER h_Issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER c_Field-Name AS CHAR  NO-UNDO.
  DEFINE VAR   c_Field-Screen-Value   AS CHAR   NO-UNDO.
  DEFINE VAR   i_Num                  AS INT    NO-UNDO.
  DEFINE VAR   c_Handle               AS CHAR   NO-UNDO.
  DEFINE VAR   h_Handle               AS HANDLE NO-UNDO.
  ASSIGN c_Field-Screen-Value = "".
  RUN get-link-handle IN adm-broker-hdl504 (INPUT h_Container, 
                                         INPUT 'CONTAINER-TARGET':U,
                                         OUTPUT c_Handle ).
Scan-Objects:
  DO i_Num = 1 TO NUM-ENTRIES(c_Handle):
     h_Handle = WIDGET-HANDLE(ENTRY(i_Num,c_Handle)).
     IF h_handle = h_Issuer-hdl THEN NEXT.
     
     RUN get-attribute IN h_Handle( 'TYPE':U ).
     IF RETURN-VALUE EQ 'SmartViewer':U OR
        RETURN-VALUE EQ 'CustomViewDigita':U THEN
        DO:
          RUN get-attribute IN h_handle("ADM-OBJECT-HANDLE":U).
          RUN Scan-Field-On-Object (WIDGET-HANDLE(RETURN-VALUE), c_Field-Name).
          ASSIGN c_Field-Screen-Value = RETURN-VALUE.
          IF c_Field-Screen-Value <> "" THEN LEAVE Scan-Objects.
        END.
  END.
  RETURN c_Field-Screen-Value.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Scan-Field-On-Object Procedure 
PROCEDURE Scan-Field-On-Object :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_Frame        AS HANDLE.
DEFINE INPUT PARAMETER c_Field-Names  AS CHAR.          
DEFINE VAR   c_Type                   AS CHAR INITIAL "Fill-in,Radio-set,Combo-box,Editor,Selection-List,Toggle-box,Slider".

DO :
  ASSIGN h_Frame = h_Frame:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h_Frame = h_Frame:FIRST-CHILD. /* pegando o 1o. Campo */
  
  DO WHILE h_Frame <> ? :
     IF LOOKUP(h_Frame:TYPE, c_Type) <> 0 and
        LOOKUP(h_Frame:TYPE, c_Type) <> ? and
        LOOKUP(h_Frame:NAME, c_Field-Names) <> 0 and 
        LOOKUP(h_Frame:NAME, c_Field-Names) <> ? THEN
        DO :
           RETURN  h_Frame:SCREEN-VALUE.
        END.
     ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
  END.
  RETURN "".
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE What-Is-The-Page Procedure 
PROCEDURE What-Is-The-Page :
/*------------------------------------------------------------------------------
  Purpose:    What-Is-The-Page : Informa a pagina onde o objeto esta colocado 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT   PARAMETER h_Issuer-hdl AS HANDLE.

FOR FIRST adm-link-table WHERE adm-link-table.link-target = h_Issuer-hdl AND 
                               adm-link-table.link-type <> "PAGE" AND
                               adm-link-table.link-type BEGINS "PAGE" NO-LOCK :
    RETURN substring(adm-link-table.link-type,5,1).
END.                              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Who-Is-The-Container Procedure 
PROCEDURE Who-Is-The-Container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER h_Issuer-hdl AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER c_Container  AS CHAR   NO-UNDO.

RUN get-link-handle /* IN adm-broker-hdl504 */ (h_Issuer-hdl,"CONTAINER-SOURCE", OUTPUT c_Container).
IF VALID-HANDLE(WIDGET-HANDLE(c_Container)) THEN.
ELSE
    ASSIGN c_Container = "?".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



