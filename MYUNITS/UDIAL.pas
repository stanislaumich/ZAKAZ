unit UDIAL;

interface
USES
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Psock, NMpop3, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdPOP3,idmessage, ustr,
  wininet, shellapi, ComCtrls;

 function IsConnectedToInternet: Boolean;
 procedure Dial(h:hwnd);
 procedure UnDial(h:hwnd);
 function FtpDownloadFile(striname,striuser,stripass,strHost, strUser, strPwd: string;
  Port: Integer; ftpDir, ftpFile, TargetFile: string; ProgressBar: TProgressBar;label1:tlabel): Boolean;


 var
  Inetname:string;
  inetUser:string;
  inetpass:string;
  dialcount:integer;

implementation

 function FtpDownloadFile(striname,striuser,stripass,strHost, strUser, strPwd: string;
  Port: Integer; ftpDir, ftpFile, TargetFile: string; ProgressBar: TProgressBar;Label1:tlabel): Boolean;

  function FmtFileSize(Size: Integer): string;
  begin 
    if Size >= $F4240 then 
      Result := Format('%.2f', [Size / $F4240]) + ' Mb' 
    else 
    if Size < 1000 then 
      Result := IntToStr(Size) + ' bytes' 
    else 
      Result := Format('%.2f', [Size / 1000]) + ' Kb'; 
  end; 

const 
  READ_BUFFERSIZE = 4096;  // or 256, 512, ... 
var 
  hNet, hFTP, hFile: HINTERNET; 
  buffer: array[0..READ_BUFFERSIZE - 1] of Char; 
  bufsize, dwBytesRead, fileSize: DWORD; 
  sRec: TWin32FindData; 
  strStatus: string; 
  LocalFile: file; 
  bSuccess: Boolean; 
begin 
  Result := False; 
  hNet := InternetOpen('RVC_CONNECT', // Agent
                        INTERNET_OPEN_TYPE_PRECONFIG, // AccessType
                        nil,  // ProxyName
                        nil, // ProxyBypass
                        0); // or INTERNET_FLAG_ASYNC / INTERNET_FLAG_OFFLINE
  if hNet = nil then
  begin
    ShowMessage('Невозможно подгрузить библиотеку WinInet.Dll');
    Exit;
  end;
  hFTP := InternetConnect(hNet, // Handle from InternetOpen
                          PChar(strHost), // FTP server
                          port, // (INTERNET_DEFAULT_FTP_PORT),
                          PChar(StrUser), // username
                          PChar(strPwd),  // password
                          INTERNET_SERVICE_FTP, // FTP, HTTP, or Gopher?
                          0, // flag: 0 or INTERNET_FLAG_PASSIVE
                          0);// User defined number for callback

  if hFTP = nil then 
  begin 
    InternetCloseHandle(hNet); 
    ShowMessage(Format('Host "%s" недоступен',[strHost])); 
    Exit; 
  end; 

  { Change directory }
  if ftpdir<>'' then
   begin
    bSuccess := FtpSetCurrentDirectory(hFTP, PChar(ftpDir));
    if not bSuccess then
    begin
      InternetCloseHandle(hFTP);
      InternetCloseHandle(hNet);
      ShowMessage(Format('Невозможно выбрать папку %s.',[ftpDir]));
      Exit;
    end;
   end;
   
  { Read size of file } 
  if FtpFindFirstFile(hFTP, PChar(ftpFile), sRec, 0, 0) <> nil then 
  begin 
    fileSize := sRec.nFileSizeLow; 
    //fileLastWritetime := sRec.lastWriteTime
  end else 
  begin 
    InternetCloseHandle(hFTP); 
    InternetCloseHandle(hNet); 
    ShowMessage(Format('Невозможно найти файл ',[ftpFile])); 
    Exit; 
  end; 

  { Open the file } 
  hFile := FtpOpenFile(hFTP, // Handle to the ftp session 
                       PChar(ftpFile), // filename 
                       GENERIC_READ, // dwAccess 
                       FTP_TRANSFER_TYPE_BINARY, // dwFlags 
                       0); // This is the context used for callbacks. 

  if hFile = nil then 
  begin 
    InternetCloseHandle(hFTP); 
    InternetCloseHandle(hNet); 
    Exit; 
  end; 

  { Create a new local file } 
  AssignFile(LocalFile, TargetFile); 
  {$i-} 
  Rewrite(LocalFile, 1); 
  {$i+} 

  if IOResult <> 0 then 
  begin 
    InternetCloseHandle(hFile); 
    InternetCloseHandle(hFTP); 
    InternetCloseHandle(hNet);
    //Messagebox(); 
    Exit; 
  end; 

  dwBytesRead := 0; 
  bufsize := READ_BUFFERSIZE; 

  while (bufsize > 0) do 
  begin 
    Application.ProcessMessages; 

    if not InternetReadFile(hFile, 
                            @buffer, // address of a buffer that receives the data 
                            READ_BUFFERSIZE, // number of bytes to read from the file 
                            bufsize) then Break; // receives the actual number of bytes read 

    if (bufsize > 0) and (bufsize <= READ_BUFFERSIZE) then 
      BlockWrite(LocalFile, buffer, bufsize); 
    dwBytesRead := dwBytesRead + bufsize; 

    { Show Progress } 
    ProgressBar.Position := Round(dwBytesRead * 100 / fileSize); 
    Label1.Caption := Format('%s из %s / %d %%',[FmtFileSize(dwBytesRead),FmtFileSize(fileSize) ,ProgressBar.Position]);
  end;

  CloseFile(LocalFile); 

  InternetCloseHandle(hFile); 
  InternetCloseHandle(hFTP); 
  InternetCloseHandle(hNet); 
  Result := True; 
