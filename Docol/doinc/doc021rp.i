/*******************************************************************************
** Include: doc019rp.i3
**  Fun‡Æo: Contabilizar lote
*******************************************************************************/

DEF VAR r-rec_integr_lote_ctbl AS RECID                                 no-undo.
DEF VAR i-seq-lancto-ctbl      AS INT                                   NO-UNDO.
DEF VAR de-lancam              AS DEC                                   NO-UNDO.
DEF VAR c-erro                 AS CHAR                                  NO-UNDO.
DEF VAR c-historico            AS CHAR FORMAT "x(50)"                   NO-UNDO.
DEF VAR c-mensagem             AS CHAR FORMAT "x(60)" LABEL "Mensagem"  NO-UNDO.

{doinc/fgl900zh.i} /* temp-tables */

def new global shared var v_cod_empres_usuar       as character format "x(3)":U  label "Empresa"          column-label "Empresa"          no-undo.
DEF VAR cc-plano    AS CHAR NO-UNDO.
{doinc/dsg998.i} /* SugestÆo cc-plano conforme empresa */

RUN pi-acompanhar IN h-acomp ('Contabilizando Lote ' + c-lote-contab).

FIND FIRST lote_ctbl NO-LOCK
     WHERE lote_ctbl.cod_empresa       = trad_org_ext.cod_unid_organ
       AND lote_ctbl.ind_sit_lote_ctbl = "Ctbz"
       AND lote_ctbl.des_lote_ctbl     = c-lote-contab NO-ERROR.
IF AVAIL lote_ctbl THEN do:
    RUN MESSAGE.P ("Lote nÆo contabilizado!", "Lote j  est  integrado no EMS 5 com situa‡Æo " + lote_ctbl.ind_sit_lote_ctbl).
    DISP STREAM s_1
        c-lote-contab
        "Lote j  est  integrado no EMS 5 com situa‡Æo " + lote_ctbl.ind_sit_lote_ctbl @ c-mensagem with stream-io width 132.
   DOWN STREAM s_1.
END.

ELSE DO:

    CREATE tt_integr_lote_ctbl.
    ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul             = 'FGL'
           tt_integr_lote_ctbl.tta_num_lote_ctbl               = 1
           tt_integr_lote_ctbl.tta_des_lote_ctbl               = c-lote-contab
           tt_integr_lote_ctbl.tta_cod_empresa                 = trad_org_ext.cod_unid_organ
           tt_integr_lote_ctbl.tta_dat_lote_ctbl               = da-lote-contab
           tt_integr_lote_ctbl.ttv_ind_erro_valid              = "NÆo"
           tt_integr_lote_ctbl.tta_log_integr_ctbl_online      = YES.
    
    CREATE  tt_integr_lancto_ctbl.
    ASSIGN  tt_integr_lancto_ctbl.tta_cod_cenar_ctbl            = 'Fiscal'
            tt_integr_lancto_ctbl.tta_log_lancto_conver         = NO
            tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo  = NO
            tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl      = RECID(tt_integr_lote_ctbl)
            tt_integr_lancto_ctbl.tta_num_lancto_ctbl           = 10
            tt_integr_lancto_ctbl.ttv_ind_erro_valid            = "NÆo"
            tt_integr_lancto_ctbl.tta_dat_lancto_ctbl           = da-lote-contab.
    
    ASSIGN  r-rec_integr_lote_ctbl                              = RECID(tt_integr_lancto_ctbl)
            i-seq-lancto-ctbl                                   = 0.
             
    FOR EACH tt-contab.

       IF tt-contab.cdn-encargo = 99999 THEN
          ASSIGN c-historico = "Vlr ajuste encargos".
       ELSE DO:
          FIND FIRST rh-encargo no-lock
               WHERE rh-encargo.cdn-encargo = tt-contab.cdn-encargo NO-ERROR.
          ASSIGN c-historico = "Vlr ajuste encargos " + " referente "          + rh-encargo.des-encargo.
       END.

       ASSIGN de-lancam = tt-contab.debito - tt-contab.credito.

       IF de-lancam = 0 THEN NEXT.
         
       ASSIGN i-seq-lancto-ctbl = i-seq-lancto-ctbl + 10.
    
       CREATE tt_integr_item_lancto_ctbl.
       ASSIGN tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = r-rec_integr_lote_ctbl
              tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-seq-lancto-ctbl
              tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = (IF de-lancam > 0 THEN 'DB' ELSE 'CR')
              tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = "PCDOCOL"
              tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = tt-contab.c-ct-conta
              tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = IF tt-contab.c-ccusto = "" THEN ""
                                                                            ELSE cc-plano                 /*"CCDOCOL"*/
              tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = tt-contab.c-ccusto
              tt_integr_item_lancto_ctbl.tta_cod_estab                    = c-cod-estab /*"9"*/
              tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = trad_org_ext.cod_unid_organ /*Mario Fleith - Projeto Mekal*/
              tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = c-historico
              tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = "Real"
              tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = tt_integr_lancto_ctbl.tta_dat_lancto_ctbl
              tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = IF de-lancam < 0 THEN de-lancam * -1
                                                                            ELSE de-lancam
              tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = 0
              tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "NÆo".
            
       CREATE tt_integr_aprop_lancto_ctbl.
       ASSIGN tt_integr_aprop_lancto_ctbl.tta_cod_finalid_econ            = "Corrente"
              tt_integr_aprop_lancto_ctbl.tta_cod_unid_negoc              = tt_integr_item_lancto_ctbl.tta_cod_unid_negoc
              tt_integr_aprop_lancto_ctbl.tta_cod_plano_ccusto            = tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto
              tt_integr_aprop_lancto_ctbl.tta_cod_ccusto                  = tt_integr_item_lancto_ctbl.tta_cod_ccusto
              tt_integr_aprop_lancto_ctbl.tta_val_lancto_ctbl             = tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl
              tt_integr_aprop_lancto_ctbl.tta_num_id_aprop_lancto_ctbl    = 10
              tt_integr_aprop_lancto_ctbl.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl)
              tt_integr_aprop_lancto_ctbl.tta_dat_cotac_indic_econ        = tt_integr_lancto_ctbl.tta_dat_lancto_ctbl
              tt_integr_aprop_lancto_ctbl.tta_val_cotac_indic_econ        = 1
              tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "NÆo"
              tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
                 
    END. /* for each tt-contab */
          
    
    RUN pi-contabiliza.
    
    FIND FIRST tt_integr_ctbl_valid NO-LOCK NO-ERROR.
    IF AVAIL tt_integr_ctbl_valid THEN DO:
       run message.p ("Lote nÆo contabilizado!", "Lote com problemas, nao integrado no EMS 5. Verifique arquivo!").
       DISP STREAM s_1
            da-lote-contab LABEL "Data"
            c-lote-contab  LABEL "Lote"
            "Lote com problemas, nao integrado no EMS 5" @ c-mensagem with stream-io width 132.
       DOWN stream s_1.
    END.
    ELSE DO:
       FIND FIRST tt_integr_lote_ctbl NO-LOCK NO-ERROR.
       IF AVAIL tt_integr_lote_ctbl THEN DO:
          run message3.p ("Lote contabilizado!","Lote integrado no EMS 5").
          DISP STREAM s_1
               da-lote-contab LABEL "Data"
               c-lote-contab  LABEL "Lote"
               "Lote integrado no EMS 5" @ c-mensagem with stream-io width 132.
          DOWN stream s_1.
       END.
    END.
