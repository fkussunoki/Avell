


/*: *******************************************************************************
** Autor: Flavio Kussunoki
** Empresa: FKIS Consultoria (47) 99230-5495
** Criacao: 12/04/2018
** Solicitante: Izael Uchoa
** Objetivo do programa: Efetuar validacao na RE1001 da natureza de operacao e
** confrontar com a tabela especifica ext-conta-ft, para preenchimento da conta
** transitoria de fornecedor no caso de naturezas nao financeiras
*******************************************************************************/

{include/i-epc200.i} /*Definiá∆o tt-EPC*/
{esbo/boin090.i RowObject}

DEF TEMP-TABLE tt-docum LIKE docum-est
    FIELD R-ROWID AS ROWID.

DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE BUFFER b-tt FOR item-doc-est.

DEFIN VAR l-ok AS LOGICAL.

DEF VAR h-BO AS HANDLE NO-UNDO.
DEF VAR c-emitente AS INTEGER.
DEF NEW GLOBAL SHARED VAR c-nat-oper     AS CHAR.
DEF VAR c-serie-docto  AS CHAR.
DEF VAR c-nro-docto    AS CHAR.

IF  (p-ind-event = "fim-CalculateTotalNota" 
or  p-ind-event = "aftersettotaisnota" ) THEN DO:
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
    

