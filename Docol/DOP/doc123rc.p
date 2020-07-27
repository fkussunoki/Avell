/*****************************************************************************
**       PROGRAMA: doc123rc.p
**       DATA....: Julho de 2013
**       OBJETIVO: Detalhamento das Ordens de Manuten‡Æo e Ferramentaria
**       VERSAO..: 2.06.00.000 
******************************************************************************/

{cdp/cdcfgmat.i}                                             
                                             
/*----------------------------------*/
DEF TEMP-TABLE tt-ferr-movto NO-UNDO
    FIELD nr-ord-produ   like movto-estoq.nr-ord-prod
    FIELD num-ord-des    like movto-estoq.num-ord-des 
    FIELD it-codigo      like movto-estoq.it-codigo  
    FIELD tipo-trans     like movto-estoq.tipo-trans 
    FIELD esp-docto      like movto-estoq.esp-docto  
    FIELD quantidade     like movto-estoq.quantidade 
    FIELD valor-mat-m    like movto-estoq.valor-mat-m
    FIELD valor-ggf-m    like movto-estoq.valor-ggf-m
    FIELD valor-mob-m    like movto-estoq.valor-mob-m
    FIELD conta-contabil AS CHAR FORMAT "x(17)"
    FIELD sc-codigo      LIKE movto-estoq.sc-codigo
    FIELD ct-codigo      LIKE movto-estoq.ct-codigo
    FIELD data           AS DATE
    FIELD cod-estabel    LIKE movto-estoq.cod-estabel
    FIELD narrativa      AS CHAR
    INDEX ch-chave IS PRIMARY nr-ord-produ.

DEF BUFFER b-tt-ferr-movto FOR tt-ferr-movto.
DEF BUFFER b-item FOR ITEM.

DEF TEMP-TABLE tt-ord-reporte
    FIELD nr-ord-produ LIKE ord-prod.nr-ord-produ
    FIELD nr-ord-pai   LIKE ord-prod.nr-ord-produ COLUMN-LABEL "Ord. Pai"
    FIELD log-pai      AS LOG
    INDEX ch-chave IS PRIMARY IS UNIQUE nr-ord-produ.

DEF TEMP-TABLE tt-ord-prod 
    FIELD conta-contab   AS CHAR FORMAT "x(17)"
    FIELD nr-ord-produ   LIKE ord-prod.nr-ord-produ
    FIELD saldo-ini-mat  AS DEC FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Saldo Ini MAT"  
    FIELD valor-mes-mat  AS DEC FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Valor Mes Mat"  
    FIELD saldo-ini-ggf  AS DEC FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Saldo Ini GGF"  
    FIELD valor-mes-ggf  AS DEC FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Valor Mes GGF" 
    INDEX ch-chave IS PRIMARY IS UNIQUE 
        nr-ord-produ.

DEF VAR i-nr-ord-pai       LIKE ord-prod.nr-ord-produ.
DEF VAR log-pode-reportar  AS LOG.
DEF VAR de-horas           AS DEC.
DEF VAR de-saldo-ggf       AS DEC.
DEF VAR de-saldo-mat       AS DEC.
DEF VAR de-saldo-mob       AS DEC.
/*----------------------------------*/
    
DEFINE TEMP-TABLE tt-ordem-manut NO-UNDO
    FIELD data         AS DATE
    FIELD cod_estab    AS CHAR
    FIELD nr-ord-produ AS INTEGER
    FIELD ct-desp      AS CHARACTER
    FIELD sc-desp      AS CHARACTER
    FIELD narrativa    AS CHARACTER
    FIELD valor-mat    AS DECIMAL
    FIELD valor-ggf    AS DECIMAL
    INDEX ordem IS PRIMARY UNIQUE 
        data
        nr-ord-produ.

DEFINE TEMP-TABLE tt-detalhe-ordem NO-UNDO
    FIELD data          AS DATE
    FIELD nr-ord-produ  AS INTEGER
    FIELD esp-docto     AS INTEGER
    FIELD ct-desp       AS CHARACTER
    FIELD sc-desp       AS CHARACTER
    FIELD it-codigo     AS CHARACTER
    FIELD nro-docto     AS CHARACTER
    FIELD valor-mat     AS DECIMAL
    FIELD valor-ggf     AS DECIMAL
    INDEX ord-item  AS PRIMARY UNIQUE
          data
          nr-ord-produ
          it-codigo
          esp-docto.

DEFINE INPUT PARAMETER dt-periodo-ini AS DATE NO-UNDO.
DEFINE INPUT PARAMETER dt-periodo-fim AS DATE NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ordem-manut.
DEFINE OUTPUT PARAMETER TABLE FOR tt-detalhe-ordem.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ferr-movto.
    
DEFINE VARIABLE dt-aux          AS DATE      NO-UNDO.
DEFINE VARIABLE dt-refer        AS DATE      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-valor-movto  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-ggf    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE log-processa    AS LOGICAL   NO-UNDO.

FIND FIRST param-estoq NO-LOCK.

ASSIGN log-processa = YES.

IF dt-periodo-ini <= param-estoq.ult-fech-dia  THEN
   ASSIGN log-processa = NO.

IF dt-periodo-fim <= param-estoq.mensal-ate AND param-estoq.fase-medio > 2 THEN
   ASSIGN log-processa = NO.

IF NOT log-processa THEN
    RETURN "NOK".

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Buscando Manuten‡Æo").

