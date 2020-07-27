/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520D 2.00.00.078 } /*** "010078" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520d MOF}
&ENDIF
 
/******************************************************************************
**
**  Programa: esof0520D.P
**
**  Data....: Maráo de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**
******************************************************************************/
{cdp/cdcfgdis.i}

/** EPC ****************************/
{include/i-epc200.i esof0520D}
DEF TEMP-TABLE tt-doctos-excluidos NO-UNDO
    FIELD rw-reg AS ROWID.
DEF TEMP-TABLE tt-itens-excluidos  NO-UNDO
    FIELD rw-reg AS ROWID.
/** EPC ****************************/

{ofp/esof0520.i shared}

{cdp/cd0620.i1 "' '"}

&if '{&bf_dis_versao_ems}' >= '2.04' &then
    def input param l-considera-icms-st as log no-undo.
&endif

def new shared temp-table tt-data no-undo
    field data as date.

def new shared temp-table tt-conta no-undo
    field cod-tributacao  as integer format "9"
    field conta-contabil  as character
    field aliquota-icms   as DECIMAL
    FIELD cfop            as character.  

def new shared var c-nome-emit like emitente.nome-emit no-undo.
DEF NEW SHARED VAR l-imp-dif-aliq AS LOG               NO-UNDO.

DEF NEW SHARED VAR l-tem-ipi-1 AS LOG NO-UNDO.
DEF NEW SHARED VAR l-tem-ipi-2 AS LOG NO-UNDO.
DEF NEW SHARED VAR l-tem-ipi-3 AS LOG NO-UNDO.

DEF NEW SHARED VAR de-vl-iss LIKE doc-fiscal.vl-iss NO-UNDO.

def shared var h-esof0520e          as handle               no-undo.
def shared var c-estado-estab     like estabelec.estado   no-undo.
DEF SHARED VAR l-consid-cfop-serv AS LOGICAL              NO-UNDO.

def var da-cont       as date.
def var i-primeira    as integer init 1.
def var l-subs        as logical init no.
def var da-aux        as date.
def var l-nome-imp    as logical init no.
def var l-ins-est-imp as logical init no.
def var de-obs        as decimal.
def var de-obs-tot    as decimal.  
def var l-sequencia   as logical   no-undo.
def var i-aux         as int       no-undo.
def var c-prim-aliq   as character no-undo.
def var l-soma        as log.
def var c-conta       as character no-undo format "x(20)".
def var i-num-linhas  as integer   no-undo.
def var h-acomp       as handle    no-undo.
def var i-aliquota    as integer   no-undo.
def var i-time-aux    as int       no-undo.
DEF VAR l-first-doc   AS LOG       NO-UNDO.

DEF VAR c-obs-aux     AS CHARACTER format "x(152)". 
DEF VAR l-nota-incentivada AS LOGICAL NO-UNDO.

def var ant-dt-docto      like doc-fiscal.dt-docto      no-undo.
def var ant-cod-estabel   like doc-fiscal.cod-estabel   no-undo.
def var ant-serie         like doc-fiscal.serie         no-undo.
def var ant-nr-doc-fis    like doc-fiscal.nr-doc-fis    no-undo.
def var ant-cod-emitente  like doc-fiscal.cod-emitente  no-undo.

DEFINE VARIABLE l-retorno AS LOGICAL INITIAL NO NO-UNDO.

def var l-item-ok      as logical  init no no-undo.
def var de-vl-tot-item like it-doc-fisc.vl-tot-item  no-undo. 

DEF VAR i-lncount AS INT NO-UNDO.
DEF VAR i-x       AS INT NO-UNDO.

def var de-sub-vl-icmsou-it like it-doc-fisc.vl-icmsou-it no-undo.
def var de-sub-vl-ipiou-it  like it-doc-fisc.vl-ipiou-it  no-undo.
def var de-sub-vl-icmsnt-it like it-doc-fisc.vl-icmsnt-it no-undo.
def var de-sub-vl-ipint-it  like it-doc-fisc.vl-ipint-it  no-undo.

DEF NEW SHARED VAR d-vl-icms-comp LIKE doc-fiscal.vl-icms-com NO-UNDO. /* Vari†vel definia para acumular valor do ICMS Retido sem a  opá∆o Separadores */ 

DEFINE VARIABLE h-esof0520f  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-esof0520f1 AS HANDLE NO-UNDO.

/* Funá∆o nf-ent-cancel-livro criada para gerar notas fiscais de entrada com emiss∆o pr¢pria canceladas nos Livros de Entradas e n∆o apresentar nos livros de sa°das */
DEF SHARED VAR l-funcao-nf-ent-cancel AS LOGICAL NO-UNDO.

if  not l-imp-for then
    assign c-fornecedor = "".         

if  not l-imp-cnpj then
    assign c-cgc-1 = "".

if  not l-imp-ins then
    assign c-ins-est = "".

for first param-of fields ( termo-ab-ent termo-en-ent )
    where param-of.cod-estabel = c-est-ini no-lock.
end.

find termo 
    where termo.te-codigo = param-of.termo-ab-ent no-lock.

find b-termo 
    where b-termo.te-codigo = param-of.termo-en-ent no-lock.

