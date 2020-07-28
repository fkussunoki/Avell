/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_bem_pat
** Descricao.............: Funá‰es Bem
** Versao................:  1.00.00.040
** Procedimento..........: tar_desmembramento_bem_pat
** Programa Original..........: prgfin/fas/fas703zc.p
*****************************************************************************/

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.040":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.040[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

{include/i_fcldef.i}
{include/i_trddef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_bem_pat FAS}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=2":U.
/*************************************  *************************************/

&if "{&emsfin_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSFIN")) /*msg_5884*/.
&elseif "{&emsfin_version}" < "1.00" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "FNC_BEM_PAT","~~EMSFIN", "~~{~&emsfin_version}", "~~1.00")) /*msg_5009*/.
&else

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_baixa_bem_pat no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_baixado                  as decimal extent 12 format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    index tt_id                            is primary unique
          tta_num_id_bem_pat               ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
    .

def temp-table tt_baixa_seq_incorp_bem_pat no-undo
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_baixado                  as decimal extent 12 format "->>,>>>,>>>,>>9.99" decimals 2 initial 0
    index tt_id                            is primary unique
          tta_num_seq_incorp_bem_pat       ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
    .

def shared temp-table tt_desmembrto_bem_pat        
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_perc_movto_bem_pat       as decimal format "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_respons           as Character format "x(11)" label "CCusto Responsab" column-label "CCusto Responsab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field ttv_log_busca_orig               as logical format "Sim/N∆o" initial no label "Busca da Origem" column-label "Busca da Origem"
    index tt_desmembrto_bem_pat_id         is primary unique
          tta_cod_empresa                  ascending
          tta_cod_cta_pat                  ascending
          tta_num_bem_pat                  ascending
          tta_num_seq_bem_pat              ascending
    .

def temp-table tt_impl_bem_pat no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_acerto                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_idi_campo                    as Integer format "9" initial 0
    field ttv_idi_acerto                   as Integer format "9" initial 0
    index tt_id                            is primary unique
          ttv_idi_campo                    ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
          ttv_idi_acerto                   ascending
          tta_num_id_bem_pat               ascending
    .

def temp-table tt_impl_seq_incorp_bem_pat no-undo
    field tta_num_seq_incorp_bem_pat       as integer format ">>,>>>>,>>9" initial 0 label "Sequància Incorp" column-label "Sequància Incorp"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_acerto                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field ttv_idi_campo                    as Integer format "9" initial 0
    field ttv_idi_acerto                   as Integer format "9" initial 0
    index tt_id                            is primary unique
          ttv_idi_campo                    ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
          ttv_val_acerto                   ascending
          tta_num_seq_incorp_bem_pat       ascending
    .

def temp-table tt_verifica_diferenca_desmem no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_original                 as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_dpr_val_origin           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Valor Original" column-label "Dpr Valor Original"
    field tta_val_dpr_cm                   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Correá∆o Monet" column-label "Dpr Correá∆o Monet"
    field tta_val_dpr_incevda_val_origin   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Depreciaá∆o Incentiv" column-label "Depreciaá∆o Incentiv"
    field tta_val_dpr_incevda_cm           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Dpr Incentiv CM" column-label "Dpr Incentiv CM"
    field tta_val_cm_dpr                   as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet Dpr" column-label "Correá∆o Monet Dpr"
    field tta_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_cm_dpr_incevda           as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "CM Dpr Incentivada" column-label "CM Dpr Incentivada"
    field tta_val_dpr_val_origin_amort     as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizaá∆o VO" column-label "Amortizaá∆o VO"
    field tta_val_dpr_cm_amort             as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizaá∆o CM" column-label "Amortizaá∆o CM"
    field tta_val_amort_incevda_origin     as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Amortizacao Incentiv" column-label "Amortizacao Incentiv"
    field tta_cod_tip_calc                 as character format "x(7)" label "Tipo C†lculo" column-label "Tipo C†lculo"
    field tta_ind_tip_calc                 as character format "X(20)" initial "Depreciaá∆o" label "Tipo" column-label "Tipo"
    .



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_dat_desmbrto
    as date
    format "99/99/9999"
    no-undo.
def param buffer p_bem_pat
    for bem_pat.
def Input param table 
    for tt_verifica_diferenca_desmem.


/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "1.00" &then
def buffer b_bem_pat
    for bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_destino
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_movto_bem_pat_orig
    for movto_bem_pat.
&endif
&if "{&emsfin_version}" >= "1.00" &then
def buffer b_sdo_bem_pat_cust
    for sdo_bem_pat.
&endif


/*************************** Buffer Definition End **************************/

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
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
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
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
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
def var v_ind_trans_calc_bem_pat
    as character
    format "X(18)":U
    initial "Implantaá∆o" /*l_implantacao*/
    view-as combo-box sort
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Implantaá∆o","Implantaá∆o","Baixa","Baixa","Correá∆o Monet†ria","Correá∆o Monet†ria","Depreciaá∆o","Depreciaá∆o","Amortizaá∆o","Amortizaá∆o","Apropriaá∆o","Apropriaá∆o"
    &else
    list-items "Implantaá∆o","Baixa","Correá∆o Monet†ria","Depreciaá∆o","Amortizaá∆o","Apropriaá∆o"
    &endif
     /*l_implantacao*/ /*l_baixa*/ /*l_correcao_monetaria*/ /*l_depreciacao*/ /*l_amortizacao*/ /*l_apropriacao*/
    inner-lines 7
    bgcolor 15 font 2
    label "Tipo Transaá∆o"
    column-label "Tipo Transaá∆o"
    no-undo.
def var v_log_dif
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_id_bem_pat
    as integer
    format ">>,>>>,>>9":U
    initial 0
    label "Ident Bem"
    column-label "Ident Bem"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_incorp_bem_pat
    as integer
    format ">>>>,>>9":U
    initial 0
    label "Seq Incorp Bem"
    column-label "Seq Incorp Bem"
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_obj
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_acerto
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cm
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    label "Correá∆o Monet†ria"
    column-label "Correá∆o Monet†ria"
    no-undo.
def var v_val_cm_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cm_aux
    as decimal
    format "->>>,>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cm_dpr
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    label "CM Dpr Acumulado"
    column-label "CM Dpr Acumulado"
    no-undo.
def var v_val_cm_dpr_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_cm_dpr_aux
    as decimal
    format "->>>,>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_dpr_cm
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    label "Dpr Correá∆o Monet"
    column-label "Dpr Correá∆o Monet"
    no-undo.
def var v_val_dpr_cm_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_dpr_cm_aux
    as decimal
    format "->>>,>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_dpr_val_origin
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    label "Dpr Valor Original"
    column-label "Dpr Valor Original"
    no-undo.
def var v_val_dpr_val_origin_2
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_dpr_val_origin_aux
    as decimal
    format "->>>,>>>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_maior
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_original
    as decimal
    format "->>>>>,>>>,>>9.99":U
    decimals 4
    initial 0
    label "Valor Original"
    column-label "Valor Original"
    no-undo.
def var v_val_sdo_cust_atrib
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 4
    no-undo.


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_bem_pat}


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
    run pi_version_extract ('fnc_bem_pat':U, 'prgfin/fas/fas703zc.p':U, '1.00.00.040':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_bem_pat') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bem_pat')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bem_pat')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_bem_pat' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_bem_pat'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


/* @i(i_std_dialog_box &program=@&(program)
                  frame=@&(frame))

pause 0 before-hide.
view frame @&(frame).*/

main_block:
do on endkey undo main_block, leave main_block
                on error undo main_block, leave main_block.
    run pi_verifica_diferenca.
end /* do main_block */.


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */


/* @cx_hide(@&(frame)).*/


/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */

return.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_verifica_valores_dif_destino
** Descricao.............: pi_verifica_valores_dif_destino
** Criado por............: src12337
** Criado em.............: 31/08/2001 14:01:20
** Alterado por..........: corp45760
** Alterado em...........: 05/02/2018 18:31:47
*****************************************************************************/
PROCEDURE pi_verifica_valores_dif_destino:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_desmembrto_bem_pat
        for tt_desmembrto_bem_pat.
    def buffer btt_impl_seq_incorp_bem_pat
        for tt_impl_seq_incorp_bem_pat.
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_aprop_ctbl_pat_cust
        for aprop_ctbl_pat.
    &endif
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_reg_calc_bem_pat
        for reg_calc_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_cont
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_cod_cenar_ctbl
        as character
        format "x(8)":U
        label "Cen†rio Cont†bil"
        column-label "Cen†rio Cont†bil"
        no-undo.
    def var v_cod_cenar_ctbl_2
        as character
        format "x(8)":U
        label "Cen†rio Ctbl"
        column-label "Cen†rio Ctbl"
        no-undo.
    def var v_cod_cenar_ctbl_ant
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_cenar_ctbl_aux
        as character
        format "x(8)":U
        label "Cen†rio Cont†bil"
        column-label "Cen†rio Cont†bil"
        no-undo.
    def var v_cod_finalid_ant
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_finalid_aux
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_finalid_econ
        as character
        format "x(10)":U
        label "Finalidade Econìmica"
        column-label "Finalidade Econìmica"
        no-undo.
    def var v_log_alterado
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_log_campo_chave
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_seq_incorp_bem_pat
        as integer
        format ">>>>,>>9":U
        initial 0
        label "Seq Incorp Bem"
        column-label "Seq Incorp Bem"
        no-undo.
    def var v_num_seq_incorp_bem_pat_aux
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_qtd_bem
        as decimal
        format ">>>>>9":U
        decimals 0
        label "Quantidade"
        column-label "Quantidade"
        no-undo.
    def var v_qtd_bem_aux
        as decimal
        format ">>>>>9":U
        decimals 0
        label "Quantidade"
        column-label "Quantidade"
        no-undo.
    def var v_val_acerto_aux
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        no-undo.
    def var v_val_amort_incevda_origin
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amort Incentiv"
        column-label "Amortizacao Incentiv"
        no-undo.
    def var v_val_cm_dpr_incevda
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "CM Dpr Incentiv"
        column-label "CM Dpr Incentivada"
        no-undo.
    def var v_val_dpr_cm_amort
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amortizaá∆o CM"
        column-label "Amortizaá∆o CM"
        no-undo.
    def var v_val_dpr_incevda_cm
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Dpr Incentiv CM"
        column-label "Dpr Incentiv CM"
        no-undo.
    def var v_val_dpr_incevda_val_origin
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Depreciaá∆o Incentiv"
        column-label "Depreciaá∆o Incentiv"
        no-undo.
    def var v_val_dpr_val_origin_amort
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amortizaá∆o VO"
        column-label "Amortizaá∆o VO"
        no-undo.
    def var v_val_impl
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        initial [0]
        extent 12
        no-undo.


    /************************** Variable Definition End *************************/

    for each tt_baixa_bem_pat:
        delete tt_baixa_bem_pat.
    end.

    /* Begin_Include: i_pi_verifica_valores_dif_destino_1 */
    /* faz leitura de todos os bens implantados separando por seq. incorp.
       e verifica se fecha com o valor baixado para aquela seq. de incorp. */
    for each  param_calc_bem_pat no-lock
        where param_calc_bem_pat.num_id_bem_pat = p_bem_pat.num_id_bem_pat
        and   param_calc_bem_pat.cod_tip_calc = ''
        break by param_calc_bem_pat.cod_cenar_ctbl
              by param_calc_bem_pat.cod_finalid_econ:

        for last sdo_bem_pat no-lock
            where sdo_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat
            and   sdo_bem_pat.num_seq_incorp_bem_pat = 0
            and   sdo_bem_pat.cod_cenar_ctbl = param_calc_bem_pat.cod_cenar_ctbl
            and   sdo_bem_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   sdo_bem_pat.dat_sdo_bem_pat <= p_dat_desmbrto:
            assign v_val_original = v_val_original + round(sdo_bem_pat.val_original,2)
                   v_val_dpr_val_origin = v_val_dpr_val_origin + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm = v_val_dpr_cm + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_dpr_incevda_cm = v_val_dpr_incevda_cm + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_dpr_incevda_val_origin = v_val_dpr_incevda_val_origin + round(sdo_bem_pat.val_dpr_incevda_val_origin,2)
                   v_val_cm_dpr = v_val_cm_dpr + round(sdo_bem_pat.val_cm_dpr,2)
                   v_val_cm_dpr_incevda = v_val_cm_dpr_incevda + round(sdo_bem_pat.val_cm_dpr_incevda,2)
                   v_val_cm = v_val_cm + round(sdo_bem_pat.val_cm,2)
                   v_val_dpr_val_origin_amort = v_val_dpr_val_origin_amort + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm_amort = v_val_dpr_cm_amort + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_amort_incevda_origin = v_val_amort_incevda_origin + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_sdo_cust_atrib = v_val_sdo_cust_atrib + ROUND(sdo_bem_pat.val_sdo_cust_atrib,2).

        end.
        for each  incorp_bem_pat
            where incorp_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat,
            last  sdo_bem_pat no-lock
            where sdo_bem_pat.num_id_bem_pat = incorp_bem_pat.num_id_bem_pat
            and   sdo_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
            and   sdo_bem_pat.cod_cenar_ctbl = param_calc_bem_pat.cod_cenar_ctbl
            and   sdo_bem_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   sdo_bem_pat.dat_sdo_bem_pat <= p_dat_desmbrto:
            assign v_val_original = v_val_original + round(sdo_bem_pat.val_original,2)
                   v_val_dpr_val_origin = v_val_dpr_val_origin + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm = v_val_dpr_cm + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_dpr_incevda_cm = v_val_dpr_incevda_cm + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_dpr_incevda_val_origin = v_val_dpr_incevda_val_origin + round(sdo_bem_pat.val_dpr_incevda_val_origin,2)
                   v_val_cm_dpr = v_val_cm_dpr + round(sdo_bem_pat.val_cm_dpr,2)
                   v_val_cm_dpr_incevda = v_val_cm_dpr_incevda + round(sdo_bem_pat.val_cm_dpr_incevda,2)
                   v_val_cm = v_val_cm + round(sdo_bem_pat.val_cm,2)
                   v_val_dpr_val_origin_amort = v_val_dpr_val_origin_amort + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm_amort = v_val_dpr_cm_amort + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_amort_incevda_origin = v_val_amort_incevda_origin + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_sdo_cust_atrib = v_val_sdo_cust_atrib + ROUND(sdo_bem_pat.val_sdo_cust_atrib,2).

        end.
        for each  tt_desmembrto_bem_pat:
            create tt_baixa_bem_pat.
            assign tt_baixa_bem_pat.tta_num_id_bem_pat   = tt_desmembrto_bem_pat.tta_num_id_bem_pat
                   tt_baixa_bem_pat.tta_cod_cenar_ctbl   = param_calc_bem_pat.cod_cenar_ctbl
                   tt_baixa_bem_pat.tta_cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
                   tt_baixa_bem_pat.ttv_val_baixado[01]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_original,2)
                   tt_baixa_bem_pat.ttv_val_baixado[02]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_val_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[03]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[04]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_incevda_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[05]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_incevda_val_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[06]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm_dpr,2)
                   tt_baixa_bem_pat.ttv_val_baixado[07]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm_dpr_incevda,2)
                   tt_baixa_bem_pat.ttv_val_baixado[08]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[09]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_val_origin_amort,2)
                   tt_baixa_bem_pat.ttv_val_baixado[10]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_cm_amort,2)
                   tt_baixa_bem_pat.ttv_val_baixado[11]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_amort_incevda_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[12]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_sdo_cust_atrib,2) .

        end.
        assign v_val_original = 0
               v_val_dpr_val_origin = 0
               v_val_dpr_cm = 0
               v_val_dpr_incevda_cm = 0
               v_val_dpr_incevda_val_origin = 0
               v_val_cm_dpr = 0
               v_val_cm_dpr_incevda = 0
               v_val_cm = 0
               v_val_dpr_val_origin_amort = 0
               v_val_dpr_cm_amort = 0
               v_val_amort_incevda_origin = 0
               v_val_sdo_cust_atrib = 0.

    end.

    blk_baixa_seq_incorp:
    for each  reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat = p_bem_pat.num_id_bem_pat
        and   reg_calc_bem_pat.dat_calc_pat   = p_dat_desmbrto:

        if  reg_calc_bem_pat.ind_trans_calc_bem_pat <> "Baixa" /*l_baixa*/  or
            reg_calc_bem_pat.ind_orig_calc_bem_pat  <> "Desmembramento" /*l_desmembramento*/  then
            next blk_baixa_seq_incorp.

        find first tt_baixa_seq_incorp_bem_pat
            where  tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
            and    tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
            and    tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ no-error.
        if  not avail tt_baixa_seq_incorp_bem_pat then do:
            create tt_baixa_seq_incorp_bem_pat.
            assign tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                   tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
                   tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ.
        end.

        if  reg_calc_bem_pat.cod_tip_calc = '' THEN DO:
            assign tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[01] = round(reg_calc_bem_pat.val_original,2).
            find first b_sdo_bem_pat_cust exclusive-lock
                where  b_sdo_bem_pat_cust.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                and    b_sdo_bem_pat_cust.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and    b_sdo_bem_pat_cust.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                and    b_sdo_bem_pat_cust.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                and    b_sdo_bem_pat_cust.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat no-error.
            if not avail b_sdo_bem_pat_cust then do:
                /* Inicio: Quando o bem foi implantado em um dia e baixado no dia seguinte o registro de depreciaá∆o n∆o Ç gerado
                   um dia antes da baixa e o saldo fica apenas o do dia da implantaá∆o, por isso o sistema se perdia e n∆o 
                   gerava o valor do Custo atribuido correto, incluimos a validaá∆o abaixo para ele pegar o custo deste saldo 
                   caso ocorra esta situaá∆o*/
                find first movto_bem_pat no-lock
                  where movto_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                    and movto_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/  no-error.
                if avail movto_bem_pat then do:
                    find first b_sdo_bem_pat_cust exclusive-lock
                      where b_sdo_bem_pat_cust.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                        and b_sdo_bem_pat_cust.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                        and b_sdo_bem_pat_cust.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                        and b_sdo_bem_pat_cust.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                        and (b_sdo_bem_pat_cust.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat - 1
                        and  b_sdo_bem_pat_cust.dat_sdo_bem_pat = movto_bem_pat.dat_movto_bem_pat) no-error.
                end.
                /* Fim*/
            end.
            if avail b_sdo_bem_pat_cust THEN DO:
                FIND LAST movto_bem_pat no-lock
                    WHERE movto_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                      AND movto_bem_pat.ind_orig_calc_bem_pat = "Desmembramento" /*l_desmembramento*/ 
                      AND movto_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  NO-ERROR.
                IF AVAIL movto_bem_pat THEN 
                    assign tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[12] = round((movto_bem_pat.val_perc_movto_bem_pat / 100) * b_sdo_bem_pat_cust.val_sdo_cust_atrib,2).
            END.
        END.
        else blk_param_calc_cta: do:
            for each  btt_desmembrto_bem_pat:
                if  not can-find(first param_calc_cta
                                 where param_calc_cta.cod_empresa      = btt_desmembrto_bem_pat.tta_cod_empresa
                                 and   param_calc_cta.cod_cta_pat      = btt_desmembrto_bem_pat.tta_cod_cta_pat
                                 and   param_calc_cta.cod_tip_calc     = reg_calc_bem_pat.cod_tip_calc
                                 and   param_calc_cta.cod_cenar_ctbl   = reg_calc_bem_pat.cod_cenar_ctbl
                                 and   param_calc_cta.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ) then
                    leave blk_param_calc_cta.
            end.
            find first tip_calc no-lock
                 where tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-error.
            if  avail tip_calc then do:
                case tip_calc.ind_tip_calc:
                    when "Depreciaá∆o" /*l_depreciacao*/  then
                        assign tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[02] = round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[03] = round(reg_calc_bem_pat.val_dpr_cm,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[04] = round(reg_calc_bem_pat.val_dpr_incevda_cm,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[05] = round(reg_calc_bem_pat.val_dpr_incevda_val_origin,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[06] = round(reg_calc_bem_pat.val_cm_dpr,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[07] = round(reg_calc_bem_pat.val_cm_dpr_incevda,2).
                    when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then
                        assign tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[08] = round(reg_calc_bem_pat.val_cm,2).
                    when "Amortizaá∆o" /*l_amortizacao*/  then
                        assign tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[09] = round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[10] = round(reg_calc_bem_pat.val_dpr_cm,2)
                               tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[11] = round(reg_calc_bem_pat.val_dpr_incevda_cm,2).
                end.
            end.
        end.
    end.

    for each tt_desmembrto_bem_pat,
        each  reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat = tt_desmembrto_bem_pat.tta_num_id_bem_pat
        break by reg_calc_bem_pat.num_seq_incorp_bem_pat
              by reg_calc_bem_pat.cod_cenar_ctbl
              by reg_calc_bem_pat.cod_finalid_econ:

        if  reg_calc_bem_pat.cod_tip_calc = '' THEN DO:
            assign v_cod_finalid_aux    = reg_calc_bem_pat.cod_finalid_econ
                   v_cod_cenar_ctbl_aux = reg_calc_bem_pat.cod_cenar_ctbl.
            if v_cod_finalid_ant <> v_cod_finalid_aux OR v_cod_cenar_ctbl_aux <> v_cod_cenar_ctbl_ant then 
                assign v_val_impl[1] = 0
                       v_cod_finalid_ant = v_cod_finalid_aux
                       v_cod_cenar_ctbl_ant = v_cod_cenar_ctbl_aux.
            assign v_val_impl[01] = v_val_impl[01] + round(reg_calc_bem_pat.val_original,2).
            find first b_sdo_bem_pat_cust exclusive-lock
                where  b_sdo_bem_pat_cust.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                and    b_sdo_bem_pat_cust.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and    b_sdo_bem_pat_cust.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                and    b_sdo_bem_pat_cust.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                and    b_sdo_bem_pat_cust.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat no-error.
            if avail b_sdo_bem_pat_cust then
                assign v_val_impl[12] = v_val_impl[12] + round(b_sdo_bem_pat_cust.val_sdo_cust_atrib,2) .
        END.
        else blk_param_calc_cta: do:
            if  not can-find(first param_calc_cta
                             where param_calc_cta.cod_empresa      = p_bem_pat.cod_empresa
                             and   param_calc_cta.cod_cta_pat      = p_bem_pat.cod_cta_pat
                             and   param_calc_cta.cod_tip_calc     = reg_calc_bem_pat.cod_tip_calc
                             and   param_calc_cta.cod_cenar_ctbl   = reg_calc_bem_pat.cod_cenar_ctbl
                             and   param_calc_cta.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ) then
                leave blk_param_calc_cta.

            for each  btt_desmembrto_bem_pat:
                if  not can-find(first param_calc_cta
                                 where param_calc_cta.cod_empresa      = btt_desmembrto_bem_pat.tta_cod_empresa
                                 and   param_calc_cta.cod_cta_pat      = btt_desmembrto_bem_pat.tta_cod_cta_pat
                                 and   param_calc_cta.cod_tip_calc     = reg_calc_bem_pat.cod_tip_calc
                                 and   param_calc_cta.cod_cenar_ctbl   = reg_calc_bem_pat.cod_cenar_ctbl
                                 and   param_calc_cta.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ) then
                    leave blk_param_calc_cta.
            end.
            find first tip_calc no-lock
                where tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-error.
            if  avail tip_calc then do:
                case tip_calc.ind_tip_calc:
                    when "Depreciaá∆o" /*l_depreciacao*/  then
                        assign v_val_impl[02] = v_val_impl[02] + round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               v_val_impl[03] = v_val_impl[03] + round(reg_calc_bem_pat.val_dpr_cm,2)
                               v_val_impl[04] = v_val_impl[04] + round(reg_calc_bem_pat.val_dpr_incevda_cm,2)
                               v_val_impl[05] = v_val_impl[05] + round(reg_calc_bem_pat.val_dpr_incevda_val_origin,2)
                               v_val_impl[06] = v_val_impl[06] + round(reg_calc_bem_pat.val_cm_dpr,2)
                               v_val_impl[07] = v_val_impl[07] + round(reg_calc_bem_pat.val_cm_dpr_incevda,2).
                    when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then
                        assign v_val_impl[08] = v_val_impl[08] + round(reg_calc_bem_pat.val_cm,2).
                    when "Amortizaá∆o" /*l_amortizacao*/  then
                        assign v_val_impl[09] = v_val_impl[09] + round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               v_val_impl[10] = v_val_impl[10] + round(reg_calc_bem_pat.val_dpr_cm,2)
                               v_val_impl[11] = v_val_impl[11] + round(reg_calc_bem_pat.val_dpr_incevda_cm,2).
                end.
            end.
        end.
        if  last-of(reg_calc_bem_pat.cod_finalid_econ) then do:
            find first tt_baixa_seq_incorp_bem_pat
                where  tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and    tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
                and    tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ no-error.
            if avail tt_baixa_seq_incorp_bem_pat then do:    
                do  v_cdn_cont = 1 to 12:
                    if  avail tt_baixa_seq_incorp_bem_pat
                    and v_val_impl[v_cdn_cont] <> tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[v_cdn_cont] then do:
                        create tt_impl_seq_incorp_bem_pat.
                        assign tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                               tt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
                               tt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
                               tt_impl_seq_incorp_bem_pat.ttv_idi_campo              = v_cdn_cont
                               tt_impl_seq_incorp_bem_pat.ttv_val_acerto             = tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[v_cdn_cont] - v_val_impl[v_cdn_cont].

                        if  tt_impl_seq_incorp_bem_pat.ttv_val_acerto < 0 then
                            assign tt_impl_seq_incorp_bem_pat.ttv_idi_acerto = 0.
                        else
                            if  tt_impl_seq_incorp_bem_pat.ttv_val_acerto > 0 then
                                assign tt_impl_seq_incorp_bem_pat.ttv_idi_acerto = 1.
                            else
                                assign tt_impl_seq_incorp_bem_pat.ttv_idi_acerto = 2.
                    end.
                    assign v_val_impl[v_cdn_cont] = 0.
                end.
            end.    
        end.
    end.

    do  v_cdn_cont = 1 to 12:
        assign v_val_impl[v_cdn_cont] = 0.
    end.
    assign v_cod_finalid_aux = ''
           v_cod_finalid_ant = ''
           v_cod_cenar_ctbl_aux = ''
           v_cod_cenar_ctbl_ant = ''.

    for each  tt_desmembrto_bem_pat,
        each  reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat = tt_desmembrto_bem_pat.tta_num_id_bem_pat
        break by reg_calc_bem_pat.num_id_bem_pat
              by reg_calc_bem_pat.cod_cenar_ctbl
              by reg_calc_bem_pat.cod_finalid_econ:

        if  reg_calc_bem_pat.cod_tip_calc = '' THEN DO:
            assign v_cod_finalid_aux = reg_calc_bem_pat.cod_finalid_econ.
            if v_cod_finalid_ant <> v_cod_finalid_aux OR v_cod_cenar_ctbl_aux <> v_cod_cenar_ctbl_ant then 
                assign v_val_impl[1] = 0
                       v_cod_finalid_ant = v_cod_finalid_aux
                       v_cod_cenar_ctbl_ant = v_cod_cenar_ctbl_aux.
            assign v_val_impl[01] = v_val_impl[01] + round(reg_calc_bem_pat.val_original,2).
            find first b_sdo_bem_pat_cust exclusive-lock
                where  b_sdo_bem_pat_cust.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                and    b_sdo_bem_pat_cust.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and    b_sdo_bem_pat_cust.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                and    b_sdo_bem_pat_cust.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                and    b_sdo_bem_pat_cust.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat no-error.
            if avail b_sdo_bem_pat_cust then
                assign v_val_impl[12] = v_val_impl[12] + round(b_sdo_bem_pat_cust.val_sdo_cust_atrib,2).
        END.
        else do:
            find first tip_calc no-lock
                where  tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-error.
            if  avail tip_calc then do:
                case tip_calc.ind_tip_calc:
                    when "Depreciaá∆o" /*l_depreciacao*/  then
                        assign v_val_impl[02] = v_val_impl[02] + round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               v_val_impl[03] = v_val_impl[03] + round(reg_calc_bem_pat.val_dpr_cm,2)
                               v_val_impl[04] = v_val_impl[04] + round(reg_calc_bem_pat.val_dpr_incevda_cm,2)
                               v_val_impl[05] = v_val_impl[05] + round(reg_calc_bem_pat.val_dpr_incevda_val_origin,2)
                               v_val_impl[06] = v_val_impl[06] + round(reg_calc_bem_pat.val_cm_dpr,2)
                               v_val_impl[07] = v_val_impl[07] + round(reg_calc_bem_pat.val_cm_dpr_incevda,2).
                    when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then
                        assign v_val_impl[08] = v_val_impl[08] + round(reg_calc_bem_pat.val_cm,2).
                    when "Amortizaá∆o" /*l_amortizacao*/  then
                        assign v_val_impl[09] = v_val_impl[09] + round(reg_calc_bem_pat.val_dpr_val_origin,2)
                               v_val_impl[10] = v_val_impl[10] + round(reg_calc_bem_pat.val_dpr_cm,2)
                               v_val_impl[11] = v_val_impl[11] + round(reg_calc_bem_pat.val_dpr_incevda_cm,2).
                end.
            end.
        end.
        if  first-of(reg_calc_bem_pat.num_id_bem_pat) then
            assign v_qtd_bem = v_qtd_bem + 1.

        if  last-of(reg_calc_bem_pat.cod_finalid_econ) then do:
            find first tt_baixa_bem_pat
                where  tt_baixa_bem_pat.tta_num_id_bem_pat   = reg_calc_bem_pat.num_id_bem_pat
                and    tt_baixa_bem_pat.tta_cod_cenar_ctbl   = reg_calc_bem_pat.cod_cenar_ctbl
                and    tt_baixa_bem_pat.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ no-error.
            if avail tt_baixa_bem_pat then do:    
                do  v_cdn_cont = 1 to 12:
                    create tt_impl_bem_pat.
                    assign tt_impl_bem_pat.tta_num_id_bem_pat    = reg_calc_bem_pat.num_id_bem_pat
                           tt_impl_bem_pat.tta_cod_cenar_ctbl    = reg_calc_bem_pat.cod_cenar_ctbl
                           tt_impl_bem_pat.tta_cod_finalid_econ  = reg_calc_bem_pat.cod_finalid_econ
                           tt_impl_bem_pat.ttv_idi_campo         = v_cdn_cont
                           tt_impl_bem_pat.ttv_val_acerto        = round(tt_baixa_bem_pat.ttv_val_baixado[v_cdn_cont],2) - v_val_impl[v_cdn_cont]
                           v_val_impl[v_cdn_cont] = 0.

                    if  tt_impl_bem_pat.ttv_val_acerto < 0 then
                        assign tt_impl_bem_pat.ttv_idi_acerto = 0.
                    else
                        if  tt_impl_bem_pat.ttv_val_acerto > 0 then
                            assign tt_impl_bem_pat.ttv_idi_acerto = 1.
                        else
                            assign tt_impl_bem_pat.ttv_idi_acerto = 2.
                end.
            end.
        end.
    end.
    assign v_cod_finalid_aux = ''
           v_cod_finalid_ant = ''.
    /* End_Include: i_pi_verifica_valores_dif_destino_1 */

    for each tt_impl_seq_incorp_bem_pat
        break by tt_impl_seq_incorp_bem_pat.ttv_idi_campo
              by tt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl
              by tt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ
              by tt_impl_seq_incorp_bem_pat.ttv_val_acerto
              by tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat:
        assign v_val_acerto_aux = tt_impl_seq_incorp_bem_pat.ttv_val_acerto * -1
               v_log_alterado = no.    
        if can-find(first btt_impl_seq_incorp_bem_pat
                    where btt_impl_seq_incorp_bem_pat.ttv_idi_campo > 02
                    and   btt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl = tt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl
                    and   btt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ = tt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ) then
            assign v_log_campo_chave = yes.
        else
            assign v_log_campo_chave = no.
        blk_acerto_repeat:
        repeat:
            blk_acerto_for:
            for each  tt_impl_bem_pat
                where tt_impl_bem_pat.ttv_idi_campo = tt_impl_seq_incorp_bem_pat.ttv_idi_campo
                and   tt_impl_bem_pat.tta_cod_cenar_ctbl = tt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl
                and   tt_impl_bem_pat.tta_cod_finalid_econ = tt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ
                break by tt_impl_bem_pat.ttv_idi_acerto
                      by tt_impl_bem_pat.tta_num_id_bem_pat:
                if  tt_impl_bem_pat.ttv_val_acerto = 0 then
                    assign v_val_acerto = tt_impl_seq_incorp_bem_pat.ttv_val_acerto.
                else do:
                    if (tt_impl_bem_pat.ttv_val_acerto > 0 and
                        tt_impl_seq_incorp_bem_pat.ttv_val_acerto > 0) or
                       (tt_impl_bem_pat.ttv_val_acerto < 0 and
                        tt_impl_seq_incorp_bem_pat.ttv_val_acerto < 0) then do:
                        if abs(tt_impl_bem_pat.ttv_val_acerto) < abs(tt_impl_seq_incorp_bem_pat.ttv_val_acerto) then
                            assign v_val_acerto = tt_impl_bem_pat.ttv_val_acerto.
                        else
                            assign v_val_acerto = tt_impl_seq_incorp_bem_pat.ttv_val_acerto.
                    end.
                    else
                        assign v_val_acerto = tt_impl_seq_incorp_bem_pat.ttv_val_acerto.
                end.
                if  (v_val_acerto / v_qtd_bem) - trunc(v_val_acerto / v_qtd_bem,2) < 0 then
                    assign v_val_acerto = trunc(v_val_acerto / v_qtd_bem,2) - 0.01.
                else
                    if  (v_val_acerto / v_qtd_bem) - trunc(v_val_acerto / v_qtd_bem,2) > 0 then
                        assign v_val_acerto = trunc(v_val_acerto / v_qtd_bem,2) + 0.01.
                    else
                        assign v_val_acerto = trunc(v_val_acerto / v_qtd_bem,2).
                if  abs(v_val_acerto_aux) < abs(v_val_acerto) then
                    assign v_val_acerto = v_val_acerto_aux * -1.
                if  tt_impl_bem_pat.ttv_idi_campo = 01 then do:
                    assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto.
                    for each  val_origin_bem_pat exclusive-lock
                        where val_origin_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                        and   val_origin_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                        and   val_origin_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                        and   val_origin_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ:    
                        assign tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1)
                               val_origin_bem_pat.val_original = val_origin_bem_pat.val_original + v_val_acerto.
                    end.
                end.
                for each  reg_calc_bem_pat exclusive-lock
                    where reg_calc_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                    and   reg_calc_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                    and   reg_calc_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                    and   reg_calc_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ:
                    find first sdo_bem_pat exclusive-lock
                        where  sdo_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                        and    sdo_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                        and    sdo_bem_pat.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                        and    sdo_bem_pat.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                        and    sdo_bem_pat.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat no-error.
                    find first aprop_ctbl_pat
                        where  aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat exclusive-lock no-error.
                    if  tt_impl_bem_pat.ttv_idi_campo = 01 then do:
                        find first b_bem_pat exclusive-lock
                            where  b_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                            and    b_bem_pat.val_original = reg_calc_bem_pat.val_original no-error.
                        assign reg_calc_bem_pat.val_original = reg_calc_bem_pat.val_original + v_val_acerto
                               v_log_alterado = yes.        
                        if  reg_calc_bem_pat.val_origin_corrig >= 0 then
                            assign reg_calc_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_origin_corrig + v_val_acerto.
                        assign sdo_bem_pat.val_original = reg_calc_bem_pat.val_original
                               sdo_bem_pat.val_origin_corrig = sdo_bem_pat.val_original + sdo_bem_pat.val_cm.

                        if  avail aprop_ctbl_pat and reg_calc_bem_pat.cod_tip_calc = '' then
                            if v_ind_trans_calc_bem_pat <> "Valorizaá∆o" /*l_valorizacao*/  and v_ind_trans_calc_bem_pat <> "Desvalorizaá∆o" /*l_desvalorizacao*/  then
                                assign aprop_ctbl_pat.val_lancto_ctbl = abs(reg_calc_bem_pat.val_original).        
                        if  avail b_bem_pat then do:
                            find first b_movto_bem_pat exclusive-lock
                                where  b_movto_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                                and    b_movto_bem_pat.dat_movto_bem_pat = reg_calc_bem_pat.dat_calc_pat
                                and    b_movto_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                and    b_movto_bem_pat.val_origin_movto_bem_pat = b_bem_pat.val_original no-error.
                            if  avail b_movto_bem_pat then
                                assign b_movto_bem_pat.val_origin_movto_bem_pat = reg_calc_bem_pat.val_original.        
                            if  b_bem_pat.val_despes_financ = b_bem_pat.val_original then
                                assign b_bem_pat.val_despes_financ = reg_calc_bem_pat.val_original.             
                            assign b_bem_pat.val_original = reg_calc_bem_pat.val_original.
                        end.
                    end.
                    else if tt_impl_bem_pat.ttv_idi_campo = 12 then do:
                        if reg_calc_bem_pat.cod_tip_calc = '' then do:
                            find first b_aprop_ctbl_pat_cust exclusive-lock
                                where b_aprop_ctbl_pat_cust.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat
                                  and b_aprop_ctbl_pat_cust.val_lancto_ctbl = sdo_bem_pat.val_sdo_cust_atrib no-error.
                            assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto.
                            if sdo_bem_pat.val_sdo_cust_atrib >= 0 and abs(sdo_bem_pat.val_sdo_cust_atrib) <> abs(v_val_acerto)then
                                assign sdo_bem_pat.val_sdo_cust_atrib = sdo_bem_pat.val_sdo_cust_atrib + v_val_acerto.
                            if  avail b_aprop_ctbl_pat_cust then
                                assign b_aprop_ctbl_pat_cust.val_lancto_ctbl = abs(sdo_bem_pat.val_sdo_cust_atrib).
                            assign reg_calc_bem_pat.val_transf_cust_atrib = abs(sdo_bem_pat.val_sdo_cust_atrib).
                            leave blk_acerto_repeat.
                        end.
                    end.
                    else do:
                        if  reg_calc_bem_pat.cod_tip_calc <> '' then do:
                            find first tip_calc no-lock
                                where  tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-error.
                            case tip_calc.ind_tip_calc:
                                when "Depreciaá∆o" /*l_depreciacao*/  then do:
                                    if  tt_impl_bem_pat.ttv_idi_campo < 8 then do:

                                        IF v_num_seq_incorp_bem_pat_aux <> reg_calc_bem_pat.num_seq_incorp_bem_pat THEN DO:
                                            ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                   v_val_dpr_val_origin_aux = 0
                                                   v_val_dpr_cm_aux = 0
                                                   v_val_cm_dpr_aux = 0
                                                   v_log_alterado = NO
                                                   v_num_seq_incorp_bem_pat_aux = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                                   v_cod_cenar_ctbl_2 = reg_calc_bem_pat.cod_cenar_ctbl
                                                   v_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ.
                                        END.
                                        IF v_cod_cenar_ctbl_2 <> reg_calc_bem_pat.cod_cenar_ctbl THEN
                                            ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                   v_val_dpr_val_origin_aux = 0
                                                   v_val_dpr_cm_aux = 0
                                                   v_val_cm_dpr_aux = 0
                                                   v_log_alterado = NO
                                                   v_cod_cenar_ctbl_2 = reg_calc_bem_pat.cod_cenar_ctbl
                                                   v_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ.
                                         ELSE
                                             IF v_cod_finalid_econ <> reg_calc_bem_pat.cod_finalid_econ THEN
                                                 ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                        v_val_dpr_val_origin_aux = 0
                                                        v_val_dpr_cm_aux = 0
                                                        v_val_cm_dpr_aux = 0
                                                        v_log_alterado = NO
                                                        v_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ.
                                        case tt_impl_bem_pat.ttv_idi_campo:
                                             when 02 then do:
                                                run pi_acerta_dif_desmemb_dpr_val_origin(input v_log_campo_chave,input-output v_log_alterado,input-output v_qtd_bem_aux).
                                             end.
                                             when 03 then do:
                                                 run pi_acerta_dif_desmemb_dpr_cm(input-output v_log_alterado,input-output v_qtd_bem_aux).
                                             end.    
                                             when 04 then
                                                 assign reg_calc_bem_pat.val_dpr_incevda_cm = reg_calc_bem_pat.val_dpr_incevda_cm + v_val_acerto
                                                        sdo_bem_pat.val_dpr_incevda_cm = reg_calc_bem_pat.val_dpr_incevda_cm
                                                        v_log_alterado = yes.
                                             when 05 then
                                                 assign reg_calc_bem_pat.val_dpr_incevda_val_origin = reg_calc_bem_pat.val_dpr_incevda_val_origin + v_val_acerto
                                                        sdo_bem_pat.val_dpr_incevda_val_origin = reg_calc_bem_pat.val_dpr_incevda_val_origin
                                                        v_log_alterado = yes.
                                             when 06 then do:
                                                 run pi_acerta_dif_desmemb_cm_dpr(input-output v_log_alterado,input-output v_qtd_bem_aux).
                                             end.
                                             when 07 then
                                                 assign reg_calc_bem_pat.val_cm_dpr_incevda = reg_calc_bem_pat.val_cm_dpr_incevda + v_val_acerto
                                                        sdo_bem_pat.val_cm_dpr_incevda = reg_calc_bem_pat.val_cm_dpr_incevda
                                                        v_log_alterado = yes.
                                        end case.
                                        IF v_log_alterado THEN DO:
                                            assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto
                                                   tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1)
                                                   v_log_alterado = NO.
                                            IF v_val_acerto_aux = 0 THEN
                                                ASSIGN v_qtd_bem_aux = 0.
                                        END.
                                        if v_ind_trans_calc_bem_pat <> "Valorizaá∆o" /*l_valorizacao*/  and v_ind_trans_calc_bem_pat <> "Desvalorizaá∆o" /*l_desvalorizacao*/  then
                                            if avail aprop_ctbl_pat then
                                                assign aprop_ctbl_pat.val_lancto_ctbl = abs(reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr).
                                    end.
                                end.
                                when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then do:
                                    if  tt_impl_bem_pat.ttv_idi_campo = 08 then do:
                                        IF v_num_seq_incorp_bem_pat <> reg_calc_bem_pat.num_seq_incorp_bem_pat THEN DO:
                                            ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                   v_val_cm_aux = 0
                                                   v_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                                   v_cod_cenar_ctbl_aux = reg_calc_bem_pat.cod_cenar_ctbl
                                                   v_cod_finalid_aux = reg_calc_bem_pat.cod_finalid_econ.
                                        END.
                                        IF v_cod_cenar_ctbl_aux <> reg_calc_bem_pat.cod_cenar_ctbl THEN DO:
                                            ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                   v_val_cm_aux = 0
                                                   v_cod_cenar_ctbl_aux = reg_calc_bem_pat.cod_cenar_ctbl
                                                   v_cod_finalid_aux = reg_calc_bem_pat.cod_finalid_econ.
                                            END.
                                        ELSE DO:    
                                            IF v_cod_finalid_aux <> reg_calc_bem_pat.cod_finalid_econ THEN DO:
                                                ASSIGN v_qtd_bem_aux = v_qtd_bem
                                                       v_val_cm_aux = 0
                                                       v_cod_finalid_aux = reg_calc_bem_pat.cod_finalid_econ.
                                            END.
                                        END.
                                        IF v_val_acerto_aux = 0 THEN
                                            ASSIGN v_qtd_bem_aux = 0.
                                        IF v_qtd_bem_aux > 0 THEN DO:
                                            ASSIGN v_qtd_bem_aux = v_qtd_bem_aux - 1.
                                            IF (sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm) <> 0 THEN DO:
                                                IF  ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm)) < ABS(v_val_acerto_aux) 
                                                AND ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm)) > ABS(v_val_acerto) THEN DO:
                                                    IF (sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm) > 0 THEN DO:
                                                        ASSIGN v_val_acerto_aux = v_val_acerto_aux - ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                               reg_calc_bem_pat.val_cm = reg_calc_bem_pat.val_cm - ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                               reg_calc_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_origin_corrig + ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                               sdo_bem_pat.val_cm = reg_calc_bem_pat.val_cm
                                                               sdo_bem_pat.val_origin_corrig = sdo_bem_pat.val_original + sdo_bem_pat.val_cm 
                                                               tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm)) * -1).
                                                    END.
                                                    ELSE DO:
                                                        IF (sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm) < 0 THEN DO:
                                                            ASSIGN v_val_acerto_aux = v_val_acerto_aux + ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                                   reg_calc_bem_pat.val_cm = reg_calc_bem_pat.val_cm + ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                                   reg_calc_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_origin_corrig + ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm))
                                                                   sdo_bem_pat.val_cm = reg_calc_bem_pat.val_cm
                                                                   sdo_bem_pat.val_origin_corrig = sdo_bem_pat.val_original + sdo_bem_pat.val_cm 
                                                                   tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (ABS((sdo_bem_pat.val_original + reg_calc_bem_pat.val_cm) - (sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm)) * -1).
                                                        END.
                                                    END.
                                                END.
                                                ELSE DO:
                                                    assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto
                                                           reg_calc_bem_pat.val_cm = reg_calc_bem_pat.val_cm + v_val_acerto
                                                           reg_calc_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_origin_corrig + v_val_acerto
                                                           sdo_bem_pat.val_cm = reg_calc_bem_pat.val_cm
                                                           sdo_bem_pat.val_origin_corrig  = sdo_bem_pat.val_original + sdo_bem_pat.val_cm
                                                           tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1).
                                                END.                                                
                                            END.
                                            ELSE DO:
                                                assign tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1).
                                            END.
                                        END.
                                        ELSE
                                            assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto
                                                   tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1).

                                        if v_ind_trans_calc_bem_pat <> "Valorizaá∆o" /*l_valorizacao*/  and v_ind_trans_calc_bem_pat <> "Desvalorizaá∆o" /*l_desvalorizacao*/  then               
                                            if  avail aprop_ctbl_pat then
                                                assign aprop_ctbl_pat.val_lancto_ctbl = abs(reg_calc_bem_pat.val_cm).
                                        for each  b_reg_calc_bem_pat exclusive-lock
                                            where b_reg_calc_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                                            and   b_reg_calc_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                            and   b_reg_calc_bem_pat.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                                            and   b_reg_calc_bem_pat.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                                            and   b_reg_calc_bem_pat.dat_calc_pat = reg_calc_bem_pat.dat_calc_pat:
                                            if  rowid(b_reg_calc_bem_pat) <> rowid(reg_calc_bem_pat) then
                                                assign b_reg_calc_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_origin_corrig.
                                        end.
                                    end.
                                end.    
                                when "Amortizaá∆o" /*l_amortizacao*/  then do:
                                    if  tt_impl_bem_pat.ttv_idi_campo > 8 then do:
                                        assign v_val_acerto_aux = v_val_acerto_aux + v_val_acerto
                                               tt_impl_bem_pat.ttv_val_acerto = tt_impl_bem_pat.ttv_val_acerto + (v_val_acerto * -1).
                                        case tt_impl_bem_pat.ttv_idi_campo:
                                            when 09 then
                                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                                       sdo_bem_pat.val_dpr_val_origin_amort = reg_calc_bem_pat.val_dpr_val_origin.
                                            when 10 then
                                                assign reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                                                       sdo_bem_pat.val_dpr_cm_amort = reg_calc_bem_pat.val_dpr_cm.
                                            when 11 then
                                                assign reg_calc_bem_pat.val_dpr_incevda_cm = reg_calc_bem_pat.val_dpr_incevda_cm + v_val_acerto
                                                       sdo_bem_pat.val_amort_incevda_cm = reg_calc_bem_pat.val_dpr_incevda_cm.
                                        end case.
                                        if v_ind_trans_calc_bem_pat <> "Valorizaá∆o" /*l_valorizacao*/  and v_ind_trans_calc_bem_pat <> "Desvalorizaá∆o" /*l_desvalorizacao*/  then
                                            if avail aprop_ctbl_pat then
                                                assign aprop_ctbl_pat.val_lancto_ctbl = abs(reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr).
                                    end.
                                end.
                            end case.                                                   
                        end.
                    end.
                end.            
                find first reg_calc_bem_pat exclusive-lock
                    where reg_calc_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                      and reg_calc_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                      and reg_calc_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                      and reg_calc_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ
                      and reg_calc_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/ 
                      and reg_calc_bem_pat.cod_tip_calc = '' no-error.
                if avail reg_calc_bem_pat then do:
                    for each  val_origin_bem_pat exclusive-lock
                        where val_origin_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                          and val_origin_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                          and val_origin_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                          and val_origin_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ
                          and val_origin_bem_pat.dat_calc_pat = reg_calc_bem_pat.dat_calc_pat:
                        if val_origin_bem_pat.val_original <> reg_calc_bem_pat.val_original then
                            assign val_origin_bem_pat.val_original = reg_calc_bem_pat.val_original.
                    end.                
                    for each b_reg_calc_bem_pat exclusive-lock
                        where b_reg_calc_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                          and b_reg_calc_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                          and b_reg_calc_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                          and b_reg_calc_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ
                          and recid(b_reg_calc_bem_pat) <> recid(reg_calc_bem_pat):
                        assign b_reg_calc_bem_pat.val_original = reg_calc_bem_pat.val_original.
                    end.                
                    for each sdo_bem_pat exclusive-lock
                        where sdo_bem_pat.num_id_bem_pat = tt_impl_bem_pat.tta_num_id_bem_pat
                          and sdo_bem_pat.num_seq_incorp_bem_pat = tt_impl_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                          and sdo_bem_pat.cod_cenar_ctbl = tt_impl_bem_pat.tta_cod_cenar_ctbl
                          and sdo_bem_pat.cod_finalid_econ = tt_impl_bem_pat.tta_cod_finalid_econ:
                        assign sdo_bem_pat.val_original = reg_calc_bem_pat.val_original
                               sdo_bem_pat.val_origin_corrig = reg_calc_bem_pat.val_original + sdo_bem_pat.val_cm.
                    end.
                end.
                if  tt_impl_bem_pat.ttv_val_acerto < 0 then
                    assign tt_impl_bem_pat.ttv_idi_acerto = 0.
                else
                    if  tt_impl_bem_pat.ttv_val_acerto > 0 then
                        assign tt_impl_bem_pat.ttv_idi_acerto = 1.
                    else
                        assign tt_impl_bem_pat.ttv_idi_acerto = 2.
                if  (v_val_acerto_aux = 0
                or  last-of(tt_impl_bem_pat.ttv_idi_acerto))
                and v_qtd_bem_aux = 0 then
                    leave blk_acerto_for.
            end.
            if  v_val_acerto_aux = 0 and v_qtd_bem_aux = 0 then
                leave blk_acerto_repeat.
            if not can-find (first tt_impl_bem_pat
                where tt_impl_bem_pat.ttv_idi_campo = tt_impl_seq_incorp_bem_pat.ttv_idi_campo
                and   tt_impl_bem_pat.tta_cod_cenar_ctbl = tt_impl_seq_incorp_bem_pat.tta_cod_cenar_ctbl
                and   tt_impl_bem_pat.tta_cod_finalid_econ = tt_impl_seq_incorp_bem_pat.tta_cod_finalid_econ) then do:
                leave blk_acerto_repeat.
            end.
        end.
    end.
