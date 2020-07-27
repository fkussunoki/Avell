&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza‡Æo das querys"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-query.i
    Purpose     : Implementar customiza‡äes nas querys

    Syntax      : {include/c-query.i}

    Description : Method-Library criada para fornecer customiza‡Æo para
                  as querys a serem utilizadas pelos programas do
                  Magnus97

    Author(s)   : Vanei
    Created     : 10/01/1997
    Notes       : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE h-panel-nav AS HANDLE NO-UNDO.

define variable wh-pesquisa        as handle no-undo.
define variable wh-relacionamento  as handle no-undo.
define variable wh-consulta        as handle no-undo.

define variable v-row-table as rowid no-undo.

define variable wh-programa  as handle no-undo.
define variable c-container  as char   no-undo.
define variable wh-container as handle no-undo.
define variable container    as char   no-undo.
def new global shared var r-registro-atual as rowid     no-undo.
def new global shared var l-implanta       as logical    init no.

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
         HEIGHT             = 2.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgPesquisa":U).

  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgVaPara":U).

  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgIncMod":U).

  RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "Implantar":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-IncMod) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IncMod Method-Library 
PROCEDURE IncMod :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de IncMod e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
    DEFINE VARIABLE nom_program AS CHARACTER NO-UNDO. /* vari vel para receber o return-value */
    
    RUN get-attribute IN THIS-PROCEDURE (INPUT "ProgIncMod":U).
    
    ASSIGN nom_program = RETURN-VALUE.
    
    IF nom_program <> ? AND nom_program <> "":U THEN DO:
        ASSIGN v-row-table = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
        
        RUN VALUE(nom_program) PERSISTENT SET wh-programa
                (INPUT-OUTPUT v-row-table, 
                 INPUT p-state,
                 INPUT THIS-PROCEDURE).
        
        IF NOT VALID-HANDLE(wh-programa) OR 
               wh-programa:TYPE <> "PROCEDURE":U OR 
               wh-programa:FILE-NAME <> nom_program THEN 
           RETURN "ADM-ERROR":U.
        
        RUN dispatch IN wh-programa (INPUT "INITIALIZE":U).
        
        IF NOT VALID-HANDLE(wh-programa) OR 
               wh-programa:TYPE <> "PROCEDURE":U OR 
               wh-programa:FILE-NAME <> nom_program THEN 
           RETURN "ADM-ERROR":U.
        
        IF p-state = "INCLUI":U THEN
            RUN notify IN wh-programa (INPUT "ADD-RECORD":U).
        ELSE IF p-state = "MODIFICA":U THEN DO:
                RUN pi-desabilita-bts IN wh-programa.
                RUN pi-reposiciona IN wh-programa.
                RUN new-state IN wh-programa (INPUT "UPDATE-BEGIN":U).
             END.
             ELSE IF p-state = "COPIA":U THEN DO:
                     RUN pi-desabilita-bts IN wh-programa.
                     RUN pi-reposiciona IN wh-programa.
                     RUN notify IN wh-programa (INPUT "COPY-RECORD":U).
                  END.
        
        RUN pi-entry IN wh-programa.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Pesquisa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pesquisa Method-Library 
