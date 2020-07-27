def var dt-emis        as date format 99/99/9999. 
def var c-nome-emp     like emsuni.empresa.nom_razao_social.
def var tot-vl-saldo   like dc-tit_acr.vend-vl-tit-acr   format "->>,>>>,>>9.99".
def var tot-vl-prest   like dc-tit_acr.vend-vl-prestacao format "->>,>>>,>>9.99".
def var tot-vl-equal   like dc-tit_acr.vend-vl-equaliz   format ">>>,>>9.99".
def var tot-vl-ioc     like dc-tit_acr.vend-vl-ioc       format ">>,>>9.99".
def var da-datini      as date format "99/99/9999" init today.
def var da-datfim      as date format "99/99/9999" init today.
def var i-portini      like tit_acr.cod_portador.
def var i-portfim      like tit_acr.cod_portador init 99999.
def var c-conta-cor    like portad_finalid_econ.cod_cta_corren extent 2. 
def var c-num-contrat  like vendor-lote.num-contrat.
def var i-ult-fech     like dc-tit_acr.vend-num-lote extent 2.
def var i-contas       as int.
def var c-agencia      like agenc_bcia.cod_agenc_bcia extent 2.
def var c-nome-age     as   CHAR format "x(30)" extent 2.
def var i-ep-codigo    like emsuni.empresa.cod_empresa.
def var c-cgc          like  pessoa_jurid.cod_id_feder.
def var c-cgc-banco    like  pessoa_jurid.cod_id_feder.
def var c-label        as char format "x(8)".
def var i-conta        as int.
def var c-endereco     like pessoa_jurid.nom_endereco.
def var da-data        as date format "99/99/9999".
def var da-data-ax     as date format "99/99/9999".
def var c-cep          like pessoa_jurid.cod_cep.
def var c-uf           like pessoa_jurid.cod_unid_federac.
def var c-cidade       like pessoa_jurid.nom_cidade.
def var c-empresa-ax   like empresa.nom_razao_social.
def var de-valortot    like tit_acr.val_origin_tit_acr.
def var de-taxa-cli    like dc-tit_acr.vend-taxa-cliente.
DEF VAR c-msg-ax       LIKE msg_financ.des_mensagem.  
def var de-taxa-fim    like dc-tit_acr.vend-taxa-final.

def var c-banco        like emsuni.banco.nom_banco.
def var c-banco-abrev  like emsuni.portador.nom_abrev extent 3.
def var c-nome-cli     like emsuni.cliente.nom_pessoa.
def var c-ende-cli     like pessoa_jurid.nom_endereco.
def var c-est-cli      like pessoa_jurid.cod_unid_federac.
def var c-cgc-cli      like pessoa_jurid.cod_id_feder.
def var c-cep-cli      like pessoa_jurid.cod_cep.
def var c-cidade-cli   like pessoa_jurid.nom_cidade.
def var c-opcao        AS CHAR.

/*****************************************************/
DEF BUFFER b-dc-tit_acr FOR dc-tit_acr.
DEF BUFFER b-pessoa_jurid FOR pessoa_jurid.
DEF BUFFER bb-pessoa_jurid FOR pessoa_jurid.
DEF TEMP-TABLE w-dias
    FIELD dt-vencimen  LIKE dc-tit_acr.vend-dt-vencto   
    FIELD prazo        AS DEC FORMAT "->>9"
    FIELD valor        LIKE dc-tit_acr.vend-vl-tit-acr
    FIELD taxa-b       LIKE dc-tit_acr.vend-taxa-final
    FIELD vl-equal     LIKE dc-tit_acr.vend-vl-equalizacao.
 
{include/tt-edit.i}
{include/pi-edit.i}

form header
"RESUMO GERAL DA OPERA€ÇO" skip(1)
"+-----------------------------------------------------------------------------------+" skip
"!"
"DATA DA OPERA€ÇO:" da-data-ax 
"EQUALIZA€ÇO: NO ATO" to 75 "!" to 85 skip
"+-----------------------------------------------------------------------------------+" skip
"!" "VALOR" to 28   "PRAZO EM DIAS" to 47  "TAXA BANCO" to 76 "!" to 85 skip
"+-----------------------------------------------------------------------------------+" skip
with frame f-abertura-4 WIDTH 85 no-box no-labels.

