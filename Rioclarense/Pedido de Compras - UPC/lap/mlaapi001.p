/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i MLAAPI001 2.00.00.036 } /*** 010036 ***/

    

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i mlaapi001 MML}
&ENDIF

/*******************************************************************************
**
**   Programa..:  MLAAPI001.P
**   Data......:  Fevereiro de 2001.
**   Objetivo .:  Geraá∆o de pendàncias de aprovaá∆o
**   Criaá∆o ..:  Jackson
**
*******************************************************************************/

    
    
    {lap/mlaapi001.i99}
    {cdp/cd0666.i}
    {utp/utapi019.i}
    {utp/ut-glob.i}
    
    /**  Definiá∆o de elementos referentes a UPC **/
    {include/i-epc200.i "MLAAPI001"}

    /**  Parametros
    **/
    def input  parameter p-cod-tip-doc as integer no-undo.
    def input  parameter p-tipo-trans  as integer no-undo.
    def input  parameter p-motivo      as char    no-undo.
    def input  parameter p-valor       as decimal no-undo.
    def input  parameter p-moeda       as integer no-undo.
    def input  parameter p-usuar-trans as char    no-undo.
    def input  parameter p-usuar-doc   as char    no-undo.
    def input  parameter p-lotacao-doc as char    no-undo.
    def input  parameter p-item        as char    no-undo.
    def input  parameter p-referencia  as char    no-undo.
    def input  parameter p-ep-codigo   LIKE empresa.ep-codigo    no-undo.
    def input  parameter p-cod-estabel LIKE estabelec.cod-estabel    no-undo.
    def input  parameter table for tt-mla-chave.
    def output parameter table for tt-erro.

    DEFINE VARIABLE l-sempre-gera        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-gera-condpg-valor  AS LOGICAL     NO-UNDO.

    def buffer b-mla-usuar-aprov    for mla-usuar-aprov.
    def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.
    def new global shared var gi-prox-prior as integer no-undo.

    DEF NEW GLOBAL SHARED VAR gl-not-pendencia-aed  AS LOGICAL NO-UNDO.
    
    /* Ponto para mudar o valor gl-not-pendencia-aed */
    if c-nom-prog-upc-mg97  <> "" or 
        c-nom-prog-appc-mg97 <> "" or 
        c-nom-prog-dpc-mg97  <> "" then do:

        FOR each tt-epc:
            delete tt-epc.
        end.
    
        create tt-epc.
        assign tt-epc.cod-event     = "MLAAPI001-gl-not-pendencia-aed":U
               tt-epc.cod-parameter = "tipo-documento":U
               tt-epc.val-parameter = STRING(p-cod-tip-doc).

        create tt-epc.
        assign tt-epc.cod-event     = "MLAAPI001-gl-not-pendencia-aed":U
               tt-epc.cod-parameter = "p-tipo-trans":U
               tt-epc.val-parameter = STRING(p-tipo-trans).
        
        {include/i-epc201.i "MLAAPI001-gl-not-pendencia-aed"}
    END.

    IF gl-not-pendencia-aed THEN
        RETURN.

    def var i-chave         as integer no-undo.
    def var c-chave         as char    no-undo.
    def var l-mestre        as logical no-undo.
    def var de-limite       as decimal no-undo.
    def var de-aux          as decimal no-undo.
    def var i-cod-aprov     as integer no-undo.
    def var i-tip-aprov     as integer no-undo.
    def var c-lotacao       as char    no-undo.
    def var c-lotacao-trans as char    no-undo.
    def var c-apr-lista     as char    no-undo.
    def var i-seq-lista     as integer no-undo.
    def var i-tip-lista     as integer no-undo.
    def var c-ass-e-mail    as char    no-undo.
    def var c-men-e-mail    as char    no-undo.
    def var i-prioridade    as integer no-undo.
    def var c-aprovador     as char    no-undo.
    DEF VAR c-nom-aprov     as char    no-undo.
    def var c-arquivo-anexo as char    no-undo.
    DEF VAR i-cod-cond-pag  LIKE cond-pagto.cod-cond-pag NO-UNDO.
    def var i-mo-codigo     like mla-usuar-aprov.mo-codigo initial 0 no-undo.
	def var de-valor-convert as decimal no-undo.
	def var de-val-doc-convert like mla-doc-pend-aprov.valor-doc no-undo.
    def var c-anexo         as char    no-undo.
    DEF VAR c-desc-aprov-auto  AS CHAR NO-UNDO.
    DEF VAR l-envia-email-auto AS LOG  NO-UNDO.

    def var c-alternativo   as char    no-undo.
    def var l-aprovado      as logical no-undo.
    def var l-aprovado-auto as logical no-undo.

    def var l-achou-lista   as logical no-undo.
    def var i-ordem-lista   as integer no-undo.
    def var i-tenta-lista   as integer no-undo.

    DEF VAR l-proces-compl  AS LOG     NO-UNDO.
    DEF VAR l-prossegue-gerac-elimin AS LOG NO-UNDO.
    
    def var l-lim-lista   as logical no-undo.
    
    def temp-table tt-lista NO-UNDO
        field seq-aprov       like mla-lista-aprov-doc.seq-aprov
        field cod-usuar-aprov like mla-lista-aprov-doc.cod-usuar
        field limite-aprov    like mla-perm-aprov.limite-aprov
        field rowlista        as rowid
        index chave as primary seq-aprov
        index limite limite-aprov.

    DEF VAR de-limite-auto AS DECIMAL NO-UNDO.
    DEF BUFFER bf-mla-perm-aprov    FOR mla-perm-aprov.
    DEF BUFFER bf-mla-lim-aprov-fam FOR mla-lim-aprov-fam.
    DEF BUFFER bb-mla-usuar-aprov   FOR mla-usuar-aprov.
    DEFINE VARIABLE c-msgs-26593 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-help-26593 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-msgs-26652 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-help-26652 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-mensagens-geradas AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-exchange   AS LOGICAL    NO-UNDO.
    DEF VAR c-arq-email          AS CHAR NO-UNDO.

    DEFINE VARIABLE i-programa  AS INTEGER INITIAL 5  NO-UNDO.
    DEFINE VARIABLE l-elimina   AS LOGICAL INITIAL NO NO-UNDO.
    def var l-aprov-auto-doc    as logical no-undo.
    def var l-desvia            as logical no-undo.
    def var c-chave-doc         as char    no-undo.
    def var l-tem-aprovador     as logical no-undo.

    DEFINE VARIABLE l-avail-ref         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-doc         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-item        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-fam         AS LOGICAL    NO-UNDO.
    
    /* Vari†vel l-mlaapi100-ativo = yes quando a chamada Ç a partir da aedapi100 */
    DEFINE NEW GLOBAL SHARED VAR l-aedapi100-ativo AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-anexar-conteudo   AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.
    DEF VAR p-chave-doc LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.

    if c-nom-prog-upc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-dpc-mg97  <> "" then do:

        FOR each tt-epc:
           delete tt-epc.
       end.
    
       create tt-epc.
       assign tt-epc.cod-event     = "beforemlaapi001":U
              tt-epc.cod-parameter = "tipo-documento":U
              tt-epc.val-parameter = STRING(p-cod-tip-doc).
    
       create tt-epc.
       assign tt-epc.cod-event     = "beforemlaapi001":U
              tt-epc.cod-parameter = "chave":U
              tt-epc.val-parameter = c-chave.
       
        {include/i-epc201.i "beforemlaapi001"}
    
       find first tt-epc no-lock  
            where tt-epc.cod-event = "beforemlaapi001" no-error.
       
       if avail  tt-epc and  
          string(tt-epc.cod-parameter,"x(20)") = "new-valor":U then
          assign p-valor = DECIMAL(tt-epc.val-parameter).
    
       for each tt-epc:
          delete tt-epc.
       end.    
    end.

    IF gl-not-pendencia-aed THEN
        RETURN.

    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
    put skip(2).
    put unformatted "====================================================================================================" skip.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Log_AED" *}
    PUT UNFORMATTED ".:: " + RETURN-VALUE + " - " + string(today) + " - " + string(time,"hh:mm:ss") + " ::." SKIP.
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-mlaapi001-geracao-de-pendenc AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "MLAAPI001_-_Geracao_de_pendencias_de_aprovacao" *}
    ASSIGN c-lbl-liter-mlaapi001-geracao-de-pendenc = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-versao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Versao" *}
    ASSIGN c-lbl-liter-versao = TRIM(RETURN-VALUE).
    PUT UNFORMATTED "    " + c-lbl-liter-mlaapi001-geracao-de-pendenc skip
                    "    " + c-lbl-liter-versao + ":   " + STRING(c-prg-vrs) SKIP(1).
    output close.

    find mla-tipo-doc-aprov where
        mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo   AND
        mla-tipo-doc-aprov.cod-estabel = p-cod-estabel and
        mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc
        no-lock no-error.
    
    if available mla-tipo-doc-aprov and
        not mla-tipo-doc-aprov.apr-tip-doc then
        return.

    /**  Parametros
    **/
    find mla-param-aprov where mla-param-aprov.ep-codigo   = p-ep-codigo 
                           and mla-param-aprov.cod-estabel = p-cod-estabel no-lock no-error.
    if  avail mla-param-aprov then
        assign l-exchange         = if l-aedapi100-ativo then no else mla-param-aprov.log-exchange.
    
    IF PROGRAM-NAME(i-programa) MATCHES "*cn0309*":U OR
       PROGRAM-NAME(i-programa) MATCHES "*cc0309*":U THEN 
       ASSIGN l-elimina = YES.
    
    /**   Monta chave do documento
    **/
    {lap/mlachave.i}


        if c-nom-prog-upc-mg97  <> "" or 
           c-nom-prog-appc-mg97 <> "" or 
           c-nom-prog-dpc-mg97  <> "" then do:
                                                               
            FOR each tt-epc:
               delete tt-epc.
           end.
                           
           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001-2":U
                  tt-epc.cod-parameter = "chave":U
                  tt-epc.val-parameter = c-chave.
           
            {include/i-epc201.i "beforemlaapi001-2"}           
        end.
    
        IF gl-not-pendencia-aed THEN
            RETURN.            
        

    /**  Gera hist¢ricos
    **/
    if  p-tipo-trans = 2 or 
        p-tipo-trans = 3 then do:
        
        ASSIGN l-prossegue-gerac-elimin = NO
               l-sempre-gera            = NO 
               l-gera-condpg-valor      = NO.

        for each mla-doc-pend-aprov where
            mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   and
            mla-doc-pend-aprov.cod-estabel  = p-cod-estabel and        
            mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc and
            mla-doc-pend-aprov.chave-doc    = c-chave       and
            mla-doc-pend-aprov.historico    = NO EXCLUSIVE-LOCK:

            /**  Refaz saldo da verba - REFAZER SOMENTE QUANDO A SITUAÄ«O FOR 1, CASO CONTRµRIO ESTARµ REFAZENDO SALDO QUE N«O FOI CONSUMIDO
            **/
            IF  mla-doc-pend-aprov.ind-situacao = 2 THEN DO:
            
                find first mla-verba-aprov where
                    mla-verba-aprov.ep-codigo   = p-ep-codigo and
                    mla-verba-aprov.cod-estabel = p-cod-estabel and
                    mla-verba-aprov.cod-usuar   = (if mla-doc-pend-aprov.cod-usuar-altern <> "" then mla-doc-pend-aprov.cod-usuar-altern 
                                                   else mla-doc-pend-aprov.cod-usuar) and
                    mla-verba-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc     and
                    mla-verba-aprov.periodo-ini <= mla-doc-pend-aprov.dt-geracao      and
                    mla-verba-aprov.periodo-fim >= mla-doc-pend-aprov.dt-geracao      and
                    mla-verba-aprov.verba-utilizada <> 0
                    exclusive-lock no-error.

                if available mla-verba-aprov then do:
					
					assign de-val-doc-convert = mla-doc-pend-aprov.valor-doc.
					/*chamado TPOLOI - Rodrigo*/ 
					/*find first mla-usuar-aprov
						  where mla-usuar-aprov.cod-usuar = mla-verba-aprov.cod-usuar no-lock no-error.
					  if  avail mla-usuar-aprov AND
                          mla-usuar-aprov.mo-codigo <> p-moeda then DO:
					
						RUN cdp/cd0812.p (INPUT  p-moeda,  	                    /* Moeda Origem - Documento*/
										  INPUT  mla-usuar-aprov.mo-codigo,  	/* Moeda Destino - Aprovador*/
										  INPUT  mla-doc-pend-aprov.valor-doc,	/* Valor Origem a converter */
										  INPUT  TODAY,              			/* Datas da Convers„o*/
										  OUTPUT de-val-doc-convert).     		/* Valor retorno convertido */
										  
						if de-val-doc-convert = ? then
							assign de-val-doc-convert = 0.
					end.*/
					
                    assign mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada + de-val-doc-convert.
                    release mla-verba-aprov.
                end.
            END.
            IF  AVAIL mla-param-aprov
            AND mla-param-aprov.log-cond-pagto THEN DO: /*Exceá∆o geraá∆o de pendencia: CondPagto x Valor*/
                
                FIND FIRST mla-tipo-doc-aprov NO-LOCK
                     WHERE mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo 
                       AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel 
                       AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-ERROR.
                IF AVAIL mla-tipo-doc-aprov THEN DO:
                    IF mla-tipo-doc-aprov.log-excec-val THEN DO: /*sempre gera pendencia*/
                        IF mla-doc-pend-aprov.ind-situacao > 1 THEN
                            assign mla-doc-pend-aprov.historico   = yes
                                   mla-doc-pend-aprov.motivo-hist = p-motivo.

                        ASSIGN l-prossegue-gerac-elimin = YES
                               l-sempre-gera            = YES.

                        RUN pi-elimina-documentos-pendentes.
                    END.
                    ELSE DO: 
                        RUN pi-busca-cond-pagto (OUTPUT i-cod-cond-pag).
                        IF mla-doc-pend-aprov.valor-doc    <> p-valor 
                        OR ( TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) <>  ""
                             AND TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) <> string(i-cod-cond-pag)) THEN DO:

                            ASSIGN l-prossegue-gerac-elimin = YES
                                   l-gera-condpg-valor      = YES.
                            IF mla-doc-pend-aprov.ind-situacao > 1 THEN
                                assign mla-doc-pend-aprov.historico   = yes
                                       mla-doc-pend-aprov.motivo-hist = p-motivo.
                            /**  Elimina documentos pendentes para geracao de nova pendencia **/
                            RUN pi-elimina-documentos-pendentes.
                        END.
                        ELSE DO:
                            ASSIGN l-prossegue-gerac-elimin = NO.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                /**  Elimina documentos pendentes para geracao de nova pendencia **/
                ASSIGN l-prossegue-gerac-elimin = YES.
                RUN pi-elimina-documentos-pendentes.
            END.

            IF p-tipo-trans = 3 THEN DO:
                /**  Elimina todas as pendàncias do documento quando o documento original for eliminado **/
                ASSIGN l-prossegue-gerac-elimin = YES.
                RUN pi-elimina-documentos-pendentes.
            END.
        end.
        
        IF  NOT l-sempre-gera 
        AND NOT l-gera-condpg-valor
        AND NOT CAN-FIND(FIRST mla-doc-pend-aprov 
                        WHERE mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   
                          AND mla-doc-pend-aprov.cod-estabel  = p-cod-estabel 
                          AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
                          AND mla-doc-pend-aprov.chave-doc    = c-chave        
                          AND mla-doc-pend-aprov.historico    = NO)  THEN DO:
            ASSIGN l-prossegue-gerac-elimin = YES.
        END.

        IF  NOT l-prossegue-gerac-elimin THEN
            RETURN.
        
        /**  Elimina todas as pendàncias do documento quando o documento original for eliminado
        **/
        
        if  p-tipo-trans = 3 then
            for each  mla-doc-pend-aprov 
                where mla-doc-pend-aprov.ep-codigo   = p-ep-codigo   
                  and mla-doc-pend-aprov.cod-estabel = p-cod-estabel 
                  and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
                  and mla-doc-pend-aprov.chave-doc   = c-chave exclusive-lock:
                  
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-elimina-todas-as-pendencias-d AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Elimina_todas_as_pendencias_do_documento_quando_o_documento_original_for_eliminado" *}
                ASSIGN c-lbl-liter-elimina-todas-as-pendencias-d = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-modificacao-2-eliminacao-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Modificacao_(2)_/_Eliminacao_(3)" *}
                ASSIGN c-lbl-liter-modificacao-2-eliminacao-4 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-empresa-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Empresa" *}
                ASSIGN c-lbl-liter-empresa-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Estabelecimento" *}
                ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-documento-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Documento" *}
                ASSIGN c-lbl-liter-documento-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-chave-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Chave" *}
                ASSIGN c-lbl-liter-chave-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-historico-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "#_Historico" *}
                ASSIGN c-lbl-liter-historico-2 = TRIM(RETURN-VALUE).
                put unformatted skip
                                c-lbl-liter-elimina-todas-as-pendencias-d + ". " skip
                                c-lbl-liter-modificacao-2-eliminacao-4 + "             = " p-tipo-trans                   skip
                                c-lbl-liter-empresa-2 + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                                c-lbl-liter-estabelecimento-2 + "                              = " mla-doc-pend-aprov.cod-estabel skip
                                c-lbl-liter-documento-2 + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                                c-lbl-liter-chave-2 + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                                c-lbl-liter-historico-2 + "                                    = " mla-doc-pend-aprov.historico   skip.     
                FOR EACH tt-erro:
                    PUT UNFORMATTED tt-erro.mensagem.
                END.
                output close.
                IF mla-doc-pend-aprov.cod-tip-doc = 1 AND mla-doc-pend-aprov.historico THEN
                    IF CAN-FIND(FIRST it-requisicao 
                                 where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                  AND it-requisicao.numero-ordem <> 0) THEN
                        NEXT.
                delete mla-doc-pend-aprov.
            end.
        /** Elimina as pendàncias com o estabelecimento diferente do documento  **/

        for each  mla-doc-pend-aprov 
            where mla-doc-pend-aprov.ep-codigo   = p-ep-codigo   
              and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
              and mla-doc-pend-aprov.chave-doc   = c-chave 
              and mla-doc-pend-aprov.cod-estabel <> p-cod-estabel exclusive-lock:

            RUN pi-chama-epc-eliminacao.
        
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-elimina-pendencias-com-o-esta AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Elimina_pendencias_com_o_estabelecimento_diferente_do_documento" *}
            ASSIGN c-lbl-liter-elimina-pendencias-com-o-esta = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-modificacao-2-eliminacao-5 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Modificacao_(2)_/_Eliminacao_(3)" *}
            ASSIGN c-lbl-liter-modificacao-2-eliminacao-5 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-empresa-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Empresa" *}
            ASSIGN c-lbl-liter-empresa-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-estabelecimento-novo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Estabelecimento_(Novo)" *}
            ASSIGN c-lbl-liter-estabelecimento-novo = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-estabelecimento-antigo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Estabelecimento_(Antigo)" *}
            ASSIGN c-lbl-liter-estabelecimento-antigo = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-documento-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Documento" *}
            ASSIGN c-lbl-liter-documento-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-chave-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Chave" *}
            ASSIGN c-lbl-liter-chave-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-historico-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Historico" *}
            ASSIGN c-lbl-liter-historico-3 = TRIM(RETURN-VALUE).
            put unformatted skip
                            c-lbl-liter-elimina-pendencias-com-o-esta + "." skip
                            c-lbl-liter-modificacao-2-eliminacao-5 + "             = " p-tipo-trans                   skip
                            c-lbl-liter-empresa-3 + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                            c-lbl-liter-estabelecimento-novo + "                       = " mla-doc-pend-aprov.cod-estabel skip
                            c-lbl-liter-estabelecimento-antigo + "                     = " p-cod-estabel                  skip
                            c-lbl-liter-documento-3 + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                            c-lbl-liter-chave-3 + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                            c-lbl-liter-historico-3 + "                                    = " mla-doc-pend-aprov.historico   skip.     
            FOR EACH tt-erro:
                PUT UNFORMATTED tt-erro.mensagem.
            END.
            output close.

            delete mla-doc-pend-aprov.
        end.
        
        /** Elimina as pendàncias com a empresa diferente do documento  **/
        for each  mla-doc-pend-aprov 
            where mla-doc-pend-aprov.ep-codigo   <> p-ep-codigo   
              and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
              and mla-doc-pend-aprov.chave-doc   = c-chave 
              and mla-doc-pend-aprov.cod-estabel <> p-cod-estabel exclusive-lock:

            RUN pi-chama-epc-eliminacao.
        
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-elimina-pendencias-com-o-esta-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Elimina_pendencias_com_o_estabelecimento_diferente_do_documento" *}
            ASSIGN c-lbl-liter-elimina-pendencias-com-o-esta-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-modificacao-2-eliminacao-6 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Modificacao_(2)_/_Eliminacao_(3)" *}
            ASSIGN c-lbl-liter-modificacao-2-eliminacao-6 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-empresa-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Empresa" *}
            ASSIGN c-lbl-liter-empresa-4 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-estabelecimento-novo-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Estabelecimento_(Novo)" *}
            ASSIGN c-lbl-liter-estabelecimento-novo-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-estabelecimento-antigo-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Estabelecimento_(Antigo)" *}
            ASSIGN c-lbl-liter-estabelecimento-antigo-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-documento-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Documento" *}
            ASSIGN c-lbl-liter-documento-4 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-chave-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Chave" *}
            ASSIGN c-lbl-liter-chave-4 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-historico-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "#_Historico" *}
            ASSIGN c-lbl-liter-historico-4 = TRIM(RETURN-VALUE).
            put unformatted skip
                            c-lbl-liter-elimina-pendencias-com-o-esta-2 + "." skip
                            c-lbl-liter-modificacao-2-eliminacao-6 + "             = " p-tipo-trans                   skip
                            c-lbl-liter-empresa-4 + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                            c-lbl-liter-estabelecimento-novo-2 + "                       = " mla-doc-pend-aprov.cod-estabel skip
                            c-lbl-liter-estabelecimento-antigo-2 + "                     = " p-cod-estabel                  skip
                            c-lbl-liter-documento-4 + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                            c-lbl-liter-chave-4 + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                            c-lbl-liter-historico-4 + "                                    = " mla-doc-pend-aprov.historico   skip.     
            FOR EACH tt-erro:
                PUT UNFORMATTED tt-erro.mensagem.
            END.
            output close.

            delete mla-doc-pend-aprov.
        end.
    end.

    find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-trans no-lock no-error.
    if  avail mla-usuar-aprov then
        assign c-lotacao-trans = mla-usuar-aprov.cod-lotacao. 
    /* busca a lotacao do usuario da transacao para a geracao da pendencia. Estava sendo gerada com a mesma pendencia do usuario do docto */

    /* Alteracao para verificar o usuario parametrizado para a aprovacao automatica */
    if  avail mla-usuar-aprov 
    and mla-usuar-aprov.usuar-mestre then
        /* Usuario mestre */
        assign l-mestre = yes.
    else do:
        if  mla-param-aprov.int-1 = 1 then 
            /* 1 - Usuario da transacao */
            find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-trans no-lock no-error.
        else
            /* 2 - Usuario do documento */
            find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-doc no-lock no-error.
    end.

    /**  Lotaá∆o
    **/

    if  mla-usuar-aprov.destino-lotacao = 1 THEN DO:
        assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        IF  c-lotacao = "" THEN
            assign c-lotacao = p-lotacao-doc.
    END.
    ELSE DO:
        assign c-lotacao = p-lotacao-doc.
        IF  c-lotacao = "" THEN
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
    END.
    
    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.    
    put skip(1).
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Usuario_Trans" *}
    PUT UNFORMATTED "    " + RETURN-VALUE + "                              = " p-usuar-trans                    SKIP.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Lotacao_Trans" *}
    PUT UNFORMATTED "    " + RETURN-VALUE + "                              = " c-lotacao-trans                  SKIP.  
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Usuario_Docto" *}
    PUT UNFORMATTED "    " + RETURN-VALUE + "                              = " p-usuar-doc                      SKIP. 
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Lotacao_Docto" *}
    PUT UNFORMATTED "    " + RETURN-VALUE + "                              = " c-lotacao                        SKIP.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Lotacao_(1)_/_Cento_Custo_(2)" *}
    PUT UNFORMATTED "    " + RETURN-VALUE + "              = " mla-usuar-aprov.destino-lotacao  SKIP.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Aprova_Auto_(Usuar_Trans/Doc)" *}
    put unformatted "    " + RETURN-VALUE + "              = " mla-param-aprov.int-1            skip.
    output close.
    
    /* Inicio - Chamada EPC - MERIAL repasse AED1 */
    if c-nom-prog-upc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-dpc-mg97  <> "" then do:
       
       for each tt-epc:
           delete tt-epc.
       end.
    
       create tt-epc.
       assign tt-epc.cod-event     = "afterLotacao":U
              tt-epc.cod-parameter = "tipo-documento":U
              tt-epc.val-parameter = STRING(p-cod-tip-doc).
    
       create tt-epc.
       assign tt-epc.cod-event     = "afterLotacao":U
              tt-epc.cod-parameter = "chave":U
              tt-epc.val-parameter = c-chave.
    
       {include/i-epc201.i "afterLotacao"}
    
       find first tt-epc no-lock  
            where tt-epc.cod-event = "afterLotacao" no-error.
       

       if avail  tt-epc and  
          string(tt-epc.cod-parameter,"x(20)") = "lotacao-escolhida":U then
          assign c-lotacao = tt-epc.val-parameter.
    
       for each tt-epc:
          delete tt-epc.
       end.
    end.
    /* FIM - Chamada EPC - MERIAL repasse AED1 */
    
    
    /**  Limite do aprovador **/
    FOR FIRST ITEM FIELD(it-codigo fm-codigo) 
        WHERE item.it-codigo = p-item 
        NO-LOCK: END.

    if  mla-usuar-aprov.aprova-auto-aprov then do:

        find bf-mla-perm-aprov where bf-mla-perm-aprov.ep-codigo   = p-ep-codigo 
                                 and bf-mla-perm-aprov.cod-estabel = p-cod-estabel 
                                 and bf-mla-perm-aprov.cod-usuar   = mla-usuar-aprov.cod-usuar                  /* bf-mla-perm-aprov.cod-usuar   = p-usuar-trans and */
                                 and bf-mla-perm-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.

        if avail bf-mla-perm-aprov then 
           assign de-limite-auto = bf-mla-perm-aprov.limite-aprov.
        if  available item then
            find bf-mla-lim-aprov-fam where bf-mla-lim-aprov-fam.ep-codigo   =  p-ep-codigo 
                                        and bf-mla-lim-aprov-fam.fm-codigo   =  item.fm-codigo 
                                        and bf-mla-lim-aprov-fam.cod-usuar   =  mla-usuar-aprov.cod-usuar        /* bf-mla-lim-aprov-fam.cod-usuar   = p-usuar-trans */
                                        and bf-mla-lim-aprov-fam.cod-tip-doc =  p-cod-tip-doc  no-lock no-error.

        if  avail bf-mla-lim-aprov-fam then 
            assign de-limite-auto = bf-mla-lim-aprov-fam.limite-aprov.
        if  l-mestre then
            assign de-limite-auto = 999999999.99.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.       
        put skip(1).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Aprova_Auto_Aprovador" *}
        PUT UNFORMATTED "    " + RETURN-VALUE SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Usuario" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " mla-usuar-aprov.cod-usuar SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor_docto" *}
        put unformatted "    " + RETURN-VALUE + "                                = " p-valor                   skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Limite" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                     = " de-limite-auto            SKIP. 
        output close.
    end.

    /**  Limite do aprovador
    **/
    if  mla-usuar-aprov.aprova-auto then do:
		
		assign de-valor-convert = p-valor.
		/*chamado TPOLOI - Rodrigo*/ 
		/*if mla-usuar-aprov.mo-codigo <> p-moeda then do:
		
			RUN cdp/cd0812.p (INPUT  mla-usuar-aprov.mo-codigo,  	    /*Moeda Origem - Documento*/
							  INPUT  p-moeda,  	 						/* Moeda Destino - Aprovador*/
							  INPUT  p-valor,       					/* Valor Origem a converter */
							  INPUT  TODAY,              				/* Datas da Convers„o*/
							  OUTPUT de-valor-convert).      				/* Valor retorno convertido */
			
			if de-valor-convert = ? then
				assign de-valor-convert = 0.
			
		end.*/
		
        find mla-perm-aprov where mla-perm-aprov.ep-codigo    =  p-ep-codigo   
                              and mla-perm-aprov.cod-estabel  =  p-cod-estabel 
                              and mla-perm-aprov.cod-tip-doc  =  p-cod-tip-doc 
                              and mla-perm-aprov.cod-usuar    =  mla-usuar-aprov.cod-usuar 
                              and mla-perm-aprov.limite-aprov >= de-valor-convert   
                              and mla-perm-aprov.validade-ini <= today
                              and mla-perm-aprov.validade-fim >= today no-lock no-error. /* mla-perm-aprov.cod-usuar   = p-usuar-trans */

        if  avail mla-perm-aprov then 
            assign de-limite-auto = mla-perm-aprov.limite-aprov.

        if  available item then
            find mla-lim-aprov-fam where mla-lim-aprov-fam.ep-codigo   = p-ep-codigo 
                                     and mla-lim-aprov-fam.fm-codigo   = item.fm-codigo 
                                     and mla-lim-aprov-fam.cod-usuar   = mla-usuar-aprov.cod-usuar         /* mla-lim-aprov-fam.cod-usuar   = p-usuar-trans */
                                     and mla-lim-aprov-fam.cod-tip-doc = p-cod-tip-doc  no-lock no-error.
        if  available mla-lim-aprov-fam then 
            assign de-limite-auto = mla-lim-aprov-fam.limite-aprov.
        if  l-mestre then
            assign de-limite-auto = 999999999.99.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.        
        put skip(1).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Aprova_Auto" *}
        PUT UNFORMATTED "    " + RETURN-VALUE SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Usuario" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " mla-usuar-aprov.cod-usuar SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor_docto" *}
        put unformatted "    " + RETURN-VALUE + "                                = " p-valor                   skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Limite" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                     = " de-limite-auto            SKIP. 
        output close.
    end.

    /**  Geraá∆o das pendàncias
    **/
    if  p-tipo-trans = 1 or
        p-tipo-trans = 2 then do:

        ASSIGN gi-prox-prior = 0. 

        find mla-tipo-doc-aprov where
            mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo and
            mla-tipo-doc-aprov.cod-estabel = p-cod-estabel and
            mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc
            no-lock no-error.
        if avail mla-tipo-doc-aprov then do:
            find first item where item.it-codigo = p-item no-lock no-error.
            if p-cod-tip-doc = 2 or /*Tipos de aprovaá∆o por total do documento*/
               p-cod-tip-doc = 4 or
               p-cod-tip-doc = 7 or
               p-cod-tip-doc = 8 or
               p-cod-tip-doc = 10 or
               p-cod-tip-doc = 13 then do:
               /* Inicio da valiá∆o para documentos por total - referencia/documento */
               if mla-tipo-doc-aprov.prioridade-aprov = 3 then do: /* Prioridade:  REFER“NCIA */
        
                   run pi-verifica-tipo-aprov-ref.
                   if  not l-avail-ref then 
                       run pi-verifica-tipo-aprov-doc.
    
               end.
               else if mla-tipo-doc-aprov.prioridade-aprov = 1 then do:    /* Prioridade:  DOCUMENTO */
                   run pi-verifica-tipo-aprov-doc.
               end. /* Fim da validaá∆o por referencia e documento por total */ 
            end.
            else  do: /* Inicio validaá∆o por referencia/item/familia/documento para controle por item */
               if mla-tipo-doc-aprov.prioridade-aprov = 3 then do:
        
                   run pi-verifica-tipo-aprov-ref.
                   if not l-avail-ref then do:
                       run pi-verifica-tipo-aprov-item.
                       if not l-avail-item then do:
                           run pi-verifica-tipo-aprov-fam.
                           if not l-avail-fam then 
                               run pi-verifica-tipo-aprov-doc.
                       end.
                   end.
                   
               end.
               else if mla-tipo-doc-aprov.prioridade-aprov = 2 then do: /* Inicio validaá∆o por item/familia/documento */
                   
                   run pi-verifica-tipo-aprov-item.
                   if not l-avail-item then do:
                       run pi-verifica-tipo-aprov-fam.
                       if not l-avail-fam then 
                           run pi-verifica-tipo-aprov-doc.
                   end.
                   
               end.
               else if  mla-tipo-doc-aprov.prioridade-aprov = 1 then do: /* Inicio da validaá∆o por documento */
                   run pi-verifica-tipo-aprov-doc.
               end.
            end.
        end.

        assign gi-prox-prior = i-prioridade.

        repeat while i-cod-aprov <> 0:

            find mla-tipo-aprov where
                mla-tipo-aprov.cod-tip-aprov = i-cod-aprov
                no-lock no-error.
            
            case mla-tipo-aprov.ind-tip-aprov:
                when 1 then 
                    run pi-gera-hierarquia.
                when 2 then 
                    run pi-gera-lista.
                when 3 then 
                    run pi-gera-padrao.
                when 4 then 
                    run pi-gera-padrao.
                when 5 then 
                    run pi-gera-faixa.
            end case.

            /**  Pr¢ximo tipo de aprovaá∆o
            **/
            assign i-cod-aprov = 0.
            /*if gi-prox-prior = 0 then do:*/
                case i-tip-aprov:
                    when 1 then do:
                        find first mla-tipo-aprov-doc 
                             where mla-tipo-aprov-doc.ep-codigo        = p-ep-codigo 
                               and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
                               and mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                        if available mla-tipo-aprov-doc then
                            assign i-cod-aprov   = mla-tipo-aprov-doc.cod-tip-aprov
                                   gi-prox-prior = mla-tipo-aprov-doc.prioridade-aprov.
                    end.
                    when 2 then do:
                        find first mla-tipo-aprov-item 
                             where mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
                               and mla-tipo-aprov-item.it-codigo        = p-item 
                               and mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                        if available mla-tipo-aprov-item then
                            assign i-cod-aprov   = mla-tipo-aprov-item.cod-tip-aprov
                                   gi-prox-prior = mla-tipo-aprov-item.prioridade-aprov.
                    end.
                    when 3 then do:
                        if available item then
                        find first mla-tipo-aprov-fam 
                             where mla-tipo-aprov-fam.ep-codigo        = p-ep-codigo 
                               and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo
                               and mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                        if available mla-tipo-aprov-fam then
                            assign i-cod-aprov   = mla-tipo-aprov-fam.cod-tip-aprov
                                   gi-prox-prior = mla-tipo-aprov-fam.prioridade-aprov.
                    end.
                    when 4 then do:
                        find first mla-tipo-aprov-ref 
                             where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
                               and mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc 
                               and mla-tipo-aprov-ref.codigo           = p-referencia
                               and mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                        if available mla-tipo-aprov-ref then
                            assign i-cod-aprov   = mla-tipo-aprov-ref.cod-tip-aprov
                                   gi-prox-prior = mla-tipo-aprov-ref.prioridade-aprov.
                    end.
                end case.
            /*end.*/
        end.
        assign gi-prox-prior = 0.
    end.

    
    
    /**  Gera hierarquia
    **/
    procedure pi-gera-hierarquia:
        find first mla-hierarquia-aprov where
            mla-hierarquia-aprov.ep-codigo   = p-ep-codigo   and
            mla-hierarquia-aprov.cod-estabel = p-cod-estabel and        
            mla-hierarquia-aprov.cod-lotacao = c-lotacao     and
            mla-hierarquia-aprov.cod-tip-doc = p-cod-tip-doc /*and
            mla-hierarquia-aprov.seq-aprov   = 1               */
            no-lock no-error.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        put skip(1).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gera_Hierarquia" *}
        PUT UNFORMATTED "    " + RETURN-VALUE SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Empresa" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " p-ep-codigo   SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelec" *}
        put unformatted "    " + RETURN-VALUE + "                                  = " p-cod-estabel skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Locatao" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " c-lotacao     SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        put unformatted "    " + RETURN-VALUE + "                                  = " p-cod-tip-doc skip.
        output close.
        
        if available mla-hierarquia-aprov then do:
            run pi-gera-pendencia (mla-hierarquia-aprov.cod-usuar,
                                   0,
                                   mla-hierarquia-aprov.seq-aprov).
        end.
    end procedure.
    
    
    /**  Gera lista
    **/
    procedure pi-gera-lista:
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        put skip(1).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gera_Lista" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "  "               SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Empresa" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " p-ep-codigo   SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelec" *}
        put unformatted "    " + RETURN-VALUE + "                                  = " p-cod-estabel skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " p-cod-tip-doc SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Referencia" *}
        put unformatted "    " + RETURN-VALUE + "                                 = " p-referencia  skip.
        output close.
        assign c-apr-lista = ""
               i-seq-lista = 0
               i-tip-lista = 0.
               
        assign l-achou-lista = no
               i-tenta-lista   = 1
               l-tem-aprovador = no.
        
        case mla-tipo-doc-aprov.prioridade-aprov:
            when 1 then assign i-ordem-lista = 4.
            when 2 then assign i-ordem-lista = 2.
            when 3 then assign i-ordem-lista = 1.
        end case.
               
        do while not l-achou-lista and
            i-tenta-lista < 5:
            
            case i-ordem-lista:
                when 1 then do:

                   assign l-desvia = no.

                   /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                   if c-nom-prog-upc-mg97  <> "" or 
                      c-nom-prog-appc-mg97 <> "" or 
                      c-nom-prog-dpc-mg97  <> "" then do:
                      for each tt-epc:
                          delete tt-epc.
                      end.
                                           
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                             tt-epc.cod-parameter = "lotacao":U
                             tt-epc.val-parameter = p-lotacao-doc. 
		
					  assign de-valor-convert = p-valor.
					  
					  find first mla-usuar-aprov
						  where mla-usuar-aprov.cod-usuar = p-usuar-doc no-lock no-error.
                      /*chamado TPOLOI - Rodrigo*/ 
					  /*if  avail mla-usuar-aprov and
                          mla-usuar-aprov.mo-codigo <> p-moeda then DO:
						
					    RUN cdp/cd0812.p (INPUT  p-moeda,  	      	        /* Moeda Origem - Documento*/
						    			  INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
										  INPUT  p-valor,       			/* Valor Origem a converter */
										  INPUT  TODAY,              		/* Datas da Convers„o*/
										  OUTPUT de-valor-convert).      	/* Valor retorno convertido */
						
						if de-valor-convert = ? then
							assign de-valor-convert = 0.				
						
					  end.*/
					
						
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                             tt-epc.cod-parameter = "valor-doc":U
                             tt-epc.val-parameter = string(de-valor-convert). 
                                          
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                             tt-epc.cod-parameter = "cod-usuar-doc":U
                             tt-epc.val-parameter = p-usuar-doc. 
                       
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                             tt-epc.cod-parameter = "cod-tip-doc":U
                             tt-epc.val-parameter = string(p-cod-tip-doc).

                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                             tt-epc.cod-parameter = "codigo-referencia":U
                             tt-epc.val-parameter = p-referencia.
                       
                      {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"}
                      if return-value <> "NOK":U then
                         assign l-desvia = no.
                      else
                         assign l-desvia = yes.
                    
                   end.
                   /* Fim - Chamada EPC - MERIAL repasse AED1 */
                    
                   if l-desvia = no then do:

                      /**  Referància
                      **/
                       find mla-tipo-aprov-ref
                      where mla-tipo-aprov-ref.ep-codigo     = p-ep-codigo 
                        and mla-tipo-aprov-ref.cod-tip-doc   = p-cod-tip-doc
                        and mla-tipo-aprov-ref.codigo        = p-referencia
                        and mla-tipo-aprov-ref.cod-tip-aprov = i-cod-aprov no-lock no-error.
                       if avail mla-tipo-aprov-ref then do:
                          if not l-lim-lista then do: /* todos os aprovadores */
                           
                             for each mla-lista-aprov-ref
                                where mla-lista-aprov-ref.ep-codigo   = p-ep-codigo
                                  and mla-lista-aprov-ref.cod-estabel = p-cod-estabel
                                  and mla-lista-aprov-ref.cod-tip-doc = p-cod-tip-doc
                                  and mla-lista-aprov-ref.codigo      = p-referencia no-lock:
                                  
                                find first mla-perm-aprov
                                     where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                       and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                       and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                       and mla-perm-aprov.cod-usuar     = mla-lista-aprov-ref.cod-usuar no-lock no-error.
                                  
                                if avail mla-perm-aprov then do:
                                   create tt-lista.
                                   assign tt-lista.seq-aprov       = mla-lista-aprov-ref.seq-aprov
                                          tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                          tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                          tt-lista.rowlista        = rowid(mla-lista-aprov-ref).
                                          l-achou-lista            = YES.
                                  
                                end.
                             end.
                             
                          end.
                          else do: /* apenas aprovadores com limite */
                              
                             for each mla-lista-aprov-ref
                                where mla-lista-aprov-ref.ep-codigo   = p-ep-codigo
                                  and mla-lista-aprov-ref.cod-estabel = p-cod-estabel
                                  and mla-lista-aprov-ref.cod-tip-doc = p-cod-tip-doc
                                  and mla-lista-aprov-ref.codigo      = p-referencia no-lock:
                
                                find first mla-perm-aprov
                                     where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                       and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                       and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                       and mla-perm-aprov.cod-usuar     = mla-lista-aprov-ref.cod-usuar no-lock no-error.
									   
								assign de-valor-convert = p-valor.
                                /*chamado TPOLOI - Rodrigo*/ 
								/*IF AVAIL mla-perm-aprov THEN DO:                                
    								find first mla-usuar-aprov
    									where mla-usuar-aprov.cod-usuar = mla-perm-aprov.cod-usuar no-lock no-error.
    								if  avail mla-usuar-aprov AND 
                                        mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    									RUN cdp/cd0812.p (INPUT  p-moeda,         		    /* Moeda Origem - Documento*/
    													  INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
    													  INPUT  p-valor,       			/* Valor Origem a converter */
    													  INPUT  TODAY,              		/* Datas da Convers„o*/
    													  OUTPUT de-valor-convert).      	/* Valor retorno convertido */
    													  
    									if de-valor-convert = ? then
    										assign de-valor-convert = 0.
    								end.
                                END.*/

                                if  avail mla-perm-aprov
                                    and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                    create tt-lista.
                                    assign tt-lista.seq-aprov       = mla-lista-aprov-ref.seq-aprov
                                           tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                           tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                           tt-lista.rowlista        = rowid(mla-lista-aprov-ref)
                                           l-achou-lista            = YES.
                                end.
                             end.
                             
                             release mla-lista-aprov-ref.
                             
                             find first tt-lista no-lock no-error.
                             if available tt-lista then
                                find first mla-lista-aprov-ref 
                                     where rowid(mla-lista-aprov-ref) = tt-lista.rowlista no-lock no-error.
     
                             
                          end.                    

                       end.
                   end.
                end.               
                when 2 then do:
                    /**  Item
                    **/
                    find mla-tipo-aprov-item
                   where mla-tipo-aprov-item.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-item.it-codigo     = p-item
                     and mla-tipo-aprov-item.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-item then do:
                                                           
                       if not l-lim-lista THEN DO: /* todos os aprovadores */
                          for each mla-lista-aprov-item
                             where mla-lista-aprov-item.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-item.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-item.it-codigo   = p-item no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-item.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-item.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-item)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-item
                             where mla-lista-aprov-item.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-item.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-item.it-codigo   = p-item no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-item.cod-usuar no-lock no-error.
                            
							assign de-valor-convert = p-valor.
							/*chamado TPOLOI - Rodrigo*/   
                            /*IF AVAIL mla-perm-aprov THEN DO:                            
    							find first mla-usuar-aprov
    								where mla-usuar-aprov.cod-usuar = mla-perm-aprov.cod-usuar no-lock no-error.
    							if  avail mla-usuar-aprov AND 
                                    mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    								RUN cdp/cd0812.p (INPUT  p-moeda,  	      			 /* Moeda Origem - Documento*/
    												  INPUT  mla-usuar-aprov.mo-codigo,  /* Moeda Destino - Aprovador*/
    												  INPUT  p-valor,       			 /* Valor Origem a converter */
    												  INPUT  TODAY,              		 /* Datas da Convers„o*/
    												  OUTPUT de-valor-convert).      	 /* Valor retorno convertido */
    						
    								if de-valor-convert = ? then
    									assign de-valor-convert = 0.
    							end.
                            END.*/

                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-item.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-item)
                                        l-achou-lista            = YES.
                             end.
                          end.
   
                          release mla-lista-aprov-item.
                           
                          find first tt-lista no-lock no-error.
                          if available tt-lista THEN
                             find first mla-lista-aprov-item 
                                  where rowid(mla-lista-aprov-item) = tt-lista.rowlista no-lock no-error.
   
                       end.                  
                    end.
                end.         
                when 3 then do:
                    /**  Fam°lia
                    **/
                    find mla-tipo-aprov-fam
                   where mla-tipo-aprov-fam.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-fam.fm-codigo     = item.fm-codigo
                     and mla-tipo-aprov-fam.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-fam then do:
                       
                       if not l-lim-lista then do: /* todos os aprovadores */
                          for each mla-lista-aprov-fam
                             where mla-lista-aprov-fam.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-fam.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-fam.fm-codigo   = item.fm-codigo no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-fam.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-fam.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-fam)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-fam
                             where mla-lista-aprov-fam.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-fam.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-fam.fm-codigo   = item.fm-codigo no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-fam.cod-usuar no-lock no-error.
								
							 assign de-valor-convert = p-valor.
                             /*chamado TPOLOI - Rodrigo*/ 
							 /*IF AVAIL mla-perm-aprov THEN DO:                             
    							 find first mla-usuar-aprov
    						 		 where mla-usuar-aprov.cod-usuar = mla-perm-aprov.cod-usuar no-lock no-error.
    							 if  avail mla-usuar-aprov and
                                     mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    								RUN cdp/cd0812.p (INPUT  p-moeda,  	                /* Moeda Origem - Documento*/
    								         		  INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
    												  INPUT  p-valor,       	        /* Valor Origem a converter */
    												  INPUT  TODAY,                     /* Datas da Convers„o*/
    												  OUTPUT de-valor-convert).         /* Valor retorno convertido */
    								
    								if de-valor-convert = ? then
    									assign de-valor-convert = 0.				
    								
    							 end.
                             END.*/

                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-fam.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-fam).
                                        l-achou-lista            = YES.
                             end.
                          end.
                           
                          release mla-lista-aprov-fam.
                          find first tt-lista no-lock no-error.
                          if available tt-lista then
                             find first mla-lista-aprov-fam 
                                  where rowid(mla-lista-aprov-fam) = tt-lista.rowlista no-lock no-error.
                       
                       end.                    
                    end.
                end.               
                when 4 then do:
                    /**  Documento
                    **/
                   
                    find mla-tipo-aprov-doc
                   where mla-tipo-aprov-doc.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-doc.cod-tip-doc   = p-cod-tip-doc
                     and mla-tipo-aprov-doc.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-doc then do:
                       
                       if not l-lim-lista THEN DO: /* todos os aprovadores */
                          for each mla-lista-aprov-doc
                             where mla-lista-aprov-doc.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-doc.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-doc.cod-tip-doc = p-cod-tip-doc no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-doc.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-doc.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-doc)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-doc
                             where mla-lista-aprov-doc.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-doc.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-doc.cod-tip-doc = p-cod-tip-doc no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-doc.cod-usuar no-lock no-error.
									
							 assign de-valor-convert = p-valor.
							 /*chamado TPOLOI - Rodrigo*/  
                             /*IF AVAIL mla-perm-aprov THEN DO:                             
    							 find first mla-usuar-aprov
    								 where mla-usuar-aprov.cod-usuar = mla-perm-aprov.cod-usuar no-lock no-error.
    							 if  avail mla-usuar-aprov AND
                                     mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    								RUN cdp/cd0812.p (INPUT  p-moeda,  	      		    /* Moeda Origem - Documento*/
    											      INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
    												  INPUT  p-valor,       			/* Valor Origem a converter */
    												  INPUT  TODAY,              		/* Datas da Convers∆o*/
    												  OUTPUT de-valor-convert).      	/* Valor retorno convertido */
    								
    								if de-valor-convert = ? then
    									assign de-valor-convert = 0.				
    							 
    							 end.
                             END.*/
									
                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-doc.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-doc)
                                        l-achou-lista            = YES.
                             end.
                          end.
                           
                          release mla-lista-aprov-doc.
                          find first tt-lista no-lock no-error.
                          if available tt-lista then
                             find first mla-lista-aprov-doc 
                                  where rowid(mla-lista-aprov-doc) = tt-lista.rowlista no-lock no-error.
   
                       end.                    
                    END.
                end.               
            end case.

            IF l-lim-lista THEN DO:
                find first tt-lista no-error.
                assign l-achou-lista = available tt-lista.
            END.
                    
            if not l-achou-lista then
                assign i-ordem-lista = i-ordem-lista + 1.
            if i-ordem-lista > 4 then
                assign i-ordem-lista = 1.
            assign i-tenta-lista = i-tenta-lista + 1.
        end.

        /*************************************************************************/
        /*** IN÷CIO CHAMADA EPC - Cliente: XXX / FO: 9999.9999                 ***/
        /*************************************************************************/
        /*** Prop¢sito: Permitir que na aprovaá∆o por lista seja gerada apenas ***/
        /***            uma pendància para um aprovador da lista de acordo com ***/
        /***            o limite de aprovaá∆o                                  ***/
        /*** Parametros:                                                       ***/
        /***    -> HANDLE-TT-LISTA: disponibiliza o handle da tt-lista para    ***/
        /***                        que os aprovadores da lista sejam mani-    ***/
        /***                        pulados, ou seja, permite que os dados     ***/
        /***                        da tt-lista sejam alterados ou eliminados  ***/
        /***                        e devolvidos ao programa para geraá∆o das  ***/
        /***                        pendàncias de aprovaá∆o.                   ***/
        /***    -> VALOR-DOCUMENTO: disponibiliza o valor do documento para    ***/
        /***                        que seja verificado se os aprovadores da   ***/
        /***                        lista possuem limite para aprovaá∆o,       ***/
        /***                        gerando apenas uma pendància para o        ***/
        /***                        aprovador que possuir limite para aprovaá∆o***/
        /*************************************************************************/

        if  c-nom-prog-upc-mg97 <> "" then do:

            for each tt-epc
                where tt-epc.cod-event = "LISTA-APROVADORES":
                delete tt-epc.
            end.

            /* handle da temp-table de aprovadores da lista */
            {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                 &CodParameter='"HANDLE-TT-LISTA"'
                                 &ValueParameter="string(temp-table tt-lista:handle)"}

			assign de-valor-convert = p-valor.
			/*chamado TPOLOI - Rodrigo*/  
            /*IF AVAIL tt-lista THEN DO:           
    			find first mla-usuar-aprov
    				where mla-usuar-aprov.cod-usuar = tt-lista.cod-usuar-aprov no-lock no-error.
    			if  avail mla-usuar-aprov AND
                    mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    				RUN cdp/cd0812.p (INPUT  p-moeda,  	      			  /* Moeda Origem - Documento*/
    								  INPUT  mla-usuar-aprov.mo-codigo,   /* Moeda Destino - Aprovador*/
    								  INPUT  p-valor,       			  /* Valor Origem a converter */
    								  INPUT  TODAY,              		  /* Datas da Convers„o*/
    								  OUTPUT de-valor-convert).      	  /* Valor retorno convertido */
    								  
    				if de-valor-convert = ? then
    					assign de-valor-convert = 0.				
    			end.
            END.*/

			/* valor do pendància */
            {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                 &CodParameter='"VALOR-DOCUMENTO"'
                                 &ValueParameter="string(de-valor-convert)"}

            {include/i-epc201.i "LISTA-APROVADORES"}

            /* caso a EPC retorne erro n∆o deve proceder com a geraá∆o das pendàncias */
            if  return-value = "NOK":U then
                return "NOK":U.

        end.

        /*************************************************************************/
        /*** FIM CHAMADA EPC - Cliente: XXX / FO: 9999.9999                    ***/
        /*************************************************************************/

        for each tt-lista no-lock
            by tt-lista.limite-aprov:

            /* geraá∆o de pendàncias da lista */
            run pi-gera-pendencia (tt-lista.cod-usuar-aprov,
                                   0,
                                   tt-lista.seq-aprov).
        end.
                                                                                      
    end procedure.
    
    
    /**  Gera padr∆o e tÇcnica
    **/
    procedure pi-gera-padrao:
        find first mla-usuar-padrao where
            mla-usuar-padrao.ep-codigo   = p-ep-codigo and
            mla-usuar-padrao.cod-estabel = p-cod-estabel and        
            mla-usuar-padrao.cod-tip-aprov = mla-tipo-aprov.cod-tip-aprov
            no-lock no-error.
        if available mla-usuar-padrao then do:
            run pi-gera-pendencia (mla-usuar-padrao.cod-usuar,
                                   0,
                                   10).
        end.
    end procedure.
    
    
    /**  Gera Faixa
    **/
    procedure pi-gera-faixa:

		assign de-valor-convert = p-valor.
		/*chamado TPOLOI - Rodrigo*/   
		/*find first mla-usuar-aprov
			where mla-usuar-aprov.cod-usuar = p-usuar-doc no-lock no-error.
		if  avail mla-usuar-aprov and
            mla-usuar-aprov.mo-codigo <> p-moeda then DO:

			RUN cdp/cd0812.p (INPUT  p-moeda,  	      			  /* Moeda Origem - Documento*/
							  INPUT  mla-usuar-aprov.mo-codigo,   /* Moeda Destino - Aprovador*/
							  INPUT  p-valor,       			  /* Valor Origem a converter */
							  INPUT  TODAY,              		  /* Datas da Convers„o*/
							  OUTPUT de-valor-convert).      	  /* Valor retorno convertido */
			
			if de-valor-convert = ? then
				assign de-valor-convert = 0.				
		end.*/

		find first mla-faixa-aprov where
            mla-faixa-aprov.ep-codigo   = p-ep-codigo   and
            mla-faixa-aprov.cod-estabel = p-cod-estabel and        
            mla-faixa-aprov.cod-tip-doc = p-cod-tip-doc and
            mla-faixa-aprov.cod-lotacao = c-lotacao     and
           (mla-faixa-aprov.limite-ini <= de-valor-convert and
            mla-faixa-aprov.limite-fim >= de-valor-convert)
            no-lock no-error.                  
        
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gera_Faixa" *}
        PUT UNFORMATTED skip(1) 
                        "    " + RETURN-VALUE + "                                   "                SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Empresa" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " p-ep-codigo    SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelec" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " p-cod-estabel  SKIP. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " p-cod-tip-doc  SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Lotacao" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " c-lotacao      SKIP. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                      = " p-valor        SKIP. 
        OUTPUT CLOSE.

        if available mla-faixa-aprov then do:
            find FIRST mla-hierarquia-faixa where
                       mla-hierarquia-faixa.ep-codigo   = p-ep-codigo   and
                       mla-hierarquia-faixa.cod-estabel = p-cod-estabel and                
                       mla-hierarquia-faixa.cod-tip-doc = p-cod-tip-doc and
                       mla-hierarquia-faixa.cod-lotacao = c-lotacao     and
                       mla-hierarquia-faixa.num-faixa   = mla-faixa-aprov.num-faixa
                no-lock no-error.

            if  available mla-hierarquia-faixa then do:                  
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Faixa" *}
                PUT unformatted "    " + RETURN-VALUE + "                                      = " mla-hierarquia-faixa.num-faixa SKIP.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Aprovador" *}
                PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " mla-hierarquia-faixa.cod-usuar SKIP.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Sequencia_Aprov" *}
                PUT UNFORMATTED "    " + RETURN-VALUE + "                            = " mla-hierarquia-faixa.seq-aprov SKIP.
                output close.


                /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                if c-nom-prog-upc-mg97  <> "" or 
                   c-nom-prog-appc-mg97 <> "" or 
                   c-nom-prog-dpc-mg97  <> "" then do:
                   
                   for each tt-epc:
                      delete tt-epc.
                   end.
    
                   create tt-epc.
                   assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                          tt-epc.cod-parameter = "cod-usuar-doc":U
                          tt-epc.val-parameter = p-usuar-doc. 

                   create tt-epc.
                   assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                          tt-epc.cod-parameter = "r-aed-hierarquia-faixa"
                          tt-epc.val-parameter =  string(rowid(mla-hierarquia-faixa)). 
                
                   {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"}
                
                   if  return-value = "OK" then do:
                       find first tt-epc 
                            where tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                              and tt-epc.cod-parameter = "r-aed-hierarquia-faixa"
                              and tt-epc.val-parameter <> "" no-error.

                       if available tt-epc then 
                          find mla-hierarquia-faixa 
                         where rowid(mla-hierarquia-faixa) = to-rowid(tt-epc.val-parameter) no-lock no-error. 
                   end.
                end.
                /* Fim - Chamada EPC - MERIAL repasse AED1 */


                run pi-gera-pendencia (mla-hierarquia-faixa.cod-usuar,
                                       mla-hierarquia-faixa.num-faixa,
                                       mla-hierarquia-faixa.seq-aprov).

                /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                create tt-epc.
                assign tt-epc.cod-event     = "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA"
                       tt-epc.cod-parameter = "r-mla-doc-pend-aprov"
                       tt-epc.val-parameter = STRING(ROWID(mla-doc-pend-aprov)). 

                {include/i-epc201.i "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA"}
               /* Fim - Chamada EPC - MERIAL repasse AED1 */
             
            end.
        end.
        
    end procedure.    
    
    
    /**  Gera pendàncias
    **/
    procedure pi-gera-pendencia:
        def input parameter p-aprovador as char    no-undo.
        def input parameter p-faixa     as integer no-undo.
        def input parameter p-sequencia as integer no-undo.
        RUN pi-verifica-sit-ordem (INPUT p-cod-tip-doc).

        IF RETURN-VALUE <> "OK" THEN
            RETURN.          
		
		assign de-valor-convert = p-valor.
		/*chamado TPOLOI - Rodrigo*/   
		/*find first mla-usuar-aprov
			where mla-usuar-aprov.cod-usuar = p-aprovador no-lock no-error.
		if  avail mla-usuar-aprov AND 
            mla-usuar-aprov.mo-codigo <> p-moeda then DO:

			RUN cdp/cd0812.p (INPUT  p-moeda,  	      			/*Moeda Origem - Documento*/
							  INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
							  INPUT  p-valor,       			/* Valor Origem a converter */
							  INPUT  TODAY,              		/* Datas da Convers„o*/
							  OUTPUT de-valor-convert).      	/* Valor retorno convertido */
			
			if de-valor-convert = ? then
				assign de-valor-convert = 0.				
			
		end.*/
		
        create mla-doc-pend-aprov.
        assign mla-doc-pend-aprov.ep-codigo         = p-ep-codigo
               mla-doc-pend-aprov.cod-estabel       = p-cod-estabel
               mla-doc-pend-aprov.chave-doc         = c-chave
               mla-doc-pend-aprov.cod-lotacao-doc   = c-lotacao /* p-lotacao-doc - Favretto */
               mla-doc-pend-aprov.cod-lotacao-trans = c-lotacao-trans /* Alterado  para buscar a lotacao do usuario da transacao - Favretto */
               mla-doc-pend-aprov.cod-tip-aprov     = i-cod-aprov
               mla-doc-pend-aprov.cod-tip-doc       = p-cod-tip-doc
               mla-doc-pend-aprov.cod-usuar         = p-aprovador
               mla-doc-pend-aprov.cod-usuar-doc     = p-usuar-doc
               mla-doc-pend-aprov.cod-usuar-trans   = p-usuar-trans
               mla-doc-pend-aprov.dt-geracao        = today
               mla-doc-pend-aprov.ind-situacao      = 1
               mla-doc-pend-aprov.ind-tip-aprov     = mla-tipo-aprov.ind-tip-aprov
               mla-doc-pend-aprov.it-codigo         = p-item
               mla-doc-pend-aprov.mo-codigo         = p-moeda
               mla-doc-pend-aprov.motivo-doc        = p-motivo
               mla-doc-pend-aprov.num-faixa         = p-faixa
               mla-doc-pend-aprov.seq-aprov         = p-sequencia
               mla-doc-pend-aprov.valor-doc         = de-valor-convert
               mla-doc-pend-aprov.prioridade-aprov  = i-prioridade
               mla-doc-pend-aprov.hora-geracao      = string(time,"HH:MM:SS")
               mla-doc-pend-aprov.cod-referencia    = p-referencia.
        RUN pi-verifica-priorid-aprovacao IN THIS-PROCEDURE.
        RUN pi-busca-cond-pagto  (OUTPUT i-cod-cond-pag).
        ASSIGN OVERLAY(mla-doc-pend-aprov.char-1,25,4) = STRING(i-cod-cond-pag).

    /*************************************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: BANCARIA / FO: 1220.647             ***/
    /*************************************************************************/
    /*** Prop¢sito: Permitir que uma pendància tenha seus dados alterados  ***/
    /***            antes do envio do e-mail.                              ***/
    /*************************************************************************/

    if  c-nom-prog-upc-mg97 <> "" then do:

        for each tt-epc
            where tt-epc.cod-event = "AFTER-CREATE-mla-DOC-PEND-APROV".
            delete tt-epc.
        end.
    
        /*rowid da tabela mla-doc-pend-aprov*/
        {include/i-epc200.i2 &CodEvent='"AFTER-CREATE-mla-DOC-PEND-APROV"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "AFTER-CREATE-mla-DOC-PEND-APROV"}

        find first tt-epc
            where tt-epc.cod-event     = "AFTER-CREATE-mla-DOC-PEND-APROV"
            and   tt-epc.cod-parameter = "NEW-APROVADOR"
            no-error.
        if  avail tt-epc
        and tt-epc.val-parameter <> "" then
            assign p-aprovador = tt-epc.val-parameter.

    end.

    /*************************************************************************/
    /*** FIM CHAMADA EPC - Cliente: BANCARIA / FO: 1220.647                ***/
    /*************************************************************************/
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gera_Pendencia" *}
        PUT UNFORMATTED skip(1) 
                        "    " + RETURN-VALUE + "  "                                      SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Empresa" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                    = " mla-doc-pend-aprov.ep-codigo         SKIP.  
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelec" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " mla-doc-pend-aprov.cod-estabel       SKIP. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " mla-doc-pend-aprov.chave-doc         SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Usuario_Doc" *}
        put unformatted "    " + RETURN-VALUE + "                                = " mla-doc-pend-aprov.cod-usuar-doc     skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Lotacao_Doc" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                                = " mla-doc-pend-aprov.cod-lotacao-doc   SKIP. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Usuario_Trans" *}
        put unformatted "    " + RETURN-VALUE + "                              = " mla-doc-pend-aprov.cod-usuar-trans   skip.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Lotacao_Trans" *}
        PUT UNFORMATTED "    " + RETURN-VALUE + "                              = " mla-doc-pend-aprov.cod-lotacao-trans SKIP. 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor" *}
        put unformatted "    " + RETURN-VALUE + "                                      = " mla-doc-pend-aprov.valor-doc         skip.

        output close.
               
        assign l-aprovado      = NO
               l-aprovado-auto = NO.
               
        FIND bb-mla-usuar-aprov WHERE
             bb-mla-usuar-aprov.cod-usuar = p-usuar-doc
             NO-LOCK NO-ERROR.
        /*
        ** Aprovaá∆o Autom†tica
        */
        IF AVAIL bb-mla-usuar-aprov       AND
           bb-mla-usuar-aprov.perm-aprov  AND 
           bb-mla-usuar-aprov.aprova-auto AND 
           de-limite-auto >= de-valor-convert      THEN DO:

           /****** INICIO Ponto EPC Jo∆o Santos **********/
            
            if c-nom-prog-upc-mg97  <> "" then do:
               for each tt-epc:
                   delete tt-epc.
               end.
                   
               create tt-epc.
               assign tt-epc.cod-event     = "APROVA-AUTO":U
                      tt-epc.cod-parameter = "documento":U
                      tt-epc.val-parameter = STRING(p-cod-tip-doc).
                                    
               {include/i-epc201.i "APROVA-AUTO"}
                  
               find first tt-epc
                    where tt-epc.cod-event     = "APROVA-AUTO"
                    and   tt-epc.cod-parameter = "retorno" no-error.
               if  avail tt-epc THEN NEXT.
            END.
    
            /****** FIM Ponto EPC Jo∆o Santos **********/

            assign l-aprovado      = YES
                   l-aprovado-auto = YES.

           /*{utp/ut-liter.i Aprovaá∆o_Autom†tica_-_Usu†rio_ * r}*/
           ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
          /* {utp/ut-liter.i _parametrizado_no_MLA0103_como_Aprovaá∆o_Autom†tica * r}*/
           ASSIGN mla-doc-pend-aprov.aprov-auto        = YES
                  mla-doc-pend-aprov.dt-aprova         = TODAY
                  mla-doc-pend-aprov.ind-situacao      = 2
                  mla-doc-pend-aprov.cod-usuar         = p-usuar-doc 
                  mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(p-usuar-doc) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica"
                  OVERLAY(mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 

           /**  Executa programa parametrizado para Aprovacao Automatica
           **/
           RUN pi-aprova-auto.
           
           RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).

        END.
        ELSE DO:

            /****** INICIO Ponto EPC Jo∆o Santos **********/
            
            if c-nom-prog-upc-mg97  <> "" then do:
               for each tt-epc:
                   delete tt-epc.
               end.

               create tt-epc.
               assign tt-epc.cod-event     = "APROVA-AUTO":U
                      tt-epc.cod-parameter = "documento":U
                      tt-epc.val-parameter = STRING(p-cod-tip-doc).
                                    
               {include/i-epc201.i "APROVA-AUTO"}
                  
               find first tt-epc
                    where tt-epc.cod-event     = "APROVA-AUTO"
                    and   tt-epc.cod-parameter = "retorno" no-error.
               if  avail tt-epc THEN NEXT.
            END.
    
            /****** FIM Ponto EPC Jo∆o Santos **********/

            FIND bb-mla-usuar-aprov WHERE
                 bb-mla-usuar-aprov.cod-usuar = p-aprovador
                 NO-LOCK NO-ERROR.
            /*
            ** Aprovaá∆o Autom†tica para Aprovador
            */
            IF AVAIL bb-mla-usuar-aprov             AND
               bb-mla-usuar-aprov.perm-aprov        AND 
               bb-mla-usuar-aprov.aprova-auto-aprov AND 
               p-aprovador = p-usuar-doc            AND
               de-limite-auto > de-valor-convert             THEN DO:
    
                assign l-aprovado = yes.
    
               /*{utp/ut-liter.i Aprovaá∆o_Autom†tica_-_Usu†rio_ * r}*/
               ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
               /*{utp/ut-liter.i _parametrizado_no_MLA0103_como_Aprovaá∆o_Autom†tica_para_Aprovadores * r}*/
               ASSIGN mla-doc-pend-aprov.aprov-auto        = YES
                      mla-doc-pend-aprov.dt-aprova         = TODAY
                      mla-doc-pend-aprov.ind-situacao      = 2
                      mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(p-aprovador) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica".
    
               assign substring(mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 
    
               RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).

               if mla-doc-pend-aprov.ind-tip-aprov = 1 then do:
                  assign l-aprovado = no.           
                  RUN pi-gera-pend-hierarquia (de-limite-auto).
               end.
               if mla-doc-pend-aprov.ind-tip-aprov = 5 then do:
                  assign l-aprovado = no.
                  run pi-gera-pend-faixa (de-limite-auto).
               end.

               /**  Executa programa parametrizado para Aprovacao Automatica
               **/
               RUN pi-aprova-auto.

            END.
            ELSE DO:
                /**  Para n∆o gera pendància para o pr¢ximo tipo de aprovaá∆o **/
                assign gi-prox-prior     = 990.

               /*****
               IF de-limite > de-valor-convert THEN DO:
                  assign l-aprovado = yes.
                  {utp/ut-liter.i Aprovaá∆o_autom†tica_com_limite. * r}
                   ASSIGN mla-doc-pend-aprov.aprov-auto        = YES
                          mla-doc-pend-aprov.cod-usuar-altern  = p-usuar-trans
                          mla-doc-pend-aprov.dt-aprova         = TODAY
                          mla-doc-pend-aprov.ind-situacao      = 2
                          mla-doc-pend-aprov.narrativa-apr     = RETURN-VALUE.
                          
                   assign substring(mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss").                       
                          
               END.                   
               ELSE DO:
               *****/
                  IF AVAILABLE mla-param-aprov AND
                     mla-param-aprov.log-email AND 
                     NOT l-aprovado-auto THEN DO:

                      ASSIGN l-proces-compl = YES.

                      /* Verificar se o documento gerou de forma correta, sem interrupÁ„o */
                      IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
                         p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
                         p-cod-tip-doc = 2 /* SolicitaÁ„o de Compra Total */ OR
                         p-cod-tip-doc = 4 /* RequisiÁ„o de Estoque Total */ THEN DO:
                          RUN pi-valida-docto (OUTPUT l-proces-compl).
                      END.

                      IF l-proces-compl THEN
                          RUN pi-envia-e-mail (p-aprovador).
                  END.
               /*****
               END.
               *****/
            END.
        END.

        /* Se a pendància n∆o for aprovada automaticamente */
        IF mla-doc-pend-aprov.aprov-auto = NO THEN DO:
            RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(mla-doc-pend-aprov)).
        END.

        /**  E-mail's Alternativos
        **/
        if  not l-aprovado and
            mla-param-aprov.log-email-altern then do:
            /** Geraá∆o **/
            run lap/mla0130a.p (1, 
                                 p-aprovador,
                                 rowid(mla-doc-pend-aprov),
                                 input table tt-mla-chave).
        end.            


    end procedure.
    
    
    /**  Envia e-mail
    **/
    procedure pi-envia-e-mail:
        def input parameter p-usuar-destino as char no-undo.
    
    /*************************************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
    /*************************************************************************/
    /*** Prop¢sito: Interferir no envio do e-mail de pendància, permitindo ***/
    /***            ou n∆o o envio do e-mail ao usu†rio aprovador.         ***/
    /*** Parametros:                                                       ***/
    /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
    /***                                 para que a partir deste seja      ***/
    /***                                 poss°vel identificar o documento  ***/
    /***                                 e permitir ou n∆o o envio do      ***/
    /***                                 e-mail de pendància.              ***/
    /*************************************************************************/

    if  c-nom-prog-upc-mg97 <> "" then do:

        for each tt-epc
            where tt-epc.cod-event = "SEND-EMAIL".
            delete tt-epc.
        end.
    
        /*rowid mla-doc-pend-aprov */
        {include/i-epc200.i2 &CodEvent='"SEND-EMAIL"'
                             &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "SEND-EMAIL"}

        if  return-value = "NOK" then
            return "NOK".

    end.

    /*************************************************************************/
    /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
    /*************************************************************************/
	    CREATE tt-mla-chave. 
            ASSIGN p-chave-doc = mla-doc-pend-aprov.chave-doc.
            for each mla-chave-doc-aprov no-lock
               where mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc:
                assign i-posicao = i-posicao + 1.
                assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                                      mla-chave-doc-aprov.posicao-ini,
                                                                      (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                                      mla-chave-doc-aprov.posicao-ini))).
            END.


    ASSIGN c-anexo = "".

    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail".
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "pi-envia-e-mail"}

        FIND FIRST tt-epc NO-LOCK  
             WHERE tt-epc.cod-event     = "pi-envia-e-mail" 
               AND tt-epc.cod-parameter = "arquivo-anexo" NO-ERROR.
            
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.

        find b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = p-usuar-destino
            no-lock no-error.

        RUN gera-mensagens. /* carrega as vari†veis com as mensagens */

        
        

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:

            
            IF NOT l-aedapi100-ativo THEN DO:

            
                find first b-mla-doc-pend-aprov where
                    b-mla-doc-pend-aprov.ep-codigo       = p-ep-codigo   and
                    b-mla-doc-pend-aprov.cod-estabel     = p-cod-estabel and
                    b-mla-doc-pend-aprov.cod-tip-doc     = mla-tipo-doc-aprov.cod-tip-doc and
                    b-mla-doc-pend-aprov.chave-doc       = c-chave       and
                    b-mla-doc-pend-aprov.ind-situacao    > 1             and
                    b-mla-doc-pend-aprov.historico       = no
                    no-lock no-error.
            
            END.

            if available b-mla-doc-pend-aprov then do:
                /**  E-mail de Aprovador para Aprovador
                **/

                IF mla-tipo-doc-aprov.cod-tip-doc = 7
                OR mla-tipo-doc-aprov.cod-tip-doc = 8 THEN
                   find first b-mla-usuar-aprov where
                        b-mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar-doc
                        no-lock no-error.

                IF b-mla-doc-pend-aprov.cod-usuar-alter <> "" THEN DO:
                    FIND mla-usuar-aprov 
                         WHERE mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar-alter
                         NO-LOCK NO-ERROR.
                    IF AVAIL mla-usuar-aprov THEN
                        assign c-aprovador = mla-usuar-aprov.cod-usuar
                               i-mo-codigo = mla-usuar-aprov.mo-codigo.
                END.
                ELSE DO: 
                    FIND mla-usuar-aprov 
                         WHERE mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar
                         NO-LOCK NO-ERROR.
                    IF AVAIL mla-usuar-aprov THEN
                        assign c-aprovador = mla-usuar-aprov.cod-usuar
                               i-mo-codigo = mla-usuar-aprov.mo-codigo.
                END.
                FIND FIRST moeda 
                     WHERE moeda.mo-codigo = b-mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.
                
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).
        
                assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave,
                                                 moeda.sigla + " " + trim(string(b-mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                 c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10).

                if b-mla-doc-pend-aprov.cod-tip-doc = 2 
                or b-mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                   for each it-requisicao
                        where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.
                IF b-mla-doc-pend-aprov.cod-tip-doc = 1 
                or b-mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                   for each it-requisicao
                    where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                    and   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                    and   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.

                if mla-param-aprov.compl-email <> "" then do:
                    assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
                end.
                
                for each tt-envio:
                    delete tt-envio.
                end.
                
                for each tt-erros:
                    delete tt-erros.
                end.
                
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = c-anexo.
                if mla-usuar-aprov.e-mail <> "" then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                IF NOT l-exchange THEN 
                     ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                            tt-envio.porta    = mla-param-aprov.porta-email.

                   
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.
                
/*                 run utp/utapi009.p (input  table tt-envio,                                 */
/*                                     output table tt-erros).                                */
/*                                                                                            */
/*                 /**  Output do erro (e-mail)                                               */
/*                 **/                                                                        */
/*                 find first tt-envio no-error.                                              */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (01)" tt-envio.destino tt-envio.remetente} */
                                    
                /**  Envia E-mail para os Alternativos
                **/ 

                

                if mla-param-aprov.log-aprov-altern then do:
                    

                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                        mla-usuar-aprov-altern.validade-ini <= b-mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= b-mla-doc-pend-aprov.dt-geracao no-lock:
                        assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

                        

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = c-alternativo
                            no-lock no-error.
                        find first moeda
                             where moeda.mo-codigo = b-mla-doc-pend-aprov.mo-codigo no-lock no-error.

                        assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave).
                
                        assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave,
                                                         moeda.sigla + " " + trim(string(b-mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                         c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10).

                        if b-mla-doc-pend-aprov.cod-tip-doc = 2 
                        or b-mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                           for each it-requisicao
                               where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.
                        if b-mla-doc-pend-aprov.cod-tip-doc = 1 
                        or b-mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                           for each it-requisicao
                              where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                                and   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                                and   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.

                        if mla-param-aprov.compl-email <> "" then 
                            assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
                        for each tt-envio:
                            delete tt-envio.
                        end.
                        
                        for each tt-erros:
                            delete tt-erros.
                        end.

                        create tt-envio.
                        assign tt-envio.versao-integracao = 1
                               tt-envio.exchange    = l-exchange
                               tt-envio.destino     = b-mla-usuar-aprov.e-mail
                               tt-envio.assunto     = c-ass-e-mail
                               tt-envio.mensagem    = c-men-e-mail
                               tt-envio.importancia = 2
                               tt-envio.log-enviada = no
                               tt-envio.log-lida    = no
                               tt-envio.acomp       = no
                               tt-envio.arq-anexo   = c-anexo.
                        if mla-usuar-aprov.e-mail <> "" then
                           assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                        IF NOT l-exchange THEN 
                        ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                               tt-envio.porta    = mla-param-aprov.porta-email.
                           
                        FOR EACH tt-erros :
                            DELETE tt-erros.
                        END.


/*                         run utp/utapi009.p (input  table tt-envio,                                 */
/*                                             output table tt-erros).                                */
/*                                                                                                    */
/*                         /**  Output do erro (e-mail)                                               */
/*                         **/                                                                        */
/*                         find first tt-envio no-error.                                              */
/*                         {lap/mlaapi001.i02 "mlaapi001.p (02)" tt-envio.destino tt-envio.remetente} */
                                            
                    end.
                end.

                if gi-prox-prior >= 20 then do: /*Alterado para gerar HTML qdo aprovado pelo client e existe mais um tipo de aprovaá∆o*/
                    assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).

                    run pi-gera-html (input p-usuar-destino).

                end.
 
            end.
            else do:
            
                

                /**  E-mail de Usu†rio para Aprovador
                **/
                find mla-usuar-aprov 
                     where mla-usuar-aprov.cod-usuar = p-usuar-trans
                     no-lock no-error.

                if  available mla-usuar-aprov THEN
                    ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.

                

               
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).
                
                run pi-gera-html (input p-usuar-destino).
                
            end.                
        end.
    end procedure.
    
    procedure pi-envia-e-mail-aprova-auto:
        def input parameter p-usuar-destino as char no-undo.
        
        /*************************************************************************/
        /*** IN÷CIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
        /*************************************************************************/
        /*** Prop¢sito: Interferir no envio do e-mail de pendància, permitindo ***/
        /***            ou n∆o o envio do e-mail ao usu†rio aprovador.         ***/
        /*** Parametros:                                                       ***/
        /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
        /***                                 para que a partir deste seja      ***/
        /***                                 poss°vel identificar o documento  ***/
        /***                                 e permitir ou n∆o o envio do      ***/
        /***                                 e-mail de pendància.              ***/
        /*************************************************************************/

        if  c-nom-prog-upc-mg97 <> "" then do:

            for each tt-epc
                where tt-epc.cod-event = "SEND-EMAIL-APROV-AUTO".
                delete tt-epc.
            end.

            /*rowid mla-doc-pend-aprov */
            {include/i-epc200.i2 &CodEvent='"SEND-EMAIL-APROV-AUTO"'
                                 &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                                 &ValueParameter="string(rowid(mla-doc-pend-aprov))"}

            {include/i-epc201.i "SEND-EMAIL-APROV-AUTO"}

            if  return-value = "NOK" then
                return "NOK".

        end.

        /*************************************************************************/
        /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
        /*************************************************************************/
		
		 CREATE tt-mla-chave. 
            ASSIGN p-chave-doc = mla-doc-pend-aprov.chave-doc.
            for each mla-chave-doc-aprov no-lock
               where mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc:
                assign i-posicao = i-posicao + 1.
                assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                                      mla-chave-doc-aprov.posicao-ini,
                                                                      (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                                      mla-chave-doc-aprov.posicao-ini))).
            END.

		

        RUN gera-mensagens. /* carrega as vari†veis com as mensagens */

        IF mla-doc-pend-aprov.cod-tip-doc = 7
        OR mla-doc-pend-aprov.cod-tip-doc = 8 THEN
           find b-mla-usuar-aprov where
                b-mla-usuar-aprov.cod-usuar = /* mla-doc-pend-aprov.cod-usuar-doc */ mla-usuar-aprov.cod-usuar
                no-lock no-error.
        ELSE
           find b-mla-usuar-aprov where
                b-mla-usuar-aprov.cod-usuar = p-usuar-destino
                no-lock no-error.

        find mla-param-aprov where
            mla-param-aprov.ep-codigo   = p-ep-codigo and
            mla-param-aprov.cod-estabel = p-cod-estabel
            no-lock no-error.

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:
            
            assign l-aprov-auto-doc = b-mla-usuar-aprov.aprova-auto.   /* Para identificar se o usuario documento Ç aprovador automatico*/

            if available mla-doc-pend-aprov then do:
                /**  E-mail de Aprovador para Aprovador
                **/
                IF mla-doc-pend-aprov.cod-usuar-alter <> "" THEN DO:
                    FIND mla-usuar-aprov WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-alter NO-LOCK NO-ERROR.
                    IF  AVAIL mla-usuar-aprov THEN
                        assign c-aprovador = mla-usuar-aprov.cod-usuar.
                END.
                ELSE DO: 
                    FIND mla-usuar-aprov WHERE mla-usuar-aprov.cod-usuar =  mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.
                    IF AVAIL mla-usuar-aprov THEN
                       assign c-aprovador = mla-usuar-aprov.cod-usuar.
                END.
                
                
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).

                if avail mla-usuar-aprov then do:
                    find first moeda
                         where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                   if l-aprov-auto-doc then
                      assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                       mla-tipo-doc-aprov.des-tip-doc,
                                                       c-chave,
                                                       moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                       c-aprovador + " - " + mla-usuar-aprov.nome-usuar + " - Aprovaá∆o Autom†tica") + CHR(10).
                   else
                      assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                       mla-tipo-doc-aprov.des-tip-doc,
                                                       c-chave,
                                                       moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                       c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10). /*teste eduardo*/
                end.

                if mla-doc-pend-aprov.cod-tip-doc = 2 
                or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                   for each it-requisicao
                       where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.
                if mla-doc-pend-aprov.cod-tip-doc = 1 
                or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                   for each it-requisicao
                       where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                       AND   it-requisicao.sequencia     = int(tt-mla-chave.valor[2]) 
                       AND   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.

                if mla-param-aprov.compl-email <> "" then 
                    assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
                
                for each tt-envio:
                    delete tt-envio.
                end.
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = c-anexo.

                if mla-usuar-aprov.e-mail <> "" then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                IF NOT l-exchange THEN 
                   ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                          tt-envio.porta    = mla-param-aprov.porta-email.
                   
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.

