IF LINE-COUNTER >= 63 THEN DO:

    PUT "+------------------------------------------------------------------------------+" SKIP(5).
    PUT "RESUMO GERAL DA OPERA��O - Continua��o PLANILHA N�. " i-ult-fech[1]               SKIP
        "+------------------------------------------------------------------------------+" SKIP
        "!"
        "DATA DA OPERA��O " da-data-ax /*[2]*/ " EQUALIZA��O NO ATO " TO 75 "!" TO 80              SKIP
        "!" " VALOR "     TO 20   
        " PRAZO EM DIAS " TO 44  
        " TAXA BANCO "    TO 67 
        "!"               TO 80
        SKIP 
        "!" "!"           TO 80 
        SKIP.                   
END.


