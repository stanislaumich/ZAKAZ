unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,// Windows,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, UDM, Vcl.Grids, Vcl.DBGrids, myinifiles;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    BitBtn2: TBitBtn;
    DBGrid2: TDBGrid;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox2: TGroupBox;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    StringGrid1: TStringGrid;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//procedure SetKeyboardLayout(const primary LangID, subLangID: Word);//overload;

CONST
  inifile = 'settings.ini';

var
  Form1: TForm1;
  zakazpath:string;



  const
  CNT_LAYOUT = 2; // ���������� ��������� ���������
  ENGLISH = $409;
  RUSSIAN = $419;

  TKbdValue : array [1..CNT_LAYOUT] of LongWord =
                ( ENGLISH,
                  RUSSIAN
                );
  TKbdDisplayNames : array [1..CNT_LAYOUT] of string =
                ('English',
                 '�������'
                );






implementation

{$R *.dfm}
{----- ���������� ���� ��������� � ������� -----}

{�������� �������� ���������}
function NameKeyboardLayout(layout : LongWord) : string;
var
  i: integer;
begin
  Result:='';
  try
    for i:=1 to CNT_LAYOUT do
      if TKbdValue[i]=layout then Result:= TKbdDisplayNames[i];
  except
    Result:='';
  end;
end;
//**************** end of NameKeyboardLayot ***************************
{�������� ��������� � ����� ���������}
function GetActiveKbdLayout : LongWord;
begin
  result:= GetKeyboardLayout(0) shr $10;
end;
//***************** end of GetActiveKbdLayot ****************************
{�������� ��������� � �������� ����}
function GetActiveKbdLayoutWnd : LongWord;
var
  hWindow,idProcess : THandle;
begin
  // �������� handle ��������� ���� ����� ���������
  hWindow := GetForegroundWindow;
  // �������� ������������� ������ ��������
  idProcess := GetWindowThreadProcessId(hWindow,nil);
  // �������� ������� ��������� � ����� ���������
  Result:=(GetKeyboardLayout(idProcess) shr $10);
end;
//***************** end of GetActiveKbdLayotWnd **************************
{���������� ��������� � ����� ���������}
procedure SetKbdLayout(kbLayout : LongWord);
var
  Layout: HKL;
begin
  // �������� ������ �� ���������
  Layout:=LoadKeyboardLayout(PChar(IntToStr(kbLayout)), 0);
  // ����������� ��������� �� �������
  ActivateKeyboardLayout(Layout,KLF_ACTIVATE);
end;
//****************** end of SetKbdLayot **********************************
{���������� ��������� � �������� ����}
procedure SetLayoutActiveWnd(kbLayout : LongWord);
var
  Layout: HKL;
  hWindow{, idProcess} : THandle; // ION T: �� ������������
begin
  // �������� handle ��������� ���� ����� ���������
  hWindow := GetForegroundWindow;
  // �������� ������ �� ���������
  Layout:=LoadKeyboardLayout(PChar(IntToStr(kbLayout)), 0);
  // �������� ��������� � ����� ���������
  sendMessage(hWindow,WM_INPUTLANGCHANGEREQUEST,1,Layout);
end;
//***************** end of SetLayoutActiveWnd *****************************

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  // DM.FDC.Params.Database := 'd:\zakaz.sqlite';
  DM.FDC.Params.Database := readini(inifile, 'database');
  zakazpath:= readini(inifile, 'zakazpath');
  DM.FDC.Open;
  DM.TWstud.Open;

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 CheckBox3.Enabled:=CheckBox1.Checked;
 if not CheckBox1.Checked then CheckBox3.Checked:=false;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
CheckBox4.Enabled:=CheckBox2.Checked;
 if not CheckBox2.Checked then CheckBox4.Checked:=false;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
with DM do
 begin
  QFind.Close;
  QFind.paramByName('fam').Asstring:=Edit2.Text+'%';
  QFind.paramByName('name').Asstring:=Edit3.Text+'%';
  QFind.paramByName('otch').Asstring:=Edit4.Text+'%';
  QFind.Open;
 end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  writeini(inifile, 'database', DM.FDC.Params.Database);
  writeini(inifile, 'zakazpath', zakazpath);
end;

procedure TForm1.FormCreate(Sender: TObject);

begin


  SetLayoutActiveWnd(RUSSIAN);

end;

end.
