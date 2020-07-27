/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520C 2.00.00.040 } /*** 010040 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520c MOF}
&ENDIF


/******************************************************************************
**
**  Programa: esof0520C.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: display de totais
**
******************************************************************************/
def input parameter c-tipo as char no-undo.

{ofp/esof0520.i shared}

def shared var h-esof0520e as handle no-undo.

if  c-tipo <> "TOTAL" then do:
    {ofp/esof0520i.i1 "where tt-cred-com.c-resumo = c-tipo and c-tipo <> "
                    " "}
end.
else do: 
    {ofp/esof0520i.i1 "where tt-cred-com.c-resumo <> "
                    " " } /* somatorio total */ 
end.

if  i-op-rel = 1 then 
    assign i-posicao[1]   = 90
           i-posicao[2]   = 95
           i-posicao[3]   = 98
           i-posicao[4]   = 99
           i-posicao[5]   = 113
           i-posicao[6]   = 114
           i-posicao[7]   = 120
           i-posicao[8]   = 131
           i-posicao[9]   = 132
           /* posi‡äes com separadores */
           i-posicao[10]  = 83
           i-posicao[11]  = 88
           i-posicao[12]  = 103
           i-posicao[13]  = 123
           i-posicao[14]  = 123
           i-posicao[15]  = 125.
else
    assign i-posicao[1] = 145
           i-posicao[2] = 159
          /* posi‡äes com separadores */
           i-posicao[3] = 85 
           i-posicao[4] = 90
           i-posicao[5] = 108
           i-posicao[6] = 128
           i-posicao[7] = 142
           i-posicao[8] = 154
           i-posicao[9] = 156.

