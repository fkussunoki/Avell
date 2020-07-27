/*******************************************************************************
**
**  include/i-tab.i: Include para evento de tab e back-tab para browses de zoom, 
**                   que posuem o evento de anykey, utilizando a include 
**                   i-anykey.i
**
*******************************************************************************/

DEFINE VARIABLE deTimeAux    AS DECIMAL NO-UNDO.
DEFINE VARIABLE mpSystemTime AS MEMPTR  NO-UNDO.

SET-SIZE(mpSystemTime) = 20.

RUN GetSystemTime (OUTPUT mpSystemTime).
ASSIGN deTimeAux = (GET-SHORT(mpSystemTime, 9) * 3600000) + /* Horas */
                   (GET-SHORT(mpSystemTime, 11) * 60000) +  /* Minutos */
                   (GET-SHORT(mpSystemTime, 13) * 1000) +   /* Segundo */
                   (GET-SHORT(mpSystemTime, 15)).           /* Milisegundos */

SET-SIZE(mpSystemTime) = 0.

IF deTimeAux - deTime < 1500 THEN /* > 1 OR >= 1 */
    RETURN NO-APPLY.

/* include/i-tab.i */
