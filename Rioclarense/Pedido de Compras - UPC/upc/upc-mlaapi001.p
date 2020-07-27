
/*{method/dbotterr.i}*/
{include/i-epc200.i1}
/*{include/tt-edit.i}
{include/pi-edit.i}
{cdp/cdcfgdis.i}*/

/************************************
*   definicao de parametros 
************************************/
DEF INPUT PARAM                  p-ind-event  AS CHAR NO-UNDO.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

 if p-ind-event = "send-email" then do:
 
 
 return "nok".
 
 
