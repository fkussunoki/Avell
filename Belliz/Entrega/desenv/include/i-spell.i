  /***************************************************************
**
** I-EDITOR.I - Include para definir imagem para 
**              corre»’o ortogrÿfica
** 
***************************************************************/

on  any-printable of {1} do:
    if  l-control-spell = no then do:
        if  {2}:load-image("image~\im-ednok.bmp":U) in frame {&frame-name} then.
    end.
    assign l-control-spell = yes.
end.
on  choose of {2} do:
    run utp/ut-spell.p (input {1}:handle in frame {&frame-name}).
    if  {2}:load-image("image~\im-edok.bmp":U) in frame {&frame-name} then.
    assign l-control-spell = no.
end.
