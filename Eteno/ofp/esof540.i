{include/i_dbvers.i}
/****************************************************************************
**
** esof0540.i
**
**************************************************************************/

def buffer b-termo        for termo.
def buffer b-it-doc-fisc  for it-doc-fisc.
def buffer b-doc-fis      for doc-fiscal.
def buffer b-contr-livros for contr-livros.

def {1} temp-table w-estabel NO-UNDO
    field cod-estab like estabelec.cod-estabel.

def {1} temp-table tt-tab-ocor NO-UNDO
    field cod-tab     as integer format ">>9"
    field c-campo     as char    format "x(8)"       extent 5
    field cod-ocor    as integer format ">>9"
    field da-campo    as date    format "99/99/9999" extent 5
    field de-campo    as decimal format "->>,>>9.99" extent 5
    field descricao   as char    format "x(30)"
    field i-campo     as integer format "->,>>>,>>9" extent 5
    field l-campo     as logical extent 5
    field i-formato   as int     format "9"
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel AS CHAR    format "x(05)".
&ELSE
    FIELD cod-estabel AS CHAR    FORMAT "x(3)".
&ENDIF

def {1} var l-conta-contabil as logical                          no-undo format "Sim/Nao".
def {1} var i-aux            as integer                          no-undo.
def {1} var c-localiz        as integer format "9"               no-undo.
def {1} var i-ind1           as integer                          no-undo.
def {1} var l-tem-resumo     as logical                          no-undo.
def {1} var l-imprime        as logical init no                  no-undo.
def {1} var l-resumo         as logical format "Sim/Nao" init no no-undo.
def {1} var l-periodo-ant    as logical format "Sim/Nao" init no no-undo.
def {1} var i-cod-tri        as integer format "9"               no-undo.
def {1} var c-insestad       as character format "x(19)"         no-undo.
def {1} var c-imposto        as character format "x(4)"          no-undo.
def {1} var c-cfop           as character format "x(07)"         no-undo.
def {1} var c-natur          as character format "x(5)"          no-undo.
def {1} var c-est-ini        like estabelec.cod-estabel          no-undo.
def {1} var c-est-fim        like estabelec.cod-estabel          no-undo.
def {1} var c-nomest         like estabelec.nome                 no-undo.
def {1} var c-estado         like estabelec.estado               no-undo.
def {1} var c-usuario        as character                        no-undo.
def {1} var de-vl-ipi        like doc-fiscal.vl-ipi              no-undo.
def {1} var de-vl-icms       like doc-fiscal.vl-icms             no-undo.
def {1} var de-vl-bipi       like doc-fiscal.vl-bipi             no-undo.
def {1} var de-vl-bicms      like doc-fiscal.vl-bicms            no-undo.
def {1} var de-vl-bsubs      like doc-fiscal.vl-bsubs            no-undo.
def {1} var de-vl-ipint      like doc-fiscal.vl-ipint            no-undo.
def {1} var de-vl-ipiou      like doc-fiscal.vl-ipiou            no-undo.
def {1} var de-vl-icmsnt     like doc-fiscal.vl-icmsnt           no-undo.
def {1} var de-vl-icmsou     like doc-fiscal.vl-icmsou           no-undo.
def {1} var de-vl-icmsub     like doc-fiscal.vl-icmsub           no-undo.
def {1} var de-vl-icms-com   like doc-fiscal.vl-icms-com         no-undo.
def {1} var i-num-pag        like contr-livros.nr-ult-pag        no-undo.
def {1} var c-cgc            like estabelec.cgc format "x(18)"   no-undo.
def {1} var l-prim-txt       as logical init yes                 no-undo.
def {1} var l-prim-vlr       as logical init yes                 no-undo.
def {1} var l-imprimiu-icm   as logical                          no-undo.
def {1} var c-obs-total      as character format "x(152)"        no-undo.
def {1} var da-est-ini       as date                             no-undo.
def {1} var da-est-fim       as date                             no-undo.
def {1} var da-icm-ini       as date                             no-undo.
def {1} var da-icm-fim       as date                             no-undo.
def {1} var c-cgc-1          as character format "x(12)"         no-undo.
def {1} var c-fornecedor     as character format "x(12)"         no-undo.
def {1} var c-observa        as character format "x(19)"         no-undo.
def {1} var c-ins-est        as character format "x(14)"         no-undo.
def {1} var c-titulo         as character format "x(43)"         no-undo.
def frame f-cab     with stream-io.
def frame f-cab-exp with stream-io.

form header
   c-titulo at 15
   "*------------ (a) - CODIGOS DE VALORES FISCAIS -----------*" at 94 skip
   "* 1 - OPERACOES COM CREDITO DO IMPOSTO                    *" at 94 skip
   "FIRMA:" at 1 c-nomest
   "* 2 - OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUT. *" at 94 skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc
   "* 3 - OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS           *" at 94 skip
   "FOLHA:" at 1 i-num-pag "MES OU PERIODO/ANO:" at 25 da-est-ini
   format "99/99/9999"
    "A" at 56 da-est-fim format "99/99/9999"
   "*---------------------------------------------------------*" at 94 skip(1)
   "*----- DOCUMENTOS FISCAIS ----*"                               at 10
   "*--- ICMS VALORES  FISCAIS ---*  *--- IPI VALORES FISCAIS ---* " at 83
   "DATA DE      SERIE         DATA DO    CODIGO   UF   VALOR       CODIFICACAO    "
   at 1
   "COD  BASE CALCULO/         IMPOSTO  COD  BASE CALCULO/  IMPOSTO"
   "ENTRADA  ESP SUB-   NUMERO DOCUMENTO  EMITENTE ORIG  CONTABIL    CONTABIL  FISCAL"
   at 1
   "(a)   VALOR OPERAC  ALIQ CREDITADO  (a)  VALOR OPERAC CREDITADO OBSERVACOES"
   c-fornecedor at 1 "SERIE"   at 14  skip
   c-cgc-1      at 1 
   c-ins-est    at 42 
   " "          at 132 
   skip(01)
   with no-box page-top no-labels width 170 stream-io frame f-cab.

