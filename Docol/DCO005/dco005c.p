/*********************************************************************************************************
** Programa.........: dco005
** Descricao .......: Zera Comiss∆o nos Pedidos em Carteira (N∆o faturados)
** Versao...........: 01.001
** Nome Externo.....: dop/dco005c.p
** Autor............: Diomar Muhlmann
** Criado...........: 19/11/2003
*********************************************************************************************************/
ON WRITE OF ped-repre OVERRIDE DO:
END.

DEF TEMP-TABLE tt-ped-venda NO-UNDO
                            FIELD nome-abrev            AS CHAR
                            FIELD nr-pedcli             AS CHAR
                            FIELD vl-base               AS DEC
                            FIELD vl-comissao           AS DEC
                            FIELD perc-comis            AS DEC
                            FIELD comis-emis            AS DEC.

DEFINE INPUT PARAM i-cdn_repres LIKE representante.cdn_repres.
DEFINE INPUT PARAM TABLE FOR tt-ped-venda.

FIND FIRST mgcad.repres
     WHERE mgcad.repres.cod-rep = i-cdn_repres NO-ERROR.
IF AVAIL mgcad.repres THEN DO:
   FOR EACH tt-ped-venda.
       FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = tt-ped-venda.nome-abrev
              AND ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.
       FIND ped-repre 
            WHERE ped-repre.nome-ab-rep = repres.nome-abrev
              AND ped-repre.nr-pedido   = ped-venda.nr-pedido no-error.
       IF AVAIL ped-repre THEN DO: 
          ASSIGN ped-repre.perc-comis = 0
                 ped-repre.comis-emis = 0.
       END.
   END.
END.

/* dco005c.p */
