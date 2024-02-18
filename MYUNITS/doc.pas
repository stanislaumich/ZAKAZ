unit doc;
interface
uses

  Word_TLB, windows, sysutils;
type
  TWinWord = class

  private
    App: _Application;
    function fGetVisible: boolean;
    procedure fSetVisible(visible: boolean);
  public
    procedure NewDoc(Template: string);
    procedure GotoBookmark(Bookmark: string);
    procedure InsertText(Text: string);
    procedure MoveRight(Count: integer);
    procedure Print;
    procedure UpdateFields;
    procedure SaveAs(Filename: string);
    procedure RunMacro(MacroName: string);
    constructor Create;
    destructor Destroy; override;
    property visible: boolean
      read fGetVisible
      write fSetVisible;
  end;

implementation

//------------------------------------------------------------------

constructor TWinWord.Create;
begin

  App := CoApplication.Create;
end;

//------------------------------------------------------------------

destructor TWinWord.Destroy;
var
  SaveChanges: OLEVariant;
  OriginalFormat: OLEVariant;
  RouteDocument: OLEVariant;
begin

  SaveChanges := wdDoNotSaveChanges;
  OriginalFormat := unAssigned;
  RouteDocument := unAssigned;
  app.Quit(SaveChanges, OriginalFormat, RouteDocument);
  inherited destroy;
end;

//------------------------------------------------------------------

function TWinWord.fGetVisible: boolean;
begin

  result := App.Visible;
end;

//------------------------------------------------------------------

procedure TWinWord.fSetVisible(Visible: boolean);
begin

  App.visible := Visible;
end;

//------------------------------------------------------------------

procedure TWinWord.GotoBookmark(Bookmark: string);
var

  What: OLEVariant;
  Which: OLEVariant;
  Count: OLEVariant;
  Name: OLEVariant;
begin

  What := wdGoToBookmark;
  Which := unAssigned;
  Count := unAssigned;
  Name := Bookmark;
  App.Selection.GoTo_(What, Which, Count, Name);
end;

//------------------------------------------------------------------

procedure TWinWord.InsertText(Text: string);
begin

  App.Selection.TypeText(Text);
end;

//------------------------------------------------------------------

procedure TWinWord.NewDoc(Template: string);
var

  DocTemplate: OleVariant;
  NewTemplate: OleVariant;
begin

  DocTemplate := Template;
  NewTemplate := False;
  App.Documents.Add(DocTemplate, NewTemplate);
end;

//------------------------------------------------------------------

procedure TWinWord.MoveRight(Count: integer);
var

  MoveUnit: OleVariant;
  vCount: OleVariant;
  Extended: OleVariant;
begin

  MoveUnit := wdCell;
  vCount := Count;
  Extended := unassigned;
  app.selection.MoveRight(MoveUnit, vCount, Extended);
end;

//------------------------------------------------------------------

procedure TWinWord.Print;
begin

  OLEVariant(app).Printout;
end;

//------------------------------------------------------------------

procedure TWinWord.UpdateFields;
begin

  App.ActiveDocument.Fields.Update;
end;

//------------------------------------------------------------------

procedure TWinWord.SaveAs(Filename: string);
begin

  OLEVariant(App).ActiveDocument.SaveAs(FileName);
end;

//------------------------------------------------------------------

procedure TWinWord.RunMacro(MacroName: string);
begin

  App.Run(MacroName);
end;

//------------------------------------------------------------------

end.


