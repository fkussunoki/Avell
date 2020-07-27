
    
/* /* include de controle de vers„o */                             */
/* {include/i-prgvrs.i escc0300 1.00.00.003}                       */
/* /* definiå„o das temp-tables para recebimento de par?metros */  */


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD coluna-inicial   AS INTEGER
    FIELD linha-inicial    AS INTEGER
    FIELD dir-arquivo      AS CHAR
    FIELD cod-estab        AS char.


def var h-boin082sd   as handle no-undo.
def var h-boin082ca   as handle no-undo.
def var h-boin295desc as handle no-undo.

DEFINE VARIABLE r-rw-pedido  AS ROWID NO-UNDO.


DEF VAR l-funcao-mla-ativa    AS LOG NO-UNDO INITIAL NO.

DEFINE BUFFER bf-emitente     FOR emitente.
DEFINE BUFFER bf-estabelec    FOR estabelec.
DEFINE BUFFER bf3-oc          FOR ordem-compra.


DEFINE TEMP-TABLE tt-pedido-compra LIKE pedido-compr.
DEFINE TEMP-TABLE tt-ordem-compra  LIKE ordem-compra.
DEFINE TEMP-TABLE tt-prazo-compra  LIKE prazo-compra.  
DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item
       FIELD r-Rowid AS ROWID.

DEF VAR h-prog AS HANDLE.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

def temp-table tt-raw-digita                 
        field raw-digita    as raw.          
/* recebimento de par?metros */              
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita. 
create tt-param.                             
RAW-TRANSFER raw-param to tt-param.          


CREATE tt-param.
ASSIGN tt-param.coluna-inicial = 8
       tt-param.linha-inicial  = 11
       tt-param.dir-arquivo    = "c:\desenv\recife-dez1.xlsx"
       tt-param.cod-estab      = "mtz".


DEFINE TEMP-TABLE tt-dados
    FIELD versao-integracao AS INTEGER FORMAT "999"   
    FIELD arquivo           AS CHAR    FORMAT 'x(40)' 
    FIELD planilha          AS INTEGER FORMAT ">>"    
    FIELD celula-linha      AS INTEGER FORMAT ">>>"   
    FIELD celula-coluna     AS INTEGER FORMAT ">>>"   
    FIELD valor             AS CHAR    FORMAT "x(20)" 
    FIELD formula-local     AS CHAR    FORMAT "x(20)" 
    FIELD formula           AS CHAR    FORMAT "x(20)" .


DEFINE TEMP-TABLE tt-erros
    FIELD codigo-erro AS INTEGER 
    FIELD descricao   AS CHAR.


DEFINE TEMP-TABLE tt-erro
    FIELD it-codigo   AS CHARACTER
    FIELD descricao   AS char.


DEFINE TEMP-TABLE tt-tratamento
    FIELD ttv-condicao    AS INTEGER
    FIELD ttv-it-codigo   AS CHAR
    FIELD ttv-quantidade  AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv-dt-entrega  AS DATE
    FIELD ttv-preco       AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv-deposito    AS CHAR
    FIELD ttv-un          AS CHARACTER
    FIELD ttv-linha       AS INTEGER
    FIELD ttv-coluna      AS INTEGER
    FIELD ttv-num-pedido  AS INTEGER
    .


DEFINE BUFFER bf-pedido-compr FOR pedido-compr.
DEFINE BUFFER bf-ordem-compra FOR ordem-compra.

DEFINE VAR m-linha                              AS INTEGER.
DEFINE VAR i-colun                              AS INTEGER.
DEFINE VAR c-un                                 AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR v_cod_usuar_corren AS char NO-UNDO.

DEF VAR i-col-ini                               AS INTEGER.
DEF VAR i-col-fim                               AS INTEGER.
DEF VAR i-teste                                 AS INTEGER.

FUNCTION fncProxNumPedido RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

FUNCTION fncProxNumOrdem RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.


DEF VAR separador AS CHAR.
DEF VAR vlr-decimal AS CHAR.

ASSIGN separador = ","
       vlr-decimal = ".".

