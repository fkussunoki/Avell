DEF VAR l-ok AS LOGICAL.

DEF TEMP-TABLE tt-detalhe
    FIELD cod-empresa      LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel      LIKE movto-estoq.cod-estabel
    FIELD ct-codigo        LIKE movto-estoq.ct-codigo
    FIELD sc-codigo        LIKE movto-estoq.sc-codigo
    FIELD esp-docto        LIKE movto-estoq.esp-docto
    FIELD serie-docto      LIKE movto-estoq.serie-docto
    FIELD it-codigo        LIKE movto-estoq.it-codigo
    FIELD ge-codigo        LIKE item.ge-codigo
    FIELD compr-fabric     LIKE item.compr-fabric
    FIELD quantidade       LIKE movto-estoq.quantidade FORMAT "->>>,>>>9.9999"
    FIELD valor            AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    INDEX ch-principal IS PRIMARY cod-empresa ASCENDING
                                  cod-estabel ASCENDING
                                  sc-codigo   ASCENDING
                                  ct-codigo   ASCENDING
                                  esp-docto   ASCENDING
                                  serie-docto ASCENDING
                                  it-codigo   ASCENDING.

DEF TEMP-TABLE tt-resumido
    FIELD cod-empresa    LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD ct-codigo      AS CHAR FORMAT 'X(20)'
    FIELD cc-codigo      LIKE dc-lin-prod.cc-codigo
    FIELD quantidade     AS DECIMAL             COLUMN-LABEL "Quantidade"  FORMAT "->>>,>>>,>>9.99"
    FIELD valor-total    AS DECIMAL             COLUMN-LABEL "Valor Total" FORMAT "->>>,>>>,>>9.99"
    FIELD vl-mes-ant     AS DECIMAL             COLUMN-LABEL "Vl Mes Ant." FORMAT "->>>,>>>,>>9.99"
    INDEX ch-principal IS UNIQUE PRIMARY cod-empresa ASCENDING
                                         cod-estabel ASCENDING
                                         ct-codigo   ASCENDING
                                         cc-codigo   ASCENDING.

DEF TEMP-TABLE tt-erro              NO-UNDO
    FIELD des_erro                  AS   CHARACTER      FORMAT 'x(80)'.

{include/tt-edit.i}
{include/pi-edit.i}

DEF NEW SHARED STREAM s_1.

DEF VAR dt-for             AS DATE FORMAT '99/99/9999'.
DEF BUFFER b-item          FOR ITEM.

DEF NEW SHARED VAR i-emp-s LIKE empresa.cod_empresa.
DEF NEW SHARED VAR c-ref-s LIKE lin-doc-pend.referencia.
DEF VAR ct-cod-cr       LIKE conta-contab.ct-codigo.
DEF VAR sc-cod-cr       LIKE conta-contab.sc-codigo.
DEF VAR c-esp-fundicao  AS CHAR FORMAT "x(03)" CASE-SENSITIVE INIT "REQ".
def var da-ant          as date.
def var l-resp          as lo format "Sim/Nao".
def var l-contabiliza   as lo format "Sim/Nao" init yes.
def var c-referencia    like doc-pendente.referencia.
def var l-erro-referencia as log.

FOR EACH tt-resumido:
    DELETE tt-resumido.
END.
IF rt-tipo-relat = 2 THEN DO:
   FOR EACH tt-detalhe:
       DELETE tt-detalhe.
   END.
END.
       
FIND FIRST plano_cta_ctbl NO-LOCK
     WHERE plano_cta_ctbl.dat_inic_valid        <= TODAY          
       AND plano_cta_ctbl.dat_fim_valid         >= TODAY 
       AND plano_cta_ctbl.ind_tip_plano_cta_ctbl = 'Prim rio' NO-ERROR.

FIND FIRST plano_ccusto NO-LOCK USE-INDEX plnccst_id
     WHERE plano_ccusto.cod_empresa      = empresa.cod_empresa 
       AND plano_ccusto.dat_inic_valid  <= TODAY
       AND plano_ccusto.dat_fim_valid   >= TODAY NO-ERROR.

FIND FIRST histor_finalid_econ NO-LOCK 
     WHERE histor_finalid_econ.cod_finalid_econ       = 'Corrente' 
       AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
       AND histor_finalid_econ.dat_fim_valid_finalid  >= TODAY NO-ERROR.

