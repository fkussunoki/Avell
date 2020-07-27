/*****************************************************************
**
**  I-RPLBL.I - Cria os labels para os DumbFolder do relat½rio
**
*******************************************************************/

DEF VAR wh-label-sel     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-cla     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-par     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-dig     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-imp     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-group         AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-child         AS WIDGET-HANDLE NO-UNDO.
DEF VAR c-list-folders   AS CHAR          NO-UNDO.
DEF VAR i-current-folder AS INTEGER       NO-UNDO.
DEF VAR i-new-folder     AS INTEGER       NO-UNDO.
DEF VAR c-aux            AS CHAR NO-UNDO.
/* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
DEF VAR c-modelo-aux     AS CHAR          NO-UNDO.
DEF VAR l-rtf            AS LOGICAL  INITIAL NO NO-UNDO.
DEF VAR i-aux            AS INTEGER NO-UNDO.


/*tech14178 carrega parametros e define botÆo para inicializa‡Æo do PDF */
&IF "{&PDF}" = "YES" &THEN /*tech868*/

RUN btb/btb920aa.p PERSISTENT SET h_pdf_controller.

RUN pi_prepare_permissions IN h_pdf_controller(INPUT c-programa-mg97).

RUN pi_define_objetos IN h_pdf_controller (INPUT FRAME f-pg-imp:HANDLE,
                                           INPUT rs-destino:HANDLE,
                                           INPUT c-arquivo:HANDLE,
                                           INPUT (bt-arquivo:ROW IN FRAME f-pg-imp  - (bt-arquivo:HEIGHT IN FRAME f-pg-imp + 0.1)),
                                           INPUT (bt-arquivo:COLUMN IN FRAME f-pg-imp)).
&endif
/* FIM PDF */






&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
    DEFINE NEW GLOBAL SHARED VARIABLE h-facelift AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(h-facelift) THEN RUN btb/btb901zo.p PERSISTENT SET h-facelift.
&ENDIF

/* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
ON  CLOSE OF THIS-PROCEDURE DO:
    {include/i-logfin.i}  
    RUN disable_ui.
    &IF "{&PDF}" = "YES" &THEN
        DELETE PROCEDURE h_pdf_controller.
    &ENDIF
END.
&if "{&PGIMP}" <> "" &then
    ON "LEAVE" OF c-arquivo IN FRAME f-pg-imp DO:
        IF rs-execucao = 1 THEN
            ASSIGN c-arq-old = c-arquivo:SCREEN-VALUE.
        ELSE
            ASSIGN c-arq-old-batch = c-arquivo:SCREEN-VALUE.
    END.
    
    ON "ENTER":U OF c-arquivo IN FRAME f-pg-imp OR
       "RETURN":U OF c-arquivo IN FRAME f-pg-imp OR
       "CTRL-ENTER":U OF c-arquivo IN FRAME f-pg-imp OR
       "CTRL-J":U OF c-arquivo IN FRAME f-pg-imp OR
       "CTRL-Z":U OF c-arquivo IN FRAME f-pg-imp DO:
        RETURN NO-APPLY.
    END.
    
/* tech1139 - FO 1223.694  - 02/11/2005 */
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    
     ON "~\" OF c-arquivo IN FRAME f-pg-imp DO:
         APPLY "/" TO c-arquivo IN FRAME f-pg-imp.
         RETURN NO-APPLY.
     END.

    &ENDIF
/* tech1139 - FO 1223.694  - 02/11/2005 */

    /*Alterado 07/03/2005 - tech14187 - Realizado teste de preprocessador para
    verificar se o RTF est  ativo*/
   &IF "{&RTF}":U = "YES":U &THEN
   
/* tech1139 - FO 1223.694  - 02/11/2005 */
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 

     ON "~\" OF c-modelo-rtf IN FRAME f-pg-imp DO:
         APPLY "/" TO c-modelo-rtf IN FRAME f-pg-imp.
         RETURN NO-APPLY.
     END.

    &ENDIF
