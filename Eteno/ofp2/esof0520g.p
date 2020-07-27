/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520G 2.00.00.033 } /*** 010033 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esof0520g MOF}
&ENDIF

/******************************************************************************
**
**  Programa: esof0520G.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**            Resumo por cfop.
**
******************************************************************************/

def input parameter r-it-doc-fisc as rowid.
def input parameter l-tipo as logical.
def input parameter l-sequencia as logical.
/* Novo CFOP */
def INPUT PARAMETER da-dt-cfop      as date.    
def buffer b-param-of-cfop for param-of.    
DEF var c-desc-cfop-nat like natur-oper.denominacao no-undo.
if  no then do:
    find first b-param-of-cfop   no-lock no-error.
    find first natur-oper no-lock no-error.
end.    

{ofp/esof0520.i shared}

def var l-soma as logical no-undo.
def var de-obs as decimal no-undo.
def var i-aliquota as integer no-undo.
def var i-aux like tt-tab-ocor.i-campo1 no-undo.

/* Defini‡äes de pr‚-processadores */
{cdp/cdcfgdis.i} 

find it-doc-fisc no-lock
    where rowid(it-doc-fisc) = r-it-doc-fisc no-error.
    
find doc-fiscal of it-doc-fisc no-lock no-error.

/* Este find ‚ necess rio para que nÆo ocorra erro na */
/* l¢gica para melhoria de performance desta tabela.  */
if  no then
    for first natur-oper fields() no-lock.
    end.
        
assign l-soma = no.

{ofp/esof0520g.i it-doc-fisc.nat-operacao}   /* grava formato c-cfop */

if  it-doc-fisc.cd-trib-icm = 3 or  it-doc-fisc.cd-trib-icm = 2 then do:
    for first b-it-doc-fisc fields()
        where b-it-doc-fisc.cod-estabel  = it-doc-fisc.cod-estabel
        and   b-it-doc-fisc.serie        = it-doc-fisc.serie
        and   b-it-doc-fisc.nr-doc-fis   = it-doc-fisc.nr-doc-fis
        and   b-it-doc-fisc.cod-emitente = it-doc-fisc.cod-emitente
        and   b-it-doc-fisc.nat-operacao = it-doc-fisc.nat-operacao
        and   b-it-doc-fisc.cd-trib-icm  = 1
        and   b-it-doc-fisc.it-codigo    = it-doc-fisc.it-codigo no-lock.
    end.    
    assign l-soma  =   avail b-it-doc-fisc
                   and not l-sequencia.
end. 
if  not l-soma or
    r-tt-tab-ocor = ? then do:
    assign i-aux = int(it-doc-fisc.aliquota-icm /*it-doc-fisc.dec-1*/ * 100).
    find tt-tab-ocor use-index codigo 
        where  tt-tab-ocor.cod-tab   = 249
        and    tt-tab-ocor.c-campo1  = c-usuario
        and    tt-tab-ocor.c-campo2  = c-cfop
        and    tt-tab-ocor.i-campo1  = i-aux
        and    tt-tab-ocor.l-campo1  = yes /* resumo por cfop */
        and    tt-tab-ocor.l-campo2  = yes /* icms */
        and    tt-tab-ocor.l-campo3  = l-tipo no-error.  
     
    if  not avail tt-tab-ocor then do:
       /*find last tt-tab-ocor 
           where tt-tab-ocor.cod-tab = 249 no-lock no-error.
       assign i-aux-1 = (if avail tt-tab-ocor then tt-tab-ocor.cod-ocor else 0) + 1.*/

       create tt-tab-ocor.
      
       assign tt-tab-ocor.cod-tab  = 249
              tt-tab-ocor.cod-ocor = i-aux-1
              tt-tab-ocor.c-campo1 = c-usuario
              tt-tab-ocor.c-campo2 = c-cfop
              tt-tab-ocor.i-campo1 = it-doc-fisc.aliquota-icm /*it-doc-fisc.dec-1*/ * 100
              tt-tab-ocor.l-campo1 = yes /* resumo por cfop */
              tt-tab-ocor.l-campo2 = yes /* icms */
              tt-tab-ocor.l-campo3 = l-tipo
              substr(tt-tab-ocor.char-1,1,6) = replace(c-cfop,".","")
              tt-tab-ocor.i-formato = i-formato-cfop
              tt-tab-ocor.cod-estabel = doc-fiscal.cod-estabel.
     end.
    
    assign r-tt-tab-ocor = rowid(tt-tab-ocor).
