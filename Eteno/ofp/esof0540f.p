/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540F 2.00.00.055 } /*** 010055 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0540f MOF}
&ENDIF

/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540F.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Imprime doc-fiscal
**
******************************************************************************/
{cdp/cdcfgdis.i}

def input parameter r-registro AS ROWID NO-UNDO.
def input parameter da-dt-cfop AS DATE  NO-UNDO.
def buffer b-param-of-cfop for param-of.  

DEF var c-desc-cfop-nat like natur-oper.denominacao NO-UNDO.

if  no then do:
    FIND FIRST b-param-of-cfop NO-LOCK NO-ERROR.
    FIND FIRST natur-oper      NO-LOCK NO-ERROR.
    FIND FIRST param-of        NO-LOCK NO-ERROR.
end.    

DEF SHARED VAR l-imp-dif-aliq AS LOG                                 NO-UNDO.
def shared var l-incentivado  AS logical   format "Sim/Nao"          NO-UNDO. 
def new shared var i-status   AS integer                             NO-UNDO.
def shared var i-op-rel       AS integer   initial 1                 NO-UNDO.
def shared var c-tot-res      AS character format "x(60)"            NO-UNDO.
def shared var c-desc-tot     AS character format "x(62)"            NO-UNDO.
def shared var l-tot-icm      AS logical   format "Sim/Nao"          NO-UNDO.
def shared var l-imp-for      AS logical   format "Sim/Nao" init yes NO-UNDO.
def shared var l-imp-ins      AS logical   format "Sim/Nao"          NO-UNDO.
def shared var da-ini-cab     AS date                                NO-UNDO.
def shared var l-erro-x       AS logical                             NO-UNDO.
def shared var l-esof0540x      AS logical                             NO-UNDO.
def shared var h-acomp        AS handle                              NO-UNDO.
def var i-ver                 AS integer                             NO-UNDO.
def var c-observacao          AS char    extent 10                   NO-UNDO.  
def shared var l-icms-subst   AS logical                             NO-UNDO.
def shared var h-esof0540e      AS handle                              NO-UNDO.

def var i-primeira             AS integer init 1             NO-UNDO.
def var l-subs                 AS logical init no            NO-UNDO.
def shared var de-aux          AS decimal extent 12          NO-UNDO.
def var da-aux                 AS DATE                       NO-UNDO.
def var i-inicio               AS integer init 1             NO-UNDO.
def var l-nome-imp             AS logical init no            NO-UNDO.
def var l-ins-est-imp          AS logical init no            NO-UNDO.
def var de-obs                 AS decimal                    NO-UNDO.
def var de-acum                AS decimal extent 10          NO-UNDO.
def var l-privez               AS logical                    NO-UNDO.
def var l-primeiro             AS logical                    NO-UNDO.
def var c-conta                AS character                  NO-UNDO format "x(20)".
def var i-num-linhas           AS integer                    NO-UNDO.
def var l-imp-nat              AS logical init no            NO-UNDO.
def var c-formato              AS character extent 2         NO-UNDO.
def var i-cod-trib-ipi         AS integer                    NO-UNDO init 1.
DEF VAR c-nr-doc-fis           AS INTEGER FORMAT ">>9999999" NO-UNDO.
DEF VAR l-tem-ipi-1            AS LOG                        NO-UNDO.
DEF VAR l-tem-ipi-2            AS LOG                        NO-UNDO.
DEF VAR l-tem-ipi-3            AS LOG                        NO-UNDO.
DEFINE VARIABLE de-vl-cont-doc AS DECIMAL    INIT 0          NO-UNDO.
/*** vari veis do formato cfop ***/
def var c-formato-cfop         AS character                  NO-UNDO.
def var i-formato-cfop         AS integer                    NO-UNDO.

def temp-table w-conta NO-UNDO
    field cod-tributacao     AS integer format "9"
    field conta-contabil     AS character
    field aliquota-icms      AS decimal.

find doc-fiscal where rowid(doc-fiscal) = r-registro EXCLUSIVE-LOCK no-error.

find FIRST natur-oper NO-LOCK 
    where  natur-oper.nat-operacao = doc-fiscal.nat-operacao no-error.

IF  NOT AVAIL (param-of) 
OR  param-of.cod-estabel <> doc-fiscal.cod-estabel THEN    
    find param-of no-lock
        where param-of.cod-estabel = doc-fiscal.cod-estabel no-error.

{ofp/esof0540.i "shared"}
{ofp/esof0540g.i "doc-fiscal.nat-operacao"}

