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
    FIELD cod-estab-ini    AS char
    FIELD cod-estab-fim    AS char
    FIELD cod-emitente-ini AS INTEGER 
    FIELD cod-emitente-fim AS INTEGER
    FIELD it-codigo-ini      AS CHAR
    FIELD it-codigo-fim      AS char
    FIELD natur-oper-ini    AS CHAR
    FIELD natur-oper-fim    AS char.


CREATE tt-param.
ASSIGN tt-param.cod-estab-ini = ""
       tt-param.cod-estab-fim = "zzzzz"
       tt-param.cod-emitente-ini = 0
       tt-param.cod-emitente-fim = 99999999999
       tt-param.it-codigo-ini    = ""
       tt-param.it-codigo-fim    = "zzzzzzzzzzzzz"
       tt-param.natur-oper-ini   = ""
       tt-param.natur-oper-fim   = "zzzzzzzzzzzzzzz".


DEFINE VAR h-prog AS HANDLE.

DEFINE TEMP-TABLE tt-entradas
    FIELD ttv_cfop         AS char
    FIELD ttv_uf           AS char
    FIELD ttv_emitente     AS INTEGER
    FIELD ttv_it_codigo    AS char
    FIELD ttv_lote         AS char
    FIELD ttv_vlr_ctbl     AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_aliquota     AS DEC FORMAT "->>>.99"
    FIELD ttv_base_icms    AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_vlr_icms     AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_base_icms_st AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_vlr_icms_st  AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_vlr_ipi      AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    FIELD ttv_dt_trans     AS date
    FIELD ttv_estab        AS char
    FIELD ttv_documento    AS char
    FIELD ttv_quantidade   AS DEC FORMAT "->>>,>>>,>>>,>>>.99"
    .


DEFINE VARIABLE m-linha AS INTEGER.
DEFINE VARIABLE qtde_entrada AS DEC FORMAT "->>>,>>>,>>>,>>>.99".
DEFINE VARIABLE qtde_saida AS DEC FORMAT "->>>,>>>,>>>,>>>.99".
DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}


       chExcel:sheetsinNewWorkbook = 1.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="ICMS ST". /* Nome que ser¿ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:q1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:q1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:q1"):SetValue("ICMS ST").
       chWorkSheet:Range("A1:q1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:Q1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat÷rio */
           chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("Transacao").
           chworksheet:range("b" + STRING(m-linha)):SetValue("CFOP").
           chworksheet:range("c" + STRING(m-linha)):SetValue("UF").
           chworksheet:range("d" + STRING(m-linha)):SetValue("Fornec/Clien").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Item").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Lote").
           chworksheet:range("g" + STRING(m-linha)):SetValue("Vlr.Original").
           chworksheet:range("h" + STRING(m-linha)):SetValue("Aliq.ICMS").
           chworksheet:range("i" + STRING(m-linha)):SetValue("Base ICMS").
           chworksheet:range("j" + STRING(m-linha)):SetValue("Vlr.ICMS").
           chworksheet:range("k" + STRING(m-linha)):SetValue("Base ICMS ST").
           chworksheet:range("l" + STRING(m-linha)):SetValue("Vlr. ICMS ST").
           chworksheet:range("m" + STRING(m-linha)):SetValue("Vlr. IPI").
           chworksheet:range("n" + STRING(m-linha)):SetValue("Dt. Trans").
           chworksheet:range("o" + STRING(m-linha)):SetValue("Estabel").
           chworksheet:range("p" + STRING(m-linha)):SetValue("NF").
           chworksheet:range("q" + STRING(m-linha)):SetValue("Qtde").
		   


        m-linha = m-linha + 1.
       





RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Processando Documentos de Entrada").
FIND FIRST tt-param NO-ERROR.



FOR EACH it-doc-fisc NO-LOCK WHERE it-doc-fisc.cod-estabel >= tt-param.cod-estab-ini
                             AND   it-doc-fisc.cod-estabel <= tt-param.cod-estab-fim
                             AND   it-doc-fisc.cod-emitente >= tt-param.cod-emitente-ini
                             AND   it-doc-fisc.cod-emitente <= tt-param.cod-emitente-fim
			                 AND   it-doc-fisc.it-codigo    >= tt-param.it-codigo-ini
                             AND   it-doc-fisc.it-codigo    <= tt-param.it-codigo-fim
                             AND   it-doc-fisc.nat-operacao >= tt-param.natur-oper-ini
                             AND   it-doc-fisc.nat-operacao <= tt-param.natur-oper-fim
                             AND   it-doc-fisc.dt-emis-doc  >= 01/01/2018
                             AND   it-doc-fisc.dt-emis-doc  <= 08/31/2018
                             :
