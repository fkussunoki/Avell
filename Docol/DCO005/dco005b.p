/*********************************************************************************************************
** Programa.........: dco005
** Descricao .......: Total de Comiss∆o em Carteira (Pedidos em Aberto) para Rescis∆o de Representante
** Versao...........: 01.001
** Nome Externo.....: dop/dco005a.p
** Autor............: Diomar Muhlmann
** Criado...........: 19/11/2003
*********************************************************************************************************/

DEF TEMP-TABLE tt-ped-venda NO-UNDO
                            FIELD nome-abrev            AS CHAR
                            FIELD nr-pedcli             AS CHAR
                            FIELD vl-base               AS DEC
                            FIELD vl-comissao           AS DEC
                            FIELD perc-comis            AS DEC
                            FIELD comis-emis            AS DEC.

DEFINE INPUT  PARAM i-cdn_repres LIKE representante.cdn_repres.
DEFINE OUTPUT PARAM TABLE FOR tt-ped-venda.

FIND FIRST mgcad.repres
     WHERE mgcad.repres.cod-rep = i-cdn_repres NO-ERROR.
IF AVAIL mgcad.repres THEN DO:
   FOR EACH ped-venda NO-LOCK USE-INDEX ch-rep-cli
      WHERE ped-venda.no-ab-reppri = repres.nome-abrev
        AND ped-venda.cod-sit-ped  < 3:
      FIND FIRST ped-repre NO-LOCK
           WHERE ped-repre.nome-ab-rep = repres.nome-abrev
             AND ped-repre.nr-pedido   = ped-venda.nr-pedido no-error.
      IF AVAIL ped-repre then do: 
         IF ped-venda.cod-sit-ped  = 1 THEN DO:  /* Aberto */
            CREATE tt-ped-venda.
            ASSIGN tt-ped-venda.nome-abrev  = ped-venda.nome-abrev
                   tt-ped-venda.nr-pedcli   = ped-venda.nr-pedcli
                   tt-ped-venda.vl-base     = ped-venda.vl-liq-ped
                   tt-ped-venda.vl-comissao = truncate((ped-venda.vl-liq-ped * ped-repre.perc-comis / 100), 2)
                   tt-ped-venda.perc-comis  = ped-repre.perc-comis
                   tt-ped-venda.comis-emis  = ped-repre.comis-emis.
         END.
         ELSE DO: /* Atendido Parcial */
            CREATE tt-ped-venda.
            ASSIGN tt-ped-venda.nome-abrev  = ped-venda.nome-abrev
                   tt-ped-venda.nr-pedcli   = ped-venda.nr-pedcli
                   tt-ped-venda.vl-base     = ped-venda.vl-liq-ped
                   tt-ped-venda.vl-comissao = truncate((ped-venda.vl-liq-abe * ped-repre.perc-comis / 100), 2)
                   tt-ped-venda.perc-comis  = ped-repre.perc-comis
                   tt-ped-venda.comis-emis  = ped-repre.comis-emis.
         END.
      END.
   END.
END.

/* dco005b.p */
