/*****************************************************************************
*****************************************************************************/

def var c-versao-prg as char initial " 5.12.16.100":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_gerac_planilha_demont_ctbl MGL}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=4":U.
/*************************************  *************************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def shared var v_cod_arq_planilha
    as character
    format "x(40)":U
    label "Arq Planilha"
    column-label "Arq Planilha"
    no-undo.
def shared var v_cod_carac_lim
    as character
    format "x(1)":U
    initial ";"
    label "Caracter Delimitador"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
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
def shared var v_ind_tip_arq_planilha
    as character
    format "X(08)":U
    view-as radio-set Vertical
    radio-buttons "Relat¢rio", "Relat¢rio","Exportaá∆o", "Exportaá∆o"
     /*l_relatorio*/ /*l_relatorio*/ /*l_exportacao*/ /*l_exportacao*/
    bgcolor 8 
    label "Tipo Arquivo"
    column-label "Tipo Arquivo"
    no-undo.
def shared var v_log_gerac_planilha
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Planilha"
    no-undo.
def shared var v_log_impr_desc_visualiz
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Impr Desc Visualiz"
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial ?
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def shared var v_nom_prog_ext_aux
    as character
    format "x(8)":U
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def shared var v_rec_dwb_rpt_param
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_cod_get_file                   as character       no-undo. /*local*/
def var v_log_pressed                    as logical         no-undo. /*local*/


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
/****************************** Function Button *****************************/


/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl
    rt_001
         at row 01.38 col 02.14 bgcolor 8 
    rt_002
         at row 04.42 col 03.00 bgcolor 8 
    rt_cxcf
         at row 07.63 col 02.00 bgcolor 7 
    v_log_gerac_planilha
         at row 01.63 col 06.00 label "Gerar Arquivo Planilha"
         view-as toggle-box
    v_ind_tip_arq_planilha
         at row 01.63 col 35.00 colon-aligned label "Tipo Arquivo"
         help "Informe o tipo de arquivo a ser gerado"
         view-as radio-set Vertical
         radio-buttons "Relat¢rio", "Relat¢rio","Exportaá∆o", "Exportaá∆o"
          /*l_relatorio*/ /*l_relatorio*/ /*l_exportacao*/ /*l_exportacao*/
         bgcolor 8 
    v_log_impr_desc_visualiz
         at row 03.50 col 28.00 label "Impr Desc Visualizaá∆o"
         help "Imprime Descriá∆o da Visualizaá∆o"
         view-as toggle-box
    bt_get_file
         at row 04.75 col 47.00 font ?
         help "Pesquisa Arquivo"
    v_cod_arq_planilha
         at row 04.79 col 05.72 no-label
         help "Arquivo Sa°da para Planilha Eletrìnica"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_carac_lim
         at row 06.00 col 23.72 colon-aligned label "Caracter Delimitador"
         help "Caracter Delimitador de Colunas"
         view-as fill-in
         size-chars 2.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 07.83 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.83 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 07.83 col 42.29 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 54.72 by 09.54 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Geraá∆o Planilha Demonst Ctbl".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars       in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 10.00
           bt_can:height-chars      in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 01.00
           bt_get_file:width-chars  in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 04.00
           bt_get_file:height-chars in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 01.08
           bt_hel2:width-chars      in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 10.00
           bt_hel2:height-chars     in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 01.00
           bt_ok:width-chars        in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 10.00
           bt_ok:height-chars       in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 01.00
           rt_001:width-chars       in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 51.14
           rt_001:height-chars      in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 06.08
           rt_002:width-chars       in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 49.14
           rt_002:height-chars      in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 02.75
           rt_cxcf:width-chars      in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 51.29
           rt_cxcf:height-chars     in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = 01.42.
    /* set private-data for the help system */
    assign v_log_gerac_planilha:private-data     in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000016907":U
           v_ind_tip_arq_planilha:private-data   in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000000000":U
           v_log_impr_desc_visualiz:private-data in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000000000":U
           bt_get_file:private-data              in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000008782":U
           v_cod_arq_planilha:private-data       in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000016908":U
           v_cod_carac_lim:private-data          in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000016909":U
           bt_ok:private-data                    in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000010721":U
           bt_can:private-data                   in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000011050":U
           bt_hel2:private-data                  in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = "HLP=000011326":U
           frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:private-data                             = "HLP=000000000".



{include/i_fclfrm.i f_dlg_03_fnc_gerac_planilha_demonst_ctbl }
/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_get_file IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl
DO:

    system-dialog get-file v_cod_dwb_file
        title "Criando Arquivo" /*l_criando_arquivo*/ 
        filters '*.txt' '*.txt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign v_cod_arq_planilha:screen-value in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = v_cod_dwb_file.
        apply "Entry" /*l_entry*/  to v_cod_arq_planilha in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON VALUE-CHANGED OF v_ind_tip_arq_planilha IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl
DO:

    if  input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_ind_tip_arq_planilha = "Exportaá∆o" /*l_exportacao*/ 
    then do:
        enable v_log_impr_desc_visualiz
               with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
    end /* if */.
    else do:
        assign v_log_impr_desc_visualiz = no.
        disable v_log_impr_desc_visualiz
                with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
    end /* else */.
    display v_log_impr_desc_visualiz
            with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
END. /* ON VALUE-CHANGED OF v_ind_tip_arq_planilha IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON VALUE-CHANGED OF v_log_gerac_planilha IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl
DO:

    if  input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_log_gerac_planilha = yes
    then do:
        if  v_cod_arq_planilha = ""
        then do:
           find usuar_mestre no-lock
             where usuar_mestre.cod_usuario = v_cod_usuar_corren no-error.
           if  avail usuar_mestre
           then do:

            find dwb_rpt_param
            where recid(dwb_rpt_param) = v_rec_dwb_rpt_param no-lock no-error.

              if dwb_rpt_param.ind_dwb_run_mode <> "Batch" /*l_batch*/  THEN DO:
                 if  usuar_mestre.nom_dir_spool <> ""
                 then do:
                    assign v_cod_arq_planilha = usuar_mestre.nom_dir_spool + '~/'.
                 end /* if */.
                 if  usuar_mestre.nom_subdir_spool <> ""
                 then do:
                     assign v_cod_arq_planilha = v_cod_arq_planilha + usuar_mestre.nom_subdir_spool + '~/'.
                 end /* if */.
              end.
              assign v_cod_arq_planilha = v_cod_arq_planilha
                                        + lc(v_nom_prog_ext_aux).
              if  substr(v_cod_dwb_file,r-index(v_cod_dwb_file,chr(46)) + 1) = 'txt'
              then do:
                  assign v_cod_arq_planilha = v_cod_arq_planilha
                                            + '.prn'.
              end /* if */.
              else do:
                  assign v_cod_arq_planilha = v_cod_arq_planilha
                                            + '.txt'.
              end /* else */.          
           end /* if */.
        end /* if */.
        if  v_cod_carac_lim = '' then
            assign v_cod_carac_lim:screen-value in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = ";".

        enable v_cod_arq_planilha
               v_ind_tip_arq_planilha
               v_cod_carac_lim
               with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
        apply "value-changed" to v_ind_tip_arq_planilha in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
    end /* if */.
    else do:
        assign v_cod_arq_planilha     = ""
               v_cod_carac_lim        = ""
               v_ind_tip_arq_planilha = "".
        disable v_cod_arq_planilha
                v_ind_tip_arq_planilha
                v_cod_carac_lim
                with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
    end /* else */.
    display v_cod_arq_planilha
            v_cod_carac_lim
            with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.

END. /* ON VALUE-CHANGED OF v_log_gerac_planilha IN FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */

ON WINDOW-CLOSE OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl
DO:

    apply "end-error" to self.

