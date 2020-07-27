/**************************************************************************
**
** I-RPOUT - Define sa°da para impress∆o do relat†rio - ex. cd9520.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
**             {&append} = append    
**             {&tofile} = nome da vari†vel ou campo com arquivo de destino
**             {&pagesize} = tamanho da pagina
**             {&codepage} = permite trocar o c¢digo de p†gina de destino do relat¢rio ou 
**                           para indicar que n∆o haver† convers∆o. Os valores poss°veis ser∆o "no-convert" 
**                           ou um c¢digo de p†gina v†lido para o Progress, por exemplo, iso-8859-1, utf-8, ibm850, etc. 
**                           Quando o parÉmetro n∆o for informado, ser† feita a convers∆o para o c¢digo de p†gina padr∆o - iso-8859-1.
***************************************************************************/

   /*As definiá‰es foram transferidas para a include i-rpvar.i (FO 1.120.458) */
   /*11/02/2005 - EdÇsio <tech14207>*/

   def new global shared var c-dir-spool-servid-exec as char no-undo.                     
   def new global shared var i-num-ped-exec-rpw as int no-undo.                           
                                                                                   
   /*variaveis processador externo impress∆o localizaá∆o*/


   /* procedimento necess†rio para permitir redirecionar saida para arquivo temporario no pdf sem aparecer na pagina de parametros */
   &if "{&tofile}" = "" &then
   ASSIGN v_output_file = tt-param.arquivo.
   &elseif "{&tofile}" <> "" &then
   ASSIGN v_output_file = {&tofile}.
   &endif

   /*tech14178 inicio definiá‰es PDF */
   &IF "{&mguni_version}" >= "2.04" &THEN
   &GLOBAL-DEFINE PDF-RP YES /*tech868*/
   
   &if "{&tofile}" = "" &then  /*tech868*/
   IF NUM-ENTRIES(tt-param.arquivo,"|":U) > 1  THEN DO:
      ASSIGN v_cod_relat = ENTRY(2,tt-param.arquivo,"|":U).
      ASSIGN v_cod_file_config = ENTRY(3,tt-param.arquivo,"|":U).
      ASSIGN tt-param.arquivo = ENTRY(1,tt-param.arquivo,"|":U).
      
      RUN pi_prepare_permissions IN h_pdf_controller(INPUT v_cod_relat).
      RUN pi_set_format IN h_pdf_controller(INPUT IF v_cod_relat <> "":U THEN "PDF":U ELSE "Texto":U).
      RUN pi_set_file_config IN h_pdf_controller(INPUT  v_cod_file_config).
      
   END.

   IF usePDF() AND tt-param.destino = 2 THEN DO:
      IF entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U) <> "pdf" THEN
         assign tt-param.arquivo = replace(tt-param.arquivo,".":U + entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U),".pdf":U).
   END.

   IF usePDF() AND tt-param.destino <> 1 THEN /*tech14178 muda o nome do arquivo para salvar temporario quando n∆o Ç impressora*/
      ASSIGN v_output_file = tt-param.arquivo + ".pdt".

   &elseif "{&tofile}" <> "" &then
   IF NUM-ENTRIES({&tofile},"|":U) > 1  THEN DO:
      ASSIGN v_cod_relat = ENTRY(2,{&tofile},"|":U).
      ASSIGN v_cod_file_config = ENTRY(3,{&tofile},"|":U).
      ASSIGN {&tofile} = ENTRY(1,{&tofile},"|":U).

      RUN pi_prepare_permissions IN h_pdf_controller(INPUT v_cod_relat).
      RUN pi_set_format IN h_pdf_controller(INPUT IF v_cod_relat <> "":U THEN "PDF":U ELSE "Texto":U).
      RUN pi_set_file_config IN h_pdf_controller(INPUT  v_cod_file_config).
      
   END.

   /*Alteraá∆o 12/07/2007 - tech1007 - FO 1561331 - Foi removida a chamada para o campo arquivo da tt-param e substitu°do pela vari†vel {&tofile}*/
   IF usePDF() AND tt-param.destino = 2 THEN DO:
      IF entry(num-entries({&tofile},".":U),{&tofile},".":U) <> "pdf" THEN
         assign {&tofile} = replace({&tofile},".":U + entry(num-entries({&tofile},".":U),{&tofile},".":U),".pdf":U).
   END.

   IF usePDF() AND tt-param.destino <> 1 THEN /*tech14178 muda o nome do arquivo para salvar temporario quando n∆o Ç impressora*/
      ASSIGN v_output_file = {&tofile} + ".pdt".  

   &GLOBAL-DEFINE PDF-FILE {&tofile} /*tech868*/
   &endif
   
   IF usePDF() AND tt-param.destino = 1  THEN /*pega arquivo tempor†rio randomico para ser usado como impressora */
      ASSIGN v_cod_temp_file_pdf = getPrintFileName().

   /*
    * Funcionalidade de Controle de Impressao
    * - Separar usuario responsavel pela impressao e solicitante da impressao.
    */
   IF NUM-ENTRIES(tt-param.usuario, CHR(1)) = 2 THEN DO:
      ASSIGN c-usuario-solic  = ENTRY(2, tt-param.usuario, CHR(1))
             tt-param.usuario = ENTRY(1, tt-param.usuario, CHR(1)).
   END.

   /***********************************************/

   /*
    * Funcionalidade de Controle de Impressao
    * - Tratamento para contagem do numero de paginas.
    */
   ASSIGN
   &IF "{&STREAM}":U = "":U &THEN
      i-page-counter-aux = PAGE-NUMBER
   &ELSEIF "{&STREAM_ONLY}":U = "":U &THEN
      i-page-counter-aux = 0
   &ELSE
      i-page-counter-aux = PAGE-NUMBER({&STREAM_ONLY})
   &ENDIF
      NO-ERROR.

   IF i-page-counter < i-page-counter-aux AND i-page-counter-aux <> ? THEN do:
      IF r-histor_impres <> ? THEN DO:
         DO TRANSACTION:
            FIND FIRST histor_impres EXCLUSIVE-LOCK
               WHERE ROWID(histor_impres) = r-histor_impres NO-ERROR.

            IF AVAILABLE histor_impres THEN DO:

               IF histor_impres.log_impressora = YES THEN DO:

                   ASSIGN i-page-counter  = i-page-counter-aux
                          histor_impres.qti_pag_impres = i-page-counter
                          histor_impres.qti_pag_tot = i-page-counter.
               END.
               ELSE DO:
                   
                   ASSIGN i-page-counter            = i-page-counter-aux
                          histor_impres.qti_pag_tot = i-page-counter.
               END.
               
               FIND CURRENT histor_impres NO-LOCK NO-ERROR.
            END.
         END.
      END.
   end.
   /***********************************************/
   &endif

   /*tech14178 fim definiá‰es PDF */

   /*29/12/2004 - tech1007 - Verifica se o arquivo informado tem extensao rtf, se tiver troca para .lst*/
   &IF "{&RTF}":U = "YES":U &THEN
   IF entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U) = "rtf" AND tt-param.l-habilitaRtf = YES THEN
      assign tt-param.arquivo = replace(tt-param.arquivo,".":U + entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U),".lst":U).
   &ENDIF

   /*************/
   &IF "{&product_version}" >= "11.5.4" &THEN
   /*
    * Atualizar a data e hora presente no nome do arquivo de sa°da (tt-param.arquivo). 
    * Se o relat¢rio estiver executando em RPW (i-num-ped-exec-rpw > 0), acrescentar o n£mero do pedido no nome do arquivo.
    */
   &IF "{&tofile}" <> "":U &THEN
   ASSIGN c-arquivo-ctl_imp = {&tofile}.
   &ELSE
   ASSIGN c-arquivo-ctl_imp = tt-param.arquivo.
   &ENDIF

   IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3  THEN DO:
      IF i-num-ped-exec-rpw = 0 THEN DO:
         FIND FIRST histor_impres NO-LOCK 
              WHERE histor_impres.nom_arq = SUBSTRING(c-arquivo-ctl_imp ,R-INDEX(c-arquivo-ctl_imp ,":") + 1) NO-ERROR.
         IF AVAIL histor_impres THEN DO:
            ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".")) 
               + STRING(TODAY,"99999999") 
               + STRING(TIME,"99999") 
               + SUBSTRING(c-arquivo-ctl_imp, INDEX(c-arquivo-ctl_imp, STRING(YEAR(TODAY))) + 9).
         END.
      END.
      ELSE DO:
         IF SUBSTRING(c-arquivo-ctl_imp, LENGTH(c-arquivo-ctl_imp) - 3, 1) = "." THEN DO:
            IF SUBSTRING(c-arquivo-ctl_imp, LENGTH(c-arquivo-ctl_imp) - 3, 4) = ".prn" THEN
               ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp,1, R-INDEX(c-arquivo-ctl_imp,".") - 1) + STRING(i-num-ped-exec-rpw) +  ".prn".
            ELSE
               ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".") - 1) 
                  + STRING(i-num-ped-exec-rpw) 
                  + SUBSTRING(c-arquivo-ctl_imp,LENGTH(c-arquivo-ctl_imp) - 3).
         END.
         ELSE DO:
            ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".")) 
               + STRING(TODAY,"99999999") 
               + STRING(TIME,"99999") 
               + SUBSTRING(c-arquivo-ctl_imp, INDEX(c-arquivo-ctl_imp, STRING(YEAR(TODAY))) + 9) 
               + STRING(i-num-ped-exec-rpw).
         END.
      END.
   END.
   
   /*
    * Quanto Ö pasta de destino do arquivo de sa°da: para impress‰es usando impressora, e direcionadas a arquivo, h† o seguinte comportamento:
    *    - Impress∆o on-line: Quando n∆o possuir caminho informado, o arquivo ser† gravado num diret¢rio que ser† a combinaá∆o do diret¢rio e subdiret¢rio 
    *                         de spool do cadastro do usu†rio, a exemplo do que ocorre quando a sa°da do relat¢rio Ç "arquivo". 
    *    - Impress∆o batch: 
    *       - Arquivo ser† gravado num diret¢rio que ser† a combinaá∆o do diret¢rio de spool do servidor RPW com o subdiret¢rio de spool RPW do usu†rio emissor.
    *          - Quando a impressora for do tipo "em escala", o subdiret¢rio do usu†rio deve ser desconsiderado. Verificar nos parÉmetros gerais do m¢dulo B†sico 
    *            se o recurso est† ativado e no cadastro da impressora se a mesma est† apta para impress∆o em escala.
    */
   IF tt-param.destino = 1 THEN DO: /* destino impressora */
      IF i-num-ped-exec-rpw = 0 THEN DO: /* impressao on-line */
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3 THEN DO: /* impressao direcionada para arquivo */
            IF INDEX(c-arquivo-ctl_imp, "~/") = 0 THEN DO: /* caminho nao informado */
               FIND FIRST usuar_mestre NO-LOCK
                  WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-ERROR.
               IF AVAIL usuar_mestre THEN DO:
                  ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp,1,LENGTH(c-arquivo-ctl_imp) - LENGTH(ENTRY(3,c-arquivo-ctl_imp,":")))
                     + usuar_mestre.nom_dir_spool 
                     + usuar_mestre.nom_subdir_spool  
                     + "~/"
                     + SUBSTRING(c-arquivo-ctl_imp,LENGTH(c-arquivo-ctl_imp) - LENGTH(ENTRY(3,c-arquivo-ctl_imp,":")) + 1).
               END.
            END.
         END.
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 4 THEN DO:
            /* caminho do arquivo informado e nenhuma acao sera tomada */
         END.
      END.
      ELSE DO: /* impressao em batch */
         IF (NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3 OR  /* impressao direcionada para arquivo */
             NUM-ENTRIES(c-arquivo-ctl_imp,":") = 4) AND /* impressao direcionada para arquivo com caminho informado */ 
            INDEX(c-arquivo-ctl_imp,"~/") <> 0 THEN DO: /* caminho informado */
            /* desconsiderando caminho informado */
            ASSIGN c-arquivo-ctl_imp = ENTRY(1,c-arquivo-ctl_imp,":") 
                                             + ":"
                                             + ENTRY(2,c-arquivo-ctl_imp,":")
                                             + ":"
                                             + SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,"~/") + 1).

            FIND FIRST impressora NO-LOCK
               WHERE impressora.nom_impressora = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":") - 1) NO-ERROR.
            IF AVAIL impressora THEN DO:
               FIND FIRST usuar_mestre NO-LOCK
                  WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-ERROR.
               IF AVAIL usuar_mestre THEN DO:
                  IF NOT impressora.log_impres_escal THEN  /* impressora normal */
                     ASSIGN c-dir-spool-servid-exec = c-dir-spool-servid-exec 
                        + "~/"
                        + usuar_mestre.nom_subdir_spool_rpw.
               END.
            END.
         END.
      END.
   END.
   
   &IF "{&tofile}" <> "":U &THEN
   ASSIGN {&tofile} = c-arquivo-ctl_imp.
   &ELSE
   ASSIGN tt-param.arquivo = c-arquivo-ctl_imp.
   &ENDIF
   
   &ENDIF
   /*************/

   if  tt-param.destino = 1 then do:
      &if "{&tofile}" = "" &then 
      if num-entries(tt-param.arquivo,":") = 2 then do:
      &elseif "{&tofile}" <> "" &then
      if num-entries({&tofile},":") = 2 then do:
      &endif                            
      &if "{&tofile}" = "" &then 
         assign c-impressora = substring(tt-param.arquivo,1,index(tt-param.arquivo,":") - 1).
         assign c-layout     = substring(tt-param.arquivo,index(tt-param.arquivo,":") + 1,length(tt-param.arquivo) - index(tt-param.arquivo,":")). 
      &elseif "{&tofile}" <> "" &then
         assign c-impressora = substring({&tofile},1,index({&tofile},":") - 1).
         assign c-layout     = substring({&tofile},index({&tofile},":") + 1,length({&tofile}) - index({&tofile},":")). 
      &endif                            

         find layout_impres no-lock
            where layout_impres.nom_impressora    = c-impressora
            and   layout_impres.cod_layout_impres = c-layout no-error.
         find imprsor_usuar no-lock
            where imprsor_usuar.nom_impressora = c-impressora
            and   imprsor_usuar.cod_usuario    = tt-param.usuario
            use-index imprsrsr_id no-error.
         find impressora  of imprsor_usuar no-lock no-error.
         find tip_imprsor of impressora    no-lock no-error.

         /*Alterado 26/04/2005 - tech1007 - Alterado para n∆o ocasionar problemas na convers∆o do mapa de caracteres*/
         IF AVAILABLE tip_imprsor THEN DO:
            ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
         END.
         IF AVAILABLE layout_impres THEN DO:
            ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
         END.
         /*Fim alteracao - tech1007*/

         &IF "{&mguni_version}" > "2.04" &THEN
         &IF "{&emsfnd_version}" >= "1.00" &THEN
         ASSIGN c_process-impress = impressora.cod_livre_1.
         &ELSE
         ASSIGN c_process-impress = impressora.char-1.
         &ENDIF
         IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
               /*verifica se o programa j† est† sendo executado, 
                 caso o encontre na mem¢ria usa o mesmo handle */
               h-procextimpr = SESSION:LAST-PROCEDURE.
               REPEAT:
                  IF VALID-HANDLE(h-procextimpr) AND 
                     h-procextimpr:TYPE = "PROCEDURE" AND 
                     h-procextimpr:FILE-NAME = c_process-impress 
                     THEN LEAVE.                       
                  h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                  IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
               END.
               IF NOT VALID-HANDLE(h-procextimpr) THEN
                  RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
         END.
         &ENDIF
         if  i-num-ped-exec-rpw <> 0 then do:
            find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
            find b_servid_exec_style of b_ped_exec_style no-lock no-error.
            find servid_exec_imprsor of b_servid_exec_style
               where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.
            if available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
            then do:
               ASSIGN i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  output {&stream} through value(v_cod_temp_file_pdf)
                     page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                  RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
               END.
               ELSE
               &ENDIF
                  output {&stream} through value(servid_exec_imprsor.nom_disposit_so)
                     page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* if */.
            else do:
               /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
               ASSIGN c-arq-control = servid_exec_imprsor.nom_disposit_so.
               /*Fim alteracao 26/04/2005*/

               IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
                  RUN pi_before_output IN h-procextimpr 
                     (INPUT c-impressora,
                      INPUT c-layout,
                      INPUT tt-param.usuario,
                      INPUT-OUTPUT c-arq-control,
                      INPUT-OUTPUT i-num_lin_pag,
                      INPUT-OUTPUT c-cod_pag_carac_conver).

               ASSIGN i-nr-linha-pag = i-num_lin_pag. /* armazena qtd de linhas por pagina */
            
               &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  output {&stream}  to value(v_cod_temp_file_pdf)
                     page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
                  RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
               END.
               ELSE
               &ENDIF
                  output {&stream}  to value(c-arq-control)
                     page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
            end /* else */.
         end.
         else do:
            /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
            ASSIGN c-arq-control = imprsor_usuar.nom_disposit_so.
            /*Fim alteracao 26/04/2005*/

            IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
               RUN pi_before_output IN h-procextimpr 
               (INPUT c-impressora,
                INPUT c-layout,
                INPUT tt-param.usuario,
                INPUT-OUTPUT c-arq-control,
                INPUT-OUTPUT i-num_lin_pag,
                INPUT-OUTPUT c-cod_pag_carac_conver).

            if i-num_lin_pag = 0 then do:
               ASSIGN i-nr-linha-pag = 0. /* armazena qtd de linhas por pagina */
               &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  /* sem salta p†gina */
                  output  {&stream} 
                     to value(v_cod_temp_file_pdf)
                     page-size 0
                     convert target c-cod_pag_carac_conver . 
                  RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
               END.
               ELSE
               &ENDIF
                  /* sem salta p†gina */
                  output  {&stream} 
                     to value(c-arq-control)
                     page-size 0
                     convert target c-cod_pag_carac_conver . 
            end.
            else do:
               ASSIGN i-nr-linha-pag = i-num_lin_pag. /* armazena qtd de linhas por pagina */
               &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  /* sem salta p†gina */
                  output  {&stream} 
                     to value(v_cod_temp_file_pdf)
                     paged page-size value(i-num_lin_pag) 
                     convert target c-cod_pag_carac_conver .
                  RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
               END.
               ELSE
               &ENDIF
                  /* com salta p†gina */
                  output {&stream} 
                     to value(c-arq-control)
                     paged page-size value(i-num_lin_pag) 
                     convert target c-cod_pag_carac_conver .
            end.
         end.

         for each configur_layout_impres NO-LOCK 
            where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
               by configur_layout_impres.num_ord_funcao_imprsor:

            find configur_tip_imprsor no-lock
               where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
               and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
               and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
               use-index cnfgrtpm_id no-error.
            CREATE tt-configur_layout_impres_inicio.    
            BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
         end.

         IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
            RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

         FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
            BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
            do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):            
               case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                  when 0 then put {&stream} control null.
                  when ? then leave.
                  otherwise   put {&stream} control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                                     session:cpinternal, 
                                                                     c-cod_pag_carac_conver).
               end case.
            end.
            DELETE tt-configur_layout_impres_inicio.
         END.
      end.
      else do:
         &if "{&tofile}" = "" &then 
         assign c-impressora  = entry(1,tt-param.arquivo,":").
         assign c-layout      = entry(2,tt-param.arquivo,":"). 
         if num-entries(tt-param.arquivo,":") = 4 then
            assign c-arq-control = entry(3,tt-param.arquivo,":") + ":" + entry(4,tt-param.arquivo,":").
         else 
            assign c-arq-control = entry(3,tt-param.arquivo,":").
         &elseif "{&tofile}" <> "" &then
         assign c-impressora  = entry(1,{&tofile},":").
         assign c-layout      = entry(2,{&tofile},":").
         &if "{&tofile}" = "" &then 
         if num-entries(tt-param.arquivo,":") = 4 then
         &elseif "{&tofile}" <> "" &then
         if num-entries({&tofile},":") = 4 then
         &endif
            assign c-arq-control = entry(3,{&tofile},":") + ":" + entry(4,{&tofile},":").
         else
            assign c-arq-control = entry(3,{&tofile},":").
         &endif                            

         find layout_impres no-lock
            where layout_impres.nom_impressora    = c-impressora
            and   layout_impres.cod_layout_impres = c-layout no-error.
         find imprsor_usuar no-lock
            where imprsor_usuar.nom_impressora = c-impressora
            and   imprsor_usuar.cod_usuario    = tt-param.usuario
            use-index imprsrsr_id no-error.
         find impressora  of imprsor_usuar no-lock no-error.
         find tip_imprsor of impressora    no-lock no-error.

         /*Alterado 26/04/2005 - tech1007 - Alterado para n∆o ocasionar problemas na convers∆o do mapa de caracteres*/
         IF AVAILABLE tip_imprsor THEN DO:
            ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
         END.
         IF AVAILABLE layout_impres THEN DO:
            ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
         END.
         /*Fim alteracao - tech1007*/

         &IF "{&mguni_version}" > "2.04" &THEN
         &IF "{&emsfnd_version}" >= "1.00" &THEN
         ASSIGN c_process-impress = impressora.cod_livre_1.
         &ELSE
         ASSIGN c_process-impress = impressora.char-1.
         &ENDIF
         IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
               /*verifica se o programa j† est† sendo executado, 
                 caso o encontre na mem¢ria usa o mesmo handle */
               h-procextimpr = SESSION:LAST-PROCEDURE.
               REPEAT:
                  IF VALID-HANDLE(h-procextimpr) AND 
                     h-procextimpr:TYPE = "PROCEDURE" AND 
                     h-procextimpr:FILE-NAME = c_process-impress 
                     THEN LEAVE.                       
                  h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                  IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
               END.
               IF NOT VALID-HANDLE(h-procextimpr) THEN
                  RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
         END.
         &ENDIF
    
         &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 adiciona extens∆o PDT para que o arquivo a ser convertido n∆o fique com o mesmo nome do arquivo final*/
         IF usePDF() THEN 
            ASSIGN c-arq-control = c-arq-control + ".pdt":U.
         &endif
      
         if  i-num-ped-exec-rpw <> 0 then do:
            find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
            find b_servid_exec_style of b_ped_exec_style no-lock no-error.
            find servid_exec_imprsor of b_servid_exec_style 
               where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.
            if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
            then do:
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output {&stream} to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                  page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* if */.
            else do:
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output {&stream}  to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                  page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* else */.
         end.
         else do:
            /*Alterado 26/04/2005 - tech1007 - Removido pois o assign est† sendo realizado antes dos testes
            ASSIGN 
            i-num_lin_pag = layout_impres.num_lin_pag
            c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
            Fim alteracao 26/04/2005*/    

            IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
               RUN pi_before_output IN h-procextimpr 
                  (INPUT c-impressora,
                   INPUT c-layout,
                   INPUT tt-param.usuario,
                   INPUT-OUTPUT c-arq-control,
                   INPUT-OUTPUT i-num_lin_pag,
                   INPUT-OUTPUT c-cod_pag_carac_conver).
            if i-num_lin_pag = 0 then do:
               /* sem salta p†gina */
               output  {&stream} 
                  to value(c-arq-control)
                  page-size 0
                  convert target c-cod_pag_carac_conver . 
            end.
            else do:
               /* com salta p†gina */
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output {&stream} 
                  to value(c-arq-control)
                  paged page-size value(layout_impres.num_lin_pag) 
                  convert target tip_imprsor.cod_pag_carac_conver.
            end.
         end.

         &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 guarda o nome do arquivo a ser convertido para pdf  */
         if  i-num-ped-exec-rpw <> 0 THEN
            RUN pi_set_print_filename IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + c-arq-control).
         ELSE
            RUN pi_set_print_filename IN h_pdf_controller (INPUT c-arq-control).
         &ENDIF
         
         for each configur_layout_impres NO-LOCK 
            where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
               by configur_layout_impres.num_ord_funcao_imprsor:

            find configur_tip_imprsor no-lock
               where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                 and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                 and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                 use-index cnfgrtpm_id no-error.
            CREATE tt-configur_layout_impres_inicio.    
            BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
         end.

         IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN                
            RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

         FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
               BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
            do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):
               case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                  when 0 then put {&stream} control null.
                  when ? then leave.
                  otherwise   put {&stream} control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                                     session:cpinternal, 
                                                                     c-cod_pag_carac_conver).
               end case.
            end.
            DELETE tt-configur_layout_impres_inicio.
         END.
      end.  
   end.
   else do: /* if  tt-param.destino = 1 then do: */
      &if "{&tofile}" = "" &then
      if  i-num-ped-exec-rpw <> 0 then do:
      &if "{&pagesize}" = "" &then
         /*Alterado 14/02/2005 - tech1007 - Alterado para que quando for gerar RTF em batch
           o tamanho da p†gina seja 42*/
      &IF "{&RTF}":U = "YES":U &THEN
      IF tt-param.l-habilitaRTF = YES THEN DO:
         assign i-nr-linha-pag = 43. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
            paged page-size 43 /* tech1139 - 11/07/2005 - alterado pra imprimir 43 linhas por p†gina - FO 1179.660 */
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
      END.
      ELSE DO:
      &endif
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
            paged page-size 64
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &IF "{&RTF}":U = "YES":U &THEN
      END.
      &endif
         /*Fim alteracao 14/02/2005*/
      &else         
      assign i-page-size-rel = integer("{&pagesize}").
      assign i-nr-linha-pag = i-page-size-rel. /* armazena qtd de linhas por pagina */
      output {&stream} 
         to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
         paged page-size value(i-page-size-rel)
         &IF "{&codepage}" = "" &THEN
         convert target "iso8859-1" {&append}.
         &ELSEIF "{&codepage}" = "no-covert" &THEN
         NO-CONVERT {&append}.
         &ELSE
         CONVERT TARGET {&CODEPAGE} {&APPEND}.
         &ENDIF
      &endif              
      end.
      else do:
      /* Sa°da para RTF - tech981 20/10/2004 */
      &if "{&pagesize}" = "" &then
      &IF "{&RTF}":U = "YES":U &THEN
      if  tt-param.l-habilitaRTF = YES then do:
         assign i-nr-linha-pag = 43. /* armazena qtd de linhas por pagina */
         output {&stream}
            to value(v_output_file)
            paged page-size 43 /* tech1139 - 11/07/2005 - alterado pra imprimir 43 linhas por p†gina - FO 1179.660 */
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
      END.
      ELSE DO:
      &endif
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(v_output_file) 
            paged page-size 64 
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.                
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &IF "{&RTF}":U = "YES":U &THEN
      END.
         &endif
         &else 
         assign i-page-size-rel = integer("{&pagesize}").
         assign i-nr-linha-pag = i-page-size-rel. /* armazena qtd de linhas por pagina */
         output {&stream}
            to value(v_output_file)
            paged page-size value(i-page-size-rel)
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &endif
      end.    
         &else    
         if  i-num-ped-exec-rpw <> 0 then do:
         &if "{&pagesize}" = "" &then
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
            paged page-size 64
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.         
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &else         
         assign i-page-size-rel = integer("{&pagesize}").
         assign i-nr-linha-pag = i-page-size-rel. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
            paged page-size value(i-page-size-rel)
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.         
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &endif         
      end.        
      else do:
         &if "{&pagesize}" = "" &then
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(v_output_file) 
            paged page-size 64 
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.         
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &else         
         assign i-page-size-rel = integer("{&pagesize}").
         assign i-nr-linha-pag = i-page-size-rel. /* armazena qtd de linhas por pagina */
         output {&stream} 
            to value(v_output_file) 
            paged page-size value(i-page-size-rel)
            &IF "{&codepage}" = "" &THEN
            convert target "iso8859-1" {&append}.         
            &ELSEIF "{&codepage}" = "no-covert" &THEN
            NO-CONVERT {&append}.
            &ELSE
            CONVERT TARGET {&CODEPAGE} {&APPEND}.
            &ENDIF
         &endif         
      end.  
      &endif
   end.

/* i-rpout */
