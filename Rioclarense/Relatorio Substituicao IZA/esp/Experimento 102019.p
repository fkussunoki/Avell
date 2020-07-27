DEFINE TEMP-TABLE TT-ENTRADAS
    FIELD TTV-CFOP              AS CHAR FORMAT 'X(6)'
    FIELD TTV-UF-ORIGEM         AS CHAR FORMAT 'X(2)'
    FIELD TTV-COD-ESTAB         AS CHAR FORMAT 'X(5)'
    FIELD TTV-NOME-ESTAB        AS CHAR FORMAT 'X(40)'
    FIELD TTV-CDN-FORNEC        AS INTEGER FORMAT '>>>,>>>,>>9'
    FIELD TTV-NOME-FOREC        AS CHAR FORMAT 'X(40)'
    FIELD TTV-UF-DESTINO        AS CHAR FORMAT 'X(2)'
    FIELD TTV-CONTRIBUINTE      AS LOGICAL
    FIELD TTV-IT-CODIGO         AS CHAR FORMAT 'X(8)'
    FIELD TTV-DESCRICAO         AS CHAR FORMAT 'X(40)'
    FIELD TTV-VLR-ORIGINAL      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-BASE-ICMS         AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-ALIQUOTA          AS DEC FORMAT ">>>.99"
    FIELD TTV-BASE-ICMS-ST      AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS-ST       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-QTDE              AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-NR-NF             AS CHAR FORMAT '9999999'
    FIELD TTV-DT-EMISSAO        AS DATE
    FIELD TTV-ORIGEM            AS CHAR
    FIELD TTV-LOTE              AS CHARACTER.
/*     FIELD TTV-CDN-CLIENTE       AS INTEGER FORMAT '>>>,>>>,>>9'              */
/*     FIELD TTV-NF-SAIDA          AS CHAR FORMAT '9999999'                     */
/*     FIELD TTV-SERIE             AS CHAR                                      */
/*     FIELD TTV-VLR-ICMS-ST-SAI   AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"  */
/*     FIELD TTV-QTDE-SAI          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99". */



DEFINE TEMP-TABLE TT-SAIDAS
    FIELD TTV-CFOP                  AS CHAR FORMAT 'X(6)'
    FIELD TTV-UF-ORIGEM             AS CHAR FORMAT 'X(2)'
    FIELD TTV-COD-ESTAB             AS CHAR FORMAT 'X(5)'
    FIELD TTV-NOME-ESTAB            AS CHAR FORMAT 'X(40)'
    FIELD TTV-CDN-CLIENTE           AS INTEGER FORMAT '>>>,>>>,>>9'
    FIELD TTV-NOME-CLIENTE          AS CHAR FORMAT 'X(40)'
    FIELD TTV-UF-DESTINO            AS CHAR FORMAT 'X(2)'
    FIELD TTV-CONTRIBUINTE          AS LOGICAL
    FIELD TTV-IT-CODIGO             AS CHAR FORMAT 'X(8)'
    FIELD TTV-DESCRICAO             AS CHAR FORMAT 'X(40)'
    FIELD TTV-VLR-ORIGINAL          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-BASE-ICMS             AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS              AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-ALIQUOTA              AS DEC FORMAT ">>>.99"
    FIELD TTV-BASE-ICMS-ST          AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-VLR-ICMS-ST           AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-QTDE                  AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99" 
    FIELD TTV-NR-NF                 AS CHAR FORMAT '9999999'
    FIELD TTV-DT-EMISSAO            AS DATE
    FIELD TTV-ORIGEM                AS CHAR
    FIELD TTV-NATUR-OPER            AS CHARACTER
    FIELD ttv-veterinaria           AS LOGICAL
    FIELD ttv-distrituidor          AS LOGICAL
    FIELD ttv-portaria-cat          AS LOGICAL
    FIELD ttv-total-icms-st-entrada AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-total-icms-entrada    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD ttv-nf-origem             AS CHAR FORMAT ' 9999999'
    FIELD ttv-serie-origem          AS char 
    FIELD ttv-emitente-origem       AS char
    FIELD ttv-nat-oper-origem       AS char
    FIELD ttv-dt-origem             AS date
    FIELD ttv-lote                  AS char.

