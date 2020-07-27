/*
** Programa.....: criaSolicitacoesMKT
** Data.........: 30/05/2018 - V.12.00.00.000 - Cria‡Æo Funcionalidade
**                        TechSolver - MAK
*/


FUNCTION fn-usuar-aprov RETURNS CHARACTER(p-cod-papel AS CHAR) FORWARD.

{utp/ut-glob.i}

DEFINE TEMP-TABLE ttErro                
    FIELD SeqErro           AS INTEGER
    FIELD desc-erro-1       AS CHARACTER
    FIELD desc-erro-2       AS CHARACTER
    INDEX I00-Principal AS PRIMARY
    SeqErro.

def temp-table tt_xml_input_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .

DEFINE INPUT PARAMETER pSenha                      AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pCodigoRep                  AS INTEGER     NO-UNDO.
DEFINE INPUT PARAMETER p-solicitacao               AS INTEGER     NO-UNDO.
DEFINE INPUT PARAMETER p-acao                      LIKE amkt-solicitacao.cd-acao.        
DEFINE INPUT PARAMETER p-cd-forma-pagto            LIKE amkt-solicitacao.cd-forma-pagto.        
DEFINE INPUT PARAMETER p-cd-justificativa          LIKE amkt-solicitacao.cd-justificativa.      
DEFINE INPUT PARAMETER p-tipo-fatur                LIKE amkt-solicitacao.tipo-fatur .      
DEFINE INPUT PARAMETER p-justificativa             LIKE amkt-solicitacao.justificativa-det.  
DEFINE INPUT PARAMETER p-cd-publico-alvo           LIKE amkt-solicitacao.cd-publico-alvo.       
DEFINE INPUT PARAMETER p-cd-tipo-acao              LIKE amkt-solicitacao.cd-tipo-acao.          
DEFINE INPUT PARAMETER p-cod-emitente              LIKE amkt-solicitacao.cod-emitente.          
DEFINE INPUT PARAMETER p-dinamica                  LIKE amkt-solicitacao.dinamica.              
DEFINE INPUT PARAMETER p-dt-validade-final         LIKE amkt-solicitacao.dt-validade-final.     
DEFINE INPUT PARAMETER p-dt-validade-inicial       LIKE amkt-solicitacao.dt-validade-inicial.   
DEFINE INPUT PARAMETER p-forma-pagto-agencia       LIKE amkt-solicitacao.forma-pagto-agencia.   
DEFINE INPUT PARAMETER p-forma-pagto-cd-banco      LIKE amkt-solicitacao.forma-pagto-cd-banco.  
DEFINE INPUT PARAMETER p-forma-pagto-conta         LIKE amkt-solicitacao.forma-pagto-conta.     
DEFINE INPUT PARAMETER p-forma-pagto-cpf-cnpj      LIKE amkt-solicitacao.forma-pagto-cpf-cnpj.  
DEFINE INPUT PARAMETER p-forma-pagto-favorecido    LIKE amkt-solicitacao.forma-pagto-favorecido.
DEFINE INPUT PARAMETER p-forma-pagto-nome-banco    LIKE amkt-solicitacao.forma-pagto-nome-banco.
DEFINE INPUT PARAMETER p-forma-pagto-tipo          LIKE amkt-solicitacao.forma-pagto-tipo.      
DEFINE INPUT PARAMETER p-vl-solicitacao            LIKE amkt-solicitacao.vl-solicitacao.        
DEFINE INPUT PARAMETER p-payback-dias              LIKE amkt-solicitacao.payback-dias.          
DEFINE INPUT PARAMETER p-indice-aprov              LIKE amkt-solicitacao.indice-aprov.          
DEFINE INPUT PARAMETER p-indice-aprov-dias         LIKE amkt-solicitacao.indice-aprov-dias. 
DEFINE OUTPUT PARAM TABLE FOR ttErro.
DEFINE OUTPUT PARAM pSolicitacaoGerada      AS INTEGER      NO-UNDO.

FUNCTION fcnSetErro RETURN LOGICAL ( INPUT pPar1 AS CHARACTER, INPUT pPar2 AS CHARACTER ) FORWARD.
FUNCTION fcnValidateInsert RETURN CHARACTER () FORWARD.

