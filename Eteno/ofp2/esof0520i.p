/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520I 2.00.00.044 } /*** 010044 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520i MOF}
&ENDIF
 
/******************************************************************************
**
**  Programa: esof0520I.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas  - Estouro de 63k do programa esof0520D.P
**
******************************************************************************/
/** EPC ****************************/
{include/i-epc200.i esof0520i}
DEF TEMP-TABLE tt-doctos-excluidos NO-UNDO
    FIELD rw-reg AS ROWID.
DEF TEMP-TABLE tt-itens-excluidos  NO-UNDO
    FIELD rw-reg AS ROWID.
/** EPC ****************************/

{ofp/esof0520.i shared} 
{cdp/cdcfgdis.i} /* Defini‡äes de pre-processadores */
{cdp/cd0620.i1 "' '"}

&if '{&bf_dis_versao_ems}' >= '2.04' &then
    def input param l-considera-icms-st as log no-undo.
&endif

def shared temp-table tt-data no-undo
    field data as date.

def shared var c-estado-estab       like estabelec.estado no-undo.
DEF SHARED VAR l-imp-dif-aliq       AS LOG                NO-UNDO.
DEF SHARED VAR l-consid-cfop-serv   AS LOGICAL            NO-UNDO.

def var c-prim-aliq   as character no-undo.
def var l-soma        as log.
def var l-subs        as logical init no.
def var de-obs        as decimal.
def var de-obs-tot    as decimal.
def var l-sequencia   as logical no-undo.
def var i-aliquota    as integer no-undo.
def var i-aux like tt-tab-ocor.i-campo1 no-undo.
def var de-vl-tot-item like it-doc-fisc.vl-tot-item  no-undo. 

/* Este find ‚ necess rio para que nÆo ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */

if  no then
    for first natur-oper fields() no-lock.
    end.
IF NO THEN
    FOR FIRST param-of NO-LOCK: END.

/** EPC ****************************/
RUN piCreateEpcParameters.
RUN piSendEpcParameters.

RUN piCreateInitializePoint(1).
RUN piSendInitializePoint(1).
RUN piReadReceivedDataFromEpc(1).
/** EPC ****************************/