define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    FIELD cod-estab-ini        AS char
    FIELD cod-estab-fim        AS char
    FIELD cod-emitente-ini     AS INTEGER 
    FIELD cod-emitente-fim     AS INTEGER
    FIELD it-codigo-ini        AS CHAR
    FIELD it-codigo-fim        AS char
    FIELD natur-oper-ini       AS CHAR
    FIELD natur-oper-fim       AS char
    FIELD dt-emiss-ini         AS date
    FIELD dt-emiss-fim         AS date.


DEFINE TEMP-TABLE tt-trat
    FIELD ttv-it-codigo     AS char.


DEFINE TEMP-TABLE tt-natur
    FIELD ttv-nat-oper AS CHAR.

CREATE tt-param.
ASSIGN tt-param.cod-estab-ini       = ""
       tt-param.cod-estab-fim       = "zzzzz"
       tt-param.cod-emitente-ini    = 0
       tt-param.cod-emitente-fim    = 99999999
       tt-param.it-codigo-ini       = ""
       tt-param.it-codigo-fim        = "zzzzzzzzzzz"
       tt-param.natur-oper-ini      = ""
       tt-param.natur-oper-fim      = "zzzzzzzzz"
       tt-param.dt-emiss-ini        = 03/01/2005
       tt-param.dt-emiss-fim        = 03/31/2019.


DEF VAR h-prog AS HANDLE.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Gerando").
RUN pi-entrada.
RUN pi-finalizar IN h-prog.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Gerando").

RUN pi-tratamento.
RUN pi-finalizar IN h-prog.



RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT "Gerando").

RUN pi-saidas.
RUN pi-finalizar IN h-prog.


RUN pi-resumo.



PROCEDURE pi-entrada:



    FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.vl-subs[1] > 0:


        FIND FIRST docum-est NO-LOCK WHERE docum-est.serie-docto  = item-doc-est.serie-docto
                                     AND   docum-est.nro-docto    = item-doc-est.nro-docto
                                     AND   docum-est.cod-emitente = item-doc-est.cod-emitente
                                     NO-ERROR.

        FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.

        FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.

        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

        RUN pi-acompanhar IN h-prog (INPUT "It-codigo " + item-doc-est.it-codigo + " Emitente " + string(item-doc-est.cod-emitente) + " NF " + item-doc-est.nro-docto + " Serie " + item-doc-est.serie-docto).

           CREATE tt-entradas.
           ASSIGN tt-entradas.TTV-CFOP                     = item-doc-est.nat-operacao
                  tt-entradas.TTV-UF-ORIGEM                = emitente.estado
                  tt-entradas.TTV-COD-ESTAB                = docum-est.cod-estabel
                  tt-entradas.TTV-NOME-ESTAB               = estabelec.nome 
                  tt-entradas.TTV-CDN-FORNEC               = docum-est.cod-emitente
                  tt-entradas.TTV-NOME-FOREC               = emitente.nome-emit
                  tt-entradas.TTV-UF-DESTINO               = estabelec.estado
                  tt-entradas.TTV-CONTRIBUINTE             = emitente.contrib-icms
                  tt-entradas.TTV-IT-CODIGO                = item-doc-est.it-codigo
                  tt-entradas.TTV-DESCRICAO                = ITEM.descricao-1
                  tt-entradas.TTV-VLR-ORIGINAL             = (item-doc-est.preco-unit[1] * item-doc-est.quantidade)     
                  tt-entradas.TTV-BASE-ICMS                = item-doc-est.base-icm[1]                                   
                  tt-entradas.TTV-VLR-ICMS                 = item-doc-est.valor-icm[1]                                  
                  tt-entradas.TTV-ALIQUOTA                 = item-doc-est.aliquota-icm                                  
                  tt-entradas.TTV-BASE-ICMS-ST             = item-doc-est.base-subs[1]                                  
                  tt-entradas.TTV-VLR-ICMS-ST              = item-doc-est.vl-subs[1]                                    
                  tt-entradas.TTV-QTDE                     = item-doc-est.quantidade                                    
                  tt-entradas.TTV-NR-NF                    = item-doc-est.nro-docto                                     
                  tt-entradas.TTV-DT-EMISSAO               = docum-est.dt-emissao
                  tt-entradas.TTV-ORIGEM                   = "Recebimento"
                  tt-entradas.TTV-LOTE                     = item-doc-est.lote.
                                   
    END.