/*                 run utp/utapi009.p (input  table tt-envio,                                 */
/*                                     output table tt-erros).                                */
/*                                                                                            */
/*                 /**  Output do erro (e-mail)                                               */
/*                 **/                                                                        */
/*                 find first tt-envio no-error.                                              */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (01)" tt-envio.destino tt-envio.remetente} */
                                    
                /**  Envia E-mail para os Alternativos
                **/                    
                if mla-param-aprov.log-aprov-altern then do:
                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                        mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
                        assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = c-alternativo
                            no-lock no-error.
                        find first moeda
                             where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                        assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave).

                        assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave,
                                                         moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                         c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10).

                        if mla-doc-pend-aprov.cod-tip-doc = 2 
                        or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                           for each it-requisicao
                               where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.
                        if mla-doc-pend-aprov.cod-tip-doc = 1 
                        or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                           for each it-requisicao
                               where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                               AND   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                               AND   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.

                        if mla-param-aprov.compl-email <> "" then 
                            assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).

                        for each tt-envio:
                            delete tt-envio.
                        end.
                        
                        for each tt-erros:
                            delete tt-erros.
                        end.

                        create tt-envio.
                        assign tt-envio.versao-integracao = 1
                               tt-envio.exchange    = l-exchange
                               tt-envio.destino     = b-mla-usuar-aprov.e-mail
                               tt-envio.assunto     = c-ass-e-mail
                               tt-envio.mensagem    = c-men-e-mail
                               tt-envio.importancia = 2
                               tt-envio.log-enviada = no
                               tt-envio.log-lida    = no
                               tt-envio.acomp       = no
                               tt-envio.arq-anexo   = c-anexo.
                        IF mla-usuar-aprov.e-mail <> "" then
                           assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                        IF NOT l-exchange THEN 
                           ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                                  tt-envio.porta    = mla-param-aprov.porta-email.
                           
                        FOR EACH tt-erros :
                            DELETE tt-erros.
                        END.