DO dt-aux = dt-periodo-ini TO dt-periodo-fim ON STOP UNDO, LEAVE 
                                             ON ERROR UNDO, LEAVE:

    RUN pi-acompanhar IN h-acomp ("Data em processamento: " + STRING(dt-aux,"99/99/9999")).

    ASSIGN dt-refer = DATE(MONTH(dt-aux),1,YEAR(dt-aux))
           dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.
   
    /* Leitura do movto-estoq filtrando a conta para diminuir o n£mero de registros lidos */
   
    FOR EACH movto-estoq NO-LOCK USE-INDEX data-conta
       WHERE movto-estoq.dt-trans     = dt-aux
         AND movto-estoq.ct-codigo    = "113604" 
         AND movto-estoq.sc-codigo    = ""
         AND movto-estoq.nr-ord-produ > 0,
        EACH ord-manut NO-LOCK
       WHERE ord-manut.nr-ord-produ = movto-estoq.nr-ord-produ:
        IF  movto-estoq.esp-docto <> 1  /* ACA */ AND 
            movto-estoq.esp-docto <> 8  /* EAC */ AND 
            movto-estoq.esp-docto <> 27 /* RDD */ THEN DO:

            FIND FIRST tt-ordem-manut 
                WHERE tt-ordem-manut.data         = dt-refer
                AND   tt-ordem-manut.nr-ord-produ = movto-estoq.nr-ord-produ NO-ERROR.
            IF NOT AVAIL tt-ordem-manut THEN DO:
               FIND msg-ord-man OF ord-manut NO-LOCK NO-ERROR.
               CREATE tt-ordem-manut.
               ASSIGN tt-ordem-manut.data         = dt-refer
                      tt-ordem-manut.nr-ord-produ = movto-estoq.nr-ord-produ
                      tt-ordem-manut.cod_estab    = movto-estoq.cod-estabel
                      tt-ordem-manut.ct-desp      = ord-manut.ct-desp
                      tt-ordem-manut.sc-desp      = ord-manut.sc-desp
                      tt-ordem-manut.narrativa    = IF AVAIL msg-ord-man THEN REPLACE(msg-ord-man.msg-exp,CHR(10),' ') ELSE "".
            END.

            ASSIGN de-valor-movto = movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1].
            /* Verifica se nÆo tem valor para buscar £ltimo m‚dio calculado */
            IF de-valor-movto = 0 AND movto-estoq.quantidade > 0 THEN DO:
                FIND FIRST item-estab NO-LOCK
                     WHERE item-estab.it-codigo   = movto-estoq.it-codigo
                       AND item-estab.cod-estabel = movto-estoq.cod-estabel NO-ERROR.
                ASSIGN de-valor-movto = (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1]) * movto-estoq.quantidade.
            END.
            
            /* Verifica se nÆo tem valor para buscar £ltimo entrada */
            IF de-valor-movto = 0 AND movto-estoq.quantidade > 0 THEN DO:
                FIND item-uni-estab NO-LOCK
                    WHERE item-uni-estab.it-codigo   = movto-estoq.it-codigo
                    AND   item-uni-estab.cod-estabel = movto-estoq.cod-estabel NO-ERROR.
                ASSIGN de-valor-movto = movto-estoq.quantidade * item-uni-estab.preco-ul-ent.
            END.

           IF movto-estoq.tipo-trans = 2 THEN
               ASSIGN tt-ordem-manut.valor-mat = tt-ordem-manut.valor-mat + de-valor-movto.
           ELSE 
               ASSIGN tt-ordem-manut.valor-mat = tt-ordem-manut.valor-mat - de-valor-movto.

           FIND tt-detalhe-ordem
               WHERE tt-detalhe-ordem.data         = movto-estoq.dt-trans
               AND   tt-detalhe-ordem.nr-ord-produ = tt-ordem-manut.nr-ord-produ
               AND   tt-detalhe-ordem.it-codigo    = movto-estoq.it-codigo
               AND   tt-detalhe-ordem.esp-docto    = movto-estoq.esp-docto NO-ERROR.
           IF  NOT AVAIL tt-detalhe-ordem THEN DO:
                CREATE tt-detalhe-ordem.
                ASSIGN tt-detalhe-ordem.data         = movto-estoq.dt-trans 
                       tt-detalhe-ordem.nr-ord-produ = tt-ordem-manut.nr-ord-produ
                       tt-detalhe-ordem.it-codigo    = movto-estoq.it-codigo
                       tt-detalhe-ordem.esp-docto    = movto-estoq.esp-docto
                       tt-detalhe-ordem.ct-desp      = ord-manut.ct-desp
                       tt-detalhe-ordem.sc-desp      = ord-manut.sc-desp.
           END.

           IF movto-estoq.tipo-trans = 2 THEN
               ASSIGN tt-detalhe-ordem.valor-mat = tt-detalhe-ordem.valor-mat + de-valor-movto.
           ELSE 
               ASSIGN tt-detalhe-ordem.valor-mat = tt-detalhe-ordem.valor-mat - de-valor-movto.

       END.      
   END.

   /* Leitura do movimento ggf para pegar n£mero de horas */
   FOR EACH movto-ggf NO-LOCK
      WHERE movto-ggf.dt-trans = dt-aux,
       EACH ord-manut NO-LOCK
      WHERE ord-manut.nr-ord-produ = movto-ggf.nr-ord-produ:

       FIND FIRST tt-ordem-manut 
           WHERE tt-ordem-manut.data         = dt-refer
           AND   tt-ordem-manut.nr-ord-produ = movto-ggf.nr-ord-produ NO-ERROR.
       IF NOT AVAIL tt-ordem-manut THEN DO:
          FIND msg-ord-man OF ord-manut NO-LOCK NO-ERROR.
          CREATE tt-ordem-manut.
          ASSIGN tt-ordem-manut.data         = dt-refer
                 tt-ordem-manut.nr-ord-produ = movto-ggf.nr-ord-produ
                 tt-ordem-manut.cod_estab    = movto-ggf.cod-estabel
                 tt-ordem-manut.ct-desp      = ord-manut.ct-desp
                 tt-ordem-manut.sc-desp      = ord-manut.sc-desp
                 tt-ordem-manut.narrativa    = IF AVAIL msg-ord-man THEN REPLACE(msg-ord-man.msg-exp,CHR(10),' ') ELSE "".
       END.

       ASSIGN de-valor-ggf = (movto-ggf.valor-ggf-1-m[1] + movto-ggf.valor-ggf-2-m[1] + movto-ggf.valor-ggf-3-m[1] + movto-ggf.valor-ggf-4-m[1] + movto-ggf.valor-ggf-5-m[1] + movto-ggf.valor-ggf-6-m[1]).
       IF de-valor-ggf = 0 THEN DO:

           FIND centro-custo NO-LOCK WHERE centro-custo.cc-codigo = movto-ggf.cc-codigo NO-ERROR.
           FIND FIRST ext-per-custo NO-LOCK
                WHERE ext-per-custo.cc-codigo = movto-ggf.cc-codigo
                  AND ext-per-custo.mo-codigo = 0
                  AND ext-per-custo.periodo   = STRING(YEAR(dt-aux),"9999") + STRING(MONTH(dt-aux),"99") 
                  AND ext-per-custo.custo-total[1] > 0  NO-ERROR.
           IF NOT AVAIL ext-per-custo THEN
              FIND LAST ext-per-custo NO-LOCK
                  WHERE ext-per-custo.cc-codigo = movto-ggf.cc-codigo
                    AND ext-per-custo.mo-codigo = 0 
                    AND ext-per-custo.custo-total[1] > 0 NO-ERROR.
           IF AVAIL ext-per-custo AND centro-custo.horas-report > 0 THEN DO:
               ASSIGN de-valor-ggf = (movto-ggf.horas-report * ((ext-per-custo.custo-total[1] + ext-per-custo.custo-total[2] + ext-per-custo.custo-total[3] +
                                                                 ext-per-custo.custo-total[4] + ext-per-custo.custo-total[5] + ext-per-custo.custo-total[6]) / centro-custo.horas-report)).
           END.
           ELSE DO:
               FIND FIRST ext-per-custo NO-LOCK
                    WHERE ext-per-custo.cc-codigo = movto-ggf.cc-codigo
                      AND ext-per-custo.mo-codigo = 0
                      AND ext-per-custo.periodo   = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") 
                      AND ext-per-custo.custo-prev[1] > 0 
                      AND centro-custo.horas-report    > 0 NO-ERROR.
                IF AVAIL ext-per-custo THEN
                   ASSIGN de-valor-ggf = (movto-ggf.horas-report * (ext-per-custo.custo-prev[1] + ext-per-custo.custo-prev[2] + ext-per-custo.custo-prev[3] + 
                                                                    ext-per-custo.custo-prev[4] + ext-per-custo.custo-prev[5] + ext-per-custo.custo-prev[6])).
           END.
       END. /* IF de-valor-ggf = 0  ... */

       IF movto-ggf.tipo-trans = 1 THEN
           ASSIGN tt-ordem-manut.valor-ggf = tt-ordem-manut.valor-ggf + de-valor-ggf.
       ELSE 
           ASSIGN tt-ordem-manut.valor-ggf = tt-ordem-manut.valor-ggf - de-valor-ggf.

       FIND tt-detalhe-ordem
               WHERE tt-detalhe-ordem.data         = movto-ggf.dt-trans
               AND   tt-detalhe-ordem.nr-ord-produ = tt-ordem-manut.nr-ord-produ
               AND   tt-detalhe-ordem.it-codigo    = movto-ggf.it-codigo
               AND   tt-detalhe-ordem.esp-docto    = 0 NO-ERROR.
       IF  NOT AVAIL tt-detalhe-ordem THEN DO:
            CREATE tt-detalhe-ordem.
            ASSIGN tt-detalhe-ordem.data         = movto-ggf.dt-trans 
                   tt-detalhe-ordem.nr-ord-produ = tt-ordem-manut.nr-ord-produ
                   tt-detalhe-ordem.it-codigo    = movto-ggf.it-codigo
                   tt-detalhe-ordem.esp-docto    = 0
                   tt-detalhe-ordem.ct-desp      = ord-manut.ct-desp
                   tt-detalhe-ordem.sc-desp      = ord-manut.sc-desp.
       END.

       IF movto-ggf.tipo-trans = 1 THEN
           ASSIGN tt-detalhe-ordem.valor-ggf = tt-detalhe-ordem.valor-ggf + de-valor-ggf.
       ELSE 
           ASSIGN tt-detalhe-ordem.valor-ggf = tt-detalhe-ordem.valor-ggf - de-valor-ggf.
   END. /* for each movto-ggf.... */
