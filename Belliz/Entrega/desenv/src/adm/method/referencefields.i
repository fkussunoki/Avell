&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Retorna a descri‡Æo de campos, atrav‚s da execu‡Æo dos m‚todos: goToKey e getCharField."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File       : method/ReferenceFields.i
    Purpose    : Retorna a descri‡Æo de campos, atrav‚s da execu‡Æo dos 
                 m‚todos: goToKey e getCharField

    Parameters : 
        &HandleDBOLeave : handle do programa DBO

        &KeyValue1      : valor do 1§ campo a ser utilizado no m‚todo goToKey
        &KeyValue2      : valor do 2§ campo a ser utilizado no m‚todo goToKey
        &KeyValue3      : valor do 3§ campo a ser utilizado no m‚todo goToKey
        &KeyValue4      : valor do 4§ campo a ser utilizado no m‚todo goToKey
        &KeyValue5      : valor do 5§ campo a ser utilizado no m‚todo goToKey
        &KeyValue6      : valor do 6§ campo a ser utilizado no m‚todo goToKey
        &KeyValue7      : valor do 7§ campo a ser utilizado no m‚todo goToKey
        &KeyValue8      : valor do 8§ campo a ser utilizado no m‚todo goToKey
        &KeyValue9      : valor do 9§ campo a ser utilizado no m‚todo goToKey
        &KeyValue10     : valor do 10§ campo a ser utilizado no m‚todo goToKey

        &FieldName1     : nome do campo a ser retornado
        &FieldScreen1   : nome do campo onde ser  incluso o valor retornado
        &Variable1      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame1         : nome da frame onde est  o campo {&FieldScreen1} 

        &FieldName2     : nome do campo a ser retornado
        &FieldScreen2   : nome do campo onde ser  incluso o valor retornado
        &Variable2      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame2         : nome da frame onde est  o campo {&FieldScreen2} 

        &FieldName3     : nome do campo a ser retornado
        &FieldScreen3   : nome do campo onde ser  incluso o valor retornado
        &Variable3      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame3         : nome da frame onde est  o campo {&FieldScreen3} 

        &FieldName4     : nome do campo a ser retornado
        &FieldScreen4   : nome do campo onde ser  incluso o valor retornado
        &Variable4      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame4         : nome da frame onde est  o campo {&FieldScreen4} 

        &FieldName5     : nome do campo a ser retornado
        &FieldScreen5   : nome do campo onde ser  incluso o valor retornado
        &Variable5      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame5         : nome da frame onde est  o campo {&FieldScreen5} 

        &FieldName6     : nome do campo a ser retornado
        &FieldScreen6   : nome do campo onde ser  incluso o valor retornado
        &Variable6      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame6         : nome da frame onde est  o campo {&FieldScreen6} 

        &FieldName7     : nome do campo a ser retornado
        &FieldScreen7   : nome do campo onde ser  incluso o valor retornado
        &Variable7      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame7         : nome da frame onde est  o campo {&FieldScreen7} 

        &FieldName8     : nome do campo a ser retornado
        &FieldScreen8   : nome do campo onde ser  incluso o valor retornado
        &Variable8      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame8         : nome da frame onde est  o campo {&FieldScreen8} 

        &FieldName9     : nome do campo a ser retornado
        &FieldScreen9   : nome do campo onde ser  incluso o valor retornado
        &Variable9      : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame9         : nome da frame onde est  o campo {&FieldScreen9} 

        &FieldName10    : nome do campo a ser retornado
        &FieldScreen10  : nome do campo onde ser  incluso o valor retornado
        &Variable10     : nome da vari vel onde ser  retornado o valor, por‚m o
                          retorno ser  gravado na vari vel e nÆo na propriedade
                          SCREEN-VALUE
        &Frame10        : nome da frame onde est  o campo {&FieldScreen10} 

        &ExcludeVars    : indica se as vari veis utilizadas pelo include devem ou
                          nÆo ser definidas (esta op‡Æo deve ser utilizada quando o 
                          include for utilizado, normalmente, dentro de uma procedure
                          interna)

        Somente para BO 1.1:
        &FindMethod     : nome do m‚todo, no BO 1.1, que corresponde ao m‚todo
                          goToKey, ou seja, que posiciona o BO com base nos 
                          valores do ¡ndice £nico

    Authors    : John Cleber Jaraceski, Sergio Weber

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */

&IF "{&ExcludeVars}":U <> "YES":U &THEN
    DEFINE VARIABLE cFieldValueAux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cReturnAux     AS CHARACTER NO-UNDO.
&ENDIF

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
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/*--- Verifica se o programa DBO j  est  sendo executado ---*/
IF VALID-HANDLE({&HandleDBOLeave}) THEN DO:

    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
        /*--- Executa m‚todo {&FindMethod} para realizar o posicionamento do BO 1.1 ---*/
        RUN {&FindMethod} IN {&HandleDBOLeave} (INPUT {&KeyValue1}
    &ELSE
        /*--- Executa m‚todo goToKey para realizar o posicionamento do DBO ---*/
        RUN goToKey IN {&HandleDBOLeave} (INPUT {&KeyValue1}
    &ENDIF

    &IF "{&KeyValue2}":U <> "":U &THEN
                                 ,INPUT {&KeyValue2}
    &ENDIF
    &IF "{&KeyValue3}":U <> "":U &THEN
                                 ,INPUT {&KeyValue3}
    &ENDIF
    &IF "{&KeyValue4}":U <> "":U &THEN
                                 ,INPUT {&KeyValue4}
    &ENDIF
    &IF "{&KeyValue5}":U <> "":U &THEN
                                 ,INPUT {&KeyValue5}
    &ENDIF
    &IF "{&KeyValue6}":U <> "":U &THEN
                                 ,INPUT {&KeyValue6}
    &ENDIF
    &IF "{&KeyValue7}":U <> "":U &THEN
                                 ,INPUT {&KeyValue7}
    &ENDIF
    &IF "{&KeyValue8}":U <> "":U &THEN
                                 ,INPUT {&KeyValue8}
    &ENDIF
    &IF "{&KeyValue9}":U <> "":U &THEN
                                 ,INPUT {&KeyValue9}
    &ENDIF
    &IF "{&KeyValue10}":U <> "":U &THEN
                                 ,INPUT {&KeyValue10}
    &ENDIF

    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
        ,OUTPUT cReturnAux).
    &ELSE
        ).
    &ENDIF

    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
        /*--- Verifica se o posicionamento foi realizado com sucesso ---*/
        IF cReturnAux <> "":U THEN DO:
    &ELSE
        /*--- Verifica se o posicionamento foi realizado com sucesso ---*/
        IF RETURN-VALUE = "NOK":U THEN DO:
    &ENDIF

        ASSIGN 

        &IF "{&FieldScreen1}":U <> "":U &THEN
            {&FieldScreen1}:SCREEN-VALUE IN FRAME {&Frame1} = "":U
        &ELSE
            {&Variable1} = "":U
        &ENDIF
            
        &IF "{&FieldScreen2}":U <> "":U &THEN
            {&FieldScreen2}:SCREEN-VALUE IN FRAME {&Frame2} = "":U
        &ELSEIF "{&Variable2}":U <> "":U &THEN
            {&Variable2} = "":U
        &ENDIF
        
        &IF "{&FieldScreen3}":U <> "":U &THEN
            {&FieldScreen3}:SCREEN-VALUE IN FRAME {&Frame3} = "":U
        &ELSEIF "{&Variable3}":U <> "":U &THEN
            {&Variable3} = "":U
        &ENDIF
        
        &IF "{&FieldScreen4}":U <> "":U &THEN
            {&FieldScreen4}:SCREEN-VALUE IN FRAME {&Frame4} = "":U
        &ELSEIF "{&Variable4}":U <> "":U &THEN
            {&Variable4} = "":U
        &ENDIF
        
        &IF "{&FieldScreen5}":U <> "":U &THEN
            {&FieldScreen5}:SCREEN-VALUE IN FRAME {&Frame5} = "":U
        &ELSEIF "{&Variable5}":U <> "":U &THEN
            {&Variable5} = "":U
        &ENDIF
        
        &IF "{&FieldScreen6}":U <> "":U &THEN
            {&FieldScreen6}:SCREEN-VALUE IN FRAME {&Frame6} = "":U
        &ELSEIF "{&Variable6}":U <> "":U &THEN
            {&Variable6} = "":U
        &ENDIF
        
        &IF "{&FieldScreen7}":U <> "":U &THEN
            {&FieldScreen7}:SCREEN-VALUE IN FRAME {&Frame7} = "":U
        &ELSEIF "{&Variable7}":U <> "":U &THEN
            {&Variable7} = "":U
        &ENDIF
        
        &IF "{&FieldScreen8}":U <> "":U &THEN
            {&FieldScreen8}:SCREEN-VALUE IN FRAME {&Frame8} = "":U
        &ELSEIF "{&Variable8}":U <> "":U &THEN
            {&Variable8} = "":U
        &ENDIF
        
        &IF "{&FieldScreen9}":U <> "":U &THEN
            {&FieldScreen9}:SCREEN-VALUE IN FRAME {&Frame9} = "":U
        &ELSEIF "{&Variable9}":U <> "":U &THEN
            {&Variable9} = "":U
        &ENDIF
        
        &IF "{&FieldScreen10}":U <> "":U &THEN
            {&FieldScreen10}:SCREEN-VALUE IN FRAME {&Frame10} = "":U
        &ELSEIF "{&Variable10}":U <> "":U &THEN
            {&Variable10} = "":U
        &ENDIF
        .
    END.
    ELSE DO:
        /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
        ASSIGN cFieldValueAux = "":U.

        /*--- Retorna valores de campos do registro posicionado ---*/
        RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName1}":U, OUTPUT cFieldValueAux).

        /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
        &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
            /*--- Trata retorno do m‚todo getCharField ---*/
            IF cReturnAux = "":U THEN
        &ELSE
            /*--- Trata retorno do m‚todo getCharField ---*/
            IF RETURN-VALUE = "OK":U THEN
        &ENDIF
        
        &IF "{&FieldScreen1}":U <> "":U &THEN
            ASSIGN {&FieldScreen1}:SCREEN-VALUE IN FRAME {&Frame1} = cFieldValueAux.
        &ELSE
            ASSIGN {&Variable1} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen2}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName2}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen2}:SCREEN-VALUE IN FRAME {&Frame2} = cFieldValueAux.
        &ELSEIF "{&Variable2}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName2}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable2} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen3}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName3}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen3}:SCREEN-VALUE IN FRAME {&Frame3} = cFieldValueAux.
        &ELSEIF "{&Variable3}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName3}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable3} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen4}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName4}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen4}:SCREEN-VALUE IN FRAME {&Frame4} = cFieldValueAux.
        &ELSEIF "{&Variable4}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName4}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable4} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen5}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName5}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen5}:SCREEN-VALUE IN FRAME {&Frame5} = cFieldValueAux.
        &ELSEIF "{&Variable5}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName5}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable5} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen6}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName6}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen6}:SCREEN-VALUE IN FRAME {&Frame6} = cFieldValueAux.
        &ELSEIF "{&Variable6}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName6}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable6} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen7}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName7}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen7}:SCREEN-VALUE IN FRAME {&Frame7} = cFieldValueAux.
        &ELSEIF "{&Variable7}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName7}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable7} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen8}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName8}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen8}:SCREEN-VALUE IN FRAME {&Frame8} = cFieldValueAux.
        &ELSEIF "{&Variable8}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName8}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable8} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen9}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName9}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen9}:SCREEN-VALUE IN FRAME {&Frame9} = cFieldValueAux.
        &ELSEIF "{&Variable9}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName9}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable9} = cFieldValueAux.
        &ENDIF

        &IF "{&FieldScreen10}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName10}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&FieldScreen10}:SCREEN-VALUE IN FRAME {&Frame10} = cFieldValueAux.
        &ELSEIF "{&Variable10}":U <> "":U &THEN
            /*--- Limpa conte£do da vari vel cFieldValueAux ---*/
            ASSIGN cFieldValueAux = "":U.

            /*--- Retorna valores de campos do registro posicionado ---*/
            RUN getCharField IN {&HandleDBOLeave} (INPUT "{&FieldName10}":U, OUTPUT cFieldValueAux).

            /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
            &IF "{&DBOVersion}":U = "1.1":U OR "{&FindMethod}":U <> "":U &THEN
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF cReturnAux = "":U THEN
            &ELSE
                /*--- Trata retorno do m‚todo getCharField ---*/
                IF RETURN-VALUE = "OK":U THEN
            &ENDIF
            
            ASSIGN {&Variable10} = cFieldValueAux.
        &ENDIF
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


