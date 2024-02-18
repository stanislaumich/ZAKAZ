unit NotifyIcon;
{Example - Programm BELARUSBANK}
interface

uses
  Windows, Messages;

const
  {$EXTERNALSYM NIN_BALLOONSHOW}
  NIN_BALLOONSHOW       = WM_USER + 2;
  {$EXTERNALSYM NIN_BALLOONHIDE}
  NIN_BALLOONHIDE       = WM_USER + 3;
  {$EXTERNALSYM NIN_BALLOONTIMEOUT}
  NIN_BALLOONTIMEOUT    = WM_USER + 4;
  {$EXTERNALSYM NIN_BALLOONUSERCLICK}
  NIN_BALLOONUSERCLICK  = WM_USER + 5;

  {$EXTERNALSYM NIF_INFO}
  NIF_INFO       = $00000010;
  {$EXTERNALSYM NIIF_NONE}
  NIIF_NONE      = $00000000;
  {$EXTERNALSYM NIIF_INFO}
  NIIF_INFO      = $00000001;
  {$EXTERNALSYM NIIF_WARNING}
  NIIF_WARNING   = $00000002;
  {$EXTERNALSYM NIIF_ERROR}
  NIIF_ERROR     = $00000003;
  {$EXTERNALSYM NIIF_USER}
  NIIF_USER      = $00000004;
  {$EXTERNALSYM NIIF_ICON_MASK}
  NIIF_ICON_MASK = $0000000F;
  {$EXTERNALSYM NIIF_NOSOUND}
  NIIF_NOSOUND   = $00000010;

type
  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconData = PNotifyIconDataA;
  {$EXTERNALSYM _NOTIFYICONDATAA}
  _NOTIFYICONDATAA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of AnsiChar;
    case Integer of
      0: (
        uTimeout: UINT;
        szInfoTitle : array [0..63] of AnsiChar;
        dwInfoFlags: DWORD;
        guidItem: TGUID);
      1: (
        uVersion: UINT);
  end;
  {$EXTERNALSYM _NOTIFYICONDATA}
  _NOTIFYICONDATA = _NOTIFYICONDATAA;
  TNotifyIconDataA = _NOTIFYICONDATAA;
  TNotifyIconData = TNotifyIconDataA;
  {$EXTERNALSYM NOTIFYICONDATAA}
  NOTIFYICONDATAA = _NOTIFYICONDATAA;
  {$EXTERNALSYM NOTIFYICONDATA}
  NOTIFYICONDATA = NOTIFYICONDATAA;

implementation

end.