/* BUSCA INICIALMENTE SE O ITEM ESTA NO CD0303, SE ESTIVE BUSCA NO CD0755 SE O ITEM ESTA EM ALGUMA DAS SITUACOES (ALIQUOTA ZERO OU MONOFASICO*/
  FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente   = c-emitente
                                  AND   item-doc-est.nro-docto    = c-nro-docto
                                  AND   item-doc-est.serie-docto  = c-serie-docto
                                  AND   item-doc-est.nat-operacao = c-nat-oper:

     FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(item-doc-est).

      FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao
                                    AND   natur-oper.cod-cfop     = "1922"
                                    OR    natur-oper.cod-cfop     = "2922" NO-ERROR.

      IF AVAIL natur-oper THEN DO:
      
      
      // message "TRECHO 1 - VALOR DEVERIA SER ZERO" VIEW-AS ALERT-BOX.
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

              ASSIGN L-OK = YES.
          
      END.

      FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(item-doc-est).

      FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2
                                            OR     sit-tribut-relacto.cdn-tribut = 3)
                                            AND    sit-tribut-relacto.cdn-sit-tribut = 50
                                            AND    sit-tribut-relacto.cod-ncm  = item-doc-est.class-fiscal
                                            AND    sit-tribut-relacto.dat-valid-inic <= TODAY
                                            AND    sit-tribut-relacto.idi-tip-docto  = 1
                                            NO-ERROR.
      FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

      IF AVAIL sit-tribut-relacto THEN DO:
      // message "TRECHO 2 - TEM A SITUACAO TRIBUTARIA " VIEW-AS ALERT-BOX.

            FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Aliquota 0"
                                            AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.
      
            IF AVAIL ct-clas-item THEN DO:
           // message "TRECHO 3 - ê ALIQUOTA ZERO" VIEW-AS ALERT-BOX.       
            
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
              ASSIGN L-OK = YES.
                
            END.


      FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Monofasico"
                                      AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

         IF AVAIL ct-clas-item THEN DO:
               // message "TRECHO 4 - ê MONOFASICO" VIEW-AS ALERT-BOX.
         
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
               ASSIGN L-OK = YES.
            
         END.

            FIND FIRST ct-clas-item NO-LOCK WHERE (ct-clas-item.cod-clas-fisc = "Monofasico"
                                            or     ct-clas-item.cod-clas-fisc = "Aliquota 0")
                                            AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR.

   
      IF NOT AVAIL ct-clas-item then do:
            // message "TRECHO 5 - NAO TEM CLASSE" VIEW-AS ALERT-BOX.
 
          IF  DEC(SUBSTRING(item.char-2, 31, 5)) >= 3 OR
              DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) >= 17 THEN DO:
              
              FIND FIRST NATUR-OPER WHERE NATUR-OPER.NAT-OPERACAO = C-NAT-OPER NO-ERROR.
                    // message "TRECHO 5.1 - NAO TEM CLASSE E ê ALCOOL" VIEW-AS ALERT-BOX.
              
              IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO:
             
                      // message "TRECHO 5.1.1 NAO TEM CLASSE ê ALCOOL E NFD" VIEW-AS ALERT-BOX.
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 3.75                     item-doc-est.val-aliq-cofins        = 17.25
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500.
              ASSIGN L-OK = YES.
              END.

              IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO:
                    // message "TRECHO 5.1.2 - NAO TEM CLASSE ê ALCOOL NFE" VIEW-AS ALERT-BOX.
             
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 1.65
                     item-doc-est.val-aliq-cofins        = 7.60
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760.
              ASSIGN L-OK = YES.
              END.



          END.

          ELSE DO:
          
          
             ASSIGN item-doc-est.idi-tributac-cofins    = 1
                    ITEM-DOC-EST.idi-tributac-pis       = 1
                    item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                    item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                    item-doc-est.val-aliq-pis           = 1.65
                    item-doc-est.val-aliq-cofins        = 7.60
                    item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165
                    item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760.
       
       
             ASSIGN L-OK = YES.
          end.
      END. //NOT AVAIL CT-CLAS-ITEM 
  END.  // AVAIL sit-tribut-relacto    


      FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = c-nat-oper
                                    AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido
                                                                                         da COFINS a substring pega 87, 1*/
          NO-ERROR.

      IF AVAIL natur-oper THEN DO:
            // message "natur-oper" view-as alert-box.
          FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.
          IF DEC(SUBSTRING(item.char-2, 31, 5)) >= 3 OR
              DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) >= 17 THEN DO:
              
              
              IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO:
             
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 3.75                     item-doc-est.val-aliq-cofins        = 17.25
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500.
              ASSIGN L-OK = YES.
              END.

              IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO:
             
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 1.65
                     item-doc-est.val-aliq-cofins        = 7.60
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760.
              ASSIGN L-OK = YES.
              END.



    
          END. //ALCOOOL

          ELSE DO:
          
          ASSIGN item-doc-est.idi-tributac-cofins = 3
                 ITEM-DOC-EST.idi-tributac-pis    = 3
                 item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                 item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1]
                 item-doc-est.val-aliq-pis           = 1.65
                 item-doc-est.val-aliq-cofins        = 7.60
                 item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165
                 item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * 0.0760.
          assign b-tt.idi-tributac-cofins            = 3
                 b-tt.idi-tributac-pis               = 3.


      ASSIGN L-OK = YES.
      END. //NAO ALCCOOL
  END. // NAO ê NATUREZA DE OPERACAO OUTROS


      IF L-OK = NO THEN DO:
                // message " entrei no nok"  view-as alert-box.
      
              FIND FIRST NATUR-OPER WHERE NATUR-OPER.NAT-OPERACAO = C-NAT-OPER NO-ERROR.
              
              
              IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO:
                // message " entrei no nok NFD"  view-as alert-box.             
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 3.75                     item-doc-est.val-aliq-cofins        = 17.25
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500.
              ASSIGN L-OK = YES.
                
              END.

              IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO:
                // message " entrei no nok NFE"  view-as alert-box.             
              ASSIGN item-doc-est.idi-tributac-cofins    = 1
                     ITEM-DOC-EST.idi-tributac-pis       = 1
                     item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1]
                     item-doc-est.val-aliq-pis           = 1.65
                     item-doc-est.val-aliq-cofins        = 7.60
                     item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165
                     item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760.
              ASSIGN L-OK = YES.
              
          END. //ê ALCOOL, MAS NAO ESTµ EM NATUREZA OUTROS, NO CD0303 OU NO CD0755

          else do:
                // message " entrei no nok SE NAO"  view-as alert-box.           
              ASSIGN item-doc-est.idi-tributac-cofins = 1
                     ITEM-DOC-EST.idi-tributac-pis    = 1
                     item-doc-est.val-aliq-pis           = 0
                     item-doc-est.val-aliq-cofins        = 0
                     item-doc-est.valor-pis              = 0
                     item-doc-est.val-cofins             = 0.
          assign b-tt.idi-tributac-cofins            = 2
                 b-tt.idi-tributac-pis               = 2.

              ASSIGN L-OK = YES.
         end. //NAO ê ALCOOL, NAO ESTA EM NATUREZA OUTROS, NO CD0303 OU NO CD0755

      END. // LOGICAL OK IGUAL A NAO

   END. // FOR EACH ITEM-DOC-EST


