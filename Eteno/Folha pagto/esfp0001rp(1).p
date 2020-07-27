def temp-table tt_integr_ctbl_erro_cta no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contˇbil" column-label "Conta Contˇbil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_ind_utiliz_ctbl_finalid      as character format "X(19)" initial "Normal" label "Utilizaªío Finalid" column-label "Utilizaªío Finalid"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_ind_utiliz_ctbl_finalid      ascending
    .


def shared temp-table tt_integr_ctbl_valid_parametros no-undo
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem"
    .

def temp-table tt_erro_msg no-undo
    field ttv_num_msg_erro                 as integer format ">>>>>>9" label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia"
    field ttv_des_help_erro                as character format "x(200)"
    index tt_num_erro                     
          ttv_num_msg_erro                 ascending
    .

def temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid NegΩcio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanªamento" column-label "Valor Lanªamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "999999999" initial 0 label "Apropriacao Lanªto" column-label "Apropriacao Lanªto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaªío" column-label "Data Cotaªío"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaªío" column-label "Cotaªío"
    field ttv_ind_erro_valid               as character format "X(08)" initial "Nío"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as recid format ">>>>>>9" initial ?
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid                        
          ttv_rec_integr_aprop_lancto_ctbl ascending
    .

def temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Número" column-label "Número Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posiªío"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending
    .

def temp-table tt_integr_ctbl_valid_par        
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem"
    .

def temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequºncia Lanªto" column-label "Sequºncia Lanªto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contˇbil" column-label "Conta Contˇbil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid NegΩcio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "HistΩrico Padrío" column-label "HistΩrico Padrío"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "HistΩrico Contˇbil" column-label "HistΩrico Contˇbil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp≤cie Documento" column-label "Esp≤cie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "Número Documento" column-label "Número Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanªamento" column-label "Data Lanªto"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanªamento" column-label "Valor Lanªamento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequºncia CPartida" column-label "Sequºncia CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "Nío"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending
    .

def temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cenˇrio Contˇbil" column-label "Cenˇrio Contˇbil"
    field tta_log_lancto_conver            as logical format "Sim/Nío" initial no label "Lanªamento Conversío" column-label "Lanªto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/Nío" initial no label "Lanªamento Apuraªío" column-label "Lancto Apuraªío"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Contˇbil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanªamento Contˇbil" column-label "Lanªamento Contˇbil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "Nío"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanªamento" column-label "Data Lanªto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending
    .

def temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "MΩdulo" column-label "MΩdulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Contˇbil" column-label "Lote Contˇbil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descriªío Lote" column-label "Descriªío Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Contˇbil" column-label "Data Lote Contˇbil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "Nío"
    field tta_log_integr_ctbl_online       as logical format "Sim/Nío" initial no label "Integraªío Online" column-label "Integr Online"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    index tt_recid                        
          ttv_rec_integr_lote_ctbl         ascending
    .

def temp-table tt_item_lancto_ctbl_xml        
    field ttv_num_count                    as integer format ">>>>,>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequºncia Lanªto" column-label "Sequºncia Lanªto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_cta_ctbl_db              as character format "x(20)" label "Conta Contˇbil DB" column-label "Conta Contˇbil DB"
    field tta_cod_cta_ctbl_cr              as character format "x(20)" label "Conta Contˇbil CR" column-label "Conta Contˇbil CR"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_histor_padr              as character format "x(8)" label "HistΩrico Padrío" column-label "HistΩrico Padrío"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "HistΩrico Contˇbil" column-label "HistΩrico Contˇbil"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanªamento" column-label "Data Lanªto"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanªamento" column-label "Valor Lanªamento"
    field tta_cod_ccusto_db                as Character format "x(11)" label "Centro Custo DB" column-label "Centro Custo DB"
    field tta_cod_ccusto_cr                as Character format "x(11)" label "Centro Custo CR" column-label "Centro Custo CR"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary
          ttv_num_count                    ascending
    .

def temp-table tt_params_generic_api        
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(35)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending
    .

def temp-table tt_retorna_lote_ctbl        
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Contˇbil" column-label "Lote Contˇbil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "Nío"
    field ttv_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    index tt_recid                         is primary
          tta_num_lote_ctbl                ascending
    .

DEF TEMP-TABLE tt-folha-sage
    FIELD ttv-filial          AS char
    FIELD ttv-data            AS CHAR
    FIELD ttv-cta-db          AS char
    FIELD ttv-cta-cr          AS char
    FIELD ttv-vlr-int         AS char
    FIELD ttv-vlr-dec         AS char
    FIELD ttv-historico       AS char
    FIELD ttv-ccusto          AS char
    FIELD ttv-historico1      AS CHAR.

DEF TEMP-TABLE tt-lanctos
    FIELD ttv-estab          AS CHAR
    FIELD ttv-data           AS date
    FIELD ttv-cta            AS CHAR
    FIELD ttv-natureza       AS CHAR
    FIELD ttv-vlr            AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv-historico      AS CHAR
    FIELD ttv-ccusto         AS CHAR
    FIELD ttv-plano-ct       AS char
    FIELD ttv-plano-cc       AS char
    .



define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD dir-arquivo      AS CHAR.


DEFINE TEMP-TABLE tt_log_erros
    FIELD ttv-cta    AS char
    FIELD ttv-cc     AS char
    FIELD ttv-estab  AS CHAR.


def var v_des_ajuda
    as character
    format "x(50)":U.

def var v_des_mensagem
    as character
    format "x(50)":U.

def new global shared var v_des_msg_erro_aux
    as character
    format "x(200)":U
    no-undo.


def temp-table tt-raw-digita                 
        field raw-digita    as raw.          
/* recebimento de par?metros */              
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita. 
create tt-param.                             
RAW-TRANSFER raw-param to tt-param.

define variable v_hdl_api as handle      no-undo.

DEFINE VARIABLE c-dia AS CHAR NO-UNDO.
DEFINE VARIABLE c-mes AS char NO-UNDO.
DEFINE VARIABLE c-ano AS char NO-UNDO.
DEFINE VARIABLE v-erro AS LOGICAL NO-UNDO.
DEFINE VARIABLE C-PL-CCUSTO AS CHAR NO-UNDO.
DEFINE VARIABLE C-CCUSTO AS CHAR NO-UNDO.
define variable vMsgHelp as char format "x(2000)" no-undo.

def new shared stream s_1. /*USADO QUANDO EMITE RELAT‡RIO ê IHUAL A SIM*/
/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUN∞ÄO *******************************
** Funªío para tratamento dos Entries dos cΩdigos livres
** 
**  p_num_posicao     - Número do Entry que serˇ atualizado
**  p_cod_campo       - Campo / Variˇvel que serˇ atualizada
**  p_cod_separador   - Separador que serˇ utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.



def var c-versao-prg as char initial " 1.00.00.056":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.056[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}

{include/i-prgvrs.i cea3024RP 2.04.00.000}

{utp/ut-glob.i}
/* include padrío para variˇveis de relatΩrio  */
{include/i-rpvar.i} 

/* include padr∆o para output de relat¢rios */
{include/i-rpout.i &STREAM="stream str-rp"}

    find first mguni.empresa no-lock
        where empresa.ep-codigo = i-ep-codigo-usuario no-error.

    assign c-programa 	  = "ESFP0001"
           c-versao	      = "2.04.00.000"
           c-empresa      = empresa.razao-social
           c-revisao      = "1"
           c-titulo-relat = "FOLHA DE PAGAMENTO SAGE".

    form header
         fill("-", 132) format "x(132)" skip
         c-empresa format "x(40)" c-titulo-relat at 50 format "x(35)"
         "Folha:" at 122 page-number(str-rp) at 128 format ">>>>9" skip
         fill("-", 112) format "x(110)" today format "99/99/9999"
         "-" string(time, "HH:MM:SS") skip(1)
         with stream-io width 132 no-labels no-box page-top frame f-cabec.

    c-rodape = "ETENO - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao.
    c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

    form header
         c-rodape format "x(132)"
         with stream-io width 132 no-labels no-box page-bottom frame f-rodape.


    view stream str-rp frame f-cabec.
    view stream str-rp frame f-rodape.


FIND FIRST tt-param NO-ERROR.

INPUT FROM VALUE (tt-param.dir-arquivo).

REPEAT:
    CREATE tt-folha-sage.
    IMPORT DELIMITER "|" tt-folha-sage.
END.

