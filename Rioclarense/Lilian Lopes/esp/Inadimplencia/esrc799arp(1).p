 
 def input param c-arquiv as char.
  def var c-assunto as char.
  DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.


    ASSIGN c-assunto = 'Relatorio Cobranca ' + string(today).

{utp/utapi019.i} /* include padr’o para envio de e-mail */

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = 'Segue relatorio de cobranca ESCR799 ' + STRING(today) + '.'.

        FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
 
    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.remetente         = 'sistema@rioclarense.com.br'
           tt-envio2.destino           = usuar_mestre.cod_e_mail_local
           tt-envio2.assunto           = c-assunto
           tt-envio2.importancia       = 2
           tt-envio2.log-enviada       = NO
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.formato           = 'HTML'
           tt-envio2.arq-anexo         = c-arquiv.

    run utp/utapi019.p persistent set h-utapi019.
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute2 in h-utapi019 (input table tt-envio2,
                                   input table tt-mensagem,
                                   output table tt-erros).
    output close.
    delete procedure h-utapi019.
 

