unit directorytree;

{$R-,T-,H+,X+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, FileCtrl;

const
  Rootname : string = 'My Computer';

type
  TDirectoryTree = class(TCustomTreeView)
  private
    { Private declarations }
    fImageList : TCustomImageList;
    fDirectory : string;
    fOnChange : TNotifyEvent;
    fDirLabel : TLabel;
    fDirLabelSet : Boolean;
    fFileList : TFileListbox;
    fDirList : TDirectoryTree;
    fTreenodes : TTreenodes;
    fCurDrive : string;

    //Procedure SetDirLabel(Value : TLabel);
    //Procedure SetDirLabelCaption;
    procedure FindDirs(S : string; T : TTreenode);
    procedure GetNodeInfo(T : TTreenode);
    procedure fChanges; dynamic;
    //Procedure SetFileListBox(Value : TFileListBox);
    //Function MinimizeName(const Filename : TFileName;
    // Canvas : TCanvas; MaxLen : Integer): TFileName;
    //procedure CutFirstDirectory(var S : TFileName);

  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer); override;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure UpDate; reintroduce;
    procedure FindDrives; dynamic;
    procedure CreateWnd; override;

  published
    { Published declarations }
    {--- свойства ---}
    property Align;
    property Anchors;
    //Property AutoExpand;
    //Property BiDiMode;
    //Property BorderStyle;
    //Property BorderWidth;
    //Property ChangeDelay;
    property Color;
    property Constraints;
    property Cursor;
    //Property DirLabel : TLabel
    // read fDirLabel write SetDirLabel;
    property Directory : string
    read fDirectory write fDirectory;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    //Property FileList : TFileListbox
    // read fFileList write SetFileListbox;
    property Font;
    property Height;
    property HelpContext;
    //Property HideSelection;
    property Hint;
    //Property HotTrack;
    //Property Images;
    //Property Indent;
    //Property Items;
    property Left;
    property name;
    //Property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //Property ReadOnly;
    //Property RightClickSelect;
    //Property RowSelect;
    //Property ShowButtons;
    property ShowHint;
    //Property ShowLines;
    //Property ShowRoot;
    //Property SortType;
    //Property StateImages;
    property TabOrder;
    property TabStop;
    property Tag;
    //Property ToolTips;
    property Top;
    property Visible;
    property Width;

    {--- События ---}

    //Property OnAdvancedCustomDraw;
    //Property OnAdvancedCustomDrawItem;
    property OnChange : TNotifyEvent
    read fOnChange write fOnChange;
    //Property OnChanging;
    property OnClick;
    //Property OnCollapsed;
    //Property OnCollapsing;
    //Property OnCompare;
    //Property OnContextPopup;
    //Property OnCustomDraw;
    //Property OnCustomDrawItem;
    property OnDblClick;
    //Property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    //Property OnEdited;
    //Property OnEditing;
    //Property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    //Property OnExpanded;
    //Property OnExpanding;
    //Property OnGetImageIndex;
    //Property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    //Property OnStartDock;
    property OnStartDrag;
end;

procedure register;

// Загружаем bitmap-ы, 16 x 16 бит, 256 цветов
{$R IMAGES.RES}

implementation


(* Из исходников Delphi 5:
c:\program files\borland\delphi5\source\vcl\filectrl.pas

Procedure TDirectoryTree.SetFileListBox(Value: TFileListBox);

Begin
If fFileList <> nil then
fFileList.DirList := nil;
fFileList := Value;
If fFileList <> nil then
Begin
fFileList.DirList := Self;
fFileList.FreeNotification(Self);
End;
End; *)

