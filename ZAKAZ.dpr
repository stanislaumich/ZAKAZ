program ZAKAZ;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1} ,
  UDM in 'UDM.pas' {DM: TDataModule} ,
  myinifiles in 'myinifiles.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDM, DM);
  Application.Run;

end.