FIND FIRST tt-param NO-ERROR.
ASSIGN m-linha = tt-param.linha-inicial.

ASSIGN i-col-ini = int(tt-param.coluna-inicial)
       i-col-fim = int(tt-param.coluna-inicial) + 6.

RUN pi-inicializar IN h-prog(INPUT "TT-dados").

  REPEAT ON ENDKEY UNDO, RETRY:

      ASSIGN m-linha = m-linha + 1.


DO i-colun = i-col-ini TO i-col-fim:

RUN pi-acompanhar IN h-prog (INPUT "Linha " + string(m-linha) + " Coluna " + string(i-colun)).

CREATE tt-dados.
ASSIGN tt-dados.versao-integracao = 1
       tt-dados.arquivo = tt-param.dir-arquivo 
       tt-dados.planilha = 1
       tt-dados.celula-linha = m-linha
       tt-dados.celula-coluna = i-colun.
END.


    run utp/utapi006.p (input-output table tt-dados,
                             output table tt-erros).
                             
    find       tt-dados 
         where tt-dados.arquivo       = tt-param.dir-arquivo
         and   tt-dados.planilha      = 1
         and   tt-dados.celula-coluna = 8 
         and   tt-dados.celula-linha  = m-linha.
    
    if return-value = "NOK" or 
       tt-dados.valor = "" then do:
       leave.
    end.   
 
  END. /*fim do repeat*/

RUN pi-inicializar IN h-prog (INPUT "TT-tratamento").


FOR EACH tt-dados WHERE tt-dados.valor <> "" BREAK BY tt-dados.celula-linha:
RUN pi-acompanhar IN h-prog (INPUT string(tt-dados.celula-linha) + " Dados " + tt-dados.formula).

    IF FIRST-OF(tt-dados.celula-linha) THEN DO:
        CREATE tt-tratamento.
        ASSIGN tt-tratamento.ttv-linha = tt-dados.celula-linha
               tt-tratamento.ttv-coluna = tt-param.coluna-inicial.
    END.

        CASE tt-dados.celula-coluna:

            WHEN 8 THEN  DO:
                ASSIGN tt-tratamento.ttv-condicao          = INT(entry(1,trim(tt-dados.valor),"A")).

            END.

            WHEN 9 THEN DO:

                FIND FIRST ITEM WHERE ITEM.it-codigo    = trim(replace(replace(tt-dados.valor, " PL14", ""), " ", "-")) NO-ERROR.

                IF AVAIL ITEM THEN DO:
                    ASSIGN tt-tratamento.ttv-it-codigo  = ITEM.it-codigo
                           tt-tratamento.ttv-deposito   = item.deposito-pad
                           tt-tratamento.ttv-un         = ITEM.un.

                END.

                ELSE DO:
                    ASSIGN tt-tratamento.ttv-it-codigo  = ""
                           tt-tratamento.ttv-deposito   = ""
                           tt-tratamento.ttv-un         = "".
                END.
            END.

            WHEN 11 THEN DO:

                ASSIGN tt-tratamento.ttv-quantidade        = DEC(tt-dados.formula-local).


            END.

            WHEN 12 THEN DO:


                ASSIGN tt-tratamento.ttv-dt-entrega        = date(tt-dados.valor).

            END.

             WHEN 13 THEN DO:

                ASSIGN tt-tratamento.ttv-preco             = DEC(tt-dados.formula-local).


             END.
        END.
END.
RUN pi-finalizar IN h-prog.

    RUN pi-inicializar-bos.


    FIND FIRST param-aprov  NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
         AND   funcao.ativo NO-ERROR.

    ASSIGN l-funcao-mla-ativa = IF AVAIL funcao THEN YES ELSE NO.


FOR EACH tt-tratamento WHERE tt-tratamento.ttv-it-codigo <> "":

