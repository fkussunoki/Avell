/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540E 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0540e MOF}
&ENDIF

/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540E.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Verifica se imprime termo de abertura/encerramento
**
**   Utilizacao dos parametros:
**   parametro i-line       : recebe o valor do line-counter do prog. origem.
**     "       i-line-print : recebe o numero de linhas a imprimir.
**     "       c-localiz   : recebe o nivel da impressao dentro do relatorio.
**     Se c-localiz for = 0: nivel de impressao das notas fiscais.
**                       = 1: nivel da impressao em resumo de CFOP Normal.
**                       = 2: nivel da impressao em resumo de CFOP Expandido.
**  OBS: este programa esta preparado para DISPLAY SIMPLES e o comando PUT.
**       NAO FUNCIONA o controle de impressao para frames do tipo DOWN.
******************************************************************************/
/* def shared var i-op-rel          as integer  init 1  no-undo.
def shared var l-documentos      as logical  format "Icms Substituto/Todos Documentos" no-undo. 
def shared var i-termo           as integer  no-undo.     */

IF NO THEN
    FIND FIRST param-of NO-LOCK NO-ERROR.

{ofp/esof0540.i "shared"}
{include/tt-edit.i}

procedure pi-verifica-linhas:

def input parameter i-line       as int no-undo. /* valor de line-counter */
def input parameter i-line-print as int no-undo. /* valor de linhas a imprimir */
def input parameter i-localiza   as int no-undo. /* indica posicao no relatorio p/ dar os views nas frames page-top */

IF NOT AVAIL param-of OR param-of.cod-estabel <> c-est-ini THEN
    find param-of where param-of.cod-estabel = c-est-ini no-lock.

if (i-line + i-line-print - 1) >= page-size then do: 
    hide all no-pause.
    if ((i-num-pag + 1) modulo param-of.nr-pag-ent = 0
         and param-of.reini-pag = no)
    or ((i-num-pag + 1) modulo param-of.nr-pag-ent = 0
         and param-of.reini-pag = yes) then do:
       hide frame f-cab no-pause.
       hide frame f-cab-exp no-pause.
       hide frame f-cab-res no-pause.
       hide frame f-res-sub no-pause.
       assign i-num-pag = i-num-pag + 1.
       page.

       find b-termo where b-termo.te-codigo = param-of.termo-en-ent no-lock.
       run pi-print-editor (b-termo.texto, 60).
       {ofp/esof0540.i3 "b-termo"}
       find first tt-editor no-error.
       if avail tt-editor then put tt-editor.conteudo at 26.
       for each tt-editor where tt-editor.linha > 1:
           put tt-editor.conteudo at 26.
       end.
       put skip.

       page.

       find b-termo where b-termo.te-codigo = param-of.termo-ab-ent no-lock.
       run pi-print-editor (b-termo.texto, 60).
       {ofp/esof0540.i3 "b-termo"}
       find first tt-editor no-error.
       if avail tt-editor then put tt-editor.conteudo at 26.
       for each tt-editor where tt-editor.linha > 1:
           put tt-editor.conteudo at 26.
       end.
       put skip.
       page.
       assign i-num-pag = if param-of.reinicia-fecha = no
                          then i-num-pag + 2
                          else 2.
           if c-localiz = 0 then do:
              view frame f-cab.
           end.
           else do:
                if c-localiz = 1 then do: 
                    view frame f-cab-res.
                end.        
                else do:
                     if c-localiz = 2 then do:
                        view frame f-cab-uf.     
                     end.
                end.
           end.     
    end.
    else do:
         assign i-num-pag = i-num-pag + 1.
         if c-localiz = 0 then do:
            view frame f-cab.
         end.
         else do:
              if c-localiz = 1 then do: 
                 view frame f-cab-res.
              end.        
              else do:
                   if c-localiz = 2 then do:
                      view frame f-cab-uf.     
                   end.
              end.
         end.     
         page.
    end.
end.

end procedure.
{include/pi-edit.i}


