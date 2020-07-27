/**************************************************************************
**
** I-FREEAC - Define function para transformar string's acentuadas em nao
**            acentuadas.
**
***************************************************************************/

FUNCTION fn-free-accent RETURNS char (INPUT p-string AS char ).
    define var c-free-accent as char case-sensitive no-undo.
    
    assign c-free-accent = p-string
           c-free-accent =  replace(c-free-accent, '∑', 'A')
           c-free-accent =  replace(c-free-accent, 'µ', 'A')
           c-free-accent =  replace(c-free-accent, '∂', 'A')
           c-free-accent =  replace(c-free-accent, '«', 'A')
           c-free-accent =  replace(c-free-accent, 'é', 'A')
           c-free-accent =  replace(c-free-accent, '‘', 'E')
           c-free-accent =  replace(c-free-accent, 'ê', 'E')
           c-free-accent =  replace(c-free-accent, '“', 'E')
           c-free-accent =  replace(c-free-accent, '”', 'E')
           c-free-accent =  replace(c-free-accent, 'ﬁ', 'I')
           c-free-accent =  replace(c-free-accent, '÷', 'I')
           c-free-accent =  replace(c-free-accent, '◊', 'I')
           c-free-accent =  replace(c-free-accent, 'ÿ', 'I')
           c-free-accent =  replace(c-free-accent, '„', 'O')
           c-free-accent =  replace(c-free-accent, '‡', 'O')
           c-free-accent =  replace(c-free-accent, '‚', 'O')
           c-free-accent =  replace(c-free-accent, 'Â', 'O')
           c-free-accent =  replace(c-free-accent, 'ô', 'O')
           c-free-accent =  replace(c-free-accent, 'Î', 'U')
           c-free-accent =  replace(c-free-accent, 'È', 'U')
           c-free-accent =  replace(c-free-accent, 'Í', 'U')
           c-free-accent =  replace(c-free-accent, 'ö', 'U')
           c-free-accent =  replace(c-free-accent, 'Ì', 'Y')
           c-free-accent =  replace(c-free-accent, 'ü', 'Y')
           c-free-accent =  replace(c-free-accent, 'Ä', 'C')
           c-free-accent =  replace(c-free-accent, '•', 'N')
           c-free-accent =  replace(c-free-accent, 'Ö', 'a')
           c-free-accent =  replace(c-free-accent, '†', 'a')
           c-free-accent =  replace(c-free-accent, 'É', 'a')
           c-free-accent =  replace(c-free-accent, '∆', 'a')
           c-free-accent =  replace(c-free-accent, 'Ñ', 'a')
           c-free-accent =  replace(c-free-accent, 'ä', 'e')
           c-free-accent =  replace(c-free-accent, 'Ç', 'e')
           c-free-accent =  replace(c-free-accent, 'à', 'e')
           c-free-accent =  replace(c-free-accent, 'â', 'e')
           c-free-accent =  replace(c-free-accent, 'ç', 'i')
           c-free-accent =  replace(c-free-accent, '°', 'i')
           c-free-accent =  replace(c-free-accent, 'å', 'i')
           c-free-accent =  replace(c-free-accent, 'ã', 'i')
           c-free-accent =  replace(c-free-accent, 'ï', 'o')
           c-free-accent =  replace(c-free-accent, '¢', 'o')
           c-free-accent =  replace(c-free-accent, 'ì', 'o')
           c-free-accent =  replace(c-free-accent, '‰', 'o')
           c-free-accent =  replace(c-free-accent, 'î', 'o')
           c-free-accent =  replace(c-free-accent, 'ó', 'u')
           c-free-accent =  replace(c-free-accent, '£', 'u')
           c-free-accent =  replace(c-free-accent, 'ñ', 'u')
           c-free-accent =  replace(c-free-accent, 'Å', 'u')
           c-free-accent =  replace(c-free-accent, 'Ï', 'y')
           c-free-accent =  replace(c-free-accent, 'ò', 'y')
           c-free-accent =  replace(c-free-accent, 'á', 'c')
           c-free-accent =  replace(c-free-accent, '§', 'n')
           c-free-accent =  replace(c-free-accent, '¶', 'a')
           c-free-accent =  replace(c-free-accent, 'ß', 'o')
           c-free-accent =  replace(c-free-accent, '&', 'E').
     
    return c-free-accent.
end function.
