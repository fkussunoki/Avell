def temp-table tt-detalhe
    FIELD ep-codigo       LIKE emsuni.empresa.cod_empresa    
    FIELD cod-estabel     LIKE estabelec.cod-estabel  
    FIELD ct-codigo       LIKE conta-contab.ct-codigo  
    FIELD cc-codigo       LIKE dc-repres.cod_ccusto    
    FIELD serie           LIKE nota-fiscal.serie   
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis  
    FIELD it-codigo       LIKE movto-estoq.it-codigo
    FIELD desc-item       AS CHAR FORMAT 'X(18)' LABEL 'Descri‡Æo  do Item'
    FIELD cod-emitente    LIKE emitente.cod-emitente
    FIELD data            AS DATE
    FIELD vl-mat          as decimal format "->>>,>>>,>>9.99"
    FIELD vl-mob          as decimal format "->>>,>>>,>>9.99"
    FIELD vl-impostos     as decimal format "->>>,>>>,>>9.99"
    INDEX ch-principal is unique primary
          ep-codigo       ascending
          cod-estabel     ascending
          ct-codigo       ascending
          cc-codigo       ascending
          serie           ascending 
          nr-nota-fis     ascending
          it-codigo       ascending
          cod-emitente    ascending.

def temp-table tt-resumo
    FIELD ep-codigo    LIKE emsuni.empresa.cod_empresa
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD ct-codigo    LIKE conta-contab.ct-codigo
    FIELD cc-codigo    LIKE dc-repres.cod_ccusto
    FIELD data         AS DATE
    FIELD vl-mat       as decimal format "->>>>>,>>>,>>9.99"
    FIELD vl-mob       as decimal format "->>>>>,>>>,>>9.99"
    FIELD vl-impostos  AS decimal format "->>>>>,>>>,>>9.99"
    INDEX ch-empresa is unique primary
          ep-codigo   ascending
          cod-estabel ascending
          ct-codigo   ascending
          cc-codigo   ascending.

DEF TEMP-TABLE tt-contabiliza
    FIELD cod-empresa        LIKE emsuni.empresa.cod_empresa 
    FIELD cod-estab          LIKE estabelecimento.cod_estab
    FIELD unid-neg           LIKE aprop_ctbl_acr.cod_unid_negoc
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_ccusto         LIKE emsuni.ccusto.cod_ccusto
    FIELD cod_indic_econ     LIKE aprop_ctbl_acr.cod_indic_econ
    FIELD cod_finalid_econ   LIKE finalid_econ.cod_finalid_econ
    FIELD movto              AS CHAR 
    FIELD data               AS DATE
    FIELD valor              AS DEC FORMAT '>>>>,>>>,>>9.9999'.

DEF TEMP-TABLE tt-aprop_ctbl_acr LIKE aprop_ctbl_acr.
DEF TEMP-TABLE tt-erro              NO-UNDO
    FIELD cdn_repres                LIKE representante.cdn_repres
    FIELD des_erro                  AS   CHARACTER      FORMAT 'x(80)'
    INDEX cdn_repres                IS   PRIMARY cdn_repres.

DEF STREAM s-detalhado.
DEF STREAM s-resumido.
DEF NEW SHARED STREAM s_1.

{include/tt-edit.i}
{include/pi-edit.i}

FORM representante.cdn_repres    COLUMN-LABEL 'C¢d'
     representante.nom_pessoa    COLUMN-LABEL 'Representante'        FORMAT 'x(30)'
     tt-erro.des_erro            COLUMN-LABEL 'Descri‡Æo do Erro'    FORMAT 'x(93)'
     WITH NO-BOX WIDTH 132 FRAME f-erro DOWN STREAM-IO.

RUN dop/doc009cpv.p (tt-param.c-cod-empresa,
                     tt-param.c-lista-cod-estab,
                     tt-param.cod-repres,
                     tt-param.dt-periodo-ini,
                     tt-param.dt-periodo-fin,
                     tt-param.log-impostos-bonif,
                     tt-param.c-cta-bonif,
                     NO, /* log-somente-bonif */
                     OUTPUT c-mensagem,
                     OUTPUT c-msg-ajuda,
                     OUTPUT TABLE tt-detalhe,
                     OUTPUT TABLE tt-resumo,
                     OUTPUT TABLE tt-contabiliza).

IF c-mensagem <> "" THEN
    RUN dop/message.p (INPUT c-mensagem,
                       INPUT c-msg-ajuda).

/* Bloco Principal */     
{doinc/doc009rp2.i}

IF tt-param.tg-gera-contabil THEN DO:

   FIND FIRST plano_ccusto NO-LOCK USE-INDEX plnccst_id
        WHERE plano_ccusto.cod_empresa      = empresa.cod_empresa 
          AND plano_ccusto.dat_inic_valid  <= TODAY
          AND plano_ccusto.dat_fim_valid   >= TODAY NO-ERROR.

   FOR EACH tt-contabiliza NO-LOCK
      WHERE tt-contabiliza.valor > 0
      BREAK BY tt-contabiliza.cod-empresa
            BY tt-contabiliza.cod-estab  
            BY tt-contabiliza.unid-neg   
            BY tt-contabiliza.cod_cta_ctbl
            BY tt-contabiliza.cod_ccusto:  
    
      ASSIGN i-sequencia = i-sequencia + 10.
    
      IF FIRST-OF(tt-contabiliza.cod-estab) THEN DO:
          RUN pi-gera-contabilizacao(INPUT 'lote', 
                                     INPUT '',
                                     INPUT 0,
                                     INPUT 0,
                                     INPUT 0).        
            
          RUN pi-gera-contabilizacao(INPUT 'lancto', 
                                     INPUT '',
                                     INPUT 0,
                                     INPUT 0,
                                     INPUT 0).
      END.
      RUN pi-gera-contabilizacao(INPUT 'itens', 
                                 INPUT tt-contabiliza.movto,
                                 INPUT tt-contabiliza.cod_cta_ctbl,
                                 INPUT tt-contabiliza.cod_ccusto,
                                 INPUT tt-contabiliza.valor).
   END.

   RUN pi-gera-contabilizacao (INPUT 'executa',
                               INPUT '',
                               INPUT 0,
                               INPUT 0,
                               INPUT 0).

