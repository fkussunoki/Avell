/*******************************************************************************
** Include: doc019rp.i3
**  Funá∆o: Contabilizar lote
*******************************************************************************/

def temp-table tt-contab  field cdn-encargo as i format 99999
                          field especie     as c
                          field c-ct-contab as c
                          field c-ccusto    as c 
                          field lancamen    as log  format "DB/CR"
                          field valor       as de   format "->>,>>>,>>9.99"
                          index ch-prim  cdn-encargo
                                         especie
                                         c-ct-contab
                                         c-ccusto
                                         lancamen.

DEF VAR c-mensagem             AS CHAR FORMAT "x(60)" LABEL "Mensagem"  NO-UNDO.
def var i-encargo              as i                                     no-undo.
def var c-especie              as c                                     no-undo.
DEF VAR r-rec_integr_lote_ctbl AS RECID                                 no-undo.
DEF VAR i-seq-lancto-ctbl      AS INT                                   NO-UNDO.
DEF VAR c-erro                 AS CHAR                                  NO-UNDO.

{doinc/fgl900zh.i} /* temp-tables */

RUN pi-acompanhar IN h-acomp ('Contabilizando Lote ' + c-lote-contab).

for each tt-demonst.
   if not tt-demonst.tipo then /* Fechado */
      assign i-encargo = 99999
             c-especie = "Despesa".
   else                        /* Aberto */
      assign i-encargo = tt-demonst.cdn-encargo
             c-especie = tt-demonst.especie.
   find first tt-contab no-lock
        where tt-contab.cdn-encargo = i-encargo
          and tt-contab.especie     = c-especie
          and tt-contab.c-ct-contab = tt-demonst.c-ct-contab
          and tt-contab.c-ccusto    = tt-demonst.c-ccusto
          and tt-contab.lancamen    = tt-demonst.lancamen no-error.
                  
   if not avail tt-contab then do:
      create tt-contab.
      assign tt-contab.cdn-encargo = i-encargo
             tt-contab.especie     = c-especie
             tt-contab.c-ct-contab = tt-demonst.c-ct-contab
             tt-contab.c-ccusto    = tt-demonst.c-ccusto
             tt-contab.lancamen    = tt-demonst.lancamen.
   end.            
   assign tt-contab.valor = tt-contab.valor + tt-demonst.valor.
end.     
   
FIND FIRST lote_ctbl NO-LOCK
     WHERE lote_ctbl.cod_empresa       = trad_org_ext.cod_unid_organ
       AND lote_ctbl.ind_sit_lote_ctbl = "Ctbz"
       AND lote_ctbl.des_lote_ctbl     = c-lote-contab NO-ERROR.
IF AVAIL lote_ctbl THEN do:
    RUN MESSAGE.P ("Lote n∆o contabilizado!", "Lote j† est† integrado no EMS 5 com situaá∆o " + lote_ctbl.ind_sit_lote_ctbl).
    DISP STREAM s_1
        c-lote-contab
        "Lote j† est† integrado no EMS 5 com situaá∆o " + lote_ctbl.ind_sit_lote_ctbl @ c-mensagem with stream-io width 132.
   DOWN STREAM s_1.
END.