(* Из исходников Delphi 5:
c:\program files\borland\delphi5\source\vcl\filectrl.pas

Procedure CutFirstDirectory(var S: TFileName);

Var
Root : Boolean;
P : Integer;

Begin
If S = '\' then
S := ''
else
Begin
If S[1] = '\' then
Begin
Root := True;
Delete(S, 1, 1);
End
else
Root := False;
If S[1] = '.' then
Delete(S, 1, 4);
P := AnsiPos('\',S);
If P <> 0 then
Begin
Delete(S, 1, P);
S := '...\' + S;
End
else
S := '';
If Root then
S := '\' + S;
End;
End; *)

(* Из исходников Delphi 5:
c:\program files\borland\delphi5\source\vcl\filectrl.pas

Function MinimizeName(const Filename: TFileName; Canvas: TCanvas;
MaxLen: Integer): TFileName;

Var
Drive : TFileName;
Dir : TFileName;
Name : TFileName;

Begin
Result := FileName;
Dir := ExtractFilePath(Result);
Name := ExtractFileName(Result);

If (Length(Dir) >= 2) and (Dir[2] = ':') then
begin
Drive := Copy(Dir, 1, 2);
Delete(Dir, 1, 2);
end
else
Drive := '';
While ((Dir <> '') or (Drive <> '')) and
(Canvas.TextWidth(Result) > MaxLen) do
Begin
If Dir = '\...\' then
Begin
Drive := '';
Dir := '...\';
End
else
If Dir = '' then
Drive := ''
else
CutFirstDirectory(Dir);
Result := Drive + Dir + Name;
End;
End; *)

(* Из исходников Delphi 5:
c:\program files\borland\delphi5\source\vcl\filectrl.pas

Procedure TDirectoryTree.SetDirLabel (Value: TLabel);

Begin
fDirLabel := Value;
if Value <> nil then
Value.FreeNotification(Self);
SetDirLabelCaption;
End;
*)

(* Из Delphi:
c:\program files\borland\delphi5\source\vcl\filectrl.pas

Procedure TDirectoryTree.SetDirLabelCaption;

Var
DirWidth: Integer;

Begin
If fDirLabel <> nil then
Begin
DirWidth := Width;
If not fDirLabel.AutoSize then
DirWidth := fDirLabel.Width;
fDirLabel.Caption := MinimizeName(Directory, fDirLabel.Canvas,
DirWidth);
End;
End; *)

procedure TDirectoryTree.fChanges;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

procedure TDirectoryTree.FindDirs(S: string; T: TTreeNode);
var
  Res : Integer;
  SR : TSearchRec;
  T1 : TTreenode;
  S1 : string;
begin
  S1 := S;
  if S[Length(S)] <> '\' then
    S1 := S1 + '\';
  Res := FindFirst(S1 + '*.*',faAnyFile,SR);

  if Res = 0 then
    repeat
      if ((SR.Attr and faDirectory) = faDirectory) then
        if (SR.name <> '.') and (SR.name <> '..') then
        begin
          T1 := Items.AddChild(T,SR.name);
          T1.SelectedIndex := 1; // Diropen.bmp when selected
          T1.HasChildren := True; // Creates a '+' sign
        end;
      Res := FindNext(SR);
    until
      Res <> 0;

  FindClose(SR);
end;

procedure TDirectoryTree.GetNodeInfo(T : TTreenode);
var
  S : string;
  T1 : TTreenode;
begin
  S := T.Text;
  if S = Rootname then
    Exit;
  T1 := T;
  repeat
    T1 := T1.Parent;
    if S[2] <> ':' then
      S := T1.Text + '\' + S;
  until
    S[2] = ':';

  if T.Count = 0 then
    FindDirs(S,T);

  fDirectory := S;
  fChanges;
end;

procedure TDirectoryTree.FindDrives;
var
  Tr,T1 : TTreenode;
  ld : DWord;
  I : Integer;
  Drive : string;
begin
  Items.Clear;
  ld := GetLogicalDrives;
  Tr := Items.Add(nil,Rootname);
  Tr.ImageIndex := 2;
  Tr.SelectedIndex := 2;
  for I := 0 to 25 do
  begin
    if (ld and (1 shl I)) > 0 then
    begin
      Drive := Chr(65 + I) + ':';

      T1 := Items.AddChild(Tr,Drive);
      T1.HasChildren := True;
      // Корректируем иконку диска
      case GetDriveType(PChar(Drive[1] + ':\')) of
        0, DRIVE_FIXED :
        begin
          T1.ImageIndex := 3;
          T1.SelectedIndex := 3;
        end;

        DRIVE_CDROM :
        begin
          T1.ImageIndex := 4;
          T1.SelectedIndex := 4;
        end;

        DRIVE_REMOVABLE :
        begin
          T1.ImageIndex := 5;
          T1.SelectedIndex := 5;
        end;

        DRIVE_RAMDISK:
        begin
          T1.ImageIndex := 6;
          T1.SelectedIndex := 6;
        end;

        DRIVE_REMOTE :
        begin
          T1.ImageIndex := 7;
          T1.SelectedIndex := 7;
        end;
      end; // конец Case

      if fCurDrive = Drive then
        T1.Selected := True; // Выбираем текущий диск
    end;
  end;
end;

constructor TDirectoryTree.Create(AOwner : TComponent);
var
  bDirClose,bDirOpen : TBitmap;
  bFloppy,bComputer : TBitmap;
  bHardDisk,bCDRom : TBitmap;
  bRemoteDrive,bRamdisk : TBitmap;
begin
  inherited Create(AOwner);
  ShowRoot := True;
  readonly := True;
  SortType := stBoth;
  fDirLabelSet := False;
  fDirectory := '';
  fImageList := TCustomImageList.Create(Self);
  fImageList.Clear;
  fImageList.BkColor := clWhite;
  fImageList.BlendColor := clWhite;
  fImageList.Masked := True;
  fImageList.Height := 16;
  fImageList.Width := 16;
  fImageList.AllocBy := 7;

  // Загружаем картинку DIRCLOSE
  bDirClose := TBitmap.Create;
  bDirClose.Handle := LoadBitmap(hInstance,'DIRCLOSE');
  // Добавляем в ImageList
  fImageList.Add(bDirClose,nil); // 0
  bDirClose.Free;

  // Загружаем картинку DIROPEN
  bDirOpen := TBitmap.Create;
  bDirOpen.Handle := LoadBitmap(hInstance,'DIROPEN');
  // Добавляем в ImageList
  fImageList.Add(bDirOpen,nil); // 1
  bDirOpen.Free;

  // Загружаем картинку COMPUTER
  bComputer := TBitmap.Create;
  bComputer.Handle := LoadBitmap(hInstance,'COMPUTER');
  // Добавляем в ImageList
  fImageList.Add(bComputer,nil); // 2
  bComputer.Free;

  // Загружаем картинку HARDDISK
  bHardDisk := TBitmap.Create;
  bHardDisk.Handle := LoadBitmap(hInstance,'HARDDISK');
  // Добавляем в ImageList
  fImageList.Add(bHardDisk,nil); // 3
  bHardDisk.Free;

  // Загружаем картинку CDROMDISK
  bCDRom := TBitmap.Create;
  bCDRom.Handle := LoadBitmap(hInstance,'CDROMDISK');
  // Со словом 'CDROM' возникают проблемы
  // Добавляем в ImageList
  fImageList.Add(bCDRom,nil); // 4
  bCDRom.Free;

  // Загружаем картинку FLOPPYDISK
  bFloppy := TBitmap.Create;
  bFloppy.Handle := LoadBitmap(hInstance,'FLOPPYDISK');
  // bitmap с именем 'FLOPPY'
  // уже существует
  // Добавляем в ImageList
  fImageList.Add(bFloppy,nil); // 5
  bFloppy.Free;

  // Загружаем картинку RAMDISK
  bRamDisk := TBitmap.Create;
  bRamDisk.Handle := LoadBitmap(hInstance,'RAMDISK');
  // Добавляем в ImageList
  fImageList.Add(bRamDisk,nil); // 6
  bRamDisk.Free;


  // Загружаем картинку REMOTEDISK
  bRemoteDrive := TBitmap.Create;
  bRemoteDrive.Handle := LoadBitmap(hInstance,'REMOTEDISK');
  // Добавляем в ImageList
  fImageList.Add(bRemoteDrive,nil); // 7
  bRemoteDrive.Free;

  Images := fImageList; // Assign the imagelist to TreeView.Images
  // CustomTreeView не имеет никаких treenodes, поэтому мы должны создать их..
  fTreenodes := TTreenodes.Create(Self);
end;

procedure TDirectoryTree.CreateWnd;
var
  P : string;
begin
  inherited CreateWnd;
  GetDir(0,P);
  fCurDrive := UpCase(P[1]) + ':';
  FindDrives; //Является динамическим!!
end;

procedure TDirectoryTree.MouseDown(Button: TMouseButton;
Shift : TShiftState; X, Y: Integer);
var
  T,T1 : TTreenode;
  S : string;
  HT : THitTests;
  I : Integer;
begin
  inherited MouseDown(Button,Shift,X,Y);
  HT := GetHitTestInfoAt(X,Y);
  if (htOnItem in HT) or (htOnIcon in HT) or (htOnButton in HT) then
  begin
    T := GetNodeAt(X,Y);
    S := T.Text;
    if S = Rootname then
      Exit;
    T1 := T;
    repeat
      T1 := T1.Parent;
      if S[2] <> ':' then
        S := T1.Text + '\' + S;
    until
      S[2] = ':';
    fDirectory := S;
    fChanges;
    I := T.Count;
    GetNodeInfo(T);
    T.Selected := True;
    if T.Count > 0 then
    begin
      if I = 0 then
        T.Expanded := True;
    end
    else
      T.HasChildren := False; // удаляем знаки '-' или '+'
  end;
end;

procedure TDirectoryTree.Update;
var
  P: string;
begin
  GetDir(0,P);
  fCurDrive := UpCase(P[1]) + ':';
  ChDir(fCurDrive);
  FindDrives;
  fChanges;
end;

destructor TDirectoryTree.Destroy;
begin
  fImageList.Free; // Удаляем ImageList
  fTreenodes.Free; // Удаляем Treenodes
  inherited Destroy;
end;

procedure register;
begin
  RegisterComponents('Samples', [TDirectoryTree]);
end; 

end.


