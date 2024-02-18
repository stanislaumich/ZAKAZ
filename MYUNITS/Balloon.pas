unit Balloon;
 
interface
 
uses Windows, SysUtils, ShellAPI;
 
type
  NotifyIconData_50 = record // ����������� � shellapi.h
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..MAXCHAR] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..MAXBYTE] of AnsiChar;
    uTimeout: UINT; // union with uVersion: UINT;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end{record};
 
const
  NIF_INFO      =        $00000010;
  NIIF_NONE     =        $00000000;
  NIIF_INFO     =        $00000001;
  NIIF_WARNING  =       $00000002;
  NIIF_ERROR    =        $00000003;
 
//� ��� ����� ��������������� �����:
 
type
  TBalloonTimeout = 10..30{seconds};
  TBalloonIconType = (bitNone,    // ��� ������
                      bitInfo,    // �������������� ������ (�����)
                      bitWarning, // ������ ����������� (�����)
                      bitError);  // ������ ������ (�������)
 
//������ �� ������ ���������� � �������� ���������� ���������!
 
//��� ����� ������������� ��������� ��������:
 
function DZBalloonTrayIcon(const Window: HWND; const IconID: Byte; const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle: String; Tip: string;const BalloonIconType: TBalloonIconType): Boolean;
function DZAddTrayIcon(const Window: HWND; const IconID: Byte; const Icon: HICON; const Hint: String = ''): Boolean;
function DZAddTrayIconMsg(const Window: HWND; const IconID: Byte; const Icon: HICON; const Msg: Cardinal; const Hint: String = ''): Boolean;
function DZRemoveTrayIcon(const Window: HWND; const IconID: Byte): Boolean;

function DZModifyTrayIcon(hWindow: THandle; ID: Cardinal; Flags: Cardinal;
              ICON: hIcon; Tip: PChar): Boolean;

implementation
 
//uses SysUtils, Windows, ShellAPI;
 
function DZBalloonTrayIcon(const Window: HWND; const IconID: Byte; const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle: String;Tip : string; const BalloonIconType: TBalloonIconType): Boolean;
const
  aBalloonIconTypes : array[TBalloonIconType] of Byte = (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR);
var
  NID_50 : NotifyIconData_50;
begin
  FillChar(NID_50, SizeOf(NotifyIconData_50), 0);
  with NID_50 do begin
    cbSize := SizeOf(NotifyIconData_50);
    Wnd := Window;
    uID := IconID;
    uFlags := NIF_INFO;
    StrPCopy(szInfo, BalloonText);
    uTimeout := Timeout * 1000;
    StrPCopy(szInfoTitle, BalloonTitle);
    StrPCopy(szTip, Tip);
    dwInfoFlags := aBalloonIconTypes[BalloonIconType];
  end{with};
  Result := Shell_NotifyIcon(NIM_MODIFY, @NID_50);
end;
 
//���������� ��� ��������� �������:
 
//DZBalloonTrayIcon(Form1.Handle, 1, 10, 'this is the balloon text', 'title', bitWarning);
 
//������, ������ ���� �������������� ��������� � ����� ������������ ���� � IconID (� ������ ������� Form1.Handle � 1).



// ������� ���� � ������
function DZModifyTrayIcon(hWindow: THandle; ID: Cardinal; Flags: Cardinal;
              ICON: hIcon; Tip: PChar): Boolean;
var
  NID: TNotifyIconData;
begin
  FillChar(NID, SizeOf(TNotifyIconData), 0);
  with NID do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd    := hWindow;
    uID    := ID;
    uFlags := Flags;
    hIcon  := Icon;
    StrPCopy(szTip, Tip);
  end;
  Result := Shell_NotifyIcon(NIM_MODIFY, @NID);
end;

function DZAddTrayIcon(const Window: HWND; const IconID: Byte; const Icon: HICON; const Hint: String = ''): Boolean;
var
  NID : NotifyIconData;
begin
  FillChar(NID, SizeOf(NotifyIconData), 0);
  with NID do begin
    cbSize := SizeOf(NotifyIconData);
    Wnd := Window;
    uID := IconID;
    if Hint = '' then begin
      uFlags := NIF_ICON;
    end{if} else begin
      uFlags := NIF_ICON or NIF_TIP;
      StrPCopy(szTip, Hint);
    end{else};
    hIcon := Icon;
  end{with};
  Result := Shell_NotifyIcon(NIM_ADD, @NID);
end;
 
{��������� ������ � call-back ����������}
function DZAddTrayIconMsg(const Window: HWND; const IconID: Byte; const Icon: HICON; const Msg: Cardinal; const Hint: String = ''): Boolean;
var
  NID : NotifyIconData;
begin
  FillChar(NID, SizeOf(NotifyIconData), 0);
  with NID do begin
    cbSize := SizeOf(NotifyIconData);
    Wnd := Window;
    uID := IconID;
    if Hint = '' then begin
      uFlags := NIF_ICON or NIF_MESSAGE;
    end{if} else begin
      uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
      StrPCopy(szTip, Hint);
    end{else};
    uCallbackMessage := Msg;
    hIcon := Icon;
  end{with};
  Result := Shell_NotifyIcon(NIM_ADD, @NID);
end;
 
{������� ������}
function DZRemoveTrayIcon(const Window: HWND; const IconID: Byte): Boolean;
var
  NID : NotifyIconData;
begin
  FillChar(NID, SizeOf(NotifyIconData), 0);
  with NID do begin
    cbSize := SizeOf(NotifyIconData);
    Wnd := Window;
    uID := IconID;
  end{with};
  Result := Shell_NotifyIcon(NIM_DELETE, @NID);
end;
 
 
end.
 