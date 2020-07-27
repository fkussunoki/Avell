/**************************************************************************
**
** I-IMOUT - Define sa°da para impress∆o do relatorio - ex. cd9520.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
**             {&append} = append
***************************************************************************/

if  input frame f-pg-lay rs-destino-layout = 1 then do:
&if "{&tofile}" = "" &then
    assign c-impressora = substring(tt-param.arq-destino,1,index(tt-param.arq-destino,":") - 1).
    assign c-layout     = substring(tt-param.arq-destino,index(tt-param.arq-destino,":") + 1, length(tt-param.arq-destino) - index(tt-param.arq-destino,":")).
&elseif "{&tofile}" <> "" &then
    assign c-impressora = substring({&tofile},1,index({&tofile},":") - 1).
    assign c-layout     = substring({&tofile},index({&tofile},":") + 1, length({&tofile}) - index({&tofile},":")).
&endif.
    find imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = c-impressora
        and   imprsor_usuar.cod_usuario    = tt-param.usuario
        use-index imprsrsr_id no-error.
    find layout_impres no-lock
        where layout_impres.nom_impressora    = c-impressora
        and   layout_impres.cod_layout_impres = c-layout no-error.

    output {&stream} to value(imprsor_usuar.nom_disposit_so)
          paged page-size value(layout_impres.num_lin_pag) 
          convert target 'iso8859-1'.

    for each configur_layout_impres no-lock
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:
        
        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.
        
        put {&stream} control configur_tip_imprsor.cod_comando_configur.
    end.    
end.
else do:
    output {&stream} to value(c-arq-term) 
          paged page-size 64 
          convert target "iso8859-1" {&append}.
end.

/* i-imout */
