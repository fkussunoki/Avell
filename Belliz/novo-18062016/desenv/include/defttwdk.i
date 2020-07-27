/*************************************************************************************
** defttwdk.i - programa criado para permitir que o foundation do webdesk não necessite de registro
** Jaime - 17 - 01 - 2008
***************************************************************************************/


{include/i_dbinst.i}

/*se não é o webdesk não executa nada */

&if "{&WEBDESK_dbinst}":U = "yes":U &then

def new global shared var i-num-ped-exec-rpw as int no-undo.
DEF NEW GLOBAL SHARED TEMP-TABLE control-licenc-usuar
    FIELD idi-connect AS integer
    FIELD cod-usuar AS character
    FIELD cod-produt-dtsul AS character
    FIELD char-1 AS character
    FIELD char-2 AS character
    FIELD dec-1 AS decimal
    FIELD dec-2 AS decimal
    FIELD int-1 AS integer
    FIELD int-2 AS integer
    FIELD log-1 AS logical
    FIELD log-2 AS logical
    FIELD data-1 AS date
    FIELD data-2 AS date
    INDEX cntrllcn-id IS UNIQUE idi-connect .


DEF NEW GLOBAL SHARED TEMP-TABLE control-licenc-usuar-integr
    FIELD idi-connect AS integer
    FIELD cod-usuar AS character
    FIELD cod-produt-dtsul AS character
    FIELD cod-livre-1 AS character
    FIELD cod-livre-2 AS character
    FIELD log-livre-1 AS logical
    FIELD log-livre-2 AS logical
    FIELD num-livre-1 AS integer
    FIELD num-livre-2 AS integer
    FIELD val-livre-1 AS decimal
    FIELD val-livre-2 AS decimal
    FIELD dat-livre-1 AS date
    FIELD dat-livre-2 AS date
    INDEX cntrllcaint-id IS UNIQUE idi-connect .


