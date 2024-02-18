unit AboutF;

interface

uses
  Windows, SysUtils, Graphics, Controls, Forms, StdCtrls, ExtCtrls;

procedure ShowAbout;

implementation

procedure ShowAbout;
var
  About: TForm;
  S, TS: string;
  h, sz, Len: DWORD;
  Buf: PChar;
  Value: Pointer;
  LabelLeft, i: Integer;
begin
  S := Application.ExeName;
  sz := GetFileVersionInfoSize(PChar(S), h);
  if sz > 0 then
  begin
    Buf := AllocMem(sz);
    GetFileVersionInfo(PChar(S), h, sz, Buf);
    VerQueryValue(Buf, '\VarFileInfo\Translation', Value, Len);
    TS := IntToHex(MakeLong(HiWord(Longint(Value^)), LoWord(Longint(Value^))), 8);
    About := TForm.Create(Application);
    with About do
    try
      Caption := 'О программе: ' + Application.Title;
      Position := poScreenCenter;
      BorderStyle := bsDialog;
      with TImage.Create(Application) do
      begin
        Picture.Icon := Application.Icon;
        Left := 10;
        Top := 10;
        Parent := About;
        AutoSize := True;
        LabelLeft := Left + Width + 10;
      end;
      VerQueryValue(Buf, PChar('StringFileInfo\' + TS + '\ProductName'), Pointer(Value), Len);
      if Len > 1 then
        with TLabel.Create(Application) do
        begin
          Left := LabelLeft;
          Top := About.Controls[About.ControlCount - 1].Top;
          Font.Size := 10;
          Font.Style := [fsBold];
          Font.Color := clNavy;
          Parent := About;
          Caption := StrPas(PChar(Value));
        end;
      VerQueryValue(Buf, PChar('StringFileInfo\' + TS + '\FileVersion'), Pointer(Value), Len);
      if Len > 1 then
        with TLabel.Create(Application) do
        begin
          Left := LabelLeft;
          Top := About.Controls[About.ControlCount - 1].Top + About.Controls[About.ControlCount - 1].Height + 5;
          Caption := 'Версия: ' + StrPas(PChar(Value));
          Parent := About;
        end;
      VerQueryValue(Buf, PChar('StringFileInfo\' + TS + '\CompanyName'), Pointer(Value), Len);
      if Len > 1 then
        with TLabel.Create(Application) do
        begin
          Left := LabelLeft;
          Top := About.Controls[About.ControlCount - 1].Top + About.Controls[About.ControlCount - 1].Height + 5;
          Caption := 'Компания: ' + StrPas(PChar(Value));
          Parent := About;
        end;
      VerQueryValue(Buf, PChar('StringFileInfo\' + TS + '\Author'), Pointer(Value), Len);
      if Len > 1 then
        with TLabel.Create(Application) do
        begin
          Left := LabelLeft;
          Top := About.Controls[About.ControlCount - 1].Top + About.Controls[About.ControlCount - 1].Height + 5;
          Caption := 'Автор: ' + StrPas(PChar(Value));
          Parent := About;
        end;
      Height := Controls[ControlCount - 1].Top + Controls[ControlCount - 1].Height + 85;
      Width := 10;
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TLabel then
          if Controls[i].Left + Controls[i].Width + 20 > Width then
            Width := Controls[i].Left + Controls[i].Width + 20;
      with TButton.Create(Application) do
      begin
        Caption := 'Ok';
        Left := Trunc((About.Width / 2) - (Width / 2));
        Top := Trunc(About.Height - 60);
        ModalResult := mrOk;
        Cursor := crHandPoint;
        Parent := About;
      end;
      with TBevel.Create(Application) do
      begin
        Shape := bsTopLine;
        Style := bsRaised;
        Align := alBottom;
        Parent := About;
        Height := About.Controls[About.ControlCount - 1].Height + 20;
      end;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.