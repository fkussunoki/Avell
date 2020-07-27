{include/i_dbvers.i}
/****************************************************************************
**
** esof0520.i
**
**************************************************************************/

def buffer b-termo        for termo.
def buffer b-it-doc-fisc  for it-doc-fisc.
def buffer b-doc-fis      for doc-fiscal.
def buffer b-contr-livros for contr-livros.

def {1} temp-table tt-estabelec no-undo
    field cod-estab like estabelec.cod-estabel.

def {1} temp-table tt-cred-com no-undo
    field nat-operacao   like doc-fiscal.nat-operacao
    field vl-icms-com    like doc-fiscal.vl-icms-com
    field c-resumo       as char
    field c-aliquota     as char.

def {1} temp-table w-resumo no-undo
    field natur          like doc-fiscal.nat-operacao
    field aliquota-icm   like doc-fiscal.aliquota-icm
    field vl-contabil    like doc-fiscal.vl-cont-doc
    field vl-bicms       like doc-fiscal.vl-bicms
    field vl-icms        like doc-fiscal.vl-icms
    field vl-icmsnt      like doc-fiscal.vl-icmsnt
    field vl-icmsou      like doc-fiscal.vl-icmsou
    field vl-bipi        like doc-fiscal.vl-bipi
    field vl-ipi         like doc-fiscal.vl-ipi
    field vl-ipint       like doc-fiscal.vl-ipint
    field vl-ipiou       like doc-fiscal.vl-ipiou
    field vl-bsubs       like doc-fiscal.vl-bsubs
    field vl-icmsub      like doc-fiscal.vl-icmsub
    field vl-icms-com    like doc-fiscal.vl-icms-com
    field vl-diferencial as decimal
    field vl-credito     as decimal.    
 
def {1} temp-table tt-tab-ocor no-undo
    field cod-tab   like tab-ocor.cod-tab
    field cod-ocor  like tab-ocor.cod-ocor
    field c-campo1  as char    format "x(8)"
    field c-campo2  as char    format "x(8)"
    field c-campo3  as char    format "x(8)"
    field c-campo4  as char    format "x(8)"
    field c-campo5  as char    format "x(8)"
    field char-1    as char    format "x(255)"
    field da-campo1 as date    format "99/99/9999"
    field da-campo2 as date    format "99/99/9999"
    field da-campo3 as date    format "99/99/9999"
    field da-campo4 as date    format "99/99/9999"
    field da-campo5 as date    format "99/99/9999"
    field de-campo1 as decimal format "->>,>>.99"
    field de-campo2 as decimal format "->>,>>.99"
    field de-campo3 as decimal format "->>,>>.99"
    field de-campo4 as decimal format "->>,>>.99"
    field de-campo5 as decimal format "->>,>>.99"
    field i-campo1  like tab-ocor.i-campo[1] /*as int format "->,>>>,>>9"*/
    field i-campo2  like tab-ocor.i-campo[1] /*as int format "->,>>>,>>9"*/
    field i-campo3  like tab-ocor.i-campo[1] /*as int format "->,>>>,>>9"*/
    field i-campo4  like tab-ocor.i-campo[1] /*as int format "->,>>>,>>9"*/
    field i-campo5  like tab-ocor.i-campo[1] /*as int format "->,>>>,>>9"*/
    field l-campo1  as logical format "Sim/Nao"
    field l-campo2  as logical format "Sim/Nao"
    field l-campo3  as logical format "Sim/Nao"
    field l-campo4  as logical format "Sim/Nao"
    field l-campo5  as logical format "Sim/Nao"
    field descricao like tab-ocor.descricao
    field i-formato as int     format "9"
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel AS CHAR  format "x(05)"
&ELSE
    FIELD cod-estabel AS CHAR  FORMAT "x(3)"
&ENDIF
    index codigo is primary cod-tab c-campo1 c-campo2 i-campo1 l-campo1 l-campo2 l-campo3. 


