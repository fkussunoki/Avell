
{utp/ut-glob.i}


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
    field ttv_num_situacao                 as CHAR
    field ttv_num_faixa_vencto             as CHAR
    FIELD tta_val_aprop_ctbl               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 
    field ttv-ramo                         AS char
    field ttv-cod-cobrador                 AS char
    field ttv-nom-cobrador                 AS char
    field ttv-cod-vendedor                 AS INTEGER
    field ttv-nom-vendedor                 AS char
    FIELD ttv-nom-cliente                  AS char
    FIELD ttv-cdn-cliente                  AS INTEGER
    FIELD ttv-cnpj                         AS CHAR
    FIELD ttv-estado                       AS char
    FIELD ttv-unid-negoc                   AS CHAR
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


DEFINE TEMP-TABLE tt-dados-clientes
    FIELD ttv-uf             AS CHAR
    FIELD ttv-cnpj           AS CHAR
    FIELD ttv-ramo           AS CHAR
    FIELD ttv-nome-rep       AS CHAR
    FIELD ttv-cod-rep        AS INTEGER
    FIELD ttv-nom-cobrador   AS CHAR
    FIELD ttv-cdn-cliente    AS INTEGER
    FIELD ttv-cod-estab      AS CHAR
    INDEX tt_idx
    ttv-cdn-cliente          ASCENDING
    ttv-cod-estab        ASCENDING.


define var i as integer.
DEF NEW GLOBAL SHARED var h-acomp as HANDLE NO-UNDO.
DEFINE VAR m-linha AS INTEGER.
DEFINE VAR m-linha-a AS INTEGER.
DEFINE VAR tinicio AS DATETIME.
DEFINE VAR tatual AS DATETIME.
DEFINE VAR c-arquiv AS CHAR.
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

DEFINE OUTPUT PARAM TABLE FOR tt_titulos_aberto_rioclarense.

