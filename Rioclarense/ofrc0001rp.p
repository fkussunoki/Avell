/* include de controle de versão */
{include/i-prgvrs.i ofrc0001 1.00.00.003}
/* definiŒão das temp-tables para recebimento de par?metros */



    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)"
        field modelo-rtf       as char format "x(35)"
        field l-habilitaRtf    as LOG
        FIELD c-estab-ini     AS char
        FIELD c-estab-fim     AS char
        FIELD c-dt-corte-ini   AS date
        FIELD c-dt-corte-fim   AS DATE
        FIELD c-cta-icms      AS char
        FIELD l-aberto       AS LOGICAL.
.



def temp-table tt-raw-digita
    	field raw-digita	as raw.
/* recebimento de par?metros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.


DEFINE TEMP-TABLE TT-FTP
    FIELD COD_ESTAB AS CHAR
    FIELD DATA       AS DATE
    FIELD LOTE       AS INTEGER
    FIELD DOCUMENTO  AS CHAR
    FIELD SERIE      AS CHAR
    FIELD VLR_CONTABIL AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD VLR_NOTA     AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD HISTORICO    AS CHAR FORMAT "X(40)"
    FIELD CONCATENA    AS CHAR FORMAT "X(40)".

DEFINE TEMP-TABLE TT-FTP2 LIKE TT-FTP.

DEFINE TEMP-TABLE TT-INEXISTENTES
    FIELD COD_ESTAB AS CHAR
    FIELD DATA      AS DATE
    FIELD VLR AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99"
    FIELD MODULO    AS chaR
    FIELD GE-CODIGO AS CHAR
    FIELD UNEGOC    AS CHAR
    FIELD CONCATENA  AS CHAR FORMAT "X(40)".

DEFINE TEMP-TABLE TT-INEXISTENTES2 LIKE TT-INEXISTENTES.

DEFINE TEMP-TABLE TT-SUPORTE
    FIELD COD_ESTAB AS CHAR
    FIELD DOCUMENTO AS CHAR
    FIELD SERIE     AS CHAR
    FIELD DATA      AS DATE
    FIELD SITUACAO  AS LOGICAL
    FIELD VLR AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".

DEFINE VAR V_TOT AS DECIMAL.
DEFINE VAR V_TOT1 AS DECIMAL.

DEFINE VAR H-PROG AS HANDLE.
DEFINE VAR I-TOT AS INTEGER.


DEFINE VAR m-linha AS INTEGER.

DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}

       chExcel:sheetsinNewWorkbook = 1.
       chWorkbook = chExcel:Workbooks:ADD().
       chworksheet=chWorkBook:sheets:item(1).
       chworksheet:name="ICMS". /* Nome que ser‰ criada a Pasta da Planilha */
       m-linha = 2.
       chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
       chworksheet:range("A1:g1"):FONT:colorindex = 02. /* Aplica fonte cor Branca no Titulo */
       chworksheet:range("A1:g1"):MergeCells = TRUE. /* Cria a Planilha */
       chworksheet:range("A1:g1"):SetValue("Recebimento").
       chWorkSheet:Range("A1:g1"):HorizontalAlignment = 3. /* Centraliza o Titulo */
       chWorkSheet:Range("A1:g1"):Interior:colorindex = 01. /* Aplica fundo preto no titulo */
     /* Cria os titulos para as colunas do relat¸rio */
           chworksheet:range("A2:e2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */
           chworksheet:range("A" + STRING(m-linha)):SetValue("Data").
           chworksheet:range("b" + STRING(m-linha)):SetValue("Estab").
           chworksheet:range("c" + STRING(m-linha)):SetValue("GE-Cod").
           chworksheet:range("d" + STRING(m-linha)):SetValue("Unid.Neg").
           chworksheet:range("e" + STRING(m-linha)):SetValue("Vlr.Cep").
           chworksheet:range("f" + STRING(m-linha)):SetValue("Vlr.FGL").
           chworksheet:range("g" + STRING(m-linha)):SetValue("Diferenca").

        m-linha = m-linha + 1.


FIND FIRST tt-param NO-ERROR.

IF tt-param.l-aberto = YES THEN
    RUN pi-analitico.

ELSE
    
    RUN pi-sintetico.



PROCEDURE pi-analitico:

/* RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.                                                                                          */
/*                                                                                                                                   */
/*                                                                                                                                   */
/* FIND FIRST tt-param NO-ERROR.                                                                                                     */
/*     FOR EACH item_lancto_ctbl USE-INDEX tmlnctcb_estab NO-LOCK WHERE item_lancto_ctbl.dat_lancto_ctbl >= tt-param.c-dt-corte-ini  */
/*                                           AND   item_lancto_ctbl.dat_lancto_ctbl <= tt-param.c-dt-corte-fim                       */
/*                                           AND   item_lancto_ctbl.cod_cta_ctbl = tt-param.c-cta-icms                               */
/*                                           AND   item_lancto_ctbl.cod_estab    >= tt-param.c-estab-ini                             */
/*                                           AND   item_lancto_ctbl.cod_estab    <= tt-param.c-estab-fim                             */
/*                                           AND   item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"                                     */
/*                                           AND   item_lancto_ctbl.cod_plano_cta_ctbl = "PADRAO"                                    */
/*                                           BREAK BY item_lancto_ctbl.dat_lancto_ctbL:                                              */
/*                                                                                                                                   */
/*                                                                                                                                   */
/* ASSIGN I-TOT = I-TOT + 1.                                                                                                         */
/*                                                                                                                                   */
/* END.                                                                                                                              */
/*                                                                                                                                   */


RUN utp/ut-acomp.p PERSISTENT SET h-prog.
RUN PI-INICIALIZAR IN H-PROG (INPUT "MONTANDO GERAL").

    FOR EACH item_lancto_ctbl USE-INDEX tmlnctcb_estab NO-LOCK WHERE item_lancto_ctbl.dat_lancto_ctbl >= tt-param.c-dt-corte-ini
                                          AND   item_lancto_ctbl.dat_lancto_ctbl <= tt-param.c-dt-corte-fim
                                          AND   item_lancto_ctbl.cod_cta_ctbl = tt-param.c-cta-icms
                                          AND   item_lancto_ctbl.cod_estab    >= tt-param.c-estab-ini
                                          AND   item_lancto_ctbl.cod_estab    <= tt-param.c-estab-fim
                                          AND   item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"
                                          AND   item_lancto_ctbl.cod_plano_cta_ctbl = "PADRAO"
                                          BREAK BY item_lancto_ctbl.dat_lancto_ctbL:


        RUN PI-ACOMPANHAR IN H-PROG(INPUT "Estab: " + item_lancto_ctbl.cod_estab + "Data: " + STRING(item_lancto_ctbl.dat_lancto_ctbL) + "lote: "  + STRING(item_lancto_ctbl.num_lote_ctbl)).
        FIND FIRST lote_ctbl NO-LOCK WHERE lote_ctbl.num_lote_ctbl = item_lancto_ctbl.num_lote_ctbl
                                     AND   lote_ctbl.cod_modul_dtsul = "CEP" NO-ERROR.

        IF AVAIL lote_ctbl THEN DO:
            
        

          CREATE TT-FTP.
          ASSIGN TT-FTP.COD_ESTAB = item_lancto_ctbl.cod_estab
                 TT-FTP.DATA      = item_lancto_ctbl.dat_lancto_ctbl
                 TT-FTP.LOTE      = item_lancto_ctbl.num_lote_ctbl
                 TT-FTP.VLR_CONTABIL = item_lancto_ctbl.val_lancto_ctbl
                 TT-FTP.HISTORICO = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl, "MOVTO REF A CONTROLE DE ESTOQUE GRUPO:", "|"), "EST:", "|"), "UNID NEG:", "|"), "DIA:", "|")).


  END.