RUN pi-valida-folha (OUTPUT v-erro).

    IF v-erro THEN DO:
        
        FOR EACH tt_log_erros:

            disp stream str-rp tt_log_erros.ttv-cta column-label "Contas" format "x(10)"
                                tt_log_erros.ttv-cc  column-label "CCusto" format "x(10)"
                                tt_log_erros.ttv-estab column-label "Estab" format "x(5)"
                                "Nao encontrei a conta na Matriz Traducao Cta Externa SAGE" column-label "Erro" format "x(80)"
                                
                                with stream-io width 600.
        END.
    {include/i-rpclo.i &STREAM="stream str-rp"}

        RETURN 'nok':U.
    
    END.


    FIND FIRST tt-folha-sage NO-ERROR.
    
    ASSIGN c-dia = SUBSTRING(tt-folha-sage.ttv-data, 1, 2)
           c-mes = SUBSTRING(tt-folha-sage.ttv-data, 3, 2)
           c-ano = "20" + SUBSTRING(tt-folha-sage.ttv-data, 5, 2).
    
    
    FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-db)) <> "0":
        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-db))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.

        FIND FIRST criter_distrib_cta_ctbl NO-LOCK WHERE criter_distrib_cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl
                                                   AND   criter_distrib_cta_ctbl.cod_estab    = trad_cta_ctbl_ext.cod_estab
                                                   AND   criter_distrib_cta_ctbl.dat_fim_valid > TODAY NO-ERROR.
        IF NOT AVAIL criter_distrib_cta_ctbl THEN
            ASSIGN C-PL-CCUSTO   = ""
                   C-CCUSTO      = "".

        ELSE DO:
        FIND FIRST criter_distrib_cta_ctbl NO-LOCK WHERE criter_distrib_cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl
                                                   AND   criter_distrib_cta_ctbl.cod_estab    = trad_cta_ctbl_ext.cod_estab
                                                   AND   criter_distrib_cta_ctbl.dat_fim_valid > TODAY
                                                   AND   criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" NO-ERROR.

        IF  AVAIL criter_distrib_cta_ctbl THEN
            ASSIGN C-PL-CCUSTO   = ""
                   C-CCUSTO      = "".

        ELSE 
            ASSIGN C-PL-CCUSTO  = trad_cta_ctbl_ext.cod_plano_ccusto
                   C-CCUSTO     = trad_cta_ctbl_ext.cod_ccusto.    
        END.
        CREATE tt-lanctos.
        ASSIGN tt-lanctos.ttv-estab = trad_cta_ctbl_ext.cod_estab
               tt-lanctos.ttv-data  = DATE(INT(c-mes), INT(c-dia), INT(c-ano))
               tt-lanctos.ttv-cta   = trad_cta_ctbl_ext.cod_cta_ctbl
               tt-lanctos.ttv-natureza = "DB"
               tt-lanctos.ttv-vlr      = dec(replace(tt-folha-sage.ttv-vlr-int, ".", ",") + replace(tt-folha-sage.ttv-vlr-dec, ".", ","))
               tt-lanctos.ttv-historico = tt-folha-sage.ttv-historico
               tt-lanctos.ttv-ccusto    = c-ccusto
               tt-lanctos.ttv-plano-ct  = trad_cta_ctbl_ext.cod_plano_cta_ctbl.
               tt-lanctos.ttv-plano-cc  = C-PL-CCUSTO.
    
    END.

    FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-cr)) <> "0":
        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-CR))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.

        FIND FIRST criter_distrib_cta_ctbl NO-LOCK WHERE criter_distrib_cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl
                                                   AND   criter_distrib_cta_ctbl.cod_estab    = trad_cta_ctbl_ext.cod_estab
                                                   AND   criter_distrib_cta_ctbl.dat_fim_valid > TODAY NO-ERROR.
        IF NOT AVAIL criter_distrib_cta_ctbl THEN
            ASSIGN C-PL-CCUSTO   = ""  
                   C-CCUSTO      = "".

        ELSE DO:
 
        FIND FIRST criter_distrib_cta_ctbl NO-LOCK WHERE criter_distrib_cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl
                                                   AND   criter_distrib_cta_ctbl.cod_estab    = trad_cta_ctbl_ext.cod_estab
                                                   AND   criter_distrib_cta_ctbl.dat_fim_valid > TODAY
                                                   AND   criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "N∆o Utiliza" NO-ERROR.

        IF AVAIL criter_distrib_cta_ctbl THEN
            ASSIGN C-PL-CCUSTO   = ""
                   c-ccusto      = "".

        ELSE 
            ASSIGN C-PL-CCUSTO  = trad_cta_ctbl_ext.cod_plano_ccusto
                   C-CCUSTO     = trad_cta_ctbl_ext.cod_ccusto.    

        END.


        CREATE tt-lanctos.
        ASSIGN tt-lanctos.ttv-estab = trad_cta_ctbl_ext.cod_estab
               tt-lanctos.ttv-data  = DATE(INT(c-mes), INT(c-dia), INT(c-ano))
               tt-lanctos.ttv-cta   = trad_cta_ctbl_ext.cod_cta_ctbl
               tt-lanctos.ttv-natureza = "CR"
              tt-lanctos.ttv-vlr      = dec(replace(tt-folha-sage.ttv-vlr-int, ".", ",") + replace(tt-folha-sage.ttv-vlr-dec, ".", ","))
               tt-lanctos.ttv-historico = tt-folha-sage.ttv-historico
               tt-lanctos.ttv-ccusto    = c-ccusto
               tt-lanctos.ttv-plano-ct  = trad_cta_ctbl_ext.cod_plano_cta_ctbl.
               tt-lanctos.ttv-plano-cc  = C-PL-CCUSTO.
    
    
    END.

    EMPTY TEMP-TABLE tt-folha-sage.
    EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.       
    empty temp-table tt_integr_lancto_ctbl_1.     
    empty temp-table tt_integr_item_lancto_ctbl_1.
    empty temp-table tt_integr_aprop_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
    
    RUN pi-cria-lotes.
    run pi-contabiliza.


PROCEDURE pi-valida-folha:

DEFINE OUTPUT param p-erros AS LOGICAL INITIAL NO NO-UNDO.


    FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-db)) <> '0':

        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-db))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.
        IF NOT AVAIL trad_cta_ctbl_ext THEN DO:
            
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.ttv-cta = string(int(tt-folha-sage.ttv-cta-db))
                   tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                   tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial)).

        END.

    END.

    FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-cr)) <> '0':

        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-cr))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.
        IF NOT AVAIL trad_cta_ctbl_ext THEN DO:
            
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.ttv-cta = string(int(tt-folha-sage.ttv-cta-cr))
                   tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                   tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial)).

        END.

    END.


    FIND FIRST tt_log_erros NO-ERROR.

    IF AVAIL tt_log_erros THEN DO:
        
        ASSIGN p-erros = YES.
    END.

END PROCEDURE.



PROCEDURE pi-cria-lotes:
    DEFINE VAR i-lancto AS INTEGER NO-UNDO.

    ASSIGN i-lancto = 10.

CREATE tt_integr_lote_ctbl_1.
ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul           = "FGL" 
       tt_integr_lote_ctbl_1.tta_num_lote_ctbl             =  0
       tt_integr_lote_ctbl_1.tta_des_lote_ctbl             = "Folha Pagto SAGE" 
       tt_integr_lote_ctbl_1.tta_cod_empresa               = "1" 
       tt_integr_lote_ctbl_1.tta_dat_lote_ctbl             = TODAY 
       tt_integr_lote_ctbl_1.tta_log_integr_ctbl_online    = YES 
       tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl      = recid(tt_integr_lote_ctbl_1). 



FIND FIRST tt_integr_lote_ctbl_1 NO-ERROR.

    CREATE tt_integr_lancto_ctbl_1.
    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl              = ""
           tt_integr_lancto_ctbl_1.tta_log_lancto_conver           = NO
           tt_integr_lancto_ctbl_1.tta_log_lancto_apurac_restdo    = NO
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl        = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl             = 1
           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl             = date(INT(c-mes), INT(c-dia), INT(c-ano)) 
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = recid(tt_integr_lancto_ctbl_1).

    
    FOR EACH tt-lanctos:

        FIND FIRST tt_integr_lancto_ctbl_1 NO-ERROR.

        CREATE tt_integr_item_lancto_ctbl_1.
        ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl       =  tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
               tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl          =  i-lancto
               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl        =  tt-lanctos.ttv-natureza
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl           =  tt-lanctos.ttv-plano-ct
               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                 =  tt-lanctos.ttv-cta
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto             =  tt-lanctos.ttv-plano-cc
               tt_integr_item_lancto_ctbl_1.tta_cod_estab                    =  tt-lanctos.ttv-estab
               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc               =  "ETE"
               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl       =  tt-lanctos.ttv-historico
               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ               =  "Real"
               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl              =  tt-lanctos.ttv-data
               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl              =  tt-lanctos.ttv-vlr
               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                   =  tt-lanctos.ttv-ccusto
               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  =  recid(tt_integr_item_lancto_ctbl_1).

        ASSIGN i-lancto = i-lancto + 10.

        CREATE tt_integr_aprop_lancto_ctbl_1.
        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ                  = "corrente"
               tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc                    = "Ete"
               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto                  = tt-lanctos.ttv-ccusto
               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl                   = tt-lanctos.ttv-vlr
               tt_integr_aprop_lancto_ctbl_1.tta_num_id_aprop_lancto_ctbl          = 0
               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl       = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                        = tt-lanctos.ttv-plano-cc
               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl      = RECID(tt_integr_aprop_lancto_ctbl_1).

    END.


END PROCEDURE.


PROCEDURE pi-contabiliza:

/* for each tt_integr_item_lancto_ctbl_1: */
/*    */
/* PUT stream str-rp UNFORMATTED */
/*      tta_ind_natur_lancto_ctbl          ";" */
/*      tta_cod_plano_cta_ctbl             ";" */
/*      tta_cod_cta_ctbl                   ";" */
/*      tta_cod_plano_ccusto               ";" */
/*      TTA_COD_CCUSTO                     ";" */
/*      tta_cod_estab                      ";" */
/*      tta_cod_unid_negoc                 ";" */
/*      tta_cod_histor_padr                ";" */
/*      tta_des_histor_lancto_ctbl         ";" */
/*      tta_cod_espec_docto                ";" */
/*      tta_dat_LANCTO                      ";" */
/*      tta_des_docto                      ";" */
/*      tta_cod_indic_econ                 ";" */
/*      tta_qtd_unid_lancto_ctbl           ";" */
/*      tta_val_lancto_ctbl                ";" */
/*      SKIP. */
/*    */
/*      END. */
/*    */
/*    */
                        run prgfin/fgl/fgl900zl.py (Input 3,
                                                Input "Aborta Lotes Errados" /*l_aborta_lotes_errados*/,
                                                Input no,
                                                INPUT 66,
                                                Input "Apropriaá∆o",
                                                Input "Com erro",
                                                Input yes,
                                                Input no,
                                                input-output table tt_integr_lote_ctbl_1,
                                                input-output table tt_integr_lancto_ctbl_1,
                                                input-output table tt_integr_item_lancto_ctbl_1,
                                                input-output table tt_integr_aprop_lancto_ctbl_1,
                                                input-output table tt_integr_ctbl_valid_1) /*prg_API_LOTE_CTBL_RECEBTO_1*/.
  
                        RUN pi-imprime.
  
END PROCEDURE.


PROCEDURE pi-imprime:

    FOR EACH tt_integr_ctbl_valid_1:

            run pi_msg_lote_ctbl_recebto_aux_1 (Input tt_integr_ctbl_valid_1.ttv_num_mensagem,
                                                output v_des_mensagem,
                                                output v_des_ajuda) /* pi_msg_lote_ctbl_recebto_1*/.

    
                          
 
        DISP STREAM str-rp

            v_des_mensagem  COLUMN-LABEL "Cod.MSG" FORMAT "999999"  
            v_des_ajuda  COLUMN-LABEL "Erro" FORMAT "x(300)"
            WITH STREAM-IO WIDTH 500.


    END.
{include/i-rpclo.i &STREAM="stream str-rp"}