ASSIGN tinicio = NOW.


    block_tit_Acr:         
    FOR EACH tit_acr  NO-LOCK WHERE   tit_acr.cod_estab           >= ""
                               AND    tit_acr.cod_estab           <= "zzz"
                               AND    tit_acr.cod_espec_docto     >= ""
                               AND    tit_acr.cod_espec_docto     <= "zzz"
                               AND    tit_acr.log_sdo_tit_acr     = YES
                               AND    tit_acr.dat_vencto_tit_acr  >= 01/01/2009
                               AND    tit_acr.dat_vencto_tit_acr  <= 12/31/2040
                               AND   tit_acr.ind_tip_espec_docto = "Normal"
                               BREAK BY tit_acr.cod_estab BY tit_acr.cdn_cliente:

        RUN pi-acompanhar IN h-acomp (INPUT "ESRC798a " + tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").

           ASSIGN tatual = NOW.

           IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
    
            RUN pi-varre-acr.

           END.

            RUN pi-cria-tt-titulos.

    END.




PROCEDURE pi-varre-acr:

    RUN pi-acompanhar IN h-acomp (INPUT "ESRC798a PI-VARRE" + tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").


assign i = 1.



              
              
                  FIND FIRST tt-dados-clientes NO-LOCK WHERE tt-dados-clientes.ttv-cdn-cliente = tit_acr.cdn_cliente
                                                       AND   tt-dados-clientes.ttv-cod-estab   = tit_Acr.cod_estab NO-ERROR.


                  IF NOT AVAIL tt-dados-clientes THEN DO:
                      CREATE tt-dados-clientes.
                      ASSIGN tt-dados-clientes.ttv-cdn-cliente = tit_acr.cdn_cliente
                             tt-dados-clientes.ttv-cod-estab   = tit_acr.cod_estab.
                      FIND FIRST emsbas.cliente NO-LOCK WHERE emsbas.cliente.cod_empresa = tit_acr.cod_empresa
                                                        AND   emsbas.cliente.cdn_cliente = tit_acr.cdn_cliente

                                                      NO-ERROR.

                      IF length(emsbas.cliente.cod_id_feder) < 14 THEN DO:

                          FIND FIRST pessoa_fisic NO-LOCK WHERE pessoa_fisic.num_pessoa_fisic = emsbas.cliente.num_pessoa 
                                                          AND   pessoa_fisic.cod_id_feder     = emsbas.cliente.cod_id_feder 
                                                          AND   pessoa_fisic.nom_pessoa       = emsbas.cliente.nom_pessoa NO-ERROR.

                          IF AVAIL pessoa_fisic THEN DO:
                              ASSIGN tt-dados-clientes.ttv-uf   = pessoa_fisic.cod_unid_federac        
                                     tt-dados-clientes.ttv-cnpj = pessoa_fisic.cod_id_feder.
                              
                              FIND FIRST pessoa_fisic_ativid NO-LOCK WHERE pessoa_fisic_ativid.num_pessoa_fisic = pessoa_fisic.num_pessoa_fisic NO-ERROR.
                              IF AVAIL pessoa_fisic_ativid THEN
                                ASSIGN tt-dados-clientes.ttv-ramo = pessoa_fisic_ativid.cod_ativid_pessoa_fisic.
                              ELSE
                                ASSIGN tt-dados-clientes.ttv-ramo = "nao ha".

                          END.
                      END.
                      ELSE DO:
                          FIND FIRST pessoa_jurid NO-LOCK WHERE pessoa_jurid.num_pessoa_jurid = emsbas.cliente.num_pessoa     
                                                          AND   pessoa_jurid.cod_id_feder     = emsbas.cliente.cod_id_feder
                                                          AND   pessoa_jurid.nom_pessoa       = emsbas.cliente.nom_pessoa NO-ERROR.

                           ASSIGN tt-dados-clientes.ttv-uf   = pessoa_jurid.cod_unid_federac
                                  tt-dados-clientes.ttv-cnpj = pessoa_jurid.cod_id_feder.

                          FIND FIRST pessoa_jurid_ativid NO-LOCK WHERE pessoa_jurid_ativid.num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.

                          IF AVAIL pessoa_jurid_ativid THEN
                           ASSIGN tt-dados-clientes.ttv-ramo = pessoa_jurid_ativid.cod_ativid_pessoa_jurid.
                         ELSE                                 
                           ASSIGN tt-dados-clientes.ttv-ramo = "Nao ha".
                      END.
                      
                      FIND FIRST representante NO-LOCK WHERE representante.cdn_repres = tit_Acr.cdn_repres 
                                                       AND   representante.cod_empresa = tit_Acr.cod_empresa
                                                       NO-ERROR.
                      IF AVAIL representante THEN
                      ASSIGN tt-dados-clientes.ttv-nome-rep = representante.nom_pessoa
                             tt-dados-clientes.ttv-cod-rep  = representante.cdn_repres.
                      ELSE 
                          ASSIGN tt-dados-clientes.ttv-nome-rep = "nao ha".


                          FIND FIRST  cobrador-cliente NO-LOCK WHERE cobrador-cliente.cod-empresa =  tit_Acr.cod_empresa
                                                              AND   cobrador-cliente.cod-emitente = tit_Acr.cdn_cliente
                                                               NO-ERROR.

                          IF AVAIL cobrador-cliente THEN DO:



                          FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = cobrador-cliente.cobrador NO-ERROR.

                          ASSIGN tt-dados-clientes.ttv-nom-cobrador = usuar_mestre.nom_usuario.

                          END.

                      ELSE ASSIGN tt-dados-clientes.ttv-nom-cobrador = 'Nao ha'.
                  END.

END PROCEDURE.

PROCEDURE pi-cria-tt-titulos:

              RUN pi-acompanhar IN h-acomp (INPUT "ESRC798a PI-VARRE" + tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").


              FIND FIRST tt-dados-clientes NO-LOCK WHERE tt-dados-clientes.ttv-cdn-cliente        = tit_Acr.cdn_cliente
                                                   AND   tt-dados-clientes.ttv-cod-estab          = tit_acr.cod_estab NO-ERROR.

              IF AVAIL tt-dados-clientes THEN DO:
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
                         tt_titulos_aberto_rioclarense.ttv-ramo                          =  tt-dados-clientes.ttv-ramo
                         tt_titulos_aberto_rioclarense.ttv-nom-cobrador                  =  tt-dados-clientes.ttv-nom-cobrador
                         tt_titulos_aberto_rioclarense.ttv-cod-vendedor                  =  tt-dados-clientes.ttv-cod-rep
                         tt_titulos_aberto_rioclarense.ttv-nom-vendedor                  =  tt-dados-clientes.ttv-nome-rep
                         tt_titulos_aberto_rioclarense.ttv-nom-cliente                   =  tit_acr.nom_abrev
                         tt_titulos_aberto_rioclarense.ttv-cdn-cliente                   =  tit_acr.cdn_cliente
                         tt_titulos_aberto_rioclarense.ttv-cnpj                          =  tt-dados-clientes.ttv-cnpj
                         tt_titulos_aberto_rioclarense.ttv-estado                        =  tt-dados-clientes.ttv-uf.

                  FIND FIRST movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_empresa = tit_acr.cod_empresa
                                     AND   movto_tit_acr.cod_estab   = tit_acr.cod_estab
                                     AND   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                     AND   movto_tit_acr.dat_transacao  = tit_acr.dat_transacao NO-ERROR.
                  FOR EACH aprop_ctbl_acr NO-LOCK WHERE aprop_ctbl_acr.cod_empresa = movto_tit_acr.cod_empresa
                                                  AND   aprop_ctbl_acr.cod_estab   = movto_tit_acr.cod_estab
                                                  AND   aprop_ctbl_acr.ind_tip_aprop_ctbl = "Saldo"
                                                  AND   aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr:

                      ASSIGN tt_titulos_Aberto_rioclarense.ttv-unid-negoc                = aprop_ctbl_acr.cod_unid_negoc 
                             tt_titulos_aberto_rioclarense.tta_val_aprop_ctbl           = aprop_ctbl_acr.val_aprop_ctbl.

                  END.

              END.
                 


 END PROCEdure.


