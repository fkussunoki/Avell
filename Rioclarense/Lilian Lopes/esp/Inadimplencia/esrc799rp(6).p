
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
        FIELD cod-representante        AS char
        FIELD cod-unid-negoc           AS char
        FIELD cod-especie              AS CHARACTER
        FIELD cod-tipo                 AS INTEGER
        FIELD tp-execucao              AS INTEGER
        FIELD cod-empresa              AS CHAR.

       .

define temp-table tt-envio NO-UNDO
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes.

define temp-table tt-envio2 NO-UNDO
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.

 
    def temp-table tt-raw-digita
            field raw-digita    as raw.


    def input parameter raw-param as raw no-undo.
    def input parameter TABLE for tt-raw-digita.

    create tt-param.
    RAW-TRANSFER raw-param to tt-param.

  
    {utp/utapi013.i}  

{utp/ut-glob.i}

/*                                                                      */
def var h-utapi019 as HANDLE NO-UNDO.

def temp-table tt_param_titulos_aberto_clien no-undo
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field ttv_log_ret_docto                as logical format "Sim/N’o" initial no label "Retorna T­tulos" column-label "Retorna T­tulos"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    field ttv_log_vencid                   as logical format "Sim/N’o" initial yes label "Vencidos" column-label "Vencidos"
    field ttv_log_avencer                  as logical format "Sim/N’o" initial yes label "A Vencer" column-label "A Vencer"
    field ttv_log_antecip                  as logical format "Sim/N’o" initial yes label "Antecipa»’o" column-label "Antecipa»’o"
    field tta_des_sig_indic_econ           as character format "x(06)" label "Sigla" column-label "Sigla"
    .

def temp-table tt_titulos_aberto_clien no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
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
    field ttv_num_situacao                 as integer format ">9"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    INDEX tt_padrao
    ttv_rec_id                     ASCENDING
    tta_cod_estab                  ascending
    tta_cod_espec_docto            ascending
    tta_cod_ser_docto              ascending
    tta_cod_tit_acr                ascending
    tta_cod_parcela                ascending
    tta_dat_emis_docto             ascending
    tta_dat_vencto_tit_acr         ascending.

      
def temp-table tt_titulos_aberto_rioclarense no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
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
    field ttv_num_situacao                 as integer format ">9"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
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
    
    
    INDEX tt_padrao
    ttv_rec_id                     ASCENDING
    tta_cod_estab                  ascending
    tta_cod_espec_docto            ascending
    tta_cod_ser_docto              ascending
    tta_cod_tit_acr                ascending
    tta_cod_parcela                ascending
    .


DEFINE BUFFER b-tit_acr FOR tit_acr.
def temp-table tt_tot_tit_aberto_faixa_vencto no-undo
    field ttv_num_situacao                 as integer format ">9"
    field ttv_num_faixa_vencto             as integer format ">>>>,>>9" label "Dias Vencimento"
    field ttv_val_sdo_faixa_vencto         as decimal format ">>>,>>>,>>9.99" decimals 2
    index tt_index                        
    ttv_num_situacao                 ascending
    ttv_num_faixa_vencto             ascending
    .

def temp-table tt_tot_tit_aberto_period no-undo
    field ttv_val_sdo_vencid               as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_avencer              as decimal format ">>>,>>>,>>9.99" decimals 2
    field ttv_val_sdo_antecip              as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    .

def temp-table tt_erro_msg no-undo
    field ttv_num_msg_erro                 as integer format ">>>>>>9" label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_help_erro                as character format "x(200)"
    index tt_num_erro                     
    ttv_num_msg_erro                 ascending
    .

DEFINE TEMP-TABLE tt-especie
    FIELD ttv-cod-especie AS char.

DEFINE TEMP-TABLE tt-representante
    FIELD ttv-cdn-representante AS INTEGER.

DEFINE TEMP-TABLE tt-unid-negoc
    FIELD ttv-cod-unid-negoc AS CHAR.


