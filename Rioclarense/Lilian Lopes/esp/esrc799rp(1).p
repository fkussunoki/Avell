
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

    {include/i-rpvar.i}
  
  
    /* include padr’o para output de relat½rios */
    {include/i-rpout.i &STREAM="stream str-rp"}
    /* include com a defini?’o da frame de cabe?alho e rodap' */
    /* bloco principal do programa */
    assign c-programa 	= "FGLA3131RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa 	= "Alcast"
        c-sistema	= "Datasul EMS"
        c-titulo-relat = "Titulos Gerados".
    view stream str-rp frame f-cabec.
    view stream str-rp frame f-rodape.



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


DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE VAR h-prog AS HANDLE.
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
DEFINE VAR v-uf            AS char NO-UNDO.
DEFINE VAR v-cnpj          AS char NO-UNDO.
DEFINE VAR v-ramo          AS char NO-UNDO.
DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.    




ASSIGN c-arquiv = tt-param.arquivo.
ASSIGN tinicio = NOW.
	RUN utp/utapi033.p PERSISTENT SET h-handle.


    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "gerando").
RUN pi-cabecalho.
RUN pi-varre-acr.
    RUN pi-finalizar IN h-acomp.

/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 14                                                                */
/*            tt-tabdin.ORIENTATION  = 1.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 11                                                                */
/*            tt-tabdin.ORIENTATION  = 2.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 12                                                                */
/*            tt-tabdin.ORIENTATION  = 2.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 9                                                                 */
/*            tt-tabdin.ORIENTATION  = 4                                                           */
/*            tt-tabdin.FUNCTION  = 0.                                                             */
/*     RUN add-tabdin IN h-utapi013  (1,1,"Resumo",1,18,2, m-linha, INPUT-OUTPUT TABLE tt-tabdin). */
/*                                                                                                 */

RUN piProcessa IN h-handle (INPUT-OUTPUT c-arquiv,
                            INPUT "Teste",
                            INPUT "Cobranca").

RUN show IN h-handle (false).

IF VALID-HANDLE(h-handle) THEN
    DELETE OBJECT h-handle.


PROCEDURE pi-varre-acr:



assign i = 1.

                
                                    
          FOR EACH tit_acr NO-LOCK WHERE tit_acr.cod_empresa = v_cod_empres_usuar
                                   AND   tit_acr.log_tit_acr_estordo = NO
                                   AND   tit_acr.log_sdo_tit_acr     = YES
                                   AND   tit_acr.dat_emis_docto      >= tt-param.data-ini
                                   AND   tit_acr.dat_emis_docto      <= tt-param.data-fim
                                   AND   tit_acr.val_sdo_tit_acr     > 0
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

                                ASSIGN v-uf = pessoa_fisic.cod_unid_federac
                                       v-cnpj = pessoa_fisic.cod_id_feder.
                                FIND FIRST pessoa_fisic_ativid NO-LOCK WHERE pessoa_fisic_ativid.num_pessoa_fisic = pessoa_fisic.num_pessoa_fisic NO-ERROR.
                                IF AVAIL pessoa_fisic_ativid THEN
                                ASSIGN v-ramo = pessoa_fisic_ativid.cod_ativid_pessoa_fisic.
                                ELSE
                                ASSIGN v-ramo = "Nao ha".


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
                            ASSIGN v-nom-represe = representante.nom_pessoa.
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

              RUN pi-acompanhar IN h-acomp (INPUT tit_acr.cod_estab + " " + string(tit_acr.cdn_cliente) + " " + tit_acr.cod_tit_acr + " " + string(INTErval(tatual, tinicio, "minutes")) + " minutos").
                 



                            
