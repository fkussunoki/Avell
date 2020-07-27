/* definicao de temp-table */

/*include de controle de vers’o*/
{include/i-prgvrs.i BDG 1.00.00.001}

    define temp-table tt-param no-undo
        field destino                  as integer
        field arquivo                  as char format "x(35)"
        field usuario                  as char format "x(12)"
        field data-exec                as date
        field hora-exec                as integer
        field classifica               as integer
        field desc-classifica          as char format "x(40)"
        field modelo-rtf               as char format "x(35)"
        field l-habilitaRtf            as LOG
        FIELD data-ini                 AS DATE
        FIELD data-fim                 AS DATE
.
 
    def temp-table tt-raw-digita
            field raw-digita    as raw.


    def input parameter raw-param as raw no-undo.
    def input parameter TABLE for tt-raw-digita.

    create tt-param.
    RAW-TRANSFER raw-param to tt-param.


def temp-table tt_tit_acr_liquidac no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_ind_trans_acr_abrev          as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field tta_log_movto_estordo            as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field tta_log_liquidac_contra_antecip  as logical format "Sim/NÆo" initial no label "Liquidac AN" column-label "Liquidac AN"
    field tta_val_movto_tit_acr            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Movimento" column-label "Vl Movimento"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_cr_movto_tit_acr         as date format "99/99/9999" initial ? label "Cr‚dito" column-label "Cr‚dito"
    field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_ind_espec_docto              as character format "X(08)" label "Esp‚cie Documento" column-label "Esp‚cie Documento"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field ttv_cod_proces_export            as character format "x(12)" label "Processo Exporta‡Æo" column-label "Processo Exporta‡Æo"
    index tt_cdn_cliente                  
          tta_cdn_cliente                  ascending
    index tt_cod_tit_acr                  
          tta_cod_tit_acr                  ascending
    index tt_dat_transacao                
          tta_dat_transacao                descending
    index tt_estab                         is primary
          tta_cod_estab                    ascending
    index tt_processo                     
          ttv_cod_proces_export            ascending
    .
def temp-table tt_titulos_aberto_rioclarense no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T­tulo" column-label "Vl Original T­tulo"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T­tulo" column-label "Saldo T­tulo"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_val_origin_indic_econ        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Moeda T­tulo"
    field ttv_val_sdo_indic_econ           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Saldo Moeda T­tulo"
    field ttv_num_situacao                 as CHAR
    field ttv_num_faixa_vencto             as CHAR
    field ttv-ramo                         AS char
    field ttv-cod-cobrador                 AS char
    field ttv-nom-cobrador                 AS char
    field ttv-cod-vendedor                 AS INTEGER
    field ttv-nom-vendedor                 AS char
    FIELD ttv-nom-cliente                  AS char
    FIELD ttv-cdn-cliente                  AS INTEGER
    FIELD ttv-cnpj                         AS CHAR
    FIELD ttv-estado                       AS char
    field ttv-concatena                    AS CHAR
    FIELD ttv-concatena1                   AS CHAR


    INDEX tt_padrao
    tta_cod_estab                  ascending
    tta_cod_espec_docto            ascending
    tta_cod_ser_docto              ascending
    tta_cod_tit_acr                ascending
    tta_cod_parcela                ascending
    .

DEF TEMP-TABLE tt_temporaria NO-UNDO
    FIELD  tta_cod_estab                    as Character format "x(5)" label "Estabelecimento" column-label "Estab"             
    field  tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"         
    field  tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"             
    field  tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"                    
    field  tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"                     
    field  tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"    
    FIELD  ttv_vlr_saldo_movimento          AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD  ttv_vlr_implantacao              AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    field  ttv_num_situacao                 as CHAR         
    field  ttv_num_faixa_vencto             as CHAR         
    field  ttv-ramo                         AS char         
    field  ttv-nom-cobrador                 AS char         
    field  ttv-cod-vendedor                 AS INTEGER      
    field  ttv-nom-vendedor                 AS char         
    field  ttv-nom-cliente                  AS char         
    field  ttv-cdn-cliente                  AS INTEGER
    FIELD  ttv-tabela                       AS CHAR
    FIELD  ttv-dt-implanta                  AS date
    FIELD  ttv-dt-vcto                      AS date
    FIELD  ttv-dt-liquida                   AS date
    FIELD  ttv-concatena                    AS CHAR
    INDEX idx_default

    tta_cod_estab                  ascending
    tta_cod_espec_docto            ascending
    tta_cod_ser_docto              ascending
    tta_cod_tit_acr                ascending
    tta_cod_parcela                ascending.


DEF TEMP-TABLE tt-fato NO-UNDO
    FIELD ttv-num-situacao                 AS CHAR
    FIELD ttv-num-faixa-vcto               AS char
    FIELD ttv-ramo                         AS char
    FIELD ttv-nom-cobrador                 AS char
    FIELD ttv-tabela                       AS char
    FIELD ttv-valor                        AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99" EXTENT 5
    FIELD ttv-valor-impl                   AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99" EXTENT 5
    FIELD ttv-concatena                    AS CHARACTER
    INDEX idx_default
    ttv-num-situacao               ASCENDING
    ttv-num-faixa-vcto             ASCENDING
    ttv-ramo                       ASCENDING
    ttv-nom-cobrador               ASCENDING.

