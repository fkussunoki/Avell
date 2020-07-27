/*************************************************************************
**
**     Programa: i-xls003.i  
**     Data....: SETEMBRO DE 1997.
**     Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**     Objetivo: Include para chamada do ExceLApplication   
**     Vers’o..: 1.00.000 - X.S.J.
**
******************************************************************************/

/* Tenta conectar-se a uma inst³ncia jÿ existente */
CREATE "Excel.Application":U ch-Excel connect no-error.
if  error-status:error = yes then do:
     /* ABRE NOVA PLANILHA EXCEL */
    CREATE "Excel.Application":U ch-Excel no-error.
    if  error-status:error = yes then do:
        run utp/ut-msgs.p (input "show":U,
                           input 7676,
                           input "").
        return 'adm-error':U. 
    end.
    else
         /* TORNA PLANILHA VIS™VEL */
        ch-Excel:Visible = TRUE.        
end.
else
     /* MAXIMIZA PLANILHA */
    ch-Excel:Windowstate = {&xlMaximized}.
/* DEIXA CRIA°ôO DA PLANILHA INVIS™VEL PARA USUæRIO */
ch-Excel:ScreenUpdating = FALSE.    
/* MUDA CURSOR PARA ESPERA */
ch-Excel:Cursor = {&xlWait}.
/* CRIA UMA Workbook */
ch-Workbook = ch-Excel:Workbooks:Add().
/* CRIA UMA Worksheet */
ch-Worksheet = ch-Workbook:Sheets:Item(1).
/* FIM I-XLS003.I */
