
/////////////////////////////
// Autor: Oliver Fagionato //
/////////////////////////////

{utp/ut-glob.i}

DEFINE INPUT  PARAMETER pSenha             AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCodigoErp         AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-numero           AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-valor            AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-observacao-envio AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opMensagem         AS CHARACTER   NO-UNDO.

DEFINE VARIABLE r-amkt-solic-pagto AS ROWID       NO-UNDO.
DEFINE VARIABLE c-titulos          AS CHARACTER   NO-UNDO.

def temp-table tt_xml_input_1 no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq??ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Número" column-label "Número"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist?ncia" column-label "Inconsist?ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .



/*---------------- Validaá∆o Senha -------------------*/
DEF VAR c-frase AS CHAR.
DEF VAR r-cripto AS RAW.
DEF VAR c-cripto AS CHAR.

ASSIGN c-frase = string(month(TODAY),"99") + "SDV&2.0" + string(YEAR(TODAY)) + string(pCodigoErp).
ASSIGN r-cripto = md5-DIGEST(c-frase).
ASSIGN c-cripto = HEX-ENCODE(r-cripto). 

IF c-cripto <> pSenha THEN DO:
    ASSIGN opMensagem = "Tente Novamente! #AMKT18".
    RETURN "NOK".
END.
/*---------------- (erro) Validaá∆o Senha -------------------*/

RUN pi-valida.
IF RETURN-VALUE <> "OK" THEN RETURN "NOK".

RUN pi-cria-solic-pagto.

RUN pi-gera-pend-aprov.
IF RETURN-VALUE <> "OK" THEN RETURN "NOK".

RETURN "OK".

/////////////////////////
// P R O C E D U R E S //
/////////////////////////

PROCEDURE pi-cria-solic-pagto:

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST amkt-solic-pagto NO-LOCK WHERE
              amkt-solic-pagto.numero     = p-numero AND
              amkt-solic-pagto.sequencia >= 0        NO-ERROR.
    ASSIGN i-sequencia = IF AVAIL amkt-solic-pagto THEN amkt-solic-pagto.sequencia + 1 ELSE 1.
    
    CREATE amkt-solic-pagto.
    ASSIGN amkt-solic-pagto.numero           = p-numero
           amkt-solic-pagto.sequencia        = i-sequencia
           amkt-solic-pagto.data-envio       = NOW
           amkt-solic-pagto.situacao-pagto   = 1 // Pendente
           amkt-solic-pagto.observacao-envio = p-observacao-envio
           amkt-solic-pagto.valor            = p-valor.

    ASSIGN r-amkt-solic-pagto = ROWID(amkt-solic-pagto).

    RELEASE amkt-solic-pagto NO-ERROR.

END PROCEDURE. // pi-cria-solic-pagto

