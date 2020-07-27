&IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi_aplica_trad_menu in h_facelift ( input {1} ) no-error.
    &endif

    &if "{2}" <> "" &then
        run pi_aplica_trad_menu in h_facelift ( input {2} ) no-error.
    &endif
&endif 

