DEF VAR c-prazo AS DATE EXTENT 12.
DEF VAR c-valor AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" EXTENT 12.
DEF VAR c-unid AS char FORMAT "x(120)".


DEFINE TEMP-TABLE TT-MLA
    FIELD TTV-IT-CODIGO AS CHAR
    FIELD TTV-DESCRICAO AS CHAR
    FIELD TTV-ESTAB     AS CHAR
    FIELD TTV-PEDIDO    AS INTEGER
    FIELD TTV-EMITENTE  AS INTEGER
    FIELD TTV-RAZAO     AS CHAR
    FIELD TTV-APROVACAO AS DATE
    FIELD TTV-VLR       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>>,>>>.99"
    FIELD TTV-PRAZO     AS DATE
    FIELD ttv-entrada   AS date
    FIELD ttv-un        AS char
    FIELD ttv-narrativa AS char FORMAT "x(300)"
    FIELD ttv-usuario   AS CHARACTER
    FIELD ttv-usuar-aprov AS char.
    

def var h-prog as handle.

run utp/ut-acomp.p persistent set h-prog.

Run pi-inicializar in h-prog (input "gerando").




FOR EACH pedido-compr NO-LOCK WHERE pedido-compr.data-pedido >= 01/01/2019
                              AND   pedido-compr.data-pedido <= 05/16/2019
                              
:

run pi-acompanhar in h-prog (input "Pedido " +  string(pedido-compr.num-pedido)).
    FIND last mla-doc-pend-aprov  use-index transacao NO-LOCK WHERE mla-doc-pend-aprov.chave-doc = string(pedido-compr.num-pedido)
                                                              AND   mla-doc-pend-aprov.cod-tip-doc = 8
                                                              AND   mla-doc-pend-aprov.ind-situacao = 2 NO-ERROR.


    IF AVAIL mla-doc-pend-aprov THEN DO:
        
        FOR EACH ordem-compra NO-LOCK WHERE ordem-compra.num-pedido   = pedido-compr.num-pedido
                                      AND   ordem-compra.cod-emitente = pedido-compr.cod-emitente
                                      :


            assign c-unid = "".


            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

            FIND FIRST cotacao-item NO-LOCK WHERE cotacao-item.it-codigo = ordem-compra.it-codigo
                                            AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                            AND   cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

            IF AVAIL cotacao-item THEN DO:
                FIND FIRST unid-neg-ordem NO-LOCK WHERE unid-neg-ordem.numero-ordem = cotacao-item.numero-ordem NO-ERROR.

                IF AVAIL unid-neg-ordem THEN DO:
                
                    FOR EACH unid-neg-ordem NO-LOCK WHERE unid-neg-ordem.numero-ordem = cotacao-item.numero-ordem:

                        ASSIGN c-unid = c-unid + "-> Rateio U.N: " + unid-neg-ordem.cod_unid_negoc + " Vlr: " + string((unid-neg-ordem.perc-unid-neg * cotacao-item.preco-fornec) / 100).

                    END.
                END.
               FIND FIRST unid-neg-ordem NO-LOCK WHERE unid-neg-ordem.numero-ordem = cotacao-item.numero-ordem NO-ERROR.


                if not avail unid-neg-ordem then do:

                    ASSIGN c-unid =  "-> Unica U.N: " + ordem-compra.cod-unid-negoc + " Vlr: " + string((cotacao-item.preco-fornec * ordem-compra.qt-solic)).
                end.
                
            




            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = cotacao-item.it-codigo NO-ERROR.

            IF pedido-compr.cod-cond-pag = 0 THEN DO:
                

                FIND FIRST cond-especif NO-LOCK WHERE cond-especif.num-pedido = pedido-compr.num-pedido
                                                NO-ERROR.

                FIND FIRST item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = ordem-compra.cod-emitente
                                                AND   item-doc-est.num-pedido   = ordem-compra.num-pedido
                                                AND   item-doc-est.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

                IF AVAIL item-doc-est THEN DO:
                    
                    FIND FIRST docum-est NO-LOCK WHERE docum-est.serie-docto = item-doc-est.serie-docto
                                                 AND   docum-est.nro-docto   = item-doc-est.nro-docto
                                                 AND   docum-est.cod-emitente = item-doc-est.cod-emitente
                                                 NO-ERROR.
                END.




                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo     = cond-especif.data-pagto[1]
                       tt-mla.ttv-vlr       = (cond-especif.perc-pagto[1] * cotacao-item.preco-fornec) / 100
                       tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                       tt-mla.ttv-un        = c-unid                       tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                       tt-mla.ttv-usuario   = ordem-compra.usuario
                       tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

                

                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo    = cond-especif.data-pagto[2]
                       tt-mla.ttv-vlr       = (cond-especif.perc-pagto[2] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo   = cond-especif.data-pagto[3]
                       tt-mla.ttv-vlr      = (cond-especif.perc-pagto[3] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo    = cond-especif.data-pagto[4]
                       tt-mla.ttv-vlr       = (cond-especif.perc-pagto[4] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo   = cond-especif.data-pagto[5]
                       tt-mla.ttv-vlr      = (cond-especif.perc-pagto[5] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo  = cond-especif.data-pagto[6]
                       tt-mla.ttv-vlr     = (cond-especif.perc-pagto[6] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo    = cond-especif.data-pagto[7]
                       tt-mla.ttv-vlr       = (cond-especif.perc-pagto[7] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo    = cond-especif.data-pagto[8]
                       tt-mla.ttv-vlr       = (cond-especif.perc-pagto[8] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo   = cond-especif.data-pagto[9]
                       tt-mla.ttv-vlr      = (cond-especif.perc-pagto[9] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo  = cond-especif.data-pagto[10]
                       tt-mla.ttv-vlr     = (cond-especif.perc-pagto[10] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo  = cond-especif.data-pagto[11]
                       tt-mla.ttv-vlr     = (cond-especif.perc-pagto[11] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.



                CREATE TT-MLA.
                ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                       TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                       TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                       TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                       TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                       tt-mla.ttv-razao     = emitente.nome-emit 
                       tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                       tt-mla.ttv-prazo   = cond-especif.data-pagto[12]
                       tt-mla.ttv-vlr      = (cond-especif.perc-pagto[12] * cotacao-item.preco-fornec) / 100
                    tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                        tt-mla.ttv-un        = c-unid                        tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                        tt-mla.ttv-usuario   = ordem-compra.usuario
                        tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.


                
                
                
                
                
                
                
                
                
                
                
                
            END.

            IF pedido-compr.cod-cond-pag <> 0 THEN DO:
                
            FIND FIRST cond-pagto NO-LOCK WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.

                 
            
            
            
            
            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo    = cond-pagto.prazos[1] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[1] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo   = cond-pagto.prazos[2] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr      = (cond-pagto.per-pg-dup[2] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo   = cond-pagto.prazos[3] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr      = (cond-pagto.per-pg-dup[3] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo    = cond-pagto.prazos[4] + pedido-compr.data-pedido                                       
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[4] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo    = cond-pagto.prazos[5] + pedido-compr.data-pedido                                       
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[5] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo    = cond-pagto.prazos[6] + pedido-compr.data-pedido                                       
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[6] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo    = cond-pagto.prazos[7] + pedido-compr.data-pedido                                       
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[7] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo  = cond-pagto.prazos[8] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr     = (cond-pagto.per-pg-dup[8] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo  = cond-pagto.prazos[9] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr     = (cond-pagto.per-pg-dup[9] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo     = cond-pagto.prazos[10] + pedido-compr.data-pedido                                       
                   tt-mla.ttv-vlr     = (cond-pagto.per-pg-dup[10] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo  = cond-pagto.prazos[11] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr     = (cond-pagto.per-pg-dup[11] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100
                tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                    tt-mla.ttv-un        = c-unid                    tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                    tt-mla.ttv-usuario   = ordem-compra.usuario
                    tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

            
            CREATE TT-MLA.
            ASSIGN TT-MLA.TTV-IT-CODIGO = cotacao-item.it-codigo
                   TT-MLA.TTV-DESCRICAO = ITEM.descricao-1  
                   TT-MLA.TTV-ESTAB     = pedido-compr.cod-estabel
                   TT-MLA.TTV-PEDIDO    = pedido-compr.num-pedido
                   TT-MLA.TTV-EMITENTE  = pedido-compr.cod-emitente
                   tt-mla.ttv-razao     = emitente.nome-emit 
                   tt-mla.ttv-aprovacao = mla-doc-pend-aprov.dt-aprova
                   tt-mla.ttv-prazo     = cond-pagto.prazos[12] + pedido-compr.data-pedido                                        
                   tt-mla.ttv-vlr       = (cond-pagto.per-pg-dup[12] * cotacao-item.preco-fornec * ordem-compra.qt-solic ) / 100 
                   tt-mla.ttv-entrada   = IF avail docum-est THEN docum-est.dt-emissao ELSE ?
                   tt-mla.ttv-un        = c-unid                   tt-mla.ttv-narrativa = replace(ordem-compra.narrativa, CHR(10), " ")
                       tt-mla.ttv-usuario   = ordem-compra.usuario
                       tt-mla.ttv-usuar-aprov = mla-doc-pend-aprov.cod-usuar.

                END.
                                        
            END.
        END.
    END.
END.
run pi-finalizar in h-prog.

OUTPUT TO c:\desenv\mla.txt.
        FOR EACH tt-mla WHERE tt-mla.ttv-vlr <> 0:
            PUT UNFORMATTED TT-MLA.TTV-IT-CODIGO   "|"
                            TT-MLA.TTV-DESCRICAO   "|"
                            TT-MLA.TTV-ESTAB       "|"
                            TT-MLA.TTV-PEDIDO      "|"
                            TT-MLA.TTV-EMITENTE    "|"
                            tt-mla.ttv-razao       "|"
                            tt-mla.ttv-aprovacao   "|"
                            tt-mla.ttv-prazo       "|"
                            tt-mla.ttv-vlr         "|"
                            tt-mla.ttv-entrada     "|"
                            tt-mla.ttv-un          "|"
                            tt-mla.ttv-narrativa   "|"
                            tt-mla.ttv-usuario     "|"
                            tt-mla.ttv-usuar-aprov
                            SKIP.



        END.




