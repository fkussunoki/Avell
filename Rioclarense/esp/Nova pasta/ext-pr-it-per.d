ADD TABLE "ext-pr-it-per"
  AREA "d-geral"
  LABEL "ExtensÆo pr-it-per"
  DESCRIPTION "Tabela de extensÆo da pr-it-per, para compor novo m‚dio sem bonifica‡äes"
  DUMP-NAME "ext-pr-it-per"

ADD FIELD "periodo" OF "ext-pr-it-per" AS date 
  FORMAT "99/99/9999"
  INITIAL ?
  LABEL "Periodo"
  POSITION 2
  MAX-WIDTH 4
  COLUMN-LABEL "Periodo"
  ORDER 10

ADD FIELD "it-codigo" OF "ext-pr-it-per" AS character 
  FORMAT "x(16)"
  INITIAL ""
  LABEL "Item"
  POSITION 3
  MAX-WIDTH 32
  COLUMN-LABEL "Item"
  ORDER 20

ADD FIELD "cod-estabel" OF "ext-pr-it-per" AS character 
  FORMAT "x(5)"
  INITIAL ""
  LABEL "Estabelecimento"
  POSITION 4
  MAX-WIDTH 10
  COLUMN-LABEL "Estabelecimento"
  ORDER 30

ADD FIELD "quantidade" OF "ext-pr-it-per" AS decimal 
  FORMAT ">>>>,>>>,>>9.9999999999"
  INITIAL "0"
  POSITION 5
  MAX-WIDTH 25
  DECIMALS 10
  ORDER 40

ADD FIELD "valor" OF "ext-pr-it-per" AS decimal 
  FORMAT ">>>>,>>>,>>9.9999999999"
  INITIAL "0"
  LABEL "Valor"
  POSITION 6
  MAX-WIDTH 25
  COLUMN-LABEL "Valor"
  DECIMALS 10
  ORDER 50

ADD FIELD "int-1" OF "ext-pr-it-per" AS integer 
  FORMAT "->>>,>>>,>>>,>>9"
  INITIAL "0"
  POSITION 7
  MAX-WIDTH 4
  ORDER 60

ADD FIELD "int-2" OF "ext-pr-it-per" AS integer 
  FORMAT "->>>,>>>,>>>,>>9"
  INITIAL "0"
  POSITION 8
  MAX-WIDTH 4
  ORDER 70

ADD FIELD "char-1" OF "ext-pr-it-per" AS character 
  FORMAT "x(256)"
  INITIAL ""
  POSITION 9
  MAX-WIDTH 512
  ORDER 80

ADD FIELD "char-2" OF "ext-pr-it-per" AS character 
  FORMAT "x(256)"
  INITIAL ""
  POSITION 10
  MAX-WIDTH 512
  ORDER 90

ADD FIELD "date-1" OF "ext-pr-it-per" AS date 
  FORMAT "99/99/9999"
  INITIAL ?
  POSITION 11
  MAX-WIDTH 4
  ORDER 100

ADD FIELD "date-2" OF "ext-pr-it-per" AS date 
  FORMAT "99/99/9999"
  INITIAL ?
  POSITION 12
  MAX-WIDTH 4
  ORDER 110

ADD FIELD "dec-1" OF "ext-pr-it-per" AS decimal 
  FORMAT "->>,>>9.99"
  INITIAL "0"
  POSITION 13
  MAX-WIDTH 17
  DECIMALS 2
  ORDER 120

ADD FIELD "dec-2" OF "ext-pr-it-per" AS decimal 
  FORMAT "->>,>>9.99"
  INITIAL "0"
  POSITION 14
  MAX-WIDTH 17
  DECIMALS 2
  ORDER 130

ADD FIELD "log-1" OF "ext-pr-it-per" AS logical 
  FORMAT "Sim/NÆo"
  INITIAL "Sim"
  POSITION 15
  MAX-WIDTH 1
  ORDER 140

ADD FIELD "log-2" OF "ext-pr-it-per" AS logical 
  FORMAT "Sim/NÆo"
  INITIAL "Sim"
  POSITION 16
  MAX-WIDTH 1
  ORDER 150

ADD FIELD "preco-medio" OF "ext-pr-it-per" AS decimal 
  FORMAT ">>>>,>>>,>>9.9999999999"
  INITIAL "0"
  LABEL "Pre‡o M‚dio"
  POSITION 17
  MAX-WIDTH 25
  COLUMN-LABEL "Pre‡o M‚dio"
  DECIMALS 10
  ORDER 160

ADD INDEX "idx-ext-pr-it-per" ON "ext-pr-it-per" 
  AREA "i-geral"
  UNIQUE
  PRIMARY
  INDEX-FIELD "periodo" ASCENDING 
  INDEX-FIELD "it-codigo" ASCENDING 
  INDEX-FIELD "cod-estabel" ASCENDING 

.
PSC
cpstream=ibm850
.
0000002885
