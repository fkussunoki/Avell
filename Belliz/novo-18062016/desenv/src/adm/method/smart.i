&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*-------------------------------------------------------------------------
    File        : smart.i  
    Purpose     : Provides basic SmartObject functionality.

    Syntax      : {src/adm/method/smart.i}

    Description :

    Author(s)   :
    Created     :
    Notes       :
--------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

def var c-nom-prog-upc-mg97  as char format "x(50)" no-undo.
def var c-nom-prog-appc-mg97 as char format "x(50)" no-undo.
def var c-nom-prog-dpc-mg97  as char format "x(50)" no-undo.
def var c-ctrl-tab           as char                no-undo.
def var h-ctrl-tab           as handle              no-undo.
def var wh-entry-field       as widget-handle       no-undo.

/* vari†vel que identifica dialogs - n∆o pode-se utilizar pre-processador */
/* porque ela n∆o Ç a primeira include do method libraries                */
/* Vari†vel criada para saber quando um programa Ç dialog.                */
/* Se for YES Ç dialog. A vari†vel foi criada devido a problemas          */
/* com traduá∆o - 1085750 - Valdir tech14187                              */
DEFINE VARIABLE adm-dialog AS LOGICAL INITIAL NO   NO-UNDO.

&IF DEFINED (adm-smart) = 0 &THEN
&GLOBAL adm-smart

{include/i_dbvers.i}

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN /* FO 1540.701 - corp340521 - 22/07/2008 */
    /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/    
    define new global shared variable h-facelift as handle no-undo.
    if not valid-handle(h-facelift) then run btb/btb901zo.p persistent set h-facelift.
