procedure findRowid:
    /*
    **  Localiza registro pelo rowid e nao retorna o registro.
    */
    def input parameter r-chave as rowid no-undo.
    if l-query then do:
        reposition {&QUERY-NAME}
            to rowid r-chave no-error.
            get next {&QUERY-NAME}
                no-lock no-wait.
    end.
    else
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            no-lock no-error.
    if avail {&TABLE-NAME} then RUN setCurrent.
end procedure.
