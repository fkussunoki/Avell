&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*-------------------------------------------------------------------------
    File        : tableio.i  
    Purpose     : Basic ADM methods for record changes

    Syntax      : {src/adm/method/tableio.i}

    Description :

    Author(s)   :
    Created     :
    Notes       : New 8Plus Version with Multiple Enabled Table support
    HISTORY: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(adm-tableio) = 0 &THEN
&GLOBAL adm-tableio yes

/* Note: adm-<nth>-enabled-table is defined for each updatable table - 
               that is, a table with enabled fields.
         adm-tableio-first-table is the first (or only) table in the join;
               this is used for repositioning the query after an add, e.g.
         adm-tableio-fields is the list of enabled fields or 
               browse columns in all enabled tables.
         adm-tableio-table is no longer used but has been kept for
               backward compatibility with any user code which may reference it.
         In addition, we map adm-first-enabled-table to ENABLED-TABLES 
               if it's not otherwise defined, again for backward compatibility 
               with 8.0A-generated programs.  */
/* For Viewers: */
&IF DEFINED(adm-browser) = 0 &THEN
  &GLOBAL adm-tableio-table        {&ENABLED-TABLES} 

  /* Allow users to define this preproc themselves for special cases: */
  &IF DEFINED(adm-first-enabled-table) = 0 &THEN
    &IF DEFINED(FIRST-ENABLED-TABLE) = 0 &THEN
      &GLOBAL adm-first-enabled-table  {&ENABLED-TABLES}
    &ELSE
      &GLOBAL adm-first-enabled-table  {&FIRST-ENABLED-TABLE}
    &ENDIF
  &ENDIF

  &GLOBAL adm-second-enabled-table {&SECOND-ENABLED-TABLE}
  &GLOBAL adm-third-enabled-table  {&THIRD-ENABLED-TABLE}
  &IF "{&FIRST-EXTERNAL-TABLE}":U NE "":U &THEN
    &GLOBAL adm-tableio-first-table {&FIRST-EXTERNAL-TABLE}
  &ELSE
    &GLOBAL adm-tableio-first-table {&FIRST-ENABLED-TABLE}
  &ENDIF
  &GLOBAL adm-tableio-fields  {&ENABLED-FIELDS}
&ELSE
/* For Browsers: */
  &GLOBAL adm-tableio-table        {&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}} 

  /* Allow users to define this preproc themselves for special cases: */
  &IF DEFINED(adm-first-enabled-table) = 0 &THEN
    &IF DEFINED(FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}) = 0 &THEN
      &GLOBAL adm-first-enabled-table {&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}
    &ELSE
      &GLOBAL adm-first-enabled-table {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}
    &ENDIF
  &ENDIF

  &GLOBAL adm-second-enabled-table {&SECOND-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}
  &GLOBAL adm-third-enabled-table {&THIRD-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}
  &GLOBAL adm-tableio-first-table {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}
  &GLOBAL adm-tableio-fields {&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}
&ENDIF

  DEFINE VARIABLE adm-first-table         AS ROWID NO-UNDO.  
  DEFINE VARIABLE adm-second-table        AS ROWID NO-UNDO. 
  DEFINE VARIABLE adm-third-table         AS ROWID NO-UNDO.
  DEFINE VARIABLE adm-adding-record       AS LOGICAL NO-UNDO INIT no.
  DEFINE VARIABLE adm-return-status       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE adm-first-prev-rowid    AS ROWID     NO-UNDO.
  DEFINE VARIABLE adm-second-prev-rowid   AS ROWID     NO-UNDO.
  DEFINE VARIABLE adm-third-prev-rowid    AS ROWID     NO-UNDO.
  DEFINE VARIABLE adm-first-add-rowid     AS ROWID     NO-UNDO.
  DEFINE VARIABLE adm-second-add-rowid    AS ROWID     NO-UNDO.
  DEFINE VARIABLE adm-third-add-rowid     AS ROWID     NO-UNDO.

  /**
   FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
  **/
  /** WBD: BEGIN_NULL_CODE **/
  DEFINE VARIABLE adm-first-tmpl-recid    AS RECID     NO-UNDO INIT ?.
  DEFINE VARIABLE adm-second-tmpl-recid   AS RECID     NO-UNDO INIT ?.
  DEFINE VARIABLE adm-third-tmpl-recid    AS RECID     NO-UNDO INIT ?.
  /**
   FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
  **/
  /** WBD: END_NULL_CODE **/
  
  DEFINE VARIABLE adm-index-pos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE adm-query-empty         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE adm-create-complete     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE adm-create-on-add       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE group-assign-add        AS LOGICAL   NO-UNDO INIT ?.

/************ Customizacao Progress - Ricardo de Lima Perdigao - 13/03/1998
              Definicao de variaveis utilizadas no ADM-CURRENT-CHANGED.
              **********************************/
  DEFINE VARIABLE h_record-source         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE h_record-target         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE h_tableio-source        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE h_query-browse          AS HANDLE    NO-UNDO.
/***********************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInitial Method-Library 
FUNCTION setInitial RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 6.88
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* If there are no ENABLED-TABLES, then remove the TABLEIO-TARGET link
   from the list of SUPPORTED-LINKS. */
  IF "{&adm-first-enabled-table}":U = "":U THEN
    RUN modify-list-attribute IN adm-broker-hdl
      (THIS-PROCEDURE, "REMOVE":U, "SUPPORTED-LINKS":U, "TABLEIO-TARGET":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-add-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-add-record Method-Library 
PROCEDURE adm-add-record :
/* -----------------------------------------------------------  
      Purpose:     Initiates a record add. Displays initial values
                   but does not create the record. That is done by
                   adm-assign-record.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/  
      /* EPC - Before Add da Viewer */ 
      &IF  DEFINED(adm-viewer) <> 0 &THEN   
           {include/i-epc028.i}
      &ENDIF

   &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
  
   DEFINE VARIABLE trans-hdl-string  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cntr              AS INTEGER   NO-UNDO.
   DEFINE VARIABLE temp-rowid        AS ROWID     NO-UNDO.
   DEFINE VARIABLE saved-dictdb      AS CHARACTER NO-UNDO.

      /* Check MODIFIED field attribute for the prior record. */
      RUN check-modified IN THIS-PROCEDURE ('check':U) NO-ERROR.  

             /* Save the current rowid in case the add is cancelled. */
      ASSIGN adm-first-table = ROWID({&adm-tableio-first-table})
             adm-new-record = yes     /* Signal new rec being created. */
             adm-adding-record = yes  /* Signal that it's add not copy. */
             adm-query-empty = IF AVAILABLE({&adm-tableio-first-table})
                               THEN no ELSE yes. /* needed in Cancel */
      RUN set-attribute-list ("ADM-NEW-RECORD=yes":U).


      /* If for some reason this object's fields have not been enabled from
         outside, then do it here. */
      /* Alterado : J.Carlos - 02/04/96                                */
      /*            Alterei a ordem dos comandos Enables :             */
      /*            1o. executa o enable p/ os campos de chaves depois */
      /*            executa o enable p/ os outros campos.              */   
      /*            Isto evita que o cursor caia no campo errado.      */
      /* RUN dispatch('enable-fields':U). */ 
      &IF DEFINED(ADM-CREATE-FIELDS) NE 0 &THEN
          ENABLE {&UNLESS-HIDDEN} {&ADM-CREATE-FIELDS} WITH FRAME {&FRAME-NAME}.
      &ENDIF

      RUN dispatch('enable-fields':U).

      /* The first time a record is added, we determine whether this object
         is a Group-Assign-Target for another object with the same table. */
      IF group-assign-add = ? THEN
      DO: 
          RUN request-attribute IN adm-broker-hdl
            (THIS-PROCEDURE, 'GROUP-ASSIGN-SOURCE':U, 'ENABLED-TABLES':U).

          /* This will be true only if the object has a Group-Assign-Source
             *and* its first enabled table is the same as one in the G-A-S.
             If this is the case, we re-find the record the G-A-S has just
             created and add our fields to it. Otherwise we create the
             new record in this object. */
          IF LOOKUP("{&adm-first-enabled-table}":U, RETURN-VALUE) NE 0 THEN
            group-assign-add = yes.
          ELSE group-assign-add = no.
      END.

      /* The first time a record is added, we must get the RECID(s) of
         the template record(s) which hold initial values for Progress. 
         IF the Create-On-Add attribute is set to "yes", then we don't
         do this, because the CREATE will take care of initial values. 
         We do this only for Progress databases, however, since other
         DBs or Temp-Tables don't support the template record. */
      IF (adm-create-on-add = no) AND (adm-first-tmpl-recid = ?) AND
         (DBTYPE(LDBNAME(BUFFER {&adm-first-enabled-table})) EQ "PROGRESS":U)
      THEN DO:
          saved-dictdb = LDBNAME("DICTDB":U).  /* save off current DICTDB */
          /* Change the DICTDB alias to the database of each table and
             run a separate procedure to retrieve the template RECID. */
          CREATE ALIAS DICTDB FOR DATABASE 
            VALUE(LDBNAME(BUFFER {&adm-first-enabled-table})).
          RUN adm/objects/get-init.p (INPUT "{&adm-first-enabled-table}":U,
            OUTPUT adm-first-tmpl-recid).
          &IF "{&adm-second-enabled-table}":U NE "":U &THEN
            CREATE ALIAS DICTDB FOR DATABASE 
              VALUE(LDBNAME(BUFFER {&adm-second-enabled-table})).
            RUN adm/objects/get-init.p (INPUT "{&adm-second-enabled-table}":U,
              OUTPUT adm-second-tmpl-recid).
          &ENDIF
          &IF "{&adm-third-enabled-table}":U NE "":U &THEN
            CREATE ALIAS DICTDB FOR DATABASE 
              VALUE(LDBNAME(BUFFER {&adm-third-enabled-table})).
            RUN adm/objects/get-init.p (INPUT "{&adm-third-enabled-table}":U,
              OUTPUT adm-third-tmpl-recid).
          &ENDIF
          CREATE ALIAS DICTDB FOR DATABASE    /* Restore the orig. dictdb */
            VALUE(saved-dictdb).
        END.

      &IF DEFINED(adm-browser) = 0 &THEN

          IF adm-create-on-add = no THEN 
          DO:
           IF DBTYPE(LDBNAME(BUFFER {&adm-first-enabled-table})) 
             EQ "PROGRESS":U THEN
           DO:
            /* Retrieve and display the template record initial values if
               the record hasn't already been created and we're running
               against a Progress DB. */

            /**
              FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
              **/
            /** WBD: BEGIN_NULL_CODE **/
            FIND {&adm-first-enabled-table} WHERE 
              RECID({&adm-first-enabled-table}) = adm-first-tmpl-recid.
            &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              FIND {&adm-second-enabled-table} WHERE 
                RECID({&adm-second-enabled-table}) = adm-second-tmpl-recid.
            &ENDIF
            &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              FIND {&adm-third-enabled-table} WHERE 
                RECID({&adm-third-enabled-table}) = adm-third-tmpl-recid.
            &ENDIF
            /**
              FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
              **/
            /** WBD: END_NULL_CODE **/

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 29/03/2000
              Incluir a opá∆o NO-PAUSE no comando CLEAR a fim de evitar a mensagem
              "Press space bar to continue."
              **********************************/             
             CLEAR FRAME {&FRAME-NAME} NO-PAUSE.

             DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-FIELDS}
              WITH FRAME {&FRAME-NAME} NO-ERROR.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 11/10/1999
              Impedir que o registro acessado atravÇs do RECID _Template esteja 
              dispon°vel para alteraá∆o
              **********************************/
             RELEASE {&ADM-FIRST-ENABLED-TABLE}.

             &IF "{&ADM-SECOND-ENABLED-TABLE}":U <> "":U &THEN
                RELEASE {&ADM-SECOND-ENABLED-TABLE}.
             &ENDIF

             &IF "{&ADM-THIRD-ENABLED-TABLE}":U <> "":U &THEN
                RELEASE {&ADM-THIRD-ENABLED-TABLE}.
             &ENDIF
