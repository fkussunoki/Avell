&if "{&emsbas_version}" >= "5.06" &then
   &global-define FNC_MULTI_IDIOMA YES


    FUNCTION getStrTrans RETURNS CHARACTER ( INPUT pString  AS CHARACTER,
                                             INPUT pContext AS CHARACTER) 
    &if "{1}" = "" &then IN h_facelift &else {1} &endif .

    FUNCTION getStrTransSp RETURNS CHARACTER ( INPUT pString  AS CHARACTER,
                                               INPUT pContext AS CHARACTER,
                                               INPUT pSpace   AS CHARACTER)
    &if "{1}" = "" &then IN h_facelift &else {1} &endif .

    FUNCTION getLstItTrans RETURNS CHARACTER ( INPUT pAddItemPairs AS LOGICAL,
                                               INPUT pListItems    AS CHARACTER,
                                               INPUT pContext      AS CHARACTER)
    &if "{1}" = "" &then IN h_facelift &else {1} &endif .

    FUNCTION getLstItUndoTrans RETURNS CHARACTER ( INPUT pDelItemPairs AS LOGICAL,
                                                   INPUT pListItems    AS CHARACTER)
    &if "{1}" = "" &then IN h_facelift &else {1} &endif .
                  
    def new global shared var v_cod_modul_dtsul_multi as char format "x(3)":U no-undo.

    def var v_des_return_value_editor as char no-undo.
&endif

&if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    &global-define UI_VIEW_AS_TOGGLE  view-as toggle-box
    &global-define UI_VIEW_AS_COMBO   view-as combo-box
    &global-define UI_LIST_ITEM_PAIRS list-item-pairs
&else
    &global-define VIEW-AS-TOGGLE-BOX 
    &global-define UI_VIEW_AS_COMBO   
    &global-define UI_LIST_ITEM_PAIRS list-items
&endif
