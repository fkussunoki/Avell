/*************************************************************************
**
** AJUDA.I - Include padr�o para chamada do Help
**
**************************************************************************/

&IF DEFINED(HelpForProgram) &THEN
    RUN prgtec/men/men900za.p (INPUT ?, INPUT {&HelpForProgram}:HANDLE).
&ELSE
    RUN prgtec/men/men900za.p (INPUT ?, INPUT THIS-PROCEDURE:HANDLE).
&ENDIF

RETURN NO-APPLY.

/* include/ajuda.i */