END.

/*                                                          */
/* OUTPUT TO c:\desenv\tt-entradas.txt.                     */
/*                                                          */
/* FOR EACH tt-entradas:                                    */
/*                                                          */
/*     PUT UNFORMATTED tt-entradas.TTV-CFOP             ";" */
/*                     tt-entradas.TTV-UF-ORIGEM        ";" */
/*                     tt-entradas.TTV-COD-ESTAB        ";" */
/*                     tt-entradas.TTV-NOME-ESTAB       ";" */
/*                     tt-entradas.TTV-CDN-FORNEC       ";" */
/*                     tt-entradas.TTV-NOME-FOREC       ";" */
/*                     tt-entradas.TTV-UF-DESTINO       ";" */
/*                     tt-entradas.TTV-CONTRIBUINTE     ";" */
/*                     tt-entradas.TTV-IT-CODIGO        ";" */
/*                     tt-entradas.TTV-DESCRICAO        ";" */
/*                     tt-entradas.TTV-VLR-ORIGINAL     ";" */
/*                     tt-entradas.TTV-BASE-ICMS        ";" */
/*                     tt-entradas.TTV-VLR-ICMS         ";" */
/*                     tt-entradas.TTV-ALIQUOTA         ";" */
/*                     tt-entradas.TTV-BASE-ICMS-ST     ";" */
/*                     tt-entradas.TTV-VLR-ICMS-ST      ";" */
/*                     tt-entradas.TTV-QTDE             ";" */
/*                     tt-entradas.TTV-NR-NF            ";" */
/*                     tt-entradas.TTV-DT-EMISSAO       ";" */
/*                     tt-entradas.TTV-ORIGEM          ";"  */
/*                     tt-entradas.TTV-LOTE                 */
/*         SKIP.                                            */
/*                                                          */
/*                                                          */
/* END.                                                     */
/* OUTPUT CLOSE.                                            */
/*                                                          */
PROCEDURE pi-saidas:


    FIND FIRST tt-param NO-ERROR.


        FIND FIRST tt-trat NO-ERROR.


        FOR EACH natur-oper fields(natur-oper.nat-operacao natur-oper.especie-doc natur-oper.tipo) NO-LOCK WHERE natur-oper.especie-doc = "nfs"
                                    AND   natur-oper.tipo = 2,
                    
                EACH nota-fiscal (FIELDS nota-fiscal.cod-estabel nota-fiscal.dt-emis-nota nota-fiscal.ind-sit-nota nota-fiscal.dt-cancela nota-fiscal.nat-operacao
                                         nota-fiscal.serie nota-fiscal.nr-nota-fis nota-fiscal.dt-emis-nota) 
                                NO-LOCK WHERE nota-fiscal.cod-estabel >= "101"
                                        AND   nota-fiscal.cod-estabel <= "103"
                                        AND   nota-fiscal.dt-emis-nota >= 09/01/2019
                                        AND   nota-fiscal.dt-emis-nota <= 09/30/2019
                                        AND   nota-fiscal.ind-sit-nota <> 4
                                        AND   nota-fiscal.dt-cancela    = ?
                                        AND   nota-fiscal.nat-operacao = natur-oper.nat-operacao,
                                        

                 EACH it-nota-fisc FIELDS( it-nota-fisc.cod-estabel it-nota-fisc.serie it-nota-fisc.nr-nota-fis  
                                       it-nota-fisc.it-codigo it-nota-fisc.cd-emitente it-nota-fisc.vl-tot-item     
                                       it-nota-fisc.vl-bicms-it it-nota-fisc.vl-icms-it                             
                                       it-nota-fisc.aliquota-icm it-nota-fisc.vl-bsubs-it it-nota-fisc.vl-icmsub-it 
                                       it-nota-fisc.qt-faturada[1] it-nota-fisc.nat-operacao it-nota-fisc.dt-cancela it-nota-fisc.dt-emis-nota
                                              it-nota-fisc.ind-sit-nota)                       
                                       USE-INDEX ch-item-nota  NO-LOCK WHERE lookup(trim(it-nota-fisc.it-codigo), tt-trat.ttv-it-codigo) <> 0
                                                                       AND   it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                                                       AND   it-nota-fisc.serie       = nota-fiscal.serie
                                                                       AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                    ,
                    EACH fat-ser-lote NO-LOCK WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                                              AND   fat-ser-lote.serie       = it-nota-fisc.serie
                                              AND   fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                             :
        
                                              
                
        
        /*         FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.dt-trans         >= tt-param.dt-emiss-ini     */
        /*                                      AND   movto-estoq.dt-trans         <= tt-param.dt-emiss-fim     */
        /*                                      AND   movto-estoq.cod-emitente     >= tt-param.cod-emitente-ini */
        /*                                      AND   movto-estoq.cod-emitente     <= tt-param.cod-emitente-fim */
        /*                                      AND   movto-estoq.it-codigo        = tt-entradas.ttv-it-codigo  */
        /*                                      AND   movto-estoq.lote             = tt-entradas.ttv-lote       */
        /*                                      AND   movto-estoq.esp-docto        = 22,                        */
        /*             EACH it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = movto-estoq.cod-estabel       */
        /*                                       AND   it-nota-fisc.serie       = movto-estoq.serie-docto       */
        /*                                       AND   it-nota-fisc.nr-nota-fis = movto-estoq.nro-docto         */
        /*                                       AND   it-nota-fisc.cd-emitente = movto-estoq.cod-emitente      */
        /*                                       AND   it-nota-fisc.it-codigo   = movto-estoq.it-codigo         */
        /*                                       :                                                              */
        
        
                    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = it-nota-fisc.cd-emitente NO-ERROR.   
        
                    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = it-nota-fisc.cod-estabel NO-ERROR.
        
                    RUN pi-acompanhar IN h-prog(INPUT "Item " + movto-estoq.it-codigo + " Est " + movto-estoq.cod-estabel + " Dt " + string(movto-estoq.dt-trans)).
        
                    CREATE tt-saidas.
                    ASSIGN tt-saidas.TTV-CFOP                    = it-nota-fisc.nat-operacao
                           tt-saidas.TTV-UF-ORIGEM               = estabelec.estado
                           tt-saidas.TTV-COD-ESTAB               = estabelec.cod-estabel
                           tt-saidas.TTV-NOME-ESTAB              = estabelec.nome
                           tt-saidas.TTV-CDN-CLIENTE             = it-nota-fisc.cd-emitente
                           tt-saidas.TTV-NOME-CLIENTE            = emitente.nome-emit
                           tt-saidas.TTV-UF-DESTINO              = emitente.estado
                           tt-saidas.TTV-CONTRIBUINTE            = emitente.contrib-icms
                           tt-saidas.TTV-IT-CODIGO               = it-nota-fisc.it-codigo
                           tt-saidas.TTV-DESCRICAO               = ITEM.descricao-1
                           tt-saidas.TTV-VLR-ORIGINAL            = it-nota-fisc.vl-tot-item        
                           tt-saidas.TTV-BASE-ICMS               = it-nota-fisc.vl-bicms-it        
                           tt-saidas.TTV-VLR-ICMS                = it-nota-fisc.vl-icms-it         
                           tt-saidas.TTV-ALIQUOTA                = it-nota-fisc.aliquota-icm       
                           tt-saidas.TTV-BASE-ICMS-ST            = it-nota-fisc.vl-bsubs-it        
                           tt-saidas.TTV-VLR-ICMS-ST             = it-nota-fisc.vl-icmsub-it       
                           tt-saidas.TTV-QTDE                    = it-nota-fisc.qt-faturada[1]     
                           tt-saidas.TTV-NR-NF                   = it-nota-fisc.nr-nota-fis        
                           tt-saidas.TTV-DT-EMISSAO              = it-nota-fisc.dt-emis-nota   
                           tt-saidas.TTV-ORIGEM                  = "Faturamento"                   
                           tt-saidas.TTV-NATUR-OPER              = it-nota-fisc.nat-operacao  
                           tt-saidas.ttv-lote                    = fat-ser-lote.nr-serlote
                           tt-saidas.ttv-veterinaria             = no
                           tt-saidas.ttv-distrituidor            = NO
                           tt-saidas.ttv-portaria-cat            = NO
        .
                
                END.




