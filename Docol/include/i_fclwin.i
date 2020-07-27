&if "{&emsbas_version}" >= "5.06" &then
    &if "{1}" <> "" &then
        IF  OPSYS = "WIN32" then
            RUN pi_altera_window in h_facelift ( input {1} ) no-error.
    &endif
&endif