IF AVAIL plano_cta_ctbl THEN DO:

   FIND FIRST empresa NO-LOCK USE-INDEX empresa_id
        WHERE empresa.cod_empresa = c-cod-empresa NO-ERROR.
   IF AVAIL empresa THEN DO:
      
      DO dt-for = dt-periodo-ini TO dt-periodo-fin:

         RUN pi-acompanhar IN h-acomp ('Movto Estoque Data: ' + STRING(dt-for)).
         
         FOR EACH movto-estoq NO-LOCK USE-INDEX data-conta 
            WHERE movto-estoq.dt-trans       = dt-for 
              AND movto-estoq.conta-contabil = string(ct-trans-ord-prod-mat + '00000'): /*Conta Transit¢ria das Ordens de Produ‡Æo de Materiais*/ 
            
             l-ok = NO.
             IF SUBSTRING(STRING(movto-estoq.descricao-db),11,10)  = "0107100"  OR
                movto-estoq.it-codigo = "0107100"   OR
                 SUBSTRING(STRING(movto-estoq.descricao-db),11,10)  = "1919400"  OR
                movto-estoq.it-codigo = "1919400"   then
                 l-ok = YES.

            IF NOT l-ok THEN  NEXT.
             
            IF LOOKUP(movto-estoq.cod-estabel,c-lista-cod-estab) = 0 THEN NEXT.

            FIND FIRST ITEM NO-LOCK
                 WHERE item.it-codigo = movto-estoq.it-codigo NO-ERROR.

            IF AVAIL ITEM             AND 

               ITEM.compr-fabric = 2 THEN NEXT. /* 1- Comprado 2- Fabricado */

            IF ITEM.un  =  "dm" THEN NEXT.

            IF {ininc/i03in218.i 04 movto-estoq.esp-docto} <> 'DIV' AND 
               {ininc/i03in218.i 04 movto-estoq.esp-docto} <> 'RRQ' AND
               {ininc/i03in218.i 04 movto-estoq.esp-docto} <> 'REQ' THEN NEXT.
                 
            IF {ininc/i03in218.i 04 movto-estoq.esp-docto} = 'DIV' THEN  /* S‚ries de Documento para GGF */
               IF INDEX(c-lista-serie-ggf,movto-estoq.serie-docto) = 0 THEN NEXT.

            IF {ininc/i03in218.i 04 movto-estoq.esp-docto} <> 'REQ' AND 
               movto-estoq.nat-operacao                    <> '' THEN NEXT.

            IF INDEX(c-lista-itens,item.it-codigo) <> 0 THEN NEXT.
            
            ASSIGN cc-codigo-db = ''.
            
            FIND FIRST ord-prod NO-LOCK 
                 WHERE ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ NO-ERROR.
            IF NOT AVAIL ord-prod THEN DO:
               RUN MESSAGE.p ('NÆo achou ordem de produ‡Æo',
                              'NÆo achou a ordem de produ‡Æo ' + STRING(movto-estoq.nr-ord-prod)).
               NEXT.
            END.

            IF AVAIL ord-prod THEN
               FIND FIRST lin-prod OF ord-prod NO-LOCK NO-ERROR.

            IF cc-codigo-db = '' THEN DO:
               IF AVAIL lin-prod THEN
                  IF {ininc/i01in186.i 04 lin-prod.sum-requis} = 'Ordem de Servi‡o' THEN NEXT.
               FIND FIRST dc-lin-prod NO-LOCK
                    WHERE dc-lin-prod.nr-linha = ord-prod.nr-linha NO-ERROR.
               IF AVAIL dc-lin-prod THEN  
                  IF dc-lin-prod.cc-codigo = '0' OR
                     dc-lin-prod.cc-codigo = ''  THEN DO:
                     PUT ord-prod.nr-linha AT 01
                         'Centro de Custo da linha igual a branco ou zero!'.
                  END.
               IF NOT AVAIL dc-lin-prod THEN DO:
                  ASSIGN cc-codigo-db = ''.
                  PUT ord-prod.nr-linha AT 01
                      'Centro de Custo da linha igual a branco ou zero!'.
                  CREATE dc-lin-prod.
                  ASSIGN dc-lin-prod.nr-linha    = ord-prod.nr-linha
                         dc-lin-prod.cc-codigo   = cc-codigo-db.
               END.
               ELSE
                  ASSIGN cc-codigo-db = dc-lin-prod.cc-codigo.
            END. /* if cc-codigo-db */

            IF ITEM.ge-codigo = i-gr-estoq-db-dir THEN DO: /* item de d‚bito direto */
               FIND FIRST b-item NO-LOCK 
                    WHERE b-item.it-codigo = SUBSTRING(STRING(movto-estoq.descricao-db),11,10) NO-ERROR.
               IF LOOKUP(string(b-item.ge-codigo),c-gr-estoq-mat-prima)  <> 0 
                  THEN ASSIGN c-ct-codigo-db = ct-mat-prima.
                  ELSE IF LOOKUP(STRING(b-item.ge-codigo),c-gr-estoq-mat-secund) <> 0 
                          THEN ASSIGN c-ct-codigo-db = ct-mat-secund.
                          ELSE IF LOOKUP(STRING(b-item.ge-codigo),c-gr-estoq-mat-embal)  <> 0 
                                  THEN ASSIGN c-ct-codigo-db = ct-mat-embal.
                                  ELSE DO:
                                      IF b-item.ge-codigo = 80 THEN NEXT. /* Solicita‡Æo da Marilza em 06/04/2004 */
                                      RUN MESSAGE.p ('NÆo achou conta cont bil',
                                                     'Grupo Estoque: ' + string(b-item.ge-codigo) + ' - OP: ' + STRING(movto-estoq.nr-ord-produ) + ' ser  usada conta ' + ct-mat-prima).
                                      ASSIGN c-ct-codigo-db = ct-mat-prima.
                                  END.
            END.
            ELSE DO: /* itens de estoque que nao sao debito direto */
               IF LOOKUP(STRING(ITEM.ge-codigo),c-gr-estoq-mat-prima) <> 0 
                  THEN ASSIGN c-ct-codigo-db = ct-mat-prima.
                  ELSE IF LOOKUP(STRING(ITEM.ge-codigo),c-gr-estoq-mat-secund) <> 0
                          THEN ASSIGN c-ct-codigo-db = ct-mat-secund.
                          ELSE IF LOOKUP(STRING(item.ge-codigo),c-gr-estoq-mat-embal)  <> 0
                                  THEN ASSIGN c-ct-codigo-db = ct-mat-embal.
                                  ELSE DO:
                                      IF item.ge-codigo = 80 THEN NEXT. /* Solicita‡Æo da Marilza em 06/04/2004 */
                                      RUN MESSAGE.p ('NÆo achou conta cont bil',
                                                     'Grupo Estoque: ' + string(item.ge-codigo) + ' - OP: ' + STRING(movto-estoq.nr-ord-produ)).
                                      ASSIGN c-ct-codigo-db = ''.
                                  END.
            END.
                 
            FIND tt-resumido 
                 WHERE tt-resumido.cod-empresa = empresa.cod_empresa               
                   AND tt-resumido.cod-estabel = movto-estoq.cod-estabel 
                   AND tt-resumido.ct-codigo   = c-ct-codigo-db   
                   AND tt-resumido.cc-codigo   = cc-codigo-db NO-ERROR.
            IF NOT AVAIL tt-resumido THEN DO:
               CREATE tt-resumido.
               ASSIGN tt-resumido.cod-empresa = empresa.cod_empresa
                      tt-resumido.cod-estabel = movto-estoq.cod-estabel
                      tt-resumido.ct-codigo   = c-ct-codigo-db  
                      tt-resumido.cc-codigo   = cc-codigo-db.
            END.

            FIND item-estab NO-LOCK
                 WHERE item-estab.it-codigo   = movto-estoq.it-codigo
                   AND item-estab.cod-estabel = movto-estoq.cod-estabel NO-ERROR.

            IF movto-estoq.tipo-trans = 1 THEN /*Entrada*/
               ASSIGN tt-resumido.quantidade  = tt-resumido.quantidade  + movto-estoq.quantidade
                      tt-resumido.valor-total = tt-resumido.valor-total + movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]
                      tt-resumido.vl-mes-ant  = tt-resumido.vl-mes-ant  + movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1]).
            ELSE
               ASSIGN tt-resumido.quantidade  = tt-resumido.quantidade  - movto-estoq.quantidade
                      tt-resumido.valor-total = tt-resumido.valor-total - movto-estoq.valor-mat-m[1] - movto-estoq.valor-mob-m[1] - movto-estoq.valor-ggf-m[1]
                      tt-resumido.vl-mes-ant  = tt-resumido.vl-mes-ant  - movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] - item-estab.val-unit-ggf-m[1]).

            IF rt-tipo-relat = 2 THEN DO:
               FIND FIRST tt-detalhe NO-LOCK
                    WHERE tt-detalhe.cod-empresa   = emsuni.empresa.cod_empresa
                      AND tt-detalhe.cod-estabel   = movto-estoq.cod-estabel
                      AND tt-detalhe.ct-codigo     = c-ct-codigo-db
                      AND tt-detalhe.sc-codigo     = cc-codigo-db
                      AND tt-detalhe.esp-docto     = movto-estoq.esp-docto
                      AND tt-detalhe.serie-docto   = movto-estoq.serie-docto
                      AND tt-detalhe.it-codigo     = IF AVAIL b-item 
                                                        THEN b-item.it-codigo
                                                        ELSE movto-estoq.it-codigo NO-ERROR.
               IF NOT AVAIL tt-detalhe THEN DO:
                    DISP "ponto 1" 
                        movto-estoq.it-codigo
                       int(movto-estoq.esp-docto)
                       movto-estoq.serie-docto
                       movto-estoq.quantidade   
                       movto-estoq.nr-ord-prod   SKIP.
                  CREATE tt-detalhe.
                  ASSIGN tt-detalhe.cod-empresa   = emsuni.empresa.cod_empresa
                         tt-detalhe.cod-estabel   = movto-estoq.cod-estabel
                         tt-detalhe.ct-codigo     = c-ct-codigo-db
                         tt-detalhe.sc-codigo     = cc-codigo-db
                         tt-detalhe.esp-docto     = movto-estoq.esp-docto 
                         tt-detalhe.serie-docto   = movto-estoq.serie-docto
                         tt-detalhe.it-codigo     = IF AVAIL b-item 
                                                       THEN b-item.it-codigo
                                                       ELSE ITEM.it-codigo
                         tt-detalhe.ge-codigo     = IF AVAIL b-item
                                                       THEN b-item.ge-codigo
                                                       ELSE ITEM.ge-codigo
                         tt-detalhe.compr-fabric  = IF AVAIL b-item
                                                       THEN b-item.compr-fabric
                                                       ELSE ITEM.compr-fabri.
                         
               END.
               ASSIGN tt-detalhe.quantidade  = tt-detalhe.quantidade + IF movto-estoq.tipo-trans = 1 
                                                                          THEN movto-estoq.quantidade 
                                                                          ELSE movto-estoq.quantidade * - 1
                      tt-detalhe.valor       = tt-detalhe.valor      + IF movto-estoq.tipo-trans = 1 
                                                                          THEN (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) 
                                                                          ELSE (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) * - 1.
            END.
         END. /* for each movoto-estoque */

         
         /* L¢gica para Fundi‡Æo */
         FOR EACH  movto-estoq NO-LOCK USE-INDEX data-conta 
            WHERE  movto-estoq.dt-trans       = dt-for 
              AND  movto-estoq.conta-contabil = string(ct-trans-ord-prod-mat + '00000') /*Conta Transit¢ria das Ordens de Produ‡Æo de Materiais*/ 
              AND  movto-estoq.nat-operacao   = ''
              AND  movto-estoq.cod-emitente   = 0
              AND  movto-estoq.nr-ord-produ  <> 0
              AND  movto-estoq.nr-reporte     = 0
              AND ({ininc/i03in218.i 04 movto-estoq.esp-docto} = 'REQ' OR {ininc/i03in218.i 04 movto-estoq.esp-docto} = 'DEV'):
           
            IF movto-estoq.dt-trans < 01/01/2004 AND movto-estoq.serie-docto <> 'lig' THEN NEXT.
            
            IF movto-estoq.it-codigo = '0107200' 
               THEN ASSIGN cc-codigo-db = '45510'.
               ELSE ASSIGN cc-codigo-db = '45530'.
            
            ASSIGN c-ct-codigo-db = ct-db-requis-ordem.

            FIND tt-resumido 
                 WHERE tt-resumido.cod-empresa = empresa.cod_empresa               
                   AND tt-resumido.cod-estabel = movto-estoq.cod-estabel 
                   AND tt-resumido.ct-codigo   = c-ct-codigo-db   
                   AND tt-resumido.cc-codigo   = cc-codigo-db NO-ERROR.
            IF NOT AVAIL tt-resumido THEN DO:
               CREATE tt-resumido.
               ASSIGN tt-resumido.cod-empresa = empresa.cod_empresa
                      tt-resumido.cod-estabel = movto-estoq.cod-estabel
                      tt-resumido.ct-codigo   = c-ct-codigo-db  
                      tt-resumido.cc-codigo   = cc-codigo-db.
            END.

            FIND item-estab NO-LOCK
                 WHERE item-estab.it-codigo   = movto-estoq.it-codigo
                   AND item-estab.cod-estabel = movto-estoq.cod-estabel NO-ERROR.

            IF movto-estoq.tipo-trans = 1 THEN /*Entrada*/
               ASSIGN tt-resumido.quantidade  = tt-resumido.quantidade + movto-estoq.quantidade
                      tt-resumido.valor-total = tt-resumido.valor-total + movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]
                      tt-resumido.vl-mes-ant  = tt-resumido.vl-mes-ant + movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1]).
            ELSE
               ASSIGN tt-resumido.quantidade  = tt-resumido.quantidade - movto-estoq.quantidade
                      tt-resumido.valor-total = tt-resumido.valor-total - movto-estoq.valor-mat-m[1] - movto-estoq.valor-mob-m[1] - movto-estoq.valor-ggf-m[1]
                      tt-resumido.vl-mes-ant  = tt-resumido.vl-mes-ant - movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] - item-estab.val-unit-ggf-m[1]).

            IF rt-tipo-relat = 2 THEN DO:
               FIND FIRST tt-detalhe NO-LOCK
                    WHERE tt-detalhe.cod-empresa   = emsuni.empresa.cod_empresa
                      AND tt-detalhe.cod-estabel   = movto-estoq.cod-estabel
                      AND tt-detalhe.ct-codigo     = c-ct-codigo-db
                      AND tt-detalhe.sc-codigo     = cc-codigo-db
                      AND tt-detalhe.esp-docto     = movto-estoq.esp-docto
                      AND tt-detalhe.serie-docto   = movto-estoq.serie-docto
                      AND tt-detalhe.it-codigo     = movto-estoq.it-codigo NO-ERROR.
               IF NOT AVAIL tt-detalhe THEN DO:
                    DISP "ponto 2"
                        movto-estoq.it-codigo
                       int(movto-estoq.esp-docto)
                       movto-estoq.serie-docto
                       movto-estoq.quantidade   
                       movto-estoq.nr-ord-prod   SKIP.
                    /*** nao usa o b-item  ****/
                  CREATE tt-detalhe.
                  ASSIGN tt-detalhe.cod-empresa   = emsuni.empresa.cod_empresa    
                         tt-detalhe.cod-estabel   = movto-estoq.cod-estabel       
                         tt-detalhe.ct-codigo     = c-ct-codigo-db
                         tt-detalhe.sc-codigo     = cc-codigo-db
                         tt-detalhe.esp-docto     = movto-estoq.esp-docto         
                         tt-detalhe.serie-docto   = movto-estoq.serie-docto       
                         tt-detalhe.it-codigo     = /* IF AVAIL b-item 
                                                       THEN b-item.it-codigo
                                                       ELSE m */ movto-estoq.it-codigo
                         tt-detalhe.ge-codigo     = /* IF AVAIL b-item
                                                       THEN b-item.ge-codigo
                                                       ELSE */   ITEM.ge-codigo
                         tt-detalhe.compr-fabric  = /* IF AVAIL b-item
                                                       THEN b-item.compr-fabric
                                                       ELSE */     ITEM.compr-fabri.
               END.
               ASSIGN tt-detalhe.quantidade       = tt-detalhe.quantidade + IF movto-estoq.tipo-trans = 1 
                                                                               THEN movto-estoq.quantidade 
                                                                               ELSE movto-estoq.quantidade * - 1
                      tt-detalhe.valor            = tt-detalhe.valor      + IF movto-estoq.tipo-trans = 1 
                                                                               THEN (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) 
                                                                               ELSE (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) * - 1.
            END.
         END.
      END. /* do dt-for */
   END. /* if avail Empresa */
