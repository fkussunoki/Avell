/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540D 2.00.00.039 } /*** 010039 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0540d MOF}
&ENDIF

/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540D.P
**
**  Data....: Outubro de 1995
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**
******************************************************************************/
{cdp/cd0620.i1 "' '"}
{include/i-epc200.i esof0540d}
{cdp/cdcfgdis.i} /* pre-processador */
    
def shared var l-incentivado        AS logical   format "Sim/Nao"                          NO-UNDO. 
def shared var l-documentos         AS logical   format "Icms Substituto/Todos Documentos" NO-UNDO.
def shared var i-op-rel             AS integer   initial 1                                 NO-UNDO.
def shared var c-tot-res            AS character format "x(60)"                            NO-UNDO.
def shared var c-desc-tot           AS character format "x(62)"                            NO-UNDO.
def shared var l-tot-icm            AS logical   format "Sim/Nao"                          NO-UNDO.
def shared var l-imp-for            AS logical   format "Sim/Nao" init yes                 NO-UNDO.
def shared var l-imp-ins            AS logical   format "Sim/Nao"                          NO-UNDO.
def shared var h-acomp              AS handle                                              NO-UNDO.
def shared var h-esof0540e            AS handle                                              NO-UNDO.
def shared var l-icms-subst         AS logical                                             NO-UNDO.
DEF SHARED VAR l-consid-cfop-serv   AS LOGICAL                                             NO-UNDO.
def var i-primeira                  AS integer init 1                                      NO-UNDO.
def var l-subs                      AS logical init no                                     NO-UNDO.
def new shared var de-aux           AS decimal extent 13                                   NO-UNDO.
def new shared var de-auxi          AS decimal                                             NO-UNDO.
def var da-aux                      AS DATE                                                NO-UNDO.
def var i-inicio                    AS integer init 1                                      NO-UNDO.
def var l-nome-imp                  AS logical init no                                     NO-UNDO.
def var l-ins-est-imp               AS logical init no                                     NO-UNDO.
def var de-obs                      AS decimal                                             NO-UNDO.
def var de-obs-tot                  AS decimal                                             NO-UNDO.
def var c-prim-aliq                 AS character                                           NO-UNDO.
def var l-soma                      AS LOG                                                 NO-UNDO.
def var r-tt-tab-ocor               AS rowid                                               NO-UNDO.
DEF VAR de-vl-tot-item              AS DECIMAL                                             NO-UNDO.
def var de-sub-vl-icmsou-it         LIKE it-doc-fisc.vl-icmsou-it                          NO-UNDO.
def var de-sub-vl-ipiou-it          LIKE it-doc-fisc.vl-ipiou-it                           NO-UNDO.
def var de-sub-vl-icmsnt-it         LIKE it-doc-fisc.vl-icmsnt-it                          NO-UNDO.
def var de-sub-vl-ipint-it          LIKE it-doc-fisc.vl-ipint-it                           NO-UNDO.
/*** vari†veis do formato cfop ***/
def var c-formato-cfop              AS character                                           NO-UNDO.
def var i-formato-cfop              AS integer                                             NO-UNDO. 

def shared workfile w-auxi NO-UNDO
    field cfop        like doc-fiscal.nat-oper
    field valor       like doc-fiscal.vl-icms-com.

DEF NEW SHARED VAR l-imp-dif-aliq AS LOG NO-UNDO.

/* Funá∆o nf-ent-cancel-livro criada para gerar notas fiscais de entrada com emiss∆o pr¢pria canceladas nos Livros de Entradas e n∆o apresentar nos livros de sa°das */
DEF SHARED VAR l-funcao-nf-ent-cancel AS LOGICAL NO-UNDO.

{ofp/esof0540.i "shared"}

IF NO THEN
    FIND FIRST param-of NO-LOCK NO-ERROR.

assign de-aux     = 0
       de-auxi    = 0
       de-obs     = 0
       de-obs-tot = 0.

find estabelec where estabelec.cod-estabel = c-est-ini no-lock no-error.

IF NOT AVAIL param-of OR param-of.cod-estabel <> c-est-ini THEN
    find param-of where param-of.cod-estabel = c-est-ini no-lock.

