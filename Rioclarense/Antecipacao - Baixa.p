def temp-table tt_vinc_an_x_tit no-undo

      field ttv_cod_estab_ant as character format "x(5)" column-label "Estab AN"
      field ttv_num_id_ant as integer format "999999999" initial 0 label "Token T¡t AN" column-label "Token T¡t AN"
      field ttv_cod_estab_tit_ap as character format "x(5)" column-label "Estab T¡t"
      field ttv_num_id_tit_ap as integer format "999999999" initial 0 label "Token T¡t AP" column-label "Token T¡t AP"
      field ttv_val_vincul as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Vinculado" column-label "Valor Vinculado"
      field ttv_val_cotac_indic_econ as decimal format "->>,>>>,>>>,>>9.9999999999" decimals 10 label "Cota‡Æo" column-label "Cota‡Æo"
      field ttv_des_text_histor as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
      index tt_id is primary unique
                ttv_cod_estab_ant ascending
                ttv_num_id_ant ascending
                ttv_cod_estab_tit_ap ascending
                ttv_num_id_tit_ap ascending.

def temp-table tt_erro_msg no-undo
      field ttv_num_msg_erro as integer format ">>>>>>9" label "Mensagem" column-label "Mensagem"
      field ttv_des_msg_erro as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
      field ttv_des_help_erro as character format "x(200)"
      index tt_num_erro 
                ttv_num_msg_erro ascending.


DEFINE TEMP-TABLE tt-titulos
    FIELD ttv_cod_estabel                AS char
    FIELD ttv_cod_espec                  AS CHAR
    FIELD ttv_serie                      AS char
    FIELD ttv_cdn_fornecedor             AS INTEGER
    FIELD ttv_cod_tit_ap                 AS char
    field ttv_cod_parcela                as char.

DEFINE BUFFER b_tit_ap FOR tit_ap.
def stream s1.
def stream s2.

INPUT FROM c:/desenv/zerar1.txt.

             REPEAT:
                 CREATE tt-titulos.
                 IMPORT DELIMITER ";" tt-titulos.
             END.

             INPUT CLOSE.


DEF VAR h-prog AS HANDLE.
DEF VAR v_hdl_api AS HANDLE.

FIND FIRST tit_ap NO-LOCK WHERE tit_ap.cod_tit_Ap           = "Antecipa"
                          AND   tit_ap.COD_estab            = "101"
                          AND   tit_ap.cod_espec_docto      = "AN"
                          AND   tit_ap.cdn_fornec           = 5294
                          AND   tit_ap.cod_parcela          = ""
                          AND   tit_ap.cod_ser_docto        = "" NO-ERROR.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Gerando").

output stream s1 to c:\desenv\erros.txt.
output stream s2 to c:\desenv\certos_ok.txt.
FOR EACH tt-titulos:
             run prgfin/apb/apb532za.py persisten set v_hdl_api.


RUN pi-acompanhar IN h-prog (INPUT "Titulo " + tt-titulos.ttv_cod_tit_ap + 
                               " Estab "  + tt-titulos.ttv_cod_Estabel +
                               " Serie "  +  tt-titulos.ttv_serie +        
                               " Fornec"  + string(tt-titulos.ttv_cdn_fornecedor)).
                       

    EMPTY TEMP-TABLE tt_vinc_an_x_tit.
    EMPTY TEMP-TABLE tt_erro_msg.

    FIND FIRST b_tit_ap WHERE b_tit_ap.cod_tit_ap           = tt-titulos.ttv_cod_tit_ap
                        and   b_tit_ap.cod_espec_docto      = tt-titulos.ttv_cod_espec
                        AND   b_tit_ap.cod_estab            = tt-titulos.ttv_cod_Estabel
                        AND   b_tit_ap.cod_ser_docto        = tt-titulos.ttv_serie
                        AND   b_tit_ap.cdn_fornecedor       = tt-titulos.ttv_cdn_fornecedor
                        AND   b_tit_ap.cod_parcela          = tt-titulos.ttv_cod_parcela NO-ERROR.

    CREATE tt_vinc_an_x_tit.
    ASSIGN tt_vinc_an_x_tit.ttv_cod_estab_ant    = tit_ap.cod_estab
           tt_vinc_an_x_tit.ttv_num_id_ant       = tit_ap.num_id_tit_ap
           tt_vinc_an_x_tit.ttv_cod_estab_tit_Ap = tt-titulos.ttv_cod_estabel
           tt_vinc_an_x_tit.ttv_num_id_tit_Ap    = b_tit_Ap.num_id_tit_ap
           tt_vinc_an_x_tit.ttv_val_vincul       = b_tit_Ap.val_sdo_tit_ap
           tt_vinc_an_x_tit.ttv_val_cotac_indic_econ = 1
           tt_vinc_an_x_tit.ttv_des_text_histor  = "Vinculacao para acerto".

    run pi_main_code_api_vinc_an_x_tit_ap in v_hdl_api (input 1,
                                                                                           input 12/31/2018,
                                                                                           input table tt_vinc_an_x_tit,
                                                                                           output table tt_erro_msg).

    FOR EACH tt_erro_msg:

        PUT stream s1 UNFORMATTED tt_erro_msg.ttv_num_msg_erro   "|"
                                  tt_erro_msg.ttv_des_msg_erro   "|"
                                  tt_erro_msg.ttv_des_help_erro  "|"
                                  b_tit_ap.cod_estab             "|"
                                  b_tit_ap.cod_espec_docto       "|"
                                  b_tit_ap.cod_ser_docto         "|"
                                  b_tit_ap.cdn_fornecedor        "|"
                                  b_tit_ap.cod_tit_ap            "|"
                                  b_tit_ap.cod_parcela
                                  SKIP.



    END.
    
    find first tt_erro_msg no-error.
    
    if not avail tt_erro_msg then do:
        put stream s2 unformatted tt-titulos.ttv_cod_tit_ap        "|"
                                  tt-titulos.ttv_cod_estabel       "|"
                                  tt-titulos.ttv_serie             "|"
                                  tt-titulos.ttv_cdn_fornecedor     "|"
                                  tt-titulos.ttv_cod_parcela       
                                  skip.
        end.
    


delete procedure v_hdl_api.

END.
RUN pi-finalizar IN h-prog.