DEF TEMP-TABLE tt-fato2 NO-UNDO LIKE tt-fato.

DEF TEMP-TABLE tt-variacoes NO-UNDO
    FIELD ttv-situacao                     AS char
    FIELD ttv-tabela                       AS char.

/* definicao de variaveis globais */
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS char NO-UNDO.

/* definicao de variaveis locais */
DEFINE VAR v-cod-cliente              AS INTEGER                               NO-UNDO.
DEFINE VAR v-nom-cobrador             AS char                                  NO-UNDO.
DEFINE VAR v-nom-represe              AS char                                  NO-UNDO.
DEFINE VAR v-cod-represe              AS INT                                   NO-UNDO.
DEFINE VAR v-cod-unid                 AS char                                  NO-UNDO.
DEFINE VAR v-uf                       AS char                                  NO-UNDO.
DEFINE VAR v-cnpj                     AS char                                  NO-UNDO.
DEFINE VAR v-ramo                     AS char                                  NO-UNDO.
DEFINE VAR v-tit-acr                  AS CHAR                                  NO-UNDO.
DEFINE VAR v-cod-especie              AS CHAR                                  NO-UNDO.
DEFINE VAR v-cod-serie                AS CHAR                                  NO-UNDO.
DEFINE VAR v-cod-parcela              AS CHAR                                  NO-UNDO.
DEFINE VAR v-cod-estab                AS CHAR                                  NO-UNDO.
DEFINE VAR v-cdn-cliente              AS INTEGER                               NO-UNDO.
DEFINE VAR v-cod-situacao             AS CHAR                                  NO-UNDO.
DEFINE VAR v-faixa                    AS CHAR                                  NO-UNDO.
DEFINE VAR v-nom-cliente              AS CHAR                                  NO-UNDO.
DEFINE VAR v-tabela                   AS char                                  NO-UNDO.
DEFINE VAR v-vlr-original             AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"  NO-UNDO.
DEFINE VAR v-vlr-movto                AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"  NO-UNDO.
DEFINE VAR h-prog                     AS HANDLE                                NO-UNDO.
DEFINE VAR c_arquivo                  AS char                                  NO-UNDO.
DEFINE VAR m-linha                    AS INTEGER                               NO-UNDO.
DEFINE VAR v-cobrador                 AS CHAR                                  NO-UNDO.
DEFINE VAR d-dt-vcto                  AS DATE                                  NO-UNDO.
DEFINE VAR d-dt-liquida               AS DATE                                  NO-UNDO.
DEFINE VAR d-dt-implanta              AS DATE                                  NO-UNDO.


/* definicao de includes */
{utp/utapi013.i}  /* excel */
{include/i-rpvar.i}
{include/i-rpout.i &STREAM="stream str-rp"}

/* FINAL de definicoes */


    assign tt-param.arquivo = replace(tt-param.arquivo, ".tmp", STRING(TIME) + ".xls").
    assign tt-param.arquivo = replace(tt-param.arquivo, ".lst", STRING(TIME) + ".xls").

    ASSIGN c_arquivo = tt-param.arquivo.

    EMPTY TEMP-TABLE tt_tit_Acr_liquidac.
    EMPTY TEMP-TABLE tt_titulos_aberto_rioclarense.
    EMPTY TEMP-TABLE tt_temporaria.
    EMPTY TEMP-TABLE tt-fato.
    EMPTY TEMP-TABLE tt-fato2.
    EMPTY TEMP-TABLE tt-variacoes.

RUN pi-instancia-tt.
RUN pi-prepara-liquidac.
RUN pi-prepara-abertos.
RUN pi-tabela-fato.
RUN pi-extrai-fato.
RUN pi-prepara-cabecalho.
RUN pi-prepara-dados.
RUN pi-prepara-auxiliar.
RUN pi-rodar-excel.


