    IF FIRST-OF(dc-tit_acr.vend-num-lote) THEN DO: 
        
        FIND FIRST banco OF emsfin.portador NO-LOCK NO-ERROR.
        FIND FIRST cta_corren OF portad_finalid_econ NO-LOCK NO-ERROR.
        FIND FIRST agenc_bcia OF cta_corren NO-LOCK NO-ERROR.

        IF AVAIL portador THEN
            ASSIGN c-banco          = portador.nom_pessoa
                   c-pessoa         = banco.nom_banco
                   c-banco-abrev[1] = banco.nom_banco
                   c-banco-abrev[2] = banco.nom_banco
                   c-banco-abrev[3] = banco.nom_banco
                   c-conta-cor[1]   = trim(cta_corren.cod_cta_corren_bco) + "-" + trim(cta_corren.cod_digito_cta_corren)
                   c-conta-cor[2]   = c-conta-cor[1]
                   c-agencia[1]     = trim(agenc_bcia.cod_agenc_bcia) + "-" + trim(agenc_bcia.cod_digito_agenc_bcia)
                   c-agencia[2]     = c-agencia[1]
                   c-nome-age[1]    = agenc_bcia.nom_pessoa
                   c-nome-age[2]    = agenc_bcia.nom_pessoa.
        ELSE 
            ASSIGN c-banco = ""
                   c-banco-abrev = ""
                   c-conta-cor = ""
                   c-agencia = ""
                   c-nome-age = "". 

        IF portador.cod_banco = "399" THEN DO:
           FIND FIRST msg_financ NO-LOCK
                WHERE msg_financ.cod_empresa  = v_cod_empres_usuar
                  AND msg_financ.cod_estab    = v_cod_estab_usuar 
                  AND msg_financ.cod_mensagem = "94" NO-ERROR.
           IF AVAIL msg_financ THEN
               ASSIGN c-nome-age[2] = c-nome-age[2] + msg_financ.des_mensagem.
        END.

        FIND FIRST b-pessoa_jurid NO-LOCK
            WHERE b-pessoa_jurid.num_pessoa_jurid = agenc_bcia.num_pessoa_jurid NO-ERROR.
        IF AVAIL b-pessoa_jurid THEN
            ASSIGN c-pessoa = b-pessoa_jurid.nom_pessoa.
        ELSE
            FIND FIRST pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = agenc_bcia.num_pessoa_jurid NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-pessoa = pessoa_fisic.nom_pessoa.

        ASSIGN i-ult-fech    = dc-tit_acr.vend-num-lote
               c-num-contrat = IF portador.cod_banco = "237"
                                  THEN "" 
                                  ELSE "n£mero " + cta_corren.cod_imagem
               c-cgc-banco   = b-pessoa_jurid.cod_id_feder     
               da-data       = cta_corren.dat_inic_movimen
               da-data-ax    = dc-tit_acr.vend-dt-fechamento.

        PUT  "VENDOR " c-pessoa  "- INSTRUMENTO DE FINANCIAMENTO - PLANILHA No."
             i-ult-fech[1] FORMAT ">>>,>>9" skip
             c-banco "- GCG: " c-cgc-banco FORMAT "99.999.999/9999-99" skip(1).

        RUN pi-msg(INPUT 90).       
                                                                           
        IF portador.cod_banco = '409' THEN /* unibanco */   DO:                 
            RUN pi-msg(INPUT 91). 
            PUT SKIP(1).
        END.
        ELSE DO:
            /*VIEW FRAME f-abertura-2.*/
            RUN pi-msg(INPUT 93).
            PUT SKIP(1).
        END.
        VIEW frame f-abertura-4.                                             
    END.

    FIND FIRST w-dias
        WHERE w-dias.dt-vencimen = dc-tit_acr.vend-dt-vencto NO-ERROR.

    IF NOT AVAIL w-dias THEN DO:

        CREATE w-dias.
        ASSIGN w-dias.dt-vencimen = dc-tit_acr.vend-dt-vencto
               w-dias.prazo       = dc-tit_acr.vend-dt-vencto -
                                    dc-tit_acr.vend-dt-fechamento
               w-dias.taxa-b      = dc-tit_acr.vend-taxa-banco.
    END.

    ASSIGN w-dias.valor    = w-dias.valor    + dc-tit_acr.vend-vl-tit-acr
           w-dias.vl-equal = w-dias.vl-equal + dc-tit_acr.vend-vl-equalizacao
           tot-vl-equal    = tot-vl-equal    + dc-tit_acr.vend-vl-equalizacao 
           tot-vl-ioc      = tot-vl-ioc      + dc-tit_acr.vend-vl-ioc.

    IF LAST-OF(dc-tit_acr.vend-num-lote) THEN DO:

        FOR EACH w-dias 
            BY w-dias.prazo:

            {doinc/dcr038rp2.i}
           
            PUT "! "                     AT 01
                w-dias.valor             TO 29
                w-dias.prazo             AT 41.
            
            IF portador.cod_banco = '41' THEN       

                PUT " Eq " w-dias.vl-equal FORMAT "->>,>>9.99".

            PUT w-dias.taxa-b FORMAT ">>>,>>9.999"  TO 74
                " !" TO 85 SKIP.

            ASSIGN de-valortot = de-valortot + w-dias.valor.

            DELETE w-dias.
        END.

        {doinc/dcr038rp2.i}

        PUT "!"              AT 01   
            "-------------"  TO 29 
            "!"              TO 85 SKIP.

        {doinc/dcr038rp2.i}

        PUT "!       Total: " AT 01 de-valortot
                      "IOC: " AT 35 tot-vl-ioc 
              "Equalizacao: " AT 55 tot-vl-equal FORMAT "->>>,>>9.99" "!" TO 85 SKIP
        "+-----------------------------------------------------------------------------------+" SKIP(1).

        
        RUN pi-msg(INPUT 92).

        ASSIGN de-valortot  = 0
               tot-vl-equal = 0
               tot-vl-ioc   = 0.

        VIEW FRAME f-assinatura.
        HIDE FRAME f-assinatura.                                                    
        
        PAGE.

        IF c-anexo-contrato = "yes" THEN DO:
            VIEW FRAME f-aber2.                                                       
    
            FOR EACH b-dc-tit_acr EXCLUSIVE-LOCK USE-INDEX lote
                WHERE b-dc-tit_acr.cod-empresa         = v_cod_empres_usuar
                  AND b-dc-tit_acr.cod_estab           = c-cod-estab-lote
                  AND b-dc-tit_acr.vend-num-lote       = num-lote,
                FIRST b-tit_acr OF b-dc-tit_acr
                WHERE b-tit_acr.cod_espec_docto = vendor_param.cod_espec_docto_neg
                BREAK BY b-tit_acr.cdn_cliente
                      BY b-dc-tit_acr.vend-dt-vencto:
    
                IF FIRST-OF(b-tit_acr.cdn_cliente) THEN DO: 
    
                    FIND FIRST emsuni.cliente NO-LOCK
                         WHERE emsuni.cliente.cod_empresa = b-tit_acr.cod_empresa
                           AND emsuni.cliente.cdn_cliente = b-tit_acr.cdn_cliente NO-ERROR.
                    IF AVAIL emsuni.cliente THEN DO:
    
                        FIND FIRST bb-pessoa_jurid NO-LOCK
                            WHERE bb-pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa NO-ERROR.
       
                        IF bb-pessoa_jurid.nom_ender_cobr <> '' THEN
    
                            ASSIGN c-nome-cli   = cliente.nom_pessoa
                                   c-est-cli    = bb-pessoa_jurid.cod_unid_federac_cobr       
                                   c-cep-cli    = bb-pessoa_jurid.cod_cep_cobr          
                                   c-cgc-cli    = bb-pessoa_jurid.cod_id_feder          
                                   c-ende-cli   = bb-pessoa_jurid.nom_ender_cobr
                                   c-cidade-cli = bb-pessoa_jurid.nom_cidad_cobr.
                        ELSE
                            ASSIGN c-nome-cli   = cliente.nom_pessoa
                                   c-est-cli    = bb-pessoa_jurid.cod_unid_federac       
                                   c-cep-cli    = bb-pessoa_jurid.cod_cep          
                                   c-cgc-cli    = bb-pessoa_jurid.cod_id_feder          
                                   c-ende-cli   = bb-pessoa_jurid.nom_endereco
                                   c-cidade-cli = bb-pessoa_jurid.nom_cidade.
                    END.
    
                    ELSE DO:
                    
                        ASSIGN c-nome-cli   = " "
                               c-cep-cli    = '0'   
                               c-ende-cli = " "
                               c-cidade-cli = " " 
                               c-est-cli = " ".
                    END.
                    IF LINE-COUNTER >= 54 THEN DO:
                        
                        PUT "+-----------------------------------------------------------------------------------+" skip.
                     
                        PAGE.
                    END.
    
                    VIEW FRAME f-labels.                                  
    
                END. /*first-of*/
    
                IF LINE-COUNTER = 64 THEN DO:
                    
                    PUT "+------------------------------------------"
                        "-----------------------------------------+" skip.
                    
                    PAGE.
                    
                    VIEW frame f-labels.                                   
                END.
    
                IF portador.cod_banco <> '237' then do:   /* Bradesco */
                   ASSIGN dt-emis = b-tit_acr.dat_emis_docto.
                END.
                ELSE DO:
                   ASSIGN de-taxa-cli = b-dc-tit_acr.vend-taxa-cliente.
                END.
    
                PUT "!" int(b-tit_acr.cod_tit_acr) FORMAT ">>>>>>9" "/" string(b-tit_acr.cod_parcela) FORMAT "x(2)" "!" AT 15
                         b-dc-tit_acr.vend-vl-tit-acr format ">>>>>,>>9.99" "!"
                         b-dc-tit_acr.vend-vl-prestacao format ">>>>>,>>9.99" "!".        
                        
                IF portador.cod_banco = '237' THEN
                    PUT space(2) b-dc-tit_acr.vend-taxa-final format ">>>9.99"  SPACE(1).   
    
                ELSE
                    PUT dt-emis format "99/99/9999".
    
                PUT    "!" day(b-dc-tit_acr.vend-dt-vencto) format "99" "/"
                       month(b-dc-tit_acr.vend-dt-vencto) format "99" "/"
                        year(b-dc-tit_acr.vend-dt-vencto) format "9999" "!"
                       b-dc-tit_acr.vend-vl-equalizacao format "->>>,>>9.99" "!"
                       b-dc-tit_acr.vend-vl-ioc format ">>>>>9.99" "!" skip.                 
                    
                ASSIGN tot-vl-saldo = tot-vl-saldo + b-dc-tit_acr.vend-vl-tit-acr
                       tot-vl-prest = tot-vl-prest + b-dc-tit_acr.vend-vl-prestacao
                       tot-vl-equal = tot-vl-equal + b-dc-tit_acr.vend-vl-equalizacao
                       tot-vl-ioc   = tot-vl-ioc   + b-dc-tit_acr.vend-vl-ioc.
    
                IF LAST(b-tit_acr.cdn_cliente) THEN DO:
                  
                    PUT "!------------------------------------------"
                        "-----------------------------------------!" skip
                        "!TOTAIS"                           at 01 
                        "!"                                 at 15
                        tot-vl-saldo FORMAT ">,>>>,>>9.99"  at 16 "!"
                        tot-vl-prest FORMAT ">>>>,>>9.99"   at 30 "!"
                        "!"                                 at 52 
                        "!"                                 at 63 
                        tot-vl-equal FORMAT "->>>,>>9.99"  at 64 
                        "!"
                        tot-vl-ioc   FORMAT "->>>>9.99"    at 76 "!" skip.
    
                    ASSIGN tot-vl-saldo = 0
                           tot-vl-prest = 0
                           tot-vl-equal = 0
                           tot-vl-ioc   = 0.
    
                    IF LINE-COUNTER < 64 THEN
    
                        PUT "+------------------------------------------"
                            "-----------------------------------------+" skip.
                END.
    
                ASSIGN b-dc-tit_acr.vend-emitiu-contrato = YES.
    
            END. /* for each */
            
            PAGE.
    
            HIDE FRAME f-aber2.
        END.

    END. /* if last-of */
