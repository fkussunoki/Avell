
DEF INPUT param p-banco   AS char.
DEF INPUT param p-agencia AS char.
DEF INPUT param p-conta AS char.
/* Local Variable Definitions ---                                       */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.


DEFINE TEMP-TABLE tt-conta
    FIELD cdn_fornecedor AS INTEGER
    FIELD cod_banco      AS char
    FIELD cod_agenc_bcia AS char
    FIELD cod_digito_ag  AS char
    FIELD cod_cta_corren AS char
    FIELD cod_digito_cc  AS CHARACTER
    FIELD cod_empresa    AS char.

DEF NEW GLOBAL SHARED VAR v_rec_fornec_financ AS RECID NO-UNDO.


DEF NEW GLOBAL SHARED VAR v_rec_banco AS RECID NO-UNDO.

DEF BUFFER b_cta FOR cta_corren_fornec.



FIND FIRST fornec_financ WHERE recid(fornec_financ) = v_rec_fornec_financ NO-ERROR.

FOR EACH cta_corren_fornec WHERE cta_corren_fornec.cdn_fornecedor  = fornec_financ.cdn_fornecedor
                           AND   cta_corren_fornec.cod_banco = p-banco
                           AND   cta_corren_fornec.cod_agenc_bcia = p-agencia
                           AND   cta_corren_fornec.cod_cta_corren_bco = p-conta:

  

            IF cta_corren_fornec.log_cta_corren_prefer = YES THEN DO:
                

                FIND FIRST b_cta WHERE b_cta.cod_empresa = cta_corren_fornec.cod_empresa
                                 AND   b_cta.cdn_fornecedor = cta_corren_fornec.cdn_fornecedor
                                 AND   b_cta.cod_cta_corren_bco <> cta_corren_fornec.cod_cta_corren_bco NO-ERROR.

                IF AVAIL b_cta THEN DO:
                    CREATE tt-conta.
                    ASSIGN tt-conta.cdn_fornecedor = cta_corren_fornec.cdn_fornecedor
                           tt-conta.cod_banco      = cta_corren_fornec.cod_banco
                           tt-conta.cod_agenc_bcia = cta_corren_fornec.cod_agenc_bcia
                           tt-conta.cod_digito_ag  = cta_corren_fornec.cod_digito_agenc_bcia
                           tt-conta.cod_cta_corren = cta_corren_fornec.cod_cta_corren_bco
                           tt-conta.cod_digito_cc  = cta_corren_fornec.cod_digito_cta_corren
                           tt-conta.cod_empresa    = cta_corren_fornec.cod_empresa.
                    
                    ASSIGN b_cta.log_cta_corren_prefer = YES.
                    ASSIGN fornec_financ.cod_banco = b_cta.cod_banco
                           fornec_financ.cod_agenc_bcia = b_cta.cod_agenc_bcia
                           fornec_financ.cod_digito_agenc_bcia = b_cta.cod_digito_agenc_bcia
                           fornec_financ.cod_cta_corren_bco = b_cta.cod_cta_corren_bco
                           fornec_financ.cod_digito_cta_corren = b_cta.cod_digito_cta_corren.

                END.

                IF NOT AVAIL b_cta THEN DO:
                    CREATE tt-conta.
                    ASSIGN tt-conta.cdn_fornecedor = cta_corren_fornec.cdn_fornecedor
                           tt-conta.cod_banco      = cta_corren_fornec.cod_banco
                           tt-conta.cod_agenc_bcia = cta_corren_fornec.cod_agenc_bcia
                           tt-conta.cod_digito_ag  = cta_corren_fornec.cod_digito_agenc_bcia
                           tt-conta.cod_cta_corren = cta_corren_fornec.cod_cta_corren_bco
                           tt-conta.cod_digito_cc  = cta_corren_fornec.cod_digito_cta_corren
                           tt-conta.cod_empresa    = cta_corren_fornec.cod_empresa.
                    

                        ASSIGN fornec_financ.cod_banco = ''
                               fornec_financ.cod_agenc_bcia = ''
                               fornec_financ.cod_digito_agenc_bcia = ''
                               fornec_financ.cod_cta_corren_bco = ''
                               fornec_financ.cod_digito_cta_corren = ''.


            END.
       END.


            IF cta_corren_fornec.log_cta_corren_prefer = NO THEN DO:
                CREATE tt-conta.
                ASSIGN tt-conta.cdn_fornecedor = cta_corren_fornec.cdn_fornecedor
                       tt-conta.cod_banco      = cta_corren_fornec.cod_banco
                       tt-conta.cod_agenc_bcia = cta_corren_fornec.cod_agenc_bcia
                       tt-conta.cod_digito_ag  = cta_corren_fornec.cod_digito_agenc_bcia
                       tt-conta.cod_cta_corren = cta_corren_fornec.cod_cta_corren_bco
                       tt-conta.cod_digito_cc  = cta_corren_fornec.cod_digito_cta_corren
                       tt-conta.cod_empresa    = cta_corren_fornec.cod_empresa.
                
                ASSIGN fornec_financ.cod_banco = ''
                       fornec_financ.cod_agenc_bcia = ''
                       fornec_financ.cod_digito_agenc_bcia = ''
                       fornec_financ.cod_cta_corren_bco = ''
                       fornec_financ.cod_digito_cta_corren = ''.
           END.


END.

RUN pi-apagar.

PROCEDURE pi-apagar:

    FOR EACH tt-conta:

        FIND FIRST cta_corren_fornec WHERE cta_corren_fornec.cod_empresa = tt-conta.cod_empresa
                                     AND   cta_corren_fornec.cdn_fornecedor = tt-conta.cdn_fornecedor
                                     AND   cta_corren_fornec.cod_banco       = tt-conta.cod_banco
                                     AND   cta_corren_fornec.cod_agenc_bcia  = tt-conta.cod_agenc_bcia
                                     AND   cta_corren_fornec.cod_cta_corren_bco = tt-conta.cod_cta_corren NO-ERROR.

        DELETE cta_corren_fornec.



END.





END PROCEDUre.
