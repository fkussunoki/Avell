/* include de controle de versão */
{include/i-prgvrs.i esutb0001 1.00.00.003}
/* definiŒão das temp-tables para recebimento de par?metros */



    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)"
        field modelo-rtf       as char format "x(35)"
        field l-habilitaRtf    as LOG
        FIELD cod-emitente-ini   AS INTEGER
        FIELD cod-emitente-fim   AS INTEGER.




def temp-table tt-raw-digita
    	field raw-digita	as raw.
/* recebimento de par?metros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.




DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
DEFINE BUFFER b-emitente FOR emitente.
DEFINE VAR h-prog AS HANDLE NO-UNDO.
DEFINE VAR m-linha AS INTEGER NO-UNDO.
{office/office.i Excel chExcel}




       chExcel:sheetsinNewWorkbook = 1.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="AvalCredito". /* Nome que ser¿ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:j1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:j1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:j1"):SetValue("Listagem de Clientes").
       chWorkSheet:Range("A1:j1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:j1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat÷rio */
           chworksheet:range("A2:y2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("Cod.Emitente").
           chworksheet:range("B" + STRING(m-linha)):SetValue("Nome abreviado").
           chworksheet:range("C" + STRING(m-linha)):SetValue("CNPJ").
           chworksheet:range("d" + STRING(m-linha)):SetValue("Cod. Matriz").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Nome Matriz").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Limite Credito").
           chworksheet:range("g" + STRING(m-linha)):SetValue("Dt. Lim. Credito").
           chworksheet:range("h" + STRING(m-linha)):SetValue("Dt. Ult. Venda").
           chworksheet:range("i" + STRING(m-linha)):SetValue("Dt. Fim. Credito").
           chworksheet:range("j" + STRING(m-linha)):SetValue("Dt. Atualiza").
		   ASSIGN m-linha = m-linha + 1.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.


RUN pi-inicializar IN h-prog (INPUT "Gerando*** Aguarde").
FOR EACH emitente NO-LOCK WHERE emitente.identific <> 2
                          AND   emitente.cod-emitente >= tt-param.cod-emitente-ini
                          AND   emitente.cod-emitente <= tt-param.cod-emitente-fim:

    FIND FIRST b-emitente NO-LOCK  WHERE b-emitente.nome-abrev  = emitente.nome-matriz  NO-ERROR.

    IF AVAIL b-emitente THEN DO:
    
RUN pi-acompanhar IN h-prog (INPUT string(emitente.cod-emitente) + " " + emitente.nome-abrev).

        chworksheet:range("A" + STRING(m-linha)):SetValue(emitente.cod-emitente).
        chworksheet:range("B" + STRING(m-linha)):SetValue(emitente.nome-abrev).
        chworksheet:range("C" + STRING(m-linha)):SetValue("'" + emitente.cgc).
        chworksheet:range("d" + STRING(m-linha)):SetValue(b-emitente.cod-emitente).
        chworksheet:range("e" + STRING(m-linha)):SetValue(emitente.nome-matriz).
        chworksheet:range("f" + STRING(m-linha)):SetValue(emitente.lim-credito).
        chworksheet:range("g" + STRING(m-linha)):SetValue(emitente.dt-lim-cred).
        chworksheet:range("h" + STRING(m-linha)):SetValue(emitente.dt-ult-venda).
        chworksheet:range("i" + STRING(m-linha)):SetValue(emitente.dt-fim-cred).
        chworksheet:range("j" + STRING(m-linha)):SetValue(emitente.dt-atualiza).

        m-linha = m-linha + 1.
    END.

END.

RUN pi-finalizar IN h-prog.


    chExcel:Visible = true.


