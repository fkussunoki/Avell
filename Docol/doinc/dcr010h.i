

/* temp-tables ---------------------------- */
DEFINE {1} SHARED TEMP-TABLE tt-titulo    NO-UNDO 
    FIELD rec-tit_acr           AS RECID
    FIELD sit-renegoc           AS CHARACTER    FORMAT "X(20)"              LABEL "Situa‡Æo"
    FIELD cod_empresa           AS CHARACTER    FORMAT "X(3)"               LABEL "Empresa"             COLUMN-LABEL "Emp"
    FIELD cod_estab             AS CHARACTER    FORMAT "X(3)"               LABEL "Estab"               COLUMN-LABEL "Est"
    FIELD cod_espec_docto       AS CHARACTER    FORMAT "X(3)"               LABEL "Esp Documento"       COLUMN-LABEL "Esp"
    FIELD cod_ser_docto         AS CHARACTER    FORMAT "x(3)"               LABEL "S‚rie Documento"     COLUMN-LABEL "S‚rie"
    FIELD cod_tit_acr           AS CHARACTER    FORMAT "X(10)"              LABEL "Numero Documento"    COLUMN-LABEL "Num Docto"
    FIELD cod_parcela           AS CHARACTER    FORMAT "X(2)"               LABEL "Parcela"             COLUMN-LABEL "Parc"
    FIELD num_id_tit_acr        AS INTEGER      FORMAT "9999999999"         LABEL "Identificacao Tit"   COLUMN-LABEL "Nr Id Titulo"
    FIELD cdn_cliente           AS INTEGER      FORMAT ">>>,>>>,>>9"        LABEL "Codigo Cliente"      COLUMN-LABEL "Cliente"
    FIELD nom_abrev             AS CHARACTER    FORMAT "X(12)"              LABEL "Nome Abreviado"      COLUMN-LABEL "Nome Abrev"
    FIELD cdn_repres            AS INTEGER      FORMAT ">>>,>>9"            LABEL "Codigo Repres"       COLUMN-LABEL "Cd Rep"
    FIELD dat_emis_docto        AS DATE         FORMAT "99/99/9999"         LABEL "Emiss’o"             COLUMN-LABEL "Emiss’o" 
    FIELD dat_vencto_tit_acr    AS DATE         FORMAT "99/99/9999"         LABEL "Vencimento"          COLUMN-LABEL "Vencto"
    FIELD dat_vencto_origin     AS DATE         FORMAT "99/99/9999"         LABEL "Vencimento Ori"      COLUMN-LABEL "Vencto Ori"
    FIELD dat_desconto          AS DATE         FORMAT "99/99/9999"         LABEL "Desconto"            COLUMN-LABEL "Desconto"
    FIELD val_origin_tit_acr    AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Original"      COLUMN-LABEL "Vl Ori"
    FIELD val_liq_tit_acr       AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Liquido"       COLUMN-LABEL "Vl Liq"
    FIELD val_sdo_tit_acr       AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Saldo"         COLUMN-LABEL "Saldo"
    FIELD val_desc_tit_acr      AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Desconto"      COLUMN-LABEL "Vl Des"
    FIELD val_abat_tit_acr      AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Abatimento"    COLUMN-LABEL "Vl Aba"
    
  /*FIELD nome-matriz     AS character  FORMAT "X(12)" LABEL "Matriz" COLUMN-LABEL "Matriz" 
    FIELD cod-cli-matriz  AS integer  FORMAT ">>>,>>>,>>9" LABEL "Cod Matriz" COLUMN-LABEL "Matriz"*/

    FIELD cod_gr_cli            AS CHARACTER    FORMAT "X(4)"               LABEL "Grupo Cliente"       COLUMN-LABEL "Gr Cli"
    FIELD val_perc_juros_dia_atraso AS DECIMAL  FORMAT ">>9.99999"          LABEL "Perc. Juros"         COLUMN-LABEL "Perc. Juros"
    FIELD vl-outras-despesas    AS DECIMAL      FORMAT "->>>,>>>,>>9.99"    LABEL "Outras Despesas"     COLUMN-LABEL "Outas"        DECIMALS 2
    FIELD val-juros             AS DECIMAL      FORMAT "->>>,>>>,>>9.99"    LABEL "Val Juros"           COLUMN-LABEL "Val Juros"    DECIMALS 2

    FIELD cod_portador          AS CHARACTER    FORMAT "X(5)"               LABEL "Portador"            COLUMN-LABEL "Portador"
    FIELD cod_portador_ori      AS CHARACTER    FORMAT "X(5)"               LABEL "Portador"            COLUMN-LABEL "Portador Ori"
    FIELD cod_cart_bcia         AS CHARACTER    FORMAT "X(3)"               LABEL "Carteira"            COLUMN-LABEL "Carteira"
    FIELD cod_tit_acr_bco       AS CHARACTER    FORMAT "X(20)"              LABEL "Nr Titulo Banco"     COLUMN-LABEL "Tit Bco"
    
    FIELD usuario         AS character FORMAT "X(12)" LABEL "Usuÿrio" COLUMN-LABEL "Usuÿrio"
    FIELD tipo            AS integer /*DESCRIPTION "1-Original, 2-Renegociado, 3-Novo, 4-Aviso de D²bito, 5-Antecipacao"*/ FORMAT "9" INITIAL "1" LABEL "Tipo Titulo" COLUMN-LABEL "Tp Tit"
    FIELD tp-receita      AS integer FORMAT ">>9" LABEL "Tipo Receita" COLUMN-LABEL "Receita"
    FIELD nr-pedcli       AS character FORMAT "X(12)" LABEL "Pedido do Cliente" COLUMN-LABEL "Ped Cliente"
    FIELD dt-pagto        AS date  FORMAT "99/99/9999" LABEL "Pagamento" COLUMN-LABEL "Pagamento"
    FIELD vl-realizado    AS decimal  FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Realizado" COLUMN-LABEL "Vl.Realizado"
    FIELD Estornado       AS logical  FORMAT "Sim/N’o" INITIAL "N’o" LABEL "Estornado" COLUMN-LABEL "Est"
    
    FIELD pct-multa       AS decimal  FORMAT ">>>9.99" LABEL "Perc. Multa" COLUMN-LABEL "% Multa" DECIMALS 2
    FIELD perc-juros-dia-atraso AS decimal  FORMAT ">>9.999999" LABEL "Perc. Juros Dia" COLUMN-LABEL "Perc Juros" DECIMALS 2
    FIELD abat-negociado  AS decimal  FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Abat Negociado" COLUMN-LABEL "Val Abat Neg" DECIMALS 2
    FIELD desc-negociado  AS decimal  FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Valor Desc Negociado" COLUMN-LABEL "Val Desc Neg" HELP "Valor do desconto negociado" DECIMALS 2
    FIELD val-cor-monetaria AS decimal  FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Val Correcao Monetaria" COLUMN-LABEL "Val Cor Mon" HELP "Valor da correcao monetaria" DECIMALS 2
    FIELD val-multa       AS decimal FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Val Multa" COLUMN-LABEL "Val Multa" HELP "Valor da multa" DECIMALS 2
    FIELD val-desp-bancaria AS decimal  FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Val Desp Bancaria" COLUMN-LABEL "Val Desp Ban" HELP "Valor da despesa bancaria" DECIMALS 2
    FIELD val-desp-financeira AS decimal FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Val Desp Financeira" COLUMN-LABEL "Val Desp Fin" HELP "Valor da despesa financeira" DECIMALS 2
    FIELD val-imposto-op-fin AS decimal FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Val Imp Op Financeira" COLUMN-LABEL "Val Imp Op Fin" HELP "Valor do imposto sobre operacoes financeiras" DECIMALS 2
    FIELD cre-com-garantia AS logical  FORMAT "Sim/Nao" INITIAL "Sim" HELP "Indica que este nao pode ser indicado para perda dedutivel"
    FIELD cod-refer       AS character  FORMAT "X(10)" LABEL "Cod Referencia" COLUMN-LABEL "Cod Refer" HELP "Codigo de referencia do titulo"
    FIELD moeda           AS character  FORMAT "X(8)" LABEL "Moeda" COLUMN-LABEL "Moeda" HELP "Moeda no qual o titulo esta implantado"
    FIELD banco           AS character  FORMAT "X(8)" LABEL "Banco" COLUMN-LABEL "Banco" HELP "Codigo do banco"
    FIELD agencia         AS character  FORMAT "X(10)"  LABEL "Agencia" COLUMN-LABEL "Agencia"HELP "Agencia bancÿria do titulo"
    FIELD cc-banco        AS character  FORMAT "X(10)" LABEL "Conta Corrente Bco" COLUMN-LABEL "CC Banco" HELP "Conta corrente no banco"
    FIELD digito-cc-banco AS character FORMAT "X(2)" LABEL "Digito CC Banco" COLUMN-LABEL "Dig CC Bco" HELP "Digito da conta corrente bancaria"
    FIELD conta-corrente  AS character FORMAT "X(10)" LABEL "Conta Corrente" COLUMN-LABEL "Conta Cor" HELP "Conta corrente"
    FIELD agencia-cob         AS character  FORMAT "X(10)" LABEL "Agencia Cobranca" COLUMN-LABEL "Ag Cobranca" HELP "Agencia bancÿria de cobranca"
    FIELD dias-carencia-juros AS integer  FORMAT "999" LABEL "Carencia Juros" COLUMN-LABEL "Carencia Juros" HELP "Quantidade de dias de carencia para juros"
    FIELD dias-carencia-multa AS integer  FORMAT "999" LABEL "Carencia Multa" COLUMN-LABEL "Carencia Multa" HELP "Quantidade de dias de carencia para multa"
    FIELD dias-float      AS integer  FORMAT "999" LABEL "Dias Float" COLUMN-LABEL "Float" HELP "Quantidade de dias do float bancario"
    FIELD perc-juros-novo-doc AS decimal  FORMAT ">>9.999999" LABEL "Juros Novo Doc" COLUMN-LABEL "Juros Novo Doc" HELP "Percentual de juros do novo documento" DECIMALS 6
    FIELD perc-juros-diferenciado AS decimal FORMAT ">>9.999999"  LABEL "Juros Diferenciado" COLUMN-LABEL "Juros Dif" HELP "Percentual de juros diferenciado aplicado quando da renegociaca" DECIMALS 6

    FIELD confirma          AS   LOGICAL
    FIELD dias              as int
    FIELD nome-rep          AS   CHARACTER /*representante-ca.nome-abrev*/
    FIELD regiao            AS CHARACTER /*like representante-ca.regiao*/
    FIELD nom-portador      AS CHARACTER /*like portador-ca.nome-portador*/
    FIELD i-renegocia       AS   INTEGER
    FIElD ind_alert_av_pend AS CHAR FORMAT "x(01)"
    
    INDEX i-renegocia       i-renegocia.  



