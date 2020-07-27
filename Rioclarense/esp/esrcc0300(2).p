DEF INPUT PARAM p-row-id AS ROWID.
def new global shared var gr-mla-tipo-doc-aprov as rowid no-undo.
def var i-cod-tip-doc as integer no-undo.
def var c-chave-doc   as char    no-undo.

def var c-lista-situacao as char no-undo.
def var c-lista-consulta as char no-undo.
def var c-situacao       as char format "x(12)".
def var c-arquivo        as char no-undo.
def var c-arquivo-anexo  as char no-undo.

def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.

def var i-aux as integer no-undo.

def buffer b-mla-usuar-aprov for mla-usuar-aprov.

{cdp/cd0666.i}
{lap/mlaapi001.i99}
{utp/utapi019.i}
{laphtml/mlahtml.i}

def var c-ass-e-mail as char    no-undo.
def var c-men-e-mail as char    no-undo.

def var i-chave as integer no-undo.
def var c-chave as char    no-undo.


def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.
def new global shared var g-empresa-aed LIKE mgcad.empresa.ep-codigo     no-undo.
def new global shared var gc-estabel-aed LIKE estabelec.cod-estabel no-undo.

def var c-nome-usuar-trans like mla-usuar-aprov.nome-usuar NO-UNDO.
def var c-nome-usuar-doc   like mla-usuar-aprov.nome-usuar NO-UNDO.
def var c-nome-usuar-aprov like mla-usuar-aprov.nome-usuar NO-UNDO.
def var c-nome-usuar-alter like mla-usuar-aprov.nome-usuar NO-UNDO.
/*def var i-mo-codigo-aprov  like mla-usuar-aprov.mo-codigo NO-UNDO.*/ /*Chamado TPOLOI - Rodrigo*/

def var c-hora-apr as char format "x(08)".
def var c-hora-rej as char format "x(08)".
def var c-hora-rea as char format "x(08)".

DEF VAR c-fabricante AS CHAR.
        
FIND FIRST pedido-compr NO-LOCK WHERE ROWID(pedido-compr) = p-row-id NO-ERROR.

FIND FIRST ordem-compra NO-LOCK WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-ERROR.

FIND FIRST ext-item WHERE ext-item.it-codigo = ordem-compra.it-codigo NO-ERROR.

IF AVAIL ext-item THEN
    ASSIGN c-fabricante = ext-item.cod-fabricante.

