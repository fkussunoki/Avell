/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520H 2.00.00.030 } /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520h MOF}
&ENDIF

/******************************************************************************
**
**  Programa: esof0520H.P
**
**  Data....: Mar‡o de 1998
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Registro de Entradas
**
******************************************************************************/

def input parameter r-emitente    as rowid.
def input parameter r-doc-fiscal  as rowid.

DEFINE VARIABLE c-cgc-e LIKE doc-fiscal.cgc NO-UNDO.

{ofp/esof0520.i shared}

def shared var h-esof0520e as handle no-undo.

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
         run pi-verifica-linhas in h-esof0520e(1).
         put emitente.nome-emit at 1.
         if  i-op-rel = 2 then do:
             assign l-erro-x = no.
             if  l-esof0520x then do:
                 run "ofp/esof0520x.p" (input rowid(emitente),
                                     input "2",
                                     output l-erro-x).
             end.
             if  l-erro-x = no then do:
                 RUN pi-edita-cgc(INPUT doc-fiscal.cgc, OUTPUT c-cgc-e).
                 put c-cgc-e at 42 format "x(18)".
             end.
             else put "" at 42.
             
             if  l-imp-ins then
                 put doc-fiscal.ins-estadual at 63.
             
             assign i-status = -1.
         end.
         else
             assign i-status = 2.
end.
else if  i-status = 2 then do:
         assign l-erro-x = no.
         if  l-esof0520x then do:
             run "ofp/esof0520x.p" (input rowid(emitente),
                                  input "2",
                                  output l-erro-x).
         end.
         if  l-erro-x = no then do:
             RUN pi-edita-cgc(INPUT doc-fiscal.cgc, OUTPUT c-cgc-e).
             put c-cgc-e at 1 format "x(18)".
         end.
         else put "" at 1.
         if  l-imp-ins then
             put doc-fiscal.ins-estadual at 42.
         assign i-status = -1.
    end.

/* esof0520h.p */


PROCEDURE pi-edita-cgc :
    DEFINE INPUT PARAMETER pc-cgc-in LIKE doc-fiscal.cgc NO-UNDO.
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
