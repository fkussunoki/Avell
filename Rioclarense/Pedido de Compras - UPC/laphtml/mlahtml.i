/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/******************************************************************
**               Temp-Table para passar o html                   **
******************************************************************/ 

DEFINE TEMP-TABLE tt-html no-undo
    FIELD seq-html     AS INT
    FIELD html-doc     AS CHAR 
    INDEX i-seq-mensagem
          seq-html        ASCENDING.
