{include/i-epc200.i} /*Defini»’o tt-EPC*/
/*                                               */

DEF TEMP-TABLE tt-docum LIKE docum-est
    FIELD R-ROWID AS ROWID.
def input param p-ind-event as char no-undo.  
def input-output param table for tt-epc.

DEFINE BUFFER b-tt FOR item-doc-est.

DEFIN VAR l-ok AS LOGICAL.

DEF VAR h-BO                AS HANDLE NO-UNDO.

/* def input param p-ind-object       as char          no-undo.                                            */
/* def input param p-wgh-object       as handle        no-undo.                                            */
/* def input param p-wgh-frame        as widget-handle no-undo.                                            */
/* def input param p-cod-table        as char          no-undo.                                            */
/* def input param p-row-table        as rowid         no-undo.                                            */
/* def var c-objeto as char no-undo.                                                                       */
/*                                                                                                         */
/* assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/"). */

/* message "EVENTO" p-ind-event */

/*       /* "OBJETO" p-ind-object skip                        */
/*         "NOME OBJ" c-objeto skip                           */
/*         "FRAME" p-wgh-frame skip                           */
/*         "TABELA" p-cod-table skip                          */
/*         "ROWID" string(p-row-table) */  view-as alert-box. */


IF  p-ind-event = "aftersettotaisnota"     THEN DO:


    FIND FIRST tt-epc WHERE
         tt-epc.cod-event = p-ind-event /* AND
         tt-epc.cod-parameter = "OBJECT-HANDLE" */
         NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:

           ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).


        RUN getRecord IN h-bo (OUTPUT TABLE tt-docum).


        FIND FIRST tt-docum NO-ERROR.

        FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente   = tt-docum.cod-emitente
                                        AND   item-doc-est.nro-docto    = tt-docum.nro-docto
                                        AND   item-doc-est.serie-docto  = tt-docum.serie-docto
                                        AND   item-doc-est.nat-operacao = tt-docum.nat-operacao:

            FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(item-doc-est).



            FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2
                                                  OR     sit-tribut-relacto.cdn-tribut = 3)
                                                  AND    sit-tribut-relacto.cdn-sit-tribut = 50
                                                  AND    sit-tribut-relacto.cod-ncm  = item-doc-est.class-fiscal
                                                  AND    sit-tribut-relacto.dat-valid-inic <= tt-docum.dt-emissao
                                                  AND    sit-tribut-relacto.idi-tip-docto  = 1
                                                  NO-ERROR.

            IF AVAIL sit-tribut-relacto THEN DO:


            FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.



            ASSIGN item-doc-est.idi-tributac-cofins    = 1
                   ITEM-DOC-EST.idi-tributac-pis       = 1
                   item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                   item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                   item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
                   item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
                   item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
                   item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.

            MESSAGE "Os parametros de PIS e COFINS foram alterados para " SKIP
                "Cofins TRIBUTADO | Pis TRIBUTADO | os calculos foram acertados" SKIP 
                "Para acertar os valores, verifique na documentacao INBO090" VIEW-AS ALERT-BOX.


            ASSIGN L-OK = YES.

            END.


            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = tt-docum.nat-operacao
                                          AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido
                                                                                               da COFINS a substring pega 87, 1*/
                NO-ERROR.

            IF AVAIL natur-oper THEN DO:

                FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


                ASSIGN item-doc-est.idi-tributac-cofins = 3
                       ITEM-DOC-EST.idi-tributac-pis    = 3
                       item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                       item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                       item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
                       item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
                       item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
                       item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.

                MESSAGE "Os parametros de PIS e COFINS foram alterados para " SKIP
                    "Cofins OUTROS | Pis OUTROS | os calculos foram acertados" SKIP 
                    "Para acertar os valores, verifique na documentacao INBO090" VIEW-AS ALERT-BOX.


            ASSIGN L-OK = YES.
            END.


            IF L-OK = NO THEN DO:
                    ASSIGN item-doc-est.idi-tributac-cofins = 2
                           ITEM-DOC-EST.idi-tributac-pis    = 2
                           item-doc-est.val-aliq-pis           = 0
                           item-doc-est.val-aliq-cofins        = 0
                           item-doc-est.valor-pis              = 0
                           item-doc-est.val-cofins             = 0.



                    MESSAGE "Os parametros de PIS e COFINS foram alterados para " SKIP
                        "Cofins ISENTO | Pis ISENTO | e os valores foram zerados" SKIP 
                        "Para acertar os valores, verifique na documentacao INBO090" VIEW-AS ALERT-BOX.


            END.

            END.

    END.
 END.