END.




/*
OUTPUT TO c:\spool\ver-manut-maio.txt.
FOR EACH tt-ordem-manut:
    DISP tt-ordem-manut.nr-ord-produ
         tt-ordem-manut.ct-desp
         tt-ordem-manut.sc-desp
         tt-ordem-manut.valor-mat
         tt-ordem-manut.valor-ggf
        WITH STREAM-IO.
END.
OUTPUT CLOSE.

OUTPUT TO c:\spool\ver-det-manut-maio.txt.
FOR EACH tt-detalhe-ordem
    BY tt-detalhe-ordem.nr-ord-produ:
    DISP tt-detalhe-ordem.nr-ord-produ
         tt-detalhe-ordem.ct-desp
         tt-detalhe-ordem.sc-desp
         tt-detalhe-ordem.esp-docto
         tt-detalhe-ordem.valor-mat
         tt-detalhe-ordem.valor-ggf
        WITH STREAM-IO.
END.
OUTPUT CLOSE.


OUTPUT TO c:\spool\ver-logica.txt.

FOR EACH tt-ordem-manut:
    FIND FIRST movto-estoq NO-LOCK USE-INDEX ord-seq
         WHERE movto-estoq.nr-ord-produ = tt-ordem-manut.nr-ord-produ
           AND movto-estoq.esp-docto    = 1 /* ACA */
           AND movto-estoq.dt-trans    >= dt-periodo-ini
           AND movto-estoq.dt-trans    <= dt-periodo-fim NO-ERROR.
    IF AVAIL movto-estoq THEN NEXT.
    

    FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ordem-manut.nr-ord-produ NO-ERROR.
    DISP tt-ordem-manut.nr-ord-produ
         tt-ordem-manut.valor-mat
         tt-ordem-manut.valor-ggf
         ord-prod.conta-desp.

   FOR EACH movto-estoq NO-LOCK
      WHERE movto-estoq.nr-ord-produ = tt-ordem-manut.nr-ord-produ
        AND movto-estoq.dt-trans >= dt-periodo-ini
        AND movto-estoq.dt-trans <= dt-periodo-fim:
       DISP movto-estoq.tipo-trans
            INT(movto-estoq.esp-docto)
            movto-estoq.usuario 
            movto-estoq.conta-contab
            movto-estoq.valor-mat-m[1]
            movto-estoq.valor-ggf-m[1]
            WITH WIDTH 350 STREAM-IO.

   END.