PROCEDURE Pesquisa :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de pesquisa e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE nom_program as CHARACTER NO-UNDO. /* vari vel para receber o return-value */
    
    RUN get-attribute ('Implantar':U).
    
    IF RETURN-VALUE <> ? AND RETURN-VALUE <> "":U
        THEN DO:
            if RETURN-VALUE = "yes":U then assign l-implanta = yes.
            if RETURN-VALUE = "no":U then assign l-implanta = no.
        END.
            
    RUN get-attribute ('ProgPesquisa':U).

    ASSIGN nom_program = RETURN-VALUE.
    
    IF  nom_program <> ?
    AND nom_program <> "":U
    AND (NOT VALID-HANDLE(WH-PESQUISA) OR 
         wh-pesquisa:TYPE <> "PROCEDURE":U OR 
         wh-pesquisa:FILE-NAME <> nom_program) THEN DO:
         
        run value(nom_program) persistent set wh-pesquisa.
        
        if valid-handle(wh-pesquisa) and
           wh-pesquisa:TYPE = "PROCEDURE":U and
           wh-pesquisa:FILE-NAME = nom_program then do:
         
          RUN add-link IN adm-broker-hdl (INPUT wh-pesquisa,
                                          INPUT 'State':U,
                                          INPUT THIS-PROCEDURE).
          
          /* O pre-processador a seguir ‚ utilizado pela equipe do Produto HR */
          {&CODE-OPEN-QUERY-FUNDAC-EDUC-HR}
          
          RUN dispatch IN wh-pesquisa ('initialize':U).
          if valid-handle(wh-pesquisa) and
             wh-pesquisa:TYPE = "PROCEDURE":U and
             wh-pesquisa:FILE-NAME = nom_program then          
            RUN pi-entry IN wh-pesquisa.
        end.  
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-consulta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consulta Method-Library 
PROCEDURE pi-consulta :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de pesquisa e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-inicio    as integer no-undo.
def var i-fim       as integer no-undo.
def var rw-reserva  as rowid   no-undo.

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-container ).
  assign rw-reserva = rowid({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
  IF VALID-HANDLE(WIDGET-HANDLE(c-container)) THEN do:
    assign wh-container = widget-handle(c-container).
    assign i-inicio     = r-index(wh-container:file-name,"/") + 1
           i-fim        = r-index(wh-container:file-name,".w").

    if i-fim < r-index(wh-container:file-name,".r") then
       i-fim = r-index(wh-container:file-name,".r").  
    if i-inicio < r-index(wh-container:file-name,"~\") then
       i-inicio = r-index(wh-container:file-name,"~\") + 1.
   if i-inicio > 0 and i-fim > 0 then do:
      run utp/ut-cons.w (input substring(wh-container:file-name,i-inicio , i-fim - i-inicio)).
      run pi-reposiciona-query (input rw-reserva).
   end.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-container) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-container Method-Library 
PROCEDURE pi-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-container ).
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-desabilita) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita Method-Library 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run pi-container.
run pi-desab IN widget-handle(c-container).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-habilita) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita Method-Library 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run pi-container.
run pi-habil IN widget-handle(c-container).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-posicao-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicao-query Method-Library 
PROCEDURE pi-posicao-query :
/*------------------------------------------------------------------------------
  Purpose:     Devolve a posicao do query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter rw-posicao-query as rowid no-undo.

    assign rw-posicao-query = rowid({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-reposiciona-query) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-query Method-Library 
PROCEDURE pi-reposiciona-query :
/*------------------------------------------------------------------------------
  Purpose:     Reposicionar a query
  Parameters:  INPUT rowid para reposicionamento.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-row-table AS ROWID NO-UNDO.
    
    DEFINE VARIABLE current-rowid AS ROWID NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    /*  NÆo reposiciona a query se a tabela estiver vazia. */
    IF NOT CAN-FIND(FIRST {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN DO:
        SESSION:SET-WAIT-STATE("":U).
        RETURN .
    END.    
    /* O pre-processador a seguir ‚ utilizado pela equipe do Produto HR - 
       Este pre-processador deve ficar imediatamente antes do reposition da query, sob pena
       de causar um erro no produto HR */
    {&CODE-SECURITY-OPEN-QUERY-HR}
    
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN
            ASSIGN current-rowid = ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}).
/* tech1139 - 27/07/2005 - FO 1186.555 */
        FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
            WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = p-row-table
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
        REPOSITION {&QUERY-NAME} TO ROWID p-row-table NO-ERROR.
    &ENDIF
/***********************************************/
    
    IF ERROR-STATUS:ERROR THEN DO:
        
        SESSION:SET-WAIT-STATE("":U).
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 16690, INPUT "":U).
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        IF RETURN-VALUE = "NO":U THEN
        DO:
            /* se a resposta for no, seta o mouse para "normal" e retorna*/
            SESSION:SET-WAIT-STATE("":U).
            RETURN .
        END.
        ELSE
            ASSIGN tt-uib-reposition-query = yes.
        
        RUN dispatch IN THIS-PROCEDURE ("open-query":U).
        
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
        &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
/* tech1139 - 27/07/2005 - FO 1186.555 */
            FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-LOCK
                WHERE ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = p-row-table
                &IF "{&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
                    AND {&WHERE-FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} NO-ERROR. 
                &ELSE
                    NO-ERROR.
                &ENDIF        