/* Este findÔs s∆o necess†rios para que n∆o ocorram erros */
/* na l¢gica para melhoria de performance destas tabelas. */

if  no then do:
    for first emitente fields() no-lock.
    end.

    for first natur-oper fields() no-lock.
    end.
end.

assign i-nivel        = 1
       de-aux         = 0
       de-obs         = 0
       d-vl-icms-comp = 0 
       c-linha-branco = "". 
       
if  i-op-rel = 1 then 
    assign i-posicao[1]  = 90 
           i-posicao[2]  = 95 
           i-posicao[3]  = 98 
           i-posicao[4]  = 99 
           i-posicao[5]  = 113
           i-posicao[6]  = 114
           i-posicao[7]  = 120
           i-posicao[8]  = 131
           i-posicao[9]  = 132
           /* posiá‰es sem separadores */
           i-posicao[10] = 83
           i-posicao[11] = 88
           i-posicao[12] = 103
           i-posicao[13] = 123
           i-posicao[14] = 123
           i-posicao[15] = 125.
else
    assign i-posicao[1] = 147
           i-posicao[2] = 161
           i-posicao[3] = 85
           i-posicao[4] = 108
           i-posicao[5] = 128
           i-posicao[6] = 142
           i-posicao[7] = 154
           i-posicao[8] = 156.
       
if  l-separadores then do:
    assign c-linha-branco = c-sep + fill(" ",8) + c-sep + fill(" ",3) +
           c-sep + fill(" ",5) + c-sep + fill(" ",9) + c-sep +
           fill(" ",8) + c-sep + fill(" ",9) + c-sep + fill(" ",2) +
           c-sep + fill(" ",14) + c-sep + fill(" ",15) + c-sep +
           fill(" ",6) + c-sep + fill(" ",4) + c-sep + fill(" ",3) +
           c-sep + fill(" ",14) + c-sep + fill(" ",5) + c-sep +
           fill(" ",11) + c-sep.
    if  i-op-rel = 2 then
        assign c-linha-branco = c-linha-branco + fill(" ",13) + c-sep +
               fill(" ",13) + c-sep.
end.

if  l-separadores then do:
    if  i-op-rel = 1 then do:
        DISP WITH frame f-cab-diag.
        VIEW frame f-bottom.
        DISP WITH frame f-scab-diag.
    end.
    else do:
        DISP WITH frame f-cab-diag-e.
        VIEW frame f-bottom-e.
        DISP WITH frame f-scab-diag-e.
    end.
end.
else do:
    if  i-op-rel = 1 then
        DISP WITH FRAME f-cab.
    else
        DISP WITH frame f-cab-exp.
end.

assign da-aux = date(month(da-est-fim),1,year(da-est-ini)).

/* variaveis de total */
assign de-tot-bicms   = 0 
       de-tot-icms    = 0
       de-tot-icmsnt  = 0
       de-tot-icmsou  = 0
       de-tot-bicmsub = 0
       de-tot-icmsub  = 0
       de-tot-bipi    = 0
       de-tot-ipi     = 0
       de-tot-ipint   = 0
       de-tot-ipiou   = 0
       de-tot-comple  = 0
       de-tot-obs     = 0.

for each tt-data:
    delete tt-data.
end.

do  da-cont = da-aux to da-est-ini - 1:
    create tt-data.
    assign tt-data.data = da-cont.
end.

&if '{&bf_dis_versao_ems}' >= '2.04' &then
    run ofp/esof0520i.p (INPUT l-considera-icms-st). 
&else
    run ofp/esof0520i.p.
&endif

if  l-periodo-ant then do:
    assign c-desc-tot      = c-linha-branco.
    overlay(c-desc-tot, integer(l-separadores) + 1)  = 
        "SUBTOTAL DE " + string(da-aux,"99/99/9999") +
        " A " + string(da-est-ini - 1,"99/99/9999").
    run ofp/esof0520c.p (input "RES ANT").
end.

if  da-est-ini <= da-icm-ini then 
    assign da-aux = da-est-ini.
else 
    assign da-aux = da-icm-ini.
    
if da-aux = ? then
   assign da-aux = da-est-ini.

assign de-aux     = 0
       de-obs     = 0
       de-obs-tot = 0 .

for each tt-data:
    delete tt-data.
end.

do  da-cont = da-aux to da-est-fim:
    create tt-data.
    assign tt-data.data = da-cont.
end.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Emiss∆o do Livro Registro de Entradas").

RUN ofp/esof0520f.p  PERSISTENT SET h-esof0520f.
RUN ofp/esof0520f1.p PERSISTENT SET h-esof0520f1.

IF NO THEN
    FOR FIRST param-of NO-LOCK: END.
    
/** EPC ****************************/
RUN piCreateEpcParameters.
RUN piSendEpcParameters.

RUN piCreateInitializePoint(1).
RUN piSendInitializePoint(1).
RUN piReadReceivedDataFromEpc(1).
/** EPC ****************************/

/* eliminacao do tt-conta do of0502f.p */ 
assign i-num-linhas = 0.
for EACH   tt-conta :
    delete tt-conta.
end.  

ASSIGN de-vl-tot-item = 0
       de-vl-ipi-it   = 0
       de-vl-bipi-it  = 0
       de-vl-ipint-it = 0
       de-vl-ipiou-it = 0
       l-item-ok      = no.