/*                             FIND FIRST tt_titulos_aberto_rioclarense WHERE tt_titulos_aberto_rioclarense.tta_cod_estab           =  tt_titulos_aberto_clien.tta_cod_estab                                                                                              */
/*                                                                      and   tt_titulos_aberto_rioclarense.tta_cod_espec_docto     =  tt_titulos_aberto_clien.tta_cod_espec_docto                                                                                        */
/*                                                                      and   tt_titulos_aberto_rioclarense.tta_cod_ser_docto       =  tt_titulos_aberto_clien.tta_cod_ser_docto                                                                                          */
/*                                                                      and   tt_titulos_aberto_rioclarense.tta_cod_tit_acr         =  tt_titulos_aberto_clien.tta_cod_tit_acr                                                                                            */
/*                                                                      and   tt_titulos_aberto_rioclarense.tta_cod_parcela         =  tt_titulos_aberto_clien.tta_cod_parcela                                                                                            */
/*                                                                      AND   tt_titulos_Aberto_rioclarense.ttv_rec_id              =  tt_titulos_Aberto_clien.ttv_rec_id NO-ERROR.                                                                                       */
/*                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                        */
/*                         IF NOT AVAIL tt_titulos_aberto_rioclarense                                                                                                                                                                                                     */
/*                             THEN DO:                                                                                                                                                                                                                                   */
/*                             CREATE tt_titulos_Aberto_rioclarense.                                                                                                                                                                                                      */
/*                             ASSIGN tt_titulos_Aberto_rioclarense.ttv_rec_id                =  tt_titulos_aberto_clien.ttv_rec_id                                                                                                                                       */
/*                             tt_titulos_aberto_rioclarense.tta_cod_estab                    = tt_titulos_aberto_clien.tta_cod_estab                                                                                                                                     */
/*                             tt_titulos_aberto_rioclarense.tta_cod_espec_docto              = tt_titulos_aberto_clien.tta_cod_espec_docto                                                                                                                               */
/*                             tt_titulos_aberto_rioclarense.tta_cod_ser_docto                = tt_titulos_aberto_clien.tta_cod_ser_docto                                                                                                                                 */
/*                             tt_titulos_aberto_rioclarense.tta_cod_tit_acr                  = tt_titulos_aberto_clien.tta_cod_tit_acr                                                                                                                                   */
/*                             tt_titulos_aberto_rioclarense.tta_cod_parcela                  = tt_titulos_aberto_clien.tta_cod_parcela                                                                                                                                   */
/*                             tt_titulos_aberto_rioclarense.tta_dat_emis_docto               = tt_titulos_aberto_clien.tta_dat_emis_docto                                                                                                                                */
/*                             tt_titulos_aberto_rioclarense.tta_dat_vencto_tit_acr           = tt_titulos_aberto_clien.tta_dat_vencto_tit_acr                                                                                                                            */
/*                             tt_titulos_aberto_rioclarense.tta_val_origin_tit_acr           = tt_titulos_aberto_clien.tta_val_origin_tit_acr                                                                                                                            */
/*                             tt_titulos_aberto_rioclarense.tta_val_sdo_tit_acr              = tt_titulos_aberto_clien.tta_val_sdo_tit_acr                                                                                                                               */
/*                             tt_titulos_aberto_rioclarense.tta_cod_indic_econ               = tt_titulos_aberto_clien.tta_cod_indic_econ                                                                                                                                */
/*                             tt_titulos_aberto_rioclarense.ttv_val_origin_indic_econ        = tt_titulos_aberto_clien.ttv_val_origin_indic_econ                                                                                                                         */
/*                             tt_titulos_aberto_rioclarense.ttv_val_sdo_indic_econ           = tt_titulos_aberto_clien.ttv_val_sdo_indic_econ                                                                                                                            */
/*                             tt_titulos_aberto_rioclarense.ttv_num_situacao                 = tt_titulos_aberto_clien.ttv_num_situacao                                                                                                                                  */
/*                             tt_titulos_aberto_rioclarense.ttv_num_faixa_vencto             = tt_titulos_aberto_clien.ttv_num_faixa_vencto                                                                                                                              */
/*                             tt_titulos_aberto_rioclarense.ttv-ramo                         = emitente.atividade.                                                                                                                                                       */
/*                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                        */
/*                             IF AVAIL cobrador-cliente THEN DO:                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                        */
/*                             ASSIGN tt_titulos_aberto_rioclarense.ttv-cod-cobrador                 = cobrador-cliente.cobrador                                                                                                                                          */
/*                                    tt_titulos_aberto_rioclarense.ttv-nom-cobrador                 = usuar_mestre.nom_usuario.                                                                                                                                          */
/*                                    /* tt_titulos_Aberto_rioclarense.ttv-concatena                       = cobrador-cliente.cobrador + string(tt_titulos_aberto_clien.ttv_num_situacao) + string(tt_titulos_aberto_clien.ttv_num_faixa_vencto) + emitente.atividade. */ */
/*                             END.                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                                        */
/*                             ELSE DO:                                                                                                                                                                                                                                   */
/*                             ASSIGN   tt_titulos_aberto_rioclarense.ttv-cod-cobrador                 = "Verificar"                                                                                                                                                      */
/*                                      tt_titulos_aberto_rioclarense.ttv-nom-cobrador                 = "Verificar".                                                                                                                                                     */
/*                                      /* tt_titulos_Aberto_rioclarense.ttv-concatena                    = "verificar" + string(tt_titulos_aberto_clien.ttv_num_situacao) + string(tt_titulos_aberto_clien.ttv_num_faixa_vencto) + emitente.atividade. */                */
/*                                                                                                                                                                                                                                                                        */
/*                             END.                                                                                                                                                                                                                                       */
/*                             ASSIGN                                                                                                                                                                                                                                     */
/*                             tt_titulos_aberto_rioclarense.ttv-cod-vendedor                 = representante.cdn_repres                                                                                                                                                  */
/*                             tt_titulos_aberto_rioclarense.ttv-nom-vendedor                 = representante.nom_pessoa                                                                                                                                                  */
/*                             tt_titulos_aberto_rioclarense.ttv-cdn-cliente                  = tit_acr.cdn_cliente                                                                                                                                                       */
/*                             tt_titulos_Aberto_rioclarense.ttv-nom-cliente                  = emitente.nome-abrev                                                                                                                                                       */
/*                             tt_titulos_aberto_rioclarense.ttv-cnpj                         = emitente.cgc                                                                                                                                                              */
/*                             tt_titulos_Aberto_rioclarense.ttv-estado                       = emitente.estado.                                                                                                                                                          */
/*                                                                                                                                                                                                                                                                        */
                            RUN pi-cria-planilha.
                      END.      

 END PROCEdure.