def {1} var de-acum         as decimal extent 13                   no-undo.
def {1} var de-aliquota     as decimal                             no-undo.
def {1} var l-prim-cred     as log                                 no-undo.
def {1} var l-prim-vlr-cred as log                                 no-undo.
def {1} var i-inicio        as integer                    init 1   no-undo.
def {1} var i-posicao       as integer   extent 18                 no-undo.
def {1} var l-primeiro      as logical                             no-undo.
def {1} var r-tt-tab-ocor   as rowid.
def {1} var de-aux          as decimal   extent 12                 no-undo.
def {1} var c-tot-res       as character format "x(60)"            no-undo.
def {1} var c-desc-tot      as character format "x(62)"            no-undo.
def {1} var l-imp-for       as logical   format "Sim/Nao" init yes no-undo.
def {1} var l-tot-icm       as logical   format "Sim/Nao"          no-undo.
def {1} var l-imp-ins       as logical   format "Sim/Nao" init no  no-undo.
def {1} var l-imp-cnpj      as logical   format "Sim/Nao" init no  no-undo.
def {1} var l-resumo-mes    as logical   format "Sim/Nao" init no  no-undo.
def {1} var l-incentivado   as logical   format "Sim/Nao"          no-undo. 
def {1} var l-previa        as logical   format "Previa/Emissao"  init yes.
def {1} var c-impres-cab    as character format "x(6)"             no-undo.
def {1} var da-ini-cab      as date                                no-undo.

def {1} var i-status        as integer no-undo.
def {1} var l-erro-x        as logical.
def {1} var l-esof0520x       as logical.

def {1} var l-emit-resumo-dec as logical init yes format "Sim/Nao" label "Emite Resumo do Periodo".
def {1} var l-nova-pagina     as logical                        no-undo.
def {1} var l-at-perm         as logical format "Sim/Nao"       no-undo.
def {1} var l-documentos      as logical format "Icms Substituto/Todos Documentos" no-undo.
def {1} var l-separadores     as logical format "Sim/Nao"       no-undo.
def {1} var i-op-rel          as integer   initial 1            no-undo.
def {1} var i-nivel           as integer                        no-undo.
def {1} var c-linha-branco    as character                      no-undo.
def {1} var c-sep             as character format "x" init "|"  no-undo.
def {1} var de-cred-com       like doc-fiscal.vl-icms-com       no-undo.
def {1} var c-desc-res        as character format "x(25)".
def {1} var l-conta-contabil  as logical format "Sim/Nao"       no-undo.
def {1} var i-aux-1           as integer                        no-undo.
def {1} var i-ind1            as integer                        no-undo.
def {1} var l-tem-resumo      as logical                        no-undo.
def {1} var l-imprime         as logical init no                no-undo.
def {1} var c-importacao      as char    format "x(70)"         no-undo.
def {1} var l-resumo          as logical format "Sim/Nao" init no no-undo.
def {1} var l-periodo-ant     as logical format "Sim/Nao" init no no-undo.
def {1} var i-cod-tri         as integer format "9"             no-undo.
def {1} var c-insestad        as character format "x(19)"       no-undo.
def {1} var c-imposto         as character format "x(4)"        no-undo.
def {1} var c-natur           as character format "x(5)"        no-undo.
def {1} var c-est-ini         like estabelec.cod-estabel        no-undo.
def {1} var c-est-fim         like estabelec.cod-estabel        no-undo.
def {1} var c-nomest          like estabelec.nome               no-undo.
def {1} var c-estado          like estabelec.estado             no-undo.
def {1} var c-usuario         as character                      no-undo.
def {1} var de-vl-ipi         like doc-fiscal.vl-ipi            no-undo.
def {1} var de-vl-icms        like doc-fiscal.vl-icms           no-undo.
def {1} var de-vl-bipi        like doc-fiscal.vl-bipi           no-undo.
def {1} var de-vl-bicms       like doc-fiscal.vl-bicms          no-undo.
def {1} var de-vl-bsubs       like doc-fiscal.vl-bsubs          no-undo.
def {1} var de-vl-ipint       like doc-fiscal.vl-ipint          no-undo.
def {1} var de-vl-ipiou       like doc-fiscal.vl-ipiou          no-undo.
def {1} var de-vl-icmsnt      like doc-fiscal.vl-icmsnt         no-undo.
def {1} var de-vl-icmsou      like doc-fiscal.vl-icmsou         no-undo.
def {1} var de-vl-icmsub      like doc-fiscal.vl-icmsub         no-undo.
def {1} var de-vl-icms-com    like doc-fiscal.vl-icms-com       no-undo.
def {1} var i-num-pag         like contr-livros.nr-ult-pag      no-undo.
def {1} var c-cgc             like estabelec.cgc                no-undo.
def {1} var l-prim-txt        as logical init yes               no-undo.
def {1} var l-prim-vlr        as logical init yes               no-undo.
def {1} var l-imprimiu-icm    as logical                        no-undo.
def {1} var c-obs-total       as character format "x(152)"      no-undo.
def {1} var da-est-ini        as date      format "99/99/9999".
def {1} var da-est-fim        as date      format "99/99/9999".
def {1} var da-icm-ini        as date.
def {1} var da-icm-fim        as date.
def {1} var c-cgc-1           as character format "x(12)"       no-undo.
def {1} var c-fornecedor      as character format "x(12)"       no-undo.
def {1} var c-observa         as character format "x(19)"       no-undo.
def {1} var c-ins-est         as character format "x(14)"       no-undo.
def {1} var c-titulo          as character format "x(43)"       no-undo.
def {1} var c-titulo-estado   as char      format "x(70)"       no-undo.