/*                         run utp/utapi009.p (input  table tt-envio,                                 */
/*                                             output table tt-erros).                                */
/*                                                                                                    */
/*                         /**  Output do erro (e-mail)                                               */
/*                         **/                                                                        */
/*                         find first tt-envio no-error.                                              */
/*                         {lap/mlaapi001.i02 "mlaapi001.p (02)" tt-envio.destino tt-envio.remetente} */
                                            
                    END.
                END.
            END.
        END.
    end procedure.

/* fim */

PROCEDURE pi-gera-pend-faixa:
    def input parameter p-limite as decimal no-undo.
    

    RUN gera-mensagens. /* carrega as vari†veis com as mensagens */

    find mla-usuar-aprov no-lock
         where mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc no-error.
    if  mla-usuar-aprov.destino-lotacao = 1 THEN DO:
        assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        IF c-lotacao = "" THEN
            assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
    END.
    ELSE DO:
        assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "" THEN
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
    END.
 

    find mla-hierarquia-faixa no-lock 
         where mla-hierarquia-faixa.ep-codigo   = p-ep-codigo 
         and   mla-hierarquia-faixa.cod-estabel = p-cod-estabel 
         and   mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
         and   mla-hierarquia-faixa.cod-lotacao = c-lotacao 
         and   mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
         and   mla-hierarquia-faixa.seq-aprov   = mla-doc-pend-aprov.seq-aprov no-error.
    if available mla-hierarquia-faixa and
      (mla-hierarquia-faixa.log-depend = yes or (mla-hierarquia-faixa.log-depend = no  and
       p-limite < mla-doc-pend-aprov.valor-doc)) then do:
       find NEXT mla-hierarquia-faixa no-lock 
            where mla-hierarquia-faixa.ep-codigo   = p-ep-codigo 
            and   mla-hierarquia-faixa.cod-estabel = p-cod-estabel 
            and   mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
            and   mla-hierarquia-faixa.cod-lotacao = c-lotacao 
            and   mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa no-error.
       if  available mla-hierarquia-faixa then do:
           create b-mla-doc-pend-aprov.
           assign b-mla-doc-pend-aprov.ep-codigo         = mla-doc-pend-aprov.ep-codigo
                  b-mla-doc-pend-aprov.cod-estabel       = mla-doc-pend-aprov.cod-estabel
                  b-mla-doc-pend-aprov.chave-doc         = mla-doc-pend-aprov.chave-doc
                  b-mla-doc-pend-aprov.cod-lotacao-doc   = mla-doc-pend-aprov.cod-lotacao-doc
                  b-mla-doc-pend-aprov.cod-lotacao-trans = mla-doc-pend-aprov.cod-lotacao-trans
                  b-mla-doc-pend-aprov.cod-tip-aprov     = mla-doc-pend-aprov.cod-tip-aprov
                  b-mla-doc-pend-aprov.cod-tip-doc       = mla-doc-pend-aprov.cod-tip-doc
                  b-mla-doc-pend-aprov.cod-usuar         = mla-hierarquia-faixa.cod-usuar
                  b-mla-doc-pend-aprov.cod-usuar-doc     = mla-doc-pend-aprov.cod-usuar-doc
                  b-mla-doc-pend-aprov.cod-usuar-trans   = mla-doc-pend-aprov.cod-usuar-trans
                  b-mla-doc-pend-aprov.dt-geracao        = today
                  b-mla-doc-pend-aprov.ind-situacao      = 1
                  b-mla-doc-pend-aprov.ind-tip-aprov     = mla-doc-pend-aprov.ind-tip-aprov
                  b-mla-doc-pend-aprov.it-codigo         = mla-doc-pend-aprov.it-codigo
                  b-mla-doc-pend-aprov.mo-codigo         = mla-doc-pend-aprov.mo-codigo
                  b-mla-doc-pend-aprov.motivo-doc        = mla-doc-pend-aprov.motivo-doc
                  b-mla-doc-pend-aprov.num-faixa         = mla-doc-pend-aprov.num-faixa
                  b-mla-doc-pend-aprov.seq-aprov         = mla-hierarquia-faixa.seq-aprov
                  b-mla-doc-pend-aprov.valor-doc         = mla-doc-pend-aprov.valor-doc
                  b-mla-doc-pend-aprov.prioridade-aprov  = mla-doc-pend-aprov.prioridade-aprov
                  b-mla-doc-pend-aprov.hora-geracao      = string(time,"HH:MM:SS")
                  b-mla-doc-pend-aprov.cod-referencia    = mla-doc-pend-aprov.cod-referencia.

           ASSIGN l-aprovado         = NO
                  l-aprovado-auto    = NO
                  l-envia-email-auto = NO.

           /**  Para n∆o gera pendància para o pr¢ximo tipo de aprovaá∆o **/
           assign gi-prox-prior     = 990.

           FIND bb-mla-usuar-aprov WHERE
                bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar
                NO-LOCK NO-ERROR.
           /*
           ** Aprovaá∆o Autom†tica para Aprovador
           */

			assign de-valor-convert = p-valor.
			/*chamado TPOLOI - Rodrigo*/  
            /*IF AVAIL bb-mla-usuar-aprov THEN DO:            
    			find first mla-usuar-aprov
    				where mla-usuar-aprov.cod-usuar = bb-mla-usuar-aprov.cod-usuar no-lock no-error.
    			if  avail mla-usuar-aprov AND 
                    mla-usuar-aprov.mo-codigo <> p-moeda then DO:
    
    				RUN cdp/cd0812.p (INPUT  p-moeda,  	      	        /* Moeda Origem - Documento*/
    								  INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino - Aprovador*/
    								  INPUT  p-valor,       		    /* Valor Origem a converter */
    								  INPUT  TODAY,              	    /* Datas da Convers„o*/
    								  OUTPUT de-valor-convert).         /* Valor retorno convertido */
    				
    				if de-valor-convert = ? then
    					assign de-valor-convert = 0.				
    				
    			end.
            END.*/
			   
           IF AVAIL bb-mla-usuar-aprov                     AND
              bb-mla-usuar-aprov.perm-aprov                AND 
              bb-mla-usuar-aprov.aprova-auto-aprov         AND 
              mla-hierarquia-faixa.cod-usuar = p-usuar-doc AND
              de-limite-auto > de-valor-convert               THEN DO:

               assign l-aprovado         = YES
                      l-envia-email-auto = YES.

              ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio".
              
              ASSIGN mla-doc-pend-aprov.aprov-auto        = YES
                     mla-doc-pend-aprov.dt-aprova         = TODAY
                     mla-doc-pend-aprov.ind-situacao      = 2
                     mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(mla-hierarquia-faixa.cod-usuar) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica para Aprovadores".

              assign substring(mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 

              RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).

              if mla-doc-pend-aprov.ind-tip-aprov = 1 then do:
                 assign l-aprovado = no.           
                 RUN pi-gera-pend-hierarquia (de-limite-auto).
              end.
              if mla-doc-pend-aprov.ind-tip-aprov = 5 then do:
                 assign l-aprovado = no.
                 run pi-gera-pend-faixa (de-limite-auto).
              end.

              /**  Executa programa parametrizado para Aprovacao Automatica
              **/
              RUN pi-aprova-auto.

           END.
           ELSE DO:
              IF AVAILABLE mla-param-aprov AND
                 mla-param-aprov.log-email AND 
                 NOT l-aprovado-auto       THEN
                 ASSIGN l-envia-email-auto = NO.
           END.

          /* Se a pendància n∆o for aprovada automaticamente */
          IF b-mla-doc-pend-aprov.aprov-auto = NO THEN DO:

              RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(b-mla-doc-pend-aprov)).
          END.


          IF AVAILABLE mla-param-aprov AND
             mla-param-aprov.log-email AND 
             NOT l-envia-email-auto THEN  DO:

             /**  E-mail de Usu†rio para Aprovador
             **/

             FIND mla-usuar-aprov 
                  WHERE mla-usuar-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar
                  NO-LOCK NO-ERROR.

             IF  AVAILABLE mla-usuar-aprov THEN
                 ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.

             assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                              mla-tipo-doc-aprov.des-tip-doc,
                                              c-chave).

             IF mla-tipo-doc-aprov.log-html AND
                b-mla-usuar-aprov.log-html  THEN DO:
                 /**  HTML
                 **/
                 
                 for each tt-mensagem:
                     delete tt-mensagem.
                 end.

                 FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                 IF p-cod-tip-doc < 10 THEN
                 RUN VALUE("laphtml/mlahtml00" + STRING(p-cod-tip-doc) + "e.p") 
                                           (INPUT  p-cod-tip-doc,
                                            INPUT  mla-hierarquia-faixa.cod-usuar,
                                            INPUT  table tt-mla-chave,
                                            OUTPUT TABLE tt-mensagem).
                 ELSE 
                     RUN VALUE("laphtml/mlahtml0" + STRING(p-cod-tip-doc) + "e.p") 
                                                               (INPUT  p-cod-tip-doc,
                                                                INPUT  mla-hierarquia-faixa.cod-usuar,
                                                                INPUT  table tt-mla-chave,
                                                                OUTPUT TABLE tt-mensagem).
                /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serˇ enviado como anexo */
                RUN verificaTamanhoEmail.

                if l-anexar-conteudo then do:
                    ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                           c-chave-doc = replace(c-chave-doc,"/","_")
                           c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                         + "_" + c-chave-doc + "_" + STRING(TIME) + ".htm".
                    OUTPUT TO VALUE(c-arq-email).
                        FOR EACH tt-mensagem:
                            PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                    END.
                    OUTPUT CLOSE.
                end.
                
                 FOR EACH tt-envio2:
                     DELETE tt-envio2.
                 END.      

                 CREATE tt-envio2.
                 ASSIGN tt-envio2.versao-integracao = 1
                        tt-envio2.exchange    = l-exchange
                        tt-envio2.destino     = mla-usuar-aprov.e-mail
                        tt-envio2.assunto     = c-ass-e-mail
                        tt-envio2.importancia = 2
                        tt-envio2.log-enviada = NO
                        tt-envio2.log-lida    = NO
                        tt-envio2.acomp       = NO
                        tt-envio2.formato     = "HTML".

                if l-anexar-conteudo then
                    assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(10) +
                                                   "Favor verificar o arquivo atachado."
                           tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                                   ELSE c-arq-email.
                else
                    assign tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = c-anexo.

                 IF mla-usuar-aprov.e-mail <> "" THEN
                    ASSIGN tt-envio2.remetente = b-mla-usuar-aprov.e-mail.

                 IF NOT l-exchange THEN 
                     ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                            tt-envio2.porta    = mla-param-aprov.porta-email.

                 /* Html para Palm */
                 run lap/mlaapi012.p (input p-ep-codigo,   
                                       input p-cod-estabel, 
                                       input p-cod-tip-doc,
                                       input mla-hierarquia-faixa.cod-usuar,
                                       input table tt-mla-chave,
                                       output c-arquivo-anexo).

                 if  return-value = "OK" then do:
                     if  tt-envio2.arq-anexo = "" then
                         assign tt-envio2.arq-anexo = c-arquivo-anexo.
                     else 
                         assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";"
                                                    + c-arquivo-anexo.
                 end.
                 /*Fim Html para Palm*/