END.

OUTPUT CLOSE.
*/

/* L¢gica ferramentaria */

/* Simula o reporte das ordens */
FOR EACH ord-prod NO-LOCK
   WHERE ord-prod.nr-linha      = 996
     AND ord-prod.nr-ord-produ >= 700000000
     AND ord-prod.nr-ord-produ <= 799999999
     AND ord-prod.cd-planejad   = "Giovani"
     AND ord-prod.ct-codigo     = "113601"
     AND ord-prod.sc-codigo     = "":

    FIND FIRST movto-estoq NO-LOCK USE-INDEX ord-seq
         WHERE movto-estoq.nr-ord-produ  = ord-prod.nr-ord-produ 
           AND movto-estoq.dt-trans     >= dt-periodo-ini
           AND movto-estoq.dt-trans     <= dt-periodo-fim
           AND movto-estoq.esp-docto     = 1 /* ACA */ NO-ERROR.
    IF AVAIL movto-estoq THEN NEXT.

    ASSIGN i-nr-ord-pai = ord-prod.nr-ord-produ.
    FIND FIRST al-res-op WHERE al-res-op.nr-ord-produ = ord-prod.nr-ord-prod NO-LOCK NO-ERROR.
    IF AVAIL al-res-op THEN
       ASSIGN i-nr-ord-pai = al-res-op.nr-ord-res.

    ASSIGN log-pode-reportar = NO
           de-horas          = 0
           de-saldo-ggf      = 0
           de-saldo-mat      = 0
           de-saldo-mob      = 0.

     FIND FIRST movto-estoq NO-LOCK USE-INDEX ord-seq
         WHERE movto-estoq.nr-ord-produ  = ord-prod.nr-ord-produ
           AND movto-estoq.dt-trans     >= dt-periodo-ini
           AND movto-estoq.dt-trans     <= dt-periodo-fim
           AND movto-estoq.esp-docto    <> 8
           AND movto-estoq.tipo-trans    = 2 NO-ERROR.
    IF AVAIL movto-estoq THEN
       ASSIGN log-pode-reportar = YES.
    
    FOR EACH movto-ggf NO-LOCK 
       WHERE movto-ggf.nr-ord-produ  = ord-prod.nr-ord-produ 
         AND movto-ggf.dt-trans     >= dt-periodo-ini  
         AND movto-ggf.dt-trans     <= dt-periodo-fim:
        IF movto-ggf.tipo-trans = 1 THEN
            ASSIGN de-horas = de-horas + movto-ggf.horas-rep.
        ELSE
            ASSIGN de-horas = de-horas - movto-ggf.horas-rep.
    END. /* for each movto-ggf ... */
    IF de-horas <> 0 THEN
       ASSIGN log-pode-reportar = YES.


    FOR EACH ext-ord WHERE ext-ord.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:
        ASSIGN de-saldo-ggf = de-saldo-ggf + 
                              (ext-ord.vl-ggf-db-c-m - ext-ord.vl-ggf-cr-c-m) + 
                              (ext-ord.vl-ggf-deb-m[1] + ext-ord.vl-ggf-deb-m[2] + ext-ord.vl-ggf-deb-m[3]  + 
                               ext-ord.vl-ggf-deb-m[4] + ext-ord.vl-ggf-deb-m[5] + ext-ord.vl-ggf-deb-m[6]) -    
                              (ext-ord.vl-ggf-cre-m[1] + ext-ord.vl-ggf-cre-m[2] + ext-ord.vl-ggf-cre-m[3]  + 
                               ext-ord.vl-ggf-cre-m[4] + ext-ord.vl-ggf-cre-m[5] + ext-ord.vl-ggf-cre-m[6])
               de-saldo-mat = de-saldo-mat + (ext-ord.vl-mat-deb-m  - ext-ord.vl-mat-cre-m)
               de-saldo-mob = de-saldo-mob + (ext-ord.vl-mob-deb-m  - ext-ord.vl-mob-cre-m).
    END. /* for each ext-ord ... */

    IF de-saldo-ggf <> 0 OR de-saldo-mat <> 0 OR de-saldo-mob <> 0 THEN
       ASSIGN log-pode-reportar = YES.
   IF log-pode-reportar = NO THEN NEXT.


   FIND FIRST tt-ord-reporte WHERE tt-ord-reporte.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.
   IF NOT AVAIL tt-ord-reporte THEN DO:
       CREATE tt-ord-reporte.
       ASSIGN tt-ord-reporte.nr-ord-produ = ord-prod.nr-ord-produ
              tt-ord-reporte.log-pai      = NO
              tt-ord-reporte.nr-ord-pai   = i-nr-ord-pai.
   END.
   IF tt-ord-reporte.nr-ord-produ = i-nr-ord-pai THEN DO:
      ASSIGN tt-ord-reporte.log-pai = YES.
   END.          
   ELSE DO:
       FIND FIRST tt-ord-reporte 
           WHERE tt-ord-reporte.nr-ord-produ = i-nr-ord-pai NO-ERROR.
       IF NOT AVAIL tt-ord-reporte THEN DO: 
          CREATE tt-ord-reporte.
          ASSIGN tt-ord-reporte.nr-ord-produ = i-nr-ord-pai.                     
       END.
       ASSIGN tt-ord-reporte.log-pai = YES.
   END. /* else do: */