/***********************************************/
           END.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/04/1999
              Setar valores iniciais, na inclus∆o (ADD) quando o tipo de Database 
              for diferente de PROGRESS (por exemplo: Oracle, Sysbase, ...)
              **********************************/
            /*&IF PROVERSION BEGINS "9." &THEN*/
            &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN /* ALTERAÄ«O FEITA PARA ATENDER A VERSAO 10 - MARCILENE - 26-11-2003 */
            ELSE setInitial().
            &ENDIF
/***********************************************/

          END.              /* END code for Progress DB initial values. */
          /* If the developer explicitly requested Create-On-Add or it's
             not a Progress DB then do the CREATE. */
          ELSE DO:
           DO TRANSACTION ON STOP  UNDO, RETURN "ADM-ERROR":U 
                          ON ERROR UNDO, RETURN "ADM-ERROR":U:
             adm-create-complete = no.  /* Signal whether Create succeeded. */
             RUN dispatch ('create-record':U).
             IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U.

             DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-FIELDS}
                WITH FRAME {&FRAME-NAME} NO-ERROR.

           END.
           adm-create-complete = yes.  /* Signal Cancel that Create was done. */
          END. 
      &ELSE                              /* Code for SmartBrowsers */
          DO WITH FRAME {&FRAME-NAME}:
             IF NUM-RESULTS("{&BROWSE-NAME}":U) = ? OR  /* query not opened */
              NUM-RESULTS("{&BROWSE-NAME}":U) = 0 /* query's empty */
               OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1 THEN 
                adm-return-status = {&BROWSE-NAME}:INSERT-ROW("AFTER":U).
              ELSE DO:
                MESSAGE 
              "You must select a row after which the new row is to be inserted."
                    VIEW-AS ALERT-BOX.
                RETURN.
              END.
          /* The browser's ROW-ENTRY trigger will display initial values. 
             Set the flag which indicates that this hasn't happened yet: */
              adm-brs-initted = no.
          END.
      &ENDIF

      /* EPC - Add da Viewer */ 
      &IF  DEFINED(adm-viewer) <> 0 &THEN   
           {include/i-epc011.i}
      &ENDIF

      RUN notify ('add-record, GROUP-ASSIGN-TARGET':U).

      RUN new-state('update':U). /* Signal that we're in a record update now. */

      RUN dispatch IN THIS-PROCEDURE ('apply-entry':U). 

   &ELSE MESSAGE "Object ":U THIS-PROCEDURE:FILE-NAME 
       "must have at least one Enabled Table to perform Add.":U
       VIEW-AS ALERT-BOX ERROR.
   &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-assign-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-assign-record Method-Library 
PROCEDURE adm-assign-record :
/* -----------------------------------------------------------  
      Purpose:     Assigns changes to a single record as part of an
                   update, add, or copy. If this is an add or copy, 
                   the new record is created here.
      Parameters:  <none>
      Notes:       This method is intended to be invoked from 
                   adm-update-record, which starts a transaction.       
                   This allows multiple ASSIGNs in several objects 
                   (connected with the GROUP-ASSIGN link)
                   to be part of a single update transaction.
    -------------------------------------------------------------*/  

/* EPC - Validate da Viewer */ 
&IF  DEFINED(adm-viewer) <> 0 &THEN   
     {include/i-epc002.i}
&ENDIF

&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
        adm-updating-record = yes.    /* Signal row-available etc. */
        IF adm-new-record THEN DO:

          /* Unless we already did the CREATE in add-record, create the new
             record(s) for an Add here. */

          IF (NOT adm-adding-record) OR  /* Indicates Copy, not Add */
              (NOT adm-create-on-add) THEN
          DO:
             RUN dispatch ('create-record':U).
             IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U.
          END.

          IF (adm-create-on-add = yes) OR (group-assign-add = yes) THEN
          DO:     /* Need to re-get the record to upgrade the lock */
           &IF DEFINED (adm-browser) NE 0 &THEN
            /* Under some circumstances the browse may lose track of the newly
               created record, so we may need to refetch it here. */
            IF adm-first-add-rowid NE ROWID({&adm-first-enabled-table}) THEN
              FIND {&adm-first-enabled-table} WHERE 
                  ROWID ({&adm-first-enabled-table}) = adm-first-add-rowid.
            &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              IF adm-second-add-rowid NE ROWID({&adm-second-enabled-table}) THEN
                FIND {&adm-second-enabled-table} WHERE 
                  ROWID ({&adm-second-enabled-table}) = adm-second-add-rowid.
            &ENDIF
            &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              IF adm-third-add-rowid NE ROWID({&adm-third-enabled-table}) THEN
                FIND {&adm-third-enabled-table} WHERE 
                  ROWID ({&adm-third-enabled-table}) = adm-third-add-rowid.
            &ENDIF
           &ENDIF

            RUN dispatch ('current-changed':U). /* Get an EXCLUSIVE lock */
            IF RETURN-VALUE = "ADM-ERROR":U THEN 
               RETURN "ADM-ERROR":U.
          END.
        END.       /* END of processing for Add/Copy */

        ELSE DO:   /* for ordinary ASSIGNs: */
            RUN dispatch ('current-changed':U). /* Get an EXCLUSIVE lock */
            IF RETURN-VALUE = "ADM-ERROR":U THEN 
               RETURN "ADM-ERROR":U.
        END.

        RUN dispatch ('assign-statement':U). /* ASSIGN the fields */
        IF RETURN-VALUE = "ADM-ERROR":U THEN 
            UNDO, RETURN "ADM-ERROR":U.

        /* If this object is linked to others to be updated together,
           then do that here: */
        RUN notify ('assign-record,GROUP-ASSIGN-TARGET':U).
        IF RETURN-VALUE = "ADM-ERROR":U THEN UNDO, RETURN "ADM-ERROR":U.

        /* Display any fields assigned by CREATE. */
        IF adm-new-record THEN 
        DO:
            RUN get-attribute('Query-Position':U).  /* Is this the first rec?*/
            IF RETURN-VALUE = 'no-record-available':U THEN   /* yes it is...*/
            DO:
              RUN new-state('record-available':U).  /* Let Panels know. */
              RUN set-attribute-list('Query-Position = record-available':U).
            END.
            RUN dispatch('display-fields':U).
        END.

   &ELSE MESSAGE 
       "Object ":U THIS-PROCEDURE:FILE-NAME
         "must have at least one Enabled Table to perform Assign.":U
           VIEW-AS ALERT-BOX ERROR.
   &ENDIF
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-assign-statement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-assign-statement Method-Library 
PROCEDURE adm-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     ASSIGNs field values from within assign-record
  Parameters:  <none>
  Notes:       This can be replaced with a local version if the 
               ASSIGN statement needs to be customized in some way
               which is not supportable through ADM-CREATE-FIELDS
               and ADM-ASSIGN-FIELDS, for example, to assure that
               key fields which are assigned programatically don't
               force an additional database write. Also, custom
               validation can be done in local-assign-statement before
               or after the ASSIGN.
------------------------------------------------------------------------------*/

  /* Alterado por ANDERSON(TECH540) em 30/01/2003
   Campos CHAR n∆o podem guardar valores maiores que os definidos
   em seu formato. Mudado de ems_dbtype = "SQL" para "MSS" 
   A VALIDAÄ«O ê FEITA ATRAVêS DESTA INCLUDE */
   
   {utp/ut-verdatamss.i} 
   

   /*Fim alteraá∆o Anderson 33/01/2003*/

    /* EPC - After Validate da Viewer */ 
    &IF  DEFINED(adm-viewer) <> 0 &THEN   
         {include/i-epc019.i}
    &ENDIF

    /* EPC - Before Assign do Viewer */ 
    &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc020.i}
    &ENDIF

&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 
      AND "{&adm-tableio-fields}":U NE "":U &THEN 
  &IF DEFINED(adm-browser) = 0 &THEN   /* ASSIGN for Frame Fields: */
    /* ADM-ASSIGN-FIELDS gives the developer the opportunity to define
       additional fields in the default frame which are to be assigned
       at the same time as the ENABLED-FIELDS list. */
    /* If this is a new record creation, also allow additional fields
       defined in ADM-CREATE-FIELDS to be entered. */
    &IF DEFINED(ADM-CREATE-FIELDS) NE 0 &THEN
    IF adm-new-record THEN 
    DO:
        ASSIGN FRAME {&FRAME-NAME} {&ADM-CREATE-FIELDS}
            {&adm-tableio-fields} {&ADM-ASSIGN-FIELDS} NO-ERROR.

       /*** Customizacao PGS - Ricardo de Lima Perdigao - 14/03/1997
            Resolver o problema de desabilitar os campos da 
            lista ADM-CREATE-FIELDS antes do final da inclusao  

            A desabilitaá∆o dos campos de chaves foram passados para
            a rotina ADM-DISABLE-FIELDS. ( JosÇ Carlos - PGS - 20/03/97 ) ***/    

        /* --------------------   
        IF NOT ERROR-STATUS:ERROR THEN   /* Leave enabled if error */
            DISABLE {&UNLESS-HIDDEN} {&ADM-CREATE-FIELDS} 
              WITH FRAME {&FRAME-NAME}.
        ---------------------- */      
    END.
    ELSE
    &ENDIF
        ASSIGN FRAME {&FRAME-NAME} {&adm-tableio-fields} 
             {&ADM-ASSIGN-FIELDS} NO-ERROR.

    IF ERROR-STATUS:ERROR THEN    /* DO error checking for non-browsers */
    DO: 
      RUN dispatch('show-errors':U).
      UNDO, RETURN "ADM-ERROR":U.
    END.
  &ELSE                               /* ASSIGN for Browse Fields: */
    ASSIGN BROWSE {&BROWSE-NAME} {&adm-tableio-fields} NO-ERROR.

    IF ERROR-STATUS:ERROR THEN  /* Browser gets its own error checking,   */
    DO:                         /*  only if the ASSIGN was actually done. */
      RUN dispatch('show-errors':U).
      UNDO, RETURN "ADM-ERROR":U.
    END.
  &ENDIF