/*                 run utp/utapi019.p persistent set h-utapi019.               */
/*                                                                             */
/*                 FOR EACH tt-erros :                                         */
/*                     DELETE tt-erros.                                        */
/*                 END.                                                        */
/*                                                                             */
/*                 if l-anexar-conteudo then                                   */
/*                     run pi-execute  in h-utapi019 (input table tt-envio2,   */
/*                                                    output table tt-erros).  */
/*                 else                                                        */
/*                     run pi-execute2 in h-utapi019 (input table tt-envio2,   */
/*                                                    INPUT TABLE tt-mensagem, */
/*                                                    output table tt-erros).  */

                /**  Output do erro (e-mail)
/*                 **/                                                                          */
/*                 find first tt-envio2 no-error.                                               */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (07)" tt-envio2.destino tt-envio2.remetente} */
/*                                                                                              */
/*                 delete procedure h-utapi019.                                                 */
                
                if  l-anexar-conteudo then
                    os-delete value(c-arq-email).
                    
                os-delete value(c-arquivo-anexo).
                
             END.
             ELSE DO:
                 /**  Texto
                 **/
                 FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
                 FIND FIRST moeda
                     WHERE moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.
                 
                 assign c-men-e-mail = SUBSTITUTE(c-help-26593,
                                                  mla-tipo-doc-aprov.des-tip-doc,
                                                  c-chave,
                                                  moeda.sigla + " " + trim(string(p-valor,">>>,>>>,>>>,>>>,>>9.99")),
                                                  p-usuar-trans) + CHR(10).

                 
                 IF mla-param-aprov.compl-email <> "" THEN 
                     ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + TRIM(mla-param-aprov.compl-email).

                 FOR EACH tt-envio:
                     DELETE tt-envio.
                 END.
                 
                 CREATE tt-envio.
                 ASSIGN tt-envio.versao-integracao = 1
                        tt-envio.exchange    = l-exchange
                        tt-envio.destino     = mla-usuar-aprov.e-mail
                        tt-envio.assunto     = c-ass-e-mail
                        tt-envio.mensagem    = c-men-e-mail
                        tt-envio.importancia = 2
                        tt-envio.log-enviada = NO
                        tt-envio.log-lida    = NO
                        tt-envio.acomp       = NO
                        tt-envio.arq-anexo   = c-anexo.
                 
                 IF mla-usuar-aprov.e-mail <> "" THEN
                    ASSIGN tt-envio.remetente = b-mla-usuar-aprov.e-mail.

                 IF NOT l-exchange THEN 
                    ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                           tt-envio.porta    = mla-param-aprov.porta-email.


                 FOR EACH tt-erros :
                     DELETE tt-erros.
                 END.
