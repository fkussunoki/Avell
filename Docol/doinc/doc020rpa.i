/*******************************************************************************
** Include: doc020rpa.i
**  Fun‡Æo: Confere base de contabiliza‡Æo dos encargos
*******************************************************************************/

def temp-table tt-evento   NO-UNDO
                           field cdn_event_fp like event_fp.cdn_event_fp
                           field descricao    like event_fp.des_event_fp
                           field base-inss    as de format "->>>,>>>,>>9.99"
                           field base-fgts    as de format "->>>,>>>,>>9.99"
                           field listou       as logical
                           index cdn_event_fp cdn_event_fp.

DEF VAR de-fgts-func     AS DEC  NO-UNDO. 
def var de-533           as DEC no-undo.
def var de-tot-533       as DEC no-undo.

DEF VAR de-base-fgts     as DEC NO-UNDO format "->>>,>>>,>>9.99".
DEF VAR de-base-inss     AS DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-fgts          as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-inss          as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-encargo       as DEC NO-UNDO format "->>>,>>>,>>9.99".

def var de-sub-base-fgts as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-sub-base-inss as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-sub-fgts      as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-sub-inss      as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-sub-encargo   as DEC NO-UNDO format "->>>,>>>,>>9.99".

def var de-tot-base-fgts as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-tot-base-inss as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-tot-fgts      as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-tot-inss      as DEC NO-UNDO format "->>>,>>>,>>9.99".
def var de-tot-encargo   as DEC NO-UNDO format "->>>,>>>,>>9.99".

run pi-acompanhar in h-acomp ("Lendo informa‡äes dos funcion rios").

assign de-tot-533 = 0.
for each funcionario no-lock
   where funcionario.cdn_empresa = trad_org_ext.cod_unid_organ_ext
   break by funcionario.cdn_empresa
         by funcionario.cdn_estab
         by funcionario.cdn_funcionario.
   
    IF funcionario.idi_orig_contratac_func <> 1 THEN NEXT.
    IF funcionario.idi_tip_func             = 2 THEN NEXT. /* Estagi rio */
    IF funcionario.idi_tip_func             = 7 THEN NEXT. /* Aprendizes */

   /* Base INSS */
   assign de-533       = 0
          de-fgts-func = 0.
   for each movto_calcul_func of funcionario no-lock
      where movto_calcul_func.num_mes_refer_fp         = i-mes
        and movto_calcul_func.num_ano_refer_fp         = i-ano
        and movto_calcul_func.idi_tip_fp               = 1
        and movto_calcul_func.qti_parc_habilit_calc_fp = 9.
      do i-cont = 1 to movto_calcul_func.qti_efp:  
         
         /* Verifica se existe base FGTS */
          IF LOOKUP(STRING(movto_calcul_func.cdn_event_fp[i-cont]),"531,532,533,534,535,536,542,543,544,551,552") <> 0 THEN
             ASSIGN de-fgts-func = de-fgts-func + movto_calcul_func.val_calcul_efp[i-cont].
         /* Fim Verifica base FGTS */
         
         if movto_calcul_func.cdn_event_fp[i-cont]    = "533" then
            de-533 = movto_calcul_func.val_base_calc_fp[i-cont].
            
         find first event_fp no-lock
              where  event_fp.cdn_empresa  = "*"
              AND    event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i-cont] no-error.
         if event_fp.idi_tip_inciden_inss > 2    and
            event_fp.cdn_event_fp        <> "161" then next.
         find first tt-evento 
              where tt-evento.cdn_event_fp = event_fp.cdn_event_fp no-error.
         if not avail tt-evento then do:
            create tt-evento.
            assign tt-evento.cdn_event_fp = event_fp.cdn_event_fp
                   tt-evento.descricao    = event_fp.des_event_fp.
         end.      
         if event_fp.idi_tip_inciden_inss = 2 then
            assign tt-evento.base-inss = tt-evento.base-inss - movto_calcul_func.val_calcul_efp[i-cont].
         else   
            assign tt-evento.base-inss = tt-evento.base-inss + movto_calcul_func.val_calcul_efp[i-cont].
         pause 0.
      end.   
   end. 
   assign de-tot-533 = de-tot-533 + de-533.
   
   /* Base FGTS */
   
   if de-fgts-func = 0 then next.
          
   for each movto_calcul_func of funcionario no-lock
      where movto_calcul_func.num_mes_refer_fp         = i-mes
        and movto_calcul_func.num_ano_refer_fp         = i-ano
        and movto_calcul_func.idi_tip_fp               = 1
        and movto_calcul_func.qti_parc_habilit_calc_fp = 9.

      do i-cont = 1 to movto_calcul_func.qti_efp:  
         find first event_fp no-lock
              where  event_fp.cdn_empresa  = "*"
              AND   event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i-cont] no-error.
         if event_fp.idi_tip_inciden_fgts > 2 then next.
         find first tt-evento 
              where tt-evento.cdn_event_fp = event_fp.cdn_event_fp no-error.
         if not avail tt-evento then do:
            create tt-evento.
            assign tt-evento.cdn_event_fp = event_fp.cdn_event_fp
                   tt-evento.descricao    = event_fp.des_event_fp.
         end.      
         if event_fp.idi_tip_inciden_fgts = 2 then
            assign tt-evento.base-fgts = tt-evento.base-fgts - movto_calcul_func.val_calcul_efp[i-cont].
         else   
            assign tt-evento.base-fgts = tt-evento.base-fgts + movto_calcul_func.val_calcul_efp[i-cont].
      end.
   end. 
