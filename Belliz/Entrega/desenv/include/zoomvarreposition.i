&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : ZoomVarReposition.i
    Purpose     : Chamar o programa de zoom de reposicionamento (Zoom Principal) 
                  desenvolvido em Smart Objects em programas desenvolvidos em ThinTemplates

    Syntax      : {include/zoomvarreposition.i}

    Author(s)   : Nicholas Alessandro Alves Medeiros
    Created     : 29/09/2000
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
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
  &if "{&frame}" = "" &then
      &scop FramePar in frame fPage0
  &else
      &scop FramePar in frame {&frame}
  &endif
  &if "{&frame2}" = "" &then
      &scop FramePar2 in frame fPage0
  &else
      &scop FramePar2 in frame {&frame2}
  &endif
  &if "{&frame3}" = "" &then
      &scop FramePar3 in frame fPage0
  &else
      &scop FramePar3 in frame {&frame3}
  &endif
  &if "{&frame4}" = "" &then
      &scop FramePar4 in frame fPage0
  &else
      &scop FramePar4 in frame {&frame4}
  &endif
  &if "{&frame5}" = "" &then
      &scop FramePar5 in frame fPage0
  &else
      &scop FramePar5 in frame {&frame5}
  &endif
  &if "{&frame6}" = "" &then
      &scop FramePar6 in frame fPage0
  &else
      &scop FramePar6 in frame {&frame6}
  &endif
  &if "{&frame7}" = "" &then
      &scop FramePar7 in frame fPage0
  &else
      &scop FramePar7 in frame {&frame7}
  &endif
  &if "{&frame8}" = "" &then
      &scop FramePar8 in frame fPage0
  &else
      &scop FramePar8 in frame {&frame8}
  &endif
  &if "{&frame9}" = "" &then
      &scop FramePar9 in frame fPage0
  &else
      &scop FramePar9 in frame {&frame9}
  &endif
  &if "{&frame10}" = "" &then
      &scop FramePar10 in frame fPage0
  &else
      &scop FramePar10 in frame {&frame10}
  &endif
  &if "{&browse}" <> "" &then
      &scop FramePar  in browse {&browse}
      &scop FramePar2 in browse {&browse}
      &scop FramePar3 in browse {&browse}
      &scop FramePar4 in browse {&browse}
      &scop FramePar5 in browse {&browse}
      &scop FramePar6 in browse {&browse}
      &scop FramePar7 in browse {&browse}
      &scop FramePar8 in browse {&browse}
      &scop FramePar9 in browse {&browse}
      &scop FramePar10 in browse {&browse}
  &endif
  
  if  valid-handle(wh-pesquisa) then
      return.
      
  RUN {&prog-zoom} persistent set wh-pesquisa.

  if  not valid-handle(wh-pesquisa) then
      return.
  {&parametros}
  &if '{&excludeLeave}' = 'yes' &then
      run pi-exclui-leave in wh-pesquisa (yes).
  &endif

  RUN dispatch IN wh-pesquisa ('initialize':U).
  
  if valid-handle(wh-pesquisa) then do:
    &if "{&browse}" = "" &then
        RUN pi-entry IN wh-pesquisa. 
    &endif
      
    &if defined(campo) > 0 
    and defined(campozoom) > 0 &then
        &if '{&ExcludeVar}' <> 'yes' &then
            define variable c-lista-campo as char init '' no-undo.
        &endif
        assign c-lista-campo = string({&campo}:handle {&FramePar}) + '|':U + '{&campozoom}'.
        &if defined(campo2) > 0
        and defined(campozoom2) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo2}:handle {&FramePar2}) + '|':U + '{&campozoom2}'.
        &endif
        &if defined(campo3) > 0
        and defined(campozoom3) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo3}:handle {&FramePar3}) + '|':U + '{&campozoom3}'.
        &endif
        &if defined(campo4) > 0
        and defined(campozoom4) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo4}:handle {&FramePar4}) + '|':U + '{&campozoom4}'.
        &endif
        &if defined(campo5) > 0
        and defined(campozoom5) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo5}:handle {&FramePa5r}) + '|':U + '{&campozoom5}'.
        &endif
        &if defined(campo6) > 0
        and defined(campozoom6) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo6}:handle {&FramePar6}) + '|':U + '{&campozoom6}'.
        &endif
        &if defined(campo7) > 0
        and defined(campozoom7) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo7}:handle {&FramePar7}) + '|':U + '{&campozoom7}'.
        &endif
        &if defined(campo8) > 0
        and defined(campozoom8) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo8}:handle {&FramePar8}) + '|':U + '{&campozoom8}'.
        &endif
        &if defined(campo9) > 0
        and defined(campozoom9) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campo9}:handle {&FramePar9}) + '|':U + '{&campozoom9}'.
        &endif
        &if defined(campo10) > 0
        and defined(campozoom10) > 0 &then
             assign c-lista-campo = c-lista-campo + chr(10) + string({&campo10}:handle {&FramePar10}) + '|':U + '{&campozoom10}'.
        &endif
        run pi-seta-atributos-chave in wh-pesquisa (c-lista-campo).
        RUN add-link IN adm-broker-hdl
                   (INPUT wh-pesquisa,
                    INPUT 'State':U,
                    INPUT this-procedure).
    &endif

    &if defined(campohandle) > 0 
    and defined(campozoom) > 0 &then
        define shared var adm-broker-hdl as handle no-undo.
        define variable c-lista-campo as char init '' no-undo.
        assign c-lista-campo = string({&campohandle}) + '|' + '{&campozoom}'.
        &if defined(campohandle2) > 0
        and defined(campozoom2) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle2}) + '|':U + '{&campozoom2}'.
        &endif
        &if defined(campohandle3) > 0
        and defined(campozoom3) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle3}) + '|':U + '{&campozoom3}'.
        &endif
        &if defined(campohandle4) > 0
        and defined(campozoom4) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle4}) + '|':U + '{&campozoom4}'.
        &endif
        &if defined(campohandle5) > 0
        and defined(campozoom5) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle5}) + '|':U + '{&campozoom5}'.
        &endif
        &if defined(campohandle6) > 0
        and defined(campozoom6) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle6}) + '|':U + '{&campozoom6}'.
        &endif
        &if defined(campohandle7) > 0
        and defined(campozoom7) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle7}) + '|':U + '{&campozoom7}'.
        &endif
        &if defined(campohandle8) > 0
        and defined(campozoom8) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle8}) + '|':U + '{&campozoom8}'.
        &endif
        &if defined(campohandle9) > 0
        and defined(campozoom9) > 0 &then
            assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle9}) + '|':U + '{&campozoom9}'.
        &endif
        &if defined(campohandle10) > 0
        and defined(campozoom10) > 0 &then
             assign c-lista-campo = c-lista-campo + chr(10) + string({&campohandle10}) + '|':U + '{&campozoom10}'.
        &endif
        run pi-seta-atributos-chave in wh-pesquisa (c-lista-campo).
        RUN add-link IN adm-broker-hdl
                    (INPUT wh-pesquisa,
                     INPUT 'State':U,
                     INPUT {&proghandle}).
    &endif
  end.
  &undefine FramePar
  &undefine FramePar2
  &undefine FramePar3
  &undefine FramePar4
  &undefine FramePar5
  &undefine FramePar6
  &undefine FramePar7
  &undefine FramePar8
  &undefine FramePar9
  &undefine FramePar10

