procedure findRowidShow:
    /*
    **  Localiza registro pelo rowid e retorna o registro.
    */
    def input parameter r-chave as rowid no-undo.
    def output parameter table for RowObject.
    if l-query then
        reposition {&QUERY-NAME}
            to rowid r-chave no-error.
    else
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            no-lock no-error.
    run setCurrent.
end procedure.