PROCEDURE pi-cria-planilha:


/*     FOR EACH tt_titulos_aberto_rioclarense USE-INDEX tt_padrao:  */

	RUN piNewLine IN h-handle.
    RUN piLine IN h-handle (INPUT 1,
                            INPUT tit_acr.cod_estab).

    RUN piLine IN h-handle (INPUT 2,
                            INPUT tit_acr.cod_espec_docto).

    RUN piLine IN h-handle (INPUT 3,
                            INPUT tit_acr.cod_ser_docto).

    RUN piLine IN h-handle (INPUT 4,
                            INPUT tit_acr.cod_tit_acr).

    RUN piLine IN h-handle (INPUT 5,
                            INPUT tit_acr.cod_parcela).

    RUN piLine IN h-handle (INPUT 6,
                            INPUT tit_acr.dat_emis_docto).

    RUN piLine IN h-handle (INPUT 7,
                            INPUT tit_acr.dat_vencto_tit_acr).

    RUN piLine IN h-handle (INPUT 8,
                            INPUT tit_acr.val_origin_tit_acr).

    RUN piLine IN h-handle (INPUT 9,
                            INPUT tit_acr.val_sdo_tit_acr).

    RUN piLine IN h-handle (INPUT 10,
                            INPUT tit_acr.cod_indic_econ).



        IF tit_acr.dat_vencto_tit_acr >= TODAY THEN DO:
            RUN piLine IN h-handle (INPUT 11,
                                    INPUT "A vencer").
            
             END.

         ELSE DO:
             RUN piLine IN h-handle (INPUT 11,
                                     INPUT "Vencido").
             
         END.
        
         RUN piLine IN h-handle (INPUT 12,
                                 INPUT (TODAY - tit_acr.dat_vencto_tit_acr)).
        


        IF AVAIL cobrador-cliente THEN DO:  

            
 
          
        
        


        RUN piLine IN h-handle (INPUT 13,
                                INPUT v-nom-cobrador).

        END.

        ELSE DO:
            RUN piLine IN h-handle (INPUT 13,
                                    INPUT "verificar").
            
        END.

        IF AVAIL representante THEN
            
        RUN piLine IN h-handle (INPUT 14,
                                INPUT v-nom-represe).

        ELSE 
            RUN piLine IN h-handle (INPUT 14,
                                    INPUT "").




        RUN piLine IN h-handle (INPUT 15,
                                INPUT tit_acr.cdn_cliente).

        RUN piLine IN h-handle (INPUT 16,
                                INPUT tit_acr.nom_abrev).



            RUN piLine IN h-handle (INPUT 17,
                                    INPUT v-uf).

            RUN piLine IN h-handle (INPUT 18,
                                    INPUT v-cnpj).

            RUN piLine IN h-handle (INPUT 19,
                        INPUT v-ramo).




