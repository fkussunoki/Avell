def temp-table tt-planilha no-undo
field ttv-status              as char
field ttv-filial-de           as char
field ttv-filial-para         as char
field ttv-cta-pat             as char
field ttv-descricao           as char
field ttv-cta-pat-para        as char
field ttv-bem-de              as char
field ttv-inc-de              as char
field ttv-foto                as char
field ttv-desmembrar          as char
field ttv-bem-para            as char
field ttv-inc-para            as char
field ttv-cc-de               as char
field ttv-cc-para             as char
field ttv-dt-aquisicao        as date
field ttv-descricao1          as char
field ttv-descricao-de        as char
field ttv-descricao-para      as char
field ttv-local-de            as char
field ttv-local-para          as char
field ttv-ps                  as char
field ttv-cod-especie         as char
field ttv-des-especie         as char
field ttv-taxa-conta          as char
field ttv-vlr-original        as char
field ttv-vlr-original-corr   as char
field ttv-depreciacao         as char
field ttv-situacao            as char
field ttv-nf                  as char
field ttv-fornecedor          as char
field ttv-dt-base-arquivo     as date
field ttv-taxa-societaria     as char
field ttv-residual            as char.


Def Temp-table tt-bens   
    Field i-cod-bem                              As Int   Form ">>>>>>>9"    
    Field c-empresa                              As Char  Form "x(3)"        
    Field c-conta-patrimonial                    As Char  Form "x(18)"       
    Field i-bem-patrimonial                      As Int   Form ">>>>>>>>9"   
    Field i-nr-sequencia                         As Int   Form "99999"       
    Field c-descricao                            As Char  Form "x(40)"       
    Field c-num-plaqueta                         As Char  Form "x(20)"       
    Field i-qtd-bens                             As Int   Form ">>>>>>>9"    
    Field c-periodicidade                        As Char  Form "x(14)"       
    Field dt-aquisicao                           As Date  Form "99/99/9999"  
    Field c-stabelecimento                       As Char  Form "x(3)"        
    Field c-especie-bem                          As Char  Form "x(6)"        
    Field c-Marca                                As Char  Form "x(6)"        
    Field c-Modelo                               As Char  Form "x(8)"        
    Field c-Licenca                              As Char  Form "x(12)"       
    Field c-Especificacao                        As Char  Form "x(8)"        
    Field c-Estado-fisico                        As Char  Form "x(8)"        
    Field c-Arrendador                           As Char  Form "x(6)"        
    Field c-Contrato-Leasing                     As Char  Form "x(12)"       
    Field i-Fornecedor                           As Int   Form ">>>>>9"      
    Field c-Localizacao                          As Char  Form "x(12)"       
    Field c-Responsavel                          As Char  Form "x(12)"       
    Field dt-ultimo-Inventario                   As Date  Form "99/99/9999"  
    Field c-Narrativa                            As Char  Form "x(2000)"     
    Field c-Seguradora                           As Char  Form "x(8)"    
    Field c-Apolice-Seguro                       As Char  Form "x(12)"   
    Field dt-Inicio-Validade                     As Date  Form "99/99/9999"    
    Field dt-Fim-Validade                        As Date  Form "99/99/9999"    
    Field de-Premio-Seguro                       As Dec   Form ">>>>>>>>>>>9.99"
    Field c-Seguradora1                          As Char  Form "x(8)"     
    Field c-Apolice-Seguro1                      As Char  Form "x(12)"   
    Field dt-Inicio-validade1                    As Date  Form "99/99/9999"   
    Field dt-Fim-validade1                       As Date  Form "99/99/9999"   
    Field de-Premio-Seguro1                      As Dec   Form ">>>>>>>>>>>9.99"   
    Field c-Seguradora2                          As Char  Form "x(8)"   
    Field c-apolice-seguro2                      As Char  Form "x(12)"  
    Field dt-Inicio-Validade2                    As Date  Form "99/99/9999"   
    Field dt-Fim-Validade2                       As Date  Form "99/99/9999"   
    Field de-Premio-Seguro2                      As Dec   Form ">>>>>>>>>>>9.99"  
    Field c-Docto-Entrada                        As Char  Form "x(16)"   
    Field i-Numero-Item                          As Int   Form ">>>>>9"  
    Field i-Pessoa-Garantia                      As Int   Form ">>>>>>>>9"   
    Field dt-Inicio-Garantia                     As Date  Form "99/99/9999" 
    Field dt-Fim-Garantia                        As Date  Form "99/99/9999" 
    Field c-Termo-Garantia                       As Char  Form "x(2000)" 
    Field c-Grupo-calculo                        As Char  Form "x(6)"    
    Field dt-Movimento                           As Date  Form "99/99/9999"  
    Field de-Perc-Baixado                        As Dec   Form ">>9.99"  
    Field dt-Inicio                              As Date  Form "99/99/9999" 
    Field dt-calculo                             As Date  Form "99/99/9999"  
    Field c-Serie-Nota                           As Char  Form "x(5)"    
    Field l-Bem-Importado                        As Log   Form "yes/no"   
    Field l-Credita-PIS                          As Log   Form "yes/no"   
    Field l-Credita-COFINS                       As Log   Form "yes/no"   
    Field i-Nro-Parcelas                         As Int   Form ">9"   
    Field i-Parcelas-Descontadas                 As Int   Form ">9"    
    Field de-Valor-PIS                           As dec   Form ">>>>>>>>9.99" 
    Field de-Valor-COFINS                        As dec   Form ">>>>>>>>9.99" 
    Field l-Credita                              As Log   Form "yes/no"   
    Field i-Exercicio                            As Int   Form ">9"   .

                                     
