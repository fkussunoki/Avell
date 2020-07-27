&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    &if "{1}" <> "" &then
        run pi_alterar_window in h-facelift ( input {1} ) no-error.
    &endif
&ENDIF