FOR EACH tt-estabelec,
    EACH tt-data,
    EACH  doc-fiscal USE-INDEX  ch-registro 
    WHERE doc-fiscal.dt-docto    = tt-data.data
    AND   doc-fiscal.cod-estabel = tt-estabelec.cod-estab
    AND (  (   (   doc-fiscal.tipo-nat    = 1 
                OR doc-fiscal.tipo-nat    = 3)
            AND    doc-fiscal.ind-sit-doc = 1)
         OR (    l-funcao-nf-ent-cancel   = YES
             AND doc-fiscal.tipo-nat      = 1 
             AND doc-fiscal.ind-sit-doc   = 2 ))

    /** EPC ****************************/
    AND   NOT CAN-FIND(FIRST tt-doctos-excluidos
                       WHERE tt-doctos-excluidos.rw-reg = ROWID(doc-fiscal))
    /** EPC ****************************/ 
    no-lock
    break by doc-fiscal.dt-docto
          by doc-fiscal.cod-estabel
          by doc-fiscal.serie
          by doc-fiscal.nr-doc-fis
          by doc-fiscal.cod-emitente
          by doc-fiscal.tipo-nat    
          BY doc-fiscal.esp-docto   
          &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
          BY doc-fiscal.cod-cfop
          &else
          BY trim(substr(doc-fiscal.char-1,1,10))
          &ENDIF:
          
    ASSIGN l-nota-incentivada = NO.

    IF  doc-fiscal.tipo-nat = 3 AND NOT l-consid-cfop-serv THEN NEXT.

    IF  doc-fiscal.tipo-nat = 3 AND
        &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
            doc-fiscal.cod-cfop <> "1933" AND
            doc-fiscal.cod-cfop <> "2933"
        &else
            trim(substr(doc-fiscal.char-1,1,10)) <> "1933" AND
            trim(substr(doc-fiscal.char-1,1,10)) <> "2933"
        &ENDIF THEN NEXT.
   
    /* Acompanhamento do programa de 3 em 3 segundos */
    if  time - i-time-aux >= 3 then do:
        assign i-time-aux = time.
        run pi-acompanhar in h-acomp (input doc-fiscal.nr-doc-fis).
    end.
    
    /* Definiá‰es para uso da include cdp/cd0620.i2 */
    {cdp/cd0620.i1 doc-fiscal.cod-estabel}.

    if not avail emitente
    or emitente.cod-emitente <> doc-fiscal.cod-emitente then
       for first emitente fields ( cod-emitente nome-emit )
           where emitente.cod-emitente = doc-fiscal.cod-emitente no-lock.
       
           assign c-nome-emit = emitente.nome-emit.
       end.
    
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> doc-fiscal.nat-operacao then
        for first natur-oper fields ( consum-final venda-ativo nat-operacao char-2 cd-trib-ipi usa-pick cd-trib-icm )
            where natur-oper.nat-operacao = doc-fiscal.nat-operacao  no-lock: 
        end.
            
    if  l-at-perm then do:
        if  not avail natur-oper 
        or  doc-fiscal.vl-icms = 0 then next.        
        IF  NOT natur-oper.consum-final
        OR  NOT natur-oper.venda-ativo THEN NEXT.
    end. 

    assign c-prim-aliq    = ""
           l-soma         = yes
           r-tt-tab-ocor  = ?
           de-obs         = 0.
    
    assign l-primeiro      = yes
           l-first-doc     = YES
           l-tem-ipi-1     = NO
           l-tem-ipi-2     = NO
           l-tem-ipi-3     = NO.

    /*** Quando existir uma nota de entrada, que foi quebrado em v†rios documentos em OF, por possuir v†rias naturezas de operaá∆o, e com a mesma CFOP (naturezas diferentes, com a mesma CFOP),
    e os itens da primeiro documento s∆o incentivado, e do segundo n∆o s∆o incentivados, n∆o imprimia o detalhamento do documento no livro. Isso ocorre 
    por causa do break by, onde o l-item-ok no momento da impress∆o ficava igual a "no". N∆o imprimia as informaá‰es relacionadas ao documento no arquivo. 
    A vari†vel l-item-ok ser† atualizada como NO na primeira quebra de cada CFOP, ou seja, se em algum momento encontrar um registro v†lida, ser† mantido como "yes", atÇ um nova CFOP.
    Dessa forma permitir† a impress∆o da informaá‰es do doducmento. ***/
    IF FIRST-OF(doc-fiscal.cod-cfop) THEN
       ASSIGN l-item-ok = no.

    ASSIGN l-imp-dif-aliq = YES.

    /****** Atencao *******/
    /* se houverem itens incentivados e nao incentivados no mesmo docto, o    */
    /* dif. de aliquota so devera ser impresso no livro de itens incentivados */

    IF  c-estado-estab = "PE"
    AND (   l-incentivado = NO
            AND CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))
         OR l-incentivado = YES
            AND NOT CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))   ) THEN
        ASSIGN l-imp-dif-aliq = NO.

    /** EPC ****************************/
    RUN piCreateInitializePoint(2).
    RUN piSendInitializePoint(2).
    RUN piReadReceivedDataFromEpc(2).
    /** EPC ****************************/

     /*--------- INICIO UPC ---------*/

    for each tt-epc where tt-epc.cod-event = "rowid-doc-fiscal":
        delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "rowid-doc-fiscal"
           tt-epc.cod-parameter = "rowid-doc-fiscal"
           tt-epc.val-parameter = string(ROWID(doc-fiscal)).
   {include/i-epc201.i "rowid-doc-fiscal"}
	
 	FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "rowid-doc-fiscal"
        AND   tt-epc.cod-parameter = "NOK":
        ASSIGN l-retorno = YES.
    END.

    IF l-retorno THEN
        NEXT.
    /*--------- FINAL UPC ---------*/

    FOR EACH it-doc-fisc OF doc-fiscal
        WHERE (c-estado-estab <> "PE" /* para estados <> "PE" considerar todos os itens */ 
               OR CAN-FIND(ITEM 
                           WHERE ITEM.it-codigo = it-doc-fisc.it-codigo
                           AND   ITEM.incentivado = l-incentivado)
               OR CAN-FIND (FIRST tt-itens-excluidos))
        /** EPC ****************************/
        AND   NOT CAN-FIND(FIRST tt-itens-excluidos
                           WHERE tt-itens-excluidos.rw-reg = ROWID(it-doc-fisc))
        /** EPC ****************************/
        NO-LOCK 
        BREAK BY it-doc-fisc.it-codigo
              BY it-doc-fisc.nr-seq-doc
              BY it-doc-fisc.aliquota-icm: /*it-doc-fisc.dec-1*/

        ASSIGN l-nota-incentivada = YES.

       IF l-first-doc THEN DO:
           ASSIGN l-first-doc = NO.
           ASSIGN d-vl-icms-comp = d-vl-icms-comp + doc-fiscal.vl-icms-com. /* Acumula valor do icms para documentos sumarizados */ 
           accumulate doc-fiscal.vl-icms-com (total).

           IF  doc-fiscal.tipo-nat = 3 THEN
               ACCUMULATE doc-fiscal.vl-iss (TOTAL).
       END.
       
       &if '{&bf_dis_versao_ems}' = '2.04' or '{&bf_dis_versao_ems}' = '2.05' &then
           if  l-considera-icms-st then
               assign de-vl-tot-item  = de-vl-tot-item + it-doc-fisc.vl-tot-item.
           else
               assign de-vl-tot-item  = de-vl-tot-item + (it-doc-fisc.vl-tot-item - it-doc-fisc.dec-2).
       &elseif '{&bf_dis_versao_ems}' >= '2.06' &then
           if  l-considera-icms-st then
               assign de-vl-tot-item  = de-vl-tot-item + it-doc-fisc.vl-tot-item.
           else
               assign de-vl-tot-item  = de-vl-tot-item + (it-doc-fisc.vl-tot-item - it-doc-fisc.val-icms-subst-entr).
       &else
           assign de-vl-tot-item  = de-vl-tot-item + it-doc-fisc.vl-tot-item.
       &endif
           
       assign l-item-ok       = yes
              de-vl-ipi-it    = de-vl-ipi-it    + it-doc-fisc.vl-ipi-it
              de-vl-bipi-it   = de-vl-bipi-it   + it-doc-fisc.vl-bipi-it
              de-vl-ipint-it  = de-vl-ipint-it  + (IF  doc-fiscal.tipo-nat = 3
                                                   AND AVAIL natur-oper 
                                                   AND natur-oper.usa-pick 
                                                   AND natur-oper.cd-trib-ipi = 2
                                                   THEN it-doc-fisc.vl-tot-item 
                                                   ELSE IF  doc-fiscal.tipo-nat <> 3
                                                            THEN it-doc-fisc.vl-ipint-it
                                                            ELSE 0)
              de-vl-ipiou-it  = de-vl-ipiou-it  + (IF  doc-fiscal.tipo-nat = 3
                                                     AND AVAIL natur-oper 
                                                     AND natur-oper.usa-pick 
                                                     AND natur-oper.cd-trib-ipi = 3
                                                     THEN it-doc-fisc.vl-tot-item 
                                                     ELSE IF  doc-fiscal.tipo-nat <> 3
                                                              THEN it-doc-fisc.vl-ipiou-it
                                                              ELSE 0).

       IF doc-fiscal.ind-sit-doc = 1 THEN DO:
          IF it-doc-fisc.cd-trib-ipi = 1 
          and (   it-doc-fisc.quantidade <> 0 
               OR (    it-doc-fisc.quantidade = 0 
                   AND doc-fiscal.vl-cont-doc = 0)) THEN 
              ASSIGN l-tem-ipi-1 = YES.
          
          IF it-doc-fisc.cd-trib-ipi = 2 AND (it-doc-fisc.vl-ipint-it <> 0 OR doc-fiscal.vl-cont-doc = 0) THEN ASSIGN l-tem-ipi-2 = YES.
          IF it-doc-fisc.cd-trib-ipi = 3 AND (it-doc-fisc.vl-ipiou-it <> 0 OR doc-fiscal.vl-cont-doc = 0) THEN ASSIGN l-tem-ipi-3 = YES.
          
           /* criacao de tt-conta para esof0520f.p */
           if  doc-fiscal.dt-docto >= da-est-ini then do: 
               {ofp/esof0520f.i1}
           end.
           
           if  doc-fiscal.dt-docto >= da-est-ini
           and doc-fiscal.dt-docto <= da-est-fim then do:
               assign l-subs  =    it-doc-fisc.vl-bsubs-it  > 0
                                or it-doc-fisc.vl-icmsub-it > 0
                      c-prim-aliq = if c-prim-aliq = "" 
                                    then string(it-doc-fisc.aliquota-icm /*it-doc-fisc.dec-1*/ ,"999.99")
                                    else c-prim-aliq.
          
               accumulate it-doc-fisc.vl-bicms-it  (total)
                          it-doc-fisc.vl-icms-it   (total)
                          it-doc-fisc.vl-icmsnt-it (total)
                          it-doc-fisc.vl-icmsou-it (total)
                          it-doc-fisc.vl-bipi-it   (total)
                          it-doc-fisc.vl-ipi-it    (total)
                          it-doc-fisc.vl-ipint-it  (total)
                          it-doc-fisc.vl-ipiou-it  (total)
                          it-doc-fisc.vl-bsubs-it  (total)
                          it-doc-fisc.vl-icmsub-it (total)
                          it-doc-fisc.vl-tot-item  (TOTAL).
          
               assign de-sub-vl-icmsou-it = de-sub-vl-icmsou-it + (IF  doc-fiscal.tipo-nat = 3 
                                                                   AND AVAIL natur-oper 
                                                                   AND natur-oper.cd-trib-icm = 3
                                                                       THEN it-doc-fisc.vl-tot-item 
                                                                       ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                                                THEN it-doc-fisc.vl-icmsou-it
                                                                                ELSE 0 )
                      de-sub-vl-icmsnt-it = de-sub-vl-icmsnt-it + (IF  doc-fiscal.tipo-nat = 3 
                                                                   AND AVAIL natur-oper 
                                                                   AND natur-oper.cd-trib-icm = 2
                                                                       THEN it-doc-fisc.vl-tot-item 
                                                                       ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                                                THEN it-doc-fisc.vl-icmsnt-it
                                                                                ELSE 0 )
                      de-sub-vl-ipint-it  = de-sub-vl-ipint-it  + (IF  doc-fiscal.tipo-nat = 3
                                                                   AND AVAIL natur-oper 
                                                                   AND natur-oper.usa-pick 
                                                                   AND natur-oper.cd-trib-ipi = 2
                                                                   THEN it-doc-fisc.vl-tot-item 
                                                                   ELSE IF  doc-fiscal.tipo-nat <> 3
                                                                            THEN it-doc-fisc.vl-ipint-it
                                                                            ELSE 0)
                      de-sub-vl-ipiou-it  = de-sub-vl-ipiou-it  + (IF  doc-fiscal.tipo-nat = 3
                                                                   AND AVAIL natur-oper 
                                                                   AND natur-oper.usa-pick 
                                                                   AND natur-oper.cd-trib-ipi = 3
                                                                   THEN it-doc-fisc.vl-tot-item 
                                                                   ELSE IF  doc-fiscal.tipo-nat <> 3
                                                                            THEN it-doc-fisc.vl-ipiou-it
                                                                            ELSE 0).
           end.
           
           /********************************************
            acumulo do periodo de icms
           *********************************************/
          
           if  l-tot-icm
           and (it-doc-fisc.dt-docto >= da-icm-ini
           and  it-doc-fisc.dt-docto <= da-icm-fim) then do:

               assign de-aux[1]  = de-aux[1]  + it-doc-fisc.vl-bicms-it
                      de-aux[2]  = de-aux[2]  + it-doc-fisc.vl-icms-it
                      de-aux[3]  = de-aux[3]  + (IF  doc-fiscal.tipo-nat = 3 
                                                 AND AVAIL natur-oper 
                                                 AND natur-oper.cd-trib-icm = 2
                                                     THEN it-doc-fisc.vl-tot-item 
                                                     ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                              THEN it-doc-fisc.vl-icmsnt-it
                                                              ELSE 0 )
                      de-aux[4]  = de-aux[4]  + (IF  doc-fiscal.tipo-nat = 3 
                                                 AND AVAIL natur-oper 
                                                 AND natur-oper.cd-trib-icm = 3
                                                     THEN it-doc-fisc.vl-tot-item 
                                                     ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                              THEN it-doc-fisc.vl-icmsou-it
                                                              ELSE 0 )
                      de-aux[7]  = de-aux[7]  + it-doc-fisc.vl-bipi-it
                      de-aux[8]  = de-aux[8]  + it-doc-fisc.vl-ipi-it
                      de-aux[9]  = de-aux[9]  + (IF  doc-fiscal.tipo-nat = 3
                                                 AND AVAIL natur-oper 
                                                 AND natur-oper.usa-pick 
                                                 AND natur-oper.cd-trib-ipi = 2
                                                 THEN it-doc-fisc.vl-tot-item 
                                                 ELSE IF  doc-fiscal.tipo-nat <> 3
                                                          THEN it-doc-fisc.vl-ipint-it
                                                          ELSE 0)
                      de-aux[10] = de-aux[10] + (IF  doc-fiscal.tipo-nat = 3
                                                 AND AVAIL natur-oper 
                                                 AND natur-oper.usa-pick 
                                                 AND natur-oper.cd-trib-ipi = 3
                                                 THEN it-doc-fisc.vl-tot-item 
                                                 ELSE IF  doc-fiscal.tipo-nat <> 3
                                                          THEN it-doc-fisc.vl-ipiou-it
                                                          ELSE 0).

               if l-subs or c-estado = "PE" then    
                   assign de-aux[5]  = de-aux[5] + it-doc-fisc.vl-bsubs-it
                          de-aux[6]  = de-aux[6] + it-doc-fisc.vl-icmsub-it.
           end.
           
           /************************************************ 
            gera resumo do periodo a ser impressao 
            dentro do periodo inicial e final digitado 
            *********************************************/ 
          
           if  it-doc-fisc.dt-docto >= da-est-ini then do:
          
               if  l-resumo-mes or l-resumo then do:
          
                   assign l-sequencia = yes.
                   if first-of(it-doc-fisc.nr-seq-doc) then
                   assign l-sequencia = no.
                   
                   {ofp/esof0520i.i2 no} /*antigo esof0520G.P*/
                   
               end.
               if ((l-documentos
               and l-subs) 
               or not l-documentos) 
               and l-resumo-mes then do:
               
                   {ofp/esof0520i.i3} /*antigo esof0520G1.P*/
                   
               end.
           END.
       
       /**** acumulo dos valores para o total *****/
       if  doc-fiscal.dt-docto >= da-est-ini
       and doc-fiscal.dt-docto <= da-est-fim then
           /* ICMS */
           assign de-tot-bicms    = de-tot-bicms   + it-doc-fisc.vl-bicms-it
                  de-tot-icms     = de-tot-icms    + it-doc-fisc.vl-icms-it
                  de-tot-icmsnt   = de-tot-icmsnt  + (IF  doc-fiscal.tipo-nat = 3 
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.cd-trib-icm = 2
                                                          THEN it-doc-fisc.vl-tot-item 
                                                          ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                                   THEN it-doc-fisc.vl-icmsnt-it
                                                                   ELSE 0 )
                  de-tot-icmsou   = de-tot-icmsou  + (IF  doc-fiscal.tipo-nat = 3 
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.cd-trib-icm = 3
                                                          THEN it-doc-fisc.vl-tot-item 
                                                          ELSE IF  doc-fiscal.tipo-nat <> 3 
                                                                   THEN it-doc-fisc.vl-icmsou-it
                                                                   ELSE 0 )
                  de-tot-bicmsub  = de-tot-bicmsub + it-doc-fisc.vl-bsubs-it
                  de-tot-icmsub   = de-tot-icmsub  + it-doc-fisc.vl-icmsub-it
                  /* IPI */      
                  de-tot-bipi     = de-tot-bipi    + it-doc-fisc.vl-bipi-it
                  de-tot-ipi      = de-tot-ipi     + it-doc-fisc.vl-ipi-it
                  de-tot-ipint    = de-tot-ipint   + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 2
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipint-it
                                                               ELSE 0)
                  de-tot-ipiou    = de-tot-ipiou   + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 3
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipiou-it
                                                               ELSE 0).
       END.
    END. /* for each it-doc-fisc */
    /*copiando a mesma observaá∆o para notas se observaá∆o quando item incentivado */
    /* Tratamento para imprimir a observaá∆o do documento fiscal */
    /* Foi necess†rio separar a leitura entre documento incentivado e n∆o incentivado, pois neste trecho s∆o lidas todas as notas */
    /* Desta forma caso seja lido um documento que possua observaá∆o e este n∆o seja impresso a sua observaá∆o ser† demonstrada para o outro docto que nem tem observaá∆o */
    IF  l-incentivado          = YES
    AND l-nota-incentivada     = YES 
    AND doc-fiscal.observacao <> "" THEN DO:
        ASSIGN c-obs-aux = c-obs-aux + " " + doc-fiscal.observacao.
    END.
    ELSE DO:
        IF  l-incentivado          = NO
        AND doc-fiscal.observacao <> "" THEN DO:
            ASSIGN c-obs-aux = c-obs-aux + " " + doc-fiscal.observacao.
        END.
    END.

    IF  doc-fiscal.dt-docto >= da-est-ini
    AND doc-fiscal.dt-docto <= da-est-fim THEN DO:
        /* gera tt-cred-com */         
        {ofp/esof0520i.i "(doc-fiscal.vl-icms)"
                       "RES PER"
                       "c-prim-aliq"}
    END.
 
    if  (c-estado = "SP"   /* Diferencial de aliquota de ICMS na coluna OBS */
    or  c-estado = "MG"
    or  c-estado = "PE" 
    or  c-estado = "BA"
    or  l-at-perm)
    and doc-fiscal.dt-docto >= da-est-ini
    and doc-fiscal.dt-docto <= da-est-fim then do:
        
        if  (c-estado = "PE" 
        or   c-estado = "MG")
        and doc-fiscal.cod-des-merc = 2
        and de-vl-ipiou-it > 0 then do:
            assign de-obs     =   de-vl-tot-item 
                              -  (de-vl-ipiou-it 
                              +   de-vl-ipint-it 
                              +   de-vl-bipi-it
                              +   de-vl-ipi-it)
                   de-obs     =  if  de-obs < 0 then
                                     0
                                 else 
                                     de-obs.
        end.
        assign 
               /* sub total */ 
               de-obs-tot    = de-obs-tot    + de-obs

               /* acumulo p/ total*/
               de-tot-obs    = de-tot-obs    + de-obs.

        IF l-imp-dif-aliq THEN
            ASSIGN de-aux[11]    = de-aux[11]    + doc-fiscal.vl-icms-com
                   de-tot-comple = de-tot-comple + doc-fiscal.vl-icms-com.
    end.
    
    if  l-tot-icm 
    and doc-fiscal.dt-docto > da-icm-fim  
    and not l-imprimiu-icm then do:
        assign l-imprimiu-icm = yes.

        run pi-verifica-linhas in h-esof0520e(1).
        if  not l-nova-pagina then
            if  i-op-rel = 1 then 
                put c-linha-branco at 1 format "x(132)" skip.
            else
                put c-linha-branco at 1 format "x(159)" skip.
    
        assign c-desc-tot      = c-linha-branco.
        overlay(c-desc-tot, integer(l-separadores) + 1)  = 
            "SUBTOTAL DE " + string(da-icm-ini,"99/99/9999") +
            " A " + string(da-icm-fim,"99/99/9999").
        run ofp/esof0520c.p (input "RES PER").
    
    end.
 
    /*** linha de detalhe do relatorio ->  imprime documentos ***/
    if  (   last-of(doc-fiscal.nr-doc-fis)   
         or last-of(doc-fiscal.cod-emitente)
         &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN
         OR last-of(doc-fiscal.cod-cfop)
         &else
         OR last-of(trim(substr(doc-fiscal.char-1,1,10) ) ) 
         &ENDIF
    /*or  last-of(doc-fiscal.nat-operacao)*/ ) 

    and doc-fiscal.dt-docto >= da-est-ini 
    and doc-fiscal.dt-docto <= da-est-fim 
    and l-item-ok /* indica que o documento possui itens dentro das condiá‰es de leitura */ then do:

        if  i-num-linhas = 0 then
            assign i-num-linhas = 1.
        if  l-separadores then
            run pi-imprime IN h-esof0520f1 (input rowid(doc-fiscal),
                                          input i-num-linhas,
                                          input de-obs,
                                          input de-vl-tot-item,
                                          input da-dt-cfop,
                                          INPUT-OUTPUT c-obs-aux). /* Observaá∆o do documento fiscal */ 
        else DO:
            run pi-imprime IN h-esof0520f (input rowid(doc-fiscal),
                                         input i-num-linhas,
                                         input de-obs,
                                         input de-vl-tot-item,
                                         input da-dt-cfop,
                                         INPUT-OUTPUT c-obs-aux). /* Observaá∆o do documento fiscal */
        END.

        ASSIGN de-vl-tot-item  = 0
               de-vl-ipi-it    = 0
               de-vl-bipi-it   = 0
               de-vl-ipint-it  = 0
               de-vl-ipiou-it  = 0
               d-vl-icms-comp  = 0.  
        
        run pi-verifica-linhas in h-esof0520e(1).
        if  not l-nova-pagina then
            if  i-op-rel = 1 then 
                put c-linha-branco at 1 format "x(132)" skip.
            else
                put c-linha-branco at 1 format "x(159)" skip.

        /* eliminacao do tt-conta do of0502f.p */ 
        assign i-num-linhas = 0.
        for each tt-conta :
            delete tt-conta.
        end.  

    end.
    ELSE IF doc-fiscal.dt-docto < da-est-ini THEN DO:
         ASSIGN de-vl-tot-item = 0
                de-vl-ipi-it   = 0
                de-vl-bipi-it  = 0
                de-vl-ipint-it = 0
                de-vl-ipiou-it = 0
                d-vl-icms-comp = 0. 
    END.
