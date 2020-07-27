/*****************************************************************************
*****************************************************************************/

def var c-versao-prg as char initial " 5.12.16.100":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i api_demonst_ctbl_sped_recalc_sdo MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def shared temp-table tt_retorna_sdo_ctbl_demonst no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_cod_unid_organ_orig          as character format "x(3)" label "UO Origem" column-label "UO Origem"
    field ttv_ind_espec_sdo                as character format "X(20)"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Resultado" column-label "Apuraá∆o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo DB" column-label "Apuraá∆o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo CR" column-label "Apuraá∆o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field ttv_qtd_movto_ctbl               as decimal format "->>>>,>>9.9999" decimals 4
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    field tta_val_orcado                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Oráado" column-label "Valor Oráado"
    field tta_val_orcado_sdo               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Oráado" column-label "Saldo Oráado"
    field tta_qtd_orcado                   as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtdade Oráada" column-label "Qtdade Oráada"
    field tta_qtd_orcado_sdo               as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Saldo Quantidade" column-label "Saldo Quantidade"
    field ttv_rec_ret_sdo_ctbl             as recid format ">>>>>>9"
    field ttv_log_sdo_orcado_sint          as logical format "Sim/N∆o" initial no
    field ttv_val_perc_criter_distrib      as decimal format ">>9.99" decimals 6 initial 0 label "Percentual" column-label "Percentual"
    index tt_busca                        
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_busca_proj                   
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
          ttv_ind_espec_sdo                ascending
          tta_cod_unid_organ_orig          ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_cod_proj_financ              ascending
          tta_dat_sdo_ctbl                 ascending
          ttv_ind_espec_sdo                ascending
          tta_num_seq                      ascending
    index tt_rec                          
          ttv_rec_ret_sdo_ctbl             ascending
    index tt_sint                         
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    .



/********************** Temporary Table Definition End **********************/

/************************* Variable Definition Begin ************************/

def new global shared var v_dat_fim_sped
    as date
    format "99/99/9999":U
    no-undo.
def new global shared var v_dat_inic_sped
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_fim_mes                    as date            no-undo. /*local*/
def var v_val_sdo_ctbl_inic              as decimal         no-undo. /*local*/
def var v_val_tot_cr                     as decimal         no-undo. /*local*/
def var v_val_tot_cr_apurac              as decimal         no-undo. /*local*/
def var v_val_tot_db                     as decimal         no-undo. /*local*/
def var v_val_tot_db_apurac              as decimal         no-undo. /*local*/


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_demonst_ctbl_sped_recalc_sdo}


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('api_demonst_ctbl_sped_recalc_sdo':U, 'prgfin/mgl/escg0204zl.py':U, '5.12.16.100':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

assign v_dat_fim_mes = date(month(v_dat_fim_sped),25,year(v_dat_fim_sped)) + 10
       v_dat_fim_mes = date(month(v_dat_fim_mes),1,year(v_dat_fim_mes)) - 1.

/* Precisa recompor o saldo para o demonstrativo */
if v_dat_fim_sped < v_dat_fim_mes then do:

    for each tt_retorna_sdo_ctbl_demonst:
        assign v_val_tot_db = 0
               v_val_tot_cr = 0
               v_val_tot_db_apurac = 0
               v_val_tot_cr_apurac = 0.

        for each item_lancto_ctbl no-lock
           where item_lancto_ctbl.cod_empresa         = tt_retorna_sdo_ctbl_demonst.tta_cod_empresa
             and item_lancto_ctbl.cod_plano_cta_ctbl  = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_cta_ctbl
             and item_lancto_ctbl.cod_cta_ctbl        = tt_retorna_sdo_ctbl_demonst.tta_cod_cta_ctbl
             and item_lancto_ctbl.cod_plano_ccusto    = tt_retorna_sdo_ctbl_demonst.tta_cod_plano_ccusto
             and item_lancto_ctbl.cod_ccusto          = tt_retorna_sdo_ctbl_demonst.tta_cod_ccusto
             and item_lancto_ctbl.cod_estab           = tt_retorna_sdo_ctbl_demonst.tta_cod_estab
             and item_lancto_ctbl.cod_unid_negoc      = tt_retorna_sdo_ctbl_demonst.tta_cod_unid_negoc
             and item_lancto_ctbl.cod_proj_financ     = tt_retorna_sdo_ctbl_demonst.tta_cod_proj_financ
             and item_lancto_ctbl.dat_lancto_ctbl    >= v_dat_fim_sped + 1
             and item_lancto_ctbl.dat_lancto_ctbl    <= tt_retorna_sdo_ctbl_demonst.tta_dat_sdo_ctbl
             and (item_lancto_ctbl.cod_cenar_ctbl      = tt_retorna_sdo_ctbl_demonst.tta_cod_cenar_ctbl
               or item_lancto_ctbl.cod_cenar_ctbl      = '')
             and item_lancto_ctbl.ind_sit_lancto_ctbl = "Ctbz" /*l_contabilizado*/ :

            for each aprop_lancto_ctbl no-lock
               where aprop_lancto_ctbl.num_lote_ctbl       = item_lancto_ctbl.num_lote_ctbl
                 and aprop_lancto_ctbl.num_lancto_ctbl     = item_lancto_ctbl.num_lancto_ctbl
                 and aprop_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl
                 and aprop_lancto_ctbl.cod_finalid_econ    = tt_retorna_sdo_ctbl_demonst.tta_cod_finalid_econ
                 and aprop_lancto_ctbl.val_lancto_ctbl    <> 0:         

                 if item_lancto_ctbl.log_lancto_apurac_restdo then do:
                     if item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" /*l_db*/     then
                         assign v_val_tot_db_apurac = v_val_tot_db_apurac + aprop_lancto_ctbl.val_lancto_ctbl.
                     else
                         assign v_val_tot_cr_apurac = v_val_tot_cr_apurac + aprop_lancto_ctbl.val_lancto_ctbl.
                 end.
                 else do:
                     if item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" /*l_db*/     then
                         assign v_val_tot_db = v_val_tot_db + aprop_lancto_ctbl.val_lancto_ctbl.
                     else
                         assign v_val_tot_cr = v_val_tot_cr + aprop_lancto_ctbl.val_lancto_ctbl.
                 end.
             end.
        end.
        assign v_val_sdo_ctbl_inic = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim -
                                     tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db +
                                     tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr.

        assign tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db        = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db - v_val_tot_db
               tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr        = tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr - v_val_tot_cr
               tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db   = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_db - v_val_tot_db_apurac 
               tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr   = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_cr - v_val_tot_cr_apurac 
               tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo      = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo - 
                                                                        v_val_tot_db_apurac + 
                                                                        v_val_tot_cr_apurac
               tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum = tt_retorna_sdo_ctbl_demonst.tta_val_apurac_restdo_acum - 
                                                                        v_val_tot_db_apurac + 
                                                                        v_val_tot_cr_apurac.

        assign tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_fim = v_val_sdo_ctbl_inic + 
                                                                  tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_db - 
                                                                  tt_retorna_sdo_ctbl_demonst.tta_val_sdo_ctbl_cr.
    end.
end.



/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*****************  End of api_demonst_ctbl_sped_recalc_sdo *****************/