DEFINE VARIABLE hAcomp           AS HANDLE       NO-UNDO.
DEFINE VARIABLE iNextSolicitacao AS INTEGER      NO-UNDO.
DEFINE VARIABLE lErro            AS LOGICAL      NO-UNDO.
DEFINE VARIABLE i-ano            AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-mes            AS INTEGER      NO-UNDO.
DEFINE VARIABLE de-orcado        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-realizado     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-empenhado     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-erro           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE da-valid-orcto   AS DATE        NO-UNDO.

/*---------------- Valida‡Æo Senha -------------------*/
DEF VAR c-frase AS CHAR.
DEF VAR r-cripto AS RAW.
DEF VAR c-cripto AS CHAR.

ASSIGN c-frase = string(month(TODAY),"99") + "SDV&2.0" + string(YEAR(TODAY)) + string(pCodigoRep).
ASSIGN r-cripto = md5-DIGEST(c-frase).
ASSIGN c-cripto = HEX-ENCODE(r-cripto). 

IF c-cripto <> pSenha THEN DO:
    fcnSetErro('Tente Novamente! Erro (1)','Tente Novamente! #AMKT1').
    RETURN 'NOK':U.
END.
/*---------------- (erro) Valida‡Æo Senha -------------------*/

RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
RUN pi-inicializar IN hAcomp (INPUT "Processando...").

FOR repres NO-LOCK WHERE repres.cod-rep = pCodigoRep: END.
IF NOT AVAIL repres THEN DO: 
    fcnSetErro('Representante inv lido','Representante nÆo cadastrado. #AMKT2').
    RUN pi-finalizar IN hAcomp.
    RETURN 'NOK':U.
END.

IF p-solicitacao = 0 THEN DO:
    FIND FIRST amkt-acao NO-LOCK WHERE
               amkt-acao.cd-acao = p-acao NO-ERROR.
    IF NOT AVAIL amkt-acao THEN DO:
        fcnSetErro('A‡Æo','NÆo existe A‡Æo para o c¢digo informado. #AMKT3').
        RUN pi-finalizar IN hAcomp.
        RETURN 'NOK':U.
    END.
END.

IF p-solicitacao <> 0 THEN DO:
    FOR FIRST amkt-solicitacao EXCLUSIVE-LOCK
        WHERE amkt-solicitacao.numero  = p-solicitacao:
    END.
    IF  NOT AVAIL amkt-solicitacao THEN DO:
        fcnSetErro('Solicita‡Æo','NÆo existe Solicita‡Æo para a numera‡Æo informada. #AMKT4').
        RUN pi-finalizar IN hAcomp.
        RETURN 'NOK':U.
    END.
    IF amkt-solicitacao.cod-rep <> pCodigoRep THEN DO:
        fcnSetErro('Solicita‡Æo','A Solicita‡Æo informada nÆo pertence a este representante. #AMKT5').
        RUN pi-finalizar IN hAcomp.
        RETURN 'NOK':U.
    END.
END.

FIND FIRST amkt-tipo-acao NO-LOCK WHERE
           amkt-tipo-acao.cd-tipo-acao = p-cd-tipo-acao NO-ERROR.
IF NOT AVAIL amkt-tipo-acao THEN DO:
    fcnSetErro('Solicita‡Æo','Tipo de A‡Æo nÆo encontrada com o c¢digo informado. #AMKT6').
    RUN pi-finalizar IN hAcomp.
    RETURN 'NOK':U.
END.

IF amkt-tipo-acao.acao-especifica = YES                AND
   (TRIM(p-justificativa) = "" OR p-justificativa = ?) THEN DO:
    fcnSetErro('Solicita‡Æo','A‡Æo Espec¡fica requer Justificativa Detalhada preenchida. #AMKT7').
    RUN pi-finalizar IN hAcomp.
    RETURN 'NOK':U.
END.

FIND FIRST emitente NO-LOCK WHERE
           emitente.cod-emitente = p-cod-emitente NO-ERROR.
