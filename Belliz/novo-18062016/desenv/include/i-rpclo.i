/**************************************************************************
**
** I-RPCLO - Define sa°da para impress∆o do relat¢rio - ex. cd9540.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
***************************************************************************/
IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
   RUN pi_before_close IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_fim).

FOR EACH tt-configur_layout_impres_fim EXCLUSIVE-LOCK
    BY tt-configur_layout_impres_fim.num_ord_funcao_imprsor :
    do v_num_count = 1 to extent(tt-configur_layout_impres_fim.num_carac_configur):
      case tt-configur_layout_impres_fim.num_carac_configur[v_num_count]:
        when 0 then put {&stream} control null.
        when ? then leave.
        OTHERWISE PUT {&stream} control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_fim.num_carac_configur[v_num_count]),
                                                         session:cpinternal, 
                                                         c-cod_pag_carac_conver).
      end CASE.
    END.
    DELETE tt-configur_layout_impres_fim.
END.

/* N∆o gerar p†gina em branco - tech14207 11/02/2005 */
&IF "{&RTF}":U = "YES":U &THEN
    IF tt-param.l-habilitaRTF = YES THEN
        PUT {&STREAM} SKIP "&FimArquivo":U SKIP.
&ENDIF

/* Controle de impressao */
IF CAN-FIND(FIRST param_extens_ems 
            WHERE param_extens_ems.cod_entid_param_ems = "histor_impres"
              AND param_extens_ems.cod_chave_param_ems = "histor_impres"
              AND param_extens_ems.cod_param_ems       = "log_histor_impres"
              AND param_extens_ems.log_param_ems       = YES) THEN DO:

   CREATE BUFFER tt-buffer-handle FOR TABLE ("tt-param") NO-ERROR.
   IF VALID-HANDLE(tt-buffer-handle) THEN DO:
      tt-buffer-handle:FIND-FIRST NO-ERROR.
      ASSIGN c-cod-usuar-exec = tt-buffer-handle:BUFFER-FIELD("usuario"):BUFFER-VALUE
             d-dat_inicial    = tt-buffer-handle:BUFFER-FIELD("data-exec"):BUFFER-VALUE
             i-destino-relat  = tt-buffer-handle:BUFFER-FIELD("destino"):BUFFER-VALUE
         NO-ERROR.
   END.

   IF i-destino-relat = 1 /*tt-param.destino = 1*/ THEN DO:
      IF (NUM-ENTRIES(c-arquivo-ctl_imp, ":":U) >= 3) THEN DO:
         ASSIGN l-indireta-ctl_imp = TRUE
                l-impresso-ctl_imp = FALSE
                c-histor_impres_nom_impres = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":":u) - 1).
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":":U) = 3 THEN
            ASSIGN c-histor_impres_nom_arq = SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,":":U) + 1).
         ELSE
            ASSIGN c-histor_impres_nom_arq = SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,":":U) - 1).
      END.
      ELSE
          ASSIGN l-indireta-ctl_imp = FALSE
                 l-impresso-ctl_imp = TRUE
                 c-histor_impres_nom_impres = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":") - 1).
      
   END.
   ELSE
      ASSIGN l-indireta-ctl_imp = FALSE
             l-impresso-ctl_imp = FALSE
             c-histor_impres_nom_impres  = c-arquivo-ctl_imp.
   
   IF d-dat_inicial = ? THEN
      ASSIGN d-dat_inicial = TODAY.

   IF TRIM(c-usuario-solic) = "" THEN DO:

      /* Funcionalidade de Controle de Impressao
       * - Separar usuario responsavel pela impressao e solicitante da impressao. */
      IF NUM-ENTRIES(c-cod-usuar-exec, CHR(1)) = 2 THEN DO:
          ASSIGN c-usuario-solic  = ENTRY(2, c-cod-usuar-exec, CHR(1))
                 c-cod-usuar-exec = ENTRY(1, c-cod-usuar-exec, CHR(1)).
      END.
      ELSE DO:
          ASSIGN c-usuario-solic = c-cod-usuar-exec.
      END.
      /***********************************************/
   END.

   IF NOT CAN-FIND(FIRST histor_impres
                   WHERE histor_impres.dat_inicial = d-dat_inicial
                     AND histor_impres.nom_impressora = c-histor_impres_nom_impres
                     AND histor_impres.nom_arq = c-histor_impres_nom_arq
                     &IF "{&product_version}" >= "11.5.8" &THEN
                     AND histor_impres.cod_prog_dtsul = c-prg-obj                     
                     AND  histor_impres.hra_exec    =  STRING(TIME,"HH:MM:SS")                     
                     &ELSE
                     AND histor_impres.cod_prog_dtsul = c-prg-obj + "_" + STRING(TIME) 
                     &ENDIF
                     AND histor_impres.cod_usuar_exec = c-cod-usuar-exec
                     AND histor_impres.dat_efetivac_impres = TODAY) THEN
      DO TRANSACTION:

         CREATE histor_impres.
         ASSIGN histor_impres.cod_usuar_exec      = c-cod-usuar-exec /* tt-param.usuario */
                histor_impres.cod_usuar_abert     = c-usuario-solic  
                histor_impres.qti_pag_tot         = i-page-counter
                histor_impres.dat_inicial         = d-dat_inicial    /* tt-param.data-exec */
                histor_impres.dat_efetivac_impres = TODAY
                &IF "{&product_version}" >= "11.5.8" &THEN
                histor_impres.cod_prog_dtsul      = c-prg-obj
                histor_impres.hra_exec    =  STRING(TIME,"HH:MM:SS")                     
                &ELSE
                histor_impres.cod_prog_dtsul      = c-prg-obj + "_" + STRING(TIME) 
                &ENDIF
                histor_impres.nom_tit_prog        = c-titulo-relat
                histor_impres.log_impressora      = l-impresso-ctl_imp
                histor_impres.nom_impressora      = c-histor_impres_nom_impres
                histor_impres.nom_arq             = c-histor_impres_nom_arq.
   END.

