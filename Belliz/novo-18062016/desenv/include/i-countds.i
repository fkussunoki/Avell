/**********************************************************************************
**
** I-COUNTDS.I - Include padr’o contar registros de tabelas em ambiente Dataserver
**
**********************************************************************************/

DEFINE VARIABLE iSQLStatement AS INTEGER NO-UNDO.

&IF DEFINED(COND) <> 0 &THEN

RUN STORED-PROCEDURE {&BANCO}.send-sql-statement
	 iSQLStatement = PROC-HANDLE
	  ( INPUT "select count(*) from " + REPLACE(" {&TABELA} ", "-", "_")
        + REPLACE(REPLACE(REPLACE(" {&COND} ", " -", CHR(27)), "-", "_"), CHR(27), " -") ).

&ELSE

RUN STORED-PROCEDURE {&BANCO}.send-sql-statement
	 iSQLStatement = PROC-HANDLE
	  ( INPUT "select count(*) from " + REPLACE(" {&TABELA} ", "-", "_")).

&ENDIF

FOR EACH {&BANCO}.proc-text-buffer 
    WHERE PROC-HANDLE = iSQLStatement:
    ASSIGN {&DEST} = int(proc-text-buffer.proc-text).
END.

CLOSE STORED-PROCEDURE {&BANCO}.send-sql-statement
     WHERE PROC-HANDLE = iSQLStatement.

