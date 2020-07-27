DEF TEMP-TABLE blz-sdo_ctbl 
    field cod_empresa             AS CHAR
    field cod_finalid_econ        AS CHAR
    field cod_plano_cta_ctbl      AS CHAR 
    field cod_cta_ctbl            AS CHAR
    field cod_plano_ccusto        AS CHAR
    field cod_ccusto              AS CHAR
    field cod_cenar_ctbl          AS CHAR
    field cod_estab               AS CHAR
    field dat_sdo_ctbl            AS DATE
    field val_sdo_ctbl_db         AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field val_sdo_ctbl_cr         AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field val_sdo_ctbl_fim        AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"
    field val_sdo_temp            AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"

    FIELD logico                  AS LOGICAL INITIAL YES
    field ttv-mae                 AS CHAR
    field ttv-controle            AS INTEGER
    FIELD ttv-linha               AS INTEGER.


DEF VAR h-prog AS HANDLE.


/*include de controle de versÆo*/
{include/i-prgvrs.i BDG 1.00.00.001}

/*defini–Æo das temp-tables para recebimento de parÚmetros*/
    {utp/utapi013.i}

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
    FIELD ttv-periodo-ini      AS date
    FIELD ttv-periodo-fim      AS date
    FIELD ttv-cta-ini          AS char
    FIELD ttv-cta-fim          AS char
    FIELD ttv-cc-ini           AS char
    FIELD ttv-cc-fim           AS char
    field ttv-cenar-orctario   AS char      
    field ttv-unid-orctaria    AS char      
    field ttv-num-seq-orcto    AS INTEGER      
    field ttv-cod-versao       AS char      
    field ttv-cenario          AS CHAR
    FIELD ttv-empresa          AS CHAR
    FIELD ttv-diretorio        AS CHAR.
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */


def temp-table tt-raw-digita
   field raw-digita      as raw.



def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.
   


/* CREATE tt-param.                                    */
/* ASSIGN tt-param.ttv-periodo-ini       = 02/01/2019  */
/*        tt-param.ttv-periodo-fim       = 02/28/2019  */
/*        tt-param.ttv-cta-ini           = "510000"    */
/*        tt-param.ttv-cta-fim           = "519999"    */
/*        tt-param.ttv-cc-ini            = "1233"      */
/*        tt-param.ttv-cc-fim            = "1233"      */
/*        tt-param.ttv-cenar-orctario    = "Budget"    */
/*        tt-param.ttv-unid-orctaria     = "Belliz"    */
/*        tt-param.ttv-num-seq-orcto     = 1           */
/*        tt-param.ttv-cod-versao        = "01.00"     */
/*        tt-param.ttv-cenario           = "fiscal"    */
/*        tt-param.ttv-empresa           = "blz".      */
















DEF TEMP-TABLE tt-ytd
    FIELD ttv-cta           AS char
    FIELD ttv-cc            AS char
    FIELD ttv-empresa       AS char
    FIELD ttv-periodo       AS INTEGER
    FIELD ttv-exercicio     AS INTEGER
    FIELD ttv-vlr-orcado    AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>.99".




DEF VAR i-controle AS INTEGER.
DEF VAR v_num_linha                 AS INTE                                         NO-UNDO.
DEF VAR h-acomp                     AS HANDLE                                       NO-UNDO.
DEF VAR i-tamanho                   AS INTE EXTENT 2                                NO-UNDO.
DEF VAR i-tamanho-aux               AS INTE EXTENT 2                                NO-UNDO.
DEF VAR i-col                       AS INTE EXTENT 2                                NO-UNDO.
DEF VAR i-aux                       AS INTE                                         NO-UNDO.
DEF VAR i-coluna                    AS INTE                                         NO-UNDO.
DEF VAR c-aux                       AS CHAR                                         NO-UNDO.
DEF VAR c-narrativa                 AS CHAR                                         NO-UNDO.
DEF VAR c-alfabet                   AS CHAR EXTENT 208                              NO-UNDO
    INIT ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
          "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ",
          "BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ",
          "CA","CB","CC","CD","CE","CF","CG","CH","CI","CJ","CK","CL","CM","CN","CO","CP","CQ","CR","CS","CT","CU","CV","CW","CX","CY","CZ",
          "DA","DB","DC","DD","DE","DF","DG","DH","DI","DJ","DK","DL","DM","DN","DO","DP","DQ","DR","DS","DT","DU","DV","DW","DX","DY","DZ",
          "EA","EB","EC","ED","EE","EF","EG","EH","EI","EJ","EK","EL","EM","EN","EO","EP","EQ","ER","ES","ET","EU","EV","EW","EX","EY","EZ",
          "FA","FB","FC","FD","FE","FF","FG","FH","FI","FJ","FK","FL","FM","FN","FO","FP","FQ","FR","FS","FT","FU","FV","FW","FX","FY","FZ",
          "GA","GB","GC","GD","GE","GF","GG","GH","GI","GJ","GK","GL","GM","GN","GO","GP","GQ","GR","GS","GT","GU","GV","GW","GX","GY","GZ"].

DEF VAR v-vlr-orcado AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEF VAR v-vlr-realizado AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
DEF VAR v-vlr-realizado-acum AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".

DEF VAR v-vlr-logical AS DEC FORMAT "->>>,>>>,>>>,>>>,>>>,>>>.99".
/* ---------------------------------------------------------------------------------------- */
/* ----------------------------- Configura‡äes Excel -------------------------------------- */
/* ---------------------------------------------------------------------------------------- */

