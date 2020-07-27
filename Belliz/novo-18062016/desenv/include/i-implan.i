/********************************************************************************
** 
** Include para rodar o Implanta
**
** include/i-implan.i
**
** {1} - Programa de implanta��o a ser rodado
** r-registro-atual - Variavel com o rowid da tabela (variavel global tabela do zoom)
** {2} - Handle do browse de zoom
** {3} - Handle do browse de zoom
** {4} - Handle do browse de zoom
** {5} - Handle do browse de zoom
** {6} - Handle do browse de zoom
** {7} - Handle do browse de zoom
*********************************************************************************/
/*Altera��o 05/03/2007 - tech30713 - Criado pre-processador - FO: 1469644*/
&if defined(pre_ProgPersist) = 0 &then
   /*Altera��o 22/12/2006 - tech1007 FO 1433972 - Altera��o para executar os programas de implanta��o de forma persistente*/
   DEFINE VARIABLE hProgPersist AS HANDLE     NO-UNDO.
   &global-define pre_ProgPersist YES
&ENDIF /*Altera��o 05/03/2007 - tech30713 - FO: 1469644 - FIM*/

   /*Fim altera��o 22/12/2006*/

   assign bt-implantar:sensitive in frame {&frame-name} = no.

   /*Altera��o 22/12/2006 - tech1007 FO 1433972 - Altera��o para executar os programas de implanta��o de forma persistente
   run {1}.
   */
   RUN {1} PERSISTENT SET hProgPersist.
   RUN dispatch IN hProgPersist (INPUT "initialize").

   /*Altera��o 11/09/2007 - tech1007 - FO 1512049 - Alterado para s� executar o wait-for se o handle for v�lido.
                            Isso evita problemas quando o usu�rio n�o possui permiss�o para executar o programa de implanta��o.*/
   IF VALID-HANDLE(hProgPersist) THEN DO:
       WAIT-FOR CLOSE OF hProgPersist.
   END.
   /*Fim altera��o 11/09/2007*/

   /*Fim altera��o 22/12/2006*/
    assign bt-implantar:sensitive in frame {&frame-name} = yes.
   
   
   &IF  "{3}" <> "" &THEN
   if valid-handle({3}) then do:
      RUN dispatch IN {3} ('open-query':U). 
      RUN pi-reposiciona-query IN {3}
               (r-registro-atual).
   end.
   &ENDIF
   
   &IF  "{4}" <> "" &THEN
   if valid-handle({4}) then do:
     RUN dispatch IN {4} ('open-query':U). 
     RUN pi-reposiciona-query IN {4}
                  (r-registro-atual).
   end.
   &ENDIF
   
   &IF  "{5}" <> "" &THEN
   if valid-handle({5}) then do:
   RUN dispatch IN {5} ('open-query':U). 
     RUN pi-reposiciona-query IN {5}
                  (r-registro-atual).
   end.
   &ENDIF
   
   &IF  "{6}" <> "" &THEN   
   if valid-handle({6}) then do:
     RUN dispatch IN {6} ('open-query':U). 
     RUN pi-reposiciona-query IN {6}
                  (r-registro-atual).
   end.
   &ENDIF

   &IF  "{7}" <> "" &THEN   
   if valid-handle({7}) then do:
     RUN dispatch IN {7} ('open-query':U). 
     RUN pi-reposiciona-query IN {7}
                  (r-registro-atual).
   end.
   &ENDIF
   
   &IF  "{2}" <> "" &THEN   
   if valid-handle({2}) then do:
     RUN dispatch IN {2} ('open-query':U). 
     RUN pi-reposiciona-query IN {2}
                  ( r-registro-atual).
   end.
   &ENDIF
    /*Altera��o 22/12/2006 - tech1007 FO 1433972 - Altera��o para executar os programas de implanta��o de forma persistente*/
   IF VALID-HANDLE(hProgPersist) THEN DO:
       DELETE PROCEDURE hProgPersist NO-ERROR.
   END.
   /*Fim Altera��o 22/12/2006*/
/* include/i-implan.i */   
   

