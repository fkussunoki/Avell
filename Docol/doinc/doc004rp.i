DEF TEMP-TABLE tt-movto
    FIELD cod-empresa        LIKE emsuni.empresa.cod_empresa 
    FIELD nome-empresa       LIKE emsuni.empresa.nom_razao_social
    FIELD cod-estab          LIKE estabelecimento.cod_estab
    FIELD nome-estab         LIKE estabelecimento.nom_pessoa
    FIELD ccusto             LIKE dc-repres.cod_ccusto
    FIELD cod_cta_ctbl-db    LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD cod_cta_ctbl-cr    LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD ccusto-db          LIKE dc-repres.cod_ccusto
    FIELD ccusto-cr          LIKE dc-repres.cod_ccusto
    FIELD desc-ccusto        LIKE emsuni.ccusto.des_tit_ctbl
    FIELD unid-neg           LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD cod-espec          LIKE tit_acr.cod_espec_docto
    FIELD cod-tit-acr        LIKE tit_acr.cod_tit_acr
    FIELD cod-parcela        LIKE tit_acr.cod_parcela
    FIELD cod_ser_docto      LIKE tit_acr.cod_ser_docto     
    FIELD dat_emis_docto     LIKE tit_acr.dat_emis_docto    
    FIELD dat_vencto_tit_acr LIKE tit_acr.dat_vencto_tit_acr
    FIELD dat_transacao      LIKE movto_tit_acr.dat_transacao
    FIELD cod-cliente        LIKE emsuni.cliente.cdn_cliente
    FIELD nome-cliente       LIKE emsuni.cliente.nom_pessoa
    FIELD vl-abatimento      LIKE tit_acr.val_sdo_tit_acr
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl 
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto  
    FIELD cod_indic_econ     LIKE aprop_ctbl_acr.cod_indic_econ
    FIELD cod_finalid_econ   LIKE finalid_econ.cod_finalid_econ 
    INDEX codigo cod-empresa
                 cod-estab
                 ccusto
                 cod-tit-acr
                 unid-neg.

DEF TEMP-TABLE tt-resumo-movto
    FIELD cod_empresa           LIKE emsuni.empresa.cod_empresa 
    FIELD cod_estab             LIKE estabelecimento.cod_estab
    FIELD cod_plano_cta_ctbl    LIKE plano_cta_ctbl.cod_plano_cta_ctbl 
    FIELD cod_cta_ctbl          LIKE aprop_ctbl_acr.cod_cta_ctbl
    FIELD cod_plano_ccusto      LIKE plano_ccusto.cod_plano_ccusto  
    FIELD cod_ccusto            LIKE emsuni.ccusto.cod_ccusto
    FIELD cod_unid_negoc        LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD data                  LIKE movto_tit_acr.dat_transacao
    FIELD movto                 AS CHAR
    FIELD vl-abatimento         LIKE tit_acr.val_sdo_tit_acr
    INDEX codigo cod_empresa
                 cod_estab
                 cod_cta_ctbl
                 cod_ccusto
                 cod_unid_negoc
                 movto
                 data.

DEF TEMP-TABLE tt-aprop_ctbl_acr LIKE aprop_ctbl_acr.

DEF TEMP-TABLE tt-erro              NO-UNDO
    FIELD cdn_repres                LIKE representante.cdn_repres
    FIELD des_erro                  AS   CHARACTER      FORMAT 'x(80)'
    INDEX cdn_repres                IS   PRIMARY cdn_repres.

/* DEF VAR ct-abatimen-cr-ax       LIKE dc-orc-param.ct-abatimen-cr.                          */
/* DEF VAR ct-abatimen-db-ax       LIKE dc-orc-param.ct-abatimen-db.                          */
/* DEF VAR sc-abatimen-cr-ax       LIKE dc-orc-param.sc-abatimen-cr.                          */
/* DEF VAR sc-abatimen-db-ax       LIKE dc-orc-param.sc-abatimen-db.                          */
DEF VAR i-sequencia             AS INT.
/* DEF VAR c-ind_natur_lancto_ctbl LIKE tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl. */
DEF VAR vl-abatimento           LIKE  tit_acr.val_sdo_tit_acr.
/* DEF VAR de-val-abatimento-movto AS DEC  NO-UNDO.                                           */
DEF VAR c-mensagem              AS CHAR NO-UNDO.

