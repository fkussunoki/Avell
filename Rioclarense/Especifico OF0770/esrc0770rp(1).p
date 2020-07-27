
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i OF0770RP 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i of0770rp MOF}
&ENDIF
 
{include/i_fnctrad.i}
/********************************************************************************
** Copyright DATASUL S.A. (2004)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*** defini»’o de pre-processador ***/
{cdp/cdcfgdis.i} 

{utp/utapi013.i} 
define temp-table tt-param  no-undo
    field destino            as integer
    field arquivo            as char format "x(35)":U
    field usuario            as char format "x(12)":U
    field data-exec          as date
    field hora-exec          as integer
    FIELD dt-periodo-ini     AS DATE FORMAT "99/99/9999"
    FIELD dt-periodo-fim     AS DATE FORMAT "99/99/9999"
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel        AS CHAR format "x(05)"
&ELSE                       
    FIELD cod-estabel        AS CHAR FORMAT "x(03)"
&ENDIF                      
    FIELD rs-modo            AS INTEGER
    FIELD rs-relatorio       AS INTEGER.

DEF TEMP-TABLE tt-doc-fiscal NO-UNDO 
    FIELD tipo-apuracao      AS INTEGER 
    FIELD nr-doc-fisc        AS CHARACTER
    FIELD nat-operacao       AS CHARACTER
    FIELD serie              AS CHARACTER
    FIELD emitente           AS INTEGER
    FIELD estab              AS CHARACTER
    FIELD l-valor            AS LOGICAL /* Variavel que define se o documento possui valor de pis ou cofins */
    INDEX selecao estab 
                  serie       
                  nr-doc-fisc 
                  emitente    
                  nat-operacao  
                  tipo-apuracao.

/*** defini»’o de variÿveis locais ***/
DEF VAR h-acomp             AS HANDLE                                              NO-UNDO. 
def var c-cod-fisc          as char format "x(27)"                                 no-undo.
def var de-vl-contab        as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-base-pis         as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-base-cofins      as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-vl-pis           as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-vl-cofins        as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var c-desc-nat          as char format "x(40)"                                 no-undo.
def var c-inscricao         as char format "x(19)"                                 no-undo.
def var c-cgc               like estabelec.cgc                                     no-undo.
def var c-iniper            as char format "99/99"                                 no-undo.
def var c-fimper            as char format "x(10)"                                 no-undo.
def var c-cod-est           like estabelec.cod-estabel                             no-undo.
def var de-acm-ct1          as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-bsipi        as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-bcof         as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-vlipi        as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-vlcof        as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-vlipi-ent    as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-acm-vlcof-ent    as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-saldo-cre-pi     as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-saldo-de-pi      as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-saldo-cre-cof    as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-saldo-de-cof     as dec  format '->,>>>,>>>,>>9.99'                     no-undo.
def var de-cotacao          as dec decimals 4 format ">>>,>>>,>>9.9999" init 1     no-undo.
def var de-conv             as dec init 1                                          no-undo.
def var c-estabel           like estabelec.nome                                    no-undo.
def var c-saida             as char format "x(40)"                                 no-undo.
def var c-des               as char format "x(40)"                                 no-undo.                  
def var c-modo              as char format "x(25)"                                 no-undo.
def var c-rel               as char format "x(25)"                                 no-undo.
def var l-mostra            as logical initial YES                                 no-undo.
def var da-dt-cfop          as date                                                no-undo.
def var c-desc-cfop-nat     as char                                                no-undo.
def var l-cabec             as logical initial no                                  no-undo.
def var n-val-pis           as decimal                                             no-undo.
def var n-val-cofins        as decimal                                             no-undo.
def var n-val-retenc-pis    as dec                                                 no-undo.
def var n-val-retenc-cofins as dec                                                 no-undo.
def var dt-cont             as date                                                no-undo.                                                                                
def var c-lb-cof            as char format "x(10)"                                 no-undo.
def var c-lb-pis            as char format "x(10)"                                 no-undo.
def var c-lb-tot-entr       as char format "x(24)"                                 no-undo.
def var c-lb-tot-sai        as char format "x(24)"                                 no-undo.
def var c-lb-sal-cre        as char format "x(24)"                                 no-undo. 
def var c-lb-sal-dev        as char format "x(24)"                                 no-undo.
def var c-resumo            as char format "x(24)"                                 no-undo.
def var c-lb-tot-entradas   as char format "x(24)"                                 no-undo.
def var c-lb-tot-saidas     as char format "x(24)"                                 no-undo.
DEF VAR tipo                AS INTEGER                                             NO-UNDO.

