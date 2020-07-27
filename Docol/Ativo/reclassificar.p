define var v_cod_dwb_program          as char no-undo.
define var v_cod_dwb_user             as char no-undo.
define input param p-usuario          as char no-undo.
define input param p-cta-pat          as char no-undo.
define input param p-cc-para          as char no-undo.
define input param p-bem-de           as char no-undo.
define input param p-count            as integer no-undo.
define input param p-dt-base          as date no-undo.
define input param p-cta-pat-para     as char no-undo.
define input param p-estab            as char no-undo.
define input param p-localizacao      as char no-undo.

ASSIGN v_cod_dwb_program  = "tar_reclassif_bem_pat"
       v_cod_dwb_user     = p-usuario.


find first cta_pat no-lock where cta_pat.cod_cta_pat = p-cta-pat
                           and   cta_pat.cod_empresa =  p-usuario no-error.

                           find first emsbas.ccusto no-lock where ccusto.cod_empresa = p-usuario
                                                    and    ccusto.cod_ccusto         = p-cc-para
                                                    and    ccusto.dat_fim_valid      >= today
                                                    no-error.

                            find first ccusto_unid_negoc no-lock where ccusto_unid_negoc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                            no-error.                           

create dwb_set_list.
assign dwb_set_list.ind_dwb_set_type = "Regra"
       dwb_set_list.cod_dwb_set_initial     = ""
       dwb_set_list.cod_dwb_set_final       = ""
       dwb_set_list.cod_dwb_set             = "Individual"
       dwb_set_list.cod_dwb_set_single      = p-cta-pat + chr(10) + p-bem-de + chr(10) + string(p-count) + chr(10)
       dwb_set_list.cod_dwb_set_parameters  = string(p-dt-base) + chr(10) + p-cta-pat + chr(10) + cta_pat.cod_grp_calc + chr(10) + ccusto.cod_plano_ccusto + chr(10) + p-cc-para
                                            + chr(10) + p-estab + chr(10) + ccusto_unid_negoc.cod_unid_negoc + chr(10) + p-localizacao + chr(10)
       
       dwb_set_list.num_dwb_order = p-count + 300.



