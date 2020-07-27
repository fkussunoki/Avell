DEFINE TEMP-TABLE tt-itens
    FIELD it-codigo   AS char
    FIELD descricao   AS char
    FIELD ct-codigo   AS char
    FIELD finalidade  AS char.

INPUT FROM c:\desenv\ct-itens.txt.

OUTPUT TO c:\desenv\no-cadastro.txt.

REPEAT:
    CREATE tt-itens.
    IMPORT DELIMITER ";" tt-itens.
END.

DEF BUFFER bITEM FOR item.
DEF VAR h-prog AS HANDLE.


RUN utp/ut-acomp.p PERSISTENT SET h-prog.

RUN pi-inicializar IN h-prog(INPUT 'a').
FOR EACH tt-itens:

    RUN pi-acompanhar IN h-prog(INPUT tt-item.it-codigo).

    FIND FIRST mgcad.item NO-LOCK WHERE item.it-codigo = tt-itens.it-codigo NO-ERROR.


    IF avail item THEN DO:
        
        ASSIGN item.it-codigo    = tt-itens.it-codigo
               item.descricao-1  = tt-itens.descricao
               item.ct-codigo    = tt-itens.ct-codigo
               item.narrativa    = tt-itens.finalidade.

    END.

    ELSE DO:

        FIND LAST bITEM WHERE bITEM.ge-codigo = 99 NO-ERROR.

            CREATE item.
            ASSIGN item.it-codigo = tt-itens.it-codigo
                   item.descricao-1 = tt-itens.descricao
                   item.un           = bITEM.un
                   item.compr-fabric = bITEM.compr-fabric
                   item.ge-codigo    = bITEM.ge-codigo
                   item.fm-codigo    = bITEM.fm-codigo
                   item.data-implant = bITEM.data-implant
                   item.data-liberac = bITEM.data-liberac
                   item.deposito-pad  = bITEM.deposito-pad
                   item.cod-obsoleto  = bITEM.cod-obsoleto
                   item.class-fiscal  = bITEM.class-fiscal
                   item.baixa-estoq   = bITEM.baixa-estoq
                   item.nat-despesa   = bITEM.nat-despesa
                   item.ct-codigo     = tt-item.ct-codigo
                   item.narrativa     = tt-item.finalidade.


        


    END.

END.