assign l-implanta = no.

wait-for close of wh-pesquisa.

    &IF "{&DBOVersion}":U = "1.1":U &THEN
        define variable cReturnAux as char no-undo.
        /*--- Executa m‚todo {&FindMethod} para realizar o posicionamento do BO 1.1 ---*/
        RUN {&findMethod} IN {&hDBOParent} ( &IF "{&tipocampo}":U <> "":U &THEN
                                                 INPUT {&tipocampo}({&campo}:SCREEN-VALUE {&FramePar})
                                             &ELSE 
                                                 INPUT {&campo}:SCREEN-VALUE {&FramePar}
                                             &ENDIF    
    &ELSE
        /*--- Executa m‚todo goToKey para realizar o posicionamento do DBO ---*/
        &IF "{&findMethod}":U = "" &THEN
            RUN goToKey IN {&hDBOParent} ( &IF "{&tipocampo}":U <> "":U &THEN
                                               INPUT {&tipocampo}({&campo}:SCREEN-VALUE {&FramePar})
                                           &ELSE 
                                               INPUT {&campo}:SCREEN-VALUE (&FramePar}
                                           &ENDIF
        &ELSE
            RUN {&findMethod} IN {&hDBOParent} ( &IF "{&tipocampo}":U <> "":U &THEN
                                                     INPUT {&tipocampo}({&campo}:SCREEN-VALUE {&FramePar})
                                                 &ELSE 
                                                     INPUT {&campo}:SCREEN-VALUE {&FramePar}
                                                 &ENDIF                                          
        &ENDIF
    &ENDIF
    
    &IF "{&campo2}":U <> "":U &THEN
                                 ,&IF "{&tipocampo2}":U <> "":U &THEN
                                      INPUT {&tipocampo2}({&campo2}:SCREEN-VALUE {&FramePar2})
                                  &ELSE 
                                      INPUT {&campo2}:SCREEN-VALUE {&FramePar2}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo3}":U <> "":U &THEN
                                 ,&IF "{&tipocampo3}":U <> "":U &THEN
                                      INPUT {&tipocampo3}({&campo3}:SCREEN-VALUE {&FramePar3})
                                  &ELSE 
                                      INPUT {&campo3}:SCREEN-VALUE {&FramePar3}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo4}":U <> "":U &THEN
                                 ,&IF "{&tipocampo4}":U <> "":U &THEN
                                      INPUT {&tipocampo4}({&campo4}:SCREEN-VALUE {&FramePar4})
                                  &ELSE 
                                      INPUT {&campo4}:SCREEN-VALUE {&FramePar4}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo5}":U <> "":U &THEN
                                 ,&IF "{&tipocampo5}":U <> "":U &THEN
                                      INPUT {&tipocampo5}({&campo5}:SCREEN-VALUE {&FramePar5})
                                  &ELSE 
                                      INPUT {&campo5}:SCREEN-VALUE {&FramePar5}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo6}":U <> "":U &THEN
                                 ,&IF "{&tipocampo6}":U <> "":U &THEN
                                      INPUT {&tipocampo6}({&campo6}:SCREEN-VALUE {&FramePar6})
                                  &ELSE 
                                      INPUT {&campo6}:SCREEN-VALUE {&FramePar6}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo7}":U <> "":U &THEN
                                 ,&IF "{&tipocampo7}":U <> "":U &THEN
                                      INPUT {&tipocampo7}({&campo7}:SCREEN-VALUE {&FramePar7})
                                  &ELSE 
                                      INPUT {&campo7}:SCREEN-VALUE {&FramePar7}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo8}":U <> "":U &THEN
                                 ,&IF "{&tipocampo8}":U <> "":U &THEN
                                      INPUT {&tipocampo8}({&campo8}:SCREEN-VALUE {&FramePar8})
                                  &ELSE 
                                      INPUT {&campo8}:SCREEN-VALUE {&FramePar8}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo9}":U <> "":U &THEN
                                 ,&IF "{&tipocampo9}":U <> "":U &THEN
                                      INPUT {&tipocampo9}({&campo9}:SCREEN-VALUE {&FramePar9})
                                  &ELSE 
                                      INPUT {&campo9}:SCREEN-VALUE {&FramePar9}
                                  &ENDIF    
    &ENDIF
    &IF "{&campo10}":U <> "":U &THEN
                                 ,&IF "{&tipocampo10}":U <> "":U &THEN
                                      INPUT {&tipocampo10}({&campo10}:SCREEN-VALUE {&FramePar10})
                                  &ELSE 
                                      INPUT {&campo10}:SCREEN-VALUE {&FramePar10}
                                  &ENDIF    
    &ENDIF
    
    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF "{&DBOVersion}":U = "1.1":U &THEN
        ,OUTPUT cReturnAux).
        IF cReturnAux <> "":U THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                              INPUT 2, 
                              INPUT "{&TableName}").
      
           RETURN NO-APPLY.
        END.
    &ELSE
        ).
        IF RETURN-VALUE = "NOK":U THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                              INPUT 2, 
                              INPUT "{&TableName}":U).
      
           RETURN NO-APPLY.
        END.
    &ENDIF
    define variable r-rowid as rowid no-undo.

    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).
        
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


