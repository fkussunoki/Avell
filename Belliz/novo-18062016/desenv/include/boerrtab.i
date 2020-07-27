/****
 * Modifica para permitir aos programadores informarem  parƒmetros do help
 *
 */
    DEFINE TEMP-TABLE tt-bo-erro no-undo
                      field i-sequen as int
                      field cd-erro  as int
                      field mensagem as char format "x(255)"
                      field parametros as char format "x(255)" init ""
                      field errortype as char format "x(20)"
                      field errorhelp as char format "x(20)"
                      field errorsubtype as character.
