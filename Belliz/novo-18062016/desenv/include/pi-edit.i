/**************************************************************
**
**  PI-EDIT.I - Def. Proc. Interna para Impressao de Editores
**
**************************************************************/

procedure pi-print-editor:
    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    /*Altera‡Æo 06/11/2007 - tech38629 - FO1630139 - Altera‡Æo para evitar que 
    o la‡o entre em loop infinito quando o valor recebido como parƒmetro for ? */
    IF c-editor = ? or i-len = ? THEN
        RETURN.
    /*  FO1630139 - Fim da Altera‡Æo */

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            /*Altera‡Æo 03/08/2007 - tech14187 - FO1562655 - Altera‡Æo para considerar o CHR(13) como quebra de linha tamb‚m. */
            IF i-aux = 0 THEN DO:
                assign i-aux = index(c-editor, chr(13)).
            END.
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

/* pi-edit.i */
