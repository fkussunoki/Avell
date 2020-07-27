/* por enquanto esta variável ñ pode ficar definida pois 
   dará erro de duplicacao com a utp\utglob.i
DEF                   var rw-log-exec as rowid no-undo.*/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)"
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cenar_ctbl
    as character
    format "x(8)"
    label "Cen rio Cont bil"
    column-label "Cen rio Cont bil"
    no-undo.
def var v_cod_dwb_program
    as character
    format "x(32)"
    label "Programa"
    column-label "Programa"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)"
    label "Usu rio"
    column-label "Usu rio"
    no-undo.
def var v_cod_empresa
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_exerc_ctbl
    as character
    format "9999"
    label "Exerc¡cio Cont bil"
    column-label "Exerc¡cio Cont bil"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)"
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)"
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)"
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)"
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)"
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_return
    as character
    format "x(40)"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)"
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)"
    no-undo.
def var v_dat_lancto_ctbl
    as date
    format "99/99/9999"
    label "Data Lan‡amento"
    column-label "Data Lan‡to"
    no-undo.
def var v_dat_validade
    as date
    format "99/99/9999"
    label "Data de Validade"
    column-label "Data de Validade"
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)"
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)"
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)"
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)"
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9"
    no-undo.
def var v_num_period_ctbl
    as integer
    format ">99"
    initial 01
    label "Per¡odo Atual"
    column-label "Period"
    no-undo.
def new global shared var v_rec_cenar_ctbl
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def new global shared var v_rec_dwb_set_list_param
    as recid
    format ">>>>>>9"
    no-undo.
def new global shared var v_rec_empresa
    as recid
    format ">>>>>>9"
    no-undo.
def new global shared var v_rec_exerc_ctbl
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9"
    no-undo.
def new global shared var v_rec_period_ctbl
    as recid
    format ">>>>>>9"
    label "Per¡odo Cont bil"
    no-undo.
def new global shared var v_rec_sdo_cta_ctbl
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9"
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9"
    no-undo.

/* Transformacaoo Window */
&IF DEFINED(TransformacaoWindow) <> 0 &THEN
&ELSE
    if session:window-system <> "TTY" then do:
      &global-define TransformacaoWindow OK
      {include/i-win.i}
      define var h-prog     as handle  no-undo.
      define var h-pai      as handle  no-undo.
      define var c-prog-tec as char    no-undo format "x(256)".
      define var i-template as integer no-undo.
    end.  
&ENDIF
/* Transformacaoo Window */
