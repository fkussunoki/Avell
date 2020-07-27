/***************************************************************
**
** I-RPIMP.I - Choose of bt-config-impr do template de relat¢rio
**
***************************************************************/ 
def var c-ant       AS CHAR NO-UNDO.
DEF VAR c-arq-saida AS CHAR NO-UNDO.

assign c-ant = c-arquivo:screen-value in frame f-pg-imp.
run prgtec/btb/btb036zb.w (INPUT-OUTPUT c-impressora, INPUT-OUTPUT c-layout, INPUT-OUTPUT c-arq-saida).

assign c-arquivo = c-impressora + ":" + c-layout + ":" + c-arq-saida
       c-imp-old = c-arquivo.
if c-arquivo = ":" then
  assign c-arquivo = c-ant.
  
disp c-arquivo with frame f-pg-imp.

/* i-rpimp */
