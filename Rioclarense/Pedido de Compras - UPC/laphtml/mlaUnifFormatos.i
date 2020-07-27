/*******************************************************************************
**   mlaUnifFormatos.i  Include para buscar os formatos usando a API de financas
**
**   Parâmetros:
**   {1} - Código da empresa
**   {2} - Data transação
**
**   - O handle h_api_cta_ctbl e h_api_ccusto devem estar inicializados
**   - A temp-table tt_log_erro deve ser definida
**   - O campo i-empresa precisa estar inicializado
**
**   - As variáveis abaixo devem estar definidas:
**   def var c-formato-conta    as char   no-undo.
**   def var c-formato-ccusto   as char   no-undo.
*******************************************************************************/

    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  {1},                 /* EMPRESA EMS2 */
                                                       input  "",                  /* PLANO CONTAS */
                                                       input  {2},                 /* DATA DE TRANSACAO */
                                                       output c-formato-conta,     /* FORMATO CONTA */
                                                       output table tt_log_erro).  /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  {1},                 /* EMPRESA EMS2 */
                                                   input  "",                  /* PLANO CCUSTO */
                                                   input  {2},                 /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,    /* FORMATO CCUSTO */
                                                   output table tt_log_erro).  /* ERROS */