find first item no-lock where item.it-codigo = tt-tratamento.ttv-it-codigo no-error.

    if avail item then do:

        CREATE pedido-compr.
        ASSIGN pedido-compr.num-pedido       = fncProxNumPedido()
               pedido-compr.cod-cond-pag     =  tt-tratamento.ttv-condicao
               pedido-compr.data-pedido      =  TODAY
               pedido-compr.situacao         =  1
               pedido-compr.cod-emitente     =  35
               pedido-compr.end-entrega      = tt-param.cod-estab
               pedido-compr.end-cobranca     = tt-param.cod-estab
               pedido-compr.frete            = 1
               pedido-compr.responsavel      = v_cod_usuar_corren
               pedido-compr.comentarios      = "Pedido Automatico - Excel"
               pedido-compr.emergencial      = YES
               pedido-compr.cod-estabel      = tt-param.cod-estab
               pedido-compr.cod-estab-gestor = ""
               pedido-compr.cod-transp       = 1
               pedido-compr.cod-mensagem     = 301.
    
        IF l-funcao-mla-ativa THEN ASSIGN OVERLAY(pedido-compr.char-1,58,1) = "S":U.
    
    
        ASSIGN tt-tratamento.ttv-num-pedido = pedido-compr.num-pedido .
    
        CREATE ordem-compra.
        ASSIGN ordem-compra.numero-ordem         = fncProxNumOrdem()
               ordem-compra.it-codigo            = tt-tratamento.ttv-it-codigo
               ordem-compra.situacao             = 2
               ordem-compra.data-emissao         = TODAY
               ordem-compra.requisitante         = v_cod_usuar_corren
               ordem-compra.dep-almoxar          = tt-tratamento.ttv-deposito
               ordem-compra.cod-comprado         = v_cod_usuar_corren
               ordem-compra.num-pedido           = pedido-compr.num-pedido
               ordem-compra.data-pedido          = pedido-compr.data-pedido
               ordem-compra.cod-emitente         = pedido-compr.cod-emitente
               ordem-compra.cod-cond-pag         = pedido-compr.cod-cond-pag
               ordem-compra.comentarios          = "Pedido Automatico Excel"
               ordem-compra.usuario              = v_cod_usuar_corren
               ordem-compra.data-atualiz         = TODAY
               ordem-compra.hora-atualiz         = STRING(TIME,'HH:MM:SS')
               ordem-compra.cod-estabel          = tt-param.cod-estab
               ordem-compra.tp-despesa           = 101
               ordem-compra.cod-estab-gestor     = pedido-compr.cod-estab-gestor
               ordem-compra.codigo-icm           = 2
               ordem-compra.cod-unid-negoc       = "ETE"
               ordem-compra.qt-solic             = tt-tratamento.ttv-quantidade
               ordem-compra.preco-orig           = tt-tratamento.ttv-preco 
               ordem-compra.preco-unit           = tt-tratamento.ttv-preco 
               ordem-compra.pre-unit-for         = tt-tratamento.ttv-preco 
               ordem-compra.preco-fornec         = tt-tratamento.ttv-preco .
    
    
           CREATE prazo-compra.
           ASSIGN prazo-compra.numero-ordem         = ordem-compra.numero-ordem
                  prazo-compra.parcela              = 1
                  prazo-compra.it-codigo            = ordem-compra.it-codigo
                  prazo-compra.un                   = tt-tratamento.ttv-un
                  prazo-compra.quantid-orig         = tt-tratamento.ttv-quantidade
                  prazo-compra.quantidade           = tt-tratamento.ttv-quantidade
                  prazo-compra.quant-saldo          = tt-tratamento.ttv-quantidade
                  prazo-compra.qtd-do-forn          = tt-tratamento.ttv-quantidade
                  prazo-compra.qtd-sal-forn         = tt-tratamento.ttv-quantidade
                  prazo-compra.nome-abrev           = ''
                  prazo-compra.pedido-clien         = ''
                  prazo-compra.data-orig            = TODAY
                  prazo-compra.situacao             = 2
                  prazo-compra.data-entrega         = tt-tratamento.ttv-dt-entrega.
                   
    
    
    
                EMPTY TEMP-TABLE tt-cotacao-item.
    
                /* */
    
                RUN pi-seta-defaults-cotacao.
                /* */
    
                FIND FIRST tt-cotacao-item NO-LOCK NO-ERROR.
    
                IF AVAIL tt-cotacao-item THEN DO:
    
                    FIND CURRENT tt-cotacao-item EXCLUSIVE-LOCK NO-ERROR.
    
                    ASSIGN tt-cotacao-item.un           = prazo-compra.un
                           tt-cotacao-item.preco-unit   = ordem-compra.preco-unit
                           tt-cotacao-item.pre-unit-for = ordem-compra.pre-unit-for
                           tt-cotacao-item.preco-fornec = ordem-compra.preco-fornec
                           tt-cotacao-item.cod-cond-pag = ordem-compra.cod-cond-pag
                           tt-cotacao-item.cod-comprado = ordem-compra.cod-comprado
                           /* tt-cotacao-item.codigo-icm   = 2  /* ndustrializacao */ */
                           tt-cotacao-item.cot-aprovada = YES
                           tt-cotacao-item.data-atualiz = TODAY
                           tt-cotacao-item.hora-atualiz = STRING(TIME,'HH:MM:SS').
    
                    ASSIGN ordem-compra.codigo-ipi   = tt-cotacao-item.codigo-ipi
                           ordem-compra.aliquota-ipi = tt-cotacao-item.aliquota-ipi.
    
                    /* */
                    /* */
                    
    
                    FIND FIRST tt-cotacao-item NO-LOCK NO-ERROR.
    
    
                    CREATE cotacao-item.
                    BUFFER-COPY tt-cotacao-item TO cotacao-item.
                    
                    /* cria relaá∆o item x fornec ****************************************************/
    
                    FIND FIRST bf-emitente where 
                        bf-emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        
                    FIND FIRST item-fornec where 
                        item-fornec.it-codigo    = item.it-codigo           AND 
                        item-fornec.cod-emitente = bf-emitente.cod-emitente NO-LOCK NO-ERROR.
                    
                    if not available item-fornec and 
                       item.tipo-contr <> 4      and
                       item.it-codigo  <> ""     then do:
        
                        CREATE item-fornec.
                        ASSIGN item-fornec.it-codigo    = item.it-codigo
                               item-fornec.cod-emitente = bf-emitente.cod-emitente
                               item-fornec.item-do-forn = item.it-codigo
                               item-fornec.ativo        = YES
                               item-fornec.cod-cond-pag = bf-emitente.cod-cond-pag
                               item-fornec.classe-repro = 1.
            
                        ASSIGN item-fornec.unid-med-for = cotacao-item.un 
                               item-fornec.fator-conver = 1 
                               item-fornec.num-casa-dec = 0.
                    end.
                    
                    /*********************************************************************************/
    
                END.
                
                ASSIGN r-rw-pedido = ROWID(pedido-compr).
    
    
        RELEASE pedido-compr.
        RELEASE ordem-compra.
        RELEASE cotacao-item.
        
        IF r-rw-pedido <> ? THEN DO:
    
            FOR FIRST pedido-compr NO-LOCK
                WHERE ROWID(pedido-compr) = r-rw-pedido,
                FIRST ordem-compra OF pedido-compr NO-LOCK:
                RUN piAprovaAddOrdemCompra (INPUT ROWID(ordem-compra)).
            END.
       END.
    END.
