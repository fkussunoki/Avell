&if "{&emsbas_version}" >= "5.06" &then
    &if "{1}" <> "" &then
        run pi_aplica_facelift_nao_def in h_facelift ( input frame {1}:handle ) no-error.
    &endif
&endif

