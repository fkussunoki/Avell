/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Include....: {include/okfil.i}
** Fun»’o.....: L½gica do bt-ok para o cadastro de filho, do template w-incmo3.w
** Data.......: 26/09/1997
** Cria»’o....: John Cleber Jaraceski
** Par³metros.: {1} - handle da viewer principal
*******************************************************************************/

DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN dispatch IN {1} ('update-record':U).
    IF return-value = "ADM-ERROR":U THEN
    RETURN NO-APPLY.
    RUN dispatch IN wh-browse('open-query':U).
    RUN get-rowid IN {1}
        (OUTPUT v-row-table).
    RUN pi-reposiciona-query IN wh-browse (input v-row-table).
    APPLY "close":U TO this-procedure.
END.
