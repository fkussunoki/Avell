/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : utp/utapi013.i
**
** Data : 28/07/2000
**
** Cria‡Æo : Jaime Alex Dambros
**
** Objetivo  : Include de Definicao, utilizada pela API utp/utapi013.p.
**
** Ultima Alt: 
********************************************************************************/

/* Definicao Temp-Table **********************************************************/
define temp-table tt-configuracao no-undo
    field versao-integracao   as integer format ">>9"
    field arquivo-num         as integer format ">9"     initial 1
    field arquivo             as char    format "x(255)" initial "c:~\tmp~\utapi013.xls"
    field total-planilhas     as integer format ">9"     initial 05
    field exibir-construcao   as logical                 initial no
    field abrir-excel-termino as logical                 initial no    
    index tt-configuracao-pri is unique primary 
        versao-integracao
        arquivo-num.

define temp-table tt-configuracao2 no-undo
    field versao-integracao   as integer format ">>9"
    field arquivo-num         as integer format ">9"     initial 1
    field arquivo             as char    format "x(255)" initial "c:~\tmp~\utapi013.xls"
    field total-planilhas     as integer format ">9"     initial 05
    field exibir-construcao   as logical                 initial no
    field abrir-excel-termino as logical                 initial no
    field imprimir            as logical                 initial no
    field orientacao          as integer                 initial 1    
    index tt-configuracao-pri is unique primary 
        versao-integracao
        arquivo-num.

define temp-table tt-planilha no-undo
    field arquivo-num       as integer format ">9"     initial 1
    field planilha-num      as integer format ">9"
    field planilha-nome     as char    format "x(030)"
    field linhas-grade      as logical                 initial no
    field largura-coluna    as decimal format ">>9.99" initial 8.50 extent 256
    field formatar-planilha as logical                 initial yes
    index tt-planilha-pri is unique primary
        arquivo-num
        planilha-num
    index tt-planilha-aux is unique
        arquivo-num
        planilha-nome.

define temp-table tt-planilha2 no-undo
    field arquivo-num       as integer format ">9"     initial 1
    field planilha-num      as integer format ">9"
    field planilha-nome     as char    format "x(030)"
    field linhas-grade      as logical                 initial no
    field largura-coluna    as decimal format ">>9.99" initial 8.50 extent 256
    field formatar-planilha as logical                 initial yes
    FIELD formatar-faixa    AS LOGICAL                 INITIAL NO
    index tt-planilha2-pri is unique primary
        arquivo-num
        planilha-num
    index tt-planilha2-aux is unique
        arquivo-num
        planilha-nome.

define temp-table tt-dados no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    field celula-coluna                 as integer format ">>9"
    field celula-linha                  as integer format ">>>>9"
    field celula-cor-interior           as integer format ">9"     initial 58 /* None */
    field celula-formato                as char    format "x(255)"
    field celula-formula                as char    format "x(255)"
    field celula-alinhamento-horizontal as integer format "9"      initial 4 /* Left */
    field celula-alinhamento-vertical   as integer format "9"      initial 1 /* Bottom */
    field celula-valor                  as char    format "x(255)"
    field celula-fonte-nome             as char    format "x(255)" initial "Times New Roman"
    field celula-fonte-tamanho          as integer format ">9"     initial 10
    field celula-fonte-negrito          as logical                 initial no
    field celula-fonte-italico          as logical                 initial no
    field celula-fonte-sublinhado       as integer format "9"      initial 3 /* None */
    field celula-fonte-cor              as integer format ">9"     initial 57 /* Automatic */
    field celula-tipo-borda-sup         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-inf         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-esq         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-dir         as integer format "9"      initial 7 /* None */
    index tt-dados-pri is unique primary
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha.

DEFINE TEMP-TABLE tt-dados-aux no-undo
	field atributo                      as char
	field seq                           as integer
	field valor                         as char
    field celula-coluna-ini             as integer format ">>9"
    field celula-linha-ini              as integer format ">>>>9"
    field celula-coluna-fim             as integer format ">>9"
    field celula-linha-fim              as integer format ">>>>9"
    index itt-dados-pri is unique primary
		atributo
		valor
		seq
		celula-coluna-ini
		celula-linha-ini
	index itt-dados-aux
		  atributo
		  valor
 		  celula-coluna-fim
          celula-linha-fim.

