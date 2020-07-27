/***************************************************************
**
** I-STR080.I - Value-changed no browse
** 
***************************************************************/ 

    if available( tt-str ) then do:
       assign v-row-temp-table = rowid( tt-str ).
       run pi-new-record-select( v-row-temp-table ).
    end.   
    
/* I-STR080.I */    
