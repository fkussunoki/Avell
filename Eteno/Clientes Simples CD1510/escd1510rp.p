
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
        FIELD natur-oper               AS char FORMAT "x(2000)".
      
 
    def temp-table tt-raw-digita
            field raw-digita    as raw.


    def input parameter raw-param as raw no-undo.
    def input parameter TABLE for tt-raw-digita.

    create tt-param.
    RAW-TRANSFER raw-param to tt-param.

{include/i-rpvar.i}
{include/tt-edit.i} 

{include/i-freeac.i}
{utp/utapi013.i}  

{utp/ut-glob.i}

    /* include padrÆo para output de relat¢rios */
    {include/i-rpout.i &STREAM="stream str-rp"}

    /* include com a defini‡Æo da frame de cabe‡alho e rodap‚   */
    {include/i-rpcab.i &STREAM="str-rp"}                        


    assign c-programa  = "ESCC0306rp"
        c-versao       = "1.00.00.000"
        c-empresa      = "Eteno"
        c-revisao	   = "1"
        c-titulo-relat = "Relatorio Pedido x Recebimento".
/*                                                                      */
def var h-utapi019 as HANDLE NO-UNDO.


DEFINE TEMP-TABLE tt-natur-oper
    FIELD ttv-natur-oper AS CHAR.



define var i as integer.
DEFINE VAR n1 AS INTEGER.
DEFINE VAR c-arquiv AS char.
def var h-acomp as handle.
DEFINE VAR m-linha AS INTEGER.
DEFINE VARIABLE h-handle AS HANDLE NO-UNDO.    
DEFINE VAR num-1 AS INTEGER.
DEFINE VAR vendedores AS char.
DEFINE VAR i-countador AS INTEGER.
DEFINE VAR tinicio AS date.
DEFINE VAR tatual  AS date.

ASSIGN num-1 = NUM-ENTRIES(tt-param.natur-oper).


DO n1 = 1 TO num-1:

    CREATE tt-natur-oper.
    ASSIGN tt-natur-oper.ttv-natur-oper = entry(n1, tt-param.natur-oper).

END.
                  

FIND FIRST TT-PARAM NO-ERROR.
ASSIGN C-ARQUIV = SUBSTR(tt-param.arquivo, 1, R-INDEX(tt-param.arquivo, ".") - 1).

IF i-num-ped-exec-rpw > 0 THEN DO:
   FIND ped_exec NO-LOCK WHERE ped_exec.num_ped_exec = i-num-ped-exec-rpw NO-ERROR.
   IF AVAIL ped_exec THEN DO:
       FIND servid_exec NO-LOCK WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
       IF AVAIL servid_exec THEN 
          ASSIGN c-arquiv = TRIM(servid_exec.nom_dir_spool) + '\' + C-ARQUIV + STRING(TIME) + '.xlsx'.
   END.
END.

ELSE DO:
    ASSIGN c-arquiv = c-arquiv + STRING(TIME) + '.xlsx'.

END.

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
           tt-planilha2.planilha-nome             = "CD1510"
           tt-planilha2.linhas-grade              =  NO.

ASSIGN tinicio = NOW.


RUN pi-cabecalho.    
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "gerando").


FOR EACH tt-natur-oper,
    EACH emitente NO-LOCK WHERE emitente.nat-operacao = tt-natur-oper.ttv-natur-oper
                          OR    emitente.nat-ope-ext  = tt-natur-oper.ttv-natur-oper:
    ASSIGN tatual = NOW.

    RUN pi-cria-planilha.


END.


    RUN pi-finalizar IN h-acomp.

    RUN pi-execute3 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).

    Delete procedure h-utapi013.



    FIND FIRST tt-erros NO-ERROR.

    IF AVAIL tt-erros THEN DO:
        

        EXPORT STREAM str-rp tt-erros.
    END.

    ELSE DO:
        PUT STREAM str-rp UNFORMATTED "Planilha gerada em " + SESSION:TEMP-DIRECTORY + c-arquiv SKIP.
    END.


PROCEDURE pi-cria-planilha:



   RUN pi-acompanhar IN h-acomp (INPUT "Emitente " + string(emitente.cod-emitente) + string(INTErval(tatual, tinicio, "minutes")) + " minutos").


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = string(emitente.cod-emitente)                  
           celula-fonte-cor                = 1.      
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 2                          
           celula-linha                    = m-linha         
           celula-formato                  = '@@'
           celula-cor-interior             = 58                          
           celula-valor                    = emitente.cgc                 
           celula-fonte-cor                = 1.      
            
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 3                          
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = emitente.nome-abrev                  
           celula-fonte-cor                = 1.      


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 4                          
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = emitente.nat-operacao                 
           celula-fonte-cor                = 1.      

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 5                          
           celula-linha                    = m-linha                          
           celula-cor-interior             = 58                          
           celula-valor                    = emitente.nat-ope-ext                
           celula-fonte-cor                = 1.      


ASSIGN m-linha = m-linha + 1.



END PROCEDURE.



PROCEDURE pi-cabecalho:


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 1                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Codigo cliente"                    
           celula-fonte-cor                = 1.                          
    
    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 2                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "CNPJ"                    
           celula-fonte-cor                = 1.                          

    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 3                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Nome Abreviado"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 4                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Nat.Oper"                    
           celula-fonte-cor                = 1.                          


    CREATE tt-dados.
    ASSIGN arquivo-num                     = 1                          
           planilha-num                    = 1                          
           celula-coluna                   = 5                          
           celula-linha                    = 1                          
           celula-cor-interior             = 6                          
           celula-valor                    = "Nat.Ext"                    
           celula-fonte-cor                = 1.                          

    ASSIGN m-linha = 2.

END PROCEDURE.



