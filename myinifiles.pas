unit myinifiles;

interface

uses System.SysUtils, inifiles;

procedure createini(s: string);
procedure writeini(s: string; sec: string; v: string);
function readini(s: string; sec: string): string;

implementation

procedure createini(s: string);
var
  ini: tinifile;
begin
  ini := tinifile.Create(extractfilepath(paramstr(0)) + s);
  ini.Free;
end;

procedure writeini(s: string; sec: string; v: string);
var
  ini: tinifile;
begin
  ini := tinifile.Create(extractfilepath(paramstr(0)) + s);
  ini.WriteString('', sec, v);
  ini.Free;
end;

function readini(s: string; sec: string): string;
var
  ini: tinifile;
  r: string;
begin
  ini := tinifile.Create(extractfilepath(paramstr(0)) + s);
  r := ini.ReadString('', sec, '');
  ini.Free;
  readini := r;
end;

end.
