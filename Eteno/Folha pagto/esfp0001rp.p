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


/* def shared temp-table tt_integr_ctbl_valid_parametros no-undo */
/*     field ttv_rec_aux                      as recid format ">>>>>>9" */
/*     field ttv_cod_parameters               as character format "x(256)" */
/*     field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem" */
/*     . */

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
    FIELD ttv-estab  AS CHAR
    FIELD TTV-HISTORICO AS CHAR FORMAT "X(200)".


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

            disp stream str-rp tt_log_erros.ttv-cta column-label "Contas Externa" format "x(10)"
                                tt_log_erros.ttv-cc  column-label "CCusto Externo" format "x(10)"
                                tt_log_erros.ttv-estab column-label "Estab" format "x(5)"
                                tt_log_erros.ttv-historico column-label "Erro" format "x(80)"
                                
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
                   tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial))
                   TT_LOG_ERROS.TTV-HISTORICO = "NAO ENCONTREI MATRIZ DE TRADUCAO".

        END.
        
        IF TRAD_CTA_CTBL_EXT.COD_CTA_CTBL = "" THEN DO:
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.ttv-cta = string(int(tt-folha-sage.ttv-cta-db))
                   tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                   tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial))
                   TT_LOG_ERROS.TTV-HISTORICO = "CONTA CONTABIL ESTA VAZIA NA MATRIZ DE TRADUCAO".

        
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
        IF TRAD_CTA_CTBL_EXT.COD_CTA_CTBL = "" THEN DO:
            CREATE tt_log_erros.
            ASSIGN tt_log_erros.ttv-cta = string(int(tt-folha-sage.ttv-cta-cr))
                   tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                   tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial))
                   TT_LOG_ERROS.TTV-HISTORICO = "CONTA CONTABIL ESTA VAZIA NA MATRIZ DE TRADUCAO".

        
        END.



    END.
    
    FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-cr)) <> '0':

        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-cr))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.
                                             
        if avail trad_cta_ctbl_ext then do:                                     
            find first cta_ctbl no-lock where cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl 
                                        and   cta_ctbl.dat_fim_valid < today no-error.
            
            if avail cta_ctbl then do:
            
                CREATE tt_log_erros.
                ASSIGN tt_log_erros.ttv-cta = string(cta_ctbl.cod_cta_ctbl)
                       tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                       tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial)).
    
            
            end.
        
        end.
    end.    
    
    
     FOR EACH tt-folha-sage WHERE string(int(tt-folha-sage.ttv-cta-db)) <> '0':

        FIND FIRST trad_cta_ctbl_ext NO-LOCK WHERE trad_cta_ctbl_ext.cod_unid_organ          = '1'
                                             AND   trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = 'sage'
                                             AND   trad_cta_ctbl_ext.cod_cta_ctbl_ext        = string(int(tt-folha-sage.ttv-cta-db))
                                             AND   trad_cta_ctbl_ext.cod_estab_ext           = string(int(tt-folha-sage.ttv-filial))
                                             AND   trad_cta_ctbl_ext.cod_ccusto_ext          = string(int(tt-folha-sage.ttv-ccusto)) NO-ERROR.
        if avail trad_cta_ctbl_ext then do:                                     
            find first cta_ctbl no-lock where cta_ctbl.cod_cta_ctbl = trad_cta_ctbl_ext.cod_cta_ctbl 
                                        and   cta_ctbl.dat_fim_valid < today no-error.
            
            if avail cta_ctbl then do:
            
                CREATE tt_log_erros.
                ASSIGN tt_log_erros.ttv-cta = string(cta_ctbl.cod_cta_ctbl)
                       tt_log_erros.ttv-cc  = string(int(tt-folha-sage.ttv-ccusto))
                       tt_log_erros.ttv-estab = string(int(tt-folha-sage.ttv-filial))
                       TT_LOG_ERROS.TTV-HISTORICO = "CONTA FORA DA DATA DE VALIDADE".
                       
    
            
            end.
        
        end.
    end.    
    
    
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
                                                
/*                                                 output to c:\desenv\lote_ctbl.txt. */
/*    */
/*                                                 for each tt_integr_item_lancto_ctbl_1: */
/*                                                 export delimiter "|" tt_integr_item_lancto_ctbl_1. */
/*                                                 end. */
/*    */
                        RUN pi-imprime.
  
END PROCEDURE.


PROCEDURE pi-imprime:

    FOR EACH tt_integr_ctbl_valid_1:

 
        DISP STREAM str-rp
            ttv_num_mensagem COLUMN-LABEL "Cod.MSG" FORMAT "999999"  
            ttv_ind_pos_erro COLUMN-LABEL "Erro" FORMAT "x(300)"
            WITH STREAM-IO WIDTH 500.


    END.
{include/i-rpclo.i &STREAM="stream str-rp"}


END PROCEDURE.


