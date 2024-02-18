unit FunctionOLEObject;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Comctrls, Grids, DBGrids;

{---------- WORD ----------}
{--- Documents}
function WordAddDocument(const vWord: Variant;
  const vTemplate: string;
  const vNewTemplate: Boolean): Boolean;
{---Windows}
function WordWindowsCount(const vWord: Variant): Integer;
{---Window}
procedure WordWindowActivate(const vWord: Variant;
  const IWindow: Integer);
procedure WordNextWindowActivate(const vWord: Variant);
procedure WordPreviousWindowActivate(const vWord: Variant);
{---Selection}
procedure WordPutField(const vWord: Variant;
  const Field, Value: string);
procedure WordPutFieldItem(const vWord: Variant;
  Field: string;
  Item: Integer;
  Value: array of string);
procedure WordText(const vWord: Variant;
  const Value: string);
procedure WordTypeParagraph(const vWord: Variant);
procedure WordMoveRight(const vWord: Variant;
  const vUnit, vCount, vExtend: Integer);
procedure WordMoveDown(const vWord: Variant;
  const vUnit, vCount: integer);

{---Table}
procedure WordTablesAdd(const vWord: Variant;
  const Rows, Columns: Integer);

procedure WordTablesHeaders(const vWord: Variant;
  const vColl, vRow, vCount: integer);

procedure WordTablesCellValue(const vWord: Variant;
  const Table, Row, Column: Integer;
  const Value: string;
  const FontName: string;
  const FontBold, FontItalic: boolean;
  const FontUnderLine: byte);
procedure WordTablesNextCellValue(const vWord: Variant;
  const Value: string);
procedure WordTableAddFromListView(const vWord: Variant;
  ListView: TListView);

procedure WordTableAddFromGrid(const vWord: Variant;
  DBGrid: TDBGrid; CollSize: boolean);

{---------- Excel ----------}
procedure ExcelCellsValue(const vExcel: Variant;
  const Row, Col: Integer;
  const Value: Variant);

procedure ExcelFromListView(const vExcel: Variant;
  ListView: TListView;
  const Row, Col: Integer);
procedure ExcelTableAddFromGrid(const vExcel: Variant;
  DBGrid: TDBGrid;
  const Row, Col: Integer);

procedure ExcelRangeCellsValue(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Value: Variant;
  const HorizontalAlignment,
  VerticalAlignment: Integer;
  const WrapText: Boolean;
  const Orientation: Integer;
  const ShrinkToFit: Boolean;
  const MergeCells: Boolean);
procedure ExcelRangeCellsCopy(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const tlToRow, tlToCol,
  drToRow, drToCol: Integer);
procedure ExcelRangeCellsBorders(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const BorderType: Integer;
  const LineStyle: Integer);
procedure ExcelBorders(const vExcel: Variant;
  const BorderType: Integer;
  const LineStyle: Integer);

procedure ExcelRangeCellsSelect(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer);
procedure ExcelFont(const vExcel: Variant;
  const Name: string;
  const Bold: Boolean;
  const Italic: Boolean;
  const Size: Integer;
  const Strikethrough: Boolean;
  const Superscript: Boolean;
  const Subscript: Boolean;
  const OutlineFont: Boolean;
  const Shadow: Boolean;
  const Underline: Integer;
  const ColorIndex: Integer);
procedure ExcelFontName(const vExcel: Variant;
  const Name: string);
procedure ExcelFontSize(const vExcel: Variant;
  const Size: Integer);
procedure ExcelFontBold(const vExcel: Variant;
  const Bold: Boolean);
procedure ExcelFontItalic(const vExcel: Variant;
  const Italic: Boolean);