PROCEDURE pi-prepara-auxiliar:

    ASSIGN m-linha = 3.

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 2                          
           tt-dados.celula-coluna                   = 1                          
           tt-dados.celula-linha                    = 1                          
           tt-dados.celula-cor-interior             = 58                          
           tt-dados.celula-valor                    = "Tabela Fato dos dados"          
           tt-dados.celula-fonte-cor                = 1.                


    FOR EACH tt_temporaria BREAK BY tt_temporaria.ttv-nom-cobrador
                                 BY tt_temporaria.ttv-ramo
                                 BY tt_temporaria.ttv-dt-vcto:


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 1                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.tta_cod_estab          
               tt-dados.celula-fonte-cor                = 1.                

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 2                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.tta_cod_espec_docto                    
               tt-dados.celula-fonte-cor                = 1.                          


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 3                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.tta_cod_ser_docto                       
               tt-dados.celula-fonte-cor                = 1.               


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 4                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58     
               tt-dados.CELULA-FORMATO                  = "@@"
               tt-dados.celula-valor                    = tt_temporaria.tta_cod_tit_acr                    
               tt-dados.celula-fonte-cor                = 1.              

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 5                          
               tt-dados.CELULA-FORMATO                  = "@@"
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.tta_cod_parcela                      
               tt-dados.celula-fonte-cor                = 1.              


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 6                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.tta_cdn_cliente)                    
               tt-dados.celula-fonte-cor                = 1.

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 7                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                         
               tt-dados.celula-valor                    = tt_temporaria.ttv-nom-cliente                    
               tt-dados.celula-fonte-cor                = 1.

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                         
               tt-dados.celula-coluna                   = 8                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.ttv_num_situacao                     
               tt-dados.celula-fonte-cor                = 1.


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 9                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                         
               tt-dados.celula-valor                    = tt_temporaria.ttv_num_faixa_vencto                    
               tt-dados.celula-fonte-cor                = 1.              

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 10                          
               tt-dados.celula-linha                    = m-linha                         
               tt-dados.celula-cor-interior             = 58                         
               tt-dados.celula-valor                    = tt_temporaria.ttv-ramo                    
               tt-dados.celula-fonte-cor                = 1.

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 11                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.ttv-nom-cobrador                    
               tt-dados.celula-fonte-cor                = 1.              


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 12                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv-cod-vendedor)                     
               tt-dados.celula-fonte-cor                = 1.              

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 13                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.ttv-nom-vendedor                   
               tt-dados.celula-fonte-cor                = 1.           

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 14                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt_temporaria.ttv-tabela                    
               tt-dados.celula-fonte-cor                = 1.              

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 15                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv_vlr_saldo_movimento)                    
               tt-dados.celula-fonte-cor                = 1.

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 16                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv_vlr_implantacao)                    
               tt-dados.celula-fonte-cor                = 1.              


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 17                         
               tt-dados.celula-linha                    = m-linha                         
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv-dt-implanta)                       
               tt-dados.celula-fonte-cor                = 1.              

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 18                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv-dt-vcto)                    
               tt-dados.celula-fonte-cor                = 1.           

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 19                         
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = STRING(tt_temporaria.ttv-dt-liquida)                     
               tt-dados.celula-fonte-cor                = 1.           
    
        ASSIGN m-linha = m-linha + 1.
    END.



END PROCEDURE.


PROCEDURE pi-instancia-tt:

    /* cria tabelas temporarias para concatenar */

    CREATE tt-variacoes.
    ASSIGN tt-variacoes.ttv-situacao = "AV"
           tt-variacoes.ttv-tabela   = "Liquidados".

    CREATE tt-variacoes.
    ASSIGN tt-variacoes.ttv-situacao = "V"
           tt-variacoes.ttv-tabela   = "Liquidados".

    CREATE tt-variacoes.
    ASSIGN tt-variacoes.ttv-situacao = "AV"
           tt-variacoes.ttv-tabela   = "Abertos".

    CREATE tt-variacoes.
    ASSIGN tt-variacoes.ttv-situacao = "V"
           tt-variacoes.ttv-tabela   = "Abertos".


    /* executa pedidos liquidados */
    RUN esp/esrc798ab.p PERSISTENT SET h-prog.
    RUN pi-liquida IN h-prog(OUTPUT TABLE tt_tit_acr_liquidac).
    DELETE PROCEDURE h-prog.

    /* executa titulos em aberto */
    RUN esp/esrc798aa.p(OUTPUT TABLE tt_titulos_aberto_rioclarense).

    /* instancia Excel */
    run utp/utapi013.p persistent set h-utapi013.
    /*SYSTEM-DIALOG PRINTER-SETUP.*/
    os-delete value(c_arquivo).

        CREATE tt-configuracao2.
        ASSIGN tt-configuracao2.versao-integracao     = 1
               tt-configuracao2.arquivo-num           = 1
               tt-configuracao2.arquivo               = c_arquivo
               tt-configuracao2.total-planilhas       = 3
               tt-configuracao2.exibir-construcao     = NO
               tt-configuracao2.abrir-excel-termino   = no
               tt-configuracao2.imprimir              = NO
               tt-configuracao2.orientacao            = 1.

        CREATE tt-planilha2.
        ASSIGN tt-planilha2.arquivo-num               = 1 
               tt-planilha2.planilha-num              = 1
               tt-planilha2.planilha-nome             = REPLACE(string(TODAY), "/", "_")
               tt-planilha2.linhas-grade              =  NO
               tt-planilha2.formatar-planilha = YES
               tt-planilha2.formatar-faixa = YES.

        CREATE tt-planilha2.
        ASSIGN tt-planilha2.arquivo-num               = 1 
               tt-planilha2.planilha-num              = 2
               tt-planilha2.planilha-nome             = "TabFato"
               tt-planilha2.linhas-grade              =  NO
               tt-planilha2.formatar-planilha = YES
               tt-planilha2.formatar-faixa = YES.



END PROCEDURE.


