
    
/* /* include de controle de versão */                             */
{include/i-prgvrs.i escc0300 1.00.00.003}
/* /* definiŒão das temp-tables para recebimento de par?metros */  */

    {utp/utapi013.i}  

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)"
    field modelo-rtf         as char format "x(35)"
    field l-habilitaRtf      as LOG
    FIELD cod-emitente-ini   AS INTEGER
    FIELD cod-emitente-fim   AS INTEGER
    FIELD dt-ini             AS date
    FIELD dt-fim             AS date.


def temp-table tt-raw-digita
        field raw-digita    as raw.
/* recebimento de par?metros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.


/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/tt-edit.i} 

{include/i-freeac.i}



DEFINE TEMP-TABLE tt-visao NO-UNDO
    FIELD cod-emitente     AS INTEGER
    FIELD nr-docto         AS char
    FIELD serie            AS char
    FIELD dt-emissao       AS date
    FIELD it-codigo        AS char
    FIELD descricao        AS char
    FIELD num-pedido       AS INTEGER
    FIELD num-ordem        AS INTEGER
    FIELD quantidade-nf    AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD valor-nf         AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    field un-nf            as char
    FIELD concatena        AS char.
    
    
define temp-table tt-pedido no-undo
    FIELD cod-emitente     AS INTEGER
    FIELD nr-docto         AS char
    FIELD serie            AS char
    FIELD dt-emissao       AS date
    FIELD it-codigo        AS char
    FIELD descricao        AS char
    FIELD num-pedido       AS INTEGER
    FIELD num-ordem        AS INTEGER
    FIELD quantidade-ped   AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD valor-ped        AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    field un-pedido        as char
    field concatena        as char
    field tot-valor-ped    as decimal format "->>>,>>>,>>>,>>9.99"
    field tot-qtde-ped     as decimal format "->>>,>>>,>>>,>>9.99"
    field dep-padrao       as char.
    

DEF VAR m-linha AS INTEGER NO-UNDO.
DEF VAR m-linha2 AS INTEGER NO-UNDO.
DEF VAR h-prog  AS HANDLE  NO-UNDO.
def var ft-conversao as dec no-undo.


    FIND FIRST tt-param NO-ERROR.

    /* include padrÆo para output de relat¢rios */
    {include/i-rpout.i &STREAM="stream str-rp"}

    /* include com a defini‡Æo da frame de cabe‡alho e rodap‚   */
    {include/i-rpcab.i &STREAM="str-rp"}                        


    assign c-programa  = "ESCC0306rp"
        c-versao       = "1.00.00.000"
        c-empresa      = "Eteno"
        c-revisao	   = "1"
        c-titulo-relat = "Relatorio Pedido x Recebimento".


run utp/utapi013.p persistent set h-utapi013.
/*SYSTEM-DIALOG PRINTER-SETUP.*/
os-delete value(SESSION:TEMP-DIRECTORY + 'escc0306.xlsx').
 
    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao     = 1
           tt-configuracao2.arquivo-num           = 1
           tt-configuracao2.arquivo               = SESSION:TEMP-DIRECTORY + 'escc0306.xlsx'
           tt-configuracao2.total-planilhas       = 2
           tt-configuracao2.exibir-construcao     = NO
           tt-configuracao2.abrir-excel-termino   = YES
           tt-configuracao2.imprimir              = NO
           tt-configuracao2.orientacao            = 1.

    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num               = 1 
           tt-planilha2.planilha-num              = 1
           tt-planilha2.planilha-nome             = "Resumo"
           tt-planilha2.linhas-grade              =  NO.

    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num               = 1 
           tt-planilha2.planilha-num              = 2
           tt-planilha2.planilha-nome             = "Detalhe"
           tt-planilha2.linhas-grade              =  NO.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Analisando Pedidos").


