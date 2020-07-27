    /*                          
   Nome   : F-Valid.i         -   J. Carlos  -  21/Fev/97
   Fun»’o : Executa as valida»„es do dicionÿrio definidas para os campos da tela  
   
   Nota   : 
*/
DEFINE VAR c_Page      AS CHAR NO-UNDO. 
DEFINE VAR h_Container AS HANDLE NO-UNDO.
IF NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
    DO :            
      RUN get-attribute ("W-Page":U).
      IF RETURN-VALUE <> "" AND RETURN-VALUE <> "0" THEN
         DO :                           
           ASSIGN c_Page = RETURN-VALUE.
           RUN get-attribute ("W-Container-Source":U).
           ASSIGN h_Container = WIDGET-HANDLE(RETURN-VALUE).
            /* RUN Pagina-Corrente IN WIDGET-HANDLE(RETURN-VALUE).*/
           RUN get-attribute IN h_Container ("CURRENT-PAGE":U).
           IF c_Page <> RETURN-VALUE THEN
              DO :
                RUN select-page IN  h_Container (INT(c_Page)).
                IF NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
                      UNDO, RETURN "ADM-ERROR":U. 
             END.   
         END.   
      UNDO, RETURN "ADM-ERROR":U.
    END. 
