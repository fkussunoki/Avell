OUTPUT TO c:\silet\demonst_ctbl.d.
FOR EACH demonst_ctbl NO-LOCK WHERE demonst_ctbl.cod_demonst_ctbl = "dre-blz":

    EXPORT demonst_ctbl.
END.

OUTPUT CLOSE.


OUTPUT TO c:\silet\item_demonst_ctbl.d.
FOR EACH item_demonst_ctbl NO-LOCK WHERE item_demonst_ctbl.cod_demonst_ctbl = "dre-blz":

    EXPORT item_demonst_ctbl.
END.

OUTPUT CLOSE.

OUTPUT TO c:\silet\compos_demonst_ctbl.d.
FOR EACH compos_demonst_ctbl NO-LOCK WHERE compos_demonst_ctbl.cod_demonst_ctbl = "dre-blz":

    EXPORT compos_demonst_ctbl.
END.


OUTPUT CLOSE.

OUTPUT TO c:\silet\acumul_demonst_ctbl.d.
FOR EACH acumul_demonst_ctbl NO-LOCK WHERE acumul_demonst_ctbl.cod_demonst_ctbl = "dre-blz":

    EXPORT acumul_demonst_ctbl.
END.


OUTPUT TO c:\silet\acumul_demonst_ctbl.d.
FOR EACH acumul_ctbl NO-LOCK:

    EXPORT acumul_ctbl.
END.
