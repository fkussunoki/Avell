/*******************************************************************
** bodi317ef-upc.p 
*******************************************************************/
/*  Projeto Mekal - alterado por Marlon - ACTVS - 25/04/2019  */            

/**************************************************************************
** FT4003 - Calculo de Notas
** EVENTOS na sequencia:
**   beforeEfetivaNota
**   ControleNumeroFatura
**   afterCriaItNotaFisc
**   alterawtfatserlote
**   after-create-items
**   AfterEfetivaNota
**   EndCalculaComis
**   TrataSerieNfe
**   TrataChaveNfe
**   EndEfetivaNota
**   trataEnvioNfe
**   AfterGeraXMLTXT
**   EndEfetivaNota2
**                                                                                   /*  N«O encontrado AfterPossuiImpressaoAutomatica */
**************************************************************************/




{cdp/cdcfgmat.i}
{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
def new global shared var v_cdn_empres_usuar    like mguni.empresa.ep-codigo          no-undo.

DEF NEW GLOBAL SHARED VAR rw-nota-fiscal-minuta AS ROWID NO-UNDO.

DEF BUFFER b-nota-fiscal  FOR nota-fiscal.
DEF BUFFER b-it-nota-fisc FOR it-nota-fisc.    

{include/i-epc200.i bodi317ef}
DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc. 


DEF VAR L-IVA-ST-AJU        AS LOG.
DEF VAR de-per-sub-trib     AS DEC.
DEF VAR de-aliq-icms-int    AS DEC.
DEF VAR de-perc-red-base-st AS DEC.


DEF VAR de-vl-ipi         AS DEC.
DEF VAR l-consumo         AS LOG.

DEF VAR c-observ-nota     AS CHAR.
DEF VAR i-parc            AS INT.
DEF VAR dt-venc           AS DATE.

DEF VAR l-nota-drawback AS LOG.

DEF VAR c-ccusto       AS CHAR NO-UNDO.
DEF VAR c-nome-ab-reg  AS CHAR NO-UNDO.
DEF VAR c-tipo-mercado AS CHAR NO-UNDO.
DEF VAR c-mercado      AS CHAR NO-UNDO.
 

DEF VAR dt-venc-aux    AS DATE.

DEF BUFFER b-ex-desc-fatura FOR ex-desc-fatura.
DEF VAR de-valor-original-1 AS DEC.
DEF VAR de-valor-original-2 AS DEC.
DEF VAR de-vl-desconto      AS DEC.

DEF VAR i-cont-itens        AS INT      NO-UNDO.
DEF VAR h-bo                AS HANDLE   NO-UNDO.
DEF VAR c-nr-nota-fis       AS CHAR     NO-UNDO.

DEF VAR log-cria-wdc-agenda-nota AS LOG NO-UNDO.

DEF VAR c-data-entrega AS CHAR NO-UNDO.
DEF VAR c-desc-susp    AS CHAR NO-UNDO.

/*---- Variaveis Especificas Calculo Frete Espec°fico ----*/
DEF TEMP-TABLE tt-nota-frete
    FIELD rw-nota-fiscal AS ROWID.
DEF VAR c-erro-frete AS CHAR.
/*---- (fim)  Variaveis Especificas Calculo Frete Espec°fico ----*/


DEF VAR log-boleto-duplicata AS LOG NO-UNDO.
DEF VAR log-boleto-st        AS LOG NO-UNDO.



/* variaveis para realizacao de empenho  - FKIS 12/01/2020 */
DEFINE VARIABLE h-cd9500    AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-conta-ft  AS ROWID       NO-UNDO.
DEFINE VARIABLE i-cod-canal AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_cod_unid_negoc AS CHAR   NO-UNDO.
def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".




{cdp/cd0666.i}
/*--- email ---*/
{utp/utapi019.i}



    IF  p-ind-event = "BeforeEfetivaNota" THEN DO:
        FIND tt-epc WHERE tt-epc.cod-parameter = "table-rowid" NO-ERROR.
        IF  AVAIL tt-epc THEN DO:
/*            find first param-global no-lock no-error.*/
            find first param-com no-lock no-error.
/*            find first mguni.empresa no-lock where mguni.empresa.ep-codigo = v_cdn_empres_usuar /*param-global.empresa-prin*/ no-error.*/
            FIND wt-docto WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL wt-docto THEN DO:
                find first estabelec where estabelec.cod-estabel = wt-docto.cod-estabel no-lock no-error.

                /***************Log de tempo de efetivaá∆o da nota fiscal**********************/
                DO TRANSACTION:

                   ASSIGN i-cont-itens = 0.  

                   FOR EACH wt-it-docto WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-LOCK.
                       ASSIGN i-cont-itens = i-cont-itens + 1.
                   END.

                   CREATE dc-log-nota-fiscal.
                   ASSIGN dc-log-nota-fiscal.seq-wt-docto   = wt-docto.seq-wt-docto
                          dc-log-nota-fiscal.cod-estabel    = wt-docto.cod-estabel
                          dc-log-nota-fiscal.serie          = wt-docto.serie
                          dc-log-nota-fiscal.cod-usuario    = c-seg-usuario
                          dc-log-nota-fiscal.data-ini       = TODAY
                          dc-log-nota-fiscal.hora-ini       = TIME
                          dc-log-nota-fiscal.data-hora-ini  = DATETIME(TODAY, MTIME)
                          dc-log-nota-fiscal.nome-abrev     = wt-docto.nome-abrev
                          dc-log-nota-fiscal.nr-pedcli      = wt-docto.nr-pedcli
                          dc-log-nota-fiscal.nr-resumo      = wt-docto.nr-resumo
                          dc-log-nota-fiscal.nr-itens       = i-cont-itens
                          dc-log-nota-fiscal.cod-emitente   = wt-docto.cod-emitente.

                   &if "{&bf_mat_versao_ems}" = "2.062" &then
                       ASSIGN dc-log-nota-fiscal.nr-embarque = wt-docto.nr-embarque.
                   &else
                       ASSIGN dc-log-nota-fiscal.nr-embarque = INT(wt-docto.cdd-embarq).
                   &endif
                END.
                /*******************************************************************************/

                FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = wt-docto.cod-emit.

                FIND FIRST conta-ft NO-LOCK
                     WHERE conta-ft.cod-estabel = wt-docto.cod-estabel
                       AND conta-ft.nat-oper    = wt-docto.nat-oper
                       AND conta-ft.cod-canal   = wt-docto.cod-canal NO-ERROR.
                IF NOT AVAIL conta-ft THEN DO TRANSACTION:
                    ASSIGN wt-docto.cod-canal = 0. /* Se nao zerar o canal de venda busca a conta errada no faturamento */
                END.


                find vendor-faixa no-lock WHERE vendor-faixa.ep-codigo    = int(estabelec.ep-codigo) /* /*param-global.empresa-prin*/ 2 */
                                            AND vendor-faixa.cod-cond-pag = wt-docto.cod-cond-pag no-error.
                IF AVAIL vendor-faixa THEN DO:
                     FOR EACH wt-fat-duplic of wt-docto:
                         assign wt-fat-duplic.cod-esp = "VE".
                     END.
                END.

                if wt-docto.nat-operacao BEGINS "7"     OR
                   wt-docto.nat-operacao      = "5501a" OR /* Chamado 81361*/
                   wt-docto.nat-operacao      = "5501b" OR
                   wt-docto.nat-operacao      = "6501a" OR
                   wt-docto.nat-operacao      = "6501b" OR
                   emitente.cod-gr-cli        = 98      THEN DO:
                    FOR EACH wt-fat-duplic of wt-docto:
                        IF wt-docto.cod-port <> 9000 THEN
                          assign wt-fat-duplic.cod-esp = "EX".
                    END.
                END.

                /* Chamado 5.633 */
                IF NOT AVAIL vendor-faixa THEN DO:
                   IF NOT CONNECTED('emsfin') THEN DO:
                      {dop/dbt902.i1 emsfin}
                   END.
                   IF CONNECTED('emsfin') THEN DO TRANSACTION:
                      RUN dop/dcr-acerta-port-fat.p (INPUT ROWID(wt-docto)) NO-ERROR.
                   END.
                END.
                ELSE DO TRANSACTION:
                   assign wt-docto.cod-portador = 4000
                          wt-docto.modalidade   = 6.
                END.
/*    */
                /* Fim-Chamado 5.633 */



                FIND ped-venda NO-LOCK 
                    WHERE ped-venda.nome-abrev   = emitente.nome-abrev
                      AND ped-venda.nr-pedcli    = wt-docto.nr-pedcli NO-ERROR.
                IF AVAIL ped-venda AND ped-venda.tp-pedido = "77" /* CRT */ THEN DO:
                    FOR EACH wt-it-docto WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
                        FIND ped-item NO-LOCK 
                            WHERE ped-item.nome-abrev   = emitente.nome-abrev
                              AND ped-item.nr-pedcli    = wt-docto.nr-pedcli 
                              AND ped-item.nr-sequencia = wt-it-docto.nr-seq-ped NO-ERROR.
                        IF AVAIL ped-item THEN DO:
                           IF substr(ped-item.observ,1,18) = "Ordem de Producao:" THEN
                              ASSIGN wt-it-docto.nr-ord-prod = int(substr(ped-item.observ,19,12)). 

                            IF INDEX(ped-item.observ,"(OP:") > 0 AND INDEX(ped-item.observ,"Item:") > 0 AND 
                               INDEX(ped-item.observ,"Item:") >  INDEX(ped-item.observ,"(OP:")THEN DO:
                               ASSIGN wt-it-docto.nr-ord-prod = int(SUBSTR(ped-item.observ,INDEX(ped-item.observ,"(OP:") + 4, INDEX(ped-item.observ,"Item:") - (INDEX(ped-item.observ,"(OP:") + 4))).
                            END.
                        END. /* if avail ped-item ... */
                    END.
                END. /* if avail ped-venda ... */



                 FOR EACH wt-it-docto 
                    WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto
                      AND wt-it-docto.narrativa    = "",
                     EACH ITEM NO-LOCK
                    WHERE ITEM.it-codigo    = wt-it-docto.it-codigo
                      AND ITEM.ind-imp-desc = 7 /* Narrativa Informada */
                      AND ITEM.ge-codigo    <> 99:
                     ASSIGN wt-it-docto.narrativa = ITEM.desc-item.
                 END. /* FOR EACH wt-it-docto ... */

            END. /* if avail wt-docto ... */
        END. /* if avail tt-epc ... */
    END. /* if p-ind-event ... */


    IF  p-ind-event = "BeforeEfetivaNota" THEN DO:
        FIND tt-epc WHERE tt-epc.cod-parameter = "table-rowid" NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            FIND wt-docto WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL wt-docto THEN DO:            
               find first estabelec where estabelec.cod-estabel = wt-docto.cod-estabel no-lock no-error.

              /**** Dccumento enviado pela C&C em novembro/09 ***********************************************************************************
               *  2. FORMA DE PAGAMENTO PELA C&C
               *            2.3.1 A tabela abaixo ser† v†lida a partir de 01/01/2010.
               *             Obrigaá‰es com vencimento entre os dias 01 e 10 de cada màs ? Pagamento no dia 20 do màs de vencimento
               *             Obrigaá‰es com vencimento entre os dias 11 e 20 de cada màs ? Pagamento no dia 30 do màs de vencimento
               *             Obrigaá‰es com vencimento entre os dias 21 e 31 de cada màs ? Pagamento no dia 10 do màs de vencimento
               **********************************************************************************************************************************/          

               FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = wt-docto.cod-emit.
                          /*  ENTREGA CENTRALIZADA C&C */
               IF (emitente.cgc begins "63004030"  /* C & C */ or 
                   emitente.cgc begins "05942211") /* C & C */  THEN DO:

                   FOR EACH wt-fat-duplic OF wt-docto:
                       ASSIGN dt-venc-aux = ?.
                       IF DAY(wt-fat-duplic.dt-vencimen) >= 01 AND DAY(wt-fat-duplic.dt-vencimen) <= 10 THEN DO:
                          ASSIGN dt-venc-aux = DATE(MONTH(wt-fat-duplic.dt-vencimen),20,YEAR(wt-fat-duplic.dt-vencimen)).
                       END. /* if day .... */
                       ELSE
                       IF DAY(wt-fat-duplic.dt-vencimen) >= 11 AND DAY(wt-fat-duplic.dt-vencimen) <= 20 THEN DO:
                          IF MONTH(wt-fat-duplic.dt-vencimen) = 2 THEN
                             ASSIGN dt-venc-aux = DATE(MONTH(wt-fat-duplic.dt-vencimen),28,YEAR(wt-fat-duplic.dt-vencimen)).
                          ELSE 
                             ASSIGN dt-venc-aux = DATE(MONTH(wt-fat-duplic.dt-vencimen),30,YEAR(wt-fat-duplic.dt-vencimen)).
                       END. /* if day .... */
                       ELSE
                       IF DAY(wt-fat-duplic.dt-vencimen) >= 21 AND DAY(wt-fat-duplic.dt-vencimen) <= 31 THEN DO:
                          ASSIGN dt-venc-aux = DATE(MONTH(wt-fat-duplic.dt-vencimen),01,YEAR(wt-fat-duplic.dt-vencimen))
                                 dt-venc-aux = dt-venc-aux + 35
                                 dt-venc-aux = DATE(MONTH(dt-venc-aux),10,YEAR(dt-venc-aux)).
                       END. /* if day .... */

                       IF dt-venc-aux <> ? THEN DO:
                          FIND FIRST calen-com NO-LOCK
                               WHERE calen-com.ep-codigo    = estabelec.ep-codigo /*i-ep-codigo-usuario */
                                 AND calen-com.cod-estabel  = wt-docto.cod-estabel /* "9" */
                                 AND calen-com.data        >= dt-venc-aux 
                                 AND calen-com.tipo         = 1 /* util */ NO-ERROR.
                          IF AVAIL calen-com THEN
                             ASSIGN dt-venc-aux = calen-com.data.
                          ASSIGN wt-fat-duplic.dt-vencimen = dt-venc-aux.
                       END. /* if dt-venc-aux... */

                   END. /* for each wt-fat-duplic ... */
               END. /* if emitente.cgc ... */
            END. /* if avail wt-docto */
        END. /* if avail tt-epc ... */
    END.


    IF  p-ind-event = "ControleNumeroFatura" THEN DO:

        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = "nr-nota-fis" NO-ERROR.

        /***************Log de tempo de efetivaá∆o da nota fiscal**********************/
        IF  AVAIL tt-epc THEN DO TRANSACTION:

            FIND FIRST dc-log-nota-fiscal WHERE dc-log-nota-fiscal.seq-wt-docto = int(entry(2, tt-epc.val-parameter, ";")) EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL  dc-log-nota-fiscal THEN
               ASSIGN dc-log-nota-fiscal.nr-nota-fis = entry(1, tt-epc.val-parameter, ";").

        END.
        /*******************************************************************************/
    END.

    IF p-ind-event = "AfterEfetivaNota" THEN DO:
            FIND tt-epc WHERE tt-epc.cod-parameter = "table-rowid" NO-ERROR.
            IF  AVAIL tt-epc THEN DO:
                FIND wt-docto WHERE ROWID(wt-docto)      = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

                &if "{&bf_mat_versao_ems}" = "2.062" &then
                    IF AVAIL wt-docto AND wt-docto.nr-embarque > 0 THEN DO:
                &else
                    IF AVAIL wt-docto AND wt-docto.cdd-embarq > 0 THEN DO:
                &endif
                
                    &if "{&bf_mat_versao_ems}" = "2.062" &then
                        FIND FIRST b-nota-fiscal NO-LOCK
                             WHERE b-nota-fiscal.nr-embarque = wt-docto.nr-embarque
                               AND b-nota-fiscal.nr-resumo   = wt-docto.nr-resumo    NO-ERROR.
                    &else
                        FIND FIRST b-nota-fiscal NO-LOCK
                             WHERE b-nota-fiscal.cdd-embarq = wt-docto.cdd-embarq
                               AND b-nota-fiscal.nr-resumo  = wt-docto.nr-resumo    NO-ERROR.
                    &endif

                    ASSIGN l-nota-drawback = NO.
                    FOR EACH b-it-nota-fisc OF b-nota-fiscal:
                        FIND natur-oper NO-LOCK WHERE natur-oper.nat-oper = b-it-nota-fisc.nat-oper NO-ERROR.
                        IF natur-oper.log-natur-operac-draw /* DrawBack */ THEN
                            ASSIGN l-nota-drawback = YES.
                    END. /* for each wt-it-docto ... */


                    IF l-nota-drawback THEN DO:
                       run doepc/upc-bodi317-cria-drawback.p (input ROWID(b-nota-fiscal)).
                    END. /* if l-nota-drawback */
                END. /* if avail wt-docto ... */

            END. /* if avail tt-epc ... */

            /* CAMPANHA BASETEC - envia e-mail para †rea de marketing - VALMIR 10/11/2008 
            FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
            IF AVAIL nota-fiscal  THEN DO:
                RUN dop/dpd399g.p (INPUT ROWID(nota-fiscal)).
            END.
            */



    END. /* if p-ind-event ... */













    IF  p-ind-event = "EndEfetivaNota":U THEN DO:
    
        FIND FIRST tt-epc WHERE
                   tt-epc.cod-event     = p-ind-event            AND
                   tt-epc.cod-parameter = "ROWID(nota-fiscal)":U NO-LOCK NO-ERROR.
        IF  AVAIL tt-epc THEN DO:
            FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
    
            IF AVAIL nota-fiscal THEN
               ASSIGN rw-nota-fiscal-minuta = ROWID(nota-fiscal).
    
    
    
            IF AVAIL nota-fiscal AND nota-fiscal.cod-cond-pag = 595 /* condiá∆o 595 - Cart∆o BNDES */  THEN DO:
               RUN dop/email.p (INPUT "automatico@docol.com.br",                                                         /* Remetente */
                                INPUT "fabio.costa@docol.com.br;gisele.mafra@docol.com.br;bianca.heinz@docol.com.br",        /* Para      */
                                INPUT "Faturamento CART«O BNDES - Nota: " + nota-fiscal.nr-nota-fis,                     /* Assunto   */
                                INPUT "Nota: " + nota-fiscal.nr-nota-fis + " Pedido: " + nota-fiscal.nr-pedcli + " Cliente: " + STRING(nota-fiscal.cod-emitente) + " - " + nota-fiscal.nome-ab-cli + " - Cart∆o BNDES!", /* Mensagem  */
                                INPUT "",                                                                               /* Anexo     */
                                OUTPUT TABLE tt-erros).
            END.
    
    
            /***************** FRETE - CALCULO PROVISAO ******************************/
            IF AVAIL nota-fiscal THEN DO:
                FOR EACH tt-nota-frete:
                    DELETE tt-nota-frete.
                END.
                CREATE tt-nota-frete.
                ASSIGN tt-nota-frete.rw-nota-fiscal = ROWID(nota-fiscal).
                /*
                run dop/dfr9001.p (INPUT nota-fiscal.cod-estabel,
                                   INPUT nota-fiscal.serie,
                                   INPUT nota-fiscal.nr-nota-fis,
                                   OUTPUT c-erro-calculo-frete).
                                   */
                RUN dop/dfr9050.p (INPUT TABLE tt-nota-frete,
                                   OUTPUT c-erro-frete).
    
                IF c-erro-frete <> "" THEN DO:
                    RUN dop/email.p (INPUT "Automatico@docol.com.br",            /* Remetente */
                                     INPUT "gilmarp@docol.com.br",               /* Para      */
                                     INPUT "ERRO FRETE - Nota Fiscal: " + nota-fiscal.nr-nota-fis,  /* Assunto   */
                                     INPUT c-erro-frete,                        /* Mensagem  */
                                     INPUT "",                                   /* Anexo     */
                                     OUTPUT TABLE tt-erros).
    
                    RUN dop/email.p (INPUT "Automatico@docol.com.br",            /* Remetente */
                                     INPUT "gilmarp@docol.com.br",               /* Para      */
                                     INPUT "ERRO FRETE - Nota Fiscal: " + nota-fiscal.nr-nota-fis,  /* Assunto   */
                                     INPUT c-erro-frete,                        /* Mensagem  */
                                     INPUT "",                                   /* Anexo     */
                                     OUTPUT TABLE tt-erros).
                END.
            END.
            /***************** (FIM) FRETE - CALCULO PROVISAO ******************************/

            
                   
            IF  AVAIL nota-fiscal AND nota-fiscal.dt-emis-nota >= 11/01/2007 THEN DO TRANSACTION:
    
                /****************************************************************************** 
                 **                                                                             
                 **           N U M E R O        S E Q U E N C I A L         U N I C O          
                 **                                                                             
                 ******************************************************************************/
                FIND FIRST esp-nsu-estabel WHERE
                           esp-nsu-estabel.cod-estabel = nota-fiscal.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL esp-nsu-estabel THEN DO:
                    IF  esp-nsu-estabel.num-seq-unico = 9999999999 THEN
                        ASSIGN esp-nsu-estabel.num-seq-unico = 0000000001.
                    ELSE
                        ASSIGN esp-nsu-estabel.num-seq-unico = esp-nsu-estabel.num-seq-unico + 1.
                    
                    CREATE esp-nsu-gera.
                    ASSIGN esp-nsu-gera.cod-estabel   = nota-fiscal.cod-estabel
                           esp-nsu-gera.serie         = nota-fiscal.serie
                           esp-nsu-gera.nr-nota-fis   = nota-fiscal.nr-nota-fis
                           esp-nsu-gera.num-seq-unico = esp-nsu-estabel.num-seq-unico
                           esp-nsu-gera.dt-gera-nsu   = DATE(STRING(DAY(TODAY)) + "/" + STRING(MONTH(TODAY),"99") + "/" + STRING(SUBSTR(STRING(YEAR(TODAY),"9999"),3,2))). 
                           esp-nsu-gera.hr-gera-nsu   = STRING(TIME,"HH:MM").
                END.
            END.
            /********* (FIM)   N U M E R O   S E Q U E N C I A L     U N I C O *******/ 
    
    
            /*----- CRIA DC-NOTA-FISCAL ----*/
            IF AVAIL nota-fiscal THEN DO TRANSACTION:
                RUN dop/dft000.p (INPUT nota-fiscal.cod-estabel,
                                  INPUT nota-fiscal.serie,
                                  INPUT nota-fiscal.nr-nota-fis,
                                  OUTPUT c-mercado,
                                  OUTPUT c-tipo-mercado,
                                  OUTPUT c-ccusto,
                                  OUTPUT c-nome-ab-reg).
                       
                FIND FIRST dc-nota-fiscal 
                     WHERE dc-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       AND dc-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                       AND dc-nota-fiscal.serie       = nota-fiscal.serie NO-ERROR.
                IF NOT AVAIL dc-nota-fiscal  THEN DO:
                   CREATE dc-nota-fiscal.
                   ASSIGN dc-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                          dc-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                          dc-nota-fiscal.serie       = nota-fiscal.serie.
                END.
                ASSIGN dc-nota-fiscal.cc-codigo   = c-ccusto                   
                       dc-nota-fiscal.nome-ab-reg = c-nome-ab-reg.
                       /* dc-nota-fiscal.cod-livre-1 =   */.
            END. /* if avail nota-fiscal ... */
            /*----- (fim) CRIA DC-NOTA-FISCAL ----*/
    
    
    
    
            /*------ Agendamento de Entrega -------*/
            ASSIGN log-cria-wdc-agenda-nota = NO.
            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
            FIND FIRST wdc-agenda-cliente
                 WHERE wdc-agenda-cliente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF NOT AVAIL wdc-agenda-cliente THEN
                FIND FIRST wdc-agenda-cliente
                     WHERE wdc-agenda-cliente.nome-matriz = emitente.nome-matriz NO-ERROR.
            IF NOT AVAIL wdc-agenda-cliente THEN
                FIND FIRST wdc-agenda-cliente
                     WHERE wdc-agenda-cliente.cnpj = emitente.cgc NO-ERROR.
            IF NOT AVAIL wdc-agenda-cliente THEN
                FIND FIRST wdc-agenda-cliente
                     WHERE wdc-agenda-cliente.cnpj = substr(emitente.cgc,1,8) NO-ERROR.
            IF AVAIL wdc-agenda-cliente THEN 
               ASSIGN log-cria-wdc-agenda-nota = YES.
            /*------ (fim) Agendamento de Entrega -------*/
    
    
            IF nota-fiscal.cidade-cif <> "" /* CIF */ THEN DO:
                FIND transporte NO-LOCK WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
                IF AVAIL transporte THEN DO:
                   FIND dc-transporte NO-LOCK WHERE dc-transporte.cod-transp = transporte.cod-transp NO-ERROR.
                   IF AVAIL dc-transporte THEN
                      ASSIGN log-cria-wdc-agenda-nota = YES.
                END.
            END. /* IF nota-fiscal.... */
                  
           IF log-cria-wdc-agenda-nota THEN 
              RUN dop/dwd006ag.p (INPUT ROWID(nota-fiscal)).
    
           /*-------------------------------------------------------------------------------------
            * Substituiá∆o Tribut†ria para S«O PAULO, imprimir na NOTA-FISCAL
            *  -> Incluso em 03/10/2017 - exceá∆o para natureza 6101y - Cliente Olimar - NDS 61195
            *------------------------------------------------------------------------------------*/
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
            IF nota-fiscal.dt-emis-nota  >= 05/01/2008  AND 
               nota-fiscal.estado         = "SP"        and
               nota-fiscal.nat-operacao <> '6101y'      THEN DO TRANSACTION:

               FIND ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                         AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

               IF (AVAIL ped-venda AND  ped-venda.cod-des-mer = 2    /* Consumo */)   THEN 
                   ASSIGN l-consumo = YES.
               ELSE
                   ASSIGN l-consumo = NO.
    
               IF  emitente.contrib-icms      = YES          AND 
                   emitente.insc-subs-trib    = ""           AND
                   l-consumo                  = NO           AND 
                 ((emitente.categoria         <> "I"         AND /* N«O CONSIDERA = Industria da Construcao Civil */
                   emitente.categoria         <> "O"         AND /* N«O CONSIDERA = Construtora/SPE               */
                   emitente.categoria         <> "Z"         AND /* N«O CONSIDERA = Orgaos Publicos               */  
                   emitente.categoria         <> "L"         AND /* N«O CONSIDERA = Hoteis                        */  
                   emitente.categoria         <> "D")        OR  /* N«O CONSIDERA = Industria                     */  
                   emitente.cod-canal         = 105)             /* CONSIDERA = Instaladora Hidraulica        */
                   THEN DO:
                   
                     FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK
                         WHERE (it-nota-fisc.cd-trib-icm = 1 OR it-nota-fisc.cd-trib-icm = 4),
                         EACH ITEM NO-LOCK
                        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
    
                         
                         /* - Chamado 8410
                         FIND natur-oper NO-LOCK WHERE natur-oper.nat-oper = it-nota-fisc.nat-oper NO-ERROR.
                         IF natur-oper.consum-final THEN ASSIGN l-consumo = YES. ELSE l-consumo = NO.
                         */
                         
    
    
                         IF l-consumo = NO                                AND 
                            (it-nota-fisc.nat-oper       BEGINS "6101"    OR     /* Venda */                     
                             it-nota-fisc.nat-oper       BEGINS "6501"    OR     /* Venda - Equiparada Exporta */
                          /* it-nota-fisc.nat-oper       BEGINS "6124"    OR */  /* Industrializacao  */
                             it-nota-fisc.nat-oper       BEGINS "6922"    OR     /* Entrega Futura  */
            
                          /****************************************************************************************************************
                          /* Favor incluir as naturezas de operaá∆o ref. Bonificaá‰es na sistem†tica de substituiá∆o tribut†ria SP.
                             6910AH,6910C, 6910F, 6910P, 6910q, 6910W e 6910ZB*/
                             it-nota-fisc.nat-oper       = "6910AH"  OR 
                             it-nota-fisc.nat-oper       = "6910C"   OR 
                             it-nota-fisc.nat-oper       = "6910F"   OR 
                             it-nota-fisc.nat-oper       = "6910P"   OR 
                             it-nota-fisc.nat-oper       = "6910q"   OR 
                             it-nota-fisc.nat-oper       = "6910W"   OR 
                             it-nota-fisc.nat-oper       = "6910ZB"  OR
            
                         /* Segue as CFOP's de brindes que consta o centro de custo da regional de S∆o Paulo para substituiá∆o tribut†ria.
                             --> 5.910b / 6.910b / 5.910ae / 6.910ae */
                             it-nota-fisc.nat-oper       = "5910b"   OR 
                             it-nota-fisc.nat-oper       = "6910b"   OR 
                             it-nota-fisc.nat-oper       = "5910ae"  OR 
                             it-nota-fisc.nat-oper       = "6910ae") 
                             ***************************************************************************************************************/
    
                             /* Brindes ou Bonificaá‰es */
                             it-nota-fisc.nat-oper       BEGINS "6910")  THEN DO:
    
                             /* Atualiza as variaveis: de-per-sub-trib e  de-aliq-icms-int */
                             {dop/dft039st.i "it-nota-fisc" nota-fiscal.estado it-nota-fisc.dt-emis-nota 1 nota-fiscal.cod-emitente}
                             IF de-per-sub-trib > 0 THEN DO:
    
                                 FIND FIRST st-nota-fiscal 
                                      WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                        AND st-nota-fiscal.serie           = nota-fiscal.serie      
                                        AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                                 IF NOT AVAIL st-nota-fiscal THEN DO:
                                     CREATE st-nota-fiscal.
                                     ASSIGN st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                            st-nota-fiscal.serie           = nota-fiscal.serie      
                                            st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis
                                            st-nota-fiscal.situacao        = "NAO IMPRESSO"
                                            st-nota-fiscal.vl-bsubs-nota   = 0
                                            st-nota-fiscal.vl-icmsub-nota  = 0.
                                 END.
    
                                 CREATE st-it-nota-fis.
                                 ASSIGN st-it-nota-fis.cod-estabel   = it-nota-fisc.cod-estabel
                                        st-it-nota-fis.serie         = it-nota-fisc.serie      
                                        st-it-nota-fis.nr-nota-fis   = it-nota-fisc.nr-nota-fis
                                        st-it-nota-fis.nr-seq-fat    = it-nota-fisc.nr-seq-fat 
                                        st-it-nota-fis.it-codigo     = it-nota-fisc.it-codigo.
    
    
                                 IF it-nota-fisc.cd-trib-ipi = 1 OR  it-nota-fisc.cd-trib-ipi = 4 THEN
                                    ASSIGN de-vl-ipi = it-nota-fisc.vl-ipi-it.
                                 ELSE
                                    ASSIGN de-vl-ipi = 0.
    
                                 ASSIGN st-it-nota-fis.vl-bsubs-it   = /* ROUND(((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) + it-nota-fisc.vl-despes-it + de-vl-ipi) * (1 + (de-per-sub-trib / 100)),2) */
                                                                       ROUND((it-nota-fisc.vl-tot-item * (1 + (de-per-sub-trib / 100))),2) 
                                        st-it-nota-fis.vl-bsubs-it   = round(st-it-nota-fis.vl-bsubs-it - (st-it-nota-fis.vl-bsubs-it * de-perc-red-base-st / 100),2)
                                        st-it-nota-fis.vl-icmsub-it  = ROUND(((st-it-nota-fis.vl-bsubs-it * de-aliq-icms-int / 100) - it-nota-fisc.vl-icms-it),2).
    
                                 ASSIGN st-nota-fiscal.vl-bsubs-nota   = st-nota-fiscal.vl-bsubs-nota  + st-it-nota-fis.vl-bsubs-it 
                                        st-nota-fiscal.vl-icmsub-nota  = st-nota-fiscal.vl-icmsub-nota + st-it-nota-fis.vl-icmsub-it.
                             END. /* if de-per-sub-trib ... */
    
    
                         END. /* if it-nota-fisc.nat-oper ... */
                     END. /* for each it-nota-fisc ... */
    
                     FIND FIRST st-nota-fiscal 
                          WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                            AND st-nota-fiscal.serie           = nota-fiscal.serie      
                            AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                     IF AVAIL st-nota-fiscal THEN DO:
                        FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
    
                        /* Retorna a Parcela/Data de Vencimento/Mensagem */
                        RUN dop/dft039sp.p (INPUT ROWID(st-nota-fiscal),
                                            OUTPUT c-observ-nota,
                                            OUTPUT i-parc,
                                            OUTPUT dt-venc).
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota      + chr(10) + c-observ-nota.
                     END.
               END. /* if ... */
            END. /* if nota-fiscal.estado = SP */
            /** (FIM) SUBSTITUIÄ«O SP ****/
    
    
    
    
    
    
    
    
    
           /*------------------------- Colocado em comentaro logica ST para RS conforme e-mail abaixo: ----------------------------------------------------------------------------------
              Bom dia,
              Conforme Protocolo ICMS 14 de 01/04/11 o Estado do Rio Grande do Sul aderiu ao Protocolo ICMS 196 de 11/12/09 nas operaá‰es de Materiais de Construá∆o com o Estado de Santa Catarina, o qual foi introduzido no Regulamento do ICMS/RS atravÇs do Decreto 47.997 de 05/05/11 que entrar† em vigor a partir de 01/06/11.
              Significa que os dados de Base de C†lculo e valor de ICMS-ST ser∆o impressos nas notas fiscais e o recolhimento ser† feito em nome da Docol.
               
              Eduardo e Diomar,
              1) Nota fiscal Ö Colocar nos campos pr¢prios a BASE DE CµLCULO DO ICMS ST e VALOR DO ICMS ST. Nos dados adicionais a mensagem: ICMS ST recolhido cfe. DECRETO 47.997 de 05/05/11.
              A CFOP ser† 6.401.
               
              2) Recolhimento GNRE Ö Ser† recolhido em nome da Docol por nota fiscal no c¢digo de receita 10009-9. 
              Nos dados adicionais o nß do CNPJ e Inscriá∆o Estadual do cliente.
              
              No campo 15 alterar o nß do Decreto para: DECRETO 47.997 de 05/05/11.
              
               
              
              3) O percentual dos MVA n∆o foram alterados.
               
              Faturamento,
              No dia 01/06/11, a inform†tica necessita fazer alteraá‰es no sistema EMS.
              Ent∆o, somente poder† faturar p/o Estado do Rio Grande do Sul depois da liberaá∆o da inform†tica.
               
              Atenciosamente,
               
              Francisca F. Castro Tenfen 
           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
            /*-------------------------------------------------------------------------------------
             * Substituiá∆o Tribut†ria para Rio Grande do Sul, imprimir na NOTA-FISCAL
             *------------------------------------------------------------------------------------*/
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
            IF nota-fiscal.dt-emis-nota  >= 09/01/2009  AND 
               nota-fiscal.estado         = "RS"        THEN DO:
    
                FIND ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                         AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                IF (AVAIL ped-venda AND  ped-venda.cod-des-mer = 2    /* Consumo */)   THEN 
                   ASSIGN l-consumo = YES.
                ELSE
                   ASSIGN l-consumo = NO.
    
    
               IF  emitente.contrib-icms      = YES          AND 
                   emitente.insc-subs-trib    = ""           AND
                   l-consumo                  = NO           AND 
                 ((emitente.categoria         <> "I"         AND /* N«O CONSIDERA = Industria da Construcao Civil */
                   emitente.categoria         <> "O"         AND /* N«O CONSIDERA = Construtora/SPE               */
                   emitente.categoria         <> "Z"         AND /* N«O CONSIDERA = Orgaos Publicos               */  
                   emitente.categoria         <> "L"         AND /* N«O CONSIDERA = Hoteis                        */  
                   emitente.categoria         <> "D")        OR  /* N«O CONSIDERA = Industria                     */  
                   emitente.cod-canal         = 105)             /* CONSIDERA = Instaladora Hidraulica        */
                   THEN DO:
    
                     FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK
                        WHERE (it-nota-fisc.cd-trib-icm = 1 OR it-nota-fisc.cd-trib-icm = 4):
    
                         
                         FIND natur-oper NO-LOCK WHERE natur-oper.nat-oper = it-nota-fisc.nat-oper NO-ERROR.                     
                         IF natur-oper.consum-final THEN ASSIGN l-consumo = YES. ELSE l-consumo = NO.
                         
    
                         IF l-consumo    = NO                              AND
                            (it-nota-fisc.nat-oper       BEGINS "6101"    OR     /* Venda */                     
                             it-nota-fisc.nat-oper       BEGINS "6501"    OR     /* Venda - Equiparada Exporta */
                          /* it-nota-fisc.nat-oper       BEGINS "6124"    OR */  /* Industrializacao  */
                             it-nota-fisc.nat-oper       BEGINS "6922"    OR     /* Entrega Futura  */
            
                          /********************************************************************************************************************
                          /* Favor incluir as naturezas de operaá∆o ref. Bonificaá‰es na sistem†tica de substituiá∆o tribut†ria SP.
                             6910AH,6910C, 6910F, 6910P, 6910q, 6910W e 6910ZB*/
                             it-nota-fisc.nat-oper       = "6910AH"  OR 
                             it-nota-fisc.nat-oper       = "6910C"   OR 
                             it-nota-fisc.nat-oper       = "6910F"   OR 
                             it-nota-fisc.nat-oper       = "6910P"   OR 
                             it-nota-fisc.nat-oper       = "6910q"   OR 
                             it-nota-fisc.nat-oper       = "6910W"   OR 
                             it-nota-fisc.nat-oper       = "6910ZB"  OR
            
                         /* Segue as CFOP's de brindes que consta o centro de custo da regional de S∆o Paulo para substituiá∆o tribut†ria.
                             --> 5.910b / 6.910b / 5.910ae / 6.910ae */
                             it-nota-fisc.nat-oper       = "5910b"   OR 
                             it-nota-fisc.nat-oper       = "6910b"   OR 
                             it-nota-fisc.nat-oper       = "5910aa"  OR 
                             it-nota-fisc.nat-oper       = "6910aa") 
                            ***********************************************************************************************************************/
    
                             /* Brindes ou Bonificaá‰es */
                             it-nota-fisc.nat-oper       BEGINS "6910")   THEN DO:
    
                             /* Atualiza as variaveis: de-per-sub-trib e  de-aliq-icms-int */
                             {dop/dft039st.i "it-nota-fisc" nota-fiscal.estado it-nota-fisc.dt-emis-nota 1}
    
                             IF de-per-sub-trib > 0 THEN DO:
                                 FIND FIRST st-nota-fiscal 
                                      WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                        AND st-nota-fiscal.serie           = nota-fiscal.serie      
                                        AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                                 IF NOT AVAIL st-nota-fiscal THEN DO:
                                     CREATE st-nota-fiscal.
                                     ASSIGN st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                            st-nota-fiscal.serie           = nota-fiscal.serie      
                                            st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis
                                            st-nota-fiscal.situacao        = "NAO IMPRESSO"
                                            st-nota-fiscal.vl-bsubs-nota   = 0
                                            st-nota-fiscal.vl-icmsub-nota  = 0.
                                 END.
    
                                 CREATE st-it-nota-fis.
                                 ASSIGN st-it-nota-fis.cod-estabel   = it-nota-fisc.cod-estabel
                                        st-it-nota-fis.serie         = it-nota-fisc.serie      
                                        st-it-nota-fis.nr-nota-fis   = it-nota-fisc.nr-nota-fis
                                        st-it-nota-fis.nr-seq-fat    = it-nota-fisc.nr-seq-fat 
                                        st-it-nota-fis.it-codigo     = it-nota-fisc.it-codigo.
    
                                 IF it-nota-fisc.cd-trib-ipi = 1 OR  it-nota-fisc.cd-trib-ipi = 4 THEN
                                    ASSIGN de-vl-ipi = it-nota-fisc.vl-ipi-it.
                                 ELSE
                                    ASSIGN de-vl-ipi = 0.
    
                                 ASSIGN st-it-nota-fis.vl-bsubs-it   = /* ROUND(((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) + it-nota-fisc.vl-despes-it + de-vl-ipi) * (1 + (de-per-sub-trib / 100)),2) */
                                                                       ROUND((it-nota-fisc.vl-tot-item * (1 + (de-per-sub-trib / 100))),2) 
                                        st-it-nota-fis.vl-bsubs-it   = round(st-it-nota-fis.vl-bsubs-it - (st-it-nota-fis.vl-bsubs-it * de-perc-red-base-st / 100),2)
                                        st-it-nota-fis.vl-icmsub-it  = ROUND(((st-it-nota-fis.vl-bsubs-it * de-aliq-icms-int / 100) - it-nota-fisc.vl-icms-it),2).
    
                                 ASSIGN st-nota-fiscal.vl-bsubs-nota   = st-nota-fiscal.vl-bsubs-nota  + st-it-nota-fis.vl-bsubs-it 
                                        st-nota-fiscal.vl-icmsub-nota  = st-nota-fiscal.vl-icmsub-nota + st-it-nota-fis.vl-icmsub-it.
                             END. /* if de-per-sub-trib > 0 */
    
    
                         END. /* if it-nota-fisc.nat-oper ... */
                     END. /* for each it-nota-fisc ... */
    
                     FIND FIRST st-nota-fiscal 
                          WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                            AND st-nota-fiscal.serie           = nota-fiscal.serie      
                            AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                     IF AVAIL st-nota-fiscal THEN DO:
                        FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
    
                        /* Retorna a Parcela/Data de Vencimento/Mensagem */
                        RUN dop/dft039rs.p (INPUT ROWID(st-nota-fiscal),
                                            OUTPUT c-observ-nota,
                                            OUTPUT i-parc,
                                            OUTPUT dt-venc).
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota      + chr(10) + c-observ-nota.
                     END.
               END. /* if ... */
            END. /* if nota-fiscal.estado = RS */
            /** (FIM) SUBSTITUIÄ«O RS ****/
            ---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    
    
    
    
    
    
            /*-------------------------------------------------------------------------------------
             * Substituiá∆o Tribut†ria para Rio Grande do Sul, imprimir na NOTA-FISCAL
             *------------------------------------------------------------------------------------*/
            FIND emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
            IF nota-fiscal.dt-emis-nota  >= 12/17/2010              AND 
               nota-fiscal.estado         = "MT"                    AND 
               emitente.cod-gr-cli       <> 04 /* Construtora   */  AND 
               emitente.cod-gr-cli       <> 02 /* Orgao Publico */  AND 
               emitente.cod-gr-cli       <> 16 /* Servicos      */  THEN DO TRANSACTION:
    
                   FIND ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                            AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                   IF (AVAIL ped-venda AND  ped-venda.cod-des-mer = 2    /* Consumo */)   THEN 
                      ASSIGN l-consumo = YES.
                   ELSE
                      ASSIGN l-consumo = NO.
    
    
    
                   /*
                   IF  emitente.contrib-icms      = YES          AND 
                       emitente.insc-subs-trib    = ""           AND
                       l-consumo                  = NO           AND 
                     ((emitente.categoria         <> "I"         AND /* N«O CONSIDERA = Industria da Construcao Civil */
                       emitente.categoria         <> "O"         AND /* N«O CONSIDERA = Construtora/SPE               */
                       emitente.categoria         <> "Z"         AND /* N«O CONSIDERA = Orgaos Publicos               */  
                       emitente.categoria         <> "L"         AND /* N«O CONSIDERA = Hoteis                        */  
                       emitente.categoria         <> "D")        OR  /* N«O CONSIDERA = Industria                     */  
                       emitente.cod-canal         = 105)             /* CONSIDERA = Instaladora Hidraulica        */
                       THEN DO:
                   */
    
                   /*--------------------------------------------------------------------- 26/01/2015 -----
                            Boa tarde Eduardo,
                            Devido a †rea fiscal j† existir tràs Solicitaá∆o de Mudanáa aberta, estou abrindo um chamado (D£vidas e Suporte) referente a alteraá∆o na Legislaá∆o do Estado do Mato Grosso que necessita alterar o sistema.
                            
                            Conforme contato telefìnico, referente a Lei 9.480/2010 do Estado do Mato Grosso (Benef°cio que a SEFAZ/MT concedeu para o cliente com a  Margem de 45% e ICMS (al°quota interna) de 7%, resultando em uma carga tribut†ria de 10,15% para os clientes enquadrados em alguns CNAE'S, onde a DOCOL antecipa este ICMS-ST para os clientes.
                            Conforme legislaá∆o citada acima, este percentual Ç calculado em todas as operaá‰es interestaduais.
                            
                            Agora, conforme Lei 10.173 de 21/10/14 e Decreto 2.652 de 12/12/14 (em vigor em Janeiro/2015), aplica-se exclusivamente as aquisiá‰es interestaduais de mercadorias destinadas a construá∆o civil; ou seja, somente aquisiá‰es de materiais de construá∆o para revenda.
                            
                            Ent∆o, conforme legislaá∆o, ser† necess†rio efetuar as devidas alteraá‰es:
                            1)	Excluir as operaá‰es com remessa em demonstraá∆o do programa que calcula o ICMS-ST para o Estado do Mato Grosso.
                            Ou seja, n∆o calcular o ICMS-ST referente as CFOP'S de remessa em demonstraá∆o (CFOP 6.912).
                            
                            2)	Alterar a mensagem: 
                            Hoje consta:  Cfe.Lei 9.480 de 17/12/10 e Decreto 07 de 14/01/11.
                            Alterar para:  Cfe.Lei 9.480 de 17/12/10 e Decreto 07 de 14/01/11 alterado pela Lei 10.173/14 e Decreto 2.652/14.
                            
                            Duvida, favor me ligar,
                            
                            Desde j† agradeáo e fico no aguardo,
                            
                            Francisca F. Castro Tenfen 
                    ----------------------------------------------------------------------------------------------------*/
                                       
                        
    
    
    
                   IF emitente.contrib-icms      = YES          AND 
                      emitente.insc-subs-trib    = ""           THEN DO:
    
                      FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK
                         WHERE (it-nota-fisc.cd-trib-icm = 1 OR it-nota-fisc.cd-trib-icm = 4)
                           AND NOT it-nota-fisc.nat-oper BEGINS "6912",
                          EACH ITEM NO-LOCK 
                         WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
    
                              /* Atualiza as variaveis: de-per-sub-trib e  de-aliq-icms-int */
                              {dop/dft039st.i "it-nota-fisc" nota-fiscal.estado it-nota-fisc.dt-emis-nota 1 nota-fiscal.cod-emitente}
    
                              IF de-per-sub-trib > 0 THEN DO:
                                  FIND FIRST st-nota-fiscal 
                                       WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                         AND st-nota-fiscal.serie           = nota-fiscal.serie      
                                         AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                                  IF NOT AVAIL st-nota-fiscal THEN DO:
                                      CREATE st-nota-fiscal.
                                      ASSIGN st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                                             st-nota-fiscal.serie           = nota-fiscal.serie      
                                             st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis
                                             st-nota-fiscal.situacao        = "NAO IMPRESSO"
                                             st-nota-fiscal.vl-bsubs-nota   = 0
                                             st-nota-fiscal.vl-icmsub-nota  = 0.
                                  END.
    
                                  CREATE st-it-nota-fis.
                                  ASSIGN st-it-nota-fis.cod-estabel   = it-nota-fisc.cod-estabel
                                         st-it-nota-fis.serie         = it-nota-fisc.serie      
                                         st-it-nota-fis.nr-nota-fis   = it-nota-fisc.nr-nota-fis
                                         st-it-nota-fis.nr-seq-fat    = it-nota-fisc.nr-seq-fat 
                                         st-it-nota-fis.it-codigo     = it-nota-fisc.it-codigo.
    
                                  IF it-nota-fisc.cd-trib-ipi = 1 OR  it-nota-fisc.cd-trib-ipi = 4 THEN
                                     ASSIGN de-vl-ipi = it-nota-fisc.vl-ipi-it.
                                  ELSE
                                     ASSIGN de-vl-ipi = 0.
    
                                  /*----------------------------------
                                  ASSIGN st-it-nota-fis.vl-bsubs-it   = /* ROUND(((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) + it-nota-fisc.vl-despes-it + de-vl-ipi) * (1 + (de-per-sub-trib / 100)),2) */
                                                                        ROUND((it-nota-fisc.vl-tot-item * (1 + (de-per-sub-trib / 100))),2) 
                                         st-it-nota-fis.vl-bsubs-it   = round(st-it-nota-fis.vl-bsubs-it - (st-it-nota-fis.vl-bsubs-it * de-perc-red-base-st / 100),2)
                                         st-it-nota-fis.vl-icmsub-it  = ROUND(((st-it-nota-fis.vl-bsubs-it * de-aliq-icms-int / 100) - it-nota-fisc.vl-icms-it),2).                                  
                                  -------------------------------------*/       
                                  ASSIGN st-it-nota-fis.vl-bsubs-it   = ROUND((it-nota-fisc.vl-tot-item * (1 + (de-per-sub-trib / 100))),2) 
                                         //st-it-nota-fis.vl-icmsub-it  = ROUND((st-it-nota-fis.vl-bsubs-it * de-aliq-icms-int / 100),2).
                                         st-it-nota-fis.vl-icmsub-it  = ROUND(((st-it-nota-fis.vl-bsubs-it * de-aliq-icms-int / 100) - it-nota-fisc.vl-icms-it),2). // NDS Controladoria - 16/12/19


    
                                  ASSIGN st-nota-fiscal.vl-bsubs-nota   = st-nota-fiscal.vl-bsubs-nota  + st-it-nota-fis.vl-bsubs-it 
                                         st-nota-fiscal.vl-icmsub-nota  = st-nota-fiscal.vl-icmsub-nota + st-it-nota-fis.vl-icmsub-it.
                              END. /* if de-per-sub-trib > 0 */
                      END. /* for each it-nota-fisc ... */
    
                      FIND FIRST st-nota-fiscal 
                           WHERE st-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
                             AND st-nota-fiscal.serie           = nota-fiscal.serie      
                             AND st-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-ERROR.
                      IF AVAIL st-nota-fiscal THEN DO:
                         FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
    
    
                         /*-------------------------------------------------------------------------------------------------------------------------------
                            R$ 3,60 (taxas de serviáos estaduais) 
                         /*-------------------------------------------------------------------------------------------------------------------------------
                            Bom dia,
                            Conforme conversamos semana passada, solicito que retire o acrÇscimo da taxa estadual de R$ 3,6 dos clientes do Mato Grosso 
                            61760- Marcos Augusto 
                            95889-Sim Mats Cons. 
                            Estes possuem isená∆o desta taxa. Pode parametrizar pelo c¢digo do cliente.
                            Nilson Rodrigues Gambeta
                            -----------------------------------------------------------------------------------------------------------------------------
                            Bom dia, 
                            O cliente 35715 Eletrica Serpal do estado MT tambÇm tem isená∆o da taxa estadual. Gentileza parametrizar este cliente para n∆o cobrar a taxa de R$ 3,60.
                            --*/                       
                         IF nota-fiscal.cod-emitente <> 61760 AND 
                            nota-fiscal.cod-emitente <> 95889 AND 
                            nota-fiscal.cod-emitente <> 35715 THEN DO:
                             ASSIGN st-nota-fiscal.vl-icmsub-nota  = st-nota-fiscal.vl-icmsub-nota + 3.60
                                    st-nota-fiscal.vl-despesas     = 3.60.
                         END.
                         ----------------------------------------------------------------------------------------------------------------------------*/
    
                         /* Retorna a Parcela/Data de Vencimento/Mensagem */
                         RUN dop/dft039mt.p (INPUT ROWID(st-nota-fiscal),
                                             OUTPUT c-observ-nota,
                                             OUTPUT i-parc,
                                             OUTPUT dt-venc).
                         ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota      + chr(10) + c-observ-nota.
                      END.
               END. /*  ... */
    
            END. /* if nota-fiscal.estado = MT */
            /** (FIM) SUBSTITUIÄ«O MT ****/
    
    
    
            /********************************************************************************************************* 
             * O programa doepc/upc-bodi317ef-obs.p - MONTA A OBSERVACAO DA NOTA FISCAL e atualiza no campo nota-fiscal.observ-nota 
             *********************************************************************************************************/
            IF nota-fiscal.dt-emis-nota >= 12/12/2008 THEN DO:
               RUN doepc/upc-bodi317ef-obs.p (INPUT ROWID(nota-fiscal)).
            END.
            /**** (fim) - atualizacao da observacao ****/
    
    
    
            /* CAMPANHA RESIDENCIALMATIC - envia e-mail para †rea de marketing - VALMIR 1/06/2010  */
