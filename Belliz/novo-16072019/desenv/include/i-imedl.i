/*******************************************************************
**
**  I-IMEDL.I - Editar Layout 
**
********************************************************************/

assign c-arq-temp = session:temp-directory + "import.tmp":U.
def var c-linha as char format "x(132)" no-undo.
input stream s-imp from value(search(c-arq-layout)) no-echo.
output to value(c-arq-temp) convert target "iso8859-1".
repeat:
    import stream s-imp unformatted c-linha.
    if  c-linha <> "" then
        put c-linha skip.
    else
        put " " skip.
end.
output close.
input stream s-imp close.    
    
{include/i-imtrm.i c-arq-temp 3}
/* i-imedl.i */