FORM HEADER
SKIP(2)
c-cidade + ", " + string(da-datini,"99/99/9999") + "." format "x(70)"
SKIP(2)
c-empresa-ax                   at 01 skip(3)
"___________________________ " at 01
"        PROCURADORES        " at 01
with WIDTH 130 frame f-assinatura no-box NO-LABELS.

form header
"ANEXO 1 AO INSTRUMENTO DE FINANCIAMENTO - PLANILHA NO." i-ult-fech[2] skip(1)
"CARACTERISTICAS DO FINANCIAMENTO -" c-banco-abrev[1] skip(1)
with  frame f-aber2 no-box  no-labels page-top.

form header
"+-----------------------------------------------------------------------------------+" skip
"! Caracteristicas da Compradora/Financiada" "!" to 85 skip
"! NOME:" c-nome-cli " CGC:" c-cgc-cli FORMAT "99.999.999/9999-99" "!" to 85 skip
"! RUA :" c-ende-cli " CEP:" c-cep-cli FORMAT "99999-999" "!" to 85 skip
"! CIDADE:" c-cidade-cli "        UF:" c-est-cli "!" to 85 skip
"+-----------------------------------------------------------------------------------+" skip
"! NUMERO      !       VALOR!    VALOR DA!" c-label FORMAT 'x(08)' AT 44
"!VENCIMENTO!EQUALIZACAO!      IOC!" AT 52
"! DOCUMENTO   !            !   PRESTA€ÇO!          !          !           !         !"
"+-------------!------------!------------!----------!----------!-----------!---------+"
WITH WIDTH 85 FRAME f-labels NO-BOX NO-LABELS STREAM-IO .

FIND empresa NO-LOCK 
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF AVAIL empresa THEN
    FIND FIRST estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = empresa.cod_empresa
          AND estabelecimento.log_estab_princ = YES NO-ERROR.

FIND FIRST pessoa_jurid NO-LOCK
    WHERE pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid NO-ERROR.

ASSIGN c-empresa-ax  = estabelecimento.nom_pessoa
       c-endereco    = pessoa_jurid.nom_endereco
       c-cidade      = pessoa_jurid.nom_cidade
       c-cep         = pessoa_jurid.cod_cep
       c-cgc         = pessoa_jurid.cod_id_feder
       c-uf          = pessoa_jurid.cod_unid_federac
       c-nome-emp    = estabelecimento.nom_pessoa.

FIND FIRST vendor-lote NO-LOCK
     WHERE vendor-lote.cod-empresa = v_cod_empres_usuar
       AND vendor-lote.cod-estab   = c-cod-estab-lote 
       AND vendor-lote.num-lote    = num-lote NO-ERROR.
FIND FIRST vendor_param NO-LOCK
     WHERE vendor_param.cod_empresa    = vendor-lote.cod-empresa
       AND vendor_param.cod_estabel    = vendor-lote.cod-estab
       AND vendor_param.dt_inic_valid <= vendor-lote.dt-fechamento
       AND vendor_param.dt_fin_valid  >= vendor-lote.dt-fechamento NO-ERROR.