/* tech1139 - FO 1223.694  - 02/11/2005 */

   &endif
    /*Fim alteracao 07/03/2005*/


    /* 04/03/2005 Alterado para funcionalidade de RTF sem a opcao de RTF como destino*/  
    ON "VALUE-CHANGED":U OF rs-destino IN FRAME f-pg-imp DO:
        CASE rs-destino:SCREEN-VALUE IN FRAME f-pg-imp:
            WHEN "1" THEN DO:

                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                &IF "{&RTF}":U = "YES":U &THEN
                IF l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp <> "No" THEN DO:
                   ASSIGN l-rtf = YES
                          c-modelo-aux = c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp.
                END.
                &endif
                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/

                ASSIGN c-arquivo                                = c-imp-old
                       c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-imp-old
                       c-arquivo:SENSITIVE IN FRAME f-pg-imp    = NO
                       c-arquivo:VISIBLE IN FRAME f-pg-imp      = YES
                       bt-arquivo:VISIBLE IN FRAME f-pg-imp     = NO
                       bt-config-impr:VISIBLE IN FRAME f-pg-imp = YES
                /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                verificar se o RTF est  ativo*/
                       &IF "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                       l-habilitaRtf = NO
                       &endif
                /*Fim alteracao 17/02/2005*/
                       .
                IF c-imp-old = "" THEN
                   RUN pi-impres-pad.
            END.
            WHEN "2" THEN DO:                                   
                ASSIGN c-arquivo = IF rs-execucao = 1 THEN c-arq-old
                                   ELSE c-arq-old-batch NO-ERROR.                  
                                     
                IF c-arquivo = "" THEN DO:                                     
                   FIND usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
        
                   IF AVAIL usuar_mestre THEN 
                      ASSIGN c-arquivo = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN 
                                            CAPS(REPLACE(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, " ", "~/") + "~/" + c-programa-mg97)
                                          ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + c-programa-mg97)
                             c-arq-old = c-arquivo.
                                 
                   ELSE ASSIGN c-arquivo = CAPS("spool~/":U + c-programa-mg97)
                               c-arq-old = c-arquivo.                               
                   
                   IF rs-execucao <> 1 THEN                    
                      ASSIGN c-arquivo = CAPS(c-programa-mg97).                                                                               
                END.     
                                                                                                                                                
                ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-arquivo
                       c-arquivo:SENSITIVE IN FRAME f-pg-imp    = YES
                       c-arquivo:VISIBLE IN FRAME f-pg-imp      = YES
                       bt-arquivo:VISIBLE IN FRAME f-pg-imp     = YES
                       bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO
                       /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                         verificar se o RTF est  ativo*/
                       &IF "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:sensitive  = YES
                       &endif
                       /*Fim alteracao 17/02/2005*/
                       .

                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                &IF "{&RTF}":U = "YES":U &THEN
                IF l-rtf = YES THEN DO:
                   ASSIGN l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "Yes"
                          l-rtf = NO
                          c-modelo-rtf = c-modelo-aux
                          c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp = c-modelo-aux.
                END.
                &endif
                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                
            END.
            WHEN "3" THEN DO:
                ASSIGN c-arquivo                                = ""
                       c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-arquivo
                       c-arquivo:VISIBLE IN FRAME f-pg-imp      = NO
                       bt-arquivo:VISIBLE IN FRAME f-pg-imp     = NO                       
                       bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO
                       /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                         verificar se o RTF est  ativo*/
                       &IF "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:sensitive  = YES
                       &endif
                       /*Fim alteracao 17/02/2005*/
                       .
                /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
                &IF "{&RTF}":U = "YES":U &THEN
                IF VALID-HANDLE(hWenController) THEN DO:
                    ASSIGN l-habilitaRtf:sensitive  = NO
                           l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                           l-habilitaRtf = NO.
                END.
                &endif
                /*Fim alteracao 15/02/2005*/                                        

                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                &IF "{&RTF}":U = "YES":U &THEN
                IF l-rtf = YES THEN DO:
                    ASSIGN l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "Yes"
                           l-rtf = NO
                           c-modelo-rtf = c-modelo-aux
                           c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp = c-modelo-aux.
                END.
                &endif
                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/

            END.
            WHEN "4" THEN DO:
                ASSIGN c-arquivo = IF rs-execucao = 1 THEN ENTRY(1, c-arq-old, ".") 
                                   ELSE ENTRY(1, c-arq-old-batch, ".") NO-ERROR.                  
                                   
                IF c-arquivo = "" THEN DO:                                     
                   FIND usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
        
                   IF AVAIL usuar_mestre THEN 
                      ASSIGN c-arquivo = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN 
                                            CAPS(REPLACE(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, " ", "~/") + "~/" + c-programa-mg97)
                                          ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, " ", "~/") + "~/" + c-programa-mg97)
                             c-arq-old = c-arquivo.
                                 
                   ELSE ASSIGN c-arquivo = CAPS("spool~/":U + c-programa-mg97)
                               c-arq-old = c-arquivo.                               
                   
                   IF rs-execucao <> 1 THEN                    
                      ASSIGN c-arquivo = CAPS(c-programa-mg97).                                                                               
                END.                      
                                                                      
                ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-arquivo + ".XML"
                       c-arquivo:SENSITIVE IN FRAME f-pg-imp    = YES
                       c-arquivo:VISIBLE IN FRAME f-pg-imp      = YES
                       bt-arquivo:VISIBLE IN FRAME f-pg-imp     = YES
                       bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO
                       /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                         verificar se o RTF est  ativo*/
                       &IF "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:sensitive  = YES
                       &endif
                       /*Fim alteracao 17/02/2005*/
                       .

                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                &IF "{&RTF}":U = "YES":U &THEN
                IF l-rtf = YES THEN DO:
                   ASSIGN l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "Yes"
                          l-rtf = NO
                          c-modelo-rtf = c-modelo-aux
                          c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp = c-modelo-aux.
                END.
                &endif
                /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
                
            END.
            
        END CASE.
        &IF "{&RTF}":U = "YES":U &THEN
        RUN pi-habilitaRtf.
        &endif
        /*Fim alteracao 04/03/2005*/
    END.