END. /* FOR EACH ord-prod NO-LOCK ... */

ASSIGN dt-refer = DATE(MONTH(dt-periodo-fim),1,YEAR(dt-periodo-fim))
       dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.




FOR EACH tt-ord-reporte BY tt-ord-reporte.log-pai
                        BY tt-ord-reporte.nr-ord-produ:

    DISP "tt-ord-reporte" tt-ord-reporte.log-pai tt-ord-reporte.nr-ord-produ.
    FIND FIRST tt-ord-prod
         WHERE tt-ord-prod.nr-ord-produ = tt-ord-reporte.nr-ord-produ NO-ERROR.
    IF NOT AVAIL tt-ord-prod THEN DO:
        CREATE tt-ord-prod.
        ASSIGN tt-ord-prod.nr-ord-produ = tt-ord-reporte.nr-ord-produ.
    END. /* IF NOT AVAIL tt-ord-prod .... */  

    IF tt-ord-reporte.log-pai = NO THEN DO:
        FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ord-reporte.nr-ord-produ NO-ERROR.

        FIND FIRST movto-estoq NO-LOCK
             WHERE movto-estoq.nr-ord-produ = tt-ord-reporte.nr-ord-produ
               AND movto-estoq.esp-docto    = 1 /* ACA */
               AND movto-estoq.dt-trans     >= dt-periodo-ini
               AND movto-estoq.dt-trans     <= dt-periodo-fim NO-ERROR.
        IF NOT AVAIL movto-estoq THEN DO:
            CREATE tt-ferr-movto.
            ASSIGN tt-ferr-movto.nr-ord-produ = tt-ord-reporte.nr-ord-produ
                   tt-ferr-movto.num-ord-des   = 0
                   tt-ferr-movto.it-codigo    = ord-prod.it-codigo
                   tt-ferr-movto.tipo-trans   = 1  
                   tt-ferr-movto.esp-docto    = 1 /* ACA */
                   tt-ferr-movto.quantidade   = ord-prod.qt-ordem
                   tt-ferr-movto.valor-mat-m  = 0
                   tt-ferr-movto.valor-ggf-m  = 0
                   tt-ferr-movto.valor-mob-m  = 0
                   tt-ferr-movto.conta-contab = ord-prod.conta-ordem
                   tt-ferr-movto.sc-codigo    = ord-prod.sc-codigo
                   tt-ferr-movto.ct-codigo    = ord-prod.ct-codigo
                   tt-ferr-movto.data         = dt-refer
                   tt-ferr-movto.cod-estabel  = ord-prod.cod-estabel
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").

            CREATE tt-ferr-movto.
            ASSIGN tt-ferr-movto.nr-ord-produ = tt-ord-reporte.nr-ord-pai
                   tt-ferr-movto.num-ord-des  = tt-ord-reporte.nr-ord-produ
                   tt-ferr-movto.it-codigo    = ord-prod.it-codigo
                   tt-ferr-movto.tipo-trans   = 2
                   tt-ferr-movto.esp-docto    = 28 /* Req */
                   tt-ferr-movto.quantidade   = ord-prod.qt-ordem
                   tt-ferr-movto.valor-mat-m  = 0
                   tt-ferr-movto.valor-ggf-m  = 0
                   tt-ferr-movto.valor-mob-m  = 0
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").

            FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ferr-movto.nr-ord-produ NO-ERROR.
            ASSIGN tt-ferr-movto.conta-contab = ord-prod.conta-ordem
                   tt-ferr-movto.sc-codigo    = ord-prod.sc-codigo
                   tt-ferr-movto.ct-codigo    = ord-prod.ct-codigo
                   tt-ferr-movto.data         = dt-refer
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ")
                   tt-ferr-movto.cod-estabel  = ord-prod.cod-estabel.
        END. /* IF NOT AVAIL movto-estoq THEN DO: ... */

        /*FIND FIRST movto-estoq NO-LOCK
             WHERE movto-estoq.nr-ord-produ = tt-ord-reporte.nr-ord-produ
               AND movto-estoq.esp-docto    = 28 /* Req */
               AND movto-estoq.dt-trans     >= dt-periodo-ini
               AND movto-estoq.dt-trans     <= dt-periodo-fim NO-ERROR.
        IF NOT AVAIL movto-estoq THEN DO:
            CREATE tt-ferr-movto.
            ASSIGN tt-ferr-movto.nr-ord-produ = tt-ord-reporte.nr-ord-pai
                   tt-ferr-movto.num-ord-des  = tt-ord-reporte.nr-ord-produ
                   tt-ferr-movto.it-codigo    = ord-prod.it-codigo
                   tt-ferr-movto.tipo-trans   = 2
                   tt-ferr-movto.esp-docto    = 28 /* Req */
                   tt-ferr-movto.quantidade   = ord-prod.qt-ordem
                   tt-ferr-movto.valor-mat-m  = 0
                   tt-ferr-movto.valor-ggf-m  = 0
                   tt-ferr-movto.valor-mob-m  = 0
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").

            FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ferr-movto.nr-ord-produ NO-ERROR.
            ASSIGN tt-ferr-movto.conta-contab = ord-prod.conta-ordem
                   tt-ferr-movto.sc-codigo    = ord-prod.sc-codigo
                   tt-ferr-movto.ct-codigo    = ord-prod.ct-codigo
                   tt-ferr-movto.data         = dt-refer
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ")
                   tt-ferr-movto.cod-estabel  = ord-prod.cod-estabel.
        END.*/ /* IF NOT AVAIL movto-estoq THEN DO: ... */
    END. /*  IF tt-ord-reporte.log-pai = NO  */
    ELSE DO:
        FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ord-reporte.nr-ord-produ NO-ERROR.

        FIND FIRST movto-estoq NO-LOCK
             WHERE movto-estoq.nr-ord-produ = tt-ord-reporte.nr-ord-produ
               AND movto-estoq.esp-docto    = 1 /* ACA */
               AND movto-estoq.dt-trans     >= dt-periodo-ini
               AND movto-estoq.dt-trans     <= dt-periodo-fim NO-ERROR.
        IF NOT AVAIL movto-estoq THEN DO:
           CREATE tt-ferr-movto.
           ASSIGN tt-ferr-movto.nr-ord-produ = tt-ord-reporte.nr-ord-produ
                  tt-ferr-movto.num-ord-des   = 0
                  tt-ferr-movto.it-codigo    = ord-prod.it-codigo
                  tt-ferr-movto.tipo-trans   = 1  
                  tt-ferr-movto.esp-docto    = 1 /* ACA */
                  tt-ferr-movto.quantidade   = ord-prod.qt-ordem
                  tt-ferr-movto.valor-mat-m  = 0
                  tt-ferr-movto.valor-ggf-m  = 0
                  tt-ferr-movto.valor-mob-m  = 0
                  tt-ferr-movto.conta-contab = ord-prod.conta-ordem
                  tt-ferr-movto.sc-codigo    = ord-prod.sc-codigo
                  tt-ferr-movto.ct-codigo    = ord-prod.ct-codigo
                  tt-ferr-movto.data         = dt-refer
                  tt-ferr-movto.cod-estabel  = ord-prod.cod-estabel
                  tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").
        END. /* IF NOT AVAIL movto-estoq THEN DO: ... */


        FIND FIRST movto-estoq NO-LOCK
             WHERE movto-estoq.nr-ord-produ = tt-ord-reporte.nr-ord-produ
               AND movto-estoq.esp-docto    = 27 /* Req */
               AND movto-estoq.dt-trans     >= dt-periodo-ini
               AND movto-estoq.dt-trans     <= dt-periodo-fim NO-ERROR.
        IF NOT AVAIL movto-estoq THEN DO:
            CREATE tt-ferr-movto.
            ASSIGN tt-ferr-movto.nr-ord-produ = tt-ord-reporte.nr-ord-produ
                   tt-ferr-movto.num-ord-des   = 0
                   tt-ferr-movto.it-codigo    = ord-prod.it-codigo
                   tt-ferr-movto.tipo-trans   = 2
                   tt-ferr-movto.esp-docto    = 27 /* RDD */
                   tt-ferr-movto.quantidade   = ord-prod.qt-ordem
                   tt-ferr-movto.valor-mat-m  = 0
                   tt-ferr-movto.valor-ggf-m  = 0
                   tt-ferr-movto.valor-mob-m  = 0
                   tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").

            FIND dc-rtp-ord-prod WHERE dc-rtp-ord-prod.nr-ord-prod = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
            IF AVAIL dc-rtp-ord-prod THEN
               ASSIGN tt-ferr-movto.conta-contab = dc-rtp-ord-prod.conta-aplicacao
                      tt-ferr-movto.sc-codigo    = dc-rtp-ord-prod.sc-aplicacao
                      tt-ferr-movto.ct-codigo    = dc-rtp-ord-prod.ct-aplicacao
                      tt-ferr-movto.data         = dt-refer
                      tt-ferr-movto.cod-estabel  = ord-prod.cod-estabel
                      tt-ferr-movto.narrativa    = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").
        END. /* IF NOT AVAIL movto-estoq THEN DO: ... */
    END. /* else do: */
