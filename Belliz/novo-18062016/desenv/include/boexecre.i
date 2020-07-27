procedure executeCreate:
    /*
    **  Cria registro na tabela.
    */
 
    create {&TABLE-NAME}.
    buffer-copy RowObject except r-rowid {1} to {&TABLE-NAME}.
    return string(rowid({&TABLE-NAME})).
end procedure.
