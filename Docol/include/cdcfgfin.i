/**********************************************************************************
**    Include : CDGFGFIN.i
**    Objetivo: Tratamento de Miniflexibilizacao para todas as releases
***********************************************************************************/


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 5.03 */
&glob BF_FIN_INSS_SALARIO_BASE       /* Controlar Limite INSS por Sal�rio de Contribui��o EMS5 */
&glob BF_FIN_LIQ_CAMBIO_ESTAT_CLI    /* Tratar Informa��es p/ Estat�stica do Cliente no C�mbio */
&glob BF_FIN_DEDUC_BASE_CALC_IMPTO   /* Dedu��o da Base de C�lculo do Imposto - EMS5 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 5.04 */
&glob BF_FIN_CANCEL_VARREDURA   /* Varredura - Melhorias Usabilidade */
&glob BF_FIN_MELHORIA_SPED      /* IPP: Melhorias na Extra��o e Gera��o do SPED Cont�bil EMS2 E EMS5 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 5.05 */
&glob BF_FIN_SEGUR_DEMONST_MGL
&glob BF_FIN_VALIDA_SEQUENCE
&glob BF_CONTROL_ID_FEDER
&glob BF_FIN_APROP_CTBL_TRANSF
&glob BF_FIN_ISOL_DCF_DCU
&glob BF_GERAC_CTA_CTBL_CTA_REDUZIDA
&glob BF_FIN_REPLIC_PERIOD_CTBL
&glob BF_FIN_GERAR_ANTECIP_NCONT
&glob BF_FIN_ACUM_PAGTO
&glob BF_FIN_ALTER_CODIGO_BARRA
&glob BF_FIN_ESTATIS_CLIEN_FINANCEIRO
&glob BF_ATUALIZ_HORA_PROCES_PAGTO
&glob FNC_EXEC_ATZ_LOTE_LIQUIDAC
&glob BF_FIN_ELIMINAC_APB
&glob BF_FIN_ELIMINAC_CFL_HISTOR
&glob BF_FIN_ELIMINAC_CMG_HISTOR
&glob BF_FIN_ELIMINAC_GLD_HISTOR
&glob BF_FIN_CALC_DT_VECTO_COBR
&glob BF_FIN_NOVOS_CONS_RELAT_CFL
&glob BF_FIN_COMP_REPLIC_CLIEN_FORNEC_REPRES
&glob BF_FIN_CONCIL_CTBL_APB
&glob BF_FIN_CTBZ_POR_CCUSTO
&glob BF_FIN_CONTAB_MODUL_50_20
&glob BF_FIN_DAT_INIC_MOVTO_CTA_CORREN
&glob BF_FIN_DESTINA_TITULO_VENCIDO
&glob BF_FIN_ELIMINA_DADOS_HISTORICOS_ACR
&glob BF_FIN_ENDER_COBR_CONTAT_SCO
&glob BF_FIN_ISOL_EMS5
&glob BF_FIN_COTACOES
&glob BF_FIN_ORIG_RECLASS_BEM
&glob BF_FIN_EXEC_MAPA_DISTRIB_GERENC
&glob BF_FIN_EXCL_BEM_BAIXA
&glob BF_FIN_ELIMINA_SALDO_BEM
&glob BF_FIN_ITEM_BORD_REFER
&glob BF_SEGUR_UFC
&glob BF_FIN_IMPORT_ASCII_INTER
&glob BF_FIN_HISTOR_VERS_CHEQ
&glob BF_FIN_QT_BEM
&glob BF_FIN_QUANT_BEM
&glob BF_FIN_COMPOS_TOTAL_FLUXO_CX
&glob BF_FIN_INF_COTACAO_ACR
&glob BF_FIN_INF_COT_APB
&glob BF_FIN_INF_DIRF_APB
&glob BF_FIN_FAVOR_CH_ADM
&glob BF_INTEGAPLMEC
&glob BF_CALCJURLIN
&glob BF_INTEGAPLEMS2
&glob BF_FIN_TESOURARIA_EMS5
&glob BF_FIN_INT_COTAC_MG
&glob BF_FIN_INTEGR_REPRES_EMS
&glob BF_ORCTO_FLUXO
&glob BF_FIN_LIQ_TIT_ACR_COBR_ESPEC
&glob BF_FIN_ANT_PEDVDA
&glob BF_FIN_VER_SOFRE_CAL
&glob BF_FIN_CONCIL_CTA_CORREN
&glob BF_FIN_MELHOR_INTEGR_NOM_ABREV
&glob BF_UTILIZA_RATEIO_UN
&glob BF_CLASSIF_REL
&glob BF_FIN_CONTROL_ID_FEDER
&glob BF_FIN_TRAT_CURVA_ABC
&glob BF_FIN_TRAT_PERDA_DEDUTIVEL
&glob BF_FIN_MIGRACAO_GLD
&glob BF_FIN_MULTI_SELECT_UNIAO
&glob BF_FIN_CANCEL_CTBL_FAIXAS
&glob BF_FIN_DESC_PROPOR
&glob BF_FIN_HABILITA_REGISTRO_CORPORATIVO
&glob BF_FIN_REL_CONTEXT_TIT_AP
&glob BF_FIN_RENUMERACAO_BENS
&glob BF_FIN_INTEGR_ESPEC_DOCTO_APB
&glob BF_FIN_INTEGR_ESPEC_DOCTO_ACR
&glob BF_FIN_GRP_CLIEN
&glob BF_FIN_INTEGR_GRP_FORNEC
&glob BF_FIN_MOEDA
&glob BF_FIN_INTEGR_PREV_INFLAC
&glob BF_FIN_REPLIC_RESTRIC_FGL
&glob BF_FIN_TIP_CALC_JUROS
&glob BF_FIN_TRANSF_ESTAB_OPER_FINANC
&glob BF_FIN_VALID_UF
&glob BF_FIN_RAZAO_GRUPO_CONTA
&glob BF_ADM_FIN_PROJ
&glob BF_FIN_ADM_FIN_PROJ
&glob BF_FIN_4LINHAS_END
&glob BF_FIN_COD_ENTRADA_CTBL
&glob BF_FIN_DOCTO_CHEQUE
&glob BF_FIN_DOCTOS_CHEQUE
&glob BF_EXEC_ORCTARIA
&glob BF_FIN_EXEC_ORCTARIA
&glob BF_FIN_MODUL_CAMBIO
&glob BF_FIN_METOD_REDUC_SDO      /* Fun��o Redu��o de Saldo - Foresight */
&glob BF_FIN_CO_NUMBER            /* Fun��o N�mero do Pedido Venda  no ACR - Foresight */
&glob BF_FIN_PO_NUMBER            /* Fun��o N�mero do Pedido Compra no APB - Foresight */
&glob BF_FIN_AGING_ACR            /* Fun��o Resumo Aging no Tit em Aberto  - Foresight */
&glob BF_FIN_AGING_APB            /* Fun��o Resumo Aging no Tit em Aberto  - Foresight */
&glob BF_FIN_GL_POSTING_DETAILS   /* Fun��o Rastreabilidade de movtos ctbl - Foresight */
&glob BF_FIN_MEC_FUT_CFL5         /* C�mbio futuro versus fluxo de caixa e varia��o */
&glob BF_FIN_MELHORIA_GFIP        /* IPP: Exportar Informa��es de INSS para GFIP EMS5 */
&glob BF_FIN_MELHORIA_IN87        /* IPP: Gera��o Arquivo Notas Fiscais de Servi�o para INSS EMS5 */
&glob BF_FIN_DDA_EMS5             /* IPP: DDA EMS5 */
&glob BF_FIN_EST_COM_REC          /* IPP: Estorno Comiss�es x REC */
&glob BF_FIN_DIRF_2011            /* CANCELAR PREVIS�ES POR LOTE */
&glob BF_FIN_MEMORIA_CALCULO_APL
&glob BF_FIN_MELHORIA_ABERT_DIA
&glob BF_FIN_IMPTO_REGRA_FUNDOS
&glob BF_FIN_INTEGR_APL_APB
&glob BF_FIN_SEP_CTBL_JUROS_PRINC_APL
&glob BF_FIN_CORR_DIA_ANTERIOR
&glob BF_FIN_VALOR_PREVISTO
&glob BF_FIN_ARMAZENAR_VALOR_FINALID   /* Fun��o Armazenar os valores referentes as apropria��es cont�beis em todas as finalidades econ�micas que armazenam valor nos m�dulos */
&glob BF_FIN_INF_COTAC_APL
&glob BF_FIN_VENCTO_DIAS_UTEIS         /* Fun��o determinar os vencimentos das parcelas sempre em dias �teis */ 
&glob BF_FIN_INTEGR_PV_FLUXO_CX        /* CFL - Integra��o Fluxo de Caixa x Previs�o de Vendas */
&glob BF_FIN_INTEGR_PD_FLUXO_CX        /* CFL - Integra��o Fluxo de Caixa x Pedidos */
&glob BF_FIN_MEL_ACR                   /* IPP: Melhorias no Contas a Receber EMS5 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 5.06 */
&glob BF_FIN_AGRUPA_PELO_CODIGO_FORNEC      /* APB - Agrupar o Cheque pelo C�digo do Fornecedor */
&glob BF_FIN_ALTER_COR_TIT_VENDOR           /* Alterar Cor Browser Consulta T�tulos em Aberto */
&glob BF_FIN_ALTER_VIA_ASCII                /* Importa��o ASCII Cliente/Fornecedor */
&glob BF_FIN_ALTERA_DATA_PREVISAO           /* Permitir Alterar a Data da Previs�o */
&glob BF_FIN_ALTERA_PORTADOR_ACR            /* ACR - Altera��o Portador da Liquida��o */
&glob BF_FIN_APB_API_FATURA                 /* API Substitui��o de Notas por Duplicatas */
&glob BF_FIN_API_DEPREC                     /* API de Deprecia��o de Bens */
&glob BF_FIN_APL_CONCILIACAO_SALDO          /* Gera��o de Apropria��o/Movimentos em Outras Moedas */
&glob BF_FIN_APL_CORREC_CAMBIO              /* Corre��o Financeira para Contratos de C�mbio */
&glob BF_FIN_APRESENTA_MEDIA_ATRASOS        /* ACR - Apresentar a M�dia na Estat�stica Clientes */
&glob BF_FIN_ATUALIZ_ESTORN_OPER_FIN        /* Envio/Retorno/Desconto/Abatimento da Cobran�a Descont. */
&glob BF_FIN_ATZ_RATEIO_SEQUENCIA           /* Atualiza��o de Rateios em Sequ�ncia */
&glob BF_FIN_AUTORIZ_COBR_CARTAO_CR         /* Implantar T�tulos Especiais com C�digo de Autoriza��o */
&glob BF_FIN_BAIXA_ESTAB_TIT                /* Lote Pagamento Multi-estabelecimento - APB */
&glob BF_FIN_BCOS_HISTORICOS                /* Bancos Hist�ricos - Caixa e Bancos/Contas a Pagar/Contas a Receber */
&glob BF_FIN_BLOQUEIO_ORCAMENTO             /* Informar Par�metro de Bloqueio Or�ament�rio */
&glob BF_FIN_BXA_BEM_MANUF                  /* Enviar Movto Transf. de Bem entre Estab. - Manufatura */
&glob BF_FIN_CALCULO_DESCONTO               /* APB - Recalculo Desconto no AVA de Titulos */
&glob BF_FIN_CC_UN_ADTO                     /* Inclus�o Centro Custo e Unidade Neg�cio no Adiantamento */
&glob BF_FIN_CCUSTO_DEVOLUCAO               /* ACR - Centro de Custo Devolu��o de Vendas */
&glob BF_FIN_CMG_REAPROV_CHEQUE             /* CMG - Reaproveitamento N�mero de Cheque */
&glob BF_FIN_COBR_ESCR_SEM_REG              /* ACR - Cobran�a escritural sem registro */
&glob BF_FIN_COD_BAR_AN_APB                 /* Pagamento Escritural Antecipa��es com C�digo de Barra */
&glob BF_FIN_COD_BARRAS_CTA_CONSUMO         /* Pagamento de Contas de Consumo Via Pagamento Escritural */
&glob BF_FIN_COMIS_AGENTE_MEC               /* Comiss�es Agentes Externos */
&glob BF_FIN_COMPL_CC                       /* CMG - Imprimir Nome Abrev da Cta. Corrente */
&glob BF_FIN_COMPL_HISTOR                   /* APB ACR - Hist�rico Fornecedor/Cliente */
&glob BF_FIN_CONCESSAO_ABATIMENTO           /* Intru��o de Concess�o de Abatimento x Antecipa��o */
&glob BF_FIN_CONCIL_CONSOLID                /* Relat�rio de Concilia��o da Consolida��o */
&glob BF_FIN_CONCIL_DNI_DESCONTO            /* Relat�rio de DNI Considerando Desconto */
&glob BF_FIN_CONCIL_EMPENH                  /* Concilia��o de Saldos Empenhados */
&glob BF_FIN_CONSID_JUROS_MULTA             /* Considera Juros e Multa T�tulos em Aberto */
&glob BF_FIN_CONSOLID_CC                    /* Consolida��o por Centro Custo - Demonstrativo de V�deo */
&glob BF_FIN_CONSOLID_UNID_ORCTARIA         /* Consolida��o de Unidade Or�ament�ria */
&glob BF_FIN_CONSULT_DADO_BEM               /* Consultar Dados do Bem a Partir de Faixa de Sele��o */
&glob BF_FIN_CONT_COMIS_REN                 /* Controle de Comiss�es na Renegocia��o */
&glob BF_FIN_CONTABIL_UN_ESTABEL            /* Contabiliza��o APL por UN e Estabelecimento */
&glob BF_FIN_COPIA_RATEIO_PAG_PADRAO        /* Op��o C�pia de Rateio do Pagamento Padr�o */
&glob BF_FIN_CORREC_AN_JUROS_VDR            /* Corre��o de Antecipa��es Vendor Geradas por Devolu��o */
&glob BF_FIN_COTAC_CALC_VARIAC_ECON         /* Cota��o C�lculo Varia��o Econ�mico */
&glob BF_FIN_COTAC_TRANSF_VALORES           /* Solicitar Cota��o na Transfer. Valores entre Ctas Crtes */
&glob BF_FIN_CRIA_LOTE_ESTAB_TIT            /* ACR - Atualiza��o de t�tulos no estabelecimento da impl */
&glob BF_FIN_CRM                            /* CRM - Disponibilizar Titulos a Pagar/Receber EMS 5 */
&glob BF_FIN_CTBZ_DESP_RECTA_VAR_CAMB       /* APL - Separa��o Despesa e Receita de Varia��o Cambial */
&glob BF_FIN_CTBZ_IMPL_BEM_IMOB             /* Contabiliza��o Deprecia��o Implanta��o Bem Imobilizado */
&glob BF_FIN_DADOS_FUNCIONARIO              /* Incluir funcion�rio,conta,ag�ncia na integra��o EEC/APB */
&glob BF_FIN_DECIMAIS_TAXA_CLIENTE          /* Tratar Arredondamento com Base nas Decimais Taxa Client */
&glob BF_FIN_DEMONST_EM_LOTE                /* API que Retorna os Dados Gerados no Demonstrativo */
&glob BF_FIN_DEPR_AGRO                      /* Deprecia��o de Bens - Agroind�stria */
&glob BF_FIN_DESC_ABAT_OPER_FIN             /* Envio/Retorno/Desconto/Abatimento da Cobran�a Descont. */
&glob BF_FIN_DESC_ESCRIT                    /* Desconto Escritural */
&glob BF_FIN_DESCAPTALIZACAO_APL            /* Tratar Taxa ao Ano Para 252 Dias */
&glob BF_FIN_DESTINAC_PERCENT_SDO_TITULOS   /* Considera Saldo em Cobran�a destina��o */
&glob BF_FIN_DETALHAR_POR_BEM               /* Demonstrativo Cont�bil Detalhado por Bem */
&glob BF_FIN_DIAR_PATRIM                    /* Di�rio do Ativo Fixo */
&glob BF_FIN_DIAS_VENCTO_TIT_SCI            /* ACR - Dias Vencimento Gera��o Dados para SCI */
&glob BF_FIN_DT_VENCTO_IR                   /* APB - Vincular Impostos na Incl.T�tulos */
&glob BF_FIN_ELIMINA_TIT_RELAC              /* Implementa��es na Rotina de Elimina��o de T�tulos */
&glob BF_FIN_EMIS_BALANCT_POR_ESTRUT        /* Emitir Balancete por Estrutura */
&glob BF_FIN_EMIT_AGRO                      /* Atualizar Fornecedor no PIMS Cfe Ramo de Atividade */
&glob BF_FIN_EMP_AUTO_CAD_FORN_CLI          /* Parametrizar Empresa na Integr. EMS2 X 5 */
&glob BF_FIN_ENDER_COBR_CONT_CLI            /* Endere�o Cobran�a Migra��o Clientes MAGNUS */
&glob BF_FIN_ESTORN_ELETRON_CARTCRED_SCO    /* Estorno Eletr�nico de Cart�o de Cr�dito */
&glob BF_FIN_ESTORNAR_ACUM_PAGTO            /* Atualiza��o Acumulados Pelo Estorno de Movimentos */
&glob BF_FIN_ESTORNO_COM_DESPESA            /* ACR - Estorno de Desconto com Despesa */
&glob BF_FIN_ESTORNO_COM_REEMBOLSO          /* APB - Estorno com reembolso no retorno da escritural */
&glob BF_FIN_ESTORNO_REEMBOLSO_ACR          /* ACR - Estorno com Reembolso */
&glob BF_FIN_FACTORING_APB                  /* Tratamento de Factoring no Contas a Pagar */
&glob BF_FIN_FAIXA_ESTAB_RELAT_CALC         /* FAS - Faixa estab.no relat�rio de c�lculos do per�odo */
&glob BF_FIN_FAIXA_FORNEC_ORIGEM            /* Sele��o de Fornecedor Origem no Imposto a Recolher */
&glob BF_FIN_FAIXA_MATR_TIT_ABER_APB        /* T�tulos em Aberto no APB por Matriz */
&glob BF_FIN_FAIXA_SEL_IMPORT_DOCUM         /* Faixa de Sele��o na Importa��o Documentos - FAS */
&glob BF_FIN_FAS_INV_API                    /* Atualiza��es Autom�ticas do Processo de Invent�rio */
&glob BF_FIN_FGL_TOT_RELAT_LOTES            /* Implementar Totais no Relat�rio Lotes */
&glob BF_FIN_FUNRURAL_EMS5                  /* Tratamento do Funrural - EMS5 */
&glob BF_FIN_GERA_CTA_SEQ                   /* Gera��o Plano de Contas Sequencial EMS5 x EMS2 */
&glob BF_FIN_GERA_MOV_EXTRATO               /* Sele��o Movimentos Extrato para Gera��o Conta Corrente */
&glob BF_FIN_GPS                            /* Gera��o Arquivo GPS - INSS */
&glob BF_FIN_GRUPO_FORNECEDOR_CLIENTE       /* APB - Selecionar e Classif por Grupo Fornec/Cliente/Rep */
&glob BF_FIN_HIS_DT_PROX                    /* Hist�rico e Data Pr�x Contato no Mov de Cobran�a no ACR */
&glob BF_FIN_HISTOR_ORIG_CMG_DNI            /* Hist�rico Original do CMG na Gera��o de DNI�s */
&glob BF_FIN_IMPRIME_HISTORICO_BORDERO      /* APB - Imprimir o hist�rico do Bordero do PEF */
&glob BF_FIN_IMPRIME_HISTORICO_ITEM_CHEQUE  /* APB - Imprimir o hist�rico do PEF */
&glob BF_FIN_INTEGR_AP_BGC_VARIAS_CTAS      /* Integrar T�tulos Contas a Pagar com V�rias Contas BGC */
&glob BF_FIN_INTEGR_APB5_INV2               /* Integra��o APB X Investimentos EMS 2 */
&glob BF_FIN_INTEGR_MANUFATURA              /* Enviar Movto Transf. de Bem entre Estab. - Manufatura */
&glob BF_FIN_INTEGR_MEC_EMS5                /* Consulta Contrato de C�mbio Importa��o e Exporta��o */
&glob BF_FIN_INTEGRIDADE_CLIEN_FORNEC       /* Replicar Nome Abreviado Fornecedor/Cliente */
&glob BF_FIN_IR_SUBST_DUP                   /* Impostos da Substitui��o de Notas por Duplicatas */
&glob BF_FIN_IRCOOPERATIVAS                 /* IR Cooperativas */
&glob BF_FIN_JUROS_LIQ_ACE                  /* Altera��o forma de c�lculo de juros ACC ACE */
&glob BF_FIN_JUROS_LONGO_PRAZO              /* APL - Apropria��o de Juros no Longo Prazo */
&glob BF_FIN_LAY_VARRED_SACAD               /* Novos Layouts Varredura do Sacado */
&glob BF_FIN_LAYOUT_DUP                     /* UTB - Incluir campos do Estab. emitente */
&glob BF_FIN_LISTA_MOV_TRANSF_RAZAO         /* Listar Movimentos de Transferencia de Bem no Raz�o */
&glob BF_FIN_LISTA_TITULO_NAO_DESTINADO     /* ACR - Listar Consist�ncia de T�tulos N�o Destinados */
&glob BF_FIN_LISTAR_CTA_CPARTIDA            /* Listar Conta de Contra Partida - Relator. Contabilidade */
&glob BF_FIN_LOTE_LIQUIDAC_ESTAB            /* ACR - Lote de liquida��o em v�rios estabelecimentos */
&glob BF_FIN_LOTE_UNICO                     /* Refer�ncia �nica p/ Liquida��o V�rios Estabelecimentos */
&glob BF_FIN_MEC_FASE_II                    /* MEC - Carta Remessa a Partir do Contrato */
&glob BF_FIN_MELHORIAS_PROCES_BGC           /* Melhoria Processo Suplementa��o/Redu��o/Transf. Verba */
&glob BF_FIN_MGL_RECALC_SALDO               /* Atualiza��o dos Planos Secundarios e Consolida��o Batch */
&glob BF_FIN_MOEDA_AN_ACR                   /* Moeda Implanta��o da Antecipa��o no Contas a Receber */
&glob BF_FIN_MOSTRA_TOTAIS                  /* Implementar Totais Gerais */
&glob BF_FIN_MUTUO                          /* Movimenta��o Di�ria / Conta Corrente / Pagamento Extra */
&glob BF_FIN_NAC_BEM_PAT_RELAT_FAS          /* FAS - Nacionalidade dos Bens Patrimoniais em Relat�rios */
&glob BF_FIN_NEGOC_TIT_COBRANCA             /* Negocia��o de T�tulos em Processo de Cobran�a */
&glob BF_FIN_NF_DEVOLUCAO                   /* ETP ACR - N�o atualiza NF Devolu��o */
&glob BF_FIN_NOME_ABREV_FORNEC              /* APB - Imprimir Nome Abrev Fornecedor */
&glob BF_FIN_NOVA_CLASSIFICACAO             /* Classifica��o Data Origem nr Docto */
&glob BF_FIN_NOVO_LAYOUT_BB_VENDOR          /* Novo Lay-out Banco do Brasil (Vendor/Cobran�a) */
&glob BF_FIN_NUM_PROC_EXP_REL_CON           /* Sele��o por N�mero do Processo Exporta��o */
&glob BF_FIN_ORCTO_CTA_SINT_BGC             /* BGC-N�vel Sint�tico */
&glob BF_FIN_ORCTO_ZERO                     /* Valida��o do Or�amento Com Valor Zero */
&glob BF_FIN_ORDEM_COMPRA_ANTECIP           /* APB - N�mero ordem compra na antecipa��o */
&glob BF_FIN_PAGTO_AN_OUTRA_MOEDA_APB       /* Antecipa��o em Multi-moeda Contas a Pagar */
&glob BF_FIN_PARAM_EMPENH_MODUL             /* Par�metro Para Definir Empenho e Bloqueio no BGC */
&glob BF_FIN_PARAM_GERAR_DADOS_CLI_SCI      /* ACR - Par�metro para gerar dados cliente no arq. SCI */
&glob BF_FIN_PARC_CARTAO_CREDITO            /* Parcelamento de Vendas Via Cart�o de Cr�dito */
&glob BF_FIN_PEDIDO_DE_BAIXA                /* Param p/ Ped Baixa na Alter Vecto Boleto */
&glob BF_FIN_PERC_DECIMAIS                  /* Tratar Percent. com mais Casas Decimais - Mapa Distrib. */
&glob BF_FIN_PERCENT_ESTOURO_BGC            /* Percentual de Estouro Permitido no Or�amento */
&glob BF_FIN_PERDAS_DEDUT_POR_CCUSTO_ACR    /* ACR - Perdas Dedut�veis por Centro Custo */
&glob BF_FIN_PESQUISA_PARIDADE              /* Pesquisa Paridade Indicador Econ�mico */
&glob BF_FIN_PESSOA_FISICA_RPA              /* UTB - Novos Campos Pessoa F�sica */
&glob BF_FIN_PGTO_TRIBUT_ESCRIT             /* Pagamento de Tributos - EMS5 */
&glob BF_FIN_POSIC_NRO_BCIO_CB              /* Alimentar Nosso N�mero a Partir do C�digo de Barras */
&glob BF_FIN_PRE_PAGTO                      /* MEC - Pr�-Pagamento */
&glob BF_FIN_PREVISAO_ESTAB_BAIXA           /* Previs�o Estabelecimento Baixa */
&glob BF_FIN_PRORROGA_DUPLICATA             /* ACR - Prorroga��o duplicata descontada */
&glob BF_FIN_PRORROGA_VX                    /* Prorroga��o VX Sem Gerar Nova Planilha */
&glob BF_FIN_RASTREAB_EMPENH                /* Melhoria Consulta e Relat�rios Saldos Empenhados */
&glob BF_FIN_RATEIO_DESPESA_BANCARIA        /* ACR - Rateio por CCusto da conta despesa banc�ria */
&glob BF_FIN_RATEIO_DEVOLUCAO_CC            /* ACR - Medir os resultados do centro de custo */
&glob BF_FIN_RAZAO_SOCIAL_EXTRATO_COMIS     /* Raz�o Social Cliente/Valor T�tulo no Extrato Comiss�es */
&glob BF_FIN_RECALC_COTAC                   /* UTB - Recalcular Cota��o s� Quando Alterado Registro */
&glob BF_FIN_RECOMPOR_SALDO_COMIS           /* ACR - Recompor valor comiss�o pela data de corte */
&glob BF_FIN_RED_IOF_BASE_IR                /* Redu��o do IOF da Base de C�lculo do IR */
&glob BF_FIN_REDUCAO_BASE_TRIBUT            /* Redu��o Base Tribut�vel */
&glob BF_FIN_REF_UNICA_LIQUIDAC             /* Refer�ncia �nica p/ Liquida��o V�rios Estabelecimentos */
&glob BF_FIN_REG_CORP_ACR                   /* Registro Corporativo na Relat�rio/Consulta */
&glob BF_FIN_REL_COMIS_AGENTE_MEC           /* Extrato de Comiss�es de Agente */
&glob BF_FIN_RELAT_CONF_VALORES_IR          /* Relat�rio Confer�ncia Impostos */
&glob BF_FIN_RPT_COBR_VDR_DIF_LIQUIDAC      /* Relat�rio de Diverg�ncias de Liquida��o Vendor */
&glob BF_FIN_RPT_DUPL_VENDOR_SINTETICO      /* Relat�rio Posi��o Banc�ria Vendor */
&glob BF_FIN_SEGURANCAUCF                   /* Seguran�a por UCF */
&glob BF_FIN_SEL_ESP_BEM                    /* Deprecia��o por Bem - Camada XML - EMS 5 */
&glob BF_FIN_SELEC_FX_GRP_CLIEN             /* Sele��o Grupo de Cliente no SCI/SERASA */
&glob BF_FIN_SELECAO_CCUSTO                 /* Selecao por Centro Custo nos Relatorios Contabeis */
&glob BF_FIN_SELECAO_POR_CONTA_CONTABIL     /* Sele��o Centro de Custo na Consulta/Relatorio PEF */
&glob BF_FIN_TIT_CR_EAI_S                   /* Posi��o dos T�tulos a Receber - Camada XML */
&glob BF_FIN_TOT_BALANCT                    /* Balancete - Total por Conta */
&glob BF_FIN_TOT_GERAL_TIT_LIQUIDADOS       /* Totaliza��o na Consulta de T�tulos Liquidados */
&glob BF_FIN_TOT_RELAT_BEM                  /* Totalizar primeiro nivel relat�rio de bens - FAS301AR */
&glob BF_FIN_TOTAL_POR_GRUPO_E_ESPECIE      /* Raz�o Agrupar/Total por Grupo e Esp�cie */
&glob BF_FIN_TOTALIZAR_POR_OPERACAO         /* Totaliza��o por Opera��o no Raz�o de Aplic. e Emprest. */
&glob BF_FIN_UN_DEVOLUCAO_EMS2              /* Unidade de Neg�cio na Devolu��o de Cliente */
&glob BF_FIN_UNIAO_BENS_DEPREC              /* Uni�o de Bens Patrimoniais que Depreciam */
&glob BF_FIN_VAL_JUROS_DIA                  /* ACR - Imprimir Valor juros dia atraso */
&glob BF_FIN_VAL_MAX_TIPO_PGTO              /* Altera��o Forma de Pagamento Impress�o Bordero APB */
&glob BF_FIN_VALIDA_CARTEIRA_CFL            /* CFL - Parametrizar por carteira a integr. ACR com CFL */
&glob BF_FIN_VARIOS_IMPTOS_PAGTO_COMIS      /* ACR - Informar mais de um imposto no pagamento de comis */
&glob BF_FIN_VENDOR                         /* Tratamento Comiss�es Vendor */
&glob BF_FIN_VINC_AN_APB                    /* Rotina de Abatimento de Antecipa��es */
&glob BF_FIN_VLR_DESPESA_OPERAC_FINANC      /* Valor de Despesa na Opera��o Financeira */
&glob BF_FIN_VLR_ORIG_LIQUIDAC_PGTO_PERIODO /* Vlr Original Liquida��es no Per�odo */
&glob BF_FIN_XML_DEMONST                    /* Saldos Cont�beis do Per�odo no Demonstrativo */
&glob BF_FIN_XMLGLTRANSACTION               /* Lan�amento Cont�bil - Camada XML */
&glob BF_FIN_ZERA_DESP_FINANC               /* Apropria��o Despesa Financeira nas Opera��o de Desconto */
&glob BF_FIN_FAIXA_MOEDA                    /* Faixa de Moeda no Relat�rio de Importa��o/Exporta��o (C�mbio) */
&glob BF_FIN_INTEGR_UNID_NEGOCIO_EMS2       /* Integra��o Unidade de Neg�cio com M�dulos EMS2 */
&glob BF_FIN_DEL_MOV_AUTO                   /* Eliminar Movimento de Juros Automaticamente */
&glob BF_FIN_HIST_AVA                       /* Hist�rico da Transa��o de Cancelamento de C�mbio � IT1 */
&glob BF_FIN_INFOR_CAMBIO                   /* Melhorias no Relat�rio de Saldos de Exporta��o */
&glob BF_FIN_PAGAR_JUROS_ANTECIP            /* Permitir Pagar Juros Antecipadamente no Contrato C�mbio */
&glob BF_FIN_SUBSTITUICAO                   /* 888.839 - Calculo de Juros Incorreto */
&glob BF_FIN_ESTAB_RELAT_MOVTO_BENS         /* IPP: Estabelecimento no relat.Movimento Bens Sint�tico */
&glob BF_FIN_INTEGR_FIN_SAUDE               /* IPP: INTEGRA��O FINAN�AS EMS X SA�DE - Itera��o Contas a Pagar */
&glob BF_FIN_DET_MOVTO_ORIG_CTBL            /* IPP: Raz�o Gerencial e Rastreabilidade FT e CE */
&glob BF_FIN_SAFRA_GRAOS                    /* IPP: Controle por Safra do Sistema de Gr�os */
&glob BF_FIN_NOME_80_POS                    /* IPP: Aumentar Tamanho da Raz�o Social no EMS5 */
&glob BF_FIN_PARC_CARTCRED_SCO              /* SCO - Parcelamento Vendas Via Cart�o de Cr�dito */
&glob BF_FIN_AUMENTO_DIGITO_NF              /* Proj: 71 - Aumentos de d�gitos NF ERP Financeiro */ 


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 9.0.0 (5.07) */
&glob BF_FIN_PROVIS_COMIS_REPRES              /* ACR - Provis�o de Comis Repres */
&glob BF_FIN_CM_RAT_FAS                       /* Rateios de Bens para Corre��o Monet�ria */
&glob BF_FIN_INTEGR_BGC_FGL                   /* Execu��o Or�ament�ria na Contabilidade EMS5 */
&glob BF_FIN_TRATAM_DECIMAIS                  /* Localiza��o Chile - Decimais EMS5 */
&glob BF_FIN_ACUM_POR_MATRIZ                  /* Acumulado PIS/COFINS/CSLL por Matriz ACR / APB - EMS5 */
&glob BF_FIN_API_ELIM_BORD                    /* Permitir Eliminar Border� via API */
&glob BF_FIN_MELHORIAS_INTEGR_RE_ACR          /* Melhorias nas Integra��es RE -> ACR (Devolu��o de Nota) - Itera��o 01 */
&glob BF_FIN_AGRUP_GPS                        /* Agrupamento de T�tulos no Pagamento de GPS */
&glob BF_FIN_INTEGR_ATIVO_MRI                 /* Integra��o do Ativo Fixo com MRI - EMS5 */
&glob BF_FIN_EXPORT_NAT_TRADING               /* Exportar Natureza Trading para o EMS2 */
&glob BF_FIN_VINCUL_AUTOMAC_IMPTO_IMPL_FATURA /* Reten��o de Impostos na Implanta��o da Fatura - EMS5 */
&glob BF_FIN_IMPTO_TAXADO_FATURA              /* Substitui��o de T�tulos de Imposto Taxado */
&glob BF_FIN_TIT_ABER_RES                     /* Extratos de fornecedores de forma detalhada e resumida */
&glob BF_FIN_TIT_POR_CTA_CTBL                 /* Relatorio de Titulos em Aberto por Conta Contabil APB */
&glob BF_FIN_REL_CORR_VAL_APB                 /* Relat�rio de Corre��o de Valor - APB */
&glob BF_FIN_REL_CORR_VAL_ACR                 /* Relat�rio de Corre��o de Valor - ACR */
&glob BF_FIN_DADOS_BCIO_PGTO_BORD             /* Dados Banc�rios do Fornecedor no Pagamento via Border� */
&glob BF_FIN_REL_CREDITO_FAS                  /* Relat�rio de Cr�dito PIS/COFINS/CSLL do Ativo Fixo */
&glob BF_FIN_LOG_ENVDO_SCO                    /* Marcar T�tulo Como N�o Enviado para Cobran�a Especial */
&glob BF_FIN_VALID_DAT_INIC                   /* Validar Data In�cio dos Movimentos no Contas Receber */
&glob BF_FIN_ATUALIZ_CTA_EMS2                 /* Atualiza��o Conta Cont�bil do EMS5 para EMS2 */
&glob BF_FIN_PARAM_IMPR_COL                   /* Imprimir ou N�o Coluna Sem Saldo no Demonst. Cont�bil */
&glob BF_FIN_ENDER_COB_PESSOA_FISIC           /* Endere�o de Cobran�a para Pessoa F�sica */
&glob BF_FIN_CONTAS_CORRENTES_FORNEC          /* Contas Correntes Fornecedor */
&glob BF_FIN_SEM_COD_BARRAS                   /* Varredura - Melhorias Usabilidade */
&glob BF_FIN_POSICAO_CONCIL                   /* Posi��o da Concilia��o no Per�odo */
&glob BF_FIN_DESTINACAO                       /* Liberar Cr�dito do Cliente Sem Vincular Cambial */
&glob BF_FIN_INTEGR_PLP_X_CFL                 /* Integrar Ordens Planejadas com Fluxo de Caixa - EMS5 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 10.0.0 (5.07A) */
&glob BF_FIN_BGC_INTEGR_MIP   /* Nova chamada para execu��o or�ament�ria */

   
/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.0.0 (5.08) */ 
&glob BF_FIN_MICRORREGIAO_PESSOA       /* Tratar Micro-Regi�o no EMS5 para Integra��o com Ems2 */ 
&glob BF_FIN_XML_MOV_APB               /* Evidenciar modifica��es em t�tulos do APB - via XML */ 
&glob BF_FIN_EST_ACR_DI                /* Proj: 341 - UC: Execute banking reconciliation */ 
&glob BF_FIN_MELHORIAS_INTEGR_FT_APB   /* Melhorias na integra��o de devolu��o do recebimento */ 
&glob BF_FIN_DAT_PAGTO_BORD            /* Data de Pagamento no Border� */ 
&glob BF_FIN_FILTRO_POR_UFC            /* IPP: Filtro por UFC na c�pia do Fluxo de Caixa */ 
&glob BF_FIN_VAR_RAT_CMG               /* IPP: Melhorias no Caixa e Bancos */ 
&glob BF_FIN_SAUDE_CMG                 /* IPP: INTEGRA��O FINAN�AS EMS X SA�DE - Itera��o Caixa e Bancos */ 
&glob BF_FIN_XML_MOV_ACR               /* IPP: INTEGRA��O FINAN�AS EMS X SA�DE - Itera��o Contas a Receber */ 
&glob BF_FIN_MELHORIAS_TIT_EM_ABERTO   /* IPP: Melhorias T�tulos em Aberto */ 
&glob BF_FIN_CFL_GEREN                 /* IPP: Melhorias no Fluxo de Caixa */ 
&glob BF_FIN_MSG_FGL_XML               /* IPP: Atualiza��o das mensagens de erro na API FGL900 */ 
&glob BF_FIN_TAX_ADM_CCR               /* SCO - Tratar taxa da administradora no parcelamento */ 
&glob BF_FIN_DECL_QUIT_DEB             /* DECLARA��O QUITA��O DE D�BITO */ 


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.2.0 */
&glob BF_FIN_ESTORN_COMIS   /* IPP: Projeto Comiss�es - IPP Estorno */ 
&glob BF_FIN_COMIS_REPRES   /* Proj: 397 - Comiss�es */ 
&glob BF_FIN_METADADOS      /* Proj: 418 - Metadados CRUD Flex */
&glob BF_FIN_PRAM_EMAIL     /* Par�metros de E-mail (BTB) */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.2.1 */
&glob BF_FIN_BCO_HIS_DTS_11   /* IPP: BANCOS HIST�RICOS - TOTVS 11 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.0 (11.3.0) */ 
&glob BF_FIN_INTEGR_FGL_BGC            /* IPP: INTEGRAR CONTABILIDADE EMS5 X BGC */ 
&glob BF_FIN_DATA_VALID_BGC            /* IPP: Melhorias BGC - IT04 - Data de Validade nos Par�metros */ 
&glob BF_FIN_MELHORIA_PERF             /* IPP: Melhorias BGC - IT03 Melhoria na Performance */ 
&glob BF_FIN_INTEGR_CMG_BGC            /* IPP: INTEGRAR M�DULO CAIXA E BANCOS EMS5 X BGC */ 
&glob BF_FIN_ALTERACOES_TITULO_APB     /* IPP: Parametrizar as Permiss�es de Altera��es do Usu�rio APB */ 
&glob BF_FIN_SDO_CTA_CTBL_CONCIL_APB   /* IPP: PADRONIZAR CONCILIA��O CONT�BIL APB E ACR */ 
&glob BF_FIN_ZERA_SDO_PREV_PROV        /* IPP: ZERAR O SALDO DA PREVIS�O PROVIS�O */ 
&glob BF_FIN_CURVA_ABC_CONSOLIDADA     /* IPP: CONSOLIDA��O DAS EMPRESAS NA CURVA ABC DE CLIENTES */ 
&glob BF_FIN_CONTROL_CHEQUES           /* IPP: Processo Controle de Cheques */
&glob BF_FIN_CONCILIACAO_ACR           /* IPP: Ajustes Trombamento */
&glob BF_FIN_INTEGR_API_TIT_AED        /* Autoriza��o Eletr�nica de T�tulos via Integra��o */
&glob BF_FIN_IN36                      /* Contabiliza��o do Pagamento de Prestadores por Conta de Saldo */
&glob BF_FIN_INTEGR_APB_AED_API        /* Integra��o APB x AED */ 
&glob BF_FIN_CONTROL_CXA               /* Proj: 62 - Controle de Caixa */
&glob BF_FIN_AUMENTO_DIGITO_CCUSTO     /* Proj: 82 - Unifica��o de Conceitos Fase II */
&glob BF_FIN_SEGUR_ESTABELEC           /* Proj: 99 - Seguran�a por Estabelecimento */
&glob BF_FIN_COTAC_CONTRAT             /* Proj: 48 - T�tulos em Outra Moeda */
&glob BF_FIN_CLIEN_FORNEC_DIF          /* Proj: 48 - Tratamento Clientes/Fornecedores Matriz Diferente */
&glob BF_FIN_PRECO_FLUTUANTE           /* Proj: 48 - Tratamento de Pre�o Flutuante */
&glob BF_FIN_MOSTRA_HISTOR_APF         /* Proj: 68 - Mostrar motivo Altera��o no Aprova��o Financeira */
&glob BF_FIN_VLR_IMPTO_CFL             /* Proj: 68 - Valor PIS/COFINS/CSLL n�o reflete no Fluxo de caixa */
&glob BF_FIN_EMAIL_PESSOA              /* Proj: 68 - Aumentar tamanho campo e-mail pessoa */
&glob BF_FIN_VALIDA_FUNCAO             /* Proj: 68 - Retirar Valida��es de fun��es */
&glob BF_FIN_CONSULT_TIT_ACR_EXPORT    /* API Consulta T�tulo Exporta��o - Espec Incorporado ao Produto */
&glob BF_FIN_GERA_XML_CTA_CTBL         /* Projeto via Chamado: TDNNBT - Mensagem XML - Lista de Conta Cont�bil de Integra��o */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.3 */ 
&glob BF_FIN_IMPORTACAO_TIT_FECHADO   /* Proj: D118FIN006 - Importador de T�tulos Liquidados */ 


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.5 */
&glob BF_FIN_CONSIST_APROP_ESTORNO   /* Proj: D11.5FIN99 - Estorno em Contas Inv�lidas */
&glob BF_FIN_CONCIL_CONTABEIS        /* Proj: D118FIN006 - IRM: 187 - Concilia��es Contabeis - Consultas Contabeis */
&glob BF_FIN_REPLICA_CAD             /* Proj: D118FIN006 - IRM: 203 - Acelerador de Implanta��o - Replica��o de Cadastros */
&glob BF_FIN_FIXAR_PARAM             /* Proj: D118FIN006 - IRM: 208 - Acelerador Implanta��o - Fixar Integra��o 2x5 */
&glob BF_FIN_APF_PORTAD_CXA          /* IPP: Tratar Antecipa��o via caixa com APF */
&glob BF_FIN_CONSIST_APF             /* IPP: Mudan�a Consistencias APF */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.7 */
&glob BF_FIN_EQUALIZ_VENCTO_FECHAMENTO  /* Proj: FST6122267 - IRM: 1397 - Equaliza��o Vencimento no Fechamento da Negocia��o ou no Fechamento Mensal */
&glob BF_FIN_CONTROL_CX_ACR             /* Proj: D1156FINMA - IRM: 1375 - Controle de caixa - Integra��o direta com ACR */
&glob BF_FIN_AN_CART_CRED               /* Proj: D1156FINMA - IRM: 1378 - Controle de caixa - Antecipa��o com cart�o de cr�dito-d�bito */
&glob BF_FIN_RET_COD_CARTAO             /* Proj: D118FIN006 - IRM:  230 - Cobran�as Especiais - Seguran�a n�mero Cart�o */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.8 */
&glob BF_FIN_DUPLIC_ORIG     /* Proj: D118FIN006 - IRM: 247 - Altera��o devolu��o Faturamento - RE x ACR */
&glob BF_FIN_HISTOR_CONTAS   /* Proj: D118FIN006 - IRM: 184 - Plano de Contas - Hist�rico no cadastro de contas */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.9 */
&glob BF_FIN_PERC_DESCTO_ANT  /* Proj: DFIN001 - IRM: 1947 - Tratar Desconto por Antecipa��o no Contas a Receber - Fase I */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.10 */
&glob BF_FIN_INTEG_MRI_BEM_PAT  /* Proj: DFIS001 - IRM: 1906 - Melhorias MRI x Ativo Fixo */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 11.5.11 */
&glob BF_FIN_ESOCIAL                     /* Proj: DFIN001 - IRM: 2007 - eSocial */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.0 (11.5.12) */
&glob BF_FIN_AJUSTA_VENCTO_COMIS  /* Proj: TILD81     - IRM:    0 - Ajuste da Data de Vencimento dos T�tulos de Comiss�o */
&glob BF_FIN_VAL_CRIT_CCUST       /* Proj: D118FIN006 - IRM:  183 - Plano de Contas - Valida��o e acerto do crit�rio distribui��o */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.1 */
&glob BF_FIN_SWAP_EMPRESTIMO           /* Proj: DFIN001    - IRM: 1457 - Tratar SWAP para Emprestimos */
&glob BF_FIN_FLUIG                     /* Proj: DFIN001    - IRM: 1803 - WorkFlows Fluig */
&glob BF_FIN_JUST_ORCTO                /* Proj: D118FIN006 - IRM:  225 - Permitir ao Usu�rio Justificar Altera��es no Or�amento */
&glob BF_FIN_CONSOLID_HIST_PARTICIP    /* Proj: DFLAVOUR01 - IRM:  178 - Integra��o Datasul x Protheus - REQ 1 */
&glob BF_FIN_CONSOLID_MINORITARIOS     /* Proj: DFLAVOUR01 - IRM:  178 - Integra��o Datasul x Protheus - REQ 2 */
&glob BF_FIN_INTEGR_SALDOS_CONSOLID    /* Proj: DFLAVOUR01 - IRM:  178 - Integra��o Datasul x Protheus - REQ 3 */
&glob BF_FIN_REESTRUT_SOCIETARIA       /* Proj: DFLAVOUR01 - IRM:  178 - Integra��o Datasul x Protheus - REQ 4 */
&glob BF_FIN_CONCILIACAO_CONSOLIDACAO  /* Proj: DFLAVOUR01 - IRM:  178 - Integra��o Datasul x Protheus - REQ 5 */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.2 */
&glob BF_FIN_PERC_DESCTO_CAD           /* Proj: DFIN001    - IRM: 1947 - Tratar Desconto por Antecipa��o no Contas a Receber - Fase II */
&glob BF_FIN_CAPACID_PRODUC            /* Proj: DFIN001    - IRM: 2334 - Elekeiroz - Deprecia��o */
&glob BF_FIN_WIZ_PORTAD                /* Proj: D118FIN006 - IRM:  206 - Acelerador Implanta��o - Wizard de Portador */
&glob BF_FIN_TOTVS_RESERVE             /* Proj: DFIN001    - IRM: 2008 - Integra��o Datasul x Reserve */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.3 */
&glob BF_FIN_EST_CANCEL_TIT_ESP        /* Proj: D118FIN006 - IRM:  228 - SCO - Estorno e Cancelamento T�tulos Cobran�a Especial */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.4 */
&glob BF_FIN_SERASA_SIMP               /* Proj: D_MAN_FIN001 - IRM: PCREQ-3104 - REQ: PCREQ-3105 - Disponibilizar Layouts Serasa via EDI */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.5 */
&glob BF_FIN_CAD_UNICO_EMP             /* Proj: D_MAN_FIN001 - IRM: PCREQ-3062 - REQ: PCREQ-3063 - Cadastro �nico Empresa */
&glob BF_FIN_DP_FORN_DIF               /* Proj: D_MAN_FIN001 - IRM:  PCREQ-674 - REQ:  PCREQ-927 - Implanta��o Fatura - Fornecedores Diferentes */
&glob BF_FIN_WIZ_SALDO                 /* Proj: D_MAN_FIN001 - IRM: PCREQ-3079 - REQ: PCREQ-3080 - Acelerador Implanta��o - Wizard Implanta��o de Saldo */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.6 */
&glob BF_FIN_OFFICE_OPEN_SOURCE        /* Proj: D_MAN_FIN001 - IRM: PCREQ-4980 - REQ: PCREQ-4981 - Integra��o Office Open Source */
&glob BF_FIN_REM_PARC                  /* Proj: D_MAN_FIN001 - IRM:  PCREQ-931 - REQ: PCREQ-3854 - Taxa de Administra��o Vari�vel conforme n�mero de parcelas */
&glob BF_FIN_TIT_MATRIZ                /* Proj: D_MAN_FIN001 - IRM:  PCREQ-932 - REQ: PCREQ-3851 - Consultas e Relat�rios de T�tulos por Matriz */
&glob BF_FIN_INTEGR_CLIEN_FORNEC       /* Proj: D_MAN_FIN001 - IRM:  PCREQ-266 - REQ: PCREQ-5657 - Cadastro do CEI */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.7 */
&glob BF_FIN_CPART_RZG                 /* Proj: D_MAN_FIN001 - IRM: PCREQ-5434 - REQ: PCREQ-5436 - Nobel - Relat�rio Raz�o Gerencial para Confer�ncia */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.8 */
&glob BF_FIN_ORIG_GRAOS                /* Proj: D118FIN006   - IRM:        241 - Envio de informa��es para m�dulo de Gr�os */
&glob BF_FIN_CLAS_MOV_RAZAO_CMG        /* Proj: D_MAN_FIN001 - IRM: PCREQ-7295 - REQ: PCREQ-7297 - Classifica��o Movimentos Raz�o Conta Corrente */
&glob BF_FIN_INTERDIVISION             /* Proj: D_MAN_FIN001 - IRM: PCREQ-5434 - REQ: PCREQ-5435 - Nobel - Tratamento Interdivision Transa��es Financeiras */
&glob BF_FIN_VARIAS_DUP                /* Proj: TRTTYW       - IRM:          0 - Gera��o de V�rias Duplicatas na Implanta��o de Fatura */
&glob BF_FIN_MASHUPS                   /* Proj: D_MAN_FIN001 - IRM:  PCREQ-266 - REQ: PCREQ-6087 - Mashups Financeiro */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.9 */
&glob BF_FIN_ATUALIZA_DADOS_FORNEC     /* Proj: D_MAN_FIN002 - IRM:  PCREQ-266 - REQ: PCREQ-6085 - Atualizar dados de fornecedor no ems2 ao pagar via border� */
&glob BF_FIN_ATIVIDADE_PESSOA          /* Proj: D_MAN_FIN002 - IRM:  PCREQ-266 - REQ: PCREQ-6073 - Ramo de Atividade Pessoa Jur�dica */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.10 */
&glob BF_FIN_MATRIZ_PESSOA             /* Proj: D_MAN_FIN002 - IRM:  PCREQ-266 - REQ: PCREQ-6069 - Matriz Pessoa */
&glob BF_FIN_MELHORIAS_INTEGR_GRAOS    /* Proj: D_MAN_FIN002 - IRM: PCREQ-8645 - REQ: PCREQ-8901 - Projeto Coacris - Gr�o - Safra */
&glob BF_FIN_PORTAD_DISTRIB            /* Proj: D_MAN_FIN002 - IRM: PCREQ-6670 - REQ: PCREQ-6691 - Jo�o Santos - Portador cobran�a conforme destina��o padr�o estabelec */
&glob BF_FIN_COPCOL_PADR_COL           /* Proj: D_MAN_FIN002 - IRM: PCREQ-7275 - REQ: PCREQ-7277 - HCOR - C�pia Colunas no Padr�o Colunas */
&glob BF_FIN_DARF                      /* Proj: D_MAN_FIN002 - IRM: PCREQ-6670 - REQ: PCREQ-8824 - Jo�o Santos - DARF */
&glob BF_FIN_PRD_NAO_REGULAR           /* Proj: D_MAN_FIN002 - IRM: PCREQ-7450 - REQ: PCREQ-7453 - LPA - Pagamento de Produtor n�o Regular */
&glob BF_FIN_CONTRATO_MUTUO            /* Proj: D_MAN_FIN002 - IRM: PCREQ-6670 - REQ: PCREQ-8247 - Jo�o Santos - Contrato de M�tuo */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.11 */
&glob BF_FIN_ENCTRO_CTA_COMPCAO        /* Proj: D_MAN_FIN002 - IRM: PCREQ-8531 - REQ:  PCREQ-8533 - Encontro de contas por Compensa��o */
&glob BF_FIN_FUNC_RESPONS_GRP          /* Proj: D_MAN_FIN002 - IRM: PCREQ-8645 - REQ: PCREQ-10625 - Aprova��o Presta��o de Contas */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.12 */
&glob BF_FIN_MOVTO_CONVEN              /* Proj: MANFIN01 - EPIC: PCREQ-7450 - STORY:   PCREQ-8550 - LPA - Conv�nios - Movimenta��o Conv�nio */
&glob BF_FIN_VALID_INSS_IR             /* Proj: MANFIN01 - EPIC: MANFIN01-1 - STORY:  MANFIN01-58 - Valida��o Imposto INSS x IR */
&glob BF_FIN_COTUN_ENCCTA              /* Proj: MANFIN01 - EPIC: MANFIN01-1 - STORY: MANFIN01-350 - Cota��o �nica por Moeda no Encontro de Contas */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.13 */
&glob BF_FIN_PARAM_APROV_DOCTO         /* Proj: MANFIN01 - EPIC: MANFIN01-274 - STORY: MANFIN01-275 - Gerar Pend�ncia no MLA por Especie de Documento */
&glob BF_FIN_FILTROS_GRAOS             /* Proj: MANFIN01 - EPIC:   MANFIN01-1 - STORY: MANFIN01-439 - Filtros Safra e Contrato Gr�os */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.14 */
&glob BF_FIN_EMPREST_PRODUTOR          /* Proj: MANFIN01 - EPIC:  MANFIN01-49 - STORY:  MANFIN01-50 - LPA - Adiantamentos e Empr�stimos */
&glob BF_FIN_MOVTO_CONVEN_RAT_COLETA   /* Proj: MANFIN01 - EPIC: MANFIN01-231 - STORY: MANFIN01-668 - LPA - Melhorias Piloto */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.15 */
&glob BF_FIN_LOTE_MKTPLACE_DIC         /* Proj: MANFIN01 - EPIC: MANFIN01-433 - STORY:  MANFIN01-434 - Marketplace - Controle Dicion�rio */
&glob BF_FIN_PLAT_OPERAD_LOGIST        /* Proj: MANFIN01 - EPIC: MANFIN01-891 - STORY: MANFIN01-1045 - Plataforma do Operador Log�stico */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.16 */
&glob BF_FIN_FECHTO_DIC                /* Proj: MANFIN01 - EPIC:   MANFIN01-49 - STORY:   MANFIN01-59 - LPA - Fechamento */
&glob BF_FIN_EMPREST_COMPETENCIA       /* Proj: MANFIN01 - EPIC: MANFIN01-1476 - STORY: MANFIN01-1337 - LPA - Desconto do Empr�stimo por Compet�ncia */
&glob BF_FIN_CORRENTISTA               /* Proj: MANFIN01 - EPIC: MANFIN01-1476 - STORY: MANFIN01-1482 - LPA - Tratar Correntista */
&glob BF_FIN_MELHORIAS_IVC             /* Proj: MANFIN01 - EPIC:    MANFIN01-1 - STORY:  MANFIN01-693 - Melhorias IVC */
&glob BF_FIN_LOTE_MKTPLACE             /* Proj: MANFIN01 - EPIC:  MANFIN01-433 - STORY:  MANFIN01-435 - Integra��o Marketplace */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.17 */
&glob BF_FIN_PERMIT_PAGTO_ANT          /* Proj: MANFIN01 - EPIC: MANFIN01-1718 - STORY: MANFIN01-1755 - Permitir pagamento com data anterior a aprova��o APF */
&glob BF_FIN_PRAZ_IMPL                 /* Proj: MANFIN01 - EPIC: MANFIN01-1718 - STORY: MANFIN01-1377 - APB - Controle prazo m�nimo de vencimento do t�tulo */
&glob BF_FIN_MELHORIAS_TMS_APB         /* Proj: MANFIN01 - EPIC:  MANFIN01-891 - STORY: MANFIN01-1036 - TMSxAPB - Mensagem Receb Docto Transp (XML+API) */
&glob BF_FIN_PERIOD_ACUM_PJ            /* Proj:        0 - EPIC:             0 - STORY:     MMAN-9131 - Fornecedor individual equiparado a Pessoa F�sica */
&glob BF_FIN_APF_LOG_APROVAC_PEND      /* Proj:        0 - EPIC:             0 - STORY:     MMAN-5124 - Altera��o T�tulo com Pend�ncia no MLA */
&glob BF_FIN_DIC_EMP_LPA               /* Proj: MANFIN01 - EPIC: MANFIN01-1476 - STORY: MANFIN01-1481 - Melhorias gerais LPA */
&glob BF_FIN_CLIEN_FORNEC_EAI2         /* Proj: MANFIN01 - EPIC:  MANFIN01-891 - STORY: MANFIN01-2019 - CAD - Mensagem Envio Cliente/Fornecedor */
&glob BF_FIN_IMPTO_DEVOL               /* Proj: MANFIN01 - EPIC: MANFIN01-1795 - STORY: MANFIN01-1796 - Tratamento de Impostos na Devolu��o */
&glob BF_FIN_ACR_AJ_FX                 /* Proj: MANFIN01 - EPIC:    MANFIN01-1 - STORY: MANFIN01-1402 - Estorno/Cancelamento de t�tulos em Faixa - Unimed */
&glob BF_FIN_ESOCIAL_2017_12117        /* Proj: DMANFIN1-1557 - EPIC: DMANFIN1-448 - STORY: DMANFIN1-1557  - Legisla��o do eSocial S1200 S1210 */
&glob BF_FIN_REINF_12117               /* Proj: DMANFIN1 - EPIC: DMANFIN1-172 - STORY: DMANFIN1-1036 - Legisla��o EFD REINF */


