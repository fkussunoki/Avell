/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520E 2.00.00.036 } /*** 010036 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0520e MOF}
&ENDIF

/******************************************************************************
**
**  Programa: esof0520E.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Verifica se imprime termo de abertura/encerramento
**
**   Utilizacao dos parametros:
**   parametro i-line-print : recebe o numero de linhas a imprimir.
**  OBS: este programa esta preparado para DISPLAY SIMPLES e o comando PUT.
**       NAO FUNCIONA o controle de impressao para frames do tipo DOWN.
******************************************************************************/

{ofp/esof0520.i shared}

def var l-tem-funcao         as log     no-undo.

assign l-tem-funcao = can-find(funcao where funcao.cd-funcao = "considera-termo" and funcao.ativo).
   
procedure pi-leitura-param-of:

    if  not avail param-of
    or  param-of.cod-estabel <> c-est-ini then
        for first param-of fields ( nr-pag-ent termo-en-ent 
                                    termo-ab-ent reinicia-fecha )
            where param-of.cod-estabel = c-est-ini no-lock.
        end.

    RETURN "OK".

end.    

procedure pi-verifica-linhas:
    def input parameter i-line-print as int. /* valor de linhas a imprimir */
    
    def var i-cont               as integer no-undo.
    def var i-linhas             as integer no-undo.
    
    assign l-nova-pagina = no.
    
    if (line-counter + i-line-print) > page-size then do:

       assign i-num-pag     = i-num-pag + 1 
              i-linhas      = page-size - line-counter
              l-nova-pagina = yes.
              
       do i-cont = 1 to i-linhas:
          if  i-op-rel = 1 then 
              put c-linha-branco at 1 format "x(132)" skip.
          else
              put c-linha-branco at 1 format "x(159)" skip.
       end.
       
       page.
       
       if  not l-at-perm 
       and i-num-pag modulo (param-of.nr-pag-ent +
                                if l-tem-funcao
                                then 1
                                else 0 ) = 0 then do:
           hide all no-pause.  
           find b-termo where b-termo.te-codigo = param-of.termo-en-ent no-lock.
           {ofp/esof0520.i3 "b-termo"}
           find b-termo where b-termo.te-codigo = param-of.termo-ab-ent no-lock.
           {ofp/esof0520.i3 "b-termo"}
           if l-tem-funcao 
           then assign i-num-pag = if param-of.reinicia-fecha = no
                                   then i-num-pag
                                   else 1.
           else assign i-num-pag = if  /* param-of.reini-pag = yes 
                                   or  */ param-of.reinicia-fecha = no
                                   then i-num-pag + 2
                                   else 2.
           run pi-cabecalhos.
       end.
    end.

    RETURN "OK".

end procedure.

Procedure pi-cabecalhos:

    if  l-separadores then do:
        if  i-op-rel = 1 then do:
            view frame f-cab-diag.
            view frame f-bottom.
        end.
        else do:
            view frame f-cab-diag-e.     
            view frame f-bottom-e.
        end.
        if  i-nivel = 1 then do:
            if  i-op-rel = 1 then
                view frame f-scab-diag.
            else 
                view frame f-scab-diag-e.
        end.
        if  i-nivel = 2 then do:
            if  i-op-rel = 1 then
                view frame f-scab-res.
            else
                view frame f-scab-res-e.
        end.
        if  i-nivel = 3 then do:
            if  l-documentos then do:
                if  i-op-rel = 1 then
                    view frame f-scab-uf.
                else
                    view frame f-scab-uf-e.
            end.
            else do:
                if  i-op-rel = 1 then
                   view frame f-scab-uf2.
                else
                    view frame f-scab-uf2-e.
            end.
        end.
    end.
    else do:
        if  i-op-rel = 1 then 
            view frame f-cab.
        else 
            view frame f-cab-exp.     
        if  i-nivel = 2 then do:
            if  i-op-rel = 1 then
                view frame f-cab-res.
            else
                view frame f-res-sub.
        end.
        if  i-nivel = 3 then do:
            if  l-documentos then do:
                if  i-op-rel = 1 then
                    view frame f-cab-uf2.
                else 
                    view frame f-res-uf2.
            end.
            else do:
                if  i-op-rel = 1 then 
                    view frame f-cab-uf.
                else
                    view frame f-res-uf.
            end.
        end.
    end.

    RETURN "OK".

end procedure.