END. /* IF tt-param.tg-gera-contabil */

PROCEDURE pi-gera-contabilizacao:
    DEF INPUT PARAMETER p-table  AS CHAR.
    DEF INPUT PARAMETER p-movto  AS CHAR.
    DEF INPUT PARAMETER p-conta  LIKE tt-contabiliza.cod_cta_ctbl.
    DEF INPUT PARAMETER p-ccusto LIKE tt-contabiliza.cod_ccusto.
    DEF INPUT PARAMETER p-valor  LIKE tt-contabiliza.valor.
    
    CASE p-table:
        WHEN 'lote' THEN DO:
            CREATE tt_integr_lote_ctbl.
            ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul            = 'FGL' 
                   tt_integr_lote_ctbl.tta_num_lote_ctbl              = 1
                   tt_integr_lote_ctbl.tta_des_lote_ctbl              = 'CPV por Centro de Custo ' + STRING(month(tt-param.dt-periodo-fin),'99') + '/' + STRING(YEAR(tt-param.dt-periodo-fin))
                   tt_integr_lote_ctbl.tta_cod_empresa                = emsuni.empresa.cod_empresa
                   tt_integr_lote_ctbl.tta_dat_lote_ctbl              = tt-param.dt-periodo-fin
                   tt_integr_lote_ctbl.ttv_ind_erro_valid             = "NÆo"
                   tt_integr_lote_ctbl.tta_log_integr_ctbl_online     = YES. 
        END. /* Lote */

        WHEN 'lancto' THEN DO:
            CREATE tt_integr_lancto_ctbl.
            ASSIGN tt_integr_lancto_ctbl.tta_cod_cenar_ctbl           = 'Fiscal'
                   tt_integr_lancto_ctbl.tta_log_lancto_conver        = NO
                   tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo = NO 
                   tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl     = RECID(tt_integr_lote_ctbl)
                   tt_integr_lancto_ctbl.tta_num_lancto_ctbl          = i-sequencia
                   tt_integr_lancto_ctbl.ttv_ind_erro_valid           = "NÆo" 
                   tt_integr_lancto_ctbl.tta_dat_lancto_ctbl          = tt-param.dt-periodo-fin.
        END. /* Lancto */
    
        WHEN 'itens' THEN DO:        
            CREATE tt_integr_item_lancto_ctbl.
            ASSIGN tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl      = RECID(tt_integr_lancto_ctbl)
                   tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl         = i-sequencia
                   tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl       = p-movto  
                   tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl          = 'PCDOCOL'
                   tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                = p-conta  
                   tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto            = IF tt-contabiliza.cod_ccusto <> '' THEN plano_ccusto.cod_plano_ccusto ELSE ''
                   tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = p-ccusto
                   tt_integr_item_lancto_ctbl.tta_cod_estab                    = tt-contabiliza.cod-estab
                   tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = tt-contabiliza.unid-neg
                   tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = 'CPV por Centro de Custo ' + STRING(tt-param.dt-periodo-ini,'99/99/9999') + ' ¹ ' + STRING(tt-param.dt-periodo-fin,'99/99/9999')
                   tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = tt-contabiliza.cod_indic_econ
                   tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = tt-param.dt-periodo-fin
                   tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = p-valor
                   tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = i-sequencia
                   tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "NÆo" .

            CREATE tt_integr_aprop_lancto_ctbl.
            ASSIGN tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = tt-contabiliza.cod_finalid_econ
                   tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
                   tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
                   tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
                   tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
                   tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
                   tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
                   tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = tt-param.dt-periodo-fin
                   tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
                   tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "NÆo" 
                   tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
        END. /* Item */
    
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

            RUN pi-acompanhar IN h-acomp ('Gerando listagem de erros dos Lan‡amentos ...').

            FOR EACH tt_integr_ctbl_valid NO-LOCK:
                RUN pi_messages (INPUT "help",  INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                                 INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
                CREATE  tt-erro.
                ASSIGN  tt-erro.des_erro    = 'CR:' + STRING(tt_integr_ctbl_valid.ttv_num_mensagem) + '-' + 
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

        PUT REPLACE(SUBSTR(tt-erro.des_erro,93,92),CHR(10)," ") FORMAT "x(92)"   AT 01
            REPLACE(SUBSTR(tt-erro.des_erro,185,92),CHR(10)," ") FORMAT "x(92)"  AT 01
            REPLACE(SUBSTR(tt-erro.des_erro,277,92),CHR(10)," ") FORMAT "x(92)"  AT 01
            REPLACE(SUBSTR(tt-erro.des_erro,369,92),CHR(10)," ") FORMAT "x(92)"  AT 01.
    END.
END.