/*** vari veis do formato cfop ***/
def {1} var c-cfop            as character format "x(07)"       no-undo.
def {1} var c-formato-cfop    as character                      no-undo.
def {1} var i-formato-cfop    as integer                        no-undo.

/**** variavies de totais ****/

def {1} var de-tot-bicms    like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-icms     like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-icmsou   like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-icmsnt   like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-bicmsub  like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-icmsub   like it-doc-fisc.vl-icms-it no-undo.
                            
def {1} var de-tot-bipi     like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-ipi      like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-ipiou    like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-ipint    like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-comple   like it-doc-fisc.vl-icms-it no-undo.
def {1} var de-tot-obs      like it-doc-fisc.vl-icms-it no-undo.

/* defini‡Æo de vari veis para utiliza‡Æo da impressÆo dos valores do ipi 
   pelos programas esof0520f e esof0520f1 */
   
def {1} var de-vl-ipi-it    like it-doc-fisc.vl-ipi-it    no-undo.
def {1} var de-vl-bipi-it   like it-doc-fisc.vl-bipi-it   no-undo.
def {1} var de-vl-ipint-it  like it-doc-fisc.vl-ipint-it  no-undo.
def {1} var de-vl-ipiou-it  like it-doc-fisc.vl-ipiou-it  no-undo.
def {1} var de-vl-bsubs-it  like it-doc-fisc.vl-bsubs-it  no-undo.
def {1} var de-vl-icmsub-it like it-doc-fisc.vl-icmsub-it no-undo.

{include/tt-edit.i}
{include/pi-edit.i}

/***********************/
/* Definicao de frames */
/***********************/

form header
   c-titulo at 15
   "*------------ (a) - CODIGOS DE VALORES FISCAIS -----------*" at 74 skip
   "* 1 - OPERACOES COM CREDITO DO IMPOSTO                    *" at 74 skip
   "FIRMA:" at 1 c-nomest
   "* 2 - OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUT. *" at 74 skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc 
   "* 3 - OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS           *" at 74 skip
   trim(c-impres-cab) + ": " + string(i-num-pag,">>>,>>9") format "x(17)" at 1  "MES OU PERIODO/ANO:" at 25 da-est-ini
   format "99/99/9999"
    "A" at 56 da-est-fim format "99/99/9999"
   "*---------------------------------------------------------*" at 74 skip(1)
   "*----- DOCUMENTOS FISCAIS ----*"                               at 10
   "*------- V A L O R E S  F I S C A I S -------*"                at 73
   "DATA DE      SERIE          DATA DO   CODIGO   UF      VALOR     CODIFICACAO"
   at 1
   "               BASE CALCULO         IMPOSTO"
   "ENTRADA  ESP SUB-   NUMERO  DOCUMENTO EMITENTE ORIG   CONTABIL CONTABIL  FISCAL"                                      
   at 1
   "ICMS COD OU VALOR DA ALIQ    CREDITADO  OBSERVACOES" at 81
   c-fornecedor at 1 "SERIE"   at 14 
   "IPI  (a)    OPERACAO" at 81 skip
   c-cgc-1      at 1 
   c-ins-est    at 42
   "ST"         at 81 
   " "          at 132 
   skip(01)
   with stream-io no-box page-top no-labels width 132 frame f-cab.