IF NOT AVAIL emitente THEN DO:
    fcnSetErro('Solicita‡Æo', "Cliente da Solicita‡Æo Mkt nÆo foi encontrado. #AMKT8").
    RETURN "NOK".
END.

FIND FIRST sgv-seg-mercado NO-LOCK WHERE
           sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
IF NOT AVAIL sgv-seg-mercado THEN DO:
    fcnSetErro('Solicita‡Æo', "Mercado nÆo encontrado. #AMKT9").
    RETURN "NOK".
END.

FIND FIRST dc-repres-gestor NO-LOCK WHERE
           dc-repres-gestor.cod-rep     = repres.cod-rep              AND
           dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
IF NOT AVAIL dc-repres-gestor THEN DO:
    fcnSetErro('Solicita‡Æo', "Gestor nÆo encontrado. #AMKT10").
    RETURN "NOK".
END.

FIND FIRST dc-regiao NO-LOCK WHERE
           dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.
IF NOT AVAIL dc-regiao THEN DO:
    fcnSetErro('Solicita‡Æo', "Centro de Custo nÆo encontrado. #AMKT11").
    RETURN "NOK".
END.

// Chamado 91011
IF fn-usuar-aprov("Coordenador de Vendas") = "" THEN DO:
    fcnSetErro('Solicita‡Æo', "NÆo foi encontrado Coordenador de Vendas cadastrado, favor entrar em contato com a TIC. #AMKT18").
    RETURN "NOK".
    // "Gerˆncia", "Diretoria", "Coordena‡Æo Trade", "Trade do canal"
END.

// Chamado 90879 - Valida‡Æo necess ria pois ao rodar API001BGC preciso ter o amkt-forma-pagto.tipo-pagto dispon¡vel
FIND FIRST amkt-forma-pagto NO-LOCK WHERE
           amkt-forma-pagto.cd-forma-pagto = p-cd-forma-pagto NO-ERROR.
IF NOT AVAIL amkt-forma-pagto THEN DO:
    fcnSetErro('Solicita‡Æo', "NÆo foi encontrada Forma de Pagamento informada, favor entrar em contato com a TIC. #AMKT19").
    RETURN "NOK".
END.

// Chamado 90879 - Data da valida‡Æo do or‡amento depende do fluxo
IF amkt-forma-pagto.tipo-pagto = 3 /* Adiantamento */ THEN
    ASSIGN da-valid-orcto = p-dt-validade-inicial.
ELSE // 1 - Bonificado, 2 - Abatimento
    ASSIGN da-valid-orcto = p-dt-validade-final.

RUN piOrcamento. //execucao orcamentaria

//RUN gsp/api/api001bgc.p(INPUT  STRING(YEAR(da-valid-orcto)), // Exercicio Cont bil(Ano)                               - P_Cod_Exerc_Ctbl
//                        INPUT  MONTH(da-valid-orcto),        // Per¡odo(Mˆs)                                          - P_Num_Period_Ctbl
//                        INPUT  "435362",                     // Conta Cont bil                                        - P_Cod_Cta_Ctbl
//                        INPUT  dc-regiao.cod-ccusto,         // Centro de Custo                                       - P_Cod_Ccusto
//                        INPUT  "Per¡odo",                    // Abrangencia Pesquisa(Exercicio = Ano e Per¡odo = Mˆs) - P_Ind_Tip_Pesq
//                        OUTPUT de-orcado,                    // Valor Or‡ado                                          - P_Val_Orcado_Sdo
//                        OUTPUT de-realizado,                 // Valor Realizado                                       - P_Val_Sdo_Ctbl_Fim
//                        OUTPUT de-empenhado,                 // Valor Empenhado                                       - P_Val_Movto_Empenh
//                        OUTPUT c-erro).                      // Retorno de poss¡veis erros, separados por ";"         - P_Retorn_Error
//
//IF (p-vl-solicitacao + de-realizado + de-empenhado) > de-orcado THEN DO:
//    fcnSetErro('NÆo Aprovado', "Para esta solicita‡Æo, gentileza contatar seu gestor. #AMKT12").
//    RETURN "NOK".
//END.

