DEF INPUT PARAM c-arquivo-entrada AS CHAR NO-UNDO.
DEF INPUT PARAM c-comando         AS CHAR NO-UNDO.

DEF VAR i-cont                    AS INT  NO-UNDO.
DEF VAR log-cripto                AS LOG  NO-UNDO.
                                  
DEF VAR ch-excel                  AS COM-HANDLE NO-UNDO.
DEF VAR ch-workbook               AS COM-HANDLE NO-UNDO.
DEF VAR ch-sheet                  AS COM-HANDLE NO-UNDO.

IF SEARCH(string(c-arquivo-entrada)) <> ? THEN DO: /* Se encontrar arquivo de entrada */

   CREATE "Excel.Application" ch-excel.
   ch-Excel:Visible = NO.                 
   
   ASSIGN log-cripto = NO.
   DO i-cont = 1 TO ch-excel:AddIns:Count:
      IF ch-excel:AddIns(i-cont):NAME = "cripto.xla" THEN
         ASSIGN log-cripto = YES.
   END.
   
   IF NOT log-cripto THEN DO: /* M¢dulo de Criptografia n∆o instalado no Excel da m†quina executante */
      RUN MESSAGE.p ("N∆o h† m¢dulo de criptografia instalado!",
                     "Contacte o suporte da inform†tica para instalar o suplemento de criptografia do Bradesco no Excel desta estaá∆o de trabalho.").
      OS-DELETE SILENT VALUE(c-arquivo-entrada).
   END.
   ELSE DO:
      ch-excel:workbooks:OPEN(SEARCH("suporte\cripto.xla")).
      ch-workbook = ch-excel:workbooks:ADD.
      ch-sheet    = ch-workbook:Sheets:Item(1).
      ch-sheet:cells(1,1):formula = '=cripto(' + '"' + STRING(c-arquivo-entrada) + '"' + ',"' + STRING(c-comando) + '")'.
      RELEASE OBJECT ch-sheet.
      ch-workbook:CLOSE(FALSE). /* Fecha arquivo Sem Salvar */
      RELEASE OBJECT ch-workbook.
   END.
   
   ch-excel:Quit().
   RELEASE OBJECT ch-excel.
END.
ELSE DO:
   RUN MESSAGE.p ("Problema na criptografia do arquivo!",
                  "Arquivo: " + STRING(c-arquivo-entrada) + " inv†lido.").
END.

/* cripto.p */