form header
   c-titulo at 15
   "*------------ (a) - CODIGOS DE VALORES FISCAIS -----------*" at 74 skip
   "* 1 - OPERACOES COM CREDITO DO IMPOSTO                    *" at 74 skip
   "FIRMA:" at 1 c-nomest
   "* 2 - OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUT. *" at 74 skip
   "INSCR. EST.:" at 1 c-insestad  "CNPJ:" at 36 c-cgc
   "* 3 - OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS           *" at 74 skip
   trim(c-impres-cab) + ": " +  string(i-num-pag,">>>,>>9") format "x(17)" at 1 "PERIODO:" at 36 da-est-ini format "99/99/9999"
   "A" at 56 da-est-fim format "99/99/9999"
   "*---------------------------------------------------------*"   at 74 skip(1)
   "*----- DOCUMENTOS FISCAIS ----*"                               at 10
   " *------- V A L O R E S  F I S C A I S -------*"               at 75
   "DATA DE      SER             DATA DO  COD      UF       VALOR      CODIFICACAO"    at 1
   "                    BASE CALCULO              IMPOSTO"
   "                SUBST" 
   "ENTRADA  ESP SUBSER   NR.   DOCUMENTO EMIT    ORIGEM  CONTABIL      CONTABIL     FISCAL" at 1
   "ICMS COD    OU VALOR DA   ALIQ     CREDITADO"               at 83
   "   BASE SUBST  TRIBUTARIA O B S E R V ."
   c-fornecedor at 1
   c-cgc-1      at 42
   c-ins-est    at 63
   "IPI  (a)      OPERACAO"  at 83 
   " "          at 170
   "ST" at 83 
   skip(01)
   with stream-io no-box page-top no-labels width 170 frame f-cab-exp.

form header
   fill ("-",132) format "x(132)"   at  1 skip
   "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - "   at 36
   c-desc-res skip
   fill("-",132) format "x(132)"    at  1 skip(1)
   "CFOP  NATUREZA" at  1
   " VALOR CONTABIL        COD(a)        BASE CALCULO  ALIQ.    IMPOSTO CREDIT"
   at 43 skip(1)
   with stream-io no-box page-top no-labels width 132 frame f-cab-res.

form header
   fill("-",166) format "x(166)" at 1 skip
   "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - " at 36
   c-desc-res skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "CFOP  NATUREZA" at 1
   " VALOR CONTABIL   COD(*)        BASE CALCULO  ALIQ.   IMPOSTO CREDIT"
   at 43
   "BASE SUBST         VALOR SUBST" at 118 skip(1)
   with stream-io no-box page-top no-labels width 170 frame f-res-sub.
                                                         
form header
   fill ("-",132) format "x(132)"   at  1 skip
   /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
   c-titulo-estado at 15 format "x(70)" skip
   fill("-",132) format "x(132)"    at  1 skip(1)
   "ESTADO" at  1
   " VALOR CONTABIL       ICMS       BASE CALCULO            VALOR IMPOSTO"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   "ST" at 65 
   skip(1)
   with stream-io no-box page-top no-labels width 132 frame f-cab-uf.