procedure ExcelRangeCellsFontName(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Name: string);
procedure ExcelRangeCellsFontSize(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Size: Integer);
procedure ExcelRangeCellsFontBold(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Bold: Boolean);
procedure ExcelRangeCellsFontItalic(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Italic: Boolean);
procedure ExcelRangeCellsFont(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Name: string;
  const Bold: Boolean;
  const Italic: Boolean;
  const Size: Integer;
  const Strikethrough: Boolean;
  const Superscript: Boolean;
  const Subscript: Boolean;
  const OutlineFont: Boolean;
  const Shadow: Boolean;
  const Underline: Integer;
  const ColorIndex: Integer);
implementation

uses WordConst, ExcelConst;

function WordAddDocument(const vWord: Variant;
  const vTemplate: string;
  const vNewTemplate: Boolean): Boolean;
begin
  Result := True;
  try
    vWord.Documents.Add(Template := vTemplate,
      NewTemplate := vNewTemplate);
  except
    Result := False;
  end;
end;

procedure WordMoveRight(const vWord: Variant;
  const vUnit, vCount,
  vExtend: Integer);
begin
  vWord.Selection.MoveRight(vUnit, vCount, vExtend);
end;

procedure WordTablesHeaders(const vWord: Variant;
  const vColl, vRow, vCount: integer);
var
  I, cnt: integer;

begin
  vWord.Selection.MoveLeft(unit := wdCell, Count := vColl - 1);
  vWord.Selection.MoveUp(unit := wdLine, Count := vRow);

  vWord.Selection.SelectRow;
  vWord.Selection.Rows.HeadingFormat := -1;

  { vWord.Selection.MoveUp(Unit:=wdLine, Count:=vRow);
    vWord.Selection.Tables.Item(1).Select;
    vWord.Selection.ParagraphFormat.Alignment:= wdAlignParagraphCenter;}
end;

procedure WordMoveDown(const vWord: Variant;
  const vUnit, vCount: integer);
begin
  vWord.Selection.MoveDown(vUnit, vCount);
end;

procedure WordTablesAdd(const vWord: Variant;
  const Rows, Columns: Integer);
begin
  vWord.ActiveDocument.Tables.Add(Range := vWord.Selection.Range,
    NumRows := Rows, NumColumns := Columns);
end;

procedure WordTablesCellValue(const vWord: Variant;
  const Table, Row, Column: Integer;
  const Value: string;
  const FontName: string;
  const FontBold, FontItalic: boolean;
  const FontUnderLine: byte);
begin
  vWord.ActiveDocument.Tables.Item(Table).Cell(Row, Column).
    Range.Font.Name := FontName;
  vWord.ActiveDocument.Tables.Item(Table).Cell(Row, Column).
    Range.Font.Bold := FontBold;
  vWord.ActiveDocument.Tables.Item(Table).Cell(Row, Column).
    Range.Font.Italic := FontItalic;
  vWord.ActiveDocument.Tables.Item(Table).Cell(Row, Column).
    Range.Font.UnderLine := FontUnderLine;
  vWord.ActiveDocument.Tables.Item(Table).Cell(Row, Column).
    Range.InsertAfter(Text := Value);

end;

procedure WordTableAddFromListView(const vWord: Variant;
  ListView: TListView);
var
  i, j: Integer;
begin
  WordTablesAdd(vWord, ListView.Items.Count + 1, ListView.Columns.Count);
  WordText(vWord, ListView.Column[0].Caption);
  for j := 1 to ListView.Columns.Count - 1 do
  begin
    WordTablesNextCellValue(vWord,
      ListView.Column[j].Caption);
  end;
  for i := 0 to ListView.Items.Count - 1 do
  begin
    WordTablesNextCellValue(vWord,
      ListView.Items.Item[i].Caption);
    for j := 0 to ListView.Columns.Count - 2 do
      if ListView.Items.Item[i].SubItems.Count > j then
        WordTablesNextCellValue(vWord,
          ListView.Items.Item[i].SubItems.Strings[j])
      else
        WordMoveRight(vWord, wdCell, 1, wdMove);
  end;
end;

