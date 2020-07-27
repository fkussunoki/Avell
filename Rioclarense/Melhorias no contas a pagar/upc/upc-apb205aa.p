          
DEFINE INPUT PARAM p-ind-event                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-ind-object                   AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                   AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-row-table                    AS RECID         NO-UNDO.

DEFINE New Global Shared Var apb205aa-br-titulos         As Widget-handle No-undo.
DEFINE New Global Shared Var apb205aa_tta_cod_estab      As Widget-handle No-undo.
DEFINE New Global Shared Var apb205aa_tta_num_id_tit_ap  As Widget-handle No-undo.
DEFINE New Global Shared Var apb205aa-situacao           As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR apb205aa-bordero            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR apb205aa-dda                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR apb205aa-portador           AS WIDGET-HANDLE NO-UNDO.


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
                        Input "br_tit_ap_em_aberto_corp",        
                        Output apb205aa-br-titulos). 


        On "Row-Display":U Of apb205aa-br-titulos                                                                                              
                            Persistent Run upc/upc-apb205aa.p("Row-Display",                                                        
                                                                    "br-titulos",                                                             
                                                                     p-wgh-object,                                                             
                                                                     p-wgh-frame,                                                              
                                                                     p-cod-table,                                                              
                                                                     p-row-table). 
            
        Assign wh-query  = apb205aa-br-titulos:Query.
        Assign wh-buffer = wh-query:Get-buffer-handle(1) No-error.
        

       
        Assign apb205aa-situacao                 = apb205aa-br-titulos:Add-calc-column("Character","X(40)","","Situacao"    ,1)
               apb205aa-situacao:Width           = 12
               APB205aa-br-titulos:Column-resizable = TRUE.
               
       ASSIGN  apb205aa-bordero                   = apb205aa-br-titulos:ADD-CALC-COLUM("Character", "x(4)", "", "Bordero", 2 )
               apb205aa-bordero:WIDTH             = 6
                APB205aa-br-titulos:Column-resizable = TRUE.              
               
       ASSIGN  apb205aa-portador                  = apb205aa-br-titulos:ADD-CALC-COLUM("Character", "x(8)", "", "Portador", 3 )
               apb205aa-portador:WIDTH            = 8
               APB205aa-br-titulos:Column-resizable = TRUE.
               
               
               
      ASSIGN   apb205aa-dda                       = apb205aa-br-titulos:ADD-CALC-COLUM("Character", "x(8)", "", "C/Barras", 4 )
               apb205aa-dda:WIDTH                 = 8 
               APB205aa-br-titulos:Column-resizable = TRUE.
               
          Assign  apb205aa_tta_num_id_tit_ap         = wh-buffer:Buffer-field("tta_num_id_tit_ap")
                  apb205aa_tta_cod_estab             = wh-buffer:Buffer-field("tta_cod_estab").
                  
               
               

    End.
                                                
    If  p-ind-event    = "Row-Display":U    
    And p-ind-object   = "br-titulos":U Then Do: 


     FIND FIRST tit_ap NO-LOCK WHERE tit_ap.num_id_tit_ap = apb205aa_tta_num_id_tit_ap:BUFFER-VALUE
                               AND   tit_ap.cod_estab     = apb205aa_tta_cod_estab:BUFFER-VALUE  NO-ERROR.


     IF tit_ap.cb4_tit_ap_bco_cobdor <> "" THEN DO:
         
         ASSIGN apb205aa-dda:SCREEN-VALUE = "Sim"
                apb205aa-dda:BGCOLOR          = 10.

     END.


     FIND last item_bord_ap NO-LOCK WHERE item_bord_ap.cod_empresa           = tit_ap.cod_empresa
                                     AND   item_bord_ap.cod_estab             = tit_ap.cod_estab
                                     AND   item_bord_ap.cod_espec_docto       = tit_ap.cod_espec_docto
                                     AND   item_bord_ap.cod_ser_docto         = tit_ap.cod_ser_docto
                                     AND   item_bord_ap.cdn_fornecedor        = tit_ap.cdn_fornecedor
                                     AND   item_bord_ap.cod_tit_ap            = tit_ap.cod_tit_ap
                                     AND   item_bord_ap.cod_parcela           = tit_ap.cod_parcela
                                     AND   item_bord_ap.val_pagto             = tit_ap.val_sdo_tit_ap 
                                     AND   item_bord_ap.ind_sit_item_bord_ap  <> "estornado" NO-ERROR.


         IF AVAIL item_bord_ap THEN DO:
             
             ASSIGN apb205aa-situacao:SCREEN-VALUE = string(item_bord_ap.ind_sit_item_bord_ap)
                    apb205aa-situacao:BGCOLOR      = 10
                    apb205aa-bordero:SCREEN-VALUE  = string(item_bord_ap.num_bord_ap)
                    apb205aa-bordero:BGCOLOR       = 10
                    apb205aa-portador:SCREEN-VALUE = item_bord_ap.cod_portador
                    apb205aa-portador:BGCOLOR      = 10.
    
    
    
    /*       For  First tit_Acr No-lock                                                     */
    /*            Where tit_acr.cod_estab      = acr240aa_tta_cod_estab:BUFFER-VALUE        */
    /*              And tit_Acr.num_id_tit_acr = acr240aa_tta_num_id_tit_acr:BUFFER-VALUE : */
    /*                                                                                      */
    /*           Assign acr240aa-situacao:Screen-value = tit_Acr.ind_sit_bcia_tit_acr.      */
    
    
              
    
        End.
END.
END PROCEDURE.

