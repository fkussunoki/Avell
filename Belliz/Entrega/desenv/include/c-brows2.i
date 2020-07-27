&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Biblioteca para customiza»’o dos browses"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : c-browse.i
    Purpose     : Implementar customiza»„es nos browsers

    Syntax      : {include/c-brows2.i}

    Description : Method-Library criada para fornecer customiza»’o para
                  os browses a serem utilizadas pelos programas do
                  Magnus97

    Author(s)   : Weber
    Created     : 12/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define variable wh-atributo     as handle    no-undo.
define variable wh-programa     as handle    no-undo.
def var c-container as char no-undo.
def new global shared var r-registro-atual as rowid     no-undo.
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
         HEIGHT             = 2
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
         INPUT "ProgAtributo":U).

RUN modify-list-attribute IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "ADD":U,
         INPUT "ADM-ATTRIBUTE-LIST":U,
         INPUT "ProgIncMod":U).
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-atributo) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atributo Method-Library 
PROCEDURE pi-atributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var rw-posicao as rowid no-undo.
    if  valid-handle(wh-atributo) then
        return.
    RUN get-attribute ('ProgAtributo':U).
    IF  RETURN-VALUE <>  ?
    AND RETURN-VALUE <> "":U 
    THEN DO:             
      run pi-posicao-browse (output rw-posicao).
      if rw-posicao <> ? then do:
         run value(RETURN-VALUE) persistent set wh-atributo (input-output rw-posicao).
         if valid-handle(wh-atributo) then do:
           RUN dispatch in wh-atributo (input 'initialize':U).  
           if valid-handle(wh-atributo) then do:
             run pi-reposiciona in wh-atributo.
             run new-state in wh-atributo (input 'update-begin':U).
           end.  
         end.
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
&IF DEFINED(EXCLUDE-pi-eliminar) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eliminar Method-Library 
PROCEDURE pi-eliminar :
/*------------------------------------------------------------------------------
  Purpose:     Devolve a posicao do browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO TRANSACTION:
        def var c-table-label as char format "x(40)".

        /* Trocado GET CURRENT EXCLUSIVE por FIND CURRENT EXCLUSIVE devido a FO 1114126
           O problema ‚ que em browses que tenham mais de uma tabela na query, o exclusive-lock
           locka todas as tabelas, mas s¢ uma tabela ser  manutenida nesta procedure */ 
        /*GET CURRENT {&BROWSE-NAME} EXCLUSIVE-LOCK.*/
        FIND CURRENT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15217, INPUT "":U).

            RUN dispatch IN THIS-PROCEDURE ("OPEN-QUERY":U).

            RETURN "ADM-ERROR":U.
        END.

        {include/confdel.i}
        IF NOT l-resposta 
            THEN RETURN "":U.

         /* EPC - DELETE DE BROWSE */
        &IF DEFINED(adm-browser) &THEN
        {include/i-epc037.i}
        &ENDIF
        
        /*Tech30713 - 26/08/2006 - FO:1349625 Atualiza‡Æo do browse ap¢s eliminar registro.*/
        DEF VAR c-estrutura AS CHAR NO-UNDO. /* Implementado esta vari vel devido fo: 1277935*/
        ASSIGN c-estrutura = RETURN-VALUE.
    
        DELETE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} NO-ERROR.
        IF RETURN-VALUE <> "" AND
           RETURN-VALUE <> c-estrutura THEN DO:
            IF RETURN-VALUE = "ERROR"     OR
               RETURN-VALUE = "ADM-ERROR" OR
               RETURN-VALUE = "NOK"       THEN
               RETURN RETURN-VALUE.
        END.
        /*Tech30713 - FO:1349625 - FIM*/

        IF ERROR-STATUS:ERROR 
            THEN UNDO, RETURN "ADM-ERROR":U.

         /* EPC - AFTER-DELETE DE BROWSE */
        &IF DEFINED(adm-browser) &THEN
        {include/i-epc038.i}
        &ENDIF

        BROWSE {&BROWSE-NAME}:DELETE-CURRENT-ROW().

        IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} 
            THEN RUN new-state (INPUT "record-available, SELF":U).
            ELSE RUN new-state (INPUT "no-record-available, SELF":U).

        RETURN "":U.
    END.
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
&IF DEFINED(EXCLUDE-pi-Incmod) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Incmod Method-Library 
PROCEDURE pi-Incmod :
/*------------------------------------------------------------------------------
  Purpose:     Chama o programa de IncMod e reposiciona a query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

    IF p-state = "MODIFICAR":U THEN DO:
        GET CURRENT {&BROWSE-NAME}.

        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15217, INPUT "":U).

            RUN dispatch IN THIS-PROCEDURE ("OPEN-QUERY":U).

            RETURN "ADM-ERROR":U.
        END.
        ELSE IF CURRENT-CHANGED {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15216, INPUT "":U).

                BROWSE {&BROWSE-NAME}:REFRESH().

                RETURN "ADM-ERROR":U.
             END.
    END.

    RUN get-attribute IN THIS-PROCEDURE (INPUT "ProgIncMod":U).
    IF RETURN-VALUE <> ? AND RETURN-VALUE <> "":U THEN DO:
        ASSIGN v-row-table  = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}})
               v-row-parent = ROWID({&FIRST-EXTERNAL-TABLE}).

        IF (v-row-table = ? AND p-state = "MODIFICAR":U) OR
           (v-row-parent = ?) THEN RETURN "ADM-ERROR":U.

        RUN VALUE(RETURN-VALUE) PERSISTENT SET wh-programa
                (INPUT-OUTPUT v-row-table,
                 INPUT THIS-PROCEDURE,
                 INPUT p-state).

        IF NOT VALID-HANDLE(wh-programa) THEN RETURN "ADM-ERROR":U.

        RUN dispatch IN wh-programa (INPUT "INITIALIZE":U).

        IF NOT VALID-HANDLE(wh-programa) THEN RETURN "ADM-ERROR":U.

        IF p-state = "INCLUIR":U THEN
            RUN notify IN wh-programa (INPUT "ADD-RECORD":U).
        ELSE IF p-state = "MODIFICAR":U THEN DO:
            RUN pi-reposiciona IN wh-programa.
            RUN new-state IN wh-programa (INPUT "UPDATE-BEGIN":U).
        END.

        RUN pi-entry IN wh-programa.
    END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-posicao-browse) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicao-browse Method-Library 
PROCEDURE pi-posicao-browse :
/*------------------------------------------------------------------------------
  Purpose:     Devolve a posicao do browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter rw-posicao-browse as rowid no-undo.
    assign rw-posicao-browse = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-reposiciona-query) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-query Method-Library 
PROCEDURE pi-reposiciona-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-row-table AS ROWID NO-UNDO.

/************ Customizacao TOTVS S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o reposicionamento de  
              registros em browse devido a deficiencia dos Templates PROGRESS 
              com DATABASE DIFERENTE DE PROGRESS
              **********************************/
    REPOSITION {&BROWSE-NAME} TO ROWID p-row-table NO-ERROR.
    RUN dispatch IN THIS-PROCEDURE ('get-next':U).
