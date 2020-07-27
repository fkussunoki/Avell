/******************************************************************************
**  apb701cax.P - UPC para Interface Usuario  Chamado pelo apb701ca.w 
** Autor: Reginaldo Leandro
*******************************************************************************/

{utp/ut-glob504.i}

DEF INPUT PARAM p-ind-event                     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object                    AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object                    AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame                     AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table                     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table                     AS RECID         NO-UNDO.

DEF VARIABLE c-objeto                           AS CHAR          NO-UNDO.
DEF VARIABLE h_frame                            AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR w-container           AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl        AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-objeto	            AS WIDGET-HANDLE.
DEF NEW GLOBAL SHARED VAR wgh-button            AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wgh-button-ok         AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR bt-ok-ax1             AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR cod_estab-ax          AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR v_cod_fornec_infor-ax AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR val_tit_ap-ax         AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wh-desc-fornec        AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wh-especie            AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wh-serie              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-titulo         AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wh-parcela            AS WIDGET-HANDLE .
DEF NEW GLOBAL SHARED VAR wh-refer              AS WIDGET-HANDLE .

DEF NEW GLOBAL SHARED VAR c-forn-apb704da       AS CHAR          NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-espec-apb704da      AS CHAR          NO-UNDO.



def temp-table tt_xml_input_1 no-undo 
    field tt_cod_label      as char    format "x(20)" 
    field tt_des_conteudo   as char    format "x(40)" 
    field tt_num_seq_1_xml  as integer format ">>9"
    field tt_num_seq_2_xml  as integer format ">>9".

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".


/* MESSAGE "Desenvolvendo EPC" SKIP                */
/*         p-ind-event                             */
/*         p-ind-object                            */
/*         p-wgh-object                            */
/*         p-cod-table                             */
/*         p-wgh-frame:HEIGHT SKIP                 */
/*         "-----Diomar-------" VIEW-AS ALERT-BOX. */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"),
                  p-wgh-object:PRIVATE-DATA, "~/").

IF p-ind-event  = 'display' AND
   p-ind-object = 'VIEWER'  AND
   c-objeto     = "HLP=5" THEN DO:
   ASSIGN c-forn-apb704da  = ""
          c-espec-apb704da = "".
   ASSIGN wh-objeto  = p-wgh-frame:FIRST-CHILD.
   DO WHILE VALID-HANDLE(wh-objeto):
       CASE wh-objeto:NAME:
           WHEN "cod_estab" THEN DO:
               ASSIGN cod_estab-ax = wh-objeto.
               CREATE BUTTON wgh-button
               ASSIGN frame       = p-wgh-frame
                      row         = 16.9  
                      column      = 45 
                      width       = 10
                      height      = 1
                      sensitive   = YES
                      visible     = YES
                      LABEL       = '&Pedidos'
                          triggers:
                                ON CHOOSE PERSISTENT RUN doepc/apb701cax1.p(INPUT '2').
                          end triggers.
           END.
           WHEN 'bt_ok' THEN DO:
               ASSIGN bt-ok-ax1           = wh-objeto
                      wh-objeto:SENSITIVE = NO
                      wh-objeto:VISIBLE   = NO.
               CREATE BUTTON wgh-button-ok
               ASSIGN frame       = p-wgh-frame
                      row         = 16.9  
                      column      = 3 
                      width       = 10
                      height      = 1
                      sensitive   = YES
                      visible     = YES
                      LABEL       = '&OK'
                          triggers:
                                ON CHOOSE PERSISTENT RUN doepc/apb701cax1.p(INPUT '3').
                          end triggers.
           END.
           WHEN 'v_cod_fornec_infor' THEN
               ASSIGN v_cod_fornec_infor-ax = wh-objeto.
           WHEN 'nom_abrev' THEN
               ASSIGN wh-desc-fornec = wh-objeto.
           WHEN 'cod_espec_docto' THEN
               ASSIGN wh-especie = wh-objeto.
           WHEN 'cod_ser_docto' THEN
               ASSIGN wh-serie = wh-objeto.
           WHEN 'val_tit_ap' THEN 
               ASSIGN val_tit_ap-ax = wh-objeto. 
          WHEN 'cod_tit_ap' THEN
              ASSIGN wh-cod-titulo = wh-objeto.
          WHEN 'cod_parcela' THEN
              ASSIGN wh-parcela = wh-objeto.
          WHEN 'cod_refer' THEN
              ASSIGN wh-refer = wh-objeto.
       END CASE.

       IF wh-objeto:TYPE = 'field-group' THEN 
           ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
       ELSE 
           ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
   END.
END.