/* Pre-processadores Excel */
&SCOPED-DEFINE xlCenter      -4108
&SCOPED-DEFINE xlRight       -4152
&SCOPED-DEFINE xlLeft        -4131
&SCOPED-DEFINE xlTop         -4160
&SCOPED-DEFINE xlEdgeLeft        7
&SCOPED-DEFINE xlContinuous      1
&SCOPED-DEFINE xlEdgeTop         8
&SCOPED-DEFINE xlEdgeBottom      9
&SCOPED-DEFINE xlEdgeRight      10
&SCOPED-DEFINE xlNone        -4142
&SCOPED-DEFINE xlMedium      -4138
&SCOPED-DEFINE xlThin            2


DEFINE VARIABLE  m-linha      AS INTEGER.
DEFINE VARIABLE chExcel       AS office.iface.excel.ExcelWrapper  NO-UNDO.
DEFINE VARIABLE chWorkBook    AS office.iface.excel.WorkBook      NO-UNDO.
DEFINE VARIABLE chWorkSheet   AS office.iface.excel.WorkSheet     NO-UNDO.
DEFINE VARIABLE chRange       AS office.iface.excel.Range         NO-UNDO.
{office/office.i Excel chExcel}








DEF VAR col-ini     AS INTEGER.
DEF VAR i-linha     AS INTEGER.
DEF VAR periodo-total   AS INTEGER.
DEF VAR i-mes       AS INTEGER.
DEF VAR v-mes       AS char.
DEF VAR i-ano       AS INTEGER.
DEF VAR i-ult-dia   AS INTEGER.
DEFINE TEMP-TABLE tt-compos
    FIELD cod_cta_ctbl AS CHAR
    FIELD cod_ccusto   AS CHAR.
DEF VAR v-codigo AS char.

DEFINE TEMP-TABLE tt-mae
    FIELD ttv-mae AS CHAR
    FIELD tt-descricao AS CHAR
    FIELD ttv-filho AS CHAR.

FIND FIRST tt-param NO-ERROR.




RUN utp/ut-acomp.p PERSISTENT SET h-prog.
RUN pi-inicializar IN h-prog("Montando relatorio.....").
    
RUN pi-monta-planilha.
    RUN pi-define-hcm.
    RUN pi-cria-temp-tables.
    RUN pi-parte-fixa.
    RUN pi-meses.
    RUN pi-ytd.
    RUN pi-logica-fixa.
    RUN pi-justificativa.
    RUN pi-orcto-ytd.

RUN pi-finalizar IN h-prog.


chExcel:VISIBLE = TRUE.








PROCEDURE pi-monta-planilha :

    chExcel:sheetsinNewWorkbook = 1.
    chWorkbook = chExcel:Workbooks:ADD().
    chworksheet=chWorkBook:sheets:item(1).
    chworksheet:name="Justificativa". /* Nome que ser¿ criada a Pasta da Planilha */
    m-linha = 2.
    chWorkSheet:PageSetup:Orientation = 1. /* Define papel como formato Retrato */
END PROCEDURE.

PROCEDURE pi-define-hcm:


    FOR EACH compos_demonst_ctbl NO-LOCK WHERE compos_demonst_ctbl.cod_demonst_ctbl = "1216"
                                         AND   (compos_demonst_ctbl.cod_ccusto_inic  <> "1216"
                                         AND   compos_demonst_ctbl.cod_ccusto_inic  <> ""):
        RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + compos_demonst_ctbl.cod_cta_ctbl_fim).

        ASSIGN  v-codigo = STRING(compos_demonst_ctbl.cod_cta_ctbl_inic).
        CREATE tt-compos.

        IF compos_demonst_ctbl.cod_cta_ctbl_inic < compos_demonst_ctbl.cod_cta_ctbl_fim THEN
        DO WHILE v-codigo <> compos_demonst_ctbl.cod_cta_ctbl_fim:
            ASSIGN tt-compos.cod_cta_ctbl = string(v-codigo)
                   tt-compos.cod_ccusto   = "1216"
                   v-codigo               = string(int(v-codigo) + 1).

        END.

        ELSE DO: 
            ASSIGN tt-compos.cod_cta_ctbl = v-codigo
                   tt-compos.cod_ccusto   = "1216"
                    .

        END.


    END.



    FOR EACH compos_demonst_ctbl NO-LOCK WHERE compos_demonst_ctbl.cod_demonst_ctbl = "6100"
                                         AND   compos_demonst_ctbl.cod_ccusto_inic  <> "6000"
                                         AND   compos_demonst_ctbl.cod_ccusto_inic <> "":
        RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + compos_demonst_ctbl.cod_cta_ctbl_fim).


        ASSIGN  v-codigo = STRING(compos_demonst_ctbl.cod_cta_ctbl_inic).
        CREATE tt-compos.

        IF compos_demonst_ctbl.cod_cta_ctbl_inic < compos_demonst_ctbl.cod_cta_ctbl_fim THEN
        DO WHILE v-codigo <> compos_demonst_ctbl.cod_cta_ctbl_fim:
            ASSIGN tt-compos.cod_cta_ctbl = string(v-codigo)
                   tt-compos.cod_ccusto   = "6100"
                   v-codigo               = string(int(v-codigo) + 1).

        END.

        ELSE DO: 
            ASSIGN tt-compos.cod_cta_ctbl = v-codigo
                   tt-compos.cod_ccusto   = "6100"
.

        END.


    END.


/*     OUTPUT TO c:\desenv\escg001.txt. */
/*     FOR EACH tt-compos.              */
/*         EXPORT tt-compos.            */
/*     END.                             */
/*     OUTPUT CLOSE.                    */

END PROCEDURE.



PROCEDURE pi-cria-temp-tables:

    FIND FIRST tt-param NO-ERROR.
    ASSIGN i-controle = 1.

    INPUT FROM VALUE (tt-param.ttv-diretorio).