END.

ASSIGN r-histor_impres = ROWID(histor_impres).

/* Finaliza UtAcomp */
ASSIGN   
  &IF "{&STREAM}":U = "":U &THEN
       i-page-counter-aux = PAGE-NUMBER
  &ELSE
     &IF "{&STREAM_ONLY}":U = "":U &THEN
       i-page-counter-aux = 0
     &ELSE
       i-page-counter-aux = PAGE-NUMBER({&STREAM_ONLY})
     &ENDIF
  &ENDIF
       NO-ERROR.

IF i-page-counter < i-page-counter-aux AND i-page-counter-aux <> ? then do:
   IF r-histor_impres <> ? THEN DO:
      DO TRANSACTION:
         IF AVAILABLE histor_impres THEN DO:
            ASSIGN i-page-counter            = i-page-counter-aux
                   histor_impres.qti_pag_tot = i-page-counter.
         END.
      END.
   END.
end.
    
IF AVAIL histor_impres THEN
   FIND CURRENT histor_impres NO-LOCK NO-ERROR.

/***********************************************/
output {&stream} close.

/* Sa°da para RTF - tech981 20/10/2004 */
&IF "{&RTF}":U = "YES":U &THEN
    /*Alterado 14/02/2005 - tech1007 - O teste foi alterado para verificar se o usu†rio selecionou a opá∆o para gerar o RTF, e
      a chamada para o utilit†rio de convers∆o para RTF tambÇm foi alterada para que seja enviada a informaá∆o da forma de execuá∆o
      do programa para que o arquivo gerado seja ou n∆o aberto ap¢s ser criado.*/
    if  tt-param.l-habilitaRTF = YES then
        /*Alterado 14/02/2005 - tech1007 - Criado novo teste para que a funcionalidade de RTF funcione adequadamente no modo de execuá∆o
          em Batch*/
        /*07/04/05 - tech14207 - Ser† passado o nome do diret¢rio spool dos servidores RPW para tratamento do endereáo apresentado */
        /*na tela do monitor do servido de execuá∆o utilizado*/
        if  i-num-ped-exec-rpw = 0 then do:                    

            /* Alterado 18/07/2005 - tech14207 - Alterado o nome do campo tt-param.modelo para tt-param.modelo-rtf  pois esse Ç o nome 
                correto do campo.
            */
                        run utp/ut-convrtf.p (input tt-param.arquivo,
                                  INPUT "",
                                  input tt-param.modelo-rtf,
                                  input c-titulo-relat,
                                  input c-sistema,
                                  input c-prg-obj,
                                  input c-prg-vrs,
                                  INPUT tt-param.destino).
        END.
        ELSE DO:
            IF OPSYS = "WIN32" THEN DO:
            /* Alterado 18/07/2005 - tech14207 - Alterado o nome do campo tt-param.modelo para tt-param.modelo-rtf  pois esse Ç o nome 
                correto do campo.
            */
                run utp/ut-convrtf.p (input c-dir-spool-servid-exec + "~/" + tt-param.arquivo,
                                      INPUT c-dir-spool-servid-exec,
                                      input tt-param.modelo-rtf,
                                      input c-titulo-relat,
                                      input c-sistema,
                                      input c-prg-obj,
                                      input c-prg-vrs,
                                      INPUT tt-param.destino).

            END.
            ELSE DO:
                /* Qdo o servidor RPW for unix Ç necess†rio utilizar a funá∆o TRIM caso contr†rio ocorrer† erro progress
                   quanto ao n£mero de parametros. Favor n∆o remover o trim(c-dir-spool-servid-exec) na passagem do
                   primeiro parametro - tech1139 - 04/03/2005.
                */
            /* Alterado 18/07/2005 - tech14207 - Alterado o nome do campo tt-param.modelo para tt-param.modelo-rtf  pois esse Ç o nome 
                correto do campo.
            */

                run utp/ut-convrtf.p (input trim(c-dir-spool-servid-exec) + "~/" + tt-param.arquivo,
                                      INPUT trim(c-dir-spool-servid-exec),
                                      input tt-param.modelo-rtf,
                                      input c-titulo-relat,
                                      input c-sistema,
                                      input c-prg-obj,
                                      input c-prg-vrs,
                                      INPUT tt-param.destino).

            END.

            IF  RETURN-VALUE <> "OK" THEN DO:
                RETURN RETURN-VALUE.
            END.
        END.
        /*Fim alteracao 14/02/2005*/
    /*Fim alteracao 14/02/2005*/
