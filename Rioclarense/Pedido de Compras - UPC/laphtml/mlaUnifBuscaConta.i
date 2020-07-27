/*******************************************************************************
**   mlaUnifBuscaConta.i  Include para consultar a conta usando a API de financas
**
**   Par�metros:
**   {1} - C�digo da empresa
**   {2} - C�digo da conta
**   {3} - Data transa��o
**
**   - O handle h_api_cta_ctbl e h_api_ccusto devem estar inicializados
**   - A temp-table tt_log_erro deve ser definida
**   - O campo i-empresa precisa estar inicializado
**
**   - As vari�veis abaixo devem estar definidas:
**   def var v_titulo_cta_ctbl    as char   no-undo.
**   def var v_num_tip_cta_ctbl   as int    no-undo.
**   def var v_num_sit_cta_ctbl   as int    no-undo.
**   def var v_ind_finalid_cta    as char   no-undo.
*******************************************************************************/

run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        {1},                /* EMPRESA EMS2 */
                                               input        "",                 /* PLANO DE CONTAS */
                                               input-output {2},                /* CONTA */
                                               input        {3},                /* DATA TRANSACAO */   
                                               output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                               output       v_num_sit_cta_ctbl, /* SITUA��O DA CONTA */
                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                               output table tt_log_erro).