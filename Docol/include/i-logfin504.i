/*************************************************************************
**
** I-LOGFIN.I - Encerra o Log de Execu‡Æo
**
**************************************************************************/

/*run btb/btb918zb.p (input c-programa-mg97,
                    input-output rw-log-exec,
                    input no).*/

/* Transformacao Window */
&IF DEFINED(TransformacaoWindow) <> 0 &THEN
if session:window-system <> "TTY" then do:
    case i-template:
        when 9 or when 10 or when 20 or when 30 or when 31 then do: 
            assign h-pai:sensitive = yes.
            apply "ENTRY" to h-pai.
        end.
        when 13 then do:
            assign h-pai:sensitive = yes.
            apply "ENTRY" to h-pai.
            run pi-entry-atributos-chave.
        end.
    end case.
end.  
&ENDIF
/* Transformacao Window */
/* Elimina‡Æo de arquivos tempor rios */
/*&IF DEFINED(Relatorio) <> 0 AND "{&PGIMP}" <> "" &THEN
if i-template = 17 and avail tt-param then
  if tt-param.destino = 3 and search(tt-param.arquivo) <> ? then
     os-delete value(tt-param.arquivo). 
&ENDIF  
&IF DEFINED(ExpImp)    <> 0 AND "{&PGLOG}" <> "" &THEN
if i-template = 26 and avail tt-param then
  if tt-param.destino = 3 and search(tt-param.arq-destino) <> ? then
     os-delete value(tt-param.arq-destino). 
&ENDIF  */
/* Fim da elimina‡Æo de arquivos tempor rios */

/* i-logfin */