ELSE DO:

    CREATE tt_integr_lote_ctbl.
    ASSIGN tt_integr_lote_ctbl.tta_cod_modul_dtsul             = 'FGL'
           tt_integr_lote_ctbl.tta_num_lote_ctbl               = 1
           tt_integr_lote_ctbl.tta_des_lote_ctbl               = c-lote-contab
           tt_integr_lote_ctbl.tta_cod_empresa                 = trad_org_ext.cod_unid_organ
           tt_integr_lote_ctbl.tta_dat_lote_ctbl               = da-corte
           tt_integr_lote_ctbl.ttv_ind_erro_valid              = "N∆o"
           tt_integr_lote_ctbl.tta_log_integr_ctbl_online      = YES.
    
    CREATE  tt_integr_lancto_ctbl.
    ASSIGN  tt_integr_lancto_ctbl.tta_cod_cenar_ctbl            = 'Fiscal'
            tt_integr_lancto_ctbl.tta_log_lancto_conver         = NO
            tt_integr_lancto_ctbl.tta_log_lancto_apurac_restdo  = NO
            tt_integr_lancto_ctbl.ttv_rec_integr_lote_ctbl      = RECID(tt_integr_lote_ctbl)
            tt_integr_lancto_ctbl.tta_num_lancto_ctbl           = 10
            tt_integr_lancto_ctbl.ttv_ind_erro_valid            = "N∆o"
            tt_integr_lancto_ctbl.tta_dat_lancto_ctbl           = da-corte.
    
    ASSIGN  r-rec_integr_lote_ctbl                              = RECID(tt_integr_lancto_ctbl)
            i-seq-lancto-ctbl                                   = 0.
             
    for each tt-contab.
       if tt-contab.cdn-encargo = 99999 then
          assign c-historico = "Vlr ref encargos "    + string(i-mes,"99")     + "/" + string(i-ano,"9999").
       else do:
          find first rh-encargo no-lock
               where rh-encargo.cdn-encargo = tt-contab.cdn-encargo no-error.
          assign c-historico = tt-contab.especie     + " referente "          + rh-encargo.des-encargo + " " + string(i-mes,"99")     + "/" + string(i-ano,"9999").
       end.
          
       ASSIGN i-seq-lancto-ctbl = i-seq-lancto-ctbl + 10.
    
       CREATE tt_integr_item_lancto_ctbl.
       ASSIGN tt_integr_item_lancto_ctbl.ttv_rec_integr_lancto_ctbl       = r-rec_integr_lote_ctbl
              tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl          = i-seq-lancto-ctbl
              tt_integr_item_lancto_ctbl.tta_ind_natur_lancto_ctbl        = (IF tt-contab.lancamen THEN 'DB' ELSE 'CR')
              tt_integr_item_lancto_ctbl.tta_cod_plano_cta_ctbl           = "PCDOCOL"
              tt_integr_item_lancto_ctbl.tta_cod_cta_ctbl                 = tt-contab.c-ct-contab
              tt_integr_item_lancto_ctbl.tta_cod_plano_ccusto             = IF tt-contab.c-ccusto = "" THEN "" ELSE cc-plano
              tt_integr_item_lancto_ctbl.tta_cod_ccusto                   = tt-contab.c-ccusto
              tt_integr_item_lancto_ctbl.tta_cod_estab                    = "9"
              tt_integr_item_lancto_ctbl.tta_cod_unid_negoc               = trad_org_ext.cod_unid_organ /*Mario Fleith - Projeto Mekal*/
              tt_integr_item_lancto_ctbl.tta_des_histor_lancto_ctbl       = c-historico
              tt_integr_item_lancto_ctbl.tta_cod_indic_econ               = "Real"
              tt_integr_item_lancto_ctbl.tta_dat_lancto_ctbl              = tt_integr_lancto_ctbl.tta_dat_lancto_ctbl
              tt_integr_item_lancto_ctbl.tta_val_lancto_ctbl              = tt-contab.valor
              tt_integr_item_lancto_ctbl.tta_num_seq_lancto_ctbl_cpart    = 0
              tt_integr_item_lancto_ctbl.ttv_ind_erro_valid               = "N∆o".
            
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
              tt_integr_aprop_lancto_ctbl.ttv_ind_erro_valid              = "N∆o"
              tt_integr_aprop_lancto_ctbl.tta_ind_orig_val_lancto_ctbl    = "Informado".
                 
    END. /* for each tt-contab */
          
    
    RUN pi-contabiliza.
    
    FIND FIRST tt_integr_ctbl_valid NO-LOCK NO-ERROR.
    IF AVAIL tt_integr_ctbl_valid THEN DO:
       run message.p ("Lote n∆o contabilizado!", "Lote com problemas, nao integrado no EMS 5. Verifique arquivo!").
       DISP STREAM s_1
            da-corte label "Data"
            c-lote-contab
            "Lote com problemas, nao integrado no EMS 5" @ c-mensagem with stream-io width 132.
       DOWN stream s_1.
    END.
    ELSE DO:
       FIND FIRST tt_integr_lote_ctbl NO-LOCK NO-ERROR.
       IF AVAIL tt_integr_lote_ctbl THEN DO:
          run message3.p ("Lote contabilizado!","Lote integrado no EMS 5").
          DISP STREAM s_1
               da-corte label "Data"
               c-lote-contab
               "Lote integrado no EMS 5" @ c-mensagem with stream-io width 132.
          DOWN stream s_1.
       END.
    END.
END.

FOR EACH tt-demonst:
   DELETE tt-demonst.
END.
      
FOR EACH tt-contab.
   DELETE tt-contab.
END.
      
FOR EACH tt-diret.
   DELETE tt-diret.
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
                               "Apropriaá∆o"   ,   "Com Erro"          ,
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
        RETURN "Mensagem nr. " + STRING(i_msg) + "!!! Programa Mensagem" + c_prg_msg + "n∆o encontrado.".
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action, INPUT c_param).

    RETURN RETURN-VALUE.

END PROCEDURE.

/* doc019rp.i3 */
