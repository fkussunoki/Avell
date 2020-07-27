  /***************************************************************
**
** I-STR070.I - Default action no browse
** 
***************************************************************/

    if bt-expand:sensitive in frame {&frame-name} then 
     apply "choose":U to bt-expand in frame {&frame-name}.
  else
     if bt-collapse:sensitive in frame {&frame-name} then 
        apply "choose":U to bt-collapse in frame {&frame-name}.
    
     /* I-STR070.I */