FIND FIRST tt-param NO-ERROR.
FOR EACH pedido-compr NO-LOCK WHERE pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
                              AND   pedido-compr.cod-emitente <= tt-param.cod-emitente-fim
                              AND   pedido-compr.data-pedido  >= tt-param.dt-ini
                              AND   pedido-compr.data-pedido  <= tt-param.dt-fim,
    EACH ordem-compra NO-LOCK WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
    each prazo-compra no-lock where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
                              and   prazo-compra.it-codigo  = ordem-compra.it-codigo:
                              
                              find first item no-lock where item.it-codigo = ordem-compra.it-codigo no-error.

                              find first item-fornec no-lock where item-fornec.it-codigo    = item.it-codigo
                              and   item-fornec.cod-emitente = pedido-compr.cod-emitente no-error.

                              if not avail item-fornec then 
                              assign ft-conversao = 1.
                              else
                              assign ft-conversao = item-fornec.fator-conver.



                              
    CREATE tt-pedido.
    ASSIGN tt-pedido.cod-emitente      = pedido-compr.cod-emitente
           tt-pedido.it-codigo         = ordem-compra.it-codigo
           tt-pedido.descricao         = ITEM.descricao-1
           tt-pedido.num-pedido        = pedido-compr.num-pedido
           tt-pedido.num-ordem         = ordem-compra.numero-ordem
           tt-pedido.quantidade-ped    = prazo-compra.quantidade * ft-conversao
           tt-pedido.dep-padrao        = ordem-compra.dep-almoxar
           tt-pedido.un-pedido         = prazo-compra.un
           tt-pedido.valor-ped         = ((ordem-compra.preco-fornec * ordem-compra.qt-solic * ft-conversao) / (1 - (ordem-compra.aliquota-icm / 100)))
           tt-pedido.concatena         = string(ordem-compra.it-codigo) + string(pedido-compr.num-pedido).

           
end.                              
                              
                              
                              
                              
                              
                              
                              
    for each tt-pedido no-lock,                         
    EACH item-doc-est NO-LOCK WHERE item-doc-est.num-pedido         = tt-pedido.num-pedido
                                  AND   item-doc-est.numero-ordem   = tt-pedido.num-ordem
                                  AND   item-doc-est.it-codigo      = tt-pedido.it-codigo break by tt-pedido.concatena:


                                  if item-doc-est.cod-depos = tt-pedido.dep-padrao then do:
                                  
                                  accumulate tt-pedido.quantidade-ped (sub-total by tt-pedido.concatena).
                                  accumulate tt-pedido.valor-ped      (sub-total by tt-pedido.concatena).

                                  end.


        if last-of(tt-pedido.concatena) then do:
        assign tt-pedido.tot-valor-ped = (accum sub-total by tt-pedido.concatena tt-pedido.valor-ped)
               tt-pedido.tot-qtde-ped  = (accum sub-total by tt-pedido.concatena tt-pedido.quantidade-ped).
               
        end.                                  
    
    FIND FIRST docum-est NO-LOCK WHERE docum-est.serie-docto = item-doc-est.serie-docto
                                 AND   docum-est.nro-docto   = item-doc-est.nro-docto
                                 AND   docum-est.cod-emitente = item-doc-est.cod-emitente
                                 NO-ERROR.

    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

RUN pi-acompanhar IN h-prog(INPUT "Pedido " + string(tt-pedido.num-pedido) + " Ordem " + string(tt-pedido.num-ordem) + " Item " + item-doc-est.it-codigo).

    CREATE tt-visao.
    ASSIGN tt-visao.cod-emitente      = docum-est.cod-emitente
           tt-visao.nr-docto          = item-doc-est.nro-docto
           tt-visao.serie             = item-doc-est.serie-docto
           tt-visao.dt-emissao        = docum-est.dt-emissao
           tt-visao.it-codigo         = item-doc-est.it-codigo
           tt-visao.descricao         = ITEM.descricao-1
           tt-visao.num-pedido        = tt-pedido.num-pedido
           tt-visao.num-ordem         = tt-pedido.num-ordem
           tt-visao.quantidade-nf     = (item-doc-est.qt-do-forn) 
           tt-visao.valor-nf          = item-doc-est.preco-total[1]
           tt-visao.un-nf             = item-doc-est.un
           tt-visao.concatena         = string(item-doc-est.it-codigo) + string(tt-pedido.num-pedido).