procedure WordTableAddFromGrid(const vWord: Variant;
  DBGrid: TDBGrid; CollSize: boolean);
var
  i, j, Col, Row, ColWidth: Integer;

begin

  Col := DBGrid.Columns.Count;
  Row := DBGrid.DataSource.DataSet.RecordCount + 1;

  WordTablesAdd(vWord, Row, Col);
  WordText(vWord, DBGrid.Columns.Items[0].Title.Caption);
  if CollSize then
    ColWidth := DBGrid.Columns.Items[0].Width;
  vWord.Selection.Tables.Item(1).Columns.Item(1).
    SetWidth(ColumnWidth := ColWidth, RulerStyle := wdAdjustNone);

  for j := 1 to Col - 1 do
  begin
    WordTablesNextCellValue(vWord,
      DBGrid.Columns.Items[j].Title.Caption);
    if CollSize then
      ColWidth := DBGrid.Columns.Items[j].Width;
    vWord.Selection.Tables.Item(1).Columns.Item(j + 1).
      SetWidth(ColumnWidth := ColWidth, RulerStyle := wdAdjustNone);
  end;

  DBGrid.DataSource.DataSet.First;
  for i := 1 to Row - 1 do
  begin
    for j := 0 to Col - 1 do
      WordTablesNextCellValue(vWord,
        DBGrid.Columns.Items[j].Field.AsString);
    DBGrid.DataSource.DataSet.Next;
  end;
  DBGrid.DataSource.DataSet.First;
end;

procedure WordTablesNextCellValue(const vWord: Variant;
  const Value: string);
begin
  WordMoveRight(vWord, wdCell, 1, wdMove);
  vWord.Selection.Font.Bold := false;
  WordText(vWord, Value);
end;

procedure WordText(const vWord: Variant;
  const Value: string);
begin
  vWord.Selection.TypeText(Text := Value);
end;

procedure WordTypeParagraph(const vWord: Variant);
begin
  vWord.Selection.TypeParagraph;
end;

procedure WordPutField(const vWord: Variant;
  const Field, Value: string);
begin
  vWord.Selection.goto(Name := Field);
  vWord.Selection.TypeText(Text := Value);
end;

procedure WordPutFieldItem(const vWord: Variant;
  Field: string;
  Item: Integer;
  Value: array of string);
var
  i: Integer;
begin
  Field := Format('%s%d', [Field, Item]);
  vWord.Selection.goto(Name := Field);
  for i := Low(Value) to High(Value) do
  begin
    vWord.Selection.TypeText(Text := Value[i]);
    vWord.Selection.MoveRight;
  end;
end;

procedure WordWindowActivate(const vWord: Variant;
  const IWindow: Integer);
begin
  vWord.Windows.Item(IWindow).Activate;
end;

procedure WordNextWindowActivate(const vWord: Variant);
begin
  vWord.ActiveWindow.Next.Activate;
end;

procedure WordPreviousWindowActivate(const vWord: Variant);
begin
  vWord.ActiveWindow.Previous.Activate;
end;

function WordWindowsCount(const vWord: Variant): Integer;
begin
  Result := vWord.Windows.Count;
end;

//------- Exel --------------------

procedure ExcelCellsValue(const vExcel: Variant;
  const Row, Col: Integer;
  const Value: Variant);
var
  sV: string;
  iV: Integer;
  dV: TDateTime;
begin
  case TVarData(Value).VType of
    varEmpty: ;
    varNull: ;
    varSmallint: ;
    varInteger:
      begin
        iV := Value;
        vExcel.Cells[Row, Col].Value := iV;
      end;
    varSingle: ;
    varDouble: ;
    varCurrency: ;
    varDate:
      begin
        dV := Value;
        vExcel.Cells[Row, Col].Value := dV;
      end;
    varOLEStr: ;
    varDispatch: ;
    varError: ;
    varBoolean: ;
    varUnknown: ;
    varByte: ;
    varString:
      begin
        sV := Value;
        vExcel.Cells[Row, Col].Value := sV;
      end;
    varTypeMask: ;
    varArray: ;
    varByRef: ;
  end;