END PROCEDURE. /* pi_verifica_valores_dif_destino */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_valores_dif_origem
** Descricao.............: pi_verifica_valores_dif_origem
** Criado por............: src12337
** Criado em.............: 31/08/2001 13:53:49
** Alterado por..........: corp45760
** Alterado em...........: 18/09/2017 08:27:12
*****************************************************************************/
PROCEDURE pi_verifica_valores_dif_origem:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_reg_calc_bem_pat
        for reg_calc_bem_pat.
    &endif
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_reg_calc_bem_pat_2
        for reg_calc_bem_pat.
    &endif
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_sdo_bem_pat
        for sdo_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_rec_obj
        as recid
        format ">>>>>>9":U
        no-undo.
    def var v_val_aux
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        initial 0
        no-undo.
    def var v_val_bxa
        as decimal
        format "->>,>>>,>>9.99":U
        decimals 2
        label "Total Baixado"
        column-label "Total Baixado"
        no-undo.
    def var v_val_maior
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        no-undo.


    /************************** Variable Definition End *************************/

    /* Origem */
    for each reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat         = b_movto_bem_pat_orig.num_id_bem_pat
        and   reg_calc_bem_pat.dat_calc_pat           = b_movto_bem_pat_orig.dat_movto_bem_pat
        and   reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ 
        and   reg_calc_bem_pat.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/ 
        break by reg_calc_bem_pat.cod_cenar_ctbl
              by reg_calc_bem_pat.cod_finalid_econ
              by reg_calc_bem_pat.num_seq_incorp_bem_pat.
        if trim(reg_calc_bem_pat.cod_tip_calc) = '' then do:
            assign v_val_aux = v_val_aux + round(reg_calc_bem_pat.val_original,2)
                   v_ind_trans_calc_bem_pat = reg_calc_bem_pat.ind_ajust_cust_atrib.
            if abs(reg_calc_bem_pat.val_original) > abs(v_val_maior) then
                assign v_val_maior = reg_calc_bem_pat.val_original
                       v_rec_obj = recid(reg_calc_bem_pat).
            else
                if  v_rec_obj = ? then
                    assign v_val_maior = reg_calc_bem_pat.val_original
                           v_rec_obj = recid(reg_calc_bem_pat).
        end.
        else do:
            find first tip_calc
                where tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-lock no-error.   
            if avail tip_calc then do:
                find first tt_verifica_diferenca_desmem
                    where tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                    and   tt_verifica_diferenca_desmem.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                    and   tt_verifica_diferenca_desmem.tta_cod_tip_calc = reg_calc_bem_pat.cod_tip_calc
                    no-error.
                if not avail tt_verifica_diferenca_desmem then do:
                    create tt_verifica_diferenca_desmem.
                    assign tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                           tt_verifica_diferenca_desmem.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                           tt_verifica_diferenca_desmem.tta_cod_tip_calc = reg_calc_bem_pat.cod_tip_calc.
                end.
                case tip_calc.ind_tip_calc:
                    when "Depreciaá∆o" /*l_depreciacao*/  then
                        assign tt_verifica_diferenca_desmem.tta_val_dpr_val_origin = tt_verifica_diferenca_desmem.tta_val_dpr_val_origin + reg_calc_bem_pat.val_dpr_val_origin
                               tt_verifica_diferenca_desmem.tta_val_dpr_cm = tt_verifica_diferenca_desmem.tta_val_dpr_cm  + reg_calc_bem_pat.val_dpr_cm
                               tt_verifica_diferenca_desmem.tta_val_dpr_incevda_val_origin = tt_verifica_diferenca_desmem.tta_val_dpr_incevda_val_origin + reg_calc_bem_pat.val_dpr_incevda_val_origin
                               tt_verifica_diferenca_desmem.tta_val_dpr_incevda_cm = tt_verifica_diferenca_desmem.tta_val_dpr_incevda_cm + reg_calc_bem_pat.val_dpr_incevda_cm
                               tt_verifica_diferenca_desmem.tta_val_cm = tt_verifica_diferenca_desmem.tta_val_cm + reg_calc_bem_pat.val_cm
                               tt_verifica_diferenca_desmem.tta_val_cm_dpr = tt_verifica_diferenca_desmem.tta_val_cm_dpr + reg_calc_bem_pat.val_cm_dpr
                               tt_verifica_diferenca_desmem.tta_val_cm_dpr_incevda = tt_verifica_diferenca_desmem.tta_val_cm_dpr_incevda + reg_calc_bem_pat.val_cm_dpr_incevda
                               tt_verifica_diferenca_desmem.tta_cod_tip_calc = reg_calc_bem_pat.cod_tip_calc.
                    when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then
                        assign tt_verifica_diferenca_desmem.tta_val_cm = tt_verifica_diferenca_desmem.tta_val_cm + reg_calc_bem_pat.val_cm
                               tt_verifica_diferenca_desmem.tta_cod_tip_calc = reg_calc_bem_pat.cod_tip_calc.
                    when "Amortizaá∆o" /*l_amortizacao*/  then
                        assign tt_verifica_diferenca_desmem.tta_val_dpr_val_origin_amort = tt_verifica_diferenca_desmem.tta_val_dpr_val_origin_amort + reg_calc_bem_pat.val_dpr_val_origin
                               tt_verifica_diferenca_desmem.tta_val_dpr_cm_amort = tt_verifica_diferenca_desmem.tta_val_dpr_cm_amort         + reg_calc_bem_pat.val_dpr_cm
                               tt_verifica_diferenca_desmem.tta_val_amort_incevda_origin = tt_verifica_diferenca_desmem.tta_val_amort_incevda_origin     + reg_calc_bem_pat.val_dpr_incevda_cm
                               tt_verifica_diferenca_desmem.tta_cod_tip_calc = reg_calc_bem_pat.cod_tip_calc.
                end.                           
            end.                           
        end.
        if  last-of(reg_calc_bem_pat.cod_finalid_econ) then do:
            find first tt_verifica_diferenca_desmem
                where tt_verifica_diferenca_desmem.tta_cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                and   tt_verifica_diferenca_desmem.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                and   tt_verifica_diferenca_desmem.tta_cod_tip_calc = '' no-error.
            if avail tt_verifica_diferenca_desmem and tt_verifica_diferenca_desmem.tta_val_original <> v_val_aux then do:
                find b_reg_calc_bem_pat
                    where recid(b_reg_calc_bem_pat) = v_rec_obj exclusive-lock no-error.
                if avail b_reg_calc_bem_pat then do:
                    if tt_verifica_diferenca_desmem.tta_val_original > v_val_aux then
                        assign b_reg_calc_bem_pat.val_original = b_reg_calc_bem_pat.val_original + (tt_verifica_diferenca_desmem.tta_val_original - v_val_aux).
                    else
                        assign b_reg_calc_bem_pat.val_original = b_reg_calc_bem_pat.val_original - (v_val_aux - tt_verifica_diferenca_desmem.tta_val_original).

                    if  b_reg_calc_bem_pat.num_seq_incorp_bem_pat = 0
                    and b_movto_bem_pat_orig.cod_indic_econ <> '' then do:
                        find first histor_finalid_econ no-lock
                             where histor_finalid_econ.cod_indic_econ          = b_movto_bem_pat_orig.cod_indic_econ
                               and histor_finalid_econ.dat_inic_valid_finalid <= b_movto_bem_pat_orig.dat_movto_bem_pat
                               and histor_finalid_econ.dat_fim_valid_finalid  >  b_movto_bem_pat_orig.dat_movto_bem_pat no-error.
                        if  avail histor_finalid_econ
                        and histor_finalid_econ.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ then do:
                            find first b_movto_bem_pat exclusive-lock
                                where  b_movto_bem_pat.num_id_bem_pat         = b_reg_calc_bem_pat.num_id_bem_pat
                                and    b_movto_bem_pat.dat_movto_bem_pat      = b_reg_calc_bem_pat.dat_calc_pat
                                and    b_movto_bem_pat.num_seq_incorp_bem_pat = b_reg_calc_bem_pat.num_seq_incorp_bem_pat
                                and    b_movto_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ 
                                and    b_movto_bem_pat.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/  no-error.
                            if  avail b_movto_bem_pat then
                                assign b_movto_bem_pat.val_origin_movto_bem_pat = b_reg_calc_bem_pat.val_original.
                        end.
                    end.

                    if b_reg_calc_bem_pat.ind_ajust_cust_atrib <> "Valorizaá∆o" /*l_valorizacao*/  and b_reg_calc_bem_pat.ind_ajust_cust_atrib <> "Desvalorizaá∆o" /*l_desvalorizacao*/  then do:
                        FIND FIRST aprop_ctbl_pat
                            WHERE aprop_ctbl_pat.num_seq_reg_calc_bem_pat = b_reg_calc_bem_pat.num_seq_reg_calc_bem_pat EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL aprop_ctbl_pat THEN
                            ASSIGN aprop_ctbl_pat.val_lancto_ctbl = abs(b_reg_calc_bem_pat.val_original).
                    end.

                    FIND LAST b_sdo_bem_pat
                        WHERE b_sdo_bem_pat.num_id_bem_pat = b_reg_calc_bem_pat.num_id_bem_pat
                        AND   b_sdo_bem_pat.num_seq_incorp_bem_pat = b_reg_calc_bem_pat.num_seq_incorp_bem_pat
                        AND   b_sdo_bem_pat.cod_cenar_ctbl = b_reg_calc_bem_pat.cod_cenar_ctbl
                        AND   b_sdo_bem_pat.cod_finalid_econ = b_reg_calc_bem_pat.cod_finalid_econ
                        AND   b_sdo_bem_pat.dat_sdo_bem_pat < b_reg_calc_bem_pat.dat_calc_pat + 1 NO-LOCK NO-ERROR.
                    IF AVAIL b_sdo_bem_pat THEN DO:
                        FOR EACH sdo_bem_pat
                            where sdo_bem_pat.num_id_bem_pat         = b_reg_calc_bem_pat.num_id_bem_pat
                            and   sdo_bem_pat.num_seq_incorp_bem_pat = b_reg_calc_bem_pat.num_seq_incorp_bem_pat
                            and   sdo_bem_pat.cod_cenar_ctbl         = b_reg_calc_bem_pat.cod_cenar_ctbl
                            and   sdo_bem_pat.cod_finalid_econ       = b_reg_calc_bem_pat.cod_finalid_econ
                            and   sdo_bem_pat.dat_sdo_bem_pat        = b_reg_calc_bem_pat.dat_calc_pat + 1
                            EXCLUSIVE-LOCK.
                            assign sdo_bem_pat.val_original = b_sdo_bem_pat.val_original - b_reg_calc_bem_pat.val_original
                                   sdo_bem_pat.val_origin_corrig = sdo_bem_pat.val_original + sdo_bem_pat.val_cm.
                        END.
                    END.
                end.
            end.
            assign v_val_aux = 0 v_val_maior = 0 v_rec_obj = ?.
        end.
    end.
    run pi_verifica_valores_dif_origem_sdo.

    find first reg_calc_bem_pat no-lock
      where reg_calc_bem_pat.num_id_bem_pat         = b_movto_bem_pat_orig.num_id_bem_pat
        and reg_calc_bem_pat.dat_calc_pat           = b_movto_bem_pat_orig.dat_movto_bem_pat
        and reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ 
        and reg_calc_bem_pat.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/ 
        and reg_calc_bem_pat.cod_tip_calc           = '' no-error.
        if avail reg_calc_bem_pat then do:

            find first b_reg_calc_bem_pat no-lock
                where b_reg_calc_bem_pat.num_id_bem_pat       = reg_calc_bem_pat.num_id_bem_pat
                and b_reg_calc_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and b_reg_calc_bem_pat.cod_tip_calc           = ''
                and b_reg_calc_bem_pat.cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl  
                and b_reg_calc_bem_pat.cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
                and b_reg_calc_bem_pat.dat_calc_pat           < reg_calc_bem_pat.dat_calc_pat
                and (b_reg_calc_bem_pat.ind_trans_calc_bem_pat <> "Baixa" /*l_baixa*/  
                AND  b_reg_calc_bem_pat.ind_trans_calc_bem_pat <> "Valorizaá∆o" /*l_valorizacao*/ 
                AND  b_reg_calc_bem_pat.ind_trans_calc_bem_pat <> "Implantaá∆o" /*l_implantacao*/ ) no-error.
            if avail b_reg_calc_bem_pat then do:
                assign v_val_bxa = 0.
                for each b_reg_calc_bem_pat_2 no-lock
                  where b_reg_calc_bem_pat_2.num_id_bem_pat         = reg_calc_bem_pat.num_id_bem_pat
                    and b_reg_calc_bem_pat_2.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                    and b_reg_calc_bem_pat_2.cod_tip_calc           = ''
                    and b_reg_calc_bem_pat_2.cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl  
                    and b_reg_calc_bem_pat_2.cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
                    and (b_reg_calc_bem_pat_2.dat_calc_pat          > b_reg_calc_bem_pat.dat_calc_pat
                    AND  b_reg_calc_bem_pat_2.dat_calc_pat          < reg_calc_bem_pat.dat_calc_pat)
                    and b_reg_calc_bem_pat_2.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ :

                    if b_reg_calc_bem_pat_2.ind_orig_calc_bem_pat = "Transferància" /*l_transferencia*/  then next.

                    assign v_val_bxa = v_val_bxa + b_reg_calc_bem_pat_2.val_original.
                end.
                for each sdo_bem_pat exclusive-lock 
                  where sdo_bem_pat.num_id_bem_pat         = reg_calc_bem_pat.num_id_bem_pat
                    and sdo_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                    and sdo_bem_pat.cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
                    and sdo_bem_pat.cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
                    and sdo_bem_pat.dat_sdo_bem_pat        = reg_calc_bem_pat.dat_calc_pat + 1:
                    assign sdo_bem_pat.val_original      = b_reg_calc_bem_pat.val_original - v_val_bxa - reg_calc_bem_pat.val_original
                           sdo_bem_pat.val_origin_corrig = sdo_bem_pat.val_original + sdo_bem_pat.val_cm.
                end.
            end.
        end.