Def Temp-table tt-valores No-undo
    Field i-Nro-Sequencial-Bem            As Int  Form ">>>>>>>9"           
    Field i-Sequencia-Incorp              As Int  Form ">>>>>>>9"           
    Field c-Cenario-Contabil              As Char Form "x(8)"               
    Field c-Finalidade                    As Char Form "x(10)"              
    Field de-Valor-Original                As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Correcao-Monetaria            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Dpr-Valor-Original            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Dpr-Correcao-Monet            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Correcao-Monet-Dpr            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Depreciacao-Incentiv          As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Dpr-Incentiv-CM               As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-CM-Dpr-Incentivada            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Amortizacao-VO                As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Amortizacao-CM                As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-CM-Amortizacao                As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Amortizacao-Incentiv          As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Amort-Incentiv-CM             As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-CM-Amort-Incentvda            As Dec  Form ">>>>>>>>>>>9.99"    
    Field de-Percentual-Dpr                As Dec  Form ">>>>9.9999"         
    Field de-Perc-Dpr-Incentivada          As Dec  Form ">>>>9.9999"         
    Field de-Perc-Dpr-Reducao-Saldo        As Dec  Form ">>>>9.9999"   .      


Def Temp-table tt-alocacoes No-undo
    Field i-Nro-Sequencial-Bem     As Int  Form ">>>>>>>9"         
    Field c-Plano-Centros-Custo    As Char Form "x(8)"             
    Field c-Centro-Custo           As Char Form "x(11)"            
    Field c-Unid-Negocio           As Char Form "x(3)"             
    Field de-Perc-Apropriacao      As Dec  Form ">>>>>9.9999"      
    Field l-CCusto-UN-Principal    As Log  Form "yes/no"  .         
  

def var ch-excel As Com-handle No-undo.
def var ch-book  As Com-handle No-undo.
def var ch-sheet As Com-handle No-undo.
Def Var i-linha  As Int        No-undo.
Def Var l-erro   As Log        No-undo.
Def Var i        As Int        No-undo.
    
Def Stream str-saida.

Output Stream str-saida To Value("c:\temp\erro.txt").

run pi-importa-planilha.    
Run pi-bens.
Run pi-valores.
Run pi-alocacoes.
Output Close.