end.

run pi-finalizar in h-acomp.

DELETE PROCEDURE h-esof0520f.
DELETE PROCEDURE h-esof0520f1.

/***** impressao do sub total de icms *******/

if l-tot-icm and not l-imprimiu-icm then do:

    assign c-desc-tot      = c-linha-branco.
    overlay(c-desc-tot, integer(l-separadores) + 1)  = 
        "SUBTOTAL DE " + string(da-icm-ini,"99/99/9999") +
        " A " + string(da-icm-fim,"99/99/9999").
    run ofp/esof0520c.p (input "RES PER").
end.


/**** imprime sub-total ****/ 

/* acumula tt-cred-com */    
{ofp/esof0520i.i1 "where tt-cred-com.c-resumo = "
                "RES PER" }
/* display total periodo */
    
assign c-desc-tot      = c-linha-branco.
overlay(c-desc-tot, integer(l-separadores) + 1)  = 
   "SUBTOTAL DE " + string(da-est-ini,"99/99/9999") +
   " A " + string(da-est-fim,"99/99/9999").
{ofp/esof0520.i5}

assign de-aux = 0
       de-obs = 0
       de-obs-tot = 0

       /*** ICMS ***/
       de-aux[1]  = de-tot-bicms
       de-aux[2]  = de-tot-icms
       de-aux[3]  = de-tot-icmsnt
       de-aux[4]  = de-tot-icmsou
       de-aux[5]  = de-tot-bicmsub
       de-aux[6]  = de-tot-icmsub

       /*** IPI ***/
       de-aux[7]  = de-tot-bipi
       de-aux[8]  = de-tot-ipi
       de-aux[9]  = de-tot-ipint
       de-aux[10] = de-tot-ipiou
       /***********/
       de-aux[11] = de-tot-comple
       de-aux[12] = de-tot-obs
       de-sub-vl-icmsou-it = 0
       de-sub-vl-ipiou-it  = 0.

