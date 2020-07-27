
def new shared var h-acomp    as handle no-undo.
DEF VAR c-pais-ini AS char.
DEF VAR c-pais-fim AS char.
DEFINE TEMP-TABLE tt-sinief
    FIELD cod-sinief     AS INTEGER    FORMAT "99"                    
    FIELD estado         AS CHARACTER  FORMAT "X(4)"
    FIELD nome-estado    AS CHARACTER  FORMAT "X(20)"
    FIELD de-ac-bicms    AS DEC        FORMAT ">,>>>,>>>,>>9.99999" extent 2 
    FIELD de-ac-isout    AS DEC        FORMAT ">,>>>,>>>,>>9.99999" extent 2
    FIELD de-ac-vlcont   AS DEC        FORMAT ">,>>>,>>>,>>9.99999" extent 2
    FIELD de-ac-icmou    AS DEC        FORMAT ">,>>>,>>>,>>9.99999" extent 2
    FIELD de-ac-icmsub   AS DEC        FORMAT ">,>>>,>>>,>>9.99999" extent 2
    FIELD cfop           AS CHARACTER
    FIELD nat-descricao  AS char.

define temp-table tt-notas 
       field dia  as int format "99"
       field mes  as int format "99"
       field ano  as int format "9999".

def var de-ac-tot-vlcont like doc-fiscal.vl-cont-doc extent 2 no-undo.
def var de-ac-tot-bicms  like doc-fiscal.vl-bicms    extent 2 no-undo.
def var de-ac-tot-icmou  like doc-fiscal.vl-icms     extent 2 no-undo.
def var de-ac-tot-icmsub like doc-fiscal.vl-icms     extent 2 no-undo.

def var c-traco        as char      format "x(132)"   no-undo.
def var c-traco2       as char      format "x(132)"   no-undo.
def var c-outras       as char      format "x(14)"                      no-undo.
def var l-upf          as logical initial no format "Sim/Nao".
def var de-cotacao     as decimal decimals 4 format ">>>,>>>,>>9.9999" init 1.
def var i-ano          as int                format "9999".
def var i-mes          as int                format "99".
def var da-cont        as date               no-undo.
def var c-prog         as character          no-undo.
def var c-naturezas    as character          no-undo.

def var c-nomest       like estabelec.nome                    no-undo.
def var c-insestad     as character      format "x(19)"       no-undo.
def var c-cgc          like doc-fiscal.cgc                    no-undo.

def new shared var i-moeda like moeda.mo-codigo.
def new shared var c-moeda as character format "x(10)".
def var de-conv        as decimal                      init 1.
def var da-iniper      like doc-fisc.dt-emis-doc                          no-undo.
def var da-fimper      like doc-fisc.dt-emis-doc                          no-undo.
def var c-est-ref      like ped-venda.cod-estabel                         no-undo.
def var de-tot-icms    AS DEC FORMAT ">,>>>,>>>,>>9.99999"                no-undo.
def var c-est-ini      as character format "x(2)" label "Estado"          no-undo.
def var c-est-fim      like c-est-ini                                     no-undo.
def var c-est-emp      like doc-fiscal.estado                             no-undo.
def var de-ac-bicms    AS DEC FORMAT ">,>>>,>>>,>>9.99999"       extent 2 no-undo.
def var de-ac-isout    AS DEC FORMAT ">,>>>,>>>,>>9.99999"       extent 2 no-undo.
def var de-ac-vlcont   AS DEC FORMAT ">,>>>,>>>,>>9.99999"       extent 2 no-undo.
def var de-ac-icmou    AS DEC FORMAT ">,>>>,>>>,>>9.99999"       extent 2 no-undo.
def var de-ac-icmsub   AS DEC FORMAT ">,>>>,>>>,>>9.99999"       extent 2 no-undo.
def var da-conversao   as date                                            no-undo.
def var c-titulo-tela  as char.
def var c-saida        as char format "x(40)".
def var c-des          as char format "x(40)".                  
def var l-entrou       as logical init no                                 no-undo.
DEF VAR c-model-docto  as character                                       no-undo. 

find first param-global no-lock no-error.

find first estabelec
     where estabelec.cod-estabel = "MTZ" no-lock.

assign c-nomest   = estabelec.nome
       c-insestad = estabelec.ins-estadual
       c-est-emp  = estabelec.estado
       c-cgc      = if  avail param-global and
                        param-global.formato-id-federal <> "" then
                        string(estabelec.cgc, param-global.formato-id-federal)
                    else estabelec.cgc
       de-ac-vlcont = 0
       de-ac-bicms  = 0
       de-ac-isout  = 0.