procedure pi-importa-planilha:
    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add("c:\temp\bem.xls"). 
           ch-sheet = ch-book:worksheets(1).
    
    Assign i-linha = 1
           l-erro  = No.
   
    
   Repeat:
    
        i-linha = i-linha + 1.
    
        disp i-linha.
        pause 0.
       IF ch-sheet:cells(i-linha, 1):Text = ""  Then Leave.

       create tt-planilha.
       assign tt-planilha.ttv-status               = ch-sheet:cells(i-linha, 1):Text
              tt-planilha.ttv-filial-de            = ch-sheet:cells(i-linha, 2):Text
              tt-planilha.ttv-filial-para          = ch-sheet:cells(i-linha, 3):Text
              tt-planilha.ttv-cta-pat              = ch-sheet:cells(i-linha, 4):Text
              tt-planilha.ttv-descricao            = ch-sheet:cells(i-linha, 5):text
              tt-planilha.ttv-cta-pat-para         = ch-sheet:cells(i-linha, 6):Text
              tt-planilha.ttv-bem-de               = ch-sheet:cells(i-linha, 7):Text
              tt-planilha.ttv-inc-de               = ch-sheet:cells(i-linha, 8):Text 
              tt-planilha.ttv-foto                 = ch-sheet:cells(i-linha, 9):Text
              tt-planilha.ttv-desmembrar           = ch-sheet:cells(i-linha, 10):Text
              tt-planilha.ttv-bem-para             = ch-sheet:cells(i-linha, 11):Text
              tt-planilha.ttv-inc-para             = ch-sheet:cells(i-linha, 12):Text
              tt-planilha.ttv-cc-de                = ch-sheet:cells(i-linha, 13):Text
              tt-planilha.ttv-cc-para              = ch-sheet:cells(i-linha, 14):Text
              tt-planilha.ttv-dt-aquisicao         = date(ch-sheet:cells(i-linha, 15):Text)
              tt-planilha.ttv-descricao1           = ch-sheet:cells(i-linha, 16):Text
              tt-planilha.ttv-descricao-de         = ch-sheet:cells(i-linha, 17):Text
              tt-planilha.ttv-descricao-para       = ch-sheet:cells(i-linha, 18):Text
              tt-planilha.ttv-local-de             = ch-sheet:cells(i-linha, 19):Text
              tt-planilha.ttv-local-para           = ch-sheet:cells(i-linha, 20):Text
              tt-planilha.ttv-ps                   = ch-sheet:cells(i-linha, 21):text
              tt-planilha.ttv-cod-especie          = ch-sheet:cells(i-linha, 22):Text
              tt-planilha.ttv-des-especie          = ch-sheet:cells(i-linha, 24):Text
              tt-planilha.ttv-taxa-conta           = ch-sheet:cells(i-linha, 25):Text
              tt-planilha.ttv-vlr-original         = ch-sheet:cells(i-linha, 26):Text
              tt-planilha.ttv-vlr-original-corr    = ch-sheet:cells(i-linha, 27):text
              tt-planilha.ttv-depreciacao          = ch-sheet:cells(i-linha, 28):text
              tt-planilha.ttv-situacao             = ch-sheet:cells(i-linha, 29):text
              tt-planilha.ttv-nf                   = ch-sheet:cells(i-linha, 30):text
              tt-planilha.ttv-fornecedor           = ch-sheet:cells(i-linha, 31):text
              tt-planilha.ttv-dt-base-arquivo      = date(ch-sheet:cells(i-linha, 32):text)
              tt-planilha.ttv-taxa-societaria      = ch-sheet:cells(i-linha, 33):text
              tt-planilha.ttv-residual             = ch-sheet:cells(i-linha, 34):text.  


end procedure.


