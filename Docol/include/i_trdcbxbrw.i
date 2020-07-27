&IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi-trad-combo-box-in-browse in h_facelift ( input {2}:handle in browse {1}, input {3} ) no-error.
    &endif
&endif 

