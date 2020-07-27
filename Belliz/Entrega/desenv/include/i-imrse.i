/****************************************************************
**
** I-IMRSE.I - Gatilho "Value-Changed" de rs-execucao 
**
*****************************************************************/

if  input frame f-pg-log rs-execucao = 2 then do:
    assign c-arquivo-destino
           c-arq-old-batch = c-arquivo-destino.
    if index(c-arquivo-destino,"spool/":U) <> 0 then do:
        assign c-arquivo-destino = replace(c-arquivo-destino,"spool/":U,"").
      disp c-arquivo-destino with frame f-pg-log.
    end.
    if  input frame f-pg-log rs-destino = 3 then do:
        assign rs-destino:screen-value in frame f-pg-log = "2".
        apply "value-changed":U to rs-destino in frame f-pg-log.
    end.
    if  rs-destino:disable(c-terminal) in frame f-pg-log then.
end.
else do:
    assign c-arquivo-destino = c-arq-old-batch.
    disp c-arquivo-destino with frame f-pg-log.
    if  rs-destino:enable(c-terminal) in frame f-pg-log then.
end.
/* i-imrse.i */