END PROCEDUre.


PROCEDURE pi-resumo:




OUTPUT TO c:\desenv\tt-entradas.txt.

FOR EACH tt-entradas:

    PUT UNFORMATTED tt-entradas.TTV-CFOP             ";"
                    tt-entradas.TTV-UF-ORIGEM        ";"
                    tt-entradas.TTV-COD-ESTAB        ";"
                    tt-entradas.TTV-NOME-ESTAB       ";"
                    tt-entradas.TTV-CDN-FORNEC       ";"
                    tt-entradas.TTV-NOME-FOREC       ";"
                    tt-entradas.TTV-UF-DESTINO       ";"
                    tt-entradas.TTV-CONTRIBUINTE     ";"
                    tt-entradas.TTV-IT-CODIGO        ";"
                    tt-entradas.TTV-DESCRICAO        ";"
                    tt-entradas.TTV-VLR-ORIGINAL     ";"
                    tt-entradas.TTV-BASE-ICMS        ";"
                    tt-entradas.TTV-VLR-ICMS         ";"
                    tt-entradas.TTV-ALIQUOTA         ";"
                    tt-entradas.TTV-BASE-ICMS-ST     ";"
                    tt-entradas.TTV-VLR-ICMS-ST      ";"
                    tt-entradas.TTV-QTDE             ";"
                    tt-entradas.TTV-NR-NF            ";"
                    tt-entradas.TTV-DT-EMISSAO       ";"
                    tt-entradas.TTV-ORIGEM          ";"
                    tt-entradas.TTV-LOTE
        SKIP.


