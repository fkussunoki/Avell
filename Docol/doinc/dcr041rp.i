DEF NEW GLOBAL SHARED TEMP-TABLE tt-complemento
    FIELD cod-mensagem AS INT
    FIELD complemento  AS CHAR.
DEF VAR c-mes AS CHAR EXTENT 12 INITIAL ['Janeiro','Feverieo','Mar‡o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'].
DEF VAR i-periodo   AS INT LABEL 'Periodo' FORMAT '->>'.
DEF VAR c-mensagens AS CHAR.
DEF VAR i-cont-ax AS INT.
/* API Integra‡Æo com word */
{utp/utapi012.i}
DEFINE VARIABLE AppWord                 AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE ch-Word                 As COMPONENT-HANDLE NO-UNDO.
&GLOBAL-DEFINE wdWindowStateMaximize    1 /* 1 - Maximinizada */
DEF VAR c-diret-mod AS CHAR. /*Observar autera‡Æo no Propath*/
DEFINE VARIABLE c-arq-word              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-diret                 AS CHARACTER    NO-UNDO FORMAT 'x(200)':U.
DEFINE VARIABLE i-seq-docum             AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-path-word             AS CHARACTER    NO-UNDO.
DEF VAR c-conteudo AS CHAR.
DEF VAR c-conteudo-ax AS CHAR.
DEF VAR c-conteudo-ax1 AS CHAR.
DEF VAR c-banco AS CHAR.
DEF VAR c-final AS CHAR.
DEF VAR dc-total-tit LIKE tit_acr.val_origin_tit_acr.
DEF VAR c-titulo AS INT FORMAT '>>>>>>>>>>'.
DEF STREAM s-conteudo.
DEFINE TEMP-TABLE tt-arquivos
    FIELD arquivo           AS CHARACTER FORMAT 'x(70)':U
    FIELD seq               AS INTEGER
    INDEX i-arquivo arquivo
    INDEX i-seq seq.

FIND FIRST usuar_mestre NO-LOCK
    WHERE usuar_mestre.cod_usuar = v_cod_usuar_corren NO-ERROR.

ASSIGN c-diret-mod = ENTRY(1,PROPATH) + '\modelos\'
       c-arq-word = c-arquivo
       c-arq-word = REPLACE(c-arq-word,'.tmp','.doc').

