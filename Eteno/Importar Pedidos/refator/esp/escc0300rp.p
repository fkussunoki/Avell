def temp-table tt-planilha no-undo
    FIELD ttv-tp-venda                  AS CHAR
    FIELD ttv-organizacao               AS CHAR
    FIELD ttv-canal-distrib             AS CHAR
    FIELD ttv-setor                     AS CHAR
    FIELD ttv-emissor                   AS CHAR
    FIELD ttv-nr-pedido                 AS CHAR
    FIELD ttv-it-codigo                 AS CHAR
    FIELD ttv-condicao-coml             AS CHAR
    FIELD ttv-material                  AS CHAR
    FIELD ttv-lote                      AS CHAR
    FIELD ttv-qtde                      AS DEC FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD ttv-dt-entrega                AS DATE
    FIELD ttv-preco-negoc               AS DEC FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD ttv-selected                  AS CHAR
    FIELD ttv-linha                     AS INTEGER
    field ttv-centro                    as char
    field ttv-deposito                  as char
    field ttv-transbordo                as char
    field ttv-cod-parceiro              as char
    field ttv-texto                     as char
    field ttv-OV                        as char
    field ttv-estabelecimento           as char
    field ttv-pedido                    as integer
    field ttv-icms                      as dec.

define temp-table tt-pedido no-undo
    field ttv-cond-pagto        as integer
    field ttv-dt-pedido         as date
    field ttv-dt-entrega        as date
    field ttv-situacao          as integer
    field ttv-cod-emitente      as integer
    field ttv-it-codigo         as char
    field ttv-end-entrega       as char
    field ttv-end-cobranca      as char
    field ttv-frete             as integer
    field ttv-responsavel       as char
    field ttv-comentarios       as char
    field ttv-emergencial       as logical
    field ttv-cod-estabel       as char
    field ttv-cod-estab-gestor  as char
    field ttv-cod-transp        as integer
    field ttv-cod-mensagem      as integer
    field ttv-deposito          as char
    field ttv-un                as char
    field ttv-icms              as dec format "->>>,>9.99"
    field ttv-preco             as dec format "->>>,>>>,>>>,>>9.99"
    field ttv-qtde              as dec format "->>>,>>>,>>>,>>9.99"
    field ttv-lote              as char
    field ttv-condicao          as integer
    field ttv-num-pedido        as integer
    field ttv-ctrl-pedido       as integer.

define temp-table tt-itens
    field ttv-it-codigo     as char
    field ttv-tratado       as char
    field ttv-dep-padrao    as char
    field ttv-un            as char.

DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item
FIELD r-Rowid AS ROWID.
 

def buffer bf-pedido-compr for pedido-compr.
def buffer bf-ordem-compra for ordem-compra.
def buffer bf-emitente     for emitente.
define buffer b-tt-planilha for tt-planilha.
DEFINE BUFFER bf3-oc          FOR ordem-compra.


def var h-boin082sd   as handle no-undo.
def var h-boin082ca   as handle no-undo.
def var h-boin295desc as handle no-undo.
def new global shared var v_cod_usuar_corren as char no-undo.


def var r-rw-pedido as rowid no-undo.

def var l-funcao-mla-ativa as log no-undo initial no.

def var v-ctrle as char no-undo.

define input-output param table for tt-planilha.


run pi-prepara-tt-pedido.
run pi-inicializar-bos.
run pi-cria-pedidos.

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