END.

RUN PI-FINALIZAR IN H-PROG.

FOR EACH TT-FTP:
    ASSIGN TT-FTP.CONCATENA = TRIM(REPLACE(ENTRY(5,TT-FTP.HISTORICO, "|"), "/20", "/")) + TRIM(ENTRY(2,TT-FTP.HISTORICO, "|")) + TRIM(ENTRY(4,TT-FTP.HISTORICO, "|")) + TRIM(ENTRY(3,TT-FTP.HISTORICO, "|")).
END.


RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.

FOR EACH TT-FTP:

    ASSIGN I-TOT = I-TOT  + 1.

END.

RUN PI-INICIALIZAR IN H-PROG (INPUT "MONTANDO GERAL ii", I-TOT).
FOR EACH TT-FTP BREAK BY TT-FTP.CONCATENA:

    ACCUMULATE TT-FTP.VLR_CONTABIL (SUB-TOTAL BY TT-FTP.CONCATENA).

    IF LAST-OF(TT-FTP.CONCATENA) THEN DO:
        

        CREATE TT-FTP2.
        ASSIGN TT-FTP2.COD_ESTAB = TT-FTP.COD_ESTAB
               TT-FTP2.DATA      = TT-FTP.DATA
               TT-FTP2.LOTE      = TT-FTP.LOTE
               TT-FTP2.VLR_CONTABIL = ACCUM SUB-TOTAL BY TT-FTP.CONCATENA TT-FTP.VLR_CONTABIL
               TT-FTP2.CONCATENA    = TT-FTP.CONCATENA.

    END.
