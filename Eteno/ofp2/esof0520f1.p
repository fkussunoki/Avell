/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520F1 2.00.00.076 } /*** "010076" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520f1 MOF}
&ENDIF

/******************************************************************************
**
**  Programa: esof0520F1.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Imprime doc-fiscal
**
******************************************************************************/

/** EPC ****************************/
{include/i-epc200.i esof0520F1}
DEF TEMP-TABLE tt-itens-excluidos  NO-UNDO
    FIELD rw-reg AS ROWID.
/** EPC ****************************/

DEF BUFFER b-doc-fiscal FOR doc-fiscal. 

{ofp/esof0520.i shared}

{cdp/cdcfgdis.i} /* preprocessadores cfop */

def shared temp-table tt-conta no-undo
    field cod-tributacao  as integer format "9"
    field conta-contabil  as character
    field aliquota-icms   as DECIMAL
    FIELD cfop            AS CHARACTER. 

def shared var h-esof0520e      as handle               no-undo.
def shared var c-nome-emit    like emitente.nome-emit no-undo.
def shared var c-estado-estab like estabelec.estado   no-undo.
    
DEF SHARED VAR l-tem-ipi-1 AS LOG NO-UNDO.
DEF SHARED VAR l-tem-ipi-2 AS LOG NO-UNDO.
DEF SHARED VAR l-tem-ipi-3 AS LOG NO-UNDO.

DEF SHARED VAR d-vl-icms-comp LIKE doc-fiscal.vl-icms-com NO-UNDO. /* Vari vel definia para acumular valor do ICMS Retido sem a  op‡Æo Separadores */ 

find first param-global no-lock no-error.
DEFINE VARIABLE c-cgc-e LIKE doc-fiscal.cgc NO-UNDO.

PROCEDURE pi-imprime:
    
def input parameter r-registro       as rowid.
def input parameter i-num-linhas     as int.
def input parameter de-obs           as decimal. 
def input parameter de-vl-tot-item   like it-doc-fisc.vl-tot-item. 
/* Novo CFOP */
def INPUT PARAMETER da-dt-cfop       as date.    
DEF INPUT-OUTPUT PARAMETER c-obs-aux AS CHARACTER format "x(152)". 

def buffer b-param-of-cfop for param-of.    
DEF var c-desc-cfop-nat like natur-oper.denominacao no-undo.
if  no then do:
    find first b-param-of-cfop   no-lock no-error.
    FIND FIRST param-of          NO-LOCK NO-ERROR.
    find first natur-oper        no-lock no-error.
end.    

def var c-imprimiu       as integer init 0            no-undo.
def var i-primeira       as integer init 1            no-undo.
def var l-subs           as logical init no           no-undo.
def var c-conta          as character format "x(20)"  no-undo.
def var da-aux           as date                      no-undo.
def var l-nome-imp       as logical init no           no-undo.
def var l-ins-est-imp    as logical init no           no-undo.
def var l-privez         as logical                   no-undo.
def var l-imp-nat        as logical init no           no-undo.
def var c-obs            as character format "x(152)" no-undo.
DEF VAR i-emitente-imp   LIKE doc-fiscal.cod-emitente NO-UNDO.

/* Variavel criada para armazenar a especie do item do documento */
DEF VAR esp-item AS CHARACTER NO-UNDO. 

for first doc-fiscal fields ( cod-estabel cod-emitente nr-doc-fis serie nat-operacao vl-iss
                              observacao ind-sit-doc vl-bsubs vl-icmsub dt-docto tipo-nat 
                              esp-docto dt-emis-doc estado vl-icms-com vl-icms cgc char-1 )
    where rowid(doc-fiscal) = r-registro no-lock.
end.

/* Este find ‚ necess rio para que nÆo ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */
if  no then
    for first natur-oper fields(char-2) no-lock.
    end.
    