define var i as integer.
def var h-acomp as handle.
DEFINE VAR m-linha AS INTEGER.
DEFINE VAR m-linha-a AS INTEGER.
DEFINE VAR tinicio AS DATETIME.
DEFINE VAR tatual AS DATETIME.
DEFINE VAR c-arquiv AS CHAR.
FIND FIRST tt-param NO-ERROR. 
DEFINE VAR v-cod-cliente AS INTEGER NO-UNDO.
DEFINE VAR v-nom-cobrador AS char NO-UNDO.
DEFINE VAR v-nom-represe  AS char NO-UNDO.
DEFINE VAR v-cod-represe  AS char NO-UNDO.
DEFINE VAR v-cod-unid     AS char NO-UNDO.
DEFINE VAR v-uf            AS char NO-UNDO.
DEFINE VAR v-cnpj          AS char NO-UNDO.
DEFINE VAR v-ramo          AS char NO-UNDO.
DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.    
DEFINE VAR num-1 AS INTEGER.
DEFINE VAR num-2 AS INTEGER.
DEFINE VAR num-3 AS INTEGER.
DEFINE VAR n1 AS INTEGER.
DEFINE VAR n2 AS INTEGER.
DEFINE VAR n3 AS INTEGER.
DEFINE VAR vendedores AS char.
DEFINE VAR i-countador AS INTEGER.

ASSIGN num-1 = NUM-ENTRIES(tt-param.cod-unid-negoc).
ASSIGN num-2 = NUM-ENTRIES(tt-param.cod-especie).
ASSIGN num-3 = NUM-ENTRIES(tt-param.cod-representante).


DO n1 = 1 TO num-1:

    CREATE tt-unid-negoc.
    ASSIGN tt-unid-negoc.ttv-cod-unid-negoc = entry(n1, tt-param.cod-unid-negoc).

END.

DO n2 = 1 TO num-2:
    CREATE tt-especie.
    ASSIGN tt-especie.ttv-cod-especie = ENTRY(n2, tt-param.cod-especie).
END.


DO n3 = 1 TO num-3:
    CREATE tt-representante.
    ASSIGN tt-representante.ttv-cdn-representante = int(ENTRY(n3, tt-param.cod-representante)).
END.

FIND FIRST TT-PARAM NO-ERROR.
ASSIGN C-ARQUIV = SUBSTR(tt-param.arquivo, 1, R-INDEX(tt-param.arquivo, ".") - 1).

IF i-num-ped-exec-rpw > 0 THEN DO:
   FIND ped_exec NO-LOCK WHERE ped_exec.num_ped_exec = i-num-ped-exec-rpw NO-ERROR.
   IF AVAIL ped_exec THEN DO:
       FIND servid_exec NO-LOCK WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
       IF AVAIL servid_exec THEN 
          ASSIGN c-arquiv = TRIM(servid_exec.nom_dir_spool) + '\' + C-ARQUIV + STRING(TIME) + '.xlsx'.
   END.
END.

ELSE DO:
    ASSIGN c-arquiv = c-arquiv + STRING(TIME) + '.xlsx'.

END.
ASSIGN tinicio = NOW.

run utp/utapi013.p persistent set h-utapi013.
/*SYSTEM-DIALOG PRINTER-SETUP.*/
os-delete value(c-arquiv).
 
    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao     = 1
           tt-configuracao2.arquivo-num           = 1
           tt-configuracao2.arquivo               = c-arquiv
           tt-configuracao2.total-planilhas       = 2
           tt-configuracao2.exibir-construcao     = NO
           tt-configuracao2.abrir-excel-termino   = no
           tt-configuracao2.imprimir              = NO
           tt-configuracao2.orientacao            = 1.

    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num               = 1 
           tt-planilha2.planilha-num              = 1
           tt-planilha2.planilha-nome             = "Cobranca"
           tt-planilha2.linhas-grade              =  NO.

ASSIGN tinicio = NOW.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "gerando").
    IF tt-param.cod-tipo = 1 THEN

RUN pi-cabecalho.
RUN pi-varre-acr.


IF tt-param.cod-tipo = 2 THEN
    RUN pi-gerar-dados.


    RUN pi-finalizar IN h-acomp.

    RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).

    Delete procedure h-utapi013.