IF p-ind-event = "Assign"
AND p-cod-table = "antecip_pef_pend" THEN DO:

 

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST param_integr_ems NO-LOCK 
        WHERE param_integr_ems.ind_param_integr_ems = "PERÖODOS CONTµBEIS 2.00" NO-ERROR.

    FIND FIRST trad_org_ext NO-LOCK WHERE trad_org_ext.cod_unid_organ_ext = param-global.empresa-prin
                                    AND   trad_org_ext.cod_matriz_trad_org_ext = param_integr_ems.des_contdo_param_integr_ems NO-ERROR.

    FIND FIRST antecip_pef_pend NO-LOCK WHERE recid(antecip_pef_pend) = p-row-table 
                                        AND   antecip_pef_pend.cod_espec_docto = "VC" NO-ERROR.

    

    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = antecip_pef_pend.cdn_fornecedor NO-ERROR.
        
    IF AVAIL antecip_pef_pend THEN DO:

        FIND FIRST cta_grp_fornec NO-LOCK WHERE cta_grp_fornec.cod_empresa      = trad_org_ext.cod_unid_organ
                                          AND   cta_grp_fornec.cod_espec_docto  = antecip_pef_pend.cod_espec_docto
                                          AND   cta_grp_fornec.cod_grp_fornec   = string(emitente.cod-gr-forn) 
                                          AND   cta_grp_fornec.ind_finalid_ctbl = "SALDO" 
                                          AND   cta_grp_fornec.dat_fim_valid   >= TODAY NO-ERROR.

        FIND FIRST aprop_ctbl_pend_ap NO-LOCK WHERE aprop_ctbl_pend_ap.cod_empresa = cta_grp_fornec.cod_empresa
                                              AND   aprop_ctbl_pend_ap.cod_estab   = antecip_pef_pend.cod_estab
                                              AND   aprop_ctbl_pend_ap.cod_refer   = antecip_pef_pend.cod_refer
                                              NO-ERROR.
                                                        

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Fun‡Æo"
               tt_xml_input_1.tt_des_conteudo    = "Verifica"
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Empresa"
               tt_xml_input_1.tt_des_conteudo    = param-global.empresa-prin
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Conta Cont bil"
               tt_xml_input_1.tt_des_conteudo    = STRING(cta_grp_fornec.cod_cta_ctbl)
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Estabelecimento"
               tt_xml_input_1.tt_des_conteudo    = antecip_pef_pend.cod_estab
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Data Movimentacao"
               tt_xml_input_1.tt_des_conteudo   = STRING(antecip_pef_pend.dat_emis_docto)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Finalidade Economica"
               tt_xml_input_1.tt_des_conteudo   = "0"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Valor Movimento"
               tt_xml_input_1.tt_des_conteudo   = STRING(antecip_pef_pend.val_tit_ap)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Quantidade Movimento"
               tt_xml_input_1.tt_des_conteudo   = "1"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Origem Movimento"
               tt_xml_input_1.tt_des_conteudo   = "92"
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.


        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "ID Movimento"
               tt_xml_input_1.tt_des_conteudo   = "Estab: " + antecip_pef_pend.cod_estab + " Esp: " + antecip_pef_pend.cod_espec_docto + " Serie: " + antecip_pef_pend.cod_ser_docto + " Titulo: " + antecip_pef_pend.cod_tit_ap + " Parcela: " + antecip_pef_pend.cod_parcela
                                                  + " Fornec: " + string(antecip_pef_pend.cdn_fornecedor)
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label      = "Unidade Negocio"
               tt_xml_input_1.tt_des_conteudo   = aprop_ctbl_pend_ap.cod_unid_negoc
               tt_xml_input_1.tt_num_seq_1_xml  = 1
               tt_xml_input_1.tt_num_seq_2_xml  = 0.

        create tt_xml_input_1.
        assign tt_xml_input_1.tt_cod_label       = "Centro Custo"
               tt_xml_input_1.tt_des_conteudo    = STRING(aprop_ctbl_pend_ap.cod_ccusto)
               tt_xml_input_1.tt_num_seq_1_xml   = 1
               tt_xml_input_1.tt_num_seq_2_xml   = 0.


        RUN prgfin/bgc/bgc700za.py (input 1,
                                    input table tt_xml_input_1,
                                    output table tt_log_erros) .  


        find first tt_log_erros no-lock no-error.
        if  avail tt_log_erros then do: 

                   RUN dop/MESSAGE.p (INPUT "Pedido Bloqueado!",
                                       INPUT "Motivo: " + tt_log_erros.ttv_des_ajuda).

                   RETURN 'nok'.

        END.


        ELSE DO:
        FIND FIRST tt_xml_input_1 WHERE tt_xml_input_1.tt_cod_label       = "Funcao" NO-ERROR.
        ASSIGN  tt_xml_input_1.tt_des_conteudo = "Atualiza".

        RUN prgfin/bgc/bgc700za.py (input 1,
                                    input table tt_xml_input_1,
                                    output table tt_log_erros) .  

        END.


    END.


END.



/* Grava c¢digo do fornecedor e da esp‚cie para buscar tipo de fluxo correto */
IF (p-ind-event  = 'CRIA_APROPRIAC' OR p-ind-event  = 'ALT_APROPRIAC') AND
    p-ind-object = 'VIEWER'                                           THEN DO:
    ASSIGN c-forn-apb704da  = v_cod_fornec_infor-ax:SCREEN-VALUE
           c-espec-apb704da = wh-especie:SCREEN-VALUE.
END. /* IF (p-ind-event  = 'CRIA_APROPRIAC' OR p-ind-event  = 'ALT_APROPRIAC') */

IF  p-ind-event  = 'VALIDATE' AND
    p-ind-object = 'VIEWER'  THEN DO:
END. /* IF p-ind-event  = 'VALIDATE' */

/* apb701cax.p */