def var v_saidas_base_pis as dec  format '->,>>>,>>>,>>9.99'.
def var v_saidas_base_cofins as dec  format '->,>>>,>>>,>>9.99'.
def var v_entradas_base_pis as dec  format '->,>>>,>>>,>>9.99'.
def var v_entradas_base_cofins as dec  format '->,>>>,>>>,>>9.99'.
def var v_entradas_pis as dec format '->,>>>,>>>,>>9.99'.
def var v_entradas_cofins as dec format '->,>>>,>>>,>>9.99'.
def var v_saidas_pis as dec format '->,>>>,>>>,>>9.99'.
def var v_saidas_cofins as dec format '->,>>>,>>>,>>9.99'.
def var v_entradas as dec format '->,>>>,>>>,>>9.99'.
def var v_saidas as dec format '->,>>>,>>>,>>9.99'.
def var h_acomp as handle.




def buffer b-natur-oper for natur-oper.
/* Transfer Definitions */

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR i-linha AS INTEGER.
ASSIGN i-linha = 1.


run utp/ut-acomp.p persistent set h-acomp.

/*SYSTEM-DIALOG PRINTER-SETUP.*/
os-delete value("c:\temp\esrc770.xlsx").

empty temp-table tt-configuracao2.
empty temp-table tt-planilha2.
empty temp-table tt-dados.


CREATE tt-configuracao2.
ASSIGN tt-configuracao2.versao-integracao   = 1
       tt-configuracao2.arquivo-num         = 1
       tt-configuracao2.arquivo             = "c:\temp\esrc770.xlsx"
       tt-configuracao2.total-planilha      = 2
       tt-configuracao2.exibir-construcao   = no
       tt-configuracao2.abrir-excel-termino = yes
       tt-configuracao2.imprimir = no
       tt-configuracao2.orientacao = 2.

CREATE tt-planilha2.
ASSIGN tt-planilha2.arquivo-num   = 1
       tt-planilha2.planilha-num  = 1
       tt-planilha2.planilha-nome = "Plan 1"
       tt-planilha2.linhas-grade  = no
       tt-planilha2.largura-coluna = 12.50
       tt-planilha2.formatar-planilha = NO
       tt-planilha2.formatar-faixa = YES.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Periodo"
       tt-dados.celula-fonte-negrito = yes.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string(tt-param.dt-periodo-ini) + " a " + STRING(tt-param.dt-periodo-fim)
       tt-dados.celula-fonte-negrito = yes.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = string("APURACAO DE PIS / COFINS NAS ENTRADAS - NORMAL")
       tt-dados.celula-fonte-negrito = yes.


ASSIGN i-linha = 3.

CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 1
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Docto"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 2
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Item"
       tt-dados.celula-fonte-negrito = yes.


CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 3
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "NCM"
       tt-dados.celula-fonte-negrito = yes.




CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 4
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Emitente"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 5
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "CFOP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 6
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Natureza"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 7
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Descricao CFOP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 8
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. Contabil"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 9
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "B. Calc. PIS"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 10
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "B. Calc. COFINS"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 11
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. PIS/PASEP"
       tt-dados.celula-fonte-negrito = yes.



CREATE tt-dados.
ASSIGN tt-dados.arquivo-num   = 1
       tt-dados.planilha-num  = 1
       tt-dados.celula-coluna = 12
       tt-dados.celula-linha  = i-linha
       tt-dados.celula-valor  = "Vlr. COFINS"
       tt-dados.celula-fonte-negrito = yes.



assign i-linha = i-linha + 1.


run pi-inicializar in h-acomp (Input "Iniciado").
RUN pi-seleciona-doctos.

             /* DOCUMENTOS DE ENTRADA */
             run pi-normal-docto (input 1).
             
             /* DOCUMENTOS DE SA™DA */
             run pi-normal-docto (input 3).
             



assign i-linha = i-linha + 2.    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 1
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = "Total Entradas ".

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 6
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_entradas).
        
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 7
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_entradas_base_pis).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 8
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_entradas_base_cofins).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 9
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_entradas_pis).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 10
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_entradas_cofins).
    