end.    
   RUN pi-finalizar-bos.


RUN esp/escc0300a.p (INPUT TABLE tt-tratamento,
                     INPUT tt-param.dir-arquivo).

FUNCTION fncProxNumPedido RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND LAST bf-pedido-compr USE-INDEX numero NO-LOCK NO-ERROR.

  RETURN IF AVAIL bf-pedido-compr THEN (bf-pedido-compr.num-pedido + 1) ELSE 1.   /* Function return value. */

END FUNCTION.

/* */

FUNCTION fncProxNumOrdem RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND LAST bf-ordem-compra NO-LOCK NO-ERROR.

  RETURN IF AVAIL bf-ordem-compra THEN (bf-ordem-compra.numero-ordem + 100) ELSE 100.   /* Function return value. */

END FUNCTION.



PROCEDURE pi-inicializar-bos.
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  not valid-handle(h-boin082sd) then
        run inbo/boin082sd.p persistent set h-boin082sd.
    if  not valid-handle(h-boin082ca) then
        run inbo/boin082ca.p persistent set h-boin082ca.
    if  not valid-handle(h-boin295desc) then do:
        run inbo/boin295desc.p persistent set h-boin295desc.
        run openQueryStatic in h-boin295desc ( input "Main":U ).
    end.  
END PROCEDURE.