END PROCEDURE.



PROCEDURE pi-cabecalho:

    RUN piColumn IN h-handle (INPUT 1,     //define a coluna
                              INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Estab', // label da coluna
                              INPUT 'x(3)', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 2,     //define a coluna
                              INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Especie', // label da coluna
                              INPUT 'x(3)', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 3,     //define a coluna
                              INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Serie', // label da coluna
                              INPUT 'x(3)', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)


    RUN piColumn IN h-handle (INPUT 4,     //define a coluna
                              INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Titulo', // label da coluna
                              INPUT 'x(10)', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)


    RUN piColumn IN h-handle (INPUT 5,     //define a coluna
                              INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Parcela', // label da coluna
                              INPUT 'x(4)', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 6,     //define a coluna
                              INPUT 'date',  //define o tipo de valor (char, date, decimal, int ou logical)
                              INPUT 'Dt.Emissao', // label da coluna
                              INPUT '99/99/9999', //formato suprtado pela coluna
                              INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 7,     //define a coluna
                          INPUT 'date',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Dt Vcto', // label da coluna
                          INPUT '99/99/9999', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 8,     //define a coluna
                          INPUT 'decimal',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Vlr Original', // label da coluna
                          INPUT '->>>,>>>,>>>,>>9.99', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 9,     //define a coluna
                          INPUT 'decimal',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Vlr Saldo', // label da coluna
                          INPUT '->>>,>>>,>>>,>>9.99', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 10,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Moeda', // label da coluna
                          INPUT 'x(10)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 11,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Situacao', // label da coluna
                          INPUT 'x(20)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 12,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Faixa Vcto', // label da coluna
                          INPUT 'x(30)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 13,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Cobrador', // label da coluna
                          INPUT 'x(50)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 14,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Vendedor', // label da coluna
                          INPUT 'x(50)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)


    RUN piColumn IN h-handle (INPUT 15,     //define a coluna
                          INPUT 'integer',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Cod.Cliente', // label da coluna
                          INPUT '->>>,>99', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

    RUN piColumn IN h-handle (INPUT 16,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'Nome', // label da coluna
                          INPUT 'x(50)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)


    RUN piColumn IN h-handle (INPUT 17,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'UF', // label da coluna
                          INPUT 'x(3)', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)


    RUN piColumn IN h-handle (INPUT 18,     //define a coluna
                          INPUT 'char',  //define o tipo de valor (char, date, decimal, int ou logical)
                          INPUT 'CNPJ', // label da coluna
                          INPUT '99.999.999/9999-99', //formato suprtado pela coluna
                          INPUT 30). //define tamanho)

END PROCEDURE.