&endif
/********************************************
** HELP FRAME
********************************************/
ON HELP OF FRAME F-RELAT DO:
    {include/ajuda.i}
END.
&IF "{&PGSEL}" &THEN 
ON HELP OF FRAME F-PG-SEL DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGCLA}" &THEN 
ON HELP OF FRAME F-PG-CLA DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGPAR}" &THEN 
ON HELP OF FRAME F-PG-PAR DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGDIG}" &THEN 
ON HELP OF FRAME F-PG-DIG DO:
    {include/ajuda.i}
END.
&ENDIF
&IF "{&PGIMP}" &THEN 
ON HELP OF FRAME F-PG-IMP DO:
    {include/ajuda.i}
END.
&ENDIF
/********************************************************** 
** Tradu»’o pÿgina 0 - frame f-relat 
**********************************************************/
DO  WITH FRAME f-relat:
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
        /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
        RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-relat:handle ).
    &ENDIF
    ASSIGN wh-group = FRAME f-relat:handle
           wh-group = wh-group:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(wh-group):
        ASSIGN wh-child = wh-group:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(wh-child):
            &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
            &ENDIF
            CASE wh-child:TYPE:
                WHEN "RADIO-SET":U THEN 
                    RUN pi-trad-radio-set (INPUT wh-child).
                WHEN "FILL-IN":U THEN
                    RUN pi-trad-fill-in (INPUT wh-child).
                WHEN "TOGGLE-BOX":U THEN
                    RUN pi-trad-toggle-box (INPUT wh-child).
                WHEN "COMBO-BOX":U THEN
                    RUN pi-trad-combo-box (INPUT wh-child).
                WHEN "BUTTON":U THEN
                    RUN pi-trad-button (INPUT wh-child).
                WHEN "EDITOR":U THEN
                    RUN pi-trad-editor (INPUT wh-child).
            END CASE.
            ASSIGN wh-child = wh-child:NEXT-SIBLING.
        END.
        ASSIGN wh-group = wh-group:NEXT-SIBLING.
    END. 
END.     
/********************************************************** 
** Tradu‡Æo p gina sele‡Æo - frame f-pg-sel
**********************************************************/
&if "{&PGSEL}" <> "" &then
    RUN utp/ut-liter.p (INPUT "Sele‡Æo",
                        INPUT "*",
                        INPUT "R").
    CREATE TEXT wh-label-sel
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(09)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 8
               ROW          = 1.8
               COL          = im-pg-sel:col IN FRAME f-relat + 1.86
               VISIBLE      = YES
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
               BGCOLOR      = 18
         &ENDIF
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click":U TO im-pg-sel IN FRAME f-relat.           
         END TRIGGERS.                   
     DO  WITH FRAME f-pg-sel:
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
             RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-pg-sel:handle ).
         &ENDIF
         ASSIGN wh-group = FRAME f-pg-sel:handle
                wh-group = wh-group:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-group):
             ASSIGN wh-child = wh-group:FIRST-CHILD.
             DO  WHILE VALID-HANDLE(wh-child):
                 &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                     /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                     RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
                 &ENDIF
                 CASE wh-child:TYPE:
                    WHEN "RADIO-SET":U THEN 
                        RUN pi-trad-radio-set (INPUT wh-child).
                    WHEN "FILL-IN":U THEN
                        RUN pi-trad-fill-in (INPUT wh-child).
                    WHEN "TOGGLE-BOX":U THEN
                        RUN pi-trad-toggle-box (INPUT wh-child).
                    WHEN "COMBO-BOX":U THEN
                        RUN pi-trad-combo-box (INPUT wh-child).
                    WHEN "BUTTON":U THEN
                        RUN pi-trad-button (INPUT wh-child).
                    WHEN "TEXT":U THEN
                        RUN pi-trad-text (INPUT wh-child).
                    WHEN "EDITOR":U THEN
                        RUN pi-trad-editor (INPUT wh-child).
                 END CASE.
                 ASSIGN wh-child = wh-child:NEXT-SIBLING.
             END.
             ASSIGN wh-group = wh-group:NEXT-SIBLING.
         END. 
     
     END.     
         
