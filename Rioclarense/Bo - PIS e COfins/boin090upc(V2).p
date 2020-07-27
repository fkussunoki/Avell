


/*: *******************************************************************************
** Autor: Flavio Kussunoki
** Empresa: FKIS Consultoria (47) 99230-5495
** Criacao: 12/04/2018
** Solicitante: Izael Uchoa
** Objetivo do programa: Efetuar validacao na RE1001 da natureza de operacao e
** confrontar com a tabela especifica ext-conta-ft, para preenchimento da conta
** transitoria de fornecedor no caso de naturezas nao financeiras
*******************************************************************************/

{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
{esbo/boin090.i RowObject}

DEF TEMP-TABLE tt-docum LIKE docum-est
    FIELD R-ROWID AS ROWID.

DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE BUFFER b-tt FOR item-doc-est.

DEFIN VAR l-ok AS LOGICAL.

DEF VAR h-BO AS HANDLE NO-UNDO.
DEF VAR c-emitente AS INTEGER.
DEF VAR c-nat-oper     AS CHAR.
DEF VAR c-serie-docto  AS CHAR.
DEF VAR c-nro-docto    AS CHAR.

IF  p-ind-event = "fim-CalculateTotalNota" THEN DO:


   FIND FIRST tt-epc  WHERE tt-epc.cod-event =  p-ind-event
                    AND   tt-epc.cod-parameter = "Cod-Emitente" NO-ERROR. 

    
    IF  AVAIL tt-epc THEN 
        ASSIGN c-emitente = int(tt-epc.val-parameter).

    FIND FIRST tt-epc  WHERE tt-epc.cod-event =  p-ind-event
                     AND   tt-epc.cod-parameter = "Nat-operacao" NO-ERROR. 

    IF AVAIL tt-epc THEN
        ASSIGN c-nat-oper    = tt-epc.val-parameter.


    FIND FIRST tt-epc  WHERE tt-epc.cod-event =  p-ind-event
                     AND   tt-epc.cod-parameter = "serie-docto" NO-ERROR. 

    IF AVAIL tt-epc THEN
        ASSIGN c-serie-docto    = tt-epc.val-parameter.

    FIND FIRST tt-epc  WHERE tt-epc.cod-event =  p-ind-event
                     AND   tt-epc.cod-parameter = "nro-docto" NO-ERROR. 

    IF AVAIL tt-epc THEN
        ASSIGN c-nro-docto    = tt-epc.val-parameter.



       FIND FIRST docum-est WHERE docum-est.cod-emitente = c-emitente                                            
                         AND   docum-est.nat-operacao = c-nat-oper                                            
                         AND   docum-est.serie-docto  = c-serie-docto                                         
                         AND   docum-est.nro-docto    = c-nro-docto NO-ERROR.                                 
                                                                                                              
        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao  = c-nat-oper NO-ERROR.
        
        IF natur-oper.emite-duplic = no THEN
            ASSIGN docum-est.ct-transit  = "".
            
            FIND FIRST ext-conta-ft NO-LOCK WHERE ext-conta-ft.nat-operacao = docum-est.nat-operacao NO-ERROR.
                                                                                                              
            IF AVAIL ext-conta-ft THEN DO:                                                                    
                                                                                                              
                                                                                                              
                                                                                                              
    ASSIGN docum-est.ct-transit = ext-conta-ft.ct-codigo                                                      
           docum-est.sc-transit = ext-conta-ft.sc-codigo.                                                     
                                                                                                              
  END.                                                                                                        


  FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente   = c-emitente
                                  AND   item-doc-est.nro-docto    = c-nro-docto
                                  AND   item-doc-est.serie-docto  = c-serie-docto
                                  AND   item-doc-est.nat-operacao = c-nat-oper:

      FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(item-doc-est).



      FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2
                                            OR     sit-tribut-relacto.cdn-tribut = 3)
                                            AND    sit-tribut-relacto.cdn-sit-tribut = 50
                                            AND    sit-tribut-relacto.cod-ncm  = item-doc-est.class-fiscal
                                            AND    sit-tribut-relacto.dat-valid-inic <= TODAY
                                            AND    sit-tribut-relacto.idi-tip-docto  = 1
                                            NO-ERROR.

      IF AVAIL sit-tribut-relacto THEN DO:


      FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


      FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Aliquota 0"
                                      AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

      IF AVAIL ct-clas-item THEN DO:
          ASSIGN item-doc-est.idi-tributac-cofins    = 2
                 ITEM-DOC-EST.idi-tributac-pis       = 2
                 item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                 item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                 item-doc-est.val-aliq-pis           = 0
                 item-doc-est.val-aliq-cofins        = 0
                 item-doc-est.valor-pis              = 0
                 item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.
          
      END.


      FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Monofasico"
                                      AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

      IF AVAIL ct-clas-item THEN DO:
          ASSIGN item-doc-est.idi-tributac-cofins    = 2
                 ITEM-DOC-EST.idi-tributac-pis       = 2
                 item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                 item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                 item-doc-est.val-aliq-pis           = 0
                 item-doc-est.val-aliq-cofins        = 0
                 item-doc-est.valor-pis              = 0
                 item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.
          
      END.

      IF NOT AVAIL ct-clas-item then do:
      ASSIGN item-doc-est.idi-tributac-cofins    = 1
             ITEM-DOC-EST.idi-tributac-pis       = 1
             item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
             item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
             item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
             item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
             item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
             item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.


      ASSIGN L-OK = YES.
          end.
      END.


      FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = c-nat-oper
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
          assign b-tt.idi-tributac-cofins            = 3
                 b-tt.idi-tributac-pis               = 3.


      ASSIGN L-OK = YES.
      END.


      IF L-OK = NO THEN DO:
              ASSIGN item-doc-est.idi-tributac-cofins = 2
                     ITEM-DOC-EST.idi-tributac-pis    = 2
                     item-doc-est.val-aliq-pis           = 0
                     item-doc-est.val-aliq-cofins        = 0
                     item-doc-est.valor-pis              = 0
                     item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.




      END.

 END.


