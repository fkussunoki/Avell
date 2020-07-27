
/*************** UPRE1001C.P - Chamado pelo RE1001C na Atualiza»ao de documentos ************/

/* definicao de parametros */
Def Input Parameter p-ind-event         As Char             No-Undo.
Def Input Parameter p-ind-object        As Char             No-Undo.
Def Input Parameter p-wgh-object        As Handle           No-Undo.
Def Input Parameter p-wgh-frame         As Widget-Handle    No-Undo.
Def Input Parameter p-cod-table         As Char             No-Undo.
Def Input Parameter p-row-table         As Rowid            No-Undo.

/* definicao de variaveis */
Def Var c-objeto                        As Char             No-undo.
Def Var h_frame                         As Handle           No-undo.
Def Var h-frame2                        As Handle           No-undo.
Def Var h-panel-frame                   As Handle           No-undo.
Def New Global Shared Var h_dt-vencim      As HANDLE           No-undo.

Def New Global Shared Var h_dt-vencim1      As HANDLE           No-undo.
Def New Global Shared Var h_MILAGRE      As HANDLE           No-undo.
Def New Global Shared Var h_ct-codigo      As HANDLE           No-undo.
Def New Global Shared Var h_requisitante      As HANDLE           No-undo.
Def New Global Shared Var wh-bt-conf    As Widget-handle    No-undo.
Def New Global Shared Var h-cod-emitente   As HANDLE       No-undo.
Def New Global Shared Var h-serie-docto    As HANDLE       No-undo.
Def New Global Shared Var h-nro-docto      As HANDLE       No-undo.
Def New Global Shared Var h-nat-operacao   As HANDLE       No-undo.

/* main block */
/* Assign c-objeto = Entry(Num-entries(p-wgh-object:File-name, "~/"),  */
/*                   p-wgh-object:File-name, "~/").                    */
/*                                                                     */
/*     MESSAGE "Evento     " p-ind-event  SKIP                         */
/*             "Objeto     " p-ind-object SKIP                         */
/*             "nome obj   " c-objeto     SKIP                         */
/*             "Frame      " p-wgh-frame  SKIP                         */
/*             "Nome Frame " p-wgh-frame:NAME SKIP                     */
/*             "Tabela     " p-cod-table  SKIP                         */
/*             "ROWID      " STRING(p-row-table) SKIP                  */
/*             VIEW-AS ALERT-BOX INFORMATION.                          */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.
def new global shared var gr-item as rowid no-undo.
DEF VAR h-prog AS HANDLE.
 DEF NEW GLOBAL SHARED VAR H-OBJETO2       AS HANDLE NO-UNDO.
 DEF NEW GLOBAL SHARED VAR H-OBJETO3       AS HANDLE NO-UNDO.



if  p-ind-event = "AFTER-INITIALIZE" then do:



    /* Encontra a fPage1 */
    assign h_frame = p-wgh-frame:first-child.
    assign h_frame = h_frame:first-child.

    do  while valid-handle(h_frame):
        if  h_frame:type <> "field-group" then do:

            IF h_frame:NAME = "fpage1" THEN
            DO:
                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto2 = h_frame:FIRST-CHILD.
                    do  while valid-handle(h-objeto2):


                         IF  h-objeto2:TYPE <> "field-group" and
                             h-objeto2:TYPE <> "frame" THEN DO:

                             IF h-objeto2:NAME = "SC-CODIGO" THEN DO:

                                ASSIGN H_MILAGRE = H-OBJETO2.
                                ASSIGN h_MILAGRE:SCREEN-VALUE = "LEGAL".
                             END.


                               h-objeto2 = h-objeto2:NEXT-SIBLING.
                         END.
                         ELSE DO:
                               h-objeto2 = h-objeto2:FIRST-CHILD.
                         END.
                    END.

                END.
            END.


            IF h_frame:NAME = "fpage1" THEN
            DO:

                MESSAGE "ok" VIEW-AS ALERT-BOX.
                IF h_frame:TYPE = "frame" THEN DO:
                    ASSIGN h-objeto3 = h_frame:FIRST-CHILD.
                    do  while valid-handle(h-objeto3):


                         IF  h-objeto3:TYPE <> "field-group" and
                             h-objeto3:TYPE <> "frame" THEN DO:

                             IF h-objeto3:NAME = "requisitante" THEN DO:
                                
                                 ASSIGN h_requisitante = h-objeto3.


                             IF h-objeto3:NAME = "CT-CODIGO" THEN DO:

                                ASSIGN H_ct-codigo = H-OBJETO3.

                                ON 'LEAVE':U OF H_DT-VENCIM PERSISTENT RUN UPC\VAI.P.
                             END.


                               h-objeto3 = h-objeto3:NEXT-SIBLING.
                         END.
                         ELSE DO:
                               h-objeto3 = h-objeto3:FIRST-CHILD.
                         END.
                    END.

                END.
            END.




        if  h_frame:name = "it-codigo" then do:

                assign h_dt-vencim = h_frame.


                ON 'MOUSE-SELECT-DBLCLICK':U OF h_dt-vencim PERSISTENT RUN upc/teste.p.


                ON 'f3':U OF h_dt-vencim PERSISTENT RUN inzoom\z01in015.w.


            end.


            if  h_frame:name = "c-desc-item" then do:

                    assign h_dt-vencim1 = h_frame.


                end.

/*         IF h_frame:NAME = "fpage1" THEN                               */
/*         DO:                                                           */
/*             IF h_frame:TYPE = "frame" THEN DO:                        */
/*                 ASSIGN h-objeto2 = h_frame:FIRST-CHILD.               */
/*                 do  while valid-handle(h-objeto2):                    */
/*                                                                       */
/*                                                                       */
/*                      IF  h-objeto2:TYPE <> "field-group" and          */
/*                          h-objeto2:TYPE <> "frame" THEN DO:           */
/*                                                                       */
/*                          IF h-objeto2:NAME = "SC-CODIGO" THEN DO:     */
/*                             ASSIGN h-objeto2:SCREEN-VALUE = "LEGAL".  */
/*                          END.                                         */
/*                                                                       */
/*                            h-objeto2 = h-objeto2:NEXT-SIBLING.        */
/*                      END.                                             */
/*                      ELSE DO:                                         */
/*                            h-objeto2 = h-objeto2:FIRST-CHILD.         */
/*                      END.                                             */
/*                 END.                                                  */
/*                                                                       */
/*             END.                                                      */
/*         END.                                                          */

        assign h_frame = h_frame:next-sibling.
    end.
    else
        assign h_frame = h_frame:first-child.
        end.
    END.

