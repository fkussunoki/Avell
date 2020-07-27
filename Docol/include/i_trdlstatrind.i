assign {1} = "log_,ind_,cod_contdo_integr_ctbl_ext,cod_dwb_field,cod_dwb_output,cod_dwb_set,cod_finalid_histor_padr,cod_funcao,cod_idiom_padr,cod_inform_organ,cod_liber_despes_viagem,cod_liber_proces_pend,cod_metod_dpr_utiliz,cod_produt_modul,cod_tip_inform,cod_tip_transp_viagem_eec,cod_tip_veic_eec,des_campo_layout_invent,nom_mes_inic_period_impto,cod_label_atrib,cod_label_button,cod_label_msg".

&if "{2}" <> "" &then
   assign {2} = "cod_dwb_set_initial,cod_dwb_set_final,cod_dwb_set_single,cod_dwb_set_parameters,cod_dwb_field_rpt".
&endif