&ENDIF
/* fim: Sa°da para RTF */

/*tech14178 procedimentos de convers∆o PDF */
&IF "{&PDF-RP}" = "YES" &THEN /*tech868*/

    IF usePDF() THEN DO:
        IF tt-param.destino = 1 THEN DO:
            RUN pi_print IN h_pdf_controller.
        END.
        ELSE DO:
            &if "{&PDF-FILE}" = "" &then  /*tech868*/
                IF i-num-ped-exec-rpw <> 0 THEN
                    RUN pi_convert IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO). /* indica se vai para terminal, pois regras de nomenclatura s∆o diferentes */
                ELSE
                    RUN pi_convert IN h_pdf_controller (INPUT v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO).
            &elseif "{&PDF-FILE}" <> "" &then /*tech868*/
                IF i-num-ped-exec-rpw <> 0 THEN
                    RUN pi_convert IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO). /* indica se vai para terminal, pois regras de nomenclatura s∆o diferentes */
                ELSE
                    RUN pi_convert IN h_pdf_controller (INPUT v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO).            
            &endif
        END.
    END.

&ENDIF

IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN DO:
    RUN pi_after_close IN h-procextimpr (INPUT c-arq-control).
    DELETE PROCEDURE h-procextimpr NO-ERROR.
END.

RELEASE histor_impres.

/* i-rpout */