RUN pi-finalizar IN hAcomp.

ASSIGN lErro = (fcnValidateInsert() = 'NOK').
IF lErro THEN
    RETURN 'NOK':U.

/* INCLUSAO */
IF p-solicitacao = 0 THEN DO TRANSACTION:
    ASSIGN iNextSolicitacao = 5000.
    FOR LAST amkt-solicitacao NO-LOCK WHERE
             amkt-solicitacao.numero >= 0:
        ASSIGN iNextSolicitacao = amkt-solicitacao.numero + 1.
    END.
    CREATE amkt-solicitacao.
    ASSIGN amkt-solicitacao.numero                  = iNextSolicitacao
           amkt-solicitacao.data-solicitacao        = TODAY
           amkt-solicitacao.cd-acao                 = p-acao
           amkt-solicitacao.cd-forma-pagto          = p-cd-forma-pagto        
           amkt-solicitacao.cd-justificativa        = p-cd-justificativa      
           amkt-solicitacao.cd-publico-alvo         = p-cd-publico-alvo       
           amkt-solicitacao.cd-tipo-acao            = p-cd-tipo-acao          
           amkt-solicitacao.cod-emitente            = p-cod-emitente          
           amkt-solicitacao.cod-rep                 = pCodigoRep               
           amkt-solicitacao.cod-situacao            = "Pendente de Aprova‡Æo"
           amkt-solicitacao.situacao-pagto          = "NÆo Dispon¡vel"
           amkt-solicitacao.situacao-comprov        = "NÆo Dispon¡vel"
           amkt-solicitacao.dinamica                = p-dinamica              
           amkt-solicitacao.dt-validade-final       = p-dt-validade-final
           amkt-solicitacao.dt-validade-inicial     = p-dt-validade-inicial   
           amkt-solicitacao.forma-pagto-agencia     = p-forma-pagto-agencia   
           amkt-solicitacao.forma-pagto-cd-banco    = p-forma-pagto-cd-banco  
           amkt-solicitacao.forma-pagto-conta       = p-forma-pagto-conta     
           amkt-solicitacao.forma-pagto-cpf-cnpj    = p-forma-pagto-cpf-cnpj  
           amkt-solicitacao.forma-pagto-favorecido  = p-forma-pagto-favorecido
           amkt-solicitacao.forma-pagto-nome-banco  = p-forma-pagto-nome-banco
           amkt-solicitacao.forma-pagto-tipo        = p-forma-pagto-tipo      
           amkt-solicitacao.vl-solicitacao          = p-vl-solicitacao
           amkt-solicitacao.payback-dias            = p-payback-dias     
           amkt-solicitacao.indice-aprov            = p-indice-aprov     
           amkt-solicitacao.indice-aprov-dias       = p-indice-aprov-dias
           amkt-solicitacao.justificativa-det       = p-justificativa
           amkt-solicitacao.tipo-fatur              = p-tipo-fatur.

    RUN criaNovaChave IN THIS-PROCEDURE(INPUT amkt-solicitacao.numero, OUTPUT c-cripto).

    ASSIGN amkt-solicitacao.GUID = c-cripto.

    ASSIGN pSolicitacaoGerada = amkt-solicitacao.numero.

    FIND CURRENT amkt-solicitacao NO-LOCK NO-ERROR.
    
    RELEASE amkt-solicitacao-sell-in.

    RUN dop/env-mail-mkt.p(INPUT pSolicitacaoGerada).

    RUN pi-gera-pend-aprov.

    RELEASE amkt-solicitacao.

    RETURN "OK".