assign i-inicio        = 1
       l-prim-txt      = yes          
       l-prim-vlr      = yes
       l-prim-cred     = yes
       l-prim-vlr-cred = yes
       i-status        = 0
       i-cod-tri       = 0
       c-obs-total     = c-linha-branco
       c-obs           = IF doc-fiscal.ind-sit-doc = 1 THEN "" ELSE "Cancelado"
       de-vl-bsubs-it  = 0
       de-vl-icmsub-it = 0.

ASSIGN c-obs-aux = "". 

run pi-print-editor(input c-obs, input 152).

find first tt-editor no-error.

assign c-obs = if avail tt-editor 
               then tt-editor.conteudo
               else "".

for first natur-oper fields( nat-operacao char-2 cd-situacao emite-duplic usa-pick cd-trib-ipi cd-trib-icm)
    where natur-oper.nat-operacao = doc-fiscal.nat-operacao no-lock:
end.

{ofp/esof0520g.i doc-fiscal.nat-operacao}   /* grava formato c-cfop */
    
assign l-subs = doc-fiscal.vl-bsubs > 0 or doc-fiscal.vl-icmsub > 0. 

run pi-verifica-linhas in h-esof0520e(i-num-linhas).

assign c-imposto         = "ICMS".

    IF NOT AVAIL param-of 
    OR param-of.cod-estabel <> doc-fiscal.cod-estabel THEN
       for first param-of fields ( char-2 cod-estabel ) no-lock
            where param-of.cod-estabel = doc-fiscal.cod-estabel.
       end.                                                   
    {ofp/esof0520f.i3}

put c-sep at  1 doc-fiscal.dt-docto     format "99/99/99"
    c-sep at 10 doc-fiscal.esp-docto    
    c-sep at 14 doc-fiscal.serie
    c-sep at 20.

IF LENGTH(doc-fiscal.nr-doc-fis) > 9 THEN
    put STRING(DEC(substr(doc-fiscal.nr-doc-fis, LENGTH(doc-fiscal.nr-doc-fis) - 8)),"999999999") at 21 format "x(9)".
ELSE
    put STRING(DEC(doc-fiscal.nr-doc-fis),">>>>>>>>9") at 21 format "x(9)".

ASSIGN i-emitente-imp = doc-fiscal.cod-emitente.

/** EPC para troca de codigo do emitente para impressao **/

for each tt-epc EXCLUSIVE-LOCK
    where tt-epc.cod-event = "troca-emitente":
    delete tt-epc.
end.

create tt-epc.
assign tt-epc.cod-event     = "troca-emitente"
       tt-epc.cod-parameter = "doc-fiscal rowid"
       tt-epc.val-parameter = string(rowid(doc-fiscal)).

{include/i-epc201.i "troca-emitente"}

find first tt-epc where
    tt-epc.cod-event     = "troca-emitente" and
    tt-epc.cod-parameter = "cod-emitente" no-lock no-error.

if  avail tt-epc then
    assign i-emitente-imp = integer(tt-epc.val-parameter).

put c-sep at 30 doc-fiscal.dt-emis-doc  format "99/99/99" 
    c-sep at 39 i-emitente-imp    to 48 format ">>>>>>>>9".
IF doc-fiscal.ind-sit-doc = 1 THEN
    PUT c-sep at 49 doc-fiscal.estado       format 'x(2)'     
        c-sep at 52 de-vl-tot-item    to 66 format ">>>>>>>>>>9.99".
IF doc-fiscal.ind-sit-doc = 2 THEN DO:
    PUT c-sep AT 49
        c-sep AT 52
        c-sep AT 67
        c-sep AT 83
        c-sep AT 90
        c-sep AT 95
        c-sep AT 99
        c-sep AT 114
        c-sep AT 120
        c-sep AT 132.
    ASSIGN c-cfop = "".
END.

/** EPC ****************************/
RUN piCreateEpcParameters.
RUN piSendEpcParameters.

RUN piCreateInitializePoint.
RUN piSendInitializePoint.
RUN piReadReceivedDataFromEpc.
/** EPC ****************************/

ASSIGN esp-item = doc-fiscal.esp-docto. 

