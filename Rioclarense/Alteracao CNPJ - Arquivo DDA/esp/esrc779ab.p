/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
**
** Programa..............: esrc779za
** Objetivo..............: Alterar CNPJ de CNAB de DDA de filial para Matriz
** Data Geracao..........: 06/25/2019 - 11:22
** Criado por............: Flavio Kussunoki
*****************************************************************************/


DEF INPUT param p-objeto AS WIDGET-HANDLE.
    DEF TEMP-TABLE tt-cnab
        FIELD tt-linha AS CHAR FORMAT "x(240)" .

    DEF BUFFER b-emitente FOR emitente.

    DEF VAR v_cnpj AS CHAR.
    DEF VAR h-prog AS HANDLE.




    /************************* Variable Definition Begin ************************/

    def var v_cod_get_file                   as character       no-undo. /*local*/
    def var v_log_pressed                    as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    system-dialog get-file v_cod_get_file
        title "Procurando..." /*l_procurando...*/ 
        filters '*.txt;*.ret' '*.txt;*.ret'
        must-exist
        update v_log_pressed.

    if  v_log_pressed = yes
    then do:
        assign p-objeto:screen-value = v_cod_get_file.
        apply "entry" to p-objeto.

   RUN utp/ut-acomp.p PERSISTENT SET h-prog.
   RUN pi-inicializar IN h-prog (INPUT "Acertando arquivo....aguarde").
   RUN pi-acerta-cnpj.
   RUN pi-finalizar IN h-prog.


    end /* if */.

PROCEDURE pi-acerta-cnpj:


    INPUT FROM value(v_cod_get_file).


    REPEAT:
        CREATE tt-cnab.
        IMPORT UNFORMATTED tt-cnab.
    END.

    FOR EACH tt-cnab WHERE SUBSTRING(tt-cnab.tt-linha, 14, 1) = "g":


        FIND FIRST emitente WHERE substring(emitente.cgc, 1, 8) = TRIM(SUBSTRING(tt-cnab.tt-linha, 64, 8) ) NO-ERROR.


        IF AVAIL emitente THEN DO:


            FIND FIRST b-emitente WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.
			
			if not avail b-emitente then message "Nao ‚ possivel encontrar fornecedor com o nome abreviado " + emitente.nome-matriz skip
			"para corrigir entre no cadastro do Fornecedor Financeiro, clique em alterar e confirmar para que o sistema corrija o erro"  view-as alert-box.
			
			
             RUN pi-acompanhar IN h-prog (INPUT "CNPJ antigo " + TRIM(SUBSTRING(tt-cnab.tt-linha, 64, 14)) + " CNPJ novo " + b-emitente.cgc).

            ASSIGN SUBSTRING(tt-cnab.tt-linha, 64, 14) = b-emitente.cgc. 



        END.

    END.


    OUTPUT TO value(v_cod_get_file).

    FOR EACH tt-cnab:
        PUT UNFORMATTED  tt-cnab.tt-linha
            SKIP.
    END.

END PROCEDure.
