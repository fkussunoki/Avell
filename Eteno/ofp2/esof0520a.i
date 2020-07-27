/*************************************************************************
**
** Programa: esof0520A.I
** Data    : Mar‡o de 1998
** Autor   : DATASUL S.A.
** Objetivo:
** Gera tt-tab-ocor de CFOP :
**           MENSAL : se parametro{1} = " ".
**           PERIODO: se parametro{1} = "RES ANT".
**
**************************************************************************/
{cdp/cd0620.i1 "' '"}

def var de-total       as dec extent 13.
def var de-subtotal    as dec extent 13.
def var de-total-geral as dec extent 13.
def var c-des-nat      as char format "x(56)" no-undo.

assign de-total       = 0
       de-subtotal    = 0
       de-total-geral = 0.

for each tt-tab-ocor use-index codigo 
    where tt-tab-ocor.cod-tab  = 249
    and   tt-tab-ocor.c-campo1 = c-usuario
    and   tt-tab-ocor.l-campo1 /* resumo por cfop */
    and   (     (tt-tab-ocor.l-campo3 = no and i-resumo = 1)
          or  i-resumo = 2)
    break by substring(tt-tab-ocor.c-campo2,1,1)
          by tt-tab-ocor.c-campo2
          by tt-tab-ocor.i-campo1:
    
    if  tt-tab-ocor.l-campo2 /* icms */ then
        assign de-total[1]  = de-total[1]  + tt-tab-ocor.de-campo1
               de-total[2]  = de-total[2]  + tt-tab-ocor.de-campo2
               de-total[3]  = de-total[3]  + tt-tab-ocor.de-campo3
               de-total[4]  = de-total[4]  + tt-tab-ocor.de-campo4
               de-total[5]  = de-total[5]  + tt-tab-ocor.de-campo5
               de-total[10] = de-total[10] + decimal(tt-tab-ocor.c-campo3)
               de-total[11] = de-total[11] + decimal(tt-tab-ocor.c-campo4)
               de-total[12] = de-total[12] + decimal(tt-tab-ocor.c-campo5)
               de-total[13] = de-total[13] + decimal(tt-tab-ocor.descricao).
    else /* ipi */
       assign de-total[6] = de-total[6] + tt-tab-ocor.de-campo1
              de-total[7] = de-total[7] + tt-tab-ocor.de-campo2
              de-total[8] = de-total[8] + tt-tab-ocor.de-campo3
              de-total[9] = de-total[9] + tt-tab-ocor.de-campo4.
    
     /* Defini‡äes para uso da include cdp/cd0620.i2 */
    {cdp/cd0620.i1 tt-tab-ocor.cod-estabel}
    
    IF da-est-ini < da-dt-cfop THEN DO:
        if  first-of(substring(tt-tab-ocor.c-campo2,1,1)) then do:
   
            for first natur-oper fields ( nat-operacao )
                 where  substring(natur-oper.nat-operacao,1,1) =
                        substring(tt-tab-ocor.c-campo2,1,1) no-lock.
            end.
            
            assign c-desc-tot = c-linha-branco.
    
            if  avail natur-oper then do:
                case substring(natur-oper.nat-operacao,1,1):
                
                     when "1" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos do Estado".
                     when "2" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos de Outros Estados".
                     when "3" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos do Exterior".
                     when "5" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para o Estado".
                     when "6" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para Outros Estados".
                     when "7" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para o Exterior".
                end case.
    
               if l-separadores then do:
                  overlay(c-desc-tot,2) = substring(natur-oper.nat-operacao,1,1)
                  + ".00" + " " + c-des-nat.
             
                  run pi-verifica-linhas in h-esof0520e(1).
                  if  i-op-rel = 1 then
                      put c-desc-tot at 1 format "x(132)" skip.
                  else
                      put c-desc-tot at 1 format "x(159)" skip.  
               end.       
               else do:
                  run pi-verifica-linhas in h-esof0520e(1).
                  put (substr(natur-oper.nat-operacao,1,1) +
                       ".00") at 1 format "x(4)"
                       c-des-nat at 8 skip.                    
               end. 
            end. /* if avai natur-oper */   
        end. /* if  first-of... */
    
        if  last-of(tt-tab-ocor.i-campo1) then do:
            ASSIGN substring(tt-tab-ocor.char-1,1,6) = REPLACE(SUBSTRING(tt-tab-ocor.char-1,1,6),".","").

            for first natur-oper fields ( denominacao )
                where natur-oper.nat-operacao begins trim(substr(tt-tab-ocor.char-1,1,tt-tab-ocor.i-formato))
                and   natur-oper.aliquota-icm = tt-tab-ocor.i-campo1 / 100 no-lock.
            end.
            
            if  not avail natur-oper then
                for first natur-oper fields ( denominacao )
                    where natur-oper.nat-operacao begins trim(substr(tt-tab-ocor.char-1,1,tt-tab-ocor.i-formato)) no-lock.
                end.
            
            run pi-verifica-linhas in h-esof0520e (1).
            
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
            
            run pi-verifica-linhas in h-esof0520e (3).
           
            if  l-separadores then do:
                put c-sep at 1 tt-tab-ocor.c-campo2 c-sep at 10.
                 if  avail natur-oper then do:
                     if can-find(funcao 
                         where funcao.cd-funcao = "Spp-NatSemDescri"
                         and funcao.ativo       = yes) then
                         put " "  format 'x(30)' at 11.
                     else 
                         put natur-oper.denominacao  format 'x(30)' at 11.
                 end.
                 if  i-op-rel = 1 then
                     put c-sep at 66 de-total[1] to 82 format ">>>>>>>>>>>9.99"
                         c-sep.
                 else
                     put c-sep at 59 de-total[1] to 75 format ">>>>>>>>>>>9.99"
                         c-sep.
            end.
            else do:
                put tt-tab-ocor.c-campo2 at 2 .
                if  avail natur-oper then do:
                    if can-find(funcao 
                         where funcao.cd-funcao = "Spp-NatSemDescri"
                         and funcao.ativo       = yes) then
                         put " "  format 'x(30)' at 10.
                    else 
                        put natur-oper.denominacao  format "x(30)" at 10.
                end.
                put de-total[1] format ">>>>>>>>>>>>9.99"     at 41.
            end. 
            if  c-estado = "MG" then do: 
                assign de-cred-com = 0.
                for each  tt-cred-com 
                    where tt-cred-com.c-resumo <> {1}
                    and   tt-cred-com.nat-operacao = tt-tab-ocor.c-campo2
                    and   tt-cred-com.c-aliquota   = 
                          string(tt-tab-ocor.i-campo1 / 100,"999.99") no-lock: 
                    assign de-cred-com = de-cred-com
                                        + tt-cred-com.vl-icms-com.
                end.
                assign de-subt-cred = de-subt-cred + de-cred-com
                       de-geralt-cred = de-geralt-cred + de-cred-com.
            end.
           
            assign de-acum[2]  = de-total[2]
                   de-acum[3]  = de-total[3]
                   de-acum[4]  = de-total[4]
                   de-acum[5]  = de-total[5]
                   de-acum[6]  = de-total[6]
                   de-acum[7]  = de-total[7]
                   de-acum[8]  = de-total[8]
                   de-acum[9]  = de-total[9]
                   de-acum[10] = de-total[10]
                   de-acum[11] = de-total[11]
                   de-acum[12] = de-total[12]
                   de-acum[13] = de-total[13] 
                   de-aliquota = tt-tab-ocor.i-campo1 / 100.  
            
            run ofp/esof0520a1.p.
           
            assign de-subtotal[1]  = de-subtotal[1]  + de-total[1]
                   de-subtotal[2]  = de-subtotal[2]  + de-total[2]
                   de-subtotal[3]  = de-subtotal[3]  + de-total[3]
                   de-subtotal[4]  = de-subtotal[4]  + de-total[4]
                   de-subtotal[5]  = de-subtotal[5]  + de-total[5]
                   de-subtotal[6]  = de-subtotal[6]  + de-total[6]
                   de-subtotal[7]  = de-subtotal[7]  + de-total[7]
                   de-subtotal[8]  = de-subtotal[8]  + de-total[8]
                   de-subtotal[9]  = de-subtotal[9]  + de-total[9]
                   de-subtotal[10] = de-subtotal[10] + de-total[10]
                   de-subtotal[11] = de-subtotal[11] + de-total[11]
                   de-subtotal[12] = de-subtotal[12] + de-total[12]
                   de-subtotal[13] = de-subtotal[13] + de-acum[13]
                   de-total        = 0.
         end.
         if  last-of(substring(tt-tab-ocor.c-campo2,1,1)) then do:
            run pi-verifica-linhas in h-esof0520e (1).
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
        
            run pi-verifica-linhas in h-esof0520e (3).
            if  l-separadores then do:
                assign c-desc-tot = c-linha-branco.
                overlay(c-desc-tot,2) = "S U B T O T A L - " +
                    string(substring(tt-tab-ocor.c-campo2,1,1),"9.00  -   ").     
                if  i-op-rel = 1 then 
                    put substr(c-desc-tot,1,66) at 1 format "x(66)".
                else
                    put substr(c-desc-tot,1,59) at 1 format "x(59)".
                put de-subtotal[1] format ">>>>>>>>>>>>9.99" c-sep.
            end.
            else do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-s-u-b-t-o-t-a-l AS CHARACTER FORMAT "X(20)" NO-UNDO.
                {utp/ut-liter.i "S_U_B_T_O_T_A_L" *}
                ASSIGN c-lbl-liter-s-u-b-t-o-t-a-l = TRIM(RETURN-VALUE).
                put c-lbl-liter-s-u-b-t-o-t-a-l + " - "                   at 8
                    substring(tt-tab-ocor.c-campo2,1,1) format "x(1)" at 26
                    ".00  -   "
                    de-subtotal[1]             format ">>>>>>>>>>>>9.99" at 41.
            end.        
            assign de-cred-com = de-subt-cred.
            assign de-acum[2]  = de-subtotal[2]
                   de-acum[3]  = de-subtotal[3]
                   de-acum[4]  = de-subtotal[4]
                   de-acum[5]  = de-subtotal[5]
                   de-acum[6]  = de-subtotal[6]
                   de-acum[7]  = de-subtotal[7]
                   de-acum[8]  = de-subtotal[8]
                   de-acum[9]  = de-subtotal[9]
                   de-acum[10] = de-subtotal[10]
                   de-acum[11] = de-subtotal[11]
                   de-acum[12] = de-subtotal[12]
                   de-acum[13] = de-subtotal[13]
                   de-cred-com = de-subt-cred 
                   de-aliquota = ?.  
            run ofp/esof0520a1.p.
            run pi-verifica-linhas in h-esof0520e (1).
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
        
            assign de-total-geral[1]  = de-total-geral[1]  + de-subtotal[1]
                   de-total-geral[2]  = de-total-geral[2]  + de-subtotal[2]
                   de-total-geral[3]  = de-total-geral[3]  + de-subtotal[3]
                   de-total-geral[4]  = de-total-geral[4]  + de-subtotal[4]
                   de-total-geral[5]  = de-total-geral[5]  + de-subtotal[5]
                   de-total-geral[6]  = de-total-geral[6]  + de-subtotal[6]
                   de-total-geral[7]  = de-total-geral[7]  + de-subtotal[7]
                   de-total-geral[8]  = de-total-geral[8]  + de-subtotal[8]
                   de-total-geral[9]  = de-total-geral[9]  + de-subtotal[9]
                   de-total-geral[10] = de-total-geral[10] + de-subtotal[10]
                   de-total-geral[11] = de-total-geral[11] + de-subtotal[11]
                   de-total-geral[12] = de-total-geral[12] + de-subtotal[12]
                   de-total-geral[13] = de-total-geral[13] + de-subtotal[13]
                   de-subtotal     = 0
                   de-subt-cred = 0.
        end.
    END.
    ELSE DO:
        if  first-of(substring(tt-tab-ocor.c-campo2,1,1)) then do:
            &IF DEFINED(bf_dis_formato_cfop) &THEN
            for first cfop-natur fields ( cod-cfop )
                 where  substring(cfop-natur.cod-cfop,1,1) =
                        substring(tt-tab-ocor.c-campo2,1,1) no-lock.
            end.
            &ELSE
            for first ped-curva FIELDS ( it-codigo )
                 where  substring(ped-curva.it-codigo,1,1) =
                        substring(tt-tab-ocor.c-campo2,1,1) 
                 AND    ped-curva.vl-aberto = 620 no-lock.
            end.
            &ENDIF            
            
            assign c-desc-tot = c-linha-branco.
    
            &IF DEFINED(bf_dis_formato_cfop) &THEN
            if  avail cfop-natur then do:
                case substring(cfop-natur.cod-cfop,1,1):
            &ELSE
            if  avail ped-curva then do:
               case substring(ped-curva.it-codigo,1,1):
            &ENDIF
                     when "1" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos do Estado".
                     when "2" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos de Outros Estados".
                     when "3" then
                          assign c-des-nat = "Entradas e/ou Aquisicoes de Servicos do Exterior".
                     when "5" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para o Estado".
                     when "6" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para Outros Estados".
                     when "7" then
                          assign c-des-nat = "Saidas e/ou Prestacoes de Servicos para o Exterior".
               end case.                            
               if l-separadores then do:
                  overlay(c-desc-tot,2) = &IF DEFINED(bf_dis_formato_cfop) 
                                          &THEN substring(cfop-natur.cod-cfop,1,1)
                                          &ELSE substring(ped-curva.it-codigo,1,1) &endif 
                                          + ".000" + " " + c-des-nat.
             
                  run pi-verifica-linhas in h-esof0520e(1).
                  if  i-op-rel = 1 then
                      put c-desc-tot at 1 format "x(132)" skip.
                  else
                      put c-desc-tot at 1 format "x(159)" skip.  
               end.       
               else do:
                  run pi-verifica-linhas in h-esof0520e(1).
                  put &IF DEFINED(bf_dis_formato_cfop)
                      &THEN (substr(cfop-natur.cod-cfop,1,1) +
                      &ELSE (substr(ped-curva.it-codigo,1,1) +  &endif 
                       ".000") at 1 format "x(5)"
                       c-des-nat at 8 skip.                    
               end. 
            end. /* if avai natur-oper */   
        end. /* if  first-of... */
    
        if  last-of(tt-tab-ocor.i-campo1) then do:
            ASSIGN substring(tt-tab-ocor.char-1,1,6) = 
                   REPLACE(SUBSTRING(tt-tab-ocor.char-1,1,6),".","").
            &IF DEFINED(bf_dis_formato_cfop) &THEN
            find first cfop-natur
                 where cfop-natur.cod-cfop begins trim(substr(tt-tab-ocor.char-1,1,6))
                 no-lock no-error.
            &ELSE
            find first ped-curva USE-INDEX ch-vlitem
                 where ped-curva.it-codigo begins trim(substr(tt-tab-ocor.char-1,1,6))
                 AND   ped-curva.vl-aberto = 620
                 no-lock no-error.                                                                      
            &ENDIF

            
            run pi-verifica-linhas in h-esof0520e (1).
            
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
            
            run pi-verifica-linhas in h-esof0520e (3).
           
            if  l-separadores then do:
                put c-sep at 1 tt-tab-ocor.c-campo2  
                    c-sep at 10.
                   &IF DEFINED(bf_dis_formato_cfop) &THEN
                   if  avail cfop-natur then
                       put cfop-natur.des-cfop format "x(30)" at 11.
                   &ELSE
                   if  avail ped-curva then
                       put ped-curva.nome format "x(30)" at 11.
                   &ENDIF
                if  i-op-rel = 1 then
                    put c-sep at 66 de-total[1] to 82 format ">>>>>>>>>>>9.99"
                        c-sep.
                else
                    put c-sep at 59 de-total[1] to 75 format ">>>>>>>>>>>9.99"
                        c-sep.
            end.
            else do:
                put tt-tab-ocor.c-campo2 at 2.
               &IF DEFINED(bf_dis_formato_cfop) &THEN
               if  avail cfop-natur then
                   put cfop-natur.des-cfop format "x(30)" at 11.
               &ELSE
               if  avail ped-curva then
                   put ped-curva.nome format "x(30)" at 11.
               &ENDIF
                put de-total[1] format ">>>>>>>>>>>>9.99"     at 41.
            end. 
            if  c-estado = "MG" then do: 
                assign de-cred-com = 0.
                for each  tt-cred-com 
                    where tt-cred-com.c-resumo <> {1}
                    and   tt-cred-com.nat-operacao = tt-tab-ocor.c-campo2
                    and   tt-cred-com.c-aliquota   = string(tt-tab-ocor.i-campo1 / 100,"999.99") no-lock: 
                    assign de-cred-com = de-cred-com + tt-cred-com.vl-icms-com.
                end.
                assign de-subt-cred   = de-subt-cred   + de-cred-com
                       de-geralt-cred = de-geralt-cred + de-cred-com.
            end.
           
            assign de-acum[2]  = de-total[2]
                   de-acum[3]  = de-total[3]
                   de-acum[4]  = de-total[4]
                   de-acum[5]  = de-total[5]
                   de-acum[6]  = de-total[6]
                   de-acum[7]  = de-total[7]
                   de-acum[8]  = de-total[8]
                   de-acum[9]  = de-total[9]
                   de-acum[10] = de-total[10]
                   de-acum[11] = de-total[11]
                   de-acum[12] = de-total[12]
                   de-acum[13] = de-total[13] 
                   de-aliquota = tt-tab-ocor.i-campo1 / 100.  
            
            run ofp/esof0520a1.p.
           
            assign de-subtotal[1]  = de-subtotal[1]  + de-total[1]
                   de-subtotal[2]  = de-subtotal[2]  + de-total[2]
                   de-subtotal[3]  = de-subtotal[3]  + de-total[3]
                   de-subtotal[4]  = de-subtotal[4]  + de-total[4]
                   de-subtotal[5]  = de-subtotal[5]  + de-total[5]
                   de-subtotal[6]  = de-subtotal[6]  + de-total[6]
                   de-subtotal[7]  = de-subtotal[7]  + de-total[7]
                   de-subtotal[8]  = de-subtotal[8]  + de-total[8]
                   de-subtotal[9]  = de-subtotal[9]  + de-total[9]
                   de-subtotal[10] = de-subtotal[10] + de-total[10]
                   de-subtotal[11] = de-subtotal[11] + de-total[11]
                   de-subtotal[12] = de-subtotal[12] + de-total[12]
                   de-subtotal[13] = de-subtotal[13] + de-acum[13]
                   de-total        = 0.
         end.
         if  last-of(substring(tt-tab-ocor.c-campo2,1,1)) then do:
            run pi-verifica-linhas in h-esof0520e (1).
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
        
            run pi-verifica-linhas in h-esof0520e (3).
            if  l-separadores then do:
                assign c-desc-tot = c-linha-branco.
                overlay(c-desc-tot,2) = "S U B T O T A L - " +
                    string(substring(tt-tab-ocor.c-campo2,1,1),"9.000  -   ").     
                if  i-op-rel = 1 then 
                    put substr(c-desc-tot,1,66) at 1 format "x(66)".
                else
                    put substr(c-desc-tot,1,59) at 1 format "x(59)".
                put de-subtotal[1] format ">>>>>>>>>>>>9.99" c-sep.
            end.
            else do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-s-u-b-t-o-t-a-l-2 AS CHARACTER FORMAT "X(20)" NO-UNDO.
                {utp/ut-liter.i "S_U_B_T_O_T_A_L" *}
                ASSIGN c-lbl-liter-s-u-b-t-o-t-a-l-2 = TRIM(RETURN-VALUE).
                put c-lbl-liter-s-u-b-t-o-t-a-l-2 + " - "                   at 8
                    substring(tt-tab-ocor.c-campo2,1,1) format "x(1)" at 26
                    ".000  -   "
                    de-subtotal[1]             format ">>>>>>>>>>>>9.99" at 41.
            end.        
            assign de-cred-com = de-subt-cred.
            assign de-acum[2]  = de-subtotal[2]
                   de-acum[3]  = de-subtotal[3]
                   de-acum[4]  = de-subtotal[4]
                   de-acum[5]  = de-subtotal[5]
                   de-acum[6]  = de-subtotal[6]
                   de-acum[7]  = de-subtotal[7]
                   de-acum[8]  = de-subtotal[8]
                   de-acum[9]  = de-subtotal[9]
                   de-acum[10] = de-subtotal[10]
                   de-acum[11] = de-subtotal[11]
                   de-acum[12] = de-subtotal[12]
                   de-acum[13] = de-subtotal[13]
                   de-cred-com = de-subt-cred 
                   de-aliquota = ?.  
            run ofp/esof0520a1.p.
            run pi-verifica-linhas in h-esof0520e (1).
            if  not l-nova-pagina then
                if  i-op-rel = 1 then
                    put c-linha-branco at 1 format "x(132)" skip.
                else
                    put c-linha-branco at 1 format "x(159)" skip.  
        
            assign de-total-geral[1]  = de-total-geral[1]  + de-subtotal[1]
                   de-total-geral[2]  = de-total-geral[2]  + de-subtotal[2]
                   de-total-geral[3]  = de-total-geral[3]  + de-subtotal[3]
                   de-total-geral[4]  = de-total-geral[4]  + de-subtotal[4]
                   de-total-geral[5]  = de-total-geral[5]  + de-subtotal[5]
                   de-total-geral[6]  = de-total-geral[6]  + de-subtotal[6]
                   de-total-geral[7]  = de-total-geral[7]  + de-subtotal[7]
                   de-total-geral[8]  = de-total-geral[8]  + de-subtotal[8]
                   de-total-geral[9]  = de-total-geral[9]  + de-subtotal[9]
                   de-total-geral[10] = de-total-geral[10] + de-subtotal[10]
                   de-total-geral[11] = de-total-geral[11] + de-subtotal[11]
                   de-total-geral[12] = de-total-geral[12] + de-subtotal[12]
                   de-total-geral[13] = de-total-geral[13] + de-subtotal[13]
                   de-subtotal     = 0
                   de-subt-cred = 0.
        end.
    END.
     if  last(substring(tt-tab-ocor.c-campo2,1,1)) then do:
         run pi-verifica-linhas in h-esof0520e (1).
         if  not l-nova-pagina then
              if  i-op-rel = 1 then
                 put c-linha-branco at 1 format "x(132)" skip.
             else
                 put c-linha-branco at 1 format "x(159)" skip.  

         run pi-verifica-linhas in h-esof0520e (3).
         if  l-separadores then do:
             assign c-desc-tot = c-linha-branco.
             overlay(c-desc-tot,2) = "T O T A L  G E R A L". 
             if  i-op-rel = 1 then
                 put substr(c-desc-tot,1,66) at 1 format "x(66)".
             else
                 put substr(c-desc-tot,1,59) at 1 format "x(59)".
             put de-total-geral[1] format ">>>>>>>>>>>>9.99" c-sep.
         end.
         else do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-t-o-t-a-l-g-e-r-a-l AS CHARACTER FORMAT "X(22)" NO-UNDO.
             {utp/ut-liter.i "T_O_T_A_L__G_E_R_A_L" *}
             ASSIGN c-lbl-liter-t-o-t-a-l-g-e-r-a-l = TRIM(RETURN-VALUE).
             put c-lbl-liter-t-o-t-a-l-g-e-r-a-l  at 8
                 de-total-geral[1] format ">>>>>>>>>>>>>9.99" at 40.
         end.
         de-cred-com = de-geralt-cred.
         assign de-acum[2]  = de-total-geral[2]
                de-acum[3]  = de-total-geral[3]
                de-acum[4]  = de-total-geral[4]
                de-acum[5]  = de-total-geral[5]
                de-acum[6]  = de-total-geral[6]
                de-acum[7]  = de-total-geral[7]
                de-acum[8]  = de-total-geral[8]
                de-acum[9]  = de-total-geral[9]
                de-acum[10] = de-total-geral[10]
                de-acum[11] = de-total-geral[11]
                de-acum[12] = de-total-geral[12]
                de-acum[13] = de-total-geral[13]
                de-cred-com = de-geralt-cred 
                de-aliquota = ?.
         run ofp/esof0520a1.p.
                           
         assign de-total-geral = 0
                de-geralt-cred = 0.
     end.
end.

/* fim include esof0520A.I */

