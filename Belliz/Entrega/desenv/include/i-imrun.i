/*****************************************************************
**
** I-IMRUN.I - Roda o programa RP da template de importa»’o
** {1} = Nome do programa no formato xxp/xx9999.rp.p
*****************************************************************/
def var i-num-ped-exec-rpw as integer no-undo.
  
raw-transfer tt-param    to raw-param.
if rs-execucao:screen-value in frame f-pg-log = "2" then do:
  run btb/btb911zb.p (input c-programa-mg97,
                      input "{1}",
                      input c-versao-mg97,
                      input 97,
                      input tt-param.arq-destino,
                      input tt-param.destino,
                      input raw-param,
                      input table tt-raw-digita,
                      output i-num-ped-exec-rpw).
  if i-num-ped-exec-rpw <> 0 then
    run utp/ut-msgs.p (input "show":U, input 4169, input string(i-num-ped-exec-rpw)).
end.
else do:                        
  run {1} (input raw-param,
           input table tt-raw-digita).
end.         
/* i-rprun.i */
