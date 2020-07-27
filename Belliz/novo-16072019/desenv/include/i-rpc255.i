/****************************************************************************
**
**  I-RPC255.I - Form do Cabe‡alho PadrÆo e Rodap‚ (padrÆo 255 colunas)
**                              
** {&STREAM} - indica o nome da stream (opcional)
****************************************************************************/

&IF "{&LANGUAGE-CODE}":U = "ING":U &THEN
    &IF "{&STREAM}":U = "":U &THEN
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Page:":U at 246 page-number at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Page:":U at 246 page-number  at 251 format ">>>>9":U skip
            "Period:":U i-numper-x at 09 "-":U
            da-iniper-x at 14 "to":U da-fimper-x
            fill("-":U, 197) format "X(194)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ELSE
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Page:":U at 246 page-number({&STREAM}) at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Page:":U at 246 page-number({&STREAM}) at 251 format ">>>>9":U skip
            "Period:":U i-numper-x at 09 "-":U
            da-iniper-x at 14 "to":U da-fimper-x
            fill("-":U, 197) format "X(194)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ENDIF
&ELSEIF "{&LANGUAGE-CODE}":U = "ESP" &THEN
    &IF "{&STREAM}":U = "" &THEN
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "P gina:":U at 244 page-number  at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "P gina:":U at 244 page-number  at 251 format ">>>>9":U skip
            "Periodo:":U i-numper-x at 10 "-":U
            da-iniper-x at 15 "hasta":U da-fimper-x
            fill("-":U, 194) format "X(192)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ELSE
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "P gina:":U at 244 page-number({&STREAM}) at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "P gina:":U at 244 page-number({&STREAM}) at 251 format ">>>>9":U skip
            "Periodo:":U i-numper-x at 10 "-":U
            da-iniper-x at 15 "hasta":U da-fimper-x
            fill("-":U, 194) format "X(192)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ENDIF
&ELSE 
    &IF "{&STREAM}":U = "" &THEN
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Folha:":U at 245 page-number  at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Folha:":U at 245 page-number  at 251 format ">>>>9":U skip
            "Periodo:":U i-numper-x at 10 "-":U
            da-iniper-x at 15 "a":U da-fimper-x
            fill("-":U, 197) format "X(194)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ELSE
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Folha:":U at 245 page-number({&STREAM}) at 251 format ">>>>9":U skip
            fill("-":U, 235) format "X(233)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabec-255.
        
        form header
            fill("-":U, 255) format "X(255)":U skip
            c-empresa c-titulo-relat at 97
            "Folha:":U at 245 page-number({&STREAM}) at 251 format ">>>>9":U skip
            "Periodo:":U i-numper-x at 10 "-":U
            da-iniper-x at 15 "a":U da-fimper-x
            fill("-":U, 197) format "X(194)":U today format "99/99/9999":U
            "-":U string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 255 no-labels no-box page-top frame f-cabper-255.
    &ENDIF
&ENDIF

&IF "{&STREAM}":U <> "":U &THEN
&GLOBAL-DEFINE STREAM_ONLY {&STREAM}
&ENDIF
    
c-rodape = "DATASUL - ":U + c-sistema + " - ":U + c-prg-obj + " - V:":U + c-prg-vrs.
c-rodape = fill("-":U, 255 - length(c-rodape)) + c-rodape.

form header
    c-rodape format "X(255)":U
    with stream-io width 255 no-labels no-box page-bottom frame f-rodape-255.

/*--- include/i-rpc255.i ---*/