&ENDIF
&ENDIF


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
         HEIGHT             = 2.93
         WIDTH              = 35.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}
{include/i_fnctrad.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* The code to assign the object handle (which becomes the ADM-OBJECT-HANDLE
   attribute below) for containers and for other objects has been combined
   here. Note that setting adm-object-hdl later in user code (including the
   main block of a MLI) will have no effect on the value of the attribute.
   To override these default settings (which should be appropriate for 
   virtually all objects) user code must 
     RUN set-attribute-list ('ADM-OBJECT-HANDLE=...').

   For SmartContainers, set the handle to the Frame handle if the
   Container Type is FRAME or DIALOG-BOX, else to WINDOW, unless the
   Container is "virtual" (no visualization), in which case leave it unknown.

   For other objects, set the handle to the default Frame handle if 
   there is one.
*/

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "FRAME":U OR "{&ADM-CONTAINER}":U = "DIALOG-BOX":U 
  &THEN
    ASSIGN adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE. 
  &ELSEIF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
    ASSIGN adm-object-hdl    =   {&window-name}.
  &ELSE
    ASSIGN adm-object-hdl    = ?. /* Container has no visualization. */
  &ENDIF
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
      adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE.
  &ENDIF
&ENDIF

&IF  DEFINED(adm-containr) <> 0 &THEN   
    &IF DEFINED(PGIMP) = 0 AND DEFINED(PGLOG) = 0 &THEN
        run piTooltipHelp (input frame {&frame-name}:handle).
    &ENDIF
&ENDIF

&IF DEFINED(adm-viewer) <> 0 &THEN 
    run piTooltipHelp (input frame {&frame-name}:handle).
&ENDIF       

&IF DEFINED(adm-browser) <> 0 &THEN 
    run piTooltipHelp (input frame {&frame-name}:handle).
&ENDIF       

/* If the broker handle either isn't valid or isn't the right process
   (it's possible the handle has been reused), then start the broker. 
   (But don't let the broker try to start itself!) */
&IF "{&PROCEDURE-TYPE}":U NE "ADM-Broker":U &THEN
RUN get-attribute IN adm-broker-hdl ('TYPE':U) NO-ERROR.
IF RETURN-VALUE NE "ADM-Broker":U THEN 
DO: 
    RUN adm/objects/broker.p PERSISTENT set adm-broker-hdl. 
    RUN set-broker-owner IN adm-broker-hdl (THIS-PROCEDURE).
END.
&ENDIF

/* Initialize all the attributes which all SmartObjects must have. */

THIS-PROCEDURE:{&ADM-DATA} = 
     '{&ADM-VERSION}~`':U +         /* Version attribute */
     '{&PROCEDURE-TYPE}~`':U +      /* Type attribute */
     '{&ADM-CONTAINER}~`':U +       /* Container-Type attribute */
   &IF DEFINED (adm-open-query) NE 0 &THEN
     'YES~`':U +                   /* Query-Object attribute */
   &ELSE
     'NO ~`':U +
   &ENDIF
     '{&EXTERNAL-TABLES}~`':U +    /* External-Tables attribute */
     '{&INTERNAL-TABLES}~`':U +    /* Internal-Tables attribute */
   &IF DEFINED(adm-browser) NE 0 &THEN  
     '{&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}~`':U +
   &ELSE
     '{&ENABLED-TABLES}~`':U +     /* Enabled-Tables attribute */
   &ENDIF
     (IF adm-object-hdl = ? THEN "":U ELSE STRING(adm-object-hdl))
        + "~`":U +    /* Adm-Object-Handle attribute */
   &IF DEFINED(ADM-ATTRIBUTE-LIST) NE 0 &THEN
     '{&ADM-ATTRIBUTE-LIST}~`':U +  /* Attribute-List attribute */
   &ELSE 
     '?~`':U +
   &ENDIF
   &IF "{&User-Supported-Links}":U NE "":U &THEN
     '{&ADM-SUPPORTED-LINKS},{&User-Supported-Links}~`':U +
   &ELSE
     '{&ADM-SUPPORTED-LINKS}~`':U + /* Supported-Links attribute */
   &ENDIF
     '{&ADM-DISPATCH-QUALIFIER}~`':U +  /* ADM-Dispatch-Qualifier attr */
     '~`~`~`~`~`~`~`~`~`~`~`':U +   /* Placeholders for ADM-Parent, Layout,
                                      Enabled, Hidden, COntainer-Hidden,
                                      Initialized, Fields-Enabled, Current-Page,
                                      ADM-New-Record, UIB-Mode, 
                                      ADM-Deactivate-Links */
    /* PLUS THERE IS AN EXTRA TICK FOR THE DUMMY PREPROC
       which marks the end of the list. Do not disturb. */ 
     IF THIS-PROCEDURE:{&ADM-DATA} = "":U OR THIS-PROCEDURE:{&ADM-DATA} = ? 
         THEN "^^":U             /* plus placeholders for user-defined attrs. */
     /* Or if there are already attributes defined, don't throw them away. */
     ELSE "^":U + ENTRY(2, THIS-PROCEDURE:{&ADM-DATA}, "^":U) + 
          "^":U + ENTRY(3, THIS-PROCEDURE:{&ADM-DATA}, "^":U).


/* An "apply-layout" method is not necessary if there are no layout-cases */
&IF "{&LAYOUT-VARIABLE}" eq "" &THEN
  &Scoped-define EXCLUDE-adm-apply-layout YES
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-apply-entry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-entry Method-Library 
PROCEDURE adm-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled field or other 
               object in the SmartObject.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR c_Handle AS CHAR NO-UNDO.
  ASSIGN c_Handle = "".
  RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, 
                                         INPUT 'TABLEIO-SOURCE':U,
                                         OUTPUT c_Handle ).
  IF c_Handle <> "" THEN                                       
  RUN broker-apply-entry IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-apply-layout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-layout Method-Library 
