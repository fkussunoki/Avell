PROCEDURE validateDelete:

    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.
 
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
    
    RUN InitializeValidate.
    
    &IF DEFINED(LOCKCONTROL) > 0 &THEN
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
    &ELSE
        FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    &ENDIF    
    
    IF AVAIL {&TABLE-NAME} THEN DO:
        RUN executeDelete.
    END.
 
    IF l-query THEN GET NEXT {&QUERY-NAME} NO-LOCK NO-WAIT.
    ELSE FIND NEXT {&TABLE-NAME} NO-LOCK NO-ERROR.

    IF NOT AVAIL {&TABLE-NAME} THEN DO:
       IF l-query THEN GET PREV {&QUERY-NAME} NO-LOCK NO-WAIT.
       ELSE FIND PREV {&TABLE-NAME} NO-LOCK NO-ERROR.
    END.
    
    ASSIGN r-chave = ROWID({&TABLE-NAME}).
    
    RETURN "".
END PROCEDURE.