PROCEDURE pi-seta-defaults-cotacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEF VAR c-cod-comprador AS CHAR NO-UNDO.
        DEF VAR l-codigo-icm-sensitive AS LOG NO-UNDO.
        DEF VAR l-aliquota-icm-sensitive AS LOG NO-UNDO.
        DEF VAR l-aliquota-iss-sensitive AS LOG NO-UNDO.
        DEF VAR l-valor-taxa-sensitive AS LOG NO-UNDO.
        DEF VAR l-taxa-financ-sensitive AS LOG NO-UNDO.
        DEF VAR l-possui-reaj-sensitive AS LOG NO-UNDO.

        run emptyRowObject in h-boin082sd.

        assign c-cod-comprador = ordem-compra.cod-comprado.
        
        run preparaCotacaoOrdemCompraPedEmerg in h-boin082sd (input  ordem-compra.numero-ordem,
                                                              input  ordem-compra.num-pedido,
                                                              input  ordem-compra.cod-emitente,
                                                              input  ordem-compra.it-codigo,
                                                              input  ordem-compra.cod-estabel,
                                                              input  ordem-compra.qt-solic,
                                                              input  prazo-compra.data-entrega,
                                                              input-output c-cod-comprador,
                                                              output l-codigo-icm-sensitive,
                                                              output l-aliquota-icm-sensitive,
                                                              output l-aliquota-iss-sensitive,
                                                              output l-valor-taxa-sensitive,
                                                              output l-taxa-financ-sensitive,
                                                              output l-possui-reaj-sensitive,  
                                                              output table tt-cotacao-item).

        return "OK".

END PROCEDURE.


PROCEDURE piAprovaAddOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prOrdemCompra as rowid no-undo.
    def var l-elimina-pend   as log  no-undo.

    def buffer bf-ordem for ordem-compra.


    /***** Aprovaá∆o Eletrìnica ****/
    if  not avail param-aprov then
        find first param-aprov no-lock no-error.
    if  not avail param-compra then
        find first param-compra no-lock no-error.

    /***** Aprovaá∆o Eletrìnica ****/
    for first ordem-compra fields(numero-ordem num-pedido) where
        rowid(ordem-compra)     = prOrdemCompra no-lock: end.
    for first pedido-compr fields(num-pedido emergencial) where 
        pedido-compr.num-pedido = ordem-compra.num-pedido no-lock: end.

    if  avail param-aprov  and
        param-compra.log-1 and
        avail ordem-compra and
        avail pedido-compr then do:

        /* Verifica se dever† gerar pendància de aprovaá∆o.
        */
        find first bf-ordem where bf-ordem.num-pedido   =  pedido-compr.num-pedido
                            and   bf-ordem.situacao     <> 4 no-lock no-error.
        if not avail bf-ordem then do:
           assign l-elimina-pend = yes. 
        end.

        if l-elimina-pend then do:
               run cdp/cdapi171.p (6,3,rowid(ordem-compra)).
        end.
        else do:
            if can-find(first cotacao-item where
                              cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                              cotacao-item.cot-aprovada = yes) then do:
                run cdp/cdapi171.p (6,1,prOrdemCompra) no-error.    /* Emergencial */
                run piMensagemAprEletrOrdemCompra (INPUT prOrdemCompra).
            end.
        end.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* */