assign c-desc-tot      = c-linha-branco.

overlay(c-desc-tot, integer(l-separadores) + 1)  = 
    "TOTAL GERAL DE " + 
    string(da-est-ini - day(da-est-ini) + 1,"99/99/9999") +
    " A " + string(da-est-fim,"99/99/9999").
/* faz o display dos totais.  */
run ofp/esof0520c.p (input "TOTAL").

ASSIGN i-lncount = LINE-COUNTER.

DO i-x = i-lncount TO PAGE-SIZE - 1:
    put c-linha-branco at 1 format "x(132)" skip.
END.

/* esof0520D.P */

/** EPC ****************************/
PROCEDURE piCreateEpcParameters:
    DEF VAR cEvent AS CHAR NO-UNDO.
    ASSIGN cEvent = "Parametros":U.

    FOR EACH tt-epc
       WHERE tt-epc.cod-event = cEvent:
        DELETE tt-epc.
    END.
    FOR EACH tt-estabelec:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = cEvent
               tt-epc.cod-parameter = "cod-estabel":U
               tt-epc.val-parameter = tt-estabelec.cod-estab.
    END.
    FOR EACH tt-data:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = cEvent
               tt-epc.cod-parameter = "data":U
               tt-epc.val-parameter = STRING(tt-data.data).
    END.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = cEvent
           tt-epc.cod-parameter = "tipo-nat":U
           tt-epc.val-parameter = "1".
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = cEvent
           tt-epc.cod-parameter = "ind-sit-doc":U
           tt-epc.val-parameter = "1".
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
    DEF INPUT PARAMETER pPoint AS INT NO-UNDO.

    DEF VAR cEvent AS CHAR NO-UNDO.

    IF pPoint = 1 THEN DO:
       ASSIGN cEvent = "doc-fiscal-file":U.
    
       FOR EACH tt-epc
          WHERE tt-epc.cod-event = cEvent:
           DELETE tt-epc.
       END.
       CREATE tt-epc.
       ASSIGN tt-epc.cod-event     = cEvent
              tt-epc.cod-parameter = "all-doc-fiscal":U
              tt-epc.val-parameter = "*":U.
    END.
    
    IF pPoint = 2 THEN DO:
       ASSIGN cEvent = "doc-fiscal-reg":U.
       FOR EACH tt-epc
          WHERE tt-epc.cod-event = cEvent:
          DELETE tt-epc.
       END.
       CREATE tt-epc.
       ASSIGN tt-epc.cod-event     = cEvent
              tt-epc.cod-parameter = "rowid-doc-fiscal":U
              tt-epc.val-parameter = STRING(ROWID(doc-fiscal)).

    END.