END. /* if avail plano_cta_ctbl */

IF rt-tipo-relat = 1 THEN DO: /* Resumido */
   FOR EACH tt-resumido
       BREAK BY tt-resumido.cod-empresa
             BY tt-resumido.cod-estabel
             BY tt-resumido.cc-codigo
             BY tt-resumido.ct-codigo:

       DISP tt-resumido.cod-empresa  COLUMN-LABEL 'Emp'
            tt-resumido.cod-estabel  COLUMN-LABEL 'Est'
            tt-resumido.ct-codigo    COLUMN-LABEL 'Conta'
            tt-resumido.cc-codigo    COLUMN-LABEL 'CCusto'
            tt-resumido.quantidade   COLUMN-LABEL 'Qtd'
            tt-resumido.valor-total  COLUMN-LABEL 'Valor'
            tt-resumido.vl-mes-ant   COLUMN-LABEL 'Valor Mes Ant' WITH STREAM-IO WIDTH 132 DOWN FRAME f-resumido.
       DOWN WITH FRAME f-resumido.

       ACCUMULATE tt-resumido.quantidade  (TOTAL BY tt-resumido.cc-codigo BY tt-resumido.cod-estabel BY tt-resumido.cod-empresa).
       ACCUMULATE tt-resumido.valor-total (TOTAL BY tt-resumido.cc-codigo BY tt-resumido.cod-estabel BY tt-resumido.cod-empresa).
       ACCUMULATE tt-resumido.vl-mes-ant  (TOTAL BY tt-resumido.cc-codigo BY tt-resumido.cod-estabel BY tt-resumido.cod-empresa).