assign i-linha = i-linha + 2.    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 1
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = "Total Saidas ".
               

        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 6
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_saidas).               
        
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 7
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_saidas_base_pis).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 8
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_saidas_base_cofins).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 9
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_saidas_pis).
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num   = 1
               tt-dados.planilha-num  = 1
               tt-dados.celula-coluna = 10
               tt-dados.celula-linha  = i-linha
               tt-dados.celula-valor  = string(v_saidas_cofins).
assign i-linha = i-linha + 1.    
               
run pi-finalizar in h-acomp.  
    
run utp/utapi013.p persistent set h-utapi013.
               
RUN pi-execute2 in h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                               INPUT-OUTPUT TABLE tt-planilha2,
                               INPUT-OUTPUT TABLE tt-dados,
                               INPUT-OUTPUT TABLE tt-formatar-faixa,
                               INPUT-OUTPUT TABLE tt-grafico2,
                               INPUT-OUTPUT TABLE tt-erros).

             
             

procedure pi-normal-docto:
def input param p-tipo-nat as integer no-undo.



FOR EACH tt-doc-fiscal
   WHERE tt-doc-fiscal.tipo-apuracao <= 2, /* 1 = normal 2 = ambos */
      
      /* Valores de PIS/COFINS Normal */
      /* As notas que nÆo possuem valor de PIS e COFINS devem ser demonstradas no arquivo e o valor contabil deve ser c lculado com base no valor de todas as notas
         tendo ou nÆo valor de PIS e COFINS */

    each  doc-fiscal
        where doc-fiscal.cod-estabel  = tt-doc-fiscal.estab
        AND   doc-fiscal.serie        = tt-doc-fiscal.serie
        AND   doc-fiscal.nr-doc-fis   = tt-doc-fiscal.nr-doc-fis
        AND   doc-fiscal.cod-emitente = tt-doc-fiscal.emitente
        AND   doc-fiscal.nat-operacao = tt-doc-fiscal.nat-operacao
        AND   CAN-FIND(FIRST it-doc-fisc 
                       WHERE it-doc-fisc.cod-estabel  = doc-fiscal.cod-estabel
                       AND   it-doc-fisc.serie        = doc-fiscal.serie
                       AND   it-doc-fisc.nr-doc-fis   = doc-fiscal.nr-doc-fis
                       AND   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
                       AND   it-doc-fisc.nat-operacao = doc-fiscal.nat-operacao) 
                       no-lock, 
        first natur-oper
              where natur-oper.nat-operacao = doc-fiscal.nat-operacao no-lock,
              each  it-doc-fisc
              where it-doc-fisc.cod-estabel  = doc-fiscal.cod-estabel
              and   it-doc-fisc.serie        = doc-fiscal.serie
              and   it-doc-fisc.nr-doc-fis   = doc-fiscal.nr-doc-fis
              and   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
              and   it-doc-fisc.nat-operacao = natur-oper.nat-operacao 
              BREAK by doc-fiscal.nat-operacao
                    by doc-fiscal.dt-emis-doc
                    by doc-fiscal.nr-doc-fis
                    BY doc-fiscal.cod-emitente:
run pi-acompanhar in h-acomp (Input "Item " + it-doc-fisc.it-codigo + "Dt " + string(doc-fiscal.nat-operacao)).




      if  p-tipo-nat = 1 then do: /* entrada */
          if (doc-fiscal.tipo-nat <> 1
          and doc-fiscal.tipo-nat <> 3) then next. 

          IF  doc-fiscal.tipo-nat = 3 
          AND natur-oper.tipo    <> 1 THEN NEXT.
      end.
      else do: /*** Verifica documentos de Sa¡da ***/
          if  doc-fiscal.tipo-nat <> 2
          and doc-fiscal.tipo-nat <> 3 then next. 

          IF doc-fiscal.tipo-nat  = 3 THEN DO:
             IF  natur-oper.tipo <> 2 
             and natur-oper.tipo <> 3 THEN NEXT.
          END.
      end. 

      accumulate truncate(it-doc-fisc.vl-tot-item, 2)
                   (total  by doc-fiscal.nat-operacao 
                           by doc-fiscal.dt-emis-doc  
                           by doc-fiscal.nr-doc-fis   
                           BY doc-fiscal.cod-emitente).
                          
                           
         if natur-oper.tipo = 1 then do:                     
                          
      assign v_entradas = v_entradas + it-doc-fisc.vl-tot-item.
      end.
      
      
      else do:
      assign v_saidas   = v_saidas   + it-doc-fisc.vl-tot-item.
      end.


