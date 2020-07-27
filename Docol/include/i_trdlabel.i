&IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi-trad-label in h_facelift ( input {1}:handle ) no-error.
    &endif
&endif 

