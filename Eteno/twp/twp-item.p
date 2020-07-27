/*****************************************************************************************************
** Programa  : twp-item.p
******************************************************************************************************/
/******************************************************************************
*******************************************************************************/
{include/itbuni.i}

DEFINE PARAMETER BUFFER p-table     FOR ITEM.
DEFINE PARAMETER BUFFER p-old-table FOR ITEM.

{utp/ut-glob.i}


DEFINE VARIABLE lPrograma    AS LOGICAL NO-UNDO.
DEFINE VARIABLE iProg        AS INTEGER NO-UNDO.
DEFINE VARIABLE c-usuario    AS CHAR    NO-UNDO.
DEFINE VARIABLE cCabecEmail  AS CHAR    NO-UNDO.
DEFINE VARIABLE cCorpoEmail  AS CHAR    NO-UNDO.
DEFINE VARIABLE cRodapeEmail AS CHAR    NO-UNDO.

DEFINE VARIABLE i-data-alt   AS DATETIME  NO-UNDO.
DEFINE VARIABLE c-alteracao  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-diferenca  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-diferenca1 AS CHARACTER NO-UNDO.

DEFINE VARIABLE jj           AS INT       NO-UNDO.

DEF VAR h-diretorio    AS   HANDLE     NO-UNDO.
{utp/utapi019.i}

DEFINE TEMP-TABLE tt-item-un-venda
    FIELD it-codigo   LIKE item-unid-venda.it-codigo
    FIELD un          LIKE item-unid-venda.un
    FIELD fator       AS   DECIMAL
    INDEX id-fator IS UNIQUE fator un it-codigo.

/* Objetos para com o Banco BackEnd */
DEFINE VARIABLE ObjConnection      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ObjCommand         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE ObjRecordSet       AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE c-fonte            AS CHARACTER NO-UNDO .     
DEFINE VARIABLE c-tipo-trans       AS CHARACTER FORMAT "X(1)" NO-UNDO .   


IF NEW(p-table) THEN DO:

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.

    
    FIND FIRST grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo = p-table.ge-codigo NO-ERROR.
    

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    ASSIGN c-usuario = IF AVAIL usuar_mestre THEN (usuar_mestre.cod_usuario + ' - ' + usuar_mestre.nom_usuar) ELSE v_cod_usuar_corren.

    /* */
    ASSIGN cCabecEmail  = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">               
                            <html>
                             <head>
                                 <meta http-equiv="content-type" content="text/html; charset=windows-1250">
                                 <title>Criacao de novo ITEM</title>
                             </head>
                             <body>            
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Prezados,  </br></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Segue abaixo informa‡äes referente a criacao de um novo ITEM. </br></p>
                                 <p></p>'
           cCorpoEmail  = '      <p><font style = "font-family: Verdana; font-size: 11px;">Item: ' + SUBSTRING(p-table.it-codigo,1,6) + ' - ' + p-table.desc-item + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Controle de Estoque ' + ' - ' + {ininc/i09in122.i 04 p-table.tipo-contr} + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Grupo de Estoque: ' + STRING(p-table.ge-codigo) + ' - ' + grup-estoque.descricao + ' </br></p>
                                 <p></p>
                                 <p><font style = "font-family: Verdana; font-size: 11px;">Criacao realizad por: ' + TRIM(c-usuario) + ' </br></p>
                                 <p></p> <p></p>'
           cRodapeEmail = '      <p><font style = "font-family: Verdana; font-size: 11px;">PS: Este email foi enviado automaticamente pelo sistema, por favor, nao responda. </br></p>
                             </body>
                            </html>'.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = cCabecEmail.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 2
           tt-mensagem.mensagem     = cCorpoEmail.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 3
           tt-mensagem.mensagem     = cRodapeEmail.
    /* */

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.remetente         = 'eteno@eteno.com.br'
           tt-envio2.destino           = 'rosangela.santos@eteno.com.br'
           tt-envio2.copia             = 'gedalva.santana@eteno.com.br'
           tt-envio2.assunto           = 'Criacao de um novo Item ' + p-table.it-codigo
           tt-envio2.importancia       = 2
           tt-envio2.log-enviada       = NO
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.formato           = 'HTML'.
           
           

    run utp/ut-utils.p persistent set h-diretorio.
    run setcurrentdir in h-diretorio(input session:temp-directory).

    run utp/utapi019.p persistent set h-utapi019.
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute2 in h-utapi019 (input table tt-envio2,
                                   input table tt-mensagem,
                                   output table tt-erros).
    output close.

    delete procedure h-utapi019.
    delete procedure h-diretorio.
    return 'ok'.

END.