/*             IF AVAIL nota-fiscal   AND                        */
/*                 nota-fiscal.tp-pedido = '29' THEN DO:         */
/*                 RUN dop/dpd399g.p (INPUT ROWID(nota-fiscal)). */
/*             END.                                              */
    
    
            if avail nota-fiscal then do:
                run dop/dat047a.p (input rowid(nota-fiscal)).
            end.
    
    
            /*----- EXPORTACAO -----*/
            IF nota-fiscal.nr-proc-exp <> "" THEN DO:
                FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                               AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
                FIND ex-ped-venda WHERE ex-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                FOR EACH ex-tipo-desc-cli 
                   WHERE ex-tipo-desc-cli.cod-emitente  = nota-fiscal.cod-emit,
                    EACH ex-desc-proforma 
                   WHERE ex-desc-proforma.sequen-dig    = ex-tipo-desc-cli.sequen-dig
                     AND ex-desc-proforma.nr-pedcli     = nota-fiscal.nr-pedcli:                     
                    FIND LAST b-ex-desc-fatura NO-LOCK WHERE
                              b-ex-desc-fatura.sequen-fatura >= 0 NO-ERROR.  
                    CREATE ex-desc-fatura.
                    ASSIGN ex-desc-fatura.data              = TODAY
                           ex-desc-fatura.hora              = STRING(TIME,"hh:mm:ss")
                           ex-desc-fatura.nr-proc-exp       = nota-fiscal.nr-proc-exp
                           ex-desc-fatura.nr-nota-fis       = nota-fiscal.nr-nota-fis
                           ex-desc-fatura.sequen-fatura     = (IF AVAIL b-ex-desc-fatura THEN (b-ex-desc-fatura.sequen-fatura + 1) ELSE 1)
                           ex-desc-fatura.sequen-proforma   = ex-desc-proforma.sequen-proforma
    
                           de-valor-original-1              = (nota-fiscal.vl-mercad / nota-fiscal.vl-taxa-exp)
                           de-valor-original-2              = de-valor-original-1 / (1 - (nota-fiscal.perc-desco2 / 100))
                           de-vl-desconto                   = de-valor-original-2 - de-valor-original-1.
    
                    FIND ex-ped-venda NO-LOCK WHERE ex-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                    IF AVAIL ex-ped-vend AND ex-ped-venda.l-descontar-frete AND nota-fiscal.vl-frete > 0 THEN
                       ASSIGN de-vl-desconto = de-vl-desconto - (nota-fiscal.vl-frete / nota-fiscal.vl-taxa-exp).
                    IF AVAIL ex-ped-vend AND ex-ped-venda.l-descontar-seguro AND nota-fiscal.vl-seguro > 0 THEN
                       ASSIGN de-vl-desconto = de-vl-desconto - (nota-fiscal.vl-seguro / nota-fiscal.vl-taxa-exp).
                    IF AVAIL ex-ped-vend AND ex-ped-venda.l-descontar-despesas AND nota-fiscal.vl-embalagem > 0 THEN
                       ASSIGN de-vl-desconto = de-vl-desconto - (nota-fiscal.vl-embalagem / nota-fiscal.vl-taxa-exp).                     
    
    
                    ASSIGN de-vl-desconto = de-vl-desconto * (ex-desc-proforma.valor / ex-ped-venda.vl-desconto).
    
                    IF de-vl-desconto > 0 THEN
                       ASSIGN ex-desc-fatura.valor = de-vl-desconto.
                    ELSE
                       ASSIGN ex-desc-fatura.valor = ((nota-fiscal.vl-tot-nota - nota-fiscal.vl-frete - nota-fiscal.vl-seguro - nota-fiscal.vl-embalagem) / nota-fiscal.vl-taxa-exp) / ped-venda.vl-tot-ped.
    
                     ASSIGN ex-desc-proforma.vl-saldo-fatura = ex-desc-proforma.vl-saldo-fatura - ex-desc-fatura.valor 
                            ex-tipo-desc-cli.vl-saldo-fatura = ex-tipo-desc-cli.vl-saldo-fatura - ex-desc-fatura.valor.
    
                     IF ex-desc-proforma.vl-saldo-fatura < 0 THEN ASSIGN ex-desc-proforma.vl-saldo-fatura = 0.
                     IF ex-tipo-desc-cli.vl-saldo-fatura < 0 THEN ASSIGN ex-tipo-desc-cli.vl-saldo-fatura = 0.
    
                END. /* ex-tipo-desc-cli ... */
            END.
            /*----- (fim) EXPORTACAO -----*/
    
    
            /***************Log de tempo de efetivaá∆o da nota fiscal**********************/
            DO TRANSACTION:
            
                FIND FIRST dc-log-nota-fiscal
                    WHERE dc-log-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                      AND dc-log-nota-fiscal.serie       = nota-fiscal.serie
                      AND dc-log-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL dc-log-nota-fiscal THEN DO:
                    ASSIGN dc-log-nota-fiscal.data-fim      = TODAY
                           dc-log-nota-fiscal.hora-fim      = TIME
                           dc-log-nota-fiscal.data-hora-fim = DATETIME(TODAY, MTIME)
                           dc-log-nota-fiscal.tempo         = interval(dc-log-nota-fiscal.data-hora-fim,dc-log-nota-fiscal.data-hora-ini,'milliseconds').
    
                 END.
            END.
            /*******************************************************************************/               
    
            /******* CONTROLE DO NOSSO NUMERO - BOLETO HSBC ***********************/
            {doepc/upc-bodi317-bol.i}
    
            IF log-boleto-duplicata OR log-boleto-st  THEN DO:
               RUN doepc/upc-bodi317-bol.p (INPUT ROWID(nota-fiscal)).
            END.
               
                
    
    
    
    
            /******* FIM - CONTROLE DO NOSSO NUMERO - BOLETO HSBC ***********************/
    
    
            /*------ VENDA ENTREGA FUTURA --------*/
            
            IF  nota-fiscal.nat-oper BEGINS "6922" OR
                nota-fiscal.nat-oper BEGINS "5922" THEN DO:
    
                FIND ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                         AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
                IF  AVAIL ped-venda THEN DO:
                    ASSIGN c-data-entrega = ""
                           c-desc-susp    = "".
                    FIND sdv-ped-venda NO-LOCK WHERE sdv-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                    IF AVAIL sdv-ped-venda AND sdv-ped-venda.data-1 <> ? THEN
                         ASSIGN c-data-entrega = STRING(sdv-ped-venda.data-1,"99/99/9999").
                    
                    assign c-desc-susp = "Nota Fiscal Fatura emitida! Trocar a CFOP e Data de Entrega: " + c-data-entrega + 
                                         " (Nro Nota Fatura: " + nota-fiscal.nr-nota-fis + " CFOP: " + nota-fiscal.nat-oper + ")".
                    
                    RUN dop/dpd557.p (INPUT ped-venda.nome-abrev, 
                                      INPUT ped-venda.nr-pedcli,
                                      INPUT c-desc-susp,
                                      OUTPUT TABLE tt-erro). /* programa que suspende o pedido */
                    
                    If ped-venda.cod-sit-ped = 5 /* */ THEN DO:
                       
                        IF AVAIL sdv-ped-venda THEN DO TRANSACTION:
                            FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                            ASSIGN ped-venda.nome-transp = sdv-ped-venda.nome-transp.
                            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
                        END.
    
    
    
    
                       RUN dop/email.p (INPUT "automatico@docol.com.br",                                /* Remetente */
                                         INPUT "suporte1@docol.com.br",                                 /* Para      */
                                         INPUT "VENDA ENTREGA FUTURA - Pedido: " + ped-venda.nr-pedcli + " Cliente: " + ped-venda.nome-abrev,  /* Assunto   */
                                         INPUT c-desc-susp,                                             /* Mensagem  */
                                         INPUT "",                                                      /* Anexo     */
                                         OUTPUT TABLE tt-erros).
                    END.
                    ElSE DO: /* Email caso o pedido n∆o seja suspenso */
                        RUN dop/email.p (INPUT "automatico@docol.com.br",                                /* Remetente */
                                         INPUT "suporte1@docol.com.br",                                  /* Para      */
                                         INPUT "ERRO VENDA ENTREGA FUTURA - Pedido: " + ped-venda.nr-pedcli + " Cliente: " + ped-venda.nome-abrev,  /* Assunto   */
                                         INPUT c-desc-susp,                                             /* Mensagem  */
                                         INPUT "",                                                      /* Anexo     */
                                         OUTPUT TABLE tt-erros).
                    END.
                END.
            END.
            /*------ FIM - VENDA ENTREGA FUTURA --------*/
    

            /* INICIO - NDS 22743 - Otimizaá∆o Apartamento Modelo - TIPO PEDIDO 49 */
            IF AVAIL nota-fiscal AND nota-fiscal.tp-pedido = '49' THEN DO:
    
                FOR FIRST ped-venda NO-LOCK 
                    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                      AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli,
                    FIRST emitente  NO-LOCK 
                    WHERE emitente.cod-emitente = ped-venda.cod-emitente,
                    FIRST dc-ped-venda OF ped-venda NO-LOCK:   
                    FOR FIRST ap-modelo-ficha WHERE 
                        ap-modelo-ficha.cod-emit   = ped-venda.cod-emit AND 
                        ap-modelo-ficha.ficha-obra = INT(dc-ped-venda.ficha-obra) AND 
                        ap-modelo-ficha.cod-rep    = emitente.cod-rep EXCLUSIVE-LOCK:
        
                         ASSIGN ap-modelo-ficha.log-libera  = YES
        	                    ap-modelo-ficha.dt-libera   = TODAY
                                ap-modelo-ficha.user-libera = "Autom†tico".
                    END.
                END.
            END.
            /* FIM - NDS 22743 - Otimizaá∆o Apartamento Modelo - TIPO PEDIDO 49 */


            RUN doepc/upc-bodi317ef-confere.p (INPUT ROWID(nota-fiscal)).


            /* Inserido trecho para realizacao de empenho */


            IF AVAIL nota-fiscal THEN DO:
                IF NOT VALID-HANDLE(h-cd9500) THEN
                    RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

                FIND FIRST param-global NO-ERROR.
                EMPTY TEMP-TABLE tt_xml_input_1.

                FIND FIRST conta-ft NO-LOCK
                     WHERE conta-ft.cod-estabel = ped-venda.cod-estabel
                       AND conta-ft.nat-oper    = ped-venda.nat-oper
                       AND conta-ft.cod-canal   = i-cod-canal NO-ERROR.
                IF NOT AVAIL conta-ft THEN DO: //TRANSACTION
                    ASSIGN i-cod-canal = 0. /* Se nao zerar o canal de venda busca a conta errada no faturamento */
                END.

                FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

                FIND FIRST usuar_grp_usuar NO-LOCK WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-ERROR.

                FIND FIRST estabelecimento NO-LOCK WHERE estabelecimento.cod_estab = ped-venda.cod-estabel NO-ERROR.
                FOR EACH  unid-negoc-grp-usuar NO-LOCK
                    WHERE unid-negoc-grp-usuar.cod_grp_usu =  usuar_grp_usuar.cod_grp_usu,
                    EACH  unid-negoc-estab NO-LOCK
                    WHERE unid-negoc-estab.cod-unid-negoc  = unid-negoc-grp-usuar.cod-unid-negoc
                      AND unid-negoc-estab.cod-estabel     = estabelecimento.cod_estab
                      AND unid-negoc-estab.dat-inic-valid <= TODAY
                      AND unid-negoc-estab.dat-fim-valid  >= TODAY:

                    ASSIGN v_cod_unid_negoc = unid-negoc-estab.cod-unid-negoc.
                END.



                /* Busca dados de Conta e Centro de Custo */
                RUN pi-cd9500 IN h-cd9500(INPUT  ped-venda.cod-estabel,
                                          INPUT  emitente.cod-gr-cli,
                                          INPUT  ?,
                                          INPUT  ped-venda.nat-operacao,
                                          INPUT  ?,
                                          INPUT  "",
                                          INPUT  i-cod-canal,
                                          OUTPUT r-conta-ft).

                FOR FIRST conta-ft 
                    WHERE ROWID(conta-ft) = r-conta-ft no-lock:


                    IF conta-ft.ct-cusven = "435362" THEN DO:



                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Funá∆o"
                               tt_xml_input_1.tt_des_conteudo    = "Realiza"
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Empresa"
                               tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Conta Cont†bil"
                               tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.ct-cusven)
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
                               tt_xml_input_1.tt_des_conteudo    = ped-venda.cod-estabel
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
                               tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.dt-entrega)
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
                               tt_xml_input_1.tt_des_conteudo   = "0"
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
                               tt_xml_input_1.tt_des_conteudo   = STRING(ped-venda.vl-liq-ped)
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
                               tt_xml_input_1.tt_des_conteudo   = "1"
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
                               tt_xml_input_1.tt_des_conteudo   = "92"
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
                               tt_xml_input_1.tt_des_conteudo   = "Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
                               tt_xml_input_1.tt_des_conteudo   = v_cod_unid_negoc
                               tt_xml_input_1.tt_num_seq_1_xml  = 1
                               tt_xml_input_1.tt_num_seq_2_xml  = 0.
        
                        create tt_xml_input_1.
                        assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
                               tt_xml_input_1.tt_des_conteudo    = STRING(conta-ft.sc-cusven)
                               tt_xml_input_1.tt_num_seq_1_xml   = 1
                               tt_xml_input_1.tt_num_seq_2_xml   = 0.
        
                        RUN prgfin/bgc/bgc700za.py (input 1,
                                                    input table tt_xml_input_1,
                                                    output table tt_log_erros) .  
                    END.
                END.
                    IF VALID-HANDLE(h-cd9500) THEN
                     DELETE WIDGET h-cd9500.

            END.

        END. /* IF  AVAIL tt-epc THEN DO: */
    END. /* END-EFETIVA-NOTA */

    IF  p-ind-event = "trataEnvioNFE":U THEN DO: 
    
        FIND FIRST tt-epc WHERE
                   tt-epc.cod-event     = p-ind-event            AND
                   tt-epc.cod-parameter = "Rowid NFE":U NO-LOCK NO-ERROR.
        IF  AVAIL tt-epc THEN DO:

            FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) EXCLUSIVE-LOCK NO-ERROR.

            /* (INICIO) AJUSTE DA DATA DE SA÷DA - ESTE CAMPO SERµ ATUALIZADO SOMENTE QUANDO GERAR O MANIFESTO - CHAMADO 75607 */
            IF AVAIL nota-fiscal THEN DO:

                FOR FIRST nota-fisc-adc EXCLUSIVE-LOCK
                    WHERE nota-fisc-adc.cod-estab        = nota-fiscal.cod-estabel    
                      AND nota-fisc-adc.cod-serie        = nota-fiscal.serie          
                      AND nota-fisc-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis    
                      AND nota-fisc-adc.cdn-emitente     = nota-fiscal.cod-emitente   
                      AND nota-fisc-adc.cod-natur-operac = nota-fiscal.nat-operacao   
                      AND nota-fisc-adc.idi-tip-dado     = 20:

                    ASSIGN nota-fisc-adc.dat-livre-1 = ?
                           nota-fisc-adc.hra-saida   = "".
                END.

                ASSIGN nota-fiscal.dt-saida = ?.
            END.
            /* (FIM) AJUSTE DA DATA DE SA÷DA - ESTE CAMPO SERµ ATUALIZADO SOMENTE QUANDO GERAR O MANIFESTO - CHAMADO 75607 */
        END.
    END.
    

    /* INTEGRAÄ«O MADEIRA MADEIRA */
    IF SEARCH('zzupc/upc-bodi317ef.r') <> ? THEN DO:
        RUN zzupc/upc-bodi317ef.p (INPUT p-ind-event,
                                   INPUT-OUTPUT TABLE tt-epc).
    END.

/* upc-bodi317ef.p */