REPEAT:
    CREATE tt-mae.
    IMPORT DELIMITER "|" tt-mae.
END.
INPUT CLOSE.


    FOR EACH sdo_ctbl NO-LOCK WHERE  sdo_ctbl.cod_empresa                                              = tt-param.ttv-empresa
                               AND   sdo_ctbl.cod_finalid_econ                                         = "corrente"
                               AND   sdo_ctbl.cod_ccusto                                               >= tt-param.ttv-cc-ini
                               AND   sdo_ctbl.cod_ccusto                                               <= tt-param.ttv-cc-fim

                               AND   sdo_ctbl.cod_cta_ctbl                                             >= tt-param.ttv-cta-ini
                               AND   sdo_ctbl.cod_cta_ctbl                                             <= tt-param.ttv-cta-fim
                               AND   sdo_ctbl.dat_sdo_ctb                                              >= tt-param.ttv-periodo-ini
                               AND   sdo_ctbl.dat_sdo_ctb                                              <= tt-param.ttv-periodo-fim
                               AND   sdo_ctbl.cod_cenar_ctbl                                           = "fiscal"
                               //AND   sdo_ctbl.val_sdo_ctbl_fim                                         <> 0
                               :




            RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + sdo_ctbl.cod_cta_ctbl + " Ccusto " + sdo_ctbl.cod_ccusto + " Data " + string(sdo_ctbl.dat_sdo_ctb )).

                            

                               
         FIND FIRST tt-mae WHERE tt-mae.ttv-filho = sdo_ctbl.cod_cta_ctbl NO-ERROR.

         IF  AVAIL tt-mae THEN DO:

        CREATE blz-sdo_ctbl.
        ASSIGN blz-sdo_ctbl.cod_empresa        = sdo_ctbl.cod_empresa
               blz-sdo_ctbl.cod_finalid_econ   = sdo_ctbl.cod_finalid_econ
               blz-sdo_ctbl.cod_plano_cta_ctbl = sdo_ctbl.cod_plano_cta_ctbl
               blz-sdo_ctbl.cod_cta_ctbl       = sdo_ctbl.cod_cta_ctbl
               blz-sdo_ctbl.cod_plano_ccusto   = sdo_ctbl.cod_plano_ccusto
               blz-sdo_ctbl.cod_cenar_ctbl     = sdo_ctbl.cod_cenar_ctbl
               blz-sdo_ctbl.cod_estab          = sdo_ctbl.cod_estab
               blz-sdo_ctbl.dat_sdo_ctbl       = sdo_ctbl.dat_sdo_ctbl
               blz-sdo_ctbl.val_sdo_ctbl_db    = sdo_ctbl.val_sdo_ctbl_db
               blz-sdo_ctbl.val_sdo_ctbl_cr    = sdo_ctbl.val_sdo_ctbl_cr
               blz-sdo_ctbl.val_sdo_ctbl_fim   = sdo_ctbl.val_sdo_ctbl_fim
//               v-vlr-orcado      = sdo_orcto_ctbl_bgc.val_orcado
               blz-sdo_ctbl.ttv-mae            = tt-mae.ttv-mae
               blz-sdo_ctbl.ttv-controle       = i-controle
               blz-sdo_ctbl.cod_ccusto         = sdo_ctbl.cod_ccusto.


      ASSIGN i-controle = i-controle + 1.
      NEXT.

        END.

     END.


     FOR EACH blz-sdo_ctbl:

         FIND FIRST tt-compos WHERE tt-compos.cod_cta_ctbl = blz-sdo_ctbl.cod_cta_ctbl NO-ERROR.

         IF AVAIL tt-compos THEN DO:
                  
         CASE substring(blz-sdo_ctbl.cod_ccusto,1, 1):
             WHEN  "1" THEN

             ASSIGN blz-sdo_ctbl.cod_ccusto         = "1216".
             WHEN  "2" THEN

             ASSIGN blz-sdo_ctbl.cod_ccusto         = "1216".
             WHEN  "3" THEN

             ASSIGN blz-sdo_ctbl.cod_ccusto         = "1216".
             WHEN  "4" THEN

             ASSIGN blz-sdo_ctbl.cod_ccusto         = "1216".
             WHEN  "5" THEN

             ASSIGN blz-sdo_ctbl.cod_ccusto         = "1216".

             WHEN "6" THEN
             ASSIGN blz-sdo_ctbl.cod_ccusto         = "6100".
          OTHERWISE
              ASSIGN blz-sdo_ctbl.cod_ccusto        =  blz-sdo_ctbl.cod_ccusto.

         END CASE.

         END.


     END.

     FOR EACH blz-sdo_ctbl NO-LOCK:


         RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + blz-sdo_ctbl.cod_cta_ctbl + " Ccusto " + blz-sdo_ctbl.cod_ccusto + " Data " + string(blz-sdo_ctbl.dat_sdo_ctb )).


         FIND FIRST sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                   = tt-param.ttv-cenar-orctario
                                                AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria    
                                                AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto
                                                AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao   
                                                AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario
                                                AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(tt-param.ttv-periodo-fim)))
                                                AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(tt-param.ttv-periodo-fim))
                                                AND   sdo_orcto_ctbl_bgc.cod_empresa                         = blz-sdo_ctbl.cod_empresa 
                                                AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        = blz-sdo_ctbl.ttv-mae
                                                AND   sdo_orcto_ctbl_bgc.cod_ccusto                          = blz-sdo_ctbl.cod_ccusto  
                                                NO-ERROR.


                                   IF AVAIL sdo_orcto_ctbl_bgc THEN DO:

                                       IF  (sdo_orcto_ctbl_bgc.val_orcado_sdo = 0
                                       AND  blz-sdo_ctbl.val_sdo_ctbl_fim     = 0) THEN
                                           ASSIGN blz-sdo_ctbl.logico = NO.


                                   END.


                                   IF NOT AVAIL sdo_orcto_ctbl_bgc THEN DO:

                                       IF  blz-sdo_ctbl.val_sdo_ctbl_fim = 0 THEN
                                           ASSIGN blz-sdo_ctbl.logico = NO.
                                   END.

     END.
                                      









