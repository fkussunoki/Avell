/* 
   Esta include n�oo ser� mais utilizada, pois agora a execu��o do programa do 
   facelift � armazenado em um handle global, n�o sendo necess�rio exclu�-lo.
   Precisamos exped�-la porque os programas do EMS 5 possuem chamadas para essa
   include. At� a libera��o do 5.06, tentaremos remover as chamadas para essa
   include nos programas.
 
 &if "{&emsbas_version}" >= "5.06" &then
    delete procedure h_facelift.
&endif 
*/
