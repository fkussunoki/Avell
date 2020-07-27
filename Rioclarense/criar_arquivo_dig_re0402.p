DEFINE TEMP-TABLE tt-docto
    FIELD nro-docto AS char.

DEFINE TEMP-TABLE tt-docum
    FIELD serie-docto AS char
    FIELD nro-docto   AS char
    FIELD cod-emitente AS INTEGER
    FIELD nat-oper    AS char.


INPUT FROM c:\temp\docto_julho.txt.

REPEAT:
    CREATE tt-docto.
    IMPORT tt-docto.

END.

FOR EACH tt-docto:

    ASSIGN tt-docto.nro-docto = fill("0", 7 - LENGTH(tt-docto.nro-docto)) + tt-docto.nro-docto.


END.


FOR EACH tt-docto:

    FOR EACH docum-est NO-LOCK WHERE docum-est.nro-docto = tt-docto.nro-docto
                               AND   docum-est.dt-trans >= 07/01/2019
                               AND   docum-est.dt-trans <= 07/31/2019:

        CREATE tt-docum.
        ASSIGN tt-docum.serie-docto =     docum-est.serie-docto  
               tt-docum.nro-docto   =     docum-est.nro-docto    
               tt-docum.cod-emitente =    docum-est.cod-emitente 
               tt-docum.nat-oper     =    docum-est.nat-operacao.


    END.

END.

OUTPUT TO c:\desenv\julho.dig.

FOR EACH tt-docum:

    EXPORT tt-docum.
END.
