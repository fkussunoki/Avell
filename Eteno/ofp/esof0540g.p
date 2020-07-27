/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540G 2.00.00.020 } /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0540g MOF}
&ENDIF


/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540G.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas - Impressao do demonstrativo por estados
**
******************************************************************************/

def shared var l-documentos  AS logical   format "Icms Substituto/Todos Documentos" NO-UNDO.
def shared var i-op-rel      AS integer   initial 1                                 NO-UNDO.
def shared var l-imp-for     AS logical   format "Sim/Nao"                          NO-UNDO.
def shared var c-desc-tot    AS character format "x(62)"                            NO-UNDO.
def shared var l-imp-ins     AS logical   format "Sim/Nao"                          NO-UNDO.
def var c-char-aux           AS CHARACTER                                           NO-UNDO.
def shared var h-esof0540e     AS handle                                              NO-UNDO.

{ofp/esof0540.i shared}

def var de-tot       AS dec extent 6           NO-UNDO.
def var de-aux       AS dec extent 6           NO-UNDO.
def var l-achou      AS logical                NO-UNDO.
def var l-imp-estado AS logical                NO-UNDO.
def var c-no-estado  LIKE unid-feder.no-estado NO-UNDO.

assign de-aux   = 0
       de-tot   = 0
       i-aux    = if i-op-rel = 1
                  then 1
                  else 2.

 /* i-aux serve para controle de view de frame-top de cfop normal (1)  ou
          expandido (2). */
if i-op-rel = 1 then do:
    hide frame f-cab-res.
    run pi-verifica-linhas in h-esof0540e (line-counter,page-size,c-localiz).
end.
else if i-op-rel = 2 then do:
    hide frame f-res-sub.
    run pi-verifica-linhas in h-esof0540e (line-counter,page-size,c-localiz).
end.

for each tt-tab-ocor where
         tt-tab-ocor.cod-tab    = 249
     and tt-tab-ocor.c-campo[2] = c-usuario
     and tt-tab-ocor.c-campo[3] = "RESUMO" no-lock
     break by tt-tab-ocor.c-campo[1]:  /* estado */

     assign de-aux[1]    = de-aux[1]  + tt-tab-ocor.de-campo[1]
            de-aux[2]    = de-aux[2]  + tt-tab-ocor.de-campo[2]
            de-aux[3]    = de-aux[3]  + tt-tab-ocor.de-campo[3]
            de-aux[4]    = de-aux[4]  + tt-tab-ocor.de-campo[4]
            de-aux[5]    = de-aux[5]  + tt-tab-ocor.de-campo[5]
            de-aux[6]    = de-aux[6]  + decimal(tt-tab-ocor.descricao)
            de-tot[1]    = de-tot[1]  + tt-tab-ocor.de-campo[1]
            de-tot[2]    = de-tot[2]  + tt-tab-ocor.de-campo[2]
            de-tot[3]    = de-tot[3]  + tt-tab-ocor.de-campo[3]
            de-tot[4]    = de-tot[4]  + tt-tab-ocor.de-campo[4]
            de-tot[5]    = de-tot[5]  + tt-tab-ocor.de-campo[5]
            de-tot[6]    = de-tot[6]  + decimal(tt-tab-ocor.descricao)
            l-achou      = yes
            l-imp-estado = no
            c-no-estado  = "". 

    if last-of(tt-tab-ocor.c-campo[1])  then do:
       find first unid-feder no-lock
            where unid-feder.estado = tt-tab-ocor.c-campo[1]
            and   unid-feder.pais   = "Brasil" no-error.
       run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
       put skip(1).
       run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
       if  avail unid-feder then
           assign c-no-estado = unid-feder.no-estado.

       /* todos os documentos sem substituicao tributaria */
       if  not l-documentos then do:
           if  de-aux[6] > 0
           or  de-aux[4] > 0 
           or  de-aux[5] > 0 then do:
               /* estado */
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(6)" NO-UNDO.
               {utp/ut-liter.i "ICMS" *}
               ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
               put tt-tab-ocor.c-campo[1]                         at 1
                   c-no-estado 
               /* valor contabil */
                   de-aux[6]  format ">>>>>>>>>>,>>9.99"       at 41
                   c-lbl-liter-icms                                      at 65 
                   format "x(4)"
               /* valor base icms */
                   de-aux[4]  format ">>>>>>>,>>>,>>9.99"      at 70
               /* icms outras */
                   de-aux[5]  format ">>>>>>>,>>>,>>9.99"      at 115.
               assign l-imp-estado = yes.
           end.
       end.
       run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
       
       /* documentos com substituicao tributaria */ 
       if  de-aux[1] > 0
       or  de-aux[2] > 0 
       or  de-aux[3] > 0 then do:
           if  not l-imp-estado then do:
               /* estado */
               put tt-tab-ocor.c-campo[1]                at 1
                   c-no-estado.
           end.
           if  l-documentos then
               /* valor contabil */
               put de-aux[6]  format ">>>>>>>>>>,>>9.99" at 41.
            put if l-documentos then "" else "ST"        at 65
                   format "x(4)" 
               /* valor base icms substituto */ 
               de-aux[1]  format ">>>>>>>,>>>,>>9.99"    at 70
           /* icms substituto */
               de-aux[2]  format ">>>>>>>,>>>,>>9.99"    at 95
           /* icms outras para icms substituto */
               de-aux[3]  format ">>>>>>>,>>>,>>9.99"    at 115.
        end.
        assign de-aux = 0.
        run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
    end.

    if  last(tt-tab-ocor.c-campo[1]) then do:
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
        put skip(1).
        run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-t-o-t-a-l-g-e-r-a-l AS CHARACTER FORMAT "X(22)" NO-UNDO.
        {utp/ut-liter.i "T_O_T_A_L__G_E_R_A_L" *}
        ASSIGN c-lbl-liter-t-o-t-a-l-g-e-r-a-l = TRIM(RETURN-VALUE).
        put skip c-lbl-liter-t-o-t-a-l-g-e-r-a-l  at 8.
        /* todos os documentos sem substituicao tributaria */

        if  not l-documentos then do:
                /* valor contabil */
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-icms-2 AS CHARACTER FORMAT "X(6)" NO-UNDO.
            {utp/ut-liter.i "ICMS" *}
            ASSIGN c-lbl-liter-icms-2 = TRIM(RETURN-VALUE).
            put de-tot[6]    format ">>>>>>>>>>>,>>9.99"    at 40
                c-lbl-liter-icms-2                          at 65
                             format "x(4)" 
               /* valor base icms */
                de-tot[4]    format ">>>>>>>,>>>,>>9.99"    at 70
               /* icms outras */
                de-tot[5]    format ">>>>>>>,>>>,>>9.99"    at 115.
        end.
        run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
        
        /* documentos com substituicao tributaria */ 
        if  l-documentos then
           /* valor contabil */
            put de-tot[6]    format ">>>>>>>>>>>,>>9.99"      at 40.
        put if l-documentos then "" else "ST"             at 65
                format "x(4)"
           /* valor base icms substituto */ 
            de-tot[1]  format ">>>>>>>,>>>,>>9.99"      at 70
           /* icms substituto */
            de-tot[2]  format ">>>>>>>,>>>,>>9.99"      at 95
           /* icms outras */
            de-tot[3]  format ">>>>>>>,>>>,>>9.99"      at 115.
        run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
    end.
end.

if  not l-achou then
    assign i-num-pag = i-num-pag - 1.

