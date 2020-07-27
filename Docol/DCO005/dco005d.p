/************************************************************************
 ** Programa..: dop/dco005d.p                                          **
 ** Objetivo..: Encontrar a categoria do cliente                       **
 ** Cria‡Æo...: Diomar Muhlmann - 02/03/2004                           **
 ************************************************************************/

DEF INPUT PARAM  i-emitente         AS INTEGER      NO-UNDO.
DEF OUTPUT PARAM c-categoria        AS CHARACTER    NO-UNDO.

FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = i-emitente
       AND emitente.identific   <> 2 NO-ERROR.
IF AVAIL emitente THEN
   ASSIGN c-categoria = emitente.categoria.

RETURN.


/* FIM - dco005d.p */
