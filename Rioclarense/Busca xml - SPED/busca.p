/*include de controle de vers’o*/


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
        FIELD diretorio-entrada        AS CHAR FORMAT "x(240)"
        FIELD diretorio-saida          AS CHAR FORMAT "x(240)"
        .

 
DEFINE TEMP-TABLE tt-erros
    FIELD chave AS char.

DEFINE TEMP-TABLE tt-alterados
    FIELD chave AS char.

/*     def temp-table tt-raw-digita                  */
/*             field raw-digita    as raw.           */
/*                                                   */
/*                                                   */
/*     def input parameter raw-param as raw no-undo. */
/*     def input parameter TABLE for tt-raw-digita.  */
/*                                                   */
/*     create tt-param.                              */
/*     RAW-TRANSFER raw-param to tt-param.           */
/*                                                   */

def var v_hdl_programa as HANDLE format ">>>>>>9":U no-undo.

CREATE tt-param.
ASSIGN tt-param.DIRetorio-entrada = "c:\temp\103"
       tt-param.DIRetorio-saida   = "c:\temp\103".



DEFINE VARIABLE hPDS    AS HANDLE  NO-UNDO.
DEFINE VARIABLE lReturn AS LOGICAL NO-UNDO.
DEF VAR cSourceType            AS CHAR.
DEF VAR cFile                  AS CHAR.
DEF VAR cReadMode              AS CHAR.
DEF VAR cSchemaLocation        AS CHAR.
DEF VAR lOverrideDefaultMapping AS LOGICAL.
DEFINE VARIABLE arquivo AS CHARACTER NO-UNDO
FORMAT 'x(25)'.

DEF VAR h-prog AS HANDLE NO-UNDO.
DEF STREAM entradas.


DEF TEMP-TABLE CTe
         FIELD infCte AS CHAR.

DEF TEMP-TABLE infCte
    FIELD ide AS char
    FIELD emit AS char
    FIELD rem AS char
    FIELD vPrest AS char
    FIELD imp AS char
    FIELD infCTeNorm AS char.

DEF TEMP-TABLE emit
    FIELD CNPJ AS char
    FIELD IE AS char
    FIELD xNome AS char
    FIELD xFant AS char.

DEF TEMP-TABLE rem
    FIELD CNPJ AS char
    FIELD IE AS char
    FIELD xNome AS char
    FIELD xFant AS char.

DEF TEMP-TABLE enderReme
    FIELD xLgr AS char
    FIELD nro AS char
    FIELD xCpl AS char
    FIELD xBairro AS char
    FIELD cMun AS char
    FIELD xMun AS char
    FIELD CEP AS char
    FIELD UF AS char
    FIELD xPais AS char.



DEF TEMP-TABLE dest
    FIELD CNPJ AS char
    FIELD IE AS char
    FIELD xNome AS char.

DEF TEMP-TABLE enderDest
    FIELD xLgr AS char
    FIELD nro AS char
    FIELD xCpl AS char
    FIELD xBairro AS char
    FIELD cMun AS char
    FIELD xMun AS char
    FIELD CEP AS char
    FIELD UF AS char
    FIELD xPais AS char.

DEF TEMP-TABLE vPrest
    FIELD vTPrest AS char
    FIELD vRec AS char.

DEF TEMP-TABLE Comp
    FIELD xNome AS char
    FIELD vComp AS char.

DEF TEMP-TABLE imp
    FIELD ICMS AS char.

DEF TEMP-TABLE ICMS
    FIELD ICMS00 AS char.

DEF TEMP-TABLE ICMS00
    FIELD CST AS char
    FIELD vBC AS char
    FIELD pICMS AS char
    FIELD vICMS AS char.

def temp-table infCTeNorm
    FIELD InfCarga AS char
    FIELD InfDoc AS char.

DEF TEMP-TABLE InfCarga
    FIELD vCarga AS char
    FIELD proPred AS CHAR
    FIELD InfQ AS char.

DEF TEMP-TABLE InfQ
    FIELD cunid AS char
    FIELD tpMed AS char
    FIELD qCarga AS char. 
def temp-table infDoc
    field InfNfe as char.

def temp-table infNfe
     field chave as char.

DEF TEMP-TABLE ProtCte
    FIELD InfProt AS char.

DEF TEMP-TABLE InfProt
    FIELD TpAmb AS char
    FIELD VerAplic AS char
    FIELD chCTe AS char
    FIELD dhRecbto AS char
    FIELD nProt AS char
    FIELD digVal AS char
    FIELD cStat AS char
    FIELD xMotivo AS char.


DEF TEMP-TABLE ide
    FIELD cUF AS char
    FIELD cCT AS char
    FIELD CFOP AS CHAR
    FIELD nCT AS char
    FIELD serie AS char
    FIELD dhEmi AS char
.
DEF TEMP-TABLE toma03
    FIELD toma AS char.

DEFINE TEMP-TABLE tt-dados
    FIELD chave         AS CHAR FORMAT "x(44)"
    FIELD cmunicp_reme  AS char
    FIELD cmunicp_dest  AS char
    .

DEF VAR i-tot AS INTEGER.

ASSIGN i-tot = 1.

