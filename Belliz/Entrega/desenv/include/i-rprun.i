/*****************************************************************
**
** I-RPRUN.I - Roda o programa RP do relatΩrio
** {1} = Nome do programa no formato xxp/xx9999.rp.p
*****************************************************************/
def var i-num-ped-exec-rpw as integer no-undo.
  
/*tech1478 procedimentos PDF */
&IF "{&PDF}" = "YES" &THEN /*tech868*/
   
   
   IF tt-param.destino = 1 AND usePDF() AND NOT allowPrint() THEN DO: /* so deixa imprimir pdf se relatorio estiver parametrizado para tal */
       run utp/ut-msgs.p (input "show",
                          input 32552,
                          input "").
       RETURN ERROR.
   END.
   &IF "{&RTF}":U = "YES":U &THEN /* n∆o deixa usar pdf e rtf ao mesmo tempo */
       IF tt-param.l-habilitaRTF = YES AND usePDF() THEN DO:
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 32604,
                              INPUT "").
           RETURN ERROR.
       END.
   &endif
    
    &SCOPED-DEFINE des-file c-arquivo
    
    DEFINE VARIABLE c-arquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE c-sequencial-pdf AS CHAR NO-UNDO INITIAL "0":U.
    
    /* tratamento para permitir que relatorios sejam executados com destino terminal ao mesmo tempo TEM QUE SER ANTES DE GUARDAR*/
    IF usePDF() AND tt-param.destino = 3 THEN
        ASSIGN tt-param.arquivo = tt-param.arquivo + STRING(TIME * RANDOM(1,10000)) + ".tmp":U.



    ASSIGN c-arquivo = tt-param.arquivo. /* a formaá∆o de parametros em conjunto com o nome de arquivo s¢ Ç necess†ria para a raw-param, o btb911zb.p n∆o recebe a formaá∆o de parametros pdf */
    


    IF usePDF() THEN DO:
        IF rs-execucao:screen-value in frame f-pg-imp = "2" AND tt-param.destino = 2 THEN
            RUN pi_choose_file_config IN h_pdf_controller(OUTPUT c-sequencial-pdf).
        ASSIGN tt-param.arquivo = tt-param.arquivo + "|":U + c-programa-mg97 + "|":U + c-sequencial-pdf.
    END.

&else
    &SCOPED-DEFINE des-file tt-param.arquivo
&endif
/*tech14178 fim procedimentos pdf*/

raw-transfer tt-param    to raw-param.
&IF "{&PGDIG}" <> "" &THEN
    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end.  
&ENDIF    
&IF DEFINED(ProgramaRP) = 0 &THEN
if rs-execucao:screen-value in frame f-pg-imp = "2" then do:
  run btb/btb911zb.p (input c-programa-mg97,
                      input "{1}",
                      input c-versao-mg97,
                      input 97,
                      input {&des-file},
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
&ELSE
if rs-execucao:screen-value in frame f-pg-imp = "2" then do:
  run btb/btb911zb.p (input c-programa-mg97,
                      input {&ProgramaRP},
                      input c-versao-mg97,
                      input 97,
                      input {&des-file},
                      input tt-param.destino,
                      input raw-param,
                      input table tt-raw-digita,
                      output i-num-ped-exec-rpw).
  if i-num-ped-exec-rpw <> 0 then                     
    run utp/ut-msgs.p (input "show":U, input 4169, input string(i-num-ped-exec-rpw)).                      
end.                      
else do:                                         
  run value({&ProgramaRP}) (input raw-param, input table tt-raw-digita).
end.
&ENDIF

&IF "{&PDF}" = "YES" &THEN /*tech868*/
    IF usePDF() THEN
        ASSIGN tt-param.arquivo = c-arquivo.
&ENDIF

/* i-rprun.i */