PROCEDURE adm-apply-layout :
/*------------------------------------------------------------------------------
  Purpose:     Apply the value of the Layout Attribute.
  Parameters:  <none>
  Notes:       ********************************************************
               IMPORTANT -- if you RENAME this method, check the code
               in the MAIN CODE BLOCK that excludes this method.
               ********************************************************
------------------------------------------------------------------------------*/
  DEFINE VARIABLE layout-name AS CHARACTER NO-UNDO.

  /* Get the layout name. */
  RUN get-attribute ('Layout':U).
  layout-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.

  /* A blank layout-name means return to the Default-Layout. If there is
     no default-layout, then return to the Master Layout. */
  IF layout-name eq "":U THEN DO:
    RUN get-attribute IN THIS-PROCEDURE ('Default-Layout':U).
    layout-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
    IF layout-name eq "":U THEN layout-name = "Master Layout":U.
  END. /* IF layout-name eq ... */

  /* Does the layout REALLY need changing, or is it already in use? */
  IF {&LAYOUT-VARIABLE} ne layout-name THEN DO:
    /* Always change layouts by FIRST resetting to the Master Layout. 
       (assuming that the layout isn't already the Master.) */
    IF {&LAYOUT-VARIABLE} ne "Master Layout":U 
    THEN RUN {&LAYOUT-VARIABLE}s ("Master Layout":U).
    /* Now change to the desired layout. */
    IF layout-name ne "Master Layout":U 
    THEN RUN {&LAYOUT-VARIABLE}s (layout-name).
    RUN dispatch ('display-fields':U).  /* redisplay any newly viewed fields. */
  END. /* IF...LAYOUT...ne layout-name... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-destroy Method-Library 
PROCEDURE adm-destroy :
/* -----------------------------------------------------------
      Purpose:     Basic routine to delete a procedure and its
                   CONTAINED descendents
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   

 &IF  DEFINED(adm-containr) <> 0 &THEN
      {include/i-epc100.i}
 &ENDIF

 RUN broker-destroy IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-disable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-disable Method-Library 
PROCEDURE adm-disable :
/* -----------------------------------------------------------
      Purpose:     Disables all enabled objects in the frame.
                   Note that this includes db fields if any.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   
    /* EPC Before Disable do Container */
    &IF  DEFINED(adm-containr) <> 0 &THEN
         {include/i-epc026.i}
    &ENDIF

    &IF "{&FRAME-NAME}":U NE "":U &THEN
    DISABLE {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.
    RUN dispatch ('disable-fields':U).  
    &ENDIF                              

    /* EPC Disable do Container */
    &IF  DEFINED(adm-containr) <> 0 &THEN
         {include/i-epc009.i}
    &ENDIF


    RUN set-attribute-list ('ENABLED=no':U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-edit-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-edit-attribute-list Method-Library 
PROCEDURE adm-edit-attribute-list :
/* -----------------------------------------------------------
      Purpose:    Runs the dialog to get runtime parameter settings
      Parameters:  <none>
      Notes:       Generally run by the UIB in design mode
    -------------------------------------------------------------*/   
  &IF "{&adm-attribute-dlg}":U NE "":U &THEN  /* Must be defined in the Object*/
      RUN {&adm-attribute-dlg} (INPUT THIS-PROCEDURE).
  &ELSE MESSAGE "There is no attribute list dialog for this object.":U
          VIEW-AS ALERT-BOX WARNING.
  &ENDIF

      RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-enable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-enable Method-Library 
PROCEDURE adm-enable :
/* -----------------------------------------------------------
      Purpose:    Enable an object - all components except db fields,
                  which are enabled using enable-fields.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   
   /* EPC Before Enable do Container */
   &IF  DEFINED(adm-containr) <> 0 &THEN
        {include/i-epc025.i}
   &ENDIF

   &IF "{&FRAME-NAME}":U NE "":U &THEN
    ENABLE {&UNLESS-HIDDEN} {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.

    /* We also run enable_UI from here. */ 
    RUN enable_UI IN THIS-PROCEDURE NO-ERROR.
   &ENDIF                          

   /* EPC Enable do Container */
   &IF  DEFINED(adm-containr) <> 0 &THEN
        {include/i-epc008.i}
   &ENDIF

   RUN set-attribute-list ('ENABLED=yes':U).

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-exit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-exit Method-Library 
PROCEDURE adm-exit :
/* -----------------------------------------------------------
      Purpose: Passes an exit request to its container    
      Parameters:  <none>
      Notes:  The convention is that the standard routine always
          passes an exit request to its CONTAINER-SOURCE. The container 
          that is actually able to initiate the exit should define
          a local version and *not* call the standard one.    
          That local-exit is built into the SmartWindow template.
    -------------------------------------------------------------*/   

     RUN notify ('exit':U).

  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-hide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-hide Method-Library 
PROCEDURE adm-hide :
/* -----------------------------------------------------------
      Purpose:     Hides an object and sets any active links which
                   are dependent on hide/view off.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   
  RUN broker-hide IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-initialize Method-Library 
PROCEDURE adm-initialize :
/* -----------------------------------------------------------
      Purpose:     Enables and Views an object unless its attributes
                   indicate this should not be done.
                   Cascades 'initialize' to descendents.
      Parameters:  <none>
      Notes:       
   -------------------------------------------------------------*/   
   /* alteraªío feita para atender ao WebEnabler - Marcilene Oliveira - 18/12/2003 */

   &IF DEFINED(WEN-CONTROLLER) &THEN /* est† verificaá∆o se faz necess†ria devido aos programas */
      {include/i-wenreg.i}           /* criados pelos DataViewer n∆o utilizarem a include i-prgvrs */ 
   &ENDIF                            /* e dessa forma n∆o chamarem a include i-wendef.i que define essa veri†vel. */ 

   /* fim da alateraá∆o */

   /* EPC Before Initialize do Container */ 
   &IF  DEFINED(adm-containr) <> 0 &THEN
        {include/i-epc024.i}
   &ENDIF

   /* EPC Before Initialize do Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc018.i}
   &ENDIF

   /* EPC Before Initialize do Browser */
   &IF DEFINED(adm-browser) <> 0 &THEN
        {include/i-epc034.i}
   &ENDIF   

   RUN broker-initialize IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
   /*   Alteraá∆o para corrigir o problema de algumas viewers n∆o mostrar
        o primeiro registro quando o programa Ç inicializado               
        Data : 20/Fev/97  - J.Carlos (PGS)  -  Egolf e SÇrgio (DATASUL)  */  
   &IF  DEFINED(PGS-QG1) = 0 &THEN 
        &IF "{&frame-name}" <> "" &THEN
             IF  frame {&frame-name}:scrollable THEN
                 ASSIGN frame {&frame-name}:virtual-width-chars  = frame {&frame-name}:width-chars
                        frame {&frame-name}:virtual-height-chars = frame {&frame-name}:height-chars.
        &ENDIF             
   &ENDIF    
   {include/c-page.i }

   &IF  DEFINED(adm-containr) <> 0 &THEN
        run get-link-handle in adm-broker-hdl
             (input this-procedure,
              input 'page':U,
              output c-ctrl-tab).
        assign h-ctrl-tab = if c-ctrl-tab <> "" then widget-handle(c-ctrl-tab) else ?.
   &ENDIF

   /* EPC - Initialize do Container */ 
   &IF  DEFINED(adm-containr) <> 0 &THEN
        {include/i-epc007.i}
   &ENDIF

   /* EPC - Initialize do Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc001.i}
   &ENDIF

   /* EPC - Initialize do Browser */
   &IF DEFINED(adm-browser) <> 0 &THEN
        {include/i-epc017.i}
   &ENDIF   

   &IF DEFINED(adm-containr) <> 0 &THEN
       RUN get-attribute IN THIS-PROCEDURE ("ApplyFillIn":U).
       IF ENTRY(1, RETURN-VALUE, "|":U) = "YES":U THEN
          RUN ApplyFillIn IN WIDGET-HANDLE(ENTRY(2, RETURN-VALUE, "|":U)).
   &ENDIF

   /*Traduá∆o dos campos de tela*/
   &IF "{&FNC_MULTI_IDIOMA}":U = "YES":U OR "{&aplica_facelift}" = "YES" &THEN
       &IF DEFINED(adm-containr) <> 0 &THEN
            If search("utp/ut-trcampos.p":U) <> ? or search("utp/ut-trcampos.r":U) <> ? THEN DO:
                &IF "{&FRAME-NAME}":U NE "":U &THEN
                    /* modificado conforme FO 1085750 - Valdir - tech14187*/
                    IF adm-dialog = YES THEN DO:
                        If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? THEN DO:
                            RUN utp/ut-trfrrp.p (INPUT FRAME {&FRAME-NAME}:HANDLE).
                        END.
                    END.
                    ELSE
                &ENDIF
                    RUN utp/ut-trcampos.p.
            END.
       &endif
       &IF DEFINED(adm-browser) <> 0 &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&frame-name}:Handle).
       &elseif Defined(adm-viewer) <> 0 &then
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&frame-name}:Handle).
       &endif

        &IF "{&PGSEL}":U <> "":U &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then 
                Run utp/ut-trfrrp.p (input Frame {&PGSEL}:Handle).
        &ENDIF
        &IF "{&PGCLA}":U <> "":U &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&PGCLA}:Handle).
        &ENDIF
        &IF "{&PGPAR}":U <> "":U &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&PGPAR}:Handle).
        &ENDIF
        &IF "{&PGDIG}":U <> "":U &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&PGDIG}:Handle).
        &ENDIF
        &IF "{&PGIMP}":U <> "":U &THEN
            If search("utp/ut-trfrrp.p":U) <> ? or search("utp/ut-trfrrp.r":U) <> ? Then
                Run utp/ut-trfrrp.p (input Frame {&PGIMP}:Handle).
        &ENDIF
   &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-show-errors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-show-errors Method-Library 