for each  it-doc-fisc NO-LOCK
    WHERE it-doc-fisc.dt-docto     = doc-fisc.dt-docto    
    AND   it-doc-fisc.cod-estabel  = doc-fisc.cod-estabel 
    AND   it-doc-fisc.serie        = doc-fisc.serie       
    AND   it-doc-fisc.nr-doc-fis   = doc-fisc.nr-doc-fis  
    AND   it-doc-fisc.cod-emitente = doc-fisc.cod-emitente
    AND   (SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "1" OR 
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "2" OR
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "3")
    AND (c-estado-estab <> "PE" /* para estados <> "PE" considerar todos os itens */ 
           or can-find(item where item.it-codigo = it-doc-fisc.it-codigo
                       and  item.incentivado = l-incentivado)
           OR CAN-FIND (FIRST tt-itens-excluidos))
    /** EPC ****************************/
    AND   NOT CAN-FIND(FIRST tt-itens-excluidos
                       WHERE tt-itens-excluidos.rw-reg = ROWID(it-doc-fisc)),
    /** EPC ****************************/
    
    /* Inserido o campo da especie pois o cliente pode ter para uma mesma CFOP especies diferentes e com isso ‚ necess rio acumular os valores
       separados, somente juntar quando a especie for a mesma */
    EACH  b-doc-fiscal
    WHERE b-doc-fiscal.cod-estabel  = it-doc-fisc.cod-estabel
    AND   b-doc-fiscal.cod-emitente = it-doc-fisc.cod-emitente
    AND   b-doc-fiscal.serie        = it-doc-fisc.serie
    AND   b-doc-fiscal.nr-doc-fis   = it-doc-fisc.nr-doc-fis
    AND   b-doc-fiscal.nat-operacao = it-doc-fisc.nat-operacao
    AND   b-doc-fiscal.esp-docto    = esp-item, 

    EACH  natur-oper NO-LOCK                                                                
    WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao,
    EACH     tt-conta NO-LOCK
       where tt-conta.conta-contabil = (if l-conta-contabil then it-doc-fisc.ct-codigo else "")
       and   tt-conta.aliquota-icms  = it-doc-fisc.aliquota-icm  /*it-doc-fisc.dec-1*/ 
       &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            AND tt-conta.cfop = trim(b-doc-fiscal.cod-cfop)
       &else
            AND tt-conta.cfop = trim(substr(b-doc-fiscal.char-1,1,10))
       &ENDIF
       break 
            &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                BY b-doc-fiscal.cod-cfop
            &else
                BY trim(substr(b-doc-fiscal.char-1,1,10))
            &ENDIF
             by tt-conta.cod-tributacao
             by tt-conta.conta-contabil
             by tt-conta.aliquota-icms:

    assign de-acum[1] = de-acum[1] + it-doc-fisc.vl-bicms-it
           de-acum[2] = de-acum[2] + it-doc-fisc.vl-icms-it
           de-acum[3] = de-acum[3] + (IF  doc-fiscal.tipo-nat = 3 
                                      AND AVAIL natur-oper 
                                      AND natur-oper.cd-trib-icm = 2
                                          THEN it-doc-fisc.vl-tot-item 
                                          ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                   THEN it-doc-fisc.vl-icmsnt-it
                                                   ELSE 0 )
           de-acum[4] = de-acum[4] + (IF  doc-fiscal.tipo-nat = 3 
                                      AND AVAIL natur-oper 
                                      AND natur-oper.cd-trib-icm = 3
                                          THEN it-doc-fisc.vl-tot-item 
                                          ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                   THEN it-doc-fisc.vl-icmsou-it
                                                   ELSE 0 )
           l-primeiro = i-cod-tri <> tt-conta.cod-tributacao
           c-conta    = trim(substr(tt-conta.conta-contabil,1,20)).
    
    if  last-of(tt-conta.conta-contabil)
    or  last-of(tt-conta.aliquota-icms) 
    OR  LAST-OF( &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                     b-doc-fiscal.cod-cfop
                 &else
                     trim(substr(b-doc-fiscal.char-1,1,10))
                 &ENDIF )
        then do:
        if  l-imp-nat then do: 
            {ofp/esof0520f.i2}
            run pi-verifica-linhas in h-esof0520e(1).
            put unformatted c-obs-total at 1 format "x(64)".
        end.

        if  tt-conta.cod-tributacao = 1 then do:

           PUT c-sep at 67.

           /*se a conta for at‚ 15 posi‡äes imprime na primeira linha*/
           IF LENGTH(c-conta) <= 15 THEN DO:
               if  l-conta-contabil then 
                   put UNFORMATTED c-conta at 68. 
           END.
               
           put c-sep at 83. 
           
           if l-primeiro then do:
               put c-cfop FORMAT "x(05)" at 84
                   c-sep  at 90 c-imposto              
                   c-sep  at 95 tt-conta.cod-tributacao to 98.
               assign c-cfop = "".
           end.
           ELSE DO:
               put c-sep  at 90 c-imposto                     
                   c-sep  at 95 tt-conta.cod-tributacao to 98.
           END.
            
            put c-sep at 99 de-acum[1] to 113
                format ">>>>>>>>>>9.99" 
                c-sep at 114 it-doc-fisc.aliquota-icm /*it-doc-fisc.dec-1*/ to 119 
                FORMAT IF it-doc-fisc.aliquota-icm = 100  /* Aliquota imprime 100 */
                       THEN ">>9"                     
                       ELSE ">9.99"                       
                c-sep at 120 de-acum[2] to 131
                format ">>>>>>>9.99" /* NOTA */ 
                c-sep at 132.

            if  i-op-rel = 2 then do: 
                if  l-subs then
                    put de-vl-bsubs-it   to 144
                        format ">>,>>>,>>9.99" c-sep
                        de-vl-icmsub-it  to 158
                        format ">>>>,>>9.99"
                        c-sep at 159.
                else 
                    put c-sep at 144
                        c-sep at 158.
            end.
            put skip.

            /*se a conta tiver mais de 15 posi‡äes imprime na segunda linha sem o separador inicial da conta*/
            IF LENGTH(c-conta) > 15 
            AND l-conta-contabil THEN DO:
                run pi-verifica-linhas in h-esof0520e(1).
                put unformatted c-obs-total at 1 format "x(52)".
                put UNFORMATTED c-conta at 63. 
                PUT UNFORMATTED  "|" + FILL(" ",7) + "|" + FILL(" ",4) + "|" + FILL(" ",3) + "|" + FILL(" ",14) + "|" + FILL(" ",5) + "|" + FILL(" ",10) + "|" AT 83.
                put skip.
            END.
            
            assign i-cod-tri = tt-conta.cod-tributacao.
        end.
        
        if  tt-conta.cod-tributacao = 2 then do:

           PUT c-sep at 67.

           /*se a conta for at‚ 15 posi‡äes imprime na primeira linha*/
           IF LENGTH(c-conta) <= 15 THEN DO:
               if  l-conta-contabil then 
                   put UNFORMATTED c-conta at 68. 
           END.

           put c-sep at 83. 

           if l-primeiro then do:
               put c-cfop FORMAT "x(05)" at 84  
                   c-sep  at 90 c-imposto              
                   c-sep  at 95 tt-conta.cod-tributacao to 98.
               assign c-cfop = "".
           end.
           ELSE DO:
              put c-sep  at 90 c-imposto                     
                  c-sep  at 95 tt-conta.cod-tributacao to 98.
           END.
           put c-sep at 99 de-acum[3] to 113
               format ">>>>>>>>>>9.99" 
               c-sep at 114  
               c-sep at 120 0 to 131
               format ">>>>>>9.99"                
               c-sep at 132.
           
           if  i-op-rel = 2 then 
                put c-sep at 145
                    c-sep at 159.
           put skip.  
           assign i-cod-tri = tt-conta.cod-tributacao.

           /*se a conta tiver mais de 15 posi‡äes imprime na segunda linha sem o separador inicial da conta*/
           IF LENGTH(c-conta) > 15 
           AND l-conta-contabil THEN DO:
               run pi-verifica-linhas in h-esof0520e(1).
               put unformatted c-obs-total at 1 format "x(52)".
               put UNFORMATTED c-conta at 63. 
                PUT UNFORMATTED  "|" + FILL(" ",7) + "|" + FILL(" ",4) + "|" + FILL(" ",3) + "|" + FILL(" ",14) + "|" + FILL(" ",5) + "|" + FILL(" ",10) + "|" AT 83.
               put skip.
           END.
        end.

        if  tt-conta.cod-tributacao = 3 then do:

           PUT c-sep at 67.

           /*se a conta for at‚ 15 posi‡äes imprime na primeira linha*/
           IF LENGTH(c-conta) <= 15 THEN DO:
               if  l-conta-contabil then 
                   put UNFORMATTED c-conta at 68. 
           END.

           put c-sep at 83. 

           if l-primeiro then do:
               put c-cfop FORMAT "x(05)" at 84 
                   c-sep  at 90 c-imposto              
                   c-sep  at 95 tt-conta.cod-tributacao to 98.
               assign c-cfop = "".
           end.
           ELSE DO:
              put c-sep  at 90 c-imposto                      
                  c-sep  at 95 tt-conta.cod-tributacao to 98. 
           END.

            put c-sep at 99 de-acum[4] to 113
                format ">>>>>>>>>>9.99" 
                c-sep at 114
                c-sep at 120 0 to 131
                format ">>>>>>9.99"                
                c-sep at 132.
           
            if  i-op-rel = 2 then 
                 put c-sep at 145
                     c-sep at 159.
             put skip.
             assign i-cod-tri = tt-conta.cod-tributacao.

             /*se a conta tiver mais de 15 posi‡äes imprime na segunda linha sem o separador inicial da conta*/
            IF LENGTH(c-conta) > 15 
            AND l-conta-contabil THEN DO:
                run pi-verifica-linhas in h-esof0520e(1).
                put unformatted c-obs-total at 1 format "x(52)".
                put UNFORMATTED c-conta at 63. 
                PUT UNFORMATTED "|" + FILL(" ",7) + "|" + FILL(" ",4) + "|" + FILL(" ",3) + "|" + FILL(" ",14) + "|" + FILL(" ",5) + "|" + FILL(" ",10) + "|" AT 83.
                put skip.
            END.
        end.
        assign de-acum = 0
               l-imp-nat  = yes.
    END.