END.
RUN PI-FINALIZAR IN H-PROG.


RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.


FIND FIRST tt-param NO-ERROR.
FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel >= tt-param.c-estab-ini
                             AND   movto-estoq.cod-estabel <= tt-param.c-estab-fim
                             AND   (movto-estoq.valor-icm   > 0
                             OR    movto-estoq.ct-codigo  = tt-param.c-cta-icms)
                             AND   movto-estoq.dt-trans    >= tt-param.c-dt-corte-ini
                             AND   movto-estoq.dt-trans    <= tt-param.c-dt-corte-fim
                             BREAK BY movto-estoq.dt-trans:

ASSIGN I-TOT = I-TOT +  1.

END.


RUN PI-INICIALIZAR IN H-PROG (INPUT "FASE1", I-TOT).
FIND FIRST tt-param NO-ERROR.
FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel >= tt-param.c-estab-ini
                             AND   movto-estoq.cod-estabel <= tt-param.c-estab-fim
                             AND   (movto-estoq.valor-icm   > 0
                             OR    movto-estoq.ct-codigo  = tt-param.c-cta-icms)
                             AND   movto-estoq.dt-trans    >= tt-param.c-dt-corte-ini
                             AND   movto-estoq.dt-trans    <= tt-param.c-dt-corte-fim
                             BREAK BY movto-estoq.dt-trans:

    FIND FIRST ITEM WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.

RUN PI-ACOMPANHAR IN H-PROG.


            CREATE TT-INEXISTENTES.
            ASSIGN TT-INEXISTENTES.COD_ESTAB = movto-estoq.cod-estabel
                   TT-INEXISTENTES.DATA      = movto-estoq.dt-trans
                   TT-INEXISTENTES.MODULO    = "FTP"
                   TT-INEXISTENTES.GE-CODIGO = STRING(ITEM.ge-codigo)
                   TT-INEXISTENTES.UNEGOC    = movto-estoq.cod-unid-negoc
                   TT-INEXISTENTES.CONCATENA = STRING(movto-estoq.dt-trans) + STRING(ITEM.ge-codigo) + movto-estoq.cod-unid-negoc + movto-estoq.cod-estabel.

            IF movto-estoq.ct-codigo = tt-param.c-cta-icms THEN DO:
            ASSIGN TT-INEXISTENTES.VLR       = IF movto-estoq.tipo-trans = 2 THEN movto-estoq.valor-mat-m[1] ELSE movto-estoq.valor-mat-m[1] * - 1.
                
            END.

            ELSE DO:
            
                   TT-INEXISTENTES.VLR       = IF movto-estoq.esp-docto = 20 THEN /*IF movto-estoq.tipo-trans = 1 THEN */ movto-estoq.valor-icm  * - 1
                       ELSE movto-estoq.valor-icm. /*ELSE movto-estoq.valor-icm * - 1 */ /*Foi verificado que a movto-estoq quando tem NFE nao considera ICMS cmo saida*/.
                   
            END.       

        END.


RUN PI-FINALIZAR IN H-PROG.



RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.

FOR EACH TT-INEXISTENTES    BREAK BY TT-INEXISTENTES.DATA:

ASSIGN I-TOT = I-TOT +  1.

END.


RUN PI-INICIALIZAR IN H-PROG (INPUT "FASE1", I-TOT).
FOR EACH TT-INEXISTENTES    BREAK BY TT-INEXISTENTES.CONCATENA:

RUN PI-ACOMPANHAR IN H-PROG.


    ACCUMULATE TT-INEXISTENTES.VLR (SUB-TOTAL BY TT-INEXISTENTES.CONCATENA).


    IF LAST-OF(TT-INEXISTENTES.CONCATENA) THEN DO:
        
    

            CREATE TT-INEXISTENTES2.
            ASSIGN TT-INEXISTENTES2.COD_ESTAB = TT-INEXISTENTES.COD_ESTAB
                   TT-INEXISTENTES2.DATA      = TT-INEXISTENTES.DATA
                   TT-INEXISTENTES2.VLR       = ACCUM SUB-TOTAL BY TT-INEXISTENTES.CONCATENA TT-INEXISTENTES.VLR
                   TT-INEXISTENTES2.MODULO    = "CEP"
                   TT-INEXISTENTES2.GE-CODIGO  = TT-INEXISTENTES.GE-CODIGO
                   TT-INEXISTENTES2.UNEGOC     = TT-INEXISTENTES.UNEGOC
                   TT-INEXISTENTES2.CONCATENA  = TT-INEXISTENTES.CONCATENA
                    .

        END.
   END.


RUN PI-FINALIZAR IN H-PROG.

OUTPUT TO C:\TEMP\INEXIST.TXT.
FOR EACH TT-INEXISTENTES2:

    DISP TT-INEXISTENTES2.CONCATENA.
END.


OUTPUT TO C:\TEMP\FTP.TXT.
FOR EACH TT-FTP2:
    DISP TT-FTP2.CONCATENA.
END.

END PROCEDURE.