/*                                                                                             */
/*                  RUN utp/utapi009.p (input  TABLE tt-envio,                                 */
/*                                      output TABLE tt-erros).                                */
/*                                                                                             */
/*                 /**  Output do erro (e-mail)                                                */
/*                 **/                                                                         */
/*                 find first tt-envio no-error.                                               */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (08)" tt-envio.destino tt-envio.remetente}  */
/*                                                                                             */
             END.
          END.                
       END.
    END.
END PROCEDURE.

PROCEDURE pi-gera-pend-hierarquia:
    def input parameter p-limite as decimal no-undo.
    
    RUN gera-mensagens. /* carrega as vari†veis com as mensagens */

    find mla-usuar-aprov no-lock
         where mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc no-error.

    if  mla-usuar-aprov.destino-lotacao = 1 THEN DO:
        assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        IF c-lotacao = "" THEN
            assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
    END.
    ELSE DO:
        assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "" THEN
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
    END.
    find mla-hierarquia-aprov no-lock 
         where mla-hierarquia-aprov.ep-codigo   = p-ep-codigo 
         and   mla-hierarquia-aprov.cod-estabel = p-cod-estabel 
         and   mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
         and   mla-hierarquia-aprov.cod-lotacao = c-lotacao 
         and   mla-hierarquia-aprov.seq-aprov   = mla-doc-pend-aprov.seq-aprov no-error.
    if available mla-hierarquia-aprov and
      (mla-hierarquia-aprov.log-depend = yes or (mla-hierarquia-aprov.log-depend = no  and
       p-limite < mla-doc-pend-aprov.valor-doc)) then do:
       find NEXT mla-hierarquia-aprov no-lock 
            where mla-hierarquia-aprov.ep-codigo   = p-ep-codigo 
            and   mla-hierarquia-aprov.cod-estabel = p-cod-estabel 
            and   mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
            and   mla-hierarquia-aprov.cod-lotacao = c-lotacao no-error.
       if  avail mla-hierarquia-aprov then do:
           create b-mla-doc-pend-aprov.
           assign b-mla-doc-pend-aprov.ep-codigo         = mla-doc-pend-aprov.ep-codigo
                  b-mla-doc-pend-aprov.cod-estabel       = mla-doc-pend-aprov.cod-estabel
                  b-mla-doc-pend-aprov.chave-doc         = mla-doc-pend-aprov.chave-doc
                  b-mla-doc-pend-aprov.cod-lotacao-doc   = mla-doc-pend-aprov.cod-lotacao-doc
                  b-mla-doc-pend-aprov.cod-lotacao-trans = mla-doc-pend-aprov.cod-lotacao-trans
                  b-mla-doc-pend-aprov.cod-tip-aprov     = mla-doc-pend-aprov.cod-tip-aprov
                  b-mla-doc-pend-aprov.cod-tip-doc       = mla-doc-pend-aprov.cod-tip-doc
                  b-mla-doc-pend-aprov.cod-usuar         = mla-hierarquia-aprov.cod-usuar
                  b-mla-doc-pend-aprov.cod-usuar-doc     = mla-doc-pend-aprov.cod-usuar-doc
                  b-mla-doc-pend-aprov.cod-usuar-trans   = mla-doc-pend-aprov.cod-usuar-trans
                  b-mla-doc-pend-aprov.dt-geracao        = today
                  b-mla-doc-pend-aprov.ind-situacao      = 1
                  b-mla-doc-pend-aprov.ind-tip-aprov     = mla-doc-pend-aprov.ind-tip-aprov
                  b-mla-doc-pend-aprov.it-codigo         = mla-doc-pend-aprov.it-codigo
                  b-mla-doc-pend-aprov.mo-codigo         = mla-doc-pend-aprov.mo-codigo
                  b-mla-doc-pend-aprov.motivo-doc        = mla-doc-pend-aprov.motivo-doc
                  b-mla-doc-pend-aprov.num-faixa         = mla-doc-pend-aprov.num-faixa
                  b-mla-doc-pend-aprov.seq-aprov         = mla-hierarquia-aprov.seq-aprov
                  b-mla-doc-pend-aprov.valor-doc         = mla-doc-pend-aprov.valor-doc
                  b-mla-doc-pend-aprov.prioridade-aprov  = mla-doc-pend-aprov.prioridade-aprov
                  b-mla-doc-pend-aprov.hora-geracao      = string(time,"HH:MM:SS")
                  b-mla-doc-pend-aprov.cod-referencia    = mla-doc-pend-aprov.cod-referencia.

           ASSIGN l-aprovado         = NO
                  l-aprovado-auto    = NO
                  l-envia-email-auto = NO.

           /**  Para n∆o gera pendància para o pr¢ximo tipo de aprovaá∆o **/
           assign gi-prox-prior     = 990.

           FIND bb-mla-usuar-aprov WHERE
                bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar
                NO-LOCK NO-ERROR.
           /*
           ** Aprovaá∆o Autom†tica para Aprovador
           */

		   assign de-valor-convert = p-valor.
           /*chamado TPOLOI - Rodrigo*/ 
		   /*IF AVAIL bb-mla-usuar-aprov AND bb-mla-usuar-aprov.mo-codigo <> p-moeda THEN DO:
    
    				RUN cdp/cd0812.p (INPUT  p-moeda,  	                    /* Moeda Origem - Documento*/
    								  INPUT  bb-mla-usuar-aprov.mo-codigo , /* Moeda Destino - Aprovador*/
    								  INPUT  p-valor,       	            /* Valor Origem a converter */
    								  INPUT  TODAY,                         /* Datas da Convers„o*/
    								  OUTPUT de-valor-convert).             /* Valor retorno convertido */
    				
    				if de-valor-convert = ? then
    					assign de-valor-convert = 0.				
           END.*/
		   
           IF AVAIL bb-mla-usuar-aprov                     AND
              bb-mla-usuar-aprov.perm-aprov                AND 
              bb-mla-usuar-aprov.aprova-auto-aprov         AND 
              mla-hierarquia-aprov.cod-usuar = p-usuar-doc AND
              de-limite-auto > de-valor-convert               THEN DO:

               assign l-aprovado         = YES
                      l-envia-email-auto = YES.

              /*{utp/ut-liter.i Aprovaá∆o_Autom†tica_-_Usu†rio_ * r}*/
              ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
              /*{utp/ut-liter.i _parametrizado_no_MLA0103_como_Aprovaá∆o_Autom†tica_para_Aprovadores * r}*/
              ASSIGN b-mla-doc-pend-aprov.aprov-auto        = YES
                     b-mla-doc-pend-aprov.dt-aprova         = TODAY
                     b-mla-doc-pend-aprov.ind-situacao      = 2
                     b-mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(mla-hierarquia-aprov.cod-usuar) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica para Aprovadores".

              assign substring(b-mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 

              RUN pi-envia-e-mail-aprova-auto (b-mla-doc-pend-aprov.cod-usuar-doc).

              if b-mla-doc-pend-aprov.ind-tip-aprov = 1 then do:
                 assign l-aprovado = no.           
                 RUN pi-gera-pend-hierarquia (de-limite-auto).
              end.
              if b-mla-doc-pend-aprov.ind-tip-aprov = 5 then do:
                 assign l-aprovado = no.
                 run pi-gera-pend-faixa (de-limite-auto).
              end.

              /**  Executa programa parametrizado para Aprovacao Automatica
              **/
              RUN pi-aprova-auto.
    
           END.
           ELSE DO:
              IF AVAILABLE mla-param-aprov AND
                 mla-param-aprov.log-email AND 
                 NOT l-aprovado-auto       THEN
                 ASSIGN l-envia-email-auto = NO.
           END.

           /* Se a pendància n∆o for aprovada automaticamente */
           IF b-mla-doc-pend-aprov.aprov-auto = NO THEN DO:
               RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(b-mla-doc-pend-aprov)).
           END.

           IF AVAILABLE mla-param-aprov AND
              mla-param-aprov.log-email AND
              NOT l-envia-email-auto    THEN  DO:
              
              /**  E-mail de Usu†rio para Aprovador
              **/

              FIND mla-usuar-aprov 
                   WHERE mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar
                   NO-LOCK NO-ERROR.

              IF  AVAILABLE mla-usuar-aprov THEN
                  ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.

              
              assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                               mla-tipo-doc-aprov.des-tip-doc,
                                               c-chave).

              IF mla-tipo-doc-aprov.log-html AND
                 b-mla-usuar-aprov.log-html  THEN DO:
                  /**  HTML
                  **/
                  
                  for each tt-mensagem:
                      delete tt-mensagem.
                  end.
                  
                  FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                  IF p-cod-tip-doc < 10 THEN
                  RUN VALUE("laphtml/mlahtml00" + STRING(p-cod-tip-doc) + "e.p") 
                                            (INPUT  p-cod-tip-doc,
                                             INPUT  mla-hierarquia-aprov.cod-usuar,
                                             INPUT  table tt-mla-chave,
                                             OUTPUT TABLE tt-mensagem).
                  ELSE 
                      RUN VALUE("laphtml/mlahtml0" + STRING(p-cod-tip-doc) + "e.p") 
                                                                (INPUT  p-cod-tip-doc,
                                                                 INPUT  mla-hierarquia-aprov.cod-usuar,
                                                                 INPUT  table tt-mla-chave,
                                                                 OUTPUT TABLE tt-mensagem).

                  /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serˇ enviado como anexo */
                  RUN verificaTamanhoEmail.

                  if l-anexar-conteudo then do:
                      ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                             c-chave-doc = replace(c-chave-doc,"/","_")
                             c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                           + "_" + c-chave-doc + "_" + STRING(TIME) + ".htm".

                      OUTPUT TO VALUE(c-arq-email).
                          FOR EACH tt-mensagem :
                              PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                      END.
                      OUTPUT CLOSE.
                  end.
                  

                  FOR EACH tt-envio2:
                      DELETE tt-envio2.
                  END.      

                  CREATE tt-envio2.
                  ASSIGN tt-envio2.versao-integracao = 1
                         tt-envio2.exchange    = l-exchange
                         tt-envio2.destino     = mla-usuar-aprov.e-mail
                         tt-envio2.assunto     = c-ass-e-mail
                         tt-envio2.importancia = 2
                         tt-envio2.log-enviada = NO
                         tt-envio2.log-lida    = NO
                         tt-envio2.acomp       = NO
                         tt-envio2.formato     = "HTML".

                  if l-anexar-conteudo then
                      assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(10) +
                                                     "Favor verificar o arquivo atachado."
                             tt-envio2.arq-anexo   = c-arq-email.
                  else                           
                      assign tt-envio2.mensagem    = c-men-e-mail
                             tt-envio2.arq-anexo   = "".

                  IF mla-usuar-aprov.e-mail <> "" THEN
                     ASSIGN tt-envio2.remetente = b-mla-usuar-aprov.e-mail.

                  IF NOT l-exchange THEN 
                     ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                            tt-envio2.porta    = mla-param-aprov.porta-email.
                     
                  /* Html para Palm */
                  run lap/mlaapi012.p (input p-ep-codigo,   
                                        input p-cod-estabel, 
                                        input p-cod-tip-doc,
                                        input mla-hierarquia-aprov.cod-usuar,
                                        input table tt-mla-chave,
                                        output c-arquivo-anexo).

                  if  return-value = "OK" then do:
                      if  tt-envio2.arq-anexo = "" then
                          assign tt-envio2.arq-anexo = c-arquivo-anexo.
                      else 
                          assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";"
                                                     + c-arquivo-anexo.
                  end.
                  /*Fim Html para Palm*/

                  if  tt-envio2.arq-anexo = "" then
                      assign tt-envio2.arq-anexo = c-anexo.
                  else
                      assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + "," + c-anexo.