END PROCEDURE.


PROCEDURE pi_messages: 

    def input param c_action    as char    no-undo. 
    def input param i_msg       as integer no-undo. 
    def input param c_param     as char    no-undo. 

    def var c_prg_msg           as char    no-undo. 

    assign c_prg_msg = "messages/" 
                     + string(trunc(i_msg / 1000,0),"99") 
                     + "/msg" 
                     + string(i_msg, "99999"). 

    if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then do: 
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-mensagem-nr AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Mensagem_nr" *}
        ASSIGN c-lbl-liter-mensagem-nr = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-programa-mensagem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Programa_Mensagem" *}
        ASSIGN c-lbl-liter-programa-mensagem = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nao-encontrado AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "nío_encontrado" *}
        ASSIGN c-lbl-liter-nao-encontrado = TRIM(RETURN-VALUE).
        message c-lbl-liter-mensagem-nr + ". " i_msg "!!!" skip 
                c-lbl-liter-programa-mensagem c_prg_msg c-lbl-liter-nao-encontrado + "." 
                view-as alert-box error. 
        return error. 
    end. 

    run value(c_prg_msg + ".p") (input c_action, input c_param). 
    return return-value. 
END PROCEDURE.  /* pi_messages */ 


/*****************************************************************************
** Procedure Interna.....: pi_msg_lote_ctbl_recebto_aux_1
** Descricao.............: pi_msg_lote_ctbl_recebto_aux_1
** Criado por............: fut41675
** Criado em.............: 10/06/2009 15:48:23
** Alterado por..........: log348825
** Alterado em...........: 21/05/2010 15:36:11
*****************************************************************************/
PROCEDURE pi_msg_lote_ctbl_recebto_aux_1:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.
    def output param p_des_ajuda
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_integr_item_lancto_ctbl_1
        for tt_integr_item_lancto_ctbl_1.


    /*************************** Buffer Definition End **************************/
    /************************* Parameter Definition End *************************/


    /************************* Variable Definition Begin ************************/

    def var v_des_msg_aux_2
        as character
        format "x(256)":U
        no-undo.
    def var v_nom_seq
        as character
        format "x(29)":U
        no-undo.
    def var v_num_aux
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_current
        as integer
        format "999999999":U
        no-undo.
    def var v_num_seq_max
        as integer
        format "999999999":U
        no-undo.


    /* msg_block: */
      case p_num_mensagem:
        when 14800 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '14800' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = substitute(getStrTrans("Ocorreu o erro &1 no processo executado !", "FGL"), GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"))
                       p_des_ajuda    = substitute(getStrTrans("DEVIDO A UM ERRO INTERNO, A CONTABILIZAÄ«O/DESCONTABILIZAÄ«O N«O SERµ COMPLETADA." + chr(10) +
    "" + chr(10) +
    "Detalhes que envolvem o erro interno:" + chr(10) +
    "&2" + chr(10) +
    "" + chr(10) +
    "Erro Interno: &1" + chr(10) +
    "Detalhes do Erro: &3", "FGL") /*14800*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(3, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
        end.
        when 18368 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '18368' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = substitute(getStrTrans("Diferenáa entre dÇbito &1 e crÇdito &2 na item.", "FGL") /*18368*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"))
                       p_des_ajuda    = substitute(getStrTrans("Erro no envio dos dados para a contabilidade.", "FGL") /*18368*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
        end.
            when 18369 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '18369' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = substitute(getStrTrans("Diferenáa entre DB &1 e CR &2 na apropriaá∆o, finalidade &3.", "FGL") /*18369*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(3, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"))
                       p_des_ajuda    = substitute(getStrTrans("Erro no envio dos dados para a contabilidade.", "FGL") /*18369*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(3, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
        end.
        when 13113 then do:
          ASSIGN v_nom_seq = 'seq_aprop_lancto_ctbl':U
                 v_num_current = 0.
          RUN pi_retornar_seq_maxima(INPUT v_nom_seq, OUTPUT v_num_seq_max).
          &if '{&emsfin_dbtype}' = 'progress' &then
              assign v_num_current = CURRENT-VALUE(seq_aprop_lancto_ctbl).
          &else
              /* no oracle n∆o existe a funá∆o current-value */
              find last aprop_lancto_ctbl
                   USE-INDEX aprplnca_token
                   NO-LOCK NO-ERROR .
              if avail aprop_lancto_ctbl then
                 assign v_num_current= aprop_lancto_ctbl.num_id_aprop_lancto_ctbl.
          &endif  
          assign p_des_mensagem = getStrTrans("Seq apropriaá∆o lanc  cont†bil atingiu  limite de seguranáa !", "FGL") /*13113*/
                 p_des_ajuda    = substitute(getStrTrans("O controle de sequància da apropriaá∆o lanáamento cont†bil atingiu o limite de seguranáa." + chr(10) +
    "Valor Definido: &1" + chr(10) +
    "Valor Usado   : &2" + chr(10) +
    "" + chr(10) +
    "Abrir uma FO informando a ocorrància desta mensagem. ", "FGL") /*13113*/,v_num_seq_max,v_num_current).
        end.
        when 1043 then
            assign p_des_mensagem = getStrTrans("Vers‰es incompat°veis para Integraá∆o Cont†bil !", "FGL") /*1043*/
                   p_des_ajuda    = getStrTrans("O gerador dos fatos cont†beis est† com vers∆o diferente do recebimento de lotes cont†beis. Solicite a distribuiá∆o do produto a atualizaá∆o das vers‰es.", "FGL") /*1043*/.
        when 810 then
            assign p_des_mensagem = getStrTrans("Cen†rio informado diferente do cen†rio da conta cont†bil !", "FGL") /*810*/
                   p_des_ajuda    = getStrTrans("O Cen†rio Cont†bil informado para o lanáamento Ç diferente do Cen†rio Cont†bil informado para a Conta Cont†bil.", "FGL") /*810*/.
        when 1095 then
            assign p_des_mensagem = getStrTrans("ParÉmetros de Contabilizaá∆o do M¢dulo n∆o encontrados !", "FGL") /*1095*/
                   p_des_ajuda    = getStrTrans("Verifique nos ParÉmetros de Contabilizaá∆o se o M¢dulo est† relacionado Ö Empresa do Usu†rio.", "FGL") /*1095*/.
        when 1101 then
            assign p_des_mensagem = getStrTrans("Unidade Organizacional do Lote Cont†bil n∆o Ç Empresa !", "FGL") /*1101*/
                   p_des_ajuda    = getStrTrans("O Lote Cont†bil deve ser cadastrado para uma Unidade Organizacional do N°vel Hier†rquico 998 (Empresa).", "FGL") /*1101*/.
        when 1108 then
            assign p_des_mensagem = getStrTrans("Lanáamento Cont†bil Inv†lido para o M¢dulo !", "FGL") /*1108*/
                   p_des_ajuda    = getStrTrans("Lanáamentos Cont†beis de Rateio Cont†bil podem ser gerados somente pelo M¢dulo de Contabilidade.", "FGL") /*1108*/.
        when 1105 then
            assign p_des_mensagem = getStrTrans("Rateio Cont†bil inv†lido para o Cen†rio Cont†bil !", "FGL") /*1105*/
                   p_des_ajuda    = getStrTrans("O Rateio Cont†bil informado n∆o est† relacionado ao Cen†rio Cont†bil informado.", "FGL") /*1105*/.
        when 1102 then
            assign p_des_mensagem = getStrTrans("Cen†rio Cont†bil n∆o encontrado para Unidade Organizacional !", "FGL") /*1102*/
                   p_des_ajuda    = getStrTrans("Verifique na Manutená∆o de Cen†rios Cont†beis se o Cen†rio Cont†bil informado est† relacionado Ö Unidade Organizacional e ao M¢dulo.", "FGL") /*1102*/.
        when 1106 then
            assign p_des_mensagem = getStrTrans("Lanáamento Cont†bil Inv†lido para o M¢dulo !", "FGL") /*1106*/
                   p_des_ajuda    = getStrTrans("Lanáamentos Cont†beis de Convers∆o podem ser gerados somente pelo M¢dulo de Contabilidade.", "FGL") /*1106*/.
        when 1107 then
            assign p_des_mensagem = getStrTrans("Lanáamento Cont†bil Inv†lido para o M¢dulo !", "FGL") /*1107*/
                   p_des_ajuda    = getStrTrans("Lanáamentos Cont†beis de Apuraá∆o de Resultados podem ser gerados somente pelo M¢dulo de Contabilidade.", "FGL") /*1107*/.
        when 1122 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = getStrTrans("Plano Contas Cont†beis inv†lido para Unidade Organizacional !", "FGL") /*1122*/
                       p_des_ajuda    = substitute(getStrTrans("Verifique na Manutená∆o de Planos de Contas Cont†beis se o Plano de Contas &1 informado est† cadastrado para esta Unidade Organizacional, e se o mesmo est† dentro da validade. ", "FGL") /*1122*/,tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl).
        end.
        when 1127 then
            assign p_des_mensagem = getStrTrans("Plano de Contas Cont†beis Inv†lido para Lanáamento Cont†bil !", "FGL") /*1127*/
                   p_des_ajuda    = getStrTrans("Lanáamentos Cont†beis podem ser efetuados exclusivamente em Planos de Contas Prim†rios.", "FGL") /*1127*/.
        when 1131 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Inv†lida para Plano de Contas ou Data Atual !", "FGL") /*1131*/
                   p_des_ajuda    = getStrTrans("Verifique se a Conta Cont†bil est† cadastrada no Plano de Contas Cont†beis informado, e se ambos est∆o v†lidos na data atual.", "FGL") /*1131*/.
        when 19212 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Ajuste Decimais inv†lida !", "FGL") /*19212*/
                   p_des_ajuda    = getStrTrans("Esta conta utilizada para Ajuste Decimais, n∆o Ç uma conta v†lida relacionada ao plano de contas. Acesse a Manutená∆o de Planos de Contas e no bot∆o Modifica informe uma conta de Ajuste Decimal v†lida.    ", "FGL") /*19212*/.
        when 19158 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Ajuste Decimais inv†lida !", "FGL") /*19158*/
                   p_des_ajuda    = getStrTrans("Dever† ser informada uma conta relacionada ao plano que seja Anal°tica Exclusiva. Acesse a Manutená∆o de Planos de Contas e no bot∆o Modifica informe uma conta de Ajuste Decimal v†lida.  ", "FGL") /*19158*/.
        when 19159 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Ajuste Decimais inv†lida !", "FGL") /*19159*/
                   p_des_ajuda    = getStrTrans("Conta Ajuste Decimais n∆o poder† usar critÇrio de distribuiá∆o por centro de custo. Acesse a Manutená∆o de Planos de Contas e no bot∆o Modifica informe uma conta de Ajuste Decimal v†lida.", "FGL") /*19159*/.
        when 435 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Inexistente !", "FGL") /*435*/
                   p_des_ajuda    = getStrTrans("Consulte o cadastro de Contas Cont†beis e informe uma Conta Cont†bil v†lida.", "FGL") /*435*/.
        when 1129 then
            assign p_des_mensagem = getStrTrans("Conta Cont†bil Inv†lida para Lanáamento Cont†bil !", "FGL") /*1129*/
                   p_des_ajuda    = getStrTrans("Lanáamentos Cont†beis podem ser efetuados exclusivamente em Contas Cont†beis Anal°ticas. Contas Cont†beis SintÇticas n∆o podem receber Lanáamentos Cont†beis.", "FGL") /*1129*/.
        when 1130 then
            assign p_des_mensagem = getStrTrans("Cen†rio Cont†bil do Lanáamento Inv†lido para Conta Cont†bil !", "FGL") /*1130*/
                   p_des_ajuda    = getStrTrans("A Conta Cont†bil informada n∆o pode receber Lanáamentos Cont†beis de Cen†rio Cont†bil informado. Verifique na Manutená∆o de Contas Cont†beis os Cen†rios Cont†beis v†lidos para a Conta informada.", "FGL") /*1130*/.
        when 1132 then
            assign p_des_mensagem = getStrTrans("Estabelecimento Inv†lido para Empresa do Usu†rio !", "FGL") /*1132*/
                   p_des_ajuda    = getStrTrans("Verifique na Manutená∆o de Estabelecimentos se o Estabelecimento informado est† cadastrado para a Empresa do Usu†rio.", "FGL") /*1132*/.
        when 347 then
            assign p_des_mensagem = getStrTrans("Estabelecimento n∆o habilitado como Unidade Organizacional !", "FGL") /*347*/
                   p_des_ajuda    = getStrTrans("O estabelecimento n∆o est† habilitado na estrutura de unidade organizacional na data da transaá∆o. Vocà deve cadastrar uma Unidade Organizacional com o mesmo c¢digo do Estabelecimento, dando permiss∆o de acesso ao grupo a que vocà pertence.", "FGL") /*347*/.
        when 1134 then
            assign p_des_mensagem = getStrTrans("Unidade de Neg¢cio inv†lida para Estabelecimento informado !", "FGL") /*1134*/
                   p_des_ajuda    = getStrTrans("Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o das Unidades de Neg¢cio do Estabelecimento, se a Unidade de Neg¢cio informada est† relacionada ao Estabelecimento.", "FGL") /*1134*/.
        when 617 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 fora de validade !", "FGL") /*617*/,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc)
                       p_des_ajuda    = getStrTrans("A Unidade de Neg¢cio informada para o Estabelecimento est† fora de validade.", "FGL") /*617*/.
        end.
        when 683 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = substitute(getStrTrans("Usu†rio sem permiss∆o para acessar a Unidade de Neg¢cio &1 !", "FGL") /*683*/,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc)
                       p_des_ajuda    = getStrTrans("Verifique, na Manutená∆o de Unidades de Neg¢cio, se o Grupo de Seguranáa no qual o seu usu†rio est† cadastrado est† incluso nos Grupos de Seguranáa da Unidade de Neg¢cio informada.", "FGL") /*683*/.
        end.

        /* Begin_Include: i_msg_lote_ctbl_recebto_ajuste */
        when 1135 then
                assign p_des_mensagem = getStrTrans("Unidade de Neg¢cio n∆o encontrada !", "FGL") /*1135*/
                       p_des_ajuda    = getStrTrans("Verifique, na Manutená∆o de Unidades de Neg¢cio, se a Unidade de Neg¢cio informada est† cadastrada.", "FGL") /*1135*/.
            when 335 then
                assign p_des_mensagem = getStrTrans("Indicador Econìmico Inexistente !", "FGL") /*335*/
                       p_des_ajuda    = getStrTrans("Indicador econìmico n∆o existe, ou a data da transaá∆o est† fora do per°odo de validade do indicador econìmico.", "FGL") /*335*/.
            when 336 then do: 
                find first btt_integr_item_lancto_ctbl_1
                    where btt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                if avail btt_integr_item_lancto_ctbl_1 then 
                assign p_des_mensagem = getStrTrans("Hist¢rico Finalidade inexistente para o indicador economico !", "FGL") /*336*/
                       p_des_ajuda    = substitute(getStrTrans("N∆o existe hist¢rico da finalidade v†lido para o indicador econìmico &1 e data da transaá∆o &2.", "FGL") /*336*/, btt_integr_item_lancto_ctbl_1.tta_cod_indic_econ, btt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl).
            end.
            when 337 then
                assign p_des_mensagem = getStrTrans("Finalidade econìmica n∆o permite informar valores !", "FGL") /*337*/
                       p_des_ajuda    = getStrTrans("A finalidade econìmica associada ao indicador econìmico informado, n∆o permite informar valores. Verifique o atributo informa-valor na finalidade econìmica.", "FGL") /*337*/.
            when 549 then
                assign p_des_mensagem = getStrTrans("Hist¢rico Padr∆o Inexistente !", "FGL") /*549*/
                       p_des_ajuda    = getStrTrans("Hist¢rico Padr∆o n∆o est† cadastrado na tabela Hist¢rico Padr∆o." + chr(10) +
        "Para cadastrar execute o procedimento Hist¢rico Padr∆o.", "FGL") /*549*/.
            when 589 then
                assign p_des_mensagem = getStrTrans("EspÇcie de Documento Inexistente !", "FGL") /*589*/
                       p_des_ajuda    = getStrTrans("A espÇcie de documento informada n∆o foi encontrada. Verifique a tabela de espÇcies de documento, ou informe uma espÇcie v†lida.", "FGL") /*589*/.
            when 1141 then
                assign p_des_mensagem = getStrTrans("Imagem Inexistente !", "FGL") /*1141*/
                       p_des_ajuda    = getStrTrans("Verifique, na Manutená∆o de Imagens, se a Imagem informada est† cadastrada.", "FGL") /*1141*/.
            when 852 then
                assign p_des_mensagem = getStrTrans("Plano de Centros de Custo Inv†lido !", "FGL") /*852*/
                       p_des_ajuda    = getStrTrans("Verifique, na Manutená∆o de Planos de Centros de Custo, se o Plano de Centros de Custo informado est† cadastrado e se est† dentro da data de validade.", "FGL") /*852*/.
            when 8075 then do: 
                find first tt_integr_item_lancto_ctbl_1
                    where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                if avail tt_integr_item_lancto_ctbl_1 then 
                    assign p_des_mensagem = getStrTrans("Existe restriá∆o da conta para o grupo do usu†rio corrente !", "FGL") /*8075*/
                           p_des_ajuda    = substitute(getStrTrans("Verifique no procedimento de restriá‰es se o usu†rio tem permiss∆o de movimentar a conta &1.", "FGL") /*8075*/, tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl).
            end.
            when 1136 then
                assign p_des_mensagem = getStrTrans("Centro de Custo inv†lido para Plano CCusto ou Data Validade !", "FGL") /*1136*/
                       p_des_ajuda    = getStrTrans("Verifique, na Manutená∆o de Centros de Custo, se o Centro de Custo est† cadastrado no Plano de Centros de Custo informado e se o mesmo est† dentro da validade.", "FGL") /*1136*/.
            when 1137 then do: /* sarah*/
                find first btt_integr_item_lancto_ctbl_1
                    where btt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                if avail btt_integr_item_lancto_ctbl_1 then 
                    assign p_des_mensagem = substitute(getStrTrans("Distribuiá∆o Centro de Custo inv†lida para Conta Cont†bil &1 !", "FGL") /*1137*/, btt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl)
                           p_des_ajuda    = substitute(getStrTrans("Verifique, na Manutená∆o de CritÇrios de Distribuiá∆o de Contas Cont†beis, se a Conta Cont†bil &1 est† relacionada ao Mapa de Distribuiá∆o de Centros de Custo, no qual est† incluso o Centro de Custo informado. Certifique-se de que ambos est∆o dentro da data de validade.", "FGL") /*1137*/, btt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl).
            end.
            when 18376 then do:
                find first tt_integr_ctbl_valid_parametros
                     where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                     and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '18376' no-lock no-error.
                if avail tt_integr_ctbl_valid_parametros then
                    assign p_des_mensagem = substitute(getStrTrans("Saldo do Lanáamento Cont†bil Inv†lido.", "FGL") /*18376*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"))
                           p_des_ajuda    = substitute(getStrTrans("A soma dos DÇbitos &1 e CrÇditos &2 das Apropriaá‰es dos Itens deste Lanáamento Cont†bil n∆o s∆o iguais. Verifique no Programa de Lanáamentos Cont†beis se todos os valores foram informados corretamente.", "FGL") /*18376*/, GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
            end.               
        /* End_Include: i_msg_lote_ctbl_recebto_ajuste */

        when 1229 then
            assign p_des_mensagem = getStrTrans("Quantidade Inv†lida !", "FGL") /*1229*/
                   p_des_ajuda    = getStrTrans("A soma da quantidade das Apropriaá‰es do Lanáamento Ç diferente da quantidade do Item do Lanáamento. Verifique no Programa de Lanáamentos Cont†beis se as quantidades informadas est∆o corretas.", "FGL") /*1229*/.
        when 1395 then
            assign p_des_mensagem = getStrTrans("Unidade de Neg¢cio n∆o Encontrada para o Estabelecimento !", "FGL") /*1395*/
                   p_des_ajuda    = getStrTrans("Unidade de Neg¢cio n∆o habilitada para o Estabelecimento. Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o de Unidades de Neg¢cio do Estabeleciemnto, se a Unidade de Neg¢cio est† cadastrada para este Estabelecimento.", "FGL") /*1395*/.
        when 1253 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = substitute(getStrTrans("Centro Custo &1 Inv†lido para a Unidade Neg¢cio &2 !", "FGL") /*1253*/,tt_integr_item_lancto_ctbl_1.tta_cod_ccusto,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc)
                       p_des_ajuda    = getStrTrans("O centro de custo n∆o pode ser utilizado com a Unidade de Neg¢cio informada." + chr(10) +
    "Caso sua informaá∆o esteja correta, verifique as Unidades de Neg¢cio e Unidades de Neg¢cio do Centro de Custo, na Manutená∆o de  Centros de Custo." + chr(10) +
    "Verifique o centro de custo &1 e a Unidade de neg¢cio &2" + chr(10) +
    "", "FGL") /*1253*/.
        end. 
        when 1397 then
            assign p_des_mensagem = getStrTrans("Centro de Custo inv†lido para o Estabelecimento !", "FGL") /*1397*/
                   p_des_ajuda    = getStrTrans("Existe restriá∆o de utilizaá∆o deste Centro de Custo no Estabelecimento informado. Verificar na Manutená∆o de Centros de Custo as restriá‰es.", "FGL") /*1397*/.
        when 1648 then
            assign p_des_mensagem = getStrTrans("Conta cont†bil possui critÇrio de distribuiá∆o Autom†tica !", "FGL") /*1648*/
                   p_des_ajuda    = getStrTrans("Recebimento de lanáamentos n∆o podem ser efetuados em contas com critÇrio de distribuiá∆o centro de custo Autom†tica.", "FGL") /*1648*/.
        when 1624 then
            assign p_des_mensagem = getStrTrans("Situaá∆o de movimentaá∆o do m¢dulo n∆o est† Habilitada !", "FGL") /*1624*/
                   p_des_ajuda    = getStrTrans("Movimentos somente podem ser efetuados em per°odos cuja situaá∆o de movimentaá∆o para o m¢dulo esteja habilitada.", "FGL") /*1624*/.
        when 241 then
            assign p_des_mensagem = getStrTrans("Indicador Econìmico Inexistente !", "FGL") /*241*/
                   p_des_ajuda    = getStrTrans("Verifique se o indicador econìmico existe na tabela de indicadores econìmicos", "FGL") /*241*/.
        when 1199 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = substitute(getStrTrans("Indicador Econìmico n∆o habilitado na Data Transaá∆o &1 !", "FGL") /*1199*/,tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl)
                       p_des_ajuda    = getStrTrans("A Data de Transaá∆o est† fora da faixa de validade do Indicador Econìmico.", "FGL") /*1199*/.
        end.
        when 1036 then
            assign p_des_mensagem = getStrTrans("Comunique a Datasul sobre esta mensagem !", "FGL") /*1036*/
                   p_des_ajuda    = substitute(getStrTrans("Favor comunicar a Datasul o n£mero desta mensagem (&1) e o local em que ela apareceu.", "FGL") /*1036*/,"1036").
        when 1407 then
            assign p_des_mensagem = getStrTrans("Finalidade do Indicador informado n∆o informa valor !", "FGL") /*1407*/
                   p_des_ajuda    = getStrTrans("Informe para o lanáamento um indicador econìmico que esteja associado a uma finalidade econìmica que permita informar valores.", "FGL") /*1407*/.
        when 1664 then
            assign p_des_mensagem = getStrTrans("Unidade Neg¢cio n∆o encontrada para Estabelecimento !", "FGL") /*1664*/
                   p_des_ajuda    = getStrTrans("Unidade de Neg¢cio n∆o habilitada para o Estabelecimento. Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o de Unidades de Neg¢cio do Estabeleciemnto, se a Unidade de Neg¢cio est† cadastrada para o Estabelecimento.", "FGL") /*1664*/.
        when 348 then do:
            find first tt_integr_item_lancto_ctbl_1
                where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then    
                assign p_des_mensagem = getStrTrans("Usu†rio sem permiss∆o para acessar o estabelecimento &1 !", "FGL") /*348*/
                       p_des_ajuda    = getStrTrans("Verifique se vocà possui direito de acesso ao estabelecimento informado, atravÇs:" + chr(10) +
    "- Manutená∆o de Grupos de Usu†rios, o usu†rio dever† estar relacionado a algum grupo de usu†rios;" + chr(10) +
    "- Manutená∆o de Unidade Organizacional, o estabelecimento dever† estar relacionado a uma Unidade Organizacional. TambÇm dever† ser verificado se para a Unidade Organizacional est† relacionado o grupo de usu†rios em que se encontra o usu†rio.", "FGL") /*348*/.
        end.           
        when 1665 then
            assign p_des_mensagem = getStrTrans("Existe restriá∆o deste ccusto no estabelecimento !", "FGL") /*1665*/
                   p_des_ajuda    = getStrTrans("Existe restriá∆o de utilizaá∆o deste centro de custo, no estabelecimento. Verificar na Manutená∆o de Centros de Custo as restriá‰es.", "FGL") /*1665*/.
        when 1495 then
            assign p_des_mensagem = getStrTrans("Empresa n∆o utiliza o Cen†rio Cont†bil !", "FGL") /*1495*/
                   p_des_ajuda    = getStrTrans("O cen†rio cont†bil especificado n∆o est† na lista de utilizaá∆o da empresa.", "FGL") /*1495*/.
        when 1494 then
            assign p_des_mensagem = getStrTrans("Expirou Validade do Cen†rio para a Empresa !", "FGL") /*1494*/
                   p_des_ajuda    = getStrTrans("A data de validade na utilizaá∆o do cen†rio cont†bil pela empresa n∆o permite movimentaá∆o na data de referància.", "FGL") /*1494*/.
        when 2557 then
            assign p_des_mensagem = getStrTrans("Usu†rio sem permiss∆o para manipular o cen†rio cont†bil !", "FGL") /*2557*/
                   p_des_ajuda    = getStrTrans("Usu†rio n∆o pertence a nenhum dos grupos que tem permiss∆o para manipular o cen†rio cont†bil. Verifique no programa de Manutená∆o Seguranáa Cen†rio Cont†bil.", "FGL") /*2557*/.
        when 2568 then
            assign p_des_mensagem = getStrTrans("Usu†rio sem permiss∆o para manipular todos os cen†rios !", "FGL") /*2568*/
                   p_des_ajuda    = getStrTrans("Quando n∆o Ç informado o cen†rio cont†bil, entende-se que o usu†rio deseja manipular todos, portanto deve-se ter permiss∆o a todos os cen†rios cont†beis. Verifique na Manutená∆o Seguranáa Cen†rio Cont†bil, se o grupo de usu†rios a que vocà pertence, tem permiss∆o a todos os cen†rios desta empresa.", "FGL") /*2568*/.
        when 3865 then
            assign p_des_mensagem = getStrTrans("Foram verificadas apropriaá‰es negativas !", "FGL") /*3865*/
                   p_des_ajuda    = getStrTrans("Verifique o arquivo ou procedimento de importaá∆o se n∆o existem valores negativos a serem importados.", "FGL") /*3865*/.
        when 4386 then
            assign p_des_mensagem = getStrTrans("Hist¢rico n∆o esta preenchido !", "FGL") /*4386*/
                   p_des_ajuda    = getStrTrans("Informe o hist¢rico atravÇs do hist¢rico padr∆o o digite um hist¢rico para o lanáamento.", "FGL") /*4386*/.
        when 4618 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = getStrTrans("Existe restriá∆o da conta neste estabelecimento !", "FGL") /*4618*/
                       p_des_ajuda    = substitute(getStrTrans("Verifique no procedimento de restriá‰es se a conta &1 possui permiss∆o de movimentar &3 &2.", "FGL") /*4618*/,tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl,tt_integr_item_lancto_ctbl_1.tta_cod_estab,getStrTrans("Estabelecimento", "FGL") /*l_estabelecimento*/ ).
        end.
        when 4619 then do:
            find first tt_integr_item_lancto_ctbl_1
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1 then
                assign p_des_mensagem = substitute(getStrTrans("Existe restriá∆o da conta &1 na unidade de neg¢cio &2 !", "FGL") /*4619*/,tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc)
                       p_des_ajuda    = substitute(getStrTrans("Verifique no procedimento de restriá‰es da conta cont†bil se a conta &1 possui permiss∆o de movimentaá∆o nesta unidade de neg¢cio &2.", "FGL") /*4619*/,tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc).
        end.
        when 8184 then
            assign p_des_mensagem = getStrTrans("Existe restriá∆o da conta para o grupo do usu†rio corrente.", "FGL") /*8184*/
                   p_des_ajuda    = getStrTrans("Verifique no procedimento de restriá‰es se o usu†rio tem permiss∆o de movimentar a conta em quest∆o.", "FGL") /*8184*/.
        when 10657 then
            assign p_des_mensagem = getStrTrans("O Estabelecimento informado n∆o Ç v†lido para o projeto !", "FGL") /*10657*/
                   p_des_ajuda    = getStrTrans("O Estabelecimento informado n∆o Ç v†lido para o projeto. ", "FGL") /*10657*/.
        when 12349 then /* antiga msg 782 */ do:
            find tt_integr_item_lancto_ctbl_1 no-lock
                where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1
            then do:
                assign p_des_mensagem = getStrTrans("Finalidade econìmica n∆o relacionada para o Indic. Econìmico.", "FGL") /*12349*/
                       p_des_ajuda    = substitute(getStrTrans("A finalidade econìmica &1 n∆o possui relaá∆o com o indicador econìmico &2, ou seja, n∆o existe nenhuma composiá∆o de finalidade que os une nessa data &3. Acerto deve ser feito no programa de Manutená∆o Hist¢rico Finalidade Econìmica.", "FGL") /*12349*/, GetEntryField(2,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","),GetEntryField(3,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(4,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,",")).
            end /* if */.
        end.
        when 1568 then
            assign p_des_mensagem = getStrTrans("Valor n∆o convertido para outras finalidades !", "FGL") /*1568*/
                   p_des_ajuda    = getStrTrans("O valor informado n∆o foi convertido para as outras finalidades. Verifique se existem finalidades dispon°veis para a unidade organizacional informada.", "FGL") /*1568*/.
        when 1200 then do:
            find tt_integr_item_lancto_ctbl_1 no-lock
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                  if avail tt_integr_item_lancto_ctbl_1 then
                      assign p_des_mensagem = getStrTrans("ParÉmetros de convers∆o da composiá∆o inexistentes !", "FGL") /*14051*/
                             p_des_ajuda    = substitute(getStrTrans("Verifique se existem parÉmetros de convers∆o v†lidos para a composiá∆o da finalidade econìmica." + chr(10) +
    "" + chr(10) +
    "Finalidade Econìmica: &1" + chr(10) +
    "Data In°cio de Validade Finalidade: &2" + chr(10) +
    "Indicador Econìmico Base: &3" + chr(10) +
    "Indicador Econìmico ÷ndice: &4" + chr(10) +
    "Data In°cio Validade: &5" + chr(10) +
    "Data Transaá∆o: &6" + chr(10) +
    "" + chr(10) +
    "", "FGL") /*14051*/, GetEntryField(6,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(7,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(3,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(4,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(8,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(5,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,",")).
        end.
        when 1389 then do:
            find tt_integr_item_lancto_ctbl_1 no-lock
                 where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
            if  avail tt_integr_item_lancto_ctbl_1
            then do:
                 assign p_des_mensagem = getStrTrans("Finalidade Econìmica n∆o armazena valores no M¢dulo !", "FGL") /*1389*/
                        p_des_ajuda    = substitute(getStrTrans("A finalidade econìmica &1 n∆o permite armazenar valores no m¢dulo.", "FGL") /*1389*/,GetEntryField(3,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,",")).
            end /* if */.
        end.
        when 1036 then
            assign p_des_mensagem = getStrTrans("Comunique a Datasul sobre esta mensagem !", "FGL") /*1036*/
                   p_des_ajuda    = getStrTrans("Favor comunicar a Datasul o n£mero desta mensagem (&1) e o local em que ela apareceu.", "FGL") /*1036*/.
        when 1388 then
           error_block:
           do:
              find tt_integr_item_lancto_ctbl_1 no-lock
                  where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  not avail tt_integr_item_lancto_ctbl_1
              then do: 
                  find tt_integr_aprop_lancto_ctbl_1 no-lock
                      where tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                  if avail tt_integr_aprop_lancto_ctbl_1 then 
                      find tt_integr_item_lancto_ctbl_1 no-lock
                          where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl no-error.
              end /* if */.
              if avail tt_integr_item_lancto_ctbl_1 then 
                  assign p_des_mensagem = substitute(getStrTrans("Existe restriá∆o deste ccusto no estabelecimento: &1 !", "FGL") /*1388*/, tt_integr_item_lancto_ctbl_1.tta_cod_estab)
                         p_des_ajuda    = substitute(getStrTrans("Existe restriá∆o de utilizaá∆o deste centro de custo, no estabelecimento &1. Verificar na Manutená∆o de Centros de Custo as restriá‰es.", "FGL") /*1388*/, tt_integr_item_lancto_ctbl_1.tta_cod_estab).
           end /* do error_block */.
        when 950 then
           error_block:
           do:
              find tt_integr_aprop_lancto_ctbl_1 no-lock
                  where tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail tt_integr_aprop_lancto_ctbl_1
              then do:
                  find tt_integr_item_lancto_ctbl_1 no-lock
                      where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl no-error.
              end /* if */.
              else do:
                  find tt_integr_item_lancto_ctbl_1 no-lock
                      where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
                  if  avail tt_integr_item_lancto_ctbl_1
                  then do:
                      find first tt_integr_aprop_lancto_ctbl_1 no-lock
                          where tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl no-error.
                  end /* if */.
              end /* else */.
              if avail tt_integr_item_lancto_ctbl_1 then
                  assign p_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FGL") /*950*/,tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc,tt_integr_item_lancto_ctbl_1.tta_cod_estab)
                         p_des_ajuda    = getStrTrans("Unidade de Neg¢cio n∆o habilitada para o Estabelecimento. Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o de Unidades de Neg¢cio do Estabeleciemnto, se a Unidade de Neg¢cio est† cadastrada para este Estabelecimento.", "FGL") /*950*/.
           end /* do error_block */. 

        /* Begin_Include: i_msg_lote_ctbl_recebto_1 */
        when 3083 then
           error_block:
           do:
              find btt_integr_item_lancto_ctbl_1 no-lock
                  where btt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail btt_integr_item_lancto_ctbl_1
              then do:
                  find tt_integr_lancto_ctbl_1 no-lock
                      where tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = btt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl no-error.
                  find tt_integr_lote_ctbl_1 no-lock
                      where tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl no-error.
                  if avail btt_integr_item_lancto_ctbl_1 then 
                      assign p_des_mensagem = substitute(getStrTrans("Estabelecimento &1 n∆o Ç da Empresa &2 !", "FGL") /*3083*/,btt_integr_item_lancto_ctbl_1.tta_cod_estab,tt_integr_lote_ctbl_1.tta_cod_empresa)
                             p_des_ajuda    = getStrTrans("Verificar na Manutená∆o de Estabelecimentos a Empresa.", "FGL") /*3083*/.
              end /* if */.
           end /* do error_block */.
        when 10320 then
            assign p_des_mensagem = getStrTrans("Tipo de Unidade Organizacional inexistente !", "FGL") /*10320*/
                   p_des_ajuda    = getStrTrans("O tipo de Unidade Organizacional 998 n∆o existe.", "FGL") /*10320*/.
        when 10321 then
            assign p_des_mensagem = getStrTrans("Traduá∆o de Organizaá∆o Externa inexistente para tipo 998 !", "FGL") /*10321*/
                   p_des_ajuda    = getStrTrans("Traduá∆o de Organizaá∆o Externa inexistente para tipo Unidade Organizacional Empresa !", "FGL") /*10321*/.
        when 10338 then
            assign p_des_mensagem = getStrTrans("Problema de Conex∆o com as bases do ems 2 !", "FGL") /*10338*/
                   p_des_ajuda    = getStrTrans("Favor verificar porque alguma base do ems 2 n∆o est† conectando.", "FGL") /*10338*/.
        when 10337 then
            assign p_des_mensagem = getStrTrans("Tipo de Unidade Organizacional inexistente !", "FGL") /*10337*/
                   p_des_ajuda    = getStrTrans("O tipo de Unidade Organizacional 999 n∆o existe.", "FGL") /*10337*/.
        when 10336 then
            assign p_des_mensagem = getStrTrans("Traduá∆o de Organizaá∆o Externa inexistente para tipo 999 !", "FGL") /*10336*/
                   p_des_ajuda    = getStrTrans("Traduá∆o de Organizaá∆o Externa inexistente para tipo Unidade Organizacional Estabelecimento !", "FGL") /*10336*/.
        when 5722 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '5722' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = getStrTrans("Traduá∆o de Pa°s inexistente !", "FGL") /*5722*/
                       p_des_ajuda    = substitute(getStrTrans("N∆o foi encontrada traduá∆o para o pa°s &1 na matriz de traduá∆o &2. Consulte a Manutená∆o de Matriz Traduá∆o Pa°s.", "FGL") /*5722*/,GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";"), GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
        end.
        when 2270 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '2270' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = getStrTrans("Traduá∆o para Finalidade Econìmica Externa Inexistente !", "FGL") /*2270*/
                       p_des_ajuda    = substitute(getStrTrans("Traduá∆o finalidade econìmica externa n∆o encontrada para a finalidade econìmica &1.", "FGL") /*2270*/,GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
        end.
        when 10322 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '10322' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = substitute(getStrTrans("Finalidade Econìmica &1 deve armazenar ~'M¢dulos~' !", "FGL") /*10322*/,GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ";")).
                       p_des_ajuda    = getStrTrans("Utilizar o programa de manutená∆o de Finalidades Econìmicas.", "FGL") /*10322*/.
        end.
        when 3802 then do:
            find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '3802' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
                assign p_des_mensagem = getStrTrans("Matriz Traduá∆o Conta Cont†bil Externa N∆o Localizada !", "FGL") /*3802*/
                       p_des_ajuda    = substitute(getStrTrans("Matriz traduá∆o conta cont†bil externa n∆o localizada, para a unidade organizacional &1 e matriz de traduá∆o conta cont†bil externa &2.", "FGL") /*3802*/,GetEntryField(1,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,";"),GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters,";")).
        end.
        when 2221 then
            assign p_des_mensagem = getStrTrans("Traduá∆o da Conta Cont†bil Inexistente !", "FGL") /*2221*/
                   p_des_ajuda    = "" /*2221*/.
        when 19322 then
            assign p_des_mensagem = substitute(getStrTrans("Interrupá∆o da contabilizaá∆o do lote &1 !", "FGL") /*19322*/,"")
                   p_des_ajuda    = getStrTrans("O lote n∆o foi contabilizado, ocorreu uma interrupá∆o no processo.  Verifique se o lote ficou pendente em Manutená∆o Lanáamentos Cont†beis (Contabilidade Fiscal) e efetue a contabilizaá∆o, caso contr†rio execute o processo novamente.", "FGL") /*19322*/.
        when 19316 then do:
           find first tt_integr_ctbl_valid_parametros
            where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
              and tt_integr_ctbl_valid_parametros.ttv_cod_msg = '19316' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
               assign p_des_mensagem = GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ';')
                      p_des_ajuda    = GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ';').
            else 
               assign p_des_mensagem = substitute(getStrTrans("Problema na atualizaá∆o do saldo cont†bil do per°odo &1 !", "FGL") /*19316*/,"")
                      p_des_ajuda    = substitute(getStrTrans("O sistema n∆o repassou o valor contabilizado para o per°odo &1. Verifique se o lote ficou pendente em Manutená∆o Lanáamentos Cont†beis (Contabilidade Fiscal) e efetue a contabilizaá∆o, caso contr†rio execute o processo novamente.", "FGL") /*19316*/,"").
        end.
        when 19317 then do:
            find first tt_integr_ctbl_valid_parametros
            where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
              and tt_integr_ctbl_valid_parametros.ttv_cod_msg = '19317' no-lock no-error.
            if avail tt_integr_ctbl_valid_parametros then
               assign p_des_mensagem = GetEntryField(1, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ';')
                      p_des_ajuda    = GetEntryField(2, tt_integr_ctbl_valid_parametros.ttv_cod_parameters, ';').
            else 
               assign p_des_mensagem = substitute(getStrTrans("Problema da criaá∆o de saldo cont†bil do per°odo &1 !", "FGL") /*19317*/,"")
                      p_des_ajuda    = substitute(getStrTrans("O sistema n∆o conseguiu criar registro de saldo cont†bil para o per°odo &1. Verifique se o lote ficou pendente em Manutená∆o Lanáamentos Cont†beis (Contabilidade Fiscal) e efetue a contabilizaá∆o, caso contr†rio execute o processo novamente.", "FGL") /*19317*/,11).
        end.                                            
        /* End_Include: i_msg_lote_ctbl_recebto_1 */

        when 358 then do:
             find tt_integr_item_lancto_ctbl_1 no-lock
                  where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail tt_integr_item_lancto_ctbl_1
              then do:
                  assign p_des_mensagem = getStrTrans("Cotaá∆o entre Indicadores Econìmicos n∆o encontrada !", "FGL") /*358*/
                         p_des_ajuda    = substitute(getStrTrans("Verifique se existe cotaá∆o do tipo &4 , entre os Indicadores Econìmicos &1 e &2, em &3.", "FGL") /*358*/,GetEntryField(2,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","),GetEntryField(3,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(4,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","),GetEntryField(5,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,",")).
              end /* if */.
        end.
        when 12712 then do:
             find tt_integr_item_lancto_ctbl_1 no-lock
                  where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail tt_integr_item_lancto_ctbl_1
              then do:
                  assign p_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 deve ser anal°tica !", "FGL") /*12712*/, tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc).
                         p_des_ajuda    = ''.
              end /* if */.
        end.    
        when 10351 then
            assign p_des_mensagem = getStrTrans("Programa  'cdp/cdapi007a' n∆o encontrado.", "FGL") /*10351*/
                   p_des_ajuda    = "" /*10351*/.
        when 11277 then do:
              find tt_integr_item_lancto_ctbl_1 no-lock
                  where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail tt_integr_item_lancto_ctbl_1
              then do:
                  assign p_des_mensagem = getStrTrans("Informados itens sem as apropriaá‰es !", "FGL") /*11277*/
                         p_des_ajuda    = substitute(getStrTrans("Devem ser informadas apropriaá‰es sempre que forem informados itens, hist¢rico do item: &1.", "FGL") /*11277*/,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl).
              end /* if */.
        end /* if */.
        when 13774 then
            assign p_des_mensagem = getStrTrans("Diferenáa entre dÇbito e crÇdito !", "FGL") /*13774*/
                   p_des_ajuda    = v_des_msg_erro_aux.
        when 56 then 
            assign p_des_mensagem = 'Conta Contabil do ems 2 n∆o encontrada!'
                   p_des_ajuda    = 'Consulte o cadastro de manutená∆o de traduá‰es de conta cont†bil ou verifique a composiá∆o da conta !'.
          when 7877 then 
            assign p_des_mensagem = 'N∆o foi encontrado documento pendente para atualizar no Ems 2 !'.
          when 6246  then 
            assign p_des_mensagem = 'Programa execut†vel n∆o encontrado.'.
          when 4 then 
            assign p_des_mensagem = 'Programa execut†vel n∆o encontrado.'.
          when 636 then 
            assign p_des_mensagem = 'Conta Cont†bil do Ems 2 Ç de titulo, n∆o pode receber lanáamentos.'.
          when 913 then 
            assign p_des_mensagem = 'Conta Cont†bil do Ems 2 est† desativada ' .
          when 608 then 
            assign p_des_mensagem = 'Apuraá∆o de Lucros/Perdas j† apurada para o ano, no ems 2.'.
          when 3273 then 
            assign p_des_mensagem = 'A atualizaá∆o do movto no ems 2 n∆o ser† permitida, pois o per°odo n∆o esta aberto.'.
          when 1828 then 
            assign p_des_mensagem = 'Ocorreu um erro na atualizaá∆o no ems 2.'.
          when 2521 then 
            assign p_des_mensagem = 'Contabilizaá∆o Efetuada com Sucesso.'.
          when 1121 then 
            assign p_des_mensagem = 'A data do movimento do documento est† fora do limite permitido para a empresa no Ems 2.'.
          when 15631  then 
            assign p_des_mensagem = 'Checar estrutura das contas. Pode ter conta pai cadastrado como filho.'.
          when 17587  then 
            assign p_des_mensagem = 'Conta Cont†bil do ems 2 deve ser diferente de branco'.
          when 328  then 
            assign p_des_mensagem = 'Ano Fiscal n∆o cadastrado no ems 2'.
          when 18100 then 
            assign p_des_mensagem = 'Valor com qtde de casas decimais inv†lido'
                   p_des_ajuda    = 'Foram informadas mais casas decimais em algum valor informado do que o parametrizado para a moeda no EMS2.'.
          when 18100 then 
            assign p_des_mensagem = 'Empresa n∆o possui moeda FASB cadastrada no Ems 2'
                   p_des_ajuda    = 'N∆o existe moeda FASB cadastrada nos parÉmetros FASB/CMCAC do programa FC0101 (M¢dulo FASB/CMCAC).'.
          when 1710 then 
            assign p_des_mensagem = 'Empresa n∆o possui moeda CMCAC cadastrada no Ems 2'
                   p_des_ajuda    = 'N∆o existe moeda CMCAC cadastrada nos parÉmetros FASB/CMCAC do programa FC0101 (M¢dulo FASB/CMCAC).'.
          when 4210 then 
            assign p_des_mensagem = 'Empresa n∆o possui moeda AMBID cadastrada no Ems 2'
                   p_des_ajuda    = 'N∆o existe moeda ANBID cadastrada nos parÉmetros FASB/CMCAC do programa FC0101 (M¢dulo FASB/CMCAC).'.
          when 18308 then 
            assign p_des_mensagem = 'Movimento n∆o atualizado. Diferenáa Db/Cr na moeda no Ems 2'
                   p_des_ajuda    = 'Diferenáa DÇbito/CrÇdito na moeda no Ems 2. Movimento n∆o atualizado.'.
          when 16322 then 
            assign p_des_mensagem = 'Movimento est† pendente no cancelamento no Ems 2.'
                   p_des_ajuda    = 'O movimento foi parcialmente cancelado e est† pendente. Dever† ser concluido o processo de cancelamento antes de fazer a Atualizaá∆o dos movimentos. N∆o pode ser feito nenhum tipo de alteraá∆o, c¢pia ou eliminaá∆o de referància ou dos lanáamentos.'.
          when 11354 then do:
             find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '11354' no-lock no-error.
             if avail tt_integr_ctbl_valid_parametros then do:
                 assign p_des_mensagem = 'Encontrado diferenáa entre dÇbito e crÇdito no lote cont†bil.'.
                 if num-entries(tt_integr_ctbl_valid_parametros.ttv_cod_parameters, chr(10)) > 1 then
                     assign p_des_ajuda = substitute('Esse lote cont†bil ficar† pendente para que seja feita a regularizaá∆o da diferenáa encontrada. (Finalidade: &1, Lote &2, Lanáamento &3, Valor DÇbito &4, Valor CrÇdito &5).', GetEntryField(1,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(2,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(3,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(4,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(5,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10))).
                 else
                     assign p_des_ajuda = substitute('Esse lote cont†bil ficar† pendente para que seja feita a regularizaá∆o da diferenáa encontrada. (Finalidade: &1, Lote &2, Lanáamento &3, Valor DÇbito &4, Valor CrÇdito &5).', trim(tt_integr_ctbl_valid_parametros.ttv_cod_parameters)).
             end.                 
             else
                assign p_des_mensagem = 'Encontrado diferenáa entre dÇbito e crÇdito no lote cont†bil.'
                       p_des_ajuda    = 'Esse lote cont†bil ficar† pendente para que seja feita a regularizaá∆o da diferenáa encontrada.'.
          end.
          when 12578 then do:
             find first tt_integr_ctbl_valid_parametros
                 where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                 and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '12578' no-lock no-error.
             if avail tt_integr_ctbl_valid_parametros then do:
                 assign p_des_mensagem = 'Encontrado diferenáa entre dÇbito e crÇdito no lote cont†bil.'.
                 if num-entries(tt_integr_ctbl_valid_parametros.ttv_cod_parameters, chr(10)) > 1 then
                     assign p_des_ajuda = substitute(getStrTrans("Lote n∆o ser† contabilizado pois foi encontrado diferenáa entre dÇbito e crÇdito.(Finalidade: &1, Lote &2, Lanáamento &3, Valor DÇbito &4, Valor CrÇdito &5).", "FGL") /*12578*/, GetEntryField(1,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(2,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(3,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(4,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)),GetEntryField(5,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10))).
                 else
                     assign p_des_ajuda = substitute(getStrTrans("Lote n∆o ser† contabilizado pois foi encontrado diferenáa entre dÇbito e crÇdito.(Finalidade: &1, Lote &2, Lanáamento &3, Valor DÇbito &4, Valor CrÇdito &5).", "FGL") /*12578*/, trim(tt_integr_ctbl_valid_parametros.ttv_cod_parameters)).
             end.                 
             else
                assign p_des_mensagem = getStrTrans("Encontrado diferenáa entre dÇbito e crÇdito.", "FGL") /*12578*/
                       p_des_ajuda    = getStrTrans("Lote n∆o ser† contabilizado pois foi encontrado diferenáa entre dÇbito e crÇdito.(Finalidade: &1, Lote &2, Lanáamento &3, Valor DÇbito &4, Valor CrÇdito &5).", "FGL") /*12578*/.

             /* Begin_Include: i_pi_msg_lote_ctbl_recebto_1 */
             /* include criada para evitar erro 444 do DWB na PI pi_msg_lote_ctbl_recebto_1 */

             for each btt_integr_item_lancto_ctbl_1 no-lock 
                 where btt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl:
                 find cta_ctbl no-lock
                      where cta_ctbl.cod_plano_cta_ctbl = btt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl
                        and cta_ctbl.cod_cta_ctbl       = btt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl no-error.
                 if avail cta_ctbl then do:
                    if cta_ctbl.ind_utiliz_ctbl_finalid = "Armazena Exclusiva" /*l_armazena_exclusiva*/  then do:
                       if not can-find(first tt_integr_ctbl_erro_cta
                          where tt_integr_ctbl_erro_cta.ttv_rec_integr_ctbl         = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl         
                            and tt_integr_ctbl_erro_cta.tta_cod_cta_ctbl            = btt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl          
                            and tt_integr_ctbl_erro_cta.tta_cod_plano_ccusto        = btt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl
                            and tt_integr_ctbl_erro_cta.tta_ind_utiliz_ctbl_finalid = cta_ctbl.ind_utiliz_ctbl_finalid) then do:                  
                          create tt_integr_ctbl_erro_cta.
                          assign tt_integr_ctbl_erro_cta.ttv_rec_integr_ctbl         = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                                 tt_integr_ctbl_erro_cta.tta_cod_cta_ctbl            = btt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl
                                 tt_integr_ctbl_erro_cta.tta_cod_plano_ccusto        = btt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl
                                 tt_integr_ctbl_erro_cta.tta_ind_utiliz_ctbl_finalid = cta_ctbl.ind_utiliz_ctbl_finalid
                                 tt_integr_ctbl_erro_cta.tta_cod_finalid_econ        = cta_ctbl.cod_finalid_econ.
                       end.
                    end.
                 end.
             end.
             /* End_Include: i_pi_msg_lote_ctbl_recebto_1 */

          end.
          when 12008 then
               assign p_des_mensagem = getStrTrans("Itens contabilizados em plano de contas diferentes !", "FGL") /*12008*/
                      p_des_ajuda    = getStrTrans("O Lanáamento Cont†bil possui itens em plano de contas diferentes. O movimento deve ser estornado ou ent∆o utilize a rotina de alteraá∆o de rateio e altere o plano de contas.", "FGL") /*12008*/.
          when 13137 then do:
              find tt_integr_item_lancto_ctbl_1 no-lock
                   where tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl no-error.
              if  avail tt_integr_item_lancto_ctbl_1 then do:
                  assign p_des_mensagem = getStrTrans("Finalidade n∆o Liberada para a Unidade Organizacional !", "FGL") /*13137*/
                         p_des_ajuda    = substitute(getStrTrans("A finalidade econìmica &1 associada ao indicador econìmico &2 informado, n∆o est† habilitada para a unidade organizacional &3 na data &4.", "FGL") /*13137*/,GetEntryField(2,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(3,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(4,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,","), GetEntryField(5,tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl,",")).
              end.           
          end.
          when 20334 then do:
               find first tt_integr_ctbl_valid_parametros
                    where tt_integr_ctbl_valid_parametros.ttv_cod_msg = '20334' no-lock no-error.      
               if  avail tt_integr_ctbl_valid_parametros then
                    assign p_des_mensagem = getStrTrans("Alteraá∆o do projeto padr∆o n∆o foi conclu°da !", "FGL") /*20334*/
                           p_des_ajuda    = substitute(getStrTrans("O processo de alteraá∆o do projeto padr∆o foi interrompido antes de concluir todas as alteraá‰es necess†rias. Por esse motivo n∆o ser† poss°vel efetuar nenhuma contabilizaá∆o/consulta cont†bil antes de corrigir essa situaá∆o." + chr(10) +
    "Para corrigir a situaá∆o ser† necess†rio executar novamente a alteraá∆o do projeto padr∆o (prgint\utb\utb044aa.r) e aguardar que o processo seja totalmente conclu°do." + chr(10) +
    "Projeto De: &1" + chr(10) +
    "Projeto Para: &2", "FGL") /*20334*/,GetEntryField(1,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,";"), GetEntryField(2,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,";")).
               else                       
                    assign p_des_mensagem = getStrTrans("Alteraá∆o do projeto padr∆o n∆o foi conclu°da !", "FGL") /*20334*/
                           p_des_ajuda    = getStrTrans("O processo de alteraá∆o do projeto padr∆o foi interrompido antes de concluir todas as alteraá‰es necess†rias. Por esse motivo n∆o ser† poss°vel efetuar nenhuma contabilizaá∆o/consulta cont†bil antes de corrigir essa situaá∆o." + chr(10) +
    "Para corrigir a situaá∆o ser† necess†rio executar novamente a alteraá∆o do projeto padr∆o (prgint\utb\utb044aa.r) e aguardar que o processo seja totalmente conclu°do." + chr(10) +
    "Projeto De: &1" + chr(10) +
    "Projeto Para: &2", "FGL") /*20334*/.
          end.

          /* Begin_Include: i_msg_lote_ctbl_recebto */
          when 14342 then do:
              find first tt_integr_ctbl_valid_parametros
                   where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                     and tt_integr_ctbl_valid_parametros.ttv_cod_msg = '14342' no-error.
              if avail tt_integr_ctbl_valid_parametros then do:
                  run pi_messages (input "Msg" /*l_msg*/ ,input 14342,input "" /*l_null*/ ).
                  assign p_des_mensagem = return-value.
                  run pi_messages (input "Help" /*l_help*/ ,input 14342,input "" /*l_null*/ ).
                  assign p_des_ajuda = SUBSTITUTE(RETURN-VALUE, GetEntryField(1,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,"~~"),
                                                                GetEntryField(2,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,"~~"),
                                                                GetEntryField(3,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,"~~"),
                                                                GetEntryField(4,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,"~~")).
              end.      
          end.
          when 19742 then do:
              find first tt_integr_ctbl_valid_parametros
                  where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                  and   tt_integr_ctbl_valid_parametros.ttv_cod_msg = '19742' no-lock no-error.
              if avail tt_integr_ctbl_valid_parametros then do:
                   do v_num_aux = 1 to num-entries(tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)):
                       if v_num_aux = 1 then 
                            assign v_des_msg_aux_2 = chr(10) + 'Mapa    Seq  Rateio   ' + chr(10).

                       assign v_des_msg_aux_2 = v_des_msg_aux_2 + GetEntryField(v_num_aux,tt_integr_ctbl_valid_parametros.ttv_cod_parameters,chr(10)) + '|'.
                       if (v_num_aux MOD 3)= 0 then 
                           assign v_des_msg_aux_2 = v_des_msg_aux_2 + chr(10).              
                   end.
                   assign p_des_mensagem = substitute('Existe(m) mapa(s) de distribuiá∆o com todas as qtdes zeradas.').
                   if v_des_msg_aux_2 <> "" then
                       assign p_des_ajuda = substitute('O(s) mapa(s) abaixo esta(∆o) com todas as quantidades zeradas, o rateio n∆o ser† feito para essa sequància. Essa mensagem Ç apenas um alerta, o lote ser† gerado, se o lote n∆o estiver correto, dever† revisar as quantidades do mapa de distribuiá∆o e gerar o rateio novamente. &1', v_des_msg_aux_2).                                              
                   else
                       assign p_des_ajuda = substitute('O(s) mapa(s) abaixo esta(∆o) com todas as quantidades zeradas, o rateio n∆o ser† feito para essa sequància. Essa mensagem Ç apenas um alerta, o lote ser† gerado, se o lote n∆o estiver correto, dever† revisar as quantidades do mapa de distribuiá∆o e gerar o rateio novamente. &1', trim(tt_integr_ctbl_valid_parametros.ttv_cod_parameters)).                            
              end.                 
              else
                 assign p_des_mensagem = 'O mapa de distribuiá∆o est† com todas as quantidades zeradas.'
                        p_des_ajuda    = 'O mapa de distribuiá∆o est† com todas as quantidades zeradas. Essa mensagem Ç apenas um alerta, o lote ser† gerado, se o lote n∆o estiver correto, dever† revisar as quantidades do mapa de distribuiá∆o e gerar o rateio novamente.'.
          end.
          when 19896 then do:
              find first tt_integr_ctbl_valid_parametros
                  where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                    and tt_integr_ctbl_valid_parametros.ttv_cod_msg = '19896' no-lock no-error.
              if avail tt_integr_ctbl_valid_parametros then do:
                  assign p_des_mensagem = substitute('Plano de Centros de Custo &1 inv†lido!', trim(tt_integr_ctbl_valid_parametros.ttv_cod_parameters))
                         p_des_ajuda    = substitute('Verifique, na Manutená∆o de Planos de Centros de Custo, se o Plano de Centros de Custo &1 est† cadastrado e se est† dentro da data de validade.', trim(tt_integr_ctbl_valid_parametros.ttv_cod_parameters)).

              end.
          end.
          when 20533 then
              assign p_des_mensagem = 'Estabelecimento n∆o informado !'
                     p_des_ajuda    = 'N∆o foi informado um estabelecimento, devido a isso n∆o foi encontrado um projeto v†lido.'.

          /* End_Include: i_msg_lote_ctbl_recebto */

          otherwise do:
            find first tt_integr_ctbl_valid_parametros
                where tt_integr_ctbl_valid_parametros.ttv_rec_aux = tt_integr_ctbl_valid_1.ttv_rec_integr_ctbl
                  and tt_integr_ctbl_valid_parametros.ttv_cod_msg = string(p_num_mensagem) no-lock no-error.

            run pi_busca_info_erro(input p_num_mensagem,
                                   input if avail tt_integr_ctbl_valid_parametros then tt_integr_ctbl_valid_parametros.ttv_cod_parameters else '',
                                   input ';',
                                   output p_des_mensagem,
                                   output p_des_ajuda).

            if return-value <> "OK" /*l_ok*/  then
                assign p_des_mensagem = getStrTrans("Mensagem n∆o Cadastrada.", "FGL") /*1232*/
                       p_des_ajuda    = getStrTrans("Consulte o Suporte do Produto para a Manutená∆o do Programa.", "FGL") /*1232*/.

          end.                  
    end /* case msg_block */.
END PROCEDURE. /* pi_msg_lote_ctbl_recebto_1 */
