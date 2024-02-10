unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
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
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

CONST
  inifile = 'settings.ini';

var
  Form1: TForm1;
  zakazpath:string;
implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  // DM.FDC.Params.Database := 'd:\zakaz.sqlite';
  DM.FDC.Params.Database := readini(inifile, 'database');
  zakazpath:= readini(inifile, 'zakazpath');
  DM.FDC.Open;
  DM.TWstud.Open;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  writeini(inifile, 'database', DM.FDC.Params.Database);
  writeini(inifile, 'zakazpath', zakazpath);
end;

end.