&endif
/********************************************************** 
** Tradu‡Æo p gina classifica‡Æo - frame f-pg-cla
**********************************************************/
&if "{&PGCLA}" <> "" &then
    RUN utp/ut-liter.p (INPUT "Classifica‡Æo",
                        INPUT "*",
                        INPUT "R").
    CREATE TEXT wh-label-cla
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(13)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 13
               ROW          = 1.8
               COL          = im-pg-cla:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
               BGCOLOR      = 18
         &ENDIF
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click":U TO im-pg-cla IN FRAME f-relat.           
         END TRIGGERS.       
     DO  WITH FRAME f-pg-cla:
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
             RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-pg-cla:handle ).
         &ENDIF
         ASSIGN wh-group = FRAME f-pg-cla:handle
                wh-group = wh-group:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-group):
             ASSIGN wh-child = wh-group:FIRST-CHILD.
             DO  WHILE VALID-HANDLE(wh-child):
                 &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                     /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                     RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
                 &ENDIF
                 CASE wh-child:TYPE:
                    WHEN "RADIO-SET":U THEN 
                        RUN pi-trad-radio-set (INPUT wh-child).
                    WHEN "FILL-IN":U THEN
                        RUN pi-trad-fill-in (INPUT wh-child).
                    WHEN "TOGGLE-BOX":U THEN
                        RUN pi-trad-toggle-box (INPUT wh-child).
                    WHEN "COMBO-BOX":U THEN
                        RUN pi-trad-combo-box (INPUT wh-child).
                    WHEN "BUTTON":U THEN
                        RUN pi-trad-button (INPUT wh-child).
                    WHEN "TEXT":U THEN
                        RUN pi-trad-text (INPUT wh-child).
                    WHEN "EDITOR":U THEN
                        RUN pi-trad-editor (INPUT wh-child).
                 END CASE.
                 ASSIGN wh-child = wh-child:NEXT-SIBLING.
             END.
             ASSIGN wh-group = wh-group:NEXT-SIBLING.
         END. 
     
     END.     
&endif
/********************************************************** 
** Tradu‡Æo p gina parƒmetros - frame f-pg-par
**********************************************************/
&if "{&PGPAR}" <> "" &then
    RUN utp/ut-liter.p (INPUT "Parƒmetros",
                        INPUT "*",
                        INPUT "R").
    CREATE TEXT wh-label-par
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(10)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 11
               ROW          = 1.8
               COL          = im-pg-par:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
               BGCOLOR      = 18
         &ENDIF
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click":U TO im-pg-par IN FRAME f-relat.           
         END TRIGGERS.                              
     DO  WITH FRAME f-pg-par:
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
             RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-pg-par:handle ).
         &ENDIF
         ASSIGN wh-group = FRAME f-pg-par:handle
                wh-group = wh-group:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-group):
             ASSIGN wh-child = wh-group:FIRST-CHILD.
             DO  WHILE VALID-HANDLE(wh-child):
                 &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                      /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                      RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
                 &ENDIF
                 CASE wh-child:TYPE:
                    WHEN "RADIO-SET":U THEN 
                        RUN pi-trad-radio-set (INPUT wh-child).
                    WHEN "FILL-IN":U THEN
                        RUN pi-trad-fill-in (INPUT wh-child).
                    WHEN "TOGGLE-BOX":U THEN
                        RUN pi-trad-toggle-box (INPUT wh-child).
                    WHEN "COMBO-BOX":U THEN
                        RUN pi-trad-combo-box (INPUT wh-child).
                    WHEN "BUTTON":U THEN
                        RUN pi-trad-button (INPUT wh-child).
                    WHEN "TEXT":U THEN
                        RUN pi-trad-text (INPUT wh-child).
                    WHEN "EDITOR":U THEN
                        RUN pi-trad-editor (INPUT wh-child).
                 END CASE.
                 ASSIGN wh-child = wh-child:NEXT-SIBLING.
             END.
             ASSIGN wh-group = wh-group:NEXT-SIBLING.
         END. 
     
     END.     
