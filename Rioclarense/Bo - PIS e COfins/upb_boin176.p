DEFINE TEMP-TABLE TT-ITEM-DOC-EST LIKE item-doc-est
FIELD R-ROWID AS ROWID.

DEF BUFFER b-tt FOR tt-item-doc-est.

DEF VAR L-OK AS LOGICAL INITIAL NO.


{include/i-epc200.i} /*Defini‡Æo tt-EPC*/

    DEF INPUT PARAM p-ind-event AS CHAR   NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

    DEF VAR h-BO                AS HANDLE NO-UNDO.


IF  p-ind-event = "validaterecord" THEN DO:


    FIND FIRST tt-epc WHERE
         tt-epc.cod-event = p-ind-event AND
         tt-epc.cod-parameter = "OBJECT-HANDLE" 
         NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:

           ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).

    
        RUN getRecord IN h-bo (OUTPUT TABLE TT-ITEM-DOC-EST).


        FIND FIRST TT-ITEM-DOC-EST EXCLUSIVE-LOCK NO-ERROR.
        FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(tt-item-doc-est).

        FIND FIRST docum-est NO-LOCK WHERE docum-est.serie-docto  = tt-item-doc-est.serie-docto
                                     AND   docum-est.nro-docto    = tt-item-doc-est.nro-docto
                                     AND   docum-est.cod-emitente = tt-item-doc-est.cod-emitente
                                     NO-ERROR.
                                                  
        FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2
                                              OR     sit-tribut-relacto.cdn-tribut = 3)
                                              AND    sit-tribut-relacto.cdn-sit-tribut = 50
                                              AND    sit-tribut-relacto.cod-ncm  = tt-item-doc-est.class-fiscal
                                              AND    sit-tribut-relacto.dat-valid-inic <= docum-est.dt-emissao
                                              AND    sit-tribut-relacto.idi-tip-docto  = 1
                                              NO-ERROR.

        IF AVAIL sit-tribut-relacto THEN DO:
            
        
        FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.

        
        
        ASSIGN TT-item-doc-est.idi-tributac-cofins    = 1
               TT-ITEM-DOC-EST.idi-tributac-pis       = 1
            tt-item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]
            tt-item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]
            tt-item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
            tt-item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
            tt-item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
            tt-item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.

        ASSIGN L-OK = YES.

        END.


        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = docum-est.nat-operacao
                                      AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido 
                                                                                           da COFINS a substring pega 87, 1*/
            NO-ERROR.

        IF AVAIL natur-oper THEN DO:

            FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.


            ASSIGN TT-item-doc-est.idi-tributac-cofins = 3
                   TT-ITEM-DOC-EST.idi-tributac-pis    = 3
                   tt-item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                   tt-item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                   tt-item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))
                   tt-item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))
                   tt-item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 31, 5)) / 100
                   tt-item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * dec(SUBSTRING(item.char-2, 36, 5)) / 100.


        ASSIGN L-OK = YES.    
        END.

        
        IF L-OK = NO THEN DO:
                ASSIGN TT-item-doc-est.idi-tributac-cofins = 2
               TT-ITEM-DOC-EST.idi-tributac-pis    = 2
               tt-item-doc-est.val-aliq-pis           = 0
               tt-item-doc-est.val-aliq-cofins        = 0.



        END.

        END.

                RUN setRecord IN h-bo (INPUT TABLE TT-ITEM-DOC-EST).

    END.

