/*****************************************************************************
**     Programa.........: i-rpsvpr504
**     Descricao .......: Armazena os campo na tela para execu‡Æo do RP
**     Versao...........: 01.001
**     Nome Externo.....: include/i-rpsvpr504.i
**     Autor............: Ivan Silveira
**     Criado...........: 22/10/2002
*******************************************************************************/
        
    DEF VAR wh-param    AS HANDLE   NO-UNDO.
    DEF VAR wh-param1   AS HANDLE   NO-UNDO.

    ASSIGN  c-param-campos  = ''
            c-param-tipos   = ''
            c-param-dados   = ''.

    &IF '{&PGSEL}' <> '' &THEN
        ASSIGN  wh-param = FRAME {&PGSEL}:HANDLE
                wh-param = wh-param:FIRST-CHILD
                wh-param = wh-param:FIRST-CHILD.
  
        DO  WHILE VALID-HANDLE(wh-param) :
            IF  INDEX('fill-in,toggle-box,radio-set,editor,combo-box',wh-param:TYPE) > 0 THEN DO:
                ASSIGN  c-param-campos  = c-param-campos + wh-param:NAME          + CHR(10)
                        c-param-tipos   = c-param-tipos  + wh-param:DATA-TYPE     + CHR(10)
                        c-param-dados   = c-param-dados  + wh-param:SCREEN-VALUE  + CHR(10).
                IF  wh-param:TYPE = 'RADIO-SET' THEN
                    ASSIGN  c-param-campos  = c-param-campos + 'c-des-' + wh-param:NAME          + CHR(10)
                            c-param-tipos   = c-param-tipos  + 'CHARACTER' + CHR(10)
                            c-param-dados   = c-param-dados  + ENTRY( (LOOKUP(wh-param:SCREEN-VALUE, wh-param:RADIO-BUTTONS) - 1) , wh-param:RADIO-BUTTONS) + CHR(10).
            END.
            ASSIGN  wh-param = wh-param:NEXT-SIBLING.
        END.
    &ENDIF
    
        
    &IF '{&PGCLA}' <> '' &THEN
        ASSIGN  wh-param = FRAME {&PGCLA}:HANDLE
                wh-param = wh-param:FIRST-CHILD
                wh-param = wh-param:FIRST-CHILD.
  
        DO  WHILE VALID-HANDLE(wh-param) :
            IF  INDEX('fill-in,toggle-box,radio-set,editor,combo-box',wh-param:TYPE) > 0 THEN DO:
                ASSIGN  c-param-campos  = c-param-campos + wh-param:NAME          + CHR(10)
                        c-param-tipos   = c-param-tipos  + wh-param:DATA-TYPE     + CHR(10)
                        c-param-dados   = c-param-dados  + wh-param:SCREEN-VALUE  + CHR(10).
                IF  wh-param:TYPE = 'RADIO-SET' THEN
                    ASSIGN  c-param-campos  = c-param-campos + 'c-des-' + wh-param:NAME          + CHR(10)
                            c-param-tipos   = c-param-tipos  + 'CHARACTER' + CHR(10)
                            c-param-dados   = c-param-dados  + ENTRY( (LOOKUP(wh-param:SCREEN-VALUE, wh-param:RADIO-BUTTONS) - 1) , wh-param:RADIO-BUTTONS) + CHR(10).
            END.
            ASSIGN  wh-param = wh-param:NEXT-SIBLING.
        END.
    &ENDIF

    &IF '{&PGPAR}' <> '' &THEN
        ASSIGN  wh-param = FRAME {&PGPAR}:HANDLE
                wh-param = wh-param:FIRST-CHILD
                wh-param = wh-param:FIRST-CHILD.
  
        DO  WHILE VALID-HANDLE(wh-param) :
            IF  INDEX('fill-in,toggle-box,radio-set,editor,combo-box',wh-param:TYPE) > 0 THEN DO:
                ASSIGN  c-param-campos  = c-param-campos + wh-param:NAME          + CHR(10)
                        c-param-tipos   = c-param-tipos  + wh-param:DATA-TYPE     + CHR(10)
                        c-param-dados   = c-param-dados  + wh-param:SCREEN-VALUE  + CHR(10).
                IF  wh-param:TYPE = 'RADIO-SET' THEN
                    ASSIGN  c-param-campos  = c-param-campos + 'c-des-' + wh-param:NAME          + CHR(10)
                            c-param-tipos   = c-param-tipos  + 'CHARACTER' + CHR(10)
                            c-param-dados   = c-param-dados  + ENTRY( (LOOKUP(wh-param:SCREEN-VALUE, wh-param:RADIO-BUTTONS) - 1) , wh-param:RADIO-BUTTONS) + CHR(10).
            END.
            ASSIGN  wh-param = wh-param:NEXT-SIBLING.
        END.
    &ENDIF

    &IF '{&PGDIG}' <> '' &THEN
        ASSIGN  wh-param = FRAME {&PGDIG}:HANDLE
                wh-param = wh-param:FIRST-CHILD
                wh-param = wh-param:FIRST-CHILD.
  
        DO  WHILE VALID-HANDLE(wh-param) :
            IF  INDEX('fill-in,toggle-box,radio-set,editor,combo-box',wh-param:TYPE) > 0 THEN DO:
                ASSIGN  c-param-campos  = c-param-campos + wh-param:NAME          + CHR(10)
                        c-param-tipos   = c-param-tipos  + wh-param:DATA-TYPE     + CHR(10)
                        c-param-dados   = c-param-dados  + wh-param:SCREEN-VALUE  + CHR(10).
                IF  wh-param:TYPE = 'RADIO-SET' THEN
                    ASSIGN  c-param-campos  = c-param-campos + 'c-des-' + wh-param:NAME          + CHR(10)
                            c-param-tipos   = c-param-tipos  + 'CHARACTER' + CHR(10)
                            c-param-dados   = c-param-dados  + ENTRY( (LOOKUP(wh-param:SCREEN-VALUE, wh-param:RADIO-BUTTONS) - 1) , wh-param:RADIO-BUTTONS) + CHR(10).
            END.
            ASSIGN  wh-param = wh-param:NEXT-SIBLING.
        END.
    &ENDIF
    

