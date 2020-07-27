/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza¯ao de documentos ************/

/* definicao de parametros */
Def Input Parameter p-ind-event         As Char             No-Undo.
Def Input Parameter p-ind-object        As Char             No-Undo.
Def Input Parameter p-wgh-object        As Handle           No-Undo.
Def Input Parameter p-wgh-frame         As Widget-Handle    No-Undo.
Def Input Parameter p-cod-table         As Char             No-Undo.
Def Input Parameter p-row-table         As Recid            No-Undo.

/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.
DEF NEW GLOBAL SHARED VAR c-cpf AS char NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-cpf AS LOGICAL NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE whRecPedido AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whCPF       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whLabel     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whCorrente     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whOk     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_cta_fornec AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_sav        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE bt_ok         AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR v-cpf AS char NO-UNDO.
FUNCTION validaCPF RETURNS LOGICAL
( INPUT p-cpf AS CHAR ):

DEF VAR c-cpf AS CHAR NO-UNDO EXTENT 2.
DEF VAR i-count AS INT NO-UNDO.
DEF VAR i-mult AS INT NO-UNDO.
DEF VAR i-soma AS INT NO-UNDO.
DEF VAR c-digito AS CHAR NO-UNDO.

ASSIGN c-cpf[1] = SUBSTR(p-cpf,1,9)
c-cpf[2] = SUBSTR(p-cpf,10,2)
i-mult = 10
i-soma = 0
c-digito = ''.

DO i-count = 1 TO 9:

ASSIGN i-soma = i-soma + (INT(SUBSTR(c-cpf[1],i-count,1)) * i-mult)
i-mult = i-mult - 1.

END.

i-soma = i-soma MOD 11.

IF i-soma < 2 THEN 
c-digito = '0'.
ELSE
c-digito = STRING(11 - i-soma).

ASSIGN c-cpf[1] = c-cpf[1] + c-digito 
i-mult = 11
i-soma = 0.

DO i-count = 1 TO 10:

ASSIGN i-soma = i-soma + (INT(SUBSTR(c-cpf[1],i-count,1)) * i-mult)
i-mult = i-mult - 1.

END.

i-soma = i-soma MOD 11.

IF i-soma < 2 THEN
c-digito = c-digito + '0'.
ELSE
c-digito = c-digito + STRING(11 - i-soma).

RETURN c-digito = c-cpf[2].

END FUNCTION. /* validaCPF */







/* main block */
Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),
                  p-wgh-object:File-name, "~/").


IF p-ind-event  = 'initialize'   AND
   p-ind-object = 'viewer'       
THEN DO:

    

    CREATE TOGGLE-BOX whRecPedido
       ASSIGN FRAME         = p-wgh-frame
              LABEL         = "C/C P.Fisica"
              ROW           = 8.75       /*whOrgaoEstadual:ROW + 1*/
              COL           = 50.43 /*whOrgaoEstadual:COLUMNS*/
              CHECKED       = FALSE
              VISIBLE       = YES
              SENSITIVE     = YES
              TOOLTIP       = "Fornecedores que nao tramitam pelo RE1001"
              HELP          = "Fornecedores que nao tramitam pelo RE1001"

        TRIGGERS:
            ON 'value-changed':U PERSISTENT RUN upc/upc-ufn003za.p ( input "value-changed" ,
                                                            input "whRecPedido",
                                                            input p-wgh-object,
                                                            input p-wgh-frame ,
                                                            input p-cod-table ,
                                                            input p-row-table ).
      END TRIGGERS.


    CREATE TEXT whLabel 
        ASSIGN FRAME            = p-wgh-frame
               FORMAT           = "x(9)"
               WIDTH            = 9
               SCREEN-VALUE     = "CPF:"
               ROW              = 8.90
               COL              = 65
               VISIBLE          = YES.

    CREATE FILL-IN whCPF
       ASSIGN FRAME         = p-wgh-frame
              NAME               = 'whCPF'
              SIDE-LABEL-HANDLE  = whLabel 

              ROW           = 8.71       /*whOrgaoEstadual:ROW + 1*/
              COL           = 70.43 /*whOrgaoEstadual:COLUMNS*/
              WIDTH         = 15
              HEIGHT        = .88
              DATA-TYPE          = "character"
              FORMAT             = "999.999.999-99"

              VISIBLE       = YES
              SENSITIVE     = NO
              TOOLTIP       = "Fornecedores que nao tramitam pelo RE1001"
              HELP          = "Fornecedores que nao tramitam pelo RE1001"

        TRIGGERS:
            ON 'leave':U PERSISTENT RUN upc/upc-ufn003za.p ( input "leave" ,
                                                            input "whCPF",
                                                            input p-wgh-object,
                                                            input p-wgh-frame ,
                                                            input p-cod-table ,
                                                            input p-row-table ).
      END TRIGGERS.


      RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "button",    /*** Type ***/
                INPUT "bt_cta_fornec",    /*** Name ***/
                INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                OUTPUT bt_cta_fornec).

     ASSIGN bt_cta_fornec:WIDTH = (bt_cta_fornec:WIDTH) / 2
            bt_cta_fornec:LABEL = "C/C PJ".


        CREATE BUTTON whCorrente



            ASSIGN FRAME = p-wgh-frame
                   WIDTH = bt_cta_fornec:WIDTH 
                   HEIGHT = bt_cta_fornec:HEIGHT
                   LABEL = "C/C PF"
                   ROW = bt_cta_fornec:ROW
                   COL = bt_cta_fornec:COL + 9
                   FONT = ?
                   VISIBLE = true
                   SENSITIVE = NO
            TRIGGERS:
        ON CHOOSE PERSISTENT RUN esp/esrc713.p(INPUT p-row-table,
                                     INPUT v-cpf).  


           END TRIGGERS.