END.


IF  p-ind-event = "conta-transitoria" THEN DO:
    FIND FIRST tt-epc WHERE
         tt-epc.cod-event = p-ind-event AND
         tt-epc.cod-parameter = "" NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).

        RUN getRecord IN h-bo (OUTPUT TABLE RowObject).



        FIND FIRST RowObject EXCLUSIVE-LOCK NO-ERROR.

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao  = rowObject.nat-operacao NO-ERROR.

        IF natur-oper.emite-duplic = no THEN
            ASSIGN RowObject.ct-transit = "".

        FIND FIRST ext-conta-ft NO-LOCK WHERE ext-conta-ft.nat-operacao = rowObject.nat-operacao NO-ERROR.

        IF AVAIL ext-conta-ft THEN DO:


        ASSIGN RowObject.ct-transit = ext-conta-ft.ct-codigo
               rowObject.sc-transit = ext-conta-ft.sc-codigo.


        END.

        RUN setRecord IN h-bo (INPUT TABLE RowObject).
    END.
END.


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
                                                  AND    sit-tribut-relacto.dat-valid-inic <= TODAY
                                                  AND    sit-tribut-relacto.idi-tip-docto  = 1
                                                  NO-ERROR.

            IF AVAIL sit-tribut-relacto THEN DO:


            FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


            FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Aliquota 0"
                                            AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

            IF AVAIL ct-clas-item THEN DO:
            
                ASSIGN item-doc-est.idi-tributac-cofins    = 2
                       ITEM-DOC-EST.idi-tributac-pis       = 2
                       item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                       item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                       item-doc-est.val-aliq-pis           = 0
                       item-doc-est.val-aliq-cofins        = 0
                       item-doc-est.valor-pis              = 0
                       item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.

            END.


            FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Monofasico"
                                            AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

            IF AVAIL ct-clas-item THEN DO:
                ASSIGN item-doc-est.idi-tributac-cofins    = 2
                       ITEM-DOC-EST.idi-tributac-pis       = 2
                       item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                       item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0
                       item-doc-est.val-aliq-pis           = 0
                       item-doc-est.val-aliq-cofins        = 0
                       item-doc-est.valor-pis              = 0
                       item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.

            END.

            
            IF NOT AVAIL ct-clas-item THEN DO:
            ASSIGN item-doc-est.idi-tributac-cofins    = 1
                   ITEM-DOC-EST.idi-tributac-pis       = 1
                   item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                   item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                   item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
                   item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
                   item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
                   item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.


            ASSIGN L-OK = YES.
                END.
            END.


            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = c-nat-oper
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

          assign b-tt.idi-tributac-cofins            = 3
                 b-tt.idi-tributac-pis               = 3.

            ASSIGN L-OK = YES.
            END.


            IF L-OK = NO THEN DO:
                    ASSIGN item-doc-est.idi-tributac-cofins = 2
                           ITEM-DOC-EST.idi-tributac-pis    = 2
                           item-doc-est.val-aliq-pis           = 0
                           item-doc-est.val-aliq-cofins        = 0
                           item-doc-est.valor-pis              = 0
                           item-doc-est.val-cofins             = 0.

          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.



            END.

        END.

    END.

