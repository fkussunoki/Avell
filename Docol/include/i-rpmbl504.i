/*****************************************************************
**
**  I-RPMBL.I - Main Block do Template de Relat¢rio
**  {1} =  Parƒmetro Opcional, indica a imagem que deve ser aplicado
**         o "mouse-select-click" 
*******************************************************************/

apply "value-changed" to rs-destino in frame f-pg-imp.
&IF "{1}" <> "" &THEN
    apply "mouse-select-click" to {1} in frame f-relat.
&ELSE
    apply "mouse-select-click" to im-pg-sel in frame f-relat.
&ENDIF

/* i-rpmbl */
