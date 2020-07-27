procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.
procedure findPrev:
    def output parameter c-return as char.
    if l-query then
        get prev {&QUERY-NAME}
            no-lock no-wait.
    else
        find prev {&TABLE-NAME}
            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7998,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.
procedure findNext:
    def output parameter c-return as char.
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.
procedure findLast:
    if l-query then
        get last {&QUERY-NAME}
            no-lock no-wait.
    else
        find last {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.
procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail {&TABLE-NAME} then do:
        assign r-chave = rowid({&TABLE-NAME}).
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.