PROCEDURE pi-prepara-liquidac:


    FOR EACH tt_tit_acr_liquidac WHERE tt_tit_acr_liquidac.tta_ind_espec_docto = "Normal" BREAK BY (tt_tit_acr_liquidac.tta_cdn_cliente):

        ASSIGN v-tit-acr       = ""
               v-cod-especie   = ""
               v-cod-serie     = ""
               v-cod-parcela   = ""
               v-cod-estab     = ""
               v-cdn-cliente   = 0
               v-vlr-movto     = 0
               v-vlr-original  = 0
               d-dt-vcto       = ?
               d-dt-implanta   = ?
               d-dt-liquida    = ?.

        IF FIRST-OF(tt_tit_acr_liquidac.tta_cdn_cliente) THEN DO:


            FIND FIRST emsbas.cliente NO-LOCK WHERE emsbas.cliente.cod_empresa = tt_tit_Acr_liquidac.tta_cod_empresa
                                              AND   emsbas.cliente.cdn_cliente = tt_tit_acr_liquidac.tta_cdn_cliente NO-ERROR.

            ASSIGN v-nom-cliente = emsbas.cliente.nom_pessoa.
 
            IF length(emsbas.cliente.cod_id_feder) < 14 THEN DO:

                FIND FIRST pessoa_fisic NO-LOCK WHERE pessoa_fisic.num_pessoa_fisic = emsbas.cliente.num_pessoa 
                                                AND   pessoa_fisic.cod_id_feder     = emsbas.cliente.cod_id_feder 
                                                AND   pessoa_fisic.nom_pessoa       = emsbas.cliente.nom_pessoa NO-ERROR.

                IF AVAIL pessoa_fisic THEN DO:
                    ASSIGN v-uf = pessoa_fisic.cod_unid_federac
                           v-cnpj = pessoa_fisic.cod_id_feder.
                    FIND FIRST pessoa_fisic_ativid NO-LOCK WHERE pessoa_fisic_ativid.num_pessoa_fisic = pessoa_fisic.num_pessoa_fisic NO-ERROR.
                    IF AVAIL pessoa_fisic_ativid THEN
                    ASSIGN v-ramo = pessoa_fisic_ativid.cod_ativid_pessoa_fisic.
                    ELSE
                    ASSIGN v-ramo = "Nao ha".

                END.
            END.

            ELSE DO:
                FIND FIRST pessoa_jurid NO-LOCK WHERE pessoa_jurid.num_pessoa_jurid = emsbas.cliente.num_pessoa     
                                                AND   pessoa_jurid.cod_id_feder     = emsbas.cliente.cod_id_feder
                                                AND   pessoa_jurid.nom_pessoa       = emsbas.cliente.nom_pessoa NO-ERROR.

                ASSIGN v-uf = pessoa_jurid.cod_unid_federac
                      v-cnpj = pessoa_jurid.cod_id_feder.
                FIND FIRST pessoa_jurid_ativid NO-LOCK WHERE pessoa_jurid_ativid.num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.

                IF AVAIL pessoa_jurid_ativid THEN
                    ASSIGN v-ramo = pessoa_jurid_ativid.cod_ativid_pessoa_jurid.
                ELSE
                    ASSIGN v-ramo = "Nao ha".
            END.



            FIND FIRST clien_financ NO-LOCK WHERE clien_financ.cod_empresa = emsbas.cliente.cod_empresa
                                            AND   clien_financ.cdn_cliente = emsbas.cliente.cdn_cliente
                                            AND   clien_financ.cod_tip_clien = emsbas.cliente.cod_tip_clien

                                            NO-ERROR.



            FIND FIRST representante NO-LOCK WHERE representante.cdn_repres = clien_financ.cdn_repres 
                                             AND   representante.cod_empresa = clien_financ.cod_empresa
                                             NO-ERROR.

            IF AVAIL representante THEN
            ASSIGN v-nom-represe = representante.nom_pessoa
                   v-cod-represe = representante.cdn_repres.
            ELSE 
                ASSIGN v-nom-represe = "nao ha".



            FIND FIRST cobrador-cliente NO-LOCK WHERE cobrador-cliente.cod-empresa =  clien_financ.cod_empresa
                                                AND   cobrador-cliente.cod-emitente = clien_financ.cdn_cliente
                                                 NO-ERROR.

            IF AVAIL cobrador-cliente THEN DO:

                FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = cobrador-cliente.cobrador NO-ERROR.
    
                ASSIGN v-nom-cobrador = usuar_mestre.nom_usuario.

            END.

            ELSE ASSIGN v-nom-cobrador = 'Nao ha'.


        END. /* fim do first-of */

        FIND FIRST tit_Acr NO-LOCK WHERE tit_Acr.cod_empresa         = tt_tit_acr_liquidac.tta_cod_empresa
                                   AND   tit_Acr.cod_estab           = tt_tit_acr_liquidac.tta_cod_estab
                                   AND   tit_Acr.cod_espec_docto     = tt_tit_acr_liquidac.tta_cod_espec_docto  
                                   AND   tit_Acr.cod_ser_docto       = tt_tit_Acr_liquidac.tta_cod_ser_docto
                                   AND   tit_Acr.cod_tit_acr         = tt_tit_acr_liquidac.tta_cod_tit_Acr
                                   AND   tit_Acr.cod_parcela         = tt_tit_Acr_liquidac.tta_cod_parcela
                                   AND   tit_acr.cdn_cliente         = tt_tit_Acr_liquidac.tta_cdn_cliente NO-ERROR.

        ASSIGN v-vlr-original = tit_Acr.val_origin_tit_acr.

        ASSIGN v-tit-acr       = tt_tit_acr_liquidac.tta_cod_tit_Acr
               v-cod-especie   = tt_tit_acr_liquidac.tta_cod_espec_docto
               v-cod-serie     = tt_tit_acr_liquidac.tta_cod_ser_docto
               v-cod-parcela   = tt_tit_acr_liquidac.tta_cod_parcela
               v-cod-estab     = tt_tit_Acr_liquidac.tta_cod_estab
               v-cdn-cliente   = tt_tit_Acr_liquidac.tta_cdn_cliente
               v-vlr-movto     = tt_tit_acr_liquidac.tta_val_movto_tit_acr
               d-dt-vcto       = tt_tit_acr_LIQUIDAC.tta_dat_vencto_tit_acr
               d-dt-implanta   = tit_Acr.dat_emis_docto
               d-dt-liquida    = tt_tit_acr_LIQUIDAC.tta_dat_cr_movto_tit_acr 
               .

        IF tt_tit_acr_liquidac.tta_dat_vencto_tit_acr  >= TODAY THEN
            ASSIGN v-cod-situacao = "AV".
        ELSE
            ASSIGN v-cod-situacao = "V".

        IF ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) >= 0
        AND ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) <= 30  THEN
            ASSIGN v-faixa = "Faixa1".

        IF ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) > 30
        AND ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) <= 60  THEN
            ASSIGN v-faixa = "Faixa2".

        IF ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) > 60
        AND ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) <= 90  THEN
            ASSIGN v-faixa = "Faixa3".

        IF ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) > 90
        AND ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) <= 120  THEN
            ASSIGN v-faixa = "Faixa4".

        IF ABS(TODAY - tt_tit_acr_liquidac.tta_dat_vencto_tit_acr) > 120 THEN
            ASSIGN v-faixa = "Faixa5".
        
        ASSIGN v-tabela = "Liquidados".
        RUN pi-prepara.

    END.