END.



/*             FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2                                                                             */
/*                                                   OR     sit-tribut-relacto.cdn-tribut = 3)                                                                           */
/*                                                   AND    sit-tribut-relacto.cdn-sit-tribut = 50                                                                       */
/*                                                   AND    sit-tribut-relacto.cod-ncm  = item-doc-est.class-fiscal                                                      */
/*                                                   AND    sit-tribut-relacto.dat-valid-inic <= tt-docum.dt-emissao                                                     */
/*                                                   AND    sit-tribut-relacto.idi-tip-docto  = 1                                                                        */
/*                                                   NO-ERROR.                                                                                                           */
/*                                                                                                                                                                       */
/*             IF AVAIL sit-tribut-relacto THEN DO:                                                                                                                      */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.                                                                           */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             ASSIGN item-doc-est.idi-tributac-cofins    = 1                                                                                                            */
/*                    ITEM-DOC-EST.idi-tributac-pis       = 1                                                                                                            */
/*                    item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]                                                                      */
/*                    item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]                                                                      */
/*                    item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))                                                                           */
/*                    item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))                                                                           */
/*                    item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100                                       */
/*                    item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.                                     */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             ASSIGN L-OK = YES.                                                                                                                                        */
/*                                                                                                                                                                       */
/*             END.                                                                                                                                                      */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = tt-docum.nat-operacao                                                                       */
/*                                           AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido */
/*                                                                                                da COFINS a substring pega 87, 1*/                                     */
/*                 NO-ERROR.                                                                                                                                             */
/*                                                                                                                                                                       */
/*             IF AVAIL natur-oper THEN DO:                                                                                                                              */
/*                                                                                                                                                                       */
/*                 FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.                                                                       */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*                 ASSIGN item-doc-est.idi-tributac-cofins = 3                                                                                                           */
/*                        ITEM-DOC-EST.idi-tributac-pis    = 3                                                                                                           */
/*                        item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]                                                                  */
/*                        item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]                                                                  */
/*                        item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))                                                                       */
/*                        item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))                                                                       */
/*                        item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100                                   */
/*                        item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.                                 */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             ASSIGN L-OK = YES.                                                                                                                                        */
/*             END.                                                                                                                                                      */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             IF L-OK = NO THEN DO:                                                                                                                                     */
/*                     ASSIGN item-doc-est.idi-tributac-cofins = 2                                                                                                       */
/*                            ITEM-DOC-EST.idi-tributac-pis    = 2                                                                                                       */
/*                            item-doc-est.val-aliq-pis           = 0                                                                                                    */
/*                            item-doc-est.val-aliq-cofins        = 0                                                                                                    */
/*                            item-doc-est.valor-pis              = 0                                                                                                    */
/*                            item-doc-est.val-cofins             = 0.                                                                                                   */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*                                                                                                                                                                       */
/*             END.                                                                                                                                                      */
/*                                                                                                                                                                       */
/*             END.                                                                                                                                                      */
/*                                                                                                                                                                       */
/*     END.                                                                                                                                                              */
/*  END.                                                                                                                                                                 */