END. /* tt-ord-reporte ... */





DO dt-aux = dt-periodo-ini TO dt-periodo-fim:
   FOR EACH movto-estoq NO-LOCK
      WHERE movto-estoq.dt-trans  = dt-aux
        AND movto-estoq.esp-docto = 27 /* RDD */
        AND movto-estoq.valor-mat-m[1] = 0            
        AND movto-estoq.valor-ggf-m[1] = 0            
        AND movto-estoq.valor-mob-m[1] = 0:
    /*
   WHERE tt-ferr-movto.conta-contab >= 
     AND tt-ferr-movto.conta-contab <= 
     */

       FIND ord-manut NO-LOCK WHERE ord-manut.nr-ord-produ = movto-estoq.nr-ord-produ NO-ERROR.
       IF AVAIL ord-manut THEN NEXT.

       FIND FIRST tt-ferr-movto WHERE tt-ferr-movto.nr-ord-produ = movto-estoq.nr-ord-produ NO-ERROR.
       IF AVAIL tt-ferr-movto THEN NEXT.


       FIND FIRST tt-ord-prod
            WHERE tt-ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ NO-ERROR.
       IF NOT AVAIL tt-ord-prod THEN DO:
           CREATE tt-ord-prod.
           ASSIGN tt-ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ.
       END. /* IF NOT AVAIL tt-ord-prod .... */  


       FOR EACH al-res-op 
          WHERE al-res-op.nr-ord-res = movto-estoq.nr-ord-produ:
           FIND FIRST tt-ord-prod
                WHERE tt-ord-prod.nr-ord-produ = al-res-op.nr-ord-produ NO-ERROR.
           IF NOT AVAIL tt-ord-prod THEN DO:
               CREATE tt-ord-prod.
               ASSIGN tt-ord-prod.nr-ord-produ = al-res-op.nr-ord-produ.
           END. /* IF NOT AVAIL tt-ord-prod .... */  
       END. /* FOR EACH al-res-op ... */


   END. /* for each movto-estoq .... */
