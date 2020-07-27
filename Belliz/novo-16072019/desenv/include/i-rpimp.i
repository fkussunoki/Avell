/***************************************************************
**
** I-RPIMP.I - Choose of bt-config-impr do template de relat¢rio
**
***************************************************************/ 
def var c-arquivo-temp as char no-undo.
def var c-impressora as char no-undo.
def var c-arq as char no-undo.
def var c-layout as char no-undo.
def var c-ant as char no-undo.

assign c-ant = c-arquivo:screen-value in frame f-pg-imp
       c-arquivo-temp =  replace(c-arquivo:screen-value in frame f-pg-imp,":",",").
if c-arquivo:screen-value in frame f-pg-imp <> "" then do:
  if num-entries(c-arquivo-temp) = 4 then
    assign c-impressora = entry(1,c-arquivo-temp)
           c-layout     = entry(2,c-arquivo-temp)
           c-arq        = entry(3,c-arquivo-temp) + ":" + entry(4,c-arquivo-temp).
  if num-entries(c-arquivo-temp) = 3 then
    assign c-impressora = entry(1,c-arquivo-temp)
           c-layout     = entry(2,c-arquivo-temp)
           c-arq        = entry(3,c-arquivo-temp).
  if num-entries(c-arquivo-temp) = 2 then
    assign c-impressora = entry(1,c-arquivo-temp)
           c-layout     = entry(2,c-arquivo-temp)
           c-arq        = "".
end.         

run utp/ut-impr.w (input-output c-impressora, input-output c-layout, input-output c-arq).

if c-arq = "" then
  assign c-arquivo = c-impressora + ":" + c-layout.
else
  assign c-arquivo = c-impressora + ":" + c-layout + ":" + c-arq.  



if c-arquivo = ":" then
  assign c-arquivo = c-ant.

assign c-imp-old = c-arquivo.
  
disp c-arquivo with frame f-pg-imp.

/* i-rpimp */