END.
RUN pi-finalizar IN h-prog.


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 1                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Emitente"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                       = 1                          
               tt-dados.planilha-num                      = 1                          
               tt-dados.celula-coluna                     = 2                          
               tt-dados.celula-linha                      = 1                          
               tt-dados.celula-cor-interior               = 6                          
               tt-dados.celula-valor                      = "Pedido"                  
               tt-dados.celula-fonte-cor                  = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                       = 1                          
               tt-dados.planilha-num                      = 1                          
               tt-dados.celula-coluna                     = 3                          
               tt-dados.celula-linha                      = 1                          
               tt-dados.celula-cor-interior               = 6                          
               tt-dados.celula-valor                      = "Item"                  
               tt-dados.celula-fonte-cor                  = 1.   

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 4                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Descricao"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 5                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Qtde.Pedido"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 1                          
               tt-dados.celula-coluna                  = 6                          
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Qtde NF"                  
               tt-dados.celula-fonte-cor               = 1.  
               
               
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 7                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "UN Pedido"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 1                          
               tt-dados.celula-coluna                  = 8                         
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "UN NF"                  
               tt-dados.celula-fonte-cor               = 1.      

               
                   

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 9                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Saldo Qtde"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                      = 1                          
               tt-dados.planilha-num                     = 1                          
               tt-dados.celula-coluna                    = 10                          
               tt-dados.celula-linha                     = 1                          
               tt-dados.celula-cor-interior              = 6                          
               tt-dados.celula-valor                     = "Vlr.Pedido"                  
               tt-dados.celula-fonte-cor                 = 1.      


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                       = 1                          
               tt-dados.planilha-num                      = 1                          
               tt-dados.celula-coluna                     = 11                          
               tt-dados.celula-linha                      = 1                          
               tt-dados.celula-cor-interior               = 6                          
               tt-dados.celula-valor                      = "Vlr NF"                  
               tt-dados.celula-fonte-cor                  = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 1                          
               tt-dados.celula-coluna                  = 12                          
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Saldo Vlr"                  
               tt-dados.celula-fonte-cor               = 1.      


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 2                          
               tt-dados.celula-coluna                  = 1                          
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Emitente"                  
               tt-dados.celula-fonte-cor               = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                      = 1                          
               tt-dados.planilha-num                     = 2                          
               tt-dados.celula-coluna                    = 2                          
               tt-dados.celula-linha                     = 1                          
               tt-dados.celula-cor-interior              = 6                          
               tt-dados.celula-valor                     = "Pedido"                  
               tt-dados.celula-fonte-cor                 = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 2                          
               tt-dados.celula-coluna                  = 3                          
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Item"                  
               tt-dados.celula-fonte-cor               = 1.   

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 4                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Descricao"                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                   = 1                          
               tt-dados.planilha-num                  = 2                          
               tt-dados.celula-coluna                 = 5                          
               tt-dados.celula-linha                  = 1                          
               tt-dados.celula-cor-interior           = 6                          
               tt-dados.celula-valor                  = "Qtde.Pedido"                  
               tt-dados.celula-fonte-cor              = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 6                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "Qtde NF"                  
               tt-dados.celula-fonte-cor                = 1.      
        
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                   = 1                          
               tt-dados.planilha-num                  = 2                          
               tt-dados.celula-coluna                 = 7                          
               tt-dados.celula-linha                  = 1                          
               tt-dados.celula-cor-interior           = 6                          
               tt-dados.celula-valor                  = "UN Pedido"                  
               tt-dados.celula-fonte-cor              = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 2                          
               tt-dados.celula-coluna                   = 8                          
               tt-dados.celula-linha                    = 1                          
               tt-dados.celula-cor-interior             = 6                          
               tt-dados.celula-valor                    = "UN NF"                  
               tt-dados.celula-fonte-cor                = 1.      
        
        
        
        
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                      = 1                          
               tt-dados.planilha-num                     = 2                          
               tt-dados.celula-coluna                    = 9                          
               tt-dados.celula-linha                     = 1                          
               tt-dados.celula-cor-interior              = 6                          
               tt-dados.celula-valor                     = "Vlr.Pedido"                  
               tt-dados.celula-fonte-cor                 = 1.      


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                      = 1                          
               tt-dados.planilha-num                     = 2                          
               tt-dados.celula-coluna                    = 10                         
               tt-dados.celula-linha                     = 1                          
               tt-dados.celula-cor-interior              = 6                          
               tt-dados.celula-valor                     = "Vlr NF"                  
               tt-dados.celula-fonte-cor                 = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                       = 1                          
               tt-dados.planilha-num                      = 2                          
               tt-dados.celula-coluna                     = 11                         
               tt-dados.celula-linha                      = 1                          
               tt-dados.celula-cor-interior               = 6                          
               tt-dados.celula-valor                      = "Ordem"                  
               tt-dados.celula-fonte-cor                  = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 2                          
               tt-dados.celula-coluna                  = 12                         
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "NF"                  
               tt-dados.celula-fonte-cor               = 1. 

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 2                          
               tt-dados.celula-coluna                  = 13                        
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Serie"                  
               tt-dados.celula-fonte-cor               = 1.    

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                    = 1                          
               tt-dados.planilha-num                   = 2                          
               tt-dados.celula-coluna                  = 14                         
               tt-dados.celula-linha                   = 1                          
               tt-dados.celula-cor-interior            = 6                          
               tt-dados.celula-valor                   = "Data Emissao"                  
               tt-dados.celula-fonte-cor               = 1.      


    ASSIGN m-linha = 2.
    ASSIGN m-linha2 = 2.

        RUN utp/ut-acomp.p PERSISTENT SET h-prog.

        RUN pi-inicializar IN h-prog (INPUT "TT-Visao").