&endif
/********************************************************** 
** Tradu‡Æo p gina digita‡Æo - frame f-pg-dig
**********************************************************/
&if "{&PGDIG}" <> "" &then
    RUN utp/ut-liter.p (INPUT "Digita‡Æo",
                        INPUT "*",
                        INPUT "R").
    CREATE TEXT wh-label-dig
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(09)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 10
               ROW          = 1.8
               COL          = im-pg-dig:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
               BGCOLOR      = 18
         &ENDIF
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-dig IN FRAME f-relat.           
         END TRIGGERS.
     
     DO WITH FRAME f-pg-dig:
         ASSIGN FRAME f-pg-dig:FONT = 2
                wh-group            = FRAME f-pg-dig:handle
                wh-group            = wh-group:FIRST-CHILD.
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
              /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
              RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-pg-dig:handle ).
         &ENDIF
         
         DO WHILE VALID-HANDLE(wh-group):
             ASSIGN wh-child = wh-group:FIRST-CHILD.
             DO WHILE VALID-HANDLE(wh-child):
                 &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                     /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                     RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
                 &ENDIF
                 CASE wh-child:TYPE:
                    WHEN "RADIO-SET":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-radio-set (INPUT wh-child).
                    END.
                    WHEN "FILL-IN":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-fill-in (INPUT wh-child).
                    END.
                    WHEN "TOGGLE-BOX":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-toggle-box (INPUT wh-child).
                    END.
                    WHEN "COMBO-BOX":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-combo-box (INPUT wh-child).
                    END.
                    WHEN "BUTTON":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-button (INPUT wh-child).
                    END.
                    WHEN "TEXT":U THEN DO:
                        ASSIGN wh-child:FONT = 1.
                        RUN pi-trad-text (INPUT wh-child).
                    END.
                    WHEN "BROWSE":U THEN
                        RUN pi-trad-browse (INPUT wh-child).
                    WHEN "EDITOR":U THEN
                        RUN pi-trad-editor (INPUT wh-child).
                 END CASE.
                 
                 ASSIGN wh-child = wh-child:NEXT-SIBLING.
             END.
             
             ASSIGN wh-group = wh-group:NEXT-SIBLING.
         END. 
     
     END.     
&endif
/********************************************************** 
** Tradu‡Æo p gina impressÆo - frame f-pg-imp
**********************************************************/
&if "{&PGIMP}" <> "" &then
    RUN utp/ut-liter.p (INPUT "ImpressÆo",
                        INPUT "*",
                        INPUT "R").
    CREATE TEXT wh-label-imp
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(09)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 10
               ROW          = 1.8
               COL          = im-pg-imp:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
               /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
               BGCOLOR      = 18
         &ENDIF
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click":U TO im-pg-imp IN FRAME f-relat.           
         END TRIGGERS.                   
     DO  WITH FRAME f-pg-imp:
         &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                RUN pi_aplica_facelift_smart IN h-facelift ( INPUT FRAME f-pg-imp:handle ).
         &ENDIF
         ASSIGN wh-group = FRAME f-pg-imp:handle
                wh-group = wh-group:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-group):
             ASSIGN wh-child = wh-group:FIRST-CHILD.
             DO  WHILE VALID-HANDLE(wh-child):
                 &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
                      /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
                      RUN pi_aplica_facelift_smart IN h-facelift ( INPUT wh-child ).
                 &ENDIF
                 CASE wh-child:TYPE:
                    WHEN "RADIO-SET":U THEN 
                        RUN pi-trad-radio-set (INPUT wh-child).
                    WHEN "FILL-IN":U THEN
                        RUN pi-trad-fill-in (INPUT wh-child).
                    WHEN "TOGGLE-BOX":U THEN
                        RUN pi-trad-toggle-box (INPUT wh-child).
                    WHEN "COMBO-BOX":U THEN
                        RUN pi-trad-combo-box (INPUT wh-child).
                    WHEN "BUTTON":U THEN
                        RUN pi-trad-button (INPUT wh-child).
                    WHEN "TEXT":U THEN
                        RUN pi-trad-text (INPUT wh-child).
                    WHEN "EDITOR":U THEN
                        RUN pi-trad-editor (INPUT wh-child).
                 END CASE.
                 ASSIGN wh-child = wh-child:NEXT-SIBLING.
             END.
             ASSIGN wh-group = wh-group:NEXT-SIBLING.
         END. 
     
     END.     
         
