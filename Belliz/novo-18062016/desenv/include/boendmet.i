procedure endMethod:
    def input parameter cMethodName as char no-undo.
&IF DEFINED(EPC-ENABLED) <> 0 &THEN
    def var iSeqAux  as integer no-undo.
    
    if  c-nom-prog-dpc-mg97 <> ""
    or  c-nom-prog-appc-mg97 <> ""
    or  c-nom-prog-upc-mg97 <> "" then do:
        {include/i-epc200.i3 &POSITION=AFTER}  /* cria os par³metros padr„es na tt-epc */
    
         /* DPC */
        if  c-nom-prog-dpc-mg97  <> "" then do:
            run value( c-nom-prog-dpc-mg97  ) 
                     ( string("AFTER-":U + caps(cMethodName)), 
                       input-output table tt-epc ).
        end.                                     
        
         /* APPC */
        if  c-nom-prog-appc-mg97  <> "" then do:
            run value( c-nom-prog-appc-mg97  ) 
                     ( string("AFTER-":U + caps(cMethodName)), 
                       input-output table tt-epc ).
        end.                                     
        
         /* UPC */
        if  c-nom-prog-upc-mg97   <> "" then do:
            run value( c-nom-prog-upc-mg97  )
                     ( string("AFTER-":U + caps(cMethodName)), 
                       input-output table tt-epc ).        
        end.
        
        for each tt-epc:
            if  return-value = "NOK":U 
            and tt-epc.cod-parameter = "EPC-ERROR":U then do:
                assign iSeqAux = iSeqAux + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = iSeqAux
                       tt-bo-erro.cd-erro  = 17584
                       tt-bo-erro.mensagem = "EPC-ERROR: ":U + tt-epc.val-parameter.
            end.                
            delete tt-epc.
        end.
        
    end.
&ENDIF
    if lExistsCustomBO then do:
        run value(cCustomBOName) ("end":U, cMethodName, input-output table RowObject).
    end.
end procedure.