/* tech1139 - 27/07/2005 - FO 1186.555 */
        &ELSE
            REPOSITION {&QUERY-NAME} TO ROWID p-row-table NO-ERROR.
        &ENDIF
/***********************************************/
    END.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski
              Ao utilizar Dataserver Oracle ou SQL-Server, deve-se trocar o uso de QUERY por FIND
              **********************************/
    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        ASSIGN tt-uib-reposition-find = TRUE.
    &ENDIF
/***********************************************/

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o panel p-navega.w 
              devido a deficiencia dos Templates PROGRESS com 
              DATABASE DIFERENTE DE PROGRESS
              **********************************/
    &IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN
        /*Alterado 02/10/2006 - tech1007 - Alterado para habilitar os botoes de navegacao de forma correta quando for banco Oracle*/
        &IF PROVERSION < "9.1C":U AND INTEGER(ENTRY(1,PROVERSION,".")) <= 9 &THEN    
        ASSIGN tt-uib-reposition-query = yes.        
        RUN new-state (INPUT "Reposition-Oracle,NAVIGATION-SOURCE":U).
        &ELSE
        ASSIGN tt-uib-reposition-query = NO.
        RUN new-state (INPUT "Reposition-Oracle-Correct,NAVIGATION-SOURCE":U).
        &ENDIF
        /*Fim alteracao 02/10/2006*/
    &ENDIF
/***********************************************/
    
    RUN dispatch IN THIS-PROCEDURE ('get-next':U).
    
    SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     Trata as mudan‡as de estado
  Parameters:  INPUT Handle da procedure pai
               INPUT C¢digo do Estado
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.
  
  CASE entry(1, p-state, "|":U):
      WHEN 'Pesquisa':U THEN DO:
          run Pesquisa.
      END.
      WHEN 'VaPara':U THEN DO:
          run VaPara.
      END.
      WHEN 'Inclui':U THEN DO:
          run IncMod (INPUT P-STATE).
      END.
      WHEN 'Modifica':U THEN DO:
          run IncMod (INPUT P-STATE) .
      END.
      WHEN 'Copia':U THEN DO:
          run IncMod (INPUT P-STATE).
      END.
      WHEN 'Consulta':U THEN DO:
          run pi-consulta.
      END.
      WHEN 'Reposiciona':U THEN DO:
          if  num-entries(p-state, "|":U) > 1 then do:
              run pi-reposiciona-query (to-rowid(entry(2, p-state, "|":U))).
          end.
      END.
   
/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o panel p-navega.w 
              devido a deficiencia dos Templates PROGRESS com DATABASE ORACLE
              E SQL SERVER
              **********************************/
   &IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN
      WHEN "DELETE-COMPLETE":U THEN DO:
        DEFINE VARIABLE c-auxiliar AS CHARACTER NO-UNDO.
        
        IF NOT VALID-HANDLE(h-panel-nav) THEN DO:
            RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                   INPUT "NAVIGATION-SOURCE":U,
                                                   OUTPUT c-auxiliar).
            
            ASSIGN h-panel-nav = WIDGET-HANDLE(c-auxiliar).
        END.
        
        IF VALID-HANDLE(h-panel-nav) THEN DO:
            RUN get-attribute IN h-panel-nav (INPUT "IsInReposition":U).
            
            IF RETURN-VALUE = "YES":U THEN 
                ASSIGN adm-first-rowid = IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} 
                                         THEN ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}})
                                         ELSE ?.
        END.
        
      END.
   &ENDIF
/***********************************************/

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VaPara) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VaPara Method-Library 
PROCEDURE VaPara :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de VaPara e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE nom_program AS CHARACTER NO-UNDO.

    RUN get-attribute ('ProgVaPara':U).
    
    ASSIGN nom_program = RETURN-VALUE.
    
    IF  nom_program <> ?
    AND nom_program <> "":U
    AND (NOT VALID-HANDLE(WH-PESQUISA) OR 
         wh-pesquisa:TYPE <> "PROCEDURE":U OR 
         wh-pesquisa:FILE-NAME <> nom_program) THEN DO:
        
        /* O pre-processador a seguir ‚ utilizado pela equipe do Produto HR */
        run value(nom_program) (output v-row-table {&CODE-VAPARA-FUNDAC-EDUC-HR}).
        if  v-row-table <> ? then do:
            run pi-reposiciona-query (v-row-table).
        end.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