&endif
/********************************************************** 
** Troca de pÿgina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/

&IF "{&PGSEL}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-sel,":U.
&ENDIF
&IF "{&PGCLA}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-cla,":U.
&ENDIF
&IF "{&PGPAR}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-par,":U.
&ENDIF
&IF "{&PGDIG}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-dig,":U.
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    ASSIGN c-list-folders = c-list-folders + "im-pg-imp":U.
&ENDIF
IF  SUBSTRING(c-list-folders,LENGTH(c-list-folders)) = "," THEN 
    ASSIGN c-list-folders = SUBSTRING(c-list-folders,1,LENGTH(c-list-folders) - 1 ).
ON  CTRL-TAB,SHIFT-CTRL-TAB OF {&WINDOW-NAME} ANYWHERE DO:
    DEFINE VARIABLE h_handle  AS HANDLE NO-UNDO.       
    DEFINE VARIABLE c_imagem  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_direita AS LOGICAL NO-UNDO.            
    l_direita = LAST-EVENT:LABEL = 'CTRL-TAB':U.
        
    block1:
    REPEAT:        
        IF  l_direita THEN DO:
            IF  i-current-folder = num-entries(c-list-folders) THEN
                i-current-folder = 1.
            ELSE
                i-current-folder = i-current-folder + 1.
        END.
        ELSE DO:
            IF  i-current-folder = 1 THEN
                i-current-folder = NUM-ENTRIES(c-list-folders).
            ELSE
                i-current-folder = i-current-folder - 1.
        END.
    
        ASSIGN c_imagem = ENTRY(i-current-folder,c-list-folders)
               h_handle = FRAME f-relat:first-child
               h_handle = h_handle:first-child.
        DO  WHILE VALID-HANDLE(h_handle):
            IF  h_handle:type = 'image':U AND
                h_handle:name =  c_imagem THEN DO:
                IF  h_handle:sensitive = NO THEN 
                    NEXT block1.
                APPLY 'mouse-select-click':U TO h_handle.
                LEAVE block1.
            END.
            h_handle = h_handle:next-sibling.
        END.
    END.
END.
/********************************************************** 
** Procedure de troca de pÿgina por CTRL-TAB 
**********************************************************/
PROCEDURE pi-first-child:
        
    DEFINE INPUT PARAMETER wh-entry-folder AS WIDGET-HANDLE.
    
    &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
    /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
    IF wh-entry-folder:NAME = "f-pg-sel" THEN DO:
        &if "{&PGSEL}" <> "" &then
        ASSIGN wh-label-sel:BGCOLOR = 17.
        &endif
        &if "{&PGIMP}" <> "" &then
        ASSIGN wh-label-imp:BGCOLOR = 18.
        &endif
        &if "{&PGCLA}" <> "" &then
        ASSIGN wh-label-cla:BGCOLOR = 18.
        &endif
        &if "{&PGPAR}" <> "" &then
        ASSIGN wh-label-par:BGCOLOR = 18.
        &endif
        &if "{&PGDIG}" <> "" &then
        ASSIGN wh-label-dig:BGCOLOR = 18.
        &endif
    END.
    ELSE IF wh-entry-folder:NAME = "f-pg-imp" THEN DO:
        &if "{&PGSEL}" <> "" &then
        ASSIGN wh-label-sel:BGCOLOR = 18.
        &endif
        &if "{&PGIMP}" <> "" &then
        ASSIGN wh-label-imp:BGCOLOR = 17.
        &endif
        &if "{&PGCLA}" <> "" &then
        ASSIGN wh-label-cla:BGCOLOR = 18.
        &endif
        &if "{&PGPAR}" <> "" &then
        ASSIGN wh-label-par:BGCOLOR = 18.
        &endif
        &if "{&PGDIG}" <> "" &then
        ASSIGN wh-label-dig:BGCOLOR = 18.
        &endif
    END.
    ELSE IF wh-entry-folder:NAME = "f-pg-cla" THEN DO:
        &if "{&PGSEL}" <> "" &then
        ASSIGN wh-label-sel:BGCOLOR = 18.
        &endif
        &if "{&PGIMP}" <> "" &then
        ASSIGN wh-label-imp:BGCOLOR = 18.
        &endif
        &if "{&PGCLA}" <> "" &then
        ASSIGN wh-label-cla:BGCOLOR = 17.
        &endif
        &if "{&PGPAR}" <> "" &then
        ASSIGN wh-label-par:BGCOLOR = 18.
        &endif
        &if "{&PGDIG}" <> "" &then
        ASSIGN wh-label-dig:BGCOLOR = 18.
        &endif
    END.
    ELSE IF wh-entry-folder:NAME = "f-pg-par" THEN DO:
        &if "{&PGSEL}" <> "" &then
        ASSIGN wh-label-sel:BGCOLOR = 18.
        &endif
        &if "{&PGIMP}" <> "" &then
        ASSIGN wh-label-imp:BGCOLOR = 18.
        &endif
        &if "{&PGCLA}" <> "" &then
        ASSIGN wh-label-cla:BGCOLOR = 18.
        &endif
        &if "{&PGPAR}" <> "" &then
        ASSIGN wh-label-par:BGCOLOR = 17.
        &endif
        &if "{&PGDIG}" <> "" &then
        ASSIGN wh-label-dig:BGCOLOR = 18.
        &endif

    END.
    ELSE IF wh-entry-folder:NAME = "f-pg-dig" THEN DO:
        &if "{&PGSEL}" <> "" &then
        ASSIGN wh-label-sel:BGCOLOR = 18.
        &endif
        &if "{&PGIMP}" <> "" &then
        ASSIGN wh-label-imp:BGCOLOR = 18.
        &endif
        &if "{&PGCLA}" <> "" &then
        ASSIGN wh-label-cla:BGCOLOR = 18.
        &endif
        &if "{&PGPAR}" <> "" &then
        ASSIGN wh-label-par:BGCOLOR = 18.
        &endif
        &if "{&PGDIG}" <> "" &then
        ASSIGN wh-label-dig:BGCOLOR = 17.
        &endif
    END.
    &ENDIF

    ASSIGN wh-entry-folder = wh-entry-folder:FIRST-CHILD
           wh-entry-folder = wh-entry-folder:FIRST-CHILD.
    DO  WHILE(VALID-HANDLE(wh-entry-folder)):
        IF  wh-entry-folder:SENSITIVE = YES 
        AND wh-entry-folder:TYPE <> 'rectangle':U 
        AND wh-entry-folder:TYPE <> 'image':U
        AND wh-entry-folder:TYPE <> 'browse':U THEN DO:
            APPLY 'entry':U TO wh-entry-folder.
            LEAVE.
        END.
        ELSE
            ASSIGN wh-entry-folder = wh-entry-folder:NEXT-SIBLING.    
    END.
