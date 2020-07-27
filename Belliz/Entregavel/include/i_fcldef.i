&if "{&emsbas_version}" >= "5.06" &then
    define new global shared variable h_facelift as handle no-undo.
    if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.
&endif
&IF "{&emsfnd_version}" >= "1.00" Or "{&mguni_version}" >= "2.06b" Or "{&aplica_facelift}" = "YES" &THEN
    define new global shared variable h-facelift as handle no-undo.
    if not valid-handle(h-facelift) then run btb/btb901zo.p persistent set h-facelift no-error.
&ENDIF