/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.18 */
&glob BF_FIN_VENCTO_EMPREST            /* Proj: MANFIN01 - EPIC: MANFIN01-231 - STORY:  MANFIN01-668 - LPA - Melhorias Piloto - Vencimento Empr�stimo */
&glob BF_FIN_COD_UNICO_CLI_FORN        /* Proj: MANFIN01 - EPIC: MANFIN01-891 - STORY: MANFIN01-2021 - CAD - C�digo �nico Clien/Fornec DTS x PTH x LGX */
&glob BF_FIN_CIASHOP_PEDVDA            /* Proj: DMANFIN1 - EPIC: DMANFIN1-680 - STORY: DMANFIN1-1426 - CIASHOP Fase 2 */
&glob BF_FIN_REINF                     /* Proj: DMANFIN1 - EPIC: DMANFIN1-172 - STORY: DMANFIN1-1036 - Legisla��o EFD REINF */
&glob BF_FIN_ESOCIAL_2017              /* Proj: DMANFIN1 - EPIC: DMANFIN1-448 - STORY: DMANFIN1-714  - Legisla��o do eSocial S1200 S1210 */

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.19 */
&glob BF_FIN_BENEFICIARIO              /* Proj: DMANFIN1 - EPIC: DMANFIN1-2519 - STORY: DMANFIN1-2726  - Informa��o do benefici�rio J-52 */
&glob BF_FIN_MELHORIAS_EEC_12119       /* Proj: DMANFIN1 - EPIC: DMANFIN1-99   - STORY: DMANFIN1-XXXX  - Permite realizar mais de um processo de viagem no mesmo Per�odo */
&glob BF_FIN_ESOCIAL_2017_12119        /* Proj: DMANFIN1 - EPIC: DMANFIN1-1682 - STORY: DMANFIN1-2924  - Legisla��o do eSocial S1200 S1210 */
&glob BF_FIN_NATUR_CTA_ECD             /* Proj: DMANFIN1 - EPIC: DMANCON1-2176 - STORY: DMANCON1-2371  - Informar a natureza da conta de acordo com o manual ECD  */

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.20 */
&glob BF_FIN_DIRF_2018                 /* Proj: DMANFIN1 - EPIC: DMANFIN1-3393 - STORY: DMANFIN1-3701  - DIRF 2018 */
&glob BF_FIN_REINF_12120               /* Proj: DMANFIN1 - EPIC: DMANFIN1-3330 - STORY: DMANFIN1-3778  - Legisla��o EFD REINF 12.1.20 */

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.21 */
&glob BF_FIN_EAI2_PIMS                 /* Proj: D118FIN006   - IRM:       1130 - Padronizar Integra��o do PIMS com ERP */
&glob BF_FIN_MELHORIAS_EEC_12121       /* Proj: DMANAPB1 - EPIC: DMANAPB1-170  - STORY: DMANAPB1-171   - Melhorias EEC 12.1.21 - FERBASA */
&glob BF_FIN_GILRAT_SENAR_12121        /* Proj: DMANAPB1 - EPIC: DMANAPB1-631  - STORY: DMANAPB1-577   - Alterar Cadastro de Imposto para conter os tipos GILRAT e SENAR */

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.22 */
&glob BF_FIN_EAI2_MASTERSALES          /* Proj: DMANACRTES1 - EPIC: DMANACRTES1-214 - Integra��o MASTERSALES */
&glob BF_FIN_SEST_SENAT_12122          /* Proj: DMANAPB1 - STORY: DMANAPB1-858   - Alterar Cadastro de Imposto para conter os tipos SEST e SENAT */
&glob BF_FIN_REINF_R2040               /* Proj: DMANAPB1 - EPIC: DMANAPB1-1020 - STORY: DMANAPB1-1021 - Legisla��o EFD REINF - Layout R-2040 */
&glob BF_FIN_RETIF_ESOCIAL             /* Proj: DMANAPB1 - EPIC: DMANAPB1-776  - STORY: DMANAPB1-1108 - Retifica��o ESOCIAL */

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.23 */
&glob BF_FIN_AGRUP_MOVTO_CTA_APB       /* Proj: DMANAPB1 - EPIC: DMANACRTES1-1127 - STORY: DMANACRTES1-1446 - Agrupar ou n�o agrupar movimentos APB para CMG */
&glob BF_FIN_ESOCIAL_SOCIO_CONSELH     /* Proj: DMANAPB1 - EPIC: DMANAPB1-1375    - STORY: DMANAPB1-1524    - ESOCIAL Rubricas S�cio/Propriet�rio/Conselheiro*/

