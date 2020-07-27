          
DEFINE INPUT PARAM p-ind-event                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-ind-object                   AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                   AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table                    AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-row-table                    AS RECID         NO-UNDO.

DEFINE New Global Shared Var apb711zd-br-titulos         As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cod_estab          As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cod_tit_ap         As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cdn_fornecedor     As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cod_espec_docto     As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cod_ser_docto       As Widget-handle No-undo.
DEFINE New Global Shared Var apb711zd_tta_cod_parcela         As Widget-handle No-undo.



DEFINE New Global Shared Var apb711zd-situacao           As Widget-handle No-undo.
DEFINE NEW GLOBAL SHARED VAR apb711zd-bordero            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR apb711zd-dda                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR apb711zd-portador           AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE wh-query  As Handle    No-undo.
DEFINE VARIABLE wh-buffer As Handle    No-undo.
DEF new global shared var wh-fkis1 AS HANDLE EXTENT 21 NO-UNDO.

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
                        Input "br_pagto_conjunto",        
                        Output apb711zd-br-titulos). 


        ASSIGN wh-fkis1[1] = apb711zd-br-titulos:GET-BROWSE-COLUMN (1)
               wh-fkis1[2] = apb711zd-br-titulos:GET-BROWSE-COLUMN (2)
               wh-fkis1[3] = apb711zd-br-titulos:GET-BROWSE-COLUMN (3)
               wh-fkis1[4] = apb711zd-br-titulos:GET-BROWSE-COLUMN (4)
               wh-fkis1[5] = apb711zd-br-titulos:GET-BROWSE-COLUMN (5)
               wh-fkis1[6] = apb711zd-br-titulos:GET-BROWSE-COLUMN (6)
               wh-fkis1[7] = apb711zd-br-titulos:GET-BROWSE-COLUMN (7)
               wh-fkis1[8] = apb711zd-br-titulos:GET-BROWSE-COLUMN (8)
               wh-fkis1[9] = apb711zd-br-titulos:GET-BROWSE-COLUMN (9)
               wh-fkis1[10] = apb711zd-br-titulos:GET-BROWSE-COLUMN (10)
               wh-fkis1[11] = apb711zd-br-titulos:GET-BROWSE-COLUMN (11)
               wh-fkis1[12] = apb711zd-br-titulos:GET-BROWSE-COLUMN (12)
               wh-fkis1[13] = apb711zd-br-titulos:GET-BROWSE-COLUMN (13)
               wh-fkis1[14] = apb711zd-br-titulos:GET-BROWSE-COLUMN (14)
               wh-fkis1[15] = apb711zd-br-titulos:GET-BROWSE-COLUMN (15)
               wh-fkis1[16] = apb711zd-br-titulos:GET-BROWSE-COLUMN (16)
               wh-fkis1[17] = apb711zd-br-titulos:GET-BROWSE-COLUMN (17)
               wh-fkis1[18] = apb711zd-br-titulos:GET-BROWSE-COLUMN (18)
               wh-fkis1[19] = apb711zd-br-titulos:GET-BROWSE-COLUMN (19)
               wh-fkis1[20] = apb711zd-br-titulos:GET-BROWSE-COLUMN (20)
               wh-fkis1[21] = apb711zd-br-titulos:GET-BROWSE-COLUMN (21).


        On "Row-Display":U Of apb711zd-br-titulos                                                                                              
                            Persistent Run upc/upc-apb711zd.p("Row-Display",                                                        
                                                                    "br-titulos",                                                             
                                                                     p-wgh-object,                                                             
                                                                     p-wgh-frame,                                                              
                                                                     p-cod-table,                                                              
                                                                     p-row-table). 
 
        Assign wh-query  = apb711zd-br-titulos:Query.
        Assign wh-buffer = wh-query:Get-buffer-handle(1) No-error.

        ASSIGN apb711zd_tta_cod_estab               = wh-buffer:buffer-field("tta_cod_estab")
               apb711zd_tta_cod_tit_ap              = wh-buffer:buffer-field("tta_cod_tit_ap")
               apb711zd_tta_cdn_fornecedor          = wh-buffer:buffer-field("tta_cdn_fornecedor")
               apb711zd_tta_cod_espec_docto         = wh-buffer:buffer-field("tta_cod_espec_docto")
               apb711zd_tta_cod_ser_docto           = wh-buffer:buffer-field("tta_cod_ser_docto")
               apb711zd_tta_cod_parcela             = wh-buffer:buffer-field("tta_cod_parcela").


