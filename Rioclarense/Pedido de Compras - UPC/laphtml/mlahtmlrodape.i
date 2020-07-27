/********************************************************************************
** Copyright DATASUL S.A. 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE VARIABLE c-class-notif AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-informado   AS CHAR       NO-UNDO.
DEFINE VARIABLE i-cont-aprov  AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-checked     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-sequencia-substring AS INTEGER    NO-UNDO.
/*
/**  Login Integrado
**/
def var v_hdl_login_integr          as HANDLE  no-undo.
def var v_log_habilita_login_integr as LOGICAL no-undo.
{include/i_dbvers.i}
*/

FIND FIRST mla-tipo-doc-aprov 
     WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa    
       AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
       AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-LOCK NO-ERROR.

/* Altera‡Æo realizada para corre‡…o na PQU e Orsa-Suzano - NÆo retirar */
FOR EACH mla-doc-pend-aprov 
     WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
       AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
       AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
       AND mla-doc-pend-aprov.chave-doc    = c-chave  NO-LOCK: /* pendˆncia atual */
END.
/* Fim altera‡Æo */

FIND LAST mla-doc-pend-aprov 
     WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
       AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
       AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
       AND mla-doc-pend-aprov.chave-doc    = c-chave  
       AND mla-doc-pend-aprov.ind-situacao = 1
       AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pendˆncia atual */

ASSIGN tt-html.html-doc = tt-html.html-doc +           
'<input class="fill-in" type="hidden" name="hid_nr_trans"  value="' + string(mla-doc-pend-aprov.nr-trans) + '"> '.

ASSIGN tt-html.html-doc = tt-html.html-doc +           
'<input class="fill-in" type="hidden" name="hid_empresa"  value="' + string(mla-doc-pend-aprov.ep-codigo) + '"> '.

ASSIGN tt-html.html-doc = tt-html.html-doc +           
       '<table border=0 width=100%> ' +
       '  <tr> ' +
       '  <td align=center> ' +
       '   <table border=0> ' +
       '     <tr> ' +
       '      <th class=linhaform align=right>C&oacute;digo Rejei&ccedil;&atilde;o:</th> ' +
       '       <td align=left>' +
       '        <select name="w_cod_rejeicao" class="fill-in">'.

FOR EACH mla-rej-aprov NO-LOCK:
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<option value="' + STRING(mla-REJ-APROV.cod-rejeicao) + '">' + string(mla-REJ-APROV.cod-rejeicao) + '-' + mla-REJ-APROV.des-rejeicao + IF mla-REJ-APROV.LOG-1 AND mla-tipo-doc-aprov.log-2 THEN "(Re-an lise)</option>" ELSE "</option>".
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +           
       '        </select></td></tr>' +
       '      </td>    ' +
       '      </tr> ' +
       '      <tr> ' +
       '       <th class=linhaform align=right>Narrativa:</th> ' +
       '       <td valign="midlle" align=left><textarea class="fill-in" name="w_narrativa_usuar" rows="3" cols="40"></textarea> ' +
       '      </td></tr> ' +
       '      </tr>'.

/*
/**  LOGIN Integrado
**/
/* If  Not Valid-handle(v_hdl_login_integr) Then                                                   */
/*     Run btb/btapi910zb.p Persisten Set v_hdl_login_integr (Input 1).                            */
/* If  Valid-handle(v_hdl_login_integr) Then                                                       */
/*     Run pi_Login_Integr_Habilitado In v_hdl_login_integr (Output v_log_habilita_login_integr).  */


Run pi_Login_Integr_Habilitado (Output v_log_habilita_login_integr).

&IF "{&mguni_version}" > "2.06B" &THEN
  Find First usuar_mestre_ext Where usuar_mestre_ext.cod_usuario = p-cod-aprovador NO-LOCK NO-ERROR.
  IF  NOT v_log_habilita_login_integr OR NOT AVAIL usuar_mestre_ext THEN DO:
&ELSE
  Find First usuar-mestre-ext Where usuar-mestre-ext.cod-usuario = p-cod-aprovador NO-LOCK NO-ERROR.
  IF  NOT v_log_habilita_login_integr OR NOT AVAIL usuar-mestre-ext THEN DO:
&ENDIF

    /**  Login Senha **/
    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '       <th class=linhaform align=right>Senha EMS:</th>' +
           '       <td align=left>' +
           '        <input type="password" class="fill-in" name="w_senha_usuar" size="13" maxlength="12">' +
           '      </td></tr>'.
END.
*/
ASSIGN tt-html.html-doc = tt-html.html-doc +           
       '      <tr><td align=center colspan=2> '.

/**  EPC para inserir outro botÆo no HTML **/
for each tt-epc:
   delete tt-epc.
end.
create tt-epc.
assign tt-epc.cod-event     = "NovoBotao"
       tt-epc.cod-parameter = "Documento"
       tt-epc.val-parameter = string(mla-tipo-doc-aprov.cod-tip-doc). 

{include/i-epc201.i "NovoBotao"}

FIND FIRST tt-epc 
     WHERE tt-epc.cod-event     = "NovoBotao" 
       AND tt-epc.cod-parameter = "NovoBotao"
       AND tt-epc.val-parameter <> "" NO-ERROR.
IF AVAIL tt-epc THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +           
       '       <input type="submit" name="action" value="' + TRIM(tt-epc.val-parameter) + '" class="button">'.
/**  Fim EPC  **/