end;

procedure ExcelFromListView(const vExcel: Variant;
  ListView: TListView;
  const Row, Col: Integer);
var
  i, j: Integer;
begin
  for j := 0 to ListView.Columns.Count - 1 do
  begin
    vExcel.Cells[Row, Col + j].Value := ListView.
      Column[j].Caption;
  end;
  for i := 0 to ListView.Items.Count - 1 do
  begin
    vExcel.Cells[Row + 1 + i, Col].Value := ListView.
      Items.Item[i].Caption;
    for j := 0 to ListView.Items.Item[i].SubItems.Count - 1 do
    try
      vExcel.Cells[Row + 1 + i, Col + 1 + j].Value := StrToFloat(ListView.
        Items.Item[i].SubItems.Strings[j]);
    except
      vExcel.Cells[Row + 1 + i, Col + 1 + j].Value := ListView.
        Items.Item[i].SubItems.Strings[j];
    end;
  end;
end;

procedure ExcelTableAddFromGrid(const vExcel: Variant;
  DBGrid: TDBGrid;
  const Row, Col: Integer);
var
  i, j, vCol, vRow, ColWidth: Integer;

begin
  vCol := DBGrid.Columns.Count;
  vRow := DBGrid.DataSource.DataSet.RecordCount + 1;

  for j := 0 to vCol - 1 do
    vExcel.Cells[Row, Col + j].Value := DBGrid.Columns.Items[j].Title.Caption;

  DBGrid.DataSource.DataSet.First;
  for i := 0 to vRow - 2 do
  begin
    for j := 0 to vCol - 1 do
    try
      vExcel.Cells[Row + 1 + i, Col + j].Value :=
        StrToFloat(DBGrid.Columns.Items[j].Field.AsString);
    except
      vExcel.Cells[Row + 1 + i, Col + j].Value :=
        DBGrid.Columns.Items[j].Field.AsString;
    end;
    DBGrid.DataSource.DataSet.Next;
  end;
  DBGrid.DataSource.DataSet.First;
end;

procedure ExcelRangeCellsValue(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Value: Variant;
  const HorizontalAlignment,
  VerticalAlignment: Integer;
  const WrapText: Boolean;
  const Orientation: Integer;
  const ShrinkToFit: Boolean;
  const MergeCells: Boolean);
begin
  ExcelCellsValue(vExcel, tlRow, tlCol, Value);
  vExcel.Range[vExcel.Cells[tlRow, tlCol],
    vExcel.Cells[drRow, drCol]].Select;
  vExcel.Selection.HorizontalAlignment := HorizontalAlignment;
  vExcel.Selection.VerticalAlignment := VerticalAlignment;
  vExcel.Selection.WrapText := WrapText;
  vExcel.Selection.Orientation := Orientation;
  vExcel.Selection.ShrinkToFit := ShrinkToFit;
  vExcel.Selection.MergeCells := MergeCells;
end;

procedure ExcelRangeCellsCopy(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const tlToRow, tlToCol,
  drToRow, drToCol: Integer);
begin
  vExcel.Range[vExcel.Cells[tlRow, tlCol],
    vExcel.Cells[drRow, drCol]].Select;
  vExcel.Selection.Copy;
  vExcel.Range[vExcel.Cells[tlToRow, tlToCol],
    vExcel.Cells[drToRow, drToCol]].Select;
  vExcel.ActiveSheet.Paste;
end;

procedure ExcelBorders(const vExcel: Variant;
  const BorderType: Integer;
  const LineStyle: Integer);
begin
  vExcel.Selection.Borders[BorderType].LineStyle := LineStyle;
end;

