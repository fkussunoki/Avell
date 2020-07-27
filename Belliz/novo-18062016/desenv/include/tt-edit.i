/***************************************************************
**
** tt-edit.i  - Def. Temp Table para Impressao de Editores
**
***************************************************************/

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format 'x(80)':U
    index editor-id is primary unique 
          linha.
/* tt-edit.i */
