&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
**  Programa..: 
**  Autor.....: 
**  Data......: JUNHO/2010 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 - 00/00/2010
**                  Desenvolvimento Programa
************************************************************************/
{include/i-epc200.i apb760.py}
{cdp/cdcfgdis.i}

DEFINE INPUT        PARAMETER p-ind-event AS  CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEFINE BUFFER forma_pagto FOR emsfin.forma_pagto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* MESSAGE p-ind-event VIEW-AS ALERT-BOX.  */

/* FOR EACH tt-epc:                                                                */
/*     MESSAGE "tt-epc.cod-event -> " tt-epc.cod-event SKIP                        */
/*             "tt-epc.cod-parameter -> " tt-epc.cod-parameter SKIP                */
/*             "tt-epc.val-parameter -> " tt-epc.val-parameter VIEW-AS ALERT-BOX.  */
/* END.                                                                            */

IF p-ind-event = "Atualiza Forma Pagto" THEN DO:

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "recid_item_bord" NO-ERROR.
    IF NOT AVAIL tt-epc THEN
        RETURN.

    FIND FIRST item_bord_ap WHERE RECID(item_bord_ap) = INTEGER(tt-epc.val-parameter) NO-LOCK NO-ERROR.
    IF NOT AVAIL item_bord_ap THEN
        RETURN.

    FIND FIRST forma_pagto OF item_bord_ap NO-LOCK NO-ERROR.
    IF NOT AVAIL forma_pagto THEN
        RETURN.

    IF forma_pagto.ind_tip_forma_pagto = "Cr‚dito Conta Corrente" THEN DO:
            
        FIND FIRST forma_pagto_bco OF forma_pagto NO-LOCK
             WHERE forma_pagto_bco.cod_banco EQ "001" NO-ERROR.

        IF AVAIL forma_pagto_bco AND 
           forma_pagto_bco.cod_forma_pagto_bco EQ "15" THEN DO: /* Cr‚dito Conta Poupan‡a - 001-Banco do Brasil */
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = p-ind-event
                   tt-epc.cod-parameter = "Retorno Forma Pagto"
                   tt-epc.val-parameter = "Cr‚dito C/P"          /* cod_id_bloco_msg_edi */
                                          + CHR(10) + "15".      /* cdn_tip_forma_pagto */
        END.
    END.

END.
RETURN "OK".


/*     if  v_nom_prog_upc <> ''                                                                                               */
/*     then do:                                                                                                               */
/*         for each tt_epc:                                                                                                   */
/*             delete tt_epc.                                                                                                 */
/*         end.                                                                                                               */
/*                                                                                                                            */
/*         create tt_epc.                                                                                                     */
/*         assign tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                               */
/*                tt_epc.cod_parameter = 'recid_item_bord'                                                                    */
/*                tt_epc.val_parameter = string(recid(item_bord_ap)).                                                         */
/*         create tt_epc.                                                                                                     */
/*         assign tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                               */
/*                tt_epc.cod_parameter = 'recid_forma_bco'                                                                    */
/*                tt_epc.val_parameter = string(recid(forma_pagto_bco)).                                                      */
/*                                                                                                                            */
/*         /* Begin_Include: i_exec_program_epc_custom */                                                                     */
/*         if  v_nom_prog_upc <> '' then                                                                                      */
/*         do:                                                                                                                */
/*             run value(v_nom_prog_upc) (input 'Atualiza Forma Pagto',                                                       */
/*                                        input-output table tt_epc).                                                         */
/*         end.                                                                                                               */
/*         /* End_Include: i_exec_program_epc_custom */                                                                       */
/*                                                                                                                            */
/*         if  return-value = "OK" /*l_ok*/                                                                                   */
/*         then do:                                                                                                           */
/*             find first tt_epc no-lock                                                                                      */
/*                 where tt_epc.cod_event     = 'Atualiza Forma Pagto'                                                        */
/*                 and   tt_epc.cod_parameter = 'Retorno Forma Pagto'                                                         */
/*                 no-error.                                                                                                  */
/*             if avail tt_epc and                                                                                            */
/*                tt_epc.val_parameter <> ""  and                                                                             */
/*                num-entries(tt_epc.val_parameter,chr(10)) >= 2 then                                                         */
/*                assign tt_detail_msg_pagto_edi_mpf.ttv_cod_id_bloco_msg_edi = entry(1,tt_epc.val_parameter, chr(10))        */
/*                       tt_detail_msg_pagto_edi_mpf.ttv_cdn_tip_forma_pagto  = int(entry(2,tt_epc.val_parameter, chr(10))).  */
/*         end.                                                                                                               */
/*         for each tt_epc:                                                                                                   */
/*             delete tt_epc.                                                                                                 */
/*         end.                                                                                                               */
/*     end.                                                                                                                   */
/*                                                                                                                            */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