/*                   run utp/utapi019.p persistent set h-utapi019.               */
/*                                                                               */
/*                   FOR EACH tt-erros :                                         */
/*                       DELETE tt-erros.                                        */
/*                   END.                                                        */
/*                                                                               */
/*                   if l-anexar-conteudo then                                   */
/*                       run pi-execute  in h-utapi019 (input table tt-envio2,   */
/*                                                      output table tt-erros).  */
/*                   else                                                        */
/*                       run pi-execute2 in h-utapi019 (input table tt-envio2,   */
/*                                                      INPUT TABLE tt-mensagem, */
/*                                                      output table tt-erros).  */
/*                                                                               */
                /**  Output do erro (e-mail)
                **/               
/*                 find first tt-envio2 no-error.                                               */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (09)" tt-envio2.destino tt-envio2.remetente} */
/*                                                                                              */
/*                   delete procedure h-utapi019.                                               */
/*                                                                                              */
/*                   if  l-anexar-conteudo then                                                 */
/*                       os-delete value(c-arq-email).                                          */
/*                                                                                              */
/*                   os-delete value(c-arquivo-anexo).                                          */
              END.
              ELSE DO:
                  /**  Texto
                  **/
                  FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
                  FIND FIRST moeda
                      WHERE moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.
                  
                  assign c-men-e-mail = SUBSTITUTE(c-help-26593,
                                                   mla-tipo-doc-aprov.des-tip-doc,
                                                   c-chave,
                                                   moeda.sigla + " " + trim(string(p-valor,">>>,>>>,>>>,>>>,>>9.99")),
                                                   p-usuar-trans) + CHR(10).

                  IF mla-param-aprov.compl-email <> "" THEN 
                      ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + TRIM(mla-param-aprov.compl-email).

                  FOR EACH tt-envio:
                      DELETE tt-envio.
                  END.
                  
                  CREATE tt-envio.
                  ASSIGN tt-envio.versao-integracao = 1
                         tt-envio.exchange    = l-exchange
                         tt-envio.destino     = mla-usuar-aprov.e-mail
                         tt-envio.assunto     = c-ass-e-mail
                         tt-envio.mensagem    = c-men-e-mail
                         tt-envio.importancia = 2
                         tt-envio.log-enviada = NO
                         tt-envio.log-lida    = NO
                         tt-envio.acomp       = NO
                         tt-envio.arq-anexo   = c-anexo.

                  IF mla-usuar-aprov.e-mail <> "" THEN
                     ASSIGN tt-envio.remetente = b-mla-usuar-aprov.e-mail.

                  IF NOT l-exchange THEN 
                     ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                            tt-envio.porta    = mla-param-aprov.porta-email.

                  FOR EACH tt-erros :
                      DELETE tt-erros.
                  END.