END. /* do dt-aux .... */


FOR EACH tt-ord-prod:
    FOR EACH movto-estoq NO-LOCK
       WHERE movto-estoq.nr-ord-produ  = tt-ord-prod.nr-ord-produ
         AND movto-estoq.dt-trans     >= dt-periodo-ini
         AND movto-estoq.dt-trans     <= dt-periodo-fim:

        ASSIGN dt-refer = DATE(MONTH(movto-estoq.dt-trans),1,YEAR(movto-estoq.dt-trans))
               dt-refer = ADD-INTERVAL(dt-refer,1,'month') - 1.

        CREATE tt-ferr-movto.
        BUFFER-COPY movto-estoq TO tt-ferr-movto
                ASSIGN tt-ferr-movto.data = dt-refer.
    END. /* for each movto-estoq ... */
END. /* DO DT-AUX ... */


EMPTY TEMP-TABLE tt-ord-prod.

/* Valoriza‡Æo das OS da Ferramentaria */
FOR EACH tt-ferr-movto WHERE tt-ferr-movto.esp-docto = 27
                    AND tt-ferr-movto.nr-ord-produ > 0 
                    AND tt-ferr-movto.valor-mat-m[1] = 0 
                    AND tt-ferr-movto.valor-ggf-m[1] = 0 
                    AND tt-ferr-movto.valor-mob-m[1] = 0,
    EACH ITEM NO-LOCK 
   WHERE ITEM.it-codigo = tt-ferr-movto.it-codigo
     AND ITEM.tipo-contr = 4 /* DD */:

        
    EMPTY TEMP-TABLE tt-ord-prod.
    CREATE tt-ord-prod.
    ASSIGN tt-ord-prod.nr-ord-produ = tt-ferr-movto.nr-ord-produ.

    FOR EACH b-tt-ferr-movto NO-LOCK 
       WHERE b-tt-ferr-movto.nr-ord-produ = tt-ferr-movto.nr-ord-produ
         AND b-tt-ferr-movto.num-ord-des  > 0:
         FIND FIRST tt-ord-prod WHERE tt-ord-prod.nr-ord-produ = b-tt-ferr-movto.num-ord-des NO-ERROR.
         IF NOT AVAIL tt-ord-prod THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.nr-ord-produ = b-tt-ferr-movto.num-ord-des.
         END.
    END. /* FOR EACH movto-estoq ... */

    FOR EACH tt-ord-prod:
        FOR EACH ext-ord WHERE ext-ord.nr-ord-produ = tt-ord-prod.nr-ord-produ NO-LOCK:
            ASSIGN tt-ord-prod.saldo-ini-ggf = tt-ord-prod.saldo-ini-ggf + (ext-ord.vl-ggf-db-c-m - ext-ord.vl-ggf-cr-c-m) + 
                                                   (ext-ord.vl-ggf-deb-m[1] + ext-ord.vl-ggf-deb-m[2] + ext-ord.vl-ggf-deb-m[3]  + 
                                                    ext-ord.vl-ggf-deb-m[4] + ext-ord.vl-ggf-deb-m[5] + ext-ord.vl-ggf-deb-m[6]) - 
                                                   (ext-ord.vl-ggf-cre-m[1] + ext-ord.vl-ggf-cre-m[2] + ext-ord.vl-ggf-cre-m[3]  + 
                                                    ext-ord.vl-ggf-cre-m[4] + ext-ord.vl-ggf-cre-m[5] + ext-ord.vl-ggf-cre-m[6])
                   tt-ord-prod.saldo-ini-mat = tt-ord-prod.saldo-ini-mat + (ext-ord.vl-mat-deb-m  - ext-ord.vl-mat-cre-m) + (ext-ord.vl-mob-deb-m  - ext-ord.vl-mob-cre-m).
        END. /* for each ext-ord ... */

        FOR EACH movto-estoq NO-LOCK USE-INDEX ord-seq
           WHERE movto-estoq.nr-ord-produ  = tt-ord-prod.nr-ord-produ
             AND movto-estoq.dt-trans     >= dt-periodo-ini
             AND movto-estoq.dt-trans     <= dt-periodo-fim:
            IF movto-estoq.esp-docto = 1 /* ACA */ OR 
               movto-estoq.esp-docto = 8 /* EAC */ OR
               movto-estoq.esp-docto = 27 THEN NEXT.
             IF movto-estoq.num-ord-des  > 0 THEN NEXT.

             IF movto-estoq.valor-mat-m[1] NE 0
             OR movto-estoq.valor-mob-m[1] NE 0
             OR movto-estoq.valor-ggf-m[1] NE 0 THEN DO:
                IF movto-estoq.tipo-trans = 1 then 
                   ASSIGN tt-ord-prod.valor-mes-mat = tt-ord-prod.valor-mes-mat - (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]).
                ELSE 
                   ASSIGN tt-ord-prod.valor-mes-mat = tt-ord-prod.valor-mes-mat + (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]).
             END.
             ELSE DO:
                 FIND item-estab WHERE item-estab.cod-estabel = movto-estoq.cod-estabel
                                   AND item-estab.it-codigo   = movto-estoq.it-codigo NO-LOCK.
                 FIND b-item WHERE b-item.it-codigo = movto-estoq.it-codigo no-lock.
                 IF b-item.tipo-contr = 2 THEN DO:
                     IF movto-estoq.tipo-trans = 1 THEN 
                        ASSIGN tt-ord-prod.valor-mes-mat = tt-ord-prod.valor-mes-mat - (movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] +  item-estab.val-unit-ggf-m[1])).
                     ELSE 
                        ASSIGN tt-ord-prod.valor-mes-mat = tt-ord-prod.valor-mes-mat  + (movto-estoq.quantidade * (item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] +  item-estab.val-unit-ggf-m[1])).
                 END.
             END. /* else do: */
        END. /* FOR EACH movto-estoq .... */

        FOR EACH movto-ggf NO-LOCK
           WHERE movto-ggf.nr-ord-produ  = tt-ord-prod.nr-ord-produ
             AND movto-ggf.dt-trans     >= dt-periodo-ini
             AND movto-ggf.dt-trans     <= dt-periodo-fim,
            EACH centro-custo NO-LOCK
           WHERE centro-custo.cc-codigo = movto-ggf.cc-codigo:

            FIND FIRST ext-per-custo NO-LOCK
                 WHERE ext-per-custo.cc-codigo = movto-ggf.cc-codigo
                   AND ext-per-custo.mo-codigo = 0
                   AND ext-per-custo.periodo   = STRING(YEAR(dt-periodo-fim),"9999") + STRING(MONTH(dt-periodo-fim),"99") NO-ERROR.
            IF NOT AVAIL ext-per-custo THEN
               FIND LAST ext-per-custo NO-LOCK
                   WHERE ext-per-custo.cc-codigo = movto-ggf.cc-codigo
                     AND ext-per-custo.mo-codigo = 0 
                     AND ext-per-custo.custo-total[1] > 0 NO-ERROR.
            IF NOT AVAIL ext-per-custo THEN NEXT.

            IF movto-ggf.tipo-trans = 1 THEN
                ASSIGN tt-ord-prod.valor-mes-ggf = tt-ord-prod.valor-mes-ggf + 
                                                                      (movto-ggf.horas-report * 
                                                                     ((ext-per-custo.custo-total[1] + 
                                                                       ext-per-custo.custo-total[2] +
                                                                       ext-per-custo.custo-total[3] +
                                                                       ext-per-custo.custo-total[4] +
                                                                       ext-per-custo.custo-total[5] +
                                                                       ext-per-custo.custo-total[6]) / centro-custo.horas-report)).
            ELSE
                ASSIGN tt-ord-prod.valor-mes-ggf = tt-ord-prod.valor-mes-ggf - 
                                                                       (movto-ggf.horas-report * 
                                                                     ((ext-per-custo.custo-total[1] + 
                                                                       ext-per-custo.custo-total[2] +
                                                                       ext-per-custo.custo-total[3] +
                                                                       ext-per-custo.custo-total[4] +
                                                                       ext-per-custo.custo-total[5] +
                                                                       ext-per-custo.custo-total[6]) / centro-custo.horas-report)).
        END. /* FOR EACH movto-ggf... */

        ASSIGN tt-ferr-movto.valor-mat-m[1] = tt-ferr-movto.valor-mat-m[1] + tt-ord-prod.saldo-ini-mat + tt-ord-prod.valor-mes-mat
               tt-ferr-movto.valor-ggf-m[1] = tt-ferr-movto.valor-ggf-m[1] + tt-ord-prod.saldo-ini-ggf + tt-ord-prod.valor-mes-ggf
               tt-ferr-movto.valor-mob-m[1] = 0.
    END. /* FOR EACH tt-ord-prod ... */

    IF tt-ferr-movto.narrativa = "" THEN DO:
        FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ferr-movto.nr-ord-produ NO-ERROR.
        IF AVAIL ord-prod THEN
            ASSIGN tt-ferr-movto.narrativa = replace(replace(ord-prod.narrativa,CHR(13)," "),CHR(10)," ").
    END.

