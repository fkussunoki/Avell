/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Include....: {include/cancefil.i}
** Fun»’o.....: L½gica do bt-cancel para o cadastro de filho, do template 
**              w-incmo3.w
** Data.......: 26/09/1997
** Cria»’o....: John Cleber Jaraceski
** Par³metros.: 
*******************************************************************************/

RUN notify ('cancel-record':U).
APPLY "close":U to this-procedure.