&ENDIF

   /* EPC - Assign do Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc003.i}
   &ENDIF

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-cancel-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-cancel-record Method-Library 
PROCEDURE adm-cancel-record :
/* -----------------------------------------------------------  
      Purpose:     Cancels a record update, add or copy operation
      Parameters:  <none>
      Notes:       This simply gets the query to reposition to what
                   was the current record before the add or copy began;
                   for an update of an object such as a Viewer it gets 
                   reset-record to redisplay the fields;
                   if a transaction was open for an object with its own query, 
                   such as a Browser, it reopens the query to redisplay 
                   original values for all records which may have been changed.
    -------------------------------------------------------------*/  

  /* EPC - Cancel da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc013.i}
  &ENDIF

&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

  DEFINE VARIABLE source-str          AS CHARACTER NO-UNDO.

   /* Clear MODIFIED field attribute. */


   RUN check-modified IN THIS-PROCEDURE ('clear':U) NO-ERROR. 

   IF adm-new-record THEN           /* Reposition to prev record for add/copy */
   DO:
      /* If initial values were displayed through the use of the template
         record, then get rid of the template record.*/
      IF (adm-adding-record = yes) AND  /*  Add, not Copy */
         (adm-create-on-add = no)
      THEN DO:
        RELEASE {&adm-first-enabled-table} NO-ERROR.  
        &IF "{&adm-second-enabled-table}":U NE "":U &THEN
          RELEASE {&adm-second-enabled-table} NO-ERROR.  
        &ENDIF
        &IF "{&adm-third-enabled-table}":U NE "":U &THEN
          RELEASE {&adm-third-enabled-table} NO-ERROR.  
        &ENDIF
      END.
      /* If the actual record Create was done in add-record, then we must
         delete the record(s) to cancel. */
      ELSE IF (adm-adding-record = yes) AND  /* Add, not Copy */
        (adm-create-on-add = yes) AND
          (adm-create-complete = yes) /* Make sure rec actually created */
      THEN DO:
        &IF DEFINED (adm-browser) NE 0 &THEN
          /* Under some circumstances the browse may lose track of the newly
             created record, so we may need to refetch it here. */
          IF adm-first-add-rowid NE ROWID({&adm-first-enabled-table}) THEN
            FIND {&adm-first-enabled-table} WHERE 
                ROWID ({&adm-first-enabled-table}) = adm-first-add-rowid.
          &IF "{&adm-second-enabled-table}":U NE "":U &THEN
            IF adm-second-add-rowid NE ROWID({&adm-second-enabled-table}) THEN
              FIND {&adm-second-enabled-table} WHERE 
                ROWID ({&adm-second-enabled-table}) = adm-second-add-rowid.
          &ENDIF
          &IF "{&adm-third-enabled-table}":U NE "":U &THEN
            IF adm-third-add-rowid NE ROWID({&adm-third-enabled-table}) THEN
              FIND {&adm-third-enabled-table} WHERE 
                ROWID ({&adm-third-enabled-table}) = adm-third-add-rowid.
          &ENDIF
        &ENDIF

          RUN dispatch ('delete-record':U).
      END.

      &IF DEFINED(adm-browser) NE 0 &THEN   /* Delete the new browser row */
        IF (adm-adding-record = no) OR (adm-create-on-add = no) THEN
          IF BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1 THEN 
            adm-return-status = {&BROWSE-NAME}:DELETE-CURRENT-ROW() 
             IN FRAME {&FRAME-NAME}.
      &ENDIF

      &IF DEFINED(ADM-CREATE-FIELDS) NE 0 &THEN
          DISABLE {&UNLESS-HIDDEN} {&ADM-CREATE-FIELDS} 
            WITH FRAME {&FRAME-NAME}.
      &ENDIF
      &IF DEFINED (adm-browser) = 0 &THEN
          /* For Viewers, if this was a Cancel of an Add of the only
             record in the query, then disable the fields. */
          IF adm-query-empty THEN              /* Set for us in Add */
             RUN dispatch ('disable-fields':U).
      &ENDIF
      adm-new-record = no.
      RUN set-attribute-list ("ADM-NEW-RECORD=no":U).

      RUN notify ('cancel-record, GROUP-ASSIGN-TARGET':U).
   END.
   ELSE DO: 
       RUN dispatch ('reset-record':U). /*For Update, redisplay old values. */
       /*Inserido a chamada do notify para tirar o estado de update das viewers secund†rias
       inserido por tech540 (Anderson)*/
       RUN notify ('cancel-record, GROUP-ASSIGN-TARGET':U). /*Tirar o estado de update das viewers secund†rias*/
       /*fim alteraá∆o Anderson*/
   END.

   /* Alteraá∆o : J.Carlos - PGS - 03/Abr/97                                  
    *    A variavel "adm-updating-record" Ç usada na ADM-ROW-AVAILABLE p/ testar        
    *    se um registro deve ser lido ou n∆o.                       
    *    Se ela estiver com o valor "YES" indica que o Progress esta fazendo  
    *    uma atualizaá∆o (UPDATE) e assim o registro corrente n∆o precisa ser 
    *    lido pois o que esta no buffer j† Ç o registro corrente.             
    *    Ocorre que quando se esta fazendo uma inclus∆o (ADD) esta variavel   
    *    tambÇm Ç "setada" como "YES", isto Ç feito dentro do ADM-ASSIGN-RECORD. 
    *    Quando a inclus∆o termina normalmente tudo funciona bem MAS se a
    *    inclus∆o Ç abortada (UNDO, RETURN "ADM-ERROR") AP‡S ter sido executado o 
    *    ADM-ASSIGN-RECORD E em seguida Ç executado um ADM-CANCEL-RECORD (CANCEL),
    *    a variavel fica com este valor, e quando o Progress vai executar o 
    *    ADM-ROW-AVAILABLE , ele n∆o là o registro da base de dados. Assim
    *    uma SUJEIRA (um registro n∆o-gravado) fica na tela.
    *    Este ASSIGN abaixo Ç para resolver isto. O c¢digo original da Progress
    *    tinha este comando MAS estava colocado no lugar errado.
    *    Ele deve ficar antes do "RUN new-state('update-complete':U)".
    * ************************************************************ */
   adm-updating-record = no. 

   RUN get-link-handle IN adm-broker-hdl 
       (THIS-PROCEDURE, 'GROUP-ASSIGN-SOURCE':U, OUTPUT source-str).
   IF source-str EQ "":U THEN            /* If not just a group-assign-target,*/
     RUN new-state('update-complete':U). /* tell all to reset/refresh */
   &IF DEFINED(adm-browser) NE 0 &THEN
     adm-brs-in-update = no.       /* This tells whether Update button set. */
   &ENDIF
   /*adm-updating-record = no.*/

&ENDIF

  /* EPC - After Cancel da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc030.i}
  &ENDIF

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-copy-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-copy-record Method-Library 
PROCEDURE adm-copy-record :
/* -----------------------------------------------------------  
      Purpose:     Allows the creation of a new record whose initial
                   values are the same as the current record buffer.


      Parameters:  <none>
      Notes:       This is like add-record except we start with the
                   current record buffer rather than the template record.
    -------------------------------------------------------------*/  

   &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
  
   DEFINE VARIABLE trans-hdl-string AS CHARACTER NO-UNDO.

      /* Check MODIFIED field attribute for the prior record. */
      RUN check-modified IN THIS-PROCEDURE ('check':U) NO-ERROR.  

             /* Save the current rowid in case the copy is cancelled. */
      ASSIGN adm-first-table = ROWID({&adm-tableio-first-table})
             adm-new-record = yes     /* Signal a new rec is being created. */
             adm-adding-record = no.  /* Signal this is copy not add. */
      RUN set-attribute-list ("ADM-NEW-RECORD=yes":U).

      /* If for some reason this object's fields have not been enabled from
         outside, then do it here. */
      RUN dispatch('enable-fields':U). 
      &IF DEFINED(ADM-CREATE-FIELDS) NE 0 &THEN
          ENABLE {&UNLESS-HIDDEN} {&ADM-CREATE-FIELDS} WITH FRAME {&FRAME-NAME}.
      &ENDIF

      /* The first time a record is added or copied, we determine whether 
         this object is a Group-Assign-Target for another object with the same 
         table. */
      IF group-assign-add = ? THEN
      DO: 
          RUN request-attribute IN adm-broker-hdl
            (THIS-PROCEDURE, 'GROUP-ASSIGN-SOURCE':U, 'ENABLED-TABLES':U).

          /* This will be true only if the object has a Group-Assign-Source
             *and* its first enabled table is the same as one in the G-A-S.
             If this is the case, we re-find the record the G-A-S has just
             created and add our fields to it. Otherwise we create the
             new record in this object. */
          IF LOOKUP("{&adm-first-enabled-table}":U, RETURN-VALUE) NE 0 THEN
            group-assign-add = yes.
          ELSE group-assign-add = no.
      END.

      &IF DEFINED(adm-browser) = 0 &THEN
          RUN dispatch IN THIS-PROCEDURE ('apply-entry':U). 
      &ELSE
          DO WITH FRAME {&FRAME-NAME}:
            IF NUM-RESULTS("{&BROWSE-NAME}":U) = ? OR  /* query's not opened */
               NUM-RESULTS("{&BROWSE-NAME}":U) = 0 THEN /* query's empty */
            DO:
                MESSAGE "Cannot perform Copy. There are no browse rows."
                    VIEW-AS ALERT-BOX WARNING.
                RUN dispatch ('cancel-record':U).
            END.
            ELSE DO:
             adm-first-prev-rowid = ROWID({&adm-first-enabled-table}). 
             &IF "{&adm-second-enabled-table}":U NE "":U &THEN
               adm-second-prev-rowid = ROWID({&adm-second-enabled-table}). 
             &ENDIF
             &IF "{&adm-third-enabled-table}":U NE "":U &THEN
               adm-third-prev-rowid = ROWID({&adm-third-enabled-table}). 
             &ENDIF
               IF NUM-RESULTS("{&BROWSE-NAME}":U) = ? OR  /* query not opened */
                NUM-RESULTS("{&BROWSE-NAME}":U) = 0 /* query's empty */
                 OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1 THEN 
                  adm-return-status = {&BROWSE-NAME}:INSERT-ROW("AFTER":U).
               ELSE DO:
                  MESSAGE 
              "You must select a row after which the new row is to be inserted."
                      VIEW-AS ALERT-BOX.
                  RETURN.
               END.
               /* The browser's ROW-ENTRY trigger will display initial values. 
                  Set the flag which indicates that this hasn't happened yet: */
               adm-brs-initted = no.
            END.
          END.
      &ENDIF

      RUN notify ('copy-record, GROUP-ASSIGN-TARGET':U).

      RUN new-state('update':U). /* Signal that we're in a record update now. */

   &ELSE MESSAGE "Object ":U THIS-PROCEDURE:FILE-NAME 
     "must have at least one Enabled Table to perform Copy.":U
       VIEW-AS ALERT-BOX ERROR.
   &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-create-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-record Method-Library 
PROCEDURE adm-create-record :
/* -----------------------------------------------------------  
      Purpose:    Performs the actual CREATE <table> statement(s)
                  to create a new row for a query. This is normally
                  dispatched from adm-assign-record, but may be done 
                  from adm-add-record if the 'Create-On'Add' attribute
                  is set.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/  
   &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

    DEFINE VARIABLE source-str          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE source-rowid-str    AS CHARACTER NO-UNDO.

       /* If this is a Group-Assign, then the first (or only) enabled
          table will be passed on from its parent. Any others will be 
          created here. */

       IF group-assign-add = yes THEN
       DO:
         RUN get-link-handle IN adm-broker-hdl 
           (THIS-PROCEDURE, 'GROUP-ASSIGN-SOURCE':U, 
              OUTPUT source-str).
         RUN send-records IN WIDGET-HANDLE (source-str)
             (INPUT "{&adm-first-enabled-table}":U, 
              OUTPUT source-rowid-str).
         /**
          FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
         **/
         /** WBD: BEGIN_NULL_CODE **/
         FIND {&adm-first-enabled-table} WHERE 
             ROWID ({&adm-first-enabled-table}) = 
                 TO-ROWID(source-rowid-str) NO-ERROR.
         /**
          FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
         **/
         /** WBD: END_NULL_CODE **/
         IF ERROR-STATUS:ERROR THEN
         DO: 
           RUN dispatch('show-errors':U).
           UNDO, RETURN "ADM-ERROR":U.
         END.
       END.
       ELSE DO:
           CREATE {&adm-first-enabled-table} NO-ERROR.
           IF ERROR-STATUS:ERROR THEN
           DO: 
             RUN dispatch('show-errors':U).
             UNDO, RETURN "ADM-ERROR":U.
           END.
       END.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 29/10/1999
              A gravaá∆o da vari†vel que contÇm o ROWID do registro recÇm criado
              foi transferida para ap¢s a gravaá∆o dos campos contidos no 
              preprocessador {&ADM-CREATE-FIELDS}, isto deve-se a fim de 
              corrigir uma deficiància dos Templates PROGRESS com DATABASE DIFERENTE
              DE PROGRESS
              **********************************/
        &IF "{&ems_dbtype}":U = "PROGRESS":U &THEN
            /* Save off the ROWID(s) of the new record(s) because under some
               circumstances, a browse may lose track of the record and it needs
               to be re-retrieved in assign-record. */
            
            adm-first-add-rowid = ROWID({&adm-first-enabled-table}).
       &ENDIF
