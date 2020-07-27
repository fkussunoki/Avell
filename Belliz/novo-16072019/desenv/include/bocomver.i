procedure compareVersion:
   define input  parameter c-versao as char    no-undo.
   define output parameter l-ok     as logical no-undo.
   if c-versao = "{&VERSION}" THEN assign l-version = true.
   assign l-ok = l-version.
end procedure.