DEFINE TEMP-TABLE tt-formatar-faixa no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    FIELD faixa-dados                   AS CHAR    FORMAT "x(32)"
    field faixa-cor-interior            as integer format ">9"     initial 58 /* None */
    field faixa-alinhamento-horizontal  as integer format "9"      initial 4 /* Left */
    field faixa-alinhamento-vertical    as integer format "9"      initial 1 /* Bottom */
    field faixa-fonte-nome              as char    format "x(255)" initial "Times New Roman"
    field faixa-fonte-tamanho           as integer format ">9"     initial 10
    field faixa-fonte-negrito           as logical                 initial no
    field faixa-fonte-italico           as logical                 initial no
    field faixa-fonte-sublinhado        as integer format "9"      initial 3 /* None */
    field faixa-fonte-cor               as integer format ">9"     initial 57 /* Automatic */
    field faixa-tipo-borda-sup          as integer format "9"      initial 7 /* None */
    field faixa-tipo-borda-inf          as integer format "9"      initial 7 /* None */
    field faixa-tipo-borda-esq          as integer format "9"      initial 7 /* None */
    field faixa-tipo-borda-dir          as integer format "9"      initial 7 /* None */.

define temp-table tt-grafico no-undo
    field arquivo-num           as integer format ">9"     initial 1
    field planilha-num          as integer format ">9"
    field grafico-nome          as char    format "x(030)"
    field grafico-titulo        as char    format "x(255)"
    field grafico-tipo          as integer format ">9"
    field intervalo-linha-ini   as integer format ">>>>9"  initial 1
    field intervalo-linha-fin   as integer format ">>>>9"  initial 65536
    field intervalo-coluna-ini  as integer format ">>9"    initial 1
    field intervalo-coluna-fin  as integer format ">>9"    initial 255
    field intervalo-tipo        as integer format "9"
    field exibir-legenda        as logical                 initial yes
    field exibir-rotulo-dados   as logical                 initial yes
    index tt-grafico-pri is unique primary
        arquivo-num
        planilha-num
    index tt-grafico-aux is unique
        arquivo-num
        grafico-nome.

define temp-table tt-grafico2 no-undo
    field arquivo-num           as integer format ">9"     initial 1
    field planilha-num          as integer format ">9"
    field grafico-nome          as char    format "x(030)"
    field grafico-titulo        as char    format "x(255)"
    field grafico-tipo          as integer format ">9"
    field intervalo-linha-ini   as integer format ">>>>9"  initial 1
    field intervalo-linha-fin   as integer format ">>>>9"  initial 65536
    field intervalo-coluna-ini  as integer format ">>9"    initial 1
    field intervalo-coluna-fin  as integer format ">>9"    initial 255
    field intervalo-tipo        as integer format "9"
    field exibir-legenda        as logical                 initial yes
    field exibir-rotulo-dados   as logical                 initial yes
    field exibir-eixo-cat-x     as logical                 initial yes
    field exibir-eixo-val-z     as logical                 initial yes
    index tt-grafico-pri is unique primary
        arquivo-num
        planilha-num
    index tt-grafico-aux is unique
        arquivo-num
        grafico-nome.

define temp-table tt-erros no-undo
    field cod-erro   as integer
    field desc-error as char    format "x(256)".
/* Definicao Temp-Table **********************************************************/

/*Altera‡Æo - 14/02/2007 - tech1007 - FO 1438791 - Altera‡Æo para permitir a cria‡Æo de linhas de tendˆncias no gr fico de pontos*/
DEFINE TEMP-TABLE tt-line-series NO-UNDO
    FIELD iType            AS INTEGER INITIAL -4132
    FIELD iOrder           AS INTEGER INITIAL 0
    FIELD iPeriod          AS INTEGER INITIAL 0
    FIELD iForward         AS INTEGER INITIAL 0
    FIELD iBackward        AS INTEGER INITIAL 0
    FIELD lIntercept       AS LOGICAL INITIAL FALSE
    FIELD lDisplayEquation AS LOGICAL INITIAL FALSE
    FIELD lDisplayRSquared AS LOGICAL INITIAL FALSE
    FIELD cName            AS CHAR    INITIAL ""
    FIELD iSerieNumber     AS INTEGER INITIAL 0
    FIELD iArquivo-num     AS INTEGER FORMAT ">9" INITIAL 0
    FIELD iLineColor       AS INTEGER INITIAL 1
    .
/*Fim altera‡Æo 14/02/2007*/

DEFINE TEMP-TABLE tt-formulas no-undo
    FIELD arquivo-num    AS INTEGER FORMAT ">9"
    FIELD planilha-num   AS INTEGER FORMAT ">9"
    FIELD celula-linha   AS INTEGER
    FIELD celula-coluna  AS INTEGER
    FIELD celula-formula AS CHARACTER
    FIELD celula-valor   AS CHARACTER
    INDEX tt-formulas-pri IS UNIQUE PRIMARY
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha
    .

DEFINE TEMP-TABLE tt-imagens no-undo
    FIELD arquivo-num   AS INTEGER FORMAT ">9"
    FIELD planilha-num  AS INTEGER FORMAT ">9"
    FIELD celula-coluna AS INTEGER
    FIELD celula-linha  AS INTEGER
    FIELD arq-path      AS CHARACTER
    INDEX tt-imagens-pri IS UNIQUE PRIMARY
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha
    .

def var h-utapi013 as handle.
