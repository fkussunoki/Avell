/* Empresa do Usuario */
{include/i-prgvrs.i ESRC0501ARP 1.00.00.001}


DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario AS CHARACTER NO-UNDO.

define temp-table tt-param NO-UNDO
    field destino       as integer
    field arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field classifica    as integer
    field c-serie-ini   as char
    field c-serie-fim   as char
    field c-docto-ini   as char
    field c-docto-fim   as char
    field c-opera-ini   as char
    field c-opera-fim   as char
    field i-emite-ini   as integer
    field i-emite-fim   as integer
    field c-est-ini     as char
    field c-est-fim     as char
    field da-trans-ini  as date format "99/99/9999"
    field da-trans-fim  as date format "99/99/9999"
    field da-atual-ini  as date format "99/99/9999"
    field da-atual-fim  as date format "99/99/9999"
    field c-usuario-ini as char format "x(12)"
    field c-usuario-fim as char format "x(12)"    
    field da-emis-ini   as date format "99/99/9999"
    field da-emis-fim   as date format "99/99/9999"
    field i-tipo-ini    as integer
    field i-tipo-fim    as integer
    field i-parametro   as integer
    field l-narrativa   as logical
    field l-mensagem    as logical
    field l-grade       as logical
    field l-fasb        as logical
    field l-cmcac       as logical
    field l-deta        as logical
    field l-docto-imp   as logical
    field l-extr-forn   as logical
    field l-comp        as logical
    field i-custo       as integer
    field i-mo-fasb     as integer
    field i-mo-cmcac    as integer
    field c-custo       as char
    field c-param       as char
    field c-classe      as char
    field c-destino     as char
    field l-param       as logical.


def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR c-reinf AS char NO-UNDO.
def var i-empresa like param-global.empresa-prin no-undo.

def var v_cod_cta_ctbl       as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
DEF VAR c-titulo-conta       AS char   NO-UNDO.
DEF VAR c-titulo-ccusto      AS char   NO-UNDO.

DEF VAR h_api_cta_ctbl AS HANDLE NO-UNDO.
DEF VAR h_api_ccusto   AS HANDLE NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    .
{include/i-rpvar.i}

/* include padr’o para output stream str-rp de relat½rios */
{include/i-rpout.i &STREAM="stream str-rp"}

/* include com a defini»’o da frame de cabe»alho e rodap² */
{include/i-rpcab.i &STREAM="str-rp"}
        /* bloco principal do programa */
        assign c-programa 	  = "ESRC0501ARP"
               c-versao	      = "1.04"
               c-revisao	  = ".00.000"
               c-empresa 	  = "rioclarense"
               c-sistema  	  = ""
               c-titulo-relat = "ESRC0501".


/* Handle da API Conta Contÿbil */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
/* Handle da API Centro Custo */
run prgint/utb/utb742za.py persistent set h_api_ccusto.

DEFINE VAR h-acomp AS HANDLE NO-UNDO.
DEFINE VAR c-unid-negoc AS char NO-UNDO.
DEFINE VAR c-descricao  AS char NO-UNDO.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "RE0501-Especifico").

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN i-empresa = param-global.empresa-prin.

FIND FIRST tt-param NO-ERROR.