procedure ExcelRangeCellsBorders(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const BorderType: Integer;
  const LineStyle: Integer);
begin
  vExcel.Range[vExcel.Cells[tlRow, tlCol],
    vExcel.Cells[drRow, drCol]].Select;
  ExcelBorders(vExcel, BorderType, LineStyle);
end;

procedure ExcelRangeCellsSelect(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer);
begin
  vExcel.Range[vExcel.Cells[tlRow, tlCol],
    vExcel.Cells[drRow, drCol]].Select;
end;

procedure ExcelFont(const vExcel: Variant;
  const Name: string;
  const Bold: Boolean;
  const Italic: Boolean;
  const Size: Integer;
  const Strikethrough: Boolean;
  const Superscript: Boolean;
  const Subscript: Boolean;
  const OutlineFont: Boolean;
  const Shadow: Boolean;
  const Underline: Integer;
  const ColorIndex: Integer);
begin
  ExcelFontName(vExcel, Name);
  ExcelFontSize(vExcel, Size);
  ExcelFontBold(vExcel, Bold);
  ExcelFontItalic(vExcel, Italic);
  vExcel.Selection.Font.Strikethrough := Strikethrough;
  vExcel.Selection.Font.Superscript := Superscript;
  vExcel.Selection.Font.Subscript := Subscript;
  vExcel.Selection.Font.OutlineFont := OutlineFont;
  vExcel.Selection.Font.Shadow := Shadow;
  vExcel.Selection.Font.Underline := Underline;
  vExcel.Selection.Font.ColorIndex := ColorIndex;
end;

procedure ExcelRangeCellsFont(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Name: string;
  const Bold: Boolean;
  const Italic: Boolean;
  const Size: Integer;
  const Strikethrough: Boolean;
  const Superscript: Boolean;
  const Subscript: Boolean;
  const OutlineFont: Boolean;
  const Shadow: Boolean;
  const Underline: Integer;
  const ColorIndex: Integer);
begin
  ExcelRangeCellsSelect(vExcel, tlRow, tlCol,
    drRow, drCol);
  ExcelFont(vExcel, Name, Bold, Italic, Size,
    Strikethrough, Superscript, Subscript,
    OutlineFont, Shadow, Underline, ColorIndex);
end;

procedure ExcelFontName(const vExcel: Variant;
  const Name: string);
begin
  vExcel.Selection.Font.Name := Name;
end;

procedure ExcelRangeCellsFontName(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Name: string);
begin
  ExcelRangeCellsSelect(vExcel, tlRow, tlCol,
    drRow, drCol);
  ExcelFontName(vExcel, Name);
end;

procedure ExcelFontSize(const vExcel: Variant;
  const Size: Integer);
begin
  vExcel.Selection.Font.Size := Size;
end;

procedure ExcelRangeCellsFontSize(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Size: Integer);
begin
  ExcelRangeCellsSelect(vExcel, tlRow, tlCol,
    drRow, drCol);
  ExcelFontSize(vExcel, Size);
end;

procedure ExcelFontBold(const vExcel: Variant;
  const Bold: Boolean);
begin
  vExcel.Selection.Font.Bold := Bold;
end;

procedure ExcelRangeCellsFontBold(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Bold: Boolean);
begin
  ExcelRangeCellsSelect(vExcel, tlRow, tlCol,
    drRow, drCol);
  ExcelFontBold(vExcel, Bold);
end;

procedure ExcelFontItalic(const vExcel: Variant;
  const Italic: Boolean);
begin
  vExcel.Selection.Font.Italic := Italic;
end;

procedure ExcelRangeCellsFontItalic(const vExcel: Variant;
  const tlRow, tlCol,
  drRow, drCol: Integer;
  const Italic: Boolean);
begin
  ExcelRangeCellsSelect(vExcel, tlRow, tlCol,
    drRow, drCol);
  ExcelFontItalic(vExcel, Italic);
end;

end.
