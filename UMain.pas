unit UMain;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,// Windows,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async,   ustr,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, UDM, Vcl.Grids, Vcl.DBGrids, myinifiles,
  System.Actions, Vcl.ActnList, Vcl.Menus;
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
    Badduser: TBitBtn;
    DBGrid2: TDBGrid;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox2: TGroupBox;
    Splitter1: TSplitter;
    Bdeluser: TBitBtn;
    Bcreate: TBitBtn;
    ActionList1: TActionList;
    adduser: TAction;
    deluser: TAction;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    BitBtn2: TBitBtn;
    refresh: TAction;
    Memo1: TMemo;
    CheckBox5: TCheckBox;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Button1: TButton;
    Action1: TAction;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure adduserExecute(Sender: TObject);
    procedure BdeluserClick(Sender: TObject);
    procedure refreshExecute(Sender: TObject);

    procedure StringGrid2SelectCell(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);

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
  CNT_LAYOUT = 2; // количество известных раскладок
  ENGLISH = $409;
  RUSSIAN = $419;
  TKbdValue : array [1..CNT_LAYOUT] of LongWord =
                ( ENGLISH,
                  RUSSIAN
                );
  TKbdDisplayNames : array [1..CNT_LAYOUT] of string =
                ('English',
                 'Русский'
                );



implementation
{$R *.dfm}

procedure AutoSizeGridColumns(Grid: TStringGrid);
const
  MIN_COL_WIDTH = 15;
var
  Col : Integer;
  ColWidth, CellWidth: Integer;
  Row: Integer;
begin
  Grid.Canvas.Font.Assign(Grid.Font);
  for Col := 0 to Grid.ColCount -1 do
  begin
    ColWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, 0]);
    for Row := 0 to Grid.RowCount - 1 do
    begin
      CellWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, Row]);
      if CellWidth > ColWidth then
        ColWidth := CellWidth
    end;
    Grid.ColWidths[Col] := ColWidth + MIN_COL_WIDTH;
  end;
end;

procedure TForm1.Action1Execute(Sender: TObject);
var
 s,s1:string;
 f:textfile;
 i:integer;
 j:integer;
begin
 if Label5.Caption='0' then
  begin
   showmessage('Не выбрано ни одного студента!');
   exit;
  end;
 s1:=timetostr(time);
 s1:=StringReplace(s1, ':', '-', [rfReplaceAll, rfIgnoreCase]);
 Assignfile(f,zakazpath+edit1.text+'_'+datetostr(date)+'_'+s1+'.zkz');
 Rewrite(f);
 Writeln(f,Edit1.Text);
 Writeln(f,datetostr(date));
 Writeln(f,timetostr(time));
 Writeln(f,Label5.Caption);
 for i:=1 to stringgrid1.RowCount-1 do
  begin
   s1:='';
    For j:=0 to stringgrid1.ColCount-1 do
     s1:=s1+stringgrid1.cells[j,i]+'~';
   Writeln(f,s1);
  end;
 Closefile(f);
 Showmessage('Заказ сформирован!');
  StringGrid1.Visible := false;
  for i:=0 to 1000 do
     StringGrid1.Rows[i].Clear;
  StringGrid1.Visible := true;
  StringGrid1.RowCount:=2;
  StringGrid1.Row:=1;
  Label5.Caption:='0';

end;

procedure TForm1.adduserExecute(Sender: TObject);
begin
 if((CheckBox1.Checked=false) and(CheckBox2.Checked=false)) then
  begin
   showmessage('Укажите вид документа!');
   exit;
  end;
  stringgrid1.row:=stringgrid1.rowcount-1;
 Stringgrid1.Cells[0,StringGrid1.row]:=DBGrid2.datasource.DataSet.FieldByName('tabnum').Asstring;
 Stringgrid1.Cells[1,StringGrid1.row]:=DBGrid2.datasource.DataSet.FieldByName('fam').Asstring;
 Stringgrid1.Cells[2,StringGrid1.row]:=DBGrid2.datasource.DataSet.FieldByName('name').Asstring;
 Stringgrid1.Cells[3,StringGrid1.row]:=DBGrid2.datasource.DataSet.FieldByName('otch').Asstring;
 Stringgrid1.Cells[4,StringGrid1.row]:=DBGrid2.datasource.DataSet.FieldByName('spec').Asstring;
 if (CheckBox1.Checked) then
  Stringgrid1.Cells[5,StringGrid1.row]:='1' else Stringgrid1.Cells[5,StringGrid1.row]:='0';
 if (CheckBox3.Checked) then
  Stringgrid1.Cells[6,StringGrid1.row]:='1' else Stringgrid1.Cells[6,StringGrid1.row]:='0';
 if (CheckBox2.Checked) then
  Stringgrid1.Cells[7,StringGrid1.row]:='1' else Stringgrid1.Cells[7,StringGrid1.row]:='0';
 if (CheckBox4.Checked) then
  Stringgrid1.Cells[8,StringGrid1.row]:='1' else Stringgrid1.Cells[8,StringGrid1.row]:='0';



 Stringgrid1.RowCount:=Stringgrid1.RowCount+1;
 StringGrid1.Row:=StringGrid1.row+1;
 CheckBox1.Checked:=false;
 CheckBox2.Checked:=false;
 CheckBox3.Checked:=false;
 CheckBox4.Checked:=false;
 LAbel5.Caption:=inttostr(Strtoint(Label5.caption)+1);
 AutoSizeGridColumns(StringGrid1);
end;

