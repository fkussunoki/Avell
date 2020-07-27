def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_sc-codigo        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_c-descricao      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btok             AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btconfirma       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_upcc0300b_btsave           AS HANDLE NO-UNDO.



DEF INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.


FIND FIRST usuar-ccusto NO-LOCK WHERE usuar-ccusto.cod-usuario = v_cod_usuar_corren
                                AND   usuar-ccusto.sc-codigo   = h_upcc0300b_sc-codigo:SCREEN-VALUE NO-ERROR.


IF NOT AVAIL usuar-ccusto THEN DO:

    ASSIGN h_upcc0300b_btok:SENSITIVE = NO
           h_upcc0300b_btconfirma:SENSITIVE = NO
           h_upcc0300b_btsave:SENSITIVE = NO
           h_upcc0300b_c-descricao:SCREEN-VALUE = "Centro de Custo nao permitido"
           h_upcc0300b_c-descricao:BGCOLOR = 12
           h_upcc0300b_c-descricao:FGCOLOR = 15.
 

END.

ELSE DO:

    FIND FIRST emsbas.ccusto NO-LOCK WHERE emsbas.ccusto.cod_ccusto = h_upcc0300b_sc-codigo:SCREEN-VALUE NO-ERROR.
    ASSIGN h_upcc0300b_btok:SENSITIVE = YES
          h_upcc0300b_btconfirma:SENSITIVE = YES
          h_upcc0300b_btsave:SENSITIVE = YES
          h_upcc0300b_c-descricao:SCREEN-VALUE = emsbas.ccusto.des_tit_ctbl
          h_upcc0300b_c-descricao:BGCOLOR = 8
          h_upcc0300b_c-descricao:FGCOLOR = 0.




    
END.