END.

FOR EACH tt-contab.
   DELETE tt-contab.
END.
      
FOR EACH tt_integr_lote_ctbl.
   DELETE tt_integr_lote_ctbl.
END.
FOR EACH tt_integr_lancto_ctbl.
   DELETE tt_integr_lancto_ctbl.
END.
FOR EACH tt_integr_item_lancto_ctbl.
   DELETE tt_integr_item_lancto_ctbl.
END.
FOR EACH tt_integr_aprop_lancto_ctbl.
   DELETE tt_integr_aprop_lancto_ctbl.
END.
FOR EACH tt_integr_ctbl_valid.
   DELETE tt_integr_ctbl_valid.
END.

PROCEDURE pi-contabiliza:

   RUN prgfin/fgl/fgl900zh.py (3               ,  "Aborta Tudo"        ,
                               YES             ,   NO                  ,
                               "Apropria‡Æo"   ,   "Com Erro"          ,
                               YES             ,   YES                 ).

   FOR EACH tt_integr_ctbl_valid NO-LOCK:
  
      RUN pi_messages (INPUT "help",  
                       INPUT tt_integr_ctbl_valid.ttv_num_mensagem,
                       INPUT SUBSTITUTE ("&1~&2~&3~&4~&5~&6~&7~&8~&9","EMSFIN")).
      ASSIGN  c-erro = RETURN-VALUE.
      DOWN WITH FRAME f-corpo.
      CASE tt_integr_ctbl_valid.ttv_ind_pos_erro:
         WHEN 'ITEM' THEN DO:
            FIND FIRST tt_integr_item_lancto_ctbl NO-LOCK
                 WHERE RECID(tt_integr_item_lancto_ctbl) = tt_integr_ctbl_valid.ttv_rec_integr_ctbl NO-ERROR.
            IF AVAIL tt_integr_item_lancto_ctbl THEN DO:
               ASSIGN  c-erro = c-erro + ':  SEQ:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl) +
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
                                ' SCP:' + STRING(tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart).
            END.
            PUT STREAM s_1
                substr(c-erro,  1,100) FORMAT "x(100)" AT 23
                SUBSTR(c-erro,101,100) FORMAT "x(100)" AT 23
                SUBSTR(c-erro,201,100) FORMAT "x(100)" AT 23
                SUBSTR(c-erro,301,100) FORMAT "x(100)" AT 23
                SUBSTR(c-erro,401,100) FORMAT "x(100)" AT 23.
         END.
      END CASE.
   END.
END.

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
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "nÆo encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.

END PROCEDURE.

/* doc021rp.i */