END. /* for each it-doc-fisc */

/* Foi necessario incluir outro for each para realizar somente a soma dos valores ST pois como o icms e por tribu‡Æo, acabava duplicando o valor 
   do ICMS ST pois entrava mais de uma vez no for each acima e somava novamente o mesmo valor causando duplicidade */
FOR EACH  it-doc-fisc NO-LOCK
    WHERE it-doc-fisc.dt-docto          = doc-fiscal.dt-docto    
    AND   it-doc-fisc.cod-estabel       = doc-fiscal.cod-estabel 
    AND   it-doc-fisc.serie             = doc-fiscal.serie       
    AND   it-doc-fisc.nr-doc-fis        = doc-fiscal.nr-doc-fis  
    AND   it-doc-fisc.cod-emitente      = doc-fiscal.cod-emitente
    AND   (   it-doc-fisc.vl-bsubs-it  <> 0
           OR it-doc-fisc.vl-icmsub-it <> 0)
    AND   (SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "1" OR 
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "2" OR
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "3")
    AND (c-estado-estab <> "PE" /* para estados <> "PE" considerar todos os itens */ 
         OR can-find(item where item.it-codigo = it-doc-fisc.it-codigo and  item.incentivado = l-incentivado)
         OR CAN-FIND (FIRST tt-itens-excluidos))
    /** EPC ****************************/
    AND   NOT CAN-FIND(FIRST tt-itens-excluidos
                       WHERE tt-itens-excluidos.rw-reg = ROWID(it-doc-fisc)),
    FIRST natur-oper FIELDS() NO-LOCK
    WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao
    AND &IF DEFINED(bf_dis_formato_CFOP) &THEN 
          natur-oper.cod-cfop                   = doc-fiscal.cod-cfop 
        &ELSE 
          trim(substr(natur-oper.char-1,45,10)) = trim(substr(doc-fiscal.char-1,1,4)) 
        &ENDIF:
    /** EPC ****************************/        

    ASSIGN de-vl-bsubs-it  = de-vl-bsubs-it  + it-doc-fisc.vl-bsubs-it
           de-vl-icmsub-it = de-vl-icmsub-it + it-doc-fisc.vl-icmsub-it
           l-subs          = YES. /* ICMS ST */
