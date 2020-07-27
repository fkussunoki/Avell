/*****************************************************************************
*****************************************************************************/

def var c-versao-prg as char initial " 5.12.16.100":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  api_demonst_ctbl_bgc MGL}
&ENDIF

{include/i_fcldef.i}

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.

/************************ Parameter Definition Begin ************************/

def Input param p_num_vers_integr_api
    as integer
    format ">>>>,>>9"
    no-undo.
def Input param p_cod_demonst_ctbl
    as character
    format "x(8)"
    no-undo.
def Input param p_cod_padr_col_demonst_ctbl
    as character
    format "x(8)"
    no-undo.
def Input param p_cod_cenar_orctario
    as character
    format "x(8)"
    no-undo.
def Input param p_cod_unid_orctaria
    as character
    format "x(8)"
    no-undo.
def Input param p_num_seq_orcto_ctbl
    as integer
    format ">>>>>>>>9"
    no-undo.
def Input param p_cod_vers_orcto_ctbl
    as character
    format "x(10)"
    no-undo.
def Input param p_num_period_ctbl
    as integer
    format ">99"
    no-undo.
def Input param p_cod_exerc_ctbl
    as character
    format "9999"
    no-undo.


/************************* Parameter Definition End *************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cenar_ctbl
    as character
    format "x(8)":U
    label "Cen†rio Cont†bil"
    column-label "Cen†rio Cont†bil"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_proj_financ_000
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def var v_cod_proj_financ_999
    as character
    format "x(20)":U
    label "Projeto"
    column-label "Projeto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/
/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i api_demonst_ctbl_bgc}


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
    run pi_version_extract ('api_demonst_ctbl_bgc':U, 'prgfin/mgl/escg0204zc.py':U, '5.12.16.100':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /*l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /*l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.

/* End_Include: i_declara_SetEntryField */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = '@(&program)' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = '@(&program)'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


do transaction:
    /* --- Cria preferàncias do demonstrativo para inicializar na tela ---*/
    find last prefer_demonst_ctbl exclusive-lock
        where prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
          and prefer_demonst_ctbl.cod_demonst_ctbl          = p_cod_demonst_ctbl
          and prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = p_cod_padr_col_demonst_ctbl no-error.
    if  not avail prefer_demonst_ctbl
    then do:
        create prefer_demonst_ctbl.
        assign prefer_demonst_ctbl.cod_usuario               = v_cod_usuar_corren
               prefer_demonst_ctbl.cod_demonst_ctbl          = p_cod_demonst_ctbl
               prefer_demonst_ctbl.cod_padr_col_demonst_ctbl = p_cod_padr_col_demonst_ctbl.

               &if '{&emsfin_version}' >= '5.07' &then
               assign prefer_demonst_ctbl.log_impr_col_sem_sdo = yes.
               &else
               assign prefer_demonst_ctbl.cod_livre_1 = SetEntryField(16, prefer_demonst_ctbl.cod_livre_1, chr(10), "yes" /*l_yes*/ ).
               &endif
    end /* if */.

    assign prefer_demonst_ctbl.num_period_ctbl            = p_num_period_ctbl
           prefer_demonst_ctbl.cod_exerc_ctbl             = p_cod_exerc_ctbl
           prefer_demonst_ctbl.val_fator_div_demonst_ctbl = 1
           prefer_demonst_ctbl.log_consid_apurac_restdo   = no
           prefer_demonst_ctbl.log_acum_cta_ctbl_sint     = yes
           prefer_demonst_ctbl.log_impr_cta_sem_sdo       = yes
           prefer_demonst_ctbl.dat_ult_atualiz            = today
           prefer_demonst_ctbl.hra_ult_atualiz            = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),':','').

    find usuar_mestre no-lock
        where usuar_mestre.cod_usuario = v_cod_usuar_corren no-error.
    if avail usuar_mestre then
        assign prefer_demonst_ctbl.cod_idioma = usuar_mestre.cod_idiom_orig.

    &if '{&emsfin_dbtype}' <> 'progress' &then 
        VALIDATE prefer_demonst_ctbl.
    &endif

    /* --- Criaá∆o de Conjto de Preferàncias ---*/
    conjto_block:
    for
        each col_demonst_ctbl no-lock
           where col_demonst_ctbl.cod_padr_col_demonst_ctbl = p_cod_padr_col_demonst_ctbl
           break by col_demonst_ctbl.num_conjto_param_ctbl:
        if  first-of(col_demonst_ctbl.num_conjto_param_ctbl)
        then do:
           run pi_cria_conjto_prefer_demonst (Input col_demonst_ctbl.num_conjto_param_ctbl) /*pi_cria_conjto_prefer_demonst*/.
        end.
    end.
