&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*-------------------------------------------------------------------------
    Library     : record.i  
    Purpose     : Base ADM methods for record handling objects

    Syntax      : {src/adm/method/record.i}

    Description :

    Author(s)   :
    Created     :
    HISTORY: 
--------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(adm-record) = 0 &THEN
&GLOBAL adm-record yes

/* Variable Definitions --                                              */
DEFINE VARIABLE tt-uib-reposition-find  AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE tt-uib-reposition-query AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE tt-uib-browser-view     AS LOGICAL NO-UNDO INITIAL ?.


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
         HEIGHT             = 1.25
         WIDTH              = 35.86.
                                                                        */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-display-fields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-display-fields Method-Library 
PROCEDURE adm-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Displays the fields in the current record and any other 
               objects in the DISPLAYED-OBJECTS list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* EPC - Before Display da Viewer */
  &IF  DEFINED(adm-viewer) <> 0 &THEN
       {include/i-epc023.i}
  &ENDIF  

  /****************** Customiza‡Æo PGS - Substitui‡Æo de :
  &IF DEFINED(adm-browser) NE 0 AND 
    "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U NE "":U &THEN
   Para:
     &IF DEFINED(adm-browser) NE 0 AND 
     DEFINED(FIELDS-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN 
    Em fun‡Æo de problemas de compila‡Æo com campos calculados
    dentro do BROWSE.
    Ricardo de Lima PerdigÆo - 01/07/1997 
  ************************************************************/ 

    &IF DEFINED(adm-browser) NE 0 AND 
    DEFINED(FIELDS-IN-QUERY-{&BROWSE-NAME}) NE 0 &THEN 

      IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
         DISPLAY {&FIELDS-IN-QUERY-{&BROWSE-NAME}} WITH BROWSE {&BROWSE-NAME}
            NO-ERROR.
    &IF "{&DISPLAYED-OBJECTS}":U NE "":U &THEN
      DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-OBJECTS} 
          WITH FRAME {&FRAME-NAME} NO-ERROR.
    &ENDIF
  &ELSEIF DEFINED(adm-viewer) NE 0 AND
     "{&FIRST-EXTERNAL-TABLE}":U NE "":U &THEN
      IF AVAILABLE {&FIRST-EXTERNAL-TABLE} THEN
          DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-FIELDS} {&DISPLAYED-OBJECTS}
            WITH FRAME {&FRAME-NAME} NO-ERROR. 
      ELSE
          CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.        
  &ENDIF

    /* Clear MODIFIED field attr. */
    RUN check-modified IN THIS-PROCEDURE ('clear':U) NO-ERROR.  

  /* EPC - Display da Viewer */
  &IF  DEFINED(adm-viewer) <> 0 &THEN
       {include/i-epc006.i}
  &ENDIF  

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-open-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query Method-Library 
PROCEDURE adm-open-query :
/* -----------------------------------------------------------
  Purpose:     Opens the default or browse query.
  Parameters:  <none>
  Notes:       If there's a dependency on an external table, and 
               no record from that table is available, the query
               is closed.
-------------------------------------------------------------*/

    DEFINE VARIABLE current-rowid AS ROWID NO-UNDO.

&IF "{&ems_dbtype}":U = "ORACLE":U &THEN
    DEFINE VARIABLE prov_rowid AS ROWID. /*utilizada na autaliza‡Æo das vari veis adm-first-rowid e adm-last-rowid*/
&endif

/* EPC - Before Open Query do Browser */
&IF  DEFINED(adm-browser) <> 0 &THEN
     {include/i-epc035.i}
&ENDIF 

&IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    IF AVAILABLE({&FIRST-EXTERNAL-TABLE}) THEN 
    DO:
  &ENDIF
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            ASSIGN adm-query-opened = YES 
                   adm-last-rowid = ?.      /* we don't know the last record yet */
        &ELSE
            &IF DEFINED(OPEN-QUERY-CASES) NE 0 &THEN
                {&OPEN-QUERY-CASES}
            &ELSE
                {&OPEN-QUERY-{&QUERY-NAME}}
            &ENDIF
            ASSIGN adm-query-opened = YES 
                   adm-last-rowid = ?.      /* we don't know the last record yet */        
        &ENDIF      