END.

IF doc-fiscal.ind-sit-doc = 1 THEN DO:
    ASSIGN c-imposto    = "IPI"
           i-num-linhas = 0.
    
    if (    de-vl-ipi-it  > 0
        or  de-vl-bipi-it > 0 
        OR  l-tem-ipi-1) then
        ASSIGN i-num-linhas = i-num-linhas + 1.
    
    if  (de-vl-ipint-it > 0 OR  l-tem-ipi-2) then
        assign i-num-linhas = i-num-linhas + 1.
    
    if  de-vl-ipiou-it > 0 OR  l-tem-ipi-3 then 
        assign i-num-linhas = i-num-linhas + 1.
    if  i-num-linhas > 0 then do:
        run pi-verifica-linhas in h-esof0520e(i-num-linhas).
    end.
    
    DO i-cod-tri = 1 to 3:
        if  i-cod-tri = 1
        and (de-vl-ipi-it > 0
        or   de-vl-bipi-it > 0
        OR  l-tem-ipi-1) THEN DO:
            if  l-imp-nat THEN DO:
                {ofp/esof0520f.i2}
                put unformatted c-obs-total at 1 format "x(86)".
            END.
            else do:
                put c-sep                 at 83
                    c-cfop FORMAT "x(05)" at 84. 
                assign l-imp-nat = yes. 
            end.
            assign c-imprimiu = 1.
            
            PUT c-sep at 90 c-imposto              
                c-sep at 95 i-cod-tri to 98
                c-sep at 99 de-vl-bipi-it to 113
                format ">>>>>>>>>>9.99" 
                c-sep at 114
                c-sep at 120 de-vl-ipi-it to 131
                format ">>>>>>9.99"                
                c-sep at 132.
                if  i-op-rel = 2 then 
                    put c-sep at 145
                        c-sep at 159.
                put skip. 
         end.
    
        if  i-cod-tri = 2
        and (de-vl-ipint-it > 0 OR  l-tem-ipi-2)then do:
            if  l-imp-nat THEN DO:
                {ofp/esof0520f.i2}
                put unformatted c-obs-total at 1 format "x(86)".
            END.
            else do:
                put c-sep                 at 83
                    c-cfop FORMAT "x(05)" at 84.
                assign l-imp-nat = yes.
            end.
            assign c-imprimiu = 1.
    
            put c-sep at 90 c-imposto              
                c-sep at 95 i-cod-tri       to 98
                c-sep at 99 de-vl-ipint-it  to 113
                format ">>>>>>>>>>9.99" 
                c-sep at 114
                c-sep at 120 0              to 131
                format ">>>>>>9.99"                
                c-sep at 132.
                if  i-op-rel = 2 then 
                     put c-sep at 145
                         c-sep at 159.
                put skip.
        end.
        if  i-cod-tri = 3 
        and (de-vl-ipiou-it > 0 OR  l-tem-ipi-3)then do:
            if  l-imp-nat then DO:
                {ofp/esof0520f.i2}
                put unformatted c-obs-total at 1 format "x(86)".
            END.
            else do:
                put c-sep                 at 83
                    c-cfop FORMAT "x(05)" at 84. 
                assign l-imp-nat = yes.
            end.
            assign c-imprimiu = 1.
            put c-sep at 90 c-imposto
                c-sep at 95 i-cod-tri       to 98
                c-sep at 99 de-vl-ipiou-it  to 113
                format ">>>>>>>>>>9.99"
                c-sep at 114
                c-sep at 120 0              to 131
                format ">>>>>>9.99"
                c-sep at 132.
                if  i-op-rel = 2 then 
                     put c-sep at 145
                         c-sep at 159.
                put skip.
          end.
    END.

    if l-imp-nat = no then do:
       if c-imprimiu = 0 then do:
          put c-sep                 at 83
              c-cfop FORMAT "x(05)" at 84.
          assign l-imp-nat = yes.
          put c-sep  at 90
              c-sep  at 95
              c-sep  at 99
              c-sep  at 114
              c-sep  at 120
              c-sep  at 132.
          if i-op-rel = 2 then
             put c-sep at 145
                 c-sep at 159.    
       end.         
    end.       
    
    if  l-subs 
    and i-op-rel = 1 then do:
        {ofp/esof0520f.i2}
        run pi-verifica-linhas in h-esof0520e(1).
        assign l-imp-nat = yes.
        put unformatted c-obs-total at 1 format "x(88)"
            "ST"  at 91             
            c-sep at 95 
            c-sep at 99 de-vl-bsubs-it  to 113
            format ">>>,>>>,>>9.99" 
            c-sep at 114
            c-sep at 120 de-vl-icmsub-it to 131
            format ">>>>,>>9.99"                
            c-sep at 132.
        if  i-op-rel = 2 then 
            put c-sep at 145
                c-sep at 159.
        put skip.
    END.
