/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: return_desc_novas_origens_bgc
** Descricao.............: UPC - Novas Origens BGC
** Versao................: 5.08.00.001
** Nome Externo..........: prgfin/upc/upc_bgc700zg_ext.p
** Criado por............: dvc
** Alterado por..........: dvc
*****************************************************************************/

DEFINE OUTPUT PARAMETER c_desc_novas_origens AS CHARACTER EXTENT 10 NO-UNDO.

ASSIGN c_desc_novas_origens[1]  = "90 - Pedido Expositor"
       c_desc_novas_origens[2]  = "91 - Pedido Emergencial"
       c_desc_novas_origens[3]  = "92 - Verba Cooperada"
       c_desc_novas_origens[4]  = "Descri‡Æo Origem 93"
       c_desc_novas_origens[5]  = "Descri‡Æo Origem 94"
       c_desc_novas_origens[6]  = "Descri‡Æo Origem 95"
       c_desc_novas_origens[7]  = "Descri‡Æo Origem 96"
       c_desc_novas_origens[8]  = "Descri‡Æo Origem 97"
       c_desc_novas_origens[9]  = "Descri‡Æo Origem 98"
       c_desc_novas_origens[10] = "Descri‡Æo Origem 99".

RETURN "OK".
       