END PROCEDURE. 

PROCEDURE piSendInitializePoint:
    DEF INPUT PARAMETER pPoint AS INT NO-UNDO.
    IF pPoint = 1 THEN DO:
       {include/i-epc201.i "doc-fiscal-file"}
    END.
    IF pPoint = 2 THEN DO:
       {include/i-epc201.i "doc-fiscal-reg"}
    END.
END PROCEDURE.

PROCEDURE piReadReceivedDataFromEpc:
    DEF INPUT PARAMETER pPoint AS INT NO-UNDO.
    DEF VAR raw-aux-1 AS RAW NO-UNDO.

    IF pPoint = 1 THEN DO:
        FOR EACH tt-doctos-excluidos:
           DELETE tt-doctos-excluidos.
        END.
        FOR EACH tt-epc
           WHERE tt-epc.cod-event     = "doc-fiscal-file":U 
             AND tt-epc.cod-parameter = "raw-doc-fiscal":U:
             RUN btb/btb928za.p (INPUT  tt-epc.val-parameter, 
                                 OUTPUT raw-aux-1).
             CREATE tt-doctos-excluidos.
             RAW-TRANSFER raw-aux-1 to tt-doctos-excluidos.
        END.
    END.

    IF pPoint = 2 THEN DO:
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
    END.

END PROCEDURE.
/** EPC ****************************/    

PROCEDURE pi-gerar-dados-extrato :
/* RUN  pi-gerar-dados-extrato ().*/
    def input param p-string as char no-undo.
    if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
        output to value(c-arquivo-log) append.
             put UNFORMATTED "==> " STRING(TIME,"HH:MM:SS") " - " ENTRY(1,PROGRAM-NAME(2), "") " - " p-string SKIP.
        output close. 
    end.
END PROCEDURE.