PROCEDURE pi-valida:

    DEF BUFFER b-amkt-solicitacao FOR amkt-solicitacao.

    DEFINE VARIABLE lErroVC      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-orcado    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-realizado AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-empenhado AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-erro       AS CHARACTER   NO-UNDO.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE
               amkt-solicitacao.numero = p-numero NO-ERROR.
    IF NOT AVAIL amkt-solicitacao THEN DO:
        ASSIGN opMensagem = "Solicitaá∆o n∆o encontrada. #AMKT19".
        RETURN "NOK".
    END.
    
    IF amkt-solicitacao.situacao-pagto <> "Solicitaá∆o Pagto. Liberada" THEN DO:
        ASSIGN opMensagem = "Solicitaá∆o n∆o est† pendente de pagamento. #AMKT20".
        RETURN "NOK".
    END.
    
    FIND FIRST amkt-solic-pagto NO-LOCK WHERE
               amkt-solic-pagto.numero = amkt-solicitacao.numero AND
               (amkt-solic-pagto.situacao-pagto = 1 /* Pendente */ OR amkt-solic-pagto.situacao-pagto = 2 /* Aprovada */ ) NO-ERROR.
    IF AVAIL amkt-solic-pagto THEN DO:
        ASSIGN opMensagem = "J† existe pendància de pagamento pendente ou aprovada. #AMKT21".
        RETURN "NOK".
    END.
    
    IF p-valor = ? OR p-valor <= 0 THEN DO:
        ASSIGN opMensagem = "Valor inv†lido. #AMKT22".
        RETURN "NOK".
    END.

    /* Comentado em 12/07/2019
    IF p-valor > amkt-solicitacao.vl-solicitacao * 1.1 THEN DO:
        ASSIGN opMensagem = "Valor superior ao aprovado. #AMKT23". // "N∆o pode ultrapassar em 10% o Valor da Solicitaá∆o.".
        RETURN "NOK".
    END.
    */

    /*IF p-observacao-envio = ? OR TRIM(p-observacao-envio) = "" THEN DO:
        ASSIGN opMensagem = "Observaá∆o do Envio n∆o foi informada.".
        RETURN "NOK".
    END.*/

    FIND FIRST amkt-forma-pagto NO-LOCK WHERE
               amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto NO-ERROR.

    IF AVAIL amkt-forma-pagto AND amkt-forma-pagto.tipo-pagto = 3 /* Adiantamento */ THEN DO:
        FOR EACH b-amkt-solicitacao NO-LOCK WHERE
                 b-amkt-solicitacao.cod-rep           = amkt-solicitacao.cod-rep AND
                 b-amkt-solicitacao.dt-validade-final < TODAY AND
                 b-amkt-solicitacao.log-cancela       = NO,
            FIRST amkt-solic-pagto NO-LOCK WHERE
                  amkt-solic-pagto.numero         = b-amkt-solicitacao.numero AND
                  amkt-solic-pagto.situacao-pagto = 1: // Pendente
    
            ASSIGN opMensagem = "Representante j† possui Solicitaá∆o de Pagamento pendente de aprovaá∆o. Solicitaá∆o " + STRING(b-amkt-solicitacao.numero) + ". #AMKT24".
            RETURN "NOK".
        END. // EACH b-amkt-solicitacao, FIRST amkt-solic-pagto
    END.

     /* Verifica se o Representante possui pendància financeira a mais de 30 dias */
    ASSIGN lErroVC              = NO.

    ASSIGN c-titulos = "".
    FOR FIRST representante
        WHERE representante.cod_empresa = "DOC"
          AND representante.cdn_repres = pCodigoErp NO-LOCK:
    
        FIND FIRST emsuni.fornecedor
             WHERE emsuni.fornecedor.num_pessoa = representante.num_pessoa NO-LOCK NO-ERROR.
    
        IF AVAIL fornecedor THEN DO:
    
            FOR EACH tit_ap OF fornecedor
                 WHERE tit_ap.cod_espec_docto       = "VC"
                   AND tit_ap.log_sdo_tit_ap        = YES
                   AND tit_ap.log_tit_ap_estordo    = NO
                   AND tit_ap.dat_vencto_tit_ap     < TODAY - 30 NO-LOCK
                BREAK BY tit_ap.cod_tit_ap:
                
                IF c-titulos <> "" THEN
                    ASSIGN c-titulos = c-titulos + ", ".

                ASSIGN c-titulos = c-titulos + STRING(INT(tit_ap.cod_tit_ap)).

                ASSIGN lErroVC = YES.
            END.
        END.
    END.

    IF lErroVC THEN DO:
        // Chamado 91473 - Corrigida mensagem abaixo
        ASSIGN opMensagem = "Representante possui pendància financeira referente ao(s) adiantamento(s) da(s) Verba(s) Cooperada(s) "
                          + c-titulos
                          + ". Favor entrar em contato com o financeiro DOCOL para regularizaá∆o. #AMKT25". 
        RETURN "NOK".
    END.

    FIND FIRST repres NO-LOCK WHERE
               repres.cod-rep = amkt-solicitacao.cod-rep NO-ERROR.
    IF NOT AVAIL repres THEN DO:
        ASSIGN opMensagem = "Representante da Solicitaá∆o Mkt n∆o encontrado. #AMKT26".
        RETURN "NOK".
    END.
    
    FIND FIRST emitente NO-LOCK WHERE
               emitente.cod-emitente = amkt-solicitacao.cod-emitente NO-ERROR.
    IF NOT AVAIL emitente THEN DO:
        ASSIGN opMensagem = "Cliente da Solicitaá∆o Mkt n∆o foi encontrado. #AMKT27".
        RETURN "NOK".
    END.
    
    FIND FIRST sgv-seg-mercado NO-LOCK WHERE
               sgv-seg-mercado.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
    IF NOT AVAIL sgv-seg-mercado THEN DO:
        ASSIGN opMensagem = "Mercado n∆o encontrado. #AMKT28".
        RETURN "NOK".
    END.
    
    FIND FIRST dc-repres-gestor NO-LOCK WHERE
               dc-repres-gestor.cod-rep     = repres.cod-rep              AND
               dc-repres-gestor.cod-mercado = sgv-seg-mercado.cod-mercado NO-ERROR.
    IF NOT AVAIL dc-repres-gestor THEN DO:
        ASSIGN opMensagem = "Gestor n∆o encontrado. #AMKT29".
        RETURN "NOK".
    END.
    
    FIND FIRST dc-regiao NO-LOCK WHERE
               dc-regiao.nome-ab-reg = dc-repres-gestor.cod-gestor NO-ERROR.
    IF NOT AVAIL dc-regiao THEN DO:
        ASSIGN opMensagem = "Centro de Custo n∆o encontrado. #AMKT30".
        RETURN "NOK".
    END.

    run pi-execucao-orcamentaria(OUTPUT TABLE tt_log_erros).

    FIND FIRST tt_log_erros NO-ERROR.

    IF AVAIL tt_log_erros THEN DO:

        ASSIGN opMensagem = tt_log_erros.ttv_des_ajuda.
        RETURN 'nok'.
    END.

    // Chamado 90879 - trocado amkt-solicitacao.dt-validade-final por TODAY nos parÉmetros abaixo
 /**   RUN gsp/api/api001bgc.p(INPUT  STRING(YEAR(TODAY)),  // Exercicio Cont†bil(Ano)                               - P_Cod_Exerc_Ctbl
                            INPUT  MONTH(TODAY),         // Per°odo(Màs)                                          - P_Num_Period_Ctbl
                            INPUT  "435362",             // Conta Cont†bil                                        - P_Cod_Cta_Ctbl
                            INPUT  dc-regiao.cod-ccusto, // Centro de Custo                                       - P_Cod_Ccusto
                            INPUT  "Per°odo",            // Abrangencia Pesquisa(Exercicio = Ano e Per°odo = Màs) - P_Ind_Tip_Pesq
                            OUTPUT de-orcado,            // Valor Oráado                                          - P_Val_Orcado_Sdo
                            OUTPUT de-realizado,         // Valor Realizado                                       - P_Val_Sdo_Ctbl_Fim
                            OUTPUT de-empenhado,         // Valor Empenhado                                       - P_Val_Movto_Empenh
                            OUTPUT c-erro).              // Retorno de poss°veis erros, separados por ";"         - P_Retorn_Error
    IF (p-valor + de-realizado + de-empenhado) > de-orcado THEN DO:
        ASSIGN opMensagem = "N∆o Aprovado. Para esta solicitaá∆o, gentileza contatar seu gestor. #AMKT31".
        RETURN "NOK".
    END.

    RETURN "OK".
*/
END PROCEDURE. // pi-valida