PROCEDURE adm-show-errors :
/* -----------------------------------------------------------
      Purpose:  Display system error messages on a runtime error.
      Parameters:  <none>
      Notes:    A localization of this method can look at the message
                number to display a custom error or suppress standard
                error display.
    -------------------------------------------------------------*/

    DEFINE VARIABLE        cntr                  AS INTEGER   NO-UNDO.

    DO cntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
        MESSAGE ERROR-STATUS:GET-MESSAGE(cntr).
    END.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-UIB-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-UIB-mode Method-Library 
PROCEDURE adm-UIB-mode :
/*--------------------------------------------------------------------------
  Purpose     : Set the objects attributes in "UIB Mode".  This is the
                "mode" it will have in design-mode in the UIB.
  Notes       :
  ------------------------------------------------------------------------*/

  RUN broker-UIB-mode IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-view) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-view Method-Library 
PROCEDURE adm-view :
/* -----------------------------------------------------------
      Purpose:     Views an object and sets active links on.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   

  RUN broker-view IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.

  &IF  DEFINED(adm-viewer) <> 0 &THEN
       assign wh-entry-field = frame {&frame-name}:handle
              wh-entry-field = wh-entry-field:first-child
              wh-entry-field = wh-entry-field:first-child.
       do  while(valid-handle(wh-entry-field)):
           if  wh-entry-field:sensitive = yes 
           and wh-entry-field:type <> 'rectangle' then do:
               apply 'entry' to wh-entry-field.
               leave.
           end.
           else
               assign wh-entry-field = wh-entry-field:next-sibling.    
       end.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispatch Method-Library 
PROCEDURE dispatch :
/* -----------------------------------------------------------
      Purpose:    Determines whether to run the LOCAL or STANDARD (adm-)
                  or no-prefix version of a method in the current procedure.
      Parameters: INPUT base method name (with no prefix),
      Notes:      In addition, if the developer has defined a custom prefix
                  as ADM-DISPATCH-QUALIFIER, then a method with this prefix
                  will be searched for after "local-" and before "adm-".
                  If the preprocessor ADM-SHOW-DISPATCH-ERRORS is defined
                  then the show-errors method will be dispatched if a
                  method name is not found in any form. This can be 
                  useful for debugging purposes.
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.

    RUN broker-dispatch IN adm-broker-hdl 
        (THIS-PROCEDURE, p-method-name) NO-ERROR.
    IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute Method-Library 
PROCEDURE get-attribute :
/* -----------------------------------------------------------
      Purpose:     Returns the value of a std variable or attribute-table entry.
      Parameters:  INPUT attribute name, RETURN-VALUE (string)
      Notes:       
    -------------------------------------------------------------*/   

  DEFINE INPUT PARAMETER p-attr-name    AS CHARACTER NO-UNDO.

  RUN broker-get-attribute IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, INPUT p-attr-name) NO-ERROR.

  RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute-list Method-Library 