form header
   c-titulo at 15
   "*------------ (a) - CODIGOS DE VALORES FISCAIS -----------*" at 74 skip
   "* 1 - OPERACOES COM CREDITO DO IMPOSTO                    *" at 74 skip
   "FIRMA:" at 1 c-nomest
   "* 2 - OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUT. *" at 74 skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc
   "* 3 - OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS           *" at 74 skip
   "FOLHA:" at 1 i-num-pag "PERIODO:" at 36 da-est-ini format "99/99/9999"
   "A" at 56 da-est-fim format "99/99/9999"
   "*---------------------------------------------------------*"   at 74 skip(1)
   "*----- DOCUMENTOS FISCAIS ----*"                               at 10
   " *------- V A L O R E S  F I S C A I S -------*"               at 75
   "DATA DE      SER          DATA DO  COD    UF       VALOR      CODIFICACAO"  at 1
   "ICMS COD    BASE CALCULO/            IMPOSTO                SUBST" at 83
   "ENTRADA  ESP SUBSER NR.  DOCUMENTO EMIT ORIGEM  CONTABIL        CONTABIL   FISCAL" at 1
   "IPI  (a)    VALOR OPERAC  ALIQ     CREDITADO"               at 83
   "   BASE SUBST  TRIBUTARIA O B S E R V ."
   c-fornecedor at 1
   c-cgc-1      at 42
   c-ins-est    at 63
   "ST"         at 83 skip
   " "          at 170
   skip(01)
   with no-box page-top no-labels width 170 stream-io frame f-cab-exp.

def {1} var c-desc-res  as character format "x(20)".

def frame f-cab-res  with stream-io.
def frame f-cab-res2 with stream-io.
def frame f-cab-uf   with stream-io.
def frame f-res-sub  with stream-io.
def frame f-res-sub2 with stream-io.
def frame f-res-uf   with stream-io.

form header
   c-titulo at 15
   "FIRMA:" at 1 c-nomest skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc skip
   "FOLHA:" at 1 i-num-pag "MES OU PERIODO/ANO:" at 25 da-est-ini format "99/99/9999"
   "A" at 56 da-est-fim format "99/99/9999"
   fill ("-",170) format "x(170)"   at  1 skip
   "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - "   at 36
   c-desc-res skip
   fill("-",170) format "x(170)"    at  1 skip(1)
   "CFOP  NATUREZA" at  1
   " VALOR CONTABIL COD(a)   BASE CALCULO  ALIQ.IMPOSTO CREDITADO COD(a)   BASE CALCULO IMPOSTO CREDITADO "    at 43 skip(1)
   with no-box page-top no-labels width 170 stream-io frame f-cab-res.

form header
   fill("-",166) format "x(166)" at 1 skip
   "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - " at 36
   c-desc-res skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "CFOP  NATUREZA" at 1
   " VALOR CONTABIL   COD(*)        BASE CALCULO  ALIQ.   IMPOSTO CREDIT"
   at 43
   "BASE SUBST         VALOR SUBST" at 118 skip(1)
   with no-box page-top no-labels width 170 stream-io frame f-res-sub.
                                                         
form header
   c-titulo at 15 skip
   "FIRMA:" at 1 c-nomest skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc skip
   "FOLHA:" at 1 i-num-pag "MES OU PERIODO/ANO:" at 25 da-est-ini format "99/99/9999"
   "A" at 56 da-est-fim format "99/99/9999" skip
   fill ("-",132) format "x(132)"   at  1 skip
   "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM"
   at 32 skip
   fill("-",132) format "x(132)"    at  1 skip(1)
   "ESTADO" at  1
   " VALOR CONTABIL       ICMS       BASE CALCULO            VALOR IMPOSTO"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   "ST" at 65 
   skip(1)
   with no-box page-top no-labels width 132 stream-io frame f-cab-uf.

form header
   fill("-",166) format "x(166)" at 1 skip
   "OPERACOES INTERESTADUAIS - DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM"
   at 32 skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "ESTADO" at 1
   " VALOR CONTABIL       ICMS       BASE CALCULO            VALOR IMPOSTO"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   "ST" at 65 
   skip(1)
   with no-box page-top no-labels width 170 stream-io frame f-res-uf.

form header
   fill ("-",132) format "x(132)"   at  1 skip
   "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM"
   at 32 skip
   fill("-",132) format "x(132)"    at  1 skip(1)
   "ESTADO" at  1
   " VALOR CONTABIL                  BASE CALCULO              VALOR SUBST"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   skip(1)
   with no-box page-top no-labels width 132 stream-io frame f-cab-uf2.

form header
   fill("-",166) format "x(166)" at 1 skip
   "OPERACOES INTERESTADUAIS - DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM"
   at 32 skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "ESTADO" at 1
   " VALOR CONTABIL                  BASE CALCULO              VALOR SUBST"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   skip(1)
   with no-box page-top no-labels width 170 stream-io frame f-res-uf2.
/* esof0540.I */