find first b-natur-oper where b-natur-oper.nat-operacao = it-doc-fisc.nat-operacao no-error.

    if trim(substring(b-natur-oper.char-1, 86, 1 )) = "1"
    or trim(substring(b-natur-oper.char-1, 86, 1 )) = "4" then do:

      accumulate truncate(it-doc-fisc.val-base-calc-pis, 2)
                 (total BY doc-fiscal.nat-operacao
                        BY doc-fiscal.dt-emis-doc
                        BY doc-fiscal.nr-doc-fis
                        BY doc-fiscal.cod-emitente).  
      accumulate truncate(it-doc-fisc.val-pis, 2)
                 (total BY doc-fiscal.nat-operacao
                        BY doc-fiscal.dt-emis-doc
                        BY doc-fiscal.nr-doc-fis
                        BY doc-fiscal.cod-emitente).

      accumulate truncate(it-doc-fisc.val-base-calc-cofins, 2)
                 (total BY doc-fiscal.nat-operacao
                        BY doc-fiscal.dt-emis-doc
                        BY doc-fiscal.nr-doc-fis
                        BY doc-fiscal.cod-emitente). 
      accumulate truncate(it-doc-fisc.val-cofins, 2)
                 (total BY doc-fiscal.nat-operacao
                        BY doc-fiscal.dt-emis-doc
                        BY doc-fiscal.nr-doc-fis
                        BY doc-fiscal.cod-emitente).  
        if natur-oper.tipo = 2 then do:                        
        assign v_saidas_base_pis      = v_saidas_base_pis     +  it-doc-fisc.val-base-calc-pis
               v_saidas_base_cofins   = v_saidas_base_cofins  +  it-doc-fisc.val-base-calc-cofins
               v_saidas_pis           = v_saidas_pis          +  it-doc-fisc.val-pis
               v_saidas_cofins        = v_saidas_cofins       +  it-doc-fisc.val-cofins.
        
        end.
        
        else do:
                                
        assign v_entradas_base_pis      = v_entradas_base_pis     +  it-doc-fisc.val-base-calc-pis
               v_entradas_base_cofins   = v_entradas_base_cofins  +  it-doc-fisc.val-base-calc-cofins
               v_entradas_pis           = v_entradas_pis          +  it-doc-fisc.val-pis
               v_entradas_cofins        = v_entradas_cofins       +  it-doc-fisc.val-cofins.
                                
        end.
        
                        
                        
end.

                        
find first b-natur-oper where b-natur-oper.nat-operacao = it-doc-fisc.nat-operacao no-error.

    FIND FIRST ITEM WHERE ITEM.it-codigo = it-doc-fisc.it-codigo NO-ERROR.                        

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 1
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = it-doc-fisc.nr-doc-fis.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 2
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = it-doc-fisc.it-codigo.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 3
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = item.class-fiscal.



      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 4
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.cod-emitente).

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 5
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(natur-oper.cod-cfop).



      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 6
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = it-doc-fisc.nat-operacao.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 7
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = natur-oper.denominacao.

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 8
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.vl-tot-item).

    if trim(substring(b-natur-oper.char-1, 86, 1 )) = "1"
    or trim(substring(b-natur-oper.char-1, 86, 1 )) = "4" then do:

  
      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 9
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.val-base-calc-pis).


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 10
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.val-base-calc-cofins).

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 11
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.val-pis).


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 12
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(it-doc-fisc.val-cofins).
      end.
      
      else do:
      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 9
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(0).


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 10
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(0).

      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 11
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(0).


      CREATE tt-dados.
      ASSIGN tt-dados.arquivo-num   = 1
             tt-dados.planilha-num  = 1
             tt-dados.celula-coluna = 12
             tt-dados.celula-linha  = i-linha
             tt-dados.celula-valor  = string(0).
end.      
           

