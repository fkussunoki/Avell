define var c-diretorio as char.
define var c-arquivos as char.
define var c-entradas as integer.
define var i as integer.
define var v-diretorio as char.

assign c-diretorio = "f:\totvs\custom\api, f:\totvs\custom\escm". //Aqui estamos definindo uma lista de diretorios que queremos que o programa passe. Perceba, sempre separados com virgula!!

assign c-entradas = num-entries(c-diretorio). //aqui estamos determinando quantos diretorios estao contidos na listagem. Por isto a separacao por virugla anteriormente. O comando conta os itens separados por virugla.
                                              //neste caso o resultado sera 2.


    do i = 1 to c-entradas: //aqui lemos a quantia de vezes ele fara o looping comecando a contar pelo 1. No caso, fara duas vezes.
        assign v-diretorio = trim(entry(i, c-diretorio)). //atribuimos ao v-diretorio o nome do diretorio qu ele verificara no looping. Sera reescrito a cada passagem.
                                                          //trim eh um comando para tirar espacos em branco de uma variavel.
                                                          // entry eh uma forma de navegar em uma lista, onde i = indice da lista.
        
//        message v-diretorio view-as alert-box.
//se quiser, pode dar um message para verificar se esta pegando os diretorios corretos.
        
        input from os-dir(v-diretorio). //determinamos que o sistema ira pegar o conteudo do diretorio no looping (OS-DIR)
        repeat:
            import c-arquivos. //importamos o conteudo do diretorio para c-arquivos
            
            
            if length(c-arquivos) < 3 then next. //se o arquivo tiver tamanho menor que tres caracteres, ignora e segue para o proximo
            
            if  c-arquivos matches "*~~.p"
            or  c-arquivos matches "*~~.w" then do: //verifica se o arquivo tem a extensao .p ou .w (comando matches)
             
                compile value(v-diretorio + "\" + c-arquivos) save into value (v-diretorio). //faz a compilacao. Caso queira um outro diretorio de destino, seria apenas criar uma nova variavel contendo o diretorio
                                                                                             // e substituir into value (v-diretorio) pela variavel criada.
        
            end.
            
        end.
    end.
