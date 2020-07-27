/* Utilizado na include mlalistadocsportal.i */
DEFINE VARIABLE i-situacao       AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-alternativo    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-mestre         AS LOGICAL     NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR v_cdn_empres_usuar AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR v_cod_usuar_corren LIKE usuar_mestre.cod_usuar NO-UNDO.

/* Vari†veis utilizadas pela include mlacriachave.i */
DEFINE VARIABLE c-chave    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-chave    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tipo-doc AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-mla-perm-aprov NO-UNDO
    FIELD ep-codigo   LIKE mla-perm-aprov.ep-codigo   
    FIELD cod-estabel LIKE mla-perm-aprov.cod-estabel 
    FIELD cod-tip-doc LIKE mla-perm-aprov.cod-tip-doc
    FIELD cod-usuar   LIKE mla-perm-aprov.cod-usuar.   

DEFINE TEMP-TABLE tt-usuarios NO-UNDO
    FIELD cod-usuar    LIKE usuar_mestre.cod_usuar
    FIELD nome-usuar   LIKE mla-usuar-aprov.nome-usuar
    FIELD alternativo  AS   LOGICAL
    FIELD validade-ini LIKE mla-usuar-aprov-altern.validade-ini
    FIELD validade-fim LIKE mla-usuar-aprov-altern.validade-fim
    FIELD usuar-mestre LIKE mla-usuar-aprov.usuar-mestre.

DEFINE TEMP-TABLE tt-param-aprov NO-UNDO
    FIELD ep-codigo              LIKE mla-param-aprov.ep-codigo
    FIELD cod-estabel            LIKE mla-param-aprov.cod-estabel
    FIELD log-aprovac-altern-dat LIKE mla-param-aprov.log-aprovac-altern-dat
    FIELD l-assume-perm-mestre   AS LOGICAL
    FIELD l-assume-perm-aprov    AS LOGICAL.

DEFINE TEMP-TABLE tt-empresas NO-UNDO
    FIELD ep-codigo LIKE empresa.ep-codigo 
    FIELD nome      LIKE empresa.ep-codigo.

DEFINE TEMP-TABLE tt-estabelecimentos NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel 
    FIELD nome        LIKE estabelec.ep-codigo.

DEFINE TEMP-TABLE tt-usuar NO-UNDO
    FIELD cod-usuar    LIKE mla-usuar-aprov.cod-usuar
    FIELD nome-usuar   LIKE mla-usuar-aprov.nome-usuar.

DEFINE VARIABLE l-existe-assume-perm-mestre AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-existe-assume-perm-prin   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-usuario-mestre-temporario AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-usuario-mestre            AS LOGICAL     NO-UNDO.

DEFINE VARIABLE mla-ep-codigo   LIKE mla-doc-pend-aprov.ep-codigo   NO-UNDO.
DEFINE VARIABLE mla-cod-estabel LIKE mla-doc-pend-aprov.cod-estabel NO-UNDO.

/* Inicializa com a empresa logada, pois caso n∆o seja chamada a procedure listagemDocumentosEmpresaEstab
   Ç necess†rio que o funcionamento seja o mesmo */
ASSIGN mla-ep-codigo = v_cdn_empres_usuar.

PROCEDURE listagemDocumentosEmpresaEstab:
/*------------------------------------------------------------------------------------**
**  Purpose:    Retorna a listagem de documentos baseada na empresa e estabelecimento **
**  Parameters: c-ep-codigo: C¢digo da empresa (se passar branco, considera todas)    **
**              c-cod-estabel: C¢digo do estabelecimento                              **    
**                            (se passar branco, considera todos)                     **
**              iCodTipDoc: C¢digo do tipo de documento                               **
**              tipoDoc: Tipo de documento (prin  - pendentes                         **
**                                          saida - historico                         **
**                                          (aprovadores, rejeitados e reaprovados)   **
**                                          mes - mestre,                             **
**                                          ambos - (principal, mestre e alternativos)**
**                                          aprov - aprovados e reaprovados           **
**                                          reprov - reprovados                       **
**                                                                                    **
**                dtIni: Data de in°cio para consideraá∆o dos hist¢rico               **
**                dtFim: Data de tÇrmino para consideraá∆o dos hist¢rico              **                                                                      
**                ttDados: Temp-table com dados da listagem                           **
**  Notes: As datas somente s∆o utilizadas para o hist¢rico e caso n∆o sejam          **
           informadas ser∆o considerados 30 dias                                      **
---------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cEpCodigo   LIKE mla-doc-pend-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER cCodEstabel LIKE mla-doc-pend-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER iCodTipDoc  AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER tipoDoc     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER dtIni       AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER dtFim       AS DATE      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttDados.

    /* Atualiza as vari†veis de empresa e estabelecimento lidas na "listagemDocumentos" */
    ASSIGN mla-ep-codigo   = cEpCodigo
           mla-cod-estabel = cCodEstabel.

    RUN listagemDocumentos IN THIS-PROCEDURE (INPUT iCodTipDoc,
                                              INPUT tipoDoc,
                                              INPUT dtIni,
                                              INPUT dtFim,
                                              OUTPUT TABLE ttDados).
    RETURN "OK":U.
END PROCEDURE.