for each tt-estabelec,
    each tt-data,
    each doc-fiscal fields (cod-estabel cod-emitente nr-doc-fis serie estado
                            pais nat-operacao vl-icms vl-icms-com cod-des-merc
                            vl-ipiou vl-cont-doc vl-ipint vl-bipi vl-ipi dt-docto char-1
                            &IF "{&bf_dis_Versao_ems}" >= "2.05" &THEN
                            cod-cfop
                            &endif tipo-nat)
    no-lock use-index ch-registro 
    where doc-fiscal.dt-docto    = tt-data.data
    and   doc-fiscal.cod-estabel = tt-estabelec.cod-estab
    and  (doc-fiscal.tipo-nat    = 1  OR /* yes */
          doc-fiscal.tipo-nat    = 3)
    and   doc-fiscal.ind-sit-doc = 1
    /** EPC ****************************/
    AND   NOT CAN-FIND(FIRST tt-doctos-excluidos
                       WHERE tt-doctos-excluidos.rw-reg = ROWID(doc-fiscal)):
    /** EPC ****************************/

    IF doc-fiscal.tipo-nat = 3 AND NOT l-consid-cfop-serv THEN
       NEXT.

    IF doc-fiscal.tipo-nat = 3 AND
       &IF "{&bf_dis_Versao_ems}" >= "2.05" &THEN
           doc-fiscal.cod-cfop <> "1933" AND
           doc-fiscal.cod-cfop <> "2933"
       &else
           trim(substr(doc-fiscal.char-1,1,10)) <> "1933" AND
           trim(substr(doc-fiscal.char-1,1,10)) <> "2933"
       &ENDIF THEN NEXT.

    /* novo cfop */
    {cdp/cd0620.i1 doc-fiscal.cod-estabel}

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> doc-fiscal.nat-operacao then
        for first natur-oper fields ( consum-final venda-ativo nat-operacao char-2 cd-trib-ipi usa-pick cd-trib-icm )
            where natur-oper.nat-operacao = doc-fiscal.nat-operacao  no-lock: 
        end.
            
    if  l-at-perm then do:
        if  not avail natur-oper 
        or  doc-fiscal.vl-icms = 0 then 
            next.        
        IF  NOT natur-oper.consum-final
        OR  NOT natur-oper.venda-ativo THEN
            NEXT.
    end.                                      

    assign c-prim-aliq     = ""
           l-soma          = yes
           r-tt-tab-ocor   = ?
           de-obs          = 0
           l-primeiro      = yes
           de-vl-tot-item  = 0
           de-vl-ipi-it    = 0
           de-vl-bipi-it   = 0
           de-vl-ipint-it  = 0
           de-vl-ipiou-it  = 0
           de-vl-bsubs-it  = 0
           de-vl-icmsub-it = 0.
  
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

    for each it-doc-fisc of doc-fiscal
        WHERE (c-estado-estab <> "PE" /* para estados <> "PE" considerar todos os itens */ 
               or can-find(item where item.it-codigo = it-doc-fisc.it-codigo
                           and  item.incentivado = l-incentivado)
               OR CAN-FIND (FIRST tt-itens-excluidos))
        /** EPC ****************************/
        AND   NOT CAN-FIND(FIRST tt-itens-excluidos
                           WHERE tt-itens-excluidos.rw-reg = ROWID(it-doc-fisc))
        /** EPC ****************************/
        no-lock
        break by it-doc-fisc.it-codigo
              by it-doc-fisc.nr-seq-doc:
            
        assign l-subs  = it-doc-fisc.vl-bsubs-it  > 0
                      or it-doc-fisc.vl-icmsub-it > 0
               c-prim-aliq = if c-prim-aliq = "" 
                                 then string(it-doc-fisc.aliquota-icm,"999.99") /*it-doc-fisc.dec-1*/
                                 else c-prim-aliq.

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
           
        assign de-vl-ipi-it    = de-vl-ipi-it    + it-doc-fisc.vl-ipi-it
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
                                                             ELSE 0)
               de-vl-bsubs-it  = de-vl-bsubs-it  + it-doc-fisc.vl-bsubs-it
               de-vl-icmsub-it = de-vl-icmsub-it + it-doc-fisc.vl-icmsub-it.

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

        if  l-subs or c-estado = "PE" then
            assign de-aux[5]  = de-aux[5] + it-doc-fisc.vl-bsubs-it
                   de-aux[6]  = de-aux[6] + it-doc-fisc.vl-icmsub-it.
        
        
        if  l-resumo-mes then do:
        
            assign l-sequencia = yes.
            if  first-of(it-doc-fisc.nr-seq-doc) then
                assign l-sequencia = no.

            {ofp/esof0520i.i2 yes} /*antigo esof0520G.P*/
            
            if ((l-documentos
            and l-subs) 
            or not l-documentos) then do:
                
                {ofp/esof0520i.i3} /*antigo esof0520G1.P*/                
                
            end.  
        end.

       /**** acumulo dos valores para o total *****/
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
    end.

    /*gera tt-cred-com */ 
        
    {ofp/esof0520i.i "(accum total it-doc-fisc.vl-icms-it)"
                   "RES ANT"
                   "c-prim-aliq"} 
 
    if  c-estado = "SP"
    or  c-estado = "MG"
    or  c-estado = "PE" 
    or  c-estado = "BA" then do:
       
        accumulate doc-fiscal.vl-icms-com (total).

        if  (  c-estado = "PE" 
            or c-estado = "MG")
        and doc-fiscal.cod-des-merc = 2
        and de-vl-ipiou-it > 0 then do:
            assign de-obs     =   de-vl-tot-item 
                              -  (de-vl-ipiou-it 
                              +   de-vl-ipint-it 
                              +   de-vl-bipi-it
                              +   de-vl-ipi-it)
                   de-obs     =  if  de-obs < 0 then 0 else de-obs.
        end.
        assign de-aux[12]     = de-aux[12] + de-obs

               /** acumulo para  total **/
               de-tot-obs     =  de-tot-obs    + de-obs.

        IF l-imp-dif-aliq THEN
            ASSIGN de-aux[11]    = de-aux[11] + doc-fiscal.vl-icms-com
                   de-tot-comple =  de-tot-comple + doc-fiscal.vl-icms-com.

    end.
end.

/* esof0520i.p */ 
                            
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