DEF STREAM s-detalhado.
DEF STREAM s-resumido.
DEF NEW SHARED STREAM s_1.

{include/tt-edit.i}
{include/pi-edit.i}

FORM tt-movto.cod-espec          COLUMN-LABEL 'Esp‚cie'               
     tt-movto.cod-tit-acr        COLUMN-LABEL 'T¡tulo'                
     tt-movto.cod-parcela        COLUMN-LABEL 'Parc' 
     tt-movto.cod_ser_docto      COLUMN-LABEL 'Ser'
     tt-movto.dat_emis_docto     COLUMN-LABEL 'Dt EmissÆo'
     tt-movto.dat_vencto_tit_acr COLUMN-LABEL 'Dt  Vencto'
     tt-movto.unid-neg           COLUMN-LABEL 'Un'
     tt-movto.cod-cliente        COLUMN-LABEL 'Cliente'               
     tt-movto.nome-cliente       COLUMN-LABEL 'Nome Cliente'        
     tt-movto.vl-abatimento      COLUMN-LABEL "Total Abatimentos"  
     WITH FRAME f-detalhado  WIDTH 132 DOWN STREAM-IO.

FORM tt-movto.ccusto           COLUMN-LABEL 'Centro de Custo'
     tt-movto.vl-abatimento    COLUMN-LABEL 'Valor do Abatimento' 
     WITH NO-BOX WIDTH 132 FRAME f-resumido DOWN STREAM-IO.
    
FORM representante.cdn_repres    COLUMN-LABEL 'C¢d'
     representante.nom_pessoa    COLUMN-LABEL 'Representante'        FORMAT 'x(30)'
     tt-erro.des_erro            COLUMN-LABEL 'Descri‡Æo do Erro'    FORMAT 'x(93)'
     WITH NO-BOX WIDTH 132 FRAME f-erro DOWN STREAM-IO.

RUN dop/doc004abat.p (INPUT c-cod-empresa,
                      INPUT c-lista-cod-estab,
                      INPUT dt-periodo-ini,
                      INPUT dt-periodo-fin,
                      INPUT tg-consid-jur-vendor,
                      OUTPUT TABLE tt-movto,
                      OUTPUT TABLE tt-resumo-movto,
                      OUTPUT c-mensagem).
IF c-mensagem <> "" THEN
    RUN dop/message.p (INPUT c-mensagem, 
                       INPUT c-mensagem).