ASSIGN c-pais-ini = 'brasil'
       c-pais-fim = 'brasil'
       c-est-ini  = ""
       c-est-fim  = "zzz"
       c-est-ref  = "mtz".


/*** Elimina tt-notas ***/
for each  tt-notas:
    delete tt-notas.
end.

OUTPUT TO c:/desenv/itenx.txt.
ASSIGN da-iniper = 01/01/2020
       da-fimper = 01/31/2020.

/*** Criacao do tt-notas ***/
do da-cont = da-iniper to da-fimper:
   create tt-notas.
   assign tt-notas.dia = day(da-cont)
          tt-notas.mes = month(da-cont)
          tt-notas.ano = year(da-cont).
end.
release tt-notas.

assign c-naturezas = "1".
assign c-outras    =  "        OUTRAS"
                     .

for each tt-notas,
    each  doc-fiscal use-index ch-notas 
    where doc-fiscal.dt-docto    = date(tt-notas.mes,
                                        tt-notas.dia,
                                        tt-notas.ano)
    and (doc-fiscal.tipo-nat    = 1 
    OR  doc-fiscal.tipo-nat    = 3)
    and   doc-fiscal.ind-sit-doc  = 1
    and   doc-fiscal.cod-estabel  = c-est-ref
    and   doc-fiscal.pais        >= c-pais-ini
    and   doc-fiscal.pais        <= c-pais-fim  /* "Brasil" */ NO-LOCK,
    FIRST natur-oper FIELDS(nat-operacao denominacao cd-trib-icm cod-model-nf-eletro cd-situacao char-2)
    WHERE natur-oper.nat-operacao = doc-fiscal.nat-operacao NO-LOCK
    BREAK BY doc-fiscal.pais 
          BY doc-fiscal.estado:
    
        IF TRIM(natur-oper.cod-model-nf-eletro) <> "" THEN                                       
            ASSIGN c-model-docto = natur-oper.cod-model-nf-eletro. /*Pega o Modelo Eletronico*/  
        ELSE                                                                                     
            ASSIGN c-model-docto = STRING(natur-oper.cd-situacao, "99"). /*Pega o Modelo DOC OF*/

    IF c-model-docto = "07"                                                                      
    OR c-model-docto = "57"                                                                      
    OR c-model-docto = "67" THEN                                                                 

        FIND FIRST mgcademp.cidade
            WHERE cidade.cdn-munpio-ibge = INT(SUBSTRING(doc-fiscal.char-1,241,10)) NO-LOCK NO-ERROR.

    IF AVAIL cidade THEN
        find first unid-feder use-index ch-pais 
             where unid-feder.pais = "Brasil"
               and unid-feder.estado = cidade.estado no-lock no-error.
    ELSE 
        find first unid-feder use-index ch-pais 
             where unid-feder.pais = "Brasil"
               and unid-feder.estado = doc-fiscal.estado no-lock no-error.

    IF AVAIL unid-feder 
         AND unid-feder.estado  < c-est-ini 
          OR unid-feder.estado  > c-est-fim THEN NEXT.
            
    FIND FIRST tt-sinief 
         WHERE tt-sinief.estado = unid-feder.estado 
         AND   tt-sinief.cfop   = doc-fiscal.cod-cfop NO-ERROR.

    IF NOT AVAIL tt-sinief THEN
          CREATE tt-sinief.
          ASSIGN tt-sinief.cod-sinief  = unid-feder.cod-sinief
                 tt-sinief.estado      = unid-feder.estado
                 tt-sinief.nome-estado = unid-feder.no-estado
                 tt-sinief.cfop        = doc-fiscal.cod-cfop
                 tt-sinief.nat-descricao = natur-oper.denominacao.
                    
    assign de-conv = 1
           l-entrou = yes.
    
    /*-------MOEDA-------*/
    
    {cdp/cd9600.i "0" "doc-fiscal.dt-docto" "de-conv"}
    
    /*-----------------*/
    
    
    find emitente where
         emitente.cod-emitente = doc-fiscal.cod-emitente no-lock no-error.
    
    IF doc-fiscal.tipo-nat <> 3 THEN DO:
       assign tt-sinief.de-ac-bicms[1]  = tt-sinief.de-ac-bicms[1]  + (doc-fiscal.vl-bicms   / de-conv)
              tt-sinief.de-ac-vlcont[1] = tt-sinief.de-ac-vlcont[1] + ((doc-fiscal.vl-cont-doc - 0))
              tt-sinief.de-ac-bicms[2]  = tt-sinief.de-ac-bicms[2]  + (doc-fiscal.vl-bicms   / de-conv)
              tt-sinief.de-ac-vlcont[2] = tt-sinief.de-ac-vlcont[2] + ((doc-fiscal.vl-cont-doc - 0)). 
    
       assign tt-sinief.de-ac-icmou[1]  = tt-sinief.de-ac-icmou[1]  + (doc-fiscal.vl-icmsou / de-conv)
              tt-sinief.de-ac-icmsub[1] = tt-sinief.de-ac-icmsub[1] + (doc-fiscal.vl-icmsub / de-conv)
              tt-sinief.de-ac-icmou[2]  = tt-sinief.de-ac-icmou[2]  + (doc-fiscal.vl-icmsou / de-conv)
              tt-sinief.de-ac-icmsub[2] = tt-sinief.de-ac-icmsub[2] + (doc-fiscal.vl-icmsub / de-conv).
    
    END.
    ELSE DO:
        IF  natur-oper.cd-trib-icm = 3 THEN
            ASSIGN tt-sinief.de-ac-icmou[1]  = tt-sinief.de-ac-icmou[1]  + (doc-fiscal.vl-cont-doc / de-conv) 
                   tt-sinief.de-ac-icmou[2]  = tt-sinief.de-ac-icmou[2]  + (doc-fiscal.vl-cont-doc / de-conv).
        ELSE
    
        /* N’o considera IPI para notas de servi»o */
        assign tt-sinief.de-ac-vlcont[1] = tt-sinief.de-ac-vlcont[1] + (doc-fiscal.vl-cont-doc / de-conv)
               tt-sinief.de-ac-vlcont[2] = tt-sinief.de-ac-vlcont[2] + (doc-fiscal.vl-cont-doc / de-conv).
    END.
