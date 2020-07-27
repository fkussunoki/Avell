/******************************************************************************
**  Include...: esof0520f.I3
**  Objetivo..: Atualizacao do campo nr-folha na tabela mov-ciap
**              
******************************************************************************/
&if  defined(bf_dis_ciap) &then
  for each mov-ciap of doc-fiscal 
       where mov-ciap.ind-disp exclusive-lock:
       assign mov-ciap.nr-folha = i-num-pag
              mov-ciap.nr-lre   = trim(substr(param-of.char-2,1,12)).
  end.
&endif
/* Integracao EMS x Modulo RI */
if  {cdp/cd9870.i1 doc-fiscal.cod-estabel "MOF"} THEN DO:
    RUN rip/riapi002.p (INPUT ROWID(doc-fiscal),      
                        INPUT i-num-pag,
                        INPUT trim(SUBSTRING(param-of.char-2,1,12))).
END.
/* esof0520f.i3 */