END.
/* ALTERA€ÇO */
ELSE DO TRANSACTION:

    FIND FIRST amkt-solicitacao EXCLUSIVE-LOCK 
         WHERE amkt-solicitacao.numero = p-solicitacao NO-WAIT NO-ERROR.

    IF LOCKED(amkt-solicitacao) THEN DO:
        fcnSetErro('Solicita‡Æo','Solicita‡Æo est  sendo alterada por outro usu rio. #AMKT13').
        ASSIGN lErro = TRUE.
        RUN pi-finalizar IN hAcomp.
        RETURN 'NOK':U.

    END.
    ASSIGN amkt-solicitacao.cd-forma-pagto          = p-cd-forma-pagto        
           amkt-solicitacao.cd-justificativa        = p-cd-justificativa      
           amkt-solicitacao.cd-publico-alvo         = p-cd-publico-alvo       
           amkt-solicitacao.cd-tipo-acao            = p-cd-tipo-acao          
           amkt-solicitacao.cod-emitente            = p-cod-emitente          
           amkt-solicitacao.dinamica                = p-dinamica              
           amkt-solicitacao.dt-validade-final       = p-dt-validade-final     
           amkt-solicitacao.dt-validade-inicial     = p-dt-validade-inicial   
           amkt-solicitacao.forma-pagto-agencia     = p-forma-pagto-agencia   
           amkt-solicitacao.forma-pagto-cd-banco    = p-forma-pagto-cd-banco  
           amkt-solicitacao.forma-pagto-conta       = p-forma-pagto-conta     
           amkt-solicitacao.forma-pagto-cpf-cnpj    = p-forma-pagto-cpf-cnpj  
           amkt-solicitacao.forma-pagto-favorecido  = p-forma-pagto-favorecido
           amkt-solicitacao.forma-pagto-nome-banco  = p-forma-pagto-nome-banco
           amkt-solicitacao.forma-pagto-tipo        = p-forma-pagto-tipo      
           amkt-solicitacao.vl-solicitacao          = p-vl-solicitacao
           amkt-solicitacao.payback-dias            = p-payback-dias     
           amkt-solicitacao.indice-aprov            = p-indice-aprov
           amkt-solicitacao.indice-aprov-dias       = p-indice-aprov-dias
           amkt-solicitacao.justificativa-det       = p-justificativa 
           amkt-solicitacao.tipo-fatur              = p-tipo-fatur.

    RUN pi-gera-pend-aprov.

    RELEASE amkt-solicitacao.
    RETURN 'OK':U.
END.

RUN pi-finalizar IN hAcomp.

/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/

FUNCTION fcnSetErro RETURN LOGICAL ( INPUT pPar1 AS CHARACTER, INPUT pPar2 AS CHARACTER ):

    DEFINE VARIABLE iSeqErro    AS INTEGER          NO-UNDO.

    FOR LAST ttErro: 
        ASSIGN iSeqErro = ttErro.SeqErro.  
    END.

    ASSIGN iSeqErro = iSeqErro + 1.
    CREATE ttErro.
    ASSIGN ttErro.SeqErro   = iSeqErro
           ttErro.desc-erro-1 = pPar1
           ttErro.desc-erro-2 = pPar2.

    RETURN TRUE.

END FUNCTION. // fcnSetErro

