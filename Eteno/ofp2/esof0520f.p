/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520F 2.00.00.099 } /*** "010099" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520f MOF}
&ENDIF

/******************************************************************************
**
**  Programa: esof0520F.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Imprime doc-fiscal
**
******************************************************************************/
DEF VAR i-emitente-imp           LIKE doc-fiscal.cod-emitente    NO-UNDO.
DEF VAR l-imp-linha-cod-emitente AS LOGICAL                      NO-UNDO.

/** EPC ****************************/
{include/i-epc200.i esof0520F}
DEF TEMP-TABLE tt-itens-excluidos  NO-UNDO
    FIELD rw-reg AS ROWID.
/** EPC ****************************/

/** EPC ****************************/
DEFINE VARIABLE i-posObsFinal AS INTEGER  INIT 56   NO-UNDO.
/** EPC ****************************/
DEF BUFFER b-doc-fiscal FOR doc-fiscal. 

DEF var c-desc-cfop-nat like natur-oper.denominacao no-undo.
if  no then do:
    FIND FIRST param-of   NO-LOCK NO-ERROR.
    find first natur-oper no-lock no-error.
end.    
    
find first param-global no-lock no-error.

{ofp/esof0520.i shared}
{cdp/cdcfgdis.i} /* preprocessadores CIAP */

DEF shared temp-table tt-conta                             no-undo
    field cod-tributacao       as integer format "9"
    field conta-contabil       as character
    field aliquota-icms        as DECIMAL
    FIELD cfop                 AS CHARACTER. 

def shared var h-esof0520e       as handle                   no-undo.
def shared var c-nome-emit     like emitente.nome-emit     no-undo.
def shared var c-estado-estab  like estabelec.estado       no-undo.
DEF SHARED VAR l-imp-dif-aliq  AS LOG                      NO-UNDO.

DEF SHARED VAR l-tem-ipi-1     AS LOG NO-UNDO.
DEF SHARED VAR l-tem-ipi-2     AS LOG NO-UNDO.
DEF SHARED VAR l-tem-ipi-3     AS LOG NO-UNDO.
DEFINE VARIABLE c-cgc-e        LIKE doc-fiscal.cgc         NO-UNDO.

DEF SHARED VAR d-vl-icms-comp LIKE doc-fiscal.vl-icms-com NO-UNDO. /* Vari vel definia para acumular valor do ICMS Retido sem a  op‡Æo Separadores */ 

PROCEDURE pi-imprime:

def input parameter r-registro        as rowid.
def input parameter i-num-linhas      as int.
def input parameter de-obs            as decimal. 
def input parameter de-vl-tot-item    like it-doc-fisc.vl-tot-item. 
/* Novo CFOP */
def INPUT PARAMETER da-dt-cfop        as date.    
DEF INPUT-OUTPUT PARAMETER c-obs-aux  AS CHARACTER format "x(152)". 

def var c-imprimiu         as integer init 0               no-undo.
def var i-primeira         as integer init 1               no-undo.
def var l-subs             as logical init no              no-undo.
def var c-conta            as character format "x(20)"     no-undo. 
def var da-aux             as date                         no-undo.
def var l-nome-imp         as logical init no              no-undo.
def var l-ins-est-imp      as logical init no              no-undo.
def var l-privez           as logical                      no-undo.
def var l-imp-nat          as logical init no              no-undo.
def var c-formato          as character extent 2           no-undo.

/* Variavel criada para armazenar a especie do item do documento */
DEF VAR esp-item AS CHARACTER NO-UNDO. 

for first doc-fiscal fields ( cod-estabel cod-emitente nr-doc-fis serie nat-operacao
                              observacao ind-sit-doc vl-bsubs vl-icmsub dt-docto 
                              esp-docto dt-emis-doc estado vl-icms-com vl-icms char-1
                              tipo-nat cgc ins-estadual vl-iss)
    where rowid(doc-fiscal) = r-registro NO-LOCK.
end.


/* Este find ‚ necess rio para que nÆo ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */
if  no then
    for first natur-oper fields() no-lock.
    end.

for first natur-oper fields( nat-operacao char-2 cd-situacao emite-duplic usa-pick cd-trib-ipi cd-trib-icm)
    where natur-oper.nat-operacao = doc-fiscal.nat-operacao no-lock:
end.