END PROCEDURE.


PROCEDURE pi-prepara-abertos:

    ASSIGN v-cod-estab        = ""
           v-cod-especie      = ""
           v-cod-serie        = ""
           v-tit-acr          = ""
           v-cod-parcela      = ""
           v-cdn-cliente      = 0
           v-cod-situacao     = ""
           v-faixa            = ""
           v-ramo             = ''
           v-nom-cobrador     = ""
           v-cod-represe      = 0
           v-nom-represe      = ""
           v-nom-cliente      = ""
           v-cdn-cliente      = 0
           v-tabela           = ""
           v-vlr-movto        = 0
           v-vlr-original     = 0
           d-dt-implanta      = ?
           d-dt-vcto          = ?
           d-dt-liquida       = ?.
 
    FOR EACH tt_titulos_aberto_rioclarense:
        ASSIGN v-cod-estab        = tt_titulos_aberto_rioclarense.tta_cod_estab
               v-cod-especie      = tt_titulos_aberto_rioclarense.tta_cod_espec_docto 
               v-cod-serie        = tt_titulos_aberto_rioclarense.tta_cod_ser_docto
               v-tit-acr          = tt_titulos_aberto_rioclarense.tta_cod_tit_acr
               v-cod-parcela      = tt_titulos_aberto_rioclarense.tta_cod_parcela
               v-cdn-cliente      = tt_titulos_aberto_rioclarense.ttv-cdn-cliente
               v-cod-situacao     = tt_titulos_aberto_rioclarense.ttv_num_situacao
               v-faixa            = tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto
               v-ramo             = tt_titulos_aberto_rioclarense.ttv-ramo
               v-nom-cobrador     = tt_titulos_aberto_rioclarense.ttv-nom-cobrador
               v-cod-represe      = tt_titulos_aberto_rioclarense.ttv-cod-vendedor
               v-nom-represe      = tt_titulos_aberto_rioclarense.ttv-nom-vendedor
               v-nom-cliente      = tt_titulos_aberto_rioclarense.ttv-nom-cliente 
               v-cdn-cliente      = tt_titulos_aberto_rioclarense.ttv-cdn-cliente
               v-tabela           = "Abertos"
               v-vlr-movto        = tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr
               v-vlr-original     = tt_titulos_Aberto_rioclarense.tta_val_origin_tit_acr
               d-dt-implanta      = tt_titulos_aberto_rioclarense.tta_dat_emis_docto
               d-dt-vcto          = tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr.  

        RUN pi-prepara.

    END.


END PROCEDURE.


PROCEDURE pi-prepara:

    CREATE tt_temporaria.
    ASSIGN tt_temporaria.tta_cod_estab            = v-cod-estab
           tt_temporaria.tta_cod_espec_docto      = v-cod-especie
           tt_temporaria.tta_cod_ser_docto        = v-cod-serie
           tt_temporaria.tta_cod_tit_acr          = v-tit-acr
           tt_temporaria.tta_cod_parcela          = v-cod-parcela
           tt_temporaria.tta_cdn_cliente          = v-cdn-cliente
           tt_temporaria.ttv_num_situacao         = v-cod-situacao
           tt_temporaria.ttv_num_faixa_vencto     = v-faixa
           tt_temporaria.ttv-ramo                 = v-ramo
           tt_temporaria.ttv-nom-cobrador         = v-nom-cobrador
           tt_temporaria.ttv-cod-vendedor         = v-cod-represe
           tt_temporaria.ttv-nom-vendedor         = v-nom-represe
           tt_temporaria.ttv-nom-cliente          = v-nom-cliente
           tt_temporaria.ttv-cdn-cliente          = v-cdn-cliente
           tt_temporaria.ttv-tabela               = v-tabela
           tt_temporaria.ttv_vlr_saldo_movimento  = v-vlr-movto
           tt_temporaria.ttv-concatena            = v-nom-cobrador + v-cod-situacao
           tt_temporaria.ttv_vlr_implantacao      = v-vlr-original
           tt_temporaria.ttv-dt-vcto              = d-dt-vcto
           tt_temporaria.ttv-dt-implanta          = d-dt-implanta
           tt_temporaria.ttv-dt-liquida           = d-dt-liquida.



