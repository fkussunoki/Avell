/***************************************************************
**
** I-RPEXA.I - Saida A na PI-EXECUTAR do template de relat¢rio
**
***************************************************************/ 

def var c-arq-aux    as char no-undo.

&IF  DEFINED(PGLOG) = 0 &THEN

if  input frame f-pg-imp rs-destino  = 2 
and input frame f-pg-imp rs-execucao = 1 then do:
    
    assign c-arq-aux = input frame f-pg-imp c-arquivo
           c-arq-aux = replace(c-arq-aux, "/", "\").
    if  r-index(c-arq-aux, "\") > 0 then do:
        assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "\")).
        if  file-info:full-pathname = ? or not file-info:file-type matches "*D*" then do:
            RUN MESSAGE.p ('Diret¢rio informado no caminho do arquivo n∆o existe !',
                           'Diret¢rio informado no caminho do arquivo para destino relat¢rio n∆o existe em seu sistema de arquivos.').
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = c-arq-aux.
    if file-info:file-type matches "*D*" then do:
        RUN MESSAGE.p ('Nome de arquivo inv†lido',
                       'Nome de arquivo informado n∆o Ç compat°vel com o sistema operacional.').
        apply 'mouse-select-click' to im-pg-imp in frame f-relat.
        apply 'entry' to c-arquivo in frame f-pg-imp.                   
        return error.
    end.
end.    

&ELSE

if  input frame f-pg-log rs-destino  = 2 
and input frame f-pg-log rs-execucao = 1 then do:
    
    assign c-arq-aux = input frame f-pg-log c-arquivo-destino
           c-arq-aux = replace(c-arq-aux, "/", "\").
    if  r-index(c-arq-aux, "\") > 0 then do:       
        assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "\")).
        if  file-info:full-pathname = ? or not file-info:file-type matches "*D*" then do:
            RUN MESSAGE.p ('Diret¢rio informado no caminho do arquivo n∆o existe !',
                           'Diret¢rio informado no caminho do arquivo para destino relat¢rio n∆o existe em seu sistema de arquivos.').
            apply 'mouse-select-click' to im-pg-log in frame f-import.
            apply 'entry' to c-arquivo-destino in frame f-pg-log.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = c-arq-aux.
    if file-info:file-type matches "*D*" then do:
        RUN MESSAGE.p ('Nome de arquivo inv†lido',
                       'Nome de arquivo informado n∆o Ç compat°vel com o sistema operacional.').
        apply 'mouse-select-click' to im-pg-log in frame f-import.
        apply 'entry' to c-arquivo-destino in frame f-pg-log.                   
        return error.
    end.
end.    


&ENDIF

/* i-rpexa */