END.


IF p-ind-event  = 'validate'   AND
   p-ind-object = 'viewer' 
THEN DO:


    IF c-cpf <> "" THEN DO:
        
    
    
    FIND FIRST fornec_financ NO-LOCK WHERE recid(fornec_financ) = p-row-table NO-ERROR.
    ASSIGN SUBSTRING(fornec_financ.cod_livre_2, 86, 11)        = string("yes" + c-cpf).
 END.

END.

IF  p-ind-event = 'value-changed' 
AND p-ind-object = 'whRecPedido'  THEN DO:

    ASSIGN whcpf:SENSITIVE = YES.
    ASSIGN whCorrente:SENSITIVE = YES.
END.


IF p-ind-event = 'leave' 
AND p-ind-object = 'whCpf'  THEN DO:


    ASSIGN v-cpf = replace(replace(whCpf:SCREEN-VALUE, ".", ""), "-", "").

    IF v-cpf = " " THEN DO:
        
        ASSIGN l-cpf = YES.
        ASSIGN whcpf:SENSITIVE = no.
        ASSIGN whRecPedido:SCREEN-VALUE = "no".

        RETURN.

    END.


    IF validaCPF(INPUT v-cpf) = FALSE THEN DO: 
        
        
        MESSAGE 'CPF incorreto'  VIEW-AS ALERT-BOX.

        ASSIGN l-cpf = no.

    END.

    IF validaCPF(INPUT v-cpf) = TRUE THEN DO:
        
    ASSIGN c-cpf = replace(replace(whCpf:SCREEN-VALUE, ".", ""), "-", "")
        l-cpf = YES.

    END.


    IF l-cpf = no THEN DO:
        

        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",    /*** Type ***/
                  INPUT "bt_cta_fornec",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT bt_cta_fornec).


        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",    /*** Type ***/
                  INPUT "bt_sav",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT bt_sav).

        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",    /*** Type ***/
                  INPUT "bt_ok",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT bt_ok).

        ASSIGN bt_cta_fornec:SENSITIVE = NO
               bt_sav:SENSITIVE = no
               bt_ok:SENSITIVE = no.

        END.


/*         RUN tela-upc (INPUT p-wgh-frame,                                          */
/*                       INPUT p-ind-Event,                                          */
/*                       INPUT "button",    /*** Type ***/                           */
/*                       INPUT "bt_cta_fornec",    /*** Name ***/                    */
/*                       INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/ */
/*                       OUTPUT bt_cta_fornec).                                      */
/*                                                                                   */
/*         CREATE BUTTON whCorrente                                                  */
/*                                                                                   */
/*                                                                                   */
/*                                                                                   */
/*             ASSIGN FRAME = p-wgh-frame                                            */
/*                    WIDTH = 14.00                                                  */
/*                    HEIGHT = 01.00                                                 */
/*                    LABEL = "Conta Corrente"                                       */
/*                    ROW = bt_cta_fornec:ROW                                        */
/*                    COL = bt_cta_fornec:COL                                        */
/*                    FONT = ?                                                       */
/*                    VISIBLE = true                                                 */
/*                    SENSITIVE = FALSE.                                             */
/*                                                                                   */
/*         CREATE BUTTON whOk                                                        */
/*                                                                                   */
/*                                                                                   */
/*                                                                                   */
/*             ASSIGN FRAME = p-wgh-frame                                            */
/*                    WIDTH = 10.00                                                  */
/*                    HEIGHT = 01.00                                                 */
/*                    LABEL = "Executa"                                              */
/*                    ROW = 18.24                                                    */
/*                    COL = 3.00                                                     */
/*                    FONT = ?                                                       */
/*                    VISIBLE = true                                                 */
/*                    SENSITIVE = FALSE.                                             */
/*                                                                                   */
/*     END.                                                                          */
/*                                                                                   */
    IF l-cpf = YES THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",    /*** Type ***/
                  INPUT "bt_sav",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT bt_sav).


        RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",    /*** Type ***/
                  INPUT "bt_ok",    /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  OUTPUT bt_ok).

        RUN tela-upc (INPUT p-wgh-frame,
          INPUT p-ind-Event,
          INPUT "button",    /*** Type ***/
          INPUT "bt_cta_fornec",    /*** Name ***/
          INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
          OUTPUT bt_cta_fornec).


        ASSIGN bt_cta_fornec:SENSITIVE = YES
               bt_sav:SENSITIVE = YES
               bt_ok:SENSITIVE = YES.




/* DELETE WIDGET whCorrente.                                                         */
    END.


END.


PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):             
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    RETURN "OK".
END PROCEDURE.


