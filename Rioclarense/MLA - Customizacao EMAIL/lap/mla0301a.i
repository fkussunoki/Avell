    DEF VAR l-email-faixa-hierarquia AS LOG NO-UNDO.
    DEF VAR gEmail-cod-usuar         AS CHAR NO-UNDO.
    DEF VAR c-desc-aprov-auto AS CHAR NO-UNDO.
    DEF VAR l-auto-aprovador      AS LOG  NO-UNDO.
    DEF VAR c-usu-auto-aprovador  AS CHAR NO-UNDO.
    DEF VAR c-nar-auto-aprovador  AS CHAR NO-UNDO.
    DEF VAR c-lim-auto-aprovador  AS DEC  NO-UNDO.
    def var r-doc as rowid no-undo.

    def buffer b-mla-chave-doc-aprov for mla-chave-doc-aprov.
    def var i-posicao       as integer                    no-undo.
    def var i-nr-requisicao like requisicao.nr-requisicao no-undo.
    def var i-sequencia     like it-requisicao.sequencia  no-undo.
    def var c-it-codigo     like it-requisicao.it-codigo  no-undo.

    procedure pi-gera-pendencia:
        def input parameter p-narrativa as char    format "x(2000)".
        def input parameter p-usuario   as char    no-undo.
        def input parameter p-limite    as decimal no-undo.
        

        /**  Aprova‡Æo automaticamente da lista
        **/
        if mla-doc-pend-aprov.ind-tip-aprov = 2 then do:
            find first mla-tipo-aprov where
                mla-tipo-aprov.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov 
                no-lock no-error.
            assign i-nr-min-aprov = 0.
            for each b-mla-doc-pend-aprov where
                b-mla-doc-pend-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo and
                b-mla-doc-pend-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel and            
                b-mla-doc-pend-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc   and
                b-mla-doc-pend-aprov.ind-tip-aprov = mla-doc-pend-aprov.ind-tip-aprov and
                b-mla-doc-pend-aprov.chave-doc     = mla-doc-pend-aprov.chave-doc     and
               (b-mla-doc-pend-aprov.ind-situacao  = 2  or
                b-mla-doc-pend-aprov.ind-situacao  = 4) and
                b-mla-doc-pend-aprov.historico     = no no-lock:
                assign i-nr-min-aprov = i-nr-min-aprov + 1.
            end.            
            if i-nr-min-aprov >= mla-tipo-aprov.nr-min-aprov then do:
                for each b-mla-doc-pend-aprov where
                    b-mla-doc-pend-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo and
                    b-mla-doc-pend-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel and                
                    b-mla-doc-pend-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc   and
                    b-mla-doc-pend-aprov.ind-tip-aprov = mla-doc-pend-aprov.ind-tip-aprov and
                    b-mla-doc-pend-aprov.chave-doc     = mla-doc-pend-aprov.chave-doc     and
                    b-mla-doc-pend-aprov.ind-situacao  = 1                                and
                    b-mla-doc-pend-aprov.historico     = no
                    EXCLUSIVE-LOCK:
                    assign b-mla-doc-pend-aprov.dt-aprova        = today
                           b-mla-doc-pend-aprov.ind-situacao     = 2
                           b-mla-doc-pend-aprov.narrativa-apr    = p-narrativa
                           b-mla-doc-pend-aprov.aprov-auto       = yes.
                           
                    assign substring(b-mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss").                           
                           
                    if b-mla-doc-pend-aprov.cod-usuar <> p-usuario then 
                        assign b-mla-doc-pend-aprov.cod-usuar-altern = gc-cod-usuar-aprov.                   
                end.
            end.           
        end.
    
        /**  Gera pr¢xima pendˆncia
        **/
        if mla-doc-pend-aprov.ind-tip-aprov = 1 then do:
            run pi-gera-hierarquia (p-limite).
        end.
        if mla-doc-pend-aprov.ind-tip-aprov = 5 then do:
            run pi-gera-faixa (p-limite).
        end.
    

        /* IF para tratar aprova‡Æo t‚cnica.
       Zerado o limite de aprova‡Æo.
       Isto se faz necess rio para os casos em que o aprovador t‚cnico ‚ aprovador
       de outro tipo de aprova‡Æo(Faixa por exemplo), fazendo com que o limite do mesmo seja
       ignorado caso esta seja uma aprova‡Æo t‚cnica
       */
        IF mla-doc-pend-aprov.ind-tip-aprov = 4 OR 
           mla-doc-pend-aprov.ind-tip-aprov = 2 THEN DO:
            ASSIGN p-limite = 0.
        END.
        
        /**  Gera pr¢ximo tipo de aprova‡Æo
        **/

        if  NOT l-gera-proxima AND
            mla-doc-pend-aprov.prioridade-aprov <> 0 THEN DO:
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
            if gi-prox-prior > 0 then do:
                assign gi-prox-prior = gi-prox-prior + 10.
                run lap/mlaapi001.p (mla-doc-pend-aprov.cod-tip-doc,
                                      1,
                                      mla-doc-pend-aprov.motivo-doc,
                                      mla-doc-pend-aprov.valor-doc,
                                      mla-doc-pend-aprov.mo-codigo,
                                      mla-doc-pend-aprov.cod-usuar-trans,
                                      mla-doc-pend-aprov.cod-usuar-doc,
                                      mla-doc-pend-aprov.cod-lotacao-doc,
                                      mla-doc-pend-aprov.it-codigo,
                                      mla-doc-pend-aprov.cod-referencia,
                                      mla-doc-pend-aprov.ep-codigo,
                                      mla-doc-pend-aprov.cod-estabel,
                                      input  table tt-mla-chave,
                                      output table tt-erro).                      
                           
                run lap/mlaapi002.p (mla-doc-pend-aprov.cod-tip-doc,    
                                     input  table tt-mla-chave,
                                     output table tt-erro).
                                      
                find first tt-erro
                    no-lock no-error.
                if available tt-erro then
                    assign l-gera-proxima = yes.                                  
            end.
        end.
        
    end procedure.
    
    procedure pi-gera-faixa:

        def input parameter p-limite as decimal no-undo.

/*         find first mla-usuar-aprov where                                   */
/*             mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans */
/*             no-lock no-error.                                              */
/*         if mla-usuar-aprov.destino-lotacao = 1 THEN DO:                    */
/*             assign c-lotacao = mla-usuar-aprov.cod-lotacao.                */
/*             IF c-lotacao = "" THEN                                         */
/*                 assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.     */
/*         END.                                                               */
/*         ELSE DO:                                                           */
/*             assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.         */
/*             IF c-lotacao = "" THEN                                         */
/*                 assign c-lotacao = mla-usuar-aprov.cod-lotacao.            */
/*         END.                                                               */
    
        ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "" THEN DO:
            FIND mla-usuar-aprov WHERE
                mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc
                NO-LOCK NO-ERROR.
            IF AVAILABLE mla-usuar-aprov THEN
                ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
        END.

        find first mla-hierarquia-faixa where
            mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel and        
            mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
            mla-hierarquia-faixa.cod-lotacao = c-lotacao and
            mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa and
            mla-hierarquia-faixa.seq-aprov   = mla-doc-pend-aprov.seq-aprov
            no-lock no-error.
            
        if available mla-hierarquia-faixa and
            (mla-hierarquia-faixa.log-depend = yes or
            (mla-hierarquia-faixa.log-depend = no  and
             p-limite < mla-doc-pend-aprov.valor-doc)) then do:
             
            find NEXT mla-hierarquia-faixa where
                mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
                mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel and            
                mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                mla-hierarquia-faixa.cod-lotacao = c-lotacao and
                mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa /*and
                mla-hierarquia-faixa.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1)*/
                no-lock no-error.
            if available mla-hierarquia-faixa then do:
                
                

                create b-mla-doc-pend-aprov.
                assign b-mla-doc-pend-aprov.ep-codigo         = mla-doc-pend-aprov.ep-codigo
                       b-mla-doc-pend-aprov.cod-estabel       = mla-doc-pend-aprov.cod-estabel
                       b-mla-doc-pend-aprov.chave-doc         = mla-doc-pend-aprov.chave-doc
                       b-mla-doc-pend-aprov.cod-lotacao-doc   = mla-doc-pend-aprov.cod-lotacao-doc
                       b-mla-doc-pend-aprov.cod-lotacao-trans = mla-doc-pend-aprov.cod-lotacao-trans
                       b-mla-doc-pend-aprov.cod-tip-aprov     = mla-doc-pend-aprov.cod-tip-aprov
                       b-mla-doc-pend-aprov.cod-tip-doc       = mla-doc-pend-aprov.cod-tip-doc
                       b-mla-doc-pend-aprov.cod-usuar         = mla-hierarquia-faixa.cod-usuar
                       b-mla-doc-pend-aprov.cod-usuar-doc     = mla-doc-pend-aprov.cod-usuar-doc
                       b-mla-doc-pend-aprov.cod-usuar-trans   = mla-doc-pend-aprov.cod-usuar-trans
                       b-mla-doc-pend-aprov.dt-geracao        = today
                       b-mla-doc-pend-aprov.ind-situacao      = 1
                       b-mla-doc-pend-aprov.ind-tip-aprov     = mla-doc-pend-aprov.ind-tip-aprov
                       b-mla-doc-pend-aprov.it-codigo         = mla-doc-pend-aprov.it-codigo
                       b-mla-doc-pend-aprov.mo-codigo         = mla-doc-pend-aprov.mo-codigo
                       b-mla-doc-pend-aprov.motivo-doc        = mla-doc-pend-aprov.motivo-doc
                       b-mla-doc-pend-aprov.num-faixa         = mla-doc-pend-aprov.num-faixa
                       b-mla-doc-pend-aprov.seq-aprov         = mla-hierarquia-faixa.seq-aprov
                       b-mla-doc-pend-aprov.valor-doc         = mla-doc-pend-aprov.valor-doc
                       b-mla-doc-pend-aprov.prioridade-aprov  = mla-doc-pend-aprov.prioridade-aprov
                       b-mla-doc-pend-aprov.hora-geracao      = string(time,"HH:MM:SS")
                       b-mla-doc-pend-aprov.cod-referencia    = mla-doc-pend-aprov.cod-referencia.
                 
                assign l-gera-proxima = yes.                   

                

                IF mla-usuar-aprov.aprova-auto-aprov AND 
                   mla-hierarquia-faixa.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc AND
                   p-limite > mla-doc-pend-aprov.valor-doc  THEN DO:

                   {utp/ut-liter.i Aprova‡Æo_Autom tica_-_Usu rio_ * r}
                   ASSIGN c-desc-aprov-auto = RETURN-VALUE.
                   {utp/ut-liter.i _parametrizado_no_AED0103_como_Aprova‡Æo_Autom tica_para_Aprovadores * r}
                   ASSIGN b-mla-doc-pend-aprov.aprov-auto        = YES
                          b-mla-doc-pend-aprov.dt-aprova         = TODAY
                          b-mla-doc-pend-aprov.ind-situacao      = 2
                          b-mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(mla-hierarquia-faixa.cod-usuar) + RETURN-VALUE.

                   assign substring(b-mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 
                   
                   ASSIGN l-auto-aprovador     = YES
                          c-usu-auto-aprovador = mla-hierarquia-faixa.cod-usuar
                          c-nar-auto-aprovador = b-mla-doc-pend-aprov.narrativa-apr
                          c-lim-auto-aprovador = p-limite
                          r-doc            = ROWID(b-mla-doc-pend-aprov).

                   /**  Envia e-mail ao usu rio
                   **/
                   find first mla-param-aprov where
                       mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
                       mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                       no-lock no-error.
                   find first bb-mla-usuar-aprov WHERE 
                        bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar
                        no-lock no-error.

                   IF mla-doc-pend-aprov.cod-tip-doc = 7
                   OR mla-doc-pend-aprov.cod-tip-doc = 8 THEN
                      find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc
                            no-lock no-error.
                   ELSE
                      find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans
                            no-lock no-error.

                   if  available mla-param-aprov      and
                       mla-param-aprov.log-email      and
                       available bb-mla-usuar-aprov   and
                       available b-mla-usuar-aprov    and
                       bb-mla-usuar-aprov.envia-email and
                       b-mla-usuar-aprov.recebe-email and 
                       b-mla-usuar-aprov.e-mail <> "" then do:

                       find first moeda
                            where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                       if p-tipo-trans = 2 then do:
                           /**  Rejei‡Æo
                           **/
                           run utp/ut-msgs.p (input "msg", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +  
                                                                         mla-hierarquia-faixa.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar).
                       end.
                       else do:
                           /**  Aprova‡Æo
                           **/
                           run utp/ut-msgs.p (input "msg", input 26652, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +
                                                                         mla-hierarquia-faixa.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar).
                       end.
                       assign c-ass-e-mail = return-value.

                       if p-tipo-trans = 2 then do:
                           /**  Rejei‡Æo
                           **/
                           run utp/ut-msgs.p (input "help", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                         gc-cod-usuar-aprov + " - " + bb-mla-usuar-aprov.nome-usuar + "~~" +
                                                                         mla-doc-pend-aprov.narrativa-rej). /** narrativa-apr **/
                       end.
                       else do:
                           /**  Aprova‡Æo
                           **/
                           run utp/ut-msgs.p (input "help", input 26652, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +
                                                                         moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                         mla-hierarquia-faixa.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar + "~~" +
                                                                         mla-doc-pend-aprov.narrativa-apr).
                       end.
                       assign c-men-e-mail = return-value.

                       assign c-men-e-mail = c-men-e-mail + CHR(10).

                       if avail mla-doc-pend-aprov then
                            for first mla-chave-doc-aprov fields( posicao-ini posicao-fim )  where
                                      mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock
                             break by mla-chave-doc-aprov.posicao-ini :
                        
                                assign i-posicao       =  mla-chave-doc-aprov.posicao-fim + 1
                                       i-nr-requisicao = int(substr(mla-doc-pend-aprov.chave-doc,mla-chave-doc-aprov.posicao-ini,
                                                                  ((mla-chave-doc-aprov.posicao-fim -
                                                                    mla-chave-doc-aprov.posicao-ini) + 1))).
                        
                                 for first b-mla-chave-doc-aprov fields( posicao-ini posicao-fim )   where
                                           b-mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  and
                                           b-mla-chave-doc-aprov.posicao-ini = i-posicao                       no-lock
                                  break by b-mla-chave-doc-aprov.posicao-ini :
                                     assign i-posicao   =  b-mla-chave-doc-aprov.posicao-fim + 1
                                            i-sequencia = int(substr(mla-doc-pend-aprov.chave-doc,b-mla-chave-doc-aprov.posicao-ini,
                                                                   ((b-mla-chave-doc-aprov.posicao-fim -
                                                                     b-mla-chave-doc-aprov.posicao-ini) + 1))).
                        
                                 end.
                        
                                 for first b-mla-chave-doc-aprov fields( posicao-ini posicao-fim ) where
                                           b-mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  and
                                           b-mla-chave-doc-aprov.posicao-ini = i-posicao                       no-lock
                                  break by b-mla-chave-doc-aprov.posicao-ini:
                                    assign c-it-codigo = substr(mla-doc-pend-aprov.chave-doc,b-mla-chave-doc-aprov.posicao-ini,
                                                              ((b-mla-chave-doc-aprov.posicao-fim -
                                                                b-mla-chave-doc-aprov.posicao-ini) + 1)).
                        
                                 end.
                            end.

                       if mla-doc-pend-aprov.cod-tip-doc = 2 
                       or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                          for each it-requisicao
                              where it-requisicao.nr-requisicao = i-nr-requisicao no-lock:
                              assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                          end.
                       end.
                       if mla-doc-pend-aprov.cod-tip-doc = 1 
                       or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                          for each it-requisicao
                              where it-requisicao.nr-requisicao = i-nr-requisicao
                              AND   it-requisicao.sequencia     = i-sequencia
                              AND   it-requisicao.it-codigo     = c-it-codigo
                              no-lock:
                              assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                          end.
                       end.

                       if mla-param-aprov.compl-email <> "" then do:
                           assign c-men-e-mail = c-men-e-mail + chr(13) + trim(mla-param-aprov.compl-email).
                       end.

                      if  mla-tipo-doc-aprov.log-html and
                           b-mla-usuar-aprov.log-html then do:
                           /**  HTML
                           **/
                           for each tt-envio2:
                               delete tt-envio2.
                           end.
                           create tt-envio2.
                           assign tt-envio2.versao-integracao = 1
                                  tt-envio2.exchange    = mla-param-aprov.log-exchange
                                  tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                                  tt-envio2.assunto     = c-ass-e-mail
                                  tt-envio2.mensagem    = c-men-e-mail
                                  tt-envio2.importancia = 2
                                  tt-envio2.log-enviada = no
                                  tt-envio2.log-lida    = no
                                  tt-envio2.acomp       = no.
                                  tt-envio2.arq-anexo   = "".
                           if bb-mla-usuar-aprov.e-mail <> "" then
                              assign tt-envio2.remetente = bb-mla-usuar-aprov.e-mail.
                           run utp/utapi019.p persistent set h-utapi019.
                           run pi-execute in h-utapi019 (input table tt-envio2,                   
                                                         output table tt-erros).
                                                         
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio2 no-error.                    
                            {lap/mlaapi001.i02 "aed030a.i (01)" tt-envio2.destino tt-envio2.remetente}                                    
                                                         
                           delete procedure h-utapi019.
                       end.
                       else do:
                           /**  Texto
                           **/
                           for each tt-envio:
                               delete tt-envio.
                           end.
                           create tt-envio.
                           assign tt-envio.versao-integracao = 1
                                  tt-envio.exchange    = mla-param-aprov.log-exchange
                                  tt-envio.destino     = b-mla-usuar-aprov.e-mail
                                  tt-envio.assunto     = c-ass-e-mail
                                  tt-envio.mensagem    = c-men-e-mail
                                  tt-envio.importancia = 2
                                  tt-envio.log-enviada = no
                                  tt-envio.log-lida    = no
                                  tt-envio.acomp       = no.
                                  tt-envio.arq-anexo   = "".
                           if bb-mla-usuar-aprov.e-mail <> "" then
                              assign tt-envio.remetente = bb-mla-usuar-aprov.e-mail.
                           run utp/utapi009.p (input  table tt-envio,
                                               output table tt-erros).
                                               
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio no-error.                    
                            {lap/mlaapi001.i02 "aed030a.i (02)" tt-envio.destino tt-envio.remetente}                                    
                                               
                      END.
                   END.
                END.
                ELSE DO:
                    
                    RUN pi-envia-e-mail (gc-cod-usuar-aprov,
                                         mla-hierarquia-faixa.cod-usuar,
                                         1).
                    ASSIGN l-auto-aprovador = NO.
                END.
            END.
        END.         
    
    end procedure.
    
    procedure pi-gera-hierarquia:
    
        def input parameter p-limite as decimal no-undo.
    
/*         find first mla-usuar-aprov where                                   */
/*             mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans */
/*             no-lock no-error.                                              */
/*         if mla-usuar-aprov.destino-lotacao = 1 then                        */
/*             assign c-lotacao = mla-usuar-aprov.cod-lotacao.                */
/*         else                                                               */
/*             assign c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.         */
    

        ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "" THEN DO:
            FIND mla-usuar-aprov where mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK NO-ERROR.
            IF AVAILABLE mla-usuar-aprov THEN
                ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
        END.
        
        find first mla-hierarquia-aprov where
            mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel and        
            mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
            mla-hierarquia-aprov.cod-lotacao = c-lotacao and
            mla-hierarquia-aprov.seq-aprov   = mla-doc-pend-aprov.seq-aprov
            no-lock no-error.
            
        if available mla-hierarquia-aprov and
            (mla-hierarquia-aprov.log-depend = yes or
            (mla-hierarquia-aprov.log-depend = no  and
             p-limite < mla-doc-pend-aprov.valor-doc)) then do:
             
            find NEXT mla-hierarquia-aprov where
                mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
                mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel and            
                mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                mla-hierarquia-aprov.cod-lotacao = c-lotacao /*and
                mla-hierarquia-aprov.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1)*/
                no-lock no-error.
            if available mla-hierarquia-aprov then do:
                create b-mla-doc-pend-aprov.
                assign b-mla-doc-pend-aprov.ep-codigo         = mla-doc-pend-aprov.ep-codigo
                       b-mla-doc-pend-aprov.cod-estabel       = mla-doc-pend-aprov.cod-estabel
                       b-mla-doc-pend-aprov.chave-doc         = mla-doc-pend-aprov.chave-doc
                       b-mla-doc-pend-aprov.cod-lotacao-doc   = mla-doc-pend-aprov.cod-lotacao-doc
                       b-mla-doc-pend-aprov.cod-lotacao-trans = mla-doc-pend-aprov.cod-lotacao-trans
                       b-mla-doc-pend-aprov.cod-tip-aprov     = mla-doc-pend-aprov.cod-tip-aprov
                       b-mla-doc-pend-aprov.cod-tip-doc       = mla-doc-pend-aprov.cod-tip-doc
                       b-mla-doc-pend-aprov.cod-usuar         = mla-hierarquia-aprov.cod-usuar
                       b-mla-doc-pend-aprov.cod-usuar-doc     = mla-doc-pend-aprov.cod-usuar-doc
                       b-mla-doc-pend-aprov.cod-usuar-trans   = mla-doc-pend-aprov.cod-usuar-trans
                       b-mla-doc-pend-aprov.dt-geracao        = today
                       b-mla-doc-pend-aprov.ind-situacao      = 1
                       b-mla-doc-pend-aprov.ind-tip-aprov     = mla-doc-pend-aprov.ind-tip-aprov
                       b-mla-doc-pend-aprov.it-codigo         = mla-doc-pend-aprov.it-codigo
                       b-mla-doc-pend-aprov.mo-codigo         = mla-doc-pend-aprov.mo-codigo
                       b-mla-doc-pend-aprov.motivo-doc        = mla-doc-pend-aprov.motivo-doc
                       b-mla-doc-pend-aprov.num-faixa         = mla-doc-pend-aprov.num-faixa
                       b-mla-doc-pend-aprov.seq-aprov         = mla-hierarquia-aprov.seq-aprov
                       b-mla-doc-pend-aprov.valor-doc         = mla-doc-pend-aprov.valor-doc
                       b-mla-doc-pend-aprov.prioridade-aprov  = mla-doc-pend-aprov.prioridade-aprov
                       b-mla-doc-pend-aprov.hora-geracao      = string(time,"HH:MM:SS")
                       b-mla-doc-pend-aprov.cod-referencia    = mla-doc-pend-aprov.cod-referencia.
                assign l-gera-proxima = yes.             

                IF mla-usuar-aprov.aprova-auto-aprov AND 
                   mla-hierarquia-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc AND
                   p-limite > mla-doc-pend-aprov.valor-doc  THEN DO:
                
                   {utp/ut-liter.i Aprova‡Æo_Autom tica_-_Usu rio_ * r}
                   ASSIGN c-desc-aprov-auto = RETURN-VALUE.
                   {utp/ut-liter.i _parametrizado_no_AED0103_como_Aprova‡Æo_Autom tica_para_Aprovadores * r}
                   ASSIGN b-mla-doc-pend-aprov.aprov-auto        = YES
                          b-mla-doc-pend-aprov.dt-aprova         = TODAY
                          b-mla-doc-pend-aprov.ind-situacao      = 2
                          b-mla-doc-pend-aprov.narrativa-apr     = c-desc-aprov-auto + STRING(mla-hierarquia-aprov.cod-usuar) + RETURN-VALUE.

                   assign substring(b-mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss"). 
                   
                   ASSIGN l-auto-aprovador     = YES
                          c-usu-auto-aprovador = mla-hierarquia-aprov.cod-usuar
                          c-nar-auto-aprovador = b-mla-doc-pend-aprov.narrativa-apr
                          c-lim-auto-aprovador = p-limite
                          r-doc            = ROWID(b-mla-doc-pend-aprov).
                   /**  Envia e-mail ao usu rio
                   **/
                   find first mla-param-aprov where
                       mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
                       mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                       no-lock no-error.
                   find first bb-mla-usuar-aprov WHERE 
                        bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar
                        no-lock no-error.

                   IF mla-doc-pend-aprov.cod-tip-doc = 7
                   OR mla-doc-pend-aprov.cod-tip-doc = 8 THEN
                       find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc
                            no-lock no-error.
                   ELSE
                       find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans
                            no-lock no-error.

                   if  available mla-param-aprov      and
                       mla-param-aprov.log-email      and
                       available bb-mla-usuar-aprov   and
                       available b-mla-usuar-aprov    and
                       bb-mla-usuar-aprov.envia-email and
                       b-mla-usuar-aprov.recebe-email and 
                       b-mla-usuar-aprov.e-mail <> "" then do:

                       find first moeda
                            where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                       if p-tipo-trans = 2 then do:
                           /**  Rejei‡Æo
                           **/
                           run utp/ut-msgs.p (input "msg", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +
                                                                         mla-hierarquia-aprov.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar).
                       end.
                       else do:
                           /**  Aprova‡Æo
                           **/
                           run utp/ut-msgs.p (input "msg", input 26652, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +
                                                                         mla-hierarquia-aprov.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar).
                       end.
                       assign c-ass-e-mail = return-value.

                       if p-tipo-trans = 2 then do:
                           /**  Rejei‡Æo
                           **/
                           run utp/ut-msgs.p (input "help", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                         gc-cod-usuar-aprov + " - " + bb-mla-usuar-aprov.nome-usuar + "~~" +
                                                                         mla-doc-pend-aprov.narrativa-rej). /** narrativa-apr **/
                       end.
                       else do:
                           /**  Aprova‡Æo
                           **/
                           run utp/ut-msgs.p (input "help", input 26652, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                         mla-doc-pend-aprov.chave-doc + "~~" +
                                                                         moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                         mla-hierarquia-aprov.cod-usuar + " - " + bb-mla-usuar-aprov.nome-usuar + "~~" +
                                                                         mla-doc-pend-aprov.narrativa-apr).
                       end.
                       assign c-men-e-mail = return-value.

                       assign c-men-e-mail = c-men-e-mail + CHR(10).

                       if avail mla-doc-pend-aprov then
                            for first mla-chave-doc-aprov fields( posicao-ini posicao-fim )  where
                                      mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock
                             break by mla-chave-doc-aprov.posicao-ini :
                        
                                assign i-posicao       =  mla-chave-doc-aprov.posicao-fim + 1
                                       i-nr-requisicao = int(substr(mla-doc-pend-aprov.chave-doc,mla-chave-doc-aprov.posicao-ini,
                                                                  ((mla-chave-doc-aprov.posicao-fim -
                                                                    mla-chave-doc-aprov.posicao-ini) + 1))).
                        
                                 for first b-mla-chave-doc-aprov fields( posicao-ini posicao-fim )   where
                                           b-mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  and
                                           b-mla-chave-doc-aprov.posicao-ini = i-posicao                       no-lock
                                  break by b-mla-chave-doc-aprov.posicao-ini :
                                     assign i-posicao   =  b-mla-chave-doc-aprov.posicao-fim + 1
                                            i-sequencia = int(substr(mla-doc-pend-aprov.chave-doc,b-mla-chave-doc-aprov.posicao-ini,
                                                                   ((b-mla-chave-doc-aprov.posicao-fim -
                                                                     b-mla-chave-doc-aprov.posicao-ini) + 1))).
                        
                                 end.
                        
                                 for first b-mla-chave-doc-aprov fields( posicao-ini posicao-fim ) where
                                           b-mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  and
                                           b-mla-chave-doc-aprov.posicao-ini = i-posicao                       no-lock
                                  break by b-mla-chave-doc-aprov.posicao-ini:
                                    assign c-it-codigo = substr(mla-doc-pend-aprov.chave-doc,b-mla-chave-doc-aprov.posicao-ini,
                                                              ((b-mla-chave-doc-aprov.posicao-fim -
                                                                b-mla-chave-doc-aprov.posicao-ini) + 1)).
                        
                                 end.
                            end.

                       if mla-doc-pend-aprov.cod-tip-doc = 2 
                       or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                          for each it-requisicao
                              where it-requisicao.nr-requisicao = i-nr-requisicao
                              no-lock:
                              assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                          end.
                       end.
                       if mla-doc-pend-aprov.cod-tip-doc = 1 
                       or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                          for each it-requisicao
                              where it-requisicao.nr-requisicao = i-nr-requisicao
                              AND   it-requisicao.sequencia     = i-sequencia
                              AND   it-requisicao.it-codigo     = c-it-codigo
                              no-lock:
                              assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                          end.
                       end.

                       if mla-param-aprov.compl-email <> "" then do:
                           assign c-men-e-mail = c-men-e-mail + chr(13) + trim(mla-param-aprov.compl-email).
                       end.

                      if  mla-tipo-doc-aprov.log-html and
                           b-mla-usuar-aprov.log-html then do:
                           /**  HTML
                           **/
                           for each tt-envio2:
                               delete tt-envio2.
                           end.
                           create tt-envio2.
                           assign tt-envio2.versao-integracao = 1
                                  tt-envio2.exchange    = mla-param-aprov.log-exchange
                                  tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                                  tt-envio2.assunto     = c-ass-e-mail
                                  tt-envio2.mensagem    = c-men-e-mail
                                  tt-envio2.importancia = 2
                                  tt-envio2.log-enviada = no
                                  tt-envio2.log-lida    = no
                                  tt-envio2.acomp       = no.
                                  tt-envio2.arq-anexo   = "".
                           if bb-mla-usuar-aprov.e-mail <> "" then
                              assign tt-envio2.remetente = bb-mla-usuar-aprov.e-mail.
                           run utp/utapi019.p persistent set h-utapi019.
                           run pi-execute in h-utapi019 (input table tt-envio2,                   
                                                         output table tt-erros).
                                                         
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio2 no-error.                    
                            {lap/mlaapi001.i02 "aed030a.i (03)" tt-envio2.destino tt-envio2.remetente}                                    
                                                         
                           delete procedure h-utapi019.
                       end.
                       else do:
                           /**  Texto
                           **/
                           for each tt-envio:
                               delete tt-envio.
                           end.
                           create tt-envio.
                           assign tt-envio.versao-integracao = 1
                                  tt-envio.exchange    = mla-param-aprov.log-exchange
                                  tt-envio.destino     = b-mla-usuar-aprov.e-mail
                                  tt-envio.assunto     = c-ass-e-mail
                                  tt-envio.mensagem    = c-men-e-mail
                                  tt-envio.importancia = 2
                                  tt-envio.log-enviada = no
                                  tt-envio.log-lida    = no
                                  tt-envio.acomp       = no.
                                  tt-envio.arq-anexo   = "".
                           if bb-mla-usuar-aprov.e-mail <> "" then
                              assign tt-envio.remetente = bb-mla-usuar-aprov.e-mail.
                           run utp/utapi009.p (input  table tt-envio,
                                               output table tt-erros).
                                               
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio no-error.                    
                            {lap/mlaapi001.i02 "aed030a.i (04)" tt-envio.destino tt-envio.remetente}                                    
                                               
                      END.
                   END.
                END.
                ELSE DO:
                   
                   run pi-envia-e-mail (gc-cod-usuar-aprov,
                                        mla-hierarquia-aprov.cod-usuar,
                                        1).
                   ASSIGN l-auto-aprovador = NO.
                END.

            end.
        end.         
    
    end procedure.
    
    procedure pi-envia-e-mail:
    
        def input parameter p-usuar-origem  as char no-undo.
        def input parameter p-usuar-destino as char no-undo.
        def input parameter p-tipo-envio    as inte no-undo.

        DEF VAR doc-html AS LONGCHAR.
        DEF VAR c-anexo AS CHAR.

        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = p-usuar-origem
            no-lock no-error.
    
        find first b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = p-usuar-destino
            no-lock no-error.
    
        find first mla-param-aprov where
            mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
            no-lock no-error.
    
        find first mla-tipo-doc-aprov where
            mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel and        
            mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
            no-lock no-error.

        if  available mla-param-aprov      and
            mla-param-aprov.log-email      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:
            find first moeda
                where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

            case p-tipo-envio:
                when 1 then do:
                    run utp/ut-msgs.p (input "msg", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                  mla-doc-pend-aprov.chave-doc + "~~" +
                                                                  mla-doc-pend-aprov.cod-usuar-trans).
                    assign c-ass-e-mail = return-value.
                    run utp/ut-msgs.p (input "help", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                  moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                  mla-doc-pend-aprov.cod-usuar-trans).
                    assign c-men-e-mail = return-value.
                end.
                when 2 then do:
                    run utp/ut-msgs.p (input "msg", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                  mla-doc-pend-aprov.chave-doc + "~~" +
                                                                  gc-cod-usuar-aprov).
                    assign c-ass-e-mail = return-value.
                    run utp/ut-msgs.p (input "help", input 26635, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                  moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                  gc-cod-usuar-aprov + "~~" +
                                                                  mla-doc-pend-aprov.narrativa-rej).
                    assign c-men-e-mail = return-value.
                end.
            end.
            if mla-param-aprov.compl-email <> "" then do:
                assign c-men-e-mail = c-men-e-mail + chr(13) + trim(mla-param-aprov.compl-email).
            end.
            
            if  mla-tipo-doc-aprov.log-html and
                b-mla-usuar-aprov.log-html then do:
                /**  HTML
                **/
                for each tt-html:
                    delete tt-html.
                end.
                for each tt-mensagem:
                    delete tt-mensagem.
                end.

                FOR EACH tt-mla-chave:
                    DELETE tt-mla-chave.
                END.

                create tt-mla-chave.
                assign i-chave = 0.

                VALIDATE mla-doc-pend-aprov NO-ERROR.
                VALIDATE b-mla-doc-pend-aprov NO-ERROR.
                
                for each mla-chave-doc-aprov where
                    mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock:
                    assign i-chave = i-chave + 1
                           tt-mla-chave.valor[i-chave] = substring(mla-doc-pend-aprov.chave-doc,
                                                         mla-chave-doc-aprov.posicao-ini,
                                                         ((mla-chave-doc-aprov.posicao-fim -
                                                           mla-chave-doc-aprov.posicao-ini) + 1)).
                end.                        
                IF mla-doc-pend-aprov.cod-tip-doc < 10 THEN
                   RUN VALUE("laphtml/mlahtml00" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p") 
                                             (input  mla-doc-pend-aprov.cod-tip-doc,
                                              input  b-mla-usuar-aprov.cod-usuar,
                                              input  table tt-mla-chave,
                                              OUTPUT doc-html).
                ELSE 
                     RUN VALUE("laphtml/mlahtml0" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p") 
                                                          (input  mla-doc-pend-aprov.cod-tip-doc,
                                                           input  b-mla-usuar-aprov.cod-usuar,
                                                           input  table tt-mla-chave,
                                                           output doc-html).
                ASSIGN c-men-e-mail = "".

                if mla-param-aprov.log-atachado then do:
                   assign c-anexo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                    COPY-LOB FROM doc-html TO FILE c-anexo NO-CONVERT.


/*                     OUTPUT TO value(SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm") APPEND. */
/*                     FOR EACH tt-html :                                                                                                                                                                              */
/*                             PUT UNFORMATTED tt-html.html-doc SKIP.                                                                                                                                                  */
/*                     END.                                                                                                                                                                                            */
/*                     OUTPUT CLOSE.                                                                                                                                                                                   */
                end.
                else do:
/*                     FOR EACH tt-html:                                      */
/*                             CREATE tt-mensagem.                            */
/*                             ASSIGN                                         */
/*                               tt-mensagem.seq-mensagem = tt-html.seq-html  */
/*                               tt-mensagem.mensagem     = tt-html.html-doc. */
/*                     END.                                                   */
                end.
                
                for each tt-envio2:
                    delete tt-envio2.
                end.
                create tt-envio2.
                assign tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = mla-param-aprov.log-exchange
                       tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio2.assunto     = c-ass-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = "HTML".
                       
                if mla-param-aprov.log-atachado then
                    assign tt-envio2.mensagem    = "Foi gerada uma pendˆncia de aprova‡Æo!" + chr(13) +
                                                   "Favor verificar o arquivo atachado."
                           tt-envio2.arq-anexo   = c-anexo.
                else                           
                    assign tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = "".
                       
                if not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                   assign tt-envio2.remetente = mla-usuar-aprov.e-mail.

                run utp/utapi019.p persistent set h-utapi019.
                
                if mla-param-aprov.log-atachado then
                    run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                   output table tt-erros).
                else
                    run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                   INPUT TABLE tt-mensagem,
                                                   output table tt-erros).                                                                           

                /**  Output do erro (e-mail)
                **/               
                find first tt-envio2 no-error.                    
                {lap/mlaapi001.i02 "aed030a.i (05)" tt-envio2.destino tt-envio2.remetente}                                    
    
                delete procedure h-utapi019.
                
                /**  Envia E-mail para os Alternativos
                **/                    
                if mla-param-aprov.log-aprov-altern then do:
                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                        mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                        for each tt-html:
                            delete tt-html.
                        end.
                        for each tt-mensagem:
                            delete tt-mensagem.
                        end.

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                            no-lock no-error.

                         VALIDATE mla-doc-pend-aprov NO-ERROR.
                         VALIDATE b-mla-doc-pend-aprov NO-ERROR.

                         IF mla-doc-pend-aprov.cod-tip-doc < 10 THEN
                             RUN VALUE("laphtml/mlahtml00" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p") 
                                                     (input  mla-doc-pend-aprov.cod-tip-doc,
                                                      input  b-mla-usuar-aprov.cod-usuar,
                                                      input  table tt-mla-chave,
                                                      output doc-html).
                         ELSE 
                             RUN VALUE("laphtml/mlahtml0" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "e.p") 
                                                                  (input  mla-doc-pend-aprov.cod-tip-doc,
                                                                   input  b-mla-usuar-aprov.cod-usuar,
                                                                   input  table tt-mla-chave,
                                                                   output doc-html).
                        ASSIGN c-men-e-mail = "".
                        
                        if mla-param-aprov.log-atachado then do:
                   assign c-anexo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                    COPY-LOB FROM doc-html TO FILE c-anexo NO-CONVERT.

/*                             OUTPUT TO value(SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm") APPEND. */
/*                             FOR EACH tt-html :                                                                                                                                                                              */
/*                                     PUT UNFORMATTED tt-html.html-doc SKIP.                                                                                                                                                  */
/*                             END.                                                                                                                                                                                            */
/*                             OUTPUT CLOSE.                                                                                                                                                                                   */
                        end.
                        else do:
/*                             FOR EACH tt-html:                                   */
/*                                 CREATE tt-mensagem.                             */
/*                                 ASSIGN                                          */
/*                                    tt-mensagem.seq-mensagem = tt-html.seq-html  */
/*                                    tt-mensagem.mensagem     = tt-html.html-doc. */
/*                                                                                 */
/*                             END.                                                */
                        end.
                        
                        for each tt-envio2:
                            delete tt-envio2.
                        end.
                        for each tt-erros:
                            delete tt-erros.
                        end.
                        create tt-envio2.
                        assign tt-envio2.versao-integracao = 1
                               tt-envio2.exchange    = mla-param-aprov.log-exchange
                               tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                               tt-envio2.assunto     = c-ass-e-mail
                               tt-envio2.importancia = 2
                               tt-envio2.log-enviada = no
                               tt-envio2.log-lida    = no
                               tt-envio2.acomp       = no
                               tt-envio2.formato     = "HTML".
                               
                        if mla-param-aprov.log-atachado then
                            assign tt-envio2.mensagem    = "Foi gerada uma pendˆncia de aprova‡Æo!" + chr(13) +
                                                           "Favor verificar o arquivo atachado."
                                   tt-envio2.arq-anexo   = c-anexo.
                        else                           
                            assign tt-envio2.mensagem    = c-men-e-mail
                                   tt-envio2.arq-anexo   = "".
                               
                        if not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                           assign tt-envio2.remetente = mla-usuar-aprov.e-mail.
                           
                        run utp/utapi019.p persistent set h-utapi019.
                        
                        if mla-param-aprov.log-atachado then
                            run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                           output table tt-erros).
                        else
                            run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                           INPUT TABLE tt-mensagem,
                                                           output table tt-erros).                                                                           

                        /**  Output do erro (e-mail)
                        **/               
                        find first tt-envio2 no-error.                    
                        {lap/mlaapi001.i02 "aed030a.i (06)" tt-envio2.destino tt-envio2.remetente}                                    
            
                        delete procedure h-utapi019.
                        
                        if mla-param-aprov.log-atachado then
                            OS-DELETE value(SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm").
                        
                    end.
                end.

                
            end.
            else do:
                /**  Texto
                **/
                for each tt-envio:
                    delete tt-envio.
                end.
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = mla-param-aprov.log-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no.
                       tt-envio.arq-anexo   = "".
                if not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.
                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
                                    
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio no-error.                    
                {lap/mlaapi001.i02 "aed030a.i (07)" tt-envio.destino tt-envio.remetente}                                    
                                    
                /**  Envia E-mail para os Alternativos
                **/                    
                if mla-param-aprov.log-aprov-altern then do:
                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                        mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                            no-lock no-error.
                            
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
                               tt-envio.assunto     = c-ass-e-mail
                               tt-envio.mensagem    = c-men-e-mail
                               tt-envio.importancia = 2
                               tt-envio.log-enviada = no
                               tt-envio.log-lida    = no
                               tt-envio.acomp       = no.
                               tt-envio.arq-anexo   = "".
                        if not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                           assign tt-envio.remetente = mla-usuar-aprov.e-mail.
                        run utp/utapi009.p (input  table tt-envio,
                                            output table tt-erros).

                        /**  Output do erro (e-mail)
                        **/               
                        find first tt-envio no-error.                    
                        {lap/mlaapi001.i02 "aed030a.i (08)" tt-envio.destino tt-envio.remetente}                                    
                            
                    end.
                end.                                    
                                    
                                    
            end.
        end.
    
    end procedure.
