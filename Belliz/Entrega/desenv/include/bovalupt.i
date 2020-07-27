PROCEDURE validateUpdate:

    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
 
    RUN InitializeValidate.
 
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
 
    RUN validateFields.
    
    FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-bo-erro THEN DO:
    
        &IF DEFINED(LOCKCONTROL) > 0 &THEN
            FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
        &ELSE    
            FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
        &ENDIF    
            
        RUN executeUpdate.
        
    END.
    
END PROCEDURE.
