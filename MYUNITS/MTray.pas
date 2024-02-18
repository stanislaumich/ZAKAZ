unit MTray;

interface
 Uses
  Windows,
  Messages,
  sysutils,
  classes,
  Graphics,
  ShellApi,
  qdialogs,
  forms,
  StdCtrls, ExtCtrls, controls;

CONST
  WM_USER = 500000;
  WM_NOTIFYTRAYICON = WM_USER + 1;
  NIF_INFO = $10;
  NIF_MESSAGE = 1;
  NIF_ICON = 2;
  NOTIFYICON_VERSION = 3;
  NIF_TIP = 4;
  NIM_SETVERSION = $00000004;
  NIM_SETFOCUS = $00000003;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;
  NIN_BALLOONSHOW = WM_USER + 2;
  NIN_BALLOONHIDE = WM_USER + 3;
  NIN_BALLOONTIMEOUT = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  NIN_SELECT = WM_USER + 0;
  NINF_KEY = $1;
  NIN_KEYSELECT = NIN_SELECT or NINF_KEY;
  //TRAY_CALLBACK = WM_USER + $7258;
//========================================================================
TYPE
 TDUMMYUNIONNAME    = record
    case Integer of
      0: (uTimeout: UINT);
      1: (uVersion: UINT);
  end;
TNewNotifyIconData = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of Char;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of Char;
    DUMMYUNIONNAME: TDUMMYUNIONNAME;
    szInfoTitle: array [0..63] of Char;
    dwInfoFlags: DWORD;
  end;
VAR
 IconData:TnewNotifyIconData;
 TrIcon :TIcon;
 szTip:pchar;
//=======================================================================
procedure ShowBalloonTips(s1,s2:string);
procedure AddSysTrayIcon(p:twndmethod; tmsg:cardinal);
procedure DeleteSysTrayIcon;
procedure _SysTrayIconMsgHandler(var Msg: TMessage; var app : tapplication; frm:tform);

//=======================================================================
implementation
{ пример обработчика который нужно разместить внутри описания формы
}


procedure _SysTrayIconMsgHandler(var Msg: TMessage; var app : tapplication; frm:tform);
var
P: Pointer;
i,j:integer;
appr: tapplication;
begin
  p:=app;
  appr:=tapplication(p);
  case Msg.lParam of
    WM_MOUSEMOVE:;
    WM_LBUTTONDOWN:begin
                      Application.ShowMainForm := True;
                      //Восстанавливаем приложение
                      frm.Perform(wm_SysCommand, sc_Restore, 0);
                      //Гарантируем правильную перерисовку всех компонентов
                      frm.Show;
                      //Убираем временного обработчика события чтобы не вызывался в будущем
                      Application.OnRestore := nil;
                   end;
    WM_LBUTTONUP:;
    WM_LBUTTONDBLCLK:;
    WM_RBUTTONDOWN:begin
                     frm.Hide;
                     //Application.CreateHandle;
                     ShowWindow(Appr.Handle, SW_HIDE);
                     Appr.ShowMainForm := FALSE;
                   end;
    WM_RBUTTONUP:;
    WM_RBUTTONDBLCLK:;
    NIN_BALLOONSHOW:;
    //ShowMessage('NIN_BALLOONSHOW');
    NIN_BALLOONHIDE:;
    //ShowMessage('NIN_BALLOONHIDE');
    NIN_BALLOONTIMEOUT:;
    //ShowMessage('NIN_BALLOONTIMEOUT');
    NIN_BALLOONUSERCLICK:;
  end;
end;

//-----------------------------------------------------------------------
procedure ShowBalloonTips(s1,s2:string);
var
  TipInfo, TipTitle: string;
  //icondata: TnewNotifyIconData;
begin
  IconData.cbSize := SizeOf(IconData);
  IconData.uFlags := NIF_INFO;
  TipInfo := s1;
  strPLCopy(IconData.szInfo, TipInfo, SizeOf(IconData.szInfo) - 1);
  IconData.DUMMYUNIONNAME.uTimeout := 3000;
  TipTitle := s2;
  strPLCopy(IconData.szInfoTitle, TipTitle, SizeOf(IconData.szInfoTitle) - 1);
  IconData.dwInfoFlags := NIIF_INFO;     //NIIF_ERROR;  //NIIF_WARNING;
  Shell_NotifyIcon(NIM_MODIFY, @IconData);
  IconData.DUMMYUNIONNAME.uVersion := NOTIFYICON_VERSION;
  {if not} Shell_NotifyIcon(NIM_SETVERSION, @IconData) {then
    ShowMessage('Error, setversion fail');}
end;
//-----------------------------------------------------------------------
procedure DeleteSysTrayIcon;
begin
  DeallocateHWnd(IconData.Wnd);
  {if not} Shell_NotifyIcon(NIM_DELETE, @IconData) {then
    ShowMessage('Error, delete fail');}
end;

//-----------------------------------------------------------------------
procedure AddSysTrayIcon(p:twndmethod; tmsg:cardinal);
var
 Ic: TIcon;
begin
  //Ic := TIcon.Create;
  //Ic.LoadFromFile('Icon3.ico');
  IconData.cbSize := SizeOf(IconData);
  IconData.Wnd := AllocateHWnd(p);
  IconData.uID := 0;
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  IconData.uCallbackMessage := tmsg;
  //IconData.hIcon := Ic.Handle;
  IconData.hIcon := TrIcon.Handle;
  IconData.szTip := 'Напоминалка';
  //Ic.Destroy;
  Shell_NotifyIcon(NIM_ADD, @IconData);
  //if not Shell_NotifyIcon(NIM_ADD, @IconData) then
  //  ShowMessage('Error add icon, fail');
end;

end.
