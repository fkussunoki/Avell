
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


DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE VAR h-prog AS HANDLE.
define var i as integer.
def var h-acomp as handle.
DEFINE VAR m-linha AS INTEGER.
DEFINE VAR m-linha-a AS char.
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
DEFINE VAR v-concatena     AS CHAR NO-UNDO.
DEFINE VAR v-concatena1    AS char NO-UNDO.
DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.    
DEFINE VAR num-1 AS INTEGER.
DEFINE VAR num-2 AS INTEGER.
DEFINE VAR num-3 AS INTEGER.
DEFINE VAR n1 AS INTEGER.
DEFINE VAR n2 AS INTEGER.
DEFINE VAR n3 AS INTEGER.

def OUTPUT param TABLE FOR tt_titulos_aberto_rioclarense.
RUN pi-varre-acr.


PROCEDURE pi-varre-acr:


assign i = 1.

           FOR EACH tit_acr NO-LOCK WHERE tit_acr.cod_empresa = v_cod_empres_usuar
                                   AND   tit_acr.log_tit_acr_estordo = NO
                                   AND   tit_acr.log_sdo_tit_acr     = YES
                                   AND   tit_acr.dat_emis_docto      >= 01/01/2000
                                   AND   tit_acr.dat_emis_docto      <= 12/31/2040
                                   AND   tit_acr.val_sdo_tit_acr     > 0
                                   AND   tit_acr.ind_tip_espec_docto = "Normal"
                                   USE-INDEX titacr_clien_datas BREAK BY tit_acr.cod_estab BY tit_acr.cdn_cliente:

              ASSIGN tatual = NOW.


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



                            FIND FIRST clien_financ NO-LOCK WHERE clien_financ.cod_empresa = emsbas.cliente.cod_empresa
                                                            AND   clien_financ.cdn_cliente = emsbas.cliente.cdn_cliente
                                                            AND   clien_financ.cod_tip_clien = emsbas.cliente.cod_tip_clien
                                                            
                                                            NO-ERROR.

                            

                            FIND FIRST representante NO-LOCK WHERE representante.cdn_repres = clien_financ.cdn_repres 
                                                             AND   representante.cod_empresa = clien_financ.cod_empresa
                                                             NO-ERROR.

                            IF AVAIL representante THEN
                            ASSIGN v-nom-represe = representante.nom_pessoa
                                   v-cod-represe = string(representante.cdn_repres).
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
              END.

                 


              FIND FIRST movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_empresa = tit_acr.cod_empresa
                                 AND   movto_tit_acr.cod_estab   = tit_acr.cod_estab
                                 AND   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                                 AND   movto_tit_acr.dat_transacao  = tit_acr.dat_transacao NO-ERROR.

               FOR EACH aprop_ctbl_acr NO-LOCK WHERE aprop_ctbl_acr.cod_empresa = movto_tit_acr.cod_empresa
                                                AND   aprop_ctbl_acr.cod_estab   = movto_tit_acr.cod_estab
                                                AND   aprop_ctbl_acr.ind_tip_aprop_ctbl = "Saldo"
                                                AND   aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr:


                            ASSIGN v-cod-unid = aprop_ctbl_acr.cod_unid_negoc.


                            RUN pi-acerta-planilha.
                      END.      
              END.

 END PROCEdure.

PROCEDURE pi-acerta-planilha:

    CREATE tt_titulos_aberto_rioclarense.
    ASSIGN tt_titulos_aberto_rioclarense.tta_cod_estab                  =   tit_acr.cod_estab
           tt_titulos_aberto_rioclarense.tta_cod_espec_docto            =   tit_acr.cod_espec_docto
           tt_titulos_aberto_rioclarense.tta_cod_ser_docto              =   tit_acr.cod_ser_docto
           tt_titulos_aberto_rioclarense.tta_cod_tit_acr                =   tit_acr.cod_tit_acr
           tt_titulos_aberto_rioclarense.tta_cod_parcela                =   tit_acr.cod_parcela
           tt_titulos_aberto_rioclarense.tta_dat_emis_docto             =   tit_acr.dat_emis_docto
           tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr         =   tit_acr.dat_vencto_tit_acr
           tt_titulos_aberto_rioclarense.tta_val_origin_tit_acr         =   tit_acr.val_origin_tit_acr
           tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr            =   tit_acr.val_sdo_tit_acr
           tt_titulos_aberto_rioclarense.tta_cod_indic_econ             =   tit_acr.cod_indic_econ
           tt_titulos_aberto_rioclarense.ttv-ramo                       =   v-ramo
           tt_titulos_aberto_rioclarense.ttv-nom-cobrador               =   v-nom-cobrador
           tt_titulos_aberto_rioclarense.ttv-cod-vendedor               =   int(v-cod-represe)
           tt_titulos_aberto_rioclarense.ttv-nom-vendedor               =   v-nom-represe
           tt_titulos_aberto_rioclarense.ttv-nom-cliente                =   tit_acr.nom_abrev
           tt_titulos_aberto_rioclarense.ttv-cdn-cliente                =   tit_acr.cdn_cliente
           tt_titulos_aberto_rioclarense.ttv-cnpj                       =   v-cnpj
           tt_titulos_aberto_rioclarense.ttv-estado                     =   v-uf.

    ASSIGN v-concatena                                                  = v-nom-cobrador.


      IF tit_acr.dat_vencto_tit_acr >= TODAY THEN
            ASSIGN tt_titulos_aberto_rioclarense.ttv_num_situacao             = "AV"
                   v-concatena                                                = v-concatena + "AV"
                   v-concatena1                                               = "AV" + v-ramo.
      ELSE
      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_situacao                    = "V"
             v-concatena                                                      = v-concatena + "V"
             v-concatena1                                                     = "V" + v-ramo.


      IF  abs(TODAY - tit_acr.dat_vencto_tit_acr) >=0
      AND ABS(TODAY - tit_acr.dat_vencto_tit_acr) <= 30 THEN

      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto                = "Faixa1"
             v-concatena                                                       = v-concatena + "Faixa1".
                                                                              
      IF  abs(TODAY - tit_acr.dat_vencto_tit_acr) >  30                       
      AND ABS(TODAY - tit_acr.dat_vencto_tit_acr) <= 60 THEN                  
                                                                              
      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto                = "Faixa2"
             v-concatena                                                       = v-concatena + "Faixa2".
                                                                              
      IF  abs(TODAY - tit_acr.dat_vencto_tit_acr) >  60                       
      AND ABS(TODAY - tit_acr.dat_vencto_tit_acr) <= 90 THEN                  
                                                                              
      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto                = "Faixa3"
             v-concatena                                                       = v-concatena + "Faixa3".
                                                                              
      IF  abs(TODAY - tit_acr.dat_vencto_tit_acr) >  90                       
      AND ABS(TODAY - tit_acr.dat_vencto_tit_acr) <= 120 THEN                 
                                                                              
      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto                = "Faixa4"
             v-concatena                                                       = v-concatena + "Faixa4".
                                                                              
      IF  abs(TODAY - tit_acr.dat_vencto_tit_acr) >  120 THEN                 
                                                                              
      ASSIGN tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto                = "Faixa5"
             v-concatena                                                       = v-concatena + "Faixa5".

      ASSIGN tt_titulos_aberto_rioclarense.ttv-concatena                       = v-concatena
             tt_titulos_aberto_rioclarense.ttv-concatena1                      = v-concatena1.


END PROCEDURE.