{cdp/cdcfgdis.i} /* pre-processador */

ASSIGN c-cfop = replace(REPLACE(c-cfop,".",""),"-","").

ASSIGN i-inicio      = 1
       l-prim-txt    = YES           
       l-prim-vlr    = YES 
       i-status      = 0
       i-cod-tri     = 0
       c-obs-total   = IF doc-fiscal.ind-sit-doc = 1 THEN SUBSTRING(doc-fiscal.observacao,1,152) ELSE "Cancelado". 
    
ASSIGN c-obs-total = REPLACE(c-obs-total,chr(10)," ").
   
find first emitente no-lock use-index codigo
    where emitente.cod-emitente = doc-fiscal.cod-emitente no-error.

assign l-subs = doc-fiscal.vl-bsubs > 0 or doc-fiscal.vl-icmsub > 0 
       i-num-linhas = 0. 

{ofp/esof0540f.i1}
run pi-verifica-linhas in h-esof0540e (line-counter,i-num-linhas,c-localiz).

/* grava o nr-lre no movimento ciap */
&if defined(bf_dis_ciap) &then
     {ofp/of0530f.i3}
&endif

ASSIGN  de-vl-ipi      = 0
        de-vl-bipi     = 0
        de-vl-ipint    = 0
        de-vl-ipiou    = 0
        de-vl-bsubs    = 0
        de-vl-icmsub   = 0
        de-vl-cont-doc = 0
        l-tem-ipi-1    = NO
        l-tem-ipi-2    = NO
        l-tem-ipi-3    = NO.

for each it-doc-fisc of doc-fiscal NO-LOCK
    where (c-estado <> "PE" /* para estados <> "PE" considerar todos os itens */ 
           or can-find(item 
                       where item.it-codigo = it-doc-fisc.it-codigo
                       and  item.incentivado = l-incentivado)) 
    break by it-doc-fisc.it-codigo
          by it-doc-fisc.nr-seq-doc:

    ASSIGN  de-vl-ipi      = de-vl-ipi      + it-doc-fisc.vl-ipi-it
            de-vl-bipi     = de-vl-bipi     + it-doc-fisc.vl-bipi-it
            de-vl-ipint    = de-vl-ipint    + (IF  doc-fiscal.tipo-nat = 3
                                               AND AVAIL natur-oper 
                                               AND natur-oper.usa-pick 
                                               AND natur-oper.cd-trib-ipi = 2
                                               THEN it-doc-fisc.vl-tot-item 
                                               ELSE IF  doc-fiscal.tipo-nat <> 3
                                                        THEN it-doc-fisc.vl-ipint-it
                                                        ELSE 0)
            de-vl-ipiou    = de-vl-ipiou    + (IF  doc-fiscal.tipo-nat = 3
                                               AND AVAIL natur-oper 
                                               AND natur-oper.usa-pick 
                                               AND natur-oper.cd-trib-ipi = 3
                                               THEN it-doc-fisc.vl-tot-item 
                                               ELSE IF  doc-fiscal.tipo-nat <> 3
                                                        THEN it-doc-fisc.vl-ipiou-it
                                                        ELSE 0)
            de-vl-bsubs    = de-vl-bsubs    + it-doc-fisc.vl-bsubs-it
            de-vl-icmsub   = de-vl-icmsub   + it-doc-fisc.vl-icmsub-it.

    IF it-doc-fisc.cd-trib-ipi = 1 
    and (   it-doc-fisc.quantidade <> 0 
         OR (    it-doc-fisc.quantidade = 0 
             AND doc-fiscal.vl-cont-doc = 0)) THEN ASSIGN l-tem-ipi-1 = YES.
    IF de-vl-ipint > 0 THEN ASSIGN l-tem-ipi-2 = YES.
    IF de-vl-ipiou > 0 THEN ASSIGN l-tem-ipi-3 = YES.
    
    &if '{&bf_dis_versao_ems}' = '2.04' or '{&bf_dis_versao_ems}' = '2.05' &then
        if l-icms-subst = no then do:
            assign de-vl-cont-doc = de-vl-cont-doc + (it-doc-fisc.vl-tot-item - it-doc-fisc.dec-2).
        end.
        else do:
            assign de-vl-cont-doc = de-vl-cont-doc + it-doc-fisc.vl-tot-item.
        end.
    &elseif '{&bf_dis_versao_ems}' >= '2.06' &then
        if l-icms-subst = no then
            assign de-vl-cont-doc = de-vl-cont-doc + (it-doc-fisc.vl-tot-item - it-doc-fisc.val-icms-subst-entr).
        else
            assign de-vl-cont-doc = de-vl-cont-doc + it-doc-fisc.vl-tot-item.
        &else
            assign de-vl-cont-doc = de-vl-cont-doc + it-doc-fisc.vl-tot-item.
    &endif.
