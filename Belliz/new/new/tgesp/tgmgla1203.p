def buffer b_ext_lim_justif for ext_lim_justif.

FIND FIRST ext_lim_justif NO-ERROR.

find first b_ext_lim_justif where b_ext_lim_justif.cod_niv_usuar = ext_lim_justif.cod_niv_usuar no-error.

if avail b_ext_lim_justif then 

assign ext_lim_justif.primary = yes
