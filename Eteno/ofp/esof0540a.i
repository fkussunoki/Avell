/*************************************************************************
**
** Programa: esof0540A.I
** Data    : Outubro de 1996
** Autor   : DATASUL S.A.
** Objetivo:
** Gera tt-tab-ocor de CFOP :
**           MENSAL : se parametro{1} = " ".
**           PERIODO: se parametro{1} = "RES ANT".
**
**************************************************************************/
{cdp/cd0620.i1 "' '"}

def var de-aux    as dec EXTENT 12       NO-UNDO.
def var de-tot    as dec extent  3       NO-UNDO.
def var de-aux-1  as dec extent 12       NO-UNDO.
def var de-aux-2  as dec extent 12       NO-UNDO.
def var l-achou   as logical             NO-UNDO.
def var c-des-nat as char format "x(56)" NO-UNDO.

assign de-aux   = 0
       de-tot   = 0
       de-aux-1 = 0
       de-aux-2 = 0
       i-aux  = if i-op-rel = 1 
                then 1
                else 2.

/* i-aux serve para controle de view de frame-top de cfop normal (1)  ou expandido (2). */
/* Este find Ç necess†rio para que n∆o ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */
if  no then
    for first natur-oper fields() no-lock.
    end.

for each tt-tab-ocor where
         tt-tab-ocor.cod-tab    = 249
     and tt-tab-ocor.l-campo[1] =  yes
     and tt-tab-ocor.c-campo[2] = c-usuario
     and tt-tab-ocor.c-campo[3] <> {1}
     and tt-tab-ocor.c-campo[3] <> "RESUMO" no-lock
      break by substring(tt-tab-ocor.c-campo[1],1,1)
            by tt-tab-ocor.c-campo[1]
            by tt-tab-ocor.c-campo[5]:

    assign de-tot[1]  = de-tot[1]  + decimal(tt-tab-ocor.descricao)
           de-tot[2]  = de-tot[2]  + decimal(tt-tab-ocor.descricao)
           de-tot[3]  = de-tot[3]  + decimal(tt-tab-ocor.descricao)
           de-aux[1]  = de-aux[1]  + tt-tab-ocor.de-campo[1]
           de-aux[2]  = de-aux[2]  + tt-tab-ocor.de-campo[2]
           de-aux[3]  = de-aux[3]  + tt-tab-ocor.de-campo[3]
           de-aux[4]  = de-aux[4]  + tt-tab-ocor.de-campo[4]
           de-aux[5]  = de-aux[5]  + tt-tab-ocor.de-campo[5]
           l-achou = yes.
    
    {cdp/cd0620.i1 tt-tab-ocor.cod-estabel}
    {ofp/esof0540g.i "tt-tab-ocor.c-campo[4]"}

    for each b-tt-tab-ocor where
             b-tt-tab-ocor.cod-tab    = 249
         and b-tt-tab-ocor.c-campo[1] = tt-tab-ocor.c-campo[1]
         and b-tt-tab-ocor.c-campo[2] = tt-tab-ocor.c-campo[2]
         and b-tt-tab-ocor.c-campo[3] = tt-tab-ocor.c-campo[3]
         and b-tt-tab-ocor.c-campo[4] = tt-tab-ocor.c-campo[4]
         and b-tt-tab-ocor.c-campo[5] = string(rowid(tt-tab-ocor))
         and b-tt-tab-ocor.l-campo[1] =  no no-lock
          by b-tt-tab-ocor.cod-ocor:

         assign de-aux[6]  = de-aux[6]  + b-tt-tab-ocor.de-campo[1]
                de-aux[7]  = de-aux[7]  + b-tt-tab-ocor.de-campo[2]
                de-aux[8]  = de-aux[8]  + b-tt-tab-ocor.de-campo[3]
                de-aux[9]  = de-aux[9]  + b-tt-tab-ocor.de-campo[4]
                de-aux[10] = de-aux[10] + b-tt-tab-ocor.de-campo[5]
                de-aux[11] = de-aux[11] + decimal(b-tt-tab-ocor.descricao)
                de-aux[12] = de-aux[12] + (b-tt-tab-ocor.i-campo[1] / 100).
    end.

    if  first-of(substring(tt-tab-ocor.c-campo[1],1,1)) then do:
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).

        IF da-est-ini < da-dt-cfop THEN  
            put substring(tt-tab-ocor.c-campo[4],1,1) format "x(1)" at 1
                                                    ".00".
        ELSE
            put substring(tt-tab-ocor.c-campo[4],1,1) format "x(1)" at 1 
                                                         ".000".
        
        case substring(tt-tab-ocor.c-campo[4],1,1):
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
        PUT c-des-nat AT 11.  
    end.

    if last-of(tt-tab-ocor.c-campo[5])  then do:
        IF da-est-ini < da-dt-cfop THEN DO:
             find first natur-oper 
                  where natur-oper.nat-operacao begins substri(tt-tab-ocor.c-campo[4],1,i-formato-cfop)
                  and   natur-oper.aliquota-icm  = decimal(tt-tab-ocor.c-campo[5]) no-lock no-error.
        
             if  not avail natur-oper then
                 find first natur-oper
                    where natur-oper.nat-operacao BEGINS substr(tt-tab-ocor.c-campo[4],1,i-formato-cfop)
                    no-lock no-error.
             assign c-desc-cfop-nat = natur-oper.denominacao.
        END.
        ELSE DO:
          &IF DEFINED(bf_dis_formato_CFOP) &THEN
              for first cfop-natur 
                  where cfop-natur.cod-cfop = replace(c-cfop,".","") no-lock:
                  assign c-desc-cfop-nat = cfop-natur.des-cfop. 
              end.
          &ELSE
              for first ped-curva use-index ch-vlitem
                  where ped-curva.it-codigo = replace(c-cfop,".","")
                  and   ped-curva.vl-aberto = 620 no-lock:
                  assign c-desc-cfop-nat = ped-curva.nome.
              end.
          &ENDIF
        END.

        run pi-verifica-linhas in h-esof0540e  (line-counter,1,c-localiz).
        put skip(1).
        run pi-verifica-linhas in h-esof0540e  (line-counter,3,c-localiz).
        put  c-cfop at 2.
        PUT c-desc-cfop-nat FORMAT "x(30)" AT 11. 
        put de-tot[1]          format ">>>>>>>>>>,>>9.99" at 41.
        
        {ofp/esof0540.i4 "de-tot[1]" "de-aux" "1" "7"}      /* display de totais */
        assign de-aux-1[1]  = de-aux-1[1]  + de-aux[1]
               de-aux-1[2]  = de-aux-1[2]  + de-aux[2]
               de-aux-1[3]  = de-aux-1[3]  + de-aux[3]
               de-aux-1[4]  = de-aux-1[4]  + de-aux[4]
               de-aux-1[5]  = de-aux-1[5]  + de-aux[5]
               de-aux-1[6]  = de-aux-1[6]  + de-aux[6]
               de-aux-1[7]  = de-aux-1[7]  + de-aux[7]
               de-aux-1[8]  = de-aux-1[8]  + de-aux[8]
               de-aux-1[9]  = de-aux-1[9]  + de-aux[9]
               de-aux-1[10] = de-aux-1[10] + de-aux[10]
               de-aux-1[11] = de-aux-1[11] + de-aux[11]
               de-aux-1[12] = de-aux-1[12] + de-aux[12]
               de-aux       = 0
               de-tot[1]    = 0.
    end.

    if  last-of(substring(tt-tab-ocor.c-campo[1],1,1)) then do:
        run pi-verifica-linhas in h-esof0540e  (line-counter,1,c-localiz).
        put skip(1).
        run pi-verifica-linhas in h-esof0540e  (line-counter,3,c-localiz).

        IF da-est-ini < da-dt-cfop THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-s-u-b-t-o-t-a-l AS CHARACTER FORMAT "X(20)" NO-UNDO.
            {utp/ut-liter.i "S_U_B_T_O_T_A_L" *}
            ASSIGN c-lbl-liter-s-u-b-t-o-t-a-l = TRIM(RETURN-VALUE).
            put c-lbl-liter-s-u-b-t-o-t-a-l + " - "                   at 8
                substring(tt-tab-ocor.c-campo[1],1,1) format "x(1)" at 26
                ".00  -   "
                de-tot[2]             format ">>>>>>>>>>,>>9.99" at 41.
        END. 
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-s-u-b-t-o-t-a-l-2 AS CHARACTER FORMAT "X(20)" NO-UNDO.
            {utp/ut-liter.i "S_U_B_T_O_T_A_L" *}
            ASSIGN c-lbl-liter-s-u-b-t-o-t-a-l-2 = TRIM(RETURN-VALUE).
            put c-lbl-liter-s-u-b-t-o-t-a-l-2 + " - "                   at 8
                substring(tt-tab-ocor.c-campo[1],1,1) format "x(1)" at 26
                ".000  -   "
                de-tot[2]             format ">>>>>>>>>>,>>9.99" at 41.
        END. 

        {ofp/esof0540.i4 "de-tot[2]" "de-aux-1" "2" "8"}
        /* se o parametro 3 diferente de 1 entao e' um total  */
        assign de-tot[2]  = 0
               de-aux-2[1]  = de-aux-2[1]  + de-aux-1[1]
               de-aux-2[2]  = de-aux-2[2]  + de-aux-1[2]
               de-aux-2[3]  = de-aux-2[3]  + de-aux-1[3]
               de-aux-2[4]  = de-aux-2[4]  + de-aux-1[4]
               de-aux-2[5]  = de-aux-2[5]  + de-aux-1[5]
               de-aux-2[6]  = de-aux-2[6]  + de-aux-1[6]
               de-aux-2[7]  = de-aux-2[7]  + de-aux-1[7]
               de-aux-2[8]  = de-aux-2[8]  + de-aux-1[8]
               de-aux-2[9]  = de-aux-2[9]  + de-aux-1[9]
               de-aux-2[10] = de-aux-2[10] + de-aux-1[10]
               de-aux-2[11] = de-aux-2[11] + de-aux-1[11]
               de-aux-2[12] = de-aux-2[12] + de-aux-1[12]
               de-aux-1  = 0.
    END.

    if  last(substring(tt-tab-ocor.c-campo[1],1,1)) then do:
        run pi-verifica-linhas in h-esof0540e  (line-counter,1,c-localiz).
        put skip(1).
        run pi-verifica-linhas in h-esof0540e  (line-counter,3,c-localiz).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-t-o-t-a-l-g-e-r-a-l AS CHARACTER FORMAT "X(22)" NO-UNDO.
        {utp/ut-liter.i "T_O_T_A_L__G_E_R_A_L" *}
        ASSIGN c-lbl-liter-t-o-t-a-l-g-e-r-a-l = TRIM(RETURN-VALUE).
        put skip c-lbl-liter-t-o-t-a-l-g-e-r-a-l  at 8
            de-tot[3]         format ">>>>>>>>>>>,>>9.99" at 40.
        {ofp/esof0540.i4 "de-tot[3]" "de-aux-2" "2" "9"}
           /*  parametro 1 = valor contabil
               parametro 2 = valores de icms, ipi e st
               se o parametro 3 diferente de 1 entao e' um total */

        assign de-tot[3] = 0
               de-aux-2  = 0.
            PUT SKIP.
    END.
END.

if  not l-achou then
    assign i-num-pag = i-num-pag - 1.

/* fim include esof0540A.I */
