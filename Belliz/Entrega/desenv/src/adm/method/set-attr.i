/* set-attr.i = ADM Broker's set-attribute */ 

adm-tmp-pos1 = 0.
DO adm-tmp-index = 1 TO {&{2}-INDEX} - 1:
    adm-tmp-pos1 = INDEX({1}:{&ADM-DATA},"`",
      adm-tmp-pos1 + 1).
END.
adm-tmp-pos2 = INDEX({1}:{&ADM-DATA},"`",
    adm-tmp-pos1 + 1).
adm-tmp-str = SUBSTR({1}:{&ADM-DATA},1, 
    adm-tmp-pos1) + {3}.
IF adm-tmp-pos2 NE 0 THEN
    adm-tmp-str = adm-tmp-str + 
        SUBSTR({1}:{&ADM-DATA}, adm-tmp-pos2).
{1}:{&ADM-DATA} = adm-tmp-str.

/* This is what the above code is trying to accomplish; Progress however
   does not support references to an expression such as ENTRY on the
   left hand side of an assignment statement. 
   ENTRY({&{2}-INDEX}, {1}:{&ADM-DATA}, "`":U) = {3}.
*/