/* IF  p-ind-event = "AfterUpdateRecord" THEN DO:                                                                                                                    */
/*                                                                                                                                                                   */
/*     MESSAGE "before" VIEW-AS ALERT-BOX.                                                                                                                           */
/*                                                                                                                                                                   */
/*     FIND FIRST tt-epc WHERE                                                                                                                                       */
/*          tt-epc.cod-event = p-ind-event AND                                                                                                                       */
/*          tt-epc.cod-parameter = "OBJECT-HANDLE"                                                                                                                   */
/*          NO-LOCK NO-ERROR.                                                                                                                                        */
/*     IF  AVAIL tt-epc THEN DO:                                                                                                                                     */
/*                                                                                                                                                                   */
/*            ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter).                                                                                                     */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         RUN getRecord IN h-bo (OUTPUT TABLE TT-ITEM-DOC-EST).                                                                                                     */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         FIND FIRST TT-ITEM-DOC-EST EXCLUSIVE-LOCK NO-ERROR.                                                                                                       */
/*         FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(tt-item-doc-est).                                                                                               */
/*                                                                                                                                                                   */
/*         FIND FIRST docum-est NO-LOCK WHERE docum-est.serie-docto  = tt-item-doc-est.serie-docto                                                                   */
/*                                      AND   docum-est.nro-docto    = tt-item-doc-est.nro-docto                                                                     */
/*                                      AND   docum-est.cod-emitente = tt-item-doc-est.cod-emitente                                                                  */
/*                                      NO-ERROR.                                                                                                                    */
/*                                                                                                                                                                   */
/*         FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2                                                                             */
/*                                               OR     sit-tribut-relacto.cdn-tribut = 3)                                                                           */
/*                                               AND    sit-tribut-relacto.cdn-sit-tribut = 50                                                                       */
/*                                               AND    sit-tribut-relacto.cod-ncm  = tt-item-doc-est.class-fiscal                                                   */
/*                                               AND    sit-tribut-relacto.dat-valid-inic <= docum-est.dt-emissao                                                    */
/*                                               AND    sit-tribut-relacto.idi-tip-docto  = 1                                                                        */
/*                                               NO-ERROR.                                                                                                           */
/*                                                                                                                                                                   */
/*         IF NOT AVAIL sit-tribut-relacto THEN DO:                                                                                                                  */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.                                                                        */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         ASSIGN TT-item-doc-est.idi-tributac-cofins    = 1                                                                                                         */
/*                TT-ITEM-DOC-EST.idi-tributac-pis       = 1                                                                                                         */
/*                tt-item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))                                                                        */
/*                tt-item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))                                                                        */
/*                tt-item-doc-est.valor-pis              = b-tt.val-base-calc-cofins * dec(SUBSTRING(item.char-2, 31, 5)) / 100                                      */
/*                tt-item-doc-est.val-cofins             = b-tt.val-base-calc-cofins * dec(SUBSTRING(item.char-2, 36, 5)) / 100.                                     */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         ASSIGN L-OK = YES.                                                                                                                                        */
/*                                                                                                                                                                   */
/*         END.                                                                                                                                                      */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = docum-est.nat-operacao                                                                      */
/*                                       AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido */
/*                                                                                            da COFINS a substring pega 87, 1*/                                     */
/*             NO-ERROR.                                                                                                                                             */
/*                                                                                                                                                                   */
/*         IF AVAIL natur-oper THEN DO:                                                                                                                              */
/*                                                                                                                                                                   */
/*             FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.                                                                    */
/*             MESSAGE "2" b-tt.val-base-calc-cofins SKIP SUBSTRING(item.char-2, 31, 5)  VIEW-AS ALERT-BOX .                                                         */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*             ASSIGN TT-item-doc-est.idi-tributac-cofins = 3                                                                                                        */
/*                    TT-ITEM-DOC-EST.idi-tributac-pis    = 3                                                                                                        */
/*                    tt-item-doc-est.val-aliq-pis           = dec(SUBSTRING(item.char-2, 31, 5))                                                                    */
/*                    tt-item-doc-est.val-aliq-cofins        = dec(SUBSTRING(item.char-2, 36, 5))                                                                    */
/*                    tt-item-doc-est.valor-pis              = b-tt.val-base-calc-cofins * dec(SUBSTRING(item.char-2, 31, 5)) / 100                                  */
/*                    tt-item-doc-est.val-cofins             = b-tt.val-base-calc-cofins * dec(SUBSTRING(item.char-2, 36, 5)) / 100.                                 */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         ASSIGN L-OK = YES.                                                                                                                                        */
/*         END.                                                                                                                                                      */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         IF L-OK = NO THEN DO:                                                                                                                                     */
/*                 ASSIGN TT-item-doc-est.idi-tributac-cofins = 2                                                                                                    */
/*                TT-ITEM-DOC-EST.idi-tributac-pis    = 2                                                                                                            */
/*                tt-item-doc-est.val-aliq-pis           = 0                                                                                                         */
/*                tt-item-doc-est.val-aliq-cofins        = 0.                                                                                                        */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*                                                                                                                                                                   */
/*         END.                                                                                                                                                      */
/*                                                                                                                                                                   */
/*         END.                                                                                                                                                      */
/*                                                                                                                                                                   */
/*                 RUN setRecord IN h-bo (INPUT TABLE TT-ITEM-DOC-EST).                                                                                              */
/*                                                                                                                                                                   */
/*     END.                                                                                                                                                          */
/*                                                                                                                                                                   */
    
