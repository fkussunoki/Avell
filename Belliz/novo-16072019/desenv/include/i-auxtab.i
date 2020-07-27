/* ---------------------------------------------------------------------------------------------------
   Autor      : Jos‚ Carlos - PGS
   Data       : 19/Mar/97
   Objetivo   : Include para definir‡Æo de pre-processors necess rios para as Viewers que nÆo possuem 
                campos de tabela MAS desejam tem acessos aos links e fun‡äes de TABLEIO, RECORD e 
                GROUP-ASSIGN.
   
    
   Parametros : Nenhum.
--------------------------------------------------------------------------------- */   
&IF "{&EXTERNAL-TABLES}":U <> "":U  AND "{&ADM-ASSIGN-FIELDS}":U <> "":U  &THEN
    &global-define ENABLED-TABLES {&EXTERNAL-TABLES}
    &global-define FIRST-ENABLED-TABLE {&FIRST-EXTERNAL-TABLE} 
    &global-define ENABLED-FIELDS {&ADM-ASSIGN-FIELDS}
&ELSE   
    &IF "{&EXTERNAL-TABLES}":U = "":U &THEN
        MESSAGE "Vocˆ precisa definir pelo menos uma tabela externa para que esta viewer funcione corretamente.  Verifique !"
          VIEW-AS ALERT-BOX ERROR TITLE "Mensagem p/ o desenvolvedor : ".
    &ELSE     
        MESSAGE "Vocˆ precisa definir pelo menos um FILL-IN no pre-processor ADM-ASSIGN-FIELDS para que esta viewer funcione corretamente.  Verifique !"
          VIEW-AS ALERT-BOX ERROR TITLE "Mensagem p/ o desenvolvedor : ".
    &ENDIF
&ENDIF                                  