DEFINE DATASET cteProc FOR CTe, infCte, ide, toma03, emit, rem, enderReme, dest, enderDest, vPrest, Comp, imp, ICMS, ICMS00, InfCTeNorm, InfCarga, InfQ, InfDoc, InfNFe, ProtCte, InfProt.

hPDS = DATASET cteProc:HANDLE.


INPUT FROM OS-DIR(tt-param.diretorio-saida) NO-ATTR-LIST.


REPEAT :

IMPORT arquivo.

IF arquivo BEGINS '.' THEN
NEXT.


ASSIGN
  cSourceType             = "FILE"
  cFile                   = tt-param.diretorio-saida + "\" + trim(arquivo)
  cReadMode               = "EMPTY"
  cSchemaLocation         = ?
  lOverrideDefaultMapping = NO.


lReturn = hPDS:READ-XML (cSourceType, cFile, cReadMode, cSchemaLocation, lOverrideDefaultMapping).
    IF lReturn THEN DO:


        FOR EACH INfProt:


            FOR EACH ENDerReme:

                FOR EACH ENDerDest:


                    FIND FIRST tt-dados WHERE tt-dados.chave = INfprot.chCte NO-ERROR.

                    IF NOT AVAIL tt-dados THEN  DO:

                        CREATE tt-dados.
                        ASSIGN tt-dados.chave = INfprot.chcte
                               tt-dados.cmunicp_reme = ENDerreme.cMun
                               tt-dados.cmunicp_dest = ENDerdest.cmun.

                        ASSIGN i-tot = i-tot + 1.
                    END.


                END.

                
            END.

        END.


    END.

END.
INPUT CLOSE.


OUTPUT TO c:\xml.txt.

FOR EACH tt-dados:

    PUT tt-dados.chave ";"
        tt-dados.cmunicp_reme
        SKIP.
END.


INPUT STREAM entradas FROM c:\temp\sped.txt.

DEFINE TEMP-TABLE tt-linhas
    FIELD linha AS char FORMAT "x(4000)".

REPEAT:
    
    CREATE tt-linhas.
    IMPORT STREAM entradas tt-linhas.
END.


OUTPUT TO c:\temp\inicio.txt.
FOR EACH tt-linhas WHERE tt-linhas.linha <> ""
                   AND entry(2, tt-linhas.linha, "|") = "D100"
                   AND   entry(6, tt-linhas.linha,"|") = "57"
                   AND   ENTRY(11, tt-linhas.linha, "|") <> ""
                   AND   entry(25, tt-linhas.linha, "|") = ""
                   AND   entry(26, tt-linhas.linha, "|") = "":
    EXPORT tt-linhas.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog (INPUT "Importando").



FOR EACH tt-linhas WHERE tt-linhas.linha <> ""
                   AND entry(2, tt-linhas.linha, "|") = "D100"
                   AND   entry(6, tt-linhas.linha,"|") = "57"
                   AND   ENTRY(11, tt-linhas.linha, "|") <> ""
                   AND   entry(25, tt-linhas.linha, "|") = ""
                   AND   entry(26, tt-linhas.linha, "|") = "":


                   FIND FIRST tt-dados WHERE trim(tt-dados.chave) = trim(entry(11, tt-linhas.linha, "|") )NO-ERROR.

                   IF AVAIL tt-dados THEN DO:
                       RUN pi-acompanhar IN h-prog (INPUT "Chave " + ENTRY(11, tt-linhas.linha, "|")).

                       ASSIGN  entry(25, tt-linhas.linha, "|") = tt-dados.cmunicp_reme
                               entry(26, tt-linhas.linha, "|") = tt-dados.cmunicp_dest.

                       CREATE tt-alterados.
                       ASSIGN tt-alterados.chave = ENTRY(11, tt-linhas.linha, "|").


    END.
END.


OUTPUT TO c:\temp\erros-xml.txt.
FOR EACH tt-erros:

    PUT UNFORMATTED tt-erros.chave FORMAT "x(44)"
        SKIP.
END.

OUTPUT TO c:\temp\tt-dados.txt.

FOR EACH tt-dados:

    PUT UNFORMATTED tt-dados.chave FORMAT "x(44)"
        SKIP.
END.


OUTPUT TO c:\temp\tt-atualizados.txt.

FOR EACH tt-alterados:
    PUT UNFORMATTED tt-alterados.chave
        SKIP.
END.

OUTPUT TO c:\temp\entradas.txt.
FOR EACH tt-linhas WHERE tt-linhas.linha <> ""
                   AND entry(2, tt-linhas.linha, "|") = "D100"
                   AND   entry(6, tt-linhas.linha,"|") = "57"
                   AND   ENTRY(11, tt-linhas.linha, "|") <> ""
                   AND   entry(25, tt-linhas.linha, "|") = ""
                   AND   entry(26, tt-linhas.linha, "|") = "":

    PUT UNFORMATTED ENTRY(11, tt-linhas.linha, "|") FORMAT "x(44)"
        SKIP.

END.


OUTPUT TO c:\temp\sped_final.txt.
FOR EACH tt-linhas:

    EXPORT tt-linhas.

END.