Procedure pi-bens: 

   

    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add("c:\temp\bem.xls"). 
           ch-sheet = ch-book:worksheets(1).
    
    Assign i-linha = 1
           l-erro  = No.
   
    For Each tt-bens. Delete tt-bens. End.
    
   Repeat:
    
        i-linha = i-linha + 1.
    
        disp i-linha.
        pause 0.
       IF ch-sheet:cells(i-linha, 1):Text = ""  Then Leave.
         
        Create tt-bens.
        Assign tt-bens.i-cod-bem                 = Int(Trim(ch-sheet:cells(i-linha,01):Text))      
               tt-bens.c-empresa                 = Trim(ch-sheet:cells(i-linha,02):Text)       
               tt-bens.c-conta-patrimonial       = Trim(ch-sheet:cells(i-linha,03):Text)        
               tt-bens.i-bem-patrimonial         = Int(Trim(ch-sheet:cells(i-linha,04):Text))       
               tt-bens.i-nr-sequencia            = Int(Trim(ch-sheet:cells(i-linha,05):Text))        
               tt-bens.c-descricao               = Trim(ch-sheet:cells(i-linha,06):Text)        
               tt-bens.c-num-plaqueta            = Trim(ch-sheet:cells(i-linha,07):Text)        
               tt-bens.i-qtd-bens                = Int(Trim(ch-sheet:cells(i-linha,08):Text))        
               tt-bens.c-periodicidade           = Trim(ch-sheet:cells(i-linha,09):Text)        
               tt-bens.dt-aquisicao              = Date(Trim(ch-sheet:cells(i-linha,10):Text))        
               tt-bens.c-stabelecimento          = Trim(ch-sheet:cells(i-linha,11):Text)         
               tt-bens.c-especie-bem             = Trim(ch-sheet:cells(i-linha,12):Text)         
               tt-bens.c-Marca                   = Trim(ch-sheet:cells(i-linha,13):Text)         
               tt-bens.c-Modelo                  = Trim(ch-sheet:cells(i-linha,14):Text)         
               tt-bens.c-Licenca                 = Trim(ch-sheet:cells(i-linha,15):Text)         
               tt-bens.c-Especificacao           = Trim(ch-sheet:cells(i-linha,16):Text)         
               tt-bens.c-Estado-fisico           = Trim(ch-sheet:cells(i-linha,17):Text)         
               tt-bens.c-Arrendador              = Trim(ch-sheet:cells(i-linha,18):Text)         
               tt-bens.c-Contrato-Leasing        = Trim(ch-sheet:cells(i-linha,19):Text)         
               tt-bens.i-Fornecedor              = Int(Trim(ch-sheet:cells(i-linha,20):Text))         
               tt-bens.c-Localizacao             = Trim(ch-sheet:cells(i-linha,21):Text)         
               tt-bens.c-Responsavel             = Trim(ch-sheet:cells(i-linha,22):Text)         
               tt-bens.dt-ultimo-Inventario      = Date(Trim(ch-sheet:cells(i-linha,23):Text))         
               tt-bens.c-Narrativa               = Trim(ch-sheet:cells(i-linha,24):Text)         
               tt-bens.c-Seguradora              = Trim(ch-sheet:cells(i-linha,25):Text)         
               tt-bens.c-Apolice-Seguro          = Trim(ch-sheet:cells(i-linha,26):Text)         
               tt-bens.dt-Inicio-Validade        = Date(Trim(ch-sheet:cells(i-linha,27):Text))         
               tt-bens.dt-Fim-Validade           = Date(Trim(ch-sheet:cells(i-linha,28):Text))         
               tt-bens.de-Premio-Seguro          = Dec(Trim(ch-sheet:cells(i-linha,29):Text))         
               tt-bens.c-Seguradora1             = Trim(ch-sheet:cells(i-linha,30):Text)         
               tt-bens.c-Apolice-Seguro1         = Trim(ch-sheet:cells(i-linha,31):Text)         
               tt-bens.dt-Inicio-validade1       = Date(Trim(ch-sheet:cells(i-linha,32):Text))         
               tt-bens.dt-Fim-validade1          = Date(Trim(ch-sheet:cells(i-linha,33):Text))         
               tt-bens.de-Premio-Seguro1         = Dec(Trim(ch-sheet:cells(i-linha,34):Text))         
               tt-bens.c-Seguradora2             = Trim(ch-sheet:cells(i-linha,35):Text)         
               tt-bens.c-apolice-seguro2         = Trim(ch-sheet:cells(i-linha,36):Text)         
               tt-bens.dt-Inicio-Validade2       = Date(Trim(ch-sheet:cells(i-linha,37):Text))         
               tt-bens.dt-Fim-Validade2          = Date(Trim(ch-sheet:cells(i-linha,38):Text))         
               tt-bens.de-Premio-Seguro2         = Dec(Trim(ch-sheet:cells(i-linha,39):Text))         
               tt-bens.c-Docto-Entrada           = Trim(ch-sheet:cells(i-linha,40):Text)         
               tt-bens.i-Numero-Item             = Int(Trim(ch-sheet:cells(i-linha,41):Text))         
               tt-bens.i-Pessoa-Garantia         = Int(Trim(ch-sheet:cells(i-linha,42):Text))         
               tt-bens.dt-Inicio-Garantia        = Date(Trim(ch-sheet:cells(i-linha,43):Text))         
               tt-bens.dt-Fim-Garantia           = Date(Trim(ch-sheet:cells(i-linha,44):Text))         
               tt-bens.c-Termo-Garantia          = Trim(ch-sheet:cells(i-linha,45):Text)         
               tt-bens.c-Grupo-calculo           = Trim(ch-sheet:cells(i-linha,46):Text)         
               tt-bens.dt-Movimento              = Date(Trim(ch-sheet:cells(i-linha,47):Text))         
               tt-bens.de-Perc-Baixado           = Dec(Trim(ch-sheet:cells(i-linha,48):Text))         
               tt-bens.dt-Inicio                 = Date(Trim(ch-sheet:cells(i-linha,49):Text))         
               tt-bens.dt-calculo                = Date(Trim(ch-sheet:cells(i-linha,50):Text) )        
               tt-bens.c-Serie-Nota              = Trim(ch-sheet:cells(i-linha,51):Text)          
               tt-bens.l-Bem-Importado           = Logical(ch-sheet:cells(i-linha, 52):Text,"yes/no")     
               tt-bens.l-Credita-PIS             = Logical(ch-sheet:cells(i-linha, 53):Text,"yes/no")    
               tt-bens.l-Credita-COFINS          = Logical(ch-sheet:cells(i-linha, 54):Text,"yes/no")    
               tt-bens.i-Nro-Parcelas            = Int(Trim(ch-sheet:cells(i-linha,55):Text))         
               tt-bens.i-Parcelas-Descontadas    = Int(Trim(ch-sheet:cells(i-linha,56):Text))         
               tt-bens.de-Valor-PIS              = Dec(Trim(ch-sheet:cells(i-linha,57):Text))         
               tt-bens.de-Valor-COFINS           = Dec(Trim(ch-sheet:cells(i-linha,58):Text))         
               tt-bens.l-Credita                 = Logical(ch-sheet:cells(i-linha, 59):Text,"yes/no")         
               tt-bens.i-Exercicio               = Int(Trim(ch-sheet:cells(i-linha,60):Text)) No-error.
 
      
        If Error-status:Error And Error-status:Num-messages > 0 Then Do:
            l-erro = YES.
            Do i = 1 To Error-status:Num-messages:
               Put Stream str-saida Unformatted 
                      "Linha com problema: " + string(i-linha) SPACE(5)
                      "C½digo erro: " + String(Error-status:Get-number(i)) SPACE(5)
                      "Descri?’o erro: " ERROR-STATUS:GET-MESSAGE(i) SKIP.
            End.
        End.
       
    End.
    input close.
    If Not l-erro Then Do:
    
        
        ch-book:Close(False).
        ch-excel:Quit().   
        
        Release Object ch-sheet No-error.
        Release Object ch-book  No-error.
        Release Object ch-excel No-error.
          
        Output  To Value ("c:\temp\" + "bens.txt").

        For Each tt-bens.

                  Put unformatted
                      tt-bens.i-cod-bem                         Form ">>>>>>>9"                   
           " "  trim('"' + tt-bens.c-empresa             + '"') /*Form "x(3)"*/                                  
           " "  trim('"' + tt-bens.c-conta-patrimonial   + '"') Form "x(18)"                      
           " "        tt-bens.i-bem-patrimonial                 Form ">>>>>>>>9"                  
           " "        tt-bens.i-nr-sequencia                    Form ">>>>9"                      
           " "  trim('"' + substring(replace(tt-bens.c-descricao, '"', " "), 1, 40)  + '"') Form "x(44)"                   
           " "  trim('"' + replace(tt-bens.c-num-plaqueta, '"', " ")        + '"') Form "x(22)"                      
           " "        tt-bens.i-qtd-bens                        Form ">>>>>>>9"                   
           " "  trim('"' + replace( tt-bens.c-periodicidade, '"', " ")       + '"') Form "x(16)"                      
           " "  (if tt-bens.dt-aquisicao = ? Then "?" Else String(tt-bens.dt-aquisicao, "99/99/9999"))  Form "x(11)"            
           " "  trim('"' + replace( tt-bens.c-stabelecimento, '"', " ")      + '"') Form "x(5)"                       
           " "  trim('"' + replace( tt-bens.c-especie-bem, '"', " ")         + '"') Form "x(8)"                       
           " "  trim('"' + replace( tt-bens.c-Marca, '"', " ")               + '"') Form "x(8)"                       
           " "  trim('"' + replace( tt-bens.c-Modelo, '"', " ")              + '"') Form "x(10)"                       
           " "  trim('"' + replace( tt-bens.c-Licenca, '"', " ")             + '"') Form "x(14)"                      
           " "  trim('"' + replace( tt-bens.c-Especificacao, '"', " ")       + '"') Form "x(10)"                       
           " "  trim('"' + replace( tt-bens.c-Estado-fisico, '"', " ")       + '"') Form "x(10)"                       
           " "  trim('"' + replace( tt-bens.c-Arrendador, '"', " ")         + '"') Form "x(8)"                       
           " "  trim('"' + replace( tt-bens.c-Contrato-Leasing, '"', " ")    + '"') Form "x(14)"                      
           " "        tt-bens.i-Fornecedor                      Form ">>>>>9"                     
           " "  trim('"' + replace( tt-bens.c-Localizacao, '"', " ")         + '"') Form "x(14)"                      
           " "  trim('"' + replace( tt-bens.c-Responsavel, '"', " ")         + '"') Form "x(14)"                      
           " "  (if tt-bens.dt-ultimo-Inventario  = ? Then "?" Else String(tt-bens.dt-ultimo-Inventario, "99/99/9999"))  Form "x(11)"  
           " "  trim('"' + replace( tt-bens.c-Narrativa, '"', " ")           + '"')                            
           " "  trim('"' + replace( tt-bens.c-Seguradora, '"', " ")          + '"') Form "x(10)"                           
           " "  trim('"' + replace( tt-bens.c-Apolice-Seguro, '"', " ")      + '"') Form "x(14)"                              
           " "        (if tt-bens.dt-Inicio-Validade   = ? Then "?" Else String(tt-bens.dt-Inicio-Validade, "99/99/9999"))  Form "x(11)"               
           " "        (if tt-bens.dt-Fim-Validade      = ? Then "?" Else String(tt-bens.dt-Fim-Validade   , "99/99/9999"))  Form "x(11)"                  
           " "        tt-bens.de-Premio-Seguro                  Form ">>>>>>>>>>>9.99"            
           " "  trim('"' + replace( tt-bens.c-Seguradora1, '"', " ")         + '"') Form "x(10)"                           
           " "  trim('"' + replace( tt-bens.c-Apolice-Seguro1, '"', " ")     + '"') Form "x(14)"                              
           " "        (if tt-bens.dt-Inicio-validade1  = ? Then "?" Else String(tt-bens.dt-Inicio-Validade1, "99/99/9999"))  Form "x(11)"          
           " "        (if tt-bens.dt-Fim-validade1     = ? Then "?" Else String(tt-bens.dt-Fim-Validade1   , "99/99/9999"))  Form "x(11)"          
           " "        tt-bens.de-Premio-Seguro1                 Form ">>>>>>>>>>>9.99"            
           " "  trim('"' + replace( tt-bens.c-Seguradora2, '"', " ")         + '"') Form "x(10)"                           
           " "  trim('"' + replace( tt-bens.c-apolice-seguro2, '"', " ")     + '"') Form "x(14)"                              
           " "        (if tt-bens.dt-Inicio-Validade2  = ? Then "?" Else String(tt-bens.dt-Inicio-Validade2, "99/99/9999"))  Form "x(11)"     
           " "        (if tt-bens.dt-Fim-Validade2     = ? Then "?" Else String(tt-bens.dt-Fim-Validade2   , "99/99/9999"))  Form "x(11)"     
           " "        tt-bens.de-Premio-Seguro2                 Form ">>>>>>>>>>>9.99"            
           " "  trim('"' + replace( tt-bens.c-Docto-Entrada, '"', " ")       + '"') Form "x(18)"                              
           " "        tt-bens.i-Numero-Item                     Form ">>>>>9"                     
           " "        tt-bens.i-Pessoa-Garantia                 Form ">>>>>>>>9"                  
           " "        (if tt-bens.dt-Inicio-Garantia  = ? Then "?" Else String(tt-bens.dt-Inicio-Garantia, "99/99/9999"))  Form "x(11)"         
           " "        (if tt-bens.dt-Fim-Garantia     = ? Then "?" Else String(tt-bens.dt-Fim-Garantia   , "99/99/9999"))  Form "x(11)"         
           " "  trim('"' + replace( tt-bens.c-Termo-Garantia, '"', " ")      + '"') Form "x(4)"                        
           " "  trim('"' + replace( tt-bens.c-Grupo-calculo, '"', " ")       + '"') Form "x(8)"                             
           " "        (if tt-bens.dt-Movimento   = ? Then "?" Else String(tt-bens.dt-Movimento, "99/99/9999"))  Form "x(11)"                      
           " "        tt-bens.de-Perc-Baixado                   Form ">>9.99"                     
           " "        (if tt-bens.dt-Inicio    = ? Then "?" Else String(tt-bens.dt-Inicio, "99/99/9999"))  Form "x(11)"                
           " "        (if tt-bens.dt-calculo   = ? Then "?" Else String(tt-bens.dt-calculo, "99/99/9999"))  Form "x(11)"                
           " "  trim('"' + replace( tt-bens.c-Serie-Nota, '"', " ")          + '"') Form "x(7)"                             
           " "        tt-bens.l-Bem-Importado                   Form "yes/no"                     
           " "        tt-bens.l-Credita-PIS                     Form "yes/no"                     
           " "        tt-bens.l-Credita-COFINS                  Form "yes/no"                     
           " "        tt-bens.i-Nro-Parcelas                    Form ">9"                         
           " "        tt-bens.i-Parcelas-Descontadas            Form ">9"                         
           " "        tt-bens.de-Valor-PIS                      Form ">>>>>>>>9.99"               
           " "        tt-bens.de-Valor-COFINS                   Form ">>>>>>>>9.99"               
           " "        tt-bens.l-Credita                         Form "yes/no"                     
           " "        tt-bens.i-Exercicio                       Form ">9"   Skip   .






        End.

        Output Close.
    End.
    
    

End Procedure.

Procedure pi-valores: 

    
    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add("c:\temp\valores.xls"). 
           ch-sheet = ch-book:worksheets(1).

    Assign i-linha = 1
           l-erro  = No.
    
    For Each tt-valores. Delete tt-valores. End.
    
    Repeat:
    
        i-linha = i-linha + 1.
    
        IF ch-sheet:cells(i-linha, 1):Text = ""  Then Leave.
         
        Create tt-valores.
        Assign tt-valores.i-Nro-Sequencial-Bem                = Int(Trim(ch-sheet:cells(i-linha,01):Text))      
               tt-valores.i-Sequencia-Incorp                  = Int(Trim(ch-sheet:cells(i-linha,02):Text))        
               tt-valores.c-Cenario-Contabil                  = Trim(ch-sheet:cells(i-linha,03):Text)        
               tt-valores.c-Finalidade                        = Trim(ch-sheet:cells(i-linha,04):Text)         
               tt-valores.de-Valor-Original                   = Dec(Trim(ch-sheet:cells(i-linha,05):Text))        
               tt-valores.de-Correcao-Monetaria               = Dec(Trim(ch-sheet:cells(i-linha,06):Text))  
               tt-valores.de-Dpr-Valor-Original               = Dec(Trim(ch-sheet:cells(i-linha,07):Text))
               tt-valores.de-Dpr-Correcao-Monet               = Dec(Trim(ch-sheet:cells(i-linha,08):Text))   
               tt-valores.de-Correcao-Monet-Dpr               = Dec(Trim(ch-sheet:cells(i-linha,09):Text))
               tt-valores.de-Depreciacao-Incentiv             = Dec(Trim(ch-sheet:cells(i-linha,10):Text))    
               tt-valores.de-Dpr-Incentiv-CM                  = Dec(Trim(ch-sheet:cells(i-linha,11):Text))
               tt-valores.de-CM-Dpr-Incentivada               = Dec(Trim(ch-sheet:cells(i-linha,12):Text))
               tt-valores.de-Amortizacao-VO                   = Dec(Trim(ch-sheet:cells(i-linha,13):Text))
               tt-valores.de-Amortizacao-CM                   = Dec(Trim(ch-sheet:cells(i-linha,14):Text))
               tt-valores.de-CM-Amortizacao                   = Dec(Trim(ch-sheet:cells(i-linha,15):Text))
               tt-valores.de-Amortizacao-Incentiv             = Dec(Trim(ch-sheet:cells(i-linha,16):Text))
               tt-valores.de-Amort-Incentiv-CM                = Dec(Trim(ch-sheet:cells(i-linha,17):Text))
               tt-valores.de-CM-Amort-Incentvda               = Dec(Trim(ch-sheet:cells(i-linha,18):Text))
               tt-valores.de-Percentual-Dpr                   = Dec(Trim(ch-sheet:cells(i-linha,19):Text))
               tt-valores.de-Perc-Dpr-Incentivada             = Dec(Trim(ch-sheet:cells(i-linha,20):Text))    
               tt-valores.de-Perc-Dpr-Reducao-Saldo           = Dec(Trim(ch-sheet:cells(i-linha,21):Text)) No-error .
                                                                
            
        If Error-status:Error And Error-status:Num-messages > 0 Then Do:
            l-erro = YES.
            Do i = 1 To Error-status:Num-messages:
               Put Stream str-saida  Unformatted 
                   "Linha com problema: " + string(i-linha) SPACE(5)
                      "C½digo erro: " + String(Error-status:Get-number(i)) SPACE(5)
                      "Descri?’o erro: " ERROR-STATUS:GET-MESSAGE(i) SKIP.
            End.
        End.
    
    End.
    If Not l-erro Then Do:
    

        ch-book:Close(False).
        ch-excel:Quit().   
        
        Release Object ch-sheet No-error.
        Release Object ch-book  No-error.
        Release Object ch-excel No-error.
        
        Output  To Value ("c:\temp\" + "valores.txt").

        For Each tt-valores.
           
            Put Unformatted
                  tt-valores.i-Nro-Sequencial-Bem                        
          " "    tt-valores.i-Sequencia-Incorp                          
          " " trim('"' +  tt-valores.c-Cenario-Contabil  + '"' )                        
          " " trim('"' +  tt-valores.c-Finalidade        + '"' )                  
          " "    tt-valores.de-Valor-Original                     
          " "    tt-valores.de-Correcao-Monetaria                 
          " "    tt-valores.de-Dpr-Valor-Original                 
          " "    tt-valores.de-Dpr-Correcao-Monet                 
          " "    tt-valores.de-Correcao-Monet-Dpr                 
          " "    tt-valores.de-Depreciacao-Incentiv               
          " "    tt-valores.de-Dpr-Incentiv-CM                    
          " "    tt-valores.de-CM-Dpr-Incentivada                 
          " "    tt-valores.de-Amortizacao-VO                     
          " "    tt-valores.de-Amortizacao-CM                     
          " "    tt-valores.de-CM-Amortizacao                     
          " "    tt-valores.de-Amortizacao-Incentiv               
          " "    tt-valores.de-Amort-Incentiv-CM                  
          " "    tt-valores.de-CM-Amort-Incentvda                 
          " "    tt-valores.de-Percentual-Dpr                     
          " "    tt-valores.de-Perc-Dpr-Incentivada               
          " "    tt-valores.de-Perc-Dpr-Reducao-Saldo Skip  .



        End.

        Output Close.
    End.
    
    

End Procedure.
    
Procedure pi-alocacoes: 

    
    Create "Excel.Application" ch-excel.
           ch-book = ch-excel:Workbooks:Add("c:\temp\alocacoes.xls"). 
           ch-sheet = ch-book:worksheets(1).

    Assign i-linha = 1
           l-erro  = No.
    
    For Each tt-alocacoes. Delete tt-alocacoes. End.
    
    Repeat:
    
        i-linha = i-linha + 1.
    
        IF ch-sheet:cells(i-linha, 1):Text = ""  Then Leave.
         
        Create tt-alocacoes.
        Assign tt-alocacoes.i-Nro-Sequencial-Bem            = Int(Trim(ch-sheet:cells(i-linha,01):Text))      
               tt-alocacoes.c-Plano-Centros-Custo           = Trim(ch-sheet:cells(i-linha,02):Text)      
               tt-alocacoes.c-Centro-Custo                  = Trim(ch-sheet:cells(i-linha,03):Text)        
               tt-alocacoes.c-Unid-Negocio                  = Trim(ch-sheet:cells(i-linha,04):Text)         
               tt-alocacoes.de-Perc-Apropriacao             = Dec(Trim(ch-sheet:cells(i-linha,05):Text))        
               tt-alocacoes.l-CCusto-UN-Principal           =  Logical(ch-sheet:cells(i-linha, 06):Text,"yes/no") No-error .
                  
        If Error-status:Error And Error-status:Num-messages > 0 Then Do:
            l-erro = YES.
            Do i = 1 To Error-status:Num-messages:
               Put Stream str-saida  Unformatted 
                   "Linha com problema: " + string(i-linha) SPACE(5)
                      "C½digo erro: " + String(Error-status:Get-number(i)) SPACE(5)
                      "Descri?’o erro: " ERROR-STATUS:GET-MESSAGE(i) SKIP.
            End.
        End.
    
    End.
    If Not l-erro Then Do:
    

        ch-book:Close(False).
        ch-excel:Quit().   
        
        Release Object ch-sheet No-error.
        Release Object ch-book  No-error.
        Release Object ch-excel No-error.
        
        Output  To Value ("c:\temp\" + "alocacoes.txt").

        For Each tt-alocacoes.
            Put Unformatted
                   tt-alocacoes.i-Nro-Sequencial-Bem          
            " " Trim('"' +  tt-alocacoes.c-Plano-Centros-Custo +  '"')            
            " " Trim('"' +  tt-alocacoes.c-Centro-Custo        +  '"')           
            " " Trim('"' +  tt-alocacoes.c-Unid-Negocio        +  '"')          
            " "    tt-alocacoes.de-Perc-Apropriacao         
            " "    tt-alocacoes.l-CCusto-UN-Principal  Skip  .      
                
                
                .
        End.

        Output Close.
    End.
    
    

End Procedure.
    



