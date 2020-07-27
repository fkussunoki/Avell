/***********************************************************************************************************
** Include.: dap013rp.i
** Objetivo: Montar Descri‡Æo do Tipo de Fluxo de acordo com parƒmetros
***********************************************************************************************************/

FIND FIRST tip_fluxo_financ NO-LOCK
     WHERE tip_fluxo_financ.cod_tip_fluxo_financ =  {1}.cod_tip_fluxo NO-ERROR.

ASSIGN c-descr-fluxo = FILL(' ',(({1}.nivel - 1) * i-recuo)).
IF log-cod-fluxo THEN
   ASSIGN c-descr-fluxo = c-descr-fluxo + {1}.cod_tip_fluxo + ' - '.
IF AVAIL tip_fluxo_financ THEN DO:
   IF tip_fluxo_financ.des_tip_fluxo_financ MATCHES '*,*' THEN
      ASSIGN c-descr-fluxo = c-descr-fluxo + substr(tip_fluxo_financ.des_tip_fluxo_financ,1,INDEX(tip_fluxo_financ.des_tip_fluxo_financ,',') - 1).
   ELSE
      ASSIGN c-descr-fluxo = c-descr-fluxo + tip_fluxo_financ.des_tip_fluxo_financ.
END.
ELSE
   ASSIGN c-descr-fluxo = c-descr-fluxo + 'NÆo Encontrado'.

/* dap013rp.i */