/***********************************************/

       &IF "{&adm-second-enabled-table}":U NE "":U &THEN
         CREATE {&adm-second-enabled-table} NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO: 
           RUN dispatch('show-errors':U).
           UNDO, RETURN "ADM-ERROR":U.
         END.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 29/10/1999
              A gravaá∆o da vari†vel que contÇm o ROWID do registro recÇm criado
              foi transferida para ap¢s a gravaá∆o dos campos contidos no 
              preprocessador {&ADM-CREATE-FIELDS}, isto deve-se a fim de 
              corrigir uma deficiància dos Templates PROGRESS com DATABASE DIFERENTE
              DE PROGRESS
              **********************************/
        &IF "{&ems_dbtype}":U = "PROGRESS":U &THEN
           adm-second-add-rowid = ROWID({&adm-second-enabled-table}).
        &ENDIF
/***********************************************/

       &ENDIF

       &IF "{&adm-third-enabled-table}":U NE "":U &THEN
         CREATE {&adm-third-enabled-table} NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO: 
           RUN dispatch('show-errors':U).
           UNDO, RETURN "ADM-ERROR":U.
         END.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 29/10/1999
              A gravaá∆o da vari†vel que contÇm o ROWID do registro recÇm criado
              foi transferida para ap¢s a gravaá∆o dos campos contidos no 
              preprocessador {&ADM-CREATE-FIELDS}, isto deve-se a fim de 
              corrigir uma deficiància dos Templates PROGRESS com DATABASE DIFERENTE
              DE PROGRESS
              **********************************/
        &IF "{&ems_dbtype}":U = "PROGRESS":U &THEN
           adm-third-add-rowid = ROWID({&adm-third-enabled-table}).
        &ENDIF
/***********************************************/

       &ENDIF

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 29/10/1999
              Implementar a gravaá∆o dos campos contidos no preprocessador 
              {&ADM-CREATE-FIELDS} a fim de corrigir uma deficiància dos 
              Templates PROGRESS com DATABASE DIFERENTE DE PROGRESS
              **********************************/
        &IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN
            
            &IF "{&ADM-CREATE-FIELDS}":U <> "":U &THEN
                ASSIGN FRAME {&FRAME-NAME} {&ADM-CREATE-FIELDS}.
            &ENDIF

            IF THIS-PROCEDURE:GET-SIGNATURE("salvar_chave":U) <> "":U THEN
                RUN salvar_chave IN THIS-PROCEDURE NO-ERROR.

            /* Save off the ROWID(s) of the new record(s) because under some
            circumstances, a browse may lose track of the record and it needs
            to be re-retrieved in assign-record. */

            /************************************************************************ 
               CustomizaÁ„o TOTVS S.A.  - Eloi Rene Pscheidt - 02/07/2003
               Adicionado NO-ERROR na gravaÁ„o do ROWID para em Oracle verificar
               se o registro j· n„o foi criado anteriormente. Para isso faz-se o uso
               do NUM-MESSAGES para verificar a existÍncia do erro. */

            ASSIGN adm-first-add-rowid = ROWID({&adm-first-enabled-table}) NO-ERROR.
            /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
            IF ERROR-STATUS:NUM-MESSAGES > 0 THEN  DO:  /*se ocorreu algum erro*/
               DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO.
               DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*laáo para todos os erros*/
                   CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                       WHEN 132 OR /* registro j† existe */
                       WHEN 1502 THEN DO: /* registro deu erro no oracle, n∆o no progress*/
                           run utp/ut-msgs.p (input "show", input 1, 
                                              input "{&adm-first-enabled-table}").
                           RETURN "ADM-ERROR":U.
                       END.

                       WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                           run utp/ut-msgs.p (input "show", input 29761,
                                              INPUT "{&adm-first-enabled-table}").
                           RETURN "ADM-ERROR":U.
                       END.

                       OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                           run utp/ut-msgs.p (input "show", input 29762, 
                                              input "{&ems_dbtype}":U + "~~" +
                                                    string(Error-Status:Get-Number(iNumErro)) + "~~" +
                                                    string(ERROR-STATUS:GET-MESSAGE(iNumErro))).
                           RETURN "ADM-ERROR":U.
                       END.
                   END CASE.
               END.
            END.
            /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/

            &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                ASSIGN adm-second-add-rowid = ROWID({&adm-second-enabled-table}) NO-ERROR.
                /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
                IF ERROR-STATUS:NUM-MESSAGES > 0 THEN  DO:  /*se ocorreu algum erro*/
                   /* DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO. -- J† definido acima! */
                   DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*laáo para todos os erros*/
                       CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                           WHEN 132 OR /* registro j† existe */
                           WHEN 1502 THEN DO: /* registro deu erro no oracle, n∆o no progress*/
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-second-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.

                           WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-second-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.

                           OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-second-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.
                       END CASE.
                   END.
                END.
                /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
           &ENDIF

            &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                ASSIGN adm-third-add-rowid = ROWID({&adm-third-enabled-table}) NO-ERROR.
                /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
                IF ERROR-STATUS:NUM-MESSAGES > 0 THEN  DO:  /*se ocorreu algum erro*/
                   /* DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO. -- J† definido acima */
                   DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*laáo para todos os erros*/
                       CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                           WHEN 132 OR /* registro j† existe */
                           WHEN 1502 THEN DO: /* registro deu erro no oracle, n∆o no progress*/
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-third-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.

                           WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-third-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.

                           OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                               run utp/ut-msgs.p (input "show", input 1, 
                                                  input "{&adm-third-enabled-table}").
                               RETURN "ADM-ERROR":U.
                           END.
                       END CASE.
                   END.
                END.
                /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
            &ENDIF
            /*************** Fim AlteraÁ„o Eloi 02/07/2003 ***************************/ 
        &ENDIF
/***********************************************/
   &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-current-changed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-current-changed Method-Library 
PROCEDURE adm-current-changed :
/*------------------------------------------------------------------------------
  Purpose:     Upgrades the lock on the current record to EXCLUSIVE.
               Checks whether it has been changed and redisplays
               the values in the changed record if it has been changed.
  Parameters:  <none>
  Notes:       Can be customized to change the lock upgrade code or
               to replace or supplement the CURRENT-CHANGED function,
               for example, to save off this user's changes and
               reconcile them with the other copy of the record.
------------------------------------------------------------------------------*/
&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

   /* Save the ROWID of the current record in case the lock upgrade fails. */
   ASSIGN adm-first-table = ROWID({&adm-first-enabled-table}).
   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
     ASSIGN adm-second-table = ROWID({&adm-second-enabled-table}).
   &ENDIF
   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
     ASSIGN adm-third-table = ROWID({&adm-third-enabled-table}).
   &ENDIF

   /* Note that we do the FIND EXCLUSIVE-LOCK and CURRENT-CHANGED without
           checking the initial lock state first. This is because it is not
           possible to be certain what the actual lock state is at this time,
           and the check is not expensive if in fact the record was already
           locked. */
  FIND CURRENT {&adm-first-enabled-table} EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE {&adm-first-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Execucao de CANCEL-RECORD/GET-NEXT quando o registro nao estiver disponivel.
              Alterar mensagem padr∆o da PROGRESS, quando o registro nao estiver disponivel.
              Execucao de RELEASE/PROCEDURE quando o registro nao estiver disponivel.
              **********************************/
      &IF "{&adm-first-enabled-table}":U NE "":U &THEN
         if  locked {&adm-first-enabled-table} then do:
             run utp/ut-msgs.p (input "show", input 16096 , input "").

             find {&adm-first-enabled-table} no-lock where
                  rowid({&adm-first-enabled-table}) = adm-first-table no-error.

             return "ADM-ERROR".
         end.
      &ENDIF
      run utp/ut-msgs.p (input "show", input 15217, input "").
      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN pi-cancelar IN h_tableio-source.

              RELEASE {&adm-first-enabled-table} NO-ERROR.  
              &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-second-enabled-table} NO-ERROR.
              &ENDIF
              &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-third-enabled-table} NO-ERROR.
              &ENDIF

              RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'RECORD-SOURCE':U,  OUTPUT h_record-source).
              RUN dispatch IN h_record-source ('GET-NEXT':U).
         end.
         else do:
              RUN notify IN h_tableio-source ('CANCEL-RECORD':U).

              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.
              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U) NO-ERROR.

                   RELEASE {&adm-first-enabled-table} NO-ERROR.
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   RELEASE {&adm-first-enabled-table} NO-ERROR.  
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF

                   RUN get-attribute IN h_query-browse ('TYPE':U).
                   if index(RETURN-VALUE, "query") <> 0
                   then RUN dispatch IN h_query-browse ('GET-NEXT':U).
                   else if index(RETURN-VALUE, "browse") <> 0
                        then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
              end.
         end.
      end.

/************************************************/
      RETURN 'ADM-ERROR':U.
  END.
  ELSE IF CURRENT-CHANGED {&adm-first-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Alterar mensagem padr∆o da PROGRESS, quando o registro ja foi alterado por outro usuario.
              Execucao de DISPLAY-FIELDS/CANCEL-RECORD quando o registro ja foi alterado por outro usuario.
              Execucao de DESTROY/GET-CURRENT, quando o registro ja foi alterado por outro usuario.
              **********************************/
      run utp/ut-msgs.p (input "show", input 15216, input "").
      if  return-value <> 'yes' then do:    

      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN dispatch ('DISPLAY-FIELDS':U).

              RUN pi-cancelar IN h_tableio-source.

              UNDO, RETURN "ADM-ERROR":U.
         end.
         else do:
              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.

              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U).
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   if valid-handle(h_query-browse) then do:
                      RUN get-attribute IN h_query-browse ('TYPE':U).
                      if index(RETURN-VALUE, "query") <> 0 
                      then RUN pi-reposiciona-query IN h_query-browse (INPUT rowid({&adm-first-enabled-table})).
                      else if index(RETURN-VALUE, "browse") <> 0
                           then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
                   end.
              end.
              RETURN "ADM-ERROR":U.
         end.
      end.

/************************************************/
      UNDO, RETURN "ADM-ERROR":U.
      end.
  END.
