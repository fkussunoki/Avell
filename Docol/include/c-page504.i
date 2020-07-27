/*
    Nome :  C-PAGE.i       J.Carlos - 21/Fev/97
    Fun‡Æo : Guardar a pagina e o container-source da VIEWER.
*/                                                           

   def var c_Aux-var as char no-undo.
   RUN get-link-handle IN adm-broker-hdl504 (INPUT  THIS-PROCEDURE,
                                          INPUT  "CONTAINER-SOURCE",
                                          OUTPUT c_Aux-var).    
   RUN set-attribute-list ("W-Container-Source = " + string(c_Aux-var)).                                         

   RUN What-is-the-Page IN adm-broker-hdl504 (INPUT THIS-PROCEDURE).
   RUN set-attribute-list ("W-Page = " + RETURN-VALUE). 