END.
/********************************************************** 
** Procedures de Traducao 
**********************************************************/
PROCEDURE pi-trad-radio-set:
   
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
  
    ASSIGN c-aux = wh-objeto:RADIO-BUTTONS.
    DO  i-aux = 1 TO NUM-ENTRIES(wh-objeto:RADIO-BUTTONS):
        IF  (i-aux MOD 2) <> 0 THEN DO:
            RUN utp/ut-liter.p (INPUT REPLACE(ENTRY(i-aux, wh-objeto:RADIO-BUTTONS), CHR(32), "_"),
                                INPUT "",
                                INPUT "R"). 
            ASSIGN ENTRY(i-aux, c-aux) = RETURN-VALUE.
        END.
    END.                                              
    ASSIGN wh-objeto:RADIO-BUTTONS = c-aux.
    
    IF  wh-objeto:HELP <> "" 
    AND wh-objeto:HELP <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:HELP = RETURN-VALUE.
    END.  
END.
PROCEDURE pi-trad-fill-in:
   
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
        IF  wh-objeto:LABEL <> ?
        AND wh-objeto:LABEL <> "" THEN DO:
            RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:LABEL, CHR(32), "_"),
                                INPUT "",
                                INPUT "L"). 
            ASSIGN wh-objeto:LABEL = RETURN-VALUE.
        END. 
        IF  wh-objeto:HELP <> "" 
        AND wh-objeto:HELP <> ? THEN DO:
            RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                                INPUT "",
                                INPUT "R"). 
            ASSIGN wh-objeto:HELP = RETURN-VALUE.
        END.         
    
END.
PROCEDURE pi-trad-editor:
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
         /* editor n’o tem label, ent’o traduz apenas o help */
        IF  wh-objeto:HELP <> "" 
        AND wh-objeto:HELP <> ? THEN DO:
            RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                                INPUT "",
                                INPUT "R"). 
            ASSIGN wh-objeto:HELP = RETURN-VALUE.
        END.         
END.
PROCEDURE pi-trad-toggle-box:
   
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
    IF  wh-objeto:LABEL <> ?
    AND wh-objeto:LABEL <> "" THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:LABEL, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:LABEL = RETURN-VALUE.
    END. 
    IF  wh-objeto:HELP <> "" 
    AND wh-objeto:HELP <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:HELP = RETURN-VALUE.
    END.         
    
END.
PROCEDURE pi-trad-combo-box:
                        /* nota: n’o traduz conteœdo */
    
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
    IF  wh-objeto:LABEL <> ?
    AND wh-objeto:LABEL <> "" THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:LABEL, CHR(32), "_"),
                            INPUT "",
                            INPUT "L"). 
        ASSIGN wh-objeto:LABEL = RETURN-VALUE.
    END. 
    IF  wh-objeto:HELP <> "" 
    AND wh-objeto:HELP <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:HELP = RETURN-VALUE.
    END.         
    
END.
PROCEDURE pi-trad-button:
    
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
    IF  wh-objeto:LABEL <> ?
    AND wh-objeto:LABEL <> "" THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:LABEL, CHR(32), "_"),
                            INPUT "",
                            INPUT "C"). 
        ASSIGN wh-objeto:LABEL = RETURN-VALUE.
    END. 
    IF  wh-objeto:HELP <> "" 
    AND wh-objeto:HELP <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:HELP    = RETURN-VALUE
               wh-objeto:TOOLTIP = TRIM(RETURN-VALUE).
    END.         
    
END.
PROCEDURE pi-trad-text:
    
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    
    IF  wh-objeto:SCREEN-VALUE <> ?
    AND wh-objeto:SCREEN-VALUE <> "" THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:SCREEN-VALUE, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:SCREEN-VALUE = RETURN-VALUE.
               wh-objeto:width = LENGTH(RETURN-VALUE).
    END.
    ELSE DO:
        IF  wh-objeto:PRIVATE-DATA <> ?
        AND wh-objeto:PRIVATE-DATA <> "" THEN DO:
            RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:PRIVATE-DATA, CHR(32), "_"),
                                INPUT "",
                                INPUT "R"). 
            ASSIGN wh-objeto:SCREEN-VALUE = " " + RETURN-VALUE.
                   wh-objeto:width = LENGTH(RETURN-VALUE) + 1.
        END.
    
    END.
    
