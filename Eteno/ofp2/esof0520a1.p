/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520A1 2.00.00.029 } /*** 010029 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520a1 MOF}
&ENDIF


/******************************************************************************
**
**  Programa: esof0520A1.P
**
**  Data....: Março de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - Impressao do Resumo por CFOP do periodo
**
******************************************************************************/

{ofp/esof0520.i shared}

def var c-observacao as character no-undo.
def shared var h-esof0520e as handle no-undo.

if  i-op-rel = 1 then 
    assign i-posicao[1]   = 84
           i-posicao[2]   = 88
           i-posicao[3]   = 91
           i-posicao[4]   = 115
           /* posi‡äes com separadores */
           i-posicao[5]   = 66
           i-posicao[6]   = 71
           i-posicao[7]   = 74
           i-posicao[8]   = 93
           i-posicao[9]   = 99
           i-posicao[10]  = 121.
else
    assign i-posicao[1] = 64
           i-posicao[2] = 66
           i-posicao[3] = 69
           i-posicao[4] = 88
           i-posicao[5] = 93
           i-posicao[6] = 111
           i-posicao[7] = 131
           i-posicao[8] = 154.

if  l-separadores then do:
    if  i-op-rel = 1 then do: 
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
        put c-lbl-liter-icms at i-posicao[1]
            c-sep  at i-posicao[2]
            "1"    to i-posicao[3] c-sep
            de-acum[2] format ">>>>>,>>>,>>9.99" c-sep.

        if  de-aliquota <> ? then
            PUT de-aliquota TO 114 FORMAT IF de-aliquota = 100 THEN ">>9" ELSE ">9.99". /*Aliquota imprime valor 100*/
        
        put c-sep at i-posicao[4] de-acum[3] format ">>>>>,>>>,>>9.99" c-sep skip
            substr(c-linha-branco,1,88) at 1 format "x(88)"
            "2" to i-posicao[3] c-sep 
            de-acum[4] format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[4]
            0       format ">>>>>,>>>,>>9.99" c-sep skip
            substr(c-linha-branco,1,88) at 1 format "x(88)"
            "3" to i-posicao[3] c-sep
            de-acum[5]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[4]
            0       format ">>>>>,>>>,>>9.99" c-sep skip.
        
        run pi-verifica-linhas in h-esof0520e(3).
        
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ipi AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "IPI" *}
        ASSIGN c-lbl-liter-ipi = TRIM(RETURN-VALUE).
        put substr(c-linha-branco,1,83) at 1 format "x(83)"
            c-lbl-liter-ipi at i-posicao[1] c-sep at i-posicao[2]
            "1"   to i-posicao[3] c-sep 
            de-acum[6]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[4]
            de-acum[7]  format ">>>>>,>>>,>>9.99" c-sep skip
            substr(c-linha-branco,1,88) at 1 format "x(88)"
            "2" to i-posicao[3] c-sep
            de-acum[8]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[4]
            0       format ">>>>>,>>>,>>9.99" c-sep skip
            substr(c-linha-branco,1,88) at 1 format "x(88)"
            "3" to i-posicao[3] c-sep
            de-acum[9]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[4]
            0        format ">>>>>,>>>,>>9.99" c-sep skip.
        
        if de-acum[10] > 0 or de-acum[11] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            put substr(c-linha-branco,1,83) at 1 format "x(83)"
                "ST"  at i-posicao[1] c-sep at i-posicao[2]  
                " "   to i-posicao[3] c-sep 
                de-acum[10]  format ">>>>>,>>>,>>9.99" c-sep
                c-sep at i-posicao[4]
                de-acum[11]  format ">>>>>,>>>,>>9.99" c-sep skip.
        end.
        if  de-acum[13] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-obs AS CHARACTER FORMAT "X(5)" NO-UNDO.
            {utp/ut-liter.i "OBS" *}
            ASSIGN c-lbl-liter-obs = TRIM(RETURN-VALUE).
            put substr(c-linha-branco,1,83) at 1 format "x(83)"
                c-lbl-liter-obs at i-posicao[1] c-sep at i-posicao[2]  
                c-sep at i-posicao[3] de-acum[13] format ">>>>>,>>>,>>9.99" c-sep
                c-sep at i-posicao[4]
                0                    format ">>>>>,>>>,>>9.99" c-sep skip.
        end.
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms-2 AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms-2 = TRIM(RETURN-VALUE).
        put c-lbl-liter-icms-2 at i-posicao[1]
            c-sep  at i-posicao[2]
            "1" to i-posicao[3] c-sep
            de-acum[2]  format ">>>>>,>>>,>>9.99" 
            c-sep.

        if  de-aliquota <> ? then                  /*Aliquota imprime valor 100*/
            PUT de-aliquota TO 107 FORMAT IF de-aliquota = 100 THEN ">>9" ELSE ">9.99".
        put c-sep at i-posicao[5] de-acum[3]   format ">>>>>,>>>,>>9.99" c-sep
                                  de-acum[10]  format ">>>>>,>>>,>>9.99" c-sep
                                  de-acum[11]  format ">>>>>,>>>,>>9.99" c-sep skip
            substr(c-linha-branco,1,81) at 1 format "x(81)"
            "2" to i-posicao[3] c-sep
            de-acum[4]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[5]
            0       format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[6]
            c-sep at i-posicao[7] skip 
            substr(c-linha-branco,1,81) at 1 format "x(81)"
            "3" to i-posicao[3] c-sep
            de-acum[5]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[5]
            0           format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[6]
            c-sep at i-posicao[7] skip.  
        run pi-verifica-linhas in h-esof0520e(3).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ipi-2 AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "IPI" *}
        ASSIGN c-lbl-liter-ipi-2 = TRIM(RETURN-VALUE).
        put substr(c-linha-branco,1,76) at 1 format "x(76)"
            c-lbl-liter-ipi-2 at i-posicao[1] c-sep at i-posicao[2]
            "1" to i-posicao[3] c-sep 
            de-acum[6]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[5]
            de-acum[7]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[6]
            c-sep at i-posicao[7] skip 
            substr(c-linha-branco,1,81) at 1 format "x(81)"
            "2" to i-posicao[3] c-sep
            de-acum[8]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[5]
            0       format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[6]
            c-sep at i-posicao[7] skip 
            substr(c-linha-branco,1,81) at 1 format "x(81)"
            "3" to i-posicao[3] c-sep
            de-acum[9]  format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[5]
            0        format ">>>>>,>>>,>>9.99" c-sep
            c-sep at i-posicao[6]
            c-sep at i-posicao[7] skip.  
        if  de-acum[13] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-obs-2 AS CHARACTER FORMAT "X(5)" NO-UNDO.
            {utp/ut-liter.i "OBS" *}
            ASSIGN c-lbl-liter-obs-2 = TRIM(RETURN-VALUE).
            put substr(c-linha-branco,1,76) at 1 format "x(76)"
                c-lbl-liter-obs-2 at i-posicao[1] c-sep at i-posicao[2]  
                c-sep at 85 de-acum[13]  format ">>>>>,>>>,>>9.99" c-sep
                c-sep at i-posicao[5]
                0                    format ">>>>>,>>>,>>9.99" c-sep
                c-sep at i-posicao[6]
                c-sep at i-posicao[7] skip.  
        end.
    end.
    assign c-observacao = c-linha-branco.
    overlay(c-observacao,2) = "Observacao:".
    
    if  de-acum[12] > 0 then do:
        if  c-estado = "MG" then do:
            overlay(c-observacao,14) = 
            "DEBITO: " + string(de-acum[12],">>>>>,>>9.99") +
            (if  de-cred-com > 0 
             then ("  CREDITO: " + 
             string(de-cred-com,">>>>>,>>9.99"))
             else "").
        END.
        else do:
            overlay(c-observacao,14) = "Dif.Aliq.ICMS: " +
            string(de-acum[12],">>>>>,>>9.99"). 
        end.
        run pi-verifica-linhas in h-esof0520e (1).
        if  i-op-rel = 1 then
            put c-observacao at 1 format "x(132)" skip.
        else
            put c-observacao at 1 format "x(159)" skip.
    end.