PROCEDURE pi-sintetico:
    RUN utp/ut-acomp.p PERSISTENT SET h-prog.
    RUN PI-INICIALIZAR IN H-PROG (INPUT "MONTANDO GERAL").

        FOR EACH item_lancto_ctbl USE-INDEX tmlnctcb_estab NO-LOCK WHERE item_lancto_ctbl.dat_lancto_ctbl >= tt-param.c-dt-corte-ini
                                              AND   item_lancto_ctbl.dat_lancto_ctbl <= tt-param.c-dt-corte-fim
                                              AND   item_lancto_ctbl.cod_cta_ctbl = tt-param.c-cta-icms
                                              AND   item_lancto_ctbl.cod_estab    >= tt-param.c-estab-ini
                                              AND   item_lancto_ctbl.cod_estab    <= tt-param.c-estab-fim
                                              AND   item_lancto_ctbl.ind_sit_lancto_ctbl = "CTBZ"
                                              AND   item_lancto_ctbl.cod_plano_cta_ctbl = "PADRAO"
                                              BREAK BY item_lancto_ctbl.dat_lancto_ctbL:


            RUN PI-ACOMPANHAR IN H-PROG(INPUT "Estab: " + item_lancto_ctbl.cod_estab + "Data: " + STRING(item_lancto_ctbl.dat_lancto_ctbL) + "lote: "  + STRING(item_lancto_ctbl.num_lote_ctbl)).
            FIND FIRST lote_ctbl NO-LOCK WHERE lote_ctbl.num_lote_ctbl = item_lancto_ctbl.num_lote_ctbl
                                         AND   lote_ctbl.cod_modul_dtsul = "CEP" NO-ERROR.

            IF AVAIL lote_ctbl THEN DO:



              CREATE TT-FTP.
              ASSIGN TT-FTP.COD_ESTAB = item_lancto_ctbl.cod_estab
                     TT-FTP.DATA      = item_lancto_ctbl.dat_lancto_ctbl
                     TT-FTP.LOTE      = item_lancto_ctbl.num_lote_ctbl
                     TT-FTP.VLR_CONTABIL = item_lancto_ctbl.val_lancto_ctbl
                     TT-FTP.HISTORICO = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl, "MOVTO REF A CONTROLE DE ESTOQUE GRUPO:", "|"), "EST:", "|"), "UNID NEG:", "|"), "DIA:", "|")).


      END.
    END.

    RUN PI-FINALIZAR IN H-PROG.

    FOR EACH TT-FTP:
        ASSIGN TT-FTP.CONCATENA = TRIM(ENTRY(2,TT-FTP.HISTORICO, "|")) + TRIM(ENTRY(4,TT-FTP.HISTORICO, "|")) + TRIM(ENTRY(3,TT-FTP.HISTORICO, "|")).
    END.


    RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.

    FOR EACH TT-FTP:

        ASSIGN I-TOT = I-TOT  + 1.

    END.

    RUN PI-INICIALIZAR IN H-PROG (INPUT "MONTANDO GERAL ii", I-TOT).
    FOR EACH TT-FTP BREAK BY TT-FTP.CONCATENA:

        ACCUMULATE TT-FTP.VLR_CONTABIL (SUB-TOTAL BY TT-FTP.CONCATENA).

        IF LAST-OF(TT-FTP.CONCATENA) THEN DO:


            CREATE TT-FTP2.
            ASSIGN TT-FTP2.COD_ESTAB = TT-FTP.COD_ESTAB
                   TT-FTP2.DATA      = TT-FTP.DATA
                   TT-FTP2.LOTE      = TT-FTP.LOTE
                   TT-FTP2.VLR_CONTABIL = ACCUM SUB-TOTAL BY TT-FTP.CONCATENA TT-FTP.VLR_CONTABIL
                   TT-FTP2.CONCATENA    = TT-FTP.CONCATENA.

        END.
    END.
    RUN PI-FINALIZAR IN H-PROG.


    RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.


    FIND FIRST tt-param NO-ERROR.
    FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel >= tt-param.c-estab-ini
                                 AND   movto-estoq.cod-estabel <= tt-param.c-estab-fim
                                 AND   (movto-estoq.valor-icm   > 0
                                 OR    movto-estoq.ct-codigo  = tt-param.c-cta-icms)
                                 AND   movto-estoq.dt-trans    >= tt-param.c-dt-corte-ini
                                 AND   movto-estoq.dt-trans    <= tt-param.c-dt-corte-fim
                                 BREAK BY movto-estoq.dt-trans:

    ASSIGN I-TOT = I-TOT +  1.

    END.


    RUN PI-INICIALIZAR IN H-PROG (INPUT "FASE1", I-TOT).
    FIND FIRST tt-param NO-ERROR.
    FOR EACH movto-estoq NO-LOCK WHERE movto-estoq.cod-estabel >= tt-param.c-estab-ini
                                 AND   movto-estoq.cod-estabel <= tt-param.c-estab-fim
                                 AND   (movto-estoq.valor-icm   > 0
                                 OR    movto-estoq.ct-codigo  = tt-param.c-cta-icms)
                                 AND   movto-estoq.dt-trans    >= tt-param.c-dt-corte-ini
                                 AND   movto-estoq.dt-trans    <= tt-param.c-dt-corte-fim
                                 BREAK BY movto-estoq.dt-trans:

        FIND FIRST ITEM WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-ERROR.

    RUN PI-ACOMPANHAR IN H-PROG.


                CREATE TT-INEXISTENTES.
                ASSIGN TT-INEXISTENTES.COD_ESTAB = movto-estoq.cod-estabel
                       TT-INEXISTENTES.DATA      = movto-estoq.dt-trans
                       TT-INEXISTENTES.MODULO    = "FTP"
                       TT-INEXISTENTES.GE-CODIGO = STRING(ITEM.ge-codigo)
                       TT-INEXISTENTES.UNEGOC    = movto-estoq.cod-unid-negoc
                       TT-INEXISTENTES.CONCATENA = STRING(ITEM.ge-codigo) + movto-estoq.cod-unid-negoc + movto-estoq.cod-estabel.

                IF movto-estoq.ct-codigo = tt-param.c-cta-icms THEN DO:
                ASSIGN TT-INEXISTENTES.VLR       = IF movto-estoq.tipo-trans = 2 THEN movto-estoq.valor-mat-m[1] ELSE movto-estoq.valor-mat-m[1] * - 1.
                END.

                ELSE DO:

            
                   TT-INEXISTENTES.VLR       = IF movto-estoq.esp-docto = 20 THEN /*IF movto-estoq.tipo-trans = 1 THEN */ movto-estoq.valor-icm  * - 1
                       ELSE movto-estoq.valor-icm. /*ELSE movto-estoq.valor-icm * - 1 */ /*Foi verificado que a movto-estoq quando tem NFE nao considera ICMS cmo saida*/.
                   
                END.       

            END.


    RUN PI-FINALIZAR IN H-PROG.



    RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.

    FOR EACH TT-INEXISTENTES    BREAK BY TT-INEXISTENTES.DATA:

    ASSIGN I-TOT = I-TOT +  1.

    END.


    RUN PI-INICIALIZAR IN H-PROG (INPUT "FASE1", I-TOT).
    FOR EACH TT-INEXISTENTES    BREAK BY TT-INEXISTENTES.CONCATENA:

    RUN PI-ACOMPANHAR IN H-PROG.


        ACCUMULATE TT-INEXISTENTES.VLR (SUB-TOTAL BY TT-INEXISTENTES.CONCATENA).


        IF LAST-OF(TT-INEXISTENTES.CONCATENA) THEN DO:



                CREATE TT-INEXISTENTES2.
                ASSIGN TT-INEXISTENTES2.COD_ESTAB = TT-INEXISTENTES.COD_ESTAB
                       TT-INEXISTENTES2.DATA      = TT-INEXISTENTES.DATA
                       TT-INEXISTENTES2.VLR       = ACCUM SUB-TOTAL BY TT-INEXISTENTES.CONCATENA TT-INEXISTENTES.VLR
                       TT-INEXISTENTES2.MODULO    = "CEP"
                       TT-INEXISTENTES2.GE-CODIGO  = TT-INEXISTENTES.GE-CODIGO
                       TT-INEXISTENTES2.UNEGOC     = TT-INEXISTENTES.UNEGOC
                       TT-INEXISTENTES2.CONCATENA  = TT-INEXISTENTES.CONCATENA
                        .

            END.
       END.


    RUN PI-FINALIZAR IN H-PROG.

    OUTPUT TO C:\TEMP\INEXIST.TXT.
    FOR EACH TT-INEXISTENTES2:

        PUT UNFORMATTED TT-INEXISTENTES2.COD_ESTAB ";"
            TT-INEXISTENTES2.DATA      ";"
            TT-INEXISTENTES2.VLR       ";"
            TT-INEXISTENTES2.MODULO    ";"
            TT-INEXISTENTES2.GE-CODIGO ";"
            TT-INEXISTENTES2.UNEGOC    ";"
            TT-INEXISTENTES2.CONCATENA 
            SKIP.



    END.


    OUTPUT TO C:\TEMP\FTP.TXT.
    FOR EACH TT-FTP2:
        PUT UNFORMATTED TT-FTP2.COD_ESTAB        ";"
            TT-FTP2.DATA             ";"
            TT-FTP2.LOTE             ";"
            TT-FTP2.VLR_CONTABIL     ";"
            TT-FTP2.CONCATENA        ";"