find termo   where termo.te-codigo   = param-of.termo-ab-ent no-lock.
find b-termo where b-termo.te-codigo = param-of.termo-en-ent no-lock.
 
assign da-aux = date(month(da-est-fim),1,year(da-est-ini)).

/* Este find Ç necess†rio para que n∆o ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */
if  no then
    for first natur-oper fields() no-lock.
    end.

FOR EACH w-estabel,                             /* seleciona periodo anterior */
   EACH  doc-fiscal USE-INDEX ch-registro NO-LOCK 
   WHERE doc-fiscal.dt-docto   >= da-aux
   AND   doc-fiscal.dt-docto   <  da-est-ini
   AND   doc-fiscal.cod-estabel = w-estabel.cod-estab
   AND (  (   (   doc-fiscal.tipo-nat    = 1 
               OR doc-fiscal.tipo-nat    = 3)
           AND    doc-fiscal.ind-sit-doc = 1)
        OR (    l-funcao-nf-ent-cancel   = YES
            AND doc-fiscal.tipo-nat      = 1 
            AND doc-fiscal.ind-sit-doc   = 2 )):
     
    IF  doc-fiscal.tipo-nat = 3 AND NOT l-consid-cfop-serv THEN
        NEXT.

    IF  doc-fiscal.tipo-nat = 3 AND
        l-consid-cfop-serv      AND 
        &IF "{&bf_dis_Versao_ems}" >= "2.05" &THEN
            doc-fiscal.cod-cfop <> "1933" AND
            doc-fiscal.cod-cfop <> "2933"
        &else
            trim(substr(doc-fiscal.char-1,1,10)) <> "1933" AND
            trim(substr(doc-fiscal.char-1,1,10)) <> "2933"
        &ENDIF THEN NEXT.
    
    IF  c-estado = "PE" THEN
        IF NOT CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                        WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                       AND  item.incentivado = l-incentivado))
           THEN NEXT.

    /*********** Chamada EPC - filtra-documentos-entrada ***********/
    IF c-nom-prog-upc-mg97 <> "" THEN
    DO:
        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "filtra-documentos-entrada":U:
            DELETE tt-epc.
        END.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "filtra-documentos-entrada":U
               tt-epc.cod-parameter = "doc-fiscal-rowid":U
               tt-epc.val-parameter = STRING(ROWID(doc-fiscal)).

        {include/i-epc201.i "filtra-documentos-entrada"}

        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = "filtra-documentos-entrada":U
              AND tt-epc.cod-parameter = "origem-gfe":U:
        END.
        IF AVAIL tt-epc AND tt-epc.val-parameter = "Sim" THEN
            NEXT.
    END.
    /*********** Chamada EPC - filtra-documentos-entrada ***********/

    assign c-prim-aliq    = ""
           l-soma         = yes
           r-tt-tab-ocor  = ?
           de-vl-ipiou    = 0
           de-vl-tot-item = 0
           de-vl-ipint    = 0
           de-vl-ipi      = 0.
    
    ASSIGN l-imp-dif-aliq = YES.

    /****** Atencao *******/
    /* se houverem itens incentivados e nao incentivados no mesmo docto, o    */
    /* dif. de aliquota so devera ser impresso no livro de itens incentivados */

    IF  c-estado = "PE"
    AND (   l-incentivado = NO
            AND CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))
         OR l-incentivado = YES
            AND NOT CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))   ) THEN
        ASSIGN l-imp-dif-aliq = NO.

    {cdp/cd0620.i1 doc-fiscal.cod-estabel}
    {ofp/esof0540g.i "doc-fiscal.nat-operacao"}
    
    if  c-estado = "MG" 
    and doc-fiscal.vl-icms-com > 0 
    and doc-fiscal.vl-icms > 0
    AND l-imp-dif-aliq then do:
       
        assign de-auxi   = de-auxi + doc-fiscal.vl-icms-com.
       
        find first w-auxi where w-auxi.cfop = doc-fiscal.nat-oper no-error.
          if not avail w-auxi then
              create w-auxi.
          assign w-auxi.cfop  = doc-fiscal.nat-oper
                 w-auxi.valor = w-auxi.valor + doc-fiscal.vl-icms-com.
    end.
  
    IF doc-fiscal.ind-sit-doc = 1 THEN DO:
        FOR each it-doc-fisc of doc-fiscal no-lock
            where (c-estado <> "PE" /* para estados <> "PE" considerar todos os itens */ 
                           or can-find(item where item.it-codigo = it-doc-fisc.it-codigo
                                              and  item.incentivado = l-incentivado)) 
            break by it-doc-fisc.it-codigo
                  by it-doc-fisc.nr-seq-doc:
                
            run pi-acompanhar in h-acomp (input it-doc-fisc.nr-doc-fis).
            
            assign l-subs  = it-doc-fisc.vl-bsubs-it  > 0
                          or it-doc-fisc.vl-icmsub-it > 0
                   de-obs  = 0
                   c-prim-aliq = if c-prim-aliq = "" 
                                 then string(it-doc-fisc.aliquota-icm,"999.99") 
                                 else c-prim-aliq.
            accumulate it-doc-fisc.vl-merc-liq (total)
                       it-doc-fisc.vl-despes-it (total).
        
            ASSIGN de-aux[1]  = de-aux[1]  + it-doc-fisc.vl-bicms-it
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
                                                       ELSE 0)
                   de-aux[12] = de-aux[12] + de-obs.
        
            ASSIGN de-vl-ipiou    = de-vl-ipiou    + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 3
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipiou-it
                                                               ELSE 0)
                   de-vl-tot-item = de-vl-tot-item + it-doc-fisc.vl-tot-item
                   de-vl-ipint    = de-vl-ipint    + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 2
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipint-it
                                                               ELSE 0)
                   de-vl-ipi      = de-vl-ipi      + it-doc-fisc.vl-ipi-it.
        
            if l-subs or c-estado = "PE" then
                assign de-aux[5]  = de-aux[5] + it-doc-fisc.vl-bsubs-it
                       de-aux[6]  = de-aux[6] + it-doc-fisc.vl-icmsub-it.
        
            {ofp/esof0540.i1 "it-doc-fisc" "1" "249"}
        
            {ofp/esof0540.i10 "doc-fiscal" "it-doc-fisc"}
        END. /* for each it-doc-fis */
    END.

    IF doc-fiscal.cod-des-merc = 2
    AND de-vl-ipiou > 0 THEN DO:
        ASSIGN de-obs = de-vl-tot-item -
                        (ACCUM TOTAL it-doc-fisc.vl-merc-liq) -
                        de-vl-ipint - de-vl-ipi -
                        (ACCUM TOTAL it-doc-fisc.vl-despes-it)
               de-obs = IF de-obs < 0
                        THEN 0
                        ELSE de-obs
               de-obs-tot = de-obs-tot + de-obs.
    END.

    /*****************************************************************************
     o find abaixo serve apenas p/ obtencao do rowid do tt-tab-ocor com a primeira
     aliquota de icms, o qual e' utilizado no segundo find tt-tab-ocor logo abaixo
    ******************************************************************************/
    FIND FIRST tt-tab-ocor 
        WHERE  tt-tab-ocor.cod-tab = 249
        AND    tt-tab-ocor.c-campo[1] = c-cfop
        AND    tt-tab-ocor.c-campo[2] = c-usuario
        AND    tt-tab-ocor.c-campo[3] = "RES ANT"
        AND    tt-tab-ocor.c-campo[4] = doc-fiscal.nat-operacao
        AND    tt-tab-ocor.c-campo[5] = c-prim-aliq
        AND    tt-tab-ocor.l-campo[1] = YES NO-ERROR.  /* refere-se a ICMS */

    assign r-tt-tab-ocor = rowid(tt-tab-ocor).

    find first tt-tab-ocor where
        tt-tab-ocor.cod-tab    = 249
    and tt-tab-ocor.c-campo[1] = c-cfop
    and tt-tab-ocor.c-campo[2] = c-usuario
    and tt-tab-ocor.c-campo[3] = "RES ANT"
    and tt-tab-ocor.c-campo[4] = doc-fiscal.nat-operacao
    and tt-tab-ocor.c-campo[5] = string(r-tt-tab-ocor)
    and tt-tab-ocor.l-campo[1] = no no-error.  /* refere-se a IPI */
    if  (    c-estado = "SP"
         or  c-estado = "MG"
         or  c-estado = "PE")
    AND l-imp-dif-aliq then do:
        assign de-aux[11] = de-aux[11] + doc-fiscal.vl-icms-com.
        accumulate doc-fiscal.vl-icms-com (total).
        if avail tt-tab-ocor then
            assign tt-tab-ocor.descricao = 
                   string(decimal(tt-tab-ocor.descricao) +
                   doc-fiscal.vl-icms-com,">>>>>>>>>>>9.99")
                   tt-tab-ocor.i-campo[1]  = tt-tab-ocor.i-campo[1]  + (de-obs * 100).
    end.
    if c-estado = "MG" and
       doc-fiscal.vl-icms-com > 0 and
       doc-fiscal.vl-icms > 0 AND 
       l-imp-dif-aliq then do:
           assign de-auxi   = de-auxi + doc-fiscal.vl-icms-com.
           find first w-auxi where w-auxi.cfop = doc-fiscal.nat-oper no-error.
           if not avail w-auxi then
               create w-auxi.
           assign w-auxi.cfop  = doc-fiscal.nat-oper
                  w-auxi.valor = w-auxi.valor + doc-fiscal.vl-icms-com.
    END.
