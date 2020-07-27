/****************************************************************************
**
**  I-RPCB80.I - Form do Cabe»alho Padr’o e Rodap² (padr’o 80 colunas)
**                              
** {&STREAM} - indica o nome da stream (opcional)
****************************************************************************/
Define Variable vFolha  As Char Format "x(06)" No-undo.
Define Variable vPer80 As Char  Format "x(06)" No-undo.
Define Variable vTo80 As Char Format "x(02)" No-undo.

{utp/ut-liter.i Folha: *}
Assign vFolha = Return-value.

{utp/ut-liter.i Periodo: *}
Assign vPer80 = Return-value.

{utp/ut-liter.i a RPCAB}
Assign vTo80 = Return-value.

&IF "{&STREAM}" = "" &THEN
    form header
        fill("-", 80) format "x(80)" skip
        c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
        vFolha at 70 page-number  at 76 format ">>>>9" skip
        fill("-", 60) format "x(58)" today format "99/99/9999"
        "-" string(time, "HH:MM:SS") skip(1)
        with stream-io width 80 no-labels no-box page-top frame f-cabec-80.
    
    form header
        fill("-", 80) format "x(80)" skip
        c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
        vFolha at 70 page-number  at 76 format ">>>>9" skip
        vPer80 i-numper-x at 10 "-"
        da-iniper-x at 15 vTo80 da-fimper-x
        fill("-", 22) format "x(20)" today format "99/99/9999"
        "-" string(time, "HH:MM:SS":U) skip(1)
        with stream-io width 80 no-labels no-box page-top frame f-cabper-80.
&ELSE
    form header
        fill("-", 80) format "x(80)" skip
        c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
        vFolha at 70 page-number({&STREAM})  at 76 format ">>>>9" skip
        fill("-", 60) format "x(58)" today format "99/99/9999"
        "-" string(time, "HH:MM:SS":U) skip(1)
        with stream-io width 80 no-labels no-box page-top frame f-cabec-80.
    
    form header
        fill("-", 80) format "x(80)" skip
        c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
        vFolha at 70 page-number({&STREAM})  at 76 format ">>>>9" skip
        vPer80 i-numper-x at 10 "-"
        da-iniper-x at 15 vTo80 da-fimper-x
        fill("-", 22) format "x(20)" today format "99/99/9999"
        "-" string(time, "HH:MM:SS":U) skip(1)
        with stream-io width 80 no-labels no-box page-top frame f-cabper-80.
&ENDIF

&IF "{&STREAM}":U <> "":U &THEN
&GLOBAL-DEFINE STREAM_ONLY {&STREAM}
&ENDIF

c-rodape = "DATASUL - ":U + c-sistema + " - " + c-prg-obj + " - V:":U + c-prg-vrs.
c-rodape = fill("-", 80 - length(c-rodape)) + c-rodape.
form header
    c-rodape format "x(80)"
    with stream-io width 80 no-labels no-box page-bottom frame f-rodape-80.
/* I-RPCB80.I */