RUN pi-acompanhar IN h-prog (INPUT "Estab: " + it-doc-fisc.cod-estabel + " Emitente: " + string(it-doc-fisc.cod-emitente) + " Docto: " + it-doc-fisc.nr-doc-fis + " Item: " + it-doc-fisc.it-codigo).

    FIND FIRST ITEM WHERE ITEM.ge-codigo <> 50
                    AND   ITEM.ge-codigo <> 99
                    AND   ITEM.ge-codigo <> 30 
                    AND   item.it-codigo = it-doc-fisc.it-codigo NO-ERROR..

    IF AVAIL ITEM THEN DO:
        

    FIND FIRST item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = it-doc-fisc.cod-emitente
                                    AND   item-doc-est.nro-docto    = it-doc-fisc.nr-doc-fis
                                    AND   item-doc-est.serie-docto  = it-doc-fisc.serie
                                    AND   item-doc-est.nat-operacao = it-doc-fisc.nat-operacao
                                    AND   item-doc-est.it-codigo    = ITEM.it-codigo 
                                    AND   item-doc-est.base-subs[1] <> 0 NO-ERROR.


    IF AVAIL item-doc-est THEN DO:
        
    


    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = item-doc-est.cod-emitente NO-ERROR.


    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.


    for each movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel = it-doc-fisc.cod-estabel
                                   AND   movto-estoq.it-codigo   = it-doc-fisc.it-codigo
                                   AND   movto-estoq.nro-docto   = it-doc-fisc.nr-doc-fis
                                   AND   movto-estoq.serie-docto = it-doc-fisc.serie
                                   AND   movto-estoq.cod-emitente = it-doc-fisc.cod-emitente 
                                   AND   movto-estoq.tipo-trans   = 2
                                   :



/*     find first tt-entradas where tt-entradas.ttv_cfop                       = item-doc-est.nat-operacao */
/*                            and  tt-entradas.ttv_uf                         = emitente.estado */
/*                            and  tt-entradas.ttv_emitente                   = item-doc-est.cod-emitente */
/*                            and  tt-entradas.ttv_it_codigo                  = item-doc-est.it-codigo */
/*                            and  tt-entradas.ttv_lote                       = movto-estoq.lote */
/*                            and  tt-entradas.ttv_dt_trans                   = it-doc-fisc.dt-emis-doc */
/*                            and  tt-entradas.ttv_estab                      = it-doc-fisc.cod-estabel */
/*                            and  tt-entradas.ttv_documento                  = it-doc-fisc.nr-doc-fis */
/*                            and  tt-entradas.ttv_quantidade                 = item-doc-est.quantidade no-error. */
/*    */
/*    */
/*     if not avail tt-entradas then do: */

    CREATE tt-entradas.
    ASSIGN tt-entradas.ttv_cfop                       = item-doc-est.nat-operacao
           tt-entradas.ttv_uf                         = emitente.estado
           tt-entradas.ttv_emitente                   = item-doc-est.cod-emitente
           tt-entradas.ttv_it_codigo                  = item-doc-est.it-codigo
           tt-entradas.ttv_lote                       = movto-estoq.lote
           tt-entradas.ttv_vlr_ctbl                   = it-doc-fisc.vl-tot-item
           tt-entradas.ttv_aliquota                   = it-doc-fisc.aliquota-icm 
           tt-entradas.ttv_base_icms                  = item-doc-est.base-icm[1]
           tt-entradas.ttv_vlr_icms                   = item-doc-est.valor-icm[1]
           tt-entradas.ttv_base_icms_st               = item-doc-est.base-subs[1]
           tt-entradas.ttv_vlr_icms_st                = item-doc-est.vl-subs[1]
           tt-entradas.ttv_vlr_ipi                    = item-doc-est.ipi-outras[1]
           tt-entradas.ttv_dt_trans                   = it-doc-fisc.dt-emis-doc
           tt-entradas.ttv_estab                      = it-doc-fisc.cod-estabel
           tt-entradas.ttv_documento                  = it-doc-fisc.nr-doc-fis
           tt-entradas.ttv_quantidade                 = movto-estoq.quantidade.
            END.
        end.    
    end.
