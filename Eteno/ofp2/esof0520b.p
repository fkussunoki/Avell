/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520B 2.00.00.031 } /*** 010031 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520b MOF}
&ENDIF



/******************************************************************************
**
**  Programa: esof0520B.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - Impressao do demonstrativo por estados
**
******************************************************************************/
{ofp/esof0520.i shared}

def var c-char-aux       as character.
def var de-tot           as dec extent 5.
def var l-achou          as logical                no-undo.
def var l-imp-estado     as logical                no-undo.
def var c-no-estado      like unid-feder.no-estado no-undo.
def var da-temp          as date                   no-undo.
def shared var h-esof0520e as handle                 no-undo.
def var i-aux            as int                    no-undo.

assign i-nivel        = 3
       c-linha-branco = ""
       da-temp        = da-est-ini
       da-est-ini     = da-temp - day(da-temp) + 1.

if  l-separadores then do:
    if  l-documentos then
        assign c-linha-branco = c-sep + 
               fill(" ",(if i-op-rel = 1 then 61 else 89)) + c-sep +
               fill(" ",16). 
    else
        assign c-linha-branco = c-sep + 
               fill(" ",(if i-op-rel = 1 then 56 else 84)) + c-sep +
               fill(" ",16) + c-sep + fill(" ",4).
    assign c-linha-branco = c-linha-branco + c-sep + fill(" ",16) +
           c-sep + fill(" ",16) + c-sep + fill(" ",17) + c-sep.
end.    

hide all no-pause.

if  l-separadores then do:
    if  i-op-rel = 1 then do: 
        view frame f-cab-diag.
        view frame f-bottom.
    end.
    else do: 
        view frame f-cab-diag-e.
        view frame f-bottom-e.
    end. 
    if  l-documentos then do:
        if  i-op-rel = 1 then 
            view frame f-scab-uf.
        else 
            view frame f-scab-uf-e.
    end.
    else do:
        if  i-op-rel = 1 then
            view frame f-scab-uf2.
        else
            view frame f-scab-uf2-e.
    end.
end.
else do:
    if  i-op-rel = 1 then
        view frame f-cab.
    else
        view frame f-cab-exp.
    if  l-documentos then do:
        if  i-op-rel = 1 then
            view frame f-cab-uf2.
        else 
            view frame f-res-uf2.
    end.
    else do:
        if  i-op-rel = 1 then 
            view frame f-cab-uf.
        else
            view frame f-res-uf.
    end.
end.

for each tt-tab-ocor use-index codigo  
    where tt-tab-ocor.cod-tab  = 249
    and tt-tab-ocor.c-campo1 = c-usuario
    and not tt-tab-ocor.l-campo1 /* resumo por uf */ no-lock
    break by tt-tab-ocor.c-campo2:  /* estado */
    assign de-aux[1]  = de-aux[1]  + tt-tab-ocor.de-campo1
           de-aux[2]  = de-aux[2]  + tt-tab-ocor.de-campo2
           de-aux[3]  = de-aux[3]  + tt-tab-ocor.de-campo3
           de-aux[4]  = de-aux[4]  + tt-tab-ocor.de-campo4
           de-aux[5]  = de-aux[5]  + tt-tab-ocor.de-campo5

           de-tot[1]  = de-tot[1]  + tt-tab-ocor.de-campo1
           de-tot[2]  = de-tot[2]  + tt-tab-ocor.de-campo2
           de-tot[3]  = de-tot[3]  + tt-tab-ocor.de-campo3
           de-tot[4]  = de-tot[4]  + tt-tab-ocor.de-campo4
           de-tot[5]  = de-tot[5]  + tt-tab-ocor.de-campo5.
    if  last-of(tt-tab-ocor.c-campo2) then do:
        for first unid-feder fields ( no-estado ) 
             where unid-feder.estado = tt-tab-ocor.c-campo2
             and   unid-feder.pais   = "Brasil" no-lock.
        end.
        
        run pi-verifica-linhas in h-esof0520e(1). 
        if  l-separadores then do:
            put c-sep at 1
                tt-tab-ocor.c-campo2 format "xx"
                if  avail unid-feder then unid-feder.no-estado else "" 
                format "x(20)" at 6.
             if  l-documentos then do:
                put c-sep at (if i-op-rel = 1 then 63 else 91)
                    de-aux[1]  format ">,>>>,>>>,>>9.99" c-sep
                    de-aux[2]  format ">,>>>,>>>,>>9.99" c-sep
                    de-aux[3]  format ">,>>>,>>>,>>9.99" c-sep
                    de-aux[5]  format ">,>>>,>>>,>>9.99" c-sep skip.
            end.
            else do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(4)" NO-UNDO.
                {utp/ut-liter.i "ICMS" *}
                ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
                put c-sep at (if i-op-rel = 1 then 58 else 86)
                    de-aux[1]  format ">,>>>,>>>,>>9.99" c-sep
                    c-lbl-liter-icms c-sep  
                    de-aux[4]  format ">,>>>,>>>,>>9.99" c-sep
                    fill(" ",16) format "x(16)" c-sep
                    de-aux[5]  format ">,>>>,>>>,>>9.99" to 131 c-sep skip.
                if  (de-aux[2] > 0 or de-aux[3] > 0) then do:
                    run pi-verifica-linhas in h-esof0520e (1).  
                    put c-sep at 1 
                        c-sep at (if i-op-rel = 1 then 58 else 86)
                        fill(" ",16) format "x(16)" c-sep
                        "ST  " c-sep  
                        de-aux[2]  format ">,>>>,>>>,>>9.99" c-sep
                        de-aux[3]  format ">,>>>,>>>,>>9.99" c-sep
                        fill(" ",17) format "x(17)" c-sep skip.
                end.
            end.
        end.
        else do:
            put tt-tab-ocor.c-campo2 at 1 format "xx"
                if  avail unid-feder then unid-feder.no-estado else "" 
                format "x(20)" at 6.
            if  l-documentos then do:
                put de-aux[1]  format ">>,>>>,>>>,>>9.99" at 41 
                    de-aux[2]  format ">>,>>>,>>>,>>9.99" at 70 
                    de-aux[3]  format ">>,>>>,>>>,>>9.99" at 95
                    de-aux[5]  format ">>,>>>,>>>,>>9.99" at 115 skip. 
            end.
            else do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-icms-2 AS CHARACTER FORMAT "X(4)" NO-UNDO.
                {utp/ut-liter.i "ICMS" *}
                ASSIGN c-lbl-liter-icms-2 = TRIM(RETURN-VALUE).
                put de-aux[1]  format ">>,>>>,>>>,>>9.99" at 41 
                    c-lbl-liter-icms-2                                at 65
                    de-aux[4]  format ">>,>>>,>>>,>>9.99" at 70 
                    de-aux[5]  format ">>,>>>,>>>,>>9.99" at 115 skip.
                if  (de-aux[2] > 0 or de-aux[3] > 0) then    
                    put "ST  "                                at 65
                        de-aux[2]  format ">>,>>>,>>>,>>9.99" at 70 
                        de-aux[3]  format ">>,>>>,>>>,>>9.99" at 95 skip.
            end.
        end.
        run pi-verifica-linhas in h-esof0520e (1).
        if  not l-nova-pagina then
            if  i-op-rel = 1 then 
                put c-linha-branco at 1 format "x(132)" skip.
            else
                put c-linha-branco at 1 format "x(159)" skip.
        assign de-aux   = 0.
    end.
