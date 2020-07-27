/*****************************************************************************
**     Programa.........: i-rprcpr504
**     Descricao .......: Recupera os campo da tela da £ltima execu‡Æo
**     Versao...........: 01.001
**     Nome Externo.....: include/i-rprcpr504.i
**     Autor............: Ivan Silveira
**     Criado...........: 22/10/2002
*******************************************************************************/
    
    DEF VAR wh-param        AS HANDLE       NO-UNDO.
    DEF VAR wh-param1       AS HANDLE       NO-UNDO.
    DEF VAR i-cont-param    AS INTEGER      NO-UNDO.

    ASSIGN  c-param-campos  = ENTRY(1,dwb_set_list_param.cod_dwb_parameters, CHR(13))
            c-param-tipos   = ENTRY(2,dwb_set_list_param.cod_dwb_parameters, CHR(13))
            c-param-dados   = ENTRY(3,dwb_set_list_param.cod_dwb_parameters, CHR(13)).

    &IF '{&PGSEL}' <> '' &THEN
        ASSIGN  wh-param = FRAME {&PGSEL}:HANDLE
                wh-param = wh-param:FIRST-CHILD
                wh-param = wh-param:FIRST-CHILD.
  
        DO  WHILE VALID-HANDLE(wh-param) :
            IF  INDEX('fill-in,toggle-box,radio-set,editor,combo-box',wh-param:TYPE) > 0 THEN DO:

                ASSIGN  i-cont-param = LOOKUP(wh-param:NAME, c-param-campos, CHR(10)).
                IF  i-cont-param > 0 THEN 
                    ASSIGN  wh-param:SCREEN-VALUE = ENTRY(i-cont-param, c-param-dados,CHR(10)).
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

                ASSIGN  i-cont-param = LOOKUP(wh-param:NAME, c-param-campos, CHR(10)).
                IF  i-cont-param > 0 THEN 
                    ASSIGN  wh-param:SCREEN-VALUE = ENTRY(i-cont-param, c-param-dados,CHR(10)).
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

                ASSIGN  i-cont-param = LOOKUP(wh-param:NAME, c-param-campos, CHR(10)).
                IF  i-cont-param > 0 THEN 
                    ASSIGN  wh-param:SCREEN-VALUE = ENTRY(i-cont-param, c-param-dados,CHR(10)).
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

                ASSIGN  i-cont-param = LOOKUP(wh-param:NAME, c-param-campos, CHR(10)).
                IF  i-cont-param > 0 THEN 
                    ASSIGN  wh-param:SCREEN-VALUE = ENTRY(i-cont-param, c-param-dados,CHR(10)).
            END.
            ASSIGN  wh-param = wh-param:NEXT-SIBLING.
        END.
    &ENDIF