/*        IF LAST-OF(tt-resumido.cc-codigo) THEN DO:                                                                                        */
/*           UNDERLINE tt-resumido.quantidade                                                                                               */
/*                     tt-resumido.valor-total                                                                                              */
/*                     tt-resumido.vl-mes-ant WITH FRAME f-resumido.                                                                        */
/*           DOWN WITH FRAME f-resumido.                                                                                                    */
/*           DISP "Total CC." @ tt-resumido.cc-codigo                                                                                       */
/*                (ACCUM TOTAL BY tt-resumido.cc-codigo tt-resumido.quantidade)  @ tt-resumido.quantidade                                   */
/*                (ACCUM TOTAL BY tt-resumido.cc-codigo tt-resumido.valor-total) @ tt-resumido.valor-total                                  */
/*                (ACCUM TOTAL BY tt-resumido.cc-codigo tt-resumido.vl-mes-ant)  @ tt-resumido.vl-mes-ant WITH STREAM-IO FRAME f-resumido.  */
/*           DOWN 1 WITH FRAME f-resumido.                                                                                                  */
/*        END.                                                                                                                              */
       
       IF LAST-OF(tt-resumido.cod-estabel) THEN DO:
          UNDERLINE tt-resumido.quantidade
                    tt-resumido.valor-total
                    tt-resumido.vl-mes-ant WITH FRAME f-resumido.
          DOWN WITH FRAME f-resumido.
          DISP "Total Est." @ tt-resumido.cc-codigo
               (ACCUM TOTAL BY tt-resumido.cod-estabel tt-resumido.quantidade)  @ tt-resumido.quantidade
               (ACCUM TOTAL BY tt-resumido.cod-estabel tt-resumido.valor-total) @ tt-resumido.valor-total
               (ACCUM TOTAL BY tt-resumido.cod-estabel tt-resumido.vl-mes-ant)  @ tt-resumido.vl-mes-ant WITH STREAM-IO FRAME f-resumido.
          DOWN 1 WITH FRAME f-resumido.
       END.
   
       IF LAST-OF(tt-resumido.cod-empresa) THEN DO:
          UNDERLINE tt-resumido.quantidade
                    tt-resumido.valor-total
                    tt-resumido.vl-mes-ant WITH FRAME f-resumido.
          DOWN WITH FRAME f-resumido.
          DISP "Total Emp." @ tt-resumido.cc-codigo
               (ACCUM TOTAL BY tt-resumido.cod-empresa tt-resumido.quantidade)  @ tt-resumido.quantidade
               (ACCUM TOTAL BY tt-resumido.cod-empresa tt-resumido.valor-total) @ tt-resumido.valor-total
               (ACCUM TOTAL BY tt-resumido.cod-empresa tt-resumido.vl-mes-ant)  @ tt-resumido.vl-mes-ant WITH STREAM-IO FRAME f-resumido.
       END.
   END.
