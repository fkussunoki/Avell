/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0520J 2.00.00.031 } /*** 010031 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0520J MOF}
&ENDIF

/******************************************************************************
**  Include...: esof0520J.P
**  Objetivo..: Display da coluna de observacao - Estouro 63k esof0520F.P
******************************************************************************/

def input parameter  r-docum as rowid.

{ofp/esof0520.i shared}

def var l-prim-imp             as log                            no-undo.

find first doc-fiscal where rowid(doc-fiscal) = r-docum no-lock. 

if  c-obs-total <> "" then
    replace(c-obs-total,chr(13),"").
   
assign c-observa  = ""
       l-prim-imp = yes.
       
if  c-observa <> "" 
and i-inicio < 65 then do:
    run pi-print-editor (input c-observa, input 11).
    find first tt-editor no-error.
    if avail tt-editor then do:
      put tt-editor.conteudo format "x(11)" at i-posicao[8].
      assign i-inicio = i-inicio + 11.
    end.  
    
    for each tt-editor where tt-editor.linha > 1:
       if tt-editor.linha > 1 then
          put tt-editor.conteudo format "x(11)" at i-posicao[8].
          assign i-inicio = i-inicio + 11.
    end.
    
/*    put unformatted c-observa at i-posicao[8] format "x(14)".  /*110*/
    assign i-inicio = i-inicio + 14. */
end.
else
    if  ((  c-estado = "SP"
         or c-estado = "MG"
         or c-estado = "PE"
         or c-estado = "BA"
         or c-estado = "RS")
    and doc-fiscal.vl-icms-com > 0) then do:
        
        if  l-prim-txt = yes then do:
            if  c-estado = "MG" 
            then /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-debito AS CHARACTER FORMAT "X(8)" NO-UNDO.
     {utp/ut-liter.i "DEBITO" *}
     ASSIGN c-lbl-liter-debito = TRIM(RETURN-VALUE).
     put c-lbl-liter-debito         at i-posicao[8].
 END. 
            else 
                 /* Inicio -- Projeto Internacional */
                 DO:
                 DEFINE VARIABLE c-lbl-liter-difaliqicms AS CHARACTER FORMAT "X(15)" NO-UNDO.
                 {utp/ut-liter.i "Dif.Aliq.ICMS" *}
                 ASSIGN c-lbl-liter-difaliqicms = TRIM(RETURN-VALUE).
                 put c-lbl-liter-difaliqicms at i-posicao[8].
                 END. 
             
            assign l-prim-txt = no.
        end.
        else
            if  l-prim-vlr = yes then do:
                put "(" at (i-posicao[8] /* + 1 */)
                    doc-fiscal.vl-icms-com format ">>>>>>9.99"
                    ")".
                assign l-prim-vlr = no
                       l-prim-imp = no.
            end.
        
        if  c-estado               = "MG" 
        and l-prim-txt = no 
        and l-prim-vlr = no
        and l-prim-imp = yes
        then do:
            if  doc-fiscal.vl-icms     > 0  then do:
                if  l-prim-cred = yes then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-credito AS CHARACTER FORMAT "X(9)" NO-UNDO.
                    {utp/ut-liter.i "CREDITO" *}
                    ASSIGN c-lbl-liter-credito = TRIM(RETURN-VALUE).
                    put c-lbl-liter-credito          at i-posicao[8].
                    assign l-prim-cred = no.
                end.
                else  
                    if  l-prim-vlr-cred = yes then do:
                        put "("  at (i-posicao[8] + 1)
                             doc-fiscal.vl-icms-com format ">>>>>>>9.99"
                             ")".
                        assign l-prim-vlr-cred = no.
                    end.
                assign l-prim-imp = no.
            end.
            else 
                assign l-prim-cred     = no
                       l-prim-vlr-cred = no.
        end.
    end.
    
put skip.


/* esof0520J.P */