END. //P-IND-EVENT


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


/* IF  p-ind-event = "aftersettotaisnota"     THEN DO: */
/*     FIND FIRST tt-epc WHERE */
/*          tt-epc.cod-event = p-ind-event /* AND */
/*          tt-epc.cod-parameter = "OBJECT-HANDLE" */ */
/*          NO-LOCK NO-ERROR. */
/*     IF  AVAIL tt-epc THEN DO: */
/*    */
/*            ASSIGN h-bo = WIDGET-HANDLE(tt-epc.val-parameter). */
/*    */
/*    */
/*         RUN getRecord IN h-bo (OUTPUT TABLE tt-docum). */
/*    */
/*         FIND FIRST tt-docum NO-ERROR. */
/*    */
/*         FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente   = tt-docum.cod-emitente */
/*                                         AND   item-doc-est.nro-docto    = tt-docum.nro-docto */
/*                                         AND   item-doc-est.serie-docto  = tt-docum.serie-docto */
/*                                         AND   item-doc-est.nat-operacao = tt-docum.nat-operacao: */
/*    */
/*             FIND FIRST b-tt WHERE ROWID(b-tt) = ROWID(item-doc-est). */
/*    */
/*             FIND last sit-tribut-relacto NO-LOCK WHERE (sit-tribut-relacto.cdn-tribut = 2 */
/*                                                   OR     sit-tribut-relacto.cdn-tribut = 3) */
/*                                                   AND    sit-tribut-relacto.cdn-sit-tribut = 50 */
/*                                                   AND    sit-tribut-relacto.cod-ncm  = item-doc-est.class-fiscal */
/*                                                   AND    sit-tribut-relacto.dat-valid-inic <= TODAY */
/*                                                   AND    sit-tribut-relacto.idi-tip-docto  = 1 */
/*                                                   NO-ERROR. */
/*            FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*    */
/*             IF AVAIL sit-tribut-relacto THEN DO: */
/*                 // message "ENTREI CST"  VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*             FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Aliquota 0" */
/*                                             AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR. */
/*    */
/*             IF AVAIL ct-clas-item THEN DO: */
/*    */
/*             // message "ALIQUOTA ZERO"  VIEW-AS ALERT-BOX. */
/*                 ASSIGN item-doc-est.idi-tributac-cofins    = 2 */
/*                        ITEM-DOC-EST.idi-tributac-pis       = 2 */
/*                        item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0 */
/*                        item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0 */
/*                        item-doc-est.val-aliq-pis           = 0 */
/*                        item-doc-est.val-aliq-cofins        = 0 */
/*                        item-doc-est.valor-pis              = 0 */
/*                        item-doc-est.val-cofins             = 0. */
/*           assign b-tt.idi-tributac-cofins            = 2 */
/*                  b-tt.idi-tributac-pis               = 2. */
/*               ASSIGN L-OK = YES. */
/*              END. // End aliquota zero */
/*    */
/*             FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*    */
/*    */
/*             FIND FIRST ct-clas-item NO-LOCK WHERE ct-clas-item.cod-clas-fisc = "Monofasico" */
/*                                             AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR. */
/*    */
/*             IF AVAIL ct-clas-item THEN DO: */
/*             // message "MONOTAISCL"  VIEW-AS ALERT-BOX. */
/*    */
/*                 ASSIGN item-doc-est.idi-tributac-cofins    = 2 */
/*                        ITEM-DOC-EST.idi-tributac-pis       = 2 */
/*                        item-doc-est.val-base-calc-cofins  =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0 */
/*                        item-doc-est.base-pis              =  /*(b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */ 0 */
/*                        item-doc-est.val-aliq-pis           = 0 */
/*                        item-doc-est.val-aliq-cofins        = 0 */
/*                        item-doc-est.valor-pis              = 0 */
/*                        item-doc-est.val-cofins             = 0. */
/*           assign b-tt.idi-tributac-cofins            = 2 */
/*                  b-tt.idi-tributac-pis               = 2. */
/*               ASSIGN L-OK = YES. */
/*         end. //Avail ct-class */
/*    */
/*             FIND FIRST ct-clas-item NO-LOCK WHERE (ct-clas-item.cod-clas-fisc = "Monofasico" */
/*                                             or     ct-clas-item.cod-clas-fisc = "Aliquota 0") */
/*                                             AND   ct-clas-item.cod-item      = item.it-codigo NO-ERROR. */
/*    */
/*    */
/*             IF NOT AVAIL ct-clas-item THEN DO: */
/*             // message "NAO ENCONTROU CT-CLASS"  VIEW-AS ALERT-BOX. */
/*    */
/*             FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*    */
/*             // message item.it-codigo view-as alert-box. */
/*    */
/*                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) >= 3 OR */
/*                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) >= 17 THEN DO: */
/*                               // message "ALCOOK CT-CLASS"   VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*               FIND FIRST NATUR-OPER WHERE NATUR-OPER.NAT-OPERACAO = C-NAT-OPER NO-ERROR. */
/*    */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO: */
/*                               // message "CT-CLASS ND"   VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 1 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 1 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 3.75                     item-doc-est.val-aliq-cofins        = 17.25 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500. */
/*               ASSIGN L-OK = YES. */
/*    */
/*               END. // alcook NFD */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO: */
/*                               // message "CT-CLASS NE"   VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 1 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 1 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 1.65 */
/*                      item-doc-est.val-aliq-cofins        = 7.60 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760. */
/*               ASSIGN L-OK = YES. */
/*    */
/*               END. // alcool NFE */
/*             end. // aliquota maior que 3 (alcool) */
/*    */
/*             FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) < 3 OR */
/*                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) < 17 THEN DO: */
/*    */
/*    */
/*                                           // message "nada anterior"   VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*             ASSIGN item-doc-est.idi-tributac-cofins    = 1 */
/*                    ITEM-DOC-EST.idi-tributac-pis       = 1 */
/*                    item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                    item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                    item-doc-est.val-aliq-pis           = 1.65 */
/*                    item-doc-est.val-aliq-cofins        = 7.60 */
/*                    item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165 */
/*                    item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760. */
/*    */
/*    */
/*               ASSIGN L-OK = YES. */
/*             END. // aliquota normal */
/*         END. // nao Ç monofasico ou aliquota zero. */
/*    */
/*    */
/*    */
/*             FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = c-nat-oper */
/*                                           AND   SUBSTRING(natur-oper.char-1, 86, 1) = "3"  /* Codigo Tributacao PIS ===== 1 Tributado, 2 isento, 3 Outros, 4 Reduzido */
/*                                                                                                da COFINS a substring pega 87, 1*/ */
/*                 NO-ERROR. */
/*    */
/*             IF AVAIL natur-oper THEN DO: */
/*             // message "natur-oper" view-as alert-box. */
/*    */
/*                 FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*    */
/*                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) >= 3 OR */
/*                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) >= 17 THEN DO: */
/*             // message "natur-oper2" view-as alert-box. */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO: */
/*             // message "natur-oper3" view-as alert-box. */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 3 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 3 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 3.75                     item-doc-est.val-aliq-cofins        = 17.25 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500. */
/*               ASSIGN L-OK = YES. */
/*    */
/*               END. //nfd natureza outros */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO: */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 3 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 3 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 1.65 */
/*                      item-doc-est.val-aliq-cofins        = 7.60 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760. */
/*               ASSIGN L-OK = YES. */
/*    */
/*               END. //nfe natureza outros */
/*           end.    // natureza outros */
/*        end.       // alcool */
/*                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) < 3 OR */
/*                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) < 17 THEN DO: */
/*                 ASSIGN item-doc-est.idi-tributac-cofins = 3 */
/*                        ITEM-DOC-EST.idi-tributac-pis    = 3 */
/*                        item-doc-est.val-base-calc-cofins  =  b-tt.preco-total[1] - b-tt.valor-icm[1] */
/*                        item-doc-est.base-pis              =  b-tt.preco-total[1] - b-tt.valor-icm[1] */
/*                        item-doc-est.val-aliq-pis           = 1.65 */
/*                        item-doc-est.val-aliq-cofins        = 7.60 */
/*                        item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165 */
/*                        item-doc-est.val-cofins             =  (b-tt.val-base-calc-cofins) * 0.0760. */
/*    */
/*           assign b-tt.idi-tributac-cofins            = 3 */
/*                  b-tt.idi-tributac-pis               = 3. */
/*    */
/*               ASSIGN L-OK = YES. */
/*             END. //outros. */
/*    */
/*    */
/*             IF L-OK = NO THEN DO: */
/*    */
/*             // message "NAO DEU, NOK OK"  VIEW-AS ALERT-BOX. */
/*                 FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*                                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) >= 3 OR */
/*                                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) >= 17 THEN DO: */
/*    */
/*             // message "NAO DEU, NOK OK, ALCOOL"  VIEW-AS ALERT-BOX. */
/*    */
/*                FIND FIRST NATUR-OPER WHERE NATUR-OPER.NAT-OPERACAO = C-NAT-OPER NO-ERROR. */
/*    */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFD" THEN DO: */
/*             // message "NAO DEU, NOK OK, ALCOOL NFD"  VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 1 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 1 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 3.75 */
/*                      item-doc-est.val-aliq-cofins        = 17.25 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0375 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.172500. */
/*               ASSIGN L-OK = YES. */
/*    */
/*               END. */
/*    */
/*               IF NATUR-OPER.ESPECIE-DOC = "NFE" THEN DO: */
/*             // message "NAO DEU, NOK OK, ALCOOL NFE"  VIEW-AS ALERT-BOX. */
/*    */
/*    */
/*               ASSIGN item-doc-est.idi-tributac-cofins    = 1 */
/*                      ITEM-DOC-EST.idi-tributac-pis       = 1 */
/*                      item-doc-est.val-base-calc-cofins  =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.base-pis              =  (b-tt.preco-total[1] + b-tt.valor-frete) - b-tt.valor-icm[1] */
/*                      item-doc-est.val-aliq-pis           = 1.65 */
/*                      item-doc-est.val-aliq-cofins        = 7.60 */
/*                      item-doc-est.valor-pis              = (b-tt.val-base-calc-cofins) * 0.0165 */
/*                      item-doc-est.val-cofins             = (b-tt.val-base-calc-cofins) * 0.0760. */
/*    */
/*               ASSIGN L-OK = YES. */
/*               END. */
/*    */
/*                 FIND FIRST item NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR. */
/*                       IF  DEC(SUBSTRING(item.char-2, 31, 5)) < 3 OR */
/*                       DEC(SUBSTRING(ITEM.CHAR-2, 36,5)) < 17 THEN DO: */
/*    */
/*             // message "ZERA" VIEW-AS ALERT-BOX. */
/*                     ASSIGN item-doc-est.idi-tributac-cofins = 1 */
/*                            ITEM-DOC-EST.idi-tributac-pis    = 1 */
/*                            item-doc-est.val-aliq-pis           = 0 */
/*                            item-doc-est.val-aliq-cofins        = 0 */
/*                            item-doc-est.valor-pis              = 0 */
/*                            item-doc-est.val-cofins             = 0. */
/*    */
/*           assign b-tt.idi-tributac-cofins            = 1 */
/*                  b-tt.idi-tributac-pis               = 1. */
/*    */
/*                         end. //item */
/*                     END. //l-ok */
/*    */
/*                 END. // item-doc-est */
/*    */
/*             END. //tt-epc */
/*    */
/*         END. // ind-event */
/*     end. */
/*  end. */
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