END.

IF rt-tipo-relat = 2 THEN DO: /* Detalhado */
   FOR EACH tt-detalhe
       BREAK BY tt-detalhe.cod-empresa      
             BY tt-detalhe.cod-estabel    
             BY tt-detalhe.sc-codigo
             BY tt-detalhe.ct-codigo
             BY tt-detalhe.esp-docto      
             BY tt-detalhe.serie-docto
             BY tt-detalhe.it-codigo:

       DISP tt-detalhe.cod-empresa                        COLUMN-LABEL 'Emp'  
            tt-detalhe.cod-estabel                        COLUMN-LABEL 'Est'        FORMAT 'x(3)'
            tt-detalhe.ct-codigo                          COLUMN-LABEL 'Conta'
            tt-detalhe.sc-codigo                          COLUMN-LABEL 'CCusto'     FORMAT '99999'
            {ininc/i03in218.i 04 tt-detalhe.esp-docto}    COLUMN-LABEL 'Esp'        FORMAT 'x(3)'
            tt-detalhe.serie-docto                        COLUMN-LABEL 'Ser'
            tt-detalhe.it-codigo                          COLUMN-LABEL 'Item'       FORMAT 'x(10)'
            tt-detalhe.ge-codigo                          COLUMN-LABEL 'GE'
            {ininc/i01in172.i 04 tt-detalhe.compr-fabric} COLUMN-LABEL 'Compr/Fabr' FORMAT 'x(5)'
            tt-detalhe.quantidade                         COLUMN-LABEL 'Qtd'        FORMAT '->>>>,>>9.99'
            tt-detalhe.valor                              COLUMN-LABEL 'Valor'      FORMAT '->>>,>>>,>>9.99'
            WITH FRAME f-detalhado STREAM-IO DOWN WIDTH  200.  /*132. */
       DOWN WITH FRAME f-detalhado.

       ACCUMULATE tt-detalhe.quantidade (TOTAL BY tt-detalhe.cod-empresa BY tt-detalhe.cod-estabel BY tt-detalhe.sc-codigo BY tt-detalhe.ct-codigo).
       ACCUMULATE tt-detalhe.valor      (TOTAL BY tt-detalhe.cod-empresa BY tt-detalhe.cod-estabel BY tt-detalhe.sc-codigo BY tt-detalhe.ct-codigo).

       IF LAST-OF(tt-detalhe.ct-codigo) THEN DO: 
          UNDERLINE tt-detalhe.quantidade
                    tt-detalhe.valor WITH FRAME f-detalhado.
          DOWN WITH FRAME f-detalhado.
          DISP "Total Conta" @ tt-detalhe.sc-codigo 
               (ACCUM TOTAL BY tt-detalhe.ct-codigo tt-detalhe.quantidade) @ tt-detalhe.quantidade
               (ACCUM TOTAL BY tt-detalhe.ct-codigo tt-detalhe.valor)      @ tt-detalhe.valor     
                WITH STREAM-IO FRAME f-detalhado.
          DOWN 1 WITH STREAM-IO FRAME f-detalhado.
        END.
       
       IF LAST-OF(tt-detalhe.sc-codigo) THEN DO: 
          UNDERLINE tt-detalhe.quantidade
                    tt-detalhe.valor WITH FRAME f-detalhado.
          DOWN WITH FRAME f-detalhado.

          DISP "Total C.C." @ tt-detalhe.sc-codigo 
               (ACCUM TOTAL BY tt-detalhe.sc-codigo tt-detalhe.quantidade) @ tt-detalhe.quantidade
               (ACCUM TOTAL BY tt-detalhe.sc-codigo tt-detalhe.valor)      @ tt-detalhe.valor     
                WITH STREAM-IO FRAME f-detalhado.
          DOWN 1 WITH STREAM-IO FRAME f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.cod-estabel) THEN DO: 
            UNDERLINE tt-detalhe.quantidade  
                      tt-detalhe.valor WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.
            DISP "Total Est." @ tt-detalhe.sc-codigo 
                 (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.quantidade) @ tt-detalhe.quantidade              
                 (ACCUM TOTAL BY tt-detalhe.cod-estabel tt-detalhe.valor)      @ tt-detalhe.valor WITH STREAM-IO FRAME f-detalhado.
            DOWN 1 WITH FRAME f-detalhado.
        END.

        IF LAST-OF(tt-detalhe.cod-empresa) THEN DO: 
            UNDERLINE tt-detalhe.quantidade
                      tt-detalhe.valor WITH FRAME f-detalhado.
            DOWN WITH FRAME f-detalhado.
            
            DISP "Total Emp." @ tt-detalhe.sc-codigo 
                 (ACCUM TOTAL BY tt-detalhe.cod-empresa tt-detalhe.quantidade) @ tt-detalhe.quantidade             
                 (ACCUM TOTAL BY tt-detalhe.cod-empresa tt-detalhe.valor)      @ tt-detalhe.valor WITH STREAM-IO FRAME f-detalhado.
        END.
    END. /* for each tt-detalhe ... */