/* Bloco Principal */
FOR EACH tt-movto NO-LOCK USE-INDEX codigo
    BREAK BY tt-movto.cod-empresa
          BY tt-movto.cod-estab  
          BY tt-movto.ccusto     
          BY tt-movto.unid-neg
          BY tt-movto.cod-tit-acr:
    
    IF FIRST-OF(tt-movto.cod-empresa)  THEN 
       PUT 'Empresa: '
           tt-movto.cod-empresa ' - '
           tt-movto.nome-empresa SKIP(1).

    IF FIRST-OF(tt-movto.cod-estab) THEN DO:
       PUT 'Estabelecimento: '
           tt-movto.cod-estab ' - '
           tt-movto.nome-estab SKIP(1).
       IF tg-gera-contabil THEN
          RUN pi-gera-contabilizacao(INPUT 'lote', INPUT '', INPUT 0).
    END.

    IF rt-tipo-relat = 2 THEN
       IF FIRST-OF(tt-movto.ccusto) THEN 
          PUT 'Centro de Custo: '
               tt-movto.ccusto ' - ' desc-ccusto SKIP(1).
    
    ASSIGN vl-abatimento = vl-abatimento + tt-movto.vl-abatimento.

    IF tg-gera-contabil THEN
       IF (LAST-OF(tt-movto.ccusto) OR LAST-OF(tt-movto.unid-neg)) THEN DO:            
           ASSIGN i-sequencia = i-sequencia + 10.
           RUN pi-gera-contabilizacao(INPUT 'itens',INPUT 'CR', INPUT vl-abatimento).
           ASSIGN i-sequencia = i-sequencia + 10.
           RUN pi-gera-contabilizacao(INPUT 'itens',INPUT 'DB', INPUT vl-abatimento).
           ASSIGN vl-abatimento = 0.
       END.

    IF rt-tipo-relat = 2 THEN DO:
       DISP tt-movto.cod-espec     
            tt-movto.cod-tit-acr   
            tt-movto.cod-parcela 
            tt-movto.cod_ser_docto     
            tt-movto.dat_emis_docto    
            tt-movto.dat_vencto_tit_acr
            tt-movto.unid-neg
            tt-movto.cod-cliente   
            tt-movto.nome-cliente  
            tt-movto.vl-abatimento WITH FRAME f-detalhado.
       DOWN WITH FRAME f-detalhado.
    
       ACCUMULATE tt-movto.vl-abatimento (TOTAL BY tt-movto.cod-empresa  BY tt-movto.cod-estab BY tt-movto.ccusto).    
       
       IF LAST-OF(tt-movto.ccusto) THEN DO:
          UNDERLINE tt-movto.vl-abatimento WITH FRAME f-detalhado.
          DISP "Total do C.C." @ tt-movto.nome-cliente
                (ACCUM TOTAL BY tt-movto.ccusto tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-detalhado.
          DOWN 1 WITH FRAME f-detalhado.
       END.
       IF LAST-OF(tt-movto.cod-estab) THEN DO:
          UNDERLINE tt-movto.vl-abatimento WITH FRAME f-detalhado.
          DISP "Total do Est." @ tt-movto.nome-cliente
               (ACCUM TOTAL BY tt-movto.cod-estab tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-detalhado.
          DOWN 1 WITH FRAME f-detalhado.
       END.
       IF LAST-OF(tt-movto.cod-empresa) THEN DO:
          UNDERLINE tt-movto.vl-abatimento WITH FRAME f-detalhado.
          DISP "Total da Emp." @ tt-movto.nome-cliente
               (ACCUM TOTAL BY tt-movto.cod-empresa tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-detalhado.        
       END.
    END. /* Detalhado */

    IF rt-tipo-relat = 1 THEN DO:

       ACCUMULATE tt-movto.vl-abatimento (TOTAL BY tt-movto.cod-empresa BY tt-movto.cod-estab BY tt-movto.ccusto).

       IF LAST-OF(tt-movto.ccusto) THEN DO:
          DISP tt-movto.ccusto
               (ACCUM TOTAL BY tt-movto.ccusto tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-resumido.
          DOWN WITH FRAME f-resumido.
       END.
       IF LAST-OF(tt-movto.cod-estab) THEN DO:
          UNDERLINE tt-movto.vl-abatimento WITH FRAME f-resumido.
          DISP "Total Est." @ tt-movto.ccusto
                (ACCUM TOTAL BY tt-movto.cod-estab tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-resumido.
          DOWN 1 WITH FRAME f-resumido.
       END.
       IF LAST-OF(tt-movto.cod-empresa) THEN DO:
          UNDERLINE tt-movto.vl-abatimento WITH FRAME f-resumido.
          DISP "Total Emp." @ tt-movto.ccusto
               (ACCUM TOTAL BY tt-movto.cod-empresa tt-movto.vl-abatimento) @ tt-movto.vl-abatimento WITH FRAME f-resumido.
       END.
    END. /* Resumido */

    IF LAST(tt-movto.unid-neg)  THEN
       IF tg-gera-contabil THEN
          RUN pi-gera-contabilizacao(INPUT 'executa',INPUT '', INPUT 0).
END. /* for each tt-movto */

PROCEDURE pi-gera-contabilizacao:
    DEF INPUT PARAMETER p-table      AS CHAR.
    DEF INPUT PARAMETER p-movto      AS CHAR.                                           
    DEF INPUT PARAMETER p-abatimento AS DEC.

    DEF VAR c-movto        AS CHAR NO-UNDO.
    DEF VAR c-conta        AS CHAR NO-UNDO.
    DEF VAR c-plano-ccusto AS CHAR NO-UNDO.
    DEF VAR c-ccusto       AS CHAR NO-UNDO.
    
    CASE p-table:
        WHEN 'lote' THEN DO:
            CREATE tt_integr_lote_ctbl.
            ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul             = 'FGL' 
                   tt_integr_lote_ctbl.tta_num_lote_ctbl               = 1
                   tt_integr_lote_ctbl.tta_des_lote_ctbl               = 'Abatimento por Centro de Custo ' + STRING(MONTH(dt-periodo-fin),'99') + '/' + STRING(YEAR(dt-periodo-fin))
                   tt_integr_lote_ctbl.tta_cod_empresa                 = tt-movto.cod-empres
                   tt_integr_lote_ctbl.tta_dat_lote_ctbl               = dt-periodo-fin
                   tt_integr_lote_ctbl.ttv_ind_erro_valid              = "NÆo"
                   tt_integr_lote_ctbl.tta_log_integr_ctbl_online      = YES. 
        
            CREATE  tt_integr_lancto_ctbl.
            ASSIGN  tt_integr_lancto_ctbl.tta_cod_cenar_ctbl           = 'Fiscal'
                    tt_integr_lancto_ctbl.tta_log_lancto_conver        = NO
                    tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo = NO 
                    tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl     = RECID(tt_integr_lote_ctbl)
                    tt_integr_lancto_ctbl.tta_num_lancto_ctbl          = 10
                    tt_integr_lancto_ctbl.ttv_ind_erro_valid           = "NÆo" 
                    tt_integr_lancto_ctbl.tta_dat_lancto_ctbl          = dt-periodo-fin.
        END. /* Lote */
    
        WHEN 'itens' THEN DO:
            ASSIGN c-movto        = p-movto
                   c-conta        = IF p-movto = 'CR' THEN tt-movto.cod_cta_ctbl-cr
                                    ELSE                   tt-movto.cod_cta_ctbl-db
                   c-plano-ccusto = IF p-movto = 'CR' 
                                       THEN ''
                                       ELSE IF tt-movto.ccusto <> ''
                                               THEN tt-movto.cod_plano_ccusto
                                               ELSE ''
                   c-ccusto       = IF p-movto = 'CR' 
                                      THEN ''
                                      ELSE tt-movto.ccusto.
            
            FIND FIRST tt_integr_item_lancto_ctbl
                 WHERE tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = c-movto
                   AND tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = tt-movto.cod_plano_cta_ctbl
                   AND tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = c-conta
                   AND tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = c-plano-ccusto
                   AND tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = c-ccusto
                   AND tt_integr_item_lancto_ctbl.tta_cod_estab                    = v_cod_estab_usuar
                   AND tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = tt-movto.unid-neg NO-ERROR.
            
            IF NOT AVAIL tt_integr_item_lancto_ctbl THEN DO:
               CREATE tt_integr_item_lancto_ctbl.
               ASSIGN tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = RECID(tt_integr_lancto_ctbl)
                      tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-sequencia
                      tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = c-movto
                      tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = tt-movto.cod_plano_cta_ctbl
                      tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = c-conta
                      tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = c-plano-ccusto
                      tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = c-ccusto
                      tt_integr_item_lancto_ctbl.tta_cod_estab                    = v_cod_estab_usuar
                      tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = tt-movto.unid-neg
                      tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = 'Abatimento por Centro de Custo ' + STRING(MONTH(dt-periodo-fin),'99') + '/' + STRING(year(dt-periodo-fin))
                      tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = tt-movto.cod_indic_econ
                      tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = dt-periodo-fin
                      tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = i-sequencia
                      tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "NÆo" .

               CREATE tt_integr_aprop_lancto_ctbl.
               ASSIGN tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = tt-movto.cod_finalid_econ
                      tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                      tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                      tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                      tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                      tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                      tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = dt-periodo-fin
                      tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                      tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "NÆo" 
                      tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
            END.
            ELSE DO:
                FIND FIRST tt_integr_aprop_lancto_ctbl
                     WHERE tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl) NO-ERROR.
            END.

            ASSIGN tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl + p-abatimento
                   tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl.
        END. /*Item*/
    
        WHEN  'executa' THEN DO:
            RUN pi-acompanhar IN h-acomp ('Contabilizando Lan‡amentos...').
            
            RUN prgfin/fgl/fgl900zh.py (3            , 
                                        "Aborta Tudo",
                                        NO           ,   
                                        NO           , 
                                        "Apropria‡Æo", 
                                        "Com Erro"   , 
                                        YES          , 
                                        YES          ).

            RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros dos Lan‡amentos...').

            FOR EACH tt_integr_ctbl_valid NO-LOCK:
                RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                 INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                CREATE  tt-erro.
                ASSIGN  tt-erro.des_erro    = 'FGL:' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
                                               RETURN-VALUE + CHR(10) + tt_integr_ctbl_valid.ttv_ind_pos_erro.

                CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:
                    WHEN 'ITEM' THEN DO:
                        FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                             WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
                        IF  AVAIL tt_integr_item_lancto_ctbl THEN DO:
                            ASSIGN  tt-erro.des_erro = tt-erro.des_erro + 
                                    ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl) + 
                                    ' Nat:' + tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl    +
                                    ' PCT:' + tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl       +
                                    ' CTA:' + tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl             +
                                    ' PCC:' + tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto         +
                                    ' CCU:' + tt_integr_item_lancto_ctbl.tta_cod_ccusto               + 
                                    ' EST:' + tt_integr_item_lancto_ctbl.tta_cod_estab                + 
                                    ' UNG:' + tt_integr_item_lancto_ctbl.tta_cod_unid_negoc           +
                                    ' HIS:' + tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl   +
                                    ' IEC:' + tt_integr_item_lancto_ctbl.tta_cod_indic_econ           +
                                    ' DAT:' + STRING(tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl)  +
                                    ' VAL:' + STRING(tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl)  + 
                                    ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart) .
                        END.

                    END.
                END CASE.
            END.
        END.
    END CASE.
END PROCEDURE.

PROCEDURE pi_messages:

    DEF INPUT PARAM c_action    AS CHAR    NO-UNDO.
    DEF INPUT PARAM i_msg       AS INTEGER NO-UNDO.
    DEF INPUT PARAM c_param     AS CHAR    NO-UNDO.

    def var c_prg_msg           AS CHAR    NO-UNDO.

    ASSIGN  c_prg_msg = "messages/":U
                      + STRING(TRUNC(i_msg / 1000,0),"99":U)
                      + "/msg":U
                      + STRING(i_msg, "99999":U).

    IF  SEARCH(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "n’o encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.
END PROCEDURE.  /* pi_messages */

/* Listagem de erros */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    RUN pi-acompanhar IN h-acomp ('Imprimindo listagem de erros ...').
    PAGE.
    PUT SKIP(2)
        "Listagem de ERROS e INCONSISTÒNCIAS" AT 20
        "-----------------------------------" AT 20
        SKIP(2).
    FOR EACH tt-erro NO-LOCK
       BREAK BY tt-erro.cdn_repres:
        IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:
            FIND FIRST representante NO-LOCK
                 WHERE representante.cdn_repres = tt-erro.cdn_repres NO-ERROR.
            IF  AVAIL representante THEN
                DISPLAY representante.cdn_repres
                        representante.nom_pessoa
                        WITH FRAME f-erro.
        END. /*IF  FIRST-OF(tt-erro.cdn_repres) THEN DO:*/

        FOR EACH tt-editor:     DELETE  tt-editor.      END.
        RUN pi-print-editor (tt-erro.des_erro,  92).
        
        FOR EACH tt-editor:
            DISPLAY tt-editor.conteudo @ tt-erro.des_erro WITH FRAME f-erro.
            DOWN WITH FRAME f-erro.
        END. /*FOR EACH tt-editor*/
        DOWN WITH FRAME f-erro.
    END.
END.

/* FIM - Listagem de erros */