FOR EACH tt-digita NO-LOCK USE-INDEX codigo
    BREAK BY  tt-digita.c-portador.

    IF INDEX(c-mensagens,string(tt-digita.cod-mensagem)) = 0 THEN
        ASSIGN c-mensagens = c-mensagens + string(tt-digita.cod-mensagem) + ','.

    FIND FIRST emsfin.portador NO-LOCK USE-INDEX portador_id
         WHERE portador.cod_portador = tt-digita.c-portador NO-ERROR.

    FIND FIRST tit_acr NO-LOCK USE-INDEX titacr_token
        WHERE tit_acr.cod_estab      = tt-digita.cod-estabel 
          AND tit_acr.num_id_tit_acr = tt-digita.num-id-tit-acr NO-ERROR.

    FIND FIRST dc-tit_acr OF tit_acr EXCLUSIVE-LOCK.
    IF AVAIL dc-tit_acr THEN
        ASSIGN dc-tit_acr.vend-dt-sol-descto = dt-transacao.
    
    ASSIGN i-periodo = dt-transacao - tit_acr.dat_vencto_tit_acr.

    FIND FIRST emsuni.cliente NO-LOCK USE-INDEX cliente_id
        WHERE cliente.cod_empresa = c-empresa-ax
          AND cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

    FIND FIRST pessoa_jurid NO-LOCK USE-INDEX pssjrda_id
        WHERE pessoa_jurid.num_pessoa_jurid = portador.num_pessoa_jurid NO-ERROR.

    IF c-contato-fone = "" THEN DO:
       FIND FIRST contato OF pessoa_jurid NO-LOCK
           WHERE contato.nom_abrev_contat = 'Vendor' NO-ERROR.        
       IF AVAIL contato THEN DO:
          ASSIGN c-nome-pessoa = contato.nom_pessoa
                 c-telefone    = contato.cod_telef_contat.
       END.
       ELSE
          ASSIGN c-nome-pessoa = ""
                 c-telefone    = "".
       ASSIGN c-contato-fone = c-nome-pessoa + " - " + c-telefone.
    END.

       
    IF FIRST-OF (tt-digita.c-portador) THEN DO:

        OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "lixo.txt").

        IF AVAIL usuar_mestre THEN
           ASSIGN  c-arq-word = usuar_mestre.nom_dir_spool + '/' + portador.cod_portador + '.doc'.
        ELSE
           ASSIGN c-arq-word = SESSION:TEMP-DIRECTORY + portador.cod_portador + '.doc'.  
        
        RUN pi-configura-word IN THIS-PROCEDURE (c-arq-word, 'modelos/debtovendvenc.dot':U). 

        ASSIGN c-banco = 'JOINVILLE,' + STRING(DAY(TODAY)) + ' ' + c-mes[MONTH(TODAY)] + ' ' + STRING(YEAR(TODAY)) + CHR(13) + 
               CHR(13) +
               'A0'                     + CHR(13) +
               portador.nom_pessoa      + CHR(13) + 
               c-contato-fone         + CHR(13) +
               CHR(13) +
               'REF.: DBITO DE VENDOR' + CHR(13) +   
               CHR(13) + 
               'SOLICITO O DBITO DE VENDOR VENCIDO CONFORME SEGUE:' + CHR(13) + CHR(13) +
               'EMPRESA: ' + empresa.nom_razao_social                + CHR(13) + CHR(13).
                                                                       
    END. /* First-of */
    
    OUTPUT STREAM s-conteudo TO VALUE(SESSION:TEMP-DIRECTORY + "lixo.txt") NO-ECHO CONVERT TARGET "iso8859-1" APPEND.
    ASSIGN c-titulo = int(tit_acr.cod_tit_acr).
    PUT  STREAM s-conteudo
         tit_acr.cod_tit_acr_bco                           AT 1   
         cliente.nom_abrev                                 AT 22  
         c-titulo                                          AT 38
         '/'                             
         tit_acr.cod_parcela             
         tt-digita.cod-mensagem                            AT 52  
         tit_acr.dat_vencto_tit_acr                        AT 55 FORMAT '99/99/99'
         i-periodo                    FORMAT "->>9"        AT 63  
         dc-tit_acr.vend-vl-prestacao FORMAT ">>>>,>>9.99" TO 80 SKIP.      
    
    OUTPUT STREAM s-conteudo CLOSE.

    ASSIGN dc-total-tit = dc-total-tit + dc-tit_acr.vend-vl-prestacao.
    
    IF LAST-OF (tt-digita.c-portador) THEN DO:

        INPUT FROM VALUE(SESSION:TEMP-DIRECTORY + "lixo.txt").
        REPEAT:
            IMPORT UNFORMATTED c-conteudo-ax.
            ASSIGN c-conteudo-ax1 = c-conteudo-ax1 + c-conteudo-ax + CHR(13).
        END.
     
        ASSIGN c-conteudo = 'NOSSO NéMERO         CLIENTE         TÖTULO    VD INS VENCIMEN PER         VALOR' + CHR(13) +
                            '==================== =============== ============ === ======== ==== ============' + CHR(13)
               c-conteudo = c-conteudo + c-conteudo-ax1.
    
        RUN pi-campo ('banco',
                       c-banco).

        RUN pi-campo ('campo',
                       c-conteudo).

        RUN pi-campo('total','Total: ' + string(dc-total-tit,'>>>,>>>,>>9.99':U)).
        
        ASSIGN c-final = 'CàDIGOS DE  INSTRU€ÇO: ' + CHR(13).

        REPEAT i-cont-ax = 1 TO NUM-ENTRIES(c-mensagens):
            FIND FIRST msg_financ NO-LOCK USE-INDEX msgfnnc_id
                WHERE msg_financ.cod_empresa  = v_cod_empres_usuar 
                  AND msg_financ.cod_estab    = v_cod_estab_usuar
                  AND msg_financ.cod_mensagem = ENTRY(i-cont-ax,c-mensagens) NO-ERROR.
            IF AVAIL msg_financ THEN DO:
                FIND FIRST tt-complemento NO-LOCK
                    WHERE tt-complemento.cod-mensagem = int(msg_financ.cod_mensagem) NO-ERROR.
                IF AVAIL tt-complemento THEN 
                
                    ASSIGN c-final = c-final + CHR(13) + 
                                     STRING(msg_financ.cod_mensagem) + ' - ' +
                                     SUBSTITUTE(msg_financ.des_mensagem,tt-complemento.complemento).
                ELSE 
                    ASSIGN c-final = c-final + CHR(13) +
                                     STRING(msg_financ.cod_mensagem) + ' - ' + 
                                     msg_financ.des_mensagem.
            END.
        END.
        
        ASSIGN c-final = c-final + 
                         CHR(13) + CHR(13) + CHR(13) +
                         'DESDE Jµ AGRADECEMOS.'     + CHR(13) + CHR(13) +
                         'ATENCIOSAMENTE,'           + CHR(13) + CHR(13) +
                         'Nilza Helena Paul'         + CHR(13) +
                         'Tesoureira'.
    
        RUN pi-campo ('final',
                       c-final).
        RUN pi-impressao-documento.

    END.  /*IF LAST-OF (tt-digita.c-portador) */