PROCEDURE get-attribute-list :
/* -----------------------------------------------------------
      Purpose:     Returns a list of all settable object attributes.
      Parameters:  OUTPUT comma-separated attribute list
      Notes:       This procedure does not return a list of *all*
                   attributes, but only those which are defined and
                   set by users (e.g., not HIDDEN, ENABLED... ).
                   In Version 8.1., an INPUT parameter has been added
                   to broker-get-attribute-list to allow a caller to
                   specify a particular list of attributes to return.
                   This standard call does not specify a list, so
                   the attributes in the ADM-ATTRIBUTE-LIST attribute
                   are returned.
    -------------------------------------------------------------*/   

  DEFINE OUTPUT PARAMETER p-attr-list AS CHARACTER NO-UNDO.

  RUN broker-get-attribute-list IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, 
       INPUT ?,           /* Use the defined list of attributes to return */
       OUTPUT p-attr-list) NO-ERROR.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-new-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE new-state Method-Library 
PROCEDURE new-state :
/* -----------------------------------------------------------
   Purpose:     Stub to send state message off to the broker process.
   Parameters:  state name (CHARACTER) - may also contain one or more
                link names to pass state message through, as part of a
                comma-separated list.
   Notes:       
-------------------------------------------------------------*/   

  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  RUN broker-new-state IN adm-broker-hdl (THIS-PROCEDURE, p-state) NO-ERROR.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notify Method-Library 
