DEFINE TEMP-TABLE tt-cta-ext NO-UNDO
    FIELD ttv-cta-ext AS char
    FIELD ttv-cc-ext  AS char
    FIELD ttv-est-ext AS char
    FIELD ttv-cta     AS char
    FIELD ttv-cc      AS char
    FIELD ttv-estab   AS char.



DEF VAR i AS INTEGER NO-UNDO.

ASSIGN i = 10.
INPUT FROM c:\desenv\matriz.txt.

REPEAT:
    CREATE tt-cta-ext.
    IMPORT DELIMITER ";" tt-cta-ext.
END.


FOR EACH tt-cta-ext:

    CREATE trad_cta_ctbl_ext.
    ASSIGN trad_cta_ctbl_ext.cod_unid_organ = "1"
           trad_cta_ctbl_ext.cod_matriz_trad_cta_ext = "SAGE"
           trad_cta_ctbl_ext.cod_cta_ctbl_ext = tt-cta-ext.ttv-cta-ext
           trad_cta_ctbl_ext.cod_ccusto_ext   = tt-cta-ext.ttv-cc-ext
           trad_cta_ctbl_ext.cod_estab_ext    = tt-cta-ext.ttv-est-ext
           trad_cta_ctbl_ext.cod_plano_cta_ctbl = "PC-ETENO"
           trad_cta_ctbl_ext.cod_plano_ccusto   = "CC-ETENO"
           trad_cta_ctbl_ext.cod_cta_ctbl       = tt-cta-ext.ttv-cta
           trad_cta_ctbl_ext.cod_ccusto         = tt-cta-ext.ttv-cc
           trad_cta_ctbl_ext.cod_estab          = tt-cta-ext.ttv-estab
           trad_cta_ctbl_ext.des_cta_ctbl_ext   = "SAGE"
           trad_cta_ctbl_ext.cod_unid_negoc     = "ETE"
           trad_cta_ctbl_ext.dat_inic_valid     = 01/01/0001
           trad_cta_ctbl_ext.dat_fim_valid      = 12/31/9999
           trad_cta_ctbl_ext.num_seq_trad_cta_ctbl_ext = I
           .

    ASSIGN i = i + 10.

END.
