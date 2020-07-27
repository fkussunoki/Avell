&IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi-trad-combo-box-list-item-pairs in h_facelift ( input {1}:handle ) no-error.
    &endif
&endif 