&IF "{&adm-second-enabled-table}":U NE "":U &THEN
  FIND CURRENT {&adm-second-enabled-table} EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE {&adm-second-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Execucao de CANCEL-RECORD/GET-NEXT quando o registro nao estiver disponivel.
              Alterar mensagem padr∆o da PROGRESS, quando o registro nao estiver disponivel.
              Execucao de RELEASE/PROCEDURE quando o registro nao estiver disponivel.
              **********************************/

      if  locked {&adm-second-enabled-table} then do:
          run utp/ut-msgs.p (input "show", input 16096, input "").

          find {&adm-second-enabled-table} no-lock where
               rowid({&adm-second-enabled-table}) = adm-second-table no-error.

          return "ADM-ERROR".
      end.
      run utp/ut-msgs.p (input "show", input 15217, input "").

      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN pi-cancelar IN h_tableio-source.

              RELEASE {&adm-first-enabled-table} NO-ERROR.  
              &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-second-enabled-table} NO-ERROR.
              &ENDIF
              &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-third-enabled-table} NO-ERROR.
              &ENDIF

              RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'RECORD-SOURCE':U,  OUTPUT h_record-source).
              RUN dispatch IN h_record-source ('GET-NEXT':U).
         end.
         else do:
              RUN notify IN h_tableio-source ('CANCEL-RECORD':U).

              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.
              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U) NO-ERROR.

                   RELEASE {&adm-first-enabled-table} NO-ERROR.
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   RELEASE {&adm-first-enabled-table} NO-ERROR.  
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF

                   RUN get-attribute IN h_query-browse ('TYPE':U).
                   if index(RETURN-VALUE, "query") <> 0
                   then RUN dispatch IN h_query-browse ('GET-NEXT':U).
                   else if index(RETURN-VALUE, "browse") <> 0
                        then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
              end.
         end.
      end.

/************************************************/      
      RETURN 'ADM-ERROR':U.
  END.
  ELSE IF CURRENT-CHANGED {&adm-second-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Alterar mensagem padr∆o da PROGRESS, quando o registro ja foi alterado por outro usuario.
              Execucao de DISPLAY-FIELDS/CANCEL-RECORD quando o registro ja foi alterado por outro usuario.
              Execucao de DESTROY/GET-CURRENT, quando o registro ja foi alterado por outro usuario.
              **********************************/
      run utp/ut-msgs.p (input "show", input 15216, input "").
      if  return-value <> 'yes' then do:

      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN dispatch ('DISPLAY-FIELDS':U).

              RUN pi-cancelar IN h_tableio-source.

              UNDO, RETURN "ADM-ERROR":U.
         end.
         else do:
              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.
              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U).
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   if valid-handle(h_query-browse) then do:
                      RUN get-attribute IN h_query-browse ('TYPE':U).
                      if index(RETURN-VALUE, "query") <> 0 
                      then RUN pi-reposiciona-query IN h_query-browse (INPUT rowid({&adm-second-enabled-table})).
                      else if index(RETURN-VALUE, "browse") <> 0
                           then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
                   end.
              end.
         end.
         RETURN "ADM-ERROR":U.
      end.

/************************************************/
      UNDO, RETURN "ADM-ERROR":U.
      end.
  END.
&ENDIF
&IF "{&adm-third-enabled-table}":U NE "":U &THEN
  FIND CURRENT {&adm-third-enabled-table} EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE {&adm-third-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Execucao de CANCEL-RECORD/GET-NEXT quando o registro nao estiver disponivel.
              Alterar mensagem padr∆o da PROGRESS, quando o registro nao estiver disponivel.
              Execucao de RELEASE/PROCEDURE quando o registro nao estiver disponivel.
              **********************************/
      if  locked {&adm-third-enabled-table} then do:
          run utp/ut-msgs.p (input "show", input 16096, input "").

          find {&adm-third-enabled-table} no-lock where
               rowid({&adm-third-enabled-table}) = adm-third-table no-error.

          return "ADM-ERROR".
      end.  
      run utp/ut-msgs.p (input "show", input 15217, input "").

      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN pi-cancelar IN h_tableio-source.

              RELEASE {&adm-first-enabled-table} NO-ERROR.  
              &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-second-enabled-table} NO-ERROR.
              &ENDIF
              &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              RELEASE {&adm-third-enabled-table} NO-ERROR.
              &ENDIF

              RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'RECORD-SOURCE':U,  OUTPUT h_record-source).
              RUN dispatch IN h_record-source ('GET-NEXT':U).
         end.
         else do:
              RUN notify IN h_tableio-source ('CANCEL-RECORD':U).

              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.
              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U) NO-ERROR.

                   RELEASE {&adm-first-enabled-table} NO-ERROR.
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   RELEASE {&adm-first-enabled-table} NO-ERROR.  
                   &IF "{&adm-second-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-second-enabled-table} NO-ERROR.
                   &ENDIF
                   &IF "{&adm-third-enabled-table}":U NE "":U &THEN
                   RELEASE {&adm-third-enabled-table} NO-ERROR.
                   &ENDIF

                   RUN get-attribute IN h_query-browse ('TYPE':U).
                   if index(RETURN-VALUE, "query") <> 0
                   then RUN dispatch IN h_query-browse ('GET-NEXT':U).
                   else if index(RETURN-VALUE, "browse") <> 0
                        then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
              end.
         end.
      end.

/************************************************/      
      RETURN 'ADM-ERROR':U.
  END.
  ELSE IF CURRENT-CHANGED {&adm-third-enabled-table} THEN DO:
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 13/03/1998
              Alterar mensagem padr∆o da PROGRESS, quando o registro ja foi alterado por outro usuario.
              Execucao de DISPLAY-FIELDS/CANCEL-RECORD quando o registro ja foi alterado por outro usuario.
              Execucao de DESTROY/GET-CURRENT, quando o registro ja foi alterado por outro usuario.
              **********************************/
      run utp/ut-msgs.p (input "show", input 15216, input "").
      if  return-value <> 'yes' then do:

      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'TABLEIO-SOURCE':U, OUTPUT h_tableio-source).
      if valid-handle(h_tableio-source) then do:
         RUN get-attribute IN h_tableio-source ('TYPE':U).

         if index(RETURN-VALUE, "panel") <> 0
         then do:
              RUN dispatch ('DISPLAY-FIELDS':U).

              RUN pi-cancelar IN h_tableio-source.

              UNDO, RETURN "ADM-ERROR":U.
         end.
         else do:
              RUN pi-retorna-query-browse IN h_tableio-source NO-ERROR.
              if ERROR-STATUS:ERROR
              then do:
                   RUN dispatch IN h_tableio-source ('DESTROY':U).
              end.
              else do:
                   assign h_query-browse = widget-handle(RETURN-VALUE).

                   RUN dispatch IN h_tableio-source ('DESTROY':U).

                   if valid-handle(h_query-browse) then do:
                      RUN get-attribute IN h_query-browse ('TYPE':U).
                      if index(RETURN-VALUE, "query") <> 0 
                      then RUN pi-reposiciona-query IN h_query-browse (INPUT rowid({&adm-third-enabled-table})).
                      else if index(RETURN-VALUE, "browse") <> 0
                           then RUN dispatch IN h_query-browse ('OPEN-QUERY':U).
                   end.
              end.
         end.
         RETURN "ADM-ERROR":U.
      end.

/************************************************/
      UNDO, RETURN "ADM-ERROR":U.
      end.
  END.
&ENDIF
&ENDIF

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-delete-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-delete-record Method-Library 
PROCEDURE adm-delete-record :
/* -----------------------------------------------------------
      Purpose:     Deletes the current record.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/           

/************ Customizacao PGS - Ricardo de Lima Perdigao - 14/03/1997
              Resolve problema do botao de delete voltar a mensagem de registro not available
              **********************************/
&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN  
    IF NOT AVAILABLE ({&adm-first-enabled-table}) THEN RUN dispatch IN THIS-PROCEDURE ('row-available':U).      
&ENDIF
/***************************************************************/
&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

   DEFINE VARIABLE delete-failed AS LOGICAL NO-UNDO INIT no.
   &IF DEFINED(adm-browser) NE 0 &THEN
      IF BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS NE 1 THEN 
      DO:
          MESSAGE "No row has been selected for deletion." VIEW-AS ALERT-BOX.
          RETURN.
      END.
   &ENDIF

      DO TRANSACTION ON STOP UNDO, LEAVE 
                     ON ERROR UNDO, LEAVE:

        /* If this object has a group-assign-source for its first or only
           table, then don't try to re-delete the record here. */
        IF group-assign-add NE yes THEN
        DO:
          FIND CURRENT {&adm-first-enabled-table} EXCLUSIVE-LOCK NO-ERROR.