END PROCEDURE. /* pi_verifica_valores_dif_origem */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_diferenca
** Descricao.............: pi_verifica_diferenca
** Criado por............: src12337
** Criado em.............: 24/08/2001 14:35:16
** Alterado por..........: src12337
** Alterado em...........: 04/12/2001 13:56:15
*****************************************************************************/
PROCEDURE pi_verifica_diferenca:

    find first b_movto_bem_pat_orig
        where b_movto_bem_pat_orig.num_id_bem_pat         = p_bem_pat.num_id_bem_pat
        and   b_movto_bem_pat_orig.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ 
        and   b_movto_bem_pat_orig.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/ 
        and   b_movto_bem_pat_orig.dat_movto_bem_pat      = p_dat_desmbrto
        no-lock no-error.
    if avail b_movto_bem_pat_orig then do:
        run pi_verifica_valores_dif_origem.
        run pi_verifica_valores_dif_destino.
        /* Verifica a diferenáa */
        /* run pi_acerta_valores_diferenca.*/
    end.    

END PROCEDURE. /* pi_verifica_diferenca */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut43117
** Alterado em...........: 05/12/2011 10:21:41
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* alteracao sob demanda - atividade 195864*/
    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ then 
        assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.




END PROCEDURE. /* pi_retornar_finalid_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_valores_dif_origem_sdo
** Descricao.............: pi_verifica_valores_dif_origem_sdo
** Criado por............: src12337
** Criado em.............: 23/11/2001 07:59:14
** Alterado por..........: corp45760
** Alterado em...........: 05/10/2015 10:07:16
*****************************************************************************/
PROCEDURE pi_verifica_valores_dif_origem_sdo:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_sdo_bem_pat
        for sdo_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_alter
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_val_amort_incevda_origin
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amort Incentiv"
        column-label "Amortizacao Incentiv"
        no-undo.
    def var v_val_cm_dpr_incevda
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "CM Dpr Incentiv"
        column-label "CM Dpr Incentivada"
        no-undo.
    def var v_val_dpr_cm_amort
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amortizaá∆o CM"
        column-label "Amortizaá∆o CM"
        no-undo.
    def var v_val_dpr_incevda_cm
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Dpr Incentiv CM"
        column-label "Dpr Incentiv CM"
        no-undo.
    def var v_val_dpr_incevda_val_origin
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Depreciaá∆o Incentiv"
        column-label "Depreciaá∆o Incentiv"
        no-undo.
    def var v_val_dpr_val_origin_amort
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Amortizaá∆o VO"
        column-label "Amortizaá∆o VO"
        no-undo.
    def var v_val_origin_corrig
        as decimal
        format "->>>>>,>>>,>>9.99":U
        decimals 4
        label "Val Origin Corrigido"
        column-label "Val Origin Corrigido"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_val_original = 0
           v_val_dpr_val_origin = 0
           v_val_dpr_cm = 0
           v_val_dpr_incevda_cm = 0
           v_val_dpr_incevda_val_origin = 0
           v_val_cm_dpr = 0
           v_val_cm_dpr_incevda = 0
           v_val_cm = 0
           v_val_dpr_val_origin_amort = 0
           v_val_dpr_cm_amort = 0
           v_val_amort_incevda_origin = 0
           v_val_sdo_cust_atrib = 0.
    for each  param_calc_bem_pat no-lock
        where param_calc_bem_pat.num_id_bem_pat = p_bem_pat.num_id_bem_pat
        and   param_calc_bem_pat.cod_tip_calc = ''
        break by param_calc_bem_pat.cod_cenar_ctbl
              by param_calc_bem_pat.cod_finalid_econ:
        for last sdo_bem_pat no-lock
            where sdo_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat
            and   sdo_bem_pat.num_seq_incorp_bem_pat = 0
            and   sdo_bem_pat.cod_cenar_ctbl = param_calc_bem_pat.cod_cenar_ctbl
            and   sdo_bem_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   sdo_bem_pat.dat_sdo_bem_pat <= p_dat_desmbrto:
            assign v_val_original = v_val_original + round(sdo_bem_pat.val_original,2)
                   v_val_dpr_val_origin = v_val_dpr_val_origin + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm = v_val_dpr_cm + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_dpr_incevda_cm = v_val_dpr_incevda_cm + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_dpr_incevda_val_origin = v_val_dpr_incevda_val_origin + round(sdo_bem_pat.val_dpr_incevda_val_origin,2)
                   v_val_cm_dpr = v_val_cm_dpr + round(sdo_bem_pat.val_cm_dpr,2)
                   v_val_cm_dpr_incevda = v_val_cm_dpr_incevda + round(sdo_bem_pat.val_cm_dpr_incevda,2)
                   v_val_cm = v_val_cm + round(sdo_bem_pat.val_cm,2)
                   v_val_dpr_val_origin_amort = v_val_dpr_val_origin_amort + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm_amort = v_val_dpr_cm_amort + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_amort_incevda_origin = v_val_amort_incevda_origin + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_sdo_cust_atrib = v_val_sdo_cust_atrib + ROUND(sdo_bem_pat.val_sdo_cust_atrib,2).
        end.
        for each  incorp_bem_pat
            where incorp_bem_pat.num_id_bem_pat = param_calc_bem_pat.num_id_bem_pat,
            last  sdo_bem_pat no-lock
            where sdo_bem_pat.num_id_bem_pat = incorp_bem_pat.num_id_bem_pat
            and   sdo_bem_pat.num_seq_incorp_bem_pat = incorp_bem_pat.num_seq_incorp_bem_pat
            and   sdo_bem_pat.cod_cenar_ctbl = param_calc_bem_pat.cod_cenar_ctbl
            and   sdo_bem_pat.cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
            and   sdo_bem_pat.dat_sdo_bem_pat <= p_dat_desmbrto:
            assign v_val_original = v_val_original + round(sdo_bem_pat.val_original,2)
                   v_val_dpr_val_origin = v_val_dpr_val_origin + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm = v_val_dpr_cm + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_dpr_incevda_cm = v_val_dpr_incevda_cm + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_dpr_incevda_val_origin = v_val_dpr_incevda_val_origin + round(sdo_bem_pat.val_dpr_incevda_val_origin,2)
                   v_val_cm_dpr = v_val_cm_dpr + round(sdo_bem_pat.val_cm_dpr,2)
                   v_val_cm_dpr_incevda = v_val_cm_dpr_incevda + round(sdo_bem_pat.val_cm_dpr_incevda,2)
                   v_val_cm = v_val_cm + round(sdo_bem_pat.val_cm,2)
                   v_val_dpr_val_origin_amort = v_val_dpr_val_origin_amort + round(sdo_bem_pat.val_dpr_val_origin,2)
                   v_val_dpr_cm_amort = v_val_dpr_cm_amort + round(sdo_bem_pat.val_dpr_cm,2)
                   v_val_amort_incevda_origin = v_val_amort_incevda_origin + round(sdo_bem_pat.val_dpr_incevda_cm,2)
                   v_val_sdo_cust_atrib = v_val_sdo_cust_atrib + ROUND(sdo_bem_pat.val_sdo_cust_atrib,2).
        end.
        for each  tt_desmembrto_bem_pat:
            create tt_baixa_bem_pat.
            assign tt_baixa_bem_pat.tta_num_id_bem_pat   = tt_desmembrto_bem_pat.tta_num_id_bem_pat
                   tt_baixa_bem_pat.tta_cod_cenar_ctbl   = param_calc_bem_pat.cod_cenar_ctbl
                   tt_baixa_bem_pat.tta_cod_finalid_econ = param_calc_bem_pat.cod_finalid_econ
                   tt_baixa_bem_pat.ttv_val_baixado[01]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_original,2)
                   tt_baixa_bem_pat.ttv_val_baixado[02]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_val_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[03]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[04]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_incevda_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[05]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_incevda_val_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[06]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm_dpr,2)
                   tt_baixa_bem_pat.ttv_val_baixado[07]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm_dpr_incevda,2)
                   tt_baixa_bem_pat.ttv_val_baixado[08]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_cm,2)
                   tt_baixa_bem_pat.ttv_val_baixado[09]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_val_origin_amort,2)
                   tt_baixa_bem_pat.ttv_val_baixado[10]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_dpr_cm_amort,2)
                   tt_baixa_bem_pat.ttv_val_baixado[11]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_amort_incevda_origin,2)
                   tt_baixa_bem_pat.ttv_val_baixado[12]  = round((tt_desmembrto_bem_pat.tta_val_perc_movto_bem_pat / 100) * v_val_sdo_cust_atrib,2) .
        end.
        assign v_val_original = 0
               v_val_dpr_val_origin = 0
               v_val_dpr_cm = 0
               v_val_dpr_incevda_cm = 0
               v_val_dpr_incevda_val_origin = 0
               v_val_cm_dpr = 0
               v_val_cm_dpr_incevda = 0
               v_val_cm = 0
               v_val_dpr_val_origin_amort = 0
               v_val_dpr_cm_amort = 0
               v_val_amort_incevda_origin = 0
               v_val_sdo_cust_atrib = 0.
    end.
    for each reg_calc_bem_pat no-lock
        where reg_calc_bem_pat.num_id_bem_pat         = b_movto_bem_pat_orig.num_id_bem_pat
        and   reg_calc_bem_pat.dat_calc_pat           = b_movto_bem_pat_orig.dat_movto_bem_pat
        and   reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ 
        and   reg_calc_bem_pat.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/ 
        break by reg_calc_bem_pat.cod_cenar_ctbl
              by reg_calc_bem_pat.cod_finalid_econ
              by reg_calc_bem_pat.num_seq_incorp_bem_pat.
        if trim(reg_calc_bem_pat.cod_tip_calc) = '' then
            assign v_val_original = reg_calc_bem_pat.val_original.
        else do:
            find first tip_calc
                where tip_calc.cod_tip_calc = reg_calc_bem_pat.cod_tip_calc no-lock no-error.   
            if avail tip_calc then do:
                case tip_calc.ind_tip_calc:
                    when "Depreciaá∆o" /*l_depreciacao*/  then
                        assign v_val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                               v_val_dpr_cm = v_val_dpr_cm  + reg_calc_bem_pat.val_dpr_cm
                               v_val_dpr_incevda_val_origin = v_val_dpr_incevda_val_origin + reg_calc_bem_pat.val_dpr_incevda_val_origin
                               v_val_dpr_incevda_cm = v_val_dpr_incevda_cm + reg_calc_bem_pat.val_dpr_incevda_cm
                               v_val_cm_dpr = v_val_cm_dpr + reg_calc_bem_pat.val_cm_dpr
                               v_val_cm_dpr_incevda = v_val_cm_dpr_incevda + reg_calc_bem_pat.val_cm_dpr_incevda.
                    when "Correá∆o Monet†ria" /*l_correcao_monetaria*/  then
                        assign v_val_cm = v_val_cm + reg_calc_bem_pat.val_cm.
                    when "Amortizaá∆o" /*l_amortizacao*/  then
                        assign v_val_dpr_val_origin_amort = v_val_dpr_val_origin_amort + reg_calc_bem_pat.val_dpr_val_origin
                               v_val_dpr_cm_amort = v_val_dpr_cm_amort + reg_calc_bem_pat.val_dpr_cm
                               v_val_amort_incevda_origin = v_val_amort_incevda_origin + reg_calc_bem_pat.val_dpr_incevda_cm.
                end.                           
            end.                           
        end.    
        if last-of(reg_calc_bem_pat.cod_cenar_ctbl) or last-of(reg_calc_bem_pat.cod_finalid_econ)
        or last-of(reg_calc_bem_pat.num_seq_incorp_bem_pat) then do:
            find first sdo_bem_pat
                where sdo_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                and   sdo_bem_pat.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                and   sdo_bem_pat.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                and   sdo_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                and   sdo_bem_pat.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat + 1
                exclusive-lock no-error.
            if avail sdo_bem_pat then do:
                find last b_sdo_bem_pat
                    where b_sdo_bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
                    and   b_sdo_bem_pat.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
                    and   b_sdo_bem_pat.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
                    and   b_sdo_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                    and   b_sdo_bem_pat.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat no-lock no-error.
                if avail b_sdo_bem_pat then do:
                    if (b_sdo_bem_pat.val_original - sdo_bem_pat.val_original) <> v_val_original then
                        assign sdo_bem_pat.val_original    = round(b_sdo_bem_pat.val_original - v_val_original,2)
                               v_val_original = round(b_sdo_bem_pat.val_original - v_val_original,2)
                               v_log_alter = yes.
                    if (b_sdo_bem_pat.val_dpr_val_origin - sdo_bem_pat.val_dpr_val_origin) <> v_val_dpr_val_origin then
                        assign sdo_bem_pat.val_dpr_val_origin = round(b_sdo_bem_pat.val_dpr_val_origin - v_val_dpr_val_origin,2).
                    if (b_sdo_bem_pat.val_dpr_cm - sdo_bem_pat.val_dpr_cm) <> v_val_dpr_cm then
                        assign sdo_bem_pat.val_dpr_cm = round(b_sdo_bem_pat.val_dpr_cm - v_val_dpr_cm,2).
                    if (b_sdo_bem_pat.val_dpr_incevda_val_origin - sdo_bem_pat.val_dpr_incevda_val_origin) <> v_val_dpr_incevda_val_origin then
                        assign sdo_bem_pat.val_dpr_incevda_val_origin = round(b_sdo_bem_pat.val_dpr_incevda_val_origin - v_val_dpr_incevda_val_origin,2).
                    if (b_sdo_bem_pat.val_dpr_incevda_cm - sdo_bem_pat.val_dpr_incevda_cm) <> v_val_dpr_incevda_cm then
                        assign sdo_bem_pat.val_dpr_incevda_cm = round(b_sdo_bem_pat.val_dpr_incevda_cm - v_val_dpr_incevda_cm,2).
                    if (b_sdo_bem_pat.val_cm_dpr - sdo_bem_pat.val_cm_dpr) <> v_val_cm_dpr then
                        assign sdo_bem_pat.val_cm_dpr = round(b_sdo_bem_pat.val_cm_dpr - v_val_cm_dpr,2).
                    if (b_sdo_bem_pat.val_cm - sdo_bem_pat.val_cm) <> v_val_cm then
                        assign sdo_bem_pat.val_cm = round(b_sdo_bem_pat.val_cm - v_val_cm,2)
                        v_log_alter = yes.
                    if (b_sdo_bem_pat.val_cm_dpr_incevda - sdo_bem_pat.val_cm_dpr_incevda) <> v_val_cm_dpr_incevda then
                        assign sdo_bem_pat.val_cm_dpr_incevda = round(b_sdo_bem_pat.val_cm_dpr_incevda - v_val_cm_dpr_incevda,2).
                    if (b_sdo_bem_pat.val_dpr_val_origin_amort - sdo_bem_pat.val_dpr_val_origin_amort) <> v_val_dpr_val_origin_amort then
                        assign sdo_bem_pat.val_dpr_val_origin_amort = round(b_sdo_bem_pat.val_dpr_val_origin_amort - v_val_dpr_val_origin_amort,2).
                    if (b_sdo_bem_pat.val_dpr_cm_amort - sdo_bem_pat.val_dpr_cm_amort) <> v_val_dpr_cm_amort then
                        assign sdo_bem_pat.val_dpr_cm_amort = round(b_sdo_bem_pat.val_dpr_cm_amort - v_val_dpr_cm_amort,2).
                    if (b_sdo_bem_pat.val_amort_incevda_origin - sdo_bem_pat.val_amort_incevda_origin) <> v_val_amort_incevda_origin then
                        assign sdo_bem_pat.val_amort_incevda_origin = round(b_sdo_bem_pat.val_amort_incevda_origin - v_val_amort_incevda_origin,2).
                    assign sdo_bem_pat.val_origin_corrig = round(sdo_bem_pat.val_original + sdo_bem_pat.val_cm,2).
                end.
                else do:
                    run pi_acerta_valores_dif_origem_reg_sdo(output v_log_alter).
                end.
            end.            
            if v_log_alter then do: /* Programa de desmembramento gera dois registros de saldo para a mesma data, precisa ser alterado o valor original dos dois */
                run pi_acerta_valores_dif_origem_sdo.                            
            end.    
            assign v_log_alter                  = no
                   v_val_cm                     = 0
                   v_val_original               = 0
                   v_val_dpr_val_origin         = 0
                   v_val_dpr_cm                 = 0
                   v_val_dpr_incevda_val_origin = 0
                   v_val_dpr_incevda_cm         = 0
                   v_val_cm_dpr                 = 0
                   v_val_cm_dpr_incevda         = 0
                   v_val_dpr_val_origin_amort   = 0
                   v_val_dpr_cm_amort           = 0
                   v_val_amort_incevda_origin   = 0.
        end.        
    end.    
END PROCEDURE. /* pi_verifica_valores_dif_origem_sdo */
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
/*****************************************************************************
** Procedure Interna.....: pi_acerta_dif_desmemb_dpr_val_origin
** Descricao.............: pi_acerta_dif_desmemb_dpr_val_origin
** Criado por............: corp45760
** Criado em.............: 29/09/2015 13:40:09
** Alterado por..........: danielidk
** Alterado em...........: 01/02/2018 11:53:56
*****************************************************************************/
PROCEDURE pi_acerta_dif_desmemb_dpr_val_origin:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_codigo
        as logical
        format "Sim/N∆o"
        no-undo.
    def input-output param p_log_alterado
        as logical
        format "Sim/N∆o"
        no-undo.
    def input-output param p_num_aux
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    IF (sdo_bem_pat.val_perc_dpr_acum = 100) THEN DO:
        FIND FIRST bem_pat NO-LOCK
            WHERE bem_pat.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat NO-ERROR.
        IF AVAIL bem_pat THEN
        FIND FIRST tt_baixa_seq_incorp_bem_pat NO-LOCK
            WHERE  tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
              AND  tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
              AND  tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ NO-ERROR.
            IF AVAIL tt_baixa_seq_incorp_bem_pat THEN DO:
                ASSIGN v_val_dpr_val_origin_2 = tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[02].
            END.
        IF p_num_aux > 0 THEN DO:
            ASSIGN p_num_aux = p_num_aux - 1.
            IF p_log_codigo THEN DO:
                IF v_val_acerto < 0 THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                            assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                   sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                   v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = YES.
                        END.
                        ELSE DO:
                            IF (v_val_dpr_val_origin_2 <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = YES.
                            END.
                            ELSE DO:
                                ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = NO.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF (v_val_dpr_val_origin_2 <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                            assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                   sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                   v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = YES.
                        END.
                        ELSE DO:
                            ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = NO.
                        END.
                    END.
                END.
                ELSE DO:
                    IF v_val_acerto > 0 THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig <> (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                            IF (sdo_bem_pat.val_origin_corrig >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = YES.
                            END.
                            ELSE DO:
                                IF (v_val_dpr_val_origin_2 >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                                    assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                           sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                           v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                           p_log_alterado = YES.
                                END.
                                ELSE DO:
                                    ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                           p_log_alterado = no.
                                END.
                            END.
                        END.
                        ELSE DO:
                            IF (v_val_dpr_val_origin_2 >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = YES.
                            END.
                            ELSE DO:
                                ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = no.
                            END.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                IF v_val_acerto < 0 THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                            assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                   sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                   v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = YES.
                        END.
                        ELSE DO:
                             IF (sdo_bem_pat.val_origin_corrig = (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                                IF (v_val_dpr_val_origin_2 <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                                    assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                           sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                           v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                           p_log_alterado = YES.
                                END.
                                ELSE DO:
                                    ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                           p_log_alterado = NO.
                                END.
                             END.
                             ELSE DO:
                                IF (v_val_dpr_val_origin_2 <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux)))
                                AND (sdo_bem_pat.val_original = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) THEN DO:
                                    assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                           sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                           v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                           p_log_alterado = YES.
                                END.
                                ELSE DO:
                                    IF ((v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin) <> tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[2]) AND p_num_aux = 0 THEN DO:
                                        find last b_sdo_bem_pat_cust no-lock
                                           where  b_sdo_bem_pat_cust.num_id_bem_pat         = p_bem_pat.num_id_bem_pat
                                           and    b_sdo_bem_pat_cust.num_seq_incorp_bem_pat = tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat
                                           and    b_sdo_bem_pat_cust.cod_cenar_ctbl         = tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl  
                                           and    b_sdo_bem_pat_cust.cod_finalid_econ       = tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ
                                           and    b_sdo_bem_pat_cust.dat_sdo_bem_pat       <= reg_calc_bem_pat.dat_calc_pat no-error.
                                        if avail b_sdo_bem_pat_cust then do:
                                            if GetEntryField(1, b_sdo_bem_pat_cust.cod_livre_1, chr(10)) = "0,01" or GetEntryField(1, b_sdo_bem_pat_cust.cod_livre_1, chr(10)) = ",01" then 
                                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                                       p_log_alterado = YES. 
                                        end.                                
                                    END.                    
                                    ELSE
                                        ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                               p_log_alterado = NO.                           
                                END.                           
                             END.
                        END.
                    END.
                    ELSE DO:
                        IF (v_val_dpr_val_origin_2 <= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux)))
                        OR (sdo_bem_pat.val_original = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) THEN DO:
                            assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                   sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                   v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = YES.
                        END.
                        ELSE DO:
                            ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                   p_log_alterado = NO.
                        END.
                    END.
                END.
                ELSE DO:
                    IF v_val_acerto > 0 THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig <> (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                            IF (sdo_bem_pat.val_origin_corrig >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = YES.
                            END.
                            ELSE DO:
                                IF (sdo_bem_pat.val_origin_corrig = (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + reg_calc_bem_pat.val_dpr_cm + reg_calc_bem_pat.val_cm_dpr) THEN DO:
                                    IF (v_val_dpr_val_origin_2 >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux))) THEN DO:
                                        assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                               sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                               v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                               p_log_alterado = YES.
                                    END.
                                    ELSE DO:
                                        ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                               p_log_alterado = no.
                                    END.
                                END.
                                ELSE DO:
                                    IF (v_val_dpr_val_origin_2 >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux)))
                                    AND (sdo_bem_pat.val_original = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) THEN DO:
                                        assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                               sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                               v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                               p_log_alterado = YES.
                                    END.
                                    ELSE DO:
                                        ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                               p_log_alterado = NO.
                                    END.
                                END.
                            END.
                        END.
                        ELSE DO:
                            IF (v_val_dpr_val_origin_2 >= (reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) + (v_val_dpr_val_origin_aux + (reg_calc_bem_pat.val_dpr_val_origin * p_num_aux)))
                            OR (sdo_bem_pat.val_original = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto) THEN DO:
                                assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                                       sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                                       v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = YES.
                            END.
                            ELSE DO:
                                ASSIGN v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + reg_calc_bem_pat.val_dpr_val_origin
                                       p_log_alterado = no.
                            END.
                        END.
                    END.
                END.
            END.
        END.
     END.
     ELSE DO:
         assign reg_calc_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin + v_val_acerto
                sdo_bem_pat.val_dpr_val_origin = reg_calc_bem_pat.val_dpr_val_origin
                p_log_alterado = YES.
    END.
END PROCEDURE. /* pi_acerta_dif_desmemb_dpr_val_origin */
/*****************************************************************************
** Procedure Interna.....: pi_acerta_dif_desmemb_cm_dpr
** Descricao.............: pi_acerta_dif_desmemb_cm_dpr
** Criado por............: corp45760
** Criado em.............: 29/09/2015 13:41:00
** Alterado por..........: corp45760
** Alterado em...........: 30/09/2015 15:14:15
*****************************************************************************/
PROCEDURE pi_acerta_dif_desmemb_cm_dpr:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_log_alterado
        as logical
        format "Sim/N∆o"
        no-undo.
    def input-output param p_num_aux
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* v_val_cm_dpr_aux = vari†vel para acumular o valor implantado para comparar com o valor baixado.
    v_val_cm_dpr_2   = vari†vel para armazenar o valor baixado
    p_log_alterado   = vari†vel(parÉmetro) que indica se deve ou n∆o diminuir do valor da diferenáa entre o valor implantando e o valor baixado
    p_num_aux        = vari†vel(parÉmetro) que indica a quantidade de bens restantes para o acerto
    */

    IF (sdo_bem_pat.val_perc_dpr_acum = 100) THEN DO:
        FIND FIRST tt_baixa_seq_incorp_bem_pat NO-LOCK                                                               
            WHERE  tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
              AND  tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl       
              AND  tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ NO-ERROR.
            IF AVAIL tt_baixa_seq_incorp_bem_pat THEN
                ASSIGN v_val_cm_dpr_2          = tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[06].

        IF p_num_aux > 0 THEN DO:
            ASSIGN p_num_aux = p_num_aux - 1.

            IF v_val_acerto < 0 THEN DO:
                IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_cm_dpr + v_val_acerto + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm) THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <= reg_calc_bem_pat.val_cm_dpr + v_val_acerto + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm) THEN DO:
                        assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
                               sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
                               v_val_cm_dpr_aux   = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                               p_log_alterado        = YES.
                    END.
                    ELSE DO:
                        assign v_val_cm_dpr_aux = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                   p_log_alterado      = NO. 
                    END.
                END.
                ELSE DO:
                    IF (v_val_cm_dpr_2 <= (reg_calc_bem_pat.val_cm_dpr + v_val_acerto) + (v_val_cm_dpr_aux + (reg_calc_bem_pat.val_cm_dpr * p_num_aux))) THEN DO:
                        assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
                               sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
                               v_val_cm_dpr_aux   = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                               p_log_alterado        = YES.
                    END.
                    ELSE DO:
                        assign v_val_cm_dpr_aux = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                               p_log_alterado      = NO. 
                    END.
                END.
            END.
            ELSE DO:
                IF v_val_acerto > 0 THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_cm_dpr + v_val_acerto + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm) THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig >= reg_calc_bem_pat.val_cm_dpr + v_val_acerto + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm) THEN DO:
                            assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
                                   sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
                                   v_val_cm_dpr_aux   = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                   p_log_alterado        = YES.
                        END.
                        ELSE DO:
                            IF (v_val_cm_dpr_2 >= (reg_calc_bem_pat.val_cm_dpr + v_val_acerto) + (v_val_cm_dpr_aux + (reg_calc_bem_pat.val_cm_dpr * p_num_aux))) THEN DO:
                                assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
                                       sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
                                       v_val_cm_dpr_aux   = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                       p_log_alterado        = YES.
                            END.
                            ELSE DO:
                                assign v_val_cm_dpr_aux = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                       p_log_alterado = NO.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF (v_val_cm_dpr_2 >= (reg_calc_bem_pat.val_cm_dpr + v_val_acerto) + (v_val_cm_dpr_aux + (reg_calc_bem_pat.val_cm_dpr * p_num_aux))) THEN DO:
                            assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
                                   sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
                                   v_val_cm_dpr_aux   = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                   p_log_alterado        = YES.
                        END.
                        ELSE DO:
                            assign v_val_cm_dpr_aux = v_val_cm_dpr_aux + reg_calc_bem_pat.val_cm_dpr
                                   p_log_alterado = NO.
                        END.
                    END.
                END.
            END.
        END.
    END.
    ELSE
      assign reg_calc_bem_pat.val_cm_dpr = reg_calc_bem_pat.val_cm_dpr + v_val_acerto
             sdo_bem_pat.val_cm_dpr      = reg_calc_bem_pat.val_cm_dpr
             p_log_alterado        = YES.
END PROCEDURE. /* pi_acerta_dif_desmemb_cm_dpr */
/*****************************************************************************
** Procedure Interna.....: pi_acerta_dif_desmemb_dpr_cm
** Descricao.............: pi_acerta_dif_desmemb_dpr_cm
** Criado por............: corp45760
** Criado em.............: 29/09/2015 13:40:32
** Alterado por..........: corp45760
** Alterado em...........: 30/09/2015 15:14:44
*****************************************************************************/
PROCEDURE pi_acerta_dif_desmemb_dpr_cm:

    /************************ Parameter Definition Begin ************************/

    def input-output param p_log_alterado
        as logical
        format "Sim/N∆o"
        no-undo.
    def input-output param p_num_aux
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* v_val_dpr_cm_aux = vari†vel para acumular o valor implantado para comparar com o valor baixado.
    v_val_dpr_cm_2   = vari†vel para armazenar o valor baixado
    p_log_alterado   = vari†vel(parÉmetro) que indica se deve ou n∆o diminuir do valor da diferenáa entre o valor implantando e o valor baixado
    p_num_aux        = vari†vel(parÉmetro) que indica a quantidade de bens restantes para o acerto  
    */

     IF (sdo_bem_pat.val_perc_dpr_acum = 100) THEN DO:
         FIND FIRST tt_baixa_seq_incorp_bem_pat NO-LOCK                                                               
                WHERE  tt_baixa_seq_incorp_bem_pat.tta_num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                  AND  tt_baixa_seq_incorp_bem_pat.tta_cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl       
                  AND  tt_baixa_seq_incorp_bem_pat.tta_cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ NO-ERROR.
                IF AVAIL tt_baixa_seq_incorp_bem_pat THEN
                    ASSIGN v_val_dpr_cm_2          = tt_baixa_seq_incorp_bem_pat.ttv_val_baixado[03].

         IF p_num_aux > 0 THEN DO:
            ASSIGN p_num_aux = p_num_aux - 1.

            IF v_val_acerto < 0 THEN DO:
                IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_cm_dpr + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm + v_val_acerto) THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <= reg_calc_bem_pat.val_cm_dpr + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm  + v_val_acerto) THEN DO:
                        ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                               sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                               v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                               p_log_alterado        = YES.
                    END.
                    ELSE DO:
                        IF (v_val_dpr_cm_2 <= (reg_calc_bem_pat.val_dpr_cm + v_val_acerto) + (v_val_dpr_cm_aux + (reg_calc_bem_pat.val_dpr_cm * p_num_aux))) THEN DO:
                            ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                                   sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                                   v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                   p_log_alterado        = YES.
                        END.
                        ELSE DO:
                            assign v_val_dpr_cm_aux = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                   p_log_alterado      = NO.
                        END.
                    END.
                END.
                ELSE DO:
                    IF (v_val_dpr_cm_2 <= (reg_calc_bem_pat.val_dpr_cm + v_val_acerto) + (v_val_dpr_cm_aux + (reg_calc_bem_pat.val_dpr_cm * p_num_aux))) THEN DO:
                        ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                               sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                               v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                               p_log_alterado        = YES.
                    END.
                    ELSE DO:
                        assign v_val_dpr_cm_aux = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                               p_log_alterado      = NO.
                    END.
                END.
            END.
            ELSE DO:
                IF v_val_acerto > 0 THEN DO:
                    IF (sdo_bem_pat.val_origin_corrig <> reg_calc_bem_pat.val_cm_dpr + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm  + v_val_acerto) THEN DO:
                        IF (sdo_bem_pat.val_origin_corrig >= reg_calc_bem_pat.val_cm_dpr + reg_calc_bem_pat.val_dpr_val_origin + reg_calc_bem_pat.val_dpr_cm  + v_val_acerto) THEN DO:
                            ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                                   sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                                   v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                   p_log_alterado        = YES.
                        END.
                        ELSE DO:
                            IF (v_val_dpr_cm_2 >= (reg_calc_bem_pat.val_dpr_cm + v_val_acerto) + (v_val_dpr_cm_aux + (reg_calc_bem_pat.val_dpr_cm * p_num_aux))) THEN DO:
                                ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                                       sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                                       v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                       p_log_alterado        = YES.
                            END.
                            ELSE DO:
                                assign v_val_dpr_cm_aux = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                       p_log_alterado      = NO.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF (v_val_dpr_cm_2 >= (reg_calc_bem_pat.val_dpr_cm + v_val_acerto) + (v_val_dpr_cm_aux + (reg_calc_bem_pat.val_dpr_cm * p_num_aux))) THEN DO:
                            ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                                   sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                                   v_val_dpr_cm_aux   = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                   p_log_alterado        = YES.
                        END.
                        ELSE DO:
                            assign v_val_dpr_cm_aux = v_val_dpr_cm_aux + reg_calc_bem_pat.val_dpr_cm
                                   p_log_alterado      = NO.
                        END.
                    END.
                END.
            END.
         END.
     END.
     ELSE
         ASSIGN reg_calc_bem_pat.val_dpr_cm = reg_calc_bem_pat.val_dpr_cm + v_val_acerto
                sdo_bem_pat.val_dpr_cm      = reg_calc_bem_pat.val_dpr_cm
                p_log_alterado        = YES.
END PROCEDURE. /* pi_acerta_dif_desmemb_dpr_cm */
/*****************************************************************************
** Procedure Interna.....: pi_acerta_valores_dif_origem_reg_sdo
** Descricao.............: pi_acerta_valores_dif_origem_reg_sdo
** Criado por............: corp45760
** Criado em.............: 30/09/2015 08:38:51
** Alterado por..........: corp45760
** Alterado em...........: 30/10/2015 16:12:07
*****************************************************************************/
PROCEDURE pi_acerta_valores_dif_origem_reg_sdo:

    /************************ Parameter Definition Begin ************************/

    def output param p_log_altera
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_reg_calc_bem_pat_desmembra
        for reg_calc_bem_pat.
    &endif
    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_sdo_bem_pat_baixa
        for sdo_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_alterou
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_val_dpr_val_origin_aux = 0
           v_val_dpr_cm_aux         = 0
           v_val_cm_dpr_aux         = 0
           v_val_cm_aux             = 0
           v_val_dpr_cm_2           = 0
           v_val_dpr_val_origin_2   = 0
           v_val_cm_dpr_2           = 0
           v_val_cm_2               = 0.

    for each  tt_baixa_bem_pat NO-LOCK
        WHERE tt_baixa_bem_pat.tta_cod_cenar_ctbl   = reg_calc_bem_pat.cod_cenar_ctbl
          AND tt_baixa_bem_pat.tta_cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ:
        assign v_val_dpr_val_origin_aux = v_val_dpr_val_origin_aux + tt_baixa_bem_pat.ttv_val_baixado[02] 
               v_val_dpr_cm_aux         = v_val_dpr_cm_aux + tt_baixa_bem_pat.ttv_val_baixado[03]
               v_val_cm_dpr_aux         = v_val_cm_dpr_aux + tt_baixa_bem_pat.ttv_val_baixado[06]
               v_val_cm_aux             = v_val_cm_aux + tt_baixa_bem_pat.ttv_val_baixado[08].
    END.

    find last b_sdo_bem_pat_baixa
        where b_sdo_bem_pat_baixa.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
        and   b_sdo_bem_pat_baixa.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
        and   b_sdo_bem_pat_baixa.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
        and   b_sdo_bem_pat_baixa.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
        and   b_sdo_bem_pat_baixa.dat_sdo_bem_pat < reg_calc_bem_pat.dat_calc_pat no-lock no-error.
    if avail b_sdo_bem_pat_baixa then DO:
        IF (sdo_bem_pat.val_origin_corrig <> (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin)) AND 
           (sdo_bem_pat.val_perc_dpr_acum = 100) AND (b_movto_bem_pat_orig.val_perc_movto_bem_pat < 100) THEN DO:

            /* Acerta a Correá∆o Monet†ria*/
            IF (v_val_cm > v_val_cm_aux) THEN DO:
                IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) > 0) THEN DO:
                    ASSIGN v_val_cm_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).
                    IF (v_val_cm - v_val_cm_aux) <> v_val_cm_2 THEN
                        ASSIGN v_val_cm_2 = (v_val_cm - v_val_cm_aux)
                               sdo_bem_pat.val_cm = sdo_bem_pat.val_cm - ABS(v_val_cm_2)
                               sdo_bem_pat.val_origin_corrig = round(sdo_bem_pat.val_original + sdo_bem_pat.val_cm,2).
                    ELSE
                        ASSIGN sdo_bem_pat.val_cm = sdo_bem_pat.val_cm - ABS(v_val_cm_2)
                               sdo_bem_pat.val_origin_corrig = round(sdo_bem_pat.val_original + sdo_bem_pat.val_cm,2).
                END.
                ELSE DO: 
                    IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_cm_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).
                        IF (v_val_cm - v_val_cm_aux) <> v_val_cm_2 THEN
                            ASSIGN v_val_cm_2 = (v_val_cm - v_val_cm_aux)
                                   sdo_bem_pat.val_cm = sdo_bem_pat.val_cm + ABS(v_val_cm_2)
                                   sdo_bem_pat.val_origin_corrig = round(sdo_bem_pat.val_original + sdo_bem_pat.val_cm,2).
                        ELSE
                            ASSIGN sdo_bem_pat.val_cm = sdo_bem_pat.val_cm + ABS(v_val_cm_2)
                                   sdo_bem_pat.val_origin_corrig = round(sdo_bem_pat.val_original + sdo_bem_pat.val_cm,2).
                    END.
                END.
            END.

            /* Acerta a Depreciaá∆o do Valor Original*/
            IF (v_val_dpr_val_origin > v_val_dpr_val_origin_aux) THEN DO:
                IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) > 0) THEN DO:
                    ASSIGN v_val_dpr_val_origin_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).

                    IF (v_val_dpr_val_origin - v_val_dpr_val_origin_aux) <> v_val_dpr_val_origin_2 THEN
                        ASSIGN v_val_dpr_val_origin_2       = (v_val_dpr_val_origin - v_val_dpr_val_origin_aux)
                               sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                    ELSE
                        ASSIGN sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                END.
                ELSE DO:
                    IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_dpr_val_origin_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).
                        IF (v_val_dpr_val_origin - v_val_dpr_val_origin_aux) <> v_val_dpr_val_origin_2 THEN
                            ASSIGN v_val_dpr_val_origin_2       = (v_val_dpr_val_origin - v_val_dpr_val_origin_aux)
                                   sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
                        ELSE
                            ASSIGN sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
                    END.
                END.
            END.
            ELSE DO:            
                IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) > 0) THEN
                    ASSIGN v_val_dpr_val_origin_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin)
                           sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                ELSE
                    IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) < 0) THEN
                        ASSIGN v_val_dpr_val_origin_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin)
                               sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
            END.

            /* Acerta a Depreciaá∆o da Correá∆o Monet†ria*/
            IF (v_val_dpr_cm > v_val_dpr_cm_aux) THEN DO:
                IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) > 0) THEN  DO:
                    ASSIGN v_val_dpr_cm_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).
                    IF (v_val_dpr_cm - v_val_dpr_cm_aux) <> v_val_dpr_cm_2 THEN 
                        ASSIGN v_val_dpr_cm_2 = (v_val_dpr_cm - v_val_dpr_cm_aux)
                               sdo_bem_pat.val_dpr_cm = sdo_bem_pat.val_dpr_cm + ABS(v_val_dpr_cm_2).
                    ELSE
                        ASSIGN sdo_bem_pat.val_dpr_cm = sdo_bem_pat.val_dpr_cm + ABS(v_val_dpr_cm_2).
                END.
                ELSE DO:
                    IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_dpr_cm_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin).
                        IF (v_val_dpr_cm - v_val_dpr_cm_aux) <> v_val_dpr_cm_2 THEN 
                            ASSIGN v_val_dpr_cm_2 = (v_val_dpr_cm - v_val_dpr_cm_aux)
                                   sdo_bem_pat.val_dpr_cm = sdo_bem_pat.val_dpr_cm - ABS(v_val_dpr_cm_2).
                        ELSE
                            ASSIGN sdo_bem_pat.val_dpr_cm = sdo_bem_pat.val_dpr_cm - ABS(v_val_dpr_cm_2).
                    END.
                END.
            END.

            /* Acerta a Correá∆o Monet†ria da Depreciaá∆o*/
            IF (v_val_cm_dpr > v_val_cm_dpr_aux) THEN DO:
                IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) > 0) THEN  DO:
                    ASSIGN v_val_cm_dpr_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin)
                           sdo_bem_pat.val_cm_dpr = sdo_bem_pat.val_cm_dpr + ABS(v_val_cm_dpr_2).
                END.
                ELSE DO:
                    IF (sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_cm_dpr_2 = sdo_bem_pat.val_origin_corrig - (sdo_bem_pat.val_dpr_cm + sdo_bem_pat.val_cm_dpr + sdo_bem_pat.val_dpr_val_origin)
                               sdo_bem_pat.val_cm_dpr = sdo_bem_pat.val_cm_dpr - ABS(v_val_cm_dpr_2).
                    END.
                END.
            END.
        END.
        ELSE DO:
            IF b_movto_bem_pat_orig.val_perc_movto_bem_pat < 100 THEN DO:
                IF (v_val_dpr_val_origin > v_val_original) AND (sdo_bem_pat.val_dpr_val_origin > 0) THEN
                    ASSIGN v_val_dpr_val_origin_2 = v_val_dpr_val_origin - v_val_original
                           sdo_bem_pat.val_dpr_val_origin = sdo_bem_pat.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).

                IF (v_val_cm_dpr > v_val_cm_dpr_aux) AND (sdo_bem_pat.val_cm_dpr > 0) THEN DO:
                    ASSIGN v_val_cm_dpr_2 = v_val_cm_dpr - v_val_cm_dpr_aux
                           sdo_bem_pat.val_cm_dpr = sdo_bem_pat.val_cm_dpr + ABS(v_val_cm_dpr_2).
                END.
            END.
        END.

        IF v_val_dpr_val_origin_2 <> 0 OR v_val_cm_2 <> 0 OR v_val_dpr_cm_2 <> 0 OR v_val_cm_dpr_2 <> 0 THEN
            ASSIGN v_log_alterou = yes
                   p_log_altera  = yes.
    END.                                  

    IF v_log_alterou THEN DO:
        FOR EACH b_reg_calc_bem_pat_desmembra exclusive-lock
            where b_reg_calc_bem_pat_desmembra.num_id_bem_pat         = b_movto_bem_pat_orig.num_id_bem_pat
            and   b_reg_calc_bem_pat_desmembra.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
            and   b_reg_calc_bem_pat_desmembra.cod_tip_calc          <> ''
            and   b_reg_calc_bem_pat_desmembra.cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl  
            and   b_reg_calc_bem_pat_desmembra.cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
            and   b_reg_calc_bem_pat_desmembra.dat_calc_pat           = b_movto_bem_pat_orig.dat_movto_bem_pat
            and   b_reg_calc_bem_pat_desmembra.ind_orig_calc_bem_pat  = "Desmembramento" /*l_desmembramento*/ 
            and   b_reg_calc_bem_pat_desmembra.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/ :
        /* IF AVAIL b_reg_calc_bem_pat_desmembra THEN DO:*/
            /* Acerta a Depreciaá∆o do Valor Original*/
            IF v_val_dpr_val_origin_2 <> 0 AND b_reg_calc_bem_pat_desmembra.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  THEN
                IF v_val_dpr_val_origin_2 > 0 THEN
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_dpr_val_origin = b_reg_calc_bem_pat_desmembra.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
                ELSE
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_dpr_val_origin = b_reg_calc_bem_pat_desmembra.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).

            /* Acerta a Depreciaá∆o da Correá∆o Monet†ria*/
            IF v_val_dpr_cm_2 <> 0 AND b_reg_calc_bem_pat_desmembra.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  THEN 
                IF v_val_dpr_cm_2 > 0 THEN
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_dpr_cm = b_reg_calc_bem_pat_desmembra.val_dpr_cm - ABS(v_val_dpr_cm_2).
                ELSE
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_dpr_cm = b_reg_calc_bem_pat_desmembra.val_dpr_cm + ABS(v_val_dpr_cm_2).

            /* Acerta a Correá∆o Monet†ria da Depreciaá∆o*/
            IF v_val_cm_dpr_2 <> 0 AND b_reg_calc_bem_pat_desmembra.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/  THEN 
                IF v_val_cm_dpr_2 > 0 THEN
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_cm_dpr = b_reg_calc_bem_pat_desmembra.val_cm_dpr - ABS(v_val_cm_dpr_2).
                ELSE
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_dpr_cm = b_reg_calc_bem_pat_desmembra.val_cm_dpr + ABS(v_val_cm_dpr_2).

            /* Acerta a Correá∆o Monet†ria*/
            IF v_val_cm_2 <> 0 AND b_reg_calc_bem_pat_desmembra.ind_tip_calc = "Correá∆o Monet†ria" /*l_correcao_monetaria*/  THEN
                IF v_val_cm_2 > 0 THEN
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_cm = b_reg_calc_bem_pat_desmembra.val_cm - ABS(v_val_cm_2)
                           b_reg_calc_bem_pat_desmembra.val_origin_corrig = v_val_original + b_reg_calc_bem_pat_desmembra.val_cm.
                ELSE
                    ASSIGN b_reg_calc_bem_pat_desmembra.val_cm = b_reg_calc_bem_pat_desmembra.val_cm + ABS(v_val_cm_2)
                           b_reg_calc_bem_pat_desmembra.val_origin_corrig = v_val_original + b_reg_calc_bem_pat_desmembra.val_cm.

        END.
    END.