/* FUN��ES LIBERADAS A PARTIR DA RELEASE 12.1.24 */
&glob BF_FIN_DIRF_2019                 /* Proj: DMANAPB1 - EPIC: DMANAPB1-1563    - STORY: DMANAPB1-1685    - DIRF 2019*/

/* FUN��ES AGUARDANDO LIBERA��O --
&glob BF_FIN_ITEM_DOCTO_ENTR           /* Proj: D118FIN006   - IRM:        246 - Converter os cadastros do m�dulo Ativo Fixo para a tecnologia Metadado */
&glob BF_FIN_EAI2_PIMS                 /* Proj: D118FIN006   - IRM:       1130 - Padronizar Integra��o do PIMS com ERP */
&glob BF_FIN_PEQ_MELHORIAS             /* Proj: DFIN001      - IRM:       1492 - Desenvolvimento Pequenas melhorias */
&glob BF_FIN_VALIDAR_TIP_FLUXO         /* Proj: D_MAN_FIN001 - IRM: PCREQ-3082 - REQ: PCREQ-3083 - Permitir reavaliar fluxo Financeiro */
&glob BF_FIN_WIZ_MOEDA                 /* Proj: D_MAN_FIN001 - IRM: PCREQ-4272 - REQ: PCREQ-4273 - Acelerador Implanta��o - Wizard de Moedas */
&glob BF_FIN_UNIFIC_CADASTROS          /* Proj: D118FIN07    - IRM:  212 a 220 - Unifica��o de Conceitos */
*/