{ofp/esof0520g.i doc-fiscal.nat-operacao}   /* grava formato c-cfop */
ASSIGN c-cfop = IF doc-fiscal.ind-sit-doc = 1 THEN REPLACE(c-cfop,".","") ELSE "".    

assign i-inicio        = 1
       l-prim-txt      = yes          
       l-prim-vlr      = yes
       l-prim-cred     = yes
       l-prim-vlr-cred = yes
       i-status        = 0
       i-cod-tri       = 0
       c-obs-total     = IF doc-fiscal.ind-sit-doc = 1 THEN replace(replace(c-obs-aux,CHR(13)," "),CHR(10)," ") ELSE "Cancelado"
       de-vl-bsubs-it  = 0
       de-vl-icmsub-it = 0.

ASSIGN c-obs-aux = "". 

run pi-print-editor(input c-obs-total, input 152).

find first tt-editor no-error.

FOR EACH tt-epc WHERE tt-epc.cod-event     = "BeforeAlteraObservacao"
                AND   tt-epc.cod-parameter = "VerificaTamanhoObservacao":
    DELETE tt-epc.
END.    

create tt-epc.
assign tt-epc.cod-event     = "BeforeAlteraObservacao"
       tt-epc.cod-parameter = "VerificaTamanhoObservacao"
       tt-epc.val-parameter = "NO".

{include/i-epc201.i "BeforeAlteraObservacao"}

FOR FIRST tt-epc WHERE tt-epc.cod-event     = "BeforeAlteraObservacao"
                 AND   tt-epc.cod-parameter = "VerificaTamanhoObservacao":

    IF tt-epc.val-parameter = "YES" THEN
        ASSIGN i-posObsFinal = LENGTH(c-obs-total).
    ELSE    
        assign c-obs-total = if  avail tt-editor 
                             then tt-editor.conteudo 
                             else "".

END.

if  i-op-rel = 1 then
    assign i-posicao[1] = 63
           i-posicao[2] = 78
           i-posicao[3] = 83
           i-posicao[4] = 88
           i-posicao[5] = 103
           i-posicao[6] = 109
           i-posicao[7] = 123
           i-posicao[8] = 125
           c-formato[1] = ">>>>>>>>>>9.99"
           c-formato[2] = ">>>>>>>9.99".
else
    assign i-posicao[1] = 64
           i-posicao[2] = 80
           i-posicao[3] = 85
           i-posicao[4] = 90
           i-posicao[5] = 108
           i-posicao[6] = 114
           i-posicao[7] = 128
           i-posicao[8] = 156
           c-formato[1] = ">>>,>>>,>>9.99"
           c-formato[2] = ">>>,>>9.99".

assign l-subs = doc-fiscal.vl-bsubs > 0 or doc-fiscal.vl-icmsub > 0. 

/* alterado para saltar de pagina e nao quebrar o docto */
if  l-imp-cnpj OR l-imp-ins then
    ASSIGN i-num-linhas = i-num-linhas + 1.

run pi-verifica-linhas in h-esof0520e(i-num-linhas).

assign c-imposto         = "ICMS".

  IF NOT AVAIL param-of 
  OR param-of.cod-estabel <> doc-fiscal.cod-estabel THEN
     for first param-of fields ( char-2 cod-estabel ) no-lock
         where param-of.cod-estabel = doc-fiscal.cod-estabel.
     end. 
  {ofp/esof0520f.i3}

put doc-fiscal.dt-docto     at  1 format "99/99/99"
    doc-fiscal.esp-docto    at 10
    doc-fiscal.serie        at 14 format "x(3)".

IF LENGTH(doc-fiscal.nr-doc-fis) > 9 THEN
    put STRING(DEC(substr(doc-fiscal.nr-doc-fis, LENGTH(doc-fiscal.nr-doc-fis) - 8)),"999999999") at 17 format "x(9)".
ELSE
    put STRING(DEC(doc-fiscal.nr-doc-fis),">>>>>>>>9") at 17 format "x(9)".

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

put doc-fiscal.dt-emis-doc  at 27 format "99/99/99" 
    i-emitente-imp          at 36 format ">>>>>>>>9".
    
IF doc-fiscal.ind-sit-doc = 1 THEN 
    PUT doc-fiscal.estado   at 46 format "x(2)"
        de-vl-tot-item      at 48 format ">>>>>>>>>>9.99".    
