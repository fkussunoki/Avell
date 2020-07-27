&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : zoom.i
    Purpose     : Chamar o programa de zoom para as chaves estrangeiras

    Syntax      : {include/zoom.i}

    Description : Chama o programa de zoom para os atributos que representam
                  chaves estrangeiras

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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  if  valid-handle(wh-pesquisa) then
      return.
  RUN {&prog-zoom} persistent set wh-pesquisa.

  if  not valid-handle(wh-pesquisa) then
      return.
  {&parametros}
  RUN dispatch IN wh-pesquisa ('initialize':U).
  RUN pi-entry IN wh-pesquisa.
  &if defined(atributo) > 0 &then
      &if '{&ExcludeVar}' <> 'yes' &then
          define variable c-lista-atributo as char init '' no-undo.
      &endif
      assign c-lista-atributo = string({&tabela}.{&atributo}:handle in frame {&frame-name}).
      &if defined(atributo2) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo2}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo3) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo3}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo4) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo4}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo5) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo5}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo6) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo6}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo7) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo7}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo8) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo8}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo9) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo9}:handle in frame {&frame-name}).
      &endif
      &if defined(atributo10) > 0 &then
          assign c-lista-atributo = c-lista-atributo + chr(10) + string({&tabela}.{&atributo10}:handle in frame {&frame-name}).
      &endif
      run pi-seta-atributos-chave in wh-pesquisa (c-lista-atributo).
  RUN add-link IN adm-broker-hdl
                 (INPUT wh-pesquisa,
                  INPUT 'State':U,
                  INPUT this-procedure).
  &endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