END.

if l-periodo-ant then do:
    assign c-desc-tot = "SUBTOTAL DE " + string(da-aux) + " A " +
                        string(da-est-ini - 1).
    run ofp/esof0540c.p.
    run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
    put skip(1).
end.
if da-est-ini <= da-icm-ini 
then da-aux = da-est-ini.
else da-aux = da-icm-ini.

if da-aux = ? then
   assign da-aux = da-est-ini.
assign de-aux = 0
       de-obs = 0.

if  l-imp-for = no then
    assign c-cgc-1      = ""
           c-fornecedor = "".
    
if  l-imp-ins = no then
    assign c-ins-est = "".

assign de-sub-vl-icmsou-it = 0   
       de-sub-vl-ipiou-it  = 0
       de-sub-vl-icmsnt-it = 0   
       de-sub-vl-ipint-it  = 0.  

FOR EACH w-estabel,
    EACH  doc-fiscal USE-INDEX ch-registro
    WHERE doc-fiscal.dt-docto  >= da-aux
    AND   doc-fiscal.dt-docto  <= da-est-fim
    AND   doc-fiscal.cod-estabel = w-estabel.cod-estab
    AND (  (   (   doc-fiscal.tipo-nat    = 1 
                OR doc-fiscal.tipo-nat    = 3)
            AND    doc-fiscal.ind-sit-doc = 1)
         OR (    l-funcao-nf-ent-cancel   = YES
             AND doc-fiscal.tipo-nat      = 1 
             AND doc-fiscal.ind-sit-doc   = 2 )) NO-LOCK 
    BREAK BY doc-fiscal.dt-docto
          BY doc-fiscal.cod-estabel
          BY doc-fiscal.serie
          BY doc-fiscal.nr-doc-fis
          BY doc-fiscal.cod-emitente
          BY doc-fiscal.nat-operacao:
    
    IF  doc-fiscal.tipo-nat = 3 AND NOT l-consid-cfop-serv THEN
        NEXT.

    IF  doc-fiscal.tipo-nat = 3 
    AND l-consid-cfop-serv      
    AND &IF "{&bf_dis_Versao_ems}" >= "2.05" &THEN 
            doc-fiscal.cod-cfop <> "1933" 
        AND doc-fiscal.cod-cfop <> "2933"
        &else
            trim(substr(doc-fiscal.char-1,1,10)) <> "1933" 
        AND trim(substr(doc-fiscal.char-1,1,10)) <> "2933"
        &ENDIF THEN NEXT.
        
    IF NOT AVAIL natur-oper
    OR natur-oper.nat-operacao <> doc-fiscal.nat-operacao then
        FOR FIRST natur-oper 
            WHERE natur-oper.nat-operacao = doc-fiscal.nat-operacao NO-LOCK:
        END.

    IF  c-estado = "PE" THEN
        IF NOT CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                        WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                       AND  item.incentivado = l-incentivado))
           THEN NEXT.

    /*********** Chamada EPC - filtra-documentos-entrada ***********/
    IF c-nom-prog-upc-mg97 <> "" THEN
    DO:
        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "filtra-documentos-entrada":U:
            DELETE tt-epc.
        END.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "filtra-documentos-entrada":U
               tt-epc.cod-parameter = "doc-fiscal-rowid":U
               tt-epc.val-parameter = STRING(ROWID(doc-fiscal)).

        {include/i-epc201.i "filtra-documentos-entrada"}

        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = "filtra-documentos-entrada":U
              AND tt-epc.cod-parameter = "origem-gfe":U:
        END.
        IF AVAIL tt-epc AND tt-epc.val-parameter = "Sim" THEN
            NEXT.
    END.
    /*********** Chamada EPC - filtra-documentos-entrada ***********/

    ASSIGN l-imp-dif-aliq = YES.

    /****** Atencao *******/
    /* se houverem itens incentivados e nao incentivados no mesmo docto, o    */
    /* dif. de aliquota so devera ser impresso no livro de itens incentivados */
    
    IF  c-estado = "PE"
    AND (   l-incentivado = NO
            AND CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))
         OR l-incentivado = YES
            AND NOT CAN-FIND(FIRST it-doc-fisc OF doc-fiscal
                         WHERE CAN-FIND(item WHERE item.it-codigo = it-doc-fisc.it-codigo
                                   AND  item.incentivado = YES))   ) THEN
        ASSIGN l-imp-dif-aliq = NO.

    {cdp/cd0620.i1 doc-fiscal.cod-estabel}

    assign c-prim-aliq = ""
           l-soma     = yes
           r-tt-tab-ocor = ?
           de-vl-ipiou = 0
           de-vl-tot-item = 0
           de-vl-ipint = 0
           de-vl-ipi = 0.

    IF doc-fiscal.ind-sit-doc = 1 THEN DO:
        FOR each it-doc-fisc of doc-fiscal no-lock
            where (c-estado <> "PE" /* para estados <> "PE" considerar todos os itens */
                           or can-find(item where item.it-codigo = it-doc-fisc.it-codigo
                                              and  item.incentivado = l-incentivado))
            break by it-doc-fisc.it-codigo
                  by it-doc-fisc.nr-seq-doc
                  by it-doc-fisc.aliquota-icm:
        
            run pi-acompanhar in h-acomp (input it-doc-fisc.nr-doc-fis).
        
            assign l-subs  = it-doc-fisc.vl-bsubs-it  > 0
                          or it-doc-fisc.vl-icmsub-it > 0
                   c-prim-aliq = if c-prim-aliq = ""
                                 then string(it-doc-fisc.aliquota-icm,"999.99")
                                 else c-prim-aliq.
            assign de-obs = 0.
        
            ASSIGN de-vl-ipiou    = de-vl-ipiou    + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 3
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipiou-it
                                                               ELSE 0)
                   de-vl-tot-item = de-vl-tot-item + it-doc-fisc.vl-tot-item
                   de-vl-ipint    = de-vl-ipint    + (IF  doc-fiscal.tipo-nat = 3
                                                      AND AVAIL natur-oper 
                                                      AND natur-oper.usa-pick 
                                                      AND natur-oper.cd-trib-ipi = 2
                                                      THEN it-doc-fisc.vl-tot-item 
                                                      ELSE IF  doc-fiscal.tipo-nat <> 3
                                                               THEN it-doc-fisc.vl-ipint-it
                                                               ELSE 0)
        
                   de-vl-ipi      = de-vl-ipi      + it-doc-fisc.vl-ipi-it.
        
            accumulate it-doc-fisc.vl-merc-liq (total)
                       it-doc-fisc.vl-despes-it (total).
        
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
            if  it-doc-fisc.dt-docto >= da-est-ini then do:
                {ofp/esof0540.i1 "it-doc-fisc" "2" "249"}
                {ofp/esof0540.i10 "doc-fiscal" "it-doc-fisc"}
            END.
        END. /* for each it-doc-fisc */
    END.

    if doc-fiscal.cod-des-merc = 2
    and de-vl-ipiou > 0 then do:
        assign de-obs = de-vl-tot-item -
                        (accum total it-doc-fisc.vl-merc-liq) -
                        de-vl-ipint - de-vl-ipi -
                        (accum total it-doc-fisc.vl-despes-it)
               de-obs = if de-obs < 0
                        then 0
                        else de-obs
               de-obs-tot = de-obs-tot + de-obs.
    end.
    assign de-aux[12] = de-aux[12] + de-obs.