DEF NEW GLOBAL SHARED TEMP-TABLE param-global
    FIELD grupo AS character
    FIELD contab-estat AS integer
    &IF '{&emsfnd_version}' = '1.00' &THEN 
    FIELD empresa-prin AS integer
    &ELSE
    FIELD empresa-prin AS CHARACTER
    &ENDIF
    FIELD modulo-ct AS logical
    FIELD modulo-ap AS logical
    FIELD modulo-cr AS logical
    FIELD modulo-pt AS logical
    FIELD modulo-cb AS logical
    FIELD modulo-en AS logical
    FIELD modulo-cc AS logical
    FIELD modulo-ce AS logical
    FIELD modulo-cp AS logical
    FIELD modulo-pl AS logical
    FIELD modulo-of AS logical
    FIELD modulo-ft AS logical
    FIELD modulo-mi AS logical
    FIELD modulo-wi AS logical
    FIELD modulo-fp AS logical
    FIELD modulo-cs AS logical
    FIELD modulo-pd AS logical
    FIELD dt-ult-verif AS date
    FIELD periodo-veri AS integer
    FIELD modulo-pm AS logical
    FIELD modulo-ge AS logical
    FIELD modulo-ca AS logical
    FIELD ind-venc-fer AS integer
    FIELD ind-venc-sab AS integer
    FIELD ind-venc-dom AS integer
    FIELD exp-fornec AS logical
    FIELD exp-cliente AS logical
    FIELD exp-rep AS logical
    FIELD exp-item AS logical
    FIELD exp-cond-pag AS logical
    FIELD exp-portador AS logical
    FIELD exp-cep AS logical
    FIELD modulo-mp AS logical
    FIELD ctladm AS character
    FIELD ctlind AS character
    FIELD ctlcom AS character
    FIELD ctlfol AS character
    FIELD ctlext1 AS character
    FIELD ctlext2 AS character
    FIELD ctlext3 AS character
    FIELD modulo-cq AS logical
    FIELD modulo-fc AS logical
    FIELD bloqueio-cgc AS integer
    FIELD modulo-ex AS logical
    FIELD modulo-ed AS logical
    FIELD tp-estr-banco AS integer
    FIELD modulo-bh AS logical
    FIELD modulo-pc AS logical
    FIELD modulo-re AS logical
    FIELD modulo-pv AS logical
    FIELD modulo-co AS logical
    FIELD modulo-cv AS logical
    FIELD modulo-ch AS logical
    FIELD modulo-01 AS logical
    FIELD modulo-pi AS logical
    FIELD modulo-in AS logical
    FIELD modulo-cl AS logical
    FIELD modulo-05 AS logical
    FIELD modulo-06 AS logical
    FIELD modulo-07 AS logical
    FIELD modulo-08 AS logical
    FIELD modulo-09 AS logical
    FIELD modulo-10 AS logical
    FIELD modulo-crp AS logical
    FIELD mod-conf AS integer
    FIELD cod-decex AS integer
    FIELD formato-cep AS character
    FIELD formato-conta-contabil AS character
    FIELD formato-id-federal AS character
    FIELD formato-id-estadual AS character
    FIELD id-federal-obrigatorio AS logical
    FIELD id-estadual-obrigatorio AS logical
    FIELD formato-id-pessoal AS character
    FIELD modulo-pe AS logical
    FIELD modulo-fr AS logical
    FIELD modulo-bs AS logical
    FIELD modulo-dp AS logical
    FIELD modulo-ae AS logical
    FIELD consiste-sim AS logical
    FIELD gera-narrat AS logical
    FIELD gera-texto AS logical
    FIELD tipo-texto AS character
    FIELD cod-catal-img-it AS character
    FIELD cod-catal-img-eq AS character
    FIELD cod-catal-video-op AS character
    FIELD char-1 AS character
    FIELD char-2 AS character
    FIELD dec-1 AS decimal
    FIELD dec-2 AS decimal
    FIELD int-1 AS integer
    FIELD int-2 AS integer
    FIELD log-1 AS logical
    FIELD log-2 AS logical
    FIELD data-1 AS date
    FIELD data-2 AS date
    FIELD cod-catal-img-banco AS character
    FIELD aprov-elet-req AS logical
    FIELD Nivel-apr-requis AS integer
    FIELD nivel-apr-solic AS integer
    FIELD nivel-apr-manut AS integer
    FIELD cod-catal-imag-emp AS character
    FIELD serv-mail AS character
    FIELD porta-mail AS integer
    FIELD modulo-cn AS logical
    FIELD modulo-sws AS logical
    FIELD cod-catal-docto-anexo AS character
    FIELD modulo-ds AS logical
    FIELD modulo-rs AS logical
    FIELD modulo-mt AS logical
    FIELD modulo-st AS logical
    FIELD modulo-at AS logical
    FIELD modulo-cg AS logical
    FIELD label-cgc AS character
    FIELD label-insc-est AS character
    FIELD check-sum AS character
    FIELD sc-format AS character
    FIELD ct-format AS character
    FIELD modulo-im AS logical
    FIELD modulo-tf AS logical
    FIELD nome-dominio-ext AS character
    FIELD ind-cons-conta AS integer
    FIELD des-app-url AS character
    FIELD cod-servid-exec-web AS character
    FIELD modulo-rac AS logical
    FIELD modulo-mec AS logical
    FIELD formato-nr-nota AS character
    FIELD modulo-eb AS logical
    FIELD modulo-po AS logical
    FIELD modulo-per-ppm AS logical
    FIELD modulo-vc AS logical
    FIELD log-business AS logical
    FIELD log-datasulnet AS logical
    FIELD log-modul-calib AS logical
    FIELD log-integr-crm AS logical
    FIELD log-modul-zfm AS logical
    FIELD log-modul-draw AS logical
    FIELD log-req-autom-recebto AS logical
    FIELD idi-aviso-recebto AS integer
    FIELD log-modul-eq AS logical
    FIELD ind-int-agro AS logical
    FIELD log-modul-predit AS logical
    FIELD log-modul-cm AS logical
    FIELD modul-dbr AS logical
    FIELD modul-bmg AS logical
    FIELD modul-mgg AS logical
    INDEX codigo IS UNIQUE grupo .


DEF TEMP-TABLE cfgadm
    FIELD banco AS character
    FIELD controle AS integer
    FIELD max-usuarios AS integer
    FIELD classe AS character
    FIELD sis-op AS character
    FIELD tipo-so AS character
    FIELD cpu AS character
    FIELD validacao AS character
    FIELD extra AS character
    FIELD dt-valida AS DATE EXTENT 3
    FIELD char-1 AS character
    FIELD char-2 AS character
    FIELD dec-1 AS decimal
    FIELD dec-2 AS decimal
    FIELD int-1 AS integer
    FIELD int-2 AS integer
    FIELD log-1 AS logical
    FIELD log-2 AS logical
    FIELD data-1 AS date
    FIELD data-2 AS date
    FIELD check-sum AS character
    FIELD log-consolidado AS logical
    FIELD nom_razao_social AS character
    FIELD des_serie_datasul AS character
    FIELD dat_acesso_inicial AS date
    FIELD dec_acesso_mau AS decimal
    FIELD ind_produto AS integer
    FIELD num_serie_progress AS integer
    INDEX codigo IS UNIQUE banco .

IF CONNECTED("MGADM") OR CONNECTED("MGIND") THEN DO:
    
    IF i-num-ped-exec-rpw = 0 THEN DO:
        run utp/ut-msgs.p ( INPUT 'show':U,
                            INPUT 18218,
                            INPUT 'Webdesk':U).
        
    End.
    Else DO:
        run utp/ut-msgs.p ( input 'help':U,
                            input 18218,
                            input 'Webdesk':U).

        PUT UNFORMATTED "****** ":U RETURN-VALUE SKIP.

    END.
    
    QUIT.

END.

&ENDIF
