/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520G1 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0520g1 MOF}
&ENDIF


/******************************************************************************
**
**  Programa: esof0520G1.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**            Resumo por uf.
**
******************************************************************************/

def input parameter r-it-doc-fisc as rowid.

{ofp/esof0520.i shared}

find it-doc-fisc no-lock
    where rowid(it-doc-fisc) = r-it-doc-fisc no-error.
    
find doc-fiscal of it-doc-fisc no-lock no-error.

if (c-estado       <> doc-fiscal.estado and
    c-estado       <> "RS"              and
    c-estado       <> "SC"              and
    c-estado       <> "PR"              and
    doc-fiscal.pais = "Brasil")         or
   ((c-estado       = "RS"              or              
     c-estado       = "PR"              or
     c-estado       = "SC")             and
    doc-fiscal.pais = "Brasil")         then do:

/* if c-estado <> doc-fiscal.estado and doc-fiscal.pais = "Brasil" then do: */

    find tt-tab-ocor use-index codigo
        where  tt-tab-ocor.cod-tab    = 249
        and    tt-tab-ocor.c-campo1 = c-usuario
        and    tt-tab-ocor.c-campo2 = doc-fiscal.estado
        and    tt-tab-ocor.l-campo1 = no /* resumo por uf */ no-error.  

    if  not avail tt-tab-ocor then do:
        /*find last tt-tab-ocor 
            where tt-tab-ocor.cod-tab = 249 no-lock no-error.
        assign i-aux-1 = (if avail tt-tab-ocor then tt-tab-ocor.cod-ocor else 0) + 1.*/
        create tt-tab-ocor.
        assign tt-tab-ocor.cod-tab    = 249
               tt-tab-ocor.cod-ocor   = i-aux-1
               tt-tab-ocor.c-campo1 = c-usuario
               tt-tab-ocor.c-campo2 = doc-fiscal.estado
               tt-tab-ocor.l-campo1 = no
               tt-tab-ocor.cod-estabel = doc-fiscal.cod-estabel. /* resumo por uf */
    end.
    assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-tot-item
           tt-tab-ocor.de-campo2 = tt-tab-ocor.de-campo2 + it-doc-fisc.vl-bsubs-it
           tt-tab-ocor.de-campo3 = tt-tab-ocor.de-campo3 + it-doc-fisc.vl-icmsub-it            
           tt-tab-ocor.de-campo4 = tt-tab-ocor.de-campo4 + it-doc-fisc.vl-bicms-it
           tt-tab-ocor.de-campo5 = tt-tab-ocor.de-campo5 + it-doc-fisc.vl-icmsou-it. 
end.

/* esof0520g1.p */