END PROCEDURE.



/* ======================================================================================================== */
/* ======================================================================================================== */
/* =================================================PARTE FIXA============================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */
PROCEDURE pi-parte-fixa:
/*            chworksheet:range("A2:Q2"):font:bold = TRUE.  /* Aplica negrito na linha de titulo das colunas */ */


    chWorkSheet:Range(c-alfabet[01] + "1" + ":" + c-alfabet[03] + "1"):mergecells = TRUE.
    chWorkSheet:Range(c-alfabet[01] +  "1"):setValue("Acompanhamento de Despesas Realizados").
    chWorkSheet:Range(c-alfabet[01] + "1" + ":" + c-alfabet[03] + "1"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:Range(c-alfabet[01] + "1"):FONT:Bold = TRUE.



    chWorkSheet:Range(c-alfabet[01] + "2" + ":" + c-alfabet[02] + "2"):mergecells = YES.
    chWorkSheet:Range(c-alfabet[01] + "2"):setVALUE("Area").
    chWorkSheet:Range(c-alfabet[01] + "2" + ":" + c-alfabet[02] + "2"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:Range(c-alfabet[03] + "2" + ":" + c-alfabet[03] + "2"):mergecells = YES.
    chWorkSheet:Range(c-alfabet[03] + "2"):setVALUE("").
    chWorkSheet:Range(c-alfabet[03] + "2" + ":" + c-alfabet[03] + "2"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.




    chWorkSheet:Range(c-alfabet[01] + "3" + ":" + c-alfabet[02] + "3"):mergecells = YES.
    chWorkSheet:Range(c-alfabet[01] + "3"):setVALUE("Responsavel").
    chWorkSheet:Range(c-alfabet[01] + "3" + ":" + c-alfabet[02] + "3"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:Range(c-alfabet[03] + "3" + ":" + c-alfabet[03] + "3"):mergecells = YES.
    chWorkSheet:Range(c-alfabet[03] + "3"):setVALUE("").
    chWorkSheet:Range(c-alfabet[03] + "3" + ":" + c-alfabet[03] + "3"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.



    chWorkSheet:Range(c-alfabet[01] + "5" + ":" + c-alfabet[03] + "5"):mergecells = YES.
    chWorkSheet:Range(c-alfabet[01]+  "5"):setVALUE("Planilha de Despesas").
    chWorkSheet:Range(c-alfabet[01] + "5" + ":" + c-alfabet[03] + "5"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:Range(c-alfabet[01] + "5"):FONT:Bold = TRUE.

    chWorkSheet:Range(c-alfabet[01] + "6"):setVALUE("CC").
    chWorkSheet:Range(c-alfabet[01] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:range(c-alfabet[01] + "6"):FONT:bold = TRUE.


    chWorkSheet:Range(c-alfabet[02] + "6"):setVALUE("Conta Contabil").
    chWorkSheet:Range(c-alfabet[02] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:range(c-alfabet[02] + "6"):FONT:bold = TRUE.


    chWorkSheet:Range(c-alfabet[03] + "6"):setVALUE("Discriminacao").
    chWorkSheet:Range(c-alfabet[03] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
    chWorkSheet:range(c-alfabet[03] + "6"):FONT:bold = TRUE.


END PROCEDURE.

PROCEDURE pi-meses:
/* ======================================================================================================== */
/* ======================================================================================================== */
/* =================================================PARTE DINAMICA========================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */
    
FIND FIRST tt-param NO-ERROR.
    ASSIGN periodo-total = 1 + (int(MONTH(tt-param.ttv-periodo-fim)) - int(MONTH(tt-param.ttv-periodo-ini))) +  (12 *(int(YEAR(tt-param.ttv-periodo-fim)) - int(YEAR(tt-param.ttv-periodo-ini)))).
    ASSIGN Col-ini       = 4
           i-linha       = 9
           i-mes         =  int(MONTH(tt-param.ttv-periodo-ini)).



   DO WHILE PERIODO-TOTAL > 0:
       RUN pi-resolve-mes(INPUT i-mes,
                          OUTPUT v-mes).

RUN pi-acompanhar IN h-prog(INPUT "Mes" + v-mes).
       chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 4] + "5"):mergecells = YES.
       chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 4] + "5"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 4] + "5"):FONT:bold = TRUE.
       chWorkSheet:Range(c-alfabet[col-ini] + "5"):setVALUE(v-mes).

       chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Orcado").
       chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

       ASSIGN col-ini = col-ini + 1.

       chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Realizado").
       chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

       ASSIGN col-ini = col-ini + 1.

       chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Var.(R$)").
       chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

       ASSIGN col-ini = col-ini + 1.

       chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Status").
       chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

       ASSIGN col-ini = col-ini + 1.

       chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Justificativas").
       chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

       ASSIGN COL-ini = COL-ini + 2.
       ASSIGN periodo-total = periodo-total - 1.

       IF i-mes < 12 THEN
              i-mes         = i-mes + 1.

           ELSE i-mes = 1.

     END.

END PROCEDURE.

PROCEDURE pi-ytd:


/* ======================================================================================================== */
/* ======================================================================================================== */
/* =====================================ACUMULADO OCAMENTARO------========================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */
   chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 3] + "5"):mergecells = YES.
   chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 3] + "5"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
   chWorkSheet:Range(c-alfabet[col-ini] + "5" + ":" + c-alfabet[col-ini + 3] + "5"):FONT:bold = TRUE.
   chWorkSheet:Range(c-alfabet[col-ini] + "5"):setVALUE("YTD").

   chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Orcado").
   chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
   chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

   ASSIGN col-ini = col-ini + 1.

   chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Realizado").
   chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
   chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

   ASSIGN col-ini = col-ini + 1.

   chWorkSheet:Range(c-alfabet[col-ini] + "6"):setVALUE("Var.(R$)").
   chWorkSheet:Range(c-alfabet[col-ini] + "6"):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
   chWorkSheet:range(c-alfabet[col-ini] + "6"):FONT:bold = TRUE.

END PROCEDURE.
/* ======================================================================================================== */
/* ======================================================================================================== */
/* =====================================lOGICAL=============------========================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */
PROCEDURE pi-logica-fixa:

   FIND FIRST TT-PARAM NO-ERROR.

   ASSIGN i-ano = INT(YEAR(tt-param.ttv-periodo-ini)).
   ASSIGN i-linha = 7.

   FOR EACH blz-sdo_ctbl NO-LOCK WHERE blz-sdo_ctbl.cod_empresa                                          = tt-param.ttv-empresa
                             AND   blz-sdo_ctbl.cod_finalid_econ                                         = "corrente"
                             AND   blz-sdo_ctbl.cod_cta_ctbl                                             >= tt-param.ttv-cta-ini  
                             AND   blz-sdo_ctbl.cod_cta_ctbl                                             <= tt-param.ttv-cta-fim  
                             AND   blz-sdo_ctbl.cod_ccusto                                               >= tt-param.ttv-cc-ini 
                             AND   blz-sdo_ctbl.cod_ccusto                                               <= tt-param.ttv-cc-fim
                             AND   blz-sdo_ctbl.dat_sdo_ctb                                              >= tt-param.ttv-periodo-ini
                             AND   blz-sdo_ctbl.dat_sdo_ctb                                              <= tt-param.ttv-periodo-fim
                             AND   blz-sdo_ctbl.logico                                                   = YES
                             AND   blz-sdo_ctbl.cod_cenar_ctbl                                           = "fiscal"
                             BREAK BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto:

       RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + blz-sdo_ctbl.ttv-mae + " Ccusto " + cod_ccusto + " Data " + string(blz-sdo_ctbl.dat_sdo_ctb )).

