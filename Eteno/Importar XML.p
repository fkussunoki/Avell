DEFINE TEMP-TABLE ttnfeProc
    FIELD Nfe             AS char
    FIELD infNFe          AS char
    FIELD ide             AS CHAR
    FIELD cUF             AS CHAR FORMAT "x(2)"
    FIELD cNF             AS char FORMAT "x(8)"
    FIELD natOP           AS char FORMAT "x(40)"
    FIELD MOD             AS char
    FIELD serie           AS CHAR FORMAT "x(4)"
    FIELD nNF             AS char FORMAT "x(8)"
    FIELD dhEmi           AS char FORMAT "x(12)"
    FIELD tpNF            AS char
    FIELD idDest          AS char
    FIELD cMunFG          AS char
    FIELD tpImp           AS char
    FIELD tpEmis          AS char
    FIELD cDV             AS char
    FIELD tpAmb           AS char
    FIELD NFref           AS CHAR
    FIELD cnpjE           AS CHAR  FORMAT "x(14)"
    FIELD xNomeE          AS char
    FIELD xMunE           AS char
    FIELD UFE             AS char
    FIELD cnpjD          AS CHAR  FORMAT "x(14)"
    FIELD xNomeD         AS char
    FIELD xMunD          AS char
    FIELD UFD            AS CHAR
    FIELD Pedido         AS CHAR
    FIELD chave          AS CHAR.


DEFINE TEMP-TABLE ttemit
    FIELD cnpj            AS char
    FIELD xNome           AS char
    FIELD enderEmit       AS char
    FIELD xLgr            AS char
    FIELD nro             AS char
    FIELD xBairro         AS char
    FIELD cMun            AS char
    FIELD xMun            AS char
    FIELD UF              AS char
    FIELD IE              AS char.

DEF TEMP-TABLE ttdest
    FIELD cnpj           AS CHAR
    FIELD xNome          AS char
    FIELD xLgr           AS char
    FIELD nro            AS char
    FIELD xBairro        AS char
    FIELD cMun           AS char
    FIELD xMun           AS char
    FIELD UF             AS char
    FIELD IE             AS char.

DEFINE TEMP-TABLE ttdet
    FIELD det             AS CHAR
    FIELD prod            AS char
    FIELD cProd           AS char
    FIELD cEAN            AS char.

DEFINE TEMP-TABLE ttimposto
    FIELD imposto         AS char
    FIELD ICMS            AS char
    FIELD ICMS00          AS char
    FIELD orig            AS char
    FIELD CST             AS char.
DEFINE VARIABLE lService    AS LOGICAL NO-UNDO.
DEFINE VARIABLE cActiveNode AS CHARACTER   NO-UNDO.

DEFINE VARIABLE hSax AS HANDLE      NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_diferencial AS CHAR.
DEF VAR c-arquivos AS CHAR NO-UNDO.



DEF VAR c-entrada AS char.

ASSIGN c-entrada = "C:\xml\".

INPUT FROM VALUE(Trim(c-entrada)).

REPEAT:
    IMPORT c-arquivos.

    IF LENGTH(c-arquivos) < 3 THEN NEXT. 
    IF c-arquivos MATCHES("*~~.xml") THEN  DO:
        RUN pi-importa-xml( INPUT TRIM(c-entrada) + TRIM(c-arquivos)).


    END.

END.
    

PROCEDURE pi-importa-xml:

    DEFINE INPUT PARAM c-xml-entr AS CHAR.

    DEFINE VARIABLE lService    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cActiveNode AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE hSax        AS HANDLE      NO-UNDO.
        
    CREATE SAX-READER hSax.
    
    hSax:HANDLER = THIS-PROCEDURE.
    hSax:SET-INPUT-SOURCE("file", c-xml-entr ).
    hSax:SAX-PARSE().
END PROCEDURE.

PROCEDURE Warning:
   DEFINE INPUT PARAMETER errMessage AS CHARACTER.
   MESSAGE errMessage VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE Error:
   DEFINE INPUT PARAMETER errMessage AS CHARACTER.
   MESSAGE errMessage VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE FatalError:
   DEFINE INPUT PARAMETER errMessage AS CHARACTER.
   MESSAGE errMessage VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

PROCEDURE Characters:

   DEFINE INPUT PARAMETER charData AS LONGCHAR.
   DEFINE INPUT PARAMETER numChars AS INTEGER.

   IF TRIM(chardata) = "" THEN LEAVE. 