END.
RUN pi-finalizar IN h-prog.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Processando Documentos de Saida").

FOR EACH tt-entradas BREAK BY tt-entradas.ttv_lote
                           BY tt-entradas.ttv_dt_trans
                           BY tt-entradas.ttv_cfop:
    RUN pi-acompanhar IN h-prog (INPUT "Estab: " + tt-entradas.ttv_estab + " Emitente: " + string(tt-entradas.ttv_emitente) + " Docto: " + tt-entradas.ttv_documento + " Item: " + tt-entradas.ttv_it_codigo).


    ACCUMULATE tt-entradas.ttv_quantidade (SUB-TOTAL BY tt-entradas.ttv_lote).

    chworksheet:range("a" + STRING(m-linha)):SetValue("Entrada: ").     
    chworksheet:range("b" + STRING(m-linha)):SetValue(tt-entradas.ttv_cfop).             
    chworksheet:range("c" + STRING(m-linha)):SetValue(tt-entradas.ttv_uf).               
    chworksheet:range("d" + STRING(m-linha)):SetValue(tt-entradas.ttv_emitente).         
    chworksheet:range("e" + string(m-linha)):SetValue("'" + tt-entradas.ttv_it_codigo).        
    chworksheet:range("f" + string(m-linha)):SetValue(tt-entradas.ttv_lote).             
    chworksheet:range("g" + string(m-linha)):SetValue(tt-entradas.ttv_quantidade).
    chworksheet:range("h" + string(m-linha)):SetValue(tt-entradas.ttv_vlr_ctbl).         
    chworksheet:range("i" + string(m-linha)):SetValue(tt-entradas.ttv_aliquota).         
    chworksheet:range("j" + string(m-linha)):SetValue(tt-entradas.ttv_base_icms).        
    chworksheet:range("k" + string(m-linha)):SetValue(tt-entradas.ttv_vlr_icms).         
    chworksheet:range("l" + string(m-linha)):SetValue(tt-entradas.ttv_base_icms_st).     
    chworksheet:range("m" + string(m-linha)):SetValue(tt-entradas.ttv_vlr_icms_st).      
    chworksheet:range("n" + string(m-linha)):SetValue(tt-entradas.ttv_vlr_ipi).          
    chworksheet:range("o" + string(m-linha)):SetValue(tt-entradas.ttv_dt_trans).         
    chworksheet:range("p" + string(m-linha)):SetValue(tt-entradas.ttv_estab).            
    chworksheet:range("q" + string(m-linha)):SetValue(tt-entradas.ttv_documento).        

ASSIGN m-linha = m-linha + 1.

    if first-of(tt-entradas.ttv_lote) then do:
    
    assign qtde_saida  = 0.

    FOR EACH movto-estoq NO-LOCK USE-INDEX item-est-dep WHERE   movto-estoq.it-codigo    = tt-entradas.ttv_it_codigo
                                 AND     movto-estoq.lote         = tt-entradas.ttv_lote
                                 AND     movto-estoq.cod-estabel  = tt-entradas.ttv_estab
                                 AND     movto-estoq.esp-docto    <> 21
                                 AND     movto-estoq.quantidade   > 0
                                 AND     movto-estoq.dt-trans     >= 01/01/2018
                                 AND     movto-estoq.dt-trans     <= 08/21/2018
                                 BREAK BY movto-estoq.lote:


       ASSIGN qtde_saida = IF movto-estoq.tipo-trans = 1 THEN qtde_saida + movto-estoq.quantidade ELSE qtde_saida - movto-estoq.quantidade.


        CASE movto-estoq.esp-docto:

            WHEN 22 THEN
                RUN pi-saida.
            WHEN 20 THEN 
                RUN pi-devolucao.
            otherwise
                RUN pi-outros.
                
                

        END CASE.


    END.