END.

if (c-estado = "MG"
or  c-estado = "PE")
and de-obs > 0 then do:
    {ofp/esof0520f.i2}
    run pi-verifica-linhas in h-esof0520e(1).
    assign l-imp-nat = yes.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "OBS" *}
    put unformatted c-obs-total at 1 format "x(87)"
        RETURN-VALUE at 91            
        c-sep at 95 
        c-sep at 99 de-obs to 113
        format ">>>,>>>,>>9.99" 
        c-sep at 114
        c-sep at 120 0 to 131
        format ">>>,>>9.99"                
        c-sep at 132.
    if  i-op-rel = 2 then 
        put c-sep at 145
            c-sep at 159.
    put skip.
end.
if  not l-imp-nat then do:
    if  i-op-rel = 1 then
        put SUBSTRING(c-linha-branco,80,52) at 80 format "x(52)".
    else
        put SUBSTRING(c-linha-branco,80,80) at 80 format "x(80)".
    put skip.
end.
                         
if  l-imp-for then do:
    do while i-status < 2:
        {ofp/esof0520f.i2}
        IF c-obs-total <> c-linha-branco THEN DO:
           run pi-verifica-linhas in h-esof0520e(1).
           put unformatted c-obs-total at 1 format "x(132)".
           if i-op-rel = 2 then 
               put c-sep at 145
                   c-sep at 159.
        END.
    END.
    PUT SKIP.
