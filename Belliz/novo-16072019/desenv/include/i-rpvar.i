/*****************************************************************************
**
**  I-RPVAR.I - Variaveis para Impress�o do Cabecalho Padr�o (ex-CD9500.I)
**
*****************************************************************************/

{include/i_dbvers.i}
{include/i_prdvers.i}
def new global shared var i-num-ped-exec-rpw     as INTEGER no-undo.
define var c-empresa       as character format "x(40)"      no-undo.
define var c-titulo-relat  as character format "x(50)"      no-undo.
define var c-sistema       as character format "x(25)"      no-undo.
define var i-numper-x      as integer   format "ZZ"         no-undo.
define var da-iniper-x     as date      format "99/99/9999" no-undo.
define var da-fimper-x     as date      format "99/99/9999" no-undo.
define var c-rodape        as character                     no-undo.
define var v_num_count     as integer                       no-undo.
define var c-arq-control   as character                     no-undo.
define var i-page-size-rel as integer                       no-undo.
define var c-programa      as character format "x(08)"      no-undo.
define var c-versao        as character format "x(04)"      no-undo.
define var c-revisao       as character format "999"        no-undo.
define var c-impressora    as character                     no-undo.
define var c-layout        as character                     no-undo.

&if "{&product_version}" >= "11.5.4" &then
define var i-nr-linha-pag             as integer            no-undo.
define var r-histor_impres            as rowid              no-undo.
define var i-page-counter-aux         as integer            no-undo.
define var i-page-counter             as integer            no-undo.
define var c-arquivo-ctl_imp          as character          no-undo.
define var l-indireta-ctl_imp         as logical            no-undo.
define var l-impresso-ctl_imp         as logical            no-undo.
define var c-destino-ctl_imp          as character          no-undo.
define var c-usuario-solic            as character          no-undo.
DEFINE VAR c-cod-usuar-exec           AS CHARACTER          NO-UNDO.
DEFINE VAR d-dat_inicial              AS DATE               NO-UNDO.
DEFINE VAR i-destino-relat            AS INTEGER            NO-UNDO.
DEFINE VAR tt-buffer-handle           AS HANDLE             NO-UNDO.
DEFINE VAR c-histor_impres_nom_impres AS CHARACTER          NO-UNDO.
DEFINE VAR c-histor_impres_nom_arq    AS CHARACTER          NO-UNDO.
&endif

/*Defini��es inclu�das para corrigir problema de vari�veis j� definidas pois */
/*as vari�veis e temp-tables eram definidas na include --rpout.i que pode ser*/
/*executada mais de uma vez dentro do mesmo programa (FO 1.120.458) */
/*11/02/2005 - Ed�sio <tech14207>*/
/*-------------------------------------------------------------------------------------------*/
DEF VAR h-procextimpr                               AS HANDLE   NO-UNDO. 
DEF VAR i-num_lin_pag                               AS INT      NO-UNDO.    
DEF VAR c_process-impress                           AS CHAR     NO-UNDO.   
DEF VAR c-cod_pag_carac_conver                      AS CHAR     NO-UNDO.   

/*tech14207
FO 1663218
Inclu�das as defini��es das vari�veis e fun��es
*/
&IF "{&mguni_version}" >= "2.04" &THEN
    &IF "{&PDF-RP}" <> "YES" &THEN /*tech868*/
    
        /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito valida��o para verificar se a variavel h_pdf_controller j� foi definida 
                                                       anteriormente, evitando erro de duplicidade*/

        &IF defined(def_pdf_controller) = 0 &THEN         
            DEFINE VARIABLE h_pdf_controller     AS HANDLE NO-UNDO.
    
            &GLOBAL-DEFINE def_pdf_controller YES
    
            DEFINE VARIABLE v_cod_temp_file_pdf  AS CHAR   NO-UNDO.
			DEFINE VARIABLE v_cod_temp_file_xls  AS CHAR   NO-UNDO.
    
            DEFINE VARIABLE v_cod_relat          AS CHAR   NO-UNDO.
            DEFINE VARIABLE v_cod_file_config    AS CHAR   NO-UNDO.
    
            FUNCTION allowPrint RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION allowSelect RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION useStyle RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION usePDF RETURNS LOGICAL IN h_pdf_controller.
			FUNCTION useExcel RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION getPrintFileName RETURNS CHARACTER IN h_pdf_controller.
            
            IF i-num-ped-exec-rpw <> 0 THEN DO:
               /*controle de execu��o �nica somente para RPW*/
               h_pdf_controller = SESSION:FIRST-PROCEDURE.
               DO WHILE VALID-HANDLE(h_pdf_controller):
                 IF h_pdf_controller:FILE-NAME = "btb/btb920aa.p" THEN LEAVE. 
                 h_pdf_controller = h_pdf_controller:NEXT-SIBLING.
               END.
               IF NOT VALID-HANDLE(h_pdf_controller) THEN 
                   RUN btb/btb920aa.p PERSISTENT SET h_pdf_controller.
            END.
            ELSE DO:
                /*para a execu��o normal j� existe um controle que encerra a execu��o persistente do programa*/
                RUN btb/btb920aa.p PERSISTENT SET h_pdf_controller.
            END.
            
        &ENDIF
        /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito valida��o para verificar se a variavel h_pdf_controller j� foi definida 
                                                       anteriormente, evitando erro de duplicidade*/
    &ENDIF /*tech868*/
    
&endif
/*tech14207*/
/*tech30713 - fo:1262674 - Defini��o de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_inicio NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .

/*tech30713 - fo:1262674 - Defini��o de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_fim NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .
/*-------------------------------------------------------------------------------------------*/

define buffer b_ped_exec_style for ped_exec.
define buffer b_servid_exec_style for servid_exec.
&IF "{&SHARED}" = "YES":U &THEN
    define shared stream str-rp.
&ELSE
    define new shared stream str-rp.
&ENDIF
{include/i-lgcode.i}
/* i-rpvar.i */
/*Altera��o 20/07/2007 - tech1007 - Defini��o da vari�vel utilizada para impress�o em PDF*/
DEFINE VARIABLE v_output_file        AS CHAR   NO-UNDO.

/*Fim altera��o 20/07/2007*/