END. /* rt-tipo-relat = 2 ... */

IF tg-gera-contabil THEN DO:
   FOR EACH tt-resumido NO-LOCK
       BREAK BY tt-resumido.cod-empresa
             BY tt-resumido.cod-estab  
             BY tt-resumido.ct-codigo
             BY tt-resumido.cc-codigo:
   
       ASSIGN i-sequencia = i-sequencia + 10.
   
       IF FIRST-OF(tt-resumido.cod-estab) THEN DO:
           RUN pi-gera-contabilizacao(INPUT 'lote', 
                                      INPUT '',
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT '').        
           
           RUN pi-gera-contabilizacao(INPUT 'lancto', 
                                      INPUT '',
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT '').
       END.
   
       IF tt-resumido.valor-total < 0 THEN DO:
          RUN pi-gera-contabilizacao(INPUT 'itens', 
                                     INPUT 'CR',
                                     INPUT ct-contra-partida,
                                     INPUT ccusto-contra-partida,
                                     INPUT (tt-resumido.valor-total * -1),
                                     INPUT STRING(' Conta ' + tt-resumido.ct-codigo + '.' + tt-resumido.cc-codigo)).
          ASSIGN i-sequencia = i-sequencia + 10.
          RUN pi-gera-contabilizacao(INPUT 'itens', 
                                     INPUT 'DB',
                                     INPUT tt-resumido.ct-codigo,
                                     INPUT tt-resumido.cc-codigo,
                                     INPUT (tt-resumido.valor-total * -1),
                                     INPUT '').
       END.
       ELSE DO:
          RUN pi-gera-contabilizacao(INPUT 'itens', 
                                     INPUT 'CR',
                                     INPUT tt-resumido.ct-codigo,
                                     INPUT tt-resumido.cc-codigo,
                                     INPUT tt-resumido.valor-total,
                                     INPUT '').
          ASSIGN i-sequencia = i-sequencia + 10.
          RUN pi-gera-contabilizacao(INPUT 'itens', 
                                     INPUT 'DB',
                                     INPUT ct-contra-partida,
                                     INPUT ccusto-contra-partida,
                                     INPUT tt-resumido.valor-total,
                                     INPUT STRING(' conta ' + tt-resumido.ct-codigo + '.' + tt-resumido.cc-codigo)).
       END.
   END.
   
   RUN pi-gera-contabilizacao(INPUT 'executa', 
                              INPUT '',
                              INPUT 0,
                              INPUT 0,
                              INPUT 0,
                              INPUT ''). 
