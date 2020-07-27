/*****************************************************************
**
** I-RPRUN.I - Roda o programa RP do relat¢rio
** {1} = Nome do programa no formato xxp/xx9999.rp.p
*****************************************************************/
def var i-num-ped as integer no-undo.
  
/*raw-transfer tt-param    to raw-param.*/

&IF "{&PGDIG}" <> "" &THEN
    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end.  
&ENDIF    

/*if rs-execucao:screen-value in frame f-pg-imp = "2" then do:
 *   /*run btb/btb911zb.p (input c-programa-mg97,
 *  *                       input "{1}",
 *  *                       input c-versao-mg97,
 *  *                       input 97,
 *  *                       input tt-param.arquivo,
 *  *                       input tt-param.destino,
 *  *                       input raw-param,
 *  *                       input table tt-raw-digita,
 *  *                       output i-num-ped).*/
 *   if i-num-ped <> 0 then                     
 *     run utp/ut-msgs.p (input "show", input 4169, input string(i-num-ped)).                      
 * end.                      
 * else do:                                         
 *   run {1} (input raw-param,
 *            input table tt-raw-digita).
 * end.*/

/* i-rprun.i */