procedure clearstrgr(stringgrid1:tstringgrid);
 var
   i,r: Integer;
 begin
   {r:=StringGrid1.Row;
   //if r=Stringgrid1.rowcount-1 then exit;
   if (StringGrid1.Row = StringGrid1.RowCount - 1) then

     StringGrid1.RowCount := StringGrid1.RowCount - 1
   else
   begin

     for i := r to StringGrid1.RowCount - 1 do
       StringGrid1.Rows[i] := StringGrid1.Rows[i + 1];
     StringGrid1.RowCount := StringGrid1.RowCount - 1;
   end; }
  for i:=1 to stringgrid1.RowCount-1 do stringgrid1.Rows[i].Clear;

 StringGrid1.RowCount := 2;
 end;
 procedure clearstrgr1(stringgrid1:tstringgrid);
 var
   i,r: Integer;
 begin
   r:=StringGrid1.Row;
   if r=Stringgrid1.rowcount-1 then exit;
   if (StringGrid1.Row = StringGrid1.RowCount - 1) then

     StringGrid1.RowCount := StringGrid1.RowCount - 1
   else
   begin

     for i := r to StringGrid1.RowCount - 1 do
       StringGrid1.Rows[i] := StringGrid1.Rows[i + 1];
     StringGrid1.RowCount := StringGrid1.RowCount - 1;
   end;
 end;
procedure TForm1.BdeluserClick(Sender: TObject);
begin
   if Stringgrid1.rowcount-1=stringgrid1.row then exit;
   clearstrgr1(stringgrid1);
   if strtoint(LAbel5.Caption)>0 then
   LAbel5.Caption:=inttostr(Strtoint(Label5.caption)-1);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  // DM.FDC.Params.Database := 'd:\zakaz.sqlite';
  DM.FDC.Params.Database := readini(inifile, 'database');
  zakazpath:= readini(inifile, 'zakazpath');
  DM.FDC.Open;
  DM.TWstud.Open;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
 Edit2.Text :='';
 Edit3.Text :='';
 Edit4.Text :='';
with DM do
 begin
  QFind.Close;
  QFind.paramByName('fam').Asstring:=Edit2.Text+'%';
  QFind.paramByName('name').Asstring:=Edit3.Text+'%';
  QFind.paramByName('otch').Asstring:=Edit4.Text+'%';
  QFind.Open;
 end;
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
procedure TForm1.Edit3Change(Sender: TObject);
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

procedure TForm1.Edit4Change(Sender: TObject);
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
  writeini(inifile, 'user', edit1.text);
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.text:=readini(inifile,'user');
  BitBtn1Click(Form1);
  with DM do
 begin
  QFind.Close;
  QFind.paramByName('fam').Asstring:=Edit2.Text+'%';
  QFind.paramByName('name').Asstring:=Edit3.Text+'%';
  QFind.paramByName('otch').Asstring:=Edit4.Text+'%';
  QFind.Open;
 end;
 BitBtn2.Click;
 //EDit2.SetFocus;
 end;
procedure TForm1.N1Click(Sender: TObject);
var
 s:string;
begin
 // тут просто дописать к stringgrid2.cells[] расширение экселя либо вычитать его из второй строки файла
 // и открыть

end;

procedure TForm1.N3Click(Sender: TObject);
begin
 Deletefile(stringgrid2.Cells[3,stringgrid2.Row]);
 sleep(100);
 BitBtn2.Click;
 end;

procedure TForm1.refreshExecute(Sender: TObject);
var
 i:integer;
 s,s1:string;
 sl,s2:tstrings;
 f:textfile;
begin
 Memo1.lines.Clear;
 ListFileDir(zakazpath, memo1.lines, edit1.text+'*.zkz');
 clearstrgr(Stringgrid2);
 stringgrid2.row:=1;
 if memo1.lines.Count=0 then exit;
 for i:=0 to memo1.lines.Count-1 do
 if memo1.lines.Strings[i]<>'' then
  begin
   s:=memo1.lines.Strings[i];
   s1:=pnext('_',s);
   s1:=pnext('_',s);
   stringgrid2.cells[1,stringgrid2.row]:=s1;
   s1:=pnext('.',s);
   stringgrid2.cells[2,stringgrid2.row]:=s1;
   assignfile(f,memo1.lines.Strings[i]);
   reset(f);
   ReadLn(f,s);
   Closefile(f);
   if s=edit1.text then
      stringgrid2.cells[0,stringgrid2.row]:='Ожидает'
   else stringgrid2.cells[0,stringgrid2.row]:=s;
  stringgrid2.cells[3,stringgrid2.row]:=memo1.lines.Strings[i];
   stringgrid2.rowcount:=stringgrid2.rowcount+1;
   stringgrid2.row:=stringgrid2.row+1;
  end;
  stringgrid2.row:=stringgrid2.row-1;
 stringgrid2.rowcount:=stringgrid2.rowcount-1;
 AutoSizeGridColumns(StringGrid2);
end;


procedure TForm1.StringGrid2SelectCell(Sender: TObject);
var
 s,s1:string;
 f:textfile;
 i,j,c:integer;
begin
 s:=stringgrid2.cells[3,stringgrid2.row];
 assignfile(f,s);
 reset(f);
 Readln(f,s);
 Readln(f,s);
 Readln(f,s);
 Readln(f,s);
 c:=strtoint(s);
 stringgrid3.rowcount:=c+1;
 for i:=1 to c do
  begin
   Readln(f,s);
   s1:=s;
   for j:=0 to 8 do
    begin
      s:=pnext('~',s1);
      stringgrid3.cells[j,i]:=s;
    end;

  end;
 Closefile(f);
 AutoSizeGridColumns(StringGrid3);
end;

end.