/***********************************************/

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
&IF DEFINED(EXCLUDE-pi-trata-state) = 0 &THEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Method-Library 
PROCEDURE pi-trata-state :
/*------------------------------------------------------------------------------
  Purpose:     Trata munda»as de estado no browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-issuer-hdl as handle no-undo.
define input param p-state      as char   no-undo.
define var wh-objeto as widget-handle no-undo.
case p-state:
    when "atributo":U then do:
        run pi-atributo.
    end.
    when "no-record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-modificar":U or 
               wh-objeto:NAME = "bt-eliminar":U then
                assign wh-objeto:SENSITIVE = no.

            if wh-objeto:NAME = "bt-incluir":U or
               wh-objeto:NAME = "bt-formar":U then
                assign wh-objeto:SENSITIVE = yes.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "no-external-record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-modificar":U or 
               wh-objeto:NAME = "bt-eliminar":U or 
               wh-objeto:NAME = "bt-incluir":U or
               wh-objeto:NAME = "bt-formar":U then
                assign wh-objeto:SENSITIVE = no.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "record-available":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-modificar":U or 
               wh-objeto:NAME = "bt-eliminar":U or 
               wh-objeto:NAME = "bt-incluir":U or
               wh-objeto:NAME = "bt-formar":U then
                assign wh-objeto:SENSITIVE = yes.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.
    end.
    when "dblclick":U then do:
        assign wh-objeto = {&BROWSE-NAME}:HANDLE in frame {&FRAME-NAME}.
        do while valid-handle(wh-objeto):
            if wh-objeto:NAME = "bt-modificar":U or 
               wh-objeto:NAME = "bt-formar":U then
                leave.

            if wh-objeto:TYPE = "field-group":U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
        end.

        if valid-handle(wh-objeto) then
            apply "CHOOSE" to wh-objeto.
    end.
end case.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF
