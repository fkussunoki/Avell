/**************************************************************************
** Include : padrao para Setar a Saida  do relatorio - ems50             **
** Autor   : Ivan                                                        **
** Data    : 25/05/2001                                                  **
** Parametros: {&stream}     = nome do stream de saida no formato "stream nome"
**             {&destino}    = c-destino                                 **
**             {&arquivo}    = c-arquivo                                 **
**             {&impressora} = c-impressora                              **
**             {&layout}     = c-layout                                  **
**             {&qtd-linhas} = i-qtd-linhas                              **
***************************************************************************/

&IF DEFINED(destino)    = 0 &THEN 
    &SCOPED-DEFINE destino    c-destino    
&ENDIF
&IF DEFINED(arquivo)    = 0 &THEN 
    &SCOPED-DEFINE arquivo    c-arquivo    
&ENDIF
&IF DEFINED(impressora) = 0 &THEN 
    &SCOPED-DEFINE impressora c-impressora 
&ENDIF
&IF DEFINED(layout)     = 0 &THEN 
    &SCOPED-DEFINE layout     c-layout     
&ENDIF
&IF DEFINED(qtd-linhas) = 0 &THEN 
    &SCOPED-DEFINE qtd-linhas i-qtd-linhas 
&ENDIF

DO:  /* seta a saida da impressao */
    CASE {&destino}:
        WHEN "Terminal" /*l_terminal*/  THEN DO:
            OUTPUT {&stream} TO VALUE({&arquivo}) PAGED PAGE-SIZE VALUE({&qtd-linhas}) convert target 'iso8859-1'.
        END.
        WHEN "Impressora" /*l_printer*/ THEN DO:
            FIND FIRST imprsor_usuar NO-LOCK USE-INDEX imprsrsr_id
                 WHERE imprsor_usuar.nom_impressora = {&impressora}
                   AND imprsor_usuar.cod_usuario    = v_cod_dwb_user NO-ERROR.
            FIND FIRST layout_impres NO-LOCK
                 WHERE layout_impres.nom_impressora    = {&impressora}
                   AND layout_impres.cod_layout_impres = {&layout} NO-ERROR.

            ASSIGN  {&qtd-linhas}  = layout_impres.num_lin_pag.

            IF  OPSYS = "UNIX" THEN DO:
                IF  v_num_ped_exec_corren <> 0 THEN DO:
                    FIND FIRST ped_exec NO-LOCK
                         WHERE ped_exec.num_ped_exec = v_num_ped_exec_corren NO-ERROR.
                    IF  AVAIL ped_exec THEN DO:
                        FIND FIRST servid_exec_imprsor NO-LOCK
                             WHERE servid_exec_imprsor.cod_servid_exec = ped_exec.cod_servid_exec
                               AND servid_exec_imprsor.nom_impressora  = {&impressora} NO-ERROR.
                        IF  AVAIL servid_exec_imprsor THEN 
                            OUTPUT {&stream} THROUGH VALUE(servid_exec_imprsor.nom_disposit_so)
                                   PAGED PAGE-SIZE VALUE({&qtd-linhas}) CONVERT TARGET 'iso8859-1'.
                        ELSE
                            OUTPUT {&stream} THROUGH VALUE(imprsor_usuar.nom_disposit_so)
                                PAGED PAGE-SIZE VALUE({&qtd-linhas}) CONVERT TARGET 'iso8859-1'.
                    END.
                END.
                ELSE
                    OUTPUT {&stream} THROUGH VALUE(imprsor_usuar.nom_disposit_so)
                        PAGED PAGE-SIZE VALUE({&qtd-linhas}) CONVERT TARGET 'iso8859-1'.
            END.
            ELSE DO:
                /**********************************************************/
                FIND FIRST tip_imprsor NO-LOCK
                    WHERE tip_imprsor.cod_tip_imprsor = layout_impres.cod_tip_imprsor NO-ERROR.
                /*********************************************************/

                OUTPUT {&stream} TO VALUE(imprsor_usuar.nom_disposit_so)
                       PAGED PAGE-SIZE VALUE({&qtd-linhas}) CONVERT TARGET tip_imprsor.cod_pag_carac_conver /*'iso8859-1'*/ .
            END.

            /*************************************************************/

            for each configur_layout_impres no-lock
                where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                by configur_layout_impres.num_ord_funcao_imprsor:

                find configur_tip_imprsor no-lock
                    where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                    and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                    and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                    use-index cnfgrtpm_id no-error.

                do v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                  case configur_tip_imprsor.num_carac_configur[v_num_count]:
                    when 0 then put {&stream} control null.
                    when ? then leave.
                    otherwise   put {&stream} control CODEPAGE-CONVERT(chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                       session:cpinternal, 
                                                                       tip_imprsor.cod_pag_carac_conver).
                  end case.
                end.
            end.
            /**************************************************************/

            /*
            FOR EACH configur_layout_impres NO-LOCK
               WHERE configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                  BY configur_layout_impres.num_ord_funcao_imprsor:

                FIND FIRST configur_tip_imprsor NO-LOCK 
                     WHERE configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                       AND configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                       AND configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor NO-ERROR.
                PUT {&stream} CONTROL configur_tip_imprsor.cod_comando_configur.
            END.
            */

        END.
        WHEN "Arquivo" /*l_file*/  THEN DO:
            OUTPUT {&stream} TO VALUE({&arquivo})
                   PAGED PAGE-SIZE VALUE({&qtd-linhas}) CONVERT TARGET 'iso8859-1'.

        END.
    END.
END.

/*/*****************************************************************************
** Procedure Interna.....: pi_set_print_layout_default
** Descricao.............: pi_set_print_layout_default
** Criado por............: Gilsinei
** Criado em.............: 04/03/1996 09:22:54
** Alterado por..........: izaura
** Alterado em...........: 09/06/1998 10:17:42
** Gerado por............: BRE17183
*****************************************************************************/
PROCEDURE pi_set_print_layout_default:

    dflt:
    do with frame f_rpt_40_ser_fisc_nota:

        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = v_cod_dwb_user
               and layout_impres_padr.cod_proced = v_cod_dwb_proced
             use-index lytmprsp_id /*cl_default_procedure_user of layout_impres_padr*/ no-error.
        if  not avail layout_impres_padr
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = "*"
                   and layout_impres_padr.cod_proced = v_cod_dwb_proced
                 use-index lytmprsp_id /*cl_default_procedure of layout_impres_padr*/ no-error.
            if  avail layout_impres_padr
            then do:
                find imprsor_usuar no-lock
                     where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                       and imprsor_usuar.cod_usuario = v_cod_dwb_user
                     use-index imprsrsr_id /*cl_layout_current_user of imprsor_usuar*/ no-error.
            end /* if */.
            if  not avail imprsor_usuar
            then do:
                find layout_impres_padr no-lock
                     where layout_impres_padr.cod_usuario = v_cod_dwb_user
                       and layout_impres_padr.cod_proced = "*"
                     use-index lytmprsp_id /*cl_default_user of layout_impres_padr*/ no-error.
            end /* if */.
        end /* if */.
        do transaction:
            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            if  avail layout_impres_padr
            then do:
                assign dwb_rpt_param.nom_dwb_printer      = layout_impres_padr.nom_impressora
                       dwb_rpt_param.cod_dwb_print_layout = layout_impres_padr.cod_layout_impres
                       ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                            + ":"
                                            + dwb_rpt_param.cod_dwb_print_layout.
            end /* if */.
            else do:
                assign dwb_rpt_param.nom_dwb_printer       = ""
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       ed_1x40:screen-value = "".
            end /* else */.
        end.
    end /* do dflt */.
END PROCEDURE. /* pi_set_print_layout_default */*/