SKIP.


    END.



END PROCEDURE.


FOR EACH TT-INEXISTENTES2 BREAK BY TT-INEXISTENTES2.DATA:

    FIND FIRST TT-FTP2 WHERE TT-FTP2.CONCATENA = TT-INEXISTENTES2.CONCATENA
NO-ERROR.
    IF AVAIL TT-FTP2 THEN  DO:
        


    chworksheet:range("A" + STRING(m-linha)):SetValue(TT-INEXISTENTES2.DATA).
    chworksheet:range("b" + STRING(m-linha)):SetValue(TT-INEXISTENTES2.COD_ESTAB).
    chworksheet:range("c" + STRING(m-linha)):SetValue(TT-INEXISTENTES2.GE-CODIGO). 
    chworksheet:range("d" + STRING(m-linha)):SetValue(TT-INEXISTENTES2.UNEGOC).
    chworksheet:range("e" + STRING(m-linha)):SetValue(IF TT-INEXISTENTES2.VLR < 0 THEN TT-INEXISTENTES2.Vlr * - 1 ELSE TT-INEXISTENTES2.Vlr).
    chworksheet:range("f" + STRING(m-linha)):SetValue(TT-FTP2.VLR_CONTABIL).
    chworksheet:range("g" + STRING(m-linha)):SetValue(TT-FTP2.VLR_CONTABIL - IF TT-INEXISTENTES2.VLR < 0 THEN TT-INEXISTENTES2.Vlr * - 1 ELSE TT-INEXISTENTES2.Vlr).

    m-linha = m-linha + 1.


    END.

END.

 chExcel:Visible = true.