end.

find tt-tab-ocor 
    where rowid(tt-tab-ocor) = r-tt-tab-ocor no-error.

assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-tot-item
       tt-tab-ocor.de-campo2 = tt-tab-ocor.de-campo2 + it-doc-fisc.vl-bicms-it
       tt-tab-ocor.de-campo3 = tt-tab-ocor.de-campo3 + it-doc-fisc.vl-icms-it
       tt-tab-ocor.de-campo4 = tt-tab-ocor.de-campo4 + it-doc-fisc.vl-icmsnt-it
       tt-tab-ocor.de-campo5 = tt-tab-ocor.de-campo5 + it-doc-fisc.vl-icmsou-it
       tt-tab-ocor.c-campo3  = 
       string(decimal(tt-tab-ocor.c-campo3) + it-doc-fisc.vl-bsubs-it)
       tt-tab-ocor.c-campo4  = 
       string(decimal(tt-tab-ocor.c-campo4) + it-doc-fisc.vl-icmsub-it)
       i-aliquota           = tt-tab-ocor.i-campo1.  
if  l-primeiro then do:
    assign tt-tab-ocor.c-campo5 = 
           string(decimal(tt-tab-ocor.c-campo5) + doc-fiscal.vl-icms-com)
           l-primeiro = no.
    if  ((c-estado = "PE" or c-estado = "MG")
        and doc-fiscal.cod-des-merc = 2
        and doc-fiscal.vl-ipiou > 0) then 
        assign de-obs     =   doc-fiscal.vl-cont-doc 
                          -  (doc-fiscal.vl-ipiou 
                          +   doc-fiscal.vl-ipint 
                          +   doc-fiscal.vl-bipi
                          +   doc-fiscal.vl-ipi)
               de-obs     =   if de-obs < 0 then 0 else de-obs
               tt-tab-ocor.descricao = string(decimal(tt-tab-ocor.descricao) +
                                    de-obs).                 

end.

find tt-tab-ocor use-index codigo
    where  tt-tab-ocor.cod-tab    = 249
    and    tt-tab-ocor.c-campo1 = c-usuario
    and    tt-tab-ocor.c-campo2 = c-cfop /* ao inv‚s de it-doc-fisc.nat-operacao */
    and    tt-tab-ocor.i-campo1 = i-aliquota
    and    tt-tab-ocor.l-campo1 = yes /* resumo por cfop */
    and    tt-tab-ocor.l-campo2 = NO /* ipi */
    and    tt-tab-ocor.l-campo3 = l-tipo no-error.  

if  not avail tt-tab-ocor then do:
    /*find last tt-tab-ocor 
        where tt-tab-ocor.cod-tab = 249 no-lock no-error.
    assign i-aux-1 = (if avail tt-tab-ocor then tt-tab-ocor.cod-ocor else 0) + 1.*/
    create tt-tab-ocor.
    assign tt-tab-ocor.cod-tab    = 249
           tt-tab-ocor.cod-ocor   = i-aux-1
           tt-tab-ocor.c-campo1 = c-usuario
           tt-tab-ocor.c-campo2 = c-cfop
           tt-tab-ocor.i-campo1 = i-aliquota
           tt-tab-ocor.l-campo1 = yes /* resumo por cfop */
           tt-tab-ocor.l-campo2 = no /* ipi */
           tt-tab-ocor.l-campo3 = l-tipo
           substr(tt-tab-ocor.char-1,1,6) = replace(c-cfop,".","")
           tt-tab-ocor.i-formato = i-formato-cfop
           tt-tab-ocor.cod-estabel = doc-fiscal.cod-estabel.
end.

assign tt-tab-ocor.de-campo1 = tt-tab-ocor.de-campo1 + it-doc-fisc.vl-bipi-it
       tt-tab-ocor.de-campo2 = tt-tab-ocor.de-campo2 + it-doc-fisc.vl-ipi-it
       tt-tab-ocor.de-campo3 = tt-tab-ocor.de-campo3 + it-doc-fisc.vl-ipint-it
       tt-tab-ocor.de-campo4 = tt-tab-ocor.de-campo4 + it-doc-fisc.vl-ipiou-it.

/* esof0520g.p */ 

