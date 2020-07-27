&IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi_traducao_disp in h_facelift ( input frame {1}:handle ) no-error.
    &endif
&endif 

