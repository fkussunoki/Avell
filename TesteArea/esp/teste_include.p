run pi-teste-include.
procedure pi-teste-include:
find last emitente no-lock no-error.

{esp\include.i emitente.cod-emitente}

for each tt-teste:
    disp tt-teste.ttv-cod-emitente.
end.

end procedure.