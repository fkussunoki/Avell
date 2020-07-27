/*************************************************************************
**
** SOBRE.I - Include padr’o para chamada do Sobre
** Data Cria»’o: 22/07/97
** Criado por..: Fabiano
**
**************************************************************************/

&IF DEFINED(SYSTEM-VARS) <> 0 &THEN
    def var c-nom-prog-ext     as char no-undo.
    def var c-nom-prog-ext-aux as char no-undo.
    
    assign c-nom-prog-ext = program-name(1).
    if c-nom-prog-ext begins "USER-INTERFACE-TRIGGER":U then
        assign c-nom-prog-ext = substr(c-nom-prog-ext,24)
               file-info:file-name = c-nom-prog-ext
               c-nom-prog-ext-aux = file-info:full-pathname.
    &IF "{&mguni_version}" >= "2.07A" &THEN
        &IF "{&INCLUDE_LM}" = "TRUE" &THEN    
            FIND FIRST param_extens_ems NO-LOCK
                WHERE param_extens_ems.cod_entid_param_ems = "License"
                AND   param_extens_ems.cod_chave_param_ems = "License"
                AND   param_extens_ems.cod_param_ems = "Segment" NO-ERROR.
            IF AVAIL param_extens_ems THEN
                run btb/btb901zb.p (c-programa-mg97,
                                    c-nom-prog-ext-aux,
                                    c-versao-mg97,
                                    c-lm-modulo,
                                    param_extens_ems.dsl_param_ems).
            ELSE
                run btb/btb901zb.p (c-programa-mg97,
                                    c-nom-prog-ext-aux,
                                    c-versao-mg97,
                                    c-lm-modulo,
                                    "??????????").
    
        &ELSE
            IF INDEX(PROGRAM-NAME(1),"btb") > 0 OR
               INDEX(PROGRAM-NAME(1),"sec") > 0 OR
               INDEX(PROGRAM-NAME(1),"men") > 0 OR
               INDEX(PROGRAM-NAME(1),"utp") > 0 THEN DO:
                FIND FIRST param_extens_ems NO-LOCK
                    WHERE param_extens_ems.cod_entid_param_ems = "License"
                    AND   param_extens_ems.cod_chave_param_ems = "License"
                    AND   param_extens_ems.cod_param_ems = "Segment" NO-ERROR.
                IF AVAIL param_extens_ems THEN
                    run btb/btb901zb.p (c-programa-mg97,
                                        c-nom-prog-ext-aux,
                                        c-versao-mg97,
                                        "FND":U,
                                        param_extens_ems.dsl_param_ems).
                ELSE
                    run btb/btb901zb.p (c-programa-mg97,
                                        c-nom-prog-ext-aux,
                                        c-versao-mg97,
                                        "FND":U,
                                        "??????????").
            END.
            ELSE DO:
                FIND FIRST param_extens_ems NO-LOCK
                    WHERE param_extens_ems.cod_entid_param_ems = "License"
                    AND   param_extens_ems.cod_chave_param_ems = "License"
                    AND   param_extens_ems.cod_param_ems = "Segment" NO-ERROR.
                IF AVAIL param_extens_ems THEN
                    run btb/btb901zb.p (c-programa-mg97,
                                        c-nom-prog-ext-aux,
                                        c-versao-mg97,
                                        "????",
                                        param_extens_ems.dsl_param_ems).
                ELSE
                    run btb/btb901zb.p (c-programa-mg97,
                                        c-nom-prog-ext-aux,
                                        c-versao-mg97,
                                        "????",
                                        "??????????").
            END.
            
        &ENDIF
    &ELSE
            run btb/btb901zb.p (c-programa-mg97,
                                c-nom-prog-ext-aux,
                                c-versao-mg97).    
    
    &ENDIF    
&ENDIF
/* include/sobre.i */
