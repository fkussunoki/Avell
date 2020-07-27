/****************************************************************************
**
**  I-RPCAB.I - Form do Cabe‡alho PadrÆo e Rodap‚ (ex-CD9500.F)
**                              
** {&STREAM} - indica o nome da stream (opcional)
****************************************************************************/

&IF "{&LANGUAGE-CODE}" = "ING" &THEN 
    &IF  "{&STREAM}" = "" &THEN
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(10') c-titulo-relat format 'x(30)' at 29
            "Page:" at 71 page-number  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Page:" at 71 page-number  at 76 format ">>>>9" skip
            "Period:" i-numper-x at 09 "-"
            da-iniper-x at 14 "to" da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Page:" at 71 page-number({&STREAM})  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Page:" at 71 page-number({&STREAM})  at 76 format ">>>>9" skip
            "Period:" i-numper-x at 10 "-"
            da-iniper-x at 14 "to" da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ELSEIF "{&LANGUAGE-CODE}" = "ESP" &THEN
    &IF  "{&STREAM}" = "" &THEN
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "P gina:" at 121 page-number  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "P gina:" at 121 page-number  at 76 format ">>>>9" skip
            "Periodo:" i-numper-x at 10 "-"
            da-iniper-x at 15 "hasta" da-fimper-x
            fill("-", 70) format "x(68)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "P gina:" at 71 page-number({&STREAM})  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "P gina:" at 70 page-number({&STREAM})  at 76 format ">>>>9" skip
            "Periodo:" i-numper-x at 10 "-"
            da-iniper-x at 15 "hasta" da-fimper-x
            fill("-", 70) format "x(68)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ELSE
    &IF "{&STREAM}" = "" &THEN
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Folha:" at 70 page-number  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Folha:" at 70 page-number  at 76 format ">>>>9" skip
            "Periodo:" i-numper-x at 10 "-"
            da-iniper-x at 15 "a" da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Folha:" at 70 page-number({&STREAM})  at 76 format ">>>>9" skip
            fill("-", 60) format "x(58)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 80) format "x(80)" skip
            c-empresa FORMAT 'x(12)' c-titulo-relat format 'x(30)' at 29
            "Folha:" at 70 page-number({&STREAM})  at 76 format ">>>>9" skip
            "Periodo:" i-numper-x at 10 "-"
            da-iniper-x at 15 "a" da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS") skip(1)
            with stream-io width 80 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ENDIF

c-rodape = "DATASUL - " + c-sistema + " - " + c-prg-obj + " - V:" + c-prg-vrs.
c-rodape = fill("-", 80 - length(c-rodape)) + c-rodape.

form header
    c-rodape format "x(80)"
    with stream-io width 80 no-labels no-box page-bottom frame f-rodape.

/* I-RPCAB.I */

