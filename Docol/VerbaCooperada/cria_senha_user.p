DEF VAR c-frase AS CHAR.
DEF VAR r-cripto AS RAW.
DEF VAR c-cripto AS CHAR.

ASSIGN c-frase = string(month(TODAY),"99") + "SDV&2.0" + string(YEAR(TODAY)) + string(808).
ASSIGN r-cripto = md5-DIGEST(c-frase).
ASSIGN c-cripto = HEX-ENCODE(r-cripto). 


disp c-cripto.