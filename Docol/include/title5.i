/*************************************************************************
**
** TITLE5.I - Include padrao para altera‡Æo de t¡tulo EMS5
** Data Cria‡Æo: 11/09/2009
** Criado por..: Medeiros
**
**************************************************************************/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    &IF "{&INCLUDE_LM}" = "TRUE" &THEN
   
        RUN btb/btb970aa.p PERSISTENT SET h_btb970aa.
        RUN pi-retorna-inf-modulo IN h_btb970aa (INPUT c-lm-modulo,
                                                 OUTPUT c_id_modulo_ls,
                                                 OUTPUT c_desc_modulo_ls).

        IF VALID-HANDLE(h_btb970aa) THEN
            DELETE PROCEDURE h_btb970aa.

        ASSIGN {2} {1}:title = "06.9." + c_id_modulo_ls + " - " + REPLACE(REPLACE({2} {1}:title,"(","- "),")","").

    &ELSE 
        IF INDEX(PROGRAM-NAME(1),"btb") > 0 OR
           INDEX(PROGRAM-NAME(1),"sec") > 0 OR
           INDEX(PROGRAM-NAME(1),"men") > 0 OR
           INDEX(PROGRAM-NAME(1),"utp") > 0 THEN
            ASSIGN {2} {1}:title = "06.9." + "FND" + " - " + REPLACE(REPLACE({2} {1}:title,"(","- "),")","").
        ELSE
            ASSIGN {2} {1}:title = "06.9." + "????" + " - " + REPLACE(REPLACE({2} {1}:title,"(","- "),")","").
    &ENDIF  
&ENDIF    


/* include/title5.i */