END.
OUTPUT CLOSE.


OUTPUT TO c:\desenv\tt-saidas.txt.

FOR EACH tt-saidas:

PUT unformatted tt-saidas.TTV-CFOP                   ";"
                tt-saidas.TTV-UF-ORIGEM              ";"
                tt-saidas.TTV-COD-ESTAB              ";"
                tt-saidas.TTV-NOME-ESTAB             ";"
                tt-saidas.TTV-CDN-CLIENTE            ";"
                tt-saidas.TTV-NOME-CLIENTE           ";"
                tt-saidas.TTV-UF-DESTINO             ";"
                tt-saidas.TTV-CONTRIBUINTE           ";"
                tt-saidas.TTV-IT-CODIGO              ";"
                tt-saidas.TTV-DESCRICAO              ";"
                tt-saidas.TTV-VLR-ORIGINAL           ";"
                tt-saidas.TTV-BASE-ICMS              ";"
                tt-saidas.TTV-VLR-ICMS               ";"
                tt-saidas.TTV-ALIQUOTA               ";"
                tt-saidas.TTV-BASE-ICMS-ST           ";"
                tt-saidas.TTV-VLR-ICMS-ST            ";"
                tt-saidas.TTV-QTDE                   ";"
                tt-saidas.TTV-NR-NF                  ";"
                tt-saidas.TTV-DT-EMISSAO             ";"
                tt-saidas.TTV-ORIGEM                 ";"
                tt-saidas.TTV-NATUR-OPER             ";"
                tt-saidas.ttv-veterinaria            ";"
                tt-saidas.ttv-distrituidor           ";"
                tt-saidas.ttv-portaria-cat           
    SKIP.

END.
END PROCEDURE.

PROCEdure pi-tratamento:
         CREATE tt-trat.
        FOR EACH tt-entradas BREAK BY tt-entradas.ttv-it-codigo:
           IF FIRST-OF(tt-entradas.ttv-it-codigo) THEN DO:
               
            
               ASSIGN tt-trat.ttv-it-codigo = tt-trat.ttv-it-codigo + "," + tt-entradas.ttv-it-codigo.

           END.
        END.




END PROCEDURE.
