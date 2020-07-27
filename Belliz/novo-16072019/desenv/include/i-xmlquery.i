/* definicao da futura include */
Define Variable {1} As Handle     No-undo.

Create Query {1}.

{1}:Set-buffers( {2}.hTable ).
{1}:Query-prepare({2}.cForeach).
{1}:Query-open.
{1}:Get-first(No-lock,No-wait).

/* fim da include */