run esp/esrc799arp.p (input c-arquiv,
                      INPUT tt-param.usuario).


PROCEDURE pi-varre-acr:



assign i = 1.

       block_tit_Acr:         
       FOR EACH tt-especie,
           EACH tit_acr NO-LOCK WHERE    tit_acr.log_tit_acr_estordo = NO
                                   AND   tit_acr.log_sdo_tit_acr     = YES
                                   AND   tit_acr.dat_emis_docto      >= tt-param.data-ini
                                   AND   tit_acr.dat_emis_docto      <= tt-param.data-fim
                                   AND   tit_acr.val_sdo_tit_acr     > 0
                                   AND   tit_acr.cod_espec_docto     = tt-especie.ttv-cod-especie
                                   //and tit_acr.cod_empresa = tt-param.cod-empresa
                                   USE-INDEX titacr_clien_datas BREAK BY tit_acr.cod_estab BY tit_acr.cdn_cliente:

              ASSIGN tatual = NOW.


          FIND FIRST tt-representante WHERE ttv-cdn-representante = tit_acr.cdn_repres NO-ERROR.

          IF AVAIL tt-representante THEN DO:
              
              
              IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:

                                
                            
                                FIND FIRST emsbas.cliente NO-LOCK WHERE emsbas.cliente.cod_empresa = tit_acr.cod_empresa
                                                                  AND   emsbas.cliente.cdn_cliente = tit_acr.cdn_cliente
                                                                  
                                                                NO-ERROR.
    
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
    
                                FIND FIRST representante NO-LOCK WHERE representante.cdn_repres = tit_Acr.cdn_repres 
                                                                 AND   representante.cod_empresa = tit_Acr.cod_empresa
                                                                 NO-ERROR.
    
    
    
    
    
    
                                IF AVAIL representante THEN
                                ASSIGN v-nom-represe = representante.nom_pessoa
                                       v-cod-represe = string(representante.cdn_repres).
                                ELSE 
                                    ASSIGN v-nom-represe = "nao ha".
    
    
    
    
    
                                FIND FIRST  cobrador-cliente NO-LOCK WHERE cobrador-cliente.cod-empresa =  tit_Acr.cod_empresa
                                                                    AND   cobrador-cliente.cod-emitente = tit_Acr.cdn_cliente
                                                                     NO-ERROR.
    
                                IF AVAIL cobrador-cliente THEN DO:
    
    
    
                                FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = cobrador-cliente.cobrador NO-ERROR.
    
                                ASSIGN v-nom-cobrador = usuar_mestre.nom_usuario.
    
                                END.

                            ELSE ASSIGN v-nom-cobrador = 'Nao ha'.
                            END.

              RUN pi-acompanhar IN h-acomp (INPUT tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").
                 
                            CREATE tt_titulos_aberto_rioclarense.
                            ASSIGN tt_titulos_aberto_rioclarense.tta_cod_estab                     =  tit_acr.cod_estab 
                                   tt_titulos_aberto_rioclarense.tta_cod_espec_docto               =  tit_acr.cod_espec_docto
                                   tt_titulos_aberto_rioclarense.tta_cod_ser_docto                 =  tit_acr.cod_ser_docto
                                   tt_titulos_aberto_rioclarense.tta_cod_tit_acr                   =  tit_acr.cod_tit_acr
                                   tt_titulos_aberto_rioclarense.tta_cod_parcela                   =  tit_acr.cod_parcela
                                   tt_titulos_aberto_rioclarense.tta_dat_emis_docto                =  tit_acr.dat_emis_docto
                                   tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr            =  tit_acr.dat_vencto_tit_acr
                                   tt_titulos_aberto_rioclarense.tta_val_origin_tit_acr            =  tit_acr.val_origin_tit_acr
                                   tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr               =  tit_acr.val_sdo_tit_acr
                                   tt_titulos_aberto_rioclarense.tta_cod_indic_econ                =  tit_acr.cod_indic_econ
                                   tt_titulos_aberto_rioclarense.ttv-ramo                          =  v-ramo
                                   tt_titulos_aberto_rioclarense.ttv-nom-cobrador                  =  v-nom-cobrador
                                   tt_titulos_aberto_rioclarense.ttv-cod-vendedor                  =  int(v-cod-represe)
                                   tt_titulos_aberto_rioclarense.ttv-nom-vendedor                  =  v-nom-represe
                                   tt_titulos_aberto_rioclarense.ttv-nom-cliente                   =  tit_acr.nom_abrev
                                   tt_titulos_aberto_rioclarense.ttv-cdn-cliente                   =  tit_acr.cdn_cliente
                                   tt_titulos_aberto_rioclarense.ttv-cnpj                          =  v-cnpj
                                   tt_titulos_aberto_rioclarense.ttv-estado                        =  v-uf.

                            
                            IF tt-param.cod-tipo = 2 THEN NEXT block_tit_Acr.

              FIND FIRST movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_empresa = tit_acr.cod_empresa
                                 AND   movto_tit_acr.cod_estab   = tit_acr.cod_estab
                                 AND   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                 AND   movto_tit_acr.dat_transacao  = tit_acr.dat_transacao NO-ERROR.

              FOR EACH tt-unid-negoc,
                  EACH aprop_ctbl_acr NO-LOCK WHERE aprop_ctbl_acr.cod_empresa = movto_tit_acr.cod_empresa
                                                AND   aprop_ctbl_acr.cod_estab   = movto_tit_acr.cod_estab
                                                AND   aprop_ctbl_acr.ind_tip_aprop_ctbl = "Saldo"
                                                AND   aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                                AND   aprop_ctbl_acr.cod_unid_negoc       = tt-unid-negoc.ttv-cod-unid-negoc:
                            ASSIGN v-cod-unid = aprop_ctbl_acr.cod_unid_negoc.

                            RUN pi-cria-planilha.
              END.
          END.
	end.
 END PROCEdure.



PROCEDURE pi-cria-planilha:

   RUN pi-acompanhar IN h-acomp (INPUT tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_estab                  
           celula-fonte-cor                = 1.      
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 2                         
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_espec_docto                    
           celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 3                          
           celula-formato                  = '@@'
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_ser_docto                 
           celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 4                         
           celula-formato                  = '@@'
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_tit_Acr                 
           celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 5                         
           celula-formato                  = '@@'
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_parcela               
           celula-fonte-cor                = 1.      
    
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 6                         
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = string(tit_acr.dat_emis_docto)               
           celula-fonte-cor                = 1.      
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 7                         
           celula-formato                  = '@@'
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = string(tit_acr.dat_vencto_tit_acr)               
           celula-fonte-cor                = 1.      
    
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 8                         
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = string(tit_acr.val_origin_tit_Acr * (aprop_ctbl_acr.val_aprop_ctbl / tit_acr.val_origin_tit_Acr))                 
           celula-fonte-cor                = 1.      
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 9                         
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = string(tit_acr.val_sdo_tit_acr * (aprop_ctbl_acr.val_aprop_ctbl / tit_acr.val_origin_tit_Acr))               
           celula-fonte-cor                = 1.      
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 10                        
           celula-formato                  = '@@'
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = tit_acr.cod_indic_econ                
           celula-fonte-cor                = 1.      
    
    


        IF tit_acr.dat_vencto_tit_acr >= TODAY THEN DO:
            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 11                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = "AV"                 
                   celula-fonte-cor                = 1.      
            
             END.

         ELSE DO:
             CREATE tt-dados.
             ASSIGN arquivo-num                     = 1                          
                    planilha-num                    = 1                          
                    celula-coluna                   = 11                         
                    celula-formato                  = '@@'
                    celula-linha                    = m-linha                          
                    celula-cor-interior             = 58                          
                    celula-valor                    = "V"                 
                    celula-fonte-cor                = 1.      
             
         END.
        
         CREATE tt-dados.
         ASSIGN arquivo-num                     = 1                          
                planilha-num                    = 1                          
                celula-coluna                   = 12                         
                celula-linha                    = m-linha                          
                celula-cor-interior             = 58                          
                celula-valor                    = string(tit_acr.dat_vencto_tit_Acr)                
                celula-fonte-cor                = 1.      
         


            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 13                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-nom-cobrador                
                   celula-fonte-cor                = 1.      
            

        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 14                         
               celula-formato                  = '@@'
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = v-cod-represe                
               celula-fonte-cor                = 1.      
            
            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 15                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-nom-represe                 
                   celula-fonte-cor                = 1.      

            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 16                        
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = string(tit_acr.cdn_cliente)                 
                   celula-fonte-cor                = 1.      


            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 17                       
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = tit_acr.nom_abrev                 
                   celula-fonte-cor                = 1.      

            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 18                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-uf                
                   celula-fonte-cor                = 1.      

            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 19                        
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-cnpj                
                   celula-fonte-cor                = 1.    

            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 20                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-ramo                
                   celula-fonte-cor                = 1.      

            CREATE tt-dados.
            ASSIGN arquivo-num                     = 1                          
                   planilha-num                    = 1                          
                   celula-coluna                   = 21                         
                   celula-formato                  = '@@'
                   celula-linha                    = m-linha                          
                   celula-cor-interior             = 58                          
                   celula-valor                    = v-cod-unid               
                   celula-fonte-cor                = 1.      



            IF  abs((TODAY - tit_acr.dat_vencto_tit_acr)) > 0
            and abs((TODAY - tit_acr.dat_vencto_tit_acr)) <= 30 THEN do:

                CREATE tt-dados.
                ASSIGN arquivo-num                     = 1                          
                       planilha-num                    = 1                          
                       celula-coluna                   = 22                         
                       celula-formato                  = '@@'
                       celula-linha                    = m-linha                          
                       celula-cor-interior             = 58                          
                       celula-valor                    = "Ate 30 dias"              
                       celula-fonte-cor                = 1.      
            end.           

            IF abs((TODAY - tit_acr.dat_vencto_tit_acr)) > 30
            AND abs((TODAY - tit_acr.dat_vencto_tit_acr)) <= 60 THEN do:

                CREATE tt-dados.
                ASSIGN arquivo-num                     = 1                          
                       planilha-num                    = 1                          
                       celula-coluna                   = 22                         
                       celula-formato                  = '@@'
                       celula-linha                    = m-linha                          
                       celula-cor-interior             = 58                          
                       celula-valor                    = "31 a 60 dias"              
                       celula-fonte-cor                = 1.  
            end.    


            IF abs((TODAY - tit_acr.dat_vencto_tit_acr)) > 60
            AND abs((TODAY - tit_acr.dat_vencto_tit_acr)) <= 90 THEN do:

                CREATE tt-dados.
                ASSIGN arquivo-num                     = 1                          
                       planilha-num                    = 1                          
                       celula-coluna                   = 22                         
                       celula-formato                  = '@@'
                       celula-linha                    = m-linha                          
                       celula-cor-interior             = 58                          
                       celula-valor                    = "60 a 90 dias"              
                       celula-fonte-cor                = 1.      
            end.


            IF abs((TODAY - tit_acr.dat_vencto_tit_acr)) > 90
            AND abs((TODAY - tit_acr.dat_vencto_tit_acr)) <= 120 THEN do:

                CREATE tt-dados.
                ASSIGN arquivo-num                     = 1                          
                       planilha-num                    = 1                          
                       celula-coluna                   = 22                         
                       celula-formato                  = '@@'
                       celula-linha                    = m-linha                          
                       celula-cor-interior             = 58                          
                       celula-valor                    = "90 a 120 dias"              
                       celula-fonte-cor                = 1.  
            end.    


            IF abs((TODAY - tit_acr.dat_vencto_tit_acr)) > 120
            THEN do:

                CREATE tt-dados.
                ASSIGN arquivo-num                     = 1                          
                       planilha-num                    = 1                          
                       celula-coluna                   = 22                         
                       celula-formato                  = '@@'
                       celula-linha                    = m-linha                          
                       celula-cor-interior             = 58                          
                       celula-valor                    = "Mais de 120 dias"              
                       celula-fonte-cor                = 1.      

            end.
            
ASSIGN m-linha = m-linha + 1.



END PROCEDURE.



PROCEDURE pi-cabecalho:


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Estab"                    
           celula-fonte-cor                = 1.                          
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 2                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Especie"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 3                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Serie"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 4                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Titulo"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 5                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Parcela"                    
           celula-fonte-cor                = 1.      


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 6                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Dt.Emissao"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 7                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Dt.Vcto"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 8                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Vlr.Original"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 9                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Vlr.Saldo"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 10                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Moeda"                    
           celula-fonte-cor                = 1.    

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 11                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Situacao"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 12                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Fx.Vcto"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 13                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Cobrador"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 14                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Cod.Repres"                    
           celula-fonte-cor                = 1.           


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 15                        
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Vendedor"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 16                        
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Cod.Cliente"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 17                         
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Nome"                    
           celula-fonte-cor                = 1.           


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 18                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "UF"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 19                         
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "CNPJ"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 20                         
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Ramo"                    
           celula-fonte-cor                = 1.           

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 21                        
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "U.N"                    
           celula-fonte-cor                = 1.           


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 22                        
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Faixa"                    
           celula-fonte-cor                = 1.           


    ASSIGN m-linha = 2.
    ASSIGN m-linha-a = 2.

END PROCEDURE.

PROCEDURE pi-gerar-dados:
    DEFINE VAR i AS INTEGER.
    DEFINE VAR i-linha AS INTEGER.
    DEFINE VAR i-coluna AS INTEGER.

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Data"                    
           celula-fonte-cor                = 1.                          


    FOR EACH tt_titulos_aberto_rioclarense  WHERE tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr <= TODAY
        BREAK BY tt_titulos_aberto_rioclarense.ttv-nom-cobrador:
        IF FIRST-OF(tt_titulos_aberto_rioclarense.ttv-nom-cobrador) THEN DO:
            
            ASSIGN vendedores = tt_titulos_aberto_rioclarense.ttv-nom-cobrador + ',' + vendedores.

        END.

    END.


    ASSIGN i-countador = NUM-ENTRIES(vendedores).


    DO i = 1 TO i-countador:

        ASSIGN i-coluna = i + 1.
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = (i-coluna)                          
               celula-linha                    = 1                          
               celula-cor-interior             = 6                          
               celula-valor                    = ENTRY(i, vendedores)                    
               celula-fonte-cor                = 1.                          

    END.

    ASSIGN i-linha = 2.
    ASSIGN i-coluna = 1.
               CREATE tt-dados.
               ASSIGN arquivo-num                     = 1                          
                      planilha-num                    = 1                          
                      celula-coluna                   = (1)                          
                      celula-linha                    = i-linha                          
                      celula-cor-interior             = 58                          
                      celula-valor                    = string(TODAY)                   
                      celula-fonte-cor                = 1.                          
    
    

   DO i = 1 TO i-countador:

    
    
       FOR EACH tt_titulos_aberto_rioclarense  WHERE tt_titulos_aberto_rioclarense.ttv-nom-cobrador = ENTRY(i, vendedores)
                                               AND    tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr <= TODAY
                                               BREAK BY tt_titulos_aberto_rioclarense.ttv-nom-cobrador:

           ACCUMULATE tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr (SUB-TOTAL BY tt_titulos_aberto_rioclarense.ttv-nom-cobrador).

           IF LAST-OF(tt_titulos_aberto_rioclarense.ttv-nom-cobrador) THEN DO:
               ASSIGN i-coluna = i + 1.

               
               CREATE tt-dados.
               ASSIGN arquivo-num                     = 1                          
                      planilha-num                    = 1                          
                      celula-coluna                   = i-coluna                          
                      celula-linha                    = i-linha                          
                      celula-cor-interior             = 58                          
                      celula-valor                    = string(ACCUM SUB-TOTAL BY tt_titulos_aberto_rioclarense.ttv-nom-cobrador tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr )                   
                      celula-fonte-cor                = 1.                          
               
           END.
       
       END.

   END.



END PROCEDURE.


