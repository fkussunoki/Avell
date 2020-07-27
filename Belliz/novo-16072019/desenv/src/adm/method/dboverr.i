&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*------------------------------------------------------------------------
    Library     : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE cErrorList        AS CHARACTER NO-UNDO  /* Lista de erros */
    EXTENT 38 INITIAL ["Usu†rio sem permiss∆o para executar o mÇtodo &1", 
                      "Tabela de Comunicaá∆o n∆o dispon°vel",
                      "Tabela {&TableLabel} n∆o dispon°vel",
                      &IF "{&DBType}" = "PROGRESS":U &THEN
                      "Registro da tabela {&TableLabel} est† bloqueado pelo usu†rio ",
                      &else
                      "Registro da tabela {&TableLabel} est† bloqueado por outro usu†rio ",
                      &endif
                      "Funá∆o dispon°vel somente para Banco de Dados Progress",
                      "Query est† fechada",
                      "&1 deve ser preenchido(a)",
                      "Query est† vazia",
                      "Primeiro registro da tabela",
                      "Ultimo registro da tabela",
                      "N∆o foi poss°vel reposicionar a query",
                      "Registro corrente j† foi alterado por outro usu†rio",
                      "Falha na execuá∆o de algum mÇtodo de controle obrigat¢rio",
                      "Handle da tabela tempor†ria inv†lido",
                      "Nenhum registro posicionado na tabela tempor†ria",
                      "Registro a ser eliminado n∆o existe",
                      "N∆o existe nenhum registro posicionado",
                      "N£mero de registros a serem retornados n∆o pode ser menor que zero",
                      "N∆o existe nenhum registro cadastrado",
                      "Nome do campo desconhecido",
                      "Tipos de dados incompat°veis",
                      "Tabela j† est† posicionada no £litmo registro",
                      "Tabela j† est† posicionada no primeiro registro",
                      "N∆o foi definida nenhuma tabela",
                      "N∆o foi definido nenhum Token",
                      "N∆o foi poss°vel reposicionar o registro",
                      "Handle do programa CallBack inv†lido",
                      "Campo para a formaá∆o do °ndice deve ser diferente de branco",
                      "Tipo de °ndice inv†lido",
                      "Tipo de ordenaá∆o inv†lido",
                      "Campo r-rowid inexistente",
                      "Nome da tabela deve ser diferente de branco",
                      "Token deve ser diferente de branco",
                      "Registro eliminado por outro usu†rio",
                      "Registro j† cadastrado na tabela",
                      "O valor de algum campo no cadastro excedeu o tamanho m†ximo. Veja o arquivo dataserv.lg para descobrir a tabela e o campo onde ocorreu o erro.",
                      "Ocorreu o erro progress &1. Favor consultar o suporte.",
                      "O preprocessador CHANGE-QUERY-TO-FIND-PROCS n∆o est† preenchido."].

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