/*    FOR EACH sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                  = tt-param.ttv-cenar-orctario                  */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria                   */
/*                                           AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto                   */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao                      */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario                         */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(tt-param.ttv-periodo-fim)))  */
/*                                           AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(tt-param.ttv-periodo-fim))         */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_empresa                         = tt-param.ttv-empresa                         */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        >= tt-param.ttv-cta-ini                        */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        <= tt-param.ttv-cta-fim                        */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_ccusto                          >= tt-param.ttv-cc-ini                         */
/*                                           AND   sdo_orcto_ctbl_bgc.cod_ccusto                          <= tt-param.ttv-cc-fim                         */

       IF LAST-OF(blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto)  THEN DO:
           

      FIND FIRST plano_cta_ctbl NO-LOCK WHERE plano_cta_ctbl.ind_tip_plano_cta_ctbl = "Prim rio"
                                        AND      plano_cta_ctbl.dat_fim_valid         > TODAY 
                                        AND      plano_cta_ctbl.cod_plano_cta_ctbl    <> "" NO-ERROR.

      FIND FIRST cta_ctbl NO-LOCK WHERE cta_ctbl.cod_plano_cta_ctbl = plano_cta_ctbl.cod_plano_cta_ctbl
                                  AND   cta_ctbl.cod_cta_ctbl       =  blz-sdo_ctbl.ttv-mae  NO-ERROR.