END.  /*tt-digita */
/*********************************************************************************************************/
PROCEDURE pi-campo:
    DEFINE INPUT PARAMETER p-campo AS CHARACTER.
    DEFINE INPUT PARAMETER p-valor AS CHARACTER.

    CREATE tt-dados.
    ASSIGN tt-dados.campo-nome = p-campo
           tt-dados.campo-tipo = 3
           tt-dados.campo-valor = p-valor.

END PROCEDURE.

PROCEDURE pi-impressao-documento:

    /* Integra‡Æo com WORD */
    IF NOT VALID-HANDLE(h-utapi012) THEN
        RUN utp/utapi012.p PERSISTENT SET h-utapi012.

    RUN pi-execute in h-utapi012 (INPUT-OUTPUT TABLE tt-configuracao2,
                                  INPUT-OUTPUT TABLE tt-dados,
                                  INPUT-OUTPUT TABLE tt-erros).

    IF RETURN-VALUE = 'NOK':U THEN DO:
        FOR EACH tt-erros:
            DISPLAY tt-erros WITH 1 col WIDTH 500.
        END.
    END.
    ELSE DO:
        ASSIGN i-seq-docum = i-seq-docum + 1.
        CREATE tt-arquivos.
        ASSIGN tt-arquivos.arquivo = c-arq-word
               tt-arquivos.seq     = i-seq-docum.
    END.

END PROCEDURE.

PROCEDURE pi-configura-word:

    DEFINE INPUT  PARAMETER pArquivoWord    AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pArquivoModelo  AS CHARACTER  NO-UNDO.
                                                                                      
    ASSIGN c-conteudo-ax1 = ''
           c-conteudo-ax  = ''
           c-conteudo     = ''
           dc-total-tit   = 0.
           
    FOR EACH tt-dados:
        DELETE tt-dados.
    END.
    FOR EACH tt-configuracao2:
        DELETE tt-configuracao2.
    END.
    FOR EACH tt-erros:
        DELETE tt-erros.
    END.

    /*caso o arquivo a ser criado j  exista, ele ‚ eliminado*/
    IF SEARCH(pArquivoWord) <> ? THEN
        OS-DELETE VALUE(c-arq-word).

    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao   = 1
           tt-configuracao2.senha-modelo        = '':U
           tt-configuracao2.exibir-construcao   = NO
           tt-configuracao2.abrir-word-termino  = IF c-destino = 'Terminal'  OR
                                                     c-destino = 'Arquivo' THEN
                                                      YES
                                                  ELSE
                                                      NO
           tt-configuracao2.imprimir            = IF c-destino = 'Impressora' THEN
                                                      YES
                                                  ELSE
                                                      NO
           tt-configuracao2.arquivo             = pArquivoWord /*arquivo que serÿ gerado*/
           tt-configuracao2.modelo              = SEARCH(pArquivoModelo).

END PROCEDURE.

PROCEDURE WinExec EXTERNAL 'kernel32.dll':U:
   DEFINE INPUT PARAMETER prog_name    AS CHARACTER.
   DEFINE INPUT PARAMETER visual_style AS SHORT.
END PROCEDURE.