ASSIGN i-linha = i-linha + 1.
/*                                                                                                                                        */
/*     IF LAST-OF(doc-fiscal.nat-operacao) THEN DO:                                                                                       */
/*                                                                                                                                        */
/*                                                                                                                                        */
/*         CREATE tt-dados.                                                                                                               */
/*         ASSIGN tt-dados.arquivo-num   = 1                                                                                              */
/*                tt-dados.planilha-num  = 1                                                                                              */
/*                tt-dados.celula-coluna = 1                                                                                              */
/*                tt-dados.celula-linha  = i-linha                                                                                        */
/*                tt-dados.celula-valor  = "Total Nat. Oper " + doc-fiscal.nat-operacao.                                                  */
/*                                                                                                                                        */
/*                                                                                                                                        */
/*         CREATE tt-dados.                                                                                                               */
/*         ASSIGN tt-dados.arquivo-num   = 1                                                                                              */
/*                tt-dados.planilha-num  = 1                                                                                              */
/*                tt-dados.celula-coluna = 7                                                                                              */
/*                tt-dados.celula-linha  = i-linha                                                                                        */
/*                tt-dados.celula-valor  = string(ACCUM TOTAL BY  doc-fiscal.nat-operacao truncate(it-doc-fisc.val-base-calc-pis, 2)).    */
/*                                                                                                                                        */
/*         CREATE tt-dados.                                                                                                               */
/*         ASSIGN tt-dados.arquivo-num   = 1                                                                                              */
/*                tt-dados.planilha-num  = 1                                                                                              */
/*                tt-dados.celula-coluna = 8                                                                                              */
/*                tt-dados.celula-linha  = i-linha                                                                                        */
/*                tt-dados.celula-valor  = string(ACCUM TOTAL BY  doc-fiscal.nat-operacao truncate(it-doc-fisc.val-base-calc-cofins, 2)). */
/*                                                                                                                                        */
/*         CREATE tt-dados.                                                                                                               */
/*         ASSIGN tt-dados.arquivo-num   = 1                                                                                              */
/*                tt-dados.planilha-num  = 1                                                                                              */
/*                tt-dados.celula-coluna = 9                                                                                              */
/*                tt-dados.celula-linha  = i-linha                                                                                        */
/*                tt-dados.celula-valor  = string(ACCUM TOTAL BY  doc-fiscal.nat-operacao truncate(it-doc-fisc.val-pis, 2)).              */
/*                                                                                                                                        */
/*         CREATE tt-dados.                                                                                                               */
/*         ASSIGN tt-dados.arquivo-num   = 1                                                                                              */
/*                tt-dados.planilha-num  = 1                                                                                              */
/*                tt-dados.celula-coluna = 10                                                                                             */
/*                tt-dados.celula-linha  = i-linha                                                                                        */
/*                tt-dados.celula-valor  = string(ACCUM TOTAL BY doc-fiscal.nat-operacao truncate(it-doc-fisc.val-cofins, 2)).            */
/*                                                                                                                                        */
/*         ASSIGN i-linha = i-linha + 2.                                                                                                  */
/*                                                                                                                                        */
/*     END.                                                                                                                               */




END.
      



   
end procedure. 