end.
else do:
    if i-op-rel = 1 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms-3 AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms-3 = TRIM(RETURN-VALUE).
        put c-lbl-liter-icms-3                                  at i-posicao[5]
            "1"                                     at i-posicao[6]
            de-acum[2]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7].
    
        if  de-aliquota <> ? then  /*Aliquota imprime valor 100*/
            PUT de-aliquota AT i-posicao[8] FORMAT IF de-aliquota = 100 THEN ">>9" ELSE ">9.99".
    
        put de-acum[3]  format ">>>>>>>,>>>,>>9.99" at i-posicao[9].
    
        if  de-acum[12] > 0 then
            if c-estado = "MG" then
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-debito AS CHARACTER FORMAT "X(8)" NO-UNDO.
                {utp/ut-liter.i "DEBITO" *}
                ASSIGN c-lbl-liter-debito = TRIM(RETURN-VALUE).
                put c-lbl-liter-debito        at i-posicao[10] skip.
                END.     
            else 
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-difaliq AS CHARACTER FORMAT "X(11)" NO-UNDO.
                {utp/ut-liter.i "Dif.Aliq" *}
                ASSIGN c-lbl-liter-difaliq = TRIM(RETURN-VALUE).
                put c-lbl-liter-difaliq + "." at i-posicao[10] skip.
                END. 
      
        put "2"                                     at i-posicao[6]
            de-acum[4]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
            0           format ">>>>>>>,>>>,>>9.99" at i-posicao[9].
        
        if  de-acum[12] > 0 then
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-icms-4 AS CHARACTER FORMAT "X(4)" NO-UNDO.
            {utp/ut-liter.i "ICMS" *}
            ASSIGN c-lbl-liter-icms-4 = TRIM(RETURN-VALUE).
            put c-lbl-liter-icms-4  at i-posicao[10].
            END. 
    
        put skip
            "3"                                     at i-posicao[6]
            de-acum[5]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
            0       format ">>>>>>>,>>>,>>9.99"     at i-posicao[9].
    
        if  de-cred-com > 0 then
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-credito AS CHARACTER FORMAT "X(9)" NO-UNDO.
            {utp/ut-liter.i "CREDITO" *}
            ASSIGN c-lbl-liter-credito = TRIM(RETURN-VALUE).
            put c-lbl-liter-credito at i-posicao[10].
            END. 
        ELSE
            if  de-acum[12] > 0 then
                put de-acum[12]  format ">>>>>>>>9.99" at i-posicao[10].
        put skip.
    
        run pi-verifica-linhas in h-esof0520e(3).
     
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ipi-3 AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "IPI" *}
        ASSIGN c-lbl-liter-ipi-3 = TRIM(RETURN-VALUE).
        put c-lbl-liter-ipi-3                                   at i-posicao[5]
            "1"                                     at i-posicao[6]
            de-acum[6]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
            de-acum[7]  format ">>>>>>>,>>>,>>9.99" at i-posicao[9].
  
        if  de-cred-com > 0 then
            put "("                                 at 124
                de-cred-com  format ">>>>>,>>9.99"
                ")".

        put skip
            "2"                                     at i-posicao[6]
            de-acum[8]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
            0       format ">>>>>>>,>>>,>>9.99"     at i-posicao[9] skip
            "3"                                     at i-posicao[6]
            de-acum[9] format ">>>>>>>,>>>,>>9.99"  at i-posicao[7]
            0       format ">>>>>>>,>>>,>>9.99"     at i-posicao[9] skip.
        if de-acum[10] > 0 or de-acum[11] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            put "ST"                                     at i-posicao[5]
                de-acum[10]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
                de-acum[11]  format ">>>>>>>,>>>,>>9.99" at i-posicao[9] skip.
        end.
        if de-acum[13] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-obs-3 AS CHARACTER FORMAT "X(5)" NO-UNDO.
            {utp/ut-liter.i "OBS" *}
            ASSIGN c-lbl-liter-obs-3 = TRIM(RETURN-VALUE).
            put c-lbl-liter-obs-3                                   at i-posicao[5]
                de-acum[13] format ">>>>>>>,>>>,>>9.99" at i-posicao[7]
                0       format ">>>>>>>,>>>,>>9.99"     at i-posicao[9] skip.
        end.
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms-5 AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms-5 = TRIM(RETURN-VALUE).
        put c-lbl-liter-icms-5                                  at i-posicao[1]
            "1"                                     at i-posicao[2]
            de-acum[2]  format ">>>>>>>,>>>,>>9.99" at i-posicao[3].
       
        if  de-aliquota <> ? then   /*Aliquota imprime valor 100*/
            PUT de-aliquota AT i-posicao[4] FORMAT IF de-aliquota = 100 THEN ">>9" ELSE ">9.99".
        put de-acum[3]   format ">>>>>>>,>>>,>>9.99" at i-posicao[5]
            de-acum[10]  format ">>>>>>>,>>>,>>9.99" at i-posicao[6]
            de-acum[11]  format ">>>>>>>,>>>,>>9.99" at i-posicao[7].
        
        if  de-acum[12] > 0 then
            if  c-estado = "MG"  then 
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-debito-2 AS CHARACTER FORMAT "X(8)" NO-UNDO.
                {utp/ut-liter.i "DEBITO" *}
                ASSIGN c-lbl-liter-debito-2 = TRIM(RETURN-VALUE).
                put c-lbl-liter-debito-2                        at i-posicao[8] skip.
                END. 
            else 
                 /* Inicio -- Projeto Internacional */
                 DO:
                 DEFINE VARIABLE c-lbl-liter-difaliqicms AS CHARACTER FORMAT "X(16)" NO-UNDO.
                 {utp/ut-liter.i "Dif.Aliq.ICMS" *}
                 ASSIGN c-lbl-liter-difaliqicms = TRIM(RETURN-VALUE).
                 put c-lbl-liter-difaliqicms + "="               at i-posicao[8] skip.
                 END. 
    
        put "2"                                     at i-posicao[2]
            de-acum[4]  format ">>>>>>>,>>>,>>9.99" at i-posicao[3]
            0           format ">>>>>>>,>>>,>>9.99" at i-posicao[5].

        if  de-acum[12] > 0 then
            put "("                                 at i-posicao[8]
                de-acum[12]  format ">>>>>,>>9.99"
                ")".
    
        put skip
            "3"                                     at i-posicao[2]
            de-acum[5]  format ">>>>>>>,>>>,>>9.99" at i-posicao[3]
            0           format ">>>>>>>,>>>,>>9.99" at i-posicao[5].
    
        if  de-cred-com > 0 then
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-credito-2 AS CHARACTER FORMAT "X(9)" NO-UNDO.
            {utp/ut-liter.i "CREDITO" *}
            ASSIGN c-lbl-liter-credito-2 = TRIM(RETURN-VALUE).
            put c-lbl-liter-credito-2                           at i-posicao[8].
            END. 
        
        put skip.
    
        run pi-verifica-linhas in h-esof0520e(3).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ipi-4 AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "IPI" *}
        ASSIGN c-lbl-liter-ipi-4 = TRIM(RETURN-VALUE).
        put c-lbl-liter-ipi-4                                   at i-posicao[1]
            "1"                                     at i-posicao[2]
            de-acum[6]  format ">>>>>>>,>>>,>>9.99" at i-posicao[3]
            de-acum[7]  format ">>>>>>>,>>>,>>9.99" at i-posicao[5].
    
        if  de-cred-com  > 0 then
            put "("                                 at i-posicao[8]
                  de-cred-com format ">>>>>,>>9.99"
                ")".
       
        put skip
            "2"                                     at i-posicao[2]
            de-acum[8]  format ">>>>>>>,>>>,>>9.99" at i-posicao[3]
            0           format ">>>>>>>,>>>,>>9.99" at i-posicao[5] skip
            "3"                                     at i-posicao[2]
            de-acum[9] format ">>>>>>>,>>>,>>9.99"  at i-posicao[3]
            0          format ">>>>>>>,>>>,>>9.99"  at i-posicao[5] skip.
        if de-acum[13] > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-obs-4 AS CHARACTER FORMAT "X(5)" NO-UNDO.
            {utp/ut-liter.i "OBS" *}
            ASSIGN c-lbl-liter-obs-4 = TRIM(RETURN-VALUE).
            put c-lbl-liter-obs-4                                   at i-posicao[1]
                de-acum[13] format ">>>>>>>,>>>,>>9.99" at i-posicao[3]
                0           format ">>>>>>>,>>>,>>9.99" at i-posicao[5] skip.
        end.
    end.
end.
/* fim esof0520a1.p */