end.

    IF LAST-OF(tt-entradas.ttv_lote) THEN DO:

        ASSIGN qtde_entrada = ACCUM SUB-TOTAL BY tt-entradas.ttv_lote tt-entradas.ttv_quantidade.


        ASSIGN m-linha = m-linha + 1.
        chworksheet:range("a" + STRING(m-linha)):SetValue("Qtde Entrada: "). 
        chworksheet:range("a" + STRING(m-linha)):FONT:colorindex = 25.
        chworksheet:range("b" + STRING(m-linha)):SetValue(qtde_entrada).
        chworksheet:range("b" + STRING(m-linha)):FONT:colorindex = 25.


        ASSIGN m-linha = m-linha + 1.

        chworksheet:range("a" + STRING(m-linha)):SetValue("Qtde Saida: ").     
        chworksheet:range("a" + STRING(m-linha)):FONT:colorindex = 3.
        chworksheet:range("b" + STRING(m-linha)):SetValue(qtde_saida).
        chworksheet:range("b" + STRING(m-linha)):FONT:colorindex = 3.

        
        ASSIGN m-linha = m-linha + 1.

        chworksheet:range("a" + STRING(m-linha)):SetValue("Saldo: ").    
        chworksheet:range("a" + STRING(m-linha)):FONT:colorindex = 18.
        chworksheet:range("b" + STRING(m-linha)):SetValue(qtde_entrada + qtde_saida).
        chworksheet:range("b" + STRING(m-linha)):FONT:colorindex = 18.
        ASSIGN m-linha = m-linha + 2.

        chworksheet:range("a" + STRING(m-linha)):SetValue("Transacao").
        chworksheet:range("b" + STRING(m-linha)):SetValue("CFOP").
        chworksheet:range("c" + STRING(m-linha)):SetValue("UF").
        chworksheet:range("d" + STRING(m-linha)):SetValue("Fornec/Clien").
        chworksheet:range("e" + STRING(m-linha)):SetValue("Item").
        chworksheet:range("f" + STRING(m-linha)):SetValue("Lote").
        chworksheet:range("g" + STRING(m-linha)):SetValue("Qtde").
        chworksheet:range("h" + STRING(m-linha)):SetValue("Vlr.Original").
        chworksheet:range("i" + STRING(m-linha)):SetValue("Aliq.ICMS").
        chworksheet:range("j" + STRING(m-linha)):SetValue("Base ICMS").
        chworksheet:range("k" + STRING(m-linha)):SetValue("Vlr.ICMS").
        chworksheet:range("l" + STRING(m-linha)):SetValue("Base ICMS ST").
        chworksheet:range("m" + STRING(m-linha)):SetValue("Vlr. ICMS ST").
        chworksheet:range("n" + STRING(m-linha)):SetValue("Vlr. IPI").
        chworksheet:range("o" + STRING(m-linha)):SetValue("Dt. Trans").
        chworksheet:range("p" + STRING(m-linha)):SetValue("Estabel").
        chworksheet:range("q" + STRING(m-linha)):SetValue("NF").
        chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */

        ASSIGN m-linha = m-linha + 1.

    END.


END.

RUN pi-finalizar IN h-prog.


