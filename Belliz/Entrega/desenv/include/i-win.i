    /* ---------------------------------------------------------------------------------------------------
   Autor      : Medeiros
   Data       : 01/Dez/97
   Objetivo   : Include usada nos programas que fazem interface 
                con a API do windows.
    
   Parametros : Nenhum.
--------------------------------------------------------------------------------- */

&IF DEFINED(WINDOWS_I)=0 &THEN
&GLOBAL-DEFINE WINDOWS_I
  
    /* 32-bit definitions, Progress 8.2+ */

    /* data types */
   &Glob HWND long
   &Glob BOOL long
   &Glob HINSTANCE long
   &Glob INT long
   &GLOB INTSIZE 4
    /* libraries */
   &GLOB USER   "user32":U
   &GLOB KERNEL "kernel32":U
   &GLOB SHELL  "shell32":U
   &GLOB MAPI   "mapi32":U
   &GLOB GDI    "gdi32":U
   &GLOB MMEDIA "winmm":U
   &GLOB A A
/* messages */
&Glob WM_PAINT 15
&Glob WM_HSCROLL 276
&Glob WM_VSCROLL 277
&Glob WM_LBUTTONDOWN 513
&Glob WM_LBUTTONUP 514
&Glob WM_RBUTTONDOWN 516
&Glob WM_RBUTTONUP 517
&GLOB WM_USER 1024
/* mouse buttons */
&Glob MK_LBUTTON 1
&Glob MK_RBUTTON 2
/* scrollbars */
&Glob SB_HORZ 0
&Glob SB_VERT 1
&Glob SB_BOTH 3
&Glob SB_THUMBPOSITION 4
/* editors */
   &GLOB EM_SETPASSWORDCHAR 204
/* some window styles */
&GLOB GWL_STYLE -16
&GLOB WS_DLGFRAME 4194304
&GLOB WS_SYSMENU 524288
&GLOB WS_MAXIMIZEBOX 65536
&GLOB WS_MINIMIZEBOX 131072
&GLOB WS_THICKFRAME  262144
&GLOB WS_CAPTION 12582912
&GLOB WS_BORDER 8388608
/* some extended window styles */
&GLOB GWL_EXSTYLE -20
&GLOB WS_EX_CONTEXTHELP 1024
&GLOB WS_EX_PALETTEWINDOW 392
&GLOB WS_EX_DLGMODALFRAME 1
/* system commands/menu */
&GLOB SC_SIZE      61440  
&GLOB SC_MINIMIZE  61472
&GLOB SC_MAXIMIZE  61488  
&GLOB MF_BYCOMMAND 0
&GLOB MF_BYPOSITION 1024
&GLOB MF_REMOVE 256

/* placement order (Z-order) */
&GLOB HWND_TOPMOST -1
&GLOB HWND_NOTOPMOST -2
 
/* window-positioning flags */
&GLOB SWP_NOSIZE 1
&GLOB SWP_NOMOVE 2
&GLOB SWP_NOZORDER 4
&GLOB SWP_NOACTIVATE 16 
&GLOB SWP_FRAMECHANGED 32
&GLOB SWP_SHOWWINDOW 64
/* get a handle to the procedure definitions */
&IF DEFINED(DONTDEFINE-HPAPI)=0 &THEN
   DEFINE NEW GLOBAL SHARED VARIABLE hpApi AS HANDLE NO-UNDO.
    IF NOT VALID-HANDLE(hpApi) OR
          hpApi:TYPE <> "PROCEDURE":U OR 
          hpApi:FILE-NAME <> "utp/ut-win.p":U THEN 
      RUN utp/ut-win.p PERSISTENT SET hpApi.
    /* forward function declarations. Must not be included in windows.p : */
   {include/i-func.i}
&ENDIF
&ENDIF   /* &IF DEFINED(WINDOWS_I)=0 */

