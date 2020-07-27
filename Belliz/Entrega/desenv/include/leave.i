&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : leave.i
    Purpose     : Executar o find e display para chaves estrangeiras no
                  evento de leave do atributos

    Syntax      : {include/leave.i &tabela=NOME DA TABELA A PESQUISAR
                                   &atributo-ref=ATRIBUTO DA TABELA USADO COMO REFERENCIA
                                   &variavel-ref=VARIAVEL USADA PARA MOSTRAR A REFERENCIA
                                   &where=CLAUSULA USADA PARA O FIND}
    Description : Colocar no evento de leave dos atributos que sÆo chave
                  estrangeira para outras tabelas

    Author(s)   : Vanei
    Created     : 16/01/1997
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

find {&tabela}
    where {&where} no-lock no-error.
if  avail {&tabela} then do:
    assign {&variavel-ref}:screen-value in frame {&frame-name} = string({&tabela}.{&atributo-ref}).
&if defined(variavel-ref2) > 0 and defined(atributo-ref2) > 0 &then
    assign {&variavel-ref2}:screen-value in frame {&frame-name} = string({&tabela}.{&atributo-ref2}).
&endif
&if defined(variavel-ref3) > 0 and defined(atributo-ref3) > 0 &then
    assign {&variavel-ref3}:screen-value in frame {&frame-name} = string({&tabela}.{&atributo-ref3}).
&endif
end.
else do:
    assign {&variavel-ref}:screen-value in frame {&frame-name} = "".
&if defined(variavel-ref2) > 0 and defined(atributo-ref2) > 0 &then
    display "" @ {&variavel-ref2} with frame {&frame-name}.
&endif
&if defined(variavel-ref3) > 0 and defined(atributo-ref3) > 0 &then
    display "" @ {&variavel-ref3} with frame {&frame-name}.
&endif
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


