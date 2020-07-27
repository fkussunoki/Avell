OUTPUT TO c:\desenv\cta_faturamento.txt.

FOR EACH conta-ft NO-LOCK:


    PUT UNFORMATTED conta-ft.cod-estabel       ";"                       
conta-ft.cod-gr-cli                            ";" 
conta-ft.fm-codigo                             ";" 
conta-ft.ct-recven                             ";" 
conta-ft.sc-recven                             ";" 
conta-ft.ct-cusven                             ";" 
conta-ft.sc-cusven                             ";"  
conta-ft.ct-icms-ft                            ";" 
conta-ft.sc-icms-ft                            ";" 
conta-ft.ct-ipi-ft                             ";" 
conta-ft.sc-ipi-ft                             ";" 
conta-ft.ct-iss-ft                             ";" 
conta-ft.sc-iss-ft                             ";" 
conta-ft.ct-ir-ret                             ";" 
conta-ft.sc-ir-ret                             ";" 
conta-ft.ct-icmsub-ft                          ";" 
conta-ft.sc-icmsub-ft                          ";" 
conta-ft.sc-cofins-ft                          ";" 
conta-ft.ct-cofins-ft                          ";" 
conta-ft.ct-pis-ft                             ";" 
conta-ft.sc-pis-ft                             ";" 
conta-ft.nat-operacao                          ";" 
conta-ft.serie                                 ";" 
conta-ft.fm-com                                ";" 
conta-ft.no-ab-repre                           ";" 
conta-ft.ct-despesa                            ";" 
conta-ft.ge-codigo                             ";" 
conta-ft.ct-frete-ft                           ";" 
conta-ft.ct-diversos-ft                        ";" 
conta-ft.char-1                                ";" 
conta-ft.char-2                                ";" 
conta-ft.dec-1                                 ";" 
conta-ft.dec-2                                 ";" 
conta-ft.int-1                                 ";" 
conta-ft.int-2                                 ";" 
conta-ft.log-1                                 ";" 
conta-ft.log-2                                 ";" 
conta-ft.data-1                                ";" 
conta-ft.data-2                                ";" 
conta-ft.cod-depos                             ";" 
conta-ft.cod-canal-venda                       ";" 
conta-ft.it-codigo                             ";" 
conta-ft.check-sum                             ";" 
conta-ft.conta-dev-cpv                         ";" 
conta-ft.conta-dev-rec                         ";" 
conta-ft.Ct-desp-fretes                        ";" 
conta-ft.Sc-desp-fretes                        ";" 
conta-ft.cod-dev-prod                          ";" 
conta-ft.cod-ct-inss                           ";" 
conta-ft.cod-ct-pis                            ";" 
conta-ft.cod-ct-cofins                         ";" 
conta-ft.cod-livre-1                           ";" 
conta-ft.cod-livre-2                           ";" 
conta-ft.log-livre-1                           ";" 
conta-ft.log-livre-2                           ";" 
conta-ft.log-livre-3                           ";" 
conta-ft.log-livre-4                           ";" 
conta-ft.log-livre-5                           ";" 
conta-ft.log-livre-6                           ";" 
conta-ft.num-livre-1                           ";" 
conta-ft.num-livre-2                           ";" 
conta-ft.val-livre-1                           ";" 
conta-ft.val-livre-2                           ";" 
conta-ft.dat-livre-1                           ";" 
conta-ft.dat-livre-2                           ";" 
conta-ft.cod-cta-retenc-csll                   ";" 
conta-ft.cod-cta-retenc-pis                    ";" 
conta-ft.cod-cta-retenc-cofins                 ";" 
conta-ft.cod-cta-recta-export-nao-embarc       ";" 
conta-ft.cod-ccusto-recta-export-nao-emb       ";" 
conta-ft.cod-ccusto-retenc-cofins              ";" 
conta-ft.cod-ccusto-retenc-csll                ";" 
conta-ft.cod-ccusto-retenc-pis                 ";" 
conta-ft.cod-cta-devol-cpv                     ";" 
conta-ft.cod-ccusto-devol-cpv                  ";" 
conta-ft.cod-cta-devol-recta                   ";" 
conta-ft.cod-ccusto-devol-recta                ";" 
conta-ft.cod-cta-desc                          ";" 
conta-ft.cod-ccusto-desc                       ";" 
conta-ft.cod-cta-diver                         ";" 
conta-ft.cod-ccusto-diver                      ";" 
conta-ft.cod-cta-frete                         ";" 
conta-ft.cod-ccusto-frete                      ";" 
conta-ft.cod-cta-irrf                          ";" 
conta-ft.cod-cta-despes-iss                    ";" 
conta-ft.cod-cta-devol-produc                  ";" 
conta-ft.cod-ccusto-devol-produc               ";" 
conta-ft.cod-cta-inss-retid                    ";" 
conta-ft.cod-ccusto-inss-retid                 ";" 
conta-ft.cod-cta-pis                           ";" 
conta-ft.cod-ccusto-pis                        ";" 
conta-ft.cod-cta-cofins                        ";" 
conta-ft.cod-ccusto-cofins                     ";" 
conta-ft.cod-cta-retenc-iss                    ";" 
conta-ft.cod-ccusto-retenc-iss                 ";" 
conta-ft.cod-cta-despes-icms-sub               ";" 
conta-ft.cod-cta-cust-produt-vendido           ";" 
conta-ft.cod-cta-despes-recta-vda              ";" 
conta-ft.cod-cta-ctbl-despes-icms              ";" 
conta-ft.cod-cta-ctbl-despes-ipi               ";" 
conta-ft.cod-cta-ctbl-despes-frete             ";" 
conta-ft.cod-cta-ctbl-retenc-csll              ";" 
conta-ft.cod-cta-ctbl-retenc-pis               ";" 
conta-ft.cod-cta-ctbl-retenc-cofins            ";" 
conta-ft.cod-cta-ctbl-recta-export-nao-em      ";" 
conta-ft.cod-cta-ctbl-retenc-iss               ";" 
conta-ft.cod-cta-ctbl-despes-pis-subst         ";" 
conta-ft.cod-cta-ctbl-despes-cofins-subst       
SKIP.
































































END.