procedure pi-cria-pedidos:

    FIND FIRST param-aprov  NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
         AND   funcao.ativo NO-ERROR.

    ASSIGN l-funcao-mla-ativa = IF AVAIL funcao THEN YES ELSE NO.

    for each tt-pedido  where tt-pedido.ttv-it-codigo <> ""
                        break by tt-pedido.ttv-ctrl-pedido:

            if first-of(tt-pedido.ttv-ctrl-pedido)

            then do:

            create pedido-compr.
            assign pedido-compr.num-pedido       = fncProxnumPedido()
                   pedido-compr.cod-cond-pag     = int(tt-pedido.ttv-cond-pagto)
                   pedido-compr.data-pedido      = today
                   pedido-compr.situacao         = 1
                   pedido-compr.cod-emitente     = tt-pedido.ttv-cod-emitente
                   pedido-compr.end-entrega      = tt-pedido.ttv-cod-estabel
                   pedido-compr.end-cobranca     = tt-pedido.ttv-cod-estabel
                   pedido-compr.frete            = tt-pedido.ttv-frete
                   pedido-compr.responsavel      = tt-pedido.ttv-responsavel
                   pedido-compr.comentarios      = tt-pedido.ttv-comentarios
                   pedido-compr.emergencial      = tt-pedido.ttv-emergencial
                   pedido-compr.cod-estabel      = tt-pedido.ttv-cod-estabel
                   pedido-compr.cod-estab-gestor = ""
                   pedido-compr.cod-mensagem     = tt-pedido.ttv-cod-mensagem.

                
                   if l-funcao-mla-ativa then assign overlay(pedido-compr.char-1, 58, 1) = "S":U.


                   for each tt-planilha where tt-planilha.ttv-pedido = tt-pedido.ttv-ctrl-pedido:

                        assign tt-planilha.ttv-nr-pedido = string(pedido-compr.num-pedido).
                   end.
            end.                            

                    create ordem-compra.
                    assign ordem-compra.numero-ordem     = fncProxNumOrdem()
                           ordem-compra.it-codigo        = tt-pedido.ttv-it-codigo
                           ordem-compra.situacao         = 2
                           ordem-compra.data-emissao     = today
                           ordem-compra.requisitante     = v_cod_usuar_corren
                           ordem-compra.dep-almoxar      = tt-pedido.ttv-deposito
                           ordem-compra.cod-comprado     = v_cod_usuar_corren
                           ordem-compra.num-pedido       = pedido-compr.num-pedido
                           ordem-compra.data-pedido      = pedido-compr.data-pedido
                           ordem-compra.cod-emitente     = pedido-compr.cod-emitente
                           ordem-compra.cod-cond-pag     = pedido-compr.cod-cond-pag
                           ordem-compra.comentarios      = "Pedido Automatico Excel"
                           ordem-compra.usuario          = v_cod_usuar_corren
                           ordem-compra.data-atualiz     = today
                           ordem-compra.hora-atualiz     = string(time, 'hh:mm:ss')
                           ordem-compra.cod-estabel      = pedido-compr.cod-estabel
                           ordem-compra.tp-despesa       = 101
                           ordem-compra.cod-estab-gestor = pedido-compr.cod-estab-gestor
                           ordem-compra.codigo-icm       = 2
                           ordem-compra.cod-unid-negoc   = "ETE"
                           ordem-compra.qt-solic         = tt-pedido.ttv-qtde
                           ordem-compra.preco-orig       = tt-pedido.ttv-preco
                           ordem-compra.preco-unit       = tt-pedido.ttv-preco
                           ordem-compra.pre-unit-for     = tt-pedido.ttv-preco
                           ordem-compra.preco-fornec     = tt-pedido.ttv-preco.

                    create prazo-compra.
                    assign prazo-compra.numero-ordem     = ordem-compra.numero-ordem
                           prazo-compra.parcela          = 1
                           prazo-compra.it-codigo        = ordem-compra.it-codigo
                           prazo-compra.un               = tt-pedido.ttv-un
                           prazo-compra.quantid-orig     = tt-pedido.ttv-qtde
                           prazo-compra.quant-saldo      = tt-pedido.ttv-qtde
                           prazo-compra.qtd-do-forn      = tt-pedido.ttv-qtde
                           prazo-compra.qtd-sal-forn     = tt-pedido.ttv-qtde
                           prazo-compra.nome-abrev       = ""
                           prazo-compra.pedido-clien     = ""
                           prazo-compra.data-orig        = today
                           prazo-compra.situacao         = 2
                           prazo-compra.data-entrega     = tt-pedido.ttv-dt-entrega.

                           EMPTY TEMP-TABLE tt-cotacao-item.
                           RUN pi-seta-defaults-cotacao.
               
                           FIND FIRST tt-cotacao-item NO-LOCK NO-ERROR.
               
                           IF AVAIL tt-cotacao-item THEN DO:
               
                               FIND CURRENT tt-cotacao-item EXCLUSIVE-LOCK NO-ERROR.
               
                               ASSIGN tt-cotacao-item.un           = prazo-compra.un
                                      tt-cotacao-item.preco-unit   = ordem-compra.preco-unit
                                      tt-cotacao-item.pre-unit-for = ordem-compra.pre-unit-for
                                      tt-cotacao-item.preco-fornec = ordem-compra.preco-fornec
                                      tt-cotacao-item.cod-cond-pag = ordem-compra.cod-cond-pag
                                      tt-cotacao-item.cod-comprado = ordem-compra.cod-comprado
                                      tt-cotacao-item.aliquota-icm   = tt-pedido.ttv-icms
                                      /* tt-cotacao-item.codigo-icm   = 2  /* ndustrializacao */ */
                                      tt-cotacao-item.cot-aprovada = YES
                                      tt-cotacao-item.data-atualiz = TODAY
                                      tt-cotacao-item.hora-atualiz = STRING(TIME,'HH:MM:SS').

                                      ASSIGN ordem-compra.codigo-ipi   = tt-cotacao-item.codigo-ipi
                                      ordem-compra.aliquota-ipi = tt-cotacao-item.aliquota-ipi.
               
               
                               FIND FIRST tt-cotacao-item NO-LOCK NO-ERROR.
               
               
                               CREATE cotacao-item.
                               BUFFER-COPY tt-cotacao-item TO cotacao-item.
           
                    /* cria relaá∆o item x fornec ****************************************************/
    
                    FIND FIRST bf-emitente where 
                        bf-emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        
                    FIND FIRST item-fornec where 
                        item-fornec.it-codigo    = tt-pedido.ttv-it-codigo           AND 
                        item-fornec.cod-emitente = bf-emitente.cod-emitente NO-LOCK NO-ERROR.
                    
                    if not available item-fornec and 
                       item.tipo-contr <> 4      and
                       item.it-codigo  <> ""     then do:
        
                        CREATE item-fornec.
                        ASSIGN item-fornec.it-codigo    = tt-pedido.ttv-it-codigo
                               item-fornec.cod-emitente = bf-emitente.cod-emitente
                               item-fornec.item-do-forn = tt-pedido.ttv-it-codigo
                               item-fornec.ativo        = YES
                               item-fornec.cod-cond-pag = bf-emitente.cod-cond-pag
                               item-fornec.classe-repro = 1.
            
                        ASSIGN item-fornec.unid-med-for = cotacao-item.un 
                               item-fornec.fator-conver = 1 
                               item-fornec.num-casa-dec = 0.
                    end.
                    
                end.

                ASSIGN r-rw-pedido = ROWID(pedido-compr).


                RELEASE pedido-compr.
                RELEASE ordem-compra.
                RELEASE cotacao-item.
                
                IF r-rw-pedido <> ? THEN DO:
            
                    FOR FIRST pedido-compr NO-LOCK
                        WHERE ROWID(pedido-compr) = r-rw-pedido,
                        FIRST ordem-compra OF pedido-compr NO-LOCK:
                        RUN piAprovaAddOrdemCompra (INPUT ROWID(ordem-compra)).
                        run piMensagemAprEletrOrdemCompra(input rowid(ordem-compra)).
                    END.
               END.
        end.
        RUN pi-finalizar-bos.
   