ELSE 
    ASSIGN c-fabricante = "Despesas".


    FIND FIRST mla-doc-pend-aprov NO-LOCK WHERE mla-doc-pend-aprov.chave-doc = string(pedido-compr.num-pedido) 
                                          AND   mla-doc-pend-aprov.cod-tip-doc = 8 
                                          AND   mla-doc-pend-aprov.ind-situacao <> 2 NO-ERROR. 

        IF NOT AVAIL mla-doc-pend-aprov  THEN DO:
        MESSAGE "Dcto ja aprovado, nao sera enviado email" VIEW-AS ALERT-BOX.
        next.

    END.


        find first mla-tipo-doc-aprov where
            mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel and
            mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
            no-lock no-error.

        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = c-seg-usuario
            no-lock no-error.

        find first b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar
            no-lock no-error.

        find first mla-param-aprov where
            mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
            no-lock no-error.

        {lap/mlaapi001.i01}
        create tt-mla-chave.
        assign i-chave = 0.
        for each mla-chave-doc-aprov where
            mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock:
            assign i-chave = i-chave + 1
                   tt-mla-chave.valor[i-chave] = substring(mla-doc-pend-aprov.chave-doc,
                                                 mla-chave-doc-aprov.posicao-ini,
                                                 ((mla-chave-doc-aprov.posicao-fim -
                                                   mla-chave-doc-aprov.posicao-ini) + 1)).
        end.        

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:

            run utp/ut-msgs.p (input "msg", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                               mla-doc-pend-aprov.chave-doc + "~~" +
                                                               mla-doc-pend-aprov.cod-usuar-trans).
            assign c-ass-e-mail = return-value.
            
            for each tt-envio2:
                delete tt-envio2.
            end.
            
            if not mla-param-aprov.log-senha then do:
                /**  Texto
                **/

                find first moeda
                     where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                run utp/ut-msgs.p (input "help", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                              moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                              mla-doc-pend-aprov.cod-usuar-trans).
                assign c-men-e-mail = return-value.
    
                if mla-param-aprov.compl-email <> "" then do:
                    assign c-men-e-mail = c-men-e-mail + chr(13) + trim(mla-param-aprov.compl-email).
                end.
                
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = mla-param-aprov.log-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-fabricante + " "  + c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = "".
                if  not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                    assign tt-envio.remetente = mla-usuar-aprov.e-mail.
                                   
                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
                               
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio no-error.                                    
                {lap/mlaapi001.i02 "b03in021.w (01)" tt-envio.destino tt-envio.remetente}               
                                    
                /**  Envia E-mail para os Alternativos
                **/                    
                if  mla-param-aprov.log-aprov-altern then do:
                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar     = mla-doc-pend-aprov.cod-usuar and
                        mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                        find first b-mla-usuar-aprov 
                             where b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                             no-lock no-error.

                        IF NOT AVAIL b-mla-usuar-aprov THEN DO:
                           /* Inicio -- Projeto Internacional */
                           DEFINE VARIABLE c-lbl-liter-aviso AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "AVISO" *}
                           ASSIGN c-lbl-liter-aviso = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "Usu†rio" *}
                           ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-nao-esta-cadastrado-no-mla AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "n∆o_est†_cadastrado_no_MLA" *}
                           ASSIGN c-lbl-liter-nao-esta-cadastrado-no-mla = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-help AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "HELP" *}
                           ASSIGN c-lbl-liter-help = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-favor-verificar-no-programa-ml AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "Favor_verificar_no_programa_MLA0103_(Usu†rios" *}
                           ASSIGN c-lbl-liter-favor-verificar-no-programa-ml = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-da-aprovacao-se-o-usuario AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "da_Aprovaá∆o)_se_o_usu†rio" *}
                           ASSIGN c-lbl-liter-da-aprovacao-se-o-usuario = TRIM(RETURN-VALUE).
                           DEFINE VARIABLE c-lbl-liter-esta-cadastrado AS CHARACTER NO-UNDO.
                           {utp/ut-liter.i "est†_cadastrado" *}
                           ASSIGN c-lbl-liter-esta-cadastrado = TRIM(RETURN-VALUE).
                           MESSAGE c-lbl-liter-aviso + ":"
                                   c-lbl-liter-usuario + " " mla-usuar-aprov-altern.cod-usuar-altern " " + c-lbl-liter-nao-esta-cadastrado-no-mla + "." SKIP(1)
                                   c-lbl-liter-help + ": "
                                   c-lbl-liter-favor-verificar-no-programa-ml + " " SKIP
                                   c-lbl-liter-da-aprovacao-se-o-usuario + " " mla-usuar-aprov-altern.cod-usuar-altern " " + c-lbl-liter-esta-cadastrado + "."
                                   VIEW-AS ALERT-BOX INFO BUTTONS OK.                        
                           NEXT.
                        END.

                        for each tt-envio:
                            delete tt-envio.
                        end.
                        for each tt-erros:
                            delete tt-erros.
                        end.
                        
                        create tt-envio.
                        assign tt-envio.versao-integracao = 1
                               tt-envio.exchange    = mla-param-aprov.log-exchange
                               tt-envio.destino     = b-mla-usuar-aprov.e-mail
                               tt-envio.assunto     = c-fabricante + " "  + c-ass-e-mail
                               tt-envio.mensagem    = c-men-e-mail
                               tt-envio.importancia = 2
                               tt-envio.log-enviada = no
                               tt-envio.log-lida    = no
                               tt-envio.acomp       = no
                               tt-envio.arq-anexo   = "".

                        if  not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                            assign tt-envio.remetente = mla-usuar-aprov.e-mail.
                                           
                        run utp/utapi009.p (input  table tt-envio,
                                            output table tt-erros).
                                           
                        /**  Output do erro (e-mail)
                        **/               
                        find first tt-envio no-error.                                            
                        {lap/mlaapi001.i02 "b03in021.w (02)" tt-envio.destino tt-envio.remetente}                                            
                                            
                    end.
                end.                                    
            end.
            else do:
                /**  HTML
                **/
                for each tt-html:
                    delete tt-html.
                end.
                for each tt-mensagem:
                    delete tt-mensagem.
                end.
                IF  mla-tipo-doc-aprov.cod-tip-doc < 10 THEN
                    RUN VALUE("laphtml/mlahtml00" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                            (input  mla-tipo-doc-aprov.cod-tip-doc,
                             input  b-mla-usuar-aprov.cod-usuar,   
                             input  table tt-mla-chave,
                             output TABLE tt-html).
                ELSE 
                    RUN VALUE("laphtml/mlahtml0" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                            (input  mla-tipo-doc-aprov.cod-tip-doc,
                             input  b-mla-usuar-aprov.cod-usuar,
                             input  table tt-mla-chave,
                             output TABLE tt-html).
                
                FIND FIRST tt-html NO-ERROR.
                IF  AVAILABLE tt-html THEN
                    ASSIGN c-men-e-mail = tt-html.html-doc.

                if  mla-param-aprov.log-atachado then do:
                    assign c-arquivo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                    OUTPUT TO value(c-arquivo) APPEND.
                    FOR EACH tt-html :
                        PUT UNFORMATTED tt-html.html-doc SKIP.
                    END.
                    OUTPUT CLOSE.
                end.
                else do:
                    FOR EACH tt-html:
                        CREATE tt-mensagem.
                        ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
                               tt-mensagem.mensagem     = tt-html.html-doc.
                    END.
                end.

                create tt-envio2.
                assign tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = mla-param-aprov.log-exchange
                       tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio2.assunto     = c-fabricante + " "  + c-ass-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = "HTML".            
                
                if  mla-param-aprov.log-atachado then    
                    assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(13) +
                                                   "Favor verificar o arquivo atachado."
                           tt-envio2.arq-anexo   = c-arquivo.
                else                           
                    assign tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = "".
       
                if  not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                    assign tt-envio2.remetente = mla-usuar-aprov.e-mail.

                /* Html para Palm */
                run lap/mlaapi012.p (input mla-doc-pend-aprov.ep-codigo,
                                     input mla-doc-pend-aprov.cod-estabel,
                                     input mla-tipo-doc-aprov.cod-tip-doc,
                                     input b-mla-usuar-aprov.cod-usuar,   
                                     input table tt-mla-chave,
                                     output c-arquivo-anexo). 
                if  return-value = "OK" then do:
                    if  tt-envio2.arq-anexo = "" then
                        assign tt-envio2.arq-anexo = c-arquivo-anexo.
                    else 
                        assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                                   + c-arquivo-anexo.
                end.
                /*Fim Html para Palm*/
                                                   
                run utp/utapi019.p persistent set h-utapi019.
                
                if  mla-param-aprov.log-atachado then
                    run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                   output table tt-erros).
                else
                    run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                   input table tt-mensagem,
                                                   output table tt-erros).                                                                           

                /**  Output do erro (e-mail)
                **/               
                find first tt-envio2 no-error.               
                {lap/mlaapi001.i02 "b03in021.w (03)" tt-envio2.destino tt-envio2.remetente}                               
                                                       
                delete procedure h-utapi019.

                if  mla-param-aprov.log-atachado then
                    os-delete value(c-arquivo).

                os-delete value(c-arquivo-anexo).
                                    
                /**  Envia E-mail para os Alternativos
                **/                    
                if  mla-param-aprov.log-aprov-altern then do:

                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar     = mla-doc-pend-aprov.cod-usuar and
                        mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                            no-lock no-error.

                        for each tt-envio2:
                            delete tt-envio2.
                        end.
                        for each tt-erros:
                            delete tt-erros.
                        end.
                        for each tt-html:
                            delete tt-html.
                        end.
                        for each tt-mensagem:
                            delete tt-mensagem.
                        end.

                        IF mla-tipo-doc-aprov.cod-tip-doc < 10 THEN
                            RUN VALUE("laphtml/mlahtml00" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                                    (input  mla-tipo-doc-aprov.cod-tip-doc,
                                     input  b-mla-usuar-aprov.cod-usuar,
                                     input  table tt-mla-chave,
                                     output TABLE tt-html).
                        ELSE 
                            RUN VALUE("laphtml/mlahtml0" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                                    (input  mla-tipo-doc-aprov.cod-tip-doc,
                                     input  b-mla-usuar-aprov.cod-usuar,   
                                     input  table tt-mla-chave,
                                     output TABLE tt-html).
                        
                        FIND FIRST tt-html NO-ERROR.
                        IF AVAILABLE tt-html THEN
                                ASSIGN c-men-e-mail = tt-html.html-doc.

                        if  mla-param-aprov.log-atachado then do:
                            assign c-arquivo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                            OUTPUT TO value(c-arquivo) APPEND.
                            FOR EACH tt-html :
                                PUT UNFORMATTED tt-html.html-doc SKIP.
                            END.
                            OUTPUT CLOSE.
                        end.
                        else do:
                            FOR EACH tt-html:
                                CREATE tt-mensagem.
                                ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
                                       tt-mensagem.mensagem     = tt-html.html-doc.
                            END.
                        end.
        
                        create tt-envio2.
                        assign tt-envio2.versao-integracao = 1
                               tt-envio2.exchange    = mla-param-aprov.log-exchange
                               tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                               tt-envio2.assunto     = c-fabricante + " "  + c-ass-e-mail
                               tt-envio2.importancia = 2
                               tt-envio2.log-enviada = no
                               tt-envio2.log-lida    = no
                               tt-envio2.acomp       = no
                               tt-envio2.formato     = "HTML".            
                               
                        if  mla-param-aprov.log-atachado then
                            assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(13) +
                                                           "Favor verificar o arquivo atachado."
                                   tt-envio2.arq-anexo   = c-arquivo.
                        else                           
                            assign tt-envio2.mensagem    = c-men-e-mail
                                   tt-envio2.arq-anexo   = "".
                               
                        if  not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                            assign tt-envio2.remetente = mla-usuar-aprov.e-mail.

                        /* Html para Palm */
                        run lap/mlaapi012.p (input mla-doc-pend-aprov.ep-codigo,
                                             input mla-doc-pend-aprov.cod-estabel,
                                             input mla-tipo-doc-aprov.cod-tip-doc,
                                             input b-mla-usuar-aprov.cod-usuar,   
                                             input table tt-mla-chave,
                                             output c-arquivo-anexo). 
                        if  return-value = "OK" then do:
                            if  tt-envio2.arq-anexo = "" then
                                assign tt-envio2.arq-anexo = c-arquivo-anexo.
                            else 
                                assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                                           + c-arquivo-anexo.
                        end.
                        /*Fim Html para Palm*/

                        run utp/utapi019.p persistent set h-utapi019.
                    
                        if mla-param-aprov.log-atachado then
                            run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                           output table tt-erros).
                        else
                            run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                           input table tt-mensagem,
                                                           output table tt-erros).                                                                           

                        /**  Output do erro (e-mail) **/               
                        find first tt-envio2 no-error.
                        {lap/mlaapi001.i02 "b03in021.w (04)" tt-envio2.destino tt-envio2.remetente}
                        
                        delete procedure h-utapi019.

                        if  mla-param-aprov.log-atachado then
                            os-delete value(c-arquivo).

                        os-delete value(c-arquivo-anexo).
                    end.
                end.                                    
            end.
            
            find first tt-erros
                no-lock no-error.
            if not available tt-erros then
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-e-mail-enviado-com-sucesso AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "E-mail_enviado_com_sucesso" *}
                ASSIGN c-lbl-liter-e-mail-enviado-com-sucesso = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-confirmacao-do-e-mail AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Confirmaá∆o_do_E-mail" *}
                ASSIGN c-lbl-liter-confirmacao-do-e-mail = TRIM(RETURN-VALUE).
                message c-lbl-liter-e-mail-enviado-com-sucesso + "!" view-as alert-box title c-lbl-liter-confirmacao-do-e-mail.
                END. 
            else            
            for each tt-erros:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erros_ao_tentar_enviar_o_e-mail" *}
                message tt-erros.cod-erro " - " 
                            substring(tt-erros.desc-erro,1,40) view-as alert-box title RETURN-VALUE.
            end.                      


END.