/*                   RUN utp/utapi009.p (input  TABLE tt-envio,                               */
/*                                       output TABLE tt-erros).                              */
/*                                                                                            */
/*                 /**  Output do erro (e-mail)                                               */
/*                 **/                                                                        */
/*                 find first tt-envio no-error.                                              */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (10)" tt-envio.destino tt-envio.remetente} */
                                      
              END.
           END.                
       END.
    END.
END PROCEDURE.

PROCEDURE gera-mensagens:

    /********ALTERADO PARA RODAR A UT-MSGS APENAS UMA VEZ PARA CADA MENSAGEM**********/
    IF NOT l-mensagens-geradas THEN DO:
        
        run utp/ut-msgs.p (input "msg", input 26593, input "&1" + "~~" +
                                                           "&2").
        ASSIGN c-msgs-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help", input 26593, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "msg", input 26652, input "&1" + "~~" +
                                                           "&2").
    
        ASSIGN c-msgs-26652 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help", input 26652, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26652 = RETURN-VALUE.

        ASSIGN l-mensagens-geradas = YES.

    END.

END PROCEDURE.

/* Procedures internas */
procedure pi-verifica-tipo-aprov-ref:

   find first mla-tipo-aprov-ref 
       where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
       and   mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc
       and   mla-tipo-aprov-ref.codigo           = p-referencia 
       and   mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-ref then 
       find first mla-tipo-aprov-ref 
           where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
           and   mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc 
           and   mla-tipo-aprov-ref.codigo           = p-referencia 
           and   mla-tipo-aprov-ref.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-ref then
       assign i-cod-aprov  = mla-tipo-aprov-ref.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-ref.prioridade-aprov
              l-avail-ref  = yes
              l-lim-lista  = mla-tipo-aprov-ref.log-limite
              i-tip-aprov  = 4.

end procedure.

procedure pi-verifica-tipo-aprov-item :

   find first mla-tipo-aprov-item 
       where  mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
       and    mla-tipo-aprov-item.it-codigo        = p-item 
       and    mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-item then 
       find first mla-tipo-aprov-item 
            where mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
            and   mla-tipo-aprov-item.it-codigo        = p-item 
            and   mla-tipo-aprov-item.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-item then 
       assign i-cod-aprov  = mla-tipo-aprov-item.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-item.prioridade-aprov
              l-avail-item = yes
              l-lim-lista  = mla-tipo-aprov-item.log-limite   
              i-tip-aprov   = 2.

end procedure.

procedure pi-verifica-tipo-aprov-fam:

   find first mla-tipo-aprov-fam 
       where mla-tipo-aprov-fam.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
       and mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior no-lock  no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-fam then            
       find first mla-tipo-aprov-fam 
            where mla-tipo-aprov-fam.ep-codigo        = p-ep-codigo 
            and   mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
            and   mla-tipo-aprov-fam.prioridade-aprov = 10 no-lock  no-error.

   if available mla-tipo-aprov-fam then 
       assign i-cod-aprov  = mla-tipo-aprov-fam.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-fam.prioridade-aprov
              l-avail-fam  = yes
              l-lim-lista  = mla-tipo-aprov-fam.log-limite   
              i-tip-aprov  = 3  .

end procedure.

procedure pi-verifica-tipo-aprov-doc:

   find first mla-tipo-aprov-doc 
       where mla-tipo-aprov-doc.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
       and mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-doc then
       find first mla-tipo-aprov-doc 
       where mla-tipo-aprov-doc.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
       and mla-tipo-aprov-doc.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-doc then 
       assign i-cod-aprov  = mla-tipo-aprov-doc.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-doc.prioridade-aprov
              l-avail-doc  = yes
              l-lim-lista  = mla-tipo-aprov-doc.log-limite
              i-tip-aprov  = 1.

end procedure.


procedure pi-gera-html:
    def input param p-usuar-destino as char no-undo.


    if  mla-tipo-doc-aprov.log-html and
        b-mla-usuar-aprov.log-html then do:
        
        IF b-mla-usuar-aprov.recebe-email AND b-mla-usuar-aprov.e-mail <> "" THEN DO:
            
            /**  HTML
            **/
    
            
            for each tt-mensagem:
                delete tt-mensagem.
            end.
    
            FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
    
            IF p-cod-tip-doc < 10 THEN
            RUN VALUE("laphtml/mlahtml00" + STRING(p-cod-tip-doc) + "e.p") 
                                      (input  p-cod-tip-doc,
                                       input  p-usuar-destino,
                                       input  table tt-mla-chave,
                                       output TABLE tt-mensagem).
            ELSE 
                RUN VALUE("laphtml/mlahtml0" + STRING(p-cod-tip-doc) + "e.p") 
                                                          (input  p-cod-tip-doc,
                                                           input  p-usuar-destino,
                                                           input  table tt-mla-chave,
                                                           output TABLE tt-mensagem).

            /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serˇ enviado como anexo */
            RUN verificaTamanhoEmail.
    
            IF l-anexar-conteudo then do:
               
                ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                       c-chave-doc = replace(c-chave-doc,"/","_")
                       c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                     + "_" + c-chave-doc + "_" + string(time) + ".htm".
               
                OUTPUT TO VALUE(c-arq-email).                        
               
                FOR EACH tt-mensagem:
                        PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                END.
                OUTPUT CLOSE.
            END.
    
            FOR EACH tt-envio2:
                DELETE tt-envio2.
            END.      
    
            create tt-envio2.
            assign tt-envio2.versao-integracao = 1
                   tt-envio2.exchange    = l-exchange
                   tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                   tt-envio2.assunto     = c-ass-e-mail
                   tt-envio2.importancia = 2
                   tt-envio2.log-enviada = no
                   tt-envio2.log-lida    = no
                   tt-envio2.acomp       = no
                   tt-envio2.formato     = "HTML".
    
            if l-anexar-conteudo then 
                assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(10) +
                                               "Favor verificar o arquivo atachado."
                       tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                               ELSE c-arq-email.
            else
                assign tt-envio2.mensagem    = c-men-e-mail
                       tt-envio2.arq-anexo   = c-anexo.
    
            if mla-usuar-aprov.e-mail <> "" then
               assign tt-envio2.remetente = mla-usuar-aprov.e-mail.
    
            IF NOT l-exchange THEN 
               ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                      tt-envio2.porta    = mla-param-aprov.porta-email.
    
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "mlaLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
            put skip(1).
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Envia_e-mail_Aprovador" *}
            PUT UNFORMATTED "    " + RETURN-VALUE + " "  SKIP.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Aprovador" *}
            PUT UNFORMATTED "    " + RETURN-VALUE + "                                  = " b-mla-usuar-aprov.cod-usuar    SKIP.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "E-mail" *}
            PUT UNFORMATTED "    " + RETURN-VALUE + "                                     = " b-mla-usuar-aprov.e-mail       SKIP.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Servidor" *}
            PUT UNFORMATTED "    " + RETURN-VALUE + "                                   = " mla-param-aprov.servidor-email SKIP.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Porta" *}
            PUT UNFORMATTED "    " + RETURN-VALUE + "                                      = " mla-param-aprov.porta-email    SKIP.
            output close.
    
            /* Html para Palm */
            run lap/mlaapi012.p (input p-ep-codigo,   
                                  input p-cod-estabel, 
                                  input p-cod-tip-doc,
                                  input p-usuar-destino,
                                  input table tt-mla-chave,
                                  output c-arquivo-anexo). 
            if  return-value = "OK" then do:
                if  tt-envio2.arq-anexo = "" then
                    assign tt-envio2.arq-anexo = c-arquivo-anexo.
                else 
                    assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                               + c-arquivo-anexo.
            end.
            /*Fim Html para Palm*/
    
/*             run utp/utapi019.p persistent set h-utapi019.                                 */
/*                                                                                           */
/*             for each tt-erros :                                                           */
/*                 delete tt-erros.                                                          */
/*             end.                                                                          */
/*                                                                                           */
/*             if l-anexar-conteudo then                                                     */
/*                 run pi-execute  in h-utapi019 (input table tt-envio2,                     */
/*                                                output table tt-erros).                    */
/*             else                                                                          */
/*                 run pi-execute2 in h-utapi019 (input table tt-envio2,                     */
/*                                                INPUT TABLE tt-mensagem,                   */
/*                                                output table tt-erros).                    */
/*                                                                                           */
/*             /**  Output do erro (e-mail)                                                  */
/*             **/                                                                           */
/*             find first tt-envio2 no-error.                                                */
/*             {lap/mlaapi001.i02 "mlaapi001.p (03)" tt-envio2.destino tt-envio2.remetente}  */
/*                                                                                           */
/*             delete procedure h-utapi019.                                                  */
/*                                                                                           */
/*             if  l-anexar-conteudo then                                                    */
/*                 os-delete value(c-arq-email).                                             */
/*                                                                                           */
            os-delete value(c-arquivo-anexo).
            
            /**  Envia E-mail para os Alternativos
            **/                    
        END.

        if mla-param-aprov.log-aprov-altern then do:
            

            for each  mla-usuar-aprov-altern 
                where mla-usuar-aprov-altern.cod-usuar = p-usuar-destino 
                  and mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao 
                  and mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

                
                
                find first b-mla-usuar-aprov where
                    b-mla-usuar-aprov.cod-usuar = c-alternativo
                    no-lock no-error.
                IF NOT b-mla-usuar-aprov.recebe-email OR b-mla-usuar-aprov.e-mail = "" THEN NEXT.

                for each tt-mensagem:
                    delete tt-mensagem.
                end.

                for each tt-erros:
                    delete tt-erros.
                end.

                FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                IF p-cod-tip-doc < 10 THEN
                RUN VALUE("laphtml/mlahtml00" + STRING(p-cod-tip-doc) + "e.p") 
                                          (input  p-cod-tip-doc,
                                           input  c-alternativo,
                                           input  table tt-mla-chave,
                                           output TABLE tt-mensagem).
                ELSE 
                    RUN VALUE("laphtml/mlahtml0" + STRING(p-cod-tip-doc) + "e.p") 
                                                              (input  p-cod-tip-doc,
                                                               input  c-alternativo,
                                                               input  table tt-mla-chave,
                                                               output TABLE tt-mensagem).
                /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serˇ enviado como anexo */
                RUN verificaTamanhoEmail.

                if l-anexar-conteudo then do:
                    ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                           c-chave-doc = replace(c-chave-doc,"/","_") 
                           c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                         + "_" + c-chave-doc + "_" + STRING(TIME) + ".htm".
                    OUTPUT TO VALUE(c-arq-email).
                        FOR EACH tt-mensagem :
                            PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                    END.
                    OUTPUT CLOSE.
                end.
                
                FOR EACH tt-envio2:
                    DELETE tt-envio2.
                END.      

                create tt-envio2.
                assign tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = l-exchange
                       tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio2.assunto     = c-ass-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = "HTML".
                       
                if l-anexar-conteudo then
                    assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(10) +
                                                   "Favor verificar o arquivo atachado."
                           tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                                   ELSE c-arq-email.
                else
                    assign tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = c-anexo.
                       
                if mla-usuar-aprov.e-mail <> "" then
                    assign tt-envio2.remetente = mla-usuar-aprov.e-mail.

                /* Html para Palm */
                run lap/mlaapi012.p (input p-ep-codigo,   
                                      input p-cod-estabel,  
                                      input p-cod-tip-doc,
                                      input c-alternativo,
                                      input table tt-mla-chave,
                                      output c-arquivo-anexo).

                if  return-value = "OK" then do:
                    if  tt-envio2.arq-anexo = "" then
                        assign tt-envio2.arq-anexo = c-arquivo-anexo.
                    else 
                        assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";"
                                                   + c-arquivo-anexo.
                end.
                /*Fim Html para Palm*/

/*                 run utp/utapi019.p persistent set h-utapi019.                                */
/*                                                                                              */
/*                 IF NOT l-exchange THEN                                                       */
/*                    ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email                */
/*                           tt-envio2.porta    = mla-param-aprov.porta-email.                  */
/*                                                                                              */
/*                 FOR EACH tt-erros :                                                          */
/*                     DELETE tt-erros.                                                         */
/*                 END.                                                                         */
/*                                                                                              */
/*                 if l-anexar-conteudo then                                                    */
/*                     run pi-execute  in h-utapi019 (input table tt-envio2,                    */
/*                                                    output table tt-erros).                   */
/*                 else                                                                         */
/*                     run pi-execute2 in h-utapi019 (input table tt-envio2,                    */
/*                                                    INPUT TABLE tt-mensagem,                  */
/*                                                    output table tt-erros).                   */
/*                                                                                              */
/*                 /**  Output do erro (e-mail)                                                 */
/*                 **/                                                                          */
/*                 find first tt-envio2 no-error.                                               */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (04)" tt-envio2.destino tt-envio2.remetente} */
/*                                                                                              */
/*                 delete procedure h-utapi019.                                                 */
/*                                                                                              */
/*                 if  l-anexar-conteudo then                                                   */
/*                     os-delete value(c-arq-email).                                            */
/*                                                                                              */
/*                 os-delete value(c-arquivo-anexo).                                            */
            end.
        end.                    
    end.
    else do:
        /**  Texto
        **/
        FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
        FIND FIRST moeda
             WHERE moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.
        
		assign c-men-e-mail = SUBSTITUTE(c-help-26593,
                                         mla-tipo-doc-aprov.des-tip-doc,
                                         c-chave,
                                         moeda.sigla + " " + trim(string(p-valor,">>>,>>>,>>>,>>>,>>9.99")),
                                         p-usuar-trans) + CHR(10).

        
        if mla-param-aprov.compl-email <> "" then 
            assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
        
        for each tt-envio:
            delete tt-envio.
        end.
        
        create tt-envio.
        assign tt-envio.versao-integracao = 1
               tt-envio.exchange    = l-exchange
               tt-envio.destino     = b-mla-usuar-aprov.e-mail
               tt-envio.assunto     = c-ass-e-mail
               tt-envio.mensagem    = c-men-e-mail
               tt-envio.importancia = 2
               tt-envio.log-enviada = no
               tt-envio.log-lida    = no
               tt-envio.acomp       = no
               tt-envio.arq-anexo   = c-anexo.
        IF mla-usuar-aprov.e-mail <> "" then
           assign tt-envio.remetente = mla-usuar-aprov.e-mail.

        IF NOT l-exchange THEN 
           ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                  tt-envio.porta    = mla-param-aprov.porta-email.
           
        FOR EACH tt-erros :
            DELETE tt-erros.
        END.
