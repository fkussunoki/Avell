&if "{&emsbas_version}" >= "5.06" &then
    &if "{1}" <> "" &then
        run pi_altera_dinamicos in h_facelift ( input {1}:handle ) no-error.
    &endif
&endif

