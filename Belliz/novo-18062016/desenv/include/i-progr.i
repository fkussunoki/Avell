def var prog      as char format "x(15)" no-undo.


if i-recebe <> rs-opcao or c-recebe <> c-banco then do:
  assign i-recebe = rs-opcao
         c-recebe = c-banco.    

  for each tt-prog:                               
      delete tt-prog.
  end.
  if c-banco = "Recursos Humanos" then
     assign   c-banco = "RHecursos Humanos".
  
  if c-banco = "Investimentos" then
     assign   c-banco = "IVnvestimentos".
  
  if rs-opcao = 1 then
     diretorio = "x:~\desenv~\" + substring(c-banco,1,2) + "brw~\" .    
  else if rs-opcao = 2 then 
     diretorio = "x:~\desenv~\" + substring(c-banco,1,2) + "vwr~\" .       
  else  diretorio = "x:~\desenv~\" + substring(c-banco,1,2) + "zoom~\".       
  
  input from os-dir (diretorio) no-echo.
  repeat:
    import prog.              
    if substring(prog,length(prog),1) = "w" then do:
       create tt-prog.
       assign tt-prog.prog = prog.    
    end.   
  end.
end.
       