END.
PROCEDURE pi-trad-browse:
    
    DEF INPUT PARAM wh-objeto    AS WIDGET-HANDLE NO-UNDO.
    DEF VAR wh-column            AS WIDGET-HANDLE NO-UNDO.
    IF  wh-objeto:HELP <> "" 
    AND wh-objeto:HELP <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:HELP, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:HELP = RETURN-VALUE.
    END.         
    IF  wh-objeto:TITLE <> "" 
    AND wh-objeto:TITLE <> ? THEN DO:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-objeto:TITLE, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-objeto:TITLE = RETURN-VALUE.
    END.         
    ASSIGN wh-column = wh-objeto:FIRST-COLUMN.
    DO  WHILE wh-column <> ?:
        RUN utp/ut-liter.p (INPUT REPLACE(wh-column:LABEL, CHR(32), "_"),
                            INPUT "",
                            INPUT "R"). 
        ASSIGN wh-column:LABEL = RETURN-VALUE.
        ASSIGN wh-column = wh-column:NEXT-COLUMN.
    END.
END.
/* i-rplbl */
&if "{&PGIMP}" <> "" &then
PROCEDURE pi-impres-pad:
DO WITH FRAME f-pg-imp:
    FIND layout_impres_padr NO-LOCK
         WHERE layout_impres_padr.cod_usuario = c-seg-usuario
            AND layout_impres_padr.cod_proced = c-programa-mg97  USE-INDEX lytmprsp_id  NO-ERROR. /*cl_default_procedure_user of layout_impres_padr*/
    IF  NOT AVAIL layout_impres_padr
    THEN DO:
        FIND layout_impres_padr NO-LOCK
             WHERE layout_impres_padr.cod_usuario = "*"
               AND layout_impres_padr.cod_proced = c-programa-mg97  USE-INDEX lytmprsp_id  NO-ERROR. /*cl_default_procedure of layout_impres_padr*/
        IF  AVAIL layout_impres_padr
        THEN DO:
            FIND imprsor_usuar NO-LOCK
                 WHERE imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                   AND imprsor_usuar.cod_usuario = string(c-seg-usuario)
                 USE-INDEX imprsrsr_id  NO-ERROR. /*cl_layout_current_user of imprsor_usuar*/
        END . /* if */
        IF  NOT AVAIL imprsor_usuar
            OR NOT AVAIL layout_impres_padr /* Por Thiago Garcia ref. FO 901.132 */
        THEN DO:
            FIND layout_impres_padr NO-LOCK
                 WHERE layout_impres_padr.cod_usuario = c-seg-usuario
                   AND layout_impres_padr.cod_proced = "*"
                 USE-INDEX lytmprsp_id  NO-ERROR. /*cl_default_user of layout_impres_padr*/
        END . /* if */
    END . /* if */
    IF  AVAIL layout_impres_padr
    THEN DO:
        ASSIGN c-arquivo:screen-value IN FRAME f-pg-imp = layout_impres_padr.nom_impressora
                                    + ":"
                                    + layout_impres_padr.cod_layout_impres.
    END . /* if */
    ELSE DO:
         c-arquivo:screen-value IN FRAME f-pg-imp = "".
    END . /* else */
END . /* do dflt */
END.
/*pi-impres-pad */
/*Alterado 16/02/2005 - tech1007 - Procedure criada para controlar os widgets da
  funcionalidade de RTF*/
&IF "{&RTF}":U = "YES":U &THEN
PROCEDURE pi-habilitaRtf:
    /*Procedure criada para controlar quando o RTF foi ativado*/
    IF l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp <> "No" THEN DO:
        ASSIGN c-modelo-rtf:sensitive  = YES
               bt-modelo-rtf:SENSITIVE  = YES.
        /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
        IF c-modelo-default <> "" THEN DO:
            IF  c-modelo-rtf = "" THEN DO:
                ASSIGN c-modelo-rtf = c-modelo-default
                       c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp = c-modelo-default.
            END.
        END.
        /* Alterado em 31/05/2005 - tech1139 - Altera‡äes FO 1152.814*/
    END.
    ELSE DO:
        ASSIGN c-modelo-rtf:sensitive  = NO
               c-modelo-rtf:SCREEN-VALUE IN FRAME f-pg-imp = ""
               c-modelo-rtf = ""
               bt-modelo-rtf:SENSITIVE  = NO.
    END.
END.
&ENDIF
/*Fim alteracao 16/02/2005*/
&endif
/* define procedure externa para execucao do programa de visualizacao do relatorio */

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

