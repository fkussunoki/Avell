/*******************************************************************************
**   mlaUnifBuscaCC.i  Include para consultar o centro de custo usando a API de financas
**
**   Parâmetros:
**   {1} - Código da empresa
**   {2} - Código do centro de custo
**   {3} - Data transação
**
**   - O handle h_api_ccusto devem estar inicializado
**   - A temp-table tt_log_erro deve ser definida
**   - O campo i-empresa precisa estar inicializado
**
**   - As variáveis abaixo devem estar definidas:
**   def var v_titulo_ccusto    as char   no-undo.
*******************************************************************************/

run pi_busca_dados_ccusto in h_api_ccusto (input  {1},                /* EMPRESA EMS2 */
                                           input  "",                 /* CODIGO DO PLANO CCUSTO */
                                           input  {2},                /* CCUSTO */
                                           input  {3},                /* DATA DE TRANSACAO */
                                           output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                           output table tt_log_erro). /* ERROS */                                                