/************ Customizacao TOTVS S.A. - Paulo Henrique Lazzarotti - 12/12/1999
              Verificar se o registro corrente est† dispon°vel para exclus∆o.
              **********************************/
          IF ERROR-STATUS:ERROR THEN
          DO: 
              run utp/ut-msgs.p (input "show", input 15217, input ""). 
              RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT 'RECORD-SOURCE':U,  OUTPUT h_record-source).
              RUN dispatch in h_record-source ("GET-NEXT").
              RETURN "adm-error":U.
          END.

          /* EPC - Delete da Viewer */ 
          &IF  DEFINED(adm-viewer) <> 0 &THEN
               {include/i-epc015.i}
          &ENDIF

          DELETE {&adm-first-enabled-table} NO-ERROR.

          /* EPC - After Delete da Viewer */ 
          &IF  DEFINED(adm-viewer) <> 0 &THEN
               {include/i-epc032.i}
          &ENDIF
        END.

        &IF "{&adm-second-enabled-table}":U NE "":U &THEN
          FIND CURRENT {&adm-second-enabled-table} EXCLUSIVE-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO: 
            RUN dispatch('show-errors':U).
            UNDO, RETURN "ADM-ERROR":U.
          END.
          DELETE {&adm-second-enabled-table} NO-ERROR.
        &ENDIF
        &IF "{&adm-third-enabled-table}":U NE "":U &THEN
          FIND CURRENT {&adm-third-enabled-table} EXCLUSIVE-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO: 
            RUN dispatch('show-errors':U).
            UNDO, RETURN "ADM-ERROR":U.
          END.
          DELETE {&adm-third-enabled-table} NO-ERROR.
        &ENDIF

        IF ERROR-STATUS:ERROR THEN
        DO: 
          RUN dispatch('show-errors':U).
          delete-failed = yes.
        END.    
        &IF DEFINED(adm-browser) NE 0 &THEN
        ELSE
            adm-return-status = 
               {&BROWSE-NAME}:DELETE-CURRENT-ROW() IN FRAME {&FRAME-NAME}.
        &ENDIF
      END.

      &IF DEFINED(adm-open-query) = 0 &THEN  /* If I don't have my own query, */
         IF not delete-failed THEN           /*  if the delete succeeded, then*/
         RUN new-state ('delete-complete':U). /* get query object to sync up. */
      &ELSE

         /* If I *do* have my own query, check to see if the last record
            in the query was deleted.  */
         IF NOT AVAILABLE ({&adm-first-enabled-table}) THEN
         DO:
           RUN new-state ('no-record-available':U). 
           RUN set-attribute-list ('Query-Position = no-record-available':U).
           RUN notify ('row-available':U).  /* Tell dependent objects to clear*/
         END.
      &ENDIF

     /*********** Customizacao PGS - Ricardo de Lima Perdigao - 26/06/1997
              Resolve problema do modifica retornar registro nao disponivel 
              apos um delete falhar por problema de validacao. 
              Linha anterior :

              IF delete-failed THEN
              UNDO, RETURN "ADM-ERROR":U.
              **********************************/

      IF delete-failed THEN
         RETURN "ADM-ERROR":U.

   &ELSE MESSAGE 
       "Object ":U THIS-PROCEDURE:FILE-NAME 
         "must have at least one Enabled Table to perform Delete.":U
           VIEW-AS ALERT-BOX ERROR.
   &ENDIF              

    RUN dispatch IN THIS-PROCEDURE ('apply-entry':U). 

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-disable-fields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-disable-fields Method-Library 
PROCEDURE adm-disable-fields :
/* -----------------------------------------------------------
      Purpose:     Disables fields in the {&ENABLED-FIELDS} list.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/           

   /* EPC - Disable da Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc005.i}
   &ENDIF

   &IF "{&adm-tableio-fields}":U NE "":U &THEN
     &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
       &IF DEFINED(adm-browser) NE 0 &THEN  
           /* Get focus out of the browser and then make it read-only. */
           RUN notify ('apply-entry, TABLEIO-SOURCE':U).
           {&BROWSE-NAME}:READ-ONLY IN FRAME {&FRAME-NAME} = yes.
       &ELSE
           DISABLE {&UNLESS-HIDDEN} {&adm-tableio-fields} {&ADM-CREATE-FIELDS} 
             WITH FRAME {&FRAME-NAME}.
           /* Alteraá∆o : Foi acrescentado o pre-processor "adm-create-fields" no
                          comando DISABLE acima para que ele tambÇm desabilite os
                          campos de chave. ( J. Carlos - PGS - 20/03/97 ) */             
           RUN set-editors('DISABLE':U).    /* Adjust editor widgets */
       &ENDIF
       RUN set-attribute-list ("FIELDS-ENABLED=no":U).
     &ELSE MESSAGE 
       "Object ":U THIS-PROCEDURE:FILE-NAME 
         "must have at least one Enabled Table to perform Disable-Fields.":U
           VIEW-AS ALERT-BOX ERROR.
     &ENDIF
   &ENDIF
      /* If this object is linked to others to be updated together,
         then disable fields together: */
      RUN notify ('disable-fields, GROUP-ASSIGN-TARGET':U).

   /* EPC - After Disable da Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc022.i}
   &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-enable-fields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-enable-fields Method-Library 
PROCEDURE adm-enable-fields :
/* -----------------------------------------------------------
      Purpose:     Enable all db fields in the {&ENABLED-FIELDS} list
                   for the default frame. Refind the current record
                   SHARE-LOCKED, and redisplay it in case it has changed.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/           

   /* EPC - Enable da Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc004.i}
   &ENDIF

   &IF "{&adm-tableio-fields}":U NE "":U &THEN
     &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
        RUN get-attribute ("FIELDS-ENABLED":U).
        IF RETURN-VALUE NE "YES":U THEN   /* Skip everything if fields are */
        DO:                               /*  already enabled. */
            IF AVAILABLE({&adm-first-enabled-table}) AND
              adm-initial-lock = "SHARE-LOCK":U OR
                adm-initial-lock = "EXCLUSIVE-LOCK":U THEN  
            DO:                                    /* +++ New code for EXCL */ 
                IF adm-initial-lock = "SHARE-LOCK":U THEN
                /**
                 FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                **/
                /** WBD: BEGIN_NULL_CODE **/
                  FIND CURRENT {&adm-first-enabled-table} SHARE-LOCK NO-ERROR.
                /**
                 FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                **/
               /** WBD: END_NULL_CODE **/
                
                /* For an EXCLUSIVE-LOCK, get the lock momentarily just to
                   make sure no-one else can deadlock with you. Then downgrade
                   back to share-lock until the record is saved. */
                ELSE IF AVAILABLE ({&adm-first-enabled-table}) THEN
                DO TRANSACTION:
                  FIND CURRENT {&adm-first-enabled-table} 
                   EXCLUSIVE-LOCK NO-ERROR.
                END.
                IF ERROR-STATUS:ERROR THEN
                DO: 
                  RUN dispatch('show-errors':U).
                  UNDO, RETURN "ADM-ERROR":U.
                END.
                RUN dispatch ('display-fields':U).  /* reshow in case changed.*/
            END.
            &IF "{&adm-second-enabled-table}":U NE "":U &THEN
              IF AVAILABLE({&adm-second-enabled-table}) AND
                adm-initial-lock = "SHARE-LOCK":U OR
                  adm-initial-lock = "EXCLUSIVE-LOCK":U THEN 
              DO:
                  IF adm-initial-lock = "SHARE-LOCK":U THEN
                   /**
                    FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                   **/
                   /** WBD: BEGIN_NULL_CODE **/
                    FIND CURRENT {&adm-second-enabled-table} 
                      SHARE-LOCK NO-ERROR.
                    /**
                     FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                    **/
                    /** WBD: END_NULL_CODE **/
                  ELSE IF AVAILABLE ({&adm-second-enabled-table}) THEN
                  DO TRANSACTION:
                    FIND CURRENT {&adm-second-enabled-table} 
                      EXCLUSIVE-LOCK NO-ERROR.
                  END.

                  IF ERROR-STATUS:ERROR THEN
                  DO: 
                    RUN dispatch('show-errors':U).
                    UNDO, RETURN "ADM-ERROR":U.
                  END.
                  RUN dispatch ('display-fields':U). /* reshow in case changed*/
              END.
            &ENDIF
            &IF "{&adm-third-enabled-table}":U NE "":U &THEN
              IF AVAILABLE({&adm-third-enabled-table}) AND
                adm-initial-lock = "SHARE-LOCK":U OR 
                  adm-initial-lock = "EXCLUSIVE-LOCK":U THEN 
              DO:
                  IF adm-initial-lock = "SHARE-LOCK":U THEN
                     /**
                      FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                     **/
                     /** WBD: BEGIN_NULL_CODE **/
                    FIND CURRENT {&adm-third-enabled-table} 
                      SHARE-LOCK NO-ERROR.
                     /**
                      FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
                     **/
                     /** WBD: END_NULL_CODE **/
                  ELSE IF AVAILABLE ({&adm-third-enabled-table}) THEN
                  DO TRANSACTION:
                    FIND CURRENT {&adm-third-enabled-table} 
                      EXCLUSIVE-LOCK NO-ERROR.
                  END.
                  IF ERROR-STATUS:ERROR THEN
                  DO: 
                    RUN dispatch('show-errors':U).
                    UNDO, RETURN "ADM-ERROR":U.
                  END.
                  RUN dispatch ('display-fields':U). /* reshow in case changed*/
              END.
            &ENDIF

            &IF DEFINED(adm-browser) NE 0 &THEN  
              DO WITH FRAME {&FRAME-NAME}:
                DEFINE VARIABLE row-is-selected AS LOGICAL NO-UNDO.
                row-is-selected = 
                  BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1.
                /* Get focus out of the browser and then make it read-only. */
                RUN notify ('apply-entry, TABLEIO-SOURCE':U).
                {&BROWSE-NAME}:READ-ONLY = no.
                /* Turning read-only off deselects the current row,
                   so we must reselect it. */
                IF row-is-selected THEN
                    adm-return-status = {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
              END.
            &ELSE
                ENABLE {&UNLESS-HIDDEN} {&adm-tableio-fields} 
                  WITH FRAME {&FRAME-NAME}.
                RUN set-editors('ENABLE':U).    /* Adjust editor widgets */
            &ENDIF
            RUN set-attribute-list ("FIELDS-ENABLED=yes":U).
        END.
     &ELSE MESSAGE 
       "Object ":U THIS-PROCEDURE:FILE-NAME 
         "must have at least one Enabled Table to perform Enable-Fields.":U
           VIEW-AS ALERT-BOX ERROR.


     &ENDIF

     &ENDIF
    /* Customizacao PGS Sofware para executar notify enable-fields em todos os group
    assign targets. O endif foi movido para acima do run notify, desta forma o notify
    e executado para todas as situaá‰es e nao apenas para quando houver adm-tableio-fields
    . Customizacao feita em funcao de Viewers so com campos chavers e/ou variaveis 
    Ricardo de Lima Perdigao - 05/05/1997 */


        /* If this object is linked to others to be updated together,
           then enable fields together: */
        RUN notify ('enable-fields, GROUP-ASSIGN-TARGET':U).

        RUN dispatch ('apply-entry':U). /*  Assure focus is in this object. */

   /* EPC - After Enable da Viewer */ 
   &IF  DEFINED(adm-viewer) <> 0 &THEN   
        {include/i-epc021.i}
   &ENDIF   

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-end-update) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-end-update Method-Library 
PROCEDURE adm-end-update :
/*------------------------------------------------------------------------------
  Purpose:   Does final update processing, including reopening the query
             on an add so that the new record becomes part of the query,
             and notifying others that a record has changed and that the 
             update is complete.  
  Parameters:  <none>
  Notes:     This is dispatched from adm-update-record if there is no 
             larger transaction active. Otherwise (with the Transaction
             Update Panel, for example) it must be invoked after the
             transaction is complete, because otherwise the query re-open
             may fail on some DataServers. 
------------------------------------------------------------------------------*/

  /* EPC - End-update da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc010.i}
  &ENDIF


  &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

  DEFINE VARIABLE source-str          AS CHARACTER NO-UNDO.

   /* Give any final validation errors a chance to be seen and intercepted. */
   IF ERROR-STATUS:ERROR THEN
       RUN dispatch('show-errors':U).

   /* Clear MODIFIED field attr. */
   RUN check-modified IN THIS-PROCEDURE ('clear':U) NO-ERROR.  

   IF adm-new-record THEN DO:
          adm-new-record = no.
          RUN set-attribute-list ("ADM-NEW-RECORD=no":U).

          /* Save the new rowid so it will be repositioned to. */
          ASSIGN adm-first-table = ROWID({&adm-tableio-first-table}).

          /* Get the record source, if any, to redisplay the changed record.
             First tell it that a reposition-query is coming so that it
             will suppress the intervening get-first event. */

          &IF DEFINED(adm-open-query) = 0 &THEN

/* Alteraá∆o : J.Carlos - PGS - 21/03/97
S¢ executar o Open-Query e o Reposition se a viewer Ç a viewer
principal. Isto Ç, se ela tem links de Group-Assign-Target */   

DEFINE VAR c_Handle AS CHAR.   
RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "GROUP-ASSIGN-source":U, OUTPUT c_Handle).   
IF NUM-ENTRIES(c_Handle) = 0 THEN 
DO :    
              RUN set-link-attribute IN adm-broker-hdl
                  (THIS-PROCEDURE, 'RECORD-SOURCE':U, 
                   'REPOSITION-PENDING=yes':U).
              RUN notify('open-query':U).
              RUN request IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                  INPUT 'RECORD-SOURCE':U, INPUT 'reposition-query':U).