/*    IF charAtrib = '' THEN DO:                                                                               */
/*        IF cActiveNode = "Nome" AND TRIM(chardata) = "Fabric."            THEN ASSIGN charAtrib =  '1'. ELSE */
/*        IF cActiveNode = "Nome" AND TRIM(chardata) = "Restricao"          THEN ASSIGN charAtrib =  '9'. ELSE */
/*        IF cActiveNode = "Nome" AND TRIM(chardata) = "Garantia de Precos" THEN ASSIGN charAtrib = '10'.      */
/*    END.                                                                                                     */
/*    IF cActiveNode = "Nome" OR                                                                               */
/*       cActiveNode = "Valor" THEN ASSIGN cActiveNodeAtr = TRIM(cActiveNode) + TRIM(charAtrib).               */
/*                             ELSE ASSIGN cActiveNodeAtr = cActiveNode.                                       */
/*                                                                                                             */

   CASE cActiveNode:
   
/*     WHEN "DataHora"                  THEN ASSIGN tt-licitasys.DataHora           = charData.  
       WHEN "Arquivo"                   THEN ASSIGN tt-licitasys.Arquivo            = charData. 
       WHEN "Cliente"                   THEN ASSIGN tt-licitasys.Cliente            = charData.  
       WHEN "Usuario"                   THEN ASSIGN tt-licitasys.Usuario            = charData. 
       WHEN "QtdEditais"                THEN ASSIGN tt-licitasys.QtdEditais         = charData. 
       WHEN "QtdItens"                  THEN ASSIGN tt-licitasys.QtdItens           = charData. 
       WHEN "DataHora"                  THEN ASSIGN tt-licitasys.DataHora           = charData.*/
       WHEN "NFe"                       THEN ASSIGN ttnfeProc.NFe            = charData.
       WHEN "infNFe"                    THEN ASSIGN ttnfeProc.infNFe         = charData.   
       WHEN "ide"                       THEN ASSIGN ttnfeProc.ide            = charData.   
       WHEN "cUF"                       THEN ASSIGN ttnfeProc.cUF            = charData.   
       WHEN "cNF"                       THEN ASSIGN ttnfeProc.cNF            = fill('0', 7 - length(trim(charData))) + charData.
       WHEN "serie"                     THEN ASSIGN ttnfeProc.serie          = charData.
       WHEN "nNF"                       THEN ASSIGN ttnfeProc.nNF            = charData.
       WHEN "dhEmi"                     THEN ASSIGN ttnfeProc.dhEmi          = charData.
       WHEN "natOP"                     THEN ASSIGN ttnfeProc.natOP          = charData.   
       WHEN "mod"                       THEN ASSIGN ttnfeProc.MOD            = charData. 
       WHEN 'cnpjE'                     THEN ASSIGN ttnfeProc.cnpjE          = charData.
       WHEN 'cnpjD'                     THEN ASSIGN ttnfeProc.cnpjD          = charData.
       WHEN 'xNomeE'                    THEN ASSIGN ttnfeProc.xNomeE         = charData.
       WHEN 'xNomeD'                    THEN ASSIGN ttnfeProc.xNomeD         = charData.
       WHEN 'xMunE'                     THEN ASSIGN ttnfeProc.xMunE          = charData.
       WHEN 'xMunD'                     THEN ASSIGN ttnfeProc.xMunD          = charData.
       WHEN 'UFE'                       THEN ASSIGN ttnfeProc.UFE            = charData.
       WHEN 'UFD'                       THEN ASSIGN ttnfeProc.UFD            = charData.
       WHEN 'xPed'                      THEN ASSIGN ttnfeProc.Pedido         = charData.
       WHEN 'chave'                     THEN ASSIGN ttnfeProc.chave          = charData.


       OTHERWISE . 
   END CASE.
END PROCEDURE.

PROCEDURE EndDocument:
END PROCEDURE.

PROCEDURE EndElement:
   DEFINE INPUT PARAMETER namespaceURI AS CHARACTER.
   DEFINE INPUT PARAMETER localName AS CHARACTER.
   DEFINE INPUT PARAMETER qName AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE.


PROCEDURE EndPrefixMapping:
   DEFINE INPUT PARAMETER prefix AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE. 

PROCEDURE IgnorableWhitespace:
   DEFINE INPUT PARAMETER charData AS CHARACTER.
   DEFINE INPUT PARAMETER numChars AS INTEGER.

   /* not actually used in this example */
END PROCEDURE.

PROCEDURE NotationDecl:
   DEFINE INPUT PARAMETER name AS CHARACTER.
   DEFINE INPUT PARAMETER publicID AS CHARACTER.
   DEFINE INPUT PARAMETER systemID AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE.

PROCEDURE StartDocument:
   /* not actually used in this example */
END PROCEDURE.