end.

if de-tot-533 <> 0 then do:
   find first event_fp no-lock
       where  event_fp.cdn_empresa  = "*"
       AND    event_fp.cdn_event_fp = "533" no-error.
   create tt-evento.
   assign tt-evento.cdn_event_fp = "533"
          tt-evento.descricao    = event_fp.des_event_fp
          tt-evento.base-inss    = de-tot-533.
end.

put unformatted 
    skip(1)
    "Mes: " c-mes[i-mes] "/" i-ano skip(1).

run pi-acompanhar in h-acomp ("Montando Base dos Encargos").

do with width 132 down frame f-corpo.

   for each rh-encargo no-lock
      where rh-encargo.cdn-base-estorn <> 0:
      put skip(1)
          caps(rh-encargo.des-encargo) format "x(30)" at 01 skip(1).
   
      for each estrut_efp no-lock
         where estrut_efp.cod_event_sint = string(rh-encargo.cdn-base-estorn),
          each tt-evento
         where tt-evento.cdn_event_fp = estrut_efp.cdn_efp_det:
      
         assign de-base-inss = IF rh-encargo.perc-est-inss = 0
                                  THEN 0
                                  ELSE tt-evento.base-inss
                de-base-fgts = IF rh-encargo.perc-est-fgts = 0
                                  THEN 0
                                  ELSE tt-evento.base-fgts
                de-inss      = tt-evento.base-inss * rh-encargo.perc-est-inss / 100
                de-fgts      = tt-evento.base-fgts * rh-encargo.perc-est-fgts / 100
                de-encargo   = de-inss + de-fgts.
    
         disp tt-evento.cdn_event_fp
              tt-evento.descricao
              "Ja listado" when tt-evento.listou
              de-base-inss        column-label "Base INSS"
              de-base-fgts        column-label "Base FGTS"
              de-inss             column-label "Valor INSS"
              de-fgts             column-label "Valor FGTS"
              de-encargo          column-label "Total Encargo"
              with stream-io frame f-corpo.
         down with frame f-corpo.     
 
         assign de-sub-base-inss = de-sub-base-inss + de-base-inss
                de-sub-base-fgts = de-sub-base-fgts + de-base-fgts
                de-sub-inss      = de-sub-inss      + de-inss
                de-sub-fgts      = de-sub-fgts      + de-fgts
                de-sub-encargo   = de-sub-encargo   + de-encargo
                tt-evento.listou = yes.
      end.
   
      underline de-base-inss 
                de-base-fgts
                de-inss
                de-fgts
                de-encargo with frame f-corpo.
      disp "Subtotal"       @ tt-evento.descricao
           de-sub-base-inss @ de-base-inss
           de-sub-base-fgts @ de-base-fgts
           de-sub-inss      @ de-inss
           de-sub-fgts      @ de-fgts
           de-sub-encargo   @ de-encargo with stream-io frame f-corpo.
      
      assign de-tot-base-fgts = de-tot-base-fgts + de-sub-base-fgts     
             de-tot-base-inss = de-tot-base-inss + de-sub-base-inss     
             de-tot-fgts      = de-tot-fgts      + de-sub-fgts
             de-tot-inss      = de-tot-inss      + de-sub-inss
             de-tot-encargo   = de-tot-encargo   + de-sub-encargo  
             de-sub-base-fgts = 0
             de-sub-base-inss = 0
             de-sub-fgts      = 0
             de-sub-inss      = 0
             de-sub-encargo   = 0.
      put fill("-",132) format "x(132)" at 01.       
   end.

   find first tt-evento where not tt-evento.listou no-error.
   if avail tt-evento then
      put skip(1)
          "EVENTOS NAO CONSIDERADOS" skip(1).

   for each tt-evento where not tt-evento.listou:

      assign de-base-inss = tt-evento.base-inss  
             de-base-fgts = tt-evento.base-fgts  