end.

put doc-fiscal.dt-docto        at  1 format "99/99/99"
    doc-fiscal.esp-docto       at 10
    doc-fiscal.serie           at 15 format "x(03)".

IF LENGTH(doc-fiscal.nr-doc-fis) > 9 THEN
    PUT SUBSTRING(doc-fiscal.nr-doc-fis,LENGTH(doc-fiscal.nr-doc-fis) - 8) at 18 format "999999999".
ELSE
    PUT INT(doc-fiscal.nr-doc-fis) AT 18 FORMAT ">>9999999".
    PUT doc-fiscal.dt-emis-doc     AT 28 FORMAT "99/99/99"
        doc-fiscal.cod-emitente    AT 38 FORMAT ">>>>>>>>9".
    IF doc-fiscal.ind-sit-doc = 1 THEN 
        PUT doc-fiscal.estado      AT 48 FORMAT "x(02)"
            de-vl-cont-doc         AT 51 FORMAT ">>>>>>>>>>>>9.99". 
    IF doc-fiscal.ind-sit-doc = 2 THEN
        PUT c-obs-total            AT 146 skip(1).
    
assign c-imposto = "ICMS".

if doc-fiscal.vl-icms-com > 0 and c-estado = "MG" AND l-imp-dif-aliq then
    assign i-ver = 1.

