&if "{&emsbas_version}" >= "5.06" &then
    &if "{1}" <> "" &then
        run pi_reset_values in h_facelift no-error.
        run pi_altera_mensagem in h_facelift ( input frame {1}:handle ) no-error.
    &endif
    
    &if "{2}" <> "" &then
        run pi_reset_values in h_facelift no-error.
        run pi_altera_mensagem in h_facelift ( input frame {2}:handle ) no-error.
    &endif
&endif