END.
assign c-obs-total     = c-linha-branco
       i-inicio        = 14.
overlay(c-obs-total,2) = "Observacao:".
if  doc-fiscal.vl-icms-com > 0 then do:
    if  c-estado = "MG" then do:
        overlay(c-obs-total,i-inicio) = 
        "DEBITO: " + string(d-vl-icms-comp,">>>>>,>>9.99") + 
        (if  doc-fiscal.vl-icms > 0 
        then ("  CREDITO: " + 
        string(d-vl-icms-comp,">,>>>,>>9.99")) 
        else "").
        assign i-inicio = 33 + if doc-fiscal.vl-icms > 0 
               then 24 else 1.
    end.
    else do:
        overlay(c-obs-total,i-inicio) = "Dif.Aliq.ICMS: " +
        string(d-vl-icms-comp,">,>>>,>>9.99"). 
        assign i-inicio = 42.
    end.
end.

IF  doc-fiscal.tipo-nat = 3 THEN DO:
    overlay(c-obs-total,i-inicio) = "Servi‡o Tributado Pelo ISSQN: (" + string(doc-fiscal.vl-iss,">,>>>,>>9.99") + ")".
    ASSIGN i-inicio = i-inicio + 45. 
END.

if  replace(replace(c-obs,CHR(13)," "),CHR(10)," ") <> ""   
or  i-inicio > 14 then do:
    overlay(c-obs-total,i-inicio)  = 
    SUBSTRING(c-obs,1,(if i-op-rel = 1 then 131 else 159) - i-inicio).
    run pi-verifica-linhas in h-esof0520e (1).
    if  i-op-rel = 1 then
        put unformatted c-obs-total at 1 format "x(132)" skip.
    else
        put unformatted c-obs-total at 1 format "x(159)" skip.