/*    FOR EACH ext_justificativa NO-LOCK WHERE ext_justificativa.Cta_ctbl >= tt-param.ttv-cta-ini               */
/*                                       AND   ext_justificativa.Cta_ctbl    <= tt-param.ttv-cta-fim                  */
/*                                       AND   ext_justificativa.Ccusto   >= tt-param.ttv-cc-ini                   */
/*                                       AND   ext_justificativa.Ccusto   <= tt-param.ttv-cc-fim                   */
/*                                       AND   ext_justificativa.Periodo  >= INT(MONTH(tt-param.ttv-periodo-ini))  */
/*                                       AND   ext_justificativa.Periodo  <= INT(MONTH(tt-param.ttv-periodo-fim))  */
/*                                       AND   ext_justificativa.Ano      >= INT(YEAR(tt-param.ttv-periodo-ini))   */
/*                                       AND   ext_justificativa.Ano      <= INT(YEAR(tt-param.ttv-periodo-fim))   */
/*                                       AND   ext_justificativa.cod_empresa = ""                                  */
                                      

       chWorkSheet:Range(c-alfabet[01] + string(i-linha)):setVALUE(blz-sdo_ctbl.cod_ccusto).
       chWorkSheet:Range(c-alfabet[01] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.

       chWorkSheet:Range(c-alfabet[02] + string(i-linha)):setVALUE(blz-sdo_ctbl.ttv-mae).
       chWorkSheet:Range(c-alfabet[02] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.

       chWorkSheet:Range(c-alfabet[03] + string(i-linha)):setVALUE(cta_ctbl.des_tit_ctbl).
       chWorkSheet:Range(c-alfabet[03] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.



       ASSIGN blz-sdo_ctbl.ttv-linha = i-linha. 
       ASSIGN i-linha = i-linha + 1.


   END.
END.




DEFINE BUFFER b-sdo FOR blz-sdo_ctbl.


   

    FOR EACH blz-sdo_ctbl WHERE blz-sdo_ctbl.logico = YES:

                FIND FIRST b-sdo WHERE b-sdo.ttv-linha             <> 0
                                 AND   b-sdo.cod_empresa          = blz-sdo_ctbl.cod_empresa       
                                 and   b-sdo.cod_finalid_econ     = blz-sdo_ctbl.cod_finalid_econ  
                                 and   b-sdo.ttv-mae              = blz-sdo_ctbl.ttv-mae      
                                 and   b-sdo.cod_ccusto           = blz-sdo_ctbl.cod_ccusto        
                                 
                                  NO-ERROR.     

                RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + blz-sdo_ctbl.ttv-mae + " Ccusto " + blz-sdo_ctbl.cod_ccusto + " Data " + string(blz-sdo_ctbl.dat_sdo_ctb )).

                 IF AVAIL b-sdo THEN DO:
                 

            ASSIGN blz-sdo_ctbl.ttv-linha = b-sdo.ttv-linha.

        END.

    END.

END PROCEDURE.


/* ======================================================================================================== */
/* ======================================================================================================== */
/* =====================================lOGICAL=============------========================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */

PROCEDURE pi-justificativa:
/*     OUTPUT TO c:\desenv\kentuchi.txt. */
/*                                       */
/*     FOR EACH blz-sdo_ctbl:            */
/*         EXPORT blz-sdo_ctbl.          */
/*     END.                              */
/*     OUTPUT CLOSE.                     */


   FIND FIRST tt-param NO-ERROR.
   ASSIGN periodo-total = 1 + (int(MONTH(tt-param.ttv-periodo-fim)) - int(MONTH(tt-param.ttv-periodo-ini))) +  (12 *(int(YEAR(tt-param.ttv-periodo-fim)) - int(YEAR(tt-param.ttv-periodo-ini)))).
   ASSIGN Col-ini       = 4
          i-linha       = 7
          i-mes         =  int(MONTH(tt-param.ttv-periodo-ini)).


   
   FOR EACH blz-sdo_ctbl NO-LOCK WHERE blz-sdo_ctbl.cod_empresa                                           = tt-param.ttv-empresa
                             AND   blz-sdo_ctbl.cod_finalid_econ                                         = "corrente"
                             AND   blz-sdo_ctbl.cod_cta_ctbl                                             >= tt-param.ttv-cta-ini  
                             AND   blz-sdo_ctbl.cod_cta_ctbl                                             <= tt-param.ttv-cta-fim  
                             AND   blz-sdo_ctbl.cod_ccusto                                               >= tt-param.ttv-cc-ini 
                             AND   blz-sdo_ctbl.cod_ccusto                                               <= tt-param.ttv-cc-fim
                             AND   blz-sdo_ctbl.dat_sdo_ctb                                              >= tt-param.ttv-periodo-ini
                             AND   blz-sdo_ctbl.dat_sdo_ctb                                              <= tt-param.ttv-periodo-fim
                             AND   blz-sdo_ctbl.logico                                                   = YES
                             AND   blz-sdo_ctbl.cod_cenar_ctbl                                           = "fiscal"
                            BREAK BY blz-sdo_ctbl.dat_sdo_ctb
                                  BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto + string(blz-sdo_ctbl.dat_sdo_ctbl):




       
       
       ACCUMULATE (blz-sdo_ctbl.val_sdo_ctbl_db - blz-sdo_ctbl.val_sdo_ctbl_cr) (SUB-TOTAL BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto + string(blz-sdo_ctbl.dat_sdo_ctbl)).
   
   

                         
                               

                                    IF last-of(blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto + string(blz-sdo_ctbl.dat_sdo_ctbl)) THEN DO:
                                        ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.


                                         RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + blz-sdo_ctbl.cod_cta_ctbl + " Ccusto " + cod_ccusto + " Data " + string(blz-sdo_ctbl.dat_sdo_ctb )).

                                        FIND FIRST sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                  = tt-param.ttv-cenar-orctario
                                                                              AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria
                                                                              AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto
                                                                              AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao
                                                                              AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario
                                                                              AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(blz-sdo_ctbl.dat_sdo_ctb)))
                                                                              AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(blz-sdo_ctbl.dat_sdo_ctb))
                                                                              AND   sdo_orcto_ctbl_bgc.cod_empresa                         = blz-sdo_ctbl.cod_empresa
                                                                              AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        = blz-sdo_ctbl.ttv-mae
                                                                              AND   sdo_orcto_ctbl_bgc.cod_ccusto                          = blz-sdo_ctbl.cod_ccusto
                                                                              NO-ERROR.

                                                                       IF AVAIL sdo_orcto_ctbl_bgc  THEN DO:




                                                                           ASSIGN v-vlr-orcado = sdo_orcto_ctbl_bgc.val_orcado.

                                                                           END.
                                                                       ELSE
                                                                           ASSIGN v-vlr-orcado = 0.




                                        