end.
run pi-verifica-linhas in h-esof0520e(1).
if  l-separadores then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-t-o-t-a-l-g-e-r-a-l AS CHARACTER FORMAT "X(22)" NO-UNDO.
    {utp/ut-liter.i "T_O_T_A_L__G_E_R_A_L" *}
    ASSIGN c-lbl-liter-t-o-t-a-l-g-e-r-a-l = TRIM(RETURN-VALUE).
    put c-sep at 1 c-lbl-liter-t-o-t-a-l-g-e-r-a-l.
    if  l-documentos then do:
        put c-sep at (if i-op-rel = 1 then 63 else 91)
            de-tot[1]  format ">,>>>,>>>,>>9.99" c-sep
            de-tot[2]  format ">,>>>,>>>,>>9.99" c-sep
            de-tot[3]  format ">,>>>,>>>,>>9.99" c-sep
            de-tot[5]  format ">,>>>,>>>,>>9.99" c-sep skip.
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms-3 AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms-3 = TRIM(RETURN-VALUE).
        put c-sep at (if i-op-rel = 1 then 58 else 86)
            de-tot[1]  format ">,>>>,>>>,>>9.99" c-sep
            c-lbl-liter-icms-3 c-sep  
            de-tot[4]  format ">,>>>,>>>,>>9.99" c-sep
            fill(" ",16) format "x(16)" c-sep
            de-tot[5]  format ">,>>>,>>>,>>9.99" to 131 c-sep skip.
        run pi-verifica-linhas in h-esof0520e (1).
        put c-sep at 1 
            c-sep at (if i-op-rel = 1 then 58 else 86)
            fill(" ",16) format "x(16)" c-sep 
            "ST  " c-sep  
            de-tot[2]  format ">,>>>,>>>,>>9.99" c-sep
            de-tot[3]  format ">,>>>,>>>,>>9.99" c-sep
            fill(" ",17) format "x(17)" c-sep skip.
    end.
end.
else do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-t-o-t-a-l-g-e-r-a-l-2 AS CHARACTER FORMAT "X(22)" NO-UNDO.
    {utp/ut-liter.i "T_O_T_A_L__G_E_R_A_L" *}
    ASSIGN c-lbl-liter-t-o-t-a-l-g-e-r-a-l-2 = TRIM(RETURN-VALUE).
    put c-lbl-liter-t-o-t-a-l-g-e-r-a-l-2 at 8.            
    if  l-documentos then do:
        put de-tot[1]  format ">>,>>>,>>>,>>9.99" at 41 
            de-tot[2]  format ">>,>>>,>>>,>>9.99" at 70 
            de-tot[3]  format ">>,>>>,>>>,>>9.99" at 95
            de-tot[5]  format ">>,>>>,>>>,>>9.99" at 115 skip. 
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-icms-4 AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms-4 = TRIM(RETURN-VALUE).
        put de-tot[1]  format ">>,>>>,>>>,>>9.99" at 41 
            c-lbl-liter-icms-4                                at 65
            de-tot[4]  format ">>,>>>,>>>,>>9.99" at 70 
            de-tot[5]  format ">>,>>>,>>>,>>9.99" at 115 skip.
        run pi-verifica-linhas in h-esof0520e (1).     
        put "ST  "                                at 65
            de-tot[2]  format ">>,>>>,>>>,>>9.99" at 70 
            de-tot[3]  format ">>,>>>,>>>,>>9.99" at 95 skip.
    end.
end.

do i-aux = line-counter to page-size:
    if  i-op-rel = 1 then 
        put c-linha-branco at 1 format "x(132)" skip.
    else
        put c-linha-branco at 1 format "x(159)" skip. 
end.

page.

assign da-est-ini = da-temp.

/* esof0520B.P */