/*         run utp/utapi009.p (input  table tt-envio,                                 */
/*                             output table tt-erros).                                */
/*                                                                                    */
/*         /**  Output do erro (e-mail)                                               */
/*         **/                                                                        */
/*         find first tt-envio no-error.                                              */
/*         {lap/mlaapi001.i02 "mlaapi001.p (05)" tt-envio.destino tt-envio.remetente} */
                            
        /**  Envia E-mail para os Alternativos
        **/                    
        if mla-param-aprov.log-aprov-altern then do:
            for each mla-usuar-aprov-altern where
                mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
                assign c-alternativo = mla-usuar-aprov-altern.cod-usuar-altern.

                find b-mla-usuar-aprov where
                     b-mla-usuar-aprov.cod-usuar = c-alternativo
                     no-lock no-error.

                for each tt-envio:
                    delete tt-envio.
                end.
                for each tt-erros:
                    delete tt-erros.
                end.
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = c-anexo.

                IF mla-usuar-aprov.e-mail <> "" then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                IF NOT l-exchange THEN 
                   ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                          tt-envio.porta    = mla-param-aprov.porta-email.
                   
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.

/*                 run utp/utapi009.p (input  table tt-envio,                                  */
/*                                     output table tt-erros).                                 */
/*                                                                                             */
/*                 /**  Output do erro (e-mail)                                                */
/*                 **/                                                                         */
/*                 find first tt-envio no-error.                                               */
/*                 {lap/mlaapi001.i02 "mlaapi001.p (06)" tt-envio.destino tt-envio.remetente}  */

            end.                    
        end.
    end.

end procedure.
/** FIM **/

/**  Programa parametrizado para Aprovacao Automatica
***
***  Inicialmente, funcionarˇ apenas para o tipo de documento 21 (Aprovacao do Credito do Pedido de Vendas)
***  Apos, terˇ que funcionar com qualquer outro tipo de documento, principalmente solicitacao/requisicao e cotacao  
**/
PROCEDURE pi-aprova-auto.

    IF  p-cod-tip-doc = 21 THEN DO:

        RUN lap/mlaapi002.p (INPUT 21,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro 
            NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:

            RUN lapepc/mla021e.p (INPUT ROWID(mla-doc-pend-aprov),
                                  INPUT mla-doc-pend-aprov.cod-usuar,
                                  INPUT NO).
        END.
    END.

END PROCEDURE.

PROCEDURE pi-valida-docto:
/*------------------------------------------------------------------------------
  Purpose: Procedure para verificaÁ„o de encerramento correto da pendencia dos 
			documentos gerados.     
  Parameters:  output: p-proces-compl /*Parametro de indicaÁ„o de processo
						completo ou n„o.*/
  Notes:       
------------------------------------------------------------------------------*/


    DEF OUTPUT PARAM p-proces-compl AS LOG NO-UNDO.

    IF p-cod-tip-doc = 7 /* Pedido Normal Total */       OR 
       p-cod-tip-doc = 8 /* Pedido EmergÍncial Total */  THEN DO:

        FIND FIRST pedido-compr NO-LOCK
             WHERE pedido-compr.num-pedido = INT(SUBSTRING(c-chave,1,8)) NO-ERROR.

        IF  AVAIL pedido-compr 
        AND SUBSTRING(pedido-compr.char-1,58,1) = "S":U THEN
            ASSIGN p-proces-compl = YES.
        ELSE
            ASSIGN p-proces-compl = NO.
    END.
    ELSE DO:
        IF p-cod-tip-doc = 2 /* SolicitaÁ„o de Compra Total */ THEN DO:
            FIND FIRST requisicao NO-LOCK
                 WHERE requisicao.nr-requisicao = INT(SUBSTRING(c-chave,1,9)) NO-ERROR.
            IF AVAIL requisicao AND ( SUBSTRING(requisicao.char-1,1,1) = "S":U  OR
                                      SUBSTRING(requisicao.char-1,1,1) = "":U ) THEN
                ASSIGN p-proces-compl = YES.
            ELSE
                ASSIGN p-proces-compl = NO.
        END.
        ELSE DO:
            IF p-cod-tip-doc = 4 /* RequisiÁ„o de Estoque Total */ THEN DO:
                FIND FIRST requisicao NO-LOCK
                     WHERE requisicao.nr-requisicao = INT(SUBSTRING(c-chave,1,9)) NO-ERROR.
                IF AVAIL requisicao AND ( SUBSTRING(requisicao.char-1,1,1) = "S":U OR
                                          SUBSTRING(requisicao.char-1,1,1) = "":U) THEN
                    ASSIGN p-proces-compl = YES.
                ELSE
                    ASSIGN p-proces-compl = NO.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-verifica-priorid-aprovacao:
    /*
    ** Grava na tabela mla-doc-pend-aprov a prioridade do documento de acordo com o que 
    ** o usuario seleciona na prioridade para aprovacao: muito alta, alta, media, baixa
    */

    /*Inicio Melhorias MLA IRM001425 Item 4*/
    FOR FIRST item-mat FIELDS(prioridade-aprov)
        WHERE item-mat.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK:
    END.

    CASE mla-doc-pend-aprov.cod-tip-doc:
        WHEN 1  OR /*solicitacao de compras por item*/
        WHEN 3  OR /*requisicao de estoque por item */
        WHEN 18 THEN DO: /*solicitacao de cotacao por item*/
            FIND FIRST it-requisicao 
                 WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,9)) 
                   AND it-requisicao.sequencia     = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,10,3)) 
                   AND it-requisicao.it-codigo     = SUBSTRING(mla-doc-pend-aprov.chave-doc,13,15)   NO-LOCK NO-ERROR.
            IF AVAIL it-requisicao THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = it-requisicao.prioridade-aprov.
            ELSE
                IF AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
                ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.

        END.
        WHEN 5 THEN DO: /* cotacao de materiais*/
            FIND FIRST cotacao-item no-lock
                 WHERE cotacao-item.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND cotacao-item.cod-emitente = int(substring(mla-doc-pend-aprov.chave-doc,9,8))
                   AND cotacao-item.it-codigo    = substring(mla-doc-pend-aprov.chave-doc,18,15)
                   AND cotacao-item.seq-cotac    = int(substring(mla-doc-pend-aprov.chave-doc,34,3)) NO-ERROR.
            IF AVAIL cotacao-item THEN DO:
                FIND FIRST ordem-compra
                     WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK NO-ERROR.
                IF  AVAIL ordem-compra THEN
                    ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
                   ELSE
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
            END.

        END.
        WHEN 6  OR /*pedido de compra por item*/
        WHEN 19 THEN DO: /*pedido emergencial por item*/
            FIND FIRST ordem-compra
                 WHERE ordem-compra.num-pedido   = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8)) 
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,9,16)) NO-LOCK NO-ERROR.
            IF  AVAIL ordem-compra THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
               ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        END.
        WHEN 9 THEN DO: /*processo de compras por item*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.nr-processo  = int(substring(mla-doc-pend-aprov.chave-doc,1,6))
                   AND ordem-compra.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,7,8)) NO-ERROR.
            IF  AVAIL ordem-compra THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
               ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        END.
        WHEN 11 THEN DO: /*contrato de compras por item*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.nr-contrato  = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8))
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,9,8)) NO-ERROR.
            IF AVAIL ordem-compra THEN 
                 ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
        END.
        WHEN 14 THEN DO: /*medicao contrato*/
            FIND FIRST medicao-contrat no-lock
                 WHERE medicao-contrat.nr-contrato     = int(substring(mla-doc-pend-aprov.chave-doc,1,9))
                   AND medicao-contrat.num-seq-item    = int(substring(mla-doc-pend-aprov.chave-doc,9,4))
                   AND medicao-contrat.numero-ordem    = int(substring(mla-doc-pend-aprov.chave-doc,14,8))
                   AND medicao-contrat.num-seq-event   = int(substring(mla-doc-pend-aprov.chave-doc,22,4))
                   AND medicao-contrat.num-seq-medicao = int(substring(mla-doc-pend-aprov.chave-doc,26,4)) NO-ERROR.
            IF AVAIL medicao-contrat THEN DO:
                FIND FIRST ordem-compra
                    WHERE ordem-compra.numero-ordem = medicao-contrat.numero-ordem NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN 
                     ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
            END.
        END.
        WHEN 16 THEN DO: /*evento do contrato*/
            FIND FIRST evento-ped no-lock
                 WHERE evento-ped.numero-ordem  = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND evento-ped.dt-evento     = date(substring(mla-doc-pend-aprov.chave-doc,9,9))
                   AND evento-ped.seq-evento    = int(substring(mla-doc-pend-aprov.chave-doc,19,2)) NO-ERROR.
            IF AVAIL evento-ped THEN DO:
                FIND FIRST ordem-compra
                    WHERE ordem-compra.numero-ordem = evento-ped.numero-ordem NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN 
                     ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
            END.
        END.
        OTHERWISE /*documentos por total recebem prioridade zero*/
            ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        /*Fim Melhorias MLA IRM001425 Item 4*/

    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-cond-pagto:
    /*
    ** Retorna a condicao de pagamento no documento que sera gerada a pendencia
    ** para comparacao se houve alteracao na condicao de pagamento.
    ** Se o parametro para geracao da pendencia considerar somente alteracao
    ** de valor ou de condicao de pagamento (MLA0000) gera pendencia
    */

    DEFINE OUTPUT PARAMETER pi-cond-pagto-nova LIKE cond-pagto.cod-cond-pag NO-UNDO.

    CASE mla-doc-pend-aprov.cod-tip-doc:

        WHEN 5 /*Cotaá∆o de materiais*/ THEN DO:
            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND cotacao-item.cod-emitente = int(substring(mla-doc-pend-aprov.chave-doc,9,8))
                   AND cotacao-item.it-codigo    = substring(mla-doc-pend-aprov.chave-doc,18,15)
                   AND cotacao-item.seq-cotac    = int(substring(mla-doc-pend-aprov.chave-doc,34,3)) NO-ERROR.
            IF AVAIL cotacao-item THEN DO:
                ASSIGN pi-cond-pagto-nova        = cotacao-item.cod-cond-pag.
            END.
        END.
        WHEN 6 /*Pedido de compra - item*/    OR
        WHEN 7 /*Pedido de compra - total*/   OR
        WHEN 8 /*Pedido emergencial - total*/ OR
        WHEN 19 /*Pedido emergencial - item*/ THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8)) NO-ERROR.
            IF AVAIL pedido-compr THEN
        	    ASSIGN pi-cond-pagto-nova = pedido-compr.cod-cond-pag.
        END.
        WHEN 13 /*Contrato de compras*/ OR
        WHEN 14 /*Medicao - item*/      THEN DO:
            FIND FIRST contrato-for NO-LOCK
                 WHERE contrato-for.nr-contrato = int(substring(mla-doc-pend-aprov.chave-doc,1,9)) NO-ERROR.
            IF AVAIL contrato-for THEN
        	    ASSIGN pi-cond-pagto-nova = contrato-for.cod-cond-pag.
        END.
        WHEN 16 THEN DO: /*Evento do Contrato*/
            FIND FIRST evento-ped NO-LOCK
                 WHERE evento-ped.numero-ordem  = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND evento-ped.dt-evento     = date(substring(mla-doc-pend-aprov.chave-doc,9,9))
                   AND evento-ped.seq-evento    = int(substring(mla-doc-pend-aprov.chave-doc,19,2)) NO-ERROR.
            IF AVAIL evento-ped THEN DO:
                FIND FIRST contrato-for NO-LOCK 
                     WHERE contrato-for.nr-contrato = evento-ped.nr-contrato NO-ERROR.
                IF AVAIL contrato-for THEN
                    ASSIGN pi-cond-pagto-nova = contrato-for.cod-cond-pag.
            END.
        END.
        WHEN 21 /* Avaliaá∆o de Credito (Ped.Venda) */ then do:
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedido = int(substring(mla-doc-pend-aprov.chave-doc,1,11)) NO-ERROR.
            IF AVAIL ped-venda THEN
        	    ASSIGN pi-cond-pagto-nova = ped-venda.cod-cond-pag.
        END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-elimina-documentos-pendentes:

    FOR EACH mla-doc-pend-aprov 
       WHERE mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   
         AND mla-doc-pend-aprov.cod-estabel  = p-cod-estabel 
         AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
         AND mla-doc-pend-aprov.chave-doc    = c-chave       
         AND mla-doc-pend-aprov.historico    = NO EXCLUSIVE-LOCK:

        RUN pi-chama-epc-eliminacao.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-elimina-documentos-pendentes AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Elimina_documentos_pendentes" *}
        ASSIGN c-lbl-liter-elimina-documentos-pendentes = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-modificacao-2-eliminacao-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Modificacao_(2)_/_Eliminacao_(3)" *}
        ASSIGN c-lbl-liter-modificacao-2-eliminacao-3 = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-empresa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Empresa" *}
        ASSIGN c-lbl-liter-empresa = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Documento" *}
        ASSIGN c-lbl-liter-documento = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-chave AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Chave" *}
        ASSIGN c-lbl-liter-chave = RETURN-VALUE.
        DEFINE VARIABLE c-lbl-liter-historico AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "#_Historico" *}
        ASSIGN c-lbl-liter-historico = RETURN-VALUE.
        put unformatted skip
                        c-lbl-liter-elimina-documentos-pendentes + ".     " skip
                        c-lbl-liter-modificacao-2-eliminacao-3 + "             = " p-tipo-trans                   skip
                        c-lbl-liter-empresa + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                        c-lbl-liter-estabelecimento + "                              = " mla-doc-pend-aprov.cod-estabel skip
                        c-lbl-liter-documento + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                        c-lbl-liter-chave + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                        c-lbl-liter-historico + "                                    = " mla-doc-pend-aprov.historico   skip.     
        FOR EACH tt-erro:
            PUT UNFORMATTED tt-erro.mensagem.
        END.
        output close.
        delete mla-doc-pend-aprov.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-verifica-sit-ordem:
    /*
    ** Verifica situacao da ordem do documento que esta sofrendo aprovacao eletronica
    ** para que se o parametro de gerar ou nao gerar pendencia para saldos zerados:
    ** Ordem Confirmada e/ou Ordem Recebida
    */

    DEFINE INPUT PARAMETER pi-cod-tip-doc LIKE mla-doc-pend-aprov.cod-tip-doc NO-UNDO.

    CASE pi-cod-tip-doc:
        WHEN 6  OR       /*pedido de compra por item*/
        WHEN 19 THEN DO: /*pedido emergencial por item*/
            FIND FIRST ordem-compra
                 WHERE ordem-compra.num-pedido   = INT(SUBSTRING(c-chave,1,8)) 
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(c-chave,9,16)) NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                IF p-valor = 0 THEN DO:
                    /*nao gerar pendencia para saldo zerado, ordens confirmadas e recebidas*/
                    IF (mla-param-aprov.log-ord-confda AND ordem-compra.situacao = 2)
                    OR (mla-param-aprov.log-ord-recbda AND ordem-compra.situacao = 6) THEN
                        RETURN "NOK":U.
                END.
                ELSE
                    RETURN "OK":U.
                
            END.
        END.
        WHEN 7  OR       /* pedido de compra - total*/
        WHEN 8  THEN DO: /* pedido emergencial - total*/    
            FIND FIRST pedido-compr
                 WHERE pedido-compr.num-pedido = INT(SUBSTRING(c-chave,1,8)) NO-LOCK NO-ERROR.
            IF AVAIL pedido-compr THEN DO:
                IF p-valor = 0 THEN DO:
                    IF CAN-FIND(FIRST ordem-compra
                                WHERE ordem-compra.num-pedido  = pedido-compr.num-pedido
                                  AND ( (ordem-compra.situacao = 2 AND mla-param-aprov.log-ord-confda) /*Confirmada*/
                                    OR  (ordem-compra.situacao = 6 AND mla-param-aprov.log-ord-recbda)))   /*Recebida*/ THEN DO:
                        RETURN "NOK":U.
                    END.
                END.
            END.

        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-chama-epc-eliminacao:
/*------------------------------------------------------------------------------
  Purpose: Chamada EPC para eliminaá∆o de documento    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*************************************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: Grendene                            ***/
    /*************************************************************************/
    /*** Prop¢sito: Identificar os pontos de eliminaá∆o de pendància       ***/
    /*************************************************************************/
    
    if  c-nom-prog-upc-mg97 <> "" then do:    
        for each tt-epc
            where tt-epc.cod-event = "elimina-pendencia-doc".
            delete tt-epc.
        end.
    
        /*rowid da tabela mla-doc-pend-aprov*/
        {include/i-epc200.i2 &CodEvent='"elimina-pendencia-doc"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc200.i2 &CodEvent='"elimina-pendencia-doc"'
                             &CodParameter='"p-tipo-trans"'
                             &ValueParameter="string(p-tipo-trans)"}
                             
        {include/i-epc201.i "elimina-pendencia-doc"}
    END.
    /*************************************************************************/
    /*** FIM CHAMADA EPC - Grendene                                        ***/
    /*************************************************************************/ 

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-chama-epc-geracao-pendencia:
/*------------------------------------------------------------------------------
  Purpose: Chamada EPC para indicar geraá∆o de pendància
  Parameters: r-rowid: Rowid da tabela 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowid AS ROWID NO-UNDO.

    /*************************************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: Grendene                            ***/
    /*************************************************************************/
    /*** Prop¢sito: Identificar os pontos onde s∆o geradas pendàncias que  ***/
    /***            ainda depender∆o de aprovaá∆o, ou seja, n∆o aprovadas  ***/
    /***            automaticamente                                        ***/
    /*************************************************************************/
    
    if  c-nom-prog-upc-mg97 <> "" then do:    
        for each tt-epc
            where tt-epc.cod-event = "aprovacao-pendente".
            delete tt-epc.
        end.

        /*rowid da tabela mla-doc-pend-aprov*/
        {include/i-epc200.i2 &CodEvent='"aprovacao-pendente"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(r-rowid)"}
                             
        {include/i-epc201.i "aprovacao-pendente"}
    END.
    /*************************************************************************/
    /*** FIM CHAMADA EPC - Grendene                                        ***/
    /*************************************************************************/

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE verificaTamanhoEmail:
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT mla-param-aprov.log-atachado  THEN DO:
        FOR EACH tt-mensagem:
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-mensagem.mensagem).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.
    ELSE DO:
        ASSIGN l-anexar-conteudo = mla-param-aprov.log-atachado.
    END.

    RETURN "OK":U.
END PROCEDURE.