procedure pi-execucao-orcamentaria:
    def var v_cod_empresa        as character.
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
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erros.

    
    
        FIND FIRST param-global NO-ERROR.
        EMPTY TEMP-TABLE tt_xml_input_1.
        empty temp-table tt_log_erros.

        find first amkt-solicitacao no-lock where amkt-solicitacao.numero = p-numero no-error.

        find first amkt-forma-pagto no-lock where amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto no-error.

        if amkt-forma-pagto.cd-forma-pagto = 3 then
        assign v_dat_transacao = amkt-solicitacao.dt-validade-inicial.
        else 
        assign v_dat_transacao = amkt-solicitacao.dt-validade-final.
    
    
        assign v_cod_empresa        =  param-global.empresa-prin
               v_cod_cta_ctbl       = "435362"
               v_cod_ccusto         = dc-regiao.cod-ccusto
               v_cod_estab          = "9" //esta fixo porque, ate a data de 20.09.2019 existe orcamento apenas para este estabelecimento
               v_cod_unid_negoc     = "DOC" 
               v_cod_finalid_econ   = "0" /*REFERENTE AO CÖDIGO DA FINALIDADE ECONOMICA REAL*/
               v_val_aprop_ctbl     = p-valor
               v_num_seq            = 1
               v_cod_funcao         = "estorna" 
               v_cod_id             = "Solicitacao DPD607 " + string(p-numero) //nao h† descricao, pois o empenho nao Ç realizado, apenas Ç feito check
               v_orig_movto         = "90".
        
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
               tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Conta Cont†bil" /*l_conta_contabil*/ 
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
        assign tt_xml_input_1.ttv_cod_label    = "Data Movimentaá∆o" /*l_data_movimentacao*/ 
               tt_xml_input_1.ttv_des_conteudo = string(v_dat_transacao)
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econìmica" /*l_finalidade_economica*/ 
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
        assign tt_xml_input_1.ttv_cod_label    = "Funá∆o"
               tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
               tt_xml_input_1.ttv_des_conteudo = v_cod_id
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        
        run prgfin/bgc/bgc700za.py (Input 1,
                                   input table tt_xml_input_1,
                                   output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.
    
        EMPTY TEMP-TABLE tt_xml_input_1.
        empty temp-table tt_log_erros.


        assign v_cod_empresa        =  param-global.empresa-prin
               v_cod_cta_ctbl       = "435362"
               v_cod_ccusto         = dc-regiao.cod-ccusto
               v_cod_estab          = "9" //esta fixo porque, ate a data de 20.09.2019 existe orcamento apenas para este estabelecimento
               v_cod_unid_negoc     = "DOC" 
               v_cod_finalid_econ   = "0" /*REFERENTE AO CÖDIGO DA FINALIDADE ECONOMICA REAL*/
               v_val_aprop_ctbl     = p-valor
               v_num_seq            = 1
               v_cod_funcao         = "verifica" 
               v_cod_id             = "Solicitacao DPD607 (Pagto)" + string(p-numero) //nao h† descricao, pois o empenho nao Ç realizado, apenas Ç feito check
               v_orig_movto         = "91".
        
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
               tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Conta Cont†bil" /*l_conta_contabil*/ 
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
        assign tt_xml_input_1.ttv_cod_label    = "Data Movimentaá∆o" /*l_data_movimentacao*/ 
               tt_xml_input_1.ttv_des_conteudo = string(v_dat_transacao)
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econìmica" /*l_finalidade_economica*/ 
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
        assign tt_xml_input_1.ttv_cod_label    = "Funá∆o"
               tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        create tt_xml_input_1.
        assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
               tt_xml_input_1.ttv_des_conteudo = v_cod_id
               tt_xml_input_1.ttv_num_seq_1    = v_num_seq.
        
        run prgfin/bgc/bgc700za.py (Input 1,
                                   input table tt_xml_input_1,
                                   output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.

        find first tt_log_erros no-error.
        if NOT avail tt_log_erros then do:
    
    FIND FIRST tt_xml_input_1 NO-LOCK WHERE tt_xml_input_1.ttv_cod_label = "Funcao" NO-ERROR.
    ASSIGN  tt_xml_input_1.ttv_des_conteudo = "Atualiza".
    
    RUN prgfin/bgc/bgc700za.py (input 1,
                                input table tt_xml_input_1,
                                output table tt_log_erros) .  
    RETURN 'ok'.    
    END.

       

end procedure.

PROCEDURE pi-gera-pend-aprov:

    DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.

    RUN dop/mov-pend-solic-mkt.p(INPUT p-numero,
                                 INPUT 3, // Tipo: Pagamento
                                 INPUT c-seg-usuario,
                                 INPUT 0, // nova geraá∆o de pendàncias
                                 INPUT p-observacao-envio, // observaá∆o
                                 OUTPUT c-aux).
    IF c-aux > "" THEN DO:
        ASSIGN opMensagem = c-aux.
        FIND FIRST amkt-solic-pagto EXCLUSIVE-LOCK WHERE
                   ROWID(amkt-solic-pagto) = r-amkt-solic-pagto NO-ERROR.
        IF AVAIL amkt-solic-pagto THEN DELETE amkt-solic-pagto.
        RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE. // pi-gera-pend-aprov

