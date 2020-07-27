
    
/* include de controle de vers„o */
{include/i-prgvrs.i espfas001 1.00.00.003}
/* definiå„o das temp-tables para recebimento de par?metros */



    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)"
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)"
        field modelo-rtf       as char format "x(35)"
        field l-habilitaRtf    as LOG
        FIELD ttv-estab-ini    AS CHAR
        FIELD ttv-estab-fim    AS CHAR
        FIELD ttv-dt-ini       AS DATE
        FIELD ttv-dt-fim       AS DATE
        FIELD ttv-rs           AS INTEGER.




def temp-table tt-raw-digita
    	field raw-digita	as raw.
/* recebimento de par?metros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.
create tt-param.
RAW-TRANSFER raw-param to tt-param.




FIND FIRST tt-param NO-ERROR.

CASE tt-param.ttv-rs:

    WHEN 1 THEN
        RUN esp/esof0001arp.p(INPUT TABLE tt-param).
    OTHERWISE
        RUN esp/esof0001brp.p(INPUT TABLE tt-param).

END CASE.