END PROCEDURE.

PROCEDURE pi-tabela-fato:
DEFINE VAR i-faixa AS INTEGER NO-UNDO.
DEFINE VAR v-situacao AS char NO-UNDO.

    
    FOR EACH tt-variacoes:
            DO i-faixa = 1 TO 5:
        
            FOR EACH tt_temporaria WHERE tt_temporaria.ttv_num_situacao      =  tt-variacoes.ttv-situacao
                                   AND   tt_temporaria.ttv_num_faixa_vencto  = "Faixa" + TRIM(string(i-faixa))
                                   AND   tt_temporaria.ttv-tabela            = tt-variacoes.ttv-tabela BREAK BY tt_temporaria.ttv-concatena:
    
                    CREATE tt-fato.
                    ASSIGN tt-fato.ttv-num-situacao                  = tt_temporaria.ttv_num_situacao
                           tt-fato.ttv-num-faixa-vcto                = tt_temporaria.ttv_num_faixa_vencto
                           tt-fato.ttv-ramo                          = tt_temporaria.ttv-ramo
                           tt-fato.ttv-nom-cobrador                  = tt_temporaria.ttv-nom-cobrador
                           tt-fato.ttv-tabela                        = tt_temporaria.ttv-tabela
                           /* tt-fato.ttv-valor[i-faixa]                = ACCUM SUB-TOTAL BY tt_temporaria.ttv-concatena tt_temporaria.ttv_vlr_saldo_movimento */
                           /* tt-fato.ttv-valor-impl[i-faixa]           = ACCUM SUB-TOTAL BY tt_temporaria.ttv-concatena tt_temporaria.ttv_vlr_implantacao */
                            tt-fato.ttv-valor[i-faixa]                = tt_temporaria.ttv_vlr_saldo_movimento
                            tt-fato.ttv-valor-impl[i-faixa]           = tt_temporaria.ttv_vlr_implantacao
                            tt-fato.ttv-concatena                     = tt_temporaria.ttv-nom-cobrador + tt_temporaria.ttv-tabela + tt_temporaria.ttv_num_situacao + tt_temporaria.ttv-ramo.
 
            END.
        END.
    END.

    FOR EACH tt-fato BREAK BY tt-fato.ttv-concatena:

        ACCUMULATE tt-fato.ttv-valor[1] (SUB-TOTAL by  tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor[2] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor[3] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor[4] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor[5] (SUB-TOTAL by tt-fato.ttv-concatena).

        ACCUMULATE tt-fato.ttv-valor-impl[1] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor-impl[2] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor-impl[3] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor-impl[4] (SUB-TOTAL by tt-fato.ttv-concatena).
        ACCUMULATE tt-fato.ttv-valor-impl[5] (SUB-TOTAL by tt-fato.ttv-concatena).

        IF LAST-OF(tt-fato.ttv-concatena) THEN DO:

            CREATE tt-fato2.
            ASSIGN tt-fato2.ttv-num-situacao       = tt-fato.ttv-num-situacao  
                   tt-fato2.ttv-nom-cobrador       = tt-fato.ttv-nom-cobrador 
                   tt-fato2.ttv-tabela             = tt-fato.ttv-tabela 
                   tt-fato2.ttv-ramo               = tt-fato.ttv-ramo
                   tt-fato2.ttv-valor[1]           = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor[1]) 
                   tt-fato2.ttv-valor[2]           = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor[2]) 
                   tt-fato2.ttv-valor[3]           = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor[3]) 
                   tt-fato2.ttv-valor[4]           = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor[4]) 
                   tt-fato2.ttv-valor[5]           = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor[5]) 
                   tt-fato2.ttv-valor-impl[1]      = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor-impl[1])   
                   tt-fato2.ttv-valor-impl[2]      = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor-impl[2])   
                   tt-fato2.ttv-valor-impl[3]      = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor-impl[3])   
                   tt-fato2.ttv-valor-impl[4]      = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor-impl[4])   
                   tt-fato2.ttv-valor-impl[5]      = (ACCUM SUB-TOTAL by tt-fato.ttv-concatena tt-fato.ttv-valor-impl[5])  


                   tt-fato2.ttv-concatena           = tt-fato.ttv-nom-cobrador +    tt-fato.ttv-ramo.





        END.

    END.

END PROCEDURE.

PROCEDURE pi-prepara-cabecalho:

/* prepara cabecalho */


  CREATE tt-formatar.
  ASSIGN tt-formatar.arquivo-num           = 1    
         tt-formatar.planilha-num          = 1   
         tt-formatar.celula-coluna-ini     = 5   
         tt-formatar.celula-coluna-fim     = 6   
         tt-formatar.celula-linha-ini      = 1   
         tt-formatar.celula-linha-fim      = 1   
         tt-formatar.faixa                 =  "e1:f1"  
         tt-formatar.atributo              =  "merge"  
         tt-formatar.valor                 =  "true".

  CREATE tt-formatar.
  ASSIGN tt-formatar.arquivo-num           = 1    
         tt-formatar.planilha-num          = 1   
         tt-formatar.celula-coluna-ini     = 7   
         tt-formatar.celula-coluna-fim     = 8   
         tt-formatar.celula-linha-ini      = 1   
         tt-formatar.celula-linha-fim      = 1   
         tt-formatar.faixa                 =  "g1:h1"  
         tt-formatar.atributo              =  "merge"  
         tt-formatar.valor                 =  "true".

  CREATE tt-dados.
  ASSIGN tt-dados.arquivo-num                     = 1                          
         tt-dados.planilha-num                    = 1                          
         tt-dados.celula-coluna                   = 5                         
         tt-dados.celula-linha                    = 1                          
         tt-dados.celula-cor-interior             = 6                          
         tt-dados.celula-valor                    = "A Vencer"                    
         tt-dados.celula-fonte-cor                = 1.                          

  CREATE tt-dados.
  ASSIGN tt-dados.arquivo-num                     = 1                          
         tt-dados.planilha-num                    = 1                          
         tt-dados.celula-coluna                   = 7                          
         tt-dados.celula-linha                    = 1                          
         tt-dados.celula-cor-interior             = 6                          
         tt-dados.celula-valor                    = "Vencidos"                    
         tt-dados.celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 1                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Cobrador"                    
           tt-dados.celula-fonte-cor                = 1.                

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 2                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Ramo"                    
           tt-dados.celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 3                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Vlr.Total Aberto"                    
           tt-dados.celula-fonte-cor                = 1.               


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 4                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Vlr. Original"                    
           tt-dados.celula-fonte-cor                = 1.              

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 5                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Vlr. Aberto AV"                    
           tt-dados.celula-fonte-cor                = 1.              


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 6                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Liquidados AV"                    
           tt-dados.celula-fonte-cor                = 1.

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 7                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Vlr. Aberto V"                    
           tt-dados.celula-fonte-cor                = 1.

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 8                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Liquidados V"                    
           tt-dados.celula-fonte-cor                = 1.


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 9                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Abertos 0 a 30"                    
           tt-dados.celula-fonte-cor                = 1.              

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 10                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Abertos 31 a 60"                    
           tt-dados.celula-fonte-cor                = 1.

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 11                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Abertos 61 a 90"                    
           tt-dados.celula-fonte-cor                = 1.              


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 12                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Abertos 91 a 120"                    
           tt-dados.celula-fonte-cor                = 1.              

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 13                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Abertos Superior a 120"                    
           tt-dados.celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 14                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Recebidos 0 a 30"                    
           tt-dados.celula-fonte-cor                = 1.              

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 15                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Recebidos 31 a 60"                    
           tt-dados.celula-fonte-cor                = 1.

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 16                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Recebidos 61 a 90"                    
           tt-dados.celula-fonte-cor                = 1.              


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 17                         
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Recebidos 91 a 120"                    
           tt-dados.celula-fonte-cor                = 1.              

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 1                          
           tt-dados.celula-coluna                   = 18                          
           tt-dados.celula-linha                    = 2                          
           tt-dados.celula-cor-interior             = 6                          
           tt-dados.celula-valor                    = "Recebidos Superior a 120"                    
           tt-dados.celula-fonte-cor                = 1.           

/* titulos em aberto */
      

    CREATE tt-formatar.
    ASSIGN tt-formatar.arquivo-num           = 1    
           tt-formatar.planilha-num          = 2   
           tt-formatar.celula-coluna-ini     = 1  
           tt-formatar.celula-coluna-fim     = 18   
           tt-formatar.celula-linha-ini      = 1   
           tt-formatar.celula-linha-fim      = 1   
           tt-formatar.faixa                 =  "a1:s1"  
           tt-formatar.atributo              =  "merge"  
           tt-formatar.valor                 =  "true".



      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 1                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Estab"                    
             tt-dados.celula-fonte-cor                = 1.                

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 2                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Especie"                    
             tt-dados.celula-fonte-cor                = 1.                          


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 3                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Serie"                    
             tt-dados.celula-fonte-cor                = 1.               


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 4                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Titulo"                    
             tt-dados.celula-fonte-cor                = 1.              

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 5                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Parcela"                    
             tt-dados.celula-fonte-cor                = 1.              


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 6                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Cod.Cliente"                    
             tt-dados.celula-fonte-cor                = 1.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 7                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "NomCliente"                    
             tt-dados.celula-fonte-cor                = 1.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                         
             tt-dados.celula-coluna                   = 8                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Situacao"                    
             tt-dados.celula-fonte-cor                = 1.


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 9                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Faixa Vcto"                    
             tt-dados.celula-fonte-cor                = 1.              

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 10                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Ramo"                    
             tt-dados.celula-fonte-cor                = 1.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 11                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Cobrador"                    
             tt-dados.celula-fonte-cor                = 1.              


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 12                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Cod.Rep"                    
             tt-dados.celula-fonte-cor                = 1.              

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 13                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Representante"                    
             tt-dados.celula-fonte-cor                = 1.           

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 14                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Tabela"                    
             tt-dados.celula-fonte-cor                = 1.              

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 15                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Vlr Movimento / Saldo"                    
             tt-dados.celula-fonte-cor                = 1.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 16                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Vlr Original"                    
             tt-dados.celula-fonte-cor                = 1.              


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                         
             tt-dados.celula-coluna                   = 17                         
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Dt Emissao"                    
             tt-dados.celula-fonte-cor                = 1.              

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 18                          
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Dt. Vcto"                    
             tt-dados.celula-fonte-cor                = 1.           

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num                     = 1                          
             tt-dados.planilha-num                    = 2                          
             tt-dados.celula-coluna                   = 19                         
             tt-dados.celula-linha                    = 2                          
             tt-dados.celula-cor-interior             = 6                          
             tt-dados.celula-valor                    = "Dt. Implanta"                    
             tt-dados.celula-fonte-cor                = 1.           

