&if "{&emsbas_version}" >= "5.06" &then
    define new global shared variable h_facelift as handle no-undo.
    if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.
&endif

