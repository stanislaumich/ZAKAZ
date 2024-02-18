unit PrevInst;

interface
 Uses
  WinProcs,
  WinTypes,
  SysUtils;

type
  PHWnd = ^HWnd;

function Init_Mutex(mid: string): boolean;
//function EnumApps(Wnd: HWnd; TargetWindow: PHWnd): bool; export;

implementation

uses Windows;

var
  mut: thandle;


{  procedure ActivatePreviousInstance;
var
  PrevInstWnd: HWnd;
begin
  PrevInstWnd := 0;
  EnumWindows(@EnumApps, LongInt(@PrevInstWnd));
  if PrevInstWnd <> 0 then
    if IsIconic(PrevInstWnd) then
      ShowWindow(PrevInstWnd, SW_Restore)
    else
      BringWindowToTop(PrevInstWnd);
end;}


function mut_id(s: string): string;
var
  f: integer;
begin
  result := s;
  for f := 1 to length(s) do
    if result[f] = '\' then
      result[f] := '_';
end;

function Init_Mutex(mid: string): boolean;
begin
  Mut := CreateMutex(nil, false, pchar(mut_id(mid)));
  Result := not ((Mut = 0) or (GetLastError = ERROR_ALREADY_EXISTS));
  //if result then ActivatePreviousInstance;
end;

initialization
  mut := 0;
finalization
  if mut <> 0 then
    CloseHandle(mut);
end.
