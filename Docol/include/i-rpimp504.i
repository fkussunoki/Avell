/***************************************************************
**
** I-RPIMP.I - Choose of bt-config-impr do template de relat¢rio
**
***************************************************************/ 
def var c-ant as char no-undo.

assign c-ant = c-arquivo:screen-value in frame f-pg-imp.
run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).

assign c-arquivo = c-impressora + ":" + c-layout
       c-imp-old = c-arquivo.
if c-arquivo = ":" then
  assign c-arquivo = c-ant.
  
disp c-arquivo with frame f-pg-imp.

/* i-rpimp */