IF doc-fiscal.ind-sit-doc = 2 THEN
    PUT c-obs-total  at 125.

/** EPC ****************************/
RUN piCreateEpcParameters.
RUN piSendEpcParameters.

RUN piCreateInitializePoint.
RUN piSendInitializePoint.
RUN piReadReceivedDataFromEpc.
/** EPC ****************************/

ASSIGN esp-item = doc-fiscal.esp-docto. 

FOR EACH  it-doc-fisc NO-LOCK
    WHERE it-doc-fisc.dt-docto         = doc-fiscal.dt-docto    
    AND   it-doc-fisc.cod-estabel      = doc-fiscal.cod-estabel 
    AND   it-doc-fisc.serie            = doc-fiscal.serie       
    AND   it-doc-fisc.nr-doc-fis       = doc-fiscal.nr-doc-fis  
    AND   it-doc-fisc.cod-emitente     = doc-fiscal.cod-emitente        
    AND   (SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "1" OR 
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "2" OR
           SUBSTRING(it-doc-fisc.nat-operacao,1,1) = "3")
    AND (c-estado-estab <> "PE" /* para estados <> "PE" considerar todos os itens */ 
         OR can-find(item where item.it-codigo = it-doc-fisc.it-codigo and  item.incentivado = l-incentivado)
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
       EACH  tt-conta NO-LOCK
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

       ASSIGN  de-acum[1] = de-acum[1] + it-doc-fisc.vl-bicms-it
               de-acum[2] = de-acum[2] + it-doc-fisc.vl-icms-it
               de-acum[3] = de-acum[3] + (IF  doc-fiscal.tipo-nat = 3 
                                          AND AVAIL natur-oper 
                                          AND natur-oper.cd-trib-icm = 2
                                              THEN it-doc-fisc.vl-tot-item 
                                              ELSE IF doc-fiscal.tipo-nat <> 3 
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
               l-imp-nat  = yes
               c-conta    = substr(tt-conta.conta-contabil,1,20).
        
        if  last-of(tt-conta.conta-contabil)
        or  last-of(tt-conta.aliquota-icms) 
        OR  LAST-OF( &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
                         b-doc-fiscal.cod-cfop
                     &else
                         trim(substr(b-doc-fiscal.char-1,1,10))
                     &ENDIF )
            then do:
           
            RUN pi-verifica-linhas IN h-esof0520e(1).
            RUN pi-imprime-emitente.

            IF  l-conta-contabil 
            AND LENGTH(c-conta) <= 14 THEN 
                PUT UNFORMATTED c-conta AT i-posicao[1]. 

            IF l-primeiro THEN DO:
                PUT c-cfop                  FORMAT "x(04)" AT i-posicao[2]   
                    c-imposto               AT i-posicao[3]
                    tt-conta.cod-tributacao AT i-posicao[4].
                ASSIGN c-cfop = "".
            END.
            ELSE
                PUT c-imposto               AT i-posicao[3]
                    tt-conta.cod-tributacao AT i-posicao[4].

            IF  tt-conta.cod-tributacao = 1 THEN DO:

                PUT de-acum[1]     TO i-posicao[5] FORMAT c-formato[1]
                    it-doc-fisc.aliquota-icm TO i-posicao[6] FORMAT IF  it-doc-fisc.aliquota-icm = 100
                                                                    THEN ">>9"                                                  
                                                                    ELSE ">9.99".                                                      
                PUT de-acum[2]     TO i-posicao[7] FORMAT c-formato[2].

                IF  l-subs 
                AND i-op-rel = 2 THEN DO:
                    PUT de-vl-bsubs-it   TO 140 FORMAT ">>>>,>>9.99"
                        de-vl-icmsub-it  TO 152 FORMAT ">>>>,>>9.99".
                END.
            END.

            IF  tt-conta.cod-tributacao = 2 THEN DO:
                PUT de-acum[3] TO i-posicao[5] FORMAT c-formato[1]
                    0          TO i-posicao[7] FORMAT c-formato[2].
            END.

            IF  tt-conta.cod-tributacao = 3 THEN DO:
                PUT de-acum[4]     TO i-posicao[5] FORMAT c-formato[1]
                    0              TO i-posicao[7] FORMAT c-formato[2].
            END.

            RUN pi-imprime-observacoes.
            ASSIGN i-cod-tri = tt-conta.cod-tributacao.

            IF  l-conta-contabil 
            AND LENGTH(c-conta) > 14 THEN DO: /*se o tamanho da conta for maior que 14 imprime na linha de baixo*/
                RUN pi-verifica-linhas IN h-esof0520e(1).
                PUT SKIP.
                PUT c-conta   AT i-posicao[1] - 6. /*reduz 6 na coluna que ser  impresso para caber as 20 posi‡äes*/
                PUT SKIP.
            END.

            ASSIGN de-acum = 0.
           
        end.
end. /* for each tt-doc-fisc */

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

    assign c-imposto    = "IPI"
           i-num-linhas = 1.
    
    if  (    de-vl-ipi-it > 0
         or  de-vl-bipi-it > 0 
         OR  l-tem-ipi-1)
    or        
        (    c-estado               = "MG" 
         and doc-fiscal.vl-icms-com > 0
         and doc-fiscal.vl-icms     > 0 ) 
    then
        assign i-num-linhas = i-num-linhas + 1.
    
    if  (de-vl-ipint-it > 0 OR l-tem-ipi-2)
    or  (    c-estado               = "MG" 
         and doc-fiscal.vl-icms-com > 0
         and doc-fiscal.vl-icms     > 0 ) 
    then
        assign i-num-linhas = i-num-linhas + 1.
    
    if  de-vl-ipiou-it > 0 OR l-tem-ipi-3 then 
        assign i-num-linhas = i-num-linhas + 1.
                
    do  i-cod-tri = 1 to 3:
        if  i-cod-tri = 1
        and (de-vl-ipi-it > 0
        or  de-vl-bipi-it > 0
        OR l-tem-ipi-1) then do:
            run pi-verifica-linhas in h-esof0520e(1).
            run pi-imprime-emitente.
                     
            put c-imposto          at i-posicao[3]
                i-cod-tri          at i-posicao[4]
                de-vl-bipi-it to i-posicao[5] format c-formato[1]
                de-vl-ipi-it  to i-posicao[7] format c-formato[2].
            run pi-imprime-observacoes.
        end.
    
        if  i-cod-tri = 2
        and (de-vl-ipint-it > 0 OR l-tem-ipi-2)then do:
            run pi-verifica-linhas in h-esof0520e(1).
            run pi-imprime-emitente.
    
            if  not l-imp-nat then do:
                put c-cfop FORMAT "x(04)" at i-posicao[2].
                assign l-imp-nat = yes.
            end.
    
            put c-imposto           at i-posicao[3]
                i-cod-tri           at i-posicao[4]
                de-vl-ipint-it to i-posicao[5] format c-formato[1]
                0              to i-posicao[7] format c-formato[2].
    
            run pi-imprime-observacoes.
        end.
    
        if  i-cod-tri = 3 
        and (de-vl-ipiou-it > 0 OR l-tem-ipi-3) then do:
            run pi-verifica-linhas in h-esof0520e(1).
            run pi-imprime-emitente.
    
            if  not l-imp-nat then do:
                put c-cfop FORMAT "x(04)" at i-posicao[2].
                assign l-imp-nat = yes.
            end.
    
            put c-imposto           at i-posicao[3]
                i-cod-tri           at i-posicao[4]
                de-vl-ipiou-it to i-posicao[5] format c-formato[1]
                0              to i-posicao[7] format c-formato[2].
            run pi-imprime-observacoes.
        end.
    end.     
    /* Se a nota nÆo possuir IPI a observa‡Æo ficava pela metade gerando apenas a descri‡Æo "Dif.Aliq" */
    run pi-imprime-observacoes.

    run pi-verifica-linhas in h-esof0520e(i-num-linhas).
    if  not l-imp-nat then
       put c-cfop FORMAT "x(04)" at i-posicao[2].
    
    if  l-subs 
    and i-op-rel = 1 then do:
        run pi-verifica-linhas in h-esof0520e(1).
        run pi-imprime-emitente.
        run pi-verifica-linhas in h-esof0520e (1).
        
        put "ST"            at i-posicao[3]
            de-vl-bsubs-it  to i-posicao[5]
            format c-formato[1]
            de-vl-icmsub-it to i-posicao[7]
            format c-formato[2].
        run pi-imprime-observacoes.
    end.
    
    if  c-estado = "MG"
    or  c-estado = "PE" then do:
        if  de-obs > 0 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            run pi-imprime-emitente.
            run pi-verifica-linhas in h-esof0520e (1).
            
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-obs AS CHARACTER FORMAT "X(5)" NO-UNDO.
            {utp/ut-liter.i "OBS" *}
            ASSIGN c-lbl-liter-obs = TRIM(RETURN-VALUE).
            put c-lbl-liter-obs            at i-posicao[3]
                de-obs           to i-posicao[5]  format c-formato[1]
                0                to i-posicao[7]  format c-formato[2].
          
            run pi-imprime-observacoes.
        END.
    END.
END.

if  doc-fiscal.ind-sit-doc = 1 then do:
    if  c-obs-total <> "" 
        and i-inicio = 1 then do:
            run pi-verifica-linhas in h-esof0520e(1).
            run pi-imprime-observacoes.
    end.
    if  i-status = 0 
    and l-imp-for then
        assign i-status = 1.
end.
if  i-status = 1 then do:
    run pi-verifica-linhas in h-esof0520e (1).
    run pi-imprime-emitente.
    
    run pi-imprime-observacoes.
end.

if  i-status = 2 then do:
    run pi-verifica-linhas in h-esof0520e (1).
    run pi-imprime-emitente.
    
    run pi-imprime-observacoes.
end.

if  doc-fiscal.ind-sit-doc = 1 then do:
    do while c-observa <> "" and i-inicio < i-posObsFinal:

        run pi-verifica-linhas in h-esof0520e(1).
        run pi-imprime-observacoes.
    end.

    if  l-prim-txt = no 
    and l-prim-vlr = yes then do:
        run pi-verifica-linhas in h-esof0520e(2).
        run pi-imprime-observacoes.
    end.

    /* verificar a linha de credito de dif icms foi impressa */

    do while     (   l-prim-vlr-cred = yes
                  or l-prim-cred     = yes)
             and (    c-estado = "MG"
                  and doc-fiscal.vl-icms-com > 0): 
        
        run pi-verifica-linhas in h-esof0520e(2).
        run pi-imprime-observacoes.
    end.

end.

END PROCEDURE.

/* --------------------------- Procedures Internas ----------------------------*/

procedure pi-imprime-emitente:

    IF  l-imp-linha-cod-emitente = YES THEN DO: 
        run pi-verifica-linhas in h-esof0520e(1).                                               
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_Emitente" *}
        put unformatted RETURN-VALUE + ": " AT 1 i-emitente-imp SKIP.
        ASSIGN l-imp-linha-cod-emitente = NO.
    END.                                           


    if  i-status = 0 then do:
        if  l-imp-for then
            assign i-status = 1.
    end.
    else 
        if  i-status = 1 then do: 
            run pi-verifica-linhas in h-esof0520e(1).
            put c-nome-emit at 1 FORMAT "x(40)".
         
            if   i-op-rel = 2 then do:
                 
                 if  l-imp-cnpj then DO:
                    RUN pi-edita-cgc(INPUT doc-fiscal.cgc,
                                     OUTPUT c-cgc-e).
                    put c-cgc-e at 42 format "x(18)".
                 END.

                 if  l-imp-ins then
                     put doc-fiscal.ins-estadual at 63.
                 
                 assign i-status = -1.
            end.
            else
                 assign i-status = 2.
        end.
        else 
            if  i-status = 2 then do:

                if  l-imp-cnpj then DO:
                    RUN pi-edita-cgc(INPUT doc-fiscal.cgc, 
                                     OUTPUT c-cgc-e).
                    put c-cgc-e at 1 format "x(18)".
                END.

                if  l-imp-ins then
                    put doc-fiscal.ins-estadual at 42 format "x(19)".
         
               assign i-status = -1.
            end.
end.

procedure pi-imprime-observacoes:

    def var l-prim-imp as log  no-undo.

    if  c-obs-total <> "" then
        replace(c-obs-total,chr(13),"").
       
    assign c-observa  = ""
           l-prim-imp = yes.
           
    if  c-observa <> "" and i-inicio < i-posObsFinal then do:   
        run pi-print-editor (input c-observa, 
                             input 11).
        find first tt-editor no-error.
        if avail tt-editor then do:
          put tt-editor.conteudo format "x(11)" at i-posicao[8].
          assign i-inicio = i-inicio + 11.
        end.  
        
        for each tt-editor where tt-editor.linha > 1:
           if tt-editor.linha > 1 then
              put tt-editor.conteudo format "x(11)" at i-posicao[8].
              assign i-inicio = i-inicio + 11.
        end.
        
    /*    put unformatted c-observa at i-posicao[8] format "x(14)".  /*110*/
        assign i-inicio = i-inicio + 14. */
    end.
    else
        if  ( /*(  c-estado = "SP"
             or c-estado = "MG"
             or c-estado = "PE"
             or c-estado = "BA"
             OR c-estado = "RS")
        and*/ doc-fiscal.vl-icms-com > 0
        AND l-imp-dif-aliq ) then do:
            if  l-prim-txt   = yes then do:
                if  c-estado = "MG" then 
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-debito AS CHARACTER FORMAT "X(8)" NO-UNDO.
                    {utp/ut-liter.i "DEBITO" *}
                    ASSIGN c-lbl-liter-debito = TRIM(RETURN-VALUE).
                    put c-lbl-liter-debito   at i-posicao[8].
                    END. 
                else 
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-difaliq AS CHARACTER FORMAT "X(10)" NO-UNDO.
                    {utp/ut-liter.i "Dif.Aliq" *}
                    ASSIGN c-lbl-liter-difaliq = TRIM(RETURN-VALUE).
                    put c-lbl-liter-difaliq at i-posicao[8].
                    END. 
                    
                assign l-prim-txt = if c-estado = "MG" THEN NO ELSE ?.
            end.
            else
                if  l-prim-txt = ? then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(4)" NO-UNDO.
                    {utp/ut-liter.i "ICMS" *}
                    ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
                    put c-lbl-liter-icms at i-posicao[8].
                    assign l-prim-txt = NO.
                end.
                ELSE 
                    if  l-prim-vlr = yes then do:
                        put d-vl-icms-comp format ">>>>>>9.99" at 127. /* Total do ICMS Acumulado */ 

                        assign l-prim-vlr = no
                               l-prim-imp = no.
                    end.
            
            if  c-estado   = "MG" 
            and l-prim-txt = no 
            and l-prim-vlr = no
            and l-prim-imp = yes
            then do:
                if  doc-fiscal.vl-icms     > 0  then do:
                    if  l-prim-cred = yes then do:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-credito AS CHARACTER FORMAT "X(9)" NO-UNDO.
                        {utp/ut-liter.i "CREDITO" *}
                        ASSIGN c-lbl-liter-credito = TRIM(RETURN-VALUE).
                        put c-lbl-liter-credito          at i-posicao[8].
                        assign l-prim-cred = no.
                    end.
                    else  
                        if  l-prim-vlr-cred = yes then do:
                            put "("  at 125 d-vl-icms-comp format ">>>>>>>9.99" ")". 
                            assign l-prim-vlr-cred = no.
                        end.
                    assign l-prim-imp = no.
                end.
                else 
                    assign l-prim-cred     = no
                           l-prim-vlr-cred = no.
            end.
        end.
        
    IF  doc-fiscal.tipo-nat = 3 THEN DO:
        if  l-prim-txt = yes then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-serv-trib AS CHARACTER FORMAT "X(11)" NO-UNDO.
            {utp/ut-liter.i "Serv_Trib" *}
            ASSIGN c-lbl-liter-serv-trib = TRIM(RETURN-VALUE).
            put c-lbl-liter-serv-trib at i-posicao[8].
            assign l-prim-txt = if c-estado = "MG" THEN NO ELSE ?.
        end.
        else
            if  l-prim-txt = ? then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-pelo-issqn AS CHARACTER FORMAT "X(12)" NO-UNDO.
                {utp/ut-liter.i "Pelo_ISSQN" *}
                ASSIGN c-lbl-liter-pelo-issqn = TRIM(RETURN-VALUE).
                put c-lbl-liter-pelo-issqn AT i-posicao[8].
                assign l-prim-txt = NO.
            end.
            else
                if  l-prim-vlr = yes then do:
                    put doc-fiscal.vl-iss FORMAT ">>>>>>>9.99" at (i-posicao[8] - 1).
                    assign l-prim-vlr = no
                           l-prim-imp = no.
                end.                       
    END.

    put skip.

end.

/* esof0520F.P */ 


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