if  l-separadores then do:
    run pi-verifica-linhas in h-esof0520e (3).
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(4)" NO-UNDO.
    {utp/ut-liter.i "ICMS" *}
    ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
    put substr(c-desc-tot,1,86) at 1 format "x(86)"
        c-sep at i-posicao[1] c-lbl-liter-icms       
        c-sep at i-posicao[2] 
        "1"   at i-posicao[3] 
        c-sep at i-posicao[4] de-aux[1] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] de-aux[2] format ">>>>>>>9.99" to i-posicao[8] /* TOTAL GERAL */ 
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put de-aux[5] format ">>>,>>9.99" c-sep    
            de-aux[6] format ">>>,>>9.99" c-sep.  
    put skip.
    put substr(c-linha-branco,1,91) at 1 format "x(91)"
        c-sep at i-posicao[2] 
        "2"   at i-posicao[3]
        c-sep at i-posicao[4] de-aux[3] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6] 
        c-sep at i-posicao[7] 0         format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    put substr(c-linha-branco,1,91) at 1 format "x(91)"
        c-sep at i-posicao[2] 
        "3"   at i-posicao[3]
        c-sep at i-posicao[4] de-aux[4] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] 0         format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    run pi-verifica-linhas in h-esof0520e(3).
    
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-ipi AS CHARACTER FORMAT "X(3)" NO-UNDO.
    {utp/ut-liter.i "IPI" *}
    ASSIGN c-lbl-liter-ipi = TRIM(RETURN-VALUE).
    put substr(c-linha-branco,1,86) at 1 format "x(86)"
        c-sep at i-posicao[1] c-lbl-liter-ipi        
        c-sep at i-posicao[2]  
        "1"   at i-posicao[3]
        c-sep at i-posicao[4] de-aux[7] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] de-aux[8] format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    put substr(c-linha-branco,1,91) at 1 format "x(91)"
        c-sep at i-posicao[2] 
        "2"   at i-posicao[3]
        c-sep at i-posicao[4] de-aux[9] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] 0         format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    put substr(c-linha-branco,1,91) at 1 format "x(91)"
        c-sep at i-posicao[2]  
        "3"   at i-posicao[3]
        c-sep at i-posicao[4] de-aux[10] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] 0          format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    run pi-verifica-linhas in h-esof0520e (1).
    put substr(c-linha-branco,1,86) at 1 format "x(86)"
        c-sep at i-posicao[1]  "ST"        
        c-sep at i-posicao[2]          
        c-sep at i-posicao[4] de-aux[5] format ">>>>>>>>>>9.99" to i-posicao[5]
        c-sep at i-posicao[6]
        c-sep at i-posicao[7] de-aux[6] format ">>>>>>9.99"  to i-posicao[8]
        c-sep at i-posicao[9].
    if  i-op-rel = 2 then 
        put c-sep at i-posicao[1]
            c-sep at i-posicao[2].
    put skip.
    if (c-estado = "MG"
    or c-estado = "PE") and de-aux[12] > 0 then do:
        run pi-verifica-linhas in h-esof0520e(1).
    
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-obs AS CHARACTER FORMAT "X(5)" NO-UNDO.
        {utp/ut-liter.i "OBS" *}
        ASSIGN c-lbl-liter-obs = TRIM(RETURN-VALUE).
        put substr(c-linha-branco,1,86) at 1 format "x(86)" 
            c-sep at i-posicao[1] c-lbl-liter-obs 
            c-sep at i-posicao[2]
            c-sep at i-posicao[4] de-aux[12] format ">>>>>>>>>>9.99" to i-posicao[5]
            c-sep at i-posicao[7] 0          format ">>>>>>9.99"  to i-posicao[8]
            c-sep at i-posicao[9].
        if  i-op-rel = 2 then 
            put c-sep at i-posicao[1]
                c-sep at i-posicao[2].
        put skip.
    end.
    assign c-obs-total = c-linha-branco
           i-inicio    = 14.

    overlay(c-obs-total,2) = "Observacao:".

    if  de-aux[11] > 0 then do:
        if  c-estado = "MG" then do:
            overlay(c-obs-total,i-inicio) = 
            "DEBITO: " + string(de-aux[11],">,>>>,>>9.99") +
            (if  de-cred-com > 0 
            then ("  CREDITO: " + 
            string(de-cred-com,">,>>>,>>9.99"))
            else "").
            assign i-inicio = 33 + if de-aux[11] > 0 
                   then 24 else 1.
        end.
        else do:
            overlay(c-obs-total,i-inicio) = "Dif.Aliq.ICMS: " +
            string(de-aux[11],">>>>,>>9.99"). 
            assign i-inicio = 42.
        end.
    end.
    if  c-tipo = "TOTAL" 
    and c-importacao <> ""  then 
         overlay(c-obs-total,i-inicio) = 
         substr(c-importacao,1,(if i-op-rel = 1 then 131 else 159) - i-inicio).
    if  i-inicio > 14 then do:
        run pi-verifica-linhas in h-esof0520e (1).
        if  i-op-rel = 1 then
            put c-obs-total at 1 format "x(132)" skip.
        else
            put c-obs-total at 1 format "x(159)" skip.
    end.