form header
   fill("-",166) format "x(166)" at 1 skip
   /* "OPERACOES INTERESTADUAIS - DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
   c-titulo-estado at 15 format "x(70)" skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "ESTADO" at 1
   " VALOR CONTABIL       ICMS       BASE CALCULO            VALOR IMPOSTO"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   "ST" at 65 
   skip(1)
   with stream-io no-box page-top no-labels width 170 frame f-res-uf.

form header
   fill ("-",132) format "x(132)"   at  1 skip
   /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
   c-titulo-estado at 15 format "x(70)" skip
   fill("-",132) format "x(132)"    at  1 skip(1)
   "ESTADO" at  1
   " VALOR CONTABIL                  BASE CALCULO              VALOR SUBST"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   skip(1)
   with stream-io no-box page-top no-labels width 132 frame f-cab-uf2.

form header
   fill("-",166) format "x(166)" at 1 skip
   /* "OPERACOES INTERESTADUAIS - DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
   c-titulo-estado at 15 format "x(70)" skip
   fill("-",166) format "x(166)" at 1 skip(1)
   "ESTADO" at 1
   " VALOR CONTABIL                  BASE CALCULO              VALOR SUBST"
   at 43 
   "OUTRAS"
   at 127
   "ORIGEM" at 1
   skip(1)
   with stream-io no-box page-top no-labels width 170 frame f-res-uf2.

form header
    ("+" + fill("-",130) + "+") at 1 format "x(132)"
    "|" at 1
    (fill(" ",integer((71 - length(trim(c-titulo))) / 2)) + trim(c-titulo))
    at 2 format "x(71)"
    "|             (a) - CODIGOS DE VALORES FISCAIS             |" at 73
    "|" at 1
    "|----------------------------------------------------------|" at 73
    "|FIRMA: "  at 1 c-nomest
    "|1- OPERACOES COM CREDITO DO IMPOSTO                       |" at 73
    "|INSCR. EST.: " at 1 c-insestad
    "CNPJ: " at 37 c-cgc
    "|2- OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUTADAS |" at 73
    "|" + trim(c-impres-cab) + ":  " + string(i-num-pag,">>>,>>9") format "x(17)" at 1
    "MES OU PERIODO/ANO: " at 26 da-est-ini " A " da-est-fim
    "|3- OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS              |" at 73
    ("|" + fill("-",130) + "|") at 1 format "x(132)"
    with stream-io no-box page-top no-labels width 132 frame f-cab-diag.

form header
    "|        |          DOCUMENTOS FISCAIS             |" at 1
    "|      CODIFICACAO     |       V A L O R E S  F I S C A I S      |" at 67
    "|        |-----------------------------------------|" at 1
    "  |----------------------+-----------------------------------------|" at 65
    "|DATA DE |   |     |         |        |         |  |  VALOR       |"  at 1
    "|      |    |   | BASE CALCULO |     |           |"                   at 83
    "|ENTRADA |   |SERIE|         |DATA  DO|CODIGO   |UF|"                 at 1
    "|               |      |ICMS|COD| OU VALOR DA  |     | IMPOSTO   |"   at 67
    "|        |ESP|SUB- |  NUMERO |  DOCTO |EMITENTE |OR| CONTABIL"        at 1 
    "|    CONTABIL   |FISCAL|IPI |(a)|   OPERACAO   |ALIQ |CREDITADO  |"   at 67 
    "|        |   |SERIE|         |        |         |  |"                 at 1
    "|               |      |ST  |   |              |     |           |"   at 67
    ("|" + fill("-",130) + "|") at 1 format "x(132)" skip 
   with stream-io no-box page-top no-labels width 132 frame f-scab-diag.

form header
  ("+" + fill("-",157) + "+") at 1 format "x(159)"
  "|" at 1
  (fill(" ",integer((98 - length(trim(c-titulo))) / 2)) + trim(c-titulo))
  at 2 format "x(98)"
  "|             (a) - CODIGOS DE VALORES FISCAIS            |" at 101
  "|" at 1
  "|---------------------------------------------------------|" at 101
  "|FIRMA: "  at 1 c-nomest
  "|1- OPERACOES COM CREDITO DO IMPOSTO                      |" at 101
  "|INSCR. EST.: " at 1 c-insestad
  "CNPJ: " at 37 c-cgc
  "|2- OPER. SEM CRED. DO IMPOSTO - ISENTAS OU NAO TRIBUTADAS|" at 101
  "|" + trim(c-impres-cab) + ":  " + string(i-num-pag,">>>,>>9") format "x(17)" at 1
  "MES OU PERIODO/ANO: " at 26 da-est-ini " A " da-est-fim
  "|3- OPERACOES SEM CREDITO DO IMPOSTO - OUTRAS             |" at 101
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
 with stream-io no-box page-top no-labels width 160 frame f-cab-diag-e.

form header  
  "|        |           DOCUMENTOS FISCAIS          |" at 1
  "|      CODIFICACAO      |" at 62
  "V A L O R E S  F I S C A I S                      |" at 109
  "|        |---------------------------------------|" at 1
  "|------------------------" at 62
  "+-----------------------------------------------------------------------|"
  at 87 
  "|DATA DE |   |     |         |        |         |  |  VALOR    |" at 1
  "|      |    |   | BASE CALCULO |     |             |             |             |" 
  at 80
  "|ENTRADA |   |SERIE|         |DATA  DO|CODIGO   |UF|" at 1
  "|                 |      |ICMS|COD| OU VALOR DA  |     |  IMPOSTO    |" at 62
  " BASE        | SUBST       |" at 132
  "|        |ESP|SUB- | NUMERO  |  DOCTO |EMITENTE |OR| CONTABIL" at 1 
  "|    CONTABIL    |FISCAL|IPI |(a)|   OPERACAO   |ALIQ |  CREDITADO  |" at 62
  " SUBST       | TRIBUTARIA  |" at 132 
  "|        |   |SERIE|         |        |         |  |" at 1
  "|                |      |ST  |   |              |     |             |" at 62
  "             |             |" at 132
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  with stream-io no-box page-top no-labels width 160 frame f-scab-diag-e.

form header
  "|" at 1
  "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - " at 36
  c-desc-res
  "|" at 132
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  "|CFOP    |                      NATUREZA                        " at 1
  "| VALOR CONTABIL |ICMS|COD|BASE DE CALCULO |ALIQ |     IMPOSTO    |" at 66
  "|" at 1
  "|" at 10
  "|" at 66
  " |IPI |(a)|                |     |    CREDITADO   |" at 82
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  with stream-io no-box page-top no-labels width 132 frame f-scab-res.

form header
  "|" at 1
  "RESUMO DE OPERACOES E PRESTACOES POR CODIGO FISCAL (CFOP) - " at 50
  c-desc-res
  "|" at 159
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  "|CFOP|                      NATUREZA" at 1
  "| VALOR CONTABIL |ICMS|COD|BASE DE CALCULO |ALIQ |     IMPOSTO    |" at 59
  "BASE      |     VALOR      |" at 132
  "|" at 1
  "|" at 6
  "|" at 59
  "|IPI |(a)|                |     |    CREDITADO   |" at 76
  "SUBSTITUICAO  |  SUBSTITUICAO  |" at 128
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  with stream-io no-box page-top no-labels width 159 frame f-scab-res-e.

form header
  "|" at 1
  /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
  c-titulo-estado at 15 format "x(70)"
  "|" at 132 
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  "|ESTADO DE ORIGEM" at 1
  "| VALOR CONTABIL |BASE DE CALCULO |  VALOR SUBST   |     OUTRAS      |" at 63
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  with stream-io no-box page-top no-labels width 132 frame f-scab-uf.

form header
  "|" at 1
  /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
  c-titulo-estado at 15 format "x(70)" 
  "|" at 159 
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  "|ESTADO DE ORIGEM" at 1
  "| VALOR CONTABIL |BASE DE CALCULO |  VALOR SUBST   |     OUTRAS     |" at 91
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  with stream-io no-box page-top no-labels width 159 frame f-scab-uf-e.

form header
  "|" at 1
  /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
  c-titulo-estado at 15 format "x(70)" 
  "|" at 132 
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  "|ESTADO DE ORIGEM" at 1
  "| VALOR CONTABIL |ICMS|BASE DE CALCULO |     VALOR      |     OUTRAS      |" 
  at 58
  "|" at 1 
  "|" at 58
  "|ST  |                |    IMPOSTO     |                 |" at 75
  ("|" + fill("-",130) + "|") at 1 format "x(132)"
  with stream-io no-box page-top no-labels width 132 frame f-scab-uf2.

form header
  "|" at 1
  /* "OPERACOES INTERESTADUAIS   DEMONSTRATIVO DE ICMS POR ESTADO DE ORIGEM" */
  c-titulo-estado at 15 format "x(70)"
  "|" at 159 
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  "|ESTADO DE ORIGEM" at 1
  "| VALOR CONTABIL |ICMS|BASE DE CALCULO |     VALOR      |     OUTRAS     |" 
  at 86
  "|" at 1 
  "|" at 86
  "|ST  |                |    IMPOSTO     |                |" at 103
  ("|" + fill("-",157) + "|") at 1 format "x(159)"
  with stream-io no-box page-top no-labels width 159 frame f-scab-uf2-e.

form header
  ("+" + fill("-",130) + "+") at 1 format "x(132)"
  with stream-io no-box page-bottom no-labels width 132 frame f-bottom.

form header
  ("+" + fill("-",157) + "+") at 1 format "x(159)"
  with stream-io no-box page-bottom no-labels width 159 frame f-bottom-e.

form
  space(25) tt-editor.conteudo format 'x(83)'
  with stream-io down width 132 frame f-imp.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-imp:HANDLE).

  
/* esof0520.I */
