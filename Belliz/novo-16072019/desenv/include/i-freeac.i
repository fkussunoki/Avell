/**************************************************************************
**
** I-FREEAC - Define function para transformar string's acentuadas em nao
**            acentuadas.
**
***************************************************************************/

FUNCTION fn-free-accent RETURNS char (INPUT p-string AS char ).
    define var c-free-accent as char case-sensitive no-undo.
    
    assign c-free-accent = p-string
           c-free-accent =  replace(c-free-accent, '�', 'A')
           c-free-accent =  replace(c-free-accent, '�', 'A')
           c-free-accent =  replace(c-free-accent, '�', 'A')
           c-free-accent =  replace(c-free-accent, '�', 'A')
           c-free-accent =  replace(c-free-accent, '�', 'A')
           c-free-accent =  replace(c-free-accent, '�', 'E')
           c-free-accent =  replace(c-free-accent, '�', 'E')
           c-free-accent =  replace(c-free-accent, '�', 'E')
           c-free-accent =  replace(c-free-accent, '�', 'E')
           c-free-accent =  replace(c-free-accent, '�', 'I')
           c-free-accent =  replace(c-free-accent, '�', 'I')
           c-free-accent =  replace(c-free-accent, '�', 'I')
           c-free-accent =  replace(c-free-accent, '�', 'I')
           c-free-accent =  replace(c-free-accent, '�', 'O')
           c-free-accent =  replace(c-free-accent, '�', 'O')
           c-free-accent =  replace(c-free-accent, '�', 'O')
           c-free-accent =  replace(c-free-accent, '�', 'O')
           c-free-accent =  replace(c-free-accent, '�', 'O')
           c-free-accent =  replace(c-free-accent, '�', 'U')
           c-free-accent =  replace(c-free-accent, '�', 'U')
           c-free-accent =  replace(c-free-accent, '�', 'U')
           c-free-accent =  replace(c-free-accent, '�', 'U')
           c-free-accent =  replace(c-free-accent, '�', 'Y')
           c-free-accent =  replace(c-free-accent, '�', 'Y')
           c-free-accent =  replace(c-free-accent, '�', 'C')
           c-free-accent =  replace(c-free-accent, '�', 'N')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'e')
           c-free-accent =  replace(c-free-accent, '�', 'e')
           c-free-accent =  replace(c-free-accent, '�', 'e')
           c-free-accent =  replace(c-free-accent, '�', 'e')
           c-free-accent =  replace(c-free-accent, '�', 'i')
           c-free-accent =  replace(c-free-accent, '�', 'i')
           c-free-accent =  replace(c-free-accent, '�', 'i')
           c-free-accent =  replace(c-free-accent, '�', 'i')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '�', 'u')
           c-free-accent =  replace(c-free-accent, '�', 'u')
           c-free-accent =  replace(c-free-accent, '�', 'u')
           c-free-accent =  replace(c-free-accent, '�', 'u')
           c-free-accent =  replace(c-free-accent, '�', 'y')
           c-free-accent =  replace(c-free-accent, '�', 'y')
           c-free-accent =  replace(c-free-accent, '�', 'c')
           c-free-accent =  replace(c-free-accent, '�', 'n')
           c-free-accent =  replace(c-free-accent, '�', 'a')
           c-free-accent =  replace(c-free-accent, '�', 'o')
           c-free-accent =  replace(c-free-accent, '&', 'E').
     
    return c-free-accent.
end function.
