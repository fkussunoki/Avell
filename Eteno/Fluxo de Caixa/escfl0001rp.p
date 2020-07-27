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
    FIELD dir-arquivo      AS CHARACTER
    FIELD ttv-cod-fluxo    AS INTEGER
    FIELD ttv-estab        AS char.


DEFINE TEMP-TABLE TT-FLUXO
    field ttv-duplicata    AS char 
    field ttv-dt-emissao   AS date	
    field ttv-vlr	       AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    field ttv-dt-vcto	   AS DATE
    field ttv-bco	       AS CHAR
    field ttv-nro-bcio	   AS CHAR
    field ttv-id	       AS CHAR
    field ttv-boleto	   AS CHAR
    field ttv-NDJ          AS char.



DEF VAR l-error AS LOGICAL NO-UNDO.


def temp-table tt-raw-digita                 
        field raw-digita    as raw.          

/* recebimento de par?metros */              
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita. 
create tt-param.                             
RAW-TRANSFER raw-param to tt-param.


{include/i-prgvrs.i cea3024RP 2.04.00.000}

{utp/ut-glob.i}
/* include padr’o para variÿveis de relat½rio  */
{include/i-rpvar.i} 


    FIND FIRST tt-param NO-ERROR.

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i &STREAM="stream str-rp"}

    find first mguni.empresa no-lock
        where empresa.ep-codigo = i-ep-codigo-usuario no-error.

    assign c-programa 	  = "ESFP0001"
           c-versao	      = "2.04.00.000"
           c-empresa      = empresa.razao-social
           c-revisao      = "1"
           c-titulo-relat = "CONTAS A PAGAR BRASKEM".

    form header
         fill("-", 132) format "x(132)" skip
         c-empresa format "x(40)" c-titulo-relat at 50 format "x(35)"
         "Folha:" at 122 page-number(str-rp) at 128 format ">>>>9" skip
         fill("-", 112) format "x(110)" today format "99/99/9999"
         "-" string(time, "HH:MM:SS") skip(1)
         with stream-io width 132 no-labels no-box page-top frame f-cabec.

    c-rodape = "ETENO - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao.
    c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

    form header
         c-rodape format "x(132)"
         with stream-io width 132 no-labels no-box page-bottom frame f-rodape.


    view stream str-rp frame f-cabec.
    view stream str-rp frame f-rodape.

    def var ch-excel As Com-handle No-undo.
    def var ch-book  As Com-handle No-undo.
    def var ch-sheet As Com-handle No-undo.
    Def Var i-linha  As Int        No-undo.
    Def Var l-erro   As Log        No-undo.
    Def Var i        As Int        No-undo.
    DEF VAR i-seq    AS INTEGER    NO-UNDO.

    FIND FIRST tt-param NO-ERROR.

    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add(tt-param.dir-arquivo). 
           ch-sheet = ch-book:worksheets(1).
    
    Assign i-linha = 3
           l-erro  = No.

    FOR EACH tt-fluxo:
        DELETE tt-fluxo.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-prog.
    RUN pi-inicializar IN h-prog (INPUT "Lendo Excel").
    REPEAT:

        RUN pi-acompanhar IN h-prog (INPUT "Linha " + string(i-linha)).
        i-linha = i-linha + 1.

      
        IF ch-sheet:cells(i-linha, 1):TEXT = "" THEN LEAVE.

        CREATE tt-fluxo.
        ASSIGN tt-fluxo.ttv-duplicata   = TRIM(ch-sheet:cells(i-linha, 01):TEXT)
               tt-fluxo.ttv-dt-emissao  = date(TRIM(ch-sheet:cells(i-linha, 02):TEXT))
               tt-fluxo.ttv-vlr         = DEC(TRIM(ch-sheet:cells(i-linha, 03):TEXT))
               tt-fluxo.ttv-dt-vcto     = date(TRIM(ch-sheet:cells(i-linha, 04):TEXT))
               tt-fluxo.ttv-bco         = TRIM(ch-sheet:cells(i-linha, 05):TEXT)
               tt-fluxo.ttv-nro-bcio    = TRIM(ch-sheet:cells(i-linha, 06):TEXT)
               tt-fluxo.ttv-id          = TRIM(ch-sheet:cells(i-linha, 07):TEXT)
               tt-fluxo.ttv-boleto      = TRIM(ch-sheet:cells(i-linha, 08):TEXT)
               tt-fluxo.ttv-NDJ         = TRIM(ch-sheet:cells(i-linha, 09):TEXT).

    END.

    RUN pi-finalizar IN h-prog.

    IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0  THEN DO:
        l-error = YES.

        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            PUT STREAM str-rp UNFORMATTED
                "Linhha com problema: " + string(i-linha) SPACE(5)
                "Codigo erro " + string(ERROR-STATUS:GET-NUMBER(i)) SPACE(5)
                "Erro: " + ERROR-STATUS:GET-MESSAGE(i) SKIP.
        END.
    END.



    IF NOT l-erro THEN DO:
        ch-book:CLOSE(FALSE).
        ch-excel:QUIT().

        RELEASE OBJECT ch-sheet NO-ERROR.
        RELEASE OBJECT ch-book  NO-ERROR.
        RELEASE OBJECT ch-excel NO-ERROR.

        FIND LAST movto_fluxo_cx USE-INDEX mvtflxcx_tip_fluxo NO-LOCK WHERE movto_fluxo_cx.num_fluxo_cx = tt-param.ttv-cod-fluxo
            NO-ERROR .

        ASSIGN i-seq = movto_fluxo_cx.num_seq_movto_fluxo_cx + 10.

        FOR EACH tt-fluxo:


            CREATE movto_fluxo_cx.
            ASSIGN movto_fluxo_cx.num_fluxo_cx = tt-param.ttv-cod-fluxo
                   movto_fluxo_cx.dat_movto_fluxo_cx = tt-fluxo.ttv-dt-vcto
                   movto_fluxo_cx.num_seq_movto_fluxo_cx  = i-seq
                   movto_fluxo_cx.cod_estab               = tt-param.ttv-estab
                   movto_fluxo_cx.cod_unid_negoc          = "ETE"
                   movto_fluxo_cx.cod_tip_fluxo_financ    = "1.2.06.00"
                   movto_fluxo_cx.ind_fluxo_movto_cx      = "SAI"
                   movto_fluxo_cx.ind_tip_movto_fluxo_cx  = "PR"
                   movto_fluxo_cx.cod_modul_dtsul         = "CFL"
                   movto_fluxo_cx.val_movto_fluxo_cx      = tt-fluxo.ttv-vlr
                   movto_fluxo_cx.des_histor_movto_fluxo_cx = "Importa‡Æo de movimento Nosso numero " + tt-fluxo.ttv-nro-bcio + " Emitido em " + STRING(tt-fluxo.ttv-dt-emissao)
                   movto_fluxo_cx.cod_empresa             = "1"
                   movto_fluxo_cx.ind_tip_secao_fluxo_cx  = "Anal¡tica"
                   movto_fluxo_cx.num_id_movto_fluxo_cx   = INT(recid(movto_fluxo_cx)).
                   
                   
                   assign i-seq = i-seq + 10.
                   
                   
                   disp stream str-rp tt-param.ttv-cod-fluxo column-label "Fluxo"
                                      tt-param.ttv-estab     column-label "Estab"
                                      tt-fluxo.ttv-dt-vcto   column-label "Vcto"
                                      tt-fluxo.ttv-vlr with stream-io width 600.

        END.
    END.
