
/*include de controle de vers’o*/
{include/i-prgvrs.i BDG 1.00.00.001}

    define temp-table tt-param no-undo
        field destino                  as integer
        field arquivo                  as char format "x(35)"
        field usuario                  as char format "x(12)"
        field data-exec                as date
        field hora-exec                as integer
        field classifica               as integer
        field desc-classifica          as char format "x(40)"
        field modelo-rtf               as char format "x(35)"
        field l-habilitaRtf            as LOG
        FIELD data-ini                 AS DATE
        FIELD data-fim                 AS DATE
       .



 
    def temp-table tt-raw-digita
            field raw-digita    as raw.


    def input parameter raw-param as raw no-undo.
    def input parameter TABLE for tt-raw-digita.

    create tt-param.
    RAW-TRANSFER raw-param to tt-param.

  
{utp/utapi013.i}  

    {include/i-rpvar.i}
  
  
    /* include padr’o para output de relat½rios */
    {include/i-rpout.i &STREAM="stream str-rp"}
    /* include com a defini?’o da frame de cabe?alho e rodap' */
    /* bloco principal do programa */
    assign c-programa 	= "ESFT0010RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa 	= "Eteno"
        c-sistema	= "Datasul EMS"
        c-titulo-relat = "Titulos Gerados".
    view stream str-rp frame f-cabec.
    view stream str-rp frame f-rodape.




DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE VAR h-prog AS HANDLE.
define var i as integer.
def var h-acomp as handle.
DEFINE VAR m-linha AS INTEGER.
DEFINE VAR m-linha-a AS INTEGER.
DEFINE VAR tinicio AS DATETIME.
DEFINE VAR tatual AS DATETIME.
DEFINE VAR c-arquiv AS CHAR.
FIND FIRST tt-param NO-ERROR. 
DEFINE VAR v-cod-cliente AS INTEGER NO-UNDO.
DEFINE VAR v-nom-cobrador AS char NO-UNDO.
DEFINE VAR v-nom-represe  AS char NO-UNDO.
DEFINE VAR v-uf            AS char NO-UNDO.
DEFINE VAR v-cnpj          AS char NO-UNDO.
DEFINE VAR v-ramo          AS char NO-UNDO.
DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.    


assign tt-param.arquivo = replace(tt-param.arquivo, ".tmp", STRING(TIME) + ".xls").

ASSIGN c-arquiv = tt-param.arquivo.
ASSIGN tinicio = NOW.

run utp/utapi013.p persistent set h-utapi013.
/*SYSTEM-DIALOG PRINTER-SETUP.*/
os-delete value(c-arquiv).
 
    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao     = 1
           tt-configuracao2.arquivo-num           = 1
           tt-configuracao2.arquivo               = c-arquiv
           tt-configuracao2.total-planilhas       = 2
           tt-configuracao2.exibir-construcao     = NO
           tt-configuracao2.abrir-excel-termino   = YES
           tt-configuracao2.imprimir              = NO
           tt-configuracao2.orientacao            = 1.

    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num               = 1 
           tt-planilha2.planilha-num              = 1
           tt-planilha2.planilha-nome             = "ItensFaturamento"
           tt-planilha2.linhas-grade              =  NO.



    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "gerando").
RUN pi-cabecalho.
RUN pi-varre-acr.
    RUN pi-finalizar IN h-acomp.

/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 14                                                                */
/*            tt-tabdin.ORIENTATION  = 1.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 11                                                                */
/*            tt-tabdin.ORIENTATION  = 2.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 12                                                                */
/*            tt-tabdin.ORIENTATION  = 2.                                                          */
/*     CREATE tt-tabdin.                                                                           */
/*     ASSIGN tt-tabdin.ordem  = 9                                                                 */
/*            tt-tabdin.ORIENTATION  = 4                                                           */
/*            tt-tabdin.FUNCTION  = 0.                                                             */
/*     RUN add-tabdin IN h-utapi013  (1,1,"Resumo",1,18,2, m-linha, INPUT-OUTPUT TABLE tt-tabdin). */
/*                                                                                                 */

