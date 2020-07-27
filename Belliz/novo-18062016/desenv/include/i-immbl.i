/*****************************************************************
**
**  I-RPMBL.I - Main Block do Template de Importa»’o
**  {1} =  Par³metro Opcional, indica a imagem que deve ser aplicado
**         o "mouse-select-click" 
*******************************************************************/

apply "value-changed":U to rs-destino        in frame f-pg-log.
&IF "{1}" <> "" &THEN
    apply "mouse-select-click":U to {1} in frame f-import.
&ELSE
    apply "mouse-select-click":U to im-pg-sel in frame f-import.
&ENDIF
/* i-immbl */