END. /* if tg-gera-contabil */

PROCEDURE pi-gera-contabilizacao:
    DEF INPUT PARAMETER p-table  AS CHAR.
    DEF INPUT PARAMETER p-movto  AS CHAR.
    DEF INPUT PARAMETER p-conta  LIKE tt-resumido.ct-codigo.
    DEF INPUT PARAMETER p-ccusto LIKE tt-resumido.cc-codigo.
    DEF INPUT PARAMETER p-valor  LIKE tt-resumido.valor-total.
    DEF INPUT PARAMETER p-hist   AS CHAR.
    
    CASE p-table:
        WHEN 'lote' THEN DO:
            CREATE tt_integr_lote_ctbl.
            ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul                     = 'FGL' 
                   tt_integr_lote_ctbl.tta_num_lote_ctbl                       = 1
                   tt_integr_lote_ctbl.tta_des_lote_ctbl                       = 'Custos Materiais ' + STRING(month(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin))
                   tt_integr_lote_ctbl.tta_cod_empresa                         = emsuni.empresa.cod_empresa
                   tt_integr_lote_ctbl.tta_dat_lote_ctbl                       = dt-periodo-fin
                   tt_integr_lote_ctbl.ttv_ind_erro_valid                      = "NÆo"
                   tt_integr_lote_ctbl.tta_log_integr_ctbl_online              = NO. 
        END. /* Lote */                                                       
        WHEN 'lancto' THEN DO:
            CREATE tt_integr_lancto_ctbl.
            ASSIGN tt_integr_lancto_ctbl.tta_cod_cenar_ctbl                    = 'Fiscal'
                   tt_integr_lancto_ctbl.tta_log_lancto_conver                 = NO
                   tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo          = NO 
                   tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl              = RECID(tt_integr_lote_ctbl)
                   tt_integr_lancto_ctbl.tta_num_lancto_ctbl                   = i-sequencia
                   tt_integr_lancto_ctbl.ttv_ind_erro_valid                    = "NÆo" 
                   tt_integr_lancto_ctbl.tta_dat_lancto_ctbl                   = dt-periodo-fin.
        END. /* Lancto */
    
        WHEN 'itens' THEN DO:        

            CREATE tt_integr_item_lancto_ctbl.
            ASSIGN tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = RECID(tt_integr_lancto_ctbl)
                   tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-sequencia
                   tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = p-movto
                   tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = plano_cta_ctbl.cod_plano_cta_ctbl
                   tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = p-conta
                   tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = IF p-ccusto = '' 
                                                                                    THEN ''
                                                                                    ELSE plano_ccusto.cod_plano_ccusto
                   tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = p-ccusto
                   tt_integr_item_lancto_ctbl.tta_cod_estab                    = v_cod_estab_usuar
                   tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = empresa.cod_empresa /*Mario Fleith - Projeto Mekal*/
                   tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = 'Custos Materiais ' + STRING(month(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin)) + p-hist
                   tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = histor_finalid_econ.cod_indic_econ
                   tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-periodo-fin
                   tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = p-valor
                   tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = i-sequencia
                   tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "NÆo" .

            CREATE tt_integr_aprop_lancto_ctbl.
            ASSIGN tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = histor_finalid_econ.cod_finalid_econ
                   tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                   tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                   tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                   tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
                   tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                   tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                   tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = dt-periodo-fin
                   tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                   tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "NÆo" 
                   tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
        END. /* Item */
    
        WHEN 'executa' THEN DO:
            RUN pi-acompanhar IN h-acomp ('Contabilizando Lan‡amentos...').
            RUN prgfin/fgl/fgl900zh.py (3            , 
                                        "Aborta Tudo",
                                        NO           ,   
                                        NO           , 
                                        "Apropria‡Æo", 
                                        "Com Erro"   , 
                                        YES          , 
                                        YES          ).

            FOR EACH tt_integr_ctbl_valid NO-LOCK:
                RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros dos Lan‡amentos...').
                RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                 INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                CREATE  tt-erro.
                ASSIGN  tt-erro.des_erro    = 'FGL:' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
                                               RETURN-VALUE + CHR(10) + tt_integr_ctbl_valid.ttv_ind_pos_erro.

                CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:
                    WHEN 'ITEM' THEN DO:
                        FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                             WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
                        IF  AVAIL tt_integr_item_lancto_ctbl THEN DO:
                            ASSIGN  tt-erro.des_erro = tt-erro.des_erro + 
                                  ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl) + 
                                    ' Nat:' + tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl    +
                                    ' PCT:' + tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl       +
                                    ' CTA:' + tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl             +
                                    ' PCC:' + tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto         +
                                    ' CCU:' + tt_integr_item_lancto_ctbl.tta_cod_ccusto               + 
                                    ' EST:' + tt_integr_item_lancto_ctbl.tta_cod_estab                + 
                                    ' UNG:' + tt_integr_item_lancto_ctbl.tta_cod_unid_negoc           +
                                    ' HIS:' + tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl   +
                                    ' IEC:' + tt_integr_item_lancto_ctbl.tta_cod_indic_econ           +
                                    ' DAT:' + STRING(tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl)  +
                                    ' VAL:' + STRING(tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl)  + 
                                    ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart) .
                        END.

                    END.
                END CASE.
            END.
        END.
    END CASE.