//RUN show IN h-handle (false).


RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                               INPUT-OUTPUT TABLE tt-planilha2,
                               INPUT-OUTPUT TABLE tt-dados,
                               INPUT-OUTPUT TABLE tt-formatar,
                               INPUT-OUTPUT TABLE tt-grafico2,
                               INPUT-OUTPUT TABLE tt-erros).

if return-value = "nok" then do: 
    for each tt-erros: 
        PUT STREAM str-rp tt-erros.cod-erro   FORMAT '99999'
                          tt-erros.DESC-error FORMAT 'x(256)'
                          SKIP.
    end.
end.     

ELSE DO:
    PUT STREAM str-rp UNFORMATTED   "Planilha gerada com sucesso em " + c-arquiv SKIP.
END.
Delete procedure h-utapi013.


PROCEDURE pi-varre-acr:

FOR EACH it-doc-fisc NO-LOCK WHERE  it-doc-fisc.dt-emis-doc   >= tt-param.data-ini
                              AND   it-doc-fisc.dt-emis-doc   <= tt-param.data-fim
                              AND   dec(substr(it-doc-fisc.char-2,124,14)) > 0 BREAK BY it-doc-fisc.cod-estabel
                                                                                     BY it-doc-fisc.serie
                                                                                     BY it-doc-fisc.nr-doc-fis:


    ACCUMULATE dec(substr(it-doc-fisc.char-2,124,14)) (SUB-TOTAL BY it-doc-fisc.nr-doc-fis).
    ACCUMULATE it-doc-fisc.vl-merc-liq                (SUB-TOTAL BY it-doc-fisc.nr-doc-fis).




    FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao NO-ERROR.
.   
    FIND FIRST item NO-LOCK WHERE item.it-codigo = it-doc-fisc.it-codigo NO-ERROR.

    FIND FIRST grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo = ITEM.ge-codigo  NO-ERROR.


    IF LAST-OF(it-doc-fisc.nr-doc-fis) THEN DO:
        
    

        IF AVAIL conta-ft THEN DO:
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 1                          
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = string(it-doc-fisc.dt-emis-doc)                  
               celula-fonte-cor                = 1.      
        
    
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 2                          
               celula-formato                  = '@@'
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = it-doc-fisc.cod-estabel              
               celula-fonte-cor                = 1.      
    
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 3                         
               celula-formato                  = '@@'
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = it-doc-fisc.serie                
               celula-fonte-cor                = 1.      
        
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 4                         
               celula-formato                  = '@@'
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = it-doc-fisc.nr-doc-fis              
               celula-fonte-cor                = 1.      
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 5                         
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = string(ACCUM SUB-TOTAL BY it-doc-fisc.nr-doc-fis it-doc-fisc.vl-merc-liq)               
               celula-fonte-cor                = 1.      
        
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 8                         
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = string(item.ge-codigo)                 
               celula-fonte-cor                = 1.      
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 9                         
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = it-nota-fisc.nat-operacao              
               celula-fonte-cor                = 1.      
        
        CREATE tt-dados.
        ASSIGN arquivo-num                     = 1                          
               planilha-num                    = 1                          
               celula-coluna                   = 10                        
               celula-formato                  = '@@'
               celula-linha                    = m-linha                          
               celula-cor-interior             = 58                          
               celula-valor                    = natur-oper.cod-cfop              
               celula-fonte-cor                = 1.      
        END.
    END.
END.


END PROCEDURE.




	




PROCEDURE pi-cabecalho:


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Dt.Emissao"                    
           celula-fonte-cor                = 1.                          
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 2                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Ct.Revenda"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 3                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Estab."                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 4                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Serie"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 5                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Item"                    
           celula-fonte-cor                = 1.      


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 6                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "NF"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 7                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Vlr.Total Item"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 8                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Gr.Estoque"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 9                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Nat.Oper"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 10                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "CFOP"                    
           celula-fonte-cor                = 1.    



    ASSIGN m-linha = 2.
    ASSIGN m-linha-a = 2.

END PROCEDURE.