if  doc-fiscal.ind-sit-doc = 1 then do:
    FOR EACH it-doc-fisc of doc-fiscal no-lock
        where (c-estado <> "PE" /* para estados <> "PE" considerar todos os itens */ 
               or can-find(item where item.it-codigo = it-doc-fisc.it-codigo
                               and  item.incentivado = l-incentivado)),
        each  w-conta
        where w-conta.aliquota-icms = it-doc-fisc.aliquota-icm
        and   w-conta.conta-contabil =  if  l-conta-contabil 
                                        then it-doc-fisc.ct-codigo
                                        else " "   
        break by w-conta.cod-tributacao
              by w-conta.conta-contabil
              by w-conta.aliquota-icms: /* aliquota de icms */
                                             
        run pi-acompanhar in h-acomp (input it-doc-fisc.nr-doc-fis).
    
        assign de-acum[1] = de-acum[1] + it-doc-fisc.vl-bicms-it
               de-acum[2] = de-acum[2] + it-doc-fisc.vl-icms-it
               de-acum[3] = de-acum[3] + it-doc-fisc.vl-icmsnt-it
               de-acum[4] = de-acum[4] + it-doc-fisc.vl-icmsou-it
               l-primeiro = i-cod-tri <> w-conta.cod-tributacao
               l-imp-nat  = yes
               c-conta    = substr(w-conta.conta-contabil,1,20).
                
        if  last-of(w-conta.conta-contabil)
        or  last-of(w-conta.aliquota-icms) then do:
            if w-conta.cod-tributacao = 1  then do:
               run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
               run ofp/esof0540h.p (input rowid(emitente),
                                  input rowid(doc-fiscal)).
               
               if  l-conta-contabil 
               AND LENGTH(c-conta ) <= 13 then 
                   put UNFORMATTED c-conta at 63.
    
               if l-primeiro then do:
                  put c-cfop                 at 77 format "x(04)"
                      w-conta.cod-tributacao AT 82 format "9".
                  assign c-cfop = "".
               end.
                
               put de-acum[1]                to  98 format ">>>>>>>>>>9.99"
                   it-doc-fisc.aliquota-icm  to 104 format IF  it-doc-fisc.aliquota-icm = 100
                                                           THEN ">>9"                                                  
                                                           ELSE ">9.99".                                                      
                    
                   PUT de-acum[2]            to 115 format ">>>>>>>9.99".
    
               assign i-cod-tri = w-conta.cod-tributacao.
            end.
            if  w-conta.cod-tributacao = 2 then do:
                run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
                run ofp/esof0540h.p (input rowid(emitente),
                                   input rowid(doc-fiscal)).
    
                IF l-conta-contabil 
                AND LENGTH(c-conta ) <= 13 THEN 
                    PUT UNFORMATTED c-conta at 63.
    
                if l-primeiro then do: 
                   put c-cfop                 AT 77 format "x(04)"
                       w-conta.cod-tributacao AT 82 format "9".
                   assign c-cfop = "".
                end. 
                put de-acum[3]                TO  98 format ">>>>>>>>>>9.99"
                    0                         TO 115 format ">>>>>>>9.99".
                     
                assign i-cod-tri = w-conta.cod-tributacao.
            end.
            
            if  w-conta.cod-tributacao = 3 then do:
                run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
                run ofp/esof0540h.p (input rowid(emitente),
                                   input rowid(doc-fiscal)).
    
                if l-conta-contabil 
               AND LENGTH(c-conta ) <= 13 then 
                   put UNFORMATTED c-conta at 63.
    
                if l-primeiro then do:
                    put c-cfop                 AT 77 format "x(04)"  
                        w-conta.cod-tributacao AT 82 format "9".
                    assign c-cfop = "".
                end. 
                put de-acum[4]        TO  98 format ">>>>>>>>>>9.99"
                    0                 TO 115 format ">>>>>>>9.99".
    
                assign i-cod-tri = w-conta.cod-tributacao.
            end.
                        
            if i-cod-trib-ipi = 1 then do:
                if (de-vl-ipi > 0 
                or  de-vl-bipi > 0
                OR  l-tem-ipi-1) then do:
                    put string(i-cod-trib-ipi,"9") at 117 format "9"
                        de-vl-bipi        to 132 format ">>>>>>>>>9.99"
                        de-vl-ipi         to 144 format ">>>>>>>9.99".
                end.
                else
                    assign i-cod-trib-ipi = 2.
            end.               
            if i-cod-trib-ipi = 2 then do:
                if (de-vl-ipint > 0 OR  l-tem-ipi-2) then do:
                    put string(i-cod-trib-ipi,"9") at 117 format "9"
                        de-vl-ipint       to 132 format ">>>>>>>>>9.99"
                        0                 TO 144 format ">>>>>>>9.99".
                end.
                else
                    assign i-cod-trib-ipi = 3.
            end.
            if i-cod-trib-ipi = 3 then do:
                if (de-vl-ipiou > 0 OR  l-tem-ipi-3) then do:
                    put string(i-cod-trib-ipi,"9")  at 117 format "9"
                               de-vl-ipiou          to 132 format ">>>>>>>>>9.99"
                               0                    to 144 format ">>>>>>>9.99".
                end.
            end.
    
            IF  l-conta-contabil 
            AND LENGTH(c-conta ) > 13 then 
               put UNFORMATTED c-conta at 56.
    
            if c-estado = "MG" then do:
                {ofp/esof0540f.i2}   
            end. 
            else do:
                {ofp/esof0540f.i}
            end.  
    
            assign de-acum = 0
                   i-cod-trib-ipi = i-cod-trib-ipi + 1.
        END. 
    END. /* For each it-doc-fisc */

    IF  l-subs 
    AND i-op-rel = 1 THEN DO:
        RUN pi-verifica-linhas IN h-esof0540e (LINE-COUNTER,1,c-localiz).
        RUN ofp/esof0540h.p (INPUT ROWID(emitente),
                           INPUT ROWID(doc-fiscal)).
    
        IF l-imp-nat = NO THEN DO:
            PUT c-cfop at 77 FORMAT "x(04)".
            ASSIGN l-imp-nat = YES.
        END.             
                           
        PUT "ST"          AT  83
            de-vl-bsubs   TO  98 FORMAT ">>>>>>>>>>9.99"
            de-vl-icmsub  TO 115 FORMAT ">>>>>>>>9.99".
    END.   

    run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
    
    if  l-imp-nat = no then do:
        put c-cfop at 77 format "x(04)".
        assign l-imp-nat = yes.
    end.
    if  i-cod-trib-ipi = 1 then do: 
        if (de-vl-ipi  > 0
        or  de-vl-bipi > 0) then do:
            run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
            run ofp/esof0540h.p (input rowid(emitente),    /* era recid */
                               input rowid(doc-fiscal)). /* era recid */
    
            if  l-imp-nat = no then do:
                put c-cfop at 77 format "x(04)".
                assign l-imp-nat = yes.
            end.
    
            put string(i-cod-trib-ipi,"9") at 117 format "9"
                de-vl-bipi         to 132 format ">>>>>>>>>9.99"
                de-vl-ipi          to 144 format ">>>>>>>>9.99".
            {ofp/esof0540f.i}
            {ofp/esof0540f.i2}
        END.
        ASSIGN i-cod-trib-ipi = 2.
    END.
    if  i-cod-trib-ipi = 2 then do:
        if de-vl-ipint > 0 then do:
            run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
            run ofp/esof0540h.p (input rowid(emitente),    /* era recid */
                               input rowid(doc-fiscal)). /* era recid */ 
    
            if  l-imp-nat = no then do:
                put c-cfop at 77 format "x(04)".
                assign l-imp-nat = yes.
            end.
    
            put string(i-cod-trib-ipi,"9") at 117 format "9"
                de-vl-ipint        to 132 format ">>>>>>>>>9.99"
                0                  to 144 format ">>>>>>>>9.99".
            
            {ofp/esof0540f.i} 
            {ofp/esof0540f.i2}
            
        end.
        assign i-cod-trib-ipi = 3.
    end.
    if  i-cod-trib-ipi = 3 then do:
        if de-vl-ipiou > 0 then do:
            run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
            run ofp/esof0540h.p (input rowid(emitente),    /* era recid */
                               input rowid(doc-fiscal)). /* era recid */
    
            if  l-imp-nat = no then do:
                put c-cfop at 77 format "x(04)".
                assign l-imp-nat = yes.
            end.
    
            put string(i-cod-trib-ipi,"9") at 117 format "9"
            de-vl-ipiou       to 132 format ">>>>>>>>>9.99"         
                0             to 144 format ">>>>>>>>9.99".
            
            {ofp/esof0540f.i}
            {ofp/esof0540f.i2}
        END.
    END.