DEF {1} SHARED TEMP-TABLE tt-movto-cobranca NO-UNDO 
    FIELD cod_empresa       AS CHARACTER FORMAT "X(3)"      LABEL "Empresa"         COLUMN-LABEL "Emp"
    FIELD cod_espec_docto   AS CHARACTER FORMAT "X(3)"      LABEL "Espec"           COLUMN-LABEL "Espec"
    FIELD cod_estab         AS CHARACTER FORMAT "X(3)"      LABEL "Estab"           COLUMN-LABEL "Estab"
    FIELD cod_parcela       AS CHARACTER FORMAT "X(2)"      LABEL "Parcela"         COLUMN-LABEL "Parc"
    FIELD cod_ser_docto     AS CHARACTER FORMAT "x(3)"      LABEL "S‚rie Documento" COLUMN-LABEL "S‚rie"
    FIELD cod_tit_acr       AS CHARACTER FORMAT "X(10)"     LABEL "Numero Documento" COLUMN-LABEL "Num Docto"
    
    FIELD cod_estab_motiv   AS CHARACTER FORMAT "X(3)"      LABEL "Estab"           COLUMN-LABEL "Estab"
    FIELD cod_motivo        AS CHARACTER FORMAT "X(8)"      LABEL "Motivo PadrÆo"   COLUMN-LABEL "Mot. Pad"
    FIELD dat_contato       AS DATE      FORMAT "99/99/9999" LABEL "Dt. Contato"    COLUMN-LABEL "Dt. Con"
    FIELD descricao         AS CHARACTER FORMAT "X(40)"     LABEL "Descri‡Æo"       COLUMN-LABEL "Descri‡Æo"
    FIELD det_movto         AS CHARACTER FORMAT "x(2000)"   LABEL "Descri‡Æo Detalhada" COLUMN-LABEL "Descri‡Æo Detalhada"
    FIELD nom_contato       AS CHARACTER FORMAT "X(12)"     LABEL "Nome Contato"    COLUMN-LABEL "Contato"
    FIELD tp-contato        AS INTEGER   FORMAT "9"         LABEL "Tp Contato"      COLUMN-LABEL "Tp Con"
    FIELD usuario           AS CHARACTER FORMAT "X(12)"     LABEL "Usu rio"         COLUMN-LABEL "Usu rio"
    FIELD hr-final          AS CHARACTER                    LABEL "Hr. Final"       COLUMN-LABEL "Hr. Final"
    FIELD hr-inicio         AS CHARACTER                    LABEL "Hr. Inicio"      COLUMN-LABEL "Hr. Inicio"
    FIELD num_id_movto_tit_acr  AS INTEGER
    FIELD rec-movto-cobranca    AS RECID 
    
    INDEX movto-cobranca    IS UNIQUE IS PRIMARY
        cod_empresa         cod_estab
        cod_espec_docto     cod_ser_docto
        cod_tit_acr         cod_parcela
        dat_contato         hr-inicio
    INDEX dat_contato       dat_contato .

    DEFINE TEMP-TABLE tt-erro-titulo NO-UNDO
        FIELD cod_empresa           LIKE tit_acr.cod_empresa
        FIELD cod_estab             LIKE tit_acr.cod_estab
        FIELD cod_espec_docto       LIKE tit_acr.cod_espec_docto
        FIELD cod_ser_docto         LIKE tit_acr.cod_ser_docto
        FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr
        FIELD cod_parcela           LIKE tit_acr.cod_parcela
        FIELD cdn_cliente           LIKE tit_acr.cdn_cliente
        FIELD nom_abrev             LIKE tit_acr.nom_abrev
        FIELD cod_portador          LIKE tit_acr.cod_portador 
        FIELD cod_cart_bcia         LIKE tit_acr.cod_cart_bcia
        FIELD dat_vencto_tit_acr    LIKE tit_acr.dat_vencto_tit_acr
        FIELD val_sdo_tit_acr       LIKE tit_acr.val_sdo_tit_acr
        FIELD num-seq-msg           AS   INT
        FIELD num-mensagem          AS   INTEGER format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"    
        FIELD des-abrev-msg         AS   CHAR FORMAT "x(60)" COLUMN-LABEL 'Descri‡Æo Abreviada da Mensagem'
        FIELD des-compl-msg         AS   CHAR FORMAT "x(300)"
        FIELD des-tipo-msg          AS   CHAR                  /* Erro, Informa‡Æo, Pergunta */
        INDEX sequencia             IS PRIMARY IS UNIQUE
                    num-seq-msg
        INDEX titulo
                    cod_empresa
                    cod_estab
                    cod_espec_docto
                    cod_ser_docto
                    cod_tit_acr
                    cod_parcela. 
    


/* vari veis ------------------------------ */

        