PROCEDURE pi-saida:
        FIND FIRST it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = movto-estoq.cod-estabel
                                        AND   it-nota-fisc.serie       = movto-estoq.serie-docto
                                        AND   it-nota-fisc.nr-nota-fis = movto-estoq.nro-docto
                                        AND   it-nota-fisc.it-codigo   = movto-estoq.it-codigo
                                         NO-ERROR.

        FIND FIRST emitente WHERE emitente.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.





        chworksheet:range("a" + STRING(m-linha)):SetValue("Saidas: ").             
        chworksheet:range("b" + STRING(m-linha)):SetValue(it-nota-fisc.nat-operacao).  
        chworksheet:range("c" + STRING(m-linha)):SetValue(emitente.estado).            
        chworksheet:range("d" + STRING(m-linha)):SetValue(it-nota-fisc.cd-emitente).   
        chworksheet:range("e" + string(m-linha)):SetValue(it-nota-fisc.it-codigo).           
        chworksheet:range("f" + string(m-linha)):SetValue(movto-estoq.lote).  
        chworksheet:range("g" + string(m-linha)):SetValue(IF movto-estoq.tipo-trans = 1 THEN movto-estoq.quantidade ELSE movto-estoq.quantidade * - 1).
        chworksheet:range("h" + string(m-linha)):SetValue(it-nota-fisc.vl-tot-item).   
        chworksheet:range("i" + string(m-linha)):SetValue(it-nota-fisc.aliquota-icm).  
        chworksheet:range("j" + string(m-linha)):SetValue(it-nota-fisc.vl-bicms-it).   
        chworksheet:range("k" + string(m-linha)):SetValue(it-nota-fisc.vl-icms-it).    
        chworksheet:range("l" + string(m-linha)):SetValue(it-nota-fisc.vl-bsubs-it).   
        chworksheet:range("m" + string(m-linha)):SetValue(it-nota-fisc.vl-icmsub-it).  
        chworksheet:range("n" + string(m-linha)):SetValue(it-nota-fisc.vl-ipiou-it).   
        chworksheet:range("o" + string(m-linha)):SetValue(it-nota-fisc.dt-emis-nota).  
        chworksheet:range("p" + string(m-linha)):SetValue(it-nota-fisc.cod-estabel).   
        chworksheet:range("q" + string(m-linha)):SetValue(it-nota-fisc.nr-nota-fis). 

ASSIGN m-linha = m-linha + 1.

END PROCEDURE.


PROCEDURE pi-devolucao:


    IF movto-estoq.tipo-trans = 1 THEN DO:
        
    

    FIND FIRST item-doc-est NO-LOCK WHERE item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                    AND   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                    AND   item-doc-est.serie-docto  = movto-estoq.serie-docto
                                    AND   item-doc-est.it-codigo    = movto-estoq.it-codigo 
                                    NO-ERROR.

        

    FIND FIRST emitente WHERE emitente.cod-emitente = item-doc-est.cod-emitente NO-ERROR.


    FIND FIRST it-doc-fisc NO-LOCK WHERE it-doc-fisc.serie = item-doc-est.serie-docto
                                   AND   it-doc-fisc.nr-doc-fis = item-doc-est.nro-docto
                                   AND   it-doc-fisc.cod-emitente = item-doc-est.cod-emitente
                                   AND   it-doc-fisc.it-codigo    = item-doc-est.it-codigo NO-ERROR.




    chworksheet:range("a" + STRING(m-linha)):SetValue("Devolucao Ent: ").             
    chworksheet:range("b" + STRING(m-linha)):SetValue(item-doc-est.nat-operacao).    
    chworksheet:range("c" + STRING(m-linha)):SetValue(emitente.estado).              
    chworksheet:range("d" + STRING(m-linha)):SetValue(item-doc-est.cod-emitente).    
    chworksheet:range("e" + string(m-linha)):SetValue(item-doc-est.it-codigo).            
    chworksheet:range("f" + string(m-linha)):SetValue(movto-estoq.lote).             
    chworksheet:range("g" + string(m-linha)):SetValue(item-doc-est.quantidade).     
    chworksheet:range("h" + string(m-linha)):SetValue(it-doc-fisc.vl-tot-item).      
    chworksheet:range("i" + string(m-linha)):SetValue(it-doc-fisc.aliquota-icm).     
    chworksheet:range("j" + string(m-linha)):SetValue(item-doc-est.base-icm[1]).     
    chworksheet:range("k" + string(m-linha)):SetValue(item-doc-est.valor-icm[1]).    
    chworksheet:range("l" + string(m-linha)):SetValue(item-doc-est.base-subs[1]).    
    chworksheet:range("m" + string(m-linha)):SetValue(item-doc-est.vl-subs[1]).      
    chworksheet:range("n" + string(m-linha)):SetValue(item-doc-est.ipi-outras[1]).   
    chworksheet:range("o" + string(m-linha)):SetValue(it-doc-fisc.dt-emis-doc).      
    chworksheet:range("p" + string(m-linha)):SetValue(it-doc-fisc.cod-estabel).      
    chworksheet:range("q" + string(m-linha)):SetValue(it-doc-fisc.nr-doc-fis).       

ASSIGN m-linha = m-linha + 1.

END.


