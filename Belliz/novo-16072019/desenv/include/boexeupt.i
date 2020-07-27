PROCEDURE executeUpdate:

&IF DEFINED(LOCKCONTROL) > 0 &THEN
    DEFINE VARIABLE iLockAgain AS INTEGER NO-UNDO.
    
    TRANS_BLOCK:
    DO TRANSACTION:
        /*--- Marca registro com exclusive-lock ---*/
        FIND CURRENT {&Table-Name} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        
        
        /*--- Execucao de N (inicialmente 5) tentativas a fim de esperar o 
              registro corrente ser desbloqueado ---*/
        DO WHILE LOCKED {&Table-Name}:
            
            IF LOCKED {&Table-Name} THEN
                FIND CURRENT {&Table-Name} EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                
            IF (NOT LOCKED {&Table-Name} AND NOT AVAILABLE {&Table-Name}) OR
               (AVAILABLE {&Table-Name} AND NOT LOCKED {&Table-Name}) OR
               (iLockAgain >= 5) THEN LEAVE.
            
            ASSIGN iLockAgain = iLockAgain + 1.
        END.
        
        IF NOT AVAILABLE {&Table-Name} THEN
            IF NOT LOCKED {&Table-Name} THEN DO:
            
                /*--- Erro 3: Tabela {&TableLabel} nao disponivel ---*/
                ASSIGN i-seq-erro = i-seq-erro + 1.
                
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 3
                       tt-bo-erro.mensagem = "Tabela {&TableLabel} n∆o dispon°vel".
                
                UNDO TRANS_BLOCK, RETURN "NOK":U.
                
            END.
        ELSE DO:
        
            /*--- Erro 4: Registro da tabela {&TableLabel} esta bloqueado 
                          por outro usuario ---*/
                          
            ASSIGN i-seq-erro = i-seq-erro + 1.
            
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 4
                   tt-bo-erro.mensagem = "Registro da tabela {&TableLabel} est† bloqueado por outro usu†rio".
            
            UNDO TRANS_BLOCK, RETURN "NOK":U.
        END.
        ELSE IF CURRENT-CHANGED {&Table-Name} THEN DO:
            
            /*--- Erro 12: Registro corrente ja foi alterado por outro usuario ---*/
            
            ASSIGN i-seq-erro = i-seq-erro + 1.
            
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 12
                   tt-bo-erro.mensagem = "Registro corrente foi alterado por outro usu†rio".
            
            UNDO TRANS_BLOCK, RETURN "NOK":U.
        END.
        
        BUFFER-COPY RowObject EXCEPT r-rowid {1} TO {&TABLE-NAME}.
        
    END.    
&ELSE
    BUFFER-COPY RowObject EXCEPT r-rowid {1} TO {&TABLE-NAME}.
&ENDIF    
    
END PROCEDURE.
