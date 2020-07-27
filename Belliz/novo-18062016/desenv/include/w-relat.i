&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable wh-pesquisa             as handle               no-undo.
define variable c-arq-old               as char                 no-undo.
define variable c-arq-old-batch         as char                 no-undo.

define variable c-imp-old               as char                 no-undo.

/*tech868*/
&IF "{&PGIMP}" <> "" AND "{&mguni_version}" >= "2.04" &THEN
    &GLOBAL-DEFINE PDF YES
&ELSE
    &GLOBAL-DEFINE PDF NO
&ENDIF


/*tech14178 fun‡äes PDF */
&IF "{&PDF}" = "YES" &THEN /*tech868*/

    /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito valida‡Æo para verificar se a variavel h_pdf_controller j  foi definida 
                                                       anteriormente, evitando erro de duplicidade*/

    &IF defined(def_pdf_controller) = 0 &THEN         
        DEFINE VARIABLE h_pdf_controller     AS HANDLE NO-UNDO.

        &GLOBAL-DEFINE def_pdf_controller YES

        FUNCTION allowPrint RETURNS LOGICAL IN h_pdf_controller.
        
        FUNCTION allowSelect RETURNS LOGICAL IN h_pdf_controller.
        
        FUNCTION useStyle RETURNS LOGICAL IN h_pdf_controller.
        
        FUNCTION usePDF RETURNS LOGICAL IN h_pdf_controller.
    &endif
    
    /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito valida‡Æo para verificar se a variavel h_pdf_controller j  foi definida 
                                                       anteriormente, evitando erro de duplicidade*/


&endif



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
         HEIGHT             = 1.83
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Include 
/* ************************* Included-Libraries *********************** */

assign frame f-relat:visible = no
       frame f-relat:font = 1.
&IF "{&PGSEL}" <> "" &THEN
    assign frame f-pg-sel:visible = no
           frame f-pg-sel:font = 1.
&ENDIF
&IF "{&PGCLA}" <> "" &THEN
    assign frame f-pg-cla:visible = no
           frame f-pg-cla:font = 1.
&ENDIF
&IF "{&PGPAR}" <> "" &THEN
    assign frame f-pg-par:visible = no
           frame f-pg-par:font = 1.
&ENDIF
&IF "{&PGDIG}" <> "" &THEN
    assign frame f-pg-dig:visible = no
           frame f-pg-dig:font = 1.
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    assign frame f-pg-imp:visible = no
           frame f-pg-imp:font = 1.
&ENDIF


{include/i-rpent.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Include 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     Trata as mudan‡as de estado (State-Changed)
  Parameters:  INPUT Handle da procedure pai
               INPUT C¢digo do Estado
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.
  
  case entry(1, p-state, '|'):
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


