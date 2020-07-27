/**************************************************************************
**
** I-RPTRM - Realiza o destino de impress∆o Terminal
**
***************************************************************************/
DEF VAR cEditor     AS CHAR.
DEF VAR vLog        AS LOGICAL.
DEF VAR vLogNotepad AS LOGICAL INITIAL YES. /* pdf */


/*Alterado 15/02/2005 - tech1007 - Alterado teste para que n∆o seja aberto o arquivo
  LST quando for gerado o arquivo RTF*/
IF tt-param.destino = 3 THEN DO:
     /* RTF */
     &IF "{&RTF}":U = "YES":U &THEN
     IF tt-param.l-habilitaRTF = YES THEN
         ASSIGN vLogNotepad = NO.
     &endif
     
     &IF "{&PDF}" = "YES" &THEN /*tech868*/
     IF usePDF() THEN
         ASSIGN vLogNotepad = NO.
     &endif
     
     IF vLogNotepad = YES THEN DO:
         GET-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE cEditor.

         IF  SEARCH(cEditor) = ? THEN DO:
             ASSIGN  cEditor = OS-GETENV("windir") + "~\notepad.exe"
                     vLog    = YES.
             IF  SEARCH(cEditor) = ? THEN DO:
                 ASSIGN  cEditor = OS-GETENV("windir") + "~\write.exe".
                 IF  SEARCH(cEditor) = ? THEN DO:
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 27576,
                                        INPUT tt-param.arquivo).
                     ASSIGN  vLog    = NO.
                 END.
             END.
         END.

         RUN winexec (INPUT cEditor + CHR(32) + tt-param.arquivo, INPUT 1).
     END.
        
     &IF "{&PDF}" = "YES" &THEN /*tech868*/
     /*tech1478 abre acrobat reader pro cara visualizar o arquivo */
         IF usePDF() THEN DO:
             RUN pi_call_adobe IN h_pdf_controller (INPUT tt-param.arquivo).
         END.
     &endif
    
END.


/* Alterado 25/05/2005 - tech14207 - Alterado para corrigir o erro 142 gerado quando se utiliza a opá∆o RTF com o cursor no editor
do browser br-digita*/

IF tt-param.destino = 3 THEN DO:
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/*Fim alteracao 15/02/2005*/
/* i-rptrm */