PROCEDURE StartElement:


   DEFINE INPUT PARAMETER namespaceURI AS CHARACTER.
   DEFINE INPUT PARAMETER localName AS CHARACTER.
   DEFINE INPUT PARAMETER qName AS CHARACTER.
   DEFINE INPUT PARAMETER attributes AS HANDLE.


   /*MESSAGE qName VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
   CASE qName:

       /* New Product element = new record in the temp-table */
       WHEN "NFe" THEN DO: 
           CREATE ttnfeProc.
       END.
       WHEN "emit" THEN DO:
       
       ASSIGN v_diferencial = "1".
       END. 

       WHEN "dest" THEN DO:
       
       ASSIGN v_diferencial = "2".
       END.

       when "retirada" then do:
       assign v_diferencial = "3".
       end.
       
       when "entrega" then do:
       assign v_diferencial = "4".
       end.

       when "autXML" then do:
       assign v_diferencial = "7".
       end.
       
       when "infRespTec" then do:
       assign v_diferencial = "5".
       end.

       WHEN "NFref" THEN DO:
       assign v_diferencial = "6".
       END.

       WHEN "transporta" THEN DO:
       assign v_diferencial = "8".
       END.
       
       WHEN "card" THEN DO:
       assign v_diferencial = "9".
       END.

       WHEN "CNPJ" THEN DO:
       IF v_diferencial = "1" THEN
       cActiveNode = "cnpjE".
       IF v_diferencial = "2" THEN
       cActiveNode = "cnpjD".
       IF v_diferencial = "3" THEN
       cActiveNode = "cnpjRT".
       IF v_diferencial = "6" THEN
       cActiveNode = "cnpjRef".
       if v_diferencial = "7" then
       cActiveNode = "cnpjAuth".
       if v_diferencial = "8" then
       cActiveNode = "cnpjTransporta".
       if v_diferencial = "9" then
       cActiveNode = "cnpjCard".

       END.
       
       WHEN "xNome" THEN DO:
       IF v_diferencial = "1" THEN
       cActiveNode = "xNomeE".
       IF v_diferencial = "2" THEN
       cActiveNode = "xNomeD".
       END.
       
       WHEN "xMun" THEN DO:
       IF v_diferencial = "1" THEN
       cActiveNode = "xMunE".
       IF v_diferencial = "2" THEN
       cActiveNode = "xMunD".
       END.

       WHEN "UF" THEN DO:
       IF v_diferencial = "1" THEN
       cActiveNode = "UFE".
       IF v_diferencial = "2" THEN
       cActiveNode = "UFD".
       END.
       when 'nNf' then do:
       if v_diferencial = "6" then
       cActiveNode = 'nNfref'.
       if v_diferencial <> "6" then
       cActiveNode = 'nNf'.
       
       end.
       when 'serie' then do:
       if v_diferencial = "6" then
       cActiveNode = 'serieref'.
       if v_diferencial <> "6" then
       cActiveNode = 'serie'.

       end.



       WHEN 'infProt' THEN DO:
           cActiveNode = 'chave'.
       END.


       WHEN 'xPed' THEN DO:
           cActiveNode = 'xPed'.
       END.
       /* the currency code is stored in an attribute, therefore it must be assigned here. Record should be available; based
          on XML structure, it should be created in CHARACTERS callback before we encounter this node */
       /*WHEN "Price" THEN ASSIGN tt-licitasys.currency = attributes:GET-VALUE-BY-QNAME("currencyIdentificationCode").*/

       /* for any other node, just carry over the nodename */
       OTHERWISE cActiveNode = qName.
   END CASE.

END PROCEDURE.

PROCEDURE StartPrefixMapping:
   DEFINE INPUT PARAMETER prefix AS CHARACTER.
   DEFINE INPUT PARAMETER uri AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE.

PROCEDURE UnparsedEntityDecl:
   DEFINE INPUT PARAMETER name AS CHARACTER.
   DEFINE INPUT PARAMETER publicID AS CHARACTER.
   DEFINE INPUT PARAMETER systemID AS CHARACTER.
   DEFINE INPUT PARAMETER notationName AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE.

PROCEDURE ProcessingInstruction:
   DEFINE INPUT PARAMETER target AS CHARACTER.
   DEFINE INPUT PARAMETER data AS CHARACTER.

   /* not actually used in this example */
END PROCEDURE.

PROCEDURE ResolveEntity:
   DEFINE INPUT PARAMETER publicID AS CHARACTER.
   DEFINE INPUT PARAMETER systemID AS CHARACTER.
   DEFINE OUTPUT PARAMETER filePath AS CHARACTER.
   DEFINE OUTPUT PARAMETER memPointer AS LONGCHAR.

   /* not actually used in this example */
END PROCEDURE.


