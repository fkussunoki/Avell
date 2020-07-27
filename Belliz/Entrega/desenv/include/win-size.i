/***********************************************************************
**
**  WIN-SIZE.I - Realiza o ajuste no tamanho da window e da frame
**               igualando ambos
*************************************************************************/

if {&window-name}:width-chars < frame {&frame-name}:width-chars then
    assign frame {&frame-name}:width-chars = {&window-name}:width-chars.
else if frame {&frame-name}:width-chars < {&window-name}:width-chars then
    assign {&window-name}:width-chars = frame {&frame-name}:width-chars.

if {&window-name}:height-chars < frame {&frame-name}:height-chars then
    assign frame {&frame-name}:height-chars = {&window-name}:height-chars.
else if frame {&frame-name}:height-chars < {&window-name}:height-chars then
    assign {&window-name}:height-chars = frame {&frame-name}:height-chars.

assign {&window-name}:virtual-width-chars  = {&window-name}:width-chars
       {&window-name}:virtual-height-chars = {&window-name}:height-chars
       {&window-name}:min-width-chars      = {&window-name}:width-chars
       {&window-name}:max-width-chars      = {&window-name}:width-chars
       {&window-name}:min-height-chars     = {&window-name}:height-chars
       {&window-name}:max-height-chars     = {&window-name}:height-chars.

/* win-size.i */