end.

END PROCEDURE.

/* esof0520F1.P */ 

/** EPC ****************************/
PROCEDURE piCreateEpcParameters:
    DEF VAR cEvent AS CHAR NO-UNDO.
    ASSIGN cEvent = "Parametros":U.

    FOR EACH tt-epc
       WHERE tt-epc.cod-event = cEvent:
        DELETE tt-epc.
    END.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = cEvent
           tt-epc.cod-parameter = "c-estado-estab":U
           tt-epc.val-parameter = c-estado-estab.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = cEvent
           tt-epc.cod-parameter = "l-incentivado":U
           tt-epc.val-parameter = IF l-incentivado THEN "YES":U ELSE "NO":U.

END PROCEDURE.

PROCEDURE piSendEpcParameters:
    {include/i-epc201.i "Parametros"}
END PROCEDURE.

PROCEDURE piCreateInitializePoint:
    DEF VAR cEvent AS CHAR NO-UNDO.

    ASSIGN cEvent = "doc-fiscal-reg":U.
    FOR EACH tt-epc
       WHERE tt-epc.cod-event = cEvent:
       DELETE tt-epc.
    END.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = cEvent
           tt-epc.cod-parameter = "rowid-doc-fiscal":U
           tt-epc.val-parameter = STRING(ROWID(doc-fiscal)).

END PROCEDURE. 

PROCEDURE piSendInitializePoint:
    {include/i-epc201.i "doc-fiscal-reg"}
END PROCEDURE.

PROCEDURE piReadReceivedDataFromEpc:
    DEF VAR raw-aux-1 AS RAW NO-UNDO.

    FOR EACH tt-itens-excluidos:
        DELETE tt-itens-excluidos.
    END.
    FOR EACH tt-epc
       WHERE tt-epc.cod-event     = "doc-fiscal-reg":U 
         AND tt-epc.cod-parameter = "raw-it-doc-fisc":U:
         RUN btb/btb928za.p (INPUT  tt-epc.val-parameter, 
                             OUTPUT raw-aux-1).
         CREATE tt-itens-excluidos.
         RAW-TRANSFER raw-aux-1 to tt-itens-excluidos.
    END.

END PROCEDURE.
/** EPC ****************************/
PROCEDURE pi-edita-cgc :
    DEFINE INPUT PARAMETER pc-cgc-in LIKE doc-fiscal.cgc NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cgc-out LIKE doc-fiscal.cgc NO-UNDO.

    ASSIGN pc-cgc-out = REPLACE(REPLACE(REPLACE(pc-cgc-in,"/",""),"-",""),".","").
    if avail param-global then do: 
         FIND emitente WHERE emitente.cod-emitente = doc-fiscal.cod-emitente NO-LOCK NO-ERROR.
         if avail emitente then do:
            if emitente.natureza = 1 and 
               param-global.formato-id-pessoal <> ''  then
               assign pc-cgc-out = string(pc-cgc-out,param-global.formato-id-pessoal).
            else
            if emitente.natureza = 2 and 
               param-global.formato-id-federal  <> '' then 
               assign pc-cgc-out = string(pc-cgc-out,param-global.formato-id-federal).
            else
               assign pc-cgc-out = string(pc-cgc-out,"x(18)").

         end.             
    end.       
END PROCEDURE.
