unit UGSCatcher;

{***} interface {***}

uses Classes, SysUtils, JPEG;

type
  TgsCatcher = class(TComponent)
  private
    FEnabled: boolean;
    FGenerateScreenshot: boolean;
    FJPEGScreenshot: boolean;
    FJpegQuality: TJPEGQualityRange;
    FCollectInfo: boolean;
    Fn: TFilename;
    fcount: cardinal;
    procedure SetEnabled(const Value: boolean);
    { Private declarations }
  protected
    { Protected declarations }
    procedure EnableCatcher;
    procedure DisableCatcher;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Catcher(Sender: TObject; E: Exception);
    procedure DoGenerateScreenshot;
    function CollectUserName: string;
    function CollectComputerName: string;
    procedure DoCollectInfo(E: Exception);
  published
    { Published declarations }
    property Enabled: boolean read FEnabled write SetEnabled
      default False;
  end;

procedure Register;

{***} implementation {***}

uses Windows, Forms, Dialogs, Graphics;

function CreateDirEx(Dir: string): Boolean;
var
  I, L: Integer;
  CurDir: string;
begin
  if ExcludeTrailingBackslash(Dir) = '' then
    exit;
  Dir := IncludeTrailingBackslash(Dir);
  L := Length(Dir);
  for I := 1 to L do
  begin
    CurDir := CurDir + Dir[I];
    if Dir[I] = '\' then
    begin
      if not DirectoryExists(CurDir) then
        if not CreateDir(CurDir) then
          Exit;
    end;
  end;
  Result := True;
end;

procedure Register;
begin
  RegisterComponents('Gsk Prog', [TgsCatcher]);
end;

{ TgsCatcher }

constructor TgsCatcher.Create(AOwner: TComponent);
begin
  inherited;
  Createdirex(extractfilepath(paramstr(0))+'DEBUG');

  Fn := extractfilepath(paramstr(0))
  +'DEBUG\'
  +ExtractFilename(paramstr(0))+'_'
  {+Screen.ActiveForm.Name+'_'{}
  +FormatDateTime('dd-mm-yyyy_hh-nn-ss',now)
  +'_debug';
end;

destructor TgsCatcher.Destroy;
begin
  DisableCatcher;
  inherited;
end;

procedure TgsCatcher.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  if Enabled then
    EnableCatcher
  else
    DisableCatcher;
end;

procedure TgsCatcher.DisableCatcher;
begin
  Application.OnException := nil;
end;

procedure TgsCatcher.EnableCatcher;
begin
  Application.OnException := Catcher;
end;

function TgsCatcher.CollectUserName: string;
var
  uname: pchar;
  unsiz: cardinal;
begin
  uname := StrAlloc(255);
  unsiz := 254;
  GetUserName(uname, unsiz);
  if (unsiz > 0) then
    Result := string(uname)
  else
    Result := 'n/a';
  StrDispose(uname);
end;

procedure TgsCatcher.DoGenerateScreenshot;
var
  bmp: TBitmap;
  jpg: TJPEGImage;
begin
  bmp := Screen.ActiveForm.GetFormImage;
  begin
    jpg := TJPEGImage.Create;
    jpg.CompressionQuality := 100;
    jpg.Assign(bmp);
    jpg.SaveToFile(fn + '.jpg');
    FreeAndNil(jpg);
  end;
  FreeAndNil(bmp);
end;

function TgsCatcher.CollectComputerName: string;
var
  cname: pchar;
  cnsiz: cardinal;
begin
  cname := StrAlloc(MAX_COMPUTERNAME_LENGTH + 1);
  cnsiz := MAX_COMPUTERNAME_LENGTH + 1;
  GetComputerName(cname, cnsiz);
  if (cnsiz > 0) then
    Result := string(cname)
  else
    Result := 'n/a';
  StrDispose(cname);
end;

procedure TgsCatcher.DoCollectInfo(E: Exception);
var
  sl: TStringList;
begin
  sl := tstringlist.Create;
  sl.add('--- This report is created by automated reporting system.');
  sl.add('Computer name is: [ ' + CollectComputerName + ' ]');
  sl.add('User name is: [ ' + CollectUserName + ' ]');
  sl.Add('Error Message is: [ '+e.Message+' ]');
  sl.add('--- End of report ---------------------------------------');
  sl.SaveToFile(Fn + '.txt');
  DoGenerateScreenshot;
end;

procedure TgsCatcher.Catcher(Sender: TObject; E: Exception);
begin
 DoCollectInfo(E);
 DoGenerateScreenshot;
 ShowMessage('Внимание! Произошла ошибка и операция не выполнена.'+#10+#13+'Сведения об ошибке и скриншот находятся в папке DEBUG в папке программы'+#10+#13+'Как правило это C:\KVA_PROG\PROGRAMM\DEBUG');
end;

end.