END PROCEDURE.

PROCEDURE pi_messages:
    DEF INPUT PARAM c_action    AS CHAR    NO-UNDO.
    DEF INPUT PARAM i_msg       AS INTEGER NO-UNDO.
    DEF INPUT PARAM c_param     AS CHAR    NO-UNDO.

    def var c_prg_msg           AS CHAR    NO-UNDO.

    ASSIGN  c_prg_msg = "messages/":U
                      + STRING(TRUNC(i_msg / 1000,0),"99":U)
                      + "/msg":U
                      + STRING(i_msg, "99999":U).

    IF  SEARCH(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "n’o encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.
END PROCEDURE.  /* pi_messages */

/* Listagem de erros */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    RUN pi-acompanhar IN h-acomp ('Imprimindo listagem de erros ...').
    PAGE.
    PUT SKIP(2)
        "Listagem de ERROS e INCONSISTÒNCIAS" AT 20
        "-----------------------------------" AT 20
        SKIP(2).
    FOR EACH tt-erro NO-LOCK:
        FOR EACH tt-editor:     DELETE  tt-editor.      END.
        RUN pi-print-editor (tt-erro.des_erro,  92).
        
        FOR EACH tt-editor:
            DISPLAY tt-editor.conteudo @ tt-erro.des_erro WITH STREAM-IO FRAME f-erro WIDTH 133.
            DOWN WITH FRAME f-erro.
        END. /*FOR EACH tt-editor*/
    END.
END.

/* FIM - Listagem de erros */