/*****************************************************************************
 o find abaixo serve apenas p/ obtencao do rowid do tt-tab-ocor com a primeira
 aliquota de icms, o qual e' utilizado no segundo find tt-tab-ocor logo abaixo
******************************************************************************/

    FIND FIRST tt-tab-ocor 
        WHERE  tt-tab-ocor.cod-tab    = 249
        AND    tt-tab-ocor.c-campo[1] = c-cfop
        AND    tt-tab-ocor.c-campo[2] = c-usuario
        AND    tt-tab-ocor.c-campo[3] = "RES PER"
        AND    tt-tab-ocor.c-campo[4] = doc-fiscal.nat-operacao
        AND    tt-tab-ocor.c-campo[5] = c-prim-aliq
        AND    tt-tab-ocor.l-campo[1] = YES NO-ERROR.  /* refere-se a ICMS */
    
    ASSIGN r-tt-tab-ocor = rowid(tt-tab-ocor).

    find first tt-tab-ocor where
        tt-tab-ocor.cod-tab    = 249
    and tt-tab-ocor.c-campo[1] = c-cfop
    and tt-tab-ocor.c-campo[2] = c-usuario
    and tt-tab-ocor.c-campo[3] = "RES PER"
    and tt-tab-ocor.c-campo[4] = doc-fiscal.nat-operacao
    and tt-tab-ocor.c-campo[5] = string(r-tt-tab-ocor)
    and tt-tab-ocor.l-campo[1] = no no-error.  /* refere-se a IPI */
    if  (   c-estado = "SP"
         or c-estado = "MG"
         or c-estado = "PE")
    AND l-imp-dif-aliq then do:
        assign de-aux[11] = de-aux[11] + doc-fiscal.vl-icms-com.
        if  doc-fiscal.dt-docto >= da-est-ini then 
            accumulate doc-fiscal.vl-icms-com (total).
        if  avail tt-tab-ocor then 
            assign tt-tab-ocor.descricao = 
                   string(decimal(tt-tab-ocor.descricao) +
                   doc-fiscal.vl-icms-com,">>>>>>>>>>>9.99")
                   tt-tab-ocor.i-campo[1]  = tt-tab-ocor.i-campo[1]  + 
                   (de-obs * 100).
    end.
    if c-estado = "MG" and
       doc-fiscal.vl-icms-com > 0 and
       doc-fiscal.vl-icms > 0 AND
       l-imp-dif-aliq then do:
           assign de-auxi   = de-auxi + doc-fiscal.vl-icms-com.
           find first w-auxi where w-auxi.cfop = doc-fiscal.nat-oper no-error.
           if not avail w-auxi then
               create w-auxi.
           assign w-auxi.cfop  = doc-fiscal.nat-oper
                  w-auxi.valor = w-auxi.valor + doc-fiscal.vl-icms-com.
    end.        
    if  l-tot-icm 
    and doc-fiscal.dt-docto > da-icm-fim  
    and not l-imprimiu-icm then do:
    
        assign l-imprimiu-icm = yes.
        assign c-desc-tot = "SUBTOTAL DE " + string(da-icm-ini) +
                            " A " + string(da-icm-fim) + " "
               c-desc-tot = c-desc-tot + fill(".",62 - length(c-desc-tot)).
                
        if c-desc-tot <> "" then
           assign c-desc-tot = c-desc-tot +
                               fill(".",62 - length(c-desc-tot)).
        if i-op-rel = 1 then do:
           run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).
           put c-desc-tot   at   1
               "1"          at  82
               de-aux[1]    to  98  format ">>>>>>>>>9.99"
               de-aux[2]    to 115  format ">>>>>>>9.99".
           
           if  de-aux[11] > 0 then
               /* Inicio -- Projeto Internacional */
               DO:
               DEFINE VARIABLE c-lbl-liter-difaliqicms AS CHARACTER FORMAT "X(16)" NO-UNDO.
               {utp/ut-liter.i "Dif.Aliq.ICMS" *}
               ASSIGN c-lbl-liter-difaliqicms = TRIM(RETURN-VALUE).
               put c-lbl-liter-difaliqicms + "=" at 144 skip.
               END. 
               put "2"      at  82
               de-aux[3]    to  98  format ">>>>>>>>>9.99"
               0            to 115  format ">>>>>>>9.99".
           
           if  de-aux[11] > 0 then
               put "("              at 144
                   de-aux[11]       format ">>>>>>>>9.99"
                   ")"                  skip.
           put "3"          at  82
               de-aux[4]    to  98  format ">>>>>>>>>9.99"
               0            to 115  format ">>>>>>>9.99" skip.
        end.
        assign de-aux = 0
               de-obs = 0. /* nao retirar esta linha de comando */
        
        run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
        put skip(1).
    end.
       
    /* na situacao em que a
       data inicial de totalizacao de icms for menor que a da selecao*/
    if  doc-fiscal.dt-docto < da-est-ini then next.

    if  last-of(doc-fiscal.nr-doc-fis)
    or  last-of(doc-fiscal.cod-emitente)
    or  last-of(doc-fiscal.nat-operacao) then do:
        run ofp/esof0540f.p (input rowid(doc-fiscal),
                           INPUT da-dt-cfop).
    end.