/*              de-inss      = tt-evento.base-inss * 0.29  */
/*              de-fgts      = tt-evento.base-fgts * 0.08  */
             de-encargo   = de-inss + de-fgts.
     
      disp tt-evento.cdn_event_fp
           tt-evento.descricao 
           de-base-inss  
           de-base-fgts 
/*            de-inss  */
/*            de-fgts  */
           de-encargo          
           with stream-io frame f-corpo.
      down with frame f-corpo.     
    
      assign de-sub-base-fgts = de-sub-base-fgts + tt-evento.base-fgts
             de-sub-base-inss = de-sub-base-inss + tt-evento.base-inss
/*              de-sub-inss      = de-sub-inss      + de-inss  */
/*              de-sub-fgts      = de-sub-fgts      + de-fgts  */
             de-sub-encargo   = de-sub-encargo   + de-encargo
             tt-evento.listou = yes.
   end.

   if de-sub-base-fgts <> 0 or de-sub-base-inss <> 0 or
      de-sub-encargo   <> 0 then do:

      underline de-base-inss
                de-base-fgts 
                de-inss
                de-fgts
                de-encargo with frame f-corpo.
      disp "Subtotal"       @ tt-evento.descricao
           de-sub-base-inss @ de-base-inss
           de-sub-base-fgts @ de-base-fgts
           de-sub-inss      @ de-inss
           de-sub-fgts      @ de-fgts
           de-sub-encargo   @ de-encargo with stream-io frame f-corpo.
  
      assign de-tot-base-fgts = de-tot-base-fgts + de-sub-base-fgts     
             de-tot-base-inss = de-tot-base-inss + de-sub-base-inss     
             de-tot-fgts      = de-tot-fgts      + de-sub-fgts
             de-tot-inss      = de-tot-inss      + de-sub-inss
             de-tot-encargo   = de-tot-encargo   + de-sub-encargo.
   end.

   disp "Total"          @ tt-evento.descricao
        de-tot-base-inss @ de-base-inss
        de-tot-base-fgts @ de-base-fgts
        de-tot-inss      @ de-inss
        de-tot-fgts      @ de-fgts
        de-tot-encargo   @ de-encargo with stream-io frame f-corpo.
end.

assign de-base-fgts     = 0
       de-base-inss     = 0
       de-sub-base-fgts = 0
       de-sub-base-inss = 0
       de-sub-fgts      = 0
       de-sub-inss      = 0
       de-sub-encargo   = 0
       de-tot-base-fgts = 0
       de-tot-base-inss = 0
       de-tot-fgts      = 0
       de-tot-inss      = 0
       de-tot-encargo   = 0.

/* doc020rpa.i */
