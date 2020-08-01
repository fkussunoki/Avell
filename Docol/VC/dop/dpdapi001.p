{dop\dpd611.i}
def input param p-ccusto             as character no-undo.
def input param p-cod-estab          as character no-undo.
def input param p-cod-unid-negoc     as character no-undo.
def input param p-dat-transacao      as date      no-undo.
def input param p-cod-finalid-econ   as character no-undo.
def input param p-val-apropriacao     as decimal   no-undo.    
def input param p-num-seq            as integer   no-undo.
def input param p-cod-id             as character no-undo.
def input param p-espec-docto        as character no-undo.
def input param p-cod-estab-titulo   as character no-undo.
def input param p-cod-parcela        as character no-undo.
def input param p-serie              as character no-undo.
def input param p-cod-titulo         as character no-undo.

DEFINE OUTPUT PARAM TABLE  FOR tt_log_erros.

def var v_cod_cta_ctbl as char no-undo.
def var v_cod_empresa  as char no-undo.
def var v_cod_funcao   as char no-undo.
def var v_orig_movto   as char no-undo.
DEF VAR i-controle           AS INTEGER.
DEF VAR v_dt           AS DATE NO-UNDO.

assign v_cod_cta_ctbl = "435362". //por ora, nao definido local para informar conta 


    FIND FIRST param-global NO-ERROR.
    EMPTY TEMP-TABLE tt_xml_input_1.
    empty temp-table tt_log_erros.

    FIND FIRST amkt-solicitacao NO-LOCK WHERE amkt-solicitacao.numero = int(p-cod-id) NO-ERROR.
    find first amkt-forma-pagto no-lock where amkt-forma-pagto.cd-forma-pagto = amkt-solicitacao.cd-forma-pagto no-error.

    IF  amkt-forma-pagto.cd-forma-pagto = 3 THEN
    ASSIGN v_dt = amkt-solicitacao.dt-validade-inicial.
    ELSE
        ASSIGN v_dt = amkt-solicitacao.dt-validade-final.

    assign v_cod_empresa        =  param-global.empresa-prin //funciona apenas para docol.
           v_cod_cta_ctbl       = v_cod_cta_ctbl
           v_cod_funcao         = "Estorna" 
           v_orig_movto         = "91".

    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Conta Cont bil" /*l_conta_contabil*/ 
           tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
           tt_xml_input_1.ttv_des_conteudo = p-ccusto
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
           tt_xml_input_1.ttv_des_conteudo = p-cod-estab
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
           tt_xml_input_1.ttv_des_conteudo = p-cod-unid-negoc
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Data Movimenta‡Æo" /*l_data_movimentacao*/ 
           tt_xml_input_1.ttv_des_conteudo = string(v_dt)
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econ“mica" /*l_finalidade_economica*/ 
           tt_xml_input_1.ttv_des_conteudo = p-cod-finalid-econ
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
           tt_xml_input_1.ttv_des_conteudo = string(p-val-apropriacao)
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
           tt_xml_input_1.ttv_des_conteudo = v_orig_movto
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "Fun‡Æo"
           tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
    create tt_xml_input_1.
    assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
           tt_xml_input_1.ttv_des_conteudo = "Solicitacao DPD607 (Pagto)" + string(p-cod-id)
           tt_xml_input_1.ttv_num_seq_1    = p-num-seq.

    
    run prgfin/bgc/bgc700za.py (Input 1,
                               input table tt_xml_input_1,
                               output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.

        find first tt_log_erros no-error.
        if NOT avail tt_log_erros then do:

              FIND FIRST param-global NO-ERROR.
              EMPTY TEMP-TABLE tt_xml_input_1.
              empty temp-table tt_log_erros.
          
                  
          
              assign v_cod_empresa        =  param-global.empresa-prin //funciona apenas para docol.
                     v_cod_cta_ctbl       = v_cod_cta_ctbl
                     v_cod_funcao         = "Verifica" 
                     v_orig_movto         = "91".
              
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Empresa" /*l_empresa*/ 
                     tt_xml_input_1.ttv_des_conteudo = v_cod_empresa
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Conta Cont bil" /*l_conta_contabil*/ 
                     tt_xml_input_1.ttv_des_conteudo = v_cod_cta_ctbl
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Centro Custo" /*l_centro_custo*/ 
                     tt_xml_input_1.ttv_des_conteudo = p-ccusto
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Estabelecimento" /*l_estabelecimento*/ 
                     tt_xml_input_1.ttv_des_conteudo = p-cod-estab
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Unidade Neg¢cio" /*l_unidade_negocio*/ 
                     tt_xml_input_1.ttv_des_conteudo = p-cod-unid-negoc
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Data Movimenta‡Æo" /*l_data_movimentacao*/ 
                     tt_xml_input_1.ttv_des_conteudo = string(p-dat-transacao)
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Finalidade Econ“mica" /*l_finalidade_economica*/ 
                     tt_xml_input_1.ttv_des_conteudo = p-cod-finalid-econ
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Valor Movimento" /*l_valor_movimento*/ 
                     tt_xml_input_1.ttv_des_conteudo = string(p-val-apropriacao)
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Origem Movimento" /*l_orig_movto*/ 
                     tt_xml_input_1.ttv_des_conteudo = v_orig_movto
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "Fun‡Æo"
                     tt_xml_input_1.ttv_des_conteudo = v_cod_funcao
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.
              create tt_xml_input_1.
              assign tt_xml_input_1.ttv_cod_label    = "ID Movimento"
                     tt_xml_input_1.ttv_des_conteudo = "Processo " + string(p-cod-id) + " Utilizado no titulo " + p-espec-docto + "|" + p-serie + "|" + p-cod-titulo +
                                                        "|" + p-cod-parcela + "| Estabelec " + p-cod-estab-titulo
                     tt_xml_input_1.ttv_num_seq_1    = p-num-seq.


              run prgfin/bgc/bgc700za.py (Input 1,
                                         input table tt_xml_input_1,
                                         output table tt_log_erros) /*prg_api_execucao_orcamentaria*/.

      find first tt_log_erros no-error.
      if NOT avail tt_log_erros then do:
         FIND FIRST tt_xml_input_1 NO-LOCK WHERE tt_xml_input_1.ttv_cod_label = "Funcao" NO-ERROR.
    
           ASSIGN  tt_xml_input_1.ttv_des_conteudo = "Atualiza". // Estorna o empenho e depois realiza
           RUN prgfin/bgc/bgc700za.py (input 1,
           input table tt_xml_input_1,
           output table tt_log_erros) .  
    
           find first tt_log_erros no-error.
           if NOT avail tt_log_erros then do:
              return 'ok'.
           end.
    
        
   /*        FIND FIRST tt_xml_input_1 NO-LOCK WHERE tt_xml_input_1.ttv_cod_label = "Funcao" NO-ERROR.
           ASSIGN  tt_xml_input_1.ttv_des_conteudo = "Realiza". // Estorna o empenho e depois realiza
           
           RUN prgfin/bgc/bgc700za.py (input 1,
                                       input table tt_xml_input_1,
                                       output table tt_log_erros) .  
    
                  find first tt_log_erros no-error.
                  if NOT avail tt_log_erros then do:
                                
                  RETURN 'ok'.    
           
                  end.
           end. */
      END.
end.
