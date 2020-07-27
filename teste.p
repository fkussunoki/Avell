for each movto_comis_repres no-lock 
          where movto_comis_repres.cdn_repres     >= 0
          and   movto_comis_repres.cdn_repres     <= 99999
          and   movto_comis_repres.cod_estab      >= ""
          and   movto_comis_repres.cod_estab      <= "zzzz"
          and   movto_comis_repres.dat_transacao  >= 01/01/2002
          and   movto_comis_repres.dat_transacao  <= 12/30/2018:

        find first tit_acr no-lock 
            where tit_acr.cod_estab           = movto_comis_repres.cod_estab
            and   tit_acr.num_id_tit_acr      = movto_comis_repres.num_id_tit_acr 
            and   tit_acr.log_tit_acr_estordo = no no-error.

        if avail tit_acr then do:

            find first nota-fiscal no-lock 
                where nota-fiscal.nr-nota-fis    = tit_acr.cod_tit_acr
                and   nota-fiscal.cod-emitente   = tit_acr.cdn_cliente
                and   nota-fiscal.serie          = tit_acr.cod_ser_docto
                and   nota-fiscal.cod-estabel    = tit_acr.cod_estab no-error.

                disp movto_comis_repres with 1 col width 600.
        end.
end.