/***************************************************************
**
** I-IMIMP.I - Choose of bt-config-impr do template de importa‡Æo
**
***************************************************************/ 
def var c-impressora as char no-undo.
def var c-layout as char no-undo.
def var c-ant as char no-undo.
def var c-arquivo-temp as char no-undo.
def var c-arq as char no-undo.

assign c-ant = c-arquivo-destino:screen-value in frame f-pg-log
       c-arquivo-temp =  replace(c-arquivo-destino:screen-value in frame f-pg-log,":",",").
if c-arquivo-destino:screen-value in frame f-pg-log <> "" then do:
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
  assign c-arquivo-destino = c-impressora + ":" + c-layout.
else
  assign c-arquivo-destino = c-impressora + ":" + c-layout + ":" + c-arq.  



if c-arquivo-destino = ":" then
  assign c-arquivo-destino = c-ant.

assign c-imp-old = c-arquivo-destino.
  
disp c-arquivo-destino with frame f-pg-log.

/* i-imimp */
