{include/boerrtab.i}

DEFINE VAR l-version       as logical no-undo initial false. /* Foi verificado a vers�o de integra��o */
DEFINE VAR lExistsCustomBO as logical no-undo initial false. /* Existe BO de customiza��o? */
DEFINE VAR cCustomBOName   as char    no-undo.               /* Nome do programa de BO customizada */
DEFINE VAR l-query         as logical no-undo initial false. /* A Query esta aberta? */
DEFINE VAR i-bo-query      as integer no-undo initial 1.     /* Numero da query utilizada */
DEFINE VAR i-seq-erro      as integer no-undo.
DEFINE VAR c-return        as char    no-undo.               /* Retorno de erros. */