END.   /* Teste de Group-Assign-Target */             
          &ELSE                  /* record source is local - reopen if new */
              RUN set-attribute-list ('REPOSITION-PENDING=yes':U).
              RUN dispatch('open-query':U).
              RUN reposition-query (INPUT THIS-PROCEDURE).
          &ENDIF

   END.

    /* Release the lock in case others are waiting for this record. */
    FIND CURRENT {&adm-first-enabled-table} NO-LOCK NO-ERROR.
    &IF "{&adm-second-enabled-table}":U NE "":U &THEN
      FIND CURRENT {&adm-second-enabled-table} NO-LOCK NO-ERROR.
    &ENDIF
    &IF "{&adm-third-enabled-table}":U NE "":U &THEN
      FIND CURRENT {&adm-third-enabled-table} NO-LOCK NO-ERROR.
    &ENDIF

   /* Tell any other objects in the transaction to clear themselves too. */

    RUN notify('end-update, GROUP-ASSIGN-TARGET':U).

  /* Signal query and its dependents, etc. to refresh and reset themselves. 
     Only do this, however, if we're not just a Group-Assign-Target
     of some other object; in that case, let it send the message. */
    RUN get-link-handle IN adm-broker-hdl 
        (THIS-PROCEDURE, 'GROUP-ASSIGN-SOURCE':U, OUTPUT source-str).
    IF source-str EQ "":U THEN
          RUN new-state('update-complete':U). /*Tell all to reset/refresh */

    &IF DEFINED(adm-browser) NE 0 &THEN
      adm-brs-in-update = no.      /* This tells whether Update button set. */
    &ENDIF
    adm-updating-record = no.

    RUN dispatch IN THIS-PROCEDURE ('apply-entry':U). 

  &ENDIF

  /* EPC - After End-update da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc027.i}
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-reset-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-reset-record Method-Library 
PROCEDURE adm-reset-record :
/* -----------------------------------------------------------  
      Purpose:     Redisplays values from the record buffer for the
                   current record.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/  

  /* EPC - Undo da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc012.i}
  &ENDIF

  &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
     
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

     /* If this object is linked to others to be updated together,
        then reset all records: */
     RUN notify ('reset-record, GROUP-ASSIGN-TARGET':U).
     RUN dispatch IN THIS-PROCEDURE ('apply-entry':U). 

  &ENDIF

  /* EPC - After Undo da Viewer */ 
  &IF  DEFINED(adm-viewer) <> 0 &THEN   
       {include/i-epc029.i}
  &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-update-record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-update-record Method-Library 
PROCEDURE adm-update-record :
/* -----------------------------------------------------------  
      Purpose:     Defines a transaction within which assign-record
                   commits changes to the current record. 
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------*/
   &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

      DEFINE VARIABLE cRecrdSorc AS CHARACTER NO-UNDO.
      DEFINE VARIABLE lGeneratedError AS LOGICAL NO-UNDO.
      DEFINE BUFFER bNewRecord FOR {&adm-first-enabled-table}.

      DO TRANSACTION ON STOP  UNDO, RETURN "ADM-ERROR":U 
                     ON ERROR UNDO, RETURN "ADM-ERROR":U :
        RUN dispatch ('assign-record':U).

        /*alteracao Sandro - 19/01/2005 - Atividade 128058*/
        &IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN
           /*alteraá∆o valdir - 10/06/2004 - Atividade 114576*/
           VALIDATE {&adm-first-enabled-table} NO-ERROR.
           /*ASSIGN adm-first-add-rowid = ROWID({&adm-first-enabled-table}).*/
           IF ERROR-STATUS:ERROR OR
             (ERROR-STATUS:NUM-MESSAGES > 0) THEN  DO:  /*se ocorreu algum erro*/
              DEFINE VARIABLE iNumErro AS INTEGER    NO-UNDO.
              DO iNumErro = 1 TO ERROR-STATUS:NUM-MESSAGES: /*laáo para todos os erros*/
                  CASE ERROR-STATUS:GET-NUMBER(iNumErro):
                      WHEN 132 OR /* registro j† existe */
                      WHEN 1502 THEN DO: /* registro deu erro no oracle, n∆o no progress*/
                          run utp/ut-msgs.p (input "show", input 1, 
                                             input "empresa").
                          /*RETURN "ADM-ERROR":U.*/
                          APPLY "ERROR".
                      END.

                      WHEN 4212 THEN DO: /*estouro de tamanho de campo */
                          run utp/ut-msgs.p (input "show", input 29761,
                                             INPUT "empresa").
                          APPLY "ERROR":U.
                      END.

                      OTHERWISE DO: /*qualquer outro erro que venha a acontecer*/
                          run utp/ut-msgs.p (input "show", input 29762, 
                                             input "oracle":U + "~~" +
                                                   string(Error-Status:Get-Number(iNumErro)) + "~~" +
                                                   string(ERROR-STATUS:GET-MESSAGE(iNumErro))).
                          APPLY "ERROR":U.
                      END.
                  END CASE.
              END.
           END.
           /*fim alteracao valdir */
        &ENDIF.

        IF  RETURN-VALUE = "ADM-ERROR":U OR
            RETURN-VALUE = "ERROR":U OR
            RETURN-VALUE = "ERRO-EPC":U OR /*tech32649 - FO: 1468.556 - 20/05/2007 - Alterado para fazer o tratamento "ERRO-EPC" pois ap¢s a chamada da EPC uma trigger de dicion†rio retorna um "erro-epc". */ 
            RETURN-VALUE = "NOK":U THEN
            RETURN "ADM-ERROR":U.
        /*fim alteracao Sandro */
      END.

      /* Do final update processing, unless there is a larger transaction
         open elsewhere, in which case it must be done when the
         transaction is ended. */

      IF NOT TRANSACTION THEN
          RUN dispatch ('end-update':U).

    IF NOT ERROR-STATUS:ERROR THEN
       ASSIGN lGeneratedError = NO.

    FIND FIRST bNewRecord NO-LOCK NO-ERROR.

    IF NOT ERROR-STATUS:ERROR /* AND ROWID(bNewRecord) = ROWID ({&adm-first-enabled-table}) */
    THEN DO:

      RUN get-link-handle IN adm-broker-hdl
       (INPUT THIS-PROCEDURE,
        INPUT "RECORD-SOURCE",
        OUTPUT cRecrdSorc).
      RUN New-First-Record IN WIDGET-HANDLE(cRecrdSorc) (INPUT ROWID(bNewRecord)) NO-ERROR.
      IF  NOT lGeneratedError AND ERROR-STATUS:ERROR THEN
          ASSIGN ERROR-STATUS:ERROR = NO.
    END.


    &ELSE MESSAGE 
      "Object ":U THIS-PROCEDURE:FILE-NAME 
        "must have at least one Enabled Table to perform Update.":U
          VIEW-AS ALERT-BOX ERROR.
    &ENDIF              

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-check-modified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-modified Method-Library 
PROCEDURE check-modified :
/*------------------------------------------------------------------------------
  Purpose:     Either checks or clears the MODIFIED attribute of
               all the enabled widgets in this object. Done as part
               protecting users from losing updates in the record
               changes or the application exits.
  Parameters:  <none>
  Notes:       The code checks first to make sure the FRAME or BROWSE
               hasn't already been destroyed, and that the changed record
               is still available.
               If the CHECK-MODIFIED-ALL attribute is set to "YES"
               (maps to local variable adm-check-modified-all) then
               all fields will be checked; otherwise, by default,
               only enabled database record fields are checked.
------------------------------------------------------------------------------*/
  /**
   FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
  **/
  /** WBD: BEGIN_NULL_CODE **/

DEFINE INPUT PARAMETER check-state AS CHARACTER NO-UNDO.

DEFINE VARIABLE curr-widget       AS HANDLE      NO-UNDO.
DEFINE VARIABLE container-hdl-str AS CHARACTER   NO-UNDO.

&IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN

/* Alteraá∆o :  J. Carlos - PGS - 04/04/97
   Quando esta procedure receber o parametro CHECK-STATE igual a "CHECK" ela
   ser† cancelada.

   Isto Ç para evitar que a mensagem padr∆o do UIB, que esta mais abaixo nesta proce-
   dure, seja exibida. Isto esta acontecendo em alguns momentos, considerados indevi-
   dos pela Datasul, por exemplo : 
        . Se o usu†rio esta alterando um registro e resolve cancelar a operaá∆o, 
          este teste Ç feito e a mensagem aparece. Ou ainda na mesma situaá∆o e 
          o usu†rio fecha a windows via o bot∆o de fechar da window ou aperta ALT-F4.
          Nestas situaá‰es a Datasul considera que n∆o Ç preciso avisar que algo 
          foi alterado e perguntar se quer salvar. Eles querem que saia de uma vez.
*/

    IF check-state = "check" THEN RETURN.   

/* ***************************************************************************** */   


IF NOT VALID-HANDLE(adm-object-hdl) THEN RETURN. /* Has object been destroyed?*/

&IF DEFINED(adm-browser) = 0 &THEN
  IF VALID-HANDLE(FRAME {&FRAME-NAME}:HANDLE) AND 
      AVAILABLE({&adm-first-enabled-table}) THEN
  DO:
    ASSIGN curr-widget = FRAME {&FRAME-NAME}:FIRST-CHILD. /* Field group */
    ASSIGN curr-widget = curr-widget:FIRST-CHILD. /* First field */
    DO WHILE VALID-HANDLE (curr-widget):
        IF LOOKUP (curr-widget:TYPE, 
        "FILL-IN,COMBO-BOX,EDITOR,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX":U)
            NE 0 AND 
                 /* check ENABLED fields only unless attribute says otherwise */
                 (adm-check-modified-all = yes OR curr-widget:SENSITIVE) AND
                 /* check db fields only unless attribute says otherwise */
                 (adm-check-modified-all = yes OR curr-widget:TABLE NE ?) 
                 AND curr-widget:MODIFIED THEN 
&ELSE                    /* Code for Browsers */
  IF VALID-HANDLE(BROWSE {&BROWSE-NAME}:HANDLE) AND
      AVAILABLE({&adm-first-enabled-table}) THEN
  DO:
    ASSIGN curr-widget = BROWSE {&BROWSE-NAME}:FIRST-COLUMN.
    DO WHILE VALID-HANDLE (curr-widget):
        IF NOT curr-widget:READ-ONLY AND curr-widget:MODIFIED THEN
&ENDIF
        DO:
            IF check-state = "check":U THEN /*Check for changes before leaving*/
            DO:
                /* If the Container has been hidden (for destroy, e.g.), 
                   force it to view again. */
                RUN request-attribute IN adm-broker-hdl (THIS-PROCEDURE,
                    'CONTAINER-SOURCE':U, 'HIDDEN':U).
                IF RETURN-VALUE = "YES":U THEN
                    RUN notify ('view,CONTAINER-SOURCE':U).
                MESSAGE IF 

/*tech14207 - FO 1350742 - 27072006*/
/*&IF DEFINED(adm-browser) = 0 OR PROVERSION GE "8.2" OR INTEGER(ENTRY(1,PROVERSION,".")) > 9 &THEN */
/* ALTERAÄ«O FEITA PARA ATENDER A VERSAO 10 - MARCILENE - 26-11-2003 */ 
&IF DEFINED(adm-browser) = 0 OR decimal(SUBSTRING(PROVERSION, 1 , 3)) >= 8.3 &THEN
/*Fim da alteraá∆o - tech14207 - FO 1350742 - 27072006*/
                           curr-widget:TABLE NE ? 
&ELSE
                           false   /* TABLE not queryable for Browsers in 8.1 */
&ENDIF
                                 THEN 
                  SUBSTITUTE ("Current &1 record has been changed.",
                    curr-widget:TABLE) 
                  ELSE "Current values have been changed."
                  SKIP "  Do you wish to save those changes?" skip(3)
                       "Field : " + curr-widget:name 
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
                            TITLE "Error in program " + THIS-PROCEDURE:FILE-NAME + " : "
                      UPDATE ANS AS LOGICAL.
               IF ANS THEN 
               DO:
                   RUN dispatch('update-record':U).
                   IF RETURN-VALUE = "ADM-ERROR":U THEN
                   DO:
                       MESSAGE "Changes to the previous record were not saved."
                           VIEW-AS ALERT-BOX ERROR.
                       RUN dispatch ('cancel-record':U). /* Reset all states. */
                   END.
               END.
               ELSE RUN dispatch('cancel-record':U).
               RETURN.
            END.
            ELSE IF check-state = "clear":U THEN
                curr-widget:MODIFIED = no.
        END.