end.

{ofp/esof0540.i5} /* display total periodo */

assign de-aux              = 0
       de-obs              = 0
       de-obs-tot          = 0.

for each  tt-tab-ocor 
    WHERE tt-tab-ocor.cod-tab    = 249
    AND   tt-tab-ocor.c-campo[2] = c-usuario
    AND   tt-tab-ocor.c-campo[3] <> "RESUMO"
    AND   tt-tab-ocor.l-campo[1] = yes no-lock
    BY    tt-tab-ocor.cod-ocor:

     assign de-aux[1]  = de-aux[1]  + tt-tab-ocor.de-campo[1]
            de-aux[2]  = de-aux[2]  + tt-tab-ocor.de-campo[2]
            de-aux[3]  = de-aux[3]  + tt-tab-ocor.de-campo[3]
            de-aux[4]  = de-aux[4]  + tt-tab-ocor.de-campo[4]
            de-aux[5]  = de-aux[5]  + tt-tab-ocor.de-campo[5].
end.

for each tt-tab-ocor where
         tt-tab-ocor.cod-tab = 249
     and tt-tab-ocor.c-campo[2] = c-usuario
     and tt-tab-ocor.c-campo[3] <> "RESUMO"
     and tt-tab-ocor.l-campo[1] = no no-lock
      by tt-tab-ocor.cod-ocor:

     assign de-aux[6]  = de-aux[6]  + tt-tab-ocor.de-campo[1]
            de-aux[7]  = de-aux[7]  + tt-tab-ocor.de-campo[2]
            de-aux[8]  = de-aux[8]  + tt-tab-ocor.de-campo[3]
            de-aux[9]  = de-aux[9]  + tt-tab-ocor.de-campo[4]
            de-aux[10] = de-aux[10] + tt-tab-ocor.de-campo[5]
            de-aux[11] = de-aux[11] + dec(tt-tab-ocor.descricao)
            de-aux[12] = de-aux[12] + (tt-tab-ocor.i-campo[1] / 100).
end.
run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
put skip(1).

assign c-desc-tot = "TOTAL GERAL " + 
            string(da-est-ini - day(da-est-ini) + 1,"99/99/99") 
            + " A " + string(da-est-fim) + " "
            c-desc-tot = c-desc-tot + fill(".",38 - length(c-desc-tot)).
run ofp/esof0540c.p. /* faz o display dos totais.  */
run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
put skip(1).