ELSE DO:
    
    FIND FIRST it-nota-fisc NO-LOCK WHERE it-nota-fisc.cod-estabel = movto-estoq.cod-estabel
                                    AND   it-nota-fisc.serie       = movto-estoq.serie-docto
                                    AND   it-nota-fisc.nr-nota-fis = movto-estoq.nro-docto
                                    AND   it-nota-fisc.it-codigo   = movto-estoq.it-codigo NO-ERROR.

    FIND FIRST emitente WHERE emitente.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.





    chworksheet:range("a" + STRING(m-linha)):SetValue("Devolucao Sai: ").             
    chworksheet:range("b" + STRING(m-linha)):SetValue(it-nota-fisc.nat-operacao).  
    chworksheet:range("c" + STRING(m-linha)):SetValue(emitente.estado).            
    chworksheet:range("d" + STRING(m-linha)):SetValue(it-nota-fisc.cd-emitente).   
    chworksheet:range("e" + string(m-linha)):SetValue(it-nota-fisc.it-codigo).           
    chworksheet:range("f" + string(m-linha)):SetValue(movto-estoq.lote).           
    chworksheet:range("g" + string(m-linha)):SetValue(IF movto-estoq.tipo-trans = 1 THEN movto-estoq.quantidade ELSE movto-estoq.quantidade * - 1).
    chworksheet:range("h" + string(m-linha)):SetValue(it-nota-fisc.vl-tot-item).   
    chworksheet:range("i" + string(m-linha)):SetValue(it-nota-fisc.aliquota-icm).  
    chworksheet:range("j" + string(m-linha)):SetValue(it-nota-fisc.vl-bicms-it).   
    chworksheet:range("k" + string(m-linha)):SetValue(it-nota-fisc.vl-icms-it).    
    chworksheet:range("l" + string(m-linha)):SetValue(it-nota-fisc.vl-bsubs-it).   
    chworksheet:range("m" + string(m-linha)):SetValue(it-nota-fisc.vl-icmsub-it).  
    chworksheet:range("n" + string(m-linha)):SetValue(it-nota-fisc.vl-ipiou-it).   
    chworksheet:range("o" + string(m-linha)):SetValue(it-nota-fisc.dt-emis-nota).  
    chworksheet:range("p" + string(m-linha)):SetValue(it-nota-fisc.cod-estabel).   
    chworksheet:range("q" + string(m-linha)):SetValue(it-nota-fisc.nr-nota-fis). 

ASSIGN m-linha = m-linha + 1.



END.

END PROCEDURE.


PROCEDURE pi-outros:


        chworksheet:range("a" + STRING(m-linha)):SetValue("Outras: ").             
        chworksheet:range("b" + STRING(m-linha)):SetValue("Transacao CEP: " + string(movto-estoq.esp-docto)).  
        chworksheet:range("c" + STRING(m-linha)):SetValue("").            
        chworksheet:range("d" + STRING(m-linha)):SetValue("").   
        chworksheet:range("e" + string(m-linha)):SetValue(movto-estoq.it-codigo).           
        chworksheet:range("f" + string(m-linha)):SetValue(movto-estoq.lote).           
        chworksheet:range("g" + string(m-linha)):SetValue(IF movto-estoq.tipo-trans = 1 THEN movto-estoq.quantidade ELSE movto-estoq.quantidade * - 1).
        chworksheet:range("h" + string(m-linha)):SetValue(movto-estoq.valor-mat-m[1]).   
        chworksheet:range("i" + string(m-linha)):SetValue("0").  
        chworksheet:range("j" + string(m-linha)):SetValue("0").   
        chworksheet:range("k" + string(m-linha)):SetValue("0").    
        chworksheet:range("l" + string(m-linha)):SetValue("0").   
        chworksheet:range("m" + string(m-linha)):SetValue("0").  
        chworksheet:range("n" + string(m-linha)):SetValue("0").   
        chworksheet:range("o" + string(m-linha)):SetValue(movto-estoq.dt-trans).  
        chworksheet:range("p" + string(m-linha)):SetValue(movto-estoq.cod-estabel).   
        chworksheet:range("q" + string(m-linha)):SetValue(movto-estoq.nro-docto). 

ASSIGN m-linha = m-linha + 1.

END PROCEDURE.


chexcel:VISIBLE = YES.


