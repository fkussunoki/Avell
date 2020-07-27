output to c:\desenv\titulos-excluir.txt.
for each nota-fiscal no-lock where nota-fiscal.emite-duplic = yes:

    find first tit_Acr no-lock where tit_acr.cod_estab = nota-fiscal.cod-estabel
                               and   tit_acr.cod_tit_acr = nota-fiscal.nr-nota-fis
                               and   tit_acr.cod_ser_docto = nota-fiscal.serie
                               and   tit_acr.cdn_cliente   = nota-fiscal.cod-emitente no-error.

                               if not avail tit_acr then do:

                                assign nota-fiscal.emite-duplic = no
                                       substring(nota-fiscal.char-2, 1900, 10) = "Acerto".

                               end.
                            end.
