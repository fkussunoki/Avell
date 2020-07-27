/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esof0540C 2.00.00.022 } /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esof0540c MOF}
&ENDIF


/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa: esof0540C.P
**
**  Data....: Outubro de 1996
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: display de totais
**
******************************************************************************/
def shared var c-desc-tot  as character format "x(62)"            no-undo.
def shared var de-aux      as decimal extent 13                   no-undo.
def shared var de-auxi     as decimal                             no-undo.  
def shared var i-op-rel    as integer           initial 1         no-undo.
def shared var h-esof0540e   as handle                              no-undo.

{ofp/esof0540.i "shared"}

if c-desc-tot <> "" then
   assign c-desc-tot = c-desc-tot +
                       fill(".",62 - length(c-desc-tot)).
if i-op-rel = 1 then do:
   run pi-verifica-linhas in h-esof0540e (line-counter,3,c-localiz).

   put c-desc-tot   at   1
       "1"          at  82
       de-aux[1]    to  98  format ">>>>>>>>>>9.99"
       de-aux[2]    to 115  format ">>>>>>>9.99"
       "1"          at 117
       de-aux[7]    to 132  format ">>>>>>>>>>9.99"
       de-aux[8]    to 144  format ">>>>>>>9.99".
   
   if  de-aux[11] > 0 then do:
       if c-estado = "MG" then
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-debito AS CHARACTER FORMAT "X(9)" NO-UNDO.
            {utp/ut-liter.i "DEBITO" *}
            ASSIGN c-lbl-liter-debito = TRIM(RETURN-VALUE).
            put c-lbl-liter-debito + ":"        at 146 skip.
            END. 
       else /* Inicio -- Projeto Internacional */
 DO:
     DEFINE VARIABLE c-lbl-liter-difaliicms AS CHARACTER FORMAT "X(14)" NO-UNDO.
     {utp/ut-liter.i "Dif.Ali.ICMS" *}
     ASSIGN c-lbl-liter-difaliicms = TRIM(RETURN-VALUE).
     put c-lbl-liter-difaliicms   at 146 skip.
 END. 
   end.
   
   put "2"          at  82
       de-aux[3]    to  98  format ">>>>>>>>>>9.99"
       0            to 115  format ">>>>>>>9.99"
       "2"          at 117  
        de-aux[9]   to 132  format ">>>>>>>>>>9.99"
        0           to 144  format ">>>>>>>9.99".
   if  de-aux[11] > 0 then
       put de-aux[11]  at 146 format ">>>>>>>>9.99" skip.
   put "3"          at  82
       de-aux[4]    to  98  format ">>>>>>>>>>9.99"
       0            to 115  format ">>>>>>>9.99" 
       "3"          at 117 
       de-aux[10]   to 132  format ">>>>>>>>>>9.99"
       0            to 144  format ">>>>>>>9.99".
 
   if  de-auxi > 0 then
       /* Inicio -- Projeto Internacional */
       DO:
       DEFINE VARIABLE c-lbl-liter-credito AS CHARACTER FORMAT "X(10)" NO-UNDO.
       {utp/ut-liter.i "CREDITO" *}
       ASSIGN c-lbl-liter-credito = TRIM(RETURN-VALUE).
       put c-lbl-liter-credito + ":"       at 146 skip.
       END. 
                                  
   run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).

   put  "ST"         at  82
        de-aux[5]    to  98  format ">>>>>>>>>>9.99"
        de-aux[6]    to 115  format ">>>>>>>9.99".
  
   if  de-auxi > 0 then
       do:
           put de-auxi AT 146 format ">>>>>>>>9.99" skip.
       end.  
  
   if (c-estado = "MG"
   or c-estado = "PE") and de-aux[12] > 0 then do:
       run pi-verifica-linhas in h-esof0540e (line-counter,1,c-localiz).
   
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-obs AS CHARACTER FORMAT "X(5)" NO-UNDO.
       {utp/ut-liter.i "OBS" *}
       ASSIGN c-lbl-liter-obs = TRIM(RETURN-VALUE).
       put  c-lbl-liter-obs        at 117
            de-aux[12]   to 132  format ">>>>>>>>9.99"
            0            to 144  format ">>>>>>>9.99" skip.
   end.                           
end.
assign de-aux = 0. /* nao retirar esta linha de comando */

/* Fim do programa esof0540C.p  */

