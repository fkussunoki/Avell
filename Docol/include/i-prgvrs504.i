/************************************************************************
**
**  i-prgvrs.i - Programa para cria‡Æo do log de todos os programas 
**               e objetos do EMS 2.0 para objetos
**  {1} = objeto   provido pelo Roundtable
**  {2} = versao   provido pelo Roundtable
************************************************************************/

def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.
def var c-prg-vrs as char init "[[[{2}[[[" no-undo.
def var c-prg-obj as char no-undo.

assign c-prg-vrs = "{2}"
       c-prg-obj = "{1}".

if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    find prog_dtsul
        where prog_dtsul.cod_prog_dtsul = "{1}"
        no-lock no-error.
        
   if not avail prog_dtsul then do:
          if  c-prg-obj begins "btb" then
              assign c-prg-obj = "btb~/" + c-prg-obj.
          else if c-prg-obj begins "men" then
                  assign c-prg-obj = "men~/" + c-prg-obj.
          else if c-prg-obj begins "sec" then
                  assign c-prg-obj = "sec~/" + c-prg-obj.
          else if c-prg-obj begins "utb" then
                  assign c-prg-obj = "utb~/" + c-prg-obj.
          find prog_dtsul where
               prog_dtsul.nom_prog_ext begins c-prg-obj no-lock no-error.
   end /*if*/.           
    
    output to value(c-arquivo-log) append.
    put "{1}" at 1 "{2}" at 69 today at 84 string(time,'HH:MM:SS') at 94 skip.
    if  avail prog_dtsul then do:
        if  prog_dtsul.nom_prog_dpc <> "" then
            put "DPC : " at 5 prog_dtsul.nom_prog_dpc  at 12 skip.
        if  prog_dtsul.nom_prog_appc <> "" then
            put "APPC: " at 5 prog_dtsul.nom_prog_appc at 12 skip.
        if  prog_dtsul.nom_prog_upc <> "" then
            put "UPC : " at 5 prog_dtsul.nom_prog_upc  at 12 skip.
    end.
    output close.        
end.  

error-status:error = no.

{include/i_dbtype504.i}