FUNCTION fcnValidateInsert RETURN CHARACTER ():
    DEFINE VARIABLE iNumReg             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iSolicitacaoNumero  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cVerbasCooperadas   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lErroVC             AS LOGICAL     NO-UNDO.

    ASSIGN lErro = FALSE.

    IF  iSolicitacaoNumero > 0 
    AND NOT CAN-FIND(amkt-solicitacao WHERE amkt-solicitacao.numero = iSolicitacaoNumero) THEN DO:
        fcnSetErro('Solicita‡Æo','Solicita‡Æo informada nÆo est  cadastrada. #AMKT14').
        ASSIGN lErro = TRUE.
    END.
    
    IF lErro THEN
        RETURN 'NOK':U.

    IF p-vl-solicitacao <= 0 THEN DO:
        fcnSetErro('Solicita‡Æo','Valor solicita‡Æo inv lido. #AMKT15').
        ASSIGN lErro = TRUE.
    END.
    
    FOR EACH amkt-solicitacao NO-LOCK WHERE
             amkt-solicitacao.cod-rep          = pCodigoRep AND
             amkt-solicitacao.situacao-comprov = "Pendente de Comprova‡Æo",
        LAST amkt-aprov-pend NO-LOCK WHERE
             amkt-aprov-pend.cd-solicitacao = amkt-solicitacao.numero AND
             amkt-aprov-pend.tipo           = 2: // Comprova‡Æo
        IF DATE(amkt-aprov-pend.dt-situacao) < ADD-INTERVAL(TODAY, -30, 'DAY') THEN DO:
            fcnSetErro('Solicita‡Æo','Solicita‡Æo ' + STRING(amkt-solicitacao.numero) + ' pendente de comprova‡Æo. #AMKT16').
            ASSIGN lErro = TRUE.
            LEAVE.
        END.
    END.

    /* Verifica se o Representante possui pendˆncia financeira a mais de 30 dias */
    ASSIGN lErroVC              = NO
           cVerbasCooperadas    = "".

    FOR FIRST representante
        WHERE representante.cod_empresa = "DOC"
          AND representante.cdn_repres = pCodigoRep NO-LOCK:
    
        FIND FIRST emsuni.fornecedor
             WHERE emsuni.fornecedor.num_pessoa = representante.num_pessoa NO-LOCK NO-ERROR.
    
        IF AVAIL fornecedor THEN DO:
    
            FOR EACH tit_ap OF fornecedor
                 WHERE tit_ap.cod_espec_docto       = "VC"
                   AND tit_ap.log_sdo_tit_ap        = YES
                   AND tit_ap.log_tit_ap_estordo    = NO
                   AND tit_ap.dat_vencto_tit_ap     < TODAY - 30 NO-LOCK
                BREAK BY tit_ap.cod_tit_ap:
                
                IF cVerbasCooperadas <> "" THEN
                    ASSIGN cVerbasCooperadas = cVerbasCooperadas + ", ".

                ASSIGN cVerbasCooperadas = cVerbasCooperadas + STRING(INT(tit_ap.cod_tit_ap)).

                ASSIGN lErroVC = YES.
            END.
        END.
    END.

    IF lErroVC THEN DO:

        fcnSetErro('Representante','possui pendˆncia financeira referente ao(s) adiantamento(s) da(s) Verba(s) Cooperada(s) ' + cVerbasCooperadas + '. Favor entrar em contato com o financeiro DOCOL para regulariza‡Æo. #AMKT17').
        ASSIGN lErro = YES.

    END.

    IF lErro THEN
        RETURN 'NOK':U.
    ELSE
        RETURN 'OK':U.

END FUNCTION. // fcnValidateInsert

PROCEDURE pi-gera-pend-aprov:

    DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.

    RUN dop/mov-pend-solic-mkt.p(INPUT amkt-solicitacao.numero,
                                 INPUT 1, // Tipo: Solicita‡Æo
                                 INPUT "super",
                                 INPUT 0, // nova gera‡Æo de pendˆncias
                                 INPUT "", // observa‡Æo
                                 OUTPUT c-aux).

END PROCEDURE. // pi-gera-pend-aprov

PROCEDURE criaNovaChave:

    DEFINE INPUT  PARAMETER pNumero         AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pCripto         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE rCripto     AS RAW          NO-UNDO.
    DEFINE VARIABLE cFrase      AS CHARACTER    NO-UNDO.

    /* cria guid */
    REPEAT:
        ASSIGN cFrase  = "AMKT" + STRING(pNumero) + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(MTIME).
        ASSIGN rCripto = MD5-DIGEST(cFrase).
        ASSIGN pCripto = HEX-ENCODE(rCripto).

        IF NOT CAN-FIND(amkt-solicitacao WHERE amkt-solicitacao.guid = pCripto) THEN
            LEAVE.
        /*se ja existe, volta e gera uma nova frase com o proximo MTime*/
    END.

END PROCEDURE.

