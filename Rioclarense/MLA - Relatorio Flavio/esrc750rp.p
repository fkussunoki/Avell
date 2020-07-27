/* include de controle de versão */
{include/i-prgvrs.i esrc750 1.00.00.003}
/* definiŒão das temp-tables para recebimento de par?metros */



    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)"
        field modelo-rtf       as char format "x(35)"
        field l-habilitaRtf    as LOG
        FIELD c-cenario        AS date
        FIELD c-cenario-2      AS date.
.
DEFINE VAR m-linha AS INTEGER.


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



def temp-table tt-raw-digita
    	field raw-digita	as raw.
/* recebimento de par?metros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.


DEF VAR i-tot AS INTEGER.

ASSIGN m-linha = 1.


DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}
    

    RUN utp/ut-acomp.p PERSISTENT SET h-prog.
    Run pi-inicializar in h-prog (input "gerando").



    FIND FIRST tt-param NO-ERROR.
    FOR EACH pedido-compr NO-LOCK WHERE pedido-compr.data-pedido >= tt-param.c-cenario
                                  AND   pedido-compr.data-pedido <= tt-param.c-cenario-2
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




       chExcel:sheetsinNewWorkbook = 1.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="esrc750". /* Nome que ser¿ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:n1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:n1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:n1"):SetValue("MLA").
       chWorkSheet:Range("A1:n1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:n1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat÷rio */
           chworksheet:range("A2:y2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("Codigo Item").
           chworksheet:range("B" + STRING(m-linha)):SetValue("Descricao").
           chworksheet:range("C" + STRING(m-linha)):SetValue("Estabelecimento").
           chworksheet:range("d" + STRING(m-linha)):SetValue("Pedido").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Emitente").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Razao Social").
           chworksheet:range("g" + STRING(m-linha)):SetValue("Data Aprovacao").
           chworksheet:range("h" + STRING(m-linha)):SetValue("Vcto. Parcela").
           chworksheet:range("i" + STRING(m-linha)):SetValue("Vlr. Parcela").
           chworksheet:range("j" + STRING(m-linha)):SetValue("Dt. NF Entrada.").
           chworksheet:range("k" + STRING(m-linha)):SetValue("U.Neg").
           chworksheet:range("l" + STRING(m-linha)):SetValue("Narrativa").
           chworksheet:range("m" + STRING(m-linha)):SetValue("Usuario Docto").
           chworksheet:range("n" + STRING(m-linha)):SetValue("Usuario Aprovacao").
		   

        m-linha = m-linha + 1.
       
    RUN utp/ut-acomp.p PERSISTENT SET h-prog.
run pi-inicializar in h-prog(input "Montando Excel").    


        FOR EACH tt-mla WHERE tt-mla.ttv-vlr <> 0:

             run pi-acompanhar in h-prog (INPUT "Pedido " + string(tt-mla.ttv-pedido)).
            /* Lista os dados da tabela nas colunas */
                    chworksheet:range("A" + STRING(m-linha)):SetValue(TT-MLA.TTV-IT-CODIGO).  
                    chworksheet:range("B" + STRING(m-linha)):SetValue(TT-MLA.TTV-DESCRICAO).  
                    chworksheet:range("C" + STRING(m-linha)):SetValue(TT-MLA.TTV-ESTAB).      
                    chworksheet:range("d" + string(m-linha)):SetValue(TT-MLA.TTV-PEDIDO).     
                    chworksheet:range("e" + string(m-linha)):SetValue(TT-MLA.TTV-EMITENTE).   
                    chworksheet:range("f" + string(m-linha)):SetValue(tt-mla.ttv-razao).      
                    chworksheet:range("g" + string(m-linha)):SetValue(tt-mla.ttv-aprovacao).  
                    chworksheet:range("h" + string(m-linha)):SetValue(tt-mla.ttv-prazo).      
                    chworksheet:range("i" + string(m-linha)):SetValue(tt-mla.ttv-vlr).        
                    chworksheet:range("j" + string(m-linha)):SetValue(tt-mla.ttv-entrada).    
                    chworksheet:range("k" + string(m-linha)):SetValue(tt-mla.ttv-un).         
                    chworksheet:range("l" + string(m-linha)):SetValue(tt-mla.ttv-narrativa).  
                    chworksheet:range("m" + string(m-linha)):SetValue(tt-mla.ttv-usuario).    
                    chworksheet:range("n" + string(m-linha)):SetValue(tt-mla.ttv-usuar-aprov).
                
                    ASSIGN m-linha = m-linha + 1.

     END.
run pi-finalizar in h-prog.
                
	
    chExcel:Visible = true.

    
	
