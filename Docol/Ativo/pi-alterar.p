define temp-table tt-erro
field ttv-mensagem as integer
field ttv-descricao as char.

def temp-table tt-planilha no-undo
FIELD ttv-estabel                   AS CHAR
field ttv-status                    as char
field ttv-localizacao-de            as char
field ttv-localizacao-para          as char
field ttv-cta-pat                   as char
field ttv-descricao                 as char
field ttv-cta-pat-para              as char
field ttv-bem-de                    as char
field ttv-inc-de                    as char
field ttv-foto                      as char
field ttv-desmembrar                as LOGICAL INITIAL NO
field ttv-bem-para                  as char
field ttv-inc-para                  as char
field ttv-cc-de                     as char
field ttv-cc-para                   as char
field ttv-dt-aquisicao              as date
field ttv-descricao1                as char
field ttv-descricao-de              as char
field ttv-descricao-para            as char
field ttv-local-de                  as char
field ttv-local-para                as char
field ttv-ps                        as char
field ttv-cod-especie               as char
field ttv-des-especie               as char
field ttv-taxa-conta                as char
field ttv-vlr-original              as char
field ttv-vlr-original-corr         as char
field ttv-depreciacao               as char
field ttv-situacao                  as char
field ttv-nf                        as char
field ttv-fornecedor                as char
field ttv-dt-base-arquivo           as date
field ttv-taxa-societaria           as char
field ttv-residual                  as CHAR
FIELD ttv-tratamento                AS CHAR
FIELD ttv-concatena-de              AS CHAR
FIELD ttv-concatena-para            AS CHAR
FIELD ttv-score                     AS INTEGER.

define input param p-num-bem-pat as integer no-undo.
define input param p-cta-pat     as char    no-undo.
define input param p-seq-bem     as integer no-undo.
define input param p-descricao   as char    no-undo.
define input param p-localizacao as char    no-undo.
define input param p-plaqueta    as char    no-undo.
define input param p-empresa     as char    no-undo.
define input param p-novo-num    as integer no-undo.
define input param p-nova-seq    as integer no-undo.
define output param table for tt-erro.

    def buffer b_bem     for bem_pat.
    def buffer b_movto_bem_pat   for movto_bem_pat.


    /*************************** Buffer Definition End **************************/


        find bem_pat       where  bem_pat.num_bem_pat     = p-num-bem-pat
                           and    bem_pat.num_seq_bem_pat = p-seq-bem
                           and    bem_pat.cod_cta_pat     = p-cta-pat
                           and    bem_pat.cod_empresa     = p-empresa exclusive-lock no-error.

            assign bem_pat.des_bem_pat = p-descricao
                   bem_pat.cod_localiz = p-localizacao
                   bem_pat.cb3_ident_visual = p-plaqueta.


            if bem_pat.num_bem_pat     <> p-novo-num
            or bem_pat.num_seq_bem_pat <> p-nova-seq then do:               

                if bem_pat.val_perc_bxa = 100 then do:
                    find last b_movto_bem_pat no-lock
                        where b_movto_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat
                        and   b_movto_bem_pat.num_seq_incorp_bem_pat = 0
                        and   b_movto_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/   
                        and   b_movto_bem_pat.val_perc_movto_bem_pat = 100 no-error.
                    if avail b_movto_bem_pat then do:
                        if b_movto_bem_pat.log_calc_pat = yes then do:
                            create tt-erro.
                            assign tt-erro.ttv-mensagem  = 21509
                                tt-erro.ttv-descricao = "Bem ja esta totalmente baixado.".
                                return 'nok'.
                        end.
                    end.
                end.   
                if  p-novo-num > 0
                then do:
                        find b_bem  no-lock
                            where b_bem.cod_empresa = p-empresa
                            and b_bem.cod_cta_pat = p-cta-pat
                            and b_bem.num_bem_pat = p-novo-num
                            and b_bem.num_seq_bem_pat = p-nova-seq
                            use-index bempat_id
                            no-error.
                        if  avail b_bem
                        then do:
                            /* Bem Patrimonial informado j  existe ! */
                            create tt-erro.
                            assign tt-erro.ttv-mensagem  = 21509
                                tt-erro.ttv-descricao = "Bem ja existe com esta numeracao.".
                                return 'nok'.
                        end /* if */.
                            for each  calc_parc_pis_cofins exclusive-lock
                                where calc_parc_pis_cofins.cod_empresa     = p-empresa
                                and calc_parc_pis_cofins.cod_cta_pat     = p-cta-pat
                                and calc_parc_pis_cofins.num_bem_pat     = p-num-bem-pat
                                and calc_parc_pis_cofins.num_seq_bem_pat = p-seq-bem:

                                assign calc_parc_pis_cofins.num_bem_pat     = p-novo-num
                                    calc_parc_pis_cofins.num_seq_bem_pat = p-nova-seq.
                            end.
                            for each  bem_pat_gartia
                                where bem_pat_gartia.cod_empresa      = p-empresa   
                                and  bem_pat_gartia.cod_cta_pat      = p-cta-pat    
                                and  bem_pat_gartia.num_bem_pat      = p-num-bem-pat    
                                and  bem_pat_gartia.num_seq_bem_pat  = p-seq-bem exclusive-lock:

                                assign bem_pat_gartia.num_bem_pat     = p-novo-num     
                                    bem_pat_gartia.num_seq_bem_pat = p-nova-seq.
                            end.
                            for each ident_bem_pat exclusive-lock
                                where ident_bem_pat.cod_empresa     = p-empresa
                                and ident_bem_pat.cod_cta_pat     = p-cta-pat
                                and ident_bem_pat.num_bem_pat     = p-num-bem-pat    
                                and ident_bem_pat.num_seq_bem_pat = p-seq-bem:

                                assign ident_bem_pat.num_bem_pat     = p-novo-num     
                                        ident_bem_pat.num_seq_bem_pat = p-nova-seq.

                            end.
                    end /* if */.
            end.        