FUNCTION fn-usuar-aprov RETURNS CHARACTER(p-cod-papel AS CHAR):

    IF NOT AVAIL sgv-mercado THEN
        FIND FIRST sgv-mercado NO-LOCK WHERE
                   sgv-mercado.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.

    CASE p-cod-papel:
        WHEN "Diretoria" THEN DO:
            IF AVAIL sgv-mercado AND sgv-mercado.cod-usuar-diretor > "" THEN RETURN sgv-mercado.cod-usuar-diretor.
        END.
        WHEN "Coordena‡Æo Trade" THEN DO:
            IF AVAIL sgv-mercado AND sgv-mercado.cod-usuar-coord-trade > "" THEN RETURN sgv-mercado.cod-usuar-coord-trade.
        END.
        WHEN "Trade do canal" THEN DO:
            IF AVAIL sgv-mercado AND sgv-mercado.cod-usuar-trade > "" THEN RETURN sgv-mercado.cod-usuar-trade.
        END.
        WHEN "Gerˆncia" THEN DO:
            IF AVAIL sgv-mercado AND sgv-mercado.cod-usuar-gerente > "" THEN RETURN sgv-mercado.cod-usuar-gerente.
        END.
        WHEN "Coordenador de Vendas" THEN DO:
            /* FINDs comentados pois j  foram todos feitos no in¡cio das valida‡äes
            FIND FIRST repres NO-LOCK WHERE
                       repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.
            FIND FIRST dc-repres-gestor NO-LOCK WHERE
                       dc-repres-gestor.cod-rep     = repres.cod-rep              AND
                       dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
            FIND FIRST dc-regiao NO-LOCK WHERE
                       dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.*/
            IF AVAIL dc-regiao AND dc-regiao.cod-usuario > "" THEN RETURN dc-regiao.cod-usuario.
        END.
    END CASE.

    RETURN "".

END FUNCTION. // fn-usuar-aprov


PROCEDURE piOrcamento:

def var v_cod_empresa        as char.
def var v_cod_plano_cta_ctbl as char.
def var v_cod_cta_ctbl       as char.
def var v_cod_plano_ccusto   as char.
def var v_cod_ccusto         as char.
def var v_cod_estab          as char.
def var v_cod_unid_negoc     as char.
def var v_dat_transacao      as date.
def var v_cod_finalid_econ   as char.
def var v_val_aprop_ctbl     as dec.    
def var v_num_seq            as int.
def var v_cod_funcao         as char.
def var v_cod_id             as char.
DEF VAR v_orig_movto         AS CHAR.

    FIND FIRST param-global NO-ERROR.
    EMPTY TEMP-TABLE tt_xml_input_1.


    assign v_cod_empresa        =  param-global.empresa-prin
           v_cod_cta_ctbl       = "435362"
           v_cod_ccusto         = dc-regiao.cod-ccusto
           v_cod_estab          = "9" //esta fixo porque, ate a data de 20.09.2019 existe orcamento apenas para este estabelecimento
           v_cod_unid_negoc     = "DOC" 
           v_dat_transacao      = da-valid-orcto
           v_cod_finalid_econ   = "0" /*REFERENTE AO C…DIGO DA FINALIDADE ECONOMICA REAL*/
           v_val_aprop_ctbl     = p-vl-solicitacao
           v_num_seq            = 1
           v_cod_funcao         = "Verifica" 
           v_cod_id             = "Solicitacao MKT"//nao h  descricao, pois o empenho nao ‚ realizado, apenas ‚ feito check
           v_orig_movto         = "92".
    
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Conta Cont bil" /*l_conta_contabil*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_ccusto
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_estab
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_unid_negoc
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Data Movimenta‡Æo" /*l_data_movimentacao*/ 
           tt_xml_input_1.ttv_des_conteudo = string(v_dat_transacao)
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econ“mica" /*l_finalidade_economica*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_finalid_econ
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
           tt_xml_input_1.ttv_des_conteudo = string(v_val_aprop_ctbl)
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
           tt_xml_input_1.ttv_des_conteudo = v_orig_movto
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Fun‡Æo"
           tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
           tt_xml_input_1.ttv_des_conteudo = v_cod_id
           tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
    
    run prgfin/bgc/bgc700za.py (Input 1,
                               input table tt_xml_input_1,
                               output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.
    
        for each tt_log_erros.
            message tt_log_erros.ttv_des_erro  view-as alert-box. /*Mensagem de bloqueio*/
            MESSAGE tt_log_erros.ttv_des_ajuda view-as alert-box. /*Mensagem com o cÿlculo: valor movimento x comprometido*/
        end.
  
END PROCEDURE.

