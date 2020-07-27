/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540H 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i esof0540H MOF}
&ENDIF

/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540H.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**
******************************************************************************/

def input parameter r-emitente    as rowid no-undo.
def input parameter r-doc-fiscal  as rowid no-undo.

DEFINE VARIABLE c-cgc LIKE doc-fiscal.cgc NO-UNDO.

def shared var l-imp-for  as logical format "Sim/Nao" init yes no-undo. 
def shared var l-imp-ins  as logical format "Sim/Nao"          no-undo. 
def shared var i-status   as integer                           no-undo.
def shared var l-erro-x   as logical                           no-undo.
def shared var l-esof0540x  as logical                           no-undo.
def shared var i-op-rel   as integer init 1                    no-undo.
def shared var h-esof0540e  as handle                            no-undo.

if  i-status > 0 then do:
    find emitente no-lock
        where rowid(emitente) = r-emitente no-error.
    find doc-fiscal no-lock
        where rowid(doc-fiscal) = r-doc-fiscal no-error.
end.
if  i-status = 0 then do:
    if  l-imp-for = yes then
        assign i-status = 1.
end.
else if  i-status = 1 then do: 
    run pi-verifica-linhas in h-esof0540e (line-counter,1,0).

    put emitente.nome-emit at 1 FORMAT "x(40)".

    run pi-verifica-linhas in h-esof0540e (line-counter,1,0).

    if  i-op-rel = 2 then do:
        
        RUN pi-edita-cgc(INPUT doc-fiscal.cgc, OUTPUT c-cgc).
        put c-cgc at 42 format "x(18)".
        
        if  l-imp-ins then
            put doc-fiscal.ins-estadual at 63.
        
        assign i-status = -1.
    end.
    else
        assign i-status = 2.
end.
else if  i-status = 2 then do:
    RUN pi-edita-cgc(INPUT doc-fiscal.cgc, OUTPUT c-cgc).
    put c-cgc at 1 format "x(18)".

    if  l-imp-ins then
        put doc-fiscal.ins-estadual at 42.
    assign i-status = -1.
end.

PROCEDURE pi-edita-cgc :
    DEFINE INPUT  PARAMETER pc-cgc-in  LIKE doc-fiscal.cgc NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cgc-out LIKE doc-fiscal.cgc NO-UNDO.

    ASSIGN pc-cgc-out = REPLACE(REPLACE(REPLACE(pc-cgc-in,"/",""),"-",""),".","").
    find first param-global no-lock no-error.
    if avail param-global then do: 
         if avail emitente then do:
            if emitente.natureza = 1 and 
               param-global.formato-id-pessoal <> ''  then
               assign pc-cgc-out = string(pc-cgc-out,param-global.formato-id-pessoal).
            else
            if emitente.natureza = 2 and 
               param-global.formato-id-federal  <> '' then 
               assign pc-cgc-out = string(pc-cgc-out,param-global.formato-id-federal).
            else
               assign pc-cgc-out = string(pc-cgc-out,"x(18)").

         end.             
    end.       
END PROCEDURE.