PROCEDURE notify :
/* -----------------------------------------------------------
   Purpose:     Stub to pass notify command to broker process
   Parameters:  method name (CHARACTER) - may also include one or more
                link types to pass message through as part of commas-separated
                list.
   Notes:       
-------------------------------------------------------------*/   
  DEFINE INPUT PARAMETER p-method AS CHARACTER NO-UNDO.

  RUN broker-notify IN adm-broker-hdl (THIS-PROCEDURE, p-method) NO-ERROR.
  IF RETURN-VALUE = "ADM-ERROR":U THEN 
      RETURN "ADM-ERROR":U.  

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTooltipHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTooltipHelp Method-Library 
PROCEDURE piTooltipHelp :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters: p-wh-frame - handle do frame
  Notes:       
------------------------------------------------------------------------------*/

  define input param p-wh-frame as widget-handle no-undo.

  define var wh-child     as widget-handle no-undo. 
  define var c-aux        as char          no-undo.
  define var i-aux        as integer       no-undo.  
  define var c-contexto   as char          no-undo init "".

  &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
  /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
    &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN /* FO 1540.701 - corp340521 - 22/07/2008  */
  run pi_reset_values in h-facelift.
  &ENDIF
  &ENDIF

  &IF DEFINED(adm-browser) <> 0 OR 
      "{&PROCEDURE-TYPE}" = "w-form2":U &THEN
  &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
  /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
      &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN
  run pi_aplica_facelift ( input p-wh-frame ).
      &ENDIF
  &ELSE
  assign p-wh-frame:BGCOLOR = ?
         p-wh-frame:FONT    = 2.
  &ENDIF
  assign p-wh-frame = p-wh-frame:FIRST-CHILD
         wh-child   = p-wh-frame:FIRST-CHILD.
  &ELSE
  &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
  /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
  &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN
  run pi_aplica_facelift ( input p-wh-frame ).
  &ENDIF
  &ELSE
  assign p-wh-frame:BGCOLOR = ?
         p-wh-frame:FONT    = 1.
  &ENDIF
  assign p-wh-frame = p-wh-frame:FIRST-CHILD
         wh-child   = p-wh-frame:FIRST-CHILD.
  &ENDIF
  

  do  while valid-handle(wh-child):

      &IF DEFINED(adm-browser) <> 0 OR 
          "{&PROCEDURE-TYPE}" = "w-form2":U &THEN
        if wh-child:TYPE <> "BROWSE" then do:
           if can-query(wh-child, "FONT") then
              if wh-child:FONT = ? then assign wh-child:FONT = 1 no-error.
        end.
      &ENDIF
  &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
        &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN

      /**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
      run pi_aplica_facelift ( input wh-child ).
  &ENDIF
  &ENDIF

      case wh-child:type:
          when "BUTTON" then do:
              if  wh-child:help <> "" 
              and wh-child:help <> ? then do:
                  assign wh-child:tooltip = wh-child:help.						 
              end.         

          end.
      end case.
      assign wh-child = wh-child:next-sibling.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
&IF DEFINED(EXCLUDE-pi_aplica_facelift) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_aplica_facelift Method-Library 
PROCEDURE pi_aplica_facelift :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER wg AS WIDGET-HANDLE.
/**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    &IF "{&ESPEC_CANCEL_FACELIFT}" <> "YES" &THEN /* FO 1540.701 - corp340521 - 22/07/2008 */
    run pi_aplica_facelift_smart in h-facelift ( input wg ).
    &ENDIF
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&ENDIF

