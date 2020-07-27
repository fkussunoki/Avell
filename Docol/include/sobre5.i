&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    &IF "{&INCLUDE_LM}" = "TRUE" &THEN
        FIND FIRST param_extens_ems NO-LOCK
            WHERE param_extens_ems.cod_entid_param_ems = "License"
            AND   param_extens_ems.cod_chave_param_ems = "License"
            AND   param_extens_ems.cod_param_ems = "Segment" NO-ERROR.
        IF AVAIL param_extens_ems THEN
            run btb/btb901zb.p (v_nom_prog,
                                v_nom_prog_ext,
                                v_cod_release,
                                c-lm-modulo,
                                param_extens_ems.dsl_param_ems).
        ELSE
            run btb/btb901zb.p (v_nom_prog,
                                v_nom_prog_ext,
                                v_cod_release,
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
                run btb/btb901zb.p (v_nom_prog,
                                    v_nom_prog_ext,
                                    v_cod_release,
                                    "FND":U,
                                    param_extens_ems.dsl_param_ems).
            ELSE
                run btb/btb901zb.p (v_nom_prog,
                                    v_nom_prog_ext,
                                    v_cod_release,
                                    "FND":U,
                                    "??????????").
    
        END.
        ELSE DO:
            FIND FIRST param_extens_ems NO-LOCK
                WHERE param_extens_ems.cod_entid_param_ems = "License"
                AND   param_extens_ems.cod_chave_param_ems = "License"
                AND   param_extens_ems.cod_param_ems = "Segment" NO-ERROR.
            IF AVAIL param_extens_ems THEN
                run btb/btb901zb.p (v_nom_prog,
                                    v_nom_prog_ext,
                                    v_cod_release,
                                    "????",
                                    param_extens_ems.dsl_param_ems).
            ELSE
                run btb/btb901zb.p (v_nom_prog,
                                    v_nom_prog_ext,
                                    v_cod_release,
                                    "????",
                                    "??????????").
        END.
        
    &ENDIF
&ELSE
    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/.
&ENDIF