END.

FOR EACH tt-sinief:

    put unformatted tt-sinief.cod-sinief  AT 1
        tt-sinief.nome-estado at 8 format "x(22)"
        tt-sinief.cfop        AT 30 FORMAT "x(10)"
        tt-sinief.nat-descricao AT 40 FORMAT "x(30)".
           
    put unformatted tt-sinief.de-ac-vlcont[1]         format ">>>>>>>>>>>>9.99" at 70
        tt-sinief.de-ac-bicms[1]          format ">>>>>>>>>>>>9.99" at 96
        tt-sinief.de-ac-icmou[1]          format ">>>>>>>>>>>>9.99" at 112
        tt-sinief.de-ac-icmsub[1]         format ">>>>>>>>>>>>9.99" at 128.

    ASSIGN de-ac-vlcont[2] = de-ac-vlcont[2] + tt-sinief.de-ac-vlcont[2] 
           de-ac-bicms[2]  = de-ac-bicms[2]  + tt-sinief.de-ac-bicms[2]  
           de-ac-icmou[2]  = de-ac-icmou[2]  + tt-sinief.de-ac-icmou[2]  
           de-ac-icmsub[2] = de-ac-icmsub[2] + tt-sinief.de-ac-icmsub[2]. 

    ASSIGN tt-sinief.de-ac-vlcont[1]  = 0
           tt-sinief.de-ac-bicms[1]   = 0
           tt-sinief.de-ac-icmou[1]   = 0
           tt-sinief.de-ac-icmsub[1]  = 0.
END.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-total-geral AS CHARACTER FORMAT "X(18)" NO-UNDO.
{utp/ut-liter.i "TOTAL_GERAL" *}
ASSIGN c-lbl-liter-total-geral = TRIM(RETURN-VALUE).
put skip(1)
c-lbl-liter-total-geral + " ...."           at 1
de-ac-vlcont[2]         format ">>>>>>>>>>>>9.99" at 70
de-ac-bicms[2]          format ">>>>>>>>>>>>9.99" at 96
de-ac-icmou[2]          format ">>>>>>>>>>>>9.99" at 112
de-ac-icmsub[2]         format ">>>>>>>>>>>>9.99" at 128.


assign de-ac-vlcont = 0
       de-ac-bicms  = 0
       de-ac-icmou  = 0
       de-ac-icmsub = 0. 