end.

/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_cria_conjto_prefer_demonst
** Descricao.............: pi_cria_conjto_prefer_demonst
** Criado por............: src388
** Criado em.............: 21/08/2001 15:06:50
** Alterado por..........: Dalpra
** Alterado em...........: 03/01/2002 11:36:06
*****************************************************************************/
PROCEDURE pi_cria_conjto_prefer_demonst:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_conjto_param_ctbl
        as integer
        format ">9"
        no-undo.


    /************************* Parameter Definition End *************************/

    find conjto_prefer_demonst exclusive-lock
       where conjto_prefer_demonst.cod_usuario               = v_cod_usuar_corren
         and conjto_prefer_demonst.cod_demonst_ctbl          = prefer_demonst_ctbl.cod_demonst_ctbl
         and conjto_prefer_demonst.cod_padr_col_demonst_ctbl = prefer_demonst_ctbl.cod_padr_col_demonst_ctbl
         and conjto_prefer_demonst.num_conjto_param_ctbl     = p_num_conjto_param_ctbl no-error.
    if  not avail conjto_prefer_demonst
    then do:
        create conjto_prefer_demonst.
        assign conjto_prefer_demonst.cod_usuario      = v_cod_usuar_corren
               conjto_prefer_demonst.cod_demonst_ctbl = p_cod_demonst_ctbl
               conjto_prefer_demonst.cod_padr_col_demonst_ctbl = p_cod_padr_col_demonst_ctbl
               conjto_prefer_demonst.num_conjto_param_ctbl     = p_num_conjto_param_ctbl.
        run pi_retornar_cenar_ctbl_fisc (Input v_cod_empres_usuar,
                                         Input today,
                                         output v_cod_cenar_ctbl) /*pi_retornar_cenar_ctbl_fisc*/.
        assign conjto_prefer_demonst.cod_cenar_ctbl = v_cod_cenar_ctbl.

        find emsuni.pais no-lock
             where pais.cod_pais = v_cod_pais_empres_usuar /*cl_cod_pais_corrente of pais*/ no-error.
        if  avail pais
        then do:
            assign conjto_prefer_demonst.cod_finalid_econ = pais.cod_finalid_econ_pais
                   conjto_prefer_demonst.cod_finalid_econ_apres = pais.cod_finalid_econ_pais.
        end.

        assign conjto_prefer_demonst.dat_cotac_indic_econ = today
               conjto_prefer_demonst.cod_unid_organ_inic  = "" /*l_null*/ 
               conjto_prefer_demonst.cod_unid_organ_fim   = "zzz" /*l_zzz*/ 
               conjto_prefer_demonst.cod_estab_inic       = "" /*l_null*/ 
               conjto_prefer_demonst.cod_estab_fim        = "zzz" /*l_zzz*/ 
               conjto_prefer_demonst.cod_unid_negoc_inic  = "" /*l_null*/ 
               conjto_prefer_demonst.cod_unid_negoc_fim   = "zzz" /*l_zzz*/ .

        find first demonst_ctbl no-lock
            where demonst_ctbl.cod_demonst_ctbl = prefer_demonst_ctbl.cod_demonst_ctbl no-error.
        find plano_cta_ctbl no-lock
            where plano_cta_ctbl.cod_plano_cta_ctbl = demonst_ctbl.cod_plano_cta_ctbl no-error.
        if  avail plano_cta_ctbl
        then do:
            run pi_retornar_valores_iniciais_prefer (Input plano_cta_ctbl.cod_format_cta_ctbl,
                                                     Input "Cta Ctbl" /*l_cta_ctbl*/,
                                                     output v_cod_initial,
                                                     output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
            assign conjto_prefer_demonst.cod_cta_ctbl_inic         = v_cod_initial
                   conjto_prefer_demonst.cod_cta_ctbl_fim          = v_cod_final
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_pfixa = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl))
                   conjto_prefer_demonst.cod_cta_ctbl_prefer_excec = fill("#",length(plano_cta_ctbl.cod_format_cta_ctbl)).
        end.
        &if '{&emsfin_version}' > '5.05' &then
            find first compos_demonst_ctbl no-lock
                where  compos_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl
                  and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl
            then do:
                find first plano_ccusto no-lock
                    where plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                if  avail plano_ccusto
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                             Input "CCusto" /*l_ccusto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign conjto_prefer_demonst.cod_ccusto_inic = v_cod_initial
                           conjto_prefer_demonst.cod_ccusto_fim  = v_cod_final
                           conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                           conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
                end.
            end.
        &endif

        assign conjto_prefer_demonst.cod_unid_organ_prefer_inic  = "" /*l_null*/ 
               conjto_prefer_demonst.cod_unid_organ_prefer_fim   = "zzz" /*l_zzz*/ .

        &if '{&emsfin_version}' = '5.05' &then
            find tab_livre_emsfin
                where tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                and   tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + p_cod_padr_col_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_1_idx_tab = p_cod_demonst_ctbl
                and   tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl)
                no-error.
            if  not avail tab_livre_emsfin
            then do:
                create tab_livre_emsfin.
                assign tab_livre_emsfin.cod_modul_dtsul      = "MGL" /*l_mgl*/ 
                       tab_livre_emsfin.cod_tab_dic_dtsul    = v_cod_usuar_corren + chr(10) + p_cod_padr_col_demonst_ctbl
                       tab_livre_emsfin.cod_compon_1_idx_tab = p_cod_demonst_ctbl
                       tab_livre_emsfin.cod_compon_2_idx_tab = string(p_num_conjto_param_ctbl).

                find last param_geral_ems no-lock no-error.
                if  avail param_geral_ems
                then do:
                    run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                             Input "Projeto" /*l_projeto*/,
                                                             output v_cod_initial,
                                                             output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                    assign tab_livre_emsfin.cod_livre_1 = v_cod_initial + chr(10) +
                                                          v_cod_final   + chr(10) +
                                                          fill("#",length(param_geral_ems.cod_format_proj_financ)) + chr(10) +
                                                          fill("#",length(param_geral_ems.cod_format_proj_financ)).
                end.

                find first compos_demonst_ctbl no-lock
                    where  compos_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl
                      and  compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
                if  avail compos_demonst_ctbl
                then do:
                    find first plano_ccusto no-lock
                        where plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
                    if  avail plano_ccusto
                    then do:
                        run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                                 Input "CCusto" /*l_ccusto*/,
                                                                 output v_cod_initial,
                                                                 output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                        assign tab_livre_emsfin.cod_livre_2 = v_cod_initial + chr(10) +
                                                              v_cod_final   + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)) + chr(10) +
                                                              fill("#",length(plano_ccusto.cod_format_ccusto)).
                    end.
                    else do:
                        assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                              "" + chr(10) +
                                                              "" + chr(10) +
                                                              "".
                    end.
                end.
                else do:
                    assign tab_livre_emsfin.cod_livre_2 = "" + chr(10) +
                                                          "" + chr(10) +
                                                          "" + chr(10) +
                                                          "".
                end.    
                &if '{&emsfin_dbtype}' <> 'progress' &then 
                    VALIDATE tab_livre_emsfin.
                &endif
            end.
            assign conjto_prefer_demonst.cod_livre_1 = p_cod_unid_orctaria          + chr(10) +
                                                       string(p_num_seq_orcto_ctbl) + chr(10) +
                                                       "" /*l_null*/                    + chr(10) +
                                                       "" /*l_null*/ .
        &else
            find last param_geral_ems no-lock no-error.
            if  avail param_geral_ems
            then do:
                run pi_retornar_valores_iniciais_prefer (Input param_geral_ems.cod_format_proj_financ,
                                                         Input "Projeto" /*l_projeto*/,
                                                         output v_cod_initial,
                                                         output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.

                assign conjto_prefer_demonst.cod_proj_financ_inicial = v_cod_initial
                       conjto_prefer_demonst.cod_proj_financ_fim     = v_cod_final
                       conjto_prefer_demonst.cod_proj_financ_pfixa   = fill("#",length(param_geral_ems.cod_format_proj_financ))
                       conjto_prefer_demonst.cod_proj_financ_excec   = fill("#",length(param_geral_ems.cod_format_proj_financ)).
            end.

            find first compos_demonst_ctbl no-lock
                 where compos_demonst_ctbl.cod_demonst_ctbl = p_cod_demonst_ctbl
                 and   compos_demonst_ctbl.cod_plano_ccusto <> "" no-error.
            if  avail compos_demonst_ctbl
            then do:
               find first plano_ccusto no-lock
                    where plano_ccusto.cod_plano_ccusto = compos_demonst_ctbl.cod_plano_ccusto no-error.
               if  avail plano_ccusto
               then do:
                  run pi_retornar_valores_iniciais_prefer (Input plano_ccusto.cod_format_ccusto,
                                                           Input "CCusto" /*l_ccusto*/,
                                                           output v_cod_initial,
                                                           output v_cod_final) /*pi_retornar_valores_iniciais_prefer*/.
                  assign conjto_prefer_demonst.cod_ccusto_inic  = v_cod_initial
                         conjto_prefer_demonst.cod_ccusto_fim   = v_cod_final
                         conjto_prefer_demonst.cod_ccusto_pfixa = fill("#",length(plano_ccusto.cod_format_ccusto))
                         conjto_prefer_demonst.cod_ccusto_excec = fill("#",length(plano_ccusto.cod_format_ccusto)).
               end.
            end.
            assign conjto_prefer_demonst.cod_unid_orctaria  = p_cod_unid_orctaria
                   conjto_prefer_demonst.num_seq_orcto_ctbl = p_num_seq_orcto_ctbl.
        &endif.
    end.

    assign conjto_prefer_demonst.cod_cenar_orctario  = p_cod_cenar_orctario
           conjto_prefer_demonst.cod_vers_orcto_ctbl = p_cod_vers_orcto_ctbl.

    &if '{&emsfin_dbtype}' <> 'progress' &then 
        VALIDATE conjto_prefer_demonst.
    &endif

END PROCEDURE. /* pi_cria_conjto_prefer_demonst */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_valores_iniciais_prefer
** Descricao.............: pi_retornar_valores_iniciais_prefer
** Criado por............: src388
** Criado em.............: 11/06/2001 11:40:43
** Alterado por..........: fut35059
** Alterado em...........: 30/01/2006 14:29:47
*****************************************************************************/
PROCEDURE pi_retornar_valores_iniciais_prefer:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_campo
        as character
        format "x(25)"
        no-undo.
    def output param p_cod_initial
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_final
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_count_proj                 as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_count_proj = 1
           v_cod_proj_financ_000 = ""
           v_cod_proj_financ_999 = ""
           p_cod_initial = ""
           p_cod_final = "".

    do while v_num_count_proj <= length(p_cod_format):
        if  substring(p_cod_format,v_num_count_proj,1) <> "-"
        and substring(p_cod_format,v_num_count_proj,1) <> "."
        then do:
            if  substring(p_cod_format,v_num_count_proj,1) = "9"
            then do:
                assign v_cod_proj_financ_000 = v_cod_proj_financ_000 + "0"
                       v_cod_proj_financ_999 = v_cod_proj_financ_999 + "9".
            end.
            else do:
                if  substring(p_cod_format,v_num_count_proj,1) = "x" /*l_x*/  
                then do:
                    if p_cod_campo <> "Projeto" /*l_projeto*/  then
                        assign v_cod_proj_financ_000 = v_cod_proj_financ_000 + "0".

                    assign v_cod_proj_financ_999 = v_cod_proj_financ_999 + "Z" /*l_z*/ .
                end.
            end.
        end.
        assign v_num_count_proj = v_num_count_proj + 1.
    end.

    assign p_cod_initial = v_cod_proj_financ_000
           p_cod_final   = v_cod_proj_financ_999.
END PROCEDURE. /* pi_retornar_valores_iniciais_prefer */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_cenar_ctbl_fisc
** Descricao.............: pi_retornar_cenar_ctbl_fisc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Rovina
** Alterado em...........: 13/11/1995 22:07:23
*****************************************************************************/
PROCEDURE pi_retornar_cenar_ctbl_fisc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first utiliz_cenar_ctbl no-lock
         where utiliz_cenar_ctbl.cod_empresa = p_cod_empresa
           and utiliz_cenar_ctbl.log_cenar_fisc = yes /*cl_retorna_fisc of utiliz_cenar_ctbl*/ no-error.
    if  avail utiliz_cenar_ctbl
    then do:
        if  p_dat_refer_ent = ? or (utiliz_cenar_ctbl.dat_inic_valid <= p_dat_refer_ent and
                                    utiliz_cenar_ctbl.dat_fim_valid >= p_dat_refer_ent)
        then do:
            assign p_cod_cenar_ctbl = utiliz_cenar_ctbl.cod_cenar_ctbl.
        end /* if */.
        else do:
            assign p_cod_cenar_ctbl = "".
        end /* else */.
    end /* if */.
    else do:
        assign p_cod_cenar_ctbl = "".
    end /* else */.
END PROCEDURE. /* pi_retornar_cenar_ctbl_fisc */
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
/***********************  End of api_demonst_ctbl_bgc ***********************/
