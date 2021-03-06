/*****************************************************************************
**
**  I-RPVAR.I - Variaveis para Impress�o do Cabecalho Padr�o (ex-CD9500.I)
**
*****************************************************************************/

define var c-empresa       as character format "x(40)"      no-undo.
define var c-titulo-relat  as character format "x(50)"      no-undo.
define var c-sistema       as character format "x(25)"      no-undo.
define var i-numper-x      as integer   format "ZZ"         no-undo.
define var da-iniper-x     as date      format "99/99/9999" no-undo.
define var da-fimper-x     as date      format "99/99/9999" no-undo.
define var c-rodape        as character                     no-undo.
define var v_num_count     as integer                       no-undo.

define var c-arq-control   as character                     no-undo.
define var i-page-size-rel as integer                       no-undo.

define var c-programa      as character format "x(08)"      no-undo.
define var c-versao        as character format "x(04)"      no-undo.
define var c-revisao       as character format "999"        no-undo.

define var c-impressora   as character                      no-undo.
define var c-layout       as character                      no-undo.

define buffer b_ped_exec_style for ped_exec.
define buffer b_servid_exec_style for servid_exec.

&IF "{&SHARED}" = "YES" &THEN
    define shared stream str-rp.
&ELSE
    define new shared stream str-rp.
&ENDIF

{include/i-lgcode.i}

/* i-rpvar.i */