/***********************************************/

        /* Find out if this is the end of an Add or other operation that
           reopens the query and immediately does a reposition-query. If so,
           skip the get-first. */
        RUN get-attribute ('REPOSITION-PENDING':U).
        IF RETURN-VALUE NE "YES":U and
           not tt-uib-reposition-query THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('get-first':U).
        END.
        assign tt-uib-reposition-query = no.

        IF NOT AVAILABLE ({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN
            RUN new-state ('no-record-available,SELF':U).
        ELSE 
            /* In case there previously was no record in the dataset: */
            RUN new-state ('record-available,SELF':U). 

  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    END.
    ELSE 
    DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
            RELEASE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.
        &ELSE
            CLOSE QUERY {&QUERY-NAME}.
        &ENDIF
/***********************************************/

        /* Tell others that there's an external dependency not available. */
        RUN new-state ('no-external-record-available,SELF':U).
        RUN dispatch ('row-changed':U).  /* Signal that no row is available. */
    END.
  &ENDIF
&ELSEIF DEFINED(adm-browser) NE 0 AND
    DEFINED(TABLES-IN-QUERY-{&BROWSE-NAME}) <> 0 &THEN
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    IF AVAILABLE({&FIRST-EXTERNAL-TABLE}) THEN DO:
  &ENDIF
        &IF DEFINED(OPEN-QUERY-CASES) NE 0 &THEN
            {&OPEN-QUERY-CASES}
        &ELSE
            {&OPEN-QUERY-{&BROWSE-NAME}}
        &ENDIF
        adm-query-opened = yes.
        IF NUM-RESULTS("{&BROWSE-NAME}":U) = 0 THEN /* query's empty */
            RUN new-state ('no-record-available,SELF':U).
        ELSE 
            RUN new-state ('record-available,SELF':U). 
  &IF "{&EXTERNAL-TABLES}":U NE "":U &THEN
    END. 
    ELSE
    DO:
        CLOSE QUERY {&BROWSE-NAME}.
        /* Tell others that there's an external dependency not available. */
        RUN new-state ('no-external-record-available,SELF':U).
    END.
  &ENDIF
    IF NOT adm-updating-record THEN /* Suppress if in the middle of update*/
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).

    DEFINE VARIABLE tt-uib-container-source-char AS CHARACTER NO-UNDO.
    DEFINE VARIABLE tt-uib-container-source-hdl  AS WIDGET-HANDLE NO-UNDO.

    IF THIS-PROCEDURE:GET-SIGNATURE("ApplyFillIn") <> "":U AND
       tt-uib-browser-view = ? THEN DO:
       RUN get-link-handle IN ADM-BROKER-HDL (THIS-PROCEDURE, "CONTAINER-SOURCE":U, OUTPUT tt-uib-container-source-char).
       ASSIGN tt-uib-container-source-hdl = WIDGET-HANDLE(tt-uib-container-source-char). 

       IF VALID-HANDLE(tt-uib-container-source-hdl) THEN DO:
          RUN set-attribute-list IN tt-uib-container-source-hdl ("ApplyFillIn=YES|":U + STRING(THIS-PROCEDURE)).

          IF tt-uib-browser-view = ? THEN
             RUN ApplyFillIn.

          ASSIGN tt-uib-browser-view = NO.
       END.
    END.

&ENDIF

/* EPC - Open Query do Browser */
&IF  DEFINED(adm-browser) <> 0 &THEN
     {include/i-epc036.i}
&ENDIF


/* L¢gica para controle das vari veis adm-first-rowid e adm-last-rowid
   respons veis pela navega‡Æo em DATABASE DIFERENTE DE PROGRESS    */
&IF "{&ems_dbtype}":U = "ORACLE":U &THEN
     /* Anderson Z. Dalmarco - 
       O pre-processador a seguir ² utilizado pela equipe do Produto HR - 
       se pre-processador estiver definido, o c½digo para controle das variÿveis
       de navega»’o n’o deve ser executado */
     &IF DEFINED(CODE-SECURITY-OPEN-QUERY-HR) = 0 &THEN
         &IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN
              ASSIGN prov_rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
              if prov_rowid <> adm-first-rowid then do:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
                    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
/* tech1139 - 27/07/2005 - FO 1186.555 */
                        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
                            &IF "{&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
                                WHERE {&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR.
                            &ELSE
                                NO-ERROR.
                            &ENDIF
/* tech1139 - 27/07/2005 - FO 1186.555 */                                  
                    &ELSE
                        GET FIRST {&QUERY-NAME}.
                    &ENDIF
/***********************************************/                    

                    ASSIGN ADM-FIRST-ROWID = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
              end.

              /*Paulo H. Lazzarotti - Retirado Get Last para nÆo comprometer a performance */

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
              &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
                  ASSIGN tt-uib-reposition-find = TRUE.

                  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
                      ASSIGN current-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
/* tech1139 - 27/07/2005 - FO 1186.555 */
                  FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
                      WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = prov_rowid
                      &IF "{&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
                        AND {&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR.
                      &ELSE
                        NO-ERROR.
                      &ENDIF
/* tech1139 - 27/07/2005 - FO 1186.555 */                     
                  IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
                      IF current-rowid <> ? THEN
                          FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
                              WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = current-rowid NO-ERROR.
              &ELSE
                  REPOSITION {&QUERY-NAME} TO ROWID prov_rowid NO-ERROR.
              &ENDIF
/***********************************************/

              RUN dispatch IN THIS-PROCEDURE (INPUT 'get-next').
          &endif.
      &ENDIF
&ENDIF.
/* Fim da Atualiza‡Æo das vari veis de controle.*/

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-row-changed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-changed Method-Library 
PROCEDURE adm-row-changed :
/* -----------------------------------------------------------
      Purpose:    Executed when a new record or set of records
                  is retrieved locally (as opposed to passed on from
                  another procedure). Handles default display or browse open
                  code and then signals to RECORD-TARGETs that 
                  a fresh record or set of joined records is available.. 
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/   
      /* If there's a Frame or other valid container associated
         with this object, display the record's fields. */ 
      IF VALID-HANDLE(adm-object-hdl) THEN 
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

      RUN notify ('row-available':U).

      RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reposition-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reposition-query Method-Library 
PROCEDURE reposition-query :
/* -----------------------------------------------------------
  Purpose:     Gets the current rowid from the calling procedure,
               and repositions the current query to that record.
  Parameters:  Caller's procedure handle
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-requestor-hdl     AS HANDLE NO-UNDO.

&IF DEFINED(FIRST-TABLE-IN-QUERY-{&QUERY-NAME}) NE 0 &THEN

    DEFINE VAR repos-rowid                    AS ROWID NO-UNDO.
    DEFINE VAR current-rowid                  AS ROWID no-undo.

    RUN get-rowid IN p-requestor-hdl (OUTPUT repos-rowid).
    IF repos-rowid <> ? THEN
    DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN

            ASSIGN tt-uib-reposition-find = TRUE.

            IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
                ASSIGN current-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).

/* tech1139 - 27/07/2005 - FO 1186.555 */
            FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
                WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = repos-rowid
                &IF "{&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
                    AND {&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR.
                &ELSE
                    NO-ERROR.
                &ENDIF
/* tech1139 - 27/07/2005 - FO 1186.555 */
            IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
                IF current-rowid <> ? THEN
                    FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK 
                        WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = current-rowid NO-ERROR.
        &ELSE
            REPOSITION {&QUERY-NAME} TO ROWID repos-rowid NO-ERROR.
        &ENDIF
/***********************************************/

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o panel p-navega.w 
              devido a deficiencia dos Templates PROGRESS com DATABASE DIFERENTE
              DE PROGRESS
              **********************************/
        &IF "{&ems_dbtype}":U = "ORACLE":U &THEN
            /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
            &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN
                        ASSIGN tt-uib-reposition-query = yes.
                        RUN new-state (INPUT "Reposition-Oracle,NAVIGATION-SOURCE":U).
            &ELSE
                        ASSIGN tt-uib-reposition-query = NO.                        
                        RUN new-state (INPUT "Reposition-Oracle-Correct,NAVIGATION-SOURCE":U).
            &ENDIF
            /*Fim alteracao 03/10/2006*/
        &ENDIF
/***********************************************/

        RUN dispatch IN THIS-PROCEDURE ('get-next':U).
    END.

&ELSEIF DEFINED (adm-browser) NE 0 AND
    DEFINED(TABLES-IN-QUERY-{&BROWSE-NAME}) <> 0 &THEN

    DEFINE VARIABLE table-name                 AS ROWID NO-UNDO.

    RUN get-rowid IN p-requestor-hdl (OUTPUT table-name).
    /* Note: row-changed was removed from this (after reposition)
       because the update-complete state will take care of that. */
    IF table-name <> ? THEN
        REPOSITION {&BROWSE-NAME} TO ROWID table-name NO-ERROR.
&ENDIF

    /* In case this attribute was set earlier, turn it off. */
    RUN set-attribute-list ('REPOSITION-PENDING = NO':U).

    RETURN.    

END PROCEDURE.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