PROCEDURE pi-seleciona-doctos:
    
    DEF VAR l-considera-apuracao-normal AS LOGICAL  NO-UNDO.
    DEF VAR l-considera-apuracao-retido AS LOGICAL  NO-UNDO.
    
    EMPTY TEMP-TABLE tt-doc-fiscal.

    /* FOR EACH DOC-FISCAL NA INCLUDE ofp/of0770.i6 */
            {ofp/of0770.i6  "fields (cod-estabel serie nr-doc-fis nat-operacao cod-emitente dt-docto ind-sit-doc tipo-nat dt-emis-doc char-1 cod-cfop)" 
                            "fields (nat-operacao denominacao tipo cod-cfop)"
                            "fields (cod-estabel serie nr-doc-fis cod-emitente nat-operacao dt-emis-doc vl-tot-item char-1 val-retenc-pis val-retenc-cofins val-pis val-cofins)"}
    
    /* VERIFICA CAMPOS PIS/CPOFINS NORMAL */    
    ASSIGN l-considera-apuracao-normal = 
               CAN-FIND(FIRST it-doc-fisc
                        WHERE it-doc-fisc.cod-estabel  = doc-fiscal.cod-estabel
                        AND   it-doc-fisc.nat-operacao = doc-fiscal.nat-operacao
                        AND   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
                        AND   it-doc-fisc.serie        = doc-fiscal.serie
                        AND   it-doc-fisc.nr-doc-fis   = doc-fiscal.nr-doc-fis
                        AND   (it-doc-fisc.val-pis    <> 0 
                        OR it-doc-fisc.val-cofins <> 0)).    
    /* VERIFICA CAMPOS PIS/CPOFINS RETIDO */    
    ASSIGN l-considera-apuracao-retido =
               CAN-FIND(FIRST it-doc-fisc
                        WHERE it-doc-fisc.cod-estabel  = doc-fiscal.cod-estabel
                        AND   it-doc-fisc.nat-operacao = doc-fiscal.nat-operacao
                        AND   it-doc-fisc.cod-emitente = doc-fiscal.cod-emitente
                        AND   it-doc-fisc.serie        = doc-fiscal.serie
                        AND   it-doc-fisc.nr-doc-fis   = doc-fiscal.nr-doc-fis
                        AND   (            it-doc-fisc.val-retenc-pis    <> 0 
                                        OR it-doc-fisc.val-retenc-cofins <> 0)).                                
    IF  l-considera-apuracao-normal
    OR  l-considera-apuracao-retido THEN DO:
        FIND FIRST tt-doc-fiscal                                           
            where  tt-doc-fiscal.estab         = it-doc-fisc.cod-estabel  
            and    tt-doc-fiscal.serie         = it-doc-fisc.serie        
            and    tt-doc-fiscal.nr-doc-fis    = it-doc-fisc.nr-doc-fis   
            and    tt-doc-fiscal.emitente      = it-doc-fisc.cod-emitente 
            and    tt-doc-fiscal.nat-operacao  = it-doc-fisc.nat-operacao NO-LOCK NO-ERROR.
      
        IF NOT AVAIL tt-doc-fiscal THEN DO:
            CREATE tt-doc-fiscal.
            ASSIGN tt-doc-fiscal.estab         = it-doc-fisc.cod-estabel  
                   tt-doc-fiscal.serie         = it-doc-fisc.serie        
                   tt-doc-fiscal.nr-doc-fis    = it-doc-fisc.nr-doc-fis   
                   tt-doc-fiscal.emitente      = it-doc-fisc.cod-emitente 
                   tt-doc-fiscal.nat-operacao  = it-doc-fisc.nat-operacao 
                   tt-doc-fiscal.l-valor       = NO
                   tt-doc-fiscal.tipo-apuracao = IF  l-considera-apuracao-normal
                                                 AND l-considera-apuracao-retido
                                                     THEN 2       /* ambos */
                                                     ELSE IF l-considera-apuracao-normal
                                                          THEN 1  /* normal */
                                                          ELSE 3. /* retido */
        END.
    END.
    /* Documento Fiscal n’o possui valor de PIS/COFINS */
    ELSE DO:
        FIND FIRST tt-doc-fiscal                                           
            where  tt-doc-fiscal.estab         = it-doc-fisc.cod-estabel  
            and    tt-doc-fiscal.serie         = it-doc-fisc.serie        
            and    tt-doc-fiscal.nr-doc-fis    = it-doc-fisc.nr-doc-fis   
            and    tt-doc-fiscal.emitente      = it-doc-fisc.cod-emitente 
            and    tt-doc-fiscal.nat-operacao  = it-doc-fisc.nat-operacao NO-LOCK NO-ERROR.
      
        IF NOT AVAIL tt-doc-fiscal THEN DO:
            CREATE tt-doc-fiscal.
            ASSIGN tt-doc-fiscal.estab         = it-doc-fisc.cod-estabel  
                   tt-doc-fiscal.serie         = it-doc-fisc.serie        
                   tt-doc-fiscal.nr-doc-fis    = it-doc-fisc.nr-doc-fis   
                   tt-doc-fiscal.emitente      = it-doc-fisc.cod-emitente 
                   tt-doc-fiscal.nat-operacao  = it-doc-fisc.nat-operacao 
                   tt-doc-fiscal.l-valor       = YES 
                   tt-doc-fiscal.tipo-apuracao = 1.
        END.
    END.
END. /* FOR EACH doc-fiscal */

END PROCEDURE.