&IF DEFINED(EXCLUDE-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-attribute-list Method-Library 
PROCEDURE set-attribute-list :
/* -----------------------------------------------------------
      Purpose:     Accepts the value of the complete object attribute list
                   and runs procedures to set individual attributes.
      Parameters:  INPUT comma-separated attribute list.
      Notes:       Not all attributes are settable. Those which are a
                   part of an event such as enable/disable (which set
                   ENABLED on/off) or hide/view (which set HIDDEN on/off)
                   can be queried through get-attribute but cannot be set.
    -------------------------------------------------------------*/   

  DEFINE INPUT PARAMETER p-attr-list    AS CHARACTER NO-UNDO.

  RUN broker-set-attribute-list IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, INPUT p-attr-list) NO-ERROR.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-position) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-position Method-Library 
PROCEDURE set-position :
/* -----------------------------------------------------------
  Purpose:     Moves an object to a specified position.
  Parameters:  ROW and COLUMN 
  Notes:       
-------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-row    AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-col    AS DECIMAL NO-UNDO.

    IF VALID-HANDLE(adm-object-hdl) THEN
    DO:     
      /* If this is a Window or a Dialog box which is being positioned,
         then the special value 0 means to center the object in that
         dimension (0,0 means center on the screen - 0 can be used to
         signal this because 0 is an invalid row or column position). */
      &IF "{&ADM-CONTAINER}":U NE "":U &THEN
        DEFINE VARIABLE parent-hdl AS HANDLE NO-UNDO.
        IF adm-object-hdl:TYPE = "WINDOW":U THEN
        DO:
          IF p-row = 0 THEN p-row = 
            (SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2.
          IF p-col = 0 THEN p-col = 
            (SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2.
        END.
        /* A Dialog naturally centers on its parent and positions relative
           to its parent, so we must adjust for that. */
        ELSE IF adm-object-hdl:TYPE = "DIALOG-BOX":U THEN
        DO:
          parent-hdl = adm-object-hdl:PARENT.
          IF p-row = 0 THEN p-row = 
            ((SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2) -
              parent-hdl:ROW.
          IF p-col = 0 THEN p-col = 
            ((SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2) -
              parent-hdl:COL.
        END.
        /* If the row or column wound up being between 0 and 1 after the 
           calculation, change it, because otherwise Progress will complain. */
        IF p-row GE 0 AND p-row < 1 THEN p-row = 1.
        IF p-col GE 0 AND p-col < 1 THEN p-col = 1.
      &ENDIF
      /* Set object's position */
      ASSIGN adm-object-hdl:ROW    =   p-row 
             adm-object-hdl:COLUMN =   p-col.
    END.  
    RETURN.

END PROCEDURE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