END. /* ON WINDOW-CLOSE OF FRAME f_dlg_03_fnc_gerac_planilha_demonst_ctbl */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:title, 1, max(1, length(frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "fnc_gerac_planilha_demont_ctbl":U.




    assign v_nom_prog_ext = "prgfin/mgl/escg0204zg.p":U
           v_cod_release  = trim(" 5.12.16.100":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */

{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_gerac_planilha_demont_ctbl}


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
    run pi_version_extract ('fnc_gerac_planilha_demont_ctbl':U, 'prgfin/mgl/escg0204zg.p':U, '5.12.16.100':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "fnc_gerac_planilha_demont_ctbl":U
    no-lock no-error.
if  avail prog_dtsul then do:
    if  prog_dtsul.nom_prog_upc <> ''
    and prog_dtsul.nom_prog_upc <> ? then
        assign v_nom_prog_upc = prog_dtsul.nom_prog_upc.
    if  prog_dtsul.nom_prog_appc <> ''
    and prog_dtsul.nom_prog_appc <> ? then
        assign v_nom_prog_appc = prog_dtsul.nom_prog_appc.
&if '{&emsbas_version}' > '5.00' &then
    if  prog_dtsul.nom_prog_dpc <> ''
    and prog_dtsul.nom_prog_dpc <> ? then
        assign v_nom_prog_dpc = prog_dtsul.nom_prog_dpc.
&endif
end.


assign v_wgh_frame_epc = frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:handle.



&endif

/* End_Include: i_verify_program_epc */


assign v_wgh_focus = v_log_gerac_planilha:handle in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.

pause 0 before-hide.

display bt_can
        bt_get_file
        bt_hel2
        bt_ok
        v_cod_arq_planilha
        v_cod_carac_lim
        v_ind_tip_arq_planilha
        v_log_gerac_planilha
        v_log_impr_desc_visualiz
        with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'DISPLAY',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */


enable all with frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.

/* Begin_Include: i_executa_pi_epc_fin */
run pi_exec_program_epc_FIN (Input 'ENABLE',
                             Input 'no',
                             output v_log_return_epc) /*pi_exec_program_epc_FIN*/.
if v_log_return_epc then /* epc retornou erro*/
    undo, retry.
/* End_Include: i_executa_pi_epc_fin */



/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:title = frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl:title
                            + chr(32)
                            + chr(40)
                            + trim(" 5.12.16.100":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl = menu m_help:handle.


/* End_Include: i_std_dialog_box */

{include/title5.i f_dlg_03_fnc_gerac_planilha_demonst_ctbl FRAME}


apply "value-changed" to v_log_gerac_planilha in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
planilha_block:
do on endkey undo planilha_block, leave planilha_block on error undo planilha_block, retry planilha_block.
    if  valid-handle(v_wgh_focus)
    then do:
        wait-for go of frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl focus v_wgh_focus.
    end /* if */.
    else do:
        wait-for go of frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl focus bt_ok.
    end /* else */.
    run pi_fnc_gerac_planilha /*pi_fnc_gerac_planilha*/.
    if  input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_log_gerac_planilha then do:
        assign input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_ind_tip_arq_planilha.
        if v_ind_tip_arq_planilha = "Exportaá∆o" /*l_exportacao*/  then
            assign input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_log_impr_desc_visualiz.
    end.
end /* do planilha_block */.

assign v_wgh_focus = ?.
hide frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.


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
/*****************************************************************************
** Procedure Interna.....: pi_fnc_gerac_planilha
** Descricao.............: pi_fnc_gerac_planilha
** Criado por............: veber
** Criado em.............: 12/09/1997 09:02:39
** Alterado por..........: src531
** Alterado em...........: 06/05/2002 09:32:32
*****************************************************************************/
PROCEDURE pi_fnc_gerac_planilha:

    /* --- Validar Arquivo p/ Planilha ---*/
    assign input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_log_gerac_planilha
           v_cod_arq_planilha = replace(input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_cod_arq_planilha, "~\", "~/").
    if  v_log_gerac_planilha = yes
    then do:
        find dwb_rpt_param
           where recid(dwb_rpt_param) = v_rec_dwb_rpt_param no-lock no-error.
        if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            assign v_cod_arq_planilha = replace(v_cod_arq_planilha, "~\", "~/").
            if  index(v_cod_arq_planilha, ":") <> 0
            then do:
                /* Nome de arquivo com problemas. */
                run pi_messages (input "show",
                                 input 1979,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                assign v_wgh_focus = v_cod_arq_planilha:handle in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
                return error.
            end /* if */.
            if  length(entry(2, v_cod_arq_planilha, ".")) > 3
            then do:
                assign v_wgh_focus = v_cod_arq_planilha:handle in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
                /* Nome de arquivo com problemas. */
                run pi_messages (input "show",
                                 input 1979,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                return error.
            end /* if */.
        end /* if */.
        else do:
            if  v_cod_arq_planilha = ""
            then do:
                /* &1 n∆o pode ser igual a branco ! */
                run pi_messages (input "show",
                                 input 3703,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    "O Arq Externo Planilha de C†lculo" /*l_arq_ext_plani_cal*/)) /*msg_3703*/.
                return error.
            end /* if */.
        end /* else */.
    end /* if */.
    /* --- Validar Caracter Delimitador ---*/
    if  input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_cod_carac_lim = "" and
        v_log_gerac_planilha = yes
    then do:
        assign v_wgh_focus = v_cod_carac_lim:handle in frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl.
        /* &1 n∆o pode ser igual a branco ! */
        run pi_messages (input "show",
                         input 3703,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            "O Caracter Delimitador" /*l_caracter_delimitador*/)) /*msg_3703*/.
        return error.
    end /* if */.
    assign input frame f_dlg_03_fnc_gerac_planilha_demonst_ctbl v_cod_carac_lim.
END PROCEDURE. /* pi_fnc_gerac_planilha */
/*****************************************************************************
** Procedure Interna.....: pi_exec_program_epc_FIN
** Descricao.............: pi_exec_program_epc_FIN
** Criado por............: src388
** Criado em.............: 09/09/2003 10:48:55
** Alterado por..........: fut1309
** Alterado em...........: 15/02/2006 09:44:03
*****************************************************************************/
PROCEDURE pi_exec_program_epc_FIN:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_event
        as character
        format "x(100)"
        no-undo.
    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_log_return_epc
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* *******************************************************************************************
    ** Objetivo..............: Substituir o c¢digo gerado pela include i_exec_program_epc,
    **                         muitas vezes repetido, com o intuito de evitar estouro de segmento.
    **
    ** Utilizaá∆o............: A utilizaá∆o desta procedure funciona exatamente como a include
    **                         anteriormente utilizada para este fim, para chamar ela deve ser 
    **                         includa a include i_executa_pi_epc_fin no programa, que ira executar 
    **                         esta pi e fazer tratamento para os retornos. Deve ser declarada a 
    **                         variavel v_log_return_epc (caso o parametro ela seja verdade, Ç 
    **                         porque a EPC retornou "NOK". 
    **
    **                         @i(i_executa_pi_epc_fin &event='INITIALIZE' &return='NO')
    **
    **                         Para se ter uma idÇia de como se usa, favor olhar o fonte do apb008za.p
    **
    **
    *********************************************************************************************/

    assign p_log_return_epc = no.
    /* ix_iz1_fnc_gerac_planilha_demont_ctbl */


    /* Begin_Include: i_exec_program_epc_pi_fin */
    if  v_nom_prog_upc <> ''    
    or  v_nom_prog_appc <> ''
    or  v_nom_prog_dpc <> '' then do:
        &if '' <> '' &then
            assign v_rec_table_epc = recid()
                   v_nom_table_epc = ''.
        &else
            assign v_rec_table_epc = ?
                   v_nom_table_epc = "".
        &endif
    end.
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_upc) (input p_cod_event,
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    if  v_nom_prog_appc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_appc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' and not p_log_return_epc
    then do:
        run value(v_nom_prog_dpc) (input p_cod_event,
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  p_cod_return = "yes" /*l_yes*/ 
        and return-value = "NOK" /*l_nok*/  then
            assign p_log_return_epc = yes.
    end /* if */.
    &endif
    &endif

    /* End_Include: i_exec_program_epc_pi_fin */


    /* ix_iz2_fnc_gerac_planilha_demont_ctbl */
END PROCEDURE. /* pi_exec_program_epc_FIN */


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
/******************  End of fnc_gerac_planilha_demont_ctbl ******************/
