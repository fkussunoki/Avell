          
DEFINE INPUT PARAM p-ind-event                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-ind-object                   AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                   AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-row-table                    AS RECID         NO-UNDO.

DEFINE New Global Shared Var acr240aa-br-titulos         As Widget-handle No-undo.
DEFINE New Global Shared Var acr240aa_tta_cod_estab      As Widget-handle No-undo.
DEFINE New Global Shared Var acr240aa_tta_num_id_tit_acr As Widget-handle No-undo.
DEFINE New Global Shared Var acr240aa-situacao        As Widget-handle No-undo.

DEFINE VARIABLE wh-query  As Handle    No-undo.
DEFINE VARIABLE wh-buffer As Handle    No-undo.


/* ***************************  Bloco Principal *************************** */
Run trataUPC.

If  Return-value = "NOK":U Then 
   RETURN "NOK":U.
ELSE
   RETURN "OK":U.

/* **********************  Internal Procedures  *********************** */

PROCEDURE buscaHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE  Input  Param p-wgh-frame As  Widget-handle No-undo.
 DEFINE  Input  Param p-nome      As  CHARACTER     No-undo.
 DEFINE  Output Param p-wh        As  Widget-handle No-undo.
                              
  DEFINE VARIABLE wh-objeto   AS WIDGET-HANDLE NO-UNDO.

  IF p-wgh-frame:NAME = p-nome THEN
  DO:
      p-wh = p-wgh-frame.
      RETURN.
  END.

  assign wh-objeto     = p-wgh-frame:FIRST-CHILD.
  do while valid-handle(wh-objeto):
      if INDEX(LIST-QUERY-ATTRS(wh-objeto),"NAME") > 0 THEN
      DO:
          IF wh-objeto:NAME = p-nome THEN
          DO:
              p-wh = wh-objeto.
              LEAVE.
          END.
      END.
      if wh-objeto:TYPE = 'field-group' OR
         wh-objeto:TYPE = 'frame' THEN
      DO:
          RUN buscaHandle(wh-objeto, p-nome, OUTPUT p-wh).
          if valid-handle(p-wh) then leave.
      END.
      ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
  END.


END PROCEDURE.

PROCEDURE trataUPC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    If  p-ind-event    = "INITIALIZE":U 
    And p-ind-object   = "VIEWER":U Then Do:

        Run buscaHandle(Input p-wgh-frame,        
                        Input "br_tit_acr_em_aberto",        
                        Output acr240aa-br-titulos). 


        On "Row-Display":U Of acr240aa-br-titulos                                                                                              
                            Persistent Run esupc/upc-acr240aa.p("Row-Display",                                                        
                                                                    "br-titulos",                                                             
                                                                     p-wgh-object,                                                             
                                                                     p-wgh-frame,                                                              
                                                                     p-cod-table,                                                              
                                                                     p-row-table). 
 
        Assign wh-query  = acr240aa-br-titulos:Query.
        Assign wh-buffer = wh-query:Get-buffer-handle(1) No-error.


       
        Assign acr240aa-situacao                 = acr240aa-br-titulos:Add-calc-column("Character","X(40)","","Situacao"    ,7)
               acr240aa-situacao:Width           = 12
               acr240aa-br-titulos:Column-resizable = TRUE
               acr240aa_tta_num_id_tit_acr          = wh-buffer:Buffer-field("tta_num_id_tit_acr")
               acr240aa_tta_cod_estab               = wh-buffer:Buffer-field("tta_cod_estab").

    End.
                                                
    If  p-ind-event    = "Row-Display":U    
    And p-ind-object   = "br-titulos":U Then Do: 

      FOR LAST movto_ocor_bcia NO-LOCK WHERE movto_ocor_bcia.cod_estab = acr240aa_tta_cod_estab:BUFFER-VALUE
                                       AND   movto_ocor_bcia.num_id_tit_acr = acr240aa_tta_num_id_tit_acr:BUFFER-VALUE:



          CASE movto_ocor_bcia.ind_tip_ocor_bcia:

          WHEN    "Abatimento cancelado" THEN DO:
              Assign acr240aa-situacao:Screen-value = string("Abatimento Cancelado")
                     acr240aa-situacao:BGCOLOR = 10.

          END.   

              WHEN    "Abatimento concedido" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Abatimento Concedido")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN    "Baixa Autom†tica" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Baixa Autom†tica")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN    "Baixa Instruá∆o" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Baixa Instruá∆o")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN    "Cobranáa parcial" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Cobranáa Parcial")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              
              WHEN    "DÇbito Custas Cartoriais" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("DÇbito Custas Cartoriais")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN    "Emiss∆o de Carta de Protesto" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Emiss∆o de carta de protesto")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         


              WHEN    "Entrada Confirmada" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Registrado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN    "Entrada Rejeitada" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("N∆o Confirmado")
                         acr240aa-situacao:BGCOLOR = 14.

              END.                         

              WHEN    "Entrada de Pedidos de Protesto" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protestado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         

              WHEN    "Entrada de Pedidos de Protesto" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protestado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         

              WHEN    "Enviado Cart¢rio" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protestado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                     

              WHEN  "Liquidaá∆o cart¢rio" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         

              WHEN  "Liquidaá∆o compensaá∆o" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              WHEN  "Liquidaá∆o conta" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              WHEN  "Liquidaá∆o normal" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              WHEN  "Liquidaá∆o saldo" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         


              WHEN    "Outras Baixas" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Baixado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              WHEN    "Outras Liquidaá‰es" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Liquidado")
                         acr240aa-situacao:BGCOLOR = 10.

              END.                         
              WHEN    "Protesto Sustado" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protesto Sustado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         
              WHEN    "Protesto n∆o Sustado" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protestado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         
              WHEN    "Protesto devolvido cart¢rio" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Protestado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         
              WHEN    "Vencimento Alterado" THEN DO:
                  Assign acr240aa-situacao:Screen-value = string("Vcto Alterado")
                         acr240aa-situacao:BGCOLOR = 12.

              END.                         

               OTHERWISE DO:
                   Assign acr240aa-situacao:Screen-value = string("Enviado para Registro")
                          acr240aa-situacao:BGCOLOR = 9.
                   
               END.









          END CASE.


































      END.


/*       For  First tit_Acr No-lock                                                     */
/*            Where tit_acr.cod_estab      = acr240aa_tta_cod_estab:BUFFER-VALUE        */
/*              And tit_Acr.num_id_tit_acr = acr240aa_tta_num_id_tit_acr:BUFFER-VALUE : */
/*                                                                                      */
/*           Assign acr240aa-situacao:Screen-value = tit_Acr.ind_sit_bcia_tit_acr.      */


          

    End.

END PROCEDURE.