FOR EACH tt-visao BREAK BY tt-visao.concatena:


    find first tt-pedido where tt-pedido.num-pedido = tt-visao.num-pedido
                         and   tt-pedido.num-ordem  = tt-visao.num-ordem
                         and   tt-pedido.it-codigo  = tt-visao.it-codigo no-error.

    RUN pi-acompanhar IN h-prog (INPUT "Emitente " + string(tt-visao.cod-emitente) + " Pedido " + string(tt-visao.num-pedido) + " Ordem "  + STRING(tt-visao.num-ordem) + string(tt-visao.it-codigo)).

    ACCUMULATE tt-visao.quantidade-nf  (SUB-TOTAL BY tt-visao.concatena).
    ACCUMULATE tt-visao.valor-nf       (SUB-TOTAL BY tt-visao.concatena).

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                    = 1                          
           tt-dados.planilha-num                   = 2                          
           tt-dados.celula-coluna                  = 1                          
           tt-dados.celula-linha                   = m-linha2                       
           tt-dados.celula-cor-interior            = 58                          
           tt-dados.celula-valor                   = string(tt-visao.cod-emitente)                 
           tt-dados.celula-fonte-cor               = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                      = 1                          
           tt-dados.planilha-num                     = 2                          
           tt-dados.celula-coluna                    = 2                          
           tt-dados.celula-linha                     = m-linha2                          
           tt-dados.celula-cor-interior              = 58                          
           tt-dados.celula-valor                     = string(tt-visao.num-pedido)                  
           tt-dados.celula-fonte-cor                 = 1.     

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                    = 1                          
           tt-dados.planilha-num                   = 2                          
           tt-dados.celula-coluna                  = 3                          
           tt-dados.celula-linha                   = m-linha2                          
           tt-dados.celula-cor-interior            = 58      
           tt-dados.celula-formato                 = '@'
           tt-dados.celula-valor                   = tt-visao.it-codigo                 
           tt-dados.celula-fonte-cor               = 1.   

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 2                          
           tt-dados.celula-coluna                   = 4                          
           tt-dados.celula-linha                    = m-linha2                          
           tt-dados.celula-cor-interior             = 58                          
           tt-dados.celula-valor                    = tt-visao.descricao                  
           tt-dados.celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                   = 1                          
           tt-dados.planilha-num                  = 2                          
           tt-dados.celula-coluna                 = 5                          
           tt-dados.celula-linha                  = m-linha2                          
           tt-dados.celula-cor-interior           = 58                          
           tt-dados.celula-valor                  = string(tt-pedido.quantidade-ped)                  
           tt-dados.celula-fonte-cor              = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 2                          
           tt-dados.celula-coluna                   = 6                          
           tt-dados.celula-linha                    = m-linha2                          
           tt-dados.celula-cor-interior             = 58                          
           tt-dados.celula-valor                    = string(tt-visao.quantidade-nf)                  
           tt-dados.celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                   = 1                          
           tt-dados.planilha-num                  = 2                          
           tt-dados.celula-coluna                 = 7                          
           tt-dados.celula-linha                  = m-linha2                          
           tt-dados.celula-cor-interior           = 58                          
           tt-dados.celula-valor                  = string(tt-pedido.un-ped)                  
           tt-dados.celula-fonte-cor              = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                     = 1                          
           tt-dados.planilha-num                    = 2                          
           tt-dados.celula-coluna                   = 8                        
           tt-dados.celula-linha                    = m-linha2                          
           tt-dados.celula-cor-interior             = 58                          
           tt-dados.celula-valor                    = string(tt-visao.un-nf)                  
           tt-dados.celula-fonte-cor                = 1.      




    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                      = 1                          
           tt-dados.planilha-num                     = 2                          
           tt-dados.celula-coluna                    = 9                        
           tt-dados.celula-linha                     = m-linha2                          
           tt-dados.celula-cor-interior              = 58                          
           tt-dados.celula-valor                     = string(tt-pedido.valor-ped)
           tt-dados.celula-fonte-cor                 = 1.      


    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                      = 1                          
           tt-dados.planilha-num                     = 2                          
           tt-dados.celula-coluna                    = 10                        
           tt-dados.celula-linha                     = m-linha2                          
           tt-dados.celula-cor-interior              = 58                          
           tt-dados.celula-valor                     = string(tt-visao.valor-nf)                  
           tt-dados.celula-fonte-cor                 = 1.     

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                       = 1                          
           tt-dados.planilha-num                      = 2                          
           tt-dados.celula-coluna                     = 11                         
           tt-dados.celula-linha                      = m-linha2                          
           tt-dados.celula-cor-interior               = 58                          
           tt-dados.celula-valor                      = string(tt-pedido.num-ordem)                  
           tt-dados.celula-fonte-cor                  = 1.      

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                    = 1                          
           tt-dados.planilha-num                   = 2                          
           tt-dados.celula-coluna                  = 12                         
           tt-dados.celula-linha                   = m-linha2  
           tt-dados.celula-formato                 = '@'
           tt-dados.celula-cor-interior            = 58                          
           tt-dados.celula-valor                   = tt-visao.nr-docto                  
           tt-dados.celula-fonte-cor               = 1. 

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                    = 1                          
           tt-dados.planilha-num                   = 2                          
           tt-dados.celula-coluna                  = 13                        
           tt-dados.celula-linha                   = m-linha2  
           tt-dados.celula-formato                 = '@'
           tt-dados.celula-cor-interior            = 58                          
           tt-dados.celula-valor                   = tt-visao.serie                  
           tt-dados.celula-fonte-cor               = 1.    

    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num                    = 1                          
           tt-dados.planilha-num                   = 2                          
           tt-dados.celula-coluna                  = 14                         
           tt-dados.celula-linha                   = m-linha2                          
           tt-dados.celula-cor-interior            = 58                         
           tt-dados.celula-valor                   = string(tt-visao.dt-emissao)                  
           tt-dados.celula-fonte-cor               = 1.      


    IF LAST-OF(tt-visao.concatena) THEN DO:
        
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                       = 1                          
               tt-dados.planilha-num                      = 1                          
               tt-dados.celula-coluna                     = 1                          
               tt-dados.celula-linha                      = m-linha                          
               tt-dados.celula-cor-interior               = 58                          
               tt-dados.celula-valor                      = string(tt-visao.cod-emitente)                  
               tt-dados.celula-fonte-cor                  = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 2                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(tt-pedido.num-pedido)                  
               tt-dados.celula-fonte-cor                = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 3                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                         
               tt-dados.celula-valor                    = tt-visao.it-codigo                 
               tt-dados.celula-fonte-cor                = 1.   

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 4                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = tt-visao.descricao                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 5                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(tt-pedido.tot-qtde-ped)                 
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 6                        
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(ACCUM SUB-TOTAL BY tt-visao.concatena tt-visao.quantidade-nf)                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 7                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(tt-pedido.un-pedido)                 
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 8                        
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(tt-visao.un-nf)                  
               tt-dados.celula-fonte-cor                = 1.      




        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 9                         
               tt-dados.celula-linha                    = m-linha                         
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string("=e" + string(m-linha) + "-" + "f" + string(m-linha))                  
               tt-dados.celula-fonte-cor                = 1.      

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 10                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(tt-pedido.tot-valor-ped)                 
               tt-dados.celula-fonte-cor                = 1.      


        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 11                         
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string(ACCUM SUB-TOTAL BY tt-visao.concatena tt-visao.valor-nf)                    
               tt-dados.celula-fonte-cor                = 1.     

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                     = 1                          
               tt-dados.planilha-num                    = 1                          
               tt-dados.celula-coluna                   = 12                          
               tt-dados.celula-linha                    = m-linha                          
               tt-dados.celula-cor-interior             = 58                          
               tt-dados.celula-valor                    = string("=j" + string(m-linha) + "-" + "k" + string(m-linha))                  
               tt-dados.celula-fonte-cor                = 1.      

        ASSIGN m-linha = m-linha + 1.

    END.

        ASSIGN m-linha2 = m-linha2 + 1.

END.

RUN pi-finalizar IN h-prog.


    RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).


    FIND FIRST tt-erros NO-ERROR.

    IF AVAIL tt-erros THEN DO:
        
        PUT STREAM str-rp  UNFORMATTED tt-erros.cod-erro FORMAT "x(40)" "|"
                               tt-erros.DESC-erro FORMAT "x(120)"
                               SKIP.
                

    END.

    PUT STREAM str-rp UNFORMATTED "Arquivo gerado em " + SESSION:TEMP-DIRECTORY + "escc0306.xlsx"
        SKIP.

    Delete procedure h-utapi013.