end.
else do:
    if i-op-rel = 1 then do:
       run pi-verifica-linhas in h-esof0520e (3).
 
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-icms-2 AS CHARACTER FORMAT "X(4)" NO-UNDO.
       {utp/ut-liter.i "ICMS" *}
       ASSIGN c-lbl-liter-icms-2 = TRIM(RETURN-VALUE).
       put c-desc-tot at 1
           c-lbl-liter-icms-2     at i-posicao[10]
           "1"        at i-posicao[11]
           de-aux[1]  to i-posicao[12] format ">>>>>>>>>>9.99"
           de-aux[2]  to i-posicao[14] format ">>>>>>>>>9.99".
   
       if  de-aux[11] > 0 then
           if  c-estado = "MG" 
           then /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-debito AS CHARACTER FORMAT "X(8)" NO-UNDO.
     {utp/ut-liter.i "DEBITO" *}
     ASSIGN c-lbl-liter-debito = TRIM(RETURN-VALUE).
     put c-lbl-liter-debito       at i-posicao[15].
 END. 
           else 
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-difaliq AS CHARACTER FORMAT "X(10)" NO-UNDO.
                {utp/ut-liter.i "Dif.Aliq" *}
                ASSIGN c-lbl-liter-difaliq = TRIM(RETURN-VALUE).
                put c-lbl-liter-difaliq at i-posicao[15].
                END. 
   
       put skip
           "2"       at i-posicao[11]
           de-aux[3] to i-posicao[12] format ">>>>>>>>>>9.99"
           0         to i-posicao[14] format ">>>>>>>>>9.99".
  
       if  de-aux[11] > 0 then
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-icms-3 AS CHARACTER FORMAT "X(4)" NO-UNDO.
           {utp/ut-liter.i "ICMS" *}
           ASSIGN c-lbl-liter-icms-3 = TRIM(RETURN-VALUE).
           put c-lbl-liter-icms-3 at i-posicao[15].
           END. 

       put skip
           "3"       at i-posicao[11]
           de-aux[4] to i-posicao[12] format ">>>>>>>>>>9.99"
           0         to i-posicao[14] format ">>>>>>>>>9.99". 
       
       if  de-cred-com  > 0 then   
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-credito AS CHARACTER FORMAT "X(9)" NO-UNDO.
           {utp/ut-liter.i "CREDITO" *}
           ASSIGN c-lbl-liter-credito = TRIM(RETURN-VALUE).
           put c-lbl-liter-credito at i-posicao[13].
           END. 
       ELSE if  de-aux[11] > 0 then
           PUT de-aux[11] format ">>>>>>>>9.99" at i-posicao[15].

       put skip.
       
       run pi-verifica-linhas in h-esof0520e(3).
    
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-ipi-2 AS CHARACTER FORMAT "X(3)" NO-UNDO.
       {utp/ut-liter.i "IPI" *}
       ASSIGN c-lbl-liter-ipi-2 = TRIM(RETURN-VALUE).
       put c-lbl-liter-ipi-2      at i-posicao[10]
            "1"       at i-posicao[11]
            de-aux[7] to i-posicao[12] format ">>>>>>>>>>9.99"
            de-aux[8] to i-posicao[14] format ">>>>>>>>>9.99".

       if  de-cred-com > 0 then   
           put "("          at i-posicao[15]
               de-cred-com  format ">>>>,>>9.99"
               ")".
       put skip
           "2"        at i-posicao[11]
            de-aux[9] to i-posicao[12] format ">>>>>>>>>>9.99"
            0         to i-posicao[14] format ">>>>>>>>>9.99" .

       if  c-tipo = "TOTAL" then
           put substr(c-importacao,1,13) at i-posicao[15] format "x(12)".

       put  skip
            "3"        at i-posicao[11]
            de-aux[10] to i-posicao[12] format ">>>>>>>>>>9.99"
            0          to i-posicao[14] format ">>>>>>>>>9.99".
         
       if  c-tipo = "TOTAL" then 
           put substr(c-importacao,14,13) format "x(12)" at i-posicao[14].

       put skip.
       run pi-verifica-linhas in h-esof0520e (1).
       put  "ST"      at i-posicao[10]
            de-aux[5] to i-posicao[12] format ">>>>>>>>>>9.99"
            de-aux[6] to i-posicao[14] format ">>>>>>>>>9.99".
      
       if  c-tipo = "TOTAL" then    
           put substr(c-importacao,28,13) format "x(13)" at i-posicao[13].
   
       put skip.

       if  c-tipo = "TOTAL"
       and substr(c-importacao,42,13) <> " " then
           put substr(c-importacao,42,13) format "x(13)" at i-posicao[13] skip.
 
       if  c-tipo = "TOTAL"
       and substr(c-importacao,56,13) <> " " then
           put substr(c-importacao,56,13) format "x(13)"  at i-posicao[13] skip.
   
       if (c-estado = "MG"
       or c-estado = "PE") and de-aux[12] > 0 then do:
           run pi-verifica-linhas in h-esof0520e(1).
    
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-obs-2 AS CHARACTER FORMAT "X(5)" NO-UNDO.
           {utp/ut-liter.i "OBS" *}
           ASSIGN c-lbl-liter-obs-2 = TRIM(RETURN-VALUE).
           put  c-lbl-liter-obs-2      at 83
                de-aux[12] to 101 format ">>>>>>>>>>9.99"
                0          to 120 format ">>>>>>>>>9.99" skip.
       end.
    end.

    else do:
       run pi-verifica-linhas in h-esof0520e (3).
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-icms-4 AS CHARACTER FORMAT "X(6)" NO-UNDO.
       {utp/ut-liter.i "ICMS" *}
       ASSIGN c-lbl-liter-icms-4 = TRIM(RETURN-VALUE).
       put c-desc-tot at 1
           c-lbl-liter-icms-4     at i-posicao[3]
           "1"        at i-posicao[4]
           de-aux[1]  to i-posicao[5] format ">>>>,>>>,>>9.99"
           de-aux[2]  to i-posicao[6] format ">>>,>>>,>>9.99"
           de-aux[5]  to i-posicao[7] format ">>,>>>,>>9.99"
           de-aux[6]  to i-posicao[8] format ">>>,>>9.99".
   
       if  de-aux[11] > 0 then
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-difaliqicms AS CHARACTER FORMAT "X(16)" NO-UNDO.
           {utp/ut-liter.i "Dif.Aliq.ICMS" *}
           ASSIGN c-lbl-liter-difaliqicms = TRIM(RETURN-VALUE).
           put c-lbl-liter-difaliqicms + "=" at i-posicao[9]  skip.
           END. 
   
       put "2"        at i-posicao[4]
           de-aux[3]  to i-posicao[5] format ">>>>,>>>,>>9.99"
           0          to i-posicao[6] format ">>>,>>>,>>9.99".
       if  de-aux[11] > 0 then
           put "("        at i-posicao[9]
               de-aux[11] format ">>>>>>,>>9.99"
               ")".

       put skip
           "3"       at i-posicao[4]
           de-aux[4] to i-posicao[5] format ">>>>,>>>,>>9.99"
           0         to i-posicao[6] format ">>>,>>>,>>9.99" skip.
       run pi-verifica-linhas in h-esof0520e(3).
    
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-ipi-3 AS CHARACTER FORMAT "X(3)" NO-UNDO.
       {utp/ut-liter.i "IPI" *}
       ASSIGN c-lbl-liter-ipi-3 = TRIM(RETURN-VALUE).
       put c-lbl-liter-ipi-3       at i-posicao[3]
           "1"         at i-posicao[4]
            de-aux[7]  to i-posicao[5] format ">>>>,>>>,>>9.99"
            de-aux[8]  to i-posicao[6] format ">>>,>>>,>>9.99" skip
            "2"        at i-posicao[4]
            de-aux[9]  to i-posicao[5] format ">>>>,>>>,>>9.99"
            0          to i-posicao[6] format ">>>,>>>,>>9.99" skip
            "3"        at i-posicao[4]
            de-aux[10] to i-posicao[5] format ">>>>,>>>,>>9.99"
            0          to i-posicao[6] format ">>>,>>>,>>9.99" skip.
       
       if (c-estado = "MG"
       or c-estado = "PE") and de-aux[12] > 0 then do:
          run pi-verifica-linhas in h-esof0520e(1).
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-obs-3 AS CHARACTER FORMAT "X(5)" NO-UNDO.
          {utp/ut-liter.i "OBS" *}
          ASSIGN c-lbl-liter-obs-3 = TRIM(RETURN-VALUE).
          put c-lbl-liter-obs-3      at i-posicao[3]   
              de-aux[12] to i-posicao[5] format ">>>>,>>>,>>9.99" skip.
       end.
    end.
end.
if  c-tipo <> "TOTAL" then do:
    run pi-verifica-linhas in h-esof0520e (1).
    if  not l-nova-pagina then
        if  i-op-rel = 1 then
            put c-linha-branco at 1 format "x(132)" skip.
        else 
            put c-linha-branco at 1 format "x(159)" skip.
end.
assign de-aux = 0. /* nao retirar esta linha de comando */


/* Fim do programa esof0520C.p  */


