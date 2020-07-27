/***************************************************************
**
** I-STR090.I - Definiá∆o da temp-table
** 
***************************************************************/ 

    def temp-table tt-str
    field ttv-num-level         as integer   format ">>>>,>>9"
    field ttv-des-structure     as character format "x(70)" label "Estrutura" column-label "Estrutura"
    field ttv-row-structure     as rowid     
    field ttv-num-seq           as integer   format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv-log-child         as logical   format "Sim/N∆o" initial yes
    field ttv-log-expand        as logical   format "Sim/N∆o" initial yes
    {&other-fields}
    index tt-id                            is primary unique
          ttv-num-seq                      ascending
    index tt-id-descending                               
          ttv-num-seq                      descending    
    index tt-rowid-structure                           
          ttv-row-structure                ascending      
          {&other-index} .
    

    
/* I-STR090.I */    