END.
                                                
    If  p-ind-event    = "Row-Display":U    
    And p-ind-object   = "br-titulos":U Then Do: 



        FIND FIRST  tit_ap NO-LOCK WHERE tit_ap.cod_estab           = apb711zd_tta_cod_estab:BUFFER-VALUE
                                   and   tit_ap.cod_tit_ap          = apb711zd_tta_cod_tit_ap:BUFFER-VALUE
                                   and   tit_ap.cdn_fornecedor      = int(apb711zd_tta_cdn_fornecedor:BUFFER-VALUE)
                                   and   tit_ap.cod_espec_docto     = apb711zd_tta_cod_espec_docto:BUFFER-VALUE
                                   and   tit_ap.cod_ser_docto       = apb711zd_tta_cod_ser_docto:BUFFER-VALUE
                                   and   tit_ap.cod_parcela         = apb711zd_tta_cod_parcela:BUFFER-VALUE
                                   AND   tit_ap.cb4_tit_ap_bco_cobdor <> "" NO-ERROR.

        IF AVAIL tit_ap THEN DO:


            wh-fkis1[1]:BGCOLOR = 10.
            wh-fkis1[2]:BGCOLOR = 10.
            wh-fkis1[3]:BGCOLOR = 10.
            wh-fkis1[4]:BGCOLOR = 10.
            wh-fkis1[5]:BGCOLOR = 10.
            wh-fkis1[6]:BGCOLOR = 10.
            wh-fkis1[7]:BGCOLOR = 10.
            wh-fkis1[8]:BGCOLOR = 10.
            wh-fkis1[9]:BGCOLOR = 10.
            wh-fkis1[10]:BGCOLOR = 10.
            wh-fkis1[11]:BGCOLOR = 10.
            wh-fkis1[12]:BGCOLOR = 10.
            wh-fkis1[13]:BGCOLOR = 10.
            wh-fkis1[14]:BGCOLOR = 10.
            wh-fkis1[15]:BGCOLOR = 10.
            wh-fkis1[16]:BGCOLOR = 10.
            wh-fkis1[17]:BGCOLOR = 10.
            wh-fkis1[18]:BGCOLOR = 10.
            wh-fkis1[19]:BGCOLOR = 10.
            wh-fkis1[20]:BGCOLOR = 10.
            wh-fkis1[21]:BGCOLOR = 10.

        END.


        FIND FIRST  tit_ap NO-LOCK WHERE tit_ap.cod_estab           = apb711zd_tta_cod_estab:BUFFER-VALUE
                                   and   tit_ap.cod_tit_ap          = apb711zd_tta_cod_tit_ap:BUFFER-VALUE
                                   and   tit_ap.cdn_fornecedor      = int(apb711zd_tta_cdn_fornecedor:BUFFER-VALUE)
                                   and   tit_ap.cod_espec_docto     = apb711zd_tta_cod_espec_docto:BUFFER-VALUE
                                   and   tit_ap.cod_ser_docto       = apb711zd_tta_cod_ser_docto:BUFFER-VALUE
                                   and   tit_ap.cod_parcela         = apb711zd_tta_cod_parcela:BUFFER-VALUE
                                   AND   tit_ap.ind_origin_tit_ap   = "HR" NO-ERROR.

        IF AVAIL tit_ap THEN DO:


            wh-fkis1[1]:BGCOLOR = 14.
            wh-fkis1[2]:BGCOLOR = 14.
            wh-fkis1[3]:BGCOLOR = 14.
            wh-fkis1[4]:BGCOLOR = 14.
            wh-fkis1[5]:BGCOLOR = 14.
            wh-fkis1[6]:BGCOLOR = 14.
            wh-fkis1[7]:BGCOLOR = 14.
            wh-fkis1[8]:BGCOLOR = 14.
            wh-fkis1[9]:BGCOLOR = 14.
            wh-fkis1[10]:BGCOLOR = 14.
            wh-fkis1[11]:BGCOLOR = 14.
            wh-fkis1[12]:BGCOLOR = 14.
            wh-fkis1[13]:BGCOLOR = 14.
            wh-fkis1[14]:BGCOLOR = 14.
            wh-fkis1[15]:BGCOLOR = 14.
            wh-fkis1[16]:BGCOLOR = 14.
            wh-fkis1[17]:BGCOLOR = 14.
            wh-fkis1[18]:BGCOLOR = 14.
            wh-fkis1[19]:BGCOLOR = 14.
            wh-fkis1[20]:BGCOLOR = 14.
            wh-fkis1[21]:BGCOLOR = 14.

        END.

        
         


    
    /*       For  First tit_Acr No-lock                                                     */
    /*            Where tit_acr.cod_estab      = acr240aa_tta_cod_estab:BUFFER-VALUE        */
    /*              And tit_Acr.num_id_tit_acr = acr240aa_tta_num_id_tit_acr:BUFFER-VALUE : */
    /*                                                                                      */
    /*           Assign acr240aa-situacao:Screen-value = tit_Acr.ind_sit_bcia_tit_acr.      */
    
    
              
    END.    
END PROCEDURE.


