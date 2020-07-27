/*------------------------------------------------------------------------------
  Purpose:     Valida se exite um processo agendado no servidor (RPW), que ir 
               gera um arquivo com o mesmo nome.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  INPUT FRAME f-pg-imp rs-destino = 2 THEN DO:

        FOR EACH ped_exec NO-LOCK
           WHERE ped_exec.cod_prog_dtsul = "{&programa}"
             AND ped_exec.ind_sit_ped    = "NÆo executado" :
              
            FIND FIRST ped_exec_param OF ped_exec NO-LOCK NO-ERROR.
            IF  NOT AVAIL ped_exec_param THEN NEXT.

            IF  ped_exec_param.cod_dwb_file = INPUT FRAME f-pg-imp c-arquivo THEN DO:
                RUN message2.p ("Nome do Arquivo encontrado em outro pedido,Deseja continuar?",
                                "Foi encontrado um pedido com o mesmo nome a ser criado." + chr(10) +
                                "Arquivo....: " + ped_exec_param.cod_dwb_file             + chr(10) +
                                "Usuario....: " + ped_exec.cod_usuar                      + chr(10) +
                                "Num Pedido.: " + STRING(ped_exec_param.num_ped_exec)).
                IF  RETURN-VALUE = 'yes' 
                    THEN LEAVE.
                    ELSE RETURN 'nok'.
            END.  
        END.    
    END.

