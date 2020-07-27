/*******************************************************************************
**   mlaUnifBuscaCC.i  Include para consultar o centro de custo usando a API de financas
**
**   Par�metros:
**   {1} - C�digo da empresa
**   {2} - C�digo do centro de custo
**   {3} - Data transa��o
**
**   - O handle h_api_ccusto devem estar inicializado
**   - A temp-table tt_log_erro deve ser definida
**   - O campo i-empresa precisa estar inicializado
**
**   - As vari�veis abaixo devem estar definidas:
**   def var v_titulo_ccusto    as char   no-undo.
*******************************************************************************/

run pi_busca_dados_ccusto in h_api_ccusto (input  {1},                /* EMPRESA EMS2 */
                                           input  "",                 /* CODIGO DO PLANO CCUSTO */
                                           input  {2},                /* CCUSTO */
                                           input  {3},                /* DATA DE TRANSACAO */
                                           output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                           output table tt_log_erro). /* ERROS */                                                