&IF DEFINED(adm-browser) = 0 &THEN
        ASSIGN curr-widget = curr-widget:NEXT-SIBLING.
&ELSE
        ASSIGN curr-widget = curr-widget:NEXT-COLUMN.
&ENDIF
    END.
  END.
&ENDIF
  /**
   FO 1585968 - TECH14187 - C¢digo para ser ignorado no WBD 
  **/
  /** WBD: END_NULL_CODE **/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-rowid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-rowid Method-Library 
PROCEDURE get-rowid :
/* -----------------------------------------------------------
      Purpose:      Furnishes the rowid of the current record
                    or "previously current" record (in the event
                    of a cancelled Add or Copy, for example) to a requesting
                    procedure (typically reposition-query).
                    Note that the rowid is saved only for certain update
                    operations, in order to allow repositioning after the
                    update is complete or has been cancelled. get-rowid 
                    should not be used as a general way to get the ROWID
                    of the current record. send-records should be used instead.
      Parameters:   OUTPUT record rowid.
      Notes:
    -------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-table           AS ROWID NO-UNDO.

    ASSIGN
    p-table   =   adm-first-table.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-editors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-editors Method-Library 
PROCEDURE set-editors :
/* -----------------------------------------------------------
      Purpose:      Set the attributes of editor widgets properly.
                    They must be SENSITIVE AND READ-ONLY if disabled,
                    ELSE SENSITIVE AND not READ-ONLY. Otherwise they will
                    be unscrollable and possibly the text will be invisible
                    when they are disabled. Also used (by Add) to
                    clear any non-enabled editors (since we can't yet display
                    initial values into non-fill-ins).
      Parameters:   INPUT field-setting ("INITIALIZE" OR 
                    "ENABLED" or "DISABLED" or "CLEAR").
      Notes:        The checks are made only for editor widgets which are
                    mapped to database fields. In addition, a list is built
                    during 'initialize' of any editors whose initial state
                    is READ-ONLY, so that these are not enabled later on.
    -------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-field-setting  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE curr-widget             AS HANDLE    NO-UNDO.
    DEFINE VARIABLE read-only-list          AS CHARACTER NO-UNDO INIT "":U.

    ASSIGN curr-widget = FRAME {&FRAME-NAME}:CURRENT-ITERATION. /* Field group*/
    ASSIGN curr-widget = curr-widget:FIRST-CHILD. /* First field */
    DO WHILE VALID-HANDLE (curr-widget):
        IF curr-widget:TYPE = "EDITOR":U AND curr-widget:TABLE NE ? AND
           curr-widget:HIDDEN = no THEN DO:
          CASE p-field-setting:
            WHEN "INITIALIZE":U THEN
            /* If any editor widgets have been marked as READ-ONLY then
               put them into an attribute list and leave them alone later. */
            DO:
              IF curr-widget:READ-ONLY = yes THEN read-only-list =
                  read-only-list + 
                    (IF read-only-list NE "":U THEN ",":U ELSE "":U) +
                     STRING(curr-widget).
            END.
            WHEN "DISABLE":U OR
            WHEN "ENABLE":U THEN
            DO:
                curr-widget:SENSITIVE = yes.  /* ALlow scrolling in any case.*/
                RUN get-attribute ('Read-Only-Editors':U).
                IF RETURN-VALUE = ? OR
                  LOOKUP (STRING(curr-widget), RETURN-VALUE) EQ 0 THEN 
                    curr-widget:READ-ONLY = 
                      IF p-field-setting = "ENABLE":U THEN no ELSE yes.
            END.
            WHEN "CLEAR":U THEN
                curr-widget:SCREEN-VALUE = "":U.    /* Clear for Add */
          END CASE.
        END.
        ASSIGN curr-widget = curr-widget:NEXT-SIBLING.
    END.

    IF p-field-setting = "INITIALIZE":U AND read-only-list NE "":U THEN
      RUN set-attribute-list ('Read-Only-Editors = "':U + read-only-list 
        + '"':U).

    RETURN.

END PROCEDURE.
&ENDIF                          /* end of &IF not defined adm-viewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-check-modified-all) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-check-modified-all Method-Library 
PROCEDURE use-check-modified-all :
/*------------------------------------------------------------------------------
  Purpose:     Sets a variable whenever the 'Check-Modified-All'
               attribute is set, indicating whether the check-modified
               procedure should check just fields which are in database records
               (the default) or all enabled fields (Check-modified-all = yes).
  Parameters:  attribute value - "YES" means check all enabled fields.
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.

  ASSIGN adm-check-modified-all = IF p-attr-value = "YES":U THEN yes ELSE no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-create-on-add) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-create-on-add Method-Library 
PROCEDURE use-create-on-add :
/*------------------------------------------------------------------------------
  Purpose:     Stores the value of the Create-On-Add attribute whenever
               it is set.
  Parameters:  attribute value
  Notes:       This attribute tells whether the developer wants a CREATE done
               when the Add button is pressed. 
               The default for Progress DBs is no -
               the Create is done when the record is Saved. 
               The default for non-Progress DBs is yes, because 
               there is no other way to display initial values properly. 
               Because the default (Unknown) value thus can be 
               interpreted differently depending on the source of the table,
               the adm-create-on-add variable is set explicitly to yes or no. 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.

    &IF NUM-ENTRIES("{&adm-first-enabled-table}":U, " ":U) = 1 &THEN
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 14/09/1999
              Impedir que a vari†vel adm-create-on-add possua o valor YES
              **********************************/
        ASSIGN adm-create-on-add = NO.

/*        ASSIGN adm-create-on-add = 
 *             IF (p-attr-value EQ "NO":U) OR
 *                (p-attr-value NE "YES":U AND
 *                 DBTYPE(LDBNAME(BUFFER {&adm-first-enabled-table})) EQ "PROGRESS":U)
 *             THEN no ELSE yes.*/

/***********************************************/
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-initial-lock) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-initial-lock Method-Library 
PROCEDURE use-initial-lock :
/*------------------------------------------------------------------------------
  Purpose:   Sets the local variable adm-initial-lock whenever the
             INITIAL-LOCK attribute is set for an object. This preserves
             compatibility with code in 8.0A which looks at adm-initial-lock,
             and saves the overhead of running get-attribute('INITIAL-LOCK')
             every time a record is read, since this attribute is normally
             set only once, during initialization.  
  Parameters:  attribute value: NO-LOCK, SHARE-LOCK, or EXCLUSIVE-LOCK
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.

  ASSIGN adm-initial-lock = p-attr-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInitial Method-Library 
FUNCTION setInitial RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Setar valores iniciais, na inclus∆o (ADD) quando o tipo de Database 
           for diferente de PROGRESS (por exemplo: Oracle, Sysbase, ...)
    Notes: 
------------------------------------------------------------------------------*/
  &IF INTEGER(ENTRY(1, PROVERSION, ".":U)) >= 9 &THEN
  &IF "{&adm-first-enabled-table}":U <> "":U &THEN
    DEFINE VARIABLE ttuib-cDateFormat  AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE ttuib-daDateValue  AS DATE          NO-UNDO.
    DEFINE VARIABLE ttuib-hBuffer      AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE ttuib-hBufferField AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE ttuib-iIntValue    AS INTEGER       NO-UNDO.
    DEFINE VARIABLE ttuib-wh-initial   AS WIDGET-HANDLE NO-UNDO.


    CLEAR FRAME {&FRAME-NAME} ALL.


    DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-FIELDS}
                WITH FRAME {&FRAME-NAME} NO-ERROR.


    ASSIGN ttuib-hBuffer = BUFFER {&adm-first-enabled-table}:HANDLE NO-ERROR.
    IF  NOT VALID-HANDLE(ttuib-hBuffer) THEN
        RETURN TRUE.

    ASSIGN ttuib-wh-initial = FRAME {&FRAME-NAME}:HANDLE
           ttuib-wh-initial = ttuib-wh-initial:FIRST-CHILD NO-ERROR.

    DO WHILE VALID-HANDLE(ttuib-wh-initial):
        IF CAN-QUERY(ttuib-wh-initial, "TABLE":U) AND
           CAN-QUERY(ttuib-wh-initial, "NAME":U) THEN
            IF ttuib-wh-initial:TABLE = "{&adm-first-enabled-table}":U THEN DO:
                ASSIGN ttuib-hBufferField = ttuib-hBuffer:BUFFER-FIELD(ttuib-wh-initial:NAME) NO-ERROR.

                CASE ttuib-hBufferField:DATA-TYPE:
                    WHEN "INTEGER":U THEN DO:
                        IF ttuib-wh-initial:TYPE = "RADIO-SET":U THEN DO:
                            IF ttuib-hBufferField:INITIAL = ? THEN
                                ASSIGN ttuib-iIntValue = 1 NO-ERROR.
                            ELSE
                                ASSIGN ttuib-iIntValue = INTEGER(ttuib-hBufferField:INITIAL) NO-ERROR.

                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = STRING(ttuib-iIntValue) NO-ERROR.
                        END.
                        ELSE DO:
                            IF ttuib-hBufferField:INITIAL = ? THEN
                                ASSIGN ttuib-wh-initial:SCREEN-VALUE = "0":U NO-ERROR.
                            ELSE
                                ASSIGN ttuib-wh-initial:SCREEN-VALUE = LEFT-TRIM(ttuib-hBufferField:INITIAL) NO-ERROR.
                        END.
                    END.

                    WHEN "DATE":U THEN DO:
                        ASSIGN ttuib-cDateFormat = SESSION:DATE-FORMAT NO-ERROR.

                        SESSION:DATE-FORMAT = "mdy":U.

                        ASSIGN ttuib-wh-initial:SCREEN-VALUE = ?
                               ttuib-daDateValue             = DATE(ttuib-hBufferField:INITIAL) NO-ERROR.

                        SESSION:DATE-FORMAT = ttuib-cDateFormat.

                        /* Mudado em 19/08/2002 por Farley Niehues para validar o Initial value do campo Date em 01/01/1800 
                        no caso de banco de Dados SQL MSS */
                        IF ttuib-daDateValue <> ? THEN DO: 
                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = STRING(ttuib-daDateValue, ttuib-wh-initial:FORMAT) NO-ERROR.
                            &IF "{&ems_dbtype}":U = "MSS" &THEN
                                IF DATE(STRING(ttuib-daDateValue, ttuib-wh-initial:FORMAT)) < 01/01/1753 THEN
                                    ASSIGN ttuib-wh-initial:SCREEN-VALUE = STRING(01/01/1800) NO-ERROR.
                            &endif
                        END.
                    END.

                    WHEN "DECIMAL":U THEN DO:
                        IF ttuib-hBufferField:INITIAL = ? THEN
                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = "0.0":U NO-ERROR.
                        ELSE
                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = left-trim(ttuib-hBufferField:INITIAL) NO-ERROR.
                    END.

                    OTHERWISE DO:
                        IF ttuib-hBufferField:INITIAL = ? THEN
                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = "":U NO-ERROR.
                        ELSE
                            ASSIGN ttuib-wh-initial:SCREEN-VALUE = ttuib-hBufferField:INITIAL NO-ERROR.
                    END.
                END CASE.
            END.

        IF ttuib-wh-initial:TYPE = "FIELD-GROUP":U THEN
            ASSIGN ttuib-wh-initial = ttuib-wh-initial:FIRST-CHILD NO-ERROR.
        ELSE
            ASSIGN ttuib-wh-initial = ttuib-wh-initial:NEXT-SIBLING NO-ERROR.
    END.
  &ENDIF
  &ENDIF

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

