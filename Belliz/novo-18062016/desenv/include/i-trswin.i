/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : include/i-trswin.i
**
** Data : 29/12/97
**
** Criaá∆o : John Cleber Jaraceski
**
** Objetivo : Realizar alteracoes em todos os programas que possuam interface 
**            com o usuario (window/dialog). 
**            Estas alteracoes sao :
**              - Centralizar Window
**              - Desabilitar MAX - RESIZE
**              - Ocultar MAX - MIN
**              - Tornar uma Window Modal
**
** Ultima Alt : 29/12/1997
*******************************************************************************/

/* Transformacao Window *****************************************************/
&IF DEFINED(TransformacaoWindow) &THEN

    /*
     * Alteraá∆o 010007
     * De acordo com o KBase Progress P96679 na vers∆o 10 as dll n∆o entendem (?)
     * e devem receber (0).
     */
    DEFINE VARIABLE i-hwnd AS INTEGER     NO-UNDO.
    
    ASSIGN i-hwnd = {&WINDOW-NAME}:HWND.
    
    IF i-hwnd EQ ? AND PROVERSION GE "10" THEN
        ASSIGN i-hwnd = 0.
        
        
	&IF "{&WINDOW-NAME}":U = "w-pesquisa":U &THEN 
		ASSIGN i-template = 13. 
	&ENDIF	

    /*
     * Fim da alteraá∆o 010007,
     * No restante do programa onde se usava {&WINDOW-NAME}:HWND
     * passou-se a usar i-hwnd.
     */

    case i-template:
        when 2 then do: /* Cadastro Simples */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.

            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 3 then do: /* Cadastro Simples - Alteracao */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 4 then do: /* Cadastro Complexo */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 5 then do: /* Cadastro Complexo - Alteracao */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 6 then do: /* Cadastro Simples - Inclusao */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 7 then do: /* Cadastro PaiXFilho - Atualiza Filho */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 8 then do: /* Cadastro PaiXFilho - Atualiza Ambos */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
            
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 9 then do: /* Inclui/Modifica Pai */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /* TECH14187 - FO 1466145 - Programas incorretos s∆o convertidos para MODAL */
            /*** Tornar Window Modal ***/
            &IF int(entry(1,proversion,".")) >= 9 &THEN
                assign h-pai = source-procedure
                       h-pai = h-pai:current-window
                       .
            &else
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING
                       .
            &ENDIF
            /*Alteraá∆o - 31/05/2007 - tech1007 - FO1466145 - Modificaá∆o para que n∆o ocorram erros ao executar os programas de ZOOM
            ê importante documentar que foi encontrado um BUG e em alguns casos a funá∆o SOURSE-PROCEDURE retorna o programa errado.
            Esse BUG foi solucionado no Porgress 10.1A*/
            IF NOT VALID-HANDLE(h-pai) THEN DO:
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING  
                    .
            END.
            IF VALID-HANDLE(h-pai) THEN DO:
                assign h-pai:sensitive = no.
            END.
            /*Fim alteraá∆o 31/05/2007*/
            /* TECH14187 - FO1466145 - FIM ALTERAÄ«O */
            
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 10 then do: /* Inclui/Modifica Filho */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /* TECH14187 - FO 1466145 - Programas incorretos s∆o convertidos para MODAL */
            /*** Tornar Window Modal ***/
            &IF int(entry(1,proversion,".")) >= 9 &THEN
                assign h-pai = source-procedure
                       h-pai = h-pai:current-window
                       .
            &else
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING
                       .
            &ENDIF
            /*Alteraá∆o - 31/05/2007 - tech1007 - FO1466145 - Modificaá∆o para que n∆o ocorram erros ao executar os programas de ZOOM
            ê importante documentar que foi encontrado um BUG e em alguns casos a funá∆o SOURSE-PROCEDURE retorna o programa errado.
            Esse BUG foi solucionado no Porgress 10.1A*/
            IF NOT VALID-HANDLE(h-pai) THEN DO:
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING  
                    .
            END.
            IF VALID-HANDLE(h-pai) THEN DO:
                assign h-pai:sensitive = no.
            END.
            /*Fim alteraá∆o 31/05/2007*/
            /* TECH14187 - FO1466145 - FIM ALTERAÄ«O */
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 11 then do: /* Formacao */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 12 then do: /* Parametros Unicos */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 13 then do: /* Pesquisa */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /* TECH14187 - FO 1466145 - Programas incorretos s∆o convertidos para MODAL */
            /*** Tornar Window Modal ***/
            &IF int(entry(1,proversion,".")) >= 9 &THEN
                assign h-pai = source-procedure
                       h-pai = h-pai:current-window
                       .
            &else
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING
                       .
            &ENDIF
            /*Alteraá∆o - 31/05/2007 - tech1007 - FO1466145 - Modificaá∆o para que n∆o ocorram erros ao executar os programas de ZOOM
            ê importante documentar que foi encontrado um BUG e em alguns casos a funá∆o SOURSE-PROCEDURE retorna o programa errado.
            Esse BUG foi solucionado no Porgress 10.1A*/
            IF NOT VALID-HANDLE(h-pai) THEN DO:
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING  
                    .
            END.
            IF VALID-HANDLE(h-pai) THEN DO:
                assign h-pai:sensitive = no.
            END.
            /*Fim alteraá∆o 31/05/2007*/
            /* TECH14187 - FO1466145 - FIM ALTERAÄ«O */
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 14 then do: /* Consulta Simples */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 15 then do: /* Consulta Complexa */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 16 then do: /* Consulta Relacionamento */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 17 then do: /* Relatorio */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 20 then do: /* Janela Detalhe */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /*** Tornar Window Modal ***/
            assign h-pai           = SESSION:FIRST-CHILD.

            if  h-pai:handle = {&window-name}:handle then
                assign h-pai           = h-pai:NEXT-SIBLING
                       h-pai:SENSITIVE = no.
            else 
                assign  h-pai = {&window-name}:handle
                        h-pai = h-pai:parent.

            h-pai:sensitive = no.
  
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 21 then do: /* Janela Mestre */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.        
        end.
        when 26 then do: /* Importacao/Exportacao */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 29 then do: /* Relatorio Gerado Pelo DataViewer */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 30 then do: /* Formacao Sem Navegacao */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /* TECH14187 - FO 1466145 - Programas incorretos s∆o convertidos para MODAL */
            /*** Tornar Window Modal ***/
            &IF int(entry(1,proversion,".")) >= 9 &THEN
                assign h-pai = source-procedure
                       h-pai = h-pai:current-window
                       .
            &else
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING
                       .
            &ENDIF
            /*Alteraá∆o - 31/05/2007 - tech1007 - FO1466145 - Modificaá∆o para que n∆o ocorram erros ao executar os programas de ZOOM
            ê importante documentar que foi encontrado um BUG e em alguns casos a funá∆o SOURSE-PROCEDURE retorna o programa errado.
            Esse BUG foi solucionado no Porgress 10.1A*/
            IF NOT VALID-HANDLE(h-pai) THEN DO:
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING  
                    .
            END.
            IF VALID-HANDLE(h-pai) THEN DO:
                assign h-pai:sensitive = no.
            END.
            /*Fim alteraá∆o 31/05/2007*/
            /* TECH14187 - FO1466145 - FIM ALTERAÄ«O */
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 31 then do: /* Estrutura */
            /*** Ocultar MAX - MIN ***/
            run utp/ut-style.p persistent set h-prog.
            run DeleteMinMaxButtons in h-prog(input i-hwnd).
            delete procedure h-prog.
    
            /* TECH14187 - FO 1466145 - Programas incorretos s∆o convertidos para MODAL */
            /*** Tornar Window Modal ***/
            &IF int(entry(1,proversion,".")) >= 9 &THEN
                assign h-pai = source-procedure
                       h-pai = h-pai:current-window
                       .
            &else
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING
                       .
            &ENDIF
            /*Alteraá∆o - 31/05/2007 - tech1007 - FO1466145 - Modificaá∆o para que n∆o ocorram erros ao executar os programas de ZOOM
            ê importante documentar que foi encontrado um BUG e em alguns casos a funá∆o SOURSE-PROCEDURE retorna o programa errado.
            Esse BUG foi solucionado no Porgress 10.1A*/
            IF NOT VALID-HANDLE(h-pai) THEN DO:
                assign h-pai           = SESSION:FIRST-CHILD
                       h-pai           = h-pai:NEXT-SIBLING  
                    .
            END.
            IF VALID-HANDLE(h-pai) THEN DO:
                assign h-pai:sensitive = no.
            END.
            /*Fim alteraá∆o 31/05/2007*/
            /* TECH14187 - FO1466145 - FIM ALTERAÄ«O */
    
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
        when 32 then do: /* Digitaá∆o Rapida */
            /*** Desabilitar MAX - RESIZE ***/
            run utp/ut-style.p persistent set h-prog.
            run DisableMaxButton in h-prog(input i-hwnd).
            delete procedure h-prog.
            
            assign {&WINDOW-NAME}:HIDDEN = yes
            {&WINDOW-NAME}:HIDDEN = no.
            apply "ENTRY":U to {&WINDOW-NAME}.
        end.
    end case.
&ENDIF
/* Transformacao Window *****************************************************/

