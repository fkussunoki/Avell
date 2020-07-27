def temp-table tt-digita
    field it-codigo     like necessidade-oc.it-codigo
    field cod-estabel   like necessidade-oc.cod-estabel    
    field c-geracao     as char     
    field data-geracao  like necessidade-oc.data-geracao
    field data-entrega  like necessidade-oc.data-entrega
    field qt-ordem      like necessidade-oc.qt-ordem    
    field qt-orig       like necessidade-oc.qt-orig
    field qt-pendente   like necessidade-oc.qt-pendente
    field estoque-dispo like necessidade-oc.estoque-dispo    
    field marca         as char format "x(01)" label ""    
    field numero-ordem  like ordem-compra.numero-ordem
    field rw-nec        as rowid
    index codigo marca
                 cod-estabel
                 it-codigo
                 data-geracao.

def temp-table tt-param
    field destino        as integer
    field arquivo        as char
    field usuario        as char
    field data-exec      as date
    field hora-exec      as integer
    field classifica     as integer
    field ge-ini         as integer
    field ge-fim         as integer
    field familia-ini    as char
    field familia-fim    as char
    field item-ini       as char
    field item-fim       as char
    field estabelec-ini  as char
    field estabelec-fim  as char
    field data-ini       as date
    field data-fim       as date
    field pto-enc        as logical
    field periodico      as logical
    field l-multip       like estabelec.usa-mensal
    field l-agrupa       like estabelec.usa-mensal
    field l-split        like estabelec.usa-mensal
    field l-prazo-contr  like estabelec.usa-mensal
    field c-classe       as char format "x(40)"
    field c-destino      as char
    field i-icms         as int 
    field c-requisitante like ordem-compra.requisitante
    field l-imp-param    as log
    field l-narrativa    as log.

def temp-table tt-orfaos no-undo like tt-digita.