END. /* for each tt-ferr-movto ... */

 /*
 OUTPUT TO c:\spool\ver.txt.
 FOR EACH tt-ferr-movto
     WHERE tt-ferr-movto.conta-contab BEGINS "4":

    FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-produ = tt-ferr-movto.nr-ord-produ NO-ERROR.
    FIND ITEM NO-LOCK WHERE ITEM.it-codigo = tt-ferr-movto.it-codigo NO-ERROR.
    DISP tt-ferr-movto.nr-ord-produ
         tt-ferr-movto.num-ord-des 
         tt-ferr-movto.it-codigo   
         ITEM.fm-codigo
         ITEM.desc-item          FORMAT "x(20)" COLUMN-LABEL "Descricao"
         tt-ferr-movto.tipo-trans  
         tt-ferr-movto.esp-docto   
         tt-ferr-movto.conta-contab
         tt-ferr-movto.quantidade  
         tt-ferr-movto.valor-mat-m[1] 
         tt-ferr-movto.valor-ggf-m[1]    
         tt-ferr-movto.valor-mob-m[1] 
         WITH WIDTH 450 STREAM-IO.

    IF AVAIL ord-prod AND ord-prod.narrativa <> "" THEN DO:
       PUT  space(10) "Narrativa: " replace(replace(ord-prod.narrativa,CHR(13),""),CHR(10),"") FORMAT "x(200)" SKIP.

       /*
           IF INDEX(ord-prod.narrativa,"DESC.CRONOGRAMA :") > 0 AND 
              INDEX(ord-prod.narrativa,"DATA CRIACAO")      > 0 THEN DO:
        
              ASSIGN i-posicao-ini = INDEX(ord-prod.narrativa,"DESC.CRONOGRAMA :") + 17
                     i-tamanho     = INDEX(ord-prod.narrativa,"DATA CRIACAO")  - i-posicao-ini.
              IF i-posicao-ini > 0 AND 
                 i-tamanho     > 0 THEN
                 ASSIGN tt-ferr-movto.narrativa-abrev = SUBSTR(ord-prod.narrativa,i-posicao-ini,i-tamanho).
           END.  
     */               
                   
    END.

 END.
*/

RUN pi-finalizar IN h-acomp.
