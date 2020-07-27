DEF TEMP-TABLE tt-dados NO-UNDO
    FIELD i-cdn-repres         AS INT
    FIELD i-dia-pagto          AS INT
    FIELD c-indic-corr         AS CHAR
    FIELD c-mes-pagto          AS CHAR
    FIELD dat-rescisao         AS DATE
    FIELD i-meses-aviso-previo AS INT
    FIELD de-indice-atualiz    AS DEC
    FIELD de-val-atualizado    AS DEC
    FIELD de-1-12-avos         AS DEC
    FIELD de-aviso-previo      AS DEC
    FIELD de-val-mes-rescisao  AS DEC
    FIELD log-pg-1-12-avos     AS LOG
    FIELD log-pg-aviso-previo  AS LOG
    field perc-rescisao        as dec
    field de-val-indenizado    as dec.

DEF TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD ano                   AS INTEGER
    FIELD mes                   AS INTEGER
    FIELD valor-total           AS DECIMAL
    FIELD indice-corr           AS DECIMAL
    FIELD dat-indice            AS DATE
    FIELD valor-corrig          AS DECIMAL
    field perc-rescisao-parcial as decimal
    field val-base-calculo      as decimal
    INDEX prim IS PRIMARY UNIQUE ano DESC
                                 mes DESC.

/* dco010.i */