/*                                 IF LAST-OF(blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.cod_cta_ctbl + blz-sdo_ctbl.cod_ccusto + string(blz-sdo_ctbl.dat_sdo_ctbl)) THEN DO:  */


                                    ASSIGN v-vlr-realizado = ACCUM SUB-TOTAL BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto + string(blz-sdo_ctbl.dat_sdo_ctbl) (blz-sdo_ctbl.val_sdo_ctbl_db - blz-sdo_ctbl.val_sdo_ctbl_cr).
                                

   IF TT-PARAM.TTV-EMPRESA = "BLZ" THEN DO:
              FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cta_ctbl    = blz-sdo_ctbl.ttv-mae 
                                          AND   ext_justificativa.Ccusto        = blz-sdo_ctbl.cod_ccusto   
                                          AND   ext_justificativa.Ano           = INT(YEAR(blz-sdo_ctbl.dat_sdo_ctb))
                                          AND   ext_justificativa.Periodo       = INT(MONTH(blz-sdo_ctbl.dat_sdo_ctb ))
                                          NO-ERROR.

       IF AVAIL ext_justificativa THEN DO:
               


          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-orcado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado - v-vlr-orcado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(ext_justificativa.situacao).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(ext_justificativa.justificativa).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

    

               ASSIGN COL-ini = COL-ini - 5.
              // ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.

       END.
       IF NOT AVAIL ext_justificativa THEN DO:
           


          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-orcado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado - v-vlr-orcado).
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE("").
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.

       chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE("").
       chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
       ASSIGN col-ini = col-ini + 1.


               ASSIGN COL-ini = COL-ini - 5.
               //ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.
        END.
        
     END.


  IF TT-PARAM.TTV-EMPRESA = "MAE" THEN DO:
         FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cta_ctbl    = blz-sdo_ctbl.ttv-mae 
                                     AND   ext_justificativa.Ccusto        = blz-sdo_ctbl.cod_ccusto + "M"   
                                     AND   ext_justificativa.Ano           = INT(YEAR(blz-sdo_ctbl.dat_sdo_ctb))
                                     AND   ext_justificativa.Periodo       = INT(MONTH(blz-sdo_ctbl.dat_sdo_ctb ))
                                     NO-ERROR.

          IF AVAIL ext_justificativa THEN DO:
        
        
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-orcado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado - v-vlr-orcado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(ext_justificativa.situacao).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(ext_justificativa.justificativa).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
        
        
                  ASSIGN COL-ini = COL-ini - 5.
                 // ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.
        
          END.
          IF NOT AVAIL ext_justificativa THEN DO:
        
        
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-orcado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado - v-vlr-orcado).
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE("").
             chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE("").
          chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.
          ASSIGN col-ini = col-ini + 1.
        
        
                  ASSIGN COL-ini = COL-ini - 5.
                  //ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.
          END.
    END.

     IF LAST-OF(blz-sdo_ctbl.dat_sdo_ctb) THEN DO:
         ASSIGN COL-ini = COL-ini + 6.
         ASSIGN i-linha = 7.

     END.
    END.
 END.

END PROCEDURE.


PROCEDURE pi-orcto-ytd:
/* ======================================================================================================== */
/* ======================================================================================================== */
/* =====================================ORCADO E REALIZADO YTD----========================================= */
/* ======================================================================================================== */
/* ======================================================================================================== */
       FIND FIRST tt-param NO-ERROR.
       RUN qtde_dias(INPUT INT(MONTH(tt-param.ttv-periodo-fim)),
                     INPUT INT(YEAR(tt-param.ttv-periodo-ini)),
                          OUTPUT i-ult-dia).

       
       
/*        FOR EACH sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                  = tt-param.ttv-cenar-orctario                  */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria                   */
/*                                               AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto                   */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao                      */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario                         */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(tt-param.ttv-periodo-fim)))  */
/*                                               AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(tt-param.ttv-periodo-fim))         */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_empresa                         = tt-param.ttv-empresa                         */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        >= tt-param.ttv-cta-ini                        */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        <= tt-param.ttv-cta-fim                        */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_ccusto                          >= tt-param.ttv-cc-ini                         */
/*                                               AND   sdo_orcto_ctbl_bgc.cod_ccusto                          <= tt-param.ttv-cc-fim:                        */
/*                                                                                                                                                              */
/*                                                                                                                                                              */
/*                                                                                                                                                              */
/*                                                                                                                                                              */
/*            FIND FIRST ext_justificativa NO-LOCK WHERE ext_justificativa.Cta_ctbl = sdo_orcto_ctbl_bgc.cod_cta_ctbl                                  */
/*                                               AND   ext_justificativa.Ccusto        = sdo_orcto_ctbl_bgc.cod_ccusto                                    */
/*                                               AND   ext_justificativa.Ano           = INT(sdo_orcto_ctbl_bgc.cod_exerc_ctbl)                           */
/*                                               AND   ext_justificativa.cod_empresa   = "" NO-ERROR.                                                        */
                                          


