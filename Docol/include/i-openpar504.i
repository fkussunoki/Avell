

&SCOPED-DEFINE CAMPO {2}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {3}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {4}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {5}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {6}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {7}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {8}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {9}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {10}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {11}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {12}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {13}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {14}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {15}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {16}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {17}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {18}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {19}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {20}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF

&SCOPED-DEFINE CAMPO {21}
&IF  '{&CAMPO}' <> '' &THEN
    ASSIGN  i-param-posicao   = LOOKUP('{&CAMPO}', c-param-campos, CHR(10))
            c-param-variavel  = ENTRY(i-param-posicao,c-param-dados, CHR(10)).
    IF  ENTRY(i-param-posicao,c-param-tipos, CHR(10)) = '{1}' THEN
        &IF  '{1}' = 'CHARACTER' &THEN  
            ASSIGN  {&CAMPO} = c-param-variavel.
        &ELSEIF '{1}' = 'LOGICAL' &THEN 
            ASSIGN  {&CAMPO} = (c-param-variavel = 'YES').
        &ELSE  
            ASSIGN  {&CAMPO} = {1}(c-param-variavel).
        &ENDIF
&ENDIF
