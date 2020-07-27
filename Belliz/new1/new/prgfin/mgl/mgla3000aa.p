
/*******************************************************************************************************************************************/
/***PROPOSITO: Extrair arquivos de CSV para or‡amento e transformar em execu‡Æo or‡ament ria                                               */
/***SOLICITANTE Ettore Basille                                                                                                             */
/***Desenvolvimento por: Flavio Kussunoki                                                                                                  */
/***Data do DESENVOLVIMENTO: 30/11/2016                                                                                                    */
/***Integra¶’o COM: prgfin/bdg/bdg3000.w    e CSV.hta                                                                                      */
/***Nome final: pgfin/bdb/bdg3000aa.p                                                                                                      */
/***EMPRESA: FKis Consultoria Ltda ME - Todos os direitos reservados                                                                       */
/***Revisão: 30/11/2016												                                                                       */
/*******************************************************************************************************************************************/

/*include de controle de versÆo*/
{include/i-prgvrs.i BDG 1.00.00.001}



    define temp-table tt-param no-undo
        field destino                    as integer
        field arquivo                    as char format "x(35)"
        field usuario                    as char format "x(12)"
        field data-exec                  as date
        field hora-exec                  as integer
        field classifica                 as integer
        field desc-classifica            as char format "x(40)"
        field modelo-rtf                 as char format "x(35)"
        field l-habilitaRtf              as LOG
        FIELD cenario-orc-origem         AS CHAR FORMAT "x(120)"
        FIELD cenario-ctbl-origem        AS CHAR FORMAT "x(40)"
        FIELD seq-orcto-origem           AS INTEGER
        FIELD versao-orcto-origem        AS char
        FIELD cenario-orc-destino        AS CHAR FORMAT "x(120)"
        FIELD cenario-ctbl-destino       AS CHAR FORMAT "x(40)"
        FIELD seq-orcto-destino          AS INTEGER
        FIELD versao-orcto-destino       AS char.

        def temp-table tt-raw-digita
                field raw-digita    as raw.


        def input parameter raw-param as raw no-undo.
        def input parameter TABLE for tt-raw-digita.

        create tt-param.
        RAW-TRANSFER raw-param to tt-param.

        DEFINE VAR H-PROG AS HANDLE.
        DEFINE VAR I-TOT AS INTEGER.


DEFINE STREAM f_1.
DEFINE STREAM f_2.

	
DEFINE STREAM s_1.


{include/i-rpvar.i}







/* include padr’o para output de relat½rios */
{include/i-rpout.i &STREAM="stream str-rp"}
/* include com a definiÎ’o da frame de cabeÎalho e rodap' */
/* bloco principal do programa */
assign c-programa 	= "MGLA3000"
	c-versao	= "1.00"
	c-revisao	= ".00.000"
	c-empresa 	= "Araupel"
	c-sistema	= "MGL"
	c-titulo-relat = "CONJUNTO DE PARAMETROS".
view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.
    
     
FORM HEADER
    SKIP(1)
    "Demonst         Colunas                  usuario    Cenario Or.    Cenario Ct.    Versao"
    "------------    -----------------------  ---------- -------------- -------------- ------"
    SKIP(1)
    WITH FRAME f-cabec NO-ATTR NO-BOX PAGE-TOP STREAM-IO WIDTH 132 NO-LABEL.


   
        FIND FIRST tt-param NO-ERROR.


        RUN UTP/UT-PERC.P PERSISTENT SET H-PROG.
        FOR EACH conjto_prefer_demonst WHERE conjto_prefer_demonst.cod_vers_orcto_ctbl = tt-param.versao-orcto-origem
                                       AND   conjto_prefer_demonst.cod_cenar_ctbl      = tt-param.cenario-ctbl-orige
                                       AND   conjto_prefer_demonst.cod_cenar_orctario  = tt-param.cenario-orc-origem
:
           I-TOT = I-TOT + 1.
           END.

           RUN PI-INICIALIZAR IN H-PROG (INPUT "SUBSTITUINDO", I-TOT).
           FOR EACH conjto_prefer_demonst WHERE conjto_prefer_demonst.cod_vers_orcto_ctbl = tt-param.versao-orcto-origem
                                          AND   conjto_prefer_demonst.cod_cenar_ctbl      = tt-param.cenario-ctbl-orige
                                          AND   conjto_prefer_demonst.cod_cenar_orctario  = tt-param.cenario-orc-origem
   :
            RUN PI-ACOMPANHAR IN H-PROG.
            ASSIGN conjto_prefer_demonst.cod_cenar_ctbl      = tt-param.cenario-ctbl-destino
                   conjto_prefer_demonst.cod_vers_orcto_ctbl = tt-param.versao-orcto-destino
                   conjto_prefer_demonst.cod_cenar_orctario  = tt-param.cenario-orc-destino.
.

        END.



        FOR EACH conjto_prefer_demonst NO-LOCK WHERE conjto_prefer_demonst.cod_vers_orcto_ctbl <> "":


            PUT STREAM STR-RP STRING(conjto_prefer_demonst.cod_demonst_ctbl) AT 1 FORMAT  "X(15)"
                              STRING(conjto_prefer_demonst.cod_padr_col_demonst_ctbl) AT 18 FORMAT "X(20)"
                              STRING(conjto_prefer_demonst.cod_usuario) AT 40 FORMAT "X(10)"
                              STRING(conjto_prefer_demonst.cod_cenar_orctario) AT 50 FORMAT "X(10)"
                              STRING(conjto_prefer_demonst.cod_cenar_ctbl) AT 60 FORMAT "X(10)"
                              STRING(conjto_prefer_demonst.cod_vers_orcto_ctbl) AT 70 FORMAT "X(5)"                                                                  
                                     SKIP.


        END.


    RUN PI-FINALIZAR IN H-PROG.