PROCEDURE piMensagemAprEletrOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_rw-ordem-compra AS ROWID NO-UNDO.

  DEF VAR i-moeda-lim AS INT NO-UNDO.
  DEF VAR i-tipo-moeda AS INT NO-UNDO.
  DEF VAR c-tipo-moeda AS CHAR NO-UNDO.
  DEF VAR de-valor-doc AS DEC NO-UNDO.
  DEF VAR de-valor-lim AS DEC NO-UNDO.
  DEF VAR c-moeda-lim AS CHAR NO-UNDO.
  DEF VAR l-pendente AS LOG NO-UNDO.
  DEF VAR c-param-msg AS CHAR NO-UNDO.


  run cdp/cdapi174.p (6,
                      p_rw-ordem-compra,
                      output i-moeda-lim,
                      output i-tipo-moeda,
                      output de-valor-doc,
                      output de-valor-lim) no-error.

  for first moeda fields(mo-codigo descricao) where
      moeda.mo-codigo = i-moeda-lim
      no-lock: end.
  assign c-moeda-lim  = string(i-moeda-lim,"99") + " - ":U + moeda.descricao.
  case i-tipo-moeda:
      when 1 then do:
          {utp/ut-liter.i (Usuario) * r}
          assign c-tipo-moeda = return-value.
      end.
      when 2 then do:
          {utp/ut-liter.i (Aprovador) * r}
          assign c-tipo-moeda = return-value.
      end.
      when 3 then do:
          {utp/ut-liter.i (Familia) * r}
          assign c-tipo-moeda = return-value.
      end.
      when 4 then do:
          {utp/ut-liter.i (Mestre) * r}
          assign c-tipo-moeda = return-value.
      end.
  end case.

  run cdp/cdapi172.p (input 6, input p_rw-ordem-compra, output l-pendente).

  /* rde */
  IF de-valor-doc = 0 THEN DO:

      FOR EACH bf3-oc OF pedido-compr NO-LOCK
            WHERE bf3-oc.situacao = 2 /* confirmada */ .
    
            ASSIGN de-valor-doc = de-valor-doc + (bf3-oc.qt-solic * bf3-oc.preco-unit).
        END.

  END.
  /* */

  if l-pendente = no then do:
      ASSIGN c-param-msg =  "Documento aprovado automaticamente.~~" + CHR(10) +
                            "Moeda Convers∆o: " + c-moeda-lim + CHR(10) +
                            "Limite Aprovaá∆o: " + TRIM(STRING(de-valor-lim,'zzzz,zzz,zzz,zz9.99')) + c-tipo-moeda + CHR(10) +
                            "Valor Documento: " + TRIM(STRING(de-valor-doc,'zzzz,zzz,zzz,zz9.99')).
      RUN utp\ut-msgs.p (INPUT 'show':U, INPUT 33331, INPUT c-param-msg).
  end.
  else do:
      ASSIGN c-param-msg =  "Documento est† pendente de aprovaá∆o.~~" + CHR(10) +
                            "Moeda Convers∆o: " + c-moeda-lim + CHR(10) +
                            "Limite Aprovaá∆o: " + TRIM(STRING(de-valor-lim,'zzzz,zzz,zzz,zz9.99')) + c-tipo-moeda + CHR(10) +
                            "Valor Documento: " + TRIM(STRING(de-valor-doc,'zzzz,zzz,zzz,zz9.99')).
      RUN utp\ut-msgs.p (INPUT 'show':U, INPUT 33331, INPUT c-param-msg).
  end.

END PROCEDURE.

/* fim - upc_pd4050_cc.p */

PROCEDURE pi-finalizar-bos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin082sd) THEN DO:
        DELETE PROCEDURE h-boin082sd.
        ASSIGN h-boin082sd = ?.
    END.
    IF VALID-HANDLE(h-boin082ca) THEN DO:
        DELETE PROCEDURE h-boin082ca.
        ASSIGN h-boin082ca = ?.
    END.
    IF VALID-HANDLE(h-boin295desc) THEN DO:
        DELETE PROCEDURE h-boin295desc.
        ASSIGN h-boin295desc = ?.
    END.
END PROCEDURE.