END PROCEDURE. /* pi_acerta_valores_dif_origem_reg_sdo */
/*****************************************************************************
** Procedure Interna.....: pi_acerta_valores_dif_origem_sdo
** Descricao.............: pi_acerta_valores_dif_origem_sdo
** Criado por............: corp45760
** Criado em.............: 30/09/2015 09:15:42
** Alterado por..........: corp45760
** Alterado em...........: 30/10/2015 16:13:16
*****************************************************************************/
PROCEDURE pi_acerta_valores_dif_origem_sdo:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_sdo_bem_pat_baixa
        for sdo_bem_pat.
    &endif


    /*************************** Buffer Definition End **************************/

    find last b_sdo_bem_pat_baixa
        where b_sdo_bem_pat_baixa.num_id_bem_pat = reg_calc_bem_pat.num_id_bem_pat
        and   b_sdo_bem_pat_baixa.cod_cenar_ctbl = reg_calc_bem_pat.cod_cenar_ctbl
        and   b_sdo_bem_pat_baixa.cod_finalid_econ = reg_calc_bem_pat.cod_finalid_econ
        and   b_sdo_bem_pat_baixa.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
        and   b_sdo_bem_pat_baixa.dat_sdo_bem_pat = reg_calc_bem_pat.dat_calc_pat + 1
        exclusive-lock no-error.
    if avail b_sdo_bem_pat_baixa then do:
        assign b_sdo_bem_pat_baixa.val_original      = round(sdo_bem_pat.val_original,2)
               b_sdo_bem_pat_baixa.val_origin_corrig = round(b_sdo_bem_pat_baixa.val_original + b_sdo_bem_pat_baixa.val_cm,2).
        IF (b_sdo_bem_pat_baixa.val_origin_corrig <> (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin)) AND 
           (b_sdo_bem_pat_baixa.val_perc_dpr_acum = 100) AND (b_movto_bem_pat_orig.val_perc_movto_bem_pat < 100) THEN DO:
            /* Acerta a Correá∆o Monet†ria*/
            IF (v_val_cm > v_val_cm_aux) THEN DO:
                IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) > 0) THEN DO:
                    ASSIGN v_val_cm_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                    IF (v_val_cm - v_val_cm_aux) <> v_val_cm_2 THEN
                        ASSIGN v_val_cm_2 = (v_val_cm - v_val_cm_aux)
                               b_sdo_bem_pat_baixa.val_cm = b_sdo_bem_pat_baixa.val_cm - ABS(v_val_cm_2)
                               b_sdo_bem_pat_baixa.val_origin_corrig = round(b_sdo_bem_pat_baixa.val_original + b_sdo_bem_pat_baixa.val_cm,2).
                    ELSE
                        ASSIGN b_sdo_bem_pat_baixa.val_cm = b_sdo_bem_pat_baixa.val_cm - ABS(v_val_cm_2)
                               b_sdo_bem_pat_baixa.val_origin_corrig = round(b_sdo_bem_pat_baixa.val_original + b_sdo_bem_pat_baixa.val_cm,2).
                END.
                ELSE DO:
                    IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_cm_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                        IF (v_val_cm - v_val_cm_aux) <> v_val_cm_2 THEN
                            ASSIGN v_val_cm_2 = (v_val_cm - v_val_cm_aux)
                                   b_sdo_bem_pat_baixa.val_cm = b_sdo_bem_pat_baixa.val_cm + ABS(v_val_cm_2)
                                   b_sdo_bem_pat_baixa.val_origin_corrig = round(b_sdo_bem_pat_baixa.val_original + b_sdo_bem_pat_baixa.val_cm,2).
                        ELSE
                            ASSIGN b_sdo_bem_pat_baixa.val_cm = b_sdo_bem_pat_baixa.val_cm + ABS(v_val_cm_2)
                                   b_sdo_bem_pat_baixa.val_origin_corrig = round(b_sdo_bem_pat_baixa.val_original + b_sdo_bem_pat_baixa.val_cm,2).
                    END.
                END.
            END.
            /* Acerta a Depreciaá∆o do Valor Original*/
            IF (v_val_dpr_val_origin > v_val_dpr_val_origin_aux) THEN DO:
                IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) > 0) THEN DO:
                    ASSIGN v_val_dpr_val_origin_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                    IF (v_val_dpr_val_origin - v_val_dpr_val_origin_aux) <> v_val_dpr_val_origin_2 THEN
                        ASSIGN v_val_dpr_val_origin_2               = (v_val_dpr_val_origin - v_val_dpr_val_origin_aux)
                               b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                    ELSE
                        ASSIGN b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                END.
                ELSE DO:
                    IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_dpr_val_origin_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                        IF (v_val_dpr_val_origin - v_val_dpr_val_origin_aux) <> v_val_dpr_val_origin_2 THEN
                            ASSIGN v_val_dpr_val_origin_2               = (v_val_dpr_val_origin - v_val_dpr_val_origin_aux)
                                   b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
                        ELSE
                            ASSIGN b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
                    END.
                END.
            END. 
            ELSE DO:
                IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) > 0) THEN
                    ASSIGN v_val_dpr_val_origin_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin)
                           b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                ELSE
                    IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) < 0) THEN
                        ASSIGN v_val_dpr_val_origin_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin)
                               b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin - ABS(v_val_dpr_val_origin_2).
            END.
            /* Acerta a Depreciaá∆o da Correá∆o Monet†ria*/
            IF (v_val_dpr_cm > v_val_dpr_cm_aux) THEN DO:
                IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) > 0) THEN DO:
                    ASSIGN v_val_dpr_cm_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                    IF (v_val_dpr_cm - v_val_dpr_cm_aux) <> v_val_dpr_cm_2 THEN 
                        ASSIGN v_val_dpr_cm_2        = (v_val_dpr_cm - v_val_dpr_cm_aux)
                               b_sdo_bem_pat_baixa.val_dpr_cm = b_sdo_bem_pat_baixa.val_dpr_cm + ABS(v_val_dpr_cm_2).
                    ELSE
                        ASSIGN b_sdo_bem_pat_baixa.val_dpr_cm = b_sdo_bem_pat_baixa.val_dpr_cm + ABS(v_val_dpr_cm_2).
                END.
                ELSE DO:
                    IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) < 0) THEN DO:
                        ASSIGN v_val_dpr_cm_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin).
                        IF (v_val_dpr_cm - v_val_dpr_cm_aux) <> v_val_dpr_cm_2 THEN 
                            ASSIGN v_val_dpr_cm_2 = (v_val_dpr_cm - v_val_dpr_cm_aux)
                                   b_sdo_bem_pat_baixa.val_dpr_cm = b_sdo_bem_pat_baixa.val_dpr_cm - ABS(v_val_dpr_cm_2).
                        ELSE
                            ASSIGN b_sdo_bem_pat_baixa.val_dpr_cm = b_sdo_bem_pat_baixa.val_dpr_cm - ABS(v_val_dpr_cm_2).
                    END.
                END.
            END.
            /* Acerta a Correá∆o Monet†ria da Depreciaá∆o*/
            IF (v_val_cm_dpr > v_val_cm_dpr_aux) THEN DO:
                IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) > 0) THEN
                    ASSIGN v_val_cm_dpr_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin)
                           b_sdo_bem_pat_baixa.val_cm_dpr = b_sdo_bem_pat_baixa.val_cm_dpr + ABS(v_val_cm_dpr_2).
                ELSE
                    IF (b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin) < 0) THEN
                        ASSIGN v_val_cm_dpr_2 = b_sdo_bem_pat_baixa.val_origin_corrig - (b_sdo_bem_pat_baixa.val_dpr_cm + b_sdo_bem_pat_baixa.val_cm_dpr + b_sdo_bem_pat_baixa.val_dpr_val_origin)
                               b_sdo_bem_pat_baixa.val_cm_dpr = b_sdo_bem_pat_baixa.val_cm_dpr - ABS(v_val_cm_dpr_2).
            END.
        END.
        ELSE DO:
            IF b_movto_bem_pat_orig.val_perc_movto_bem_pat < 100 THEN DO:
                IF (v_val_dpr_val_origin > v_val_original) AND (b_sdo_bem_pat_baixa.val_dpr_val_origin > 0) THEN        
                    ASSIGN v_val_dpr_val_origin_2 = v_val_dpr_val_origin - v_val_original
                           b_sdo_bem_pat_baixa.val_dpr_val_origin = b_sdo_bem_pat_baixa.val_dpr_val_origin + ABS(v_val_dpr_val_origin_2).
                IF (v_val_cm_dpr > v_val_cm_dpr_aux) AND (b_sdo_bem_pat_baixa.val_cm_dpr > 0) THEN
                    ASSIGN v_val_cm_dpr_2 = v_val_cm_dpr - v_val_cm_dpr_aux
                           b_sdo_bem_pat_baixa.val_cm_dpr = b_sdo_bem_pat_baixa.val_cm_dpr + ABS(v_val_cm_dpr_2).
            END.
        END.
    END.
END PROCEDURE. /* pi_acerta_valores_dif_origem_sdo */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/
&endif

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
        message getStrTrans("Mensagem nr. ", "FAS") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "FAS") c_prg_msg getStrTrans("n∆o encontrado.", "FAS")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/****************************  End of fnc_bem_pat ***************************/