IF AVAIL vendor-lote THEN DO:

   IF NOT l-reimpressao THEN DO:

      FOR EACH dc-tit_acr NO-LOCK USE-INDEX lote
         WHERE dc-tit_acr.cod-empresa          = vendor-lote.cod-empresa
           AND dc-tit_acr.cod_estab            = vendor-lote.cod-estab  
           AND dc-tit_acr.vend-num-lote        = vendor-lote.num-lote 
           AND dc-tit_acr.vend-emitiu-contrato = NO,
         FIRST tit_acr OF dc-tit_acr NO-LOCK
            WHERE tit_acr.cod_espec_doc        =   vendor_param.cod_espec_docto_neg
         BREAK BY dc-tit_acr.vend-cod-portador
               BY dc-tit_acr.vend-num-lote           
               BY dc-tit_acr.vend-dt-vencto:

         FIND FIRST emsfin.portador NO-LOCK
              WHERE emsfin.portador.cod_portador = dc-tit_acr.vend-cod-portador NO-ERROR.  

         IF AVAIL portador THEN DO:

            FIND FIRST portad_finalid_econ OF portador NO-LOCK NO-ERROR.

            FIND FIRST emsuni.banco NO-LOCK
                 WHERE emsuni.banco.cod_banco = portador.cod_banco NO-ERROR.

            FIND FIRST agenc_bcia OF banco NO-LOCK NO-ERROR.

            FIND FIRST cep_agenc_bcia NO-LOCK
                 WHERE cep_agenc_bcia.cod_banco = banco.cod_banco NO-ERROR.

            IF portador.cod_banco = '237' THEN 
               ASSIGN c-label =  "TX FINAL".
            ELSE 
               ASSIGN c-label = "EMISSÇO". 

            {doinc/dcr038rp1.i}
         END.
      END.
   END.
   ELSE DO:
      
      FOR EACH dc-tit_acr NO-LOCK USE-INDEX lote
         WHERE dc-tit_acr.cod-empresa         = v_cod_empres_usuar
           AND dc-tit_acr.cod_estab           = v_cod_estab_usuar
           AND dc-tit_acr.vend-num-lote       = num-lote,
         FIRST tit_acr OF dc-tit_acr NO-LOCK
         WHERE tit_acr.cod_espec_doc =   vendor_param.cod_espec_docto_neg
         BREAK BY dc-tit_acr.vend-cod-portador
               BY dc-tit_acr.vend-num-lote           
               BY dc-tit_acr.vend-dt-vencto:
         
         FIND FIRST emsfin.portador NO-LOCK
              WHERE emsfin.portador.cod_portador = dc-tit_acr.vend-cod-portador NO-ERROR.  

         IF AVAIL emsfin.portador THEN DO:

            FIND FIRST portad_finalid_econ OF portador NO-LOCK NO-ERROR.

            FIND FIRST emsuni.banco NO-LOCK
                 WHERE emsuni.banco.cod_banco = portador.cod_banco NO-ERROR.

            FIND FIRST agenc_bcia OF banco NO-LOCK NO-ERROR.

            FIND FIRST cep_agenc_bcia NO-LOCK
                 WHERE cep_agenc_bcia.cod_banco = banco.cod_banco NO-ERROR.

            IF portador.cod_banco = '237' THEN 
               ASSIGN c-label =  "TX FINAL".
            ELSE 
               ASSIGN c-label = "EMISSÇO". 

            {doinc/dcr038rp1.i}
         END.
      END.  
   END.
END.

PROCEDURE pi-msg:
    DEF INPUT PARAMETER c-nr-msg AS CHARACTER FORMAT "X(3)":U NO-UNDO.

    FIND FIRST msg_financ NO-LOCK
        WHERE msg_financ.cod_empresa  = v_cod_empres_usuar
          AND msg_financ.cod_estab    = v_cod_estab_usuar 
          AND msg_financ.cod_mensagem = c-nr-msg NO-ERROR.
    IF AVAIL msg_financ THEN DO:
        
        IF c-nr-msg = '93' THEN DO:
           ASSIGN  c-msg-ax = SUBSTITUTE(msg_financ.des_mensagem,trim(c-banco-abrev[2]),TRIM(c-num-contrat),
                                                                 string(da-data,"99/99/9999"),trim(c-banco-abrev[2]),
                                                                 trim(c-conta-cor[1]),trim(c-agencia[1]),
                                                                 trim(c-nome-age[1]),trim(c-conta-cor[2]),
                                                                 trim(c-agencia[2])).
           ASSIGN c-msg-ax = REPLACE(c-msg-ax,'#',c-nome-age[2]). 

           RUN pi-print-editor (c-msg-ax, 85).
           FOR EACH tt-editor
               WHERE tt-editor.conteudo <> "":                    
                   DISP tt-editor.conteudo FORMAT 'x(85)' WITH NO-BOX NO-LABELS  WIDTH 87 FRAME f-menssagens1.
                   DOWN WITH FRAME f-menssagens1.
           END.
        END.
        ELSE DO:
            RUN pi-print-editor (msg_financ.des_mensagem, 85).
            FOR EACH tt-editor
                WHERE tt-editor.conteudo <> "":                    
                    DISP tt-editor.conteudo FORMAT 'x(85)' WITH NO-BOX NO-LABELS  WIDTH 87 FRAME f-menssagens.
                    DOWN WITH FRAME f-menssagens.
            END.
        END.
    END.    
END PROCEDURE.