PUT STREAM str-rp UNFORMATTED 'EMITENTE | NOME | UF | SERIE | DOCUMENTO | NAT.OPER | TRANSACAO | ESP.DOC | COD OBSRV | ESTABEL | VLR TOT NF | REINF | ITEM | DESCR ITEM |  C.CONTABIL | TIT CONTA | C.CUSTO | TIT C.CUSTO | UNID NEG | NOM UN | ESP FIN | NOM ESPEC' 
    SKIP.
        
        for each docum-est  
            fields (base-icm     base-ipi      base-iss     base-subs                               
                    cod-emitente conta-transit ce-atual     cod-estabel
                    cod-observa  despesa-nota  dt-emissao   dt-trans
                    dt-atualiz   esp-docto     estab-fisc   icm-fonte
                    icm-deb-cre  ipi-deb-cre   iss-deb-cre  nat-operacao
                    nro-docto    observacao    origem       rec-fisico
                    serie-docto  tot-desconto  tot-peso     tot-valor                          
                    uf           usuario       valor-mercad via-transp
                    vl-subs      char-1        char-2       mod-frete
                    vl-pis-subs vl-cofins-subs
		            nome-transp     cod-placa[1]    cod-placa[2]
		            cod-placa[3]    cod-uf-placa[1] cod-uf-placa[2] cod-uf-placa[3]
		            log-memorando   cod-entrega     endereco        bairro
                    cep             cidade          pais            log-consid-ender-nf-saida
                    ct-transit      sc-transit
                    idi-sit-nf-eletro
                    cod-chave-aces-nf-eletro
                     )
            where 
                  docum-est.serie-docto  >= tt-param.c-serie-ini
            and   docum-est.serie-docto  <= tt-param.c-serie-fim
            and   docum-est.nro-docto    >= tt-param.c-docto-ini
            and   docum-est.nro-docto    <= tt-param.c-docto-fim
            and docum-est.cod-emit     >= tt-param.i-emite-ini
            and docum-est.cod-emit     <= tt-param.i-emite-fim     
            and   docum-est.nat-operacao <= tt-param.c-opera-fim
            and   docum-est.cod-estabel  >= tt-param.c-est-ini
            and   docum-est.cod-estabel  <= tt-param.c-est-fim
            and   docum-est.dt-trans     >= tt-param.da-trans-ini
            and   docum-est.dt-trans     <= tt-param.da-trans-fim
            and   docum-est.dt-atualiza  >= tt-param.da-atual-ini
            and   docum-est.dt-atualiza  <= tt-param.da-atual-fim
            and   docum-est.usuario      >= tt-param.c-usuario-ini
            and   docum-est.usuario      <= tt-param.c-usuario-fim
            and   docum-est.dt-emissao   >= tt-param.da-emis-ini
            and   docum-est.dt-emissao   <= tt-param.da-emis-fim
            and   docum-est.esp-docto    >= tt-param.i-tipo-ini
            and   docum-est.esp-docto    <= tt-param.i-tipo-fim     
            and  (   (docum-est.ce-atual     = yes)) NO-LOCK:
/*                       and   can-find(first consist-nota                                                   */
/*                                      where consist-nota.serie-docto  = docum-est.serie-docto              */
/*                                        and consist-nota.nro-docto    = docum-est.nro-docto                */
/*                                        and consist-nota.cod-emitente = docum-est.cod-emitente             */
/*                                        and consist-nota.nat-operacao = docum-est.nat-operacao))) NO-LOCK: */



            IF substring(docum-est.char-2,256,1) = 'S' THEN ASSIGN c-reinf = "Sim". 
            ELSE ASSIGN c-reinf = "Nao".
  

                   for each item-doc-est fields (aliquota-icm
                                                 aliquota-iss
                                                 aliquota-ipi
                                                 cd-trib-icm
                                                 cd-trib-iss                                  
                                                 cd-trib-ipi  
                                                 cod-emitente                                  
                                                 class-fiscal                                                                    
                                                 cod-refer                                                                 
                                                 ct-codigo
                                                 desconto                                                                  
                                                 despesas
                                                 it-codigo                                  
                                                 narrativa                                  
                                                 nat-comp     
                                                 nat-operacao                                                               
                                                 nr-ficha                                  
                                                 nr-ord-prod  
                                                 cod-estab-compon
                                                 nro-comp   
                                                 nro-docto                                    
                                                 num-pedido
                                                 numero-ordem                                   
                                                 parcela                                                                                              
                                                 preco-total
                                                 quantidade
                                                 sc-codigo
                                                 sequencia                                  
                                                 serie-comp   
                                                 serie-docto                    
                                                 un
                                                 valor-icm
                                                 valor-ipi    
                                                 valor-iss
                                                 char-2
                                                 val-aliq-pis
                                                 idi-tributac-pis
                                                 base-pis
                                                 valor-pis
                                                 idi-tributac-cofins
                                                 val-aliq-cofins
                                                 val-base-calc-cofins
                                                 val-cofins
                                                 cod-unid-negoc
                                                 nat-of) use-index documento where
                                                 ITEM-DOC-EST.serie-docto  = DOCUM-EST.serie-docto and
                                                 ITEM-DOC-EST.nro-docto    = DOCUM-EST.nro-docto and
                                                 ITEM-DOC-EST.cod-emitente = DOCUM-EST.cod-emitente and
                                                 ITEM-DOC-EST.nat-operacao = DOCUM-EST.nat-operacao:

                       RUN pi-acompanhar IN h-acomp(INPUT "Est " + item-doc-est.cod-estab + " Serie " + item-doc-est.serie-docto + " Docto " + item-doc-est.nro-docto + " Emitente " + STRING(item-doc-est.cod-emitente) + " NatOper " + item-doc-est.nat-operacao).
               
                       FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = item-doc-est.cod-emitente NO-ERROR.
                       FIND FIRST ITEM     NO-LOCK WHERE ITEM.it-codigo        = item-doc-est.it-codigo    NO-ERROR.
               
               
                           FIND FIRST dupli-apagar        
                                         WHERE   ITEM-DOC-EST.serie-docto  = dupli-apagar.serie-docto and
                                                 ITEM-DOC-EST.nro-docto    = dupli-apagar.nro-docto and
                                                 ITEM-DOC-EST.cod-emitente = dupli-apagar.cod-emitente and
                                                 ITEM-DOC-EST.nat-operacao = dupli-apagar.nat-operacao NO-ERROR.
               
               
               
               
                       
               
                       run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                                      input        "",                 /* PLANO DE CONTAS */
                                                                      input-output item-doc-est.ct-codigo,     /* CONTA */
                                                                      input        docum-est.dt-trans, /* DATA TRANSACAO */   
                                                                      output       c-titulo-conta,     /* DESCRICAO CONTA */
                                                                      output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                                      output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                                      output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                                      output table tt_log_erro).       /* ERROS */ 
                       
                       run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                                  input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                                  input  item-doc-est.sc-codigo,           /* CCUSTO */
                                                                  input  docum-est.dt-trans, /* DATA DE TRANSACAO */
                                                                  output c-titulo-ccusto,    /* DESCRICAO DO CCUSTO */
                                                                  output table tt_log_erro). /* ERROS */
               
               
                               PUT STREAM str-rp UNFORMATTED item-doc-est.cod-emitente "|"
                                               emitente.nome-abrev       "|"
                                               emitente.estado           "|"
                                               item-doc-est.serie-docto  "|"
                                               item-doc-est.nro-docto    "|"
                                               docum-est.nat-operacao    "|"
                                               docum-est.dt-trans        "|"
                                               {ininc/i03in218.i 04 docum-est.esp-docto} "|"
                                               {ininc/i03in090.i 04 docum-est.cod-observa} "|"
                                               docum-est.cod-estabel    "|"
                                               item-doc-est.preco-total[1] "|"
                                               c-reinf                  "|"
                                               item-doc-est.it-codigo   "|"
                                               ITEM.descricao-1         "|"
                                               item-doc-est.ct-codigo   "|"
                                               c-titulo-conta           "|"
                                               item-doc-est.sc-codigo   "|"
                                               c-titulo-ccusto          "|"
                                               .
     

                               FIND FIRST emsbas.unid_negoc NO-LOCK WHERE unid_negoc.cod_unid_negoc = item-doc-est.cod-unid-negoc NO-ERROR.

                               IF AVAIL emsbas.unid_negoc THEN DO:

                                  PUT STREAM str-rp UNFORMATTED   unid_negoc.cod_unid_negoc "|"   
                                                                  unid_negoc.des_unid_negoc "|".
                                   
                               END.
                               ELSE DO:
                                   FOR EACH unid-neg-ordem NO-LOCK WHERE unid-neg-ordem.numero-ordem = item-doc-est.numero-ordem:

                                       FIND FIRST emsbas.unid_negoc NO-LOCK WHERE emsbas.unid_negoc.cod_unid_negoc = unid-neg-ordem.cod_unid_negoc NO-ERROR.

                                       ASSIGN c-unid-negoc = c-unid-negoc + " , " + unid-neg-ordem.cod_unid_negoc
                                              c-descricao  = c-descricao  + " , " + emsbas.unid_negoc.des_unid_negoc.

                                   END.

                                   PUT STREAM str-rp UNFORMATTED       c-unid-negoc "|"
                                                                        c-descricao "|".
                                   
                               END.

                               FIND FIRST dupli-apagar        
                                                       WHERE   ITEM-DOC-EST.serie-docto  = dupli-apagar.serie-docto and
                                                               ITEM-DOC-EST.nro-docto    = dupli-apagar.nro-docto and
                                                               ITEM-DOC-EST.cod-emitente = dupli-apagar.cod-emitente and
                                                               ITEM-DOC-EST.nat-operacao = dupli-apagar.nat-operacao NO-ERROR.

                               IF AVAIL dupli-apagar THEN

                                   FIND FIRST espec_docto NO-LOCK WHERE espec_docto.cod_espec_docto = dupli-apagar.cod-esp NO-ERROR.

                                   PUT STREAM str-rp UNFORMATTED dupli-apagar.cod-esp "|"
                                                                 espec_docto.des_espec_docto SKIP.

                               ELSE 
                                   PUT STREAM str-rp UNFORMATTED "Sem duplicatas"  "|" 
                                                                  "" SKIP.




                               END.
                         END.
                                               
          RUN pi-finalizar IN h-acomp.     
                                           
{include/i-rpclo.i &STREAM="stream str-rp"}
