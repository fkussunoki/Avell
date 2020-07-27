if  l-separadores then do:
    if  i-op-rel = 1 then do: 
        view frame f-cab-diag.
        view frame f-bottom.
    end.
    else do: 
        view frame f-cab-diag-e.
        view frame f-bottom-e.
    end. 
    if  l-documentos then do:
        if  i-op-rel = 1 then 
            view frame f-scab-uf.
        else 
            view frame f-scab-uf-e.
    end.
    else do:
        if  i-op-rel = 1 then
            view frame f-scab-uf2.
        else
            view frame f-scab-uf2-e.
    end.
end.
else do:
    if  l-documentos then do:
        if  i-op-rel = 1 then
            view frame f-cab-uf2.
        else 
            view frame f-res-uf2.
    end.
    else do:
        if  i-op-rel = 1 then 
            view frame f-cab-uf.
        else
            view frame f-res-uf.
    end.
end.
