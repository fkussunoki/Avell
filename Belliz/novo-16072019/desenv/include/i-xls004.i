/*************************************************************************
**
**     Programa: i-xls004.i  
**     Data....: SETEMBRO DE 1997.
**     Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**     Objetivo: Include finalizaá∆o do ExceLApplication   
**     Vers∆o..: 1.00.000 - X.S.J.
**
******************************************************************************/

/* MUDA CURSOR PARA DEFAULT */
ch-Excel:Cursor = {&xlDefault}.

/* MOSTRA APLICAÄ∂O */
ch-Excel:ScreenUpdating = TRUE.    

/* RELEAS NOS OBJETOS USADOS */
RELEASE OBJECT ch-Worksheet.
RELEASE OBJECT ch-Workbook.
RELEASE OBJECT ch-Excel.      

/* FIM I-XLS004.i */