/*            FIND FIRST sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                  = tt-param.ttv-cenar-orctario              */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria                  */
/*                                                  AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto                  */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao                     */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario                        */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(tt-param.ttv-periodo-fim))) */
/*                                                  AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(tt-param.ttv-periodo-fim))        */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_empresa                         = tt-param.ttv-empresa                        */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        = ext_justificativa.Cta_ctbl               */
/*                                                  AND   sdo_orcto_ctbl_bgc.cod_ccusto                          = ext_justificativa.Ccusto                 */
/*                                                NO-ERROR.                                                                                                       */



       FOR EACH blz-sdo_ctbl NO-LOCK WHERE blz-sdo_ctbl.cod_empresa                                           = tt-param.ttv-empresa
                                 AND   blz-sdo_ctbl.cod_finalid_econ                                         = "corrente"
                                 AND   blz-sdo_ctbl.cod_cta_ctbl                                             >= tt-param.ttv-cta-ini  
                                 AND   blz-sdo_ctbl.cod_cta_ctbl                                             <= tt-param.ttv-cta-fim  
                                 AND   blz-sdo_ctbl.cod_ccusto                                               >= tt-param.ttv-cc-ini 
                                 AND   blz-sdo_ctbl.cod_ccusto                                               <= tt-param.ttv-cc-fim
                                 
                                 AND   blz-sdo_ctbl.logico                                                   = YES
                                 AND   blz-sdo_ctbl.dat_sdo_ctb                                              = date(INT(MONTH(tt-param.ttv-periodo-fim)), i-ult-dia,INT(YEAR(tt-param.ttv-periodo-fim)))
                                 AND   blz-sdo_ctbl.cod_cenar_ctbl                                           = "fiscal" BREAK BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto:


           RUN pi-acompanhar IN h-prog (INPUT "CtaCtbl " + blz-sdo_ctbl.cod_cta_ctbl + " Ccusto " + cod_ccusto + " Data " + string(blz-sdo_ctbl.dat_sdo_ctb )).
                                      

           FIND FIRST sdo_orcto_ctbl_bgc NO-LOCK WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario                   = tt-param.ttv-cenar-orctario
                                                  AND   sdo_orcto_ctbl_bgc.cod_unid_orctaria                   = tt-param.ttv-unid-orctaria    
                                                  AND   sdo_orcto_ctbl_bgc.num_seq_orcto_ctbl                  = tt-param.ttv-num-seq-orcto
                                                  AND   sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl                 = tt-param.ttv-cod-versao   
                                                  AND   sdo_orcto_ctbl_bgc.cod_cenar_ctbl                      = tt-param.ttv-cenario
                                                  AND   sdo_orcto_ctbl_bgc.cod_exerc_ctbl                      = string(INT(YEAR(tt-param.ttv-periodo-fim)))
                                                  AND   sdo_orcto_ctbl_bgc.num_period_ctbl                     = INT(MONTH(tt-param.ttv-periodo-fim))
                                                  AND   sdo_orcto_ctbl_bgc.cod_empresa                         = blz-sdo_ctbl.cod_empresa 
                                                  AND   sdo_orcto_ctbl_bgc.cod_cta_ctbl                        = blz-sdo_ctbl.ttv-mae
                                                  AND   sdo_orcto_ctbl_bgc.cod_ccusto                          = blz-sdo_ctbl.cod_ccusto  
                                                  NO-ERROR.


                                     ACCUMULATE blz-sdo_ctbl.val_sdo_ctbl_fim (SUB-TOTAL BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto).

                                     

                                     IF LAST-OF(blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto) THEN DO:
                                         ASSIGN i-linha = blz-sdo_ctbl.ttv-linha.



                                         
                                         ASSIGN  v-vlr-realizado-acum = ACCUM SUB-TOTAL BY blz-sdo_ctbl.cod_empresa + blz-sdo_ctbl.ttv-mae + blz-sdo_ctbl.cod_ccusto blz-sdo_ctbl.val_sdo_ctbl_fim.

                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(IF AVAIL sdo_orcto_ctbl_bgc THEN  sdo_orcto_ctbl_bgc.val_orcado_sdo ELSE 0).
                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.


                                         ASSIGN col-ini = col-ini + 1.
                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE(v-vlr-realizado-acum).
                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.


                                         ASSIGN col-ini = col-ini + 1.

                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):setVALUE((v-vlr-realizado-acum) - (IF AVAIL sdo_orcto_ctbl_bgc THEN  sdo_orcto_ctbl_bgc.val_orcado_sdo ELSE 0)).
                                         chWorkSheet:Range(c-alfabet[col-ini] + string(i-linha)):borders({&xlEdgeLeftTopBottomRight}):Weight = {&xlMedium}.


                                         ASSIGN col-ini = col-ini + 1.
                                         
                                         ASSIGN COL-ini = COL-ini - 3.


                                     END.

                END.

END PROCEDURE.

    
    
    

PROCEDURE  pi-resolve-mes:

    DEF INPUT  param p-mes AS INTEGER.
    DEF OUTPUT param o-mes AS char.


    CASE p-mes:

        WHEN 1 THEN
            ASSIGN o-mes = "Janeiro".
        WHEN 2 THEN
            ASSIGN o-mes = "Fevereiro".
        WHEN 3 THEN
            ASSIGN o-mes = "Marco".
        WHEN 4 THEN
            ASSIGN o-mes = "Abril".
        WHEN 5 THEN
            ASSIGN o-mes = "Maio".
        WHEN 6 THEN
            ASSIGN o-mes = "Junho".
        WHEN 7 THEN
            ASSIGN o-mes = "Julho".
        WHEN 8 THEN
            ASSIGN o-mes = "Agosto".
        WHEN 9 THEN
            ASSIGN o-mes = "Setembro".
        WHEN 10 THEN
            ASSIGN o-mes = "Outubro".
        WHEN 11 THEN
            ASSIGN o-mes = "Novembro".
        WHEN 12 THEN
            ASSIGN o-mes = "Dezembro".


    END CASE.



END PROCEDURE.


PROCEDURE qtde_dias:
    DEF INPUT PARAM d_mes AS INTEGER.
    DEF INPUT param d_ano AS INTEGER.
    DEF OUTPUT PARAM p_num_dia AS INTEGER.

    FIND FIRST tt-param NO-ERROR.


         if  (d_mes = 4) or (d_mes = 6) or
             (d_mes = 9) or (d_mes = 11)
          then do:

                 assign p_num_dia = 30.
          end.

          if  (d_mes = 1) OR
              (d_mes = 3) or (d_mes = 5) or
              (d_mes = 7) or (d_mes = 8) OR
              (d_mes = 10) or (d_mes = 12)
       then do:

              assign p_num_dia = 31.
       end.


           if  d_mes = 2
       then do:
                   assign p_num_dia = 29.

               If p_num_dia = 29 then
                  if (d_ano modulo 4) <> 0 then
                      assign p_num_dia = 28.
           end.
END PROCEDURE.  /*qtde_dias*/


