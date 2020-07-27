/***********************************************************************
**  UT9000.I - Defini‡Æo das vari veis de ambiente do Magnus 97
**  {1} = programa provido pelo Roundtable
**  {2} = versao   provido pelo Roundtable
************************************************************************/

assign {&WINDOW-NAME}:title = "{1}"
                              + " - " 
                              + caps("{2}") 
                              + " - " 
                              + "{3}".



&IF  DEFINED(SYSTEM-VARS) = 0 &THEN 

def var c-programa-mg97       as char format "x(08)" no-undo.
def var c-versao-mg97         as char format "x(08)" no-undo.
def var c-modulo-mg97         as char format "x(08)" no-undo.
def var c-titulo-prog-mg97    as char format "x(08)" no-undo.
def var i-num-topico-hlp-mg97 as integer no-undo.
def var c-nom-manual-hlp-mg97 as char format "x(06)" no-undo.


&ENDIF

&IF  '{1}' = ' ' or  '{1}' = '' 
 OR  '{2}' = ' ' or  '{2}' = '' 
 OR  '{1}' = '"' or  '{2}' = '"' &THEN 

    message 'LALA A chamada do include UT9000.I est  sem os parƒmetros necess rios,' skip
            'ou em local incorreto. Vocˆ deve editar o programa no UIB e ' skip
            'verificar a chamada que deve estar no formato: ' skip(1)
            '~{utp/ut9000.i "XX9999" "99.99.99"~}'
            view-as alert-box error.
    quit.

&ELSE    

    assign c-programa-mg97 = caps("{1}")
           c-versao-mg97   = "{2}".
    find prog_dtsul no-lock
        where prog_dtsul.cod_prog_dtsul = c-programa-mg97 no-error.
    if  avail prog_dtsul then do:
        assign c-titulo-prog-mg97    = prog_dtsul.des_prog_dtsul
               c-nom-prog-upc-mg97   = prog_dtsul.nom_prog_upc
               c-nom-prog-appc-mg97  = prog_dtsul.nom_prog_appc
               c-nom-prog-dpc-mg97   = prog_dtsul.nom_prog_dpc
               /*i-num-topico-hlp-mg97 = prog_dtsul.num_topico*/.
        
        find procedimento no-lock
            where procedimento.cod_proced = prog_dtsul.cod_proced no-error.
        if  avail procedimento then do:
            find modul_dtsul no-lock
                where modul_dtsul.cod_modul_dtsul = procedimento.cod_modul_dtsul no-error. 
            if  avail modul_dtsul then do:
                assign c-modulo-mg97         = caps(modul_dtsul.nom_modul_dtsul_menu)
                       c-nom-manual-hlp-mg97 = "dochlp~/" + string(modul_dtsul.num_manual_documen, "999999") + ".hlp".
            end.
        end.
        IF prog_dtsul.log_gera_log_exec = yes then do transaction:
           create log_exec_prog_dtsul.
           assign log_exec_prog_dtsul.cod_prog_dtsul           = c-programa-mg97
                  log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
                  log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
                  log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                  log_exec_prog_dtsul.dat_fim_exec_prog_dtsul  = today                                                    
                  log_exec_prog_dtsul.hra_fim_exec_prog_dtsul  = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":",""). 
           assign v_rec_log = recid(log_exec_prog_dtsul).
           release log_exec_prog_dtsul no-error.
        end.
    end.                                                      
    else do:
        assign c-titulo-prog-mg97    = caps(c-programa-mg97)
               c-nom-prog-upc-mg97   = ""
               c-nom-prog-appc-mg97  = ""
               i-num-topico-hlp-mg97 = 0
               c-nom-manual-hlp-mg97 = "dochlp~/000000.hlp".
    end.                 
     
    &IF  "{&WINDOW-NAME}" <> "" AND "{&WINDOW-NAME}" <> "CURRENT-WINDOW" &THEN 
         assign {&WINDOW-NAME}:title = c-titulo-prog-mg97  
                                     + " (" + c-versao-mg97 + ")".
    &ELSE
         assign frame {&FRAME-NAME}:title = c-titulo-prog-mg97  
                                     + " (" + c-versao-mg97 + ")".
    &ENDIF

    /* Verifica‡Æo da seguran‡a e login informado */
/*    {utp/ut-vfsec.i} */

    /* Inicio do log de execu‡Æo de programas */
/*    {include/i-logini.i}  */

&ENDIF 


/* ut9000.i */
