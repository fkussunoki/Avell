if  l-separadores then do:
    if  i-op-rel = 1 then do:
        view frame f-cab-diag.
        view frame f-bottom.
        view frame f-scab-diag.
    end.
    else do:
        view frame f-cab-diag-e.
        view frame f-bottom-e.
        view frame f-scab-diag-e.
    end.
end.
else do:
    if  i-op-rel = 1 then
        view frame f-cab.
    else
        view frame f-cab-exp.
end.