END PROCEDURE.

PROCEDURE pi-prepara-dados:
    ASSIGN m-linha = 2.

    FOR EACH tt-fato2 BREAK BY tt-fato2.ttv-concatena:

        IF FIRST-OF(tt-fato2.ttv-concatena) THEN DO:
            ASSIGN m-linha = m-linha + 1.
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 1                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-valor                    = tt-fato2.ttv-nom-cobrador                    
                   tt-dados.celula-fonte-cor                = 1.       

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 2                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-valor                    = tt-fato2.ttv-ramo                   
                   tt-dados.celula-fonte-cor                = 1.           

            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 3                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 4                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 5                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 6                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 7                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 8                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 9                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 10                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 11                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 12                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 13                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 14                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
.                  tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 15                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                         
                   tt-dados.celula-coluna                   = 16                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 17                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                     = 1                          
                   tt-dados.planilha-num                    = 1                          
                   tt-dados.celula-coluna                   = 18                         
                   tt-dados.celula-linha                    = m-linha                         
                   tt-dados.celula-cor-interior             = 58                          
                   tt-dados.celula-fonte-cor                = 1.           
            
        END.

        IF tt-fato2.ttv-tabela = "Abertos" 
        AND tt-fato2.ttv-num-situacao = "V" THEN DO:
            
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  7 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1] + tt-fato2.ttv-valor[2] + tt-fato2.ttv-valor[3] + tt-fato2.ttv-valor[4] + tt-fato2.ttv-valor[5]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  9 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1]).
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  10 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[2]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  11 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[3]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  12 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[4]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  13 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[5]).


        END.

        IF tt-fato2.ttv-tabela = "Liquidados" 
        AND tt-fato2.ttv-num-situacao = "V" THEN DO:
            
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  8 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1] + tt-fato2.ttv-valor[2] + tt-fato2.ttv-valor[3] + tt-fato2.ttv-valor[4] + tt-fato2.ttv-valor[5]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  14 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1]).
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  15 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[2]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  16 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[3]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  17 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[4]).

            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  18 NO-ERROR.
            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[5]).

        END.

        IF tt-fato2.ttv-tabela = "Abertos" 
        AND tt-fato2.ttv-num-situacao = "AV" THEN DO:
            
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  5 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1] + tt-fato2.ttv-valor[2] + tt-fato2.ttv-valor[3] + tt-fato2.ttv-valor[4] + tt-fato2.ttv-valor[5]).

        END.

        IF tt-fato2.ttv-tabela = "Liquidados" 
        AND tt-fato2.ttv-num-situacao = "AV" THEN DO:
            
            FIND FIRST tt-dados WHERE tt-dados.celula-linha  = m-linha
                                AND   tt-dados.celula-coluna =  6 NO-ERROR.

            ASSIGN tt-dados.celula-valor  =  string(DECIMAL(tt-dados.celula-valor) + tt-fato2.ttv-valor[1] + tt-fato2.ttv-valor[2] + tt-fato2.ttv-valor[3] + tt-fato2.ttv-valor[4] + tt-fato2.ttv-valor[5]).

        END.


    END.


    

END PROCEDURE.


PROCEDURE pi-rodar-excel:


    RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).

    if return-value = "nok" then do:



        /* include padr’o para output de relat½rios */
        /* include com a defini?’o da frame de cabe?alho e rodap' */
        /* bloco principal do programa */
        assign c-programa   = "ESRC798RP"
            c-versao    = "1.00"
            c-revisao   = ".00.000"
            c-empresa   = "Rioclarense"
            c-sistema   = "Datasul EMS"
            c-titulo-relat = "Titulos Gerados".
        view stream str-rp frame f-cabec.
        view stream str-rp frame f-rodape.
        for each tt-erros:
            PUT STREAM str-rp tt-erros.cod-erro   FORMAT '99999'
                              tt-erros.DESC-error FORMAT 'x(256)'
                              SKIP.
        end.
    end.

END PROCEDURE.

PROCEDURE pi-extrai-fato:
/*     OUTPUT TO c:\desenv\teste.txt. */
/*     FOR EACH tt_temporaria:        */
/*         EXPORT     tt_temporaria.  */
/*     END.                           */

END PROCEDURE.