end procedure.

    procedure pi-prepara-tt-pedido:



    for each item no-lock where item.ge-codigo >= 30
    and item.ge-codigo <= 40:

        create tt-itens.
        assign tt-itens.ttv-it-codigo   = item.it-codigo
               tt-itens.ttv-tratado     = trim(replace(replace(item.it-codigo, "-", ""), " ", ""))
               tt-itens.ttv-dep-padrao  = item.deposito-pad
               tt-itens.ttv-un          = item.un.
    end.


    
            for each tt-planilha where tt-planilha.ttv-selected = "*":

                if not can-find(estabelec no-lock where estabelec.cod-estabel = tt-planilha.ttv-estabelecimento) then do:

                message 'Estabelecimento informado esta incorreto ' view-as alert-box.
                return 'nok'.
                end.
                find first tt-itens no-lock where tt-itens.ttv-it-codigo = tt-planilha.ttv-it-codigo no-error.

                

                create tt-pedido.
                assign tt-pedido.ttv-cod-emitente     = 35
                       tt-pedido.ttv-situacao         = 1
                       tt-pedido.ttv-dt-pedido        = today
                       tt-pedido.ttv-frete            = 1
                       tt-pedido.ttv-responsavel      = v_cod_usuar_corren
                       tt-pedido.ttv-comentarios      = "Pedido Automatico Excel"
                       tt-pedido.ttv-emergencial      = yes
                       tt-pedido.ttv-cod-estab-gestor = ""
                       tt-pedido.ttv-cod-mensagem     = 301
                       tt-pedido.ttv-cod-transp       = 1
                       tt-pedido.ttv-it-codigo        = tt-planilha.ttv-it-codigo
                       tt-pedido.ttv-cond-pagto       = int(entry(1, trim(tt-planilha.ttv-condicao-coml), "A"))
                        tt-pedido.ttv-qtde             = dec(tt-planilha.ttv-qtde)
                        tt-pedido.ttv-preco            = dec(tt-planilha.ttv-preco-negoc)
                        tt-pedido.ttv-dt-entrega       = tt-planilha.ttv-dt-entrega   
                        tt-pedido.ttv-deposito         = tt-itens.ttv-dep-padrao
                        tt-pedido.ttv-un               = tt-itens.ttv-un
                        tt-pedido.ttv-cod-estabel      = tt-planilha.ttv-estabelecimento
                        tt-pedido.ttv-ctrl-pedido      = tt-planilha.ttv-pedido.
                        
                        if tt-planilha.ttv-icms    = 0 then do:

                           if tt-planilha.ttv-centro   <> "" then

                            assign tt-pedido.ttv-icms = 4.

                            else assign tt-pedido.ttv-icms = 7.
                            
                        end.
                        
                        else do:
                            assign tt-pedido.ttv-icms = tt-planilha.ttv-icms.
                            
                        end.

                        
                    

            end.
        end procedure.

      
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
                      //run piMensagemAprEletrOrdemCompra (INPUT prOrdemCompra).
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
      
              