end;

 function IsConnectedToInternet: Boolean;
 var
   dwConnectionTypes: Cardinal;
 begin
   dwConnectionTypes :=
     INTERNET_CONNECTION_MODEM +
     INTERNET_CONNECTION_LAN +
     INTERNET_CONNECTION_PROXY;
   Result := InternetGetConnectedState(@dwConnectionTypes, 0);
 end;

procedure Dial(h:hwnd);
var  
  cmd, par, fil, dir: PChar;
   si: Tstartupinfo;
   p: Tprocessinformation;
begin
  FillChar( Si, SizeOf( Si ) , 0 );
with Si do
 begin
  cb := SizeOf( Si);
  dwFlags := startf_UseShowWindow;
  wShowWindow := 4;
 end;
 Createprocess(nil, pCHAR('rasdial.exe '+ INETUSER+' '+INETPASS+' '+INETNAME), nil, nil,
 false, Create_default_error_mode, nil, nil, si, p);
 Waitforsingleobject(p.hProcess, infinite);
  {cmd := 'open';
  fil := 'rasdial.exe';
  par := PChar('internet ' + ' ' + 'User' + ' ' + 'Pass');
  dir := 'C:';
  ShellExecute(h, cmd, fil, par, dir, SW_SHOWMINNOACTIVE);}
end;

procedure UnDial(h:hwnd);
var
  cmd, par, fil, dir: PChar;
     si: Tstartupinfo;
   p: Tprocessinformation;
begin
  FillChar( Si, SizeOf( Si ) , 0 );
with Si do
 begin
  cb := SizeOf( Si);
  dwFlags := startf_UseShowWindow;
  wShowWindow := 4;
 end;
 Createprocess(nil, pCHAR('rasdial.exe '+ ' '+INETNAME+' /DISCONNECT'), nil, nil,
 false, Create_default_error_mode, nil, nil, si, p);
 Waitforsingleobject(p.hProcess, infinite);
  {cmd := 'open';
  fil := 'rasdial.exe'; 
  par := PChar('internet' + ' /DISCONNECT');
  dir := 'C:'; 
  ShellExecute(h, cmd, fil, par, dir, SW_SHOWMINNOACTIVE);}
end;


end.