ASSIGN tt-html.html-doc = tt-html.html-doc +
       '       <input type="submit" name="action" value="Aprovar"  class="button">' +
       '       <input type="submit" name="action" value="Rejeitar" class="button">' +
       '      </td></tr>      ' +
       
       '    </table>       ' + 
       '  </td>' +
       '  <td align=center>'.


IF AVAIL mla-tipo-doc-aprov AND 
   (SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "Y" OR 
    SUBSTRING(mla-tipo-doc-aprov.char-1,2,1) = "Y") THEN DO:

    ASSIGN tt-html.html-doc = tt-html.html-doc +           
       '<table class="tableForm" align="center" width="100%">' +
       '   <tr>' +
       '      <td align="center"  class="ColumnLabel" colspan=2>Notificar os Seguites Usu rios</td>' +
       '   </tr>' +
       '   <tr>' +
       '      <th align="center"  class="ColumnLabel">Aprova&ccedil;&atilde;o</th>' +
       '      <th align="center"  class="ColumnLabel">Rejei&ccedil;&atilde;o</th>' +
       '   </tr>' +
       '   <tr >'.
    
     {laphtml/mlahtmlrodape.i2 "aprova"}
    
     FIND FIRST mla-doc-pend-aprov 
          WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
            AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
            AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
            AND mla-doc-pend-aprov.chave-doc    = c-chave  
            AND mla-doc-pend-aprov.ind-situacao = 1
            AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pendˆncia atual */
    
     {laphtml/mlahtmlrodape.i2 "rejeita"}
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +           
                               '</tr>' +
                               '</table>'.
    
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '  </td>' +
           '  </tr>' + 
           '</table>'.

END.
    ASSIGN tt-html.html-doc = tt-html.html-doc +  
           '  </td>' +
           '  </tr>' +
           '     <tr> ' +
           '      <td align=center>'.

ASSIGN i-cont-aprov = 0.

IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.log-1 = YES THEN DO:

    ASSIGN tt-html.html-doc = tt-html.html-doc +  
           '   <center> ' +
           '   <table border=0 width=80%> ' +
           '     <tr> ' +
           '      <td class=linhaform align=left>' +
           '        <fieldset><legend><b>Aprova‡äes</b></legend>' + 
           '   <table border=0>'.
           
           
           FOR EACH  mla-doc-pend-aprov 
               WHERE mla-doc-pend-aprov.ep-codigo    = i-empresa
                 AND mla-doc-pend-aprov.cod-estabel  = c-cod-estabel
                 AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
                 AND mla-doc-pend-aprov.chave-doc    = c-chave  
                 AND mla-doc-pend-aprov.ind-situacao = 2
                 AND mla-doc-pend-aprov.historico    = NO NO-LOCK USE-INDEX pend-18 BY mla-doc-pend-aprov.nr-trans: 
               
               FIND mla-tipo-aprov WHERE mla-tipo-aprov.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK NO-ERROR. 
               

               ASSIGN i-cont-aprov = i-cont-aprov + 1.

               IF mla-doc-pend-aprov.cod-usuar-altern = "" THEN 
                   FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.
               ELSE
                   FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar-altern NO-LOCK NO-ERROR.
               

               ASSIGN tt-html.html-doc = tt-html.html-doc + 
                                         '<tr> ' +
                                         '  <td colspan=2 class=linhaform align=left>' +
                                         '----------- N¡vel ' + STRING(i-cont-aprov) + ' (' + mla-tipo-aprov.des-tip-aprov + ') ------------<br>' +
                                         '<b>Aprovado por: </b>' + usuar_mestre.cod_usuar + ' - ' + usuar_mestre.nom_usuario + '<br>' +
                                         '<b>Quando: </b>' + string(mla-doc-pend-aprov.dt-aprova,'99/99/9999') + ' as ' + substring(mla-doc-pend-aprov.char-1,1,8) +
                                         '  </td> ' +
                                         '</tr> ' +
                                         '<tr> ' +
                                         '  <td class=linhaform align=left valign=top>' +
                                         '      <b>Coment rio: </b>' + 
                                         '  </td>' +
                                         '  <td class=linhaform align=left>' + replace(mla-doc-pend-aprov.narrativa-apr,CHR(10),'<br>') +
                                         '  </td>' +
                                         '</tr>'. 

           END.

ASSIGN tt-html.html-doc = tt-html.html-doc +           
           '        </table>' +
           '        </fieldset>' +
           '     </td> ' +
           '     </tr>' +
           '   </table>'.
 
END.


/*
/*****************************************************************************
** Procedure.: pi_Login_Integr_Habilitado
** Fun»’o....: Retorna se a funcionalidade do Login Integrado estÿ habilitada
*****************************************************************************/
Procedure pi_Login_Integr_Habilitado:

    Def Output Param pLoginIntegrHabilit As Logical Initial No.

    &IF "{&mguni_version}" > "2.06B" &THEN
      Find First login_integr_so No-lock NO-ERROR.
      Assign pLoginIntegrHabilit = (Avail login_integr_so
                                    And login_integr_so.log_habtdo_login_integr).
    &ELSE
      Find First login-integr-so No-lock NO-ERROR.
      Assign pLoginIntegrHabilit = (Avail login-integr-so 
                                    And login-integr-so.log-habtdo-login-integr).
    &ENDIF.

End Procedure. /* --- pi_Login_Integr_Habilitado - */
*/