END.
if c-estado = "MG"
or c-estado = "PE" then do:
    if doc-fiscal.cod-des-merc = 2
    and de-vl-ipiou > 0 then do:
        assign de-obs = de-vl-cont-doc -
                        (accum total it-doc-fisc.vl-merc-liq) -
                        de-vl-ipint - de-vl-ipi -
                        (accum total it-doc-fisc.vl-despes-it)
               de-obs = if de-obs < 0
                           then 0
                        else de-obs.
     end.
    
     if de-obs > 0 then do:
         run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
         run ofp/esof0540h.p (input rowid(emitente),
                            input rowid(doc-fiscal)).
         if l-imp-nat = no then do:
            put c-cfop at 77 format "x(04)".
            assign l-imp-nat = yes.
         end.                      
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-obs AS CHARACTER FORMAT "X(5)" NO-UNDO.
         {utp/ut-liter.i "OBS" *}
         ASSIGN c-lbl-liter-obs = TRIM(RETURN-VALUE).
         put c-lbl-liter-obs  at 117
             de-obs           to 132 format ">>>>>>>>>9.99"
             0                to 144 format ">>>>>>>>9.99"  skip.
         
         if c-estado = "MG" then do:
             {ofp/esof0540f.i2}   
         end. 
         else do:
             {ofp/esof0540f.i}
         END.
     END.
END.

if  doc-fiscal.ind-sit-doc = 1 then do:
    if  c-obs-total <> "" 
    and i-inicio    = 1 then do:
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
        if c-estado = "MG" then do:
            {ofp/esof0540f.i2}   
        end. 
        else do:
            {ofp/esof0540f.i}
        end.   
    end.
    if  i-status = 0 
    and l-imp-for then
        assign i-status = 1.
end.
if  i-status = 1 then do:
    run ofp/esof0540h.p (input rowid(emitente),
                       input rowid(doc-fiscal)).
    if c-estado = "MG" then do:
        {ofp/esof0540f.i2}   
    end. 
    else do:
        {ofp/esof0540f.i}
    end.   
end.

if  i-status = 2 then do:
    run ofp/esof0540h.p (input rowid(emitente),
                       input rowid(doc-fiscal)).

    if c-estado = "MG" then do:
        {ofp/esof0540f.i2}   
    end. 
    else do:
        {ofp/esof0540f.i}
    end.   
end.

if  doc-fiscal.ind-sit-doc = 1 then do:
    do while c-observa <> "" 
    and i-inicio < 56:
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
        if c-estado = "MG" then do:
            {ofp/esof0540f.i2}   
        end. 
        else do:
            {ofp/esof0540f.i}
        end.   
    end.

    if  l-prim-txt = no 
    and l-prim-vlr = yes then do:
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
        if c-estado = "MG" then do:
            {ofp/esof0540f.i2}   
        end. 
        else do:
            {ofp/esof0540f.i}
        end.   
    end.
    run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
    
    put skip(1).
end.
